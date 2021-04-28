using DarkRift;
using DarkRift.Client.Unity;
using DarkRift.Server;
using Sirenix.OdinInspector;
using System;
using UnityEngine;

public class NetworkedObject : MonoBehaviour
{
    [Tooltip("Sync Position")]
    [BoxGroup("Networked")] public bool isNetworked = true;
    [ShowIf("isNetworked")] [BoxGroup("Networked")] public bool synchronisePosition = true;
    [ShowIf("isNetworked")] [BoxGroup("Networked")] public bool synchroniseRotation = false;
    [ShowIf("isNetworked")] [BoxGroup("Networked")] public float interpolateSpeed = 30;
    [InfoBox("Attention, mal géré, ces valeurs peuvent entrainer de lourd problème de connexion", InfoMessageType.Warning)]
    [ShowIf("isNetworked")] [BoxGroup("Networked")] public float distanceRequiredBeforeSync = 0.1f;
    [ShowIf("isNetworked")] [BoxGroup("Networked")] public float rotationRequiredBeforeSync = 6;

    private ushort objListKey = 0;
    private ushort serverObjectID = 0; // ID donné par le serveur pour cette object (utilisé pour referer le meme object pour tout le monde dans la scene) | 0 si il n'est pas instancié
    private bool isOwner = false;
    private PlayerData owner;
    private UnityClient ownerIClient; // Set uniquement par le créateur
    private Vector3 lastPosition; // Set uniquement par le créateur
    private float lastYRotation; // Set uniquement par le créateur

    public Action OnSpawnObj;

    Vector3 newNetorkPos;

    public void Init(ushort lastObjId, PlayerData playerData, ushort objKey, Vector3 pos)
    {
        // Vérifie les droits lié à cette objets
        transform.position = pos;
        newNetorkPos = transform.position;

        serverObjectID = lastObjId;
        owner = playerData;
        lastPosition = transform.position;
        lastYRotation = transform.rotation.eulerAngles.y;
        objListKey = objKey;

        if (NetworkManager.Instance.GetLocalPlayer() == owner)
        {
            ownerIClient = RoomManager.Instance.client;
            isOwner = true;
        }

        OnSpawnObj?.Invoke();
    }
    private void OnDisable()
    {
        // RESET VALUES BECAUSE OF POOLING
        owner = null;
        isOwner = false;
        ownerIClient = null;
        serverObjectID = 0;
        objListKey = 0;
        lastPosition = Vector3.zero;
        lastYRotation = 0;
    }
    
    public bool GetIsOwner()
    {
        return isOwner;
    }

    /// <summary>
    /// Get server unique ID
    /// </summary>
    /// <returns></returns>
    public ushort GetItemID()
    {
        return serverObjectID;
    }
    public ushort GetObjInstantiateID()
    {
        return objListKey;
    }
    public ushort GetOwnerID()
    {
        return owner.ID;
    }

    public PlayerData GetOwner()
    {
        return owner;
    }

    private void Update()
    {
        if (!isOwner && isNetworked)
        {
            transform.position = Vector3.Lerp(transform.position, newNetorkPos, Time.deltaTime * interpolateSpeed);
        }

        if (!isNetworked || !isOwner || serverObjectID == 0)
            return;

        if ((Vector3.Distance(lastPosition, transform.position) > distanceRequiredBeforeSync) || (Mathf.Abs(lastYRotation - transform.rotation.eulerAngles.y) > rotationRequiredBeforeSync))
        {
            lastPosition = transform.position;
            lastYRotation = transform.rotation.eulerAngles.y;
            using (DarkRiftWriter writer = DarkRiftWriter.Create())
            {
                writer.Write(serverObjectID);

                writer.Write(synchronisePosition);

                if (synchronisePosition)
                {
                    writer.Write(this.transform.position.x);
                    writer.Write(this.transform.position.z);
                }

                writer.Write(synchroniseRotation);

                if (synchroniseRotation)
                {
                    writer.Write(this.transform.rotation.eulerAngles.y);
                }

                using (Message message = Message.Create(Tags.SynchroniseObject, writer))
                    ownerIClient.SendMessage(message, SendMode.Unreliable);
            }
        }
    }

    public void SetPosition(Vector3 pos)
    {
        if (!isOwner)
        {
            newNetorkPos = pos;
        }
    }

    public void Activate()
    {
        isNetworked = true;
    }

    public void Desactivate()
    {
        isNetworked = false;
    }

}

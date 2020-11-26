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
    [ShowIf("isNetworked")] [BoxGroup("Networked")] public float interpolateSpeed = 10;
    [ShowIf("isNetworked")] [BoxGroup("Networked")] public float distanceRequiredBeforeSync = 0.02f;

    private ushort objListKey = 0;
    private ushort serverObjectID = 0; // ID donné par le serveur pour cette object (utilisé pour referer le meme object pour tout le monde dans la scene) | 0 si il n'est pas instancié
    private bool isOwner = false;
    private PlayerData owner;
    private UnityClient ownerIClient; // Set uniquement par le créateur
    private Vector3 lastPosition; // Set uniquement par le créateur

    public Action OnSpawnObj;

    public void Init(ushort lastObjId, PlayerData playerData, ushort objKey)
    {
        // Vérifie les droits lié à cette objets

        serverObjectID = lastObjId;
        owner = playerData;
        lastPosition = transform.position;
        objListKey = objKey;

        if (RoomManager.Instance.GetLocalPlayer() == owner)
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
        if (!isNetworked || !isOwner || serverObjectID == 0 )
            return;

        if (Vector3.Distance(lastPosition, transform.position) > distanceRequiredBeforeSync)
        {
            lastPosition = transform.position;

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
                    writer.Write(this.transform.rotation.eulerAngles.x);
                    writer.Write(this.transform.rotation.eulerAngles.y);
                    writer.Write(this.transform.rotation.eulerAngles.z);
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
            transform.position = pos;
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

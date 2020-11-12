using DarkRift;
using DarkRift.Client.Unity;
using DarkRift.Server;
using UnityEngine;

public class NetworkedObject : MonoBehaviour
{
    public bool isNetworked = true;
    public bool synchroniseRotation = true;
    public float distanceRequiredBeforeSync = 0.02f;

    private ushort serverObjectID = 0; // ID donné par le serveur pour cette object (utilisé pour referer le meme object pour tout le monde dans la scene) | 0 si il n'est pas instancié
    private bool isOwner = false;
    private PlayerData owner;
    private UnityClient ownerIClient; // Set uniquement par le créateur
    private Vector3 lastPosition; // Set uniquement par le créateur

    public void Init(ushort lastObjId, PlayerData playerData)
    {
        // Vérifie les droits lié à cette objets

        serverObjectID = lastObjId;
        owner = playerData;
        lastPosition = transform.position;

        if (RoomManager.Instance.GetLocalPlayer() == owner)
        {
            ownerIClient = RoomManager.Instance.client;
            isOwner = true;
        }
    }
    private void OnDisable()
    {
        // RESET VALUES BECAUSE OF POOLING
        owner = null;
        isOwner = false;
        ownerIClient = null;
        serverObjectID = 0;
        lastPosition = Vector3.zero;
    }
    
    public bool GetIsOwner()
    {
        return isOwner;
    }

    public ushort GetItemID()
    {
        return serverObjectID;
    }
    public ushort GetOwnerID()
    {
        return owner.ID;
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

                writer.Write(this.transform.position.x);
                writer.Write(this.transform.position.y);
                writer.Write(this.transform.position.z);

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

    public void Activate()
    {
        isNetworked = true;
    }

    public void Desactivate()
    {
        isNetworked = false;
    }


}

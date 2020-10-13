using DarkRift;
using DarkRift.Client.Unity;
using DarkRift.Server;
using UnityEngine;

public class NetworkedObject : MonoBehaviour
{
    public PlayerData owner;
    public bool synchroniseRotation = true;

    public ushort networkedObjectID = 0; // ID dans le scriptable (utilisé pour l'instantiation)
    public ushort serverObjectID = 0; // ID donné par le serveur pour cette object (utilisé pour referer le meme object pour tout le monde dans la scene) | 0 si il n'est pas instancié
    public float distanceRequiredBeforeSync = 0.02f;
    private Vector3 lastPosition;
    private bool isNetworked = true;

    public bool isOwner = false;
    private UnityClient ownerIClient;

    public void Init(ushort lastObjId, PlayerData playerData)
    {
        // Vérifie les droits lié à cette objets

        serverObjectID = lastObjId;
        owner = playerData;

        if (RoomManager.Instance.GetLocalPlayer() == owner)
        {
            ownerIClient = RoomManager.Instance.client;
            isOwner = true;
        }
    }


    private void Update()
    {
        if (!isNetworked || !isOwner || serverObjectID == 0)
            return;

        if (Vector3.Distance(lastPosition, transform.position) > distanceRequiredBeforeSync)
        {
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

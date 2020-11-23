using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class NetworkObjectsManager : SerializedMonoBehaviour
{
    private static NetworkObjectsManager _instance;
    public static NetworkObjectsManager Instance { get { return _instance; } }

    [SerializeField] public Sc_NetworkedObjects networkedObjectsList;
    [Header("Instantiated Object")]
    public Dictionary<ushort, NetworkedObject> instantiatedObjectsList = new Dictionary<ushort, NetworkedObject>();

    public GameObject poolRootObj;

    private UnityClient client;
    public List<KeyGameObjectPair> poolParents = new List<KeyGameObjectPair>();
    [ReadOnly] public GameObject lastGOInstantiate;

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }

        if (RoomManager.Instance == null)
        {
            Debug.LogError("NO ROOM MANAGER");
            return;
        }

        client = RoomManager.Instance.client;

        client.MessageReceived += MessageReceived;

    }

    private void Start()
    {
        InitPooling();
    }
    private void OnDisable()
    {
        client.MessageReceived -= MessageReceived;
    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        if (RoomManager.Instance == null)
        {
            Debug.LogError("NO ROOM MANAGER");
            return;
        }

        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.InstantiateObject)
            {
                InstantiateInServer(sender, e);
            }

            if (message.Tag == Tags.SynchroniseObject)
            {
                SynchroniseObject(sender, e);
            }
            if (message.Tag == Tags.DestroyObject)
            {
                DestroyNetworkedObjectInServer(sender, e);
            }
        }
    }

    private void InitPooling()
    {
        foreach (KeyGameObjectPair item in networkedObjectsList.networkObjects)
        {
            GameObject parent = new GameObject("POOL_" + item.gameObject.name);
            parent.transform.SetParent(poolRootObj.transform);

            KeyGameObjectPair newPair = new KeyGameObjectPair();
            newPair.gameObject = parent;
            newPair.Key = item.Key;
            poolParents.Add(newPair);

            for (int i = 0; i < item.poolCount; i++)
            {
                GameObject newobj = Instantiate(item.gameObject, parent.transform);
                newobj.SetActive(false);
            }
        }
    }

    private GameObject GetFirstDisabledObject(int objectID)
    {
        KeyGameObjectPair _parent = poolParents.Where(x => x.Key == objectID).First();

        foreach (Transform t in _parent.gameObject.transform)
        {
            if (!t.gameObject.activeInHierarchy)
            {
                return t.gameObject;
            }
        }

        KeyGameObjectPair _item = networkedObjectsList.networkObjects.Where(x => x.Key == objectID).First();

        GameObject newobj = Instantiate(_item.gameObject, _parent.gameObject.transform);
        newobj.SetActive(false);

        return newobj;
    }

    /// <summary>
    /// Use linq / Not efficient in Update
    /// </summary>
    /// <param name="networkedObjectID"></param>
    /// <param name="position"></param>
    /// <param name="eulerAngles"></param>
    public void NetworkInstantiate(ushort networkedObjectID, Vector3 position, Vector3 eulerAngles)
    {
        // Demande l'instantiation de l'objet pour tout les joueurs présent dans la room
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(RoomManager.Instance.GetLocalPlayer().ID);
            writer.Write(networkedObjectID);

            writer.Write(position.x);
            writer.Write(position.y);
            writer.Write(position.z);

            writer.Write(eulerAngles.x);
            writer.Write(eulerAngles.y);
            writer.Write(eulerAngles.z);

            using (Message message = Message.Create(Tags.InstantiateObject, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void InstantiateInServer(object sender, MessageReceivedEventArgs e)
    {
        ushort _ownerID;
        ushort _objectID;
        ushort _lastObjId;
        Vector3 _ObjectPos = new Vector3(0, 0, 0);
        Vector3 _ObjectRotation = new Vector3(0, 0, 0);

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                _ownerID = reader.ReadUInt16();
                _objectID = reader.ReadUInt16();

                _ObjectPos.x = reader.ReadSingle();
                _ObjectPos.y = reader.ReadSingle();
                _ObjectPos.z = reader.ReadSingle();

                _ObjectRotation.x = reader.ReadSingle();
                _ObjectRotation.y = reader.ReadSingle();
                _ObjectRotation.z = reader.ReadSingle();


                _lastObjId = reader.ReadUInt16();
            }
        }

        GameObject _tempObject = GetFirstDisabledObject(_objectID);
        _tempObject.transform.position = _ObjectPos;
        _tempObject.transform.rotation = Quaternion.Euler(_ObjectRotation);
        NetworkedObject networkedObject = _tempObject.GetComponent<NetworkedObject>();
        networkedObject.Init(_lastObjId, RoomManager.Instance.actualRoom.playerList[_ownerID], _objectID);
        NetworkedObjectAdded(_lastObjId, networkedObject);
        _tempObject.SetActive(true);


        if (_tempObject.GetComponent<Projectile>() != null)
        {
            _tempObject.GetComponent<Projectile>().Init(RoomManager.Instance.GetPlayerData(_ownerID).playerTeam);
        }

        //GameObject _tempObject = Instantiate(networkedObjectsList.networkObjects.Where(x => x.Key == _objectID).FirstOrDefault().gameObject, _ObjectPos, Quaternion.Euler(_ObjectRotation));
        //NetworkedObject networkedObject = _tempObject.GetComponent<NetworkedObject>();
        //networkedObject.Init(_lastObjId, RoomManager.Instance.actualRoom.playerList[_ownerID]);
        //NetworkedObjectAdded(_lastObjId, networkedObject);
    }

    public void NetworkedObjectAdded(ushort lastObjId, NetworkedObject obj)
    {
        instantiatedObjectsList.Add(lastObjId, obj);
    }

    private void SynchroniseObject(object sender, MessageReceivedEventArgs e)
    {
        ushort _objectID;
        Vector3 _newObjectPos = new Vector3(0, 0, 0);

        bool _synchroniseRotation = true;
        Vector3 _newObjectRotation = new Vector3(0, 0, 0);

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                _objectID = reader.ReadUInt16();

                _newObjectPos.x = reader.ReadSingle();
                _newObjectPos.y = reader.ReadSingle();
                _newObjectPos.z = reader.ReadSingle();

                _synchroniseRotation = reader.ReadBoolean();

                if (_synchroniseRotation)
                {
                    _newObjectRotation.x = reader.ReadSingle();
                    _newObjectRotation.y = reader.ReadSingle();
                    _newObjectRotation.z = reader.ReadSingle();
                }
            }
        }

        if (!instantiatedObjectsList.ContainsKey(_objectID))
            return;

        if (_synchroniseRotation)
        {
            instantiatedObjectsList[_objectID].transform.rotation = Quaternion.Euler(_newObjectRotation);
        }

    }

    public void DestroyNetworkedObject(ushort networkedObjectID, bool bypassOwner = false)
    {
        // Demande l'instantiation de l'objet pour tout les joueurs présent dans la room

        if (!instantiatedObjectsList[networkedObjectID].GetIsOwner() && !bypassOwner)
        {
            Debug.LogError("YOU HAVE TO BE OWNER");
            return;
        }

        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(networkedObjectID);

            using (Message message = Message.Create(Tags.DestroyObject, writer))
                client.SendMessage(message, SendMode.Reliable);
        }
    }

    private void DestroyNetworkedObjectInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort objID = reader.ReadUInt16();

                if (instantiatedObjectsList.ContainsKey(objID))
                {
                    instantiatedObjectsList[objID].gameObject.SetActive(false);
                    instantiatedObjectsList.Remove(objID);
                }


            }
        }
    }

}

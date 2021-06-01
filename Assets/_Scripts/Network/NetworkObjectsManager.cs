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

    private ushort lastNetworkedObjId = 0;

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
            if (message.Tag == Tags.InstantiateAutoKillObject)
            {
                InstantiateInServer(sender, e, true);
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



    public ushort GenerateUniqueObjID()
    {
        int _temp = 0;
        lastNetworkedObjId++;
        _temp = (lastNetworkedObjId * 10) + RoomManager.Instance.GetLocalPlayerUniqueID();

        return (ushort)_temp;
    }


    public GameObject LocalInstantiate(ushort networkedObjectID, Vector3 position, Vector3 eulerAngles)
    {
        GameObject _tempObject = GetFirstDisabledObject(networkedObjectID);

        _tempObject.transform.position = position;
        _tempObject.transform.rotation = Quaternion.Euler(eulerAngles);
        _tempObject.SetActive(true);

        return _tempObject;
    }

    public GameObject LocalInstantiate(GameObject Object, Vector3 position, Vector3 eulerAngles)
    {
        GameObject _tempObject = GetFirstDisabledObject(GetPoolID(Object));

        _tempObject.transform.position = position;
        _tempObject.transform.rotation = Quaternion.Euler(eulerAngles);
        _tempObject.SetActive(true);

        return _tempObject;
    }

    /// <summary>
    /// Moins opti que la version ID
    /// </summary>
    public GameObject NetworkInstantiate(GameObject networkedObject, Vector3 position, Vector3? eulerAngles = null)
    {
        return NetworkInstantiate(GetPoolID(networkedObject), position, eulerAngles);
    }


    /// <summary>s
    /// Use linq / Not efficient in Update
    /// </summary>
    /// <param name="networkedObjectID"></param>
    /// <param name="position"></param>
    /// <param name="eulerAngles">SET IN ANGLES</param>
    public GameObject NetworkInstantiate(ushort networkedObjectID, Vector3 position, Vector3? eulerAngles = null)
    {
        GameObject _tempObject = GetFirstDisabledObject(networkedObjectID);
        Vector3 angles = Vector3.zero;

        if (eulerAngles == null)
        {
            angles = _tempObject.transform.rotation.eulerAngles;
        } else
        {
            angles = (Vector3)eulerAngles;
        }

        ushort uniqueObjId = GenerateUniqueObjID();

        _tempObject.transform.position = position;
        _tempObject.transform.rotation = Quaternion.Euler(angles);
        NetworkedObject networkedObject = _tempObject.GetComponent<NetworkedObject>();
        networkedObject.Init(uniqueObjId, NetworkManager.Instance.GetLocalPlayer(), networkedObjectID, position);
        NetworkedObjectAdded(uniqueObjId, networkedObject);

        AutoKill _autoKill = _tempObject.GetComponent<AutoKill>();

        if (_autoKill != null)
            _autoKill.Init(GameManager.Instance.networkPlayers[GameManager.Instance.currentLocalPlayer.myPlayerId].myPlayerModule.teamIndex);

        _tempObject.SetActive(true);

        // Demande l'instantiation de l'objet pour tout les joueurs présent dans la room

        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(NetworkManager.Instance.GetLocalPlayer().ID);
            writer.Write(networkedObjectID);
            writer.Write(uniqueObjId);

            writer.Write(position.x);
            writer.Write(position.z);

            writer.Write(angles.x);
            writer.Write(angles.y);
            writer.Write(angles.z);

            using (Message message = Message.Create(Tags.InstantiateObject, writer))
                client.SendMessage(message, SendMode.Reliable);
        }


        return _tempObject;
    }

    /// <summary>
    /// Use linq / Not efficient in Update
    /// </summary>
    /// <param name="networkedObjectID"></param>
    /// <param name="position"></param>
    /// <param name="eulerAngles"></param>
    public GameObject NetworkAutoKillInstantiate(ushort networkedObjectID, Vector3 position, Vector3 eulerAngles, float _percentageOfLifeTime = 1)
    {
        GameObject _tempObject = GetFirstDisabledObject(networkedObjectID);

        ushort uniqueObjId = GenerateUniqueObjID();

        _tempObject.transform.position = position;
        _tempObject.transform.rotation = Quaternion.Euler(eulerAngles);
        NetworkedObject networkedObject = _tempObject.GetComponent<NetworkedObject>();
        networkedObject.Init(uniqueObjId, NetworkManager.Instance.GetLocalPlayer(), networkedObjectID, position);
        NetworkedObjectAdded(uniqueObjId, networkedObject);
        _tempObject.SetActive(true);

        if (_tempObject.GetComponent<AutoKill>() != null)
        {
            _tempObject.GetComponent<AutoKill>().Init(NetworkManager.Instance.GetLocalPlayer().playerTeam, 1);
            //TODO: ICI
        }


        // Demande l'instantiation de l'objet pour tout les joueurs présent dans la room

        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write(NetworkManager.Instance.GetLocalPlayer().ID);
            writer.Write(networkedObjectID);
            writer.Write(uniqueObjId);

            writer.Write(position.x);
            writer.Write(position.z);

            writer.Write(eulerAngles.x);
            writer.Write(eulerAngles.y);
            writer.Write(eulerAngles.z);
            writer.Write(_percentageOfLifeTime);

            using (Message message = Message.Create(Tags.InstantiateObject, writer))
                client.SendMessage(message, SendMode.Reliable);
        }


        return _tempObject;
    }


    private void InstantiateInServer(object sender, MessageReceivedEventArgs e, bool autokill = false)
    {
        ushort _ownerID;
        ushort _objectID;
        ushort _uniqueObjId;
        Vector3 _ObjectPos = new Vector3(0, 0, 0);
        Vector3 _ObjectRotation = new Vector3(0, 0, 0);
        float _LifePercentage = 1;

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                _ownerID = reader.ReadUInt16();
                _objectID = reader.ReadUInt16();
                _uniqueObjId = reader.ReadUInt16();

                _ObjectPos.x = reader.ReadSingle();
                _ObjectPos.z = reader.ReadSingle();

                _ObjectRotation.x = reader.ReadSingle();
                _ObjectRotation.y = reader.ReadSingle();
                _ObjectRotation.z = reader.ReadSingle();

                if (autokill)
                {
                    _LifePercentage = reader.ReadSingle();
                }
            }
        }

        GameObject _tempObject = GetFirstDisabledObject(_objectID);
        _tempObject.transform.position = _ObjectPos;
        _tempObject.transform.rotation = Quaternion.Euler(_ObjectRotation);
        NetworkedObject networkedObject = _tempObject.GetComponent<NetworkedObject>();
        networkedObject.Init(_uniqueObjId, RoomManager.Instance.actualRoom.playerList[_ownerID], _objectID, _ObjectPos);
        NetworkedObjectAdded(_uniqueObjId, networkedObject);

        AutoKill _autoKill = _tempObject.GetComponent<AutoKill>();

        if (_autoKill != null)
        {
             _autoKill.Init(RoomManager.Instance.GetPlayerData(_ownerID).playerTeam);
        }


        _tempObject.SetActive(true);
    }

    public void NetworkedObjectAdded(ushort lastObjId, NetworkedObject obj)
    {
        instantiatedObjectsList.Add(lastObjId, obj);
    }

    private void SynchroniseObject(object sender, MessageReceivedEventArgs e)
    {
        ushort _objectID;
        Vector3 _newObjectPos = new Vector3(0, 0, 0);

        bool _synchronisePosition = true;
        bool _synchroniseRotation = true;
        Vector3 _newObjectRotation = new Vector3(0, 0, 0);

        using (Message message = e.GetMessage() as Message)
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                _objectID = reader.ReadUInt16();

                _synchronisePosition = reader.ReadBoolean();

                if (_synchroniseRotation)
                {
                    _newObjectPos.x = reader.ReadSingle();
                    _newObjectPos.z = reader.ReadSingle();
                }
                _synchroniseRotation = reader.ReadBoolean();

                if (_synchroniseRotation)
                {
                    _newObjectRotation.y = reader.ReadSingle();
                }
            }
        }

        if (!instantiatedObjectsList.ContainsKey(_objectID))
            return;


        if (_synchronisePosition)
        {
            instantiatedObjectsList[_objectID].SetPosition(_newObjectPos);
        }
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

    /// <summary>
    /// Not efficient / Do not use this in Update
    /// </summary>
    /// <param name="obj"> </param>
    /// <returns></returns>
    public ushort GetPoolID(GameObject obj)
    {
        foreach (KeyGameObjectPair pair in networkedObjectsList.networkObjects)
        {
            if (obj == pair.gameObject)
            {
                return pair.Key;
            }
        }
        return 0;
    }
}

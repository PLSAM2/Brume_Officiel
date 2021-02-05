﻿using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class AudioManager : SerializedMonoBehaviour
{
    private static AudioManager _instance;
    public static AudioManager Instance { get { return _instance; } }

    [SerializeField] GameObject prefabAudioSource;

    Dictionary<AudioElement, bool> allAudioElement = new Dictionary<AudioElement, bool>(); // true = utilisé // false = libre

    public float currentPlayerVolume = 1;

    public Action<float> OnVolumeChange;

    public Action<Vector3> OnAudioPlay;

    [SerializeField] AudioSource backGroundMusic;

    public List<AudioClip> networkAudio = new List<AudioClip>();

    UnityClient client;

    public AudioClip spotSound, cooldownUpSound;

    bool init = false;
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
        DontDestroyOnLoad(this);

        if (PlayerPrefs.HasKey("Volume"))
        {
            currentPlayerVolume = PlayerPrefs.GetFloat("Volume");
        }

        OnMasterVolumeChange(currentPlayerVolume);
        client = NetworkManager.Instance.GetLocalClient();

        client.MessageReceived += OnMessageReceive;
        init = true;
    }

    private void OnEnable()
    {

        OnVolumeChange += OnMasterVolumeChange;

    }

    private void OnDisable()
    {
        if (init == true)
        {
            OnVolumeChange -= OnMasterVolumeChange;

            client.MessageReceived -= OnMessageReceive;
        }

    }

    void OnMasterVolumeChange(float _value)
    {
        backGroundMusic.volume = _value / 2;
    }

    private void OnMessageReceive(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {

            if (message.Tag == Tags.Play2DSound)
            {
                OnReceive2DSound(sender, e);
            }
            else if (message.Tag == Tags.Play3DSound)
            {
                OnReceive3DSound(sender, e);
            }
        }
    }

    void OnReceive2DSound(object _sender, MessageReceivedEventArgs _e)
    {
        using (Message message = _e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _id = reader.ReadUInt16();
                Play2DAudio(networkAudio[_id]);
            }
        }
    }

    void OnReceive3DSound(object _sender, MessageReceivedEventArgs _e)
    {
        using (Message message = _e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _idSound = reader.ReadUInt16();

                float _posX = reader.ReadSingle();
                float _posY = reader.ReadSingle();
                float _posZ = reader.ReadSingle();

                ushort _idObj = reader.ReadUInt16();
                bool _isPlayer= reader.ReadBoolean();

                Play3DAudio(networkAudio[_idSound], new Vector3(_posX, _posY, _posZ), _idObj, _isPlayer);
            }
        }
    }

    public AudioElement Play2DAudio(AudioClip _clip, float _volume = 1)
    {
        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.Init(_clip, 0, _volume);

        return _myAudioElement;
    }

    public void Play3DAudioInNetwork(AudioClip _clip, Vector3 _position, ushort id, bool isPlayer = false)
    {
        if(_clip == null) { return; }
        ushort _id = GetIndexOfList(_clip);
        if (_id == 0) { return; }

        Play3DAudio(networkAudio[_id], _position, id, isPlayer);

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(_id);

            _writer.Write(_position.x);
            _writer.Write(_position.y);
            _writer.Write(_position.z);

            _writer.Write(id);
            _writer.Write(isPlayer);

            using (Message _message = Message.Create(Tags.Play3DSound, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    ushort GetIndexOfList(AudioClip _clip)
    {
        int i = 0;
        foreach(AudioClip clip in networkAudio)
        {
            if(clip == _clip)
            {
                return (ushort) i;
            }
            i++;
        }

        print("<color=red>" + _clip.name + " est pas dans le manager audio </color>");
        return 0;
    }

    public void Play2DAudioInNetwork(ushort _id)
    {
        Play2DAudio(networkAudio[_id]);

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(_id);
            using (Message _message = Message.Create(Tags.Play2DSound, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    public AudioElement Play3DAudio(AudioClip _clip, Vector3 _position, ushort id, bool isPlayer, float _volume = 1)
    {
        if (!GameFactory.DoSound(_position)) { return null; }

        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.SetPosition(_position);
        _myAudioElement.Init(_clip, 1, _volume);
        OnAudioPlayed(_position, id, isPlayer, _myAudioElement._myAudioSource.maxDistance);
        return _myAudioElement;
    }

    public AudioElement Play3DAudio(AudioClip _clip, Transform _followObj, ushort id, bool isPlayer, float _volume = 1)
    {
        if (!!GameFactory.DoSound(_followObj.position)) { return null; }

        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.SetObjToFollow(_followObj);
        _myAudioElement.Init(_clip, 1, _volume);
        OnAudioPlayed(_followObj.position, id, isPlayer, _myAudioElement._myAudioSource.maxDistance);

        return _myAudioElement;
    }

    public void OnAudioFinish(AudioElement _audio)
    {
        allAudioElement[_audio] = false;
    }

    public void OnAudioPlayed(Vector3 pos, ushort id, bool isPlayer, float audioDistance)
    {

        if (isPlayer)
        {
            if (GameManager.Instance.networkPlayers.ContainsKey(id))
            {
                if (GameManager.Instance.visiblePlayer.ContainsKey(GameManager.Instance.networkPlayers[id].transform) || 
                    id == NetworkManager.Instance.GetLocalPlayer().ID )
                {
                    return;
                }
            } else { return; }

        } else
        {
            if (NetworkObjectsManager.Instance.instantiatedObjectsList.ContainsKey(id))
            {
                NetworkedObject _no = NetworkObjectsManager.Instance.instantiatedObjectsList[id];

                if (_no.GetIsOwner())
                {
                    return;
                }
            } else { return; }

        }

        audioDistance = Mathf.Clamp(audioDistance - 2 , 0, float.MaxValue);

        if (GameFactory.GetLocalPlayerObj() != null)
        {
            if (Vector3.Distance(pos, GameFactory.GetLocalPlayerObj().transform.position) < audioDistance)
            {
                OnAudioPlay?.Invoke(pos);
            }
        }
    }

    AudioElement GetFreeAudioElement()
    {
        foreach(KeyValuePair<AudioElement, bool> element in allAudioElement)
        {
            if (!element.Value)
            {
                allAudioElement[element.Key] = true;
                element.Key.gameObject.SetActive(true);
                return element.Key;
            }
        }

        AudioElement newAudioElement = Instantiate(prefabAudioSource, transform).GetComponent<AudioElement>();
        allAudioElement.Add(newAudioElement, true);

        newAudioElement.gameObject.SetActive(true);
        return newAudioElement;
    }
}

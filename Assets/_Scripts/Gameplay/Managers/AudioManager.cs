using DarkRift;
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


    }

    private void OnEnable()
    {
        OnVolumeChange += OnMasterVolumeChange;
        client.MessageReceived += OnMessageReceive;
    }

    private void OnDisable()
    {
        OnVolumeChange -= OnMasterVolumeChange;
        client.MessageReceived -= OnMessageReceive;
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
                ushort _id = reader.ReadUInt16();

                float _posX = reader.ReadSingle();
                float _posY = reader.ReadSingle();
                float _posZ = reader.ReadSingle();

                Play3DAudio(networkAudio[_id], new Vector3(_posX, _posY, _posZ));
            }
        }
    }

    public AudioElement Play2DAudio(AudioClip _clip, float _volume = 1)
    {
        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.Init(_clip, 0, _volume);

        return _myAudioElement;
    }

    public void Play3DAudioInNetwork(AudioClip _clip, Vector3 _position)
    {
        if(_clip == null) { return; }
        ushort _id = GetIndexOfList(_clip);

        Play3DAudio(networkAudio[_id], _position);

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(_id);

            _writer.Write(_position.x);
            _writer.Write(_position.y);
            _writer.Write(_position.z);

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

        print("<color=red>Frero le son il existe pas le manager </color>");
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

    public AudioElement Play3DAudio(AudioClip _clip, Vector3 _position, float _volume = 1)
    {
        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.SetPosition(_position);
        _myAudioElement.Init(_clip, 1, _volume);
        OnAudioPlayed(_position, _myAudioElement);
        return _myAudioElement;
    }

    public AudioElement Play3DAudio(AudioClip _clip, Transform _followObj, float _volume = 1)
    {
        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.SetObjToFollow(_followObj);
        _myAudioElement.Init(_clip, 1, _volume);
        OnAudioPlayed(_followObj.position, _myAudioElement);

        return _myAudioElement;
    }

    public void OnAudioFinish(AudioElement _audio)
    {
        allAudioElement[_audio] = false;
    }

    public void OnAudioPlayed(Vector3 pos, AudioElement _myAudioElement)
    {
        if (Vector3.Distance(pos, GameFactory.GetLocalPlayerObj().transform.position) < _myAudioElement._myAudioSource.maxDistance )
        {
            OnAudioPlay?.Invoke(pos);
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

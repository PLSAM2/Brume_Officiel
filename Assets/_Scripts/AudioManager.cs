using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioManager : MonoBehaviour
{
    private static AudioManager _instance;
    public static AudioManager Instance { get { return _instance; } }

    [SerializeField] GameObject prefabAudioSource;

    Dictionary<AudioElement, bool> allAudioElement = new Dictionary<AudioElement, bool>(); // true = utilisé // false = libre

    public float currentPlayerVolume = 1;

    public Action<float> OnVolumeChange;

    [SerializeField] AudioSource backGroundMusic;

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

        backGroundMusic.volume = currentPlayerVolume;
    }

    private void OnEnable()
    {
        OnVolumeChange += OnMasterVolumeChange;
    }

    private void OnDisable()
    {
        OnVolumeChange -= OnMasterVolumeChange;
    }

    void OnMasterVolumeChange(float _value)
    {
        backGroundMusic.volume = _value;
    }

    public AudioElement Play2DAudio(AudioClip _clip, float _volume = 1)
    {
        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.Init(_clip, 0, _volume);

        return _myAudioElement;
    }

    public AudioElement Play3DAudio(AudioClip _clip, Vector3 _position, float _volume = 1)
    {
        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.SetPosition(_position);
        _myAudioElement.Init(_clip, 1, _volume);

        return _myAudioElement;
    }

    public AudioElement Play3DAudio(AudioClip _clip, Transform _followObj, float _volume = 1)
    {
        AudioElement _myAudioElement = GetFreeAudioElement();
        _myAudioElement.SetObjToFollow(_followObj);
        _myAudioElement.Init(_clip, 1, _volume);

        return _myAudioElement;
    }

    public void OnAudioFinish(AudioElement _audio)
    {
        allAudioElement[_audio] = false;
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

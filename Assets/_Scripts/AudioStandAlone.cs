using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioStandAlone : MonoBehaviour
{
    [SerializeField] AudioSource myAudioSource;

    private void Start()
    {
        if (myAudioSource == null)
        {
            myAudioSource = GetComponent<AudioSource>();
        }
        myAudioSource.volume = AudioManager.Instance.currentPlayerVolume;
    }

    private void OnEnable()
    {
        if(myAudioSource == null)
        {
            myAudioSource = GetComponent<AudioSource>();
            return;
        }

        myAudioSource.volume = AudioManager.Instance.currentPlayerVolume;

        AudioManager.Instance.OnVolumeChange += OnVolumeChange;
    }

    private void OnDisable()
    {
        AudioManager.Instance.OnVolumeChange -= OnVolumeChange;
    }

    void OnVolumeChange(float _volume)
    {
        myAudioSource.volume = AudioManager.Instance.currentPlayerVolume;
    }
}

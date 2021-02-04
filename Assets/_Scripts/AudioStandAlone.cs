using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioStandAlone : MonoBehaviour
{
    AudioSource myAudioSource;

    private void OnEnable()
    {
        if(myAudioSource == null)
        {
            myAudioSource = GetComponent<AudioSource>();
        }
        myAudioSource.volume = AudioManager.Instance.currentPlayerVolume;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayAudioInEnable : MonoBehaviour
{
    public AudioClip currentAudio;

    [SerializeField] bool inNetwork = false;

    private void OnEnable()
    {
        if (inNetwork)
        {
            AudioManager.Instance.Play3DAudioInNetwork(currentAudio, transform.position, 0, false);
        }
        else
        {
            AudioManager.Instance.Play3DAudio(currentAudio, transform.position, 0, false);
        }
    }
}

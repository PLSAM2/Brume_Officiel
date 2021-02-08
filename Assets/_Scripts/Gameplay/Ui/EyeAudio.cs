using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EyeAudio : MonoBehaviour
{
    [SerializeField] AudioSource audioSource;
    [SerializeField] LocalPlayer mylocalplayer; 

    private void OnEnable()
    {
        if (GameFactory.GetActualPlayerFollow() == mylocalplayer)
        {
            audioSource.Play();
        }
    }
}

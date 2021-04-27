using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioButton : MonoBehaviour
{
    public AudioClip hoverAudio;
    public AudioClip clickAudio;

    public void OnHover()
    {
        AudioManager.Instance.Play2DAudio(hoverAudio);
    }

    public void OnClick()
    {
        AudioManager.Instance.Play2DAudio(clickAudio);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioElement : MonoBehaviour
{
    AudioClip _myAudioClip;

    public AudioSource _myAudioSource;

    bool follow = false;
    Transform objFollowing;

    public void Init(AudioClip _clip, float _spacial = 1, float _volume = 1, bool autoStop = true) // 1 si volume de base
    {
        _myAudioSource.volume = _volume * AudioManager.Instance.currentPlayerVolume;
        _myAudioSource.spatialBlend = _spacial;

        _myAudioSource.clip = _clip;
        _myAudioClip = _clip;
        _myAudioSource.Play();

        if (autoStop)
        {
            StartCoroutine(WaitToDisable());
            _myAudioSource.loop = false;
        }
        else
        {
            _myAudioSource.loop = true;
        }
    }

    public void SetPosition(Vector3 _position)
    {
        transform.position = _position;
    }

    public void SetObjToFollow(Transform _obj)
    {
        follow = true;
        objFollowing = _obj;
    }

    private void Update()
    {
        if (follow && objFollowing != null)
        {
            SetPosition(objFollowing.position);
        }
    }

    public void StopSound()
    {
        gameObject.SetActive(false);
    }

    IEnumerator WaitToDisable()
    {
        yield return new WaitForSeconds(_myAudioClip.length);
        gameObject.SetActive(false);
    }

    private void OnDisable()
    {
        follow = false;
        objFollowing = null;
        AudioManager.Instance.OnAudioFinish(this);
    }
}

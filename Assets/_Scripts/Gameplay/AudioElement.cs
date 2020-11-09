﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioElement : MonoBehaviour
{
    AudioClip _myAudioClip;

    [SerializeField] AudioSource _myAudioSource;

    bool follow = false;
    Transform objFollowing;

    public void Init(AudioClip _clip, float _spacial = 1, float _volume = 1) // 1 si volume de base
    {
        _myAudioSource.volume = _volume * AudioManager.Instance.currentPlayerVolume;
        _myAudioSource.spatialBlend = _spacial;

        _myAudioSource.clip = _clip;
        _myAudioClip = _clip;
        _myAudioSource.Play();

        StartCoroutine(WaitToDisable());
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
        if (follow)
        {
            SetPosition(objFollowing.position);
        }
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

﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootstepAudio : MonoBehaviour
{
    [SerializeField] PlayerModule myPlayerModule;
    Vector3 oldPos;

    [SerializeField] AudioClip[] allFootsteps;

    [SerializeField] AudioSource myAudioSource;

    [SerializeField] float delayAfterSound = 0.2f;

    bool doSound = true;

    private void Start()
    {
        ChangeVolume(AudioManager.Instance.currentPlayerVolume);
    }

    private void OnEnable()
    {
        AudioManager.Instance.OnVolumeChange += ChangeVolume;
    }

    private void OnDisable()
    {
        AudioManager.Instance.OnVolumeChange -= ChangeVolume;
    }

    private void ChangeVolume(float _volume)
    {
        if(myPlayerModule.teamIndex == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            myAudioSource.volume = _volume / 5;
        }
        else
        {
            myAudioSource.volume = _volume;
        }
    }

    // Update is called once per frame
    void Update()
    {
        float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;
        oldPos = transform.position;

        if (!myPlayerModule.state.HasFlag(En_CharacterState.Crouched))
        {
            if ((velocityX + velocityZ) != 0 && doSound)
            {
                doSound = false;
                StartCoroutine(WaitEndSound(allFootsteps[Random.Range(0, allFootsteps.Length)]));
            }
        }
    }

    IEnumerator WaitEndSound(AudioClip _clip)
    {
        if (GameFactory.DoSound(transform.position)) {
            AudioManager.Instance.OnAudioPlayed(this.transform.position, myPlayerModule.mylocalPlayer.myPlayerId, true, myAudioSource.maxDistance);
            myAudioSource.PlayOneShot(_clip);
        }

        yield return new WaitForSeconds(_clip.length);

        yield return new WaitForSeconds(delayAfterSound);

        doSound = true;
    }
}

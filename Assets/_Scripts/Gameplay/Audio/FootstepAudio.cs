using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootstepAudio : MonoBehaviour
{
    [SerializeField] PlayerModule myPlayerModule;
    Vector3 oldPos;

    bool haveWaitDelay = true;

    bool crouchedStatut = false;

    [SerializeField] AudioClip[] allFootsteps;

    [SerializeField] AudioSource myAudioSource;

    [SerializeField] float delayToDoSound = 0.5f;

    [SerializeField] GameObject objMesh;
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
            myAudioSource.volume = _volume / 10;
        }
        else
        {
            myAudioSource.volume = _volume / 2;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if (objMesh.activeSelf)
        {
            if (crouchedStatut && !myPlayerModule.state.HasFlag(En_CharacterState.Crouched))
            {
                haveWaitDelay = false;

                StopAllCoroutines();
                StartCoroutine(WaitDelay());
            }

            crouchedStatut = myPlayerModule.state.HasFlag(En_CharacterState.Crouched);
        }
        else
        {
            if (!myPlayerModule.state.HasFlag(En_CharacterState.Crouched))
            {
                float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
                float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;
                oldPos = transform.position;

                if ((velocityX + velocityZ) != 0 && doSound)
                {
                    doSound = false;
                    StartCoroutine(WaitEndSound(allFootsteps[Random.Range(0, allFootsteps.Length)]));
                }
            }
        }
    }

    IEnumerator WaitDelay()
    {
        yield return new WaitForSeconds(delayToDoSound);
        haveWaitDelay = true;
    }

    IEnumerator WaitEndSound(AudioClip _clip)
    {
        myAudioSource.PlayOneShot(_clip);

        yield return new WaitForSeconds(_clip.length);

        yield return new WaitForSeconds(0.2f);
        doSound = true;
    }

    public void OnAnimRun()
    {
        if(!myPlayerModule.state.HasFlag(En_CharacterState.Crouched) && haveWaitDelay)
        {
            AudioManager.Instance.OnAudioPlayed(this.transform.position, myPlayerModule.mylocalPlayer.myPlayerId,true, myAudioSource.maxDistance);
            myAudioSource.PlayOneShot(allFootsteps[Random.Range(0, allFootsteps.Length)]);
        }
    }
}

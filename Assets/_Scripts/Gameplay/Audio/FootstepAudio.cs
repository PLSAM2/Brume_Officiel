using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootstepAudio : MonoBehaviour
{
    [SerializeField] PlayerModule myPlayerModule;
    Vector3 oldPos;

    bool doSound = true;
    bool haveWaitDelay = false;

    bool crouchedStatut = false;

    [SerializeField] AudioClip[] allFootsteps;

    [SerializeField] AudioSource myAudioSource;

    [SerializeField] float minTime = 0.1f;
    [SerializeField] float maxTime = 0.3f;

    [SerializeField] float delayToDoSound = 0.5f;

    private void Start()
    {
        ChangeVolume(AudioManager.Instance.currentPlayerVolume / 2);


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
            myAudioSource.volume = _volume / 4;
        }
        else
        {
            myAudioSource.volume = _volume / 2;
        }
    }

    // Update is called once per frame
    void Update()
    {
        if(crouchedStatut && !myPlayerModule.state.HasFlag(En_CharacterState.Crouched))
        {
            haveWaitDelay = false;

            StopAllCoroutines();
            StartCoroutine(WaitDelay());
            print("test");
        }

        crouchedStatut = myPlayerModule.state.HasFlag(En_CharacterState.Crouched);

        /*
        float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;
        oldPos = transform.position;

        if((velocityX + velocityZ) != 0 && doSound)
        {
            doSound = false;
            StartCoroutine(WaitEndSound(allFootsteps[Random.Range(0, allFootsteps.Length)]));
        }
        */
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

        yield return new WaitForSeconds(Random.Range(minTime, maxTime));
        doSound = true;
    }

    public void OnAnimRun()
    {
        if(!myPlayerModule.state.HasFlag(En_CharacterState.Crouched))
        {
            myAudioSource.PlayOneShot(allFootsteps[Random.Range(0, allFootsteps.Length)]);
        }
    }
}

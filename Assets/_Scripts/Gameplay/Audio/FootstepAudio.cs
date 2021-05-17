using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootstepAudio : MonoBehaviour
{
    [SerializeField] PlayerModule myPlayerModule;
    Vector3 oldPos;

    [HideInInspector]
    public bool isDecoy = false;

    [HideInInspector]
    public Decoy myDecoy;

    [SerializeField] AudioClip[] allFootsteps;

    [SerializeField] AudioSource myAudioSource;

    [SerializeField] float delayAfterSound = 0.2f;

    bool doSound = true;


    //icon footstep
    public bool doFootStepIcon = false;
    bool isLeftFoot = false;

    public Transform posFootLeft, posFootRight;

    private void Start()
    {
        ChangeVolume(AudioManager.Instance.currentPlayerVolume);

        if(transform.parent == GameFactory.GetActualPlayerFollow().transform)
        {
            doFootStepIcon = true;
        }
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
        if(myPlayerModule != null && myPlayerModule.teamIndex == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            myAudioSource.volume = _volume / 4;
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

        if (myPlayerModule != null && myPlayerModule.state.HasFlag(En_CharacterState.Crouched))
        {
            return;
        }
        else
        {
            if ((velocityX != 0 || velocityZ != 0) && doSound)
            {
                doSound = false;
                StartCoroutine(WaitEndSound(allFootsteps[Random.Range(0, allFootsteps.Length)]));

                if (doFootStepIcon)
                {
                    if (isLeftFoot)
                    {
                        LocalPoolManager.Instance.SpawnNewGenericInLocal(6, posFootLeft.position, Random.Range(0, 90), 1, 0.7f);
                    }
                    else
                    {
                        LocalPoolManager.Instance.SpawnNewGenericInLocal(6, posFootRight.position, Random.Range(0, 90), 1, 0.7f);
                    }

                    isLeftFoot = !isLeftFoot;
                }
            }
        }
    }

    IEnumerator WaitEndSound(AudioClip _clip)
    {
        if (GameFactory.DoSound(transform.position)) {

            if (!isDecoy)
            {
                AudioManager.Instance.OnAudioPlayed(this.transform.position, myPlayerModule.mylocalPlayer.myPlayerId, true, myAudioSource.maxDistance);
            }
            else
            {
                AudioManager.Instance.OnAudioPlayed(this.transform.position, myDecoy.netObj.GetOwnerID(), true, myAudioSource.maxDistance);
            }
            myAudioSource.PlayOneShot(_clip);
        }

        yield return new WaitForSeconds(_clip.length);

        yield return new WaitForSeconds(delayAfterSound);

        doSound = true;
    }
}

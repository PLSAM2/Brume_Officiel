using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FootstepAudio : MonoBehaviour
{
    public bool crowtching = false;

    Vector3 oldPos;

    bool doSound = true;

    [SerializeField] AudioClip[] allFootsteps;

    [SerializeField] AudioSource myAudioSource;

    [SerializeField] float minTime = 0.1f;
    [SerializeField] float maxTime = 0.3f;

    // Update is called once per frame
    void Update()
    {
        if (crowtching) { return; }

        float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;
        oldPos = transform.position;

        if((velocityX + velocityZ) != 0 && doSound)
        {
            doSound = false;
            StartCoroutine(WaitEndSound(allFootsteps[Random.Range(0, allFootsteps.Length)]));
        }
    }

    IEnumerator WaitEndSound(AudioClip _clip)
    {
        myAudioSource.PlayOneShot(_clip);

        yield return new WaitForSeconds(_clip.length);

        yield return new WaitForSeconds(Random.Range(minTime, maxTime));
        doSound = true;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DummyFootstepAudio : MonoBehaviour
{
	Vector3 oldPos;

	[SerializeField] Dummy dummy;

	[SerializeField] AudioClip[] allFootsteps;

	[SerializeField] AudioSource myAudioSource;

	[SerializeField] float delayAfterSound = 0.2f;

	bool doSound = true;

    public bool doFootStep = false;

	private void Start ()
	{
		ChangeVolume(AudioManager.Instance.currentPlayerVolume);
	}

	private void OnEnable ()
	{
		AudioManager.Instance.OnVolumeChange += ChangeVolume;

        if (doFootStep)
        {
            StartCoroutine(WaitForVisionCheck());
        }
	}

	private void OnDisable ()
	{
		AudioManager.Instance.OnVolumeChange -= ChangeVolume;
	}

	private void ChangeVolume ( float _volume )
	{
        myAudioSource.volume = _volume;
    }

	// Update is called once per frame
	void Update ()
	{
		float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
		float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;
		oldPos = transform.position;

		if (!doFootStep)
		{
			return;
		}

        if (doSound)
        {
            doSound = false;
            StartCoroutine(WaitEndSound(allFootsteps[Random.Range(0, allFootsteps.Length)]));
            //LocalPoolManager.Instance.SpawnNewGenericInLocal(6, transform.position, Random.Range(0, 90), 1, 0.7f);
        }

        IEnumerator WaitEndSound ( AudioClip _clip )
		{
			if (GameFactory.DoSound(transform.position))
			{
                AudioManager.Instance.OnAudioPlayed(this.transform.position, 0, true, myAudioSource.maxDistance, dummy);
                myAudioSource.PlayOneShot(_clip);

			}

			yield return new WaitForSeconds(_clip.length);

			yield return new WaitForSeconds(delayAfterSound);

			doSound = true;
		}
	}

    public IEnumerator WaitForVisionCheck()
    {
        CheckForBrumeRevelation();
        yield return new WaitForSeconds(.25f);
        CheckForBrumeRevelation();
        yield return new WaitForSeconds(.25f);
        CheckForBrumeRevelation();
        yield return new WaitForSeconds(.8f);
        StartCoroutine(WaitForVisionCheck());
    }

    void CheckForBrumeRevelation()
    {

        if (GameManager.Instance.currentLocalPlayer == null)
        {
            return;
        }

        if (GameFactory.GetActualPlayerFollow() != null && !GameFactory.GetActualPlayerFollow().myPlayerModule.isInBrume)
        {
            return;
        }

        LocalPoolManager.Instance.SpawnNewGenericInLocal(2, transform.position + Vector3.up * 0.1f, 90, 1);
    }

}

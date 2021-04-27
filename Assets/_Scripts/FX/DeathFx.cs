using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathFx : MonoBehaviour
{
    public float timeToDestroy = 3;

    public AudioClip myFxSound;

    // Start is called before the first frame update
    void Start()
    {
        if(myFxSound != null)
        {
            AudioManager.Instance.Play3DAudio(myFxSound, transform.position, 0, false);
        }

        Destroy(gameObject, timeToDestroy);
    }
}

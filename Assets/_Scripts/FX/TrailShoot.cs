using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrailShoot : FxFollow
{
    [SerializeField] ParticleSystem ps;
    bool isPlayeing = false;

    void Update()
    {
        if (target)
        {
            transform.position = target.position;

            if (target.gameObject.activeSelf)
            {
                if (!isPlayeing)
                {
                    ps.Play();
                    isPlayeing = true;
                }
            }
            else
            {
                if (isPlayeing)
                {
                    ps.Stop();
                    isPlayeing = false;
                }
            }
        }
    }
}

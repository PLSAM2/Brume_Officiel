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
                    print("oui");
                    ps.Play();
                    isPlayeing = true;
                }
            }
            else
            {
                if (isPlayeing)
                {
                    print("non");
                    ps.Stop();
                    isPlayeing = false;
                }
            }
        }
    }
}

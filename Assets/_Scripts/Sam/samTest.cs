using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class samTest : MonoBehaviour
{
    public ParticleSystem ps;
    bool isOn = true;

    private void Update()
    {
        int i = Random.Range(0, 100);

        if(i == 0)
        {
            if (isOn)
            {
                ps.Stop();
            }
            else
            {
                ps.Play();
            }

            isOn = !isOn;
            print("change");
        }
    }
}

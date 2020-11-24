using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    [SerializeField] Camera myCam;
    [SerializeField] AudioClip clip;

    AudioElement myAudio;


    private void Update()
    {
        RaycastHit hit;
        Ray ray = myCam.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out hit))
        {
            if (Input.GetMouseButtonDown(0))
            {

                if (myAudio == null || !myAudio.gameObject.activeSelf)
                {
                    myAudio = AudioManager.Instance.Play3DAudio(clip, hit.point);
                }
            }
            myAudio.transform.position = hit.point;
        }

    }
}

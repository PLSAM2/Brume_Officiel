using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrumeDetection : MonoBehaviour
{
    [SerializeField] LayerMask maskBrume;
    PlayerModule myPlayerModule;

    Brume currentBrume;

    private void Start()
    {
        myPlayerModule = GetComponent<PlayerModule>();
    }

    void Update()
    {
        RaycastHit hit;
        if (Physics.Raycast(transform.position + Vector3.up *1, -Vector3.up, out hit, 10, maskBrume))
        {
            currentBrume = hit.transform.GetComponent<BrumePlane>().myBrume;

            if(!myPlayerModule.isInBrume || myPlayerModule.brumeId != currentBrume.GetInstanceID())
            {
                myPlayerModule.SetInBrumeStatut(true, currentBrume.GetInstanceID());

                PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

                if (myPlayerModule == currentFollowPlayer)
                {
                    currentBrume.ShowHideMesh(myPlayerModule, false);
                    currentBrume.PlayAudio();
                }
            }
        }
        else
        {
            if (myPlayerModule.isInBrume)
            {
                myPlayerModule.SetInBrumeStatut(false, 0);

                PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

                if (myPlayerModule == currentFollowPlayer)
                {
                    currentBrume.ShowHideMesh(myPlayerModule, true);
                    UiManager.Instance.SetAlphaBrume(0);
                    currentBrume.PlayAudio();
                }
            }
        }
    }
}

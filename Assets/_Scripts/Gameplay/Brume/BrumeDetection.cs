using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class BrumeDetection : MonoBehaviour
{
    [SerializeField] LayerMask maskBrume;
    [SerializeField] LayerMask maskBrumeMesh;
    PlayerModule myPlayerModule;

    Brume currentBrume;

    public float resolution = 0.1f;
    float distanceRay = 2f;

    public AnimationCurve curveHeight;

    public GameObject brumeFx;

    private void Start()
    {
        myPlayerModule = GetComponent<PlayerModule>();
        //distanceRay = curveAlpha.keys[curveAlpha.keys.Length - 1].time;
    }

    void Update()
    {
        PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

        //sol detection
        RaycastHit hit;
        if (Physics.Raycast(transform.position + Vector3.up * 1, -Vector3.up, out hit, 10, maskBrume))
        {
            currentBrume = hit.transform.GetComponent<BrumePlane>().myBrume;

            if(!myPlayerModule.isInBrume || myPlayerModule.brumeId != currentBrume.GetInstanceID())
            {
                myPlayerModule.SetInBrumeStatut(true, currentBrume.GetInstanceID());

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

                if (myPlayerModule == currentFollowPlayer)
                {
                    currentBrume.ShowHideMesh(myPlayerModule, true);
                    currentBrume.PlayAudio();
                }
            }
        }

        //border detection
        float distance = GetDistanceFromBrume();
        if(distance == 2)
        {
            brumeFx.gameObject.SetActive(false);
        }
        else
        {
            brumeFx.gameObject.SetActive(true);
            brumeFx.transform.position = new Vector3(brumeFx.transform.position.x, curveHeight.Evaluate(GetDistanceFromBrume()), brumeFx.transform.position.z);
        }
    }

    float GetDistanceFromBrume()
    {
        RaycastHit hit;

        int stepCount = Mathf.RoundToInt(360 * resolution);
        float stepAngleSize = 360 / stepCount;
        List<Vector3> viewPoints = new List<Vector3>();

        List<float> allDistance = new List<float>();

        for (int i = 0; i <= stepCount; i++)
        {
            float angle = transform.eulerAngles.y - 360 / 2 + stepAngleSize * i;

            Vector3 dir = DirFromAngle(angle, true);

            if (Physics.Raycast(transform.position + Vector3.up * 0.5f, dir, out hit, distanceRay, maskBrumeMesh))
            {
                allDistance.Add(hit.distance);
            }
            Debug.DrawRay(transform.position, dir, Color.red, 0.1f);
        }

        if (allDistance.Count > 0)
        {
            return allDistance.Min();
        }
        return distanceRay;
    }

    public Vector3 DirFromAngle(float angleInDegrees, bool angleIsGlobal)
    {
        if (!angleIsGlobal)
        {
            angleInDegrees += transform.eulerAngles.y;
        }
        return new Vector3(Mathf.Sin(angleInDegrees * Mathf.Deg2Rad), 0, Mathf.Cos(angleInDegrees * Mathf.Deg2Rad));
    }
}

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

                    GameManager.Instance._mistMat.SetTexture("_MistMask", currentBrume.myTexture);
                    GameManager.Instance.OnLocalPlayerStateBrume?.Invoke(true);
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
                    GameManager.Instance.OnLocalPlayerStateBrume?.Invoke(false);
                }
            }
        }

        //border detection
        GetDistanceFromBrume();

        if (myPlayerModule.isInBrume)
        {
            myPlayerModule.timeInBrume += Time.deltaTime;
        }
        else
        {
            myPlayerModule.timeInBrume -= Time.deltaTime;
        }

        myPlayerModule.timeInBrume = Mathf.Clamp(myPlayerModule.timeInBrume, 0, 2);
    }

    void GetDistanceFromBrume()
    {
        RaycastHit hit;

        int stepCount = Mathf.RoundToInt(360 * resolution);
        float stepAngleSize = 360 / stepCount;
        List<Vector3> viewPoints = new List<Vector3>();

        float closestDistance = Mathf.Infinity;

        Vector3 posHit = Vector3.zero;

        for (int i = 0; i <= stepCount; i++)
        {
            float angle = transform.eulerAngles.y - 360 / 2 + stepAngleSize * i;

            Vector3 dir = DirFromAngle(angle, true);

            if (Physics.Raycast(transform.position + Vector3.up * 1f, dir, out hit, distanceRay, maskBrumeMesh))
            {
                if(hit.distance < closestDistance)
                {
                    closestDistance = hit.distance;
                    posHit = hit.point;
                }
            }
            //Debug.DrawRay(transform.position, dir, Color.red, 0.1f);
        }

        if (closestDistance != Mathf.Infinity)
        {
            //brumeFx.Play();
           // brumeFx.startSize = curveHeight.Evaluate(closestDistance);
        }
        else
        {
            //brumeFx.Stop();
        }
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

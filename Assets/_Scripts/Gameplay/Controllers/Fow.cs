using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fow : MonoBehaviour
{
    public Transform myTarget;
    [SerializeField] bool isStatic = false;


    public FieldOfView myFieldOfView;

    [SerializeField] float followSpeed = 10;
    public float fowRaduis = 0;

    PlayerModule playerModule;

    AnimationCurve curveInBrume;

    public void Init(Transform _target = null, float _fowRaduis = 0)
    {
        if(_target != null)
        {
            isStatic = false;
            myTarget = _target;
            fowRaduis = _fowRaduis;
            myFieldOfView.viewRadius = fowRaduis;
        }
        else
        {
            isStatic = true;
            myFieldOfView.GenerateFowStatic();
        }
    }

    public void InitPlayerModule(PlayerModule _pModule)
    {
        playerModule = _pModule;

        curveInBrume = new AnimationCurve();
        curveInBrume.AddKey(new Keyframe(0, playerModule.characterParameters.minVisionRangeInBrume));
        curveInBrume.AddKey(new Keyframe(2f, playerModule.characterParameters.visionRangeInBrume));
    }

    // Update is called once per frame
    void Update()
    {
        if (isStatic) { return; }

        transform.position = Vector3.Lerp(transform.position, new Vector3(myTarget.position.x, 0, myTarget.position.z), Time.deltaTime * followSpeed);

        float raduis = 0;
        if (playerModule.isInBrume)
        {
            raduis = curveInBrume.Evaluate(playerModule.timeInBrume);
        }
        else
        {
            raduis = playerModule.characterParameters.visionRange;
        }

        myFieldOfView.viewRadius = raduis;
    }
}

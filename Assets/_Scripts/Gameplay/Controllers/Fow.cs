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
    }

    public void ForceChangeFowRaduis(float _size)
    {
        fowRaduis = _size;
        myFieldOfView.viewRadius = fowRaduis;
    }

    public void ChangeFowRaduis(float _size)
    {
        fowRaduis = _size;
    }

    // Update is called once per frame
    void Update()
    {
        if (isStatic) { return; }

        transform.position = Vector3.Lerp(transform.position, new Vector3(myTarget.position.x, 0, myTarget.position.z), Time.deltaTime * followSpeed);

        if (playerModule.isInBrume)
        {
            myFieldOfView.viewRadius = playerModule.characterParameters.visionRange;
        }
        else
        {
            myFieldOfView.viewRadius = Mathf.Lerp(myFieldOfView.viewRadius, fowRaduis, playerModule.characterParameters.curveOutBrume.Evaluate(tOut) * Time.deltaTime);
        }
    }
}

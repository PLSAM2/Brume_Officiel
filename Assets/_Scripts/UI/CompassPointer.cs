﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CompassPointer : MonoBehaviour
{
    [SerializeField] private MeshRenderer pointerMat;
    public string vFrequencyPropertyName = "VerticalNoise_prop";
    public string hFrequencyPropertyName = "HorizontalNoise_prop";
    public string opacityPropertyName = "Opacity_Prop";

    public float maxDistance = 50;
    public float minDistance = 10;
    public float maxLifeTime = 4;
    public float minLifeTime = 1;
    public float noiseMultiplier = 2;
    private Transform character;
    private Vector3 targetPos;
    private bool isOneTime = false;
    private float baseTimer = 0;
    private float timer = 0;

    private void Start()
    {
        pointerMat.material.SetFloat(opacityPropertyName, 1);
    }

    public void InitNewTargetOneTime(Transform character, Vector3 target)
    {

        this.character = character;
        this.targetPos = target;
        float distance = AimToTarget();
        baseTimer = timer = Mathf.Clamp(Mathf.Abs((maxDistance - minDistance) / (distance - minDistance)) + minLifeTime, minLifeTime, maxLifeTime);
        isOneTime = true;
        SetByDistance(distance);
    }


    private void Update()
    {
        if (isOneTime)
        {
            if (timer > 0)
            {
                timer -= Time.deltaTime;
                float opacity = (timer / baseTimer);
                pointerMat.material.SetFloat(opacityPropertyName, opacity);
            }
            else
            {
                timer = 0;
                this.gameObject.SetActive(false);
            }

            return;
        }
    }

    public float AimToTarget()
    {
        Vector3 fromPos = character.position;
        Vector3 toPos = targetPos;

        fromPos.y = 0;
        toPos.y = 0;
        Vector3 direction = (toPos - fromPos).normalized;
        float angle = Vector3.SignedAngle(direction, Vector3.right, Vector3.up);
        this.transform.localEulerAngles = new Vector3(0, 0, -angle + 180) ;
        return Vector3.Distance(fromPos, toPos);
    }

    public void SetByDistance(float distance)
    {
        float value = Mathf.Clamp(maxDistance - distance, 0, maxDistance);
        pointerMat.material.SetFloat(vFrequencyPropertyName , value * noiseMultiplier);
        pointerMat.material.SetFloat(hFrequencyPropertyName, value * noiseMultiplier);
    }

}

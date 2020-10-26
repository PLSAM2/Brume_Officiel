using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WardModule : SpellModule
{
    [SerializeField] private AnimationCurve launchCurve;
    [SerializeField] private GameObject wardPrefab;
    private GameObject wardObj;
    public float wardSpeed;
    private float deceleratedRatio = 1;

    public bool isLaunched = false;
    private float deceleration = 1;
    private Vector3 startPos;
    private Vector3 destination;
    private float baseDistance;
    private float lastOffest = 0;
    private Vector3 noCurvePosition;
    private float animationCurveMaxValue;
    private void Start()
    {
        charges += 10000;
        wardObj = Instantiate(wardPrefab, Vector3.zero, Quaternion.identity);
        wardObj.SetActive(false);
        animationCurveMaxValue = launchCurve.Evaluate(0.5f);
    }


    protected override void Update()
    {
        base.Update();

        if (isLaunched)
        {
            if (wardObj.transform.position == destination)
            {
                WardLanded();
                return;
            }
            deceleration = 1;
            deceleration -= lastOffest / (animationCurveMaxValue + deceleratedRatio);
            Vector3 newPosition = Vector3.MoveTowards(noCurvePosition, destination, (wardSpeed * deceleration) * Time.deltaTime ); // Progression de la position de la balle (sans courbe)

            noCurvePosition = newPosition;
            float distanceProgress = Vector3.Distance(newPosition, destination) / baseDistance;
            float UpOffset = 0;

            UpOffset = launchCurve.Evaluate(distanceProgress);
            lastOffest = UpOffset;
            wardObj.transform.position = (newPosition + new Vector3(0, UpOffset, 0));
            deceleration = 1;
        }
    }

    public override void DecreaseCooldown() { } // Disabled

    public void AddCharge(int value = 1)
    {
        charges += value;
    }

    protected override void ResolveSpell(Vector3 _mousePosition)
    {
        base.ResolveSpell(_mousePosition);

        wardObj.SetActive(true);
        destination = _mousePosition;
        startPos = (transform.position + Vector3.up);
        wardObj.transform.position = startPos;
        baseDistance = Vector3.Distance(startPos, destination);
        noCurvePosition = startPos;
        isLaunched = true;
    }

    public void WardLanded()
    {
        isLaunched = false;
    }
}

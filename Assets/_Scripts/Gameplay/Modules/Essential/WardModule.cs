using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WardModule : SpellModule
{
    [SerializeField] private AnimationCurve launchCurve;
    [SerializeField] private GameObject wardPrefab;
    private GameObject wardObj;
    public float wardSpeed;
    public float deceleratedRatio = 1; // Plus il est petit, plus la vitesse de l'objet lorsqu'il est haut est lent
    public float distanceMaxBeforeEndTravel = 0.01f;
    private bool isLaunched = false;
    private float deceleration = 1;
    private float baseDistance;
    private float lastOffest = 0;
    private Vector3 startPos;
    private Vector3 destination;
    private Vector3 noCurvePosition;
    private float animationCurveMaxValue;

    private bool isOwner;

    private void Start()
    {
        wardObj = Instantiate(wardPrefab, Vector3.zero, Quaternion.identity);
        wardObj.SetActive(false);
        animationCurveMaxValue = launchCurve.Evaluate(0.5f); // MaxValue généré sur le millieu de la curve

        isOwner = this.GetComponent<LocalPlayer>().isOwner;

        AddCharge(100000000); // !!!!!!!
    }


    protected override void Update()
    {
        base.Update();

        if (isLaunched)
        {
            if (Vector3.Distance(wardObj.transform.position, destination) < distanceMaxBeforeEndTravel)
            {
                WardLanded();
                return;
            }

            deceleration = 1;
            deceleration = deceleration - (lastOffest / (animationCurveMaxValue + deceleratedRatio));
            Vector3 newPosition = Vector3.MoveTowards(noCurvePosition, destination, (wardSpeed * deceleration) * Time.deltaTime); // Progression de la position de la balle (sans courbe)
            noCurvePosition = newPosition;

            float distanceProgress = Vector3.Distance(newPosition, destination) / baseDistance;
            float UpOffset;

            UpOffset = launchCurve.Evaluate(distanceProgress);
            lastOffest = UpOffset;
            wardObj.transform.position = (newPosition + new Vector3(0, UpOffset, 0));
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

        if (isLaunched)
        {
            return;
        }

        destination = _mousePosition;

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.client.ID); // Player ID

            _writer.Write(destination.x);
            _writer.Write(destination.y);
            _writer.Write(destination.z);

            using (Message _message = Message.Create(Tags.LaunchWard, _writer))
            {
                RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
            }
        }

        InitWardLaunch(destination);
    }

    public void InitWardLaunch(Vector3 destination)
    {
        this.destination = destination;
        wardObj.SetActive(true);
        startPos = (transform.position + Vector3.up);
        wardObj.transform.position = startPos;
        baseDistance = Vector3.Distance(startPos, destination);
        noCurvePosition = startPos;
        isLaunched = true;
    }

    public void WardLanded()
    {
        isLaunched = false;

        if (isOwner)
        {
            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(RoomManager.Instance.client.ID); // Player ID

                using (Message _message = Message.Create(Tags.StartWardLifeTime, _writer))
                {
                    RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
                }
            }
        }

       wardObj.GetComponent<Ward>().Landed();

    }

}

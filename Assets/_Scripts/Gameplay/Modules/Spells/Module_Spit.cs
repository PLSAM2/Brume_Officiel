using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_Spit : SpellModule
{

    public GameObject spitPrefab;
    [HideInInspector] public GameObject spitObj;
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
    Sc_Spit localTrad;

    private void Start()
    {
        localTrad = spell as Sc_Spit;

        spitObj = Instantiate(spitPrefab, Vector3.zero, Quaternion.identity);
        spitObj.SetActive(false);
        animationCurveMaxValue = localTrad.launchCurve.Evaluate(0.5f); // MaxValue généré sur le millieu de la curve
    }

    private void OnDestroy()
    {
        Destroy(spitObj);
    }

    protected override void DestroyIfClient() { } // Keep this for client

    protected  void Update()
    {

        if (isLaunched)
        {
            if (Vector3.Distance(spitObj.transform.position, destination) < distanceMaxBeforeEndTravel)
            {
                Landed();
                return;
            }

            deceleration = 1;
            deceleration = deceleration - (lastOffest / (animationCurveMaxValue + deceleratedRatio));
            Vector3 newPosition = Vector3.MoveTowards(noCurvePosition, destination, (localTrad.spitSpeed * deceleration) * Time.deltaTime); // Progression de la position de la balle (sans courbe)
            noCurvePosition = newPosition;

            float distanceProgress = Vector3.Distance(newPosition, destination) / baseDistance;
            float UpOffset;

            UpOffset = localTrad.launchCurve.Evaluate(distanceProgress);
            lastOffest = UpOffset;
            spitObj.transform.position = (newPosition + new Vector3(0, UpOffset, 0));
        }
    }


    protected override void ResolveSpell(Vector3 _mousePosition)
    {
        if (isLaunched && spitObj != null)
        {
            return;
        }

        base.ResolveSpell(_mousePosition);

        destination = _mousePosition;

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(RoomManager.Instance.client.ID); // Player ID

            _writer.Write(destination.x);
            _writer.Write(destination.y);
            _writer.Write(destination.z);

            using (Message _message = Message.Create(Tags.CurveSpellLaunch, _writer))
            {
                RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
            }
        }

        InitLaunch(destination);
    }

    public void InitLaunch(Vector3 destination)
    {
        this.destination = destination;
        spitObj.SetActive(true);
        startPos = (transform.position + Vector3.up);
        spitObj.transform.position = startPos;
        baseDistance = Vector3.Distance(startPos, destination);
        noCurvePosition = startPos;
        isLaunched = true;
    }

    public void Landed()
    {
        isLaunched = false;

        if (isOwner)
        {
            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(RoomManager.Instance.client.ID); // Player ID

                using (Message _message = Message.Create(Tags.CurveSpellLanded, _writer))
                {
                    RoomManager.Instance.client.SendMessage(_message, SendMode.Reliable);
                }
            }

            NetworkObjectsManager.Instance.NetworkInstantiate(localTrad.onImpactInstantiate.myNetworkObject.objListKey, destination, Vector3.zero);
        }
    }
}

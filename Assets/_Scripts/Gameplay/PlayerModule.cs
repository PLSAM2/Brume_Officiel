using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class PlayerModule : MonoBehaviour
{
    [Header("GameplayInfos")]
    public Sc_CharacterParameters characterParameters;
    public ushort myId;
    public int teamIndex { get; set; }
    public static Action<Vector3, ushort> DirectionInputedUpdate;

    [Header("CharacterBuilder")]
    [SerializeField] MovementModule movementPart;
    [SerializeField] CapsuleCollider coll;

    void Start ()
    {
        movementPart.SetupComponent(characterParameters.movementParameters,coll);
    }

    void Update ()
    {
        DirectionInputedUpdate.Invoke(DirectionInputed(), myId);
    }

    Vector3 DirectionInputed ()
    {
        return Vector3.Normalize(new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")));
    }
}

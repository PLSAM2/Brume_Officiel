using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerModule : MonoBehaviour
{
    [Header("GameplayInfos")]
    public Sc_CharacterParameters characterParameters;
    public int teamIndex { get; set; }

    [Header("CharacterBuilder")]
    [SerializeField] MovementModule movementPart;
    [SerializeField] CapsuleCollider coll;

    void Start ()
    {
        movementPart.SetupComponent(characterParameters.movementParameters,coll);
    }

    void Update ()
    {

    }
}

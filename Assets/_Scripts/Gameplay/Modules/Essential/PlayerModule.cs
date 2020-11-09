﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;
using System.Net.Http.Headers;
using DG.Tweening;
using static GameData;

public class PlayerModule : MonoBehaviour
{
    [Header("Inputs")]
    public KeyCode firstSpellKey = KeyCode.A;
    public KeyCode secondSpellKey = KeyCode.E, thirdSpellKey = KeyCode.R, freeCamera = KeyCode.Space, crouching = KeyCode.LeftShift;
    public KeyCode interactKey = KeyCode.F;
    public KeyCode wardKey = KeyCode.Alpha4;
    private LayerMask groundLayer;
    bool rotLocked = false;

    [Header("GameplayInfos")]
    public Sc_CharacterParameters characterParameters;
    public Team teamIndex;
    public bool isInBrume = false;
    [HideInInspector] public bool isCrouched;


    [Header("DamagesPart")]
    En_CharacterState _state;
    [ReadOnly] public En_CharacterState state { get => _state; set { _state = value; UiManager.Instance.StatusUpdate(_state); } }
    [ReadOnly] public List<DamagesInfos> allHitTaken = new List<DamagesInfos>();


    [Header("Vision")]
    public GameObject sonar;
    public LayerMask brumeLayer;
    [SerializeField] SpriteRenderer mapIcon;

    [Header("CharacterBuilder")]
    public MovementModule movementPart;
    [SerializeField] SpellModule firstSpell, secondSpell, thirdSpell, leftClick, ward;
    [SerializeField] CapsuleCollider coll;
    [ReadOnly] public LocalPlayer mylocalPlayer;

    public List<Interactible> interactiblesClose = new List<Interactible>();

    //animations local des autres joueurs
    //Vector3 oldPos;
    //ALL ACTION 
    #region
    public Action revelationCheck;

    public Action<Vector3> DirectionInputedUpdate;
    //spell
    public Action<Vector3> firstSpellInput, secondSpellInput, thirdSpellInput, leftClickInput, wardInput;
    public Action<Vector3> firstSpellInputRealeased, secondSpellInputRealeased, thirdSpellInputRealeased, leftClickInputRealeased, wardInputReleased;
    //run
    public Action toggleRunning, stopRunning;
    //otherMovements
    public Action<ForcedMovement> forcedMovementAdded;
    public Action forcedMovementInterrupted;
    public Action<MovementModifier> addMovementModifier;
    //Animation
    public Action<Vector3> onSendMovement;
    public static Action<float> reduceAllCooldown;
    public static Action<float, En_SpellInput> reduceTargetCooldown;
    public Action upgradeKit, backToNormalKit;
    public Action<bool> rotationLock;
    #endregion

    void Awake()
    {
        groundLayer = LayerMask.GetMask("Ground");
        mylocalPlayer = GetComponent<LocalPlayer>();

        GameManager.Instance.AllCharacterSpawned += Setup;
    }

    void Start()
    {
        if (GameManager.Instance.gameStarted)
            Setup();

        GameManager.Instance.PlayerJoinedAndInitInScene(); // DIT AU SERVEUR QUE CE JOUEUR EST PRET A JOUER

        //	oldPos = transform.position;
    }

    private void OnDestroy()
    {
        GameManager.Instance.AllCharacterSpawned -= Setup;

        if (!mylocalPlayer.isOwner)
        {
        }
        else
        {
            rotationLock -= LockingRotation;
            reduceAllCooldown -= ReduceAllCooldowns;
            reduceTargetCooldown -= ReduceCooldown;
        }
    }

    void Setup()
    {
        state = En_CharacterState.Clear;
        if (mylocalPlayer.isOwner)
        {
            _state = En_CharacterState.Clear;
            mapIcon.color = Color.blue;

            //modulesPArt
            movementPart.SetupComponent(characterParameters.movementParameters);
            firstSpell?.SetupComponent();
            secondSpell?.SetupComponent();
            thirdSpell?.SetupComponent();
            leftClick?.SetupComponent();
            ward?.SetupComponent();

            rotationLock += LockingRotation;
            reduceAllCooldown += ReduceAllCooldowns;
            reduceTargetCooldown += ReduceCooldown;
            GameManager.PlayerSpawned.Invoke(this);



        }
        else
        {
            if (teamIndex == GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex)
                mapIcon.color = Color.green;
            else
                mapIcon.color = Color.red;

            StartCoroutine(WaitForVisionCheck());

        }
    }

    void Update()
    {
        if (mylocalPlayer.isOwner)
        {
            //rot player
            LookAtMouse();

            //direction des fleches du clavier 
            DirectionInputedUpdate.Invoke(directionInputed());

            //INPUT DETECTION SPELLS AND RUNNING
            #region
            if (Input.GetKeyDown(firstSpellKey))
                firstSpellInput?.Invoke(mousePos());
            else if (Input.GetKeyDown(secondSpellKey))
                secondSpellInput?.Invoke(mousePos());
            else if (Input.GetKeyDown(thirdSpellKey))
                thirdSpellInput?.Invoke(mousePos());
            else if (Input.GetKeyDown(wardKey))
                wardInput?.Invoke(mousePos());
            //AUTO
            else if (Input.GetAxis("Fire1") > 0)
            {
                leftClickInput?.Invoke(mousePos());
            }
            //RUNNING
            else if (Input.GetKeyDown(KeyCode.LeftShift))
                toggleRunning?.Invoke();

            if (Input.GetKeyUp(firstSpellKey))
                firstSpellInputRealeased?.Invoke(mousePos());
            else if (Input.GetKeyDown(secondSpellKey))
                secondSpellInputRealeased?.Invoke(mousePos());
            else if (Input.GetKeyDown(thirdSpellKey))
                thirdSpellInputRealeased?.Invoke(mousePos());
            else if (Input.GetKeyDown(wardKey))
                wardInputReleased?.Invoke(mousePos());


            if (Input.GetKeyDown(interactKey))
            {
                foreach (Interactible interactible in interactiblesClose)
                {
                    if (interactible == null)
                        return;

                    interactible.TryCapture(teamIndex, this);
                }
            }
            else if (Input.GetKeyUp(interactKey))
            {
                foreach (Interactible interactible in interactiblesClose)
                {
                    if (interactible == null)
                        return;

                    interactible.StopCapturing(teamIndex);
                }
            }

            if (Input.GetKeyDown(crouching))
                AddState(En_CharacterState.Crouched);

            else if (Input.GetKeyUp(crouching))
                RemoveState(En_CharacterState.Crouched);
            #endregion

            //camera
            if (Input.GetKeyUp(freeCamera))
                CameraManager.LockCamera.Invoke();
            else if (Input.GetKey(freeCamera))
                CameraManager.UpdateCameraPos();
        }
        else
            return;
    }

    public void SetInBrumeStatut(bool _value)
    {
        isInBrume = _value;
        mylocalPlayer.ChangeFowRaduis(_value);
    }

    void LookAtMouse()
    {
        if (!rotLocked)
        {
            Vector3 _currentMousePos = mousePos();
            transform.LookAt(new Vector3(_currentMousePos.x, transform.position.y, _currentMousePos.z));
        }
    }

    public void AddState(En_CharacterState _stateToAdd)
    {
        state |= _stateToAdd;
    }

    public void RemoveState(En_CharacterState _stateToRemove)
    {
        state = state & (state & ~(_stateToRemove));
    }

    void ReduceCooldown(float _duration, En_SpellInput _spell)
    {
        switch (_spell)
        {
            case En_SpellInput.FirstSpell:
                firstSpell.ReduceCooldown(_duration);
                break;

            case En_SpellInput.SecondSpell:
                secondSpell.ReduceCooldown(_duration);
                break;

            case En_SpellInput.ThirdSpell:
                thirdSpell.ReduceCooldown(_duration);
                break;

            case En_SpellInput.Click:
                leftClick.ReduceCooldown(_duration);
                break;

            case En_SpellInput.Ward:
                ward.ReduceCooldown(_duration);
                break;
        }
    }

    void ReduceAllCooldowns(float _duration)
    {
        firstSpell.ReduceCooldown(_duration);
        secondSpell.ReduceCooldown(_duration);
        thirdSpell.ReduceCooldown(_duration);
        //leftClick.ReduceCooldown(_duration);
        ward.ReduceCooldown(_duration);
    }
    //vision
    #region
    void CheckForBrumeRevelation()
    {
        if (GameManager.Instance.currentLocalPlayer == null)
        {
            return;
        }

        if (Vector3.Distance(transform.position, GameManager.Instance.currentLocalPlayer.transform.position) <= GameManager.Instance.currentLocalPlayer.myPlayerModule.characterParameters.detectionRange &&
            GameManager.Instance.currentLocalPlayer.myPlayerModule.isInBrume)
        {
            GameObject _fx = Instantiate(sonar, transform.position + Vector3.up, Quaternion.Euler(90, 0, 0));

            if (teamIndex == Team.blue)
            {
                _fx.GetComponent<ParticleSystem>().startColor = Color.blue;
            }
            else if (teamIndex == Team.red)
            {
                _fx.GetComponent<ParticleSystem>().startColor = Color.red;
            }
        }

    }
    IEnumerator WaitForVisionCheck()
    {
        CheckForBrumeRevelation();
        yield return new WaitForSeconds(characterParameters.delayBetweenDetection);
        revelationCheck?.Invoke();
    }
    #endregion

    //Vars 
    #region 
    public Vector3 directionInputed()
    {
        return Vector3.Normalize(new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")));
    }

    public Vector3 mousePos()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, Mathf.Infinity, groundLayer))
        {
            return new Vector3(hit.point.x, 0, hit.point.z);
        }
        else
        {
            return Vector3.zero;
        }
    }

    public Vector3 ClosestFreePos(Vector3 _posToCloseUpTo, float _anticipationDistance)
    {
        RaycastHit _hit;
        if (Physics.Raycast(transform.position, _posToCloseUpTo - transform.position, out _hit, 1000, movementPart.movementBlockingLayer))
        {
            return transform.position + Vector3.Normalize(_posToCloseUpTo - transform.position) * (Vector3.Distance(_hit.point, transform.position) - _anticipationDistance);
        }
        return transform.position;
    }
    #endregion

    void LockingRotation(bool _isLocked)
    {
        if (_isLocked)
            rotLocked = true;
        else
            rotLocked = false;
    }


}

[System.Flags]
public enum En_CharacterState
{
    Clear = 1 << 0,
    Slowed = 1 << 1,
    SpedUp = 1 << 2,
    Stunned = 1 << 3,
    Canalysing = 1 << 4,
    Silenced = 1 << 5,
    Crouched = 1 << 6,
}

[System.Serializable]
public class DamagesInfos
{
    public ushort damageHealth;

    [HideInInspector] public string playerName;
}


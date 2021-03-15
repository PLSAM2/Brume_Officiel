﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;
using static GameData;
using System.Linq;
using DG.Tweening;
using UnityEngine.UI;

public class PlayerModule : MonoBehaviour
{
    [TabGroup("InputsPart")] public KeyCode firstSpellKey = KeyCode.A;
    [TabGroup("InputsPart")] public KeyCode secondSpellKey = KeyCode.E, thirdSpellKey = KeyCode.R, freeCamera = KeyCode.Space, tpSpellKey = KeyCode.F, crouching = KeyCode.LeftShift, cancelSpellKey = KeyCode.LeftControl, pingKey = KeyCode.G;
    [TabGroup("InputsPart")] public KeyCode interactKey = KeyCode.F;
    [TabGroup("InputsPart")] public KeyCode wardKey = KeyCode.Alpha4;
    [TabGroup("Modules")] public MovementModule movementPart;
    [TabGroup("Modules")] public SpellModule firstSpell, secondSpell, thirdSpell, leftClick, tpModule, ward, pingModule;
    bool boolWasClicked = false;

    [TabGroup("GameplayInfos")] public Sc_CharacterParameters characterParameters;
    [TabGroup("GameplayInfos")] [ReadOnly] public Team teamIndex;
    [TabGroup("GameplayInfos")] public float revelationRangeWhileHidden = 10;
    [TabGroup("FeedbacksState")] [SerializeField] ParticleSystem rootParticle, slowParticle, spedUpParticle, silencedParticle, embourbedParticle;
    Team otherTeam;
    [HideInInspector] public bool _isInBrume;
    En_CharacterState _state = En_CharacterState.Clear;
    public En_CharacterState state
    {
        get => _state | LiveEffectCharacterState();
        set { if (!mylocalPlayer.isOwner) { _state = value; } else return; }
    }
    [HideInInspector] public bool willListenInputs = true;
    En_CharacterState LiveEffectCharacterState()
    {
        En_CharacterState _temp = En_CharacterState.Clear;

        if (allEffectLive.Count == 0)
            return En_CharacterState.Clear;
        foreach (EffectLifeTimed effectLive in allEffectLive)
        {
            _temp |= effectLive.effect.stateApplied;
        }

        return _temp;
    }

    [HideInInspector] public En_CharacterState oldState = En_CharacterState.Clear;

    [ReadOnly]
    public bool isInBrume
    {
        get => _isInBrume; set
        {
            _isInBrume = value;

            if (mylocalPlayer.isOwner)
                GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", value);

            if (isAltarSpeedBuffActive)
            {
                print("Iexitbrume");
                SetAltarSpeedBuffState(_isInBrume);
            }
        }
    }
    [TabGroup("Debugging")] [ReadOnly] public int brumeId;
    Vector3 lastRecordedPos;


    [TabGroup("Debugging")] [SerializeField] Color myColor;
    bool _isCrouched = false;
    bool isCrouched
    { get => _isCrouched; set { _isCrouched = value; if (_isCrouched) { AddState(En_CharacterState.Crouched); } else { RemoveState(En_CharacterState.Crouched); } } }
    [TabGroup("Debugging")] public List<DamagesInfos> allHitTaken = new List<DamagesInfos>();


    private LayerMask brumeLayer;
    [TabGroup("GameplayInfos")] [SerializeField] SpriteRenderer mapIcon;


    [HideInInspector] public LocalPlayer mylocalPlayer;
    //interactibles
    [HideInInspector] public List<Interactible> interactiblesClose = new List<Interactible>();
    [TabGroup("GameplayInfos")] public Image menacedIcon;
    //effects
    [TabGroup("Debugging")] public List<EffectLifeTimed> allEffectLive;
    [TabGroup("Debugging")] public List<EffectLifeTimed> allTickLive;
    private ushort currentKeyIndex = 0;

    [Header("Altar Buff/Debuff")]
    [TabGroup("GameplayInfos")] [SerializeField] private Sc_Status enteringBrumeStatus;
    [TabGroup("GameplayInfos")] [SerializeField] private Sc_Status leavingBrumeStatus;
    private bool isAltarSpeedBuffActive = false;
    [TabGroup("Modules")] public Sc_Status poisonousEffect;
    [HideInInspector] public bool isPoisonousEffectActive = false;

    [HideInInspector] public bool cursedByShili = false;
    [Header("Cursed")]
    [TabGroup("GameplayInfos")] [SerializeField] public GameObject wxMark;
    [TabGroup("GameplayInfos")] [SerializeField] private Sc_Status wxMarkRef;
    [TabGroup("GameplayInfos")] [SerializeField] float shaderSpeedTransition = 10;
    [TabGroup("GameplayInfos")] float shaderTransitionValue = 1;

    [Header("AutoHeal")]
    [TabGroup("GameplayInfos")] public float timeWaitForHeal = 10;
    [TabGroup("GameplayInfos")] private float timerWaitForHeal = 0;
    [TabGroup("GameplayInfos")] private bool isWaitingForHeal = false;

    [TabGroup("GameplayInfos")] public float timeHealTick = 2.5f;
    [TabGroup("GameplayInfos")] public ushort healPerTick = 1;
    [TabGroup("GameplayInfos")] private float healTimer = 0;
    [TabGroup("GameplayInfos")] private bool isAutoHealing = false;

    //ALL ACTION 
    #region
    //[INPUTS ACTION]
    #region
    public Action<Vector3> DirectionInputedUpdate;
    //spell
    public Action<Vector3> firstSpellInput, secondSpellInput, thirdSpellInput, leftClickInput, tpInput, wardInput, pingInput;
    public Action<Vector3> firstSpellInputRealeased, secondSpellInputRealeased, thirdSpellInputRealeased, leftClickInputRealeased, tpInputReleased, wardInputReleased, pingInputReleased;
    public Action startSneaking, stopSneaking;
    public Action<bool> rotationLock, cancelSpell;
    #endregion

    //[DASH ET MODIFICATEUR DE MOUVEMENT]
    #region
    public Action<ForcedMovement> forcedMovementAdded;
    public Action forcedMovementInterrupted;
    #endregion

    //pour l animator
    public Action<Vector3> onSendMovement;

    //[SPECIFIC ACTION NEEDED POUR LES SPELLS]
    #region
    public Action<float> reduceAllCooldown;
    public Action<float, En_SpellInput> reduceTargetCooldown;
    public Action upgradeKit, backToNormalKit;
    #endregion

    //pour la revelation hors de la brume
    public Action revelationCheck;

    //damagesInterruptionetc
    public Action hitCountered;
    //buffer input
    public Action spellResolved;
    [HideInInspector] public En_SpellInput spellInputedRecorded;
    public Action ultPointPickedUp;
    #endregion

    void Awake()
    {
        mylocalPlayer = GetComponent<LocalPlayer>();
        GameManager.Instance.OnAllCharacterSpawned += Setup;
        GameManager.Instance.OnAllCharacterSpawned += mylocalPlayer.AllCharacterSpawn;

        //A VIRER QUAND C EST TROUVER.
    }

    void Start()
    {
        if (GameManager.Instance.gameStarted)
            Setup();

        if (mylocalPlayer.isOwner)
        {
            GameManager.Instance.playerJoinedAndInit = true;
            GameManager.Instance.PlayerJoinedAndInitInScene(); // DIT AU SERVEUR QUE CE JOUEUR EST PRET A JOUER
        }
        //	oldPos = transform.position;
    }

    private void OnDestroy()
    {
        GameManager.Instance.OnAllCharacterSpawned -= Setup;
        GameManager.Instance.OnAllCharacterSpawned -= mylocalPlayer.AllCharacterSpawn;
        if (mylocalPlayer.isOwner)
        {
            rotationLock -= LockingRotation;
            reduceAllCooldown -= ReduceAllCooldowns;
            reduceTargetCooldown -= ReduceCooldown;
            spellResolved -= BuffInput;

        }
    }

    public virtual void Setup()
    {
        if (firstSpell != null)
            firstSpell.SetupComponent(En_SpellInput.FirstSpell);
        if (secondSpell != null)
            secondSpell.SetupComponent(En_SpellInput.SecondSpell);
        if (thirdSpell != null)
            thirdSpell.SetupComponent(En_SpellInput.ThirdSpell);
        if (leftClick != null)
            leftClick.SetupComponent(En_SpellInput.Click);
        if (pingModule != null)
            pingModule.SetupComponent(En_SpellInput.Ping);
        if (ward != null)
            ward.SetupComponent(En_SpellInput.Ward);
        if (tpModule != null)
            tpModule.SetupComponent(En_SpellInput.TP);

        spedUpParticle.gameObject.SetActive(false);
        silencedParticle.gameObject.SetActive(false);
        slowParticle.gameObject.SetActive(false);
        rootParticle.gameObject.SetActive(false);
        embourbedParticle.gameObject.SetActive(false);

        _state = En_CharacterState.Clear;
        oldState = state;


        if (teamIndex == Team.blue)
            otherTeam = Team.red;
        else
            otherTeam = Team.blue;

        if (mylocalPlayer.isOwner)
        {

            UiManager.Instance.LinkInputName(En_SpellInput.Click, "LC");
            UiManager.Instance.LinkInputName(En_SpellInput.FirstSpell, "RC");
            UiManager.Instance.LinkInputName(En_SpellInput.SecondSpell, secondSpellKey.ToString());
            UiManager.Instance.LinkInputName(En_SpellInput.ThirdSpell, thirdSpellKey.ToString());
            UiManager.Instance.LinkInputName(En_SpellInput.TP, tpSpellKey.ToString());

            UiManager.Instance.LinkInputName(En_SpellInput.Ward, wardKey.ToString());
            spellResolved += BuffInput;
            //modulesPArt
            movementPart.SetupComponent(characterParameters.movementParameters);
            rotationLock += LockingRotation;

            reduceAllCooldown += ReduceAllCooldowns;
            reduceTargetCooldown += ReduceCooldown;

        }
        else
        {
            mapIcon.gameObject.SetActive(false);
            StartCoroutine(WaitForVisionCheck());
        }

        ResetLayer();
    }

    public void ResetLayer()
    {
        if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(teamIndex))
        {
            gameObject.layer = 7;
        }
        else
        {
            gameObject.layer = 8;
        }
    }

    private void OnDisable()
    {
        foreach (Material mat in GameManager.Instance.shaderDifMaterial)
        {
            mat.SetFloat(GameManager.Instance.property, 0);
        }
    }

    protected virtual void Update()
    {

        if (oldState != state)
        {
            if ((state & En_CharacterState.Integenbility) != 0)
                gameObject.layer = 16;
            else if ((oldState & En_CharacterState.Integenbility) != 0)
                ResetLayer();

            if (oldState.HasFlag(En_CharacterState.Crouched) != state.HasFlag(En_CharacterState.Crouched))
            {
                mylocalPlayer.myAnimController.animator.SetBool("walk", state.HasFlag(En_CharacterState.Crouched));
            }

            if ((oldState & En_CharacterState.WxMarked) != 0 && (state & En_CharacterState.WxMarked) == 0)
            {
                mylocalPlayer.MarkThirdEye(false);
            }
            else if ((state & En_CharacterState.WxMarked) != 0 && (oldState & En_CharacterState.WxMarked) == 0)
            {
                mylocalPlayer.MarkThirdEye(true);
            }

            //PARTICLE FEEDBACK TOUSSA
            #region
            if ((oldState & En_CharacterState.SpedUp) == 0 && (state & En_CharacterState.SpedUp) != 0)
                spedUpParticle.gameObject.SetActive(true);
            else if ((oldState & En_CharacterState.SpedUp) != 0 && (state & En_CharacterState.SpedUp) == 0)
                spedUpParticle.gameObject.SetActive(false);


            if ((oldState & En_CharacterState.Slowed) == 0 && (state & En_CharacterState.Slowed) != 0)
                slowParticle.gameObject.SetActive(true);
            else if ((oldState & En_CharacterState.Slowed) != 0 && (state & En_CharacterState.Slowed) == 0)
                slowParticle.gameObject.SetActive(false);


            /*	if ((oldState & En_CharacterState.Root) == 0 && (state & En_CharacterState.Root) != 0)
                    rootParticle.gameObject.SetActive(true);
                else if ((oldState & En_CharacterState.Root) != 0 && (state & En_CharacterState.Root) == 0)
                    rootParticle.gameObject.SetActive(false);*/


            if ((oldState & En_CharacterState.Silenced) == 0 && (state & En_CharacterState.Silenced) != 0)
                silencedParticle.gameObject.SetActive(true);
            else if ((oldState & En_CharacterState.Silenced) != 0 && (state & En_CharacterState.Silenced) == 0)
                silencedParticle.gameObject.SetActive(false);


            if ((oldState & En_CharacterState.Embourbed) == 0 && (state & En_CharacterState.Embourbed) != 0)
                embourbedParticle.gameObject.SetActive(true);
            else if ((oldState & En_CharacterState.Embourbed) != 0 && (state & En_CharacterState.Embourbed) == 0)
                embourbedParticle.gameObject.SetActive(false);

            #endregion
            if (mylocalPlayer.isOwner)
            {
                UiManager.Instance.StatusUpdate(state);
                mylocalPlayer.SendState(state);
            }
        }
        oldState = state;

        if ((state & (En_CharacterState.Stunned | En_CharacterState.Slowed | En_CharacterState.Hidden)) != 0)
        {
            mylocalPlayer.myUiPlayerManager.HidePseudo(true);
        }
        else
            mylocalPlayer.myUiPlayerManager.HidePseudo(false);

        if (mylocalPlayer.isOwner)
        {
            if (willListenInputs && !UiManager.Instance.chat.isFocus && !GameManager.Instance.menuOpen)
            {
                //direction des fleches du clavier 
                DirectionInputedUpdate?.Invoke(directionInputed());
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
                else if (Input.GetKeyDown(cancelSpellKey))
                    cancelSpell?.Invoke(false);
                else if (Input.GetKeyDown(tpSpellKey))
                    tpInput?.Invoke(mousePos());
                else if (Input.GetKeyDown(pingKey))
                    pingInput?.Invoke(mousePos());

                //AUTO
                else if (Input.GetAxis("Fire1") > 0 && !boolWasClicked)
                {
                    leftClickInput?.Invoke(mousePos());
                    boolWasClicked = true;
                }

                if (Input.GetKeyUp(firstSpellKey))
                    firstSpellInputRealeased?.Invoke(mousePos());
                else if (Input.GetKeyUp(secondSpellKey))
                    secondSpellInputRealeased?.Invoke(mousePos());
                else if (Input.GetKeyUp(thirdSpellKey))
                    thirdSpellInputRealeased?.Invoke(mousePos());
                else if (Input.GetKeyUp(wardKey))
                {
                    wardInputReleased?.Invoke(mousePos());
                    RetryInteractibleCapture();
                }
                else if (Input.GetKeyUp(tpSpellKey))
                    tpInputReleased?.Invoke(mousePos());
                else if (Input.GetKeyUp(pingKey))
                    pingInputReleased?.Invoke(mousePos());
                else if (Input.GetAxis("Fire1") <= 0 && boolWasClicked)
                {
                    leftClickInputRealeased?.Invoke(mousePos());
                    boolWasClicked = false;
                }

                //if (Input.GetKeyDown(interactKey))
                //{
                //	foreach (Interactible interactible in interactiblesClose)
                //	{
                //		if (interactible == null)
                //			return;
                //		LockingRotation(true);
                //		interactible.TryCapture(teamIndex, this);
                //	}
                //}
                //else if (Input.GetKeyUp(interactKey))
                //{
                //	foreach (Interactible interactible in interactiblesClose)
                //	{
                //		if (interactible == null)
                //			return;
                //		LockingRotation(false);
                //		interactible.StopCapturing(teamIndex);
                //	}
                //}

                if (Input.GetKeyDown(crouching))
                {
                    isCrouched = true;
                }
                else if (Input.GetKeyUp(crouching))
                {
                    isCrouched = false;
                }
            }

            #endregion

            //camera
            if (Input.GetKeyUp(freeCamera))
                CameraManager.Instance.LockCamera?.Invoke();
            else if (Input.GetKey(freeCamera))
                CameraManager.Instance.UpdateCameraPos?.Invoke();

            //MEGA TEMP
            mylocalPlayer.myUiPlayerManager.ShowStateIcon(state, 10, 10);

        }
        else
        {
            // TEMP
            mylocalPlayer.myUiPlayerManager.ShowStateIcon(state, 10, 10);
        }

        if (isAutoHealing)
        {
            CheckAutoHealProcess();
        }

        if (isWaitingForHeal)
        {
            WaitForHealProcess();
        }


    }


    protected virtual void FixedUpdate()
    {
        TreatEffects();
        TreatTickEffects();
        if (mylocalPlayer.isOwner)
        {
            CheckBrumeShader();
        }
    }

    public void CheckBrumeShader()
    {
            if (_isInBrume)
            {
                if (shaderTransitionValue > 0.99f)
                {
                    return;
                }
                foreach (Material mat in GameManager.Instance.shaderDifMaterial)
                {
                    shaderTransitionValue = Mathf.Lerp(shaderTransitionValue, 1, Time.deltaTime * shaderSpeedTransition);
                    mat.SetFloat(GameManager.Instance.property, shaderTransitionValue);
                }

            }
            else
            {
                if (shaderTransitionValue < 0.01f)
                {
                    return;
                }
                foreach (Material mat in GameManager.Instance.shaderDifMaterial)
                {
                    shaderTransitionValue = Mathf.Lerp(shaderTransitionValue, 0, Time.deltaTime * shaderSpeedTransition);
                    mat.SetFloat(GameManager.Instance.property, shaderTransitionValue);
                }
            }
    }
    private void WaitForHealProcess()
    {
       timerWaitForHeal -= Time.deltaTime;

        if (timerWaitForHeal <= 0)
        {
            isWaitingForHeal = false;

            if (mylocalPlayer.liveHealth <= characterParameters.maxHealthForRegen)
            {
                SetAutoHealState(true);
            }
        }
    }


    private void CheckAutoHealProcess()
    {
        healTimer -= Time.deltaTime;

        if (healTimer <= 0 )
        {
            mylocalPlayer.HealPlayer(healPerTick);

            if (mylocalPlayer.liveHealth >= characterParameters.maxHealthForRegen)
            {
                SetAutoHealState(false);
            } else
            {
                healTimer = timeHealTick;
            }
        }
    }


    public virtual void SetInBrumeStatut(bool _value, int idBrume)
    {
        isInBrume = _value;
        brumeId = idBrume;
    }

    public void RetryInteractibleCapture()
    {
        foreach (Interactible inter in interactiblesClose)
        {
            inter.CheckOnUnlock = true;
        }
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
        leftClick.ReduceCooldown(_duration);
        ward.ReduceCooldown(_duration);
        tpModule.ReduceCooldown(_duration);
    }

    //vision
    #region
    void CheckForBrumeRevelation()
    {

        if (GameManager.Instance.currentLocalPlayer == null)
        {
            return;
        }
        if (ShouldBePinged())
        {
            //Debug.Log("I shouldBePinged");
            if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(teamIndex))
                LocalPoolManager.Instance.SpawnNewGenericInLocal(1, transform.position + Vector3.up * 0.1f, 90, 1);
            else
                LocalPoolManager.Instance.SpawnNewGenericInLocal(2, transform.position + Vector3.up * 0.1f, 90, 1);

        }
        lastRecordedPos = transform.position;

    }

    bool ShouldBePinged()
    {
        //marké par la shili donc go ping
        if (cursedByShili)
            return true;

        //le perso a pas bougé
        if (lastRecordedPos == transform.position || isInBrume)
            return false;

        //on choppe le player local
        PlayerModule _localPlayer = GameManager.Instance.currentLocalPlayer.myPlayerModule;

        //le perso est pas en train de crouched
        if (!_localPlayer.isInBrume || (state & En_CharacterState.Crouched) != 0)
            return false;

        //DISTANCE > a la range
        if (Vector3.Distance(transform.position, _localPlayer.transform.position) >= _localPlayer.characterParameters.detectionRange)
            return false;

        return true;
    }

    IEnumerator WaitForVisionCheck()
    {
        CheckForBrumeRevelation();
        yield return new WaitForSeconds(characterParameters.delayBetweenDetection);
        StartCoroutine(WaitForVisionCheck());
    }
    #endregion

    //Vars 
    #region 
    public Vector3 directionInputed()
    {
        return Vector3.Normalize(new Vector3(Input.GetAxis("Horizontal"), 0, Input.GetAxis("Vertical")));
    }

    public Vector3 directionOfTheMouse()
    {
        return Vector3.Normalize(mousePos() - transform.position);
    }

    public Vector3 mousePos()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, Mathf.Infinity, 1 << 10))
        {
            return new Vector3(hit.point.x, 0, hit.point.z);
        }
        else
        {
            return Vector3.zero;
        }
    }

    public Vector3 ClosestFreePos(Vector3 _direction, float maxDistance)
    {
        RaycastHit _hit;
        if (Physics.Raycast(transform.position, _direction, out _hit, maxDistance, 1 << 9 | 1 << 19))
        {
            return _hit.point;
        }
        else
            return transform.position + _direction * maxDistance;
    }
    #endregion

    void LockingRotation(bool _isLocked)
    {
        if (_isLocked)
            movementPart.rotLocked = true;
        else
            movementPart.rotLocked = false;
    }
    //STATUS GESTION
    #region
    void TreatEffects()
    {
        List<EffectLifeTimed> _tempList = new List<EffectLifeTimed>();

        for (int i = 0; i < allEffectLive.Count; i++)
        {
            if (!allEffectLive[i].effect.isConstant)
                allEffectLive[i].liveLifeTime -= Time.fixedDeltaTime;

            if (allEffectLive[i].liveLifeTime <= 0)
            {
                _tempList.Add(allEffectLive[i]);
            }
        }

        foreach (EffectLifeTimed _effect in _tempList)
            allEffectLive.Remove(_effect);
    }

    void TreatTickEffects()
    {
        List<EffectLifeTimed> _tempList = new List<EffectLifeTimed>();

        for (int i = 0; i < allTickLive.Count; i++)
        {
            allTickLive[i].liveLifeTime -= Time.fixedDeltaTime;
            allTickLive[i].lastTick += Time.fixedDeltaTime;

            if (allTickLive[i].liveLifeTime <= 0)
            {
                _tempList.Add(allTickLive[i]);
            }

            if (allTickLive[i].lastTick >= allTickLive[i].effect.tickRate && allTickLive[i].liveLifeTime > 0)
            {
                allTickLive[i].lastTick = 0;

                if (mylocalPlayer.isOwner)
                {
                    if (allTickLive[i].effect.isDamaging)
                    {
                        DamagesInfos _temp = new DamagesInfos();
                        _temp.damageHealth = allTickLive[i].effect.tickValue;
                        //REMPLACER ICI LE DEALER PAR LE DEAL D EFFECT
                        this.mylocalPlayer.DealDamages(_temp, transform.position, null, false, true);
                    }
                    if (allTickLive[i].effect.isHealing)
                    {
                        this.mylocalPlayer.HealPlayer(allTickLive[i].effect.tickValue);
                    }
                }

            }
        }

        foreach (EffectLifeTimed _effect in _tempList)
            allTickLive.Remove(_effect);
    }
    public void AddStatus(Effect _statusToAdd)
    {
        Effect _tempTrad = new Effect();
        _tempTrad = _statusToAdd;
        EffectLifeTimed _newElement = new EffectLifeTimed();

        _newElement.liveLifeTime = _tempTrad.finalLifeTime;
        _newElement.baseLifeTime = _tempTrad.finalLifeTime;
        _newElement.effect = _tempTrad;

        if ((_statusToAdd.stateApplied & En_CharacterState.Silenced) != 0)
            cancelSpell?.Invoke(true);


        if (_statusToAdd.forcedKey != 0)
        {
            _newElement.key = _statusToAdd.forcedKey;
        }
        else
        {
            _newElement.key = currentKeyIndex;
            currentKeyIndex++;
        }

        if (_tempTrad.tick)
        {
            if (_tempTrad.refreshOnApply)
            {
                EffectLifeTimed _temp = GetTickEffectByKey(_newElement.key);

                if (_temp != null)
                {
                    _temp.Refresh();
                    return;
                }

            }
            else
            {
                if (_tempTrad.doNotApplyIfExist)
                {
                    EffectLifeTimed _temp = GetTickEffectByKey(_newElement.key);

                    if (_temp != null)
                    {
                        return;
                    }
                }
            }
            allTickLive.Add(_newElement);
        }
        else
        {
            if (_tempTrad.refreshOnApply)
            {
                EffectLifeTimed _temp = GetEffectByKey(_newElement.key);

                if (_temp != null)
                {
                    _temp.Refresh();
                    return;
                }
            }
            else
            {
                if (_tempTrad.doNotApplyIfExist)
                {
                    EffectLifeTimed _temp = GetEffectByKey(_newElement.key);

                    if (_temp != null)
                    {
                        return;
                    }
                }
            }
            allEffectLive.Add(_newElement);
        }

    }
    private EffectLifeTimed GetTickEffectByKey(ushort key)
    {
        foreach (EffectLifeTimed effect in allTickLive)
        {
            if (effect.key == key)
            {
                return effect;
            }
        }

        return null;
    }
    private EffectLifeTimed GetEffectByKey(ushort key)
    {
        foreach (EffectLifeTimed effect in allEffectLive)
        {
            if (effect.key == key)
            {
                return effect;
            }
        }

        return null;
    }
    public bool StopStatus(ushort key)
    {
        EffectLifeTimed _temp = allEffectLive.Where(x => x.key == key).FirstOrDefault();

        if (_temp != null)
        {
            allEffectLive.Remove(_temp);
            _temp.Stop();
            return true;
        }
        return false;
    }
    public void StopTickStatus(ushort key)
    {
        EffectLifeTimed _temp = allTickLive.Where(x => x.key == key).FirstOrDefault();

        if (_temp != null)
        {
            _temp.Stop();
        }
    }
    public void AddState(En_CharacterState _stateToadd)
    {
        _state |= _stateToadd;
    }

    public void RemoveState(En_CharacterState _stateToRemove)
    {
        _state = (_state & ~_stateToRemove);
    }

    #endregion
    // Altars buff
    public void ApplySpeedBuffInServer()
    {
        isAltarSpeedBuffActive = true;
        if (isInBrume)
        {
            mylocalPlayer.SendStatus(enteringBrumeStatus);
        }
    }
    public void ApplyPoisonousBuffInServer()
    {
        isPoisonousEffectActive = true;
    }
    public void SetAltarSpeedBuffState(bool value) // Call when entering brume
    {
        if (value)
        {
            StopStatus(enteringBrumeStatus.effect.forcedKey);
            StopStatus(leavingBrumeStatus.effect.forcedKey);
            mylocalPlayer.SendStatus(enteringBrumeStatus);
        }
        else
        {
            StopStatus(leavingBrumeStatus.effect.forcedKey);
            StopStatus(enteringBrumeStatus.effect.forcedKey);
            mylocalPlayer.SendStatus(leavingBrumeStatus);
        }
    }

    void PingMenace()
    {
        menacedIcon.gameObject.SetActive(true);
    }
    void HideMenace()
    {
        menacedIcon.gameObject.SetActive(false);
    }
    internal void ApplyWxMark(ushort? dealerID = null)
    {
        if (GetEffectByKey(wxMarkRef.effect.forcedKey) == null)
            return;

        if (GetEffectByKey(wxMarkRef.effect.forcedKey).effect.hitBeforeProcOptionnalDamages > 0)
        {
            GetEffectByKey(wxMarkRef.effect.forcedKey).effect.hitBeforeProcOptionnalDamages--;
            return;
        }

        if (!StopStatus(wxMarkRef.effect.forcedKey))
            return;


        // wxMark.SetActive(false);
        DamagesInfos _tempDamages = new DamagesInfos();
        _tempDamages.damageHealth = wxMarkRef.effect.optionalDamagesInfos.damageHealth;

        //REMPLACER ICI LE DEALER PAR LE MEC QUI T APPLY LA MARQUE
        mylocalPlayer.DealDamages(_tempDamages, transform.position, dealerID, true);

        foreach (Sc_Status status in wxMarkRef.effect.optionalDamagesInfos.statusToApply) // already in DealDamage but we dont need to reaply state wx marked
        {
            mylocalPlayer.SendStatus(status);
        }
        mylocalPlayer.SendState(state);
    }
    void BuffInput()
    {
        /*switch(spellInputedRecorded)
		{
			case En_SpellInput.Click:
				leftClick.StartCanalysing(mousePos());
				break;
			case En_SpellInput.FirstSpell:
				firstSpell.StartCanalysing(mousePos());
				break;
			case En_SpellInput.SecondSpell:
				secondSpell.StartCanalysing(mousePos());
				break;
			case En_SpellInput.ThirdSpell:
				thirdSpell.StartCanalysing(mousePos());
				break;
		}

		spellInputedRecorded = En_SpellInput.Null;*/
    }
    public void KillEveryStun()
    {
        foreach (EffectLifeTimed _effect in allEffectLive)
        {
            if ((_effect.effect.stateApplied & En_CharacterState.Root) != 0 || (_effect.effect.stateApplied & En_CharacterState.Silenced) != 0)
            {
                _effect.liveLifeTime = 0;
            }
        }
    }

    public SpellModule ModuleLinkedToInput(En_SpellInput _inputOfTheSpell)
    {
        switch (_inputOfTheSpell)
        {
            case En_SpellInput.FirstSpell:
                return firstSpell;

            case En_SpellInput.SecondSpell:
                return secondSpell;

            case En_SpellInput.ThirdSpell:
                return thirdSpell;

            case En_SpellInput.Click:
                return leftClick;

            case En_SpellInput.Ward:
                return ward;
            case En_SpellInput.TP:
                return tpModule;
        }

        return pingModule;
    }


    public void SetAutoHealState(bool state)
    {
        healTimer = timeHealTick;
        isAutoHealing = state;
    }

    public void WaitForHeal(bool _activation)
    {
        SetAutoHealState(false);
        timerWaitForHeal = timeWaitForHeal;

        isWaitingForHeal = _activation;
    }
}

[System.Flags]
public enum En_CharacterState
{
    Clear = 1 << 0,
    Slowed = 1 << 1,
    SpedUp = 1 << 2,
    Root = 1 << 3,
    Canalysing = 1 << 4,
    Silenced = 1 << 5,
    Crouched = 1 << 6,
    Embourbed = 1 << 7,
    WxMarked = 1 << 8,
    ThirdEye = 1 << 9,
    Hidden = 1 << 10,
    Countering = 1 << 11,
    Invulnerability = 1 << 12,
    Integenbility = 1 << 13,

    Stunned = Silenced | Root,
}

[System.Serializable]
public class DamagesInfos
{

    public DamagesInfos() { }
    public DamagesInfos(ushort damageHealth)
    {
        this.damageHealth = damageHealth;
    }

    [HideInInspector] public string playerName;

    [TabGroup("NormalDamages")] public ushort damageHealth;
    [TabGroup("NormalDamages")] public Sc_Status[] statusToApply;
    [TabGroup("NormalDamages")] public Sc_ForcedMovement movementToApply = null;

    [TabGroup("EffectIfConditionCompleted")] public En_CharacterState stateNeeded = En_CharacterState.Embourbed;
    [TabGroup("EffectIfConditionCompleted")] public ushort additionalDamages;
    [TabGroup("EffectIfConditionCompleted")] public Sc_Status[] additionalStatusToApply;
    [TabGroup("EffectIfConditionCompleted")] public Sc_ForcedMovement additionalMovementToApply = null;

    [HideInInspector]
    public bool isUsable => statusToApply.Length > 0 || damageHealth > 0 || movementToApply != null;
}

[System.Serializable]
public class Effect
{
    public bool tick = false;

    [HorizontalGroup("Group2")] [HideIf("isConstant")] public float finalLifeTime;
    [HorizontalGroup("Group2")] public bool isConstant = false;
    [HorizontalGroup("Group1")] public bool canBeForcedStop = false;
    [HorizontalGroup("Group1")] [ShowIf("canBeForcedStop")] public ushort forcedKey = 0;
    [HorizontalGroup("Group3")] public bool refreshOnApply = false;
    [HorizontalGroup("Group3")] [HideIf("refreshOnApply")] public bool doNotApplyIfExist = false;
    [ShowIf("tick")] [BoxGroup("Tick")] public float tickRate = 0.2f;
    [ShowIf("tick")] [BoxGroup("Tick")] public bool isDamaging = true;
    [ShowIf("tick")] [BoxGroup("Tick")] public bool isHealing = false;
    [ShowIf("tick")] [BoxGroup("Tick")] public ushort tickValue = 0;

    public En_CharacterState stateApplied;
    public bool isHardControl => ((stateApplied & En_CharacterState.Root) != 0 || (stateApplied & En_CharacterState.Silenced) != 0);

    bool isMovementOriented => ((stateApplied & En_CharacterState.Slowed) != 0 || (stateApplied & En_CharacterState.SpedUp) != 0);
    [Range(0, 1)] [ShowIf("isMovementOriented")] public float percentageOfTheMovementModifier = 1;
    [ShowIf("isMovementOriented")] public AnimationCurve decayOfTheModifier = AnimationCurve.Constant(1, 1, 1);

    public DamagesInfos optionalDamagesInfos;
    public int hitBeforeProcOptionnalDamages = 0;
    public Effect() { }
}

[System.Serializable]
public class EffectLifeTimed
{
    public ushort key = 0;

    public Effect effect;
    public float liveLifeTime;
    public float baseLifeTime;

    [HideInInspector] public float lastTick = 0;
    public void Stop()
    {
        liveLifeTime = 0;
    }

    internal void Refresh()
    {
        liveLifeTime = effect.finalLifeTime;
    }
}
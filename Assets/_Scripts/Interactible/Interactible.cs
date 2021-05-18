using DarkRift;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public enum State : ushort
{
    Locked = 0,
    Capturable = 1,
    Captured = 2
}
public class Interactible : MonoBehaviour
{
    [Header("Interactible properties")]
    [TabGroup("InteractiblePart")]
    [HideInInspector] public ushort interactibleID = 0; // Generate in interactibleObjectManager
    [TabGroup("InteractiblePart")]
    public InteractibleType type = InteractibleType.none;
    [TabGroup("InteractiblePart")]
    [SerializeField] protected float interactTime = 5;
    [TabGroup("InteractiblePart")]
    public bool isInteractable = true;
    [TabGroup("InteractiblePart")]
    [HideInInspector] public Team capturingTeam = Team.none;
    [TabGroup("InteractiblePart")]
    [HideInInspector] public PlayerModule capturingPlayerModule;
    [TabGroup("InteractiblePart")]
    public State state = State.Locked;
    [TabGroup("InteractiblePart")]
    public LayerMask playerLayer = ((1 << 7) | (1 << 8));
    [TabGroup("InteractiblePart")]
    public Character[] authorizedCaptureCharacter = new Character[1];
    [TabGroup("InteractiblePart")]
    protected float timer = 0;
    [TabGroup("InteractiblePart")]
    protected bool isCapturing = false;
    [TabGroup("InteractiblePart")]
    protected bool Decapturing = false;
    [TabGroup("InteractiblePart")]
    protected bool paused = false;

    [TabGroup("InteractiblePart")]
    protected List<PlayerModule> playerInZone = new List<PlayerModule>();

    [Header("Color")]
    [TabGroup("InteractiblePart")]
    [SerializeField] protected Color canBeCapturedColor;
    [TabGroup("InteractiblePart")]
    [SerializeField] protected Color noCaptureColor;
    [TabGroup("InteractiblePart")]
    [SerializeField] protected string progressShaderName = "_Apparition";
    [TabGroup("InteractiblePart")] [SerializeField] protected string color1Shader = "_ColorBase1";
    [TabGroup("InteractiblePart")] [SerializeField] protected string color2Shader = "_ColorBase2";
    [TabGroup("InteractiblePart")] [SerializeField] protected string opacityZoneAlphaShader = "_Opacity";
    [Header("UI")]
    [TabGroup("InteractiblePart")]
    [SerializeField] protected MeshRenderer fillImg;
    [TabGroup("InteractiblePart")] public AnimationCurve captureCurve;
    [TabGroup("InteractiblePart")] protected UnityClient client;

    [Header("Map")]
    [TabGroup("InteractiblePart")]
    protected bool showOnMap = true;
    [TabGroup("InteractiblePart")]
    public SpriteRenderer mapIcon;
    [TabGroup("InteractiblePart")]
    [SerializeField] Sprite iconNeutral, iconRed, iconBlue;

    [Header("Audio")]

    [TabGroup("InteractiblePart")] [SerializeField] AudioSource myAudioSource;
    [TabGroup("InteractiblePart")] public string interactibleName = "";
    [TabGroup("InteractiblePart")] public bool showReload = false;
    [TabGroup("InteractiblePart")] [ShowIf("showReload")] public float serverReloadTime;
    private float reloadTimer = 0;
    protected bool reloading = false;
    protected bool isViewed = false;
    [HideInInspector] public bool CheckOnUnlock = false;

    [TabGroup("InteractiblePart")] public Team lastTeamCaptured = Team.none;

    // Tutorial Purpose
    [HideInInspector] public Action<Interactible> OnEnter;
    [HideInInspector] public Action<Interactible> OnExit;
    [HideInInspector] public Action<Interactible> OnCaptured;

    private void Awake()
    {
        client = RoomManager.Instance.client;
        OnVolumeChange(AudioManager.Instance.currentPlayerVolume);

        myAudioSource.enabled = false;
    }

    protected virtual void Init()
    {
        fillImg.material.SetFloat(progressShaderName, 1);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0.1f);
    }

    private void OnEnable()
    {
        GameManager.Instance.OnInteractibleViewChange += OnInteractibleViewChange;
        AudioManager.Instance.OnVolumeChange += OnVolumeChange;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnInteractibleViewChange -= OnInteractibleViewChange;
        AudioManager.Instance.OnVolumeChange -= OnVolumeChange;

        if (OnEnter != null)
            OnEnter -= TutorialManager.Instance.OnInteractibleEntered;
        if (OnExit != null)
            OnExit -= TutorialManager.Instance.OnInteractibleExit;
        if (OnCaptured != null)
            OnCaptured -= TutorialManager.Instance.OnInteractibleCaptured;

    }

    protected virtual void OnVolumeChange(float _value)
    {
        myAudioSource.volume = _value;
    }

    protected virtual void FixedUpdate()
    {
        Capture();

        if (Decapturing)
        {
            timer -= Time.fixedDeltaTime;

            if (timer <= 0)
            {
                SetColorByState();
                timer = 0;
                Decapturing = false;
            }
        }

        if (showReload)
        {
            if (reloading)
            {
                reloadTimer += Time.fixedDeltaTime;
                fillImg.material.SetFloat(progressShaderName, reloadTimer / serverReloadTime);

                if (reloadTimer >= serverReloadTime)
                {
                    reloadTimer = 0;
                    fillImg.material.SetFloat(progressShaderName, 1);
                    reloading = false;
                }
            }
        }
        if (Decapturing)
        {
            VisualCaptureProgress();
        }

    }


    protected virtual void VisualCaptureProgress()
    {
        if (isViewed && reloading == false)
        {
            fillImg.material.SetFloat(progressShaderName, 1 - captureCurve.Evaluate((timer / interactTime)));
        }
    }

    protected virtual void Capture()
    {
        if (capturingPlayerModule != null)
        {
            if (isInteractable && isCapturing && paused == false &&
                capturingPlayerModule.mylocalPlayer == GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID]) // Uniquement si on est le joueur qui capture et que l'on peut capturer
            {
                timer += Time.fixedDeltaTime;

                using (DarkRiftWriter _writer = DarkRiftWriter.Create())
                {
                    _writer.Write(interactibleID);
                    _writer.Write(timer / interactTime);  // 0 --> 1 

                    using (Message _message = Message.Create(Tags.CaptureProgressInteractible, _writer))
                    {
                        client.SendMessage(_message, SendMode.Unreliable);
                    }
                }
            }
        }
        else return;


    }

    public virtual void ProgressInServer(float progress)
    {
        timer = progress * interactTime; // 0 --> interactTime 

        fillImg.material.SetFloat(progressShaderName, 1 - captureCurve.Evaluate((timer / interactTime)));
    }

    public virtual void TryCapture(Team team, PlayerModule capturingPlayer)
    {
        if (state != State.Capturable)
        {
            return;
        }

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(interactibleID);
            _writer.Write((ushort)team);
            _writer.Write((ushort)type);
            _writer.Write(this.transform.position.x);
            _writer.Write(this.transform.position.y);
            _writer.Write(this.transform.position.z);

            using (Message _message = Message.Create(Tags.TryCaptureInteractible, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }

    public virtual void UpdateTryCapture(ushort _capturingPlayerID)
    {
        Decapturing = false;
        capturingPlayerModule = GameManager.Instance.networkPlayers[_capturingPlayerID].myPlayerModule;

        if (NetworkManager.Instance.GetLocalPlayer().ID == _capturingPlayerID)
        {
            isCapturing = true;
            paused = false;
            // timer = 0;
        }
        else
        {
            // timer = 0;
            isCapturing = false;
            paused = false;
        }

        StartAudio();
        capturingTeam = capturingPlayerModule.teamIndex;

        if (isViewed)
        {
            SetColor(GameFactory.GetRelativeColor(capturingTeam));
        }

    }

    public void StartAudio()
    {
        myAudioSource.enabled = true;
    }

    public void PauseCapture(bool v)
    {
        if (v)
        {
            isCapturing = false;
            paused = true;
        }
        else
        {
            isCapturing = true;
            paused = false;
        }

    }

    /// <summary>
    /// Stop une capture en local
    /// </summary>
    /// <param name="team"> Equipe qui arrete de capturer</param>
    public void StopCapturing()
    {
        //  timer = 0;

        if (timer > 0)
        {
            Decapturing = true;
        }
        myAudioSource.enabled = false;

        capturingTeam = Team.none;
        isCapturing = false;
        paused = false;
        capturingPlayerModule = null;

        if (isViewed)
        {
            SetColorByState();
        }
    }


    public virtual void Captured(ushort _capturingPlayerID)
    {
        if (InGameNetworkReceiver.Instance.GetEndGame())
        {
            return;

        }
        OnCaptured?.Invoke(this);

        // SI ON EST LA PERSONNE QUI CAPTURE
    }

    public virtual void UpdateCaptured(ushort _capturingPlayerID)
    {
        capturingPlayerModule = GameManager.Instance.networkPlayers[_capturingPlayerID].myPlayerModule;
        lastTeamCaptured = (capturingPlayerModule.teamIndex);
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
        isCapturing = false;
        fillImg.material.SetFloat(progressShaderName, 0);

        state = State.Captured;


        myAudioSource.enabled = false;

        if (showReload)
        {
            fillImg.material.SetFloat(opacityZoneAlphaShader, 0);
            reloadTimer = 0;
            reloading = true;
            SetColor(Color.black);
        }
        else
        {
            fillImg.material.SetFloat(opacityZoneAlphaShader, 1);
        }

        if (mapIcon != null && showOnMap)
        {
            if (lastTeamCaptured == GameFactory.GetOtherTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam))
                mapIcon.sprite = iconRed;
            else
                mapIcon.sprite = iconBlue;
        }
    }

    public virtual void SetActiveState(bool value)
    {
        isInteractable = value;
    }

    public virtual void Unlock()
    {

        if (isViewed)
        {
            SetColor(canBeCapturedColor);
        }

        fillImg.material.SetFloat(progressShaderName, 1);
        fillImg.material.SetFloat(opacityZoneAlphaShader, 0.1f);
        state = State.Capturable;

        CheckOnUnlock = true;
    }

    protected virtual void SetColorByState()
    {
        if (showReload && reloading)
        {
            SetColor(Color.black);
            return;
        }

        switch (state)
        {
            case State.Locked:
                SetColor(noCaptureColor);
                break;
            case State.Capturable:
                if (capturingPlayerModule == null)
                {
                    if (timer <= 0)
                    {
                        SetColor(canBeCapturedColor);
                    }

                }
                else
                {
                    if (capturingTeam != Team.none)
                    {
                        SetColor(GameFactory.GetRelativeColor(capturingTeam));
                    }
                }

                break;
            case State.Captured:
                if (capturingTeam != Team.none)
                {
                    SetColor(GameFactory.GetRelativeColor(capturingTeam));
                }
                break;
            default:
                break;
        }
    }

    protected void SetColor(Color color)
    {
        fillImg.material.SetColor("_ColorBase2", new Color(color.r, color.g, color.b, 1));
        fillImg.material.SetColor("_ColorBase1", new Color(color.r, color.g, color.b, 1));
    }


    private void OnTriggerEnter(Collider other)
    {

        if (GameFactory.IsInLayer(other.gameObject.layer, playerLayer))
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
            {
                return;
            }


            if (!playerInZone.Contains(_pModule))
            {
                playerInZone.Add(_pModule);
            }


            if (!_pModule.mylocalPlayer.isOwner)
            {
                return;
            }

            if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter)) // Si personnage autorisé
            {
                OnEnter?.Invoke(this);
                CheckOnUnlock = false;
                _pModule.interactiblesClose.Add(this);
                TryCapture(_pModule.teamIndex, _pModule);
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (GameFactory.IsInLayer(other.gameObject.layer, playerLayer))
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
            {
                return;
            }

            if (playerInZone.Contains(_pModule))
            {
                playerInZone.Remove(_pModule);
                PlayerInContestedZoneQuit(_pModule);
            }

            if (!_pModule.mylocalPlayer.isOwner)
            {
                return;
            }

            if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter)) // Si personnage autorisé
            {
                OnExit?.Invoke(this);

                using (DarkRiftWriter _writer = DarkRiftWriter.Create())
                {
                    _writer.Write(interactibleID);

                    using (Message _message = Message.Create(Tags.QuitInteractibleZone, _writer))
                    {
                        client.SendMessage(_message, SendMode.Reliable);
                    }
                }

                if (isCapturing && _pModule.teamIndex == capturingTeam)
                {
                    StopCapturing();
                }

                _pModule.interactiblesClose.Remove(this);
            }
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (CheckOnUnlock)
        {
            if (GameFactory.IsInLayer(other.gameObject.layer, playerLayer))
            {
                PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

                if (_pModule == null)
                {
                    return;
                }

                if (!playerInZone.Contains(_pModule))
                {
                    playerInZone.Add(_pModule);
                }

                if (!_pModule.mylocalPlayer.isOwner)
                {
                    return;
                }



                if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter) && isCapturing == false) // Si personnage autorisé
                {
                    OnEnter?.Invoke(this);
                    _pModule.interactiblesClose.Add(this);
                    TryCapture(_pModule.teamIndex, _pModule);
                }
            }
            CheckOnUnlock = false;
        }
    }


    protected virtual void PlayerInContestedZoneQuit(PlayerModule p) { }

    public virtual bool IsLocallyContested()
    {
        bool containRed = false;
        bool containblue = false;

        foreach (PlayerModule pm in playerInZone)
        {
            if (pm.teamIndex == Team.red)
            {
                containRed = true;
            } else
            {
                containblue = true;
            }

            if (containRed && containblue)
            {
                return true;
            }
        }

        return false;
    }

    public virtual int GetLocalPlayerCountInZone()
    {
        return playerInZone.Count;
    }

    public virtual bool IsLocalPlayerInZoneContainLocalPlayer()
    {
        return playerInZone.Contains(GameFactory.GetActualPlayerFollow().myPlayerModule);
    }


    private void OnInteractibleViewChange(ushort ID, bool value)
    {
        if (interactibleID == ID)
        {
            isViewed = value;

            if (value)
            {
                SetColorByState();
            }
        }
    }

    internal void ForceQuit()
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(interactibleID);

            using (Message _message = Message.Create(Tags.QuitInteractibleZone, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
    }


    public void EventTutorial(InteractibleEvent interactibleEvent)
    {
        switch (interactibleEvent)
        {
            case InteractibleEvent.Entered:
                OnEnter += TutorialManager.Instance.OnInteractibleEntered;
                break;
            case InteractibleEvent.Exit:
                OnExit += TutorialManager.Instance.OnInteractibleExit;
                break;
            case InteractibleEvent.Captured:
                OnCaptured += TutorialManager.Instance.OnInteractibleCaptured;
                break;
            default:
                throw new Exception("not existing event");
        }
    }
}

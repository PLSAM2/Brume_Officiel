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
    public bool contestable = true;
    [TabGroup("InteractiblePart")]
    protected float timer = 0;
    [TabGroup("InteractiblePart")]
    protected bool isCapturing = false;
    [TabGroup("InteractiblePart")]
    protected bool paused = false;

    [Header("Color")]
    [TabGroup("InteractiblePart")]
    [SerializeField] protected Color canBeCapturedColor;
    [TabGroup("InteractiblePart")]
    [SerializeField] protected Color noCaptureColor;

    [Header("UI")]
    [TabGroup("InteractiblePart")]
    [SerializeField] protected Image fillImg;
    [TabGroup("InteractiblePart")]
    [SerializeField] protected Image zoneImg;

    protected UnityClient client;

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
    [TabGroup("InteractiblePart")] [ShowIf("showReload")] public Image reloadImage;
    private float reloadTimer = 0;
    private bool reloading = false;
    private bool isViewed = false;
    [HideInInspector] public bool CheckOnUnlock = false;

    private void Awake()
    {
        client = RoomManager.Instance.client;
        OnVolumeChange(AudioManager.Instance.currentPlayerVolume);

        myAudioSource.enabled = false;
    }

    protected void Init()
    {

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
    }

    void OnVolumeChange(float _value)
    {
        myAudioSource.volume = _value;
    }

    protected virtual void FixedUpdate()
    {
        Capture();

        if (showReload)
        {
            if (reloading)
            {
                reloadTimer += Time.fixedDeltaTime;
                reloadImage.fillAmount = reloadTimer / serverReloadTime;

                if (reloadTimer >= serverReloadTime)
                {
                    reloadTimer = 0;
                    reloadImage.fillAmount = 0;
                    reloading = false;
                }
            }
        }

        if (isViewed && reloading == false)
        {
            fillImg.fillAmount = (timer / interactTime) / 1;
        }
    }

    protected virtual void Capture()
    {
        if (isInteractable && isCapturing && paused == false) // Uniquement si on est le joueur qui capture et que l'on peut capturer
        {
            timer += Time.fixedDeltaTime;

            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(interactibleID);
                _writer.Write((float)Time.fixedDeltaTime / interactTime);

                using (Message _message = Message.Create(Tags.CaptureProgressInteractible, _writer))
                {
                    client.SendMessage(_message, SendMode.Unreliable);
                }
            }
        }
    }

    public void ProgressInServer(float progress)
    {
        timer = progress * interactTime;
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
        capturingPlayerModule = GameManager.Instance.networkPlayers[_capturingPlayerID].myPlayerModule;
        if (NetworkManager.Instance.GetLocalPlayer().ID == _capturingPlayerID)
        {
            isCapturing = true;
            paused = false;
            timer = 0;
        } else
        {
            timer = 0;
            isCapturing = false;
            paused = false;
        }

        myAudioSource.enabled = true;
        capturingTeam = capturingPlayerModule.teamIndex;



        if (isViewed)
        {
            SetColor(GameFactory.GetRelativeColor(capturingTeam));
        }

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
        timer = 0;
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

        //using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        //{
        //    _writer.Write(interactibleID);
        //    _writer.Write((ushort)team);
        //    _writer.Write((ushort)type);

        //    using (Message _message = Message.Create(Tags.CaptureInteractible, _writer))
        //    {
        //        client.SendMessage(_message, SendMode.Reliable);
        //    }
        //}
        // capturingPlayerModule.rotationLock(false);

        // capturingPlayerModule.RemoveState(En_CharacterState.Stunned | En_CharacterState.Canalysing);

        UpdateCaptured(_capturingPlayerID);
    }

    public virtual void UpdateCaptured(ushort _capturingPlayerID)
    {
        capturingPlayerModule = GameManager.Instance.networkPlayers[_capturingPlayerID].myPlayerModule;

        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
        fillImg.fillAmount = 0;
        isCapturing = false;
        state = State.Captured;
        timer = 0;

        myAudioSource.enabled = false;

        if (showReload)
        {
            reloadTimer = 0;
            reloading = true;
        }

        if (mapIcon != null)
        {
            if (capturingPlayerModule.teamIndex == Team.red && showOnMap)
                mapIcon.sprite = iconRed;
            else if (showOnMap)
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

        zoneImg.gameObject.SetActive(true);
        state = State.Capturable;

        CheckOnUnlock = true;
    }

    private void SetColorByState()
    {
        switch (state)
        {
            case State.Locked:
                SetColor(noCaptureColor);
                break;
            case State.Capturable:
                SetColor(canBeCapturedColor);
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

    private void SetColor(Color color)
    {
        fillImg.color = new Color(color.r, color.g, color.b, fillImg.color.a);
        zoneImg.color = new Color(color.r, color.g, color.b, zoneImg.color.a);
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

            if (!_pModule.mylocalPlayer.isOwner)
            {
                return;
            }

            if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter)) // Si personnage autorisé
            {
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

            if (!_pModule.mylocalPlayer.isOwner)
            {
                return;
            }

            if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter)) // Si personnage autorisé
            {

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

                if (!_pModule.mylocalPlayer.isOwner)
                {
                    return;
                }

                if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter)) // Si personnage autorisé
                {
                    _pModule.interactiblesClose.Add(this);
                    TryCapture(_pModule.teamIndex, _pModule);
                }
            }
            CheckOnUnlock = false;
        }
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

}

﻿using DarkRift;
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
    [HideInInspector] public ushort interactibleID = 0; // Generate in interactibleObjectManager
    public InteractibleType type = InteractibleType.none;
    [SerializeField] protected float interactTime = 5;
    public bool isInteractable = true;
    [HideInInspector] public Team capturingTeam = Team.none;
      [HideInInspector]  public PlayerModule capturingPlayerModule;
    public State state = State.Locked;

    public Character[] authorizedCaptureCharacter = new Character[1];
    protected float timer = 0;
    protected bool isCapturing = false;

    [Header("Color")]
    [SerializeField] protected Color canBeCapturedColor;
    [SerializeField] protected Color noCaptureColor;

    [Header("UI")]
    [SerializeField] private Image fillImg;
    [SerializeField] private Image zoneImg;

    protected UnityClient client;

    [Header("Map")]
    protected bool showOnMap= true;
    public SpriteRenderer mapIcon;
    [SerializeField] Sprite iconNeutral, iconRed, iconBlue;

    [Header("Audio")]
    [SerializeField] AudioSource myAudioSource;

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
        AudioManager.Instance.OnVolumeChange += OnVolumeChange;
    }

    private void OnDisable()
    {
        AudioManager.Instance.OnVolumeChange -= OnVolumeChange;
    }

    void OnVolumeChange(float _value)
    {
        myAudioSource.volume = _value;
    }

    protected virtual void FixedUpdate()
    {
        Capture();
        fillImg.fillAmount = (timer / interactTime);
    }

    protected virtual void Capture()
    {
        if (isInteractable && isCapturing) // Uniquement si on est le joueur qui capture et que l'on peut capturer
        {
            timer += Time.fixedDeltaTime;

            if (timer >= interactTime)
            {
                Captured(capturingTeam);
            }

            using (DarkRiftWriter _writer = DarkRiftWriter.Create())
            {
                _writer.Write(interactibleID);
                _writer.Write((float)Time.fixedDeltaTime);

                using (Message _message = Message.Create(Tags.CaptureProgressInteractible, _writer))
                {
                    client.SendMessage(_message, SendMode.Unreliable);
                }
            }
        }

    }
    public void ProgressInServer(float progress)
    {
        timer += progress;
    }

    public virtual void TryCapture(Team team, PlayerModule capturingPlayer)
    {
        if (state != State.Capturable)
        {
            return;
        }

        capturingPlayerModule = capturingPlayer;
        capturingPlayerModule.AddState(En_CharacterState.Stunned);
        isCapturing = true;

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(interactibleID);
            _writer.Write((ushort)team);

            using (Message _message = Message.Create(Tags.TryCaptureInteractible, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }

        UpdateTryCapture(team);
    }

    public virtual void UpdateTryCapture(Team team)
    {
        if (state != State.Capturable)
        {
            return;
        }

        myAudioSource.enabled = true;

        timer = 0;
        capturingTeam = team;

        if (team != NetworkManager.Instance.GetLocalPlayer().playerTeam) // si on est pas de l'équipe qui capture, arreter la capture
        {
            StopCapturing(NetworkManager.Instance.GetLocalPlayer().playerTeam);
        }

        SetColor(GameFactory.GetColorTeam(team));
    }

    /// <summary>
    /// Demande a une équipe de stopper une capture
    /// </summary>
    /// <param name="team"> Equipe qui arrete de capturer</param>
    public virtual void StopCapturing(Team team) 
    {
        if (!isCapturing) // si il ne capture pas
        {
            return;
        }

        myAudioSource.enabled = false;

        capturingPlayerModule.RemoveState(En_CharacterState.Stunned | En_CharacterState.Canalysing);

        if (team == capturingTeam)
        {
            capturingTeam = Team.none;
            isCapturing = false;

            if (state == State.Capturable)
            {
                SetColor(canBeCapturedColor);
            }
            else
            {
                SetColor(noCaptureColor);
            }
        }
    }

    public virtual void Captured(Team team)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(interactibleID); 
            _writer.Write((ushort)team);
            _writer.Write((ushort)type);

            using (Message _message = Message.Create(Tags.CaptureInteractible, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
        capturingPlayerModule.rotationLock(false);

        timer = 0;
        capturingPlayerModule.RemoveState(En_CharacterState.Stunned | En_CharacterState.Canalysing);

        UpdateCaptured(team);
    }

    public virtual void UpdateCaptured(Team team)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant
        fillImg.fillAmount = 0;
        isCapturing = false;
        state = State.Captured;
        timer = 0;

        myAudioSource.enabled = false;

        if(mapIcon != null)
		{
            if (team == Team.red && showOnMap)
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
        SetColor(canBeCapturedColor);
        zoneImg.gameObject.SetActive(true);
        state = State.Capturable;
    }

    private void SetColor(Color color)
    {
        fillImg.color = new Color(color.r, color.g, color.b, fillImg.color.a);
        zoneImg.color = new Color(color.r, color.g, color.b, zoneImg.color.a);
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null || !_pModule.mylocalPlayer.isOwner)
                return;

            if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter)) // Si personnage autorisé
            {
                _pModule.interactiblesClose.Add(this);
            }
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null || !_pModule.mylocalPlayer.isOwner)
                return;

            if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter)) // Si personnage autorisé
            {
                if (isCapturing && _pModule.teamIndex == capturingTeam)
                {
                    StopCapturing(_pModule.teamIndex);
                }

                _pModule.interactiblesClose.Remove(this);
            }
        }
    }

}

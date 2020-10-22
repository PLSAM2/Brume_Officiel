using DarkRift;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
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
    public ushort interactibleID;
    [SerializeField] protected float interactTime = 5;
    public bool isInteractable = true;
    [ReadOnly] public Team capturingTeam = Team.none;
    public State state = State.Locked;

    protected Action<Team> capturedEvent;
    protected Action<Team> leaveEvent;

    public Character[] authorizedCaptureCharacter = new Character[1];
    protected float timer = 0;
    protected bool isCapturing = false;

    protected UnityClient client;

    private void Awake()
    {
        client = RoomManager.Instance.client;
    }
    protected void Init()
    {

    }

    protected virtual void FixedUpdate()
    {
        Capture();
    }

    protected virtual void Capture()
    {
        if (isInteractable && isCapturing) // Uniquement si on est le joueur qui capture et que l'on peut capturer
        {
            timer += Time.fixedDeltaTime;

            if (timer >= interactTime)
            {
                capturedEvent.Invoke(capturingTeam);
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

    public virtual void TryCapture(Team team)
    {
        if (state != State.Capturable)
        {
            return;
        }

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

    }

    public virtual void UpdateTryCapture(Team team)
    {
        if (state != State.Capturable)
        {
            return;
        }

        if (team != RoomManager.Instance.GetLocalPlayer().playerTeam) // si on est pas de l'équie qui capture, arreter la capture
        {
            isCapturing = false;
        }

        capturingTeam = team;

        if (capturingTeam != team)
        {
            StopCapturing(team);
        }

        timer = 0;
    }

    public virtual void StopCapturing(Team team)
    {
        if (!isCapturing) // si il ne catpure déja pas
        {
            return;
        }

        if (team == capturingTeam)
        {
            capturingTeam = Team.none;
            isCapturing = false;
        }
    }

    public virtual void Captured(Team team)
    {
        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(interactibleID);

            _writer.Write((ushort)team);

            using (Message _message = Message.Create(Tags.CaptureInteractible, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }
        timer = 0;
    }

    public virtual void UpdateCaptured(Team team)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant

        isCapturing = false;
        state = State.Captured;
        timer = 0;

        // Detruire ici
    }


    public virtual void SetActiveState(bool value)
    {
        isInteractable = value;
    }

    protected virtual void Unlock()
    {
        state = State.Capturable;
    }


    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.layer == 8)
        {
            PlayerModule _pModule = other.gameObject.GetComponent<PlayerModule>();

            if (_pModule == null)
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

            if (_pModule == null)
                return;

            if (authorizedCaptureCharacter.Contains(RoomManager.Instance.actualRoom.playerList[_pModule.mylocalPlayer.myPlayerId].playerCharacter)) // Si personnage autorisé
            {
                if (isCapturing && _pModule.teamIndex == capturingTeam)
                {
                    leaveEvent.Invoke(_pModule.teamIndex);
                }

                _pModule.interactiblesClose.Remove(this);
            }
        }
    }

}

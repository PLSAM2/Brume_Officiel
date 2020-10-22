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

    [SerializeField] protected float interactTime = 5;
    public bool isInteractable = true;
    [ReadOnly] public Team capturingTeam = Team.none;
    public State state = State.Locked;
    protected Action<Team> capturedEvent;
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
        }
    }

    public virtual void TryCapture(Team team)
    {
        if (state != State.Capturable)
        {
            return;
        }

        capturingTeam = team;
        isCapturing = true;
    }

    public virtual void StopCapturing(Team team)
    {

        if (team == capturingTeam)
        {
            capturingTeam = Team.none;
            isCapturing = false;
        }
    }

    public virtual void Captured(Team team)
    {
        timer = 0;
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
                _pModule.interactiblesClose.Remove(this);
            }
        }
    }

}

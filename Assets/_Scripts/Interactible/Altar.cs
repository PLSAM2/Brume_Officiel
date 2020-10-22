
using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;



public class Altar : Interactible
{
    [Header("Altar properties")]
    public int life;
    public float unlockTime;

    [Header("Color")]
    public Color redTeamCaptureColor;
    public Color blueTeamCaptureColor;
    public Color canBeCapturedColor;
    public Color noCaptureColor;

    [Header("UI")]
    [SerializeField] private Image fillImg;
    [SerializeField] private Image zoneImg;

    void Start()
    {
        base.Init();
        base.capturedEvent += Captured;
        base.leaveEvent += StopCapturing;
        isInteractable = false;
    }

    private void OnDisable()
    {
        base.capturedEvent -= Captured;
        base.leaveEvent -= StopCapturing;
    }

    protected override void FixedUpdate()
    {
        base.Capture();
        fillImg.fillAmount = (timer / interactTime);
    }

    public override void Captured(Team team)
    {
        // Uniquement lancé par la personne capturant l'altar
        base.Captured(team);

        UpdateCaptured(team);
    }

    public override void UpdateCaptured(Team team)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant

        base.UpdateCaptured(team);

        fillImg.fillAmount = 0;

        // Detruire ici
    }


    public override void TryCapture(Team team)
    {
        base.TryCapture(team);

        UpdateTryCapture(team);
    }



    public override void StopCapturing(Team team)
    {
        base.StopCapturing(team);

        if (team == capturingTeam)
        {
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
    public override void UpdateTryCapture(Team team)
    {
        base.UpdateTryCapture(team);

        if (state != State.Capturable)
        {
            return;
        }
        switch (team)
        {
            case Team.red:
                SetColor(redTeamCaptureColor);
                break;
            case Team.blue:
                SetColor(blueTeamCaptureColor);
                break;
            default:
                Debug.Log("ERROR NO TEAM");
                break;
        }
    }

    public override void SetActiveState(bool value)
    {
        base.SetActiveState(value);

        if (value)
        {
            StartCoroutine(ActivateAltar());
        }
    }
    protected override void Unlock()
    {
        base.Unlock();

        SetColor(canBeCapturedColor);
        zoneImg.gameObject.SetActive(true);
    }

    IEnumerator ActivateAltar()
    {
        yield return new WaitForSeconds(unlockTime);

        Unlock();
    }

    private void SetColor(Color color)
    {
        fillImg.color = new Color(color.r, color.g, color.b, fillImg.color.a);
        zoneImg.color = new Color(color.r, color.g, color.b, zoneImg.color.a);
    }



}

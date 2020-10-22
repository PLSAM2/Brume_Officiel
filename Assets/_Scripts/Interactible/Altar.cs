
using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;



public class Altar : Interactible
{
    [Header("Altar properties")]
    public ushort altarID;
    public int life;
    public float unlockTime;

    [Header("Color")]
    public Color redTeamCaptureColor;
    public Color blueTeamCaptureColor;
    public Color contestCaptureColor;
    public Color noCaptureColor;

    [Header("UI")]
    [SerializeField] private Image fillImg;
    [SerializeField] private Image zoneImg;

    void Start()
    {
        base.Init();
        base.capturedEvent += Captured;
        isInteractable = false;
    }

    private void OnDisable()
    {
        base.capturedEvent -= Captured;
    }

    protected override void FixedUpdate()
    {
        Capture();
        fillImg.fillAmount = (timer / interactTime);
    }

    protected override void Capture()
    {
        base.Capture();

        if (!isInteractable || !isCapturing)
        {
            return;
        }

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(altarID);
            _writer.Write((float)Time.fixedDeltaTime);

            using (Message _message = Message.Create(Tags.CaptureProgressAltar, _writer))
            {
                client.SendMessage(_message, SendMode.Unreliable);
            }
        }
    }

    public override void Captured(Team team)
    {
        // Uniquement lancé par la personne capturant l'altar

        UpdateCaptured(team);

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(altarID);
            _writer.Write((ushort)team);

            using (Message _message = Message.Create(Tags.CaptureAltar, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }

    }

    public void UpdateCaptured(Team team)
    {
        // Recu par tout les clients quand l'altar à finis d'être capturé par la personne le prenant

        isCapturing = false;
        state = State.Captured;
        fillImg.fillAmount = 0;
        base.Captured(team);

        // Detruire ici
    }


    public override void TryCapture(Team team)
    {
        base.TryCapture(team);

        UpdateCaptureProgress(team);

        using (DarkRiftWriter _writer = DarkRiftWriter.Create())
        {
            _writer.Write(altarID);
            _writer.Write((ushort)team);

            using (Message _message = Message.Create(Tags.TryCaptureAltar, _writer))
            {
                client.SendMessage(_message, SendMode.Reliable);
            }
        }


    }

    public void UpdateCaptureProgress(Team team)
    {
        if (state != State.Capturable)
        {
            return;
        }

        timer = 0;

        switch (team)
        {
            case Team.red:
                fillImg.color = new Color(redTeamCaptureColor.r, redTeamCaptureColor.g, redTeamCaptureColor.b, fillImg.color.a);
                zoneImg.color = new Color(redTeamCaptureColor.r, redTeamCaptureColor.g, redTeamCaptureColor.b, zoneImg.color.a);
                break;
            case Team.blue:
                fillImg.color = new Color(blueTeamCaptureColor.r, blueTeamCaptureColor.g, blueTeamCaptureColor.b, fillImg.color.a);
                zoneImg.color = new Color(blueTeamCaptureColor.r, blueTeamCaptureColor.g, blueTeamCaptureColor.b, zoneImg.color.a);
                break;
            default:
                Debug.Log("ERROR NO TEAM");
                break;
        }
    }

    public void ProgressInServer(float progress)
    {
        timer += progress;
    }

    public override void StopCapturing(Team team)
    {
        base.StopCapturing(team);

        if (team == capturingTeam)
        {
            fillImg.color = new Color(noCaptureColor.r, noCaptureColor.g, noCaptureColor.b, fillImg.color.a);
            zoneImg.color = new Color(noCaptureColor.r, noCaptureColor.g, noCaptureColor.b, zoneImg.color.a);
        }
    }


    public void SetActiveState(bool value)
    {
        isInteractable = value;

        if (value)
        {
            StartCoroutine(ActivateAltar());
        }
    }

    IEnumerator ActivateAltar()
    {
        yield return new WaitForSeconds(unlockTime);

        Unlock();
    }

    private void Unlock()
    {
        zoneImg.gameObject.SetActive(true);
        state = State.Capturable;
    }

}

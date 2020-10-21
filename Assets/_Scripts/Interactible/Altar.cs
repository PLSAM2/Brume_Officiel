using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public enum AltarState : ushort
{
    Locked = 0,
    Capturable = 1,
    Captured = 2
}

public class Altar : Interactible
{
    [Header("Altar properties")]
    public AltarState altarState = AltarState.Locked;
    public Character[] authorizedCaptureCharacter = new Character[1];
    public Team teamOwner = Team.none;

    public int life;
    public float unlockTime;

    [SerializeField] private Image fillImg;
    void Start()
    {
        base.capturedEvent += Captured;

        base.Init();

        isInteractable = false;
    }

    protected override void Update()
    {
        if (altarState == AltarState.Capturable)
        {
            base.Update();

            fillImg.fillAmount = (timer / interactTime);
        }

    }

    protected override void Captured()
    {
        altarState = AltarState.Captured;
        fillImg.fillAmount = 0;
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
        altarState = AltarState.Capturable;

    }
    void Destroy()
    {

    }
}

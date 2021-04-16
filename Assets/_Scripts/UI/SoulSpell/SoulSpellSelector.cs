using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class SoulSpellSelector : MonoBehaviour
{
    public Image fillImgTimer;
    public TextMeshProUGUI timerText;
    public Gradient colorTimer;

    public float timer = 15;
    float currentTimer;
    bool startTimer = false;

    public SoulSpellElement ward;
    public SoulSpellElement tp;
    public SoulSpellElement thirdEye;
    public SoulSpellElement invisible;

    public En_SoulSpell currentSoulSpell = En_SoulSpell.none;

    List<SoulSpellElement> activeSoulSpell = new List<SoulSpellElement>();

    [HideInInspector]
    public SoulSpellElement currentSpell;

    private void Start()
    {
        timerText.text = timer + "s";
        fillImgTimer.fillAmount = 1;
        fillImgTimer.color = colorTimer.Evaluate( 1- fillImgTimer.fillAmount);
    }

    void Update()
    {
        if (startTimer)
        {
            currentTimer -= Time.deltaTime;

            timerText.text = Mathf.RoundToInt(currentTimer) + "s";
            fillImgTimer.fillAmount = currentTimer / timer;
            fillImgTimer.color = colorTimer.Evaluate(1 - fillImgTimer.fillAmount);

            if (currentTimer <= 0.0f)
            {
                StartCoroutine(OnTimerFinish());
                startTimer = false;

                timerText.text = "Waiting player ...";
                fillImgTimer.fillAmount = 0;
            }
        }
    }

    public void StartTimer()
    {
        currentTimer = timer;
        startTimer = true;

        switch (NetworkManager.Instance.GetLocalPlayer().playerCharacter)
        {
            case Character.WuXin:
                ward.gameObject.SetActive(true);
                thirdEye.gameObject.SetActive(true);
                invisible.gameObject.SetActive(true);

                activeSoulSpell.Add(ward); activeSoulSpell.Add(thirdEye); activeSoulSpell.Add(invisible);
                break;

            case Character.Re:
                ward.gameObject.SetActive(true);
                tp.gameObject.SetActive(true);
                invisible.gameObject.SetActive(true);

                activeSoulSpell.Add(ward); activeSoulSpell.Add(tp); activeSoulSpell.Add(invisible);
                break;

            case Character.Leng:
                ward.gameObject.SetActive(true);
                tp.gameObject.SetActive(true);

                activeSoulSpell.Add(ward); activeSoulSpell.Add(tp);
                break;
        }
    }

    IEnumerator OnTimerFinish()
    {
        if(currentSoulSpell == En_SoulSpell.none)
        {
            currentSoulSpell = activeSoulSpell[0].mySoulSpell;
            activeSoulSpell[0].OnClickBtn();
        }

        foreach(SoulSpellElement soulSpell in activeSoulSpell)
        {
            if(soulSpell.mySoulSpell != currentSoulSpell)
            {
                soulSpell.Hide();
            }
        }

        GameManager.Instance.currentLocalPlayer.myPlayerModule.InitSoulSpell(currentSoulSpell);

        yield return new WaitForSeconds(2);

        RoomManager.Instance.ImReady();
    }
}

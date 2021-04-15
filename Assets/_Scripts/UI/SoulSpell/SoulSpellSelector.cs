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

    public SoulSpell currentSoulSpell = SoulSpell.none;

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

            timerText.text = Mathf.RoundToInt(timer) + "s";
            fillImgTimer.fillAmount = 1;
            fillImgTimer.color = colorTimer.Evaluate(1 - fillImgTimer.fillAmount);
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
                break;

            case Character.Re:
                ward.gameObject.SetActive(true);
                tp.gameObject.SetActive(true);
                invisible.gameObject.SetActive(true);
                break;

            case Character.Leng:
                ward.gameObject.SetActive(true);
                tp.gameObject.SetActive(true);
                break;
        }
    }

    void OnTimerFinish()
    {
        if(currentSoulSpell == SoulSpell.none)
        {

        }
    }
}

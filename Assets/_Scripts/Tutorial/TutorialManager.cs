using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class TutorialManager : MonoBehaviour
{
    private static TutorialManager _instance;
    public static TutorialManager Instance { get { return _instance; } }

    public List<TutorialQuest> tutorialQuests = new List<TutorialQuest>();
    public TutorialQuest actualQuest;
    
    public int step = 0;

    List<QuestStepUI> questStepUIs = new List<QuestStepUI>();

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    public void PlayerSpawned()
    {
        PlayerPrefs.SetInt("SoulSpell", (int)En_SoulSpell.Invisible);
        GameManager.Instance.currentLocalPlayer.myPlayerModule.InitSoulSpell(En_SoulSpell.Invisible);

        RoomManager.Instance.ImReady();
        UiManager.Instance.StartTutorial();
        actualQuest = tutorialQuests[step];
    }

    public List<QuestStep> HaveAQuestStepOfThisType(QuestEvent qe)
    {
        List<QuestStep> _temp = new List<QuestStep>();

        foreach (QuestStep qs in actualQuest.questSteps)
        {
            if (qs.questEvent == qe)
            {
                _temp.Add(qs);
            }
        }

        return _temp;
    }

    private void CheckQuestEnd()
    {
        bool ended = true;

        foreach (QuestStep steps in actualQuest.questSteps)
        {
            if (steps.completed != true)
            {
                ended = false;
                break;
            }
        }

        if (ended)
        {
            StartNextQuest();
        }
    }

    public void StartNextQuest()
    {
        step++;

        actualQuest = tutorialQuests[step];

        InitQuestUi();
    }

    public void InitQuestUi()
    {
        for (int i = 0; i < actualQuest.questSteps.Count; i++)
        {
            questStepUIs[i].Init(actualQuest.questSteps[i]);
        }
    }


    // EVENT --- 
    public void OnInteractibleEntered(Interactible inter)
    {
        inter.OnEnter -= OnInteractibleEntered;

       List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.InteractibleEvent);

        foreach (QuestStep questS in qs)
        {
            if (questS.interactibleEvent == InteractibleEvent.Entered)
            {
                questS.completed = true;
            } 
        }

        CheckQuestEnd();
    }



    public void OnInteractibleExit(Interactible inter)
    {
        inter.OnExit -= OnInteractibleExit;

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.InteractibleEvent);

        foreach (QuestStep questS in qs)
        {
            if (questS.interactibleEvent == InteractibleEvent.Exit)
            {
                questS.completed = true;
            }
        }

        CheckQuestEnd();
    }

    public void OnInteractibleCaptured(Interactible inter)
    {
        inter.OnCaptured -= OnInteractibleCaptured;

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.InteractibleEvent);

        foreach (QuestStep questS in qs)
        {
            if (questS.interactibleEvent == InteractibleEvent.Captured)
            {
                questS.completed = true;
            }
        }

        CheckQuestEnd();
    }

    public void OnDummyHit(Dummy dummy)
    {
        dummy.OnHit -= OnDummyHit;
    }

    public void OnDummyKilled(Dummy dummy)
    {
        dummy.OnKilled -= OnDummyKilled;
    }

    public void OnMystEnter(PlayerModule pm)
    {
        pm.OnMystEnter -= OnMystEnter;
    }

    public void OnMystExit(PlayerModule pm)
    {
        pm.OnMystExit -= OnMystExit;
    }


    // ------

}

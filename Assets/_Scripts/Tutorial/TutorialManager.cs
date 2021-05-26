using DarkRift;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.SceneManagement;
using static GameData;

public class TutorialManager : MonoBehaviour
{
    private static TutorialManager _instance;
    public static TutorialManager Instance { get { return _instance; } }

    public List<TutorialQuest> tutorialQuests = new List<TutorialQuest>();

    private TutorialQuest actualQuest;

    private int step = 0;
    [Header("REF")]
    public List<Dummy> dummies = new List<Dummy>();

    [Header("UI")]
    public List<QuestStepUI> questStepUIs = new List<QuestStepUI>();
    public TextMeshProUGUI questTileUiText;
    public GameObject tutorialQuestUiPanel;
    public GameObject EndTutorialPanel;

    [Header("Events")]
    public UnityEvent OnQuestStarted;
    public UnityEvent OnQuestEnded;

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

    private void OnDisable()
    {
        foreach (TutorialQuest tq in tutorialQuests)
        {
            foreach (QuestStep qs in tq.questSteps)
            {
                qs.Reset();
            }
        }
    }


    public void PlayerSpawned()
    {
        PlayerPrefs.SetInt("SoulSpell", (int)En_SoulSpell.Invisible);
        GameManager.Instance.currentLocalPlayer.myPlayerModule.InitSoulSpell(En_SoulSpell.Invisible);
        RoomManager.Instance.ImReady();
        UiManager.Instance.StartTutorial();


        actualQuest = tutorialQuests[step];
        InitAllNewQuestEvents();
        InitQuestUi();
    }

    public List<QuestStep> HaveAQuestStepOfThisType(QuestEvent qe)
    {
        List<QuestStep> _temp = new List<QuestStep>();

        foreach (QuestStep qs in actualQuest.questSteps)
        {
            if (qs.questEvent == qe && qs.completed != true)
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
            OnQuestEnded?.Invoke();
            actualQuest.OnQuestEnded?.Invoke();
            foreach (QuestStep steps in actualQuest.questSteps)
            {
                steps.Reset();
            }

            StartNextQuest();
        }
    }

    public void StartNextQuest()
    {
        step++;

        if (tutorialQuests.Count == step)
        {
            EndTutorial();
            return;
        } else
        {
            OnQuestStarted?.Invoke();
            actualQuest = tutorialQuests[step];

            actualQuest.OnQuestStarted?.Invoke();

            InitAllNewQuestEvents();
            InitQuestUi();
        }
    }


    public void EndTutorial()
    {
        tutorialQuestUiPanel.SetActive(false);
        EndTutorialPanel.SetActive(true);

        foreach (TutorialQuest tq in tutorialQuests)
        {
            foreach (QuestStep qs in tq.questSteps)
            {
                qs.Reset();
            }
        }

        step = 0;
    }

    public void StartTraining()
    {
        using (DarkRiftWriter writer = DarkRiftWriter.Create())
        {
            writer.Write((ushort)RoomType.Training);

            using (Message message = Message.Create(Tags.ConvertPrivateRoomType, writer))
                RoomManager.Instance.client.SendMessage(message, SendMode.Reliable);
        }

    }

    public void StartTrainingInServer()
    {
        SceneManager.LoadScene(RoomManager.Instance.loadingTrainingScene);
    }

    public void ReturnToMenu()
    {
        SceneManager.LoadScene(RoomManager.Instance.menuScene);
    }

    public void InitAllNewQuestEvents()
    {
        foreach (QuestStep qs in actualQuest.questSteps)
        {
            switch (qs.questEvent)
            {
                case QuestEvent.KeyPressed:
                    GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].myPlayerModule.tutorialListeningInput = true;
                    break;
                case QuestEvent.ZoneToTrigger:
                    qs.zoneToTrigger.EventTutorial(qs.zoneEvent);
                    break;
                case QuestEvent.InteractibleEvent:

                    List<Interactible> _temp = new List<Interactible>();

                    if (qs.focusedInteractible != null) // Get all interactible targeted
                    {
                        _temp.Add(qs.focusedInteractible.GetComponent<Interactible>());
                    }
                    else
                    {
                        if (qs.interactibleType != InteractibleType.none)
                        {
                            _temp = InteractibleObjectsManager.Instance.GetAllOfType(qs.interactibleType);
                        }
                        else
                        {
                            _temp = InteractibleObjectsManager.Instance.GetAllInteractible();
                        }
                    }

                    foreach (Interactible inter in _temp) // Subscribe all interactible
                    {
                        inter.EventTutorial(qs.interactibleEvent);
                    }

                    break;
                case QuestEvent.DummyEvent:

                    List<Dummy> _tempDummys = new List<Dummy>();

                    if (qs.focusedDummy != null) 
                    {
                        _tempDummys.Add(qs.focusedDummy);
                    }
                    else
                    {
                        _tempDummys = dummies; // Get all
                    }

                    foreach (Dummy dum in _tempDummys) // Subscribe 
                    {
                        dum.EventTutorial(qs.dummyEvent);
                    }
                    break;
                case QuestEvent.MystEvent:
                    GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].myPlayerModule.EventTutorial(qs.mystEvent);
                    break;
                case QuestEvent.MovementEvent:
                    switch (qs.movementEvent)
                    {
                        case MovementEvent.Walk:
                            GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].myPlayerModule.EventTutorial(qs.movementEvent);                 
                    break;
                        case MovementEvent.WatchCameraBorder:
                           CameraManager.Instance.EventTutorial(qs.movementEvent);
                            break;
                        default:
                            break;
                    }

                        

                    break;
                default:
                    throw new Exception("not existing event");
            }
        }
    }



    public void InitQuestUi()
    {
        questTileUiText.text = actualQuest.questTitle;
        for (int i = 0; i < actualQuest.questSteps.Count; i++)
        {
            questStepUIs[i].Init(actualQuest.questSteps[i]);
            actualQuest.questSteps[i].UI = questStepUIs[i];
        }
    }


    public void CompleteQuest(QuestStep qs)
    {
        qs.completed = true;

        qs.UI.End();
    }
    public void ProgressKeyQuest(QuestStep qs)
    {
        qs.UI.ProgressKeyQuest(qs);
    }



    // EVENT --- 


    internal void GetKeyPressed(KeyCode keyCode)
    {

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.KeyPressed);

        foreach (QuestStep questS in qs)
        {
            for (int i = 0; i < questS.keyToPress.Count; i++)
            {
                if (questS.keyToPress[i].key == keyCode && questS.keyToPress[i].pressed == false)
                {
                    questS.keyToPress[i].KeyPress();

                    ProgressKeyQuest(questS);
                    if (CheckKeyQuestCompleteState(questS))
                    {
                       
                        CompleteQuest(questS);

                        if (HaveAQuestStepOfThisType(QuestEvent.KeyPressed).Count == 0)
                        {
                            GameManager.Instance.networkPlayers[NetworkManager.Instance.GetLocalPlayer().ID].myPlayerModule.tutorialListeningInput = false;
                        }
                    }

                    break;
                }
            }
        }

        CheckQuestEnd();
    }

    internal void GetKeyPressed(int mouse)
    {
        KeyCode m = KeyCode.Mouse0;

        if (mouse == 0)
        {
           m = KeyCode.Mouse0;
        } else if(mouse == 1) 
        {
            m = KeyCode.Mouse1;
        } else if(mouse == 2) 
        {
            m = KeyCode.Mouse2;
        } else if(mouse == 3) 
        {
            m = KeyCode.Mouse3;
        } else if(mouse == 4) 
        {
            m = KeyCode.Mouse4;
        } else if(mouse == 5) 
        {
            m = KeyCode.Mouse5;
        } else if(mouse == 6) 
        {
            m = KeyCode.Mouse6;
        }
        GetKeyPressed(m);
    }

    private bool CheckKeyQuestCompleteState(QuestStep questS)
    {
        for (int i = 0; i < questS.keyToPress.Count; i++)
        {
            if (questS.keyToPress[i].pressed == false)
            {
                return false;
            }
        }
        return true;
    }

    public void OnZoneEnter(TutorialTriggerZone ttz)
    {
        ttz.OnEnter -= OnZoneEnter;

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.ZoneToTrigger);

        foreach (QuestStep questS in qs)
        {
            if (questS.zoneEvent == ZoneEvent.Entered)
            {
                CompleteQuest(questS);

            }
        }

        CheckQuestEnd();
    }

    public void OnZoneExit(TutorialTriggerZone ttz)
    {
        ttz.OnExit -= OnZoneExit;

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.ZoneToTrigger);

        foreach (QuestStep questS in qs)
        {
            if (questS.zoneEvent == ZoneEvent.Exit)
            {
                CompleteQuest(questS);
            }
        }

        CheckQuestEnd();
    }

    public void OnInteractibleEntered(Interactible inter)
    {
        inter.OnEnter -= OnInteractibleEntered;

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.InteractibleEvent);

        foreach (QuestStep questS in qs)
        {
            if (questS.interactibleEvent == InteractibleEvent.Entered)
            {
                CompleteQuest(questS);
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
                CompleteQuest(questS);
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
                CompleteQuest(questS);
            }
        }
        CheckQuestEnd();
    }


    public void OnDummyHit(Dummy dummy)
    {
        dummy.OnHit -= OnDummyHit;

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.DummyEvent);
        foreach (QuestStep questS in qs)
        {
            if (questS.dummyEvent == DummyEvent.Hit)
            {
                CompleteQuest(questS);
            }
        }
        CheckQuestEnd();
    }

    public void OnDummyKilled(Dummy dummy)
    {
        dummy.OnKilled -= OnDummyKilled;


        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.DummyEvent);
        foreach (QuestStep questS in qs)
        {
            if (questS.dummyEvent == DummyEvent.Kill)
            {
                CompleteQuest(questS);
            }
        }
        CheckQuestEnd();
    }

    public void OnMystEnter(PlayerModule pm)
    {
        pm.OnMystEnter -= OnMystEnter;

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.MystEvent);
        foreach (QuestStep questS in qs)
        {
            if (questS.mystEvent == MystEvent.Entered)
            {
                CompleteQuest(questS);
            }
        }
        CheckQuestEnd();
    }

    public void OnMystExit(PlayerModule pm)
    {
        pm.OnMystExit -= OnMystExit;


        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.MystEvent);
        foreach (QuestStep questS in qs)
        {
            if (questS.mystEvent == MystEvent.Exit)
            {
                CompleteQuest(questS);
            }
        }
        CheckQuestEnd();
    }

    public void OnWalk(PlayerModule pm)
    {
        pm.OnWalk -= OnWalk;

        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.MovementEvent);
        foreach (QuestStep questS in qs)
        {
            if (questS.movementEvent == MovementEvent.Walk)
            {
                CompleteQuest(questS);
            }
        }
        CheckQuestEnd();
    }

    internal void OnWatchCameraBorder(CameraManager obj)
    {
        obj.OnWatchCameraBorder -= OnWatchCameraBorder;
        obj.listeningCameraInput = false;
        List<QuestStep> qs = HaveAQuestStepOfThisType(QuestEvent.MovementEvent);

        foreach (QuestStep questS in qs)
        {
            if (questS.movementEvent == MovementEvent.WatchCameraBorder)
            {
                CompleteQuest(questS);
            }
        }

        CheckQuestEnd();
    }


    // ------

}

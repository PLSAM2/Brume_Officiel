using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Events;
using UnityEngine;

[Serializable]
public class TutorialQuest 
{
    [Title("Tutorial Quest ")]
    public string questTitle = "";
    [Header("Events")]
    public UnityEvent OnQuestStarted;
    public UnityEvent OnQuestEnded;

    [Header("Steps")]
    public List<QuestStep> questSteps = new List<QuestStep>();
}
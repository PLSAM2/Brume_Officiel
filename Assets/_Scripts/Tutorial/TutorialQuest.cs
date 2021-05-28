using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Events;
using UnityEngine;

[Serializable]
public class TutorialQuest 
{
    [FoldoutGroup("Quest")]
    [Title("Tutorial Quest ")] 
    public string questTitle = "";
    [FoldoutGroup("Quest")]
    [Header("Events")]
    public UnityEvent OnQuestStarted;
    [FoldoutGroup("Quest")] public UnityEvent OnQuestEnded;
    [FoldoutGroup("Quest")]
    [Header("Steps")]
    public List<QuestStep> questSteps = new List<QuestStep>();
}
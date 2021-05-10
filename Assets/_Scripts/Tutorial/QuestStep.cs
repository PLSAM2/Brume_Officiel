using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

[Serializable]
public class QuestStep 
{
    public QuestEvent questEvent;
    public string stepDescription = "";

    public bool completed = false;
    public QuestStepUI UI;
    // --------------------------------

    [ShowIf("questEvent", QuestEvent.InteractibleEvent)] public InteractibleEvent interactibleEvent;
    [ShowIf("questEvent", QuestEvent.InteractibleEvent)] [LabelText("Optionnal --> any interactible")] public GameObject focusedInteractible;
    [ShowIf("questEvent", QuestEvent.InteractibleEvent)] [HideIf("focusedInteractible")] public InteractibleType interactibleType;

    // --------------------------------

    [ShowIf("questEvent", QuestEvent.DummyEvent)] public DummyEvent dummyEvent;
    [ShowIf("questEvent", QuestEvent.DummyEvent)] [LabelText("Optionnal --> any dummy")] public GameObject focusedDummy;
    // --------------------------------

    [ShowIf("questEvent", QuestEvent.MystEvent)] public MystEvent mystEvent;

    // --------------------------------

    [ShowIf("questEvent", QuestEvent.MovementEvent)] public MovementEvent movementEvent;

    // --------------------------------
}

public enum QuestEvent
{
    KeyPressed,
    ZoneEntered,
    InteractibleEvent,
    DummyEvent,
    MystEvent,
    MovementEvent
}

public enum InteractibleEvent
{
    Entered,
    Exit,
    Captured
}


public enum DummyEvent
{
    Hit,
    Kill
}

public enum MystEvent
{
    Entered,
    Exit
}

public enum MovementEvent
{
    Walk,
    Run
}

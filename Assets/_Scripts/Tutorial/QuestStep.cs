using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

[Serializable]
public class QuestStep 
{
    [Title("Quest Step ")]
    public QuestEvent questEvent;
    public string stepDescription = "";

   [HideInInspector] public bool completed = false;
   [HideInInspector] public QuestStepUI UI;

    [ShowIf("questEvent", QuestEvent.KeyPressed)] public List<PairKeycodeBool> keyToPress;

    [ShowIf("questEvent", QuestEvent.ZoneToTrigger)] public ZoneEvent zoneEvent;
    [ShowIf("questEvent", QuestEvent.ZoneToTrigger)] [LabelText("Zone ID ref")] public int zoneToTrigger;

    // --------------------------------

    [ShowIf("questEvent", QuestEvent.InteractibleEvent)] public InteractibleEvent interactibleEvent;
    [ShowIf("questEvent", QuestEvent.InteractibleEvent)] [InfoBox("Optionnal target --> null == all of Type")] public GameObject focusedInteractible;
    [ShowIf("questEvent", QuestEvent.InteractibleEvent)] [HideIf("focusedInteractible")] public InteractibleType interactibleType;

    // --------------------------------

    [ShowIf("questEvent", QuestEvent.DummyEvent)] public DummyEvent dummyEvent;
    [ShowIf("questEvent", QuestEvent.DummyEvent)] [InfoBox("Optionnal target --> NULL == any Dummy")] public Dummy focusedDummy;

    // --------------------------------

    [ShowIf("questEvent", QuestEvent.MystEvent)] public MystEvent mystEvent;

    // --------------------------------

    [ShowIf("questEvent", QuestEvent.MovementEvent)] public MovementEvent movementEvent;

    
    internal void Reset()
    {
        completed = false;

        for (int i = 0; i < keyToPress.Count; i++)
        {
            keyToPress[i].pressed = false;
        }

    }

    // --------------------------------
}

public enum QuestEvent
{
    KeyPressed,
    ZoneToTrigger,
    InteractibleEvent,
    DummyEvent,
    MystEvent,
    MovementEvent
}

public enum ZoneEvent
{
    Entered,
    Exit
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
    Walk
}

[Serializable]
public class PairKeycodeBool
{
    public KeyCode key;
    [HideInInspector] public bool pressed;
}

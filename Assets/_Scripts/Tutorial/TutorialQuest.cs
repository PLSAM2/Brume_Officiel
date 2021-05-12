using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[InlineEditor]
[CreateAssetMenu(fileName = "NewSpell", menuName = "Custom/Tutorial Quest")]
public class TutorialQuest : ScriptableObject
{
    public string questTitle = "";

    public List<QuestStep> questSteps = new List<QuestStep>();

}



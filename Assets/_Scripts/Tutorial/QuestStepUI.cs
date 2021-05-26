using DG.Tweening;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class QuestStepUI : MonoBehaviour
{

    public Text descriptionText;
    public Animator QuestStepUI_Animator;

    public void Init(QuestStep qs)
    {
        QuestStepUI_Animator.SetBool("Complete", false);
        if (qs.questEvent == QuestEvent.KeyPressed)
        {
            ProgressKeyQuest(qs);
            descriptionText.DOText(descriptionText.text, 0.7f, true, ScrambleMode.Lowercase);
        } else
        {
         
            descriptionText.DOText(qs.stepDescription, 0.7f, true, ScrambleMode.Lowercase);
        }

        gameObject.SetActive(true);
    }


    public void ProgressKeyQuest(QuestStep qs) {

        string _temp = "";

        _temp += qs.stepDescription;

        foreach (PairKeycodeBool pair in qs.keyToPress)
        {
            string keyName = TransformKeyName(pair.key);

            if (pair.pressed)
            {
                _temp += " <color=green> " + keyName + "</color>";
            } else
            {
                _temp += " <color=white> " + keyName + "</color>";
            }

        }

        descriptionText.text = _temp; 

    }


    public string TransformKeyName(KeyCode key)
    {
        string _temp = "";

        switch (key)
        {
            case KeyCode.Mouse0:
                _temp = "Left-Click";
                break;
            case KeyCode.Mouse1:
                _temp = "Right-Click";
                break;
            case KeyCode.Mouse2:
                _temp = "Middle-Click";
                break;
            default:
                _temp = key.ToString();
                break;
        }


        return _temp;
    }
    public void End()
    {
        QuestStepUI_Animator.SetBool("Complete", true);
    }

}

using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class QuestStepUI : MonoBehaviour
{

    public TextMeshProUGUI descriptionText;
    public Image img;

    public void Init(QuestStep qs)
    {
        if (qs.questEvent == QuestEvent.KeyPressed)
        {
            ProgressKeyQuest(qs);
        } else
        {
            descriptionText.text = qs.stepDescription;
        }

        descriptionText.color = Color.white;
        img.color = Color.white;
        gameObject.SetActive(true);
    }


    public void ProgressKeyQuest(QuestStep qs) {

        string _temp = "";
        _temp += qs.stepDescription;

        foreach (PairKeycodeBool pair in qs.keyToPress)
        {
            if (pair.pressed)
            {
                _temp += " <color=green> " + pair.key + "</color>";
            } else
            {
                _temp += " <color=white> " + pair.key + "</color>";
            }

        }

        descriptionText.text = _temp;
    }

    public void End()
    {
        descriptionText.color = Color.green;
        img.color = Color.green;
    }
}

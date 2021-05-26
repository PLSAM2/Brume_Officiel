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
        descriptionText.color = Color.green;
        img.color = Color.green;
    }
}

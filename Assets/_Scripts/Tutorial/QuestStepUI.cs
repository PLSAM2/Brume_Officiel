using DG.Tweening;
using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class QuestStepUI : MonoBehaviour
{

    public TextMeshProUGUI objectifText;
    public Animator QuestStepUI_Animator;

    public List<GameObject> descriptionQuest = new List<GameObject>();

    public TextMeshProUGUI descriptionText;

    public void Init(QuestStep qs)
    {
        QuestStepUI_Animator.SetBool("Complete", false);
        if (qs.questEvent == QuestEvent.KeyPressed)
        {
            ProgressKeyQuest(qs);
            objectifText.text = objectifText.text;
        } else
        {

            objectifText.text = qs.stepDescription;
            //descriptionText.DOText(qs.stepDescription, 0.7f, true, ScrambleMode.Lowercase);
        }

        gameObject.SetActive(true);
    }


    public void SetDescription(string _text)
    {
        descriptionText.text = _text;
    }

    public void ProgressKeyQuest(QuestStep qs) {

        foreach (PairKeycodeBool pair in qs.keyToPress)
        {
            if (!pair.pressed) { continue; }

            pair.myKeyObj.myAnimator.SetBool("Idle", true);

            foreach(Image img in pair.myKeyObj.myColorImg)
            {
                img.color = Color.green;
            }

            foreach (TextMeshProUGUI text in pair.myKeyObj.myColorText)
            {
                text.color = Color.green;
            }
        }
    }

    public void End()
    {
        QuestStepUI_Animator.SetBool("Complete", true);
    }

}

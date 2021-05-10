using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class QuestStepUI : MonoBehaviour
{

    public TextMeshProUGUI descriptionText;

    public void Init(QuestStep qs)
    {
        descriptionText.text = qs.stepDescription;
        gameObject.SetActive(true);
    }

}

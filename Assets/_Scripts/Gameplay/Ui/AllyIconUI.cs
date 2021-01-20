using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class AllyIconUI : MonoBehaviour
{
    [SerializeField] private Image soulFeedBack;

    [SerializeField] private List<Image> ultimateProgress = new List<Image>();
    [SerializeField] private Color ultProgressOffColor;
    [SerializeField] private Color ultProgressOnColor;

    public void SetUltimateProgress(float progress)
    {
        for (int i = 0; i < ultimateProgress.Count; i++)
        {
            ultimateProgress[i].color = ultProgressOnColor;

            if (i >= progress)
            {
                ultimateProgress[i].color = ultProgressOffColor;
            }


        }
    }

    public void ResetUltimateProgress()
    {
        for (int i = 0; i < ultimateProgress.Count; i++)
        {
            ultimateProgress[i].color = ultProgressOffColor;
        }
    }
}

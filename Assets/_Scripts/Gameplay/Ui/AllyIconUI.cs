using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AllyIconUI : MonoBehaviour
{
    [SerializeField] private GameObject soulFeedback;

    public void SetPickSoul(bool value)
    {
        soulFeedback.SetActive(value);
    }
}

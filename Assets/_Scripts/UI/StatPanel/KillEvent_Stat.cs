using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class KillEvent_Stat : MonoBehaviour
{
    public TextMeshProUGUI username;
    public TextMeshProUGUI perso;
    public TextMeshProUGUI killer;

    public void Hide()
    {
        killer.gameObject.SetActive(false);
    }

    public void Show()
    {
        killer.gameObject.SetActive(true);
    }
}

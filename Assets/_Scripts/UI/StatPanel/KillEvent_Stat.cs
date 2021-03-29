using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class KillEvent_Stat : MonoBehaviour
{
    public TextMeshProUGUI username;
    public TextMeshProUGUI perso;
    public TextMeshProUGUI killer;
    public Image icon;

    private void Start()
    {
        StartCoroutine(WaitToDisable());
    }

    IEnumerator WaitToDisable()
    {
        Show();

        yield return new WaitForSeconds(2);

        Hide();
    }

    public void Hide()
    {
        killer.gameObject.SetActive(false);
    }

    public void Show()
    {
        killer.gameObject.SetActive(true);
    }
}

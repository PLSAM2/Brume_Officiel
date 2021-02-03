using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    public Transform fx;

    private void Update()
    {
        RaycastHit hit;
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out hit))
        {
            fx.position = hit.point;
        }

        fx.gameObject.SetActive(Input.GetMouseButton(0));
    }
}

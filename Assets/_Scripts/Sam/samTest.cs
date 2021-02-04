using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    public Transform obj;

    public RectTransform icon;

    private Vector3 playerTemp;
    private Vector2 mapTemp;

    void Start()
    {
        mapTemp = icon.anchoredPosition;
    }

    private void Update()
    {
        var sp = RectTransformUtility.WorldToScreenPoint(Camera.main, obj.transform.position);
        var rect = icon.rect;
        var cp = new Vector2(sp.x / Screen.width * rect.width, sp.y / Screen.height * rect.height);
    }
}

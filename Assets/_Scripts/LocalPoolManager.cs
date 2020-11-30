using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class LocalPoolManager : MonoBehaviour
{
    private static LocalPoolManager _instance;
    public static LocalPoolManager Instance { get { return _instance; } }

    public GameObject prefabTextFeedback;
    List<GameObject> allText = new List<GameObject>();

    public GameObject prefabImpactFx;
    List<GameObject> allImpactFx = new List<GameObject>();

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
        DontDestroyOnLoad(this);
    }

    //Textfeedback
    public void SpawnNewTextFeedback(Vector3 _pos, string _value, Color _color)
    {
        TextFeedback currentFeedback = GetFree(allText, prefabTextFeedback).GetComponent<TextFeedback>();

        currentFeedback.gameObject.SetActive(true);
        currentFeedback.Init(_pos, _value, _color);
    }

    //impact feedback
    public void SpawnNewImpactFX(Vector3 _pos, Quaternion _rota, Team _team)
    {
        Transform currentFeedback = GetFree(allImpactFx, prefabImpactFx).transform;

        currentFeedback.position = _pos;
        currentFeedback.rotation = _rota;

        currentFeedback.GetChild(0).gameObject.SetActive(_team == Team.red);
        currentFeedback.GetChild(1).gameObject.SetActive(_team == Team.blue);
    }

    GameObject GetFree(List<GameObject> allObj, GameObject prefab)
    {
        foreach (GameObject element in allObj)
        {
            if (!element.activeSelf)
            {
                return element;
            }
        }

        GameObject newObjElement = Instantiate(prefab, transform);
        allObj.Add(newObjElement);
        return newObjElement;
    }
}
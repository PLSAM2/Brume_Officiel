using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class LocalPoolManager : SerializedMonoBehaviour
{
    private static LocalPoolManager _instance;
    public static LocalPoolManager Instance { get { return _instance; } }

    public GameObject prefabTextFeedback;
    List<GameObject> allText = new List<GameObject>();

    public GameObject prefabImpactFx;
    List<GameObject> allImpactFx = new List<GameObject>();


    public Dictionary<int, GameObject> prefabGeneric = new Dictionary<int, GameObject>();
    Dictionary<int, List<GameObject>> allGeneric = new Dictionary<int, List<GameObject>>();

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
    }

    //Textfeedback
    public void SpawnNewTextFeedback(Vector3 _pos, string _value, Color _color, float _time = 1)
    {
        TextFeedback currentFeedback = GetFree(allText, prefabTextFeedback).GetComponent<TextFeedback>();

        currentFeedback.gameObject.SetActive(true);
        currentFeedback.Init(_pos, _value, _color);

        currentFeedback.GetComponent<AutoDisable>().Init(_time);
    }

    //impact feedback
    public void SpawnNewImpactFX(Vector3 _pos, Quaternion _rota, Team _team, float _time = 1)
    {
        Transform currentFeedback = GetFree(allImpactFx, prefabImpactFx).transform;

        currentFeedback.gameObject.SetActive(true);

        currentFeedback.position = _pos;
        currentFeedback.rotation = _rota;

        currentFeedback.GetChild(0).GetChild(0).gameObject.SetActive(_team == Team.red);
        currentFeedback.GetChild(0).GetChild(1).gameObject.SetActive(_team == Team.blue);

        currentFeedback.GetComponent<AutoDisable>().Init(_time);
    }

    //generic
    public void SpawnNewGeneric(int _index,Vector3 _pos, Quaternion _rota, Vector3 _scale, float _time = 1)
    {
        GameObject newObj = GetFreeGeneric(_index);

        newObj.SetActive(true);

        newObj.transform.position = _pos;
        newObj.transform.rotation = _rota;
        newObj.transform.localScale = _scale;

        newObj.GetComponent<AutoDisable>().Init(_time);
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

    GameObject GetFreeGeneric(int _index)
    {
        foreach(KeyValuePair<int, List<GameObject>> element in allGeneric)
        {
            if (element.Key == _index)
            {
                foreach(GameObject obj in element.Value)
                {
                    if (!obj.activeSelf)
                    {
                        return obj;
                    }
                }
            }
        }

        GameObject newObjElement = Instantiate(prefabGeneric[_index], transform);

        if(!allGeneric.ContainsKey(_index)){
            List<GameObject> newList = new List<GameObject>();
            allGeneric.Add(_index, newList);
        }

        allGeneric[_index].Add(newObjElement);
        return newObjElement;
    }
}
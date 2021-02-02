﻿using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static AOE_Fx;
using static GameData;

public class LocalPoolManager : SerializedMonoBehaviour
{
    private static LocalPoolManager _instance;
    public static LocalPoolManager Instance { get { return _instance; } }

    public GameObject prefabAOEFeedback;
    List<GameObject> allAOE = new List<GameObject>();

    public GameObject prefabTextFeedback;
    List<GameObject> allText = new List<GameObject>();

    public GameObject prefabImpactFx;
    List<GameObject> allImpactFx = new List<GameObject>();

    public Dictionary<ushort, GameObject> prefabGeneric = new Dictionary<ushort, GameObject>();
    Dictionary<ushort, List<GameObject>> allGeneric = new Dictionary<ushort, List<GameObject>>();

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

    //AOE
    public void SpawnNewAOELocal(ushort _id, Vector3 _pos, float _rota, float _scale, float _time)
    {
        AOE_Fx currentFeedback = GetFree(allAOE, prefabAOEFeedback).GetComponent<AOE_Fx>();

        currentFeedback.gameObject.SetActive(true);
        currentFeedback.Init((AOE_Fx_Type) _id, _pos, _rota, _scale *2, _time);

        currentFeedback.GetComponent<AutoDisable>().Init(_time + 0.2f);
    }

    public void SpawnNewAOEInNetwork(ushort _id, Vector3 _pos, float _rota, float _scale, float _time)
    {
        LocalPlayer myLocalPlayer = GameFactory.GetLocalPlayerObj();

        SpawnNewAOELocal(_id, _pos, _rota, _scale, _time);

        myLocalPlayer.SendSpawnAOEFx(_id, _pos, _rota, _scale, _time);
    }


    bool textIsLeft = true;
    //Textfeedback
    public void SpawnNewTextFeedback(Vector3 _pos, string _value, Color _color, float _time = 1)
    {
        TextFeedback currentFeedback = GetFree(allText, prefabTextFeedback).GetComponent<TextFeedback>();

        currentFeedback.gameObject.SetActive(true);
        textIsLeft = !textIsLeft;
        currentFeedback.Init(_pos, _value, _color, textIsLeft);

        currentFeedback.GetComponent<AutoDisable>().Init(_time);
    }

    //impact feedback
    public void SpawnNewImpactFX(Vector3 _pos, Quaternion _rota, Team _team, float _time = 1)
    {
        Transform currentFeedback = GetFree(allImpactFx, prefabImpactFx).transform;

        currentFeedback.gameObject.SetActive(true);

        currentFeedback.position = _pos;
        currentFeedback.rotation = Quaternion.identity;

        currentFeedback.GetChild(0).GetChild(0).gameObject.SetActive(_team == Team.red);
        currentFeedback.GetChild(0).GetChild(1).gameObject.SetActive(_team == Team.blue);

        currentFeedback.GetComponent<AutoDisable>().Init(_time);
    }

    //generic
    public void SpawnNewGenericInLocal(ushort _index, Vector3 _pos, float _rota, float _scale, float _time = 1)
    {
        GameObject newObj = GetFreeGeneric(_index);

        newObj.SetActive(true);

        newObj.transform.position = _pos;
        newObj.transform.eulerAngles = new Vector3(0, _rota, 0);
        newObj.transform.localScale = new Vector3(1, 1, _scale);

        newObj.GetComponent<AutoDisable>().Init(_time);
    }

    public void SpawnNewGenericInNetwork(ushort _index, Vector3 _pos, float _rota, float _scale, float _time = 1)
    {
        LocalPlayer myLocalPlayer = GameFactory.GetLocalPlayerObj();

        SpawnNewGenericInLocal(_index, _pos, _rota, _scale, _time);

        myLocalPlayer.SendSpawnGenericFx(_index, _pos, _rota, _scale, _time);
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

    GameObject GetFreeGeneric(ushort _index)
    {
        foreach(KeyValuePair<ushort, List <GameObject>> element in allGeneric)
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
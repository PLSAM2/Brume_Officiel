using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class LocalPoolManager : MonoBehaviour
{
    private static LocalPoolManager _instance;
    public static LocalPoolManager Instance { get { return _instance; } }

    public GameObject prefabTextFeedback;
    List<TextFeedback> allText = new List<TextFeedback>();

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

    public void SpawnNewTextFeedback(Vector3 _pos, string _value, Color _color)
    {
        foreach (TextFeedback element in allText)
        {
            if (!element.gameObject.activeSelf)
            {
                SetTextFeedback(element, _pos, _value, _color);
                return;
            }
        }

        TextFeedback newTextElement = Instantiate(prefabTextFeedback, transform).GetComponent<TextFeedback>();
        allText.Add(newTextElement);
        SetTextFeedback(newTextElement, _pos, _value, _color);
        return;
    }

    void SetTextFeedback(TextFeedback currentFeedback, Vector3 _pos, string _value, Color _color)
    {
        currentFeedback.gameObject.SetActive(true);
        currentFeedback.Init(_pos, _value, _color);
    }
}
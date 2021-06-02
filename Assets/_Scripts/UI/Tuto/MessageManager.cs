using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class MessageManager : MonoBehaviour
{
    private static MessageManager _instance;
    public static MessageManager Instance { get { return _instance; } }


    [SerializeField] Animator myAnimator;
    [SerializeField] TextMeshProUGUI text;


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

    public void DisplayNewMessage(string _value)
    {
        if (myAnimator.GetBool("Show"))
        {
            StartCoroutine(WaitToHide(_value));
        }
        else
        {
            SetNetDisplay(_value);
        }
    }

    void SetNetDisplay(string _value)
    {
        text.text = _value;
        myAnimator.SetBool("Show", true);
    }

    IEnumerator WaitToHide(string _value)
    {
        myAnimator.SetBool("Show", false);

        yield return new WaitForSeconds(0.4f);

        SetNetDisplay(_value);
    }

    public void HideMessage()
    {
        myAnimator.SetBool("Show", false);
    }
}

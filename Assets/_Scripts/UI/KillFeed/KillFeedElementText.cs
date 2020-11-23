using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class KillFeedElementText : MonoBehaviour
{
    [SerializeField] Image topLineImg;

    [SerializeField] TextMeshProUGUI text;

    [SerializeField] Animator myAnimator;

    public void InitAction(string _textInfo)
    {
        text.text = _textInfo;

        StartCoroutine(WaitToDisable());
        myAnimator.SetTrigger("Play");
    }

    IEnumerator WaitToDisable()
    {
        yield return new WaitForSeconds(2);
        gameObject.SetActive(false);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TextFeedback : MonoBehaviour
{
    [SerializeField] Text damageText;
    [SerializeField] Text damageShadowText;

    [SerializeField] Animator myAnimator;

    public void Init(string value, Color _color)
    {
        damageText.text = value;
        damageShadowText.text = value;

        damageText.color = _color;

        myAnimator.SetTrigger("Show");
    }

    IEnumerator WaitToDisable()
    {
        yield return new WaitForSeconds(0.5f);
        gameObject.SetActive(false);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class TextFeedback : MonoBehaviour
{
    [SerializeField] Text damageText;
    [SerializeField] Text damageShadowText;

    [SerializeField] Animator myAnimator;

    [SerializeField] AudioClip hitClip;

    public void Init(Vector3 pos, string value, Color _color)
    {
        transform.position = pos;

        damageText.text = value;
        damageShadowText.text = value;

        damageText.color = _color;

        myAnimator.SetTrigger("Show");

        AudioManager.Instance.Play3DAudio(hitClip, transform.position);
    }
}

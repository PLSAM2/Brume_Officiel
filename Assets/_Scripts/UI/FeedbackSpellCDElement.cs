using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class FeedbackSpellCDElement : MonoBehaviour
{
    public TextMeshProUGUI timeText;
    public TextMeshProUGUI timeTextShadow;
    public Image img;

    public AudioClip audioCantSpell;

    public void Init(Sprite _icon, float _time)
    {
        img.sprite = _icon;
        timeText.text = _time + "s";
        timeTextShadow.text = _time + "s";

        if (audioCantSpell != null)
        {
            AudioManager.Instance.Play2DAudio(audioCantSpell);
        }

        Destroy(gameObject, 1);
    }
}

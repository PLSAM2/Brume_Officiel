using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;
using DG.Tweening;

public class SoulSpellElement : MonoBehaviour
{
    public CanvasGroup outlineSelect;
    public Animator myAnimator;

    public SoulSpell mySoulSpell;
    public SoulSpellSelector mySelector;

    public AudioClip clickSound;

    public void OnClickBtn()
    {
        mySelector.currentSoulSpell = mySoulSpell;

        AudioManager.Instance.Play2DAudio(clickSound);
    }

    public void OnHover()
    {
        outlineSelect.DOFade(1, 1);
    }

    public void OnExit()
    {
        outlineSelect.DOFade(0, 1);
    }

    public void Hide()
    {
        myAnimator.SetTrigger("Hide");
    }
}

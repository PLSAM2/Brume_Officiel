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

    public AudioClip hoverSound;
    public AudioClip clickSound;

    public GameObject selected;

    public void OnClickBtn()
    {
        if (selected.activeSelf) { return; }

        mySelector.currentSoulSpell = mySoulSpell;
        AudioManager.Instance.Play2DAudio(clickSound);
        selected.SetActive(true);

        if(mySelector.currentSpell != null)
        {
            mySelector.currentSpell.UnSelect();
        }
        mySelector.currentSpell = this;
    }

    public void UnSelect()
    {
        selected.SetActive(false);
    }

    public void OnHover()
    {
        outlineSelect.DOFade(1, 0.7f);
        AudioManager.Instance.Play2DAudio(hoverSound);
    }

    public void OnExit()
    {
        outlineSelect.DOFade(0, 0.7f);
    }

    public void Hide()
    {
        myAnimator.SetTrigger("Hide");
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;
using DG.Tweening;
using TMPro;

public class SoulSpellElement : MonoBehaviour
{
    public Animator myAnimator;

    public En_SoulSpell mySoulSpell;
    public SoulSpellSelector mySelector;

    public AudioClip hoverSound;
    public AudioClip clickSound;

    public Sc_Spell mySpell;
    public TextMeshProUGUI nameSpell;
    public TextMeshProUGUI description;

    public CanvasGroup myCanvasGroup;
    public CanvasGroup myCanvasGroupDescription;

    public bool selected = false;

    public void DisableInteractable()
    {
        myCanvasGroup.interactable = false;
        myCanvasGroup.blocksRaycasts = false;
    }

    private void Start()
    {
        nameSpell.text = mySpell.spellName;
        description.text = mySpell.spellDescription;

        myCanvasGroup.alpha = 0.2f;
    }

    public void OnClickBtn()
    {
        if (selected) { return; }

        selected = true;

        mySelector.currentSoulSpell = mySoulSpell;
        AudioManager.Instance.Play2DAudio(clickSound);

        if(mySelector.currentSpell != null)
        {
            mySelector.currentSpell.UnSelect();
        }
        mySelector.currentSpell = this;

        mySelector.OnClickSoulSpell();

        myAnimator.SetBool("Selected", true);
    }

    public void UnSelect()
    {
        transform.DOScale(1, 0.3f);
        selected = false;

        myAnimator.SetBool("Selected", false);
        myCanvasGroupDescription.DOFade(0, 0.3f);
    }

    public void OnHover()
    {
        AudioManager.Instance.Play2DAudio(hoverSound);
        transform.DOScale(1.5f, 0.3f);
        myCanvasGroup.DOFade(1, 0.3f);

        myCanvasGroupDescription.DOFade(1, 0.3f);
    }

    public void OnExit()
    {
        if (!selected)
        {
            transform.DOScale(1, 0.3f);
            myCanvasGroup.DOFade(0.2f, 0.3f);
            myCanvasGroupDescription.DOFade(0, 0.3f);
        }
    }
    
    public void Hide()
    {
        myCanvasGroup.DOFade(0, 0.6f);
    }
}

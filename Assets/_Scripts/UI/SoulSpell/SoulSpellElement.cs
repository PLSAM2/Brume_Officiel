using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;
using DG.Tweening;
using TMPro;

public class SoulSpellElement : MonoBehaviour
{
    public CanvasGroup outlineSelect;
    public Animator myAnimator;

    public En_SoulSpell mySoulSpell;
    public SoulSpellSelector mySelector;

    public AudioClip hoverSound;
    public AudioClip clickSound;

    public GameObject selected;

    public Sc_Spell mySpell;
    public TextMeshProUGUI nameSpell;
    public TextMeshProUGUI description;
    public Image img;

    public Button myButton;

    public void DisableInteractible()
    {
        myButton.interactable = false;
    }

    private void Start()
    {
        nameSpell.text = mySpell.spellName;
        description.text = mySpell.spellDescription;
        img.sprite = mySpell.spellIcon;
    }

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

        mySelector.OnClickSoulSpell();
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

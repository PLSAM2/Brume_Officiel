using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpellSlot : MonoBehaviour
{

    [SerializeField] Animator myAnimator;

    [SerializeField] SpellInfo myInfo;
    [SerializeField] Animator infoAnimator;

    public Sc_Spell mySpell;

    public bool isDefault = false;

    private void Start()
    {
        if (isDefault)
        {
            myInfo.SetInfos(mySpell);
        }
    }

    public void OnHover(bool value)
    {
        myAnimator.SetBool("Hover", value);
    }

    public void OnClick()
    {
        myInfo.SetInfos(mySpell);
        infoAnimator.SetTrigger("Open");
    }
}

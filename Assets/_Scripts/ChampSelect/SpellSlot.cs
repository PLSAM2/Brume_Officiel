using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpellSlot : MonoBehaviour
{

    [SerializeField] Animator animator;

    public void OnHover(bool value)
    {
        animator.SetBool("Hover", value);
    }

    public void OnClick()
    {

    }
}

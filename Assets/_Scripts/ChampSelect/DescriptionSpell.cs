using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DescriptionSpell : MonoBehaviour
{
    [SerializeField] Animator myAnimator;

    public void OpenDescription(string _newName, string _newDescription)
    {
        myAnimator.SetTrigger("Open");
    }

    public void CloseDescription()
    {
        myAnimator.SetTrigger("Close");
    }
}

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class ChampionSlot : MonoBehaviour
{
    public Character character;
    public Animator animator;

    public GameObject keyLock;
    public void SelectCharacter()
    {
        animator.SetBool("Picked", true);
        ChampSelectManager.Instance.PickCharacter(character, this);
    }

    internal void OnPlayerLeave()
    {
        keyLock.SetActive(false);
    }

    public void Hover(bool value)
    {
        animator.SetBool("Hover", value);
    }

    internal void Pick(ushort playerID)
    {
        keyLock.SetActive(true);
    }

    internal void UnPick()
    {
        animator.SetBool("Picked", false);
    }
}

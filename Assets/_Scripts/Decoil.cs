using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Decoil : MonoBehaviour
{
    public UIDecoil myUI;

    public float lifeTime = 6;

    public Animator myAnimator;

    public void Start()
    {
        myAnimator.SetBool("IsMoving", true); 
    }

    public void Init(string _name, int _liveHealth, int _maxLiveHealth, Team _team)
    {
        myUI.Init(_name, _liveHealth, _maxLiveHealth, _team);
    }
}

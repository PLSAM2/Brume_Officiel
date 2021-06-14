using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.Video;

public class SpellInfo : MonoBehaviour
{
    public TextMeshProUGUI titleSpell, description;
    public VideoPlayer myVideoPlayer;

    public void SetInfos(Sc_Spell _mySpell)
    {
        titleSpell.text = _mySpell.spellName;
        description.text = _mySpell.spellDescription;

        myVideoPlayer.clip = _mySpell.myVideoSpell;
    }
}

using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class SpellInfo : MonoBehaviour
{
    public TextMeshProUGUI titleSpell, description;

    public void SetInfos(Sc_Spell _mySpell)
    {
        titleSpell.text = _mySpell.spellName;
        description.text = _mySpell.spellDescription;
    }
}

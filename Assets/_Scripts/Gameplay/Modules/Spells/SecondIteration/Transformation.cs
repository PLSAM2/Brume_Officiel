using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Transformation : SpellModule
{
	public SpellModule newClick, newFirst, newSecond, newThird;


	protected override void ResolveSpell ()
	{
		base.ResolveSpell();
		if (newClick != null)
		{
			myPlayerModule.leftClick.Disable();
			SpellModule _temp = myPlayerModule.leftClick;
			newClick.SetupComponent(En_SpellInput.Click);
			myPlayerModule.leftClick = newClick;
			newClick = _temp;
		}
		if(newFirst != null)
		{
			myPlayerModule.firstSpell.Disable();
			SpellModule _temp = myPlayerModule.firstSpell;
			newFirst.SetupComponent(En_SpellInput.FirstSpell);
			myPlayerModule.firstSpell = newFirst;
			newFirst = _temp;
		}
		if(newSecond != null)
		{
			myPlayerModule.secondSpell.Disable();
			SpellModule _temp = myPlayerModule.secondSpell;
			newSecond.SetupComponent(En_SpellInput.SecondSpell);
			myPlayerModule.secondSpell = newSecond;
			newSecond = _temp;
		}
		if (newThird != null)
		{
			myPlayerModule.thirdSpell.Disable();
			SpellModule _temp = myPlayerModule.thirdSpell;
			newSecond.SetupComponent(En_SpellInput.ThirdSpell);
			myPlayerModule.thirdSpell = newThird;
			newThird = _temp;
		}
	}
}

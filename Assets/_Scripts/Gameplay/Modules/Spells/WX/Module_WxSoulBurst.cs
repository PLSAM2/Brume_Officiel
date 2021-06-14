using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxSoulBurst : ModuleProjectileSpell
{
    public override void DecreaseCooldown() {}

	void AddChargeManualy()
	{
		Mathf.Clamp(charges++, 0, 3);
	}

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		WxController _temp = (WxController)myPlayerModule;
		_temp.soulPickedUp += AddChargeManualy;
	}

	public override void Disable ()
	{
		base.Disable();
		WxController _temp = (WxController)myPlayerModule;
		_temp.soulPickedUp += AddChargeManualy;
	}
}

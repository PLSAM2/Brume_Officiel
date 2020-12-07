using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxSoulBurst : ModuleProjectileSpell
{
    protected override void AddCharge() { }
    public override void DecreaseCooldown() {}

	void AddChargeManualy()
	{
		charges++;
	}

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
		WxController _temp = (WxController)myPlayerModule;
		_temp.soulPickedUp += AddChargeManualy;
	}

	protected override void Disable ()
	{
		base.Disable();
		WxController _temp = (WxController)myPlayerModule;
		_temp.soulPickedUp += AddChargeManualy;
	}
}

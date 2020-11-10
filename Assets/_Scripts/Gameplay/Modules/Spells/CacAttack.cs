using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CacAttack : SpellModule
{
	Sc_CacAttack localTrad;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);

		localTrad = (Sc_CacAttack)spell;

		switch (_actionLinked)
		{
			case En_SpellInput.Click:
				myPlayerModule.leftClickInputRealeased += ResolveSpell;
				break;

			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInputRealeased += ResolveSpell;
				break;

			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInputRealeased += ResolveSpell;
				break;

			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInputRealeased += ResolveSpell;
				break;
		}
	}

	protected override void ResolveSpell ( Vector3 _mousePosition )
	{
		base.ResolveSpell(_mousePosition);

		List<GameObject> _listHit = new List<GameObject>();

		float _baseAngle = localTrad.angleToAttackFrom / 2 - localTrad.angleToAttackFrom;

		for (int i = 0; i < localTrad.angleToAttackFrom; i++)
		{
			Vector3 _direction = Quaternion.Euler(0, _baseAngle, 0) * transform.forward;
			_baseAngle++;
			RaycastHit[] _allhits = Physics.RaycastAll(transform.position, _direction, spell.range, gameObject.layer);

			for(int j =0; j < _allhits.Length; j++)
			{
				if (!_listHit.Contains(_allhits[j].collider.gameObject))
				{
					_listHit.Add(_allhits[j].collider.gameObject);
				}
			}
		}

	//	foreach()

	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HurtingDash : SpellModule
{
	bool isDashingWithSpell =false;
	[SerializeField] float hurtingBoxWidth = .8f;
	List<GameObject> allHits;
	[SerializeField] DamagesInfos damages;

	private void Start ()
	{
		allHits = new List<GameObject>();
	}
	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		isDashingWithSpell = true;
		base.StartCanalysing(_BaseMousePos);
	}

	public override void Interrupt ()
	{
		isDashingWithSpell = false;
		allHits.Clear();
		base.Interrupt();
	}

	protected override void FixedUpdate ()
	{
		if(isDashingWithSpell)
		{
			RaycastHit[] allCharacterHitOnFrame = Physics.SphereCastAll(new Vector3(transform.position.x, 0, transform.position.z), hurtingBoxWidth, Vector3.zero);
		
			foreach(RaycastHit hit in allCharacterHitOnFrame)
				if(!allHits.Contains(hit.collider.gameObject))
				{
					allHits.Add(hit.collider.gameObject);

					hit.collider.GetComponent<Damageable>().DealDamages(damages, transform.position, myPlayerModule.mylocalPlayer.myPlayerId);
						}
		}

		base.FixedUpdate();
	}
}
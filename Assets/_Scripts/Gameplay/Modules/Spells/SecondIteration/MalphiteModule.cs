using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MalphiteModule : SpellModule
{
	public DamagesInfos damagesToDeal;
	float timeCanalised;
	public float minRange, maxRange;
	float rangeDif => maxRange - minRange;
	public LayerMask layerTouched;
	bool counting;
	public Transform previewImpact;

	protected override void FixedUpdate ()
	{
		base.FixedUpdate();

		if (counting)
		{
			timeCanalised += Time.fixedDeltaTime;
		}

		previewImpact.localScale = new Vector3(SizeOfImpact() *2 +.75f, SizeOfImpact()*2 + .75f, SizeOfImpact()*2);
	}


	public override void StartCanalysing ( Vector3 _BaseMousePos )
	{
		base.StartCanalysing(_BaseMousePos);
		timeCanalised = 0;
	}

	protected override void ResolveSpell ()
	{
		base.ResolveSpell();

		Collider[] touchedEnemies = Physics.OverlapSphere( new Vector3(transform.position.x,0, transform.position.z), SizeOfImpact(), layerTouched);
		if (touchedEnemies.Length > 0)
		{
			foreach (Collider _coll in touchedEnemies)
			{
				_coll.GetComponent<Damageable>().DealDamages(damagesToDeal, transform.position);
			}
		}
	}

	float SizeOfImpact()
	{
		return minRange + rangeDif * ((spell.canalisationTime - ((spell.canalisationTime - spell.anonciationTime) - timeCanalised)) / spell.canalisationTime);
	}

	public override void StartCanalysingFeedBack ()
	{
		base.StartCanalysingFeedBack();
		counting = true;
	}

	public override void StartAnnonciationFeedBack ()
	{
		base.StartAnnonciationFeedBack();
		counting = false;
	}

	private void OnDrawGizmosSelected ()
	{
		//Gizmos.DrawWireSphere(transform.position, maxRange);
		Gizmos.DrawWireSphere(transform.position  + Vector3.down *  .75f, SizeOfImpact());
	}
}

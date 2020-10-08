using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
	Action actionLinkedToTheSpell;
	[ReadOnly] public float currentTimeCanalised, timeToResolveSpell;
	[ReadOnly] bool isUsed = false;

	public void SetupComponent(Action _actionToSubscribe)
	{
		_actionToSubscribe += StartCanalysing;

		actionLinkedToTheSpell = _actionToSubscribe;
	}

	void OnDisable()
	{
		actionLinkedToTheSpell -= StartCanalysing;
	}

	void Update()
	{
		if(isUsed)
		{
			currentTimeCanalised += Time.deltaTime;
			if (currentTimeCanalised >= timeToResolveSpell)
			{
			//	ResolveSpell();
			}
		}
	}

	public void StartCanalysing()
	{ 
	
	}

	public void Interrupt ()
	{

	}
	public virtual void ResolveSpell(Vector3 mousePosition)
	{
		Interrupt();
	}


}

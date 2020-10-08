using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Sirenix.OdinInspector;

public class SpellModule : MonoBehaviour
{
	[ReadOnly] public float currentTimeCanalised, timeToResolveSpell;
	[ReadOnly] bool isUsed = false;
	[SerializeField] string debug;
	public En_SpellInput actionLinked;

	PlayerModule myPlayerModule;

    private void Start()
    {
		myPlayerModule = GetComponent<PlayerModule>();
	}

    public void SetupComponent()
	{

		switch(actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput += StartCanalysing;
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput += StartCanalysing;
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput += StartCanalysing;
				break;
			case En_SpellInput.Click:
				myPlayerModule.leftClickInput += StartCanalysing;
				break;
		}

	}

	void OnDisable()
	{
		switch (actionLinked)
		{
			case En_SpellInput.FirstSpell:
				myPlayerModule.firstSpellInput -= StartCanalysing;
				break;
			case En_SpellInput.SecondSpell:
				myPlayerModule.secondSpellInput -= StartCanalysing;
				break;
			case En_SpellInput.ThirdSpell:
				myPlayerModule.thirdSpellInput -= StartCanalysing;
				break;
			case En_SpellInput.Click:
				myPlayerModule.leftClickInput -= StartCanalysing;
				break;
		}
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

	public void StartCanalysing ( Vector3 _BaseMousePos)
	{
		Debug.Log("I start Canalysing" + debug);
	}

	public void Interrupt ()
	{

	}
	public virtual void ResolveSpell(Vector3 mousePosition)
	{
		Interrupt();
	}


}

public enum En_SpellInput
{
	FirstSpell,
	SecondSpell,
	ThirdSpell,
	Click
}
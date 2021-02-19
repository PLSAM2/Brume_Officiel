using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CallBackAnim : MonoBehaviour
{
	[SerializeField] CacAttack myCacAttack;
	bool countingPreview;
	float timeCounted;
	bool isOwner;

	private void Start ()
	{
		GameManager.Instance.OnAllCharacterSpawned += Setup;
	}

	void Setup()
	{
		isOwner = myCacAttack.myPlayerModule.mylocalPlayer.isOwner;
	}

	private void OnDisable ()
	{
		GameManager.Instance.OnAllCharacterSpawned -= Setup;
	}

	public void StartCounting()
	{
		if (!isOwner)
		{
			myCacAttack.ShowPreviewNetwork(true);
			timeCounted = 0;
			countingPreview = true;
		}
	
	}

	public void StopCounting()
	{
		if (!isOwner)
		{
			myCacAttack.ShowPreviewNetwork(false);
			countingPreview = false;
			myCacAttack.ShowAttackPreviewNetwork(timeCounted);
		}
	}

	private void Update ()
	{
		if (!isOwner)
		{
			if (countingPreview)
			{
				timeCounted += Time.deltaTime;
				myCacAttack.EvaluatePreviewNetwork(timeCounted);
			}
			if (timeCounted >= myCacAttack.spell.canalisationTime)
				StopCounting();
		}
	}
}

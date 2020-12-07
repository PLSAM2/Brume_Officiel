using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CallBackAnim : MonoBehaviour
{
	[SerializeField] CacAttack myCacAttack;
	bool countingPreview;
	float timeCounted;

	public void StartCounting()
	{
		if (!myCacAttack.myPlayerModule.mylocalPlayer.isOwner)
		{
			myCacAttack.ShowPreviewNetwork(true);
			timeCounted = 0;
			countingPreview = true;
		}
	
	}

	public void StopCounting()
	{
		if (!myCacAttack.myPlayerModule.mylocalPlayer.isOwner)
		{
			myCacAttack.ShowPreviewNetwork(false);
			countingPreview = false;
			myCacAttack.ShowAttackPreviewNetwork(timeCounted);
		}
	}

	private void Update ()
	{
		if (!myCacAttack.myPlayerModule.mylocalPlayer.isOwner)
		{
			if (countingPreview)
			{
				timeCounted += Time.deltaTime;
				myCacAttack.EvaluatePreviewNetwork(timeCounted);
			}
		}
	}
}

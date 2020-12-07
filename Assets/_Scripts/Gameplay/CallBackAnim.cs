using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CallBackAnim : MonoBehaviour
{
	[SerializeField] CacAttack myCacAttack;
	bool countingPreview;
	float timeCounted;
	bool isActive;

	private void Start ()
	{
		isActive = !myCacAttack.myPlayerModule.mylocalPlayer.isOwner;
	}

	public void StartCounting()
	{
		if(isActive)
		{
			myCacAttack.ShowPreviewNetwork(true);
			timeCounted = 0;
			countingPreview = true;
		}
	
	}

	public void StopCounting()
	{
		if (isActive)
		{
			myCacAttack.ShowPreviewNetwork(false);
			countingPreview = false;
			myCacAttack.ShowAttackPreviewNetwork(timeCounted);
		}
	}

	private void Update ()
	{
		if (isActive)
		{
			if (countingPreview)
			{
				timeCounted += Time.deltaTime;
				myCacAttack.EvaluatePreviewNetwork(timeCounted);
			}
		}
	}
}

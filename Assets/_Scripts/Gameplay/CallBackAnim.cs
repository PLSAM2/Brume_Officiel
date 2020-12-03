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
		timeCounted = 0;
		countingPreview = true;
	}

	public void StopCounting()
	{
		countingPreview = false;
		myCacAttack.ShowAttackPreviewReseau(timeCounted);
	}

	private void Update ()
	{
		if (countingPreview)
		{

			timeCounted += Time.deltaTime;

			print("Icount");
		}
	}
}

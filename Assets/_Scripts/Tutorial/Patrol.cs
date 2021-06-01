using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

public class Patrol : MonoBehaviour
{
    public Transform firstPoint, secondPoint;
	bool goToFirst = false;
	private void OnEnable ()
	{
		transform.position = firstPoint.position;
		StartPatroll(goToFirst);
	}

	public void StartPatroll(bool _goingToFirst)
	{
		if (_goingToFirst)
			transform.DOMove(firstPoint.position, 4).OnComplete(() =>StartPatroll(goToFirst));
		else
			transform.DOMove(secondPoint.position, 4).OnComplete(() => StartPatroll(goToFirst));

		goToFirst = !_goingToFirst;
	}
}

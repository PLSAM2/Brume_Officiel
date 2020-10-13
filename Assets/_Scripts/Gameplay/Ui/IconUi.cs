using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;

public class IconUi : MonoBehaviour
{
	[SerializeField] Image icon, outline, fillAmount;
	[SerializeField] En_SpellInput typeOfSpell;
	RectTransform myRectTransform;
	[HideInInspector] public bool isMoving = false;
	bool ishiding;
	private void Start ()
	{
		myRectTransform = icon.GetComponent<RectTransform>();
	}

	public void SetSprite(Sprite _icon)
	{
		icon.sprite = _icon;
	}

	public void UpdateFillAmount(float _fill)
	{
		fillAmount.fillAmount = _fill;
	}

	public void BeReady(bool _hiding, float _timeToWarmUp = .2f)
	{
		/* SACRE BORDEL A CORRIGER
		if(isMoving == false)
		{
			if (_hiding == true)
			{
				isMoving = true;
				print(_hiding);
				myRectTransform.DOMoveY(60, _timeToWarmUp).OnComplete(() => isMoving = false);
			}
			else
			{
				isMoving = true;
				myRectTransform.DOMoveY(20, _timeToWarmUp).OnComplete(() => isMoving = false);
			}
		}
		*/
	}
}

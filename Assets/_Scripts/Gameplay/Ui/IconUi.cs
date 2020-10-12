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

	private void Start ()
	{
		myRectTransform = GetComponent<RectTransform>();
	}

	public void SetSprite(Sprite _icon)
	{
		icon.sprite = _icon;
	}

	public void UpdateFillAmount(float _fill)
	{
		fillAmount.fillAmount = _fill;
	}

	public void BeReady(bool hiding, float timeToWarmUp = .2f)
	{
		if(isMoving == false)
		{
			if (hiding == true)
				myRectTransform.DOMoveY(-30, timeToWarmUp).OnComplete(()=> isMoving = false);
			else
				myRectTransform.DOMoveY(0, timeToWarmUp).OnComplete(() => isMoving = false); 
		}
	}
}

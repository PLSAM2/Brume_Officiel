using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using TMPro;

public class IconUi : MonoBehaviour
{
	[SerializeField] Image icon, outline, fillAmount;
	[SerializeField] TextMeshProUGUI chargesSpot, cooldownCount;
	[SerializeField] En_SpellInput typeOfSpell;
	[HideInInspector] public bool isMoving = false;
	bool ishiding;

	public void SetSprite ( Sprite _icon )
	{
		icon.sprite = _icon;
	}

	public void UpdateFillAmount ( float _fill, float _cooldownRemaining , float _completeCd)
	{
		if (_cooldownRemaining > 0 && _cooldownRemaining != _completeCd)
		{
		//	cooldownCount.text = "" +  Mathf.RoundToInt(_cooldownRemaining).ToString();
			fillAmount.fillAmount = _fill;
		}
		else
		{
			fillAmount.fillAmount = 0;
			//cooldownCount.text = " ";
		}
	}

	public void UpdatesChargesAmont ( int _numberOfCharges )
	{
		chargesSpot.text = _numberOfCharges.ToString();
	}

	public void BeReady ( bool _hiding, float _timeToWarmUp = .2f )
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

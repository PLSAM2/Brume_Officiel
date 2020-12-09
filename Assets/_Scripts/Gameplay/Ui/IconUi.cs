using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using TMPro;

public class IconUi : MonoBehaviour
{
	[SerializeField] Image icon, outline, fillAmount;
	[SerializeField] TextMeshProUGUI chargesSpot, cooldownCount, input;
	[SerializeField] En_SpellInput typeOfSpell;
	[HideInInspector] public bool isMoving = false;
	bool ishiding;
	RectTransform myRectTransform;
	Vector2 basePos;

	private void Start ()
	{
		myRectTransform = GetComponent<RectTransform>();
		basePos = new Vector2(myRectTransform.localPosition.x, myRectTransform.localPosition.y);
		print(basePos);
	}

	public void SetSprite ( Sprite _icon )
	{
		icon.sprite = _icon;
	}

	public void UpdateFillAmount ( float _cooldownRemaining, float _completeCd )
	{

		if (_cooldownRemaining > 0 && _cooldownRemaining != _completeCd)
		{
			//	cooldownCount.text = "" +  Mathf.RoundToInt(_cooldownRemaining).ToString();
			fillAmount.fillAmount = _cooldownRemaining / _completeCd;

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

	public void HideIcon ( bool _hiding )
	{
		myRectTransform.DOKill();


		if (_hiding == true)
		{
			myRectTransform.DOAnchorPos(basePos - new Vector2(0, 30), .4f);
		}
		else
		{
			myRectTransform.DOAnchorPos(basePos, .4f);
		}
	}
	public void SetupInputName ( string _name )
	{
		input.text = _name;
	}
}

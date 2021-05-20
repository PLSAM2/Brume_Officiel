using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using TMPro;
using Sirenix.OdinInspector;
using UnityEngine.EventSystems;
using System;

public class IconUi : MonoBehaviour
{
	[TabGroup("IconSpell")] [SerializeField] Image icon, outline, fillAmount, feedbackCantCast, outlineIcon, grisage;
	[TabGroup("IconSpell")] [SerializeField] TextMeshProUGUI cooldownCount, input;
	[HideInInspector] public bool isMoving = false;
	bool ishiding;
	[SerializeField] RectTransform myRectTransform;
	Vector2 basePos;
	En_SpellInput inputLinked;
	Sc_Spell spellLinked;
	float lastCD = 0;
	public GameObject feedbackCanUse;

	float cdDisplay = 0.35f;

	public void SetupIcon ( En_SpellInput _inputLinked, Sc_Spell _spellToToolTip )
	{
		basePos = new Vector2(myRectTransform.localPosition.x, myRectTransform.localPosition.y);

		inputLinked = _inputLinked;
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellAvaible += CooldownReadyFeedback;
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellNotAvaible += CantCastFeedback;

		spellLinked = _spellToToolTip;
		icon.sprite = _spellToToolTip.spellIcon;

		ResetIcon();
		fillAmount.fillAmount = 0;
		grisage.gameObject.SetActive(false);
		cooldownCount.text = "";
		outlineIcon.color = Color.white;

	}
	private void OnDisable ()
	{
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellAvaible -= CooldownReadyFeedback;
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellNotAvaible -= CantCastFeedback;
	}

	public void UpdateSpellStep ( En_IconStep _spellStep )
	{
		switch (_spellStep)
		{
			case En_IconStep.inCd:
				outlineIcon.color = Color.black;
				break;
			case En_IconStep.selectionned:
				outlineIcon.color = Color.blue;
				break;
			case En_IconStep.ready:
				outlineIcon.color = Color.white;
				break;
		}
	}

	public void UpdateCooldown ( float _cooldownRemaining, float _completeCd )
	{
		if (_completeCd - _cooldownRemaining > 1)
			lastCD = Mathf.Round(_completeCd - _cooldownRemaining);
		else
		{
			lastCD = Mathf.Round(_completeCd * 10 - _cooldownRemaining * 10);
			lastCD /= 10;
		}


		if (_cooldownRemaining > 0 && _cooldownRemaining != _completeCd)
		{
			grisage.gameObject.SetActive(true);
			fillAmount.fillAmount = (_completeCd - _cooldownRemaining) / _completeCd;

			if (_completeCd - _cooldownRemaining > 1)
				cooldownCount.text = lastCD.ToString();
			else
				cooldownCount.text = lastCD.ToString();

		}
		else
		{
			cooldownCount.text = "";
		}
	}
	public void UpdatesChargesAmont ( int _numberOfCharges )
	{
		//chargesSpot.text = _numberOfCharges.ToString();
	}
	public void CantCastFeedback ()
	{
		ResetIcon();
		myRectTransform.DOShakeAnchorPos(.5f, 4, 20, 90, false, false).OnComplete(() => myRectTransform.localPosition = basePos);
		myRectTransform.localScale = new Vector3(.7f, .7f, .7f);
		myRectTransform.DOScale(new Vector3(1f, 1f, 1), .75f);
		//feedbackCantCast.DOColor(new Vector4(255, 16, 16, 55), .5f).OnComplete(() => feedbackCantCast.DOColor(_color, .5f)).OnComplete(() => feedbackCantCast.DOColor(new Vector4(255, 16, 16, 0), .5f));


		if (UiManager.Instance.currentCdDisplay >= cdDisplay)
		{
			UiManager.Instance.currentCdDisplay = 0;

			UiManager.Instance.SpawnCDFeedback(spellLinked.spellIcon, lastCD);
		}
	}

	public void CooldownReadyFeedback ()
	{
		ResetIcon();
		fillAmount.fillAmount = 0;
		grisage.gameObject.SetActive(false);
		cooldownCount.text = "";
		outlineIcon.color = Color.white;
		//myRectTransform.DOScale(new Vector3(1f, 2.8f, 1f), .15f).OnComplete(() => myRectTransform.DOScale(Vector3.one, .15f));


		feedbackCanUse.SetActive(true);
	}
	public void ResetIcon ()
	{
		myRectTransform.DOKill();
		myRectTransform.localPosition = basePos;
		myRectTransform.localScale = Vector3.one;
		feedbackCantCast.DOKill();
		feedbackCantCast.rectTransform.localScale = new Vector3(1, 1, 1);

		Color _color = new Vector4(255, 16, 16, 0);
		feedbackCantCast.color = _color;

		feedbackCanUse.SetActive(false);
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

	public void ShowTooltip ()
	{
		UiManager.Instance.wholeTooltip.SetActive(true);
		UiManager.Instance.skillNameText.text = spellLinked.spellName;
		UiManager.Instance.cooldownText.text = spellLinked.cooldown + "s";
		UiManager.Instance.descriptionText.text = spellLinked.spellDescription;
	}

	public void HideToolTip ()
	{
		UiManager.Instance.wholeTooltip.SetActive(false);
	}
}

public enum En_IconStep
{
	inCd, ready, selectionned
}

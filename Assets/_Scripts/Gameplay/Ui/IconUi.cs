using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;
using TMPro;
using Sirenix.OdinInspector;
using UnityEngine.EventSystems;
public class IconUi : MonoBehaviour
{
	[TabGroup("IconSpell")] [SerializeField] Image icon, outline, fillAmount, feedbackCantCast, outlineIcon, grisage;
	[TabGroup("IconSpell")] [SerializeField] TextMeshProUGUI cooldownCount, input;
	[HideInInspector] public bool isMoving = false;
	bool ishiding;
	RectTransform myRectTransform;
	Vector2 basePos;
	En_SpellInput inputLinked;
	Sc_Spell spellLinked;
	public void SetupIcon ( En_SpellInput _inputLinked, Sc_Spell _spellToToolTip )
	{
		myRectTransform = GetComponent<RectTransform>();
		basePos = new Vector2(myRectTransform.localPosition.x, myRectTransform.localPosition.y);

		inputLinked = _inputLinked;
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellAvaible += CooldownReadyFeedback;
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellNotAvaible += CantCastFeedback;

		spellLinked = _spellToToolTip;

		icon.sprite = _spellToToolTip.spellIcon;

		if (NetworkManager.Instance.GetLocalPlayer().ultStacks < _spellToToolTip.stacksUsed)
		{
			CantCastFeedback();
		}

	}
	private void OnDisable ()
	{
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellAvaible -= CooldownReadyFeedback;
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellNotAvaible -= CantCastFeedback;
	}
	public void UpdateCooldown ( float _cooldownRemaining, float _completeCd )
	{
		if (_cooldownRemaining > 0 && _cooldownRemaining != _completeCd)
		{
			grisage.gameObject.SetActive(true);
			fillAmount.fillAmount = (_completeCd - _cooldownRemaining) / _completeCd;
			cooldownCount.text = Mathf.CeilToInt(_completeCd - _cooldownRemaining).ToString();
			outlineIcon.color = Color.black;
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
		AudioManager.Instance.Play2DAudio(AudioManager.Instance.cantCastSound, .8f);
		//Color _color = new Vector4(0, 0, 0, 255);
		//feedbackCantCast.color = _color;
		myRectTransform.DOShakeAnchorPos(.5f, 4, 20, 90, false, false).OnComplete(() => myRectTransform.localPosition = basePos);
		myRectTransform.localScale = new Vector3(.7f, .7f, .7f);
		myRectTransform.DOScale(new Vector3(1f, 1f, 1), .75f);
		//feedbackCantCast.DOColor(new Vector4(255, 16, 16, 55), .5f).OnComplete(() => feedbackCantCast.DOColor(_color, .5f)).OnComplete(() => feedbackCantCast.DOColor(new Vector4(255, 16, 16, 0), .5f));
	}
	public void CooldownReadyFeedback ()
	{
		ResetIcon();
		UpdateCooldown(0, 0);
		grisage.gameObject.SetActive(false);
		outlineIcon.color = new Color(248, 189, 67, 255);
		myRectTransform.DOScale(new Vector3(1f, 2.8f, 1f), .15f).OnComplete(() => myRectTransform.DOScale(Vector3.one, .15f));
	}
	public void ResetIcon ()
	{
		myRectTransform.DOKill();
		myRectTransform.localPosition = basePos;
		myRectTransform.localScale = Vector3.one;
		Color _color = new Vector4(255, 16, 16, 0);
		feedbackCantCast.DOKill();
		feedbackCantCast.rectTransform.localScale = new Vector3(1, 1, 1);
		feedbackCantCast.color = _color;
	}
	public void HideIcon ( bool _hiding )
	{/*
		myRectTransform.DOKill();


		if (_hiding == true)
		{
			myRectTransform.DOAnchorPos(basePos - new Vector2(0, 30), .4f);
		}
		else
		{
			myRectTransform.DOAnchorPos(basePos, .4f);
		}*/
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

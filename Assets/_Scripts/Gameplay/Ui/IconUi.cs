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
	[TabGroup("IconSpell")] [SerializeField] Image icon, outline, fillAmount, feedbackCantCast, outlineIcon;
	[TabGroup("IconSpell")] [SerializeField] TextMeshProUGUI cooldownCount, input;
	[HideInInspector] public bool isMoving = false;
	bool ishiding;
	RectTransform myRectTransform;
	Vector2 basePos;
	[TabGroup("Tooltip")] public GameObject wholeTooltip;
	[TabGroup("Tooltip")] public TextMeshProUGUI myDescription, myName, myCdText;
	En_SpellInput inputLinked;

	private void Start ()
	{
		myRectTransform = GetComponent<RectTransform>();
		basePos = new Vector2(myRectTransform.localPosition.x, myRectTransform.localPosition.y);
		CooldownReadyFeedback();
	}
	public void SetupIcon( En_SpellInput _inputLinked, Sc_Spell _spellToToolTip)
	{
		inputLinked = _inputLinked;
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellAvaible += CooldownReadyFeedback;
		GameManager.Instance.currentLocalPlayer.myPlayerModule.ModuleLinkedToInput(inputLinked).SpellNotAvaible += CantCastFeedback;

		myName.text = _spellToToolTip.spellName;
		myCdText.text = _spellToToolTip.cooldown + "s";
		myDescription.text = _spellToToolTip.spellDescription;
		icon.sprite = _spellToToolTip.spellIcon;
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
		Color _color = new Vector4(255, 16, 16, 195);
		feedbackCantCast.color = _color;
		myRectTransform.DOShakeAnchorPos(.5f, 4, 20, 90, false, false).OnComplete(() => myRectTransform.localPosition = basePos);
		feedbackCantCast.rectTransform.localScale = new Vector3(1.5f, 1.5f, 1);
		feedbackCantCast.rectTransform.DOScale(1f, 1.5f);
		feedbackCantCast.DOColor(new Vector4(255, 16, 16, 55), .5f).OnComplete(() => feedbackCantCast.DOColor(_color, .5f)).OnComplete(() => feedbackCantCast.DOColor(new Vector4(255, 16, 16, 0), .5f));
	}
	public void CooldownReadyFeedback ()
	{
		ResetIcon();
		outlineIcon.color = new Color(248, 189, 67, 255);
		myRectTransform.DOScale(new Vector3(1.2f, 1.2f, 1.2f), .15f).OnComplete(() => myRectTransform.DOScale(Vector3.one, .15f));
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
	public void ShowTooltip()
	{
		wholeTooltip.SetActive(true);
	}
	public void HideToolTip ()
	{
		wholeTooltip.SetActive(false);
	}
}

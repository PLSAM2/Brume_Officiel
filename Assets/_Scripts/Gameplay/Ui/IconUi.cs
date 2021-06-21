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
	[TabGroup("IconSpell")] [SerializeField] Image icon, fillAmount, outlineIcon;
	[TabGroup("IconSpell")] [SerializeField] TextMeshProUGUI cooldownCount;
	[TabGroup("IconSpell")] [SerializeField] GameObject inputIcon, feedbackCanUse;
	[TabGroup("IconSpell")] public Color colorUnavaible = new Vector4(157, 48, 45, 255);
	[HideInInspector] public bool isMoving = false;
	bool ishiding;
	[SerializeField] RectTransform myRectTransform;
	Vector2 basePos;
	En_SpellInput inputLinked;
	Sc_Spell spellLinked;
	float lastCD = 0;
	float cdDisplay = 0.35f;

	public void SetupIcon ( En_SpellInput _inputLinked, Sc_Spell _spellToToolTip )
	{
		basePos = new Vector2(myRectTransform.localPosition.x, myRectTransform.localPosition.y);

		inputLinked = _inputLinked;

		spellLinked = _spellToToolTip;
		icon.sprite = _spellToToolTip.spellIcon;

		ResetIcon();
		fillAmount.fillAmount = 0;
		cooldownCount.text = "";
		outlineIcon.color = Color.white;

		UpdateSpellStep(En_IconStep.ready);
	}
	private void OnDisable ()
	{
		if (NetworkManager.Instance.GetLocalPlayer().playerTeam == GameData.Team.spectator)
		{
			return;
		}
	}

	public void UpdateSpellStep ( En_IconStep _spellStep)
	{
		switch (_spellStep)
		{
			case En_IconStep.inCd:
				icon.color = Color.red;
				outlineIcon.color = Color.gray;
				inputIcon.SetActive(false);
				cooldownCount.gameObject.SetActive(true);
				break;

			case En_IconStep.selectionned:
				Color _tempColorBlue = new Vector4(0, 100, 180, 255);
				outlineIcon.color = _tempColorBlue;
				icon.color = _tempColorBlue;
				UiManager.Instance.currentCdDisplay = 0;
				cooldownCount.gameObject.SetActive(true);
				feedbackCanUse.SetActive(false);
				break;

			case En_IconStep.ready:
				ResetIcon();
				icon.color = Color.white;
				outlineIcon.color = Color.white;
				inputIcon.SetActive(true);
				cooldownCount.gameObject.SetActive(false);
				fillAmount.fillAmount = 0;
				cooldownCount.text = "";
				feedbackCanUse.SetActive(true);
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

	public void CantCastFeedback ()
	{
		ResetIcon();
		myRectTransform.DOShakeAnchorPos(.5f, 4, 20, 90, false, false).OnComplete(() => myRectTransform.localPosition = basePos);
		myRectTransform.localScale = new Vector3(1.7f, 1.7f, 1.7f);
		myRectTransform.DOScale(new Vector3(2f, 2f, 2), .75f);

		if (UiManager.Instance.currentCdDisplay >= cdDisplay)
		{
			UiManager.Instance.currentCdDisplay = 0;

			UiManager.Instance.SpawnCDFeedback(spellLinked.spellIcon, lastCD);
		}
	}

	public void ResetIcon ()
	{
		myRectTransform.DOKill();
		myRectTransform.localPosition = basePos;
		myRectTransform.localScale = new Vector3(2, 2, 2);
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

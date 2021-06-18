using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class UIPlayerManager : MonoBehaviour
{
	[HideIf("dummy")] [SerializeField] LocalPlayer myLocalPlayer;

	public bool dummy = false;
	[ShowIf("dummy")] [SerializeField] Dummy myDummy;
	[Header("UI")]
	[TabGroup("Ui")] public GameObject canvas;
	[TabGroup("Ui")] public Quaternion canvasRot;
	[TabGroup("Ui")] public TextMeshProUGUI nameText;
	[TabGroup("Ui")] public GameObject feedbackCounter;
	[TabGroup("Ui")] public Transform parentListLife;
	[TabGroup("Ui")] public GameObject prefabLifeBar;
	[TabGroup("Ui")] public Image lifeBarWaitingForHeal;
	[TabGroup("Ui")] public RectTransform indicationOfMaxRegen;
	public List<UIBarLifePerso> allBarLife = new List<UIBarLifePerso>();

	[Header("Buff")]
	[TabGroup("Buff")] public TextMeshProUGUI nameOfTheBuff;
	[TabGroup("Buff")] public Image fillAmountBuff;
	[TabGroup("Buff")] public GameObject wholeBuffUi;

	[Header("Compass Canvas")]
	[TabGroup("WX Compass")] public GameObject compassCanvas;
	[TabGroup("WX Compass")] public GameObject pointerObj;
	[TabGroup("WX Compass")] public Quaternion compassRot;

	[TabGroup("Mats")] public Material blueMat, redMat, grayMat, goldMat;

	[Header("State")]
	[TabGroup("UiState")] public GameObject statePart;
	[TabGroup("UiState")] public TextMeshProUGUI stateText;
	//	[TabGroup("UiState")] public Image fillPart;
	[TabGroup("UiState")] public GameObject stunIcon, revealedIcon, intangibleIcon, invulnerableIcon, slowIcon, hiddenIcon, spedUpIcon, poweredUpIcon, crouchedIcon;
	[TabGroup("UiState")] [FoldoutGroup("Cast")] public GameObject barCasting;
	[TabGroup("UiState")] [FoldoutGroup("Cast")] public Image canalisationImage;

	public LookTarget directionWx;
	public Animator directionWxAnimator;

	public CanvasGroup myCanvasGroup;

	Material currentColorTeam;

	private void Awake ()
	{
		canvasRot = canvas.transform.rotation;
        print(canvasRot);

		compassRot = compassCanvas.transform.rotation;
		compassCanvas.GetComponent<Canvas>().worldCamera = Camera.main;
	}

	private void OnEnable ()
	{
		if (!dummy)
		{
			myLocalPlayer.myPlayerModule.OnStateChange += OnStateChange;
			myLocalPlayer.OnInitFinish += Init;
			OnStateChange();
		}


		UpdateLife();
	}

	private void OnDisable ()
	{
		if (!dummy)
		{
			myLocalPlayer.myPlayerModule.OnStateChange -= OnStateChange;
			myLocalPlayer.OnInitFinish -= Init;
		}


	}

	void OnStateChange ()
	{
		if (myLocalPlayer.myPlayerModule.state.HasFlag(En_CharacterState.Intangenbility))
		{
			myCanvasGroup.alpha = 0.3f;
		}
		else
		{
			myCanvasGroup.alpha = 1;
		}

		/*
        if (myLocalPlayer.myPlayerModule.state.HasFlag(En_CharacterState.Shield))
        {
            foreach (UIBarLifePerso img in allBarLife)
            {
                img.ChangeColor(goldMat);
            }
        }
        else
        {
            foreach (UIBarLifePerso img in allBarLife)
            {
                img.ChangeColor(currentColorTeam);
            }
        }*/
	}

	public void Init ()
	{
		if (dummy)
		{
			nameText.text = "Dummy";
			currentColorTeam = redMat;
			nameText.material = currentColorTeam;
			SpawnLifeBar();
			return;

		}
		nameText.text = RoomManager.Instance.actualRoom.playerList[myLocalPlayer.myPlayerId].Name;

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == Team.spectator)
        {
			currentColorTeam = redMat;

			if (myLocalPlayer.myPlayerModule.teamIndex == Team.blue)
			{
				currentColorTeam = blueMat;
			}
		} else
        {
			currentColorTeam = redMat;
			if (GameFactory.GetRelativeTeam(myLocalPlayer.myPlayerModule.teamIndex) == Team.blue)
			{
				currentColorTeam = blueMat;
			}
		}

		nameText.material = currentColorTeam;
		SpawnLifeBar();

		if (myLocalPlayer.isOwner)
		{
			this.GetComponent<Canvas>().sortingLayerName = "LocalUI";
		}

		if (feedbackCounter != null)
		{
			feedbackCounter.SetActive(false);
		}
	}
	void SpawnLifeBar ()
	{
		if (dummy)
		{
			for (int i = 0; i < myDummy.liveHealth; i++)
			{
				UIBarLifePerso img = Instantiate(prefabLifeBar, parentListLife).GetComponent<UIBarLifePerso>();
				img.Init(currentColorTeam);
				allBarLife.Add(img);
			}
		}
		else
		{
			for (int i = 0; i < myLocalPlayer.liveHealth; i++)
			{
				UIBarLifePerso img = Instantiate(prefabLifeBar, parentListLife).GetComponent<UIBarLifePerso>();
				img.Init(currentColorTeam);
				allBarLife.Add(img);
			}
		}
	}

	public void AddLifePoint ( int _int )
	{
		for (int i = 0; i < _int; i++)
		{
			UIBarLifePerso img = Instantiate(prefabLifeBar, parentListLife).GetComponent<UIBarLifePerso>();
			img.transform.SetSiblingIndex(0);
			img.Init(currentColorTeam);
			allBarLife.Insert(0, img);
		}

		/*  RectTransform finalBar = allBarLife[myLocalPlayer.myPlayerModule.characterParameters.maxHealthForRegen + myLocalPlayer.myPlayerModule.bonusHp].GetComponent<RectTransform>();
          indicationOfMaxRegen.rect.Set(finalBar.rect.position.x + finalBar.rect.width /2, 0, finalBar.rect.width /5, finalBar.rect.height);*/

		UpdateLife();
	}

	private void LateUpdate ()
	{
		canvas.transform.eulerAngles = new Vector3(45, 0, 0);
		compassCanvas.transform.rotation = compassRot;
	}

	public void UpdateLife ()
	{
		ushort _lifeHealth = (dummy ? myDummy.liveHealth : myLocalPlayer.liveHealth);

		int i = 1;
		foreach (UIBarLifePerso img in allBarLife)
		{
			if (i <= _lifeHealth)
			{
				img.SetColorLife(currentColorTeam, true);
			}
			else
			{
				img.SetColorLife(grayMat, false);
			}
			i++;
		}
	}

	public void HidePseudo ( bool _hidePseudo )
	{
		nameText.gameObject.SetActive(!_hidePseudo);
		statePart.SetActive(_hidePseudo);
	}

	public void ShowStateIcon ( En_CharacterState _currentState )
	{
		stunIcon.SetActive(false);
		revealedIcon.SetActive(false);
		slowIcon.SetActive(false);
		hiddenIcon.SetActive(false);
		spedUpIcon.SetActive(false);
		poweredUpIcon.SetActive(false);
		crouchedIcon.SetActive(false);
		intangibleIcon.SetActive(false);
		invulnerableIcon.SetActive(false);

		stateText.text = "";

		if (feedbackCounter != null)
		{
			feedbackCounter.SetActive(false);
		}
		//	fillPart.fillAmount = actualTime / baseTime;f
		if ((_currentState & En_CharacterState.Root) != 0 && (_currentState & En_CharacterState.Silenced) != 0)
		{
			HidePseudo(true);
			stunIcon.SetActive(true);
			stateText.text = "STUNNED";
			return;
		}
		else if ((_currentState & En_CharacterState.WxMarked) != 0)
		{
			HidePseudo(true);
			revealedIcon.SetActive(true);
			stateText.text = "SPOTTED";
			return;
		}

		else if ((_currentState & En_CharacterState.Hidden) != 0)
		{
			HidePseudo(true);
			hiddenIcon.SetActive(true);
			stateText.text = "INVISIBLE";
			return;
		}
		else if ((_currentState & En_CharacterState.Intangenbility) != 0)
		{
			HidePseudo(true);
			intangibleIcon.SetActive(true);
			stateText.text = "UNTOUCHABLE";
			return;
		}
		else if ((_currentState & En_CharacterState.Invulnerability) != 0)
		{
			HidePseudo(true);
			invulnerableIcon.SetActive(true);
			stateText.text = "INVULNERABLE";
			return;
		}
		else if ((_currentState & En_CharacterState.Slowed) != 0)
		{
			HidePseudo(true);
			slowIcon.SetActive(true);
			stateText.text = "SLOWED";
			return;
		}
		else if ((_currentState & En_CharacterState.SpedUp) != 0)
		{
			HidePseudo(true);
			spedUpIcon.SetActive(true);
			stateText.text = "SPEED UP";
			return;
		}
		else if ((_currentState & En_CharacterState.Crouched) != 0)
		{
			HidePseudo(true);
			crouchedIcon.SetActive(true);
			stateText.text = "STEALTHY";
			return;
		}
		else if ((_currentState & En_CharacterState.PoweredUp) != 0)
		{
			HidePseudo(true);
			poweredUpIcon.SetActive(true);
			stateText.text = "BUFFED";
			return;
		}
		else
			HidePseudo(false);


	}

    public GameObject GetFirstDisabledPointer()
    {
        foreach (Transform t in compassCanvas.gameObject.transform)
        {
            if (!t.gameObject.activeInHierarchy)
            {
                t.gameObject.SetActive(true);
                return t.gameObject;
            }
        }

        GameObject newobj = Instantiate(pointerObj, compassCanvas.transform);
        newobj.SetActive(true);

        return newobj;
    }

	public void EnableBuff ( bool _stateOfBuff, string _buffName )
	{
		wholeBuffUi.SetActive(_stateOfBuff);
		nameOfTheBuff.text = _buffName;
	}

	public void UpdateBuffDuration ( float _fillAmount )
	{
		fillAmountBuff.fillAmount = _fillAmount;
	}

	public void UpdateCanalisation ( float _percentageOfTheCanalisation, bool _isCasting = true )
	{
		if (_isCasting)
			canalisationImage.color = Color.red;
		else
			canalisationImage.color = Color.cyan;

		canalisationImage.fillAmount = _percentageOfTheCanalisation;
	}

	public void HideCanalisationBar ( bool _isHiding )
	{
		barCasting.SetActive(_isHiding);
	}
}

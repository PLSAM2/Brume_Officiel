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
    public  List<UIBarLifePerso> allBarLife = new List<UIBarLifePerso>();

    [Header("Buff")]
    [TabGroup("Buff")] public TextMeshProUGUI nameOfTheBuff;
    [TabGroup("Buff")] public Image fillAmountBuff;
    [TabGroup("Buff")] public GameObject wholeBuffUi;

    [Header("Compass Canvas")]
    [TabGroup("WX Compass")] public GameObject compassCanvas;
    [TabGroup("WX Compass")] public GameObject pointerObj;
    [TabGroup("WX Compass")] public Quaternion compassRot;
    [TabGroup("WX Compass")] public LocalPlayer wxRef;
    [TabGroup("WX Compass")] public Material blueMat, redMat, grayMat, goldMat;

    [Header("State")]
    [TabGroup("UiState")] public GameObject statePart;
    [TabGroup("UiState")] public TextMeshProUGUI stateText;
    [TabGroup("UiState")] public Image fillPart;
    [TabGroup("UiState")] public GameObject StunIcon, HiddenIcon, CounteringIcon;
    [TabGroup("UiState")] public GameObject SlowIcon;
    [TabGroup("UiState")] public GameObject RootIcon;
    [TabGroup("UiState")] public GameObject SilencedIcon, EmbourbedIcon, Eye_Spot;

    public LookTarget directionWx;
    public Animator directionWxAnimator;

    public CanvasGroup myCanvasGroup;

    Material currentColorTeam;
    private void Awake()
    {
        canvasRot = canvas.transform.rotation;
        compassRot = compassCanvas.transform.rotation;
        compassCanvas.GetComponent<Canvas>().worldCamera = Camera.main;
    }

    private void OnEnable()
    {
        myLocalPlayer.myPlayerModule.OnStateChange += OnStateChange;
        OnStateChange();

        UpdateLife();
    }

    private void OnDisable()
    {
        myLocalPlayer.myPlayerModule.OnStateChange -= OnStateChange;
    }

    void OnStateChange()
    {
        if (myLocalPlayer.myPlayerModule.state.HasFlag(En_CharacterState.Intengenbility))
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

    private void Start()
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

        currentColorTeam = redMat;
        if (GameFactory.GetRelativeTeam(myLocalPlayer.myPlayerModule.teamIndex) == Team.blue)
        {
            currentColorTeam = blueMat;
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

    void SpawnLifeBar()
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

    public void AddLifePoint(int _int)
	{
        for (int i = 0; i < _int; i++)
        {
            UIBarLifePerso img = Instantiate(prefabLifeBar, parentListLife).GetComponent<UIBarLifePerso>();
            img.transform.SetSiblingIndex(0);
            img.Init(currentColorTeam);
            allBarLife.Insert(0,img);
        }

      /*  RectTransform finalBar = allBarLife[myLocalPlayer.myPlayerModule.characterParameters.maxHealthForRegen + myLocalPlayer.myPlayerModule.bonusHp].GetComponent<RectTransform>();
        indicationOfMaxRegen.rect.Set(finalBar.rect.position.x + finalBar.rect.width /2, 0, finalBar.rect.width /5, finalBar.rect.height);*/    
      
    }

    private void LateUpdate()
    {
        canvas.transform.rotation = canvasRot;
        compassCanvas.transform.rotation = compassRot;
    }

    public void UpdateLife()
    {
        int i = 0;
        foreach (UIBarLifePerso img in allBarLife)
        {
            if (dummy)
            {
                if (i < myDummy.liveHealth)
                {
                    img.SetColorLife(currentColorTeam, true);
                }
                else
                {
                    img.CrackLife();
                    img.SetColorLife(grayMat, false);
                    img.HideLife();
                }
            }
            else
            {
                if (i < myLocalPlayer.liveHealth)
                {
                    img.SetColorLife(currentColorTeam, true);
                }
                else
                {
                    img.CrackLife();
                    img.SetColorLife(grayMat, false);
                    img.HideLife();
                }
            }


            i++;
        }
    }

    public void HidePseudo(bool _hidePseudo)
    {
        nameText.gameObject.SetActive(!_hidePseudo);
        statePart.SetActive(_hidePseudo);
    }

    public void ShowStateIcon(En_CharacterState _currentState, float actualTime, float baseTime)
    {
        RootIcon.SetActive(false);
        SilencedIcon.SetActive(false);
        StunIcon.SetActive(false);
        SlowIcon.SetActive(false);
        HiddenIcon.SetActive(false);
        EmbourbedIcon.SetActive(false);
        CounteringIcon.SetActive(false);
        stateText.text = "";

        if (feedbackCounter != null)
        {
            feedbackCounter.SetActive(false);
        }
        //	fillPart.fillAmount = actualTime / baseTime;f

        if ((_currentState & En_CharacterState.Hidden) != 0)
        {
            HiddenIcon.SetActive(true);
            stateText.text = "Hidden";
            return;
        }
        else if ((_currentState & En_CharacterState.Countering) != 0)
        {
            if (feedbackCounter != null)
            {
                feedbackCounter.SetActive(true);
            }
            CounteringIcon.SetActive(true);
            stateText.text = "Countering";
            return;
        }
        else if ((_currentState & En_CharacterState.Embourbed) != 0)
        {
            EmbourbedIcon.SetActive(true);
            stateText.text = "Embourbed";
            return;
        }
        else if ((_currentState & En_CharacterState.Root) != 0 && (_currentState & En_CharacterState.Silenced) != 0)
        {
            StunIcon.SetActive(true);
            stateText.text = "Stunned";
            return;

        }
        else if ((_currentState & En_CharacterState.Silenced) != 0)
        {
            SilencedIcon.SetActive(true);
            stateText.text = "Silenced";
            return;

        }
        else if ((_currentState & En_CharacterState.Root) != 0)
        {
            RootIcon.SetActive(true);
            stateText.text = "Root";
            return;

        }
        else if ((_currentState & En_CharacterState.Slowed) != 0)
        {
            SlowIcon.SetActive(true);
            stateText.text = "Slowed";
            return;

        }

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

    public void EnableBuff(bool _stateOfBuff, string _buffName)
    {
        wholeBuffUi.SetActive(_stateOfBuff);
        nameOfTheBuff.text = _buffName;
    }

    public void UpdateBuffDuration(float _fillAmount)
    {
        fillAmountBuff.fillAmount = _fillAmount;
    }
}

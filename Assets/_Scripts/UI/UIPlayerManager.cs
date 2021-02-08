using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class UIPlayerManager : MonoBehaviour
{
    [SerializeField] LocalPlayer myLocalPlayer;

    [Header("UI")]
    [TabGroup("Ui")] public GameObject canvas;
    [TabGroup("Ui")] public Quaternion canvasRot;
    [TabGroup("Ui")] public TextMeshProUGUI nameText;
    [TabGroup("Ui")] public TextMeshProUGUI lifeCount;
    [TabGroup("Ui")] public Image lifeImg;
    [TabGroup("Ui")] public Image lifeDamageImg;
    [TabGroup("Ui")] public GameObject feedbackCounter;

    [Header("WX Compass")]
    [TabGroup("Ui")] public GameObject WxCompass;
    [TabGroup("Ui")] public Image WxLife, arrow;
    [TabGroup("Ui")] public GameObject sonar;
    [TabGroup("Ui")] public List<Image> sonarImg;
    [TabGroup("Ui")] public Color wxInViewColor, wxTakeDamageColor;

    [Header("Buff")]
    [TabGroup("Ui")] public TextMeshProUGUI nameOfTheBuff;
    [TabGroup("Ui")] public Image fillAmountBuff;
    [TabGroup("Ui")] public GameObject wholeBuffUi;

    [Header("Compass Canvas")]
    [TabGroup("Ui")] public GameObject compassCanvas;
    [TabGroup("Ui")] public GameObject pointerObj;
    [TabGroup("Ui")] public Quaternion compassRot;
    [TabGroup("Ui")] public Animator redDotRadar, yellowDotRadar;
    [TabGroup("Ui")] public LocalPlayer wxRef;
    [TabGroup("Ui")] public Material greenMat, redMat, grayMat;

    [Header("State")]
    [TabGroup("UiState")] public GameObject statePart;
    [TabGroup("UiState")] public TextMeshProUGUI stateText;
    [TabGroup("UiState")] public Image fillPart;
    [TabGroup("UiState")] public GameObject StunIcon, HiddenIcon, CounteringIcon;
    [TabGroup("UiState")] public GameObject SlowIcon;
    [TabGroup("UiState")] public GameObject RootIcon;
    [TabGroup("UiState")] public GameObject SilencedIcon, EmbourbedIcon, Eye_Spot;

    private void Awake()
    {
        canvasRot = canvas.transform.rotation;
        compassRot = compassCanvas.transform.rotation;
        compassCanvas.GetComponent<Canvas>().worldCamera = Camera.main;
    }

    private void Start()
    {
        nameText.text = RoomManager.Instance.actualRoom.playerList[myLocalPlayer.myPlayerId].Name;

        switch (myLocalPlayer.myPlayerModule.teamIndex)
        {
            case Team.red:
                nameText.material = redMat;
                lifeDamageImg.material = greenMat;
                lifeImg.material = redMat;
                WxLife.material = redMat;
                break;

            case Team.blue:
                nameText.material = greenMat;
                lifeDamageImg.material = redMat;
                lifeImg.material = greenMat;
                WxLife.material = greenMat;
                break;
        }

        if (feedbackCounter != null)
        {
            feedbackCounter.SetActive(false);
        }
    }

    private void LateUpdate()
    {
        canvas.transform.rotation = canvasRot;
        compassCanvas.transform.rotation = compassRot;
    }

    public void UpdateLife()
    {
        //Update UI
        lifeCount.text = myLocalPlayer.liveHealth.ToString();
        lifeImg.fillAmount = (float)myLocalPlayer.liveHealth / GameFactory.GetMaxLifeOfPlayer(myLocalPlayer.myPlayerId);
    }

    private void Update()
    {
        //ui life
        lifeDamageImg.fillAmount = Mathf.Lerp(lifeDamageImg.fillAmount, lifeImg.fillAmount, 3 * Time.deltaTime);


        //compase rota
        if (myLocalPlayer.allCharacterSpawned)
        {
            if (wxRef != null)
            {
                //voit la shili
                if (GameManager.Instance.visiblePlayer.ContainsKey(wxRef.transform)){
                    WxLife.fillAmount = (float) wxRef.liveHealth / (float) wxRef.myPlayerModule.characterParameters.maxHealth;

                    Vector3 fromPos = WxCompass.transform.position;
                    Vector3 toPos = wxRef.transform.position;

                    fromPos.y = 0;
                    toPos.y = 0;
                    Vector3 direction = (toPos - fromPos).normalized;
                    float angle = Vector3.SignedAngle(direction, Vector3.right, Vector3.up);
                    WxCompass.gameObject.transform.localEulerAngles = new Vector3(0, 0, angle);

                    if(WxLife.material == grayMat)
                    {
                        switch (myLocalPlayer.myPlayerModule.teamIndex)
                        {
                            case Team.red:
                                WxLife.material = redMat;
                                break;

                            case Team.blue:
                                WxLife.material = greenMat;
                                break;
                        }

                        arrow.material = null;
                    }
                }
                else
                {
                    WxLife.material = grayMat;
                    arrow.material = grayMat;
                }
            }
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

        if(feedbackCounter != null)
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

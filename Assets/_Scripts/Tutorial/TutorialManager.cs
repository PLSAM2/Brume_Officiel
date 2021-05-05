using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class TutorialManager : MonoBehaviour
{
    private static TutorialManager _instance;
    public static TutorialManager Instance { get { return _instance; } }

    private void Awake()
    {
        if (_instance != null && _instance != this)
        {
            Destroy(this.gameObject);
        }
        else
        {
            _instance = this;
        }
    }

    public void PlayerSpawned()
    {
        PlayerPrefs.SetInt("SoulSpell", (int)En_SoulSpell.Invisible);
        GameManager.Instance.currentLocalPlayer.myPlayerModule.InitSoulSpell(En_SoulSpell.Invisible);

        RoomManager.Instance.ImReady();
        UiManager.Instance.StartTutorial();
    }


}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class iconActionKF : MonoBehaviour
{
    [SerializeField] Image myIconImg;

    [SerializeField] Sprite iconKill;
    [SerializeField] Sprite iconRevive;

    public void Init(actionKillfeed _action)
    {
        switch (_action)
        {
            case actionKillfeed.Revive:
                myIconImg.sprite = iconRevive;
                break;

            case actionKillfeed.Kill:
                myIconImg.sprite = iconKill;
                break;
        }
    }

    public enum actionKillfeed
    {
        Revive,
        Kill
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class UltiBar : MonoBehaviour
{
    [SerializeField] GameObject prefabUlti;
    public bool isOwner = false;
    int number = 0;
    int numberMax = 0;
    List<UltiElement> allUltiElement = new List<UltiElement>();

    public void Init(ushort numberUltiMax, ushort numberUlti)
    {
        number = numberUlti;
        numberMax = numberUltiMax;
        for (int i=0; i < numberUltiMax; i++)
        {
            UltiElement newUltiElement = Instantiate(prefabUlti, transform).GetComponent<UltiElement>();
            newUltiElement.InstantSetValue(0);

            allUltiElement.Add(newUltiElement);
        }

        UpdateUltiBar(number);
    }

    public void SetValue(int numberUlti)
    {
        UpdateUltiBar(numberUlti);

        print(RoomManager.Instance.GetPlayerData(NetworkManager.Instance.GetLocalPlayer().ID).ultStacks);

        if (!isOwner) { return; }

        int numberChange = number - numberUlti;
        if (numberChange < 0)
        {
            //add anim
            int numberAdd = numberUlti - number;
            UiManager.Instance.feedBackUlti.GainUlti(numberAdd);
        }
        number = numberUlti;
    }

    void UpdateUltiBar(int numberUlti)
    {
        int i = 1;
        foreach (UltiElement ult in allUltiElement)
        {
            if (i <= numberUlti)
            {
                ult.Fill();
            }
            else
            {
                ult.UnFill();
            }
            i++;
        }
    }
}

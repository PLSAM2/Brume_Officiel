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

        UpdateUltiBar(number, false);
    }

    public void SetValue(int numberUlti, bool islocal)
    {
        UpdateUltiBar(numberUlti, islocal);

        if (!isOwner) { return; }

        number = numberUlti;
    }

    void UpdateUltiBar(int numberUlti, bool islocal)
    {
        int i = 1;
        foreach (UltiElement ult in allUltiElement)
        {
            if (i <= numberUlti)
            {
                ult.Fill(islocal);
            }
            else
            {
                ult.UnFill();
            }
            i++;
        }

        if (isOwner)
        {
            UiManager.Instance.curentUlti.text = numberUlti + "<size=15>/" + numberMax;
        }
    }
}

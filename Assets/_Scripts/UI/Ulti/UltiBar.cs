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

    public void Init(ushort numberUlti)
    {
        numberMax = numberUlti;
        for (int i=0; i < numberUlti; i++)
        {
            UltiElement newUltiElement = Instantiate(prefabUlti, transform).GetComponent<UltiElement>();
            newUltiElement.InstantSetValue(0);

            allUltiElement.Add(newUltiElement);
        }
    }

    public void SetValue(int numberUlti)
    {
        //add
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
}

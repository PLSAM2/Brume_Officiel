using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FeedBackGainUlti : MonoBehaviour
{
    [SerializeField] GameObject prefabGainUlti;

    public void GainUlti(int number)
    {
        GainUltiElement newGain = Instantiate(prefabGainUlti, transform).GetComponent<GainUltiElement>();
        newGain.Init(number);
    }
}

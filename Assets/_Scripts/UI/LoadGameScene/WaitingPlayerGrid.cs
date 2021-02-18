using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class WaitingPlayerGrid : MonoBehaviour
{
    public TextMeshProUGUI playerName;
    
    public void Init(PlayerData pData)
    {
        playerName.text = pData.Name; 
    }
}

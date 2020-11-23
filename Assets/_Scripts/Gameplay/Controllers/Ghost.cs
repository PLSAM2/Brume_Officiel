using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Ghost : MonoBehaviour
{
    public PlayerModule playerModule;
    public void Init(PlayerModule playerModule)
    {
        this.playerModule = playerModule;
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AudioListenerFollow : MonoBehaviour
{
    // Update is called once per frame
    void Update()
    {
        if(GameManager.Instance.currentLocalPlayer != null)
        {
            transform.position = GameManager.Instance.currentLocalPlayer.transform.position;
        }
    }
}

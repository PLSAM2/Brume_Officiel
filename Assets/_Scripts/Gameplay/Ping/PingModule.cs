using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PingModule : MonoBehaviour
{
    public KeyCode pingKey;
    private PlayerModule playerModule;

    private void Start()
    {
        playerModule = this.GetComponent<PlayerModule>();
    }

    private void Update()
    {
        if (Input.GetKeyDown(pingKey))
        {
            if (playerModule.mousePos() != Vector3.zero)
            {
                NetworkObjectsManager.Instance.NetworkInstantiate(2100, playerModule.mousePos() + new Vector3(0, 0.05f, 0), Vector3.zero);
            }
        }
    }
}

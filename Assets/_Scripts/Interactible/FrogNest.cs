using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FrogNest : MonoBehaviour
{
    public Frog frogObj;

    private void Start()
    {
        frogObj.nest = this;
    }

    public void SpawnFrog()
    {
        frogObj.gameObject.SetActive(true);
    }

    public void FrogPicked(PlayerModule capturingPlayer)
    {

        frogObj.gameObject.SetActive(false);

        if (capturingPlayer != null)
        {
            if (capturingPlayer.interactiblesClose.Contains(frogObj))
            {
                capturingPlayer.interactiblesClose.Remove(frogObj);
            }
        }
    }
}

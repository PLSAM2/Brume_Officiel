using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class EnemyIconMinimap : MonoBehaviour
{
    public bool isRedTeam;

    public Color blueColorSeen;
    public Color redColorSeen;
    public Color blueColorUnseen;
    public Color redColorUnseen;
    public Color deadColor;

    public Sprite mercenaryAlive;
    public Sprite mercenaryDying;

    public Image icon;

    /*private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
            SetSeen();

        if (Input.GetKeyDown(KeyCode.Z))
            SetUnseen();

        if (Input.GetKeyDown(KeyCode.E))
            SetDying();

        if (Input.GetKeyDown(KeyCode.R))
            SetAlive();

        if (Input.GetKeyDown(KeyCode.T))
            SetDead();
    }*/

    private void SetSeen()
    {
        if (isRedTeam)
        {
            icon.color = redColorSeen;
        }
        else if (!isRedTeam)
        {
            icon.color = blueColorSeen;
        }
    }

    private void SetUnseen()
    {
        if (isRedTeam)
        {
            icon.color = redColorUnseen;
        }
        else if (!isRedTeam)
        {
            icon.color = blueColorUnseen;
        }
    }

    private void SetDying()
    {
        icon.sprite = mercenaryDying;
    }

    private void SetDead()
    {
        icon.sprite = mercenaryAlive;
        icon.color = deadColor;
    }

    private void SetAlive()
    {
        icon.sprite = mercenaryAlive;
    }
}

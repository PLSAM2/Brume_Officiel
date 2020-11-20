using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static iconActionKF;

public class KillFeedElement : MonoBehaviour
{
    [SerializeField] Image topLineImg;

    [SerializeField] Transform listIconParent;

    [SerializeField] GameObject prefabIconPerso;
    [SerializeField] GameObject prefabIconAction;

    [SerializeField] List<GameObject> infoElement = new List<GameObject>();

    [SerializeField] Animator myAnimator;

    public void InitAction(PlayerData idP1, actionKillfeed myAction, PlayerData idP2)
    {
        if (idP1 != null)
        {
            topLineImg.color = GameFactory.GetColorTeam(idP1.playerTeam);

            infoElement[0].SetActive(true);
            infoElement[0].GetComponent<iconPersoKF>().Init(idP1);
        }
        else
        {
            infoElement[0].SetActive(false);
            topLineImg.color = GameFactory.GetColorTeam(idP2.playerTeam);
        }

        infoElement[1].GetComponent<iconActionKF>().Init(myAction);

        if (idP2 != null)
        {
            infoElement[2].SetActive(true);
            infoElement[2].GetComponent<iconPersoKF>().Init(idP2);
        }
        else
        {
            infoElement[2].SetActive(false);
        }

        StartCoroutine(WaitToDisable());

        myAnimator.SetTrigger("Play");
    }

    IEnumerator WaitToDisable()
    {
        yield return new WaitForSeconds(2);
        gameObject.SetActive(false);
    }
}

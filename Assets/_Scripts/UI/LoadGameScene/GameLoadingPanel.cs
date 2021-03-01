using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameLoadingPanel : MonoBehaviour
{
    public List<RectTransform> spawnPointList = new List<RectTransform>();
    public RectTransform spawnHelp;

    // Start is called before the first frame update
    void Awake()
    {
        InitMimimap();
    }
    private void InitMimimap()
    {
        spawnHelp.position = spawnPointList[RoomManager.Instance.assignedSpawn[NetworkManager.Instance.GetLocalPlayer().playerTeam] - 1].position;
        spawnHelp.gameObject.SetActive(true);
    }

}

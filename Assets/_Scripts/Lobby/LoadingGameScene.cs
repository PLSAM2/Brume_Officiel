using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LoadingGameScene : MonoBehaviour
{
    public Image progressBar;
    public float fakeLoadingTime = 3;

    public List<RectTransform> spawnPointList = new List<RectTransform>();
    public RectTransform spawnHelp;
    private string scene;

    private void Awake()
    {
        scene = RoomManager.Instance.gameScene;
    }

    void Start()
    {
        StartCoroutine(FakeLoadingTime());
        InitMimimap();
    }

    private void InitMimimap()
    {
        spawnHelp.position = spawnPointList[RoomManager.Instance.assignedSpawn[NetworkManager.Instance.GetLocalPlayer().playerTeam] - 1].position;
        spawnHelp.gameObject.SetActive(true);

    }

    private IEnumerator FakeLoadingTime()
    {
        yield return new WaitForSeconds(Random.Range(fakeLoadingTime, 5));
        StartCoroutine(LoadSceneAsyncOperation());
    }


    private IEnumerator LoadSceneAsyncOperation()
    {
        AsyncOperation gameLevelLoad = SceneManager.LoadSceneAsync(scene);

        while (gameLevelLoad.progress < 1)
        {
            progressBar.fillAmount = gameLevelLoad.progress;
            yield return new WaitForEndOfFrame();
        }

    }
}

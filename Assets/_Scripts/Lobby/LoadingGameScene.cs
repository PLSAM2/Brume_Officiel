using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LoadingGameScene : SerializedMonoBehaviour
{
    public Image progressBar;
    public float fakeLoadingTime = 3;
    public Dictionary<GameObject, List<GameObject>> camerasWithAssets = new Dictionary<GameObject, List<GameObject>>();
    public string scene;


    private void Awake()
    {
        int r = UnityEngine.Random.Range(0, camerasWithAssets.Count);

        foreach (GameObject item in camerasWithAssets.ElementAt(r).Value)
        {
            item.SetActive(true);
        }
        camerasWithAssets.ElementAt(r).Key.SetActive(true);
    }

    void Start()
    {
        StartCoroutine(FakeLoadingTime());
    }

    private IEnumerator FakeLoadingTime()
    {
        yield return new WaitForSeconds(Random.Range(0, fakeLoadingTime));
        StartCoroutine(LoadSceneAsyncOperation());
    }


    private IEnumerator LoadSceneAsyncOperation()
    {
        AsyncOperation gameLevelLoad = SceneManager.LoadSceneAsync(scene, LoadSceneMode.Single);

        while (gameLevelLoad.progress < 1)
        {
            progressBar.fillAmount = gameLevelLoad.progress;
            yield return new WaitForEndOfFrame();
        }

    }
}

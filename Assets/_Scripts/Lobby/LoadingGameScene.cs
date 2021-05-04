using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class LoadingGameScene : MonoBehaviour
{
    public Image progressBar;
    public float fakeLoadingTime = 3;

    public string scene;

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

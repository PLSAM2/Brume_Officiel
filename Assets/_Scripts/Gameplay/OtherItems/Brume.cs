using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;
using UnityEngine.UI;

public class Brume : MonoBehaviour
{
    public List<Renderer> myRenderer = new List<Renderer>();
    [SerializeField] AudioClip sfxTransiBrume;

    bool isShow = true;
    [SerializeField] float speedTransition = 8;
    float value = 1;

    public Texture myTexture;

    private void Start()
    {
        GameManager.Instance.allBrume.Add(this);

        foreach (Renderer r in myRenderer)
        {
            r.material = Instantiate<Material>(r.material);
        }
    }


    private void Update()
    {
        if (isShow)
        {
            value = Mathf.Lerp(value, 1, Time.deltaTime * speedTransition);

        }
        else
        {
            value = Mathf.Lerp(value, 0, Time.deltaTime * speedTransition);
        }

        foreach (Renderer r in myRenderer)
        {
            r.material.SetFloat("_Alpha", value);
        }

        if(value < 0.1f)
        {
            foreach (Renderer r in myRenderer)
            {
                if (r.gameObject.activeSelf)
                {
                    r.gameObject.SetActive(false);
                }
            }
        }
        else
        {
            foreach (Renderer r in myRenderer)
            {
                if (!r.gameObject.activeSelf)
                {
                    r.gameObject.SetActive(true);
                }
            }
        }
    }

    public void ForceEnter(PlayerModule player)
    {
        ShowHideMesh(player, false);
        AudioManager.Instance.Play2DAudio(sfxTransiBrume);
    }

    public void ForceExit(PlayerModule player)
    {
        PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

        if (player == currentFollowPlayer)
        {
            ShowHideMesh(player, true);
            AudioManager.Instance.Play2DAudio(sfxTransiBrume);
        }
    }

    public void PlayAudio()
    {
        AudioManager.Instance.Play2DAudio(sfxTransiBrume);
    }

    public void ShowHideMesh(PlayerModule _module, bool _value)
    {
        GameManager.Instance.globalVolumeAnimator.SetBool("InBrume", !_value);

        isShow = _value;
    }
}

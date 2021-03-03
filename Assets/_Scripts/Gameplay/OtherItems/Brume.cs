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
    [SerializeField] float speedTransition = 10;

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
        float value = 0;
        if (isShow)
        {
            value = Mathf.Lerp(1, 0, Time.deltaTime * speedTransition);
        }
        else
        {
            value = Mathf.Lerp(0, 1, Time.deltaTime * speedTransition);
        }

        foreach (Renderer r in myRenderer)
        {
            r.material.SetFloat("_Alpha", value);
        }
    }

    public void ForceEnter(PlayerModule player)
    {
        //player.SetInBrumeStatut(true, GetInstanceID());
        PlayerModule currentFollowPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

        ShowHideMesh(player, false);
        AudioManager.Instance.Play2DAudio(sfxTransiBrume);
    }

    public void ForceExit(PlayerModule player)
    {
        //player.SetInBrumeStatut(false, 0);
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
        SetWardFow(_module);

        SetTowerFow(_value);

        isShow = _value;
    }

    void SetWardFow(PlayerModule _player)
    {
        GameManager.Instance.allWard.RemoveAll(x => x == null);

        foreach (Ward ward in GameManager.Instance.allWard)
        {
            if(ward == null) { continue; }
            bool fogValue = false;

            if (_player.isInBrume == ward.isInBrume)
            {
                if (GameFactory.PlayerWardAreOnSameBrume(_player, ward) || _player.isInBrume == false)
                {
                    fogValue = true;
                }
                else
                {
                    fogValue = false;
                }
            }

            ward.GetMesh().SetActive(fogValue);
        }
    }

    void SetTowerFow(bool value)
    {
        GameManager.Instance.allTower.RemoveAll(x => x == null);

        foreach (VisionTower tower in GameManager.Instance.allTower)
        {
            if (tower == null) { continue; }
            tower.vision.gameObject.SetActive(value);
        }
    }
}

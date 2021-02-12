using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

public class Brume : MonoBehaviour
{
    public List<Renderer> myRenderer = new List<Renderer>();
    [SerializeField] AudioClip sfxTransiBrume;

    private void Start()
    {
        GameManager.Instance.allBrume.Add(this);
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

        foreach(Renderer r in myRenderer)
        {
            r.enabled = _value;
        }
    }

    void SetWardFow(PlayerModule _player)
    {
        GameManager.Instance.allWard.RemoveAll(x => x == null);

        foreach (Ward ward in GameManager.Instance.allWard)
        {
            if(ward == null) { continue; }
            bool fogValue = false;

            if (GameFactory.PlayerWardAreOnSameBrume(_player, ward))
            {
                fogValue = true;
            }
            else
            {
                if (_player.isInBrume)
                {
                    fogValue = false;
                }
                else
                {
                    fogValue = true;
                }
            }

            ward.GetFow().gameObject.SetActive(fogValue);
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

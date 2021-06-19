using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.Events;

public class SpellFeedback : MonoBehaviour
{

	public PlayerModule myPlayerModule;
	float shakingTime = .1f, heardDistance = 7;
	public Material wuxinGhostMaterial;
	Material baseMaterial;

	public LineRenderer[] allLinePreviewForCac;
	bool showLaser = false;
	public float laserMaxLength = 8f;

    public UnityEvent OnInvisibleStart, OnInvisibleEnd;

	public void PlaySound ( AudioClip _audioToPlay )
	{
		AudioManager.Instance.Play3DAudio(_audioToPlay, transform.position, myPlayerModule.mylocalPlayer.myPlayerId, true);
	}

	public void SetShakingTime ( float _setShakingTime )
	{
		shakingTime = _setShakingTime;
	}
	public void SetHeardDistance ( float _setHeardDistance )
	{
		heardDistance = _setHeardDistance;
	}
	public void ShakeScreen ( float _shakingStrength )
	{
		GameFactory.DoScreenShake(shakingTime, _shakingStrength, transform.position, 8);
	}

	public void ShowPreview ( Transform _objectToShow )
	{
        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == GameData.Team.spectator)
        {
			_objectToShow.GetChild(1).gameObject.SetActive(true);
			return;
		}

		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(myPlayerModule.teamIndex))
			_objectToShow.GetChild(0).gameObject.SetActive(true);
		else
			_objectToShow.GetChild(1).gameObject.SetActive(true);
	}

	public void HidePreview ( Transform _objectToShow )
	{

		if (NetworkManager.Instance.GetLocalPlayer().playerTeam == GameData.Team.spectator)
		{
			_objectToShow.GetChild(1).gameObject.SetActive(false);
			return;
		}


		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(myPlayerModule.teamIndex))
			_objectToShow.GetChild(0).gameObject.SetActive(false);
		else
			_objectToShow.GetChild(1).gameObject.SetActive(false);
	}

	public void IsGhost ( bool _isGhosting )
	{
		if (baseMaterial == null)
		{
            foreach(SkinnedMeshRenderer skin in myPlayerModule.skinnedRenderer)
            {
                baseMaterial = skin.material;
            }
		}

		if (_isGhosting)
        {
            OnInvisibleStart?.Invoke();
            foreach (SkinnedMeshRenderer skin in myPlayerModule.skinnedRenderer)
            {
                skin.material = wuxinGhostMaterial;
            }
        }else
        {
            OnInvisibleEnd?.Invoke();
            foreach (SkinnedMeshRenderer skin in myPlayerModule.skinnedRenderer)
            {
                skin.material = baseMaterial;
            }
        }
	}

    public void SpawnFXInvisible()
    {
        switch (myPlayerModule.teamIndex == NetworkManager.Instance.GetLocalPlayer().playerTeam)
        {
            case true:
                LocalPoolManager.Instance.SpawnNewGenericInNetwork(4, transform.position, 0, 1, 2);
                break;

            case false:
                LocalPoolManager.Instance.SpawnNewGenericInNetwork(5, transform.position, 0, 1, 2);
                break;
        }
    }

	public void ShowPreviewAttackLaser ( bool _isShown )
	{
		foreach (LineRenderer _line in allLinePreviewForCac)
		{
			_line.gameObject.SetActive(_isShown);
		}
		showLaser = _isShown;

	}

	private void Update ()
	{
		RaycastHit _hit;

		if (showLaser)
			if (Physics.Raycast(transform.position, transform.forward, out _hit, laserMaxLength, LayerMask.GetMask("Obstacle")))
				foreach (LineRenderer _line in allLinePreviewForCac)
				{
					_line.GetPosition(1).Set(0, 0, _hit.point.z);
				}
			else
				foreach (LineRenderer _line in allLinePreviewForCac)
				{
					_line.GetPosition(1).Set(0, 0, 8);
				}


	}

    public void PlaySpellAudio(SpellSound _mySpell)
    {
        AudioClip mySpellAudio = GetAudioClip(_mySpell);

        if (myPlayerModule.mylocalPlayer.isOwner)
        {
            AudioManager.Instance.Play2DCharacterAudio(mySpellAudio);
        }
        else
        {
            LocalPlayer actualPlayer = GameFactory.GetActualPlayerFollow();
            if(actualPlayer == null) { return; }

            if(Vector3.Distance(transform.position, actualPlayer.transform.position) <= 30)
            {
                if(Random.Range(0, 2) == 0)
                {
                    AudioManager.Instance.Play2DCharacterAudio(mySpellAudio);
                }
            }
        }
    }

    public Dictionary<SpellSound, List<AudioClip>> audioSpells = new Dictionary<SpellSound, List<AudioClip>>();

    AudioClip GetAudioClip(SpellSound _mySpell)
    {
        return audioSpells[_mySpell][(Random.Range(0, audioSpells[_mySpell].Count))];
    }

    public enum SpellSound
    {
        LeftClick,
        RightClick,
        Space
    }
}



using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
public class SpellFeedback : MonoBehaviour
{

	public PlayerModule myPlayerModule;
	float shakingTime = .1f, heardDistance = 7;
	public Material wuxinGhostMaterial;
	Material baseMaterial;
	public SkinnedMeshRenderer meshToSet;
	public LineRenderer[] allLinePreviewForCac;
	bool showLaser = false;
	public float laserMaxLength = 8f;

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
		GameFactory.DoScreenShack(shakingTime, _shakingStrength, transform.position, heardDistance);
	}

	public void ShowPreview ( Transform _objectToShow )
	{
		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(myPlayerModule.teamIndex))
			_objectToShow.GetChild(0).gameObject.SetActive(true);
		else
			_objectToShow.GetChild(1).gameObject.SetActive(true);
	}

	public void HidePreview ( Transform _objectToShow )
	{
		if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(myPlayerModule.teamIndex))
			_objectToShow.GetChild(0).gameObject.SetActive(false);
		else
			_objectToShow.GetChild(1).gameObject.SetActive(false);
	}

	public void IsGhost ( bool _isGhosting )
	{
		if (baseMaterial == null)
		{
			baseMaterial = meshToSet.material;
		}

		if (_isGhosting)
			meshToSet.material = wuxinGhostMaterial;
		else
			meshToSet.material = baseMaterial;

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
}



using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpellFeedback : MonoBehaviour
{

	public PlayerModule myPlayerModule;
	float shakingTime = .15f, heardDistance = 7;
	public Material wuxinGhostMaterial;
    Material baseMaterial;
    public SkinnedMeshRenderer meshToSet;
	public LineRenderer[] allLinePreviewForCac;

    public void PlaySound(AudioClip _audioToPlay)
	{
		AudioManager.Instance.Play3DAudio(_audioToPlay, transform.position, myPlayerModule.mylocalPlayer.myPlayerId, true);
	}

	public void SetShakingTime(float _setShakingTime)
	{
		shakingTime = _setShakingTime;
	}
	public void SetHeardDistance ( float _setHeardDistance )
	{
		heardDistance = _setHeardDistance;
	}
	public void ShakeScreen(float _shakingStrength )
	{
        GameFactory.DoScreenShack(shakingTime, _shakingStrength, transform.position, heardDistance);
    }

	public void ShowPreview(Transform _objectToShow)
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

	public void IsGhost(bool _isGhosting)
	{
        if(baseMaterial == null)
        {
            baseMaterial = meshToSet.material;
        }

		if (_isGhosting)
			meshToSet.material = wuxinGhostMaterial;
		else
			meshToSet.material = baseMaterial;

	}

	public void ()
}



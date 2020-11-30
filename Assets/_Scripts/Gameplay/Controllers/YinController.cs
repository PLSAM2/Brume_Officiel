using DarkRift;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class YinController : PlayerModule
{
	// [Header("Ying Properties")]
	public float revelationRangeWhileHidden = 4;
	Team otherTeam;

	protected override void Setup ()
	{
		base.Setup();
		if (teamIndex == Team.blue)
			otherTeam = Team.red;
		else
			otherTeam = Team.blue;

		StartCoroutine(CheckForMenace());

	}

	IEnumerator CheckForMenace()
	{
		yield return new WaitForSeconds(.5f);

		if ((state & En_CharacterState.Hidden) != 0)
		{
			foreach (LocalPlayer _player in GameFactory.GetPlayersInRangeByTeam(revelationRangeWhileHidden, transform.position, otherTeam))
			{
				_player.myPlayerModule.pingMenace.Invoke();
			}
		}
		StartCoroutine(CheckForMenace());
	}
}

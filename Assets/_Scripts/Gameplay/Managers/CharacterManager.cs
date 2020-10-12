using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterManager : MonoBehaviour
{
	public static CharacterManager instance;

	List<PlayerModule> playerList;


	private void Awake ()
	{
		if (instance == null || instance == this)
			instance = this;
		else
			Destroy(this);
	}

	public List<PlayerModule> PlayersFromTeam (int _teamIndexAsked)
	{
		List<PlayerModule> tempList = new List<PlayerModule>();
		
		for(int i =0; i <  playerList.Count; i++)
		{
			if (playerList[i].teamIndex == _teamIndexAsked)
				tempList.Add(playerList[i]);
		}
		return tempList;
	}

	public PlayerModule PlayerFromIndex (int _playerIndex)
	{
		return playerList[_playerIndex];
	}
}

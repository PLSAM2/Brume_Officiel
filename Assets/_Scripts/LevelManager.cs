using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour
{

	[SerializeField] List<Transform> allCollectibleSpot; 
	[SerializeField]int numberOfCollectible;
	private void Start ()
	{
		if (RoomManager.Instance.GetLocalPlayer().IsHost)
		{
			List<Transform> _collectibleSpotAvaible = allCollectibleSpot;
			List<Transform> _usedSpot = new List<Transform>();

			for (int i = 0; i < numberOfCollectible; i++)
			{
				int _randomTransform = Random.Range(0, _collectibleSpotAvaible.Count-1);
				_usedSpot.Add(_collectibleSpotAvaible[_randomTransform]);
				_collectibleSpotAvaible.Remove(_collectibleSpotAvaible[_randomTransform]);
			}

			for  (int j = 0; j < _usedSpot.Count -1;  j++)
			{
				Transform _posToSet = _usedSpot[j];
				NetworkObjectsManager.Instance.NetworkInstantiate(11, _posToSet.position, _posToSet.rotation.eulerAngles);
			}
		}
	}
}

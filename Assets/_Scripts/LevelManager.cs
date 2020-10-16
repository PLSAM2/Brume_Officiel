using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelManager : MonoBehaviour
{
	public static LevelManager instance;
	[SerializeField] List<Transform> allCollectibleSpot;
	List<Transform> collectibleSpotAvaible;
	[SerializeField]int numberOfCollectible;
	int _pickableAvaible;
	public int numberOfPickableAvaible { get => _pickableAvaible; set { _pickableAvaible = value; CheckForRepop(); } }

	private void Awake ()
	{

		if (instance != null && instance != this)
		{
			Destroy(this.gameObject);
		}
		else
		{
			instance = this;
		}
	}
	private void Start ()
	{
		collectibleSpotAvaible = allCollectibleSpot;
		GeneratePickable(numberOfCollectible);
	}

	void GeneratePickable(int _numberToPop)
	{
		if (RoomManager.Instance.GetLocalPlayer().IsHost)
		{
			List<Transform> _usedSpot = new List<Transform>();

			for (int i = 0; i < _numberToPop; i++)
			{
				int _randomTransform = Random.Range(0, collectibleSpotAvaible.Count - 1);

				_usedSpot.Add(collectibleSpotAvaible[_randomTransform]);

				collectibleSpotAvaible.RemoveAt(_randomTransform);
			}

			for (int j = 0; j < _usedSpot.Count - 1; j++)
			{
				Transform _posToSet = _usedSpot[j];
				NetworkObjectsManager.Instance.NetworkInstantiate(11, _posToSet.position, _posToSet.rotation.eulerAngles);
			}
		}
	}

	public void KillPickup(Transform _positionFreed)
	{
		collectibleSpotAvaible.Add(_positionFreed);
		_pickableAvaible -= 1;
	}

	void CheckForRepop()
	{
		if (numberOfPickableAvaible<= numberOfCollectible/3)
		{
			GeneratePickable(_pickableAvaible);
		}
	}
}

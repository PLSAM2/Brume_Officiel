using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Decoy : MonoBehaviour, Damageable
{
	public UIDecoy myUI;

	public float lifeTime = 6;

	public Animator alliedMesh, enemyMesh;

	public Team myTeam;

	public Sc_CharacterParameters reParameter;

	public FootstepAudio myFootStep;

	public NetworkedObject netObj;

	public CharacterController charac;

	Quaternion uiRotation;

	public bool isInBrume = false;

	public LayerMask maskBrume;

	Vector3 lastRecordedPos;

	public Sc_Status stateAppliedWhenWKilled;

	public float timeAlive = 5;

    public List<GameObject> fires = new List<GameObject>();

	private void Awake ()
	{
		uiRotation = myUI.transform.rotation;
	}

	private void OnEnable ()
	{
		netObj.OnSpawnObj += Init;
		StartCoroutine(WaitForVisionCheck());

		if (netObj.GetIsOwner())
		{
			StartCoroutine(WaitToDestroy());
		}
	}

	private void OnDisable ()
	{
		StopAllCoroutines();
		LocalPoolManager.Instance.SpawnNewGenericInLocal(3, transform.position, transform.rotation.eulerAngles.y , 1f);
	}

	public void Init ()
	{
		PlayerData _tempData = netObj.GetOwner();
		myTeam = _tempData.playerTeam;


		myFootStep.isDecoy = true;
		myFootStep.myDecoy = this;

        int hpMax = reParameter.maxHealth;
        hpMax += GameFactory.GetBonusHp(_tempData.ID);

        myUI.Init(myTeam, _tempData.Name, GameManager.Instance.networkPlayers[_tempData.ID].liveHealth, hpMax);

		if (NetworkManager.Instance.GetLocalPlayer().playerTeam != myTeam)
		{
			enemyMesh.gameObject.SetActive(true);
			alliedMesh.gameObject.SetActive(false);
		}
		else
		{
			enemyMesh.gameObject.SetActive(false);
			alliedMesh.gameObject.SetActive(true);

            myFootStep.doFootStepIcon = true;

            if (GameManager.Instance.networkPlayers.ContainsKey(netObj.GetOwnerID()))
            {
                if (GameManager.Instance.networkPlayers[netObj.GetOwnerID()].myPlayerModule.state.HasFlag(En_CharacterState.PoweredUp))
                {
                    foreach(GameObject fire in fires)
                    {
                        fire.SetActive(true);
                    }
                }
            }
		}
	}

	IEnumerator WaitToDestroy ()
	{
		yield return new WaitForSeconds(timeAlive);
		NetworkObjectsManager.Instance.DestroyNetworkedObject(netObj.GetItemID());
	}

	void Update ()
	{
		charac.Move(transform.forward * reParameter.movementParameters.movementSpeed * Time.deltaTime);
		enemyMesh.SetBool("IsMoving", true);
		alliedMesh.SetBool("IsMoving", true);

		//test in brume
		RaycastHit hit;
		isInBrume = (Physics.Raycast(transform.position + Vector3.up * 1, -Vector3.up, out hit, 10, maskBrume));
	}

	private void LateUpdate ()
	{
		myUI.transform.rotation = uiRotation;
	}

	public void DealDamages ( DamagesInfos _damagesToDeal, Transform _positionOfTheDealer, ushort? dealerID = null, bool ignoreStatusAndEffect = false, bool ignoreTickStatus = false, float _percentageOfTheMovement = 1 )
	{

		NetworkObjectsManager.Instance.DestroyNetworkedObject(netObj.GetItemID(), true);
		if (dealerID != null)
			GameManager.Instance.networkPlayers[(ushort)dealerID].myPlayerModule.AddStatus(stateAppliedWhenWKilled.effect);
	}

	public bool IsInMyTeam ( Team _indexTested )
	{
		return _indexTested == myTeam;
	}

	public IEnumerator WaitForVisionCheck ()
	{
		CheckForBrumeRevelation();
		yield return new WaitForSeconds(.25f);
		CheckForBrumeRevelation();
		yield return new WaitForSeconds(.25f);
		CheckForBrumeRevelation();
		yield return new WaitForSeconds(.8f);
		StartCoroutine(WaitForVisionCheck());
	}

	void CheckForBrumeRevelation ()
	{

		if (GameManager.Instance.currentLocalPlayer == null)
		{
			return;
		}

		if (ShouldBePinged())
		{
			//Debug.Log("I shouldBePinged");
			if (GameManager.Instance.currentLocalPlayer.IsInMyTeam(myTeam))
				LocalPoolManager.Instance.SpawnNewGenericInLocal(1, transform.position + Vector3.up * 0.1f, 90, 1);
			else
				LocalPoolManager.Instance.SpawnNewGenericInLocal(2, transform.position + Vector3.up * 0.1f, 90, 1);

		}

		lastRecordedPos = transform.position;
	}

	bool ShouldBePinged ()
	{
		//le perso a pas bougé
		if (lastRecordedPos == transform.position || isInBrume)
			return false;

		//on choppe le player local
		PlayerModule _localPlayer = GameFactory.GetActualPlayerFollow().myPlayerModule;

		if (!_localPlayer.isInBrume)
			return false;

		//DISTANCE > a la range
		if (Vector3.Distance(transform.position, _localPlayer.transform.position) >= _localPlayer.characterParameters.detectionRange)
			return false;

		return true;
	}
}

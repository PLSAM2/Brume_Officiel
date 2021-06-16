using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Sirenix.OdinInspector;
using DG.Tweening;
using UnityEngine.Events;

public class Aoe : AutoKill
{
	[TabGroup("AoeParameters")] public Sc_Aoe localTrad;
	bool asDealtFinal = false;
	LayerMask allyLayer, enemyLayer;
	public bool adaptiveRange = true;
	DamagesInfos damageOnEnable, damageOnDisable;
	[SerializeField] AudioClip procSound;
	public UnityEvent OnApparition, OnPrewarm,OnProck, OnDisparition;
	public float timeToPrewarm;
	public GameObject objectToSpawnOnBuff;
	bool hasPrewarmed=false;


	protected override void Awake ()
	{
		allyLayer = LayerMask.GetMask("CharacterIntengible") | LayerMask.GetMask("AlliedCharacter");
		enemyLayer = LayerMask.GetMask("Character");

		mylifeTime = localTrad.rules.durationOfTheAoe;
		myLivelifeTime = mylifeTime;


		damageOnEnable = new DamagesInfos();
		damageOnDisable = new DamagesInfos();

		ResetDamage();

	}


	void ResetDamage ()
	{
		damageOnEnable.damageHealth = localTrad.rules.damagesToDealOnImpact.damageHealth;
		damageOnEnable.movementToApply = localTrad.rules.damagesToDealOnImpact.movementToApply;
		damageOnEnable.statusToApply = localTrad.rules.damagesToDealOnImpact.statusToApply;

		damageOnDisable.damageHealth = localTrad.rules.finalDamages.damageHealth;
		damageOnDisable.movementToApply = localTrad.rules.finalDamages.movementToApply;
		damageOnDisable.statusToApply = localTrad.rules.finalDamages.statusToApply;
	}

	public override void Init ( GameData.Team ownerTeam, float _LifePercentage )
	{
		base.Init(ownerTeam, _LifePercentage);
		OnApparition?.Invoke();
		ResetDamage();
		/*if (GameManager.Instance.gameStarted)
		{
			if ((GameManager.Instance.currentLocalPlayer.myPlayerModule.state & En_CharacterState.PoweredUp) != 0 && isOwner)
			{
				print("I m powered up");
				if (damageOnEnable.damageHealth > 0)
				{
					damageOnEnable.damageHealth = (ushort)(localTrad.rules.damagesToDealOnImpact.damageHealth + 1);
					GameManager.Instance.currentLocalPlayer.myPlayerModule.RemoveState(En_CharacterState.PoweredUp);

				}
				if (damageOnDisable.damageHealth > 0)
				{
					damageOnDisable.damageHealth = (ushort)(localTrad.rules.finalDamages.damageHealth + 1);
					GameManager.Instance.currentLocalPlayer.myPlayerModule.RemoveState(En_CharacterState.PoweredUp);
				}
			}
	}
		*/
		hasPrewarmed = false;
		if (isOwner)
		{
			if (localTrad.rules.damagesToDealOnImpact.isUsable)
				DealDamagesInRange(damageOnEnable);

			if (localTrad.rules.impactAlly.isUsable)
				DealBuffInRange(localTrad.rules.impactAlly);
		}

		//ResetDamage();
	}

	protected void DealDamagesInRange ( DamagesInfos _damages )
	{
		if (isOwner)
		{

			foreach (Collider _coll in enemiesTouched())
			{
				Damageable _damageable = _coll.GetComponent<Damageable>();


				if (_damageable != null)
				{
					if (!_damageable.IsInMyTeam(GameManager.Instance.currentLocalPlayer.myPlayerModule.teamIndex))
					{

						float _percentageOfStrength = 1;

						Transform _posOfDealing = transform;

						if (_damages.movementToApply != null)
						{

							if (adaptiveRange)
							{
								if (localTrad.rules.isBox)
								{
									if (_damages.movementToApply.isGrab)
										_percentageOfStrength = Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z / 2;
									else
										_percentageOfStrength = (1 - (Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z) / 2);

								}
								else
								{
									if (_damages.movementToApply.isGrab)
										_percentageOfStrength = (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius);

									else
										_percentageOfStrength = (1 - (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius));
								}
							}

							if (localTrad.rules.useOwnerPos)
								_posOfDealing = GameManager.Instance.networkPlayers[myNetworkObject.GetOwnerID()].transform;
						}

						_damageable.DealDamages(_damages, _posOfDealing, GameManager.Instance.currentLocalPlayer.myPlayerId, false, false, _percentageOfStrength);



						if (enemiesTouched().Length > 0 && localTrad.cooldownReductionOnHit > 0)
							GameManager.Instance.currentLocalPlayer.myPlayerModule.reduceTargetCooldown(localTrad.cooldownReductionOnHit, localTrad.cooldownReducedOnHit);
					}
				}
			}


		}
	}

	protected void DealBuffInRange ( DamagesInfos _buff )
	{
		if (isOwner)
		{
			foreach (Collider _coll in alliedTouched())
			{
				LocalPlayer _damageable = _coll.GetComponent<LocalPlayer>();

				Transform _posOfDealing = transform;

				if (_damageable != null && _damageable.IsInMyTeam(myteam))
				{
					NetworkObjectsManager.Instance.NetworkAutoKillInstantiate(NetworkObjectsManager.Instance.GetPoolID(objectToSpawnOnBuff), _coll.transform.position, transform.eulerAngles, 1);

					float _percentageOfStrength = 1;
					if (_buff.movementToApply != null)
					{
						if (adaptiveRange)
						{
							if (localTrad.rules.isBox)
							{
								if (_buff.movementToApply.isGrab)
									_percentageOfStrength = Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z / 2;
								else
									_percentageOfStrength = (1 - (Mathf.Abs(transform.position.x - _coll.transform.position.x) / localTrad.rules.boxDimension.x + Mathf.Abs(transform.position.z - _coll.transform.position.z) / localTrad.rules.boxDimension.z) / 2);

							}
							else
							{
								if (_buff.movementToApply.isGrab)
									_percentageOfStrength = (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius);

								else
									_percentageOfStrength = (1 - (Vector3.Distance(transform.position, _coll.transform.position) / localTrad.rules.aoeRadius));
							}
						}

						if (localTrad.rules.useOwnerPos)
							_posOfDealing = GameManager.Instance.networkPlayers[myNetworkObject.GetOwnerID()].transform;
					}

					_damageable.DealDamages(_buff, _posOfDealing, GameManager.Instance.currentLocalPlayer.myPlayerId, false, false, _percentageOfStrength);
					//_damageable.SendStatus(_buff.statusToApply[0]);
				}

				if (_coll.gameObject == GameManager.Instance.currentLocalPlayer.gameObject)
					_coll.GetComponent<PlayerModule>().AddStatus(_buff.statusToApply[0].effect);
			}
		}
	}

	protected Collider[] enemiesTouched ()
	{
		Collider[] _allhits;

		if (localTrad.rules.isBox)
			_allhits = Physics.OverlapBox(transform.position, localTrad.rules.boxDimension / 2 + Vector3.up * 8, transform.rotation, enemyLayer);
		else
			_allhits = Physics.OverlapSphere(transform.position, localTrad.rules.aoeRadius, enemyLayer);

		return _allhits;
	}

	protected Collider[] alliedTouched ()
	{
		Collider[] _allhits;

		if (localTrad.rules.isBox)
			_allhits = Physics.OverlapBox(transform.position, localTrad.rules.boxDimension / 2 + Vector3.up * 8, Quaternion.identity, allyLayer);
		else
			_allhits = Physics.OverlapSphere(transform.position, localTrad.rules.aoeRadius, allyLayer);

		return _allhits;
	}

	protected override void Update ()
	{
		base.Update();
		if (myLivelifeTime <= localTrad.rules.timeBeforeFinalDisparition &&
			localTrad.rules.timeBeforeFinalDisparition != 0 &&
				!asDealtFinal)
		{
			StopAllCoroutines();
			asDealtFinal = true;
			OnProck?.Invoke();

			if (localTrad.rules.finalDamages.isUsable)
			{
				if (localTrad.screenShake && Vector3.Distance(GameManager.Instance.currentLocalPlayer.transform.position, transform.position) <=8)
				{
					CameraManager.Instance.SetNewCameraShake(localTrad.duration, localTrad.intensity);
				}

				DealDamagesInRange(damageOnDisable);
				if (procSound != null)
					AudioManager.Instance.Play3DAudio(procSound, transform.position, myNetworkObject.GetItemID(), false);
			}

			if (localTrad.rules.finalAlly.isUsable)
				DealBuffInRange(localTrad.rules.finalAlly);
		}

		if (myLivelifeTime <= timeToPrewarm && !hasPrewarmed)
		{
			hasPrewarmed = true;
			OnPrewarm?.Invoke();

		}
	}

	private void OnDrawGizmosSelected ()
	{
		if (localTrad.rules.isBox)
			Gizmos.DrawCube(transform.position, localTrad.rules.boxDimension);
		else
			Gizmos.DrawSphere(transform.position, localTrad.rules.aoeRadius);
	}

	public override void Destroy ( bool _spawnAoe = false )
	{
		OnDisparition?.Invoke();
		StopAllCoroutines();
		base.Destroy();
	}

	protected void OnEnable ()
	{
		asDealtFinal = false;

	}

	protected override void OnDisable ()
	{
		base.OnDisable();
		StopAllCoroutines();
	}

	public void LerpParameter(MeshRenderer _renderer)
	{
		_renderer.material.SetFloat( "_FillAmount", 0.35f);

		_renderer.material.DOFloat(1, "_FillAmount",.65f);
	}
}
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class MovementModule : MonoBehaviour
{

    [Header("Basic elements")]
    St_MovementParameters parameters;
    public LayerMask movementBlockingLayer, dashBlockingLayer;
    public CharacterController chara;
    [HideInInspector] public bool rotLocked = false;


    /*	[Header("Running Stamina")]
		[SerializeField] bool usingStamina;
		float timeSpentRunning,  timeSpentNotRunning, _stamina;
		public float Stamina {	get => _stamina; 
			set { 
				_stamina = value;
				UiManager.Instance.UpdateUiCooldownSpell(En_SpellInput.Maj, _stamina , parameters.maxStamina); 	} 
		}
		bool running = false;*/
    //DASH 
    [ReadOnly] public ForcedMovement currentForcedMovement = null;
    //recup des actions
    PlayerModule myPlayerModule;


    [BoxGroup("Dummy")] public bool isADummy = false;
    private void Start()
    {
        Init();
    }
    public void Init()
    {
        if (isADummy)
        {
            return;
        }
        myPlayerModule = GetComponent<PlayerModule>();

        if (myPlayerModule.mylocalPlayer.isOwner)
        {
            myPlayerModule.DirectionInputedUpdate += Move;
            myPlayerModule.forcedMovementAdded += AddDash;
        }


        /*myPlayerModule.toggleRunning += ToggleRunning;
		myPlayerModule.stopRunning += StopRunning;*/

        //IMPORTANT POUR LES CALLBACKS

        currentForcedMovement.myModule = myPlayerModule;

        rotLocked = false;
    }

    void OnDisable()
    {
        if (myPlayerModule == null)
        {
            return;
        }

        if (myPlayerModule.mylocalPlayer.isOwner)
        {
            myPlayerModule.DirectionInputedUpdate -= Move;
            myPlayerModule.forcedMovementAdded -= AddDash;
        }
        //	myPlayerModule.toggleRunning -= ToggleRunning;
        //	myPlayerModule.stopRunning -= StopRunning;
    }

    public void SetupComponent(St_MovementParameters _newParameters)
    {
        parameters = _newParameters;
        //stamina
        //_stamina = parameters.maxStamina;
        //Stamina = parameters.maxStamina;
    }

    void Move(Vector3 _directionInputed)
    {
        //forceMovement
        if (currentForcedMovement != null)
        {
            currentForcedMovement.duration -= Time.deltaTime;

            if (currentForcedMovement.duration <= 0)
            {
                currentForcedMovement = null;

                if (!isADummy)
                {
                    myPlayerModule.forcedMovementInterrupted?.Invoke();
                }

                return;
            }
            if (IsFree(currentForcedMovement.direction, dashBlockingLayer, currentForcedMovement.strength * Time.deltaTime))
            {
                chara.Move(new Vector3(currentForcedMovement.direction.x, 0, currentForcedMovement.direction.z) *
                    (currentForcedMovement.strength * currentForcedMovement.speedEvolution.Evaluate(1 - (currentForcedMovement.duration / currentForcedMovement.baseDuration))) * Time.deltaTime);
            }
            else
            {
                ForcedMovementTouchObstacle();
            }

        }
        //movement normal
        else if (_directionInputed != Vector3.zero && CanMove() && !isADummy)
        {
            chara.Move(_directionInputed * LiveMoveSpeed() * Time.deltaTime);
            myPlayerModule.onSendMovement?.Invoke(_directionInputed);
        }
        else if (!isADummy)
        {
            myPlayerModule.onSendMovement?.Invoke(Vector3.zero);
        }
    }

    public void ForcedMovementTouchObstacle()
    {
        //juste pour caler le callback comme quoi le mouvement est bien fini;
        currentForcedMovement.duration = 0;
    }

    public void AddDash(ForcedMovement infos)
    {
        ForcedMovement _temp = new ForcedMovement();
        _temp.direction = infos.direction;
        _temp.duration = infos.duration;
        _temp.baseDuration = infos.duration;
        _temp.strength = infos.strength;
        _temp.myModule = myPlayerModule;
        _temp.speedEvolution = infos.speedEvolution;
        currentForcedMovement = _temp;
    }

    private void Update()
    {
        if (isADummy)
        {
            Move(Vector3.zero);
            return;
        }
        
        if (myPlayerModule.mylocalPlayer.isOwner)
        {
            if (currentForcedMovement != null)
            {
                if (myPlayerModule.HasState(En_CharacterState.ForcedMovement) == false)
                {
                    myPlayerModule.AddState(En_CharacterState.ForcedMovement);
                } 
            } else
            {
                if (myPlayerModule.HasState(En_CharacterState.ForcedMovement))
                {
                    myPlayerModule.RemoveState(En_CharacterState.ForcedMovement);
                }
            }


            //rot player
            LookAtMouse();
        }
        else
            return;
    }
    void LookAtMouse()
    {
        if (!rotLocked)
        {
            Vector3 _currentMousePos = myPlayerModule.mousePos();
            transform.LookAt(new Vector3(_currentMousePos.x, transform.position.y, _currentMousePos.z));
        }
    }

    public Vector3 FreeLocation(Vector3 _locationToFindFrom, float maxRange)
    {
        Collider[] _hits;
        _locationToFindFrom.y = 0;

        _hits = Physics.OverlapCapsule(_locationToFindFrom + Vector3.down * 10, _locationToFindFrom + Vector3.up * 10, chara.radius, dashBlockingLayer);
        if (_hits.Length > 0)
        {
            return TryToFindFreePos(_locationToFindFrom, 1);
        }
        else
        {
            Debug.DrawLine(_locationToFindFrom + Vector3.down * 10, _locationToFindFrom + Vector3.up * 10, Color.red, 1000);
            return _locationToFindFrom;
        }
    }

    /*
	if (Physics.Raycast(_locationToFindFrom + Vector3.up *50,Vector3.down, 60, dashBlockingLayer))
	{
		Vector3 _direction = (_locationToFindFrom - transform.position).normalized;

		//	Vector3 _direction = (transform.position - _locationToFindFrom).normalized;
		RaycastHit _closestHit;
		//trouver le bord de collider dans la direction du joueur
		if (Physics.Raycast(_locationToFindFrom, _direction, out _closestHit, 100, dashBlockingLayer))
		{
			//trouver le bord de collider dans la direction inverse du joueur
			RaycastHit _farthestHit;
			if (Physics.Raycast(_locationToFindFrom, -_direction, out _farthestHit, 100, dashBlockingLayer))
			{

				if (Vector3.Distance(_closestHit.point, _locationToFindFrom) > Vector3.Distance(_farthestHit.point, _locationToFindFrom))
					return _farthestHit.point - _direction * chara.radius;
				else
					return _closestHit.point + _direction * chara.radius;
			}
			else
				return _closestHit.point + _direction * chara.radius;
		}
		else
			return transform.position;
	}
	else
	{
		print("PosIsFree");
		return _locationToFindFrom;
	}*/

    Vector3 TryToFindFreePos(Vector3 _locationToFindFrom, int _iteration)
    {
        Collider[] _hits;
        Vector3 posToCheck = _locationToFindFrom + (transform.position - _locationToFindFrom).normalized * _iteration * chara.radius;

        _hits = Physics.OverlapCapsule(posToCheck + Vector3.down * 10,
            posToCheck + Vector3.up * 10,
            chara.radius,
            dashBlockingLayer);

        Debug.DrawLine(posToCheck + Vector3.down * 10,
            posToCheck + Vector3.up * 10,
            Color.red,
            100);

        if (_hits.Length == 0)
        {
            return posToCheck;
        }
        else
        {

            posToCheck = _locationToFindFrom - (transform.position - _locationToFindFrom).normalized * _iteration * chara.radius;
            _hits = Physics.OverlapCapsule(posToCheck + Vector3.down * 10,
            posToCheck + Vector3.up * 10,
            chara.radius,
            dashBlockingLayer);

            Debug.DrawLine(posToCheck + Vector3.down * 10,
                        posToCheck + Vector3.up * 10,
                        Color.red,
                        100);

            if (_hits.Length == 0)
            {
                return posToCheck;
            }
            else
                return TryToFindFreePos(_locationToFindFrom, _iteration + 1);
        }
    }
    /*void StopRunning()
	{
		timeSpentRunning = 0;
		running = false;
	}

	void StartRunning()
	{
		timeSpentNotRunning = 0;
		running = true;
	}

	void ToggleRunning()
	{
		if (running)
			StopRunning();
		else
			StartRunning();
	}*/


    //Parameters
    #region
    /* si plusieurs mouvement forcé en même temps s additione;
	Vector3 ForcedMovement ()
	{
		Vector3 _forceToApply = Vector3.zero;

		if (allForcedMovement.Count > 0)
		{
			List<ForcedMovement> _movementToKeep = new List<ForcedMovement>();

			foreach (ForcedMovement _movement in allForcedMovement)
			{
				_forceToApply += (Vector3.Normalize(_movement.direction) * _movement.strength);
				_movement.duration -= Time.deltaTime;

				if (_movement.duration > 0)
					_movementToKeep.Add(_movement);
			}

			allForcedMovement = _movementToKeep;
		}

		return _forceToApply;
	}*/

    Vector3 SlideVector(Vector3 _directionToSlideFrom)
    {
        RaycastHit _hitToRead = CastSphereAll(_directionToSlideFrom, movementBlockingLayer, chara.radius, transform.position)[0];


        Vector3 _aVector = new Vector3(-_hitToRead.normal.z, 0, _hitToRead.normal.x);
        Vector3 _bVector = new Vector3(_hitToRead.normal.z, 0, -_hitToRead.normal.x);

        if (Vector3.Dot(_directionToSlideFrom, _aVector) > 0)
        {
            if (IsFree(_aVector, movementBlockingLayer, chara.radius))
                return _aVector;
            else
                return Vector3.zero;
        }
        else if (Vector3.Dot(_directionToSlideFrom, _bVector) > 0)
        {
            if (IsFree(_bVector, movementBlockingLayer, chara.radius))
            {
                return _bVector;
            }
            else
                return Vector3.zero;
        }
        else
            return Vector3.zero;

    }

    public bool IsFree(Vector3 _direction, LayerMask _layerTocheck, float _maxRange)
    {
        if (CastSphereAll(_direction, _layerTocheck, _maxRange, transform.position) != null)
            return false;
        else
            return true;
    }

    bool CanMove()
    {
        if ((myPlayerModule.state & En_CharacterState.Root) != 0 || currentForcedMovement != null)
        {
            return false;
        }
        else
            return true;
    }

    float LiveMoveSpeed()
    {
        float _worstMalus = 0;
        float _allBonuses = 0;

        foreach (EffectLifeTimed _liveEffect in myPlayerModule.allEffectLive)
        {
            if ((_liveEffect.effect.stateApplied & En_CharacterState.Slowed) != 0)
            {
                if (_liveEffect.effect.percentageOfTheMovementModifier * _liveEffect.effect.decayOfTheModifier.Evaluate(_liveEffect.liveLifeTime / _liveEffect.baseLifeTime) > _worstMalus)
                    _worstMalus = _liveEffect.effect.percentageOfTheMovementModifier * _liveEffect.effect.decayOfTheModifier.Evaluate(_liveEffect.liveLifeTime / _liveEffect.baseLifeTime);
            }
            else if ((_liveEffect.effect.stateApplied & En_CharacterState.SpedUp) != 0)
            {
                _allBonuses += _liveEffect.effect.percentageOfTheMovementModifier * _liveEffect.effect.decayOfTheModifier.Evaluate(_liveEffect.liveLifeTime / _liveEffect.baseLifeTime);
            }
        }
        /*float defspeed = parameters.movementSpeed + parameters.accelerationCurve.Evaluate(timeSpentRunning/ parameters.accelerationTime) * parameters.bonusRunningSpeed;*/

        float _baseSpeed = 0;

        if ((myPlayerModule.state & En_CharacterState.Crouched) != 0)
            _baseSpeed = parameters.crouchingSpeed;

        else
            _baseSpeed = parameters.movementSpeed;


        return _baseSpeed * (1 + _allBonuses) * (1 - _worstMalus);

    }

    List<RaycastHit> CastSphereAll(Vector3 _direction, LayerMask _checkingLayer, float _maxRange, Vector3 _origin)
    {
        List<RaycastHit> _allHit = Physics.SphereCastAll(_origin,
            chara.radius,
            _direction,
            _maxRange,
            _checkingLayer).ToList<RaycastHit>();

        List<RaycastHit> _returnList = new List<RaycastHit>();
        if (_allHit.Count > 0)
        {
            for (int i = 0; i < _allHit.Count; i++)
            {
                if (_allHit[i].collider.gameObject != this.gameObject)
                {
                    _returnList.Add(_allHit[i]);
                }
            }
            return _returnList;
        }
        else
            return null;
    }
    #endregion
}

[System.Serializable]
public class ForcedMovement
{
    [HideInInspector] public PlayerModule myModule;
    [SerializeField] float _duration = 0;

    public float duration
    {
        get => _duration;
        set
        {
            _duration = value;
        }
    }
    [HideInInspector] public float baseDuration;
    public AnimationCurve speedEvolution = new AnimationCurve(new Keyframe(1, 1), new Keyframe(1, 1));
    Vector3 _direction;
    public Vector3 direction { get => _direction; set { _direction = Vector3.Normalize(value); } }
    public float strength;
    [ReadOnly] public float length => duration * strength;
    public float fakeRange;
}
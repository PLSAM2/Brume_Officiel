using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Cinemachine;
using Sirenix.OdinInspector;

public class CameraManager : MonoBehaviour
{
	private static CameraManager _instance;
	public static CameraManager Instance { get { return _instance; } }

	[TabGroup("CameraScroll")] [SerializeField] float /*percentageOfTheScreenToScrollFromWidth = .1f, percentageOfTheScreenToScrollFromHeight = .1f, scrollingSpeed = 10,*/pixelToScrollFrom = 700, maxPixelTraveled = 200, maxDistanceInGameTraveled = 3, heightMultiplier = 1.4f;
	Transform cameraLocker;
	public Action UpdateCameraPos, LockCamera;

	//float et taille d ecran histoire que on la recalcule pas a chaque fois
	Vector2 pixelSizeScreen;
	float minX, maxX, minY, maxY, screenEdgeBorder;
	bool isLocked = false;


	public Transform playerToFollow;
	[SerializeField] CinemachineVirtualCamera myCinemachine;
	CinemachineBasicMultiChannelPerlin myCinemachinePerlin;
	[SerializeField] LayerMask groundlayer;
	float screenEdgeBorderHeight, screenEdgeBorderWidth;
	Camera cam;
	public bool isSpectate = false;
	public bool endGame = false;
	private float cameraShakeTimer = 0;
	private bool cameraShakeStarted = false;
	[HideInInspector] public Action<CameraManager> OnWatchCameraBorder;
	[HideInInspector] public bool listeningCameraInput = false;
	private void Awake ()
	{
		if (_instance != null && _instance != this)
		{
			Destroy(this.gameObject);
		}
		else
		{
			_instance = this;
		}
		cam = Camera.main;
	}

	private void OnEnable ()
	{
		UpdateCameraPos += CameraScroll;
		LockCamera += LockingCam;
	}

	private void OnDisable ()
	{
		UpdateCameraPos -= CameraScroll;
		LockCamera -= LockingCam;
	}

	private void Start ()
	{
		GameObject _go = new GameObject();
		cameraLocker = _go.transform;
		myCinemachine.Follow = _go.transform;
		myCinemachinePerlin = myCinemachine.GetCinemachineComponent<CinemachineBasicMultiChannelPerlin>();
		OnResolutionChanged();

		/*screenEdgeBorderHeight = Screen.height * percentageOfTheScreenToScrollFromHeight;
		screenEdgeBorderWidth = Screen.width * percentageOfTheScreenToScrollFromWidth;*/

		
	}

	public void SetParent ( Transform _characterToStick )
	{
		playerToFollow = _characterToStick;
		cameraLocker.transform.position = _characterToStick.transform.position;
	}

	void OnResolutionChanged ()
	{
		pixelSizeScreen = new Vector2(Screen.width, Screen.height);
		/*minX = pixelSizeScreen.x / 2 - pixelSizeScreen.x * percentageOfTheScreenToScrollFromWidth;
		maxX = pixelSizeScreen.x / 2 + pixelSizeScreen.x * percentageOfTheScreenToScrollFromWidth;
		minY = pixelSizeScreen.y / 2 - pixelSizeScreen.y * percentageOfTheScreenToScrollFromHeight;
		maxY = pixelSizeScreen.y / 2 + pixelSizeScreen.y * percentageOfTheScreenToScrollFromHeight;*/
	}

	public void LockingCam ()
	{
		isLocked = true;
	}

	void LerpCameraPos ()
	{
		LocalPlayer _character = GameManager.Instance.currentLocalPlayer;
        if(_character == null) {

            return;
        }

		float _distanceY = Vector2.Distance(new Vector2(0, Input.mousePosition.y) , new Vector2(0, pixelSizeScreen.y / 2)) * heightMultiplier;
		float _distanceX = Vector2.Distance(new Vector2( Input.mousePosition.x,0) , new Vector2( pixelSizeScreen.x / 2, 0)) ;
		float _distanceFromCenter = Mathf.Sqrt(_distanceY * _distanceY + _distanceX * _distanceX);

		if (_distanceFromCenter > pixelToScrollFrom)
		{
			if(_distanceFromCenter > pixelToScrollFrom*1.3f & listeningCameraInput)
			{ 
				OnWatchCameraBorder?.Invoke(this);
			}

			Vector3 _direction = new Vector3( Input.mousePosition.x - pixelSizeScreen.x / 2, 0,( Input.mousePosition.y - pixelSizeScreen.y / 2) * heightMultiplier).normalized;
			cameraLocker.transform.position = _character.transform.position + _direction * Mathf.Clamp((_distanceFromCenter - pixelToScrollFrom) / maxPixelTraveled, 0, maxDistanceInGameTraveled);
		}
		else
			cameraLocker.transform.position = playerToFollow.transform.position;
	}

	Vector3 CenterOfScreen()
	{
		Ray ray = Camera.main.ScreenPointToRay(new Vector2(pixelSizeScreen.x /2, pixelSizeScreen.y /2));
		RaycastHit hit;

		if (Physics.Raycast(ray, out hit, Mathf.Infinity, 1 << 10))
		{
			return new Vector3(hit.point.x, 0, hit.point.z);
		}
		else
		{
			return Vector3.zero;
		}
	}

	void CameraScroll ()
	{
		//isLocked = false;

		float inputX = Input.mousePosition.x;
		float inputY = Input.mousePosition.y;

		/*if (inputX <= minX)
		{
			print("Scroll left");
			float posX = (minX - inputX) / pixelSizeScreen.x;
			cameraLocker.position -= new Vector3(( * scrollingSpeed * Time.deltaTime, 0, 0);
		}
		else if (inputX >= maxX)
		{
			print("Scroll right");

			cameraLocker.position += new Vector3(((inputX - maxX) / pixelSizeScreen.x) * scrollingSpeed * Time.deltaTime, 0, 0);
		}

		if (inputY <= minY)
		{
			print("Scroll down");

			cameraLocker.position -= new Vector3(0, 0, ((minY - inputY) / pixelSizeScreen.y) * scrollingSpeed * Time.deltaTime);
		}
		else if (inputY >= maxY)
		{
			print("Scroll up");

			cameraLocker.position += new Vector3(0, 0, ((inputY - maxY) / pixelSizeScreen.y) * scrollingSpeed * Time.deltaTime);
		}
		cameraLocker.position = new Vector3(cameraLocker.position.x, 0, cameraLocker.position.z);
		//}

		/*
					float inputX = Input.mousePosition.x;
					float inputY = Input.mousePosition.y;

					if (inputX <= minX || inputX >= maxX || inputY <= minY || inputY >= maxY)
					{
						cameraLocker.position += Vector3.Normalize(playerToFollow.mousePos() - cameraLocker.position) * scrollingSpeed;
						//new Vector3(0, 0, ((inputY - maxY) / pixelSizeScreen.y) * scrollingSpeed * Time.deltaTime);
					}
			*/
	/*	Vector3 desiredMove = new Vector3();

		Rect leftRect = new Rect(0, 0, screenEdgeBorderWidth, Screen.height);
		Rect rightRect = new Rect(Screen.width - screenEdgeBorderWidth, 0, screenEdgeBorderWidth, Screen.height);
		Rect upRect = new Rect(0, Screen.height - screenEdgeBorderHeight, Screen.width, screenEdgeBorderHeight);
		Rect downRect = new Rect(0, 0, Screen.width, screenEdgeBorderHeight);

		desiredMove.x = leftRect.Contains(MouseInput) ? -1 : rightRect.Contains(MouseInput) ? 1 : 0;
		desiredMove.z = upRect.Contains(MouseInput) ? 1 : downRect.Contains(MouseInput) ? -1 : 0;
		desiredMove *= scrollingSpeed;

		desiredMove *= Time.deltaTime;
		desiredMove.y = 0;
		cameraLocker.position += new Vector3(desiredMove.x, 0, desiredMove.z);*/
	}

	private Vector2 MouseInput
	{
		get { return Input.mousePosition; }
	}


	private void Update ()
	{
		if (cameraShakeTimer > 0 && cameraShakeStarted)
		{
			cameraShakeTimer -= Time.deltaTime;

			if (cameraShakeTimer < 0)
			{
				myCinemachinePerlin.m_AmplitudeGain = 0;
				cameraShakeStarted = false;
				cameraShakeTimer = 0;
			}
		}
		LerpCameraPos();
	}

	private void LateUpdate ()
	{

        if (endGame)
        {
			myCinemachine.m_Lens.FieldOfView = Mathf.Lerp(myCinemachine.m_Lens.FieldOfView, 50, Time.deltaTime * 5);
			return;
        }


        LocalPlayer currentPlayer = GameFactory.GetActualPlayerFollow();

        if (currentPlayer)
        {
            if (GameFactory.GetActualPlayerFollow().myPlayerModule.state.HasFlag(En_CharacterState.Crouched))
            {
                myCinemachine.m_Lens.FieldOfView = Mathf.Lerp(myCinemachine.m_Lens.FieldOfView, 64, Time.deltaTime * 5);
            }
            else
            {
                myCinemachine.m_Lens.FieldOfView = Mathf.Lerp(myCinemachine.m_Lens.FieldOfView, 60, Time.deltaTime * 5);
            }
        }

		if (isSpectate) { return; }

		if (isLocked && GameManager.Instance.gameStarted && playerToFollow != null)
		{
			//cameraLocker.transform.position = playerToFollow.transform.position;
		}
	}

    internal void EventTutorial(MovementEvent movementEvent)
    {

			switch (movementEvent)
			{
				case MovementEvent.WatchCameraBorder:
				listeningCameraInput = true;
				OnWatchCameraBorder += TutorialManager.Instance.OnWatchCameraBorder;
					break;
				default:
					throw new Exception("not existing event");
			}
		}

    public void SetFollowObj ( Transform obj )
	{
		myCinemachine.Follow = obj;
	}

	public void ResetPlayerFollow ()
	{
		isSpectate = false;
		myCinemachine.Follow = cameraLocker;
	}

	// Camera Shake >>
	public void SetNewCameraShake ( float time, float intensity = 0.3f )
	{
		myCinemachinePerlin.m_AmplitudeGain = intensity;
		cameraShakeTimer = time;
		cameraShakeStarted = true;
	}



	// <<
}

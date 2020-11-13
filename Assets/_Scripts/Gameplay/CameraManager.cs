using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using Cinemachine;

public class CameraManager : MonoBehaviour
{
	private static CameraManager _instance;
	public static CameraManager Instance { get { return _instance; } }
	[SerializeField] float percentageOfTheScreenToScrollFromWidth = .1f, percentageOfTheScreenToScrollFromHeight = .1f, scrollingSpeed = 10;
	Transform cameraLocker;
	public static Action UpdateCameraPos, LockCamera;

	//float et taille d ecran histoire que on la recalcule pas a chaque fois
	Vector2 pixelSizeScreen;
	float minX, maxX, minY, maxY, screenEdgeBorder;
	bool isLocked = true;
	public Transform playerToFollow;
	[SerializeField] CinemachineVirtualCamera myCinemachine;
	[SerializeField] LayerMask groundlayer;
	float screenEdgeBorderHeight, screenEdgeBorderWidth;

	public bool isSpectate = false;

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
	}

	private void Start ()
	{
		UpdateCameraPos += CameraScroll;
		LockCamera += LockingCam;

		GameObject _go = new GameObject();
		cameraLocker = _go.transform;
		myCinemachine.Follow = _go.transform;

		OnResolutionChanged();

		screenEdgeBorderHeight = Screen.height * percentageOfTheScreenToScrollFromHeight;
		screenEdgeBorderWidth = Screen.width * percentageOfTheScreenToScrollFromWidth;
	}

	private void OnDestroy ()
	{
		UpdateCameraPos -= CameraScroll;
		LockCamera -= LockingCam;
	}

	public void SetParent ( Transform _characterToStick)
	{
		playerToFollow = _characterToStick;
		cameraLocker.transform.position = _characterToStick.transform.position;
	}

	void OnResolutionChanged ()
	{
		pixelSizeScreen = new Vector2(Screen.width, Screen.height);
		minX = pixelSizeScreen.x / 2 - pixelSizeScreen.x * percentageOfTheScreenToScrollFromWidth;
		maxX = pixelSizeScreen.x / 2 + pixelSizeScreen.x * percentageOfTheScreenToScrollFromWidth;
		minY = pixelSizeScreen.y / 2 - pixelSizeScreen.y * percentageOfTheScreenToScrollFromHeight;
		maxY = pixelSizeScreen.y / 2 + pixelSizeScreen.y * percentageOfTheScreenToScrollFromHeight;
	}

	public void LockingCam ()
	{
		isLocked = true;
	}

	void CameraScroll ()
	{
		isLocked = false;
		/* 
        float inputX = Input.mousePosition.x;
        float inputY = Input.mousePosition.y;

        if(inputX <= minX)
		{
            print("Scroll left");
            cameraLocker.position -= new Vector3(((minX - inputX)/pixelSizeScreen.x) * scrollingSpeed * Time.deltaTime, 0, 0);
        }
        else if (inputX >= maxX)
		{
            print("Scroll right");

            cameraLocker.position += new Vector3(((inputX - maxX) / pixelSizeScreen.x) * scrollingSpeed * Time.deltaTime,0,0);
        }

        if(inputY <= minY)
		{
            print("Scroll down");

            cameraLocker.position -= new Vector3(0,0,((minY - inputY) / pixelSizeScreen.y) * scrollingSpeed * Time.deltaTime);
        }
        else if (inputY >= maxY)
		{
            print("Scroll up");

            cameraLocker.position += new Vector3(0,0, ((inputY - maxY) / pixelSizeScreen.y) * scrollingSpeed * Time.deltaTime);
        }
        cameraLocker.position = new Vector3(cameraLocker.position.x, 0, cameraLocker.position.z);
            }*/

/*
			float inputX = Input.mousePosition.x;
			float inputY = Input.mousePosition.y;

			if (inputX <= minX || inputX >= maxX || inputY <= minY || inputY >= maxY)
			{
				cameraLocker.position += Vector3.Normalize(playerToFollow.mousePos() - cameraLocker.position) * scrollingSpeed;
				//new Vector3(0, 0, ((inputY - maxY) / pixelSizeScreen.y) * scrollingSpeed * Time.deltaTime);
			}
	*/
		Vector3 desiredMove = new Vector3();

		Rect leftRect = new Rect(0, 0, screenEdgeBorderWidth, Screen.height);
		Rect rightRect = new Rect(Screen.width - screenEdgeBorderWidth, 0, screenEdgeBorderWidth, Screen.height);
		Rect upRect = new Rect(0, Screen.height - screenEdgeBorderHeight, Screen.width, screenEdgeBorderHeight);
		Rect downRect = new Rect(0, 0, Screen.width, screenEdgeBorderHeight);

		desiredMove.x = leftRect.Contains(MouseInput) ? -1 : rightRect.Contains(MouseInput) ? 1 : 0;
		desiredMove.z = upRect.Contains(MouseInput) ? 1 : downRect.Contains(MouseInput) ? -1 : 0;
		desiredMove *= scrollingSpeed;

		desiredMove *= Time.deltaTime;
		desiredMove.y = 0;
		cameraLocker.position += new Vector3(desiredMove.x, 0,desiredMove.z) ;
			
	}

	private Vector2 MouseInput
	{
		get { return Input.mousePosition; }
	}

	private void LateUpdate ()
	{
        if (isSpectate) { return; }

		if (isLocked && GameManager.Instance.gameStarted && playerToFollow != null)
		{
			cameraLocker.transform.position = playerToFollow.transform.position;
		}
	}

	public void SetFollowObj(Transform obj)
    {
		myCinemachine.Follow = obj;
	}

	public void ResetPlayerFollow()
    {
		isSpectate = false;
		myCinemachine.Follow = cameraLocker;
	}
}

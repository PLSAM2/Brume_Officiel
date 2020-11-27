using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Ghost : MonoBehaviour
{
    [HideInInspector] public PlayerModule playerModule;
    public MovementModule movementModule;
    public NetworkedObject networkedObject;
    public GameObject fowPrefab;
    public GameObject canvas;
    public Image fillImg;

    private Quaternion canvasRot;
    private float timer = 0;
    private GameObject fowObj;
    private float saveLifeTime;

    [SerializeField] Animator myAnimator;
    [SerializeField] float speedAnim = 30;
    [SerializeField] Sc_CharacterParameters characterParameters;
	En_SpellInput inputLinked;

    public bool isVisible = false;
    public List<GameObject> objToHide = new List<GameObject>();

    private void Awake()
    {
        canvasRot = canvas.transform.rotation;
        networkedObject.OnSpawnObj += OnRespawn;
    }

    private void OnDisable()
    {
        if (playerModule == null)
        {
            return;
        }

        Destroy(fowObj);
        playerModule.thirdSpellInputRealeased -= Destruct;
    }

    private void OnEnable()
    {
        if (!networkedObject.GetIsOwner())
        {
            canvas.SetActive(false);
        }
    }

    public void Init(PlayerModule playerModule, float lifetime, float ghostSpeed, En_SpellInput _inputLinked )
    {
        canvas.SetActive(true);
        this.playerModule = playerModule;
        saveLifeTime = lifetime;
        movementModule.ghostSpeed = ghostSpeed;
        timer = saveLifeTime;
        playerModule.thirdSpellInputRealeased += Destruct;

		inputLinked = _inputLinked;

		switch (inputLinked)
		{
			case En_SpellInput.Click:
				playerModule.leftClickInput += Destruct;
				break;
			case En_SpellInput.FirstSpell:
				playerModule.firstSpellInput += Destruct;

				break;
			case En_SpellInput.SecondSpell:
				playerModule.secondSpellInput += Destruct;

				break;
			case En_SpellInput.ThirdSpell:
				playerModule.thirdSpellInput += Destruct;

				break;
			case En_SpellInput.Ward:
				playerModule.wardInput += Destruct;

				break;
		}
		this.GetComponent<MovementModule>().Init();

        fowObj = Instantiate(fowPrefab, transform.root);
        fowObj.GetComponent<Fow>().Init(this.transform, 7);

        CameraManager.Instance.SetFollowObj(this.transform);

    }

    void OnRespawn()
    {
        if (!GameManager.Instance.allGhost.Contains(this))
        {
            GameManager.Instance.allGhost.Add(this);
        }
    }

    private void Update()
    {
        DoAnimation();
    }

    Vector3 oldPos;
    private void DoAnimation()
    {
        float velocityX = (transform.position.x - oldPos.x) / Time.deltaTime;
        float velocityZ = (transform.position.z - oldPos.z) / Time.deltaTime;

        float speed = characterParameters.movementParameters.movementSpeed;

        velocityX = Mathf.Lerp(velocityX, Mathf.Clamp(velocityX / speed, -1, 1), Time.deltaTime * speedAnim);
        velocityZ = Mathf.Lerp(velocityZ, Mathf.Clamp(velocityZ / speed, -1, 1), Time.deltaTime * speedAnim);

        Vector3 pos = new Vector3(velocityX, 0, velocityZ);

        float right = Vector3.Dot(transform.right, pos);
        float forward = Vector3.Dot(transform.forward, pos);

        myAnimator.SetFloat("Forward", forward);
        myAnimator.SetFloat("Turn", right);

        oldPos = transform.position;
    }

    private void FixedUpdate()
    {
        if (!networkedObject.GetIsOwner())
            return;

        timer -= Time.fixedDeltaTime;

        if (timer < 0)
        {
            LifeTimeEnd();
        }

        fillImg.fillAmount = (timer / saveLifeTime);
    }

    private void LateUpdate()
    {
        if (!networkedObject.GetIsOwner())
            return;

        canvas.transform.rotation = canvasRot;
    }

    /// <param name="pos"> Useless </param>
    private void Destruct(Vector3 pos)
    {
        if (networkedObject.GetIsOwner())
        {
			switch (inputLinked)
			{
				case En_SpellInput.Click:
					playerModule.leftClickInput -= Destruct;
					break;
				case En_SpellInput.FirstSpell:
					playerModule.firstSpellInput -= Destruct;

					break;
				case En_SpellInput.SecondSpell:
					playerModule.secondSpellInput -= Destruct;

					break;
				case En_SpellInput.ThirdSpell:
					playerModule.thirdSpellInput -= Destruct;

					break;
				case En_SpellInput.Ward:
					playerModule.wardInput -= Destruct;

					break;
			}

			CameraManager.Instance.SetFollowObj(playerModule.transform);
            NetworkObjectsManager.Instance.DestroyNetworkedObject(networkedObject.GetItemID());
            playerModule.RemoveState(En_CharacterState.Stunned | En_CharacterState.Canalysing);
            this.gameObject.SetActive(false);

            playerModule.isInGhost = false;
        }
    }

    private void LifeTimeEnd()
    {
        playerModule.gameObject.transform.position = this.transform.position;
        playerModule.gameObject.transform.rotation = this.transform.rotation;

        Destruct(Vector3.zero);
    }

    private void OnDestroy()
    {
        networkedObject.OnSpawnObj -= OnRespawn;
    }
}

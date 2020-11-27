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

    public List<GameObject> ojbToHide = new List<GameObject>();
    public bool isVisible = false;

    private void Awake()
    {
        canvasRot = canvas.transform.rotation;
        networkedObject.OnSpawnObj += OnRespawn;
    }

    private void OnDestroy()
    {
        networkedObject.OnSpawnObj -= OnRespawn;
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

    public void Init(PlayerModule playerModule, float lifetime, float ghostSpeed)
    {
        print("test");

        canvas.SetActive(true);
        this.playerModule = playerModule;
        saveLifeTime = lifetime;
        movementModule.ghostSpeed = ghostSpeed;
        timer = saveLifeTime;
        playerModule.thirdSpellInputRealeased += Destruct;
        this.GetComponent<MovementModule>().Init();

        fowObj = Instantiate(fowPrefab, transform.root);
        fowObj.GetComponent<Fow>().Init(this.transform, 7);

        CameraManager.Instance.SetFollowObj(this.transform);

        foreach(GameObject obj in ojbToHide)
        {
            obj.SetActive(true);
        }
    }

    void OnRespawn()
    {
        GameManager.Instance.allGhost.Add(this);
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
            CameraManager.Instance.SetFollowObj(playerModule.transform);
            NetworkObjectsManager.Instance.DestroyNetworkedObject(networkedObject.GetItemID());
            playerModule.RemoveState(En_CharacterState.Stunned | En_CharacterState.Canalysing);
            this.gameObject.SetActive(false);

            playerModule.isInGhost = false;
        }

        GameManager.Instance.allGhost.Remove(this);
        GameManager.Instance.allGhost.RemoveAll(x => x == null);

        print("out");
    }

    private void LifeTimeEnd()
    {
        playerModule.gameObject.transform.position = this.transform.position;
        playerModule.gameObject.transform.rotation = this.transform.rotation;

        Destruct(Vector3.zero);
    }
}

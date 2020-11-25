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
    public float lifeTime = 10;

    private Quaternion canvasRot;
    private float timer = 0;
    private GameObject fowObj;


    private void Awake()
    {
        canvasRot = canvas.transform.rotation;
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

    public void Init(PlayerModule playerModule)
    {
        canvas.SetActive(true);
        this.playerModule = playerModule;
        timer = lifeTime;
        playerModule.thirdSpellInputRealeased += Destruct;
        this.GetComponent<MovementModule>().Init();

        fowObj = Instantiate(fowPrefab, transform.root);
        fowObj.GetComponent<Fow>().Init(this.transform, 7);

        CameraManager.Instance.SetFollowObj(this.transform);
    }


    private void FixedUpdate()
    {
        if (!networkedObject.GetIsOwner())
            return;

        timer -= Time.fixedDeltaTime;

        if (timer < 0)
        {
            Destruct(Vector3.zero);
        }

        fillImg.fillAmount = (timer / lifeTime);
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
        }
    }
}

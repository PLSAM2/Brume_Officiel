using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Ghost : MonoBehaviour
{
    public PlayerModule playerModule;
    public MovementModule movementModule;
    public AudioListener audioListener;

    public GameObject fowPrefab;
    private GameObject fowObj;
    public GameObject canvas;
    public Image fillImg;
    public float lifeTime = 10;
    private Quaternion canvasRot;
    private float timer = 0;

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
        playerModule.thirdSpellInputRealeased -= Destruct;
    }

    public void Init(PlayerModule playerModule)
    {
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
        timer -= Time.fixedDeltaTime;

        if (timer < 0)
        {
            Destruct(Vector3.zero);
        }

        fillImg.fillAmount = (timer / lifeTime);
    }

    private void LateUpdate()
    {
        canvas.transform.rotation = canvasRot;
    }



    /// <param name="pos"> Useless </param>
    private void Destruct(Vector3 pos)
    {
        CameraManager.Instance.SetFollowObj(playerModule.transform);
        Destroy(fowObj);
        playerModule.RemoveState(En_CharacterState.Stunned | En_CharacterState.Canalysing);
        this.gameObject.SetActive(false);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class Decoy : MonoBehaviour, Damageable
{
    public UIDecoy myUI;

    public float lifeTime = 6;

    public Animator myAnimator;

    public Team myTeam;

    public Sc_CharacterParameters reParameter;

    public FootstepAudio myFootStep;

    public NetworkedObject netObj;

    public CharacterController charac;

    Quaternion uiRotation;

    bool isInBrume = false;

    public LayerMask maskBrume;

    Vector3 lastRecordedPos;

    private void Awake()
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

    private void OnDisable()
    {
        StopAllCoroutines();
    }

    public void Init()
    {
        PlayerData _tempData = netObj.GetOwner();
        myTeam = _tempData.playerTeam;


        myFootStep.isDecoy = true;
        myFootStep.myDecoy = this;

        myUI.Init(myTeam, _tempData.Name, GameManager.Instance.networkPlayers[_tempData.ID].liveHealth, reParameter.maxHealth);
    }

    public float timeAlive = 5;
    IEnumerator WaitToDestroy()
    {
        yield return new WaitForSeconds(timeAlive);
        NetworkObjectsManager.Instance.DestroyNetworkedObject(netObj.GetItemID());

        print("destroy");
    }

    void Update()
    {
        charac.Move(transform.forward * reParameter.movementParameters.movementSpeed * Time.deltaTime);
        myAnimator.SetBool("IsMoving", true);


        //test in brume
        RaycastHit hit;
        isInBrume = (Physics.Raycast(transform.position + Vector3.up * 1, -Vector3.up, out hit, 10, maskBrume));


    }

    private void LateUpdate()
    {
        myUI.transform.rotation = uiRotation;
    }

    public void DealDamages(DamagesInfos _damagesToDeal, Transform _positionOfTheDealer, ushort? dealerID = null, bool ignoreStatusAndEffect = false, bool ignoreTickStatus = false, float _percentageOfTheMovement = 1)
    {
        if(_damagesToDeal.damageHealth > 0)
        {
            //destroy
            NetworkObjectsManager.Instance.DestroyNetworkedObject(netObj.GetItemID(), true);
        }
    }

    public bool IsInMyTeam(Team _indexTested)
    {
        return _indexTested == myTeam;
    }

    public IEnumerator WaitForVisionCheck()
    {
        CheckForBrumeRevelation();
        yield return new WaitForSeconds(reParameter.delayBetweenDetection);
        StartCoroutine(WaitForVisionCheck());
    }
    void CheckForBrumeRevelation()
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

    bool ShouldBePinged()
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

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile_SoulBurst : MonoBehaviour
{
    private NetworkedObject networkedObject;
    private bool isOwner = false;
    private bool traveling = false;

    private float speed = 1;
    private float maxRange = 1;
    private float explodeRange = 3;
    private Vector3 startPos;
    private Vector3 destination;

    private void OnEnable()
    {
        networkedObject = this.GetComponent<NetworkedObject>();
    }

    public void Init(Vector3 destination, Vector3 startPos, float explodeRange = 1, float maxRange = 5, float speed = 1)
    {
        isOwner = networkedObject.GetIsOwner();

        this.destination = destination;
        this.startPos = startPos;        
        this.explodeRange = explodeRange;
        this.maxRange = maxRange;
        this.speed = speed;
        traveling = true;
    }

    private void FixedUpdate()
    {
        if (!isOwner)
            return;

        if (!traveling)
            return;

        transform.position = Vector3.MoveTowards(transform.position, destination, (speed) * Time.deltaTime);

        if (Vector3.Distance(transform.position, destination) < 0.01 || Vector3.Distance(transform.position, startPos) > maxRange)
        {
            Explode();
        }
    }

    private List<LocalPlayer> GetAllNearbyPlayers()
    {
        List<LocalPlayer> _temp = new List<LocalPlayer>();

        foreach (LocalPlayer P in GameManager.Instance.networkPlayers.Values)
        {
            if (Vector3.Distance(P.transform.position, this.transform.position) < explodeRange)
            {
                if (P.myPlayerModule.teamIndex == networkedObject.GetOwner().playerTeam)
                {
                    continue;
                }
                _temp.Add(P);
            }
        }
        return _temp;
    }

    public void Explode()
    {
        traveling = false;

        NetworkObjectsManager.Instance.DestroyNetworkedObject(networkedObject.GetItemID());

        foreach (LocalPlayer P in GetAllNearbyPlayers())
        {
            DamagesInfos _tempDmg = new DamagesInfos();
            _tempDmg.damageHealth = 10;

            P.DealDamages(_tempDmg, Vector3.zero);
        }


    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, explodeRange);
    }

}

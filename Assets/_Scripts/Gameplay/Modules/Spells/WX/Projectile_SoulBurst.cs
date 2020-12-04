using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile_SoulBurst : MonoBehaviour
{
    public ushort damages = 10;

    private NetworkedObject networkedObject;
    private bool isOwner = false;
    private bool traveling = false;

    private float speed = 1;
    private float maxRange = 1;
    private float explodeRange = 3;
    private Vector3 startPos;
    private Vector3 destination;
    private int hitCount = 0; // cause trigger is called multiple times

    private void OnEnable()
    {
        networkedObject = this.GetComponent<NetworkedObject>();
    }

    public void Init(Vector3 destination, Vector3 startPos, float explodeRange = 1, float maxRange = 5, float speed = 1)
    {
        isOwner = networkedObject.GetIsOwner();
        hitCount = 0;
        this.destination = ((destination - startPos).normalized *(maxRange * 2)) + destination; 
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

        if (Vector3.Distance(transform.position, startPos) > maxRange)
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
			_tempDmg.damageHealth = damages;

			P.DealDamages(_tempDmg, transform.position, GameManager.Instance.currentLocalPlayer.myPlayerId);
        }
    }



    private void OnTriggerEnter(Collider other)
    {
        if (!isOwner && !traveling)
        {
            return;
        }

        if (other.gameObject.layer == 8)
        {
            PlayerModule playerHit = other.gameObject.GetComponent<PlayerModule>();

            if (playerHit != null)
            {
                if (playerHit.teamIndex != networkedObject.GetOwner().playerTeam && hitCount <1)
                {
                    hitCount++;
                    Explode();
                }
            }
        }
    }

    void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, explodeRange);
    }

}

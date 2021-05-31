using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Lava : MonoBehaviour
{
    [SerializeField] AnimationCurve curve;

    [SerializeField] float spawnCD = 2f;
    [SerializeField] float time = 10;

    [SerializeField] Transform obj;
    [SerializeField] float sizeMax = 16;

    [SerializeField] MeshCollider LavaCollider;

    [SerializeField] float cdDamage = 0.5f;
    bool canDamage = false;
    bool firstHit = true;


    public void Spawn()
    {
        StartCoroutine(ValueToTime());
    }

    IEnumerator ValueToTime()
    {
        yield return new WaitForSeconds(spawnCD);

        LavaCollider.enabled = true;
        canDamage = true;

        float timeCounter = 0;

        while (timeCounter < time)
        {
            float val = curve.Evaluate(timeCounter / time) * sizeMax;

            obj.localScale = new Vector3(val, val, val);

            timeCounter += Time.deltaTime;
            yield return null;
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if(GameManager.Instance.currentLocalPlayer == null) { return; }

        if(other.transform != GameManager.Instance.currentLocalPlayer.transform) { return; }

        if (canDamage)
        {
            canDamage = false;
            StartCoroutine(TakeDamage());
        }
    }

    private void OnTriggerExit(Collider other)
    {
        if (GameManager.Instance.currentLocalPlayer == null) { return; }

        if (other.transform != GameManager.Instance.currentLocalPlayer.transform) { return; }

        firstHit = true;
    }

    IEnumerator TakeDamage()
    {
        DamagesInfos _temp = new DamagesInfos();
        _temp.damageHealth = 1;

        if (!firstHit)
        {
            //take damage
            GameManager.Instance.currentLocalPlayer.DealDamages(_temp, transform);
        }
        else
        {
            firstHit = false;
        }

        yield return new WaitForSeconds(cdDamage);
        canDamage = true;
    }
}

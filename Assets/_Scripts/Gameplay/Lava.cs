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

    [SerializeField] MeshCollider collider;

    [SerializeField] float cdDamage = 0.5f;
    bool canDamage = false;


    public void Spawn()
    {
        collider.enabled = true;
        canDamage = true;

        StartCoroutine(ValueToTime());
    }

    IEnumerator ValueToTime()
    {
        yield return new WaitForSeconds(spawnCD);

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
        print(other.transform);

        if(GameManager.Instance.currentLocalPlayer == null) { return; }

        if(other.transform != GameManager.Instance.currentLocalPlayer.transform) { return; }

        if (canDamage)
        {
            canDamage = false;
            StartCoroutine(TakeDamage());
        }
    }

    IEnumerator TakeDamage()
    {
        DamagesInfos _temp = new DamagesInfos();
        _temp.damageHealth = 1;

        //take damage
        GameManager.Instance.currentLocalPlayer.DealDamages(_temp, transform.position);

        yield return new WaitForSeconds(cdDamage);
        canDamage = true;
    }
}

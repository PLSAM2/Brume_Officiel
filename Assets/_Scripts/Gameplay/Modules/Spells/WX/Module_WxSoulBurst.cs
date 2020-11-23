using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxSoulBurst : SpellModule
{
    public GameObject soulburstPrefab;
    private GameObject soulburstObj;

    public float speed = 1;
    public float maxRange = 1;
    public float explodeRange = 1;
    protected override void AddCharge() { }
    public override void DecreaseCooldown() { }
    protected override void ResolveSpell(Vector3 _mousePosition)
    {

        base.ResolveSpell(_mousePosition);

        soulburstObj = NetworkObjectsManager.Instance.NetworkInstantiate(16, this.transform.position, 
            new Vector3(soulburstPrefab.transform.rotation.x, soulburstPrefab.transform.rotation.y, soulburstPrefab.transform.rotation.z));

        soulburstObj.GetComponent<Projectile_SoulBurst>().Init(_mousePosition, this.transform.position, explodeRange, maxRange, speed);
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxGhost : SpellModule
{
    public GameObject ghostPrefab;
    private GameObject ghostObj;

    public float lifeTime = 10;
    public float ghostSpeed = 7.5f;

	protected override void ResolveSpell ()
    {
        base.ResolveSpell();

        GameObject ghostObj = NetworkObjectsManager.Instance.NetworkInstantiate(17, this.transform.position,
            new Vector3(ghostPrefab.transform.rotation.x, ghostPrefab.transform.rotation.y, ghostPrefab.transform.rotation.z));

        PlayerModule _tempPlayerModule = myPlayerModule;

        _tempPlayerModule.AddState(En_CharacterState.Stunned);
        ghostObj.GetComponent<Ghost>().Init(_tempPlayerModule, lifeTime, ghostSpeed);
    }

}

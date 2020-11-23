using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxGhost : SpellModule
{
    public GameObject ghostPrefab;
    private GameObject ghostObj;
    protected override void ResolveSpell(Vector3 _mousePosition)
    {
        base.ResolveSpell(_mousePosition);

        GameObject ghostObj = NetworkObjectsManager.Instance.NetworkInstantiate(17, _mousePosition,
            new Vector3(ghostPrefab.transform.rotation.x, ghostPrefab.transform.rotation.y, ghostPrefab.transform.rotation.z));

        ghostObj.GetComponent<Ghost>().Init(this.GetComponent<PlayerModule>());
    }

}

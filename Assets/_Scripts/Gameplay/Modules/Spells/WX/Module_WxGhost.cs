using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WxGhost : SpellModule
{
    public GameObject ghostPrefab;
    private GameObject ghostObj;
    protected override void Resolution()
    {
        base.Resolution();

        GameObject ghostObj = NetworkObjectsManager.Instance.NetworkInstantiate(17, mousePosInputed,
            new Vector3(ghostPrefab.transform.rotation.x, ghostPrefab.transform.rotation.y, ghostPrefab.transform.rotation.z));

        PlayerModule _tempPlayerModule = myPlayerModule;

        _tempPlayerModule.AddState(En_CharacterState.Stunned);
        ghostObj.GetComponent<Ghost>().Init(_tempPlayerModule);
    }

}

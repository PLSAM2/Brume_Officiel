using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerRecupPos : MonoBehaviour
{
    public MeshRenderer renderer;
    public Material myRefMat;
    Material _myInstanceMat;
    public Transform myPlayer;

    private void Start()
    {
        Material _myMatToInstance = new Material(myRefMat);
        _myInstanceMat = _myMatToInstance;
        renderer.material = _myInstanceMat;
    }


    void Update()
    {
      //Vector4 _tempVector = new Vector4(myPlayer.position.x, myPlayer.position.y, myPlayer.position.z, 0);
        _myInstanceMat.SetVector("_Character_Position", myPlayer.position);
    }
}

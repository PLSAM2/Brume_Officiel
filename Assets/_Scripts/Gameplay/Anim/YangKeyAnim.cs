using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class YangKeyAnim : MonoBehaviour
{
    [SerializeField] AudioClip surchargeYangSfx;

    public void OnSurchargeSfx()
    {
        AudioManager.Instance.Play3DAudio(surchargeYangSfx, transform.position);
    }
}

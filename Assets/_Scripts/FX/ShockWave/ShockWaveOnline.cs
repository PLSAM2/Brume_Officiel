using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class ShockWaveOnline : MonoBehaviour
{
    [SerializeField] AudioClip waveAudio;

    float currentWaveTime = 0;
    
    float waveRange, waveDuration;
    AnimationCurve waveCurve;

    [SerializeField] statut myStatut;
    public enum statut
    {
        Open,
        Close
    }     

    void InitValue()
    {
        Module_WxThirdEye thirdEye = GameManager.Instance.GetLocalPlayerChamp(Character.Shili, GameFactory.GetOtherTeam(RoomManager.Instance.GetLocalPlayer().playerTeam)).GetComponent<Module_WxThirdEye>();

        if (thirdEye != null)
        {
            waveRange = thirdEye.waveRange;
            waveDuration = thirdEye.waveDuration;
            waveCurve = thirdEye.waveCurve;
        }
    }

    private void OnEnable()
    {
        GetComponent<NetworkedObject>().OnSpawnObj += Init;
    }

    private void OnDisable()
    {
        GetComponent<NetworkedObject>().OnSpawnObj -= Init;
    }

    void Init()
    {
        InitValue();

        currentWaveTime = 0;
        AudioManager.Instance.Play3DAudio(waveAudio, transform.position);
    }

    // Update is called once per frame
    void Update()
    {
        currentWaveTime += Time.deltaTime;

        float size = waveRange;
        switch (myStatut)
        {
            case statut.Open:
                size = Mathf.Lerp(0, waveRange, waveCurve.Evaluate(currentWaveTime / waveDuration));
                break;

            case statut.Close:
                size = Mathf.Lerp(waveRange, 0, waveCurve.Evaluate(currentWaveTime / waveDuration));
                break;
        }

        transform.localScale = new Vector3(size, size, size);

        if (currentWaveTime >= waveDuration)
        {
            gameObject.SetActive(false);
        }
    }
}

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

    NetworkedObject myNetworkObj;
    public enum statut
    {
        Open,
        Close
    }

    private void Awake()
    {
        myNetworkObj = GetComponent<NetworkedObject>();
        myNetworkObj.OnSpawnObj += Init;
    }

    void InitValue()
    {
        print(myNetworkObj.GetOwnerID());
        print(GameManager.Instance.networkPlayers[myNetworkObj.GetOwnerID()]);
        print(GameManager.Instance.networkPlayers[myNetworkObj.GetOwnerID()].GetComponent<Module_WxThirdEye>());


        Module_WxThirdEye thirdEye = GameManager.Instance.networkPlayers[myNetworkObj.GetOwnerID()].GetComponent<Module_WxThirdEye>();

        if (thirdEye != null)
        {
            print("ok");
            waveRange = thirdEye.waveRange;
            waveDuration = thirdEye.waveDuration;
            waveCurve = thirdEye.waveCurve;
        }
        else
        {
            print("null");
            gameObject.SetActive(false);
        }
    }

    private void OnDestroy()
    {
        myNetworkObj.OnSpawnObj -= Init;
    }

    void Init()
    {
        print("init");
        InitValue();

        print(waveRange);
        print(waveCurve);
        print(currentWaveTime);
        print(waveDuration);

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

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class ShockWaveOnline : MonoBehaviour
{
    float currentWaveTime = 0;

    [SerializeField] statut myStatut;

    [SerializeField] Sc_ThirdEye localTrad;

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

    private void OnDestroy()
    {
        myNetworkObj.OnSpawnObj -= Init;
    }

    void Init()
    {
        currentWaveTime = 0;
        AudioManager.Instance.Play3DAudio(localTrad.waveAudio, transform.position);
    }

    // Update is called once per frame
    void Update()
    {
        currentWaveTime += Time.deltaTime;

        float size = localTrad.range;
        /*
        switch (myStatut)
        {
            case statut.Open:
                size = Mathf.Lerp(0, localTrad.range, localTrad.waveCurve.Evaluate(currentWaveTime / localTrad.waveDuration));
                break;

            case statut.Close:
                size = Mathf.Lerp(localTrad.waveRange, 0, localTrad.waveCurve.Evaluate(currentWaveTime / localTrad.waveDuration));
                break;
        }
        */
        transform.localScale = new Vector3(size, size, size);

        if (currentWaveTime >= localTrad.waveDuration)
        {
            gameObject.SetActive(false);
        }
    }
}

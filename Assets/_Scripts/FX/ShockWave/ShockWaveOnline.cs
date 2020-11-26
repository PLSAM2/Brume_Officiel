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
        AudioManager.Instance.Play3DAudio(localTrad.parameters.waveAudio, transform.position);
    }

    // Update is called once per frame
    void Update()
    {
        currentWaveTime += Time.deltaTime;

        float size = localTrad.parameters.waveRange;
        switch (myStatut)
        {
            case statut.Open:
                size = Mathf.Lerp(0, localTrad.parameters.waveRange, localTrad.parameters.waveCurve.Evaluate(currentWaveTime / localTrad.parameters.waveDuration));
                break;

            case statut.Close:
                size = Mathf.Lerp(localTrad.parameters.waveRange, 0, localTrad.parameters.waveCurve.Evaluate(currentWaveTime / localTrad.parameters.waveDuration));
                break;
        }

        transform.localScale = new Vector3(size, size, size);

        if (currentWaveTime >= localTrad.parameters.waveDuration)
        {
            gameObject.SetActive(false);
        }
    }
}

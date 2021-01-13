using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

public class ShockWaveOnline : MonoBehaviour
{
    [SerializeField] statut myStatut;

    [SerializeField] Sc_ThirdEye localTrad;

    NetworkedObject myNetworkObj;

    [SerializeField] GameObject mesh;

    public enum statut
    {
        Open,
        Close
    }

    private void Awake()
    {
        myNetworkObj = GetComponent<NetworkedObject>();
        myNetworkObj.OnSpawnObj += Init;

        mesh.SetActive(false);
    }

    private void OnDestroy()
    {
        myNetworkObj.OnSpawnObj -= Init;
    }

    void Init()
    {
        AudioManager.Instance.Play3DAudio(localTrad.waveAudio, transform.position, myNetworkObj.GetOwnerID(), true);

        Transform transformOwner = GameManager.Instance.networkPlayers[myNetworkObj.GetOwnerID()].transform;

        if (transformOwner != null && GameManager.Instance.visiblePlayer.ContainsKey(transformOwner))
        {
            mesh.SetActive(true);

            switch (myStatut)
            {
                case statut.Open:
                    transform.localScale = Vector3.zero;
                    transform.DOScale(localTrad.range, localTrad.anonciationTime).OnComplete(() => OnFinish());
                    break;

                case statut.Close:
                    transform.localScale = new Vector3(localTrad.range, localTrad.range, localTrad.range);
                    transform.DOScale(Vector3.zero, localTrad.anonciationTime).OnComplete(() => OnFinish());
                    break;
            }
        }
    }

    void OnFinish()
    {
        mesh.SetActive(false);
        gameObject.SetActive(false);
    }
}

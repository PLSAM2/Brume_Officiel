using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimEvent : MonoBehaviour
{
    public Transform parentList;

    public GameObject killPrefab;

    Dictionary<ushort, int> killByPlayer = new Dictionary<ushort, int>();

    public AudioClip kill1, kill2, kill3, kill4, kill5;

    GameObject currentEvent;

    private void OnEnable()
    {
        GameManager.Instance.OnPlayerDie += OnPlayerDie;
    }

    private void OnDisable()
    {
        GameManager.Instance.OnPlayerDie -= OnPlayerDie;
    }

    public void OnPlayerDie(ushort _idKilled, ushort _idKiller)
    {
        if(currentEvent != null)
        {
            StopAllCoroutines();
            DestroyImmediate(currentEvent);
        }

        if (killByPlayer.ContainsKey(_idKiller))
        {
            killByPlayer[_idKiller]++;
        }
        else
        {
            killByPlayer.Add(_idKiller, 1);
        }

        if (NetworkManager.Instance.GetLocalPlayer().playerTeam == GameData.Team.spectator)
        {
            return;
        }

        if(GameFactory.GetActualPlayerFollow() && _idKiller == GameFactory.GetActualPlayerFollow().myPlayerId)
        {
            KillEventAnim obj = Instantiate(killPrefab, parentList).GetComponent<KillEventAnim>();
            obj.killText.text = "KILL x" + killByPlayer[_idKiller];

            currentEvent = obj.gameObject;

            AudioManager.Instance.Play2DAudio(kill1, 5);
            /*
            switch (killByPlayer[_idKiller])
            {
                case 1:
                    AudioManager.Instance.Play2DAudio(kill1, 5);
                    break;

                case 2:
                    AudioManager.Instance.Play2DAudio(kill2, 5);
                    break;

                case 3:
                    AudioManager.Instance.Play2DAudio(kill3, 5);
                    break;

                case 4:
                    AudioManager.Instance.Play2DAudio(kill4, 5);
                    break;

                default:
                    AudioManager.Instance.Play2DAudio(kill5, 5);
                    break;
            }*/

            StartCoroutine(WaitToDestroy(obj.gameObject));
        }
    }

    IEnumerator WaitToDestroy(GameObject _obj)
    {
        yield return new WaitForSeconds(3.1f);
        Destroy(_obj);
    }
}

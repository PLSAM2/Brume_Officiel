using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimEvent : MonoBehaviour
{
    public Transform parentList;

    public GameObject killPrefab;

    Dictionary<ushort, int> killByPlayer = new Dictionary<ushort, int>();

    public AudioClip kill1, kill2, kill3, kill4, kill5;

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
        if (killByPlayer.ContainsKey(_idKiller))
        {
            killByPlayer[_idKiller]++;
        }
        else
        {
            killByPlayer.Add(_idKiller, 1);
        }

        if(_idKiller == GameFactory.GetActualPlayerFollow().myPlayerId)
        {
            KillEventAnim obj = Instantiate(killPrefab, parentList).GetComponent<KillEventAnim>();
            obj.killText.text = "KILL x" + killByPlayer[_idKiller];

            switch (killByPlayer[_idKiller])
            {
                case 1:
                    AudioManager.Instance.Play2DAudio(kill1);
                    break;

                case 2:
                    AudioManager.Instance.Play2DAudio(kill2);
                    break;

                case 3:
                    AudioManager.Instance.Play2DAudio(kill3);
                    break;

                case 4:
                    AudioManager.Instance.Play2DAudio(kill4);
                    break;

                default:
                    AudioManager.Instance.Play2DAudio(kill5);
                    break;
            }

            Destroy(obj.gameObject, 3.1f);
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyDisplayer : MonoBehaviour
{
    private void Start()
    {
        //GameManager.Instance.visibleEnemy.Clear();
    }

    // Update is called once per frame
    void Update()
    {
        /*
        if (GameManager.Instance.canPlay)
        {
            List<Transform> allVisibleEnemy = GameManager.Instance.visibleEnemy;

            foreach (KeyValuePair<Transform, Displayer> enemy in GameManager.Instance.enemyList)
            {
                if (allVisibleEnemy.Contains(enemy.Key))
                {
                    enemy.Value.SetAlphaValue(1);
                }
                else
                {
                    enemy.Value.SetAlphaValue(0);
                }
            }
        }
        else
        {
            GameManager.Instance.visibleEnemy.Clear();

            foreach (KeyValuePair<Transform, Displayer> enemy in GameManager.Instance.enemyList)
            {
                enemy.Value.SetAlphaValue(0);
            }
        }
        */
    }
}

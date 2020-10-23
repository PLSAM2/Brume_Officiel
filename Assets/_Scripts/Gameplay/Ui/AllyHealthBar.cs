using System.Collections;
using System.Collections.Generic;
using UnityEditor.ShaderGraph.Internal;
using UnityEngine;

public class AllyHealthBar : MonoBehaviour
{
    public RectTransform healthBar;

    private float health;
    private float healthMax;

    private void Start()
    {
        health = healthMax;
    }

    //Update la taille de la healthbar en fonction des HP actuels du personnage
    private void HealthBarUpdate(float damage)
    {
        health -= damage;
        healthBar.localScale = new Vector3(health / healthMax, 1, 1);
    }

    /*private void Update()
    {
        if (Input.GetKeyDown(KeyCode.A))
            HealthBarUpdate();
    }*/
}

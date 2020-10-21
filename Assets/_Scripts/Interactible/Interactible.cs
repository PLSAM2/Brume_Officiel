using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Interactible : MonoBehaviour
{
    [Header("Interactible properties")]
    [SerializeField] protected float interactTime = 5;
    public bool isInteractable = true;

    protected Action capturedEvent;

    protected float timer = 0;

    protected void Init()
    {

    }

    protected virtual void Update()
    {
        if (isInteractable)
        {
            timer += Time.deltaTime;

            if (timer >= interactTime)
            {
                capturedEvent.Invoke();
            }
        }
    }



    protected virtual void Captured()
    {
        timer = 0;
    }
}

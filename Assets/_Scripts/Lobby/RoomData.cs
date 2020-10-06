﻿using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class RoomData : MonoBehaviour
{
    [SerializeField] public ushort ID { get; set; }
    [SerializeField] public string Name { get; set; }


    // Uniquement rempli si à l'intérieur de celle-ci >>

    public List<PlayerData> playerList = new List<PlayerData>();

    public RoomData(ushort iD, string name)
    {
        this.ID = iD;
        this.Name = name;
    }

    public RoomData()
    {
        this.ID = 0; // Une room ne peut pas avoir l'ID 0 sur le serveur
        this.Name = "";
    }
}

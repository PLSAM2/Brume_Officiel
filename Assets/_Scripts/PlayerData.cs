using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class PlayerData
{
    [SerializeField] public ushort ID { get; set; }
    [SerializeField] public bool IsHost { get; set; }
    [SerializeField] public string Name { get; set; }

    public PlayerData(ushort iD, bool isHost, string name)
    {
        this.ID = iD;
        this.IsHost = isHost;
        this.Name = name;
    }
}

using DarkRift;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class RoomData : IDarkRiftSerializable
{
    [SerializeField] public ushort ID { get; set; }
    [SerializeField] public string Name { get; set; }
    [SerializeField] public ushort MaxPlayers { get; set; }

    public ushort playerCount = 1; // LocalOnly

    // Uniquement rempli si à l'intérieur de celle-ci >>

    public Dictionary<ushort, PlayerData> playerList = new Dictionary<ushort, PlayerData>();

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

    public void Deserialize(DeserializeEvent e)
    {
        this.ID = e.Reader.ReadUInt16();
        this.Name = e.Reader.ReadString();
        this.MaxPlayers = e.Reader.ReadUInt16();
        this.playerCount = e.Reader.ReadUInt16();
    }       

    public void Serialize(SerializeEvent e)
    {
        e.Writer.Write(ID);
        e.Writer.Write(Name);
        e.Writer.Write(MaxPlayers);
    }
}

using DarkRift;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;

[Serializable]
public class RoomData : IDarkRiftSerializable
{
    public ushort ID { get; set; }
    public string Name { get; set; }
    public ushort MaxPlayers { get; set; }

    public ushort playerCount = 1; // LocalOnly

    // Uniquement rempli si à l'intérieur de celle-ci >>
    public Dictionary<ushort, PlayerData> playerList = new Dictionary<ushort, PlayerData>();

    // InGameStats >>
    public Dictionary<Team, ushort> scores = new Dictionary<Team, ushort>();
    // <<

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
        this.scores[Team.blue] = e.Reader.ReadUInt16();
        this.scores[Team.red] = e.Reader.ReadUInt16();
        this.playerCount = e.Reader.ReadUInt16(); // valeur calculé sur serveur
    }

    public void Serialize(SerializeEvent e)
    {
        e.Writer.Write(ID);
        e.Writer.Write(Name);
        e.Writer.Write(MaxPlayers);
        e.Writer.Write(scores[Team.blue]);
        e.Writer.Write(scores[Team.red]);
    }
}


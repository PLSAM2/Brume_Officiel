using DarkRift;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;


public enum RoomType
{
    Classic,
    Training,
    Tutorial
}


[Serializable]
public class RoomData : IDarkRiftSerializable
{
    public ushort ID { get; set; }
    public string Name { get; set; }
    public ushort MaxPlayers { get; set; }

    public ushort playerCount = 1; // LocalOnly

    public RoomType roomType = RoomType.Classic;

    // Uniquement rempli si à l'intérieur de celle-ci >>
    public Dictionary<ushort, PlayerData> playerList = new Dictionary<ushort, PlayerData>();

    // InGameStats >>
    public Dictionary<Team, ushort> scores = new Dictionary<Team, ushort>();
    // <<
    public bool IsStarted = false;
    public bool isATrainingRoom = false;
    public RoomData(ushort iD, string name, bool isATrainingRoom = false, RoomType roomType = RoomType.Classic)
    {
        this.ID = iD;
        this.Name = name;
        this.isATrainingRoom = isATrainingRoom;

        scores.Add(Team.blue, 0);
        scores.Add(Team.red, 0);
        this.roomType = roomType;
    }

    public RoomData()
    {
        this.ID = 0; // Une room ne peut pas avoir l'ID 0 sur le serveur
        this.Name = "";


        scores.Add(Team.blue, 0);
        scores.Add(Team.red, 0);
    }

    public void Deserialize(DeserializeEvent e)
    {
        this.ID = e.Reader.ReadUInt16();
        this.Name = e.Reader.ReadString();
        this.MaxPlayers = e.Reader.ReadUInt16();
        this.scores[Team.blue] = e.Reader.ReadUInt16();
        this.scores[Team.red] = e.Reader.ReadUInt16();
        this.IsStarted = e.Reader.ReadBoolean();
        this.playerCount = e.Reader.ReadUInt16(); // valeur calculé sur serveur
    }

    public void Serialize(SerializeEvent e)
    {
        e.Writer.Write(ID); 
        e.Writer.Write(Name);
        e.Writer.Write(MaxPlayers);
        e.Writer.Write(scores[Team.blue]);
        e.Writer.Write(scores[Team.red]);
        e.Writer.Write(IsStarted);
    }
}


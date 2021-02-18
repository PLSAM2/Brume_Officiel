﻿using DarkRift;
using System;
using UnityEngine;
using static GameData;

[Serializable]
public class PlayerData : IDarkRiftSerializable
{
    public ushort ID { get; set; }
    public ushort InGameUniqueID { get; set; }
    public bool IsHost { get; set; }
    public string Name { get; set; }
    public bool IsReady { get; set; }
    public ushort ultStacks { get; set; }

    public Team playerTeam = Team.none;

    public Character playerCharacter = Character.none;

    public PlayerData()
    {
        this.ID = 0;
        this.IsHost = false;
        this.Name = "NULL";
        this.playerTeam = Team.none;
        this.ultStacks = 0;
    }

    public void ResetGameData()
    {
        playerCharacter = Character.none;
        playerTeam = Team.none;
        IsReady = false;
        IsHost = false;
        ultStacks = 0;
        InGameUniqueID = 0;
    }

    public PlayerData(ushort ID, bool isHost, string name, Team team = Team.none)
    {
        this.ID = ID;
        this.IsHost = isHost;
        this.Name = name;
        this.playerTeam = team;
        this.ultStacks = 0;
    }

    public void Deserialize(DeserializeEvent e)
    {
        this.ID = e.Reader.ReadUInt16();
        this.IsHost = e.Reader.ReadBoolean();
        this.Name = e.Reader.ReadString();
        this.IsReady = e.Reader.ReadBoolean();
        this.ultStacks = e.Reader.ReadUInt16();
        this.playerTeam = (Team)e.Reader.ReadUInt16();
        this.playerCharacter = (Character)e.Reader.ReadUInt16();
    }

    public void Serialize(SerializeEvent e)
    {
        e.Writer.Write(ID);
        e.Writer.Write(IsHost);
        e.Writer.Write(Name);
        e.Writer.Write(IsReady);
        e.Writer.Write(ultStacks);
        e.Writer.Write((ushort)playerTeam);
        e.Writer.Write((ushort)playerCharacter);
    }

}

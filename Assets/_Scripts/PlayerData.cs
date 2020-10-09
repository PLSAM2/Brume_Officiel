using DarkRift;
using System;
using UnityEngine;
using static GameData;

[Serializable]
public class PlayerData : IDarkRiftSerializable
{
   [SerializeField] public ushort ID { get; set; }
    public bool IsHost { get; set; }
    public string Name { get; set; }

    public Team playerTeam = Team.none;

    public Character playerCharacter = Character.none;

    public PlayerData()
    {

    }

    public PlayerData(ushort ID, bool isHost, string name, Team team = Team.none)
    {
        this.ID = ID;
        this.IsHost = isHost;
        this.Name = name;
        this.playerTeam = team;
    }

    public void Deserialize(DeserializeEvent e)
    {
        this.ID = e.Reader.ReadUInt16();
        this.IsHost = e.Reader.ReadBoolean();
        this.Name = e.Reader.ReadString();
        this.playerTeam = (Team)e.Reader.ReadUInt16();
        this.playerCharacter = (Character)e.Reader.ReadUInt16();
    }

    public void Serialize(SerializeEvent e)
    {
        e.Writer.Write(ID);
        e.Writer.Write(IsHost);
        e.Writer.Write(Name);
        e.Writer.Write((ushort)playerTeam);
        e.Writer.Write((ushort)playerCharacter);
    }

}

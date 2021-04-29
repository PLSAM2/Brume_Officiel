using DarkRift;
using DarkRift.Client;
using DarkRift.Client.Unity;
using Sirenix.OdinInspector;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using static GameData;

public class InteractibleObjectsManager : MonoBehaviour
{
    [InfoBox("Altar --> EndZone --> Autre")]
    [BoxGroup("L'ORDRE DES TYPES EST IMPORTANT !")]
    public List<KeyInteractiblePair> interactibleList = new List<KeyInteractiblePair>();

    UnityClient client;
    private void Awake()
    {
        if (RoomManager.Instance == null)
        {
            Debug.LogError("NO ROOM MANAGER");
            return;
        }

        client = RoomManager.Instance.client;

        InitInteractibleID();
    }
    void Start()
    {
        client.MessageReceived += MessageReceived;
    }


    private void OnDisable()
    {
        client.MessageReceived -= MessageReceived;
    }

    private void MessageReceived(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage() as Message)
        {
            if (message.Tag == Tags.TryCaptureInteractible)
            {
                TryCaptureInteractibleInServer(sender, e);
            }
            if (message.Tag == Tags.CaptureProgressInteractible)
            {
                CaptureProgressInteractibleInServer(sender, e);
            }
            if (message.Tag == Tags.StopCaptureInteractible)
            {
                StopCaptureInteractible(sender, e);
            }
            if (message.Tag == Tags.PauseInteractible)
            {
                PauseInteractible(sender, e);
            }
            if (message.Tag == Tags.CaptureInteractible)
            {
                CaptureInteractibleInServer(sender, e);
            }
            if (message.Tag == Tags.UnlockInteractible)
            {
                UnlockInteractibleInServer(sender, e);
            }
            if (message.Tag == Tags.UnlockAllInteractibleOfType)
            {
                UnlockAllInteractibleOfType(sender, e);
            }
            if (message.Tag == Tags.FrogTimerElapsed)
            {
                RespawnFrogTimerEndInServer(sender, e);
            }
            if (message.Tag == Tags.VisionTowerTimerElapsed)
            {
                ReactivateVisionTowerInServer(sender, e);
            }
            if (message.Tag == Tags.HealthPackTimerElapsed)
            {
                ReactivateHealthPackInServer(sender, e);
            }
            if (message.Tag == Tags.RoundFinalPhase)
            {
                RoundFinalPhase(sender, e);
            }           
            if (message.Tag == Tags.OvertimeState)
            {
                OvertimeState(sender, e);
            }
        }
    }



    public void InitInteractibleID()
    {
        for (ushort i = 0; i < interactibleList.Count; i++)
        {
            interactibleList[i].Key = i;
            interactibleList[i].interactible.interactibleID = i;
        }
    }

    private void UnlockInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

                if (_interactible.GetType() == typeof(Altar))
                {
                    ((Altar)_interactible).SetActiveState(true);
                } else
                {
                    _interactible.Unlock();
                }
            }
        }
    }

    private void CaptureInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();
                ushort _capturingPlayerID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

                if (NetworkManager.Instance.GetLocalPlayer().ID == _capturingPlayerID)
                {
                    _interactible.Captured(_capturingPlayerID);
                    _interactible.UpdateCaptured(_capturingPlayerID);

                }
                else
                {
                    _interactible.UpdateCaptured(_capturingPlayerID);
                }

            }
        }
    }

    private void TryCaptureInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();
                ushort _capturingPlayerID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

                (_interactible).UpdateTryCapture(_capturingPlayerID);
            }
        }

    }

    private void StopCaptureInteractible(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

                (_interactible).StopCapturing();
            }
        }
    }

    private void PauseInteractible(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();
                bool canProgress = reader.ReadBoolean();
                Interactible _interactible = interactibleList[_ID].interactible;

                (_interactible).PauseCapture(canProgress);
            }
        }
    }

    private void CaptureProgressInteractibleInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();
                float progress = reader.ReadSingle();

                Interactible _interactible = interactibleList[_ID].interactible;

                (_interactible).ProgressInServer(progress);
            }
        }
    }


    private void RespawnFrogTimerEndInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

                ((Frog)_interactible).RespawnFrog();
            }
        }
    }
    private void ReactivateVisionTowerInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

                ((VisionTower)_interactible).ReactivateTower();
            }
        }
    }

    private void ReactivateHealthPackInServer(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();

                Interactible _interactible = interactibleList[_ID].interactible;

                ((HealthPackPickup)_interactible).Reactivate();
            }
        }
    }

    private void UnlockAllInteractibleOfType(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                InteractibleType _type = (InteractibleType)reader.ReadUInt16();

                foreach (KeyInteractiblePair interactiblePair in interactibleList)
                {
                    if (interactiblePair.interactible.type == _type)
                    {
                        Interactible _temp = interactiblePair.interactible;

                        switch (_type)
                        {
                            case InteractibleType.none:
                                return;
                            case InteractibleType.Altar:
                                ((Altar)_temp).SetActiveState(true);
                                break;
                            case InteractibleType.VisionTower:
                                ((VisionTower)_temp).Unlock();
                                break;
                            case InteractibleType.Frog:
                                ((Frog)_temp).Unlock();
                                break;
                            case InteractibleType.ResurectAltar:
                                ((ResurrectAltar)_temp).Unlock();
                                break;
                            case InteractibleType.HealthPack:
                                ((HealthPackPickup)_temp).Unlock();
                                break;
                            default:
                                throw new Exception("Type non connnu");
                        }
                    }
                }
            }
        }
    }
    private void RoundFinalPhase(object sender, MessageReceivedEventArgs e)
    {
        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                ushort _ID = reader.ReadUInt16();
                Team team = (Team)reader.ReadUInt16();

                Interactible _lastAltarCaptured = interactibleList[_ID].interactible;


                foreach (KeyInteractiblePair pair in interactibleList) // TODO: PAS OUF, a faire en serv
                {
                    if (pair.interactible.GetType() == typeof(Altar))
                    {
                        if (pair.interactible.state != State.Captured)
                        {
                            ((Altar)(pair.interactible)).StarFinalPhase();
                        }
                    }
                }

                GameManager.Instance.StartEndZone(team);
                ((EndZoneInteractible)interactibleList[3].interactible).lastTeamCaptured = team;
                ((EndZoneInteractible)interactibleList[3].interactible).Unlock();

            }
        }
    }

    private void OvertimeState(object sender, MessageReceivedEventArgs e)
    {

        using (Message message = e.GetMessage())
        {
            using (DarkRiftReader reader = message.GetReader())
            {
                bool _state = reader.ReadBoolean();

                GameManager.Instance.SetOvertimeTimerState(_state);
            }
        }
    }

}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomListPanelControl : MonoBehaviour
{
    public GameObject roomList;
    public GameObject roomListObj;

    public Dictionary<RoomData, GameObject> roomObjDict = new Dictionary<RoomData, GameObject>();
    public void Init()
    {
        foreach (KeyValuePair< RoomData, GameObject > item in roomObjDict)
        {
            Destroy(item.Value);
        }

        roomObjDict.Clear();

        foreach (KeyValuePair <ushort, RoomData> room in LobbyManager.Instance.rooms)
        {
            if (room.Value.IsStarted)
            {
                continue;
            }
            GameObject _tempListObj = Instantiate(roomListObj, roomList.transform);
            RoomListObj _roomListObj = _tempListObj.GetComponent<RoomListObj>();
            roomObjDict.Add(room.Value, _tempListObj);
            _roomListObj.Init(room.Value, room.Value.playerCount, room.Value.ID);
        }
    }

    public void Refresh()
    {
        LobbyManager.Instance.AskForAllRooms();
    }
}

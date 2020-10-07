using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RoomListPanelControl : MonoBehaviour
{
    public GameObject roomList;
    public GameObject roomListObj;
    public void Init()
    {
        foreach (KeyValuePair <ushort, RoomData> room in LobbyManager.Instance.rooms)
        {
            GameObject _tempListObj = Instantiate(roomListObj, roomList.transform);
            RoomListObj _roomListObj = _tempListObj.GetComponent<RoomListObj>();
            print(room.Value.Name);
            print(room.Value.ID);
            _roomListObj.Init(room.Value.Name, 1, room.Value.ID);
        }
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class KillFeedManager : MonoBehaviour
{
    public List<KillFeedElement> killFeedElements = new List<KillFeedElement>();

    public enum character
    {
        Yin,
        Yang,
        Shili
    }

    public enum action
    {
        kill,
        revive,
        capture
    }
    public enum target
    {
        Yin,
        Yang,
        Shili,
        Altar,
        Tower
    }

    public void NewKill()
    {
        //killFeedElements[0].InitKill();
    }


}

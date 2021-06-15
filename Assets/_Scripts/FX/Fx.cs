using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Fx : MonoBehaviour
{
    public bool isVisible = false;
    public List<GameObject> objToHide = new List<GameObject>();

    LayerMask enviro;

    private void OnEnable()
    {
        enviro = LayerMask.GetMask("Environment");

        GameManager.Instance.allFx.Add(this);

        bool display = IsVisible();

        foreach (GameObject obj in objToHide)
        {
            if(obj == null) { continue; }

            obj.SetActive(display);
        }

        isVisible = display;
    }

    bool IsVisible()
    {
        foreach (KeyValuePair<ushort, LocalPlayer> player in GameManager.Instance.networkPlayers)
        {
            if (player.Value == null) { continue; }
            if (!player.Value.IsInMyTeam(NetworkManager.Instance.GetLocalPlayer().playerTeam)) { continue; }

            if (Vector3.Distance(transform.position, player.Value.transform.position) > player.Value.GetFowRaduis()) { continue; }

            RaycastHit hit;
            Vector3 dirToTarget = (transform.position - player.Value.transform.position).normalized;

            float dstToTarget = Vector3.Distance(player.Value.transform.position, transform.position);
            if (Physics.Raycast(player.Value.transform.position, dirToTarget, out hit, dstToTarget, enviro))
            {
                return false;
            }
            return true;
        }
        return false;
    }

    private void OnDisable()
    {
        GameManager.Instance.allFx.Remove(this);
        GameManager.Instance.allFx.RemoveAll(x => x == null);
    }
}

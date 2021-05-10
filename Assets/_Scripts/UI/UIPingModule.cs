using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIPingModule : MonoBehaviour
{
    public GameObject radialMenu;
    public List<Image> disCornerImg = new List<Image>();
    public List<Image> enCornerImg = new List<Image>();
    public LayerMask pingableLayer;

    private Ray ray;
    private RaycastHit hit;

    private Vector3 initPos = Vector3.zero;
    private float xOffset = 0;
    private float yOffset = 0;
    private bool activated = false;
    private bool locked = false;
    private int actualPos = -1;
    private bool onCenter = false;

    [FoldoutGroup("Minimap")] public RectTransform minimapTransform;
    [FoldoutGroup("Minimap")] public Transform downLimit;
    [FoldoutGroup("Minimap")] public Transform upLimit;
    [FoldoutGroup("Minimap")] public bool mouseOverMinimap = false;
    private Vector3 newPingPos = Vector3.zero;

    private void Update()
    {
        if (activated == false)
        {
            return;
        }

        //if (Input.GetMouseButtonDown(0))
        //{
        //    TryChoosePos();
        //}

        if (Input.GetKeyDown(KeyCode.LeftControl))
        {
            Desactivate();
        }

        //if (Input.GetMouseButton(0))
        //{
        //    PingChoiceHold();
        //}

        //if (Input.GetMouseButtonUp(0))
        //{
        //    Ping();
        //}
    }
    public void Init()
    {
        xOffset = 0;
        yOffset = 0;
        activated = true;
        onCenter = true;

        if (mouseOverMinimap)
        {
            ClickOnMinimap();
        }
        else
        {
            TryChoosePos();
        }
    }

    public void OnMinimapOver(bool v)
    {
        mouseOverMinimap = v;
    }

    public void ClickOnMinimap()
    {
        Vector2 localpoint;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(minimapTransform, Input.mousePosition, GetComponentInParent<Canvas>().worldCamera, out localpoint);

        Vector2 normalizedPoint = Rect.PointToNormalized(minimapTransform.rect, localpoint);

        initPos = new Vector3(downLimit.position.x + ((upLimit.position.x - downLimit.position.x) * (normalizedPoint.x))
            , 0,
            downLimit.position.z + ((upLimit.position.z - downLimit.position.z) * (normalizedPoint.y))
            );

        radialMenu.transform.position = Input.mousePosition;
        radialMenu.SetActive(true);
        locked = true;
    }
    public void Desactivate()
    {
        Ping();

        activated = false;
        radialMenu.SetActive(false);
        locked = false;
        xOffset = 0;
        yOffset = 0;
    }

    public void OnEnterCenter()
    {
        onCenter = true;
    }
    public void OnExitCenter()
    {
        onCenter = false;
    }
    public void TryChoosePos()
    {
        ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (Physics.Raycast(ray, out hit, 300, pingableLayer))
        {
            GameObject _temp = hit.collider.gameObject;

            if (_temp.layer == 7 || _temp.layer == 8)
            {
                if (_temp.GetComponent<LocalPlayer>().myPlayerId != NetworkManager.Instance.GetLocalPlayer().ID)
                {
                    UiManager.Instance.chat.SendNewForcedMessage("<color=red> I see " + RoomManager.Instance.GetPlayerData(hit.collider.GetComponent<LocalPlayer>().myPlayerId).playerCharacter.ToString() + " ! </color>", true);
                }
            }
            else if (_temp.CompareTag("Interactible"))
            {
                Interactible _inter = _temp.GetComponent<Interactible>();

                if (_inter.type == GameData.InteractibleType.Altar)
                {
                    UiManager.Instance.chat.SendNewForcedMessage("<color=green> Go to " + _inter.interactibleName + " ! </color>", true);
                }
                else
                {
                    UiManager.Instance.chat.SendNewForcedMessage("<color=green> I see " + _inter.interactibleName + " - " + _inter.state.ToString() + " ! </color>", true);
                }
            }

            initPos = hit.point;
            radialMenu.transform.position = Input.mousePosition;
            radialMenu.SetActive(true);
            locked = true;
        }
    }
    public void Ping(bool local = false, Vector3? newInitPos = null )
    {
        if (newInitPos != null)
        {
            initPos = (Vector3)newInitPos;
        }

        if (locked)
        {
            ushort chosedPingID = 0;

            if (onCenter)
            {
                chosedPingID = 1;
            }
            else
            {
                switch (actualPos)
                {
                    case -1:
                        return;
                    case 0:
                        chosedPingID = 4;
                        break;
                    case 1:
                        chosedPingID = 2;
                        break;
                    case 2:
                        chosedPingID = 3;
                        break;
                    default: throw new System.Exception("NOT EXISTING EXCEPTION");
                }
            }

            if (initPos != Vector3.zero && local == false)
            {
                NetworkObjectsManager.Instance.NetworkInstantiate(chosedPingID, new Vector3(initPos.x, 0.05f, initPos.z), Vector3.zero);
            }
            else if (initPos != Vector3.zero && local)
            {
                NetworkObjectsManager.Instance.LocalInstantiate(chosedPingID, new Vector3(initPos.x, 0.05f, initPos.z), Vector3.zero);
            }
            xOffset = 0;
            yOffset = 0;
            radialMenu.SetActive(false);
            locked = false;
        }
    }

    public void PingChoiceHold()
    {
        xOffset += Input.GetAxis("Mouse X");
        yOffset += Input.GetAxis("Mouse Y");

        if (xOffset > 0 && yOffset > 0)
        {
            SelectUnselect(0, true);
        }
        else if (xOffset < 0 && yOffset > 0)
        {
            SelectUnselect(1, true);
        }
        else if (yOffset < 0)
        {
            SelectUnselect(2, true);
        }
    }

    public void SelectUnselect(int pos, bool selected)
    {
        if (onCenter)
        {
            ResetAll();
            return;
        }

        if ((selected && pos != actualPos) || (selected && pos == actualPos && enCornerImg[pos].gameObject.activeInHierarchy == false))
        {
            ResetAll();
            actualPos = pos;
        }
        else if (selected == false)
        {
            ResetAll();
            actualPos = -1;
            return;
        }
        else
        {
            return;
        }

        disCornerImg[pos].gameObject.SetActive(!selected);
        enCornerImg[pos].gameObject.SetActive(selected);
    }

    public void ResetAll()
    {
        for (int i = 0; i < disCornerImg.Count; i++)
        {
            disCornerImg[i].gameObject.SetActive(true);
            enCornerImg[i].gameObject.SetActive(false);
        }
    }

}

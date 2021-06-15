using DG.Tweening;
using PixelPlay.OffScreenIndicator;
using Sirenix.OdinInspector;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Waypoint : MonoBehaviour
{
    [SerializeField] private GameObject indicatorOut;
    [SerializeField] private GameObject indicatorIn;

    public bool dynamicIcon = false;

    [ShowIf("dynamicIcon")] [SerializeField] private Transform posIconIn;
    [ShowIf("dynamicIcon")] [SerializeField] private Transform posIconOut;
    [ShowIf("dynamicIcon")] [SerializeField] private Transform iconIn;
    [ShowIf("dynamicIcon")] [SerializeField] private Transform iconOut;

    [SerializeField] private List<Image> images = new List<Image>();

    [SerializeField] private TextMeshProUGUI distanceTextIn;
    [SerializeField] private TextMeshProUGUI distanceTextOut;

    [SerializeField] private TextMeshProUGUI nameTextIn;
    [SerializeField] private TextMeshProUGUI nameTextOut;

    public Transform target;
    [HideInInspector] public Vector3 targetVector;

    [ShowIf("dynamicIcon")] [SerializeField] private GameObject arrow;

    public bool displayIn = true;
    public bool displayOut = true;

    public bool displayNameIn = false;
    public bool displayNameOut = false;

    private Vector3 screenCentre;
    private Vector3 screenBounds;

    [SerializeField] private float screenBoundOffset = 0.9f;

    RectTransform posCenter;

    [ShowIf("dynamicIcon")] [SerializeField] private CanvasGroup canvasIn;
    [ShowIf("dynamicIcon")] [SerializeField] private CanvasGroup canvasOut;

    private void Start()
    {
        screenCentre = new Vector3(Screen.width, Screen.height, 0) / 2;
        screenBounds = screenCentre * screenBoundOffset;

        indicatorIn.SetActive(false);
        indicatorOut.SetActive(false);

        if(nameTextIn != null)
        {
            nameTextIn.gameObject.SetActive(displayNameIn);
        }

        if (nameTextOut != null)
        {
            nameTextOut.gameObject.SetActive(displayNameOut);
        }
    }

    public void ActiveAnnonciation(RectTransform _posCenter)
    {
        arrow.SetActive(false);
        posCenter = _posCenter;
        StartCoroutine(StartAnonciation());
    }

    bool moveIcon = false;
    IEnumerator StartAnonciation()
    {
        canvasIn.alpha = 0;
        canvasOut.alpha = 0;

        moveIcon = true;

        yield return new WaitForSeconds(2f);
        moveIcon = false;

        var currentPos = iconIn.position;
        var t = 0f;
        while (t < 1)
        {
            t += Time.deltaTime / 1.2f;
            iconIn.position = Vector3.Lerp(currentPos, posIconIn.position, t);
            iconOut.position = Vector3.Lerp(currentPos, posIconOut.position, t);
            yield return null;
        }

        arrow.SetActive(true);
        canvasIn.alpha = 1;
        canvasOut.alpha = 1;
    }

    public virtual void SetUnderText(string _value)
    {
        distanceTextIn.text = _value;
        distanceTextOut.text = _value;
    }

    private void LateUpdate()
    {
        if (moveIcon)
        {
            iconIn.transform.position = posCenter.position;
            iconOut.transform.position = posCenter.position;
        }

        //position
        Vector3 screenPosition = Vector3.zero;

        if (target)
        {
            screenPosition = OffScreenIndicatorCore.GetScreenPosition(Camera.main, target.transform.position);
        }
        else
        {
            screenPosition = OffScreenIndicatorCore.GetScreenPosition(Camera.main, targetVector);
        }
        bool isTargetVisible = OffScreenIndicatorCore.IsTargetVisible(screenPosition);

        if (isTargetVisible)
        {
            screenPosition.z = 0;
            //indicator = GetIndicator(ref target.indicator, IndicatorType.BOX); // Gets the box indicator from the pool.

            indicatorIn.SetActive(displayIn);
            indicatorOut.SetActive(false);

            transform.rotation = Quaternion.identity;
        }
        else if (!isTargetVisible)
        {
            float angle = float.MinValue;
            OffScreenIndicatorCore.GetArrowIndicatorPositionAndAngle(ref screenPosition, ref angle, screenCentre, screenBounds);
            transform.rotation = Quaternion.Euler(0, 0, angle * Mathf.Rad2Deg); // Sets the rotation for the arrow indicator.

            indicatorOut.SetActive(displayOut);
            indicatorIn.SetActive(false);
        }

        transform.position = screenPosition; //Sets the position of the indicator on the screen.
        SetTextRotation(Quaternion.identity); // Sets the rotation of the distance text of the indicator.
    }

    public void SetImageColor(Color color)
    {
        foreach(Image img in images)
        {
            img.color = color;
        }
    }

    public void SetTextRotation(Quaternion rotation)
    {
        if (nameTextIn != null)
        {
            distanceTextIn.rectTransform.rotation = rotation;
        }

        if (nameTextOut != null)
        {
            distanceTextOut.rectTransform.rotation = rotation;
        }
    }
}

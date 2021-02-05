using PixelPlay.OffScreenIndicator;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class Waypoint : MonoBehaviour
{
    [SerializeField] private GameObject indicatorOut;
    [SerializeField] private GameObject indicatorIn;

    [SerializeField] private List<Image> images = new List<Image>();

    [SerializeField] private TextMeshProUGUI distanceTextIn;
    [SerializeField] private TextMeshProUGUI distanceTextOut;

    [SerializeField] private TextMeshProUGUI nameTextIn;
    [SerializeField] private TextMeshProUGUI nameTextOut;

    public Transform target;

    public bool displayNameIn = false;
    public bool displayNameOut = false;

    public bool displayDistanceIn = false;
    public bool displayDistanceOut = false;

    private Vector3 screenCentre;
    private Vector3 screenBounds;

    [SerializeField] private float screenBoundOffset = 0.9f;

    private void Start()
    {
        screenCentre = new Vector3(Screen.width, Screen.height, 0) / 2;
        screenBounds = screenCentre * screenBoundOffset;

        indicatorIn.SetActive(false);
        indicatorOut.SetActive(false);

        nameTextIn.gameObject.SetActive(displayNameIn);
        nameTextOut.gameObject.SetActive(displayNameOut);
    }

    private void LateUpdate()
    {
        //distance
        if (displayDistanceIn || displayDistanceOut)
        {
            float value = Vector3.Distance(target.position, GameManager.Instance.currentLocalPlayer.transform.position);
            distanceTextIn.text = value >= 0 ? Mathf.Floor(value) + " m" : "";
            distanceTextOut.text = value >= 0 ? Mathf.Floor(value) + " m" : "";
        }

        //position
        Vector3 screenPosition = OffScreenIndicatorCore.GetScreenPosition(Camera.main, target.transform.position);
        bool isTargetVisible = OffScreenIndicatorCore.IsTargetVisible(screenPosition);

        if (isTargetVisible)
        {
            screenPosition.z = 0;
            //indicator = GetIndicator(ref target.indicator, IndicatorType.BOX); // Gets the box indicator from the pool.

            if (!indicatorIn.activeSelf)
            {
                indicatorIn.SetActive(true);
                indicatorOut.SetActive(false);

                distanceTextIn.gameObject.SetActive(displayDistanceIn);
                distanceTextOut.gameObject.SetActive(false);
            }

            transform.rotation = Quaternion.identity;
        }
        else if (!isTargetVisible)
        {
            float angle = float.MinValue;
            OffScreenIndicatorCore.GetArrowIndicatorPositionAndAngle(ref screenPosition, ref angle, screenCentre, screenBounds);
            transform.rotation = Quaternion.Euler(0, 0, angle * Mathf.Rad2Deg); // Sets the rotation for the arrow indicator.

            if (!indicatorOut.activeSelf)
            {
                indicatorOut.SetActive(true);
                indicatorIn.SetActive(false);

                distanceTextOut.gameObject.SetActive(displayDistanceOut);
                distanceTextIn.gameObject.SetActive(false);
            }
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
        distanceTextIn.rectTransform.rotation = rotation;
        distanceTextOut.rectTransform.rotation = rotation;
    }
}

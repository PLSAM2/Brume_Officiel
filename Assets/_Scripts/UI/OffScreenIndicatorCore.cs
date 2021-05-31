using UnityEngine;

namespace PixelPlay.OffScreenIndicator
{
    public class OffScreenIndicatorCore
    {
        public static Vector3 GetScreenPosition(Camera mainCamera, Vector3 targetPosition)
        {
            Vector3 screenPosition = mainCamera.WorldToScreenPoint(targetPosition);
            return screenPosition;
        }

        public static bool IsTargetVisible(Vector3 screenPosition)
        {
            //bool isTargetVisible = screenPosition.z > 0 && screenPosition.x > 0 && screenPosition.x < Screen.width && screenPosition.y > 0 && screenPosition.y < Screen.height;
              bool isTargetVisible = screenPosition.z > 0 && screenPosition.x > (Screen.width * 0.1f) && screenPosition.x < (Screen.width - Screen.width * 0.1f) && screenPosition.y > (Screen.height * 0.1f) && screenPosition.y < (Screen.height - Screen.height * 0.1f);
            return isTargetVisible;
        }

        public static void GetArrowIndicatorPositionAndAngle(ref Vector3 screenPosition, ref float angle, Vector3 screenCentre, Vector3 screenBounds)
        {
            // Our screenPosition's origin is screen's bottom-left corner.
            // But we have to get the arrow's screenPosition and rotation with respect to screenCentre.
            screenPosition -= screenCentre;

            // When the targets are behind the camera their projections on the screen (WorldToScreenPoint) are inverted,
            // so just invert them.
            if(screenPosition.z < 0)
            {
                screenPosition *= -1;
            }

            // Angle between the x-axis (bottom of screen) and a vector starting at zero(bottom-left corner of screen) and terminating at screenPosition.
            angle = Mathf.Atan2(screenPosition.y, screenPosition.x);
            // Slope of the line starting from zero and terminating at screenPosition.
            float slope = Mathf.Tan(angle);

            // Two point's line's form is (y2 - y1) = m (x2 - x1) + c, 
            // starting point (x1, y1) is screen botton-left (0, 0),
            // ending point (x2, y2) is one of the screenBounds,
            // m is the slope
            // c is y intercept which will be 0, as line is passing through origin.
            // Final equation will be y = mx.
            if(screenPosition.x > 0)
            {
                // Keep the x screen position to the maximum x bounds and
                // find the y screen position using y = mx.
                screenPosition = new Vector3(screenBounds.x, screenBounds.x * slope, 0);
            }
            else
            {
                screenPosition = new Vector3(-screenBounds.x, -screenBounds.x * slope, 0);
            }
            // Incase the y ScreenPosition exceeds the y screenBounds 
            if(screenPosition.y > screenBounds.y)
            {
                // Keep the y screen position to the maximum y bounds and
                // find the x screen position using x = y/m.
                screenPosition = new Vector3(screenBounds.y / slope, screenBounds.y, 0);
            }
            else if(screenPosition.y < -screenBounds.y)
            {
                screenPosition = new Vector3(-screenBounds.y / slope, -screenBounds.y, 0);
            }
            // Bring the ScreenPosition back to its original reference.
            screenPosition += screenCentre;
        }
    }
}

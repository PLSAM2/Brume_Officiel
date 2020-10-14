using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdvancedDissolve_Example
{
    public class UIEventReciever_ExampleScene_Mask_Cylinder : MonoBehaviour
    {
        //Updates all 'Plane' mask related parameters
        Controller_Mask_Cylinder maskController;

        

        // Use this for initialization
        void Start()
        {
            maskController = GetComponent<Controller_Mask_Cylinder>();

            int i = 1;
            foreach (GameObject obj in maskController.allbrumes)
            {
                if(i > 1)
                {
                    obj.SetActive(false);
                }
                i++;
            }

            UI_Count(0);
            UI_Invert(false);
        }


        public void UI_Count(int value)
        {
            //UI dropdown displays "1", "2", "3", "4" are just item names.
            //value - is dropdown index starting from 0 (zero)
            value += 1;


            maskController.UpdateMaskCountKeyword(value);

            int i = 1;
            foreach (GameObject obj in maskController.allbrumes)
            {
                if (i > 1)
                {
                    obj.SetActive(value > i-1);
                }
                i++;
            }
        }

        public void UI_Invert(bool value)
        {
            maskController.invert = value;
        }
    }
}
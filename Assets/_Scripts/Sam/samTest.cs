using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static GameData;

public class samTest : MonoBehaviour
{
    public float raduis = 6;
    public float number = 30;

    public LayerMask objs;
    public LayerMask wall;

    private void Update()
    {
        for (int i = 0; i < 45; i++)
        {
            Vector3 _direction = Quaternion.Euler(0, i * (360 / 45), 0) * transform.forward;
            Ray _ray = new Ray(transform.position, _direction);

            RaycastHit hit;
            float distance = raduis;
            if (Physics.Raycast(_ray.origin, _ray.direction, out hit, raduis, wall))
            {
                distance = Vector3.Distance(transform.position, hit.point);
            }

            RaycastHit[] hits = Physics.RaycastAll(transform.position, _ray.direction, distance, objs);

            foreach (RaycastHit target in hits)
            {
                switch (target.transform.gameObject.tag)
                {
                    case "Hide":
                        if (target.transform.gameObject.layer == 11)
                        {
                            //if (visibleFx.Contains(target.transform)) { continue; }
                            //visibleFx.Add(target.transform);
                        }
                        else
                        {
                            //if (visibleTargets.Contains(target.transform)) { continue; }
                            //visibleTargets.Add(target.transform);
                        }
                        break;

                    case "Interactible":
                        //if (visibleInteractible.ContainsKey(target.transform)) { continue; }
                        //visibleInteractible.Add(target.transform, target.transform.GetComponent<Interactible>().interactibleID);
                        break;

                }
            }
        }
    }
}

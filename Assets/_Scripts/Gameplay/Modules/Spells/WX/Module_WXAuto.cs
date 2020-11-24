using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WXAuto : SpellModule
{
    public DamagesInfos damages;
    private ArrowPreview arrowPreview;
    [SerializeField] private float rayWidthDivider = 10;
    [SerializeField] private int raycastCount = 3;
    [SerializeField] private LayerMask hitLayer;

    private void Start()
    {
        arrowPreview = PreviewManager.Instance.GetArrowPreview();
        arrowPreview.gameObject.SetActive(false);
    }

    protected override void ResolveSpell(Vector3 _mousePosition)
    {
        base.ResolveSpell(_mousePosition);

        LocalPlayer _hitPlayer = ShootAndGetFirstHit();
        //arrowPreview.Init(this.transform.position, );
        //arrowPreview.gameObject.SetActive(true);

        if (_hitPlayer != null)
        {
            _hitPlayer.DealDamages(damages, this.transform.position);
        }
    }


    public LocalPlayer ShootAndGetFirstHit()
    {
        List<LocalPlayer> _temp = new List<LocalPlayer>();

        Vector3 _direction = transform.forward;
        Vector3 _width = transform.right / rayWidthDivider;
        Vector3 _offset = new Vector3(raycastCount *  (1/rayWidthDivider), 0 , 0);

        for (int i = 0; i < raycastCount; i++)
        {
            Ray _ray = new Ray(transform.position + Vector3.up + _offset + (_width * i), _direction);
            RaycastHit[] _allhits = Physics.RaycastAll(_ray, spell.range, hitLayer);

            if (_allhits.Length > 0)
            {
                foreach (RaycastHit hit in _allhits)
                {
                    if (hit.collider.GetComponent<LocalPlayer>() != null)
                    {
                        _temp.Add(hit.collider.GetComponent<LocalPlayer>());
                    }
                }
            }

            Ray _debugRay = new Ray(transform.position + Vector3.up + _offset + (_width * i), _direction);
            Debug.DrawRay(_ray.origin, _debugRay.direction * spell.range, Color.red, 5);
        }


        // Get first hit >>

        LocalPlayer closestPlayer = null;
        float closestPlayerDistance = 0;

        foreach (LocalPlayer p in _temp)
        {
            if (closestPlayer == null)
            {
                closestPlayer = p;
                closestPlayerDistance = Vector3.Distance(this.transform.position, closestPlayer.transform.position);
                continue;
            }

            if (closestPlayerDistance > Vector3.Distance(this.transform.position, p.transform.position))
            {
                closestPlayer = p;
                closestPlayerDistance = Vector3.Distance(this.transform.position, closestPlayer.transform.position);
            }
        }
        return closestPlayer;
    }

}

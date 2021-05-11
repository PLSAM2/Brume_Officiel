using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Module_WXAuto : SpellModule
{
    private ArrowPreview arrowPreview;
    [SerializeField] private float rayWidthDivider = 10;
    [SerializeField] private int raycastCount = 3;
    Sc_RayAttack localTrad;

	public override void SetupComponent ( En_SpellInput _actionLinked )
	{
		base.SetupComponent(_actionLinked);
        arrowPreview = PreviewManager.Instance.GetArrowPreview();
        HidePreview(Vector3.zero);
        localTrad = (Sc_RayAttack)spell;
    }

	protected override void AnonceSpell(Vector3 _toAnnounce)
    {
        base.AnonceSpell(_toAnnounce);

        LocalPoolManager.Instance.SpawnNewGenericInNetwork(2, transform.position + Vector3.up * 0.1f, transform.eulerAngles.y, spell.range, spell.anonciationTime + 1);
    }

    protected override void ShowPreview(Vector3 mousePos)
    {
        SetPreview();

        if (base.canBeCast())
        {
            base.ShowPreview(mousePos);
            arrowPreview.gameObject.SetActive(true);
        }
    }

    public override void TryCanalysing(Vector3 _BaseMousePos )
    {
        HidePreview(Vector3.zero);
        base.TryCanalysing(_BaseMousePos);
    }

    protected override void HidePreview( Vector3 _posToHide )
    {
        base.HidePreview(_posToHide);
        arrowPreview.gameObject.SetActive(false);
    }

    protected override void UpdatePreview()
    {
        SetPreview();
    }

    private void SetPreview()
    {
        Vector3 normDirection = (myPlayerModule.mousePos() - this.transform.position).normalized;

        arrowPreview.Init(this.transform.position, this.transform.position + (normDirection * spell.range));
    }

    protected override void Resolution()
    {
        base.Resolution();

        LocalPlayer _hitPlayer = ShootAndGetFirstHit();

        LocalPoolManager.Instance.SpawnNewGenericInNetwork(3, transform.position + Vector3.up * 0.1f, transform.eulerAngles.y, spell.range, 1);

        if (_hitPlayer != null)
        {
            _hitPlayer.DealDamages(localTrad.damagesToDeal, transform, myPlayerModule.mylocalPlayer.myPlayerId);
        }
    }


    public LocalPlayer ShootAndGetFirstHit()
    {
        List<LocalPlayer> _temp = new List<LocalPlayer>();

        Vector3 _direction = transform.forward;
        Vector3 _width = transform.right / rayWidthDivider;
        Vector3 _offset = new Vector3(_width.x, 0 , 0);

        for (int i = 0; i < raycastCount; i++)
        {
            Ray _ray = new Ray(transform.position + Vector3.up + (_width * i), _direction);

            RaycastHit[] _allhits = Physics.RaycastAll(_ray, spell.range, 1 << 8);

            if (_allhits.Length > 0)
            {
                foreach (RaycastHit hit in _allhits)
                {
                    LocalPlayer hitP = hit.collider.GetComponent<LocalPlayer>();
                    if (hitP != null)
                    {
                        if (NetworkManager.Instance.GetLocalPlayer().playerTeam != hitP.myPlayerModule.teamIndex)
                        {
                            _temp.Add(hitP);
                        }
                    }
                }
            }

            Ray _debugRay = new Ray(transform.position + Vector3.up - _offset + (_width * i), _direction);
            Debug.DrawRay(_debugRay.origin, _debugRay.direction * spell.range, Color.red, 5);
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

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class FieldOfView : MonoBehaviour
{

	public float viewRadius;

	public LayerMask targetMask;
	public LayerMask obstacleMask;

	[HideInInspector]
	public List<Transform> visibleTargets = new List<Transform>();
	List<Transform> oldVisibleTargets = new List<Transform>();

    public List<Transform> visibleFx = new List<Transform>();
    List<Transform> oldVisibleFx = new List<Transform>();

    public Dictionary<Transform, ushort> visibleInteractible = new Dictionary<Transform, ushort>();
    List<ushort> oldVisibleInteractible = new List<ushort>();

	[SerializeField] fowType myType;

	Coroutine refreshCoroutine;

    private void OnEnable()
    {
		refreshCoroutine = StartCoroutine("FindTargetsWithDelay", .1f);
	}

    private void OnDisable()
    {
		if(refreshCoroutine != null)
        {
			StopCoroutine(refreshCoroutine);
		}

		visibleTargets.Clear();
		SetListVisibleEnemy();
	}

	IEnumerator FindTargetsWithDelay ( float delay )
	{
		while (true)
		{
			yield return new WaitForSeconds(delay);
			FindVisibleTargets();
		}
	}

	public void GenerateFowStatic()
    {
		isStatic = true;
	}

    [SerializeField] bool isStatic = false;

	void FixedUpdate ()
	{
        SetListVisibleEnemy();
        SetListVisibleFx();
        SetListVisibleInteractible();
	}

    void SetListVisibleInteractible()
    {
        foreach (KeyValuePair<Transform, ushort> interact in visibleInteractible)
        {
            if (!GameManager.Instance.allVisibleInteractible.Contains(interact.Value))
            {
                GameManager.Instance.allVisibleInteractible.Add(interact.Value);
                GameManager.Instance.OnInteractibleViewChange?.Invoke(interact.Value, true);
            }
        }

        foreach (ushort interact in oldVisibleInteractible)
        {
            if (!visibleInteractible.ContainsValue(interact))
            {
                GameManager.Instance.allVisibleInteractible.Remove(interact);
                GameManager.Instance.OnInteractibleViewChange?.Invoke(interact, false);
            }
        }

        oldVisibleInteractible.Clear();
        oldVisibleInteractible.AddRange(visibleInteractible.Values);
    }

    void SetListVisibleFx()
    {
        foreach (Transform fx in visibleFx)
        {
            if (!GameManager.Instance.allVisibleFx.Contains(fx))
            {
                GameManager.Instance.allVisibleFx.Add(fx);
            }
        }

        foreach (Transform fx in oldVisibleFx)
        {
            if (!visibleFx.Contains(fx))
            {
                GameManager.Instance.allVisibleFx.Remove(fx);
            }
        }

        oldVisibleFx.Clear();
        oldVisibleFx.AddRange(visibleFx);
    }

    void SetListVisibleEnemy ()
	{
		foreach (Transform enemy in visibleTargets)
		{
			if (!GameManager.Instance.visiblePlayer.ContainsKey(enemy))
			{
				//print("add");
				GameManager.Instance.visiblePlayer.Add(enemy, myType);
            }
            else
            {
				if (GameManager.Instance.visiblePlayer[enemy] == fowType.player && myType == fowType.ward)
                {
					//print("update");
					GameManager.Instance.visiblePlayer[enemy] = myType;
				}
            }
		}

		foreach (Transform enemy in oldVisibleTargets)
		{
			if (!visibleTargets.Contains(enemy))
			{
				//print("remove");
				GameManager.Instance.visiblePlayer.Remove(enemy);
			}
		}

		oldVisibleTargets.Clear();
		oldVisibleTargets.AddRange(visibleTargets);
	}

    void FindVisibleTargets()
    {
        visibleTargets.Clear();
        visibleFx.Clear();
        visibleInteractible.Clear();

        Collider[] targetsInViewRadius = Physics.OverlapSphere(transform.position, viewRadius);

        for (int i = 0; i < targetsInViewRadius.Length; i++)
        {
            if (targetsInViewRadius[i].tag != "Hide" && targetsInViewRadius[i].tag != "Interactible") { continue; }

            Transform target = targetsInViewRadius[i].transform;

            Vector3 dirToTarget1 = (target.position - transform.position).normalized;
            Vector3 dirToTarget2 = (targetsInViewRadius[i].ClosestPoint(transform.position) - transform.position).normalized;

            float dstToTarget = Vector3.Distance(transform.position, target.position);
            if (!Physics.Raycast(transform.position, dirToTarget1, dstToTarget, obstacleMask) || !Physics.Raycast(transform.position, dirToTarget2, dstToTarget, obstacleMask))
            {
                switch (targetsInViewRadius[i].tag)
                {
                    case "Hide":
                        if (target.gameObject.layer == 11)
                        {
                            if (visibleFx.Contains(target)) { continue; }
                            visibleFx.Add(target);
                        }
                        else
                        {
                            if (visibleTargets.Contains(target)) { continue; }
                            visibleTargets.Add(target);
                        }
                        break;

                    case "Interactible":
                        if (visibleInteractible.ContainsKey(target)) { continue; }
                        visibleInteractible.Add(target, target.GetComponent<Interactible>().interactibleID);
                        break;

                }
            }
        }
    }

	public Vector3 DirFromAngle ( float angleInDegrees, bool angleIsGlobal )
	{
		if (!angleIsGlobal)
		{
			angleInDegrees += transform.eulerAngles.y;
		}
		return new Vector3(Mathf.Sin(angleInDegrees * Mathf.Deg2Rad), 0, Mathf.Cos(angleInDegrees * Mathf.Deg2Rad));
	}

	public struct ViewCastInfo
	{
		public bool hit;
		public Vector3 point;
		public float dst;
		public float angle;

		public ViewCastInfo ( bool _hit, Vector3 _point, float _dst, float _angle )
		{
			hit = _hit;
			point = _point;
			dst = _dst;
			angle = _angle;
		}
	}

	public struct EdgeInfo
	{
		public Vector3 pointA;
		public Vector3 pointB;

		public EdgeInfo ( Vector3 _pointA, Vector3 _pointB )
		{
			pointA = _pointA;
			pointB = _pointB;
		}
	}

	public enum fowType
    {
		player,
		ward,
		tower
    }
}
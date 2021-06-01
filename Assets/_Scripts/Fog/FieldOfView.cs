using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class FieldOfView : MonoBehaviour
{
	public float viewRadius;
	[Range(0, 360)]
	public float viewAngle;

	public LayerMask targetMask;
	public LayerMask obstacleMask;

	List<Transform> visibleTargets = new List<Transform>();
	List<Transform> oldVisibleTargets = new List<Transform>();

	public List<Transform> visibleFx = new List<Transform>();
	List<Transform> oldVisibleFx = new List<Transform>();

	public Dictionary<Transform, ushort> visibleInteractible = new Dictionary<Transform, ushort>();
	List<ushort> oldVisibleInteractible = new List<ushort>();

	public float meshResolution;
	public int edgeResolveIterations;
	public float edgeDstThreshold;

	public float maskCutawayDst = .1f;

	public MeshFilter viewMeshFilter;
	Mesh viewMesh;

	[SerializeField] fowType myType;

	Coroutine refreshCoroutine;

	public Action<LocalPlayer, bool> OnPlayerEnterInFow;
	public Action<bool> EnemySeen;

    bool enemyIsSeen = false;
    private void Start()
    {
        EnemySeen?.Invoke(false);
    }

    private void OnEnable ()
	{
		refreshCoroutine = StartCoroutine("FindTargetsWithDelay", .1f);
    }

	private void OnDisable ()
	{
		if (refreshCoroutine != null)
		{
			StopCoroutine(refreshCoroutine);
		}

		visibleTargets.Clear();
		SetListVisibleEnemy();
	}


	void InitMesh ()
	{
		viewMesh = new Mesh();
		viewMesh.name = "View Mesh";

		viewMeshFilter.mesh = viewMesh;
	}

	IEnumerator FindTargetsWithDelay ( float delay )
	{
		while (true)
		{
			yield return new WaitForSeconds(delay);
			FindVisibleTargets();
		}
	}

	public void GenerateFowStatic ()
	{
		isStatic = true;
		DrawFieldOfView();
	}

	[SerializeField] bool isStatic = false;

	void FixedUpdate ()
	{
		SetListVisibleEnemy();
		SetListVisibleFx();
		SetListVisibleInteractible();

		if (isStatic) { return; }

		DrawFieldOfView();
	}

	void SetListVisibleInteractible ()
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

	void SetListVisibleFx ()
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
        bool isEnemyInView = false;
		foreach (Transform player in visibleTargets)
		{
            if(player == null) { continue; }

			if (!GameManager.Instance.visiblePlayer.ContainsKey(player))
			{
				//print("add");
				GameManager.Instance.visiblePlayer.Add(player, myType);
				OnPlayerEnterInFow?.Invoke(player.GetComponent<LocalPlayer>(), true);
			}
			else
			{
				if (GameManager.Instance.visiblePlayer[player] == fowType.player && myType == fowType.ward)
				{
					//print("update");
					GameManager.Instance.visiblePlayer[player] = myType;
					OnPlayerEnterInFow?.Invoke(player.GetComponent<LocalPlayer>(), true);
				}
			}

            if (!isEnemyInView && GameFactory.TransformIsEnemy(player))
            {
                isEnemyInView = true;
            }
		}

        if(isEnemyInView != enemyIsSeen)
        {
            enemyIsSeen = isEnemyInView;
            EnemySeen?.Invoke(enemyIsSeen);
        }

		foreach (Transform enemy in oldVisibleTargets)
		{
            if(enemy == null) { continue; }

			if (!visibleTargets.Contains(enemy))
			{
				//print("remove");
				GameManager.Instance.visiblePlayer.Remove(enemy);
				OnPlayerEnterInFow?.Invoke(enemy.GetComponent<LocalPlayer>(), false);
			}
		}

		oldVisibleTargets.Clear();
		oldVisibleTargets.AddRange(visibleTargets);
	}

    void FindVisibleTargets ()
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

    int rota = 0;

	public void DrawFieldOfView ()
	{
		int stepCount = Mathf.RoundToInt(viewAngle * meshResolution / 5);
		float stepAngleSize = viewAngle / stepCount;
		List<Vector3> viewPoints = new List<Vector3>();
		ViewCastInfo oldViewCast = new ViewCastInfo();

		for (int i = 0; i <= stepCount; i++)
		{
			float angle = transform.eulerAngles.y - viewAngle / 2 + stepAngleSize * i;
			ViewCastInfo newViewCast = ViewCast(angle);

			if (i > 0)
			{
				bool edgeDstThresholdExceeded = Mathf.Abs(oldViewCast.dst - newViewCast.dst) > edgeDstThreshold;
				if (oldViewCast.hit != newViewCast.hit || (oldViewCast.hit && newViewCast.hit && edgeDstThresholdExceeded))
				{
					EdgeInfo edge = FindEdge(oldViewCast, newViewCast);
					if (edge.pointA != Vector3.zero)
					{
						viewPoints.Add(edge.pointA);
					}
					if (edge.pointB != Vector3.zero)
					{
						viewPoints.Add(edge.pointB);
					}
				}

			}


			viewPoints.Add(newViewCast.point);
			oldViewCast = newViewCast;
		}

		int vertexCount = viewPoints.Count + 1;
		Vector3[] vertices = new Vector3[vertexCount];
		int[] triangles = new int[(vertexCount - 2) * 3];

		vertices[0] = Vector3.zero;
		for (int i = 0; i < vertexCount - 1; i++)
		{
			vertices[i + 1] = transform.InverseTransformPoint(viewPoints[i]) + Vector3.forward * maskCutawayDst;

			if (i < vertexCount - 2)
			{
				triangles[i * 3] = 0;
				triangles[i * 3 + 1] = i + 1;
				triangles[i * 3 + 2] = i + 2;
			}
		}

		if (viewMesh == null)
		{
			InitMesh();
		}

		viewMesh.Clear();

		viewMesh.vertices = vertices;
		viewMesh.triangles = triangles;
		viewMesh.RecalculateNormals();
	}

	EdgeInfo FindEdge ( ViewCastInfo minViewCast, ViewCastInfo maxViewCast )
	{
		float minAngle = minViewCast.angle;
		float maxAngle = maxViewCast.angle;
		Vector3 minPoint = Vector3.zero;
		Vector3 maxPoint = Vector3.zero;

		for (int i = 0; i < edgeResolveIterations; i++)
		{
			float angle = (minAngle + maxAngle) / 2;
			ViewCastInfo newViewCast = ViewCast(angle);

			bool edgeDstThresholdExceeded = Mathf.Abs(minViewCast.dst - newViewCast.dst) > edgeDstThreshold;
			if (newViewCast.hit == minViewCast.hit && !edgeDstThresholdExceeded)
			{
				minAngle = angle;
				minPoint = newViewCast.point;
			}
			else
			{
				maxAngle = angle;
				maxPoint = newViewCast.point;
			}
		}

		return new EdgeInfo(minPoint, maxPoint);
	}


	ViewCastInfo ViewCast ( float globalAngle )
	{
		Vector3 dir = DirFromAngle(globalAngle, true);
		RaycastHit hit;

		if (Physics.Raycast(transform.position, dir, out hit, viewRadius, obstacleMask))
		{
			return new ViewCastInfo(true, hit.point, hit.distance, globalAngle);
		}
		else
		{
			return new ViewCastInfo(false, transform.position + dir * viewRadius, viewRadius, globalAngle);
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
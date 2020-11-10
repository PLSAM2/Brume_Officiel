using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class UpdatePlaneSection : MonoBehaviour {

	public GameObject m_plane;
	private Renderer m_renderer;
	// Use this for initialization
	void Start()
	{
		m_renderer = GetComponent<Renderer>();
	}

	// Update is called once per frame
	void Update () {
		if( m_renderer!=null && m_plane != null )
		{

			m_renderer.sharedMaterial.SetVector("_PlanePosition", new Vector4( m_plane.transform.position.x, m_plane.transform.position.y, m_plane.transform.position.z ) );
			m_renderer.sharedMaterial.SetVector( "_PlaneNormal", new Vector4( m_plane.transform.forward.x, m_plane.transform.forward.y, m_plane.transform.forward.z ) );
		}
	}
}

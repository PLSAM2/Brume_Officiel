using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace AdultLink {
	[ExecuteInEditMode]
	public class SetPosition : MonoBehaviour {

	public List<Material> mats = new List<Material>();
	// Update is called once per frame
	void Update () {

			foreach(Material mat in mats)
            {
				mat.SetVector("_Position", transform.position);
			}
	}
}
}

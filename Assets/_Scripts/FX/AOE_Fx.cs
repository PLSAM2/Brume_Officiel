using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
public class AOE_Fx : MonoBehaviour
{
	[SerializeField] AnimationCurve myCurve;
	[SerializeField] ParticleSystem imgInter;

    [SerializeField] GameObject redMesh;
    [SerializeField] GameObject blueMesh;

    float size = 0;

	float currentWaveTime = 0;

	float timeToSize = 1;

	public void Init (Vector3 _pos, float _scale, float _time, Team _team)
	{
        transform.position = _pos;
		transform.eulerAngles = new Vector3(0, 0, 0);
		transform.localScale = new Vector3(_scale, _scale, _scale);

		imgInter.transform.localScale = Vector3.zero;
		size = 0;
		currentWaveTime = 0;
		timeToSize = _time;

        ParticleSystem.MainModule m = imgInter.main;
        m.startColor = GameFactory.GetRelativeColor(_team);

        blueMesh.SetActive(_team == NetworkManager.Instance.GetLocalPlayer().playerTeam);
        redMesh.SetActive(_team != NetworkManager.Instance.GetLocalPlayer().playerTeam);
    }

	private void Update ()
	{
		size = Mathf.Lerp(0, 1, myCurve.Evaluate(currentWaveTime / timeToSize));
		currentWaveTime += Time.deltaTime;

		imgInter.transform.localScale = new Vector3(size, size, size);

        ParticleSystem.MainModule m = imgInter.main;
        m.startColor = new Color(imgInter.startColor.r, imgInter.startColor.g, imgInter.startColor.b, size);
	}
}

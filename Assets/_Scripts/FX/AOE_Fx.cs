using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static GameData;
public class AOE_Fx : MonoBehaviour
{
	[SerializeField] AnimationCurve myCurve;

	[SerializeField] SpriteRenderer imgExt;
	[SerializeField] SpriteRenderer imgInter;

	[SerializeField] Sprite circle;
	[SerializeField] Sprite square;

	float size = 0;

	float currentWaveTime = 0;

	float timeToSize = 1;

	public void Init ( AOE_Fx_Type _myType, Vector3 _pos, float _rota, float _scale, float _time, Team _team )
	{
		switch (_myType)
		{
			case AOE_Fx_Type.circle:
				imgExt.sprite = circle;
				imgInter.sprite = circle;
				break;

			case AOE_Fx_Type.square:
				imgExt.sprite = square;
				imgInter.sprite = square;
				break;
		}

		transform.position = _pos;
		transform.eulerAngles = new Vector3(0, _rota, 0);
		transform.localScale = new Vector3(_scale, _scale, _scale);

		imgInter.transform.localScale = Vector3.zero;
		size = 0;
		currentWaveTime = 0;
		timeToSize = _time;

		imgExt.color = GameFactory.GetRelativeColor(_team);
		imgInter.color = GameFactory.GetRelativeColor(_team);

	}

	private void Update ()
	{
		size = Mathf.Lerp(0, 1, myCurve.Evaluate(currentWaveTime / timeToSize));
		currentWaveTime += Time.deltaTime;

		imgInter.transform.localScale = new Vector3(size, size, size);
		imgInter.color = new Color(imgInter.color.r, imgInter.color.g, imgInter.color.b, size);
	}

	public enum AOE_Fx_Type
	{
		circle,
		square
	}
}

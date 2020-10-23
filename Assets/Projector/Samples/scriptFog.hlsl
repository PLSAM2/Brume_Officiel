void MyFunc_float(sampler2D _FogTex, out float4 Out){

	fixed a2 = tex2Dproj(_FogTex, UNITY_PROJ_COORD(i.uvShadow)).a;
	Out = lerp(_Color, fixed4(1, 1, 1, 1), a2);
}
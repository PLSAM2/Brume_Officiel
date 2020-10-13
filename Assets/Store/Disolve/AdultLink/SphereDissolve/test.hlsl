

void Clip_float (
	float3 _worldPos, 
	float4 _Position, 
	float _Bordernoisescale, 
	float _noiseResult, 
	float _Radius, 
	float _Borderradius, 
	float4 _Emission_tint,
	float4 _Bordercolor,
	out float ClipOut){

	float temp_output_15_0 = distance(_Position, _worldPos);

	float temp_output_39_0 = (_noiseResult + _Radius);
	float temp_output_5_0 = step((1.0 - saturate((temp_output_15_0 / temp_output_39_0))), 0.5);
	float temp_output_32_0 = saturate((temp_output_15_0 / (_Borderradius + temp_output_39_0)));
	float Border49 = (temp_output_5_0 - step((1.0 - temp_output_32_0), 0.5));
	//float4 Emission113 = ((_Emission_tint * normalColor) + (_Bordercolor * Border49));
	//o.Emission = Emission113.rgb;

	//float4 Metallic114 = (tex2D(_Metallic, UVs116) * _Metallic_multiplier);
	//o.Metallic = Metallic114.r;
	//o.Smoothness = _Smoothness;
	//o.Alpha = 1;

	float num = 0.5;
	float stepFloat = step(temp_output_32_0, num);
	float Mask51 = lerp(temp_output_5_0, stepFloat, 1);

	ClipOut = Mask51 - num;
	// = clip(lerpResult);*/
}
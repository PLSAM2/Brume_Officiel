void Normal_float (float4 texcoord, float4 _Tiling, float4 _Offset, Texture2D<float4> _nono, float4 _UV, SamplerState _textureOption, out float3 NormalOut, out float2 UVs116)
{
	float4 normalColor = _nono.Sample(_textureOption, _UV.xy);


	float2 uv_TexCoord90 = texcoord * _Tiling + _Offset;
	UVs116 = uv_TexCoord90;
	float3 Normal112 = UnpackNormal(normalColor);

	NormalOut = texcoord.xyz;
}
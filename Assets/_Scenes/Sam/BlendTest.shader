Shader "Custom/BlendTest"
{
	Properties
	{
		_MainTex("Tex", 2D) = "white" {}
		_SaveTex("SaveTex", 2D) = "white" {}
		_Blend("Blend time", Range(0,1)) = 0.2
	}
	
	SubShader
		{
				Tags { "RenderPipeline" = "UniversalPipeline" }

				Pass
				{
					ZTest Always
					Cull Off
					ZWrite Off
					Fog { Mode off }

					HLSLPROGRAM
					#pragma vertex vert_img
					#pragma fragment frag vertex:vert
					#pragma fragmentoption ARB_precision_hint_fastest
					#include "UnityCG.cginc"

					sampler2D _MainTex;
					sampler2D _SaveTex;

					float _Blend;

					float4 _Save;


					struct Input
					{
						float4 position : POSITION;
						float2 uv : TEXCOORD0;
					};

					void vert(inout appdata_full v, out Input o)
					{
						o.position = UnityObjectToClipPos(v.vertex);
						o.uv = v.texcoord.xy;
					}

					fixed4 frag(Input i) : COLOR
					{
						float4 fog = tex2D(_MainTex, i.uv);

						float4 result = fog + _Save;

						_Save = result;
						return result;
					}
					ENDHLSL
				}
		}
		Fallback off
}

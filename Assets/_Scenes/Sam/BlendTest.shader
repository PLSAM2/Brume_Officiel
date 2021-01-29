Shader "Custom/BlendTest"
{
	Properties
	{
		_MyTexture1("Texture1", 2D) = "white" { }
		_MyTexture2("Texture2", 2D) = "white" { }
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

					sampler2D _MyTexture1;
					sampler2D _MyTexture2;

					float _Blend;

					float4 _Save;


					struct Input
					{
						float4 position : POSITION;
						float2 uv : TEXCOORD0;
						float2 uv_Tex1 : TEXCOORD0;
						float2 uv_Tex2 : TEXCOORD0;
					};

					void vert(inout appdata_full v, out Input o)
					{
						o.position = UnityObjectToClipPos(v.vertex);
						o.uv = v.texcoord.xy;
					}


					fixed4 frag(Input i) : COLOR
					{
						   float4 col1 = tex2D(_MyTexture1, i.uv_Tex1);
						   float4 col2 = tex2D(_MyTexture2, i.uv_Tex2);
						   //blend them somehow - here I just use average color
						   float finalR = col1.r / 3 + col2.r / 3;
						   float finalG = col1.g / 3 + col2.g / 3;
						   float finalB = col1.b / 3 + col2.b / 3;
						   float4 final;
						   final.r = finalR;
						   final.g = finalG;
						   final.b = finalB;
						return final;
					}
					ENDHLSL
				}
		}
		Fallback off
}
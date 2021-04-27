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
						half4 original = tex2D(_MyTexture1, i.uv);
						half4 blend = tex2D(_MyTexture2, i.uv);


						return lerp(original, blend, 0.5);
					}
					ENDHLSL
				}
		}
		Fallback off
}
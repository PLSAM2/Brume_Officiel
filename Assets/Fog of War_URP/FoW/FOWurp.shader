Shader "Image Effects/Fog of War Urp"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FogTex0 ("Fog 0", 2D) = "white" {}
		_FogTex1 ("Fog 1", 2D) = "white" {}
		_Unexplored ("Unexplored Color", Color) = (0.05, 0.05, 0.05, 0.05)
		_BlurAmount("Blur Amount", Range(0,02)) = 0.0005
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
			sampler2D _FogTex0;
			sampler2D _FogTex1;
			sampler2D _CameraDepthTexture;

			float _BlurAmount;

			uniform float4x4 _InverseMVP;
			uniform float4 _Params;
			uniform float4 _CamPos;
			uniform half4 _Unexplored;

			struct Input
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			void vert (inout appdata_full v, out Input o)
			{
				o.position = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord.xy;
			}

			float3 CamToWorld (in float2 uv, in float depth)
			{
				float4 pos = float4(uv.x, uv.y, depth, 1.0);
				pos.xyz = pos.xyz * 2.0 - 1.0;
				pos = mul(_InverseMVP, pos);
				return pos.xyz / pos.w;
			}

			fixed4 frag(Input i) : COLOR
			{
				half4 original = tex2D(_MainTex, i.uv);

				float depth = 1.0 - UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, i.uv));
				float3 pos = CamToWorld(i.uv, depth);

				if (pos.y < 0.0)
				{
					float3 dir = normalize(pos - _CamPos.xyz);
					pos = _CamPos.xyz - dir * (_CamPos.y / dir.y);
				}

				float2 uv = pos.xz * _Params.z + _Params.xy;

				//Lerp0 = tex2D(_FogTex0, uv).r * Lerp0.r;

				//half4 fog = tex2D(_FogTex0, uv);

				half4 texcol = half4(0,0,0,0);
				float remaining = 1.0f;
				float coef = 1.0;
				float fI = 0;
				for (int j = 0; j < 3; j++) {
					fI++;
					coef *= 0.32;
					texcol += tex2D(_FogTex0, float2(uv.x, uv.y - fI * _BlurAmount)) * coef;
					texcol += tex2D(_FogTex0, float2(uv.x - fI * _BlurAmount, uv.y)) * coef;
					texcol += tex2D(_FogTex0, float2(uv.x + fI * _BlurAmount, uv.y)) * coef;
					texcol += tex2D(_FogTex0, float2(uv.x, uv.y + fI * _BlurAmount)) * coef;

					remaining -= 4 * coef;
				}
				//texcol += tex2D(_FogTex0, float2(uv.x, uv.y)) * remaining;

				float4 result = texcol * tex2D(_FogTex1, float2(uv.x, uv.y));

				return lerp(original * _Unexplored, original, result);
			}
			ENDHLSL
		}
	}
	Fallback off
}

Shader "Custom/Stencil Mask" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry-100" "RenderPipeline" = "UniversalPipeline" }
		ColorMask 0
		ZWrite off
		LOD 200

		Stencil {
			Ref 1
			Pass replace
		}

		Pass {

			HLSLPROGRAM
			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"            


			sampler2D _MainTex;

			struct Input {
				float2 uv_MainTex;
			};

			half _Glossiness;
			half _Metallic;
			fixed4 _Color;

			void surf(Input IN, inout SurfaceOutputStandard o) {
				// Albedo comes from a texture tinted by color
				fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = c.rgb;
				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;
			}
		ENDHLSL
		}
	}
}

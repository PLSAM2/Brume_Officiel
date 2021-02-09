// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "GAPH Custom Shader/Distortion Effect/Mobile/Mobile - Distortion Effect(WithMask)" {
	Properties {
			_TintColor ("Tint Color", Color) = (1,1,1,1)
			_Mask ("Mask (A)",2D) = "black"{}
			_NormalMap ("Normalmap", 2D) = "bump" {}
			_DistortFactor ("Distortion", Float) = 10
			_InvFade ("Soft Particles Factor", Range(0,10)) = 1.0
	}

	Category {

		Tags { "Queue"="Transparent"  "IgnoreProjector"="True"  "RenderType"="Opaque" }
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off 
		Lighting Off 
		ZWrite Off 

		SubShader {
			GrabPass {							
				Name "BASE"
				Tags { "LightMode" = "Always" }
			}
				Pass {
					Name "BASE"
					Tags { "LightMode" = "Always" }
					
					HLSLPROGRAM
					#pragma vertex vert
					#pragma fragment frag
					#pragma fragmentoption ARB_precision_hint_fastest
					#pragma multi_compile_particles
					#include "UnityCG.cginc"

					struct appdata_t {
						float4 vertex : POSITION;
						float2 texcoord: TEXCOORD0;
						fixed4 color : COLOR;
					};

					struct v2f {
						float4 vertex : POSITION;
						float4 uvgrab : TEXCOORD0;
						float2 uvnormal : TEXCOORD1;
						float2 uvmask : TEXCOORD2;
						fixed4 color : COLOR;
						float4 projPos : TEXCOORD3;
					};

					fixed4 _TintColor;

					sampler2D _Mask;
					sampler2D _NormalMap;
					sampler2D _GrabTextureMobile;

					float _DistortFactor;
					float _ColorFactor;			

					float4 _NormalMap_ST;
					float4 _Mask_ST;
					float4 _GrabTextureMobile_TexelSize;

					v2f vert (appdata_t v)
					{
						v2f o;

						o.vertex = UnityObjectToClipPos(v.vertex);

						o.color = v.color;

						float scale = -1.0;

						o.uvgrab.xy = (float2(o.vertex.x, o.vertex.y) + o.vertex.w) * 0.5;
						o.uvgrab.zw = o.vertex.zw;

						o.uvnormal = TRANSFORM_TEX( v.texcoord, _NormalMap );
						o.uvmask = TRANSFORM_TEX(v.texcoord,_Mask);
						
						return o;
					}

					sampler2D _CameraDepthTexture;
					float _InvFade;

					half4 frag( v2f i ) : COLOR
					{
						half2 normal = UnpackNormal(tex2D( _NormalMap, i.uvnormal )).rg;
						half2 distortValue = normal * _DistortFactor * _GrabTextureMobile_TexelSize.xy * 10;
						i.uvgrab.xy = (distortValue * i.uvgrab.z) + i.uvgrab.xy;

						half4 distort = tex2Dproj( _GrabTextureMobile, UNITY_PROJ_COORD(i.uvgrab));
						half4 mask = tex2D(_Mask,i.uvmask);
						
						half4 res = distort;
						res.a = _TintColor.a * i.color.a;
						res.a = res.a * mask.a;

						return res;
					}
				ENDHLSL
			}
		}
	}
}
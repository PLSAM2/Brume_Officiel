// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Projector' with 'unity_Projector'
// Upgrade NOTE: replaced '_ProjectorClip' with 'unity_ProjectorClip'

Shader "Projector/Fog Of War" {
	Properties {
		_FogTex ("Fog Texture", 2D) = "gray" {}
		_Color ("Color", Color) = (0,0,0,0)
		_RampTex("Ramp (RGB)", 2D) = "white" {}
	}
	Subshader {
		Tags {"Queue"="Transparent"}
		Pass {
			ZWrite Off
			Blend DstColor Zero
			Offset -1, -1

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			
			struct v2f {
				float4 uvShadow : TEXCOORD0;
				UNITY_FOG_COORDS(2)
				float4 pos : SV_POSITION;
			};
			
			float4x4 unity_Projector;
			float4x4 unity_ProjectorClip;
			
			v2f vert (float4 vertex : POSITION)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (vertex);
				o.uvShadow = mul (unity_Projector, vertex);
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}


			float2 translate(float2 samplePosition, float2 offset) {
				//move samplepoint in the opposite direction that we want to move shapes in
				return samplePosition - offset;
			}

			float rectangle(float2 samplePosition, float2 halfSize) {
				float2 componentWiseEdgeDistance = abs(samplePosition) - halfSize;
				float outsideDistance = length(max(componentWiseEdgeDistance, 0));
				float insideDistance = min(max(componentWiseEdgeDistance.x, componentWiseEdgeDistance.y), 0);
				return outsideDistance + insideDistance;
			}

			float intersect(float shape1, float shape2) {
				return max(shape1, shape2);
			}

			float subtract(float base, float subtraction) {
				return intersect(base, -subtraction);
			}

			float merge(float shape1, float shape2) {
				return min(shape1, shape2);
			}

			float2 rotate(float2 samplePosition, float rotation) {
				const float PI = 3.14159;
				float angle = rotation * PI * 2 * -1;
				float sine, cosine;
				sincos(angle, sine, cosine);
				return float2(cosine * samplePosition.x + sine * samplePosition.y, cosine * samplePosition.y - sine * samplePosition.x);
			}

			float scene(float2 position) {
				float bounds = -rectangle(position, 2);

				float2 quarterPos = abs(position);

				float corner = rectangle(translate(quarterPos, 1), 0.5);
				corner = subtract(corner, rectangle(position, 1.2));

				float diamond = rectangle(rotate(position, 0.125), .5);

				float world = merge(bounds, corner);
				world = merge(world, diamond);

				return world;
			}

			#define STARTDISTANCE 0.00001
			#define MINSTEPDIST 0.02
			#define SAMPLES 32

			float traceShadows(float2 position, float2 lightPosition, float hardness) {
				float2 direction = normalize(lightPosition - position);
				float lightDistance = length(lightPosition - position);

				float lightSceneDistance = scene(lightPosition) * 0.8;

				float rayProgress = 0.0001;
				float shadow = 9999;
				for (int i = 0; i < SAMPLES; i++) {
					float sceneDist = scene(position + direction * rayProgress);

					if (sceneDist <= 0) {
						return 0;
					}
					if (rayProgress > lightDistance) {
						return saturate(shadow);
					}

					shadow = min(shadow, hardness * sceneDist / rayProgress);
					rayProgress = rayProgress + max(sceneDist, 0.02);
				}

				return 0;
			}
			
			sampler2D _FogTex;
			fixed4 _Color;
			sampler2D _RampTex;
			uniform float _Blend;
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed a2 = tex2Dproj (_FogTex, UNITY_PROJ_COORD(i.uvShadow)).a;
				fixed a1 = tex2Dproj(_RampTex, UNITY_PROJ_COORD(i.uvShadow)).b;

				fixed a = a1 * a2;
				fixed4 col = lerp(_Color, fixed4(1,1,1,1), a);

				UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(1,1,1,1));
				return col;
			}
			ENDCG
		}
	}
}

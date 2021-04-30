// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RE_Shader"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin]_Re_Albedo_Texture("Re_Albedo_Texture", 2D) = "white" {}
		_Re_Normal_Texture("Re_Normal_Texture", 2D) = "bump" {}
		_Re_Mask_Texture("Re_Mask_Texture", 2D) = "white" {}
		_WarmColor01("WarmColor01", Color) = (1,0.8811684,0.3820755,0)
		_WarmColor02("WarmColor02", Color) = (1,0.6987091,0,0)
		_lineColor("lineColor", Color) = (0.6886792,0.6886792,0.6886792,0)
		_ShadowColor("ShadowColor", Color) = (0.6886792,0.6886792,0.6886792,0)
		_Speed("Speed", Float) = 1
		_Contraste("Contraste", Float) = 0.47
		_Booster("Booster", Float) = 0.45
		_Tiling("Tiling", Vector) = (10,10,0,0)
		[Header(Noise)]_Noise_Texture("Noise_Texture", 2D) = "white" {}
		_Noise_Tiling("Noise_Tiling", Vector) = (1,1,0,0)
		_Noise_Speed("Noise_Speed", Vector) = (0,-1,0,0)
		_Noise_Smoothstep("Noise_Smoothstep", Float) = 0.5
		[Toggle(_ALPHA_ON)] _Alpha("Alpha?", Float) = 0
		_Noise_Contrast("Noise_Contrast", Float) = 1
		_Dissolve_Smoothstep("Dissolve_Smoothstep", Float) = 0.5
		_Masque_lineNoire("Masque_lineNoire", 2D) = "white" {}
		_OutlineColor("OutlineColor", Color) = (0,0,0,0)
		_OutlinePower("OutlinePower", Float) = 0
		_Dissolve_Step("Dissolve_Step", Range( 0 , 1)) = 0
		_Dissolve_StepStart("Dissolve_StepStart", Float) = 0
		_Dissolve_StepEnd("Dissolve_StepEnd", Float) = 0
		_HitRed("HitRed?", Range( 0 , 1)) = 0
		_HitRedOpacityMax("HitRedOpacityMax", Range( 0 , 1)) = 0.5
		_HitColorRed("HitColorRed", Color) = (1,0,0,0)
		_HitWhite("HitWhite?", Range( 0 , 1)) = 0
		_HitWhiteOpacityMax("HitWhiteOpacityMax", Range( 0 , 1)) = 0.5
		_HitFresnelScale("HitFresnelScale", Float) = 0
		[ASEEnd]_HitFresnelPower("HitFresnelPower", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
		
		Cull Off
		AlphaToMask Off
		HLSLINCLUDE
		#pragma target 2.0

		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha SrcColor
			ZWrite On
			ZTest LEqual
			Offset 0,0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_NEEDS_FRAG_POSITION
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma shader_feature_local _ALPHA_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Re_Normal_Texture_ST;
			float4 _ShadowColor;
			float4 _Masque_lineNoire_ST;
			float4 _lineColor;
			float4 _Re_Albedo_Texture_ST;
			float4 _Re_Mask_Texture_ST;
			float4 _WarmColor02;
			float4 _WarmColor01;
			float4 _HitColorRed;
			float4 _OutlineColor;
			float2 _Noise_Tiling;
			float2 _Noise_Speed;
			float2 _Tiling;
			float _OutlinePower;
			float _Noise_Contrast;
			float _Dissolve_Smoothstep;
			float _Noise_Smoothstep;
			float _Dissolve_Step;
			float _Dissolve_StepEnd;
			float _Dissolve_StepStart;
			float _HitRed;
			float _HitRedOpacityMax;
			float _Contraste;
			float _HitWhite;
			float _HitWhiteOpacityMax;
			float _HitFresnelPower;
			float _Speed;
			float _Booster;
			float _HitFresnelScale;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Re_Normal_Texture;
			sampler2D _Masque_lineNoire;
			sampler2D _Re_Albedo_Texture;
			sampler2D _Re_Mask_Texture;
			sampler2D _Noise_Texture;


			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord4.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord5.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord6.xyz = ase_worldBitangent;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				o.ase_texcoord7 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor( positionCS.z );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif
				float2 uv_Re_Normal_Texture = IN.ase_texcoord3.xy * _Re_Normal_Texture_ST.xy + _Re_Normal_Texture_ST.zw;
				float3 ase_worldTangent = IN.ase_texcoord4.xyz;
				float3 ase_worldNormal = IN.ase_texcoord5.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord6.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal17 = UnpackNormalScale( tex2D( _Re_Normal_Texture, uv_Re_Normal_Texture ), 1.0f );
				float3 worldNormal17 = float3(dot(tanToWorld0,tanNormal17), dot(tanToWorld1,tanNormal17), dot(tanToWorld2,tanNormal17));
				float dotResult15 = dot( worldNormal17 , SafeNormalize(_MainLightPosition.xyz) );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir19 = ( dotResult15 * ase_lightAtten );
				float temp_output_22_0 = step( normal_LightDir19 , 0.0 );
				float2 uv_Masque_lineNoire = IN.ase_texcoord3.xy * _Masque_lineNoire_ST.xy + _Masque_lineNoire_ST.zw;
				float2 uv_Re_Albedo_Texture = IN.ase_texcoord3.xy * _Re_Albedo_Texture_ST.xy + _Re_Albedo_Texture_ST.zw;
				float4 blendOpSrc120 = ( tex2D( _Masque_lineNoire, uv_Masque_lineNoire ) * _lineColor );
				float4 blendOpDest120 = tex2D( _Re_Albedo_Texture, uv_Re_Albedo_Texture );
				float2 uv_Re_Mask_Texture = IN.ase_texcoord3.xy * _Re_Mask_Texture_ST.xy + _Re_Mask_Texture_ST.zw;
				float4 transform53 = mul(GetObjectToWorldMatrix(),float4( IN.ase_texcoord7.xyz , 0.0 ));
				float mulTime38 = _TimeParameters.x * _Speed;
				float2 panner36 = ( mulTime38 * float2( 0,-1 ) + float2( 0,0 ));
				float2 texCoord13 = IN.ase_texcoord3.xy * _Tiling + panner36;
				float simplePerlin2D42 = snoise( texCoord13 );
				simplePerlin2D42 = simplePerlin2D42*0.5 + 0.5;
				float4 temp_cast_1 = (simplePerlin2D42).xxxx;
				float4 lerpResult48 = lerp( _WarmColor02 , _WarmColor01 , ( transform53.y + ( CalculateContrast(_Contraste,temp_cast_1) + _Booster ) ));
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float fresnelNdotV124 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode124 = ( 0.0 + _OutlinePower * pow( 1.0 - fresnelNdotV124, 5.0 ) );
				float fresnelNdotV154 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode154 = ( 0.0 + _HitFresnelScale * pow( 1.0 - fresnelNdotV154, _HitFresnelPower ) );
				float temp_output_153_0 = ( 1.0 - fresnelNode154 );
				float4 temp_cast_2 = (temp_output_153_0).xxxx;
				float lerpResult146 = lerp( 0.0 , _HitWhiteOpacityMax , _HitWhite);
				float4 lerpResult142 = lerp( ( ( ( ( 1.0 - temp_output_22_0 ) + ( temp_output_22_0 * _ShadowColor ) ) * ( ( saturate( ( blendOpDest120 - blendOpSrc120 ) )) + ( tex2D( _Re_Mask_Texture, uv_Re_Mask_Texture ) * pow( lerpResult48 , 1.0 ) ) ) ) + ( fresnelNode124 * _OutlineColor ) ) , temp_cast_2 , lerpResult146);
				float lerpResult148 = lerp( 0.0 , _HitRedOpacityMax , _HitRed);
				float4 lerpResult140 = lerp( lerpResult142 , ( _HitColorRed * temp_output_153_0 ) , lerpResult148);
				
				float lerpResult129 = lerp( _Dissolve_StepStart , _Dissolve_StepEnd , _Dissolve_Step);
				float temp_output_100_0 = ( _Dissolve_Smoothstep + lerpResult129 );
				float3 worldToObj128 = mul( GetWorldToObjectMatrix(), float4( WorldPosition, 1 ) ).xyz;
				float dotResult101 = dot( worldToObj128 , float3(0,1,0) );
				float smoothstepResult106 = smoothstep( ( lerpResult129 + _Noise_Smoothstep ) , ( temp_output_100_0 + _Noise_Smoothstep ) , dotResult101);
				float smoothstepResult103 = smoothstep( lerpResult129 , temp_output_100_0 , dotResult101);
				float3 objToWorld69 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord7.xyz, 1 ) ).xyz;
				float2 appendResult75 = (float2(objToWorld69.x , objToWorld69.y));
				float3 temp_cast_4 = (0.05).xxx;
				float3 break70 = ( abs( ase_worldNormal ) - temp_cast_4 );
				float YMask80 = break70.y;
				float lerpResult89 = lerp( 0.0 , tex2D( _Noise_Texture, ( appendResult75 * _Noise_Tiling ) ).r , YMask80);
				float3 objToWorld61 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord7.xyz, 1 ) ).xyz;
				float2 appendResult63 = (float2(objToWorld61.z , objToWorld61.y));
				float2 panner74 = ( 1.0 * _Time.y * _Noise_Speed + ( appendResult63 * _Noise_Tiling ));
				float XMask76 = break70.x;
				float lerpResult84 = lerp( 0.0 , tex2D( _Noise_Texture, panner74 ).r , XMask76);
				float3 objToWorld59 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord7.xyz, 1 ) ).xyz;
				float2 appendResult65 = (float2(objToWorld59.x , objToWorld59.y));
				float2 panner77 = ( 1.0 * _Time.y * _Noise_Speed + ( _Noise_Tiling * appendResult65 ));
				float ZMask73 = break70.z;
				float lerpResult86 = lerp( 0.0 , tex2D( _Noise_Texture, panner77 ).r , ZMask73);
				float4 temp_cast_5 = (saturate( ( lerpResult89 + ( lerpResult84 + lerpResult86 ) ) )).xxxx;
				float4 UpDissolve94 = CalculateContrast(_Noise_Contrast,temp_cast_5);
				float4 temp_cast_6 = (1.0).xxxx;
				float Alpha112 = step( ( smoothstepResult106 + ( smoothstepResult103 * UpDissolve94 ) ) , temp_cast_6 ).r;
				#ifdef _ALPHA_ON
				float staticSwitch134 = Alpha112;
				#else
				float staticSwitch134 = 1.0;
				#endif
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = lerpResult140.rgb;
				float Alpha = staticSwitch134;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif

				return half4( Color, Alpha );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ALPHA_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Re_Normal_Texture_ST;
			float4 _ShadowColor;
			float4 _Masque_lineNoire_ST;
			float4 _lineColor;
			float4 _Re_Albedo_Texture_ST;
			float4 _Re_Mask_Texture_ST;
			float4 _WarmColor02;
			float4 _WarmColor01;
			float4 _HitColorRed;
			float4 _OutlineColor;
			float2 _Noise_Tiling;
			float2 _Noise_Speed;
			float2 _Tiling;
			float _OutlinePower;
			float _Noise_Contrast;
			float _Dissolve_Smoothstep;
			float _Noise_Smoothstep;
			float _Dissolve_Step;
			float _Dissolve_StepEnd;
			float _Dissolve_StepStart;
			float _HitRed;
			float _HitRedOpacityMax;
			float _Contraste;
			float _HitWhite;
			float _HitWhiteOpacityMax;
			float _HitFresnelPower;
			float _Speed;
			float _Booster;
			float _HitFresnelScale;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Noise_Texture;


			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				
				o.ase_texcoord2 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir( v.ase_normal );

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = clipPos;

				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float lerpResult129 = lerp( _Dissolve_StepStart , _Dissolve_StepEnd , _Dissolve_Step);
				float temp_output_100_0 = ( _Dissolve_Smoothstep + lerpResult129 );
				float3 worldToObj128 = mul( GetWorldToObjectMatrix(), float4( WorldPosition, 1 ) ).xyz;
				float dotResult101 = dot( worldToObj128 , float3(0,1,0) );
				float smoothstepResult106 = smoothstep( ( lerpResult129 + _Noise_Smoothstep ) , ( temp_output_100_0 + _Noise_Smoothstep ) , dotResult101);
				float smoothstepResult103 = smoothstep( lerpResult129 , temp_output_100_0 , dotResult101);
				float3 objToWorld69 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord2.xyz, 1 ) ).xyz;
				float2 appendResult75 = (float2(objToWorld69.x , objToWorld69.y));
				float3 ase_worldNormal = IN.ase_texcoord3.xyz;
				float3 temp_cast_0 = (0.05).xxx;
				float3 break70 = ( abs( ase_worldNormal ) - temp_cast_0 );
				float YMask80 = break70.y;
				float lerpResult89 = lerp( 0.0 , tex2D( _Noise_Texture, ( appendResult75 * _Noise_Tiling ) ).r , YMask80);
				float3 objToWorld61 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord2.xyz, 1 ) ).xyz;
				float2 appendResult63 = (float2(objToWorld61.z , objToWorld61.y));
				float2 panner74 = ( 1.0 * _Time.y * _Noise_Speed + ( appendResult63 * _Noise_Tiling ));
				float XMask76 = break70.x;
				float lerpResult84 = lerp( 0.0 , tex2D( _Noise_Texture, panner74 ).r , XMask76);
				float3 objToWorld59 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord2.xyz, 1 ) ).xyz;
				float2 appendResult65 = (float2(objToWorld59.x , objToWorld59.y));
				float2 panner77 = ( 1.0 * _Time.y * _Noise_Speed + ( _Noise_Tiling * appendResult65 ));
				float ZMask73 = break70.z;
				float lerpResult86 = lerp( 0.0 , tex2D( _Noise_Texture, panner77 ).r , ZMask73);
				float4 temp_cast_1 = (saturate( ( lerpResult89 + ( lerpResult84 + lerpResult86 ) ) )).xxxx;
				float4 UpDissolve94 = CalculateContrast(_Noise_Contrast,temp_cast_1);
				float4 temp_cast_2 = (1.0).xxxx;
				float Alpha112 = step( ( smoothstepResult106 + ( smoothstepResult103 * UpDissolve94 ) ) , temp_cast_2 ).r;
				#ifdef _ALPHA_ON
				float staticSwitch134 = Alpha112;
				#else
				float staticSwitch134 = 1.0;
				#endif
				
				float Alpha = staticSwitch134;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_POSITION
			#pragma shader_feature_local _ALPHA_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Re_Normal_Texture_ST;
			float4 _ShadowColor;
			float4 _Masque_lineNoire_ST;
			float4 _lineColor;
			float4 _Re_Albedo_Texture_ST;
			float4 _Re_Mask_Texture_ST;
			float4 _WarmColor02;
			float4 _WarmColor01;
			float4 _HitColorRed;
			float4 _OutlineColor;
			float2 _Noise_Tiling;
			float2 _Noise_Speed;
			float2 _Tiling;
			float _OutlinePower;
			float _Noise_Contrast;
			float _Dissolve_Smoothstep;
			float _Noise_Smoothstep;
			float _Dissolve_Step;
			float _Dissolve_StepEnd;
			float _Dissolve_StepStart;
			float _HitRed;
			float _HitRedOpacityMax;
			float _Contraste;
			float _HitWhite;
			float _HitWhiteOpacityMax;
			float _HitFresnelPower;
			float _Speed;
			float _Booster;
			float _HitFresnelScale;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Noise_Texture;


			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				
				o.ase_texcoord2 = v.vertex;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = TransformWorldToHClip( positionWS );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float lerpResult129 = lerp( _Dissolve_StepStart , _Dissolve_StepEnd , _Dissolve_Step);
				float temp_output_100_0 = ( _Dissolve_Smoothstep + lerpResult129 );
				float3 worldToObj128 = mul( GetWorldToObjectMatrix(), float4( WorldPosition, 1 ) ).xyz;
				float dotResult101 = dot( worldToObj128 , float3(0,1,0) );
				float smoothstepResult106 = smoothstep( ( lerpResult129 + _Noise_Smoothstep ) , ( temp_output_100_0 + _Noise_Smoothstep ) , dotResult101);
				float smoothstepResult103 = smoothstep( lerpResult129 , temp_output_100_0 , dotResult101);
				float3 objToWorld69 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord2.xyz, 1 ) ).xyz;
				float2 appendResult75 = (float2(objToWorld69.x , objToWorld69.y));
				float3 ase_worldNormal = IN.ase_texcoord3.xyz;
				float3 temp_cast_0 = (0.05).xxx;
				float3 break70 = ( abs( ase_worldNormal ) - temp_cast_0 );
				float YMask80 = break70.y;
				float lerpResult89 = lerp( 0.0 , tex2D( _Noise_Texture, ( appendResult75 * _Noise_Tiling ) ).r , YMask80);
				float3 objToWorld61 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord2.xyz, 1 ) ).xyz;
				float2 appendResult63 = (float2(objToWorld61.z , objToWorld61.y));
				float2 panner74 = ( 1.0 * _Time.y * _Noise_Speed + ( appendResult63 * _Noise_Tiling ));
				float XMask76 = break70.x;
				float lerpResult84 = lerp( 0.0 , tex2D( _Noise_Texture, panner74 ).r , XMask76);
				float3 objToWorld59 = mul( GetObjectToWorldMatrix(), float4( IN.ase_texcoord2.xyz, 1 ) ).xyz;
				float2 appendResult65 = (float2(objToWorld59.x , objToWorld59.y));
				float2 panner77 = ( 1.0 * _Time.y * _Noise_Speed + ( _Noise_Tiling * appendResult65 ));
				float ZMask73 = break70.z;
				float lerpResult86 = lerp( 0.0 , tex2D( _Noise_Texture, panner77 ).r , ZMask73);
				float4 temp_cast_1 = (saturate( ( lerpResult89 + ( lerpResult84 + lerpResult86 ) ) )).xxxx;
				float4 UpDissolve94 = CalculateContrast(_Noise_Contrast,temp_cast_1);
				float4 temp_cast_2 = (1.0).xxxx;
				float Alpha112 = step( ( smoothstepResult106 + ( smoothstepResult103 * UpDissolve94 ) ) , temp_cast_2 ).r;
				#ifdef _ALPHA_ON
				float staticSwitch134 = Alpha112;
				#else
				float staticSwitch134 = 1.0;
				#endif
				
				float Alpha = staticSwitch134;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

	
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18707
1920;0;1920;1019;2162.626;708.8663;1.616665;True;False
Node;AmplifyShaderEditor.CommentaryNode;55;-6414.602,3170.435;Inherit;False;4510.561;1831.559;Comment;39;80;94;93;91;92;90;88;89;86;84;85;87;81;79;83;82;78;73;75;74;76;77;72;71;68;69;70;67;65;66;64;63;62;61;60;59;57;56;58;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;57;-4862.841,3856.533;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;56;-6364.602,3972.592;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;58;-4867.144,4431.886;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;62;-6091.474,3973.201;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TransformPositionNode;61;-4658.208,3851.637;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;60;-5827.403,4083.792;Inherit;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;False;0.05;0.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;59;-4662.508,4426.991;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PosVertexDataNode;67;-4873.619,3402.836;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;66;-4467.902,4109.949;Inherit;True;Property;_Noise_Tiling;Noise_Tiling;12;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.DynamicAppendNode;65;-4425.056,4455.978;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;63;-4420.753,3880.623;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;64;-5692.403,3972.794;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-4258.754,3856.623;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;70;-5493.474,3974.201;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-4263.057,4431.978;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;72;-4135.026,4222.481;Inherit;False;Property;_Noise_Speed;Noise_Speed;13;0;Create;True;0;0;False;0;False;0,-1;0,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TransformPositionNode;69;-4668.984,3397.94;Inherit;False;Object;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;77;-3979.725,4431.169;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-5279.521,3682.771;Inherit;True;XMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;74;-3975.424,3855.814;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;75;-4431.531,3426.926;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-5278.087,4124.914;Inherit;True;ZMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-3527.038,4084.34;Inherit;True;76;XMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;78;-3731.672,4401.297;Inherit;True;Property;_Noise_Texture;Noise_Texture;11;0;Create;True;0;0;False;1;Header(Noise);False;-1;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;80;-5277.619,3905.645;Inherit;True;YMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-4269.532,3402.926;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;-3531.296,4738.204;Inherit;True;73;ZMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;82;-3740.605,3864.033;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;78;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;87;-3745.876,3294.713;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;78;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;84;-3283.026,3866.093;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-3532.308,3515.021;Inherit;True;80;YMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;86;-3287.283,4520.954;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-2939.732,4164.752;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;89;-3288.297,3296.773;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-2783.714,3827.332;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;54;-6417.628,2102.114;Inherit;False;3125.568;1052.875;Alpha;22;100;95;112;110;109;107;111;106;105;103;108;104;102;101;99;97;128;129;98;130;131;132;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-5890.977,2963.424;Inherit;False;Property;_Dissolve_StepEnd;Dissolve_StepEnd;23;0;Create;True;0;0;False;0;False;0;-10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-5889.977,2888.424;Inherit;False;Property;_Dissolve_StepStart;Dissolve_StepStart;22;0;Create;True;0;0;False;0;False;0;-6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-5998.977,3046.424;Inherit;False;Property;_Dissolve_Step;Dissolve_Step;21;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;98;-6360.807,2277.754;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;91;-2693.853,4396.729;Inherit;False;Property;_Noise_Contrast;Noise_Contrast;16;0;Create;True;0;0;False;0;False;1;-0.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;92;-2682.777,4164.972;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;97;-6068.706,2679.245;Inherit;False;Constant;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;95;-5733.292,2723.911;Inherit;False;Property;_Dissolve_Smoothstep;Dissolve_Smoothstep;17;0;Create;True;0;0;False;0;False;0.5;5.92;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;128;-6133.593,2272.619;Inherit;True;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleContrastOpNode;93;-2467.683,4168.048;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;129;-5643.159,2943.543;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;94;-2184.754,4162.413;Inherit;False;UpDissolve;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;100;-5386.296,2919.911;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;101;-5879.052,2458.003;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-5648.274,2170.269;Inherit;False;Property;_Noise_Smoothstep;Noise_Smoothstep;14;0;Create;True;0;0;False;0;False;0.5;3.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;103;-5108.749,2453.969;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-5287.701,2345.233;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;108;-4932.2,2704.048;Inherit;False;94;UpDissolve;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;104;-5290.809,2229.382;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-4701.047,2453.693;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;106;-5113.155,2168.292;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-4442.287,2152.114;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-4227.098,2279.365;Inherit;False;Constant;_Float6;Float 6;4;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;109;-4051.099,2155.365;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;110;-3801.096,2157.365;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-3533.72,2165.425;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;121;-5909.061,-483.3108;Inherit;False;1048.055;625.259;;5;114;115;120;119;5;LineNoir /Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;45;-6426.029,912.2037;Inherit;False;2087.302;718.7039;Comment;10;39;13;32;42;31;36;38;40;44;35;Noise;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;113;-570.1212,665.1882;Inherit;False;112;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-538.2376,535.9274;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;46;-4090.079,345.5245;Inherit;False;Property;_WarmColor02;WarmColor02;4;0;Create;True;0;0;False;0;False;1,0.6987091,0,0;1,0.6980392,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-3446.577,-853.4073;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;49;-3241.195,737.5428;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;39;-6060.028,962.2037;Inherit;True;Property;_Tiling;Tiling;10;0;Create;True;0;0;False;0;False;10,10;10,10;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;42;-5473.549,1118.01;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;31;-5019.851,1145.05;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-2616.783,391.7998;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-1619.828,302.5049;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;120;-5081.006,-225.4994;Inherit;False;Subtract;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2853.965,714.1976;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;14;-5095.564,-885.1879;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;22;-3689.409,-1098.058;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;13;-5744.174,1167.205;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;48;-3589.379,736.6242;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;23;-3421.93,-1087.362;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;16;-5383.566,-1013.188;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;148;-436.5067,208.9938;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-770.3796,348.7045;Inherit;False;Property;_HitRed;HitRed?;24;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-1287.193,263.1358;Inherit;False;Property;_HitWhiteOpacityMax;HitWhiteOpacityMax;28;0;Create;True;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-1556.365,-113.6343;Inherit;False;Property;_HitFresnelScale;HitFresnelScale;29;0;Create;True;0;0;False;0;False;0;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;145;-1286.88,354.2045;Inherit;False;Property;_HitWhite;HitWhite?;27;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-5374.421,-283.3088;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;6;-3423.123,419.0755;Inherit;True;Property;_Re_Mask_Texture;Re_Mask_Texture;2;0;Create;True;0;0;False;0;False;-1;33f424158318f604fa25072e875227fe;ec6ff471d11fe9b40af132f114b879e7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;36;-5944.296,1277.894;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;123;-2052.902,870.7545;Inherit;False;Property;_OutlineColor;OutlineColor;19;0;Create;True;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;146;-955.5287,206.9977;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;115;-5813.409,-246.4632;Inherit;False;Property;_lineColor;lineColor;5;0;Create;True;0;0;False;0;False;0.6886792,0.6886792,0.6886792,0;0.3301883,0.3301883,0.3301883,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;-5859.061,-88.05172;Inherit;True;Property;_Re_Albedo_Texture;Re_Albedo_Texture;0;0;Create;True;0;0;False;0;False;-1;None;39afe6fb610212b4db0a50df27506e27;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;35;-4573.723,1137.435;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.754717;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2239.776,-22.04195;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;155;-1554.365,-33.63443;Inherit;False;Property;_HitFresnelPower;HitFresnelPower;30;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-5829.705,-433.3108;Inherit;True;Property;_Masque_lineNoire;Masque_lineNoire;18;0;Create;True;0;0;False;0;False;-1;59674542ee940b94a90f700ccaa3e47f;59674542ee940b94a90f700ccaa3e47f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-4823.566,-1157.186;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;124;-2000.923,669.4455;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;125;-1379.268,119.4997;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-6376.028,1312.204;Inherit;True;Property;_Speed;Speed;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;50;-5549.051,558.7696;Inherit;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-4190.419,832.5738;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;29;-3788.927,-681.0355;Inherit;False;Property;_ShadowColor;ShadowColor;6;0;Create;True;0;0;False;0;False;0.6886792,0.6886792,0.6886792,0;0.5686274,0.5686274,0.5686274,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-3192.35,-846.2272;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-5400.25,1411.782;Inherit;False;Property;_Contraste;Contraste;8;0;Create;True;0;0;False;0;False;0.47;1.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-2306.67,719.7225;Inherit;False;Property;_OutlinePower;OutlinePower;20;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-4789.045,1371.907;Inherit;True;Property;_Booster;Booster;9;0;Create;True;0;0;False;0;False;0.45;-1.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;38;-6155.028,1315.204;Inherit;True;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;21;-5837.538,-1167.748;Inherit;True;Property;_Re_Normal_Texture;Re_Normal_Texture;1;0;Create;True;0;0;False;0;False;-1;ac6ce669204879440af8e1ebaf48eeba;ac6ce669204879440af8e1ebaf48eeba;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;15;-5111.564,-1157.186;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-4085.909,529.5059;Inherit;False;Property;_WarmColor01;WarmColor01;3;0;Create;True;0;0;False;0;False;1,0.8811684,0.3820755,0;1,0.8823529,0.3803914,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;154;-1312.068,-140.1388;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;153;-976.743,-140.4458;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;53;-5210.142,554.8813;Inherit;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-489.3651,-164.6343;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;152;-740.9421,-340.3035;Inherit;False;Property;_HitColorRed;HitColorRed;26;0;Create;True;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;19;-3981.34,-1143.228;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;134;-358.2375,535.9274;Inherit;False;Property;_Alpha;Alpha?;15;0;Create;True;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;140;-247.5802,119.4748;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;142;-743.0801,117.9748;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-768.1707,265.1317;Inherit;False;Property;_HitRedOpacityMax;HitRedOpacityMax;25;0;Create;True;0;0;False;0;False;0.5;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;17;-5367.566,-1157.186;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-9.876155,117.5563;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;RE_Shader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;2;5;False;-1;10;False;-1;1;5;False;-1;3;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;0;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;1;  Blend;0;Two Sided;0;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-270.6557,101.9935;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;62;0;56;0
WireConnection;61;0;57;0
WireConnection;59;0;58;0
WireConnection;65;0;59;1
WireConnection;65;1;59;2
WireConnection;63;0;61;3
WireConnection;63;1;61;2
WireConnection;64;0;62;0
WireConnection;64;1;60;0
WireConnection;68;0;63;0
WireConnection;68;1;66;0
WireConnection;70;0;64;0
WireConnection;71;0;66;0
WireConnection;71;1;65;0
WireConnection;69;0;67;0
WireConnection;77;0;71;0
WireConnection;77;2;72;0
WireConnection;76;0;70;0
WireConnection;74;0;68;0
WireConnection;74;2;72;0
WireConnection;75;0;69;1
WireConnection;75;1;69;2
WireConnection;73;0;70;2
WireConnection;78;1;77;0
WireConnection;80;0;70;1
WireConnection;79;0;75;0
WireConnection;79;1;66;0
WireConnection;82;1;74;0
WireConnection;87;1;79;0
WireConnection;84;1;82;1
WireConnection;84;2;83;0
WireConnection;86;1;78;1
WireConnection;86;2;81;0
WireConnection;88;0;84;0
WireConnection;88;1;86;0
WireConnection;89;1;87;1
WireConnection;89;2;85;0
WireConnection;90;0;89;0
WireConnection;90;1;88;0
WireConnection;92;0;90;0
WireConnection;128;0;98;0
WireConnection;93;1;92;0
WireConnection;93;0;91;0
WireConnection;129;0;131;0
WireConnection;129;1;132;0
WireConnection;129;2;130;0
WireConnection;94;0;93;0
WireConnection;100;0;95;0
WireConnection;100;1;129;0
WireConnection;101;0;128;0
WireConnection;101;1;97;0
WireConnection;103;0;101;0
WireConnection;103;1;129;0
WireConnection;103;2;100;0
WireConnection;102;0;100;0
WireConnection;102;1;99;0
WireConnection;104;0;129;0
WireConnection;104;1;99;0
WireConnection;105;0;103;0
WireConnection;105;1;108;0
WireConnection;106;0;101;0
WireConnection;106;1;104;0
WireConnection;106;2;102;0
WireConnection;107;0;106;0
WireConnection;107;1;105;0
WireConnection;109;0;107;0
WireConnection;109;1;111;0
WireConnection;110;0;109;0
WireConnection;112;0;110;0
WireConnection;28;0;22;0
WireConnection;28;1;29;0
WireConnection;49;0;48;0
WireConnection;42;0;13;0
WireConnection;31;1;42;0
WireConnection;31;0;32;0
WireConnection;8;0;120;0
WireConnection;8;1;11;0
WireConnection;126;0;124;0
WireConnection;126;1;123;0
WireConnection;120;0;119;0
WireConnection;120;1;5;0
WireConnection;11;0;6;0
WireConnection;11;1;49;0
WireConnection;22;0;19;0
WireConnection;13;0;39;0
WireConnection;13;1;36;0
WireConnection;48;0;46;0
WireConnection;48;1;10;0
WireConnection;48;2;51;0
WireConnection;23;0;22;0
WireConnection;148;1;150;0
WireConnection;148;2;149;0
WireConnection;119;0;114;0
WireConnection;119;1;115;0
WireConnection;36;1;38;0
WireConnection;146;1;147;0
WireConnection;146;2;145;0
WireConnection;35;0;31;0
WireConnection;35;1;44;0
WireConnection;25;0;30;0
WireConnection;25;1;8;0
WireConnection;20;0;15;0
WireConnection;20;1;14;0
WireConnection;124;2;122;0
WireConnection;125;0;25;0
WireConnection;125;1;126;0
WireConnection;51;0;53;2
WireConnection;51;1;35;0
WireConnection;30;0;23;0
WireConnection;30;1;28;0
WireConnection;38;0;40;0
WireConnection;15;0;17;0
WireConnection;15;1;16;0
WireConnection;154;2;156;0
WireConnection;154;3;155;0
WireConnection;153;0;154;0
WireConnection;53;0;50;0
WireConnection;151;0;152;0
WireConnection;151;1;153;0
WireConnection;19;0;20;0
WireConnection;134;1;133;0
WireConnection;134;0;113;0
WireConnection;140;0;142;0
WireConnection;140;1;151;0
WireConnection;140;2;148;0
WireConnection;142;0;125;0
WireConnection;142;1;153;0
WireConnection;142;2;146;0
WireConnection;17;0;21;0
WireConnection;1;2;140;0
WireConnection;1;3;134;0
ASEEND*/
//CHKSM=1D74B592AA87AFFE8049AD824E1C9058BEC9EFD2
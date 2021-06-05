// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TerrainMaterialShader"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Header(OutInBrume)]_Out_or_InBrume("Out_or_InBrume?", Range( 0 , 1)) = 0
		[Header(TerrainMask)]_TerrainMask_TextureSampler1("TerrainMask_TextureSampler1", 2D) = "white" {}
		[Header(TerrainMask)]_TerrainMask_TextureSampler2("TerrainMask_TextureSampler2", 2D) = "white" {}
		[Header(Debug)]_LightDebug("LightDebug", Range( 0 , 1)) = 0
		_NormalDebug("NormalDebug", Range( 0 , 1)) = 0
		_GrayscaleDebug("GrayscaleDebug", Range( 0 , 1)) = 0
		_DebugVertexPaint("DebugVertexPaint", Range( 0 , 1)) = 1
		_DebugTextureArray("DebugTextureArray", 2DArray) = "white" {}
		_DebugTextureTiling("DebugTextureTiling", Float) = 10
		[Header(Shadow and Noise)]_ShadowNoise("ShadowNoise", 2D) = "white" {}
		_ScreenBasedShadowNoise("ScreenBasedShadowNoise?", Range( 0 , 1)) = 0
		_ShadowNoisePanner("ShadowNoisePanner", Vector) = (0.01,0,0,0)
		_StepShadow("StepShadow", Float) = 0.1
		_StepAttenuation("StepAttenuation", Float) = -0.07
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		_EdgeShadowColor("EdgeShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		_Noise_Tiling("Noise_Tiling", Float) = 1
		[Header(Texture 1 VertexPaintBlack)]_TA_1_Textures_and_Grunges("TA_1_Textures_and_Grunges", 2DArray) = "white" {}
		_T1_ColorCorrection("T1_ColorCorrection", Color) = (1,1,1,0)
		_T1_Albedo_ProceduralTiling("T1_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T1_Albedo_Tiling("T1_Albedo_Tiling", Float) = 1
		[Header(T1 Animated Grunge)]_T1_AnimatedGrunge("T1_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T1_IsGrungeAnimated("T1_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T1_AnimatedGrunge_ScreenBased("T1_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T1_AnimatedGrunge_Tiling("T1_AnimatedGrunge_Tiling", Float) = 1
		_T1_AnimatedGrunge_Flipbook_Columns("T1_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T1_AnimatedGrunge_Flipbook_Rows("T1_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T1_AnimatedGrunge_Flipbook_Speed("T1_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T1_AnimatedGrunge_Contrast("T1_AnimatedGrunge_Contrast", Float) = 1.58
		_T1_AnimatedGrunge_Multiply("T1_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 2 VertexPaintRed)]_TA_2_Textures_and_Grunges("TA_2_Textures_and_Grunges", 2DArray) = "white" {}
		_T2_ColorCorrection("T2_ColorCorrection", Color) = (1,1,1,0)
		_T2_Albedo_Contrast("T2_Albedo_Contrast", Float) = 0
		_T2_Albedo_ProceduralTiling("T2_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T2_Albedo_Tiling("T2_Albedo_Tiling", Float) = 1
		[Header(T2 Animated Grunge)]_T2_AnimatedGrunge("T2_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T2_IsGrungeAnimated("T2_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T2_AnimatedGrunge_ScreenBased("T2_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T2_AnimatedGrunge_Tiling("T2_AnimatedGrunge_Tiling", Float) = 1
		_T2_AnimatedGrunge_Flipbook_Columns("T2_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T2_AnimatedGrunge_Flipbook_Rows("T2_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T2_AnimatedGrunge_Flipbook_Speed("T2_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T2_AnimatedGrunge_Contrast("T2_AnimatedGrunge_Contrast", Float) = 1.58
		_T2_AnimatedGrunge_Multiply("T2_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 3 VertexPaintGreen)]_TA_3_Textures_and_Grunges("TA_3_Textures_and_Grunges", 2DArray) = "white" {}
		_T3_ColorCorrection("T3_ColorCorrection", Color) = (1,1,1,0)
		_T3_Albedo_ProceduralTiling("T3_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T3_Albedo_Tiling("T3_Albedo_Tiling", Float) = 1
		[Header(T3 Animated Grunge)]_T3_AnimatedGrunge("T3_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T3_IsGrungeAnimated("T3_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T3_AnimatedGrunge_ScreenBased("T3_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T3_AnimatedGrunge_Tiling("T3_AnimatedGrunge_Tiling", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Columns("T3_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Rows("T3_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Speed("T3_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T3_AnimatedGrunge_Contrast("T3_AnimatedGrunge_Contrast", Float) = 1.58
		_T3_AnimatedGrunge_Multiply("T3_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 4 VertexPaintBlue)]_TA_4_Textures_and_Grunges("TA_4_Textures_and_Grunges", 2DArray) = "white" {}
		_T4_ColorCorrection("T4_ColorCorrection", Color) = (1,1,1,0)
		_T4_Albedo_ProceduralTiling("T4_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T4_Albedo_Tiling("T4_Albedo_Tiling", Float) = 1
		[Header(T4 Animated Grunge)]_T4_AnimatedGrunge("T4_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T4_IsGrungeAnimated("T4_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T4_AnimatedGrunge_ScreenBased("T4_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T4_AnimatedGrunge_Tiling("T4_AnimatedGrunge_Tiling", Float) = 1
		_T4_AnimatedGrunge_Flipbook_Columns("T4_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T4_AnimatedGrunge_Flipbook_Rows("T4_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T4_AnimatedGrunge_Flipbook_Speed("T4_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T4_AnimatedGrunge_Contrast("T4_AnimatedGrunge_Contrast", Float) = 1.58
		_T4_AnimatedGrunge_Multiply("T4_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 5 VertexPaintRed)]_TA_5_Textures_and_Grunges("TA_5_Textures_and_Grunges", 2DArray) = "white" {}
		_T5_ColorCorrection("T5_ColorCorrection", Color) = (1,1,1,0)
		_T5_Albedo_ProceduralTiling("T5_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T5_Albedo_Tiling("T5_Albedo_Tiling", Float) = 1
		[Header(T5 Animated Grunge)]_T5_AnimatedGrunge("T5_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T5_IsGrungeAnimated("T5_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T5_AnimatedGrunge_ScreenBased("T5_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T5_AnimatedGrunge_Tiling("T5_AnimatedGrunge_Tiling", Float) = 1
		_T5_AnimatedGrunge_Flipbook_Columns("T5_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T5_AnimatedGrunge_Flipbook_Rows("T5_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T5_AnimatedGrunge_Flipbook_Speed("T5_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T5_AnimatedGrunge_Contrast("T5_AnimatedGrunge_Contrast", Float) = 1.58
		_T5_AnimatedGrunge_Multiply("T5_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 6 VertexPaintGreen)]_TA_6_Textures_and_Grunges("TA_6_Textures_and_Grunges", 2DArray) = "white" {}
		_T6_ColorCorrection("T6_ColorCorrection", Color) = (1,1,1,0)
		_T6_Albedo_ProceduralTiling("T6_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T6_Albedo_Tiling("T6_Albedo_Tiling", Float) = 1
		[Header(T6 Animated Grunge)]_T6_AnimatedGrunge("T6_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T6_IsGrungeAnimated("T6_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T6_AnimatedGrunge_ScreenBased("T6_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T6_AnimatedGrunge_Tiling("T6_AnimatedGrunge_Tiling", Float) = 1
		_T6_AnimatedGrunge_Flipbook_Columns("T6_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T6_AnimatedGrunge_Flipbook_Rows("T6_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T6_AnimatedGrunge_Flipbook_Speed("T6_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T6_AnimatedGrunge_Contrast("T6_AnimatedGrunge_Contrast", Float) = 1.58
		_T6_AnimatedGrunge_Multiply("T6_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 7 VertexPaintBlue)]_TA_7_Textures_and_Grunges("TA_7_Textures_and_Grunges", 2DArray) = "white" {}
		_T7_ColorCorrection("T7_ColorCorrection", Color) = (1,1,1,0)
		_T7_Albedo_ProceduralTiling("T7_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T7_Albedo_Tiling("T7_Albedo_Tiling", Float) = 1
		[Header(T7 Animated Grunge)]_T7_AnimatedGrunge("T7_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T7_IsGrungeAnimated("T7_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T7_AnimatedGrunge_ScreenBased("T7_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T7_AnimatedGrunge_Tiling("T7_AnimatedGrunge_Tiling", Float) = 1
		_T7_AnimatedGrunge_Flipbook_Columns("T7_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T7_AnimatedGrunge_Flipbook_Rows("T7_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T7_AnimatedGrunge_Flipbook_Speed("T7_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T7_AnimatedGrunge_Contrast("T7_AnimatedGrunge_Contrast", Float) = 1.58
		_T7_AnimatedGrunge_Multiply("T7_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Fake Lights)]_FakeLights("FakeLights?", Range( 0 , 1)) = 0
		_FakeLightArrayLength("FakeLightArrayLength", Float) = 0
		_FakeLight_Color("FakeLight_Color", Color) = (1,1,1,0)
		_FakeLightStep("FakeLightStep", Range( 0 , 50)) = 0
		_FakeLightStepAttenuation("FakeLightStepAttenuation", Range( 0 , 50)) = 5
		_WaveFakeLight_Time("WaveFakeLight_Time", Float) = 1
		_WaveFakeLight_Min("WaveFakeLight_Min", Float) = 1
		[ASEEnd]_WaveFakeLight_Max("WaveFakeLight_Max", Float) = 1.1
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

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
		Cull Back
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
			
			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
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
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT


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
			float4 _ShadowColor;
			float4 _T3_ColorCorrection;
			float4 _T6_ColorCorrection;
			float4 _T5_ColorCorrection;
			float4 _T1_ColorCorrection;
			float4 _EdgeShadowColor;
			float4 _FakeLight_Color;
			float4 _T7_ColorCorrection;
			float4 _T2_ColorCorrection;
			float4 _TerrainMask_TextureSampler2_ST;
			float4 _T4_ColorCorrection;
			float4 _TerrainMask_TextureSampler1_ST;
			float2 _ShadowNoisePanner;
			float _T6_AnimatedGrunge_Multiply;
			float _T6_AnimatedGrunge_Flipbook_Columns;
			float _T6_AnimatedGrunge_Flipbook_Speed;
			float _T6_AnimatedGrunge;
			float _T6_AnimatedGrunge_Flipbook_Rows;
			float _T6_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Contrast;
			float _T5_Albedo_ProceduralTiling;
			float _T6_AnimatedGrunge_Tiling;
			float _T6_AnimatedGrunge_Contrast;
			float _T5_Albedo_Tiling;
			float _T5_AnimatedGrunge;
			float _T5_AnimatedGrunge_Multiply;
			float _T5_IsGrungeAnimated;
			float _T5_AnimatedGrunge_Flipbook_Speed;
			float _T5_AnimatedGrunge_Flipbook_Rows;
			float _T5_AnimatedGrunge_Flipbook_Columns;
			float _T6_AnimatedGrunge_ScreenBased;
			float _T6_Albedo_Tiling;
			float _T7_AnimatedGrunge_ScreenBased;
			float _T7_AnimatedGrunge_Contrast;
			float _FakeLights;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _WaveFakeLight_Max;
			float _FakeLightArrayLength;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _T6_Albedo_ProceduralTiling;
			float _StepAttenuation;
			float _T7_Albedo_ProceduralTiling;
			float _T7_Albedo_Tiling;
			float _T7_AnimatedGrunge;
			float _T7_AnimatedGrunge_Multiply;
			float _T7_IsGrungeAnimated;
			float _T7_AnimatedGrunge_Flipbook_Speed;
			float _T7_AnimatedGrunge_Flipbook_Rows;
			float _T7_AnimatedGrunge_Flipbook_Columns;
			float _T7_AnimatedGrunge_Tiling;
			float _StepShadow;
			float _T5_AnimatedGrunge_ScreenBased;
			float _T4_Albedo_ProceduralTiling;
			float _T5_AnimatedGrunge_Contrast;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_IsGrungeAnimated;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _T2_AnimatedGrunge_ScreenBased;
			float _T2_AnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Contrast;
			float _DebugVertexPaint;
			float _DebugTextureTiling;
			float _T2_AnimatedGrunge;
			float _Out_or_InBrume;
			float _T1_Albedo_ProceduralTiling;
			float _T1_Albedo_Tiling;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_AnimatedGrunge_ScreenBased;
			float _T1_AnimatedGrunge_Tiling;
			float _GrayscaleDebug;
			float _T5_AnimatedGrunge_Tiling;
			float _T2_Albedo_Contrast;
			float _T2_Albedo_ProceduralTiling;
			float _LightDebug;
			float _T4_Albedo_Tiling;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_IsGrungeAnimated;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_AnimatedGrunge_Tiling;
			float _T2_Albedo_Tiling;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_Albedo_Tiling;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _T3_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_Contrast;
			float _T3_Albedo_ProceduralTiling;
			float _NormalDebug;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D_ARRAY(_TA_1_Textures_and_Grunges);
			SAMPLER(sampler_TA_1_Textures_and_Grunges);
			TEXTURE2D_ARRAY(_DebugTextureArray);
			SAMPLER(sampler_DebugTextureArray);
			TEXTURE2D_ARRAY(_TA_2_Textures_and_Grunges);
			SAMPLER(sampler_TA_2_Textures_and_Grunges);
			sampler2D _TerrainMask_TextureSampler1;
			TEXTURE2D_ARRAY(_TA_3_Textures_and_Grunges);
			SAMPLER(sampler_TA_3_Textures_and_Grunges);
			TEXTURE2D_ARRAY(_TA_4_Textures_and_Grunges);
			SAMPLER(sampler_TA_4_Textures_and_Grunges);
			sampler2D _TerrainMask_TextureSampler2;
			TEXTURE2D_ARRAY(_TA_5_Textures_and_Grunges);
			SAMPLER(sampler_TA_5_Textures_and_Grunges);
			TEXTURE2D_ARRAY(_TA_6_Textures_and_Grunges);
			SAMPLER(sampler_TA_6_Textures_and_Grunges);
			TEXTURE2D_ARRAY(_TA_7_Textures_and_Grunges);
			SAMPLER(sampler_TA_7_Textures_and_Grunges);
			sampler2D _ShadowNoise;
			float4 FakeLightsPositionsArray[10];


			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			float CycleThroughArray1562( float In0, float3 WorldPos, float Length, float LightStep, float LightStepAttenuation )
			{
				float result=0;
				for(int i=0; i<Length;i++)
				{
					float dist = distance(WorldPos,FakeLightsPositionsArray[i]);
					result += 1 - smoothstep( LightStep, LightStepAttenuation, dist);
				}
				return result;
			}
			
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord5.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord6.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord7.xyz = ase_worldBitangent;
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;
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
				float4 temp_cast_0 = (1.0).xxxx;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_cast_1 = (_T1_AnimatedGrunge_Tiling).xx;
				float2 texCoord1463 = IN.ase_texcoord4.xy * temp_cast_1 + float2( 0,0 );
				float2 lerpResult1465 = lerp( ( (ase_screenPosNorm).xy * _T1_AnimatedGrunge_Tiling ) , texCoord1463 , _T1_AnimatedGrunge_ScreenBased);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles179 = _T1_AnimatedGrunge_Flipbook_Columns * _T1_AnimatedGrunge_Flipbook_Rows;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset179 = 1.0f / _T1_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset179 = 1.0f / _T1_AnimatedGrunge_Flipbook_Rows;
				// Speed of animation
				float fbspeed179 = _TimeParameters.x * _T1_AnimatedGrunge_Flipbook_Speed;
				// UV Tiling (col and row offset)
				float2 fbtiling179 = float2(fbcolsoffset179, fbrowsoffset179);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex179 = round( fmod( fbspeed179 + 0.0, fbtotaltiles179) );
				fbcurrenttileindex179 += ( fbcurrenttileindex179 < 0) ? fbtotaltiles179 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox179 = round ( fmod ( fbcurrenttileindex179, _T1_AnimatedGrunge_Flipbook_Columns ) );
				// Multiply Offset X by coloffset
				float fboffsetx179 = fblinearindextox179 * fbcolsoffset179;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy179 = round( fmod( ( fbcurrenttileindex179 - fblinearindextox179 ) / _T1_AnimatedGrunge_Flipbook_Columns, _T1_AnimatedGrunge_Flipbook_Rows ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy179 = (int)(_T1_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy179;
				// Multiply Offset Y by rowoffset
				float fboffsety179 = fblinearindextoy179 * fbrowsoffset179;
				// UV Offset
				float2 fboffset179 = float2(fboffsetx179, fboffsety179);
				// Flipbook UV
				half2 fbuv179 = lerpResult1465 * fbtiling179 + fboffset179;
				// *** END Flipbook UV Animation vars ***
				float2 lerpResult158 = lerp( lerpResult1465 , fbuv179 , _T1_IsGrungeAnimated);
				float3 temp_cast_2 = (SAMPLE_TEXTURE2D_ARRAY( _TA_1_Textures_and_Grunges, sampler_TA_1_Textures_and_Grunges, lerpResult158,2.0 ).r).xxx;
				float grayscale403 = Luminance(temp_cast_2);
				float4 temp_cast_3 = (grayscale403).xxxx;
				float4 lerpResult1423 = lerp( temp_cast_0 , ( CalculateContrast(_T1_AnimatedGrunge_Contrast,temp_cast_3) * _T1_AnimatedGrunge_Multiply ) , _T1_AnimatedGrunge);
				float T1_Albedo_Tiling1379 = _T1_Albedo_Tiling;
				float2 temp_cast_4 = (T1_Albedo_Tiling1379).xx;
				float2 texCoord1385 = IN.ase_texcoord4.xy * temp_cast_4 + float2( 0,0 );
				float localStochasticTiling171_g162 = ( 0.0 );
				float2 Input_UV145_g162 = texCoord1385;
				float2 UV171_g162 = Input_UV145_g162;
				float2 UV1171_g162 = float2( 0,0 );
				float2 UV2171_g162 = float2( 0,0 );
				float2 UV3171_g162 = float2( 0,0 );
				float W1171_g162 = 0.0;
				float W2171_g162 = 0.0;
				float W3171_g162 = 0.0;
				StochasticTiling( UV171_g162 , UV1171_g162 , UV2171_g162 , UV3171_g162 , W1171_g162 , W2171_g162 , W3171_g162 );
				float Input_Index184_g162 = 0.0;
				float2 temp_output_172_0_g162 = ddx( Input_UV145_g162 );
				float2 temp_output_182_0_g162 = ddy( Input_UV145_g162 );
				float4 Output_2DArray294_g162 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures_and_Grunges, sampler_TA_1_Textures_and_Grunges, UV1171_g162,Input_Index184_g162, temp_output_172_0_g162, temp_output_182_0_g162 ) * W1171_g162 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures_and_Grunges, sampler_TA_1_Textures_and_Grunges, UV2171_g162,Input_Index184_g162, temp_output_172_0_g162, temp_output_182_0_g162 ) * W2171_g162 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures_and_Grunges, sampler_TA_1_Textures_and_Grunges, UV3171_g162,Input_Index184_g162, temp_output_172_0_g162, temp_output_182_0_g162 ) * W3171_g162 ) );
				float4 lerpResult1434 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_1_Textures_and_Grunges, sampler_TA_1_Textures_and_Grunges, texCoord1385,0.0 ) , Output_2DArray294_g162 , _T1_Albedo_ProceduralTiling);
				float4 temp_output_335_0 = ( lerpResult1434 * _T1_ColorCorrection );
				float grayscale252 = dot(temp_output_335_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_6 = (grayscale252).xxxx;
				float GrayscaleDebug614 = _GrayscaleDebug;
				float4 lerpResult191 = lerp( temp_output_335_0 , temp_cast_6 , GrayscaleDebug614);
				float4 blendOpSrc190 = lerpResult1423;
				float4 blendOpDest190 = lerpResult191;
				float4 T1_RGB202 = ( saturate( ( blendOpSrc190 * blendOpDest190 ) ));
				float4 T1_End_OutBrume187 = T1_RGB202;
				float grayscale1476 = Luminance(T1_End_OutBrume187.rgb);
				float T1_End_InBrume1477 = grayscale1476;
				float4 temp_cast_8 = (T1_End_InBrume1477).xxxx;
				float Out_or_InBrume606 = _Out_or_InBrume;
				float4 lerpResult340 = lerp( T1_End_OutBrume187 , temp_cast_8 , Out_or_InBrume606);
				float4 Texture1_Final748 = lerpResult340;
				float2 temp_cast_9 = (_DebugTextureTiling).xx;
				float2 texCoord563 = IN.ase_texcoord4.xy * temp_cast_9 + float2( 0,0 );
				float4 DebugColor1488 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,0.0 );
				float DebugVertexPaint566 = _DebugVertexPaint;
				float4 lerpResult565 = lerp( Texture1_Final748 , DebugColor1488 , DebugVertexPaint566);
				float4 temp_cast_10 = (1.0).xxxx;
				float2 temp_cast_11 = (_T2_AnimatedGrunge_Tiling).xx;
				float2 texCoord1460 = IN.ase_texcoord4.xy * temp_cast_11 + float2( 0,0 );
				float2 lerpResult1461 = lerp( ( (ase_screenPosNorm).xy * _T2_AnimatedGrunge_Tiling ) , texCoord1460 , _T2_AnimatedGrunge_ScreenBased);
				float fbtotaltiles919 = _T2_AnimatedGrunge_Flipbook_Columns * _T2_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset919 = 1.0f / _T2_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset919 = 1.0f / _T2_AnimatedGrunge_Flipbook_Rows;
				float fbspeed919 = _TimeParameters.x * _T2_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling919 = float2(fbcolsoffset919, fbrowsoffset919);
				float fbcurrenttileindex919 = round( fmod( fbspeed919 + 0.0, fbtotaltiles919) );
				fbcurrenttileindex919 += ( fbcurrenttileindex919 < 0) ? fbtotaltiles919 : 0;
				float fblinearindextox919 = round ( fmod ( fbcurrenttileindex919, _T2_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx919 = fblinearindextox919 * fbcolsoffset919;
				float fblinearindextoy919 = round( fmod( ( fbcurrenttileindex919 - fblinearindextox919 ) / _T2_AnimatedGrunge_Flipbook_Columns, _T2_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy919 = (int)(_T2_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy919;
				float fboffsety919 = fblinearindextoy919 * fbrowsoffset919;
				float2 fboffset919 = float2(fboffsetx919, fboffsety919);
				half2 fbuv919 = lerpResult1461 * fbtiling919 + fboffset919;
				float2 lerpResult891 = lerp( lerpResult1461 , fbuv919 , _T2_IsGrungeAnimated);
				float3 temp_cast_12 = (SAMPLE_TEXTURE2D_ARRAY( _TA_2_Textures_and_Grunges, sampler_TA_2_Textures_and_Grunges, lerpResult891,2.0 ).r).xxx;
				float grayscale907 = Luminance(temp_cast_12);
				float4 temp_cast_13 = (grayscale907).xxxx;
				float4 lerpResult1427 = lerp( temp_cast_10 , ( CalculateContrast(_T2_AnimatedGrunge_Contrast,temp_cast_13) * _T2_AnimatedGrunge_Multiply ) , _T2_AnimatedGrunge);
				float T2_Albedo_Tiling1378 = _T2_Albedo_Tiling;
				float2 temp_cast_14 = (T2_Albedo_Tiling1378).xx;
				float2 texCoord1392 = IN.ase_texcoord4.xy * temp_cast_14 + float2( 0,0 );
				float localStochasticTiling171_g165 = ( 0.0 );
				float2 Input_UV145_g165 = texCoord1392;
				float2 UV171_g165 = Input_UV145_g165;
				float2 UV1171_g165 = float2( 0,0 );
				float2 UV2171_g165 = float2( 0,0 );
				float2 UV3171_g165 = float2( 0,0 );
				float W1171_g165 = 0.0;
				float W2171_g165 = 0.0;
				float W3171_g165 = 0.0;
				StochasticTiling( UV171_g165 , UV1171_g165 , UV2171_g165 , UV3171_g165 , W1171_g165 , W2171_g165 , W3171_g165 );
				float Input_Index184_g165 = 0.0;
				float2 temp_output_172_0_g165 = ddx( Input_UV145_g165 );
				float2 temp_output_182_0_g165 = ddy( Input_UV145_g165 );
				float4 Output_2DArray294_g165 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures_and_Grunges, sampler_TA_2_Textures_and_Grunges, UV1171_g165,Input_Index184_g165, temp_output_172_0_g165, temp_output_182_0_g165 ) * W1171_g165 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures_and_Grunges, sampler_TA_2_Textures_and_Grunges, UV2171_g165,Input_Index184_g165, temp_output_172_0_g165, temp_output_182_0_g165 ) * W2171_g165 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures_and_Grunges, sampler_TA_2_Textures_and_Grunges, UV3171_g165,Input_Index184_g165, temp_output_172_0_g165, temp_output_182_0_g165 ) * W3171_g165 ) );
				float4 lerpResult1437 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_2_Textures_and_Grunges, sampler_TA_2_Textures_and_Grunges, texCoord1392,0.0 ) , Output_2DArray294_g165 , _T2_Albedo_ProceduralTiling);
				float4 temp_output_903_0 = ( _T2_ColorCorrection * lerpResult1437 );
				float grayscale905 = dot(temp_output_903_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_16 = (grayscale905).xxxx;
				float4 lerpResult886 = lerp( CalculateContrast(_T2_Albedo_Contrast,temp_output_903_0) , temp_cast_16 , GrayscaleDebug614);
				float4 blendOpSrc912 = lerpResult1427;
				float4 blendOpDest912 = lerpResult886;
				float4 T2_RGB816 = ( saturate( ( blendOpSrc912 * blendOpDest912 ) ));
				float4 T2_End_OutBrume839 = T2_RGB816;
				float grayscale1478 = Luminance(T2_End_OutBrume839.rgb);
				float T2_End_InBrume1480 = grayscale1478;
				float4 temp_cast_18 = (T2_End_InBrume1480).xxxx;
				float4 lerpResult871 = lerp( T2_End_OutBrume839 , temp_cast_18 , Out_or_InBrume606);
				float4 Texture2_Final868 = lerpResult871;
				float4 DebugColor2477 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,1.0 );
				float4 lerpResult569 = lerp( Texture2_Final868 , DebugColor2477 , DebugVertexPaint566);
				float2 uv_TerrainMask_TextureSampler1 = IN.ase_texcoord4.xy * _TerrainMask_TextureSampler1_ST.xy + _TerrainMask_TextureSampler1_ST.zw;
				float4 tex2DNode1472 = tex2D( _TerrainMask_TextureSampler1, uv_TerrainMask_TextureSampler1 );
				float4 lerpResult11 = lerp( lerpResult565 , lerpResult569 , tex2DNode1472.r);
				float4 temp_cast_19 = (1.0).xxxx;
				float2 temp_cast_20 = (_T3_AnimatedGrunge_Tiling).xx;
				float2 texCoord1466 = IN.ase_texcoord4.xy * temp_cast_20 + float2( 0,0 );
				float2 lerpResult1468 = lerp( ( (ase_screenPosNorm).xy * _T3_AnimatedGrunge_Tiling ) , texCoord1466 , _T3_AnimatedGrunge_ScreenBased);
				float fbtotaltiles1080 = _T3_AnimatedGrunge_Flipbook_Columns * _T3_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset1080 = 1.0f / _T3_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset1080 = 1.0f / _T3_AnimatedGrunge_Flipbook_Rows;
				float fbspeed1080 = _TimeParameters.x * _T3_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling1080 = float2(fbcolsoffset1080, fbrowsoffset1080);
				float fbcurrenttileindex1080 = round( fmod( fbspeed1080 + 0.0, fbtotaltiles1080) );
				fbcurrenttileindex1080 += ( fbcurrenttileindex1080 < 0) ? fbtotaltiles1080 : 0;
				float fblinearindextox1080 = round ( fmod ( fbcurrenttileindex1080, _T3_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx1080 = fblinearindextox1080 * fbcolsoffset1080;
				float fblinearindextoy1080 = round( fmod( ( fbcurrenttileindex1080 - fblinearindextox1080 ) / _T3_AnimatedGrunge_Flipbook_Columns, _T3_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy1080 = (int)(_T3_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy1080;
				float fboffsety1080 = fblinearindextoy1080 * fbrowsoffset1080;
				float2 fboffset1080 = float2(fboffsetx1080, fboffsety1080);
				half2 fbuv1080 = lerpResult1468 * fbtiling1080 + fboffset1080;
				float2 lerpResult1081 = lerp( lerpResult1468 , fbuv1080 , _T3_IsGrungeAnimated);
				float3 temp_cast_21 = (SAMPLE_TEXTURE2D_ARRAY( _TA_3_Textures_and_Grunges, sampler_TA_3_Textures_and_Grunges, lerpResult1081,2.0 ).r).xxx;
				float grayscale1112 = Luminance(temp_cast_21);
				float4 temp_cast_22 = (grayscale1112).xxxx;
				float4 lerpResult1446 = lerp( temp_cast_19 , ( CalculateContrast(_T3_AnimatedGrunge_Contrast,temp_cast_22) * _T3_AnimatedGrunge_Multiply ) , _T3_AnimatedGrunge);
				float T3_Albedo_Tiling1377 = _T3_Albedo_Tiling;
				float2 temp_cast_23 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1390 = IN.ase_texcoord4.xy * temp_cast_23 + float2( 0,0 );
				float localStochasticTiling171_g164 = ( 0.0 );
				float2 Input_UV145_g164 = texCoord1390;
				float2 UV171_g164 = Input_UV145_g164;
				float2 UV1171_g164 = float2( 0,0 );
				float2 UV2171_g164 = float2( 0,0 );
				float2 UV3171_g164 = float2( 0,0 );
				float W1171_g164 = 0.0;
				float W2171_g164 = 0.0;
				float W3171_g164 = 0.0;
				StochasticTiling( UV171_g164 , UV1171_g164 , UV2171_g164 , UV3171_g164 , W1171_g164 , W2171_g164 , W3171_g164 );
				float Input_Index184_g164 = 0.0;
				float2 temp_output_172_0_g164 = ddx( Input_UV145_g164 );
				float2 temp_output_182_0_g164 = ddy( Input_UV145_g164 );
				float4 Output_2DArray294_g164 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures_and_Grunges, sampler_TA_3_Textures_and_Grunges, UV1171_g164,Input_Index184_g164, temp_output_172_0_g164, temp_output_182_0_g164 ) * W1171_g164 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures_and_Grunges, sampler_TA_3_Textures_and_Grunges, UV2171_g164,Input_Index184_g164, temp_output_172_0_g164, temp_output_182_0_g164 ) * W2171_g164 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures_and_Grunges, sampler_TA_3_Textures_and_Grunges, UV3171_g164,Input_Index184_g164, temp_output_172_0_g164, temp_output_182_0_g164 ) * W3171_g164 ) );
				float4 lerpResult1441 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_3_Textures_and_Grunges, sampler_TA_3_Textures_and_Grunges, texCoord1390,0.0 ) , Output_2DArray294_g164 , _T3_Albedo_ProceduralTiling);
				float4 temp_output_1094_0 = ( _T3_ColorCorrection * lerpResult1441 );
				float grayscale1113 = dot(temp_output_1094_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_25 = (grayscale1113).xxxx;
				float4 lerpResult1085 = lerp( temp_output_1094_0 , temp_cast_25 , GrayscaleDebug614);
				float4 blendOpSrc1107 = lerpResult1446;
				float4 blendOpDest1107 = lerpResult1085;
				float4 T3_RGB1187 = ( saturate( ( blendOpSrc1107 * blendOpDest1107 ) ));
				float4 T3_End_OutBrume1119 = T3_RGB1187;
				float grayscale1481 = Luminance(T3_End_OutBrume1119.rgb);
				float T3_End_InBrume1482 = grayscale1481;
				float4 temp_cast_27 = (T3_End_InBrume1482).xxxx;
				float4 lerpResult1196 = lerp( T3_End_OutBrume1119 , temp_cast_27 , Out_or_InBrume606);
				float4 Texture3_Final1214 = lerpResult1196;
				float4 DebugColor3478 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,2.0 );
				float4 lerpResult576 = lerp( Texture3_Final1214 , DebugColor3478 , DebugVertexPaint566);
				float4 lerpResult14 = lerp( lerpResult11 , lerpResult576 , tex2DNode1472.g);
				float4 temp_cast_28 = (1.0).xxxx;
				float2 temp_cast_29 = (_T4_AnimatedGrunge_Tiling).xx;
				float2 texCoord1470 = IN.ase_texcoord4.xy * temp_cast_29 + float2( 0,0 );
				float2 lerpResult1471 = lerp( ( (ase_screenPosNorm).xy * _T4_AnimatedGrunge_Tiling ) , texCoord1470 , _T4_AnimatedGrunge_ScreenBased);
				float fbtotaltiles1129 = _T4_AnimatedGrunge_Flipbook_Columns * _T4_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset1129 = 1.0f / _T4_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset1129 = 1.0f / _T4_AnimatedGrunge_Flipbook_Rows;
				float fbspeed1129 = _TimeParameters.x * _T4_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling1129 = float2(fbcolsoffset1129, fbrowsoffset1129);
				float fbcurrenttileindex1129 = round( fmod( fbspeed1129 + 0.0, fbtotaltiles1129) );
				fbcurrenttileindex1129 += ( fbcurrenttileindex1129 < 0) ? fbtotaltiles1129 : 0;
				float fblinearindextox1129 = round ( fmod ( fbcurrenttileindex1129, _T4_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx1129 = fblinearindextox1129 * fbcolsoffset1129;
				float fblinearindextoy1129 = round( fmod( ( fbcurrenttileindex1129 - fblinearindextox1129 ) / _T4_AnimatedGrunge_Flipbook_Columns, _T4_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy1129 = (int)(_T4_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy1129;
				float fboffsety1129 = fblinearindextoy1129 * fbrowsoffset1129;
				float2 fboffset1129 = float2(fboffsetx1129, fboffsety1129);
				half2 fbuv1129 = lerpResult1471 * fbtiling1129 + fboffset1129;
				float2 lerpResult1069 = lerp( lerpResult1471 , fbuv1129 , _T4_IsGrungeAnimated);
				float3 temp_cast_30 = (SAMPLE_TEXTURE2D_ARRAY( _TA_4_Textures_and_Grunges, sampler_TA_4_Textures_and_Grunges, lerpResult1069,2.0 ).r).xxx;
				float grayscale1097 = Luminance(temp_cast_30);
				float4 temp_cast_31 = (grayscale1097).xxxx;
				float4 lerpResult1453 = lerp( temp_cast_28 , ( CalculateContrast(_T4_AnimatedGrunge_Contrast,temp_cast_31) * _T4_AnimatedGrunge_Multiply ) , _T4_AnimatedGrunge);
				float T4_Albedo_Tiling1376 = _T4_Albedo_Tiling;
				float2 temp_cast_32 = (T4_Albedo_Tiling1376).xx;
				float2 texCoord1389 = IN.ase_texcoord4.xy * temp_cast_32 + float2( 0,0 );
				float localStochasticTiling171_g163 = ( 0.0 );
				float2 Input_UV145_g163 = texCoord1389;
				float2 UV171_g163 = Input_UV145_g163;
				float2 UV1171_g163 = float2( 0,0 );
				float2 UV2171_g163 = float2( 0,0 );
				float2 UV3171_g163 = float2( 0,0 );
				float W1171_g163 = 0.0;
				float W2171_g163 = 0.0;
				float W3171_g163 = 0.0;
				StochasticTiling( UV171_g163 , UV1171_g163 , UV2171_g163 , UV3171_g163 , W1171_g163 , W2171_g163 , W3171_g163 );
				float Input_Index184_g163 = 0.0;
				float2 temp_output_172_0_g163 = ddx( Input_UV145_g163 );
				float2 temp_output_182_0_g163 = ddy( Input_UV145_g163 );
				float4 Output_2DArray294_g163 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures_and_Grunges, sampler_TA_4_Textures_and_Grunges, UV1171_g163,Input_Index184_g163, temp_output_172_0_g163, temp_output_182_0_g163 ) * W1171_g163 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures_and_Grunges, sampler_TA_4_Textures_and_Grunges, UV2171_g163,Input_Index184_g163, temp_output_172_0_g163, temp_output_182_0_g163 ) * W2171_g163 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures_and_Grunges, sampler_TA_4_Textures_and_Grunges, UV3171_g163,Input_Index184_g163, temp_output_172_0_g163, temp_output_182_0_g163 ) * W3171_g163 ) );
				float4 lerpResult1444 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_4_Textures_and_Grunges, sampler_TA_4_Textures_and_Grunges, texCoord1389,0.0 ) , Output_2DArray294_g163 , _T4_Albedo_ProceduralTiling);
				float4 temp_output_1079_0 = ( _T4_ColorCorrection * lerpResult1444 );
				float grayscale1051 = dot(temp_output_1079_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_34 = (grayscale1051).xxxx;
				float4 lerpResult1074 = lerp( temp_output_1079_0 , temp_cast_34 , GrayscaleDebug614);
				float4 blendOpSrc1064 = lerpResult1453;
				float4 blendOpDest1064 = lerpResult1074;
				float4 T4_RGB1122 = ( saturate( ( blendOpSrc1064 * blendOpDest1064 ) ));
				float4 T4_End_OutBrume1120 = T4_RGB1122;
				float grayscale1484 = Luminance(T4_End_OutBrume1120.rgb);
				float T4_End_InBrume1485 = grayscale1484;
				float4 temp_cast_36 = (T4_End_InBrume1485).xxxx;
				float4 lerpResult1050 = lerp( T4_End_OutBrume1120 , temp_cast_36 , Out_or_InBrume606);
				float4 Texture4_Final1364 = lerpResult1050;
				float4 DebugColor4479 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,3.0 );
				float4 lerpResult580 = lerp( Texture4_Final1364 , DebugColor4479 , DebugVertexPaint566);
				float4 lerpResult495 = lerp( lerpResult14 , lerpResult580 , tex2DNode1472.b);
				float2 uv_TerrainMask_TextureSampler2 = IN.ase_texcoord4.xy * _TerrainMask_TextureSampler2_ST.xy + _TerrainMask_TextureSampler2_ST.zw;
				float4 tex2DNode2095 = tex2D( _TerrainMask_TextureSampler2, uv_TerrainMask_TextureSampler2 );
				float clampResult2145 = clamp( saturate( ( tex2DNode2095.r + tex2DNode2095.g + tex2DNode2095.b ) ) , 0.0 , 1.0 );
				float TextureSampler2_AlphaMask2129 = clampResult2145;
				float4 AllAlbedo_TextureSampler1622 = ( lerpResult495 * ( 1.0 - TextureSampler2_AlphaMask2129 ) );
				float4 temp_cast_37 = (1.0).xxxx;
				float2 temp_cast_38 = (_T5_AnimatedGrunge_Tiling).xx;
				float2 texCoord1716 = IN.ase_texcoord4.xy * temp_cast_38 + float2( 0,0 );
				float2 lerpResult1719 = lerp( ( (ase_screenPosNorm).xy * _T5_AnimatedGrunge_Tiling ) , texCoord1716 , _T5_AnimatedGrunge_ScreenBased);
				float fbtotaltiles1680 = _T5_AnimatedGrunge_Flipbook_Columns * _T5_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset1680 = 1.0f / _T5_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset1680 = 1.0f / _T5_AnimatedGrunge_Flipbook_Rows;
				float fbspeed1680 = _TimeParameters.x * _T5_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling1680 = float2(fbcolsoffset1680, fbrowsoffset1680);
				float fbcurrenttileindex1680 = round( fmod( fbspeed1680 + 0.0, fbtotaltiles1680) );
				fbcurrenttileindex1680 += ( fbcurrenttileindex1680 < 0) ? fbtotaltiles1680 : 0;
				float fblinearindextox1680 = round ( fmod ( fbcurrenttileindex1680, _T5_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx1680 = fblinearindextox1680 * fbcolsoffset1680;
				float fblinearindextoy1680 = round( fmod( ( fbcurrenttileindex1680 - fblinearindextox1680 ) / _T5_AnimatedGrunge_Flipbook_Columns, _T5_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy1680 = (int)(_T5_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy1680;
				float fboffsety1680 = fblinearindextoy1680 * fbrowsoffset1680;
				float2 fboffset1680 = float2(fboffsetx1680, fboffsety1680);
				half2 fbuv1680 = lerpResult1719 * fbtiling1680 + fboffset1680;
				float2 lerpResult1696 = lerp( lerpResult1719 , fbuv1680 , _T5_IsGrungeAnimated);
				float3 temp_cast_39 = (SAMPLE_TEXTURE2D_ARRAY( _TA_5_Textures_and_Grunges, sampler_TA_5_Textures_and_Grunges, lerpResult1696,2.0 ).r).xxx;
				float grayscale1736 = Luminance(temp_cast_39);
				float4 temp_cast_40 = (grayscale1736).xxxx;
				float4 lerpResult1725 = lerp( temp_cast_37 , ( CalculateContrast(_T5_AnimatedGrunge_Contrast,temp_cast_40) * _T5_AnimatedGrunge_Multiply ) , _T5_AnimatedGrunge);
				float T5_Albedo_Tiling1705 = _T5_Albedo_Tiling;
				float2 temp_cast_41 = (T5_Albedo_Tiling1705).xx;
				float2 texCoord1704 = IN.ase_texcoord4.xy * temp_cast_41 + float2( 0,0 );
				float localStochasticTiling171_g153 = ( 0.0 );
				float2 Input_UV145_g153 = texCoord1704;
				float2 UV171_g153 = Input_UV145_g153;
				float2 UV1171_g153 = float2( 0,0 );
				float2 UV2171_g153 = float2( 0,0 );
				float2 UV3171_g153 = float2( 0,0 );
				float W1171_g153 = 0.0;
				float W2171_g153 = 0.0;
				float W3171_g153 = 0.0;
				StochasticTiling( UV171_g153 , UV1171_g153 , UV2171_g153 , UV3171_g153 , W1171_g153 , W2171_g153 , W3171_g153 );
				float Input_Index184_g153 = 0.0;
				float2 temp_output_172_0_g153 = ddx( Input_UV145_g153 );
				float2 temp_output_182_0_g153 = ddy( Input_UV145_g153 );
				float4 Output_2DArray294_g153 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_5_Textures_and_Grunges, sampler_TA_5_Textures_and_Grunges, UV1171_g153,Input_Index184_g153, temp_output_172_0_g153, temp_output_182_0_g153 ) * W1171_g153 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_5_Textures_and_Grunges, sampler_TA_5_Textures_and_Grunges, UV2171_g153,Input_Index184_g153, temp_output_172_0_g153, temp_output_182_0_g153 ) * W2171_g153 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_5_Textures_and_Grunges, sampler_TA_5_Textures_and_Grunges, UV3171_g153,Input_Index184_g153, temp_output_172_0_g153, temp_output_182_0_g153 ) * W3171_g153 ) );
				float4 lerpResult1721 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_5_Textures_and_Grunges, sampler_TA_5_Textures_and_Grunges, texCoord1704,0.0 ) , Output_2DArray294_g153 , _T5_Albedo_ProceduralTiling);
				float4 temp_output_1684_0 = ( _T5_ColorCorrection * lerpResult1721 );
				float grayscale1677 = dot(temp_output_1684_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_43 = (grayscale1677).xxxx;
				float4 lerpResult1706 = lerp( temp_output_1684_0 , temp_cast_43 , GrayscaleDebug614);
				float4 blendOpSrc1747 = lerpResult1725;
				float4 blendOpDest1747 = lerpResult1706;
				float4 T5_RGB1695 = ( saturate( ( blendOpSrc1747 * blendOpDest1747 ) ));
				float4 T5_End_OutBrume1761 = T5_RGB1695;
				float grayscale1757 = Luminance(T5_End_OutBrume1761.rgb);
				float T5_End_InBrume1755 = grayscale1757;
				float4 temp_cast_45 = (T5_End_InBrume1755).xxxx;
				float4 lerpResult1722 = lerp( T5_End_OutBrume1761 , temp_cast_45 , Out_or_InBrume606);
				float4 Texture5_Final1675 = lerpResult1722;
				float4 lerpResult2075 = lerp( Texture5_Final1675 , DebugColor2477 , DebugVertexPaint566);
				float4 lerpResult2078 = lerp( AllAlbedo_TextureSampler1622 , lerpResult2075 , tex2DNode2095.r);
				float4 temp_cast_46 = (1.0).xxxx;
				float2 temp_cast_47 = (_T6_AnimatedGrunge_Tiling).xx;
				float2 texCoord1877 = IN.ase_texcoord4.xy * temp_cast_47 + float2( 0,0 );
				float2 lerpResult1844 = lerp( ( (ase_screenPosNorm).xy * _T6_AnimatedGrunge_Tiling ) , texCoord1877 , _T6_AnimatedGrunge_ScreenBased);
				float fbtotaltiles1845 = _T6_AnimatedGrunge_Flipbook_Columns * _T6_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset1845 = 1.0f / _T6_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset1845 = 1.0f / _T6_AnimatedGrunge_Flipbook_Rows;
				float fbspeed1845 = _TimeParameters.x * _T6_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling1845 = float2(fbcolsoffset1845, fbrowsoffset1845);
				float fbcurrenttileindex1845 = round( fmod( fbspeed1845 + 0.0, fbtotaltiles1845) );
				fbcurrenttileindex1845 += ( fbcurrenttileindex1845 < 0) ? fbtotaltiles1845 : 0;
				float fblinearindextox1845 = round ( fmod ( fbcurrenttileindex1845, _T6_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx1845 = fblinearindextox1845 * fbcolsoffset1845;
				float fblinearindextoy1845 = round( fmod( ( fbcurrenttileindex1845 - fblinearindextox1845 ) / _T6_AnimatedGrunge_Flipbook_Columns, _T6_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy1845 = (int)(_T6_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy1845;
				float fboffsety1845 = fblinearindextoy1845 * fbrowsoffset1845;
				float2 fboffset1845 = float2(fboffsetx1845, fboffsety1845);
				half2 fbuv1845 = lerpResult1844 * fbtiling1845 + fboffset1845;
				float2 lerpResult1847 = lerp( lerpResult1844 , fbuv1845 , _T6_IsGrungeAnimated);
				float3 temp_cast_48 = (SAMPLE_TEXTURE2D_ARRAY( _TA_6_Textures_and_Grunges, sampler_TA_6_Textures_and_Grunges, lerpResult1847,0.0 ).r).xxx;
				float grayscale1852 = Luminance(temp_cast_48);
				float4 temp_cast_49 = (grayscale1852).xxxx;
				float4 lerpResult1872 = lerp( temp_cast_46 , ( CalculateContrast(_T6_AnimatedGrunge_Contrast,temp_cast_49) * _T6_AnimatedGrunge_Multiply ) , _T6_AnimatedGrunge);
				float T6_Albedo_Tiling1828 = _T6_Albedo_Tiling;
				float2 temp_cast_50 = (T6_Albedo_Tiling1828).xx;
				float2 texCoord1867 = IN.ase_texcoord4.xy * temp_cast_50 + float2( 0,0 );
				float localStochasticTiling171_g154 = ( 0.0 );
				float2 Input_UV145_g154 = texCoord1867;
				float2 UV171_g154 = Input_UV145_g154;
				float2 UV1171_g154 = float2( 0,0 );
				float2 UV2171_g154 = float2( 0,0 );
				float2 UV3171_g154 = float2( 0,0 );
				float W1171_g154 = 0.0;
				float W2171_g154 = 0.0;
				float W3171_g154 = 0.0;
				StochasticTiling( UV171_g154 , UV1171_g154 , UV2171_g154 , UV3171_g154 , W1171_g154 , W2171_g154 , W3171_g154 );
				float Input_Index184_g154 = 0.0;
				float2 temp_output_172_0_g154 = ddx( Input_UV145_g154 );
				float2 temp_output_182_0_g154 = ddy( Input_UV145_g154 );
				float4 Output_2DArray294_g154 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_6_Textures_and_Grunges, sampler_TA_6_Textures_and_Grunges, UV1171_g154,Input_Index184_g154, temp_output_172_0_g154, temp_output_182_0_g154 ) * W1171_g154 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_6_Textures_and_Grunges, sampler_TA_6_Textures_and_Grunges, UV2171_g154,Input_Index184_g154, temp_output_172_0_g154, temp_output_182_0_g154 ) * W2171_g154 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_6_Textures_and_Grunges, sampler_TA_6_Textures_and_Grunges, UV3171_g154,Input_Index184_g154, temp_output_172_0_g154, temp_output_182_0_g154 ) * W3171_g154 ) );
				float4 lerpResult1853 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_6_Textures_and_Grunges, sampler_TA_6_Textures_and_Grunges, texCoord1867,0.0 ) , Output_2DArray294_g154 , _T6_Albedo_ProceduralTiling);
				float4 temp_output_1838_0 = ( _T6_ColorCorrection * lerpResult1853 );
				float grayscale1812 = dot(temp_output_1838_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_52 = (grayscale1812).xxxx;
				float4 lerpResult1874 = lerp( temp_output_1838_0 , temp_cast_52 , GrayscaleDebug614);
				float4 blendOpSrc1870 = lerpResult1872;
				float4 blendOpDest1870 = lerpResult1874;
				float4 T6_RGB1803 = ( saturate( ( blendOpSrc1870 * blendOpDest1870 ) ));
				float4 T6_End_OutBrume1836 = T6_RGB1803;
				float grayscale1887 = Luminance(T6_End_OutBrume1836.rgb);
				float T6_End_InBrume1886 = grayscale1887;
				float4 temp_cast_54 = (T6_End_InBrume1886).xxxx;
				float4 lerpResult1868 = lerp( T6_End_OutBrume1836 , temp_cast_54 , Out_or_InBrume606);
				float4 Texture6_Final1811 = lerpResult1868;
				float4 lerpResult2091 = lerp( Texture6_Final1811 , DebugColor3478 , DebugVertexPaint566);
				float4 lerpResult2093 = lerp( lerpResult2078 , lerpResult2091 , tex2DNode2095.g);
				float4 temp_cast_55 = (1.0).xxxx;
				float2 temp_cast_56 = (_T7_AnimatedGrunge_Tiling).xx;
				float2 texCoord2013 = IN.ase_texcoord4.xy * temp_cast_56 + float2( 0,0 );
				float2 lerpResult1999 = lerp( ( (ase_screenPosNorm).xy * _T7_AnimatedGrunge_Tiling ) , texCoord2013 , _T7_AnimatedGrunge_ScreenBased);
				float fbtotaltiles2000 = _T7_AnimatedGrunge_Flipbook_Columns * _T7_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset2000 = 1.0f / _T7_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset2000 = 1.0f / _T7_AnimatedGrunge_Flipbook_Rows;
				float fbspeed2000 = _TimeParameters.x * _T7_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling2000 = float2(fbcolsoffset2000, fbrowsoffset2000);
				float fbcurrenttileindex2000 = round( fmod( fbspeed2000 + 0.0, fbtotaltiles2000) );
				fbcurrenttileindex2000 += ( fbcurrenttileindex2000 < 0) ? fbtotaltiles2000 : 0;
				float fblinearindextox2000 = round ( fmod ( fbcurrenttileindex2000, _T7_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx2000 = fblinearindextox2000 * fbcolsoffset2000;
				float fblinearindextoy2000 = round( fmod( ( fbcurrenttileindex2000 - fblinearindextox2000 ) / _T7_AnimatedGrunge_Flipbook_Columns, _T7_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy2000 = (int)(_T7_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy2000;
				float fboffsety2000 = fblinearindextoy2000 * fbrowsoffset2000;
				float2 fboffset2000 = float2(fboffsetx2000, fboffsety2000);
				half2 fbuv2000 = lerpResult1999 * fbtiling2000 + fboffset2000;
				float2 lerpResult2001 = lerp( lerpResult1999 , fbuv2000 , _T7_IsGrungeAnimated);
				float3 temp_cast_57 = (SAMPLE_TEXTURE2D_ARRAY( _TA_7_Textures_and_Grunges, sampler_TA_7_Textures_and_Grunges, lerpResult2001,2.0 ).r).xxx;
				float grayscale2003 = Luminance(temp_cast_57);
				float4 temp_cast_58 = (grayscale2003).xxxx;
				float4 lerpResult2009 = lerp( temp_cast_55 , ( CalculateContrast(_T7_AnimatedGrunge_Contrast,temp_cast_58) * _T7_AnimatedGrunge_Multiply ) , _T7_AnimatedGrunge);
				float T7_Albedo_Tiling2048 = _T7_Albedo_Tiling;
				float2 temp_cast_59 = (T7_Albedo_Tiling2048).xx;
				float2 texCoord2044 = IN.ase_texcoord4.xy * temp_cast_59 + float2( 0,0 );
				float localStochasticTiling171_g166 = ( 0.0 );
				float2 Input_UV145_g166 = texCoord2044;
				float2 UV171_g166 = Input_UV145_g166;
				float2 UV1171_g166 = float2( 0,0 );
				float2 UV2171_g166 = float2( 0,0 );
				float2 UV3171_g166 = float2( 0,0 );
				float W1171_g166 = 0.0;
				float W2171_g166 = 0.0;
				float W3171_g166 = 0.0;
				StochasticTiling( UV171_g166 , UV1171_g166 , UV2171_g166 , UV3171_g166 , W1171_g166 , W2171_g166 , W3171_g166 );
				float Input_Index184_g166 = 0.0;
				float2 temp_output_172_0_g166 = ddx( Input_UV145_g166 );
				float2 temp_output_182_0_g166 = ddy( Input_UV145_g166 );
				float4 Output_2DArray294_g166 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_7_Textures_and_Grunges, sampler_TA_7_Textures_and_Grunges, UV1171_g166,Input_Index184_g166, temp_output_172_0_g166, temp_output_182_0_g166 ) * W1171_g166 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_7_Textures_and_Grunges, sampler_TA_7_Textures_and_Grunges, UV2171_g166,Input_Index184_g166, temp_output_172_0_g166, temp_output_182_0_g166 ) * W2171_g166 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_7_Textures_and_Grunges, sampler_TA_7_Textures_and_Grunges, UV3171_g166,Input_Index184_g166, temp_output_172_0_g166, temp_output_182_0_g166 ) * W3171_g166 ) );
				float4 lerpResult2042 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_7_Textures_and_Grunges, sampler_TA_7_Textures_and_Grunges, texCoord2044,0.0 ) , Output_2DArray294_g166 , _T7_Albedo_ProceduralTiling);
				float4 temp_output_2040_0 = ( _T7_ColorCorrection * lerpResult2042 );
				float grayscale2039 = dot(temp_output_2040_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_61 = (grayscale2039).xxxx;
				float4 lerpResult2045 = lerp( temp_output_2040_0 , temp_cast_61 , GrayscaleDebug614);
				float4 blendOpSrc2053 = lerpResult2009;
				float4 blendOpDest2053 = lerpResult2045;
				float4 T7_RGB2054 = ( saturate( ( blendOpSrc2053 * blendOpDest2053 ) ));
				float4 T7_End_OutBrume2055 = T7_RGB2054;
				float grayscale2017 = Luminance(T7_End_OutBrume2055.rgb);
				float T7_End_InBrume2035 = grayscale2017;
				float4 temp_cast_63 = (T7_End_InBrume2035).xxxx;
				float4 lerpResult2007 = lerp( T7_End_OutBrume2055 , temp_cast_63 , Out_or_InBrume606);
				float4 Texture7_Final2037 = lerpResult2007;
				float4 lerpResult2082 = lerp( Texture7_Final2037 , DebugColor4479 , DebugVertexPaint566);
				float4 lerpResult2080 = lerp( lerpResult2093 , lerpResult2082 , tex2DNode2095.b);
				float4 AllAlbedo_TextureSampler22073 = lerpResult2080;
				float4 AllAlbedo2113 = AllAlbedo_TextureSampler22073;
				float temp_output_420_0 = ( _StepShadow + _StepAttenuation );
				float localStochasticTiling171_g161 = ( 0.0 );
				float2 temp_cast_64 = (T1_Albedo_Tiling1379).xx;
				float2 texCoord1386 = IN.ase_texcoord4.xy * temp_cast_64 + float2( 0,0 );
				float2 Input_UV145_g161 = texCoord1386;
				float2 UV171_g161 = Input_UV145_g161;
				float2 UV1171_g161 = float2( 0,0 );
				float2 UV2171_g161 = float2( 0,0 );
				float2 UV3171_g161 = float2( 0,0 );
				float W1171_g161 = 0.0;
				float W2171_g161 = 0.0;
				float W3171_g161 = 0.0;
				StochasticTiling( UV171_g161 , UV1171_g161 , UV2171_g161 , UV3171_g161 , W1171_g161 , W2171_g161 , W3171_g161 );
				float Input_Index184_g161 = 1.0;
				float2 temp_output_172_0_g161 = ddx( Input_UV145_g161 );
				float2 temp_output_182_0_g161 = ddy( Input_UV145_g161 );
				float4 Output_2DArray294_g161 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures_and_Grunges, sampler_TA_1_Textures_and_Grunges, UV1171_g161,Input_Index184_g161, temp_output_172_0_g161, temp_output_182_0_g161 ) * W1171_g161 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures_and_Grunges, sampler_TA_1_Textures_and_Grunges, UV2171_g161,Input_Index184_g161, temp_output_172_0_g161, temp_output_182_0_g161 ) * W2171_g161 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures_and_Grunges, sampler_TA_1_Textures_and_Grunges, UV3171_g161,Input_Index184_g161, temp_output_172_0_g161, temp_output_182_0_g161 ) * W3171_g161 ) );
				float4 T1_Normal_Texture139 = Output_2DArray294_g161;
				float localStochasticTiling171_g158 = ( 0.0 );
				float2 temp_cast_65 = (T2_Albedo_Tiling1378).xx;
				float2 texCoord1398 = IN.ase_texcoord4.xy * temp_cast_65 + float2( 0,0 );
				float2 Input_UV145_g158 = texCoord1398;
				float2 UV171_g158 = Input_UV145_g158;
				float2 UV1171_g158 = float2( 0,0 );
				float2 UV2171_g158 = float2( 0,0 );
				float2 UV3171_g158 = float2( 0,0 );
				float W1171_g158 = 0.0;
				float W2171_g158 = 0.0;
				float W3171_g158 = 0.0;
				StochasticTiling( UV171_g158 , UV1171_g158 , UV2171_g158 , UV3171_g158 , W1171_g158 , W2171_g158 , W3171_g158 );
				float Input_Index184_g158 = 1.0;
				float2 temp_output_172_0_g158 = ddx( Input_UV145_g158 );
				float2 temp_output_182_0_g158 = ddy( Input_UV145_g158 );
				float4 Output_2DArray294_g158 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures_and_Grunges, sampler_TA_2_Textures_and_Grunges, UV1171_g158,Input_Index184_g158, temp_output_172_0_g158, temp_output_182_0_g158 ) * W1171_g158 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures_and_Grunges, sampler_TA_2_Textures_and_Grunges, UV2171_g158,Input_Index184_g158, temp_output_172_0_g158, temp_output_182_0_g158 ) * W2171_g158 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures_and_Grunges, sampler_TA_2_Textures_and_Grunges, UV3171_g158,Input_Index184_g158, temp_output_172_0_g158, temp_output_182_0_g158 ) * W3171_g158 ) );
				float4 T2_Normal_Texture1396 = Output_2DArray294_g158;
				float4 tex2DNode1473 = tex2D( _TerrainMask_TextureSampler1, uv_TerrainMask_TextureSampler1 );
				float4 lerpResult632 = lerp( T1_Normal_Texture139 , T2_Normal_Texture1396 , tex2DNode1473.r);
				float localStochasticTiling171_g160 = ( 0.0 );
				float2 temp_cast_66 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1404 = IN.ase_texcoord4.xy * temp_cast_66 + float2( 0,0 );
				float2 Input_UV145_g160 = texCoord1404;
				float2 UV171_g160 = Input_UV145_g160;
				float2 UV1171_g160 = float2( 0,0 );
				float2 UV2171_g160 = float2( 0,0 );
				float2 UV3171_g160 = float2( 0,0 );
				float W1171_g160 = 0.0;
				float W2171_g160 = 0.0;
				float W3171_g160 = 0.0;
				StochasticTiling( UV171_g160 , UV1171_g160 , UV2171_g160 , UV3171_g160 , W1171_g160 , W2171_g160 , W3171_g160 );
				float Input_Index184_g160 = 1.0;
				float2 temp_output_172_0_g160 = ddx( Input_UV145_g160 );
				float2 temp_output_182_0_g160 = ddy( Input_UV145_g160 );
				float4 Output_2DArray294_g160 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures_and_Grunges, sampler_TA_3_Textures_and_Grunges, UV1171_g160,Input_Index184_g160, temp_output_172_0_g160, temp_output_182_0_g160 ) * W1171_g160 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures_and_Grunges, sampler_TA_3_Textures_and_Grunges, UV2171_g160,Input_Index184_g160, temp_output_172_0_g160, temp_output_182_0_g160 ) * W2171_g160 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures_and_Grunges, sampler_TA_3_Textures_and_Grunges, UV3171_g160,Input_Index184_g160, temp_output_172_0_g160, temp_output_182_0_g160 ) * W3171_g160 ) );
				float4 T3_Normal_Texture1402 = Output_2DArray294_g160;
				float4 lerpResult635 = lerp( lerpResult632 , T3_Normal_Texture1402 , tex2DNode1473.g);
				float localStochasticTiling171_g159 = ( 0.0 );
				float2 temp_cast_67 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1410 = IN.ase_texcoord4.xy * temp_cast_67 + float2( 0,0 );
				float2 Input_UV145_g159 = texCoord1410;
				float2 UV171_g159 = Input_UV145_g159;
				float2 UV1171_g159 = float2( 0,0 );
				float2 UV2171_g159 = float2( 0,0 );
				float2 UV3171_g159 = float2( 0,0 );
				float W1171_g159 = 0.0;
				float W2171_g159 = 0.0;
				float W3171_g159 = 0.0;
				StochasticTiling( UV171_g159 , UV1171_g159 , UV2171_g159 , UV3171_g159 , W1171_g159 , W2171_g159 , W3171_g159 );
				float Input_Index184_g159 = 1.0;
				float2 temp_output_172_0_g159 = ddx( Input_UV145_g159 );
				float2 temp_output_182_0_g159 = ddy( Input_UV145_g159 );
				float4 Output_2DArray294_g159 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures_and_Grunges, sampler_TA_4_Textures_and_Grunges, UV1171_g159,Input_Index184_g159, temp_output_172_0_g159, temp_output_182_0_g159 ) * W1171_g159 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures_and_Grunges, sampler_TA_4_Textures_and_Grunges, UV2171_g159,Input_Index184_g159, temp_output_172_0_g159, temp_output_182_0_g159 ) * W2171_g159 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures_and_Grunges, sampler_TA_4_Textures_and_Grunges, UV3171_g159,Input_Index184_g159, temp_output_172_0_g159, temp_output_182_0_g159 ) * W3171_g159 ) );
				float4 T4_Normal_Texture1408 = Output_2DArray294_g159;
				float4 lerpResult640 = lerp( lerpResult635 , T4_Normal_Texture1408 , tex2DNode1473.b);
				float4 AllNormal_TextureSampler1644 = ( lerpResult640 * ( 1.0 - TextureSampler2_AlphaMask2129 ) );
				float localStochasticTiling171_g168 = ( 0.0 );
				float2 temp_cast_68 = (T5_Albedo_Tiling1705).xx;
				float2 texCoord1763 = IN.ase_texcoord4.xy * temp_cast_68 + float2( 0,0 );
				float2 Input_UV145_g168 = texCoord1763;
				float2 UV171_g168 = Input_UV145_g168;
				float2 UV1171_g168 = float2( 0,0 );
				float2 UV2171_g168 = float2( 0,0 );
				float2 UV3171_g168 = float2( 0,0 );
				float W1171_g168 = 0.0;
				float W2171_g168 = 0.0;
				float W3171_g168 = 0.0;
				StochasticTiling( UV171_g168 , UV1171_g168 , UV2171_g168 , UV3171_g168 , W1171_g168 , W2171_g168 , W3171_g168 );
				float Input_Index184_g168 = 1.0;
				float2 temp_output_172_0_g168 = ddx( Input_UV145_g168 );
				float2 temp_output_182_0_g168 = ddy( Input_UV145_g168 );
				float4 Output_2DArray294_g168 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_5_Textures_and_Grunges, sampler_TA_5_Textures_and_Grunges, UV1171_g168,Input_Index184_g168, temp_output_172_0_g168, temp_output_182_0_g168 ) * W1171_g168 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_5_Textures_and_Grunges, sampler_TA_5_Textures_and_Grunges, UV2171_g168,Input_Index184_g168, temp_output_172_0_g168, temp_output_182_0_g168 ) * W2171_g168 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_5_Textures_and_Grunges, sampler_TA_5_Textures_and_Grunges, UV3171_g168,Input_Index184_g168, temp_output_172_0_g168, temp_output_182_0_g168 ) * W3171_g168 ) );
				float4 T5_Normal_Texture1767 = Output_2DArray294_g168;
				float4 tex2DNode2107 = tex2D( _TerrainMask_TextureSampler2, uv_TerrainMask_TextureSampler2 );
				float4 lerpResult2105 = lerp( AllNormal_TextureSampler1644 , T5_Normal_Texture1767 , tex2DNode2107.r);
				float localStochasticTiling171_g167 = ( 0.0 );
				float2 temp_cast_69 = (T6_Albedo_Tiling1828).xx;
				float2 texCoord2059 = IN.ase_texcoord4.xy * temp_cast_69 + float2( 0,0 );
				float2 Input_UV145_g167 = texCoord2059;
				float2 UV171_g167 = Input_UV145_g167;
				float2 UV1171_g167 = float2( 0,0 );
				float2 UV2171_g167 = float2( 0,0 );
				float2 UV3171_g167 = float2( 0,0 );
				float W1171_g167 = 0.0;
				float W2171_g167 = 0.0;
				float W3171_g167 = 0.0;
				StochasticTiling( UV171_g167 , UV1171_g167 , UV2171_g167 , UV3171_g167 , W1171_g167 , W2171_g167 , W3171_g167 );
				float Input_Index184_g167 = 1.0;
				float2 temp_output_172_0_g167 = ddx( Input_UV145_g167 );
				float2 temp_output_182_0_g167 = ddy( Input_UV145_g167 );
				float4 Output_2DArray294_g167 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_6_Textures_and_Grunges, sampler_TA_6_Textures_and_Grunges, UV1171_g167,Input_Index184_g167, temp_output_172_0_g167, temp_output_182_0_g167 ) * W1171_g167 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_6_Textures_and_Grunges, sampler_TA_6_Textures_and_Grunges, UV2171_g167,Input_Index184_g167, temp_output_172_0_g167, temp_output_182_0_g167 ) * W2171_g167 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_6_Textures_and_Grunges, sampler_TA_6_Textures_and_Grunges, UV3171_g167,Input_Index184_g167, temp_output_172_0_g167, temp_output_182_0_g167 ) * W3171_g167 ) );
				float4 T6_Normal_Texture2061 = Output_2DArray294_g167;
				float4 lerpResult2100 = lerp( lerpResult2105 , T6_Normal_Texture2061 , tex2DNode2107.g);
				float localStochasticTiling171_g169 = ( 0.0 );
				float2 temp_cast_70 = (T7_Albedo_Tiling2048).xx;
				float2 texCoord2065 = IN.ase_texcoord4.xy * temp_cast_70 + float2( 0,0 );
				float2 Input_UV145_g169 = texCoord2065;
				float2 UV171_g169 = Input_UV145_g169;
				float2 UV1171_g169 = float2( 0,0 );
				float2 UV2171_g169 = float2( 0,0 );
				float2 UV3171_g169 = float2( 0,0 );
				float W1171_g169 = 0.0;
				float W2171_g169 = 0.0;
				float W3171_g169 = 0.0;
				StochasticTiling( UV171_g169 , UV1171_g169 , UV2171_g169 , UV3171_g169 , W1171_g169 , W2171_g169 , W3171_g169 );
				float Input_Index184_g169 = 1.0;
				float2 temp_output_172_0_g169 = ddx( Input_UV145_g169 );
				float2 temp_output_182_0_g169 = ddy( Input_UV145_g169 );
				float4 Output_2DArray294_g169 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_7_Textures_and_Grunges, sampler_TA_7_Textures_and_Grunges, UV1171_g169,Input_Index184_g169, temp_output_172_0_g169, temp_output_182_0_g169 ) * W1171_g169 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_7_Textures_and_Grunges, sampler_TA_7_Textures_and_Grunges, UV2171_g169,Input_Index184_g169, temp_output_172_0_g169, temp_output_182_0_g169 ) * W2171_g169 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_7_Textures_and_Grunges, sampler_TA_7_Textures_and_Grunges, UV3171_g169,Input_Index184_g169, temp_output_172_0_g169, temp_output_182_0_g169 ) * W3171_g169 ) );
				float4 T7_Normal_Texture2070 = Output_2DArray294_g169;
				float4 lerpResult2098 = lerp( lerpResult2100 , T7_Normal_Texture2070 , tex2DNode2107.b);
				float4 AllNormal_TextureSampler22106 = lerpResult2098;
				float4 AllNormal2114 = AllNormal_TextureSampler22106;
				float3 ase_worldTangent = IN.ase_texcoord5.xyz;
				float3 ase_worldNormal = IN.ase_texcoord6.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal411 = AllNormal2114.rgb;
				float3 worldNormal411 = float3(dot(tanToWorld0,tanNormal411), dot(tanToWorld1,tanNormal411), dot(tanToWorld2,tanNormal411));
				float dotResult414 = dot( worldNormal411 , SafeNormalize(_MainLightPosition.xyz) );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir140 = ( dotResult414 * ase_lightAtten );
				float smoothstepResult430 = smoothstep( _StepShadow , temp_output_420_0 , normal_LightDir140);
				float2 temp_cast_72 = (_Noise_Tiling).xx;
				float2 texCoord170 = IN.ase_texcoord4.xy * temp_cast_72 + float2( 0,0 );
				float2 lerpResult157 = lerp( texCoord170 , ( (ase_screenPosNorm).xy * _Noise_Tiling ) , _ScreenBasedShadowNoise);
				float2 panner362 = ( 1.0 * _Time.y * ( _ShadowNoisePanner + float2( 0.1,0.05 ) ) + lerpResult157);
				float2 panner359 = ( 1.0 * _Time.y * _ShadowNoisePanner + lerpResult157);
				float blendOpSrc365 = tex2D( _ShadowNoise, ( panner362 + float2( 0.5,0.5 ) ) ).r;
				float blendOpDest365 = tex2D( _ShadowNoise, panner359 ).r;
				float MapNoise197 = ( saturate( 2.0f*blendOpDest365*blendOpSrc365 + blendOpDest365*blendOpDest365*(1.0f - 2.0f*blendOpSrc365) ));
				float smoothstepResult408 = smoothstep( 0.0 , 0.6 , ( smoothstepResult430 - MapNoise197 ));
				float smoothstepResult406 = smoothstep( ( _StepShadow + -0.02 ) , ( temp_output_420_0 + -0.02 ) , normal_LightDir140);
				float blendOpSrc429 = smoothstepResult408;
				float blendOpDest429 = smoothstepResult406;
				float temp_output_429_0 = ( saturate( 2.0f*blendOpDest429*blendOpSrc429 + blendOpDest429*blendOpDest429*(1.0f - 2.0f*blendOpSrc429) ));
				float4 temp_cast_73 = (step( temp_output_429_0 , -0.23 )).xxxx;
				float4 blendOpSrc1541 = ( ( 1.0 - temp_output_429_0 ) * _EdgeShadowColor );
				float4 blendOpDest1541 = ( temp_output_429_0 * _ShadowColor );
				float4 blendOpSrc1543 = temp_cast_73;
				float4 blendOpDest1543 = ( saturate( max( blendOpSrc1541, blendOpDest1541 ) ));
				float4 lerpBlendMode1543 = lerp(blendOpDest1543,max( blendOpSrc1543, blendOpDest1543 ),temp_output_429_0);
				float4 lerpResult1544 = lerp( float4( 1,1,1,1 ) , ( saturate( lerpBlendMode1543 )) , ( 1.0 - step( temp_output_429_0 , 0.0 ) ));
				float4 Shadows428 = lerpResult1544;
				float4 temp_cast_74 = (1.0).xxxx;
				float4 lerpResult1010 = lerp( Shadows428 , temp_cast_74 , Out_or_InBrume606);
				float4 temp_output_705_0 = ( AllAlbedo2113 * lerpResult1010 );
				float In01562 = FakeLightsPositionsArray[0].x;
				float3 WorldPos1562 = WorldPosition;
				float Length1562 = _FakeLightArrayLength;
				float mulTime1558 = _TimeParameters.x * _WaveFakeLight_Time;
				float lerpResult1556 = lerp( _WaveFakeLight_Max , _WaveFakeLight_Min , cos( mulTime1558 ));
				float temp_output_1560_0 = ( lerpResult1556 * _FakeLightStep );
				float LightStep1562 = temp_output_1560_0;
				float LightStepAttenuation1562 = ( temp_output_1560_0 + _FakeLightStepAttenuation );
				float localCycleThroughArray1562 = CycleThroughArray1562( In01562 , WorldPos1562 , Length1562 , LightStep1562 , LightStepAttenuation1562 );
				float FakeLights1547 = saturate( localCycleThroughArray1562 );
				float4 lerpResult1565 = lerp( temp_output_705_0 , ( temp_output_705_0 + _FakeLight_Color ) , FakeLights1547);
				float4 lerpResult2146 = lerp( temp_output_705_0 , lerpResult1565 , _FakeLights);
				float4 temp_cast_76 = (normal_LightDir140).xxxx;
				float LightDebug608 = _LightDebug;
				float4 lerpResult282 = lerp( lerpResult2146 , temp_cast_76 , LightDebug608);
				float NormalDebug610 = _NormalDebug;
				float4 lerpResult286 = lerp( lerpResult282 , AllNormal2114 , NormalDebug610);
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = lerpResult286.rgb;
				float Alpha = 1;
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
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ShadowColor;
			float4 _T3_ColorCorrection;
			float4 _T6_ColorCorrection;
			float4 _T5_ColorCorrection;
			float4 _T1_ColorCorrection;
			float4 _EdgeShadowColor;
			float4 _FakeLight_Color;
			float4 _T7_ColorCorrection;
			float4 _T2_ColorCorrection;
			float4 _TerrainMask_TextureSampler2_ST;
			float4 _T4_ColorCorrection;
			float4 _TerrainMask_TextureSampler1_ST;
			float2 _ShadowNoisePanner;
			float _T6_AnimatedGrunge_Multiply;
			float _T6_AnimatedGrunge_Flipbook_Columns;
			float _T6_AnimatedGrunge_Flipbook_Speed;
			float _T6_AnimatedGrunge;
			float _T6_AnimatedGrunge_Flipbook_Rows;
			float _T6_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Contrast;
			float _T5_Albedo_ProceduralTiling;
			float _T6_AnimatedGrunge_Tiling;
			float _T6_AnimatedGrunge_Contrast;
			float _T5_Albedo_Tiling;
			float _T5_AnimatedGrunge;
			float _T5_AnimatedGrunge_Multiply;
			float _T5_IsGrungeAnimated;
			float _T5_AnimatedGrunge_Flipbook_Speed;
			float _T5_AnimatedGrunge_Flipbook_Rows;
			float _T5_AnimatedGrunge_Flipbook_Columns;
			float _T6_AnimatedGrunge_ScreenBased;
			float _T6_Albedo_Tiling;
			float _T7_AnimatedGrunge_ScreenBased;
			float _T7_AnimatedGrunge_Contrast;
			float _FakeLights;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _WaveFakeLight_Max;
			float _FakeLightArrayLength;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _T6_Albedo_ProceduralTiling;
			float _StepAttenuation;
			float _T7_Albedo_ProceduralTiling;
			float _T7_Albedo_Tiling;
			float _T7_AnimatedGrunge;
			float _T7_AnimatedGrunge_Multiply;
			float _T7_IsGrungeAnimated;
			float _T7_AnimatedGrunge_Flipbook_Speed;
			float _T7_AnimatedGrunge_Flipbook_Rows;
			float _T7_AnimatedGrunge_Flipbook_Columns;
			float _T7_AnimatedGrunge_Tiling;
			float _StepShadow;
			float _T5_AnimatedGrunge_ScreenBased;
			float _T4_Albedo_ProceduralTiling;
			float _T5_AnimatedGrunge_Contrast;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_IsGrungeAnimated;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _T2_AnimatedGrunge_ScreenBased;
			float _T2_AnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Contrast;
			float _DebugVertexPaint;
			float _DebugTextureTiling;
			float _T2_AnimatedGrunge;
			float _Out_or_InBrume;
			float _T1_Albedo_ProceduralTiling;
			float _T1_Albedo_Tiling;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_AnimatedGrunge_ScreenBased;
			float _T1_AnimatedGrunge_Tiling;
			float _GrayscaleDebug;
			float _T5_AnimatedGrunge_Tiling;
			float _T2_Albedo_Contrast;
			float _T2_Albedo_ProceduralTiling;
			float _LightDebug;
			float _T4_Albedo_Tiling;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_IsGrungeAnimated;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_AnimatedGrunge_Tiling;
			float _T2_Albedo_Tiling;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_Albedo_Tiling;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _T3_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_Contrast;
			float _T3_Albedo_ProceduralTiling;
			float _NormalDebug;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
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

				
				float Alpha = 1;
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
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ShadowColor;
			float4 _T3_ColorCorrection;
			float4 _T6_ColorCorrection;
			float4 _T5_ColorCorrection;
			float4 _T1_ColorCorrection;
			float4 _EdgeShadowColor;
			float4 _FakeLight_Color;
			float4 _T7_ColorCorrection;
			float4 _T2_ColorCorrection;
			float4 _TerrainMask_TextureSampler2_ST;
			float4 _T4_ColorCorrection;
			float4 _TerrainMask_TextureSampler1_ST;
			float2 _ShadowNoisePanner;
			float _T6_AnimatedGrunge_Multiply;
			float _T6_AnimatedGrunge_Flipbook_Columns;
			float _T6_AnimatedGrunge_Flipbook_Speed;
			float _T6_AnimatedGrunge;
			float _T6_AnimatedGrunge_Flipbook_Rows;
			float _T6_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Contrast;
			float _T5_Albedo_ProceduralTiling;
			float _T6_AnimatedGrunge_Tiling;
			float _T6_AnimatedGrunge_Contrast;
			float _T5_Albedo_Tiling;
			float _T5_AnimatedGrunge;
			float _T5_AnimatedGrunge_Multiply;
			float _T5_IsGrungeAnimated;
			float _T5_AnimatedGrunge_Flipbook_Speed;
			float _T5_AnimatedGrunge_Flipbook_Rows;
			float _T5_AnimatedGrunge_Flipbook_Columns;
			float _T6_AnimatedGrunge_ScreenBased;
			float _T6_Albedo_Tiling;
			float _T7_AnimatedGrunge_ScreenBased;
			float _T7_AnimatedGrunge_Contrast;
			float _FakeLights;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _WaveFakeLight_Max;
			float _FakeLightArrayLength;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _T6_Albedo_ProceduralTiling;
			float _StepAttenuation;
			float _T7_Albedo_ProceduralTiling;
			float _T7_Albedo_Tiling;
			float _T7_AnimatedGrunge;
			float _T7_AnimatedGrunge_Multiply;
			float _T7_IsGrungeAnimated;
			float _T7_AnimatedGrunge_Flipbook_Speed;
			float _T7_AnimatedGrunge_Flipbook_Rows;
			float _T7_AnimatedGrunge_Flipbook_Columns;
			float _T7_AnimatedGrunge_Tiling;
			float _StepShadow;
			float _T5_AnimatedGrunge_ScreenBased;
			float _T4_Albedo_ProceduralTiling;
			float _T5_AnimatedGrunge_Contrast;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_IsGrungeAnimated;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _T2_AnimatedGrunge_ScreenBased;
			float _T2_AnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Contrast;
			float _DebugVertexPaint;
			float _DebugTextureTiling;
			float _T2_AnimatedGrunge;
			float _Out_or_InBrume;
			float _T1_Albedo_ProceduralTiling;
			float _T1_Albedo_Tiling;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_AnimatedGrunge_ScreenBased;
			float _T1_AnimatedGrunge_Tiling;
			float _GrayscaleDebug;
			float _T5_AnimatedGrunge_Tiling;
			float _T2_Albedo_Contrast;
			float _T2_Albedo_ProceduralTiling;
			float _LightDebug;
			float _T4_Albedo_Tiling;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_IsGrungeAnimated;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_AnimatedGrunge_Tiling;
			float _T2_Albedo_Tiling;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_Albedo_Tiling;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _T3_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_Contrast;
			float _T3_Albedo_ProceduralTiling;
			float _NormalDebug;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
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

				
				float Alpha = 1;
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
1920;0;1920;1019;9163.439;6289.698;3.443749;False;False
Node;AmplifyShaderEditor.CommentaryNode;1789;-17944.25,-7175.124;Inherit;False;5780.957;10318.64;TextureSampler1;6;587;2071;1014;750;746;1013;TextureSampler1;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2058;-12061.29,-7163.483;Inherit;False;5720.846;8062.69;TextureSampler2;5;2072;699;1665;1790;1987;TextureSampler2;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1373;-6187.331,-7159.941;Inherit;False;8733.113;3265.513;OTHER VARIABLES;7;1567;30;28;2117;588;604;39;OTHER VARIABLES;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1014;-17890.07,-1290.168;Inherit;False;5654.577;1921.887;TEXTURE 4;4;1029;1018;1019;1787;;0,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1790;-12016.19,-5242.802;Inherit;False;5605.832;1863.768;TEXTURE 6;4;1800;1793;1792;1791;;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1665;-12011.01,-7113.483;Inherit;False;5608.046;1831.389;TEXTURE 5;4;1671;1667;1666;1788;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;750;-17903.51,-5158.311;Inherit;False;5683.081;1879.325;TEXTURE 2;4;760;752;753;1785;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;746;-17903.68,-7125.124;Inherit;False;5694.134;1925.637;TEXTURE 1;4;749;42;740;1784;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1013;-17894.02,-3225.865;Inherit;False;5665.812;1878.791;TEXTURE 3;4;1044;1016;1017;1786;;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1987;-12008.89,-3305.615;Inherit;False;5605.832;1863.768;TEXTURE 7;4;1996;1990;1989;1988;;0,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-16466.21,-7075.124;Inherit;False;3377.736;1797.994;Paper + Object Texture;5;190;202;730;718;616;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;752;-17822.68,-4990.223;Inherit;False;1264.346;1085.74;Texture Arrays 2;2;757;763;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1016;-17813.19,-3057.777;Inherit;False;1269.42;1074.732;Texture Arrays 3;2;1022;1034;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1018;-16452.6,-1240.168;Inherit;False;3377.075;1801.395;Paper + Object Texture;5;1064;1122;1026;1030;1024;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1990;-11928.06,-3137.528;Inherit;False;1271.964;1071.483;Texture Arrays 7;2;1994;1993;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1792;-10578.72,-5192.803;Inherit;False;3329.94;1776.01;Paper + Object Texture;5;1803;1870;1799;1795;1794;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1989;-10571.42,-3255.616;Inherit;False;3329.94;1776.01;Paper + Object Texture;5;2054;2053;1995;1992;1991;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-6137.331,-7109.941;Inherit;False;5639.813;1022.403;Shadow Smooth Edge + Int Shadow;27;1521;420;356;428;431;422;427;426;430;435;425;408;421;432;429;424;416;406;43;1538;1539;1540;1541;1543;1544;1545;1546;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1019;-17809.24,-1122.08;Inherit;False;1271.272;1072.784;Texture Arrays 4;2;1027;1025;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1667;-11930.18,-6945.395;Inherit;False;1265.848;1079.134;Texture Arrays 5;2;1673;1672;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;740;-17822.85,-6957.036;Inherit;False;1269.77;1080.054;Texture Arrays 1;2;27;736;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1793;-11935.36,-5074.713;Inherit;False;1271.964;1071.483;Texture Arrays 6;2;1798;1797;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1666;-10573.55,-7063.483;Inherit;False;3321.528;1744.332;Paper + Object Texture;5;1747;1695;1674;1668;1669;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1017;-16456.54,-3175.865;Inherit;False;3369.413;1764.315;Paper + Object Texture;5;1107;1187;1039;1032;1037;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;753;-16466.04,-5108.311;Inherit;False;3331.515;1774.371;Paper + Object Texture;5;816;912;764;762;756;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1996;-11736.24,-1984.289;Inherit;False;863.1523;325.855;Texture4_Final;5;2037;2036;2014;2007;2006;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1992;-10513.22,-3170.647;Inherit;False;2635.696;674.9272;Animated Grunge;24;2038;2032;2031;2030;2029;2028;2027;2026;2025;2024;2013;2012;2011;2010;2009;2008;2005;2004;2003;2001;2000;1999;1998;1997;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1993;-11877.76,-3087.527;Inherit;False;1178.062;699.5752;Textures;8;2057;2021;2020;2019;2018;2016;2015;2002;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;757;-17772.37,-4940.221;Inherit;False;1178.062;699.5752;Textures;8;881;876;866;865;863;858;857;855;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;604;-2887.942,-6015.234;Inherit;False;684.4763;593.2962;Global Variables;10;564;281;423;605;606;610;613;614;608;566;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1994;-11878.06,-2365.829;Inherit;False;1173.241;279.6689;Grunges;3;2056;2023;2022;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2071;-17887.3,668.158;Inherit;False;2291.332;2427.631;All Normal by Vertex Color;38;644;2142;2141;2140;1411;1398;1408;1413;1396;1410;1386;635;1399;1406;1414;1405;1416;1403;1400;1382;139;1404;1383;1397;1402;690;1380;640;694;642;691;632;693;1412;692;1473;1415;1409;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1800;-11743.53,-3921.475;Inherit;False;863.1523;325.855;Texture4_Final;5;1878;1868;1866;1811;1805;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1991;-10518.72,-2462.372;Inherit;False;2619.777;630.8765;Albedo;14;2052;2051;2050;2049;2048;2047;2046;2045;2044;2043;2042;2041;2040;2039;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1044;-17625.92,-1879.529;Inherit;False;863.1523;325.855;Texture3_Final;5;1214;1199;1198;1196;1195;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1995;-10521.18,-1813.024;Inherit;False;515.4902;301.2971;FinalPass;2;2055;2033;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1799;-10528.48,-3750.21;Inherit;False;515.4902;301.2971;FinalPass;2;1836;1810;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;760;-17638.2,-3822.67;Inherit;False;863.1523;325.855;Texture2_Final;5;872;871;870;869;868;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1784;-13043.95,-7062.844;Inherit;False;743.873;168.3657;IN_BRUME;3;1475;1477;1476;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;730;-16418.84,-5608.517;Inherit;False;554.751;290.8408;FinalPass;2;187;301;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;764;-16411.05,-4322.113;Inherit;False;2593.267;623.7134;Albedo;16;920;923;1458;886;889;1459;1392;1436;888;1438;1378;906;1437;903;825;905;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1039;-16395.89,-1733.049;Inherit;False;523.9512;283.8408;FinalPass;2;1119;1211;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-405.1875,-7087.588;Inherit;False;2817.218;723.9179;Final Mix;19;2;1512;1563;1564;294;1565;282;705;609;1566;286;1010;698;611;1012;280;704;2146;2147;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2117;-6111.803,-4240.267;Inherit;False;611.4397;267.6733;Mix Albedo and Normals;4;2114;2112;2113;2109;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1032;-16398.33,-2390.421;Inherit;False;2623.941;630.8765;Albedo;14;1124;1390;1377;1128;1126;1113;1092;1094;1185;1085;1084;1439;1440;1441;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1791;-7199.454,-5182.325;Inherit;False;743.873;168.3647;IN_BRUME;3;1887;1886;1885;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1794;-10526.02,-4399.559;Inherit;False;2619.777;630.8765;Albedo;14;1880;1874;1867;1862;1853;1851;1838;1828;1827;1815;1814;1813;1812;1804;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1798;-11885.36,-4303.016;Inherit;False;1173.241;279.6689;Grunges;3;1859;1802;1820;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1797;-11885.05,-5024.712;Inherit;False;1178.062;699.5752;Textures;8;1883;1882;1881;1879;1863;1848;1833;1832;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1026;-16390.78,-444.2103;Inherit;False;2619.777;630.8765;Albedo;14;1376;1125;1134;1389;1103;1051;1083;1072;1175;1079;1074;1442;1443;1444;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1795;-10520.52,-5107.833;Inherit;False;2635.696;674.9272;Animated Grunge;24;1884;1877;1876;1875;1873;1872;1869;1861;1860;1858;1852;1847;1845;1844;1843;1835;1834;1831;1826;1825;1823;1817;1808;1801;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;588;-6126.578,-5344.56;Inherit;False;1267.933;1006.26;Debug Textures;14;479;594;590;592;596;598;593;597;477;563;559;488;595;478;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-6067.668,-6834.708;Inherit;False;1385.351;464.59;Normal Light Dir;7;140;169;413;414;411;358;412;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;749;-17630.58,-5746.598;Inherit;False;863.1523;325.855;Texture1_Final;5;748;274;349;340;607;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1988;-7192.16,-3245.138;Inherit;False;743.873;168.3647;IN_BRUME;3;2035;2034;2017;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;756;-16407.84,-5023.34;Inherit;False;2635.696;674.9272;Animated Grunge;24;919;918;917;910;909;908;907;891;890;885;884;882;854;841;822;821;820;819;1428;1429;1427;1460;1461;1462;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;587;-15552.95,676.9994;Inherit;False;2991.792;1273.124;Texture Set by Vertex Color;27;2131;2130;622;1;586;573;581;570;495;574;576;579;489;1472;585;14;577;578;580;11;565;584;567;571;569;583;2132;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1669;-10512.24,-6276.363;Inherit;False;2619.777;630.8765;Albedo;14;1742;1721;1715;1714;1707;1706;1705;1704;1703;1694;1686;1684;1678;1677;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-6130.754,-6013.038;Inherit;False;3145.105;593.8924;Noise;18;159;365;162;386;180;218;363;197;170;128;142;176;359;362;157;168;703;741;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1025;-17759.24,-350.3804;Inherit;False;1179.63;282.5477;Grunges;3;1077;1115;1111;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1674;-10515.37,-5623.001;Inherit;False;535.4639;272.208;FinalPass;2;1761;1734;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;718;-16408.01,-6990.155;Inherit;False;2635.696;674.9272;Animated Grunge;24;318;224;717;716;403;381;156;146;127;132;130;175;150;163;167;179;158;208;1422;1423;1424;1463;1464;1465;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1671;-11710,-5788.989;Inherit;False;863.1523;325.855;Texture4_Final;5;1746;1722;1709;1708;1675;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1785;-13108.45,-5105.941;Inherit;False;745.873;168.365;IN_BRUME;3;1478;1480;1479;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1786;-13034.69,-3149.755;Inherit;False;743.873;168.3651;IN_BRUME;3;1482;1481;1483;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1034;-17762.88,-3007.777;Inherit;False;1178.062;699.5752;Textures;8;1363;1362;1206;1204;1203;1178;1164;1090;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;736;-17772.85,-6185.338;Inherit;False;1171.739;277.2114;Grunges;3;268;1986;700;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1788;-7205.504,-7054.322;Inherit;False;743.873;168.3647;IN_BRUME;3;1757;1755;1724;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;763;-17772.68,-4218.523;Inherit;False;1172.837;290.5126;Grunges;3;880;856;867;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1567;-4768.432,-5342.527;Inherit;False;1925.334;901.1771;FAKE LIGHTS;16;1559;1551;1562;1561;1560;1558;1557;1556;1555;1554;1553;1552;1550;1549;1548;1547;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1029;-17563.34,58.84139;Inherit;False;863.1523;325.855;Texture4_Final;5;1367;1364;1118;1050;1049;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1022;-17763.19,-2286.08;Inherit;False;1173.247;289.2933;Grunges;3;1091;1241;1205;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;762;-16416.74,-3662.759;Inherit;False;505.3994;283.5702;FinalPass;2;839;806;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1672;-11879.87,-6895.394;Inherit;False;1178.062;699.5752;Textures;8;1743;1739;1737;1732;1731;1729;1698;1682;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1673;-11880.18,-6173.697;Inherit;False;1177.333;282.2089;Grunges;3;1748;1756;1759;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2072;-10452.33,-1400.655;Inherit;False;2117.7;1375.577;Texture Set by Vertex Color;24;2129;2128;2095;2087;2086;2091;2094;2073;2092;2093;2081;2079;2083;2082;2080;2078;2076;2075;2090;2089;2084;2139;2144;2145;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1024;-16390.82,224.5917;Inherit;False;516.335;290.4478;FinalPass;2;1120;1121;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1787;-13020.39,-1231.645;Inherit;False;743.873;168.365;IN_BRUME;3;1484;1485;1486;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1027;-17758.93,-1072.079;Inherit;False;1178.062;699.5752;Textures;8;1146;1145;1144;1143;1132;1068;1057;1047;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;616;-16411.27,-6275.572;Inherit;False;2537.716;636.7236;Albedo;14;191;709;621;335;1385;1379;252;615;399;617;619;1433;1434;1435;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1037;-16398.35,-3090.896;Inherit;False;2635.696;674.9272;Animated Grunge;24;1191;1186;1161;1160;1156;1154;1152;1130;1112;1110;1109;1104;1089;1087;1086;1082;1081;1080;1445;1446;1447;1467;1468;1466;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-17772.54,-6907.036;Inherit;False;1178.062;699.5752;Textures;8;50;172;71;74;177;708;706;133;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;699;-12006.91,-1405.192;Inherit;False;1516.468;2254.259;All Normal by Vertex Color;29;2070;2060;2069;2068;2067;2066;2065;2061;2063;2064;2062;2059;1765;1766;1764;1767;1762;1763;2097;2098;2099;2100;2101;2103;2104;2105;2106;2107;2138;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1668;-10515.35,-6978.513;Inherit;False;2635.696;674.9272;Animated Grunge;24;1760;1754;1753;1751;1750;1749;1745;1736;1728;1727;1725;1720;1719;1717;1716;1712;1711;1702;1699;1696;1693;1691;1690;1680;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1030;-16394.4,-1155.198;Inherit;False;2635.696;674.9272;Animated Grunge;24;1173;1162;1159;1158;1157;1155;1150;1141;1129;1097;1078;1075;1069;1067;1066;1061;1060;1046;1451;1452;1453;1469;1470;1471;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCGrayscale;403;-14715.35,-6941.507;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1199;-17561.54,-1744.323;Inherit;False;1482;T3_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1484;-12739.39,-1179.28;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1082;-15880.3,-2505.821;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;179;-15652.95,-6673.559;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;816;-13379.55,-4271.403;Inherit;False;T2_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1470;-16048.16,-958.8477;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1437;-15125.14,-4265.237;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1173;-15034.8,-1108.436;Inherit;True;Property;_TextureSample50;Texture Sample 50;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1205;-16868.55,-2212.536;Inherit;False;T3_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1471;-15838.32,-1076.605;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1159;-16017.35,-817.1217;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Columns;T4_AnimatedGrunge_Flipbook_Columns;66;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1463;-16057.99,-6798.279;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;1060;-16123.3,-1079.874;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1392;-15965.08,-4084.748;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;906;-15726.77,-4270.57;Inherit;True;Procedural Sample;-1;;165;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;870;-17573.82,-3687.464;Inherit;False;1480;T2_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1476;-12755.95,-7003.478;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1444;-15119.69,-389.0103;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;923;-15101.62,-4115.349;Inherit;False;Property;_T2_ColorCorrection;T2_ColorCorrection;32;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;903;-14811.62,-4249.347;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;912;-13662.83,-4272.259;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;856;-16878.04,-4144.979;Inherit;False;T2_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;910;-14504.9,-4747.679;Inherit;False;Property;_T2_AnimatedGrunge_Multiply;T2_AnimatedGrunge_Multiply;44;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;825;-16334.46,-4270.737;Inherit;True;881;TA_2_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;1465;-15827.15,-6920.036;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;839;-16142.13,-3598.899;Inherit;False;T2_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;857;-17688.39,-4518.897;Inherit;False;Constant;_Float50;Float 50;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1439;-15718.95,-2017.633;Inherit;True;Property;_TextureSample29;Texture Sample 29;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1241;-17242.55,-2213.536;Inherit;True;Property;_TA_3_Grunges_Sample;TA_3_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1486;-12970.39,-1180.28;Inherit;False;1120;T4_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1107;-13658.08,-2343.796;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1475;-12988.95,-7003.478;Inherit;False;187;T1_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1479;-13058.45,-5053.577;Inherit;False;839;T2_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;889;-16099.36,-4185.813;Inherit;False;Constant;_Float26;Float 26;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1064;-13651.88,-394.2196;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1481;-12753.69,-3097.39;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1160;-16021.3,-2752.821;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Columns;T3_AnimatedGrunge_Flipbook_Columns;53;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;-17262.34,-6829.561;Inherit;True;Property;_TA_1_Textures_Sample;TA_1_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;ef1e633c4c2c51641bd59a932b55b28a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1067;-16353.3,-903.8737;Inherit;False;Property;_T4_AnimatedGrunge_Tiling;T4_AnimatedGrunge_Tiling;65;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1367;-17498.96,194.0474;Inherit;False;1485;T4_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1986;-16884.83,-6112.05;Inherit;False;T1_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1483;-12984.69,-3098.39;Inherit;False;1119;T3_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;888;-16370.8,-4041.203;Inherit;False;Property;_T2_Albedo_Tiling;T2_Albedo_Tiling;35;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1477;-12527.08,-7005.844;Inherit;False;T1_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1376;-16140.22,-165.9164;Inherit;False;T4_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-16030.96,-6652.079;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Columns;T1_AnimatedGrunge_Flipbook_Columns;26;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1081;-15319.98,-3015.02;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1132;-16853.08,-990.9907;Inherit;False;T4_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-15668.81,-6840.453;Inherit;False;Property;_T1_IsGrungeAnimated;T1_IsGrungeAnimated?;23;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;163;-16360.91,-6914.831;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1453;-13966.32,-694.7377;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-17687.55,-6408.712;Inherit;False;Constant;_Float63;Float 63;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1089;-16019.3,-2603.821;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Speed;T3_AnimatedGrunge_Flipbook_Speed;55;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1443;-15418.97,-273.0653;Inherit;False;Property;_T4_Albedo_ProceduralTiling;T4_Albedo_ProceduralTiling?;60;0;Create;True;0;0;False;0;False;0;0.225;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1112;-14713.69,-3038.249;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1485;-12510.52,-1181.645;Inherit;False;T4_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;208;-15889.96,-6405.079;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1057;-17704.33,-790.7507;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;127;-16029.96,-6578.079;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Rows;T1_AnimatedGrunge_Flipbook_Rows;27;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1075;-15207.82,-949.2727;Inherit;False;Constant;_Float28;Float 28;87;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1069;-15316.03,-1079.321;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1155;-14801.39,-852.7267;Inherit;False;Property;_T4_AnimatedGrunge_Contrast;T4_AnimatedGrunge_Contrast;69;0;Create;True;0;0;False;0;False;1.58;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-14213.07,-6937.494;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1079;-14538.38,-371.4454;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1049;-17500.87,272.6964;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1441;-15115.66,-2344.266;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;177;-17263.9,-6636.454;Inherit;True;Property;_TextureSample57;Texture Sample 57;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;158;-15329.64,-6914.278;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-17575.58,-5691.792;Inherit;False;187;T1_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1118;-17508.34,113.6475;Inherit;False;1120;T4_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-17717.94,-6625.708;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1424;-14143.7,-6575.377;Inherit;False;Constant;_Float46;Float 46;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;716;-14484,-6937.684;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;708;-17480.95,-6830.558;Inherit;False;TA_1_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;1423;-13947.92,-6540.259;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1364;-16919.19,112.8414;Inherit;False;Texture4_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1175;-16314.19,-392.8343;Inherit;True;1146;TA_4_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1046;-15972.3,-1078.874;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1187;-13340.51,-2342.94;Inherit;False;T3_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1122;-13334.32,-393.3636;Inherit;False;T4_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;571;-15492.5,1159.636;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-16117.23,-5544.609;Inherit;False;T1_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1072;-16332.53,-166.3014;Inherit;False;Property;_T4_Albedo_Tiling;T4_Albedo_Tiling;61;0;Create;True;0;0;False;0;False;1;32.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;621;-16387.02,-5998.662;Inherit;False;Property;_T1_Albedo_Tiling;T1_Albedo_Tiling;21;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1214;-16981.77,-1825.529;Inherit;False;Texture3_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1434;-15125.99,-6241.639;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1113;-14251.1,-2218.159;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1074;-13969.64,-369.6343;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;706;-17752.37,-6830.849;Inherit;True;Property;_TA_1_Textures_and_Grunges;TA_1_Textures_and_Grunges;18;0;Create;True;0;0;False;1;Header(Texture 1 VertexPaintBlack);False;ef1e633c4c2c51641bd59a932b55b28a;None;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-13325.17,-6243.724;Inherit;False;T1_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1198;-17570.92,-1824.723;Inherit;False;1119;T3_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;617;-15726.99,-6224.029;Inherit;True;Procedural Sample;-1;;162;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;1482;-12524.81,-3099.755;Inherit;False;T3_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;700;-17250.68,-6112.919;Inherit;True;Property;_TA_1_Grunges_Sample;TA_1_Grunges_Sample;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;167;-16136.91,-6914.831;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1385;-15969.03,-6042.074;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;1141;-15876.35,-570.1216;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1458;-14740.2,-4001.752;Inherit;False;Property;_T2_Albedo_Contrast;T2_Albedo_Contrast;33;0;Create;True;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1379;-16204.31,-5998.966;Inherit;False;T1_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1085;-13977.19,-2315.845;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;615;-14329.72,-6030.643;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;268;-17704.77,-6064.788;Inherit;False;Constant;_Float71;Float 71;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;567;-15499.94,875.9882;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;190;-13642.73,-6244.58;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;584;-14483.15,1627.822;Inherit;False;479;DebugColor4;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1084;-16086.64,-2254.121;Inherit;False;Constant;_Float7;Float 7;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1466;-16042.27,-2888.555;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1150;-15655.2,-1001.128;Inherit;False;Property;_T4_IsGrungeAnimated;T4_IsGrungeAnimated?;63;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;252;-14328.26,-6115.676;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-16371.98,-5545.32;Inherit;True;202;T1_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;191;-14054.35,-6213.362;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;920;-14265.28,-4064.818;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1435;-15425.27,-6125.694;Inherit;False;Property;_T1_Albedo_ProceduralTiling;T1_Albedo_ProceduralTiling?;20;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1196;-17296.34,-1820.279;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1103;-14245.01,-186.9154;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1120;-16110.38,291.3807;Inherit;False;T4_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-14623.09,-6215.172;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1396;-16787.78,1063.353;Inherit;False;T2_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1390;-15973.7,-2156.709;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-17688.55,-6485.712;Inherit;False;Constant;_Float53;Float 53;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1442;-15722.98,-62.37748;Inherit;True;Property;_TextureSample30;Texture Sample 30;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1051;-14243.55,-271.9484;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;709;-16334.68,-6224.196;Inherit;True;708;TA_1_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;318;-14499.07,-6692.494;Inherit;False;Property;_T1_AnimatedGrunge_Multiply;T1_AnimatedGrunge_Multiply;30;0;Create;True;0;0;False;0;False;1.58;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1377;-16177.85,-2112.153;Inherit;False;T3_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1124;-15714.05,-2338.878;Inherit;True;Procedural Sample;-1;;164;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;748;-16986.43,-5692.598;Inherit;False;Texture1_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;607;-17568.11,-5532.743;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1469;-16364.32,-793.6047;Inherit;False;Property;_T4_AnimatedGrunge_ScreenBased;T4_AnimatedGrunge_ScreenBased?;64;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;717;-14800,-6697.684;Inherit;False;Property;_T1_AnimatedGrunge_Contrast;T1_AnimatedGrunge_Contrast;29;0;Create;True;0;0;False;0;False;1.58;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1083;-16079.09,-307.9102;Inherit;False;Constant;_Float30;Float 30;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1363;-17714.13,-2932.59;Inherit;True;Property;_TA_3_Textures_and_Grunges;TA_3_Textures_and_Grunges;45;0;Create;True;0;0;False;1;Header(Texture 3 VertexPaintGreen);False;ef1e633c4c2c51641bd59a932b55b28a;0556bc6f8449b5645a36bdb589f4767d;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;1068;-17674.95,-650.7546;Inherit;False;Constant;_Float15;Float 15;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1090;-17471.29,-2931.299;Inherit;False;TA_3_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TFHCGrayscale;905;-14263.82,-4149.851;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1378;-16183.07,-4041.08;Inherit;False;T2_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1438;-15424.42,-4150.292;Inherit;False;Property;_T2_Albedo_ProceduralTiling;T2_Albedo_ProceduralTiling?;34;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1126;-14835.93,-2183.656;Inherit;False;Property;_T3_ColorCorrection;T3_ColorCorrection;46;0;Create;True;0;0;False;0;False;1,1,1,0;0.8867924,0.8867924,0.8867924,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1185;-16321.74,-2339.045;Inherit;True;1090;TA_3_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.FunctionNode;1125;-15706.5,-392.6673;Inherit;True;Procedural Sample;-1;;163;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;1128;-14252.56,-2133.126;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;399;-14913.09,-6081.173;Inherit;False;Property;_T1_ColorCorrection;T1_ColorCorrection;19;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;619;-16099.58,-6139.272;Inherit;False;Constant;_Float4;Float 4;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1436;-15728.43,-3938.604;Inherit;True;Property;_TextureSample28;Texture Sample 28;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;1459;-14463.57,-4247.83;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1119;-16118.29,-1670.141;Inherit;False;T3_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;917;-16360.74,-4948.017;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1077;-17674.17,-225.3284;Inherit;False;Constant;_Float29;Float 29;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1094;-14545.93,-2317.655;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1433;-15729.28,-5915.006;Inherit;True;Property;_TextureSample27;Texture Sample 27;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1091;-17648.11,-2164.028;Inherit;False;Constant;_Float32;Float 32;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;886;-13989.91,-4247.537;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;381;-15048.41,-6943.393;Inherit;True;Property;_TextureSample67;Texture Sample 67;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;880;-17679.91,-4099.271;Inherit;False;Constant;_Float52;Float 52;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1134;-14828.38,-237.4464;Inherit;False;Property;_T4_ColorCorrection;T4_ColorCorrection;59;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;866;-17725.2,-4865.035;Inherit;True;Property;_TA_2_Textures_and_Grunges;TA_2_Textures_and_Grunges;31;0;Create;True;0;0;False;1;Header(Texture 2 VertexPaintRed);False;ef1e633c4c2c51641bd59a932b55b28a;2b6e729c66a58e64e9da60628e5652f1;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;1389;-15938.13,-208.4784;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1121;-16343.96,287.7885;Inherit;True;1122;T4_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1440;-15414.94,-2228.321;Inherit;False;Property;_T3_Albedo_ProceduralTiling;T3_Albedo_ProceduralTiling?;47;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1092;-16365.08,-2111.511;Inherit;False;Property;_T3_Albedo_Tiling;T3_Albedo_Tiling;48;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1478;-12825.45,-5053.577;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1146;-17467.34,-995.6006;Inherit;False;TA_4_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;865;-17262.17,-4862.747;Inherit;True;Property;_TA_2_Textures_Sample;TA_2_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2025;-10483.14,-2809.053;Inherit;False;Property;_T7_AnimatedGrunge_ScreenBased;T7_AnimatedGrunge_ScreenBased?;103;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2022;-11357.42,-2293.285;Inherit;True;Property;_TA_7_Grunges_Sample;TA_7_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;2011;-10466.13,-3095.322;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2031;-8638.29,-2865.983;Inherit;False;Property;_T7_AnimatedGrunge_Multiply;T7_AnimatedGrunge_Multiply;109;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2050;-9850.929,-2080.54;Inherit;True;Property;_TextureSample35;Texture Sample 35;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2020;-11369.12,-2816.944;Inherit;True;Property;_TextureSample36;Texture Sample 36;70;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2019;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2013;-10166.99,-2974.295;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;2093;-9431.959,-822.0974;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2023;-10983.42,-2292.285;Inherit;False;T7_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2081;-9118.869,-346.0554;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2101;-11111.39,652.1433;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2098;-11044.85,454.5415;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2078;-9919.919,-1086.906;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2038;-9153.627,-3123.885;Inherit;True;Property;_TextureSample38;Texture Sample 38;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2022;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;2044;-10066.08,-2226.641;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2046;-10207.04,-2326.071;Inherit;False;Constant;_Float19;Float 19;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;2000;-9758.167,-2854.049;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;2076;-10391.89,-969.9653;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;2043;-9834.447,-2410.829;Inherit;True;Procedural Sample;-1;;166;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.LerpOp;2001;-9434.856,-3094.769;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2055;-10239.26,-1750.207;Inherit;False;T7_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1143;-17248.73,-994.6036;Inherit;True;Property;_TA_4_Textures_Sample;TA_4_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2029;-10134.18,-2683.569;Inherit;False;Property;_T7_AnimatedGrunge_Flipbook_Speed;T7_AnimatedGrunge_Flipbook_Speed;107;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2042;-9247.638,-2407.172;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1999;-9957.146,-3092.053;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;2030;-8920.218,-2868.174;Inherit;False;Property;_T7_AnimatedGrunge_Contrast;T7_AnimatedGrunge_Contrast;108;0;Create;True;0;0;False;0;False;1.58;1.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1066;-14229.46,-1102.537;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2012;-9326.646,-2964.72;Inherit;False;Constant;_Float14;Float 14;87;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2037;-11092.09,-1930.288;Inherit;False;Texture7_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;2008;-8614.221,-3118.176;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;2005;-9995.177,-2585.57;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1997;-10091.13,-3094.322;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;2003;-8832.57,-3122.998;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;2010;-10242.13,-3095.322;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2092;-9874.819,-707.0643;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2028;-10135.18,-2758.569;Inherit;False;Property;_T7_AnimatedGrunge_Flipbook_Rows;T7_AnimatedGrunge_Flipbook_Rows;106;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2040;-8666.331,-2389.607;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2026;-9774.026,-3016.576;Inherit;False;Property;_T7_IsGrungeAnimated;T7_IsGrungeAnimated?;102;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2075;-10147.7,-1062.184;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2128;-9964.095,-272.7218;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2139;-10321.15,-1238.443;Inherit;False;622;AllAlbedo_TextureSampler1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;2094;-9504.77,-674.2573;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2107;-11915.26,552.5293;Inherit;True;Property;_TextureSample34;Texture Sample 34;2;0;Create;True;0;0;False;0;False;-1;5f7dc751ae860b74f924a9351582963f;5f7dc751ae860b74f924a9351582963f;True;0;False;white;Auto;False;Instance;2095;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2129;-9343.353,-279.0728;Inherit;False;TextureSampler2_AlphaMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2070;-10891.07,-608.1627;Inherit;False;T7_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2080;-8888.559,-543.9713;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2089;-9877.859,-856.6984;Inherit;False;1811;Texture6_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2084;-9382.559,-577.5664;Inherit;False;2037;Texture7_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2114;-5733.644,-4079.536;Inherit;False;AllNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;611;1593.509,-6767.99;Inherit;False;610;NormalDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;286;1823.383,-7002.219;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;609;1161.093,-6700.741;Inherit;False;608;LightDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;282;1425.368,-7004.185;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;1137.67,-6813.199;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1565;584.6244,-6914.66;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2146;837.2459,-7000.683;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;1541.765,-6851.677;Inherit;False;2114;AllNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;2067;-11174.41,-608.3673;Inherit;True;Procedural Sample;-1;;169;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;2048;-10268.17,-2184.078;Inherit;False;T7_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2105;-11612.99,24.63748;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1468;-15821.43,-3009.313;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;1765;-11181.01,-1316.777;Inherit;True;Procedural Sample;-1;;168;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;2047;-10442.13,-2410.996;Inherit;True;2018;TA_7_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;2087;-10394.93,-1119.602;Inherit;False;1675;Texture5_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2091;-9630.629,-799.2814;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2051;-9546.917,-2291.228;Inherit;False;Property;_T7_Albedo_ProceduralTiling;T7_Albedo_ProceduralTiling?;99;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2073;-8631.52,-548.7853;Inherit;False;AllAlbedo_TextureSampler2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;2064;-11173.07,-962.59;Inherit;True;Procedural Sample;-1;;167;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;2083;-9379.52,-427.9304;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2033;-10474.33,-1749.829;Inherit;True;2054;T7_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2052;-8956.329,-2255.608;Inherit;False;Property;_T7_ColorCorrection;T7_ColorCorrection;98;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;2090;-9877.839,-780.9104;Inherit;False;478;DebugColor3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2061;-10889.73,-962.3854;Inherit;False;T6_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;806;-16369.88,-3599.562;Inherit;True;816;T2_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1767;-10897.67,-1316.573;Inherit;False;T5_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2130;-13706.86,1688.585;Inherit;False;2129;TextureSampler2_AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2049;-10460.47,-2184.464;Inherit;False;Property;_T7_Albedo_Tiling;T7_Albedo_Tiling;100;0;Create;True;0;0;False;0;False;1;26.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2082;-9135.329,-520.1494;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2027;-10136.18,-2832.569;Inherit;False;Property;_T7_AnimatedGrunge_Flipbook_Columns;T7_AnimatedGrunge_Flipbook_Columns;105;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2079;-9382.539,-501.7794;Inherit;False;479;DebugColor4;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2095;-10390.6,-478.3503;Inherit;True;Property;_TerrainMask_TextureSampler2;TerrainMask_TextureSampler2;2;0;Create;True;0;0;False;1;Header(TerrainMask);False;-1;None;44fba50036835704296a0c81fdcac7ff;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1047;-17673.95,-573.7546;Inherit;False;Constant;_Float11;Float 11;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2024;-10472.13,-2919.321;Inherit;False;Property;_T7_AnimatedGrunge_Tiling;T7_AnimatedGrunge_Tiling;104;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1050;-17233.76,118.0914;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;909;-14217.9,-4970.68;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1422;-14287.09,-6466.434;Inherit;False;Property;_T1_AnimatedGrunge;T1_AnimatedGrunge?;22;0;Create;True;0;0;False;1;Header(T1 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1144;-17250.29,-801.4967;Inherit;True;Property;_TextureSample47;Texture Sample 47;94;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1143;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1115;-17238.6,-277.8365;Inherit;True;Property;_TA_4_Grunges_Sample;TA_4_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;175;-16363.91,-6732.831;Inherit;False;Property;_T1_AnimatedGrunge_Tiling;T1_AnimatedGrunge_Tiling;25;0;Create;True;0;0;False;0;False;1;32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;871;-17308.63,-3763.42;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2112;-6059.825,-4080.971;Inherit;False;2106;AllNormal_TextureSampler2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1446;-13960.18,-2623.728;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;820;-16358.74,-4770.017;Inherit;False;Property;_T2_AnimatedGrunge_Tiling;T2_AnimatedGrunge_Tiling;39;0;Create;True;0;0;False;0;False;1;32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1452;-14305.49,-620.9127;Inherit;False;Property;_T4_AnimatedGrunge;T4_AnimatedGrunge?;62;0;Create;True;0;0;False;1;Header(T4 Animated Grunge);False;0;0.719;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1195;-17563.45,-1665.674;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;867;-17252.04,-4145.979;Inherit;True;Property;_TA_2_Grunges_Sample;TA_2_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1447;-14155.96,-2658.846;Inherit;False;Constant;_Float42;Float 42;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;908;-14500.83,-4971.87;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;819;-14818.83,-4754.869;Inherit;False;Property;_T2_AnimatedGrunge_Contrast;T2_AnimatedGrunge_Contrast;43;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1428;-14142.17,-4585.678;Inherit;False;Constant;_Float10;Float 10;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1186;-15966.25,-3010.572;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;821;-15974.74,-4944.017;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;891;-15329.47,-4947.463;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;918;-16136.74,-4948.017;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1078;-14495.39,-1102.727;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1158;-16016.35,-743.1217;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Rows;T4_AnimatedGrunge_Flipbook_Rows;67;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;919;-15652.78,-4706.744;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1462;-16109.46,-4713.352;Inherit;False;Property;_T2_AnimatedGrunge_ScreenBased;T2_AnimatedGrunge_ScreenBased?;38;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;-17566.2,-5611.392;Inherit;False;1477;T1_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1104;-16351.25,-3015.572;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1206;-17677.89,-2509.454;Inherit;False;Constant;_Float40;Float 40;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1467;-16376.43,-2746.313;Inherit;False;Property;_T3_AnimatedGrunge_ScreenBased;T3_AnimatedGrunge_ScreenBased?;51;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1145;-17711.76,-996.8917;Inherit;True;Property;_TA_4_Textures_and_Grunges;TA_4_Textures_and_Grunges;58;0;Create;True;0;0;False;1;Header(Texture 4 VertexPaintBlue);False;ef1e633c4c2c51641bd59a932b55b28a;bce18311dad27e24f89c7baa9c2efc3b;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;876;-17717.77,-4658.894;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;869;-17583.2,-3767.864;Inherit;False;839;T2_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;863;-16866.52,-4859.134;Inherit;False;T2_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;868;-16994.05,-3768.67;Inherit;False;Texture2_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;855;-17687.39,-4441.897;Inherit;False;Constant;_Float49;Float 49;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1097;-14713.74,-1107.55;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1191;-16020.3,-2678.821;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Rows;T3_AnimatedGrunge_Flipbook_Rows;54;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1109;-14237.41,-3032.236;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1157;-16015.35,-668.1217;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Speed;T4_AnimatedGrunge_Flipbook_Speed;68;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1461;-15831.46,-4943.352;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;854;-16283.79,-4533.265;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Rows;T2_AnimatedGrunge_Flipbook_Rows;41;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1152;-16353.25,-2843.572;Inherit;False;Property;_T3_AnimatedGrunge_Tiling;T3_AnimatedGrunge_Tiling;52;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;884;-15048.24,-4976.579;Inherit;True;Property;_TextureSample48;Texture Sample 48;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1427;-13946.39,-4550.56;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;340;-17301,-5687.348;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2019;-11367.55,-3010.052;Inherit;True;Property;_TA_7_Textures_Sample;TA_7_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1161;-15659.15,-2941.194;Inherit;False;Property;_T3_IsGrungeAnimated;T3_IsGrungeAnimated?;50;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2086;-10394.9,-1043.813;Inherit;False;477;DebugColor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;2131;-13427.86,1693.585;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2132;-13219.44,1586.569;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2140;-16704.39,2841.336;Inherit;False;2129;TextureSampler2_AlphaMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;2141;-16425.39,2846.336;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1156;-14794.34,-2786.425;Inherit;False;Property;_T3_AnimatedGrunge_Contrast;T3_AnimatedGrunge_Contrast;56;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2021;-10971.91,-3006.437;Inherit;False;T7_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1203;-17254.24,-2737.196;Inherit;True;Property;_TextureSample33;Texture Sample 33;97;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1362;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1204;-17678.89,-2586.454;Inherit;False;Constant;_Float39;Float 39;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1129;-15639.34,-838.6017;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;1460;-16052.3,-4847.594;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;1130;-16127.25,-3015.572;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1362;-17252.68,-2930.302;Inherit;True;Property;_TA_3_Textures_Sample;TA_3_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1087;-15038.75,-3044.134;Inherit;True;Property;_TextureSample53;Texture Sample 53;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;885;-15221.26,-4817.416;Inherit;False;Constant;_Float55;Float 55;87;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;872;-17575.73,-3608.815;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1445;-14299.35,-2549.903;Inherit;False;Property;_T3_AnimatedGrunge;T3_AnimatedGrunge?;49;0;Create;True;0;0;False;1;Header(T3 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;858;-17263.73,-4669.639;Inherit;True;Property;_TextureSample44;Texture Sample 44;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;865;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1451;-14162.1,-729.8557;Inherit;False;Constant;_Float44;Float 44;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1211;-16349.04,-1669.851;Inherit;True;1187;T3_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1154;-14495.41,-2782.236;Inherit;False;Property;_T3_AnimatedGrunge_Multiply;T3_AnimatedGrunge_Multiply;57;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;881;-17480.78,-4863.744;Inherit;False;TA_2_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1162;-14519.46,-850.5366;Inherit;False;Property;_T4_AnimatedGrunge_Multiply;T4_AnimatedGrunge_Multiply;70;0;Create;True;0;0;False;0;False;1.58;1.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1080;-15643.29,-2774.3;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleContrastOpNode;1110;-14512.34,-3032.425;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;841;-15668.64,-4873.639;Inherit;False;Property;_T2_IsGrungeAnimated;T2_IsGrungeAnimated?;37;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1164;-17708.27,-2726.449;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;907;-14729.18,-4977.692;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1111;-16864.6,-276.8365;Inherit;False;T4_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1178;-16857.03,-2926.689;Inherit;False;T3_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1429;-14285.56,-4476.734;Inherit;False;Property;_T2_AnimatedGrunge;T2_AnimatedGrunge?;36;0;Create;True;0;0;False;1;Header(T2 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1411;-17443.38,1838.028;Inherit;False;Constant;_Float25;Float 25;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;882;-16282.79,-4458.264;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Speed;T2_AnimatedGrunge_Flipbook_Speed;42;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;890;-15889.79,-4438.264;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1553;-4707.982,-4766.572;Inherit;False;Property;_WaveFakeLight_Time;WaveFakeLight_Time;115;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1549;-4376.982,-4943.572;Inherit;False;Property;_WaveFakeLight_Max;WaveFakeLight_Max;117;0;Create;False;0;0;False;0;False;1.1;1.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1825;-8927.513,-4805.36;Inherit;False;Property;_T6_AnimatedGrunge_Contrast;T6_AnimatedGrunge_Contrast;95;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;478;-5074.163,-4812.89;Inherit;True;DebugColor3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;-14532.57,1307.504;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;2053;-7795.191,-2420.068;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2014;-11673.76,-1770.433;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;431;-2325.189,-7054.839;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1823;-9160.922,-5061.07;Inherit;True;Property;_TextureSample41;Texture Sample 41;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1820;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;2006;-11679.44,-1856.663;Inherit;False;2035;T7_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2035;-6693.74,-3177.958;Inherit;False;T7_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1810;-10481.62,-3687.015;Inherit;True;1803;T6_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1870;-7802.484,-4357.254;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2036;-11681.24,-1929.482;Inherit;False;2055;T7_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1690;-9155.751,-6931.752;Inherit;True;Property;_TextureSample55;Texture Sample 55;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1756;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1803;-7484.923,-4356.399;Inherit;False;T6_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1750;-8616.342,-6926.043;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1867;-10073.37,-4163.827;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1472;-15491.22,1651.251;Inherit;True;Property;_TerrainMask_TextureSampler1;TerrainMask_TextureSampler1;1;0;Create;True;0;0;False;1;Header(TerrainMask);False;-1;None;6b5070083681b4546855db16376e4b25;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1709;-11655.01,-5734.182;Inherit;False;1761;T5_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1835;-10143.47,-4769.756;Inherit;False;Property;_T6_AnimatedGrunge_Flipbook_Columns;T6_AnimatedGrunge_Flipbook_Columns;92;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2034;-7153.614,-3176.593;Inherit;False;2055;T7_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1719;-9959.271,-6899.921;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;2017;-6922.614,-3175.593;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1815;-9858.224,-4017.726;Inherit;True;Property;_TextureSample40;Texture Sample 40;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1677;-8365.013,-6104.099;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1755;-6707.084,-6987.141;Inherit;False;T5_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2009;-8085.152,-2710.185;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1813;-8963.624,-4192.794;Inherit;False;Property;_T6_ColorCorrection;T6_ColorCorrection;85;0;Create;True;0;0;False;0;False;1,1,1,0;1,0.9098039,0.9098039,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1678;-8949.844,-6069.597;Inherit;False;Property;_T5_ColorCorrection;T5_ColorCorrection;72;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1844;-9964.44,-5029.239;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;2056;-11792.5,-2243.023;Inherit;False;Constant;_Float20;Float 20;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2018;-11586.17,-3011.048;Inherit;False;TA_7_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1691;-10093.25,-6902.189;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;2039;-8371.5,-2290.11;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1876;-9333.94,-4901.906;Inherit;False;Constant;_Float37;Float 37;87;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1753;-8426.443,-6444.229;Inherit;False;Property;_T5_AnimatedGrunge;T5_AnimatedGrunge?;75;0;Create;True;0;0;False;1;Header(T5 Animated Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1881;-11800.07,-4526.39;Inherit;False;Constant;_Float79;Float 79;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1859;-11799.79,-4180.209;Inherit;False;Constant;_Float23;Float 23;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2004;-8280.933,-2745.303;Inherit;False;Constant;_Float13;Float 13;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-5045.261,-5633.177;Inherit;False;Property;_ScreenBasedShadowNoise;ScreenBasedShadowNoise?;10;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2016;-11823.16,-2806.199;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;169;-6019.177,-6753.23;Inherit;True;2114;AllNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1887;-6929.907,-5112.779;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;593;-5487.143,-4836.466;Inherit;True;Property;_TextureSample25;Texture Sample 25;7;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1716;-10169.11,-6782.163;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-5268.219,-5702.589;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2068;-11782.1,-608.5343;Inherit;True;2018;TA_7_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1762;-11705.57,-1093.17;Inherit;False;1705;T5_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1734;-10468.51,-5559.806;Inherit;True;1695;T5_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;386;-4038.411,-5898.843;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;1682;-11832.7,-6820.207;Inherit;True;Property;_TA_5_Textures_and_Grunges;TA_5_Textures_and_Grunges;71;0;Create;True;0;0;False;1;Header(Texture 5 VertexPaintRed);False;ef1e633c4c2c51641bd59a932b55b28a;367e4a1a884fceb4495dc92c9be487dd;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;2099;-11897.54,17.97146;Inherit;True;1767;T5_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1061;-16347.3,-1079.874;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1863;-11593.46,-4948.234;Inherit;False;TA_6_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1838;-8673.626,-4326.793;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1464;-16363.15,-6644.036;Inherit;False;Property;_T1_AnimatedGrunge_ScreenBased;T1_AnimatedGrunge_ScreenBased?;24;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1684;-8659.843,-6203.597;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2041;-8372.961,-2205.077;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1766;-11788.7,-1316.944;Inherit;True;1739;TA_5_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;741;-6040.814,-5708.424;Inherit;True;Property;_InBrumeDrippingNoise;InBrumeDrippingNoise;17;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1693;-10138.3,-6640.437;Inherit;False;Property;_T5_AnimatedGrunge_Flipbook_Columns;T5_AnimatedGrunge_Flipbook_Columns;79;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;358;-5472.659,-6489.52;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1749;-10468.25,-6903.189;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;128;-5454.819,-5839.688;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;16;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1717;-8350.412,-6925.851;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;704;-219.5086,-7035.265;Inherit;False;2113;AllAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;218;-3835.652,-5928.716;Inherit;True;Property;_TextureSample60;Texture Sample 60;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;703;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;564;-2807.275,-5528.708;Inherit;False;Property;_DebugVertexPaint;DebugVertexPaint;6;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2065;-11452.58,-410.2155;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;2103;-11596.68,252.9624;Inherit;True;2061;T6_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;2057;-11830.59,-3012.339;Inherit;True;Property;_TA_7_Textures_and_Grunges;TA_7_Textures_and_Grunges;97;0;Create;True;0;0;False;1;Header(Texture 7 VertexPaintBlue);False;ef1e633c4c2c51641bd59a932b55b28a;df1d03832ee756f41b86097a2cb84b33;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;594;-5488.143,-4614.466;Inherit;True;Property;_TextureSample26;Texture Sample 26;7;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1812;-8378.795,-4227.296;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1808;-8645.585,-4803.169;Inherit;False;Property;_T6_AnimatedGrunge_Multiply;T6_AnimatedGrunge_Multiply;96;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-4470.422,-5866.843;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2063;-11780.76,-962.757;Inherit;True;1863;TA_6_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;1868;-11413.95,-3862.224;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1833;-10979.2,-4943.624;Inherit;False;T6_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1540;-2383.939,-6674.292;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2060;-11697.63,-738.9831;Inherit;False;1828;T6_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2097;-11317.5,466.4143;Inherit;True;2070;T7_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1728;-9328.771,-6772.588;Inherit;False;Constant;_Float54;Float 54;87;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2100;-11332.53,235.1614;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1698;-11795.89,-6474.07;Inherit;False;Constant;_Float41;Float 41;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1858;-8288.227,-4682.49;Inherit;False;Constant;_Float22;Float 22;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1737;-11369.68,-6817.919;Inherit;True;Property;_TA_5_Textures_Sample;TA_5_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1851;-8380.256,-4142.263;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1827;-10467.77,-4121.65;Inherit;False;Property;_T6_Albedo_Tiling;T6_Albedo_Tiling;87;0;Create;True;0;0;False;0;False;1;26.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1861;-10002.47,-4522.757;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1884;-10490.44,-4746.24;Inherit;False;Property;_T6_AnimatedGrunge_ScreenBased;T6_AnimatedGrunge_ScreenBased?;90;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1834;-10142.47,-4695.756;Inherit;False;Property;_T6_AnimatedGrunge_Flipbook_Rows;T6_AnimatedGrunge_Flipbook_Rows;93;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1729;-11825.27,-6614.067;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1761;-10218.34,-5559.301;Inherit;False;T5_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1742;-8366.474,-6019.068;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1832;-11376.41,-4754.131;Inherit;True;Property;_TextureSample37;Texture Sample 37;69;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1879;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1703;-9827.964,-6224.82;Inherit;True;Procedural Sample;-1;;153;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1817;-9781.321,-4953.762;Inherit;False;Property;_T6_IsGrungeAnimated;T6_IsGrungeAnimated?;89;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1748;-11792.11,-6052.643;Inherit;False;Constant;_Float59;Float 59;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1746;-11647.53,-5575.134;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1848;-11801.07,-4603.389;Inherit;False;Constant;_Float16;Float 16;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;1873;-10249.42,-5032.507;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1695;-7473.591,-6230.102;Inherit;False;T5_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1843;-8355.585,-5055.169;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1696;-9436.981,-6902.636;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1760;-8283.054,-6553.171;Inherit;False;Constant;_Float61;Float 61;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1751;-10485.27,-6616.92;Inherit;False;Property;_T5_AnimatedGrunge_ScreenBased;T5_AnimatedGrunge_ScreenBased?;77;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1736;-8834.692,-6930.866;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1706;-8091.106,-6201.787;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1814;-9554.212,-4228.414;Inherit;False;Property;_T6_Albedo_ProceduralTiling;T6_Albedo_ProceduralTiling?;86;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1847;-9442.151,-5031.956;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1704;-10059.59,-6040.63;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1721;-9241.153,-6221.163;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1724;-7166.957,-6985.776;Inherit;False;1761;T5_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1874;-8104.888,-4324.982;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1707;-9540.433,-6105.217;Inherit;False;Property;_T5_Albedo_ProceduralTiling;T5_Albedo_ProceduralTiling?;73;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;1712;-10244.25,-6903.189;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;1747;-7791.151,-6230.956;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2045;-8097.594,-2387.796;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;597;-5746.402,-4914.497;Inherit;False;Constant;_Float2;Float 2;69;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1845;-9765.462,-4791.235;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;1802;-10990.72,-4229.471;Inherit;False;T6_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1801;-10098.42,-5031.507;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;1702;-9997.302,-6393.438;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1831;-10141.47,-4620.756;Inherit;False;Property;_T6_AnimatedGrunge_Flipbook_Speed;T6_AnimatedGrunge_Flipbook_Speed;94;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1879;-11374.85,-4947.238;Inherit;True;Property;_TA_6_Textures_Sample;TA_6_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1862;-9841.743,-4348.016;Inherit;True;Procedural Sample;-1;;154;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SimpleContrastOpNode;1869;-8621.516,-5055.361;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1828;-10275.46,-4121.264;Inherit;False;T6_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1880;-10214.33,-4263.258;Inherit;False;Constant;_Float38;Float 38;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1804;-10449.43,-4348.183;Inherit;True;1863;TA_6_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1886;-6701.034,-5115.145;Inherit;False;T6_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1883;-11837.88,-4949.525;Inherit;True;Property;_TA_6_Textures_and_Grunges;TA_6_Textures_and_Grunges;84;0;Create;True;0;0;False;1;Header(Texture 6 VertexPaintGreen);False;ef1e633c4c2c51641bd59a932b55b28a;None;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;1882;-11830.45,-4743.386;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;2007;-11406.66,-1925.038;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1805;-11688.53,-3866.668;Inherit;False;1836;T6_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1820;-11364.72,-4230.471;Inherit;True;Property;_TA_6_Grunges_Sample;TA_6_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1852;-8839.865,-5060.185;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1866;-11679.15,-3786.268;Inherit;False;1886;T6_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1405;-17445.34,1496.102;Inherit;False;Constant;_Float17;Float 17;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2104;-11387.39,429.1433;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1714;-10200.55,-6140.061;Inherit;False;Constant;_Float48;Float 48;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1998;-8348.292,-3117.984;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1875;-10473.42,-5032.507;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1480;-12596.58,-5055.941;Inherit;False;T2_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1872;-8092.445,-4647.372;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1732;-11794.89,-6397.071;Inherit;False;Constant;_Float12;Float 12;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;559;-5492.484,-5291.467;Inherit;True;Property;_DebugTextureArray;DebugTextureArray;7;0;Create;True;0;0;False;0;False;-1;fcf4482ca7d817c42b6d03968194b044;fcf4482ca7d817c42b6d03968194b044;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2054;-7477.63,-2419.213;Inherit;False;T7_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1877;-10174.28,-4911.481;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1811;-11099.38,-3867.474;Inherit;False;Texture6_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1836;-10246.55,-3687.393;Inherit;False;T6_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1885;-7160.907,-5113.779;Inherit;False;1836;T6_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1739;-11588.29,-6818.916;Inherit;False;TA_5_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1708;-11645.62,-5653.784;Inherit;False;1755;T5_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2015;-11792.78,-2589.203;Inherit;False;Constant;_Float18;Float 18;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1722;-11380.42,-5729.739;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;162;-5463.819,-5706.687;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;1757;-6935.957,-6984.776;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1826;-10479.42,-4856.507;Inherit;False;Property;_T6_AnimatedGrunge_Tiling;T6_AnimatedGrunge_Tiling;91;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;563;-5859.021,-5264.105;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1711;-10137.3,-6566.437;Inherit;False;Property;_T5_AnimatedGrunge_Flipbook_Rows;T5_AnimatedGrunge_Flipbook_Rows;80;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2002;-11793.78,-2666.202;Inherit;False;Constant;_Float9;Float 9;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1680;-9760.292,-6661.917;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;1878;-11681.06,-3707.619;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1397;-17071.12,1063.147;Inherit;True;Procedural Sample;-1;;158;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;2069;-11698.97,-384.7604;Inherit;False;2048;T7_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1675;-11065.85,-5734.989;Inherit;False;Texture5_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1412;-17678.47,1753.104;Inherit;True;1146;TA_4_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1557;-3757.93,-4604.283;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;583;-14483.17,1552.035;Inherit;False;1364;Texture4_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;692;-17239.54,2749.483;Inherit;True;1408;T4_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1403;-17072.75,1411.345;Inherit;True;Procedural Sample;-1;;160;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;489;-15502.95,802.14;Inherit;False;488;DebugColor1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-16866.69,-6825.948;Inherit;False;T1_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;581;-14480.14,1701.671;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;579;-14978.48,1272.903;Inherit;False;1214;Texture3_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;640;-16966.89,2737.61;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;644;-15971.62,2733.765;Inherit;False;AllNormal_TextureSampler1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1380;-17677.52,718.158;Inherit;True;708;TA_1_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1416;-17603.89,1970.468;Inherit;False;1377;T3_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;570;-15495.52,1085.788;Inherit;False;477;DebugColor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1473;-17837.3,2835.598;Inherit;True;Property;_TextureSample31;Texture Sample 31;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1472;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1402;-16789.41,1411.551;Inherit;False;T3_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;694;-17033.43,2935.212;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1409;-17070.78,1753.271;Inherit;True;Procedural Sample;-1;;159;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;1406;-17680.44,1411.178;Inherit;True;1090;TA_3_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;157;-4741.261,-5777.178;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-15977.91,-6923.831;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1404;-17350.92,1609.498;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1544;-1261.888,-6708.66;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;1558;-4483.21,-4761.288;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1547;-3056.648,-5125.861;Inherit;False;FakeLights;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;566;-2499.365,-5529.619;Inherit;False;DebugVertexPaint;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-15221.43,-6784.23;Inherit;False;Constant;_Float62;Float 62;87;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1560;-3950.982,-4728.572;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1860;-8431.615,-4573.548;Inherit;False;Property;_T6_AnimatedGrunge;T6_AnimatedGrunge?;88;0;Create;True;0;0;False;1;Header(T6 Animated Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-5204.42,-5920.987;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1686;-9844.444,-5894.53;Inherit;True;Property;_TextureSample32;Texture Sample 32;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1415;-17605.89,1632.468;Inherit;False;1377;T3_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1086;-15211.77,-2884.971;Inherit;False;Constant;_Float31;Float 31;87;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;-17819.58,2301.04;Inherit;True;1396;T2_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;573;-15502.54,726.9994;Inherit;False;748;Texture1_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1550;-4376.982,-4859.572;Inherit;False;Property;_WaveFakeLight_Min;WaveFakeLight_Min;116;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;2144;-9746.873,-272.5801;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;586;-14219.49,1783.546;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;576;-14731.25,1330.32;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1400;-17678.81,1062.98;Inherit;True;881;TA_2_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1410;-17348.96,1951.424;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1383;-17069.83,718.325;Inherit;True;Procedural Sample;-1;;161;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerNode;1743;-11371.24,-6624.812;Inherit;True;Property;_TextureSample56;Texture Sample 56;86;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1737;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2106;-10785.2,450.1943;Inherit;False;AllNormal_TextureSampler2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;691;-17518.72,2536.031;Inherit;True;1402;T3_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;632;-17535.03,2307.706;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;822;-16284.79,-4607.265;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Columns;T2_AnimatedGrunge_Flipbook_Columns;40;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;635;-17254.57,2518.23;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1552;-4053.864,-4554.738;Inherit;False;Property;_FakeLightStepAttenuation;FakeLightStepAttenuation;114;0;Create;False;0;0;False;0;False;5;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;495;-13989.17,1585.63;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1408;-16787.44,1753.477;Inherit;False;T4_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1398;-17349.29,1261.301;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;569;-15248.32,1067.417;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1386;-17348,916.4769;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;577;-14975.44,1422.538;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1745;-8640.412,-6673.851;Inherit;False;Property;_T5_AnimatedGrunge_Multiply;T5_AnimatedGrunge_Multiply;83;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2142;-16216.97,2739.32;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1413;-17594.39,941.9319;Inherit;False;1379;T1_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1382;-17442.42,803.0808;Inherit;False;Constant;_Float5;Float 5;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;578;-14978.45,1348.691;Inherit;False;478;DebugColor3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1554;-4115.549,-5039.951;Inherit;False;Property;_FakeLightArrayLength;FakeLightArrayLength;111;0;Create;False;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;477;-5073.666,-5050.087;Inherit;True;DebugColor2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1512;-260.0815,-6783.335;Inherit;False;Constant;_Float47;Float 47;109;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1705;-10261.68,-5998.069;Inherit;False;T5_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;622;-12927.13,1580.816;Inherit;False;AllAlbedo_TextureSampler1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1556;-4151.981,-4890.572;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;642;-17821.04,2107.01;Inherit;True;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;585;-14605.39,1455.345;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;565;-15255.75,783.7694;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-16786.49,718.53;Inherit;False;T1_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;-15020.54,1042.695;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1414;-17598.65,1284.24;Inherit;False;1378;T2_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1399;-17443.71,1147.905;Inherit;False;Constant;_Float8;Float 8;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-16028.96,-6503.079;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Speed;T1_AnimatedGrunge_Flipbook_Speed;28;0;Create;True;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;580;-14235.95,1609.452;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1521;-2569.433,-6528.43;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;574;-15495.54,1009.999;Inherit;False;868;Texture2_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;421;-3931.38,-6453.939;Inherit;False;Constant;_Float77;Float 77;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1853;-9254.933,-4344.358;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1548;-4221.93,-4645.244;Inherit;False;Property;_FakeLightStep;FakeLightStep;113;0;Create;False;0;0;False;0;False;0;3;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;693;-17309.43,2712.212;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2032;-8424.32,-2636.361;Inherit;False;Property;_T7_AnimatedGrunge;T7_AnimatedGrunge?;101;0;Create;True;0;0;False;1;Header(T7 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;1561;-4317.277,-4760.952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;423;-2806.219,-5834.324;Inherit;False;Property;_LightDebug;LightDebug;3;0;Create;True;0;0;False;1;Header(Debug);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;432;-2875.09,-6450.74;Inherit;False;Property;_ShadowColor;ShadowColor;14;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.8396226,0.8396226,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1763;-11459.18,-1118.625;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1725;-8087.273,-6518.053;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;608;-2495.495,-5833.521;Inherit;False;LightDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-3212.411,-5687.843;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;159;-4780.063,-5951.657;Inherit;False;Property;_ShadowNoisePanner;ShadowNoisePanner;11;0;Create;True;0;0;False;0;False;0.01,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;590;-6092.63,-5245.192;Inherit;False;Property;_DebugTextureTiling;DebugTextureTiling;8;0;Create;True;0;0;False;0;False;10;9.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1559;-4105.292,-5184.326;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleSubtractOpNode;424;-3435.382,-7045.941;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;1562;-3573.941,-5121.271;Float;False;float result=0@$for(int i=0@ i<Length@i++)${$	float dist = distance(WorldPos,FakeLightsPositionsArray[i])@$	result += 1 - smoothstep( LightStep, LightStepAttenuation, dist)@$}$return result@;1;False;5;True;In0;FLOAT;0;In;;Inherit;False;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;Length;FLOAT;0;In;;Inherit;False;True;LightStep;FLOAT;0;In;;Float;False;True;LightStepAttenuation;FLOAT;0;In;;Float;False;Cycle Through Array;True;False;0;5;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2066;-11547,-523.6115;Inherit;False;Constant;_Float24;Float 24;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;408;-3211.39,-7045.941;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1541;-2196.02,-6559.271;Inherit;False;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;411;-5745.657,-6747.518;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1012;-319.7695,-6711.333;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1545;-1679.088,-6572.459;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;606;-2503.536,-5932.027;Inherit;False;Out_or_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;412;-5761.658,-6603.519;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1720;-10136.3,-6491.437;Inherit;False;Property;_T5_AnimatedGrunge_Flipbook_Speed;T5_AnimatedGrunge_Flipbook_Speed;81;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1754;-9776.151,-6824.444;Inherit;False;Property;_T5_IsGrungeAnimated;T5_IsGrungeAnimated?;76;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;363;-3836.652,-5662.715;Inherit;True;Property;_TextureSample66;Texture Sample 66;9;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;703;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;426;-3659.38,-6869.939;Inherit;False;197;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2062;-11545.66,-877.8342;Inherit;False;Constant;_Float21;Float 21;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;362;-4310.411,-5898.843;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;359;-4470.422,-5642.843;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2059;-11451.24,-764.4382;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;479;-5076.617,-4570.122;Inherit;True;DebugColor4;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1538;-2592.13,-6765.625;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-2799.738,-5731.308;Inherit;False;Property;_NormalDebug;NormalDebug;4;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;365;-3500.411,-5686.843;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;592;-5490.143,-5068.466;Inherit;True;Property;_TextureSample24;Texture Sample 24;7;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;488;-5076.916,-5292.072;Inherit;True;DebugColor1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1546;-1429.688,-6572.26;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;703;-6042.066,-5913.212;Inherit;True;Property;_ShadowNoise;ShadowNoise;9;0;Create;True;0;0;False;1;Header(Shadow and Noise);False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;a61778d50b6394348b9f8089e2c6e1fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1759;-10985.55,-6100.153;Inherit;False;T5_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;596;-5747.402,-4995.497;Inherit;False;Constant;_Float1;Float 1;69;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;595;-5749.696,-5076.351;Inherit;False;Constant;_Float0;Float 0;69;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;698;-297.2356,-6930.729;Inherit;False;428;Shadows;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;598;-5746.402,-4833.497;Inherit;False;Constant;_Float3;Float 3;69;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1010;-65.39049,-6881.199;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;414;-5489.658,-6747.518;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1756;-11359.55,-6101.153;Inherit;True;Property;_TA_5_Grunges_Sample;TA_5_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1699;-8922.342,-6676.042;Inherit;False;Property;_T5_AnimatedGrunge_Contrast;T5_AnimatedGrunge_Contrast;82;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;613;-2798.775,-5626.535;Inherit;False;Property;_GrayscaleDebug;GrayscaleDebug;5;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;429;-2932.284,-6892.476;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1727;-10474.25,-6727.189;Inherit;False;Property;_T5_AnimatedGrunge_Tiling;T5_AnimatedGrunge_Tiling;78;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;420;-4075.38,-6805.939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;176;-5669.818,-5706.687;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;1555;-3230.507,-5120.811;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;614;-2491.335,-5627.459;Inherit;False;GrayscaleDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1715;-10453.99,-5998.454;Inherit;False;Property;_T5_Albedo_Tiling;T5_Albedo_Tiling;74;0;Create;True;0;0;False;0;False;1;26.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1731;-10974.03,-6814.305;Inherit;False;T5_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1539;-2868.94,-6652.292;Inherit;False;Property;_EdgeShadowColor;EdgeShadowColor;15;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;428;-1011.589,-6553.591;Inherit;False;Shadows;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;435;-3723.38,-6501.939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-4913.66,-6763.518;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;416;-3755.38,-6613.939;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1564;384.0065,-6835.604;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;413;-5201.659,-6747.518;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1563;134.0065,-6703.604;Inherit;False;Property;_FakeLight_Color;FakeLight_Color;112;0;Create;False;0;0;False;0;False;1,1,1,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;422;-4267.379,-6789.939;Inherit;False;Property;_StepAttenuation;StepAttenuation;13;0;Create;True;0;0;False;0;False;-0.07;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;610;-2494.786,-5731.053;Inherit;False;NormalDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;427;-3723.38,-6405.939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1764;-11553.6,-1232.021;Inherit;False;Constant;_Float64;Float 64;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1566;390.2694,-6616.809;Inherit;False;1547;FakeLights;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;605;-2803.609,-5933.152;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;0;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;406;-3515.381,-6533.939;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;356;-4187.379,-7045.941;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;2145;-9570.873,-273.5801;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2147;414.8876,-6501.387;Inherit;False;Property;_FakeLights;FakeLights?;110;0;Create;True;0;0;False;1;Header(Fake Lights);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2109;-6058.426,-4183.284;Inherit;False;2073;AllAlbedo_TextureSampler2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2113;-5735.97,-4183.091;Inherit;False;AllAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;705;186.4084,-7006.605;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GlobalArrayNode;1551;-4131.54,-5289.915;Inherit;False;FakeLightsPositionsArray;0;10;2;False;False;0;1;False;Object;13;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;425;-4634.388,-6507.939;Inherit;False;Property;_StepShadow;StepShadow;12;0;Create;True;0;0;False;0;False;0.1;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;430;-3915.38,-7045.941;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1543;-1795.958,-6938.823;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1694;-10435.65,-6224.987;Inherit;True;1739;TA_5_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;2138;-11918.26,-107.8453;Inherit;False;644;AllNormal_TextureSampler1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;2026.651,-6912.61;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;TerrainMaterialShader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;1;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-13936.3,1402.608;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;403;0;381;1
WireConnection;1484;0;1486;0
WireConnection;179;0;1465;0
WireConnection;179;1;132;0
WireConnection;179;2;127;0
WireConnection;179;3;146;0
WireConnection;179;5;208;0
WireConnection;816;0;912;0
WireConnection;1470;0;1067;0
WireConnection;1437;0;1436;0
WireConnection;1437;1;906;0
WireConnection;1437;2;1438;0
WireConnection;1173;1;1069;0
WireConnection;1173;6;1075;0
WireConnection;1205;0;1241;0
WireConnection;1471;0;1046;0
WireConnection;1471;1;1470;0
WireConnection;1471;2;1469;0
WireConnection;1463;0;175;0
WireConnection;1060;0;1061;0
WireConnection;1392;0;1378;0
WireConnection;906;158;825;0
WireConnection;906;183;889;0
WireConnection;906;5;1392;0
WireConnection;1476;0;1475;0
WireConnection;1444;0;1442;0
WireConnection;1444;1;1125;0
WireConnection;1444;2;1443;0
WireConnection;903;0;923;0
WireConnection;903;1;1437;0
WireConnection;912;0;1427;0
WireConnection;912;1;886;0
WireConnection;856;0;867;0
WireConnection;1465;0;130;0
WireConnection;1465;1;1463;0
WireConnection;1465;2;1464;0
WireConnection;839;0;806;0
WireConnection;1439;0;1185;0
WireConnection;1439;1;1390;0
WireConnection;1241;0;1363;0
WireConnection;1241;1;1164;0
WireConnection;1241;6;1091;0
WireConnection;1107;0;1446;0
WireConnection;1107;1;1085;0
WireConnection;1064;0;1453;0
WireConnection;1064;1;1074;0
WireConnection;1481;0;1483;0
WireConnection;74;0;708;0
WireConnection;74;1;50;0
WireConnection;74;6;71;0
WireConnection;1986;0;700;0
WireConnection;1477;0;1476;0
WireConnection;1376;0;1072;0
WireConnection;1081;0;1468;0
WireConnection;1081;1;1080;0
WireConnection;1081;2;1161;0
WireConnection;1132;0;1143;0
WireConnection;1453;0;1451;0
WireConnection;1453;1;1066;0
WireConnection;1453;2;1452;0
WireConnection;1112;0;1087;1
WireConnection;1485;0;1484;0
WireConnection;1069;0;1471;0
WireConnection;1069;1;1129;0
WireConnection;1069;2;1150;0
WireConnection;224;0;716;0
WireConnection;224;1;318;0
WireConnection;1079;0;1134;0
WireConnection;1079;1;1444;0
WireConnection;1441;0;1439;0
WireConnection;1441;1;1124;0
WireConnection;1441;2;1440;0
WireConnection;177;1;50;0
WireConnection;177;6;172;0
WireConnection;158;0;1465;0
WireConnection;158;1;179;0
WireConnection;158;2;150;0
WireConnection;716;1;403;0
WireConnection;716;0;717;0
WireConnection;708;0;706;0
WireConnection;1423;0;1424;0
WireConnection;1423;1;224;0
WireConnection;1423;2;1422;0
WireConnection;1364;0;1050;0
WireConnection;1046;0;1060;0
WireConnection;1046;1;1067;0
WireConnection;1187;0;1107;0
WireConnection;1122;0;1064;0
WireConnection;187;0;301;0
WireConnection;1214;0;1196;0
WireConnection;1434;0;1433;0
WireConnection;1434;1;617;0
WireConnection;1434;2;1435;0
WireConnection;1113;0;1094;0
WireConnection;1074;0;1079;0
WireConnection;1074;1;1051;0
WireConnection;1074;2;1103;0
WireConnection;202;0;190;0
WireConnection;617;158;709;0
WireConnection;617;183;619;0
WireConnection;617;5;1385;0
WireConnection;1482;0;1481;0
WireConnection;700;0;706;0
WireConnection;700;1;50;0
WireConnection;700;6;268;0
WireConnection;167;0;163;0
WireConnection;1385;0;1379;0
WireConnection;1379;0;621;0
WireConnection;1085;0;1094;0
WireConnection;1085;1;1113;0
WireConnection;1085;2;1128;0
WireConnection;190;0;1423;0
WireConnection;190;1;191;0
WireConnection;1466;0;1152;0
WireConnection;252;0;335;0
WireConnection;191;0;335;0
WireConnection;191;1;252;0
WireConnection;191;2;615;0
WireConnection;1196;0;1198;0
WireConnection;1196;1;1199;0
WireConnection;1196;2;1195;0
WireConnection;1120;0;1121;0
WireConnection;335;0;1434;0
WireConnection;335;1;399;0
WireConnection;1396;0;1397;0
WireConnection;1390;0;1377;0
WireConnection;1442;0;1175;0
WireConnection;1442;1;1389;0
WireConnection;1051;0;1079;0
WireConnection;1377;0;1092;0
WireConnection;1124;158;1185;0
WireConnection;1124;183;1084;0
WireConnection;1124;5;1390;0
WireConnection;748;0;340;0
WireConnection;1090;0;1363;0
WireConnection;905;0;903;0
WireConnection;1378;0;888;0
WireConnection;1125;158;1175;0
WireConnection;1125;183;1083;0
WireConnection;1125;5;1389;0
WireConnection;1436;0;825;0
WireConnection;1436;1;1392;0
WireConnection;1459;1;903;0
WireConnection;1459;0;1458;0
WireConnection;1119;0;1211;0
WireConnection;1094;0;1126;0
WireConnection;1094;1;1441;0
WireConnection;1433;0;709;0
WireConnection;1433;1;1385;0
WireConnection;886;0;1459;0
WireConnection;886;1;905;0
WireConnection;886;2;920;0
WireConnection;381;1;158;0
WireConnection;381;6;156;0
WireConnection;1389;0;1376;0
WireConnection;1478;0;1479;0
WireConnection;1146;0;1145;0
WireConnection;865;0;881;0
WireConnection;865;1;876;0
WireConnection;865;6;857;0
WireConnection;2022;0;2057;0
WireConnection;2022;1;2016;0
WireConnection;2022;6;2056;0
WireConnection;2050;0;2047;0
WireConnection;2050;1;2044;0
WireConnection;2020;1;2016;0
WireConnection;2020;6;2015;0
WireConnection;2013;0;2024;0
WireConnection;2093;0;2078;0
WireConnection;2093;1;2091;0
WireConnection;2093;2;2094;0
WireConnection;2023;0;2022;0
WireConnection;2081;0;2095;3
WireConnection;2101;0;2107;3
WireConnection;2098;0;2100;0
WireConnection;2098;1;2097;0
WireConnection;2098;2;2101;0
WireConnection;2078;0;2139;0
WireConnection;2078;1;2075;0
WireConnection;2078;2;2095;1
WireConnection;2038;1;2001;0
WireConnection;2038;6;2012;0
WireConnection;2044;0;2048;0
WireConnection;2000;0;1999;0
WireConnection;2000;1;2027;0
WireConnection;2000;2;2028;0
WireConnection;2000;3;2029;0
WireConnection;2000;5;2005;0
WireConnection;2043;158;2047;0
WireConnection;2043;183;2046;0
WireConnection;2043;5;2044;0
WireConnection;2001;0;1999;0
WireConnection;2001;1;2000;0
WireConnection;2001;2;2026;0
WireConnection;2055;0;2033;0
WireConnection;1143;0;1146;0
WireConnection;1143;1;1057;0
WireConnection;1143;6;1068;0
WireConnection;2042;0;2050;0
WireConnection;2042;1;2043;0
WireConnection;2042;2;2051;0
WireConnection;1999;0;1997;0
WireConnection;1999;1;2013;0
WireConnection;1999;2;2025;0
WireConnection;1066;0;1078;0
WireConnection;1066;1;1162;0
WireConnection;2037;0;2007;0
WireConnection;2008;1;2003;0
WireConnection;2008;0;2030;0
WireConnection;1997;0;2010;0
WireConnection;1997;1;2024;0
WireConnection;2003;0;2038;1
WireConnection;2010;0;2011;0
WireConnection;2040;0;2052;0
WireConnection;2040;1;2042;0
WireConnection;2075;0;2087;0
WireConnection;2075;1;2086;0
WireConnection;2075;2;2076;0
WireConnection;2128;0;2095;1
WireConnection;2128;1;2095;2
WireConnection;2128;2;2095;3
WireConnection;2094;0;2095;2
WireConnection;2129;0;2145;0
WireConnection;2070;0;2067;0
WireConnection;2080;0;2093;0
WireConnection;2080;1;2082;0
WireConnection;2080;2;2081;0
WireConnection;2114;0;2112;0
WireConnection;286;0;282;0
WireConnection;286;1;280;0
WireConnection;286;2;611;0
WireConnection;282;0;2146;0
WireConnection;282;1;294;0
WireConnection;282;2;609;0
WireConnection;1565;0;705;0
WireConnection;1565;1;1564;0
WireConnection;1565;2;1566;0
WireConnection;2146;0;705;0
WireConnection;2146;1;1565;0
WireConnection;2146;2;2147;0
WireConnection;2067;158;2068;0
WireConnection;2067;183;2066;0
WireConnection;2067;5;2065;0
WireConnection;2048;0;2049;0
WireConnection;2105;0;2138;0
WireConnection;2105;1;2099;0
WireConnection;2105;2;2107;1
WireConnection;1468;0;1186;0
WireConnection;1468;1;1466;0
WireConnection;1468;2;1467;0
WireConnection;1765;158;1766;0
WireConnection;1765;183;1764;0
WireConnection;1765;5;1763;0
WireConnection;2091;0;2089;0
WireConnection;2091;1;2090;0
WireConnection;2091;2;2092;0
WireConnection;2073;0;2080;0
WireConnection;2064;158;2063;0
WireConnection;2064;183;2062;0
WireConnection;2064;5;2059;0
WireConnection;2061;0;2064;0
WireConnection;1767;0;1765;0
WireConnection;2082;0;2084;0
WireConnection;2082;1;2079;0
WireConnection;2082;2;2083;0
WireConnection;1050;0;1118;0
WireConnection;1050;1;1367;0
WireConnection;1050;2;1049;0
WireConnection;909;0;908;0
WireConnection;909;1;910;0
WireConnection;1144;1;1057;0
WireConnection;1144;6;1047;0
WireConnection;1115;0;1145;0
WireConnection;1115;1;1057;0
WireConnection;1115;6;1077;0
WireConnection;871;0;869;0
WireConnection;871;1;870;0
WireConnection;871;2;872;0
WireConnection;1446;0;1447;0
WireConnection;1446;1;1109;0
WireConnection;1446;2;1445;0
WireConnection;867;0;866;0
WireConnection;867;1;876;0
WireConnection;867;6;880;0
WireConnection;908;1;907;0
WireConnection;908;0;819;0
WireConnection;1186;0;1130;0
WireConnection;1186;1;1152;0
WireConnection;821;0;918;0
WireConnection;821;1;820;0
WireConnection;891;0;1461;0
WireConnection;891;1;919;0
WireConnection;891;2;841;0
WireConnection;918;0;917;0
WireConnection;1078;1;1097;0
WireConnection;1078;0;1155;0
WireConnection;919;0;1461;0
WireConnection;919;1;822;0
WireConnection;919;2;854;0
WireConnection;919;3;882;0
WireConnection;919;5;890;0
WireConnection;863;0;865;0
WireConnection;868;0;871;0
WireConnection;1097;0;1173;1
WireConnection;1109;0;1110;0
WireConnection;1109;1;1154;0
WireConnection;1461;0;821;0
WireConnection;1461;1;1460;0
WireConnection;1461;2;1462;0
WireConnection;884;1;891;0
WireConnection;884;6;885;0
WireConnection;1427;0;1428;0
WireConnection;1427;1;909;0
WireConnection;1427;2;1429;0
WireConnection;340;0;274;0
WireConnection;340;1;349;0
WireConnection;340;2;607;0
WireConnection;2019;0;2018;0
WireConnection;2019;1;2016;0
WireConnection;2019;6;2002;0
WireConnection;2131;0;2130;0
WireConnection;2132;0;495;0
WireConnection;2132;1;2131;0
WireConnection;2141;0;2140;0
WireConnection;2021;0;2019;0
WireConnection;1203;1;1164;0
WireConnection;1203;6;1206;0
WireConnection;1129;0;1471;0
WireConnection;1129;1;1159;0
WireConnection;1129;2;1158;0
WireConnection;1129;3;1157;0
WireConnection;1129;5;1141;0
WireConnection;1460;0;820;0
WireConnection;1130;0;1104;0
WireConnection;1362;0;1090;0
WireConnection;1362;1;1164;0
WireConnection;1362;6;1204;0
WireConnection;1087;1;1081;0
WireConnection;1087;6;1086;0
WireConnection;858;1;876;0
WireConnection;858;6;855;0
WireConnection;881;0;866;0
WireConnection;1080;0;1468;0
WireConnection;1080;1;1160;0
WireConnection;1080;2;1191;0
WireConnection;1080;3;1089;0
WireConnection;1080;5;1082;0
WireConnection;1110;1;1112;0
WireConnection;1110;0;1156;0
WireConnection;907;0;884;1
WireConnection;1111;0;1115;0
WireConnection;1178;0;1362;0
WireConnection;478;0;593;0
WireConnection;14;0;11;0
WireConnection;14;1;576;0
WireConnection;14;2;585;0
WireConnection;2053;0;2009;0
WireConnection;2053;1;2045;0
WireConnection;431;0;429;0
WireConnection;1823;1;1847;0
WireConnection;2035;0;2017;0
WireConnection;1870;0;1872;0
WireConnection;1870;1;1874;0
WireConnection;1690;1;1696;0
WireConnection;1690;6;1728;0
WireConnection;1803;0;1870;0
WireConnection;1750;1;1736;0
WireConnection;1750;0;1699;0
WireConnection;1867;0;1828;0
WireConnection;1719;0;1691;0
WireConnection;1719;1;1716;0
WireConnection;1719;2;1751;0
WireConnection;2017;0;2034;0
WireConnection;1815;0;1804;0
WireConnection;1815;1;1867;0
WireConnection;1677;0;1684;0
WireConnection;1755;0;1757;0
WireConnection;2009;0;2004;0
WireConnection;2009;1;1998;0
WireConnection;2009;2;2032;0
WireConnection;1844;0;1801;0
WireConnection;1844;1;1877;0
WireConnection;1844;2;1884;0
WireConnection;2018;0;2057;0
WireConnection;1691;0;1712;0
WireConnection;1691;1;1727;0
WireConnection;2039;0;2040;0
WireConnection;1887;0;1885;0
WireConnection;593;1;563;0
WireConnection;593;6;597;0
WireConnection;1716;0;1727;0
WireConnection;142;0;162;0
WireConnection;142;1;128;0
WireConnection;386;0;362;0
WireConnection;1863;0;1883;0
WireConnection;1838;0;1813;0
WireConnection;1838;1;1853;0
WireConnection;1684;0;1678;0
WireConnection;1684;1;1721;0
WireConnection;1717;0;1750;0
WireConnection;1717;1;1745;0
WireConnection;218;1;386;0
WireConnection;2065;0;2069;0
WireConnection;594;1;563;0
WireConnection;594;6;598;0
WireConnection;1812;0;1838;0
WireConnection;180;0;159;0
WireConnection;1868;0;1805;0
WireConnection;1868;1;1866;0
WireConnection;1868;2;1878;0
WireConnection;1833;0;1879;0
WireConnection;1540;0;1538;0
WireConnection;1540;1;1539;0
WireConnection;2100;0;2105;0
WireConnection;2100;1;2103;0
WireConnection;2100;2;2104;0
WireConnection;1737;0;1739;0
WireConnection;1737;1;1729;0
WireConnection;1737;6;1698;0
WireConnection;1761;0;1734;0
WireConnection;1832;1;1882;0
WireConnection;1832;6;1881;0
WireConnection;1703;158;1694;0
WireConnection;1703;183;1714;0
WireConnection;1703;5;1704;0
WireConnection;1873;0;1875;0
WireConnection;1695;0;1747;0
WireConnection;1843;0;1869;0
WireConnection;1843;1;1808;0
WireConnection;1696;0;1719;0
WireConnection;1696;1;1680;0
WireConnection;1696;2;1754;0
WireConnection;1736;0;1690;1
WireConnection;1706;0;1684;0
WireConnection;1706;1;1677;0
WireConnection;1706;2;1742;0
WireConnection;1847;0;1844;0
WireConnection;1847;1;1845;0
WireConnection;1847;2;1817;0
WireConnection;1704;0;1705;0
WireConnection;1721;0;1686;0
WireConnection;1721;1;1703;0
WireConnection;1721;2;1707;0
WireConnection;1874;0;1838;0
WireConnection;1874;1;1812;0
WireConnection;1874;2;1851;0
WireConnection;1712;0;1749;0
WireConnection;1747;0;1725;0
WireConnection;1747;1;1706;0
WireConnection;2045;0;2040;0
WireConnection;2045;1;2039;0
WireConnection;2045;2;2041;0
WireConnection;1845;0;1844;0
WireConnection;1845;1;1835;0
WireConnection;1845;2;1834;0
WireConnection;1845;3;1831;0
WireConnection;1845;5;1861;0
WireConnection;1802;0;1820;0
WireConnection;1801;0;1873;0
WireConnection;1801;1;1826;0
WireConnection;1879;0;1863;0
WireConnection;1879;1;1882;0
WireConnection;1879;6;1848;0
WireConnection;1862;158;1804;0
WireConnection;1862;183;1880;0
WireConnection;1862;5;1867;0
WireConnection;1869;1;1852;0
WireConnection;1869;0;1825;0
WireConnection;1828;0;1827;0
WireConnection;1886;0;1887;0
WireConnection;2007;0;2036;0
WireConnection;2007;1;2006;0
WireConnection;2007;2;2014;0
WireConnection;1820;0;1883;0
WireConnection;1820;1;1882;0
WireConnection;1820;6;1859;0
WireConnection;1852;0;1823;1
WireConnection;2104;0;2107;2
WireConnection;1998;0;2008;0
WireConnection;1998;1;2031;0
WireConnection;1480;0;1478;0
WireConnection;1872;0;1858;0
WireConnection;1872;1;1843;0
WireConnection;1872;2;1860;0
WireConnection;559;1;563;0
WireConnection;559;6;595;0
WireConnection;2054;0;2053;0
WireConnection;1877;0;1826;0
WireConnection;1811;0;1868;0
WireConnection;1836;0;1810;0
WireConnection;1739;0;1682;0
WireConnection;1722;0;1709;0
WireConnection;1722;1;1708;0
WireConnection;1722;2;1746;0
WireConnection;162;0;176;0
WireConnection;1757;0;1724;0
WireConnection;563;0;590;0
WireConnection;1680;0;1719;0
WireConnection;1680;1;1693;0
WireConnection;1680;2;1711;0
WireConnection;1680;3;1720;0
WireConnection;1680;5;1702;0
WireConnection;1397;158;1400;0
WireConnection;1397;183;1399;0
WireConnection;1397;5;1398;0
WireConnection;1675;0;1722;0
WireConnection;1557;0;1560;0
WireConnection;1557;1;1552;0
WireConnection;1403;158;1406;0
WireConnection;1403;183;1405;0
WireConnection;1403;5;1404;0
WireConnection;133;0;74;0
WireConnection;640;0;635;0
WireConnection;640;1;692;0
WireConnection;640;2;694;0
WireConnection;644;0;2142;0
WireConnection;1402;0;1403;0
WireConnection;694;0;1473;3
WireConnection;1409;158;1412;0
WireConnection;1409;183;1411;0
WireConnection;1409;5;1410;0
WireConnection;157;0;170;0
WireConnection;157;1;142;0
WireConnection;157;2;168;0
WireConnection;130;0;167;0
WireConnection;130;1;175;0
WireConnection;1404;0;1415;0
WireConnection;1544;1;1543;0
WireConnection;1544;2;1546;0
WireConnection;1558;0;1553;0
WireConnection;1547;0;1555;0
WireConnection;566;0;564;0
WireConnection;1560;0;1556;0
WireConnection;1560;1;1548;0
WireConnection;170;0;128;0
WireConnection;1686;0;1694;0
WireConnection;1686;1;1704;0
WireConnection;2144;0;2128;0
WireConnection;586;0;1472;3
WireConnection;576;0;579;0
WireConnection;576;1;578;0
WireConnection;576;2;577;0
WireConnection;1410;0;1416;0
WireConnection;1383;158;1380;0
WireConnection;1383;183;1382;0
WireConnection;1383;5;1386;0
WireConnection;1743;1;1729;0
WireConnection;1743;6;1732;0
WireConnection;2106;0;2098;0
WireConnection;632;0;642;0
WireConnection;632;1;690;0
WireConnection;632;2;1473;1
WireConnection;635;0;632;0
WireConnection;635;1;691;0
WireConnection;635;2;693;0
WireConnection;495;0;14;0
WireConnection;495;1;580;0
WireConnection;495;2;586;0
WireConnection;1408;0;1409;0
WireConnection;1398;0;1414;0
WireConnection;569;0;574;0
WireConnection;569;1;570;0
WireConnection;569;2;571;0
WireConnection;1386;0;1413;0
WireConnection;2142;0;640;0
WireConnection;2142;1;2141;0
WireConnection;477;0;592;0
WireConnection;1705;0;1715;0
WireConnection;622;0;2132;0
WireConnection;1556;0;1549;0
WireConnection;1556;1;1550;0
WireConnection;1556;2;1561;0
WireConnection;585;0;1472;2
WireConnection;565;0;573;0
WireConnection;565;1;489;0
WireConnection;565;2;567;0
WireConnection;139;0;1383;0
WireConnection;11;0;565;0
WireConnection;11;1;569;0
WireConnection;11;2;1472;1
WireConnection;580;0;583;0
WireConnection;580;1;584;0
WireConnection;580;2;581;0
WireConnection;1521;0;429;0
WireConnection;1521;1;432;0
WireConnection;1853;0;1815;0
WireConnection;1853;1;1862;0
WireConnection;1853;2;1814;0
WireConnection;693;0;1473;2
WireConnection;1561;0;1558;0
WireConnection;1763;0;1762;0
WireConnection;1725;0;1760;0
WireConnection;1725;1;1717;0
WireConnection;1725;2;1753;0
WireConnection;608;0;423;0
WireConnection;197;0;365;0
WireConnection;424;0;430;0
WireConnection;424;1;426;0
WireConnection;1562;0;1551;0
WireConnection;1562;1;1559;0
WireConnection;1562;2;1554;0
WireConnection;1562;3;1560;0
WireConnection;1562;4;1557;0
WireConnection;408;0;424;0
WireConnection;1541;0;1540;0
WireConnection;1541;1;1521;0
WireConnection;411;0;169;0
WireConnection;1545;0;429;0
WireConnection;606;0;605;0
WireConnection;363;1;359;0
WireConnection;362;0;157;0
WireConnection;362;2;180;0
WireConnection;359;0;157;0
WireConnection;359;2;159;0
WireConnection;2059;0;2060;0
WireConnection;479;0;594;0
WireConnection;1538;0;429;0
WireConnection;365;0;218;1
WireConnection;365;1;363;1
WireConnection;592;1;563;0
WireConnection;592;6;596;0
WireConnection;488;0;559;0
WireConnection;1546;0;1545;0
WireConnection;1759;0;1756;0
WireConnection;1010;0;698;0
WireConnection;1010;1;1512;0
WireConnection;1010;2;1012;0
WireConnection;414;0;411;0
WireConnection;414;1;412;0
WireConnection;1756;0;1682;0
WireConnection;1756;1;1729;0
WireConnection;1756;6;1748;0
WireConnection;429;0;408;0
WireConnection;429;1;406;0
WireConnection;420;0;425;0
WireConnection;420;1;422;0
WireConnection;1555;0;1562;0
WireConnection;614;0;613;0
WireConnection;1731;0;1737;0
WireConnection;428;0;1544;0
WireConnection;435;0;425;0
WireConnection;435;1;421;0
WireConnection;140;0;413;0
WireConnection;1564;0;705;0
WireConnection;1564;1;1563;0
WireConnection;413;0;414;0
WireConnection;413;1;358;0
WireConnection;610;0;281;0
WireConnection;427;0;420;0
WireConnection;427;1;421;0
WireConnection;406;0;416;0
WireConnection;406;1;435;0
WireConnection;406;2;427;0
WireConnection;2145;0;2144;0
WireConnection;2113;0;2109;0
WireConnection;705;0;704;0
WireConnection;705;1;1010;0
WireConnection;430;0;356;0
WireConnection;430;1;425;0
WireConnection;430;2;420;0
WireConnection;1543;0;431;0
WireConnection;1543;1;1541;0
WireConnection;1543;2;429;0
WireConnection;2;2;286;0
ASEEND*/
//CHKSM=AABD42A2786615650F2A4E1AF23D2EE4837AC92E
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TerrainMaterialShader"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Header(OutInBrume)]_Out_or_InBrume("Out_or_InBrume?", Range( 0 , 1)) = 0
		[Header(TerrainMask)]_TerrainMaskTexture("TerrainMaskTexture", 2D) = "white" {}
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
		[Header(Texture 1 VertexPaintBlack)]_TA_1_Textures("TA_1_Textures", 2DArray) = "white" {}
		_TA_1_Grunges("TA_1_Grunges", 2DArray) = "white" {}
		_T1_ColorCorrection("T1_ColorCorrection", Color) = (1,1,1,0)
		_T1_Albedo_ProceduralTiling("T1_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T1_Albedo_Tiling("T1_Albedo_Tiling", Float) = 1
		[Header(T1 Paint Grunge)]_T1_PaintGrunge("T1_PaintGrunge?", Range( 0 , 1)) = 0
		_T1_PaintGrunge_Tiling("T1_PaintGrunge_Tiling", Float) = 1
		_T1_PaintGrunge_Contrast("T1_PaintGrunge_Contrast", Float) = 0
		_T1_PaintGrunge_Multiply("T1_PaintGrunge_Multiply", Float) = 0
		[Header(T1 Animated Grunge)]_T1_AnimatedGrunge("T1_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T1_IsGrungeAnimated("T1_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T1_AnimatedGrunge_ScreenBased("T1_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T1_AnimatedGrunge_Tiling("T1_AnimatedGrunge_Tiling", Float) = 1
		_T1_AnimatedGrunge_Flipbook_Columns("T1_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T1_AnimatedGrunge_Flipbook_Rows("T1_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T1_AnimatedGrunge_Flipbook_Speed("T1_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T1_AnimatedGrunge_Contrast("T1_AnimatedGrunge_Contrast", Float) = 1.58
		_T1_AnimatedGrunge_Multiply("T1_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 2 VertexPaintRed)]_TA_2_Textures("TA_2_Textures", 2DArray) = "white" {}
		_TA_2_Grunges("TA_2_Grunges", 2DArray) = "white" {}
		_T2_ColorCorrection("T2_ColorCorrection", Color) = (1,1,1,0)
		_T2_Albedo_Contrast("T2_Albedo_Contrast", Float) = 0
		_T2_Albedo_ProceduralTiling("T2_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T2_Albedo_Tiling("T2_Albedo_Tiling", Float) = 1
		[Header(T2 Paint Grunge)]_T2_PaintGrunge("T2_PaintGrunge?", Range( 0 , 1)) = 0
		_T2_PaintGrunge_Tiling("T2_PaintGrunge_Tiling", Float) = 1
		_T2_PaintGrunge_Contrast("T2_PaintGrunge_Contrast", Float) = 0
		_T2_PaintGrunge_Multiply("T2_PaintGrunge_Multiply", Float) = 0
		[Header(T2 Animated Grunge)]_T2_AnimatedGrunge("T2_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T2_IsGrungeAnimated("T2_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T2_AnimatedGrunge_ScreenBased("T2_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T2_AnimatedGrunge_Tiling("T2_AnimatedGrunge_Tiling", Float) = 1
		_T2_AnimatedGrunge_Flipbook_Columns("T2_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T2_AnimatedGrunge_Flipbook_Rows("T2_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T2_AnimatedGrunge_Flipbook_Speed("T2_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T2_AnimatedGrunge_Contrast("T2_AnimatedGrunge_Contrast", Float) = 1.58
		_T2_AnimatedGrunge_Multiply("T2_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 3 VertexPaintGreen)]_TA_3_Textures("TA_3_Textures", 2DArray) = "white" {}
		_TA_3_Grunges("TA_3_Grunges", 2DArray) = "white" {}
		_T3_ColorCorrection("T3_ColorCorrection", Color) = (1,1,1,0)
		_T3_Albedo_ProceduralTiling("T3_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T3_Albedo_Tiling("T3_Albedo_Tiling", Float) = 1
		[Header(T3 Paint Grunge)]_T3_PaintGrunge("T3_PaintGrunge?", Range( 0 , 1)) = 0
		_T3_PaintGrunge_Tiling("T3_PaintGrunge_Tiling", Float) = 1
		_T3_PaintGrunge_Contrast("T3_PaintGrunge_Contrast", Float) = 0
		_T3_PaintGrunge_Multiply("T3_PaintGrunge_Multiply", Float) = 0
		[Header(T3 Animated Grunge)]_T3_AnimatedGrunge("T3_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T3_IsGrungeAnimated("T3_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T3_AnimatedGrunge_ScreenBased("T3_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T3_AnimatedGrunge_Tiling("T3_AnimatedGrunge_Tiling", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Columns("T3_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Rows("T3_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Speed("T3_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T3_AnimatedGrunge_Contrast("T3_AnimatedGrunge_Contrast", Float) = 1.58
		_T3_AnimatedGrunge_Multiply("T3_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Texture 4 VertexPaintBlue)]_TA_4_Textures("TA_4_Textures", 2DArray) = "white" {}
		_TA_4_Grunges("TA_4_Grunges", 2DArray) = "white" {}
		_T4_ColorCorrection("T4_ColorCorrection", Color) = (1,1,1,0)
		_T4_Albedo_ProceduralTiling("T4_Albedo_ProceduralTiling?", Range( 0 , 1)) = 0
		_T4_Albedo_Tiling("T4_Albedo_Tiling", Float) = 1
		[Header(T4 Paint Grunge)]_T4_PaintGrunge("T4_PaintGrunge?", Range( 0 , 1)) = 0
		_T4_PaintGrunge_Tiling("T4_PaintGrunge_Tiling", Float) = 1
		_T4_PaintGrunge_Contrast("T4_PaintGrunge_Contrast", Float) = 0
		_T4_PaintGrunge_Multiply("T4_PaintGrunge_Multiply", Float) = 0
		[Header(T4 Animated Grunge)]_T4_AnimatedGrunge("T4_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T4_IsGrungeAnimated("T4_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_T4_AnimatedGrunge_ScreenBased("T4_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_T4_AnimatedGrunge_Tiling("T4_AnimatedGrunge_Tiling", Float) = 1
		_T4_AnimatedGrunge_Flipbook_Columns("T4_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T4_AnimatedGrunge_Flipbook_Rows("T4_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T4_AnimatedGrunge_Flipbook_Speed("T4_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T4_AnimatedGrunge_Contrast("T4_AnimatedGrunge_Contrast", Float) = 1.58
		_T4_AnimatedGrunge_Multiply("T4_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Fake Lights)]_FakeLightArrayLength("FakeLightArrayLength", Float) = 0
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
			float4 _T2_ColorCorrection;
			float4 _T4_ColorCorrection;
			float4 _TerrainMaskTexture_ST;
			float4 _FakeLight_Color;
			float4 _ShadowColor;
			float4 _EdgeShadowColor;
			float4 _T3_ColorCorrection;
			float4 _T1_ColorCorrection;
			float2 _ShadowNoisePanner;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_AnimatedGrunge_Tiling;
			float _T4_AnimatedGrunge_Contrast;
			float _T1_AnimatedGrunge_Contrast;
			float _T3_Albedo_Tiling;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T3_PaintGrunge;
			float _T3_PaintGrunge_Multiply;
			float _T3_PaintGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _T3_AnimatedGrunge;
			float _T3_Albedo_ProceduralTiling;
			float _T4_IsGrungeAnimated;
			float _T4_PaintGrunge_Tiling;
			float _T4_AnimatedGrunge;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _WaveFakeLight_Max;
			float _FakeLightArrayLength;
			float _ScreenBasedShadowNoise;
			float _T4_AnimatedGrunge_Multiply;
			float _Noise_Tiling;
			float _StepShadow;
			float _T4_Albedo_ProceduralTiling;
			float _T4_Albedo_Tiling;
			float _T4_PaintGrunge;
			float _T4_PaintGrunge_Multiply;
			float _T3_AnimatedGrunge_Multiply;
			float _T4_PaintGrunge_Contrast;
			float _StepAttenuation;
			float _T3_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _LightDebug;
			float _DebugTextureTiling;
			float _Out_or_InBrume;
			float _GrayscaleDebug;
			float _T1_Albedo_ProceduralTiling;
			float _T1_Albedo_Tiling;
			float _T1_PaintGrunge;
			float _T1_PaintGrunge_Multiply;
			float _T1_PaintGrunge_Tiling;
			float _T1_PaintGrunge_Contrast;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_AnimatedGrunge_ScreenBased;
			float _T1_AnimatedGrunge_Tiling;
			float _DebugVertexPaint;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Contrast;
			float _T2_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _T3_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_Albedo_ProceduralTiling;
			float _T2_Albedo_Tiling;
			float _T2_Albedo_Contrast;
			float _T2_PaintGrunge;
			float _T2_PaintGrunge_Multiply;
			float _T2_PaintGrunge_Tiling;
			float _T2_PaintGrunge_Contrast;
			float _T2_AnimatedGrunge;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_IsGrungeAnimated;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _T2_AnimatedGrunge_Tiling;
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
			TEXTURE2D_ARRAY(_TA_1_Grunges);
			SAMPLER(sampler_TA_1_Grunges);
			TEXTURE2D_ARRAY(_TA_1_Textures);
			SAMPLER(sampler_TA_1_Textures);
			TEXTURE2D_ARRAY(_DebugTextureArray);
			SAMPLER(sampler_DebugTextureArray);
			TEXTURE2D_ARRAY(_TA_2_Grunges);
			SAMPLER(sampler_TA_2_Grunges);
			TEXTURE2D_ARRAY(_TA_2_Textures);
			SAMPLER(sampler_TA_2_Textures);
			sampler2D _TerrainMaskTexture;
			TEXTURE2D_ARRAY(_TA_3_Grunges);
			SAMPLER(sampler_TA_3_Grunges);
			TEXTURE2D_ARRAY(_TA_3_Textures);
			SAMPLER(sampler_TA_3_Textures);
			TEXTURE2D_ARRAY(_TA_4_Grunges);
			SAMPLER(sampler_TA_4_Grunges);
			TEXTURE2D_ARRAY(_TA_4_Textures);
			SAMPLER(sampler_TA_4_Textures);
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
				float3 temp_cast_2 = (SAMPLE_TEXTURE2D_ARRAY( _TA_1_Grunges, sampler_TA_1_Grunges, lerpResult158,0.0 ).r).xxx;
				float grayscale403 = Luminance(temp_cast_2);
				float4 temp_cast_3 = (grayscale403).xxxx;
				float4 lerpResult1423 = lerp( temp_cast_0 , ( CalculateContrast(_T1_AnimatedGrunge_Contrast,temp_cast_3) * _T1_AnimatedGrunge_Multiply ) , _T1_AnimatedGrunge);
				float localStochasticTiling171_g126 = ( 0.0 );
				float2 temp_cast_4 = (_T1_PaintGrunge_Tiling).xx;
				float2 texCoord1394 = IN.ase_texcoord4.xy * temp_cast_4 + float2( 0,0 );
				float2 Input_UV145_g126 = texCoord1394;
				float2 UV171_g126 = Input_UV145_g126;
				float2 UV1171_g126 = float2( 0,0 );
				float2 UV2171_g126 = float2( 0,0 );
				float2 UV3171_g126 = float2( 0,0 );
				float W1171_g126 = 0.0;
				float W2171_g126 = 0.0;
				float W3171_g126 = 0.0;
				StochasticTiling( UV171_g126 , UV1171_g126 , UV2171_g126 , UV3171_g126 , W1171_g126 , W2171_g126 , W3171_g126 );
				float Input_Index184_g126 = 3.0;
				float2 temp_output_172_0_g126 = ddx( Input_UV145_g126 );
				float2 temp_output_182_0_g126 = ddy( Input_UV145_g126 );
				float4 Output_2DArray294_g126 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV1171_g126,Input_Index184_g126, temp_output_172_0_g126, temp_output_182_0_g126 ) * W1171_g126 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV2171_g126,Input_Index184_g126, temp_output_172_0_g126, temp_output_182_0_g126 ) * W2171_g126 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV3171_g126,Input_Index184_g126, temp_output_172_0_g126, temp_output_182_0_g126 ) * W3171_g126 ) );
				float lerpResult1420 = lerp( 1.0 , ( CalculateContrast(_T1_PaintGrunge_Contrast,Output_2DArray294_g126) * _T1_PaintGrunge_Multiply ).r , _T1_PaintGrunge);
				float T1_Albedo_Tiling1379 = _T1_Albedo_Tiling;
				float2 temp_cast_5 = (T1_Albedo_Tiling1379).xx;
				float2 texCoord1385 = IN.ase_texcoord4.xy * temp_cast_5 + float2( 0,0 );
				float localStochasticTiling171_g122 = ( 0.0 );
				float2 Input_UV145_g122 = texCoord1385;
				float2 UV171_g122 = Input_UV145_g122;
				float2 UV1171_g122 = float2( 0,0 );
				float2 UV2171_g122 = float2( 0,0 );
				float2 UV3171_g122 = float2( 0,0 );
				float W1171_g122 = 0.0;
				float W2171_g122 = 0.0;
				float W3171_g122 = 0.0;
				StochasticTiling( UV171_g122 , UV1171_g122 , UV2171_g122 , UV3171_g122 , W1171_g122 , W2171_g122 , W3171_g122 );
				float Input_Index184_g122 = 0.0;
				float2 temp_output_172_0_g122 = ddx( Input_UV145_g122 );
				float2 temp_output_182_0_g122 = ddy( Input_UV145_g122 );
				float4 Output_2DArray294_g122 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV1171_g122,Input_Index184_g122, temp_output_172_0_g122, temp_output_182_0_g122 ) * W1171_g122 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV2171_g122,Input_Index184_g122, temp_output_172_0_g122, temp_output_182_0_g122 ) * W2171_g122 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV3171_g122,Input_Index184_g122, temp_output_172_0_g122, temp_output_182_0_g122 ) * W3171_g122 ) );
				float4 lerpResult1434 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_1_Textures, sampler_TA_1_Textures, texCoord1385,0.0 ) , Output_2DArray294_g122 , _T1_Albedo_ProceduralTiling);
				float4 temp_output_335_0 = ( lerpResult1434 * _T1_ColorCorrection );
				float grayscale252 = dot(temp_output_335_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_7 = (grayscale252).xxxx;
				float GrayscaleDebug614 = _GrayscaleDebug;
				float4 lerpResult191 = lerp( temp_output_335_0 , temp_cast_7 , GrayscaleDebug614);
				float4 blendOpSrc190 = ( lerpResult1423 * lerpResult1420 );
				float4 blendOpDest190 = lerpResult191;
				float4 T1_RGB202 = ( saturate( ( blendOpSrc190 * blendOpDest190 ) ));
				float4 T1_End_OutBrume187 = T1_RGB202;
				float grayscale1476 = Luminance(T1_End_OutBrume187.rgb);
				float T1_End_InBrume1477 = grayscale1476;
				float4 temp_cast_9 = (T1_End_InBrume1477).xxxx;
				float Out_or_InBrume606 = _Out_or_InBrume;
				float4 lerpResult340 = lerp( T1_End_OutBrume187 , temp_cast_9 , Out_or_InBrume606);
				float4 Texture1_Final748 = lerpResult340;
				float2 temp_cast_10 = (_DebugTextureTiling).xx;
				float2 texCoord563 = IN.ase_texcoord4.xy * temp_cast_10 + float2( 0,0 );
				float4 DebugColor1488 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,0.0 );
				float DebugVertexPaint566 = _DebugVertexPaint;
				float4 lerpResult565 = lerp( Texture1_Final748 , DebugColor1488 , DebugVertexPaint566);
				float4 temp_cast_11 = (1.0).xxxx;
				float2 temp_cast_12 = (_T2_AnimatedGrunge_Tiling).xx;
				float2 texCoord1460 = IN.ase_texcoord4.xy * temp_cast_12 + float2( 0,0 );
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
				float3 temp_cast_13 = (SAMPLE_TEXTURE2D_ARRAY( _TA_2_Grunges, sampler_TA_2_Grunges, lerpResult891,0.0 ).r).xxx;
				float grayscale907 = Luminance(temp_cast_13);
				float4 temp_cast_14 = (grayscale907).xxxx;
				float4 lerpResult1427 = lerp( temp_cast_11 , ( CalculateContrast(_T2_AnimatedGrunge_Contrast,temp_cast_14) * _T2_AnimatedGrunge_Multiply ) , _T2_AnimatedGrunge);
				float localStochasticTiling171_g130 = ( 0.0 );
				float2 temp_cast_15 = (_T2_PaintGrunge_Tiling).xx;
				float2 texCoord1393 = IN.ase_texcoord4.xy * temp_cast_15 + float2( 0,0 );
				float2 Input_UV145_g130 = texCoord1393;
				float2 UV171_g130 = Input_UV145_g130;
				float2 UV1171_g130 = float2( 0,0 );
				float2 UV2171_g130 = float2( 0,0 );
				float2 UV3171_g130 = float2( 0,0 );
				float W1171_g130 = 0.0;
				float W2171_g130 = 0.0;
				float W3171_g130 = 0.0;
				StochasticTiling( UV171_g130 , UV1171_g130 , UV2171_g130 , UV3171_g130 , W1171_g130 , W2171_g130 , W3171_g130 );
				float Input_Index184_g130 = 4.0;
				float2 temp_output_172_0_g130 = ddx( Input_UV145_g130 );
				float2 temp_output_182_0_g130 = ddy( Input_UV145_g130 );
				float4 Output_2DArray294_g130 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV1171_g130,Input_Index184_g130, temp_output_172_0_g130, temp_output_182_0_g130 ) * W1171_g130 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV2171_g130,Input_Index184_g130, temp_output_172_0_g130, temp_output_182_0_g130 ) * W2171_g130 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV3171_g130,Input_Index184_g130, temp_output_172_0_g130, temp_output_182_0_g130 ) * W3171_g130 ) );
				float lerpResult1431 = lerp( 1.0 , ( CalculateContrast(_T2_PaintGrunge_Contrast,Output_2DArray294_g130) * _T2_PaintGrunge_Multiply ).r , _T2_PaintGrunge);
				float T2_Albedo_Tiling1378 = _T2_Albedo_Tiling;
				float2 temp_cast_16 = (T2_Albedo_Tiling1378).xx;
				float2 texCoord1392 = IN.ase_texcoord4.xy * temp_cast_16 + float2( 0,0 );
				float localStochasticTiling171_g121 = ( 0.0 );
				float2 Input_UV145_g121 = texCoord1392;
				float2 UV171_g121 = Input_UV145_g121;
				float2 UV1171_g121 = float2( 0,0 );
				float2 UV2171_g121 = float2( 0,0 );
				float2 UV3171_g121 = float2( 0,0 );
				float W1171_g121 = 0.0;
				float W2171_g121 = 0.0;
				float W3171_g121 = 0.0;
				StochasticTiling( UV171_g121 , UV1171_g121 , UV2171_g121 , UV3171_g121 , W1171_g121 , W2171_g121 , W3171_g121 );
				float Input_Index184_g121 = 0.0;
				float2 temp_output_172_0_g121 = ddx( Input_UV145_g121 );
				float2 temp_output_182_0_g121 = ddy( Input_UV145_g121 );
				float4 Output_2DArray294_g121 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV1171_g121,Input_Index184_g121, temp_output_172_0_g121, temp_output_182_0_g121 ) * W1171_g121 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV2171_g121,Input_Index184_g121, temp_output_172_0_g121, temp_output_182_0_g121 ) * W2171_g121 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV3171_g121,Input_Index184_g121, temp_output_172_0_g121, temp_output_182_0_g121 ) * W3171_g121 ) );
				float4 lerpResult1437 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_2_Textures, sampler_TA_2_Textures, texCoord1392,0.0 ) , Output_2DArray294_g121 , _T2_Albedo_ProceduralTiling);
				float4 temp_output_903_0 = ( _T2_ColorCorrection * lerpResult1437 );
				float grayscale905 = dot(temp_output_903_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_18 = (grayscale905).xxxx;
				float4 lerpResult886 = lerp( CalculateContrast(_T2_Albedo_Contrast,temp_output_903_0) , temp_cast_18 , GrayscaleDebug614);
				float4 blendOpSrc912 = ( lerpResult1427 * lerpResult1431 );
				float4 blendOpDest912 = lerpResult886;
				float4 T2_RGB816 = ( saturate( ( blendOpSrc912 * blendOpDest912 ) ));
				float4 T2_End_OutBrume839 = T2_RGB816;
				float grayscale1478 = Luminance(T2_End_OutBrume839.rgb);
				float T2_End_InBrume1480 = grayscale1478;
				float4 temp_cast_20 = (T2_End_InBrume1480).xxxx;
				float4 lerpResult871 = lerp( T2_End_OutBrume839 , temp_cast_20 , Out_or_InBrume606);
				float4 Texture2_Final868 = lerpResult871;
				float4 DebugColor2477 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,1.0 );
				float4 lerpResult569 = lerp( Texture2_Final868 , DebugColor2477 , DebugVertexPaint566);
				float2 uv_TerrainMaskTexture = IN.ase_texcoord4.xy * _TerrainMaskTexture_ST.xy + _TerrainMaskTexture_ST.zw;
				float4 tex2DNode1472 = tex2D( _TerrainMaskTexture, uv_TerrainMaskTexture );
				float4 lerpResult11 = lerp( lerpResult565 , lerpResult569 , tex2DNode1472.r);
				float4 temp_cast_21 = (1.0).xxxx;
				float2 temp_cast_22 = (_T3_AnimatedGrunge_Tiling).xx;
				float2 texCoord1466 = IN.ase_texcoord4.xy * temp_cast_22 + float2( 0,0 );
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
				float3 temp_cast_23 = (SAMPLE_TEXTURE2D_ARRAY( _TA_3_Grunges, sampler_TA_3_Grunges, lerpResult1081,0.0 ).r).xxx;
				float grayscale1112 = Luminance(temp_cast_23);
				float4 temp_cast_24 = (grayscale1112).xxxx;
				float4 lerpResult1446 = lerp( temp_cast_21 , ( CalculateContrast(_T3_AnimatedGrunge_Contrast,temp_cast_24) * _T3_AnimatedGrunge_Multiply ) , _T3_AnimatedGrunge);
				float localStochasticTiling171_g128 = ( 0.0 );
				float2 temp_cast_25 = (_T3_PaintGrunge_Tiling).xx;
				float2 texCoord1391 = IN.ase_texcoord4.xy * temp_cast_25 + float2( 0,0 );
				float2 Input_UV145_g128 = texCoord1391;
				float2 UV171_g128 = Input_UV145_g128;
				float2 UV1171_g128 = float2( 0,0 );
				float2 UV2171_g128 = float2( 0,0 );
				float2 UV3171_g128 = float2( 0,0 );
				float W1171_g128 = 0.0;
				float W2171_g128 = 0.0;
				float W3171_g128 = 0.0;
				StochasticTiling( UV171_g128 , UV1171_g128 , UV2171_g128 , UV3171_g128 , W1171_g128 , W2171_g128 , W3171_g128 );
				float Input_Index184_g128 = 4.0;
				float2 temp_output_172_0_g128 = ddx( Input_UV145_g128 );
				float2 temp_output_182_0_g128 = ddy( Input_UV145_g128 );
				float4 Output_2DArray294_g128 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV1171_g128,Input_Index184_g128, temp_output_172_0_g128, temp_output_182_0_g128 ) * W1171_g128 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV2171_g128,Input_Index184_g128, temp_output_172_0_g128, temp_output_182_0_g128 ) * W2171_g128 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV3171_g128,Input_Index184_g128, temp_output_172_0_g128, temp_output_182_0_g128 ) * W3171_g128 ) );
				float lerpResult1450 = lerp( 1.0 , ( CalculateContrast(_T3_PaintGrunge_Contrast,Output_2DArray294_g128) * _T3_PaintGrunge_Multiply ).r , _T3_PaintGrunge);
				float T3_Albedo_Tiling1377 = _T3_Albedo_Tiling;
				float2 temp_cast_26 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1390 = IN.ase_texcoord4.xy * temp_cast_26 + float2( 0,0 );
				float localStochasticTiling171_g131 = ( 0.0 );
				float2 Input_UV145_g131 = texCoord1390;
				float2 UV171_g131 = Input_UV145_g131;
				float2 UV1171_g131 = float2( 0,0 );
				float2 UV2171_g131 = float2( 0,0 );
				float2 UV3171_g131 = float2( 0,0 );
				float W1171_g131 = 0.0;
				float W2171_g131 = 0.0;
				float W3171_g131 = 0.0;
				StochasticTiling( UV171_g131 , UV1171_g131 , UV2171_g131 , UV3171_g131 , W1171_g131 , W2171_g131 , W3171_g131 );
				float Input_Index184_g131 = 0.0;
				float2 temp_output_172_0_g131 = ddx( Input_UV145_g131 );
				float2 temp_output_182_0_g131 = ddy( Input_UV145_g131 );
				float4 Output_2DArray294_g131 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV1171_g131,Input_Index184_g131, temp_output_172_0_g131, temp_output_182_0_g131 ) * W1171_g131 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV2171_g131,Input_Index184_g131, temp_output_172_0_g131, temp_output_182_0_g131 ) * W2171_g131 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV3171_g131,Input_Index184_g131, temp_output_172_0_g131, temp_output_182_0_g131 ) * W3171_g131 ) );
				float4 lerpResult1441 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_3_Textures, sampler_TA_3_Textures, texCoord1390,0.0 ) , Output_2DArray294_g131 , _T3_Albedo_ProceduralTiling);
				float4 temp_output_1094_0 = ( _T3_ColorCorrection * lerpResult1441 );
				float grayscale1113 = dot(temp_output_1094_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_28 = (grayscale1113).xxxx;
				float4 lerpResult1085 = lerp( temp_output_1094_0 , temp_cast_28 , GrayscaleDebug614);
				float4 blendOpSrc1107 = ( lerpResult1446 * lerpResult1450 );
				float4 blendOpDest1107 = lerpResult1085;
				float4 T3_RGB1187 = ( saturate( ( blendOpSrc1107 * blendOpDest1107 ) ));
				float4 T3_End_OutBrume1119 = T3_RGB1187;
				float grayscale1481 = Luminance(T3_End_OutBrume1119.rgb);
				float T3_End_InBrume1482 = grayscale1481;
				float4 temp_cast_30 = (T3_End_InBrume1482).xxxx;
				float4 lerpResult1196 = lerp( T3_End_OutBrume1119 , temp_cast_30 , Out_or_InBrume606);
				float4 Texture3_Final1214 = lerpResult1196;
				float4 DebugColor3478 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,2.0 );
				float4 lerpResult576 = lerp( Texture3_Final1214 , DebugColor3478 , DebugVertexPaint566);
				float4 lerpResult14 = lerp( lerpResult11 , lerpResult576 , tex2DNode1472.g);
				float4 temp_cast_31 = (1.0).xxxx;
				float2 temp_cast_32 = (_T4_AnimatedGrunge_Tiling).xx;
				float2 texCoord1470 = IN.ase_texcoord4.xy * temp_cast_32 + float2( 0,0 );
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
				float3 temp_cast_33 = (SAMPLE_TEXTURE2D_ARRAY( _TA_4_Grunges, sampler_TA_4_Grunges, lerpResult1069,0.0 ).r).xxx;
				float grayscale1097 = Luminance(temp_cast_33);
				float4 temp_cast_34 = (grayscale1097).xxxx;
				float4 lerpResult1453 = lerp( temp_cast_31 , ( CalculateContrast(_T4_AnimatedGrunge_Contrast,temp_cast_34) * _T4_AnimatedGrunge_Multiply ) , _T4_AnimatedGrunge);
				float localStochasticTiling171_g129 = ( 0.0 );
				float2 temp_cast_35 = (_T4_PaintGrunge_Tiling).xx;
				float2 texCoord1388 = IN.ase_texcoord4.xy * temp_cast_35 + float2( 0,0 );
				float2 Input_UV145_g129 = texCoord1388;
				float2 UV171_g129 = Input_UV145_g129;
				float2 UV1171_g129 = float2( 0,0 );
				float2 UV2171_g129 = float2( 0,0 );
				float2 UV3171_g129 = float2( 0,0 );
				float W1171_g129 = 0.0;
				float W2171_g129 = 0.0;
				float W3171_g129 = 0.0;
				StochasticTiling( UV171_g129 , UV1171_g129 , UV2171_g129 , UV3171_g129 , W1171_g129 , W2171_g129 , W3171_g129 );
				float Input_Index184_g129 = 4.0;
				float2 temp_output_172_0_g129 = ddx( Input_UV145_g129 );
				float2 temp_output_182_0_g129 = ddy( Input_UV145_g129 );
				float4 Output_2DArray294_g129 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV1171_g129,Input_Index184_g129, temp_output_172_0_g129, temp_output_182_0_g129 ) * W1171_g129 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV2171_g129,Input_Index184_g129, temp_output_172_0_g129, temp_output_182_0_g129 ) * W2171_g129 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV3171_g129,Input_Index184_g129, temp_output_172_0_g129, temp_output_182_0_g129 ) * W3171_g129 ) );
				float lerpResult1455 = lerp( 1.0 , ( CalculateContrast(_T4_PaintGrunge_Contrast,Output_2DArray294_g129) * _T4_PaintGrunge_Multiply ).r , _T4_PaintGrunge);
				float T4_Albedo_Tiling1376 = _T4_Albedo_Tiling;
				float2 temp_cast_36 = (T4_Albedo_Tiling1376).xx;
				float2 texCoord1389 = IN.ase_texcoord4.xy * temp_cast_36 + float2( 0,0 );
				float localStochasticTiling171_g125 = ( 0.0 );
				float2 Input_UV145_g125 = texCoord1389;
				float2 UV171_g125 = Input_UV145_g125;
				float2 UV1171_g125 = float2( 0,0 );
				float2 UV2171_g125 = float2( 0,0 );
				float2 UV3171_g125 = float2( 0,0 );
				float W1171_g125 = 0.0;
				float W2171_g125 = 0.0;
				float W3171_g125 = 0.0;
				StochasticTiling( UV171_g125 , UV1171_g125 , UV2171_g125 , UV3171_g125 , W1171_g125 , W2171_g125 , W3171_g125 );
				float Input_Index184_g125 = 0.0;
				float2 temp_output_172_0_g125 = ddx( Input_UV145_g125 );
				float2 temp_output_182_0_g125 = ddy( Input_UV145_g125 );
				float4 Output_2DArray294_g125 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV1171_g125,Input_Index184_g125, temp_output_172_0_g125, temp_output_182_0_g125 ) * W1171_g125 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV2171_g125,Input_Index184_g125, temp_output_172_0_g125, temp_output_182_0_g125 ) * W2171_g125 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV3171_g125,Input_Index184_g125, temp_output_172_0_g125, temp_output_182_0_g125 ) * W3171_g125 ) );
				float4 lerpResult1444 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_4_Textures, sampler_TA_4_Textures, texCoord1389,0.0 ) , Output_2DArray294_g125 , _T4_Albedo_ProceduralTiling);
				float4 temp_output_1079_0 = ( _T4_ColorCorrection * lerpResult1444 );
				float grayscale1051 = dot(temp_output_1079_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_38 = (grayscale1051).xxxx;
				float4 lerpResult1074 = lerp( temp_output_1079_0 , temp_cast_38 , GrayscaleDebug614);
				float4 blendOpSrc1064 = ( lerpResult1453 * lerpResult1455 );
				float4 blendOpDest1064 = lerpResult1074;
				float4 T4_RGB1122 = ( saturate( ( blendOpSrc1064 * blendOpDest1064 ) ));
				float4 T4_End_OutBrume1120 = T4_RGB1122;
				float grayscale1484 = Luminance(T4_End_OutBrume1120.rgb);
				float T4_End_InBrume1485 = grayscale1484;
				float4 temp_cast_40 = (T4_End_InBrume1485).xxxx;
				float4 lerpResult1050 = lerp( T4_End_OutBrume1120 , temp_cast_40 , Out_or_InBrume606);
				float4 Texture4_Final1364 = lerpResult1050;
				float4 DebugColor4479 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,3.0 );
				float4 lerpResult580 = lerp( Texture4_Final1364 , DebugColor4479 , DebugVertexPaint566);
				float4 lerpResult495 = lerp( lerpResult14 , lerpResult580 , tex2DNode1472.b);
				float4 AllAlbedo622 = lerpResult495;
				float temp_output_420_0 = ( _StepShadow + _StepAttenuation );
				float localStochasticTiling171_g133 = ( 0.0 );
				float2 temp_cast_41 = (T1_Albedo_Tiling1379).xx;
				float2 texCoord1386 = IN.ase_texcoord4.xy * temp_cast_41 + float2( 0,0 );
				float2 Input_UV145_g133 = texCoord1386;
				float2 UV171_g133 = Input_UV145_g133;
				float2 UV1171_g133 = float2( 0,0 );
				float2 UV2171_g133 = float2( 0,0 );
				float2 UV3171_g133 = float2( 0,0 );
				float W1171_g133 = 0.0;
				float W2171_g133 = 0.0;
				float W3171_g133 = 0.0;
				StochasticTiling( UV171_g133 , UV1171_g133 , UV2171_g133 , UV3171_g133 , W1171_g133 , W2171_g133 , W3171_g133 );
				float Input_Index184_g133 = 1.0;
				float2 temp_output_172_0_g133 = ddx( Input_UV145_g133 );
				float2 temp_output_182_0_g133 = ddy( Input_UV145_g133 );
				float4 Output_2DArray294_g133 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV1171_g133,Input_Index184_g133, temp_output_172_0_g133, temp_output_182_0_g133 ) * W1171_g133 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV2171_g133,Input_Index184_g133, temp_output_172_0_g133, temp_output_182_0_g133 ) * W2171_g133 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV3171_g133,Input_Index184_g133, temp_output_172_0_g133, temp_output_182_0_g133 ) * W3171_g133 ) );
				float4 T1_Normal_Texture139 = Output_2DArray294_g133;
				float localStochasticTiling171_g124 = ( 0.0 );
				float2 temp_cast_42 = (T2_Albedo_Tiling1378).xx;
				float2 texCoord1398 = IN.ase_texcoord4.xy * temp_cast_42 + float2( 0,0 );
				float2 Input_UV145_g124 = texCoord1398;
				float2 UV171_g124 = Input_UV145_g124;
				float2 UV1171_g124 = float2( 0,0 );
				float2 UV2171_g124 = float2( 0,0 );
				float2 UV3171_g124 = float2( 0,0 );
				float W1171_g124 = 0.0;
				float W2171_g124 = 0.0;
				float W3171_g124 = 0.0;
				StochasticTiling( UV171_g124 , UV1171_g124 , UV2171_g124 , UV3171_g124 , W1171_g124 , W2171_g124 , W3171_g124 );
				float Input_Index184_g124 = 1.0;
				float2 temp_output_172_0_g124 = ddx( Input_UV145_g124 );
				float2 temp_output_182_0_g124 = ddy( Input_UV145_g124 );
				float4 Output_2DArray294_g124 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV1171_g124,Input_Index184_g124, temp_output_172_0_g124, temp_output_182_0_g124 ) * W1171_g124 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV2171_g124,Input_Index184_g124, temp_output_172_0_g124, temp_output_182_0_g124 ) * W2171_g124 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV3171_g124,Input_Index184_g124, temp_output_172_0_g124, temp_output_182_0_g124 ) * W3171_g124 ) );
				float4 T2_Normal_Texture1396 = Output_2DArray294_g124;
				float4 tex2DNode1473 = tex2D( _TerrainMaskTexture, uv_TerrainMaskTexture );
				float4 lerpResult632 = lerp( T1_Normal_Texture139 , T2_Normal_Texture1396 , tex2DNode1473.r);
				float localStochasticTiling171_g123 = ( 0.0 );
				float2 temp_cast_43 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1404 = IN.ase_texcoord4.xy * temp_cast_43 + float2( 0,0 );
				float2 Input_UV145_g123 = texCoord1404;
				float2 UV171_g123 = Input_UV145_g123;
				float2 UV1171_g123 = float2( 0,0 );
				float2 UV2171_g123 = float2( 0,0 );
				float2 UV3171_g123 = float2( 0,0 );
				float W1171_g123 = 0.0;
				float W2171_g123 = 0.0;
				float W3171_g123 = 0.0;
				StochasticTiling( UV171_g123 , UV1171_g123 , UV2171_g123 , UV3171_g123 , W1171_g123 , W2171_g123 , W3171_g123 );
				float Input_Index184_g123 = 1.0;
				float2 temp_output_172_0_g123 = ddx( Input_UV145_g123 );
				float2 temp_output_182_0_g123 = ddy( Input_UV145_g123 );
				float4 Output_2DArray294_g123 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV1171_g123,Input_Index184_g123, temp_output_172_0_g123, temp_output_182_0_g123 ) * W1171_g123 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV2171_g123,Input_Index184_g123, temp_output_172_0_g123, temp_output_182_0_g123 ) * W2171_g123 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV3171_g123,Input_Index184_g123, temp_output_172_0_g123, temp_output_182_0_g123 ) * W3171_g123 ) );
				float4 T3_Normal_Texture1402 = Output_2DArray294_g123;
				float4 lerpResult635 = lerp( lerpResult632 , T3_Normal_Texture1402 , tex2DNode1473.g);
				float localStochasticTiling171_g132 = ( 0.0 );
				float2 temp_cast_44 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1410 = IN.ase_texcoord4.xy * temp_cast_44 + float2( 0,0 );
				float2 Input_UV145_g132 = texCoord1410;
				float2 UV171_g132 = Input_UV145_g132;
				float2 UV1171_g132 = float2( 0,0 );
				float2 UV2171_g132 = float2( 0,0 );
				float2 UV3171_g132 = float2( 0,0 );
				float W1171_g132 = 0.0;
				float W2171_g132 = 0.0;
				float W3171_g132 = 0.0;
				StochasticTiling( UV171_g132 , UV1171_g132 , UV2171_g132 , UV3171_g132 , W1171_g132 , W2171_g132 , W3171_g132 );
				float Input_Index184_g132 = 1.0;
				float2 temp_output_172_0_g132 = ddx( Input_UV145_g132 );
				float2 temp_output_182_0_g132 = ddy( Input_UV145_g132 );
				float4 Output_2DArray294_g132 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV1171_g132,Input_Index184_g132, temp_output_172_0_g132, temp_output_182_0_g132 ) * W1171_g132 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV2171_g132,Input_Index184_g132, temp_output_172_0_g132, temp_output_182_0_g132 ) * W2171_g132 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV3171_g132,Input_Index184_g132, temp_output_172_0_g132, temp_output_182_0_g132 ) * W3171_g132 ) );
				float4 T4_Normal_Texture1408 = Output_2DArray294_g132;
				float4 lerpResult640 = lerp( lerpResult635 , T4_Normal_Texture1408 , tex2DNode1473.b);
				float4 AllNormal644 = lerpResult640;
				float3 ase_worldTangent = IN.ase_texcoord5.xyz;
				float3 ase_worldNormal = IN.ase_texcoord6.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal411 = AllNormal644.rgb;
				float3 worldNormal411 = float3(dot(tanToWorld0,tanNormal411), dot(tanToWorld1,tanNormal411), dot(tanToWorld2,tanNormal411));
				float dotResult414 = dot( worldNormal411 , SafeNormalize(_MainLightPosition.xyz) );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir140 = ( dotResult414 * ase_lightAtten );
				float smoothstepResult430 = smoothstep( _StepShadow , temp_output_420_0 , normal_LightDir140);
				float2 temp_cast_46 = (_Noise_Tiling).xx;
				float2 texCoord170 = IN.ase_texcoord4.xy * temp_cast_46 + float2( 0,0 );
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
				float4 temp_cast_47 = (step( temp_output_429_0 , -0.23 )).xxxx;
				float4 blendOpSrc1541 = ( ( 1.0 - temp_output_429_0 ) * _EdgeShadowColor );
				float4 blendOpDest1541 = ( temp_output_429_0 * _ShadowColor );
				float4 blendOpSrc1543 = temp_cast_47;
				float4 blendOpDest1543 = ( saturate( max( blendOpSrc1541, blendOpDest1541 ) ));
				float4 lerpBlendMode1543 = lerp(blendOpDest1543,max( blendOpSrc1543, blendOpDest1543 ),temp_output_429_0);
				float4 lerpResult1544 = lerp( float4( 1,1,1,1 ) , ( saturate( lerpBlendMode1543 )) , ( 1.0 - step( temp_output_429_0 , 0.0 ) ));
				float4 Shadows428 = lerpResult1544;
				float4 temp_cast_48 = (1.0).xxxx;
				float4 lerpResult1010 = lerp( Shadows428 , temp_cast_48 , Out_or_InBrume606);
				float4 temp_output_705_0 = ( AllAlbedo622 * lerpResult1010 );
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
				float4 temp_cast_50 = (normal_LightDir140).xxxx;
				float LightDebug608 = _LightDebug;
				float4 lerpResult282 = lerp( lerpResult1565 , temp_cast_50 , LightDebug608);
				float NormalDebug610 = _NormalDebug;
				float4 lerpResult286 = lerp( lerpResult282 , AllNormal644 , NormalDebug610);
				
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
			float4 _T2_ColorCorrection;
			float4 _T4_ColorCorrection;
			float4 _TerrainMaskTexture_ST;
			float4 _FakeLight_Color;
			float4 _ShadowColor;
			float4 _EdgeShadowColor;
			float4 _T3_ColorCorrection;
			float4 _T1_ColorCorrection;
			float2 _ShadowNoisePanner;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_AnimatedGrunge_Tiling;
			float _T4_AnimatedGrunge_Contrast;
			float _T1_AnimatedGrunge_Contrast;
			float _T3_Albedo_Tiling;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T3_PaintGrunge;
			float _T3_PaintGrunge_Multiply;
			float _T3_PaintGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _T3_AnimatedGrunge;
			float _T3_Albedo_ProceduralTiling;
			float _T4_IsGrungeAnimated;
			float _T4_PaintGrunge_Tiling;
			float _T4_AnimatedGrunge;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _WaveFakeLight_Max;
			float _FakeLightArrayLength;
			float _ScreenBasedShadowNoise;
			float _T4_AnimatedGrunge_Multiply;
			float _Noise_Tiling;
			float _StepShadow;
			float _T4_Albedo_ProceduralTiling;
			float _T4_Albedo_Tiling;
			float _T4_PaintGrunge;
			float _T4_PaintGrunge_Multiply;
			float _T3_AnimatedGrunge_Multiply;
			float _T4_PaintGrunge_Contrast;
			float _StepAttenuation;
			float _T3_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _LightDebug;
			float _DebugTextureTiling;
			float _Out_or_InBrume;
			float _GrayscaleDebug;
			float _T1_Albedo_ProceduralTiling;
			float _T1_Albedo_Tiling;
			float _T1_PaintGrunge;
			float _T1_PaintGrunge_Multiply;
			float _T1_PaintGrunge_Tiling;
			float _T1_PaintGrunge_Contrast;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_AnimatedGrunge_ScreenBased;
			float _T1_AnimatedGrunge_Tiling;
			float _DebugVertexPaint;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Contrast;
			float _T2_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _T3_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_Albedo_ProceduralTiling;
			float _T2_Albedo_Tiling;
			float _T2_Albedo_Contrast;
			float _T2_PaintGrunge;
			float _T2_PaintGrunge_Multiply;
			float _T2_PaintGrunge_Tiling;
			float _T2_PaintGrunge_Contrast;
			float _T2_AnimatedGrunge;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_IsGrungeAnimated;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _T2_AnimatedGrunge_Tiling;
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
			float4 _T2_ColorCorrection;
			float4 _T4_ColorCorrection;
			float4 _TerrainMaskTexture_ST;
			float4 _FakeLight_Color;
			float4 _ShadowColor;
			float4 _EdgeShadowColor;
			float4 _T3_ColorCorrection;
			float4 _T1_ColorCorrection;
			float2 _ShadowNoisePanner;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_AnimatedGrunge_Tiling;
			float _T4_AnimatedGrunge_Contrast;
			float _T1_AnimatedGrunge_Contrast;
			float _T3_Albedo_Tiling;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T3_PaintGrunge;
			float _T3_PaintGrunge_Multiply;
			float _T3_PaintGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _T3_AnimatedGrunge;
			float _T3_Albedo_ProceduralTiling;
			float _T4_IsGrungeAnimated;
			float _T4_PaintGrunge_Tiling;
			float _T4_AnimatedGrunge;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _WaveFakeLight_Max;
			float _FakeLightArrayLength;
			float _ScreenBasedShadowNoise;
			float _T4_AnimatedGrunge_Multiply;
			float _Noise_Tiling;
			float _StepShadow;
			float _T4_Albedo_ProceduralTiling;
			float _T4_Albedo_Tiling;
			float _T4_PaintGrunge;
			float _T4_PaintGrunge_Multiply;
			float _T3_AnimatedGrunge_Multiply;
			float _T4_PaintGrunge_Contrast;
			float _StepAttenuation;
			float _T3_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _LightDebug;
			float _DebugTextureTiling;
			float _Out_or_InBrume;
			float _GrayscaleDebug;
			float _T1_Albedo_ProceduralTiling;
			float _T1_Albedo_Tiling;
			float _T1_PaintGrunge;
			float _T1_PaintGrunge_Multiply;
			float _T1_PaintGrunge_Tiling;
			float _T1_PaintGrunge_Contrast;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_IsGrungeAnimated;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_AnimatedGrunge_ScreenBased;
			float _T1_AnimatedGrunge_Tiling;
			float _DebugVertexPaint;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Contrast;
			float _T2_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _T3_AnimatedGrunge_ScreenBased;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_Albedo_ProceduralTiling;
			float _T2_Albedo_Tiling;
			float _T2_Albedo_Contrast;
			float _T2_PaintGrunge;
			float _T2_PaintGrunge_Multiply;
			float _T2_PaintGrunge_Tiling;
			float _T2_PaintGrunge_Contrast;
			float _T2_AnimatedGrunge;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_IsGrungeAnimated;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _T2_AnimatedGrunge_Tiling;
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
1920;0;1920;1019;7186.313;7210.69;5.875498;True;False
Node;AmplifyShaderEditor.CommentaryNode;746;-15559.13,-7072.62;Inherit;False;10769.91;2740.058;TEXTURE 1;6;42;740;749;1475;1476;1477;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;750;-15558.96,-4297.144;Inherit;False;10769.91;2740.058;TEXTURE 2;6;760;753;752;1480;1479;1478;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1014;-15557.25,1271.575;Inherit;False;10769.91;2740.058;TEXTURE 4;6;1029;1019;1018;1486;1485;1484;;0,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1013;-15557.42,-1503.901;Inherit;False;10769.91;2740.058;TEXTURE 3;6;1044;1017;1016;1481;1482;1483;;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1665;-15564.31,4034.822;Inherit;False;10769.91;2740.058;TEXTURE 5;6;1757;1755;1724;1671;1667;1666;;1,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1019;-15476.42,1439.663;Inherit;False;1279.631;1658.024;Texture Arrays 4;2;1027;1025;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1017;-14119.95,-1453.901;Inherit;False;3990.135;2631.681;Paper + Object Texture;7;1187;1108;1107;1039;1037;1032;1028;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1666;-14126.84,4084.822;Inherit;False;3990.135;2631.681;Paper + Object Texture;7;1747;1710;1695;1674;1670;1669;1668;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1667;-15483.48,4202.91;Inherit;False;1279.631;1658.024;Texture Arrays 5;2;1673;1672;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;740;-15478.3,-6904.532;Inherit;False;1279.631;1658.024;Texture Arrays 1;2;27;736;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1016;-15476.59,-1335.813;Inherit;False;1279.631;1658.024;Texture Arrays 3;2;1034;1022;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;753;-14121.49,-4247.144;Inherit;False;3990.135;2631.681;Paper + Object Texture;7;912;911;816;765;764;762;756;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1373;-4659.422,-7051.386;Inherit;False;9212.971;6898.707;OTHER VARIABLES;5;28;1567;699;587;588;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1018;-14119.78,1321.575;Inherit;False;3990.135;2631.681;Paper + Object Texture;7;1122;1065;1064;1030;1026;1024;1023;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;752;-15478.13,-4129.056;Inherit;False;1279.631;1658.024;Texture Arrays 2;2;763;757;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-4609.422,-7001.386;Inherit;False;5639.813;1022.403;Shadow Smooth Edge + Int Shadow;27;1521;420;356;428;431;422;427;426;430;435;425;408;421;432;429;424;416;406;43;1538;1539;1540;1541;1543;1544;1545;1546;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-14121.66,-7022.62;Inherit;False;3990.135;2631.681;Paper + Object Texture;7;202;184;190;718;616;715;730;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;756;-14063.29,-4162.174;Inherit;False;2635.696;674.9272;Animated Grunge;24;919;918;917;910;909;908;907;891;890;885;884;882;854;841;822;821;820;819;1428;1429;1427;1460;1461;1462;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;616;-14063.44,-5605.458;Inherit;False;2537.716;636.7236;Albedo;14;191;709;621;335;1385;1379;252;615;399;617;619;1433;1434;1435;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1034;-15426.28,-1285.813;Inherit;False;1178.062;699.5752;Textures;8;1363;1362;1206;1204;1203;1178;1164;1090;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1567;-524.6166,-1382.324;Inherit;False;1925.334;901.1771;FAKE LIGHTS;16;1559;1551;1562;1561;1560;1558;1557;1556;1555;1554;1553;1552;1550;1549;1548;1547;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1029;-15272.32,3257.659;Inherit;False;863.1523;325.855;Texture4_Final;5;1367;1364;1118;1050;1049;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1022;-15426.59,-564.1155;Inherit;False;1179.63;861.0986;Grunges;15;1371;1369;1241;1215;1205;1194;1193;1192;1190;1182;1180;1179;1163;1136;1091;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;736;-15428.3,-6132.834;Inherit;False;1179.63;861.0986;Grunges;15;733;714;702;268;700;737;701;735;732;734;731;713;712;738;739;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;718;-14063.46,-6937.651;Inherit;False;2635.696;674.9272;Animated Grunge;24;318;224;717;716;403;381;156;146;127;132;130;175;150;163;167;179;158;208;1422;1423;1424;1463;1464;1465;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1669;-14068.62,5501.985;Inherit;False;2619.777;630.8765;Albedo;14;1742;1721;1715;1714;1707;1706;1705;1704;1703;1694;1686;1684;1678;1677;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1668;-14068.64,4169.792;Inherit;False;2635.696;674.9272;Animated Grunge;24;1760;1754;1753;1751;1750;1749;1745;1736;1728;1727;1725;1720;1719;1717;1716;1712;1711;1702;1699;1696;1693;1691;1690;1680;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1025;-15426.42,2211.362;Inherit;False;1179.63;861.0986;Grunges;15;1372;1366;1148;1140;1139;1138;1137;1115;1111;1098;1077;1070;1059;1058;1052;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1024;-14061.6,3407.54;Inherit;False;1313.751;503.8408;FinalPass;2;1121;1120;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1670;-14064.89,4872.556;Inherit;False;2624.655;602.9019;Paint Grunge;13;1744;1741;1735;1726;1723;1718;1713;1701;1692;1689;1688;1683;1681;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;762;-14079.56,-2157.691;Inherit;False;1313.751;503.8408;FinalPass;2;839;806;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1672;-15433.17,4252.911;Inherit;False;1178.062;699.5752;Textures;8;1743;1739;1737;1732;1731;1729;1698;1682;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1673;-15433.48,4974.609;Inherit;False;1179.63;861.0986;Grunges;15;1759;1758;1756;1752;1748;1740;1738;1733;1730;1700;1697;1687;1685;1679;1676;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1674;-14068.66,6170.788;Inherit;False;1313.751;503.8408;FinalPass;2;1761;1734;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1027;-15426.11,1489.664;Inherit;False;1178.062;699.5752;Textures;8;1146;1145;1144;1143;1132;1068;1057;1047;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-15427.99,-6854.532;Inherit;False;1178.062;699.5752;Textures;8;50;172;71;74;177;708;706;133;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1023;-14057.83,2109.309;Inherit;False;2624.655;602.9019;Paint Grunge;13;1388;1133;1056;1062;1213;1166;1135;1076;1171;1063;1454;1455;1456;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;699;-623.0894,-5920.902;Inherit;False;2684.354;2972.583;All Normal by Vertex Color;45;1768;1767;1762;1766;1765;1764;1763;139;1380;1383;1382;1386;1413;1400;1411;635;694;640;1415;1396;1405;1409;1404;690;1416;1408;1410;691;644;1399;632;1398;1414;642;692;1402;1397;1403;693;1412;1406;1473;1769;1771;1770;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;587;-4597.033,-3123.681;Inherit;False;3197.304;1834.579;Texture Set by Vertex Color;30;1;585;586;570;574;581;569;489;573;14;565;495;578;577;11;576;580;622;1472;567;583;571;584;579;1774;1775;1776;1777;1778;1779;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1037;-14061.75,-1368.932;Inherit;False;2635.696;674.9272;Animated Grunge;24;1191;1186;1161;1160;1156;1154;1152;1130;1112;1110;1109;1104;1089;1087;1086;1082;1081;1080;1445;1446;1447;1467;1468;1466;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1671;-15279.38,6020.906;Inherit;False;863.1523;325.855;Texture4_Final;5;1746;1722;1709;1708;1675;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-4602.845,-5904.483;Inherit;False;3145.105;593.8924;Noise;18;159;365;162;386;180;218;363;197;170;128;142;176;359;362;157;168;703;741;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;763;-15428.13,-3357.357;Inherit;False;1179.63;861.0986;Grunges;15;880;879;878;877;875;874;873;867;856;853;852;851;850;849;846;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;749;-15274.2,-5086.536;Inherit;False;863.1523;325.855;Texture1_Final;5;748;274;349;340;607;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1030;-14061.58,1406.545;Inherit;False;2635.696;674.9272;Animated Grunge;24;1173;1162;1159;1158;1157;1155;1150;1141;1129;1097;1078;1075;1069;1067;1066;1061;1060;1046;1451;1452;1453;1469;1470;1471;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1044;-15272.49,482.1825;Inherit;False;863.1523;325.855;Texture3_Final;5;1214;1199;1198;1196;1195;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1032;-14061.73,-36.73938;Inherit;False;2623.941;630.8765;Albedo;14;1124;1390;1377;1128;1126;1113;1092;1094;1185;1085;1084;1439;1440;1441;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;757;-15427.82,-4079.055;Inherit;False;1178.062;699.5752;Textures;8;881;876;866;865;863;858;857;855;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;760;-15274.03,-2311.059;Inherit;False;863.1523;325.855;Texture2_Final;5;872;871;870;869;868;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-4539.759,-6726.153;Inherit;False;1385.351;464.59;Normal Light Dir;7;140;169;413;414;411;358;412;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;588;-4598.669,-5236.005;Inherit;False;1354.753;2082.206;Debug Textures;17;559;488;597;593;477;478;563;595;596;592;590;1783;594;479;1782;1781;598;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;715;-14059.71,-6234.887;Inherit;False;2540.175;589.6089;Paint Grunge;13;377;297;258;710;336;1394;285;253;135;711;1419;1420;1421;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;765;-14059.54,-3459.41;Inherit;False;2624.556;601.4268;Paint Grunge;13;817;916;883;818;1393;913;915;823;921;914;1430;1431;1432;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;604;-1360.032,-5906.679;Inherit;False;671.5669;606.8997;Global Variables;10;566;564;605;423;606;614;608;613;281;610;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;730;-14071.01,-4938.403;Inherit;False;1313.751;503.8408;FinalPass;2;301;187;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-588.2324,-2839.358;Inherit;False;2375.426;1300.643;Final Mix;18;704;2;1512;286;611;698;1497;1010;705;294;280;1012;282;609;1563;1564;1565;1566;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1026;-14061.56,2738.738;Inherit;False;2619.777;630.8765;Albedo;14;1376;1125;1134;1389;1103;1051;1083;1072;1175;1079;1074;1442;1443;1444;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1039;-14061.77,623.7369;Inherit;False;1313.751;503.8408;FinalPass;2;1211;1119;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;764;-14063.27,-2829.981;Inherit;False;2632.267;626.7134;Albedo;16;1392;1378;905;906;825;888;889;886;923;920;903;1436;1437;1438;1459;1458;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1028;-14058,-666.1687;Inherit;False;2622.859;593.3951;Paint Grunge;13;1197;1114;1106;1099;1391;1169;1105;1088;1170;1149;1448;1449;1450;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1139;-14903.73,2482.967;Inherit;True;Property;_TextureSample43;Texture Sample 43;90;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1173;-12701.98,1453.307;Inherit;True;Property;_TextureSample50;Texture Sample 50;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-11269.91,-6050.4;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-13178.4,-4873.495;Inherit;False;T1_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1063;-12450.77,2319.775;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1137;-14525.05,2483.425;Inherit;False;T4_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1465;-13482.6,-6867.532;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1456;-12008.05,2446.345;Inherit;False;Property;_T4_PaintGrunge;T4_PaintGrunge?;85;0;Create;True;0;0;False;1;Header(T4 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1140;-15117.29,2282.417;Inherit;False;TA_4_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-14019.36,-6680.327;Inherit;False;Property;_T1_AnimatedGrunge_Tiling;T1_AnimatedGrunge_Tiling;35;0;Create;True;0;0;False;0;False;1;32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1145;-15378.94,1564.851;Inherit;True;Property;_TA_4_Textures;TA_4_Textures;78;0;Create;True;0;0;False;1;Header(Texture 4 VertexPaintBlue);False;ef1e633c4c2c51641bd59a932b55b28a;367e4a1a884fceb4495dc92c9be487dd;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TFHCGrayscale;1051;-11914.33,2911;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1543;-268.0488,-6830.268;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1486;-9674.87,2247.757;Inherit;False;1120;T4_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1442;-13393.76,3120.571;Inherit;True;Property;_TextureSample30;Texture Sample 30;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;167;-13792.36,-6862.327;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1213;-14012.91,2181.306;Inherit;True;1140;TA_4_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1159;-13684.53,1744.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Columns;T4_AnimatedGrunge_Flipbook_Columns;95;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1129;-13306.52,1723.141;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;1141;-13543.53,1991.621;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;709;-13986.85,-5554.082;Inherit;True;708;TA_1_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;711;-13968.78,-5965.854;Inherit;False;Constant;_Float19;Float 19;62;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1058;-15307.39,2766.983;Inherit;False;Constant;_Float13;Float 13;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;252;-11980.43,-5445.562;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1134;-12499.16,2945.502;Inherit;False;Property;_T4_ColorCorrection;T4_ColorCorrection;80;0;Create;True;0;0;False;0;False;1,1,1,0;1,0.9103774,0.9103774,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1046;-13639.48,1482.869;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1079;-12209.16,2811.503;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1158;-13683.53,1818.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Rows;T4_AnimatedGrunge_Flipbook_Rows;96;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1062;-13695.29,2181.06;Inherit;True;Procedural Sample;-1;;129;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;1364;-14628.17,3311.659;Inherit;False;Texture4_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1148;-14901.36,2867.688;Inherit;True;Property;_TextureSample49;Texture Sample 49;100;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1083;-13749.87,2875.038;Inherit;False;Constant;_Float30;Float 30;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-13686.41,-6599.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Columns;T1_AnimatedGrunge_Flipbook_Columns;36;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1166;-13965.83,2613.188;Inherit;False;Property;_T4_PaintGrunge_Tiling;T4_PaintGrunge_Tiling;87;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1076;-13034.87,2188.287;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;381;-12703.86,-6890.889;Inherit;True;Property;_TextureSample67;Texture Sample 67;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1125;-13377.28,2790.281;Inherit;True;Procedural Sample;-1;;125;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;1118;-15217.32,3312.465;Inherit;False;1120;T4_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1376;-13811,3017.032;Inherit;False;T4_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1133;-13966.9,2378.342;Inherit;False;Constant;_Float35;Float 35;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1098;-15356.4,2281.271;Inherit;True;Property;_TA_4_Grunges;TA_4_Grunges;79;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;8f4c22a1083f0e64f8a4c34b3cc88618;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1066;-11896.64,1459.206;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1069;-12983.21,1482.422;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-13685.41,-6525.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Rows;T1_AnimatedGrunge_Flipbook_Rows;37;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;399;-12565.26,-5411.059;Inherit;False;Property;_T1_ColorCorrection;T1_ColorCorrection;25;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1065;-11268.03,2293.795;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1050;-14942.74,3316.909;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1476;-9440.299,-6807.266;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1122;-10584.35,2775.733;Inherit;False;T4_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1453;-11633.5,1867.005;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1171;-13349.85,2350.068;Inherit;False;Property;_T4_PaintGrunge_Contrast;T4_PaintGrunge_Contrast;88;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1157;-13682.53,1893.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Speed;T4_AnimatedGrunge_Flipbook_Speed;97;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1075;-12875,1612.47;Inherit;False;Constant;_Float28;Float 28;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1059;-15306.39,2841.539;Inherit;False;Constant;_Float14;Float 14;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1691;-13646.54,4246.116;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1175;-13984.97,2790.114;Inherit;True;1146;TA_4_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1389;-13608.91,2974.47;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1444;-12790.47,2793.938;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;1060;-13790.48,1481.869;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1074;-11640.42,2813.314;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1155;-12468.57,1709.016;Inherit;False;Property;_T4_AnimatedGrunge_Contrast;T4_AnimatedGrunge_Contrast;98;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1068;-15342.13,1910.988;Inherit;False;Constant;_Float15;Float 15;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1135;-12801.78,2436.467;Inherit;False;Property;_T4_PaintGrunge_Multiply;T4_PaintGrunge_Multiply;89;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1443;-13089.75,2909.883;Inherit;False;Property;_T4_Albedo_ProceduralTiling;T4_Albedo_ProceduralTiling?;82;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;712;-14905.61,-5861.229;Inherit;True;Property;_TextureSample36;Texture Sample 36;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1422;-11942.54,-6413.93;Inherit;False;Property;_T1_AnimatedGrunge;T1_AnimatedGrunge?;32;0;Create;True;0;0;False;1;Header(T1 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1471;-13505.5,1485.138;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;731;-14904.77,-5669.23;Inherit;True;Property;_TextureSample37;Texture Sample 37;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1385;-13621.2,-5371.96;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1367;-15207.94,3392.865;Inherit;False;1485;T4_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1455;-11672.88,2326.522;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;621;-14039.19,-5328.548;Inherit;False;Property;_T1_Albedo_Tiling;T1_Albedo_Tiling;27;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1366;-14554.52,2866.77;Inherit;False;T4_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1072;-14003.31,3016.647;Inherit;False;Property;_T4_Albedo_Tiling;T4_Albedo_Tiling;83;0;Create;True;0;0;False;0;False;1;26.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1470;-13715.34,1602.895;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;285;-13036.75,-6155.909;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-15343.01,-6356.208;Inherit;False;Constant;_Float63;Float 63;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;606;-975.6267,-5823.472;Inherit;False;Out_or_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;734;-14903.24,-5476.507;Inherit;True;Property;_TextureSample38;Texture Sample 38;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1423;-11603.37,-6487.755;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;739;-15350.36,-5831.829;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-13633.36,-6871.327;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;706;-15407.82,-6778.345;Inherit;True;Property;_TA_1_Textures;TA_1_Textures;23;0;Create;True;0;0;False;1;Header(Texture 1 VertexPaintBlack);False;ef1e633c4c2c51641bd59a932b55b28a;03400b2757c6d6d459169340ceb111c8;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-11868.52,-6884.99;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-15373.39,-6573.204;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;282;879.0575,-2755.956;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-15344.01,-6433.208;Inherit;False;Constant;_Float53;Float 53;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;995.4545,-2603.448;Inherit;False;644;AllNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-14522.14,-6773.444;Inherit;False;T1_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1420;-11689.31,-6049.232;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-10586.23,-5568.462;Inherit;False;T1_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;617;-13379.16,-5553.915;Inherit;True;Procedural Sample;-1;;122;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;179;-13308.4,-6621.055;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;737;-15405.28,-6061.924;Inherit;True;Property;_TA_1_Grunges;TA_1_Grunges;24;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;b33b36e28008b23459206c358b00d02a;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;177;-14919.35,-6583.95;Inherit;True;Property;_TextureSample57;Texture Sample 57;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-12452.65,-6024.42;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1379;-13856.48,-5328.852;Inherit;False;T1_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;377;-13351.73,-5994.128;Inherit;False;Property;_T1_PaintGrunge_Contrast;T1_PaintGrunge_Contrast;30;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;297;-12803.66,-5907.729;Inherit;False;Property;_T1_PaintGrunge_Multiply;T1_PaintGrunge_Multiply;31;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1553;-464.1664,-806.3687;Inherit;False;Property;_WaveFakeLight_Time;WaveFakeLight_Time;122;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1010;-248.4355,-2632.969;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;611;1047.198,-2519.761;Inherit;False;610;NormalDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1394;-13732.33,-5793.535;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;708;-15136.4,-6778.054;Inherit;False;TA_1_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-15219.2,-5031.73;Inherit;False;187;T1_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1463;-13713.44,-6745.775;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;336;-13697.17,-6163.136;Inherit;True;Procedural Sample;-1;;126;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.LerpOp;1434;-12778.16,-5571.525;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;591.3594,-2564.97;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1566;207.2242,-2368.579;Inherit;False;1547;FakeLights;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1012;-502.8144,-2463.103;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;286;1277.072,-2753.99;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;615;-11981.89,-5360.529;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;716;-12139.45,-6885.18;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;258;-13967.71,-5731.008;Inherit;False;Property;_T1_PaintGrunge_Tiling;T1_PaintGrunge_Tiling;29;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;318;-12154.52,-6639.99;Inherit;False;Property;_T1_AnimatedGrunge_Multiply;T1_AnimatedGrunge_Multiply;40;0;Create;True;0;0;False;0;False;1.58;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;158;-12985.09,-6861.774;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1435;-13077.44,-5455.58;Inherit;False;Property;_T1_Albedo_ProceduralTiling;T1_Albedo_ProceduralTiling?;26;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1419;-12024.48,-5929.408;Inherit;False;Property;_T1_PaintGrunge;T1_PaintGrunge?;28;0;Create;True;0;0;False;1;Header(T1 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;701;-14533.66,-6059.29;Inherit;False;T1_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;700;-14907.66,-6060.29;Inherit;True;Property;_TA_1_Grunges_Sample;TA_1_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;748;-14630.05,-5032.536;Inherit;False;Texture1_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1464;-14018.6,-6591.532;Inherit;False;Property;_T1_AnimatedGrunge_ScreenBased;T1_AnimatedGrunge_ScreenBased?;34;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;135;-12228.6,-6024.229;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;156;-12876.88,-6731.726;Inherit;False;Constant;_Float62;Float 62;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;403;-12370.8,-6889.003;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;607;-15211.73,-4872.681;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1421;-11863.13,-6128.481;Inherit;False;Constant;_Float34;Float 34;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;-15209.82,-4951.33;Inherit;False;1477;T1_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;713;-14526.93,-5861.771;Inherit;False;T1_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;340;-14944.62,-5027.286;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-13751.75,-5469.158;Inherit;False;Constant;_Float4;Float 4;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;738;-15119.17,-6061.779;Inherit;False;TA_1_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;74;-14917.79,-6777.057;Inherit;True;Property;_TA_1_Textures_Sample;TA_1_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;ef1e633c4c2c51641bd59a932b55b28a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1477;-9211.426,-6809.632;Inherit;False;T1_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;714;-15308.27,-5502.657;Inherit;False;Constant;_Float20;Float 20;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1433;-13381.45,-5244.892;Inherit;True;Property;_TextureSample27;Texture Sample 27;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;163;-14016.36,-6862.327;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;733;-15306.16,-5426.742;Inherit;False;Constant;_Float21;Float 21;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;710;-14014.79,-6162.889;Inherit;True;738;TA_1_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-12275.26,-5545.058;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1424;-11799.15,-6522.873;Inherit;False;Constant;_Float46;Float 46;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-13684.41,-6450.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Speed;T1_AnimatedGrunge_Flipbook_Speed;38;0;Create;True;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;735;-14556.4,-5477.425;Inherit;False;T1_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1067;-14020.48,1657.869;Inherit;False;Property;_T4_AnimatedGrunge_Tiling;T4_AnimatedGrunge_Tiling;94;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-14024.15,-4875.206;Inherit;True;202;T1_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;191;-11706.52,-5543.248;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;732;-14560.41,-5669.246;Inherit;False;T1_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;702;-15309.27,-5577.212;Inherit;False;Constant;_Float18;Float 18;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;268;-15308.23,-5654.782;Inherit;False;Constant;_Float71;Float 71;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;190;-10903.79,-5569.318;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;717;-12455.45,-6645.18;Inherit;False;Property;_T1_AnimatedGrunge_Contrast;T1_AnimatedGrunge_Contrast;39;0;Create;True;0;0;False;0;False;1.58;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;208;-13545.41,-6352.575;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1475;-9673.299,-6807.266;Inherit;False;187;T1_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-13324.26,-6787.949;Inherit;False;Property;_T1_IsGrungeAnimated;T1_IsGrungeAnimated?;33;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1070;-15304.28,2917.454;Inherit;False;Constant;_Float16;Float 16;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1052;-15348.48,2512.366;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1047;-15341.13,1987.988;Inherit;False;Constant;_Float11;Float 11;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1103;-11915.79,2996.033;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1759;-14538.84,5048.153;Inherit;False;T5_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1695;-10591.41,5538.98;Inherit;False;T5_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;580;-3280.026,-2191.229;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1694;-13992.03,5553.361;Inherit;True;1739;TA_5_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1709;-15224.38,6075.712;Inherit;False;1761;T5_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1681;-13972.89,5376.435;Inherit;False;Property;_T5_PaintGrunge_Tiling;T5_PaintGrunge_Tiling;106;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1688;-14019.97,4944.553;Inherit;True;1685;TA_5_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1745;-12193.7,4474.454;Inherit;False;Property;_T5_AnimatedGrunge_Multiply;T5_AnimatedGrunge_Multiply;117;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1685;-15124.35,5045.665;Inherit;False;TA_5_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1734;-14021.8,6233.984;Inherit;True;1695;T5_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;581;-3524.214,-2099.01;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1724;-9681.93,5011.004;Inherit;False;1761;T5_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1675;-14635.23,6074.906;Inherit;False;Texture5_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;1771;515.2265,-3387.403;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1764;990.8867,-5747.731;Inherit;False;Constant;_Float64;Float 64;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1677;-11921.39,5674.248;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1678;-12506.22,5708.75;Inherit;False;Property;_T5_ColorCorrection;T5_ColorCorrection;102;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1707;-13096.81,5673.13;Inherit;False;Property;_T5_Albedo_ProceduralTiling;T5_Albedo_ProceduralTiling?;103;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1686;-13400.82,5883.818;Inherit;True;Property;_TextureSample32;Texture Sample 32;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1733;-14565.59,5438.196;Inherit;False;T5_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1754;-13329.44,4323.862;Inherit;False;Property;_T5_IsGrungeAnimated;T5_IsGrungeAnimated?;110;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1679;-14532.11,5246.672;Inherit;False;T5_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1687;-14910.79,5247.214;Inherit;True;Property;_TextureSample45;Texture Sample 45;81;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1756;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1756;-14912.84,5047.153;Inherit;True;Property;_TA_5_Grunges_Sample;TA_5_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1752;-14909.95,5438.213;Inherit;True;Property;_TextureSample46;Texture Sample 46;84;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1756;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1676;-14908.42,5630.935;Inherit;True;Property;_TextureSample54;Texture Sample 54;93;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1756;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1766;755.7866,-5832.654;Inherit;True;1739;TA_5_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;583;-3527.254,-2248.646;Inherit;False;1364;Texture4_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1690;-12709.04,4216.554;Inherit;True;Property;_TextureSample55;Texture Sample 55;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1756;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1701;-12808.84,5199.714;Inherit;False;Property;_T5_PaintGrunge_Multiply;T5_PaintGrunge_Multiply;108;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1699;-12475.63,4472.263;Inherit;False;Property;_T5_AnimatedGrunge_Contrast;T5_AnimatedGrunge_Contrast;116;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1727;-14027.54,4421.116;Inherit;False;Property;_T5_AnimatedGrunge_Tiling;T5_AnimatedGrunge_Tiling;112;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1715;-14010.37,5779.894;Inherit;False;Property;_T5_Albedo_Tiling;T5_Albedo_Tiling;104;0;Create;True;0;0;False;0;False;1;26.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1755;-9222.057,5009.639;Inherit;False;T5_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1705;-13818.06,5780.279;Inherit;False;T5_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1150;-13322.38,1560.615;Inherit;False;Property;_T4_IsGrungeAnimated;T4_IsGrungeAnimated?;91;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1762;838.9164,-5608.88;Inherit;False;1705;T5_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1767;1646.815,-5832.282;Inherit;False;T5_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;692;13.11786,-3790.681;Inherit;True;1408;T4_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;586;-3263.567,-2017.135;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;584;-3527.231,-2172.859;Inherit;False;479;DebugColor4;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;594;-3950.372,-4350.56;Inherit;True;Property;_TextureSample26;Texture Sample 26;7;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1697;-15363.46,5044.518;Inherit;True;Property;_TA_5_Grunges;TA_5_Grunges;101;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;None;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;644;844.4186,-3577.901;Inherit;False;AllNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1768;145.4968,-3411.649;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1413;-341.7355,-5598.232;Inherit;False;1379;T1_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;479;-3544.354,-4372.308;Inherit;True;DebugColor4;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1386;-95.34624,-5623.687;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1718;-12015.11,5209.592;Inherit;False;Property;_T5_PaintGrunge;T5_PaintGrunge?;105;0;Create;True;0;0;False;1;Header(T5 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;577;-4015.617,-2359.943;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1775;-3079.573,-1738.017;Inherit;False;1783;DebugColor5;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1472;-4535.297,-2149.43;Inherit;True;Property;_TerrainMaskTexture;TerrainMaskTexture;1;0;Create;True;0;0;False;1;Header(TerrainMask);False;-1;None;4a63dddb07f87d541b02f7ca4ed57c92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;11;-4064.618,-2757.986;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;-3572.75,-2474.977;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;495;-3033.252,-2215.051;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1783;-3537.589,-4131.195;Inherit;True;DebugColor5;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1720;-13689.59,4656.868;Inherit;False;Property;_T5_AnimatedGrunge_Flipbook_Speed;T5_AnimatedGrunge_Flipbook_Speed;115;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1782;-3947.601,-4131.076;Inherit;True;Property;_TextureSample34;Texture Sample 34;6;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1781;-4209.601,-4487.076;Inherit;False;Constant;_Float65;Float 65;69;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;466.1629,-5821.634;Inherit;False;T1_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;640;285.7617,-3802.554;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1777;-2832.367,-1756.387;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1382;-189.7652,-5737.083;Inherit;False;Constant;_Float5;Float 5;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1057;-15371.51,1770.992;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1743;-14924.53,4523.493;Inherit;True;Property;_TextureSample56;Texture Sample 56;86;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1737;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1731;-14527.32,4334;Inherit;False;T5_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1383;182.8246,-5821.839;Inherit;True;Procedural Sample;-1;;133;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1469;-14031.5,1768.138;Inherit;False;Property;_T4_AnimatedGrunge_ScreenBased;T4_AnimatedGrunge_ScreenBased?;92;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1770;577.5483,-3573.34;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1380;-424.8652,-5822.006;Inherit;True;708;TA_1_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1769;304.9045,-3561.467;Inherit;True;1767;T5_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1763;1085.306,-5634.335;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1779;-3076.555,-1664.168;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1776;-3079.595,-1813.804;Inherit;False;1675;Texture5_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;598;-4208.631,-4569.591;Inherit;False;Constant;_Float3;Float 3;69;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1138;-14902.89,2674.966;Inherit;True;Property;_TextureSample42;Texture Sample 42;92;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1711;-13690.59,4581.868;Inherit;False;Property;_T5_AnimatedGrunge_Flipbook_Rows;T5_AnimatedGrunge_Flipbook_Rows;114;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1693;-13691.59,4507.868;Inherit;False;Property;_T5_AnimatedGrunge_Flipbook_Columns;T5_AnimatedGrunge_Flipbook_Columns;113;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1761;-13107.61,6237.577;Inherit;False;T5_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1740;-15355.54,5275.613;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1684;-12216.22,5574.75;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1097;-12380.92,1454.193;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;609;614.7824,-2452.512;Inherit;False;608;LightDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1077;-15306.35,2689.414;Inherit;False;Constant;_Float29;Float 29;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1064;-10901.91,2774.877;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1132;-14520.26,1570.752;Inherit;False;T4_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1683;-13041.93,4951.535;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1559;138.5236,-1224.123;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1689;-12457.83,5083.022;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1741;-11853.76,5010.52;Inherit;False;Constant;_Float58;Float 58;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1512;-443.1264,-2535.106;Inherit;False;Constant;_Float47;Float 47;109;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1146;-15134.52,1566.142;Inherit;False;TA_4_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1452;-11972.67,1940.83;Inherit;False;Property;_T4_AnimatedGrunge;T4_AnimatedGrunge?;90;0;Create;True;0;0;False;1;Header(T4 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1744;-12233.78,5083.214;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1717;-11903.7,4222.454;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1372;-14558.53,2674.949;Inherit;False;T4_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1719;-13512.56,4248.385;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1680;-13313.58,4486.388;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1451;-11829.28,1831.887;Inherit;False;Constant;_Float44;Float 44;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1144;-14917.47,1760.246;Inherit;True;Property;_TextureSample47;Texture Sample 47;94;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1143;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;1056;-12226.72,2319.967;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1162;-12186.64,1711.206;Inherit;False;Property;_T4_AnimatedGrunge_Multiply;T4_AnimatedGrunge_Multiply;99;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1121;-14014.74,3470.737;Inherit;True;1122;T4_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1049;-15209.85,3471.514;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1692;-11679.94,5089.769;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1696;-12990.27,4245.669;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1120;-13100.55,3474.329;Inherit;False;T4_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1698;-15349.19,4674.235;Inherit;False;Constant;_Float41;Float 41;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1738;-15311.34,5680.702;Inherit;False;Constant;_Float57;Float 57;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1143;-14915.91,1567.139;Inherit;True;Property;_TA_4_Textures_Sample;TA_4_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1388;-13726.67,2538.164;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1726;-13356.91,5113.315;Inherit;False;Property;_T5_PaintGrunge_Contrast;T5_PaintGrunge_Contrast;107;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1742;-11922.85,5759.28;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1061;-14014.48,1481.869;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1111;-14531.78,2284.906;Inherit;False;T4_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1736;-12387.98,4217.44;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1454;-11846.7,2247.273;Inherit;False;Constant;_Float45;Float 45;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1721;-12797.53,5557.185;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1723;-13973.96,5141.589;Inherit;False;Constant;_Float51;Float 51;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1758;-15314.45,5530.23;Inherit;False;Constant;_Float60;Float 60;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1710;-11275.09,5057.042;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1730;-15313.45,5604.787;Inherit;False;Constant;_Float56;Float 56;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1760;-11836.34,4595.134;Inherit;False;Constant;_Float61;Float 61;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1748;-15313.41,5452.662;Inherit;False;Constant;_Float59;Float 59;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1753;-11979.73,4704.077;Inherit;False;Property;_T5_AnimatedGrunge;T5_AnimatedGrunge?;109;0;Create;True;0;0;False;1;Header(T5 Animated Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1702;-13550.59,4754.868;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1757;-9450.93,5012.004;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1703;-13384.34,5553.528;Inherit;True;Procedural Sample;-1;;136;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;1739;-15141.58,4329.389;Inherit;False;TA_5_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1485;-9214.997,2246.392;Inherit;False;T4_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1735;-13733.73,5301.412;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1700;-14561.58,5630.017;Inherit;False;T5_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1484;-9443.87,2248.757;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1765;1363.476,-5832.487;Inherit;True;Procedural Sample;-1;;138;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;1708;-15215,6156.112;Inherit;False;1755;T5_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1704;-13615.97,5737.717;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1722;-14949.8,6080.156;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1750;-12169.63,4222.263;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1747;-10908.97,5538.125;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1713;-13702.35,4944.307;Inherit;True;Procedural Sample;-1;;137;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.LerpOp;1725;-11640.56,4630.252;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;1712;-13797.54,4245.116;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1706;-11647.48,5576.561;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;821;-13630.19,-4082.85;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1554;128.2658,-1079.748;Inherit;False;Property;_FakeLightArrayLength;FakeLightArrayLength;118;0;Create;False;0;0;False;1;Header(Fake Lights);False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1415;-353.237,-4907.696;Inherit;False;1377;T3_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1749;-14021.54,4245.116;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;574;-4539.622,-2790.681;Inherit;False;868;Texture2_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1728;-12882.06,4375.717;Inherit;False;Constant;_Float54;Float 54;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1115;-14905.78,2283.906;Inherit;True;Property;_TA_4_Grunges_Sample;TA_4_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1716;-13722.4,4366.142;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;1078;-12162.57,1459.016;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1746;-15216.91,6234.761;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1737;-14922.97,4330.386;Inherit;True;Property;_TA_5_Textures_Sample;TA_5_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1714;-13756.93,5638.286;Inherit;False;Constant;_Float48;Float 48;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;423;-1278.309,-5725.769;Inherit;False;Property;_LightDebug;LightDebug;2;0;Create;True;0;0;False;1;Header(Debug);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1563;-49.03904,-2455.375;Inherit;False;Property;_FakeLight_Color;FakeLight_Color;119;0;Create;False;0;0;False;0;False;1,1,1,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;1104;-14014.65,-1293.608;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;705;3.363792,-2758.376;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-1271.828,-5622.753;Inherit;False;Property;_NormalDebug;NormalDebug;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;-3213.352,-5654.817;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-3517.352,-5510.816;Inherit;False;Property;_ScreenBasedShadowNoise;ScreenBasedShadowNoise?;11;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1404;-98.26397,-4930.666;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;1538;-1064.22,-6657.07;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1411;-190.7174,-4702.136;Inherit;False;Constant;_Float25;Float 25;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;435;-2195.47,-6393.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;489;-4547.033,-2998.54;Inherit;False;488;DebugColor1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;-566.9257,-4239.124;Inherit;True;1396;T2_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;741;-4512.905,-5586.063;Inherit;True;Property;_InBrumeDrippingNoise;InBrumeDrippingNoise;22;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;218;-2307.742,-5806.355;Inherit;True;Property;_TextureSample60;Texture Sample 60;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;703;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1396;464.8768,-5476.811;Inherit;False;T2_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;635;-1.915349,-4021.934;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GlobalArrayNode;1551;112.2761,-1329.712;Inherit;False;FakeLightsPositionsArray;0;10;2;False;False;0;1;False;Object;13;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;876;-15373.22,-3797.727;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;590;-4554.859,-4981.286;Inherit;False;Property;_DebugTextureTiling;DebugTextureTiling;9;0;Create;True;0;0;False;0;False;10;9.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;570;-4539.598,-2714.893;Inherit;False;477;DebugColor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;412;-4233.749,-6494.964;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WireNode;694;219.225,-3604.952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;596;-4209.631,-4731.591;Inherit;False;Constant;_Float1;Float 1;69;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;573;-4546.622,-3073.681;Inherit;False;748;Texture1_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;406;-1987.471,-6425.385;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;432;-1347.18,-6342.185;Inherit;False;Property;_ShadowColor;ShadowColor;15;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.8396226,0.8396226,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;592;-3952.372,-4804.56;Inherit;True;Property;_TextureSample24;Texture Sample 24;7;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1405;-192.6832,-5044.062;Inherit;False;Constant;_Float17;Float 17;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;585;-3645.567,-2327.136;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1461;-13486.91,-4082.185;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1400;-426.1516,-5477.184;Inherit;True;881;TA_2_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1195;-15210.02,696.0374;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;863;-14521.97,-3997.967;Inherit;False;T2_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;425;-3106.479,-6399.385;Inherit;False;Property;_StepShadow;StepShadow;13;0;Create;True;0;0;False;0;False;0.1;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;564;-1279.365,-5420.153;Inherit;False;Property;_DebugVertexPaint;DebugVertexPaint;5;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1416;-351.237,-4569.696;Inherit;False;1377;T3_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1502;2733.274,-6623.55;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;908;-12156.28,-4110.703;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1113;-11914.5,135.5223;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;849;-14556.23,-2701.948;Inherit;False;T2_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;819;-12474.28,-3893.703;Inherit;False;Property;_T2_AnimatedGrunge_Contrast;T2_AnimatedGrunge_Contrast;58;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;870;-15209.65,-2175.853;Inherit;False;1480;T2_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;891;-12984.92,-4086.297;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1170;-12801.95,-339.0104;Inherit;False;Property;_T3_PaintGrunge_Multiply;T3_PaintGrunge_Multiply;68;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;605;-1275.699,-5824.597;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;0;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1206;-15341.3,-787.4894;Inherit;False;Constant;_Float40;Float 40;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1541;-668.1101,-6450.717;Inherit;False;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;363;-2308.742,-5540.354;Inherit;True;Property;_TextureSample66;Texture Sample 66;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;703;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1185;-13985.14,14.63659;Inherit;True;1090;TA_3_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1440;-13078.34,125.3606;Inherit;False;Property;_T3_Albedo_ProceduralTiling;T3_Albedo_ProceduralTiling?;63;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1136;-15307.56,-8.493289;Inherit;False;Constant;_Float36;Float 36;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;703;-4514.157,-5790.851;Inherit;True;Property;_ShadowNoise;ShadowNoise;10;0;Create;True;0;0;False;1;Header(Shadow and Noise);False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;a61778d50b6394348b9f8089e2c6e1fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;169;-4491.268,-6644.676;Inherit;True;644;AllNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;856;-14533.49,-3283.813;Inherit;False;T2_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-1684.501,-5565.482;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;918;-13792.19,-4086.85;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;176;-4141.909,-5584.326;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1497;-486.2734,-2607.542;Inherit;False;1496;IB_Shadows;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;614;-963.4258,-5518.905;Inherit;False;GrayscaleDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1409;181.8724,-4786.893;Inherit;True;Procedural Sample;-1;;132;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1449;-11998.13,-322.4233;Inherit;False;Property;_T3_PaintGrunge;T3_PaintGrunge?;65;0;Create;True;0;0;False;1;Header(T3 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;853;-14526.76,-3086.294;Inherit;False;T2_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;855;-15342.84,-3580.731;Inherit;False;Constant;_Float49;Float 49;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1369;-14554.69,91.29375;Inherit;False;T3_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;879;-15309.1,-2801.735;Inherit;False;Constant;_Float24;Float 24;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1467;-14039.83,-1024.348;Inherit;False;Property;_T3_AnimatedGrunge_ScreenBased;T3_AnimatedGrunge_ScreenBased?;71;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;871;-14944.45,-2251.809;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;921;-13968.61,-3190.377;Inherit;False;Constant;_Float27;Float 27;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;565;-4299.832,-3016.911;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1109;-11900.81,-1310.272;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;408;-1683.48,-6937.386;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;642;-568.3788,-4433.155;Inherit;True;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;421;-2403.47,-6345.385;Inherit;False;Constant;_Float77;Float 77;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;820;-14014.19,-3908.85;Inherit;False;Property;_T2_AnimatedGrunge_Tiling;T2_AnimatedGrunge_Tiling;54;0;Create;True;0;0;False;0;False;1;32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;868;-14629.88,-2257.059;Inherit;False;Texture2_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;905;-11916.04,-2657.719;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;846;-14905.44,-3085.752;Inherit;True;Property;_TextureSample39;Texture Sample 39;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;569;-4292.396,-2733.264;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;386;-2510.501,-5776.482;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;424;-1907.472,-6937.386;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;613;-1270.865,-5517.98;Inherit;False;Property;_GrayscaleDebug;GrayscaleDebug;4;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-3676.511,-5798.626;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1499;1973.064,-6654.549;Inherit;False;Property;_IB_StepShadow;IB_StepShadow;18;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;428;516.3201,-6445.036;Inherit;False;Shadows;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;420;-2547.47,-6697.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1414;-345.9882,-5255.924;Inherit;False;1378;T2_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1406;-427.7834,-5128.986;Inherit;True;1090;TA_3_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;595;-4211.925,-4812.445;Inherit;False;Constant;_Float0;Float 0;69;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;691;-266.0599,-4004.133;Inherit;True;1402;T3_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1496;3827.23,-6751.163;Inherit;False;IB_Shadows;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;571;-4536.583,-2641.045;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;359;-2942.513,-5520.482;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;566;-971.4554,-5421.064;Inherit;False;DebugVertexPaint;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1473;-584.6416,-3704.566;Inherit;True;Property;_TextureSample31;Texture Sample 31;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1472;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1544;266.0214,-6600.105;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1500;1948.064,-6570.549;Inherit;False;Property;_IB_StepAttenuation;IB_StepAttenuation;19;0;Create;True;0;0;False;0;False;0.1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1539;-1341.03,-6543.738;Inherit;False;Property;_EdgeShadowColor;EdgeShadowColor;16;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1732;-15348.19,4751.235;Inherit;False;Constant;_Float12;Float 12;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1402;463.2452,-5128.613;Inherit;False;T3_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-2942.513,-5744.482;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;431;-797.2797,-6946.284;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1521;-1041.523,-6419.875;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;478;-3541.9,-4615.076;Inherit;True;DebugColor3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1511;3355.173,-6833.966;Inherit;False;Constant;_Float6;Float 6;109;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1412;-425.8178,-4787.06;Inherit;True;1146;TA_4_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.ColorNode;1503;2521.275,-6469.55;Inherit;False;Property;_IB_ShadowColor;IB_ShadowColor;20;0;Create;True;0;0;False;0;False;0,0,0,0;0.3301885,0.3301885,0.3301885,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;579;-4018.657,-2509.578;Inherit;False;1214;Texture3_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;608;-967.5857,-5724.967;Inherit;False;LightDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1403;179.9068,-5128.819;Inherit;True;Procedural Sample;-1;;123;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1540;-856.0298,-6565.738;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1397;181.5387,-5477.017;Inherit;True;Procedural Sample;-1;;124;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;426;-2131.47,-6761.385;Inherit;False;197;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;693;-56.77522,-3827.952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1545;-151.1787,-6463.905;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;358;-3945.75,-6366.965;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;422;-2739.47,-6681.385;Inherit;False;Property;_StepAttenuation;StepAttenuation;14;0;Create;True;0;0;False;0;False;-0.07;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;563;-4321.25,-5000.2;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-3385.751,-6654.963;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1546;98.22156,-6463.705;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;915;-14018.54,-2963.531;Inherit;False;Property;_T2_PaintGrunge_Tiling;T2_PaintGrunge_Tiling;48;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;477;-3541.403,-4852.273;Inherit;True;DebugColor2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1398;-96.63238,-5278.863;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1410;-96.29839,-4588.74;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1408;465.2108,-4786.687;Inherit;False;T4_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;429;-1404.374,-6783.921;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;593;-3949.372,-4572.56;Inherit;True;Property;_TextureSample25;Texture Sample 25;7;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;430;-2387.47,-6937.386;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;411;-4217.748,-6638.963;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;414;-3961.749,-6638.963;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-3740.31,-5580.228;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;576;-3771.429,-2452.161;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;362;-2782.502,-5776.482;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;1510;3543.173,-6773.966;Inherit;False;Property;_IB_Shadow;IB_Shadow?;17;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1508;2963.216,-6744.054;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;597;-4208.631,-4650.591;Inherit;False;Constant;_Float2;Float 2;69;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;416;-2227.47,-6505.385;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;162;-3935.91,-5584.326;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1128;-11915.96,220.5555;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;365;-1972.501,-5564.482;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;427;-2195.47,-6297.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;610;-966.8767,-5622.498;Inherit;False;NormalDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1498;2349.064,-6743.549;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;356;-2659.47,-6937.386;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;632;-282.3738,-4232.458;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1399;-191.0514,-5392.259;Inherit;False;Constant;_Float8;Float 8;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-3926.91,-5717.327;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;21;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;159;-3252.154,-5829.296;Inherit;False;Property;_ShadowNoisePanner;ShadowNoisePanner;12;0;Create;True;0;0;False;0;False;0.01,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;578;-4018.633,-2433.79;Inherit;False;478;DebugColor3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;567;-4544.019,-2924.692;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;488;-3544.653,-5094.258;Inherit;True;DebugColor1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;559;-3954.713,-5027.561;Inherit;True;Property;_DebugTextureArray;DebugTextureArray;7;0;Create;True;0;0;False;0;False;-1;fcf4482ca7d817c42b6d03968194b044;fcf4482ca7d817c42b6d03968194b044;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;909;-11873.35,-4109.513;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;852;-14904.6,-2893.753;Inherit;True;Property;_TextureSample41;Texture Sample 41;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;907;-12384.63,-4116.526;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;825;-13986.68,-2778.605;Inherit;True;881;TA_2_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1493;2104.301,-6747.799;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1501;2191.064,-6610.549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1509;2548.216,-6623.054;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;910;-12160.35,-3886.513;Inherit;False;Property;_T2_AnimatedGrunge_Multiply;T2_AnimatedGrunge_Multiply;59;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1391;-13737.9,-235.402;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1112;-12377.09,-1316.284;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1082;-13543.7,-783.8566;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1186;-13629.65,-1288.608;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1445;-11962.75,-827.9385;Inherit;False;Property;_T3_AnimatedGrunge;T3_AnimatedGrunge?;69;0;Create;True;0;0;False;1;Header(T3 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1087;-12702.15,-1322.17;Inherit;True;Property;_TextureSample53;Texture Sample 53;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;903;-12463.84,-2757.215;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;869;-15219.03,-2256.253;Inherit;False;839;T2_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;919;-13308.23,-3845.578;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1430;-11815.04,-3309.125;Inherit;False;Constant;_Float9;Float 9;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1428;-11797.62,-3724.511;Inherit;False;Constant;_Float10;Float 10;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1460;-13707.75,-3986.428;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1194;-15117.46,-493.0602;Inherit;False;TA_3_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TexturePropertyNode;1363;-15377.53,-1210.626;Inherit;True;Property;_TA_3_Textures;TA_3_Textures;60;0;Create;True;0;0;False;1;Header(Texture 3 VertexPaintGreen);False;ef1e633c4c2c51641bd59a932b55b28a;0556bc6f8449b5645a36bdb589f4767d;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;1446;-11623.58,-901.7634;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;874;-15358.11,-3287.447;Inherit;True;Property;_TA_2_Grunges;TA_2_Grunges;42;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;8f4c22a1083f0e64f8a4c34b3cc88618;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.LerpOp;1450;-11662.96,-442.2463;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;698;-480.2802,-2682.5;Inherit;False;428;Shadows;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1191;-13683.7,-956.8566;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Rows;T3_AnimatedGrunge_Flipbook_Rows;74;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;872;-15211.56,-2097.204;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1362;-14916.08,-1208.338;Inherit;True;Property;_TA_3_Textures_Sample;TA_3_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1080;-13306.69,-1052.336;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;1427;-11601.84,-3689.393;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;914;-12228.43,-3248.752;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;1483;-9854.276,-818.3984;Inherit;False;1119;T3_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1203;-14917.64,-1015.232;Inherit;True;Property;_TextureSample33;Texture Sample 33;97;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1362;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;413;-3673.75,-6638.963;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1371;-14558.7,-100.5275;Inherit;False;T3_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1437;-12777.36,-2773.105;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1557;485.8868,-644.0797;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;822;-13940.24,-3746.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Columns;T2_AnimatedGrunge_Flipbook_Columns;55;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1086;-12875.17,-1163.007;Inherit;False;Constant;_Float31;Float 31;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1179;-15304.45,141.9764;Inherit;False;Constant;_Float38;Float 38;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1164;-15371.68,-1004.485;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1084;-13750.04,99.56036;Inherit;False;Constant;_Float7;Float 7;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1099;-13967.07,-397.1354;Inherit;False;Constant;_Float33;Float 33;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;839;-13190.94,-2090.831;Inherit;False;T2_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;841;-13324.09,-4012.472;Inherit;False;Property;_T2_IsGrungeAnimated;T2_IsGrungeAnimated?;52;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1178;-14520.43,-1204.725;Inherit;False;T3_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1187;-10584.52,0.2567101;Inherit;False;T3_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1106;-12450.94,-455.7013;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;882;-13938.24,-3597.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Speed;T2_AnimatedGrunge_Flipbook_Speed;57;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;1562;669.8751,-1161.068;Float;False;float result=0@$for(int i=0@ i<Length@i++)${$	float dist = distance(WorldPos,FakeLightsPositionsArray[i])@$	result += 1 - smoothstep( LightStep, LightStepAttenuation, dist)@$}$return result@;1;False;5;True;In0;FLOAT;0;In;;Inherit;False;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;Length;FLOAT;0;In;;Inherit;False;True;LightStep;FLOAT;0;In;;Float;False;True;LightStepAttenuation;FLOAT;0;In;;Float;False;Cycle Through Array;True;False;0;5;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1564;200.961,-2587.375;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;890;-13545.24,-3577.098;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1555;1013.309,-1160.608;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1110;-12175.74,-1310.461;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1556;91.83369,-930.3686;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1552;189.9518,-594.5348;Inherit;False;Property;_FakeLightStepAttenuation;FakeLightStepAttenuation;121;0;Create;False;0;0;False;0;False;5;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1560;292.8341,-768.3687;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;1561;-73.46126,-800.7488;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1462;-13764.91,-3852.185;Inherit;False;Property;_T2_AnimatedGrunge_ScreenBased;T2_AnimatedGrunge_ScreenBased?;53;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1447;-11819.36,-936.8813;Inherit;False;Constant;_Float42;Float 42;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1550;-133.1664,-899.3686;Inherit;False;Property;_WaveFakeLight_Min;WaveFakeLight_Min;123;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1549;-133.1664,-983.3686;Inherit;False;Property;_WaveFakeLight_Max;WaveFakeLight_Max;124;0;Create;False;0;0;False;0;False;1.1;1.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1548;21.88494,-685.041;Inherit;False;Property;_FakeLightStep;FakeLightStep;120;0;Create;False;0;0;False;0;False;0;3;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1729;-15378.57,4534.239;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;704;-402.5542,-2787.036;Inherit;False;622;AllAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1479;-9389.141,-3991.244;Inherit;False;839;T2_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1169;-13966,-162.2892;Inherit;False;Property;_T3_PaintGrunge_Tiling;T3_PaintGrunge_Tiling;66;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1119;-13175.16,688.6451;Inherit;False;T3_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1448;-11836.78,-521.4954;Inherit;False;Constant;_Float43;Float 43;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;854;-13939.24,-3672.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Rows;T2_AnimatedGrunge_Flipbook_Rows;56;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1081;-12983.38,-1293.055;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1156;-12457.74,-1064.461;Inherit;False;Property;_T3_AnimatedGrunge_Contrast;T3_AnimatedGrunge_Contrast;76;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1154;-12158.81,-1060.272;Inherit;False;Property;_T3_AnimatedGrunge_Multiply;T3_AnimatedGrunge_Multiply;77;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1152;-14016.65,-1121.608;Inherit;False;Property;_T3_AnimatedGrunge_Tiling;T3_AnimatedGrunge_Tiling;72;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1480;-8927.268,-3993.609;Inherit;False;T2_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1108;-11268.2,-481.6813;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;1558;-239.3943,-801.0848;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1481;-9623.276,-817.3984;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;906;-13378.99,-2778.438;Inherit;True;Procedural Sample;-1;;121;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.ColorNode;1126;-12499.33,170.0253;Inherit;False;Property;_T3_ColorCorrection;T3_ColorCorrection;62;0;Create;True;0;0;False;0;False;1,1,1,0;0.8867924,0.8867924,0.8867924,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1778;-2586.594,-1780.208;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1114;-12226.89,-455.5104;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ScreenPosInputsNode;917;-14016.19,-4086.85;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1547;1187.168,-1165.658;Inherit;False;FakeLights;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1565;402.8804,-2753.529;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1482;-9394.403,-819.7634;Inherit;False;T3_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1197;-14013.08,-594.1707;Inherit;True;1194;TA_3_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1161;-13322.55,-1219.23;Inherit;False;Property;_T3_IsGrungeAnimated;T3_IsGrungeAnimated?;70;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1107;-10902.08,-0.599247;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1192;-15348.65,-263.1105;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;875;-15350.19,-3056.352;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;913;-12452.48,-3248.943;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1378;-13835.29,-2548.948;Inherit;False;T2_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1431;-11641.22,-3229.876;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1438;-13076.64,-2658.16;Inherit;False;Property;_T2_Albedo_ProceduralTiling;T2_Albedo_ProceduralTiling?;45;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;880;-15308.06,-2879.305;Inherit;False;Constant;_Float52;Float 52;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;888;-14023.02,-2549.071;Inherit;False;Property;_T2_Albedo_Tiling;T2_Albedo_Tiling;46;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1436;-13380.65,-2446.472;Inherit;True;Property;_TextureSample28;Texture Sample 28;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;877;-15305.99,-2651.265;Inherit;False;Constant;_Float22;Float 22;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;878;-15308.1,-2727.18;Inherit;False;Constant;_Float23;Float 23;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1432;-11976.39,-3110.053;Inherit;False;Property;_T2_PaintGrunge;T2_PaintGrunge?;47;0;Create;True;0;0;False;1;Header(T2 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;911;-11269.74,-3274.923;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1105;-13695.46,-594.4177;Inherit;True;Procedural Sample;-1;;128;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;818;-13351.56,-3218.651;Inherit;False;Property;_T2_PaintGrunge_Contrast;T2_PaintGrunge_Contrast;49;0;Create;True;0;0;False;0;False;0;-3.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;858;-14919.18,-3808.473;Inherit;True;Property;_TextureSample44;Texture Sample 44;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;865;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;865;-14917.62,-4001.58;Inherit;True;Property;_TA_2_Textures_Sample;TA_2_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1149;-13350.02,-425.4093;Inherit;False;Property;_T3_PaintGrunge_Contrast;T3_PaintGrunge_Contrast;67;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;806;-14032.7,-2094.494;Inherit;True;816;T2_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1088;-13035.04,-587.1907;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1392;-13617.3,-2592.616;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;884;-12703.69,-4115.412;Inherit;True;Property;_TextureSample48;Texture Sample 48;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1377;-13841.25,241.5291;Inherit;False;T3_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1094;-12209.33,36.02634;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1459;-12115.79,-2755.698;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;873;-15119,-3286.302;Inherit;False;TA_2_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;867;-14907.49,-3284.813;Inherit;True;Property;_TA_2_Grunges_Sample;TA_2_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;866;-15380.65,-4003.868;Inherit;True;Property;_TA_2_Textures;TA_2_Textures;41;0;Create;True;0;0;False;1;Header(Texture 2 VertexPaintRed);False;ef1e633c4c2c51641bd59a932b55b28a;2b6e729c66a58e64e9da60628e5652f1;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TFHCGrayscale;1478;-9156.141,-3991.244;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;850;-14560.24,-2893.769;Inherit;False;T2_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;881;-15136.23,-4002.577;Inherit;False;TA_2_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;889;-13751.58,-2693.681;Inherit;False;Constant;_Float26;Float 26;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;1130;-13790.65,-1293.608;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1089;-13682.7,-881.8566;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Speed;T3_AnimatedGrunge_Flipbook_Speed;75;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;885;-12876.71,-3956.249;Inherit;False;Constant;_Float55;Float 55;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1092;-14028.48,242.1707;Inherit;False;Property;_T3_Albedo_Tiling;T3_Albedo_Tiling;64;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1211;-14014.91,686.9343;Inherit;True;1187;T3_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1085;-11640.59,37.8364;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1182;-14901.53,92.21172;Inherit;True;Property;_TextureSample52;Texture Sample 52;98;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1429;-11941.01,-3615.568;Inherit;False;Property;_T2_AnimatedGrunge;T2_AnimatedGrunge?;51;0;Create;True;0;0;False;1;Header(T2 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;886;-11642.13,-2755.405;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1124;-13377.45,14.80359;Inherit;True;Procedural Sample;-1;;131;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerNode;1190;-14903.06,-100.5114;Inherit;True;Property;_TextureSample35;Texture Sample 35;89;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1215;-14525.22,-293.0524;Inherit;False;T3_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1468;-13484.83,-1287.348;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1204;-15342.3,-864.4894;Inherit;False;Constant;_Float39;Float 39;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1214;-14628.34,536.1824;Inherit;False;Texture3_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1205;-14531.95,-490.5714;Inherit;False;T3_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1196;-14942.91,541.4324;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1180;-14903.9,-291.5104;Inherit;True;Property;_TextureSample51;Texture Sample 51;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;816;-10586.06,-2792.985;Inherit;False;T2_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1193;-15356.57,-494.2053;Inherit;True;Property;_TA_3_Grunges;TA_3_Grunges;61;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;b33b36e28008b23459206c358b00d02a;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;817;-12803.49,-3132.252;Inherit;False;Property;_T2_PaintGrunge_Multiply;T2_PaintGrunge_Multiply;50;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1466;-13705.67,-1166.591;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1199;-15208.11,617.3884;Inherit;False;1482;T3_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1458;-12392.42,-2509.62;Inherit;False;Property;_T2_Albedo_Contrast;T2_Albedo_Contrast;44;0;Create;True;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;883;-13036.58,-3380.432;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1198;-15217.49,536.9885;Inherit;False;1119;T3_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;923;-12753.84,-2623.216;Inherit;False;Property;_T2_ColorCorrection;T2_ColorCorrection;43;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1090;-15134.69,-1209.335;Inherit;False;TA_3_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;1439;-13382.35,336.0486;Inherit;True;Property;_TextureSample29;Texture Sample 29;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;851;-14903.07,-2701.03;Inherit;True;Property;_TextureSample40;Texture Sample 40;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;916;-13697,-3387.659;Inherit;True;Procedural Sample;-1;;130;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1160;-13684.7,-1030.857;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Columns;T3_AnimatedGrunge_Flipbook_Columns;73;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;912;-10903.62,-2793.841;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1441;-12779.06,9.415527;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1163;-15306.56,66.06134;Inherit;False;Constant;_Float37;Float 37;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1241;-14905.95,-491.5715;Inherit;True;Property;_TA_3_Grunges_Sample;TA_3_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;1774;-3070.006,-1572.153;Inherit;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;1682;-15386,4328.098;Inherit;True;Property;_TA_5_Textures;TA_5_Textures;100;0;Create;True;0;0;False;1;Header(Texture 5 VertexPaintYellow);False;ef1e633c4c2c51641bd59a932b55b28a;None;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;1751;-14038.56,4531.385;Inherit;False;Property;_T5_AnimatedGrunge_ScreenBased;T5_AnimatedGrunge_ScreenBased?;111;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1393;-13780.73,-3020.198;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;857;-15343.84,-3657.731;Inherit;False;Constant;_Float50;Float 50;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;920;-11917.5,-2572.686;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;823;-14014.62,-3387.412;Inherit;True;873;TA_2_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1390;-13637.1,196.9722;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1091;-15306.52,-86.06361;Inherit;False;Constant;_Float32;Float 32;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;622;-2299.633,-1783.823;Inherit;False;AllAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;1480.34,-2664.381;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;TerrainMaterialShader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;1;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-2980.375,-2398.073;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;1139;1;1052;0
WireConnection;1139;6;1058;0
WireConnection;1173;1;1069;0
WireConnection;1173;6;1075;0
WireConnection;184;0;1423;0
WireConnection;184;1;1420;0
WireConnection;187;0;301;0
WireConnection;1063;0;1076;0
WireConnection;1063;1;1135;0
WireConnection;1137;0;1139;0
WireConnection;1465;0;130;0
WireConnection;1465;1;1463;0
WireConnection;1465;2;1464;0
WireConnection;1140;0;1098;0
WireConnection;1051;0;1079;0
WireConnection;1543;0;431;0
WireConnection;1543;1;1541;0
WireConnection;1543;2;429;0
WireConnection;1442;0;1175;0
WireConnection;1442;1;1389;0
WireConnection;167;0;163;0
WireConnection;1129;0;1471;0
WireConnection;1129;1;1159;0
WireConnection;1129;2;1158;0
WireConnection;1129;3;1157;0
WireConnection;1129;5;1141;0
WireConnection;252;0;335;0
WireConnection;1046;0;1060;0
WireConnection;1046;1;1067;0
WireConnection;1079;0;1134;0
WireConnection;1079;1;1444;0
WireConnection;1062;158;1213;0
WireConnection;1062;183;1133;0
WireConnection;1062;5;1388;0
WireConnection;1364;0;1050;0
WireConnection;1148;1;1052;0
WireConnection;1148;6;1070;0
WireConnection;1076;1;1062;0
WireConnection;1076;0;1171;0
WireConnection;381;1;158;0
WireConnection;381;6;156;0
WireConnection;1125;158;1175;0
WireConnection;1125;183;1083;0
WireConnection;1125;5;1389;0
WireConnection;1376;0;1072;0
WireConnection;1066;0;1078;0
WireConnection;1066;1;1162;0
WireConnection;1069;0;1471;0
WireConnection;1069;1;1129;0
WireConnection;1069;2;1150;0
WireConnection;1065;0;1453;0
WireConnection;1065;1;1455;0
WireConnection;1050;0;1118;0
WireConnection;1050;1;1367;0
WireConnection;1050;2;1049;0
WireConnection;1476;0;1475;0
WireConnection;1122;0;1064;0
WireConnection;1453;0;1451;0
WireConnection;1453;1;1066;0
WireConnection;1453;2;1452;0
WireConnection;1691;0;1712;0
WireConnection;1691;1;1727;0
WireConnection;1389;0;1376;0
WireConnection;1444;0;1442;0
WireConnection;1444;1;1125;0
WireConnection;1444;2;1443;0
WireConnection;1060;0;1061;0
WireConnection;1074;0;1079;0
WireConnection;1074;1;1051;0
WireConnection;1074;2;1103;0
WireConnection;712;1;739;0
WireConnection;712;6;702;0
WireConnection;1471;0;1046;0
WireConnection;1471;1;1470;0
WireConnection;1471;2;1469;0
WireConnection;731;1;739;0
WireConnection;731;6;714;0
WireConnection;1385;0;1379;0
WireConnection;1455;0;1454;0
WireConnection;1455;1;1056;0
WireConnection;1455;2;1456;0
WireConnection;1366;0;1148;0
WireConnection;1470;0;1067;0
WireConnection;285;1;336;0
WireConnection;285;0;377;0
WireConnection;606;0;605;0
WireConnection;734;1;739;0
WireConnection;734;6;733;0
WireConnection;1423;0;1424;0
WireConnection;1423;1;224;0
WireConnection;1423;2;1422;0
WireConnection;130;0;167;0
WireConnection;130;1;175;0
WireConnection;224;0;716;0
WireConnection;224;1;318;0
WireConnection;282;0;1565;0
WireConnection;282;1;294;0
WireConnection;282;2;609;0
WireConnection;133;0;74;0
WireConnection;1420;0;1421;0
WireConnection;1420;1;135;0
WireConnection;1420;2;1419;0
WireConnection;202;0;190;0
WireConnection;617;158;709;0
WireConnection;617;183;619;0
WireConnection;617;5;1385;0
WireConnection;179;0;1465;0
WireConnection;179;1;132;0
WireConnection;179;2;127;0
WireConnection;179;3;146;0
WireConnection;179;5;208;0
WireConnection;177;1;50;0
WireConnection;177;6;172;0
WireConnection;253;0;285;0
WireConnection;253;1;297;0
WireConnection;1379;0;621;0
WireConnection;1010;0;698;0
WireConnection;1010;1;1512;0
WireConnection;1010;2;1012;0
WireConnection;1394;0;258;0
WireConnection;708;0;706;0
WireConnection;1463;0;175;0
WireConnection;336;158;710;0
WireConnection;336;183;711;0
WireConnection;336;5;1394;0
WireConnection;1434;0;1433;0
WireConnection;1434;1;617;0
WireConnection;1434;2;1435;0
WireConnection;286;0;282;0
WireConnection;286;1;280;0
WireConnection;286;2;611;0
WireConnection;716;1;403;0
WireConnection;716;0;717;0
WireConnection;158;0;1465;0
WireConnection;158;1;179;0
WireConnection;158;2;150;0
WireConnection;701;0;700;0
WireConnection;700;0;738;0
WireConnection;700;1;739;0
WireConnection;700;6;268;0
WireConnection;748;0;340;0
WireConnection;135;0;253;0
WireConnection;403;0;381;1
WireConnection;713;0;712;0
WireConnection;340;0;274;0
WireConnection;340;1;349;0
WireConnection;340;2;607;0
WireConnection;738;0;737;0
WireConnection;74;0;708;0
WireConnection;74;1;50;0
WireConnection;74;6;71;0
WireConnection;1477;0;1476;0
WireConnection;1433;0;709;0
WireConnection;1433;1;1385;0
WireConnection;335;0;1434;0
WireConnection;335;1;399;0
WireConnection;735;0;734;0
WireConnection;191;0;335;0
WireConnection;191;1;252;0
WireConnection;191;2;615;0
WireConnection;732;0;731;0
WireConnection;190;0;184;0
WireConnection;190;1;191;0
WireConnection;1759;0;1756;0
WireConnection;1695;0;1747;0
WireConnection;580;0;583;0
WireConnection;580;1;584;0
WireConnection;580;2;581;0
WireConnection;1685;0;1697;0
WireConnection;1675;0;1722;0
WireConnection;1771;0;1768;0
WireConnection;1677;0;1684;0
WireConnection;1686;0;1694;0
WireConnection;1686;1;1704;0
WireConnection;1733;0;1752;0
WireConnection;1679;0;1687;0
WireConnection;1687;1;1740;0
WireConnection;1687;6;1758;0
WireConnection;1756;0;1685;0
WireConnection;1756;1;1740;0
WireConnection;1756;6;1748;0
WireConnection;1752;1;1740;0
WireConnection;1752;6;1730;0
WireConnection;1676;1;1740;0
WireConnection;1676;6;1738;0
WireConnection;1690;1;1696;0
WireConnection;1690;6;1728;0
WireConnection;1755;0;1757;0
WireConnection;1705;0;1715;0
WireConnection;1767;0;1765;0
WireConnection;586;0;1472;3
WireConnection;594;1;563;0
WireConnection;594;6;598;0
WireConnection;644;0;640;0
WireConnection;1768;0;1473;1
WireConnection;1768;1;1473;2
WireConnection;479;0;594;0
WireConnection;1386;0;1413;0
WireConnection;11;0;565;0
WireConnection;11;1;569;0
WireConnection;11;2;1472;1
WireConnection;14;0;11;0
WireConnection;14;1;576;0
WireConnection;14;2;585;0
WireConnection;495;0;14;0
WireConnection;495;1;580;0
WireConnection;495;2;586;0
WireConnection;1783;0;1782;0
WireConnection;1782;1;563;0
WireConnection;1782;6;1781;0
WireConnection;139;0;1383;0
WireConnection;640;0;635;0
WireConnection;640;1;692;0
WireConnection;640;2;694;0
WireConnection;1777;0;1776;0
WireConnection;1777;1;1775;0
WireConnection;1777;2;1779;0
WireConnection;1743;1;1729;0
WireConnection;1743;6;1732;0
WireConnection;1731;0;1737;0
WireConnection;1383;158;1380;0
WireConnection;1383;183;1382;0
WireConnection;1383;5;1386;0
WireConnection;1770;0;640;0
WireConnection;1770;1;1769;0
WireConnection;1770;2;1771;0
WireConnection;1763;0;1762;0
WireConnection;1138;1;1052;0
WireConnection;1138;6;1059;0
WireConnection;1761;0;1734;0
WireConnection;1684;0;1678;0
WireConnection;1684;1;1721;0
WireConnection;1097;0;1173;1
WireConnection;1064;0;1065;0
WireConnection;1064;1;1074;0
WireConnection;1132;0;1143;0
WireConnection;1683;1;1713;0
WireConnection;1683;0;1726;0
WireConnection;1689;0;1683;0
WireConnection;1689;1;1701;0
WireConnection;1146;0;1145;0
WireConnection;1744;0;1689;0
WireConnection;1717;0;1750;0
WireConnection;1717;1;1745;0
WireConnection;1372;0;1138;0
WireConnection;1719;0;1691;0
WireConnection;1719;1;1716;0
WireConnection;1719;2;1751;0
WireConnection;1680;0;1719;0
WireConnection;1680;1;1693;0
WireConnection;1680;2;1711;0
WireConnection;1680;3;1720;0
WireConnection;1680;5;1702;0
WireConnection;1144;1;1057;0
WireConnection;1144;6;1047;0
WireConnection;1056;0;1063;0
WireConnection;1692;0;1741;0
WireConnection;1692;1;1744;0
WireConnection;1692;2;1718;0
WireConnection;1696;0;1719;0
WireConnection;1696;1;1680;0
WireConnection;1696;2;1754;0
WireConnection;1120;0;1121;0
WireConnection;1143;0;1146;0
WireConnection;1143;1;1057;0
WireConnection;1143;6;1068;0
WireConnection;1388;0;1166;0
WireConnection;1111;0;1115;0
WireConnection;1736;0;1690;1
WireConnection;1721;0;1686;0
WireConnection;1721;1;1703;0
WireConnection;1721;2;1707;0
WireConnection;1710;0;1725;0
WireConnection;1710;1;1692;0
WireConnection;1757;0;1724;0
WireConnection;1703;158;1694;0
WireConnection;1703;183;1714;0
WireConnection;1703;5;1704;0
WireConnection;1739;0;1682;0
WireConnection;1485;0;1484;0
WireConnection;1735;0;1681;0
WireConnection;1700;0;1676;0
WireConnection;1484;0;1486;0
WireConnection;1765;158;1766;0
WireConnection;1765;183;1764;0
WireConnection;1765;5;1763;0
WireConnection;1704;0;1705;0
WireConnection;1722;0;1709;0
WireConnection;1722;1;1708;0
WireConnection;1722;2;1746;0
WireConnection;1750;1;1736;0
WireConnection;1750;0;1699;0
WireConnection;1747;0;1710;0
WireConnection;1747;1;1706;0
WireConnection;1713;158;1688;0
WireConnection;1713;183;1723;0
WireConnection;1713;5;1735;0
WireConnection;1725;0;1760;0
WireConnection;1725;1;1717;0
WireConnection;1725;2;1753;0
WireConnection;1712;0;1749;0
WireConnection;1706;0;1684;0
WireConnection;1706;1;1677;0
WireConnection;1706;2;1742;0
WireConnection;821;0;918;0
WireConnection;821;1;820;0
WireConnection;1115;0;1140;0
WireConnection;1115;1;1052;0
WireConnection;1115;6;1077;0
WireConnection;1716;0;1727;0
WireConnection;1078;1;1097;0
WireConnection;1078;0;1155;0
WireConnection;1737;0;1739;0
WireConnection;1737;1;1729;0
WireConnection;1737;6;1698;0
WireConnection;705;0;704;0
WireConnection;705;1;1010;0
WireConnection;157;0;170;0
WireConnection;157;1;142;0
WireConnection;157;2;168;0
WireConnection;1404;0;1415;0
WireConnection;1538;0;429;0
WireConnection;435;0;425;0
WireConnection;435;1;421;0
WireConnection;218;1;386;0
WireConnection;1396;0;1397;0
WireConnection;635;0;632;0
WireConnection;635;1;691;0
WireConnection;635;2;693;0
WireConnection;694;0;1473;3
WireConnection;406;0;416;0
WireConnection;406;1;435;0
WireConnection;406;2;427;0
WireConnection;592;1;563;0
WireConnection;592;6;596;0
WireConnection;585;0;1472;2
WireConnection;1461;0;821;0
WireConnection;1461;1;1460;0
WireConnection;1461;2;1462;0
WireConnection;863;0;865;0
WireConnection;1502;0;1509;0
WireConnection;1502;1;1503;0
WireConnection;908;1;907;0
WireConnection;908;0;819;0
WireConnection;1113;0;1094;0
WireConnection;849;0;851;0
WireConnection;891;0;1461;0
WireConnection;891;1;919;0
WireConnection;891;2;841;0
WireConnection;1541;0;1540;0
WireConnection;1541;1;1521;0
WireConnection;363;1;359;0
WireConnection;856;0;867;0
WireConnection;197;0;365;0
WireConnection;918;0;917;0
WireConnection;614;0;613;0
WireConnection;1409;158;1412;0
WireConnection;1409;183;1411;0
WireConnection;1409;5;1410;0
WireConnection;853;0;846;0
WireConnection;1369;0;1182;0
WireConnection;871;0;869;0
WireConnection;871;1;870;0
WireConnection;871;2;872;0
WireConnection;565;0;573;0
WireConnection;565;1;489;0
WireConnection;565;2;567;0
WireConnection;1109;0;1110;0
WireConnection;1109;1;1154;0
WireConnection;408;0;424;0
WireConnection;868;0;871;0
WireConnection;905;0;903;0
WireConnection;846;1;875;0
WireConnection;846;6;879;0
WireConnection;569;0;574;0
WireConnection;569;1;570;0
WireConnection;569;2;571;0
WireConnection;386;0;362;0
WireConnection;424;0;430;0
WireConnection;424;1;426;0
WireConnection;170;0;128;0
WireConnection;428;0;1544;0
WireConnection;420;0;425;0
WireConnection;420;1;422;0
WireConnection;1496;0;1510;0
WireConnection;359;0;157;0
WireConnection;359;2;159;0
WireConnection;566;0;564;0
WireConnection;1544;1;1543;0
WireConnection;1544;2;1546;0
WireConnection;1402;0;1403;0
WireConnection;180;0;159;0
WireConnection;431;0;429;0
WireConnection;1521;0;429;0
WireConnection;1521;1;432;0
WireConnection;478;0;593;0
WireConnection;608;0;423;0
WireConnection;1403;158;1406;0
WireConnection;1403;183;1405;0
WireConnection;1403;5;1404;0
WireConnection;1540;0;1538;0
WireConnection;1540;1;1539;0
WireConnection;1397;158;1400;0
WireConnection;1397;183;1399;0
WireConnection;1397;5;1398;0
WireConnection;693;0;1473;2
WireConnection;1545;0;429;0
WireConnection;563;0;590;0
WireConnection;140;0;413;0
WireConnection;1546;0;1545;0
WireConnection;477;0;592;0
WireConnection;1398;0;1414;0
WireConnection;1410;0;1416;0
WireConnection;1408;0;1409;0
WireConnection;429;0;408;0
WireConnection;429;1;406;0
WireConnection;593;1;563;0
WireConnection;593;6;597;0
WireConnection;430;0;356;0
WireConnection;430;1;425;0
WireConnection;430;2;420;0
WireConnection;411;0;169;0
WireConnection;414;0;411;0
WireConnection;414;1;412;0
WireConnection;142;0;162;0
WireConnection;142;1;128;0
WireConnection;576;0;579;0
WireConnection;576;1;578;0
WireConnection;576;2;577;0
WireConnection;362;0;157;0
WireConnection;362;2;180;0
WireConnection;1510;1;1511;0
WireConnection;1510;0;1508;0
WireConnection;1508;0;1498;0
WireConnection;1508;1;1502;0
WireConnection;162;0;176;0
WireConnection;365;0;218;1
WireConnection;365;1;363;1
WireConnection;427;0;420;0
WireConnection;427;1;421;0
WireConnection;610;0;281;0
WireConnection;1498;0;1493;0
WireConnection;1498;1;1499;0
WireConnection;1498;2;1501;0
WireConnection;632;0;642;0
WireConnection;632;1;690;0
WireConnection;632;2;1473;1
WireConnection;488;0;559;0
WireConnection;559;1;563;0
WireConnection;559;6;595;0
WireConnection;909;0;908;0
WireConnection;909;1;910;0
WireConnection;852;1;875;0
WireConnection;852;6;878;0
WireConnection;907;0;884;1
WireConnection;1501;0;1499;0
WireConnection;1501;1;1500;0
WireConnection;1509;0;1498;0
WireConnection;1391;0;1169;0
WireConnection;1112;0;1087;1
WireConnection;1186;0;1130;0
WireConnection;1186;1;1152;0
WireConnection;1087;1;1081;0
WireConnection;1087;6;1086;0
WireConnection;903;0;923;0
WireConnection;903;1;1437;0
WireConnection;919;0;1461;0
WireConnection;919;1;822;0
WireConnection;919;2;854;0
WireConnection;919;3;882;0
WireConnection;919;5;890;0
WireConnection;1460;0;820;0
WireConnection;1194;0;1193;0
WireConnection;1446;0;1447;0
WireConnection;1446;1;1109;0
WireConnection;1446;2;1445;0
WireConnection;1450;0;1448;0
WireConnection;1450;1;1114;0
WireConnection;1450;2;1449;0
WireConnection;1362;0;1090;0
WireConnection;1362;1;1164;0
WireConnection;1362;6;1204;0
WireConnection;1080;0;1468;0
WireConnection;1080;1;1160;0
WireConnection;1080;2;1191;0
WireConnection;1080;3;1089;0
WireConnection;1080;5;1082;0
WireConnection;1427;0;1428;0
WireConnection;1427;1;909;0
WireConnection;1427;2;1429;0
WireConnection;914;0;913;0
WireConnection;1203;1;1164;0
WireConnection;1203;6;1206;0
WireConnection;413;0;414;0
WireConnection;413;1;358;0
WireConnection;1371;0;1190;0
WireConnection;1437;0;1436;0
WireConnection;1437;1;906;0
WireConnection;1437;2;1438;0
WireConnection;1557;0;1560;0
WireConnection;1557;1;1552;0
WireConnection;839;0;806;0
WireConnection;1178;0;1362;0
WireConnection;1187;0;1107;0
WireConnection;1106;0;1088;0
WireConnection;1106;1;1170;0
WireConnection;1562;0;1551;0
WireConnection;1562;1;1559;0
WireConnection;1562;2;1554;0
WireConnection;1562;3;1560;0
WireConnection;1562;4;1557;0
WireConnection;1564;0;705;0
WireConnection;1564;1;1563;0
WireConnection;1555;0;1562;0
WireConnection;1110;1;1112;0
WireConnection;1110;0;1156;0
WireConnection;1556;0;1549;0
WireConnection;1556;1;1550;0
WireConnection;1556;2;1561;0
WireConnection;1560;0;1556;0
WireConnection;1560;1;1548;0
WireConnection;1561;0;1558;0
WireConnection;1119;0;1211;0
WireConnection;1081;0;1468;0
WireConnection;1081;1;1080;0
WireConnection;1081;2;1161;0
WireConnection;1480;0;1478;0
WireConnection;1108;0;1446;0
WireConnection;1108;1;1450;0
WireConnection;1558;0;1553;0
WireConnection;1481;0;1483;0
WireConnection;906;158;825;0
WireConnection;906;183;889;0
WireConnection;906;5;1392;0
WireConnection;1778;0;495;0
WireConnection;1778;1;1777;0
WireConnection;1778;2;1774;0
WireConnection;1114;0;1106;0
WireConnection;1547;0;1555;0
WireConnection;1565;0;705;0
WireConnection;1565;1;1564;0
WireConnection;1565;2;1566;0
WireConnection;1482;0;1481;0
WireConnection;1107;0;1108;0
WireConnection;1107;1;1085;0
WireConnection;913;0;883;0
WireConnection;913;1;817;0
WireConnection;1378;0;888;0
WireConnection;1431;0;1430;0
WireConnection;1431;1;914;0
WireConnection;1431;2;1432;0
WireConnection;1436;0;825;0
WireConnection;1436;1;1392;0
WireConnection;911;0;1427;0
WireConnection;911;1;1431;0
WireConnection;1105;158;1197;0
WireConnection;1105;183;1099;0
WireConnection;1105;5;1391;0
WireConnection;858;1;876;0
WireConnection;858;6;855;0
WireConnection;865;0;881;0
WireConnection;865;1;876;0
WireConnection;865;6;857;0
WireConnection;1088;1;1105;0
WireConnection;1088;0;1149;0
WireConnection;1392;0;1378;0
WireConnection;884;1;891;0
WireConnection;884;6;885;0
WireConnection;1377;0;1092;0
WireConnection;1094;0;1126;0
WireConnection;1094;1;1441;0
WireConnection;1459;1;903;0
WireConnection;1459;0;1458;0
WireConnection;873;0;874;0
WireConnection;867;0;873;0
WireConnection;867;1;875;0
WireConnection;867;6;880;0
WireConnection;1478;0;1479;0
WireConnection;850;0;852;0
WireConnection;881;0;866;0
WireConnection;1130;0;1104;0
WireConnection;1085;0;1094;0
WireConnection;1085;1;1113;0
WireConnection;1085;2;1128;0
WireConnection;1182;1;1192;0
WireConnection;1182;6;1179;0
WireConnection;886;0;1459;0
WireConnection;886;1;905;0
WireConnection;886;2;920;0
WireConnection;1124;158;1185;0
WireConnection;1124;183;1084;0
WireConnection;1124;5;1390;0
WireConnection;1190;1;1192;0
WireConnection;1190;6;1163;0
WireConnection;1215;0;1180;0
WireConnection;1468;0;1186;0
WireConnection;1468;1;1466;0
WireConnection;1468;2;1467;0
WireConnection;1214;0;1196;0
WireConnection;1205;0;1241;0
WireConnection;1196;0;1198;0
WireConnection;1196;1;1199;0
WireConnection;1196;2;1195;0
WireConnection;1180;1;1192;0
WireConnection;1180;6;1136;0
WireConnection;816;0;912;0
WireConnection;1466;0;1152;0
WireConnection;883;1;916;0
WireConnection;883;0;818;0
WireConnection;1090;0;1363;0
WireConnection;1439;0;1185;0
WireConnection;1439;1;1390;0
WireConnection;851;1;875;0
WireConnection;851;6;877;0
WireConnection;916;158;823;0
WireConnection;916;183;921;0
WireConnection;916;5;1393;0
WireConnection;912;0;911;0
WireConnection;912;1;886;0
WireConnection;1441;0;1439;0
WireConnection;1441;1;1124;0
WireConnection;1441;2;1440;0
WireConnection;1241;0;1194;0
WireConnection;1241;1;1192;0
WireConnection;1241;6;1091;0
WireConnection;1774;0;1472;0
WireConnection;1393;0;915;0
WireConnection;1390;0;1377;0
WireConnection;622;0;495;0
WireConnection;2;2;286;0
ASEEND*/
//CHKSM=336B815B43909E63A465D58A623B9334F4FC8B3A
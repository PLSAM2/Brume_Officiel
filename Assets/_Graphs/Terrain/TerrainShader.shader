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
		[Header(T1 Custom Rim Light)]_T1_CustomRimLight("T1_CustomRimLight?", Range( 0 , 1)) = 0
		_T1_CustomRimLight_Texture("T1_CustomRimLight_Texture?", Range( 0 , 1)) = 1
		_T1_CustomRimLight_Color("T1_CustomRimLight_Color", Color) = (1,1,1,0)
		_T1_CustomRimLight_Opacity("T1_CustomRimLight_Opacity", Range( 0 , 1)) = 1
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
		[Header(T2 Custom Rim Light)]_T2_CustomRimLight("T2_CustomRimLight?", Range( 0 , 1)) = 0
		_T2_CutomRimLight_Texture("T2_CutomRimLight_Texture?", Range( 0 , 1)) = 1
		_T2_CustomRimLight_Color("T2_CustomRimLight_Color", Color) = (1,1,1,0)
		_T2_CustomRimLight_Opacity("T2_CustomRimLight_Opacity", Range( 0 , 1)) = 1
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
		[Header(T3 Custom Rim Light)]_T3_CustomRimLight("T3_CustomRimLight?", Range( 0 , 1)) = 0
		_T3_CutomRimLight_Texture("T3_CutomRimLight_Texture?", Range( 0 , 1)) = 1
		_T3_CustomRimLight_Color("T3_CustomRimLight_Color", Color) = (1,1,1,0)
		_T3_CustomRimLight_Opacity("T3_CustomRimLight_Opacity", Range( 0 , 1)) = 1
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
		[Header(T4 Custom Rim Light)]_T4_CustomRimLight("T4_CustomRimLight?", Range( 0 , 1)) = 0
		_T4_CutomRimLight_Texture("T4_CutomRimLight_Texture?", Range( 0 , 1)) = 1
		_T4_CustomRimLight_Color("T4_CustomRimLight_Color", Color) = (1,1,1,0)
		[ASEEnd]_T4_CustomRimLight_Opacity("T4_CustomRimLight_Opacity", Range( 0 , 1)) = 1
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
			float4 _T1_CustomRimLight_Color;
			float4 _T4_CustomRimLight_Color;
			float4 _T1_ColorCorrection;
			float4 _T3_CustomRimLight_Color;
			float4 _T2_CustomRimLight_Color;
			float4 _TerrainMaskTexture_ST;
			float4 _EdgeShadowColor;
			float4 _ShadowColor;
			float4 _T3_ColorCorrection;
			float2 _ShadowNoisePanner;
			float _T3_CustomRimLight_Opacity;
			float _T3_CustomRimLight;
			float _T3_Albedo_ProceduralTiling;
			float _T3_Albedo_Tiling;
			float _T3_CutomRimLight_Texture;
			float _T1_AnimatedGrunge_Contrast;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Multiply;
			float _T3_PaintGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_IsGrungeAnimated;
			float _T3_PaintGrunge;
			float _T4_AnimatedGrunge_Tiling;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _StepAttenuation;
			float _StepShadow;
			float _T4_CustomRimLight;
			float _T4_CutomRimLight_Texture;
			float _T4_CustomRimLight_Opacity;
			float _T4_Albedo_ProceduralTiling;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_Albedo_Tiling;
			float _T4_PaintGrunge_Multiply;
			float _T4_PaintGrunge_Tiling;
			float _T4_PaintGrunge_Contrast;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_PaintGrunge;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_ScreenBased;
			float _Out_or_InBrume;
			float _T1_CustomRimLight;
			float _T1_CustomRimLight_Texture;
			float _T1_CustomRimLight_Opacity;
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
			float _DebugTextureTiling;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _DebugVertexPaint;
			float _T2_AnimatedGrunge_Tiling;
			float _LightDebug;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_CustomRimLight;
			float _T2_CutomRimLight_Texture;
			float _T2_CustomRimLight_Opacity;
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
			float _T2_AnimatedGrunge_ScreenBased;
			float _T2_AnimatedGrunge_Contrast;
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
				float localStochasticTiling171_g109 = ( 0.0 );
				float2 temp_cast_4 = (_T1_PaintGrunge_Tiling).xx;
				float2 texCoord1394 = IN.ase_texcoord4.xy * temp_cast_4 + float2( 0,0 );
				float2 Input_UV145_g109 = texCoord1394;
				float2 UV171_g109 = Input_UV145_g109;
				float2 UV1171_g109 = float2( 0,0 );
				float2 UV2171_g109 = float2( 0,0 );
				float2 UV3171_g109 = float2( 0,0 );
				float W1171_g109 = 0.0;
				float W2171_g109 = 0.0;
				float W3171_g109 = 0.0;
				StochasticTiling( UV171_g109 , UV1171_g109 , UV2171_g109 , UV3171_g109 , W1171_g109 , W2171_g109 , W3171_g109 );
				float Input_Index184_g109 = 3.0;
				float2 temp_output_172_0_g109 = ddx( Input_UV145_g109 );
				float2 temp_output_182_0_g109 = ddy( Input_UV145_g109 );
				float4 Output_2DArray294_g109 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV1171_g109,Input_Index184_g109, temp_output_172_0_g109, temp_output_182_0_g109 ) * W1171_g109 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV2171_g109,Input_Index184_g109, temp_output_172_0_g109, temp_output_182_0_g109 ) * W2171_g109 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV3171_g109,Input_Index184_g109, temp_output_172_0_g109, temp_output_182_0_g109 ) * W3171_g109 ) );
				float lerpResult1420 = lerp( 1.0 , ( CalculateContrast(_T1_PaintGrunge_Contrast,Output_2DArray294_g109) * _T1_PaintGrunge_Multiply ).r , _T1_PaintGrunge);
				float T1_Albedo_Tiling1379 = _T1_Albedo_Tiling;
				float2 temp_cast_5 = (T1_Albedo_Tiling1379).xx;
				float2 texCoord1385 = IN.ase_texcoord4.xy * temp_cast_5 + float2( 0,0 );
				float localStochasticTiling171_g108 = ( 0.0 );
				float2 Input_UV145_g108 = texCoord1385;
				float2 UV171_g108 = Input_UV145_g108;
				float2 UV1171_g108 = float2( 0,0 );
				float2 UV2171_g108 = float2( 0,0 );
				float2 UV3171_g108 = float2( 0,0 );
				float W1171_g108 = 0.0;
				float W2171_g108 = 0.0;
				float W3171_g108 = 0.0;
				StochasticTiling( UV171_g108 , UV1171_g108 , UV2171_g108 , UV3171_g108 , W1171_g108 , W2171_g108 , W3171_g108 );
				float Input_Index184_g108 = 0.0;
				float2 temp_output_172_0_g108 = ddx( Input_UV145_g108 );
				float2 temp_output_182_0_g108 = ddy( Input_UV145_g108 );
				float4 Output_2DArray294_g108 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV1171_g108,Input_Index184_g108, temp_output_172_0_g108, temp_output_182_0_g108 ) * W1171_g108 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV2171_g108,Input_Index184_g108, temp_output_172_0_g108, temp_output_182_0_g108 ) * W2171_g108 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV3171_g108,Input_Index184_g108, temp_output_172_0_g108, temp_output_182_0_g108 ) * W3171_g108 ) );
				float4 lerpResult1434 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_1_Textures, sampler_TA_1_Textures, texCoord1385,0.0 ) , Output_2DArray294_g108 , _T1_Albedo_ProceduralTiling);
				float4 temp_output_335_0 = ( lerpResult1434 * _T1_ColorCorrection );
				float grayscale252 = dot(temp_output_335_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_7 = (grayscale252).xxxx;
				float GrayscaleDebug614 = _GrayscaleDebug;
				float4 lerpResult191 = lerp( temp_output_335_0 , temp_cast_7 , GrayscaleDebug614);
				float4 blendOpSrc190 = ( lerpResult1423 * lerpResult1420 );
				float4 blendOpDest190 = lerpResult191;
				float4 T1_RGB202 = ( saturate( ( blendOpSrc190 * blendOpDest190 ) ));
				float2 texCoord50 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode171 = SAMPLE_TEXTURE2D_ARRAY( _TA_1_Textures, sampler_TA_1_Textures, texCoord50,2.0 );
				float T1_RimLightMask_Texture265 = tex2DArrayNode171.a;
				float4 T1_RimLight_Texture599 = tex2DArrayNode171;
				float4 lerpResult601 = lerp( _T1_CustomRimLight_Color , T1_RimLight_Texture599 , _T1_CustomRimLight_Texture);
				float4 T1_CustomRimLight410 = ( ( T1_RimLightMask_Texture265 * _T1_CustomRimLight_Opacity ) * lerpResult601 );
				float4 blendOpSrc415 = T1_RGB202;
				float4 blendOpDest415 = T1_CustomRimLight410;
				float4 lerpResult246 = lerp( T1_RGB202 , ( saturate( max( blendOpSrc415, blendOpDest415 ) )) , _T1_CustomRimLight);
				float4 T1_End_OutBrume187 = lerpResult246;
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
				float localStochasticTiling171_g113 = ( 0.0 );
				float2 temp_cast_15 = (_T2_PaintGrunge_Tiling).xx;
				float2 texCoord1393 = IN.ase_texcoord4.xy * temp_cast_15 + float2( 0,0 );
				float2 Input_UV145_g113 = texCoord1393;
				float2 UV171_g113 = Input_UV145_g113;
				float2 UV1171_g113 = float2( 0,0 );
				float2 UV2171_g113 = float2( 0,0 );
				float2 UV3171_g113 = float2( 0,0 );
				float W1171_g113 = 0.0;
				float W2171_g113 = 0.0;
				float W3171_g113 = 0.0;
				StochasticTiling( UV171_g113 , UV1171_g113 , UV2171_g113 , UV3171_g113 , W1171_g113 , W2171_g113 , W3171_g113 );
				float Input_Index184_g113 = 4.0;
				float2 temp_output_172_0_g113 = ddx( Input_UV145_g113 );
				float2 temp_output_182_0_g113 = ddy( Input_UV145_g113 );
				float4 Output_2DArray294_g113 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV1171_g113,Input_Index184_g113, temp_output_172_0_g113, temp_output_182_0_g113 ) * W1171_g113 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV2171_g113,Input_Index184_g113, temp_output_172_0_g113, temp_output_182_0_g113 ) * W2171_g113 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV3171_g113,Input_Index184_g113, temp_output_172_0_g113, temp_output_182_0_g113 ) * W3171_g113 ) );
				float lerpResult1431 = lerp( 1.0 , ( CalculateContrast(_T2_PaintGrunge_Contrast,Output_2DArray294_g113) * _T2_PaintGrunge_Multiply ).r , _T2_PaintGrunge);
				float T2_Albedo_Tiling1378 = _T2_Albedo_Tiling;
				float2 temp_cast_16 = (T2_Albedo_Tiling1378).xx;
				float2 texCoord1392 = IN.ase_texcoord4.xy * temp_cast_16 + float2( 0,0 );
				float localStochasticTiling171_g106 = ( 0.0 );
				float2 Input_UV145_g106 = texCoord1392;
				float2 UV171_g106 = Input_UV145_g106;
				float2 UV1171_g106 = float2( 0,0 );
				float2 UV2171_g106 = float2( 0,0 );
				float2 UV3171_g106 = float2( 0,0 );
				float W1171_g106 = 0.0;
				float W2171_g106 = 0.0;
				float W3171_g106 = 0.0;
				StochasticTiling( UV171_g106 , UV1171_g106 , UV2171_g106 , UV3171_g106 , W1171_g106 , W2171_g106 , W3171_g106 );
				float Input_Index184_g106 = 0.0;
				float2 temp_output_172_0_g106 = ddx( Input_UV145_g106 );
				float2 temp_output_182_0_g106 = ddy( Input_UV145_g106 );
				float4 Output_2DArray294_g106 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV1171_g106,Input_Index184_g106, temp_output_172_0_g106, temp_output_182_0_g106 ) * W1171_g106 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV2171_g106,Input_Index184_g106, temp_output_172_0_g106, temp_output_182_0_g106 ) * W2171_g106 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV3171_g106,Input_Index184_g106, temp_output_172_0_g106, temp_output_182_0_g106 ) * W3171_g106 ) );
				float4 lerpResult1437 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_2_Textures, sampler_TA_2_Textures, texCoord1392,0.0 ) , Output_2DArray294_g106 , _T2_Albedo_ProceduralTiling);
				float4 temp_output_903_0 = ( _T2_ColorCorrection * lerpResult1437 );
				float grayscale905 = dot(temp_output_903_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_18 = (grayscale905).xxxx;
				float4 lerpResult886 = lerp( CalculateContrast(_T2_Albedo_Contrast,temp_output_903_0) , temp_cast_18 , GrayscaleDebug614);
				float4 blendOpSrc912 = ( lerpResult1427 * lerpResult1431 );
				float4 blendOpDest912 = lerpResult886;
				float4 T2_RGB816 = ( saturate( ( blendOpSrc912 * blendOpDest912 ) ));
				float2 texCoord876 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode859 = SAMPLE_TEXTURE2D_ARRAY( _TA_2_Textures, sampler_TA_2_Textures, texCoord876,2.0 );
				float T2_RimLightMask_Texture860 = tex2DArrayNode859.a;
				float4 T2_RimLight_Texture861 = tex2DArrayNode859;
				float4 lerpResult928 = lerp( _T2_CustomRimLight_Color , T2_RimLight_Texture861 , _T2_CutomRimLight_Texture);
				float4 T2_CustomRimLight826 = ( ( T2_RimLightMask_Texture860 * _T2_CustomRimLight_Opacity ) * lerpResult928 );
				float4 blendOpSrc808 = T2_RGB816;
				float4 blendOpDest808 = T2_CustomRimLight826;
				float4 lerpResult809 = lerp( T2_RGB816 , ( saturate( max( blendOpSrc808, blendOpDest808 ) )) , _T2_CustomRimLight);
				float4 T2_End_OutBrume839 = lerpResult809;
				float grayscale1478 = Luminance(T2_End_OutBrume839.rgb);
				float T2_End_InBrume1480 = grayscale1478;
				float4 temp_cast_20 = (T2_End_InBrume1480).xxxx;
				float4 lerpResult871 = lerp( T2_End_OutBrume839 , temp_cast_20 , Out_or_InBrume606);
				float4 Texture2_Final868 = lerpResult871;
				float4 DebugColor2477 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,0.0 );
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
				float localStochasticTiling171_g110 = ( 0.0 );
				float2 temp_cast_25 = (_T3_PaintGrunge_Tiling).xx;
				float2 texCoord1391 = IN.ase_texcoord4.xy * temp_cast_25 + float2( 0,0 );
				float2 Input_UV145_g110 = texCoord1391;
				float2 UV171_g110 = Input_UV145_g110;
				float2 UV1171_g110 = float2( 0,0 );
				float2 UV2171_g110 = float2( 0,0 );
				float2 UV3171_g110 = float2( 0,0 );
				float W1171_g110 = 0.0;
				float W2171_g110 = 0.0;
				float W3171_g110 = 0.0;
				StochasticTiling( UV171_g110 , UV1171_g110 , UV2171_g110 , UV3171_g110 , W1171_g110 , W2171_g110 , W3171_g110 );
				float Input_Index184_g110 = 4.0;
				float2 temp_output_172_0_g110 = ddx( Input_UV145_g110 );
				float2 temp_output_182_0_g110 = ddy( Input_UV145_g110 );
				float4 Output_2DArray294_g110 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV1171_g110,Input_Index184_g110, temp_output_172_0_g110, temp_output_182_0_g110 ) * W1171_g110 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV2171_g110,Input_Index184_g110, temp_output_172_0_g110, temp_output_182_0_g110 ) * W2171_g110 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV3171_g110,Input_Index184_g110, temp_output_172_0_g110, temp_output_182_0_g110 ) * W3171_g110 ) );
				float lerpResult1450 = lerp( 1.0 , ( CalculateContrast(_T3_PaintGrunge_Contrast,Output_2DArray294_g110) * _T3_PaintGrunge_Multiply ).r , _T3_PaintGrunge);
				float T3_Albedo_Tiling1377 = _T3_Albedo_Tiling;
				float2 temp_cast_26 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1390 = IN.ase_texcoord4.xy * temp_cast_26 + float2( 0,0 );
				float localStochasticTiling171_g111 = ( 0.0 );
				float2 Input_UV145_g111 = texCoord1390;
				float2 UV171_g111 = Input_UV145_g111;
				float2 UV1171_g111 = float2( 0,0 );
				float2 UV2171_g111 = float2( 0,0 );
				float2 UV3171_g111 = float2( 0,0 );
				float W1171_g111 = 0.0;
				float W2171_g111 = 0.0;
				float W3171_g111 = 0.0;
				StochasticTiling( UV171_g111 , UV1171_g111 , UV2171_g111 , UV3171_g111 , W1171_g111 , W2171_g111 , W3171_g111 );
				float Input_Index184_g111 = 0.0;
				float2 temp_output_172_0_g111 = ddx( Input_UV145_g111 );
				float2 temp_output_182_0_g111 = ddy( Input_UV145_g111 );
				float4 Output_2DArray294_g111 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV1171_g111,Input_Index184_g111, temp_output_172_0_g111, temp_output_182_0_g111 ) * W1171_g111 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV2171_g111,Input_Index184_g111, temp_output_172_0_g111, temp_output_182_0_g111 ) * W2171_g111 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV3171_g111,Input_Index184_g111, temp_output_172_0_g111, temp_output_182_0_g111 ) * W3171_g111 ) );
				float4 lerpResult1441 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_3_Textures, sampler_TA_3_Textures, texCoord1390,0.0 ) , Output_2DArray294_g111 , _T3_Albedo_ProceduralTiling);
				float4 temp_output_1094_0 = ( _T3_ColorCorrection * lerpResult1441 );
				float grayscale1113 = dot(temp_output_1094_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_28 = (grayscale1113).xxxx;
				float4 lerpResult1085 = lerp( temp_output_1094_0 , temp_cast_28 , GrayscaleDebug614);
				float4 blendOpSrc1107 = ( lerpResult1446 * lerpResult1450 );
				float4 blendOpDest1107 = lerpResult1085;
				float4 T3_RGB1187 = ( saturate( ( blendOpSrc1107 * blendOpDest1107 ) ));
				float2 texCoord1164 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode1184 = SAMPLE_TEXTURE2D_ARRAY( _TA_3_Textures, sampler_TA_3_Textures, texCoord1164,2.0 );
				float4 T3_RimLight_Texture1202 = tex2DArrayNode1184;
				float4 lerpResult1093 = lerp( _T3_CustomRimLight_Color , T3_RimLight_Texture1202 , _T3_CutomRimLight_Texture);
				float4 T3_CustomRimLight1183 = ( ( T2_RimLightMask_Texture860 * _T3_CustomRimLight_Opacity ) * lerpResult1093 );
				float4 blendOpSrc1245 = T3_RGB1187;
				float4 blendOpDest1245 = T3_CustomRimLight1183;
				float4 lerpResult1209 = lerp( T3_RGB1187 , ( saturate( max( blendOpSrc1245, blendOpDest1245 ) )) , _T3_CustomRimLight);
				float4 T3_End_OutBrume1119 = lerpResult1209;
				float grayscale1481 = Luminance(T3_End_OutBrume1119.rgb);
				float T3_End_InBrume1482 = grayscale1481;
				float4 temp_cast_30 = (T3_End_InBrume1482).xxxx;
				float4 lerpResult1196 = lerp( T3_End_OutBrume1119 , temp_cast_30 , Out_or_InBrume606);
				float4 Texture3_Final1214 = lerpResult1196;
				float4 DebugColor3478 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,0.0 );
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
				float localStochasticTiling171_g112 = ( 0.0 );
				float2 temp_cast_35 = (_T4_PaintGrunge_Tiling).xx;
				float2 texCoord1388 = IN.ase_texcoord4.xy * temp_cast_35 + float2( 0,0 );
				float2 Input_UV145_g112 = texCoord1388;
				float2 UV171_g112 = Input_UV145_g112;
				float2 UV1171_g112 = float2( 0,0 );
				float2 UV2171_g112 = float2( 0,0 );
				float2 UV3171_g112 = float2( 0,0 );
				float W1171_g112 = 0.0;
				float W2171_g112 = 0.0;
				float W3171_g112 = 0.0;
				StochasticTiling( UV171_g112 , UV1171_g112 , UV2171_g112 , UV3171_g112 , W1171_g112 , W2171_g112 , W3171_g112 );
				float Input_Index184_g112 = 4.0;
				float2 temp_output_172_0_g112 = ddx( Input_UV145_g112 );
				float2 temp_output_182_0_g112 = ddy( Input_UV145_g112 );
				float4 Output_2DArray294_g112 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV1171_g112,Input_Index184_g112, temp_output_172_0_g112, temp_output_182_0_g112 ) * W1171_g112 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV2171_g112,Input_Index184_g112, temp_output_172_0_g112, temp_output_182_0_g112 ) * W2171_g112 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV3171_g112,Input_Index184_g112, temp_output_172_0_g112, temp_output_182_0_g112 ) * W3171_g112 ) );
				float lerpResult1455 = lerp( 1.0 , ( CalculateContrast(_T4_PaintGrunge_Contrast,Output_2DArray294_g112) * _T4_PaintGrunge_Multiply ).r , _T4_PaintGrunge);
				float T4_Albedo_Tiling1376 = _T4_Albedo_Tiling;
				float2 temp_cast_36 = (T4_Albedo_Tiling1376).xx;
				float2 texCoord1389 = IN.ase_texcoord4.xy * temp_cast_36 + float2( 0,0 );
				float localStochasticTiling171_g107 = ( 0.0 );
				float2 Input_UV145_g107 = texCoord1389;
				float2 UV171_g107 = Input_UV145_g107;
				float2 UV1171_g107 = float2( 0,0 );
				float2 UV2171_g107 = float2( 0,0 );
				float2 UV3171_g107 = float2( 0,0 );
				float W1171_g107 = 0.0;
				float W2171_g107 = 0.0;
				float W3171_g107 = 0.0;
				StochasticTiling( UV171_g107 , UV1171_g107 , UV2171_g107 , UV3171_g107 , W1171_g107 , W2171_g107 , W3171_g107 );
				float Input_Index184_g107 = 0.0;
				float2 temp_output_172_0_g107 = ddx( Input_UV145_g107 );
				float2 temp_output_182_0_g107 = ddy( Input_UV145_g107 );
				float4 Output_2DArray294_g107 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV1171_g107,Input_Index184_g107, temp_output_172_0_g107, temp_output_182_0_g107 ) * W1171_g107 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV2171_g107,Input_Index184_g107, temp_output_172_0_g107, temp_output_182_0_g107 ) * W2171_g107 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV3171_g107,Input_Index184_g107, temp_output_172_0_g107, temp_output_182_0_g107 ) * W3171_g107 ) );
				float4 lerpResult1444 = lerp( SAMPLE_TEXTURE2D_ARRAY( _TA_4_Textures, sampler_TA_4_Textures, texCoord1389,0.0 ) , Output_2DArray294_g107 , _T4_Albedo_ProceduralTiling);
				float4 temp_output_1079_0 = ( _T4_ColorCorrection * lerpResult1444 );
				float grayscale1051 = dot(temp_output_1079_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_38 = (grayscale1051).xxxx;
				float4 lerpResult1074 = lerp( temp_output_1079_0 , temp_cast_38 , GrayscaleDebug614);
				float4 blendOpSrc1064 = ( lerpResult1453 * lerpResult1455 );
				float4 blendOpDest1064 = lerpResult1074;
				float4 T4_RGB1122 = ( saturate( ( blendOpSrc1064 * blendOpDest1064 ) ));
				float2 texCoord1057 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode1142 = SAMPLE_TEXTURE2D_ARRAY( _TA_4_Textures, sampler_TA_4_Textures, texCoord1057,2.0 );
				float T4_RimLightMask_Texture1102 = tex2DArrayNode1142.a;
				float4 T4_RimLight_Texture1101 = tex2DArrayNode1142;
				float4 lerpResult1147 = lerp( _T4_CustomRimLight_Color , T4_RimLight_Texture1101 , _T4_CutomRimLight_Texture);
				float4 T4_CustomRimLight1131 = ( ( T4_RimLightMask_Texture1102 * _T4_CustomRimLight_Opacity ) * lerpResult1147 );
				float4 blendOpSrc1055 = T4_RGB1122;
				float4 blendOpDest1055 = T4_CustomRimLight1131;
				float4 lerpResult1053 = lerp( T4_RGB1122 , ( saturate( max( blendOpSrc1055, blendOpDest1055 ) )) , _T4_CustomRimLight);
				float4 T4_End_OutBrume1120 = lerpResult1053;
				float grayscale1484 = Luminance(T4_End_OutBrume1120.rgb);
				float T4_End_InBrume1485 = grayscale1484;
				float4 temp_cast_40 = (T4_End_InBrume1485).xxxx;
				float4 lerpResult1050 = lerp( T4_End_OutBrume1120 , temp_cast_40 , Out_or_InBrume606);
				float4 Texture4_Final1364 = lerpResult1050;
				float4 DebugColor4479 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,0.0 );
				float4 lerpResult580 = lerp( Texture4_Final1364 , DebugColor4479 , DebugVertexPaint566);
				float4 lerpResult495 = lerp( lerpResult14 , lerpResult580 , tex2DNode1472.b);
				float4 AllAlbedo622 = lerpResult495;
				float temp_output_420_0 = ( _StepShadow + _StepAttenuation );
				float localStochasticTiling171_g116 = ( 0.0 );
				float2 temp_cast_41 = (T1_Albedo_Tiling1379).xx;
				float2 texCoord1386 = IN.ase_texcoord4.xy * temp_cast_41 + float2( 0,0 );
				float2 Input_UV145_g116 = texCoord1386;
				float2 UV171_g116 = Input_UV145_g116;
				float2 UV1171_g116 = float2( 0,0 );
				float2 UV2171_g116 = float2( 0,0 );
				float2 UV3171_g116 = float2( 0,0 );
				float W1171_g116 = 0.0;
				float W2171_g116 = 0.0;
				float W3171_g116 = 0.0;
				StochasticTiling( UV171_g116 , UV1171_g116 , UV2171_g116 , UV3171_g116 , W1171_g116 , W2171_g116 , W3171_g116 );
				float Input_Index184_g116 = 1.0;
				float2 temp_output_172_0_g116 = ddx( Input_UV145_g116 );
				float2 temp_output_182_0_g116 = ddy( Input_UV145_g116 );
				float4 Output_2DArray294_g116 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV1171_g116,Input_Index184_g116, temp_output_172_0_g116, temp_output_182_0_g116 ) * W1171_g116 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV2171_g116,Input_Index184_g116, temp_output_172_0_g116, temp_output_182_0_g116 ) * W2171_g116 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV3171_g116,Input_Index184_g116, temp_output_172_0_g116, temp_output_182_0_g116 ) * W3171_g116 ) );
				float4 T1_Normal_Texture139 = Output_2DArray294_g116;
				float localStochasticTiling171_g114 = ( 0.0 );
				float2 temp_cast_42 = (T2_Albedo_Tiling1378).xx;
				float2 texCoord1398 = IN.ase_texcoord4.xy * temp_cast_42 + float2( 0,0 );
				float2 Input_UV145_g114 = texCoord1398;
				float2 UV171_g114 = Input_UV145_g114;
				float2 UV1171_g114 = float2( 0,0 );
				float2 UV2171_g114 = float2( 0,0 );
				float2 UV3171_g114 = float2( 0,0 );
				float W1171_g114 = 0.0;
				float W2171_g114 = 0.0;
				float W3171_g114 = 0.0;
				StochasticTiling( UV171_g114 , UV1171_g114 , UV2171_g114 , UV3171_g114 , W1171_g114 , W2171_g114 , W3171_g114 );
				float Input_Index184_g114 = 1.0;
				float2 temp_output_172_0_g114 = ddx( Input_UV145_g114 );
				float2 temp_output_182_0_g114 = ddy( Input_UV145_g114 );
				float4 Output_2DArray294_g114 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV1171_g114,Input_Index184_g114, temp_output_172_0_g114, temp_output_182_0_g114 ) * W1171_g114 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV2171_g114,Input_Index184_g114, temp_output_172_0_g114, temp_output_182_0_g114 ) * W2171_g114 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV3171_g114,Input_Index184_g114, temp_output_172_0_g114, temp_output_182_0_g114 ) * W3171_g114 ) );
				float4 T2_Normal_Texture1396 = Output_2DArray294_g114;
				float4 tex2DNode1473 = tex2D( _TerrainMaskTexture, uv_TerrainMaskTexture );
				float4 lerpResult632 = lerp( T1_Normal_Texture139 , T2_Normal_Texture1396 , tex2DNode1473.r);
				float localStochasticTiling171_g115 = ( 0.0 );
				float2 temp_cast_43 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1404 = IN.ase_texcoord4.xy * temp_cast_43 + float2( 0,0 );
				float2 Input_UV145_g115 = texCoord1404;
				float2 UV171_g115 = Input_UV145_g115;
				float2 UV1171_g115 = float2( 0,0 );
				float2 UV2171_g115 = float2( 0,0 );
				float2 UV3171_g115 = float2( 0,0 );
				float W1171_g115 = 0.0;
				float W2171_g115 = 0.0;
				float W3171_g115 = 0.0;
				StochasticTiling( UV171_g115 , UV1171_g115 , UV2171_g115 , UV3171_g115 , W1171_g115 , W2171_g115 , W3171_g115 );
				float Input_Index184_g115 = 1.0;
				float2 temp_output_172_0_g115 = ddx( Input_UV145_g115 );
				float2 temp_output_182_0_g115 = ddy( Input_UV145_g115 );
				float4 Output_2DArray294_g115 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV1171_g115,Input_Index184_g115, temp_output_172_0_g115, temp_output_182_0_g115 ) * W1171_g115 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV2171_g115,Input_Index184_g115, temp_output_172_0_g115, temp_output_182_0_g115 ) * W2171_g115 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV3171_g115,Input_Index184_g115, temp_output_172_0_g115, temp_output_182_0_g115 ) * W3171_g115 ) );
				float4 T3_Normal_Texture1402 = Output_2DArray294_g115;
				float4 lerpResult635 = lerp( lerpResult632 , T3_Normal_Texture1402 , tex2DNode1473.g);
				float localStochasticTiling171_g117 = ( 0.0 );
				float2 temp_cast_44 = (T3_Albedo_Tiling1377).xx;
				float2 texCoord1410 = IN.ase_texcoord4.xy * temp_cast_44 + float2( 0,0 );
				float2 Input_UV145_g117 = texCoord1410;
				float2 UV171_g117 = Input_UV145_g117;
				float2 UV1171_g117 = float2( 0,0 );
				float2 UV2171_g117 = float2( 0,0 );
				float2 UV3171_g117 = float2( 0,0 );
				float W1171_g117 = 0.0;
				float W2171_g117 = 0.0;
				float W3171_g117 = 0.0;
				StochasticTiling( UV171_g117 , UV1171_g117 , UV2171_g117 , UV3171_g117 , W1171_g117 , W2171_g117 , W3171_g117 );
				float Input_Index184_g117 = 1.0;
				float2 temp_output_172_0_g117 = ddx( Input_UV145_g117 );
				float2 temp_output_182_0_g117 = ddy( Input_UV145_g117 );
				float4 Output_2DArray294_g117 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV1171_g117,Input_Index184_g117, temp_output_172_0_g117, temp_output_182_0_g117 ) * W1171_g117 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV2171_g117,Input_Index184_g117, temp_output_172_0_g117, temp_output_182_0_g117 ) * W2171_g117 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV3171_g117,Input_Index184_g117, temp_output_172_0_g117, temp_output_182_0_g117 ) * W3171_g117 ) );
				float4 T4_Normal_Texture1408 = Output_2DArray294_g117;
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
				float4 temp_cast_49 = (normal_LightDir140).xxxx;
				float LightDebug608 = _LightDebug;
				float4 lerpResult282 = lerp( ( AllAlbedo622 * lerpResult1010 ) , temp_cast_49 , LightDebug608);
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
			float4 _T1_CustomRimLight_Color;
			float4 _T4_CustomRimLight_Color;
			float4 _T1_ColorCorrection;
			float4 _T3_CustomRimLight_Color;
			float4 _T2_CustomRimLight_Color;
			float4 _TerrainMaskTexture_ST;
			float4 _EdgeShadowColor;
			float4 _ShadowColor;
			float4 _T3_ColorCorrection;
			float2 _ShadowNoisePanner;
			float _T3_CustomRimLight_Opacity;
			float _T3_CustomRimLight;
			float _T3_Albedo_ProceduralTiling;
			float _T3_Albedo_Tiling;
			float _T3_CutomRimLight_Texture;
			float _T1_AnimatedGrunge_Contrast;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Multiply;
			float _T3_PaintGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_IsGrungeAnimated;
			float _T3_PaintGrunge;
			float _T4_AnimatedGrunge_Tiling;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _StepAttenuation;
			float _StepShadow;
			float _T4_CustomRimLight;
			float _T4_CutomRimLight_Texture;
			float _T4_CustomRimLight_Opacity;
			float _T4_Albedo_ProceduralTiling;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_Albedo_Tiling;
			float _T4_PaintGrunge_Multiply;
			float _T4_PaintGrunge_Tiling;
			float _T4_PaintGrunge_Contrast;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_PaintGrunge;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_ScreenBased;
			float _Out_or_InBrume;
			float _T1_CustomRimLight;
			float _T1_CustomRimLight_Texture;
			float _T1_CustomRimLight_Opacity;
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
			float _DebugTextureTiling;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _DebugVertexPaint;
			float _T2_AnimatedGrunge_Tiling;
			float _LightDebug;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_CustomRimLight;
			float _T2_CutomRimLight_Texture;
			float _T2_CustomRimLight_Opacity;
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
			float _T2_AnimatedGrunge_ScreenBased;
			float _T2_AnimatedGrunge_Contrast;
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
			float4 _T1_CustomRimLight_Color;
			float4 _T4_CustomRimLight_Color;
			float4 _T1_ColorCorrection;
			float4 _T3_CustomRimLight_Color;
			float4 _T2_CustomRimLight_Color;
			float4 _TerrainMaskTexture_ST;
			float4 _EdgeShadowColor;
			float4 _ShadowColor;
			float4 _T3_ColorCorrection;
			float2 _ShadowNoisePanner;
			float _T3_CustomRimLight_Opacity;
			float _T3_CustomRimLight;
			float _T3_Albedo_ProceduralTiling;
			float _T3_Albedo_Tiling;
			float _T3_CutomRimLight_Texture;
			float _T1_AnimatedGrunge_Contrast;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Multiply;
			float _T3_PaintGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_IsGrungeAnimated;
			float _T3_PaintGrunge;
			float _T4_AnimatedGrunge_Tiling;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _StepAttenuation;
			float _StepShadow;
			float _T4_CustomRimLight;
			float _T4_CutomRimLight_Texture;
			float _T4_CustomRimLight_Opacity;
			float _T4_Albedo_ProceduralTiling;
			float _T4_AnimatedGrunge_ScreenBased;
			float _T4_Albedo_Tiling;
			float _T4_PaintGrunge_Multiply;
			float _T4_PaintGrunge_Tiling;
			float _T4_PaintGrunge_Contrast;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_IsGrungeAnimated;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_PaintGrunge;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Tiling;
			float _T3_AnimatedGrunge_ScreenBased;
			float _Out_or_InBrume;
			float _T1_CustomRimLight;
			float _T1_CustomRimLight_Texture;
			float _T1_CustomRimLight_Opacity;
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
			float _DebugTextureTiling;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _DebugVertexPaint;
			float _T2_AnimatedGrunge_Tiling;
			float _LightDebug;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_CustomRimLight;
			float _T2_CutomRimLight_Texture;
			float _T2_CustomRimLight_Opacity;
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
			float _T2_AnimatedGrunge_ScreenBased;
			float _T2_AnimatedGrunge_Contrast;
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
1920;0;1920;1019;6083.392;8809.111;4.603228;True;False
Node;AmplifyShaderEditor.CommentaryNode;1373;-4659.422,-7051.386;Inherit;False;9826.477;4618.679;OTHER VARIABLES;19;604;28;30;588;587;699;39;1493;1496;1498;1500;1499;1501;1502;1503;1508;1509;1510;1511;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;746;-15559.13,-7072.62;Inherit;False;10769.91;2740.058;TEXTURE 1;6;42;740;749;1475;1476;1477;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;750;-15558.96,-4297.144;Inherit;False;10769.91;2740.058;TEXTURE 2;6;760;753;752;1480;1479;1478;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1014;-15557.25,1271.575;Inherit;False;10769.91;2740.058;TEXTURE 4;5;1029;1019;1018;1486;1485;;0,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1013;-15557.42,-1503.901;Inherit;False;10769.91;2740.058;TEXTURE 3;6;1044;1017;1016;1481;1482;1483;;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1019;-15476.42,1439.663;Inherit;False;1279.631;1658.024;Texture Arrays 4;2;1027;1025;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;740;-15478.3,-6904.532;Inherit;False;1279.631;1658.024;Texture Arrays 1;2;27;736;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1016;-15476.59,-1335.813;Inherit;False;1279.631;1658.024;Texture Arrays 3;2;1034;1022;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1017;-14119.95,-1453.901;Inherit;False;3990.135;2631.681;Paper + Object Texture;8;1187;1108;1107;1039;1037;1032;1031;1028;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;752;-15478.13,-4129.056;Inherit;False;1279.631;1658.024;Texture Arrays 2;2;763;757;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1018;-14119.78,1321.575;Inherit;False;3990.135;2631.681;Paper + Object Texture;8;1122;1065;1064;1030;1026;1024;1023;1021;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-4609.422,-7001.386;Inherit;False;5639.813;1022.403;Shadow Smooth Edge + Int Shadow;27;1521;420;356;428;431;422;427;426;430;435;425;408;421;432;429;424;416;406;43;1538;1539;1540;1541;1543;1544;1545;1546;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;753;-14121.49,-4247.144;Inherit;False;3990.135;2631.681;Paper + Object Texture;8;912;911;816;765;764;762;759;756;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-14121.66,-7022.62;Inherit;False;3990.135;2631.681;Paper + Object Texture;8;202;184;190;32;718;616;715;730;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1027;-15426.11,1489.664;Inherit;False;1178.062;699.5752;Textures;12;1146;1145;1144;1143;1142;1132;1102;1101;1068;1057;1054;1047;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1028;-14058,-666.1687;Inherit;False;2622.859;593.3951;Paint Grunge;13;1197;1114;1106;1099;1391;1169;1105;1088;1170;1149;1448;1449;1450;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-11252.16,-6949.366;Inherit;False;1038.211;719.015;CustomRimLight;9;385;410;332;397;602;600;262;395;601;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;763;-15428.13,-3357.357;Inherit;False;1179.63;861.0986;Grunges;15;880;879;878;877;875;874;873;867;856;853;852;851;850;849;846;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-15427.99,-6854.532;Inherit;False;1178.062;699.5752;Textures;12;50;172;71;241;74;177;708;706;171;265;599;133;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;762;-14079.56,-2157.691;Inherit;False;1313.751;503.8408;FinalPass;6;844;839;809;808;807;806;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;759;-11251.99,-4173.89;Inherit;False;1038.211;719.015;CustomRimLight;9;928;926;826;815;814;813;812;811;810;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1023;-14057.83,2109.309;Inherit;False;2624.655;602.9019;Paint Grunge;13;1388;1133;1056;1062;1213;1166;1135;1076;1171;1063;1454;1455;1456;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;587;-3259.282,-5238.938;Inherit;False;2067.298;1155.405;Texture Set by Vertex Color;27;622;1;489;573;576;495;580;581;583;584;14;579;578;11;569;571;574;570;565;577;567;586;585;3;4;5;1472;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1022;-15426.59,-564.1155;Inherit;False;1179.63;861.0986;Grunges;15;1371;1369;1241;1215;1205;1194;1193;1192;1190;1182;1180;1179;1163;1136;1091;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;736;-15428.3,-6132.834;Inherit;False;1179.63;861.0986;Grunges;15;733;714;702;268;700;737;701;735;732;734;731;713;712;738;739;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;718;-14063.46,-6937.651;Inherit;False;2635.696;674.9272;Animated Grunge;24;318;224;717;716;403;381;156;146;127;132;130;175;150;163;167;179;158;208;1422;1423;1424;1463;1464;1465;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;756;-14063.29,-4162.174;Inherit;False;2635.696;674.9272;Animated Grunge;24;919;918;917;910;909;908;907;891;890;885;884;882;854;841;822;821;820;819;1428;1429;1427;1460;1461;1462;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1025;-15426.42,2211.362;Inherit;False;1179.63;861.0986;Grunges;15;1372;1366;1148;1140;1139;1138;1137;1115;1111;1098;1077;1070;1059;1058;1052;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1029;-15272.32,3257.659;Inherit;False;863.1523;325.855;Texture4_Final;5;1367;1364;1118;1050;1049;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1024;-14061.6,3407.54;Inherit;False;1313.751;503.8408;FinalPass;6;1121;1120;1116;1055;1053;1048;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1031;-11250.45,-1380.647;Inherit;False;1038.211;719.015;CustomRimLight;9;1210;1208;1189;1188;1183;1167;1153;1095;1093;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;715;-14059.71,-6234.887;Inherit;False;2540.175;589.6089;Paint Grunge;13;377;297;258;710;336;1394;285;253;135;711;1419;1420;1421;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1034;-15426.28,-1285.813;Inherit;False;1178.062;699.5752;Textures;12;1368;1363;1362;1207;1206;1204;1203;1202;1184;1178;1164;1090;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1026;-14061.56,2738.738;Inherit;False;2619.777;630.8765;Albedo;14;1376;1125;1134;1389;1103;1051;1083;1072;1175;1079;1074;1442;1443;1444;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;764;-14063.27,-2829.981;Inherit;False;2632.267;626.7134;Albedo;16;1392;1378;905;906;825;888;889;886;923;920;903;1436;1437;1438;1459;1458;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;699;-623.0894,-5920.902;Inherit;False;1409.08;2439.218;All Normal by Vertex Color;35;692;691;690;642;632;635;693;644;694;640;1408;1402;1396;1416;1415;1414;1413;1412;1406;1400;1411;1410;1409;1405;1404;1403;1399;1398;1397;1380;1382;1386;1383;139;1473;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1039;-14061.77,623.7369;Inherit;False;1313.751;503.8408;FinalPass;6;1245;1211;1209;1200;1181;1119;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;757;-15427.82,-4079.055;Inherit;False;1178.062;699.5752;Textures;12;881;876;866;865;864;863;861;860;859;858;857;855;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1032;-14061.73,-36.73938;Inherit;False;2623.941;630.8765;Albedo;14;1124;1390;1377;1128;1126;1113;1092;1094;1185;1085;1084;1439;1440;1441;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1044;-15272.49,482.1825;Inherit;False;863.1523;325.855;Texture3_Final;5;1214;1199;1198;1196;1195;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1030;-14061.58,1406.545;Inherit;False;2635.696;674.9272;Animated Grunge;24;1173;1162;1159;1158;1157;1155;1150;1141;1129;1097;1078;1075;1069;1067;1066;1061;1060;1046;1451;1452;1453;1469;1470;1471;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-4602.845,-5904.483;Inherit;False;3145.105;593.8924;Noise;18;159;365;162;386;180;218;363;197;170;128;142;176;359;362;157;168;703;741;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;588;-4598.669,-5236.005;Inherit;False;1281.268;1101.646;Debug Textures;14;590;479;478;477;488;563;559;592;593;594;595;596;597;598;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-4539.759,-6726.153;Inherit;False;1385.351;464.59;Normal Light Dir;7;140;169;413;414;411;358;412;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;730;-14071.01,-4938.403;Inherit;False;1313.751;503.8408;FinalPass;6;405;409;301;415;187;246;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-3050.692,-3874.95;Inherit;False;1708.676;476.5241;Final Mix;14;698;2;705;704;286;282;294;609;611;280;1010;1012;1497;1512;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;749;-15274.2,-5086.536;Inherit;False;863.1523;325.855;Texture1_Final;5;748;274;349;340;607;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;765;-14059.54,-3459.41;Inherit;False;2624.556;601.4268;Paint Grunge;13;817;916;883;818;1393;913;915;823;921;914;1430;1431;1432;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;616;-14063.44,-5605.458;Inherit;False;2537.716;636.7236;Albedo;14;191;709;621;335;1385;1379;252;615;399;617;619;1433;1434;1435;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;760;-15274.03,-2311.059;Inherit;False;863.1523;325.855;Texture2_Final;5;872;871;870;869;868;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1037;-14061.75,-1368.932;Inherit;False;2635.696;674.9272;Animated Grunge;24;1191;1186;1161;1160;1156;1154;1152;1130;1112;1110;1109;1104;1089;1087;1086;1082;1081;1080;1445;1446;1447;1467;1468;1466;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1021;-11250.28,1394.829;Inherit;False;1038.211;719.015;CustomRimLight;9;1172;1168;1165;1151;1147;1131;1127;1123;1045;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;604;-1360.032,-5906.679;Inherit;False;671.5669;606.8997;Global Variables;10;566;564;605;423;606;614;608;613;281;610;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-15344.01,-6433.208;Inherit;False;Constant;_Float53;Float 53;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;408;-1683.48,-6937.386;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1450;-11662.96,-442.2463;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;565;-2962.08,-5132.168;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;732;-14560.41,-5669.246;Inherit;False;T1_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1087;-12702.15,-1322.17;Inherit;True;Property;_TextureSample53;Texture Sample 53;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1047;-15341.13,1987.988;Inherit;False;Constant;_Float11;Float 11;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1416;-351.237,-4569.696;Inherit;False;1377;T3_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;903;-12463.84,-2757.215;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;-2234.999,-4590.234;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;914;-12228.43,-3248.752;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;741;-4512.905,-5586.063;Inherit;True;Property;_InBrumeDrippingNoise;InBrumeDrippingNoise;20;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;690;-566.9257,-4239.124;Inherit;True;1396;T2_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;714;-15308.27,-5502.657;Inherit;False;Constant;_Float20;Float 20;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;403;-12370.8,-6889.003;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-13684.41,-6450.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Speed;T1_AnimatedGrunge_Flipbook_Speed;36;0;Create;True;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;841;-13324.09,-4012.472;Inherit;False;Property;_T2_IsGrungeAnimated;T2_IsGrungeAnimated?;54;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1132;-14520.26,1570.752;Inherit;False;T4_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1059;-15306.39,2841.539;Inherit;False;Constant;_Float14;Float 14;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1075;-12875,1612.47;Inherit;False;Constant;_Float28;Float 28;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1409;181.8724,-4786.893;Inherit;True;Procedural Sample;-1;;117;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1127;-10817.22,1489.606;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;241;-15343.01,-6280.208;Inherit;False;Constant;_Float69;Float 69;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1188;-11127.84,-1324.915;Inherit;True;860;T2_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1057;-15371.51,1770.992;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1386;-95.34624,-5623.687;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;386;-2510.501,-5776.482;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;-14533.49,-726.2073;Inherit;False;T3_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;479;-3544.354,-4372.308;Inherit;True;DebugColor4;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1101;-14532.18,1952.334;Inherit;False;T4_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1363;-15377.53,-1210.626;Inherit;True;Property;_TA_3_Textures;TA_3_Textures;66;0;Create;True;0;0;False;1;Header(Texture 3 VertexPaintGreen);False;ef1e633c4c2c51641bd59a932b55b28a;0556bc6f8449b5645a36bdb589f4767d;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;597;-4208.631,-4650.591;Inherit;False;Constant;_Float2;Float 2;69;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;488;-3544.653,-5094.258;Inherit;True;DebugColor1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1210;-10599.69,-1114.51;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;218;-2307.742,-5806.355;Inherit;True;Property;_TextureSample60;Texture Sample 60;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;703;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;822;-13940.24,-3746.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Columns;T2_AnimatedGrunge_Flipbook_Columns;57;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-14522.14,-6773.444;Inherit;False;T1_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;613;-1270.865,-5517.98;Inherit;False;Property;_GrayscaleDebug;GrayscaleDebug;4;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;733;-15306.16,-5426.742;Inherit;False;Constant;_Float21;Float 21;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1102;-14533.32,2049.271;Inherit;False;T4_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1161;-13322.55,-1219.23;Inherit;False;Property;_T3_IsGrungeAnimated;T3_IsGrungeAnimated?;76;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;424;-1907.472,-6937.386;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;609;-2487.465,-3489.921;Inherit;False;608;LightDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1448;-11836.78,-521.4954;Inherit;False;Constant;_Float43;Float 43;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1388;-13726.67,2538.164;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;168;-3517.352,-5510.816;Inherit;False;Property;_ScreenBasedShadowNoise;ScreenBasedShadowNoise?;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;596;-4209.631,-4731.591;Inherit;False;Constant;_Float1;Float 1;69;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1179;-15304.45,141.9764;Inherit;False;Constant;_Float38;Float 38;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1382;-189.7652,-5737.083;Inherit;False;Constant;_Float5;Float 5;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;573;-3208.871,-5188.938;Inherit;False;748;Texture1_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1164;-15371.68,-1004.485;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;191;-11706.52,-5543.248;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1084;-13750.04,99.56036;Inherit;False;Constant;_Float7;Float 7;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;416;-2227.47,-6505.385;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1371;-14558.7,-100.5275;Inherit;False;T3_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-13324.26,-6787.949;Inherit;False;Property;_T1_IsGrungeAnimated;T1_IsGrungeAnimated?;31;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1464;-14018.6,-6591.532;Inherit;False;Property;_T1_AnimatedGrunge_ScreenBased;T1_AnimatedGrunge_ScreenBased?;32;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1405;-192.6832,-5044.062;Inherit;False;Constant;_Float17;Float 17;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1404;-98.26397,-4930.666;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;282;-2223.19,-3793.365;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1153;-11131.39,-1133.872;Inherit;False;Property;_T3_CustomRimLight_Opacity;T3_CustomRimLight_Opacity;87;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;406;-1987.471,-6425.385;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1203;-14917.64,-1015.232;Inherit;True;Property;_TextureSample33;Texture Sample 33;97;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1362;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;592;-3952.372,-4804.56;Inherit;True;Property;_TextureSample24;Texture Sample 24;6;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1372;-14558.53,2674.949;Inherit;False;T4_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;716;-12139.45,-6885.18;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1121;-14014.74,3470.737;Inherit;True;1122;T4_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1107;-10902.08,-0.599247;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;179;-13308.4,-6621.055;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;208;-13545.41,-6352.575;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;858;-14919.18,-3808.473;Inherit;True;Property;_TextureSample44;Texture Sample 44;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;865;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1197;-14013.08,-594.1707;Inherit;True;1194;TA_3_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1169;-13966,-162.2892;Inherit;False;Property;_T3_PaintGrunge_Tiling;T3_PaintGrunge_Tiling;72;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;817;-12803.49,-3132.252;Inherit;False;Property;_T2_PaintGrunge_Multiply;T2_PaintGrunge_Multiply;52;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1012;-2965.274,-3498.695;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1126;-12499.33,170.0253;Inherit;False;Property;_T3_ColorCorrection;T3_ColorCorrection;68;0;Create;True;0;0;False;0;False;1,1,1,0;0.8867924,0.8867924,0.8867924,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1486;-9674.87,2247.757;Inherit;False;1120;T4_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;362;-2782.502,-5776.482;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;738;-15119.17,-6061.779;Inherit;False;TA_1_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.BlendOpsNode;190;-10903.79,-5569.318;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;365;-1972.501,-5564.482;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1050;-14942.74,3316.909;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;576;-2433.678,-4567.418;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1167;-11185.25,-756.4875;Inherit;False;Property;_T3_CutomRimLight_Texture;T3_CutomRimLight_Texture?;85;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;-2106.794,-3640.857;Inherit;False;644;AllNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1055;-13707.91,3573.054;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;-2726.867,-4873.242;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1202;-14532.35,-823.1442;Inherit;False;T3_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;358;-3945.75,-6366.965;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1189;-11153.25,-836.4885;Inherit;False;1202;T3_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;735;-14556.4,-5477.425;Inherit;False;T1_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1133;-13966.9,2378.342;Inherit;False;Constant;_Float35;Float 35;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;577;-2677.866,-4475.199;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;702;-15309.27,-5577.212;Inherit;False;Constant;_Float18;Float 18;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1182;-14901.53,92.21172;Inherit;True;Property;_TextureSample52;Texture Sample 52;98;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;559;-3954.713,-5027.561;Inherit;True;Property;_DebugTextureArray;DebugTextureArray;6;0;Create;True;0;0;False;0;False;-1;fcf4482ca7d817c42b6d03968194b044;fcf4482ca7d817c42b6d03968194b044;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1215;-14525.22,-293.0524;Inherit;False;T3_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;-15209.82,-4951.33;Inherit;False;1477;T1_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;601;-10811.39,-6504.257;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;466.1629,-5821.634;Inherit;False;T1_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;599;-14534.06,-6391.863;Inherit;False;T1_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1471;-13505.5,1485.138;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1207;-15341.3,-711.4895;Inherit;False;Constant;_Float41;Float 41;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;385;-11133.1,-6702.591;Inherit;False;Property;_T1_CustomRimLight_Opacity;T1_CustomRimLight_Opacity;42;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1444;-12790.47,2793.938;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1157;-13682.53,1893.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Speed;T4_AnimatedGrunge_Flipbook_Speed;103;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;808;-13725.87,-1992.176;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;580;-1942.275,-4306.486;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-1684.501,-5565.482;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;-2512.706,-3569.662;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;594;-3950.372,-4350.56;Inherit;True;Property;_TextureSample26;Texture Sample 26;6;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;644;561.4186,-3807.901;Inherit;False;AllNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1090;-15134.69,-1209.335;Inherit;False;TA_3_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;1453;-11633.5,1867.005;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1408;465.2108,-4786.687;Inherit;False;T4_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;705;-2459.095,-3793.968;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1193;-15356.57,-494.2053;Inherit;True;Property;_TA_3_Grunges;TA_3_Grunges;67;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;b33b36e28008b23459206c358b00d02a;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;1168;-11163.08,1762.989;Inherit;False;Property;_T4_CustomRimLight_Color;T4_CustomRimLight_Color;108;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;610;-966.8767,-5622.498;Inherit;False;NormalDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;262;-11129.55,-6893.634;Inherit;True;265;T1_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1204;-15342.3,-864.4894;Inherit;False;Constant;_Float39;Float 39;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1214;-14628.34,536.1824;Inherit;False;Texture3_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1196;-14942.91,541.4324;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1095;-10817.39,-1285.871;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;414;-3961.749,-6638.963;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1458;-12392.42,-2509.62;Inherit;False;Property;_T2_Albedo_Contrast;T2_Albedo_Contrast;46;0;Create;True;0;0;False;0;False;0;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1438;-13076.64,-2658.16;Inherit;False;Property;_T2_Albedo_ProceduralTiling;T2_Albedo_ProceduralTiling?;47;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-3740.31,-5580.228;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;495;-1695.501,-4330.307;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1410;-96.29839,-4588.74;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;810;-11132.93,-3927.114;Inherit;False;Property;_T2_CustomRimLight_Opacity;T2_CustomRimLight_Opacity;65;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1143;-14915.91,1567.139;Inherit;True;Property;_TA_4_Textures_Sample;TA_4_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;578;-2680.882,-4549.047;Inherit;False;478;DebugColor3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;564;-1279.365,-5420.153;Inherit;False;Property;_DebugVertexPaint;DebugVertexPaint;5;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1171;-13349.85,2350.068;Inherit;False;Property;_T4_PaintGrunge_Contrast;T4_PaintGrunge_Contrast;95;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;691;-266.0599,-4004.133;Inherit;True;1402;T3_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1163;-15306.56,66.06134;Inherit;False;Constant;_Float37;Float 37;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;712;-14905.61,-5861.229;Inherit;True;Property;_TextureSample36;Texture Sample 36;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1540;-856.0298,-6565.738;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1198;-15217.49,536.9885;Inherit;False;1119;T3_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1165;-11185.08,2018.99;Inherit;False;Property;_T4_CutomRimLight_Texture;T4_CutomRimLight_Texture?;107;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1205;-14531.95,-490.5714;Inherit;False;T3_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1194;-15117.46,-493.0602;Inherit;False;TA_3_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;816;-10586.06,-2792.985;Inherit;False;T2_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;430;-2387.47,-6937.386;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;429;-1404.374,-6783.921;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1468;-13484.83,-1287.348;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1067;-14020.48,1657.869;Inherit;False;Property;_T4_AnimatedGrunge_Tiling;T4_AnimatedGrunge_Tiling;100;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;923;-12753.84,-2623.216;Inherit;False;Property;_T2_ColorCorrection;T2_ColorCorrection;45;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1142;-14916.86,1952.997;Inherit;True;Property;_TextureSample46;Texture Sample 46;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1143;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1097;-12380.92,1454.193;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1144;-14917.47,1760.246;Inherit;True;Property;_TextureSample47;Texture Sample 47;94;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1143;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1396;464.8768,-5476.811;Inherit;False;T2_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-14019.36,-6680.327;Inherit;False;Property;_T1_AnimatedGrunge_Tiling;T1_AnimatedGrunge_Tiling;33;0;Create;True;0;0;False;0;False;1;32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1480;-8927.268,-3993.609;Inherit;False;T2_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1138;-14902.89,2674.966;Inherit;True;Property;_TextureSample42;Texture Sample 42;92;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1152;-14016.65,-1121.608;Inherit;False;Property;_T3_AnimatedGrunge_Tiling;T3_AnimatedGrunge_Tiling;78;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1187;-10584.52,0.2567101;Inherit;False;T3_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1411;-190.7174,-4702.136;Inherit;False;Constant;_Float25;Float 25;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;585;-2307.816,-4442.393;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;363;-2308.742,-5540.354;Inherit;True;Property;_TextureSample66;Texture Sample 66;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;703;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;807;-13734.25,-1756.652;Inherit;False;Property;_T2_CustomRimLight;T2_CustomRimLight?;62;0;Create;True;0;0;False;1;Header(T2 Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1400;-426.1516,-5477.184;Inherit;True;881;TA_2_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;711;-13968.78,-5965.854;Inherit;False;Constant;_Float19;Float 19;62;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1106;-12450.94,-455.7013;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;598;-4208.631,-4569.591;Inherit;False;Constant;_Float3;Float 3;69;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;882;-13938.24,-3597.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Speed;T2_AnimatedGrunge_Flipbook_Speed;59;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-11269.91,-6050.4;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1154;-12158.81,-1060.272;Inherit;False;Property;_T3_AnimatedGrunge_Multiply;T3_AnimatedGrunge_Multiply;83;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;709;-13986.85,-5554.082;Inherit;True;708;TA_1_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;1081;-12983.38,-1293.055;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-12876.88,-6731.726;Inherit;False;Constant;_Float62;Float 62;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1064;-10901.91,2774.877;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1104;-14014.65,-1293.608;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1475;-9673.299,-6807.266;Inherit;False;187;T1_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;586;-1925.816,-4132.393;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1110;-12175.74,-1310.461;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;135;-12228.6,-6024.229;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleTimeNode;890;-13545.24,-3577.098;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;399;-12565.26,-5411.059;Inherit;False;Property;_T1_ColorCorrection;T1_ColorCorrection;23;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1422;-11942.54,-6413.93;Inherit;False;Property;_T1_AnimatedGrunge;T1_AnimatedGrunge?;30;0;Create;True;0;0;False;1;Header(T1 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;167;-13792.36,-6862.327;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1463;-13713.44,-6745.775;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;1538;-1064.22,-6657.07;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;622;-1419.846,-4335.654;Inherit;False;AllAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1469;-14031.5,1768.138;Inherit;False;Property;_T4_AnimatedGrunge_ScreenBased;T4_AnimatedGrunge_ScreenBased?;99;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1452;-11972.67,1940.83;Inherit;False;Property;_T4_AnimatedGrunge;T4_AnimatedGrunge?;97;0;Create;True;0;0;False;1;Header(T4 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;854;-13939.24,-3672.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Rows;T2_AnimatedGrunge_Flipbook_Rows;58;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-13686.41,-6599.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Columns;T1_AnimatedGrunge_Flipbook_Columns;34;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1208;-11163.25,-1012.488;Inherit;False;Property;_T3_CustomRimLight_Color;T3_CustomRimLight_Color;86;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1156;-12457.74,-1064.461;Inherit;False;Property;_T3_AnimatedGrunge_Contrast;T3_AnimatedGrunge_Contrast;82;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1465;-13482.6,-6867.532;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1447;-11819.36,-936.8813;Inherit;False;Constant;_Float42;Float 42;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1541;-668.1101,-6450.717;Inherit;False;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1476;-9440.299,-6807.266;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1010;-2710.894,-3668.561;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;381;-12703.86,-6890.889;Inherit;True;Property;_TextureSample67;Texture Sample 67;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1479;-9389.141,-3991.244;Inherit;False;839;T2_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1462;-13764.91,-3852.185;Inherit;False;Property;_T2_AnimatedGrunge_ScreenBased;T2_AnimatedGrunge_ScreenBased?;55;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1451;-11829.28,1831.887;Inherit;False;Constant;_Float44;Float 44;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1111;-14531.78,2284.906;Inherit;False;T4_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1058;-15307.39,2766.983;Inherit;False;Constant;_Float13;Float 13;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1484;-9443.87,2248.757;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;252;-11980.43,-5445.562;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;821;-13630.19,-4082.85;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;1481;-9623.276,-817.3984;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;432;-1347.18,-6342.185;Inherit;False;Property;_ShadowColor;ShadowColor;13;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.8396226,0.8396226,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;917;-14016.19,-4086.85;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;74;-14917.79,-6777.057;Inherit;True;Property;_TA_1_Textures_Sample;TA_1_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;ef1e633c4c2c51641bd59a932b55b28a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1108;-11268.2,-481.6813;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-13685.41,-6525.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Rows;T1_AnimatedGrunge_Flipbook_Rows;35;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1150;-13322.38,1560.615;Inherit;False;Property;_T4_IsGrungeAnimated;T4_IsGrungeAnimated?;98;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1477;-9211.426,-6809.632;Inherit;False;T1_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;734;-14903.24,-5476.507;Inherit;True;Property;_TextureSample38;Texture Sample 38;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;1114;-12226.89,-455.5104;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;614;-963.4258,-5518.905;Inherit;False;GrayscaleDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;158;-12985.09,-6861.774;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1485;-9214.997,2246.392;Inherit;False;T4_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-15343.01,-6356.208;Inherit;False;Constant;_Float63;Float 63;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;703;-4514.157,-5790.851;Inherit;True;Property;_ShadowNoise;ShadowNoise;8;0;Create;True;0;0;False;1;Header(Shadow and Noise);False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;a61778d50b6394348b9f8089e2c6e1fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;169;-4491.268,-6644.676;Inherit;True;644;AllNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;605;-1275.699,-5824.597;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;0;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;600;-11154.96,-6405.207;Inherit;False;599;T1_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1115;-14905.78,2283.906;Inherit;True;Property;_TA_4_Grunges_Sample;TA_4_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1086;-12875.17,-1163.007;Inherit;False;Constant;_Float31;Float 31;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1045;-10599.52,1660.967;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;621;-14039.19,-5328.548;Inherit;False;Property;_T1_Albedo_Tiling;T1_Albedo_Tiling;25;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1078;-12162.57,1459.016;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;694;219.225,-3604.952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;-3213.352,-5654.817;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1466;-13705.67,-1166.591;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1099;-13967.07,-397.1354;Inherit;False;Constant;_Float33;Float 33;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;918;-13792.19,-4086.85;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1093;-10809.68,-935.5383;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;700;-14907.66,-6060.29;Inherit;True;Property;_TA_1_Grunges_Sample;TA_1_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;581;-2186.463,-4214.267;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1415;-353.237,-4907.696;Inherit;False;1377;T3_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1200;-13716.46,1024.775;Inherit;False;Property;_T3_CustomRimLight;T3_CustomRimLight?;84;0;Create;True;0;0;False;1;Header(T3 Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;926;-10818.93,-4079.113;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;435;-2195.47,-6393.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1056;-12226.72,2319.967;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;640;285.7617,-3802.554;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1112;-12377.09,-1316.284;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1162;-12186.64,1711.206;Inherit;False;Property;_T4_AnimatedGrunge_Multiply;T4_AnimatedGrunge_Multiply;105;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1428;-11797.62,-3724.511;Inherit;False;Constant;_Float10;Float 10;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1049;-15209.85,3471.514;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1454;-11846.7,2247.273;Inherit;False;Constant;_Float45;Float 45;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;425;-3106.479,-6399.385;Inherit;False;Property;_StepShadow;StepShadow;11;0;Create;True;0;0;False;0;False;0.1;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1482;-9394.403,-819.7634;Inherit;False;T3_End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1181;-14013.27,880.9048;Inherit;True;1183;T3_CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1460;-13707.75,-3986.428;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1070;-15304.28,2917.454;Inherit;False;Constant;_Float16;Float 16;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1383;182.8246,-5821.839;Inherit;True;Procedural Sample;-1;;116;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.ScreenPosInputsNode;163;-14016.36,-6862.327;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1146;-15134.52,1566.142;Inherit;False;TA_4_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;825;-13986.68,-2778.605;Inherit;True;881;TA_2_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;607;-15211.73,-4872.681;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1103;-11915.79,2996.033;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1362;-14916.08,-1208.338;Inherit;True;Property;_TA_3_Textures_Sample;TA_3_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;489;-3209.282,-5113.797;Inherit;False;488;DebugColor1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1052;-15348.48,2512.366;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;569;-2954.644,-4848.521;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;574;-3201.871,-4905.938;Inherit;False;868;Texture2_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;423;-1278.309,-5725.769;Inherit;False;Property;_LightDebug;LightDebug;2;0;Create;True;0;0;False;1;Header(Debug);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1184;-14917.03,-822.4807;Inherit;True;Property;_TextureSample34;Texture Sample 34;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1362;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;1543;-268.0488,-6830.268;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1497;-2948.732,-3643.134;Inherit;False;1496;IB_Shadows;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1147;-10809.51,1839.939;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;869;-15219.03,-2256.253;Inherit;False;839;T2_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1077;-15306.35,2689.414;Inherit;False;Constant;_Float29;Float 29;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;570;-3201.847,-4830.15;Inherit;False;477;DebugColor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1483;-9854.276,-818.3984;Inherit;False;1119;T3_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1061;-14014.48,1481.869;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;590;-4554.859,-4981.286;Inherit;False;Property;_DebugTextureTiling;DebugTextureTiling;7;0;Create;True;0;0;False;0;False;10;9.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;874;-15358.11,-3287.447;Inherit;True;Property;_TA_2_Grunges;TA_2_Grunges;44;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;8f4c22a1083f0e64f8a4c34b3cc88618;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;1380;-424.8652,-5822.006;Inherit;True;708;TA_1_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;919;-13308.23,-3845.578;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;1437;-12777.36,-2773.105;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1478;-9156.141,-3991.244;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-1271.828,-5622.753;Inherit;False;Property;_NormalDebug;NormalDebug;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-12275.26,-5545.058;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1190;-14903.06,-100.5114;Inherit;True;Property;_TextureSample35;Texture Sample 35;89;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1178;-14520.43,-1204.725;Inherit;False;T3_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;635;-1.915349,-4021.934;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1445;-11962.75,-827.9385;Inherit;False;Property;_T3_AnimatedGrunge;T3_AnimatedGrunge?;75;0;Create;True;0;0;False;1;Header(T3 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1446;-11623.58,-901.7634;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;412;-4233.749,-6494.964;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;606;-975.6267,-5823.472;Inherit;False;Out_or_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;413;-3673.75,-6638.963;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;844;-14031.06,-1900.522;Inherit;True;826;T2_CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1080;-13306.69,-1052.336;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;1116;-14013.1,3664.709;Inherit;True;1131;T4_CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;872;-15211.56,-2097.204;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1430;-11815.04,-3309.125;Inherit;False;Constant;_Float9;Float 9;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;340;-14944.62,-5027.286;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1191;-13683.7,-956.8566;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Rows;T3_AnimatedGrunge_Flipbook_Rows;80;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;176;-4141.909,-5584.326;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1119;-13168.16,836.6451;Inherit;False;T3_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1186;-13629.65,-1288.608;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;415;-13717.32,-4772.889;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;411;-4217.748,-6638.963;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;301;-14024.15,-4875.206;Inherit;True;202;T1_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;748;-14630.05,-5032.536;Inherit;False;Texture1_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;818;-13351.56,-3218.651;Inherit;False;Property;_T2_PaintGrunge_Contrast;T2_PaintGrunge_Contrast;51;0;Create;True;0;0;False;0;False;0;-3.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1046;-13639.48,1482.869;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1159;-13684.53,1744.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Columns;T4_AnimatedGrunge_Flipbook_Columns;101;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1094;-12209.33,36.02634;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1455;-11672.88,2326.522;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;915;-14018.54,-2963.531;Inherit;False;Property;_T2_PaintGrunge_Tiling;T2_PaintGrunge_Tiling;50;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1403;179.9068,-5128.819;Inherit;True;Procedural Sample;-1;;115;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;478;-3541.9,-4615.076;Inherit;True;DebugColor3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;713;-14526.93,-5861.771;Inherit;False;T1_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1397;181.5387,-5477.017;Inherit;True;Procedural Sample;-1;;114;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TextureCoordinatesNode;1391;-13737.9,-235.402;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1175;-13984.97,2790.114;Inherit;True;1146;TA_4_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1122;-10584.35,2775.733;Inherit;False;T4_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1069;-12983.21,1482.422;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;426;-2131.47,-6761.385;Inherit;False;197;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1098;-15356.4,2281.271;Inherit;True;Property;_TA_4_Grunges;TA_4_Grunges;89;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;8f4c22a1083f0e64f8a4c34b3cc88618;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1173;-12701.98,1453.307;Inherit;True;Property;_TextureSample50;Texture Sample 50;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;619;-13751.75,-5469.158;Inherit;False;Constant;_Float4;Float 4;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;881;-15136.23,-4002.577;Inherit;False;TA_2_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;861;-14533.89,-3616.385;Inherit;False;T2_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1183;-10444.81,-1119.944;Inherit;False;T3_CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1378;-13835.29,-2548.948;Inherit;False;T2_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;906;-13378.99,-2778.438;Inherit;True;Procedural Sample;-1;;106;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;608;-967.5857,-5724.967;Inherit;False;LightDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;907;-12384.63,-4116.526;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1139;-14903.73,2482.967;Inherit;True;Property;_TextureSample43;Texture Sample 43;90;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1213;-14012.91,2181.306;Inherit;True;1140;TA_4_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.FunctionNode;617;-13379.16,-5553.915;Inherit;True;Procedural Sample;-1;;108;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;1377;-13841.25,241.5291;Inherit;False;T3_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1063;-12450.77,2319.775;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;885;-12876.71,-3956.249;Inherit;False;Constant;_Float55;Float 55;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;285;-13036.75,-6155.909;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;584;-2189.48,-4288.115;Inherit;False;479;DebugColor4;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1385;-13621.2,-5371.96;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;410;-10446.52,-6688.663;Inherit;False;T1_CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1068;-15342.13,1910.988;Inherit;False;Constant;_Float15;Float 15;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;809;-13432.98,-2090.581;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;268;-15308.23,-5654.782;Inherit;False;Constant;_Float71;Float 71;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1120;-13167.99,3620.448;Inherit;False;T4_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;567;-3206.268,-5039.949;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1392;-13617.3,-2592.616;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;884;-12703.69,-4115.412;Inherit;True;Property;_TextureSample48;Texture Sample 48;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;336;-13697.17,-6163.136;Inherit;True;Procedural Sample;-1;;109;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SimpleContrastOpNode;1459;-12115.79,-2755.698;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;889;-13751.58,-2693.681;Inherit;False;Constant;_Float26;Float 26;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;1130;-13790.65,-1293.608;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;377;-13351.73,-5994.128;Inherit;False;Property;_T1_PaintGrunge_Contrast;T1_PaintGrunge_Contrast;28;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1467;-14039.83,-1024.348;Inherit;False;Property;_T3_AnimatedGrunge_ScreenBased;T3_AnimatedGrunge_ScreenBased?;77;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1053;-13415.02,3474.65;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;867;-14907.49,-3284.813;Inherit;True;Property;_TA_2_Grunges_Sample;TA_2_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1472;-3197.546,-4321.959;Inherit;True;Property;_TerrainMaskTexture;TerrainMaskTexture;1;0;Create;True;0;0;False;1;Header(TerrainMask);False;-1;None;4a63dddb07f87d541b02f7ca4ed57c92;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1423;-11603.37,-6487.755;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;877;-15305.99,-2651.265;Inherit;False;Constant;_Float22;Float 22;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;297;-12803.66,-5907.729;Inherit;False;Property;_T1_PaintGrunge_Multiply;T1_PaintGrunge_Multiply;29;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;865;-14917.62,-4001.58;Inherit;True;Property;_TA_2_Textures_Sample;TA_2_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;579;-2680.906,-4624.835;Inherit;False;1214;Texture3_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;583;-2189.503,-4363.903;Inherit;False;1364;Texture4_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;812;-11164.79,-3805.73;Inherit;False;Property;_T2_CustomRimLight_Color;T2_CustomRimLight_Color;64;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1155;-12468.57,1709.016;Inherit;False;Property;_T4_AnimatedGrunge_Contrast;T4_AnimatedGrunge_Contrast;104;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;615;-11981.89,-5360.529;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1366;-14554.52,2866.77;Inherit;False;T4_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;739;-15350.36,-5831.829;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1135;-12801.78,2436.467;Inherit;False;Property;_T4_PaintGrunge_Multiply;T4_PaintGrunge_Multiply;96;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1141;-13543.53,1991.621;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1402;463.2452,-5128.613;Inherit;False;T3_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;409;-13725.7,-4537.365;Inherit;False;Property;_T1_CustomRimLight;T1_CustomRimLight?;39;0;Create;True;0;0;False;1;Header(T1 Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;717;-12455.45,-6645.18;Inherit;False;Property;_T1_AnimatedGrunge_Contrast;T1_AnimatedGrunge_Contrast;37;0;Create;True;0;0;False;0;False;1.58;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1082;-13543.7,-783.8566;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;-13967.71,-5731.008;Inherit;False;Property;_T1_PaintGrunge_Tiling;T1_PaintGrunge_Tiling;27;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1125;-13377.28,2790.281;Inherit;True;Procedural Sample;-1;;107;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TextureCoordinatesNode;563;-4321.25,-5000.2;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;571;-3198.832,-4756.302;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;909;-11873.35,-4109.513;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;692;13.11786,-3790.681;Inherit;True;1408;T4_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;863;-14521.97,-3997.967;Inherit;False;T2_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;871;-14944.45,-2251.809;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1245;-13708.08,789.251;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1134;-12499.16,2945.502;Inherit;False;Property;_T4_ColorCorrection;T4_ColorCorrection;90;0;Create;True;0;0;False;0;False;1,1,1,0;1,0.9103774,0.9103774,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1394;-13732.33,-5793.535;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1369;-14554.69,91.29375;Inherit;False;T3_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-13633.36,-6871.327;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;815;-11129.38,-4118.157;Inherit;True;860;T2_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;855;-15342.84,-3580.731;Inherit;False;Constant;_Float49;Float 49;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1136;-15307.56,-8.493289;Inherit;False;Constant;_Float36;Float 36;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;846;-14905.44,-3085.752;Inherit;True;Property;_TextureSample39;Texture Sample 39;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1129;-13306.52,1723.141;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1166;-13965.83,2613.188;Inherit;False;Property;_T4_PaintGrunge_Tiling;T4_PaintGrunge_Tiling;94;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1145;-15378.94,1564.851;Inherit;True;Property;_TA_4_Textures;TA_4_Textures;88;0;Create;True;0;0;False;1;Header(Texture 4 VertexPaintBlue);False;ef1e633c4c2c51641bd59a932b55b28a;367e4a1a884fceb4495dc92c9be487dd;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;879;-15309.1,-2801.735;Inherit;False;Constant;_Float24;Float 24;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;820;-14014.19,-3908.85;Inherit;False;Property;_T2_AnimatedGrunge_Tiling;T2_AnimatedGrunge_Tiling;56;0;Create;True;0;0;False;0;False;1;32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;422;-2739.47,-6681.385;Inherit;False;Property;_StepAttenuation;StepAttenuation;12;0;Create;True;0;0;False;0;False;-0.07;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1406;-427.7834,-5128.986;Inherit;True;1090;TA_3_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-3385.751,-6654.963;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1051;-11914.33,2911;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;870;-15209.65,-2175.853;Inherit;False;1480;T2_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1148;-14901.36,2867.688;Inherit;True;Property;_TextureSample49;Texture Sample 49;100;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1364;-14628.17,3311.659;Inherit;False;Texture4_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1206;-15341.3,-787.4894;Inherit;False;Constant;_Float40;Float 40;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;246;-13424.43,-4871.294;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;359;-2942.513,-5520.482;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;921;-13968.61,-3190.377;Inherit;False;Constant;_Float27;Float 27;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;566;-971.4554,-5421.064;Inherit;False;DebugVertexPaint;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;595;-4211.925,-4812.445;Inherit;False;Constant;_Float0;Float 0;69;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1209;-13415.19,690.8464;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;849;-14556.23,-2701.948;Inherit;False;T2_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;395;-10819.1,-6854.59;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;819;-12474.28,-3893.703;Inherit;False;Property;_T2_AnimatedGrunge_Contrast;T2_AnimatedGrunge_Contrast;60;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1473;-584.6416,-3704.566;Inherit;True;Property;_TextureSample31;Texture Sample 31;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1472;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;868;-14629.88,-2257.059;Inherit;False;Texture2_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1137;-14525.05,2483.425;Inherit;False;T4_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1076;-13034.87,2188.287;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;910;-12160.35,-3886.513;Inherit;False;Property;_T2_AnimatedGrunge_Multiply;T2_AnimatedGrunge_Multiply;61;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1079;-12209.16,2811.503;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;905;-11916.04,-2657.719;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;853;-14526.76,-3086.294;Inherit;False;T2_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;864;-15342.84,-3504.731;Inherit;False;Constant;_Float51;Float 51;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1128;-11915.96,220.5555;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1109;-11900.81,-1310.272;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1140;-15117.29,2282.417;Inherit;False;TA_4_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1449;-11998.13,-322.4233;Inherit;False;Property;_T3_PaintGrunge;T3_PaintGrunge?;71;0;Create;True;0;0;False;1;Header(T3 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1440;-13078.34,125.3606;Inherit;False;Property;_T3_Albedo_ProceduralTiling;T3_Albedo_ProceduralTiling?;69;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1442;-13393.76,3120.571;Inherit;True;Property;_TextureSample30;Texture Sample 30;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;891;-12984.92,-4086.297;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;698;-2942.739,-3718.092;Inherit;False;428;Shadows;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1170;-12801.95,-339.0104;Inherit;False;Property;_T3_PaintGrunge_Multiply;T3_PaintGrunge_Multiply;74;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;856;-14533.49,-3283.813;Inherit;False;T2_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1503;2521.275,-6469.55;Inherit;False;Property;_IB_ShadowColor;IB_ShadowColor;18;0;Create;True;0;0;False;0;False;0,0,0,0;0.3301885,0.3301885,0.3301885,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;852;-14904.6,-2893.753;Inherit;True;Property;_TextureSample41;Texture Sample 41;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1420;-11689.31,-6049.232;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;421;-2403.47,-6345.385;Inherit;False;Constant;_Float77;Float 77;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;908;-12156.28,-4110.703;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-15373.39,-6573.204;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1185;-13985.14,14.63659;Inherit;True;1090;TA_3_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;1461;-13486.91,-4082.185;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;1113;-11914.5,135.5223;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;708;-15136.4,-6778.054;Inherit;False;TA_1_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1195;-15210.02,696.0374;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;731;-14904.77,-5669.23;Inherit;True;Property;_TextureSample37;Texture Sample 37;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-11868.52,-6884.99;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;873;-15119,-3286.302;Inherit;False;TA_2_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1412;-425.8178,-4787.06;Inherit;True;1146;TA_4_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.WireNode;693;-56.77522,-3827.952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-15219.2,-5031.73;Inherit;False;187;T1_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1048;-13716.29,3808.578;Inherit;False;Property;_T4_CustomRimLight;T4_CustomRimLight?;106;0;Create;True;0;0;False;1;Header(T4 Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;814;-11154.79,-3629.73;Inherit;False;861;T2_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;876;-15373.22,-3797.727;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;642;-568.3788,-4433.155;Inherit;True;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-3676.511,-5798.626;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;866;-15380.65,-4003.868;Inherit;True;Property;_TA_2_Textures;TA_2_Textures;43;0;Create;True;0;0;False;1;Header(Texture 2 VertexPaintRed);False;ef1e633c4c2c51641bd59a932b55b28a;2b6e729c66a58e64e9da60628e5652f1;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;427;-2195.47,-6297.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1172;-11127.67,1450.562;Inherit;True;1102;T4_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1062;-13695.29,2181.06;Inherit;True;Procedural Sample;-1;;112;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.Vector2Node;159;-3252.154,-5829.296;Inherit;False;Property;_ShadowNoisePanner;ShadowNoisePanner;10;0;Create;True;0;0;False;0;False;0.01,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;737;-15405.28,-6061.924;Inherit;True;Property;_TA_1_Grunges;TA_1_Grunges;22;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;b33b36e28008b23459206c358b00d02a;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-14535.2,-6294.926;Inherit;False;T1_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1211;-14014.91,686.9343;Inherit;True;1187;T3_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1180;-14903.9,-291.5104;Inherit;True;Property;_TextureSample51;Texture Sample 51;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;1060;-13790.48,1481.869;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;477;-3541.403,-4852.273;Inherit;True;DebugColor2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;850;-14560.24,-2893.769;Inherit;False;T2_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;177;-14919.35,-6583.95;Inherit;True;Property;_TextureSample57;Texture Sample 57;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1379;-13856.48,-5328.852;Inherit;False;T1_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;875;-15350.19,-3056.352;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;851;-14903.07,-2701.03;Inherit;True;Property;_TextureSample40;Texture Sample 40;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;611;-2055.049,-3557.17;Inherit;False;610;NormalDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;912;-10903.62,-2793.841;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1158;-13683.53,1818.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Rows;T4_AnimatedGrunge_Flipbook_Rows;102;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1432;-11976.39,-3110.053;Inherit;False;Property;_T2_PaintGrunge;T2_PaintGrunge?;49;0;Create;True;0;0;False;1;Header(T2 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1083;-13749.87,2875.038;Inherit;False;Constant;_Float30;Float 30;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;286;-1825.177,-3791.399;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1436;-13380.65,-2446.472;Inherit;True;Property;_TextureSample28;Texture Sample 28;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1054;-15341.13,2063.988;Inherit;False;Constant;_Float12;Float 12;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;593;-3949.372,-4572.56;Inherit;True;Property;_TextureSample25;Texture Sample 25;6;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1192;-15348.65,-263.1105;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1431;-11641.22,-3229.876;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;860;-14535.03,-3519.448;Inherit;False;T2_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;806;-14032.7,-2094.494;Inherit;True;816;T2_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1512;-2905.585,-3570.698;Inherit;False;Constant;_Float47;Float 47;109;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1065;-11268.03,2293.795;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;826;-10446.35,-3913.186;Inherit;False;T2_CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;911;-11269.74,-3274.923;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;171;-14918.74,-6391.199;Inherit;True;Property;_TextureSample56;Texture Sample 56;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1118;-15217.32,3312.465;Inherit;False;1120;T4_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-2942.513,-5744.482;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;397;-11164.96,-6581.207;Inherit;False;Property;_T1_CustomRimLight_Color;T1_CustomRimLight_Color;41;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;823;-14014.62,-3387.412;Inherit;True;873;TA_2_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1072;-14003.31,3016.647;Inherit;False;Property;_T4_Albedo_Tiling;T4_Albedo_Tiling;92;0;Create;True;0;0;False;0;False;1;26.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1160;-13684.7,-1030.857;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Columns;T3_AnimatedGrunge_Flipbook_Columns;79;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;888;-14023.02,-2549.071;Inherit;False;Property;_T2_Albedo_Tiling;T2_Albedo_Tiling;48;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1456;-12008.05,2446.345;Inherit;False;Property;_T4_PaintGrunge;T4_PaintGrunge?;93;0;Create;True;0;0;False;1;Header(T4 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1085;-11640.59,37.8364;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;920;-11917.5,-2572.686;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;813;-11186.79,-3549.729;Inherit;False;Property;_T2_CutomRimLight_Texture;T2_CutomRimLight_Texture?;63;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1441;-12779.06,9.415527;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1399;-191.0514,-5392.259;Inherit;False;Constant;_Float8;Float 8;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-3926.91,-5717.327;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;19;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1124;-13377.45,14.80359;Inherit;True;Procedural Sample;-1;;111;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1091;-15306.52,-86.06361;Inherit;False;Constant;_Float32;Float 32;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;602;-11186.96,-6325.206;Inherit;False;Property;_T1_CustomRimLight_Texture;T1_CustomRimLight_Texture?;40;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;883;-13036.58,-3380.432;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1509;2548.216,-6623.054;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1092;-14028.48,242.1707;Inherit;False;Property;_T3_Albedo_Tiling;T3_Albedo_Tiling;70;0;Create;True;0;0;False;0;False;1;15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1089;-13682.7,-881.8566;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Speed;T3_AnimatedGrunge_Flipbook_Speed;81;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1493;2104.301,-6747.799;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1419;-12024.48,-5929.408;Inherit;False;Property;_T1_PaintGrunge;T1_PaintGrunge?;26;0;Create;True;0;0;False;1;Header(T1 Paint Grunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1066;-11896.64,1459.206;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1123;-11153.08,1938.989;Inherit;False;1101;T4_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1439;-13382.35,336.0486;Inherit;True;Property;_TextureSample29;Texture Sample 29;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;857;-15343.84,-3657.731;Inherit;False;Constant;_Float50;Float 50;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1470;-13715.34,1602.895;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-13177.4,-4725.495;Inherit;False;T1_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1398;-96.63238,-5278.863;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;356;-2659.47,-6937.386;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1151;-11131.22,1641.605;Inherit;False;Property;_T4_CustomRimLight_Opacity;T4_CustomRimLight_Opacity;109;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1435;-13077.44,-5455.58;Inherit;False;Property;_T1_Albedo_ProceduralTiling;T1_Albedo_ProceduralTiling?;24;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1149;-13350.02,-425.4093;Inherit;False;Property;_T3_PaintGrunge_Contrast;T3_PaintGrunge_Contrast;73;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1429;-11941.01,-3615.568;Inherit;False;Property;_T2_AnimatedGrunge;T2_AnimatedGrunge?;53;0;Create;True;0;0;False;1;Header(T2 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1433;-13381.45,-5244.892;Inherit;True;Property;_TextureSample27;Texture Sample 27;91;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;632;-282.3738,-4232.458;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;886;-11642.13,-2755.405;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;859;-14918.57,-3615.722;Inherit;True;Property;_TextureSample45;Texture Sample 45;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;865;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;928;-10811.22,-3728.78;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1241;-14905.95,-491.5715;Inherit;True;Property;_TA_3_Grunges_Sample;TA_3_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1393;-13780.73,-3020.198;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;916;-13697,-3387.659;Inherit;True;Procedural Sample;-1;;113;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;710;-14014.79,-6162.889;Inherit;True;738;TA_1_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1367;-15207.94,3392.865;Inherit;False;1485;T4_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;701;-14533.66,-6059.29;Inherit;False;T1_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1074;-11640.42,2813.314;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1390;-13637.1,196.9722;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;913;-12452.48,-3248.943;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1376;-13811,3017.032;Inherit;False;T4_Albedo_Tiling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1500;1948.064,-6570.549;Inherit;False;Property;_IB_StepAttenuation;IB_StepAttenuation;17;0;Create;True;0;0;False;0;False;0.1;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;405;-14022.51,-4681.235;Inherit;True;410;T1_CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1499;1973.064,-6654.549;Inherit;False;Property;_IB_StepShadow;IB_StepShadow;16;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1413;-341.7355,-5598.232;Inherit;False;1379;T1_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1088;-13035.04,-587.1907;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1424;-11799.15,-6522.873;Inherit;False;Constant;_Float46;Float 46;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1443;-13089.75,2909.883;Inherit;False;Property;_T4_Albedo_ProceduralTiling;T4_Albedo_ProceduralTiling?;91;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1105;-13695.46,-594.4177;Inherit;True;Procedural Sample;-1;;110;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;428;516.3201,-6445.036;Inherit;False;Shadows;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;420;-2547.47,-6697.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;318;-12154.52,-6639.99;Inherit;False;Property;_T1_AnimatedGrunge_Multiply;T1_AnimatedGrunge_Multiply;38;0;Create;True;0;0;False;0;False;1.58;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;811;-10601.23,-3907.752;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1434;-12778.16,-5571.525;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;878;-15308.1,-2727.18;Inherit;False;Constant;_Float23;Float 23;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1427;-11601.84,-3689.393;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;704;-2865.013,-3822.628;Inherit;False;622;AllAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;-10601.4,-6683.229;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1389;-13608.91,2974.47;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;839;-13185.95,-1944.782;Inherit;False;T2_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1502;2733.274,-6623.55;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;880;-15308.06,-2879.305;Inherit;False;Constant;_Float52;Float 52;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;162;-3935.91,-5584.326;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-10586.23,-5568.462;Inherit;False;T1_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1199;-15208.11,617.3884;Inherit;False;1482;T3_End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1421;-11863.13,-6128.481;Inherit;False;Constant;_Float34;Float 34;170;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1501;2191.064,-6610.549;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1496;3827.23,-6751.163;Inherit;False;IB_Shadows;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-12452.65,-6024.42;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;706;-15407.82,-6778.345;Inherit;True;Property;_TA_1_Textures;TA_1_Textures;21;0;Create;True;0;0;False;1;Header(Texture 1 VertexPaintBlack);False;ef1e633c4c2c51641bd59a932b55b28a;03400b2757c6d6d459169340ceb111c8;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;1414;-345.9882,-5255.924;Inherit;False;1378;T2_Albedo_Tiling;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1511;3355.173,-6833.966;Inherit;False;Constant;_Float6;Float 6;109;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1521;-1041.523,-6419.875;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1539;-1341.03,-6543.738;Inherit;False;Property;_EdgeShadowColor;EdgeShadowColor;14;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1544;266.0214,-6600.105;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1131;-10444.64,1655.533;Inherit;False;T4_CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;431;-797.2797,-6946.284;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1546;98.22156,-6463.705;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1545;-151.1787,-6463.905;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1510;3543.173,-6773.966;Inherit;False;Property;_IB_Shadow;IB_Shadow?;15;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1508;2963.216,-6744.054;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1498;2349.064,-6743.549;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-1642.624,-4513.329;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;-1621.909,-3701.79;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;TerrainMaterialShader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;1;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;408;0;424;0
WireConnection;1450;0;1448;0
WireConnection;1450;1;1114;0
WireConnection;1450;2;1449;0
WireConnection;565;0;573;0
WireConnection;565;1;489;0
WireConnection;565;2;567;0
WireConnection;732;0;731;0
WireConnection;1087;1;1081;0
WireConnection;1087;6;1086;0
WireConnection;903;0;923;0
WireConnection;903;1;1437;0
WireConnection;14;0;11;0
WireConnection;14;1;576;0
WireConnection;14;2;585;0
WireConnection;914;0;913;0
WireConnection;403;0;381;1
WireConnection;1132;0;1143;0
WireConnection;1409;158;1412;0
WireConnection;1409;183;1411;0
WireConnection;1409;5;1410;0
WireConnection;1127;0;1172;0
WireConnection;1127;1;1151;0
WireConnection;1386;0;1413;0
WireConnection;386;0;362;0
WireConnection;1368;0;1184;4
WireConnection;479;0;594;0
WireConnection;1101;0;1142;0
WireConnection;488;0;559;0
WireConnection;1210;0;1095;0
WireConnection;1210;1;1093;0
WireConnection;218;1;386;0
WireConnection;133;0;74;0
WireConnection;1102;0;1142;4
WireConnection;424;0;430;0
WireConnection;424;1;426;0
WireConnection;1388;0;1166;0
WireConnection;191;0;335;0
WireConnection;191;1;252;0
WireConnection;191;2;615;0
WireConnection;1371;0;1190;0
WireConnection;1404;0;1415;0
WireConnection;282;0;705;0
WireConnection;282;1;294;0
WireConnection;282;2;609;0
WireConnection;406;0;416;0
WireConnection;406;1;435;0
WireConnection;406;2;427;0
WireConnection;1203;1;1164;0
WireConnection;1203;6;1206;0
WireConnection;592;1;563;0
WireConnection;1372;0;1138;0
WireConnection;716;1;403;0
WireConnection;716;0;717;0
WireConnection;1107;0;1108;0
WireConnection;1107;1;1085;0
WireConnection;179;0;1465;0
WireConnection;179;1;132;0
WireConnection;179;2;127;0
WireConnection;179;3;146;0
WireConnection;179;5;208;0
WireConnection;858;1;876;0
WireConnection;858;6;855;0
WireConnection;362;0;157;0
WireConnection;362;2;180;0
WireConnection;738;0;737;0
WireConnection;190;0;184;0
WireConnection;190;1;191;0
WireConnection;365;0;218;1
WireConnection;365;1;363;1
WireConnection;1050;0;1118;0
WireConnection;1050;1;1367;0
WireConnection;1050;2;1049;0
WireConnection;576;0;579;0
WireConnection;576;1;578;0
WireConnection;576;2;577;0
WireConnection;1055;0;1121;0
WireConnection;1055;1;1116;0
WireConnection;11;0;565;0
WireConnection;11;1;569;0
WireConnection;11;2;1472;1
WireConnection;1202;0;1184;0
WireConnection;735;0;734;0
WireConnection;1182;1;1192;0
WireConnection;1182;6;1179;0
WireConnection;559;1;563;0
WireConnection;559;6;595;0
WireConnection;1215;0;1180;0
WireConnection;601;0;397;0
WireConnection;601;1;600;0
WireConnection;601;2;602;0
WireConnection;139;0;1383;0
WireConnection;599;0;171;0
WireConnection;1471;0;1046;0
WireConnection;1471;1;1470;0
WireConnection;1471;2;1469;0
WireConnection;1444;0;1442;0
WireConnection;1444;1;1125;0
WireConnection;1444;2;1443;0
WireConnection;808;0;806;0
WireConnection;808;1;844;0
WireConnection;580;0;583;0
WireConnection;580;1;584;0
WireConnection;580;2;581;0
WireConnection;197;0;365;0
WireConnection;594;1;563;0
WireConnection;644;0;640;0
WireConnection;1090;0;1363;0
WireConnection;1453;0;1451;0
WireConnection;1453;1;1066;0
WireConnection;1453;2;1452;0
WireConnection;1408;0;1409;0
WireConnection;705;0;704;0
WireConnection;705;1;1010;0
WireConnection;610;0;281;0
WireConnection;1214;0;1196;0
WireConnection;1196;0;1198;0
WireConnection;1196;1;1199;0
WireConnection;1196;2;1195;0
WireConnection;1095;0;1188;0
WireConnection;1095;1;1153;0
WireConnection;414;0;411;0
WireConnection;414;1;412;0
WireConnection;142;0;162;0
WireConnection;142;1;128;0
WireConnection;495;0;14;0
WireConnection;495;1;580;0
WireConnection;495;2;586;0
WireConnection;1410;0;1416;0
WireConnection;1143;0;1146;0
WireConnection;1143;1;1057;0
WireConnection;1143;6;1068;0
WireConnection;712;1;739;0
WireConnection;712;6;702;0
WireConnection;1540;0;1538;0
WireConnection;1540;1;1539;0
WireConnection;1205;0;1241;0
WireConnection;1194;0;1193;0
WireConnection;816;0;912;0
WireConnection;430;0;356;0
WireConnection;430;1;425;0
WireConnection;430;2;420;0
WireConnection;429;0;408;0
WireConnection;429;1;406;0
WireConnection;1468;0;1186;0
WireConnection;1468;1;1466;0
WireConnection;1468;2;1467;0
WireConnection;1142;1;1057;0
WireConnection;1142;6;1054;0
WireConnection;1097;0;1173;1
WireConnection;1144;1;1057;0
WireConnection;1144;6;1047;0
WireConnection;1396;0;1397;0
WireConnection;1480;0;1478;0
WireConnection;1138;1;1052;0
WireConnection;1138;6;1059;0
WireConnection;1187;0;1107;0
WireConnection;585;0;1472;2
WireConnection;363;1;359;0
WireConnection;1106;0;1088;0
WireConnection;1106;1;1170;0
WireConnection;184;0;1423;0
WireConnection;184;1;1420;0
WireConnection;1081;0;1468;0
WireConnection;1081;1;1080;0
WireConnection;1081;2;1161;0
WireConnection;1064;0;1065;0
WireConnection;1064;1;1074;0
WireConnection;586;0;1472;3
WireConnection;1110;1;1112;0
WireConnection;1110;0;1156;0
WireConnection;135;0;253;0
WireConnection;167;0;163;0
WireConnection;1463;0;175;0
WireConnection;1538;0;429;0
WireConnection;622;0;495;0
WireConnection;1465;0;130;0
WireConnection;1465;1;1463;0
WireConnection;1465;2;1464;0
WireConnection;1541;0;1540;0
WireConnection;1541;1;1521;0
WireConnection;1476;0;1475;0
WireConnection;1010;0;698;0
WireConnection;1010;1;1512;0
WireConnection;1010;2;1012;0
WireConnection;381;1;158;0
WireConnection;381;6;156;0
WireConnection;1111;0;1115;0
WireConnection;1484;0;1486;0
WireConnection;252;0;335;0
WireConnection;821;0;918;0
WireConnection;821;1;820;0
WireConnection;1481;0;1483;0
WireConnection;74;0;708;0
WireConnection;74;1;50;0
WireConnection;74;6;71;0
WireConnection;1108;0;1446;0
WireConnection;1108;1;1450;0
WireConnection;1477;0;1476;0
WireConnection;734;1;739;0
WireConnection;734;6;733;0
WireConnection;1114;0;1106;0
WireConnection;614;0;613;0
WireConnection;158;0;1465;0
WireConnection;158;1;179;0
WireConnection;158;2;150;0
WireConnection;1485;0;1484;0
WireConnection;1115;0;1140;0
WireConnection;1115;1;1052;0
WireConnection;1115;6;1077;0
WireConnection;1045;0;1127;0
WireConnection;1045;1;1147;0
WireConnection;1078;1;1097;0
WireConnection;1078;0;1155;0
WireConnection;694;0;1473;3
WireConnection;157;0;170;0
WireConnection;157;1;142;0
WireConnection;157;2;168;0
WireConnection;1466;0;1152;0
WireConnection;918;0;917;0
WireConnection;1093;0;1208;0
WireConnection;1093;1;1189;0
WireConnection;1093;2;1167;0
WireConnection;700;0;738;0
WireConnection;700;1;739;0
WireConnection;700;6;268;0
WireConnection;926;0;815;0
WireConnection;926;1;810;0
WireConnection;435;0;425;0
WireConnection;435;1;421;0
WireConnection;1056;0;1063;0
WireConnection;640;0;635;0
WireConnection;640;1;692;0
WireConnection;640;2;694;0
WireConnection;1112;0;1087;1
WireConnection;1482;0;1481;0
WireConnection;1460;0;820;0
WireConnection;1383;158;1380;0
WireConnection;1383;183;1382;0
WireConnection;1383;5;1386;0
WireConnection;1146;0;1145;0
WireConnection;1362;0;1090;0
WireConnection;1362;1;1164;0
WireConnection;1362;6;1204;0
WireConnection;569;0;574;0
WireConnection;569;1;570;0
WireConnection;569;2;571;0
WireConnection;1184;1;1164;0
WireConnection;1184;6;1207;0
WireConnection;1543;0;431;0
WireConnection;1543;1;1541;0
WireConnection;1543;2;429;0
WireConnection;1147;0;1168;0
WireConnection;1147;1;1123;0
WireConnection;1147;2;1165;0
WireConnection;919;0;1461;0
WireConnection;919;1;822;0
WireConnection;919;2;854;0
WireConnection;919;3;882;0
WireConnection;919;5;890;0
WireConnection;1437;0;1436;0
WireConnection;1437;1;906;0
WireConnection;1437;2;1438;0
WireConnection;1478;0;1479;0
WireConnection;335;0;1434;0
WireConnection;335;1;399;0
WireConnection;1190;1;1192;0
WireConnection;1190;6;1163;0
WireConnection;1178;0;1362;0
WireConnection;635;0;632;0
WireConnection;635;1;691;0
WireConnection;635;2;693;0
WireConnection;1446;0;1447;0
WireConnection;1446;1;1109;0
WireConnection;1446;2;1445;0
WireConnection;606;0;605;0
WireConnection;413;0;414;0
WireConnection;413;1;358;0
WireConnection;1080;0;1468;0
WireConnection;1080;1;1160;0
WireConnection;1080;2;1191;0
WireConnection;1080;3;1089;0
WireConnection;1080;5;1082;0
WireConnection;340;0;274;0
WireConnection;340;1;349;0
WireConnection;340;2;607;0
WireConnection;1119;0;1209;0
WireConnection;1186;0;1130;0
WireConnection;1186;1;1152;0
WireConnection;415;0;301;0
WireConnection;415;1;405;0
WireConnection;411;0;169;0
WireConnection;748;0;340;0
WireConnection;1046;0;1060;0
WireConnection;1046;1;1067;0
WireConnection;1094;0;1126;0
WireConnection;1094;1;1441;0
WireConnection;1455;0;1454;0
WireConnection;1455;1;1056;0
WireConnection;1455;2;1456;0
WireConnection;1403;158;1406;0
WireConnection;1403;183;1405;0
WireConnection;1403;5;1404;0
WireConnection;478;0;593;0
WireConnection;713;0;712;0
WireConnection;1397;158;1400;0
WireConnection;1397;183;1399;0
WireConnection;1397;5;1398;0
WireConnection;1391;0;1169;0
WireConnection;1122;0;1064;0
WireConnection;1069;0;1471;0
WireConnection;1069;1;1129;0
WireConnection;1069;2;1150;0
WireConnection;1173;1;1069;0
WireConnection;1173;6;1075;0
WireConnection;881;0;866;0
WireConnection;861;0;859;0
WireConnection;1183;0;1210;0
WireConnection;1378;0;888;0
WireConnection;906;158;825;0
WireConnection;906;183;889;0
WireConnection;906;5;1392;0
WireConnection;608;0;423;0
WireConnection;907;0;884;1
WireConnection;1139;1;1052;0
WireConnection;1139;6;1058;0
WireConnection;617;158;709;0
WireConnection;617;183;619;0
WireConnection;617;5;1385;0
WireConnection;1377;0;1092;0
WireConnection;1063;0;1076;0
WireConnection;1063;1;1135;0
WireConnection;285;1;336;0
WireConnection;285;0;377;0
WireConnection;1385;0;1379;0
WireConnection;410;0;332;0
WireConnection;809;0;806;0
WireConnection;809;1;808;0
WireConnection;809;2;807;0
WireConnection;1120;0;1053;0
WireConnection;1392;0;1378;0
WireConnection;884;1;891;0
WireConnection;884;6;885;0
WireConnection;336;158;710;0
WireConnection;336;183;711;0
WireConnection;336;5;1394;0
WireConnection;1459;1;903;0
WireConnection;1459;0;1458;0
WireConnection;1130;0;1104;0
WireConnection;1053;0;1121;0
WireConnection;1053;1;1055;0
WireConnection;1053;2;1048;0
WireConnection;867;0;873;0
WireConnection;867;1;875;0
WireConnection;867;6;880;0
WireConnection;1423;0;1424;0
WireConnection;1423;1;224;0
WireConnection;1423;2;1422;0
WireConnection;865;0;881;0
WireConnection;865;1;876;0
WireConnection;865;6;857;0
WireConnection;1366;0;1148;0
WireConnection;1402;0;1403;0
WireConnection;1125;158;1175;0
WireConnection;1125;183;1083;0
WireConnection;1125;5;1389;0
WireConnection;563;0;590;0
WireConnection;909;0;908;0
WireConnection;909;1;910;0
WireConnection;863;0;865;0
WireConnection;871;0;869;0
WireConnection;871;1;870;0
WireConnection;871;2;872;0
WireConnection;1245;0;1211;0
WireConnection;1245;1;1181;0
WireConnection;1394;0;258;0
WireConnection;1369;0;1182;0
WireConnection;130;0;167;0
WireConnection;130;1;175;0
WireConnection;846;1;875;0
WireConnection;846;6;879;0
WireConnection;1129;0;1471;0
WireConnection;1129;1;1159;0
WireConnection;1129;2;1158;0
WireConnection;1129;3;1157;0
WireConnection;1129;5;1141;0
WireConnection;140;0;413;0
WireConnection;1051;0;1079;0
WireConnection;1148;1;1052;0
WireConnection;1148;6;1070;0
WireConnection;1364;0;1050;0
WireConnection;246;0;301;0
WireConnection;246;1;415;0
WireConnection;246;2;409;0
WireConnection;359;0;157;0
WireConnection;359;2;159;0
WireConnection;566;0;564;0
WireConnection;1209;0;1211;0
WireConnection;1209;1;1245;0
WireConnection;1209;2;1200;0
WireConnection;849;0;851;0
WireConnection;395;0;262;0
WireConnection;395;1;385;0
WireConnection;868;0;871;0
WireConnection;1137;0;1139;0
WireConnection;1076;1;1062;0
WireConnection;1076;0;1171;0
WireConnection;1079;0;1134;0
WireConnection;1079;1;1444;0
WireConnection;905;0;903;0
WireConnection;853;0;846;0
WireConnection;1109;0;1110;0
WireConnection;1109;1;1154;0
WireConnection;1140;0;1098;0
WireConnection;1442;0;1175;0
WireConnection;1442;1;1389;0
WireConnection;891;0;1461;0
WireConnection;891;1;919;0
WireConnection;891;2;841;0
WireConnection;856;0;867;0
WireConnection;852;1;875;0
WireConnection;852;6;878;0
WireConnection;1420;0;1421;0
WireConnection;1420;1;135;0
WireConnection;1420;2;1419;0
WireConnection;908;1;907;0
WireConnection;908;0;819;0
WireConnection;1461;0;821;0
WireConnection;1461;1;1460;0
WireConnection;1461;2;1462;0
WireConnection;1113;0;1094;0
WireConnection;708;0;706;0
WireConnection;731;1;739;0
WireConnection;731;6;714;0
WireConnection;224;0;716;0
WireConnection;224;1;318;0
WireConnection;873;0;874;0
WireConnection;693;0;1473;2
WireConnection;170;0;128;0
WireConnection;427;0;420;0
WireConnection;427;1;421;0
WireConnection;1062;158;1213;0
WireConnection;1062;183;1133;0
WireConnection;1062;5;1388;0
WireConnection;265;0;171;4
WireConnection;1180;1;1192;0
WireConnection;1180;6;1136;0
WireConnection;1060;0;1061;0
WireConnection;477;0;592;0
WireConnection;850;0;852;0
WireConnection;177;1;50;0
WireConnection;177;6;172;0
WireConnection;1379;0;621;0
WireConnection;851;1;875;0
WireConnection;851;6;877;0
WireConnection;912;0;911;0
WireConnection;912;1;886;0
WireConnection;286;0;282;0
WireConnection;286;1;280;0
WireConnection;286;2;611;0
WireConnection;1436;0;825;0
WireConnection;1436;1;1392;0
WireConnection;593;1;563;0
WireConnection;1431;0;1430;0
WireConnection;1431;1;914;0
WireConnection;1431;2;1432;0
WireConnection;860;0;859;4
WireConnection;1065;0;1453;0
WireConnection;1065;1;1455;0
WireConnection;826;0;811;0
WireConnection;911;0;1427;0
WireConnection;911;1;1431;0
WireConnection;171;1;50;0
WireConnection;171;6;241;0
WireConnection;180;0;159;0
WireConnection;1085;0;1094;0
WireConnection;1085;1;1113;0
WireConnection;1085;2;1128;0
WireConnection;1441;0;1439;0
WireConnection;1441;1;1124;0
WireConnection;1441;2;1440;0
WireConnection;1124;158;1185;0
WireConnection;1124;183;1084;0
WireConnection;1124;5;1390;0
WireConnection;883;1;916;0
WireConnection;883;0;818;0
WireConnection;1509;0;1498;0
WireConnection;1066;0;1078;0
WireConnection;1066;1;1162;0
WireConnection;1439;0;1185;0
WireConnection;1439;1;1390;0
WireConnection;1470;0;1067;0
WireConnection;187;0;246;0
WireConnection;1398;0;1414;0
WireConnection;1433;0;709;0
WireConnection;1433;1;1385;0
WireConnection;632;0;642;0
WireConnection;632;1;690;0
WireConnection;632;2;1473;1
WireConnection;886;0;1459;0
WireConnection;886;1;905;0
WireConnection;886;2;920;0
WireConnection;859;1;876;0
WireConnection;859;6;864;0
WireConnection;928;0;812;0
WireConnection;928;1;814;0
WireConnection;928;2;813;0
WireConnection;1241;0;1194;0
WireConnection;1241;1;1192;0
WireConnection;1241;6;1091;0
WireConnection;1393;0;915;0
WireConnection;916;158;823;0
WireConnection;916;183;921;0
WireConnection;916;5;1393;0
WireConnection;701;0;700;0
WireConnection;1074;0;1079;0
WireConnection;1074;1;1051;0
WireConnection;1074;2;1103;0
WireConnection;1390;0;1377;0
WireConnection;913;0;883;0
WireConnection;913;1;817;0
WireConnection;1376;0;1072;0
WireConnection;1088;1;1105;0
WireConnection;1088;0;1149;0
WireConnection;1105;158;1197;0
WireConnection;1105;183;1099;0
WireConnection;1105;5;1391;0
WireConnection;428;0;1544;0
WireConnection;420;0;425;0
WireConnection;420;1;422;0
WireConnection;811;0;926;0
WireConnection;811;1;928;0
WireConnection;1434;0;1433;0
WireConnection;1434;1;617;0
WireConnection;1434;2;1435;0
WireConnection;1427;0;1428;0
WireConnection;1427;1;909;0
WireConnection;1427;2;1429;0
WireConnection;332;0;395;0
WireConnection;332;1;601;0
WireConnection;1389;0;1376;0
WireConnection;839;0;809;0
WireConnection;1502;0;1509;0
WireConnection;1502;1;1503;0
WireConnection;162;0;176;0
WireConnection;202;0;190;0
WireConnection;1501;0;1499;0
WireConnection;1501;1;1500;0
WireConnection;1496;0;1510;0
WireConnection;253;0;285;0
WireConnection;253;1;297;0
WireConnection;1521;0;429;0
WireConnection;1521;1;432;0
WireConnection;1544;1;1543;0
WireConnection;1544;2;1546;0
WireConnection;1131;0;1045;0
WireConnection;431;0;429;0
WireConnection;1546;0;1545;0
WireConnection;1545;0;429;0
WireConnection;1510;1;1511;0
WireConnection;1510;0;1508;0
WireConnection;1508;0;1498;0
WireConnection;1508;1;1502;0
WireConnection;1498;0;1493;0
WireConnection;1498;1;1499;0
WireConnection;1498;2;1501;0
WireConnection;2;2;286;0
ASEEND*/
//CHKSM=A19618E88C4DBFAABA24F4B408141CAEDE2768DF
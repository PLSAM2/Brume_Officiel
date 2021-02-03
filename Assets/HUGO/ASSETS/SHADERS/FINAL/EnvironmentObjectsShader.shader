// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EnvironmentObjectsShader"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Header(OutInBrume)]_Out_or_InBrume("Out_or_InBrume?", Range( 0 , 1)) = 0
		[Header(Debug)]_LightDebug("LightDebug", Range( 0 , 1)) = 0
		_NormalDebug("NormalDebug", Range( 0 , 1)) = 0
		_Grayscale("Grayscale?", Range( 0 , 1)) = 0
		_BaseColor("BaseColor?", Range( 0 , 1)) = 0
		_OutBrumeBaseColor("OutBrumeBaseColor", Color) = (0,0,0,0)
		[Header(OtherProperties)]_CustomWorldSpaceNormal("CustomWorldSpaceNormal?", Range( 0 , 1)) = 0
		_Opacity("Opacity?", Range( 0 , 1)) = 1
		_CustomOpacityMask("CustomOpacityMask?", Range( 0 , 1)) = 0
		_InverseCustomOpacityMask("InverseCustomOpacityMask?", Range( 0 , 1)) = 0
		_ObjectTextureArray("Object Texture Array", 2DArray) = "white" {}
		[Header(TerrainBlending)]_TerrainBlending("TerrainBlending?", Range( 0 , 1)) = 0
		_TerrainBlending_TextureTerrain("TerrainBlending_TextureTerrain", 2D) = "white" {}
		_TerrainBlending_Color("TerrainBlending_Color", Color) = (1,1,1,0)
		_TerrainBlending_Opacity("TerrainBlending_Opacity", Range( 0 , 1)) = 0
		_TerrainBlending_TextureTiling("TerrainBlending_TextureTiling", Float) = 1
		_TerrainBlending_BlendThickness("TerrainBlending_BlendThickness", Range( 0 , 30)) = 0
		_TerrainBlending_Falloff("TerrainBlending_Falloff", Range( 0 , 30)) = 0
		_TerrainBlendingNoise_Texture("TerrainBlendingNoise_Texture", 2D) = "white" {}
		_TerrainBlendingNoise_Tiling("TerrainBlendingNoise_Tiling", Vector) = (1,1,0,0)
		_NoiseandGrungeOutBrumeTextureArray("Noise and Grunge OutBrume Texture Array", 2DArray) = "white" {}
		[Header(Paper)]_MovingPaper("MovingPaper?", Range( 0 , 1)) = 0
		_Paper_Tiling("Paper_Tiling", Float) = 1
		_Paper_Flipbook_Columns("Paper_Flipbook_Columns", Float) = 1
		_Paper_Flipbook_Rows("Paper_Flipbook_Rows", Float) = 1
		_Paper_Flipbook_Speed("Paper_Flipbook_Speed", Float) = 1
		_PaperContrast("PaperContrast", Color) = (0.5660378,0.5660378,0.5660378,0)
		_PaperMultiply("PaperMultiply", Float) = 1.58
		[Header(Ink Grunge)]_InkGrunge_Texture("InkGrunge_Texture", 2D) = "white" {}
		_InkGrunge_Tiling("InkGrunge_Tiling", Float) = 1
		_InkGrunge_Contrast("InkGrunge_Contrast", Float) = 0
		_InkGrunge_Multiply("InkGrunge_Multiply", Float) = 0
		[Header(Shadow and NoiseEdge)]_Noise_Tiling("Noise_Tiling", Float) = 1
		_ScreenBasedNoise("ScreenBasedNoise?", Range( 0 , 1)) = 0
		_Noise_Panner("Noise_Panner", Vector) = (0.2,-0.1,0,0)
		_StepShadow("StepShadow", Float) = 0.03
		_StepAttenuation("StepAttenuation", Float) = 0.3
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		[Header(Specular)]_Specular("Specular?", Range( 0 , 1)) = 0
		_SpeculartStepMin("SpeculartStepMin", Float) = 0
		_SpecularStepMax("SpecularStepMax", Float) = 1
		_SpecularNoise("SpecularNoise", Float) = 1
		_SpecularColor("SpecularColor", Color) = (0.9433962,0.8590411,0.6274475,0)
		_Roughness_Multiplier("Roughness_Multiplier", Float) = 1
		[Header(Top Texture)]_TopTex("TopTex?", Range( 0 , 1)) = 0
		_TopTex_Albedo_Texture("TopTex_ Albedo_Texture", 2D) = "white" {}
		_TopTex_Tiling("TopTex_Tiling", Vector) = (1,1,0,0)
		_TopTex_Noise_Texture("TopTex_Noise_Texture", 2D) = "white" {}
		_TopTex_NoiseHoles("TopTex_NoiseHoles?", Range( 0 , 1)) = 0
		_TopTex_NoiseTiling("TopTex_NoiseTiling", Float) = 1
		_TopTex_NoiseOffset("TopTex_NoiseOffset", Vector) = (0,0,0,0)
		_TopTex_Step("TopTex_Step", Float) = 0
		_TopTex_Smoothstep("TopTex_Smoothstep", Float) = 0.3
		[Header(SubSurface Scattering)]_SSS("SSS?", Range( 0 , 1)) = 0
		_SSS_Distortion("SSS_Distortion", Range( 0 , 1)) = 0.8
		_SSS_Color("SSS_Color", Color) = (1,0,0,0)
		_SSS_Scale("SSS_Scale", Float) = 0.46
		_SSS_Power("SSS_Power", Float) = 0.25
		[Header(Custom Rim Light)]_CustomRimLight("CustomRimLight?", Range( 0 , 1)) = 0
		_CustomRimLight_Color("CustomRimLight_Color", Color) = (1,1,1,0)
		_CustomRimLight_Opacity("CustomRimLight_Opacity", Float) = 1
		_OutBrumeColorCorrection("OutBrumeColorCorrection", Color) = (1,1,1,0)
		_InBrumeTextureArray("InBrume Texture Array", 2DArray) = "white" {}
		_ColorShadow("ColorShadow", Color) = (0.5283019,0.5283019,0.5283019,0)
		_InBrumeBackColor("InBrumeBackColor", Color) = (1,1,1,0)
		_ShadowDrippingNoise_Transition("ShadowDrippingNoise_Transition", Range( 0 , 1)) = 1
		_ShadowDrippingNoise_Smoothstep("ShadowDrippingNoise_Smoothstep", Range( 0.001 , 0.5)) = 0.2
		_ShadowDrippingNoise_Step("ShadowDrippingNoise_Step", Range( 0 , 1)) = 0
		_DrippingNoise_Tiling("ShadowDrippingNoise_Tiling", Float) = 1
		_ShadowDrippingNoise_Offset("ShadowDrippingNoise_Offset", Vector) = (0,0,0,0)
		_NormalDrippingNoise_Smoothstep("NormalDrippingNoise_Smoothstep", Range( 0 , 1)) = 0.01
		_NormalDrippingNoise_Step("NormalDrippingNoise_Step", Range( 0 , 1)) = 0.45
		_NormalDrippingNoise_Tiling("NormalDrippingNoise_Tiling", Float) = 1
		_NormalDrippingNoise_Offset("NormalDrippingNoise_Offset", Vector) = (0,0,0,0)
		_InBrumeGrunge_Texture2("ShadowInBrumeGrunge_Texture", 2D) = "white" {}
		_ShadowInBrumeGrunge_Tiling("ShadowInBrumeGrunge_Tiling", Float) = 0.2
		_ShadowInBrumeGrunge_Contrast("ShadowInBrumeGrunge_Contrast", Float) = -3.38
		_InBrumeGrunge_Texture("NormalInBrumeGrunge_Texture", 2D) = "white" {}
		_NormalInBrumeGrunge_Tiling("NormalInBrumeGrunge_Tiling", Float) = 0.2
		_NormalInBrumeGrunge_Contrast("NormalInBrumeGrunge_Contrast", Float) = 2.4
		_InBrumeColorCorrection("InBrumeColorCorrection", Color) = (1,1,1,0)
		[Header(Wind)]_WindVertexDisplacement("WindVertexDisplacement?", Range( 0 , 1)) = 0
		_Wind_Noise_Texture("Wind_Noise_Texture", 2D) = "white" {}
		_Wind_Texture_Tiling("Wind_Texture_Tiling", Float) = 0.5
		_Wind_Direction("Wind_Direction", Float) = 1
		_Wind_Density("Wind_Density", Float) = 0.2
		_Wind_Strength("Wind_Strength", Float) = 2
		_WindWave_Speed("WindWave_Speed", Vector) = (0.1,0,0,0)
		_WindWave_Min_Speed("WindWave_Min_Speed", Vector) = (0.05,0,0,0)
		_Wave_Speed("Wave_Speed", Float) = 0
		[Header(Depth Fade)]_DepthFade("DepthFade?", Range( 0 , 1)) = 1
		_DepthFade_Texture("DepthFade_Texture?", Range( 0 , 1)) = 0
		_DepthFade_Dither_Texture("DepthFade_Dither_Texture", 2D) = "white" {}
		_DepthFade_Dither_Tiling("DepthFade_Dither_Tiling", Float) = 1
		_DepthFade_DitherMultiply("DepthFade_DitherMultiply", Float) = 1
		_DepthFade_Falloff("DepthFade_Falloff", Float) = 3
		_DepthFade_Distance("DepthFade_Distance", Float) = 10.5
		_DepthFade_ClampMin("DepthFade_ClampMin", Range( 0 , 1)) = 1
		[ASEEnd]_DepthFade_ClampMax("DepthFade_ClampMax", Range( 0 , 1)) = 0.8

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
			
			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0,0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define _ALPHATEST_ON 1
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

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#define ASE_NEEDS_VERT_POSITION
			#pragma multi_compile_instancing
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
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
			float4 _SSS_Color;
			float4 _OutBrumeColorCorrection;
			float4 _ShadowColor;
			float4 _TerrainBlending_Color;
			float4 _PaperContrast;
			float4 _InBrumeBackColor;
			float4 _OutBrumeBaseColor;
			float4 _InBrumeColorCorrection;
			float4 _CustomRimLight_Color;
			float4 _SpecularColor;
			float4 _ColorShadow;
			float2 _WindWave_Speed;
			float2 _ShadowDrippingNoise_Offset;
			float2 _WindWave_Min_Speed;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _NormalDrippingNoise_Offset;
			float2 _TopTex_NoiseOffset;
			float2 _Noise_Panner;
			float2 _TopTex_Tiling;
			float _ShadowDrippingNoise_Smoothstep;
			float _CustomRimLight_Opacity;
			float _SSS_Scale;
			float _DrippingNoise_Tiling;
			float _SSS_Power;
			float _SSS;
			float _CustomRimLight;
			float _SSS_Distortion;
			float _ShadowDrippingNoise_Step;
			float _ShadowInBrumeGrunge_Contrast;
			float _ShadowInBrumeGrunge_Tiling;
			float _DepthFade_ClampMin;
			float _DepthFade_DitherMultiply;
			float _DepthFade_Texture;
			float _DepthFade_Dither_Tiling;
			float _DepthFade_Distance;
			float _DepthFade_Falloff;
			float _Opacity;
			float _CustomOpacityMask;
			float _InverseCustomOpacityMask;
			float _TerrainBlending_Opacity;
			float _NormalDebug;
			float _LightDebug;
			float _NormalDrippingNoise_Tiling;
			float _NormalDrippingNoise_Smoothstep;
			float _NormalDrippingNoise_Step;
			float _NormalInBrumeGrunge_Tiling;
			float _NormalInBrumeGrunge_Contrast;
			float _ShadowDrippingNoise_Transition;
			float _Wind_Texture_Tiling;
			float _StepAttenuation;
			float _Noise_Tiling;
			float _Paper_Flipbook_Rows;
			float _Paper_Flipbook_Columns;
			float _Paper_Tiling;
			float _Specular;
			float _SpecularNoise;
			float _SpecularStepMax;
			float _Paper_Flipbook_Speed;
			float _SpeculartStepMin;
			float _Out_or_InBrume;
			float _WindVertexDisplacement;
			float _Wind_Strength;
			float _Wind_Density;
			float _Wind_Direction;
			float _Wave_Speed;
			float _Roughness_Multiplier;
			float _MovingPaper;
			float _PaperMultiply;
			float _InkGrunge_Contrast;
			float _CustomWorldSpaceNormal;
			float _DepthFade_ClampMax;
			float _StepShadow;
			float _TopTex;
			float _TopTex_NoiseTiling;
			float _TopTex_Smoothstep;
			float _TopTex_Step;
			float _TerrainBlending;
			float _TerrainBlending_Falloff;
			float _TerrainBlending_BlendThickness;
			float _TerrainBlending_TextureTiling;
			float _Grayscale;
			float _BaseColor;
			float _InkGrunge_Multiply;
			float _InkGrunge_Tiling;
			float _ScreenBasedNoise;
			float _DepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Wind_Noise_Texture;
			TEXTURE2D_ARRAY(_ObjectTextureArray);
			SAMPLER(sampler_ObjectTextureArray);
			TEXTURE2D_ARRAY(_NoiseandGrungeOutBrumeTextureArray);
			SAMPLER(sampler_NoiseandGrungeOutBrumeTextureArray);
			sampler2D _InkGrunge_Texture;
			sampler2D _TerrainBlending_TextureTerrain;
			sampler2D TB_DEPTH;
			float TB_OFFSET_X;
			float TB_OFFSET_Z;
			float TB_SCALE;
			float TB_FARCLIP;
			float TB_OFFSET_Y;
			sampler2D _TerrainBlendingNoise_Texture;
			sampler2D _TopTex_Albedo_Texture;
			sampler2D _TopTex_Noise_Texture;
			TEXTURE2D_ARRAY(_InBrumeTextureArray);
			SAMPLER(sampler_InBrumeTextureArray);
			sampler2D _InBrumeGrunge_Texture2;
			sampler2D _InBrumeGrunge_Texture;
			sampler2D _DepthFade_Dither_Texture;
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
				UNITY_DEFINE_INSTANCED_PROP(float, _TopTex_NoiseHoles)
			UNITY_INSTANCING_BUFFER_END(EnvironmentObjectsShader)


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
			
			void TriplanarWeights108_g23( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			inline float4 TriplanarSampling1360( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
			}
			
			inline float4 TriplanarSampling1599( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
			}
			
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 temp_cast_0 = (0.0).xxxx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _Wave_Speed ) * _WindWave_Speed + float2( 0,0 ));
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + float2( 0,0 ));
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( ( panner1312 + panner1313 ) * _Wind_Direction );
				float4 temp_cast_2 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_3 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( ( tex2Dlod( _Wind_Noise_Texture, float4( texCoord1319, 0, 0.0) ) - temp_cast_2 ) * _Wind_Strength ) + float4( 0,0,0,0 ) ) , temp_cast_3 , v.ase_color);
				float4 WindVertexDisplacement1330 = lerpResult1328;
				float4 lerpResult1407 = lerp( temp_cast_0 , WindVertexDisplacement1330 , _WindVertexDisplacement);
				float4 temp_cast_4 = (0.0).xxxx;
				float4 lerpResult1609 = lerp( lerpResult1407 , temp_cast_4 , _Out_or_InBrume);
				
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord4.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord5.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord6.xyz = ase_worldBitangent;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord7 = screenPos;
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord3.z = eyeDepth;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = lerpResult1609.rgb;
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
				float4 ase_color : COLOR;
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
				o.ase_color = v.ase_color;
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
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
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
				float2 texCoord1622 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 TextureCoordinates1629 = texCoord1622;
				float4 Object_Roughness_Texture1455 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,2.0 );
				float4 temp_output_522_0 = ( ( 1.0 - Object_Roughness_Texture1455 ) * _Roughness_Multiplier );
				float4 temp_cast_1 = (0.0).xxxx;
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 normalizeResult4_g24 = normalize( ( ase_worldViewDir + SafeNormalize(_MainLightPosition.xyz) ) );
				float4 Object_Normal_Texture1454 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,1.0 );
				float3 ase_worldTangent = IN.ase_texcoord4.xyz;
				float3 ase_worldNormal = IN.ase_texcoord5.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord6.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal498 = Object_Normal_Texture1454.rgb;
				float3 worldNormal498 = float3(dot(tanToWorld0,tanNormal498), dot(tanToWorld1,tanNormal498), dot(tanToWorld2,tanNormal498));
				float3 normalizeResult499 = normalize( worldNormal498 );
				float dotResult504 = dot( normalizeResult4_g24 , normalizeResult499 );
				float smoothstepResult632 = smoothstep( _SpeculartStepMin , _SpecularStepMax , max( dotResult504 , 0.0 ));
				float4 temp_cast_3 = (smoothstepResult632).xxxx;
				float2 temp_cast_4 = (_SpecularNoise).xx;
				float2 texCoord626 = IN.ase_texcoord3.xy * temp_cast_4 + float2( 0,0 );
				float grayscale634 = Luminance(step( ( temp_cast_3 - SAMPLE_TEXTURE2D_ARRAY( _NoiseandGrungeOutBrumeTextureArray, sampler_NoiseandGrungeOutBrumeTextureArray, texCoord626,1.0 ) ) , float4( 0,0,0,0 ) ).rgb);
				float4 lerpResult1401 = lerp( temp_cast_1 , ( (0.0 + (grayscale634 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) * _SpecularColor ) , _Specular);
				float4 RoughnessNormal1585 = ( float4( (temp_output_522_0).rgb , 0.0 ) * (temp_output_522_0).a * lerpResult1401 );
				float4 screenPos = IN.ase_texcoord7;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_output_466_0 = ( (ase_screenPosNorm).xy * _Paper_Tiling );
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles664 = _Paper_Flipbook_Columns * _Paper_Flipbook_Rows;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset664 = 1.0f / _Paper_Flipbook_Columns;
				float fbrowsoffset664 = 1.0f / _Paper_Flipbook_Rows;
				// Speed of animation
				float fbspeed664 = _TimeParameters.x * _Paper_Flipbook_Speed;
				// UV Tiling (col and row offset)
				float2 fbtiling664 = float2(fbcolsoffset664, fbrowsoffset664);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex664 = round( fmod( fbspeed664 + 0.0, fbtotaltiles664) );
				fbcurrenttileindex664 += ( fbcurrenttileindex664 < 0) ? fbtotaltiles664 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox664 = round ( fmod ( fbcurrenttileindex664, _Paper_Flipbook_Columns ) );
				// Multiply Offset X by coloffset
				float fboffsetx664 = fblinearindextox664 * fbcolsoffset664;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy664 = round( fmod( ( fbcurrenttileindex664 - fblinearindextox664 ) / _Paper_Flipbook_Columns, _Paper_Flipbook_Rows ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy664 = (int)(_Paper_Flipbook_Rows-1) - fblinearindextoy664;
				// Multiply Offset Y by rowoffset
				float fboffsety664 = fblinearindextoy664 * fbrowsoffset664;
				// UV Offset
				float2 fboffset664 = float2(fboffsetx664, fboffsety664);
				// Flipbook UV
				half2 fbuv664 = temp_output_466_0 * fbtiling664 + fboffset664;
				// *** END Flipbook UV Animation vars ***
				float2 lerpResult1411 = lerp( temp_output_466_0 , fbuv664 , _MovingPaper);
				float3 temp_cast_6 = (SAMPLE_TEXTURE2D_ARRAY( _NoiseandGrungeOutBrumeTextureArray, sampler_NoiseandGrungeOutBrumeTextureArray, lerpResult1411,0.0 ).r).xxx;
				float grayscale455 = Luminance(temp_cast_6);
				float localStochasticTiling53_g23 = ( 0.0 );
				float2 temp_cast_7 = (_InkGrunge_Tiling).xx;
				float2 temp_output_104_0_g23 = temp_cast_7;
				float3 temp_output_80_0_g23 = WorldPosition;
				float2 Triplanar_UV050_g23 = ( temp_output_104_0_g23 * (temp_output_80_0_g23).zy );
				float2 UV53_g23 = Triplanar_UV050_g23;
				float2 UV153_g23 = float2( 0,0 );
				float2 UV253_g23 = float2( 0,0 );
				float2 UV353_g23 = float2( 0,0 );
				float W153_g23 = 0.0;
				float W253_g23 = 0.0;
				float W353_g23 = 0.0;
				StochasticTiling( UV53_g23 , UV153_g23 , UV253_g23 , UV353_g23 , W153_g23 , W253_g23 , W353_g23 );
				float2 temp_output_57_0_g23 = ddx( Triplanar_UV050_g23 );
				float2 temp_output_58_0_g23 = ddy( Triplanar_UV050_g23 );
				float localTriplanarWeights108_g23 = ( 0.0 );
				float3 WorldNormal108_g23 = ase_worldNormal;
				float W0108_g23 = 0.0;
				float W1108_g23 = 0.0;
				float W2108_g23 = 0.0;
				TriplanarWeights108_g23( WorldNormal108_g23 , W0108_g23 , W1108_g23 , W2108_g23 );
				float localStochasticTiling83_g23 = ( 0.0 );
				float2 Triplanar_UV164_g23 = ( temp_output_104_0_g23 * (temp_output_80_0_g23).zx );
				float2 UV83_g23 = Triplanar_UV164_g23;
				float2 UV183_g23 = float2( 0,0 );
				float2 UV283_g23 = float2( 0,0 );
				float2 UV383_g23 = float2( 0,0 );
				float W183_g23 = 0.0;
				float W283_g23 = 0.0;
				float W383_g23 = 0.0;
				StochasticTiling( UV83_g23 , UV183_g23 , UV283_g23 , UV383_g23 , W183_g23 , W283_g23 , W383_g23 );
				float2 temp_output_86_0_g23 = ddx( Triplanar_UV164_g23 );
				float2 temp_output_92_0_g23 = ddy( Triplanar_UV164_g23 );
				float localStochasticTiling117_g23 = ( 0.0 );
				float2 Triplanar_UV271_g23 = ( temp_output_104_0_g23 * (temp_output_80_0_g23).xy );
				float2 UV117_g23 = Triplanar_UV271_g23;
				float2 UV1117_g23 = float2( 0,0 );
				float2 UV2117_g23 = float2( 0,0 );
				float2 UV3117_g23 = float2( 0,0 );
				float W1117_g23 = 0.0;
				float W2117_g23 = 0.0;
				float W3117_g23 = 0.0;
				StochasticTiling( UV117_g23 , UV1117_g23 , UV2117_g23 , UV3117_g23 , W1117_g23 , W2117_g23 , W3117_g23 );
				float2 temp_output_107_0_g23 = ddx( Triplanar_UV271_g23 );
				float2 temp_output_110_0_g23 = ddy( Triplanar_UV271_g23 );
				float4 Output_Triplanar295_g23 = ( ( ( ( tex2D( _InkGrunge_Texture, UV153_g23, temp_output_57_0_g23, temp_output_58_0_g23 ) * W153_g23 ) + ( tex2D( _InkGrunge_Texture, UV253_g23, temp_output_57_0_g23, temp_output_58_0_g23 ) * W253_g23 ) + ( tex2D( _InkGrunge_Texture, UV353_g23, temp_output_57_0_g23, temp_output_58_0_g23 ) * W353_g23 ) ) * W0108_g23 ) + ( W1108_g23 * ( ( tex2D( _InkGrunge_Texture, UV183_g23, temp_output_86_0_g23, temp_output_92_0_g23 ) * W183_g23 ) + ( tex2D( _InkGrunge_Texture, UV283_g23, temp_output_86_0_g23, temp_output_92_0_g23 ) * W283_g23 ) + ( tex2D( _InkGrunge_Texture, UV383_g23, temp_output_86_0_g23, temp_output_92_0_g23 ) * W383_g23 ) ) ) + ( W2108_g23 * ( ( tex2D( _InkGrunge_Texture, UV1117_g23, temp_output_107_0_g23, temp_output_110_0_g23 ) * W1117_g23 ) + ( tex2D( _InkGrunge_Texture, UV2117_g23, temp_output_107_0_g23, temp_output_110_0_g23 ) * W2117_g23 ) + ( tex2D( _InkGrunge_Texture, UV3117_g23, temp_output_107_0_g23, temp_output_110_0_g23 ) * W3117_g23 ) ) ) );
				float4 tex2DArrayNode1711 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,0.0 );
				float4 Object_Albedo_Texture1453 = tex2DArrayNode1711;
				float4 lerpResult1757 = lerp( Object_Albedo_Texture1453 , _OutBrumeBaseColor , _BaseColor);
				float4 temp_output_842_0 = ( _OutBrumeColorCorrection * lerpResult1757 );
				float grayscale1613 = dot(temp_output_842_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_9 = (grayscale1613).xxxx;
				float4 lerpResult1612 = lerp( temp_output_842_0 , temp_cast_9 , _Grayscale);
				float4 blendOpSrc461 = ( ( ( grayscale455 + _PaperContrast ) * _PaperMultiply ) * ( CalculateContrast(_InkGrunge_Contrast,Output_Triplanar295_g23) * _InkGrunge_Multiply ).r );
				float4 blendOpDest461 = lerpResult1612;
				float4 RGB1366 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
				float2 temp_cast_10 = (_TerrainBlending_TextureTiling).xx;
				float2 texCoord1373 = IN.ase_texcoord3.xy * temp_cast_10 + float2( 0,0 );
				float worldY1344 = WorldPosition.y;
				float4 temp_cast_11 = (worldY1344).xxxx;
				float2 appendResult1340 = (float2(WorldPosition.x , WorldPosition.z));
				float2 appendResult1339 = (float2(TB_OFFSET_X , TB_OFFSET_Z));
				float4 temp_cast_12 = (TB_OFFSET_Y).xxxx;
				float4 triplanar1360 = TriplanarSampling1360( _TerrainBlendingNoise_Texture, WorldPosition, ase_worldNormal, 1.0, _TerrainBlendingNoise_Tiling, 1.0, 0 );
				float4 clampResult1354 = clamp( ( ( ( temp_cast_11 - ( tex2D( TB_DEPTH, ( ( appendResult1340 - appendResult1339 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_12 ) / ( _TerrainBlending_BlendThickness * triplanar1360 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_14 = (_TerrainBlending_Falloff).xxxx;
				float4 clampResult1356 = clamp( pow( clampResult1354 , temp_cast_14 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult1358 = lerp( ( tex2D( _TerrainBlending_TextureTerrain, texCoord1373 ) * _TerrainBlending_Color ) , RGB1366 , clampResult1356.r);
				float4 RBG_TerrainBlending1368 = lerpResult1358;
				float4 lerpResult1468 = lerp( RGB1366 , RBG_TerrainBlending1368 , _TerrainBlending);
				float4 triplanar1599 = TriplanarSampling1599( _TopTex_Albedo_Texture, WorldPosition, ase_worldNormal, 1.0, _TopTex_Tiling, 1.0, 0 );
				float3 tanNormal1555 = Object_Normal_Texture1454.rgb;
				float3 worldNormal1555 = float3(dot(tanToWorld0,tanNormal1555), dot(tanToWorld1,tanNormal1555), dot(tanToWorld2,tanNormal1555));
				float dotResult1557 = dot( worldNormal1555 , float3(0,1,0) );
				float smoothstepResult1559 = smoothstep( _TopTex_Step , ( _TopTex_Step + _TopTex_Smoothstep ) , dotResult1557);
				float2 temp_cast_18 = (_TopTex_NoiseTiling).xx;
				float2 texCoord1556 = IN.ase_texcoord3.xy * temp_cast_18 + _TopTex_NoiseOffset;
				float4 tex2DNode1582 = tex2D( _TopTex_Noise_Texture, texCoord1556 );
				float smoothstepResult1563 = smoothstep( 0.0 , 0.25 , ( smoothstepResult1559 - tex2DNode1582.r ));
				float _TopTex_NoiseHoles_Instance = UNITY_ACCESS_INSTANCED_PROP(EnvironmentObjectsShader,_TopTex_NoiseHoles);
				float lerpResult1595 = lerp( 0.0 , step( tex2DNode1582.r , 0.34 ) , _TopTex_NoiseHoles_Instance);
				float temp_output_1565_0 = ( smoothstepResult1563 - lerpResult1595 );
				float clampResult1552 = clamp( temp_output_1565_0 , 0.0 , 1.0 );
				float4 TopTex1584 = ( ( triplanar1599 * dotResult1557 ) * clampResult1552 );
				float4 blendOpSrc1592 = lerpResult1468;
				float4 blendOpDest1592 = TopTex1584;
				float TopTexMask1606 = temp_output_1565_0;
				float4 lerpBlendMode1592 = lerp(blendOpDest1592,max( blendOpSrc1592, blendOpDest1592 ),( 1.0 - TopTexMask1606 ));
				float4 lerpResult1588 = lerp( lerpResult1468 , ( saturate( lerpBlendMode1592 )) , _TopTex);
				float temp_output_387_0 = ( _StepShadow + _StepAttenuation );
				float4 lerpResult1410 = lerp( float4( float3(0,0,1) , 0.0 ) , Object_Normal_Texture1454 , _CustomWorldSpaceNormal);
				float3 tanNormal10 = lerpResult1410.rgb;
				float3 worldNormal10 = float3(dot(tanToWorld0,tanNormal10), dot(tanToWorld1,tanNormal10), dot(tanToWorld2,tanNormal10));
				float dotResult12 = dot( worldNormal10 , SafeNormalize(_MainLightPosition.xyz) );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir23 = ( dotResult12 * ase_lightAtten );
				float smoothstepResult385 = smoothstep( _StepShadow , temp_output_387_0 , normal_LightDir23);
				float2 temp_cast_22 = (_Noise_Tiling).xx;
				float2 texCoord565 = IN.ase_texcoord3.xy * temp_cast_22 + float2( 0,0 );
				float2 lerpResult1413 = lerp( texCoord565 , ( (ase_screenPosNorm).xy * _Noise_Tiling ) , _ScreenBasedNoise);
				float2 panner571 = ( 1.0 * _Time.y * ( _Noise_Panner + float2( 0.1,0.05 ) ) + lerpResult1413);
				float2 panner484 = ( 1.0 * _Time.y * _Noise_Panner + lerpResult1413);
				float blendOpSrc570 = SAMPLE_TEXTURE2D_ARRAY( _NoiseandGrungeOutBrumeTextureArray, sampler_NoiseandGrungeOutBrumeTextureArray, ( panner571 + float2( 0.5,0.5 ) ),1.0 ).r;
				float blendOpDest570 = SAMPLE_TEXTURE2D_ARRAY( _NoiseandGrungeOutBrumeTextureArray, sampler_NoiseandGrungeOutBrumeTextureArray, panner484,1.0 ).r;
				float MapNoise481 = ( saturate( 2.0f*blendOpDest570*blendOpSrc570 + blendOpDest570*blendOpDest570*(1.0f - 2.0f*blendOpSrc570) ));
				float smoothstepResult401 = smoothstep( 0.0 , 0.6 , ( smoothstepResult385 - MapNoise481 ));
				float smoothstepResult445 = smoothstep( ( _StepShadow + -0.02 ) , ( temp_output_387_0 + -0.02 ) , normal_LightDir23);
				float blendOpSrc444 = smoothstepResult401;
				float blendOpDest444 = smoothstepResult445;
				float4 temp_cast_23 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest444) / max( blendOpSrc444, 0.00001) ) ) ))).xxxx;
				float4 blendOpSrc449 = temp_cast_23;
				float4 blendOpDest449 = _ShadowColor;
				float4 temp_output_449_0 = ( saturate( ( blendOpSrc449 * blendOpDest449 ) ));
				float4 temp_output_562_0 = step( temp_output_449_0 , float4( 0,0,0,0 ) );
				float4 Shadow877 = ( temp_output_562_0 + temp_output_449_0 );
				float4 blendOpSrc428 = lerpResult1588;
				float4 blendOpDest428 = Shadow877;
				float4 temp_output_518_0 = ( RoughnessNormal1585 + float4( (( saturate( ( blendOpSrc428 * blendOpDest428 ) ))).rgb , 0.0 ) );
				float3 tanNormal1286 = Object_Normal_Texture1454.rgb;
				float3 worldNormal1286 = float3(dot(tanToWorld0,tanNormal1286), dot(tanToWorld1,tanNormal1286), dot(tanToWorld2,tanNormal1286));
				float dotResult1283 = dot( ase_worldViewDir , -( SafeNormalize(_MainLightPosition.xyz) + ( worldNormal1286 * _SSS_Distortion ) ) );
				float dotResult1293 = dot( dotResult1283 , _SSS_Scale );
				float saferPower1296 = max( dotResult1293 , 0.0001 );
				float4 SSS1275 = ( _SSS_Color * saturate( pow( saferPower1296 , _SSS_Power ) ) );
				float4 blendOpSrc1290 = temp_output_518_0;
				float4 blendOpDest1290 = SSS1275;
				float4 lerpResult1398 = lerp( temp_output_518_0 , ( saturate( max( blendOpSrc1290, blendOpDest1290 ) )) , _SSS);
				float4 Object_RimLightMask_Texture1456 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,3.0 );
				float4 CustomRimLight1389 = ( ( Object_RimLightMask_Texture1456 * _CustomRimLight_Opacity ) * _CustomRimLight_Color );
				float4 blendOpSrc1395 = lerpResult1398;
				float4 blendOpDest1395 = CustomRimLight1389;
				float4 lerpResult1397 = lerp( lerpResult1398 , ( saturate( max( blendOpSrc1395, blendOpDest1395 ) )) , _CustomRimLight);
				float4 EndOutBrume473 = lerpResult1397;
				float smoothstepResult1227 = smoothstep( ( _ShadowDrippingNoise_Smoothstep + _ShadowDrippingNoise_Step ) , _ShadowDrippingNoise_Step , normal_LightDir23);
				float4 temp_cast_27 = (smoothstepResult1227).xxxx;
				float2 temp_cast_28 = (_DrippingNoise_Tiling).xx;
				float2 texCoord1203 = IN.ase_texcoord3.xy * temp_cast_28 + _ShadowDrippingNoise_Offset;
				float4 temp_output_1228_0 = ( temp_cast_27 - SAMPLE_TEXTURE2D_ARRAY( _InBrumeTextureArray, sampler_InBrumeTextureArray, texCoord1203,1.0 ) );
				float4 temp_cast_29 = (step( normal_LightDir23 , _ShadowDrippingNoise_Step )).xxxx;
				float4 blendOpSrc1231 = temp_output_1228_0;
				float4 blendOpDest1231 = temp_cast_29;
				float4 temp_cast_30 = (smoothstepResult1227).xxxx;
				float4 lerpBlendMode1231 = lerp(blendOpDest1231,max( blendOpSrc1231, blendOpDest1231 ),( 1.0 - step( temp_output_1228_0 , float4( 0,0,0,0 ) ) ).r);
				float4 temp_cast_32 = (step( normal_LightDir23 , _ShadowDrippingNoise_Step )).xxxx;
				float4 lerpResult1220 = lerp( ( saturate( lerpBlendMode1231 )) , temp_cast_32 , _ShadowDrippingNoise_Transition);
				float4 ShadowDrippingNoise1240 = lerpResult1220;
				float localStochasticTiling2_g26 = ( 0.0 );
				float2 temp_cast_33 = (_ShadowInBrumeGrunge_Tiling).xx;
				float2 texCoord1754 = IN.ase_texcoord3.xy * temp_cast_33 + float2( 0,0 );
				float2 Input_UV145_g26 = texCoord1754;
				float2 UV2_g26 = Input_UV145_g26;
				float2 UV12_g26 = float2( 0,0 );
				float2 UV22_g26 = float2( 0,0 );
				float2 UV32_g26 = float2( 0,0 );
				float W12_g26 = 0.0;
				float W22_g26 = 0.0;
				float W32_g26 = 0.0;
				StochasticTiling( UV2_g26 , UV12_g26 , UV22_g26 , UV32_g26 , W12_g26 , W22_g26 , W32_g26 );
				float2 temp_output_10_0_g26 = ddx( Input_UV145_g26 );
				float2 temp_output_12_0_g26 = ddy( Input_UV145_g26 );
				float4 Output_2D293_g26 = ( ( tex2D( _InBrumeGrunge_Texture2, UV12_g26, temp_output_10_0_g26, temp_output_12_0_g26 ) * W12_g26 ) + ( tex2D( _InBrumeGrunge_Texture2, UV22_g26, temp_output_10_0_g26, temp_output_12_0_g26 ) * W22_g26 ) + ( tex2D( _InBrumeGrunge_Texture2, UV32_g26, temp_output_10_0_g26, temp_output_12_0_g26 ) * W32_g26 ) );
				float grayscale1119 = Luminance(CalculateContrast(_ShadowInBrumeGrunge_Contrast,Output_2D293_g26).rgb);
				float ShadowInBrumeGrunge1246 = grayscale1119;
				float4 blendOpSrc1162 = ( _InBrumeBackColor * ( 1.0 - ShadowDrippingNoise1240 ).r );
				float4 blendOpDest1162 = ( _ColorShadow * ( ShadowDrippingNoise1240 * ShadowInBrumeGrunge1246 ) );
				float localStochasticTiling2_g25 = ( 0.0 );
				float2 temp_cast_35 = (_NormalInBrumeGrunge_Tiling).xx;
				float2 texCoord1755 = IN.ase_texcoord3.xy * temp_cast_35 + float2( 0,0 );
				float2 Input_UV145_g25 = texCoord1755;
				float2 UV2_g25 = Input_UV145_g25;
				float2 UV12_g25 = float2( 0,0 );
				float2 UV22_g25 = float2( 0,0 );
				float2 UV32_g25 = float2( 0,0 );
				float W12_g25 = 0.0;
				float W22_g25 = 0.0;
				float W32_g25 = 0.0;
				StochasticTiling( UV2_g25 , UV12_g25 , UV22_g25 , UV32_g25 , W12_g25 , W22_g25 , W32_g25 );
				float2 temp_output_10_0_g25 = ddx( Input_UV145_g25 );
				float2 temp_output_12_0_g25 = ddy( Input_UV145_g25 );
				float4 Output_2D293_g25 = ( ( tex2D( _InBrumeGrunge_Texture, UV12_g25, temp_output_10_0_g25, temp_output_12_0_g25 ) * W12_g25 ) + ( tex2D( _InBrumeGrunge_Texture, UV22_g25, temp_output_10_0_g25, temp_output_12_0_g25 ) * W22_g25 ) + ( tex2D( _InBrumeGrunge_Texture, UV32_g25, temp_output_10_0_g25, temp_output_12_0_g25 ) * W32_g25 ) );
				float grayscale1115 = Luminance(CalculateContrast(_NormalInBrumeGrunge_Contrast,Output_2D293_g25).rgb);
				float NormalInBrumeGrunge1247 = grayscale1115;
				float grayscale1105 = (Object_Normal_Texture1454.rgb.r + Object_Normal_Texture1454.rgb.g + Object_Normal_Texture1454.rgb.b) / 3;
				float temp_output_1106_0 = step( grayscale1105 , _NormalDrippingNoise_Step );
				float smoothstepResult1179 = smoothstep( _NormalDrippingNoise_Step , ( _NormalDrippingNoise_Step + _NormalDrippingNoise_Smoothstep ) , grayscale1105);
				float4 temp_cast_38 = (( 1.0 - smoothstepResult1179 )).xxxx;
				float2 temp_cast_39 = (_NormalDrippingNoise_Tiling).xx;
				float2 texCoord1184 = IN.ase_texcoord3.xy * temp_cast_39 + _NormalDrippingNoise_Offset;
				float4 temp_output_1186_0 = ( temp_output_1106_0 + ( temp_cast_38 - SAMPLE_TEXTURE2D_ARRAY( _InBrumeTextureArray, sampler_InBrumeTextureArray, texCoord1184,1.0 ) ) );
				float4 temp_cast_40 = (( 1.0 - smoothstepResult1179 )).xxxx;
				float4 blendOpSrc1189 = ( NormalInBrumeGrunge1247 * temp_output_1186_0 );
				float4 blendOpDest1189 = ( 1.0 - temp_output_1186_0 );
				float4 lerpBlendMode1189 = lerp(blendOpDest1189,max( blendOpSrc1189, blendOpDest1189 ),temp_output_1106_0);
				float4 NormalDrippingGrunge1251 = ( saturate( lerpBlendMode1189 ));
				float4 EndInBrume901 = ( _InBrumeColorCorrection * (float4( 0,0,0,0 ) + (( max( blendOpSrc1162, blendOpDest1162 ) * NormalDrippingGrunge1251 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) );
				float4 lerpResult955 = lerp( EndOutBrume473 , EndInBrume901 , _Out_or_InBrume);
				float4 temp_cast_41 = (normal_LightDir23).xxxx;
				float4 lerpResult1403 = lerp( lerpResult955 , temp_cast_41 , _LightDebug);
				float4 lerpResult1405 = lerp( lerpResult1403 , Object_Normal_Texture1454 , _NormalDebug);
				
				float TerrainBlendingMask1761 = clampResult1356.r;
				float clampResult1771 = clamp( ( TerrainBlendingMask1761 + _TerrainBlending_Opacity ) , 0.0 , 1.0 );
				float Object_Opacity_Texture1457 = tex2DArrayNode1711.a;
				float Object_CustomOpacityMask_Texture1475 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,4.0 ).r;
				float lerpResult1549 = lerp( Object_CustomOpacityMask_Texture1475 , ( 1.0 - Object_CustomOpacityMask_Texture1475 ) , _InverseCustomOpacityMask);
				float lerpResult1472 = lerp( Object_Opacity_Texture1457 , lerpResult1549 , _CustomOpacityMask);
				float lerpResult1416 = lerp( 1.0 , ( clampResult1771 * lerpResult1472 ) , _Opacity);
				float eyeDepth = IN.ase_texcoord3.z;
				float cameraDepthFade1534 = (( eyeDepth -_ProjectionParams.y - _DepthFade_Distance ) / _DepthFade_Falloff);
				float localStochasticTiling2_g18 = ( 0.0 );
				float2 Input_UV145_g18 = ( (ase_screenPosNorm).xy * _DepthFade_Dither_Tiling );
				float2 UV2_g18 = Input_UV145_g18;
				float2 UV12_g18 = float2( 0,0 );
				float2 UV22_g18 = float2( 0,0 );
				float2 UV32_g18 = float2( 0,0 );
				float W12_g18 = 0.0;
				float W22_g18 = 0.0;
				float W32_g18 = 0.0;
				StochasticTiling( UV2_g18 , UV12_g18 , UV22_g18 , UV32_g18 , W12_g18 , W22_g18 , W32_g18 );
				float2 temp_output_10_0_g18 = ddx( Input_UV145_g18 );
				float2 temp_output_12_0_g18 = ddy( Input_UV145_g18 );
				float4 Output_2D293_g18 = ( ( tex2D( _DepthFade_Dither_Texture, UV12_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W12_g18 ) + ( tex2D( _DepthFade_Dither_Texture, UV22_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W22_g18 ) + ( tex2D( _DepthFade_Dither_Texture, UV32_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W32_g18 ) );
				float4 break31_g18 = Output_2D293_g18;
				float lerpResult1542 = lerp( 0.0 , break31_g18.r , _DepthFade_Texture);
				float clampResult1523 = clamp( cameraDepthFade1534 , ( ( lerpResult1542 * _DepthFade_DitherMultiply ) + _DepthFade_ClampMin ) , _DepthFade_ClampMax );
				float lerpResult1540 = lerp( 1.0 , clampResult1523 , _DepthFade);
				float Opacity1375 = ( lerpResult1416 * lerpResult1540 );
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = lerpResult1405.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = Opacity1375;
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
			#define _ALPHATEST_ON 1
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
			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
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
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _SSS_Color;
			float4 _OutBrumeColorCorrection;
			float4 _ShadowColor;
			float4 _TerrainBlending_Color;
			float4 _PaperContrast;
			float4 _InBrumeBackColor;
			float4 _OutBrumeBaseColor;
			float4 _InBrumeColorCorrection;
			float4 _CustomRimLight_Color;
			float4 _SpecularColor;
			float4 _ColorShadow;
			float2 _WindWave_Speed;
			float2 _ShadowDrippingNoise_Offset;
			float2 _WindWave_Min_Speed;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _NormalDrippingNoise_Offset;
			float2 _TopTex_NoiseOffset;
			float2 _Noise_Panner;
			float2 _TopTex_Tiling;
			float _ShadowDrippingNoise_Smoothstep;
			float _CustomRimLight_Opacity;
			float _SSS_Scale;
			float _DrippingNoise_Tiling;
			float _SSS_Power;
			float _SSS;
			float _CustomRimLight;
			float _SSS_Distortion;
			float _ShadowDrippingNoise_Step;
			float _ShadowInBrumeGrunge_Contrast;
			float _ShadowInBrumeGrunge_Tiling;
			float _DepthFade_ClampMin;
			float _DepthFade_DitherMultiply;
			float _DepthFade_Texture;
			float _DepthFade_Dither_Tiling;
			float _DepthFade_Distance;
			float _DepthFade_Falloff;
			float _Opacity;
			float _CustomOpacityMask;
			float _InverseCustomOpacityMask;
			float _TerrainBlending_Opacity;
			float _NormalDebug;
			float _LightDebug;
			float _NormalDrippingNoise_Tiling;
			float _NormalDrippingNoise_Smoothstep;
			float _NormalDrippingNoise_Step;
			float _NormalInBrumeGrunge_Tiling;
			float _NormalInBrumeGrunge_Contrast;
			float _ShadowDrippingNoise_Transition;
			float _Wind_Texture_Tiling;
			float _StepAttenuation;
			float _Noise_Tiling;
			float _Paper_Flipbook_Rows;
			float _Paper_Flipbook_Columns;
			float _Paper_Tiling;
			float _Specular;
			float _SpecularNoise;
			float _SpecularStepMax;
			float _Paper_Flipbook_Speed;
			float _SpeculartStepMin;
			float _Out_or_InBrume;
			float _WindVertexDisplacement;
			float _Wind_Strength;
			float _Wind_Density;
			float _Wind_Direction;
			float _Wave_Speed;
			float _Roughness_Multiplier;
			float _MovingPaper;
			float _PaperMultiply;
			float _InkGrunge_Contrast;
			float _CustomWorldSpaceNormal;
			float _DepthFade_ClampMax;
			float _StepShadow;
			float _TopTex;
			float _TopTex_NoiseTiling;
			float _TopTex_Smoothstep;
			float _TopTex_Step;
			float _TerrainBlending;
			float _TerrainBlending_Falloff;
			float _TerrainBlending_BlendThickness;
			float _TerrainBlending_TextureTiling;
			float _Grayscale;
			float _BaseColor;
			float _InkGrunge_Multiply;
			float _InkGrunge_Tiling;
			float _ScreenBasedNoise;
			float _DepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Wind_Noise_Texture;
			sampler2D TB_DEPTH;
			float TB_OFFSET_X;
			float TB_OFFSET_Z;
			float TB_SCALE;
			float TB_FARCLIP;
			float TB_OFFSET_Y;
			sampler2D _TerrainBlendingNoise_Texture;
			TEXTURE2D_ARRAY(_ObjectTextureArray);
			SAMPLER(sampler_ObjectTextureArray);
			sampler2D _DepthFade_Dither_Texture;
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
			UNITY_INSTANCING_BUFFER_END(EnvironmentObjectsShader)


			inline float4 TriplanarSampling1360( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
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
			

			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float4 temp_cast_0 = (0.0).xxxx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _Wave_Speed ) * _WindWave_Speed + float2( 0,0 ));
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + float2( 0,0 ));
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( ( panner1312 + panner1313 ) * _Wind_Direction );
				float4 temp_cast_2 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_3 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( ( tex2Dlod( _Wind_Noise_Texture, float4( texCoord1319, 0, 0.0) ) - temp_cast_2 ) * _Wind_Strength ) + float4( 0,0,0,0 ) ) , temp_cast_3 , v.ase_color);
				float4 WindVertexDisplacement1330 = lerpResult1328;
				float4 lerpResult1407 = lerp( temp_cast_0 , WindVertexDisplacement1330 , _WindVertexDisplacement);
				float4 temp_cast_4 = (0.0).xxxx;
				float4 lerpResult1609 = lerp( lerpResult1407 , temp_cast_4 , _Out_or_InBrume);
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord2.w = eyeDepth;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = lerpResult1609.rgb;
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
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

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
				o.ase_color = v.ase_color;
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
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
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

				float worldY1344 = WorldPosition.y;
				float4 temp_cast_0 = (worldY1344).xxxx;
				float2 appendResult1340 = (float2(WorldPosition.x , WorldPosition.z));
				float2 appendResult1339 = (float2(TB_OFFSET_X , TB_OFFSET_Z));
				float4 temp_cast_1 = (TB_OFFSET_Y).xxxx;
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float4 triplanar1360 = TriplanarSampling1360( _TerrainBlendingNoise_Texture, WorldPosition, ase_worldNormal, 1.0, _TerrainBlendingNoise_Tiling, 1.0, 0 );
				float4 clampResult1354 = clamp( ( ( ( temp_cast_0 - ( tex2D( TB_DEPTH, ( ( appendResult1340 - appendResult1339 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_1 ) / ( _TerrainBlending_BlendThickness * triplanar1360 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_3 = (_TerrainBlending_Falloff).xxxx;
				float4 clampResult1356 = clamp( pow( clampResult1354 , temp_cast_3 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float TerrainBlendingMask1761 = clampResult1356.r;
				float clampResult1771 = clamp( ( TerrainBlendingMask1761 + _TerrainBlending_Opacity ) , 0.0 , 1.0 );
				float2 texCoord1622 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 TextureCoordinates1629 = texCoord1622;
				float4 tex2DArrayNode1711 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,0.0 );
				float Object_Opacity_Texture1457 = tex2DArrayNode1711.a;
				float Object_CustomOpacityMask_Texture1475 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,4.0 ).r;
				float lerpResult1549 = lerp( Object_CustomOpacityMask_Texture1475 , ( 1.0 - Object_CustomOpacityMask_Texture1475 ) , _InverseCustomOpacityMask);
				float lerpResult1472 = lerp( Object_Opacity_Texture1457 , lerpResult1549 , _CustomOpacityMask);
				float lerpResult1416 = lerp( 1.0 , ( clampResult1771 * lerpResult1472 ) , _Opacity);
				float eyeDepth = IN.ase_texcoord2.w;
				float cameraDepthFade1534 = (( eyeDepth -_ProjectionParams.y - _DepthFade_Distance ) / _DepthFade_Falloff);
				float localStochasticTiling2_g18 = ( 0.0 );
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 Input_UV145_g18 = ( (ase_screenPosNorm).xy * _DepthFade_Dither_Tiling );
				float2 UV2_g18 = Input_UV145_g18;
				float2 UV12_g18 = float2( 0,0 );
				float2 UV22_g18 = float2( 0,0 );
				float2 UV32_g18 = float2( 0,0 );
				float W12_g18 = 0.0;
				float W22_g18 = 0.0;
				float W32_g18 = 0.0;
				StochasticTiling( UV2_g18 , UV12_g18 , UV22_g18 , UV32_g18 , W12_g18 , W22_g18 , W32_g18 );
				float2 temp_output_10_0_g18 = ddx( Input_UV145_g18 );
				float2 temp_output_12_0_g18 = ddy( Input_UV145_g18 );
				float4 Output_2D293_g18 = ( ( tex2D( _DepthFade_Dither_Texture, UV12_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W12_g18 ) + ( tex2D( _DepthFade_Dither_Texture, UV22_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W22_g18 ) + ( tex2D( _DepthFade_Dither_Texture, UV32_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W32_g18 ) );
				float4 break31_g18 = Output_2D293_g18;
				float lerpResult1542 = lerp( 0.0 , break31_g18.r , _DepthFade_Texture);
				float clampResult1523 = clamp( cameraDepthFade1534 , ( ( lerpResult1542 * _DepthFade_DitherMultiply ) + _DepthFade_ClampMin ) , _DepthFade_ClampMax );
				float lerpResult1540 = lerp( 1.0 , clampResult1523 , _DepthFade);
				float Opacity1375 = ( lerpResult1416 * lerpResult1540 );
				
				float Alpha = 1;
				float AlphaClipThreshold = Opacity1375;
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
			#define _ALPHATEST_ON 1
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
			#define ASE_NEEDS_VERT_POSITION


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
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
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _SSS_Color;
			float4 _OutBrumeColorCorrection;
			float4 _ShadowColor;
			float4 _TerrainBlending_Color;
			float4 _PaperContrast;
			float4 _InBrumeBackColor;
			float4 _OutBrumeBaseColor;
			float4 _InBrumeColorCorrection;
			float4 _CustomRimLight_Color;
			float4 _SpecularColor;
			float4 _ColorShadow;
			float2 _WindWave_Speed;
			float2 _ShadowDrippingNoise_Offset;
			float2 _WindWave_Min_Speed;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _NormalDrippingNoise_Offset;
			float2 _TopTex_NoiseOffset;
			float2 _Noise_Panner;
			float2 _TopTex_Tiling;
			float _ShadowDrippingNoise_Smoothstep;
			float _CustomRimLight_Opacity;
			float _SSS_Scale;
			float _DrippingNoise_Tiling;
			float _SSS_Power;
			float _SSS;
			float _CustomRimLight;
			float _SSS_Distortion;
			float _ShadowDrippingNoise_Step;
			float _ShadowInBrumeGrunge_Contrast;
			float _ShadowInBrumeGrunge_Tiling;
			float _DepthFade_ClampMin;
			float _DepthFade_DitherMultiply;
			float _DepthFade_Texture;
			float _DepthFade_Dither_Tiling;
			float _DepthFade_Distance;
			float _DepthFade_Falloff;
			float _Opacity;
			float _CustomOpacityMask;
			float _InverseCustomOpacityMask;
			float _TerrainBlending_Opacity;
			float _NormalDebug;
			float _LightDebug;
			float _NormalDrippingNoise_Tiling;
			float _NormalDrippingNoise_Smoothstep;
			float _NormalDrippingNoise_Step;
			float _NormalInBrumeGrunge_Tiling;
			float _NormalInBrumeGrunge_Contrast;
			float _ShadowDrippingNoise_Transition;
			float _Wind_Texture_Tiling;
			float _StepAttenuation;
			float _Noise_Tiling;
			float _Paper_Flipbook_Rows;
			float _Paper_Flipbook_Columns;
			float _Paper_Tiling;
			float _Specular;
			float _SpecularNoise;
			float _SpecularStepMax;
			float _Paper_Flipbook_Speed;
			float _SpeculartStepMin;
			float _Out_or_InBrume;
			float _WindVertexDisplacement;
			float _Wind_Strength;
			float _Wind_Density;
			float _Wind_Direction;
			float _Wave_Speed;
			float _Roughness_Multiplier;
			float _MovingPaper;
			float _PaperMultiply;
			float _InkGrunge_Contrast;
			float _CustomWorldSpaceNormal;
			float _DepthFade_ClampMax;
			float _StepShadow;
			float _TopTex;
			float _TopTex_NoiseTiling;
			float _TopTex_Smoothstep;
			float _TopTex_Step;
			float _TerrainBlending;
			float _TerrainBlending_Falloff;
			float _TerrainBlending_BlendThickness;
			float _TerrainBlending_TextureTiling;
			float _Grayscale;
			float _BaseColor;
			float _InkGrunge_Multiply;
			float _InkGrunge_Tiling;
			float _ScreenBasedNoise;
			float _DepthFade;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Wind_Noise_Texture;
			sampler2D TB_DEPTH;
			float TB_OFFSET_X;
			float TB_OFFSET_Z;
			float TB_SCALE;
			float TB_FARCLIP;
			float TB_OFFSET_Y;
			sampler2D _TerrainBlendingNoise_Texture;
			TEXTURE2D_ARRAY(_ObjectTextureArray);
			SAMPLER(sampler_ObjectTextureArray);
			sampler2D _DepthFade_Dither_Texture;
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
			UNITY_INSTANCING_BUFFER_END(EnvironmentObjectsShader)


			inline float4 TriplanarSampling1360( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
			{
				float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
				projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
				float3 nsign = sign( worldNormal );
				half4 xNorm; half4 yNorm; half4 zNorm;
				xNorm = tex2D( topTexMap, tiling * worldPos.zy * float2(  nsign.x, 1.0 ) );
				yNorm = tex2D( topTexMap, tiling * worldPos.xz * float2(  nsign.y, 1.0 ) );
				zNorm = tex2D( topTexMap, tiling * worldPos.xy * float2( -nsign.z, 1.0 ) );
				return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
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
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 temp_cast_0 = (0.0).xxxx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _Wave_Speed ) * _WindWave_Speed + float2( 0,0 ));
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + float2( 0,0 ));
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( ( panner1312 + panner1313 ) * _Wind_Direction );
				float4 temp_cast_2 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_3 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( ( tex2Dlod( _Wind_Noise_Texture, float4( texCoord1319, 0, 0.0) ) - temp_cast_2 ) * _Wind_Strength ) + float4( 0,0,0,0 ) ) , temp_cast_3 , v.ase_color);
				float4 WindVertexDisplacement1330 = lerpResult1328;
				float4 lerpResult1407 = lerp( temp_cast_0 , WindVertexDisplacement1330 , _WindVertexDisplacement);
				float4 temp_cast_4 = (0.0).xxxx;
				float4 lerpResult1609 = lerp( lerpResult1407 , temp_cast_4 , _Out_or_InBrume);
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord2.w = eyeDepth;
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = lerpResult1609.rgb;
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
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;

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
				o.ase_color = v.ase_color;
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
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
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

				float worldY1344 = WorldPosition.y;
				float4 temp_cast_0 = (worldY1344).xxxx;
				float2 appendResult1340 = (float2(WorldPosition.x , WorldPosition.z));
				float2 appendResult1339 = (float2(TB_OFFSET_X , TB_OFFSET_Z));
				float4 temp_cast_1 = (TB_OFFSET_Y).xxxx;
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float4 triplanar1360 = TriplanarSampling1360( _TerrainBlendingNoise_Texture, WorldPosition, ase_worldNormal, 1.0, _TerrainBlendingNoise_Tiling, 1.0, 0 );
				float4 clampResult1354 = clamp( ( ( ( temp_cast_0 - ( tex2D( TB_DEPTH, ( ( appendResult1340 - appendResult1339 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_1 ) / ( _TerrainBlending_BlendThickness * triplanar1360 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_3 = (_TerrainBlending_Falloff).xxxx;
				float4 clampResult1356 = clamp( pow( clampResult1354 , temp_cast_3 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float TerrainBlendingMask1761 = clampResult1356.r;
				float clampResult1771 = clamp( ( TerrainBlendingMask1761 + _TerrainBlending_Opacity ) , 0.0 , 1.0 );
				float2 texCoord1622 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 TextureCoordinates1629 = texCoord1622;
				float4 tex2DArrayNode1711 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,0.0 );
				float Object_Opacity_Texture1457 = tex2DArrayNode1711.a;
				float Object_CustomOpacityMask_Texture1475 = SAMPLE_TEXTURE2D_ARRAY( _ObjectTextureArray, sampler_ObjectTextureArray, TextureCoordinates1629,4.0 ).r;
				float lerpResult1549 = lerp( Object_CustomOpacityMask_Texture1475 , ( 1.0 - Object_CustomOpacityMask_Texture1475 ) , _InverseCustomOpacityMask);
				float lerpResult1472 = lerp( Object_Opacity_Texture1457 , lerpResult1549 , _CustomOpacityMask);
				float lerpResult1416 = lerp( 1.0 , ( clampResult1771 * lerpResult1472 ) , _Opacity);
				float eyeDepth = IN.ase_texcoord2.w;
				float cameraDepthFade1534 = (( eyeDepth -_ProjectionParams.y - _DepthFade_Distance ) / _DepthFade_Falloff);
				float localStochasticTiling2_g18 = ( 0.0 );
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 Input_UV145_g18 = ( (ase_screenPosNorm).xy * _DepthFade_Dither_Tiling );
				float2 UV2_g18 = Input_UV145_g18;
				float2 UV12_g18 = float2( 0,0 );
				float2 UV22_g18 = float2( 0,0 );
				float2 UV32_g18 = float2( 0,0 );
				float W12_g18 = 0.0;
				float W22_g18 = 0.0;
				float W32_g18 = 0.0;
				StochasticTiling( UV2_g18 , UV12_g18 , UV22_g18 , UV32_g18 , W12_g18 , W22_g18 , W32_g18 );
				float2 temp_output_10_0_g18 = ddx( Input_UV145_g18 );
				float2 temp_output_12_0_g18 = ddy( Input_UV145_g18 );
				float4 Output_2D293_g18 = ( ( tex2D( _DepthFade_Dither_Texture, UV12_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W12_g18 ) + ( tex2D( _DepthFade_Dither_Texture, UV22_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W22_g18 ) + ( tex2D( _DepthFade_Dither_Texture, UV32_g18, temp_output_10_0_g18, temp_output_12_0_g18 ) * W32_g18 ) );
				float4 break31_g18 = Output_2D293_g18;
				float lerpResult1542 = lerp( 0.0 , break31_g18.r , _DepthFade_Texture);
				float clampResult1523 = clamp( cameraDepthFade1534 , ( ( lerpResult1542 * _DepthFade_DitherMultiply ) + _DepthFade_ClampMin ) , _DepthFade_ClampMax );
				float lerpResult1540 = lerp( 1.0 , clampResult1523 , _DepthFade);
				float Opacity1375 = ( lerpResult1416 * lerpResult1540 );
				
				float Alpha = 1;
				float AlphaClipThreshold = Opacity1375;

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
1920;0;1920;1019;12450.02;8229.304;9.575966;True;False
Node;AmplifyShaderEditor.CommentaryNode;824;-6950.875,-4815.77;Inherit;False;8348.826;7947.749;OUT BRUME;33;473;1397;1395;1400;1394;1398;1399;1290;518;1276;513;1586;428;1369;1588;1396;1592;1591;1468;1608;1590;1370;1607;1471;1469;1301;471;1587;520;31;521;1371;468;;1,0.7827643,0.5518868,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1371;-6897.966,719.2745;Inherit;False;3849.702;1403.809;TerrainBlending;37;1368;1367;1365;1364;1363;1362;1361;1360;1359;1358;1357;1356;1355;1354;1353;1352;1351;1350;1349;1348;1347;1346;1345;1344;1343;1342;1341;1340;1339;1338;1337;1336;1373;1374;1759;1760;1761;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1336;-6854.188,1318.237;Inherit;False;Global;TB_OFFSET_X;TB_OFFSET_X;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1337;-6851.622,1396.513;Inherit;False;Global;TB_OFFSET_Z;TB_OFFSET_Z;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1338;-6855.839,1163.497;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;1339;-6511.571,1391.38;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1340;-6511.571,1260.493;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1341;-6258.778,1409.345;Inherit;False;Global;TB_SCALE;TB_SCALE;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1342;-6274.177,1297.706;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1343;-6020.101,1297.706;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1344;-6534.669,1159.119;Inherit;False;worldY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1346;-5808.084,1231.58;Inherit;True;Global;TB_DEPTH;TB_DEPTH;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1345;-5703.637,1433.146;Inherit;False;Global;TB_FARCLIP;TB_FARCLIP;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1362;-5666.299,1611.293;Inherit;True;Property;_TerrainBlendingNoise_Texture;TerrainBlendingNoise_Texture;19;0;Create;True;0;0;False;0;False;1cb5d7a8b79999d4b8356e740bbf6667;c5ad016d3a1aba84ea1e7d0364506280;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;1348;-5429.405,1241.788;Inherit;False;1344;worldY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1359;-5738.547,1814.361;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;1361;-5611.448,1973.651;Inherit;False;Property;_TerrainBlendingNoise_Tiling;TerrainBlendingNoise_Tiling;20;0;Create;True;0;0;False;0;False;1,1;0.3,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1347;-5448.993,1363.835;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1335;-4561.12,-6100.601;Inherit;False;3603.017;815.9397;VertexColor WindDisplacement;27;1305;1306;1308;1307;1311;1310;1309;1312;1313;1315;1314;1317;1316;1319;1318;1321;1323;1322;1325;1324;1326;1329;1327;1328;1304;1330;1320;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosTime;1305;-4493.472,-5946.191;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1350;-5200.378,1317.126;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1363;-5214.471,1562.834;Inherit;False;Property;_TerrainBlending_BlendThickness;TerrainBlending_BlendThickness;17;0;Create;True;0;0;False;0;False;0;0.3;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1349;-5185.31,1434.653;Inherit;False;Global;TB_OFFSET_Y;TB_OFFSET_Y;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;1360;-5325.37,1791.088;Inherit;True;Spherical;World;False;Top Texture 3;_TopTexture3;white;0;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;1306;-4511.121,-5744.322;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1308;-4085.18,-5703.892;Inherit;False;Property;_Wave_Speed;Wave_Speed;90;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1351;-4864.081,1607.857;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1307;-4331.121,-5795.322;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1689;-6893.171,-6815.569;Inherit;False;673.6729;678.3989;Texture Atlas Infos;2;1622;1629;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1352;-5031.621,1314.113;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1381;-909.8229,-6105.162;Inherit;False;3106.94;1269.762;Opacity;21;1548;1428;1467;1417;1477;1416;1550;1472;1478;1539;1551;1538;1540;1549;1375;1536;1767;1765;1770;1771;1772;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;1311;-4005.315,-5936.475;Inherit;False;Property;_WindWave_Speed;WindWave_Speed;88;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1309;-3894.133,-5781.417;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1353;-4630.973,1312.654;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1622;-6843.171,-6760.371;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1310;-4103.792,-5448.661;Inherit;False;Property;_WindWave_Min_Speed;WindWave_Min_Speed;89;0;Create;True;0;0;False;0;False;0.05,0;0.05,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;1536;-850.1397,-5525.54;Inherit;False;2048.503;664.5554;DepthFade;18;1523;1534;1535;1530;1528;1532;1533;1529;1531;1527;1526;1525;1524;1542;1543;1544;1545;1546;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1629;-6603.873,-6765.569;Inherit;False;TextureCoordinates;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1522;-6907.222,-6099.964;Inherit;False;2298.802;1114.077;TexturesArrays;18;1479;1480;1711;1712;1715;1716;1717;1722;1721;1720;1719;1718;1454;1455;1456;1475;1457;1453;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;1312;-3747.521,-5955.602;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;1354;-4433.319,1315.307;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;1313;-3847.175,-5466.776;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1364;-4526.176,1141.53;Inherit;False;Property;_TerrainBlending_Falloff;TerrainBlending_Falloff;18;0;Create;True;0;0;False;0;False;0;30;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1524;-799.0931,-5161.576;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1314;-3480.655,-5557.14;Inherit;False;Property;_Wind_Direction;Wind_Direction;85;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1722;-6816.742,-5184.357;Inherit;False;Constant;_Float37;Float 37;104;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1315;-3501.781,-5682.56;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1723;-7147.623,-5655.685;Inherit;False;1629;TextureCoordinates;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;1355;-4201.174,1312.654;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;1525;-591.0931,-5161.576;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;1356;-4009.745,1311.197;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1316;-3404.272,-5841.589;Inherit;False;Property;_Wind_Texture_Tiling;Wind_Texture_Tiling;84;0;Create;True;0;0;False;0;False;0.5;-0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1717;-6674.329,-5232.281;Inherit;True;Property;_TextureSample11;Texture Sample 11;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1526;-607.0931,-5081.576;Inherit;False;Property;_DepthFade_Dither_Tiling;DepthFade_Dither_Tiling;94;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1317;-3291.653,-5674.141;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1319;-3166.573,-5828.379;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1321;-2823.918,-5639.736;Inherit;False;Property;_Wind_Density;Wind_Density;86;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;1318;-2792.74,-5547.377;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1531;-470.9058,-5460.349;Inherit;True;Property;_DepthFade_Dither_Texture;DepthFade_Dither_Texture;93;0;Create;True;0;0;False;0;False;None;5249c43f26c99bf448754900521f6d27;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;1475;-6289.991,-5201.48;Inherit;False;Object_CustomOpacityMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1527;-367.0897,-5161.576;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1357;-3815.128,1312.002;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1718;-6843.952,-5976.107;Inherit;False;Constant;_Float7;Float 7;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1320;-3121.824,-6050.601;Inherit;True;Property;_Wind_Noise_Texture;Wind_Noise_Texture;83;0;Create;True;0;0;False;0;False;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1322;-2624.326,-5584.533;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1323;-2878.825,-5860.6;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1544;-114.3415,-5331.07;Inherit;False;Constant;_Float26;Float 26;86;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1543;-151.3415,-4968.07;Inherit;False;Property;_DepthFade_Texture;DepthFade_Texture?;92;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1529;-185.9061,-5189.349;Inherit;False;Procedural Sample;-1;;18;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerNode;1711;-6678.491,-6022.488;Inherit;True;Property;_ObjectTextureArray;Object Texture Array;11;0;Create;True;0;0;False;0;False;-1;None;d0091e005383fcc4f9fda7c9ef4d7dff;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1761;-3510.166,1451.809;Inherit;False;TerrainBlendingMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1478;-887.1839,-5870.966;Inherit;True;1475;Object_CustomOpacityMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1551;-614.8028,-5651.579;Inherit;False;Property;_InverseCustomOpacityMask;InverseCustomOpacityMask?;10;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1528;263.4483,-5101.56;Inherit;False;Property;_DepthFade_DitherMultiply;DepthFade_DitherMultiply;95;0;Create;True;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1325;-2415.766,-5852.731;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1767;152.0026,-5977.279;Inherit;False;Property;_TerrainBlending_Opacity;TerrainBlending_Opacity;15;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1542;99.65852,-5185.07;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1324;-2212.674,-5784.213;Inherit;False;Property;_Wind_Strength;Wind_Strength;87;0;Create;True;0;0;False;0;False;2;0.004;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1550;-533.4002,-5741.352;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1765;156.8719,-6058.497;Inherit;False;1761;TerrainBlendingMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1457;-6281.517,-5923.901;Inherit;False;Object_Opacity_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1770;472.8707,-6008.13;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1533;258.3684,-5297.096;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;97;0;Create;True;0;0;False;0;False;10.5;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1532;265.3683,-5379.096;Inherit;False;Property;_DepthFade_Falloff;DepthFade_Falloff;96;0;Create;True;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1530;504.4483,-5183.56;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1326;-2037.677,-5852.213;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1467;-131.6557,-5993.16;Inherit;True;1457;Object_Opacity_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1549;-300.4002,-5818.352;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1477;-227.8821,-5686.058;Inherit;False;Property;_CustomOpacityMask;CustomOpacityMask?;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1546;540.1972,-5055.07;Inherit;False;Property;_DepthFade_ClampMin;DepthFade_ClampMin;98;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;1534;536.3693,-5379.096;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1329;-1732.258,-5996.808;Inherit;False;Constant;_Float1;Float 1;67;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1472;138.4026,-5863.752;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1535;539.9333,-4970.578;Inherit;False;Property;_DepthFade_ClampMax;DepthFade_ClampMax;99;0;Create;True;0;0;False;0;False;0.8;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1304;-1735.607,-5585.193;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1327;-1776.546,-5852.263;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1771;600.3788,-6007.732;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1545;782.1972,-5183.07;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1328;-1470.508,-5957.989;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1428;1048.42,-6003.648;Inherit;False;Constant;_Float6;Float 6;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1539;1295.673,-5731.427;Inherit;False;Constant;_Float25;Float 25;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1523;938.5362,-5190.478;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1417;959.8386,-5768.742;Inherit;False;Property;_Opacity;Opacity?;8;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1538;1212.094,-5638.521;Inherit;False;Property;_DepthFade;DepthFade?;91;0;Create;True;0;0;False;1;Header(Depth Fade);False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1772;824.4437,-5895.874;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1416;1301.306,-5906.273;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1330;-1240.105,-5968.102;Inherit;False;WindVertexDisplacement;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;845;2251.206,-6096.439;Inherit;False;1531.766;1053.436;FinalPass;18;1407;1334;1408;1331;1405;1406;1404;1403;582;954;474;844;955;1376;1464;1609;1611;1800;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;1540;1574.557,-5727.052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1331;2368.29,-5273.137;Inherit;False;1330;WindVertexDisplacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1254;1489.404,-4794.337;Inherit;False;5750.871;4770.477;IN BRUME;20;901;1255;1256;1223;1014;1252;1162;988;1049;989;1118;1161;1248;1050;1241;1158;1242;1250;1253;1243;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1334;2483.903,-5364.958;Inherit;False;Constant;_Float4;Float 4;68;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1548;1786.855,-5816.149;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1408;2369.948,-5184.637;Inherit;False;Property;_WindVertexDisplacement;WindVertexDisplacement?;82;0;Create;True;0;0;False;1;Header(Wind);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;468;-6889.708,-4018.677;Inherit;False;4068.818;1665.93;Paper + Object Texture;39;1366;461;530;525;1382;460;1497;526;1385;839;458;455;1491;1492;1411;1412;664;666;667;665;670;466;463;465;464;1612;1613;1614;1697;1725;1726;1727;1728;1748;1756;1757;1758;841;842;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-6882.713,-4765.77;Inherit;False;1788.085;588.8215;Normal Light Dir;10;23;12;10;11;576;710;711;1409;1410;1458;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1587;-2496.178,-4028.175;Inherit;False;3445.089;1817.899;TopTex;29;1584;1553;1552;1581;1565;1563;1595;1594;1596;1564;1562;1561;1560;1559;1582;1557;1558;1556;1568;1567;1555;1566;1554;1569;1598;1599;1600;1604;1606;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1480;-5205.585,-6041.312;Inherit;False;542.5189;491.103;InBrume TextureArray Setup;4;1505;1504;1509;1503;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1243;1548.961,-3798.261;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;20;1194;1240;1220;1219;1221;1218;1231;1224;1233;1232;1228;1227;1225;1235;1203;1230;1165;1164;1516;1517;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1301;-6905.633,-20.07816;Inherit;False;3450.197;700.3971;SSS;17;1264;1286;1281;1287;1289;1285;1284;1283;1294;1293;1300;1296;1272;1299;1270;1275;1460;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;520;-6918.805,-1072.776;Inherit;False;3799.808;1008.013;Add Rougness and Normal;30;1585;512;509;508;1401;656;639;522;1402;523;623;636;1462;634;640;630;632;1501;506;633;626;1500;619;504;627;500;499;498;1459;1615;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1479;-5951.777,-6046.524;Inherit;False;711.9073;439.9834;Noise et Grunge OutBrume TextureArray Setup;4;1486;1485;1483;1482;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;954;2284.689,-5853.256;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;1;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1375;1981.366,-5821.883;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1611;2749.891,-5430.837;Inherit;False;Constant;_Float10;Float 10;98;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1407;2692.706,-5293.154;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1396;-2163.091,-4700.212;Inherit;False;921.4059;517.2213;CustomRimLight;6;1389;1393;1391;1390;1392;1461;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1253;1539.404,-2828.728;Inherit;False;2088.706;597.0554;InBrumeGrunge;16;1195;1117;1116;1119;1246;1114;1113;1115;1104;1247;1749;1750;1751;1752;1754;1755;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;521;-4914.711,-4765.77;Inherit;False;2700.771;602.1591;Noise;18;481;570;1495;1493;1496;1494;573;484;571;572;1413;477;565;487;1414;480;479;478;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1250;1544.504,-2202.849;Inherit;False;3114.2;902.8672;NormalDrippingGrunge;20;1249;1189;1188;1111;1186;1187;1106;1180;1184;1179;1193;1181;1191;1105;1182;1108;1251;1465;1519;1518;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;471;-6904.995,-2197.37;Inherit;False;3565.746;1090.681;Shadow Smooth Edge + Int Shadow;20;768;877;563;562;449;444;450;401;445;447;397;470;446;448;482;385;387;469;386;388;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1118;4956.938,-3559.622;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;623;-4446.28,-384.7766;Inherit;False;Property;_SpecularColor;SpecularColor;43;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.9433962,0.8590411,0.6274475,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;1592;-5900.888,2685.002;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1270;-4061.958,231.5807;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1393;-1612.882,-4484.435;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;988;5231.383,-3754.165;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;509;-3886.278,-784.7766;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;1395;-3536.771,2631.384;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1401;-3973.948,-349.7667;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1247;3375.61,-2493.123;Inherit;False;NormalInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1115;3137.593,-2492.974;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1252;5696.354,-3110.124;Inherit;False;1251;NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1116;2889.441,-2771.511;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;1293;-5130.457,263.0066;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1609;2933.191,-5425.638;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1119;3139.825,-2777.393;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1240;4167.85,-3543.434;Inherit;False;ShadowDrippingNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;844;2322.17,-5940.718;Inherit;False;901;EndInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1469;-6877.931,2847.791;Inherit;False;Property;_TerrainBlending;TerrainBlending?;12;0;Create;True;0;0;False;1;Header(TerrainBlending);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;711;-5618.712,-4621.769;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1496;-3229.859,-4533.634;Inherit;False;Constant;_Float18;Float 18;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;508;-3886.278,-704.7766;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;842;-4126.373,-2961.017;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1757;-4578.993,-2937.151;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-4308.421,-3700.986;Inherit;False;Property;_PaperMultiply;PaperMultiply;28;0;Create;True;0;0;False;0;False;1.58;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1590;-6278.165,2733.889;Inherit;False;1584;TopTex;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;1294;-5315.096,377.1138;Inherit;False;Property;_SSS_Scale;SSS_Scale;57;0;Create;True;0;0;False;0;False;0.46;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1519;2867.755,-1526.045;Inherit;True;Property;_TextureSample25;Texture Sample 25;63;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1503;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1370;-6884.591,2689.322;Inherit;False;1368;RBG_TerrainBlending;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;523;-4415.28,-643.7766;Inherit;False;Property;_Roughness_Multiplier;Roughness_Multiplier;44;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;955;2587.376,-6016.674;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1179;2777.383,-1829.955;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1509;-5004.239,-5760.893;Inherit;True;Property;_TextureSample0;Texture Sample 0;90;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1503;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1382;-5105.739,-3303.506;Inherit;False;Procedural Sample;-1;;23;f5379ff72769e2b4495e5ce2f004d8d4;2,157,2,315,2;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SimpleAddOpNode;1186;3500.65,-1783.366;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1189;4066.064,-2085.203;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-5608.994,-2133.37;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;428;-5128.803,2607.623;Inherit;True;Multiply;True;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;460;-4484.421,-3924.986;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1114;2567.943,-2393.435;Inherit;False;Property;_NormalInBrumeGrunge_Contrast;NormalInBrumeGrunge_Contrast;80;0;Create;True;0;0;False;0;False;2.4;-6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;2629.317,-5770.151;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1405;3251.845,-5861.888;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1482;-5708.095,-5993.832;Inherit;True;Property;_NoiseandGrungeOutBrumeTextureArray;Noise and Grunge OutBrume Texture Array;21;0;Create;True;0;0;False;0;False;-1;8fdb86c7e9893674ea4c46a3398744c6;8fdb86c7e9893674ea4c46a3398744c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1504;-5207.978,-5931.153;Inherit;False;Constant;_InkSplatter_Texture;InkSplatter_Texture;90;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1403;2918.833,-6014.854;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1406;3069.99,-5610.872;Inherit;False;Property;_NormalDebug;NormalDebug;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1464;2965.229,-5812.346;Inherit;False;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;1569;-2124.025,-2509.969;Inherit;False;Property;_TopTex_NoiseOffset;TopTex_NoiseOffset;51;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1014;5961.697,-3128.717;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1725;-4712.436,-3296.231;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1180;3017.84,-1829.511;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-4063.278,-755.7766;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1728;-4565.539,-3066.365;Inherit;False;Property;_InkGrunge_Multiply;InkGrunge_Multiply;32;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;634;-4862.281,-496.7766;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;1554;-1997.714,-2948.045;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1518;2676.755,-1378.045;Inherit;False;Constant;_Float22;Float 22;88;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-5928.994,-1701.369;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;901;6908.911,-3131.885;Inherit;False;EndInBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-5906.713,-4621.769;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1283;-5409.943,260.9688;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1607;-6402.098,2811.918;Inherit;False;1606;TopTexMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1241;4698.682,-3564.553;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1220;3970.006,-3491.819;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1184;2597.719,-1496.293;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1471;-6826.749,2600.868;Inherit;False;1366;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;518;-4652.995,2528.185;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;636;-4622.281,-496.7766;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1483;-5918.5,-5758.268;Inherit;False;Constant;_EdgeNoise;EdgeNoise;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-6360.995,-2133.37;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;710;-5890.713,-4349.77;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;513;-4878.747,2607.806;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;1162;5658.548,-3782.357;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1458;-6660.233,-4514.482;Inherit;True;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-5896.994,-1589.37;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;458;-4740.422,-3844.986;Inherit;False;Property;_PaperContrast;PaperContrast;27;0;Create;True;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0.6226414,0.6226414,0.6226414,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1275;-3679.439,250.8323;Inherit;False;SSS;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-6248.995,-1893.37;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-6162.713,-4621.769;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1400;-3465.153,2909.908;Inherit;False;Property;_CustomRimLight;CustomRimLight?;59;0;Create;True;0;0;False;1;Header(Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-5384.993,-2133.37;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;841;-4416.373,-2827.018;Inherit;False;Property;_OutBrumeColorCorrection;OutBrumeColorCorrection;62;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-5688.994,-1621.37;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1398;-3871.884,2530.979;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;455;-4948.422,-3940.986;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1389;-1457.995,-4489.869;Inherit;False;CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1553;505.1564,-3368.473;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-5896.994,-1493.37;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;448;-6104.994,-1541.37;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;572;-3698.707,-4605.769;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1191;2322.838,-1540.714;Inherit;False;Property;_NormalDrippingNoise_Tiling;NormalDrippingNoise_Tiling;73;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;449;-4920.99,-1621.37;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1165;1732.137,-3438.533;Inherit;False;Property;_ShadowDrippingNoise_Step;ShadowDrippingNoise_Step;68;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;768;-4280.992,-2069.37;Inherit;False;LightMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;1193;2316.136,-1453.259;Inherit;False;Property;_NormalDrippingNoise_Offset;NormalDrippingNoise_Offset;74;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1591;-5909.939,2922.918;Inherit;False;Property;_TopTex;TopTex?;45;0;Create;True;0;0;False;1;Header(Top Texture);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1249;3496.067,-2082.659;Inherit;False;1247;NormalInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1462;-4697.935,-923.7216;Inherit;True;1455;Object_Roughness_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1615;-4366.253,-920.1621;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;499;-6160.754,-598.8336;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-6088.994,-2133.37;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;563;-4136.993,-1637.37;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-6807.995,-1595.37;Inherit;False;Property;_StepShadow;StepShadow;36;0;Create;True;0;0;False;0;False;0.03;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;482;-5832.994,-1957.37;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1485;-5916.118,-5946.435;Inherit;False;Constant;_Paper_Texture;Paper_Texture;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1251;4362.971,-2085.377;Inherit;False;NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1404;2694.955,-5668.413;Inherit;False;Property;_LightDebug;LightDebug;2;0;Create;True;0;0;False;1;Header(Debug);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1494;-3233.859,-4297.635;Inherit;False;Constant;_Float17;Float 17;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;444;-5336.993,-1621.37;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;989;4947.555,-3758.932;Inherit;False;Property;_ColorShadow;ColorShadow;64;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.150942,0.150942,0.150942,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1391;-2063.88,-4365.435;Inherit;False;Property;_CustomRimLight_Color;CustomRimLight_Color;60;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1111;3752.193,-2077.96;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;450;-5064.992,-1301.37;Inherit;False;Property;_ShadowColor;ShadowColor;38;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.4056589,0.4056589,0.4056589,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;562;-4552.991,-1941.37;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;500;-6256.754,-790.8345;Inherit;False;Blinn-Phong Half Vector;-1;;24;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;570;-2728.71,-4425.77;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1290;-4163.778,2615.625;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-6178.713,-4477.77;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;1493;-3065.946,-4401.642;Inherit;True;Property;_TextureSample13;Texture Sample 13;21;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1482;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;571;-3538.707,-4637.769;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1567;-1495.419,-2934.377;Inherit;False;Property;_TopTex_Smoothstep;TopTex_Smoothstep;53;0;Create;True;0;0;False;0;False;0.3;0.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1187;3252.029,-1638.812;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;484;-3698.707,-4381.77;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1459;-6622.82,-604.1476;Inherit;True;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;1555;-2067.164,-3169.078;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;388;-6440.995,-1877.37;Inherit;False;Property;_StepAttenuation;StepAttenuation;37;0;Create;True;0;0;False;0;False;0.3;-0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1726;-4974.599,-3099.517;Inherit;False;Property;_InkGrunge_Contrast;InkGrunge_Contrast;31;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1390;-1803.881,-4595.435;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1246;3356.108,-2778.729;Inherit;False;ShadowInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1586;-4901.121,2509.075;Inherit;False;1585;RoughnessNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1276;-4355.934,2737.961;Inherit;False;1275;SSS;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1188;3792.616,-1782.83;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1367;-3828.959,1191.297;Inherit;False;1366;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1719;-6834.952,-5776.107;Inherit;False;Constant;_Float11;Float 11;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1164;1623.455,-3256.258;Inherit;False;Property;_DrippingNoise_Tiling;ShadowDrippingNoise_Tiling;69;0;Create;False;0;0;False;0;False;1;-5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1557;-1808.059,-3169.287;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1285;-5614.085,108.525;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;1106;2793.14,-2081.781;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1756;-5017.925,-2646.67;Inherit;False;Property;_OutBrumeBaseColor;OutBrumeBaseColor;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;498;-6368.754,-598.8336;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleContrastOpNode;1113;2895.165,-2487.674;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1248;4697.494,-3486.695;Inherit;False;1246;ShadowInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1566;-1448.42,-3042.376;Inherit;False;Property;_TopTex_Step;TopTex_Step;52;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1181;2378.533,-1764.275;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1182;2046.222,-1760.473;Inherit;False;Property;_NormalDrippingNoise_Smoothstep;NormalDrippingNoise_Smoothstep;71;0;Create;True;0;0;False;0;False;0.01;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1712;-6680.055,-5829.381;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-4864.714,-4451.914;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;463;-6642.376,-3707.739;Inherit;False;Property;_Paper_Tiling;Paper_Tiling;23;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1299;-4426.52,269.9319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1460;-6646.205,347.6007;Inherit;True;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1595;-362.8938,-2668.281;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1468;-6583.945,2611.796;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;626;-5941.063,-352.7767;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;877;-3575.187,-1642.022;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-2814.851,2531.778;Inherit;False;EndOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1588;-5555.967,2614.271;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;1272;-4317.865,29.92182;Inherit;False;Property;_SSS_Color;SSS_Color;56;0;Create;True;0;0;False;0;False;1,0,0,0;1,0.007843138,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;480;-4656.714,-4451.914;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;565;-4432.711,-4659.913;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1562;-857.9733,-3009.636;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;664;-6142.411,-3546.466;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-6850.376,-3787.739;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1598;-2345.067,-3173.622;Inherit;True;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-5970.244,-973.9715;Inherit;False;Property;_SpeculartStepMin;SpeculartStepMin;40;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1235;2103.798,-3494.698;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1289;-5823.595,285.0105;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;1612;-3567.627,-3162.207;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;461;-3382.916,-3465.709;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1565;-114.6562,-3011.983;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1287;-6102.872,469.9413;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1374;-5386.789,823.0943;Inherit;False;Property;_TerrainBlending_TextureTiling;TerrainBlending_TextureTiling;16;0;Create;True;0;0;False;0;False;1;3.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1501;-5662.337,-380.5166;Inherit;True;Property;_TextureSample15;Texture Sample 15;21;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1482;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;666;-6436.423,-3444.986;Inherit;False;Property;_Paper_Flipbook_Rows;Paper_Flipbook_Rows;25;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;1286;-6364.411,394.6767;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1561;-627.2427,-2939.411;Inherit;False;Constant;_Float9;Float 9;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1373;-5097.789,804.0943;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1584;704.922,-3373.025;Inherit;False;TopTex;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;487;-3922.708,-4301.77;Inherit;False;Property;_Noise_Panner;Noise_Panner;35;0;Create;True;0;0;False;0;False;0.2,-0.1;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1500;-5868.284,-194.1262;Inherit;False;Constant;_Float19;Float 19;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1232;2799.593,-3127.942;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TriplanarNode;1599;-670.1906,-3734.854;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;1748;-4050.491,-3296.174;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;1453;-6282.843,-6018.876;Inherit;False;Object_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;665;-6452.423,-3524.986;Inherit;False;Property;_Paper_Flipbook_Columns;Paper_Flipbook_Columns;24;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-5330.712,-4637.769;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-6418.376,-3787.739;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1558;-1288.42,-2953.376;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-4672.714,-4371.914;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;33;0;Create;True;0;0;False;1;Header(Shadow and NoiseEdge);False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-3718.918,-3513.709;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1556;-1882.19,-2571.963;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;1563;-441.2429,-3007.411;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1751;1712.557,-2305.803;Inherit;False;Property;_NormalInBrumeGrunge_Tiling;NormalInBrumeGrunge_Tiling;79;0;Create;True;0;0;False;0;False;0.2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1409;-6680.779,-4312.642;Inherit;False;Property;_CustomWorldSpaceNormal;CustomWorldSpaceNormal?;7;0;Create;True;0;0;False;1;Header(OtherProperties);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-4432.711,-4451.914;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1568;-2122.191,-2594.963;Inherit;False;Property;_TopTex_NoiseTiling;TopTex_NoiseTiling;50;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1697;-5040.249,-2857.857;Inherit;True;1453;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1760;-4549.126,932.0366;Inherit;False;Property;_TerrainBlending_Color;TerrainBlending_Color;14;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1411;-5819.105,-3787.185;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1413;-3969.556,-4516.104;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1581;-164.7392,-3338.692;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1715;-6678.329,-5634.281;Inherit;True;Property;_TextureSample6;Texture Sample 6;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1758;-4784.804,-2460.278;Inherit;False;Property;_BaseColor;BaseColor?;5;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1750;1687.731,-2577.955;Inherit;False;Property;_ShadowInBrumeGrunge_Tiling;ShadowInBrumeGrunge_Tiling;76;0;Create;True;0;0;False;0;False;0.2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1410;-6325.968,-4622.459;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1412;-6158.274,-3713.36;Inherit;False;Property;_MovingPaper;MovingPaper?;22;0;Create;True;0;0;False;1;Header(Paper);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1108;2065.354,-1860.845;Inherit;False;Property;_NormalDrippingNoise_Step;NormalDrippingNoise_Step;72;0;Create;True;0;0;False;0;False;0.45;0.461;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;576;-6661.603,-4684.951;Inherit;False;Constant;_Vector0;Vector 0;25;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1492;-5520.504,-3780.708;Inherit;False;Constant;_Float16;Float 16;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;667;-6436.423,-3364.986;Inherit;False;Property;_Paper_Flipbook_Speed;Paper_Flipbook_Speed;26;0;Create;True;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1397;-3243.885,2532.979;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1559;-1122.156,-3165.725;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.33;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1497;-5445.502,-3220.583;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;1454;-6273.843,-5821.876;Inherit;False;Object_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;506;-5795.757,-785.5605;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1227;2276.713,-3518.146;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1505;-5234.978,-5713.153;Inherit;False;Constant;_DrippingNoise_Texture;DrippingNoise_Texture;90;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1754;2010.706,-2688.793;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1104;1597.38,-2491.586;Inherit;True;Property;_InBrumeGrunge_Texture;NormalInBrumeGrunge_Texture;78;0;Create;False;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1716;-6674.329,-5437.281;Inherit;True;Property;_TextureSample8;Texture Sample 8;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1727;-4274.539,-3296.365;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;1219;3676.058,-3367.801;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1752;2260.557,-2489.803;Inherit;False;Procedural Sample;-1;;25;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.LerpOp;1358;-3500.869,1172.419;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;1223;6238.016,-3127.269;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1552;238.9589,-3144.495;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1755;2003.706,-2413.793;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;640;-5022.282,-496.7766;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1613;-3843.539,-3144.52;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1225;1971.318,-3748.261;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1560;-645.2427,-2864.411;Inherit;False;Constant;_Float8;Float 8;2;0;Create;True;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1606;391.7551,-3014.137;Inherit;False;TopTexMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;670;-6379.423,-3277.986;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1749;2262.531,-2775.654;Inherit;False;Procedural Sample;-1;;26;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.BreakToComponentsNode;1161;4884.754,-4169.173;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1402;-4207.032,-146.7071;Inherit;False;Property;_Specular;Specular?;39;0;Create;True;0;0;False;1;Header(Specular);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1296;-4700.434,262.2195;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;6.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1376;3237.855,-5447.42;Inherit;False;1375;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1503;-5000.667,-5979.393;Inherit;True;Property;_InBrumeTextureArray;InBrume Texture Array;63;0;Create;True;0;0;False;0;False;-1;0b5330c4506cf76469355adb5b4180b0;0b5330c4506cf76469355adb5b4180b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;1608;-6167.922,2883.934;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-4222.278,-496.7766;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1759;-4257.815,782.8743;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1721;-6822.952,-5390.107;Inherit;False;Constant;_Float36;Float 36;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1385;-5467.227,-3049.474;Inherit;False;Property;_InkGrunge_Tiling;InkGrunge_Tiling;30;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1399;-4074.883,2915.979;Inherit;False;Property;_SSS;SSS?;54;0;Create;True;0;0;False;1;Header(SubSurface Scattering);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1456;-6269.795,-5424.007;Inherit;False;Object_RimLightMask_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1049;5048.973,-4346.26;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1300;-4878.509,348.4243;Inherit;False;Property;_SSS_Power;SSS_Power;58;0;Create;True;0;0;False;0;False;0.25;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1233;3005.594,-3127.942;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;630;-5230.282,-496.7766;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1596;-533.7923,-2675.48;Inherit;False;Constant;_Float15;Float 15;96;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1414;-4200.556,-4365.104;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;34;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;656;-4207.278,-232.7766;Inherit;False;Constant;_Float2;Float 2;31;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1720;-6830.952,-5586.107;Inherit;False;Constant;_Float35;Float 35;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1264;-6467.678,567.1663;Inherit;False;Property;_SSS_Distortion;SSS_Distortion;55;0;Create;True;0;0;False;0;False;0.8;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;839;-5489.387,-3427.483;Inherit;True;Property;_InkGrunge_Texture;InkGrunge_Texture;29;0;Create;True;0;0;False;1;Header(Ink Grunge);False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1582;-1647.574,-2650.237;Inherit;True;Property;_TopTex_Noise_Texture;TopTex_Noise_Texture;48;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1203;1929.625,-3235.801;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1517;2009.987,-3094.224;Inherit;False;Constant;_Float14;Float 14;88;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1228;2556.94,-3351.712;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1495;-3063.946,-4667.642;Inherit;True;Property;_TextureSample14;Texture Sample 14;21;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1482;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;573;-3266.71,-4637.769;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1281;-6143.164,276.1383;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCGrayscale;1105;2157.005,-2152.849;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;1284;-5675.325,286.3362;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;1564;-1155.503,-2635.895;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1366;-3065.353,-3464.853;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1461;-2114.325,-4634.479;Inherit;True;1456;Object_RimLightMask_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;-3598.277,-752.7766;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1614;-3864.438,-2891.635;Inherit;False;Property;_Grayscale;Grayscale?;4;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1600;-940.1906,-3790.854;Inherit;True;Property;_TopTex_Albedo_Texture;TopTex_ Albedo_Texture;46;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-2440.71,-4426.77;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;632;-5634.243,-989.9715;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;504;-6000.754,-694.8346;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1594;-662.7923,-2484.48;Inherit;False;InstancedProperty;_TopTex_NoiseHoles;TopTex_NoiseHoles?;49;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;2310.789,-6021.119;Inherit;False;473;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1255;6664.081,-3150.641;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1486;-5709.036,-5805.474;Inherit;True;Property;_TextureSample7;Texture Sample 7;85;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1482;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1218;3458.816,-3373.501;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1455;-6258.194,-5643.189;Inherit;False;Object_Roughness_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-4116.419,-3844.986;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1365;-4876.114,775.08;Inherit;True;Property;_TerrainBlending_TextureTerrain;TerrainBlending_TextureTerrain;13;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;88d75bbfdb8a26849988713b4599646a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1604;-869.9202,-3592.521;Inherit;False;Property;_TopTex_Tiling;TopTex_Tiling;47;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;1224;2290.962,-3743.161;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;627;-6101.063,-336.7776;Inherit;False;Property;_SpecularNoise;SpecularNoise;42;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1491;-5378.481,-3938.872;Inherit;True;Property;_TextureSample12;Texture Sample 12;21;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1482;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;633;-5970.244,-893.9705;Inherit;False;Property;_SpecularStepMax;SpecularStepMax;41;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;-3313.137,1165.979;Inherit;False;RBG_TerrainBlending;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1256;6362.291,-3414.715;Inherit;False;Property;_InBrumeColorCorrection;InBrumeColorCorrection;81;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;1231;3283.057,-3631.653;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1585;-3336.702,-758.8047;Inherit;False;RoughnessNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1369;-5362.555,2704.322;Inherit;False;877;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1394;-3757.965,2753.037;Inherit;False;1389;CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1392;-2075.881,-4444.435;Inherit;False;Property;_CustomRimLight_Opacity;CustomRimLight_Opacity;61;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1242;4425.13,-4175.379;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1117;2587.215,-2674.273;Inherit;False;Property;_ShadowInBrumeGrunge_Contrast;ShadowInBrumeGrunge_Contrast;77;0;Create;True;0;0;False;0;False;-3.38;-60;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;465;-6626.376,-3787.739;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;1158;4693.764,-4169.367;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1516;2180.987,-3264.224;Inherit;True;Property;_TextureSample1;Texture Sample 1;63;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1503;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1465;1874.141,-2152.833;Inherit;False;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1230;1725.979,-3525.107;Inherit;False;Property;_ShadowDrippingNoise_Smoothstep;ShadowDrippingNoise_Smoothstep;67;0;Create;True;0;0;False;0;False;0.2;0.001;0.001;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1194;1617.961,-3168.183;Inherit;False;Property;_ShadowDrippingNoise_Offset;ShadowDrippingNoise_Offset;70;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1221;3665.805,-3718.18;Inherit;False;Property;_ShadowDrippingNoise_Transition;ShadowDrippingNoise_Transition;66;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1050;4795.729,-4378.192;Inherit;False;Property;_InBrumeBackColor;InBrumeBackColor;65;0;Create;True;0;0;False;0;False;1,1,1,0;0.8962264,0.8890581,0.883544,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1195;1589.404,-2777.549;Inherit;True;Property;_InBrumeGrunge_Texture2;ShadowInBrumeGrunge_Texture;75;0;Create;False;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1802;3500.958,-5634.269;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1801;3500.958,-5634.269;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1803;3500.958,-5634.269;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1800;3500.958,-5634.269;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;EnvironmentObjectsShader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;0;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1799;3500.958,-5634.269;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;1339;0;1336;0
WireConnection;1339;1;1337;0
WireConnection;1340;0;1338;1
WireConnection;1340;1;1338;3
WireConnection;1342;0;1340;0
WireConnection;1342;1;1339;0
WireConnection;1343;0;1342;0
WireConnection;1343;1;1341;0
WireConnection;1344;0;1338;2
WireConnection;1346;1;1343;0
WireConnection;1347;0;1346;0
WireConnection;1347;1;1345;0
WireConnection;1350;0;1348;0
WireConnection;1350;1;1347;0
WireConnection;1360;0;1362;0
WireConnection;1360;9;1359;0
WireConnection;1360;3;1361;0
WireConnection;1351;0;1363;0
WireConnection;1351;1;1360;0
WireConnection;1307;0;1305;4
WireConnection;1307;1;1306;0
WireConnection;1352;0;1350;0
WireConnection;1352;1;1349;0
WireConnection;1309;0;1307;0
WireConnection;1309;1;1308;0
WireConnection;1353;0;1352;0
WireConnection;1353;1;1351;0
WireConnection;1629;0;1622;0
WireConnection;1312;2;1311;0
WireConnection;1312;1;1309;0
WireConnection;1354;0;1353;0
WireConnection;1313;2;1310;0
WireConnection;1315;0;1312;0
WireConnection;1315;1;1313;0
WireConnection;1355;0;1354;0
WireConnection;1355;1;1364;0
WireConnection;1525;0;1524;0
WireConnection;1356;0;1355;0
WireConnection;1717;1;1723;0
WireConnection;1717;6;1722;0
WireConnection;1317;0;1315;0
WireConnection;1317;1;1314;0
WireConnection;1319;0;1316;0
WireConnection;1319;1;1317;0
WireConnection;1475;0;1717;1
WireConnection;1527;0;1525;0
WireConnection;1527;1;1526;0
WireConnection;1357;0;1356;0
WireConnection;1322;0;1321;0
WireConnection;1322;1;1318;4
WireConnection;1323;0;1320;0
WireConnection;1323;1;1319;0
WireConnection;1529;82;1531;0
WireConnection;1529;5;1527;0
WireConnection;1711;1;1723;0
WireConnection;1711;6;1718;0
WireConnection;1761;0;1357;0
WireConnection;1325;0;1323;0
WireConnection;1325;1;1322;0
WireConnection;1542;0;1544;0
WireConnection;1542;1;1529;32
WireConnection;1542;2;1543;0
WireConnection;1550;0;1478;0
WireConnection;1457;0;1711;4
WireConnection;1770;0;1765;0
WireConnection;1770;1;1767;0
WireConnection;1530;0;1542;0
WireConnection;1530;1;1528;0
WireConnection;1326;0;1325;0
WireConnection;1326;1;1324;0
WireConnection;1549;0;1478;0
WireConnection;1549;1;1550;0
WireConnection;1549;2;1551;0
WireConnection;1534;0;1532;0
WireConnection;1534;1;1533;0
WireConnection;1472;0;1467;0
WireConnection;1472;1;1549;0
WireConnection;1472;2;1477;0
WireConnection;1327;0;1326;0
WireConnection;1771;0;1770;0
WireConnection;1545;0;1530;0
WireConnection;1545;1;1546;0
WireConnection;1328;0;1327;0
WireConnection;1328;1;1329;0
WireConnection;1328;2;1304;0
WireConnection;1523;0;1534;0
WireConnection;1523;1;1545;0
WireConnection;1523;2;1535;0
WireConnection;1772;0;1771;0
WireConnection;1772;1;1472;0
WireConnection;1416;0;1428;0
WireConnection;1416;1;1772;0
WireConnection;1416;2;1417;0
WireConnection;1330;0;1328;0
WireConnection;1540;0;1539;0
WireConnection;1540;1;1523;0
WireConnection;1540;2;1538;0
WireConnection;1548;0;1416;0
WireConnection;1548;1;1540;0
WireConnection;1375;0;1548;0
WireConnection;1407;0;1334;0
WireConnection;1407;1;1331;0
WireConnection;1407;2;1408;0
WireConnection;1118;0;1241;0
WireConnection;1118;1;1248;0
WireConnection;1592;0;1468;0
WireConnection;1592;1;1590;0
WireConnection;1592;2;1608;0
WireConnection;1270;0;1272;0
WireConnection;1270;1;1299;0
WireConnection;1393;0;1390;0
WireConnection;1393;1;1391;0
WireConnection;988;0;989;0
WireConnection;988;1;1118;0
WireConnection;509;0;522;0
WireConnection;1395;0;1398;0
WireConnection;1395;1;1394;0
WireConnection;1401;0;656;0
WireConnection;1401;1;639;0
WireConnection;1401;2;1402;0
WireConnection;1247;0;1115;0
WireConnection;1115;0;1113;0
WireConnection;1116;1;1749;0
WireConnection;1116;0;1117;0
WireConnection;1293;0;1283;0
WireConnection;1293;1;1294;0
WireConnection;1609;0;1407;0
WireConnection;1609;1;1611;0
WireConnection;1609;2;954;0
WireConnection;1119;0;1116;0
WireConnection;1240;0;1220;0
WireConnection;711;0;12;0
WireConnection;711;1;710;0
WireConnection;508;0;522;0
WireConnection;842;0;841;0
WireConnection;842;1;1757;0
WireConnection;1757;0;1697;0
WireConnection;1757;1;1756;0
WireConnection;1757;2;1758;0
WireConnection;1519;1;1184;0
WireConnection;1519;6;1518;0
WireConnection;955;0;474;0
WireConnection;955;1;844;0
WireConnection;955;2;954;0
WireConnection;1179;0;1105;0
WireConnection;1179;1;1108;0
WireConnection;1179;2;1181;0
WireConnection;1509;6;1505;0
WireConnection;1382;82;839;0
WireConnection;1382;80;1497;0
WireConnection;1382;104;1385;0
WireConnection;1186;0;1106;0
WireConnection;1186;1;1187;0
WireConnection;1189;0;1111;0
WireConnection;1189;1;1188;0
WireConnection;1189;2;1106;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;428;0;1588;0
WireConnection;428;1;1369;0
WireConnection;460;0;455;0
WireConnection;460;1;458;0
WireConnection;1405;0;1403;0
WireConnection;1405;1;1464;0
WireConnection;1405;2;1406;0
WireConnection;1482;6;1485;0
WireConnection;1403;0;955;0
WireConnection;1403;1;582;0
WireConnection;1403;2;1404;0
WireConnection;1014;0;1162;0
WireConnection;1014;1;1252;0
WireConnection;1725;1;1382;0
WireConnection;1725;0;1726;0
WireConnection;1180;0;1179;0
WireConnection;522;0;1615;0
WireConnection;522;1;523;0
WireConnection;634;0;640;0
WireConnection;901;0;1255;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;1283;0;1285;0
WireConnection;1283;1;1284;0
WireConnection;1220;0;1231;0
WireConnection;1220;1;1219;0
WireConnection;1220;2;1221;0
WireConnection;1184;0;1191;0
WireConnection;1184;1;1193;0
WireConnection;518;0;1586;0
WireConnection;518;1;513;0
WireConnection;636;0;634;0
WireConnection;513;0;428;0
WireConnection;1162;0;1049;0
WireConnection;1162;1;988;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;1275;0;1270;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;10;0;1410;0
WireConnection;401;0;397;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;1398;0;518;0
WireConnection;1398;1;1290;0
WireConnection;1398;2;1399;0
WireConnection;455;0;1491;1
WireConnection;1389;0;1393;0
WireConnection;1553;0;1581;0
WireConnection;1553;1;1552;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;572;0;487;0
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;768;0;562;0
WireConnection;1615;0;1462;0
WireConnection;499;0;498;0
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;563;0;562;0
WireConnection;563;1;449;0
WireConnection;1251;0;1189;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;1111;0;1249;0
WireConnection;1111;1;1186;0
WireConnection;562;0;449;0
WireConnection;570;0;1495;1
WireConnection;570;1;1493;1
WireConnection;1290;0;518;0
WireConnection;1290;1;1276;0
WireConnection;1493;1;484;0
WireConnection;1493;6;1494;0
WireConnection;571;0;1413;0
WireConnection;571;2;572;0
WireConnection;1187;0;1180;0
WireConnection;1187;1;1519;0
WireConnection;484;0;1413;0
WireConnection;484;2;487;0
WireConnection;1555;0;1598;0
WireConnection;1390;0;1461;0
WireConnection;1390;1;1392;0
WireConnection;1246;0;1119;0
WireConnection;1188;0;1186;0
WireConnection;1557;0;1555;0
WireConnection;1557;1;1554;0
WireConnection;1106;0;1105;0
WireConnection;1106;1;1108;0
WireConnection;498;0;1459;0
WireConnection;1113;1;1752;0
WireConnection;1113;0;1114;0
WireConnection;1181;0;1108;0
WireConnection;1181;1;1182;0
WireConnection;1712;1;1723;0
WireConnection;1712;6;1719;0
WireConnection;1299;0;1296;0
WireConnection;1595;0;1596;0
WireConnection;1595;1;1564;0
WireConnection;1595;2;1594;0
WireConnection;1468;0;1471;0
WireConnection;1468;1;1370;0
WireConnection;1468;2;1469;0
WireConnection;626;0;627;0
WireConnection;877;0;563;0
WireConnection;473;0;1397;0
WireConnection;1588;0;1468;0
WireConnection;1588;1;1592;0
WireConnection;1588;2;1591;0
WireConnection;480;0;478;0
WireConnection;565;0;479;0
WireConnection;1562;0;1559;0
WireConnection;1562;1;1582;1
WireConnection;664;0;466;0
WireConnection;664;1;665;0
WireConnection;664;2;666;0
WireConnection;664;3;667;0
WireConnection;664;5;670;0
WireConnection;1235;0;1230;0
WireConnection;1235;1;1165;0
WireConnection;1289;0;1281;0
WireConnection;1289;1;1287;0
WireConnection;1612;0;842;0
WireConnection;1612;1;1613;0
WireConnection;1612;2;1614;0
WireConnection;461;0;530;0
WireConnection;461;1;1612;0
WireConnection;1565;0;1563;0
WireConnection;1565;1;1595;0
WireConnection;1287;0;1286;0
WireConnection;1287;1;1264;0
WireConnection;1501;1;626;0
WireConnection;1501;6;1500;0
WireConnection;1286;0;1460;0
WireConnection;1373;0;1374;0
WireConnection;1584;0;1553;0
WireConnection;1232;0;1228;0
WireConnection;1599;0;1600;0
WireConnection;1599;3;1604;0
WireConnection;1748;0;1727;0
WireConnection;1453;0;1711;0
WireConnection;23;0;711;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;1558;0;1566;0
WireConnection;1558;1;1567;0
WireConnection;530;0;525;0
WireConnection;530;1;1748;0
WireConnection;1556;0;1568;0
WireConnection;1556;1;1569;0
WireConnection;1563;0;1562;0
WireConnection;1563;1;1561;0
WireConnection;1563;2;1560;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;1411;0;466;0
WireConnection;1411;1;664;0
WireConnection;1411;2;1412;0
WireConnection;1413;0;565;0
WireConnection;1413;1;477;0
WireConnection;1413;2;1414;0
WireConnection;1581;0;1599;0
WireConnection;1581;1;1557;0
WireConnection;1715;1;1723;0
WireConnection;1715;6;1720;0
WireConnection;1410;0;576;0
WireConnection;1410;1;1458;0
WireConnection;1410;2;1409;0
WireConnection;1397;0;1398;0
WireConnection;1397;1;1395;0
WireConnection;1397;2;1400;0
WireConnection;1559;0;1557;0
WireConnection;1559;1;1566;0
WireConnection;1559;2;1558;0
WireConnection;1454;0;1712;0
WireConnection;506;0;504;0
WireConnection;1227;0;1225;0
WireConnection;1227;1;1235;0
WireConnection;1227;2;1165;0
WireConnection;1754;0;1750;0
WireConnection;1716;1;1723;0
WireConnection;1716;6;1721;0
WireConnection;1727;0;1725;0
WireConnection;1727;1;1728;0
WireConnection;1219;0;1218;0
WireConnection;1219;1;1165;0
WireConnection;1752;82;1104;0
WireConnection;1752;5;1755;0
WireConnection;1358;0;1759;0
WireConnection;1358;1;1367;0
WireConnection;1358;2;1357;0
WireConnection;1223;0;1014;0
WireConnection;1552;0;1565;0
WireConnection;1755;0;1751;0
WireConnection;640;0;630;0
WireConnection;1613;0;842;0
WireConnection;1606;0;1565;0
WireConnection;1749;82;1195;0
WireConnection;1749;5;1754;0
WireConnection;1161;0;1158;0
WireConnection;1296;0;1293;0
WireConnection;1296;1;1300;0
WireConnection;1503;6;1504;0
WireConnection;1608;0;1607;0
WireConnection;639;0;636;0
WireConnection;639;1;623;0
WireConnection;1759;0;1365;0
WireConnection;1759;1;1760;0
WireConnection;1456;0;1716;0
WireConnection;1049;0;1050;0
WireConnection;1049;1;1161;0
WireConnection;1233;0;1232;0
WireConnection;630;0;632;0
WireConnection;630;1;1501;0
WireConnection;1582;1;1556;0
WireConnection;1203;0;1164;0
WireConnection;1203;1;1194;0
WireConnection;1228;0;1227;0
WireConnection;1228;1;1516;0
WireConnection;1495;1;573;0
WireConnection;1495;6;1496;0
WireConnection;573;0;571;0
WireConnection;1105;0;1465;0
WireConnection;1284;0;1289;0
WireConnection;1564;0;1582;1
WireConnection;1366;0;461;0
WireConnection;512;0;509;0
WireConnection;512;1;508;0
WireConnection;512;2;1401;0
WireConnection;481;0;570;0
WireConnection;632;0;506;0
WireConnection;632;1;619;0
WireConnection;632;2;633;0
WireConnection;504;0;500;0
WireConnection;504;1;499;0
WireConnection;1255;0;1256;0
WireConnection;1255;1;1223;0
WireConnection;1486;6;1483;0
WireConnection;1455;0;1715;0
WireConnection;525;0;460;0
WireConnection;525;1;526;0
WireConnection;1365;1;1373;0
WireConnection;1224;0;1225;0
WireConnection;1224;1;1165;0
WireConnection;1491;1;1411;0
WireConnection;1491;6;1492;0
WireConnection;1368;0;1358;0
WireConnection;1231;0;1228;0
WireConnection;1231;1;1224;0
WireConnection;1231;2;1233;0
WireConnection;1585;0;512;0
WireConnection;465;0;464;0
WireConnection;1158;0;1242;0
WireConnection;1516;1;1203;0
WireConnection;1516;6;1517;0
WireConnection;1800;2;1405;0
WireConnection;1800;4;1376;0
WireConnection;1800;5;1609;0
ASEEND*/
//CHKSM=BA46426F778E16CE42599365A002AC0E26A7B295
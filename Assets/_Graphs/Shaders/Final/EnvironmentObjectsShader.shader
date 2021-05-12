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
		_DebugGrayscale("DebugGrayscale?", Range( 0 , 1)) = 0
		_Opacity("Opacity?", Range( 0 , 1)) = 1
		_CustomOpacityMask("CustomOpacityMask?", Range( 0 , 1)) = 0
		_OutBrumeColorCorrection("OutBrumeColorCorrection", Color) = (1,1,1,0)
		_OutBrumeColorCorrection_Additionnal("OutBrumeColorCorrection_Additionnal", Color) = (0,0,0,0)
		_OutBrume_Edges_Textures("OutBrume_Edges_Textures?", Range( 0 , 1)) = 0
		[Header(Textures Arrays)]_TextureArray_Textures("TextureArray_Textures", 2DArray) = "white" {}
		_TextureArray_Grunges("TextureArray_Grunges", 2DArray) = "white" {}
		_TextureArray_Noises("TextureArray_Noises", 2DArray) = "white" {}
		[Header(UV 2)]_UV_2_("UV_2_?", Range( 0 , 1)) = 0
		_UV2_TextureArray_Textures("UV2_TextureArray_Textures", 2DArray) = "white" {}
		_UV2_OutBrume_ColorCorrection("UV2_OutBrume_ColorCorrection", Color) = (1,1,1,0)
		[Header(AnimatedGrunge)]_AnimatedGrunge("AnimatedGrunge?", Range( 0 , 1)) = 0
		_IsGrungeAnimated("IsGrungeAnimated?", Range( 0 , 1)) = 0
		_AnimatedGrunge_Tiling("AnimatedGrunge_Tiling", Float) = 1
		_AnimatedGrunge_Flipbook_Columns("AnimatedGrunge_Flipbook_Columns", Float) = 1
		_AnimatedGrunge_Flipbook_Rows("AnimatedGrunge_Flipbook_Rows", Float) = 1
		_AnimatedGrunge_Flipbook_Speed("AnimatedGrunge_Flipbook_Speed", Float) = 1
		_AnimatedGrungeMultiply("AnimatedGrungeMultiply", Float) = 1.58
		[Header(PaintGrunge)]_PaintGrunge("PaintGrunge?", Range( 0 , 1)) = 0
		_PaintGrunge_Tiling("PaintGrunge_Tiling", Float) = 1
		_PaintGrunge_Contrast("PaintGrunge_Contrast", Float) = 0
		_PaintGrunge_Multiply("PaintGrunge_Multiply", Float) = 0
		[Header(Shadow and NoiseEdge)]_Noise_Tiling("Noise_Tiling", Float) = 1
		_Noise_Panner("Noise_Panner", Vector) = (0.2,-0.1,0,0)
		_ScreenBasedNoise("ScreenBasedNoise?", Range( 0 , 1)) = 0
		_StepShadow("StepShadow", Float) = 0.03
		_StepAttenuation("StepAttenuation", Float) = 0.3
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		[Header(TerrainBlending)]_TerrainBlending("TerrainBlending?", Range( 0 , 1)) = 0
		_TerrainBlending_TextureTerrain("TerrainBlending_TextureTerrain", 2D) = "white" {}
		_TerrainBlendingNoise_Tiling("TerrainBlendingNoise_Tiling", Vector) = (1,1,0,0)
		_TerrainBlending_Color("TerrainBlending_Color", Color) = (1,1,1,0)
		_TerrainBlending_Opacity("TerrainBlending_Opacity", Range( 0 , 1)) = 0
		_TerrainBlending_TextureTiling("TerrainBlending_TextureTiling", Float) = 1
		_TerrainBlending_BlendThickness("TerrainBlending_BlendThickness", Range( 0 , 30)) = 0
		_TerrainBlending_Falloff("TerrainBlending_Falloff", Range( 0 , 30)) = 0
		[Header(IB_InBrume)]_IB_ColorCorrection("IB_ColorCorrection", Color) = (1,1,1,0)
		_IB_RGB_Grayscale("IB_RGB_Grayscale?", Range( 0 , 1)) = 0
		_IB_RGB_Contrast("IB_RGB_Contrast", Float) = 0
		_IB_BackColor("IB_BackColor", Color) = (1,1,1,0)
		_IB_ColorShadow("IB_ColorShadow", Color) = (0.5283019,0.5283019,0.5283019,0)
		[Header(IB_Edges)]_IB_Edges_Textures("IB_Edges_Textures", 2D) = "white" {}
		_IB_Edges_Modif1("IB_Edges_Modif1", Range( 0 , 1)) = 0
		_IB_Edges_Modif2("IB_Edges_Modif2", Range( 0 , 1)) = 0
		[Header(IB_Shadow)]_IB_ShadowNoise_Tiling("IB_ShadowNoise_Tiling", Float) = 1
		_IB_ShadowNoise_Panner("IB_ShadowNoise_Panner", Vector) = (0.2,-0.1,0,0)
		_IB_ShadowNoise_Panner_AddSpeed("IB_ShadowNoise_Panner_AddSpeed", Vector) = (0.01,0,0,0)
		_IB_ShadowDrippingNoise_Step("IB_ShadowDrippingNoise_Step", Float) = 0
		_IB_ShadowDrippingNoise_Smoothstep("IB_ShadowDrippingNoise_Smoothstep", Float) = 0.2
		_IB_ShadowDrippingNoise_SmoothstepAnimated("IB_ShadowDrippingNoise_SmoothstepAnimated", Float) = 0
		_IB_ShadowInBrumeGrunge_Tiling("IB_ShadowInBrumeGrunge_Tiling", Float) = 0.2
		_IB_ShadowInBrumeGrunge_Contrast("IB_ShadowInBrumeGrunge_Contrast", Float) = -3.38
		[Header(IB_Normal)]_IB_NormalDrippingNoise_Step("IB_NormalDrippingNoise_Step", Range( 0 , 1)) = 0.45
		_IB_NormalDrippingNoise_Smoothstep("IB_NormalDrippingNoise_Smoothstep", Range( 0 , 1)) = 0.01
		_IB_NormalInBrumeGrunge_Tiling("IB_NormalInBrumeGrunge_Tiling", Float) = 0.2
		_IB_NormalInBrumeGrunge_Contrast("IB_NormalInBrumeGrunge_Contrast", Float) = 2.4
		[Header(IB_TerrainBlending)]_IB_TerrainBlending("IB_TerrainBlending?", Range( 0 , 1)) = 0
		_IB_TerrainBlendingNoise_Tiling("IB_TerrainBlendingNoise_Tiling", Float) = 0
		_IB_TerrainBlending_BlendThickness("IB_TerrainBlending_BlendThickness", Range( 0 , 30)) = 0
		_IB_TerrainBlending_Falloff("IB_TerrainBlending_Falloff", Range( 0 , 30)) = 0
		_IB_TerrainBlending_Color("IB_TerrainBlending_Color", Color) = (0.4245283,0.4245283,0.4245283,0)
		[Header(Wind)]_WindVertexDisplacement("WindVertexDisplacement?", Range( 0 , 1)) = 0
		_Wind_Texture_Tiling("Wind_Texture_Tiling", Float) = 0.5
		_Wind_Texture_Contrast("Wind_Texture_Contrast", Float) = 1
		_Wind_Direction("Wind_Direction", Float) = 1
		_Wind_Density("Wind_Density", Float) = 0.2
		_Wind_Strength("Wind_Strength", Float) = 2
		_WindWave_Speed("WindWave_Speed", Vector) = (0.1,0,0,0)
		_WindWave_Min_Speed("WindWave_Min_Speed", Vector) = (0.05,0,0,0)
		_WindWave_Frequency("WindWave_Frequency", Float) = 0
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

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
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
				float4 ase_texcoord1 : TEXCOORD1;
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
			float4 _UV2_OutBrume_ColorCorrection;
			float4 _TerrainBlending_Color;
			float4 _OutBrumeColorCorrection;
			float4 _IB_TerrainBlending_Color;
			float4 _IB_BackColor;
			float4 _IB_ColorCorrection;
			float4 _ShadowColor;
			float4 _FakeLight_Color;
			float4 _IB_ColorShadow;
			float4 _OutBrumeColorCorrection_Additionnal;
			float2 _Noise_Panner;
			float2 _IB_ShadowNoise_Panner_AddSpeed;
			float2 _WindWave_Min_Speed;
			float2 _WindWave_Speed;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _IB_ShadowNoise_Panner;
			float _IB_ShadowDrippingNoise_SmoothstepAnimated;
			float _IB_ShadowNoise_Tiling;
			float _IB_ShadowDrippingNoise_Step;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _IB_ShadowDrippingNoise_Smoothstep;
			float _Wind_Texture_Contrast;
			float _IB_ShadowInBrumeGrunge_Contrast;
			float _IB_ShadowInBrumeGrunge_Tiling;
			float _TerrainBlending_Opacity;
			float _NormalDebug;
			float _LightDebug;
			float _IB_TerrainBlending;
			float _IB_TerrainBlending_Falloff;
			float _IB_TerrainBlendingNoise_Tiling;
			float _IB_TerrainBlending_BlendThickness;
			float _IB_RGB_Grayscale;
			float _IB_RGB_Contrast;
			float _IB_Edges_Modif2;
			float _IB_Edges_Modif1;
			float _IB_NormalDrippingNoise_Smoothstep;
			float _IB_NormalDrippingNoise_Step;
			float _IB_NormalInBrumeGrunge_Tiling;
			float _IB_NormalInBrumeGrunge_Contrast;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _ScreenBasedNoise;
			float _FakeLightArrayLength;
			float _Wind_Texture_Tiling;
			float _WindWave_Frequency;
			float _Wind_Density;
			float _Wind_Strength;
			float _Wind_Direction;
			float _WindVertexDisplacement;
			float _Out_or_InBrume;
			float _AnimatedGrunge_Tiling;
			float _AnimatedGrunge_Flipbook_Columns;
			float _AnimatedGrunge_Flipbook_Rows;
			float _AnimatedGrunge_Flipbook_Speed;
			float _IsGrungeAnimated;
			float _AnimatedGrungeMultiply;
			float _AnimatedGrunge;
			float _PaintGrunge_Contrast;
			float _PaintGrunge_Tiling;
			float _PaintGrunge_Multiply;
			float _PaintGrunge;
			float _UV_2_;
			float _DebugGrayscale;
			float _OutBrume_Edges_Textures;
			float _TerrainBlending_TextureTiling;
			float _TerrainBlending_BlendThickness;
			float _TerrainBlending_Falloff;
			float _TerrainBlending;
			float _StepShadow;
			float _StepAttenuation;
			float _Noise_Tiling;
			float _CustomOpacityMask;
			float _WaveFakeLight_Max;
			float _Opacity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D_ARRAY(_TextureArray_Noises);
			SAMPLER(sampler_TextureArray_Noises);
			TEXTURE2D_ARRAY(_TextureArray_Grunges);
			SAMPLER(sampler_TextureArray_Grunges);
			TEXTURE2D_ARRAY(_TextureArray_Textures);
			SAMPLER(sampler_TextureArray_Textures);
			TEXTURE2D_ARRAY(_UV2_TextureArray_Textures);
			SAMPLER(sampler_UV2_TextureArray_Textures);
			sampler2D _IB_Edges_Textures;
			sampler2D _TerrainBlending_TextureTerrain;
			sampler2D TB_DEPTH;
			float TB_OFFSET_X;
			float TB_OFFSET_Z;
			float TB_SCALE;
			float TB_FARCLIP;
			float TB_OFFSET_Y;
			float4 FakeLightsPositionsArray[10];
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
				UNITY_DEFINE_INSTANCED_PROP(float4, _IB_Edges_Textures_ST)
			UNITY_INSTANCING_BUFFER_END(EnvironmentObjectsShader)


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
			
			void TriplanarWeights229_g101( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			void TriplanarWeights229_g27( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			float CycleThroughArray2197( float In0, float3 WorldPos, float Length, float LightStep, float LightStepAttenuation )
			{
				float result=0;
				for(int i=0; i<Length;i++)
				{
					float dist = distance(WorldPos,FakeLightsPositionsArray[i]);
					result += 1 - smoothstep( LightStep, LightStepAttenuation, dist);
				}
				return result;
			}
			
			void TriplanarWeights229_g102( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (0.0).xx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _WindWave_Frequency ) * _WindWave_Speed + ase_worldPos.xy);
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + ase_worldPos.xy);
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( panner1312 + panner1313 );
				float4 temp_cast_4 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_5 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( CalculateContrast(_Wind_Texture_Contrast,SAMPLE_TEXTURE2D_ARRAY_LOD( _TextureArray_Noises, sampler_TextureArray_Noises, texCoord1319,1.0, 0.0 )) - temp_cast_4 ) * _Wind_Strength ) , temp_cast_5 , v.ase_color.r);
				float3 worldToObjDir2095 = mul( GetWorldToObjectMatrix(), float4( lerpResult1328.rgb, 0 ) ).xyz;
				float cos2096 = cos( _Wind_Direction );
				float sin2096 = sin( _Wind_Direction );
				float2 rotator2096 = mul( worldToObjDir2095.xy - float2( 0,0 ) , float2x2( cos2096 , -sin2096 , sin2096 , cos2096 )) + float2( 0,0 );
				float2 WindVertexDisplacement1330 = rotator2096;
				float2 lerpResult1407 = lerp( temp_cast_0 , WindVertexDisplacement1330 , _WindVertexDisplacement);
				float2 temp_cast_8 = (0.0).xx;
				float2 lerpResult1609 = lerp( lerpResult1407 , temp_cast_8 , _Out_or_InBrume);
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord6.xyz = ase_worldTangent;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord7.xyz = ase_worldBitangent;
				
				o.ase_texcoord5.xy = v.ase_texcoord.xy;
				o.ase_texcoord5.zw = v.ase_texcoord1.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = float3( lerpResult1609 ,  0.0 );
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
				float4 ase_texcoord1 : TEXCOORD1;
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
				o.ase_texcoord1 = v.ase_texcoord1;
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
				o.ase_texcoord1 = patch[0].ase_texcoord1 * bary.x + patch[1].ase_texcoord1 * bary.y + patch[2].ase_texcoord1 * bary.z;
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
				float2 temp_output_466_0 = ( (ase_screenPosNorm).xy * _AnimatedGrunge_Tiling );
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles664 = _AnimatedGrunge_Flipbook_Columns * _AnimatedGrunge_Flipbook_Rows;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset664 = 1.0f / _AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset664 = 1.0f / _AnimatedGrunge_Flipbook_Rows;
				// Speed of animation
				float fbspeed664 = _TimeParameters.x * _AnimatedGrunge_Flipbook_Speed;
				// UV Tiling (col and row offset)
				float2 fbtiling664 = float2(fbcolsoffset664, fbrowsoffset664);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex664 = round( fmod( fbspeed664 + 0.0, fbtotaltiles664) );
				fbcurrenttileindex664 += ( fbcurrenttileindex664 < 0) ? fbtotaltiles664 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox664 = round ( fmod ( fbcurrenttileindex664, _AnimatedGrunge_Flipbook_Columns ) );
				// Multiply Offset X by coloffset
				float fboffsetx664 = fblinearindextox664 * fbcolsoffset664;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy664 = round( fmod( ( fbcurrenttileindex664 - fblinearindextox664 ) / _AnimatedGrunge_Flipbook_Columns, _AnimatedGrunge_Flipbook_Rows ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy664 = (int)(_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy664;
				// Multiply Offset Y by rowoffset
				float fboffsety664 = fblinearindextoy664 * fbrowsoffset664;
				// UV Offset
				float2 fboffset664 = float2(fboffsetx664, fboffsety664);
				// Flipbook UV
				half2 fbuv664 = temp_output_466_0 * fbtiling664 + fboffset664;
				// *** END Flipbook UV Animation vars ***
				float2 lerpResult1411 = lerp( temp_output_466_0 , fbuv664 , _IsGrungeAnimated);
				float3 temp_cast_1 = (SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Grunges, sampler_TextureArray_Grunges, lerpResult1411,0.0 ).r).xxx;
				float grayscale455 = Luminance(temp_cast_1);
				float4 temp_cast_2 = (grayscale455).xxxx;
				float4 lerpResult1834 = lerp( temp_cast_0 , ( CalculateContrast(1.0,temp_cast_2) * _AnimatedGrungeMultiply ) , _AnimatedGrunge);
				float localStochasticTiling216_g101 = ( 0.0 );
				float2 temp_cast_3 = (_PaintGrunge_Tiling).xx;
				float2 temp_output_104_0_g101 = temp_cast_3;
				float3 temp_output_80_0_g101 = WorldPosition;
				float2 Triplanar_UV050_g101 = ( temp_output_104_0_g101 * (temp_output_80_0_g101).zy );
				float2 UV216_g101 = Triplanar_UV050_g101;
				float2 UV1216_g101 = float2( 0,0 );
				float2 UV2216_g101 = float2( 0,0 );
				float2 UV3216_g101 = float2( 0,0 );
				float W1216_g101 = 0.0;
				float W2216_g101 = 0.0;
				float W3216_g101 = 0.0;
				StochasticTiling( UV216_g101 , UV1216_g101 , UV2216_g101 , UV3216_g101 , W1216_g101 , W2216_g101 , W3216_g101 );
				float Input_Index184_g101 = 1.0;
				float2 temp_output_280_0_g101 = ddx( Triplanar_UV050_g101 );
				float2 temp_output_275_0_g101 = ddy( Triplanar_UV050_g101 );
				float localTriplanarWeights229_g101 = ( 0.0 );
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 WorldNormal229_g101 = ase_worldNormal;
				float W0229_g101 = 0.0;
				float W1229_g101 = 0.0;
				float W2229_g101 = 0.0;
				TriplanarWeights229_g101( WorldNormal229_g101 , W0229_g101 , W1229_g101 , W2229_g101 );
				float localStochasticTiling215_g101 = ( 0.0 );
				float2 Triplanar_UV164_g101 = ( temp_output_104_0_g101 * (temp_output_80_0_g101).zx );
				float2 UV215_g101 = Triplanar_UV164_g101;
				float2 UV1215_g101 = float2( 0,0 );
				float2 UV2215_g101 = float2( 0,0 );
				float2 UV3215_g101 = float2( 0,0 );
				float W1215_g101 = 0.0;
				float W2215_g101 = 0.0;
				float W3215_g101 = 0.0;
				StochasticTiling( UV215_g101 , UV1215_g101 , UV2215_g101 , UV3215_g101 , W1215_g101 , W2215_g101 , W3215_g101 );
				float2 temp_output_242_0_g101 = ddx( Triplanar_UV164_g101 );
				float2 temp_output_247_0_g101 = ddy( Triplanar_UV164_g101 );
				float localStochasticTiling201_g101 = ( 0.0 );
				float2 Triplanar_UV271_g101 = ( temp_output_104_0_g101 * (temp_output_80_0_g101).xy );
				float2 UV201_g101 = Triplanar_UV271_g101;
				float2 UV1201_g101 = float2( 0,0 );
				float2 UV2201_g101 = float2( 0,0 );
				float2 UV3201_g101 = float2( 0,0 );
				float W1201_g101 = 0.0;
				float W2201_g101 = 0.0;
				float W3201_g101 = 0.0;
				StochasticTiling( UV201_g101 , UV1201_g101 , UV2201_g101 , UV3201_g101 , W1201_g101 , W2201_g101 , W3201_g101 );
				float2 temp_output_214_0_g101 = ddx( Triplanar_UV271_g101 );
				float2 temp_output_258_0_g101 = ddy( Triplanar_UV271_g101 );
				float4 Output_TriplanarArray296_g101 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1216_g101,Input_Index184_g101, temp_output_280_0_g101, temp_output_275_0_g101 ) * W1216_g101 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2216_g101,Input_Index184_g101, temp_output_280_0_g101, temp_output_275_0_g101 ) * W2216_g101 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3216_g101,Input_Index184_g101, temp_output_280_0_g101, temp_output_275_0_g101 ) * W3216_g101 ) ) * W0229_g101 ) + ( W1229_g101 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1215_g101,Input_Index184_g101, temp_output_242_0_g101, temp_output_247_0_g101 ) * W1215_g101 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2215_g101,Input_Index184_g101, temp_output_242_0_g101, temp_output_247_0_g101 ) * W2215_g101 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3215_g101,Input_Index184_g101, temp_output_242_0_g101, temp_output_247_0_g101 ) * W3215_g101 ) ) ) + ( W2229_g101 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1201_g101,Input_Index184_g101, temp_output_214_0_g101, temp_output_258_0_g101 ) * W1201_g101 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2201_g101,Input_Index184_g101, temp_output_214_0_g101, temp_output_258_0_g101 ) * W2201_g101 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3201_g101,Input_Index184_g101, temp_output_214_0_g101, temp_output_258_0_g101 ) * W3201_g101 ) ) ) );
				float lerpResult1831 = lerp( 1.0 , ( CalculateContrast(_PaintGrunge_Contrast,Output_TriplanarArray296_g101) * _PaintGrunge_Multiply ).r , _PaintGrunge);
				float2 texCoord1622 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode1711 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures, sampler_TextureArray_Textures, texCoord1622,0.0 );
				float4 Object_Albedo_Texture1453 = tex2DArrayNode1711;
				float4 temp_cast_4 = (1.0).xxxx;
				float2 texCoord2067 = IN.ase_texcoord5.zw * float2( 1,1 ) + float2( 0,0 );
				float4 Object_Albedo_Texture_UV22072 = SAMPLE_TEXTURE2D_ARRAY( _UV2_TextureArray_Textures, sampler_UV2_TextureArray_Textures, texCoord2067,0.0 );
				float Switch_UV_22074 = _UV_2_;
				float4 lerpResult2085 = lerp( temp_cast_4 , ( Object_Albedo_Texture_UV22072 * _UV2_OutBrume_ColorCorrection ) , Switch_UV_22074);
				float4 blendOpSrc2107 = ( Object_Albedo_Texture1453 * _OutBrumeColorCorrection );
				float4 blendOpDest2107 = lerpResult2085;
				float4 temp_output_2107_0 = ( saturate( ( blendOpSrc2107 * blendOpDest2107 ) ));
				float grayscale1613 = dot(temp_output_2107_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_6 = (grayscale1613).xxxx;
				float4 lerpResult1612 = lerp( temp_output_2107_0 , temp_cast_6 , _DebugGrayscale);
				float4 temp_cast_7 = (1.0).xxxx;
				float4 _IB_Edges_Textures_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(EnvironmentObjectsShader,_IB_Edges_Textures_ST);
				float2 uv_IB_Edges_Textures = IN.ase_texcoord5.xy * _IB_Edges_Textures_ST_Instance.xy + _IB_Edges_Textures_ST_Instance.zw;
				float4 lerpResult2182 = lerp( temp_cast_7 , tex2D( _IB_Edges_Textures, uv_IB_Edges_Textures ) , _OutBrume_Edges_Textures);
				float4 blendOpSrc461 = ( lerpResult1834 * lerpResult1831 );
				float4 blendOpDest461 = ( ( lerpResult1612 * lerpResult2182 ) + _OutBrumeColorCorrection_Additionnal );
				float4 RGB1366 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
				float2 temp_cast_8 = (_TerrainBlending_TextureTiling).xx;
				float2 texCoord1373 = IN.ase_texcoord5.xy * temp_cast_8 + float2( 0,0 );
				float worldY1344 = WorldPosition.y;
				float4 temp_cast_9 = (worldY1344).xxxx;
				float2 appendResult1340 = (float2(WorldPosition.x , WorldPosition.z));
				float2 appendResult1339 = (float2(TB_OFFSET_X , TB_OFFSET_Z));
				float4 temp_cast_10 = (TB_OFFSET_Y).xxxx;
				float4 temp_output_1352_0 = ( ( temp_cast_9 - ( tex2D( TB_DEPTH, ( ( appendResult1340 - appendResult1339 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_10 );
				float localStochasticTiling216_g27 = ( 0.0 );
				float2 temp_output_104_0_g27 = _TerrainBlendingNoise_Tiling;
				float3 temp_output_80_0_g27 = WorldPosition;
				float2 Triplanar_UV050_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).zy );
				float2 UV216_g27 = Triplanar_UV050_g27;
				float2 UV1216_g27 = float2( 0,0 );
				float2 UV2216_g27 = float2( 0,0 );
				float2 UV3216_g27 = float2( 0,0 );
				float W1216_g27 = 0.0;
				float W2216_g27 = 0.0;
				float W3216_g27 = 0.0;
				StochasticTiling( UV216_g27 , UV1216_g27 , UV2216_g27 , UV3216_g27 , W1216_g27 , W2216_g27 , W3216_g27 );
				float Input_Index184_g27 = 3.0;
				float2 temp_output_280_0_g27 = ddx( Triplanar_UV050_g27 );
				float2 temp_output_275_0_g27 = ddy( Triplanar_UV050_g27 );
				float localTriplanarWeights229_g27 = ( 0.0 );
				float3 WorldNormal229_g27 = ase_worldNormal;
				float W0229_g27 = 0.0;
				float W1229_g27 = 0.0;
				float W2229_g27 = 0.0;
				TriplanarWeights229_g27( WorldNormal229_g27 , W0229_g27 , W1229_g27 , W2229_g27 );
				float localStochasticTiling215_g27 = ( 0.0 );
				float2 Triplanar_UV164_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).zx );
				float2 UV215_g27 = Triplanar_UV164_g27;
				float2 UV1215_g27 = float2( 0,0 );
				float2 UV2215_g27 = float2( 0,0 );
				float2 UV3215_g27 = float2( 0,0 );
				float W1215_g27 = 0.0;
				float W2215_g27 = 0.0;
				float W3215_g27 = 0.0;
				StochasticTiling( UV215_g27 , UV1215_g27 , UV2215_g27 , UV3215_g27 , W1215_g27 , W2215_g27 , W3215_g27 );
				float2 temp_output_242_0_g27 = ddx( Triplanar_UV164_g27 );
				float2 temp_output_247_0_g27 = ddy( Triplanar_UV164_g27 );
				float localStochasticTiling201_g27 = ( 0.0 );
				float2 Triplanar_UV271_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).xy );
				float2 UV201_g27 = Triplanar_UV271_g27;
				float2 UV1201_g27 = float2( 0,0 );
				float2 UV2201_g27 = float2( 0,0 );
				float2 UV3201_g27 = float2( 0,0 );
				float W1201_g27 = 0.0;
				float W2201_g27 = 0.0;
				float W3201_g27 = 0.0;
				StochasticTiling( UV201_g27 , UV1201_g27 , UV2201_g27 , UV3201_g27 , W1201_g27 , W2201_g27 , W3201_g27 );
				float2 temp_output_214_0_g27 = ddx( Triplanar_UV271_g27 );
				float2 temp_output_258_0_g27 = ddy( Triplanar_UV271_g27 );
				float4 Output_TriplanarArray296_g27 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W1216_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W2216_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W3216_g27 ) ) * W0229_g27 ) + ( W1229_g27 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W1215_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W2215_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W3215_g27 ) ) ) + ( W2229_g27 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W1201_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W2201_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W3201_g27 ) ) ) );
				float4 clampResult1354 = clamp( ( temp_output_1352_0 / ( _TerrainBlending_BlendThickness * Output_TriplanarArray296_g27 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_11 = (_TerrainBlending_Falloff).xxxx;
				float4 clampResult1356 = clamp( pow( clampResult1354 , temp_cast_11 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult1358 = lerp( ( tex2D( _TerrainBlending_TextureTerrain, texCoord1373 ) * _TerrainBlending_Color ) , RGB1366 , clampResult1356.r);
				float4 RBG_TerrainBlending1368 = lerpResult1358;
				float4 lerpResult1468 = lerp( RGB1366 , RBG_TerrainBlending1368 , _TerrainBlending);
				float temp_output_387_0 = ( _StepShadow + _StepAttenuation );
				float4 tex2DArrayNode1712 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures, sampler_TextureArray_Textures, texCoord1622,1.0 );
				float4 Object_Normal_Texture1454 = tex2DArrayNode1712;
				float4 tex2DArrayNode2069 = SAMPLE_TEXTURE2D_ARRAY( _UV2_TextureArray_Textures, sampler_UV2_TextureArray_Textures, texCoord2067,1.0 );
				float4 Object_Normal_Texture_UV22073 = tex2DArrayNode2069;
				float4 lerpResult2137 = lerp( Object_Normal_Texture1454 , float4( BlendNormal( Object_Normal_Texture1454.rgb , Object_Normal_Texture_UV22073.rgb ) , 0.0 ) , Switch_UV_22074);
				float3 ase_worldTangent = IN.ase_texcoord6.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal10 = lerpResult2137.rgb;
				float3 worldNormal10 = float3(dot(tanToWorld0,tanNormal10), dot(tanToWorld1,tanNormal10), dot(tanToWorld2,tanNormal10));
				float dotResult12 = dot( worldNormal10 , SafeNormalize(_MainLightPosition.xyz) );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir23 = ( dotResult12 * ase_lightAtten );
				float smoothstepResult385 = smoothstep( _StepShadow , temp_output_387_0 , normal_LightDir23);
				float2 temp_cast_16 = (_Noise_Tiling).xx;
				float2 texCoord565 = IN.ase_texcoord5.xy * temp_cast_16 + float2( 0,0 );
				float2 lerpResult1413 = lerp( texCoord565 , ( (ase_screenPosNorm).xy * _Noise_Tiling ) , _ScreenBasedNoise);
				float2 panner571 = ( 1.0 * _Time.y * ( _Noise_Panner + float2( 0.1,0.05 ) ) + lerpResult1413);
				float2 panner484 = ( 1.0 * _Time.y * _Noise_Panner + lerpResult1413);
				float blendOpSrc570 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Noises, sampler_TextureArray_Noises, ( panner571 + float2( 0.5,0.5 ) ),0.0 ).r;
				float blendOpDest570 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Noises, sampler_TextureArray_Noises, panner484,0.0 ).r;
				float MapNoise481 = ( saturate( 2.0f*blendOpDest570*blendOpSrc570 + blendOpDest570*blendOpDest570*(1.0f - 2.0f*blendOpSrc570) ));
				float smoothstepResult401 = smoothstep( 0.0 , 0.6 , ( smoothstepResult385 - MapNoise481 ));
				float smoothstepResult445 = smoothstep( ( _StepShadow + -0.02 ) , ( temp_output_387_0 + -0.02 ) , normal_LightDir23);
				float blendOpSrc444 = smoothstepResult401;
				float blendOpDest444 = smoothstepResult445;
				float4 temp_cast_17 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest444) / max( blendOpSrc444, 0.00001) ) ) ))).xxxx;
				float4 blendOpSrc449 = temp_cast_17;
				float4 blendOpDest449 = _ShadowColor;
				float4 temp_output_449_0 = ( saturate( ( blendOpSrc449 * blendOpDest449 ) ));
				float4 Shadow877 = ( step( temp_output_449_0 , float4( 0,0,0,0 ) ) + temp_output_449_0 );
				float4 blendOpSrc428 = lerpResult1468;
				float4 blendOpDest428 = Shadow877;
				float4 temp_output_428_0 = ( saturate( ( blendOpSrc428 * blendOpDest428 ) ));
				float In02197 = FakeLightsPositionsArray[0].x;
				float3 WorldPos2197 = WorldPosition;
				float Length2197 = _FakeLightArrayLength;
				float mulTime2207 = _TimeParameters.x * _WaveFakeLight_Time;
				float lerpResult2198 = lerp( _WaveFakeLight_Max , _WaveFakeLight_Min , cos( mulTime2207 ));
				float temp_output_2205_0 = ( lerpResult2198 * _FakeLightStep );
				float LightStep2197 = temp_output_2205_0;
				float LightStepAttenuation2197 = ( temp_output_2205_0 + _FakeLightStepAttenuation );
				float localCycleThroughArray2197 = CycleThroughArray2197( In02197 , WorldPos2197 , Length2197 , LightStep2197 , LightStepAttenuation2197 );
				float FakeLights2210 = saturate( localCycleThroughArray2197 );
				float4 lerpResult2212 = lerp( temp_output_428_0 , ( temp_output_428_0 + _FakeLight_Color ) , FakeLights2210);
				float4 EndOutBrume473 = lerpResult2212;
				float smoothstepResult1227 = smoothstep( ( _IB_ShadowDrippingNoise_Step + _IB_ShadowDrippingNoise_Smoothstep ) , _IB_ShadowDrippingNoise_Step , normal_LightDir23);
				float2 temp_cast_19 = (_IB_ShadowNoise_Tiling).xx;
				float2 texCoord1943 = IN.ase_texcoord5.xy * temp_cast_19 + float2( 0,0 );
				float2 panner1930 = ( 1.0 * _Time.y * ( _IB_ShadowNoise_Panner + _IB_ShadowNoise_Panner_AddSpeed ) + texCoord1943);
				float2 panner1931 = ( 1.0 * _Time.y * _IB_ShadowNoise_Panner + texCoord1943);
				float blendOpSrc1932 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Noises, sampler_TextureArray_Noises, ( panner1930 + float2( 0.5,0.5 ) ),0.0 ).r;
				float blendOpDest1932 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Noises, sampler_TextureArray_Noises, panner1931,0.0 ).r;
				float MapNoise_IB1934 = ( saturate( 2.0f*blendOpDest1932*blendOpSrc1932 + blendOpDest1932*blendOpDest1932*(1.0f - 2.0f*blendOpSrc1932) ));
				float temp_output_1228_0 = ( smoothstepResult1227 - MapNoise_IB1934 );
				float temp_output_1950_0 = ( _IB_ShadowDrippingNoise_Step - _IB_ShadowDrippingNoise_SmoothstepAnimated );
				float smoothstepResult1951 = smoothstep( ( temp_output_1950_0 + _IB_ShadowDrippingNoise_Smoothstep ) , temp_output_1950_0 , normal_LightDir23);
				float blendOpSrc1231 = temp_output_1228_0;
				float blendOpDest1231 = smoothstepResult1951;
				float lerpBlendMode1231 = lerp(blendOpDest1231,( blendOpSrc1231 + blendOpDest1231 ),( 1.0 - step( temp_output_1228_0 , 0.0 ) ));
				float ShadowDrippingNoise1240 = ( saturate( lerpBlendMode1231 ));
				float localStochasticTiling171_g104 = ( 0.0 );
				float2 temp_cast_20 = (_IB_ShadowInBrumeGrunge_Tiling).xx;
				float2 texCoord1754 = IN.ase_texcoord5.xy * temp_cast_20 + float2( 0,0 );
				float2 Input_UV145_g104 = texCoord1754;
				float2 UV171_g104 = Input_UV145_g104;
				float2 UV1171_g104 = float2( 0,0 );
				float2 UV2171_g104 = float2( 0,0 );
				float2 UV3171_g104 = float2( 0,0 );
				float W1171_g104 = 0.0;
				float W2171_g104 = 0.0;
				float W3171_g104 = 0.0;
				StochasticTiling( UV171_g104 , UV1171_g104 , UV2171_g104 , UV3171_g104 , W1171_g104 , W2171_g104 , W3171_g104 );
				float Input_Index184_g104 = 2.0;
				float2 temp_output_172_0_g104 = ddx( Input_UV145_g104 );
				float2 temp_output_182_0_g104 = ddy( Input_UV145_g104 );
				float4 Output_2DArray294_g104 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1171_g104,Input_Index184_g104, temp_output_172_0_g104, temp_output_182_0_g104 ) * W1171_g104 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2171_g104,Input_Index184_g104, temp_output_172_0_g104, temp_output_182_0_g104 ) * W2171_g104 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3171_g104,Input_Index184_g104, temp_output_172_0_g104, temp_output_182_0_g104 ) * W3171_g104 ) );
				float grayscale1119 = Luminance(CalculateContrast(_IB_ShadowInBrumeGrunge_Contrast,Output_2DArray294_g104).rgb);
				float ShadowInBrumeGrunge1246 = grayscale1119;
				float4 blendOpSrc1162 = ( _IB_BackColor * ( 1.0 - ShadowDrippingNoise1240 ) );
				float4 blendOpDest1162 = ( _IB_ColorShadow * ( ShadowDrippingNoise1240 * ShadowInBrumeGrunge1246 ) );
				float localStochasticTiling171_g103 = ( 0.0 );
				float2 temp_cast_22 = (_IB_NormalInBrumeGrunge_Tiling).xx;
				float2 texCoord1755 = IN.ase_texcoord5.xy * temp_cast_22 + float2( 0,0 );
				float2 Input_UV145_g103 = texCoord1755;
				float2 UV171_g103 = Input_UV145_g103;
				float2 UV1171_g103 = float2( 0,0 );
				float2 UV2171_g103 = float2( 0,0 );
				float2 UV3171_g103 = float2( 0,0 );
				float W1171_g103 = 0.0;
				float W2171_g103 = 0.0;
				float W3171_g103 = 0.0;
				StochasticTiling( UV171_g103 , UV1171_g103 , UV2171_g103 , UV3171_g103 , W1171_g103 , W2171_g103 , W3171_g103 );
				float Input_Index184_g103 = 3.0;
				float2 temp_output_172_0_g103 = ddx( Input_UV145_g103 );
				float2 temp_output_182_0_g103 = ddy( Input_UV145_g103 );
				float4 Output_2DArray294_g103 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1171_g103,Input_Index184_g103, temp_output_172_0_g103, temp_output_182_0_g103 ) * W1171_g103 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2171_g103,Input_Index184_g103, temp_output_172_0_g103, temp_output_182_0_g103 ) * W2171_g103 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3171_g103,Input_Index184_g103, temp_output_172_0_g103, temp_output_182_0_g103 ) * W3171_g103 ) );
				float grayscale1115 = Luminance(CalculateContrast(_IB_NormalInBrumeGrunge_Contrast,Output_2DArray294_g103).rgb);
				float NormalInBrumeGrunge1247 = grayscale1115;
				float4 NormalMixedUV22091 = lerpResult2137;
				float grayscale1105 = (NormalMixedUV22091.rgb.r + NormalMixedUV22091.rgb.g + NormalMixedUV22091.rgb.b) / 3;
				float smoothstepResult2161 = smoothstep( _IB_NormalDrippingNoise_Step , _IB_NormalDrippingNoise_Smoothstep , grayscale1105);
				float NormalDrippingGrunge1251 = ( ( NormalInBrumeGrunge1247 * smoothstepResult2161 ) + ( 1.0 - smoothstepResult2161 ) );
				float temp_output_1979_0 = step( ShadowDrippingNoise1240 , 0.0 );
				float4 lerpResult2135 = lerp( tex2D( _IB_Edges_Textures, uv_IB_Edges_Textures ) , Object_Albedo_Texture_UV22072 , Switch_UV_22074);
				float IB_Edges1994 = (0.0 + (( ( temp_output_1979_0 * ( lerpResult2135.r + _IB_Edges_Modif1 ) ) + ( ( 1.0 - temp_output_1979_0 ) * ( lerpResult2135.r + _IB_Edges_Modif2 ) ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
				float4 temp_cast_25 = (IB_Edges1994).xxxx;
				float4 blendOpSrc1989 = ( max( blendOpSrc1162, blendOpDest1162 ) * NormalDrippingGrunge1251 );
				float4 blendOpDest1989 = temp_cast_25;
				float grayscale2188 = Luminance(EndOutBrume473.rgb);
				float4 temp_cast_27 = (grayscale2188).xxxx;
				float4 lerpResult2186 = lerp( ( _IB_ColorCorrection * (float4( 0,0,0,0 ) + (( saturate( ( blendOpSrc1989 * blendOpDest1989 ) )) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) ) , CalculateContrast(_IB_RGB_Contrast,temp_cast_27) , _IB_RGB_Grayscale);
				float4 EndInBrume901 = lerpResult2186;
				float4 temp_cast_28 = (worldY1344).xxxx;
				float4 temp_cast_29 = (TB_OFFSET_Y).xxxx;
				float4 TerrainBlending2034 = temp_output_1352_0;
				float localStochasticTiling216_g102 = ( 0.0 );
				float2 appendResult2140 = (float2(_IB_TerrainBlendingNoise_Tiling , _IB_TerrainBlendingNoise_Tiling));
				float2 temp_output_104_0_g102 = appendResult2140;
				float3 temp_output_80_0_g102 = WorldPosition;
				float2 Triplanar_UV050_g102 = ( temp_output_104_0_g102 * (temp_output_80_0_g102).zy );
				float2 UV216_g102 = Triplanar_UV050_g102;
				float2 UV1216_g102 = float2( 0,0 );
				float2 UV2216_g102 = float2( 0,0 );
				float2 UV3216_g102 = float2( 0,0 );
				float W1216_g102 = 0.0;
				float W2216_g102 = 0.0;
				float W3216_g102 = 0.0;
				StochasticTiling( UV216_g102 , UV1216_g102 , UV2216_g102 , UV3216_g102 , W1216_g102 , W2216_g102 , W3216_g102 );
				float Input_Index184_g102 = 3.0;
				float2 temp_output_280_0_g102 = ddx( Triplanar_UV050_g102 );
				float2 temp_output_275_0_g102 = ddy( Triplanar_UV050_g102 );
				float localTriplanarWeights229_g102 = ( 0.0 );
				float3 WorldNormal229_g102 = ase_worldNormal;
				float W0229_g102 = 0.0;
				float W1229_g102 = 0.0;
				float W2229_g102 = 0.0;
				TriplanarWeights229_g102( WorldNormal229_g102 , W0229_g102 , W1229_g102 , W2229_g102 );
				float localStochasticTiling215_g102 = ( 0.0 );
				float2 Triplanar_UV164_g102 = ( temp_output_104_0_g102 * (temp_output_80_0_g102).zx );
				float2 UV215_g102 = Triplanar_UV164_g102;
				float2 UV1215_g102 = float2( 0,0 );
				float2 UV2215_g102 = float2( 0,0 );
				float2 UV3215_g102 = float2( 0,0 );
				float W1215_g102 = 0.0;
				float W2215_g102 = 0.0;
				float W3215_g102 = 0.0;
				StochasticTiling( UV215_g102 , UV1215_g102 , UV2215_g102 , UV3215_g102 , W1215_g102 , W2215_g102 , W3215_g102 );
				float2 temp_output_242_0_g102 = ddx( Triplanar_UV164_g102 );
				float2 temp_output_247_0_g102 = ddy( Triplanar_UV164_g102 );
				float localStochasticTiling201_g102 = ( 0.0 );
				float2 Triplanar_UV271_g102 = ( temp_output_104_0_g102 * (temp_output_80_0_g102).xy );
				float2 UV201_g102 = Triplanar_UV271_g102;
				float2 UV1201_g102 = float2( 0,0 );
				float2 UV2201_g102 = float2( 0,0 );
				float2 UV3201_g102 = float2( 0,0 );
				float W1201_g102 = 0.0;
				float W2201_g102 = 0.0;
				float W3201_g102 = 0.0;
				StochasticTiling( UV201_g102 , UV1201_g102 , UV2201_g102 , UV3201_g102 , W1201_g102 , W2201_g102 , W3201_g102 );
				float2 temp_output_214_0_g102 = ddx( Triplanar_UV271_g102 );
				float2 temp_output_258_0_g102 = ddy( Triplanar_UV271_g102 );
				float4 Output_TriplanarArray296_g102 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1216_g102,Input_Index184_g102, temp_output_280_0_g102, temp_output_275_0_g102 ) * W1216_g102 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2216_g102,Input_Index184_g102, temp_output_280_0_g102, temp_output_275_0_g102 ) * W2216_g102 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3216_g102,Input_Index184_g102, temp_output_280_0_g102, temp_output_275_0_g102 ) * W3216_g102 ) ) * W0229_g102 ) + ( W1229_g102 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1215_g102,Input_Index184_g102, temp_output_242_0_g102, temp_output_247_0_g102 ) * W1215_g102 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2215_g102,Input_Index184_g102, temp_output_242_0_g102, temp_output_247_0_g102 ) * W2215_g102 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3215_g102,Input_Index184_g102, temp_output_242_0_g102, temp_output_247_0_g102 ) * W3215_g102 ) ) ) + ( W2229_g102 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1201_g102,Input_Index184_g102, temp_output_214_0_g102, temp_output_258_0_g102 ) * W1201_g102 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2201_g102,Input_Index184_g102, temp_output_214_0_g102, temp_output_258_0_g102 ) * W2201_g102 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3201_g102,Input_Index184_g102, temp_output_214_0_g102, temp_output_258_0_g102 ) * W3201_g102 ) ) ) );
				float4 clampResult2044 = clamp( ( TerrainBlending2034 / ( _IB_TerrainBlending_BlendThickness * Output_TriplanarArray296_g102 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_30 = (_IB_TerrainBlending_Falloff).xxxx;
				float4 clampResult2046 = clamp( pow( clampResult2044 , temp_cast_30 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float IB_TerrainBlending2147 = clampResult2046.r;
				float4 lerpResult2049 = lerp( _IB_TerrainBlending_Color , EndInBrume901 , IB_TerrainBlending2147);
				float4 lerpResult2149 = lerp( EndInBrume901 , lerpResult2049 , _IB_TerrainBlending);
				float4 FinalInBrume2052 = lerpResult2149;
				float4 lerpResult955 = lerp( EndOutBrume473 , FinalInBrume2052 , _Out_or_InBrume);
				float4 temp_cast_31 = (normal_LightDir23).xxxx;
				float4 lerpResult1403 = lerp( lerpResult955 , temp_cast_31 , _LightDebug);
				float4 lerpResult1405 = lerp( lerpResult1403 , NormalMixedUV22091 , _NormalDebug);
				
				float TerrainBlendingMask1761 = clampResult1356.r;
				float clampResult1771 = clamp( ( TerrainBlendingMask1761 + _TerrainBlending_Opacity ) , 0.0 , 1.0 );
				float Object_Opacity_Texture1457 = tex2DArrayNode1711.a;
				float lerpResult1472 = lerp( Object_Opacity_Texture1457 , 0.0 , _CustomOpacityMask);
				float lerpResult1416 = lerp( 1.0 , ( clampResult1771 * lerpResult1472 ) , _Opacity);
				float Opacity1375 = lerpResult1416;
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = lerpResult1405.rgb;
				float Alpha = Opacity1375;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _UV2_OutBrume_ColorCorrection;
			float4 _TerrainBlending_Color;
			float4 _OutBrumeColorCorrection;
			float4 _IB_TerrainBlending_Color;
			float4 _IB_BackColor;
			float4 _IB_ColorCorrection;
			float4 _ShadowColor;
			float4 _FakeLight_Color;
			float4 _IB_ColorShadow;
			float4 _OutBrumeColorCorrection_Additionnal;
			float2 _Noise_Panner;
			float2 _IB_ShadowNoise_Panner_AddSpeed;
			float2 _WindWave_Min_Speed;
			float2 _WindWave_Speed;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _IB_ShadowNoise_Panner;
			float _IB_ShadowDrippingNoise_SmoothstepAnimated;
			float _IB_ShadowNoise_Tiling;
			float _IB_ShadowDrippingNoise_Step;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _IB_ShadowDrippingNoise_Smoothstep;
			float _Wind_Texture_Contrast;
			float _IB_ShadowInBrumeGrunge_Contrast;
			float _IB_ShadowInBrumeGrunge_Tiling;
			float _TerrainBlending_Opacity;
			float _NormalDebug;
			float _LightDebug;
			float _IB_TerrainBlending;
			float _IB_TerrainBlending_Falloff;
			float _IB_TerrainBlendingNoise_Tiling;
			float _IB_TerrainBlending_BlendThickness;
			float _IB_RGB_Grayscale;
			float _IB_RGB_Contrast;
			float _IB_Edges_Modif2;
			float _IB_Edges_Modif1;
			float _IB_NormalDrippingNoise_Smoothstep;
			float _IB_NormalDrippingNoise_Step;
			float _IB_NormalInBrumeGrunge_Tiling;
			float _IB_NormalInBrumeGrunge_Contrast;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _ScreenBasedNoise;
			float _FakeLightArrayLength;
			float _Wind_Texture_Tiling;
			float _WindWave_Frequency;
			float _Wind_Density;
			float _Wind_Strength;
			float _Wind_Direction;
			float _WindVertexDisplacement;
			float _Out_or_InBrume;
			float _AnimatedGrunge_Tiling;
			float _AnimatedGrunge_Flipbook_Columns;
			float _AnimatedGrunge_Flipbook_Rows;
			float _AnimatedGrunge_Flipbook_Speed;
			float _IsGrungeAnimated;
			float _AnimatedGrungeMultiply;
			float _AnimatedGrunge;
			float _PaintGrunge_Contrast;
			float _PaintGrunge_Tiling;
			float _PaintGrunge_Multiply;
			float _PaintGrunge;
			float _UV_2_;
			float _DebugGrayscale;
			float _OutBrume_Edges_Textures;
			float _TerrainBlending_TextureTiling;
			float _TerrainBlending_BlendThickness;
			float _TerrainBlending_Falloff;
			float _TerrainBlending;
			float _StepShadow;
			float _StepAttenuation;
			float _Noise_Tiling;
			float _CustomOpacityMask;
			float _WaveFakeLight_Max;
			float _Opacity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D_ARRAY(_TextureArray_Noises);
			SAMPLER(sampler_TextureArray_Noises);
			sampler2D TB_DEPTH;
			float TB_OFFSET_X;
			float TB_OFFSET_Z;
			float TB_SCALE;
			float TB_FARCLIP;
			float TB_OFFSET_Y;
			TEXTURE2D_ARRAY(_TextureArray_Textures);
			SAMPLER(sampler_TextureArray_Textures);
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
			UNITY_INSTANCING_BUFFER_END(EnvironmentObjectsShader)


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
			
			void TriplanarWeights229_g27( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			

			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float2 temp_cast_0 = (0.0).xx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _WindWave_Frequency ) * _WindWave_Speed + ase_worldPos.xy);
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + ase_worldPos.xy);
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( panner1312 + panner1313 );
				float4 temp_cast_4 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_5 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( CalculateContrast(_Wind_Texture_Contrast,SAMPLE_TEXTURE2D_ARRAY_LOD( _TextureArray_Noises, sampler_TextureArray_Noises, texCoord1319,1.0, 0.0 )) - temp_cast_4 ) * _Wind_Strength ) , temp_cast_5 , v.ase_color.r);
				float3 worldToObjDir2095 = mul( GetWorldToObjectMatrix(), float4( lerpResult1328.rgb, 0 ) ).xyz;
				float cos2096 = cos( _Wind_Direction );
				float sin2096 = sin( _Wind_Direction );
				float2 rotator2096 = mul( worldToObjDir2095.xy - float2( 0,0 ) , float2x2( cos2096 , -sin2096 , sin2096 , cos2096 )) + float2( 0,0 );
				float2 WindVertexDisplacement1330 = rotator2096;
				float2 lerpResult1407 = lerp( temp_cast_0 , WindVertexDisplacement1330 , _WindVertexDisplacement);
				float2 temp_cast_8 = (0.0).xx;
				float2 lerpResult1609 = lerp( lerpResult1407 , temp_cast_8 , _Out_or_InBrume);
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = float3( lerpResult1609 ,  0.0 );
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
				float4 temp_output_1352_0 = ( ( temp_cast_0 - ( tex2D( TB_DEPTH, ( ( appendResult1340 - appendResult1339 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_1 );
				float localStochasticTiling216_g27 = ( 0.0 );
				float2 temp_output_104_0_g27 = _TerrainBlendingNoise_Tiling;
				float3 temp_output_80_0_g27 = WorldPosition;
				float2 Triplanar_UV050_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).zy );
				float2 UV216_g27 = Triplanar_UV050_g27;
				float2 UV1216_g27 = float2( 0,0 );
				float2 UV2216_g27 = float2( 0,0 );
				float2 UV3216_g27 = float2( 0,0 );
				float W1216_g27 = 0.0;
				float W2216_g27 = 0.0;
				float W3216_g27 = 0.0;
				StochasticTiling( UV216_g27 , UV1216_g27 , UV2216_g27 , UV3216_g27 , W1216_g27 , W2216_g27 , W3216_g27 );
				float Input_Index184_g27 = 3.0;
				float2 temp_output_280_0_g27 = ddx( Triplanar_UV050_g27 );
				float2 temp_output_275_0_g27 = ddy( Triplanar_UV050_g27 );
				float localTriplanarWeights229_g27 = ( 0.0 );
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float3 WorldNormal229_g27 = ase_worldNormal;
				float W0229_g27 = 0.0;
				float W1229_g27 = 0.0;
				float W2229_g27 = 0.0;
				TriplanarWeights229_g27( WorldNormal229_g27 , W0229_g27 , W1229_g27 , W2229_g27 );
				float localStochasticTiling215_g27 = ( 0.0 );
				float2 Triplanar_UV164_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).zx );
				float2 UV215_g27 = Triplanar_UV164_g27;
				float2 UV1215_g27 = float2( 0,0 );
				float2 UV2215_g27 = float2( 0,0 );
				float2 UV3215_g27 = float2( 0,0 );
				float W1215_g27 = 0.0;
				float W2215_g27 = 0.0;
				float W3215_g27 = 0.0;
				StochasticTiling( UV215_g27 , UV1215_g27 , UV2215_g27 , UV3215_g27 , W1215_g27 , W2215_g27 , W3215_g27 );
				float2 temp_output_242_0_g27 = ddx( Triplanar_UV164_g27 );
				float2 temp_output_247_0_g27 = ddy( Triplanar_UV164_g27 );
				float localStochasticTiling201_g27 = ( 0.0 );
				float2 Triplanar_UV271_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).xy );
				float2 UV201_g27 = Triplanar_UV271_g27;
				float2 UV1201_g27 = float2( 0,0 );
				float2 UV2201_g27 = float2( 0,0 );
				float2 UV3201_g27 = float2( 0,0 );
				float W1201_g27 = 0.0;
				float W2201_g27 = 0.0;
				float W3201_g27 = 0.0;
				StochasticTiling( UV201_g27 , UV1201_g27 , UV2201_g27 , UV3201_g27 , W1201_g27 , W2201_g27 , W3201_g27 );
				float2 temp_output_214_0_g27 = ddx( Triplanar_UV271_g27 );
				float2 temp_output_258_0_g27 = ddy( Triplanar_UV271_g27 );
				float4 Output_TriplanarArray296_g27 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W1216_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W2216_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W3216_g27 ) ) * W0229_g27 ) + ( W1229_g27 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W1215_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W2215_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W3215_g27 ) ) ) + ( W2229_g27 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W1201_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W2201_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W3201_g27 ) ) ) );
				float4 clampResult1354 = clamp( ( temp_output_1352_0 / ( _TerrainBlending_BlendThickness * Output_TriplanarArray296_g27 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_2 = (_TerrainBlending_Falloff).xxxx;
				float4 clampResult1356 = clamp( pow( clampResult1354 , temp_cast_2 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float TerrainBlendingMask1761 = clampResult1356.r;
				float clampResult1771 = clamp( ( TerrainBlendingMask1761 + _TerrainBlending_Opacity ) , 0.0 , 1.0 );
				float2 texCoord1622 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode1711 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures, sampler_TextureArray_Textures, texCoord1622,0.0 );
				float Object_Opacity_Texture1457 = tex2DArrayNode1711.a;
				float lerpResult1472 = lerp( Object_Opacity_Texture1457 , 0.0 , _CustomOpacityMask);
				float lerpResult1416 = lerp( 1.0 , ( clampResult1771 * lerpResult1472 ) , _Opacity);
				float Opacity1375 = lerpResult1416;
				
				float Alpha = Opacity1375;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _UV2_OutBrume_ColorCorrection;
			float4 _TerrainBlending_Color;
			float4 _OutBrumeColorCorrection;
			float4 _IB_TerrainBlending_Color;
			float4 _IB_BackColor;
			float4 _IB_ColorCorrection;
			float4 _ShadowColor;
			float4 _FakeLight_Color;
			float4 _IB_ColorShadow;
			float4 _OutBrumeColorCorrection_Additionnal;
			float2 _Noise_Panner;
			float2 _IB_ShadowNoise_Panner_AddSpeed;
			float2 _WindWave_Min_Speed;
			float2 _WindWave_Speed;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _IB_ShadowNoise_Panner;
			float _IB_ShadowDrippingNoise_SmoothstepAnimated;
			float _IB_ShadowNoise_Tiling;
			float _IB_ShadowDrippingNoise_Step;
			float _FakeLightStepAttenuation;
			float _FakeLightStep;
			float _IB_ShadowDrippingNoise_Smoothstep;
			float _Wind_Texture_Contrast;
			float _IB_ShadowInBrumeGrunge_Contrast;
			float _IB_ShadowInBrumeGrunge_Tiling;
			float _TerrainBlending_Opacity;
			float _NormalDebug;
			float _LightDebug;
			float _IB_TerrainBlending;
			float _IB_TerrainBlending_Falloff;
			float _IB_TerrainBlendingNoise_Tiling;
			float _IB_TerrainBlending_BlendThickness;
			float _IB_RGB_Grayscale;
			float _IB_RGB_Contrast;
			float _IB_Edges_Modif2;
			float _IB_Edges_Modif1;
			float _IB_NormalDrippingNoise_Smoothstep;
			float _IB_NormalDrippingNoise_Step;
			float _IB_NormalInBrumeGrunge_Tiling;
			float _IB_NormalInBrumeGrunge_Contrast;
			float _WaveFakeLight_Time;
			float _WaveFakeLight_Min;
			float _ScreenBasedNoise;
			float _FakeLightArrayLength;
			float _Wind_Texture_Tiling;
			float _WindWave_Frequency;
			float _Wind_Density;
			float _Wind_Strength;
			float _Wind_Direction;
			float _WindVertexDisplacement;
			float _Out_or_InBrume;
			float _AnimatedGrunge_Tiling;
			float _AnimatedGrunge_Flipbook_Columns;
			float _AnimatedGrunge_Flipbook_Rows;
			float _AnimatedGrunge_Flipbook_Speed;
			float _IsGrungeAnimated;
			float _AnimatedGrungeMultiply;
			float _AnimatedGrunge;
			float _PaintGrunge_Contrast;
			float _PaintGrunge_Tiling;
			float _PaintGrunge_Multiply;
			float _PaintGrunge;
			float _UV_2_;
			float _DebugGrayscale;
			float _OutBrume_Edges_Textures;
			float _TerrainBlending_TextureTiling;
			float _TerrainBlending_BlendThickness;
			float _TerrainBlending_Falloff;
			float _TerrainBlending;
			float _StepShadow;
			float _StepAttenuation;
			float _Noise_Tiling;
			float _CustomOpacityMask;
			float _WaveFakeLight_Max;
			float _Opacity;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D_ARRAY(_TextureArray_Noises);
			SAMPLER(sampler_TextureArray_Noises);
			sampler2D TB_DEPTH;
			float TB_OFFSET_X;
			float TB_OFFSET_Z;
			float TB_SCALE;
			float TB_FARCLIP;
			float TB_OFFSET_Y;
			TEXTURE2D_ARRAY(_TextureArray_Textures);
			SAMPLER(sampler_TextureArray_Textures);
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
			UNITY_INSTANCING_BUFFER_END(EnvironmentObjectsShader)


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
			
			void TriplanarWeights229_g27( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 temp_cast_0 = (0.0).xx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float3 ase_worldPos = mul(GetObjectToWorldMatrix(), v.vertex).xyz;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _WindWave_Frequency ) * _WindWave_Speed + ase_worldPos.xy);
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + ase_worldPos.xy);
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( panner1312 + panner1313 );
				float4 temp_cast_4 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_5 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( CalculateContrast(_Wind_Texture_Contrast,SAMPLE_TEXTURE2D_ARRAY_LOD( _TextureArray_Noises, sampler_TextureArray_Noises, texCoord1319,1.0, 0.0 )) - temp_cast_4 ) * _Wind_Strength ) , temp_cast_5 , v.ase_color.r);
				float3 worldToObjDir2095 = mul( GetWorldToObjectMatrix(), float4( lerpResult1328.rgb, 0 ) ).xyz;
				float cos2096 = cos( _Wind_Direction );
				float sin2096 = sin( _Wind_Direction );
				float2 rotator2096 = mul( worldToObjDir2095.xy - float2( 0,0 ) , float2x2( cos2096 , -sin2096 , sin2096 , cos2096 )) + float2( 0,0 );
				float2 WindVertexDisplacement1330 = rotator2096;
				float2 lerpResult1407 = lerp( temp_cast_0 , WindVertexDisplacement1330 , _WindVertexDisplacement);
				float2 temp_cast_8 = (0.0).xx;
				float2 lerpResult1609 = lerp( lerpResult1407 , temp_cast_8 , _Out_or_InBrume);
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = float3( lerpResult1609 ,  0.0 );
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
				float4 temp_output_1352_0 = ( ( temp_cast_0 - ( tex2D( TB_DEPTH, ( ( appendResult1340 - appendResult1339 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_1 );
				float localStochasticTiling216_g27 = ( 0.0 );
				float2 temp_output_104_0_g27 = _TerrainBlendingNoise_Tiling;
				float3 temp_output_80_0_g27 = WorldPosition;
				float2 Triplanar_UV050_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).zy );
				float2 UV216_g27 = Triplanar_UV050_g27;
				float2 UV1216_g27 = float2( 0,0 );
				float2 UV2216_g27 = float2( 0,0 );
				float2 UV3216_g27 = float2( 0,0 );
				float W1216_g27 = 0.0;
				float W2216_g27 = 0.0;
				float W3216_g27 = 0.0;
				StochasticTiling( UV216_g27 , UV1216_g27 , UV2216_g27 , UV3216_g27 , W1216_g27 , W2216_g27 , W3216_g27 );
				float Input_Index184_g27 = 3.0;
				float2 temp_output_280_0_g27 = ddx( Triplanar_UV050_g27 );
				float2 temp_output_275_0_g27 = ddy( Triplanar_UV050_g27 );
				float localTriplanarWeights229_g27 = ( 0.0 );
				float3 ase_worldNormal = IN.ase_texcoord2.xyz;
				float3 WorldNormal229_g27 = ase_worldNormal;
				float W0229_g27 = 0.0;
				float W1229_g27 = 0.0;
				float W2229_g27 = 0.0;
				TriplanarWeights229_g27( WorldNormal229_g27 , W0229_g27 , W1229_g27 , W2229_g27 );
				float localStochasticTiling215_g27 = ( 0.0 );
				float2 Triplanar_UV164_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).zx );
				float2 UV215_g27 = Triplanar_UV164_g27;
				float2 UV1215_g27 = float2( 0,0 );
				float2 UV2215_g27 = float2( 0,0 );
				float2 UV3215_g27 = float2( 0,0 );
				float W1215_g27 = 0.0;
				float W2215_g27 = 0.0;
				float W3215_g27 = 0.0;
				StochasticTiling( UV215_g27 , UV1215_g27 , UV2215_g27 , UV3215_g27 , W1215_g27 , W2215_g27 , W3215_g27 );
				float2 temp_output_242_0_g27 = ddx( Triplanar_UV164_g27 );
				float2 temp_output_247_0_g27 = ddy( Triplanar_UV164_g27 );
				float localStochasticTiling201_g27 = ( 0.0 );
				float2 Triplanar_UV271_g27 = ( temp_output_104_0_g27 * (temp_output_80_0_g27).xy );
				float2 UV201_g27 = Triplanar_UV271_g27;
				float2 UV1201_g27 = float2( 0,0 );
				float2 UV2201_g27 = float2( 0,0 );
				float2 UV3201_g27 = float2( 0,0 );
				float W1201_g27 = 0.0;
				float W2201_g27 = 0.0;
				float W3201_g27 = 0.0;
				StochasticTiling( UV201_g27 , UV1201_g27 , UV2201_g27 , UV3201_g27 , W1201_g27 , W2201_g27 , W3201_g27 );
				float2 temp_output_214_0_g27 = ddx( Triplanar_UV271_g27 );
				float2 temp_output_258_0_g27 = ddy( Triplanar_UV271_g27 );
				float4 Output_TriplanarArray296_g27 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W1216_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W2216_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3216_g27,Input_Index184_g27, temp_output_280_0_g27, temp_output_275_0_g27 ) * W3216_g27 ) ) * W0229_g27 ) + ( W1229_g27 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W1215_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W2215_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3215_g27,Input_Index184_g27, temp_output_242_0_g27, temp_output_247_0_g27 ) * W3215_g27 ) ) ) + ( W2229_g27 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W1201_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W2201_g27 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3201_g27,Input_Index184_g27, temp_output_214_0_g27, temp_output_258_0_g27 ) * W3201_g27 ) ) ) );
				float4 clampResult1354 = clamp( ( temp_output_1352_0 / ( _TerrainBlending_BlendThickness * Output_TriplanarArray296_g27 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_2 = (_TerrainBlending_Falloff).xxxx;
				float4 clampResult1356 = clamp( pow( clampResult1354 , temp_cast_2 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float TerrainBlendingMask1761 = clampResult1356.r;
				float clampResult1771 = clamp( ( TerrainBlendingMask1761 + _TerrainBlending_Opacity ) , 0.0 , 1.0 );
				float2 texCoord1622 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode1711 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures, sampler_TextureArray_Textures, texCoord1622,0.0 );
				float Object_Opacity_Texture1457 = tex2DArrayNode1711.a;
				float lerpResult1472 = lerp( Object_Opacity_Texture1457 , 0.0 , _CustomOpacityMask);
				float lerpResult1416 = lerp( 1.0 , ( clampResult1771 * lerpResult1472 ) , _Opacity);
				float Opacity1375 = lerpResult1416;
				
				float Alpha = Opacity1375;
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
1920;0;1920;1019;11105.68;5326.993;3.997097;True;False
Node;AmplifyShaderEditor.CommentaryNode;824;-6976.179,-4815.77;Inherit;False;8677.277;5620.472;OUT BRUME;3;1847;1842;1841;;1,0.7827643,0.5518868,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1841;-3082.261,-4738.333;Inherit;False;4647.981;4294.936;Additional;4;520;1396;1587;1371;;0.3679245,0.3679245,0.3679245,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1371;-3030.162,-3648.377;Inherit;False;3849.702;1403.809;TerrainBlending;39;1368;1367;1365;1364;1363;1361;1359;1358;1357;1356;1355;1354;1353;1352;1351;1350;1349;1348;1347;1346;1345;1344;1343;1342;1341;1340;1339;1338;1337;1336;1373;1374;1759;1760;1761;1897;1898;1899;2034;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1338;-2988.035,-3204.155;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1336;-2986.384,-3049.415;Inherit;False;Global;TB_OFFSET_X;TB_OFFSET_X;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1337;-2983.818,-2971.139;Inherit;False;Global;TB_OFFSET_Z;TB_OFFSET_Z;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1893;-8906.5,-4820.025;Inherit;False;1860.31;3803.75;TEXTURE ARRAYS;4;1819;2064;1807;1883;;0,0,0,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;1340;-2643.766,-3107.159;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1339;-2643.766,-2976.272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1883;-8861.957,-2127.826;Inherit;False;1270.378;1049.881;Noises;21;1878;1877;1872;1894;1873;1895;1896;1871;1876;1874;1882;1880;1875;1879;1881;1908;1909;1910;2063;2062;2061;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1892;-6995.821,883.652;Inherit;False;4345.192;3581.647;OTHER VARIABLES;6;521;31;2089;1536;1381;1335;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1341;-2390.973,-2958.307;Inherit;False;Global;TB_SCALE;TB_SCALE;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1342;-2406.372,-3069.946;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1335;-6943.921,2124.667;Inherit;False;4203.367;812.4094;VertexColor WindDisplacement;32;1886;1330;2096;1314;2095;1328;1304;1326;1329;1324;1325;1323;1322;1319;1321;1887;1318;1316;1315;1312;1313;2093;1311;2092;1310;1309;1307;1308;1305;1306;2098;2099;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1881;-8811.957,-2077.658;Inherit;True;Property;_TextureArray_Noises;TextureArray_Noises;15;0;Create;True;0;0;False;0;False;668ed38e9d9e517458c599bfa078a81c;829b1744df5e7e1438fda8b5bb926ccc;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;1343;-2152.296,-3069.946;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1879;-8523.97,-2077.658;Inherit;False;Noise;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;1346;-1940.28,-3136.072;Inherit;True;Global;TB_DEPTH;TB_DEPTH;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1345;-1835.833,-2934.506;Inherit;False;Global;TB_FARCLIP;TB_FARCLIP;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;1306;-6893.921,2480.947;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;1305;-6876.273,2279.077;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1344;-2666.865,-3208.533;Inherit;False;worldY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1361;-1743.644,-2394.001;Inherit;False;Property;_TerrainBlendingNoise_Tiling;TerrainBlendingNoise_Tiling;46;0;Create;True;0;0;False;0;False;1,1;0.3,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldPosInputsNode;1359;-1870.742,-2553.291;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1347;-1581.189,-3003.817;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1899;-1834.37,-2636.724;Inherit;False;Constant;_Float32;Float 32;95;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1348;-1561.601,-3125.864;Inherit;False;1344;worldY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1307;-6713.921,2429.947;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1898;-1863.74,-2723.639;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1308;-6507.981,2520.376;Inherit;False;Property;_WindWave_Frequency;WindWave_Frequency;98;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2092;-6440.658,2620.031;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1349;-1317.506,-2932.999;Inherit;False;Global;TB_OFFSET_Y;TB_OFFSET_Y;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1309;-6276.935,2443.851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1310;-6486.591,2776.607;Inherit;False;Property;_WindWave_Min_Speed;WindWave_Min_Speed;97;0;Create;True;0;0;False;0;False;0.05,0;0.05,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1363;-1346.667,-2804.818;Inherit;False;Property;_TerrainBlending_BlendThickness;TerrainBlending_BlendThickness;50;0;Create;True;0;0;False;0;False;0;1.1;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1897;-1346.706,-2609.446;Inherit;False;Procedural Sample;-1;;27;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.Vector2Node;1311;-6340.116,2318.793;Inherit;False;Property;_WindWave_Speed;WindWave_Speed;96;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1350;-1332.574,-3050.526;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2093;-6319.355,2173.626;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1351;-996.277,-2759.795;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;1313;-6229.977,2758.49;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;1312;-6082.321,2299.666;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1352;-1163.817,-3053.539;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1316;-5787.071,2383.679;Inherit;False;Property;_Wind_Texture_Tiling;Wind_Texture_Tiling;91;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1353;-763.1694,-3054.998;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1315;-5884.582,2542.708;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1886;-5750.464,2191.329;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1887;-5448.445,2533.095;Inherit;False;Constant;_Float2;Float 2;98;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1364;-658.3721,-3226.122;Inherit;False;Property;_TerrainBlending_Falloff;TerrainBlending_Falloff;51;0;Create;True;0;0;False;0;False;0;3.2;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1319;-5549.374,2396.889;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;1354;-565.5151,-3052.345;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1321;-4891.277,2635.819;Inherit;False;Property;_Wind_Density;Wind_Density;94;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1355;-333.371,-3054.998;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1323;-5261.626,2364.668;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1807;-8870.481,-4754.129;Inherit;False;1701.802;852.4719;Textures;20;1712;1716;1475;1721;1456;1715;1455;1719;1454;1453;1904;1720;1457;1711;1622;1806;1718;1804;2126;2127;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SinTimeNode;1318;-4860.103,2728.177;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2099;-4932.288,2454.764;Inherit;False;Property;_Wind_Texture_Contrast;Wind_Texture_Contrast;92;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;2098;-4694.288,2371.764;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1804;-8820.481,-4703.961;Inherit;True;Property;_TextureArray_Textures;TextureArray_Textures;12;0;Create;True;0;0;False;1;Header(Textures Arrays);False;668ed38e9d9e517458c599bfa078a81c;None;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ClampOpNode;1356;-141.9435,-3056.455;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1322;-4687.113,2640.735;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1622;-8767.261,-4496.089;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;1357;52.6738,-3055.65;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1718;-8718.121,-4358.249;Inherit;False;Constant;_Float7;Float 7;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1325;-4478.555,2372.537;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1806;-8532.495,-4703.961;Inherit;False;Texture;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1324;-4275.463,2441.055;Inherit;False;Property;_Wind_Strength;Wind_Strength;95;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1711;-8307.557,-4704.129;Inherit;True;Property;_TA_Textures;TA_Textures;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1761;357.6356,-2915.843;Inherit;False;TerrainBlendingMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1326;-4100.466,2373.055;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1381;-6937.666,2963.402;Inherit;False;2464.586;725.3411;Opacity;18;1900;1375;1548;1416;1540;1838;1428;1539;1772;1417;1538;1472;1771;1467;1770;1477;1767;1765;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1329;-3866.8,2451.038;Inherit;False;Constant;_Float1;Float 1;67;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;1304;-3883.327,2539.036;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1767;-6508.511,3102.841;Inherit;False;Property;_TerrainBlending_Opacity;TerrainBlending_Opacity;48;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1457;-7911.583,-4607.542;Inherit;False;Object_Opacity_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1328;-3704.625,2375.64;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1765;-6503.642,3021.624;Inherit;False;1761;TerrainBlendingMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1770;-6187.645,3071.99;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;2095;-3507.271,2369.972;Inherit;False;World;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1477;-6888.397,3394.061;Inherit;False;Property;_CustomOpacityMask;CustomOpacityMask?;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1314;-3617.03,2726.478;Inherit;False;Property;_Wind_Direction;Wind_Direction;93;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1467;-6792.171,3086.96;Inherit;True;1457;Object_Opacity_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1900;-6755.625,3283.031;Inherit;False;Constant;_Float33;Float 33;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1472;-6522.111,3216.367;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;2096;-3258.92,2375.401;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;1771;-6060.135,3072.387;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1842;-6899.22,-4739.434;Inherit;False;3767.544;3684.208;Essential;2;471;1840;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1772;-5836.071,3184.245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1330;-3055.055,2371.067;Inherit;False;WindVertexDisplacement;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1428;-5612.094,3076.471;Inherit;False;Constant;_Float6;Float 6;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1840;-6861.474,-4689.434;Inherit;False;3675.997;2452.021;RGB;13;461;530;1366;1826;1830;1827;2180;2181;2182;2183;2184;2193;2191;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1417;-5700.676,3311.378;Inherit;False;Property;_Opacity;Opacity?;7;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;845;-8626.889,-961.1481;Inherit;False;1548.594;1019.987;FinalPass;19;1405;582;955;1464;1406;1376;1404;1403;844;474;1609;954;1611;1407;1408;1331;1334;2059;2060;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1254;1860.96,-4784.294;Inherit;False;6772.289;4431.814;IN BRUME;53;1252;1989;1241;1242;1050;1161;1049;988;1158;1162;1118;989;1248;1223;1256;901;1255;1253;1243;1250;1993;1995;2035;2041;2036;2037;2038;2040;2042;2043;2044;2045;2046;2047;2048;2049;2050;2051;2052;2139;2140;2146;2147;2148;2149;2150;2151;2185;2186;2187;2188;2189;2190;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1334;-8377.363,-229.6654;Inherit;False;Constant;_Float4;Float 4;68;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1416;-5359.209,3173.846;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1408;-8491.318,-49.34719;Inherit;False;Property;_WindVertexDisplacement;WindVertexDisplacement?;90;0;Create;True;0;0;False;1;Header(Wind);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1827;-6800.289,-3281.761;Inherit;False;1873.002;947.4066;Albedo;8;2107;1612;1614;1613;1697;841;842;2087;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1331;-8492.977,-137.8472;Inherit;False;1330;WindVertexDisplacement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1536;-6928.761,3720.215;Inherit;False;2198.199;655.8777;DepthFade;19;1837;1523;1534;1535;1545;1530;1533;1532;1546;1542;1528;1544;1543;1529;1527;1531;1526;1525;1524;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2089;-6939.277,946.5102;Inherit;False;585.5757;438.8629;UV2 Normal;2;2076;1458;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;520;-3028.572,-4688.333;Inherit;False;3545.176;1011.814;Specular;30;1585;623;498;506;639;1500;619;500;522;1615;1462;1459;627;636;634;640;523;630;1501;508;499;509;632;633;512;504;626;1905;1906;1907;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1243;1902.872,-4729.279;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;15;1240;1231;1233;1232;1228;1227;1225;1235;1230;1165;1949;1950;1951;1953;1954;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1250;1898.415,-3133.868;Inherit;False;2793.385;1304.568;NormalDrippingGrunge;21;1108;1251;1105;2152;1465;1182;1249;2158;2160;2161;2162;2163;2164;2165;2166;2167;2168;2170;2177;2178;2179;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1611;-8111.377,-295.5445;Inherit;False;Constant;_Float10;Float 10;98;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2194;-2600.789,886.2454;Inherit;False;2835.362;2534.708;FAKE LIGHTS;16;2200;2201;2204;2195;2196;2197;2198;2199;2202;2203;2205;2206;2207;2208;2209;2210;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1587;-3032.261,-2205.532;Inherit;False;3162.162;1702.81;TopTex;30;1565;1581;1599;1600;1604;1555;1557;1598;1554;1566;1567;1556;1560;1553;1606;1584;1561;1569;1595;1558;1562;1552;1594;1559;1596;1568;1582;1564;1563;1911;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1925;2548.288,-120.4256;Inherit;False;2161.485;604.1234;IB_ShadowNoise;16;1936;1935;2141;1934;1932;1927;1931;1937;1928;1943;1940;1930;1933;1939;1929;1941;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;1407;-8168.56,-157.8638;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1375;-4681.149,3170.237;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;2064;-8869.534,-3875.48;Inherit;False;1701.708;853.737;Textures UV2;14;2067;2071;2102;2065;2073;2072;2069;2068;2100;2101;2066;2070;2128;2129;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;471;-6862.793,-2195.719;Inherit;False;3565.746;1090.681;Shadow Smooth Edge + Int Shadow;19;877;563;562;449;444;450;401;445;447;397;470;446;448;482;385;387;469;386;388;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1819;-8861.877,-3001.784;Inherit;False;1241.837;843.8696;Grunges;15;1823;1815;1808;1818;1811;1810;1814;1813;1812;1820;1821;1822;1816;1809;1817;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1993;4719.399,-3134.31;Inherit;False;2869.074;968.4207;Edges;17;2130;1977;1992;1994;1990;1985;1966;1983;2131;1980;1979;1991;1976;1981;2134;2135;2136;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1253;1903.725,-3774.783;Inherit;False;2694.904;611.5192;InBrumeGrunge;18;1247;1246;1889;1891;1752;1113;1116;1114;1754;1755;1117;1750;1119;1749;1888;1890;1115;1751;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2087;-6748.011,-2838.642;Inherit;False;981.3428;474.9114;UV2 Albedo;6;2085;2086;2106;2088;2081;2080;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1826;-6811.228,-3901.076;Inherit;False;2278.282;581.4458;PaintGrunge;13;1824;1497;1825;1382;1728;1727;1726;1725;1748;1385;1831;1833;1832;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1396;567.6714,-4685.668;Inherit;False;938.298;801.8033;CustomRimLight;9;1902;1903;1901;1393;1389;1392;1390;1391;1461;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1830;-6820.089,-4625.089;Inherit;False;2709.934;703.4277;AnimatedGrunge;21;525;526;1829;1828;455;1492;1491;1412;667;666;665;463;465;670;466;464;664;1411;1834;1835;1836;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;954;-8576.578,-717.9639;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;3;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1847;-6930.624,-348.9947;Inherit;False;5942.767;652.2931;FinalPass_OutBrume;25;1586;1468;1592;1590;1471;1588;1369;1469;1607;428;1395;1400;1370;1402;518;1394;1591;473;1843;1608;1397;2213;2212;2214;2215;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;521;-6938.73,1494.205;Inherit;False;2700.771;602.1591;Noise;20;481;570;1495;1493;1496;1494;573;484;571;572;1413;477;565;487;1414;480;479;478;1884;1885;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-6332.142,941.7288;Inherit;False;2013.652;530.9265;Normal Light Dir;10;710;12;23;711;10;11;2091;2111;2137;2138;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2131;5285.665,-3066.633;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;1246;4135.895,-3723.903;Inherit;False;ShadowInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2185;7601.216,-3322.552;Inherit;False;Property;_IB_RGB_Grayscale;IB_RGB_Grayscale?;65;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1559;-1941.166,-1343.081;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.33;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1928;3689.857,347.7089;Inherit;False;Constant;_Float14;Float 14;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2146;6500.731,-3787.782;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2170;2142.608,-2644.329;Inherit;False;Property;_IB_NormalDrippingNoise_SmoothstepAnimated;IB_NormalDrippingNoise_SmoothstepAnimated;81;0;Create;True;0;0;False;0;False;0.01;0.106;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1936;2594.293,173.9588;Inherit;False;Property;_IB_ShadowNoise_Tiling;IB_ShadowNoise_Tiling;72;0;Create;True;0;0;False;1;Header(IB_Shadow);False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2135;5097.283,-3031.854;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;482;-5790.792,-1955.719;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2158;4028.66,-3014.79;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1943;2836.943,154.4052;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;2166;2799.18,-2802.767;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2167;2642.608,-2777.329;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1116;3192.462,-3717.566;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;1979;5634.2,-2811.735;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1248;5191.878,-3794.804;Inherit;False;1246;ShadowInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2162;2812.93,-2542.066;Inherit;True;1934;MapNoise_IB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;2044;3346.934,-1182.386;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1890;1989.524,-3348.527;Inherit;False;Constant;_Float30;Float 30;102;0;Create;True;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1227;2650.625,-4144.165;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1119;3442.848,-3723.448;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2186;8149.852,-3808.681;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;2152;4014.565,-2901.193;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2130;4753.234,-3071.995;Inherit;False;2072;Object_Albedo_Texture_UV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1889;1974.524,-3645.527;Inherit;False;Constant;_Float29;Float 29;101;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2160;4263.461,-3029.238;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1813;-8706.518,-2527.905;Inherit;False;Constant;_Float13;Float 13;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;2045;3579.078,-1185.039;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2049;4500.051,-1449.906;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1255;7637.808,-3809.16;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;1232;3153.504,-4058.961;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1749;2565.554,-3721.71;Inherit;False;Procedural Sample;-1;;104;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;2041;2567.376,-1069.166;Inherit;False;Property;_IB_TerrainBlending_BlendThickness;IB_TerrainBlending_BlendThickness;87;0;Create;True;0;0;False;0;False;0;0.7;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1162;6152.931,-4090.465;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2163;3327.457,-2804.73;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1240;3922.371,-4562.674;Inherit;False;ShadowDrippingNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2102;-8679.742,-3265.004;Inherit;False;Constant;_Float46;Float 46;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1752;2563.58,-3435.858;Inherit;False;Procedural Sample;-1;;103;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1966;5451.814,-2961.592;Inherit;False;Property;_IB_Edges_Modif1;IB_Edges_Modif1;70;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1223;7211.742,-3785.788;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1873;-8299.036,-2077.826;Inherit;True;Property;_TA_Noises;TA_Noises;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1242;5227.15,-4346.759;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1251;4443.597,-3037.784;Inherit;False;NormalDrippingGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1929;3225.007,39.57451;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1981;6180.683,-2577.547;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1231;3636.969,-4562.671;Inherit;True;LinearDodge;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;2046;3770.506,-1186.496;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1977;6172.335,-2953.14;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2187;7172.128,-3548.107;Inherit;False;473;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;2164;3100.005,-2540.908;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1976;5389.236,-2816.56;Inherit;True;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1228;2927.852,-4061.731;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;2140;2325.797,-622.8301;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;2148;4224.11,-1349.818;Inherit;False;2147;IB_TerrainBlending;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1252;6190.737,-3768.644;Inherit;False;1251;NormalDrippingGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1817;-8298.793,-2563.577;Inherit;True;Property;_TextureSample27;Texture Sample 27;16;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1816;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1843;-5082.98,-196.2036;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;2189;7635.241,-3546.48;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1754;2313.729,-3634.848;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1935;3001.006,343.5738;Inherit;False;Property;_IB_ShadowNoise_Panner;IB_ShadowNoise_Panner;73;0;Create;True;0;0;False;0;False;0.2,-0.1;0.05,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;1256;7336.017,-4073.234;Inherit;False;Property;_IB_ColorCorrection;IB_ColorCorrection;64;0;Create;True;0;0;False;1;Header(IB_InBrume);False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-5854.792,-1491.72;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1989;6922.443,-3792.775;Inherit;False;Multiply;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;665;-6461.598,-4277.863;Inherit;False;Property;_AnimatedGrunge_Flipbook_Columns;AnimatedGrunge_Flipbook_Columns;23;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1613;-5421.513,-3133.603;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1614;-5450.412,-3029.718;Inherit;False;Property;_DebugGrayscale;DebugGrayscale?;6;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1105;2233.393,-3077.711;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1888;1944.928,-3723.621;Inherit;False;1810;Grunge;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1225;2137.23,-4657.279;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2036;2078.672,-901.0724;Inherit;False;Constant;_Float41;Float 41;95;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1165;1983.049,-4305.551;Inherit;False;Property;_IB_ShadowDrippingNoise_Step;IB_ShadowDrippingNoise_Step;75;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2139;2034.797,-615.8301;Inherit;False;Property;_IB_TerrainBlendingNoise_Tiling;IB_TerrainBlendingNoise_Tiling;86;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1954;1943.876,-4399.057;Inherit;False;Property;_IB_ShadowDrippingNoise_SmoothstepAnimated;IB_ShadowDrippingNoise_SmoothstepAnimated;77;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1230;1945.891,-4228.126;Inherit;False;Property;_IB_ShadowDrippingNoise_Smoothstep;IB_ShadowDrippingNoise_Smoothstep;76;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1182;2144.484,-2731.379;Inherit;False;Property;_IB_NormalDrippingNoise_Smoothstep;IB_NormalDrippingNoise_Smoothstep;82;0;Create;True;0;0;False;0;False;0.01;0.305;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1108;2145.98,-2813.252;Inherit;False;Property;_IB_NormalDrippingNoise_Step;IB_NormalDrippingNoise_Step;80;0;Create;True;0;0;False;1;Header(IB_Normal);False;0.45;0.597;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2038;2049.302,-987.9869;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2168;2643.608,-2682.329;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1953;2654.616,-4481.668;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1118;5451.322,-3867.731;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2047;3965.123,-1185.691;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1812;-8709.518,-2605.905;Inherit;False;Constant;_Float12;Float 12;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2052;5138.03,-1525.993;Inherit;False;FinalInBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1934;4483.002,218.5736;Inherit;False;MapNoise_IB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1161;5686.774,-4340.553;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1833;-5102.637,-3559.773;Inherit;False;Property;_PaintGrunge;PaintGrunge?;27;0;Create;True;0;0;False;1;Header(PaintGrunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2134;4748.283,-2965.854;Inherit;True;Property;_IB_Edges_Textures;IB_Edges_Textures;69;0;Create;True;0;0;False;1;Header(IB_Edges);False;-1;None;bfb6f68b70a03e74f8c8ffef151e6a56;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1910;-8707.936,-1404.27;Inherit;False;Constant;_Float34;Float 34;104;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1937;3657.003,7.575001;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1241;5193.066,-3872.661;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2051;4241.631,-1623.418;Inherit;False;Property;_IB_TerrainBlending_Color;IB_TerrainBlending_Color;89;0;Create;True;0;0;False;0;False;0.4245283,0.4245283,0.4245283,0;0.1320753,0.1320753,0.1320753,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;2040;2566.337,-873.7946;Inherit;False;Procedural Sample;-1;;102;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;1465;1950.529,-3077.695;Inherit;False;2091;NormalMixedUV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1891;1960.524,-3428.527;Inherit;False;1810;Grunge;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1751;2015.579,-3251.858;Inherit;False;Property;_IB_NormalInBrumeGrunge_Tiling;IB_NormalInBrumeGrunge_Tiling;83;0;Create;True;0;0;False;0;False;0.2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1592;-6138.203,-83.97057;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1235;2443.711,-4043.716;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1117;2890.238,-3620.328;Inherit;False;Property;_IB_ShadowInBrumeGrunge_Contrast;IB_ShadowInBrumeGrunge_Contrast;79;0;Create;True;0;0;False;0;False;-3.38;-3.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2147;4190.863,-1128.803;Inherit;False;IB_TerrainBlending;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1233;3359.506,-4058.961;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;450;-5177.79,-1335.72;Inherit;False;Property;_ShadowColor;ShadowColor;36;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.5,0.5,0.5,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1590;-6382.48,-46.0836;Inherit;False;1584;TopTex;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1598;-2881.858,-1582.888;Inherit;True;2091;NormalMixedUV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-5566.792,-2131.719;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2080;-6399.979,-2688.335;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-4919.349,-4330.476;Inherit;False;Property;_AnimatedGrungeMultiply;AnimatedGrungeMultiply;26;0;Create;True;0;0;False;0;False;1.58;1.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1113;3198.188,-3433.73;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1750;1990.753,-3524.01;Inherit;False;Property;_IB_ShadowInBrumeGrunge_Tiling;IB_ShadowInBrumeGrunge_Tiling;78;0;Create;True;0;0;False;0;False;0.2;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;2179;3678.042,-3002.851;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;498;-2733.152,-4214.391;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1995;6710.106,-3698.159;Inherit;False;1994;IB_Edges;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1994;6937.943,-2746.355;Inherit;False;IB_Edges;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1755;2306.729,-3359.848;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1940;3618.849,206.5502;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;1809;-8300.519,-2758.678;Inherit;True;Property;_TextureSample26;Texture Sample 26;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1816;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1050;5597.749,-4549.572;Inherit;False;Property;_IB_BackColor;IB_BackColor;67;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2208;-1902.57,1685.912;Inherit;False;Property;_FakeLightStepAttenuation;FakeLightStepAttenuation;112;0;Create;True;0;0;False;0;False;5;5;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1716;-8303.395,-4118.922;Inherit;True;Property;_TextureSample8;Texture Sample 8;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2100;-8299.713,-3353.935;Inherit;True;Property;_TextureSample35;Texture Sample 35;18;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2066;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1895;-7947.102,-1492.424;Inherit;False;Object_TerrainBlendingNoise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2067;-8760.732,-3548.18;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1808;-8294.793,-2366.577;Inherit;True;Property;_TextureSample24;Texture Sample 24;13;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1816;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1896;-8707.786,-1490.316;Inherit;False;Constant;_Float31;Float 31;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;2126;-7676.435,-4505.703;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;2072;-7899.655,-3789.354;Inherit;False;Object_Albedo_Texture_UV2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1908;-8296.953,-1298.64;Inherit;True;Property;_TextureSample31;Texture Sample 31;16;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;2065;-8803.613,-3790.832;Inherit;True;Property;_UV2_TextureArray_Textures;UV2_TextureArray_Textures;17;0;Create;True;0;0;False;0;False;668ed38e9d9e517458c599bfa078a81c;None;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-6781.551,-4539.616;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2042;2916.766,-1024.143;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1455;-7923.26,-4220.831;Inherit;False;Object_SpecularMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1874;-7923.478,-1689.528;Inherit;False;Object_IB_DrippingNoise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1882;-8706.597,-1574.946;Inherit;False;Constant;_Float28;Float 28;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1712;-8309.121,-4511.022;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1872;-8300.599,-1884.719;Inherit;True;Property;_TextureSample29;Texture Sample 29;12;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1823;-7922.396,-2365.487;Inherit;False;Object_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1909;-7940.953,-1298.64;Inherit;False;Object_TopTexNoise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1904;-7913.667,-4315.732;Inherit;False;Object_Specular_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1939;3859.769,-22.29744;Inherit;True;Property;_TextureSample33;Texture Sample 33;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;506;-2160.155,-4401.117;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1365;-1008.31,-3592.572;Inherit;True;Property;_TerrainBlending_TextureTerrain;TerrainBlending_TextureTerrain;45;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2201;-2556.688,1474.078;Inherit;False;Property;_WaveFakeLight_Time;WaveFakeLight_Time;113;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2076;-6910.076,1173.21;Inherit;True;2073;Object_Normal_Texture_UV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2213;-2999.788,-14.49622;Inherit;False;2210;FakeLights;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2190;7397.347,-3460.681;Inherit;False;Property;_IB_RGB_Contrast;IB_RGB_Contrast;66;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1880;-8758.737,-1869.785;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2207;-2331.916,1479.362;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2215;-3440.051,10.70691;Inherit;False;Property;_FakeLight_Color;FakeLight_Color;110;0;Create;False;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;465;-6557.551,-4539.616;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;2199;-1079.214,1119.839;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2198;-2000.688,1350.078;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2202;-1606.635,1636.367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;2128;-7743.482,-3568.93;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;2203;-1953.998,1056.324;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2205;-1799.688,1512.078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1815;-8707.518,-2366.905;Inherit;False;Constant;_Float5;Float 5;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;2206;-2165.983,1479.698;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2197;-1422.647,1119.379;Float;False;float result=0@$for(int i=0@ i<Length@i++)${$	float dist = distance(WorldPos,FakeLightsPositionsArray[i])@$	result += 1 - smoothstep( LightStep, LightStepAttenuation, dist)@$}$return result@;1;False;5;True;In0;FLOAT;0;In;;Inherit;False;True;WorldPos;FLOAT3;0,0,0;In;;Float;False;True;Length;FLOAT;0;In;;Inherit;False;True;LightStep;FLOAT;0;In;;Float;False;True;LightStepAttenuation;FLOAT;0;In;;Float;False;Cycle Through Array;True;False;0;5;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2196;-1964.256,1200.699;Inherit;False;Property;_FakeLightArrayLength;FakeLightArrayLength;109;0;Create;True;0;0;False;1;Header(Fake Lights);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1871;-8298.874,-1689.619;Inherit;True;Property;_TextureSample28;Texture Sample 28;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2068;-8518.7,-3790.604;Inherit;False;Texture_UV2;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1821;-7928.559,-2759.396;Inherit;False;Object_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2165;2899.005,-2320.908;Inherit;False;Property;_Float22;Float 22;108;0;Create;True;0;0;False;0;False;0;30.03;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-2513.804,-285.2582;Inherit;False;EndOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1818;-8811.877,-2951.616;Inherit;True;Property;_TextureArray_Grunges;TextureArray_Grunges;14;0;Create;True;0;0;False;0;False;668ed38e9d9e517458c599bfa078a81c;649e428ece482fe499fbfc248f5c6460;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1715;-8307.395,-4315.922;Inherit;True;Property;_TextureSample6;Texture Sample 6;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1949;2690.949,-3920.859;Inherit;False;1934;MapNoise_IB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1719;-8715.121,-4280.249;Inherit;False;Constant;_Float11;Float 11;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1720;-8715.121,-4201.25;Inherit;False;Constant;_Float35;Float 35;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1878;-8706.597,-1653.946;Inherit;False;Constant;_Float27;Float 27;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2138;-6126.479,1076.355;Inherit;False;2074;Switch_UV_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2071;-8679.823,-3350.113;Inherit;False;Constant;_Float43;Float 43;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2048;3254.077,-1356.163;Inherit;False;Property;_IB_TerrainBlending_Falloff;IB_TerrainBlending_Falloff;88;0;Create;True;0;0;False;0;False;0;3.1;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1454;-7469.909,-4509.518;Inherit;False;Object_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;2177;3492.201,-2833.027;Inherit;False;Difference;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2101;-7903.351,-3354.34;Inherit;False;Object_Highlights_Texture_UV2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;2043;3149.28,-1185.039;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1816;-8298.955,-2951.784;Inherit;True;Property;_TA_Grunges;TA_Grunges;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;2035;2622.465,-1246.746;Inherit;False;2034;TerrainBlending;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1374;-1518.985,-3544.558;Inherit;False;Property;_TerrainBlending_TextureTiling;TerrainBlending_TextureTiling;49;0;Create;True;0;0;False;0;False;1;5.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1468;-6541.638,-290.7897;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2073;-7505.328,-3574.378;Inherit;False;Object_Normal_Texture_UV2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1877;-8709.597,-1731.946;Inherit;False;Constant;_Float24;Float 24;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1811;-8758.656,-2743.744;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1990;5775.995,-3068.183;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1475;-7906.158,-4118.624;Inherit;False;Object_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2149;4939.069,-1521.598;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1247;4155.397,-3438.297;Inherit;False;NormalInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2050;4226.631,-1428.418;Inherit;False;901;EndInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2150;4732.069,-1554.598;Inherit;False;901;EndInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;988;5725.767,-4062.273;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.3;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1991;5825.976,-2444.124;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1985;6463.998,-2742.761;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1894;-8296.649,-1492.515;Inherit;True;Property;_TextureSample30;Texture Sample 30;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1456;-7918.861,-4022.649;Inherit;False;Object_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1933;3693.857,111.7096;Inherit;False;Constant;_Float40;Float 40;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1876;-7935.972,-2077.205;Inherit;False;Object_Noise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2037;2042.3,-817.6396;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;2081;-6718.242,-2561.547;Inherit;False;Property;_UV2_OutBrume_ColorCorrection;UV2_OutBrume_ColorCorrection;19;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1941;3608.435,-77.59648;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1951;2867.004,-4646.898;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;901;8350.671,-3814.176;Inherit;False;EndInBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1581;-999.7497,-1602.048;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;2070;-8682.823,-3428.113;Inherit;False;Constant;_Float42;Float 42;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2183;-4737.375,-3133.151;Inherit;False;Constant;_Float38;Float 38;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1822;-7923.396,-2563.487;Inherit;False;Object_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1875;-7928.64,-1885.438;Inherit;False;Object_WindNoise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2127;-7878.123,-4415.457;Inherit;False;Property;_Normal_Level;Normal_Level;13;0;Create;True;0;0;False;0;False;1;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2066;-8293.025,-3789.358;Inherit;True;Property;_TA_Textures_UV2;TA_Textures_UV2;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1810;-8523.89,-2951.616;Inherit;False;Grunge;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.OneMinusNode;1158;5495.784,-4340.747;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1453;-7912.909,-4702.518;Inherit;False;Object_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1983;5519.649,-2345.334;Inherit;False;Property;_IB_Edges_Modif2;IB_Edges_Modif2;71;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1249;3766.953,-3073.288;Inherit;False;1247;NormalInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1932;4195.002,219.5736;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2069;-8302.69,-3575.973;Inherit;True;Property;_TextureSample34;Texture Sample 34;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2066;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-4560.009,1033.833;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1586;-5610.506,-65.4536;Inherit;False;1585;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;444;-5294.791,-1619.72;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;2161;2796.88,-3048.27;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;2141;2914.6,2.013111;Inherit;False;Property;_IB_ShadowNoise_Panner_AddSpeed;IB_ShadowNoise_Panner_AddSpeed;74;0;Create;True;0;0;False;0;False;0.01,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.OneMinusNode;1980;5878.789,-2577.047;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1115;3440.615,-3439.029;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1721;-8716.121,-4119.249;Inherit;False;Constant;_Float36;Float 36;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2151;4637.069,-1281.598;Inherit;False;Property;_IB_TerrainBlending;IB_TerrainBlending?;85;0;Create;True;0;0;False;1;Header(IB_TerrainBlending);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2129;-7966.17,-3479.684;Inherit;False;Property;_UV2_Normal_Level;UV2_Normal_Level;18;0;Create;True;0;0;False;0;False;1;-1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2178;3728.252,-2852.084;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2136;4855.553,-2769.531;Inherit;False;2074;Switch_UV_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;989;5441.94,-4067.039;Inherit;False;Property;_IB_ColorShadow;IB_ColorShadow;68;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.2452828,0.2452828,0.2452828,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;1931;3225.007,263.5737;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;1552;-580.0522,-1321.851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GlobalArrayNode;2195;-1980.246,950.7346;Inherit;False;FakeLightsPositionsArray;0;10;2;False;False;0;1;False;Object;13;4;0;INT;0;False;2;INT;0;False;1;INT;0;False;3;INT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendOpsNode;2107;-5764.979,-3230.724;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TriplanarNode;1599;-1580.201,-2007.21;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;1992;6590.739,-2742.57;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;1554;-2534.505,-1357.311;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1461;616.4374,-4619.936;Inherit;True;1456;Object_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1391;666.8824,-4350.892;Inherit;False;Property;_CustomRimLight_Color;CustomRimLight_Color;62;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1902;635.6772,-3984.347;Inherit;False;Property;_CustomRimLight_Texture;CustomRimLight_Texture?;61;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1903;644.5051,-4182.536;Inherit;True;1475;Object_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1393;1117.88,-4469.892;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1392;654.8813,-4429.892;Inherit;False;Property;_CustomRimLight_Opacity;CustomRimLight_Opacity;63;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1389;1272.767,-4475.326;Inherit;False;CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1901;985.0667,-4288.11;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1608;-6343.238,52.96156;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;711;-4848.01,1049.833;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2137;-5893.431,990.1129;Inherit;False;3;0;COLOR;1,1,1,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2091;-5635.107,1348.965;Inherit;False;NormalMixedUV2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-5392.01,1049.833;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BlendNormalsNode;2111;-6282.41,1156.19;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-5408.01,1193.832;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightAttenuation;710;-5120.009,1321.832;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1609;-7928.075,-290.3471;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2074;-7695.92,296.1685;Inherit;False;Switch_UV_2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1404;-8166.312,-533.1212;Inherit;False;Property;_LightDebug;LightDebug;4;0;Create;True;0;0;False;1;Header(Debug);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;572;-5722.726,1654.205;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1526;-6685.713,4164.179;Inherit;False;Property;_DepthFade_Dither_Tiling;DepthFade_Dither_Tiling;102;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1540;-5085.958,3353.068;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1049;5850.993,-4517.639;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1543;-6229.962,4277.685;Inherit;False;Property;_DepthFade_Texture;DepthFade_Texture?;100;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2210;-905.3538,1114.789;Inherit;False;FakeLights;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1828;-5185.367,-4346.383;Inherit;False;Constant;_AnimatedGrungeContrast;AnimatedGrungeContrast;96;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2088;-6140.051,-2766.886;Inherit;False;Constant;_Float44;Float 44;100;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1492;-5613.432,-4402.198;Inherit;False;Constant;_Float16;Float 16;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1385;-6749.07,-3428.541;Inherit;False;Property;_PaintGrunge_Tiling;PaintGrunge_Tiling;28;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1459;-2987.218,-4219.704;Inherit;True;2091;NormalMixedUV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2034;-1000.347,-3115.117;Inherit;False;TerrainBlending;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-5342.791,-2131.719;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1604;-1779.929,-1864.877;Inherit;False;Property;_TopTex_Tiling;TopTex_Tiling;54;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;1564;-1974.512,-813.251;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1596;-1352.802,-852.836;Inherit;False;Constant;_Float15;Float 15;96;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-4001.485,-3747.466;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1411;-5750.28,-4539.062;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1612;-5136.602,-3226.29;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1582;-2466.584,-827.5928;Inherit;True;Property;_TopTex_Noise_Texture;TopTex_Noise_Texture;11;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;1563;-1260.253,-1184.767;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;504;-2365.152,-4310.391;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1527;-6445.71,4084.179;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;1555;-2603.955,-1578.344;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1907;-800.4421,-3786.267;Inherit;False;Property;_SpecularTexture;SpecularTexture?;38;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1569;-2965.847,-814.059;Inherit;False;Property;_TopTex_NoiseOffset;TopTex_NoiseOffset;57;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;388;-6398.792,-1875.719;Inherit;False;Property;_StepAttenuation;StepAttenuation;35;0;Create;True;0;0;False;0;False;0.3;-0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1373;-1229.985,-3563.558;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1535;-5538.687,4275.177;Inherit;False;Property;_DepthFade_ClampMax;DepthFade_ClampMax;107;0;Create;True;0;0;False;0;False;0.8;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1725;-5957.646,-3704.473;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;2188;7402.131,-3549.107;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;-8550.477,-885.827;Inherit;False;473;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1814;-8706.518,-2448.905;Inherit;False;Constant;_Float20;Float 20;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1825;-6724.848,-3652.442;Inherit;False;Constant;_Float3;Float 3;99;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1532;-5813.251,3866.659;Inherit;False;Property;_DepthFade_Falloff;DepthFade_Falloff;104;0;Create;True;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1405;-7609.425,-726.5969;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1403;-7942.434,-879.5641;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;2112;-8007.942,401.2925;Inherit;False;NormalCreate;0;;97;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1496;-5253.877,1726.34;Inherit;False;Constant;_Float18;Float 18;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1838;-5143.306,3601.74;Inherit;False;1837;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1837;-4934.535,4044.749;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1548;-4873.659,3263.97;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;955;-8273.891,-881.382;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-5136.009,1049.833;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1524;-6877.713,4084.179;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1495;-5087.964,1592.333;Inherit;True;Property;_TextureSample14;Texture Sample 14;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1413;-5993.575,1743.87;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-4464.731,1833.204;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1494;-5257.877,1962.339;Inherit;False;Constant;_Float17;Float 17;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;480;-6680.731,1808.06;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1538;-5448.421,3441.598;Inherit;False;Property;_DepthFade;DepthFade?;99;0;Create;True;0;0;False;1;Header(Depth Fade);False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-6696.731,1888.06;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;31;0;Create;True;0;0;False;1;Header(Shadow and NoiseEdge);False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1500;-2232.682,-3809.684;Inherit;False;Constant;_Float19;Float 19;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1493;-5089.964,1858.332;Inherit;True;Property;_TextureSample13;Texture Sample 13;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;582;-8231.951,-634.8589;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1760;-681.3223,-3435.616;Inherit;False;Property;_TerrainBlending_Color;TerrainBlending_Color;47;0;Create;True;0;0;False;0;False;1,1,1,0;0.6132076,0.3658997,0.3384211,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1406;-7791.276,-475.58;Inherit;False;Property;_NormalDebug;NormalDebug;5;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1376;-7626.413,-345.1284;Inherit;False;1375;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2075;-8058.865,295.8423;Inherit;False;Property;_UV_2_;UV_2_?;16;0;Create;True;0;0;False;1;Header(UV 2);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;1525;-6669.713,4084.179;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1832;-5027.637,-3797.773;Inherit;False;Constant;_Float21;Float 21;95;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;573;-5290.729,1622.205;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1539;-5364.841,3348.693;Inherit;False;Constant;_Float25;Float 25;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1726;-6219.809,-3507.759;Inherit;False;Property;_PaintGrunge_Contrast;PaintGrunge_Contrast;29;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1836;-4600.862,-4065.742;Inherit;False;Property;_AnimatedGrunge;AnimatedGrunge?;20;0;Create;True;0;0;False;1;Header(AnimatedGrunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1528;-5815.171,4144.195;Inherit;False;Property;_DepthFade_DitherMultiply;DepthFade_DitherMultiply;103;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;487;-5946.727,1958.204;Inherit;False;Property;_Noise_Panner;Noise_Panner;32;0;Create;True;0;0;False;0;False;0.2,-0.1;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;1531;-6549.526,3785.406;Inherit;True;Property;_DepthFade_Dither_Texture;DepthFade_Dither_Texture;101;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;1885;-5328.883,1821.181;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.FunctionNode;1529;-6264.526,4056.406;Inherit;False;Procedural Sample;-1;;98;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1546;-5538.422,4190.685;Inherit;False;Property;_DepthFade_ClampMin;DepthFade_ClampMin;106;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-6456.729,1808.06;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1530;-5574.171,4062.196;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;571;-5562.726,1622.205;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1542;-5978.962,4060.685;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;570;-4752.731,1834.204;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;565;-6456.729,1600.062;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2113;-7697.617,395.6537;Inherit;False;BlankNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;1464;-7896.038,-677.0542;Inherit;False;2091;NormalMixedUV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CameraDepthFade;1534;-5542.25,3866.659;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1414;-6224.575,1894.87;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;33;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1884;-5339.298,1537.034;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;844;-8539.096,-805.4249;Inherit;False;2052;FinalInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1533;-5820.251,3948.659;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;105;0;Create;True;0;0;False;0;False;10.5;10.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1523;-5140.084,4055.278;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1397;-4271.655,-190.3232;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1545;-5296.422,4062.685;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-6888.732,1808.06;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-5854.792,-1587.72;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1820;-7935.892,-2951.163;Inherit;False;Object_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1824;-6761.228,-3851.076;Inherit;True;1810;Grunge;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1544;-6192.962,3914.684;Inherit;False;Constant;_Float26;Float 26;86;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2212;-2805.132,-278.4471;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1469;-6880.624,-122.7947;Inherit;False;Property;_TerrainBlending;TerrainBlending?;44;0;Create;True;0;0;False;1;Header(TerrainBlending);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1565;-959.4577,-1185.041;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1834;-4268.863,-4232.739;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;632;-1998.641,-4605.529;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1606;-427.2567,-1191.493;Inherit;False;TopTexMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;509;-250.6789,-4400.333;Inherit;False;True;True;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;634;-1304.679,-4114.333;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1911;-2678.514,-675.7164;Inherit;False;Constant;_Float37;Float 37;89;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;627;-2486.461,-3950.335;Inherit;False;Property;_SpecularNoise;SpecularNoise;41;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1588;-5795.283,-218.7015;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;1369;-4018.847,-125.9157;Inherit;False;877;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2086;-6180.869,-2563.492;Inherit;False;2074;Switch_UV_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1566;-2267.429,-1219.732;Inherit;False;Property;_TopTex_Step;TopTex_Step;58;0;Create;True;0;0;False;0;False;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1835;-4525.862,-4303.739;Inherit;False;Constant;_Float23;Float 23;95;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;877;-3532.986,-1640.371;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1491;-5444.409,-4567.362;Inherit;True;Property;_TextureSample12;Texture Sample 12;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1816;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;448;-6062.792,-1539.719;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1829;-4919.732,-4562.094;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;633;-2334.642,-4509.528;Inherit;False;Property;_SpecularStepMax;SpecularStepMax;40;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2085;-5959.809,-2711.978;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1759;-390.0121,-3584.777;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1591;-6147.253,153.9455;Inherit;False;Property;_TopTex;TopTex?;52;0;Create;True;0;0;False;1;Header(Top Texture);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1560;-1464.253,-1041.766;Inherit;False;Constant;_Float8;Float 8;2;0;Create;True;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1382;-6350.948,-3711.748;Inherit;False;Procedural Sample;-1;;101;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerNode;1927;3857.769,243.7017;Inherit;True;Property;_TextureSample32;Texture Sample 32;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1553;-313.8558,-1545.829;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendOpsNode;428;-3795.095,-284.6147;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1462;-1062.334,-4539.279;Inherit;True;1455;Object_SpecularMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;508;-250.6789,-4320.333;Inherit;False;False;False;False;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1561;-1446.253,-1116.767;Inherit;False;Constant;_Float9;Float 9;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2191;-4026.808,-3228.894;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;499;-2525.152,-4214.391;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;1600;-1850.2,-2063.21;Inherit;True;Property;_TopTex_Albedo_Texture;TopTex_ Albedo_Texture;53;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;623;-752.6787,-4047.334;Inherit;False;Property;_SpecularColor;SpecularColor;42;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.8679245,0.7711852,0.5117478,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;455;-5123.35,-4567.476;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1114;2870.966,-3339.49;Inherit;False;Property;_IB_NormalInBrumeGrunge_Contrast;IB_NormalInBrumeGrunge_Contrast;84;0;Create;True;0;0;False;0;False;2.4;1.51;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-167.7526,-4116.125;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-6765.793,-1593.72;Inherit;False;Property;_StepShadow;StepShadow;34;0;Create;True;0;0;False;0;False;0.03;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1557;-2344.849,-1578.553;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;461;-3723.328,-3254.85;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;37.32248,-4368.333;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1615;-730.6519,-4535.72;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1471;-6776.444,-295.7177;Inherit;False;1366;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1697;-6748.165,-3231.761;Inherit;True;1453;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2184;-4869.375,-2854.151;Inherit;False;Property;_OutBrume_Edges_Textures;OutBrume_Edges_Textures?;11;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;670;-6310.598,-4029.866;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;630;-1672.681,-4114.333;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1501;-2026.735,-3996.074;Inherit;True;Property;_TextureSample15;Texture Sample 15;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;563;-4094.792,-1635.72;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1558;-2107.429,-1130.732;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-5886.792,-1699.719;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2182;-4545.375,-3069.151;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2181;-4893.375,-3049.187;Inherit;True;Property;_TextureSample25;Texture Sample 25;69;0;Create;True;0;0;False;1;Header(IB_Edges);False;-1;None;9fc1226b59297204c88aa087a5887390;True;0;False;white;Auto;False;Instance;2134;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;1930;3385.007,7.575001;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-427.6786,-4371.333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-2334.642,-4589.529;Inherit;False;Property;_SpeculartStepMin;SpeculartStepMin;39;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1950;2515.703,-4557.268;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2209;-2070.637,1595.406;Inherit;False;Property;_FakeLightStep;FakeLightStep;111;0;Create;True;0;0;False;0;False;0;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-6318.792,-2131.719;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;484;-5722.726,1878.204;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1370;-6839.285,-209.2626;Inherit;False;1368;RBG_TerrainBlending;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;666;-6457.598,-4199.864;Inherit;False;Property;_AnimatedGrunge_Flipbook_Rows;AnimatedGrunge_Flipbook_Rows;24;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-6206.792,-1891.719;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1390;926.8816,-4580.892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-4642.347,-4563.476;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1402;-5430.013,134.8876;Inherit;False;Property;_Specular;Specular?;37;0;Create;True;0;0;False;1;Header(Specular);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;841;-6462.057,-3126.585;Inherit;False;Property;_OutBrumeColorCorrection;OutBrumeColorCorrection;9;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;518;-5374.705,-90.1566;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1727;-5519.748,-3704.607;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1748;-5295.701,-3704.416;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1568;-2964.013,-899.0527;Inherit;False;Property;_TopTex_NoiseTiling;TopTex_NoiseTiling;56;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1394;-4835.74,-12.26521;Inherit;False;1389;CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1595;-1181.903,-845.6368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;640;-1464.681,-4114.333;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1585;298.8976,-4374.361;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;636;-1064.68,-4114.333;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1905;-786.4066,-3872.39;Inherit;False;1904;Object_Specular_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1400;-4597.928,136.6063;Inherit;False;Property;_CustomRimLight;CustomRimLight?;60;0;Create;True;0;0;False;1;Header(Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1395;-4594.544,-99.91722;Inherit;True;Lighten;True;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-5646.792,-1619.72;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1831;-4770.637,-3726.773;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;463;-6598.551,-4460.616;Inherit;False;Property;_AnimatedGrunge_Tiling;AnimatedGrunge_Tiling;22;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1358;366.9327,-3195.233;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-6349.551,-4539.616;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;2204;-2225.688,1381.078;Inherit;False;Property;_WaveFakeLight_Min;WaveFakeLight_Min;114;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1594;-1481.803,-661.8361;Inherit;False;InstancedProperty;_TopTex_NoiseHoles;TopTex_NoiseHoles?;55;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1458;-6890.672,980.9233;Inherit;True;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2214;-3190.051,-121.2931;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1412;-6089.449,-4465.237;Inherit;False;Property;_IsGrungeAnimated;IsGrungeAnimated?;21;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-6046.792,-2131.719;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;664;-6073.586,-4298.343;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1562;-1676.984,-1186.992;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1728;-5810.748,-3474.607;Inherit;False;Property;_PaintGrunge_Multiply;PaintGrunge_Multiply;30;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;449;-4878.788,-1619.72;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;626;-2305.461,-3968.334;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;562;-4487.789,-1817.719;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1366;-3427.235,-3256.38;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2106;-6690.329,-2693.678;Inherit;False;2072;Object_Albedo_Texture_UV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1584;-114.0908,-1550.381;Inherit;False;TopTex;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;1906;-434.4421,-3997.267;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1497;-6742.345,-3572.649;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;523;-779.6787,-4259.333;Inherit;False;Property;_Specular_Multiplier;Specular_Multiplier;43;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;842;-6166.093,-3226.85;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1607;-6526.412,47.94545;Inherit;False;1606;TopTexMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;667;-6458.598,-4121.866;Inherit;False;Property;_AnimatedGrunge_Flipbook_Speed;AnimatedGrunge_Flipbook_Speed;25;0;Create;True;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1367;38.84274,-3176.354;Inherit;False;1366;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1556;-2724.012,-876.0529;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;500;-2621.152,-4406.391;Inherit;False;Blinn-Phong Half Vector;-1;;100;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;2193;-4259.229,-3004.545;Inherit;False;Property;_OutBrumeColorCorrection_Additionnal;OutBrumeColorCorrection_Additionnal;10;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1567;-2314.428,-1111.733;Inherit;False;Property;_TopTex_Smoothstep;TopTex_Smoothstep;59;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;554.6646,-3201.673;Inherit;False;RBG_TerrainBlending;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2200;-2225.688,1297.078;Inherit;False;Property;_WaveFakeLight_Max;WaveFakeLight_Max;115;0;Create;False;0;0;False;0;False;1.1;1.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2180;-4355.31,-3228.641;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2059;-7360.309,-648.7876;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2060;-7375.881,-726.7039;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;EnvironmentObjectsShader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;0;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2063;-7360.251,-1099.568;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2062;-7360.251,-1099.568;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2061;-7360.251,-1099.568;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;1340;0;1338;1
WireConnection;1340;1;1338;3
WireConnection;1339;0;1336;0
WireConnection;1339;1;1337;0
WireConnection;1342;0;1340;0
WireConnection;1342;1;1339;0
WireConnection;1343;0;1342;0
WireConnection;1343;1;1341;0
WireConnection;1879;0;1881;0
WireConnection;1346;1;1343;0
WireConnection;1344;0;1338;2
WireConnection;1347;0;1346;0
WireConnection;1347;1;1345;0
WireConnection;1307;0;1305;4
WireConnection;1307;1;1306;0
WireConnection;1309;0;1307;0
WireConnection;1309;1;1308;0
WireConnection;1897;158;1898;0
WireConnection;1897;183;1899;0
WireConnection;1897;80;1359;0
WireConnection;1897;104;1361;0
WireConnection;1350;0;1348;0
WireConnection;1350;1;1347;0
WireConnection;1351;0;1363;0
WireConnection;1351;1;1897;0
WireConnection;1313;0;2092;0
WireConnection;1313;2;1310;0
WireConnection;1312;0;2093;0
WireConnection;1312;2;1311;0
WireConnection;1312;1;1309;0
WireConnection;1352;0;1350;0
WireConnection;1352;1;1349;0
WireConnection;1353;0;1352;0
WireConnection;1353;1;1351;0
WireConnection;1315;0;1312;0
WireConnection;1315;1;1313;0
WireConnection;1319;0;1316;0
WireConnection;1319;1;1315;0
WireConnection;1354;0;1353;0
WireConnection;1355;0;1354;0
WireConnection;1355;1;1364;0
WireConnection;1323;0;1886;0
WireConnection;1323;1;1319;0
WireConnection;1323;6;1887;0
WireConnection;2098;1;1323;0
WireConnection;2098;0;2099;0
WireConnection;1356;0;1355;0
WireConnection;1322;0;1321;0
WireConnection;1322;1;1318;4
WireConnection;1357;0;1356;0
WireConnection;1325;0;2098;0
WireConnection;1325;1;1322;0
WireConnection;1806;0;1804;0
WireConnection;1711;0;1806;0
WireConnection;1711;1;1622;0
WireConnection;1711;6;1718;0
WireConnection;1761;0;1357;0
WireConnection;1326;0;1325;0
WireConnection;1326;1;1324;0
WireConnection;1457;0;1711;4
WireConnection;1328;0;1326;0
WireConnection;1328;1;1329;0
WireConnection;1328;2;1304;1
WireConnection;1770;0;1765;0
WireConnection;1770;1;1767;0
WireConnection;2095;0;1328;0
WireConnection;1472;0;1467;0
WireConnection;1472;1;1900;0
WireConnection;1472;2;1477;0
WireConnection;2096;0;2095;0
WireConnection;2096;2;1314;0
WireConnection;1771;0;1770;0
WireConnection;1772;0;1771;0
WireConnection;1772;1;1472;0
WireConnection;1330;0;2096;0
WireConnection;1416;0;1428;0
WireConnection;1416;1;1772;0
WireConnection;1416;2;1417;0
WireConnection;1407;0;1334;0
WireConnection;1407;1;1331;0
WireConnection;1407;2;1408;0
WireConnection;1375;0;1416;0
WireConnection;2131;0;2135;0
WireConnection;1246;0;1119;0
WireConnection;1559;0;1557;0
WireConnection;1559;1;1566;0
WireConnection;1559;2;1558;0
WireConnection;2146;0;1162;0
WireConnection;2146;1;1252;0
WireConnection;2135;0;2134;0
WireConnection;2135;1;2130;0
WireConnection;2135;2;2136;0
WireConnection;2158;0;1249;0
WireConnection;2158;1;2161;0
WireConnection;1943;0;1936;0
WireConnection;2166;0;1105;0
WireConnection;2166;1;2167;0
WireConnection;2166;2;2168;0
WireConnection;2167;0;1108;0
WireConnection;2167;1;2170;0
WireConnection;1116;1;1749;0
WireConnection;1116;0;1117;0
WireConnection;1979;0;1976;0
WireConnection;2044;0;2043;0
WireConnection;1227;0;1225;0
WireConnection;1227;1;1235;0
WireConnection;1227;2;1165;0
WireConnection;1119;0;1116;0
WireConnection;2186;0;1255;0
WireConnection;2186;1;2189;0
WireConnection;2186;2;2185;0
WireConnection;2152;0;2161;0
WireConnection;2160;0;2158;0
WireConnection;2160;1;2152;0
WireConnection;2045;0;2044;0
WireConnection;2045;1;2048;0
WireConnection;2049;0;2051;0
WireConnection;2049;1;2050;0
WireConnection;2049;2;2148;0
WireConnection;1255;0;1256;0
WireConnection;1255;1;1223;0
WireConnection;1232;0;1228;0
WireConnection;1749;158;1888;0
WireConnection;1749;183;1889;0
WireConnection;1749;5;1754;0
WireConnection;1162;0;1049;0
WireConnection;1162;1;988;0
WireConnection;2163;0;2166;0
WireConnection;2163;1;2164;0
WireConnection;1240;0;1231;0
WireConnection;1752;158;1891;0
WireConnection;1752;183;1890;0
WireConnection;1752;5;1755;0
WireConnection;1223;0;1989;0
WireConnection;1873;0;1879;0
WireConnection;1873;1;1880;0
WireConnection;1873;6;1877;0
WireConnection;1251;0;2160;0
WireConnection;1929;0;1935;0
WireConnection;1929;1;2141;0
WireConnection;1981;0;1980;0
WireConnection;1981;1;1991;0
WireConnection;1231;0;1228;0
WireConnection;1231;1;1951;0
WireConnection;1231;2;1233;0
WireConnection;2046;0;2045;0
WireConnection;1977;0;1979;0
WireConnection;1977;1;1990;0
WireConnection;2164;1;2162;0
WireConnection;2164;0;2165;0
WireConnection;1228;0;1227;0
WireConnection;1228;1;1949;0
WireConnection;2140;0;2139;0
WireConnection;2140;1;2139;0
WireConnection;1817;1;1811;0
WireConnection;1817;6;1814;0
WireConnection;1843;0;1588;0
WireConnection;1843;1;518;0
WireConnection;1843;2;1402;0
WireConnection;2189;1;2188;0
WireConnection;2189;0;2190;0
WireConnection;1754;0;1750;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;1989;0;2146;0
WireConnection;1989;1;1995;0
WireConnection;1613;0;2107;0
WireConnection;1105;0;1465;0
WireConnection;2168;0;1182;0
WireConnection;2168;1;2170;0
WireConnection;1953;0;1950;0
WireConnection;1953;1;1230;0
WireConnection;1118;0;1241;0
WireConnection;1118;1;1248;0
WireConnection;2047;0;2046;0
WireConnection;2052;0;2149;0
WireConnection;1934;0;1932;0
WireConnection;1161;0;1158;0
WireConnection;1937;0;1930;0
WireConnection;2040;158;2038;0
WireConnection;2040;183;2036;0
WireConnection;2040;80;2037;0
WireConnection;2040;104;2140;0
WireConnection;1592;0;1468;0
WireConnection;1592;1;1590;0
WireConnection;1592;2;1608;0
WireConnection;1235;0;1165;0
WireConnection;1235;1;1230;0
WireConnection;2147;0;2047;0
WireConnection;1233;0;1232;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;2080;0;2106;0
WireConnection;2080;1;2081;0
WireConnection;1113;1;1752;0
WireConnection;1113;0;1114;0
WireConnection;2179;0;2161;0
WireConnection;498;0;1459;0
WireConnection;1994;0;1992;0
WireConnection;1755;0;1751;0
WireConnection;1809;1;1811;0
WireConnection;1809;6;1813;0
WireConnection;1716;1;1622;0
WireConnection;1716;6;1721;0
WireConnection;2100;1;2067;0
WireConnection;2100;6;2102;0
WireConnection;1895;0;1894;0
WireConnection;1808;1;1811;0
WireConnection;1808;6;1815;0
WireConnection;2126;0;1712;0
WireConnection;2126;1;2127;0
WireConnection;2072;0;2066;0
WireConnection;1908;1;1880;0
WireConnection;1908;6;1910;0
WireConnection;2042;0;2041;0
WireConnection;2042;1;2040;0
WireConnection;1455;0;1715;4
WireConnection;1874;0;1871;0
WireConnection;1712;1;1622;0
WireConnection;1712;6;1719;0
WireConnection;1872;1;1880;0
WireConnection;1872;6;1878;0
WireConnection;1823;0;1808;0
WireConnection;1909;0;1908;0
WireConnection;1904;0;1715;0
WireConnection;1939;0;1941;0
WireConnection;1939;1;1937;0
WireConnection;1939;6;1933;0
WireConnection;506;0;504;0
WireConnection;1365;1;1373;0
WireConnection;2207;0;2201;0
WireConnection;465;0;464;0
WireConnection;2199;0;2197;0
WireConnection;2198;0;2200;0
WireConnection;2198;1;2204;0
WireConnection;2198;2;2206;0
WireConnection;2202;0;2205;0
WireConnection;2202;1;2208;0
WireConnection;2128;0;2069;0
WireConnection;2128;1;2129;0
WireConnection;2205;0;2198;0
WireConnection;2205;1;2209;0
WireConnection;2206;0;2207;0
WireConnection;2197;0;2195;0
WireConnection;2197;1;2203;0
WireConnection;2197;2;2196;0
WireConnection;2197;3;2205;0
WireConnection;2197;4;2202;0
WireConnection;1871;1;1880;0
WireConnection;1871;6;1882;0
WireConnection;2068;0;2065;0
WireConnection;1821;0;1809;0
WireConnection;473;0;2212;0
WireConnection;1715;1;1622;0
WireConnection;1715;6;1720;0
WireConnection;1454;0;1712;0
WireConnection;2177;0;2161;0
WireConnection;2177;1;2163;0
WireConnection;2101;0;2100;0
WireConnection;2043;0;2035;0
WireConnection;2043;1;2042;0
WireConnection;1816;0;1810;0
WireConnection;1816;1;1811;0
WireConnection;1816;6;1812;0
WireConnection;1468;0;1471;0
WireConnection;1468;1;1370;0
WireConnection;1468;2;1469;0
WireConnection;2073;0;2069;0
WireConnection;1990;0;2131;0
WireConnection;1990;1;1966;0
WireConnection;1475;0;1716;0
WireConnection;2149;0;2150;0
WireConnection;2149;1;2049;0
WireConnection;2149;2;2151;0
WireConnection;1247;0;1115;0
WireConnection;988;0;989;0
WireConnection;988;1;1118;0
WireConnection;1991;0;2131;0
WireConnection;1991;1;1983;0
WireConnection;1985;0;1977;0
WireConnection;1985;1;1981;0
WireConnection;1894;1;1880;0
WireConnection;1894;6;1896;0
WireConnection;1456;0;1716;4
WireConnection;1876;0;1873;0
WireConnection;1951;0;1225;0
WireConnection;1951;1;1953;0
WireConnection;1951;2;1950;0
WireConnection;901;0;2186;0
WireConnection;1581;0;1599;0
WireConnection;1581;1;1557;0
WireConnection;1822;0;1817;0
WireConnection;1875;0;1872;0
WireConnection;2066;0;2068;0
WireConnection;2066;1;2067;0
WireConnection;2066;6;2070;0
WireConnection;1810;0;1818;0
WireConnection;1158;0;1242;0
WireConnection;1453;0;1711;0
WireConnection;1932;0;1939;1
WireConnection;1932;1;1927;1
WireConnection;2069;1;2067;0
WireConnection;2069;6;2071;0
WireConnection;23;0;711;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;2161;0;1105;0
WireConnection;2161;1;1108;0
WireConnection;2161;2;1182;0
WireConnection;1980;0;1979;0
WireConnection;1115;0;1113;0
WireConnection;2178;0;2179;0
WireConnection;2178;1;2177;0
WireConnection;1931;0;1943;0
WireConnection;1931;2;1935;0
WireConnection;1552;0;1565;0
WireConnection;2107;0;842;0
WireConnection;2107;1;2085;0
WireConnection;1599;0;1600;0
WireConnection;1599;3;1604;0
WireConnection;1992;0;1985;0
WireConnection;1393;0;1390;0
WireConnection;1393;1;1901;0
WireConnection;1389;0;1393;0
WireConnection;1901;0;1391;0
WireConnection;1901;1;1903;0
WireConnection;1901;2;1902;0
WireConnection;1608;0;1607;0
WireConnection;711;0;12;0
WireConnection;711;1;710;0
WireConnection;2137;0;1458;0
WireConnection;2137;1;2111;0
WireConnection;2137;2;2138;0
WireConnection;2091;0;2137;0
WireConnection;10;0;2137;0
WireConnection;2111;0;1458;0
WireConnection;2111;1;2076;0
WireConnection;1609;0;1407;0
WireConnection;1609;1;1611;0
WireConnection;1609;2;954;0
WireConnection;2074;0;2075;0
WireConnection;572;0;487;0
WireConnection;1540;0;1539;0
WireConnection;1540;1;1838;0
WireConnection;1540;2;1538;0
WireConnection;1049;0;1050;0
WireConnection;1049;1;1161;0
WireConnection;2210;0;2199;0
WireConnection;2034;0;1352;0
WireConnection;401;0;397;0
WireConnection;1564;0;1582;1
WireConnection;530;0;1834;0
WireConnection;530;1;1831;0
WireConnection;1411;0;466;0
WireConnection;1411;1;664;0
WireConnection;1411;2;1412;0
WireConnection;1612;0;2107;0
WireConnection;1612;1;1613;0
WireConnection;1612;2;1614;0
WireConnection;1582;1;1556;0
WireConnection;1563;0;1562;0
WireConnection;1563;1;1561;0
WireConnection;1563;2;1560;0
WireConnection;504;0;500;0
WireConnection;504;1;499;0
WireConnection;1527;0;1525;0
WireConnection;1527;1;1526;0
WireConnection;1555;0;1598;0
WireConnection;1373;0;1374;0
WireConnection;1725;1;1382;0
WireConnection;1725;0;1726;0
WireConnection;2188;0;2187;0
WireConnection;1405;0;1403;0
WireConnection;1405;1;1464;0
WireConnection;1405;2;1406;0
WireConnection;1403;0;955;0
WireConnection;1403;1;582;0
WireConnection;1403;2;1404;0
WireConnection;1837;0;1523;0
WireConnection;1548;0;1416;0
WireConnection;1548;1;1540;0
WireConnection;955;0;474;0
WireConnection;955;1;844;0
WireConnection;955;2;954;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;1495;0;1884;0
WireConnection;1495;1;573;0
WireConnection;1495;6;1496;0
WireConnection;1413;0;565;0
WireConnection;1413;1;477;0
WireConnection;1413;2;1414;0
WireConnection;481;0;570;0
WireConnection;480;0;478;0
WireConnection;1493;0;1885;0
WireConnection;1493;1;484;0
WireConnection;1493;6;1494;0
WireConnection;1525;0;1524;0
WireConnection;573;0;571;0
WireConnection;1529;82;1531;0
WireConnection;1529;5;1527;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;1530;0;1542;0
WireConnection;1530;1;1528;0
WireConnection;571;0;1413;0
WireConnection;571;2;572;0
WireConnection;1542;0;1544;0
WireConnection;1542;1;1529;32
WireConnection;1542;2;1543;0
WireConnection;570;0;1495;1
WireConnection;570;1;1493;1
WireConnection;565;0;479;0
WireConnection;2113;0;2112;0
WireConnection;1534;0;1532;0
WireConnection;1534;1;1533;0
WireConnection;1523;0;1534;0
WireConnection;1523;1;1545;0
WireConnection;1523;2;1535;0
WireConnection;1397;0;1843;0
WireConnection;1397;1;1395;0
WireConnection;1397;2;1400;0
WireConnection;1545;0;1530;0
WireConnection;1545;1;1546;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;1820;0;1816;0
WireConnection;2212;0;428;0
WireConnection;2212;1;2214;0
WireConnection;2212;2;2213;0
WireConnection;1565;0;1563;0
WireConnection;1565;1;1595;0
WireConnection;1834;0;1835;0
WireConnection;1834;1;525;0
WireConnection;1834;2;1836;0
WireConnection;632;0;506;0
WireConnection;632;1;619;0
WireConnection;632;2;633;0
WireConnection;1606;0;1565;0
WireConnection;509;0;522;0
WireConnection;634;0;640;0
WireConnection;1588;0;1468;0
WireConnection;1588;1;1592;0
WireConnection;1588;2;1591;0
WireConnection;877;0;563;0
WireConnection;1491;1;1411;0
WireConnection;1491;6;1492;0
WireConnection;1829;1;455;0
WireConnection;1829;0;1828;0
WireConnection;2085;0;2088;0
WireConnection;2085;1;2080;0
WireConnection;2085;2;2086;0
WireConnection;1759;0;1365;0
WireConnection;1759;1;1760;0
WireConnection;1382;158;1824;0
WireConnection;1382;183;1825;0
WireConnection;1382;80;1497;0
WireConnection;1382;104;1385;0
WireConnection;1927;0;1940;0
WireConnection;1927;1;1931;0
WireConnection;1927;6;1928;0
WireConnection;1553;0;1581;0
WireConnection;1553;1;1552;0
WireConnection;428;0;1468;0
WireConnection;428;1;1369;0
WireConnection;508;0;522;0
WireConnection;2191;0;2180;0
WireConnection;2191;1;2193;0
WireConnection;499;0;498;0
WireConnection;455;0;1491;1
WireConnection;639;0;636;0
WireConnection;639;1;1906;0
WireConnection;1557;0;1555;0
WireConnection;1557;1;1554;0
WireConnection;461;0;530;0
WireConnection;461;1;2191;0
WireConnection;512;0;509;0
WireConnection;512;1;508;0
WireConnection;512;2;639;0
WireConnection;1615;0;1462;0
WireConnection;630;0;632;0
WireConnection;630;1;1501;0
WireConnection;1501;1;626;0
WireConnection;1501;6;1500;0
WireConnection;563;0;562;0
WireConnection;563;1;449;0
WireConnection;1558;0;1566;0
WireConnection;1558;1;1567;0
WireConnection;2182;0;2183;0
WireConnection;2182;1;2181;0
WireConnection;2182;2;2184;0
WireConnection;1930;0;1943;0
WireConnection;1930;2;1929;0
WireConnection;522;0;1615;0
WireConnection;522;1;523;0
WireConnection;1950;0;1165;0
WireConnection;1950;1;1954;0
WireConnection;484;0;1413;0
WireConnection;484;2;487;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;1390;0;1461;0
WireConnection;1390;1;1392;0
WireConnection;525;0;1829;0
WireConnection;525;1;526;0
WireConnection;518;0;1588;0
WireConnection;518;1;1586;0
WireConnection;1727;0;1725;0
WireConnection;1727;1;1728;0
WireConnection;1748;0;1727;0
WireConnection;1595;0;1596;0
WireConnection;1595;1;1564;0
WireConnection;1595;2;1594;0
WireConnection;640;0;630;0
WireConnection;1585;0;512;0
WireConnection;636;0;634;0
WireConnection;1395;0;1843;0
WireConnection;1395;1;1394;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;1831;0;1832;0
WireConnection;1831;1;1748;0
WireConnection;1831;2;1833;0
WireConnection;1358;0;1759;0
WireConnection;1358;1;1367;0
WireConnection;1358;2;1357;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;2214;0;428;0
WireConnection;2214;1;2215;0
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;664;0;466;0
WireConnection;664;1;665;0
WireConnection;664;2;666;0
WireConnection;664;3;667;0
WireConnection;664;5;670;0
WireConnection;1562;0;1559;0
WireConnection;1562;1;1582;1
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;626;0;627;0
WireConnection;562;0;449;0
WireConnection;1366;0;461;0
WireConnection;1584;0;1553;0
WireConnection;1906;0;623;0
WireConnection;1906;1;1905;0
WireConnection;1906;2;1907;0
WireConnection;842;0;1697;0
WireConnection;842;1;841;0
WireConnection;1556;0;1568;0
WireConnection;1556;1;1569;0
WireConnection;1368;0;1358;0
WireConnection;2180;0;1612;0
WireConnection;2180;1;2182;0
WireConnection;2060;2;1405;0
WireConnection;2060;3;1376;0
WireConnection;2060;5;1609;0
ASEEND*/
//CHKSM=9749DB7FB60AC0E4419864696D39B8039D7C1372
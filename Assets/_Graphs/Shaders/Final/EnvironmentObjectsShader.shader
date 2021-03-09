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
		_TextureArray_Textures_UV2("TextureArray_Textures_UV2", 2DArray) = "white" {}
		[Header(Textures Arrays)]_TextureArray_Textures("TextureArray_Textures", 2DArray) = "white" {}
		_TextureArray_Grunges("TextureArray_Grunges", 2DArray) = "white" {}
		_TextureArray_Noises("TextureArray_Noises", 2DArray) = "white" {}
		_IB_TerrainBlendingNoise_Tiling("IB_TerrainBlendingNoise_Tiling", Vector) = (1,1,0,0)
		_TerrainBlendingNoise_Tiling("TerrainBlendingNoise_Tiling", Vector) = (1,1,0,0)
		[Header(AnimatedGrunge)]_AnimatedGrunge("AnimatedGrunge?", Range( 0 , 1)) = 0
		_IsGrungeAnimated("IsGrungeAnimated?", Range( 0 , 1)) = 0
		_AnimatedGrunge_Tiling("AnimatedGrunge_Tiling", Float) = 1
		_AnimatedGrunge_Flipbook_Columns("AnimatedGrunge_Flipbook_Columns", Float) = 1
		_AnimatedGrunge_Flipbook_Rows("AnimatedGrunge_Flipbook_Rows", Float) = 1
		_AnimatedGrunge_Flipbook_Speed("AnimatedGrunge_Flipbook_Speed", Float) = 1
		_AnimatedGrungeMultiply("AnimatedGrungeMultiply", Float) = 1.58
		_TextureSample15("Texture Sample 15", 2DArray) = "white" {}
		[Header(PaintGrunge)]_PaintGrunge("PaintGrunge?", Range( 0 , 1)) = 0
		_PaintGrunge_Tiling("PaintGrunge_Tiling", Float) = 1
		_PaintGrunge_Contrast("PaintGrunge_Contrast", Float) = 0
		_PaintGrunge_Multiply("PaintGrunge_Multiply", Float) = 0
		_ScreenBasedNoise("ScreenBasedNoise?", Range( 0 , 1)) = 0
		[Header(Shadow and NoiseEdge)]_Noise_Tiling("Noise_Tiling", Float) = 1
		[Header(Shadow and NoiseEdge)]_IB_Noise_Tiling("IB_Noise_Tiling", Float) = 1
		_Noise_Panner("Noise_Panner", Vector) = (0.2,-0.1,0,0)
		_IB_Noise_Panner("IB_Noise_Panner", Vector) = (0.2,-0.1,0,0)
		_StepShadow("StepShadow", Float) = 0.03
		_StepAttenuation("StepAttenuation", Float) = 0.3
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		[Header(Specular)]_Specular("Specular?", Range( 0 , 1)) = 0
		_SpecularTexture("SpecularTexture?", Range( 0 , 1)) = 0
		_SpeculartStepMin("SpeculartStepMin", Float) = 0
		_SpecularStepMax("SpecularStepMax", Float) = 1
		_SpecularNoise("SpecularNoise", Float) = 1
		_SpecularColor("SpecularColor", Color) = (0.9433962,0.8590411,0.6274475,0)
		_Specular_Multiplier("Specular_Multiplier", Float) = 1
		[Header(TerrainBlending)]_TerrainBlending("TerrainBlending?", Range( 0 , 1)) = 0
		_TerrainBlending_TextureTerrain("TerrainBlending_TextureTerrain", 2D) = "white" {}
		_TerrainBlending_Color("TerrainBlending_Color", Color) = (1,1,1,0)
		_TerrainBlending_Opacity("TerrainBlending_Opacity", Range( 0 , 1)) = 0
		_TerrainBlending_TextureTiling("TerrainBlending_TextureTiling", Float) = 1
		_TerrainBlending_BlendThickness("TerrainBlending_BlendThickness", Range( 0 , 30)) = 0
		_IB_TerrainBlending_BlendThickness("IB_TerrainBlending_BlendThickness", Range( 0 , 30)) = 0
		_IB_TerrainBlending_Falloff("IB_TerrainBlending_Falloff", Range( 0 , 30)) = 0
		_IB_TerrainBlending_Color("IB_TerrainBlending_Color", Color) = (0.4245283,0.4245283,0.4245283,0)
		_TerrainBlending_Falloff("TerrainBlending_Falloff", Range( 0 , 30)) = 0
		[Header(Top Texture)]_TopTex("TopTex?", Range( 0 , 1)) = 0
		_TopTex_Albedo_Texture("TopTex_ Albedo_Texture", 2D) = "white" {}
		_TopTex_Tiling("TopTex_Tiling", Vector) = (1,1,0,0)
		_TopTex_NoiseHoles("TopTex_NoiseHoles?", Range( 0 , 1)) = 0
		_TopTex_NoiseTiling("TopTex_NoiseTiling", Float) = 1
		_TopTex_NoiseOffset("TopTex_NoiseOffset", Vector) = (0,0,0,0)
		_TopTex_Step("TopTex_Step", Float) = 0
		_TopTex_Smoothstep("TopTex_Smoothstep", Float) = 0.3
		[Header(Custom Rim Light)]_CustomRimLight("CustomRimLight?", Range( 0 , 1)) = 0
		_CustomRimLight_Texture("CustomRimLight_Texture?", Range( 0 , 1)) = 0
		_CustomRimLight_Color("CustomRimLight_Color", Color) = (1,1,1,0)
		_CustomRimLight_Opacity("CustomRimLight_Opacity", Float) = 1
		_OutBrume_UV2_ColorCorrection("OutBrume_UV2_ColorCorrection", Color) = (1,1,1,0)
		_OutBrumeColorCorrection("OutBrumeColorCorrection", Color) = (1,1,1,0)
		[Header(In Brume)]_IB_BackColor("IB_BackColor", Color) = (1,1,1,0)
		_IB_ColorShadow("IB_ColorShadow", Color) = (0.5283019,0.5283019,0.5283019,0)
		_ShadowDrippingNoise_Smoothstep("ShadowDrippingNoise_Smoothstep", Float) = 0.2
		_ShadowDrippingNoise_Step("ShadowDrippingNoise_Step", Float) = 0
		_NormalDrippingNoise_Smoothstep("NormalDrippingNoise_Smoothstep", Range( 0 , 1)) = 0.01
		_NormalDrippingNoise_Step("NormalDrippingNoise_Step", Range( 0 , 1)) = 0.45
		_NormalDrippingNoise_Tiling("NormalDrippingNoise_Tiling", Float) = 1
		_NormalDrippingNoise_Offset("NormalDrippingNoise_Offset", Vector) = (0,0,0,0)
		_ShadowInBrumeGrunge_Tiling("ShadowInBrumeGrunge_Tiling", Float) = 0.2
		_ShadowInBrumeGrunge_Contrast("ShadowInBrumeGrunge_Contrast", Float) = -3.38
		_NormalInBrumeGrunge_Tiling("NormalInBrumeGrunge_Tiling", Float) = 0.2
		_NormalInBrumeGrunge_Contrast("NormalInBrumeGrunge_Contrast", Float) = 2.4
		_InBrumeColorCorrection("InBrumeColorCorrection", Color) = (1,1,1,0)
		[Header(Wind)]_WindVertexDisplacement("WindVertexDisplacement?", Range( 0 , 1)) = 0
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
		_DepthFade_ClampMax("DepthFade_ClampMax", Range( 0 , 1)) = 0.8
		_ShadowDrippingNoise_SmoothstepAnimated("ShadowDrippingNoise_SmoothstepAnimated", Float) = 0
		_Float29("Float 29", Float) = 2
		_Float30("Float 30", Float) = 3
		_IB_Edges_Mask("IB_Edges_Mask", 2D) = "white" {}
		_Float38("Float 38", Range( 0 , 1)) = 0
		_Float39("Float 39", Range( 0 , 1)) = 0
		[ASEEnd][Header(UV 2)]_UV_2_("UV_2_?", Range( 0 , 1)) = 0
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
			float4 _CustomRimLight_Color;
			float4 _ShadowColor;
			float4 _IB_TerrainBlending_Color;
			float4 _InBrumeColorCorrection;
			float4 _IB_BackColor;
			float4 _SpecularColor;
			float4 _IB_ColorShadow;
			float4 _TerrainBlending_Color;
			float4 _OutBrume_UV2_ColorCorrection;
			float4 _OutBrumeColorCorrection;
			float2 _IB_Noise_Panner;
			float2 _TopTex_NoiseOffset;
			float2 _TopTex_Tiling;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _NormalDrippingNoise_Offset;
			float2 _Noise_Panner;
			float2 _WindWave_Speed;
			float2 _WindWave_Min_Speed;
			float2 _IB_TerrainBlendingNoise_Tiling;
			float _IB_TerrainBlending_BlendThickness;
			float _ScreenBasedNoise;
			float _DepthFade_ClampMin;
			float _DepthFade_DitherMultiply;
			float _ShadowDrippingNoise_Step;
			float _DepthFade_Texture;
			float _ShadowDrippingNoise_Smoothstep;
			float _DepthFade_Dither_Tiling;
			float _IB_Noise_Tiling;
			float _ShadowDrippingNoise_SmoothstepAnimated;
			float _DepthFade_Distance;
			float _DepthFade_Falloff;
			float _ShadowInBrumeGrunge_Contrast;
			float _ShadowInBrumeGrunge_Tiling;
			float _Opacity;
			float _NormalInBrumeGrunge_Contrast;
			float _NormalInBrumeGrunge_Tiling;
			float _CustomOpacityMask;
			float _Float30;
			float _TerrainBlending_Opacity;
			float _Noise_Tiling;
			float _NormalDrippingNoise_Smoothstep;
			float _NormalDrippingNoise_Tiling;
			float _NormalDebug;
			float _LightDebug;
			float _IB_TerrainBlending_Falloff;
			float _Float38;
			float _Float39;
			float _Float29;
			float _NormalDrippingNoise_Step;
			float _Wind_Texture_Tiling;
			float _StepShadow;
			float _PaintGrunge_Multiply;
			float _PaintGrunge_Tiling;
			float _PaintGrunge_Contrast;
			float _AnimatedGrunge;
			float _AnimatedGrungeMultiply;
			float _IsGrungeAnimated;
			float _AnimatedGrunge_Flipbook_Speed;
			float _PaintGrunge;
			float _AnimatedGrunge_Flipbook_Rows;
			float _AnimatedGrunge_Tiling;
			float _Out_or_InBrume;
			float _WindVertexDisplacement;
			float _Wind_Strength;
			float _Wind_Density;
			float _Wind_Direction;
			float _Wave_Speed;
			float _AnimatedGrunge_Flipbook_Columns;
			float _UV_2_;
			float _DebugGrayscale;
			float _TerrainBlending_TextureTiling;
			float _CustomRimLight;
			float _CustomRimLight_Texture;
			float _DepthFade_ClampMax;
			float _CustomRimLight_Opacity;
			float _Specular;
			float _SpecularTexture;
			float _SpecularNoise;
			float _SpecularStepMax;
			float _SpeculartStepMin;
			float _Specular_Multiplier;
			float _TopTex;
			float _TopTex_NoiseTiling;
			float _TopTex_Smoothstep;
			float _TopTex_Step;
			float _TerrainBlending;
			float _TerrainBlending_Falloff;
			float _TerrainBlending_BlendThickness;
			float _StepAttenuation;
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
			TEXTURE2D_ARRAY(_TextureArray_Noises);
			SAMPLER(sampler_TextureArray_Noises);
			TEXTURE2D_ARRAY(_TextureArray_Grunges);
			SAMPLER(sampler_TextureArray_Grunges);
			TEXTURE2D_ARRAY(_TextureArray_Textures);
			SAMPLER(sampler_TextureArray_Textures);
			TEXTURE2D_ARRAY(_TextureArray_Textures_UV2);
			SAMPLER(sampler_TextureArray_Textures_UV2);
			sampler2D _TerrainBlending_TextureTerrain;
			sampler2D TB_DEPTH;
			float TB_OFFSET_X;
			float TB_OFFSET_Z;
			float TB_SCALE;
			float TB_FARCLIP;
			float TB_OFFSET_Y;
			sampler2D _TopTex_Albedo_Texture;
			TEXTURE2D_ARRAY(_TextureSample15);
			SAMPLER(sampler_TextureSample15);
			sampler2D _IB_Edges_Mask;
			sampler2D _DepthFade_Dither_Texture;
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
				UNITY_DEFINE_INSTANCED_PROP(float4, _IB_Edges_Mask_ST)
				UNITY_DEFINE_INSTANCED_PROP(float, _TopTex_NoiseHoles)
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
			
			void TriplanarWeights229_g40( float3 WorldNormal, out float W0, out float W1, out float W2 )
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
			
			void TriplanarWeights229_g37( float3 WorldNormal, out float W0, out float W1, out float W2 )
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

				float4 temp_cast_0 = (0.0).xxxx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _Wave_Speed ) * _WindWave_Speed + float2( 0,0 ));
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + float2( 0,0 ));
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( ( panner1312 + panner1313 ) * _Wind_Direction );
				float4 temp_cast_2 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_3 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( ( SAMPLE_TEXTURE2D_ARRAY_LOD( _TextureArray_Noises, sampler_TextureArray_Noises, texCoord1319,1.0, 0.0 ) - temp_cast_2 ) * _Wind_Strength ) + float4( 0,0,0,0 ) ) , temp_cast_3 , v.ase_color);
				float4 WindVertexDisplacement1330 = lerpResult1328;
				float4 lerpResult1407 = lerp( temp_cast_0 , WindVertexDisplacement1330 , _WindVertexDisplacement);
				float4 temp_cast_4 = (0.0).xxxx;
				float4 lerpResult1609 = lerp( lerpResult1407 , temp_cast_4 , _Out_or_InBrume);
				
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
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord4.w = eyeDepth;
				
				o.ase_texcoord5.xy = v.ase_texcoord.xy;
				o.ase_texcoord5.zw = v.ase_texcoord1.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;
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
				float localStochasticTiling216_g40 = ( 0.0 );
				float2 temp_cast_3 = (_PaintGrunge_Tiling).xx;
				float2 temp_output_104_0_g40 = temp_cast_3;
				float3 temp_output_80_0_g40 = WorldPosition;
				float2 Triplanar_UV050_g40 = ( temp_output_104_0_g40 * (temp_output_80_0_g40).zy );
				float2 UV216_g40 = Triplanar_UV050_g40;
				float2 UV1216_g40 = float2( 0,0 );
				float2 UV2216_g40 = float2( 0,0 );
				float2 UV3216_g40 = float2( 0,0 );
				float W1216_g40 = 0.0;
				float W2216_g40 = 0.0;
				float W3216_g40 = 0.0;
				StochasticTiling( UV216_g40 , UV1216_g40 , UV2216_g40 , UV3216_g40 , W1216_g40 , W2216_g40 , W3216_g40 );
				float Input_Index184_g40 = 1.0;
				float2 temp_output_280_0_g40 = ddx( Triplanar_UV050_g40 );
				float2 temp_output_275_0_g40 = ddy( Triplanar_UV050_g40 );
				float localTriplanarWeights229_g40 = ( 0.0 );
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 WorldNormal229_g40 = ase_worldNormal;
				float W0229_g40 = 0.0;
				float W1229_g40 = 0.0;
				float W2229_g40 = 0.0;
				TriplanarWeights229_g40( WorldNormal229_g40 , W0229_g40 , W1229_g40 , W2229_g40 );
				float localStochasticTiling215_g40 = ( 0.0 );
				float2 Triplanar_UV164_g40 = ( temp_output_104_0_g40 * (temp_output_80_0_g40).zx );
				float2 UV215_g40 = Triplanar_UV164_g40;
				float2 UV1215_g40 = float2( 0,0 );
				float2 UV2215_g40 = float2( 0,0 );
				float2 UV3215_g40 = float2( 0,0 );
				float W1215_g40 = 0.0;
				float W2215_g40 = 0.0;
				float W3215_g40 = 0.0;
				StochasticTiling( UV215_g40 , UV1215_g40 , UV2215_g40 , UV3215_g40 , W1215_g40 , W2215_g40 , W3215_g40 );
				float2 temp_output_242_0_g40 = ddx( Triplanar_UV164_g40 );
				float2 temp_output_247_0_g40 = ddy( Triplanar_UV164_g40 );
				float localStochasticTiling201_g40 = ( 0.0 );
				float2 Triplanar_UV271_g40 = ( temp_output_104_0_g40 * (temp_output_80_0_g40).xy );
				float2 UV201_g40 = Triplanar_UV271_g40;
				float2 UV1201_g40 = float2( 0,0 );
				float2 UV2201_g40 = float2( 0,0 );
				float2 UV3201_g40 = float2( 0,0 );
				float W1201_g40 = 0.0;
				float W2201_g40 = 0.0;
				float W3201_g40 = 0.0;
				StochasticTiling( UV201_g40 , UV1201_g40 , UV2201_g40 , UV3201_g40 , W1201_g40 , W2201_g40 , W3201_g40 );
				float2 temp_output_214_0_g40 = ddx( Triplanar_UV271_g40 );
				float2 temp_output_258_0_g40 = ddy( Triplanar_UV271_g40 );
				float4 Output_TriplanarArray296_g40 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1216_g40,Input_Index184_g40, temp_output_280_0_g40, temp_output_275_0_g40 ) * W1216_g40 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2216_g40,Input_Index184_g40, temp_output_280_0_g40, temp_output_275_0_g40 ) * W2216_g40 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3216_g40,Input_Index184_g40, temp_output_280_0_g40, temp_output_275_0_g40 ) * W3216_g40 ) ) * W0229_g40 ) + ( W1229_g40 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1215_g40,Input_Index184_g40, temp_output_242_0_g40, temp_output_247_0_g40 ) * W1215_g40 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2215_g40,Input_Index184_g40, temp_output_242_0_g40, temp_output_247_0_g40 ) * W2215_g40 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3215_g40,Input_Index184_g40, temp_output_242_0_g40, temp_output_247_0_g40 ) * W3215_g40 ) ) ) + ( W2229_g40 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1201_g40,Input_Index184_g40, temp_output_214_0_g40, temp_output_258_0_g40 ) * W1201_g40 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2201_g40,Input_Index184_g40, temp_output_214_0_g40, temp_output_258_0_g40 ) * W2201_g40 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3201_g40,Input_Index184_g40, temp_output_214_0_g40, temp_output_258_0_g40 ) * W3201_g40 ) ) ) );
				float lerpResult1831 = lerp( 1.0 , ( CalculateContrast(_PaintGrunge_Contrast,Output_TriplanarArray296_g40) * _PaintGrunge_Multiply ).r , _PaintGrunge);
				float2 texCoord1622 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode1711 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures, sampler_TextureArray_Textures, texCoord1622,0.0 );
				float4 Object_Albedo_Texture1453 = tex2DArrayNode1711;
				float4 temp_cast_4 = (0.0).xxxx;
				float2 texCoord2067 = IN.ase_texcoord5.zw * float2( 1,1 ) + float2( 0,0 );
				float4 Object_Albedo_Texture_UV22072 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures_UV2, sampler_TextureArray_Textures_UV2, texCoord2067,0.0 );
				float Switch_UV_22074 = _UV_2_;
				float4 lerpResult2085 = lerp( temp_cast_4 , ( Object_Albedo_Texture_UV22072 * _OutBrume_UV2_ColorCorrection ) , Switch_UV_22074);
				float4 temp_output_2078_0 = ( ( Object_Albedo_Texture1453 * _OutBrumeColorCorrection ) + lerpResult2085 );
				float grayscale1613 = dot(temp_output_2078_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_6 = (grayscale1613).xxxx;
				float4 lerpResult1612 = lerp( temp_output_2078_0 , temp_cast_6 , _DebugGrayscale);
				float4 blendOpSrc461 = ( lerpResult1834 * lerpResult1831 );
				float4 blendOpDest461 = lerpResult1612;
				float4 RGB1366 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
				float2 temp_cast_7 = (_TerrainBlending_TextureTiling).xx;
				float2 texCoord1373 = IN.ase_texcoord5.xy * temp_cast_7 + float2( 0,0 );
				float worldY1344 = WorldPosition.y;
				float4 temp_cast_8 = (worldY1344).xxxx;
				float2 appendResult1340 = (float2(WorldPosition.x , WorldPosition.z));
				float2 appendResult1339 = (float2(TB_OFFSET_X , TB_OFFSET_Z));
				float4 temp_cast_9 = (TB_OFFSET_Y).xxxx;
				float4 temp_output_1352_0 = ( ( temp_cast_8 - ( tex2D( TB_DEPTH, ( ( appendResult1340 - appendResult1339 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_9 );
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
				float4 temp_cast_10 = (_TerrainBlending_Falloff).xxxx;
				float4 clampResult1356 = clamp( pow( clampResult1354 , temp_cast_10 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult1358 = lerp( ( tex2D( _TerrainBlending_TextureTerrain, texCoord1373 ) * _TerrainBlending_Color ) , RGB1366 , clampResult1356.r);
				float4 RBG_TerrainBlending1368 = lerpResult1358;
				float4 lerpResult1468 = lerp( RGB1366 , RBG_TerrainBlending1368 , _TerrainBlending);
				float4 triplanar1599 = TriplanarSampling1599( _TopTex_Albedo_Texture, WorldPosition, ase_worldNormal, 1.0, _TopTex_Tiling, 1.0, 0 );
				float4 Object_Normal_Texture1454 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures, sampler_TextureArray_Textures, texCoord1622,1.0 );
				float3 ase_worldTangent = IN.ase_texcoord6.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal1555 = Object_Normal_Texture1454.rgb;
				float3 worldNormal1555 = float3(dot(tanToWorld0,tanNormal1555), dot(tanToWorld1,tanNormal1555), dot(tanToWorld2,tanNormal1555));
				float dotResult1557 = dot( worldNormal1555 , float3(0,1,0) );
				float smoothstepResult1559 = smoothstep( _TopTex_Step , ( _TopTex_Step + _TopTex_Smoothstep ) , dotResult1557);
				float2 temp_cast_14 = (_TopTex_NoiseTiling).xx;
				float2 texCoord1556 = IN.ase_texcoord5.xy * temp_cast_14 + _TopTex_NoiseOffset;
				float4 tex2DArrayNode1582 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Noises, sampler_TextureArray_Noises, texCoord1556,0.0 );
				float smoothstepResult1563 = smoothstep( 0.0 , 0.25 , ( smoothstepResult1559 - tex2DArrayNode1582.r ));
				float _TopTex_NoiseHoles_Instance = UNITY_ACCESS_INSTANCED_PROP(EnvironmentObjectsShader,_TopTex_NoiseHoles);
				float lerpResult1595 = lerp( 0.0 , step( tex2DArrayNode1582.r , 0.34 ) , _TopTex_NoiseHoles_Instance);
				float temp_output_1565_0 = ( smoothstepResult1563 - lerpResult1595 );
				float clampResult1552 = clamp( temp_output_1565_0 , 0.0 , 1.0 );
				float4 TopTex1584 = ( ( triplanar1599 * dotResult1557 ) * clampResult1552 );
				float4 blendOpSrc1592 = lerpResult1468;
				float4 blendOpDest1592 = TopTex1584;
				float TopTexMask1606 = temp_output_1565_0;
				float4 lerpBlendMode1592 = lerp(blendOpDest1592,max( blendOpSrc1592, blendOpDest1592 ),( 1.0 - TopTexMask1606 ));
				float4 lerpResult1588 = lerp( lerpResult1468 , ( saturate( lerpBlendMode1592 )) , _TopTex);
				float4 tex2DArrayNode1715 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures, sampler_TextureArray_Textures, texCoord1622,2.0 );
				float Object_SpecularMask_Texture1455 = tex2DArrayNode1715.a;
				float temp_output_522_0 = ( ( 1.0 - Object_SpecularMask_Texture1455 ) * _Specular_Multiplier );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 normalizeResult4_g39 = normalize( ( ase_worldViewDir + SafeNormalize(_MainLightPosition.xyz) ) );
				float3 tanNormal498 = Object_Normal_Texture1454.rgb;
				float3 worldNormal498 = float3(dot(tanToWorld0,tanNormal498), dot(tanToWorld1,tanNormal498), dot(tanToWorld2,tanNormal498));
				float3 normalizeResult499 = normalize( worldNormal498 );
				float dotResult504 = dot( normalizeResult4_g39 , normalizeResult499 );
				float smoothstepResult632 = smoothstep( _SpeculartStepMin , _SpecularStepMax , max( dotResult504 , 0.0 ));
				float4 temp_cast_16 = (smoothstepResult632).xxxx;
				float2 temp_cast_17 = (_SpecularNoise).xx;
				float2 texCoord626 = IN.ase_texcoord5.xy * temp_cast_17 + float2( 0,0 );
				float grayscale634 = Luminance(step( ( temp_cast_16 - SAMPLE_TEXTURE2D_ARRAY( _TextureSample15, sampler_TextureSample15, texCoord626,1.0 ) ) , float4( 0,0,0,0 ) ).rgb);
				float4 Object_Specular_Texture1904 = tex2DArrayNode1715;
				float4 lerpResult1906 = lerp( _SpecularColor , Object_Specular_Texture1904 , _SpecularTexture);
				float4 Specular1585 = ( temp_output_522_0 * temp_output_522_0 * ( (0.0 + (grayscale634 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) * lerpResult1906 ) );
				float4 lerpResult1843 = lerp( lerpResult1588 , ( lerpResult1588 + Specular1585 ) , _Specular);
				float4 tex2DArrayNode1716 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures, sampler_TextureArray_Textures, texCoord1622,3.0 );
				float Object_RimLightMask_Texture1456 = tex2DArrayNode1716.a;
				float4 Object_RimLight_Texture1475 = tex2DArrayNode1716;
				float4 lerpResult1901 = lerp( _CustomRimLight_Color , Object_RimLight_Texture1475 , _CustomRimLight_Texture);
				float4 CustomRimLight1389 = ( ( Object_RimLightMask_Texture1456 * _CustomRimLight_Opacity ) * lerpResult1901 );
				float4 blendOpSrc1395 = lerpResult1843;
				float4 blendOpDest1395 = CustomRimLight1389;
				float4 lerpResult1397 = lerp( lerpResult1843 , ( saturate( max( blendOpSrc1395, blendOpDest1395 ) )) , _CustomRimLight);
				float temp_output_387_0 = ( _StepShadow + _StepAttenuation );
				float4 temp_cast_22 = (1.0).xxxx;
				float4 Object_Normal_Texture_UV22073 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Textures_UV2, sampler_TextureArray_Textures_UV2, texCoord2067,1.0 );
				float4 lerpResult2082 = lerp( temp_cast_22 , Object_Normal_Texture_UV22073 , Switch_UV_22074);
				float4 temp_output_2077_0 = ( Object_Normal_Texture1454 * lerpResult2082 );
				float3 tanNormal10 = temp_output_2077_0.rgb;
				float3 worldNormal10 = float3(dot(tanToWorld0,tanNormal10), dot(tanToWorld1,tanNormal10), dot(tanToWorld2,tanNormal10));
				float dotResult12 = dot( worldNormal10 , SafeNormalize(_MainLightPosition.xyz) );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir23 = ( dotResult12 * ase_lightAtten );
				float smoothstepResult385 = smoothstep( _StepShadow , temp_output_387_0 , normal_LightDir23);
				float2 temp_cast_24 = (_Noise_Tiling).xx;
				float2 texCoord565 = IN.ase_texcoord5.xy * temp_cast_24 + float2( 0,0 );
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
				float4 temp_cast_25 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest444) / max( blendOpSrc444, 0.00001) ) ) ))).xxxx;
				float4 blendOpSrc449 = temp_cast_25;
				float4 blendOpDest449 = _ShadowColor;
				float4 temp_output_449_0 = ( saturate( ( blendOpSrc449 * blendOpDest449 ) ));
				float4 Shadow877 = ( step( temp_output_449_0 , float4( 0,0,0,0 ) ) + temp_output_449_0 );
				float4 blendOpSrc428 = lerpResult1397;
				float4 blendOpDest428 = Shadow877;
				float4 EndOutBrume473 = ( saturate( ( blendOpSrc428 * blendOpDest428 ) ));
				float smoothstepResult1227 = smoothstep( ( _ShadowDrippingNoise_Step + _ShadowDrippingNoise_Smoothstep ) , _ShadowDrippingNoise_Step , normal_LightDir23);
				float2 temp_cast_26 = (_IB_Noise_Tiling).xx;
				float2 texCoord1943 = IN.ase_texcoord5.xy * temp_cast_26 + float2( 0,0 );
				float2 panner1930 = ( 1.0 * _Time.y * ( _IB_Noise_Panner + float2( 0.1,0.05 ) ) + texCoord1943);
				float2 panner1931 = ( 1.0 * _Time.y * _IB_Noise_Panner + texCoord1943);
				float blendOpSrc1932 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Noises, sampler_TextureArray_Noises, ( panner1930 + float2( 0.5,0.5 ) ),0.0 ).r;
				float blendOpDest1932 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Noises, sampler_TextureArray_Noises, panner1931,0.0 ).r;
				float MapNoise_IB1934 = ( saturate( 2.0f*blendOpDest1932*blendOpSrc1932 + blendOpDest1932*blendOpDest1932*(1.0f - 2.0f*blendOpSrc1932) ));
				float temp_output_1228_0 = ( smoothstepResult1227 - MapNoise_IB1934 );
				float temp_output_1950_0 = ( _ShadowDrippingNoise_Step - _ShadowDrippingNoise_SmoothstepAnimated );
				float smoothstepResult1951 = smoothstep( ( temp_output_1950_0 + _ShadowDrippingNoise_Smoothstep ) , temp_output_1950_0 , normal_LightDir23);
				float blendOpSrc1231 = temp_output_1228_0;
				float blendOpDest1231 = smoothstepResult1951;
				float lerpBlendMode1231 = lerp(blendOpDest1231,max( blendOpSrc1231, blendOpDest1231 ),( 1.0 - step( temp_output_1228_0 , 0.0 ) ));
				float ShadowDrippingNoise1240 = ( saturate( lerpBlendMode1231 ));
				float localStochasticTiling171_g41 = ( 0.0 );
				float2 temp_cast_27 = (_ShadowInBrumeGrunge_Tiling).xx;
				float2 texCoord1754 = IN.ase_texcoord5.xy * temp_cast_27 + float2( 0,0 );
				float2 Input_UV145_g41 = texCoord1754;
				float2 UV171_g41 = Input_UV145_g41;
				float2 UV1171_g41 = float2( 0,0 );
				float2 UV2171_g41 = float2( 0,0 );
				float2 UV3171_g41 = float2( 0,0 );
				float W1171_g41 = 0.0;
				float W2171_g41 = 0.0;
				float W3171_g41 = 0.0;
				StochasticTiling( UV171_g41 , UV1171_g41 , UV2171_g41 , UV3171_g41 , W1171_g41 , W2171_g41 , W3171_g41 );
				float Input_Index184_g41 = _Float29;
				float2 temp_output_172_0_g41 = ddx( Input_UV145_g41 );
				float2 temp_output_182_0_g41 = ddy( Input_UV145_g41 );
				float4 Output_2DArray294_g41 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1171_g41,Input_Index184_g41, temp_output_172_0_g41, temp_output_182_0_g41 ) * W1171_g41 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2171_g41,Input_Index184_g41, temp_output_172_0_g41, temp_output_182_0_g41 ) * W2171_g41 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3171_g41,Input_Index184_g41, temp_output_172_0_g41, temp_output_182_0_g41 ) * W3171_g41 ) );
				float grayscale1119 = Luminance(CalculateContrast(_ShadowInBrumeGrunge_Contrast,Output_2DArray294_g41).rgb);
				float ShadowInBrumeGrunge1246 = grayscale1119;
				float4 blendOpSrc1162 = ( _IB_BackColor * ( 1.0 - ShadowDrippingNoise1240 ) );
				float4 blendOpDest1162 = ( _IB_ColorShadow * ( ShadowDrippingNoise1240 * ShadowInBrumeGrunge1246 ) );
				float localStochasticTiling171_g38 = ( 0.0 );
				float2 temp_cast_29 = (_NormalInBrumeGrunge_Tiling).xx;
				float2 texCoord1755 = IN.ase_texcoord5.xy * temp_cast_29 + float2( 0,0 );
				float2 Input_UV145_g38 = texCoord1755;
				float2 UV171_g38 = Input_UV145_g38;
				float2 UV1171_g38 = float2( 0,0 );
				float2 UV2171_g38 = float2( 0,0 );
				float2 UV3171_g38 = float2( 0,0 );
				float W1171_g38 = 0.0;
				float W2171_g38 = 0.0;
				float W3171_g38 = 0.0;
				StochasticTiling( UV171_g38 , UV1171_g38 , UV2171_g38 , UV3171_g38 , W1171_g38 , W2171_g38 , W3171_g38 );
				float Input_Index184_g38 = _Float30;
				float2 temp_output_172_0_g38 = ddx( Input_UV145_g38 );
				float2 temp_output_182_0_g38 = ddy( Input_UV145_g38 );
				float4 Output_2DArray294_g38 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV1171_g38,Input_Index184_g38, temp_output_172_0_g38, temp_output_182_0_g38 ) * W1171_g38 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV2171_g38,Input_Index184_g38, temp_output_172_0_g38, temp_output_182_0_g38 ) * W2171_g38 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Grunges, sampler_TextureArray_Grunges, UV3171_g38,Input_Index184_g38, temp_output_172_0_g38, temp_output_182_0_g38 ) * W3171_g38 ) );
				float grayscale1115 = Luminance(CalculateContrast(_NormalInBrumeGrunge_Contrast,Output_2DArray294_g38).rgb);
				float NormalInBrumeGrunge1247 = grayscale1115;
				float grayscale1105 = (Object_Normal_Texture1454.rgb.r + Object_Normal_Texture1454.rgb.g + Object_Normal_Texture1454.rgb.b) / 3;
				float temp_output_1106_0 = step( grayscale1105 , _NormalDrippingNoise_Step );
				float smoothstepResult1179 = smoothstep( _NormalDrippingNoise_Step , ( _NormalDrippingNoise_Step + _NormalDrippingNoise_Smoothstep ) , grayscale1105);
				float4 temp_cast_32 = (( 1.0 - smoothstepResult1179 )).xxxx;
				float2 temp_cast_33 = (_NormalDrippingNoise_Tiling).xx;
				float2 texCoord1184 = IN.ase_texcoord5.xy * temp_cast_33 + _NormalDrippingNoise_Offset;
				float4 temp_output_1186_0 = ( temp_output_1106_0 + ( temp_cast_32 - SAMPLE_TEXTURE2D_ARRAY( _TextureArray_Noises, sampler_TextureArray_Noises, texCoord1184,2.0 ) ) );
				float4 temp_cast_34 = (( 1.0 - smoothstepResult1179 )).xxxx;
				float4 blendOpSrc1189 = ( NormalInBrumeGrunge1247 * temp_output_1186_0 );
				float4 blendOpDest1189 = ( 1.0 - temp_output_1186_0 );
				float4 lerpBlendMode1189 = lerp(blendOpDest1189,max( blendOpSrc1189, blendOpDest1189 ),temp_output_1106_0);
				float4 NormalDrippingGrunge1251 = ( saturate( lerpBlendMode1189 ));
				float temp_output_1979_0 = step( ShadowDrippingNoise1240 , 0.0 );
				float4 _IB_Edges_Mask_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(EnvironmentObjectsShader,_IB_Edges_Mask_ST);
				float2 uv_IB_Edges_Mask = IN.ase_texcoord5.xy * _IB_Edges_Mask_ST_Instance.xy + _IB_Edges_Mask_ST_Instance.zw;
				float4 tex2DNode1957 = tex2D( _IB_Edges_Mask, uv_IB_Edges_Mask );
				float4 IB_Edges1994 = (float4( 0,0,0,0 ) + (( ( temp_output_1979_0 * ( tex2DNode1957 + _Float38 ) ) + ( ( 1.0 - temp_output_1979_0 ) * ( tex2DNode1957 + _Float39 ) ) ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 )));
				float4 blendOpSrc1989 = ( max( blendOpSrc1162, blendOpDest1162 ) * NormalDrippingGrunge1251 );
				float4 blendOpDest1989 = IB_Edges1994;
				float4 EndInBrume901 = ( _InBrumeColorCorrection * (float4( 0,0,0,0 ) + (( saturate( ( blendOpSrc1989 * blendOpDest1989 ) )) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) );
				float4 temp_cast_35 = (worldY1344).xxxx;
				float4 temp_cast_36 = (TB_OFFSET_Y).xxxx;
				float4 TerrainBlending2034 = temp_output_1352_0;
				float localStochasticTiling216_g37 = ( 0.0 );
				float2 temp_output_104_0_g37 = _IB_TerrainBlendingNoise_Tiling;
				float3 temp_output_80_0_g37 = WorldPosition;
				float2 Triplanar_UV050_g37 = ( temp_output_104_0_g37 * (temp_output_80_0_g37).zy );
				float2 UV216_g37 = Triplanar_UV050_g37;
				float2 UV1216_g37 = float2( 0,0 );
				float2 UV2216_g37 = float2( 0,0 );
				float2 UV3216_g37 = float2( 0,0 );
				float W1216_g37 = 0.0;
				float W2216_g37 = 0.0;
				float W3216_g37 = 0.0;
				StochasticTiling( UV216_g37 , UV1216_g37 , UV2216_g37 , UV3216_g37 , W1216_g37 , W2216_g37 , W3216_g37 );
				float Input_Index184_g37 = 3.0;
				float2 temp_output_280_0_g37 = ddx( Triplanar_UV050_g37 );
				float2 temp_output_275_0_g37 = ddy( Triplanar_UV050_g37 );
				float localTriplanarWeights229_g37 = ( 0.0 );
				float3 WorldNormal229_g37 = ase_worldNormal;
				float W0229_g37 = 0.0;
				float W1229_g37 = 0.0;
				float W2229_g37 = 0.0;
				TriplanarWeights229_g37( WorldNormal229_g37 , W0229_g37 , W1229_g37 , W2229_g37 );
				float localStochasticTiling215_g37 = ( 0.0 );
				float2 Triplanar_UV164_g37 = ( temp_output_104_0_g37 * (temp_output_80_0_g37).zx );
				float2 UV215_g37 = Triplanar_UV164_g37;
				float2 UV1215_g37 = float2( 0,0 );
				float2 UV2215_g37 = float2( 0,0 );
				float2 UV3215_g37 = float2( 0,0 );
				float W1215_g37 = 0.0;
				float W2215_g37 = 0.0;
				float W3215_g37 = 0.0;
				StochasticTiling( UV215_g37 , UV1215_g37 , UV2215_g37 , UV3215_g37 , W1215_g37 , W2215_g37 , W3215_g37 );
				float2 temp_output_242_0_g37 = ddx( Triplanar_UV164_g37 );
				float2 temp_output_247_0_g37 = ddy( Triplanar_UV164_g37 );
				float localStochasticTiling201_g37 = ( 0.0 );
				float2 Triplanar_UV271_g37 = ( temp_output_104_0_g37 * (temp_output_80_0_g37).xy );
				float2 UV201_g37 = Triplanar_UV271_g37;
				float2 UV1201_g37 = float2( 0,0 );
				float2 UV2201_g37 = float2( 0,0 );
				float2 UV3201_g37 = float2( 0,0 );
				float W1201_g37 = 0.0;
				float W2201_g37 = 0.0;
				float W3201_g37 = 0.0;
				StochasticTiling( UV201_g37 , UV1201_g37 , UV2201_g37 , UV3201_g37 , W1201_g37 , W2201_g37 , W3201_g37 );
				float2 temp_output_214_0_g37 = ddx( Triplanar_UV271_g37 );
				float2 temp_output_258_0_g37 = ddy( Triplanar_UV271_g37 );
				float4 Output_TriplanarArray296_g37 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1216_g37,Input_Index184_g37, temp_output_280_0_g37, temp_output_275_0_g37 ) * W1216_g37 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2216_g37,Input_Index184_g37, temp_output_280_0_g37, temp_output_275_0_g37 ) * W2216_g37 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3216_g37,Input_Index184_g37, temp_output_280_0_g37, temp_output_275_0_g37 ) * W3216_g37 ) ) * W0229_g37 ) + ( W1229_g37 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1215_g37,Input_Index184_g37, temp_output_242_0_g37, temp_output_247_0_g37 ) * W1215_g37 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2215_g37,Input_Index184_g37, temp_output_242_0_g37, temp_output_247_0_g37 ) * W2215_g37 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3215_g37,Input_Index184_g37, temp_output_242_0_g37, temp_output_247_0_g37 ) * W3215_g37 ) ) ) + ( W2229_g37 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV1201_g37,Input_Index184_g37, temp_output_214_0_g37, temp_output_258_0_g37 ) * W1201_g37 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV2201_g37,Input_Index184_g37, temp_output_214_0_g37, temp_output_258_0_g37 ) * W2201_g37 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TextureArray_Noises, sampler_TextureArray_Noises, UV3201_g37,Input_Index184_g37, temp_output_214_0_g37, temp_output_258_0_g37 ) * W3201_g37 ) ) ) );
				float4 clampResult2044 = clamp( ( TerrainBlending2034 / ( _IB_TerrainBlending_BlendThickness * Output_TriplanarArray296_g37 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_37 = (_IB_TerrainBlending_Falloff).xxxx;
				float4 clampResult2046 = clamp( pow( clampResult2044 , temp_cast_37 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 lerpResult2049 = lerp( _IB_TerrainBlending_Color , EndInBrume901 , clampResult2046.r);
				float4 FinalInBrume2052 = lerpResult2049;
				float4 lerpResult955 = lerp( EndOutBrume473 , FinalInBrume2052 , _Out_or_InBrume);
				float4 temp_cast_38 = (normal_LightDir23).xxxx;
				float4 lerpResult1403 = lerp( lerpResult955 , temp_cast_38 , _LightDebug);
				float4 lerpResult1405 = lerp( lerpResult1403 , Object_Normal_Texture1454 , _NormalDebug);
				
				float TerrainBlendingMask1761 = clampResult1356.r;
				float clampResult1771 = clamp( ( TerrainBlendingMask1761 + _TerrainBlending_Opacity ) , 0.0 , 1.0 );
				float Object_Opacity_Texture1457 = tex2DArrayNode1711.a;
				float lerpResult1472 = lerp( Object_Opacity_Texture1457 , 0.0 , _CustomOpacityMask);
				float lerpResult1416 = lerp( 1.0 , ( clampResult1771 * lerpResult1472 ) , _Opacity);
				float eyeDepth = IN.ase_texcoord4.w;
				float cameraDepthFade1534 = (( eyeDepth -_ProjectionParams.y - _DepthFade_Distance ) / _DepthFade_Falloff);
				float localStochasticTiling2_g28 = ( 0.0 );
				float2 Input_UV145_g28 = ( (ase_screenPosNorm).xy * _DepthFade_Dither_Tiling );
				float2 UV2_g28 = Input_UV145_g28;
				float2 UV12_g28 = float2( 0,0 );
				float2 UV22_g28 = float2( 0,0 );
				float2 UV32_g28 = float2( 0,0 );
				float W12_g28 = 0.0;
				float W22_g28 = 0.0;
				float W32_g28 = 0.0;
				StochasticTiling( UV2_g28 , UV12_g28 , UV22_g28 , UV32_g28 , W12_g28 , W22_g28 , W32_g28 );
				float2 temp_output_10_0_g28 = ddx( Input_UV145_g28 );
				float2 temp_output_12_0_g28 = ddy( Input_UV145_g28 );
				float4 Output_2D293_g28 = ( ( tex2D( _DepthFade_Dither_Texture, UV12_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W12_g28 ) + ( tex2D( _DepthFade_Dither_Texture, UV22_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W22_g28 ) + ( tex2D( _DepthFade_Dither_Texture, UV32_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W32_g28 ) );
				float4 break31_g28 = Output_2D293_g28;
				float lerpResult1542 = lerp( 0.0 , break31_g28.r , _DepthFade_Texture);
				float clampResult1523 = clamp( cameraDepthFade1534 , ( ( lerpResult1542 * _DepthFade_DitherMultiply ) + _DepthFade_ClampMin ) , _DepthFade_ClampMax );
				float DepthFade1837 = clampResult1523;
				float lerpResult1540 = lerp( 1.0 , DepthFade1837 , _DepthFade);
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
			float4 _CustomRimLight_Color;
			float4 _ShadowColor;
			float4 _IB_TerrainBlending_Color;
			float4 _InBrumeColorCorrection;
			float4 _IB_BackColor;
			float4 _SpecularColor;
			float4 _IB_ColorShadow;
			float4 _TerrainBlending_Color;
			float4 _OutBrume_UV2_ColorCorrection;
			float4 _OutBrumeColorCorrection;
			float2 _IB_Noise_Panner;
			float2 _TopTex_NoiseOffset;
			float2 _TopTex_Tiling;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _NormalDrippingNoise_Offset;
			float2 _Noise_Panner;
			float2 _WindWave_Speed;
			float2 _WindWave_Min_Speed;
			float2 _IB_TerrainBlendingNoise_Tiling;
			float _IB_TerrainBlending_BlendThickness;
			float _ScreenBasedNoise;
			float _DepthFade_ClampMin;
			float _DepthFade_DitherMultiply;
			float _ShadowDrippingNoise_Step;
			float _DepthFade_Texture;
			float _ShadowDrippingNoise_Smoothstep;
			float _DepthFade_Dither_Tiling;
			float _IB_Noise_Tiling;
			float _ShadowDrippingNoise_SmoothstepAnimated;
			float _DepthFade_Distance;
			float _DepthFade_Falloff;
			float _ShadowInBrumeGrunge_Contrast;
			float _ShadowInBrumeGrunge_Tiling;
			float _Opacity;
			float _NormalInBrumeGrunge_Contrast;
			float _NormalInBrumeGrunge_Tiling;
			float _CustomOpacityMask;
			float _Float30;
			float _TerrainBlending_Opacity;
			float _Noise_Tiling;
			float _NormalDrippingNoise_Smoothstep;
			float _NormalDrippingNoise_Tiling;
			float _NormalDebug;
			float _LightDebug;
			float _IB_TerrainBlending_Falloff;
			float _Float38;
			float _Float39;
			float _Float29;
			float _NormalDrippingNoise_Step;
			float _Wind_Texture_Tiling;
			float _StepShadow;
			float _PaintGrunge_Multiply;
			float _PaintGrunge_Tiling;
			float _PaintGrunge_Contrast;
			float _AnimatedGrunge;
			float _AnimatedGrungeMultiply;
			float _IsGrungeAnimated;
			float _AnimatedGrunge_Flipbook_Speed;
			float _PaintGrunge;
			float _AnimatedGrunge_Flipbook_Rows;
			float _AnimatedGrunge_Tiling;
			float _Out_or_InBrume;
			float _WindVertexDisplacement;
			float _Wind_Strength;
			float _Wind_Density;
			float _Wind_Direction;
			float _Wave_Speed;
			float _AnimatedGrunge_Flipbook_Columns;
			float _UV_2_;
			float _DebugGrayscale;
			float _TerrainBlending_TextureTiling;
			float _CustomRimLight;
			float _CustomRimLight_Texture;
			float _DepthFade_ClampMax;
			float _CustomRimLight_Opacity;
			float _Specular;
			float _SpecularTexture;
			float _SpecularNoise;
			float _SpecularStepMax;
			float _SpeculartStepMin;
			float _Specular_Multiplier;
			float _TopTex;
			float _TopTex_NoiseTiling;
			float _TopTex_Smoothstep;
			float _TopTex_Step;
			float _TerrainBlending;
			float _TerrainBlending_Falloff;
			float _TerrainBlending_BlendThickness;
			float _StepAttenuation;
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
			sampler2D _DepthFade_Dither_Texture;
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
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

				float4 temp_cast_0 = (0.0).xxxx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _Wave_Speed ) * _WindWave_Speed + float2( 0,0 ));
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + float2( 0,0 ));
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( ( panner1312 + panner1313 ) * _Wind_Direction );
				float4 temp_cast_2 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_3 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( ( SAMPLE_TEXTURE2D_ARRAY_LOD( _TextureArray_Noises, sampler_TextureArray_Noises, texCoord1319,1.0, 0.0 ) - temp_cast_2 ) * _Wind_Strength ) + float4( 0,0,0,0 ) ) , temp_cast_3 , v.ase_color);
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
				float eyeDepth = IN.ase_texcoord2.w;
				float cameraDepthFade1534 = (( eyeDepth -_ProjectionParams.y - _DepthFade_Distance ) / _DepthFade_Falloff);
				float localStochasticTiling2_g28 = ( 0.0 );
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 Input_UV145_g28 = ( (ase_screenPosNorm).xy * _DepthFade_Dither_Tiling );
				float2 UV2_g28 = Input_UV145_g28;
				float2 UV12_g28 = float2( 0,0 );
				float2 UV22_g28 = float2( 0,0 );
				float2 UV32_g28 = float2( 0,0 );
				float W12_g28 = 0.0;
				float W22_g28 = 0.0;
				float W32_g28 = 0.0;
				StochasticTiling( UV2_g28 , UV12_g28 , UV22_g28 , UV32_g28 , W12_g28 , W22_g28 , W32_g28 );
				float2 temp_output_10_0_g28 = ddx( Input_UV145_g28 );
				float2 temp_output_12_0_g28 = ddy( Input_UV145_g28 );
				float4 Output_2D293_g28 = ( ( tex2D( _DepthFade_Dither_Texture, UV12_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W12_g28 ) + ( tex2D( _DepthFade_Dither_Texture, UV22_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W22_g28 ) + ( tex2D( _DepthFade_Dither_Texture, UV32_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W32_g28 ) );
				float4 break31_g28 = Output_2D293_g28;
				float lerpResult1542 = lerp( 0.0 , break31_g28.r , _DepthFade_Texture);
				float clampResult1523 = clamp( cameraDepthFade1534 , ( ( lerpResult1542 * _DepthFade_DitherMultiply ) + _DepthFade_ClampMin ) , _DepthFade_ClampMax );
				float DepthFade1837 = clampResult1523;
				float lerpResult1540 = lerp( 1.0 , DepthFade1837 , _DepthFade);
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
			float4 _CustomRimLight_Color;
			float4 _ShadowColor;
			float4 _IB_TerrainBlending_Color;
			float4 _InBrumeColorCorrection;
			float4 _IB_BackColor;
			float4 _SpecularColor;
			float4 _IB_ColorShadow;
			float4 _TerrainBlending_Color;
			float4 _OutBrume_UV2_ColorCorrection;
			float4 _OutBrumeColorCorrection;
			float2 _IB_Noise_Panner;
			float2 _TopTex_NoiseOffset;
			float2 _TopTex_Tiling;
			float2 _TerrainBlendingNoise_Tiling;
			float2 _NormalDrippingNoise_Offset;
			float2 _Noise_Panner;
			float2 _WindWave_Speed;
			float2 _WindWave_Min_Speed;
			float2 _IB_TerrainBlendingNoise_Tiling;
			float _IB_TerrainBlending_BlendThickness;
			float _ScreenBasedNoise;
			float _DepthFade_ClampMin;
			float _DepthFade_DitherMultiply;
			float _ShadowDrippingNoise_Step;
			float _DepthFade_Texture;
			float _ShadowDrippingNoise_Smoothstep;
			float _DepthFade_Dither_Tiling;
			float _IB_Noise_Tiling;
			float _ShadowDrippingNoise_SmoothstepAnimated;
			float _DepthFade_Distance;
			float _DepthFade_Falloff;
			float _ShadowInBrumeGrunge_Contrast;
			float _ShadowInBrumeGrunge_Tiling;
			float _Opacity;
			float _NormalInBrumeGrunge_Contrast;
			float _NormalInBrumeGrunge_Tiling;
			float _CustomOpacityMask;
			float _Float30;
			float _TerrainBlending_Opacity;
			float _Noise_Tiling;
			float _NormalDrippingNoise_Smoothstep;
			float _NormalDrippingNoise_Tiling;
			float _NormalDebug;
			float _LightDebug;
			float _IB_TerrainBlending_Falloff;
			float _Float38;
			float _Float39;
			float _Float29;
			float _NormalDrippingNoise_Step;
			float _Wind_Texture_Tiling;
			float _StepShadow;
			float _PaintGrunge_Multiply;
			float _PaintGrunge_Tiling;
			float _PaintGrunge_Contrast;
			float _AnimatedGrunge;
			float _AnimatedGrungeMultiply;
			float _IsGrungeAnimated;
			float _AnimatedGrunge_Flipbook_Speed;
			float _PaintGrunge;
			float _AnimatedGrunge_Flipbook_Rows;
			float _AnimatedGrunge_Tiling;
			float _Out_or_InBrume;
			float _WindVertexDisplacement;
			float _Wind_Strength;
			float _Wind_Density;
			float _Wind_Direction;
			float _Wave_Speed;
			float _AnimatedGrunge_Flipbook_Columns;
			float _UV_2_;
			float _DebugGrayscale;
			float _TerrainBlending_TextureTiling;
			float _CustomRimLight;
			float _CustomRimLight_Texture;
			float _DepthFade_ClampMax;
			float _CustomRimLight_Opacity;
			float _Specular;
			float _SpecularTexture;
			float _SpecularNoise;
			float _SpecularStepMax;
			float _SpeculartStepMin;
			float _Specular_Multiplier;
			float _TopTex;
			float _TopTex_NoiseTiling;
			float _TopTex_Smoothstep;
			float _TopTex_Step;
			float _TerrainBlending;
			float _TerrainBlending_Falloff;
			float _TerrainBlending_BlendThickness;
			float _StepAttenuation;
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
			sampler2D _DepthFade_Dither_Texture;
			UNITY_INSTANCING_BUFFER_START(EnvironmentObjectsShader)
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

				float4 temp_cast_0 = (0.0).xxxx;
				float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
				float2 panner1312 = ( ( ( _TimeParameters.z + _TimeParameters.x ) * _Wave_Speed ) * _WindWave_Speed + float2( 0,0 ));
				float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + float2( 0,0 ));
				float2 texCoord1319 = v.ase_texcoord.xy * temp_cast_1 + ( ( panner1312 + panner1313 ) * _Wind_Direction );
				float4 temp_cast_2 = (( _Wind_Density * _TimeParameters.y )).xxxx;
				float4 temp_cast_3 = (0.0).xxxx;
				float4 lerpResult1328 = lerp( ( ( ( SAMPLE_TEXTURE2D_ARRAY_LOD( _TextureArray_Noises, sampler_TextureArray_Noises, texCoord1319,1.0, 0.0 ) - temp_cast_2 ) * _Wind_Strength ) + float4( 0,0,0,0 ) ) , temp_cast_3 , v.ase_color);
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
				float eyeDepth = IN.ase_texcoord2.w;
				float cameraDepthFade1534 = (( eyeDepth -_ProjectionParams.y - _DepthFade_Distance ) / _DepthFade_Falloff);
				float localStochasticTiling2_g28 = ( 0.0 );
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 Input_UV145_g28 = ( (ase_screenPosNorm).xy * _DepthFade_Dither_Tiling );
				float2 UV2_g28 = Input_UV145_g28;
				float2 UV12_g28 = float2( 0,0 );
				float2 UV22_g28 = float2( 0,0 );
				float2 UV32_g28 = float2( 0,0 );
				float W12_g28 = 0.0;
				float W22_g28 = 0.0;
				float W32_g28 = 0.0;
				StochasticTiling( UV2_g28 , UV12_g28 , UV22_g28 , UV32_g28 , W12_g28 , W22_g28 , W32_g28 );
				float2 temp_output_10_0_g28 = ddx( Input_UV145_g28 );
				float2 temp_output_12_0_g28 = ddy( Input_UV145_g28 );
				float4 Output_2D293_g28 = ( ( tex2D( _DepthFade_Dither_Texture, UV12_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W12_g28 ) + ( tex2D( _DepthFade_Dither_Texture, UV22_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W22_g28 ) + ( tex2D( _DepthFade_Dither_Texture, UV32_g28, temp_output_10_0_g28, temp_output_12_0_g28 ) * W32_g28 ) );
				float4 break31_g28 = Output_2D293_g28;
				float lerpResult1542 = lerp( 0.0 , break31_g28.r , _DepthFade_Texture);
				float clampResult1523 = clamp( cameraDepthFade1534 , ( ( lerpResult1542 * _DepthFade_DitherMultiply ) + _DepthFade_ClampMin ) , _DepthFade_ClampMax );
				float DepthFade1837 = clampResult1523;
				float lerpResult1540 = lerp( 1.0 , DepthFade1837 , _DepthFade);
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
1920;0;1920;1019;9310.687;5265.45;6.141069;True;False
Node;AmplifyShaderEditor.CommentaryNode;824;-6976.179,-4815.77;Inherit;False;8623.517;4437.728;OUT BRUME;5;1841;1842;1847;2087;1827;;1,0.7827643,0.5518868,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1841;-3082.261,-4738.333;Inherit;False;4647.981;4294.936;Additional;4;520;1396;1587;1371;;0.3679245,0.3679245,0.3679245,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1371;-3030.162,-3648.377;Inherit;False;3849.702;1403.809;TerrainBlending;39;1368;1367;1365;1364;1363;1361;1359;1358;1357;1356;1355;1354;1353;1352;1351;1350;1349;1348;1347;1346;1345;1344;1343;1342;1341;1340;1339;1338;1337;1336;1373;1374;1759;1760;1761;1897;1898;1899;2034;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1338;-2988.035,-3204.155;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1337;-2983.818,-2971.139;Inherit;False;Global;TB_OFFSET_Z;TB_OFFSET_Z;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1336;-2986.384,-3049.415;Inherit;False;Global;TB_OFFSET_X;TB_OFFSET_X;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;1340;-2643.766,-3107.159;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1339;-2643.766,-2976.272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1893;-8428.657,-4820.025;Inherit;False;1382.467;3810.296;TEXTURE ARRAYS;4;1819;1807;1883;2064;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1342;-2406.372,-3069.946;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1341;-2390.973,-2958.307;Inherit;False;Global;TB_SCALE;TB_SCALE;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1883;-8358.195,-2119.701;Inherit;False;1270.378;1049.881;Noises;18;1878;1877;1872;1894;1873;1895;1896;1871;1876;1874;1882;1880;1875;1879;1881;1908;1909;1910;;0,0,0,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;1881;-8308.195,-2069.533;Inherit;True;Property;_TextureArray_Noises;TextureArray_Noises;10;0;Create;True;0;0;False;0;False;668ed38e9d9e517458c599bfa078a81c;829b1744df5e7e1438fda8b5bb926ccc;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleDivideOpNode;1343;-2152.296,-3069.946;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1346;-1940.28,-3136.072;Inherit;True;Global;TB_DEPTH;TB_DEPTH;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1879;-8020.207,-2069.533;Inherit;False;Noise;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1345;-1835.833,-2934.506;Inherit;False;Global;TB_FARCLIP;TB_FARCLIP;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1892;-6968.941,-316.0907;Inherit;False;3703.017;4167.293;OTHER VARIABLES;6;521;31;1381;1536;1335;2089;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1344;-2666.865,-3208.533;Inherit;False;worldY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1361;-1743.644,-2394.001;Inherit;False;Property;_TerrainBlendingNoise_Tiling;TerrainBlendingNoise_Tiling;12;0;Create;True;0;0;False;0;False;1,1;0.3,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;1348;-1561.601,-3125.864;Inherit;False;1344;worldY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1347;-1581.189,-3003.817;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1335;-6918.941,1470.624;Inherit;False;3603.017;815.9397;VertexColor WindDisplacement;28;1305;1306;1308;1307;1311;1310;1309;1312;1313;1315;1314;1317;1316;1319;1318;1321;1323;1322;1325;1324;1326;1329;1327;1328;1304;1330;1886;1887;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1359;-1870.742,-2553.291;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1898;-1863.74,-2723.639;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1899;-1834.37,-2636.724;Inherit;False;Constant;_Float32;Float 32;95;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;1305;-6851.293,1625.034;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;1306;-6868.941,1826.904;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1897;-1346.706,-2609.446;Inherit;False;Procedural Sample;-1;;27;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1363;-1346.667,-2804.818;Inherit;False;Property;_TerrainBlending_BlendThickness;TerrainBlending_BlendThickness;44;0;Create;True;0;0;False;0;False;0;2;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1349;-1317.506,-2932.999;Inherit;False;Global;TB_OFFSET_Y;TB_OFFSET_Y;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1350;-1332.574,-3050.526;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1351;-996.277,-2759.795;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1308;-6443.001,1867.333;Inherit;False;Property;_Wave_Speed;Wave_Speed;83;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1307;-6688.941,1775.904;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1536;-6915.553,2315.731;Inherit;False;2198.199;655.8777;DepthFade;19;1837;1523;1534;1535;1545;1530;1533;1532;1546;1542;1528;1544;1543;1529;1527;1531;1526;1525;1524;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1352;-1163.817,-3053.539;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;1311;-6363.136,1634.75;Inherit;False;Property;_WindWave_Speed;WindWave_Speed;81;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;1310;-6461.612,2122.564;Inherit;False;Property;_WindWave_Min_Speed;WindWave_Min_Speed;82;0;Create;True;0;0;False;0;False;0.05,0;0.05,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1309;-6251.954,1789.808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1353;-763.1694,-3054.998;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1524;-6864.506,2679.696;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;1312;-6105.342,1615.623;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1364;-658.3721,-3226.122;Inherit;False;Property;_TerrainBlending_Falloff;TerrainBlending_Falloff;48;0;Create;True;0;0;False;0;False;0;30;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1354;-565.5151,-3052.345;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1526;-6672.505,2759.696;Inherit;False;Property;_DepthFade_Dither_Tiling;DepthFade_Dither_Tiling;87;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;1313;-6204.996,2104.448;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;1525;-6656.505,2679.696;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1314;-5838.475,2014.085;Inherit;False;Property;_Wind_Direction;Wind_Direction;78;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1531;-6536.318,2380.922;Inherit;True;Property;_DepthFade_Dither_Texture;DepthFade_Dither_Texture;86;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;1315;-5859.601,1888.665;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1527;-6432.502,2679.696;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1807;-8366.72,-4746.004;Inherit;False;1248.823;848.4091;Textures;18;1475;1456;1712;1719;1453;1455;1716;1454;1720;1721;1715;1457;1711;1806;1718;1804;1622;1904;;0,0,0,1;0;0
Node;AmplifyShaderEditor.PowerNode;1355;-333.371,-3054.998;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1529;-6251.318,2651.923;Inherit;False;Procedural Sample;-1;;28;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TexturePropertyNode;1804;-8316.72,-4695.836;Inherit;True;Property;_TextureArray_Textures;TextureArray_Textures;8;0;Create;True;0;0;False;1;Header(Textures Arrays);False;668ed38e9d9e517458c599bfa078a81c;bab7337c8018c7042ada8f6325405b49;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;1316;-5762.092,1729.636;Inherit;False;Property;_Wind_Texture_Tiling;Wind_Texture_Tiling;77;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1317;-5649.473,1897.084;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1543;-6216.754,2873.202;Inherit;False;Property;_DepthFade_Texture;DepthFade_Texture?;85;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1356;-141.9435,-3056.455;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1544;-6179.754,2510.201;Inherit;False;Constant;_Float26;Float 26;86;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1321;-5181.738,1931.489;Inherit;False;Property;_Wind_Density;Wind_Density;79;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1886;-5457.485,1587.285;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;1542;-5965.754,2656.202;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1887;-5423.466,1879.053;Inherit;False;Constant;_Float2;Float 2;98;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1622;-8263.499,-4487.964;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1319;-5524.393,1742.846;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;1357;52.6738,-3055.65;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;1528;-5801.963,2739.712;Inherit;False;Property;_DepthFade_DitherMultiply;DepthFade_DitherMultiply;88;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1718;-8214.359,-4350.124;Inherit;False;Constant;_Float7;Float 7;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1806;-8028.733,-4695.836;Inherit;False;Texture;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SinTimeNode;1318;-5150.561,2023.848;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1546;-5525.214,2786.202;Inherit;False;Property;_DepthFade_ClampMin;DepthFade_ClampMin;91;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1323;-5236.646,1710.625;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1532;-5800.043,2462.175;Inherit;False;Property;_DepthFade_Falloff;DepthFade_Falloff;89;0;Create;True;0;0;False;0;False;3;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1530;-5560.963,2657.712;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1761;357.6356,-2915.843;Inherit;False;TerrainBlendingMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1381;-6912.686,3000.941;Inherit;False;2464.586;725.3411;Opacity;18;1900;1375;1548;1416;1540;1838;1428;1539;1772;1417;1538;1472;1771;1467;1770;1477;1767;1765;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1533;-5807.043,2544.175;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;90;0;Create;True;0;0;False;0;False;10.5;10.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1711;-7803.795,-4696.004;Inherit;True;Property;_TA_Textures;TA_Textures;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1322;-4982.146,1986.692;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CameraDepthFade;1534;-5529.042,2462.175;Inherit;False;3;2;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1535;-5525.478,2870.694;Inherit;False;Property;_DepthFade_ClampMax;DepthFade_ClampMax;92;0;Create;True;0;0;False;0;False;0.8;0.8;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1325;-4773.587,1718.494;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1765;-6478.662,3059.163;Inherit;False;1761;TerrainBlendingMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1457;-7407.821,-4599.417;Inherit;False;Object_Opacity_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1767;-6483.532,3140.38;Inherit;False;Property;_TerrainBlending_Opacity;TerrainBlending_Opacity;42;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1324;-4570.495,1787.012;Inherit;False;Property;_Wind_Strength;Wind_Strength;80;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1545;-5283.215,2658.202;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1477;-6863.418,3431.601;Inherit;False;Property;_CustomOpacityMask;CustomOpacityMask?;6;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1523;-5126.876,2650.794;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1467;-6767.192,3124.499;Inherit;True;1457;Object_Opacity_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1326;-4395.498,1719.012;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1770;-6162.665,3109.529;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1900;-6730.646,3320.57;Inherit;False;Constant;_Float33;Float 33;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1472;-6497.132,3253.907;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1327;-4134.367,1718.962;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;1304;-4093.427,1986.032;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1329;-4090.079,1574.417;Inherit;False;Constant;_Float1;Float 1;67;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1771;-6035.156,3109.927;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1837;-4921.327,2640.266;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1328;-3828.329,1613.237;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1417;-5675.697,3348.917;Inherit;False;Property;_Opacity;Opacity?;5;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1539;-5339.862,3386.232;Inherit;False;Constant;_Float25;Float 25;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1838;-5118.327,3639.28;Inherit;False;1837;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1428;-5587.115,3114.011;Inherit;False;Constant;_Float6;Float 6;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1772;-5811.092,3221.785;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1538;-5423.442,3479.138;Inherit;False;Property;_DepthFade;DepthFade?;84;0;Create;True;0;0;False;1;Header(Depth Fade);False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1416;-5334.23,3211.386;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1842;-6899.22,-4739.434;Inherit;False;3767.544;3684.208;Essential;2;471;1840;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;845;-8584.028,-901.8619;Inherit;False;1548.594;1019.987;FinalPass;19;1405;582;955;1464;1406;1376;1404;1403;844;474;1609;954;1611;1407;1408;1331;1334;2060;2059;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;1540;-5060.979,3390.607;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1330;-3597.926,1603.123;Inherit;False;WindVertexDisplacement;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1548;-4848.68,3301.51;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1334;-8334.503,-170.3791;Inherit;False;Constant;_Float4;Float 4;68;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1331;-8450.116,-78.56088;Inherit;False;1330;WindVertexDisplacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1408;-8448.458,9.939123;Inherit;False;Property;_WindVertexDisplacement;WindVertexDisplacement?;76;0;Create;True;0;0;False;1;Header(Wind);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1254;2870.999,-4814.001;Inherit;False;6772.289;4431.814;IN BRUME;41;1252;1989;1241;1242;1050;1014;1161;1049;988;1158;1162;1118;989;1248;1223;1256;901;1255;1253;1243;1250;1993;1995;2035;2039;2041;2036;2037;2038;2040;2042;2043;2044;2045;2046;2047;2048;2049;2050;2051;2052;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1840;-6861.474,-4689.434;Inherit;False;3675.997;2452.021;RGB;5;461;530;1366;1826;1830;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-6305.261,-258.014;Inherit;False;2013.652;530.9265;Normal Light Dir;9;710;12;23;711;10;11;1458;2077;2091;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2087;-6804.53,-2808.667;Inherit;False;1291.285;412.4309;UV2 Albedo;6;2080;2081;2079;2086;2085;2088;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1847;-6890.674,-1009.971;Inherit;False;3393.6;552.7587;FinalPass_OutBrume;21;1400;1394;1395;1402;1586;518;1843;1397;428;1369;473;1588;1471;1469;1370;1468;1590;1607;1608;1591;1592;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1819;-8358.115,-2993.659;Inherit;False;1241.837;843.8696;Grunges;15;1823;1815;1808;1818;1811;1810;1814;1813;1812;1820;1821;1822;1816;1809;1817;;0,0,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1611;-8068.515,-236.2581;Inherit;False;Constant;_Float10;Float 10;98;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1993;5729.438,-3164.017;Inherit;False;2271.157;937.1863;Edges;14;1976;1991;1981;1992;1966;1985;1957;1984;1979;1980;1977;1983;1990;1994;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;954;-8533.718,-658.6777;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;1;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1407;-8125.699,-98.57748;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1396;567.6714,-4685.668;Inherit;False;938.298;801.8033;CustomRimLight;9;1902;1903;1901;1393;1389;1392;1390;1391;1461;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2064;-8365.772,-3867.355;Inherit;False;1248.823;848.4091;Textures UV2;9;2065;2066;2067;2068;2069;2070;2071;2072;2073;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1830;-6820.089,-4625.089;Inherit;False;2709.934;703.4277;AnimatedGrunge;21;525;526;1829;1828;455;1492;1491;1412;667;666;665;463;465;670;466;464;664;1411;1834;1835;1836;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;2089;-6912.397,-253.2326;Inherit;False;585.5757;438.8629;UV2 Normal;4;2090;2082;2084;2076;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;471;-6862.793,-2195.719;Inherit;False;3565.746;1090.681;Shadow Smooth Edge + Int Shadow;19;877;563;562;449;444;450;401;445;447;397;470;446;448;482;385;387;469;386;388;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1375;-4654.17,3295.776;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;521;-6913.75,840.162;Inherit;False;2700.771;602.1591;Noise;20;481;570;1495;1493;1496;1494;573;484;571;572;1413;477;565;487;1414;480;479;478;1884;1885;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1826;-6811.228,-3901.076;Inherit;False;2278.282;581.4458;PaintGrunge;13;1824;1497;1825;1382;1728;1727;1726;1725;1748;1385;1831;1833;1832;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1253;2913.764,-3804.49;Inherit;False;2694.904;611.5192;InBrumeGrunge;18;1247;1246;1889;1891;1752;1113;1116;1114;1754;1755;1117;1750;1119;1749;1888;1890;1115;1751;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1243;2912.911,-4758.986;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;15;1240;1231;1233;1232;1228;1227;1225;1235;1230;1165;1949;1950;1951;1953;1954;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;520;-3028.572,-4688.333;Inherit;False;3545.176;1011.814;Specular;30;1585;623;498;506;639;1500;619;500;522;1615;1462;1459;627;636;634;640;523;630;1501;508;499;509;632;633;512;504;626;1905;1906;1907;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1925;-2539.975,-214.8084;Inherit;False;2085.438;600.3704;Noise_IB;15;1936;1943;1934;1941;1940;1939;1937;1935;1933;1932;1931;1930;1929;1928;1927;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1587;-3032.261,-2205.532;Inherit;False;3162.162;1702.81;TopTex;30;1565;1581;1599;1600;1604;1555;1557;1598;1554;1566;1567;1556;1560;1553;1606;1584;1561;1569;1595;1558;1562;1552;1594;1559;1596;1568;1582;1564;1563;1911;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1250;2908.454,-3163.575;Inherit;False;2793.385;902.8672;NormalDrippingGrunge;20;1519;1465;1105;1184;1191;1249;1180;1186;1179;1181;1187;1188;1518;1106;1182;1251;1189;1108;1111;1193;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1827;-6808.778,-3284.59;Inherit;False;2046.31;441.7513;Albedo;7;2078;1613;1612;1614;841;842;1697;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;1358;366.9327,-3195.233;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1976;6156.093,-2846.267;Inherit;True;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1365;-1008.31,-3592.572;Inherit;True;Property;_TerrainBlending_TextureTerrain;TerrainBlending_TextureTerrain;40;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1889;2984.563,-3675.234;Inherit;False;Property;_Float29;Float 29;94;0;Create;True;0;0;False;0;False;2;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1754;3323.768,-3664.555;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;1979;6401.057,-2841.442;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1193;3406.801,-2435.374;Inherit;False;Property;_NormalDrippingNoise_Offset;NormalDrippingNoise_Offset;70;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCGrayscale;1115;4450.654,-3468.736;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-6318.792,-2131.719;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;632;-1998.641,-4605.529;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1181;3469.198,-2746.39;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1557;-2344.849,-1578.553;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;626;-2305.461,-3968.334;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1720;-8211.359,-4193.125;Inherit;False;Constant;_Float35;Float 35;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1834;-4268.863,-4232.739;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1500;-2232.682,-3809.684;Inherit;False;Constant;_Float19;Float 19;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1114;3881.005,-3369.197;Inherit;False;Property;_NormalInBrumeGrunge_Contrast;NormalInBrumeGrunge_Contrast;74;0;Create;True;0;0;False;0;False;2.4;-6.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;627;-2486.461,-3950.335;Inherit;False;Property;_SpecularNoise;SpecularNoise;36;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1111;4842.859,-3060.074;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1248;6201.917,-3824.511;Inherit;False;1246;ShadowInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1596;-1352.802,-852.836;Inherit;False;Constant;_Float15;Float 15;96;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-6398.792,-1875.719;Inherit;False;Property;_StepAttenuation;StepAttenuation;30;0;Create;True;0;0;False;0;False;0.3;-0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;988;6735.806,-4091.98;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.3;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1592;-6098.253,-811.1281;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1559;-1941.166,-1343.081;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.33;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;633;-2334.642,-4509.528;Inherit;False;Property;_SpecularStepMax;SpecularStepMax;35;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1594;-1481.803,-661.8361;Inherit;False;InstancedProperty;_TopTex_NoiseHoles;TopTex_NoiseHoles?;52;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1558;-2107.429,-1130.732;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1749;3575.593,-3751.417;Inherit;False;Procedural Sample;-1;;41;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.DotProductOpNode;504;-2365.152,-4310.391;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1991;6592.833,-2473.831;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1581;-999.7497,-1602.048;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1240;4932.41,-4592.381;Inherit;False;ShadowDrippingNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1831;-4770.637,-3726.773;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1977;6939.192,-2982.847;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;640;-1464.681,-4114.333;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1158;6505.823,-4370.454;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1905;-786.4066,-3872.39;Inherit;False;1904;Object_Specular_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;1552;-580.0522,-1321.851;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1560;-1464.253,-1041.766;Inherit;False;Constant;_Float8;Float 8;2;0;Create;True;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-6765.793,-1593.72;Inherit;False;Property;_StepShadow;StepShadow;29;0;Create;True;0;0;False;0;False;0.03;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1904;-7409.905,-4307.607;Inherit;False;Object_Specular_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1179;3868.048,-2812.069;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1582;-2466.584,-827.5928;Inherit;True;Property;_TopTex_Noise_Texture;TopTex_Noise_Texture;11;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1374;-1518.985,-3544.558;Inherit;False;Property;_TerrainBlending_TextureTiling;TerrainBlending_TextureTiling;43;0;Create;True;0;0;False;0;False;1;0.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1241;6203.105,-3902.368;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1496;-5228.897,1072.297;Inherit;False;Constant;_Float18;Float 18;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1569;-2965.847,-814.059;Inherit;False;Property;_TopTex_NoiseOffset;TopTex_NoiseOffset;54;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector3Node;1554;-2534.505,-1357.311;Inherit;False;Constant;_Vector1;Vector 1;2;0;Create;True;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-6206.792,-1891.719;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-2334.642,-4589.529;Inherit;False;Property;_SpeculartStepMin;SpeculartStepMin;34;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-4001.485,-3747.466;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TriplanarNode;1599;-1580.201,-2007.21;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1117;3900.277,-3650.035;Inherit;False;Property;_ShadowInBrumeGrunge_Contrast;ShadowInBrumeGrunge_Contrast;72;0;Create;True;0;0;False;0;False;-3.38;-3.53;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1715;-7803.633,-4307.797;Inherit;True;Property;_TextureSample6;Texture Sample 6;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;1563;-1260.253,-1184.767;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1957;5759.438,-3100.017;Inherit;True;Property;_IB_Edges_Mask;IB_Edges_Mask;96;0;Create;True;0;0;False;0;False;-1;None;37e68fddeb33a654cbb84cf062065914;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1981;6947.54,-2607.254;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1990;6542.852,-3097.89;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1759;-390.0121,-3584.777;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1246;5145.934,-3753.61;Inherit;False;ShadowInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1186;4591.314,-2765.48;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1231;4647.008,-4592.378;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1462;-1062.334,-4539.279;Inherit;True;1455;Object_SpecularMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1184;3688.384,-2478.407;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;1113;4208.227,-3463.437;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1518;3767.42,-2360.16;Inherit;False;Constant;_Float22;Float 22;88;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-4439.751,1179.161;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;634;-1304.679,-4114.333;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1809;-7796.757,-2750.553;Inherit;True;Property;_TextureSample26;Texture Sample 26;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1816;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;630;-1672.681,-4114.333;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1187;4342.693,-2620.926;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1501;-2026.735,-3996.074;Inherit;True;Property;_TextureSample15;Texture Sample 15;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1494;-5232.897,1308.296;Inherit;False;Constant;_Float17;Float 17;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1116;4202.501,-3747.273;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1519;3958.42,-2508.159;Inherit;True;Property;_TextureSample25;Texture Sample 25;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2074;-7695.92,296.1685;Inherit;False;Switch_UV_2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1561;-1446.253,-1116.767;Inherit;False;Constant;_Float9;Float 9;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1413;-5968.595,1089.827;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;570;-4727.751,1180.161;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1493;-5064.985,1204.289;Inherit;True;Property;_TextureSample13;Texture Sample 13;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1495;-5062.985,938.29;Inherit;True;Property;_TextureSample14;Texture Sample 14;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-6431.749,1154.017;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;1188;4883.282,-2764.944;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;487;-5921.746,1304.161;Inherit;False;Property;_Noise_Panner;Noise_Panner;27;0;Create;True;0;0;False;0;False;0.2,-0.1;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;572;-5697.745,1000.162;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;565;-6431.749,946.0189;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-6863.752,1154.017;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;479;-6671.751,1234.017;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;25;0;Create;True;0;0;False;1;Header(Shadow and NoiseEdge);False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;480;-6655.751,1154.017;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1414;-6199.595,1240.827;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;24;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1966;6218.671,-2991.299;Inherit;False;Property;_Float38;Float 38;97;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;573;-5265.749,968.1624;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1808;-7791.031,-2358.452;Inherit;True;Property;_TextureSample24;Texture Sample 24;13;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1816;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2088;-5891,-2763.395;Inherit;False;Constant;_Float44;Float 44;100;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2076;-6875.397,-103.2326;Inherit;True;2073;Object_Normal_Texture_UV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1815;-8203.756,-2358.779;Inherit;False;Constant;_Float5;Float 5;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1615;-730.6519,-4535.72;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2077;-5797.621,-150.0443;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;710;-5093.129,122.0893;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-5109.129,-149.9094;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-4533.129,-165.9094;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;711;-4821.13,-149.9094;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-5365.13,-149.9094;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-5381.13,-5.91042;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;1465;2960.568,-3107.402;Inherit;False;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1464;-7853.177,-617.768;Inherit;False;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1105;3243.432,-3107.418;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2072;-7395.893,-3781.229;Inherit;False;Object_Albedo_Texture_UV2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2084;-6790.81,95.63028;Inherit;False;2074;Switch_UV_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;484;-5697.745,1224.161;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1885;-5303.904,1167.138;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.PannerNode;571;-5537.745,968.1624;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2078;-5505.65,-3229.048;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1613;-5236.943,-3132.726;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1612;-4952.032,-3225.413;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1405;-7566.563,-667.3107;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2090;-6747.357,-188.4684;Inherit;False;Constant;_Float45;Float 45;100;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;-8189.091,-575.5727;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;955;-8231.03,-822.0958;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;461;-3723.328,-3254.85;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2069;-7798.928,-3567.848;Inherit;True;Property;_TextureSample34;Texture Sample 34;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;2066;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1404;-8123.451,-473.8348;Inherit;False;Property;_LightDebug;LightDebug;2;0;Create;True;0;0;False;1;Header(Debug);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1403;-7899.572,-820.2779;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;-8507.616,-826.5408;Inherit;False;473;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1609;-7885.214,-231.0608;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2068;-8014.938,-3782.479;Inherit;False;Texture_UV2;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.StepOpNode;1564;-1974.512,-813.251;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1373;-1229.985,-3563.558;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1562;-1676.984,-1186.992;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1376;-7583.552,-285.8421;Inherit;False;1375;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2066;-7789.263,-3781.233;Inherit;True;Property;_TA_Textures_UV2;TA_Textures_UV2;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1719;-8211.359,-4272.124;Inherit;False;Constant;_Float11;Float 11;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1406;-7748.415,-416.2936;Inherit;False;Property;_NormalDebug;NormalDebug;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1614;-5265.842,-3028.841;Inherit;False;Property;_DebugGrayscale;DebugGrayscale?;4;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2085;-5696.527,-2748.991;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2086;-5917.587,-2600.505;Inherit;False;2074;Switch_UV_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;2079;-6755.812,-2701.305;Inherit;True;2072;Object_Albedo_Texture_UV2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;2081;-6454.96,-2598.56;Inherit;False;Property;_OutBrume_UV2_ColorCorrection;OutBrume_UV2_ColorCorrection;61;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2080;-6136.697,-2725.348;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;2075;-8058.865,295.8423;Inherit;False;Property;_UV_2_;UV_2_?;99;0;Create;True;0;0;False;1;Header(UV 2);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1453;-7409.147,-4694.393;Inherit;False;Object_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;841;-6758.778,-3040.751;Inherit;False;Property;_OutBrumeColorCorrection;OutBrumeColorCorrection;62;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2073;-7391.566,-3568.253;Inherit;False;Object_Normal_Texture_UV2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1471;-6736.494,-956.6941;Inherit;False;1366;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1823;-7418.635,-2357.361;Inherit;False;Object_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;2065;-8299.852,-3782.706;Inherit;True;Property;_TextureArray_Textures_UV2;TextureArray_Textures_UV2;7;0;Create;True;0;0;False;0;False;668ed38e9d9e517458c599bfa078a81c;bab7337c8018c7042ada8f6325405b49;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;2071;-8176.061,-3341.987;Inherit;False;Constant;_Float43;Float 43;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2070;-8179.061,-3419.987;Inherit;False;Constant;_Float42;Float 42;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2067;-8256.971,-3540.055;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;842;-6442.778,-3229.75;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1760;-681.3223,-3435.616;Inherit;False;Property;_TerrainBlending_Color;TerrainBlending_Color;41;0;Create;True;0;0;False;0;False;1,1,1,0;0.3679237,0.2556294,0.2412327,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1235;3453.75,-4073.423;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1455;-7419.498,-4212.706;Inherit;False;Object_SpecularMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1871;-7795.112,-1681.494;Inherit;True;Property;_TextureSample28;Texture Sample 28;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;428;-4060.89,-947.2991;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1843;-5013.102,-944.9711;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;1896;-8204.024,-1482.191;Inherit;False;Constant;_Float31;Float 31;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1402;-5360.135,-613.8799;Inherit;False;Property;_Specular;Specular?;32;0;Create;True;0;0;False;1;Header(Specular);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1751;3025.618,-3281.565;Inherit;False;Property;_NormalInBrumeGrunge_Tiling;NormalInBrumeGrunge_Tiling;73;0;Create;True;0;0;False;0;False;0.2;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1894;-7792.887,-1484.39;Inherit;True;Property;_TextureSample30;Texture Sample 30;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1953;3664.655,-4511.375;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1252;7200.776,-3798.351;Inherit;False;1251;NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1911;-2678.514,-675.7164;Inherit;False;Constant;_Float37;Float 37;89;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;2045;4658.791,-1658.124;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1811;-8254.895,-2735.619;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1394;-4956.872,-765.2351;Inherit;False;1389;CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1255;8647.847,-3838.867;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;450;-5177.79,-1335.72;Inherit;False;Property;_ShadowColor;ShadowColor;31;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.5,0.5,0.5,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1884;-5314.319,882.9911;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1910;-8204.174,-1396.145;Inherit;False;Constant;_Float34;Float 34;104;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1820;-7432.13,-2943.037;Inherit;False;Object_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;563;-4094.792,-1635.72;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;2046;4850.219,-1659.581;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1118;6461.361,-3897.438;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1189;5156.73,-3067.317;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1553;-313.8558,-1545.829;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;1817;-7795.031,-2555.452;Inherit;True;Property;_TextureSample27;Texture Sample 27;16;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1816;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;2034;-1000.347,-3115.117;Inherit;False;TerrainBlending;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2049;5256.995,-1771;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2050;4983.575,-1749.512;Inherit;False;901;EndInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1873;-7795.274,-2069.701;Inherit;True;Property;_TA_Noises;TA_Noises;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1397;-4392.787,-943.2931;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;562;-4487.789,-1817.719;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;518;-5304.827,-838.9241;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1821;-7424.797,-2751.271;Inherit;False;Object_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1989;7932.482,-3822.482;Inherit;False;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1812;-8205.756,-2597.779;Inherit;False;Constant;_Float12;Float 12;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1393;1117.88,-4469.892;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1585;298.8976,-4374.361;Inherit;False;Specular;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;2091;-5618.227,73.22258;Inherit;False;NormalMixedUV2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2035;3702.178,-1719.831;Inherit;False;2034;TerrainBlending;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1891;2970.563,-3458.234;Inherit;False;1810;Grunge;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.BlendOpsNode;444;-5294.791,-1619.72;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1882;-8202.835,-1566.821;Inherit;False;Constant;_Float28;Float 28;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-6781.551,-4539.616;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;2044;4426.647,-1655.471;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1014;7466.119,-3816.944;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1909;-7437.191,-1290.515;Inherit;False;Object_TopTexNoise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;2038;3129.015,-1461.072;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;1908;-7793.191,-1290.515;Inherit;True;Property;_TextureSample31;Texture Sample 31;16;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;1223;8221.781,-3815.495;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1369;-4284.642,-788.6001;Inherit;False;877;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1391;666.8824,-4350.892;Inherit;False;Property;_CustomRimLight_Color;CustomRimLight_Color;59;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1389;1272.767,-4475.326;Inherit;False;CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-5342.791,-2131.719;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1400;-4719.06,-616.3636;Inherit;False;Property;_CustomRimLight;CustomRimLight?;57;0;Create;True;0;0;False;1;Header(Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1395;-4715.677,-852.8871;Inherit;True;Lighten;True;3;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;2047;5044.836,-1658.776;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;2051;4998.575,-1944.512;Inherit;False;Property;_IB_TerrainBlending_Color;IB_TerrainBlending_Color;47;0;Create;True;0;0;False;0;False;0.4245283,0.4245283,0.4245283,0;0.1320754,0.1320754,0.1320754,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1814;-8202.756,-2440.779;Inherit;False;Constant;_Float20;Float 20;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;523;-779.6787,-4259.333;Inherit;False;Property;_Specular_Multiplier;Specular_Multiplier;38;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2048;4333.79,-1829.248;Inherit;False;Property;_IB_TerrainBlending_Falloff;IB_TerrainBlending_Falloff;46;0;Create;True;0;0;False;0;False;0;2;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-5854.792,-1587.72;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;877;-3532.986,-1640.371;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1994;7704.8,-2776.062;Inherit;False;IB_Edges;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;2040;3646.05,-1346.879;Inherit;False;Procedural Sample;-1;;37;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;1370;-6799.335,-870.239;Inherit;False;1368;RBG_TerrainBlending;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1906;-434.4421,-3997.267;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-167.7526,-4116.125;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;636;-1064.68,-4114.333;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1590;-6342.53,-773.2411;Inherit;False;1584;TopTex;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1895;-7443.34,-1484.299;Inherit;False;Object_TerrainBlendingNoise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1608;-6303.288,-674.1959;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1461;616.4374,-4619.936;Inherit;True;1456;Object_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1903;644.5051,-4182.536;Inherit;True;1475;Object_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2037;3122.013,-1290.724;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;2052;5488.974,-1776.087;Inherit;False;FinalInBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1816;-7795.193,-2943.659;Inherit;True;Property;_TA_Grunges;TA_Grunges;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1469;-6840.674,-783.7711;Inherit;False;Property;_TerrainBlending;TerrainBlending?;39;0;Create;True;0;0;False;1;Header(TerrainBlending);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1878;-8202.835,-1645.821;Inherit;False;Constant;_Float27;Float 27;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1584;-114.0908,-1550.381;Inherit;False;TopTex;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;37.32248,-4368.333;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1835;-4525.862,-4303.739;Inherit;False;Constant;_Float23;Float 23;95;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2041;3647.089,-1542.251;Inherit;False;Property;_IB_TerrainBlending_BlendThickness;IB_TerrainBlending_BlendThickness;45;0;Create;True;0;0;False;0;False;0;0.6;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1468;-6501.688,-951.7661;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1475;-7402.396,-4110.499;Inherit;False;Object_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;554.6646,-3201.673;Inherit;False;RBG_TerrainBlending;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;508;-250.6789,-4320.333;Inherit;False;False;False;False;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1256;8346.056,-4102.941;Inherit;False;Property;_InBrumeColorCorrection;InBrumeColorCorrection;75;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1607;-6486.462,-679.212;Inherit;False;1606;TopTexMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-5646.792,-1619.72;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;509;-250.6789,-4400.333;Inherit;False;True;True;True;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1606;-427.2567,-1191.493;Inherit;False;TopTexMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-5566.792,-2131.719;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-427.6786,-4371.333;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1872;-7796.837,-1876.594;Inherit;True;Property;_TextureSample29;Texture Sample 29;12;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1873;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;2036;3158.385,-1374.157;Inherit;False;Constant;_Float41;Float 41;95;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1251;5453.636,-3067.491;Inherit;False;NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1050;6607.788,-4579.279;Inherit;False;Property;_IB_BackColor;IB_BackColor;63;0;Create;True;0;0;False;1;Header(In Brume);False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1716;-7799.633,-4110.797;Inherit;True;Property;_TextureSample8;Texture Sample 8;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;482;-5790.792,-1955.719;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-5854.792,-1491.72;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-5886.792,-1699.719;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1392;654.8813,-4429.892;Inherit;False;Property;_CustomRimLight_Opacity;CustomRimLight_Opacity;60;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;2042;3996.479,-1497.228;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;901;8935.765,-3843.883;Inherit;False;EndInBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1162;7162.97,-4120.172;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1880;-8254.976,-1861.66;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;448;-6062.792,-1539.719;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;2039;3249.112,-1131.434;Inherit;False;Property;_IB_TerrainBlendingNoise_Tiling;IB_TerrainBlendingNoise_Tiling;11;0;Create;True;0;0;False;0;False;1,1;0.3,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-6046.792,-2131.719;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1874;-7419.716,-1681.403;Inherit;False;Object_IB_DrippingNoise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-6349.551,-4539.616;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1876;-7432.21,-2069.079;Inherit;False;Object_Noise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;1930;-1779.303,-86.80806;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1985;7230.855,-2772.468;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1161;6696.813,-4370.26;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;989;6451.979,-4096.746;Inherit;False;Property;_IB_ColorShadow;IB_ColorShadow;64;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.2452829,0.2452829,0.2452829,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1586;-5539.628,-815.2211;Inherit;False;1585;Specular;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1983;6286.506,-2375.041;Inherit;False;Property;_Float39;Float 39;98;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1875;-7424.878,-1877.313;Inherit;False;Object_WindNoise_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1901;985.0667,-4288.11;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1825;-6724.848,-3652.442;Inherit;False;Constant;_Float3;Float 3;99;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;670;-6310.598,-4029.866;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1949;3700.988,-3950.566;Inherit;False;1934;MapNoise_IB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1818;-8308.115,-2943.491;Inherit;True;Property;_TextureArray_Grunges;TextureArray_Grunges;9;0;Create;True;0;0;False;0;False;668ed38e9d9e517458c599bfa078a81c;649e428ece482fe499fbfc248f5c6460;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StepOpNode;1232;4163.543,-4088.668;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;463;-6598.551,-4460.616;Inherit;False;Property;_AnimatedGrunge_Tiling;AnimatedGrunge_Tiling;15;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;666;-6457.598,-4199.864;Inherit;False;Property;_AnimatedGrunge_Flipbook_Rows;AnimatedGrunge_Flipbook_Rows;17;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1382;-6350.948,-3711.748;Inherit;False;Procedural Sample;-1;;40;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerNode;1939;-1304.542,-116.6805;Inherit;True;Property;_TextureSample33;Texture Sample 33;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1712;-7805.359,-4502.897;Inherit;True;Property;_TextureSample2;Texture Sample 2;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1711;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1454;-7402.147,-4503.393;Inherit;False;Object_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;1935;-2163.304,249.1908;Inherit;False;Property;_IB_Noise_Panner;IB_Noise_Panner;28;0;Create;True;0;0;False;0;False;0.2,-0.1;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1936;-2509.017,78.57581;Inherit;False;Property;_IB_Noise_Tiling;IB_Noise_Tiling;26;0;Create;True;0;0;False;1;Header(Shadow and NoiseEdge);False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1943;-2327.367,60.02216;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;844;-8496.235,-746.1387;Inherit;False;2052;FinalInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1941;-1555.876,-171.9794;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1902;635.6772,-3984.347;Inherit;False;Property;_CustomRimLight_Texture;CustomRimLight_Texture?;58;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;465;-6557.551,-4539.616;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1492;-5613.432,-4402.198;Inherit;False;Constant;_Float16;Float 16;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1933;-1470.454,17.32673;Inherit;False;Constant;_Float40;Float 40;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1247;5165.436,-3468.004;Inherit;False;NormalInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1366;-3427.235,-3256.38;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1456;-7415.099,-4014.524;Inherit;False;Object_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1927;-1306.542,149.3188;Inherit;True;Property;_TextureSample32;Texture Sample 32;20;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;667;-6458.598,-4121.866;Inherit;False;Property;_AnimatedGrunge_Flipbook_Speed;AnimatedGrunge_Flipbook_Speed;18;0;Create;True;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1934;-681.3083,124.1907;Inherit;False;MapNoise_IB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1385;-6749.07,-3428.541;Inherit;False;Property;_PaintGrunge_Tiling;PaintGrunge_Tiling;21;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1106;3883.805,-3063.895;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1458;-6166.99,-155.1195;Inherit;True;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1929;-1939.303,-54.80857;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1595;-1181.903,-845.6368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1119;4452.887,-3753.155;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1726;-6219.809,-3507.759;Inherit;False;Property;_PaintGrunge_Contrast;PaintGrunge_Contrast;22;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1242;6237.189,-4376.466;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1980;6645.646,-2606.754;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1367;38.84274,-3176.354;Inherit;False;1366;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1249;4586.731,-3064.773;Inherit;False;1247;NormalInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1888;2954.967,-3753.328;Inherit;False;1810;Grunge;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TexturePropertyNode;1600;-1850.2,-2063.21;Inherit;True;Property;_TopTex_Albedo_Texture;TopTex_ Albedo_Texture;50;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;1937;-1507.307,-86.80806;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1411;-5750.28,-4539.062;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1588;-5755.333,-945.859;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;1931;-1939.303,169.1908;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;1604;-1779.929,-1864.877;Inherit;False;Property;_TopTex_Tiling;TopTex_Tiling;51;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;665;-6461.598,-4277.863;Inherit;False;Property;_AnimatedGrunge_Flipbook_Columns;AnimatedGrunge_Flipbook_Columns;16;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1932;-969.3083,125.1907;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1165;2993.088,-4335.258;Inherit;False;Property;_ShadowDrippingNoise_Step;ShadowDrippingNoise_Step;66;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1810;-8020.127,-2943.491;Inherit;False;Grunge;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;664;-6073.586,-4298.343;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1230;2955.93,-4257.833;Inherit;False;Property;_ShadowDrippingNoise_Smoothstep;ShadowDrippingNoise_Smoothstep;65;0;Create;True;0;0;False;0;False;0.2;0.14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1412;-6089.449,-4465.237;Inherit;False;Property;_IsGrungeAnimated;IsGrungeAnimated?;14;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1824;-6761.228,-3851.076;Inherit;True;1810;Grunge;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;1225;3147.269,-4686.986;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1497;-6742.345,-3572.649;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1954;2953.915,-4428.764;Inherit;False;Property;_ShadowDrippingNoise_SmoothstepAnimated;ShadowDrippingNoise_SmoothstepAnimated;93;0;Create;True;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1180;4108.504,-2811.625;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1182;3136.887,-2742.587;Inherit;False;Property;_NormalDrippingNoise_Smoothstep;NormalDrippingNoise_Smoothstep;67;0;Create;True;0;0;False;0;False;0.01;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1725;-5957.646,-3704.473;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1721;-8212.359,-4111.124;Inherit;False;Constant;_Float36;Float 36;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1728;-5810.748,-3474.607;Inherit;False;Property;_PaintGrunge_Multiply;PaintGrunge_Multiply;23;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;455;-5123.35,-4567.476;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1228;3937.891,-4091.438;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1727;-5519.748,-3704.607;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1459;-2987.218,-4219.704;Inherit;True;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;449;-4878.788,-1619.72;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1491;-5444.409,-4567.362;Inherit;True;Property;_TextureSample12;Texture Sample 12;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1816;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;1752;3573.619,-3465.565;Inherit;False;Procedural Sample;-1;;38;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;1697;-6756.654,-3234.59;Inherit;True;1453;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1598;-2881.858,-1582.888;Inherit;True;1454;Object_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-4919.349,-4330.476;Inherit;False;Property;_AnimatedGrungeMultiply;AnimatedGrungeMultiply;19;0;Create;True;0;0;False;0;False;1.58;1.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1950;3525.742,-4586.975;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1836;-4600.862,-4065.742;Inherit;False;Property;_AnimatedGrunge;AnimatedGrunge?;13;0;Create;True;0;0;False;1;Header(AnimatedGrunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1890;2999.563,-3378.234;Inherit;False;Property;_Float30;Float 30;95;0;Create;True;0;0;False;0;False;3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1755;3316.768,-3389.555;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1907;-800.4421,-3786.267;Inherit;False;Property;_SpecularTexture;SpecularTexture?;33;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1565;-959.4577,-1185.041;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1390;926.8816,-4580.892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1877;-8205.835,-1723.821;Inherit;False;Constant;_Float24;Float 24;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1822;-7419.635,-2555.361;Inherit;False;Object_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1813;-8202.756,-2519.779;Inherit;False;Constant;_Float13;Float 13;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;2043;4228.993,-1658.124;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;498;-2733.152,-4214.391;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-3691.075,-945.499;Inherit;False;EndOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1829;-4919.732,-4562.094;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1748;-5295.701,-3704.416;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;1995;7720.145,-3727.866;Inherit;False;1994;IB_Edges;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1591;-6107.303,-573.212;Inherit;False;Property;_TopTex;TopTex?;49;0;Create;True;0;0;False;1;Header(Top Texture);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1227;3660.664,-4173.872;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;1555;-2603.955,-1578.344;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;623;-752.6787,-4047.334;Inherit;False;Property;_SpecularColor;SpecularColor;37;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.9433962,0.8590411,0.6274475,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1750;3000.792,-3553.717;Inherit;False;Property;_ShadowInBrumeGrunge_Tiling;ShadowInBrumeGrunge_Tiling;71;0;Create;True;0;0;False;0;False;0.2;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1828;-5185.367,-4346.383;Inherit;False;Constant;_AnimatedGrungeContrast;AnimatedGrungeContrast;96;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-4642.347,-4563.476;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1833;-5102.637,-3559.773;Inherit;False;Property;_PaintGrunge;PaintGrunge?;20;0;Create;True;0;0;False;1;Header(PaintGrunge);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1951;3877.043,-4676.605;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1928;-1474.454,253.326;Inherit;False;Constant;_Float14;Float 14;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1568;-2964.013,-899.0527;Inherit;False;Property;_TopTex_NoiseTiling;TopTex_NoiseTiling;53;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1108;3156.019,-2842.959;Inherit;False;Property;_NormalDrippingNoise_Step;NormalDrippingNoise_Step;68;0;Create;True;0;0;False;0;False;0.45;0.392;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1233;4369.545,-4088.668;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1566;-2267.429,-1219.732;Inherit;False;Property;_TopTex_Step;TopTex_Step;55;0;Create;True;0;0;False;0;False;0;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1940;-1545.461,112.1673;Inherit;False;1879;Noise;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.WireNode;1984;6088.162,-2528.643;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1567;-2314.428,-1111.733;Inherit;False;Property;_TopTex_Smoothstep;TopTex_Smoothstep;56;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;506;-2160.155,-4401.117;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1992;7357.596,-2772.277;Inherit;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;499;-2525.152,-4214.391;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1191;3413.503,-2522.828;Inherit;False;Property;_NormalDrippingNoise_Tiling;NormalDrippingNoise_Tiling;69;0;Create;True;0;0;False;0;False;1;0.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1556;-2724.012,-876.0529;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;500;-2621.152,-4406.391;Inherit;False;Blinn-Phong Half Vector;-1;;39;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1832;-5027.637,-3797.773;Inherit;False;Constant;_Float21;Float 21;95;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1049;6861.032,-4547.346;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;2082;-6505.764,-124.5115;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;1,1,1,1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2061;-7360.251,-1099.568;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2062;-7360.251,-1099.568;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2059;-7317.448,-589.5014;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2060;-7317.448,-589.5014;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;EnvironmentObjectsShader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;0;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2063;-7360.251,-1099.568;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;1340;0;1338;1
WireConnection;1340;1;1338;3
WireConnection;1339;0;1336;0
WireConnection;1339;1;1337;0
WireConnection;1342;0;1340;0
WireConnection;1342;1;1339;0
WireConnection;1343;0;1342;0
WireConnection;1343;1;1341;0
WireConnection;1346;1;1343;0
WireConnection;1879;0;1881;0
WireConnection;1344;0;1338;2
WireConnection;1347;0;1346;0
WireConnection;1347;1;1345;0
WireConnection;1897;158;1898;0
WireConnection;1897;183;1899;0
WireConnection;1897;80;1359;0
WireConnection;1897;104;1361;0
WireConnection;1350;0;1348;0
WireConnection;1350;1;1347;0
WireConnection;1351;0;1363;0
WireConnection;1351;1;1897;0
WireConnection;1307;0;1305;4
WireConnection;1307;1;1306;0
WireConnection;1352;0;1350;0
WireConnection;1352;1;1349;0
WireConnection;1309;0;1307;0
WireConnection;1309;1;1308;0
WireConnection;1353;0;1352;0
WireConnection;1353;1;1351;0
WireConnection;1312;2;1311;0
WireConnection;1312;1;1309;0
WireConnection;1354;0;1353;0
WireConnection;1313;2;1310;0
WireConnection;1525;0;1524;0
WireConnection;1315;0;1312;0
WireConnection;1315;1;1313;0
WireConnection;1527;0;1525;0
WireConnection;1527;1;1526;0
WireConnection;1355;0;1354;0
WireConnection;1355;1;1364;0
WireConnection;1529;82;1531;0
WireConnection;1529;5;1527;0
WireConnection;1317;0;1315;0
WireConnection;1317;1;1314;0
WireConnection;1356;0;1355;0
WireConnection;1542;0;1544;0
WireConnection;1542;1;1529;32
WireConnection;1542;2;1543;0
WireConnection;1319;0;1316;0
WireConnection;1319;1;1317;0
WireConnection;1357;0;1356;0
WireConnection;1806;0;1804;0
WireConnection;1323;0;1886;0
WireConnection;1323;1;1319;0
WireConnection;1323;6;1887;0
WireConnection;1530;0;1542;0
WireConnection;1530;1;1528;0
WireConnection;1761;0;1357;0
WireConnection;1711;0;1806;0
WireConnection;1711;1;1622;0
WireConnection;1711;6;1718;0
WireConnection;1322;0;1321;0
WireConnection;1322;1;1318;4
WireConnection;1534;0;1532;0
WireConnection;1534;1;1533;0
WireConnection;1325;0;1323;0
WireConnection;1325;1;1322;0
WireConnection;1457;0;1711;4
WireConnection;1545;0;1530;0
WireConnection;1545;1;1546;0
WireConnection;1523;0;1534;0
WireConnection;1523;1;1545;0
WireConnection;1523;2;1535;0
WireConnection;1326;0;1325;0
WireConnection;1326;1;1324;0
WireConnection;1770;0;1765;0
WireConnection;1770;1;1767;0
WireConnection;1472;0;1467;0
WireConnection;1472;1;1900;0
WireConnection;1472;2;1477;0
WireConnection;1327;0;1326;0
WireConnection;1771;0;1770;0
WireConnection;1837;0;1523;0
WireConnection;1328;0;1327;0
WireConnection;1328;1;1329;0
WireConnection;1328;2;1304;0
WireConnection;1772;0;1771;0
WireConnection;1772;1;1472;0
WireConnection;1416;0;1428;0
WireConnection;1416;1;1772;0
WireConnection;1416;2;1417;0
WireConnection;1540;0;1539;0
WireConnection;1540;1;1838;0
WireConnection;1540;2;1538;0
WireConnection;1330;0;1328;0
WireConnection;1548;0;1416;0
WireConnection;1548;1;1540;0
WireConnection;1407;0;1334;0
WireConnection;1407;1;1331;0
WireConnection;1407;2;1408;0
WireConnection;1375;0;1548;0
WireConnection;1358;0;1759;0
WireConnection;1358;1;1367;0
WireConnection;1358;2;1357;0
WireConnection;1365;1;1373;0
WireConnection;1754;0;1750;0
WireConnection;1979;0;1976;0
WireConnection;1115;0;1113;0
WireConnection;632;0;506;0
WireConnection;632;1;619;0
WireConnection;632;2;633;0
WireConnection;1181;0;1108;0
WireConnection;1181;1;1182;0
WireConnection;1557;0;1555;0
WireConnection;1557;1;1554;0
WireConnection;626;0;627;0
WireConnection;1834;0;1835;0
WireConnection;1834;1;525;0
WireConnection;1834;2;1836;0
WireConnection;1111;0;1249;0
WireConnection;1111;1;1186;0
WireConnection;988;0;989;0
WireConnection;988;1;1118;0
WireConnection;1592;0;1468;0
WireConnection;1592;1;1590;0
WireConnection;1592;2;1608;0
WireConnection;1559;0;1557;0
WireConnection;1559;1;1566;0
WireConnection;1559;2;1558;0
WireConnection;1558;0;1566;0
WireConnection;1558;1;1567;0
WireConnection;1749;158;1888;0
WireConnection;1749;183;1889;0
WireConnection;1749;5;1754;0
WireConnection;504;0;500;0
WireConnection;504;1;499;0
WireConnection;1991;0;1984;0
WireConnection;1991;1;1983;0
WireConnection;1581;0;1599;0
WireConnection;1581;1;1557;0
WireConnection;1240;0;1231;0
WireConnection;1831;0;1832;0
WireConnection;1831;1;1748;0
WireConnection;1831;2;1833;0
WireConnection;1977;0;1979;0
WireConnection;1977;1;1990;0
WireConnection;640;0;630;0
WireConnection;1158;0;1242;0
WireConnection;1552;0;1565;0
WireConnection;1904;0;1715;0
WireConnection;1179;0;1105;0
WireConnection;1179;1;1108;0
WireConnection;1179;2;1181;0
WireConnection;1582;1;1556;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;530;0;1834;0
WireConnection;530;1;1831;0
WireConnection;1599;0;1600;0
WireConnection;1599;3;1604;0
WireConnection;1715;1;1622;0
WireConnection;1715;6;1720;0
WireConnection;1563;0;1562;0
WireConnection;1563;1;1561;0
WireConnection;1563;2;1560;0
WireConnection;1981;0;1980;0
WireConnection;1981;1;1991;0
WireConnection;1990;0;1957;0
WireConnection;1990;1;1966;0
WireConnection;1759;0;1365;0
WireConnection;1759;1;1760;0
WireConnection;1246;0;1119;0
WireConnection;1186;0;1106;0
WireConnection;1186;1;1187;0
WireConnection;1231;0;1228;0
WireConnection;1231;1;1951;0
WireConnection;1231;2;1233;0
WireConnection;1184;0;1191;0
WireConnection;1184;1;1193;0
WireConnection;1113;1;1752;0
WireConnection;1113;0;1114;0
WireConnection;481;0;570;0
WireConnection;634;0;640;0
WireConnection;1809;1;1811;0
WireConnection;1809;6;1813;0
WireConnection;630;0;632;0
WireConnection;630;1;1501;0
WireConnection;1187;0;1180;0
WireConnection;1187;1;1519;0
WireConnection;1501;1;626;0
WireConnection;1501;6;1500;0
WireConnection;1116;1;1749;0
WireConnection;1116;0;1117;0
WireConnection;1519;1;1184;0
WireConnection;1519;6;1518;0
WireConnection;2074;0;2075;0
WireConnection;1413;0;565;0
WireConnection;1413;1;477;0
WireConnection;1413;2;1414;0
WireConnection;570;0;1495;1
WireConnection;570;1;1493;1
WireConnection;1493;0;1885;0
WireConnection;1493;1;484;0
WireConnection;1493;6;1494;0
WireConnection;1495;0;1884;0
WireConnection;1495;1;573;0
WireConnection;1495;6;1496;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;1188;0;1186;0
WireConnection;572;0;487;0
WireConnection;565;0;479;0
WireConnection;480;0;478;0
WireConnection;573;0;571;0
WireConnection;1808;1;1811;0
WireConnection;1808;6;1815;0
WireConnection;1615;0;1462;0
WireConnection;2077;0;1458;0
WireConnection;2077;1;2082;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;23;0;711;0
WireConnection;711;0;12;0
WireConnection;711;1;710;0
WireConnection;10;0;2077;0
WireConnection;1105;0;1465;0
WireConnection;2072;0;2066;0
WireConnection;484;0;1413;0
WireConnection;484;2;487;0
WireConnection;571;0;1413;0
WireConnection;571;2;572;0
WireConnection;2078;0;842;0
WireConnection;2078;1;2085;0
WireConnection;1613;0;2078;0
WireConnection;1612;0;2078;0
WireConnection;1612;1;1613;0
WireConnection;1612;2;1614;0
WireConnection;1405;0;1403;0
WireConnection;1405;1;1464;0
WireConnection;1405;2;1406;0
WireConnection;955;0;474;0
WireConnection;955;1;844;0
WireConnection;955;2;954;0
WireConnection;461;0;530;0
WireConnection;461;1;1612;0
WireConnection;2069;1;2067;0
WireConnection;2069;6;2071;0
WireConnection;1403;0;955;0
WireConnection;1403;1;582;0
WireConnection;1403;2;1404;0
WireConnection;1609;0;1407;0
WireConnection;1609;1;1611;0
WireConnection;1609;2;954;0
WireConnection;2068;0;2065;0
WireConnection;1564;0;1582;1
WireConnection;1373;0;1374;0
WireConnection;1562;0;1559;0
WireConnection;1562;1;1582;1
WireConnection;2066;0;2068;0
WireConnection;2066;1;2067;0
WireConnection;2066;6;2070;0
WireConnection;2085;0;2088;0
WireConnection;2085;1;2080;0
WireConnection;2085;2;2086;0
WireConnection;2080;0;2079;0
WireConnection;2080;1;2081;0
WireConnection;1453;0;1711;0
WireConnection;2073;0;2069;0
WireConnection;1823;0;1808;0
WireConnection;842;0;1697;0
WireConnection;842;1;841;0
WireConnection;1235;0;1165;0
WireConnection;1235;1;1230;0
WireConnection;1455;0;1715;4
WireConnection;1871;1;1880;0
WireConnection;1871;6;1882;0
WireConnection;428;0;1397;0
WireConnection;428;1;1369;0
WireConnection;1843;0;1588;0
WireConnection;1843;1;518;0
WireConnection;1843;2;1402;0
WireConnection;1894;1;1880;0
WireConnection;1894;6;1896;0
WireConnection;1953;0;1950;0
WireConnection;1953;1;1230;0
WireConnection;2045;0;2044;0
WireConnection;2045;1;2048;0
WireConnection;1255;0;1256;0
WireConnection;1255;1;1223;0
WireConnection;1820;0;1816;0
WireConnection;563;0;562;0
WireConnection;563;1;449;0
WireConnection;2046;0;2045;0
WireConnection;1118;0;1241;0
WireConnection;1118;1;1248;0
WireConnection;1189;0;1111;0
WireConnection;1189;1;1188;0
WireConnection;1189;2;1106;0
WireConnection;1553;0;1581;0
WireConnection;1553;1;1552;0
WireConnection;1817;1;1811;0
WireConnection;1817;6;1814;0
WireConnection;2034;0;1352;0
WireConnection;2049;0;2051;0
WireConnection;2049;1;2050;0
WireConnection;2049;2;2047;0
WireConnection;1873;0;1879;0
WireConnection;1873;1;1880;0
WireConnection;1873;6;1877;0
WireConnection;1397;0;1843;0
WireConnection;1397;1;1395;0
WireConnection;1397;2;1400;0
WireConnection;562;0;449;0
WireConnection;518;0;1588;0
WireConnection;518;1;1586;0
WireConnection;1821;0;1809;0
WireConnection;1989;0;1014;0
WireConnection;1989;1;1995;0
WireConnection;1393;0;1390;0
WireConnection;1393;1;1901;0
WireConnection;1585;0;512;0
WireConnection;2091;0;2077;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;2044;0;2043;0
WireConnection;1014;0;1162;0
WireConnection;1014;1;1252;0
WireConnection;1909;0;1908;0
WireConnection;1908;1;1880;0
WireConnection;1908;6;1910;0
WireConnection;1223;0;1989;0
WireConnection;1389;0;1393;0
WireConnection;401;0;397;0
WireConnection;1395;0;1843;0
WireConnection;1395;1;1394;0
WireConnection;2047;0;2046;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;877;0;563;0
WireConnection;1994;0;1992;0
WireConnection;2040;158;2038;0
WireConnection;2040;183;2036;0
WireConnection;2040;80;2037;0
WireConnection;2040;104;2039;0
WireConnection;1906;0;623;0
WireConnection;1906;1;1905;0
WireConnection;1906;2;1907;0
WireConnection;639;0;636;0
WireConnection;639;1;1906;0
WireConnection;636;0;634;0
WireConnection;1895;0;1894;0
WireConnection;1608;0;1607;0
WireConnection;2052;0;2049;0
WireConnection;1816;0;1810;0
WireConnection;1816;1;1811;0
WireConnection;1816;6;1812;0
WireConnection;1584;0;1553;0
WireConnection;512;0;509;0
WireConnection;512;1;508;0
WireConnection;512;2;639;0
WireConnection;1468;0;1471;0
WireConnection;1468;1;1370;0
WireConnection;1468;2;1469;0
WireConnection;1475;0;1716;0
WireConnection;1368;0;1358;0
WireConnection;508;0;522;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;509;0;522;0
WireConnection;1606;0;1565;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;522;0;1615;0
WireConnection;522;1;523;0
WireConnection;1872;1;1880;0
WireConnection;1872;6;1878;0
WireConnection;1251;0;1189;0
WireConnection;1716;1;1622;0
WireConnection;1716;6;1721;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;2042;0;2041;0
WireConnection;2042;1;2040;0
WireConnection;901;0;1255;0
WireConnection;1162;0;1049;0
WireConnection;1162;1;988;0
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;1874;0;1871;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;1876;0;1873;0
WireConnection;1930;0;1943;0
WireConnection;1930;2;1929;0
WireConnection;1985;0;1977;0
WireConnection;1985;1;1981;0
WireConnection;1161;0;1158;0
WireConnection;1875;0;1872;0
WireConnection;1901;0;1391;0
WireConnection;1901;1;1903;0
WireConnection;1901;2;1902;0
WireConnection;1232;0;1228;0
WireConnection;1382;158;1824;0
WireConnection;1382;183;1825;0
WireConnection;1382;80;1497;0
WireConnection;1382;104;1385;0
WireConnection;1939;0;1941;0
WireConnection;1939;1;1937;0
WireConnection;1939;6;1933;0
WireConnection;1712;1;1622;0
WireConnection;1712;6;1719;0
WireConnection;1454;0;1712;0
WireConnection;1943;0;1936;0
WireConnection;465;0;464;0
WireConnection;1247;0;1115;0
WireConnection;1366;0;461;0
WireConnection;1456;0;1716;4
WireConnection;1927;0;1940;0
WireConnection;1927;1;1931;0
WireConnection;1927;6;1928;0
WireConnection;1934;0;1932;0
WireConnection;1106;0;1105;0
WireConnection;1106;1;1108;0
WireConnection;1929;0;1935;0
WireConnection;1595;0;1596;0
WireConnection;1595;1;1564;0
WireConnection;1595;2;1594;0
WireConnection;1119;0;1116;0
WireConnection;1980;0;1979;0
WireConnection;1937;0;1930;0
WireConnection;1411;0;466;0
WireConnection;1411;1;664;0
WireConnection;1411;2;1412;0
WireConnection;1588;0;1468;0
WireConnection;1588;1;1592;0
WireConnection;1588;2;1591;0
WireConnection;1931;0;1943;0
WireConnection;1931;2;1935;0
WireConnection;1932;0;1939;1
WireConnection;1932;1;1927;1
WireConnection;1810;0;1818;0
WireConnection;664;0;466;0
WireConnection;664;1;665;0
WireConnection;664;2;666;0
WireConnection;664;3;667;0
WireConnection;664;5;670;0
WireConnection;1180;0;1179;0
WireConnection;1725;1;1382;0
WireConnection;1725;0;1726;0
WireConnection;455;0;1491;1
WireConnection;1228;0;1227;0
WireConnection;1228;1;1949;0
WireConnection;1727;0;1725;0
WireConnection;1727;1;1728;0
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;1491;1;1411;0
WireConnection;1491;6;1492;0
WireConnection;1752;158;1891;0
WireConnection;1752;183;1890;0
WireConnection;1752;5;1755;0
WireConnection;1950;0;1165;0
WireConnection;1950;1;1954;0
WireConnection;1755;0;1751;0
WireConnection;1565;0;1563;0
WireConnection;1565;1;1595;0
WireConnection;1390;0;1461;0
WireConnection;1390;1;1392;0
WireConnection;1822;0;1817;0
WireConnection;2043;0;2035;0
WireConnection;2043;1;2042;0
WireConnection;498;0;1459;0
WireConnection;473;0;428;0
WireConnection;1829;1;455;0
WireConnection;1829;0;1828;0
WireConnection;1748;0;1727;0
WireConnection;1227;0;1225;0
WireConnection;1227;1;1235;0
WireConnection;1227;2;1165;0
WireConnection;1555;0;1598;0
WireConnection;525;0;1829;0
WireConnection;525;1;526;0
WireConnection;1951;0;1225;0
WireConnection;1951;1;1953;0
WireConnection;1951;2;1950;0
WireConnection;1233;0;1232;0
WireConnection;1984;0;1957;0
WireConnection;506;0;504;0
WireConnection;1992;0;1985;0
WireConnection;499;0;498;0
WireConnection;1556;0;1568;0
WireConnection;1556;1;1569;0
WireConnection;1049;0;1050;0
WireConnection;1049;1;1161;0
WireConnection;2082;0;2090;0
WireConnection;2082;1;2076;0
WireConnection;2082;2;2084;0
WireConnection;2060;2;1405;0
WireConnection;2060;4;1376;0
WireConnection;2060;5;1609;0
ASEEND*/
//CHKSM=7499397167438D65B13517922F66C5F72BE8FB4B
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EnvironmentObjectsShader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_InOutBrumeTransition("InOutBrumeTransition", Range( 0 , 1)) = 0
		[Toggle(_LIGHTDEBUG_ON)] _LightDebug("LightDebug", Float) = 0
		[Toggle(_NORMALDEBUG_ON)] _NormalDebug("NormalDebug", Float) = 0
		[Toggle(_CUSTOMWORLDSPACENORMAL_ON)] _CustomWorldSpaceNormal("CustomWorldSpaceNormal?", Float) = 0
		_Object_Albedo_Texture("Object_Albedo_Texture", 2D) = "white" {}
		_Object_Normal_Texture("Object_Normal_Texture", 2D) = "white" {}
		_Object_Roughness_Texture("Object_Roughness_Texture", 2D) = "white" {}
		[Toggle(_OPACITYTEXTURE_ON)] _OpacityTexture("OpacityTexture?", Float) = 0
		_Object_Opacity_Texture("Object_Opacity_Texture", 2D) = "white" {}
		_TerrainBlending_TextureTerrain("TerrainBlending_TextureTerrain", 2D) = "white" {}
		_TerrainBlending_TextureTiling("TerrainBlending_TextureTiling", Float) = 1
		_TerrainBlending_BlendThickness("TerrainBlending_BlendThickness", Range( 0 , 30)) = 0
		_TerrainBlending_Falloff("TerrainBlending_Falloff", Range( 0 , 30)) = 0
		_TerrainBlendingNoise_Texture("TerrainBlendingNoise_Texture", 2D) = "white" {}
		_TerrainBlendingNoise_Tiling("TerrainBlendingNoise_Tiling", Vector) = (1,1,0,0)
		[Toggle(_MOVINGPAPER_ON)] _MovingPaper("MovingPaper?", Float) = 1
		_Paper_Texture("Paper_Texture", 2D) = "white" {}
		_Paper_Tiling("Paper_Tiling", Float) = 1
		_Paper_Flipbook_Columns("Paper_Flipbook_Columns", Float) = 1
		_Paper_Flipbook_Rows("Paper_Flipbook_Rows", Float) = 1
		_Paper_Flipbook_Speed("Paper_Flipbook_Speed", Float) = 1
		_PaperContrast("PaperContrast", Color) = (0.5660378,0.5660378,0.5660378,0)
		_PaperMultiply("PaperMultiply", Float) = 1.58
		_Noise_Tiling("Noise_Tiling", Float) = 1
		_InkGrunge_Texture("InkGrunge_Texture", 2D) = "white" {}
		_InkGrunge_Tiling("InkGrunge_Tiling", Float) = 1
		_Edge_Noise_Texture("Edge_Noise_Texture", 2D) = "white" {}
		[Toggle(_SCREENBASEDNOISE_ON)] _ScreenBasedNoise("ScreenBasedNoise?", Float) = 0
		_Noise_Panner("Noise_Panner", Vector) = (0.2,-0.1,0,0)
		_StepShadow("StepShadow", Float) = 0.03
		_StepAttenuation("StepAttenuation", Float) = 0.3
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		[Toggle(_SPECULAR_ON)] _Specular("Specular?", Float) = 1
		_SpeculartStepMin("SpeculartStepMin", Float) = 0
		_SpecularStepMax("SpecularStepMax", Float) = 1
		_SpecularNoise("SpecularNoise", Float) = 1
		_SpecularColor("SpecularColor", Color) = (0.9433962,0.8590411,0.6274475,0)
		_Roughness_Multiplier("Roughness_Multiplier", Float) = 1
		[Toggle(_SSS_ON)] _SSS("SSS?", Float) = 0
		_SSS_Distortion("SSS_Distortion", Range( 0 , 1)) = 0.8
		_SSS_Color("SSS_Color", Color) = (1,0,0,0)
		_SSS_Scale("SSS_Scale", Float) = 0.46
		_SSS_Power("SSS_Power", Float) = 0.25
		_OutBrumeColorCorrection("OutBrumeColorCorrection", Color) = (1,1,1,0)
		_ColorShadow("ColorShadow", Color) = (0.5283019,0.5283019,0.5283019,0)
		_InBrumeBackColor("InBrumeBackColor", Color) = (1,1,1,0)
		[Toggle(_INKSPLATTER_ON)] _InkSplatter("InkSplatter?", Float) = 0
		_InkSplatter_Texture("InkSplatter_Texture", 2D) = "white" {}
		_InkSplatter_Tiling("InkSplatter_Tiling", Float) = 1
		_DrippingNoiseTexture_Albedo("DrippingNoiseTexture_Albedo", 2D) = "white" {}
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
		_ShadowInBrumeGrunge_Tiling("ShadowInBrumeGrunge_Tiling", Vector) = (1,1,0,0)
		_ShadowInBrumeGrunge_Contrast("ShadowInBrumeGrunge_Contrast", Float) = -3.38
		_InBrumeGrunge_Texture("NormalInBrumeGrunge_Texture", 2D) = "white" {}
		_NormalInBrumeGrunge_Tiling("NormalInBrumeGrunge_Tiling", Vector) = (1,1,0,0)
		_NormalInBrumeGrunge_Contrast("NormalInBrumeGrunge_Contrast", Float) = 2.4
		_InBrumeColorCorrection("InBrumeColorCorrection", Color) = (1,1,1,0)
		[Toggle(_WINDVERTEXDISPLACEMENT_ON)] _WindVertexDisplacement("WindVertexDisplacement?", Float) = 0
		_Wind_Noise_Texture("Wind_Noise_Texture", 2D) = "white" {}
		_Wind_Texture_Tiling("Wind_Texture_Tiling", Float) = 0.5
		_Wind_Direction("Wind_Direction", Float) = 1
		_Wind_Density("Wind_Density", Float) = 0.2
		_Wind_Strength("Wind_Strength", Float) = 2
		_WindWave_Speed("WindWave_Speed", Vector) = (0.1,0,0,0)
		_WindWave_Min_Speed("WindWave_Min_Speed", Vector) = (0.05,0,0,0)
		_Wave_Speed("Wave_Speed", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Off
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _WINDVERTEXDISPLACEMENT_ON
		#pragma shader_feature_local _OPACITYTEXTURE_ON
		#pragma shader_feature_local _NORMALDEBUG_ON
		#pragma shader_feature_local _LIGHTDEBUG_ON
		#pragma shader_feature_local _SSS_ON
		#pragma shader_feature_local _SPECULAR_ON
		#pragma shader_feature_local _MOVINGPAPER_ON
		#pragma shader_feature_local _CUSTOMWORLDSPACENORMAL_ON
		#pragma shader_feature_local _SCREENBASEDNOISE_ON
		#pragma shader_feature_local _INKSPLATTER_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _Wind_Noise_Texture;
		uniform float _Wind_Texture_Tiling;
		uniform float _Wave_Speed;
		uniform float2 _WindWave_Speed;
		uniform float2 _WindWave_Min_Speed;
		uniform float _Wind_Direction;
		uniform float _Wind_Density;
		uniform float _Wind_Strength;
		uniform sampler2D _Object_Albedo_Texture;
		uniform sampler2D _Object_Opacity_Texture;
		uniform float4 _Object_Opacity_Texture_ST;
		uniform float4 _OutBrumeColorCorrection;
		uniform sampler2D _Object_Roughness_Texture;
		uniform float4 _Object_Roughness_Texture_ST;
		uniform float _Roughness_Multiplier;
		uniform float _SpeculartStepMin;
		uniform float _SpecularStepMax;
		uniform sampler2D _Object_Normal_Texture;
		uniform float4 _Object_Normal_Texture_ST;
		uniform sampler2D _Edge_Noise_Texture;
		uniform float _SpecularNoise;
		uniform float4 _SpecularColor;
		uniform sampler2D _TerrainBlending_TextureTerrain;
		uniform float _TerrainBlending_TextureTiling;
		uniform sampler2D _Paper_Texture;
		uniform float _Paper_Tiling;
		uniform float _Paper_Flipbook_Columns;
		uniform float _Paper_Flipbook_Rows;
		uniform float _Paper_Flipbook_Speed;
		uniform float4 _PaperContrast;
		uniform float _PaperMultiply;
		uniform sampler2D _InkGrunge_Texture;
		uniform float _InkGrunge_Tiling;
		uniform sampler2D TB_DEPTH;
		uniform float TB_OFFSET_X;
		uniform float TB_OFFSET_Z;
		uniform float TB_SCALE;
		uniform float TB_FARCLIP;
		uniform float TB_OFFSET_Y;
		uniform float _TerrainBlending_BlendThickness;
		uniform sampler2D _TerrainBlendingNoise_Texture;
		uniform float2 _TerrainBlendingNoise_Tiling;
		uniform float _TerrainBlending_Falloff;
		uniform float _StepShadow;
		uniform float _StepAttenuation;
		uniform float2 _Noise_Panner;
		uniform float _Noise_Tiling;
		uniform float4 _ShadowColor;
		uniform float4 _SSS_Color;
		uniform float _SSS_Distortion;
		uniform float _SSS_Scale;
		uniform float _SSS_Power;
		uniform float4 _InBrumeColorCorrection;
		uniform sampler2D _InkSplatter_Texture;
		uniform float _InkSplatter_Tiling;
		uniform sampler2D _DrippingNoiseTexture_Albedo;
		uniform float4 _DrippingNoiseTexture_Albedo_ST;
		uniform float4 _InBrumeBackColor;
		uniform float _ShadowDrippingNoise_Smoothstep;
		uniform float _ShadowDrippingNoise_Step;
		uniform float _DrippingNoise_Tiling;
		uniform float2 _ShadowDrippingNoise_Offset;
		uniform float _ShadowDrippingNoise_Transition;
		uniform float4 _ColorShadow;
		uniform float _ShadowInBrumeGrunge_Contrast;
		uniform sampler2D _InBrumeGrunge_Texture2;
		uniform float2 _ShadowInBrumeGrunge_Tiling;
		uniform float _NormalInBrumeGrunge_Contrast;
		uniform sampler2D _InBrumeGrunge_Texture;
		uniform float2 _NormalInBrumeGrunge_Tiling;
		uniform float _NormalDrippingNoise_Step;
		uniform float _NormalDrippingNoise_Smoothstep;
		uniform float _NormalDrippingNoise_Tiling;
		uniform float2 _NormalDrippingNoise_Offset;
		uniform float _InOutBrumeTransition;
		uniform float _Cutoff = 0.5;


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


		inline float4 TriplanarSampling1120( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline float4 TriplanarSampling1102( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 temp_cast_0 = (0.0).xxxx;
			float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
			float2 panner1312 = ( ( ( _CosTime.w + _Time.y ) * _Wave_Speed ) * _WindWave_Speed + float2( 0,0 ));
			float2 panner1313 = ( 1.0 * _Time.y * _WindWave_Min_Speed + float2( 0,0 ));
			float2 uv_TexCoord1319 = v.texcoord.xy * temp_cast_1 + ( ( panner1312 + panner1313 ) * _Wind_Direction );
			float4 temp_cast_2 = (( _Wind_Density * _SinTime.w )).xxxx;
			float4 temp_cast_3 = (0.0).xxxx;
			float4 lerpResult1328 = lerp( ( ( ( tex2Dlod( _Wind_Noise_Texture, float4( uv_TexCoord1319, 0, 0.0) ) - temp_cast_2 ) * _Wind_Strength ) + float4( 0,0,0,0 ) ) , temp_cast_3 , v.color);
			float4 WindVertexDisplacement1330 = lerpResult1328;
			#ifdef _WINDVERTEXDISPLACEMENT_ON
				float4 staticSwitch1333 = WindVertexDisplacement1330;
			#else
				float4 staticSwitch1333 = temp_cast_0;
			#endif
			v.vertex.xyz += staticSwitch1333.rgb;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float4 tex2DNode426 = tex2D( _Object_Albedo_Texture, i.uv_texcoord );
			float4 Object_Albedo878 = tex2DNode426;
			float4 temp_cast_0 = (Object_Albedo878.a).xxxx;
			float2 uv_Object_Opacity_Texture = i.uv_texcoord * _Object_Opacity_Texture_ST.xy + _Object_Opacity_Texture_ST.zw;
			#ifdef _OPACITYTEXTURE_ON
				float4 staticSwitch1380 = tex2D( _Object_Opacity_Texture, uv_Object_Opacity_Texture );
			#else
				float4 staticSwitch1380 = temp_cast_0;
			#endif
			float4 Opacity1375 = staticSwitch1380;
			float4 temp_output_1376_0 = Opacity1375;
			float2 uv_Object_Roughness_Texture = i.uv_texcoord * _Object_Roughness_Texture_ST.xy + _Object_Roughness_Texture_ST.zw;
			float4 temp_output_522_0 = ( tex2D( _Object_Roughness_Texture, uv_Object_Roughness_Texture ) * _Roughness_Multiplier );
			float4 temp_cast_4 = (0.0).xxxx;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g9 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float2 uv_Object_Normal_Texture = i.uv_texcoord * _Object_Normal_Texture_ST.xy + _Object_Normal_Texture_ST.zw;
			float3 normalizeResult499 = normalize( (WorldNormalVector( i , tex2D( _Object_Normal_Texture, uv_Object_Normal_Texture ).rgb )) );
			float dotResult504 = dot( normalizeResult4_g9 , normalizeResult499 );
			float smoothstepResult632 = smoothstep( _SpeculartStepMin , _SpecularStepMax , max( dotResult504 , 0.0 ));
			float4 temp_cast_6 = (smoothstepResult632).xxxx;
			float2 temp_cast_7 = (_SpecularNoise).xx;
			float2 uv_TexCoord626 = i.uv_texcoord * temp_cast_7;
			float grayscale634 = Luminance(step( ( temp_cast_6 - tex2D( _Edge_Noise_Texture, uv_TexCoord626 ) ) , float4( 0,0,0,0 ) ).rgb);
			#ifdef _SPECULAR_ON
				float4 staticSwitch647 = ( (0.0 + (grayscale634 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) * _SpecularColor );
			#else
				float4 staticSwitch647 = temp_cast_4;
			#endif
			float2 temp_cast_9 = (_TerrainBlending_TextureTiling).xx;
			float2 uv_TexCoord1373 = i.uv_texcoord * temp_cast_9;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 temp_output_466_0 = ( (ase_screenPosNorm).xy * _Paper_Tiling );
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles664 = _Paper_Flipbook_Columns * _Paper_Flipbook_Rows;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset664 = 1.0f / _Paper_Flipbook_Columns;
			float fbrowsoffset664 = 1.0f / _Paper_Flipbook_Rows;
			// Speed of animation
			float fbspeed664 = _Time.y * _Paper_Flipbook_Speed;
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
			#ifdef _MOVINGPAPER_ON
				float2 staticSwitch671 = fbuv664;
			#else
				float2 staticSwitch671 = temp_output_466_0;
			#endif
			float grayscale455 = Luminance(tex2D( _Paper_Texture, staticSwitch671 ).rgb);
			float localStochasticTiling2_g10 = ( 0.0 );
			float2 temp_cast_11 = (_InkGrunge_Tiling).xx;
			float2 uv_TexCoord1384 = i.uv_texcoord * temp_cast_11;
			float2 Input_UV145_g10 = uv_TexCoord1384;
			float2 UV2_g10 = Input_UV145_g10;
			float2 UV12_g10 = float2( 0,0 );
			float2 UV22_g10 = float2( 0,0 );
			float2 UV32_g10 = float2( 0,0 );
			float W12_g10 = 0.0;
			float W22_g10 = 0.0;
			float W32_g10 = 0.0;
			StochasticTiling( UV2_g10 , UV12_g10 , UV22_g10 , UV32_g10 , W12_g10 , W22_g10 , W32_g10 );
			float2 temp_output_10_0_g10 = ddx( Input_UV145_g10 );
			float2 temp_output_12_0_g10 = ddy( Input_UV145_g10 );
			float4 Output_2D293_g10 = ( ( tex2D( _InkGrunge_Texture, UV12_g10, temp_output_10_0_g10, temp_output_12_0_g10 ) * W12_g10 ) + ( tex2D( _InkGrunge_Texture, UV22_g10, temp_output_10_0_g10, temp_output_12_0_g10 ) * W22_g10 ) + ( tex2D( _InkGrunge_Texture, UV32_g10, temp_output_10_0_g10, temp_output_12_0_g10 ) * W32_g10 ) );
			float4 blendOpSrc461 = ( ( ( grayscale455 + _PaperContrast ) * _PaperMultiply ) * Output_2D293_g10 );
			float4 blendOpDest461 = tex2DNode426;
			float4 RGB1366 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
			float worldY1344 = ase_worldPos.y;
			float4 temp_cast_12 = (worldY1344).xxxx;
			float2 appendResult1340 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult1339 = (float2(TB_OFFSET_X , TB_OFFSET_Z));
			float4 temp_cast_13 = (TB_OFFSET_Y).xxxx;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar1360 = TriplanarSampling1360( _TerrainBlendingNoise_Texture, ase_worldPos, ase_worldNormal, 1.0, _TerrainBlendingNoise_Tiling, 1.0, 0 );
			float4 clampResult1354 = clamp( ( ( ( temp_cast_12 - ( tex2D( TB_DEPTH, ( ( appendResult1340 - appendResult1339 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_13 ) / ( _TerrainBlending_BlendThickness * triplanar1360 ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 temp_cast_15 = (_TerrainBlending_Falloff).xxxx;
			float4 clampResult1356 = clamp( pow( clampResult1354 , temp_cast_15 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 lerpResult1358 = lerp( tex2D( _TerrainBlending_TextureTerrain, uv_TexCoord1373 ) , RGB1366 , clampResult1356.r);
			float4 RBG_TerrainBlending1368 = lerpResult1358;
			float temp_output_387_0 = ( _StepShadow + _StepAttenuation );
			#ifdef _CUSTOMWORLDSPACENORMAL_ON
				float4 staticSwitch575 = tex2D( _Object_Normal_Texture, uv_Object_Normal_Texture );
			#else
				float4 staticSwitch575 = float4( float3(0,0,1) , 0.0 );
			#endif
			float dotResult12 = dot( (WorldNormalVector( i , staticSwitch575.rgb )) , ase_worldlightDir );
			float normal_LightDir23 = ( dotResult12 * ase_lightAtten );
			float smoothstepResult385 = smoothstep( _StepShadow , temp_output_387_0 , normal_LightDir23);
			float2 temp_cast_18 = (_Noise_Tiling).xx;
			float2 uv_TexCoord565 = i.uv_texcoord * temp_cast_18;
			#ifdef _SCREENBASEDNOISE_ON
				float2 staticSwitch564 = ( (ase_screenPosNorm).xy * _Noise_Tiling );
			#else
				float2 staticSwitch564 = uv_TexCoord565;
			#endif
			float2 panner571 = ( 1.0 * _Time.y * ( _Noise_Panner + float2( 0.1,0.05 ) ) + staticSwitch564);
			float2 panner484 = ( 1.0 * _Time.y * _Noise_Panner + staticSwitch564);
			float blendOpSrc570 = tex2D( _Edge_Noise_Texture, ( panner571 + float2( 0.5,0.5 ) ) ).r;
			float blendOpDest570 = tex2D( _Edge_Noise_Texture, panner484 ).r;
			float MapNoise481 = ( saturate( 2.0f*blendOpDest570*blendOpSrc570 + blendOpDest570*blendOpDest570*(1.0f - 2.0f*blendOpSrc570) ));
			float smoothstepResult401 = smoothstep( 0.0 , 0.6 , ( smoothstepResult385 - MapNoise481 ));
			float smoothstepResult445 = smoothstep( ( _StepShadow + -0.02 ) , ( temp_output_387_0 + -0.02 ) , normal_LightDir23);
			float blendOpSrc444 = smoothstepResult401;
			float blendOpDest444 = smoothstepResult445;
			float4 temp_cast_19 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest444) / max( blendOpSrc444, 0.00001) ) ) ))).xxxx;
			float4 blendOpSrc449 = temp_cast_19;
			float4 blendOpDest449 = _ShadowColor;
			float4 temp_output_449_0 = ( saturate( ( blendOpSrc449 * blendOpDest449 ) ));
			float4 temp_output_562_0 = step( temp_output_449_0 , float4( 0,0,0,0 ) );
			float4 Shadow877 = ( temp_output_562_0 + temp_output_449_0 );
			float4 blendOpSrc428 = RBG_TerrainBlending1368;
			float4 blendOpDest428 = Shadow877;
			float4 temp_output_518_0 = ( ( float4( (temp_output_522_0).rgb , 0.0 ) * (temp_output_522_0).a * staticSwitch647 ) + float4( (( saturate( ( blendOpSrc428 * blendOpDest428 ) ))).rgb , 0.0 ) );
			float dotResult1283 = dot( ase_worldViewDir , -( ase_worldlightDir + ( (WorldNormalVector( i , tex2D( _Object_Normal_Texture, uv_Object_Normal_Texture ).rgb )) * _SSS_Distortion ) ) );
			float dotResult1293 = dot( dotResult1283 , _SSS_Scale );
			float saferPower1296 = max( dotResult1293 , 0.0001 );
			float4 SSS1275 = ( _SSS_Color * saturate( pow( saferPower1296 , _SSS_Power ) ) );
			float4 blendOpSrc1290 = temp_output_518_0;
			float4 blendOpDest1290 = SSS1275;
			#ifdef _SSS_ON
				float4 staticSwitch1273 = ( saturate( 	max( blendOpSrc1290, blendOpDest1290 ) ));
			#else
				float4 staticSwitch1273 = temp_output_518_0;
			#endif
			float4 EndOutBrume473 = ( _OutBrumeColorCorrection * staticSwitch1273 );
			float4 temp_cast_24 = (1.0).xxxx;
			float2 temp_cast_25 = (_InkSplatter_Tiling).xx;
			float2 uv_TexCoord1053 = i.uv_texcoord * temp_cast_25;
			float4 temp_cast_26 = (0.5).xxxx;
			float4 temp_output_1058_0 = step( tex2D( _InkSplatter_Texture, uv_TexCoord1053 ) , temp_cast_26 );
			float4 temp_cast_27 = (0.5).xxxx;
			float2 uv_DrippingNoiseTexture_Albedo = i.uv_texcoord * _DrippingNoiseTexture_Albedo_ST.xy + _DrippingNoiseTexture_Albedo_ST.zw;
			#ifdef _INKSPLATTER_ON
				float4 staticSwitch1084 = ( ( 1.0 - temp_output_1058_0 ) + ( temp_output_1058_0 * tex2D( _DrippingNoiseTexture_Albedo, uv_DrippingNoiseTexture_Albedo ) ) );
			#else
				float4 staticSwitch1084 = temp_cast_24;
			#endif
			float4 InkSplatter1244 = staticSwitch1084;
			float smoothstepResult1227 = smoothstep( ( _ShadowDrippingNoise_Smoothstep + _ShadowDrippingNoise_Step ) , _ShadowDrippingNoise_Step , normal_LightDir23);
			float4 temp_cast_28 = (smoothstepResult1227).xxxx;
			float2 temp_cast_29 = (_DrippingNoise_Tiling).xx;
			float2 uv_TexCoord1203 = i.uv_texcoord * temp_cast_29 + _ShadowDrippingNoise_Offset;
			float4 temp_output_1228_0 = ( temp_cast_28 - tex2D( _DrippingNoiseTexture_Albedo, uv_TexCoord1203 ) );
			float4 temp_cast_30 = (step( normal_LightDir23 , _ShadowDrippingNoise_Step )).xxxx;
			float4 blendOpSrc1231 = temp_output_1228_0;
			float4 blendOpDest1231 = temp_cast_30;
			float4 temp_cast_31 = (smoothstepResult1227).xxxx;
			float4 lerpBlendMode1231 = lerp(blendOpDest1231,	max( blendOpSrc1231, blendOpDest1231 ),( 1.0 - step( temp_output_1228_0 , float4( 0,0,0,0 ) ) ).r);
			float4 temp_cast_33 = (step( normal_LightDir23 , _ShadowDrippingNoise_Step )).xxxx;
			float4 lerpResult1220 = lerp( ( saturate( lerpBlendMode1231 )) , temp_cast_33 , _ShadowDrippingNoise_Transition);
			float4 ShadowDrippingNoise1240 = lerpResult1220;
			float4 triplanar1120 = TriplanarSampling1120( _InBrumeGrunge_Texture2, ase_worldPos, ase_worldNormal, 1.0, _ShadowInBrumeGrunge_Tiling, 1.0, 0 );
			float grayscale1119 = Luminance(CalculateContrast(_ShadowInBrumeGrunge_Contrast,triplanar1120).rgb);
			float ShadowInBrumeGrunge1246 = grayscale1119;
			float4 blendOpSrc1162 = ( InkSplatter1244 * ( _InBrumeBackColor * ( 1.0 - ShadowDrippingNoise1240 ).r ) );
			float4 blendOpDest1162 = ( _ColorShadow * ( ShadowDrippingNoise1240 * ShadowInBrumeGrunge1246 ) );
			float4 triplanar1102 = TriplanarSampling1102( _InBrumeGrunge_Texture, ase_worldPos, ase_worldNormal, 1.0, _NormalInBrumeGrunge_Tiling, 1.0, 0 );
			float grayscale1115 = Luminance(CalculateContrast(_NormalInBrumeGrunge_Contrast,triplanar1102).rgb);
			float NormalInBrumeGrunge1247 = grayscale1115;
			float grayscale1105 = (tex2D( _Object_Normal_Texture, i.uv_texcoord ).rgb.r + tex2D( _Object_Normal_Texture, i.uv_texcoord ).rgb.g + tex2D( _Object_Normal_Texture, i.uv_texcoord ).rgb.b) / 3;
			float temp_output_1106_0 = step( grayscale1105 , _NormalDrippingNoise_Step );
			float smoothstepResult1179 = smoothstep( _NormalDrippingNoise_Step , ( _NormalDrippingNoise_Step + _NormalDrippingNoise_Smoothstep ) , grayscale1105);
			float4 temp_cast_39 = (( 1.0 - smoothstepResult1179 )).xxxx;
			float2 temp_cast_40 = (_NormalDrippingNoise_Tiling).xx;
			float2 uv_TexCoord1184 = i.uv_texcoord * temp_cast_40 + _NormalDrippingNoise_Offset;
			float4 temp_output_1186_0 = ( temp_output_1106_0 + ( temp_cast_39 - tex2D( _DrippingNoiseTexture_Albedo, uv_TexCoord1184 ) ) );
			float4 temp_cast_41 = (( 1.0 - smoothstepResult1179 )).xxxx;
			float4 blendOpSrc1189 = ( NormalInBrumeGrunge1247 * temp_output_1186_0 );
			float4 blendOpDest1189 = ( 1.0 - temp_output_1186_0 );
			float4 lerpBlendMode1189 = lerp(blendOpDest1189,	max( blendOpSrc1189, blendOpDest1189 ),temp_output_1106_0);
			float4 NormalDrippingGrunge1251 = ( saturate( lerpBlendMode1189 ));
			float4 EndInBrume901 = ( _InBrumeColorCorrection * (float4( 0,0,0,0 ) + (( 	max( blendOpSrc1162, blendOpDest1162 ) * NormalDrippingGrunge1251 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) );
			float4 lerpResult955 = lerp( EndOutBrume473 , EndInBrume901 , _InOutBrumeTransition);
			float4 temp_cast_42 = (normal_LightDir23).xxxx;
			#ifdef _LIGHTDEBUG_ON
				float4 staticSwitch580 = temp_cast_42;
			#else
				float4 staticSwitch580 = lerpResult955;
			#endif
			#ifdef _NORMALDEBUG_ON
				float4 staticSwitch1302 = tex2D( _Object_Normal_Texture, uv_Object_Normal_Texture );
			#else
				float4 staticSwitch1302 = staticSwitch580;
			#endif
			c.rgb = staticSwitch1302.rgb;
			c.a = temp_output_1376_0.r;
			clip( temp_output_1376_0.r - _Cutoff );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 screenPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
0;0;1920;1019;6387.592;5268.179;2.800324;True;False
Node;AmplifyShaderEditor.CommentaryNode;824;-6916.299,-4815.77;Inherit;False;6399.167;6501.159;OUT BRUME;19;473;842;1273;841;1290;518;1276;513;428;1301;471;520;468;31;521;1366;1369;1370;1371;;1,0.7827643,0.5518868,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;521;-4914.711,-4765.77;Inherit;False;2866.093;613.3671;Noise;16;570;481;566;476;572;571;484;487;564;565;477;480;479;478;573;825;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-4802.711,-4429.77;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;31;-6882.713,-4765.77;Inherit;False;1788.085;588.8215;Normal Light Dir;9;23;12;10;11;575;576;710;711;519;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;468;-6889.708,-4018.677;Inherit;False;3795.438;989.2273;Paper + Object Texture;25;466;465;463;464;878;461;530;426;427;525;839;460;526;458;455;454;671;664;670;665;666;667;1382;1384;1385;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;576;-6802.713,-4605.769;Inherit;False;Constant;_Vector0;Vector 0;25;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;479;-4610.711,-4349.77;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;24;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;519;-6682.727,-4404.447;Inherit;True;Property;_Object_Normal_Texture;Object_Normal_Texture;7;0;Create;True;0;0;False;0;False;-1;2418409f260e65a4baa4d7d8b8b8a53e;2418409f260e65a4baa4d7d8b8b8a53e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;480;-4594.711,-4429.77;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1371;-6870.396,180.6709;Inherit;False;3849.702;1403.809;TerrainBlending;34;1368;1367;1365;1364;1363;1362;1361;1360;1359;1358;1357;1356;1355;1354;1353;1352;1351;1350;1349;1348;1347;1346;1345;1344;1343;1342;1341;1340;1339;1338;1337;1336;1373;1374;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;825;-4584.271,-4620.198;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;26;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1336;-6826.618,779.6337;Inherit;False;Global;TB_OFFSET_X;TB_OFFSET_X;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1338;-6828.269,624.8928;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-6850.376,-3787.739;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-4370.708,-4429.77;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;565;-4370.708,-4637.769;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1337;-6824.052,857.9096;Inherit;False;Global;TB_OFFSET_Z;TB_OFFSET_Z;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;487;-3922.708,-4301.77;Inherit;False;Property;_Noise_Panner;Noise_Panner;30;0;Create;True;0;0;False;0;False;0.2,-0.1;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;575;-6498.713,-4605.769;Inherit;False;Property;_CustomWorldSpaceNormal;CustomWorldSpaceNormal?;5;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;1340;-6484.001,721.8892;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;1339;-6484.001,852.7767;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;564;-4002.708,-4461.77;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;29;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;572;-3698.707,-4605.769;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;463;-6642.376,-3707.739;Inherit;False;Property;_Paper_Tiling;Paper_Tiling;19;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-6178.713,-4477.77;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;10;-6162.713,-4621.769;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;465;-6626.376,-3787.739;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;666;-6436.423,-3444.986;Inherit;False;Property;_Paper_Flipbook_Rows;Paper_Flipbook_Rows;21;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1342;-6246.607,759.1023;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;571;-3538.707,-4637.769;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1254;-6980.338,1944.485;Inherit;False;5649.46;3565.475;IN BRUME;23;901;1223;1014;1162;1252;1039;988;989;1049;1245;1118;1248;1241;1050;1161;1158;1242;1253;1250;1086;1243;1255;1256;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;710;-5890.713,-4349.77;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;665;-6452.423,-3524.986;Inherit;False;Property;_Paper_Flipbook_Columns;Paper_Flipbook_Columns;20;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;667;-6436.423,-3364.986;Inherit;False;Property;_Paper_Flipbook_Speed;Paper_Flipbook_Speed;22;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-6418.376,-3787.739;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1341;-6231.208,870.7417;Inherit;False;Global;TB_SCALE;TB_SCALE;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;670;-6256.423,-3213.986;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-5906.713,-4621.769;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;664;-6020.423,-3332.986;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;711;-5618.712,-4621.769;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;484;-3698.707,-4381.77;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;573;-3266.71,-4637.769;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1343;-5992.531,759.1024;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;1243;-6920.78,2940.559;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;19;1194;1240;1220;1219;1221;1218;1231;1224;1233;1232;1228;1236;1227;1225;1235;1203;1230;1165;1164;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1230;-6743.761,3213.712;Inherit;False;Property;_ShadowDrippingNoise_Smoothstep;ShadowDrippingNoise_Smoothstep;53;0;Create;True;0;0;False;0;False;0.2;0.01;0.001;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1164;-6846.286,3482.561;Inherit;False;Property;_DrippingNoise_Tiling;ShadowDrippingNoise_Tiling;55;0;Create;False;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;566;-3058.71,-4653.769;Inherit;True;Property;_TextureSample0;Texture Sample 0;28;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;476;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;471;-6877.425,-2735.973;Inherit;False;3265.324;1087.017;Shadow Smooth Edge + Int Shadow;20;877;563;768;562;449;444;450;401;445;397;446;447;470;385;448;482;469;387;388;386;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;476;-3058.71,-4413.77;Inherit;True;Property;_Edge_Noise_Texture;Edge_Noise_Texture;28;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-5330.712,-4637.769;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;671;-5596.681,-3917.423;Inherit;True;Property;_MovingPaper;MovingPaper?;17;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;1194;-6851.78,3570.637;Inherit;False;Property;_ShadowDrippingNoise_Offset;ShadowDrippingNoise_Offset;56;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;1346;-5780.514,692.9767;Inherit;True;Global;TB_DEPTH;TB_DEPTH;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1345;-5676.067,894.5427;Inherit;False;Global;TB_FARCLIP;TB_FARCLIP;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1344;-6507.099,620.5154;Inherit;False;worldY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;520;-6891.235,-1611.381;Inherit;False;3548.808;1021.013;Add Rougness and Normal;26;632;633;619;506;504;499;500;498;656;522;523;502;512;647;509;508;639;623;636;634;640;630;625;626;627;827;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1165;-6737.604,3300.286;Inherit;False;Property;_ShadowDrippingNoise_Step;ShadowDrippingNoise_Step;54;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1359;-5710.977,1275.756;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;454;-5300.422,-3940.986;Inherit;True;Property;_Paper_Texture;Paper_Texture;18;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;827;-6809.4,-831.4996;Inherit;True;Property;_TextureSample5;Texture Sample 5;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1362;-5638.729,1072.689;Inherit;True;Property;_TerrainBlendingNoise_Texture;TerrainBlendingNoise_Texture;15;0;Create;True;0;0;False;0;False;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;1203;-6540.115,3503.018;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1361;-5583.878,1435.046;Inherit;False;Property;_TerrainBlendingNoise_Tiling;TerrainBlendingNoise_Tiling;16;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;1235;-6365.943,3244.121;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;570;-2594.71,-4413.77;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-6845.425,-2079.973;Inherit;False;Property;_StepShadow;StepShadow;31;0;Create;True;0;0;False;0;False;0.03;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-6413.425,-2415.974;Inherit;False;Property;_StepAttenuation;StepAttenuation;32;0;Create;True;0;0;False;0;False;0.3;-0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1348;-5401.835,703.1845;Inherit;False;1344;worldY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1347;-5421.423,825.2318;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1225;-6498.423,2990.559;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1227;-6193.028,3220.673;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-6333.425,-2671.973;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;455;-4948.422,-3940.986;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TriplanarNode;1360;-5297.8,1252.484;Inherit;True;Spherical;World;False;Top Texture 3;_TopTexture3;white;0;None;Mid Texture 3;_MidTexture3;white;-1;None;Bot Texture 3;_BotTexture3;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;458;-4740.422,-3844.986;Inherit;False;Property;_PaperContrast;PaperContrast;23;0;Create;True;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0.5019608,0.5019608,0.5019608,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1349;-5157.74,896.0496;Inherit;False;Global;TB_OFFSET_Y;TB_OFFSET_Y;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1363;-5186.901,1024.23;Inherit;False;Property;_TerrainBlending_BlendThickness;TerrainBlending_BlendThickness;13;0;Create;True;0;0;False;0;False;0;0;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1301;-6878.063,-558.6816;Inherit;False;3450.197;700.3971;SSS;17;1277;1264;1286;1281;1287;1289;1285;1284;1283;1294;1293;1300;1296;1272;1299;1270;1275;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-2274.71,-4397.77;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-6221.425,-2431.974;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1350;-5172.808,778.5225;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1385;-4792.233,-3241.048;Inherit;False;Property;_InkGrunge_Tiling;InkGrunge_Tiling;27;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1236;-6294.662,3474.688;Inherit;True;Property;_DrippingNoiseTexture_Albedo;DrippingNoiseTexture_Albedo;51;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;498;-6459.222,-810.214;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;448;-6077.424,-2079.973;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1228;-5912.801,3387.108;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;460;-4484.421,-3924.986;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;500;-6347.222,-1002.214;Inherit;False;Blinn-Phong Half Vector;-1;;9;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-6061.424,-2671.973;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;499;-6251.222,-810.214;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;482;-5805.424,-2495.973;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-4308.421,-3700.986;Inherit;False;Property;_PaperMultiply;PaperMultiply;25;0;Create;True;0;0;False;0;False;1.58;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1352;-5004.051,775.509;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1351;-4836.511,1069.253;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;1086;-6911.383,1994.485;Inherit;False;2193.24;919.6926;InkSplatter;12;1244;1084;1125;1126;1060;1058;1123;1051;1059;1053;1054;1085;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;1277;-6828.063,-199.2758;Inherit;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1250;-6925.237,4535.97;Inherit;False;3114.2;902.8672;NormalDrippingGrunge;20;1249;1189;1188;1111;1186;1187;1106;1180;1185;1184;1179;1193;1181;1191;1105;1109;1182;1108;1107;1251;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1384;-4593.511,-3260.155;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;839;-4656.394,-3478.057;Inherit;True;Property;_InkGrunge_Texture;InkGrunge_Texture;26;0;Create;True;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;470;-5901.424,-2239.973;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1232;-5670.148,3610.878;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-5869.424,-2031.973;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-5581.424,-2671.973;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;504;-6091.222,-906.2142;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-5869.424,-2127.973;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;627;-5906.713,-875.3809;Inherit;False;Property;_SpecularNoise;SpecularNoise;37;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;1353;-4603.403,774.0499;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1054;-6861.383,2212.645;Inherit;False;Property;_InkSplatter_Tiling;InkSplatter_Tiling;50;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1107;-6875.237,4614.67;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-4116.419,-3844.986;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1253;-6930.338,3910.093;Inherit;False;2088.706;597.0554;InBrumeGrunge;14;1195;1121;1117;1120;1116;1119;1246;1103;1102;1114;1113;1115;1104;1247;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;427;-4006.916,-3193.709;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;1286;-6493.436,-146.7742;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FunctionNode;1382;-4246.135,-3473.979;Inherit;False;Procedural Sample;-1;;10;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1264;-6596.703,25.71552;Inherit;False;Property;_SSS_Distortion;SSS_Distortion;41;0;Create;True;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;633;-5947.222,-1258.214;Inherit;False;Property;_SpecularStepMax;SpecularStepMax;36;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1108;-6404.386,4877.974;Inherit;False;Property;_NormalDrippingNoise_Step;NormalDrippingNoise_Step;58;0;Create;True;0;0;False;0;False;0.45;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-5357.423,-2671.973;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1182;-6423.519,4978.346;Inherit;False;Property;_NormalDrippingNoise_Smoothstep;NormalDrippingNoise_Smoothstep;57;0;Create;True;0;0;False;0;False;0.01;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;1354;-4405.749,776.703;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1104;-6872.361,4247.235;Inherit;True;Property;_InBrumeGrunge_Texture;NormalInBrumeGrunge_Texture;64;0;Create;False;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1287;-6231.897,-71.50958;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1281;-6272.189,-265.3126;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;1103;-6561.273,4342.942;Inherit;False;Property;_NormalInBrumeGrunge_Tiling;NormalInBrumeGrunge_Tiling;65;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;619;-5947.222,-1338.215;Inherit;False;Property;_SpeculartStepMin;SpeculartStepMin;35;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1233;-5464.148,3610.878;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;506;-6075.222,-1082.214;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1053;-6646.943,2194.238;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-3718.918,-3513.709;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1109;-6640.749,4586.268;Inherit;True;Property;_TextureSample4;Texture Sample 4;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1364;-4498.606,602.9265;Inherit;False;Property;_TerrainBlending_Falloff;TerrainBlending_Falloff;14;0;Create;True;0;0;False;0;False;0;0;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-5661.424,-2159.973;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;626;-5746.713,-891.3809;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;1224;-6178.779,2995.659;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1218;-5010.924,3365.318;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;426;-3766.918,-3257.709;Inherit;True;Property;_Object_Albedo_Texture;Object_Albedo_Texture;6;0;Create;True;0;0;False;0;False;-1;6395db2a80729484b931cff6723fa89f;6395db2a80729484b931cff6723fa89f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1121;-6574.388,4055.403;Inherit;False;Property;_ShadowInBrumeGrunge_Tiling;ShadowInBrumeGrunge_Tiling;62;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1114;-5901.799,4345.385;Inherit;False;Property;_NormalInBrumeGrunge_Contrast;NormalInBrumeGrunge_Contrast;66;0;Create;True;0;0;False;0;False;2.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1221;-4803.936,3020.639;Inherit;False;Property;_ShadowDrippingNoise_Transition;ShadowDrippingNoise_Transition;52;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;450;-5037.422,-1839.973;Inherit;False;Property;_ShadowColor;ShadowColor;33;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.462264,0.462264,0.462264,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1191;-6146.903,5198.105;Inherit;False;Property;_NormalDrippingNoise_Tiling;NormalDrippingNoise_Tiling;59;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1374;-4449.888,293.2512;Inherit;False;Property;_TerrainBlending_TextureTiling;TerrainBlending_TextureTiling;12;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;632;-5611.221,-1354.215;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1195;-6880.338,3961.271;Inherit;True;Property;_InBrumeGrunge_Texture2;ShadowInBrumeGrunge_Texture;61;0;Create;False;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;1181;-6091.208,4974.545;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1193;-6153.605,5285.56;Inherit;False;Property;_NormalDrippingNoise_Offset;NormalDrippingNoise_Offset;60;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BlendOpsNode;461;-3382.916,-3465.709;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TriplanarNode;1102;-6280.132,4251.465;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1059;-6262.503,2044.485;Inherit;False;Constant;_Float3;Float 3;53;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1051;-6415.396,2164.954;Inherit;True;Property;_InkSplatter_Texture;InkSplatter_Texture;49;0;Create;True;0;0;False;0;False;-1;5392ce4f46828c142999c3edf442f7a7;5392ce4f46828c142999c3edf442f7a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1105;-6312.736,4585.97;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;444;-5309.423,-2159.973;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1231;-5186.684,3107.166;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;1355;-4173.604,774.0499;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1289;-5952.62,-256.4405;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;625;-5522.712,-939.3809;Inherit;True;Property;_TextureSample1;Texture Sample 1;28;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;476;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;1219;-4793.683,3371.018;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1184;-5872.022,5242.526;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;449;-4893.42,-2159.973;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1113;-5652.575,4253.147;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;1285;-5743.11,-432.9257;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;1117;-5882.526,4064.547;Inherit;False;Property;_ShadowInBrumeGrunge_Contrast;ShadowInBrumeGrunge_Contrast;63;0;Create;True;0;0;False;0;False;-3.38;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;1284;-5804.35,-255.1147;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;1123;-6188.729,2674.979;Inherit;True;Property;_TextureSample6;Texture Sample 6;51;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1236;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;1335;-470.3166,-4816.195;Inherit;False;3603.017;815.9397;VertexColor WindDisplacement;27;1305;1306;1308;1307;1311;1310;1309;1312;1313;1315;1314;1317;1316;1319;1318;1321;1323;1322;1325;1324;1326;1329;1327;1328;1304;1330;1320;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;1220;-4499.733,3247;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;1058;-6114.503,2171.485;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1179;-5692.358,4908.864;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1373;-4160.888,274.2512;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;630;-5202.712,-1035.381;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1366;-3065.353,-3464.853;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TriplanarNode;1120;-6264.167,3967.063;Inherit;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;1356;-3982.175,772.593;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1115;-5410.149,4247.845;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosTime;1305;-402.6676,-4661.785;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;1306;-420.3165,-4459.916;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;640;-4994.712,-1035.381;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1357;-3787.558,773.3984;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleContrastOpNode;1116;-5580.3,3967.309;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1185;-5652.088,5213.981;Inherit;True;Property;_TextureSample8;Texture Sample 8;51;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Instance;1236;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;562;-4525.421,-2479.974;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1240;-4301.892,3195.385;Inherit;False;ShadowDrippingNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1180;-5451.902,4909.308;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1365;-3939.213,245.2369;Inherit;True;Property;_TerrainBlending_TextureTerrain;TerrainBlending_TextureTerrain;11;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;1060;-5840.503,2173.485;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1367;-3853.389,484.6932;Inherit;True;1366;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1294;-5444.121,-164.3371;Inherit;False;Property;_SSS_Scale;SSS_Scale;43;0;Create;True;0;0;False;0;False;0.46;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1283;-5538.968,-280.4821;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1126;-5872.971,2456.595;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1125;-5474.971,2366.595;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1300;-4850.939,-190.1794;Inherit;False;Property;_SSS_Power;SSS_Power;44;0;Create;True;0;0;False;0;False;0.25;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1085;-5427.473,2053.683;Inherit;False;Constant;_Float5;Float 5;59;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1247;-5172.13,4247.697;Inherit;False;NormalInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1358;-3473.299,633.8148;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1187;-5217.712,5100.008;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;563;-4109.423,-2175.973;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;634;-4834.711,-1035.381;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1242;-4044.614,2563.442;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1119;-5329.916,3961.428;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1106;-5676.601,4657.039;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;1293;-5259.482,-278.4442;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1308;5.62438,-4419.486;Inherit;False;Property;_Wave_Speed;Wave_Speed;76;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1307;-240.3164,-4510.916;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1311;85.48931,-4652.069;Inherit;False;Property;_WindWave_Speed;WindWave_Speed;74;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCRemapNode;636;-4594.711,-1035.381;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1246;-5113.632,3960.092;Inherit;False;ShadowInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1158;-3775.981,2569.454;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;502;-4419.71,-1390.381;Inherit;True;Property;_Object_Roughness_Texture;Object_Roughness_Texture;8;0;Create;True;0;0;False;0;False;-1;e3ffd422ed294bf4b8c909ae388edf91;462e6eb6ea263d24c9aa2becc5fa3ffa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;623;-4418.71,-923.3809;Inherit;False;Property;_SpecularColor;SpecularColor;38;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.9433962,0.8590411,0.6274475,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1310;-12.98743,-4164.255;Inherit;False;Property;_WindWave_Min_Speed;WindWave_Min_Speed;75;0;Create;True;0;0;False;0;False;0.05,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;1084;-5269.473,2143.952;Inherit;False;Property;_InkSplatter;InkSplatter?;48;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1186;-4969.09,4955.453;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;523;-4387.71,-1182.381;Inherit;False;Property;_Roughness_Multiplier;Roughness_Multiplier;39;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1309;196.6714,-4497.011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;1296;-4672.864,-276.3842;Inherit;True;True;2;0;FLOAT;0;False;1;FLOAT;6.34;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;-3285.567,627.3749;Inherit;False;RBG_TerrainBlending;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;877;-3814.617,-2180.626;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1249;-4973.673,4656.16;Inherit;False;1247;NormalInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1050;-3674.017,2360.63;Inherit;False;Property;_InBrumeBackColor;InBrumeBackColor;47;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-4035.708,-1294.381;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1188;-4677.125,4955.989;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1272;-4290.295,-508.6816;Inherit;False;Property;_SSS_Color;SSS_Color;42;0;Create;True;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1248;-3772.251,3252.124;Inherit;False;1246;ShadowInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;1299;-4398.95,-268.6718;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;1312;343.2845,-4671.196;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;1313;243.6294,-4182.37;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-4194.708,-1035.381;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1370;-3126.23,-1044.414;Inherit;False;1368;RBG_TerrainBlending;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1111;-4717.547,4660.86;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1369;-3125.623,-947.7327;Inherit;False;877;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1241;-3771.063,3174.266;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1244;-4985.64,2143.034;Inherit;False;InkSplatter;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1161;-3584.991,2569.648;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;656;-4179.708,-771.3806;Inherit;False;Constant;_Float2;Float 2;31;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1315;589.0245,-4398.154;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1118;-3512.807,3179.198;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;508;-3858.708,-1243.381;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;647;-4002.708,-875.3809;Inherit;False;Property;_Specular;Specular?;34;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1245;-3378.266,2269.62;Inherit;False;1244;InkSplatter;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1270;-4034.388,-307.0229;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;509;-3858.708,-1323.381;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;1189;-4403.675,4653.616;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1314;610.1505,-4272.734;Inherit;False;Property;_Wind_Direction;Wind_Direction;71;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;989;-3522.191,2979.887;Inherit;False;Property;_ColorShadow;ColorShadow;46;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.4811321,0.4811321,0.4811321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;428;-2818.871,-1044.432;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1049;-3420.772,2392.561;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1275;-3651.869,-287.7713;Inherit;False;SSS;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;988;-3238.36,2984.655;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1317;799.1525,-4389.735;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1316;686.5326,-4557.183;Inherit;False;Property;_Wind_Texture_Tiling;Wind_Texture_Tiling;70;0;Create;True;0;0;False;0;False;0.5;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1251;-4106.772,4653.443;Inherit;False;NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1039;-3171.392,2364.902;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;-3570.707,-1291.381;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;513;-2528.815,-1044.249;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;1321;1266.887,-4355.33;Inherit;False;Property;_Wind_Density;Wind_Density;72;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1319;924.2317,-4543.973;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;518;-2282.063,-1283.87;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1276;-1997.902,-1069.793;Inherit;False;1275;SSS;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1162;-2811.197,2956.462;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1320;968.9797,-4766.195;Inherit;True;Property;_Wind_Noise_Texture;Wind_Noise_Texture;69;0;Create;True;0;0;False;0;False;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SinTimeNode;1318;1298.065,-4262.971;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1252;-2773.392,3628.696;Inherit;False;1251;NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1322;1466.478,-4300.127;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1290;-1771.339,-1194.995;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1014;-2508.048,3610.103;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1323;1211.98,-4576.194;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1256;-2107.453,3324.104;Inherit;False;Property;_InBrumeColorCorrection;InBrumeColorCorrection;67;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1324;1878.129,-4499.807;Inherit;False;Property;_Wind_Strength;Wind_Strength;73;0;Create;True;0;0;False;0;False;2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1223;-2231.729,3611.551;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;841;-1337.015,-1559.619;Inherit;False;Property;_OutBrumeColorCorrection;OutBrumeColorCorrection;45;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1325;1675.038,-4568.325;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1273;-1452.591,-1287.6;Inherit;False;Property;_SSS;SSS?;40;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;842;-1032.226,-1284.543;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1326;2053.129,-4567.807;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;878;-3443.566,-3181.008;Inherit;False;Object_Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1255;-1805.662,3588.179;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;1381;-473.3672,-3977.836;Inherit;False;1173.941;490.5488;Opacity;5;1378;1379;1377;1380;1375;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;901;-1560.833,3606.935;Inherit;False;EndInBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1327;2314.26,-4567.857;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1329;2358.547,-4712.402;Inherit;False;Constant;_Float1;Float 1;67;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-802.7091,-1261.77;Inherit;False;EndOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;845;989.735,-688.1459;Inherit;False;1518.214;1161.848;FinalPass;13;1331;1333;1302;0;1303;580;582;955;954;474;844;1334;1376;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;1378;-423.3672,-3674.552;Inherit;False;878;Object_Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;1304;2355.199,-4300.787;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;954;1015.667,-631.0621;Inherit;False;Property;_InOutBrumeTransition;InOutBrumeTransition;2;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1377;-313.7807,-3927.836;Inherit;True;Property;_Object_Opacity_Texture;Object_Opacity_Texture;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1328;2620.297,-4673.583;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;844;1037.148,-321.525;Inherit;False;901;EndInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;1035.767,-534.926;Inherit;False;473;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1379;-199.5833,-3670.287;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.LerpOp;955;1331.354,-520.9811;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1330;2850.701,-4683.696;Inherit;False;WindVertexDisplacement;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1380;173.4166,-3799.287;Inherit;False;Property;_OpacityTexture;OpacityTexture?;9;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;1369.294,-298.8574;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1303;1524.042,-164.8297;Inherit;True;Property;_TextureSample7;Texture Sample 7;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1375;476.5742,-3799.566;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;580;1618.623,-431.6826;Inherit;False;Property;_LightDebug;LightDebug;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1334;1716.035,163.5092;Inherit;False;Constant;_Float4;Float 4;68;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1331;1601.423,281.3298;Inherit;False;1330;WindVertexDisplacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;768;-4253.422,-2607.973;Inherit;False;LightMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1376;1962.833,-39.12579;Inherit;False;1375;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1333;1898.984,179.7731;Inherit;False;Property;_WindVertexDisplacement;WindVertexDisplacement?;68;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;1302;1897.598,-320.4286;Inherit;False;Property;_NormalDebug;NormalDebug;4;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2225.936,-225.9748;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;EnvironmentObjectsShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.06;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;480;0;478;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;565;0;825;0
WireConnection;575;1;576;0
WireConnection;575;0;519;0
WireConnection;1340;0;1338;1
WireConnection;1340;1;1338;3
WireConnection;1339;0;1336;0
WireConnection;1339;1;1337;0
WireConnection;564;1;565;0
WireConnection;564;0;477;0
WireConnection;572;0;487;0
WireConnection;10;0;575;0
WireConnection;465;0;464;0
WireConnection;1342;0;1340;0
WireConnection;1342;1;1339;0
WireConnection;571;0;564;0
WireConnection;571;2;572;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;664;0;466;0
WireConnection;664;1;665;0
WireConnection;664;2;666;0
WireConnection;664;3;667;0
WireConnection;664;5;670;0
WireConnection;711;0;12;0
WireConnection;711;1;710;0
WireConnection;484;0;564;0
WireConnection;484;2;487;0
WireConnection;573;0;571;0
WireConnection;1343;0;1342;0
WireConnection;1343;1;1341;0
WireConnection;566;1;573;0
WireConnection;476;1;484;0
WireConnection;23;0;711;0
WireConnection;671;1;466;0
WireConnection;671;0;664;0
WireConnection;1346;1;1343;0
WireConnection;1344;0;1338;2
WireConnection;454;1;671;0
WireConnection;1203;0;1164;0
WireConnection;1203;1;1194;0
WireConnection;1235;0;1230;0
WireConnection;1235;1;1165;0
WireConnection;570;0;566;1
WireConnection;570;1;476;1
WireConnection;1347;0;1346;0
WireConnection;1347;1;1345;0
WireConnection;1227;0;1225;0
WireConnection;1227;1;1235;0
WireConnection;1227;2;1165;0
WireConnection;455;0;454;0
WireConnection;1360;0;1362;0
WireConnection;1360;9;1359;0
WireConnection;1360;3;1361;0
WireConnection;481;0;570;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;1350;0;1348;0
WireConnection;1350;1;1347;0
WireConnection;1236;1;1203;0
WireConnection;498;0;827;0
WireConnection;1228;0;1227;0
WireConnection;1228;1;1236;0
WireConnection;460;0;455;0
WireConnection;460;1;458;0
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;499;0;498;0
WireConnection;1352;0;1350;0
WireConnection;1352;1;1349;0
WireConnection;1351;0;1363;0
WireConnection;1351;1;1360;0
WireConnection;1384;0;1385;0
WireConnection;1232;0;1228;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;504;0;500;0
WireConnection;504;1;499;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;1353;0;1352;0
WireConnection;1353;1;1351;0
WireConnection;525;0;460;0
WireConnection;525;1;526;0
WireConnection;1286;0;1277;0
WireConnection;1382;82;839;0
WireConnection;1382;5;1384;0
WireConnection;401;0;397;0
WireConnection;1354;0;1353;0
WireConnection;1287;0;1286;0
WireConnection;1287;1;1264;0
WireConnection;1233;0;1232;0
WireConnection;506;0;504;0
WireConnection;1053;0;1054;0
WireConnection;530;0;525;0
WireConnection;530;1;1382;0
WireConnection;1109;1;1107;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;626;0;627;0
WireConnection;1224;0;1225;0
WireConnection;1224;1;1165;0
WireConnection;426;1;427;0
WireConnection;632;0;506;0
WireConnection;632;1;619;0
WireConnection;632;2;633;0
WireConnection;1181;0;1108;0
WireConnection;1181;1;1182;0
WireConnection;461;0;530;0
WireConnection;461;1;426;0
WireConnection;1102;0;1104;0
WireConnection;1102;3;1103;0
WireConnection;1051;1;1053;0
WireConnection;1105;0;1109;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;1231;0;1228;0
WireConnection;1231;1;1224;0
WireConnection;1231;2;1233;0
WireConnection;1355;0;1354;0
WireConnection;1355;1;1364;0
WireConnection;1289;0;1281;0
WireConnection;1289;1;1287;0
WireConnection;625;1;626;0
WireConnection;1219;0;1218;0
WireConnection;1219;1;1165;0
WireConnection;1184;0;1191;0
WireConnection;1184;1;1193;0
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;1113;1;1102;0
WireConnection;1113;0;1114;0
WireConnection;1284;0;1289;0
WireConnection;1220;0;1231;0
WireConnection;1220;1;1219;0
WireConnection;1220;2;1221;0
WireConnection;1058;0;1051;0
WireConnection;1058;1;1059;0
WireConnection;1179;0;1105;0
WireConnection;1179;1;1108;0
WireConnection;1179;2;1181;0
WireConnection;1373;0;1374;0
WireConnection;630;0;632;0
WireConnection;630;1;625;0
WireConnection;1366;0;461;0
WireConnection;1120;0;1195;0
WireConnection;1120;3;1121;0
WireConnection;1356;0;1355;0
WireConnection;1115;0;1113;0
WireConnection;640;0;630;0
WireConnection;1357;0;1356;0
WireConnection;1116;1;1120;0
WireConnection;1116;0;1117;0
WireConnection;1185;1;1184;0
WireConnection;562;0;449;0
WireConnection;1240;0;1220;0
WireConnection;1180;0;1179;0
WireConnection;1365;1;1373;0
WireConnection;1060;0;1058;0
WireConnection;1283;0;1285;0
WireConnection;1283;1;1284;0
WireConnection;1126;0;1058;0
WireConnection;1126;1;1123;0
WireConnection;1125;0;1060;0
WireConnection;1125;1;1126;0
WireConnection;1247;0;1115;0
WireConnection;1358;0;1365;0
WireConnection;1358;1;1367;0
WireConnection;1358;2;1357;0
WireConnection;1187;0;1180;0
WireConnection;1187;1;1185;0
WireConnection;563;0;562;0
WireConnection;563;1;449;0
WireConnection;634;0;640;0
WireConnection;1119;0;1116;0
WireConnection;1106;0;1105;0
WireConnection;1106;1;1108;0
WireConnection;1293;0;1283;0
WireConnection;1293;1;1294;0
WireConnection;1307;0;1305;4
WireConnection;1307;1;1306;0
WireConnection;636;0;634;0
WireConnection;1246;0;1119;0
WireConnection;1158;0;1242;0
WireConnection;1084;1;1085;0
WireConnection;1084;0;1125;0
WireConnection;1186;0;1106;0
WireConnection;1186;1;1187;0
WireConnection;1309;0;1307;0
WireConnection;1309;1;1308;0
WireConnection;1296;0;1293;0
WireConnection;1296;1;1300;0
WireConnection;1368;0;1358;0
WireConnection;877;0;563;0
WireConnection;522;0;502;0
WireConnection;522;1;523;0
WireConnection;1188;0;1186;0
WireConnection;1299;0;1296;0
WireConnection;1312;2;1311;0
WireConnection;1312;1;1309;0
WireConnection;1313;2;1310;0
WireConnection;639;0;636;0
WireConnection;639;1;623;0
WireConnection;1111;0;1249;0
WireConnection;1111;1;1186;0
WireConnection;1244;0;1084;0
WireConnection;1161;0;1158;0
WireConnection;1315;0;1312;0
WireConnection;1315;1;1313;0
WireConnection;1118;0;1241;0
WireConnection;1118;1;1248;0
WireConnection;508;0;522;0
WireConnection;647;1;656;0
WireConnection;647;0;639;0
WireConnection;1270;0;1272;0
WireConnection;1270;1;1299;0
WireConnection;509;0;522;0
WireConnection;1189;0;1111;0
WireConnection;1189;1;1188;0
WireConnection;1189;2;1106;0
WireConnection;428;0;1370;0
WireConnection;428;1;1369;0
WireConnection;1049;0;1050;0
WireConnection;1049;1;1161;0
WireConnection;1275;0;1270;0
WireConnection;988;0;989;0
WireConnection;988;1;1118;0
WireConnection;1317;0;1315;0
WireConnection;1317;1;1314;0
WireConnection;1251;0;1189;0
WireConnection;1039;0;1245;0
WireConnection;1039;1;1049;0
WireConnection;512;0;509;0
WireConnection;512;1;508;0
WireConnection;512;2;647;0
WireConnection;513;0;428;0
WireConnection;1319;0;1316;0
WireConnection;1319;1;1317;0
WireConnection;518;0;512;0
WireConnection;518;1;513;0
WireConnection;1162;0;1039;0
WireConnection;1162;1;988;0
WireConnection;1322;0;1321;0
WireConnection;1322;1;1318;4
WireConnection;1290;0;518;0
WireConnection;1290;1;1276;0
WireConnection;1014;0;1162;0
WireConnection;1014;1;1252;0
WireConnection;1323;0;1320;0
WireConnection;1323;1;1319;0
WireConnection;1223;0;1014;0
WireConnection;1325;0;1323;0
WireConnection;1325;1;1322;0
WireConnection;1273;1;518;0
WireConnection;1273;0;1290;0
WireConnection;842;0;841;0
WireConnection;842;1;1273;0
WireConnection;1326;0;1325;0
WireConnection;1326;1;1324;0
WireConnection;878;0;426;0
WireConnection;1255;0;1256;0
WireConnection;1255;1;1223;0
WireConnection;901;0;1255;0
WireConnection;1327;0;1326;0
WireConnection;473;0;842;0
WireConnection;1328;0;1327;0
WireConnection;1328;1;1329;0
WireConnection;1328;2;1304;0
WireConnection;1379;0;1378;0
WireConnection;955;0;474;0
WireConnection;955;1;844;0
WireConnection;955;2;954;0
WireConnection;1330;0;1328;0
WireConnection;1380;1;1379;3
WireConnection;1380;0;1377;0
WireConnection;1375;0;1380;0
WireConnection;580;1;955;0
WireConnection;580;0;582;0
WireConnection;768;0;562;0
WireConnection;1333;1;1334;0
WireConnection;1333;0;1331;0
WireConnection;1302;1;580;0
WireConnection;1302;0;1303;0
WireConnection;0;9;1376;0
WireConnection;0;10;1376;0
WireConnection;0;13;1302;0
WireConnection;0;11;1333;0
ASEEND*/
//CHKSM=9142238B81549B1E9C3FCAA69807AFACCBA68F29
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "EnvironmentObjectsShader"
{
	Properties
	{
		_InOutBrumeTransition("InOutBrumeTransition", Range( 0 , 1)) = 0
		[Toggle(_LIGHTDEBUG_ON)] _LightDebug("LightDebug", Float) = 0
		[Toggle(_CUSTOMWORLDSPACENORMAL_ON)] _CustomWorldSpaceNormal("CustomWorldSpaceNormal?", Float) = 0
		_Object_Albedo_Texture("Object_Albedo_Texture", 2D) = "white" {}
		_Object_Normal_Texture("Object_Normal_Texture", 2D) = "white" {}
		_Object_Roughness_Texture("Object_Roughness_Texture", 2D) = "white" {}
		[Toggle(_MOVINGPAPER_ON)] _MovingPaper("MovingPaper?", Float) = 1
		_Paper_Texture("Paper_Texture", 2D) = "white" {}
		_Paper_Tiling("Paper_Tiling", Float) = 1
		_Paper_Flipbook_Columns("Paper_Flipbook_Columns", Float) = 1
		_Paper_Flipbook_Rows("Paper_Flipbook_Rows", Float) = 1
		_Paper_Flipbook_Speed("Paper_Flipbook_Speed", Float) = 1
		_PaperContrast("PaperContrast", Color) = (0.5660378,0.5660378,0.5660378,0)
		_PaperMultiply("PaperMultiply", Float) = 1.58
		_InkGrunge_Texture("InkGrunge_Texture", 2D) = "white" {}
		_InkGrunge_Tiling("InkGrunge_Tiling", Vector) = (1,1,0,0)
		_Edge_Noise_Texture("Edge_Noise_Texture", 2D) = "white" {}
		[Toggle(_SCREENBASEDNOISE_ON)] _ScreenBasedNoise("ScreenBasedNoise?", Float) = 0
		_Noise_Tiling("Noise_Tiling", Float) = 1
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
		[Toggle(_RIMLIGHT_ON)] _RimLight("RimLight?", Float) = 0
		_RimLightColor("RimLightColor", Color) = (1,0,0,0)
		_RimLightEmission_Multiplier("RimLightEmission_Multiplier", Float) = 1
		_RimLightSmoothstep_Min("RimLightSmoothstep_Min", Float) = 0.9
		_RimLightSmoothstep_Max("RimLightSmoothstep_Max", Float) = 0.91
		[Toggle(_RIMLIGHT_CUSTOMNORMAL_ON)] _RimLight_CustomNormal("RimLight_CustomNormal", Float) = 0
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
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _LIGHTDEBUG_ON
		#pragma shader_feature_local _RIMLIGHT_ON
		#pragma shader_feature_local _SPECULAR_ON
		#pragma shader_feature_local _MOVINGPAPER_ON
		#pragma shader_feature_local _CUSTOMWORLDSPACENORMAL_ON
		#pragma shader_feature_local _SCREENBASEDNOISE_ON
		#pragma shader_feature_local _RIMLIGHT_CUSTOMNORMAL_ON
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
		uniform sampler2D _Paper_Texture;
		uniform float _Paper_Tiling;
		uniform float _Paper_Flipbook_Columns;
		uniform float _Paper_Flipbook_Rows;
		uniform float _Paper_Flipbook_Speed;
		uniform float4 _PaperContrast;
		uniform float _PaperMultiply;
		uniform sampler2D _InkGrunge_Texture;
		uniform float2 _InkGrunge_Tiling;
		uniform sampler2D _Object_Albedo_Texture;
		uniform float _StepShadow;
		uniform float _StepAttenuation;
		uniform float2 _Noise_Panner;
		uniform float _Noise_Tiling;
		uniform float4 _ShadowColor;
		uniform float _RimLightEmission_Multiplier;
		uniform float4 _RimLightColor;
		uniform float _RimLightSmoothstep_Min;
		uniform float _RimLightSmoothstep_Max;
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


		inline float4 TriplanarSampling838( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
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
			float2 uv_Object_Roughness_Texture = i.uv_texcoord * _Object_Roughness_Texture_ST.xy + _Object_Roughness_Texture_ST.zw;
			float4 temp_output_522_0 = ( tex2D( _Object_Roughness_Texture, uv_Object_Roughness_Texture ) * _Roughness_Multiplier );
			float4 temp_cast_1 = (0.0).xxxx;
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
			float4 temp_cast_3 = (smoothstepResult632).xxxx;
			float2 temp_cast_4 = (_SpecularNoise).xx;
			float2 uv_TexCoord626 = i.uv_texcoord * temp_cast_4;
			float grayscale634 = Luminance(step( ( temp_cast_3 - tex2D( _Edge_Noise_Texture, uv_TexCoord626 ) ) , float4( 0,0,0,0 ) ).rgb);
			#ifdef _SPECULAR_ON
				float4 staticSwitch647 = ( (0.0 + (grayscale634 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) * _SpecularColor );
			#else
				float4 staticSwitch647 = temp_cast_1;
			#endif
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
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar838 = TriplanarSampling838( _InkGrunge_Texture, ase_worldPos, ase_worldNormal, 1.0, _InkGrunge_Tiling, 1.0, 0 );
			float4 tex2DNode426 = tex2D( _Object_Albedo_Texture, i.uv_texcoord );
			float4 blendOpSrc461 = ( ( ( grayscale455 + _PaperContrast ) * _PaperMultiply ) * triplanar838 );
			float4 blendOpDest461 = tex2DNode426;
			float temp_output_387_0 = ( _StepShadow + _StepAttenuation );
			#ifdef _CUSTOMWORLDSPACENORMAL_ON
				float4 staticSwitch575 = tex2D( _Object_Normal_Texture, uv_Object_Normal_Texture );
			#else
				float4 staticSwitch575 = float4( float3(0,0,1) , 0.0 );
			#endif
			float dotResult12 = dot( (WorldNormalVector( i , staticSwitch575.rgb )) , ase_worldlightDir );
			float normal_LightDir23 = ( dotResult12 * ase_lightAtten );
			float smoothstepResult385 = smoothstep( _StepShadow , temp_output_387_0 , normal_LightDir23);
			float2 temp_cast_10 = (_Noise_Tiling).xx;
			float2 uv_TexCoord565 = i.uv_texcoord * temp_cast_10;
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
			float4 temp_cast_11 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest444) / max( blendOpSrc444, 0.00001) ) ) ))).xxxx;
			float4 blendOpSrc449 = temp_cast_11;
			float4 blendOpDest449 = _ShadowColor;
			float4 temp_output_449_0 = ( saturate( ( blendOpSrc449 * blendOpDest449 ) ));
			float4 temp_output_562_0 = step( temp_output_449_0 , float4( 0,0,0,0 ) );
			float4 temp_output_563_0 = ( temp_output_562_0 + temp_output_449_0 );
			float4 blendOpSrc428 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
			float4 blendOpDest428 = temp_output_563_0;
			float4 RGB514 = ( saturate( ( blendOpSrc428 * blendOpDest428 ) ));
			float4 temp_output_518_0 = ( ( float4( (temp_output_522_0).rgb , 0.0 ) * (temp_output_522_0).a * staticSwitch647 ) + float4( (RGB514).rgb , 0.0 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			#ifdef _RIMLIGHT_CUSTOMNORMAL_ON
				float3 staticSwitch820 = (WorldNormalVector( i , tex2D( _Object_Normal_Texture, uv_Object_Normal_Texture ).rgb ));
			#else
				float3 staticSwitch820 = ase_vertexNormal;
			#endif
			float dotResult805 = dot( staticSwitch820 , ase_worldViewDir );
			float smoothstepResult811 = smoothstep( _RimLightSmoothstep_Min , _RimLightSmoothstep_Max , ( 1.0 - dotResult805 ));
			float4 temp_cast_16 = (smoothstepResult811).xxxx;
			float4 LightMask768 = temp_output_562_0;
			float4 blendOpSrc796 = _RimLightColor;
			float4 blendOpDest796 = ( temp_cast_16 - LightMask768 );
			float4 CustomRimLight772 = ( _RimLightEmission_Multiplier * ( saturate( min( blendOpSrc796 , blendOpDest796 ) )) );
			#ifdef _RIMLIGHT_ON
				float4 staticSwitch798 = ( temp_output_518_0 + CustomRimLight772 );
			#else
				float4 staticSwitch798 = temp_output_518_0;
			#endif
			float4 EndOutBrume473 = ( _OutBrumeColorCorrection * staticSwitch798 );
			float4 temp_cast_17 = (1.0).xxxx;
			float2 temp_cast_18 = (_InkSplatter_Tiling).xx;
			float2 uv_TexCoord1053 = i.uv_texcoord * temp_cast_18;
			float4 temp_cast_19 = (0.5).xxxx;
			float4 temp_output_1058_0 = step( tex2D( _InkSplatter_Texture, uv_TexCoord1053 ) , temp_cast_19 );
			float4 temp_cast_20 = (0.5).xxxx;
			float2 uv_DrippingNoiseTexture_Albedo = i.uv_texcoord * _DrippingNoiseTexture_Albedo_ST.xy + _DrippingNoiseTexture_Albedo_ST.zw;
			#ifdef _INKSPLATTER_ON
				float4 staticSwitch1084 = ( ( 1.0 - temp_output_1058_0 ) + ( temp_output_1058_0 * tex2D( _DrippingNoiseTexture_Albedo, uv_DrippingNoiseTexture_Albedo ) ) );
			#else
				float4 staticSwitch1084 = temp_cast_17;
			#endif
			float4 InkSplatter1244 = staticSwitch1084;
			float smoothstepResult1227 = smoothstep( ( _ShadowDrippingNoise_Smoothstep + _ShadowDrippingNoise_Step ) , _ShadowDrippingNoise_Step , normal_LightDir23);
			float4 temp_cast_21 = (smoothstepResult1227).xxxx;
			float2 temp_cast_22 = (_DrippingNoise_Tiling).xx;
			float2 uv_TexCoord1203 = i.uv_texcoord * temp_cast_22 + _ShadowDrippingNoise_Offset;
			float4 temp_output_1228_0 = ( temp_cast_21 - tex2D( _DrippingNoiseTexture_Albedo, uv_TexCoord1203 ) );
			float4 temp_cast_23 = (step( normal_LightDir23 , _ShadowDrippingNoise_Step )).xxxx;
			float4 blendOpSrc1231 = temp_output_1228_0;
			float4 blendOpDest1231 = temp_cast_23;
			float4 temp_cast_24 = (smoothstepResult1227).xxxx;
			float4 lerpBlendMode1231 = lerp(blendOpDest1231,	max( blendOpSrc1231, blendOpDest1231 ),( 1.0 - step( temp_output_1228_0 , float4( 0,0,0,0 ) ) ).r);
			float4 temp_cast_26 = (step( normal_LightDir23 , _ShadowDrippingNoise_Step )).xxxx;
			float4 lerpResult1220 = lerp( ( saturate( lerpBlendMode1231 )) , temp_cast_26 , _ShadowDrippingNoise_Transition);
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
			float4 temp_cast_32 = (( 1.0 - smoothstepResult1179 )).xxxx;
			float2 temp_cast_33 = (_NormalDrippingNoise_Tiling).xx;
			float2 uv_TexCoord1184 = i.uv_texcoord * temp_cast_33 + _NormalDrippingNoise_Offset;
			float4 temp_output_1186_0 = ( temp_output_1106_0 + ( temp_cast_32 - tex2D( _DrippingNoiseTexture_Albedo, uv_TexCoord1184 ) ) );
			float4 temp_cast_34 = (( 1.0 - smoothstepResult1179 )).xxxx;
			float4 blendOpSrc1189 = ( NormalInBrumeGrunge1247 * temp_output_1186_0 );
			float4 blendOpDest1189 = ( 1.0 - temp_output_1186_0 );
			float4 lerpBlendMode1189 = lerp(blendOpDest1189,	max( blendOpSrc1189, blendOpDest1189 ),temp_output_1106_0);
			float4 NormalDrippingGrunge1251 = ( saturate( lerpBlendMode1189 ));
			float4 EndInBrume901 = ( _InBrumeColorCorrection * (float4( 0,0,0,0 ) + (( 	max( blendOpSrc1162, blendOpDest1162 ) * NormalDrippingGrunge1251 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) );
			float4 lerpResult955 = lerp( EndOutBrume473 , EndInBrume901 , _InOutBrumeTransition);
			float4 temp_cast_35 = (normal_LightDir23).xxxx;
			#ifdef _LIGHTDEBUG_ON
				float4 staticSwitch580 = temp_cast_35;
			#else
				float4 staticSwitch580 = lerpResult955;
			#endif
			c.rgb = staticSwitch580.rgb;
			c.a = 1;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

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
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
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
0;6;1920;1013;6754.144;-3162.073;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;824;-6937.732,-4815.77;Inherit;False;6359.02;5128.683;OUT BRUME;18;473;798;792;773;518;513;510;514;428;823;520;471;468;31;521;841;842;877;;1,0.7827643,0.5518868,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;521;-4914.711,-4765.77;Inherit;False;2866.093;613.3671;Noise;16;570;481;566;476;572;571;484;487;564;565;477;480;479;478;573;825;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-4802.711,-4429.77;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;825;-4584.271,-4620.198;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;19;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;480;-4594.711,-4429.77;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;31;-6882.713,-4765.77;Inherit;False;1788.085;588.8215;Normal Light Dir;9;23;12;10;11;575;576;710;711;519;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-4610.711,-4349.77;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;20;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;576;-6802.713,-4605.769;Inherit;False;Constant;_Vector0;Vector 0;25;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-4370.708,-4429.77;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;565;-4370.708,-4637.769;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;519;-6824.358,-4408.739;Inherit;True;Property;_Object_Normal_Texture;Object_Normal_Texture;5;0;Create;True;0;0;False;0;False;-1;2418409f260e65a4baa4d7d8b8b8a53e;2418409f260e65a4baa4d7d8b8b8a53e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;487;-3922.708,-4301.77;Inherit;False;Property;_Noise_Panner;Noise_Panner;20;0;Create;True;0;0;False;0;False;0.2,-0.1;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;575;-6498.713,-4605.769;Inherit;False;Property;_CustomWorldSpaceNormal;CustomWorldSpaceNormal?;2;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;572;-3698.707,-4605.769;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;564;-4002.708,-4461.77;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;18;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;571;-3538.707,-4637.769;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-6178.713,-4477.77;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;10;-6162.713,-4621.769;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;1254;-6940.984,396.3358;Inherit;False;5649.46;3565.475;IN BRUME;23;901;1223;1014;1162;1252;1039;988;989;1049;1245;1118;1248;1241;1050;1161;1158;1242;1253;1250;1086;1243;1255;1256;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-5906.713,-4621.769;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;468;-6889.708,-4018.677;Inherit;False;3534.264;1037.394;Paper + Object Texture;26;461;530;426;525;838;427;836;839;837;526;460;458;455;454;671;664;670;665;466;667;666;465;463;464;876;878;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;710;-5890.713,-4349.77;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;484;-3698.707,-4381.77;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;573;-3266.71,-4637.769;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;566;-3058.71,-4653.769;Inherit;True;Property;_TextureSample0;Texture Sample 0;17;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;476;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;471;-6338.713,-2797.77;Inherit;False;3004.532;1100.889;Shadow Smooth Edge + Int Shadow;19;449;562;563;450;387;444;445;385;401;446;447;397;448;470;469;388;386;482;768;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;476;-3058.71,-4413.77;Inherit;True;Property;_Edge_Noise_Texture;Edge_Noise_Texture;17;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;711;-5618.712,-4621.769;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1243;-6881.426,1392.41;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;19;1194;1240;1220;1219;1221;1218;1231;1224;1233;1232;1228;1236;1227;1225;1235;1203;1230;1165;1164;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-6729.708,-3922.677;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1165;-6698.249,1752.136;Inherit;False;Property;_ShadowDrippingNoise_Step;ShadowDrippingNoise_Step;45;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-5330.712,-4637.769;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1164;-6806.93,1934.412;Inherit;False;Property;_DrippingNoise_Tiling;ShadowDrippingNoise_Tiling;46;0;Create;False;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1194;-6812.426,2022.489;Inherit;False;Property;_ShadowDrippingNoise_Offset;ShadowDrippingNoise_Offset;47;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;388;-5874.713,-2477.771;Inherit;False;Property;_StepAttenuation;StepAttenuation;22;0;Create;True;0;0;False;0;False;0.3;-0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-6306.713,-2141.77;Inherit;False;Property;_StepShadow;StepShadow;21;0;Create;True;0;0;False;0;False;0.03;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;570;-2594.71,-4413.77;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;465;-6505.708,-3922.677;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;463;-6521.708,-3842.677;Inherit;False;Property;_Paper_Tiling;Paper_Tiling;9;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1230;-6704.406,1665.562;Inherit;False;Property;_ShadowDrippingNoise_Smoothstep;ShadowDrippingNoise_Smoothstep;44;0;Create;True;0;0;False;0;False;0.2;0.01;0.001;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;520;-6891.235,-1611.381;Inherit;False;3548.808;1021.013;Add Rougness and Normal;26;632;633;619;506;504;499;500;498;656;522;523;502;512;647;509;508;639;623;636;634;640;630;625;626;627;827;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;665;-6713.708,-3554.677;Inherit;False;Property;_Paper_Flipbook_Columns;Paper_Flipbook_Columns;10;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-5794.713,-2733.77;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1235;-6326.589,1695.971;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;667;-6697.708,-3394.677;Inherit;False;Property;_Paper_Flipbook_Speed;Paper_Flipbook_Speed;12;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1203;-6500.76,1954.869;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-6297.708,-3922.677;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;827;-6809.4,-831.4996;Inherit;True;Property;_TextureSample5;Texture Sample 5;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;666;-6697.708,-3474.677;Inherit;False;Property;_Paper_Flipbook_Rows;Paper_Flipbook_Rows;11;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-5682.713,-2493.771;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;670;-6517.708,-3243.677;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1225;-6459.069,1442.41;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-2274.71,-4397.77;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;498;-6459.222,-810.214;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;448;-5538.712,-2141.77;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;482;-5266.712,-2557.77;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1227;-6153.674,1672.523;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;664;-6281.708,-3362.677;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;1236;-6255.306,1926.539;Inherit;True;Property;_DrippingNoiseTexture_Albedo;DrippingNoiseTexture_Albedo;42;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-5522.712,-2733.77;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;671;-5993.708,-3698.677;Inherit;True;Property;_MovingPaper;MovingPaper?;7;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-5330.712,-2189.77;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-5362.712,-2301.77;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;500;-6347.222,-1002.214;Inherit;False;Blinn-Phong Half Vector;-1;;9;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-5330.712,-2093.77;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-5042.712,-2733.77;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;499;-6251.222,-810.214;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;823;-6350.638,-550.3016;Inherit;False;3007.976;788.3442;Rim Light;17;806;817;810;820;807;805;812;809;814;819;811;818;771;796;803;804;772;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1086;-6872.029,446.3356;Inherit;False;2193.24;919.6926;InkSplatter;12;1244;1084;1125;1126;1060;1058;1123;1051;1059;1053;1054;1085;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1250;-6885.883,2987.822;Inherit;False;3114.2;902.8672;NormalDrippingGrunge;20;1249;1189;1188;1111;1186;1187;1106;1180;1185;1184;1179;1193;1181;1191;1105;1109;1182;1108;1107;1251;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1228;-5873.447,1838.959;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-5122.712,-2221.77;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1107;-6835.883,3066.523;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;454;-5561.707,-3970.677;Inherit;True;Property;_Paper_Texture;Paper_Texture;8;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;806;-6302.638,-374.3016;Inherit;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;504;-6091.222,-906.2142;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1054;-6822.029,664.4955;Inherit;False;Property;_InkSplatter_Tiling;InkSplatter_Tiling;41;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;1253;-6890.984,2361.944;Inherit;False;2088.706;597.0554;InBrumeGrunge;14;1195;1121;1117;1120;1116;1119;1246;1103;1102;1114;1113;1115;1104;1247;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;1232;-5630.794,2062.729;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;627;-5906.713,-875.3809;Inherit;False;Property;_SpecularNoise;SpecularNoise;27;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-4818.711,-2733.77;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1108;-6365.031,3329.827;Inherit;False;Property;_NormalDrippingNoise_Step;NormalDrippingNoise_Step;49;0;Create;True;0;0;False;0;False;0.45;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;506;-6075.222,-1082.214;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1053;-6607.589,646.0885;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1218;-4971.57,1817.169;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1233;-5424.794,2062.729;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1182;-6384.163,3430.2;Inherit;False;Property;_NormalDrippingNoise_Smoothstep;NormalDrippingNoise_Smoothstep;48;0;Create;True;0;0;False;0;False;0.01;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1104;-6833.007,2699.087;Inherit;True;Property;_InBrumeGrunge_Texture;NormalInBrumeGrunge_Texture;55;0;Create;False;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1109;-6601.393,3038.12;Inherit;True;Property;_TextureSample4;Texture Sample 4;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;458;-5001.707,-3874.677;Inherit;False;Property;_PaperContrast;PaperContrast;13;0;Create;True;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0.5019608,0.5019608,0.5019608,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;455;-5209.707,-3970.677;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;444;-4770.711,-2221.77;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;619;-5947.222,-1338.215;Inherit;False;Property;_SpeculartStepMin;SpeculartStepMin;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;817;-5854.638,-438.3016;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;633;-5947.222,-1258.214;Inherit;False;Property;_SpecularStepMax;SpecularStepMax;26;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;810;-5870.638,-214.3016;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;1103;-6521.919,2794.795;Inherit;False;Property;_NormalInBrumeGrunge_Tiling;NormalInBrumeGrunge_Tiling;56;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;626;-5746.713,-891.3809;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;450;-4498.71,-1901.77;Inherit;False;Property;_ShadowColor;ShadowColor;23;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.462264,0.462264,0.462264,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;1224;-6139.425,1447.51;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1231;-5147.328,1559.016;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1051;-6376.041,616.8046;Inherit;True;Property;_InkSplatter_Texture;InkSplatter_Texture;40;0;Create;True;0;0;False;0;False;-1;5392ce4f46828c142999c3edf442f7a7;5392ce4f46828c142999c3edf442f7a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1105;-6273.382,3037.822;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1114;-5862.445,2797.237;Inherit;False;Property;_NormalInBrumeGrunge_Contrast;NormalInBrumeGrunge_Contrast;57;0;Create;True;0;0;False;0;False;2.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1193;-6114.251,3737.413;Inherit;False;Property;_NormalDrippingNoise_Offset;NormalDrippingNoise_Offset;51;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TriplanarNode;1102;-6240.778,2703.317;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;-1;None;Mid Texture 2;_MidTexture2;white;-1;None;Bot Texture 2;_BotTexture2;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1191;-6107.549,3649.959;Inherit;False;Property;_NormalDrippingNoise_Tiling;NormalDrippingNoise_Tiling;50;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1219;-4754.327,1822.869;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1221;-4764.58,1472.489;Inherit;False;Property;_ShadowDrippingNoise_Transition;ShadowDrippingNoise_Transition;43;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1059;-6223.149,496.3355;Inherit;False;Constant;_Float3;Float 3;53;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1195;-6840.984,2413.123;Inherit;True;Property;_InBrumeGrunge_Texture2;ShadowInBrumeGrunge_Texture;52;0;Create;False;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;1181;-6051.854,3426.399;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;836;-5254.781,-3431.826;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;632;-5611.221,-1354.215;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;807;-5438.637,9.698444;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;625;-5522.712,-939.3809;Inherit;True;Property;_TextureSample1;Texture Sample 1;17;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;476;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;837;-5271.667,-3273.383;Inherit;False;Property;_InkGrunge_Tiling;InkGrunge_Tiling;16;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;526;-4569.706,-3730.677;Inherit;False;Property;_PaperMultiply;PaperMultiply;14;0;Create;True;0;0;False;0;False;1.58;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1121;-6535.032,2507.255;Inherit;False;Property;_ShadowInBrumeGrunge_Tiling;ShadowInBrumeGrunge_Tiling;53;0;Create;True;0;0;False;0;False;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;460;-4745.706,-3954.677;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;839;-5303.349,-3638.117;Inherit;True;Property;_InkGrunge_Texture;InkGrunge_Texture;15;0;Create;True;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StaticSwitch;820;-5502.637,-214.3016;Inherit;False;Property;_RimLight_CustomNormal;RimLight_CustomNormal;35;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;449;-4354.708,-2221.77;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1184;-5832.668,3694.38;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;1220;-4460.379,1698.851;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1123;-6149.373,1126.829;Inherit;True;Property;_TextureSample6;Texture Sample 6;42;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1236;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;1113;-5613.219,2704.999;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1117;-5843.172,2516.399;Inherit;False;Property;_ShadowInBrumeGrunge_Contrast;ShadowInBrumeGrunge_Contrast;54;0;Create;True;0;0;False;0;False;-3.38;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1058;-6075.149,623.3354;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1179;-5653.004,3360.718;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;630;-5202.712,-1035.381;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;805;-5166.637,-214.3016;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;562;-3986.708,-2541.771;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-4377.703,-3874.677;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;427;-4268.201,-3223.4;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;1120;-6224.812,2418.915;Inherit;True;Spherical;World;False;Top Texture 2;_TopTexture2;white;-1;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TriplanarNode;838;-4896.835,-3452.918;Inherit;True;Spherical;World;False;Top Texture 1;_TopTexture1;white;-1;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1185;-5612.734,3665.836;Inherit;True;Property;_TextureSample8;Texture Sample 8;42;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Instance;1236;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1115;-5370.795,2699.697;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1240;-4262.537,1647.235;Inherit;False;ShadowDrippingNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1116;-5540.946,2419.161;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1060;-5801.149,625.3353;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1180;-5412.548,3361.162;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1126;-5833.615,908.4453;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-3980.202,-3543.4;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;809;-4926.636,-214.3016;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;768;-3714.707,-2669.77;Inherit;False;LightMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;814;-4971.637,87.69832;Inherit;False;Property;_RimLightSmoothstep_Max;RimLightSmoothstep_Max;34;0;Create;True;0;0;False;0;False;0.91;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;426;-4028.202,-3287.4;Inherit;True;Property;_Object_Albedo_Texture;Object_Albedo_Texture;4;0;Create;True;0;0;False;0;False;-1;6395db2a80729484b931cff6723fa89f;6395db2a80729484b931cff6723fa89f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;812;-4968.637,12.69844;Inherit;False;Property;_RimLightSmoothstep_Min;RimLightSmoothstep_Min;33;0;Create;True;0;0;False;0;False;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;640;-4994.712,-1035.381;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;461;-3644.2,-3495.4;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1125;-5435.615,818.4453;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1247;-5132.776,2699.549;Inherit;False;NormalInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1242;-4005.259,1015.293;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1119;-5290.56,2413.28;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1085;-5388.117,505.534;Inherit;False;Constant;_Float5;Float 5;59;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;634;-4834.711,-1035.381;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;811;-4670.636,-214.3016;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;819;-4606.636,121.6983;Inherit;False;768;LightMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;563;-3570.707,-2237.77;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;1106;-5637.245,3108.891;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1187;-5178.358,3551.862;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;502;-4419.71,-1390.381;Inherit;True;Property;_Object_Roughness_Texture;Object_Roughness_Texture;6;0;Create;True;0;0;False;0;False;-1;e3ffd422ed294bf4b8c909ae388edf91;462e6eb6ea263d24c9aa2becc5fa3ffa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1246;-5074.278,2411.944;Inherit;False;ShadowInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;1084;-5230.117,595.8025;Inherit;False;Property;_InkSplatter;InkSplatter?;39;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1158;-3736.625,1021.304;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;428;-3074.71,-2925.77;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1249;-4934.319,3108.012;Inherit;False;1247;NormalInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;818;-4398.635,-214.3016;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;771;-4398.635,-486.3015;Inherit;False;Property;_RimLightColor;RimLightColor;31;0;Create;True;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;636;-4594.711,-1035.381;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1186;-4929.736,3407.307;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;523;-4387.71,-1182.381;Inherit;False;Property;_Roughness_Multiplier;Roughness_Multiplier;29;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;623;-4418.71,-923.3809;Inherit;False;Property;_SpecularColor;SpecularColor;28;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.9433962,0.8590411,0.6274475,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1248;-3732.895,1703.975;Inherit;False;1246;ShadowInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;514;-2786.71,-2925.77;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1111;-4678.193,3112.713;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1241;-3731.707,1626.116;Inherit;False;1240;ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1050;-3634.661,812.4805;Inherit;False;Property;_InBrumeBackColor;InBrumeBackColor;38;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;1161;-3545.635,1021.499;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;1188;-4637.771,3407.843;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;656;-4179.708,-771.3806;Inherit;False;Constant;_Float2;Float 2;31;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-4194.708,-1035.381;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;803;-4062.633,-502.3015;Inherit;False;Property;_RimLightEmission_Multiplier;RimLightEmission_Multiplier;32;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;796;-4126.633,-278.3016;Inherit;True;Darken;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-4035.708,-1294.381;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1244;-4946.284,594.8845;Inherit;False;InkSplatter;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;647;-4002.708,-875.3809;Inherit;False;Property;_Specular;Specular?;24;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1245;-3338.91,721.4706;Inherit;False;1244;InkSplatter;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1118;-3473.451,1631.049;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1189;-4364.321,3105.468;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;804;-3774.632,-294.3016;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;509;-3858.708,-1323.381;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;508;-3858.708,-1243.381;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1049;-3381.416,844.4116;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;989;-3482.835,1431.738;Inherit;False;Property;_ColorShadow;ColorShadow;37;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.4811321,0.4811321,0.4811321,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;510;-3058.71,-1005.77;Inherit;False;514;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1039;-3132.036,816.7527;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;-3570.707,-1291.381;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;988;-3199.004,1436.506;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;513;-2850.71,-1005.77;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;772;-3566.632,-278.3016;Inherit;False;CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1251;-4067.417,3105.296;Inherit;False;NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1162;-2771.84,1408.313;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;518;-2434.71,-1261.77;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;773;-2082.71,-1101.77;Inherit;False;772;CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1252;-2734.036,2080.547;Inherit;False;1251;NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1014;-2468.692,2061.954;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;792;-1858.71,-1181.77;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1256;-2068.097,1775.955;Inherit;False;Property;_InBrumeColorCorrection;InBrumeColorCorrection;58;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;1223;-2192.372,2063.402;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;841;-1503.414,-1556.419;Inherit;False;Property;_OutBrumeColorCorrection;OutBrumeColorCorrection;36;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;798;-1602.71,-1261.77;Inherit;False;Property;_RimLight;RimLight?;30;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1255;-1766.308,2040.031;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;842;-1198.625,-1281.343;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;845;702.505,-676.0676;Inherit;False;1493.438;534.7701;FinalPass;7;844;0;580;533;582;474;955;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-802.7091,-1261.77;Inherit;False;EndOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;901;-1521.479,2058.786;Inherit;False;EndInBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;954;723.7101,-786.9839;Inherit;False;Property;_InOutBrumeTransition;InOutBrumeTransition;0;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;733.8101,-522.8477;Inherit;False;473;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;844;735.1914,-309.4467;Inherit;False;901;EndInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;955;994.3972,-630.9028;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;1067.337,-286.7791;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;580;1316.666,-419.6043;Inherit;False;Property;_LightDebug;LightDebug;1;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;876;-4454.209,-3350.871;Inherit;False;TriplanarInkGrunge;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;877;-3275.901,-2242.423;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;533;982.1046,-408.2663;Inherit;False;Property;_isPlayerInBrume;isPlayerInBrume;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;878;-3704.85,-3210.699;Inherit;False;Object_Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1938.33,-591.5077;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;EnvironmentObjectsShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.06;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;480;0;478;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;565;0;825;0
WireConnection;575;1;576;0
WireConnection;575;0;519;0
WireConnection;572;0;487;0
WireConnection;564;1;565;0
WireConnection;564;0;477;0
WireConnection;571;0;564;0
WireConnection;571;2;572;0
WireConnection;10;0;575;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;484;0;564;0
WireConnection;484;2;487;0
WireConnection;573;0;571;0
WireConnection;566;1;573;0
WireConnection;476;1;484;0
WireConnection;711;0;12;0
WireConnection;711;1;710;0
WireConnection;23;0;711;0
WireConnection;570;0;566;1
WireConnection;570;1;476;1
WireConnection;465;0;464;0
WireConnection;1235;0;1230;0
WireConnection;1235;1;1165;0
WireConnection;1203;0;1164;0
WireConnection;1203;1;1194;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;481;0;570;0
WireConnection;498;0;827;0
WireConnection;1227;0;1225;0
WireConnection;1227;1;1235;0
WireConnection;1227;2;1165;0
WireConnection;664;0;466;0
WireConnection;664;1;665;0
WireConnection;664;2;666;0
WireConnection;664;3;667;0
WireConnection;664;5;670;0
WireConnection;1236;1;1203;0
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;671;1;466;0
WireConnection;671;0;664;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;499;0;498;0
WireConnection;1228;0;1227;0
WireConnection;1228;1;1236;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;454;1;671;0
WireConnection;504;0;500;0
WireConnection;504;1;499;0
WireConnection;1232;0;1228;0
WireConnection;401;0;397;0
WireConnection;506;0;504;0
WireConnection;1053;0;1054;0
WireConnection;1233;0;1232;0
WireConnection;1109;1;1107;0
WireConnection;455;0;454;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;817;0;806;0
WireConnection;626;0;627;0
WireConnection;1224;0;1225;0
WireConnection;1224;1;1165;0
WireConnection;1231;0;1228;0
WireConnection;1231;1;1224;0
WireConnection;1231;2;1233;0
WireConnection;1051;1;1053;0
WireConnection;1105;0;1109;0
WireConnection;1102;0;1104;0
WireConnection;1102;3;1103;0
WireConnection;1219;0;1218;0
WireConnection;1219;1;1165;0
WireConnection;1181;0;1108;0
WireConnection;1181;1;1182;0
WireConnection;632;0;506;0
WireConnection;632;1;619;0
WireConnection;632;2;633;0
WireConnection;625;1;626;0
WireConnection;460;0;455;0
WireConnection;460;1;458;0
WireConnection;820;1;810;0
WireConnection;820;0;817;0
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;1184;0;1191;0
WireConnection;1184;1;1193;0
WireConnection;1220;0;1231;0
WireConnection;1220;1;1219;0
WireConnection;1220;2;1221;0
WireConnection;1113;1;1102;0
WireConnection;1113;0;1114;0
WireConnection;1058;0;1051;0
WireConnection;1058;1;1059;0
WireConnection;1179;0;1105;0
WireConnection;1179;1;1108;0
WireConnection;1179;2;1181;0
WireConnection;630;0;632;0
WireConnection;630;1;625;0
WireConnection;805;0;820;0
WireConnection;805;1;807;0
WireConnection;562;0;449;0
WireConnection;525;0;460;0
WireConnection;525;1;526;0
WireConnection;1120;0;1195;0
WireConnection;1120;3;1121;0
WireConnection;838;0;839;0
WireConnection;838;9;836;0
WireConnection;838;3;837;0
WireConnection;1185;1;1184;0
WireConnection;1115;0;1113;0
WireConnection;1240;0;1220;0
WireConnection;1116;1;1120;0
WireConnection;1116;0;1117;0
WireConnection;1060;0;1058;0
WireConnection;1180;0;1179;0
WireConnection;1126;0;1058;0
WireConnection;1126;1;1123;0
WireConnection;530;0;525;0
WireConnection;530;1;838;0
WireConnection;809;0;805;0
WireConnection;768;0;562;0
WireConnection;426;1;427;0
WireConnection;640;0;630;0
WireConnection;461;0;530;0
WireConnection;461;1;426;0
WireConnection;1125;0;1060;0
WireConnection;1125;1;1126;0
WireConnection;1247;0;1115;0
WireConnection;1119;0;1116;0
WireConnection;634;0;640;0
WireConnection;811;0;809;0
WireConnection;811;1;812;0
WireConnection;811;2;814;0
WireConnection;563;0;562;0
WireConnection;563;1;449;0
WireConnection;1106;0;1105;0
WireConnection;1106;1;1108;0
WireConnection;1187;0;1180;0
WireConnection;1187;1;1185;0
WireConnection;1246;0;1119;0
WireConnection;1084;1;1085;0
WireConnection;1084;0;1125;0
WireConnection;1158;0;1242;0
WireConnection;428;0;461;0
WireConnection;428;1;563;0
WireConnection;818;0;811;0
WireConnection;818;1;819;0
WireConnection;636;0;634;0
WireConnection;1186;0;1106;0
WireConnection;1186;1;1187;0
WireConnection;514;0;428;0
WireConnection;1111;0;1249;0
WireConnection;1111;1;1186;0
WireConnection;1161;0;1158;0
WireConnection;1188;0;1186;0
WireConnection;639;0;636;0
WireConnection;639;1;623;0
WireConnection;796;0;771;0
WireConnection;796;1;818;0
WireConnection;522;0;502;0
WireConnection;522;1;523;0
WireConnection;1244;0;1084;0
WireConnection;647;1;656;0
WireConnection;647;0;639;0
WireConnection;1118;0;1241;0
WireConnection;1118;1;1248;0
WireConnection;1189;0;1111;0
WireConnection;1189;1;1188;0
WireConnection;1189;2;1106;0
WireConnection;804;0;803;0
WireConnection;804;1;796;0
WireConnection;509;0;522;0
WireConnection;508;0;522;0
WireConnection;1049;0;1050;0
WireConnection;1049;1;1161;0
WireConnection;1039;0;1245;0
WireConnection;1039;1;1049;0
WireConnection;512;0;509;0
WireConnection;512;1;508;0
WireConnection;512;2;647;0
WireConnection;988;0;989;0
WireConnection;988;1;1118;0
WireConnection;513;0;510;0
WireConnection;772;0;804;0
WireConnection;1251;0;1189;0
WireConnection;1162;0;1039;0
WireConnection;1162;1;988;0
WireConnection;518;0;512;0
WireConnection;518;1;513;0
WireConnection;1014;0;1162;0
WireConnection;1014;1;1252;0
WireConnection;792;0;518;0
WireConnection;792;1;773;0
WireConnection;1223;0;1014;0
WireConnection;798;1;518;0
WireConnection;798;0;792;0
WireConnection;1255;0;1256;0
WireConnection;1255;1;1223;0
WireConnection;842;0;841;0
WireConnection;842;1;798;0
WireConnection;473;0;842;0
WireConnection;901;0;1255;0
WireConnection;955;0;474;0
WireConnection;955;1;844;0
WireConnection;955;2;954;0
WireConnection;580;1;955;0
WireConnection;580;0;582;0
WireConnection;876;0;838;0
WireConnection;877;0;563;0
WireConnection;533;1;474;0
WireConnection;533;0;844;0
WireConnection;878;0;426;0
WireConnection;0;13;580;0
ASEEND*/
//CHKSM=85A2E46F06B91C60C2D131FA5A199AB172C010A2
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InkShaderTest"
{
	Properties
	{
		_Object_Albedo_Texture("Object_Albedo_Texture", 2D) = "white" {}
		_Object_Normal_Texture("Object_Normal_Texture", 2D) = "white" {}
		[Toggle(_LIGHTDEBUG_ON)] _LightDebug("LightDebug", Float) = 0
		[Toggle(_CUSTOMWORLDSPACENORMAL_ON)] _CustomWorldSpaceNormal("CustomWorldSpaceNormal?", Float) = 0
		_Object_WorldSpaceNormal_Texture("Object_WorldSpaceNormal_Texture", 2D) = "white" {}
		_Object_Roughness_Texture("Object_Roughness_Texture", 2D) = "white" {}
		[Toggle(_ROUGNESSCOLOR_ON)] _RougnessColor("RougnessColor", Float) = 0
		_Rougness_Color("Rougness_Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_Ink_Texture("Ink_Texture", 2D) = "white" {}
		_Ink_Tiling("Ink_Tiling", Float) = 1
		[Toggle(_MOVINGPAPERGRUNGE_ON)] _MovingPaperGrunge("MovingPaperGrunge?", Float) = 1
		_PaperGrunge_Texture("Paper/Grunge_Texture", 2D) = "white" {}
		_PaperGrunge_Tiling("Paper/Grunge_Tiling", Float) = 1
		_PaperContrast("PaperContrast", Color) = (0.5660378,0.5660378,0.5660378,0)
		_PaperMultiply("PaperMultiply", Float) = 1.58
		_Edge_Noise_Texture("Edge_Noise_Texture", 2D) = "white" {}
		_Noise_Tiling("Noise_Tiling", Float) = 1
		_StepShadow("StepShadow", Float) = 0.03
		_StepAttenuation("StepAttenuation", Float) = 0.3
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		_Noise_Panner("Noise_Panner", Vector) = (0.2,-0.1,0,0)
		_Roughness_Multiplier("Roughness_Multiplier", Float) = 1
		[Toggle(_ISPLAYERINBRUME_ON)] _isPlayerInBrume("isPlayerInBrume", Float) = 0
		_InBrume_Contrast("InBrume_Contrast", Float) = 1
		_InBrume_Color("InBrume_Color", Color) = (0,0,0,0)
		[Toggle(_SCREENBASEDNOISE_ON)] _ScreenBasedNoise("ScreenBasedNoise?", Float) = 0
		[Toggle(_SPECULAR_ON)] _Specular("Specular?", Float) = 1
		_SpeculartStepMin("SpeculartStepMin", Float) = 0
		_SpecularStepMax("SpecularStepMax", Float) = 1
		_SpecularNoise("SpecularNoise", Float) = 1
		_SpecularColor("SpecularColor", Color) = (0.9433962,0.8590411,0.6274475,0)
		_Flipbook_StartFrame("Flipbook_StartFrame", Float) = 0
		_Flipbook_Columns("Flipbook_Columns", Float) = 1
		_Flipbook_Rows("Flipbook_Rows", Float) = 1
		_Flipbook_Speed("Flipbook_Speed", Float) = 1
		[Toggle(_RIMLIGHT_ON)] _RimLight("RimLight?", Float) = 0
		_RimLightColor("RimLightColor", Color) = (1,0,0,0)
		_RimLightEmission_Multiplier("RimLightEmission_Multiplier", Float) = 1
		_ColorCorrection_Multiply("ColorCorrection_Multiply", Color) = (1,1,1,0)
		_Float6("Float 6", Float) = 0.9
		_Float7("Float 7", Float) = 0.91
		[Toggle(_RIMLIGHT_CUSTOMNORMAL_ON)] _RimLight_CustomNormal("RimLight_CustomNormal", Float) = 0
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
		#pragma shader_feature_local _ISPLAYERINBRUME_ON
		#pragma shader_feature_local _RIMLIGHT_ON
		#pragma shader_feature_local _ROUGNESSCOLOR_ON
		#pragma shader_feature_local _SPECULAR_ON
		#pragma shader_feature_local _MOVINGPAPERGRUNGE_ON
		#pragma shader_feature_local _CUSTOMWORLDSPACENORMAL_ON
		#pragma shader_feature_local _SCREENBASEDNOISE_ON
		#pragma shader_feature_local _RIMLIGHT_CUSTOMNORMAL_ON
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

		uniform float4 _ColorCorrection_Multiply;
		uniform sampler2D _Object_Roughness_Texture;
		uniform float4 _Object_Roughness_Texture_ST;
		uniform float _Roughness_Multiplier;
		uniform float4 _Rougness_Color;
		uniform float _SpeculartStepMin;
		uniform float _SpecularStepMax;
		uniform sampler2D _Object_Normal_Texture;
		uniform float4 _Object_Normal_Texture_ST;
		uniform sampler2D _Edge_Noise_Texture;
		uniform float _SpecularNoise;
		uniform float4 _SpecularColor;
		uniform sampler2D _PaperGrunge_Texture;
		uniform float _PaperGrunge_Tiling;
		uniform float _Flipbook_Columns;
		uniform float _Flipbook_Rows;
		uniform float _Flipbook_Speed;
		uniform float _Flipbook_StartFrame;
		uniform float4 _PaperContrast;
		uniform float _PaperMultiply;
		uniform sampler2D _Ink_Texture;
		uniform float _Ink_Tiling;
		uniform sampler2D _Object_Albedo_Texture;
		uniform float _StepShadow;
		uniform float _StepAttenuation;
		uniform sampler2D _Object_WorldSpaceNormal_Texture;
		uniform float4 _Object_WorldSpaceNormal_Texture_ST;
		uniform float2 _Noise_Panner;
		uniform float _Noise_Tiling;
		uniform float4 _ShadowColor;
		uniform float _RimLightEmission_Multiplier;
		uniform float4 _RimLightColor;
		uniform float _Float6;
		uniform float _Float7;
		uniform float _InBrume_Contrast;
		uniform float4 _InBrume_Color;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
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
			#ifdef _ROUGNESSCOLOR_ON
				float4 staticSwitch507 = _Rougness_Color;
			#else
				float4 staticSwitch507 = ( tex2D( _Object_Roughness_Texture, uv_Object_Roughness_Texture ) * _Roughness_Multiplier );
			#endif
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
			float2 temp_output_466_0 = ( (ase_screenPosNorm).xy * _PaperGrunge_Tiling );
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles664 = _Flipbook_Columns * _Flipbook_Rows;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset664 = 1.0f / _Flipbook_Columns;
			float fbrowsoffset664 = 1.0f / _Flipbook_Rows;
			// Speed of animation
			float fbspeed664 = _Time.y * _Flipbook_Speed;
			// UV Tiling (col and row offset)
			float2 fbtiling664 = float2(fbcolsoffset664, fbrowsoffset664);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex664 = round( fmod( fbspeed664 + _Flipbook_StartFrame, fbtotaltiles664) );
			fbcurrenttileindex664 += ( fbcurrenttileindex664 < 0) ? fbtotaltiles664 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox664 = round ( fmod ( fbcurrenttileindex664, _Flipbook_Columns ) );
			// Multiply Offset X by coloffset
			float fboffsetx664 = fblinearindextox664 * fbcolsoffset664;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy664 = round( fmod( ( fbcurrenttileindex664 - fblinearindextox664 ) / _Flipbook_Columns, _Flipbook_Rows ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy664 = (int)(_Flipbook_Rows-1) - fblinearindextoy664;
			// Multiply Offset Y by rowoffset
			float fboffsety664 = fblinearindextoy664 * fbrowsoffset664;
			// UV Offset
			float2 fboffset664 = float2(fboffsetx664, fboffsety664);
			// Flipbook UV
			half2 fbuv664 = temp_output_466_0 * fbtiling664 + fboffset664;
			// *** END Flipbook UV Animation vars ***
			#ifdef _MOVINGPAPERGRUNGE_ON
				float2 staticSwitch671 = fbuv664;
			#else
				float2 staticSwitch671 = temp_output_466_0;
			#endif
			float grayscale455 = Luminance(tex2D( _PaperGrunge_Texture, staticSwitch671 ).rgb);
			float2 temp_cast_7 = (_Ink_Tiling).xx;
			float2 uv_TexCoord672 = i.uv_texcoord * temp_cast_7;
			float4 blendOpSrc461 = ( ( ( grayscale455 + _PaperContrast ) * _PaperMultiply ) * tex2D( _Ink_Texture, uv_TexCoord672 ) );
			float4 blendOpDest461 = tex2D( _Object_Albedo_Texture, i.uv_texcoord );
			float temp_output_387_0 = ( _StepShadow + _StepAttenuation );
			float2 uv_Object_WorldSpaceNormal_Texture = i.uv_texcoord * _Object_WorldSpaceNormal_Texture_ST.xy + _Object_WorldSpaceNormal_Texture_ST.zw;
			#ifdef _CUSTOMWORLDSPACENORMAL_ON
				float4 staticSwitch575 = tex2D( _Object_WorldSpaceNormal_Texture, uv_Object_WorldSpaceNormal_Texture );
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
			float4 blendOpSrc428 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
			float4 blendOpDest428 = ( temp_output_562_0 + temp_output_449_0 );
			float4 RGB514 = ( saturate( ( blendOpSrc428 * blendOpDest428 ) ));
			float4 temp_output_518_0 = ( ( float4( (staticSwitch507).rgb , 0.0 ) * (staticSwitch507).a * staticSwitch647 ) + float4( (RGB514).rgb , 0.0 ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			#ifdef _RIMLIGHT_CUSTOMNORMAL_ON
				float3 staticSwitch820 = (WorldNormalVector( i , tex2D( _Object_Normal_Texture, uv_Object_Normal_Texture ).rgb ));
			#else
				float3 staticSwitch820 = ase_vertexNormal;
			#endif
			float dotResult805 = dot( staticSwitch820 , ase_worldViewDir );
			float smoothstepResult811 = smoothstep( _Float6 , _Float7 , ( 1.0 - dotResult805 ));
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
			float4 EndClassic473 = staticSwitch798;
			float grayscale535 = Luminance(EndClassic473.rgb);
			#ifdef _ISPLAYERINBRUME_ON
				float4 staticSwitch533 = CalculateContrast(_InBrume_Contrast,( grayscale535 + _InBrume_Color ));
			#else
				float4 staticSwitch533 = ( _ColorCorrection_Multiply * EndClassic473 );
			#endif
			float4 temp_cast_18 = (normal_LightDir23).xxxx;
			#ifdef _LIGHTDEBUG_ON
				float4 staticSwitch580 = temp_cast_18;
			#else
				float4 staticSwitch580 = staticSwitch533;
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
Version=18301
0;0;1920;1019;5588.508;3127.18;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;824;-8050.948,-3177.751;Inherit;False;6818;5430;IN BRUME ;15;823;521;31;468;471;520;428;514;510;513;773;518;792;798;473;;0.4622642,0.4622642,0.4622642,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;521;-5568.948,-3127.751;Inherit;False;2866.093;613.3671;Noise;16;570;481;566;476;572;571;484;487;564;565;477;480;479;478;573;825;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-5456.948,-2791.751;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;479;-5264.948,-2711.751;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;16;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;825;-5238.508,-2982.18;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;16;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;480;-5248.948,-2791.751;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;31;-7536.948,-3127.751;Inherit;False;1788.085;588.8215;Normal Light Dir;9;574;23;12;10;11;575;576;710;711;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector3Node;576;-7456.948,-2967.751;Inherit;False;Constant;_Vector0;Vector 0;25;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;565;-5024.947,-2999.751;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;574;-7472.948,-2775.751;Inherit;True;Property;_Object_WorldSpaceNormal_Texture;Object_WorldSpaceNormal_Texture;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;487;-4576.947,-2663.751;Inherit;False;Property;_Noise_Panner;Noise_Panner;20;0;Create;True;0;0;False;0;False;0.2,-0.1;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-5024.947,-2791.751;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;564;-4656.947,-2823.751;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;25;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;572;-4352.946,-2967.751;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;575;-7152.948,-2967.751;Inherit;False;Property;_CustomWorldSpaceNormal;CustomWorldSpaceNormal?;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-6832.948,-2839.751;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;571;-4192.946,-2999.751;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-6816.948,-2983.751;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;573;-3920.948,-2999.751;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-6560.948,-2983.751;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;484;-4352.946,-2743.751;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;468;-7536.948,-2247.751;Inherit;False;3534.264;942.9596;Paper + Object Texture;26;671;661;664;670;668;667;666;665;674;672;528;532;461;530;426;427;463;458;455;454;460;526;464;466;465;525;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LightAttenuation;710;-6544.948,-2711.751;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;476;-3712.948,-2775.751;Inherit;True;Property;_Edge_Noise_Texture;Edge_Noise_Texture;15;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;471;-6992.948,-1159.751;Inherit;False;3004.532;1100.889;Shadow Smooth Edge + Int Shadow;19;449;562;563;450;387;444;445;385;401;446;447;397;448;470;469;388;386;482;768;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;566;-3712.948,-3015.751;Inherit;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;476;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-7376.948,-2151.751;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;711;-6272.948,-2983.751;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-6960.948,-503.7512;Inherit;False;Property;_StepShadow;StepShadow;17;0;Create;True;0;0;False;0;False;0.03;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;570;-3248.948,-2775.751;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-6528.948,-839.7512;Inherit;False;Property;_StepAttenuation;StepAttenuation;18;0;Create;True;0;0;False;0;False;0.3;-0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;463;-7168.948,-2071.751;Inherit;False;Property;_PaperGrunge_Tiling;Paper/Grunge_Tiling;12;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;520;-8000.948,56.24882;Inherit;False;4004.285;1357.365;Add Rougness and Normal;28;512;509;508;507;639;623;636;501;522;502;523;634;640;630;625;632;626;619;633;506;504;627;499;500;498;519;656;647;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-5984.948,-2999.751;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;465;-7152.948,-2151.751;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;665;-7360.948,-1783.751;Inherit;False;Property;_Flipbook_Columns;Flipbook_Columns;32;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;519;-7936.948,1176.249;Inherit;True;Property;_Object_Normal_Texture;Object_Normal_Texture;1;0;Create;True;0;0;False;0;False;-1;2418409f260e65a4baa4d7d8b8b8a53e;2418409f260e65a4baa4d7d8b8b8a53e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;469;-6448.948,-1095.751;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-2928.948,-2759.751;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;670;-7312.948,-1463.751;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;667;-7344.948,-1623.751;Inherit;False;Property;_Flipbook_Speed;Flipbook_Speed;34;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-6944.948,-2151.751;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;668;-7344.948,-1543.751;Inherit;False;Property;_Flipbook_StartFrame;Flipbook_StartFrame;31;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;666;-7344.948,-1703.751;Inherit;False;Property;_Flipbook_Rows;Flipbook_Rows;33;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-6336.948,-855.7512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;498;-7568.948,1176.249;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-6176.948,-1095.751;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;664;-6928.948,-1591.751;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;482;-5920.948,-919.751;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;448;-6192.948,-503.7512;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-5984.948,-455.7512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-5696.948,-1095.751;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;500;-7456.948,984.2489;Inherit;False;Blinn-Phong Half Vector;-1;;9;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;671;-6640.948,-1927.751;Inherit;True;Property;_MovingPaperGrunge;MovingPaperGrunge?;10;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-6016.948,-663.7512;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;499;-7360.948,1176.249;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;823;-7008.948,1464.249;Inherit;False;3007.976;788.3442;Rim Light;18;806;817;810;820;807;805;812;809;814;819;811;818;771;796;803;804;772;816;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-5984.948,-551.7512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-5472.948,-1095.751;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;806;-6960.948,1640.249;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-5776.948,-583.7512;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;454;-6208.948,-2199.751;Inherit;True;Property;_PaperGrunge_Texture;Paper/Grunge_Texture;11;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;504;-7200.948,1080.249;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;627;-6560.948,792.2488;Inherit;False;Property;_SpecularNoise;SpecularNoise;29;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;817;-6512.948,1576.249;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;450;-5152.948,-263.7512;Inherit;False;Property;_ShadowColor;ShadowColor;19;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.462264,0.462264,0.462264,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;674;-5776.948,-1783.751;Inherit;False;Property;_Ink_Tiling;Ink_Tiling;9;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;458;-5648.948,-2103.751;Inherit;False;Property;_PaperContrast;PaperContrast;13;0;Create;True;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0.5019608,0.5019608,0.5019608,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;506;-7184.948,904.2488;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;444;-5424.948,-583.7512;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;626;-6400.948,776.2488;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;619;-7056.948,648.2488;Inherit;False;Property;_SpeculartStepMin;SpeculartStepMin;27;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;455;-5856.948,-2199.751;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;810;-6528.948,1800.249;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;633;-7056.948,728.2488;Inherit;False;Property;_SpecularStepMax;SpecularStepMax;28;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;632;-6720.948,632.2488;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;460;-5392.948,-2183.751;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-5216.948,-1959.751;Inherit;False;Property;_PaperMultiply;PaperMultiply;14;0;Create;True;0;0;False;0;False;1.58;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;449;-5008.947,-583.7512;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;672;-5600.948,-1799.751;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;625;-6176.948,728.2488;Inherit;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;476;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;807;-6096.948,2024.249;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;820;-6160.948,1800.249;Inherit;False;Property;_RimLight_CustomNormal;RimLight_CustomNormal;44;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;427;-4896.947,-1703.751;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;528;-5344.948,-1831.751;Inherit;True;Property;_Ink_Texture;Ink_Texture;8;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;88d75bbfdb8a26849988713b4599646a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;630;-5856.948,632.2488;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;805;-5824.948,1800.249;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-5024.947,-2103.751;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;562;-4640.947,-903.7512;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;640;-5648.948,632.2488;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;768;-4368.946,-1031.751;Inherit;False;LightMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;814;-5536.948,2104.249;Inherit;False;Property;_Float7;Float 7;43;0;Create;True;0;0;False;0;False;0.91;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;426;-4656.947,-1767.751;Inherit;True;Property;_Object_Albedo_Texture;Object_Albedo_Texture;0;0;Create;True;0;0;False;0;False;-1;6395db2a80729484b931cff6723fa89f;6395db2a80729484b931cff6723fa89f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;809;-5584.948,1800.249;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;812;-5536.948,2024.249;Inherit;False;Property;_Float6;Float 6;42;0;Create;True;0;0;False;0;False;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-4608.947,-2023.751;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;811;-5328.948,1800.249;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;819;-5264.948,2136.249;Inherit;False;768;LightMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;461;-4272.946,-1975.751;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;634;-5488.948,632.2488;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;563;-4224.946,-599.7512;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;502;-5424.948,88.24881;Inherit;True;Property;_Object_Roughness_Texture;Object_Roughness_Texture;5;0;Create;True;0;0;False;0;False;-1;e3ffd422ed294bf4b8c909ae388edf91;462e6eb6ea263d24c9aa2becc5fa3ffa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;523;-5392.948,296.2488;Inherit;False;Property;_Roughness_Multiplier;Roughness_Multiplier;21;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;428;-3728.948,-1287.751;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;636;-5248.948,632.2488;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;818;-5056.948,1800.249;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;771;-5056.948,1528.249;Inherit;False;Property;_RimLightColor;RimLightColor;39;0;Create;True;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-5040.947,184.2488;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;623;-5072.948,744.2488;Inherit;False;Property;_SpecularColor;SpecularColor;30;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.9433962,0.8590411,0.6274475,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;501;-5104.948,312.2488;Float;False;Property;_Rougness_Color;Rougness_Color;7;0;Create;True;0;0;False;0;False;0.3921569,0.3921569,0.3921569,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;507;-4784.947,376.2488;Inherit;False;Property;_RougnessColor;RougnessColor;6;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;514;-3440.948,-1287.751;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;796;-4784.947,1736.249;Inherit;True;Darken;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;656;-4864.947,1192.249;Inherit;False;Constant;_Float2;Float 2;31;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-4848.947,632.2488;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;803;-4720.947,1512.249;Inherit;False;Property;_RimLightEmission_Multiplier;RimLightEmission_Multiplier;40;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;508;-4512.947,424.2488;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;509;-4512.947,344.2488;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;647;-4656.947,792.2488;Inherit;False;Property;_Specular;Specular?;26;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;510;-3712.948,632.2488;Inherit;False;514;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;804;-4432.946,1720.249;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;513;-3504.948,632.2488;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;-4224.946,376.2488;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;772;-4224.946,1736.249;Inherit;False;CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;518;-3088.948,376.2488;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;773;-2736.948,536.2488;Inherit;False;772;CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;792;-2512.948,456.2488;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;798;-2256.948,376.2488;Inherit;False;Property;_RimLight;RimLight?;38;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-1456.947,376.2488;Inherit;False;EndClassic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;534;-157.2233,-132.6539;Inherit;False;473;EndClassic;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;541;103.4035,183.2833;Inherit;False;Property;_InBrume_Color;InBrume_Color;24;0;Create;True;0;0;False;0;False;0,0,0,0;0.6132076,0.6132076,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;535;75.88928,-131.4961;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;540;359.457,90.58168;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;539;405.457,349.5816;Inherit;False;Property;_InBrume_Contrast;InBrume_Contrast;23;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;783;392.1096,-678.2971;Inherit;False;Property;_ColorCorrection_Multiply;ColorCorrection_Multiply;41;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;474;452.7513,-382.8482;Inherit;False;473;EndClassic;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;782;696.8977,-403.2203;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;536;639.4573,93.58168;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.5;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;1124.033,-172.9984;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;533;1010.56,-305.7814;Inherit;False;Property;_isPlayerInBrume;isPlayerInBrume;22;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;737;-5221.888,3566.319;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;705;-3575.789,3666.733;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;693;-5531.253,4097.119;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;816;-6784.948,1816.249;Inherit;True;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;699;-3820.618,3666.211;Inherit;True;2;0;FLOAT;0.2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;697;-5699.65,3893.206;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NegateNode;696;-4711.839,3887.775;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;532;-4496.947,-2135.751;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;580;1376.491,-385.0632;Inherit;False;Property;_LightDebug;LightDebug;2;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;746;-3959.926,3520.473;Inherit;False;Property;_Float4;Float 4;36;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;748;-5616.399,3564.648;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;709;-3314.046,3521.2;Inherit;False;Property;_Float3;Float 3;35;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;706;-3363.789,3667.733;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;4.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;736;-5419.416,3566.295;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;694;-4065.291,3665.681;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;695;-5046.444,3889.737;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;821;2332.93,-179.7783;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;822;1899.76,-124.5603;Inherit;True;Property;_TextureSample4;Texture Sample 4;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;708;-3033.709,3560.463;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;747;-3508.926,3534.473;Inherit;False;Property;_Float5;Float 5;37;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;745;-5055.5,3714.636;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;661;-7360.948,-1911.751;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalizeNode;698;-5456.869,3891.727;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;744;-4735.5,3648.636;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2724.836,-545.6027;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;InkShaderTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.06;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;480;0;478;0
WireConnection;565;0;825;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;564;1;565;0
WireConnection;564;0;477;0
WireConnection;572;0;487;0
WireConnection;575;1;576;0
WireConnection;575;0;574;0
WireConnection;571;0;564;0
WireConnection;571;2;572;0
WireConnection;10;0;575;0
WireConnection;573;0;571;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;484;0;564;0
WireConnection;484;2;487;0
WireConnection;476;1;484;0
WireConnection;566;1;573;0
WireConnection;711;0;12;0
WireConnection;711;1;710;0
WireConnection;570;0;566;1
WireConnection;570;1;476;1
WireConnection;23;0;711;0
WireConnection;465;0;464;0
WireConnection;481;0;570;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;498;0;519;0
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;664;0;466;0
WireConnection;664;1;665;0
WireConnection;664;2;666;0
WireConnection;664;3;667;0
WireConnection;664;4;668;0
WireConnection;664;5;670;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;671;1;466;0
WireConnection;671;0;664;0
WireConnection;499;0;498;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;401;0;397;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;454;1;671;0
WireConnection;504;0;500;0
WireConnection;504;1;499;0
WireConnection;817;0;806;0
WireConnection;506;0;504;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;626;0;627;0
WireConnection;455;0;454;0
WireConnection;632;0;506;0
WireConnection;632;1;619;0
WireConnection;632;2;633;0
WireConnection;460;0;455;0
WireConnection;460;1;458;0
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;672;0;674;0
WireConnection;625;1;626;0
WireConnection;820;1;810;0
WireConnection;820;0;817;0
WireConnection;528;1;672;0
WireConnection;630;0;632;0
WireConnection;630;1;625;0
WireConnection;805;0;820;0
WireConnection;805;1;807;0
WireConnection;525;0;460;0
WireConnection;525;1;526;0
WireConnection;562;0;449;0
WireConnection;640;0;630;0
WireConnection;768;0;562;0
WireConnection;426;1;427;0
WireConnection;809;0;805;0
WireConnection;530;0;525;0
WireConnection;530;1;528;0
WireConnection;811;0;809;0
WireConnection;811;1;812;0
WireConnection;811;2;814;0
WireConnection;461;0;530;0
WireConnection;461;1;426;0
WireConnection;634;0;640;0
WireConnection;563;0;562;0
WireConnection;563;1;449;0
WireConnection;428;0;461;0
WireConnection;428;1;563;0
WireConnection;636;0;634;0
WireConnection;818;0;811;0
WireConnection;818;1;819;0
WireConnection;522;0;502;0
WireConnection;522;1;523;0
WireConnection;507;1;522;0
WireConnection;507;0;501;0
WireConnection;514;0;428;0
WireConnection;796;0;771;0
WireConnection;796;1;818;0
WireConnection;639;0;636;0
WireConnection;639;1;623;0
WireConnection;508;0;507;0
WireConnection;509;0;507;0
WireConnection;647;1;656;0
WireConnection;647;0;639;0
WireConnection;804;0;803;0
WireConnection;804;1;796;0
WireConnection;513;0;510;0
WireConnection;512;0;509;0
WireConnection;512;1;508;0
WireConnection;512;2;647;0
WireConnection;772;0;804;0
WireConnection;518;0;512;0
WireConnection;518;1;513;0
WireConnection;792;0;518;0
WireConnection;792;1;773;0
WireConnection;798;1;518;0
WireConnection;798;0;792;0
WireConnection;473;0;798;0
WireConnection;535;0;534;0
WireConnection;540;0;535;0
WireConnection;540;1;541;0
WireConnection;782;0;783;0
WireConnection;782;1;474;0
WireConnection;536;1;540;0
WireConnection;536;0;539;0
WireConnection;533;1;782;0
WireConnection;533;0;536;0
WireConnection;737;0;736;0
WireConnection;705;0;699;0
WireConnection;699;0;746;0
WireConnection;699;1;694;0
WireConnection;696;0;695;0
WireConnection;580;1;533;0
WireConnection;580;0;582;0
WireConnection;706;0;705;0
WireConnection;706;1;747;0
WireConnection;736;0;748;0
WireConnection;694;0;744;0
WireConnection;694;1;696;0
WireConnection;695;0;698;0
WireConnection;695;1;693;0
WireConnection;821;0;822;0
WireConnection;708;0;709;0
WireConnection;708;1;706;0
WireConnection;745;0;737;0
WireConnection;698;0;697;0
WireConnection;744;0;737;0
WireConnection;744;1;745;0
WireConnection;0;13;580;0
ASEEND*/
//CHKSM=8842A185EEB0C55F5BB7E3D039BC4E35EAA00107
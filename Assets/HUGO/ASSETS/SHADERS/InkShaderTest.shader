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
		[Toggle(_FRESNEL_ON)] _Fresnel("Fresnel?", Float) = 1
		_FresnelColor("FresnelColor", Color) = (0.9433962,0.8590411,0.6274475,0)
		_Flipbook_StartFrame("Flipbook_StartFrame", Float) = 0
		_Flipbook_Columns("Flipbook_Columns", Float) = 1
		_Flipbook_Rows("Flipbook_Rows", Float) = 1
		_Flipbook_Speed("Flipbook_Speed", Float) = 1
		[Toggle(_MOVINGGRAIN_ON)] _MovingGrain("MovingGrain?", Float) = 1
		_ColorCorrection_Multiply("ColorCorrection_Multiply", Color) = (1,1,1,0)
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
		#pragma shader_feature_local _ROUGNESSCOLOR_ON
		#pragma shader_feature_local _SPECULAR_ON
		#pragma shader_feature_local _MOVINGGRAIN_ON
		#pragma shader_feature_local _CUSTOMWORLDSPACENORMAL_ON
		#pragma shader_feature_local _SCREENBASEDNOISE_ON
		#pragma shader_feature_local _FRESNEL_ON
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
		uniform float4 _FresnelColor;
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
			#ifdef _MOVINGGRAIN_ON
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
			#ifdef _SCREENBASEDNOISE_ON
				float2 staticSwitch564 = ( (ase_screenPosNorm).xy * _Noise_Tiling );
			#else
				float2 staticSwitch564 = i.uv_texcoord;
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
			float4 temp_cast_10 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest444) / max( blendOpSrc444, 0.00001) ) ) ))).xxxx;
			float4 blendOpSrc449 = temp_cast_10;
			float4 blendOpDest449 = _ShadowColor;
			float4 temp_output_449_0 = ( saturate( ( blendOpSrc449 * blendOpDest449 ) ));
			float4 temp_output_562_0 = step( temp_output_449_0 , float4( 0,0,0,0 ) );
			float4 blendOpSrc428 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
			float4 blendOpDest428 = ( temp_output_562_0 + temp_output_449_0 );
			float4 RGB514 = ( saturate( ( blendOpSrc428 * blendOpDest428 ) ));
			float4 temp_cast_12 = (0.0).xxxx;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV641 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode641 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV641, 5.0 ) );
			#ifdef _FRESNEL_ON
				float4 staticSwitch654 = ( ( 1.0 - step( fresnelNode641 , 0.8 ) ) * _FresnelColor );
			#else
				float4 staticSwitch654 = temp_cast_12;
			#endif
			float4 temp_output_642_0 = ( ( ( float4( (staticSwitch507).rgb , 0.0 ) * (staticSwitch507).a * staticSwitch647 ) + float4( (RGB514).rgb , 0.0 ) ) + staticSwitch654 );
			float4 EndClassic473 = temp_output_642_0;
			float grayscale535 = Luminance(EndClassic473.rgb);
			#ifdef _ISPLAYERINBRUME_ON
				float4 staticSwitch533 = CalculateContrast(_InBrume_Contrast,( grayscale535 + _InBrume_Color ));
			#else
				float4 staticSwitch533 = ( _ColorCorrection_Multiply * EndClassic473 );
			#endif
			float4 temp_cast_14 = (normal_LightDir23).xxxx;
			#ifdef _LIGHTDEBUG_ON
				float4 staticSwitch580 = temp_cast_14;
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
0;0;1920;1019;615.6896;1032.101;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;521;-4187.164,-2898.646;Inherit;False;2866.093;613.3671;Noise;15;570;481;566;476;572;571;484;487;564;565;477;480;479;478;573;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-4075.645,-2567.392;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;31;-6158.848,-2894.248;Inherit;False;1788.085;588.8215;Normal Light Dir;9;574;23;12;10;11;575;576;710;711;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-3880.015,-2488.472;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;16;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;480;-3862.02,-2568.052;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;576;-6080.387,-2733.076;Inherit;False;Constant;_Vector0;Vector 0;25;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;574;-6096.266,-2554.335;Inherit;True;Property;_Object_WorldSpaceNormal_Texture;Object_WorldSpaceNormal_Texture;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-3648.02,-2566.052;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;565;-3653.087,-2771.556;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;487;-3204.162,-2440.872;Inherit;False;Property;_Noise_Panner;Noise_Panner;20;0;Create;True;0;0;False;0;False;0.2,-0.1;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;572;-2975.52,-2742.814;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;575;-5774.66,-2732.68;Inherit;False;Property;_CustomWorldSpaceNormal;CustomWorldSpaceNormal?;4;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;564;-3270.673,-2594.181;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;25;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;571;-2807.52,-2771.814;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-5461.036,-2611.78;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;468;-6153.265,-2020.089;Inherit;False;3534.264;942.9596;Paper + Object Texture;26;671;661;664;670;668;667;666;665;674;672;528;532;461;530;426;427;463;458;455;454;460;526;464;466;465;525;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-5442.841,-2763.509;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;12;-5184.938,-2762.318;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-5992.181,-1921.14;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;484;-2968.163,-2514.872;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LightAttenuation;710;-5167.715,-2484.768;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;573;-2536.912,-2772.683;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;520;-6616.238,278.6839;Inherit;False;4004.285;1357.365;Add Rougness and Normal;28;512;509;508;507;639;623;636;501;522;502;523;634;640;630;625;632;626;619;633;506;504;627;499;500;498;519;656;647;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;471;-5620,-925.1917;Inherit;False;3004.532;1100.889;Shadow Smooth Edge + Int Shadow;19;449;562;563;450;387;444;445;385;401;446;447;397;448;470;469;388;386;482;768;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;711;-4888.869,-2763.006;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;476;-2340.083,-2548.759;Inherit;True;Property;_Edge_Noise_Texture;Edge_Noise_Texture;15;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;566;-2336.532,-2795.581;Inherit;True;Property;_TextureSample0;Texture Sample 0;15;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;476;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;463;-5796.551,-1842.22;Inherit;False;Property;_PaperGrunge_Tiling;Paper/Grunge_Tiling;12;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;465;-5778.555,-1921.799;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;670;-5929.286,-1237.534;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-5564.555,-1919.799;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-5589.132,-281.3859;Inherit;False;Property;_StepShadow;StepShadow;17;0;Create;True;0;0;False;0;False;0.03;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-5145.659,-605.2927;Inherit;False;Property;_StepAttenuation;StepAttenuation;18;0;Create;True;0;0;False;0;False;0.3;-0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;519;-6562.273,1401.607;Inherit;True;Property;_Object_Normal_Texture;Object_Normal_Texture;2;0;Create;True;0;0;False;0;False;-1;2418409f260e65a4baa4d7d8b8b8a53e;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;667;-5968.641,-1397.689;Inherit;False;Property;_Flipbook_Speed;Flipbook_Speed;36;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;666;-5971.641,-1481.689;Inherit;False;Property;_Flipbook_Rows;Flipbook_Rows;35;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;668;-5970.946,-1321.198;Inherit;False;Property;_Flipbook_StartFrame;Flipbook_StartFrame;33;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;570;-1867.795,-2555.315;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;665;-5973.641,-1559.689;Inherit;False;Property;_Flipbook_Columns;Flipbook_Columns;34;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-4612.006,-2766.573;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-4951.658,-625.2927;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;664;-5554.466,-1364.38;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-1543.069,-2532.834;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;498;-6187.097,1407.318;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;469;-5061.394,-875.1915;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;482;-4542.546,-700.0279;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-4790.421,-870.8506;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;671;-5263.115,-1696.624;Inherit;True;Property;_MovingGrain;MovingGrain?;37;0;Create;True;0;0;False;0;False;0;1;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;499;-5979.1,1407.318;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;448;-4819.127,-274.7047;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;500;-6081.98,1217.347;Inherit;False;Blinn-Phong Half Vector;-1;;9;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;454;-4833.396,-1967.434;Inherit;True;Property;_PaperGrunge_Texture;Paper/Grunge_Texture;11;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-4311.242,-869.8826;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-4598.042,-228.0058;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;504;-5820.98,1302.347;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-4599.042,-325.0061;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-4636.144,-436.4301;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;627;-5189.209,1023.715;Inherit;False;Property;_SpecularNoise;SpecularNoise;29;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;458;-4271.458,-1873.687;Inherit;False;Property;_PaperContrast;PaperContrast;13;0;Create;True;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0.5019608,0.5019608,0.5019608,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;674;-4398.974,-1556.39;Inherit;False;Property;_Ink_Tiling;Ink_Tiling;10;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;633;-5673.712,954.6584;Inherit;False;Property;_SpecularStepMax;SpecularStepMax;28;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-4094.385,-869.0345;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;506;-5810.98,1129.346;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;455;-4481.458,-1967.686;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-4392.109,-350.1162;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;626;-5013.813,1004.077;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;619;-5675.63,873.6154;Inherit;False;Property;_SpeculartStepMin;SpeculartStepMin;27;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-3829.992,-1735.899;Inherit;False;Property;_PaperMultiply;PaperMultiply;14;0;Create;True;0;0;False;0;False;1.58;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;672;-4226.974,-1573.39;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;460;-4014.46,-1961.686;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;625;-4793.484,957.2251;Inherit;True;Property;_TextureSample1;Texture Sample 1;15;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;476;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;632;-5343.712,864.6583;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;444;-4048.53,-353.7383;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;450;-3775.441,-38.78844;Inherit;False;Property;_ShadowColor;ShadowColor;19;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.462264,0.462264,0.462264,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;630;-4471.777,863.368;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;528;-3969.118,-1602.018;Inherit;True;Property;_Ink_Texture;Ink_Texture;9;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;88d75bbfdb8a26849988713b4599646a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;449;-3627.571,-351.7971;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-3638.992,-1880.9;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;427;-3510.993,-1479.644;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;640;-4262.091,863.6837;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;426;-3277.064,-1535.239;Inherit;True;Property;_Object_Albedo_Texture;Object_Albedo_Texture;0;0;Create;True;0;0;False;0;False;-1;6395db2a80729484b931cff6723fa89f;6395db2a80729484b931cff6723fa89f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-3229.125,-1793.961;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;562;-3265.908,-676.1429;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;563;-2838.187,-376.0784;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;634;-4103.002,858.6088;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;523;-4012.043,519.8615;Inherit;False;Property;_Roughness_Multiplier;Roughness_Multiplier;21;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;461;-2889.247,-1756.537;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;657;-2447.858,988.5723;Inherit;False;1186.823;637.9753;Fresnel;7;641;644;645;653;655;652;654;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;502;-4078.654,324.6838;Inherit;True;Property;_Object_Roughness_Texture;Object_Roughness_Texture;6;0;Create;True;0;0;False;0;False;-1;462e6eb6ea263d24c9aa2becc5fa3ffa;462e6eb6ea263d24c9aa2becc5fa3ffa;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-3655.043,418.8616;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;636;-3871.819,864.4301;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;641;-2397.858,1158.824;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;428;-2352.906,-1059.129;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;623;-3696.563,965.4352;Inherit;False;Property;_SpecularColor;SpecularColor;30;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.9433962,0.8590411,0.6274475,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;501;-3723.219,532.8193;Float;False;Property;_Rougness_Color;Rougness_Color;8;0;Create;True;0;0;False;0;False;0.3921569,0.3921569,0.3921569,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;507;-3409.304,610.0601;Inherit;False;Property;_RougnessColor;RougnessColor;7;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;644;-2084.5,1158.902;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;639;-3469.332,866.7841;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;656;-3479.659,1421.413;Inherit;False;Constant;_Float2;Float 2;31;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;514;-2053.519,-1057.547;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;509;-3127.218,566.8195;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;653;-1922.112,1414.548;Inherit;False;Property;_FresnelColor;FresnelColor;32;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.9433962,0.8590411,0.6274475,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;647;-3273.521,1021.639;Inherit;False;Property;_Specular;Specular?;26;0;Create;True;0;0;False;0;False;0;1;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;508;-3127.218,646.8194;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;645;-1873.404,1157.893;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;510;-2340.873,864.4721;Inherit;False;514;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;652;-1646.384,1157.728;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;-2847.952,603.7423;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;655;-1624.288,1038.572;Inherit;False;Constant;_Float1;Float 1;34;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;513;-2132.966,863.4241;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;654;-1480.034,1039.002;Inherit;False;Property;_Fresnel;Fresnel?;31;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;518;-1716.966,607.4218;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;642;-1248.883,607.1379;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-496.8823,604.4997;Inherit;False;EndClassic;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;534;-155.1106,-128.4961;Inherit;False;473;EndClassic;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;535;75.88928,-131.4961;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;541;103.4035,183.2833;Inherit;False;Property;_InBrume_Color;InBrume_Color;24;0;Create;True;0;0;False;0;False;0,0,0,0;0.6132076,0.6132076,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;539;405.457,349.5816;Inherit;False;Property;_InBrume_Contrast;InBrume_Contrast;23;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;783;392.1096,-678.2971;Inherit;False;Property;_ColorCorrection_Multiply;ColorCorrection_Multiply;45;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;474;452.7513,-382.8482;Inherit;False;473;EndClassic;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;540;359.457,90.58168;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;536;639.4573,93.58168;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;782;696.8977,-403.2203;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;533;1010.56,-305.7814;Inherit;False;Property;_isPlayerInBrume;isPlayerInBrume;22;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;582;1124.033,-172.9984;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;776;-7102.577,2367.955;Inherit;True;Property;_Object_Normal_Texture1;Object_Normal_Texture;2;0;Create;True;0;0;False;0;False;-1;2418409f260e65a4baa4d7d8b8b8a53e;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;773;-887.2383,854.0713;Inherit;False;772;CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;778;-6760.355,2113.864;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;777;-6784.67,2373.123;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;768;-3014.638,-808.8422;Inherit;False;LightMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;779;-6758.355,2213.864;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;769;-6248.994,2667.721;Inherit;False;768;LightMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;775;-6383.577,2266.955;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;748;-2476.136,2683.273;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;771;-5912.391,2162.246;Inherit;False;Property;_Color0;Color 0;44;0;Create;True;0;0;False;0;False;1,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;750;-1650.049,2109.547;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;772;-5395.355,2366.611;Inherit;False;CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;758;-1921.912,2155.465;Inherit;False;Property;_CustomNormal;CustomNormal;41;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldPosInputsNode;697;-2559.387,3011.831;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;532;-3117.126,-1912.362;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;580;1376.491,-385.0632;Inherit;False;Property;_LightDebug;LightDebug;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;756;-2247.777,2003.082;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.UnityObjToClipPosHlpNode;736;-2279.152,2684.92;Inherit;False;1;0;FLOAT3;0,0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;765;-6003.394,2532.552;Inherit;True;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;780;-682.3374,759.6805;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;770;-5625.804,2371.617;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;764;-7317.69,2115.609;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.UnityObjToViewPosHlpNode;749;-2745.893,3205.591;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;763;-7088.898,2113.66;Inherit;True;Property;_TextureSample4;Texture Sample 4;6;0;Create;True;0;0;False;0;False;-1;462e6eb6ea263d24c9aa2becc5fa3ffa;462e6eb6ea263d24c9aa2becc5fa3ffa;True;0;False;white;Auto;False;Instance;502;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;661;-5986.926,-1686.305;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;707;-891.2497,1066.883;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;757;-2245.719,2228.409;Inherit;True;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BlendNormalsNode;695;-1906.181,3008.362;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;747;-368.6624,2653.098;Inherit;False;Property;_Float5;Float 5;40;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;752;-2577.864,1998.702;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;744;-1595.237,2767.261;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.NormalizeNode;698;-2316.606,3010.352;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;745;-1915.237,2833.261;Inherit;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;746;-819.6622,2639.098;Inherit;False;Property;_Float4;Float 4;39;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;708;106.5541,2679.088;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;694;-925.0268,2784.306;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;709;-173.7826,2639.825;Inherit;False;Property;_Float3;Float 3;38;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;760;-1341.549,2172.496;Inherit;False;Property;_Float6;Float 6;42;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;699;-680.3542,2784.836;Inherit;True;2;0;FLOAT;0.2;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComputeScreenPosHlpNode;737;-2081.625,2684.944;Inherit;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;705;-435.5257,2785.358;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;762;-1341.623,2245.578;Inherit;False;Property;_Float7;Float 7;43;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;696;-1571.576,3006.4;Inherit;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PowerNode;706;-223.5258,2786.358;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;4.02;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;759;-1167.549,2109.496;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;693;-2390.99,3215.744;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;519;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1753.067,-537.4021;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;InkShaderTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.06;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;480;0;478;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;572;0;487;0
WireConnection;575;1;576;0
WireConnection;575;0;574;0
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
WireConnection;711;0;12;0
WireConnection;711;1;710;0
WireConnection;476;1;484;0
WireConnection;566;1;573;0
WireConnection;465;0;464;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;570;0;566;1
WireConnection;570;1;476;1
WireConnection;23;0;711;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;664;0;466;0
WireConnection;664;1;665;0
WireConnection;664;2;666;0
WireConnection;664;3;667;0
WireConnection;664;4;668;0
WireConnection;664;5;670;0
WireConnection;481;0;570;0
WireConnection;498;0;519;0
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;671;1;466;0
WireConnection;671;0;664;0
WireConnection;499;0;498;0
WireConnection;454;1;671;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;504;0;500;0
WireConnection;504;1;499;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;401;0;397;0
WireConnection;506;0;504;0
WireConnection;455;0;454;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;626;0;627;0
WireConnection;672;0;674;0
WireConnection;460;0;455;0
WireConnection;460;1;458;0
WireConnection;625;1;626;0
WireConnection;632;0;506;0
WireConnection;632;1;619;0
WireConnection;632;2;633;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;630;0;632;0
WireConnection;630;1;625;0
WireConnection;528;1;672;0
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;525;0;460;0
WireConnection;525;1;526;0
WireConnection;640;0;630;0
WireConnection;426;1;427;0
WireConnection;530;0;525;0
WireConnection;530;1;528;0
WireConnection;562;0;449;0
WireConnection;563;0;562;0
WireConnection;563;1;449;0
WireConnection;634;0;640;0
WireConnection;461;0;530;0
WireConnection;461;1;426;0
WireConnection;522;0;502;0
WireConnection;522;1;523;0
WireConnection;636;0;634;0
WireConnection;428;0;461;0
WireConnection;428;1;563;0
WireConnection;507;1;522;0
WireConnection;507;0;501;0
WireConnection;644;0;641;0
WireConnection;639;0;636;0
WireConnection;639;1;623;0
WireConnection;514;0;428;0
WireConnection;509;0;507;0
WireConnection;647;1;656;0
WireConnection;647;0;639;0
WireConnection;508;0;507;0
WireConnection;645;0;644;0
WireConnection;652;0;645;0
WireConnection;652;1;653;0
WireConnection;512;0;509;0
WireConnection;512;1;508;0
WireConnection;512;2;647;0
WireConnection;513;0;510;0
WireConnection;654;1;655;0
WireConnection;654;0;652;0
WireConnection;518;0;512;0
WireConnection;518;1;513;0
WireConnection;642;0;518;0
WireConnection;642;1;654;0
WireConnection;473;0;642;0
WireConnection;535;0;534;0
WireConnection;540;0;535;0
WireConnection;540;1;541;0
WireConnection;536;1;540;0
WireConnection;536;0;539;0
WireConnection;782;0;783;0
WireConnection;782;1;474;0
WireConnection;533;1;782;0
WireConnection;533;0;536;0
WireConnection;778;0;763;0
WireConnection;777;0;776;0
WireConnection;768;0;562;0
WireConnection;779;0;763;0
WireConnection;775;0;778;0
WireConnection;775;1;779;0
WireConnection;775;2;777;0
WireConnection;750;0;758;0
WireConnection;772;0;770;0
WireConnection;758;1;757;0
WireConnection;758;0;756;0
WireConnection;580;1;533;0
WireConnection;580;0;582;0
WireConnection;756;0;752;0
WireConnection;736;0;748;0
WireConnection;765;0;775;0
WireConnection;765;1;769;0
WireConnection;780;0;642;0
WireConnection;780;1;773;0
WireConnection;770;0;771;0
WireConnection;770;1;765;0
WireConnection;763;1;764;0
WireConnection;707;0;642;0
WireConnection;707;1;759;0
WireConnection;695;0;698;0
WireConnection;695;1;693;0
WireConnection;744;0;737;0
WireConnection;744;1;745;0
WireConnection;698;0;697;0
WireConnection;745;0;737;0
WireConnection;708;0;709;0
WireConnection;708;1;706;0
WireConnection;694;0;744;0
WireConnection;694;1;696;0
WireConnection;699;0;746;0
WireConnection;699;1;694;0
WireConnection;737;0;736;0
WireConnection;705;0;699;0
WireConnection;696;0;695;0
WireConnection;706;0;705;0
WireConnection;706;1;747;0
WireConnection;759;0;750;0
WireConnection;759;1;760;0
WireConnection;759;2;762;0
WireConnection;0;13;580;0
ASEEND*/
//CHKSM=2F58B9FE578D58C7FE5CA34813B97315DF348451
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InkShaderTest"
{
	Properties
	{
		_Object_Albedo_Texture("Object_Albedo_Texture", 2D) = "white" {}
		_Object_Normal_Texture("Object_Normal_Texture", 2D) = "white" {}
		_Object_Roughness_Texture("Object_Roughness_Texture", 2D) = "white" {}
		[Toggle(_ROUGNESSCOLOR_ON)] _RougnessColor("RougnessColor", Float) = 0
		_Rougness_Color("Rougness_Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_Shininess("Shininess", Range( 0.01 , 1)) = 1
		_Ink_Texture("Ink_Texture", 2D) = "white" {}
		_Ink_Tiling("Ink_Tiling", Float) = 1
		_PaperGrunge_Texture("Paper/Grunge_Texture", 2D) = "white" {}
		_PaperGrunge_Tiling("Paper/Grunge_Tiling", Float) = 1
		_PaperContrast("PaperContrast", Color) = (0.5660378,0.5660378,0.5660378,0)
		_PaperMultiply("PaperMultiply", Float) = 1.58
		_Edge_Noise_Texture("Edge_Noise_Texture", 2D) = "white" {}
		_Noise_Tiling("Noise_Tiling", Float) = 1
		_StepShadow("StepShadow", Float) = 0.03
		_EdgeRange("EdgeRange", Float) = -0.1
		_StepAttenuation("StepAttenuation", Float) = -0.27
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		_Noise_Panner("Noise_Panner", Vector) = (0,0,0,0)
		_Roughness_Multiplier("Roughness_Multiplier", Float) = 0
		[Toggle(_ISPLAYERINBRUME_ON)] _isPlayerInBrume("isPlayerInBrume", Float) = 0
		_InBrume_Contrast("InBrume_Contrast", Float) = 1
		_InBrume_Color("InBrume_Color", Color) = (0,0,0,0)
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
		#pragma shader_feature_local _ISPLAYERINBRUME_ON
		#pragma shader_feature_local _ROUGNESSCOLOR_ON
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

		uniform sampler2D _Object_Roughness_Texture;
		uniform float4 _Object_Roughness_Texture_ST;
		uniform float _Roughness_Multiplier;
		uniform float4 _Rougness_Color;
		uniform sampler2D _Object_Normal_Texture;
		uniform float4 _Object_Normal_Texture_ST;
		uniform float _Shininess;
		uniform sampler2D _PaperGrunge_Texture;
		uniform float _PaperGrunge_Tiling;
		uniform float4 _PaperContrast;
		uniform float _PaperMultiply;
		uniform sampler2D _Ink_Texture;
		uniform float _Ink_Tiling;
		uniform sampler2D _Object_Albedo_Texture;
		uniform float _StepShadow;
		uniform float _StepAttenuation;
		uniform sampler2D _Edge_Noise_Texture;
		uniform float2 _Noise_Panner;
		uniform float _Noise_Tiling;
		uniform float4 _ShadowColor;
		uniform float _EdgeRange;
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
			float2 uv_Object_Roughness_Texture = i.uv_texcoord * _Object_Roughness_Texture_ST.xy + _Object_Roughness_Texture_ST.zw;
			float4 temp_cast_0 = (( tex2D( _Object_Roughness_Texture, uv_Object_Roughness_Texture ).a * _Roughness_Multiplier )).xxxx;
			#ifdef _ROUGNESSCOLOR_ON
				float4 staticSwitch507 = _Rougness_Color;
			#else
				float4 staticSwitch507 = temp_cast_0;
			#endif
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
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float grayscale455 = Luminance(tex2D( _PaperGrunge_Texture, ( (ase_screenPosNorm).xy * _PaperGrunge_Tiling ) ).rgb);
			float2 temp_cast_3 = (_Ink_Tiling).xx;
			float2 uv_TexCoord527 = i.uv_texcoord * temp_cast_3;
			float4 blendOpSrc461 = ( ( ( grayscale455 + _PaperContrast ) * _PaperMultiply ) * tex2D( _Ink_Texture, uv_TexCoord527 ) );
			float4 blendOpDest461 = tex2D( _Object_Albedo_Texture, i.uv_texcoord );
			float temp_output_387_0 = ( _StepShadow + _StepAttenuation );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult12 = dot( ase_worldNormal , ase_worldlightDir );
			float normal_LightDir23 = dotResult12;
			float smoothstepResult385 = smoothstep( _StepShadow , temp_output_387_0 , normal_LightDir23);
			float2 panner484 = ( 1.0 * _Time.y * _Noise_Panner + ( (ase_screenPosNorm).xy * _Noise_Tiling ));
			float MapNoise481 = tex2D( _Edge_Noise_Texture, panner484 ).r;
			float smoothstepResult401 = smoothstep( 0.0 , 0.6 , ( smoothstepResult385 - MapNoise481 ));
			float smoothstepResult445 = smoothstep( ( _StepShadow + -0.02 ) , ( temp_output_387_0 + -0.02 ) , normal_LightDir23);
			float blendOpSrc444 = smoothstepResult401;
			float blendOpDest444 = smoothstepResult445;
			float4 temp_cast_4 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest444) / max( blendOpSrc444, 0.00001) ) ) ))).xxxx;
			float4 blendOpSrc449 = temp_cast_4;
			float4 blendOpDest449 = _ShadowColor;
			float temp_output_419_0 = ( ( _StepShadow + _EdgeRange ) * -1.0 );
			float smoothstepResult402 = smoothstep( temp_output_419_0 , ( temp_output_419_0 + -0.1 ) , ( normal_LightDir23 * -1.0 ));
			float4 blendOpSrc428 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
			float4 blendOpDest428 = ( ( saturate( ( blendOpSrc449 * blendOpDest449 ) )) + ( 1.0 - step( ( smoothstepResult402 - MapNoise481 ) , 0.0 ) ) );
			float4 RGB514 = ( saturate( ( blendOpSrc428 * blendOpDest428 ) ));
			float3 EndClassic473 = ( ( (staticSwitch507).rgb * (staticSwitch507).a * pow( max( dotResult504 , 0.0 ) , ( _Shininess * 128.0 ) ) ) + (RGB514).rgb );
			float grayscale535 = Luminance(EndClassic473);
			#ifdef _ISPLAYERINBRUME_ON
				float4 staticSwitch533 = CalculateContrast(_InBrume_Contrast,( grayscale535 + _InBrume_Color ));
			#else
				float4 staticSwitch533 = float4( EndClassic473 , 0.0 );
			#endif
			c.rgb = staticSwitch533.rgb;
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
1920;0;1920;1019;6724.784;3537.769;7.070291;True;False
Node;AmplifyShaderEditor.CommentaryNode;521;-4067.253,-3950.146;Inherit;False;1709.898;459.17;Noise;8;478;480;479;487;477;484;476;481;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-4017.253,-3899.486;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;480;-3803.628,-3900.146;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-3821.623,-3820.566;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;13;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-5170.86,-3945.747;Inherit;False;916.9309;379.7947;Normal Light Dir;4;11;10;23;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;472;-4607.078,-1099.465;Inherit;False;1932.856;570.4816;Shadow Hard Edge;12;422;421;419;392;418;383;402;396;404;406;380;483;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;487;-3548.722,-3654.977;Inherit;False;Property;_Noise_Panner;Noise_Panner;18;0;Create;True;0;0;False;0;False;0,0;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-5147.859,-3741.954;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-3589.628,-3898.146;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;468;-5564.959,-3113.13;Inherit;False;2970.234;712.448;Paper + Object Texture;17;460;461;426;458;455;427;454;466;465;463;464;525;526;527;528;529;530;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-5117.748,-3890.436;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PannerNode;484;-3312.723,-3728.977;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-5493.323,-3033.153;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;422;-4557.078,-998.7985;Inherit;False;Property;_EdgeRange;EdgeRange;15;0;Create;True;0;0;False;0;False;-0.1;-0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-4687.156,-3892.493;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;471;-4435.237,-2315.223;Inherit;False;1847.087;1098.404;Shadow Smooth Edge + Int Shadow;15;388;387;448;385;397;447;446;445;401;450;444;449;470;469;482;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-4828.71,-1671.417;Inherit;False;Property;_StepShadow;StepShadow;14;0;Create;True;0;0;False;0;False;0.03;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-4385.237,-1995.324;Inherit;False;Property;_StepAttenuation;StepAttenuation;16;0;Create;True;0;0;False;0;False;-0.27;-0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-4450.926,-3896.748;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;421;-4354.796,-1049.465;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;476;-2961.366,-3767.363;Inherit;True;Property;_Edge_Noise_Texture;Edge_Noise_Texture;12;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;465;-5279.697,-3033.813;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;463;-5297.693,-2954.233;Inherit;False;Property;_PaperGrunge_Tiling;Paper/Grunge_Tiling;9;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-4191.236,-2015.324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;419;-4201.28,-943.3083;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-4300.971,-2265.223;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-5065.697,-3031.813;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-2581.354,-3745.438;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;-4170.532,-723.4073;Inherit;False;Constant;_StepShadow1;StepShadow;12;0;Create;False;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;380;-4004.603,-997.5882;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-4029.999,-2260.882;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;448;-4058.705,-1664.736;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;418;-3878.368,-792.1541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;454;-4808.876,-3060.474;Inherit;True;Property;_PaperGrunge_Texture;Paper/Grunge_Texture;8;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;383;-3756.583,-958.2734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;482;-3782.125,-2090.059;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;402;-3595.024,-959.2877;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.19;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;483;-3557.425,-620.8953;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;458;-4246.938,-2966.727;Inherit;False;Property;_PaperContrast;PaperContrast;10;0;Create;True;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0.5019608,0.5019608,0.5019608,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-3837.621,-1618.037;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-3875.723,-1826.461;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-3550.82,-2259.914;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-3838.621,-1715.037;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;455;-4456.938,-3060.726;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;529;-4361.529,-2631.971;Inherit;False;Property;_Ink_Tiling;Ink_Tiling;7;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;520;-4572.094,-326.4781;Inherit;False;1925.56;910.3955;Add Rougness and Normal;17;498;499;500;503;504;505;506;508;509;511;519;502;501;507;512;522;523;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-3631.688,-1740.147;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;526;-3805.47,-2828.94;Inherit;False;Property;_PaperMultiply;PaperMultiply;11;0;Create;True;0;0;False;0;False;1.58;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;396;-3300.482,-786.807;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;460;-3989.938,-3054.726;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;527;-4186.708,-2651.717;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-3333.962,-2259.066;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;450;-3015.019,-1428.82;Inherit;False;Property;_ShadowColor;ShadowColor;17;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.462264,0.462264,0.462264,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;444;-3288.108,-1743.769;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;427;-3486.471,-2572.684;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;404;-3077.934,-783.5673;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;519;-4522.093,353.9178;Inherit;True;Property;_Object_Normal_Texture;Object_Normal_Texture;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;525;-3614.47,-2973.94;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;528;-3944.596,-2695.058;Inherit;True;Property;_Ink_Texture;Ink_Texture;6;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;88d75bbfdb8a26849988713b4599646a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;449;-2867.149,-1741.828;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;530;-3204.603,-2887.002;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;426;-3252.542,-2628.279;Inherit;True;Property;_Object_Albedo_Texture;Object_Albedo_Texture;0;0;Create;True;0;0;False;0;False;-1;6395db2a80729484b931cff6723fa89f;6395db2a80729484b931cff6723fa89f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;498;-4146.916,359.6283;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;406;-2872.222,-782.9836;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;500;-4041.799,169.6575;Inherit;False;Blinn-Phong Half Vector;-1;;9;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;461;-2864.725,-2849.578;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalizeNode;499;-3938.919,359.6283;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;390;-2400.227,-1347.732;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;523;-4046.624,-85.30054;Inherit;False;Property;_Roughness_Multiplier;Roughness_Multiplier;19;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;502;-4113.235,-280.4782;Inherit;True;Property;_Object_Roughness_Texture;Object_Roughness_Texture;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;501;-3757.799,-72.34268;Float;False;Property;_Rougness_Color;Rougness_Color;4;0;Create;True;0;0;False;0;False;0.3921569,0.3921569,0.3921569,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;504;-3721.799,217.6581;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;522;-3689.624,-186.3005;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;503;-3561.799,233.6576;Float;False;Property;_Shininess;Shininess;5;0;Create;True;0;0;False;0;False;1;0.01;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;428;-1906.34,-1752.522;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;505;-3257.797,201.6576;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;128;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;506;-3545.799,137.6573;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;507;-3443.885,4.898212;Inherit;False;Property;_RougnessColor;RougnessColor;3;0;Create;True;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;514;-1606.952,-1750.94;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;508;-3161.798,41.65749;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;510;-2931.45,681.7271;Inherit;False;514;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;511;-3097.798,137.6573;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;509;-3161.798,-38.34244;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;512;-2882.533,-1.419601;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;513;-2723.542,680.6788;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;518;-2307.542,424.6772;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-2066.759,419.8681;Inherit;False;EndClassic;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;534;150.8231,-143.8709;Inherit;False;473;EndClassic;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TFHCGrayscale;535;381.8231,-146.8709;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;541;409.3373,167.9084;Inherit;False;Property;_InBrume_Color;InBrume_Color;22;0;Create;True;0;0;False;0;False;0,0,0,0;0.6132076,0.6132076,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;539;711.3909,334.2068;Inherit;False;Property;_InBrume_Contrast;InBrume_Contrast;21;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;540;665.3909,75.20685;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;1065.015,-95.02161;Inherit;False;473;EndClassic;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;536;945.3909,78.20685;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.5;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;532;-3092.604,-3005.402;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;533;1324.823,-37.95483;Inherit;False;Property;_isPlayerInBrume;isPlayerInBrume;20;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1573.984,-170.9062;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;InkShaderTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.06;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;480;0;478;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;484;0;477;0
WireConnection;484;2;487;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;23;0;12;0
WireConnection;421;0;386;0
WireConnection;421;1;422;0
WireConnection;476;1;484;0
WireConnection;465;0;464;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;419;0;421;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;481;0;476;1
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;418;0;419;0
WireConnection;418;1;392;0
WireConnection;454;1;466;0
WireConnection;383;0;380;0
WireConnection;402;0;383;0
WireConnection;402;1;419;0
WireConnection;402;2;418;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;455;0;454;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;396;0;402;0
WireConnection;396;1;483;0
WireConnection;460;0;455;0
WireConnection;460;1;458;0
WireConnection;527;0;529;0
WireConnection;401;0;397;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;404;0;396;0
WireConnection;525;0;460;0
WireConnection;525;1;526;0
WireConnection;528;1;527;0
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;530;0;525;0
WireConnection;530;1;528;0
WireConnection;426;1;427;0
WireConnection;498;0;519;0
WireConnection;406;0;404;0
WireConnection;461;0;530;0
WireConnection;461;1;426;0
WireConnection;499;0;498;0
WireConnection;390;0;449;0
WireConnection;390;1;406;0
WireConnection;504;0;500;0
WireConnection;504;1;499;0
WireConnection;522;0;502;4
WireConnection;522;1;523;0
WireConnection;428;0;461;0
WireConnection;428;1;390;0
WireConnection;505;0;503;0
WireConnection;506;0;504;0
WireConnection;507;1;522;0
WireConnection;507;0;501;0
WireConnection;514;0;428;0
WireConnection;508;0;507;0
WireConnection;511;0;506;0
WireConnection;511;1;505;0
WireConnection;509;0;507;0
WireConnection;512;0;509;0
WireConnection;512;1;508;0
WireConnection;512;2;511;0
WireConnection;513;0;510;0
WireConnection;518;0;512;0
WireConnection;518;1;513;0
WireConnection;473;0;518;0
WireConnection;535;0;534;0
WireConnection;540;0;535;0
WireConnection;540;1;541;0
WireConnection;536;1;540;0
WireConnection;536;0;539;0
WireConnection;533;1;474;0
WireConnection;533;0;536;0
WireConnection;0;13;533;0
ASEEND*/
//CHKSM=391F8BEA7F189C1AB47302CC061CB8C0F840EA0C
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CustomShadow"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_InOutBrumeTransition("InOutBrumeTransition", Range( 0 , 1)) = 0
		[Toggle(_OUTBRUMEGROUNDCOLOR_ON)] _OutBrumeGroundColor("OutBrumeGroundColor?", Float) = 0
		[Toggle(_INBRUMEGROUNDCOLOR_ON)] _InBrumeGroundColor("InBrumeGroundColor?", Float) = 0
		_Ground_Color("Ground_Color", Color) = (0,0,0,0)
		_OutBrumeGroundTexture_Albedo("OutBrumeGroundTexture_Albedo", 2D) = "white" {}
		_InBrumeGroundTexture_Albedo("InBrumeGroundTexture_Albedo", 2D) = "white" {}
		[Toggle(_CUSTOMWORLDSPACENORMAL_ON)] _CustomWorldSpaceNormal("CustomWorldSpaceNormal?", Float) = 0
		_Object_WorldSpaceNormal_Texture("Object_WorldSpaceNormal_Texture", 2D) = "white" {}
		_Noise_Texture("Noise_Texture", 2D) = "white" {}
		[Toggle(_SCREENBASEDNOISE_ON)] _ScreenBasedNoise("ScreenBasedNoise?", Float) = 0
		_Noise_Tiling("Noise_Tiling", Float) = 1
		_Noise_Panner("Noise_Panner", Vector) = (0.2,-0.1,0,0)
		_GroundMask_Texture("GroundMask_Texture", 2D) = "white" {}
		_MultiplyGroundMask("MultiplyGroundMask", Float) = 2.44
		_ShadowOutBrume_Color("ShadowOutBrume_Color", Color) = (0.7264151,0.7264151,0.7264151,0)
		_ShadowOutBrume_Details("ShadowOutBrume_Details", Float) = 0.95
		_ShadowOutBrume_SmoothstepMin("ShadowOutBrume_SmoothstepMin", Float) = 0.05
		_ShadowOutBrume_SmoothstepMax("ShadowOutBrume_SmoothstepMax", Float) = 0.36
		_ShadowInBrume_Color("ShadowInBrume_Color", Color) = (0.6981132,0.6981132,0.6981132,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _CUSTOMWORLDSPACENORMAL_ON
		#pragma shader_feature_local _SCREENBASEDNOISE_ON
		#pragma shader_feature_local _OUTBRUMEGROUNDCOLOR_ON
		#pragma shader_feature_local _INBRUMEGROUNDCOLOR_ON
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
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
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

		uniform sampler2D _GroundMask_Texture;
		uniform float4 _GroundMask_Texture_ST;
		uniform float _MultiplyGroundMask;
		uniform sampler2D _Noise_Texture;
		uniform float4 _Noise_Texture_ST;
		uniform float4 _ShadowOutBrume_Color;
		uniform sampler2D _Object_WorldSpaceNormal_Texture;
		uniform float4 _Object_WorldSpaceNormal_Texture_ST;
		uniform float2 _Noise_Panner;
		uniform float _Noise_Tiling;
		uniform float _ShadowOutBrume_Details;
		uniform float _ShadowOutBrume_SmoothstepMin;
		uniform float _ShadowOutBrume_SmoothstepMax;
		uniform sampler2D _OutBrumeGroundTexture_Albedo;
		uniform float4 _OutBrumeGroundTexture_Albedo_ST;
		uniform float4 _Ground_Color;
		uniform sampler2D _InBrumeGroundTexture_Albedo;
		uniform float4 _InBrumeGroundTexture_Albedo_ST;
		uniform float4 _ShadowInBrume_Color;
		uniform float _InOutBrumeTransition;
		uniform float _Cutoff = 0.5;

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
			float2 uv_GroundMask_Texture = i.uv_texcoord * _GroundMask_Texture_ST.xy + _GroundMask_Texture_ST.zw;
			float4 temp_output_75_0 = ( tex2D( _GroundMask_Texture, uv_GroundMask_Texture ) * _MultiplyGroundMask );
			float2 uv_Noise_Texture = i.uv_texcoord * _Noise_Texture_ST.xy + _Noise_Texture_ST.zw;
			float4 blendOpSrc68 = temp_output_75_0;
			float4 blendOpDest68 = ( temp_output_75_0 - tex2D( _Noise_Texture, uv_Noise_Texture ) );
			float4 Ground103 = ( saturate( ( blendOpDest68/ max( 1.0 - blendOpSrc68, 0.00001 ) ) ));
			float2 uv_Object_WorldSpaceNormal_Texture = i.uv_texcoord * _Object_WorldSpaceNormal_Texture_ST.xy + _Object_WorldSpaceNormal_Texture_ST.zw;
			#ifdef _CUSTOMWORLDSPACENORMAL_ON
				float4 staticSwitch5 = tex2D( _Object_WorldSpaceNormal_Texture, uv_Object_WorldSpaceNormal_Texture );
			#else
				float4 staticSwitch5 = float4( float3(0,0,1) , 0.0 );
			#endif
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult8 = dot( (WorldNormalVector( i , staticSwitch5.rgb )) , ase_worldlightDir );
			float Light91 = ( dotResult8 * ase_lightAtten );
			float2 temp_cast_3 = (_Noise_Tiling).xx;
			float2 uv_TexCoord24 = i.uv_texcoord * temp_cast_3;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			#ifdef _SCREENBASEDNOISE_ON
				float2 staticSwitch27 = ( (ase_screenPosNorm).xy * _Noise_Tiling );
			#else
				float2 staticSwitch27 = uv_TexCoord24;
			#endif
			float2 panner28 = ( 1.0 * _Time.y * ( _Noise_Panner + float2( 0.1,0.05 ) ) + staticSwitch27);
			float2 panner30 = ( 1.0 * _Time.y * _Noise_Panner + staticSwitch27);
			float blendOpSrc33 = tex2D( _Noise_Texture, ( panner28 + float2( 0.5,0.5 ) ) ).r;
			float blendOpDest33 = tex2D( _Noise_Texture, panner30 ).r;
			float MapNoise34 = ( saturate( 2.0f*blendOpDest33*blendOpSrc33 + blendOpDest33*blendOpDest33*(1.0f - 2.0f*blendOpSrc33) ));
			float temp_output_18_0 = ( ( 1.0 - Light91 ) - MapNoise34 );
			float smoothstepResult37 = smoothstep( -0.18 , 0.36 , temp_output_18_0);
			float temp_output_45_0 = ( 1.0 - Light91 );
			float smoothstepResult36 = smoothstep( ( _ShadowOutBrume_Details - 0.3 ) , _ShadowOutBrume_Details , temp_output_45_0);
			float blendOpSrc38 = smoothstepResult37;
			float blendOpDest38 = smoothstepResult36;
			float smoothstepResult61 = smoothstep( _ShadowOutBrume_SmoothstepMin , _ShadowOutBrume_SmoothstepMax , temp_output_18_0);
			float smoothstepResult63 = smoothstep( 0.4 , 0.73 , temp_output_45_0);
			float blendOpSrc64 = smoothstepResult61;
			float blendOpDest64 = smoothstepResult63;
			float2 uv_OutBrumeGroundTexture_Albedo = i.uv_texcoord * _OutBrumeGroundTexture_Albedo_ST.xy + _OutBrumeGroundTexture_Albedo_ST.zw;
			float4 GroundColor101 = _Ground_Color;
			#ifdef _OUTBRUMEGROUNDCOLOR_ON
				float4 staticSwitch113 = GroundColor101;
			#else
				float4 staticSwitch113 = tex2D( _OutBrumeGroundTexture_Albedo, uv_OutBrumeGroundTexture_Albedo );
			#endif
			float4 ShadowOutBrume11 = ( ( ( ( _ShadowOutBrume_Color * ( saturate( ( blendOpSrc38 + blendOpDest38 - 1.0 ) )) ) + step( ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest64) / max( blendOpSrc64, 0.00001) ) ) )) , 0.0 ) ) * staticSwitch113 ) * Ground103 );
			float2 uv_InBrumeGroundTexture_Albedo = i.uv_texcoord * _InBrumeGroundTexture_Albedo_ST.xy + _InBrumeGroundTexture_Albedo_ST.zw;
			#ifdef _INBRUMEGROUNDCOLOR_ON
				float4 staticSwitch80 = _Ground_Color;
			#else
				float4 staticSwitch80 = tex2D( _InBrumeGroundTexture_Albedo, uv_InBrumeGroundTexture_Albedo );
			#endif
			float temp_output_127_0 = step( Light91 , 0.0 );
			float4 ShadowInBrume106 = ( ( staticSwitch80 * ( ( 1.0 - temp_output_127_0 ) + ( temp_output_127_0 * _ShadowInBrume_Color ) ) ) * Ground103 );
			float4 lerpResult87 = lerp( ShadowOutBrume11 , ShadowInBrume106 , _InOutBrumeTransition);
			c.rgb = lerpResult87.rgb;
			c.a = 1;
			clip( Ground103.r - _Cutoff );
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
0;0;1920;1019;2637.974;-606.0019;1.672153;True;False
Node;AmplifyShaderEditor.CommentaryNode;19;-1763.336,-1740.664;Inherit;False;2866.093;613.3671;Noise;15;34;33;32;31;30;29;28;27;26;25;24;23;22;21;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;20;-1651.817,-1409.411;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;2;-1766.5,-1099.464;Inherit;False;1841.144;504.1284;Light;9;91;10;8;9;6;7;5;3;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SwizzleNode;22;-1438.19,-1410.071;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-1456.185,-1330.49;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;11;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1669.572,-814.3475;Inherit;True;Property;_Object_WorldSpaceNormal_Texture;Object_WorldSpaceNormal_Texture;8;0;Create;True;0;0;False;0;False;-1;2418409f260e65a4baa4d7d8b8b8a53e;2418409f260e65a4baa4d7d8b8b8a53e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;3;-1653.693,-993.0882;Inherit;False;Constant;_Vector0;Vector 0;25;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1224.19,-1408.071;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1229.257,-1613.574;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;23;-780.3313,-1282.89;Inherit;False;Property;_Noise_Panner;Noise_Panner;12;0;Create;True;0;0;False;0;False;0.2,-0.1;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;5;-1347.967,-992.6922;Inherit;False;Property;_CustomWorldSpaceNormal;CustomWorldSpaceNormal?;7;0;Create;True;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-551.6895,-1584.832;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;27;-846.8421,-1436.199;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;10;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;28;-383.6898,-1613.832;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;6;-1034.342,-871.7924;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;7;-1016.146,-1023.521;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-113.0818,-1614.701;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DotProductOpNode;8;-758.2451,-1022.33;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;30;-544.3326,-1356.89;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LightAttenuation;9;-741.0209,-744.7808;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;32;83.74743,-1389.777;Inherit;True;Property;_Noise_Texture;Noise_Texture;9;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;31;87.29821,-1637.599;Inherit;True;Property;_TextureSample0;Texture Sample 0;9;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;32;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-462.175,-1023.018;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;33;556.0343,-1397.333;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;98;-1758.051,-563.3099;Inherit;False;3651.606;1229.861;SHADOW OUT BRUME;26;11;89;46;62;102;47;90;64;48;38;36;63;37;61;18;50;45;77;78;44;35;51;97;109;110;113;;1,0.7843137,0.5529412,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;-169.5524,-1049.428;Inherit;False;Light;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;880.7607,-1374.852;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;97;-1708.051,-381.5838;Inherit;False;91;Light;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-1237.042,-266.0786;Inherit;False;Property;_ShadowOutBrume_Details;ShadowOutBrume_Details;16;0;Create;True;0;0;False;0;False;0.95;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;-1468.687,-150.3806;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-1246.822,174.2678;Inherit;False;34;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;108;113.2698,-1104.083;Inherit;False;1575.085;513.3398;Ground;7;66;65;103;68;75;67;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;-881.0428,-393.0787;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;76;232.3967,-856.0596;Inherit;False;Property;_MultiplyGroundMask;MultiplyGroundMask;14;0;Create;True;0;0;False;0;False;2.44;4.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-997.2153,428.0933;Inherit;False;Property;_ShadowOutBrume_SmoothstepMin;ShadowOutBrume_SmoothstepMin;17;0;Create;True;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;-1465.117,-375.8609;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-998.7139,508.4932;Inherit;False;Property;_ShadowOutBrume_SmoothstepMax;ShadowOutBrume_SmoothstepMax;18;0;Create;True;0;0;False;0;False;0.36;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;111;-1754.82,687.7883;Inherit;False;2336.176;1190.856;SHADOW IN BRUME;14;79;92;101;95;52;93;96;80;53;105;106;104;127;128;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;67;156.7698,-1054.082;Inherit;True;Property;_GroundMask_Texture;GroundMask_Texture;13;0;Create;True;0;0;False;0;False;-1;49bd8c401abf6944f8c5bcb3430bc9c3;49bd8c401abf6944f8c5bcb3430bc9c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-957.9997,161.9915;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;512.2593,-1048.251;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;61;-637.6381,402.3101;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;63;-634.536,-78.55732;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.73;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;-1704.82,1255.48;Inherit;False;91;Light;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-633.6927,-304.7657;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-1011.541,1009.762;Inherit;False;Property;_Ground_Color;Ground_Color;4;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;37;-638.0009,177.9917;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.18;False;2;FLOAT;0.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;451.5867,-797.2524;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;32;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;95;-1532.563,1666.645;Inherit;False;Property;_ShadowInBrume_Color;ShadowInBrume_Color;19;0;Create;True;0;0;False;0;False;0.6981132,0.6981132,0.6981132,0;0.6981132,0.6981132,0.6981132,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;127;-1525.139,1259.685;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-174.9701,-513.3099;Inherit;False;Property;_ShadowOutBrume_Color;ShadowOutBrume_Color;15;0;Create;True;0;0;False;0;False;0.7264151,0.7264151,0.7264151,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;38;-217.6949,-302.7657;Inherit;True;LinearBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;64;-225.2823,-30.52632;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-706.3135,1106.931;Inherit;False;GroundColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;799.5111,-816.1443;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;169.0303,-380.3099;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;68;1096.821,-1051.754;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;62;80.24889,-25.03024;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-1089.885,737.7883;Inherit;True;Property;_InBrumeGroundTexture_Albedo;InBrumeGroundTexture_Albedo;6;0;Create;True;0;0;False;0;False;-1;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;90;350.8795,3.469536;Inherit;True;Property;_OutBrumeGroundTexture_Albedo;OutBrumeGroundTexture_Albedo;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;128;-1236.531,1259.066;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1263.559,1537.645;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;460.7962,206.3333;Inherit;False;101;GroundColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;113;712.2494,65.10178;Inherit;False;Property;_OutBrumeGroundColor;OutBrumeGroundColor?;2;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;80;-727.9852,921.9072;Inherit;False;Property;_InBrumeGroundColor;InBrumeGroundColor?;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;103;1460.454,-1053.43;Inherit;False;Ground;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;452.5784,-295.0882;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-1015.559,1260.645;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;979.4958,-292.0206;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-386.9345,1234.851;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;1205.462,-138.6124;Inherit;False;103;Ground;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-167.4633,1437.75;Inherit;False;103;Ground;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;1415.322,-291.2653;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;108.4807,1234.912;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;106;349.3602,1228.927;Inherit;False;ShadowInBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;1662.607,-295.06;Inherit;False;ShadowOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;2129.395,61.009;Inherit;False;Property;_InOutBrumeTransition;InOutBrumeTransition;1;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;2145.596,-145.592;Inherit;False;11;ShadowOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;112;2145.726,-71.88562;Inherit;False;106;ShadowInBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;87;2516.083,-136.9099;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;107;2585.064,92.12488;Inherit;False;103;Ground;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2928.793,-178.5416;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;CustomShadow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;20;0
WireConnection;25;0;22;0
WireConnection;25;1;21;0
WireConnection;24;0;21;0
WireConnection;5;1;3;0
WireConnection;5;0;4;0
WireConnection;26;0;23;0
WireConnection;27;1;24;0
WireConnection;27;0;25;0
WireConnection;28;0;27;0
WireConnection;28;2;26;0
WireConnection;7;0;5;0
WireConnection;29;0;28;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;30;0;27;0
WireConnection;30;2;23;0
WireConnection;32;1;30;0
WireConnection;31;1;29;0
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;33;0;31;1
WireConnection;33;1;32;1
WireConnection;91;0;10;0
WireConnection;34;0;33;0
WireConnection;44;0;97;0
WireConnection;50;0;51;0
WireConnection;45;0;97;0
WireConnection;18;0;44;0
WireConnection;18;1;35;0
WireConnection;75;0;67;0
WireConnection;75;1;76;0
WireConnection;61;0;18;0
WireConnection;61;1;77;0
WireConnection;61;2;78;0
WireConnection;63;0;45;0
WireConnection;36;0;45;0
WireConnection;36;1;50;0
WireConnection;36;2;51;0
WireConnection;37;0;18;0
WireConnection;127;0;92;0
WireConnection;38;0;37;0
WireConnection;38;1;36;0
WireConnection;64;0;61;0
WireConnection;64;1;63;0
WireConnection;101;0;79;0
WireConnection;66;0;75;0
WireConnection;66;1;65;0
WireConnection;47;0;48;0
WireConnection;47;1;38;0
WireConnection;68;0;75;0
WireConnection;68;1;66;0
WireConnection;62;0;64;0
WireConnection;128;0;127;0
WireConnection;93;0;127;0
WireConnection;93;1;95;0
WireConnection;113;1;90;0
WireConnection;113;0;102;0
WireConnection;80;1;52;0
WireConnection;80;0;79;0
WireConnection;103;0;68;0
WireConnection;46;0;47;0
WireConnection;46;1;62;0
WireConnection;96;0;128;0
WireConnection;96;1;93;0
WireConnection;89;0;46;0
WireConnection;89;1;113;0
WireConnection;53;0;80;0
WireConnection;53;1;96;0
WireConnection;109;0;89;0
WireConnection;109;1;110;0
WireConnection;105;0;53;0
WireConnection;105;1;104;0
WireConnection;106;0;105;0
WireConnection;11;0;109;0
WireConnection;87;0;86;0
WireConnection;87;1;112;0
WireConnection;87;2;88;0
WireConnection;0;10;107;0
WireConnection;0;13;87;0
ASEEND*/
//CHKSM=5F7513053FD6BD7ACCB7820BB0CA3D81AE9E88F4
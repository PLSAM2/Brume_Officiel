// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "CustomShadow"
{
	Properties
	{
		_InOutBrumeTransition("InOutBrumeTransition", Range( 0 , 1)) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_GroundTexture_Albedo("GroundTexture_Albedo", 2D) = "white" {}
		[Toggle(_CUSTOMWORLDSPACENORMAL_ON)] _CustomWorldSpaceNormal("CustomWorldSpaceNormal?", Float) = 1
		_Object_WorldSpaceNormal_Texture("Object_WorldSpaceNormal_Texture", 2D) = "white" {}
		_Edge_Noise_Texture("Edge_Noise_Texture", 2D) = "white" {}
		_Noise_Tiling("Noise_Tiling", Float) = 1
		_Noise_Tiling1("Noise_Tiling", Float) = 1
		_Noise_Panner("Noise_Panner", Vector) = (0.2,-0.1,0,0)
		[Toggle(_SCREENBASEDNOISE_ON)] _ScreenBasedNoise("ScreenBasedNoise?", Float) = 0
		_ShadowColor("ShadowColor", Color) = (0.7264151,0.7264151,0.7264151,0)
		_Detail_Shadow("Detail_Shadow", Float) = 0.95
		_GroundMask_Texture("GroundMask_Texture", 2D) = "white" {}
		_MultiplyGroundMask("MultiplyGroundMask", Float) = 2.44
		_Float0("Float 0", Float) = 0.05
		[Toggle(_GROUNDCOLOR_ON)] _GroundColor("GroundColor?", Float) = 0
		_Ground_Color("Ground_Color", Color) = (0,0,0,0)
		_Float1("Float 1", Float) = 0.36
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
		#pragma shader_feature_local _GROUNDCOLOR_ON
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
		uniform sampler2D _Edge_Noise_Texture;
		uniform float4 _Edge_Noise_Texture_ST;
		uniform float4 _ShadowColor;
		uniform sampler2D _Object_WorldSpaceNormal_Texture;
		uniform float4 _Object_WorldSpaceNormal_Texture_ST;
		uniform float2 _Noise_Panner;
		uniform float _Noise_Tiling1;
		uniform float _Noise_Tiling;
		uniform float _Detail_Shadow;
		uniform float _Float0;
		uniform float _Float1;
		uniform sampler2D _GroundTexture_Albedo;
		uniform float4 _GroundTexture_Albedo_ST;
		uniform float4 _Ground_Color;
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
			float2 uv_Edge_Noise_Texture = i.uv_texcoord * _Edge_Noise_Texture_ST.xy + _Edge_Noise_Texture_ST.zw;
			float4 blendOpSrc68 = temp_output_75_0;
			float4 blendOpDest68 = ( temp_output_75_0 - tex2D( _Edge_Noise_Texture, uv_Edge_Noise_Texture ) );
			float4 temp_output_68_0 = ( saturate( ( blendOpDest68/ max( 1.0 - blendOpSrc68, 0.00001 ) ) ));
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
			float temp_output_10_0 = ( dotResult8 * ase_lightAtten );
			float2 temp_cast_3 = (_Noise_Tiling1).xx;
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
			float blendOpSrc33 = tex2D( _Edge_Noise_Texture, ( panner28 + float2( 0.5,0.5 ) ) ).r;
			float blendOpDest33 = tex2D( _Edge_Noise_Texture, panner30 ).r;
			float MapNoise34 = ( saturate( 2.0f*blendOpDest33*blendOpSrc33 + blendOpDest33*blendOpDest33*(1.0f - 2.0f*blendOpSrc33) ));
			float temp_output_18_0 = ( ( 1.0 - temp_output_10_0 ) - MapNoise34 );
			float smoothstepResult37 = smoothstep( -0.18 , 0.36 , temp_output_18_0);
			float temp_output_45_0 = ( 1.0 - temp_output_10_0 );
			float smoothstepResult36 = smoothstep( ( _Detail_Shadow - 0.3 ) , _Detail_Shadow , temp_output_45_0);
			float blendOpSrc38 = smoothstepResult37;
			float blendOpDest38 = smoothstepResult36;
			float smoothstepResult61 = smoothstep( _Float0 , _Float1 , temp_output_18_0);
			float smoothstepResult63 = smoothstep( 0.4 , 0.73 , temp_output_45_0);
			float blendOpSrc64 = smoothstepResult61;
			float blendOpDest64 = smoothstepResult63;
			float4 normal_LightDir11 = ( ( _ShadowColor * ( saturate( ( blendOpSrc38 + blendOpDest38 - 1.0 ) )) ) + step( ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest64) / max( blendOpSrc64, 0.00001) ) ) )) , 0.0 ) );
			float2 uv_GroundTexture_Albedo = i.uv_texcoord * _GroundTexture_Albedo_ST.xy + _GroundTexture_Albedo_ST.zw;
			#ifdef _GROUNDCOLOR_ON
				float4 staticSwitch80 = _Ground_Color;
			#else
				float4 staticSwitch80 = tex2D( _GroundTexture_Albedo, uv_GroundTexture_Albedo );
			#endif
			float4 lerpResult87 = lerp( normal_LightDir11 , ( ( staticSwitch80 * ( 1.0 - step( temp_output_10_0 , 0.0 ) ) ) * temp_output_68_0 ) , _InOutBrumeTransition);
			c.rgb = lerpResult87.rgb;
			c.a = 1;
			clip( temp_output_68_0.r - _Cutoff );
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
Version=18301
0;0;1920;1019;-1436.164;549.2854;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;19;-3219.077,-786.0816;Inherit;False;2866.093;613.3671;Noise;16;34;33;32;31;30;29;28;27;26;25;24;23;22;21;20;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;20;-3107.558,-454.8278;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;22;-2893.933,-455.4877;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2911.927,-375.9074;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-2886.342,-628.6433;Inherit;False;Property;_Noise_Tiling1;Noise_Tiling;7;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-2679.933,-453.4877;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;23;-2236.075,-328.3075;Inherit;False;Property;_Noise_Panner;Noise_Panner;8;0;Create;True;0;0;False;0;False;0.2,-0.1;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-2685,-658.9915;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;27;-2302.586,-481.6167;Inherit;False;Property;_ScreenBasedNoise;ScreenBasedNoise?;9;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2007.433,-630.2495;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;2;-4849.329,-62.98466;Inherit;False;4523.626;1234.503;Normal Light Dir;27;36;62;11;46;47;61;38;48;37;45;50;18;35;51;44;10;9;8;6;7;5;4;3;63;64;77;78;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;4;-4752.401,216.2151;Inherit;True;Property;_Object_WorldSpaceNormal_Texture;Object_WorldSpaceNormal_Texture;4;0;Create;True;0;0;False;0;False;-1;2418409f260e65a4baa4d7d8b8b8a53e;2418409f260e65a4baa4d7d8b8b8a53e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;28;-1839.433,-659.2495;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector3Node;3;-4736.522,37.47399;Inherit;False;Constant;_Vector0;Vector 0;25;0;Create;True;0;0;False;0;False;0,0,1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StaticSwitch;5;-4430.795,37.87;Inherit;False;Property;_CustomWorldSpaceNormal;CustomWorldSpaceNormal?;3;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1568.825,-660.1187;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;30;-2000.076,-402.3077;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;31;-1368.445,-683.0166;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;32;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;32;-1371.996,-436.1947;Inherit;True;Property;_Edge_Noise_Texture;Edge_Noise_Texture;5;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;6;-4117.17,158.77;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;7;-4098.974,7.040881;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightAttenuation;9;-3823.849,285.7818;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;8;-3841.073,8.231883;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;33;-899.7083,-442.7506;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-3545.004,7.543902;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-574.9824,-420.2696;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;35;-2524.935,672.0788;Inherit;False;34;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;-2746.8,347.4307;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-2515.155,231.7323;Inherit;False;Property;_Detail_Shadow;Detail_Shadow;11;0;Create;True;0;0;False;0;False;0.95;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;77;-2131.027,931.1021;Inherit;False;Property;_Float0;Float 0;14;0;Create;True;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;-2236.112,659.8026;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;50;-2304.155,176.7323;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2130.027,1008.102;Inherit;False;Property;_Float1;Float 1;17;0;Create;True;0;0;False;0;False;0.36;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;45;-2743.231,121.9499;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;61;-1915.748,900.1196;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;0.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;63;-1912.646,419.254;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.4;False;2;FLOAT;0.73;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;36;-1911.803,193.0454;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;37;-1916.111,675.8027;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.18;False;2;FLOAT;0.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;64;-1503.39,467.2849;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;48;-1453.078,-15.49899;Inherit;False;Property;_ShadowColor;ShadowColor;10;0;Create;True;0;0;False;0;False;0.7264151,0.7264151,0.7264151,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;38;-1495.803,195.0454;Inherit;True;LinearBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;67;840.5503,258.8505;Inherit;True;Property;_GroundMask_Texture;GroundMask_Texture;12;0;Create;True;0;0;False;0;False;-1;49bd8c401abf6944f8c5bcb3430bc9c3;49bd8c401abf6944f8c5bcb3430bc9c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;916.1773,456.8754;Inherit;False;Property;_MultiplyGroundMask;MultiplyGroundMask;13;0;Create;True;0;0;False;0;False;2.44;4.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;62;-1197.859,472.781;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;79;-112.9975,-326.1461;Inherit;False;Property;_Ground_Color;Ground_Color;16;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;65;1126.267,659.9824;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Instance;32;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1109.078,117.501;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;81;511.6447,-635.6899;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;1211.041,437.6838;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;52;-190.3416,-145.1205;Inherit;True;Property;_GroundTexture_Albedo;GroundTexture_Albedo;2;0;Create;True;0;0;False;0;False;-1;88d75bbfdb8a26849988713b4599646a;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-825.5303,202.7229;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;66;1474.193,641.0905;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;82;745.0054,-631.7409;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;80;136.559,-245.0009;Inherit;False;Property;_GroundColor;GroundColor?;15;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;470.9011,56.76163;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-622.3459,78.79261;Inherit;False;normal_LightDir;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;68;1784.503,462.6814;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;2180.004,63.90988;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;2245.395,-292.991;Inherit;False;Property;_InOutBrumeTransition;InOutBrumeTransition;0;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;2145.596,-140.592;Inherit;False;11;normal_LightDir;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;87;2516.083,-136.9099;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2928.793,-178.5416;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;CustomShadow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;20;0
WireConnection;25;0;22;0
WireConnection;25;1;21;0
WireConnection;24;0;54;0
WireConnection;27;1;24;0
WireConnection;27;0;25;0
WireConnection;26;0;23;0
WireConnection;28;0;27;0
WireConnection;28;2;26;0
WireConnection;5;1;3;0
WireConnection;5;0;4;0
WireConnection;29;0;28;0
WireConnection;30;0;27;0
WireConnection;30;2;23;0
WireConnection;31;1;29;0
WireConnection;32;1;30;0
WireConnection;7;0;5;0
WireConnection;8;0;7;0
WireConnection;8;1;6;0
WireConnection;33;0;31;1
WireConnection;33;1;32;1
WireConnection;10;0;8;0
WireConnection;10;1;9;0
WireConnection;34;0;33;0
WireConnection;44;0;10;0
WireConnection;18;0;44;0
WireConnection;18;1;35;0
WireConnection;50;0;51;0
WireConnection;45;0;10;0
WireConnection;61;0;18;0
WireConnection;61;1;77;0
WireConnection;61;2;78;0
WireConnection;63;0;45;0
WireConnection;36;0;45;0
WireConnection;36;1;50;0
WireConnection;36;2;51;0
WireConnection;37;0;18;0
WireConnection;64;0;61;0
WireConnection;64;1;63;0
WireConnection;38;0;37;0
WireConnection;38;1;36;0
WireConnection;62;0;64;0
WireConnection;47;0;48;0
WireConnection;47;1;38;0
WireConnection;81;0;10;0
WireConnection;75;0;67;0
WireConnection;75;1;76;0
WireConnection;46;0;47;0
WireConnection;46;1;62;0
WireConnection;66;0;75;0
WireConnection;66;1;65;0
WireConnection;82;0;81;0
WireConnection;80;1;52;0
WireConnection;80;0;79;0
WireConnection;53;0;80;0
WireConnection;53;1;82;0
WireConnection;11;0;46;0
WireConnection;68;0;75;0
WireConnection;68;1;66;0
WireConnection;74;0;53;0
WireConnection;74;1;68;0
WireConnection;87;0;86;0
WireConnection;87;1;74;0
WireConnection;87;2;88;0
WireConnection;0;10;68;0
WireConnection;0;13;87;0
ASEEND*/
//CHKSM=ABFF761F17D144C44F0C27B0C61C6829F5C7DFAB
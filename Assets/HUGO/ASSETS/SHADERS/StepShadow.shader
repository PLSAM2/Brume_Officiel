// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "StepShadow"
{
	Properties
	{
		_Step_Shadow("Step_Shadow", Float) = 0
		_Rougness_Color("Rougness_Color", Color) = (0.3921569,0.3921569,0.3921569,1)
		_Shininess("Shininess", Range( 0.01 , 1)) = 1
		_ShadowColor("ShadowColor", Color) = (0.3018868,0.3018868,0.3018868,0)
		_Object_Albedo("Object_Albedo", 2D) = "white" {}
		_Object_Normal("Object_Normal", 2D) = "white" {}
		_Object_Roughness("Object_Roughness", 2D) = "white" {}
		[Toggle(_SPECULARCOLOR_ON)] _SpecularColor("SpecularColor", Float) = 0
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
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _SPECULARCOLOR_ON
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

		uniform sampler2D _Object_Roughness;
		uniform float4 _Object_Roughness_ST;
		uniform float4 _Rougness_Color;
		uniform sampler2D _Object_Normal;
		uniform float4 _Object_Normal_ST;
		uniform float _Shininess;
		uniform sampler2D _Object_Albedo;
		uniform float4 _Object_Albedo_ST;
		uniform float _Step_Shadow;
		uniform float4 _ShadowColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_Object_Roughness = i.uv_texcoord * _Object_Roughness_ST.xy + _Object_Roughness_ST.zw;
			float4 temp_cast_0 = (tex2D( _Object_Roughness, uv_Object_Roughness ).a).xxxx;
			#ifdef _SPECULARCOLOR_ON
				float4 staticSwitch61 = _Rougness_Color;
			#else
				float4 staticSwitch61 = temp_cast_0;
			#endif
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float3 normalizeResult4_g9 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float2 uv_Object_Normal = i.uv_texcoord * _Object_Normal_ST.xy + _Object_Normal_ST.zw;
			float4 ObjectNormal62 = tex2D( _Object_Normal, uv_Object_Normal );
			float3 normalizeResult34 = normalize( (WorldNormalVector( i , ObjectNormal62.rgb )) );
			float dotResult39 = dot( normalizeResult4_g9 , normalizeResult34 );
			float2 uv_Object_Albedo = i.uv_texcoord * _Object_Albedo_ST.xy + _Object_Albedo_ST.zw;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float dotResult3 = dot( ase_worldNormal , ase_worldlightDir );
			float4 temp_cast_2 = (( 1.0 - step( dotResult3 , _Step_Shadow ) )).xxxx;
			float4 blendOpSrc8 = temp_cast_2;
			float4 blendOpDest8 = _ShadowColor;
			float4 blendOpSrc14 = tex2D( _Object_Albedo, uv_Object_Albedo );
			float4 blendOpDest14 = ( saturate( 	max( blendOpSrc8, blendOpDest8 ) ));
			float4 DiffuseAndLight54 = ( saturate( ( blendOpSrc14 * blendOpDest14 ) ));
			float3 temp_output_48_0 = (DiffuseAndLight54).rgb;
			float3 RGB59 = ( ( (staticSwitch61).rgb * (staticSwitch61).a * pow( max( dotResult39 , 0.0 ) , ( _Shininess * 128.0 ) ) ) + temp_output_48_0 );
			c.rgb = RGB59;
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
0;0;1920;1019;9832.835;3846.752;6.832318;True;False
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;1;-3152.329,395.3602;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;2;-3125.956,224.2525;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;15;-1485.278,491.2802;Inherit;True;Property;_Object_Normal;Object_Normal;5;0;Create;True;0;0;False;0;False;-1;896a9d1489510974b89826bd8b457565;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-1154.115,504.8917;Inherit;False;ObjectNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-2881.844,242.0034;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2806.431,483.5727;Inherit;False;Property;_Step_Shadow;Step_Shadow;0;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-3681.025,-1095.911;Inherit;False;62;ObjectNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;5;-2608.055,243.9841;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;30;-3168.402,-1091.661;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;11;-2366.431,661.5728;Inherit;False;Property;_ShadowColor;ShadowColor;3;0;Create;True;0;0;False;0;False;0.3018868,0.3018868,0.3018868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-2389.555,244.9219;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;8;-2061.091,475.0737;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;12;-1957.124,58.80933;Inherit;True;Property;_Object_Albedo;Object_Albedo;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;26;-3063.285,-1281.631;Inherit;False;Blinn-Phong Half Vector;-1;;9;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;34;-2960.405,-1091.661;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;14;-1454.436,245.0066;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;39;-2743.285,-1233.631;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;51;-2779.285,-1523.631;Float;False;Property;_Rougness_Color;Rougness_Color;1;0;Create;True;0;0;False;0;False;0.3921569,0.3921569,0.3921569,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-2583.285,-1217.631;Float;False;Property;_Shininess;Shininess;2;0;Create;True;0;0;False;0;False;1;0;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-2823.721,-1727.766;Inherit;True;Property;_Object_Roughness;Object_Roughness;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-1168.271,284.1482;Inherit;False;DiffuseAndLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-2279.285,-1249.631;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;128;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;38;-2567.285,-1313.631;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;61;-2465.372,-1446.39;Inherit;False;Property;_SpecularColor;SpecularColor;7;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;40;-2183.285,-1409.631;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;-2119.285,-1313.631;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;-2183.285,-1489.631;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-1761.037,-803.4861;Inherit;False;54;DiffuseAndLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1474.431,-1306.02;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;48;-1462.13,-900.5352;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-1046.13,-1156.535;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-813.8984,-1084.065;Inherit;False;RGB;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;58;-810.8469,-993.5583;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;-1055.533,-1312.444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;64;-256.0098,235.2385;Inherit;False;59;RGB;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;32;-1462.13,-804.5352;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;StepShadow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;62;0;15;0
WireConnection;3;0;2;0
WireConnection;3;1;1;0
WireConnection;5;0;3;0
WireConnection;5;1;10;0
WireConnection;30;0;63;0
WireConnection;6;0;5;0
WireConnection;8;0;6;0
WireConnection;8;1;11;0
WireConnection;34;0;30;0
WireConnection;14;0;12;0
WireConnection;14;1;8;0
WireConnection;39;0;26;0
WireConnection;39;1;34;0
WireConnection;54;0;14;0
WireConnection;35;0;28;0
WireConnection;38;0;39;0
WireConnection;61;1;16;4
WireConnection;61;0;51;0
WireConnection;40;0;61;0
WireConnection;47;0;38;0
WireConnection;47;1;35;0
WireConnection;25;0;61;0
WireConnection;29;0;25;0
WireConnection;29;1;40;0
WireConnection;29;2;47;0
WireConnection;48;0;57;0
WireConnection;31;0;29;0
WireConnection;31;1;48;0
WireConnection;59;0;31;0
WireConnection;58;0;32;0
WireConnection;65;0;39;0
WireConnection;65;1;48;0
WireConnection;32;0;57;0
WireConnection;0;13;64;0
ASEEND*/
//CHKSM=E41ED0509D1B54EB31AB90268B640FA98A2F2094
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Distortion"
{
	Properties
	{
		_DistortNoiseTexture("DistortNoiseTexture", 2D) = "white" {}
		_NormalStrength("NormalStrength", Float) = 1
		_DistortColor("DistortColor", Color) = (1,1,1,0)
		_TimeScale("TimeScale", Float) = 0.2
		_DepthFadeDistance("DepthFadeDistance", Float) = 1
		[Toggle(_FRESNEL_ON)] _Fresnel("Fresnel ?", Float) = 0
		_FresnelScale("FresnelScale", Float) = 1
		_FresnelPower("FresnelPower", Float) = 5
		_FresnelColor("FresnelColor", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature_local _FRESNEL_ON
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
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

		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeDistance;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform sampler2D _DistortNoiseTexture;
		uniform float _TimeScale;
		uniform float _NormalStrength;
		uniform float4 _DistortColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _FresnelColor;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth7 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth7 = abs( ( screenDepth7 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) );
			float mulTime12 = _Time.y * _TimeScale;
			float cos11 = cos( mulTime12 );
			float sin11 = sin( mulTime12 );
			float2 rotator11 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos11 , -sin11 , sin11 , cos11 )) + float2( 0.5,0.5 );
			float2 temp_output_2_0_g1 = rotator11;
			float2 break6_g1 = temp_output_2_0_g1;
			float temp_output_25_0_g1 = ( pow( 0.5 , 3.0 ) * 0.1 );
			float2 appendResult8_g1 = (float2(( break6_g1.x + temp_output_25_0_g1 ) , break6_g1.y));
			float4 tex2DNode14_g1 = tex2D( _DistortNoiseTexture, temp_output_2_0_g1 );
			float temp_output_4_0_g1 = _NormalStrength;
			float3 appendResult13_g1 = (float3(1.0 , 0.0 , ( ( tex2D( _DistortNoiseTexture, appendResult8_g1 ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float2 appendResult9_g1 = (float2(break6_g1.x , ( break6_g1.y + temp_output_25_0_g1 )));
			float3 appendResult16_g1 = (float3(0.0 , 1.0 , ( ( tex2D( _DistortNoiseTexture, appendResult9_g1 ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float3 normalizeResult22_g1 = normalize( cross( appendResult13_g1 , appendResult16_g1 ) );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor4 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( float4( normalizeResult22_g1 , 0.0 ) + ase_grabScreenPosNorm ).xy);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV25 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode25 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV25, _FresnelPower ) );
			float4 temp_cast_3 = (0.0).xxxx;
			#ifdef _FRESNEL_ON
				float4 staticSwitch28 = temp_cast_3;
			#else
				float4 staticSwitch28 = ( fresnelNode25 * _FresnelColor );
			#endif
			c.rgb = ( ( float4( (screenColor4).rgb , 0.0 ) * _DistortColor ) + staticSwitch28 ).rgb;
			c.a = saturate( distanceDepth7 );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
0;0;1920;1019;4927.433;1648.583;3.31;True;False
Node;AmplifyShaderEditor.RangedFloatNode;13;-2535.421,194.5685;Inherit;False;Property;_TimeScale;TimeScale;5;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-2485.536,-176.9286;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;12;-2359.422,163.5685;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;14;-2354.422,-22.43148;Inherit;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;21;-2172.997,-638.4257;Inherit;True;Property;_DistortNoiseTexture;DistortNoiseTexture;2;0;Create;True;0;0;False;0;False;0fe9101c6b6e1124b90b120ceebd6cba;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;22;-2102.823,-286.9887;Inherit;False;Property;_NormalStrength;NormalStrength;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;11;-2124.422,-93.43144;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;18;-1880.051,-359.6663;Inherit;True;NormalCreate;0;;1;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;2;-1771.913,-115.9419;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-1681.927,288.4633;Inherit;False;Property;_FresnelScale;FresnelScale;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;-1679.927,367.4633;Inherit;False;Property;_FresnelPower;FresnelPower;9;0;Create;True;0;0;False;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;3;-1547.913,-194.9419;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FresnelNode;25;-1435.861,200.4027;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;-1345.28,421.4032;Inherit;False;Property;_FresnelColor;FresnelColor;10;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;4;-1334.913,-260.9419;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-1016.978,302.7032;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;17;-1098.907,-288.5185;Inherit;True;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-763.7666,-550.8676;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;6;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-1061.913,-51.94194;Inherit;False;Property;_DistortColor;DistortColor;4;0;Create;True;0;0;False;0;False;1,1,1,0;0.1223032,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;29;-926.3604,493.3463;Inherit;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-838.9132,-118.9419;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;7;-519.8091,-569.7211;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;28;-750.3604,296.3463;Inherit;False;Property;_Fresnel;Fresnel ?;7;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-421.4253,194.8468;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;9;-283.7666,-568.8678;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Distortion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;5;True;False;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;13;0
WireConnection;11;0;10;0
WireConnection;11;1;14;0
WireConnection;11;2;12;0
WireConnection;18;1;21;0
WireConnection;18;2;11;0
WireConnection;18;4;22;0
WireConnection;3;0;18;0
WireConnection;3;1;2;0
WireConnection;25;2;33;0
WireConnection;25;3;34;0
WireConnection;4;0;3;0
WireConnection;36;0;25;0
WireConnection;36;1;35;0
WireConnection;17;0;4;0
WireConnection;5;0;17;0
WireConnection;5;1;6;0
WireConnection;7;0;8;0
WireConnection;28;1;36;0
WireConnection;28;0;29;0
WireConnection;32;0;5;0
WireConnection;32;1;28;0
WireConnection;9;0;7;0
WireConnection;0;9;9;0
WireConnection;0;13;32;0
ASEEND*/
//CHKSM=D2FF248AA6029DC8EAFDEEC2AA442D151D919E43
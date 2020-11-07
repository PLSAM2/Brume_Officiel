// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Distortion/DistortionFresnel"
{
	Properties
	{
		_FresnelScale("Fresnel Scale", Range( 0 , 1)) = 0.510905
		_FresnelPower("Fresnel Power", Range( 0 , 5)) = 2
		[Toggle]_UseFresnelAlpha("Use Fresnel Alpha", Float) = 1
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_MainTex("Main Tex", 2D) = "white" {}
		_DistortionTexture("Distortion Texture", 2D) = "bump" {}
		_Scale("Scale", Float) = 1
		_DistortionSpeed("Distortion Speed", Vector) = (0,0,0,0)
		_Distortion("Distortion", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform float4 _TintColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _GrabTexture;
		uniform float _Distortion;
		uniform sampler2D _DistortionTexture;
		uniform float4 _DistortionTexture_ST;
		uniform float _Scale;
		uniform float2 _DistortionSpeed;
		uniform float _UseFresnelAlpha;
		uniform float _FresnelScale;
		uniform float _FresnelPower;


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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_DistortionTexture = i.uv_texcoord * _DistortionTexture_ST.xy + _DistortionTexture_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float4 screenColor14_g27 = tex2D( _GrabTexture, ( float4( ( _Distortion * UnpackNormal( tex2D( _DistortionTexture, (uv_DistortionTexture*_Scale + ( _Time.y * _DistortionSpeed )) ) ) ) , 0.0 ) + ase_grabScreenPosNorm ).xy );
			float3 temp_output_19_0_g27 = (( ( _TintColor * tex2D( _MainTex, uv_MainTex ) ) + screenColor14_g27 )).rgb;
			float temp_output_20_0_g27 = ( i.vertexColor.a * _TintColor.a );
			float temp_output_59_23 = temp_output_20_0_g27;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1_g26 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g26 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV1_g26, _FresnelPower ) );
			float4 appendResult44 = (float4(temp_output_19_0_g27 , lerp(temp_output_59_23,( temp_output_59_23 * saturate( fresnelNode1_g26 ) ),_UseFresnelAlpha)));
			o.Emission = appendResult44.xyz;
			o.Alpha = ( (appendResult44).w * i.vertexColor.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
714;438;1060;605;832.123;142.709;1.63545;True;False
Node;AmplifyShaderEditor.FunctionNode;59;-478.5901,20.72542;Float;False;QFX Get Distortion Cutout;4;;27;db69d9cc7908a9a44b0b25d1b86b6fe8;0;0;3;FLOAT3;22;FLOAT;23;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;40;-492.0824,324.7922;Float;False;QFX Get Fresnel;0;;26;0a832704e6daa5244b3db55d16dfb317;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-187.5699,252.3267;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;53;11.59151,167.7325;Float;False;Property;_UseFresnelAlpha;Use Fresnel Alpha;3;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;44;345.5204,27.79636;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexColorNode;61;379.5864,393.4638;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;58;391.8929,259.7139;Float;False;False;False;False;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;646.5752,281.8865;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;57;847.8729,-13.78123;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Distortion/DistortionFresnel;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;45;0;59;23
WireConnection;45;1;40;0
WireConnection;53;0;59;23
WireConnection;53;1;45;0
WireConnection;44;0;59;22
WireConnection;44;3;53;0
WireConnection;58;0;44;0
WireConnection;60;0;58;0
WireConnection;60;1;61;4
WireConnection;57;2;44;0
WireConnection;57;9;60;0
ASEEND*/
//CHKSM=258E882864CB32E2B596F87DACCD9C2E63426352
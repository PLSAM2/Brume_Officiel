// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Cutout/GlowCutout"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.1
		_FresnelScale("Fresnel Scale", Range( 0 , 1)) = 0.510905
		_FresnelPower("Fresnel Power", Range( 0 , 5)) = 2
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_AlphaCutout("Alpha Cutout", Float) = 0
		[Toggle]_CutoutFresnel("Cutout Fresnel", Float) = 1
		_MainTex("Main Tex", 2D) = "white" {}
		[HDR]_GlowColor("Glow Color", Color) = (0,0,0,0)
		_MainSpeed("Main Speed", Vector) = (0,0,0,0)
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv2_texcoord2;
			float3 uv_tex3coord;
		};

		uniform sampler2D _MainTex;
		uniform float2 _MainSpeed;
		uniform float4 _MainTex_ST;
		uniform float4 _GlowColor;
		uniform float4 _TintColor;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _CutoutFresnel;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _AlphaCutout;
		uniform float _Cutoff = 0.1;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner77 = ( _Time.y * _MainSpeed + uv_MainTex);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1_g2 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1_g2 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV1_g2, _FresnelPower ) );
			float temp_output_23_0 = saturate( fresnelNode1_g2 );
			float4 lerpResult50 = lerp( _GlowColor , ( _TintColor * i.vertexColor * temp_output_23_0 ) , temp_output_23_0);
			o.Emission = ( tex2D( _MainTex, panner77 ) * lerpResult50 ).rgb;
			float lerpResult72 = lerp( _GlowColor.a , _TintColor.a , temp_output_23_0);
			o.Alpha = ( lerpResult72 * i.vertexColor.a );
			float temp_output_51_0 = saturate( ( 1.0 - temp_output_23_0 ) );
			float2 uv_NoiseTex = i.uv2_texcoord2 * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float smoothstepResult69 = smoothstep( 0.0 , 0.2 , ( tex2D( _NoiseTex, uv_NoiseTex ).r - ( _AlphaCutout + i.uv_tex3coord.z ) ));
			clip( lerp(( temp_output_51_0 + smoothstepResult69 ),( temp_output_51_0 * smoothstepResult69 ),_CutoutFresnel) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
533;438;1060;605;3500.66;1475.547;4.563426;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1813.279,965.1547;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-1637.361,622.5059;Float;False;1;59;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-1789.148,881.139;Float;False;Property;_AlphaCutout;Alpha Cutout;5;0;Create;True;0;0;False;0;0;7.97;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1458.578,886.7496;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-1382.355,600.5187;Float;True;Property;_NoiseTex;Noise Tex;4;0;Create;True;0;0;False;0;140c5b15ccac91a4fb58b5ea4666c02f;2a2854d4b1276ce43b7452693bf47e04;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;23;-1171.444,58.90908;Float;False;QFX Get Fresnel;1;;2;0a832704e6daa5244b3db55d16dfb317;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;79;-260.7799,-331.0004;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;78;-325.7799,-454.0004;Float;False;Property;_MainSpeed;Main Speed;9;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-339.0494,-579.3573;Float;False;0;75;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-795.9426,-444.7403;Float;False;Property;_TintColor;Tint Color;10;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2,2,2,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-781.4116,635.6123;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;49;-900.4998,294.7603;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;19;-630.283,131.1213;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;77;-51.04938,-459.3573;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;52;-1156.474,-209.7787;Float;False;Property;_GlowColor;Glow Color;8;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;51;-544.9602,296.795;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-503.4037,-387.7173;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;69;-359.6006,639.1743;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;31.12895,-205.3436;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;70;-47.1801,574.5998;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;72;-212.5049,19.81915;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-57.08271,307.7061;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;75;133.7475,-489.8504;Float;True;Property;_MainTex;Main Tex;7;0;Create;True;0;0;False;0;None;01725f4874228d44cae6191ef23556bf;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-45.18409,129.0986;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;71;222.6963,416.3839;Float;False;Property;_CutoutFresnel;Cutout Fresnel;6;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;74;281.6627,-135.1337;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;17;566.5996,49.85668;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Cutout/GlowCutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.1;True;False;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;58;0;56;0
WireConnection;58;1;65;3
WireConnection;59;1;57;0
WireConnection;61;0;59;1
WireConnection;61;1;58;0
WireConnection;49;0;23;0
WireConnection;77;0;76;0
WireConnection;77;2;78;0
WireConnection;77;1;79;2
WireConnection;51;0;49;0
WireConnection;18;0;15;0
WireConnection;18;1;19;0
WireConnection;18;2;23;0
WireConnection;69;0;61;0
WireConnection;50;0;52;0
WireConnection;50;1;18;0
WireConnection;50;2;23;0
WireConnection;70;0;51;0
WireConnection;70;1;69;0
WireConnection;72;0;52;4
WireConnection;72;1;15;4
WireConnection;72;2;23;0
WireConnection;67;0;51;0
WireConnection;67;1;69;0
WireConnection;75;1;77;0
WireConnection;55;0;72;0
WireConnection;55;1;19;4
WireConnection;71;0;70;0
WireConnection;71;1;67;0
WireConnection;74;0;75;0
WireConnection;74;1;50;0
WireConnection;17;2;74;0
WireConnection;17;9;55;0
WireConnection;17;10;71;0
ASEEND*/
//CHKSM=A1D7DE075D273F79A5C012F20D7C243D4B351B43
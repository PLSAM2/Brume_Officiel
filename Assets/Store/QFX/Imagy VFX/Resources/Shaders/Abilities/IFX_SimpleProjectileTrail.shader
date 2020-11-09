// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Abilities/SimpleProjectileTrail"
{
	Properties
	{
		_TimeScale("Time Scale", Float) = 0
		_FlowMap("Flow Map", 2D) = "white" {}
		_FlowStrength("Flow Strength", Float) = 0
		_MainTex("Main Tex", 2D) = "white" {}
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_MaskMap("Mask Map", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Stencil
		{
			Ref 0
		}
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _TintColor;
		uniform sampler2D _MainTex;
		uniform float _TimeScale;
		uniform float4 _MainTex_ST;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _FlowStrength;
		uniform sampler2D _MaskMap;
		uniform float4 _MaskMap_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime151 = _Time.y * _TimeScale;
			float Time152 = mulTime151;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 panner153 = ( Time152 * float2( -1,0 ) + uv_FlowMap);
			float2 panner163 = ( Time152 * float2( 0,0 ) + ( uv_MainTex + ( ( ( (tex2D( _FlowMap, panner153 )).rg + -0.5 ) * 2.0 ) * _FlowStrength ) ));
			float4 tex2DNode168 = tex2D( _MainTex, panner163 );
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST.xy + _MaskMap_ST.zw;
			float4 tex2DNode181 = tex2D( _MaskMap, uv_MaskMap );
			o.Emission = ( _TintColor * tex2DNode168.r * i.vertexColor * tex2DNode181.r ).rgb;
			o.Alpha = ( tex2DNode168.r * i.vertexColor.a * tex2DNode181.r );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
927;92;480;936;-706.7918;2562.434;3.204376;False;False
Node;AmplifyShaderEditor.RangedFloatNode;150;-1475.133,-485.3661;Float;False;Property;_TimeScale;Time Scale;0;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;151;-1299.133,-480.3661;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;152;-1122.133,-484.3661;Float;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;148;-1155.106,-637.2558;Float;False;0;154;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;153;-874.7524,-601.2973;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;154;-638.1333,-630.3661;Float;True;Property;_FlowMap;Flow Map;1;0;Create;True;0;0;False;0;None;140c5b15ccac91a4fb58b5ea4666c02f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;155;-326.1333,-629.3661;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;158;-8.133301,-480.3661;Float;False;Property;_FlowStrength;Flow Strength;2;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;156;-83.1333,-622.3661;Float;False;ConstantBiasScale;-1;;12;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;176.8667,-622.3661;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;169;82.94824,-774.6415;Float;False;0;168;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;161;336.2576,-668.5261;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;164;321.2576,-542.5261;Float;False;152;Time;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;163;525.2576,-669.5261;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;179;759.7094,-904.2696;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;181;759.7374,-542.7658;Float;True;Property;_MaskMap;Mask Map;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;168;758.561,-728.4795;Float;True;Property;_MainTex;Main Tex;3;0;Create;True;0;0;False;0;None;4cb3f0346abb3384a87003549e8a4330;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;177;756.9315,-1078.09;Float;False;Property;_TintColor;Tint Color;4;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;1103.018,-693.8925;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;178;1092.601,-886.6025;Float;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;146;1362.477,-871.472;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Abilities/SimpleProjectileTrail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;True;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;4;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Custom;#pragma surface surf Unlit alpha:fade;False;;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;151;0;150;0
WireConnection;152;0;151;0
WireConnection;153;0;148;0
WireConnection;153;1;152;0
WireConnection;154;1;153;0
WireConnection;155;0;154;0
WireConnection;156;3;155;0
WireConnection;157;0;156;0
WireConnection;157;1;158;0
WireConnection;161;0;169;0
WireConnection;161;1;157;0
WireConnection;163;0;161;0
WireConnection;163;1;164;0
WireConnection;168;1;163;0
WireConnection;180;0;168;1
WireConnection;180;1;179;4
WireConnection;180;2;181;1
WireConnection;178;0;177;0
WireConnection;178;1;168;1
WireConnection;178;2;179;0
WireConnection;178;3;181;1
WireConnection;146;2;178;0
WireConnection;146;9;180;0
ASEEND*/
//CHKSM=AD159A2FF41DC4F55788DA73FD3216A3DC21C0ED
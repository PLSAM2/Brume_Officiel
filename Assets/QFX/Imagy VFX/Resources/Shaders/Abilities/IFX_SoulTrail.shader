// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Abilities/SoulTrail"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,1)
		_TimeScale("TimeScale", Float) = 0
		_Head("Head", 2D) = "white" {}
		_MainTex("Main Tex", 2D) = "white" {}
		_FlowMap("Flow Map", 2D) = "white" {}
		_FlowStrength("Flow Strength", Float) = 0
		[HDR]_ColorStart("Color Start", Color) = (0,0,0,0)
		[HDR]_ColorEnd("Color End ", Color) = (0,0,0,0)
		_FinalPower("Final Power", Float) = 0
		_MainTexSpeed("Main Tex Speed", Vector) = (0,0,0,0)
		_FlowMapSpeed("Flow Map Speed", Vector) = (0,0,0,0)
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0.37
		_DissolveEdgeWidth("Dissolve Edge Width", Range( 0 , 1)) = 0.37
		_MaskMap("Mask Map", 2D) = "white" {}
		_DissolveMap("Dissolve Map", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TreeTransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		Stencil
		{
			Ref 0
		}
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _DissolveEdgeWidth;
		uniform sampler2D _DissolveMap;
		uniform float4 _DissolveMap_ST;
		uniform float _DissolveAmount;
		uniform float4 _DissolveColor;
		uniform float4 _ColorStart;
		uniform sampler2D _Head;
		uniform float4 _Head_ST;
		uniform float4 _ColorEnd;
		uniform sampler2D _MainTex;
		uniform float _TimeScale;
		uniform float2 _MainTexSpeed;
		uniform float4 _MainTex_ST;
		uniform sampler2D _FlowMap;
		uniform float2 _FlowMapSpeed;
		uniform float _FlowStrength;
		uniform sampler2D _MaskMap;
		uniform float4 _MaskMap_ST;
		uniform float _FinalPower;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_DissolveMap = i.uv_texcoord * _DissolveMap_ST.xy + _DissolveMap_ST.zw;
			float temp_output_128_0 = ( tex2D( _DissolveMap, uv_DissolveMap ).r + (-0.6 + (( 1.0 - _DissolveAmount ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) );
			float temp_output_134_0 = saturate( temp_output_128_0 );
			float2 uv_Head = i.uv_texcoord * _Head_ST.xy + _Head_ST.zw;
			float4 tex2DNode88 = tex2D( _Head, uv_Head );
			float4 lerpResult54 = lerp( _ColorStart , _ColorEnd , 0);
			float mulTime6 = _Time.y * _TimeScale;
			float time7 = mulTime6;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv8 = uv_MainTex;
			float2 panner9 = ( time7 * _FlowMapSpeed + uv8);
			float2 panner43 = ( time7 * _MainTexSpeed + ( uv8 + ( ( ( (tex2D( _FlowMap, panner9 )).rg + -0.5 ) * 2.0 ) * _FlowStrength ) ));
			float4 tex2DNode45 = tex2D( _MainTex, panner43 );
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST.xy + _MaskMap_ST.zw;
			float4 tex2DNode93 = tex2D( _MaskMap, uv_MaskMap );
			o.Emission = (( _DissolveEdgeWidth > temp_output_134_0 ) ? _DissolveColor :  ( ( _ColorStart * tex2DNode88.a ) + ( ( lerpResult54 * tex2DNode45.r ) * tex2DNode93.r * _FinalPower ) ) ).rgb;
			o.Alpha = saturate( ( tex2DNode88.a + ( tex2DNode45.r * tex2DNode93.r * i.vertexColor.a ) ) );
			clip( temp_output_134_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
241;244;1084;799;-239.4549;1733.556;3.316544;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-2169.988,427.8152;Float;False;Property;_TimeScale;TimeScale;2;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2015.86,434.0619;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2038.831,49.84193;Float;False;0;46;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-1832.623,428.9387;Float;False;time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1790.81,52.73065;Float;False;uv;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;61;-1969.191,261.5509;Float;False;Property;_FlowMapSpeed;Flow Map Speed;12;0;Create;True;0;0;False;0;0,0;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;9;-1499.347,181.3447;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;12;-1773.775,-248.7525;Float;True;Property;_FlowMap;Flow Map;6;0;Create;True;0;0;False;0;None;86ad23c623f950a4997067186e283be5;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;11;-1293.918,153.2345;Float;True;Property;_1;1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;13;-985.544,153.3575;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;14;-766.0029,158.7649;Float;False;ConstantBiasScale;-1;;11;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-698.9508,293.9503;Float;False;Property;_FlowStrength;Flow Strength;7;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-491.6571,44.9859;Float;False;8;uv;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-458.7021,157.1017;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-271.4571,330.3859;Float;False;7;time;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-237.6571,79.9859;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;60;-268.336,192.2274;Float;False;Property;_MainTexSpeed;Main Tex Speed;11;0;Create;True;0;0;False;0;0,0;-0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;43;-24.6571,79.9859;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.8,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;46;-69.23958,-257.139;Float;True;Property;_MainTex;Main Tex;5;0;Create;True;0;0;False;0;None;09f4a30c1a0141b5aaa317dfad6ebb90;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;121;1082.594,382.4312;Float;False;Property;_DissolveAmount;Dissolve Amount;13;0;Create;True;0;0;False;0;0.37;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;437.759,-899.5054;Float;False;Property;_ColorEnd;Color End ;9;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;50;435.7832,-700.0701;Float;True;-1;;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;444.759,-1071.505;Float;False;Property;_ColorStart;Color Start;8;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,1.751724,2,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;54;732.759,-912.5054;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;45;269.1928,-219.5641;Float;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;126;1387.738,389.4878;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;93;856.6133,-520.5329;Float;True;Property;_MaskMap;Mask Map;15;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;127;1579.263,388.6704;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;100;1078.802,156.6178;Float;True;Property;_DissolveMap;Dissolve Map;16;0;Create;True;0;0;False;0;None;d784595d7b8bfef41ac0a5bd8fa0a662;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;49;837.7581,-30.80776;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;1249.509,-520.5531;Float;False;Property;_FinalPower;Final Power;10;0;Create;True;0;0;False;0;0;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;88;1038.827,-996.0403;Float;True;Property;_Head;Head;3;0;Create;True;0;0;False;0;None;768492d0a244fd348a8869cf49c7e003;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;1057.833,-797.2925;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;128;1786.031,188.3062;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;1430.252,-749.3896;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1138.076,-201.1501;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;1447.541,-1064.09;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;134;2211.958,193.8411;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;1621.737,-899.2578;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;1566.112,-371.4284;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;116;2006.731,-896.5071;Float;False;Property;_DissolveColor;Dissolve Color;1;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;131;2010.155,-1031.242;Float;False;Property;_DissolveEdgeWidth;Dissolve Edge Width;14;0;Create;True;0;0;False;0;0.37;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;130;2402.767,-567.9703;Float;True;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;148;1997.155,141.1509;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;75;1845.892,-371.7348;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;47.38647,-44.26392;Float;False;Property;_MaskProgress;Mask Progress;4;0;Create;True;0;0;False;0;-0.03;1.918521;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;146;2859.48,-317.17;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Abilities/SoulTrail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TreeTransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;True;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;4;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Custom;#pragma surface surf Unlit alpha:fade;False;;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;7;0;6;0
WireConnection;8;0;4;0
WireConnection;9;0;8;0
WireConnection;9;2;61;0
WireConnection;9;1;7;0
WireConnection;11;0;12;0
WireConnection;11;1;9;0
WireConnection;13;0;11;0
WireConnection;14;3;13;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;41;0;42;0
WireConnection;41;1;15;0
WireConnection;43;0;41;0
WireConnection;43;2;60;0
WireConnection;43;1;44;0
WireConnection;54;0;53;0
WireConnection;54;1;52;0
WireConnection;54;2;50;0
WireConnection;45;0;46;0
WireConnection;45;1;43;0
WireConnection;126;0;121;0
WireConnection;127;0;126;0
WireConnection;55;0;54;0
WireConnection;55;1;45;1
WireConnection;128;0;100;1
WireConnection;128;1;127;0
WireConnection;96;0;55;0
WireConnection;96;1;93;1
WireConnection;96;2;56;0
WireConnection;72;0;45;1
WireConnection;72;1;93;1
WireConnection;72;2;49;4
WireConnection;92;0;53;0
WireConnection;92;1;88;4
WireConnection;134;0;128;0
WireConnection;97;0;92;0
WireConnection;97;1;96;0
WireConnection;91;0;88;4
WireConnection;91;1;72;0
WireConnection;130;0;131;0
WireConnection;130;1;134;0
WireConnection;130;2;116;0
WireConnection;130;3;97;0
WireConnection;148;1;128;0
WireConnection;75;0;91;0
WireConnection;146;2;130;0
WireConnection;146;9;75;0
WireConnection;146;10;134;0
ASEEND*/
//CHKSM=0BF646FB3C7D4314981D9B29B4F23B0AC58A11EC
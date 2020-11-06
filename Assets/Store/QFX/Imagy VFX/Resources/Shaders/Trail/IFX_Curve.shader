// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Trail/Curve"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_MainTex("Main Tex", 2D) = "white" {}
		_Speed("Speed", Vector) = (0,0,0,0)
		_MaskSize("Mask Size", Vector) = (0.08,0.2,0,0)
		_MainTexOffsetY("Main Tex Offset Y", Float) = 0
		_MainTexOffsetX("Main Tex Offset X", Float) = 0
		_TexAddX("Tex Add X", Float) = 0.5
		_MaskMap("Mask Map", 2D) = "white" {}
		[Toggle]_UseMaskMap("Use Mask Map", Float) = 1
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float3 uv_tex3coord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _MainTex;
		uniform float4 _Speed;
		uniform float4 _MainTex_ST;
		uniform float _MainTexOffsetX;
		uniform float _TexAddX;
		uniform float _MainTexOffsetY;
		uniform float4 _TintColor;
		uniform float2 _MaskSize;
		uniform float _UseMaskMap;
		uniform sampler2D _MaskMap;
		uniform float4 _MaskMap_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult228 = (float2(_Speed.x , _Speed.y));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float temp_output_198_0 = ( _MainTexOffsetX + i.uv_tex3coord.z );
			float2 appendResult192 = (float2(( temp_output_198_0 - _TexAddX ) , _MainTexOffsetY));
			float2 temp_output_176_0 = ( uv_MainTex - appendResult192 );
			float2 panner232 = ( _Time.y * appendResult228 + temp_output_176_0);
			float4 tex2DNode234 = tex2D( _MainTex, panner232 );
			float2 break168 = i.uv_texcoord;
			float temp_output_152_0 = saturate( ( step( abs( ( break168.x - temp_output_198_0 ) ) , _MaskSize.x ) * step( abs( ( break168.y - 0.5 ) ) , _MaskSize.y ) ) );
			float4 emission243 = ( tex2DNode234.r * _TintColor * temp_output_152_0 * i.vertexColor );
			o.Emission = emission243.rgb;
			float uv_mask215 = ( ( i.uv_texcoord.y * ( 1.0 - i.uv_texcoord.y ) * ( 1.0 - i.uv_texcoord.x ) * 8.0 ) * ( ( i.uv_texcoord.x * i.uv_texcoord.y * ( 1.0 - i.uv_texcoord.y ) ) * 20.0 ) );
			float opacity244 = ( i.vertexColor.a * tex2DNode234.r * temp_output_152_0 );
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST.xy + _MaskMap_ST.zw;
			o.Alpha = saturate( lerp(( uv_mask215 * opacity244 ),( opacity244 * tex2D( _MaskMap, uv_MaskMap ).r ),_UseMaskMap) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
797;161;1227;680;-223.5621;-605.3364;1.793105;True;False
Node;AmplifyShaderEditor.CommentaryNode;201;-2127.954,-597.1671;Float;False;310;229;is animated by Particle System;1;200;;0.09805238,1,0,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-1973.505,-683.0233;Float;False;Property;_MainTexOffsetX;Main Tex Offset X;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;200;-2077.953,-547.1671;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;198;-1725.14,-577.23;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;128;-1661.613,-830.1138;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;197;-1697.688,-321.3021;Float;False;Property;_TexAddX;Tex Add X;6;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1777.18,-127.3046;Float;False;Property;_MainTexOffsetY;Main Tex Offset Y;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-1703.031,-224.4999;Float;False;Constant;_TexAddY;Tex Add Y;10;0;Create;True;0;0;False;0;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;168;-1393.807,-829.3569;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleSubtractOpNode;177;-1488.276,-478.3961;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;199;-1412.318,-646.0145;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;236;-1513.439,99.9726;Float;False;2361.99;1004.37;;16;244;253;243;239;240;241;252;257;250;234;232;228;176;230;238;223;FLOW & MAIN;0,0,0,1;0;0
Node;AmplifyShaderEditor.Vector4Node;223;-1462.621,542.3989;Float;False;Property;_Speed;Speed;2;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;192;-1414.729,-189.7923;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;155;-1003.731,-409.0334;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;156;-1001.467,-534.9742;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;238;-1489.127,149.2605;Float;False;0;234;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;214;-1515.32,1252.48;Float;False;2276.908;815.8495;;12;211;213;210;212;209;208;207;206;205;204;203;215;UV MASK;0,1,0.4206896,1;0;0
Node;AmplifyShaderEditor.AbsOpNode;146;-858.8792,-409.6407;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;137;-852.6734,-531.631;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;149;-1001.305,-240.9106;Float;False;Property;_MaskSize;Mask Size;3;0;Create;True;0;0;False;0;0.08,0.2;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;230;-1058.007,426.9425;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;176;-1178.966,154.6534;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;228;-1099.658,310.2015;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;211;-1426.126,1536.055;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;204;-1036.16,1789.224;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;203;-668.5741,1864.075;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;232;-807.7172,242.3427;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;144;-706.3538,-411.9863;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;143;-705.4492,-530.8107;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-658.5981,1652.866;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;213;-904.1432,1353.125;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;234;-574.1305,216.2082;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;4b7b360a21c5d084abec3db1c7b65512;4452c7d8018d75f48bff0bb51e0254fb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;154;-529.6799,-489.929;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;207;-430.2327,1751.73;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;206;-655.7953,1567.243;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;205;-655.7947,1487.422;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;240;-75.76641,475.643;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;152;-392.7132,-491.1033;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;257;-386.986,683.7555;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;208;-394.1655,1464.654;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;209;-196.5023,1693.071;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;344.117,688.9647;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;61.3055,1571.549;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;215;345.1277,1567.302;Float;False;uv_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;244;580.4019,684.3853;Float;True;opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;246;974.568,1270.27;Float;False;244;opacity;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;254;960.3379,1190.188;Float;False;215;uv_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;241;-97.72429,149.684;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;8,8,8,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;202;915.3649,1465.271;Float;True;Property;_MaskMap;Mask Map;7;0;Create;True;0;0;False;0;None;a616776311244cf40a3bedf5108a59c7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;84;1253.5,1358.338;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;239;328.3452,343.016;Float;True;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;259;1183.62,1218.271;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;243;581.8378,337.064;Float;True;emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;216;-1536.241,2216.62;Float;False;1415.85;589.0923;;6;222;221;220;219;218;217;ADJUST UV MASK;0,1,0.3793101,1;0;0
Node;AmplifyShaderEditor.ToggleSwitchNode;258;1464.64,1235.14;Float;False;Property;_UseMaskMap;Use Mask Map;8;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;221;-679.787,2334.586;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-529.2423,2328.607;Float;False;adjust_uv_mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;220;-925.934,2333.133;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;250;-983.7046,159.8382;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;252;26.55817,695.1139;Float;True;222;adjust_uv_mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;245;1053.557,993.7647;Float;True;243;emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;75;1703.104,1238.929;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;217;-1399.179,2635.243;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;218;-1337.009,2337.445;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;219;-1137.384,2335.147;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;1897.592,1056.041;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Trail/Curve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;198;0;191;0
WireConnection;198;1;200;3
WireConnection;168;0;128;0
WireConnection;177;0;198;0
WireConnection;177;1;197;0
WireConnection;199;0;198;0
WireConnection;192;0;177;0
WireConnection;192;1;196;0
WireConnection;155;0;168;1
WireConnection;155;1;162;0
WireConnection;156;0;168;0
WireConnection;156;1;199;0
WireConnection;146;0;155;0
WireConnection;137;0;156;0
WireConnection;176;0;238;0
WireConnection;176;1;192;0
WireConnection;228;0;223;1
WireConnection;228;1;223;2
WireConnection;204;0;211;2
WireConnection;203;0;211;2
WireConnection;232;0;176;0
WireConnection;232;2;228;0
WireConnection;232;1;230;2
WireConnection;144;0;146;0
WireConnection;144;1;149;2
WireConnection;143;0;137;0
WireConnection;143;1;149;1
WireConnection;213;0;211;2
WireConnection;234;1;232;0
WireConnection;154;0;143;0
WireConnection;154;1;144;0
WireConnection;207;0;211;1
WireConnection;207;1;211;2
WireConnection;207;2;203;0
WireConnection;206;0;211;1
WireConnection;205;0;204;0
WireConnection;152;0;154;0
WireConnection;257;0;234;1
WireConnection;208;0;213;0
WireConnection;208;1;205;0
WireConnection;208;2;206;0
WireConnection;208;3;212;0
WireConnection;209;0;207;0
WireConnection;253;0;240;4
WireConnection;253;1;257;0
WireConnection;253;2;152;0
WireConnection;210;0;208;0
WireConnection;210;1;209;0
WireConnection;215;0;210;0
WireConnection;244;0;253;0
WireConnection;84;0;246;0
WireConnection;84;1;202;1
WireConnection;239;0;234;1
WireConnection;239;1;241;0
WireConnection;239;2;152;0
WireConnection;239;3;240;0
WireConnection;259;0;254;0
WireConnection;259;1;246;0
WireConnection;243;0;239;0
WireConnection;258;0;259;0
WireConnection;258;1;84;0
WireConnection;221;0;220;0
WireConnection;222;0;221;0
WireConnection;220;0;219;0
WireConnection;250;0;176;0
WireConnection;75;0;258;0
WireConnection;218;0;211;1
WireConnection;219;0;218;0
WireConnection;219;1;217;0
WireConnection;2;2;245;0
WireConnection;2;9;75;0
ASEEND*/
//CHKSM=3DAD965612E355D7780F54DC1B75AAAD4B334269
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Cutout/AlphaBlendNoiseCutout"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,1)
		_AlphaCutout("Alpha Cutout", Float) = 0
		_MainTex("Main Tex", 2D) = "white" {}
		_TexPower("Tex Power", Float) = 1
		_DissolveEdgeWidth("Dissolve Edge Width", Range( 0 , 1)) = 0
		_NoiseSpeed("Noise Speed", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 uv_tex3coord;
			float2 uv2_texcoord2;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _DissolveEdgeWidth;
		uniform float _AlphaCutout;
		uniform sampler2D _NoiseTex;
		uniform float2 _NoiseSpeed;
		uniform float4 _NoiseTex_ST;
		uniform float4 _DissolveColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _TexPower;
		uniform float4 _TintColor;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_NoiseTex = i.uv2_texcoord2 * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner71 = ( _Time.y * _NoiseSpeed + uv_NoiseTex);
			float temp_output_19_0 = ( ( 1.0 - ( _AlphaCutout + i.uv_tex3coord.z ) ) - tex2D( _NoiseTex, panner71 ).r );
			float OpacityMask27 = temp_output_19_0;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 Emission22 = ( pow( tex2D( _MainTex, uv_MainTex ).r , _TexPower ) * _TintColor * i.vertexColor );
			o.Emission = (( _DissolveEdgeWidth > saturate( OpacityMask27 ) ) ? _DissolveColor :  Emission22 ).rgb;
			float temp_output_48_0 = (Emission22).a;
			o.Alpha = ( temp_output_48_0 * i.vertexColor.a );
			clip( ( temp_output_48_0 * OpacityMask27 ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
533;438;1060;605;3092.033;14.44971;1;True;False
Node;AmplifyShaderEditor.Vector2Node;70;-2708.033,222.5503;Float;False;Property;_NoiseSpeed;Noise Speed;8;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;72;-2709.033,379.5503;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-2711.455,86.8371;Float;False;1;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-2466.865,579.424;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-2413.462,485.671;Float;False;Property;_AlphaCutout;Alpha Cutout;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;71;-2458.033,225.5503;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-2191.575,490.6151;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-2185.393,831.8754;Float;False;0;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;55;-1970.672,491.1886;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-1912.147,686.4109;Float;True;Property;_MainTex;Main Tex;5;0;Create;True;0;0;False;0;None;140c5b15ccac91a4fb58b5ea4666c02f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-2246.713,197.9425;Float;True;Property;_NoiseTex;Noise Tex;1;0;Create;True;0;0;False;0;None;140c5b15ccac91a4fb58b5ea4666c02f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;57;-1760.339,1004.052;Float;False;Property;_TexPower;Tex Power;6;0;Create;True;0;0;False;0;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;59;-1492.949,1449.278;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;56;-1528.356,828.6035;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1834.158,216.5794;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1502.742,1261.156;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2.5,2.5,2.5,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1316.193,212.3789;Float;True;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1166.016,1085.019;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-963.1421,1078.194;Float;True;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-131.7604,1074.527;Float;True;27;OpacityMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;48;-623.2192,712.2346;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;65;77.4077,815.1886;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;38.66884,-11.2167;Float;True;22;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;64;37.44855,437.026;Float;False;Property;_DissolveColor;Dissolve Color;3;1;[HDR];Create;True;0;0;False;0;1,1,1,1;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-0.1776242,317.2508;Float;False;Property;_DissolveEdgeWidth;Dissolve Edge Width;7;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;23;-446.497,821.5546;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;68;-1604.647,454.063;Float;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;False;0;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-217.544,657.3463;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;286.0408,1044.223;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;63;371.5839,360.4258;Float;True;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;67;-1468.897,344.8324;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.63;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;51;739.3195,451.1123;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Cutout/AlphaBlendNoiseCutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;;False;;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;71;0;61;0
WireConnection;71;2;70;0
WireConnection;71;1;72;2
WireConnection;43;0;15;0
WireConnection;43;1;46;3
WireConnection;55;0;43;0
WireConnection;31;1;60;0
WireConnection;12;1;71;0
WireConnection;56;0;31;1
WireConnection;56;1;57;0
WireConnection;19;0;55;0
WireConnection;19;1;12;1
WireConnection;27;0;19;0
WireConnection;18;0;56;0
WireConnection;18;1;13;0
WireConnection;18;2;59;0
WireConnection;22;0;18;0
WireConnection;48;0;22;0
WireConnection;65;0;26;0
WireConnection;25;0;48;0
WireConnection;25;1;23;4
WireConnection;69;0;48;0
WireConnection;69;1;26;0
WireConnection;63;0;62;0
WireConnection;63;1;65;0
WireConnection;63;2;64;0
WireConnection;63;3;30;0
WireConnection;67;0;19;0
WireConnection;67;1;68;0
WireConnection;51;2;63;0
WireConnection;51;9;25;0
WireConnection;51;10;69;0
ASEEND*/
//CHKSM=C819FD94EFE201CDA6A35DE6F1E4746A478D1134
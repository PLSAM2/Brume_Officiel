// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Cutout/AlphaBlendNoiseCutout_Dist"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_AlphaCutout("Alpha Cutout", Float) = 0
		_MainTex("Main Tex", 2D) = "white" {}
		_TexPower("Tex Power", Float) = 1
		_FlowSpeed("Flow Speed", Vector) = (0,0,0,0)
		_Speed("Speed", Vector) = (0,0,0,0)
		_FlowMap("Flow Map", 2D) = "white" {}
		_Flow("Flow", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
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
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 uv_tex3coord;
		};

		uniform sampler2D _MainTex;
		uniform float2 _Speed;
		uniform float4 _MainTex_ST;
		uniform float _TexPower;
		uniform float4 _TintColor;
		uniform sampler2D _NoiseTex;
		uniform sampler2D _FlowMap;
		uniform float4 _FlowMap_ST;
		uniform float _Flow;
		uniform float2 _FlowSpeed;
		uniform float _AlphaCutout;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner62 = ( _Time.y * _Speed + uv_MainTex);
			float4 tex2DNode31 = tex2D( _MainTex, panner62 );
			float temp_output_56_0 = pow( tex2DNode31.r , _TexPower );
			float4 Emission22 = ( temp_output_56_0 * _TintColor * i.vertexColor );
			o.Emission = Emission22.rgb;
			o.Alpha = saturate( ( (Emission22).a * i.vertexColor.a ) );
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 panner73 = ( _Time.y * _FlowSpeed + uv_FlowMap);
			float OpacityMask27 = ( ( temp_output_56_0 - ( tex2D( _NoiseTex, ( ( tex2D( _FlowMap, uv_FlowMap ).r * _Flow ) + panner73 ) ).r - ( 1.0 - ( _AlphaCutout + i.uv_tex3coord.z ) ) ) ) * tex2DNode31.a );
			clip( OpacityMask27 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
101;314;1227;680;3637.711;371.5574;1.735345;True;False
Node;AmplifyShaderEditor.TimeNode;63;-2494.04,1098.182;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-2827.592,269.7676;Float;False;Property;_Flow;Flow;9;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-2489.312,788.0352;Float;False;0;31;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;66;-2873.506,2.628799;Float;True;Property;_FlowMap;Flow Map;8;0;Create;True;0;0;False;0;None;d784595d7b8bfef41ac0a5bd8fa0a662;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;65;-2475.928,957.441;Float;False;Property;_Speed;Speed;7;0;Create;True;0;0;False;0;0,0;-0.5,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;72;-3438.309,236.7368;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;70;-3433.581,-73.40971;Float;False;0;66;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;71;-3420.197,95.99597;Float;False;Property;_FlowSpeed;Flow Speed;6;0;Create;True;0;0;False;0;0,0;-0.5,-0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-2556.28,148.7204;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-2466.865,579.424;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;15;-2413.462,485.671;Float;False;Property;_AlphaCutout;Alpha Cutout;3;0;Create;True;0;0;False;0;0;1.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;73;-3080.256,26.67877;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;62;-2135.987,888.1237;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-2191.575,490.6151;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-2341.316,154.9814;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1760.339,1004.052;Float;False;Property;_TexPower;Tex Power;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-1924.084,808.1491;Float;True;Property;_MainTex;Main Tex;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-1991.62,208.5308;Float;True;Property;_NoiseTex;Noise Tex;1;0;Create;True;0;0;False;0;None;140c5b15ccac91a4fb58b5ea4666c02f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;55;-1827.932,490.4519;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;-1528.356,828.6035;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;59;-1492.949,1449.278;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-1502.742,1261.156;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;4,4,4,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1166.016,1085.019;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1580.039,233.2182;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;40;-1320.077,343.9556;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-963.1421,1078.194;Float;True;Emission;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1095.804,385.2491;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;23;-446.497,821.5546;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;48;-623.2192,712.2346;Float;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-918.8,376.6079;Float;True;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-186.9363,718.5619;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-46.71175,1162.476;Float;True;27;OpacityMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;74;52.3464,713.9189;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-2542.982,303.5855;Float;False;1;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;30;-74.63905,400.7302;Float;True;22;Emission;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;51;314.5516,543.1608;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Cutout/AlphaBlendNoiseCutout_Dist;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;66;1
WireConnection;68;1;67;0
WireConnection;73;0;70;0
WireConnection;73;2;71;0
WireConnection;73;1;72;2
WireConnection;62;0;60;0
WireConnection;62;2;65;0
WireConnection;62;1;63;2
WireConnection;43;0;15;0
WireConnection;43;1;46;3
WireConnection;69;0;68;0
WireConnection;69;1;73;0
WireConnection;31;1;62;0
WireConnection;12;1;69;0
WireConnection;55;0;43;0
WireConnection;56;0;31;1
WireConnection;56;1;57;0
WireConnection;18;0;56;0
WireConnection;18;1;13;0
WireConnection;18;2;59;0
WireConnection;19;0;12;1
WireConnection;19;1;55;0
WireConnection;40;0;56;0
WireConnection;40;1;19;0
WireConnection;22;0;18;0
WireConnection;53;0;40;0
WireConnection;53;1;31;4
WireConnection;48;0;22;0
WireConnection;27;0;53;0
WireConnection;25;0;48;0
WireConnection;25;1;23;4
WireConnection;74;0;25;0
WireConnection;51;2;30;0
WireConnection;51;9;74;0
WireConnection;51;10;26;0
ASEEND*/
//CHKSM=4F0834C3E990634341F77DFA7C649ABDBF6EC09B
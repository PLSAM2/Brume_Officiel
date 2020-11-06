// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Cutout/GlowCutout_Hard"
{
	Properties
	{
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_AlphaCutout("Alpha Cutout", Range( -0.5 , 0.5)) = 0
		[HDR]_GlowColor("Glow Color", Color) = (0,0,0,0)
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_AdjustMax("Adjust Max", Range( 0 , 1)) = 0
		_AdjustMin("Adjust Min", Range( 0 , 1)) = 0
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float3 uv_tex3coord;
		};

		uniform float4 _TintColor;
		uniform float _AdjustMin;
		uniform float _AdjustMax;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform float4 _GlowColor;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float _AlphaCutout;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float smoothstepResult71 = smoothstep( _AdjustMin , _AdjustMax , tex2D( _Mask, uv_Mask ).r);
			float temp_output_51_0 = saturate( ( 1.0 - smoothstepResult71 ) );
			float4 lerpResult50 = lerp( ( _TintColor * i.vertexColor * smoothstepResult71 ) , _GlowColor , temp_output_51_0);
			o.Emission = lerpResult50.rgb;
			float lerpResult54 = lerp( i.vertexColor.a , ( _GlowColor.a * i.vertexColor.a ) , temp_output_51_0);
			float2 uv_NoiseTex = i.uv2_texcoord2 * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float smoothstepResult69 = smoothstep( 0.0 , 0.2 , ( tex2D( _NoiseTex, uv_NoiseTex ).r - ( _AlphaCutout + i.uv_tex3coord.z ) ));
			o.Alpha = ( lerpResult54 * smoothstepResult69 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
429;363;1227;680;2631.601;389.5739;2.411942;True;False
Node;AmplifyShaderEditor.SamplerNode;70;-1833.179,156.0907;Float;True;Property;_Mask;Mask;1;0;Create;True;0;0;False;0;None;fc236386a4905e341ac33b46758022ad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;72;-1830.837,346.0682;Float;False;Property;_AdjustMin;Adjust Min;6;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-1830.837,423.2502;Float;False;Property;_AdjustMax;Adjust Max;5;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;57;-1637.361,622.5059;Float;False;1;59;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;56;-1789.148,881.139;Float;False;Property;_AlphaCutout;Alpha Cutout;2;0;Create;True;0;0;False;0;0;0.1;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1813.279,965.1547;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;71;-1423.218,184.4683;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;19;-746.7814,89.15701;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-1458.578,886.7496;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;59;-1382.355,600.5187;Float;True;Property;_NoiseTex;Noise Tex;0;0;Create;True;0;0;False;0;140c5b15ccac91a4fb58b5ea4666c02f;163632276e446414db3976d5befc6048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;49;-900.4998,294.7603;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;52;-1169.469,-237.2126;Float;False;Property;_GlowColor;Glow Color;3;1;[HDR];Create;True;0;0;False;0;0,0,0,0;3,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;61;-781.4116,635.6123;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-795.9426,-444.7403;Float;False;Property;_TintColor;Tint Color;4;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,1.668965,2,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-352.6013,146.9633;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;51;-544.9602,296.795;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;69;-462.4647,712.6019;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-220.4765,276.7993;Float;True;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-423.9901,-256.3238;Float;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;50;-227.6065,-166.566;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;39.1419,203.9531;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;17;271.9793,-10.66778;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Cutout/GlowCutout_Hard;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;71;0;70;1
WireConnection;71;1;72;0
WireConnection;71;2;73;0
WireConnection;58;0;56;0
WireConnection;58;1;65;3
WireConnection;59;1;57;0
WireConnection;49;0;71;0
WireConnection;61;0;59;1
WireConnection;61;1;58;0
WireConnection;55;0;52;4
WireConnection;55;1;19;4
WireConnection;51;0;49;0
WireConnection;69;0;61;0
WireConnection;54;0;19;4
WireConnection;54;1;55;0
WireConnection;54;2;51;0
WireConnection;18;0;15;0
WireConnection;18;1;19;0
WireConnection;18;2;71;0
WireConnection;50;0;18;0
WireConnection;50;1;52;0
WireConnection;50;2;51;0
WireConnection;67;0;54;0
WireConnection;67;1;69;0
WireConnection;17;2;50;0
WireConnection;17;9;67;0
ASEEND*/
//CHKSM=4F11223DFBCBACCEF3CBBDFF02E516FB0D297ECF
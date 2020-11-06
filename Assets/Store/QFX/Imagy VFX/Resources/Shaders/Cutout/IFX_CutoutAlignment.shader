// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Cutout/CutoutAlignment"
{
	Properties
	{
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_AlphaCutout("Alpha Cutout", Float) = 0
		_MainTex("Main Tex", 2D) = "white" {}
		_TexPower("Tex Power", Float) = 1
		_NoiseSpeed("Noise Speed", Vector) = (0,0,0,0)
		_NoiseMin("Noise Min", Float) = 0
		_NoiseMax("Noise Max", Float) = 1
		[KeywordEnum(X,Y)] _Alignment("Alignment", Float) = 0
		_Size("Size", Float) = 1
		_NoisePower("Noise Power", Float) = 1
		[HideInInspector] _tex3coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _ALIGNMENT_X _ALIGNMENT_Y
		#pragma #pragma surface surf Unlit keepalpha noshadow alpha:fade
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
		uniform float4 _MainTex_ST;
		uniform float _TexPower;
		uniform float4 _TintColor;
		uniform sampler2D _NoiseTex;
		uniform float2 _NoiseSpeed;
		uniform float4 _NoiseTex_ST;
		uniform float _NoisePower;
		uniform float _NoiseMin;
		uniform float _NoiseMax;
		uniform float _AlphaCutout;
		uniform float _Size;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode31 = tex2D( _MainTex, uv_MainTex );
			float4 temp_cast_0 = (_TexPower).xxxx;
			o.Emission = ( ( pow( tex2DNode31 , temp_cast_0 ) * _TintColor ) * i.vertexColor ).rgb;
			o.Alpha = ( tex2DNode31.a * i.vertexColor.a );
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner62 = ( _Time.y * _NoiseSpeed + uv_NoiseTex);
			#if defined(_ALIGNMENT_X)
				float staticSwitch96 = i.uv_texcoord.x;
			#elif defined(_ALIGNMENT_Y)
				float staticSwitch96 = i.uv_texcoord.y;
			#else
				float staticSwitch96 = i.uv_texcoord.x;
			#endif
			float temp_output_128_0 = ( abs( ( staticSwitch96 + ( _AlphaCutout + i.uv_tex3coord.z ) ) ) - _Size );
			float smoothstepResult81 = smoothstep( _NoiseMin , _NoiseMax , temp_output_128_0);
			float OpacityMask27 = ( ( ( tex2D( _NoiseTex, panner62 ).r * _NoisePower ) - smoothstepResult81 ) * saturate( ( 1.0 - temp_output_128_0 ) ) );
			clip( saturate( OpacityMask27 ) - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
-41;485;1906;463;3891.98;686.4037;1.390703;True;False
Node;AmplifyShaderEditor.RangedFloatNode;15;-3033.457,-443.2428;Float;False;Property;_AlphaCutout;Alpha Cutout;3;0;Create;True;0;0;False;0;0;-2.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3086.859,-349.4898;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-3095.595,-164.3821;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-2811.57,-438.2987;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;96;-2827.512,-147.2435;Float;True;Property;_Alignment;Alignment;9;0;Create;True;0;0;False;0;0;0;1;True;;KeywordEnum;2;X;Y;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;64;-2730.974,274.8971;Float;False;Property;_NoiseSpeed;Noise Speed;6;0;Create;True;0;0;False;0;0,0;0.5,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;65;-2765.356,433.7265;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;61;-2774.675,115.1243;Float;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-2554.662,-303.8715;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.28;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-2412.858,-453.5385;Float;False;Property;_Size;Size;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;62;-2480.963,264.562;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;80;-2349.852,-303.1217;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1962.695,-552.4367;Float;False;Property;_NoiseMin;Noise Min;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-1962.897,-469.7183;Float;False;Property;_NoiseMax;Noise Max;8;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;128;-2161.109,-341.968;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2145.591,428.0527;Float;False;Property;_NoisePower;Noise Power;11;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-2296.663,237.774;Float;True;Property;_NoiseTex;Noise Tex;1;0;Create;True;0;0;False;0;None;140c5b15ccac91a4fb58b5ea4666c02f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;126;-1952.272,115.757;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;103;-2099.719,-58.43204;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;81;-1810.972,-302.91;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-1951.451,600.3507;Float;True;Property;_MainTex;Main Tex;4;0;Create;True;0;0;False;0;None;044739fcb2afdba47b715dad90299771;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-1632.572,-34.53204;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;131;-1876.411,-46.64743;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;57;-1826.99,794.8143;Float;False;Property;_TexPower;Tex Power;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;13;-1634.31,851.8441;Float;False;Property;_TintColor;Tint Color;0;1;[HDR];Create;True;0;0;False;0;0,0,0,0;4,4,4,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;123;-1353.661,51.64398;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;56;-1617.052,684.8545;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-1387.026,779.6753;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-1142.646,45.30453;Float;True;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;59;-1351.387,1168.846;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1116.597,1073.291;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;132;-1041.002,727.9747;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;26;-434.4309,1073.666;Float;True;27;OpacityMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;133;-578.0134,620.8227;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;88;-96.20927,1066.968;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;134;-587.4667,811.3622;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;51;63.83646,722.5021;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Cutout/CutoutAlignment;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;Transparent;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;#pragma surface surf Unlit keepalpha noshadow alpha:fade;False;;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;43;0;15;0
WireConnection;43;1;46;3
WireConnection;96;1;78;1
WireConnection;96;0;78;2
WireConnection;79;0;96;0
WireConnection;79;1;43;0
WireConnection;62;0;61;0
WireConnection;62;2;64;0
WireConnection;62;1;65;2
WireConnection;80;0;79;0
WireConnection;128;0;80;0
WireConnection;128;1;129;0
WireConnection;12;1;62;0
WireConnection;126;0;12;1
WireConnection;126;1;130;0
WireConnection;103;0;128;0
WireConnection;81;0;128;0
WireConnection;81;1;82;0
WireConnection;81;2;83;0
WireConnection;19;0;126;0
WireConnection;19;1;81;0
WireConnection;131;0;103;0
WireConnection;123;0;19;0
WireConnection;123;1;131;0
WireConnection;56;0;31;0
WireConnection;56;1;57;0
WireConnection;75;0;56;0
WireConnection;75;1;13;0
WireConnection;27;0;123;0
WireConnection;18;0;75;0
WireConnection;18;1;59;0
WireConnection;132;0;31;4
WireConnection;133;0;18;0
WireConnection;88;0;26;0
WireConnection;134;0;132;0
WireConnection;134;1;59;4
WireConnection;51;2;133;0
WireConnection;51;9;134;0
WireConnection;51;10;88;0
ASEEND*/
//CHKSM=95C229AD4D6C31649F1F37CD0B1A287632158112
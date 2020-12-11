// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VegetationShader"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[Header(Out or In Brume)]_Out_or_InBrume("Out_or_InBrume?", Range( 0 , 1)) = 0
		[Header(Textures)]_Object_Albedo_Texture("Object_Albedo_Texture", 2D) = "white" {}
		_Object_Alpha_Texture("Object_Alpha_Texture", 2D) = "white" {}
		[Header(Other Properties)]_Opacity("Opacity?", Range( 0 , 1)) = 1
		_CustomAlphaMask("CustomAlphaMask?", Range( 0 , 1)) = 1
		_WindVertexDisplacement("WindVertexDisplacement?", Range( 0 , 1)) = 0
		[Header(Wind)]_Wind_Noise_Texture("Wind_Noise_Texture", 2D) = "white" {}
		_Wind_Texture_Tiling("Wind_Texture_Tiling", Float) = 0.5
		_Wind_Direction("Wind_Direction", Float) = 1
		_Wind_Density("Wind_Density", Float) = 0.2
		_Wind_Strength("Wind_Strength", Float) = 2
		[Header(Wind Wave)]_WindWave_Speed("WindWave_Speed", Vector) = (0.1,0,0,0)
		_WindWave_Min_Speed("WindWave_Min_Speed", Vector) = (0.05,0,0,0)
		_WindWave_Frequency("WindWave_Frequency", Float) = 0
		[Header(Out Brume Color Correction)]_OutBrume_ColorCorrection("OutBrume_ColorCorrection", Color) = (1,1,1,0)
		_ColorNoise_Texture("ColorNoise_Texture", 2D) = "white" {}
		_ColorNoise_Tiling("ColorNoise_Tiling", Float) = 0
		_ColorNoise_Contrast("ColorNoise_Contrast", Float) = 0
		_ColorNoise_Power("ColorNoise_Power", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform sampler2D _Wind_Noise_Texture;
		uniform float _Wind_Texture_Tiling;
		uniform float _WindWave_Frequency;
		uniform float2 _WindWave_Speed;
		uniform float2 _WindWave_Min_Speed;
		uniform float _Wind_Density;
		uniform float _Wind_Strength;
		uniform float _Wind_Direction;
		uniform float _WindVertexDisplacement;
		uniform float _Out_or_InBrume;
		uniform sampler2D _Object_Albedo_Texture;
		uniform float4 _Object_Albedo_Texture_ST;
		uniform float4 _OutBrume_ColorCorrection;
		uniform float _ColorNoise_Contrast;
		uniform sampler2D _ColorNoise_Texture;
		uniform float _ColorNoise_Tiling;
		uniform float _ColorNoise_Power;
		uniform sampler2D _Object_Alpha_Texture;
		uniform float4 _Object_Alpha_Texture_ST;
		uniform float _CustomAlphaMask;
		uniform float _Opacity;
		uniform float _Cutoff = 0.5;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 temp_cast_0 = (0.0).xx;
			float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner10 = ( ( ( _CosTime.w + _Time.y ) * _WindWave_Frequency ) * _WindWave_Speed + ase_worldPos.xy);
			float2 panner9 = ( 1.0 * _Time.y * _WindWave_Min_Speed + ase_worldPos.xy);
			float2 uv_TexCoord17 = v.texcoord.xy * temp_cast_1 + ( panner10 + panner9 );
			float4 temp_cast_4 = (( _Wind_Density * _SinTime.w )).xxxx;
			float4 temp_cast_5 = (0.0).xxxx;
			float4 lerpResult124 = lerp( ( ( tex2Dlod( _Wind_Noise_Texture, float4( uv_TexCoord17, 0, 0.0) ) - temp_cast_4 ) * _Wind_Strength ) , temp_cast_5 , v.color.r);
			float3 worldToObjDir127 = mul( unity_WorldToObject, float4( lerpResult124.rgb, 0 ) ).xyz;
			float cos137 = cos( _Wind_Direction );
			float sin137 = sin( _Wind_Direction );
			float2 rotator137 = mul( worldToObjDir127.xy - float2( 0,0 ) , float2x2( cos137 , -sin137 , sin137 , cos137 )) + float2( 0,0 );
			float2 WindVertexDisplacement32 = rotator137;
			float2 lerpResult50 = lerp( temp_cast_0 , WindVertexDisplacement32 , _WindVertexDisplacement);
			float2 temp_cast_8 = (0.0).xx;
			float2 lerpResult162 = lerp( lerpResult50 , temp_cast_8 , _Out_or_InBrume);
			v.vertex.xyz += float3( lerpResult162 ,  0.0 );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Object_Albedo_Texture = i.uv_texcoord * _Object_Albedo_Texture_ST.xy + _Object_Albedo_Texture_ST.zw;
			float4 tex2DNode35 = tex2D( _Object_Albedo_Texture, uv_Object_Albedo_Texture );
			float4 Object_Albedo_Texture37 = tex2DNode35;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 EndOutBrume54 = ( Object_Albedo_Texture37 * ( _OutBrume_ColorCorrection * ( CalculateContrast(_ColorNoise_Contrast,tex2D( _ColorNoise_Texture, ( (ase_screenPosNorm).xy * _ColorNoise_Tiling ) )) * _ColorNoise_Power ) ) );
			float grayscale59 = Luminance(Object_Albedo_Texture37.rgb);
			float EndInBrume53 = grayscale59;
			float4 temp_cast_1 = (EndInBrume53).xxxx;
			float4 lerpResult42 = lerp( EndOutBrume54 , temp_cast_1 , _Out_or_InBrume);
			o.Emission = lerpResult42.rgb;
			o.Alpha = 1;
			float4 temp_cast_3 = (tex2DNode35.a).xxxx;
			float2 uv_Object_Alpha_Texture = i.uv_texcoord * _Object_Alpha_Texture_ST.xy + _Object_Alpha_Texture_ST.zw;
			float4 lerpResult61 = lerp( temp_cast_3 , tex2D( _Object_Alpha_Texture, uv_Object_Alpha_Texture ) , _CustomAlphaMask);
			float4 Object_Opacity_Texture29 = lerpResult61;
			float4 temp_cast_4 = (1.0).xxxx;
			float4 lerpResult33 = lerp( Object_Opacity_Texture29 , temp_cast_4 , _Opacity);
			float4 Opacity34 = lerpResult33;
			clip( Opacity34.r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
0;0;1920;1019;849.7722;1831.99;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-5149.841,-1672.024;Inherit;False;4722.003;799.1631;VertexColor WindDisplacement;29;23;22;21;20;19;17;15;18;16;13;11;12;9;10;7;6;8;5;4;2;3;122;128;125;126;124;127;32;137;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosTime;3;-5065.299,-1396.074;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2;-5082.949,-1194.205;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-4902.949,-1245.205;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4691.008,-1151.774;Inherit;False;Property;_WindWave_Frequency;WindWave_Frequency;14;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-4455.962,-1233.299;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;128;-4118.385,-1213.021;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;122;-4561.71,-1531.114;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;7;-4577.145,-1386.356;Inherit;False;Property;_WindWave_Speed;WindWave_Speed;12;0;Create;True;0;0;False;1;Header(Wind Wave);False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;8;-4163.807,-1054.542;Inherit;False;Property;_WindWave_Min_Speed;WindWave_Min_Speed;13;0;Create;True;0;0;False;0;False;0.05,0;0.05,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;9;-3907.192,-1072.658;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;10;-4319.349,-1405.483;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;64;-5152.946,-435.5862;Inherit;False;2069.213;678.4071;OutBrume;15;149;161;160;158;146;54;56;140;55;57;155;157;154;151;156;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3549.423,-1403.651;Inherit;False;Property;_Wind_Texture_Tiling;Wind_Texture_Tiling;8;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-3645.932,-1244.621;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2904.087,-1218.403;Inherit;False;Property;_Wind_Density;Wind_Density;10;0;Create;True;0;0;False;0;False;0.2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3150.994,-1613.266;Inherit;True;Property;_Wind_Noise_Texture;Wind_Noise_Texture;7;0;Create;True;0;0;False;1;Header(Wind);False;1cb5d7a8b79999d4b8356e740bbf6667;0fe9101c6b6e1124b90b120ceebd6cba;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-3237.723,-1394.441;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinTimeNode;15;-2872.909,-1126.044;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;158;-5041.962,-74.42669;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-2907.994,-1423.265;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2704.495,-1163.2;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-4838.941,19.30506;Inherit;False;Property;_ColorNoise_Tiling;ColorNoise_Tiling;17;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;160;-4817.962,-74.42669;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;-4609.962,-74.42669;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2241.843,-1346.88;Inherit;False;Property;_Wind_Strength;Wind_Strength;11;0;Create;True;0;0;False;0;False;2;0.002;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;146;-4691.266,-334.9175;Inherit;True;Property;_ColorNoise_Texture;ColorNoise_Texture;16;0;Create;True;0;0;False;0;False;None;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-2444.936,-1415.397;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-1791.217,-1322.528;Inherit;False;Constant;_Float0;Float 0;67;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;151;-4429.181,-102.5519;Inherit;True;Property;_TextureSample0;Texture Sample 0;18;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;65;-5144.591,-2332.431;Inherit;False;954.9209;631.1599;Textures;6;35;60;62;61;29;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-4226.617,100.8933;Inherit;False;Property;_ColorNoise_Contrast;ColorNoise_Contrast;18;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2066.842,-1414.88;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;126;-1807.667,-1228.823;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-4922.034,-1817.268;Inherit;False;Property;_CustomAlphaMask;CustomAlphaMask?;5;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-5094.591,-2282.431;Inherit;True;Property;_Object_Albedo_Texture;Object_Albedo_Texture;2;0;Create;True;0;0;False;1;Header(Textures);False;-1;None;0c342c2328160f24ca1c2798a9eb04db;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;154;-3993.617,-46.1065;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;60;-5088.035,-2069.271;Inherit;True;Property;_Object_Alpha_Texture;Object_Alpha_Texture;3;0;Create;True;0;0;False;0;False;-1;None;0c342c2328160f24ca1c2798a9eb04db;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;157;-3985.617,97.89333;Inherit;False;Property;_ColorNoise_Power;ColorNoise_Power;19;0;Create;True;0;0;False;0;False;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;124;-1593.311,-1413.493;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-1266.694,-1199.261;Inherit;False;Property;_Wind_Direction;Wind_Direction;9;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;63;-4279.484,-848.2383;Inherit;False;828.718;168.3489;InBrume;3;58;59;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;61;-4623.029,-2022.27;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TransformDirectionNode;127;-1412.326,-1418.927;Inherit;False;World;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-4682.577,-2281.107;Inherit;False;Object_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;-3977.055,-300.4942;Inherit;False;Property;_OutBrume_ColorCorrection;OutBrume_ColorCorrection;15;0;Create;True;0;0;False;1;Header(Out Brume Color Correction);False;1,1,1,0;0.5647059,0.3633637,0.2392156,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-3796.617,-48.10649;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-4462.667,-2027.951;Inherit;False;Object_Opacity_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-4229.484,-795.8893;Inherit;False;37;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-3963.324,-385.5862;Inherit;False;37;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-3640.716,-195.1142;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotatorNode;137;-1001.116,-1383.15;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;26;-5148.834,-845.3911;Inherit;False;836.2999;385.9216;Opacity;5;34;33;31;28;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-5080.474,-573.2869;Inherit;False;Property;_Opacity;Opacity?;4;0;Create;True;0;0;False;1;Header(Other Properties);False;1;0.38;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-5058.546,-765.6711;Inherit;False;29;Object_Opacity_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-4996.894,-666.1949;Inherit;False;Constant;_Float6;Float 6;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-3461.88,-380.5531;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-804.7217,-1387.579;Inherit;False;WindVertexDisplacement;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;66;251.8418,-1699.96;Inherit;False;1069.663;1108.434;Final Output;11;40;0;52;42;50;48;46;38;39;47;162;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCGrayscale;59;-3965.827,-796.5134;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-3674.767,-798.2383;Inherit;False;EndInBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-4739.007,-710.8199;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-3306.152,-384.2971;Inherit;False;EndOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;47;298.7078,-798.925;Inherit;False;Property;_WindVertexDisplacement;WindVertexDisplacement?;6;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;297.0486,-887.427;Inherit;False;32;WindVertexDisplacement;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;46;412.6608,-979.248;Inherit;False;Constant;_Float4;Float 4;68;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;371.4417,-1613.56;Inherit;False;54;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;382.8228,-1533.159;Inherit;False;53;EndInBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;345.3418,-1445.696;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;1;0;Create;False;0;0;False;1;Header(Out or In Brume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;50;621.4645,-907.4449;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-4536.535,-715.846;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;648.0288,-1609.115;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;645.6074,-1309.06;Inherit;False;34;Opacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;162;845.0787,-1054.834;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1030.105,-1481.842;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;VegetationShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;4
WireConnection;5;1;2;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;9;0;128;0
WireConnection;9;2;8;0
WireConnection;10;0;122;0
WireConnection;10;2;7;0
WireConnection;10;1;6;0
WireConnection;12;0;10;0
WireConnection;12;1;9;0
WireConnection;17;0;13;0
WireConnection;17;1;12;0
WireConnection;20;0;18;0
WireConnection;20;1;17;0
WireConnection;19;0;16;0
WireConnection;19;1;15;4
WireConnection;160;0;158;0
WireConnection;161;0;160;0
WireConnection;161;1;149;0
WireConnection;21;0;20;0
WireConnection;21;1;19;0
WireConnection;151;0;146;0
WireConnection;151;1;161;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;154;1;151;0
WireConnection;154;0;156;0
WireConnection;124;0;23;0
WireConnection;124;1;125;0
WireConnection;124;2;126;1
WireConnection;61;0;35;4
WireConnection;61;1;60;0
WireConnection;61;2;62;0
WireConnection;127;0;124;0
WireConnection;37;0;35;0
WireConnection;155;0;154;0
WireConnection;155;1;157;0
WireConnection;29;0;61;0
WireConnection;140;0;57;0
WireConnection;140;1;155;0
WireConnection;137;0;127;0
WireConnection;137;2;11;0
WireConnection;56;0;55;0
WireConnection;56;1;140;0
WireConnection;32;0;137;0
WireConnection;59;0;58;0
WireConnection;53;0;59;0
WireConnection;33;0;36;0
WireConnection;33;1;31;0
WireConnection;33;2;28;0
WireConnection;54;0;56;0
WireConnection;50;0;46;0
WireConnection;50;1;48;0
WireConnection;50;2;47;0
WireConnection;34;0;33;0
WireConnection;42;0;39;0
WireConnection;42;1;38;0
WireConnection;42;2;40;0
WireConnection;162;0;50;0
WireConnection;162;1;46;0
WireConnection;162;2;40;0
WireConnection;0;2;42;0
WireConnection;0;10;52;0
WireConnection;0;11;162;0
ASEEND*/
//CHKSM=8F942D5BF95A4E5669584AF6BA2B66B23EAB023C
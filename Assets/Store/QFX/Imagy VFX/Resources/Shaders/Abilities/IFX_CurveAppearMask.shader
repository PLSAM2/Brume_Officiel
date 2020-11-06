// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Abilities/CurveAppearMask"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_TimeScale("TimeScale", Float) = 0
		_MaskAppearProgress("Mask Appear Progress", Float) = 0
		_FlowMap("Flow Map", 2D) = "white" {}
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_FlowStrength("Flow Strength", Float) = 0
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_NoiseSpeed("Noise Speed", Vector) = (0,0,0,0)
		_Size("Size", Float) = -0.24
		_MainTex("Main Tex", 2D) = "white" {}
		_FlowMapSpeed("Flow Map Speed", Vector) = (0,0,0,0)
		_MaskMap("Mask Map", 2D) = "white" {}
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
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float3 uv_tex3coord;
		};

		uniform float4 _TintColor;
		uniform sampler2D _MainTex;
		uniform sampler2D _FlowMap;
		uniform float _TimeScale;
		uniform float2 _FlowMapSpeed;
		uniform float4 _FlowMap_ST;
		uniform float _FlowStrength;
		uniform sampler2D _MaskMap;
		uniform float4 _MaskMap_ST;
		uniform sampler2D _NoiseTex;
		uniform float2 _NoiseSpeed;
		uniform float4 _NoiseTex_ST;
		uniform float _MaskAppearProgress;
		uniform float _Size;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime6 = _Time.y * _TimeScale;
			float time7 = mulTime6;
			float2 uv_FlowMap = i.uv_texcoord * _FlowMap_ST.xy + _FlowMap_ST.zw;
			float2 panner9 = ( time7 * _FlowMapSpeed + uv_FlowMap);
			float2 myVarName171 = ( ( ( (tex2D( _FlowMap, panner9 )).rg + -0.5 ) * 2.0 ) * _FlowStrength * uv_FlowMap.x * ( 1.0 - uv_FlowMap.x ) );
			float4 tex2DNode134 = tex2D( _MainTex, ( ( i.uv_texcoord + myVarName171 ) - float2( 0,0 ) ) );
			o.Emission = ( _TintColor * tex2DNode134.r * i.vertexColor ).rgb;
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST.xy + _MaskMap_ST.zw;
			o.Alpha = saturate( ( tex2DNode134.r * i.vertexColor.a * tex2D( _MaskMap, uv_MaskMap ) ) ).r;
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner217 = ( _Time.y * _NoiseSpeed + uv_NoiseTex);
			float4 temp_cast_2 = (( abs( ( (-0.5 + (i.uv_texcoord.x - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) + ( 1.0 - ( _MaskAppearProgress + i.uv_tex3coord.z ) ) ) ) - _Size )).xxxx;
			clip( ( tex2D( _NoiseTex, panner217 ) - temp_cast_2 ).r - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
443;307;1278;710;23.4689;973.7311;1.832574;True;False
Node;AmplifyShaderEditor.RangedFloatNode;5;-2866.342,-742.2021;Float;False;Property;_TimeScale;TimeScale;1;0;Create;True;0;0;False;0;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-2712.214,-735.9554;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;7;-2528.977,-741.0784;Float;False;time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-2729.753,-1038.651;Float;False;0;12;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;61;-2727.779,-901.9193;Float;False;Property;_FlowMapSpeed;Flow Map Speed;10;0;Create;True;0;0;False;0;0,0;1,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;12;-2367.993,-1180.392;Float;True;Property;_FlowMap;Flow Map;3;0;Create;True;0;0;False;0;None;140c5b15ccac91a4fb58b5ea4666c02f;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;9;-2228.935,-911.1255;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-1,-0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;11;-2023.506,-939.2356;Float;True;Property;_1;1;2;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;184;-1503.772,-433.7308;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;13;-1715.132,-939.1128;Float;True;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;14;-1468.592,-932.7054;Float;True;ConstantBiasScale;-1;;11;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1467.405,-702.7067;Float;False;Property;_FlowStrength;Flow Strength;5;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;186;-1217.504,-646.7477;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;185;-1399.762,-519.3441;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1190.954,-932.7054;Float;False;4;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;221;-639.6815,740.6031;Float;False;0;-1;3;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;171;-995.9803,-936.8252;Float;True;myVarName;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-637.4958,605.4783;Float;False;Property;_MaskAppearProgress;Mask Appear Progress;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-204.9531,-600.929;Float;False;171;myVarName;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;128;-212.7076,-723.0899;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;222;-521.8144,309.5983;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;223;-370.6815,700.6031;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;224;-185.5686,613.5243;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;173;90.95375,-674.1543;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;225;-224.6682,333.1203;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;176;447.2819,-673.4046;Float;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;216;-78.47212,200.625;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;214;-208.8543,-47.74101;Float;False;0;218;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;215;-208.8543,82.50597;Float;False;Property;_NoiseSpeed;Noise Speed;7;0;Create;True;0;0;False;0;0,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;226;165.0269,333.1162;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;134;637.2559,-690.9435;Float;True;Property;_MainTex;Main Tex;9;0;Create;True;0;0;False;0;None;67445778cc9abb1418e25e66352fdd84;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;217;191.0505,66.40404;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.AbsOpNode;228;607.5715,330.5303;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;710.915,592.8622;Float;False;Property;_Size;Size;8;0;Create;True;0;0;False;0;-0.24;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;49;715.5773,-396.7781;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;230;673.3548,-195.7891;Float;True;Property;_MaskMap;Mask Map;11;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;218;466.799,33.79096;Float;True;Property;_NoiseTex;Noise Tex;4;0;Create;True;0;0;False;0;None;163632276e446414db3976d5befc6048;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;229;975.897,394.1263;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;1125.874,-257.4006;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;53;762.3691,-1096.175;Float;False;Property;_TintColor;Tint Color;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;1144.995,-906.0751;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;75;1353.454,-256.6755;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;219;1173.661,96.30197;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;1720.559,-479.6327;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Abilities/CurveAppearMask;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;0
WireConnection;7;0;6;0
WireConnection;9;0;4;0
WireConnection;9;2;61;0
WireConnection;9;1;7;0
WireConnection;11;0;12;0
WireConnection;11;1;9;0
WireConnection;184;0;4;1
WireConnection;13;0;11;0
WireConnection;14;3;13;0
WireConnection;186;0;184;0
WireConnection;185;0;4;1
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;15;2;185;0
WireConnection;15;3;186;0
WireConnection;171;0;15;0
WireConnection;223;0;220;0
WireConnection;223;1;221;3
WireConnection;224;0;223;0
WireConnection;173;0;128;0
WireConnection;173;1;172;0
WireConnection;225;0;222;1
WireConnection;176;0;173;0
WireConnection;226;0;225;0
WireConnection;226;1;224;0
WireConnection;134;1;176;0
WireConnection;217;0;214;0
WireConnection;217;2;215;0
WireConnection;217;1;216;2
WireConnection;228;0;226;0
WireConnection;218;1;217;0
WireConnection;229;0;228;0
WireConnection;229;1;227;0
WireConnection;72;0;134;1
WireConnection;72;1;49;4
WireConnection;72;2;230;0
WireConnection;55;0;53;0
WireConnection;55;1;134;1
WireConnection;55;2;49;0
WireConnection;75;0;72;0
WireConnection;219;0;218;0
WireConnection;219;1;229;0
WireConnection;2;2;55;0
WireConnection;2;9;75;0
WireConnection;2;10;219;0
ASEEND*/
//CHKSM=1E46967F25ECC6F0269FF6338E1E2E855D29B115
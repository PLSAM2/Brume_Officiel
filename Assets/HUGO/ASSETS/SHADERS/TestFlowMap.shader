// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TestFlowMap"
{
	Properties
	{
		_Size("Size", Range( 0 , 10)) = 1
		_Texture1("Texture 1", 2D) = "white" {}
		_FlowStrength("FlowStrength", Float) = 0.5
		_FlowSpeed("FlowSpeed", Float) = 0.2
		_FlowTexture("FlowTexture", 2D) = "white" {}
		_FlowTiling("FlowTiling", Float) = 0.1
		_FlowDirection("FlowDirection", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture1;
		uniform sampler2D _FlowTexture;
		uniform float _FlowTiling;
		uniform float _Size;
		uniform float2 _FlowDirection;
		uniform float _FlowStrength;
		uniform float _FlowSpeed;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_cast_0 = (1.0).xx;
			float2 temp_cast_1 = (_FlowTiling).xx;
			float2 uv_TexCoord76 = i.uv_texcoord * temp_cast_1;
			float2 temp_output_4_0_g2 = (( uv_TexCoord76 / _Size )).xy;
			float2 temp_output_41_0_g2 = ( _FlowDirection + 0.5 );
			float2 temp_cast_2 = (_FlowStrength).xx;
			float2 temp_output_17_0_g2 = temp_cast_2;
			float mulTime22_g2 = _Time.y * _FlowSpeed;
			float temp_output_27_0_g2 = frac( mulTime22_g2 );
			float2 temp_output_11_0_g2 = ( temp_output_4_0_g2 + ( temp_output_41_0_g2 * temp_output_17_0_g2 * temp_output_27_0_g2 ) );
			float2 temp_output_12_0_g2 = ( temp_output_4_0_g2 + ( temp_output_41_0_g2 * temp_output_17_0_g2 * frac( ( mulTime22_g2 + 0.5 ) ) ) );
			float3 lerpResult9_g2 = lerp( UnpackNormal( tex2D( _FlowTexture, temp_output_11_0_g2 ) ) , UnpackNormal( tex2D( _FlowTexture, temp_output_12_0_g2 ) ) , ( abs( ( temp_output_27_0_g2 - 0.5 ) ) / 0.5 ));
			float2 uv_TexCoord79 = i.uv_texcoord * temp_cast_0 + lerpResult9_g2.xy;
			o.Albedo = tex2D( _Texture1, uv_TexCoord79 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
0;0;1920;1019;8623.611;2546.712;5.950863;True;False
Node;AmplifyShaderEditor.RangedFloatNode;81;-1081.915,-57.42316;Inherit;False;Property;_FlowTiling;FlowTiling;13;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;72;-904.5577,58.94709;Inherit;False;Property;_FlowDirection;FlowDirection;14;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-918.0947,-76.02322;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-903.4359,188.5447;Inherit;False;Property;_FlowStrength;FlowStrength;10;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-902.5577,262.9472;Inherit;False;Property;_FlowSpeed;FlowSpeed;11;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;83;-936.2877,-311.0471;Inherit;True;Property;_FlowTexture;FlowTexture;12;0;Create;True;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;64;-640.4136,-81.60307;Inherit;True;Flow;1;;2;acad10cc8145e1f4eb8042bebe2d9a42;2,50,1,51,1;5;5;SAMPLER2D;;False;2;FLOAT2;0,0;False;18;FLOAT2;0,0;False;17;FLOAT2;1,1;False;24;FLOAT;0.2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-471.6593,-221.9619;Inherit;False;Constant;_Float3;Float 3;13;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-3447.319,83.88966;Inherit;False;1684.125;840.9902;Time;18;56;52;55;54;57;60;39;41;40;20;17;38;53;9;11;12;10;61;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-308.1289,-240.2083;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;74;-344.3725,-618.6896;Inherit;True;Property;_Texture1;Texture 1;7;0;Create;True;0;0;False;0;False;6395db2a80729484b931cff6723fa89f;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;34;-3445.86,-1211.45;Inherit;False;657.4829;209;DiffuseTiling;3;29;30;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;35;-3454.326,940.0665;Inherit;False;1272.327;773.3026;Diffuse;10;24;50;49;26;47;27;25;58;59;63;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-3445.296,-982.1207;Inherit;False;2225.645;1024.616;FlowMapUV;13;23;22;19;21;3;18;15;16;1;37;36;46;44;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;45;-2126.831,-435.4184;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-2093.496,-163.6852;Inherit;True;31;DiffuseTiling;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-2377.215,161.96;Inherit;False;TimeA;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3201.319,163.8896;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-3248.377,-1161.45;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2183.54,397.9998;Inherit;False;TimeB;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;46;-2453.193,-303.6345;Inherit;False;41;TimeB;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;21;-2425.083,-738.0414;Inherit;False;Overlay;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-2461.534,-848.2845;Inherit;False;20;TimeA;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-3012.377,-1141.45;Inherit;False;DiffuseTiling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-1470.362,-916.5394;Inherit;False;FlowA;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3378.319,212.8899;Inherit;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;9;-3062.301,163.8236;Inherit;True;Sawtooth Wave;-1;;1;289adb816c3ac6d489f255fc3caf5016;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;18;-2812.435,-930.0734;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-2493.763,1366.881;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;75;-52.21182,-427.8172;Inherit;True;Property;_TextureSample4;Texture Sample 4;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;28;-206.9176,-5.03077;Inherit;False;24;Diffuse;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;61;-2590.782,406.3542;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;40;-2362.169,403.053;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;3;-2786.039,-743.4357;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NegateNode;17;-2555.845,167.0132;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;56;-2147.326,659.2306;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-3102.719,1331.301;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;55;-2269.326,660.2306;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-3395.86,-1142.264;Inherit;False;Property;_Tiling;Tiling;8;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-2968.712,1627.675;Inherit;False;Property;_Float1;Float 1;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-3397.319,133.8896;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;25;-3404.326,990.0665;Inherit;True;Property;_Diffuse;Diffuse;6;0;Create;True;0;0;False;0;False;6395db2a80729484b931cff6723fa89f;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;37;-2084.748,-655.3082;Inherit;True;31;DiffuseTiling;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;50;-2587.766,1193.211;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;58;-2985.73,1541.738;Inherit;False;57;BlendTime;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;52;-2627.985,658.7546;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-3100.247,1077.774;Inherit;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;38;-3062.406,408.1877;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-3395.296,-833.8427;Inherit;True;Property;_FlowMap;FlowMap;0;0;Create;True;0;0;False;0;False;-1;f4a8a61c2f245df47a0743cdab8f52da;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;27;-3388.48,1181.769;Inherit;True;23;FlowA;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;15;-3036.331,-746.8865;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;60;-2853.742,164.7679;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-3263.227,558.2303;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;39;-2862.002,405.7595;Inherit;True;Sawtooth Wave;-1;;1;289adb816c3ac6d489f255fc3caf5016;0;1;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1795.785,-926.5405;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;44;-1479.11,-424.9164;Inherit;False;FlowB;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-3384.819,1463.901;Inherit;True;44;FlowB;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-2403.398,1187.05;Inherit;False;Diffuse;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;22;-2118.083,-927.0414;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-3299.33,-638.8865;Inherit;False;Property;_ContrastFlowMap;ContrastFlowMap;5;0;Create;True;0;0;False;0;False;0.1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;57;-1984.326,653.2306;Inherit;False;BlendTime;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-1804.533,-434.9175;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;54;-2422.326,659.2306;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;290.0002,-421.3;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TestFlowMap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;76;0;81;0
WireConnection;64;5;83;0
WireConnection;64;2;76;0
WireConnection;64;18;72;0
WireConnection;64;17;71;0
WireConnection;64;24;73;0
WireConnection;79;0;80;0
WireConnection;79;1;64;0
WireConnection;45;0;18;0
WireConnection;45;1;21;0
WireConnection;45;2;46;0
WireConnection;20;0;17;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;30;0;29;0
WireConnection;41;0;40;0
WireConnection;21;0;18;0
WireConnection;21;1;3;0
WireConnection;31;0;30;0
WireConnection;23;0;36;0
WireConnection;9;1;11;0
WireConnection;63;0;26;0
WireConnection;63;1;49;0
WireConnection;75;0;74;0
WireConnection;75;1;79;0
WireConnection;61;0;39;0
WireConnection;40;0;61;0
WireConnection;3;0;15;0
WireConnection;17;0;60;0
WireConnection;56;0;55;0
WireConnection;49;0;25;0
WireConnection;49;1;47;0
WireConnection;55;0;54;0
WireConnection;50;0;26;0
WireConnection;50;1;49;0
WireConnection;50;2;58;0
WireConnection;52;0;60;0
WireConnection;52;1;53;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;38;0;11;0
WireConnection;38;2;53;0
WireConnection;15;1;1;0
WireConnection;15;0;16;0
WireConnection;60;0;9;0
WireConnection;39;1;38;0
WireConnection;36;0;22;0
WireConnection;36;1;37;0
WireConnection;44;0;43;0
WireConnection;24;0;50;0
WireConnection;22;0;18;0
WireConnection;22;1;21;0
WireConnection;22;2;19;0
WireConnection;57;0;56;0
WireConnection;43;0;45;0
WireConnection;43;1;42;0
WireConnection;54;0;52;0
WireConnection;0;0;75;0
ASEEND*/
//CHKSM=9C5E6A9A32535349A1539362CB3B745BA8E2CFD0
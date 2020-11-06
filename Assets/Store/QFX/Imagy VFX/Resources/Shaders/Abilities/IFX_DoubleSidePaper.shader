// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Abilities/DoubleSidePaper"
{
	Properties
	{
		[Toggle]_MaskAppearInvert("Mask Appear Invert", Float) = 0
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,1)
		[KeywordEnum(None,X,Y,Z)] _MaskAppearAxis("Mask Appear Axis", Float) = 2
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0
		_MaskAppearProgress("Mask Appear Progress", Float) = -0.03
		_TextureSample0("Dissolve Map", 2D) = "white" {}
		_MaskAppearStrength("Mask Appear Strength", Range( 0 , 1)) = 0.5
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HDR]_Albedo("Albedo", Color) = (0,0,0,0)
		_MainTexBack("Main Tex Back", 2D) = "white" {}
		_MainTexFront("Main Tex Front", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature _MASKAPPEARAXIS_NONE _MASKAPPEARAXIS_X _MASKAPPEARAXIS_Y _MASKAPPEARAXIS_Z
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			half ASEVFace : VFACE;
			float3 worldPos;
		};

		uniform float4 _Albedo;
		uniform sampler2D _MainTexFront;
		uniform float4 _MainTexFront_ST;
		uniform sampler2D _MainTexBack;
		uniform float4 _MainTexBack_ST;
		uniform float _MaskAppearStrength;
		uniform float _MaskAppearInvert;
		uniform float _MaskAppearProgress;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float _DissolveAmount;
		uniform float4 _DissolveColor;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTexFront = i.uv_texcoord * _MainTexFront_ST.xy + _MainTexFront_ST.zw;
			float2 uv_MainTexBack = i.uv_texcoord * _MainTexBack_ST.xy + _MainTexBack_ST.zw;
			float4 switchResult5 = (((i.ASEVFace>0)?(( _Albedo * tex2D( _MainTexFront, uv_MainTexFront ) )):(( _Albedo * tex2D( _MainTexBack, uv_MainTexBack ) ))));
			o.Albedo = switchResult5.rgb;
			float4 temp_cast_1 = (_MaskAppearStrength).xxxx;
			float4 transform24_g32 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_worldPos = i.worldPos;
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 temp_output_7_0_g32 = ( ( lerp(( transform24_g32 - float4( ase_worldPos , 0.0 ) ),( float4( ase_worldPos , 0.0 ) - transform24_g32 ),_MaskAppearInvert) / float4( ase_objectScale , 0.0 ) ) + ( _MaskAppearProgress + tex2D( _TextureSample0, uv_TextureSample0 ).r ) );
			float4 break5_g32 = temp_output_7_0_g32;
			float4 temp_cast_6 = (break5_g32.y).xxxx;
			float4 temp_cast_10 = (break5_g32.x).xxxx;
			float4 temp_cast_11 = (break5_g32.y).xxxx;
			float4 temp_cast_12 = (break5_g32.z).xxxx;
			#if defined(_MASKAPPEARAXIS_NONE)
				float4 staticSwitch6_g32 = temp_output_7_0_g32;
			#elif defined(_MASKAPPEARAXIS_X)
				float4 staticSwitch6_g32 = temp_cast_10;
			#elif defined(_MASKAPPEARAXIS_Y)
				float4 staticSwitch6_g32 = temp_cast_6;
			#elif defined(_MASKAPPEARAXIS_Z)
				float4 staticSwitch6_g32 = temp_cast_12;
			#else
				float4 staticSwitch6_g32 = temp_cast_6;
			#endif
			float4 temp_cast_13 = (0.0).xxxx;
			float4 smoothstepResult31_g32 = smoothstep( float4( 0,0,0,0 ) , temp_cast_1 , ( staticSwitch6_g32 - temp_cast_13 ));
			float4 temp_output_17_0_g3 = smoothstepResult31_g32;
			float4 mask_appear6_g3 = temp_output_17_0_g3;
			float4 temp_cast_15 = (_DissolveAmount).xxxx;
			float4 dissolve_color5_g3 = ( _DissolveColor * temp_output_17_0_g3 );
			o.Emission = (( mask_appear6_g3 > temp_cast_15 ) ? float4( 0,0,0,0 ) :  dissolve_color5_g3 ).rgb;
			o.Alpha = 1;
			clip( mask_appear6_g3.x - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16100
241;244;1084;799;956.7885;77.30756;1.684725;True;False
Node;AmplifyShaderEditor.ColorNode;2;-555.5587,28.89114;Float;False;Property;_Albedo;Albedo;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1,1,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-557.2676,201.4896;Float;True;Property;_MainTexFront;Main Tex Front;10;0;Create;True;0;0;False;0;None;83e349c7bcb87a84291c70e9b5d13fb3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-553.8409,401.0917;Float;True;Property;_MainTexBack;Main Tex Back;8;0;Create;True;0;0;False;0;None;3075991c0b817f54b94ce68bb803a367;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-172.3141,143.4839;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;-179.2881,336.2924;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwitchByFaceNode;5;107.7914,181.4023;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;8;-546.7968,950.2321;Float;False;Property;_EmissionColor;Emission Color;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.1034478,3,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwitchByFaceNode;10;39.96709,687.6307;Float;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;16;297.2839,669.2367;Float;False;QFX Get Simple Dissolve;0;;3;614d23a5ed725f9478c6a2f099c21623;0;1;10;COLOR;0,0,0,0;False;2;COLOR;0;FLOAT4;12
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-114.7589,596.7392;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-555.7893,613.201;Float;False;Property;_EmissionPower;Emission Power;9;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-592.7944,705.5813;Float;True;Property;_Emission;Emission;7;0;Create;True;0;0;False;0;None;3075991c0b817f54b94ce68bb803a367;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-218.6106,695.4665;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;836.7379,452.6369;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;QFX/IFX/Abilities/DoubleSidePaper;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;4;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;4;1;3;0
WireConnection;21;0;2;0
WireConnection;21;1;6;0
WireConnection;5;0;4;0
WireConnection;5;1;21;0
WireConnection;10;0;20;0
WireConnection;20;0;19;0
WireConnection;20;1;9;0
WireConnection;9;0;7;0
WireConnection;9;1;8;0
WireConnection;0;0;5;0
WireConnection;0;2;16;0
WireConnection;0;10;16;12
ASEEND*/
//CHKSM=F86E4275C0E1064F95A91104F9B791D7DB3AF3F3
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Decal/DepthDecalCutout"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_Size("Size", Range( 0 , 1)) = 1
		_AlphaCutout("Alpha Cutout", Float) = 0
		_RampFalloff("Ramp Falloff", Range( 0.01 , 6)) = 5
		[Toggle]_BlendMask("Blend Mask", Float) = 0
		_MainTex("Main Tex", 2D) = "white" {}
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_TexPower("Tex Power", Float) = 1
		_MaskPower("Mask Power", Range( 1 , 8)) = 1
		_NoiseSpeed("Noise Speed", Vector) = (0.5,0.5,0,0)
		_MaskMap("Mask Map", 2D) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
		};

		uniform float4 _TintColor;
		uniform sampler2D _MainTex;
		uniform sampler2D _CameraDepthTexture;
		uniform float _BlendMask;
		uniform float _Size;
		uniform float _RampFalloff;
		uniform sampler2D _MaskMap;
		uniform float _MaskPower;
		uniform float _TexPower;
		uniform sampler2D _NoiseTex;
		uniform float2 _NoiseSpeed;
		uniform float _AlphaCutout;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float4 tex2DNode36_g1 = tex2D( _CameraDepthTexture, ase_screenPosNorm.xy );
			#ifdef UNITY_REVERSED_Z
				float staticSwitch38_g1 = ( 1.0 - tex2DNode36_g1.r );
			#else
				float staticSwitch38_g1 = tex2DNode36_g1.r;
			#endif
			float3 appendResult39_g1 = (float3(ase_screenPosNorm.x , ase_screenPosNorm.y , staticSwitch38_g1));
			float4 appendResult42_g1 = (float4((appendResult39_g1*2.0 + -1.0) , 1.0));
			float4 temp_output_43_0_g1 = mul( unity_CameraInvProjection, appendResult42_g1 );
			float4 appendResult49_g1 = (float4(( ( (temp_output_43_0_g1).xyz / (temp_output_43_0_g1).w ) * float3( 1,1,-1 ) ) , 1.0));
			float4 temp_output_244_0 = mul( unity_CameraToWorld, appendResult49_g1 );
			float4 uv312 = ( mul( unity_WorldToObject, temp_output_244_0 ) + 0.5 );
			float4 tex2DNode222 = tex2D( _MainTex, uv312.xy, float2( 0,0 ), float2( 0,0 ) );
			float3 temp_output_281_0 = (( _TintColor * tex2DNode222 )).rgb;
			o.Emission = temp_output_281_0;
			float4 transform114 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float4 tex2DNode277 = tex2D( _MaskMap, uv312.xy );
			float temp_output_278_0 = ( ( 1.0 - saturate( pow( ( length( abs( (( transform114 - temp_output_244_0 )).xyz ) ) / ( max( max( ase_objectScale.x , ase_objectScale.y ) , ase_objectScale.z ) * 0.5 * _Size ) ) , _RampFalloff ) ) ) * _TintColor.a * pow( tex2DNode277.r , _MaskPower ) );
			float3 temp_cast_3 = (temp_output_278_0).xxx;
			o.Alpha = lerp(temp_cast_3,( temp_output_281_0 * temp_output_278_0 ),_BlendMask).x;
			float main_r317 = tex2DNode222.r;
			float2 panner322 = ( _Time.y * _NoiseSpeed + uv312.xy);
			float OpacityMask301 = ( tex2DNode277.a * ( pow( main_r317 , _TexPower ) - ( tex2D( _NoiseTex, panner322 ).r - ( 1.0 - _AlphaCutout ) ) ) );
			clip( OpacityMask301 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
235;637;1100;391;-3647.268;-420.7635;1.009616;True;False
Node;AmplifyShaderEditor.CommentaryNode;316;1363.25,33.80344;Float;False;1077.075;368.6297;UV;6;312;249;250;248;274;244;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;219;1362.035,448.4351;Float;False;339.352;234.4789;Object pivot position in world space;1;114;;0,0,0,1;0;0
Node;AmplifyShaderEditor.FunctionNode;244;1391.482,253.8999;Float;False;Reconstruct World Position From Depth;1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;274;1501.073,110.5258;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.CommentaryNode;220;1675.14,720.5161;Float;False;527.0399;229;Make the effect scale with the sphere;3;152;154;155;;0,0,0,1;0;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;114;1412.035,498.4351;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;1787.361,167.0437;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;250;1850.056,266.7348;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;113;1850.315,480.0514;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectScaleNode;152;1725.14,770.5161;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;249;2015.493,173.228;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;154;1923.767,770.5155;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;160;2019.684,492.7632;Float;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;2158.523,166.2019;Float;False;uv;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.AbsOpNode;158;2253.102,498.1834;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;155;2053.176,817.9933;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;1922.201,1004.83;Float;False;Property;_Size;Size;4;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;313;2613.684,239.8039;Float;False;312;uv;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TimeNode;321;1235.67,1416.877;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;314;1266.218,1165.224;Float;False;312;uv;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;2254.979,824.6212;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;159;2400,496;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;222;2829.111,215.667;Float;True;Property;_MainTex;Main Tex;8;0;Create;True;0;0;False;0;None;84875002b328bcb45a8f0fb9fa37aa2a;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;320;1255.803,1297.048;Float;False;Property;_NoiseSpeed;Noise Speed;12;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;317;3142.263,287.3997;Float;False;main_r;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;2512,672;Float;False;Property;_RampFalloff;Ramp Falloff;6;0;Create;True;0;0;False;0;5;6;0.01;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;148;2560,496;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;1716.086,1438.569;Float;False;Property;_AlphaCutout;Alpha Cutout;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;322;1546.797,1249.14;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;163;2736,496;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;2652.77,777.8351;Float;False;312;uv;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;288;1715.152,1221.023;Float;True;Property;_NoiseTex;Noise Tex;3;0;Create;True;0;0;False;0;None;357928dd8c8088440b4662373bd09d7a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;318;2269.823,1154.26;Float;False;317;main_r;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;289;2289.246,1520.266;Float;False;Property;_TexPower;Tex Power;10;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;305;1915.115,1443.35;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;283;2857.562,926.9477;Float;False;Property;_MaskPower;Mask Power;11;0;Create;True;0;0;False;0;1;1;1;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;187;2944,496;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;252;3106.855,8.825776;Float;False;Property;_TintColor;Tint Color;9;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.421578,0.3761029,1.65,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;293;2126.734,1245.71;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;292;2492.01,1252.63;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;277;2862.228,695.7241;Float;True;Property;_MaskMap;Mask Map;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;282;3229.901,806.6626;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;184;3120,496;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;3511.026,136.5275;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;295;2719.478,1351.625;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;281;3734.874,132.7914;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;3530.034,425.8254;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;2948.751,1325.918;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;301;3099.486,1318.187;Float;True;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;328;4076.8,557.6959;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;327;4265.657,530.4615;Float;False;Property;_BlendMask;Blend Mask;7;0;Create;True;0;0;False;0;0;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;308;3597.617,840.0585;Float;True;301;OpacityMask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;324;4590.746,467.9195;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Decal/DepthDecalCutout;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;2;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;248;0;274;0
WireConnection;248;1;244;0
WireConnection;113;0;114;0
WireConnection;113;1;244;0
WireConnection;249;0;248;0
WireConnection;249;1;250;0
WireConnection;154;0;152;1
WireConnection;154;1;152;2
WireConnection;160;0;113;0
WireConnection;312;0;249;0
WireConnection;158;0;160;0
WireConnection;155;0;154;0
WireConnection;155;1;152;3
WireConnection;156;0;155;0
WireConnection;156;2;216;0
WireConnection;159;0;158;0
WireConnection;222;1;313;0
WireConnection;317;0;222;1
WireConnection;148;0;159;0
WireConnection;148;1;156;0
WireConnection;322;0;314;0
WireConnection;322;2;320;0
WireConnection;322;1;321;2
WireConnection;163;0;148;0
WireConnection;163;1;164;0
WireConnection;288;1;322;0
WireConnection;305;0;303;0
WireConnection;187;0;163;0
WireConnection;293;0;288;1
WireConnection;293;1;305;0
WireConnection;292;0;318;0
WireConnection;292;1;289;0
WireConnection;277;1;315;0
WireConnection;282;0;277;1
WireConnection;282;1;283;0
WireConnection;184;0;187;0
WireConnection;251;0;252;0
WireConnection;251;1;222;0
WireConnection;295;0;292;0
WireConnection;295;1;293;0
WireConnection;281;0;251;0
WireConnection;278;0;184;0
WireConnection;278;1;252;4
WireConnection;278;2;282;0
WireConnection;298;0;277;4
WireConnection;298;1;295;0
WireConnection;301;0;298;0
WireConnection;328;0;281;0
WireConnection;328;1;278;0
WireConnection;327;0;278;0
WireConnection;327;1;328;0
WireConnection;324;2;281;0
WireConnection;324;9;327;0
WireConnection;324;10;308;0
ASEEND*/
//CHKSM=E3C58E2191622C3D070907400C1FD5088E50888A
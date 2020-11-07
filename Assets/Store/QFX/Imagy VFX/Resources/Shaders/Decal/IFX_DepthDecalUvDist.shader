// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Decal/DepthDecalUvDist"
{
	Properties
	{
		_Size("Size", Range( 0 , 1)) = 1
		_RampFalloff("Ramp Falloff", Range( 0.01 , 14)) = 5
		_MaskMap("Mask Map", 2D) = "white" {}
		_NoiseTex("Noise Tex", 2D) = "white" {}
		_NoiseSpeed("Noise Speed", Vector) = (0.5,0.5,0,0)
		_Offset("Offset", Float) = 0
		_Noise("Noise", Float) = 0.45
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" }
		Cull Front
		ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf StandardCustomLighting keepalpha noshadow alpha:fade
		#pragma surface surf StandardCustomLighting keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _CameraDepthTexture;
		uniform float _Size;
		uniform float _RampFalloff;
		uniform sampler2D _MaskMap;
		uniform sampler2D _NoiseTex;
		uniform float2 _NoiseSpeed;
		uniform float _Noise;
		uniform float _Offset;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 transform114 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
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
			float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
			float4 temp_output_248_0 = mul( unity_WorldToObject, temp_output_244_0 );
			float2 panner280 = ( _Time.y * _NoiseSpeed + temp_output_248_0.xy);
			float4 temp_cast_2 = (_Offset).xxxx;
			float4 temp_output_289_0 = ( ( ( ( tex2D( _NoiseTex, panner280 ).r * _Noise ) + temp_output_248_0 ) + 0.5 ) - temp_cast_2 );
			c.rgb = 0;
			c.a = ( ( 1.0 - saturate( pow( ( length( abs( (( transform114 - temp_output_244_0 )).xyz ) ) / ( max( max( ase_objectScale.x , ase_objectScale.y ) , ase_objectScale.z ) * 0.5 * _Size ) ) , _RampFalloff ) ) ) * tex2D( _MaskMap, temp_output_289_0.xy ).r );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
235;637;1100;391;-2295.459;53.65692;2.30947;True;False
Node;AmplifyShaderEditor.CommentaryNode;219;1430.562,431.2389;Float;False;339.352;234.4789;Object pivot position in world space;1;114;;0,0,0,1;0;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;114;1480.562,481.2389;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;220;1669.14,726.5161;Float;False;527.0399;229;Make the effect scale with the sphere;3;152;154;155;;0,0,0,1;0;0
Node;AmplifyShaderEditor.FunctionNode;244;1451.203,252.1467;Float;False;Reconstruct World Position From Depth;1;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;274;1610.878,172.8008;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;113;1850.315,480.0514;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TimeNode;284;1910.423,-190.4717;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ObjectScaleNode;152;1719.14,776.5161;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;1875.491,206.3374;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;283;1825.256,-312.9013;Float;False;Property;_NoiseSpeed;Noise Speed;11;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMaxOpNode;154;1917.767,776.5155;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;160;2019.684,492.7632;Float;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;280;2116.25,-360.8086;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;216;1922.201,1004.83;Float;False;Property;_Size;Size;3;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;279;2302.526,-388.3244;Float;True;Property;_NoiseTex;Noise Tex;10;0;Create;True;0;0;False;0;140c5b15ccac91a4fb58b5ea4666c02f;357928dd8c8088440b4662373bd09d7a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;158;2249.322,496.2934;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;155;2047.176,823.9933;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;164;2219.559,637.4156;Float;False;Property;_RampFalloff;Ramp Falloff;4;0;Create;True;0;0;False;0;5;6;0.01;14;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;2393.37,-102.7856;Float;False;Property;_Noise;Noise;13;0;Create;True;0;0;False;0;0.45;0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;159;2400,499.7799;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;293;2538.424,604.926;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;286;2621.933,-191.4081;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;2254.979,824.6212;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;148;2571.09,499.1686;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;250;2251.57,354.189;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;285;2262.706,143.0819;Float;False;2;2;0;FLOAT;0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.WireNode;296;2556.854,582.5112;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;163;2730.691,497.8898;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;294;2628.559,337.9805;Float;False;Property;_Offset;Offset;12;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;249;2453.517,246.4837;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;289;2819.683,240.737;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;187;2947.78,499.78;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;277;2966.679,654.6608;Float;True;Property;_MaskMap;Mask Map;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;184;3120,496;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;222;3038.239,225.3191;Float;True;Property;_MainTex;Main Tex;5;0;Create;True;0;0;False;0;163632276e446414db3976d5befc6048;163632276e446414db3976d5befc6048;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;297;3798.195,317.087;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ToggleSwitchNode;298;3987.052,289.8526;Float;False;Property;_BlendMask;Blend Mask;8;0;Create;True;0;0;False;0;0;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;3511.026,136.5275;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;3445.034,438.8254;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Matrix4X4Node;272;1618.809,-2.647696;Float;False;InstancedProperty;_WorldToLocalMatrix;_WorldToLocalMatrix;7;0;Create;True;0;0;False;0;1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.ColorNode;252;3106.855,8.825776;Float;False;Property;_TintColor;Tint Color;6;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;245;4371.868,260.5614;Float;False;True;2;Float;ASEMaterialInspector;0;0;CustomLighting;QFX/IFX/Decal/DepthDecalUvDist;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Front;0;False;-1;7;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;surface surf StandardCustomLighting keepalpha noshadow alpha:fade;False;;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;113;0;114;0
WireConnection;113;1;244;0
WireConnection;248;0;274;0
WireConnection;248;1;244;0
WireConnection;154;0;152;1
WireConnection;154;1;152;2
WireConnection;160;0;113;0
WireConnection;280;0;248;0
WireConnection;280;2;283;0
WireConnection;280;1;284;2
WireConnection;279;1;280;0
WireConnection;158;0;160;0
WireConnection;155;0;154;0
WireConnection;155;1;152;3
WireConnection;159;0;158;0
WireConnection;293;0;164;0
WireConnection;286;0;279;1
WireConnection;286;1;287;0
WireConnection;156;0;155;0
WireConnection;156;2;216;0
WireConnection;148;0;159;0
WireConnection;148;1;156;0
WireConnection;285;0;286;0
WireConnection;285;1;248;0
WireConnection;296;0;293;0
WireConnection;163;0;148;0
WireConnection;163;1;296;0
WireConnection;249;0;285;0
WireConnection;249;1;250;0
WireConnection;289;0;249;0
WireConnection;289;1;294;0
WireConnection;187;0;163;0
WireConnection;277;1;289;0
WireConnection;184;0;187;0
WireConnection;222;1;289;0
WireConnection;298;1;297;0
WireConnection;251;0;252;0
WireConnection;251;1;222;0
WireConnection;278;0;184;0
WireConnection;278;1;277;1
WireConnection;245;9;278;0
ASEEND*/
//CHKSM=E2C75856E19D78936E7B4DC4347ADBC096DD02B6
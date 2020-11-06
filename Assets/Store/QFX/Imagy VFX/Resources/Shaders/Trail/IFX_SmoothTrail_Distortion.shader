// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Trail/SmoothTrail_Distortion"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_NoiseTex("Noise Tex", 2D) = "white" {}
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white" {}
		_Speed("Speed", Vector) = (0,0,0,0)
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_Distortion("Distortion", Float) = 0
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0.37
		_DissolveEdgeWidth("Dissolve Edge Width", Range( 0 , 1)) = 0.37
		_NoiseMap("Noise Map", 2D) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow alpha:fade
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv_tex4coord;
			float4 screenPos;
			float4 vertexColor : COLOR;
		};

		uniform float _DissolveEdgeWidth;
		uniform sampler2D _NoiseMap;
		uniform float4 _NoiseMap_ST;
		uniform float _DissolveAmount;
		uniform float4 _DissolveColor;
		uniform sampler2D _GrabTexture;
		uniform sampler2D _MainTex;
		uniform float4 _Speed;
		uniform float4 _MainTex_ST;
		uniform float _Distortion;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float4 _TintColor;
		uniform float _Cutoff = 0.5;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_NoiseMap = i.uv_texcoord * _NoiseMap_ST.xy + _NoiseMap_ST.zw;
			float temp_output_65_0 = ( tex2D( _NoiseMap, uv_NoiseMap ).r + (-0.6 + (( 1.0 - ( _DissolveAmount + i.uv_tex4coord.z ) ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) );
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult9 = (float2(_Speed.x , _Speed.y));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner10 = ( _Time.y * appendResult9 + uv_MainTex);
			float4 tex2DNode6 = tex2D( _MainTex, panner10 );
			float4 screenColor54 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + float4( ( (tex2DNode6).rg * _Distortion ), 0.0 , 0.0 ) ).xy );
			float smoothstepResult52 = smoothstep( 0.2 , 0.8 , ( ( 1.0 - uv_MainTex.x ) - 0.0 ));
			float temp_output_47_0 = saturate( smoothstepResult52 );
			float2 appendResult16 = (float2(_Speed.z , _Speed.w));
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner17 = ( _Time.y * appendResult16 + uv_NoiseTex);
			float temp_output_42_0 = ( uv_MainTex.y * ( 1.0 - uv_MainTex.y ) * ( 1.0 - uv_MainTex.x ) * 8.0 );
			o.Emission = (( _DissolveEdgeWidth > temp_output_65_0 ) ? _DissolveColor :  ( screenColor54 + ( tex2DNode6.r * saturate( ( ( temp_output_47_0 + tex2D( _NoiseTex, panner17 ).r ) - i.uv_texcoord.x ) ) * _TintColor * temp_output_42_0 * i.vertexColor ) ) ).rgb;
			o.Alpha = saturate( ( i.vertexColor.a * temp_output_42_0 * temp_output_47_0 * ( ( uv_MainTex.x * uv_MainTex.y * ( 1.0 - uv_MainTex.y ) ) * 20.0 ) ) );
			clip( temp_output_65_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
101;314;1227;680;1498.831;390.4655;2.196816;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1566.076,958.9046;Float;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;20;-1287.834,-448.9283;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;8;-1926.099,481.1486;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0,0,0,0;-0.5,0,-1.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;46;-1350.004,-108.8792;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-1088.209,-451.2259;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1572.91,650.2505;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1664.938,527.6633;Float;False;0;7;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;14;-1596.062,747.6527;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;13;-1471.088,301.2889;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;9;-1573.736,211.2868;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;52;-876.7589,-453.2397;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;17;-1349.251,603.5708;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;10;-1236.519,166.0599;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;47;-739.8207,-28.32692;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;6;-991.6994,157.8784;Float;True;Property;_MainTex;Main Tex;3;0;Create;True;0;0;False;0;None;c72a4cfc6aff9594bbf78865caa0e621;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;7;-1054.046,546.7562;Float;True;Property;_NoiseTex;Noise Tex;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-719.1584,456.8394;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;60;-396.9722,2042.129;Float;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1101.938,781.9611;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;77;-954.2447,1349.663;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-387.0922,1933.867;Float;False;Property;_DissolveAmount;Dissolve Amount;7;0;Create;True;0;0;False;0;0.37;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;58;157.339,593.7649;Float;False;Property;_Distortion;Distortion;6;0;Create;True;0;0;False;0;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;56;57.46944,295.0531;Float;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-567.5573,1303.362;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;76;-644.5538,1005.561;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-543.9658,777.377;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-564.7538,1137.918;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;40;-564.7542,1217.739;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;53;88.30894,-43.64823;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;78;-682.4876,1514.358;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;62;-87.54913,1951.303;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;337.5775,459.3729;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-303.1242,1115.15;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;43;-363.1695,866.132;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;72;-334.0998,696.2947;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-333.8737,1332.282;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;63;238.1539,1946.32;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;368.8595,83.82259;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ColorNode;30;-385.8618,100.2492;Float;False;Property;_TintColor;Tint Color;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;2,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;67;420.6868,1949.098;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-100.1434,1273.623;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-86.77873,406.4583;Float;True;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;64;-400.7508,1705.516;Float;True;Property;_NoiseMap;Noise Map;9;0;Create;True;0;0;False;0;None;140c5b15ccac91a4fb58b5ea4666c02f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenColorNode;54;516.1333,135.1925;Float;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;69;298.6741,1284.34;Float;False;Property;_DissolveColor;Dissolve Color;2;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;82.36072,766.6558;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;239.8419,1126.394;Float;False;Property;_DissolveEdgeWidth;Dissolve Edge Width;8;0;Create;True;0;0;False;0;0.37;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;561.4955,520.9351;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;612.1763,1722.069;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;48;315.8358,772.5049;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareGreater;70;670.0846,1167.943;Float;True;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1144.407,823.7061;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Trail/SmoothTrail_Distortion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;surface surf Unlit keepalpha noshadow alpha:fade;False;;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;11;1
WireConnection;49;0;20;0
WireConnection;49;1;46;0
WireConnection;16;0;8;3
WireConnection;16;1;8;4
WireConnection;9;0;8;1
WireConnection;9;1;8;2
WireConnection;52;0;49;0
WireConnection;17;0;15;0
WireConnection;17;2;16;0
WireConnection;17;1;14;2
WireConnection;10;0;11;0
WireConnection;10;2;9;0
WireConnection;10;1;13;2
WireConnection;47;0;52;0
WireConnection;6;1;10;0
WireConnection;7;1;17;0
WireConnection;24;0;47;0
WireConnection;24;1;7;1
WireConnection;77;0;11;2
WireConnection;56;0;6;0
WireConnection;76;0;11;2
WireConnection;25;0;24;0
WireConnection;25;1;26;1
WireConnection;39;0;77;0
WireConnection;40;0;11;1
WireConnection;78;0;11;2
WireConnection;62;0;61;0
WireConnection;62;1;60;3
WireConnection;57;0;56;0
WireConnection;57;1;58;0
WireConnection;42;0;76;0
WireConnection;42;1;39;0
WireConnection;42;2;40;0
WireConnection;42;3;41;0
WireConnection;72;0;25;0
WireConnection;75;0;11;1
WireConnection;75;1;11;2
WireConnection;75;2;78;0
WireConnection;63;0;62;0
WireConnection;55;0;53;0
WireConnection;55;1;57;0
WireConnection;67;0;63;0
WireConnection;79;0;75;0
WireConnection;19;0;6;1
WireConnection;19;1;72;0
WireConnection;19;2;30;0
WireConnection;19;3;42;0
WireConnection;19;4;43;0
WireConnection;54;0;55;0
WireConnection;44;0;43;4
WireConnection;44;1;42;0
WireConnection;44;2;47;0
WireConnection;44;3;79;0
WireConnection;59;0;54;0
WireConnection;59;1;19;0
WireConnection;65;0;64;1
WireConnection;65;1;67;0
WireConnection;48;0;44;0
WireConnection;70;0;68;0
WireConnection;70;1;65;0
WireConnection;70;2;69;0
WireConnection;70;3;59;0
WireConnection;0;2;70;0
WireConnection;0;9;48;0
WireConnection;0;10;65;0
ASEEND*/
//CHKSM=EF609A1B2B1A807779F3595F69948C65C82A84AB
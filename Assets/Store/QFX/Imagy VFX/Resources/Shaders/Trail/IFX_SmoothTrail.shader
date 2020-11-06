// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Trail/SmoothTrail"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_NoiseTex("Noise Tex", 2D) = "white" {}
		[HDR]_DissolveColor("Dissolve Color", Color) = (1,1,1,1)
		_MainTex("Main Tex", 2D) = "white" {}
		_Speed("Speed", Vector) = (0,0,0,0)
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		_DissolveAmount("Dissolve Amount", Range( 0 , 1)) = 0.37
		_NoiseMap("Noise Map", 2D) = "white" {}
		_DissolveEdgeWidth("Dissolve Edge Width", Range( 0 , 1)) = 0.37
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma #pragma surface surf Unlit keepalpha noshadow alpha:fade
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 uv_tex4coord;
			float4 vertexColor : COLOR;
		};

		uniform float _DissolveEdgeWidth;
		uniform sampler2D _NoiseMap;
		uniform float4 _NoiseMap_ST;
		uniform float _DissolveAmount;
		uniform float4 _DissolveColor;
		uniform sampler2D _MainTex;
		uniform float4 _Speed;
		uniform float4 _MainTex_ST;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTex_ST;
		uniform float4 _TintColor;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_NoiseMap = i.uv_texcoord * _NoiseMap_ST.xy + _NoiseMap_ST.zw;
			float temp_output_59_0 = ( tex2D( _NoiseMap, uv_NoiseMap ).r + (-0.6 + (( 1.0 - ( _DissolveAmount + i.uv_tex4coord.z ) ) - 0.0) * (0.6 - -0.6) / (1.0 - 0.0)) );
			float2 appendResult9 = (float2(_Speed.x , _Speed.y));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner10 = ( _Time.y * appendResult9 + uv_MainTex);
			float4 tex2DNode6 = tex2D( _MainTex, panner10 );
			float smoothstepResult52 = smoothstep( 0.2 , 0.8 , ( ( 1.0 - uv_MainTex.x ) - 0.0 ));
			float temp_output_47_0 = saturate( smoothstepResult52 );
			float2 appendResult16 = (float2(_Speed.z , _Speed.w));
			float2 uv_NoiseTex = i.uv_texcoord * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
			float2 panner17 = ( _Time.y * appendResult16 + uv_NoiseTex);
			float4 tex2DNode7 = tex2D( _NoiseTex, panner17 );
			float temp_output_42_0 = ( uv_MainTex.y * ( 1.0 - uv_MainTex.y ) * ( 1.0 - uv_MainTex.x ) * 8.0 );
			o.Emission = (( _DissolveEdgeWidth > temp_output_59_0 ) ? _DissolveColor :  ( tex2DNode6 * ( ( temp_output_47_0 + tex2DNode7.r ) - i.uv_texcoord.x ) * _TintColor * temp_output_42_0 * i.vertexColor ) ).rgb;
			o.Alpha = saturate( ( i.vertexColor.a * tex2DNode6.r * tex2DNode7 * temp_output_42_0 * temp_output_47_0 * ( temp_output_42_0 * ( ( uv_MainTex.x * uv_MainTex.y * ( 1.0 - uv_MainTex.y ) ) * 20.0 ) ) ) ).r;
			clip( temp_output_59_0 - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
151;242;1227;680;768.4816;-666.1635;1.449115;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;11;-1497.843,1101.729;Float;False;0;6;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;20;-1287.834,-448.9283;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1350.004,-108.8792;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;8;-1926.099,481.1486;Float;False;Property;_Speed;Speed;4;0;Create;True;0;0;False;0;0,0,0,0;-0.5,0,-1.5,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1664.938,527.6633;Float;False;0;7;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;14;-1596.062,747.6527;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;49;-1088.209,-451.2259;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-1572.91,650.2505;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-731.8467,2031.754;Float;False;Property;_DissolveAmount;Dissolve Amount;6;0;Create;True;0;0;False;0;0.37;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;62;-577.5331,1514.571;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;64;-945.1194,1439.72;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-741.7267,2140.016;Float;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;52;-876.7589,-453.2397;Float;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;0.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;17;-1349.251,603.5708;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;65;-896.1194,1035.72;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;13;-1471.088,301.2889;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;40;-564.7542,1217.739;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-339.1913,1402.226;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-567.5573,1303.362;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1171.547,576.1312;Float;True;Property;_NoiseTex;Noise Tex;1;0;Create;True;0;0;False;0;None;4b7b360a21c5d084abec3db1c7b65512;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;9;-1573.736,211.2868;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;-432.3037,2049.189;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;39;-564.7538,1137.918;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;47;-739.8207,-28.32692;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;10;-1236.519,166.0599;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-105.461,1343.567;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-1101.938,781.9611;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-717.0602,465.2323;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-303.1242,1115.15;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;56;-106.6006,2044.207;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;2.13501,1227.767;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;-539.1712,578.6456;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;30;-353.726,60.07949;Float;False;Property;_TintColor;Tint Color;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;0.06617635,1.664605,3,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;43;-277.142,532.5147;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;58;75.93226,2046.985;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.6;False;4;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-745.5053,1803.403;Float;True;Property;_NoiseMap;Noise Map;7;0;Create;True;0;0;False;0;None;140c5b15ccac91a4fb58b5ea4666c02f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;6;-991.6994,157.8784;Float;True;Property;_MainTex;Main Tex;3;0;Create;True;0;0;False;0;None;c72a4cfc6aff9594bbf78865caa0e621;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;66;214.6786,1419.349;Float;False;Property;_DissolveEdgeWidth;Dissolve Edge Width;8;0;Create;True;0;0;False;0;0.37;0.7;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;59;360.1656,1837.345;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;67;273.5108,1577.295;Float;False;Property;_DissolveColor;Dissolve Color;2;1;[HDR];Create;True;0;0;False;0;1,1,1,1;0,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;92.0473,885.9427;Float;True;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;105.3561,577.2098;Float;True;5;5;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;48;320.6172,1069.345;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareGreater;68;584.9213,1492.898;Float;True;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1021.703,1244.679;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Trail/SmoothTrail;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Pragma;#pragma surface surf Unlit keepalpha noshadow alpha:fade;False;;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;11;1
WireConnection;49;0;20;0
WireConnection;49;1;46;0
WireConnection;16;0;8;3
WireConnection;16;1;8;4
WireConnection;62;0;11;2
WireConnection;64;0;11;2
WireConnection;52;0;49;0
WireConnection;17;0;15;0
WireConnection;17;2;16;0
WireConnection;17;1;14;2
WireConnection;65;0;11;2
WireConnection;40;0;11;1
WireConnection;61;0;11;1
WireConnection;61;1;11;2
WireConnection;61;2;62;0
WireConnection;7;1;17;0
WireConnection;9;0;8;1
WireConnection;9;1;8;2
WireConnection;55;0;54;0
WireConnection;55;1;53;3
WireConnection;39;0;64;0
WireConnection;47;0;52;0
WireConnection;10;0;11;0
WireConnection;10;2;9;0
WireConnection;10;1;13;2
WireConnection;60;0;61;0
WireConnection;24;0;47;0
WireConnection;24;1;7;1
WireConnection;42;0;65;0
WireConnection;42;1;39;0
WireConnection;42;2;40;0
WireConnection;42;3;41;0
WireConnection;56;0;55;0
WireConnection;63;0;42;0
WireConnection;63;1;60;0
WireConnection;25;0;24;0
WireConnection;25;1;26;1
WireConnection;58;0;56;0
WireConnection;6;1;10;0
WireConnection;59;0;57;1
WireConnection;59;1;58;0
WireConnection;44;0;43;4
WireConnection;44;1;6;1
WireConnection;44;2;7;0
WireConnection;44;3;42;0
WireConnection;44;4;47;0
WireConnection;44;5;63;0
WireConnection;19;0;6;0
WireConnection;19;1;25;0
WireConnection;19;2;30;0
WireConnection;19;3;42;0
WireConnection;19;4;43;0
WireConnection;48;0;44;0
WireConnection;68;0;66;0
WireConnection;68;1;59;0
WireConnection;68;2;67;0
WireConnection;68;3;19;0
WireConnection;0;2;68;0
WireConnection;0;9;48;0
WireConnection;0;10;59;0
ASEEND*/
//CHKSM=532603AB7113DE9059430C971A1E0CDA2D3EC45E
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Distortion/SphereDistortion"
{
	Properties
	{
		_FresnelPower("Fresnel Power", Float) = 2.49
		_FresnelScale("Fresnel Scale", Float) = 0.65
		_NoiseMap("Noise Map", 2D) = "white" {}
		_Distortion("Distortion", Range( -1 , 1)) = 0
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,1)
		_NoiseSpeed("Noise Speed", Vector) = (0,0,0,0)
		[Toggle]_UseFresnelOpacity("Use Fresnel Opacity", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			float4 vertexColor : COLOR;
			float3 viewDir;
		};

		uniform float4 _TintColor;
		uniform sampler2D _GrabTexture;
		uniform sampler2D _NoiseMap;
		uniform float2 _NoiseSpeed;
		uniform float4 _NoiseMap_ST;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _Distortion;
		uniform float _UseFresnelOpacity;


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
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 uv_NoiseMap = i.uv_texcoord * _NoiseMap_ST.xy + _NoiseMap_ST.zw;
			float2 panner38 = ( _Time.y * _NoiseSpeed + uv_NoiseMap);
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode1 = ( 0.0 + _FresnelScale * pow( 1.0 - fresnelNdotV1, _FresnelPower ) );
			float temp_output_23_0 = ( fresnelNode1 * ( 1.0 - fresnelNode1 ) );
			float3 worldToViewDir26 = mul( UNITY_MATRIX_V, float4( ase_worldNormal, 0 ) ).xyz;
			float3 worldToViewDir27 = mul( UNITY_MATRIX_V, float4( i.viewDir, 0 ) ).xyz;
			float3 normalizeResult31 = normalize( ( worldToViewDir26 - worldToViewDir27 ) );
			float4 screenColor13 = tex2D( _GrabTexture, ( ase_grabScreenPosNorm + ( tex2D( _NoiseMap, panner38 ).r * temp_output_23_0 * _Distortion * i.vertexColor * float4( normalizeResult31 , 0.0 ) ) ).xy );
			o.Emission = ( _TintColor * screenColor13 ).rgb;
			o.Alpha = saturate( ( i.vertexColor.a * lerp(1.0,temp_output_23_0,_UseFresnelOpacity) * _TintColor.a ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16200
235;730;957;298;2133.573;-402.3151;1.799326;True;False
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;25;-2137.337,854.2354;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;3;-2100.099,345.0563;Float;False;Property;_FresnelPower;Fresnel Power;0;0;Create;True;0;0;False;0;2.49;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;24;-2143.434,699.7784;Float;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;2;-2100.01,241.6154;Float;False;Property;_FresnelScale;Fresnel Scale;1;0;Create;True;0;0;False;0;0.65;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;27;-1870.26,875.7693;Float;False;World;View;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;1;-1877.061,199.4677;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TransformDirectionNode;26;-1879.193,669.2653;Float;False;World;View;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TimeNode;41;-2069.193,84.34908;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;40;-2031.807,-38.32193;Float;False;Property;_NoiseSpeed;Noise Speed;5;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-2035.313,-157.488;Float;False;0;4;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;6;-1523.147,264.45;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-1603.894,776.6334;Float;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PannerNode;38;-1701.43,8.986538;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;4;-1461.659,-1.826017;Float;True;Property;_NoiseMap;Noise Map;2;0;Create;True;0;0;False;0;None;5abc56ef7afce594881c7c417db12ea2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1342.081,196.985;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;31;-1339.297,776.7161;Float;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1314.494,488.2083;Float;False;Property;_Distortion;Distortion;3;0;Create;True;0;0;False;0;0;-0.15;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;9;-1318.135,581.5636;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;43;-991.8982,706.5535;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-996.9513,443.7235;Float;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GrabScreenPosition;11;-1013.154,248.4855;Float;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;42;-845.443,613.5161;Float;False;Property;_UseFresnelOpacity;Use Fresnel Opacity;6;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;-1438.949,-233.675;Float;False;Property;_TintColor;Tint Color;4;1;[HDR];Create;True;0;0;False;0;0,0,0,1;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-722.7983,371.7495;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-609.272,594.9916;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;13;-565.1357,368.4846;Float;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-344.3787,308.5151;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;35;-459.9391,596.4287;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-184.1631,329.9326;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;QFX/IFX/Distortion/SphereDistortion;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;27;0;25;0
WireConnection;1;2;2;0
WireConnection;1;3;3;0
WireConnection;26;0;24;0
WireConnection;6;0;1;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;38;0;39;0
WireConnection;38;2;40;0
WireConnection;38;1;41;2
WireConnection;4;1;38;0
WireConnection;23;0;1;0
WireConnection;23;1;6;0
WireConnection;31;0;28;0
WireConnection;10;0;4;1
WireConnection;10;1;23;0
WireConnection;10;2;8;0
WireConnection;10;3;9;0
WireConnection;10;4;31;0
WireConnection;42;0;43;0
WireConnection;42;1;23;0
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;34;0;9;4
WireConnection;34;1;42;0
WireConnection;34;2;36;4
WireConnection;13;0;12;0
WireConnection;37;0;36;0
WireConnection;37;1;13;0
WireConnection;35;0;34;0
WireConnection;0;2;37;0
WireConnection;0;9;35;0
ASEEND*/
//CHKSM=59A3FD0193727E14FA22A2F2DB760331837737BB
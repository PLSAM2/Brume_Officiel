// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GrassSwing"
{
	Properties
	{
		_wind_Noise_Texture("wind_Noise_Texture", 2D) = "white" {}
		_wind_Texture_Tiling("wind_Texture_Tiling", Float) = 0.5
		_wind_Direction("wind_Direction", Float) = 1
		_wind_Density("wind_Density", Float) = 0.2
		_wind_Strength("wind_Strength", Float) = 2
		_windWave_Speed("windWave_Speed", Vector) = (0.1,0,0,0)
		_windWave_Min_Speed("windWave_Min_Speed", Vector) = (0.05,0,0,0)
		_object_Size("object_Size", Float) = 0.2
		_wave_Speed("wave_Speed", Float) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
		};

		uniform sampler2D _wind_Noise_Texture;
		uniform float _wind_Texture_Tiling;
		uniform float _wave_Speed;
		uniform float2 _windWave_Speed;
		uniform float2 _windWave_Min_Speed;
		uniform float _wind_Direction;
		uniform float _wind_Density;
		uniform float _wind_Strength;
		uniform float _object_Size;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 temp_cast_1 = (_wind_Texture_Tiling).xx;
			float2 panner7 = ( ( ( _CosTime.w + _Time.y ) * _wave_Speed ) * _windWave_Speed + float2( 0,0 ));
			float2 panner62 = ( 1.0 * _Time.y * _windWave_Min_Speed + float2( 0,0 ));
			float2 uv_TexCoord6 = v.texcoord.xy * temp_cast_1 + ( ( panner7 + panner62 ) * _wind_Direction );
			float4 temp_cast_2 = (( _wind_Density * _SinTime.w )).xxxx;
			float4 appendResult16 = (float4(( ( ( tex2Dlod( _wind_Noise_Texture, float4( uv_TexCoord6, 0, 0.0) ) - temp_cast_2 ) * _wind_Strength ) + ase_worldPos.x ).r , ase_worldPos.y , ase_worldPos.z , 0.0));
			float4 lerpResult26 = lerp( float4( ase_worldPos , 0.0 ) , appendResult16 , ( 1.0 - v.texcoord.xy.y ));
			float4 ase_screenPos = ComputeScreenPos( UnityObjectToClipPos( v.vertex ) );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 worldToObj18 = mul( unity_WorldToObject, float4( ( lerpResult26 - ase_screenPosNorm ).xyz, 1 ) ).xyz;
			v.vertex.xyz += ( worldToObj18 * _object_Size );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
0;0;1920;1019;3484.354;726.7935;2.452533;True;False
Node;AmplifyShaderEditor.CommentaryNode;17;-6494.443,-140.7463;Inherit;False;2967.388;861.3693;Wind Noise Animation;23;37;2;6;1;77;74;11;8;9;65;7;62;10;79;63;38;80;39;85;86;87;88;89;;0.6745283,0.8372198,1,1;0;0
Node;AmplifyShaderEditor.CosTime;37;-5461.712,13.66297;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;39;-5479.361,215.5317;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;38;-5299.361,164.5316;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-5053.42,255.962;Inherit;False;Property;_wave_Speed;wave_Speed;8;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-4862.373,178.4373;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;63;-5072.032,511.1929;Inherit;False;Property;_windWave_Min_Speed;windWave_Min_Speed;6;0;Create;True;0;0;False;0;False;0.05,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;10;-4973.555,23.3787;Inherit;False;Property;_windWave_Speed;windWave_Speed;5;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;7;-4715.76,4.251574;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;62;-4815.415,493.0778;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-4448.894,402.7136;Inherit;False;Property;_wind_Direction;wind_Direction;2;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;65;-4470.02,277.2941;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-4372.512,118.2648;Inherit;False;Property;_wind_Texture_Tiling;wind_Texture_Tiling;1;0;Create;True;0;0;False;0;False;0.5;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-4259.892,285.7131;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinTimeNode;77;-3760.979,412.4771;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-4134.813,131.475;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1;-4090.065,-90.74682;Inherit;True;Property;_wind_Noise_Texture;wind_Noise_Texture;0;0;Create;True;0;0;False;0;False;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;74;-3792.157,320.1185;Inherit;False;Property;_wind_Density;wind_Density;3;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;78;-3592.566,375.3208;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-3847.064,99.25427;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;76;-3180.915,175.6409;Inherit;False;Property;_wind_Strength;wind_Strength;4;0;Create;True;0;0;False;0;False;2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;73;-3384.006,107.1231;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-2148.575,703.3266;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;75;-3005.915,107.6409;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;12;-2780.274,296.4176;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-2533.211,107.5909;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;24;-1915.145,703.0761;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;16;-2290.212,319.591;Inherit;True;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.OneMinusNode;29;-1740.875,894.1539;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;27;-1780.27,205.7386;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenPosInputsNode;69;-1135.654,384.3947;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;26;-1569.265,293.7376;Inherit;True;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;19;-900.0132,284.3083;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TransformPositionNode;18;-735.4211,280.4265;Inherit;True;World;Object;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;71;-425.2344,380.1037;Inherit;False;Property;_object_Size;object_Size;7;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;85;-6138.09,98.87483;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;-5931.09,39.87486;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;89;-5772.669,105.7866;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;-240.3771,286.6619;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-5951.641,187.3081;Inherit;False;Property;_frequency;frequency;9;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;87;-6077.766,7.004494;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;GrassSwing;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;38;0;37;4
WireConnection;38;1;39;0
WireConnection;79;0;38;0
WireConnection;79;1;80;0
WireConnection;7;2;10;0
WireConnection;7;1;79;0
WireConnection;62;2;63;0
WireConnection;65;0;7;0
WireConnection;65;1;62;0
WireConnection;8;0;65;0
WireConnection;8;1;9;0
WireConnection;6;0;11;0
WireConnection;6;1;8;0
WireConnection;78;0;74;0
WireConnection;78;1;77;4
WireConnection;2;0;1;0
WireConnection;2;1;6;0
WireConnection;73;0;2;0
WireConnection;73;1;78;0
WireConnection;75;0;73;0
WireConnection;75;1;76;0
WireConnection;15;0;75;0
WireConnection;15;1;12;1
WireConnection;24;0;23;0
WireConnection;16;0;15;0
WireConnection;16;1;12;2
WireConnection;16;2;12;3
WireConnection;29;0;24;1
WireConnection;26;0;27;0
WireConnection;26;1;16;0
WireConnection;26;2;29;0
WireConnection;19;0;26;0
WireConnection;19;1;69;0
WireConnection;18;0;19;0
WireConnection;86;0;87;0
WireConnection;86;1;85;0
WireConnection;89;0;86;0
WireConnection;89;1;88;0
WireConnection;70;0;18;0
WireConnection;70;1;71;0
WireConnection;0;11;70;0
ASEEND*/
//CHKSM=A2AF5DC7617BF9D42BB4D62AAA0B13F459F81957
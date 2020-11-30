// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TerrainBlending"
{
	Properties
	{
		_BlendThickness("BlendThickness", Range( 0 , 30)) = 0
		_Falloff("Falloff", Range( 0 , 30)) = 0
		_Noise("Noise", 2D) = "white" {}
		_NoiseScale("NoiseScale", Float) = 0
		_TextureTerrain("TextureTerrain", 2D) = "white" {}
		_TextureMesh("TextureMesh", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _TextureTerrain;
		uniform float4 _TextureTerrain_ST;
		uniform sampler2D _TextureMesh;
		uniform float4 _TextureMesh_ST;
		uniform sampler2D TB_DEPTH;
		uniform float TB_OFFSET_X;
		uniform float TB_OFFSET_Z;
		uniform float TB_SCALE;
		uniform float TB_FARCLIP;
		uniform float TB_OFFSET_Y;
		uniform float _BlendThickness;
		uniform sampler2D _Noise;
		uniform float _NoiseScale;
		uniform float _Falloff;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureTerrain = i.uv_texcoord * _TextureTerrain_ST.xy + _TextureTerrain_ST.zw;
			float2 uv_TextureMesh = i.uv_texcoord * _TextureMesh_ST.xy + _TextureMesh_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float worldY8 = ase_worldPos.y;
			float4 temp_cast_0 = (worldY8).xxxx;
			float2 appendResult6 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult5 = (float2(TB_OFFSET_X , TB_OFFSET_Z));
			float4 temp_cast_1 = (TB_OFFSET_Y).xxxx;
			float4 clampResult19 = clamp( ( ( ( temp_cast_0 - ( tex2D( TB_DEPTH, ( ( appendResult6 - appendResult5 ) / TB_SCALE ) ) * TB_FARCLIP ) ) - temp_cast_1 ) / ( _BlendThickness * tex2D( _Noise, ( (ase_worldPos).xyzz * _NoiseScale ).xy ) ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 temp_cast_3 = (_Falloff).xxxx;
			float4 clampResult22 = clamp( pow( clampResult19 , temp_cast_3 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float4 lerpResult30 = lerp( tex2D( _TextureTerrain, uv_TextureTerrain ) , tex2D( _TextureMesh, uv_TextureMesh ) , clampResult22.r);
			o.Albedo = lerpResult30.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
317;150;1342;806;4324.295;1875.281;4.910912;True;False
Node;AmplifyShaderEditor.RangedFloatNode;2;-2044.435,178.0194;Inherit;False;Global;TB_OFFSET_X;TB_OFFSET_X;0;0;Create;True;0;0;False;0;False;0;43.82495;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-2041.869,256.2953;Inherit;False;Global;TB_OFFSET_Z;TB_OFFSET_Z;0;0;Create;True;0;0;False;0;False;0;-30.47505;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1;-2046.085,23.27846;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;5;-1701.818,251.1624;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-1701.818,120.2749;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1449.025,269.1274;Inherit;False;Global;TB_SCALE;TB_SCALE;0;0;Create;True;0;0;False;0;False;0;36.3501;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;7;-1464.424,157.488;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-1210.348,157.4881;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldPosInputsNode;24;-1148.381,821.0311;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SwizzleNode;29;-957.5012,815.7549;Inherit;False;FLOAT4;0;1;2;3;1;0;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1724.915,18.90106;Inherit;False;worldY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-921.2991,1053.385;Inherit;False;Property;_NoiseScale;NoiseScale;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-998.3306,91.36237;Inherit;True;Global;TB_DEPTH;TB_DEPTH;0;0;Create;True;0;0;False;0;False;-1;None;1390f3604c1415c488c6e88feefac35e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-893.8835,292.9284;Inherit;False;Global;TB_FARCLIP;TB_FARCLIP;0;0;Create;True;0;0;False;0;False;0;40;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-694.7205,865.6926;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;14;-619.6516,101.5702;Inherit;False;8;worldY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-639.2395,223.6175;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-390.6243,176.9082;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;25;-511.1399,837.5364;Inherit;True;Property;_Noise;Noise;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-403.7177,423.6154;Inherit;False;Property;_BlendThickness;BlendThickness;0;0;Create;True;0;0;False;0;False;0;0;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-375.5567,294.4353;Inherit;False;Global;TB_OFFSET_Y;TB_OFFSET_Y;0;0;Create;True;0;0;False;0;False;0;-19;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-221.8676,173.8947;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-54.32774,467.6386;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;17;178.7806,172.4356;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;19;376.4349,175.0887;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;283.5773,1.312209;Inherit;False;Property;_Falloff;Falloff;1;0;Create;True;0;0;False;0;False;0;0;0;30;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;20;608.5792,172.4356;Inherit;False;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;22;800.01,170.9787;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;31;862.4711,-391.4777;Inherit;True;Property;_TextureTerrain;TextureTerrain;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;23;994.6273,171.7841;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;32;866.5776,-196.4214;Inherit;True;Property;_TextureMesh;TextureMesh;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;1308.886,32.20044;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1711.754,-189.3594;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;TerrainBlending;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;2;0
WireConnection;5;1;3;0
WireConnection;6;0;1;1
WireConnection;6;1;1;3
WireConnection;7;0;6;0
WireConnection;7;1;5;0
WireConnection;9;0;7;0
WireConnection;9;1;4;0
WireConnection;29;0;24;0
WireConnection;8;0;1;2
WireConnection;10;1;9;0
WireConnection;26;0;29;0
WireConnection;26;1;28;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;13;0;14;0
WireConnection;13;1;12;0
WireConnection;25;1;26;0
WireConnection;15;0;13;0
WireConnection;15;1;16;0
WireConnection;27;0;18;0
WireConnection;27;1;25;0
WireConnection;17;0;15;0
WireConnection;17;1;27;0
WireConnection;19;0;17;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;22;0;20;0
WireConnection;23;0;22;0
WireConnection;30;0;31;0
WireConnection;30;1;32;0
WireConnection;30;2;23;0
WireConnection;0;0;30;0
ASEEND*/
//CHKSM=EF6E657B3B679E0141D21AE80ED49C0ED1DE12D1
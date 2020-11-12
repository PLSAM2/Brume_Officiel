// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PostProcess_Outline"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Intensity("Intensity", Float) = 1
		_Step("Step", Float) = 1

	}

	SubShader
	{
		LOD 0

		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float _Step;
			uniform float _Intensity;


			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				
				o.pos = UnityObjectToClipPos( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv0_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 localCenter138_g1 = uv0_MainTex;
				float4 break12 = ( _MainTex_TexelSize * _Step );
				float temp_output_2_0_g1 = break12.x;
				float localNegStepX156_g1 = -temp_output_2_0_g1;
				float temp_output_3_0_g1 = break12.y;
				float localStepY164_g1 = temp_output_3_0_g1;
				float2 appendResult14_g85 = (float2(localNegStepX156_g1 , localStepY164_g1));
				float4 tex2DNode16_g85 = tex2D( _MainTex, ( localCenter138_g1 + appendResult14_g85 ) );
				float temp_output_2_0_g85 = (tex2DNode16_g85).r;
				float temp_output_4_0_g85 = (tex2DNode16_g85).g;
				float temp_output_5_0_g85 = (tex2DNode16_g85).b;
				float localTopLeft172_g1 = ( sqrt( ( ( ( temp_output_2_0_g85 * temp_output_2_0_g85 ) + ( temp_output_4_0_g85 * temp_output_4_0_g85 ) ) + ( temp_output_5_0_g85 * temp_output_5_0_g85 ) ) ) * _Intensity );
				float2 appendResult14_g81 = (float2(localNegStepX156_g1 , 0.0));
				float4 tex2DNode16_g81 = tex2D( _MainTex, ( localCenter138_g1 + appendResult14_g81 ) );
				float temp_output_2_0_g81 = (tex2DNode16_g81).r;
				float temp_output_4_0_g81 = (tex2DNode16_g81).g;
				float temp_output_5_0_g81 = (tex2DNode16_g81).b;
				float localLeft173_g1 = ( sqrt( ( ( ( temp_output_2_0_g81 * temp_output_2_0_g81 ) + ( temp_output_4_0_g81 * temp_output_4_0_g81 ) ) + ( temp_output_5_0_g81 * temp_output_5_0_g81 ) ) ) * _Intensity );
				float localNegStepY165_g1 = -temp_output_3_0_g1;
				float2 appendResult14_g84 = (float2(localNegStepX156_g1 , localNegStepY165_g1));
				float4 tex2DNode16_g84 = tex2D( _MainTex, ( localCenter138_g1 + appendResult14_g84 ) );
				float temp_output_2_0_g84 = (tex2DNode16_g84).r;
				float temp_output_4_0_g84 = (tex2DNode16_g84).g;
				float temp_output_5_0_g84 = (tex2DNode16_g84).b;
				float localBottomLeft174_g1 = ( sqrt( ( ( ( temp_output_2_0_g84 * temp_output_2_0_g84 ) + ( temp_output_4_0_g84 * temp_output_4_0_g84 ) ) + ( temp_output_5_0_g84 * temp_output_5_0_g84 ) ) ) * _Intensity );
				float localStepX160_g1 = temp_output_2_0_g1;
				float2 appendResult14_g76 = (float2(localStepX160_g1 , localStepY164_g1));
				float4 tex2DNode16_g76 = tex2D( _MainTex, ( localCenter138_g1 + appendResult14_g76 ) );
				float temp_output_2_0_g76 = (tex2DNode16_g76).r;
				float temp_output_4_0_g76 = (tex2DNode16_g76).g;
				float temp_output_5_0_g76 = (tex2DNode16_g76).b;
				float localTopRight177_g1 = ( sqrt( ( ( ( temp_output_2_0_g76 * temp_output_2_0_g76 ) + ( temp_output_4_0_g76 * temp_output_4_0_g76 ) ) + ( temp_output_5_0_g76 * temp_output_5_0_g76 ) ) ) * _Intensity );
				float2 appendResult14_g79 = (float2(localStepX160_g1 , 0.0));
				float4 tex2DNode16_g79 = tex2D( _MainTex, ( localCenter138_g1 + appendResult14_g79 ) );
				float temp_output_2_0_g79 = (tex2DNode16_g79).r;
				float temp_output_4_0_g79 = (tex2DNode16_g79).g;
				float temp_output_5_0_g79 = (tex2DNode16_g79).b;
				float localRight178_g1 = ( sqrt( ( ( ( temp_output_2_0_g79 * temp_output_2_0_g79 ) + ( temp_output_4_0_g79 * temp_output_4_0_g79 ) ) + ( temp_output_5_0_g79 * temp_output_5_0_g79 ) ) ) * _Intensity );
				float2 appendResult14_g80 = (float2(localStepX160_g1 , localNegStepY165_g1));
				float4 tex2DNode16_g80 = tex2D( _MainTex, ( localCenter138_g1 + appendResult14_g80 ) );
				float temp_output_2_0_g80 = (tex2DNode16_g80).r;
				float temp_output_4_0_g80 = (tex2DNode16_g80).g;
				float temp_output_5_0_g80 = (tex2DNode16_g80).b;
				float localBottomRight179_g1 = ( sqrt( ( ( ( temp_output_2_0_g80 * temp_output_2_0_g80 ) + ( temp_output_4_0_g80 * temp_output_4_0_g80 ) ) + ( temp_output_5_0_g80 * temp_output_5_0_g80 ) ) ) * _Intensity );
				float temp_output_133_0_g1 = ( ( localTopLeft172_g1 + ( localLeft173_g1 * 2 ) + localBottomLeft174_g1 + -localTopRight177_g1 + ( localRight178_g1 * -2 ) + -localBottomRight179_g1 ) / 6.0 );
				float2 appendResult14_g83 = (float2(0.0 , localStepY164_g1));
				float4 tex2DNode16_g83 = tex2D( _MainTex, ( localCenter138_g1 + appendResult14_g83 ) );
				float temp_output_2_0_g83 = (tex2DNode16_g83).r;
				float temp_output_4_0_g83 = (tex2DNode16_g83).g;
				float temp_output_5_0_g83 = (tex2DNode16_g83).b;
				float localTop175_g1 = ( sqrt( ( ( ( temp_output_2_0_g83 * temp_output_2_0_g83 ) + ( temp_output_4_0_g83 * temp_output_4_0_g83 ) ) + ( temp_output_5_0_g83 * temp_output_5_0_g83 ) ) ) * _Intensity );
				float2 appendResult14_g82 = (float2(0.0 , localNegStepY165_g1));
				float4 tex2DNode16_g82 = tex2D( _MainTex, ( localCenter138_g1 + appendResult14_g82 ) );
				float temp_output_2_0_g82 = (tex2DNode16_g82).r;
				float temp_output_4_0_g82 = (tex2DNode16_g82).g;
				float temp_output_5_0_g82 = (tex2DNode16_g82).b;
				float localBottom176_g1 = ( sqrt( ( ( ( temp_output_2_0_g82 * temp_output_2_0_g82 ) + ( temp_output_4_0_g82 * temp_output_4_0_g82 ) ) + ( temp_output_5_0_g82 * temp_output_5_0_g82 ) ) ) * _Intensity );
				float temp_output_135_0_g1 = ( ( -localTopLeft172_g1 + ( localTop175_g1 * -2 ) + -localTopRight177_g1 + localBottomLeft174_g1 + ( localBottom176_g1 * 2 ) + localBottomRight179_g1 ) / 6.0 );
				float temp_output_111_0_g1 = sqrt( ( ( temp_output_133_0_g1 * temp_output_133_0_g1 ) + ( temp_output_135_0_g1 * temp_output_135_0_g1 ) ) );
				float3 appendResult113_g1 = (float3(temp_output_111_0_g1 , temp_output_111_0_g1 , temp_output_111_0_g1));
				

				finalColor = float4( appendResult113_g1 , 0.0 );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18301
1920;0;1920;1019;2187.453;807.1392;1.760107;True;False
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;9;-1421.346,78.39031;Inherit;False;0;0;_MainTex_TexelSize;Pass;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1407.946,337.6903;Inherit;False;Property;_Step;Step;17;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-1200.346,274.6903;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;13;-1315.732,551.1638;Inherit;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;12;-1031.732,275.1638;Inherit;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-1015.732,524.1638;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;8;-696.9872,378.0075;Inherit;False;SobelMain;0;;1;481788033fe47cd4893d0d4673016cbc;0;4;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT2;0,0;False;1;SAMPLER2D;0.0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;2;PostProcess_Outline;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;12;0;10;0
WireConnection;14;2;13;0
WireConnection;8;2;12;0
WireConnection;8;3;12;1
WireConnection;8;4;14;0
WireConnection;8;1;13;0
WireConnection;1;0;8;0
ASEEND*/
//CHKSM=331E7D3E7E9B8D6CC2F4E9A379F766C850969A5A
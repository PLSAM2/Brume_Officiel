// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Particle/Alpha Blended Soft Tex"
{
	Properties
	{
		_TexSoftFactor("Tex Soft Factor", Range( 0 , 3)) = 0
		_MainTex("Main Tex", 2D) = "white" {}
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
				UNITY_VERTEX_OUTPUT_STEREO
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			uniform float4 _TintColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform half _TexSoftFactor;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float2 uv_MainTex = i.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp_cast_0 = (_TexSoftFactor).xxxx;
				float4 temp_output_21_0 = ( ( _TintColor * pow( tex2D( _MainTex, uv_MainTex ) , temp_cast_0 ) ) * i.ase_color );
				
				
				finalColor = temp_output_21_0;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16200
890;430;1227;681;441.5872;323.0989;1.911093;True;False
Node;AmplifyShaderEditor.SamplerNode;16;-353.4004,-182.338;Float;True;Property;_MainTex;Main Tex;1;0;Create;True;0;0;False;0;None;7aa8f4a30cfcb6646b664af4191570b5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-342.9,21.32786;Half;False;Property;_TexSoftFactor;Tex Soft Factor;0;0;Create;True;0;0;False;0;0;0.81;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;19;-11.87262,-101.0876;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;17;-7.741274,-348.9706;Float;False;Property;_TintColor;Tint Color;2;1;[HDR];Create;True;0;0;False;0;0,0,0,0;1.029412,1.549696,5,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;237.3875,-156.1727;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;20;54.73734,73.52586;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;23;584.6702,-72.74557;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;21;454.9736,-65.28223;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;229.2066,47.65308;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;24;812.0901,-32.61259;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;15;977.8138,-32.93813;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/IFX/Particle/Alpha Blended Soft Tex;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;5;False;-1;1;False;-1;True;0;False;-1;0;False;-1;True;False;True;2;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;False;-1;True;False;0;False;-1;0;False;-1;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;19;0;16;0
WireConnection;19;1;5;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;23;0;21;0
WireConnection;21;0;18;0
WireConnection;21;1;20;0
WireConnection;25;0;20;0
WireConnection;24;0;23;0
WireConnection;24;3;20;4
WireConnection;15;0;21;0
ASEEND*/
//CHKSM=68D17890D51C1F4EF15E2D25E0686ED6CF440402
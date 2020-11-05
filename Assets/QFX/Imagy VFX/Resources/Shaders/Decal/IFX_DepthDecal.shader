// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "QFX/IFX/Decal/DepthDecal"
{
	Properties
	{
		_Size("Size", Range( 0 , 1)) = 1
		_RampFalloff("Ramp Falloff", Range( 0.01 , 6)) = 5
		_MainTex("Main Tex", 2D) = "white" {}
		[HDR]_TintColor("Tint Color", Color) = (0,0,0,0)
		[Toggle]_BlendMask("Blend Mask", Float) = 0
		_MaskMap("Mask Map", 2D) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest Always
		
		

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			uniform float _BlendMask;
			uniform float4 _TintColor;
			uniform sampler2D _MainTex;
			uniform sampler2D _CameraDepthTexture;
			uniform float _Size;
			uniform float _RampFalloff;
			uniform sampler2D _MaskMap;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord = screenPos;
				
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float4 screenPos = i.ase_texcoord;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
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
				float4 temp_output_249_0 = ( mul( unity_WorldToObject, temp_output_244_0 ) + 0.5 );
				float4 temp_output_251_0 = ( _TintColor * tex2D( _MainTex, temp_output_249_0.xy, float2( 0,0 ), float2( 0,0 ) ) );
				float4 transform114 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
				float3 ase_objectScale = float3( length( unity_ObjectToWorld[ 0 ].xyz ), length( unity_ObjectToWorld[ 1 ].xyz ), length( unity_ObjectToWorld[ 2 ].xyz ) );
				float temp_output_278_0 = ( ( 1.0 - saturate( pow( ( length( abs( (( transform114 - temp_output_244_0 )).xyz ) ) / ( max( max( ase_objectScale.x , ase_objectScale.y ) , ase_objectScale.z ) * 0.5 * _Size ) ) , _RampFalloff ) ) ) * tex2D( _MaskMap, temp_output_249_0.xy ).a * _TintColor.a );
				float4 appendResult280 = (float4((temp_output_251_0).rgb , temp_output_278_0));
				
				
				finalColor = lerp(appendResult280,( temp_output_251_0 * temp_output_278_0 ),_BlendMask);
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16200
180;272;1043;649;-3016.879;198.8233;1.888996;True;False
Node;AmplifyShaderEditor.CommentaryNode;219;1371.035,430.4351;Float;False;339.352;234.4789;Object pivot position in world space;1;114;;0,0,0,1;0;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;114;1421.035,480.4351;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;244;1427.103,294.9467;Float;False;Reconstruct World Position From Depth;0;;1;e7094bcbcc80eb140b2a3dbe6a861de8;0;0;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;220;1675.14,720.5161;Float;False;527.0399;229;Make the effect scale with the sphere;3;152;154;155;;0,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;113;1850.315,480.0514;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ObjectScaleNode;152;1725.14,770.5161;Float;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMaxOpNode;154;1923.767,770.5155;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;160;2019.684,492.7632;Float;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;216;1922.201,1004.83;Float;False;Property;_Size;Size;2;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;155;2053.176,817.9933;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;158;2253.102,498.1834;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;2254.979,824.6212;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;159;2400,496;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectMatrix;274;1687.58,135.1007;Float;False;0;1;FLOAT4x4;0
Node;AmplifyShaderEditor.RangedFloatNode;164;2512,672;Float;False;Property;_RampFalloff;Ramp Falloff;3;0;Create;True;0;0;False;0;5;6;0.01;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;148;2560,496;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;1955.612,177.42;Float;False;2;2;0;FLOAT4x4;0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;250;2251.57,354.189;Float;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;163;2736,496;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;249;2453.517,246.4837;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;187;2944,496;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;252;3106.855,8.825776;Float;False;Property;_TintColor;Tint Color;5;1;[HDR];Create;True;0;0;False;0;0,0,0,0;3,0,1.675863,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;222;3038.239,225.3191;Float;True;Property;_MainTex;Main Tex;4;0;Create;True;0;0;False;0;None;a05394891d5ae2a4e9b21ada39fa90a1;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;184;3120,496;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;277;2900.824,722.4365;Float;True;Property;_MaskMap;Mask Map;7;0;Create;True;0;0;False;0;None;a616776311244cf40a3bedf5108a59c7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;251;3511.026,136.5275;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;278;3530.034,425.8254;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;281;3739.793,210.8687;Float;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;280;4062.177,266.9198;Float;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;283;4057.715,415.1007;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ToggleSwitchNode;285;4259.84,335.7625;Float;False;Property;_BlendMask;Blend Mask;6;0;Create;True;0;0;False;0;0;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;279;4515.646,345.9972;Float;False;True;2;Float;ASEMaterialInspector;0;1;QFX/IFX/Decal/DepthDecal;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;0;5;False;-1;10;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;7;False;-1;True;False;0;False;-1;0;False;-1;True;1;RenderType=Transparent=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;113;0;114;0
WireConnection;113;1;244;0
WireConnection;154;0;152;1
WireConnection;154;1;152;2
WireConnection;160;0;113;0
WireConnection;155;0;154;0
WireConnection;155;1;152;3
WireConnection;158;0;160;0
WireConnection;156;0;155;0
WireConnection;156;2;216;0
WireConnection;159;0;158;0
WireConnection;148;0;159;0
WireConnection;148;1;156;0
WireConnection;248;0;274;0
WireConnection;248;1;244;0
WireConnection;163;0;148;0
WireConnection;163;1;164;0
WireConnection;249;0;248;0
WireConnection;249;1;250;0
WireConnection;187;0;163;0
WireConnection;222;1;249;0
WireConnection;184;0;187;0
WireConnection;277;1;249;0
WireConnection;251;0;252;0
WireConnection;251;1;222;0
WireConnection;278;0;184;0
WireConnection;278;1;277;4
WireConnection;278;2;252;4
WireConnection;281;0;251;0
WireConnection;280;0;281;0
WireConnection;280;3;278;0
WireConnection;283;0;251;0
WireConnection;283;1;278;0
WireConnection;285;0;280;0
WireConnection;285;1;283;0
WireConnection;279;0;285;0
ASEEND*/
//CHKSM=99CCB7F2123A5EE897A0823032F623564A93E13D
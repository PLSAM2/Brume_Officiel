// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpellRecover"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[ASEBegin]_blurclouds("blurclouds", 2D) = "white" {}
		_Float2("Float 2", Float) = 1
		_SpellRecoverSparks("SpellRecoverSparks", 2D) = "white" {}
		_Disparition("Disparition", Range( 0 , 1)) = 0
		_Float5("Float 5", Float) = 0.1
		[ASEEnd]_Color0("Color 0", Color) = (1,0.7771496,0.4669811,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }

		Cull Off
		HLSLINCLUDE
		#pragma target 2.0
		ENDHLSL

		
		Pass
		{
			Name "Unlit"
			

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA

			#define _SURFACE_TYPE_TRANSPARENT 1
			#define SHADERPASS_SPRITEUNLIT

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			

			sampler2D _SpellRecoverSparks;
			sampler2D _blurclouds;
			CBUFFER_START( UnityPerMaterial )
			float4 _Color0;
			float4 _SpellRecoverSparks_ST;
			float _Disparition;
			float _Float5;
			float _Float2;
			CBUFFER_END


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			float4 _RendererColor;

			
			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.normal = v.normal;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.vertex.xyz );

				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.clipPos = vertexInput.positionCS;

				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_SpellRecoverSparks = IN.texCoord0.xy * _SpellRecoverSparks_ST.xy + _SpellRecoverSparks_ST.zw;
				float smoothstepResult25 = smoothstep( _Disparition , ( _Disparition + _Float5 ) , tex2D( _SpellRecoverSparks, uv_SpellRecoverSparks ).r);
				float2 temp_cast_0 = (_Float2).xx;
				float2 texCoord16 = IN.texCoord0.xy * temp_cast_0 + float2( 0,0 );
				float2 panner18 = ( 1.0 * _Time.y * float2( 0.2,0 ) + texCoord16);
				float temp_output_30_0 = saturate( ( smoothstepResult25 / tex2D( _blurclouds, panner18 ).r ) );
				
				float4 Color = ( _Color0 * temp_output_30_0 );

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D( _AlphaTex, sampler_AlphaTex, IN.texCoord0.xy );
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture );
				#endif

				Color *= IN.color;

				return Color;
			}

			ENDHLSL
		}
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18707
-1920;0;1920;1019;2618.503;1334.215;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;19;-1587.463,-557.3117;Inherit;False;Property;_Float2;Float 2;1;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;16;-1436.663,-576.9117;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-1640.747,-864.3916;Inherit;False;Property;_Disparition;Disparition;3;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1240.16,-732.5248;Inherit;False;Property;_Float5;Float 5;4;0;Create;True;0;0;False;0;False;0.1;1.81;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;17;-1368.264,-384.3118;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;False;0;False;0.2,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;21;-1384.152,-1223.185;Inherit;True;Property;_SpellRecoverSparks;SpellRecoverSparks;2;0;Create;True;0;0;False;0;False;-1;80e8a43671735a543ac031d2a3eaa0f3;0b0ccf81c5bea6a4a8051df906fff43d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;18;-1188.465,-490.5117;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-1078.16,-751.5248;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;15;-978.0985,-520.1093;Inherit;True;Property;_blurclouds;blurclouds;0;0;Create;True;0;0;False;0;False;-1;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;25;-915.5963,-878.7023;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-618.2209,-662.9937;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;30;-364.3729,-601.4178;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;40;-101.088,-749.9556;Inherit;False;Property;_Color0;Color 0;6;0;Create;True;0;0;False;0;False;1,0.7771496,0.4669811,0;1,0.7054315,0.2971698,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;-11.27325,-387.3743;Inherit;False;Property;_Float1;Float 1;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;140.331,-615.152;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;151.3803,-454.0827;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;41;444.4482,-477.8311;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;14;SpellRecover;cf964e524c8e69742b1d21fbe2ebcc4a;True;Unlit;0;0;Unlit;3;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;1;Vertex Position;1;0;1;True;False;;False;0
WireConnection;16;0;19;0
WireConnection;18;0;16;0
WireConnection;18;2;17;0
WireConnection;28;0;26;0
WireConnection;28;1;27;0
WireConnection;15;1;18;0
WireConnection;25;0;21;1
WireConnection;25;1;26;0
WireConnection;25;2;28;0
WireConnection;29;0;25;0
WireConnection;29;1;15;1
WireConnection;30;0;29;0
WireConnection;39;0;40;0
WireConnection;39;1;30;0
WireConnection;37;0;30;0
WireConnection;37;1;38;0
WireConnection;41;1;39;0
ASEEND*/
//CHKSM=F00B8767575D301CD98D519DEC8A2A494D2CD246
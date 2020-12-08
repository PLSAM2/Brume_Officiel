// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VegetationShader"
{
	Properties
	{
		_InOutBrume("InOutBrume", Range( 0 , 1)) = 0
		_Object_Albedo_Texture("Object_Albedo_Texture", 2D) = "white" {}
		_CustomAlphaMask("CustomAlphaMask?", Range( 0 , 1)) = 1
		_Object_Alpha_Texture("Object_Alpha_Texture", 2D) = "white" {}
		_WindVertexDisplacement("WindVertexDisplacement?", Range( 0 , 1)) = 0
		_Wind_Noise_Texture("Wind_Noise_Texture", 2D) = "white" {}
		_Wind_Texture_Tiling("Wind_Texture_Tiling", Float) = 0.5
		_Wind_Direction("Wind_Direction", Float) = 1
		_Wind_Density("Wind_Density", Float) = 0.2
		_Wind_Strength("Wind_Strength", Float) = 2
		_WindWave_Speed("WindWave_Speed", Vector) = (0.1,0,0,0)
		_WindWave_Min_Speed("WindWave_Min_Speed", Vector) = (0.05,0,0,0)
		_Wave_Speed("Wave_Speed", Float) = 0
		_OutBrume_ColorCorrection("OutBrume_ColorCorrection", Color) = (1,1,1,0)
		_WindDirection("WindDirection", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform float _WindDirection;
		uniform sampler2D _Wind_Noise_Texture;
		uniform float _Wind_Texture_Tiling;
		uniform float _Wave_Speed;
		uniform float2 _WindWave_Speed;
		uniform float2 _WindWave_Min_Speed;
		uniform float _Wind_Direction;
		uniform float _Wind_Density;
		uniform float _Wind_Strength;
		uniform float _WindVertexDisplacement;
		uniform sampler2D _Object_Albedo_Texture;
		uniform float4 _Object_Albedo_Texture_ST;
		uniform float4 _OutBrume_ColorCorrection;
		uniform float _InOutBrume;
		uniform sampler2D _Object_Alpha_Texture;
		uniform float4 _Object_Alpha_Texture_ST;
		uniform float _CustomAlphaMask;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 temp_cast_0 = (0.0).xxx;
			float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 panner10 = ( ( ( _CosTime.w + _Time.y ) * _Wave_Speed ) * _WindWave_Speed + ase_worldPos.xy);
			float2 panner9 = ( 1.0 * _Time.y * _WindWave_Min_Speed + ase_worldPos.xy);
			float2 uv_TexCoord17 = v.texcoord.xy * temp_cast_1 + ( ( panner10 + panner9 ) * _Wind_Direction );
			float4 temp_cast_4 = (( _Wind_Density * _SinTime.w )).xxxx;
			float4 temp_cast_5 = (0.0).xxxx;
			float4 lerpResult124 = lerp( ( ( tex2Dlod( _Wind_Noise_Texture, float4( uv_TexCoord17, 0, 0.0) ) - temp_cast_4 ) * _Wind_Strength ) , temp_cast_5 , v.color.r);
			float3 worldToObjDir127 = mul( unity_WorldToObject, float4( lerpResult124.rgb, 0 ) ).xyz;
			float3 rotatedValue134 = RotateAroundAxis( float3( 0,0,0 ), worldToObjDir127, float3( 0,0,0 ), _WindDirection );
			float3 WindVertexDisplacement32 = rotatedValue134;
			float3 lerpResult50 = lerp( temp_cast_0 , WindVertexDisplacement32 , _WindVertexDisplacement);
			v.vertex.xyz += lerpResult50;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_Object_Albedo_Texture = i.uv_texcoord * _Object_Albedo_Texture_ST.xy + _Object_Albedo_Texture_ST.zw;
			float4 tex2DNode35 = tex2D( _Object_Albedo_Texture, uv_Object_Albedo_Texture );
			float4 Object_Albedo_Texture37 = tex2DNode35;
			float4 EndOutBrume54 = ( Object_Albedo_Texture37 * _OutBrume_ColorCorrection );
			float grayscale59 = Luminance(Object_Albedo_Texture37.rgb);
			float EndInBrume53 = grayscale59;
			float4 temp_cast_1 = (EndInBrume53).xxxx;
			float4 lerpResult42 = lerp( EndOutBrume54 , temp_cast_1 , _InOutBrume);
			o.Emission = lerpResult42.rgb;
			float4 temp_cast_3 = (tex2DNode35.a).xxxx;
			float2 uv_Object_Alpha_Texture = i.uv_texcoord * _Object_Alpha_Texture_ST.xy + _Object_Alpha_Texture_ST.zw;
			float4 lerpResult61 = lerp( temp_cast_3 , tex2D( _Object_Alpha_Texture, uv_Object_Alpha_Texture ) , _CustomAlphaMask);
			float4 Object_Opacity_Texture29 = lerpResult61;
			o.Alpha = Object_Opacity_Texture29.r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
1920;0;1920;1019;8675.683;3592.135;5.345736;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-5149.841,-1672.024;Inherit;False;4722.003;799.1631;VertexColor WindDisplacement;31;23;22;21;20;19;17;15;18;16;13;14;11;12;9;10;7;6;8;5;4;2;3;122;128;125;126;124;127;32;107;134;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosTime;3;-5065.299,-1396.074;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2;-5082.949,-1194.205;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-4657.008,-1153.774;Inherit;False;Property;_Wave_Speed;Wave_Speed;13;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-4902.949,-1245.205;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;122;-4561.71,-1531.114;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;128;-4118.385,-1213.021;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;8;-4163.807,-1054.542;Inherit;False;Property;_WindWave_Min_Speed;WindWave_Min_Speed;12;0;Create;True;0;0;False;0;False;0.05,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;7;-4577.145,-1386.356;Inherit;False;Property;_WindWave_Speed;WindWave_Speed;11;0;Create;True;0;0;False;0;False;0.1,0;0.15,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-4465.962,-1231.299;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;10;-4319.349,-1405.483;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;9;-3907.192,-1072.658;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-3645.932,-1244.621;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3624.805,-1119.201;Inherit;False;Property;_Wind_Direction;Wind_Direction;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3549.423,-1403.651;Inherit;False;Property;_Wind_Texture_Tiling;Wind_Texture_Tiling;7;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-3435.803,-1236.202;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-2904.087,-1218.403;Inherit;False;Property;_Wind_Density;Wind_Density;9;0;Create;True;0;0;False;0;False;0.2;7.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3150.994,-1613.266;Inherit;True;Property;_Wind_Noise_Texture;Wind_Noise_Texture;6;0;Create;True;0;0;False;0;False;1cb5d7a8b79999d4b8356e740bbf6667;0fe9101c6b6e1124b90b120ceebd6cba;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SinTimeNode;15;-2872.909,-1126.044;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-3237.723,-1394.441;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;20;-2907.994,-1423.265;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2704.495,-1163.2;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;65;-5144.591,-2401.137;Inherit;False;954.9209;631.1599;Textures;6;35;60;62;61;29;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-2444.936,-1415.397;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2241.843,-1346.88;Inherit;False;Property;_Wind_Strength;Wind_Strength;10;0;Create;True;0;0;False;0;False;2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-5094.591,-2351.137;Inherit;True;Property;_Object_Albedo_Texture;Object_Albedo_Texture;1;0;Create;True;0;0;False;0;False;-1;None;f7f6c297b81bce748a988b58802b956a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-2066.842,-1414.88;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-1791.217,-1322.528;Inherit;False;Constant;_Float0;Float 0;67;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;126;-1807.667,-1228.823;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;63;-3176.73,-688.1691;Inherit;False;828.718;168.3489;InBrume;3;58;59;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;64;-4119.679,-736.2618;Inherit;False;725.9001;347.0919;OutBrume;4;55;57;56;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;124;-1593.311,-1413.493;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-4682.577,-2349.813;Inherit;False;Object_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-1275.739,-1551.253;Inherit;False;Property;_WindDirection;WindDirection;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;57;-4069.679,-601.1699;Inherit;False;Property;_OutBrume_ColorCorrection;OutBrume_ColorCorrection;14;0;Create;True;0;0;False;0;False;1,1,1,0;0.4509804,0.3098033,0.2627445,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TransformDirectionNode;127;-1412.326,-1418.927;Inherit;False;World;Object;False;Fast;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;58;-3126.73,-635.8202;Inherit;False;37;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-4055.949,-686.2618;Inherit;False;37;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;59;-2863.072,-636.4443;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;-5088.035,-2137.977;Inherit;True;Property;_Object_Alpha_Texture;Object_Alpha_Texture;4;0;Create;True;0;0;False;0;False;-1;None;f7f6c297b81bce748a988b58802b956a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-3773.506,-681.2288;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RotateAboutAxisNode;134;-1099.282,-1266.579;Inherit;False;False;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-4922.034,-1885.973;Inherit;False;Property;_CustomAlphaMask;CustomAlphaMask?;3;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-3617.778,-684.9728;Inherit;False;EndOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-2572.012,-638.1691;Inherit;False;EndInBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;61;-4623.029,-2090.975;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-673.7217,-1372.579;Inherit;False;WindVertexDisplacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;66;-301.7192,-1688.37;Inherit;False;1045.663;800.4343;Final Output;10;46;38;39;48;52;50;42;0;40;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-232.2192,-1434.106;Inherit;False;Property;_InOutBrume;InOutBrume;0;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-206.1193,-1601.97;Inherit;False;54;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-213.5124,-1102.837;Inherit;False;32;WindVertexDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;26;-5120.19,-767.8849;Inherit;False;836.2999;385.9216;Opacity;5;34;33;31;28;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-194.7382,-1521.569;Inherit;False;53;EndInBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-211.8532,-1014.336;Inherit;False;Property;_WindVertexDisplacement;WindVertexDisplacement?;5;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-4462.667,-2096.656;Inherit;False;Object_Opacity_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-97.90017,-1194.658;Inherit;False;Constant;_Float4;Float 4;68;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-5029.902,-688.1649;Inherit;False;29;Object_Opacity_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-4968.25,-588.6887;Inherit;False;Constant;_Float6;Float 6;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-4507.891,-638.3398;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-5051.83,-495.7807;Inherit;False;Property;_Opacity;Opacity?;2;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;68.04648,-1297.47;Inherit;False;29;Object_Opacity_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;70.46782,-1597.525;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;50;110.9035,-1122.855;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;33;-4710.363,-633.3137;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;452.5438,-1470.252;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;VegetationShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;4
WireConnection;5;1;2;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;10;0;122;0
WireConnection;10;2;7;0
WireConnection;10;1;6;0
WireConnection;9;0;128;0
WireConnection;9;2;8;0
WireConnection;12;0;10;0
WireConnection;12;1;9;0
WireConnection;14;0;12;0
WireConnection;14;1;11;0
WireConnection;17;0;13;0
WireConnection;17;1;14;0
WireConnection;20;0;18;0
WireConnection;20;1;17;0
WireConnection;19;0;16;0
WireConnection;19;1;15;4
WireConnection;21;0;20;0
WireConnection;21;1;19;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;124;0;23;0
WireConnection;124;1;125;0
WireConnection;124;2;126;1
WireConnection;37;0;35;0
WireConnection;127;0;124;0
WireConnection;59;0;58;0
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;134;1;107;0
WireConnection;134;3;127;0
WireConnection;54;0;56;0
WireConnection;53;0;59;0
WireConnection;61;0;35;4
WireConnection;61;1;60;0
WireConnection;61;2;62;0
WireConnection;32;0;134;0
WireConnection;29;0;61;0
WireConnection;34;0;33;0
WireConnection;42;0;39;0
WireConnection;42;1;38;0
WireConnection;42;2;40;0
WireConnection;50;0;46;0
WireConnection;50;1;48;0
WireConnection;50;2;47;0
WireConnection;33;0;36;0
WireConnection;33;1;31;0
WireConnection;33;2;28;0
WireConnection;0;2;42;0
WireConnection;0;9;52;0
WireConnection;0;11;50;0
ASEEND*/
//CHKSM=32B683793E0B85DF16BA6F5C028005FC75A7BD7E
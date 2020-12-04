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
			float2 uv_texcoord;
		};

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

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 temp_cast_0 = (0.0).xxxx;
			float2 temp_cast_1 = (_Wind_Texture_Tiling).xx;
			float2 panner10 = ( ( ( _CosTime.w + _Time.y ) * _Wave_Speed ) * _WindWave_Speed + float2( 0,0 ));
			float2 panner9 = ( 1.0 * _Time.y * _WindWave_Min_Speed + float2( 0,0 ));
			float2 uv_TexCoord17 = v.texcoord.xy * temp_cast_1 + ( ( panner10 + panner9 ) * _Wind_Direction );
			float4 temp_cast_2 = (( _Wind_Density * _SinTime.w )).xxxx;
			float4 temp_cast_3 = (0.0).xxxx;
			float4 lerpResult30 = lerp( ( ( ( tex2Dlod( _Wind_Noise_Texture, float4( uv_TexCoord17, 0, 0.0) ) - temp_cast_2 ) * _Wind_Strength ) + float4( 0,0,0,0 ) ) , temp_cast_3 , v.color);
			float4 WindVertexDisplacement32 = lerpResult30;
			float4 lerpResult50 = lerp( temp_cast_0 , WindVertexDisplacement32 , _WindVertexDisplacement);
			v.vertex.xyz += lerpResult50.rgb;
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
0;0;1920;1019;7708.57;3745.964;3.59503;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-4462.217,-1667.194;Inherit;False;3603.017;815.9397;VertexColor WindDisplacement;27;32;30;27;25;24;23;22;21;20;19;18;17;16;15;14;13;12;11;10;9;8;7;6;5;4;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CosTime;3;-4394.567,-1512.786;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;2;-4412.217,-1310.917;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3986.276,-1270.486;Inherit;False;Property;_Wave_Speed;Wave_Speed;13;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-4232.217,-1361.917;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;8;-4004.888,-1015.255;Inherit;False;Property;_WindWave_Min_Speed;WindWave_Min_Speed;12;0;Create;True;0;0;False;0;False;0.05,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-3795.229,-1348.011;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;7;-3906.411,-1503.068;Inherit;False;Property;_WindWave_Speed;WindWave_Speed;11;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;9;-3748.271,-1033.371;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;10;-3648.616,-1522.195;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-3402.876,-1249.154;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-3381.75,-1123.734;Inherit;False;Property;_Wind_Direction;Wind_Direction;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3305.368,-1408.184;Inherit;False;Property;_Wind_Texture_Tiling;Wind_Texture_Tiling;7;0;Create;True;0;0;False;0;False;0.5;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-3192.748,-1240.735;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinTimeNode;15;-2693.835,-1113.972;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-2725.013,-1206.331;Inherit;False;Property;_Wind_Density;Wind_Density;9;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3022.92,-1617.194;Inherit;True;Property;_Wind_Noise_Texture;Wind_Noise_Texture;6;0;Create;True;0;0;False;0;False;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;-3067.668,-1394.974;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;65;-4455.088,-2318.397;Inherit;False;954.9209;631.1599;Textures;6;35;60;62;61;29;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-2525.421,-1151.128;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-2779.92,-1427.193;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;21;-2316.862,-1419.325;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2113.772,-1350.808;Inherit;False;Property;_Wind_Strength;Wind_Strength;10;0;Create;True;0;0;False;0;False;2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-4405.088,-2268.397;Inherit;True;Property;_Object_Albedo_Texture;Object_Albedo_Texture;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;63;-2804.398,-819.1756;Inherit;False;828.718;168.3489;InBrume;3;58;59;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;64;-3581.864,-819.0028;Inherit;False;725.9001;347.0919;OutBrume;4;55;57;56;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-1938.772,-1418.808;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;-3993.074,-2267.073;Inherit;False;Object_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-1677.641,-1418.858;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1633.354,-1563.401;Inherit;False;Constant;_Float1;Float 1;67;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;27;-1636.702,-1151.788;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;55;-3518.134,-769.0028;Inherit;False;37;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;57;-3531.864,-683.9109;Inherit;False;Property;_OutBrume_ColorCorrection;OutBrume_ColorCorrection;14;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;58;-2754.398,-766.8267;Inherit;False;37;Object_Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-4232.531,-1803.233;Inherit;False;Property;_CustomAlphaMask;CustomAlphaMask?;3;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;-4398.532,-2055.237;Inherit;True;Property;_Object_Alpha_Texture;Object_Alpha_Texture;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-3235.691,-763.9697;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;59;-2490.74,-767.4508;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;30;-1371.604,-1524.584;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;61;-3933.526,-2008.235;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;54;-3079.963,-767.7138;Inherit;False;EndOutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;66;-301.7192,-1688.37;Inherit;False;1045.663;800.4343;Final Output;10;46;38;39;48;52;50;42;0;40;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-2199.68,-769.1756;Inherit;False;EndInBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-1141.199,-1534.695;Inherit;False;WindVertexDisplacement;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-3773.163,-2013.916;Inherit;False;Object_Opacity_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;26;-4458.268,-836.8357;Inherit;False;836.2999;385.9216;Opacity;5;34;33;31;28;36;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-241.7532,-1003.936;Inherit;False;Property;_WindVertexDisplacement;WindVertexDisplacement?;5;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-214.2383,-1557.969;Inherit;False;53;EndInBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;-225.6194,-1638.37;Inherit;False;54;EndOutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-127.8002,-1184.258;Inherit;False;Constant;_Float4;Float 4;68;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-251.7193,-1470.506;Inherit;False;Property;_InOutBrume;InOutBrume;0;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;48;-243.4124,-1092.437;Inherit;False;32;WindVertexDisplacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;34;-3845.967,-707.2906;Inherit;False;Opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;36;-4367.98,-757.1157;Inherit;False;29;Object_Opacity_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-4389.907,-564.7315;Inherit;False;Property;_Opacity;Opacity?;2;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-4306.327,-657.6395;Inherit;False;Constant;_Float6;Float 6;82;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;104.4465,-1289.67;Inherit;False;29;Object_Opacity_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;50;81.00348,-1112.455;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;42;50.96775,-1633.925;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;33;-4048.441,-702.2645;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;488.9437,-1462.452;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;VegetationShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;0;3;4
WireConnection;5;1;2;0
WireConnection;6;0;5;0
WireConnection;6;1;4;0
WireConnection;9;2;8;0
WireConnection;10;2;7;0
WireConnection;10;1;6;0
WireConnection;12;0;10;0
WireConnection;12;1;9;0
WireConnection;14;0;12;0
WireConnection;14;1;11;0
WireConnection;17;0;13;0
WireConnection;17;1;14;0
WireConnection;19;0;16;0
WireConnection;19;1;15;4
WireConnection;20;0;18;0
WireConnection;20;1;17;0
WireConnection;21;0;20;0
WireConnection;21;1;19;0
WireConnection;23;0;21;0
WireConnection;23;1;22;0
WireConnection;37;0;35;0
WireConnection;24;0;23;0
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;59;0;58;0
WireConnection;30;0;24;0
WireConnection;30;1;25;0
WireConnection;30;2;27;0
WireConnection;61;0;35;4
WireConnection;61;1;60;0
WireConnection;61;2;62;0
WireConnection;54;0;56;0
WireConnection;53;0;59;0
WireConnection;32;0;30;0
WireConnection;29;0;61;0
WireConnection;34;0;33;0
WireConnection;50;0;46;0
WireConnection;50;1;48;0
WireConnection;50;2;47;0
WireConnection;42;0;39;0
WireConnection;42;1;38;0
WireConnection;42;2;40;0
WireConnection;33;0;36;0
WireConnection;33;1;31;0
WireConnection;33;2;28;0
WireConnection;0;2;42;0
WireConnection;0;9;52;0
WireConnection;0;11;50;0
ASEEND*/
//CHKSM=71EFF0A39B19A54603C21652A8C6A70EDCF8C8C9
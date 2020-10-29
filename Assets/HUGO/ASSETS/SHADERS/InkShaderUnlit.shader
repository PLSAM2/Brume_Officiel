// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InkShaderUnlit"
{
	Properties
	{
		_object_Texture("object_Texture", 2D) = "white" {}
		_chinesePaper_Texture("chinesePaper_Texture", 2D) = "white" {}
		_chinesePaper_Tiling("chinesePaper_Tiling", Float) = 1
		_edgeNoise_Texture("edgeNoise_Texture", 2D) = "white" {}
		_edgeNoise_Tiling("edgeNoise_Tiling", Float) = 1
		_edgeNoise_Speed("edgeNoise_Speed", Vector) = (0.1,0,0,0)
		_edgeNoise_Attenuation("edgeNoise_Attenuation", Float) = 0.9
		_shadow_Color("shadow_Color", Color) = (0.6132076,0.6132076,0.6132076,0)
		_watercolor_Texture("watercolor_Texture", 2D) = "white" {}
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_watercolor_Strength("watercolor_Strength", Float) = 3
		_watercolor_Edge("watercolor_Edge", Float) = 0.7
		_watercolor_Contrast("watercolor_Contrast", Float) = 0.6
		_watercolor_Speed("watercolor_Speed", Vector) = (0.01,0,0,0)
		_watercolor_Tiling("watercolor_Tiling", Float) = 0.5
		_watercolor_Tiling2("watercolor_Tiling2", Float) = 0.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 screenPos;
			float3 worldNormal;
			float3 worldPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _object_Texture;
		uniform float4 _object_Texture_ST;
		uniform sampler2D _chinesePaper_Texture;
		uniform float _chinesePaper_Tiling;
		uniform float _watercolor_Contrast;
		uniform float _watercolor_Strength;
		uniform sampler2D _watercolor_Texture;
		uniform float _watercolor_Tiling;
		uniform float2 _watercolor_Speed;
		uniform sampler2D _TextureSample0;
		uniform float _watercolor_Tiling2;
		uniform float _watercolor_Edge;
		uniform float4 _shadow_Color;
		uniform sampler2D _edgeNoise_Texture;
		uniform float _edgeNoise_Tiling;
		uniform float2 _edgeNoise_Speed;
		uniform float _edgeNoise_Attenuation;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_object_Texture = i.uv_texcoord * _object_Texture_ST.xy + _object_Texture_ST.zw;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float grayscale69 = Luminance(tex2D( _chinesePaper_Texture, ( (ase_screenPosNorm).xyzw * _chinesePaper_Tiling ).xy ).rgb);
			float2 temp_cast_2 = (_watercolor_Tiling).xx;
			float2 panner217 = ( 1.0 * _Time.y * _watercolor_Speed + float2( 0,0 ));
			float2 uv_TexCoord218 = i.uv_texcoord * temp_cast_2 + panner217;
			float2 temp_cast_3 = (_watercolor_Tiling2).xx;
			float2 uv_TexCoord223 = i.uv_texcoord * temp_cast_3 + ( panner217 * -1.0 );
			float4 temp_cast_4 = (_watercolor_Edge).xxxx;
			float4 blendOpSrc76 = tex2D( _object_Texture, uv_object_Texture );
			float4 blendOpDest76 = ( ( grayscale69 * 3.0 ) * CalculateContrast(_watercolor_Contrast,abs( ( ( _watercolor_Strength * ( tex2D( _watercolor_Texture, uv_TexCoord218 ) * tex2D( _TextureSample0, uv_TexCoord223 ) ) ) - temp_cast_4 ) )) );
			float4 final_Texture79 = ( saturate( ( blendOpSrc76 * blendOpDest76 ) ));
			float2 temp_cast_5 = (_edgeNoise_Tiling).xx;
			float2 panner175 = ( 1.0 * _Time.y * _edgeNoise_Speed + float2( 0,0 ));
			float2 uv_TexCoord152 = i.uv_texcoord * temp_cast_5 + ( float4( panner175, 0.0 , 0.0 ) + ase_screenPosNorm ).xy;
			float4 edge_Noise161 = tex2D( _edgeNoise_Texture, uv_TexCoord152 );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult12 = dot( ase_worldNormal , ase_worldlightDir );
			float normal_LightDir23 = dotResult12;
			float shadows_Ramp41 = pow( normal_LightDir23 , _edgeNoise_Attenuation );
			float4 temp_cast_8 = (shadows_Ramp41).xxxx;
			float grayscale187 = Luminance(step( edge_Noise161 , temp_cast_8 ).rgb);
			float4 temp_cast_10 = (grayscale187).xxxx;
			float4 blendOpSrc199 = _shadow_Color;
			float4 blendOpDest199 = temp_cast_10;
			c.rgb = ( final_Texture79 * ( saturate( 	max( blendOpSrc199, blendOpDest199 ) )) ).rgb;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows 

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
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
				float3 worldNormal : TEXCOORD4;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.screenPos = ComputeScreenPos( o.pos );
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
				surfIN.worldNormal = IN.worldNormal;
				surfIN.screenPos = IN.screenPos;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18301
1920;0;1920;1019;11102.99;4217.814;7.546526;True;False
Node;AmplifyShaderEditor.CommentaryNode;182;-6107.127,-2285.445;Inherit;False;3241.322;1566.079;Texture;7;79;117;181;78;66;214;229;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;214;-6056.147,-1422.903;Inherit;False;2478.927;651.8186;WaterColor Effect;18;226;207;222;218;223;224;227;216;217;225;215;219;220;206;212;213;210;221;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;215;-6018.519,-1179.67;Inherit;False;Property;_watercolor_Speed;watercolor_Speed;14;0;Create;True;0;0;False;0;False;0.01,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;225;-5769.563,-1021.291;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;217;-5794.519,-1198.67;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.12,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-5591.073,-1088.229;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-5882.611,-915.7223;Inherit;False;Property;_watercolor_Tiling2;watercolor_Tiling2;16;0;Create;True;0;0;False;0;False;0.2;-0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;216;-5816.518,-1293.669;Inherit;False;Property;_watercolor_Tiling;watercolor_Tiling;15;0;Create;True;0;0;False;0;False;0.5;-0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;156;-5634.832,268.5341;Inherit;False;1667.954;572.8691;Edge Noise;8;178;173;161;203;152;192;175;191;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-4880.801,-209.418;Inherit;False;916.9309;379.7947;Normal Light Dir;4;11;10;23;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;218;-5606.658,-1295.282;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;223;-5589.073,-986.2281;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;66;-5358.165,-1902.626;Inherit;False;1505.928;372.5782;Billboard Chinese Paper Texture;8;57;59;56;55;49;84;85;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-4857.802,-5.624552;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;207;-5361.287,-1259.257;Inherit;True;Property;_watercolor_Texture;watercolor_Texture;9;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;4d5dbc1ba3dda0143a39c6a1fa10a3b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;222;-5359.938,-1015.033;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;4d5dbc1ba3dda0143a39c6a1fa10a3b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;178;-5604.343,449.8601;Inherit;False;Property;_edgeNoise_Speed;edgeNoise_Speed;6;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WorldNormalVector;10;-4827.693,-154.1071;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ScreenPosInputsNode;55;-5324.328,-1827.991;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;191;-5409.646,643.7156;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-5116.604,-1745.165;Inherit;False;Property;_chinesePaper_Tiling;chinesePaper_Tiling;2;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;56;-5098.032,-1828.175;Inherit;False;FLOAT4;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-4397.099,-156.1638;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-4988.999,-1142.023;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;175;-5377.922,431.0873;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.28,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-4799.016,-1342.662;Inherit;False;Property;_watercolor_Strength;watercolor_Strength;11;0;Create;True;0;0;False;0;False;3;2.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-4561.011,-1133.906;Inherit;False;Property;_watercolor_Edge;watercolor_Edge;12;0;Create;True;0;0;False;0;False;0.7;0.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-4160.873,-160.4186;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-4881.778,-1821.68;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;192;-5148.321,543.3196;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-5195.922,313.087;Inherit;False;Property;_edgeNoise_Tiling;edgeNoise_Tiling;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-4517.836,-1323.189;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-3370.641,115.3113;Inherit;False;Property;_edgeNoise_Attenuation;edgeNoise_Attenuation;7;0;Create;True;0;0;False;0;False;0.9;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;49;-4718.651,-1850.522;Inherit;True;Property;_chinesePaper_Texture;chinesePaper_Texture;1;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;45;-3375.64,20.84022;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;152;-4961.651,347.094;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;212;-4335.016,-1261.903;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;69;-4331.966,-1849.715;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;206;-4186.796,-1261.795;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;162;-3106.32,25.66944;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-4087.293,-1044.092;Inherit;False;Property;_watercolor_Contrast;watercolor_Contrast;13;0;Create;True;0;0;False;0;False;0.6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;203;-4564.363,317.7187;Inherit;True;Property;_edgeNoise_Texture;edgeNoise_Texture;4;0;Create;True;0;0;False;0;False;-1;1cb5d7a8b79999d4b8356e740bbf6667;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;78;-4461.781,-2235.445;Inherit;False;609.101;283.2876;Object Texture;2;77;75;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-4014.583,-1602.133;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-4182.228,321.3484;Inherit;False;edge_Noise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-2860.844,21.17915;Inherit;False;shadows_Ramp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;75;-4411.782,-2185.445;Inherit;True;Property;_object_Texture;object_Texture;0;0;Create;True;0;0;False;0;False;6395db2a80729484b931cff6723fa89f;6395db2a80729484b931cff6723fa89f;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;219;-3845.003,-1262.273;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.29;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-2060.429,292.8982;Inherit;False;41;shadows_Ramp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-3501.362,-1593.883;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;77;-4172.684,-2182.157;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;181;-3446.819,-2055.304;Inherit;False;329;309;Multiply Texture/Grain;1;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-2043.845,214.4215;Inherit;False;161;edge_Noise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;160;-1804.529,219.5057;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;76;-3396.82,-2005.304;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;187;-1561.065,214.6759;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-3089.818,-2005.991;Inherit;False;final_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;197;-1580.477,-39.20035;Inherit;False;Property;_shadow_Color;shadow_Color;8;0;Create;True;0;0;False;0;False;0.6132076,0.6132076,0.6132076,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;80;-948.4003,117.461;Inherit;False;79;final_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;199;-1305.713,210.9695;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;84;-4114.02,-1844.509;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-4371.131,-1620.693;Inherit;False;Property;_chinesePaper_Contrast;chinesePaper_Contrast;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-720.2399,167.0174;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-384.1372,-114.203;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;InkShaderUnlit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;217;2;215;0
WireConnection;224;0;217;0
WireConnection;224;1;225;0
WireConnection;218;0;216;0
WireConnection;218;1;217;0
WireConnection;223;0;227;0
WireConnection;223;1;224;0
WireConnection;207;1;218;0
WireConnection;222;1;223;0
WireConnection;56;0;55;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;226;0;207;0
WireConnection;226;1;222;0
WireConnection;175;2;178;0
WireConnection;23;0;12;0
WireConnection;57;0;56;0
WireConnection;57;1;59;0
WireConnection;192;0;175;0
WireConnection;192;1;191;0
WireConnection;210;0;221;0
WireConnection;210;1;226;0
WireConnection;49;1;57;0
WireConnection;152;0;173;0
WireConnection;152;1;192;0
WireConnection;212;0;210;0
WireConnection;212;1;213;0
WireConnection;69;0;49;0
WireConnection;206;0;212;0
WireConnection;162;0;45;0
WireConnection;162;1;163;0
WireConnection;203;1;152;0
WireConnection;229;0;69;0
WireConnection;161;0;203;0
WireConnection;41;0;162;0
WireConnection;219;1;206;0
WireConnection;219;0;220;0
WireConnection;117;0;229;0
WireConnection;117;1;219;0
WireConnection;77;0;75;0
WireConnection;160;0;168;0
WireConnection;160;1;167;0
WireConnection;76;0;77;0
WireConnection;76;1;117;0
WireConnection;187;0;160;0
WireConnection;79;0;76;0
WireConnection;199;0;197;0
WireConnection;199;1;187;0
WireConnection;84;1;69;0
WireConnection;84;0;85;0
WireConnection;48;0;80;0
WireConnection;48;1;199;0
WireConnection;0;13;48;0
ASEEND*/
//CHKSM=745C26FD671D06756E3C9D06C45FF82A8EADAC44
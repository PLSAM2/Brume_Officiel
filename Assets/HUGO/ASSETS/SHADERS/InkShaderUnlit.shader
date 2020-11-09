// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InkShaderUnlit"
{
	Properties
	{
		_edgeNoise_Attenuation1("edgeNoise_Attenuation", Float) = 0.5
		_EmberSpread("EmberSpread", Float) = 0.1
		_FlowMapTilling("FlowMapTilling", Float) = 1
		_FlowMap("FlowMap", 2D) = "white" {}
		_FlowDirection("FlowDirection", Vector) = (1,1,0,0)
		_NoiseTiling("NoiseTiling", Float) = 1
		_NoiseTexture("NoiseTexture", 2D) = "white" {}
		_DistortionStrength("DistortionStrength", Float) = 1.2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldNormal;
			float3 worldPos;
			float2 uv_texcoord;
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

		uniform float _edgeNoise_Attenuation1;
		uniform sampler2D _NoiseTexture;
		uniform float _NoiseTiling;
		uniform sampler2D _FlowMap;
		uniform float _FlowMapTilling;
		uniform float2 _FlowDirection;
		uniform float _DistortionStrength;
		uniform float _EmberSpread;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult12 = dot( ase_worldNormal , ase_worldlightDir );
			float normal_LightDir23 = dotResult12;
			float shadows_Ramp353 = pow( normal_LightDir23 , _edgeNoise_Attenuation1 );
			float2 temp_output_291_0 = ( i.uv_texcoord * _NoiseTiling );
			float2 temp_output_287_0 = ( (tex2D( _FlowMap, ( i.uv_texcoord * _FlowMapTilling ) )).rg * _FlowDirection );
			float temp_output_300_0 = ( _Time.y * 0.5 );
			float temp_output_301_0 = frac( temp_output_300_0 );
			float lerpResult297 = lerp( (tex2D( _NoiseTexture, ( temp_output_291_0 + ( temp_output_287_0 * ( _DistortionStrength * temp_output_301_0 ) ) ) )).r , (tex2D( _NoiseTexture, ( temp_output_291_0 + ( temp_output_287_0 * ( _DistortionStrength * frac( ( temp_output_300_0 + 0.5 ) ) ) ) ) )).r , abs( ( ( temp_output_301_0 * 2.0 ) - 1.0 ) ));
			float clampResult337 = clamp( ( shadows_Ramp353 - lerpResult297 ) , 0.0 , 1.0 );
			float clampResult269 = clamp( ( 1.0 - ( distance( clampResult337 , 0.45 ) / _EmberSpread ) ) , 0.0 , 1.0 );
			float3 temp_cast_0 = (clampResult269).xxx;
			c.rgb = temp_cast_0;
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
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

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
				float3 worldNormal : TEXCOORD3;
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
1978;151;1682;778;7837.245;467.595;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;323;-3630.595,-28.66395;Inherit;False;3078.294;1288.718;FlowMapNoiseControl;30;282;279;299;300;280;302;283;286;305;303;301;289;287;290;304;292;306;291;294;307;311;293;308;295;309;312;296;313;310;297;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-3566.896,452.0325;Inherit;False;Property;_FlowMapTilling;FlowMapTilling;21;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;279;-3580.595,282.0493;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;299;-2979.17,835.566;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;-2794.123,834.316;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-3298.624,347.031;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;283;-3083.125,337.9386;Inherit;True;Property;_FlowMap;FlowMap;22;0;Create;True;0;0;False;0;False;-1;d69708e797d901040b8b9c15bd0b6ea7;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;302;-2625.724,980.0063;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-8935.119,-312.506;Inherit;False;916.9309;379.7947;Normal Light Dir;4;11;10;23;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-8882.011,-257.1951;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-8912.12,-108.7127;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector2Node;289;-2756.369,422.9603;Inherit;False;Property;_FlowDirection;FlowDirection;23;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;305;-2831.029,703.0146;Inherit;False;Property;_DistortionStrength;DistortionStrength;26;0;Create;True;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;303;-2481.724,982.0063;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;286;-2770.819,337.9385;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;301;-2552.724,836.0062;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;12;-8451.418,-259.2518;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-2259.799,956.7851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;292;-2231.61,147.3049;Inherit;False;Property;_NoiseTiling;NoiseTiling;24;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-2313.489,728.4756;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;-2537.368,369.9603;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;290;-2285.357,21.33611;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;-1909.809,849.4996;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-2014.61,99.30495;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-1991.61,311.3049;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-8215.191,-263.5066;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;293;-1812.61,122.305;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;364;-6774.666,322.8298;Inherit;False;Property;_edgeNoise_Attenuation1;edgeNoise_Attenuation;8;0;Create;True;0;0;False;0;False;0.5;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-1958.589,1125.054;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;350;-6729.906,230.931;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;308;-1730.374,760.9705;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;309;-1532.323,717.6976;Inherit;True;Property;_TextureSample2;Texture Sample 2;25;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;None;True;0;False;white;Auto;False;Instance;295;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;352;-6430.192,234.9188;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;295;-1536.738,184.2758;Inherit;True;Property;_NoiseTexture;NoiseTexture;25;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;312;-1800.458,1125.054;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;313;-1638.891,1126.773;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;310;-1176.533,746.9177;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;296;-1155.183,229.3834;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;353;-6181.341,227.8076;Inherit;False;shadows_Ramp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;297;-734.3013,362.874;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;-1506.89,-420.79;Inherit;True;353;shadows_Ramp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;336;-278.7594,126.7032;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;45.089,-84.59256;Inherit;False;Constant;_Float2;Float 2;18;0;Create;True;0;0;False;0;False;0.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;337;-22.33752,123.9915;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;271;181.7013,15.57053;Inherit;False;Property;_EmberSpread;EmberSpread;19;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;266;199.296,-158.0014;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;182;-7466.651,-3985.958;Inherit;False;3241.322;1566.079;Texture;7;79;117;181;78;66;214;229;;1,0,0,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;270;376.7017,-121.4284;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;272;517.8934,-120.1459;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;181;-4806.344,-3755.816;Inherit;False;329;309;Multiply Texture/Grain;1;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;78;-5821.304,-3935.958;Inherit;False;609.101;283.2876;Object Texture;2;77;75;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;214;-7415.67,-3123.416;Inherit;False;2478.927;651.8186;WaterColor Effect;18;226;207;222;218;223;224;227;216;217;225;215;219;220;206;212;213;210;221;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;66;-6717.689,-3603.139;Inherit;False;1505.928;372.5782;Billboard Chinese Paper Texture;8;57;59;56;55;49;84;85;69;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;156;-9689.157,165.446;Inherit;False;2093.515;625.2458;Edge Noise;11;203;161;152;173;192;175;191;178;230;232;233;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCGrayscale;187;-4829.2,-1494.622;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;213;-5920.535,-2834.418;Inherit;False;Property;_watercolor_Edge;watercolor_Edge;14;0;Create;True;0;0;False;0;False;0.7;0.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;192;-9202.643,440.2315;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;347;-6738.679,-573.6606;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;175;-9432.244,327.9992;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.28,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-9250.243,209.9989;Inherit;False;Property;_edgeNoise_Tiling;edgeNoise_Tiling;5;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;203;-8789.682,215.6306;Inherit;True;Property;_edgeNoise_Texture;edgeNoise_Texture;4;0;Create;True;0;0;False;0;False;-1;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;152;-9015.971,244.006;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;232;-8474.961,221.7396;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-7129.086,-2721.803;Inherit;False;Constant;_Float0;Float 0;16;0;Create;True;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-8302.688,301.4403;Inherit;False;Property;_edgeNoise_Contrast;edgeNoise_Contrast;9;0;Create;True;0;0;False;0;False;0.7;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;362;-473.5786,564.0193;Inherit;False;FlowMapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-5374.107,-3302.646;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-7182.692,-219.3938;Inherit;False;Property;_edgeNoise_Attenuation;edgeNoise_Attenuation;7;0;Create;True;0;0;False;0;False;0.5;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;167;-5450.792,-1412.375;Inherit;False;-1;;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;197;-4808.493,-1806.775;Inherit;False;Property;_shadow_Color;shadow_Color;10;0;Create;True;0;0;False;0;False;0.6132076,0.6132076,0.6132076,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;49;-6078.174,-3551.035;Inherit;True;Property;_chinesePaper_Texture;chinesePaper_Texture;1;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-6266.228,-318.2467;Inherit;False;shadows_Ramp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;349;-6739.22,-289.1076;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;191;-9463.969,540.6274;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;216;-7176.042,-2994.181;Inherit;False;Property;_watercolor_Tiling;watercolor_Tiling;17;0;Create;True;0;0;False;0;False;0.8;-0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;268;208.8312,277.2486;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;341;-5140.23,-1207.591;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-7123.69,-306.8648;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;226;-6348.523,-2842.535;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;-5434.208,-1490.851;Inherit;False;161;edge_Noise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-6902.679,-561.6606;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-4370.99,-1656.898;Inherit;False;79;final_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;199;-4537.026,-1520.349;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;69;-5691.49,-3550.228;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-4157.83,-1539.342;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;59;-6476.127,-3445.677;Inherit;False;Property;_chinesePaper_Tiling;chinesePaper_Tiling;2;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;215;-7378.042,-2880.183;Inherit;False;Property;_watercolor_Speed;watercolor_Speed;16;0;Create;True;0;0;False;0;False;0.01,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;217;-7154.042,-2899.183;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-0.12,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;161;-7801.903,218.6249;Inherit;False;edge_Noise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;278;683.1639,334.1034;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;273;524.1467,336.3783;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;56;-6457.556,-3528.688;Inherit;False;FLOAT4;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;178;-9658.666,346.772;Inherit;False;Property;_edgeNoise_Speed;edgeNoise_Speed;6;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;218;-6966.182,-2995.794;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;230;-8077.217,223.1615;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.7;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;227;-7242.134,-2616.234;Inherit;False;Property;_watercolor_Tiling2;watercolor_Tiling2;18;0;Create;True;0;0;False;0;False;0.6;-0.34;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;76;-4756.345,-3705.816;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-6241.301,-3522.192;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-6158.54,-3043.174;Inherit;False;Property;_watercolor_Strength;watercolor_Strength;13;0;Create;True;0;0;False;0;False;6;2.31;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;160;-5194.894,-1485.767;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;274;388.6019,338.256;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-4449.344,-3706.503;Inherit;False;final_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-5877.36,-3023.701;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;55;-6683.852,-3528.503;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;212;-5694.54,-2962.416;Inherit;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;75;-5771.306,-3885.958;Inherit;True;Property;_object_Texture;object_Texture;0;0;Create;True;0;0;False;0;False;6395db2a80729484b931cff6723fa89f;6395db2a80729484b931cff6723fa89f;False;white;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-5446.817,-2744.604;Inherit;False;Property;_watercolor_Contrast;watercolor_Contrast;15;0;Create;True;0;0;False;0;False;0.8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;222;-6719.461,-2715.545;Inherit;True;Property;_TextureSample0;Texture Sample 0;12;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;4d5dbc1ba3dda0143a39c6a1fa10a3b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;-4860.887,-3294.396;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;206;-5546.32,-2962.308;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;207;-6720.811,-2959.77;Inherit;True;Property;_watercolor_Texture;watercolor_Texture;11;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;4d5dbc1ba3dda0143a39c6a1fa10a3b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;219;-5204.527,-2962.785;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0.29;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;84;-5473.543,-3545.021;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-6950.597,-2788.741;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ClampOpNode;269;693.1564,-118.3406;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;68.49303,345.0064;Inherit;False;Constant;_Float3;Float 3;18;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;223;-6948.597,-2686.74;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;77;-5532.208,-3882.669;Inherit;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;277;191.9196,448.2542;Inherit;False;Property;_Float1;Float 1;20;0;Create;True;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-5730.655,-3321.206;Inherit;False;Property;_chinesePaper_Contrast;chinesePaper_Contrast;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1212.521,-173.1796;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;InkShaderUnlit;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.06;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;300;0;299;0
WireConnection;280;0;279;0
WireConnection;280;1;282;0
WireConnection;283;1;280;0
WireConnection;302;0;300;0
WireConnection;303;0;302;0
WireConnection;286;0;283;0
WireConnection;301;0;300;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;304;0;305;0
WireConnection;304;1;303;0
WireConnection;306;0;305;0
WireConnection;306;1;301;0
WireConnection;287;0;286;0
WireConnection;287;1;289;0
WireConnection;307;0;287;0
WireConnection;307;1;304;0
WireConnection;291;0;290;0
WireConnection;291;1;292;0
WireConnection;294;0;287;0
WireConnection;294;1;306;0
WireConnection;23;0;12;0
WireConnection;293;0;291;0
WireConnection;293;1;294;0
WireConnection;311;0;301;0
WireConnection;308;0;291;0
WireConnection;308;1;307;0
WireConnection;309;1;308;0
WireConnection;352;0;350;0
WireConnection;352;1;364;0
WireConnection;295;1;293;0
WireConnection;312;0;311;0
WireConnection;313;0;312;0
WireConnection;310;0;309;0
WireConnection;296;0;295;0
WireConnection;353;0;352;0
WireConnection;297;0;296;0
WireConnection;297;1;310;0
WireConnection;297;2;313;0
WireConnection;336;0;338;0
WireConnection;336;1;297;0
WireConnection;337;0;336;0
WireConnection;266;0;337;0
WireConnection;266;1;275;0
WireConnection;270;0;266;0
WireConnection;270;1;271;0
WireConnection;272;0;270;0
WireConnection;187;0;160;0
WireConnection;192;0;175;0
WireConnection;192;1;191;0
WireConnection;347;0;45;0
WireConnection;347;1;345;0
WireConnection;175;2;178;0
WireConnection;203;1;152;0
WireConnection;152;0;173;0
WireConnection;152;1;192;0
WireConnection;232;0;203;0
WireConnection;362;0;297;0
WireConnection;229;0;69;0
WireConnection;49;1;57;0
WireConnection;349;0;45;0
WireConnection;349;1;163;0
WireConnection;268;0;337;0
WireConnection;268;1;276;0
WireConnection;341;0;167;0
WireConnection;341;1;168;0
WireConnection;226;0;207;0
WireConnection;226;1;222;0
WireConnection;345;0;163;0
WireConnection;199;0;197;0
WireConnection;199;1;187;0
WireConnection;69;0;49;0
WireConnection;48;0;80;0
WireConnection;48;1;199;0
WireConnection;217;2;215;0
WireConnection;161;0;230;0
WireConnection;278;0;273;0
WireConnection;273;0;274;0
WireConnection;56;0;55;0
WireConnection;218;0;216;0
WireConnection;218;1;217;0
WireConnection;230;1;232;0
WireConnection;230;0;233;0
WireConnection;76;0;77;0
WireConnection;76;1;117;0
WireConnection;57;0;56;0
WireConnection;57;1;59;0
WireConnection;160;0;168;0
WireConnection;160;1;167;0
WireConnection;274;0;268;0
WireConnection;274;1;277;0
WireConnection;79;0;76;0
WireConnection;210;0;221;0
WireConnection;210;1;226;0
WireConnection;212;0;210;0
WireConnection;212;1;213;0
WireConnection;222;1;223;0
WireConnection;117;0;229;0
WireConnection;117;1;219;0
WireConnection;206;0;212;0
WireConnection;207;1;218;0
WireConnection;219;1;206;0
WireConnection;219;0;220;0
WireConnection;84;1;69;0
WireConnection;84;0;85;0
WireConnection;224;0;217;0
WireConnection;224;1;225;0
WireConnection;269;0;272;0
WireConnection;223;0;227;0
WireConnection;223;1;224;0
WireConnection;77;0;75;0
WireConnection;0;13;269;0
ASEEND*/
//CHKSM=36C9DCF1AE5D9B12AA9FF9D93FB2EB043C8A01FC
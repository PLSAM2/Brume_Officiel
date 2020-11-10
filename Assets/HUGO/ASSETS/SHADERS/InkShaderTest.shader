// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InkShaderTest"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Object_Albedo("Object_Albedo", 2D) = "white" {}
		_StepShadow("StepShadow", Float) = 0.03
		_StepAttenuation("StepAttenuation", Float) = -0.27
		_EdgeRange("EdgeRange", Float) = -0.1
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		_PaperGrunge_Texture("Paper/Grunge_Texture", 2D) = "white" {}
		_PaperGrunge_Tiling("Paper/Grunge_Tiling", Float) = 1
		_Noise_Tiling("Noise_Tiling", Float) = 1
		_Panner("Panner", Vector) = (0,0,0,0)
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
			float4 screenPos;
			float2 uv_texcoord;
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

		uniform sampler2D _PaperGrunge_Texture;
		uniform float _PaperGrunge_Tiling;
		uniform sampler2D _Object_Albedo;
		uniform float _StepShadow;
		uniform float _StepAttenuation;
		uniform sampler2D _TextureSample0;
		uniform float2 _Panner;
		uniform float _Noise_Tiling;
		uniform float4 _ShadowColor;
		uniform float _EdgeRange;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float grayscale455 = Luminance(tex2D( _PaperGrunge_Texture, ( (ase_screenPosNorm).xy * _PaperGrunge_Tiling ) ).rgb);
			float4 color458 = IsGammaSpace() ? float4(0.5660378,0.5660378,0.5660378,0) : float4(0.280335,0.280335,0.280335,0);
			float4 blendOpSrc461 = ( grayscale455 + color458 );
			float4 blendOpDest461 = tex2D( _Object_Albedo, i.uv_texcoord );
			float temp_output_387_0 = ( _StepShadow + _StepAttenuation );
			float3 ase_worldNormal = i.worldNormal;
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult12 = dot( ase_worldNormal , ase_worldlightDir );
			float normal_LightDir23 = dotResult12;
			float smoothstepResult385 = smoothstep( _StepShadow , temp_output_387_0 , normal_LightDir23);
			float2 panner484 = ( 1.0 * _Time.y * _Panner + ( (ase_screenPosNorm).xy * _Noise_Tiling ));
			float MapNoise481 = tex2D( _TextureSample0, panner484 ).r;
			float smoothstepResult401 = smoothstep( 0.0 , 0.6 , ( smoothstepResult385 - MapNoise481 ));
			float smoothstepResult445 = smoothstep( ( _StepShadow + -0.02 ) , ( temp_output_387_0 + -0.02 ) , normal_LightDir23);
			float blendOpSrc444 = smoothstepResult401;
			float blendOpDest444 = smoothstepResult445;
			float4 temp_cast_1 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest444) / max( blendOpSrc444, 0.00001) ) ) ))).xxxx;
			float4 blendOpSrc449 = temp_cast_1;
			float4 blendOpDest449 = _ShadowColor;
			float temp_output_419_0 = ( ( _StepShadow + _EdgeRange ) * -1.0 );
			float smoothstepResult402 = smoothstep( temp_output_419_0 , ( temp_output_419_0 + -0.1 ) , ( normal_LightDir23 * -1.0 ));
			float4 blendOpSrc428 = ( saturate( ( blendOpSrc461 * blendOpDest461 ) ));
			float4 blendOpDest428 = ( ( saturate( ( blendOpSrc449 * blendOpDest449 ) )) + ( 1.0 - step( ( smoothstepResult402 - MapNoise481 ) , 0.0 ) ) );
			float4 End473 = ( saturate( ( blendOpSrc428 * blendOpDest428 ) ));
			c.rgb = End473.rgb;
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
-4;9;1920;1019;3.75647;313.785;1;True;False
Node;AmplifyShaderEditor.ScreenPosInputsNode;478;-5825.09,-330.615;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;480;-5611.465,-331.2752;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;479;-5629.46,-251.6951;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;15;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;31;-6040.725,-1429.607;Inherit;False;916.9309;379.7947;Normal Light Dir;4;11;10;23;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;487;-5356.556,-86.10516;Inherit;False;Property;_Panner;Panner;16;0;Create;True;0;0;False;0;False;0,0;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;477;-5397.465,-329.2752;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-6017.724,-1225.814;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;472;-4607.078,-1099.465;Inherit;False;1932.856;570.4816;Shadow Hard Edge;13;422;421;419;392;418;383;402;394;396;404;406;380;483;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-5987.613,-1374.296;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;12;-5557.02,-1376.353;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;484;-5120.556,-160.1052;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-4828.71,-1671.417;Inherit;False;Property;_StepShadow;StepShadow;9;0;Create;True;0;0;False;0;False;0.03;0.26;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;471;-4387.663,-2267.649;Inherit;False;1847.087;1098.404;Shadow Smooth Edge + Int Shadow;16;388;387;448;385;398;397;447;446;445;401;450;444;449;470;469;482;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;422;-4557.078,-998.7985;Inherit;False;Property;_EdgeRange;EdgeRange;11;0;Create;True;0;0;False;0;False;-0.1;-0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;468;-4592.831,-3356.867;Inherit;False;2193.765;714.8518;Paper + Object Texture;11;464;465;463;466;454;458;455;460;427;426;461;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-5320.79,-1380.608;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;421;-4354.796,-1049.465;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;476;-4769.199,-198.4918;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;388;-4337.663,-1947.75;Inherit;False;Property;_StepAttenuation;StepAttenuation;10;0;Create;True;0;0;False;0;False;-0.27;-0.59;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;419;-4201.28,-943.3083;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-4143.662,-1967.75;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;481;-4389.188,-176.5665;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;464;-4542.831,-3279.294;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;380;-4004.603,-997.5882;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;-4170.532,-723.4073;Inherit;False;Constant;_StepShadow1;StepShadow;12;0;Create;False;0;0;False;0;False;-0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;469;-4253.397,-2217.649;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-3982.425,-2213.308;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;448;-4011.131,-1617.162;Inherit;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;463;-4347.201,-3200.374;Inherit;False;Property;_PaperGrunge_Tiling;Paper/Grunge_Tiling;14;0;Create;True;0;0;False;0;False;1;3.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;383;-3756.583,-958.2734;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;482;-3734.551,-2042.485;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;418;-3878.368,-792.1541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-0.19;False;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;465;-4329.206,-3279.954;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;447;-3791.047,-1667.463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;466;-4115.206,-3277.954;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;446;-3790.047,-1570.463;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;470;-3828.149,-1778.887;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-3503.246,-2212.34;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;402;-3595.024,-959.2877;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.19;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;483;-3557.425,-620.8953;Inherit;False;481;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-3286.388,-2211.492;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;454;-3858.385,-3306.615;Inherit;True;Property;_PaperGrunge_Texture;Paper/Grunge_Texture;13;0;Create;True;0;0;False;0;False;-1;8c8e6bd39f1d3c348a607b675e3dc417;8c8e6bd39f1d3c348a607b675e3dc417;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;396;-3300.482,-786.807;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;445;-3584.114,-1692.573;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;450;-2967.445,-1381.246;Inherit;False;Property;_ShadowColor;ShadowColor;12;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.4622641,0.4622641,0.4622641,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;404;-3077.934,-783.5673;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;427;-3290.811,-2816.421;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;455;-3506.446,-3306.867;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;458;-3311.446,-3050.868;Inherit;False;Constant;_PaperContrast;PaperContrast;13;0;Create;True;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;444;-3240.534,-1696.195;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;426;-3056.882,-2872.016;Inherit;True;Property;_Object_Albedo;Object_Albedo;8;0;Create;True;0;0;False;0;False;-1;6395db2a80729484b931cff6723fa89f;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;449;-2819.575,-1694.254;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;460;-3039.446,-3300.867;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;406;-2872.222,-782.9836;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;461;-2678.065,-3101.315;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;390;-2400.227,-1347.732;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;428;-1906.34,-1752.522;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;473;-1600.682,-1752.511;Inherit;False;End;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;323;-6157.825,756.7073;Inherit;False;3314.989;1261.052;FlowMapNoiseControl;31;362;297;313;310;296;312;295;309;293;311;308;294;307;291;287;306;290;304;292;301;305;286;289;303;302;283;300;280;282;299;279;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;293;-4339.836,907.6763;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-4518.839,1096.676;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;279;-6107.825,1067.42;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;303;-5008.955,1767.379;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;305;-5358.26,1488.386;Inherit;False;Property;_DistortionStrength;DistortionStrength;7;0;Create;True;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;-5064.599,1155.331;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;297;-3261.524,1148.245;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;690.214,641.1276;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;299;-5506.401,1620.938;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;-5321.354,1619.688;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;301;-5079.956,1621.378;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-5825.854,1132.402;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;474;1336.015,63.97839;Inherit;False;473;End;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.AbsOpNode;313;-4166.116,1912.145;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-4787.03,1742.156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-4840.72,1513.848;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;286;-5298.05,1123.309;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;292;-4758.841,932.6752;Inherit;False;Property;_NoiseTiling;NoiseTiling;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;302;-5152.956,1765.379;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;283;-5610.355,1123.309;Inherit;True;Property;_FlowMap;FlowMap;2;0;Create;True;0;0;False;0;False;-1;d69708e797d901040b8b9c15bd0b6ea7;d69708e797d901040b8b9c15bd0b6ea7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;451;-865.868,418.1596;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;309;-4059.548,1503.069;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Instance;295;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;452;-895.9778,566.6418;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;453;-435.2743,416.1028;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;489;-170.3205,728.9047;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;475;-182.1744,415.9221;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;-0.11;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;494;68.19873,516.6772;Inherit;False;Constant;_Color0;Color 0;16;0;Create;True;0;0;False;0;False;0.4339623,0.4339623,0.4339623,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;490;43.67947,731.9047;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;495;309.0723,456.5056;Inherit;True;Lighten;False;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;362;-3034.209,1142.598;Inherit;False;FlowMapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;312;-4327.684,1910.427;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;290;-4811.588,806.7073;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-4485.817,1910.427;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;-4437.036,1634.872;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;296;-3682.408,1014.754;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-6094.127,1237.404;Inherit;False;Property;_FlowMapTilling;FlowMapTilling;1;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;295;-4063.963,969.6465;Inherit;True;Property;_NoiseTexture;NoiseTexture;5;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;398;-3733.395,-2117.785;Inherit;False;362;FlowMapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-4541.839,884.6763;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;289;-5283.6,1208.332;Inherit;False;Property;_FlowDirection;FlowDirection;3;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;310;-3703.758,1532.29;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;394;-3582.89,-697.8196;Inherit;False;362;FlowMapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;308;-4257.599,1546.343;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TriplanarNode;496;-5018.224,502.9198;Inherit;True;Spherical;World;False;Top Texture 0;_TopTexture0;white;0;None;Mid Texture 0;_MidTexture0;white;-1;None;Bot Texture 0;_BotTexture0;white;-1;None;Triplanar Sampler;False;Tangent;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1573.984,-170.9062;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;InkShaderTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.06;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;480;0;478;0
WireConnection;477;0;480;0
WireConnection;477;1;479;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;484;0;477;0
WireConnection;484;2;487;0
WireConnection;23;0;12;0
WireConnection;421;0;386;0
WireConnection;421;1;422;0
WireConnection;476;1;484;0
WireConnection;419;0;421;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;481;0;476;1
WireConnection;385;0;469;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;383;0;380;0
WireConnection;418;0;419;0
WireConnection;418;1;392;0
WireConnection;465;0;464;0
WireConnection;447;0;386;0
WireConnection;447;1;448;0
WireConnection;466;0;465;0
WireConnection;466;1;463;0
WireConnection;446;0;387;0
WireConnection;446;1;448;0
WireConnection;397;0;385;0
WireConnection;397;1;482;0
WireConnection;402;0;383;0
WireConnection;402;1;419;0
WireConnection;402;2;418;0
WireConnection;401;0;397;0
WireConnection;454;1;466;0
WireConnection;396;0;402;0
WireConnection;396;1;483;0
WireConnection;445;0;470;0
WireConnection;445;1;447;0
WireConnection;445;2;446;0
WireConnection;404;0;396;0
WireConnection;455;0;454;0
WireConnection;444;0;401;0
WireConnection;444;1;445;0
WireConnection;426;1;427;0
WireConnection;449;0;444;0
WireConnection;449;1;450;0
WireConnection;460;0;455;0
WireConnection;460;1;458;0
WireConnection;406;0;404;0
WireConnection;461;0;460;0
WireConnection;461;1;426;0
WireConnection;390;0;449;0
WireConnection;390;1;406;0
WireConnection;428;0;461;0
WireConnection;428;1;390;0
WireConnection;473;0;428;0
WireConnection;293;0;291;0
WireConnection;293;1;294;0
WireConnection;294;0;287;0
WireConnection;294;1;306;0
WireConnection;303;0;302;0
WireConnection;287;0;286;0
WireConnection;287;1;289;0
WireConnection;297;0;296;0
WireConnection;297;1;310;0
WireConnection;297;2;313;0
WireConnection;491;0;495;0
WireConnection;491;1;490;0
WireConnection;300;0;299;0
WireConnection;301;0;300;0
WireConnection;280;0;279;0
WireConnection;280;1;282;0
WireConnection;313;0;312;0
WireConnection;304;0;305;0
WireConnection;304;1;303;0
WireConnection;306;0;305;0
WireConnection;306;1;301;0
WireConnection;286;0;283;0
WireConnection;302;0;300;0
WireConnection;283;1;280;0
WireConnection;309;1;308;0
WireConnection;453;0;451;0
WireConnection;453;1;452;0
WireConnection;489;0;453;0
WireConnection;475;0;453;0
WireConnection;490;0;489;0
WireConnection;495;0;475;0
WireConnection;495;1;494;0
WireConnection;362;0;297;0
WireConnection;312;0;311;0
WireConnection;311;0;301;0
WireConnection;307;0;287;0
WireConnection;307;1;304;0
WireConnection;296;0;295;0
WireConnection;295;1;293;0
WireConnection;291;0;290;0
WireConnection;291;1;292;0
WireConnection;310;0;309;0
WireConnection;308;0;291;0
WireConnection;308;1;307;0
WireConnection;0;13;474;0
ASEEND*/
//CHKSM=649A3A628613DAF802E91B27502843892316B26C
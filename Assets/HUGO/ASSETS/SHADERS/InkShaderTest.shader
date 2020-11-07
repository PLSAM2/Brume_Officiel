// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "InkShaderTest"
{
	Properties
	{
		_FlowMapTilling("FlowMapTilling", Float) = 1
		_FlowMap("FlowMap", 2D) = "white" {}
		_FlowDirection("FlowDirection", Vector) = (1,1,0,0)
		_NoiseTiling("NoiseTiling", Float) = 1
		_NoiseTexture("NoiseTexture", 2D) = "white" {}
		_DistortionStrength("DistortionStrength", Float) = 1.2
		_StepShadow("StepShadow", Float) = -0.19
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

		uniform float _StepShadow;
		uniform sampler2D _NoiseTexture;
		uniform float _NoiseTiling;
		uniform sampler2D _FlowMap;
		uniform float _FlowMapTilling;
		uniform float2 _FlowDirection;
		uniform float _DistortionStrength;

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
			float smoothstepResult385 = smoothstep( _StepShadow , ( _StepShadow + -0.23 ) , normal_LightDir23);
			float2 temp_output_291_0 = ( i.uv_texcoord * _NoiseTiling );
			float2 temp_output_287_0 = ( (tex2D( _FlowMap, ( i.uv_texcoord * _FlowMapTilling ) )).rg * _FlowDirection );
			float temp_output_300_0 = ( _Time.y * 0.5 );
			float temp_output_301_0 = frac( temp_output_300_0 );
			float lerpResult297 = lerp( (tex2D( _NoiseTexture, ( temp_output_291_0 + ( temp_output_287_0 * ( _DistortionStrength * temp_output_301_0 ) ) ) )).r , (tex2D( _NoiseTexture, ( temp_output_291_0 + ( temp_output_287_0 * ( _DistortionStrength * frac( ( temp_output_300_0 + 0.5 ) ) ) ) ) )).r , abs( ( ( temp_output_301_0 * 2.0 ) - 1.0 ) ));
			float FlowMapNoise362 = lerpResult297;
			float smoothstepResult401 = smoothstep( 0.0 , 0.6 , ( smoothstepResult385 - FlowMapNoise362 ));
			float temp_output_383_0 = ( normal_LightDir23 * -1.0 );
			float smoothstepResult402 = smoothstep( 0.27 , 0.0 , temp_output_383_0);
			float3 temp_cast_0 = (( smoothstepResult401 + ( 1.0 - step( ( smoothstepResult402 - FlowMapNoise362 ) , 0.0 ) ) )).xxx;
			float grayscale369 = Luminance(temp_cast_0);
			float3 temp_cast_1 = (grayscale369).xxx;
			c.rgb = temp_cast_1;
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
2011;161;1682;778;10155.01;1466.638;7.552036;True;False
Node;AmplifyShaderEditor.CommentaryNode;323;-4002.858,1088.619;Inherit;False;3314.989;1261.052;FlowMapNoiseControl;31;362;297;313;310;296;312;295;309;293;311;308;294;307;291;287;306;290;304;292;301;305;286;289;303;302;283;300;280;282;299;279;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;279;-3952.858,1399.332;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;299;-3351.434,1952.85;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;282;-3939.16,1569.316;Inherit;False;Property;_FlowMapTilling;FlowMapTilling;4;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;280;-3670.888,1464.314;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;300;-3166.387,1951.6;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;283;-3455.389,1455.221;Inherit;True;Property;_FlowMap;FlowMap;5;0;Create;True;0;0;False;0;False;-1;d69708e797d901040b8b9c15bd0b6ea7;d69708e797d901040b8b9c15bd0b6ea7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;302;-2997.989,2097.29;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;301;-2924.989,1953.29;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;286;-3143.083,1455.221;Inherit;False;True;True;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;305;-3203.293,1820.298;Inherit;False;Property;_DistortionStrength;DistortionStrength;10;0;Create;True;0;0;False;0;False;1.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;303;-2853.989,2099.29;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;289;-3128.633,1540.243;Inherit;False;Property;_FlowDirection;FlowDirection;7;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;292;-2603.873,1264.587;Inherit;False;Property;_NoiseTiling;NoiseTiling;8;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;304;-2632.062,2074.068;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;306;-2685.753,1845.76;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;287;-2909.632,1487.243;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;290;-2657.62,1138.619;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;291;-2386.871,1216.588;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;-2282.069,1966.784;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;31;-8363.032,-704.1387;Inherit;False;916.9309;379.7947;Normal Light Dir;4;11;10;23;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;294;-2363.871,1428.588;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;293;-2184.869,1239.588;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;311;-2330.85,2242.338;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;10;-8309.921,-648.8277;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;308;-2102.632,1878.255;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;11;-8340.031,-500.3452;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;309;-1904.581,1834.981;Inherit;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Instance;295;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;12;-7879.327,-650.8845;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;295;-1908.996,1301.558;Inherit;True;Property;_NoiseTexture;NoiseTexture;9;0;Create;True;0;0;False;0;False;-1;0fe9101c6b6e1124b90b120ceebd6cba;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;312;-2172.717,2242.338;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;296;-1527.441,1346.666;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;310;-1548.791,1864.202;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-7643.098,-655.1392;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;313;-2011.149,2244.057;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;380;-9242.196,108.4276;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;297;-1106.558,1480.157;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;386;-8940.583,147.5225;Inherit;False;Property;_StepShadow;StepShadow;12;0;Create;True;0;0;False;0;False;-0.19;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-8951.453,231.6024;Inherit;False;Constant;_StepAttenuation;StepAttenuation;13;0;Create;True;0;0;False;0;False;-0.23;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;383;-8946.605,622.9708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;362;-879.2433,1474.509;Inherit;False;FlowMapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;402;-8786.046,398.956;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.27;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;394;-8772.911,883.4253;Inherit;False;362;FlowMapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;387;-8757.451,211.6024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;385;-8596.212,-33.95377;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;396;-8490.504,794.4378;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;398;-8576.313,205.0885;Inherit;False;362;FlowMapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;404;-8267.956,797.6775;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;397;-8282.902,-31.89901;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;406;-8062.244,798.2612;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;401;-8066.045,-31.05179;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;390;-7816.483,363.2762;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;-7123.69,-306.8648;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;353;-6181.341,227.8076;Inherit;False;shadows_Ramp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-6266.228,-318.2467;Inherit;False;shadows_Ramp;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;266;199.296,-158.0014;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;270;376.7017,-121.4284;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;275;45.089,-84.59256;Inherit;False;Constant;_Float2;Float 2;18;0;Create;True;0;0;False;0;False;0.45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;349;-6739.22,-289.1076;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;272;517.8934,-120.1459;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;337;-22.33752,123.9915;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;269;693.1564,-118.3406;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;347;-6738.679,-573.6606;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;338;-632.6826,-476.375;Inherit;True;353;shadows_Ramp;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;277;191.9196,448.2542;Inherit;False;Property;_Float1;Float 1;3;0;Create;True;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;345;-6902.679,-561.6606;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;274;388.6019,338.256;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;336;-278.7594,126.7032;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;365;-5794.048,333.9905;Inherit;True;Property;_ShadowEdge;ShadowEdge;6;0;Create;True;0;0;False;0;False;-1;e0ccb9fc7a953df47b554d3b7e6776b3;e0ccb9fc7a953df47b554d3b7e6776b3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;368;-6814.136,341.5631;Inherit;False;Property;_Float4;Float 4;1;0;Create;True;0;0;False;0;False;0.5;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;350;-6729.906,230.931;Inherit;False;23;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;352;-6430.192,234.9188;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;367;-5714.635,638.9442;Inherit;False;362;FlowMapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;384;-7428.26,879.4546;Inherit;False;Property;_StepEdgeShadow;StepEdgeShadow;11;0;Create;True;0;0;False;0;False;0.1232227;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;271;181.7013,15.57053;Inherit;False;Property;_EmberSpread;EmberSpread;2;0;Create;True;0;0;False;0;False;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;163;-7182.692,-219.3938;Inherit;False;Property;_edgeNoise_Attenuation;edgeNoise_Attenuation;0;0;Create;True;0;0;False;0;False;0.5;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;273;524.1467,336.3783;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.25;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;268;208.8312,277.2486;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;68.49303,345.0064;Inherit;False;Constant;_Float3;Float 3;18;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;369;-4482.062,611.814;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;392;-9253.558,640.8375;Inherit;False;Property;_StepShadow1;StepShadow;12;0;Create;False;0;0;False;0;False;-0.19;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;366;-5427.334,512.7036;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;278;683.1639,334.1034;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;381;-8782.904,624.2589;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;407;-514.4355,151.7983;Inherit;False;362;FlowMapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1212.521,-173.1796;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;InkShaderTest;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;2.06;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;280;0;279;0
WireConnection;280;1;282;0
WireConnection;300;0;299;0
WireConnection;283;1;280;0
WireConnection;302;0;300;0
WireConnection;301;0;300;0
WireConnection;286;0;283;0
WireConnection;303;0;302;0
WireConnection;304;0;305;0
WireConnection;304;1;303;0
WireConnection;306;0;305;0
WireConnection;306;1;301;0
WireConnection;287;0;286;0
WireConnection;287;1;289;0
WireConnection;291;0;290;0
WireConnection;291;1;292;0
WireConnection;307;0;287;0
WireConnection;307;1;304;0
WireConnection;294;0;287;0
WireConnection;294;1;306;0
WireConnection;293;0;291;0
WireConnection;293;1;294;0
WireConnection;311;0;301;0
WireConnection;308;0;291;0
WireConnection;308;1;307;0
WireConnection;309;1;308;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;295;1;293;0
WireConnection;312;0;311;0
WireConnection;296;0;295;0
WireConnection;310;0;309;0
WireConnection;23;0;12;0
WireConnection;313;0;312;0
WireConnection;297;0;296;0
WireConnection;297;1;310;0
WireConnection;297;2;313;0
WireConnection;383;0;380;0
WireConnection;362;0;297;0
WireConnection;402;0;383;0
WireConnection;387;0;386;0
WireConnection;387;1;388;0
WireConnection;385;0;380;0
WireConnection;385;1;386;0
WireConnection;385;2;387;0
WireConnection;396;0;402;0
WireConnection;396;1;394;0
WireConnection;404;0;396;0
WireConnection;397;0;385;0
WireConnection;397;1;398;0
WireConnection;406;0;404;0
WireConnection;401;0;397;0
WireConnection;390;0;401;0
WireConnection;390;1;406;0
WireConnection;353;0;352;0
WireConnection;266;0;337;0
WireConnection;266;1;275;0
WireConnection;270;0;266;0
WireConnection;270;1;271;0
WireConnection;349;0;45;0
WireConnection;349;1;163;0
WireConnection;272;0;270;0
WireConnection;337;0;336;0
WireConnection;269;0;272;0
WireConnection;347;0;45;0
WireConnection;347;1;345;0
WireConnection;345;0;163;0
WireConnection;274;0;268;0
WireConnection;274;1;277;0
WireConnection;336;0;338;0
WireConnection;336;1;407;0
WireConnection;365;1;352;0
WireConnection;352;0;350;0
WireConnection;352;1;368;0
WireConnection;273;0;274;0
WireConnection;268;0;337;0
WireConnection;268;1;276;0
WireConnection;369;0;390;0
WireConnection;366;0;365;0
WireConnection;366;1;367;0
WireConnection;278;0;273;0
WireConnection;381;0;383;0
WireConnection;381;1;392;0
WireConnection;0;13;369;0
ASEEND*/
//CHKSM=E6E4D4A09E1F0A716E2B12356F3FFFE4228E1043
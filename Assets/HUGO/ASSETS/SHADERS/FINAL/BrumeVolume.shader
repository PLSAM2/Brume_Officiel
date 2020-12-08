// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrumeVolume"
{
	Properties
	{
		_BrumeTexture("BrumeTexture", 2D) = "white" {}
		_BrumeTexture_Tiling("BrumeTexture_Tiling", Float) = 2
		[Toggle(_ROTATORANIMATION_ON)] _RotatorAnimation("RotatorAnimation?", Float) = 0
		[Header(Tesselation)][Toggle(_TESSELATION_ON)] _Tesselation("Tesselation?", Float) = 0
		_Tesselation_Factor("Tesselation_Factor", Range( 1 , 128)) = 15
		_Tesselation_MinDist("Tesselation_MinDist", Float) = 0
		_Tesselation_MaxDist("Tesselation_MaxDist", Float) = 5
		[Header(Displacement)][Toggle(_DISPLACEMENT_ON)] _Displacement("Displacement?", Float) = 0
		_DisplacementTexture_Multiply("DisplacementTexture_Multiply", Float) = 1
		_DisplacementTexture_Contrast("DisplacementTexture_Contrast", Float) = 1
		[Header(Light Normal)]_LightNormal("LightNormal?", Range( 0 , 1)) = 0
		_NormalStrength("NormalStrength", Float) = 2
		_NormalOffset("NormalOffset", Float) = 0.5
		[Header(Noise)]_PerlinNoise_Texture("PerlinNoise_Texture", 2D) = "white" {}
		_PerlinNoise_Tiling("PerlinNoise_Tiling", Float) = 0.1
		_PerlinNoise_PannerSpeed("PerlinNoise_PannerSpeed", Vector) = (0,0,0,0)
		_WaveNoiseContrast("WaveNoiseContrast", Float) = 4
		[Header(Brume Color)]_BrumeColor_ColorLow("BrumeColor_ColorLow", Color) = (0.4,0.4470589,0.509804,1)
		_BrumeColor_ColorHigh("BrumeColor_ColorHigh", Color) = (1,1,1,0)
		[Header(Brume Animation)]_BrumeAnimation_RotatorTime("BrumeAnimation_RotatorTime", Float) = 0.2
		_BrumeAnimation_WaveStrength("BrumeAnimation_WaveStrength", Float) = 0.15
		_BrumeAnimation_WaveFrequency("BrumeAnimation_WaveFrequency", Float) = 0.1
		_BrumeAnimation_PannerSpeed("BrumeAnimation_PannerSpeed", Vector) = (0.1,0,0,0)
		[Header(Opacity)]_OpacityMask_Texture("OpacityMask_Texture", 2D) = "white" {}
		_OpacityMask_Scale("OpacityMask_Scale", Float) = 5
		_OpacityMask_Offset("OpacityMask_Offset", Float) = 0
		[Header(Brume Edges)]_BrumeEdges_Smoothstep("BrumeEdges_Smoothstep", Float) = 0.3
		[Header(Brume Volume Transition)]_BrumeVolumeTransition_Blend("BrumeVolumeTransition_Blend", Range( 0 , 5)) = 5
		_BrumeVolumeTransition_Scale("BrumeVolumeTransition_Scale", Float) = 0.3
		_BrumeVolumeTransition_Offset("BrumeVolumeTransition_Offset", Float) = 1.3
		[Header(Depth Fade)]_DepthFade_Distance("DepthFade_Distance", Float) = 1
		_DepthFade_Power("DepthFade_Power", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma shader_feature_local _DISPLACEMENT_ON
		#pragma shader_feature_local _ROTATORANIMATION_ON
		#pragma shader_feature_local _TESSELATION_ON
		#pragma surface surf StandardCustomLighting keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
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

		uniform float _DisplacementTexture_Contrast;
		uniform sampler2D _BrumeTexture;
		uniform float _BrumeTexture_Tiling;
		uniform float _BrumeAnimation_WaveFrequency;
		uniform float _BrumeAnimation_RotatorTime;
		uniform float _BrumeAnimation_WaveStrength;
		uniform float2 _BrumeAnimation_PannerSpeed;
		uniform float _WaveNoiseContrast;
		uniform sampler2D _PerlinNoise_Texture;
		uniform float2 _PerlinNoise_PannerSpeed;
		uniform float _PerlinNoise_Tiling;
		uniform float _DisplacementTexture_Multiply;
		uniform sampler2D _OpacityMask_Texture;
		uniform float4 _OpacityMask_Texture_ST;
		uniform float _BrumeVolumeTransition_Scale;
		uniform float _BrumeVolumeTransition_Offset;
		uniform float _BrumeVolumeTransition_Blend;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFade_Distance;
		uniform float _DepthFade_Power;
		uniform float _OpacityMask_Scale;
		uniform float _OpacityMask_Offset;
		uniform float _BrumeEdges_Smoothstep;
		uniform float4 _BrumeColor_ColorLow;
		uniform float4 _BrumeColor_ColorHigh;
		uniform float _NormalOffset;
		uniform float _NormalStrength;
		uniform float _LightNormal;
		uniform float _Tesselation_MinDist;
		uniform float _Tesselation_MaxDist;
		uniform float _Tesselation_Factor;


		float4 CalculateContrast( float contrastValue, float4 colorTarget )
		{
			float t = 0.5 * ( 1.0 - contrastValue );
			return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
		}

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_7 = (1.0).xxxx;
			#ifdef _TESSELATION_ON
				float4 staticSwitch264 = UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _Tesselation_MinDist,_Tesselation_MaxDist,_Tesselation_Factor);
			#else
				float4 staticSwitch264 = temp_cast_7;
			#endif
			float4 BrumeTesselation560 = staticSwitch264;
			return BrumeTesselation560;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (_BrumeTexture_Tiling).xx;
			float2 uv_TexCoord322 = v.texcoord.xy * temp_cast_0;
			float mulTime476 = _Time.y * _BrumeAnimation_RotatorTime;
			float temp_output_508_0 = ( ( ( _SinTime.w * _BrumeAnimation_WaveFrequency ) + mulTime476 ) * _BrumeAnimation_WaveStrength );
			float2 temp_cast_1 = (( _BrumeTexture_Tiling * 0.5 )).xx;
			float cos473 = cos( temp_output_508_0 );
			float sin473 = sin( temp_output_508_0 );
			float2 rotator473 = mul( uv_TexCoord322 - temp_cast_1 , float2x2( cos473 , -sin473 , sin473 , cos473 )) + temp_cast_1;
			float2 panner513 = ( temp_output_508_0 * _BrumeAnimation_PannerSpeed + rotator473);
			#ifdef _ROTATORANIMATION_ON
				float2 staticSwitch474 = panner513;
			#else
				float2 staticSwitch474 = uv_TexCoord322;
			#endif
			float2 UV323 = staticSwitch474;
			float4 BrumeTextureSample329 = tex2Dlod( _BrumeTexture, float4( UV323, 0, 0.0) );
			float2 temp_cast_2 = (_PerlinNoise_Tiling).xx;
			float2 temp_cast_3 = (( ( 1.0 - _PerlinNoise_Tiling ) / 2.0 )).xx;
			float2 uv_TexCoord340 = v.texcoord.xy * temp_cast_2 + temp_cast_3;
			float cos367 = cos( ( _Time.y * 0.05 ) );
			float sin367 = sin( ( _Time.y * 0.05 ) );
			float2 rotator367 = mul( uv_TexCoord340 - float2( 0.5,0.5 ) , float2x2( cos367 , -sin367 , sin367 , cos367 )) + float2( 0.5,0.5 );
			float2 panner355 = ( ( _Time.y * 0.05 ) * _PerlinNoise_PannerSpeed + rotator367);
			float MovingPerlinNoise414 = tex2Dlod( _PerlinNoise_Texture, float4( panner355, 0, 0.0) ).r;
			float4 temp_cast_4 = ((0.5 + (MovingPerlinNoise414 - 0.0) * (1.0 - 0.5) / (1.0 - 0.0))).xxxx;
			float4 temp_cast_5 = (CalculateContrast(_DisplacementTexture_Contrast,( ( BrumeTextureSample329 * CalculateContrast(_WaveNoiseContrast,temp_cast_4) ) * _DisplacementTexture_Multiply )).r).xxxx;
			float2 uv_OpacityMask_Texture = v.texcoord * _OpacityMask_Texture_ST.xy + _OpacityMask_Texture_ST.zw;
			float4 tex2DNode516 = tex2Dlod( _OpacityMask_Texture, float4( uv_OpacityMask_Texture, 0, 0.0) );
			float4 OpacityMask566 = tex2DNode516;
			float temp_output_9_0_g2 = saturate( pow( max( ( (OpacityMask566*_BrumeVolumeTransition_Scale + _BrumeVolumeTransition_Offset).r * 0.79 * ( 1.0 + 0.0 ) ) , 0.0 ) , ( _BrumeVolumeTransition_Blend * -1.0 ) ) );
			float4 lerpResult14_g2 = lerp( temp_cast_5 , float4( 0,0,0,0 ) , temp_output_9_0_g2);
			float3 ase_vertexNormal = v.normal.xyz;
			#ifdef _DISPLACEMENT_ON
				float3 staticSwitch267 = ( lerpResult14_g2.r * ase_vertexNormal );
			#else
				float3 staticSwitch267 = float3( 0,0,0 );
			#endif
			float3 BrumeDisplacement558 = staticSwitch267;
			v.vertex.xyz += BrumeDisplacement558;
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth568 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth568 = abs( ( screenDepth568 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFade_Distance ) );
			float clampResult573 = clamp( ( distanceDepth568 * _DepthFade_Power ) , 0.0 , 1.0 );
			float DepthFade574 = clampResult573;
			float2 uv_OpacityMask_Texture = i.uv_texcoord * _OpacityMask_Texture_ST.xy + _OpacityMask_Texture_ST.zw;
			float4 tex2DNode516 = tex2D( _OpacityMask_Texture, uv_OpacityMask_Texture );
			float2 temp_cast_0 = (_BrumeTexture_Tiling).xx;
			float2 uv_TexCoord322 = i.uv_texcoord * temp_cast_0;
			float mulTime476 = _Time.y * _BrumeAnimation_RotatorTime;
			float temp_output_508_0 = ( ( ( _SinTime.w * _BrumeAnimation_WaveFrequency ) + mulTime476 ) * _BrumeAnimation_WaveStrength );
			float2 temp_cast_1 = (( _BrumeTexture_Tiling * 0.5 )).xx;
			float cos473 = cos( temp_output_508_0 );
			float sin473 = sin( temp_output_508_0 );
			float2 rotator473 = mul( uv_TexCoord322 - temp_cast_1 , float2x2( cos473 , -sin473 , sin473 , cos473 )) + temp_cast_1;
			float2 panner513 = ( temp_output_508_0 * _BrumeAnimation_PannerSpeed + rotator473);
			#ifdef _ROTATORANIMATION_ON
				float2 staticSwitch474 = panner513;
			#else
				float2 staticSwitch474 = uv_TexCoord322;
			#endif
			float2 UV323 = staticSwitch474;
			float4 BrumeTextureSample329 = tex2D( _BrumeTexture, UV323 );
			float smoothstepResult526 = smoothstep( _BrumeEdges_Smoothstep , ( _BrumeEdges_Smoothstep + ( ( _CosTime.w * 0.4 ) + 1.0 ) ) , BrumeTextureSample329.r);
			float clampResult522 = clamp( ( (tex2DNode516.r*_OpacityMask_Scale + _OpacityMask_Offset) - smoothstepResult526 ) , 0.0 , 1.0 );
			float BrumeOpacity420 = ( DepthFade574 * clampResult522 );
			float2 temp_output_2_0_g1 = UV323;
			float2 break6_g1 = temp_output_2_0_g1;
			float temp_output_25_0_g1 = ( pow( _NormalOffset , 3.0 ) * 0.1 );
			float2 appendResult8_g1 = (float2(( break6_g1.x + temp_output_25_0_g1 ) , break6_g1.y));
			float4 tex2DNode14_g1 = tex2D( _BrumeTexture, temp_output_2_0_g1 );
			float temp_output_4_0_g1 = _NormalStrength;
			float3 appendResult13_g1 = (float3(1.0 , 0.0 , ( ( tex2D( _BrumeTexture, appendResult8_g1 ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float2 appendResult9_g1 = (float2(break6_g1.x , ( break6_g1.y + temp_output_25_0_g1 )));
			float3 appendResult16_g1 = (float3(0.0 , 1.0 , ( ( tex2D( _BrumeTexture, appendResult9_g1 ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float3 normalizeResult22_g1 = normalize( cross( appendResult13_g1 , appendResult16_g1 ) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult177 = dot( (WorldNormalVector( i , normalizeResult22_g1 )) , ase_worldlightDir );
			float normal_LightDir180 = ( dotResult177 * ase_lightAtten );
			float lerpResult449 = lerp( 1.0 , normal_LightDir180 , _LightNormal);
			float4 lerpResult314 = lerp( _BrumeColor_ColorLow , _BrumeColor_ColorHigh , ( lerpResult449 * BrumeTextureSample329 ));
			float4 BrumeColor315 = lerpResult314;
			c.rgb = BrumeColor315.rgb;
			c.a = BrumeOpacity420;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18707
0;0;1920;1019;9762.707;5756.523;6.775102;True;False
Node;AmplifyShaderEditor.CommentaryNode;164;-3465.936,-3395.754;Inherit;False;2165.693;783.9038;UV;17;323;474;513;473;515;322;508;495;496;502;402;509;476;511;512;478;501;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinTimeNode;501;-3277.75,-3161.566;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;440;-3463.359,-4223.959;Inherit;False;1837.985;805.8237;Noise;16;414;337;355;372;358;367;373;357;340;375;374;369;376;368;370;341;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;512;-3429.901,-3005.708;Inherit;False;Property;_BrumeAnimation_WaveFrequency;BrumeAnimation_WaveFrequency;31;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;478;-3410.691,-2917.321;Inherit;False;Property;_BrumeAnimation_RotatorTime;BrumeAnimation_RotatorTime;29;0;Create;True;0;0;False;1;Header(Brume Animation);False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;476;-3125.691,-2908.321;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-3413.359,-4147.363;Inherit;False;Property;_PerlinNoise_Tiling;PerlinNoise_Tiling;24;0;Create;True;0;0;False;0;False;0.1;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;511;-3092.9,-3027.708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;509;-3103.198,-2807.591;Inherit;False;Property;_BrumeAnimation_WaveStrength;BrumeAnimation_WaveStrength;30;0;Create;True;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;502;-2902.642,-2941.323;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;368;-3205.359,-4051.362;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;496;-2945.225,-3073.113;Inherit;False;Constant;_Float17;Float 17;31;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-3189.359,-3971.362;Inherit;False;Constant;_Float5;Float 5;29;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;402;-3134.5,-3262.15;Inherit;False;Property;_BrumeTexture_Tiling;BrumeTexture_Tiling;3;0;Create;True;0;0;False;0;False;2;2.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;508;-2755.198,-2869.591;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;369;-3045.359,-4019.362;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;376;-2997.359,-3747.361;Inherit;False;Constant;_Float7;Float 7;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;374;-3029.359,-3859.363;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;322;-2864.052,-3280.805;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;-2787.225,-3135.113;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;357;-2693.36,-3619.361;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-2853.359,-3859.363;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-2917.359,-4163.363;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;373;-2677.36,-3523.361;Inherit;False;Constant;_Float6;Float 6;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;515;-2526.992,-2782.576;Inherit;False;Property;_BrumeAnimation_PannerSpeed;BrumeAnimation_PannerSpeed;32;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RotatorNode;473;-2565.087,-3006.273;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;-2517.36,-3571.361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;358;-2661.36,-3763.361;Inherit;False;Property;_PerlinNoise_PannerSpeed;PerlinNoise_PannerSpeed;25;0;Create;True;0;0;False;0;False;0,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;513;-2203.522,-2906.281;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;367;-2661.36,-3987.362;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;355;-2373.36,-3843.362;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;474;-1832.512,-3158.133;Inherit;False;Property;_RotatorAnimation;RotatorAnimation?;4;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;441;-3456.108,-4551.423;Inherit;False;1247.329;286;Texture;5;329;327;328;128;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;337;-2181.359,-3875.363;Inherit;True;Property;_PerlinNoise_Texture;PerlinNoise_Texture;23;0;Create;True;0;0;False;1;Header(Noise);False;-1;f6ff7a2b76d9a074eb1c734d22e9cb35;f6ff7a2b76d9a074eb1c734d22e9cb35;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3406.108,-4500.423;Inherit;True;Property;_BrumeTexture;BrumeTexture;2;0;Create;True;0;0;False;0;False;9338f0dfd38c86b4ca38561628f333f1;d59eab6cece9db54b90d982bd90cd50d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1519.088,-3159.302;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;414;-1884.095,-3874.961;Inherit;False;MovingPerlinNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;556;-3473.63,-1621.067;Inherit;False;3539.135;962.1111;Displacement;27;558;267;241;548;239;547;549;553;325;551;552;234;326;406;235;330;411;407;412;415;410;408;409;565;564;567;563;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-3148.764,-4410.318;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-3168.108,-4501.423;Inherit;False;BrumeTexture;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;327;-2756.24,-4504.806;Inherit;True;Property;_TextureSample2;Texture Sample 2;29;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;410;-3354.486,-884.1597;Inherit;False;Constant;_Float10;Float 10;32;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;415;-3430.982,-1222.016;Inherit;True;414;MovingPerlinNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;409;-3355.213,-952.6536;Inherit;False;Constant;_Float9;Float 9;32;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-3353.007,-1025.97;Inherit;False;Constant;_Float8;Float 8;32;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;171;-2196.127,-4700.583;Inherit;False;1849.498;433.2894;Normal Light Dir;11;180;179;177;178;176;175;273;276;277;274;275;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-2127.795,-4417.019;Inherit;False;Property;_NormalStrength;NormalStrength;21;0;Create;True;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;412;-2995.063,-881.4346;Inherit;False;Property;_WaveNoiseContrast;WaveNoiseContrast;26;0;Create;True;0;0;False;0;False;4;2.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-2124.795,-4493.019;Inherit;False;Property;_NormalOffset;NormalOffset;22;0;Create;True;0;0;False;0;False;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-2146.418,-4572.443;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-2153.318,-4650.386;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-2458.779,-4504.79;Inherit;False;BrumeTextureSample;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;407;-3188.532,-1091.141;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;411;-2761.154,-1033.973;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;555;-3467.056,-2588.599;Inherit;False;2863.207;949.2275;OpacityMask;22;575;420;578;522;523;518;524;526;519;521;527;528;520;529;535;517;537;534;566;516;532;533;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-2941.964,-1290.649;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;273;-1898.587,-4621.773;Inherit;True;NormalCreate;0;;1;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;175;-1395.239,-4471.015;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;-2383.528,-1145.33;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-2073.416,-894.5236;Inherit;False;Property;_DisplacementTexture_Multiply;DisplacementTexture_Multiply;18;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;176;-1379.239,-4615.015;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CosTime;532;-3417.056,-1998.04;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;533;-3414.135,-1839.421;Inherit;False;Constant;_Float21;Float 21;37;0;Create;True;0;0;False;0;False;0.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;516;-2896.571,-2538.599;Inherit;True;Property;_OpacityMask_Texture;OpacityMask_Texture;33;0;Create;True;0;0;False;1;Header(Opacity);False;-1;a24af4bf25040b448bb7a647ef0953a7;a24af4bf25040b448bb7a647ef0953a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;580;-1273.936,-3392.316;Inherit;False;1179.571;384.1917;DepthFade;6;574;573;579;568;572;569;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;569;-1239.728,-3237.478;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;40;0;Create;True;0;0;False;1;Header(Depth Fade);False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;178;-1107.238,-4343.014;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;326;-1899.273,-800.6846;Inherit;False;Property;_DisplacementTexture_Contrast;DisplacementTexture_Contrast;19;0;Create;True;0;0;False;0;False;1;0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;177;-1123.238,-4615.015;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;566;-2520.313,-2538.691;Inherit;False;OpacityMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;537;-3268.151,-1748.702;Inherit;False;Constant;_Float22;Float 22;37;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;534;-3271.136,-1859.421;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;-1794.644,-1132.307;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;551;-1512.554,-901.6416;Inherit;False;Property;_BrumeVolumeTransition_Blend;BrumeVolumeTransition_Blend;37;0;Create;True;0;0;False;1;Header(Brume Volume Transition);False;5;5;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-835.2373,-4615.015;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;535;-3106.151,-1767.702;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;552;-1377.553,-817.6416;Inherit;False;Constant;_Float24;Float 24;37;0;Create;True;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;564;-1759.032,-1460.689;Inherit;False;Property;_BrumeVolumeTransition_Scale;BrumeVolumeTransition_Scale;38;0;Create;True;0;0;False;0;False;0.3;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;529;-2981.801,-2030.102;Inherit;False;Property;_BrumeEdges_Smoothstep;BrumeEdges_Smoothstep;36;0;Create;True;0;0;False;1;Header(Brume Edges);False;0.3;0.37;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;568;-1008.541,-3324.898;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;565;-1762.032,-1378.689;Inherit;False;Property;_BrumeVolumeTransition_Offset;BrumeVolumeTransition_Offset;39;0;Create;True;0;0;False;0;False;1.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;572;-974.6486,-3156.267;Inherit;False;Property;_DepthFade_Power;DepthFade_Power;41;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;517;-3276.601,-2243.288;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;567;-1658.749,-1549.649;Inherit;False;566;OpacityMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;325;-1561.812,-1131.805;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.92;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;579;-740.6537,-3255.255;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;520;-2773.704,-2302.21;Inherit;False;Property;_OpacityMask_Scale;OpacityMask_Scale;34;0;Create;True;0;0;False;0;False;5;7.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;549;-1280.406,-1259.373;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-551.4112,-4620.581;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;447;-1595.039,-4221.434;Inherit;False;1369.623;791.6198;Color;10;449;311;451;450;336;314;313;312;335;315;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;563;-1415.32,-1489.031;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;521;-2774.704,-2224.21;Inherit;False;Property;_OpacityMask_Offset;OpacityMask_Offset;35;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;528;-2696.801,-1927.102;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;527;-3041.136,-2238.558;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;553;-1234.554,-881.6416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;557;-332.627,-4704.568;Inherit;False;1048.449;435.2094;Tesselation;7;264;240;266;238;236;237;560;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;573;-547.9108,-3255.41;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;519;-2533.704,-2355.21;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;450;-1435.652,-3840.119;Inherit;False;Constant;_Float2;Float 2;26;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;451;-1550.008,-3679.298;Inherit;False;Property;_LightNormal;LightNormal?;20;0;Create;True;0;0;False;1;Header(Light Normal);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;526;-2527.136,-2049.558;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.48;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1500.663,-3759.336;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;547;-1122.263,-1324.785;Inherit;True;Height-based Blending;-1;;2;31c0084e26e17dc4c963d2f60261c022;0;6;13;COLOR;0,0,0,0;False;12;FLOAT;0;False;4;FLOAT;0.79;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;-0.75;False;2;COLOR;15;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;238;-282.627,-4531.118;Inherit;False;Property;_Tesselation_Factor;Tesselation_Factor;14;0;Create;True;0;0;False;0;False;15;64;1;128;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-225.4048,-4382.086;Inherit;False;Property;_Tesselation_MaxDist;Tesselation_MaxDist;16;0;Create;True;0;0;False;0;False;5;300;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-221.4048,-4456.086;Inherit;False;Property;_Tesselation_MinDist;Tesselation_MinDist;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;548;-780.4786,-1239.525;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;524;-1814.856,-2118.07;Inherit;False;Constant;_Float18;Float 18;35;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;-1309.333,-3556.901;Inherit;False;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;239;-823.0677,-963.9876;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;518;-2029.704,-2267.21;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;574;-309.3638,-3260.386;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;449;-1256.752,-3777.319;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;523;-1814.856,-2190.069;Inherit;False;Constant;_Float13;Float 13;35;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;312;-1067.795,-4139.609;Inherit;False;Property;_BrumeColor_ColorLow;BrumeColor_ColorLow;27;0;Create;True;0;0;False;1;Header(Brume Color);False;0.4,0.4470589,0.509804,1;0.2474189,0.3427079,0.3773584,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;575;-1453.035,-2398.908;Inherit;False;574;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-987.7296,-3668.412;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;240;9.596161,-4516.086;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;266;85.37003,-4654.568;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-603.6436,-1044.627;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;313;-1067.336,-3958.437;Inherit;False;Property;_BrumeColor_ColorHigh;BrumeColor_ColorHigh;28;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;522;-1587.486,-2267.212;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;578;-1161.928,-2291.558;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;267;-439.9783,-1074.166;Inherit;False;Property;_Displacement;Displacement?;17;0;Create;True;0;0;False;1;Header(Displacement);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;264;252.829,-4629.858;Inherit;False;Property;_Tesselation;Tesselation?;13;0;Create;True;0;0;False;1;Header(Tesselation);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;314;-745.4819,-3959.716;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;560;485.4852,-4629.924;Inherit;False;BrumeTesselation;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;554;-6585.927,-2569.837;Inherit;False;1623.811;655.3071;Flipbook Animation;15;321;222;221;223;225;226;439;224;438;437;278;305;279;256;228;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;562;752.6329,-4817.349;Inherit;False;672.7769;531.2505;BrumeFinal;5;0;324;292;559;561;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;-454.9479,-3963.927;Inherit;False;BrumeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;558;-167.336,-1094.914;Inherit;False;BrumeDisplacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;420;-858.0571,-2270.679;Inherit;True;BrumeOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-6535.927,-2488.905;Inherit;False;Property;_Flipbook_Tiling;Flipbook_Tiling;9;0;Create;True;0;0;False;0;False;1;-1.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;226;-6042.176,-2071.191;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-6042.176,-2311.192;Inherit;False;Property;_Flipbook_Columns;Flipbook_Columns;10;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;843.2217,-4643.053;Inherit;False;420;BrumeOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;844.6368,-4566.714;Inherit;False;315;BrumeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;279;-6495.271,-2016.826;Inherit;False;Constant;_Float1;Float 1;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-6042.176,-2151.192;Inherit;False;Property;_Flipbook_Speed;Flipbook_Speed;8;0;Create;True;0;0;False;0;False;1;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;439;-6003.746,-2485.978;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;305;-6360.477,-2507.532;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;559;802.6329,-4483.932;Inherit;False;558;BrumeDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-6509.795,-2096.119;Inherit;False;Property;_Flipbook_Time;Flipbook_Time;12;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;438;-6141.24,-2435.439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;561;815.8707,-4402.099;Inherit;False;560;BrumeTesselation;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-6042.176,-2230.192;Inherit;False;Property;_Flipbook_Rows;Flipbook_Rows;11;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-5527.44,-2299.564;Inherit;False;UvAnimation;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StaticSwitch;321;-5256.088,-2390.177;Inherit;False;Property;_Flipbook_Animation;Flipbook_Animation?;6;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;437;-6139.24,-2504.439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;221;-5818.177,-2292.605;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;278;-6292.312,-2080.516;Inherit;False;Property;_AnimationPause;AnimationPause;5;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1170.409,-4767.349;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;BrumeVolume;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;7;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;476;0;478;0
WireConnection;511;0;501;4
WireConnection;511;1;512;0
WireConnection;502;0;511;0
WireConnection;502;1;476;0
WireConnection;368;0;341;0
WireConnection;508;0;502;0
WireConnection;508;1;509;0
WireConnection;369;0;368;0
WireConnection;369;1;370;0
WireConnection;322;0;402;0
WireConnection;495;0;402;0
WireConnection;495;1;496;0
WireConnection;375;0;374;0
WireConnection;375;1;376;0
WireConnection;340;0;341;0
WireConnection;340;1;369;0
WireConnection;473;0;322;0
WireConnection;473;1;495;0
WireConnection;473;2;508;0
WireConnection;372;0;357;0
WireConnection;372;1;373;0
WireConnection;513;0;473;0
WireConnection;513;2;515;0
WireConnection;513;1;508;0
WireConnection;367;0;340;0
WireConnection;367;2;375;0
WireConnection;355;0;367;0
WireConnection;355;2;358;0
WireConnection;355;1;372;0
WireConnection;474;1;322;0
WireConnection;474;0;513;0
WireConnection;337;1;355;0
WireConnection;323;0;474;0
WireConnection;414;0;337;1
WireConnection;128;0;18;0
WireConnection;327;0;128;0
WireConnection;327;1;328;0
WireConnection;329;0;327;0
WireConnection;407;0;415;0
WireConnection;407;1;408;0
WireConnection;407;2;410;0
WireConnection;407;3;409;0
WireConnection;407;4;410;0
WireConnection;411;1;407;0
WireConnection;411;0;412;0
WireConnection;273;1;274;0
WireConnection;273;2;275;0
WireConnection;273;3;276;0
WireConnection;273;4;277;0
WireConnection;406;0;330;0
WireConnection;406;1;411;0
WireConnection;176;0;273;0
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;566;0;516;0
WireConnection;534;0;532;4
WireConnection;534;1;533;0
WireConnection;234;0;406;0
WireConnection;234;1;235;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;535;0;534;0
WireConnection;535;1;537;0
WireConnection;568;0;569;0
WireConnection;325;1;234;0
WireConnection;325;0;326;0
WireConnection;579;0;568;0
WireConnection;579;1;572;0
WireConnection;549;0;325;0
WireConnection;180;0;179;0
WireConnection;563;0;567;0
WireConnection;563;1;564;0
WireConnection;563;2;565;0
WireConnection;528;0;529;0
WireConnection;528;1;535;0
WireConnection;527;0;517;0
WireConnection;553;0;551;0
WireConnection;553;1;552;0
WireConnection;573;0;579;0
WireConnection;519;0;516;1
WireConnection;519;1;520;0
WireConnection;519;2;521;0
WireConnection;526;0;527;0
WireConnection;526;1;529;0
WireConnection;526;2;528;0
WireConnection;547;12;549;0
WireConnection;547;1;563;0
WireConnection;547;3;553;0
WireConnection;548;0;547;15
WireConnection;518;0;519;0
WireConnection;518;1;526;0
WireConnection;574;0;573;0
WireConnection;449;0;450;0
WireConnection;449;1;311;0
WireConnection;449;2;451;0
WireConnection;335;0;449;0
WireConnection;335;1;336;0
WireConnection;240;0;238;0
WireConnection;240;1;236;0
WireConnection;240;2;237;0
WireConnection;241;0;548;0
WireConnection;241;1;239;0
WireConnection;522;0;518;0
WireConnection;522;1;523;0
WireConnection;522;2;524;0
WireConnection;578;0;575;0
WireConnection;578;1;522;0
WireConnection;267;0;241;0
WireConnection;264;1;266;0
WireConnection;264;0;240;0
WireConnection;314;0;312;0
WireConnection;314;1;313;0
WireConnection;314;2;335;0
WireConnection;560;0;264;0
WireConnection;315;0;314;0
WireConnection;558;0;267;0
WireConnection;420;0;578;0
WireConnection;226;0;278;0
WireConnection;439;0;437;0
WireConnection;439;1;438;0
WireConnection;305;0;228;0
WireConnection;438;0;305;2
WireConnection;222;0;221;0
WireConnection;321;0;222;0
WireConnection;437;0;305;1
WireConnection;221;0;439;0
WireConnection;221;1;223;0
WireConnection;221;2;224;0
WireConnection;221;3;225;0
WireConnection;221;5;226;0
WireConnection;278;1;256;0
WireConnection;278;0;279;0
WireConnection;0;9;324;0
WireConnection;0;13;292;0
WireConnection;0;11;559;0
WireConnection;0;14;561;0
ASEEND*/
//CHKSM=2C6552BCD37E81712AE9BB09D6530537CADA5A32
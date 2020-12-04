// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrumeVolume"
{
	Properties
	{
		_BrumeTexture("BrumeTexture", 2D) = "white" {}
		[Toggle(_FLIPBOOK_ANIMATION_ON)] _Flipbook_Animation("Flipbook_Animation?", Float) = 0
		[Toggle(_ROTATIONPAUSE_ON)] _RotationPause("RotationPause", Float) = 1
		[Toggle(_ANIMATIONPAUSE_ON)] _AnimationPause("AnimationPause", Float) = 1
		_Flipbook_Speed("Flipbook_Speed", Float) = 1
		_Flipbook_Tiling("Flipbook_Tiling", Float) = 1
		_Rotator_Time("Rotator_Time", Float) = 1
		_Flipbook_Columns("Flipbook_Columns", Float) = 1
		_Flipbook_Rows("Flipbook_Rows", Float) = 1
		_Flipbook_Time("Flipbook_Time", Float) = 1
		[Toggle(_TESSELATION_ON)] _Tesselation("Tesselation?", Float) = 0
		_Tesselation_Factor("Tesselation_Factor", Range( 1 , 64)) = 15
		_Tesselation_MinDist("Tesselation_MinDist", Float) = 0
		_Tesselation_MaxDist("Tesselation_MaxDist", Float) = 5
		[Toggle(_DISPLACEMENT_ON)] _Displacement("Displacement?", Float) = 0
		_DisplacementTexture_Multiply("DisplacementTexture_Multiply", Float) = 1
		_DisplacementTexture_Contrast("DisplacementTexture_Contrast", Float) = 1
		_NormalStrength("NormalStrength", Float) = 2
		_NormalOffset("NormalOffset", Float) = 0.5
		_BrumeColor_ColorLow("BrumeColor_ColorLow", Color) = (0.4,0.4470589,0.509804,1)
		_PerlinNoise_Tiling("PerlinNoise_Tiling", Float) = 0.1
		_PerlinNoise_PannerSpeed("PerlinNoise_PannerSpeed", Vector) = (0,0,0,0)
		_PerlinNoise("PerlinNoise", 2D) = "white" {}
		_BrumeColor_ColorHigh("BrumeColor_ColorHigh", Color) = (1,1,1,0)
		_Texture_Tiling("Texture_Tiling", Float) = 1
		_WaveNoiseContrast("WaveNoiseContrast", Float) = 4
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		#pragma shader_feature_local _DISPLACEMENT_ON
		#pragma shader_feature_local _FLIPBOOK_ANIMATION_ON
		#pragma shader_feature_local _ROTATIONPAUSE_ON
		#pragma shader_feature_local _ANIMATIONPAUSE_ON
		#pragma shader_feature_local _TESSELATION_ON
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
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
		uniform float _Texture_Tiling;
		uniform float _Flipbook_Tiling;
		uniform float _Rotator_Time;
		uniform float _Flipbook_Columns;
		uniform float _Flipbook_Rows;
		uniform float _Flipbook_Speed;
		uniform float _Flipbook_Time;
		uniform float _WaveNoiseContrast;
		uniform sampler2D _PerlinNoise;
		uniform float2 _PerlinNoise_PannerSpeed;
		uniform float _PerlinNoise_Tiling;
		uniform float _DisplacementTexture_Multiply;
		uniform float4 _BrumeColor_ColorLow;
		uniform float4 _BrumeColor_ColorHigh;
		uniform float _NormalOffset;
		uniform float _NormalStrength;
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
			float4 temp_cast_10 = (1.0).xxxx;
			#ifdef _TESSELATION_ON
				float4 staticSwitch264 = UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _Tesselation_MinDist,_Tesselation_MaxDist,_Tesselation_Factor);
			#else
				float4 staticSwitch264 = temp_cast_10;
			#endif
			return staticSwitch264;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (_Texture_Tiling).xx;
			float2 uv_TexCoord322 = v.texcoord.xy * temp_cast_0;
			float2 temp_cast_1 = (_Flipbook_Tiling).xx;
			float2 uv_TexCoord305 = v.texcoord.xy * temp_cast_1;
			#ifdef _ROTATIONPAUSE_ON
				float staticSwitch333 = 0.0;
			#else
				float staticSwitch333 = _Rotator_Time;
			#endif
			float mulTime308 = _Time.y * staticSwitch333;
			float cos306 = cos( mulTime308 );
			float sin306 = sin( mulTime308 );
			float2 rotator306 = mul( uv_TexCoord305 - float2( 0.5,0.5 ) , float2x2( cos306 , -sin306 , sin306 , cos306 )) + float2( 0.5,0.5 );
			#ifdef _ANIMATIONPAUSE_ON
				float staticSwitch278 = 0.0;
			#else
				float staticSwitch278 = _Flipbook_Time;
			#endif
			float mulTime226 = _Time.y * staticSwitch278;
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles221 = _Flipbook_Columns * _Flipbook_Rows;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset221 = 1.0f / _Flipbook_Columns;
			float fbrowsoffset221 = 1.0f / _Flipbook_Rows;
			// Speed of animation
			float fbspeed221 = mulTime226 * _Flipbook_Speed;
			// UV Tiling (col and row offset)
			float2 fbtiling221 = float2(fbcolsoffset221, fbrowsoffset221);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex221 = round( fmod( fbspeed221 + 0.0, fbtotaltiles221) );
			fbcurrenttileindex221 += ( fbcurrenttileindex221 < 0) ? fbtotaltiles221 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox221 = round ( fmod ( fbcurrenttileindex221, _Flipbook_Columns ) );
			// Multiply Offset X by coloffset
			float fboffsetx221 = fblinearindextox221 * fbcolsoffset221;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy221 = round( fmod( ( fbcurrenttileindex221 - fblinearindextox221 ) / _Flipbook_Columns, _Flipbook_Rows ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy221 = (int)(_Flipbook_Rows-1) - fblinearindextoy221;
			// Multiply Offset Y by rowoffset
			float fboffsety221 = fblinearindextoy221 * fbrowsoffset221;
			// UV Offset
			float2 fboffset221 = float2(fboffsetx221, fboffsety221);
			// Flipbook UV
			half2 fbuv221 = rotator306 * fbtiling221 + fboffset221;
			// *** END Flipbook UV Animation vars ***
			float2 UvAnimation222 = fbuv221;
			#ifdef _FLIPBOOK_ANIMATION_ON
				float2 staticSwitch321 = UvAnimation222;
			#else
				float2 staticSwitch321 = uv_TexCoord322;
			#endif
			float2 UV323 = staticSwitch321;
			float4 BrumeTextureSample329 = tex2Dlod( _BrumeTexture, float4( UV323, 0, 0.0) );
			float2 temp_cast_2 = (_PerlinNoise_Tiling).xx;
			float2 temp_cast_3 = (( ( 1.0 - _PerlinNoise_Tiling ) / 2.0 )).xx;
			float2 uv_TexCoord340 = v.texcoord.xy * temp_cast_2 + temp_cast_3;
			float cos367 = cos( ( _Time.y * 0.05 ) );
			float sin367 = sin( ( _Time.y * 0.05 ) );
			float2 rotator367 = mul( uv_TexCoord340 - float2( 0.5,0.5 ) , float2x2( cos367 , -sin367 , sin367 , cos367 )) + float2( 0.5,0.5 );
			float2 panner355 = ( ( _Time.y * 0.05 ) * _PerlinNoise_PannerSpeed + rotator367);
			float4 tex2DNode337 = tex2Dlod( _PerlinNoise, float4( panner355, 0, 0.0) );
			float4 MovingPerlinNoise414 = tex2DNode337;
			float4 temp_cast_4 = (0.0).xxxx;
			float4 temp_cast_5 = (1.0).xxxx;
			float4 temp_cast_6 = (0.5).xxxx;
			float4 temp_cast_7 = (1.0).xxxx;
			float4 temp_output_406_0 = ( BrumeTextureSample329 * CalculateContrast(_WaveNoiseContrast,(temp_cast_6 + (MovingPerlinNoise414 - temp_cast_4) * (temp_cast_7 - temp_cast_6) / (temp_cast_5 - temp_cast_4))) );
			float3 ase_vertexNormal = v.normal.xyz;
			#ifdef _DISPLACEMENT_ON
				float4 staticSwitch267 = ( CalculateContrast(_DisplacementTexture_Contrast,( temp_output_406_0 * _DisplacementTexture_Multiply )) * float4( ase_vertexNormal , 0.0 ) );
			#else
				float4 staticSwitch267 = float4( 0,0,0,0 );
			#endif
			v.vertex.xyz += staticSwitch267.rgb;
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
			float OpacityFinal420 = 1.0;
			float2 temp_cast_0 = (_Texture_Tiling).xx;
			float2 uv_TexCoord322 = i.uv_texcoord * temp_cast_0;
			float2 temp_cast_1 = (_Flipbook_Tiling).xx;
			float2 uv_TexCoord305 = i.uv_texcoord * temp_cast_1;
			#ifdef _ROTATIONPAUSE_ON
				float staticSwitch333 = 0.0;
			#else
				float staticSwitch333 = _Rotator_Time;
			#endif
			float mulTime308 = _Time.y * staticSwitch333;
			float cos306 = cos( mulTime308 );
			float sin306 = sin( mulTime308 );
			float2 rotator306 = mul( uv_TexCoord305 - float2( 0.5,0.5 ) , float2x2( cos306 , -sin306 , sin306 , cos306 )) + float2( 0.5,0.5 );
			#ifdef _ANIMATIONPAUSE_ON
				float staticSwitch278 = 0.0;
			#else
				float staticSwitch278 = _Flipbook_Time;
			#endif
			float mulTime226 = _Time.y * staticSwitch278;
			// *** BEGIN Flipbook UV Animation vars ***
			// Total tiles of Flipbook Texture
			float fbtotaltiles221 = _Flipbook_Columns * _Flipbook_Rows;
			// Offsets for cols and rows of Flipbook Texture
			float fbcolsoffset221 = 1.0f / _Flipbook_Columns;
			float fbrowsoffset221 = 1.0f / _Flipbook_Rows;
			// Speed of animation
			float fbspeed221 = mulTime226 * _Flipbook_Speed;
			// UV Tiling (col and row offset)
			float2 fbtiling221 = float2(fbcolsoffset221, fbrowsoffset221);
			// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
			// Calculate current tile linear index
			float fbcurrenttileindex221 = round( fmod( fbspeed221 + 0.0, fbtotaltiles221) );
			fbcurrenttileindex221 += ( fbcurrenttileindex221 < 0) ? fbtotaltiles221 : 0;
			// Obtain Offset X coordinate from current tile linear index
			float fblinearindextox221 = round ( fmod ( fbcurrenttileindex221, _Flipbook_Columns ) );
			// Multiply Offset X by coloffset
			float fboffsetx221 = fblinearindextox221 * fbcolsoffset221;
			// Obtain Offset Y coordinate from current tile linear index
			float fblinearindextoy221 = round( fmod( ( fbcurrenttileindex221 - fblinearindextox221 ) / _Flipbook_Columns, _Flipbook_Rows ) );
			// Reverse Y to get tiles from Top to Bottom
			fblinearindextoy221 = (int)(_Flipbook_Rows-1) - fblinearindextoy221;
			// Multiply Offset Y by rowoffset
			float fboffsety221 = fblinearindextoy221 * fbrowsoffset221;
			// UV Offset
			float2 fboffset221 = float2(fboffsetx221, fboffsety221);
			// Flipbook UV
			half2 fbuv221 = rotator306 * fbtiling221 + fboffset221;
			// *** END Flipbook UV Animation vars ***
			float2 UvAnimation222 = fbuv221;
			#ifdef _FLIPBOOK_ANIMATION_ON
				float2 staticSwitch321 = UvAnimation222;
			#else
				float2 staticSwitch321 = uv_TexCoord322;
			#endif
			float2 UV323 = staticSwitch321;
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
			float4 BrumeTextureSample329 = tex2D( _BrumeTexture, UV323 );
			float4 lerpResult314 = lerp( _BrumeColor_ColorLow , _BrumeColor_ColorHigh , ( normal_LightDir180 * BrumeTextureSample329 ));
			float4 BrumeColor315 = lerpResult314;
			c.rgb = BrumeColor315.rgb;
			c.a = OpacityFinal420;
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
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				UnityGI gi;
				UNITY_INITIALIZE_OUTPUT( UnityGI, gi );
				o.Alpha = LightingStandardCustomLighting( o, worldViewDir, gi ).a;
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
0;0;1920;1019;643.073;4324.551;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;164;-3488.341,-2999.965;Inherit;False;1924.607;765.0575;Texture et UV;20;308;310;334;333;279;278;323;321;322;222;221;223;224;225;306;226;305;228;256;402;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;334;-3432.946,-2618.796;Inherit;False;Constant;_Float2;Float 2;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-3461.549,-2713.976;Inherit;False;Property;_Rotator_Time;Rotator_Time;9;0;Create;True;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;333;-3276.946,-2678.796;Inherit;False;Property;_RotationPause;RotationPause;5;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;279;-3312.922,-2331.875;Inherit;False;Constant;_Float1;Float 1;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-3327.445,-2411.168;Inherit;False;Property;_Flipbook_Time;Flipbook_Time;12;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-3288.977,-2868.653;Inherit;False;Property;_Flipbook_Tiling;Flipbook_Tiling;8;0;Create;True;0;0;False;0;False;1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;278;-3109.963,-2395.565;Inherit;False;Property;_AnimationPause;AnimationPause;6;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;305;-3057.527,-2886.28;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;308;-3021.16,-2725.156;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-2859.827,-2466.241;Inherit;False;Property;_Flipbook_Speed;Flipbook_Speed;7;0;Create;True;0;0;False;0;False;1;24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-2205.974,-5272.059;Inherit;False;Property;_PerlinNoise_Tiling;PerlinNoise_Tiling;25;0;Create;True;0;0;False;0;False;0.1;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;306;-2836.16,-2814.156;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-2859.827,-2545.241;Inherit;False;Property;_Flipbook_Rows;Flipbook_Rows;11;0;Create;True;0;0;False;0;False;1;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;226;-2859.827,-2386.24;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-2859.827,-2626.241;Inherit;False;Property;_Flipbook_Columns;Flipbook_Columns;10;0;Create;True;0;0;False;0;False;1;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;368;-1997.974,-5176.059;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-1981.974,-5096.059;Inherit;False;Constant;_Float5;Float 5;29;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;221;-2635.827,-2607.654;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;402;-2579.644,-2758.998;Inherit;False;Property;_Texture_Tiling;Texture_Tiling;30;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;374;-1821.974,-4984.06;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;369;-1837.974,-5144.059;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;376;-1789.974,-4872.06;Inherit;False;Constant;_Float7;Float 7;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-2345.091,-2614.613;Inherit;False;UvAnimation;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;322;-2363.196,-2777.653;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-1709.974,-5288.059;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;357;-1485.975,-4744.06;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-1645.974,-4984.06;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3312.122,-3272.118;Inherit;True;Property;_BrumeTexture;BrumeTexture;2;0;Create;True;0;0;False;0;False;9338f0dfd38c86b4ca38561628f333f1;9338f0dfd38c86b4ca38561628f333f1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;373;-1469.975,-4648.06;Inherit;False;Constant;_Float6;Float 6;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;321;-2129.515,-2703.657;Inherit;False;Property;_Flipbook_Animation;Flipbook_Animation?;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;171;-3491.643,-2222.146;Inherit;False;1849.498;433.2894;Normal Light Dir;11;180;179;177;178;176;175;273;276;277;274;275;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;358;-1453.975,-4888.06;Inherit;False;Property;_PerlinNoise_PannerSpeed;PerlinNoise_PannerSpeed;27;0;Create;True;0;0;False;0;False;0,0;0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;-1309.975,-4696.06;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;367;-1453.975,-5112.059;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1839.508,-2704.014;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-3074.122,-3273.118;Inherit;False;BrumeTexture;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;355;-1165.975,-4968.06;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-3441.933,-2094.006;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-3448.834,-2171.948;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-3423.31,-1938.581;Inherit;False;Property;_NormalStrength;NormalStrength;20;0;Create;True;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-3420.31,-2014.581;Inherit;False;Property;_NormalOffset;NormalOffset;21;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;337;-973.9749,-5000.06;Inherit;True;Property;_PerlinNoise;PerlinNoise;28;0;Create;True;0;0;False;0;False;-1;f6ff7a2b76d9a074eb1c734d22e9cb35;f6ff7a2b76d9a074eb1c734d22e9cb35;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;273;-3194.103,-2143.336;Inherit;True;NormalCreate;0;;1;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;176;-2674.753,-2136.577;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;175;-2690.753,-1992.577;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;414;-601.2184,-5298.656;Inherit;False;MovingPerlinNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-3054.778,-3182.013;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;327;-2867.254,-3272.501;Inherit;True;Property;_TextureSample2;Texture Sample 2;29;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;409;-652.4246,-1819.576;Inherit;False;Constant;_Float9;Float 9;32;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-650.2191,-1892.892;Inherit;False;Constant;_Float8;Float 8;32;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;410;-651.6985,-1751.082;Inherit;False;Constant;_Float10;Float 10;32;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;177;-2418.753,-2136.577;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;415;-733.194,-1978.938;Inherit;False;414;MovingPerlinNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;178;-2402.753,-1864.576;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;407;-485.7445,-1958.063;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-2569.793,-3272.485;Inherit;False;BrumeTextureSample;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;412;-273.2752,-1802.357;Inherit;False;Property;_WaveNoiseContrast;WaveNoiseContrast;31;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-2130.752,-2136.577;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-30.71961,-2106.31;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-1846.926,-2142.143;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;411;-1.366493,-1893.895;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;235;629.3723,-1761.446;Inherit;False;Property;_DisplacementTexture_Multiply;DisplacementTexture_Multiply;18;0;Create;True;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;-3491.295,-1218.64;Inherit;False;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-3454.068,-1338.644;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;319.2597,-2012.253;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;326;803.5151,-1667.607;Inherit;False;Property;_DisplacementTexture_Contrast;DisplacementTexture_Contrast;19;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;313;-3303.555,-1574.909;Inherit;False;Property;_BrumeColor_ColorHigh;BrumeColor_ColorHigh;29;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;908.1443,-1999.23;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;312;-3304.014,-1756.08;Inherit;False;Property;_BrumeColor_ColorLow;BrumeColor_ColorLow;24;0;Create;True;0;0;False;0;False;0.4,0.4470589,0.509804,1;0.6527234,0.6967309,0.7169812,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-3223.948,-1284.884;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;238;1782.81,-1546.083;Inherit;False;Property;_Tesselation_Factor;Tesselation_Factor;14;0;Create;True;0;0;False;0;False;15;20;1;64;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;1844.032,-1471.052;Inherit;False;Property;_Tesselation_MinDist;Tesselation_MinDist;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;314;-2981.701,-1576.188;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;435;619.1626,-4003.218;Inherit;False;Constant;_Float13;Float 13;31;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;239;1703.722,-1763.91;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;325;1140.977,-1998.728;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.92;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;237;1840.032,-1397.052;Inherit;False;Property;_Tesselation_MaxDist;Tesselation_MaxDist;16;0;Create;True;0;0;False;0;False;5;35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;420;799.9921,-3986.863;Inherit;False;OpacityFinal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;1923.147,-1844.549;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;-2691.161,-1580.399;Inherit;False;BrumeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;240;2075.033,-1531.052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;266;2150.807,-1669.534;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;432;-125.9033,-2759.361;Inherit;False;Constant;_Float11;Float 11;31;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;364;-429.9745,-4616.06;Inherit;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;False;0;False;-0.03;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;2542.567,-2095.401;Inherit;False;420;OpacityFinal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;257;-613.8998,-3736.55;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;352;674.0257,-4824.06;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;417;-940.9424,-4254.97;Inherit;False;GroundMaskTexture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;431;281.0967,-2694.361;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;423;-201.8084,-2461.261;Inherit;False;417;GroundMaskTexture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;434;34.09668,-2639.361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;433;-134.9033,-2619.361;Inherit;False;Constant;_Float12;Float 12;31;0;Create;True;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;363;-429.9745,-4712.06;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;264;2318.267,-1644.824;Inherit;False;Property;_Tesselation;Tesselation?;13;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;2545.982,-1999.062;Inherit;False;315;BrumeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;267;2086.812,-1874.088;Inherit;False;Property;_Displacement;Displacement?;17;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;360;-573.9747,-5000.06;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;377;-221.9745,-4760.06;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;186;-77.97456,-4248.06;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;430;629.0593,-2288.335;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;181;-1246.975,-4255.06;Inherit;True;Property;_GroundMask_Texture;GroundMask_Texture;22;0;Create;True;0;0;False;0;False;-1;a24af4bf25040b448bb7a647ef0953a7;a24af4bf25040b448bb7a647ef0953a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;182;-893.6598,-3945.735;Inherit;False;Property;_GroundMask_Scale;GroundMask_Scale;23;0;Create;True;0;0;False;0;False;2.49;2.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;204;-897.9764,-3869.574;Inherit;False;Property;_GroundMask_Offset;GroundMask_Offset;26;0;Create;True;0;0;False;0;False;0;-0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;421;431.684,-3904.129;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;351;66.02553,-4760.06;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;185;-301.5445,-3908.819;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;359;-221.9745,-4536.06;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;200;-624.3488,-3980.561;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0.66;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2879.755,-2197.697;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;BrumeVolume;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;4;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;333;1;310;0
WireConnection;333;0;334;0
WireConnection;278;1;256;0
WireConnection;278;0;279;0
WireConnection;305;0;228;0
WireConnection;308;0;333;0
WireConnection;306;0;305;0
WireConnection;306;2;308;0
WireConnection;226;0;278;0
WireConnection;368;0;341;0
WireConnection;221;0;306;0
WireConnection;221;1;223;0
WireConnection;221;2;224;0
WireConnection;221;3;225;0
WireConnection;221;5;226;0
WireConnection;369;0;368;0
WireConnection;369;1;370;0
WireConnection;222;0;221;0
WireConnection;322;0;402;0
WireConnection;340;0;341;0
WireConnection;340;1;369;0
WireConnection;375;0;374;0
WireConnection;375;1;376;0
WireConnection;321;1;322;0
WireConnection;321;0;222;0
WireConnection;372;0;357;0
WireConnection;372;1;373;0
WireConnection;367;0;340;0
WireConnection;367;2;375;0
WireConnection;323;0;321;0
WireConnection;128;0;18;0
WireConnection;355;0;367;0
WireConnection;355;2;358;0
WireConnection;355;1;372;0
WireConnection;337;1;355;0
WireConnection;273;1;274;0
WireConnection;273;2;275;0
WireConnection;273;3;276;0
WireConnection;273;4;277;0
WireConnection;176;0;273;0
WireConnection;414;0;337;0
WireConnection;327;0;128;0
WireConnection;327;1;328;0
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;407;0;415;0
WireConnection;407;1;408;0
WireConnection;407;2;410;0
WireConnection;407;3;409;0
WireConnection;407;4;410;0
WireConnection;329;0;327;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;180;0;179;0
WireConnection;411;1;407;0
WireConnection;411;0;412;0
WireConnection;406;0;330;0
WireConnection;406;1;411;0
WireConnection;234;0;406;0
WireConnection;234;1;235;0
WireConnection;335;0;311;0
WireConnection;335;1;336;0
WireConnection;314;0;312;0
WireConnection;314;1;313;0
WireConnection;314;2;335;0
WireConnection;325;1;234;0
WireConnection;325;0;326;0
WireConnection;420;0;435;0
WireConnection;241;0;325;0
WireConnection;241;1;239;0
WireConnection;315;0;314;0
WireConnection;240;0;238;0
WireConnection;240;1;236;0
WireConnection;240;2;237;0
WireConnection;352;1;351;0
WireConnection;417;0;181;0
WireConnection;431;0;423;0
WireConnection;431;1;432;0
WireConnection;431;2;434;0
WireConnection;434;0;432;0
WireConnection;434;1;433;0
WireConnection;264;1;266;0
WireConnection;264;0;240;0
WireConnection;267;0;241;0
WireConnection;360;0;337;0
WireConnection;360;1;417;0
WireConnection;377;0;360;0
WireConnection;377;1;363;0
WireConnection;377;2;364;0
WireConnection;186;0;417;0
WireConnection;186;1;185;0
WireConnection;430;0;431;0
WireConnection;430;1;406;0
WireConnection;421;0;200;0
WireConnection;351;0;377;0
WireConnection;351;1;359;0
WireConnection;185;0;200;0
WireConnection;185;1;257;0
WireConnection;200;0;417;0
WireConnection;200;1;182;0
WireConnection;200;2;204;0
WireConnection;0;9;324;0
WireConnection;0;13;292;0
WireConnection;0;11;267;0
WireConnection;0;14;264;0
ASEEND*/
//CHKSM=3BE433827F235CDDF3717874377922CF73FBD30F
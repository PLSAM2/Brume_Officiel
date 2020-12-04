// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrumeVolume"
{
	Properties
	{
		_BrumeTexture("BrumeTexture", 2D) = "white" {}
		[Toggle(_FLIPBOOK_ANIMATION_ON)] _Flipbook_Animation("Flipbook_Animation?", Float) = 0
		[Toggle(_ANIMATIONPAUSE_ON)] _AnimationPause("AnimationPause", Float) = 1
		_Flipbook_Speed("Flipbook_Speed", Float) = 1
		_Flipbook_Tiling("Flipbook_Tiling", Float) = 1
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
		_LightNormal("LightNormal?", Range( 0 , 1)) = 0
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
			float2 appendResult439 = (float2(frac( uv_TexCoord305.x ) , frac( uv_TexCoord305.y )));
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
			half2 fbuv221 = appendResult439 * fbtiling221 + fboffset221;
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
			float4 MovingPerlinNoise414 = tex2Dlod( _PerlinNoise, float4( panner355, 0, 0.0) );
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
			float2 appendResult439 = (float2(frac( uv_TexCoord305.x ) , frac( uv_TexCoord305.y )));
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
			half2 fbuv221 = appendResult439 * fbtiling221 + fboffset221;
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
			float lerpResult449 = lerp( 1.0 , normal_LightDir180 , _LightNormal);
			float2 temp_cast_2 = (_PerlinNoise_Tiling).xx;
			float2 temp_cast_3 = (( ( 1.0 - _PerlinNoise_Tiling ) / 2.0 )).xx;
			float2 uv_TexCoord340 = i.uv_texcoord * temp_cast_2 + temp_cast_3;
			float cos367 = cos( ( _Time.y * 0.05 ) );
			float sin367 = sin( ( _Time.y * 0.05 ) );
			float2 rotator367 = mul( uv_TexCoord340 - float2( 0.5,0.5 ) , float2x2( cos367 , -sin367 , sin367 , cos367 )) + float2( 0.5,0.5 );
			float2 panner355 = ( ( _Time.y * 0.05 ) * _PerlinNoise_PannerSpeed + rotator367);
			float4 MovingPerlinNoise414 = tex2D( _PerlinNoise, panner355 );
			float4 BrumeTextureSample329 = tex2D( _BrumeTexture, UV323 );
			float4 lerpResult314 = lerp( _BrumeColor_ColorLow , _BrumeColor_ColorHigh , ( lerpResult449 * ( MovingPerlinNoise414 * BrumeTextureSample329 ) ));
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
0;0;1920;1019;4303.047;2144.689;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;164;-3463.412,-3401.316;Inherit;False;1824.463;667.8156;UV;18;323;321;322;222;402;221;439;226;225;224;223;437;438;278;256;279;305;228;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-3367.837,-3315.609;Inherit;False;Property;_Flipbook_Tiling;Flipbook_Tiling;7;0;Create;True;0;0;False;0;False;1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;305;-3192.387,-3334.236;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;256;-3341.704,-2922.823;Inherit;False;Property;_Flipbook_Time;Flipbook_Time;10;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;279;-3327.181,-2843.53;Inherit;False;Constant;_Float1;Float 1;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;438;-2973.149,-3262.143;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;437;-2971.149,-3331.143;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;278;-3124.222,-2907.22;Inherit;False;Property;_AnimationPause;AnimationPause;5;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;440;-3463.359,-4223.959;Inherit;False;1853.263;809.3662;Noise;16;414;337;355;367;372;358;340;357;375;373;374;376;369;370;368;341;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-2874.086,-3056.896;Inherit;False;Property;_Flipbook_Rows;Flipbook_Rows;9;0;Create;True;0;0;False;0;False;1;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;226;-2874.086,-2897.895;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-2874.086,-2977.896;Inherit;False;Property;_Flipbook_Speed;Flipbook_Speed;6;0;Create;True;0;0;False;0;False;1;24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;439;-2835.655,-3312.682;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-2874.086,-3137.896;Inherit;False;Property;_Flipbook_Columns;Flipbook_Columns;8;0;Create;True;0;0;False;0;False;1;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-3413.359,-4147.363;Inherit;False;Property;_PerlinNoise_Tiling;PerlinNoise_Tiling;21;0;Create;True;0;0;False;0;False;0.1;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;402;-2593.903,-3270.653;Inherit;False;Property;_Texture_Tiling;Texture_Tiling;25;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;221;-2650.086,-3119.309;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-2359.35,-3126.268;Inherit;False;UvAnimation;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;322;-2377.455,-3289.308;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;441;-3456.108,-4551.423;Inherit;False;1053.329;281;Texture;5;18;128;328;327;329;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;368;-3205.359,-4051.362;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-3189.359,-3971.362;Inherit;False;Constant;_Float5;Float 5;29;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;321;-2143.774,-3215.312;Inherit;False;Property;_Flipbook_Animation;Flipbook_Animation?;3;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;369;-3045.359,-4019.362;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;374;-3029.359,-3859.363;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3406.108,-4500.423;Inherit;True;Property;_BrumeTexture;BrumeTexture;2;0;Create;True;0;0;False;0;False;9338f0dfd38c86b4ca38561628f333f1;9338f0dfd38c86b4ca38561628f333f1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;376;-2997.359,-3747.361;Inherit;False;Constant;_Float7;Float 7;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1853.766,-3215.669;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-3168.108,-4501.423;Inherit;False;BrumeTexture;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;171;-3463.001,-2709.06;Inherit;False;1849.498;433.2894;Normal Light Dir;12;180;179;177;178;176;175;273;276;277;274;275;436;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-2853.359,-3859.363;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;-2677.36,-3523.361;Inherit;False;Constant;_Float6;Float 6;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;357;-2693.36,-3619.361;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-2917.359,-4163.363;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;275;-3413.291,-2580.92;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-3420.192,-2658.862;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-3391.668,-2501.495;Inherit;False;Property;_NormalOffset;NormalOffset;19;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;358;-2661.36,-3763.361;Inherit;False;Property;_PerlinNoise_PannerSpeed;PerlinNoise_PannerSpeed;22;0;Create;True;0;0;False;0;False;0,0;0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;277;-3394.668,-2425.495;Inherit;False;Property;_NormalStrength;NormalStrength;18;0;Create;True;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;-2517.36,-3571.361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;367;-2661.36,-3987.362;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;355;-2373.36,-3843.362;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;273;-3165.461,-2630.25;Inherit;True;NormalCreate;0;;1;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;175;-2662.111,-2479.491;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;337;-2181.359,-3875.363;Inherit;True;Property;_PerlinNoise;PerlinNoise;23;0;Create;True;0;0;False;0;False;-1;f6ff7a2b76d9a074eb1c734d22e9cb35;f6ff7a2b76d9a074eb1c734d22e9cb35;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;176;-2646.111,-2623.491;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;414;-1884.095,-3874.961;Inherit;False;MovingPerlinNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;177;-2390.111,-2623.491;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-3148.764,-4410.318;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LightAttenuation;178;-2374.111,-2351.49;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-2102.11,-2623.491;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;415;-733.194,-1978.938;Inherit;False;414;MovingPerlinNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;409;-652.4246,-1819.576;Inherit;False;Constant;_Float9;Float 9;32;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;327;-2961.24,-4500.806;Inherit;True;Property;_TextureSample2;Texture Sample 2;29;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;410;-651.6985,-1751.082;Inherit;False;Constant;_Float10;Float 10;32;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-650.2191,-1892.892;Inherit;False;Constant;_Float8;Float 8;32;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;447;-3465.219,-2266.245;Inherit;False;1520.166;787.761;Color;12;311;315;314;335;313;312;336;449;450;451;453;454;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-2663.779,-4500.79;Inherit;False;BrumeTextureSample;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;412;-273.2752,-1802.357;Inherit;False;Property;_WaveNoiseContrast;WaveNoiseContrast;26;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-1818.284,-2629.057;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;407;-485.7445,-1958.063;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;-3413.437,-1596.843;Inherit;False;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;411;-1.366493,-1893.895;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;451;-3408.337,-1864.771;Inherit;False;Property;_LightNormal;LightNormal?;27;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-30.71961,-2106.31;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;450;-3293.98,-2025.591;Inherit;False;Constant;_Float2;Float 2;26;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-3358.992,-1944.808;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;453;-3403.688,-1732.025;Inherit;False;414;MovingPerlinNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;454;-3074.726,-1727.001;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;319.2597,-2012.253;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;449;-3115.08,-1962.791;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;235;629.3723,-1761.446;Inherit;False;Property;_DisplacementTexture_Multiply;DisplacementTexture_Multiply;16;0;Create;True;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;326;803.5151,-1667.607;Inherit;False;Property;_DisplacementTexture_Contrast;DisplacementTexture_Contrast;17;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;313;-2843.976,-2018.172;Inherit;False;Property;_BrumeColor_ColorHigh;BrumeColor_ColorHigh;24;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-2764.369,-1728.147;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;908.1443,-1999.23;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;312;-2844.435,-2199.344;Inherit;False;Property;_BrumeColor_ColorLow;BrumeColor_ColorLow;20;0;Create;True;0;0;False;0;False;0.4,0.4470589,0.509804,1;0.6527234,0.6967309,0.7169812,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;314;-2522.122,-2019.452;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;236;1844.032,-1471.052;Inherit;False;Property;_Tesselation_MinDist;Tesselation_MinDist;13;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;239;1703.722,-1763.91;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;435;1206.889,-2915.485;Inherit;False;Constant;_Float13;Float 13;31;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;1840.032,-1397.052;Inherit;False;Property;_Tesselation_MaxDist;Tesselation_MaxDist;14;0;Create;True;0;0;False;0;False;5;35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;325;1140.977,-1998.728;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.92;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;238;1782.81,-1546.083;Inherit;False;Property;_Tesselation_Factor;Tesselation_Factor;12;0;Create;True;0;0;False;0;False;15;20;1;64;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;420;1369.719,-2915.13;Inherit;False;OpacityFinal;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;-2231.582,-2023.663;Inherit;False;BrumeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;240;2075.033,-1531.052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;266;2150.807,-1669.534;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;1923.147,-1844.549;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;436;-2842.517,-2537.208;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;2542.567,-2095.401;Inherit;False;420;OpacityFinal;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;431;281.0967,-2694.361;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;434;34.09668,-2639.361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;264;2318.267,-1644.824;Inherit;False;Property;_Tesselation;Tesselation?;11;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StaticSwitch;267;2086.812,-1874.088;Inherit;False;Property;_Displacement;Displacement?;15;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;432;-125.9033,-2759.361;Inherit;False;Constant;_Float11;Float 11;31;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;2545.982,-1999.062;Inherit;False;315;BrumeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;433;-134.9033,-2619.361;Inherit;False;Constant;_Float12;Float 12;31;0;Create;True;0;0;False;0;False;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;430;629.0593,-2288.335;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2879.755,-2197.697;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;BrumeVolume;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;4;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;305;0;228;0
WireConnection;438;0;305;2
WireConnection;437;0;305;1
WireConnection;278;1;256;0
WireConnection;278;0;279;0
WireConnection;226;0;278;0
WireConnection;439;0;437;0
WireConnection;439;1;438;0
WireConnection;221;0;439;0
WireConnection;221;1;223;0
WireConnection;221;2;224;0
WireConnection;221;3;225;0
WireConnection;221;5;226;0
WireConnection;222;0;221;0
WireConnection;322;0;402;0
WireConnection;368;0;341;0
WireConnection;321;1;322;0
WireConnection;321;0;222;0
WireConnection;369;0;368;0
WireConnection;369;1;370;0
WireConnection;323;0;321;0
WireConnection;128;0;18;0
WireConnection;375;0;374;0
WireConnection;375;1;376;0
WireConnection;340;0;341;0
WireConnection;340;1;369;0
WireConnection;372;0;357;0
WireConnection;372;1;373;0
WireConnection;367;0;340;0
WireConnection;367;2;375;0
WireConnection;355;0;367;0
WireConnection;355;2;358;0
WireConnection;355;1;372;0
WireConnection;273;1;274;0
WireConnection;273;2;275;0
WireConnection;273;3;276;0
WireConnection;273;4;277;0
WireConnection;337;1;355;0
WireConnection;176;0;273;0
WireConnection;414;0;337;0
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;327;0;128;0
WireConnection;327;1;328;0
WireConnection;329;0;327;0
WireConnection;180;0;179;0
WireConnection;407;0;415;0
WireConnection;407;1;408;0
WireConnection;407;2;410;0
WireConnection;407;3;409;0
WireConnection;407;4;410;0
WireConnection;411;1;407;0
WireConnection;411;0;412;0
WireConnection;454;0;453;0
WireConnection;454;1;336;0
WireConnection;406;0;330;0
WireConnection;406;1;411;0
WireConnection;449;0;450;0
WireConnection;449;1;311;0
WireConnection;449;2;451;0
WireConnection;335;0;449;0
WireConnection;335;1;454;0
WireConnection;234;0;406;0
WireConnection;234;1;235;0
WireConnection;314;0;312;0
WireConnection;314;1;313;0
WireConnection;314;2;335;0
WireConnection;325;1;234;0
WireConnection;325;0;326;0
WireConnection;420;0;435;0
WireConnection;315;0;314;0
WireConnection;240;0;238;0
WireConnection;240;1;236;0
WireConnection;240;2;237;0
WireConnection;241;0;325;0
WireConnection;241;1;239;0
WireConnection;431;1;432;0
WireConnection;431;2;434;0
WireConnection;434;0;432;0
WireConnection;434;1;433;0
WireConnection;264;1;266;0
WireConnection;264;0;240;0
WireConnection;267;0;241;0
WireConnection;430;0;431;0
WireConnection;430;1;406;0
WireConnection;0;9;324;0
WireConnection;0;13;292;0
WireConnection;0;11;267;0
WireConnection;0;14;264;0
ASEEND*/
//CHKSM=4F90EAC51DC6F0252C42C4D010F086BE4AA90EEB
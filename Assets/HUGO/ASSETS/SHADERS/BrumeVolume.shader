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
		_Tesselation_Factor("Tesselation_Factor", Range( 1 , 32)) = 15
		_Tesselation_MinDist("Tesselation_MinDist", Float) = 0
		_Tesselation_MaxDist("Tesselation_MaxDist", Float) = 5
		[Toggle(_DISPLACEMENT_ON)] _Displacement("Displacement?", Float) = 0
		_DisplacementTexture_Multiply("DisplacementTexture_Multiply", Float) = 1
		_DisplacementTexture_Contrast("DisplacementTexture_Contrast", Float) = 1
		_NormalStrength("NormalStrength", Float) = 2
		_NormalOffset("NormalOffset", Float) = 0.5
		_GroundMask_Texture("GroundMask_Texture", 2D) = "white" {}
		_GroundMask_Scale("GroundMask_Scale", Float) = 2.49
		_BrumeColor_ColorLow("BrumeColor_ColorLow", Color) = (0.4,0.4470589,0.509804,1)
		_GroundMask_Offset("GroundMask_Offset", Float) = 0
		_BrumeColor_ColorHigh("BrumeColor_ColorHigh", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Back
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
		uniform float _Flipbook_Tiling;
		uniform float _Rotator_Time;
		uniform float _Flipbook_Columns;
		uniform float _Flipbook_Rows;
		uniform float _Flipbook_Speed;
		uniform float _Flipbook_Time;
		uniform sampler2D _GroundMask_Texture;
		uniform float4 _GroundMask_Texture_ST;
		uniform float _GroundMask_Scale;
		uniform float _GroundMask_Offset;
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
			float4 temp_cast_4 = (1.0).xxxx;
			#ifdef _TESSELATION_ON
				float4 staticSwitch264 = UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _Tesselation_MinDist,_Tesselation_MaxDist,_Tesselation_Factor);
			#else
				float4 staticSwitch264 = temp_cast_4;
			#endif
			return staticSwitch264;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (_Flipbook_Tiling).xx;
			float2 uv_TexCoord305 = v.texcoord.xy * temp_cast_0;
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
				float2 staticSwitch321 = v.texcoord.xy;
			#endif
			float2 UV323 = staticSwitch321;
			float4 BrumeTextureSample329 = tex2Dlod( _BrumeTexture, float4( UV323, 0, 0.0) );
			float4 blendOpSrc320 = BrumeTextureSample329;
			float4 blendOpDest320 = float4( 0,0,0,0 );
			float2 uv_GroundMask_Texture = v.texcoord * _GroundMask_Texture_ST.xy + _GroundMask_Texture_ST.zw;
			float4 tex2DNode181 = tex2Dlod( _GroundMask_Texture, float4( uv_GroundMask_Texture, 0, 0.0) );
			float4 blendOpSrc186 = tex2DNode181;
			float4 blendOpDest186 = ( (tex2DNode181*_GroundMask_Scale + _GroundMask_Offset) - BrumeTextureSample329 );
			float4 OpacityMask316 = ( saturate( ( blendOpDest186/ max( 1.0 - blendOpSrc186, 0.00001 ) ) ));
			float4 lerpBlendMode320 = lerp(blendOpDest320,abs( blendOpSrc320 - blendOpDest320 ),OpacityMask316.r);
			float3 ase_vertexNormal = v.normal.xyz;
			#ifdef _DISPLACEMENT_ON
				float4 staticSwitch267 = ( CalculateContrast(_DisplacementTexture_Contrast,( ( saturate( lerpBlendMode320 )) * _DisplacementTexture_Multiply )) * float4( ase_vertexNormal , 0.0 ) );
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
			float2 uv_GroundMask_Texture = i.uv_texcoord * _GroundMask_Texture_ST.xy + _GroundMask_Texture_ST.zw;
			float4 tex2DNode181 = tex2D( _GroundMask_Texture, uv_GroundMask_Texture );
			float2 temp_cast_0 = (_Flipbook_Tiling).xx;
			float2 uv_TexCoord305 = i.uv_texcoord * temp_cast_0;
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
				float2 staticSwitch321 = i.uv_texcoord;
			#endif
			float2 UV323 = staticSwitch321;
			float4 BrumeTextureSample329 = tex2D( _BrumeTexture, UV323 );
			float4 blendOpSrc186 = tex2DNode181;
			float4 blendOpDest186 = ( (tex2DNode181*_GroundMask_Scale + _GroundMask_Offset) - BrumeTextureSample329 );
			float4 OpacityMask316 = ( saturate( ( blendOpDest186/ max( 1.0 - blendOpSrc186, 0.00001 ) ) ));
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
			float4 lerpResult314 = lerp( _BrumeColor_ColorLow , _BrumeColor_ColorHigh , ( normal_LightDir180 * BrumeTextureSample329 ));
			float4 BrumeColor315 = lerpResult314;
			c.rgb = BrumeColor315.rgb;
			c.a = OpacityMask316.r;
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
0;0;1920;1019;52.7205;4036.024;1.300917;True;False
Node;AmplifyShaderEditor.CommentaryNode;164;-2160.76,-2936.124;Inherit;False;1924.607;765.0575;Texture et UV;19;308;310;334;333;279;278;323;321;322;222;221;223;224;225;306;226;305;228;256;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;334;-2105.365,-2554.955;Inherit;False;Constant;_Float2;Float 2;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-2133.968,-2650.135;Inherit;False;Property;_Rotator_Time;Rotator_Time;9;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1999.864,-2347.328;Inherit;False;Property;_Flipbook_Time;Flipbook_Time;12;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-1961.396,-2804.812;Inherit;False;Property;_Flipbook_Tiling;Flipbook_Tiling;8;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;333;-1949.365,-2614.955;Inherit;False;Property;_RotationPause;RotationPause;5;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;279;-1985.341,-2268.034;Inherit;False;Constant;_Float1;Float 1;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;278;-1782.382,-2331.724;Inherit;False;Property;_AnimationPause;AnimationPause;6;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;308;-1693.579,-2661.316;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;305;-1729.946,-2822.439;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;225;-1532.246,-2402.401;Inherit;False;Property;_Flipbook_Speed;Flipbook_Speed;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;226;-1532.246,-2322.4;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-1532.246,-2481.401;Inherit;False;Property;_Flipbook_Rows;Flipbook_Rows;11;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;306;-1508.579,-2750.316;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-1532.246,-2562.401;Inherit;False;Property;_Flipbook_Columns;Flipbook_Columns;10;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;221;-1308.246,-2543.813;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-1017.51,-2550.772;Inherit;False;UvAnimation;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;322;-1035.615,-2713.812;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;321;-801.9333,-2639.817;Inherit;False;Property;_Flipbook_Animation;Flipbook_Animation?;4;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1984.54,-3208.277;Inherit;True;Property;_BrumeTexture;BrumeTexture;3;0;Create;True;0;0;False;0;False;9338f0dfd38c86b4ca38561628f333f1;9338f0dfd38c86b4ca38561628f333f1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-511.9269,-2640.173;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-1727.197,-3118.172;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-1746.541,-3209.277;Inherit;False;BrumeTexture;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;327;-1539.673,-3208.661;Inherit;True;Property;_TextureSample2;Texture Sample 2;29;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;171;-2164.062,-2158.305;Inherit;False;1849.498;433.2894;Normal Light Dir;11;180;179;177;178;176;175;273;276;277;274;275;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;204;843.9984,-2837.514;Inherit;False;Property;_GroundMask_Offset;GroundMask_Offset;26;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-1242.212,-3208.644;Inherit;False;BrumeTextureSample;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-2092.729,-1950.741;Inherit;False;Property;_NormalOffset;NormalOffset;21;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;848.3151,-2913.675;Inherit;False;Property;_GroundMask_Scale;GroundMask_Scale;23;0;Create;True;0;0;False;0;False;2.49;4.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-2121.253,-2108.107;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-2114.352,-2030.166;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;181;797.6881,-3114.697;Inherit;True;Property;_GroundMask_Texture;GroundMask_Texture;22;0;Create;True;0;0;False;0;False;-1;a24af4bf25040b448bb7a647ef0953a7;49bd8c401abf6944f8c5bcb3430bc9c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;277;-2095.729,-1874.741;Inherit;False;Property;_NormalStrength;NormalStrength;20;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;273;-1866.522,-2079.495;Inherit;True;NormalCreate;0;;1;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;200;1117.626,-2948.501;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0.66;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;257;1128.075,-2704.49;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;185;1440.43,-2876.759;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;175;-1363.172,-1928.737;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;176;-1347.172,-2072.736;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BlendOpsNode;186;1712.586,-3116.492;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;178;-1075.172,-1800.736;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;177;-1091.172,-2072.736;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-803.1705,-2072.736;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;316;2819.08,-3313.711;Inherit;False;OpacityMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;317;802.0583,-1931.698;Inherit;True;316;OpacityMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;773.0842,-2134.18;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-519.3444,-2078.302;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;320;1177.307,-2020.541;Inherit;True;Difference;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;-1904.533,-1062.352;Inherit;False;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1867.306,-1182.356;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;235;1171.044,-1778.373;Inherit;False;Property;_DisplacementTexture_Multiply;DisplacementTexture_Multiply;18;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;312;-1717.251,-1599.792;Inherit;False;Property;_BrumeColor_ColorLow;BrumeColor_ColorLow;24;0;Create;True;0;0;False;0;False;0.4,0.4470589,0.509804,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;313;-1716.792,-1418.621;Inherit;False;Property;_BrumeColor_ColorHigh;BrumeColor_ColorHigh;29;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;1449.815,-2016.157;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-1637.185,-1128.596;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;326;1345.186,-1684.534;Inherit;False;Property;_DisplacementTexture_Contrast;DisplacementTexture_Contrast;19;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;238;1782.81,-1546.083;Inherit;False;Property;_Tesselation_Factor;Tesselation_Factor;14;0;Create;True;0;0;False;0;False;15;0;1;32;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;1840.032,-1397.052;Inherit;False;Property;_Tesselation_MaxDist;Tesselation_MaxDist;16;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;314;-1394.938,-1419.9;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;325;1682.647,-2015.655;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.92;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;239;1703.722,-1763.91;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;236;1844.032,-1471.052;Inherit;False;Property;_Tesselation_MinDist;Tesselation_MinDist;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;1923.147,-1844.549;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;240;2075.033,-1531.052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;-1104.398,-1424.111;Inherit;False;BrumeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;266;2150.807,-1669.534;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;355;382.9174,-3726.517;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;362;1561.902,-3625.744;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;360;1215.899,-3864.56;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;352;2451.483,-3690.937;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;358;114.9174,-3758.517;Inherit;False;Property;_PerlinNoise_PannerSpeed;PerlinNoise_PannerSpeed;27;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;357;161.9174,-3618.517;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;385.032,-3815.252;Inherit;False;Property;_PerlinNoise_Tiling;PerlinNoise_Tiling;25;0;Create;True;0;0;False;0;False;0.2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;364;1401.705,-3483.134;Inherit;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;337;813.1619,-3863.105;Inherit;True;Property;_PerlinNoise;PerlinNoise;28;0;Create;True;0;0;False;0;False;-1;f6ff7a2b76d9a074eb1c734d22e9cb35;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;359;1906.054,-3590.854;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;351;2184.531,-3648.465;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;267;2086.812,-1874.088;Inherit;False;Property;_Displacement;Displacement?;17;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;2589.982,-2007.062;Inherit;False;315;BrumeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;2679.567,-2090.401;Inherit;False;316;OpacityMask;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;264;2318.267,-1644.824;Inherit;False;Property;_Tesselation;Tesselation?;13;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;594.0321,-3834.252;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;363;1405.608,-3555.986;Inherit;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2879.755,-2197.697;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;BrumeVolume;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;333;1;310;0
WireConnection;333;0;334;0
WireConnection;278;1;256;0
WireConnection;278;0;279;0
WireConnection;308;0;333;0
WireConnection;305;0;228;0
WireConnection;226;0;278;0
WireConnection;306;0;305;0
WireConnection;306;2;308;0
WireConnection;221;0;306;0
WireConnection;221;1;223;0
WireConnection;221;2;224;0
WireConnection;221;3;225;0
WireConnection;221;5;226;0
WireConnection;222;0;221;0
WireConnection;321;1;322;0
WireConnection;321;0;222;0
WireConnection;323;0;321;0
WireConnection;128;0;18;0
WireConnection;327;0;128;0
WireConnection;327;1;328;0
WireConnection;329;0;327;0
WireConnection;273;1;274;0
WireConnection;273;2;275;0
WireConnection;273;3;276;0
WireConnection;273;4;277;0
WireConnection;200;0;181;0
WireConnection;200;1;182;0
WireConnection;200;2;204;0
WireConnection;185;0;200;0
WireConnection;185;1;257;0
WireConnection;176;0;273;0
WireConnection;186;0;181;0
WireConnection;186;1;185;0
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;316;0;186;0
WireConnection;180;0;179;0
WireConnection;320;0;330;0
WireConnection;320;2;317;0
WireConnection;234;0;320;0
WireConnection;234;1;235;0
WireConnection;335;0;311;0
WireConnection;335;1;336;0
WireConnection;314;0;312;0
WireConnection;314;1;313;0
WireConnection;314;2;335;0
WireConnection;325;1;234;0
WireConnection;325;0;326;0
WireConnection;241;0;325;0
WireConnection;241;1;239;0
WireConnection;240;0;238;0
WireConnection;240;1;236;0
WireConnection;240;2;237;0
WireConnection;315;0;314;0
WireConnection;355;2;358;0
WireConnection;355;1;357;0
WireConnection;362;0;360;0
WireConnection;360;0;337;0
WireConnection;360;1;181;0
WireConnection;352;1;351;0
WireConnection;337;1;340;0
WireConnection;351;1;359;0
WireConnection;267;0;241;0
WireConnection;264;1;266;0
WireConnection;264;0;240;0
WireConnection;340;0;341;0
WireConnection;340;1;355;0
WireConnection;0;9;324;0
WireConnection;0;13;292;0
WireConnection;0;11;267;0
WireConnection;0;14;264;0
ASEEND*/
//CHKSM=7EBCC85EAE182A06079BA412DF9EC33304F682F0
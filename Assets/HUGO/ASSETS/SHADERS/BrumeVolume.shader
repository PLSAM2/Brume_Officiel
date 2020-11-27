// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrumeVolume"
{
	Properties
	{
		_BrumeFlipbookTexture("BrumeFlipbookTexture", 2D) = "white" {}
		[Toggle(_COLOR_ON)] _Color("Color?", Float) = 0
		_Flipbook_Speed("Flipbook_Speed", Float) = 1
		_Flipbook_Tiling("Flipbook_Tiling", Float) = 1
		_Rotator_Time("Rotator_Time", Float) = 1
		_Flipbook_Columns("Flipbook_Columns", Float) = 1
		_Flipbook_Rows("Flipbook_Rows", Float) = 1
		_Flipbook_Time("Flipbook_Time", Float) = 1
		_Parralax_Scale("Parralax_Scale", Float) = 0.15
		_Parralax_DistancePlane("Parralax_DistancePlane", Float) = 0
		[Toggle(_TESSELATION_ON)] _Tesselation("Tesselation?", Float) = 0
		_Tesselation_Factor("Tesselation_Factor", Range( 1 , 32)) = 15
		_Tesselation_MinDist("Tesselation_MinDist", Float) = 0
		_Tesselation_MaxDist("Tesselation_MaxDist", Float) = 5
		[Toggle(_DISPLACEMENT_ON)] _Displacement("Displacement?", Float) = 0
		_DisplacementTexture_Multiply("DisplacementTexture_Multiply", Float) = 1
		[Toggle(_BRUMEANIMATED_ON)] _BrumeAnimated("BrumeAnimated?", Float) = 1
		_NormalStrength("NormalStrength", Float) = 2
		_NormalOffset("NormalOffset", Float) = 0.5
		_GroundMask_Texture("GroundMask_Texture", 2D) = "white" {}
		_GroundMask_Scale("GroundMask_Scale", Float) = 2.49
		_Color0("Color 0", Color) = (0.4,0.4470589,0.509804,1)
		_BrumeColor_ColorLow("BrumeColor_ColorLow", Color) = (0.4,0.4470589,0.509804,1)
		_GroundMask_Offset("GroundMask_Offset", Float) = 0
		_Color1("Color 1", Color) = (1,1,1,0)
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
		#pragma shader_feature_local _BRUMEANIMATED_ON
		#pragma shader_feature_local _COLOR_ON
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
			float3 viewDir;
			INTERNAL_DATA
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

		uniform sampler2D _BrumeFlipbookTexture;
		uniform float _Flipbook_Tiling;
		uniform float _Rotator_Time;
		uniform float _Flipbook_Columns;
		uniform float _Flipbook_Rows;
		uniform float _Flipbook_Speed;
		uniform float _Flipbook_Time;
		uniform float _DisplacementTexture_Multiply;
		uniform sampler2D _GroundMask_Texture;
		uniform float4 _GroundMask_Texture_ST;
		uniform float _GroundMask_Scale;
		uniform float _GroundMask_Offset;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Parralax_Scale;
		uniform float _Parralax_DistancePlane;
		uniform float4 _BrumeFlipbookTexture_ST;
		uniform float4 _BrumeColor_ColorLow;
		uniform float4 _BrumeColor_ColorHigh;
		uniform float _NormalOffset;
		uniform float _NormalStrength;
		uniform float _Tesselation_MinDist;
		uniform float _Tesselation_MaxDist;
		uniform float _Tesselation_Factor;


		inline float2 POM( sampler2D heightMap, float2 uvs, float2 dx, float2 dy, float3 normalWorld, float3 viewWorld, float3 viewDirTan, int minSamples, int maxSamples, float parallax, float refPlane, float2 tilling, float2 curv, int index )
		{
			float3 result = 0;
			int stepIndex = 0;
			int numSteps = ( int )lerp( (float)maxSamples, (float)minSamples, saturate( dot( normalWorld, viewWorld ) ) );
			float layerHeight = 1.0 / numSteps;
			float2 plane = parallax * ( viewDirTan.xy / viewDirTan.z );
			uvs.xy += refPlane * plane;
			float2 deltaTex = -plane * layerHeight;
			float2 prevTexOffset = 0;
			float prevRayZ = 1.0f;
			float prevHeight = 0.0f;
			float2 currTexOffset = deltaTex;
			float currRayZ = 1.0f - layerHeight;
			float currHeight = 0.0f;
			float intersection = 0;
			float2 finalTexOffset = 0;
			while ( stepIndex < numSteps + 1 )
			{
			 	currHeight = tex2Dgrad( heightMap, uvs + currTexOffset, dx, dy ).r;
			 	if ( currHeight > currRayZ )
			 	{
			 	 	stepIndex = numSteps + 1;
			 	}
			 	else
			 	{
			 	 	stepIndex++;
			 	 	prevTexOffset = currTexOffset;
			 	 	prevRayZ = currRayZ;
			 	 	prevHeight = currHeight;
			 	 	currTexOffset += deltaTex;
			 	 	currRayZ -= layerHeight;
			 	}
			}
			int sectionSteps = 10;
			int sectionIndex = 0;
			float newZ = 0;
			float newHeight = 0;
			while ( sectionIndex < sectionSteps )
			{
			 	intersection = ( prevHeight - prevRayZ ) / ( prevHeight - currHeight + currRayZ - prevRayZ );
			 	finalTexOffset = prevTexOffset + intersection * deltaTex;
			 	newZ = prevRayZ - intersection * layerHeight;
			 	newHeight = tex2Dgrad( heightMap, uvs + finalTexOffset, dx, dy ).r;
			 	if ( newHeight > newZ )
			 	{
			 	 	currTexOffset = finalTexOffset;
			 	 	currHeight = newHeight;
			 	 	currRayZ = newZ;
			 	 	deltaTex = intersection * deltaTex;
			 	 	layerHeight = intersection * layerHeight;
			 	}
			 	else
			 	{
			 	 	prevTexOffset = finalTexOffset;
			 	 	prevHeight = newHeight;
			 	 	prevRayZ = newZ;
			 	 	deltaTex = ( 1 - intersection ) * deltaTex;
			 	 	layerHeight = ( 1 - intersection ) * layerHeight;
			 	}
			 	sectionIndex++;
			}
			return uvs.xy + finalTexOffset;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_3 = (1.0).xxxx;
			#ifdef _TESSELATION_ON
				float4 staticSwitch264 = UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, _Tesselation_MinDist,_Tesselation_MaxDist,_Tesselation_Factor);
			#else
				float4 staticSwitch264 = temp_cast_3;
			#endif
			return staticSwitch264;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 temp_cast_0 = (_Flipbook_Tiling).xx;
			float2 uv_TexCoord305 = v.texcoord.xy * temp_cast_0;
			float mulTime308 = _Time.y * _Rotator_Time;
			float cos306 = cos( mulTime308 );
			float sin306 = sin( mulTime308 );
			float2 rotator306 = mul( uv_TexCoord305 - float2( 0.5,0.5 ) , float2x2( cos306 , -sin306 , sin306 , cos306 )) + float2( 0.5,0.5 );
			#ifdef _BRUMEANIMATED_ON
				float staticSwitch278 = _Flipbook_Time;
			#else
				float staticSwitch278 = 0.0;
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
			float3 ase_vertexNormal = v.normal.xyz;
			#ifdef _DISPLACEMENT_ON
				float4 staticSwitch267 = ( ( tex2Dlod( _BrumeFlipbookTexture, float4( UvAnimation222, 0, 0.0) ) * _DisplacementTexture_Multiply ) * float4( ase_vertexNormal , 0.0 ) );
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
			float mulTime308 = _Time.y * _Rotator_Time;
			float cos306 = cos( mulTime308 );
			float sin306 = sin( mulTime308 );
			float2 rotator306 = mul( uv_TexCoord305 - float2( 0.5,0.5 ) , float2x2( cos306 , -sin306 , sin306 , cos306 )) + float2( 0.5,0.5 );
			#ifdef _BRUMEANIMATED_ON
				float staticSwitch278 = _Flipbook_Time;
			#else
				float staticSwitch278 = 0.0;
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
			float4 blendOpSrc186 = tex2DNode181;
			float4 blendOpDest186 = ( (tex2DNode181*_GroundMask_Scale + _GroundMask_Offset) - tex2D( _BrumeFlipbookTexture, UvAnimation222 ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float2 OffsetPOM20 = POM( _BrumeFlipbookTexture, UvAnimation222, ddx(UvAnimation222), ddy(UvAnimation222), ase_worldNormal, ase_worldViewDir, i.viewDir, 128, 128, _Parralax_Scale, _Parralax_DistancePlane, _BrumeFlipbookTexture_ST.xy, float2(0,0), 0 );
			float4 BrumeParralax139 = tex2D( _BrumeFlipbookTexture, OffsetPOM20, ddx( UvAnimation222 ), ddy( UvAnimation222 ) );
			float4 lerpResult299 = lerp( _Color0 , _Color1 , BrumeParralax139);
			float4 BrumeFinal262 = lerpResult299;
			float2 temp_output_2_0_g1 = UvAnimation222;
			float2 break6_g1 = temp_output_2_0_g1;
			float temp_output_25_0_g1 = ( pow( _NormalOffset , 3.0 ) * 0.1 );
			float2 appendResult8_g1 = (float2(( break6_g1.x + temp_output_25_0_g1 ) , break6_g1.y));
			float4 tex2DNode14_g1 = tex2D( _BrumeFlipbookTexture, temp_output_2_0_g1 );
			float temp_output_4_0_g1 = _NormalStrength;
			float3 appendResult13_g1 = (float3(1.0 , 0.0 , ( ( tex2D( _BrumeFlipbookTexture, appendResult8_g1 ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float2 appendResult9_g1 = (float2(break6_g1.x , ( break6_g1.y + temp_output_25_0_g1 )));
			float3 appendResult16_g1 = (float3(0.0 , 1.0 , ( ( tex2D( _BrumeFlipbookTexture, appendResult9_g1 ).g - tex2DNode14_g1.g ) * temp_output_4_0_g1 )));
			float3 normalizeResult22_g1 = normalize( cross( appendResult13_g1 , appendResult16_g1 ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult177 = dot( (WorldNormalVector( i , normalizeResult22_g1 )) , ase_worldlightDir );
			float normal_LightDir180 = ( dotResult177 * ase_lightAtten );
			float4 lerpResult314 = lerp( _BrumeColor_ColorLow , _BrumeColor_ColorHigh , normal_LightDir180);
			float4 BrumeColor315 = lerpResult314;
			#ifdef _COLOR_ON
				float4 staticSwitch268 = BrumeColor315;
			#else
				float4 staticSwitch268 = BrumeFinal262;
			#endif
			c.rgb = staticSwitch268.rgb;
			c.a = ( saturate( ( blendOpDest186/ max( 1.0 - blendOpSrc186, 0.00001 ) ) )).r;
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
				surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
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
0;0;1920;1019;4637.875;3076.255;5.22365;True;False
Node;AmplifyShaderEditor.CommentaryNode;164;-2081.471,-3194.944;Inherit;False;2118.471;899.0958;Texture et UV;16;228;306;305;308;128;18;221;224;225;226;223;278;279;256;310;222;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-1146.862,-3067.514;Inherit;False;Property;_Flipbook_Tiling;Flipbook_Tiling;6;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;279;-1157.807,-2633.736;Inherit;False;Constant;_Float1;Float 1;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1195.33,-2554.03;Inherit;False;Property;_Flipbook_Time;Flipbook_Time;10;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-1150.434,-2917.837;Inherit;False;Property;_Rotator_Time;Rotator_Time;7;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;305;-915.4119,-3085.141;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;308;-904.045,-2922.018;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;278;-967.8479,-2594.426;Inherit;False;Property;_BrumeAnimated;BrumeAnimated?;19;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-717.7119,-2665.103;Inherit;False;Property;_Flipbook_Speed;Flipbook_Speed;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-717.7119,-2744.103;Inherit;False;Property;_Flipbook_Rows;Flipbook_Rows;9;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;226;-717.7119,-2585.102;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-717.7119,-2825.103;Inherit;False;Property;_Flipbook_Columns;Flipbook_Columns;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;306;-694.0452,-3013.018;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-1979.373,-2913.775;Inherit;True;Property;_BrumeFlipbookTexture;BrumeFlipbookTexture;3;0;Create;True;0;0;False;0;False;090dbeeabb49a3947986c747e58bb1fa;9338f0dfd38c86b4ca38561628f333f1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;221;-493.7118,-2809.103;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-1739.374,-2912.775;Inherit;False;BrumeTexture;-1;True;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.CommentaryNode;171;-1503.638,-1634.795;Inherit;False;1849.498;433.2894;Normal Light Dir;11;180;179;177;178;176;175;273;276;277;274;275;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-202.9753,-2813.474;Inherit;False;UvAnimation;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-1460.829,-1584.597;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-1432.305,-1427.231;Inherit;False;Property;_NormalOffset;NormalOffset;21;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-1453.928,-1506.656;Inherit;False;222;UvAnimation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-1435.305,-1351.231;Inherit;False;Property;_NormalStrength;NormalStrength;20;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;165;-1496.107,-1161.968;Inherit;False;1441.512;738.1835;Core Paralax Occlusion Mapping;11;160;139;22;130;20;29;28;24;23;25;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FunctionNode;273;-1206.098,-1555.985;Inherit;True;NormalCreate;0;;1;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;175;-702.748,-1405.227;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;176;-686.748,-1549.226;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;160;-1326.797,-902.4592;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1167.808,-699.2693;Inherit;False;Property;_Parralax_Scale;Parralax_Scale;11;0;Create;True;0;0;False;0;False;0.15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-1059.81,-527.2693;Inherit;False;Property;_Parralax_DistancePlane;Parralax_DistancePlane;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;24;-1237.809,-584.2693;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;79;-1319.85,-1009.576;Inherit;False;222;UvAnimation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdyOpNode;29;-814.8826,-561.9012;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DdxOpNode;28;-816.8826,-634.9012;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LightAttenuation;178;-414.7477,-1277.226;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;130;-832.7814,-957.4191;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DotProductOpNode;177;-430.7477,-1549.226;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxOcclusionMappingNode;20;-888.8093,-849.2681;Inherit;False;0;128;False;26;128;False;27;10;0.02;0;False;1,1;False;0,0;7;0;FLOAT2;0,0;False;1;SAMPLER2D;;False;2;FLOAT;0.02;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT2;0,0;False;6;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-142.7465,-1549.226;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;22;-604.8091,-878.2681;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Derivative;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-279.0466,-878.0181;Inherit;False;BrumeParralax;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;141.0794,-1554.792;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;312;-1378.532,480.8771;Inherit;False;Property;_BrumeColor_ColorLow;BrumeColor_ColorLow;25;0;Create;True;0;0;False;0;False;0.4,0.4470589,0.509804,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;313;-1383.272,301.9471;Inherit;False;Property;_BrumeColor_ColorHigh;BrumeColor_ColorHigh;28;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1633.887,660.4124;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;297;-1396.318,-359.4362;Inherit;False;Property;_Color1;Color 1;27;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;231;947.564,-2002.388;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.ColorNode;296;-1391.578,-180.5062;Inherit;False;Property;_Color0;Color 0;24;0;Create;True;0;0;False;0;False;0.4,0.4470589,0.509804,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;258;-1646.933,-0.970953;Inherit;False;139;BrumeParralax;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;232;952.0523,-1927.718;Inherit;False;222;UvAnimation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;257;855.7947,-2717.559;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;230;1153.541,-1975.505;Inherit;True;Property;_TextureSample0;Texture Sample 0;25;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;314;-1038.019,620.4685;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;255;860.4798,-2640.017;Inherit;False;222;UvAnimation;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;182;848.3151,-2913.675;Inherit;False;Property;_GroundMask_Scale;GroundMask_Scale;23;0;Create;True;0;0;False;0;False;2.49;4.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;299;-1051.065,-40.91486;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;235;1171.044,-1778.373;Inherit;False;Property;_DisplacementTexture_Multiply;DisplacementTexture_Multiply;18;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;181;797.6881,-3114.697;Inherit;True;Property;_GroundMask_Texture;GroundMask_Texture;22;0;Create;True;0;0;False;0;False;-1;a24af4bf25040b448bb7a647ef0953a7;49bd8c401abf6944f8c5bcb3430bc9c3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;204;843.9984,-2837.514;Inherit;False;Property;_GroundMask_Offset;GroundMask_Offset;26;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;239;1480.122,-1760.01;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;236;1844.032,-1471.052;Inherit;False;Property;_Tesselation_MinDist;Tesselation_MinDist;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;1840.032,-1397.052;Inherit;False;Property;_Tesselation_MaxDist;Tesselation_MaxDist;16;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;238;1782.81,-1546.083;Inherit;False;Property;_Tesselation_Factor;Tesselation_Factor;14;0;Create;True;0;0;False;0;False;15;0;1;32;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;262;-306.8248,-46.42566;Inherit;False;BrumeFinal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;1478.815,-1872.157;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;190;1069.087,-2709.409;Inherit;True;Property;_TextureSample5;Texture Sample 5;19;0;Create;True;0;0;False;0;False;-1;9338f0dfd38c86b4ca38561628f333f1;9338f0dfd38c86b4ca38561628f333f1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;-293.7783,614.9577;Inherit;False;BrumeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;200;1139.525,-3111.531;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0.66;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;81;1880.434,-2219.028;Inherit;False;262;BrumeFinal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;1699.547,-1840.649;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;266;2157.807,-1694.534;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceBasedTessNode;240;2075.033,-1531.052;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;185;1440.43,-2876.759;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;1848.982,-2067.062;Inherit;False;315;BrumeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;264;2318.267,-1644.824;Inherit;False;Property;_Tesselation;Tesselation?;13;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT4;0,0,0,0;False;0;FLOAT4;0,0,0,0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;4;FLOAT4;0,0,0,0;False;5;FLOAT4;0,0,0,0;False;6;FLOAT4;0,0,0,0;False;7;FLOAT4;0,0,0,0;False;8;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.BlendOpsNode;186;1796.162,-3071.146;Inherit;True;ColorDodge;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;267;2086.812,-1874.088;Inherit;False;Property;_Displacement;Displacement?;17;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;268;2107.344,-2155.829;Inherit;False;Property;_Color;Color?;4;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2499.829,-2192.698;Float;False;True;-1;6;ASEMaterialInspector;0;0;CustomLighting;BrumeVolume;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;2;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;305;0;228;0
WireConnection;308;0;310;0
WireConnection;278;1;279;0
WireConnection;278;0;256;0
WireConnection;226;0;278;0
WireConnection;306;0;305;0
WireConnection;306;2;308;0
WireConnection;221;0;306;0
WireConnection;221;1;223;0
WireConnection;221;2;224;0
WireConnection;221;3;225;0
WireConnection;221;5;226;0
WireConnection;128;0;18;0
WireConnection;222;0;221;0
WireConnection;273;1;274;0
WireConnection;273;2;275;0
WireConnection;273;3;276;0
WireConnection;273;4;277;0
WireConnection;176;0;273;0
WireConnection;29;0;79;0
WireConnection;28;0;79;0
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;20;0;79;0
WireConnection;20;1;160;0
WireConnection;20;2;23;0
WireConnection;20;3;24;0
WireConnection;20;4;25;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;22;0;130;0
WireConnection;22;1;20;0
WireConnection;22;3;28;0
WireConnection;22;4;29;0
WireConnection;139;0;22;0
WireConnection;180;0;179;0
WireConnection;230;0;231;0
WireConnection;230;1;232;0
WireConnection;314;0;312;0
WireConnection;314;1;313;0
WireConnection;314;2;311;0
WireConnection;299;0;296;0
WireConnection;299;1;297;0
WireConnection;299;2;258;0
WireConnection;262;0;299;0
WireConnection;234;0;230;0
WireConnection;234;1;235;0
WireConnection;190;0;257;0
WireConnection;190;1;255;0
WireConnection;315;0;314;0
WireConnection;200;0;181;0
WireConnection;200;1;182;0
WireConnection;200;2;204;0
WireConnection;241;0;234;0
WireConnection;241;1;239;0
WireConnection;240;0;238;0
WireConnection;240;1;236;0
WireConnection;240;2;237;0
WireConnection;185;0;200;0
WireConnection;185;1;190;0
WireConnection;264;1;266;0
WireConnection;264;0;240;0
WireConnection;186;0;181;0
WireConnection;186;1;185;0
WireConnection;267;0;241;0
WireConnection;268;1;81;0
WireConnection;268;0;292;0
WireConnection;0;9;186;0
WireConnection;0;13;268;0
WireConnection;0;11;267;0
WireConnection;0;14;264;0
ASEEND*/
//CHKSM=1D75E118DAF0DBD486CB8FE70FC428C481B6382E
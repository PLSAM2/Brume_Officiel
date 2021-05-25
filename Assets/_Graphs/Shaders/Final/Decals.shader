// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Decals"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Header(OutInBrume)]_Out_or_InBrume("Out_or_InBrume?", Range( 0 , 1)) = 0
		_DecalTexture("DecalTexture", 2D) = "white" {}
		_DecalNormal("DecalNormal", 2D) = "white" {}
		_TextureGrunge("TextureGrunge", 2D) = "white" {}
		[Header(Shadow and Noise)]_ShadowNoise("ShadowNoise", 2D) = "white" {}
		_ScreenBasedShadowNoise("ScreenBasedShadowNoise?", Range( 0 , 1)) = 0
		_ShadowNoisePanner("ShadowNoisePanner", Vector) = (0.01,0,0,0)
		_StepShadow("StepShadow", Float) = 0.1
		_StepAttenuation("StepAttenuation", Float) = -0.07
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		_EdgeShadowColor("EdgeShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		_Noise_Tiling("Noise_Tiling", Float) = 1
		_Decal_ColorCorrection("Decal_ColorCorrection", Color) = (1,1,1,0)
		[Header(T1 Animated Grunge)]_Decal_AnimatedGrunge("Decal_AnimatedGrunge?", Range( 0 , 1)) = 0
		_Decal_IsGrungeAnimated("Decal_IsGrungeAnimated?", Range( 0 , 1)) = 0
		_Decal_AnimatedGrunge_ScreenBased("Decal_AnimatedGrunge_ScreenBased?", Range( 0 , 1)) = 0
		_Decal_AnimatedGrunge_Tiling("Decal_AnimatedGrunge_Tiling", Float) = 1
		_Decal_AnimatedGrunge_Flipbook_Columns("Decal_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_Decal_AnimatedGrunge_Flipbook_Rows("Decal_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_Decal_AnimatedGrunge_Flipbook_Speed("Decal_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_Decal_AnimatedGrunge_Contrast("Decal_AnimatedGrunge_Contrast", Float) = 1.58
		[ASEEnd]_Decal_AnimatedGrunge_Multiply("Decal_AnimatedGrunge_Multiply", Float) = 1.58
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
		
		Cull Back
		AlphaToMask Off
		HLSLINCLUDE
		#pragma target 2.0

		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _DecalTexture_ST;
			float4 _DecalNormal_ST;
			float4 _Decal_ColorCorrection;
			float4 _EdgeShadowColor;
			float4 _ShadowColor;
			float2 _ShadowNoisePanner;
			float _Decal_AnimatedGrunge_Flipbook_Speed;
			float _Decal_IsGrungeAnimated;
			float _Decal_AnimatedGrunge_Multiply;
			float _Decal_AnimatedGrunge;
			float _Decal_AnimatedGrunge_Flipbook_Columns;
			float _Decal_AnimatedGrunge_ScreenBased;
			float _Out_or_InBrume;
			float _StepShadow;
			float _StepAttenuation;
			float _Decal_AnimatedGrunge_Tiling;
			float _Noise_Tiling;
			float _ScreenBasedShadowNoise;
			float _Decal_AnimatedGrunge_Flipbook_Rows;
			float _Decal_AnimatedGrunge_Contrast;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _TextureGrunge;
			sampler2D _DecalTexture;
			sampler2D _DecalNormal;
			sampler2D _ShadowNoise;


			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord5.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord6.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord7.xyz = ase_worldBitangent;
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				o.ase_texcoord5.w = 0;
				o.ase_texcoord6.w = 0;
				o.ase_texcoord7.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor( positionCS.z );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_tangent = v.ase_tangent;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif
				float4 temp_cast_0 = (1.0).xxxx;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_cast_1 = (_Decal_AnimatedGrunge_Tiling).xx;
				float2 texCoord53 = IN.ase_texcoord4.xy * temp_cast_1 + float2( 0,0 );
				float2 lerpResult54 = lerp( ( (ase_screenPosNorm).xy * _Decal_AnimatedGrunge_Tiling ) , texCoord53 , _Decal_AnimatedGrunge_ScreenBased);
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles51 = _Decal_AnimatedGrunge_Flipbook_Columns * _Decal_AnimatedGrunge_Flipbook_Rows;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset51 = 1.0f / _Decal_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset51 = 1.0f / _Decal_AnimatedGrunge_Flipbook_Rows;
				// Speed of animation
				float fbspeed51 = _TimeParameters.x * _Decal_AnimatedGrunge_Flipbook_Speed;
				// UV Tiling (col and row offset)
				float2 fbtiling51 = float2(fbcolsoffset51, fbrowsoffset51);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex51 = round( fmod( fbspeed51 + 0.0, fbtotaltiles51) );
				fbcurrenttileindex51 += ( fbcurrenttileindex51 < 0) ? fbtotaltiles51 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox51 = round ( fmod ( fbcurrenttileindex51, _Decal_AnimatedGrunge_Flipbook_Columns ) );
				// Multiply Offset X by coloffset
				float fboffsetx51 = fblinearindextox51 * fbcolsoffset51;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy51 = round( fmod( ( fbcurrenttileindex51 - fblinearindextox51 ) / _Decal_AnimatedGrunge_Flipbook_Columns, _Decal_AnimatedGrunge_Flipbook_Rows ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy51 = (int)(_Decal_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy51;
				// Multiply Offset Y by rowoffset
				float fboffsety51 = fblinearindextoy51 * fbrowsoffset51;
				// UV Offset
				float2 fboffset51 = float2(fboffsetx51, fboffsety51);
				// Flipbook UV
				half2 fbuv51 = lerpResult54 * fbtiling51 + fboffset51;
				// *** END Flipbook UV Animation vars ***
				float2 lerpResult58 = lerp( lerpResult54 , fbuv51 , _Decal_IsGrungeAnimated);
				float3 temp_cast_2 = (tex2D( _TextureGrunge, lerpResult58 ).r).xxx;
				float grayscale52 = Luminance(temp_cast_2);
				float4 temp_cast_3 = (grayscale52).xxxx;
				float4 lerpResult64 = lerp( temp_cast_0 , ( CalculateContrast(_Decal_AnimatedGrunge_Contrast,temp_cast_3) * _Decal_AnimatedGrunge_Multiply ) , _Decal_AnimatedGrunge);
				float2 uv_DecalTexture = IN.ase_texcoord4.xy * _DecalTexture_ST.xy + _DecalTexture_ST.zw;
				float4 tex2DNode152 = tex2D( _DecalTexture, uv_DecalTexture );
				float4 Albedo_Texture20 = tex2DNode152;
				float4 blendOpSrc23 = lerpResult64;
				float4 blendOpDest23 = ( Albedo_Texture20 * _Decal_ColorCorrection );
				float4 RGB35 = ( saturate( ( blendOpSrc23 * blendOpDest23 ) ));
				float4 End_OutBrume32 = RGB35;
				float grayscale50 = Luminance(End_OutBrume32.rgb);
				float End_InBrume67 = grayscale50;
				float4 temp_cast_5 = (End_InBrume67).xxxx;
				float Out_or_InBrume156 = _Out_or_InBrume;
				float4 lerpResult77 = lerp( End_OutBrume32 , temp_cast_5 , Out_or_InBrume156);
				float4 Final46 = lerpResult77;
				float temp_output_105_0 = ( _StepShadow + _StepAttenuation );
				float2 uv_DecalNormal = IN.ase_texcoord4.xy * _DecalNormal_ST.xy + _DecalNormal_ST.zw;
				float4 Normal_Texture154 = tex2D( _DecalNormal, uv_DecalNormal );
				float3 ase_worldTangent = IN.ase_texcoord5.xyz;
				float3 ase_worldNormal = IN.ase_texcoord6.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal94 = Normal_Texture154.rgb;
				float3 worldNormal94 = float3(dot(tanToWorld0,tanNormal94), dot(tanToWorld1,tanNormal94), dot(tanToWorld2,tanNormal94));
				float dotResult95 = dot( worldNormal94 , SafeNormalize(_MainLightPosition.xyz) );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir109 = ( dotResult95 * ase_lightAtten );
				float smoothstepResult99 = smoothstep( _StepShadow , temp_output_105_0 , normal_LightDir109);
				float2 temp_cast_7 = (_Noise_Tiling).xx;
				float2 texCoord130 = IN.ase_texcoord4.xy * temp_cast_7 + float2( 0,0 );
				float2 lerpResult131 = lerp( texCoord130 , ( (ase_screenPosNorm).xy * _Noise_Tiling ) , _ScreenBasedShadowNoise);
				float2 panner124 = ( 1.0 * _Time.y * ( _ShadowNoisePanner + float2( 0.1,0.05 ) ) + lerpResult131);
				float2 panner125 = ( 1.0 * _Time.y * _ShadowNoisePanner + lerpResult131);
				float blendOpSrc126 = tex2D( _ShadowNoise, ( panner124 + float2( 0.5,0.5 ) ) ).r;
				float blendOpDest126 = tex2D( _ShadowNoise, panner125 ).r;
				float MapNoise132 = ( saturate( 2.0f*blendOpDest126*blendOpSrc126 + blendOpDest126*blendOpDest126*(1.0f - 2.0f*blendOpSrc126) ));
				float smoothstepResult92 = smoothstep( 0.0 , 0.6 , ( smoothstepResult99 - MapNoise132 ));
				float smoothstepResult97 = smoothstep( ( _StepShadow + -0.02 ) , ( temp_output_105_0 + -0.02 ) , normal_LightDir109);
				float blendOpSrc104 = smoothstepResult92;
				float blendOpDest104 = smoothstepResult97;
				float temp_output_104_0 = ( saturate( 2.0f*blendOpDest104*blendOpSrc104 + blendOpDest104*blendOpDest104*(1.0f - 2.0f*blendOpSrc104) ));
				float4 temp_cast_8 = (step( temp_output_104_0 , -0.23 )).xxxx;
				float4 blendOpSrc93 = ( ( 1.0 - temp_output_104_0 ) * _EdgeShadowColor );
				float4 blendOpDest93 = ( temp_output_104_0 * _ShadowColor );
				float4 blendOpSrc100 = temp_cast_8;
				float4 blendOpDest100 = ( saturate( max( blendOpSrc93, blendOpDest93 ) ));
				float4 lerpBlendMode100 = lerp(blendOpDest100,max( blendOpSrc100, blendOpDest100 ),temp_output_104_0);
				float4 lerpResult111 = lerp( float4( 1,1,1,1 ) , ( saturate( lerpBlendMode100 )) , ( 1.0 - step( temp_output_104_0 , 0.0 ) ));
				float4 Shadows107 = lerpResult111;
				float4 temp_cast_9 = (1.0).xxxx;
				float4 lerpResult136 = lerp( Shadows107 , temp_cast_9 , Out_or_InBrume156);
				
				float Albedo_Alpha158 = tex2DNode152.a;
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = ( Final46 * lerpResult136 ).rgb;
				float Alpha = Albedo_Alpha158;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif

				return half4( Color, Alpha );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _DecalTexture_ST;
			float4 _DecalNormal_ST;
			float4 _Decal_ColorCorrection;
			float4 _EdgeShadowColor;
			float4 _ShadowColor;
			float2 _ShadowNoisePanner;
			float _Decal_AnimatedGrunge_Flipbook_Speed;
			float _Decal_IsGrungeAnimated;
			float _Decal_AnimatedGrunge_Multiply;
			float _Decal_AnimatedGrunge;
			float _Decal_AnimatedGrunge_Flipbook_Columns;
			float _Decal_AnimatedGrunge_ScreenBased;
			float _Out_or_InBrume;
			float _StepShadow;
			float _StepAttenuation;
			float _Decal_AnimatedGrunge_Tiling;
			float _Noise_Tiling;
			float _ScreenBasedShadowNoise;
			float _Decal_AnimatedGrunge_Flipbook_Rows;
			float _Decal_AnimatedGrunge_Contrast;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _DecalTexture;


			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir( v.ase_normal );

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				o.clipPos = clipPos;

				return o;
			}
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_DecalTexture = IN.ase_texcoord2.xy * _DecalTexture_ST.xy + _DecalTexture_ST.zw;
				float4 tex2DNode152 = tex2D( _DecalTexture, uv_DecalTexture );
				float Albedo_Alpha158 = tex2DNode152.a;
				
				float Alpha = Albedo_Alpha158;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define ASE_SRP_VERSION 999999

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _DecalTexture_ST;
			float4 _DecalNormal_ST;
			float4 _Decal_ColorCorrection;
			float4 _EdgeShadowColor;
			float4 _ShadowColor;
			float2 _ShadowNoisePanner;
			float _Decal_AnimatedGrunge_Flipbook_Speed;
			float _Decal_IsGrungeAnimated;
			float _Decal_AnimatedGrunge_Multiply;
			float _Decal_AnimatedGrunge;
			float _Decal_AnimatedGrunge_Flipbook_Columns;
			float _Decal_AnimatedGrunge_ScreenBased;
			float _Out_or_InBrume;
			float _StepShadow;
			float _StepAttenuation;
			float _Decal_AnimatedGrunge_Tiling;
			float _Noise_Tiling;
			float _ScreenBasedShadowNoise;
			float _Decal_AnimatedGrunge_Flipbook_Rows;
			float _Decal_AnimatedGrunge_Contrast;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _DecalTexture;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = TransformWorldToHClip( positionWS );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 uv_DecalTexture = IN.ase_texcoord2.xy * _DecalTexture_ST.xy + _DecalTexture_ST.zw;
				float4 tex2DNode152 = tex2D( _DecalTexture, uv_DecalTexture );
				float Albedo_Alpha158 = tex2DNode152.a;
				
				float Alpha = Albedo_Alpha158;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

	
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18707
1920;0;1920;1019;6435.931;1838.395;4.889866;True;False
Node;AmplifyShaderEditor.CommentaryNode;7;-5177.861,-741.9702;Inherit;False;5694.134;1925.637;TEXTURE 1;10;4;3;2;0;16;14;9;8;156;157;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;8;-4941.829,-629.413;Inherit;False;826.1577;1067.514;Texture Arrays 1;2;12;11;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;12;-4891.518,-579.4129;Inherit;False;714.0715;693.3051;Textures;5;158;154;153;152;20;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;78;-5176.714,1254.513;Inherit;False;5639.813;1022.403;Shadow Smooth Edge + Int Shadow;27;113;112;111;110;108;107;106;105;104;102;101;100;99;98;97;96;93;92;91;90;89;87;86;85;83;81;79;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;9;-3740.393,-691.9702;Inherit;False;3377.736;1797.994;Paper + Object Texture;5;35;23;15;13;10;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.SamplerNode;152;-4825.543,-514.9548;Inherit;True;Property;_DecalTexture;DecalTexture;1;0;Create;True;0;0;False;0;False;-1;3bd11a8284767274cb9634e3368a262d;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;114;-5174.866,2303.39;Inherit;False;3145.105;593.8924;Noise;18;132;131;130;129;128;127;126;125;124;123;122;121;120;119;118;117;116;115;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;15;-3693.021,774.6367;Inherit;False;554.751;290.8408;FinalPass;2;32;25;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;13;-3685.451,107.582;Inherit;False;2537.716;636.7236;Albedo;3;43;28;155;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;11;-4891.829,142.2853;Inherit;False;723.4238;261.536;Grunges;2;66;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;10;-3682.191,-607.001;Inherit;False;2635.696;674.9272;Animated Grunge;23;76;75;71;70;69;68;65;64;62;61;58;56;54;53;52;51;48;45;41;38;21;18;17;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;158;-4465.305,-422.2521;Inherit;False;Albedo_Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;14;-4953.741,527.2929;Inherit;False;863.1523;325.855;Texture1_Final;5;77;74;59;47;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;133;718.4944,-653.7836;Inherit;False;984.1085;484.2753;Final Mix;8;1;142;135;134;143;139;136;161;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;79;-5107.051,1529.746;Inherit;False;1385.351;464.59;Normal Light Dir;7;109;103;95;94;88;84;82;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;16;-318.1318,-679.6904;Inherit;False;743.873;168.3657;IN_BRUME;3;67;50;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;76;-3638.092,-349.6772;Inherit;False;Property;_Decal_AnimatedGrunge_Tiling;Decal_AnimatedGrunge_Tiling;20;0;Create;True;0;0;False;0;False;1;32;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;128;-3824.175,2364.771;Inherit;False;Property;_ShadowNoisePanner;ShadowNoisePanner;9;0;Create;True;0;0;False;0;False;0.01,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;69;-2942.991,-457.2993;Inherit;False;Property;_Decal_IsGrungeAnimated;Decal_IsGrungeAnimated?;18;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-4089.374,2683.251;Inherit;False;Property;_ScreenBasedShadowNoise;ScreenBasedShadowNoise?;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2074.182,-314.5303;Inherit;False;Property;_Decal_AnimatedGrunge_Contrast;Decal_AnimatedGrunge_Contrast;24;0;Create;True;0;0;False;0;False;1.58;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-5058.56,1611.224;Inherit;True;154;Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;118;-2879.764,2387.712;Inherit;True;Property;_TextureSample60;Texture Sample 60;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;127;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;135;786.3165,-437.3641;Inherit;False;107;Shadows;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-2698.762,1494.515;Inherit;False;132;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-3304.142,-194.9253;Inherit;False;Property;_Decal_AnimatedGrunge_Flipbook_Rows;Decal_AnimatedGrunge_Flipbook_Rows;22;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;130;-4248.532,2395.441;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;123;-2880.764,2653.713;Inherit;True;Property;_TextureSample66;Texture Sample 66;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;127;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;129;-4713.93,2609.741;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;127;-5086.178,2403.216;Inherit;True;Property;_ShadowNoise;ShadowNoise;5;0;Create;True;0;0;False;1;Header(Shadow and Noise);False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;a61778d50b6394348b9f8089e2c6e1fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;41;-2322.592,-560.2393;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;5;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;122;-5084.926,2608.004;Inherit;True;Property;_InBrumeDrippingNoise;InBrumeDrippingNoise;15;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-2256.523,2628.585;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;131;-3785.373,2539.25;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1561.271,-83.28027;Inherit;False;Property;_Decal_AnimatedGrunge;Decal_AnimatedGrunge?;17;0;Create;True;0;0;False;1;Header(T1 Animated Grunge);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;121;-3082.523,2417.585;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-3303.142,-119.9253;Inherit;False;Property;_Decal_AnimatedGrunge_Flipbook_Speed;Decal_AnimatedGrunge_Flipbook_Speed;23;0;Create;True;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;126;-2544.523,2629.585;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-2202.398,185.0287;Inherit;False;20;Albedo_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-3305.142,-268.9253;Inherit;False;Property;_Decal_AnimatedGrunge_Flipbook_Columns;Decal_AnimatedGrunge_Flipbook_Columns;21;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;819.4705,-333.9701;Inherit;False;Constant;_Float47;Float 47;109;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;124;-3354.523,2417.585;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;156;-4589.464,884.6674;Inherit;False;Out_or_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-4465.677,-129.8462;Inherit;False;Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-4889.537,883.5424;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;0;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;-4891.271,741.1479;Inherit;False;156;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;77;-4624.161,586.5429;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;1211.564,-357.1722;Inherit;False;158;Albedo_Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;20;-4469.058,-516.4302;Inherit;False;Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;759.7825,-261.9682;Inherit;False;156;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;153;-4822.163,-128.3708;Inherit;True;Property;_DecalNormal;DecalNormal;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;74;-4889.36,662.499;Inherit;False;67;End_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;-599.3516,139.4297;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;-4309.591,581.2929;Inherit;False;Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;1265.96,-557.2402;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;860.0435,-585.9004;Inherit;False;46;Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-4898.741,582.0991;Inherit;False;32;End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-4498.931,2476.74;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;14;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;136;1014.161,-431.8344;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;125;-3514.534,2673.585;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;67;198.7383,-622.6904;Inherit;False;End_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;87;-469.0701,1792.194;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-4312.332,2613.839;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-3391.412,838.5449;Inherit;False;End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;43;-2187.271,301.981;Inherit;False;Property;_Decal_ColorCorrection;Decal_ColorCorrection;16;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-3514.534,2449.585;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-4852.327,193.2943;Inherit;True;Property;_TextureGrunge;TextureGrunge;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-3953.042,1600.936;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-3637.332,-260.8823;Inherit;False;Property;_Decal_AnimatedGrunge_ScreenBased;Decal_AnimatedGrunge_ScreenBased?;19;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-1773.252,-309.3403;Inherit;False;Property;_Decal_AnimatedGrunge_Multiply;Decal_AnimatedGrunge_Multiply;25;0;Create;True;0;0;False;0;False;1.58;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;58;-2603.821,-531.124;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCGrayscale;50;-30.13184,-620.3242;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;-2970.762,1910.515;Inherit;False;Constant;_Float77;Float 77;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;71;-3635.092,-531.6772;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;70;-3164.142,-21.92529;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;84;-4512.042,1874.934;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;51;-2927.132,-290.4053;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BlendOpsNode;104;-1971.666,1471.978;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1417.882,-192.2231;Inherit;False;Constant;_Float46;Float 46;171;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-1487.252,-554.3403;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;64;-1222.102,-157.105;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;53;-3332.172,-415.125;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;49;-263.1318,-620.3242;Inherit;False;32;End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3252.092,-540.6772;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;38;-3411.092,-531.6772;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;111;-301.2701,1655.794;Inherit;False;3;0;COLOR;1,1,1,1;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;52;-1989.531,-558.353;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;-1423.321,1690.162;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-50.97111,1810.863;Inherit;False;Shadows;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;23;-916.9121,138.5737;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-3646.162,837.834;Inherit;True;35;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1897.271,167.9819;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;81;-1364.571,1309.615;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;-0.23;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;106;-1908.322,1712.162;Inherit;False;Property;_EdgeShadowColor;EdgeShadowColor;13;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-1608.815,1836.024;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-3306.761,1574.515;Inherit;False;Property;_StepAttenuation;StepAttenuation;11;0;Create;True;0;0;False;0;False;-0.07;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;115;-4507.931,2609.741;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;62;-1758.182,-554.5303;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;99;-2954.762,1318.513;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-2762.762,1862.515;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;54;-3101.332,-536.8823;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-3114.762,1558.515;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-2794.762,1750.515;Inherit;False;109;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-4241.042,1616.936;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;90;-1914.472,1913.714;Inherit;False;Property;_ShadowColor;ShadowColor;12;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.8396226,0.8396226,0.8396226,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;94;-4785.04,1616.936;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.BlendOpsNode;100;-835.3401,1425.631;Inherit;True;Lighten;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;95;-4529.041,1616.936;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;86;-1631.512,1598.829;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-4486.609,193.6279;Inherit;False;T1_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;92;-2250.772,1318.513;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;93;-1235.402,1805.183;Inherit;False;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-2762.762,1958.515;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;89;-718.4702,1791.995;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;91;-2474.764,1318.513;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-3673.771,1856.515;Inherit;False;Property;_StepShadow;StepShadow;10;0;Create;True;0;0;False;0;False;0.1;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;88;-4801.041,1760.935;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;97;-2554.763,1830.515;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;-3226.761,1318.513;Inherit;False;109;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1430.197,-556.9896;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;Decals;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;1;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;158;0;152;4
WireConnection;118;1;121;0
WireConnection;130;0;117;0
WireConnection;123;1;125;0
WireConnection;41;1;58;0
WireConnection;132;0;126;0
WireConnection;131;0;130;0
WireConnection;131;1;120;0
WireConnection;131;2;116;0
WireConnection;121;0;124;0
WireConnection;126;0;118;1
WireConnection;126;1;123;1
WireConnection;124;0;131;0
WireConnection;124;2;119;0
WireConnection;156;0;157;0
WireConnection;154;0;153;0
WireConnection;77;0;59;0
WireConnection;77;1;74;0
WireConnection;77;2;47;0
WireConnection;20;0;152;0
WireConnection;35;0;23;0
WireConnection;46;0;77;0
WireConnection;139;0;134;0
WireConnection;139;1;136;0
WireConnection;136;0;135;0
WireConnection;136;1;143;0
WireConnection;136;2;142;0
WireConnection;125;0;131;0
WireConnection;125;2;128;0
WireConnection;67;0;50;0
WireConnection;87;0;89;0
WireConnection;120;0;115;0
WireConnection;120;1;117;0
WireConnection;32;0;25;0
WireConnection;119;0;128;0
WireConnection;109;0;103;0
WireConnection;58;0;54;0
WireConnection;58;1;51;0
WireConnection;58;2;69;0
WireConnection;50;0;49;0
WireConnection;51;0;54;0
WireConnection;51;1;68;0
WireConnection;51;2;65;0
WireConnection;51;3;21;0
WireConnection;51;5;70;0
WireConnection;104;0;92;0
WireConnection;104;1;97;0
WireConnection;56;0;62;0
WireConnection;56;1;45;0
WireConnection;64;0;61;0
WireConnection;64;1;56;0
WireConnection;64;2;75;0
WireConnection;53;0;76;0
WireConnection;18;0;38;0
WireConnection;18;1;76;0
WireConnection;38;0;71;0
WireConnection;111;1;100;0
WireConnection;111;2;87;0
WireConnection;52;0;41;1
WireConnection;83;0;86;0
WireConnection;83;1;106;0
WireConnection;107;0;111;0
WireConnection;23;0;64;0
WireConnection;23;1;28;0
WireConnection;28;0;155;0
WireConnection;28;1;43;0
WireConnection;81;0;104;0
WireConnection;112;0;104;0
WireConnection;112;1;90;0
WireConnection;115;0;129;0
WireConnection;62;1;52;0
WireConnection;62;0;48;0
WireConnection;99;0;102;0
WireConnection;99;1;98;0
WireConnection;99;2;105;0
WireConnection;108;0;98;0
WireConnection;108;1;113;0
WireConnection;54;0;18;0
WireConnection;54;1;53;0
WireConnection;54;2;17;0
WireConnection;105;0;98;0
WireConnection;105;1;101;0
WireConnection;103;0;95;0
WireConnection;103;1;84;0
WireConnection;94;0;82;0
WireConnection;100;0;81;0
WireConnection;100;1;93;0
WireConnection;100;2;104;0
WireConnection;95;0;94;0
WireConnection;95;1;88;0
WireConnection;86;0;104;0
WireConnection;66;0;5;0
WireConnection;92;0;91;0
WireConnection;93;0;83;0
WireConnection;93;1;112;0
WireConnection;96;0;105;0
WireConnection;96;1;113;0
WireConnection;89;0;104;0
WireConnection;91;0;99;0
WireConnection;91;1;85;0
WireConnection;97;0;110;0
WireConnection;97;1;108;0
WireConnection;97;2;96;0
WireConnection;1;2;139;0
WireConnection;1;3;161;0
ASEEND*/
//CHKSM=10C9A4D67BF2342850DF8183E02319946D96D287
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TerrainMaterialShader"
{
	Properties
	{
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[ASEBegin]_TextureArray_2("TextureArray_2", 2DArray) = "white" {}
		_TextureArray_4("TextureArray_4", 2DArray) = "white" {}
		_TextureArray_3("TextureArray_3", 2DArray) = "white" {}
		[ASEEnd]_TextureArray_1("TextureArray_1", 2DArray) = "white" {}

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

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
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
			
			Blend One Zero, One Zero
			ZWrite On
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

			#define ASE_NEEDS_FRAG_COLOR


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
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
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
						#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D_ARRAY(_TextureArray_1);
			SAMPLER(sampler_TextureArray_1);
			TEXTURE2D_ARRAY(_TextureArray_2);
			SAMPLER(sampler_TextureArray_2);
			TEXTURE2D_ARRAY(_TextureArray_3);
			SAMPLER(sampler_TextureArray_3);
			TEXTURE2D_ARRAY(_TextureArray_4);
			SAMPLER(sampler_TextureArray_4);


						
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
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
				float4 ase_color : COLOR;

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
				o.ase_color = v.ase_color;
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
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
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
				float2 texCoord50 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float4 T1_Normal_Texture139 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_1, sampler_TextureArray_1, texCoord50,1.0 );
				float2 texCoord650 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float4 T2_Normal_Texture658 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_2, sampler_TextureArray_2, texCoord650,1.0 );
				float4 lerpResult632 = lerp( T1_Normal_Texture139 , T2_Normal_Texture658 , IN.ase_color.r);
				float2 texCoord665 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float4 T3_Normal_Texture673 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_3, sampler_TextureArray_3, texCoord665,1.0 );
				float4 lerpResult635 = lerp( lerpResult632 , T3_Normal_Texture673 , IN.ase_color.g);
				float2 texCoord680 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float4 T4_Normal_Texture686 = SAMPLE_TEXTURE2D_ARRAY( _TextureArray_4, sampler_TextureArray_4, texCoord680,1.0 );
				float4 lerpResult640 = lerp( lerpResult635 , T4_Normal_Texture686 , IN.ase_color.b);
				float4 AllNormal644 = lerpResult640;
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = AllNormal644.rgb;
				float Alpha = 1;
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
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
						#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
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

				
				float Alpha = 1;
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
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
						#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
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

				
				float Alpha = 1;
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
1920;0;1920;1019;4482.41;217.9764;2.823192;True;False
Node;AmplifyShaderEditor.CommentaryNode;42;-13216.01,-6014.816;Inherit;False;4068.818;1665.93;Paper + Object Texture;31;403;381;377;373;336;318;297;288;285;258;253;239;224;208;202;190;184;179;175;167;163;158;156;150;146;145;135;132;130;127;616;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;-7425.981,-6092.449;Inherit;False;5750.871;4770.477;IN BRUME;23;417;401;396;393;392;389;321;319;295;293;290;289;276;275;264;256;248;229;164;37;34;33;31;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-7370.88,-3500.96;Inherit;False;3114.2;902.8672;NormalDrippingGrunge;20;383;382;372;360;350;344;339;317;316;305;303;296;277;236;216;210;206;178;154;134;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-17878.86,-5247.149;Inherit;False;1788.085;588.8215;Normal Light Dir;7;414;413;412;411;358;169;140;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;38;-11282.93,-8121.077;Inherit;False;711.9073;439.9834;Noise et Grunge OutBrume TextureArray Setup;4;307;284;278;221;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;675;-11387.53,-9504.498;Inherit;False;1208.855;894.2474;Textures Arrays 4;14;689;688;687;686;685;684;683;682;681;680;679;678;677;676;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-17874.76,-4014.039;Inherit;False;3565.746;1090.681;Shadow Smooth Edge + Int Shadow;20;435;434;433;432;431;430;429;428;427;426;425;424;422;421;420;418;416;408;406;356;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-16058.7,-5246.945;Inherit;False;1208.831;589.7677;CustomRimLight;9;385;602;601;600;262;397;332;395;410;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;588;-4540.847,-789.0635;Inherit;False;1281.268;1101.646;Debug Textures;16;590;564;566;479;478;477;488;563;559;592;593;594;595;596;597;598;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-15158.65,-9500.779;Inherit;False;1208.855;894.2474;Textures Arrays 1;14;133;139;265;599;225;74;177;171;155;50;71;172;241;268;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;34;-7375.981,-4126.84;Inherit;False;2088.706;597.0554;InBrumeGrunge;16;374;329;325;324;322;320;311;306;261;255;254;250;249;244;151;124;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;36;-10542.98,-8161.736;Inherit;False;542.5189;491.103;InBrume TextureArray Setup;4;347;271;200;283;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-7366.423,-5096.373;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;20;375;364;355;351;304;251;247;240;232;231;226;222;213;212;211;196;195;193;189;137;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;37;-7357.026,-6042.449;Inherit;False;2193.24;919.6926;InkSplatter;15;388;341;338;331;330;314;312;299;292;287;220;217;160;149;138;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;645;-13904.59,-9502.766;Inherit;False;1208.855;894.2474;Textures Arrays 2;14;659;658;657;656;655;654;653;652;651;650;649;648;647;646;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-17877.14,-4636.892;Inherit;False;2700.771;602.1591;Noise;18;386;371;365;363;362;359;352;218;197;180;176;170;168;162;159;157;142;128;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;616;-12336.62,-4893.989;Inherit;False;2024.437;397.7363;T1 Albedo;10;335;191;252;399;615;617;618;619;620;621;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;660;-12641.59,-9502.512;Inherit;False;1208.855;894.2474;Textures Arrays 3;14;674;673;672;671;670;669;668;667;666;665;664;663;662;661;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;587;-3207.46,-775.9969;Inherit;False;2067.298;1155.405;Texture Set by Vertex Color;24;622;1;489;573;576;495;580;581;583;584;14;579;578;11;569;571;574;570;565;577;567;7;586;585;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;35;-13210.75,-4291.465;Inherit;False;3799.808;1008.013;Add Rougness and Normal;30;419;384;379;370;369;368;366;342;334;328;326;323;315;310;298;269;267;266;263;243;238;235;230;228;215;199;198;194;186;131;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-9396.275,-7376.218;Inherit;False;1513.52;501.626;MixFinal_1;11;607;568;349;274;611;280;286;609;294;340;282;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;604;-9317.788,-8121.294;Inherit;False;673.8345;550.9663;Global Variables;8;610;608;423;281;606;605;613;614;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;389;-4119.655,-5676.304;Inherit;False;Property;_Color8;Color 8;39;0;Create;True;0;0;False;0;False;1,1,1,0;0.8962264,0.8890581,0.883544,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;303;-6317.665,-2794.404;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;412;-17174.85,-4959.149;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;132;-12778.72,-5521.126;Inherit;False;Property;_Float97;Float 97;11;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;350;-4849.32,-3383.314;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;344;-6047.629,-2824.156;Inherit;True;Property;_TextureSample64;Texture Sample 64;45;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;158;-12145.4,-5783.325;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BlendOpsNode;434;-15890.76,-3438.039;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;388;-5431.283,-5893.901;Inherit;False;InkSplatter;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;575;-5819.249,-413.6062;Inherit;False;Texture3_Final;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-12744.67,-5783.878;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;352;-16192.28,-4404.756;Inherit;False;Constant;_Float75;Float 75;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;386;-16229.13,-4508.891;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-17635.14,-4243.036;Inherit;False;Property;_Float96;Float 96;20;0;Create;True;0;0;False;1;Header(Shadow and NoiseEdge);False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;590;-4497.037,-534.3443;Inherit;False;Property;_DebugTextureTiling;DebugTextureTiling;60;0;Create;True;0;0;False;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;564;-4181.425,-738.1528;Inherit;False;Property;_DebugVertexPaint;DebugVertexPaint;59;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;566;-3873.515,-739.0635;Inherit;False;DebugVertexPaint;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;375;-7183.247,-4736.645;Inherit;False;Property;_Float128;Float 128;44;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;421;-17074.75,-3358.039;Inherit;False;Constant;_Float77;Float 77;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;304;-4945.378,-4789.932;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;261;-6652.853,-4073.765;Inherit;False;Procedural Sample;-1;;34;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerNode;218;-16026.37,-4538.764;Inherit;True;Property;_TextureSample60;Texture Sample 60;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;-4552.413,-3383.488;Inherit;False;NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;190;-9709.216,-5461.849;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;-3823.906,-5767.313;Inherit;False;388;InkSplatter;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;206;-6758.379,-3450.96;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-6592.546,-2838.825;Inherit;False;Property;_Float115;Float 115;49;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;160;-5909.871,-5632.509;Inherit;False;Property;_Float105;Float 105;40;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;196;-6638.671,-4816.258;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-7202.827,-3603.914;Inherit;False;Property;_Float94;Float 94;55;0;Create;True;0;0;False;0;False;0.2;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-6850.03,-3158.956;Inherit;False;Property;_Float104;Float 104;48;0;Create;True;0;0;False;0;False;0.45;0.461;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;195;-6734.398,-4562.335;Inherit;True;Property;_TextureSample59;Texture Sample 59;46;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;479;-3486.532,74.6332;Inherit;True;DebugColor4;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-7227.653,-3876.066;Inherit;False;Property;_Float102;Float 102;52;0;Create;True;0;0;False;0;False;0.2;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;222;-6624.422,-5041.272;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;373;-11066.72,-5841.126;Inherit;False;Property;_Color6;Color 6;14;0;Create;True;0;0;False;0;False;0.5660378,0.5660378,0.5660378,0;0.5019608,0.5019608,0.5019608,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;606;-8937.119,-8011.087;Inherit;False;Out_or_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;608;-8929.078,-7912.581;Inherit;False;LightDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-2251.303,-4448.752;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;356;-17330.75,-3950.039;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;-16931.98,-4387.226;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;401;-3967.829,-5057.043;Inherit;False;Property;_Color11;Color 11;38;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.1509433,0.1509433,0.1509433,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;478;-3484.078,-168.1343;Inherit;True;DebugColor3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-16661.14,-4476.891;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;488;-3486.83,-647.317;Inherit;True;DebugColor1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-17395.14,-4531.035;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-17395.14,-4323.036;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;362;-16501.13,-4508.891;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-15403.13,-4297.892;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-16326.85,-5119.148;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;371;-16196.28,-4168.756;Inherit;False;Constant;_Float76;Float 76;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;262;-15756.94,-5191.212;Inherit;True;265;T1_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;385;-15718.49,-5001.168;Inherit;False;Property;_Float130;Float 130;35;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;397;-15992.49,-4954.168;Inherit;False;Property;_Color9;Color 9;33;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;600;-16037.45,-4783.971;Inherit;False;599;T1_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;340;-9060.105,-7296.453;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;282;-8728.649,-7294.633;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;609;-8992.925,-6991.189;Inherit;False;608;LightDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;286;-8330.637,-7292.667;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;281;-9233.318,-7810.367;Inherit;False;Property;_NormalDebug;NormalDebug;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;610;-8928.369,-7810.112;Inherit;False;NormalDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;-8612.253,-7142.125;Inherit;False;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;607;-9327.222,-7141.849;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;349;-9325.312,-7220.497;Inherit;False;289;End_InBrume_1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-17162.98,-4236.226;Inherit;False;Property;_Float106;Float 106;21;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;477;-3483.58,-405.3319;Inherit;True;DebugColor2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;396;-4490.254,-5473.491;Inherit;False;351;ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;410;-15079.91,-5041.241;Inherit;False;CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;432;-16140.76,-3184.039;Inherit;False;Property;_Color12;Color 12;25;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.5,0.5,0.5,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;586;-1873.994,330.5484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;417;-3256.837,-5080.469;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;582;-5818.498,-324.706;Inherit;False;Texture4_Final;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;563;-4263.429,-553.2584;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;159;-16885.14,-4172.892;Inherit;False;Property;_Vector7;Vector 7;22;0;Create;True;0;0;False;0;False;0.2,-0.1;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BlendOpsNode;365;-15691.13,-4296.892;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;359;-16661.14,-4252.892;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;-4216.702,-4862.665;Inherit;False;351;ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;176;-17827.14,-4323.036;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;162;-17619.14,-4323.036;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;411;-17158.85,-5103.148;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DotProductOpNode;414;-16902.85,-5103.148;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;289;-2006.473,-4429.997;Inherit;False;End_InBrume_1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;413;-16614.85,-5103.148;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;-9018.164,-7070.93;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;395;-15446.49,-5152.168;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;601;-15441.78,-4952.834;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;-15234.79,-5035.807;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightAttenuation;358;-16886.85,-4831.149;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;231;-7297.423,-4466.294;Inherit;False;Property;_Vector9;Vector 9;46;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StepOpNode;382;-6122.244,-3379.892;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-10045.22,-5509.849;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;217;-7107.586,-5841.696;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;149;-7322.026,-5823.288;Inherit;False;Property;_Float100;Float 100;41;0;Create;True;0;0;False;0;False;1;3.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;338;-6286.145,-5863.448;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;255;-6904.678,-3986.904;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;250;-7325.981,-4075.66;Inherit;True;Property;_InBrumeGrunge_Texture5;ShadowInBrumeGrunge_Texture;51;0;Create;False;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;212;-6905.398,-4392.335;Inherit;False;Constant;_Float66;Float 66;88;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;137;-6115.791,-4426.054;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;431;-15522.76,-3758.039;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;177;-14638.01,-9230.197;Inherit;True;Property;_TextureSample57;Texture Sample 57;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;429;-16306.76,-3438.039;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;251;-5239.326,-4665.913;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;164;-4221.62,-5467.479;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;138;-7040.23,-5698.716;Inherit;False;Constant;_Float61;Float 61;90;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;299;-6835.496,-5311.113;Inherit;False;Constant;_Float72;Float 72;88;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;256;-4030.63,-5467.285;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SwizzleNode;167;-12952.67,-5783.878;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;163;-13176.67,-5783.878;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;435;-16866.75,-3406.039;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;331;-6318.615,-5580.339;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;155;-14636.29,-9035.098;Inherit;True;Property;_TextureSample55;Texture Sample 55;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;171;-14632.29,-8838.098;Inherit;True;Property;_TextureSample56;Texture Sample 56;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;682;-10866.9,-9233.916;Inherit;True;Property;_TextureSample33;Texture Sample 33;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;681;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;597;-4150.81,-203.6497;Inherit;False;Constant;_Float2;Float 2;69;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;598;-4150.81,-122.6497;Inherit;False;Constant;_Float3;Float 3;69;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;596;-4151.81,-284.6497;Inherit;False;Constant;_Float1;Float 1;69;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;559;-3896.891,-580.6194;Inherit;True;Property;_DebugTextureArray;DebugTextureArray;58;0;Create;True;0;0;False;0;False;-1;fcf4482ca7d817c42b6d03968194b044;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;592;-3894.55,-357.618;Inherit;True;Property;_TextureSample24;Texture Sample 24;56;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;624;-2345.954,1739.598;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;644;-1248.39,1649.39;Inherit;False;AllNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;694;-1590.583,1852.339;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;693;-1866.583,1629.339;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;642;-2378.185,1024.135;Inherit;True;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;632;-2092.181,1224.832;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;640;-1524.046,1654.737;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;692;-1796.689,1666.611;Inherit;True;686;T4_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;635;-1811.723,1435.357;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;691;-2075.867,1453.159;Inherit;True;673;T3_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;-2376.733,1218.166;Inherit;True;658;T2_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;-17432.37,-5108.861;Inherit;True;644;AllNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;684;-10861.18,-8841.816;Inherit;True;Property;_TextureSample35;Texture Sample 35;19;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;681;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;683;-10865.18,-9038.816;Inherit;True;Property;_TextureSample34;Texture Sample 34;21;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;681;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;325;-5775.559,-4075.504;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;232;-7189.405,-4823.219;Inherit;False;Property;_Float114;Float 114;43;0;Create;True;0;0;False;0;False;0.2;0.003;0.001;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;249;-6654.827,-3787.914;Inherit;False;Procedural Sample;-1;;35;f5379ff72769e2b4495e5ce2f004d8d4;2,157,0,315,0;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.SamplerNode;363;-16028.37,-4272.763;Inherit;True;Property;_TextureSample66;Texture Sample 66;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;134;-7041.243,-3450.944;Inherit;False;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;-3219.031,-4408.236;Inherit;False;296;NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;339;-6138.001,-3128.066;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;317;-5897.544,-3127.622;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;287;-5606.092,-5889.403;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;418;-15106.76,-3454.039;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;427;-16866.75,-3310.039;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;360;-5663.355,-2936.923;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-5163.191,-3376.071;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;318;-10634.72,-5697.126;Inherit;False;Property;_Float124;Float 124;15;0;Create;True;0;0;False;0;False;1.58;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-9336.692,-7300.898;Inherit;False;187;End_OutBrume_1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;383;-5122.768,-3080.941;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;275;-2677.368,-4425.381;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;312;-5908.411,-5868.047;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;351;-4747.534,-4841.545;Inherit;False;ShadowDrippingNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;320;-6025.943,-4069.622;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;247;-5632.327,-4929.766;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-10442.72,-5841.126;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;314;-6664.496,-5481.115;Inherit;True;Property;_TextureSample63;Texture Sample 63;47;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;341;-6560.145,-5865.448;Inherit;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-6723.482,-5665.782;Inherit;False;Constant;_Float67;Float 67;53;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;426;-16802.75,-3774.039;Inherit;False;197;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;213;-6985.759,-4533.913;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;605;-9237.19,-8012.212;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;0;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;602;-15721.21,-4743.461;Inherit;False;Property;_RimLightTexture;RimLightTexture?;34;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;372;-5419.317,-3380.77;Inherit;False;324;NormalInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;179;-12468.71,-5542.605;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;226;-5456.568,-4671.613;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;248;-2553.094,-4712.827;Inherit;False;Property;_Color4;Color 4;57;0;Create;True;0;0;False;0;False;1,1,1,0;0.8773585,0.8773585,0.8773585,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-3866.411,-5644.372;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;240;-5909.79,-4426.054;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;594;-3892.55,96.38196;Inherit;True;Property;_TextureSample26;Texture Sample 26;56;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;244;-6911.678,-3711.904;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;178;-6869.162,-3058.584;Inherit;False;Property;_Float108;Float 108;47;0;Create;True;0;0;False;0;False;0.01;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;254;-7318.004,-3789.697;Inherit;True;Property;_InBrumeGrunge_Texture6;NormalInBrumeGrunge_Texture;54;0;Create;False;0;0;False;0;False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;189;-6944.066,-5046.373;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-12484.57,-5709.5;Inherit;False;Property;_Float101;Float 101;9;0;Create;True;0;0;False;1;Header(Paper);False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;-2953.688,-4426.829;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;593;-3891.55,-125.618;Inherit;True;Property;_TextureSample25;Texture Sample 25;56;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;208;-12705.72,-5274.126;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-11846.8,-5776.848;Inherit;False;Constant;_Float62;Float 62;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;423;-9239.8,-7913.384;Inherit;False;Property;_LightDebug;LightDebug;1;0;Create;True;0;0;False;1;Header(Debug);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;316;-6238.629,-2676.156;Inherit;False;Constant;_Float73;Float 73;88;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;428;-14842.96,-3458.69;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;615;-10768.25,-4649.06;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;568;-8120.023,-7297.755;Inherit;False;Texture1_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-12762.72,-5361.126;Inherit;False;Property;_Float98;Float 98;13;0;Create;True;0;0;False;0;False;1;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;292;-6876.824,-5870.589;Inherit;True;Property;_TextureSample62;Texture Sample 62;48;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-3958.447,-4857.733;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;374;-5559.276,-4076.84;Inherit;False;ShadowInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;425;-17777.76,-3412.039;Inherit;False;Property;_Float133;Float 133;23;0;Create;True;0;0;False;0;False;0.03;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;416;-16898.75,-3518.039;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;330;-5873.117,-5983.251;Inherit;False;Constant;_Float74;Float 74;59;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-12762.72,-5441.126;Inherit;False;Property;_Float95;Float 95;12;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;-10514.23,-3715.467;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;319;-3684.002,-5052.277;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;406;-16658.75,-3438.039;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;424;-16578.75,-3950.039;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;355;-5249.579,-5016.292;Inherit;False;Property;_Float127;Float 127;42;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-6811.586,-4792.81;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-12968.67,-5703.878;Inherit;False;Property;_Float107;Float 107;10;0;Create;True;0;0;False;0;False;1;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;210;-6599.248,-2751.37;Inherit;False;Property;_Vector8;Vector 8;50;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;216;-6536.851,-3062.386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;433;-15250.76,-3886.039;Inherit;False;LightMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;572;-5817.063,-514.9233;Inherit;False;Texture2_Final;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;211;-6358.444,-4649.824;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;408;-16354.76,-3950.039;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;617;-11652.34,-4842.446;Inherit;False;Procedural Sample;-1;;33;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;611;-8560.508,-7058.438;Inherit;False;610;NormalDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;329;-6328.169,-3972.384;Inherit;False;Property;_Float125;Float 125;53;0;Create;True;0;0;False;0;False;-3.38;-20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;392;-3617.031,-5672.031;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;393;-4217.89,-4784.807;Inherit;False;374;ShadowInBrumeGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;322;-5777.791,-3791.085;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;381;-11673.78,-5936.011;Inherit;True;Property;_TextureSample67;Texture Sample 67;16;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;305;-5414.734,-3081.477;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;324;-5539.774,-3791.234;Inherit;False;NormalInBrumeGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;364;-7291.929,-4554.37;Inherit;False;Property;_DrippingNoise_Tiling3;ShadowDrippingNoise_Tiling;45;0;Create;False;0;0;False;0;False;1;-5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;422;-17410.75,-3694.039;Inherit;False;Property;_Float131;Float 131;24;0;Create;True;0;0;False;0;False;0.3;-0.07;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;403;-11274.72,-5937.126;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;420;-17218.75,-3710.039;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;239;-11815.69,-5423.623;Inherit;True;Property;_T1_BackgroundGrunge;T1_BackgroundGrunge;16;0;Create;True;0;0;False;1;Header(Ink Grunge);False;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;577;-2626.044,-12.25747;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;145;-11771.8,-5216.723;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;618;-12267.73,-4842.773;Inherit;True;Property;_Texture0;Texture 0;61;0;Create;True;0;0;False;0;False;fcf4482ca7d817c42b6d03968194b044;fcf4482ca7d817c42b6d03968194b044;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;619;-12024.93,-4757.689;Inherit;False;Constant;_Float4;Float 4;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;620;-12024.46,-4671.686;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;621;-11835.37,-4606.078;Inherit;False;Constant;_Float5;Float 5;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;288;-10810.72,-5921.126;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-9391.652,-5460.993;Inherit;False;RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;326;-10265.9,-3568.457;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;336;-11432.04,-5299.646;Inherit;False;Procedural Sample;-1;;32;f5379ff72769e2b4495e5ce2f004d8d4;2,157,2,315,2;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;405;-12192.21,-2964.772;Inherit;False;410;CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;379;-12660.7,-3817.524;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TextureCoordinatesNode;235;-12233.01,-3571.467;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;328;-10738.23,-3603.467;Inherit;False;Property;_Color5;Color 5;30;0;Create;True;0;0;False;0;False;0.9433962,0.8590411,0.6274475,0;0.9433962,0.8590411,0.6274475,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;194;-12262.19,-4192.662;Inherit;False;Property;_Float109;Float 109;27;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;370;-12452.7,-3817.524;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-12160.23,-3412.816;Inherit;False;Constant;_Float60;Float 60;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;186;-11954.28,-3599.207;Inherit;True;Property;_TextureSample58;Texture Sample 58;13;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-9890.229,-3971.466;Inherit;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;198;-12087.7,-4004.25;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;243;-11314.23,-3715.467;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;323;-10178.23,-4003.466;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;342;-10707.23,-3862.467;Inherit;False;Property;_Float126;Float 126;31;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;238;-11522.23,-3715.467;Inherit;False;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;230;-12292.7,-3913.524;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-12393.01,-3555.468;Inherit;False;Property;_Float113;Float 113;29;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;267;-10499.23,-3451.467;Inherit;False;Constant;_Float70;Float 70;31;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;298;-10914.23,-3715.467;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;310;-11154.23,-3715.467;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;334;-10178.23,-3923.467;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;581;-2134.641,248.6746;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;567;-3154.445,-577.0076;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;585;-2255.994,20.5484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;315;-10355.23,-3974.466;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-13107.99,-3118.894;Inherit;False;202;RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;199;-12262.19,-4112.661;Inherit;False;Property;_Float110;Float 110;28;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;215;-11926.19,-4208.662;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;368;-12548.7,-4009.524;Inherit;False;Blinn-Phong Half Vector;-1;;31;91a149ac9d615be429126c95e20753ce;0;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;266;-10498.98,-3365.396;Inherit;False;Property;_Float117;Float 117;26;0;Create;True;0;0;False;1;Header(Specular);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;366;-12914.77,-3822.837;Inherit;True;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;419;-10989.88,-4142.412;Inherit;True;225;T1_Roughness_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-11249.1,-3186.032;Inherit;False;End_OutBrume_1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;384;-9628.654,-3977.494;Inherit;False;RoughnessNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;291;-12872.89,-3124.64;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;-12397.08,-3204.078;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;369;-10658.2,-4138.852;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;407;-12622.83,-3124.457;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;415;-11971.02,-3086.426;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;409;-11899.4,-2807.902;Inherit;False;Property;_Float137;Float 137;32;0;Create;True;0;0;False;1;Header(Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;387;-12645.21,-3223.189;Inherit;False;384;RoughnessNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;259;-13106.64,-3027.941;Inherit;False;428;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;246;-11678.13,-3184.831;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;7;-3041.587,109.4958;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;574;-3150.048,-442.997;Inherit;False;572;Texture2_Final;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;565;-2910.257,-669.2269;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;679;-11287.8,-9339.641;Inherit;False;Constant;_Float6;Float 6;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;225;-14235.15,-9045.006;Inherit;False;T1_Roughness_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;599;-14249.61,-8829.762;Inherit;False;T1_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-14248.75,-8741.824;Inherit;False;T1_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-14231.8,-9222.693;Inherit;False;T1_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-14240.8,-9419.691;Inherit;False;T1_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;646;-13801.86,-9109.908;Inherit;False;Constant;_Float17;Float 17;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;647;-13803.86,-9184.908;Inherit;False;Constant;_Float16;Float 16;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;648;-13803.86,-9260.908;Inherit;False;Constant;_Float15;Float 15;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;74;-14636.45,-9423.305;Inherit;True;Property;_TextureArray_1;TextureArray_1;7;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;649;-13804.86,-9337.908;Inherit;False;Constant;_Float14;Float 14;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;221;-11040.18,-7880.026;Inherit;True;Property;_TextureSample61;Texture Sample 61;71;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;271;-10338.06,-8099.816;Inherit;True;Property;_TextureSample69;Texture Sample 69;37;0;Create;True;0;0;False;0;False;-1;0b5330c4506cf76469355adb5b4180b0;0b5330c4506cf76469355adb5b4180b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;306;-6020.219,-3785.785;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;571;-3147.009,-293.3603;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;569;-2902.821,-385.5794;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;11;-2675.045,-410.3001;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;578;-2629.06,-86.10568;Inherit;False;478;DebugColor3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;579;-2629.084,-161.8942;Inherit;False;575;Texture3_Final;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;347;-10341.64,-7881.316;Inherit;True;Property;_TextureSample65;Texture Sample 65;77;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-15094.11,-8918.295;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-15058.91,-9335.924;Inherit;False;Constant;_Float53;Float 53;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-15057.91,-9258.924;Inherit;False;Constant;_Float63;Float 63;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;613;-9232.355,-7705.594;Inherit;False;Property;_GrayscaleDebug;GrayscaleDebug;2;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;377;-11300.9,-5095.656;Inherit;False;Property;_Float129;Float 129;18;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-10600.84,-5292.504;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;285;-11038.73,-5292.371;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;258;-11793.53,-5045.613;Inherit;False;Property;_Float116;Float 116;17;0;Create;True;0;0;False;0;False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;297;-10891.84,-5062.504;Inherit;False;Property;_Float121;Float 121;19;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;595;-4154.104,-365.5041;Inherit;False;Constant;_Float0;Float 0;69;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;399;-11351.62,-4699.589;Inherit;False;Property;_T1_ColorCorrection;T1_ColorCorrection;36;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;252;-10766.79,-4734.092;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;191;-10492.88,-4831.779;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-11061.62,-4833.588;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;614;-8924.918,-7706.519;Inherit;False;GrayscaleDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;135;-10376.79,-5292.313;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;311;-6347.441,-3691.546;Inherit;False;Property;_Float123;Float 123;56;0;Create;True;0;0;False;0;False;2.4;-6.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;430;-17058.75,-3950.039;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;654;-13382.4,-9425.289;Inherit;True;Property;_TextureArray_2;TextureArray_2;4;0;Create;True;0;0;False;0;False;-1;9396915cfffc85f40a47e32c6959c0c2;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;307;-11249.65,-7832.82;Inherit;False;Constant;_Float122;Float 122;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;268;-15055.91,-9107.924;Inherit;False;Constant;_Float71;Float 71;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;241;-15057.91,-9182.924;Inherit;False;Constant;_Float69;Float 69;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;680;-11322.99,-8922.014;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;584;-2137.658,174.8264;Inherit;False;479;DebugColor4;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;14;-2183.177,-127.2926;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;580;-1890.453,156.4554;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;688;-10478.5,-8833.479;Inherit;False;T4_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;689;-10477.64,-8745.541;Inherit;False;T4_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;685;-10469.69,-9423.41;Inherit;False;T4_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;659;-12986.75,-9421.678;Inherit;False;T2_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;667;-12115.23,-8839.83;Inherit;True;Property;_TextureSample30;Texture Sample 30;16;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;669;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;666;-12119.23,-9036.83;Inherit;True;Property;_TextureSample29;Texture Sample 29;23;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;669;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;668;-12120.95,-9231.93;Inherit;True;Property;_TextureSample28;Texture Sample 28;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;669;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;664;-12541.85,-9337.656;Inherit;False;Constant;_Float13;Float 13;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;652;-13378.24,-8840.084;Inherit;True;Property;_TextureSample27;Texture Sample 27;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;654;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;658;-12977.75,-9223.678;Inherit;False;T2_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;655;-12981.1,-9046.99;Inherit;False;T2_Roughness_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;656;-12995.56,-8831.746;Inherit;False;T2_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;657;-12994.7,-8743.809;Inherit;False;T2_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;661;-12538.85,-9109.656;Inherit;False;Constant;_Float12;Float 12;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;662;-12540.85,-9184.656;Inherit;False;Constant;_Float11;Float 11;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;663;-12540.85,-9260.656;Inherit;False;Constant;_Float10;Float 10;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;665;-12577.05,-8920.027;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;669;-12119.39,-9425.037;Inherit;True;Property;_TextureArray_3;TextureArray_3;6;0;Create;True;0;0;False;0;False;-1;f12877cabaeb8ab42a06a6297e4c4820;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;676;-11284.8,-9111.641;Inherit;False;Constant;_Float9;Float 9;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;677;-11286.8,-9186.641;Inherit;False;Constant;_Float8;Float 8;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;678;-11286.8,-9262.641;Inherit;False;Constant;_Float7;Float 7;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;687;-10464.04,-9048.723;Inherit;False;T4_Roughness_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;583;-2137.681,99.03793;Inherit;False;582;Texture4_Final;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;686;-10460.69,-9225.41;Inherit;False;T4_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;653;-13383.96,-9232.184;Inherit;True;Property;_TextureSample32;Texture Sample 32;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;654;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;622;-1368.023,127.2877;Inherit;False;FinalAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;284;-11039.24,-8068.385;Inherit;True;Property;_TextureSample70;Texture Sample 70;8;0;Create;True;0;0;False;0;False;-1;8fdb86c7e9893674ea4c46a3398744c6;8fdb86c7e9893674ea4c46a3398744c6;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;200;-10505.38,-7833.577;Inherit;False;Constant;_Float111;Float 111;90;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;283;-10512.38,-8051.577;Inherit;False;Constant;_Float120;Float 120;90;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;650;-13840.05,-8920.281;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;576;-2381.856,-104.4767;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;570;-3150.025,-367.2085;Inherit;False;477;DebugColor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;489;-3157.46,-650.8559;Inherit;False;488;DebugColor1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;651;-13382.24,-9037.084;Inherit;True;Property;_TextureSample31;Texture Sample 31;22;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;654;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;674;-11723.74,-9421.424;Inherit;False;T3_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;670;-11718.09,-9046.738;Inherit;False;T3_Roughness_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;671;-11732.55,-8831.494;Inherit;False;T3_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;672;-11731.69,-8743.557;Inherit;False;T3_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;681;-10865.34,-9427.021;Inherit;True;Property;_TextureArray_4;TextureArray_4;5;0;Create;True;0;0;False;0;False;-1;7edf6ff27381fb14cb946c8e85c4a115;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;495;-1643.679,132.6349;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;278;-11247.27,-8020.988;Inherit;False;Constant;_Float118;Float 118;87;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;673;-11714.74,-9224.426;Inherit;False;T3_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;573;-3157.048,-725.9969;Inherit;False;568;Texture1_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-1590.803,-50.38741;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;-969.1179,1632.945;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;TerrainMaterialShader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
WireConnection;303;0;236;0
WireConnection;303;1;210;0
WireConnection;350;0;277;0
WireConnection;350;1;383;0
WireConnection;350;2;382;0
WireConnection;344;1;303;0
WireConnection;344;6;316;0
WireConnection;158;0;130;0
WireConnection;158;1;179;0
WireConnection;158;2;150;0
WireConnection;434;0;429;0
WireConnection;434;1;432;0
WireConnection;388;0;287;0
WireConnection;130;0;167;0
WireConnection;130;1;175;0
WireConnection;386;0;362;0
WireConnection;566;0;564;0
WireConnection;304;0;247;0
WireConnection;304;1;251;0
WireConnection;304;2;355;0
WireConnection;261;82;250;0
WireConnection;261;5;255;0
WireConnection;218;1;386;0
WireConnection;218;6;352;0
WireConnection;296;0;350;0
WireConnection;190;0;184;0
WireConnection;190;1;191;0
WireConnection;206;0;134;0
WireConnection;196;0;189;0
WireConnection;196;1;193;0
WireConnection;196;2;375;0
WireConnection;195;1;213;0
WireConnection;195;6;212;0
WireConnection;479;0;594;0
WireConnection;222;0;189;0
WireConnection;222;1;375;0
WireConnection;606;0;605;0
WireConnection;608;0;423;0
WireConnection;229;0;248;0
WireConnection;229;1;275;0
WireConnection;157;0;170;0
WireConnection;157;1;142;0
WireConnection;157;2;168;0
WireConnection;478;0;593;0
WireConnection;180;0;159;0
WireConnection;488;0;559;0
WireConnection;170;0;128;0
WireConnection;142;0;162;0
WireConnection;142;1;128;0
WireConnection;362;0;157;0
WireConnection;362;2;180;0
WireConnection;197;0;365;0
WireConnection;140;0;413;0
WireConnection;340;0;274;0
WireConnection;340;1;349;0
WireConnection;340;2;607;0
WireConnection;282;0;340;0
WireConnection;282;1;294;0
WireConnection;282;2;609;0
WireConnection;286;0;282;0
WireConnection;286;1;280;0
WireConnection;286;2;611;0
WireConnection;610;0;281;0
WireConnection;477;0;592;0
WireConnection;410;0;332;0
WireConnection;586;0;7;3
WireConnection;417;0;392;0
WireConnection;417;1;319;0
WireConnection;563;0;590;0
WireConnection;365;0;218;1
WireConnection;365;1;363;1
WireConnection;359;0;157;0
WireConnection;359;2;159;0
WireConnection;162;0;176;0
WireConnection;411;0;169;0
WireConnection;414;0;411;0
WireConnection;414;1;412;0
WireConnection;289;0;229;0
WireConnection;413;0;414;0
WireConnection;413;1;358;0
WireConnection;395;0;262;0
WireConnection;395;1;385;0
WireConnection;601;0;397;0
WireConnection;601;1;600;0
WireConnection;601;2;602;0
WireConnection;332;0;395;0
WireConnection;332;1;601;0
WireConnection;382;0;206;0
WireConnection;382;1;154;0
WireConnection;184;0;224;0
WireConnection;184;1;135;0
WireConnection;217;0;149;0
WireConnection;338;0;341;0
WireConnection;255;0;151;0
WireConnection;137;0;211;0
WireConnection;431;0;434;0
WireConnection;177;1;50;0
WireConnection;177;6;172;0
WireConnection;429;0;408;0
WireConnection;429;1;406;0
WireConnection;251;0;226;0
WireConnection;251;1;375;0
WireConnection;164;0;396;0
WireConnection;256;0;164;0
WireConnection;167;0;163;0
WireConnection;435;0;425;0
WireConnection;435;1;421;0
WireConnection;331;0;341;0
WireConnection;331;1;314;0
WireConnection;155;1;50;0
WireConnection;155;6;241;0
WireConnection;171;1;50;0
WireConnection;171;6;268;0
WireConnection;682;1;680;0
WireConnection;682;6;678;0
WireConnection;559;1;563;0
WireConnection;559;6;595;0
WireConnection;592;1;563;0
WireConnection;592;6;596;0
WireConnection;644;0;640;0
WireConnection;694;0;624;3
WireConnection;693;0;624;2
WireConnection;632;0;642;0
WireConnection;632;1;690;0
WireConnection;632;2;624;1
WireConnection;640;0;635;0
WireConnection;640;1;692;0
WireConnection;640;2;694;0
WireConnection;635;0;632;0
WireConnection;635;1;691;0
WireConnection;635;2;693;0
WireConnection;684;1;680;0
WireConnection;684;6;676;0
WireConnection;683;1;680;0
WireConnection;683;6;677;0
WireConnection;325;0;320;0
WireConnection;249;82;254;0
WireConnection;249;5;244;0
WireConnection;363;1;359;0
WireConnection;363;6;371;0
WireConnection;339;0;206;0
WireConnection;339;1;154;0
WireConnection;339;2;216;0
WireConnection;317;0;339;0
WireConnection;287;0;330;0
WireConnection;287;1;312;0
WireConnection;287;2;160;0
WireConnection;418;0;431;0
WireConnection;418;1;434;0
WireConnection;427;0;420;0
WireConnection;427;1;421;0
WireConnection;360;0;317;0
WireConnection;360;1;344;0
WireConnection;277;0;372;0
WireConnection;277;1;305;0
WireConnection;383;0;305;0
WireConnection;275;0;276;0
WireConnection;312;0;338;0
WireConnection;312;1;331;0
WireConnection;351;0;304;0
WireConnection;320;1;261;0
WireConnection;320;0;329;0
WireConnection;247;0;211;0
WireConnection;247;1;222;0
WireConnection;247;2;240;0
WireConnection;224;0;288;0
WireConnection;224;1;318;0
WireConnection;314;6;299;0
WireConnection;341;0;292;0
WireConnection;341;1;220;0
WireConnection;213;0;364;0
WireConnection;213;1;231;0
WireConnection;179;0;130;0
WireConnection;179;1;132;0
WireConnection;179;2;127;0
WireConnection;179;3;146;0
WireConnection;179;5;208;0
WireConnection;264;0;389;0
WireConnection;264;1;256;0
WireConnection;240;0;137;0
WireConnection;594;1;563;0
WireConnection;594;6;598;0
WireConnection;244;0;124;0
WireConnection;276;0;417;0
WireConnection;276;1;321;0
WireConnection;593;1;563;0
WireConnection;593;6;597;0
WireConnection;428;0;418;0
WireConnection;568;0;286;0
WireConnection;292;1;217;0
WireConnection;292;6;138;0
WireConnection;290;0;295;0
WireConnection;290;1;393;0
WireConnection;374;0;325;0
WireConnection;269;0;298;0
WireConnection;269;1;328;0
WireConnection;319;0;401;0
WireConnection;319;1;290;0
WireConnection;406;0;416;0
WireConnection;406;1;435;0
WireConnection;406;2;427;0
WireConnection;424;0;430;0
WireConnection;424;1;426;0
WireConnection;193;0;232;0
WireConnection;193;1;375;0
WireConnection;216;0;154;0
WireConnection;216;1;178;0
WireConnection;433;0;431;0
WireConnection;211;0;196;0
WireConnection;211;1;195;0
WireConnection;408;0;424;0
WireConnection;617;158;618;0
WireConnection;617;183;619;0
WireConnection;617;80;620;0
WireConnection;617;104;621;0
WireConnection;392;0;293;0
WireConnection;392;1;264;0
WireConnection;322;0;306;0
WireConnection;381;1;158;0
WireConnection;381;6;156;0
WireConnection;305;0;382;0
WireConnection;305;1;360;0
WireConnection;324;0;322;0
WireConnection;403;0;381;1
WireConnection;420;0;425;0
WireConnection;420;1;422;0
WireConnection;288;0;403;0
WireConnection;288;1;373;0
WireConnection;202;0;190;0
WireConnection;326;0;267;0
WireConnection;326;1;269;0
WireConnection;326;2;266;0
WireConnection;336;82;239;0
WireConnection;336;80;145;0
WireConnection;336;104;258;0
WireConnection;379;0;366;0
WireConnection;235;0;228;0
WireConnection;370;0;379;0
WireConnection;186;1;235;0
WireConnection;186;6;131;0
WireConnection;263;0;323;0
WireConnection;263;1;334;0
WireConnection;263;2;326;0
WireConnection;198;0;230;0
WireConnection;243;0;238;0
WireConnection;323;0;315;0
WireConnection;238;0;215;0
WireConnection;238;1;186;0
WireConnection;230;0;368;0
WireConnection;230;1;370;0
WireConnection;298;0;310;0
WireConnection;310;0;243;0
WireConnection;334;0;315;0
WireConnection;585;0;7;2
WireConnection;315;0;369;0
WireConnection;315;1;342;0
WireConnection;215;0;198;0
WireConnection;215;1;194;0
WireConnection;215;2;199;0
WireConnection;187;0;246;0
WireConnection;384;0;263;0
WireConnection;291;0;301;0
WireConnection;291;1;259;0
WireConnection;300;0;387;0
WireConnection;300;1;407;0
WireConnection;369;0;419;0
WireConnection;407;0;291;0
WireConnection;415;0;300;0
WireConnection;415;1;405;0
WireConnection;246;0;300;0
WireConnection;246;1;415;0
WireConnection;246;2;409;0
WireConnection;565;0;573;0
WireConnection;565;1;489;0
WireConnection;565;2;567;0
WireConnection;225;0;155;0
WireConnection;599;0;171;0
WireConnection;265;0;171;4
WireConnection;139;0;177;0
WireConnection;133;0;74;0
WireConnection;74;1;50;0
WireConnection;74;6;71;0
WireConnection;221;6;307;0
WireConnection;271;6;283;0
WireConnection;306;1;249;0
WireConnection;306;0;311;0
WireConnection;569;0;574;0
WireConnection;569;1;570;0
WireConnection;569;2;571;0
WireConnection;11;0;565;0
WireConnection;11;1;569;0
WireConnection;11;2;7;1
WireConnection;347;6;200;0
WireConnection;253;0;285;0
WireConnection;253;1;297;0
WireConnection;285;1;336;0
WireConnection;285;0;377;0
WireConnection;252;0;335;0
WireConnection;191;0;335;0
WireConnection;191;1;252;0
WireConnection;191;2;615;0
WireConnection;335;0;399;0
WireConnection;335;1;617;0
WireConnection;614;0;613;0
WireConnection;135;0;253;0
WireConnection;430;0;356;0
WireConnection;430;1;425;0
WireConnection;430;2;420;0
WireConnection;654;1;650;0
WireConnection;654;6;649;0
WireConnection;14;0;11;0
WireConnection;14;1;576;0
WireConnection;14;2;585;0
WireConnection;580;0;583;0
WireConnection;580;1;584;0
WireConnection;580;2;581;0
WireConnection;688;0;684;0
WireConnection;689;0;684;4
WireConnection;685;0;681;0
WireConnection;659;0;654;0
WireConnection;667;1;665;0
WireConnection;667;6;661;0
WireConnection;666;1;665;0
WireConnection;666;6;662;0
WireConnection;668;1;665;0
WireConnection;668;6;663;0
WireConnection;652;1;650;0
WireConnection;652;6;646;0
WireConnection;658;0;653;0
WireConnection;655;0;651;0
WireConnection;656;0;652;0
WireConnection;657;0;652;4
WireConnection;669;1;665;0
WireConnection;669;6;664;0
WireConnection;687;0;683;0
WireConnection;686;0;682;0
WireConnection;653;1;650;0
WireConnection;653;6;648;0
WireConnection;622;0;495;0
WireConnection;284;6;278;0
WireConnection;576;0;579;0
WireConnection;576;1;578;0
WireConnection;576;2;577;0
WireConnection;651;1;650;0
WireConnection;651;6;647;0
WireConnection;674;0;669;0
WireConnection;670;0;666;0
WireConnection;671;0;667;0
WireConnection;672;0;667;4
WireConnection;681;1;680;0
WireConnection;681;6;679;0
WireConnection;495;0;14;0
WireConnection;495;1;580;0
WireConnection;495;2;586;0
WireConnection;673;0;668;0
WireConnection;2;2;644;0
ASEEND*/
//CHKSM=BAC82ACB156C1DCF8498981E5E753C7136935053
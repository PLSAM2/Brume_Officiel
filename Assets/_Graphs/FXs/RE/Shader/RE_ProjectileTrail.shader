// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RE_ProjectileTrail"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin]_MainTrail("MainTrail", 2D) = "white" {}
		_MainTrail_Noise("MainTrail_Noise", 2D) = "white" {}
		_MainTrail_Noise_Speed("MainTrail_Noise_Speed", Float) = 0.5
		_MainTrail_Noise_Tiling("MainTrail_Noise_Tiling", Float) = 1
		_Shape_Noise_Contrast("Shape_Noise_Contrast", Float) = 1
		_MainTrail_Noise_Contrast("MainTrail_Noise_Contrast", Float) = 1
		_Shape_Noise_Add("Shape_Noise_Add", Float) = 0.88
		_MainTrail_Noise_Add("MainTrail_Noise_Add", Float) = 0.84
		_MainTrail_TilingUV("MainTrail_TilingUV", Float) = 1
		_MainTrail_TexturePanner("MainTrail_TexturePanner", Vector) = (1,0,0,0)
		_Float7("Float 7", Float) = 0
		_MainTrail_Offset("MainTrail_Offset", Vector) = (0,0,0,0)
		_Opacity_Noise("Opacity_Noise", 2D) = "white" {}
		_Opacity_Noise_Tiling("Opacity_Noise_Tiling", Float) = 0.84
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample4("Texture Sample 4", 2D) = "white" {}
		_AnisotropicNoise_Tiling("AnisotropicNoise_Tiling", Float) = 1
		_AnisotropicNoise_Step("AnisotropicNoise_Step", Float) = 0.17
		_AnisotropicNoise_Smoothstep("AnisotropicNoise_Smoothstep", Float) = 0.01
		_Float6("Float 6", Float) = 2
		_AnisotropicNoise_Panner("AnisotropicNoise_Panner", Vector) = (0.1,0,0,0)
		_AnisotropicNoise_Mask_Contrast("AnisotropicNoise_Mask_Contrast", Float) = -0.7
		_Float2("Float 2", Float) = 0.1
		_Float1("Float 1", Float) = 1
		_Float3("Float 3", Float) = 0.13
		_ReTrailMask("ReTrailMask", 2D) = "white" {}
		[ASEEnd]_WaveSpeed("WaveSpeed", Float) = 4

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
			float2 _MainTrail_Offset;
			float2 _MainTrail_TexturePanner;
			float2 _AnisotropicNoise_Panner;
			float _Opacity_Noise_Tiling;
			float _AnisotropicNoise_Mask_Contrast;
			float _AnisotropicNoise_Smoothstep;
			float _AnisotropicNoise_Step;
			float _MainTrail_Noise_Add;
			float _MainTrail_Noise_Speed;
			float _MainTrail_Noise_Tiling;
			float _MainTrail_Noise_Contrast;
			float _Float7;
			float _Shape_Noise_Contrast;
			float _Float1;
			float _WaveSpeed;
			float _Float3;
			float _Float2;
			float _MainTrail_TilingUV;
			float _Float6;
			float _Shape_Noise_Add;
			float _AnisotropicNoise_Tiling;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _TextureSample1;
			sampler2D _MainTrail;
			sampler2D _ReTrailMask;
			sampler2D _MainTrail_Noise;
			sampler2D _Opacity_Noise;
			sampler2D _TextureSample4;


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
				float2 temp_cast_0 = (_Float6).xx;
				float2 texCoord235 = IN.ase_texcoord3.xy * temp_cast_0 + float2( 0,0 );
				float4 temp_cast_1 = (( tex2D( _TextureSample1, texCoord235 ).r + -0.36 )).xxxx;
				float clampResult234 = clamp( CalculateContrast(_Float7,temp_cast_1).r , 0.0 , 1.0 );
				float Color167 = clampResult234;
				float2 temp_cast_2 = (_MainTrail_TilingUV).xx;
				float2 texCoord76 = IN.ase_texcoord3.xy * temp_cast_2 + float2( 0,0 );
				float2 panner83 = ( 1.0 * _Time.y * _MainTrail_TexturePanner + texCoord76);
				float4 tex2DNode57 = tex2D( _MainTrail, panner83 );
				float ColorMask165 = tex2DNode57.r;
				float3 temp_cast_3 = (( Color167 * ColorMask165 )).xxx;
				
				float mulTime213 = _TimeParameters.x * _WaveSpeed;
				float lerpResult206 = lerp( _Float2 , _Float3 , cos( mulTime213 ));
				float2 texCoord209 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_cast_4 = (0.5).xx;
				float2 texCoord220 = IN.ase_texcoord3.xy * temp_cast_4 + float2( 0,0 );
				float2 panner221 = ( 1.0 * _Time.y * float2( 0.5,0 ) + texCoord220);
				float2 texCoord215 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult200 = smoothstep( lerpResult206 , ( lerpResult206 + _Float1 ) , ( texCoord209.x * tex2D( _ReTrailMask, ( saturate( ( CalculateContrast(_Shape_Noise_Contrast,tex2D( _MainTrail_Noise, panner221 )) + _Shape_Noise_Add ) ) * float4( texCoord215, 0.0 , 0.0 ) ).rg ).r ));
				float2 temp_cast_8 = (_MainTrail_Noise_Tiling).xx;
				float2 appendResult67 = (float2(_MainTrail_Noise_Speed , 0.0));
				float2 panner68 = ( 1.0 * _Time.y * appendResult67 + float2( 0,0 ));
				float2 texCoord69 = IN.ase_texcoord3.xy * temp_cast_8 + panner68;
				float2 temp_cast_9 = (( _MainTrail_Noise_Tiling / 2.0 )).xx;
				float2 texCoord126 = IN.ase_texcoord3.xy * temp_cast_9 + float2( 0,0 );
				float blendOpSrc129 = tex2D( _MainTrail_Noise, texCoord69 ).r;
				float blendOpDest129 = tex2D( _MainTrail_Noise, texCoord126 ).r;
				float4 temp_cast_10 = (( saturate( (( blendOpDest129 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest129 ) * ( 1.0 - blendOpSrc129 ) ) : ( 2.0 * blendOpDest129 * blendOpSrc129 ) ) ))).xxxx;
				float2 panner80 = ( 1.0 * _Time.y * _MainTrail_TexturePanner + ( float4( _MainTrail_Offset, 0.0 , 0.0 ) + ( saturate( ( CalculateContrast(_MainTrail_Noise_Contrast,temp_cast_10) + _MainTrail_Noise_Add ) ) * float4( texCoord76, 0.0 , 0.0 ) ) ).rg);
				float OpacityMask159 = ( tex2D( _MainTrail, panner80 ).r + tex2DNode57.r );
				float smoothstepResult63 = smoothstep( 0.0 , 0.13 , ( smoothstepResult200 * OpacityMask159 ));
				float2 temp_cast_13 = (_Opacity_Noise_Tiling).xx;
				float2 texCoord146 = IN.ase_texcoord3.xy * temp_cast_13 + float2( 0,0 );
				float2 panner147 = ( 1.0 * _Time.y * float2( 0.5,0 ) + texCoord146);
				float4 temp_cast_14 = (tex2D( _Opacity_Noise, panner147 ).r).xxxx;
				float2 temp_cast_15 = (_AnisotropicNoise_Tiling).xx;
				float2 texCoord178 = IN.ase_texcoord3.xy * temp_cast_15 + float2( 0,0 );
				float2 panner189 = ( 1.0 * _Time.y * _AnisotropicNoise_Panner + texCoord178);
				float smoothstepResult181 = smoothstep( _AnisotropicNoise_Step , ( _AnisotropicNoise_Step + _AnisotropicNoise_Smoothstep ) , ( CalculateContrast(_AnisotropicNoise_Mask_Contrast,temp_cast_14).r + tex2D( _TextureSample4, panner189 ).r ));
				float Opacity162 = ( smoothstepResult63 * ( 1.0 * smoothstepResult181 ) );
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = temp_cast_3;
				float Alpha = ( Opacity162 * IN.ase_color.a );
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float2 _MainTrail_Offset;
			float2 _MainTrail_TexturePanner;
			float2 _AnisotropicNoise_Panner;
			float _Opacity_Noise_Tiling;
			float _AnisotropicNoise_Mask_Contrast;
			float _AnisotropicNoise_Smoothstep;
			float _AnisotropicNoise_Step;
			float _MainTrail_Noise_Add;
			float _MainTrail_Noise_Speed;
			float _MainTrail_Noise_Tiling;
			float _MainTrail_Noise_Contrast;
			float _Float7;
			float _Shape_Noise_Contrast;
			float _Float1;
			float _WaveSpeed;
			float _Float3;
			float _Float2;
			float _MainTrail_TilingUV;
			float _Float6;
			float _Shape_Noise_Add;
			float _AnisotropicNoise_Tiling;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _ReTrailMask;
			sampler2D _MainTrail_Noise;
			sampler2D _MainTrail;
			sampler2D _Opacity_Noise;
			sampler2D _TextureSample4;


			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
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

				float mulTime213 = _TimeParameters.x * _WaveSpeed;
				float lerpResult206 = lerp( _Float2 , _Float3 , cos( mulTime213 ));
				float2 texCoord209 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_cast_0 = (0.5).xx;
				float2 texCoord220 = IN.ase_texcoord2.xy * temp_cast_0 + float2( 0,0 );
				float2 panner221 = ( 1.0 * _Time.y * float2( 0.5,0 ) + texCoord220);
				float2 texCoord215 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult200 = smoothstep( lerpResult206 , ( lerpResult206 + _Float1 ) , ( texCoord209.x * tex2D( _ReTrailMask, ( saturate( ( CalculateContrast(_Shape_Noise_Contrast,tex2D( _MainTrail_Noise, panner221 )) + _Shape_Noise_Add ) ) * float4( texCoord215, 0.0 , 0.0 ) ).rg ).r ));
				float2 temp_cast_4 = (_MainTrail_Noise_Tiling).xx;
				float2 appendResult67 = (float2(_MainTrail_Noise_Speed , 0.0));
				float2 panner68 = ( 1.0 * _Time.y * appendResult67 + float2( 0,0 ));
				float2 texCoord69 = IN.ase_texcoord2.xy * temp_cast_4 + panner68;
				float2 temp_cast_5 = (( _MainTrail_Noise_Tiling / 2.0 )).xx;
				float2 texCoord126 = IN.ase_texcoord2.xy * temp_cast_5 + float2( 0,0 );
				float blendOpSrc129 = tex2D( _MainTrail_Noise, texCoord69 ).r;
				float blendOpDest129 = tex2D( _MainTrail_Noise, texCoord126 ).r;
				float4 temp_cast_6 = (( saturate( (( blendOpDest129 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest129 ) * ( 1.0 - blendOpSrc129 ) ) : ( 2.0 * blendOpDest129 * blendOpSrc129 ) ) ))).xxxx;
				float2 temp_cast_7 = (_MainTrail_TilingUV).xx;
				float2 texCoord76 = IN.ase_texcoord2.xy * temp_cast_7 + float2( 0,0 );
				float2 panner80 = ( 1.0 * _Time.y * _MainTrail_TexturePanner + ( float4( _MainTrail_Offset, 0.0 , 0.0 ) + ( saturate( ( CalculateContrast(_MainTrail_Noise_Contrast,temp_cast_6) + _MainTrail_Noise_Add ) ) * float4( texCoord76, 0.0 , 0.0 ) ) ).rg);
				float2 panner83 = ( 1.0 * _Time.y * _MainTrail_TexturePanner + texCoord76);
				float4 tex2DNode57 = tex2D( _MainTrail, panner83 );
				float OpacityMask159 = ( tex2D( _MainTrail, panner80 ).r + tex2DNode57.r );
				float smoothstepResult63 = smoothstep( 0.0 , 0.13 , ( smoothstepResult200 * OpacityMask159 ));
				float2 temp_cast_10 = (_Opacity_Noise_Tiling).xx;
				float2 texCoord146 = IN.ase_texcoord2.xy * temp_cast_10 + float2( 0,0 );
				float2 panner147 = ( 1.0 * _Time.y * float2( 0.5,0 ) + texCoord146);
				float4 temp_cast_11 = (tex2D( _Opacity_Noise, panner147 ).r).xxxx;
				float2 temp_cast_12 = (_AnisotropicNoise_Tiling).xx;
				float2 texCoord178 = IN.ase_texcoord2.xy * temp_cast_12 + float2( 0,0 );
				float2 panner189 = ( 1.0 * _Time.y * _AnisotropicNoise_Panner + texCoord178);
				float smoothstepResult181 = smoothstep( _AnisotropicNoise_Step , ( _AnisotropicNoise_Step + _AnisotropicNoise_Smoothstep ) , ( CalculateContrast(_AnisotropicNoise_Mask_Contrast,temp_cast_11).r + tex2D( _TextureSample4, panner189 ).r ));
				float Opacity162 = ( smoothstepResult63 * ( 1.0 * smoothstepResult181 ) );
				
				float Alpha = ( Opacity162 * IN.ase_color.a );
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
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float2 _MainTrail_Offset;
			float2 _MainTrail_TexturePanner;
			float2 _AnisotropicNoise_Panner;
			float _Opacity_Noise_Tiling;
			float _AnisotropicNoise_Mask_Contrast;
			float _AnisotropicNoise_Smoothstep;
			float _AnisotropicNoise_Step;
			float _MainTrail_Noise_Add;
			float _MainTrail_Noise_Speed;
			float _MainTrail_Noise_Tiling;
			float _MainTrail_Noise_Contrast;
			float _Float7;
			float _Shape_Noise_Contrast;
			float _Float1;
			float _WaveSpeed;
			float _Float3;
			float _Float2;
			float _MainTrail_TilingUV;
			float _Float6;
			float _Shape_Noise_Add;
			float _AnisotropicNoise_Tiling;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _ReTrailMask;
			sampler2D _MainTrail_Noise;
			sampler2D _MainTrail;
			sampler2D _Opacity_Noise;
			sampler2D _TextureSample4;


			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
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

				float mulTime213 = _TimeParameters.x * _WaveSpeed;
				float lerpResult206 = lerp( _Float2 , _Float3 , cos( mulTime213 ));
				float2 texCoord209 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_cast_0 = (0.5).xx;
				float2 texCoord220 = IN.ase_texcoord2.xy * temp_cast_0 + float2( 0,0 );
				float2 panner221 = ( 1.0 * _Time.y * float2( 0.5,0 ) + texCoord220);
				float2 texCoord215 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult200 = smoothstep( lerpResult206 , ( lerpResult206 + _Float1 ) , ( texCoord209.x * tex2D( _ReTrailMask, ( saturate( ( CalculateContrast(_Shape_Noise_Contrast,tex2D( _MainTrail_Noise, panner221 )) + _Shape_Noise_Add ) ) * float4( texCoord215, 0.0 , 0.0 ) ).rg ).r ));
				float2 temp_cast_4 = (_MainTrail_Noise_Tiling).xx;
				float2 appendResult67 = (float2(_MainTrail_Noise_Speed , 0.0));
				float2 panner68 = ( 1.0 * _Time.y * appendResult67 + float2( 0,0 ));
				float2 texCoord69 = IN.ase_texcoord2.xy * temp_cast_4 + panner68;
				float2 temp_cast_5 = (( _MainTrail_Noise_Tiling / 2.0 )).xx;
				float2 texCoord126 = IN.ase_texcoord2.xy * temp_cast_5 + float2( 0,0 );
				float blendOpSrc129 = tex2D( _MainTrail_Noise, texCoord69 ).r;
				float blendOpDest129 = tex2D( _MainTrail_Noise, texCoord126 ).r;
				float4 temp_cast_6 = (( saturate( (( blendOpDest129 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest129 ) * ( 1.0 - blendOpSrc129 ) ) : ( 2.0 * blendOpDest129 * blendOpSrc129 ) ) ))).xxxx;
				float2 temp_cast_7 = (_MainTrail_TilingUV).xx;
				float2 texCoord76 = IN.ase_texcoord2.xy * temp_cast_7 + float2( 0,0 );
				float2 panner80 = ( 1.0 * _Time.y * _MainTrail_TexturePanner + ( float4( _MainTrail_Offset, 0.0 , 0.0 ) + ( saturate( ( CalculateContrast(_MainTrail_Noise_Contrast,temp_cast_6) + _MainTrail_Noise_Add ) ) * float4( texCoord76, 0.0 , 0.0 ) ) ).rg);
				float2 panner83 = ( 1.0 * _Time.y * _MainTrail_TexturePanner + texCoord76);
				float4 tex2DNode57 = tex2D( _MainTrail, panner83 );
				float OpacityMask159 = ( tex2D( _MainTrail, panner80 ).r + tex2DNode57.r );
				float smoothstepResult63 = smoothstep( 0.0 , 0.13 , ( smoothstepResult200 * OpacityMask159 ));
				float2 temp_cast_10 = (_Opacity_Noise_Tiling).xx;
				float2 texCoord146 = IN.ase_texcoord2.xy * temp_cast_10 + float2( 0,0 );
				float2 panner147 = ( 1.0 * _Time.y * float2( 0.5,0 ) + texCoord146);
				float4 temp_cast_11 = (tex2D( _Opacity_Noise, panner147 ).r).xxxx;
				float2 temp_cast_12 = (_AnisotropicNoise_Tiling).xx;
				float2 texCoord178 = IN.ase_texcoord2.xy * temp_cast_12 + float2( 0,0 );
				float2 panner189 = ( 1.0 * _Time.y * _AnisotropicNoise_Panner + texCoord178);
				float smoothstepResult181 = smoothstep( _AnisotropicNoise_Step , ( _AnisotropicNoise_Step + _AnisotropicNoise_Smoothstep ) , ( CalculateContrast(_AnisotropicNoise_Mask_Contrast,temp_cast_11).r + tex2D( _TextureSample4, panner189 ).r ));
				float Opacity162 = ( smoothstepResult63 * ( 1.0 * smoothstepResult181 ) );
				
				float Alpha = ( Opacity162 * IN.ase_color.a );
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
1920;0;1920;1019;6123.024;2136.415;4.964659;True;False
Node;AmplifyShaderEditor.RangedFloatNode;66;-4439.271,129.014;Inherit;False;Property;_MainTrail_Noise_Speed;MainTrail_Noise_Speed;2;0;Create;True;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;-3999.981,-62.73874;Inherit;False;Property;_MainTrail_Noise_Tiling;MainTrail_Noise_Tiling;3;0;Create;True;0;0;False;0;False;1;0.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;67;-4163.984,133.87;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;127;-3702.192,127.258;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;68;-3991.011,97.64;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;69;-3517.709,-79.45895;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;126;-3511.192,129.258;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;124;-3275.628,100.8519;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;70;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;70;-3281.891,-107.4489;Inherit;True;Property;_MainTrail_Noise;MainTrail_Noise;1;0;Create;True;0;0;False;0;False;-1;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;222;-4928.153,1655.103;Inherit;False;Constant;_Float0;Float 0;24;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;105;-2615.655,194.2872;Inherit;False;Property;_MainTrail_Noise_Contrast;MainTrail_Noise_Contrast;5;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;129;-2880.096,-3.784325;Inherit;True;Overlay;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;220;-4724.153,1637.103;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;104;-2358.823,69.41577;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-2315.701,199.8613;Inherit;False;Property;_MainTrail_Noise_Add;MainTrail_Noise_Add;7;0;Create;True;0;0;False;0;False;0.84;0.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;227;-4655.988,1842.229;Inherit;False;Constant;_Vector1;Vector 1;26;0;Create;True;0;0;False;0;False;0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;221;-4466.153,1766.103;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-2173.184,603.375;Inherit;False;Property;_MainTrail_TilingUV;MainTrail_TilingUV;8;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;75;-2056.701,67.86078;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.6698113;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;217;-4249.61,1737.122;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;70;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;223;-4171.674,1980.14;Inherit;False;Property;_Shape_Noise_Contrast;Shape_Noise_Contrast;4;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;76;-1862.151,554.2;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;77;-1740.089,114.4518;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-3102.685,3065.226;Inherit;False;Property;_Opacity_Noise_Tiling;Opacity_Noise_Tiling;13;0;Create;True;0;0;False;0;False;0.84;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-3871.719,1985.714;Inherit;False;Property;_Shape_Noise_Add;Shape_Noise_Add;6;0;Create;True;0;0;False;0;False;0.88;0.88;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-1549.036,113.6358;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;95;-1636.161,-91.23935;Inherit;False;Property;_MainTrail_Offset;MainTrail_Offset;11;0;Create;True;0;0;False;0;False;0,0;-0.5,0.07;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleContrastOpNode;224;-3914.841,1855.268;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;-3612.719,1853.713;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.6698113;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1192.138,-89.2456;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;82;-1291.109,742.8208;Inherit;False;Property;_MainTrail_TexturePanner;MainTrail_TexturePanner;9;0;Create;True;0;0;False;0;False;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;148;-2828.684,3207.612;Inherit;False;Constant;_Vector0;Vector 0;24;0;Create;True;0;0;False;0;False;0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;212;-3070.401,2694.41;Inherit;False;Property;_WaveSpeed;WaveSpeed;26;0;Create;True;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;146;-2887.643,3053.306;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;182;-2628.48,3533.045;Inherit;False;Property;_AnisotropicNoise_Tiling;AnisotropicNoise_Tiling;16;0;Create;True;0;0;False;0;False;1;0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;213;-2911.401,2699.41;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;83;-923.0696,519.7759;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;228;-3407.49,1852.929;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;80;-950.0361,114.1175;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;147;-2611.333,3150.487;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;215;-3557.042,2204.294;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CosOpNode;214;-2731.401,2698.41;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;190;-2391.108,3679.273;Inherit;False;Property;_AnisotropicNoise_Panner;AnisotropicNoise_Panner;20;0;Create;True;0;0;False;0;False;0.1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;57;-400.8346,511.0363;Inherit;True;Property;_MainTrail;MainTrail;0;0;Create;True;0;0;False;0;False;-1;0e13668642319b64f94265677a93d4b4;0e13668642319b64f94265677a93d4b4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;197;-2064.387,3277.526;Inherit;False;Property;_AnisotropicNoise_Mask_Contrast;AnisotropicNoise_Mask_Contrast;21;0;Create;True;0;0;False;0;False;-0.7;-0.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;218;-3204.418,2070.198;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;178;-2362.481,3513.045;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;208;-2968.635,2382.823;Inherit;False;Property;_Float3;Float 3;24;0;Create;True;0;0;False;0;False;0.13;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;65;-441.7704,81.54839;Inherit;True;Property;_TextureSample5;Texture Sample 5;0;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;57;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;207;-2970.635,2306.823;Inherit;False;Property;_Float2;Float 2;22;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;142;-2313.772,3061.246;Inherit;True;Property;_Opacity_Noise;Opacity_Noise;12;0;Create;True;0;0;False;0;False;-1;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;206;-2757.635,2357.823;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;189;-2115.752,3622.148;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;203;-2534.521,2496.981;Inherit;False;Property;_Float1;Float 1;23;0;Create;True;0;0;False;0;False;1;0.48;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;209;-3236.21,1553.082;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;195;-1884.467,3134.073;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;84;-31.2769,110.8521;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;198;-2941.371,2042.19;Inherit;True;Property;_ReTrailMask;ReTrailMask;25;0;Create;True;0;0;False;0;False;-1;f2482fed0c267f9458993ae0a852d4e8;f2482fed0c267f9458993ae0a852d4e8;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;196;-1704.541,3134.074;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;184;-1876.52,3796.089;Inherit;False;Property;_AnisotropicNoise_Smoothstep;AnisotropicNoise_Smoothstep;18;0;Create;True;0;0;False;0;False;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;204;-2305.972,2449.384;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;176;-1830.222,3698.507;Inherit;False;Property;_AnisotropicNoise_Step;AnisotropicNoise_Step;17;0;Create;True;0;0;False;0;False;0.17;0.23;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;174;-1903.571,3481.78;Inherit;True;Property;_TextureSample4;Texture Sample 4;15;0;Create;True;0;0;False;0;False;-1;b7b6180d660771e4ca7b20e22b7a8c51;b7b6180d660771e4ca7b20e22b7a8c51;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-2598.506,1947.899;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;224.3235,196.3842;Inherit;False;OpacityMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;200;-2069.521,2283.981;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;160;-2023.804,2518.641;Inherit;False;159;OpacityMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;175;-1520.037,3777.1;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;194;-1495.006,3236.862;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-1666.226,2693.668;Inherit;False;Constant;_Float5;Float 5;14;0;Create;True;0;0;False;0;False;0.13;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;181;-1298.519,3678.089;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-1659.226,2607.669;Inherit;False;Constant;_Float4;Float 4;14;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;199;-1683.736,2208.275;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-1034.25,3164.908;Inherit;True;2;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;63;-1351.826,2205.269;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;-937.6567,2166.963;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-666.3212,2215.329;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;173;966.1038,874.7394;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;163;963.8299,768.7919;Inherit;False;162;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;165;52.7117,617.3143;Inherit;False;ColorMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;169;947.9495,144.4982;Inherit;False;167;Color;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-632.9218,633.7742;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;168;942.3405,274.3908;Inherit;False;165;ColorMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;1179.104,830.7394;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;150;1178.361,206.3937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;232;-2194.826,-726.7021;Inherit;True;Property;_TextureSample1;Texture Sample 1;14;0;Create;True;0;0;False;0;False;-1;None;88d75bbfdb8a26849988713b4599646a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;231;-2658.826,-646.7023;Inherit;False;Property;_Float6;Float 6;19;0;Create;True;0;0;False;0;False;2;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-1477.034,-586.3204;Inherit;False;Property;_Float7;Float 7;10;0;Create;True;0;0;False;0;False;0;-0.72;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;236;-1099.826,-694.7023;Inherit;True;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;235;-2418.826,-694.7023;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;234;-898.8262,-694.7023;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;233;-1330.826,-694.7023;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-577.5723,-723.8425;Inherit;False;Color;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;238;-1762.827,-694.7023;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;-0.36;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1539.617,548.7143;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;RE_ProjectileTrail;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;1;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-519.2407,-200.4501;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.CommentaryNode;161;-4967.155,1214.859;Inherit;False;4727.625;3134.803;Opacity;0;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;170;-4489.271,-157.449;Inherit;False;4922.729;1075.25;Texture et UV;0;;1,1,1,1;0;0
WireConnection;67;0;66;0
WireConnection;127;0;103;0
WireConnection;68;2;67;0
WireConnection;69;0;103;0
WireConnection;69;1;68;0
WireConnection;126;0;127;0
WireConnection;124;1;126;0
WireConnection;70;1;69;0
WireConnection;129;0;70;1
WireConnection;129;1;124;1
WireConnection;220;0;222;0
WireConnection;104;1;129;0
WireConnection;104;0;105;0
WireConnection;221;0;220;0
WireConnection;221;2;227;0
WireConnection;75;0;104;0
WireConnection;75;1;73;0
WireConnection;217;1;221;0
WireConnection;76;0;74;0
WireConnection;77;0;75;0
WireConnection;79;0;77;0
WireConnection;79;1;76;0
WireConnection;224;1;217;0
WireConnection;224;0;223;0
WireConnection;226;0;224;0
WireConnection;226;1;225;0
WireConnection;90;0;95;0
WireConnection;90;1;79;0
WireConnection;146;0;149;0
WireConnection;213;0;212;0
WireConnection;83;0;76;0
WireConnection;83;2;82;0
WireConnection;228;0;226;0
WireConnection;80;0;90;0
WireConnection;80;2;82;0
WireConnection;147;0;146;0
WireConnection;147;2;148;0
WireConnection;214;0;213;0
WireConnection;57;1;83;0
WireConnection;218;0;228;0
WireConnection;218;1;215;0
WireConnection;178;0;182;0
WireConnection;65;1;80;0
WireConnection;142;1;147;0
WireConnection;206;0;207;0
WireConnection;206;1;208;0
WireConnection;206;2;214;0
WireConnection;189;0;178;0
WireConnection;189;2;190;0
WireConnection;195;1;142;1
WireConnection;195;0;197;0
WireConnection;84;0;65;1
WireConnection;84;1;57;1
WireConnection;198;1;218;0
WireConnection;196;0;195;0
WireConnection;204;0;206;0
WireConnection;204;1;203;0
WireConnection;174;1;189;0
WireConnection;210;0;209;1
WireConnection;210;1;198;1
WireConnection;159;0;84;0
WireConnection;200;0;210;0
WireConnection;200;1;206;0
WireConnection;200;2;204;0
WireConnection;175;0;176;0
WireConnection;175;1;184;0
WireConnection;194;0;196;0
WireConnection;194;1;174;1
WireConnection;181;0;194;0
WireConnection;181;1;176;0
WireConnection;181;2;175;0
WireConnection;199;0;200;0
WireConnection;199;1;160;0
WireConnection;188;1;181;0
WireConnection;63;0;199;0
WireConnection;63;1;62;0
WireConnection;63;2;64;0
WireConnection;137;0;63;0
WireConnection;137;1;188;0
WireConnection;162;0;137;0
WireConnection;165;0;57;1
WireConnection;187;0;83;0
WireConnection;171;0;163;0
WireConnection;171;1;173;4
WireConnection;150;0;169;0
WireConnection;150;1;168;0
WireConnection;232;1;235;0
WireConnection;236;0;233;0
WireConnection;235;0;231;0
WireConnection;234;0;236;0
WireConnection;233;1;238;0
WireConnection;233;0;237;0
WireConnection;167;0;234;0
WireConnection;238;0;232;1
WireConnection;1;2;150;0
WireConnection;1;3;171;0
ASEEND*/
//CHKSM=68BAE8D07828AD57B590AA572E2903A9FA7218EA
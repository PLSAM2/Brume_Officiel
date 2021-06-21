// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrumeVolume1"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin]_Alpha("Alpha", Range( 0 , 1)) = 0
		[Header(Textures)]_BrumeTexture("BrumeTexture", 2D) = "white" {}
		_BrumeTexture_Tiling("BrumeTexture_Tiling", Float) = 2
		_PerlinNoise_Texture("PerlinNoise_Texture", 2D) = "white" {}
		_PerlinNoise_Tiling("PerlinNoise_Tiling", Float) = 0.1
		_PerlinNoise_RotatorSpeed("PerlinNoise_RotatorSpeed", Float) = 0.05
		_PerlinNoise_PannerSpeed("PerlinNoise_PannerSpeed", Vector) = (0,0,0,0)
		_ColorVariationNoise_Texture("ColorVariationNoise_Texture", 2D) = "white" {}
		_ColorVariationNoise_Tiling("ColorVariationNoise_Tiling", Float) = 0.49
		_ColorVariationNoise_Contrast("ColorVariationNoise_Contrast", Float) = 1.35
		_ColorVariationNoise_RotatorSpeed("ColorVariationNoise_RotatorSpeed", Float) = 0.05
		[Header(Brume Color)]_BrumeColor_ColorLow1("BrumeColor_ColorLow1", Color) = (0.4,0.4470589,0.509804,1)
		_BrumeColor_ColorLow2("BrumeColor_ColorLow2", Color) = (0.4,0.4470589,0.509804,1)
		_BrumeColor_ColorHigh("BrumeColor_ColorHigh", Color) = (1,1,1,0)
		_BrumeColor_LightImpact("BrumeColor_LightImpact", Range( 0 , 1)) = 0
		[Header(Brume Animation)][Toggle(_ROTATORANIMATION_ON)] _RotatorAnimation("RotatorAnimation?", Float) = 0
		_BrumeAnimation_RotatorTime("BrumeAnimation_RotatorTime", Float) = 0.2
		_BrumeAnimation_WaveStrength("BrumeAnimation_WaveStrength", Float) = 0.15
		_BrumeAnimation_WaveFrequency("BrumeAnimation_WaveFrequency", Float) = 0.1
		_BrumeAnimation_PannerSpeed("BrumeAnimation_PannerSpeed", Vector) = (0.1,0,0,0)
		[Header(Depth Fade)]_DepthFade_Distance("DepthFade_Distance", Float) = 1
		_DepthFade_SmoothstepMin("DepthFade_SmoothstepMin", Float) = 0
		_DepthFade_SmoothstepMax("DepthFade_SmoothstepMax", Float) = 1
		_BrumeOpacity_DepthMax_Step("BrumeOpacity_DepthMax_Step", Float) = 0
		_BrumeOpacity_DepthMax_Smoothstep("BrumeOpacity_DepthMax_Smoothstep", Float) = 1
		[Header(Displacement)]_Displacement_Contrast("Displacement_Contrast", Float) = 0.41
		_WaveNoise_Contrast("WaveNoise_Contrast", Float) = 0
		_DisplacementTop_Step("DisplacementTop_Step", Float) = 0
		_DisplacementTop_Smoothstep("DisplacementTop_Smoothstep", Float) = 0
		[ASEEnd][Toggle(_DISPLACEMENT_TOP_MASK_ON)] _Displacement_Top_Mask("Displacement_Top_Mask", Float) = 0

		_TessPhongStrength( "Phong Tess Strength", Range( 0, 1 ) ) = 0.5
		_TessValue( "Max Tessellation", Range( 1, 32 ) ) = 16
		_TessMin( "Tess Min Distance", Float ) = 10
		_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
		
		Cull Off
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
			
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_DISTANCE_TESSELLATION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_DEPTH_TEXTURE 1

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
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _ROTATORANIMATION_ON
			#pragma shader_feature_local _DISPLACEMENT_TOP_MASK_ON
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT


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
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _BrumeColor_ColorLow1;
			float4 _BrumeColor_ColorHigh;
			float4 _BrumeColor_ColorLow2;
			float2 _BrumeAnimation_PannerSpeed;
			float2 _PerlinNoise_PannerSpeed;
			float _BrumeOpacity_DepthMax_Step;
			float _DepthFade_Distance;
			float _DepthFade_SmoothstepMax;
			float _DepthFade_SmoothstepMin;
			float _BrumeColor_LightImpact;
			float _ColorVariationNoise_RotatorSpeed;
			float _ColorVariationNoise_Tiling;
			float _ColorVariationNoise_Contrast;
			float _BrumeTexture_Tiling;
			float _Displacement_Contrast;
			float _DisplacementTop_Smoothstep;
			float _DisplacementTop_Step;
			float _PerlinNoise_RotatorSpeed;
			float _PerlinNoise_Tiling;
			float _WaveNoise_Contrast;
			float _BrumeAnimation_WaveStrength;
			float _BrumeAnimation_RotatorTime;
			float _BrumeAnimation_WaveFrequency;
			float _BrumeOpacity_DepthMax_Smoothstep;
			float _Alpha;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _BrumeTexture;
			sampler2D _PerlinNoise_Texture;
			sampler2D _ColorVariationNoise_Texture;
			uniform float4 _CameraDepthTexture_TexelSize;


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

				float2 temp_cast_0 = (_BrumeTexture_Tiling).xx;
				float2 texCoord322 = v.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float mulTime476 = _TimeParameters.x * _BrumeAnimation_RotatorTime;
				float temp_output_508_0 = ( ( ( _TimeParameters.y * _BrumeAnimation_WaveFrequency ) + mulTime476 ) * _BrumeAnimation_WaveStrength );
				float2 temp_cast_1 = (( _BrumeTexture_Tiling * 0.5 )).xx;
				float cos473 = cos( temp_output_508_0 );
				float sin473 = sin( temp_output_508_0 );
				float2 rotator473 = mul( texCoord322 - temp_cast_1 , float2x2( cos473 , -sin473 , sin473 , cos473 )) + temp_cast_1;
				float2 panner513 = ( temp_output_508_0 * _BrumeAnimation_PannerSpeed + rotator473);
				#ifdef _ROTATORANIMATION_ON
				float2 staticSwitch474 = panner513;
				#else
				float2 staticSwitch474 = texCoord322;
				#endif
				float2 UV323 = staticSwitch474;
				float4 BrumeTextureSample329 = tex2Dlod( _BrumeTexture, float4( UV323, 0, 0.0) );
				float2 temp_cast_2 = (_PerlinNoise_Tiling).xx;
				float2 temp_cast_3 = (( ( 1.0 - _PerlinNoise_Tiling ) / 2.0 )).xx;
				float2 texCoord340 = v.ase_texcoord.xy * temp_cast_2 + temp_cast_3;
				float cos367 = cos( ( _TimeParameters.x * _PerlinNoise_RotatorSpeed ) );
				float sin367 = sin( ( _TimeParameters.x * _PerlinNoise_RotatorSpeed ) );
				float2 rotator367 = mul( texCoord340 - float2( 0.5,0.5 ) , float2x2( cos367 , -sin367 , sin367 , cos367 )) + float2( 0.5,0.5 );
				float2 panner355 = ( ( _TimeParameters.x * 0.05 ) * _PerlinNoise_PannerSpeed + rotator367);
				float MovingPerlinNoise414 = tex2Dlod( _PerlinNoise_Texture, float4( panner355, 0, 0.0) ).r;
				float4 temp_cast_4 = (MovingPerlinNoise414).xxxx;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float smoothstepResult837 = smoothstep( _DisplacementTop_Step , _DisplacementTop_Smoothstep , ase_worldNormal.y);
				float clampResult833 = clamp( smoothstepResult837 , 0.0 , 1.0 );
				#ifdef _DISPLACEMENT_TOP_MASK_ON
				float staticSwitch848 = clampResult833;
				#else
				float staticSwitch848 = 1.0;
				#endif
				float3 BrumeDisplacement558 = ( ( ( BrumeTextureSample329 + ( CalculateContrast(_WaveNoise_Contrast,temp_cast_4) * staticSwitch848 ) ) * _Displacement_Contrast ).r * v.ase_normal );
				
				o.ase_texcoord4.xyz = ase_worldNormal;
				
				float3 vertexPos568 = ( v.vertex.xyz + BrumeDisplacement558 );
				float4 ase_clipPos568 = TransformObjectToHClip((vertexPos568).xyz);
				float4 screenPos568 = ComputeScreenPos(ase_clipPos568);
				o.ase_texcoord5 = screenPos568;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
				o.ase_texcoord4.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = BrumeDisplacement558;
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
				float2 temp_cast_0 = (_ColorVariationNoise_Tiling).xx;
				float2 texCoord768 = IN.ase_texcoord3.xy * temp_cast_0 + float2( 0,0 );
				float2 temp_cast_1 = (( _ColorVariationNoise_Tiling * 0.5 )).xx;
				float mulTime774 = _TimeParameters.x * _ColorVariationNoise_RotatorSpeed;
				float cos773 = cos( mulTime774 );
				float sin773 = sin( mulTime774 );
				float2 rotator773 = mul( texCoord768 - temp_cast_1 , float2x2( cos773 , -sin773 , sin773 , cos773 )) + temp_cast_1;
				float4 MovingPerlinNoise2854 = CalculateContrast(_ColorVariationNoise_Contrast,tex2D( _ColorVariationNoise_Texture, rotator773 ));
				float4 lerpResult853 = lerp( _BrumeColor_ColorLow1 , _BrumeColor_ColorLow2 , MovingPerlinNoise2854);
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float dotResult177 = dot( ase_worldNormal , _MainLightPosition.xyz );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float temp_output_179_0 = ( dotResult177 * ase_lightAtten );
				float2 temp_cast_2 = (_PerlinNoise_Tiling).xx;
				float2 temp_cast_3 = (( ( 1.0 - _PerlinNoise_Tiling ) / 2.0 )).xx;
				float2 texCoord340 = IN.ase_texcoord3.xy * temp_cast_2 + temp_cast_3;
				float cos367 = cos( ( _TimeParameters.x * _PerlinNoise_RotatorSpeed ) );
				float sin367 = sin( ( _TimeParameters.x * _PerlinNoise_RotatorSpeed ) );
				float2 rotator367 = mul( texCoord340 - float2( 0.5,0.5 ) , float2x2( cos367 , -sin367 , sin367 , cos367 )) + float2( 0.5,0.5 );
				float2 panner355 = ( ( _TimeParameters.x * 0.05 ) * _PerlinNoise_PannerSpeed + rotator367);
				float MovingPerlinNoise414 = tex2D( _PerlinNoise_Texture, panner355 ).r;
				float normal_LightDir180 = ( temp_output_179_0 + ( ( 1.0 - temp_output_179_0 ) * MovingPerlinNoise414 ) );
				float lerpResult449 = lerp( 1.0 , normal_LightDir180 , _BrumeColor_LightImpact);
				float2 temp_cast_4 = (_BrumeTexture_Tiling).xx;
				float2 texCoord322 = IN.ase_texcoord3.xy * temp_cast_4 + float2( 0,0 );
				float mulTime476 = _TimeParameters.x * _BrumeAnimation_RotatorTime;
				float temp_output_508_0 = ( ( ( _TimeParameters.y * _BrumeAnimation_WaveFrequency ) + mulTime476 ) * _BrumeAnimation_WaveStrength );
				float2 temp_cast_5 = (( _BrumeTexture_Tiling * 0.5 )).xx;
				float cos473 = cos( temp_output_508_0 );
				float sin473 = sin( temp_output_508_0 );
				float2 rotator473 = mul( texCoord322 - temp_cast_5 , float2x2( cos473 , -sin473 , sin473 , cos473 )) + temp_cast_5;
				float2 panner513 = ( temp_output_508_0 * _BrumeAnimation_PannerSpeed + rotator473);
				#ifdef _ROTATORANIMATION_ON
				float2 staticSwitch474 = panner513;
				#else
				float2 staticSwitch474 = texCoord322;
				#endif
				float2 UV323 = staticSwitch474;
				float4 BrumeTextureSample329 = tex2D( _BrumeTexture, UV323 );
				float4 lerpResult314 = lerp( lerpResult853 , _BrumeColor_ColorHigh , ( lerpResult449 * BrumeTextureSample329 ));
				float4 BrumeColor315 = lerpResult314;
				
				float4 screenPos568 = IN.ase_texcoord5;
				float4 ase_screenPosNorm568 = screenPos568 / screenPos568.w;
				ase_screenPosNorm568.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm568.z : ase_screenPosNorm568.z * 0.5 + 0.5;
				float screenDepth568 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm568.xy ),_ZBufferParams);
				float distanceDepth568 = abs( ( screenDepth568 - LinearEyeDepth( ase_screenPosNorm568.z,_ZBufferParams ) ) / ( _DepthFade_Distance ) );
				float smoothstepResult726 = smoothstep( _DepthFade_SmoothstepMin , _DepthFade_SmoothstepMax , distanceDepth568);
				float clampResult708 = clamp( smoothstepResult726 , 0.0 , 1.0 );
				float smoothstepResult866 = smoothstep( _BrumeOpacity_DepthMax_Step , _BrumeOpacity_DepthMax_Smoothstep , ( WorldPosition.y + 0.0 ));
				float DepthFade574 = ( clampResult708 * smoothstepResult866 );
				float lerpResult760 = lerp( 0.0 , DepthFade574 , _Alpha);
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = BrumeColor315.rgb;
				float Alpha = lerpResult760;
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
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM
			#pragma multi_compile_instancing
			#define TESSELLATION_ON 1
			#pragma require tessellation tessHW
			#pragma hull HullFunction
			#pragma domain DomainFunction
			#define ASE_PHONG_TESSELLATION
			#define ASE_DISTANCE_TESSELLATION
			#define ASE_SRP_VERSION 999999
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#pragma shader_feature_local _ROTATORANIMATION_ON
			#pragma shader_feature_local _DISPLACEMENT_TOP_MASK_ON


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
			float4 _BrumeColor_ColorLow1;
			float4 _BrumeColor_ColorHigh;
			float4 _BrumeColor_ColorLow2;
			float2 _BrumeAnimation_PannerSpeed;
			float2 _PerlinNoise_PannerSpeed;
			float _BrumeOpacity_DepthMax_Step;
			float _DepthFade_Distance;
			float _DepthFade_SmoothstepMax;
			float _DepthFade_SmoothstepMin;
			float _BrumeColor_LightImpact;
			float _ColorVariationNoise_RotatorSpeed;
			float _ColorVariationNoise_Tiling;
			float _ColorVariationNoise_Contrast;
			float _BrumeTexture_Tiling;
			float _Displacement_Contrast;
			float _DisplacementTop_Smoothstep;
			float _DisplacementTop_Step;
			float _PerlinNoise_RotatorSpeed;
			float _PerlinNoise_Tiling;
			float _WaveNoise_Contrast;
			float _BrumeAnimation_WaveStrength;
			float _BrumeAnimation_RotatorTime;
			float _BrumeAnimation_WaveFrequency;
			float _BrumeOpacity_DepthMax_Smoothstep;
			float _Alpha;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _BrumeTexture;
			sampler2D _PerlinNoise_Texture;
			uniform float4 _CameraDepthTexture_TexelSize;


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

				float2 temp_cast_0 = (_BrumeTexture_Tiling).xx;
				float2 texCoord322 = v.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float mulTime476 = _TimeParameters.x * _BrumeAnimation_RotatorTime;
				float temp_output_508_0 = ( ( ( _TimeParameters.y * _BrumeAnimation_WaveFrequency ) + mulTime476 ) * _BrumeAnimation_WaveStrength );
				float2 temp_cast_1 = (( _BrumeTexture_Tiling * 0.5 )).xx;
				float cos473 = cos( temp_output_508_0 );
				float sin473 = sin( temp_output_508_0 );
				float2 rotator473 = mul( texCoord322 - temp_cast_1 , float2x2( cos473 , -sin473 , sin473 , cos473 )) + temp_cast_1;
				float2 panner513 = ( temp_output_508_0 * _BrumeAnimation_PannerSpeed + rotator473);
				#ifdef _ROTATORANIMATION_ON
				float2 staticSwitch474 = panner513;
				#else
				float2 staticSwitch474 = texCoord322;
				#endif
				float2 UV323 = staticSwitch474;
				float4 BrumeTextureSample329 = tex2Dlod( _BrumeTexture, float4( UV323, 0, 0.0) );
				float2 temp_cast_2 = (_PerlinNoise_Tiling).xx;
				float2 temp_cast_3 = (( ( 1.0 - _PerlinNoise_Tiling ) / 2.0 )).xx;
				float2 texCoord340 = v.ase_texcoord.xy * temp_cast_2 + temp_cast_3;
				float cos367 = cos( ( _TimeParameters.x * _PerlinNoise_RotatorSpeed ) );
				float sin367 = sin( ( _TimeParameters.x * _PerlinNoise_RotatorSpeed ) );
				float2 rotator367 = mul( texCoord340 - float2( 0.5,0.5 ) , float2x2( cos367 , -sin367 , sin367 , cos367 )) + float2( 0.5,0.5 );
				float2 panner355 = ( ( _TimeParameters.x * 0.05 ) * _PerlinNoise_PannerSpeed + rotator367);
				float MovingPerlinNoise414 = tex2Dlod( _PerlinNoise_Texture, float4( panner355, 0, 0.0) ).r;
				float4 temp_cast_4 = (MovingPerlinNoise414).xxxx;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float smoothstepResult837 = smoothstep( _DisplacementTop_Step , _DisplacementTop_Smoothstep , ase_worldNormal.y);
				float clampResult833 = clamp( smoothstepResult837 , 0.0 , 1.0 );
				#ifdef _DISPLACEMENT_TOP_MASK_ON
				float staticSwitch848 = clampResult833;
				#else
				float staticSwitch848 = 1.0;
				#endif
				float3 BrumeDisplacement558 = ( ( ( BrumeTextureSample329 + ( CalculateContrast(_WaveNoise_Contrast,temp_cast_4) * staticSwitch848 ) ) * _Displacement_Contrast ).r * v.ase_normal );
				
				float3 vertexPos568 = ( v.vertex.xyz + BrumeDisplacement558 );
				float4 ase_clipPos568 = TransformObjectToHClip((vertexPos568).xyz);
				float4 screenPos568 = ComputeScreenPos(ase_clipPos568);
				o.ase_texcoord2 = screenPos568;
				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = BrumeDisplacement558;
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

				float4 screenPos568 = IN.ase_texcoord2;
				float4 ase_screenPosNorm568 = screenPos568 / screenPos568.w;
				ase_screenPosNorm568.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm568.z : ase_screenPosNorm568.z * 0.5 + 0.5;
				float screenDepth568 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm568.xy ),_ZBufferParams);
				float distanceDepth568 = abs( ( screenDepth568 - LinearEyeDepth( ase_screenPosNorm568.z,_ZBufferParams ) ) / ( _DepthFade_Distance ) );
				float smoothstepResult726 = smoothstep( _DepthFade_SmoothstepMin , _DepthFade_SmoothstepMax , distanceDepth568);
				float clampResult708 = clamp( smoothstepResult726 , 0.0 , 1.0 );
				float smoothstepResult866 = smoothstep( _BrumeOpacity_DepthMax_Step , _BrumeOpacity_DepthMax_Smoothstep , ( WorldPosition.y + 0.0 ));
				float DepthFade574 = ( clampResult708 * smoothstepResult866 );
				float lerpResult760 = lerp( 0.0 , DepthFade574 , _Alpha);
				
				float Alpha = lerpResult760;
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
302;73;1125;622;3126.774;2381.343;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;164;-3465.936,-3395.754;Inherit;False;2165.693;783.9038;UV;17;323;474;513;473;515;322;508;495;496;502;402;509;476;511;512;478;501;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;512;-3429.901,-3005.708;Inherit;False;Property;_BrumeAnimation_WaveFrequency;BrumeAnimation_WaveFrequency;18;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;478;-3410.691,-2917.321;Inherit;False;Property;_BrumeAnimation_RotatorTime;BrumeAnimation_RotatorTime;16;0;Create;True;0;0;False;0;False;0.2;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;440;-3464.395,-4766.331;Inherit;False;1899.414;1343.164;Noise;27;781;859;858;854;765;774;768;773;782;775;779;414;337;355;372;367;358;340;357;375;373;374;369;376;368;370;341;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinTimeNode;501;-3277.75,-3161.566;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;511;-3092.9,-3027.708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-3414.395,-4689.735;Inherit;False;Property;_PerlinNoise_Tiling;PerlinNoise_Tiling;4;0;Create;True;0;0;False;0;False;0.1;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;476;-3125.691,-2908.321;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;368;-3206.396,-4593.734;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-3190.396,-4513.734;Inherit;False;Constant;_Float5;Float 5;29;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;509;-3103.198,-2807.591;Inherit;False;Property;_BrumeAnimation_WaveStrength;BrumeAnimation_WaveStrength;17;0;Create;True;0;0;False;0;False;0.15;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;502;-2902.642,-2941.323;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;496;-2945.225,-3073.113;Inherit;False;Constant;_Float17;Float 17;31;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;402;-3134.5,-3262.15;Inherit;False;Property;_BrumeTexture_Tiling;BrumeTexture_Tiling;2;0;Create;True;0;0;False;0;False;2;4.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;369;-3046.396,-4561.734;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;508;-2755.198,-2869.591;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;374;-3030.396,-4401.735;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;376;-3104.395,-4322.732;Inherit;False;Property;_PerlinNoise_RotatorSpeed;PerlinNoise_RotatorSpeed;5;0;Create;True;0;0;False;0;False;0.05;0.04;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;-2787.225,-3135.113;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;322;-2864.052,-3280.805;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;357;-2694.397,-4161.732;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;473;-2565.087,-3006.273;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-2918.396,-4705.735;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;373;-2678.397,-4065.73;Inherit;False;Constant;_Float6;Float 6;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;515;-2526.992,-2782.576;Inherit;False;Property;_BrumeAnimation_PannerSpeed;BrumeAnimation_PannerSpeed;19;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-2854.396,-4401.735;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;367;-2662.397,-4529.734;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;-2518.396,-4113.733;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;513;-2203.522,-2906.281;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;358;-2662.397,-4305.732;Inherit;False;Property;_PerlinNoise_PannerSpeed;PerlinNoise_PannerSpeed;6;0;Create;True;0;0;False;0;False;0,0;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;474;-1846.652,-3281.863;Inherit;False;Property;_RotatorAnimation;RotatorAnimation?;15;0;Create;True;0;0;False;1;Header(Brume Animation);False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;556;-3467.412,-1288.571;Inherit;False;3237.907;1213.387;Displacement;19;833;837;832;838;735;239;740;739;737;846;330;734;848;849;736;415;241;558;839;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PannerNode;355;-2374.397,-4385.734;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;839;-3409.781,-207.5701;Inherit;False;Property;_DisplacementTop_Smoothstep;DisplacementTop_Smoothstep;28;0;Create;True;0;0;False;0;False;0;2.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1533.229,-3283.032;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;441;-3455.702,-5655.188;Inherit;False;839.0314;313.6436;Texture;3;329;327;328;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;832;-3322.115,-432.2172;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;337;-2182.394,-4417.735;Inherit;True;Property;_PerlinNoise_Texture;PerlinNoise_Texture;3;0;Create;True;0;0;False;0;False;-1;f6ff7a2b76d9a074eb1c734d22e9cb35;f6ff7a2b76d9a074eb1c734d22e9cb35;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;838;-3363.206,-282.5793;Inherit;False;Property;_DisplacementTop_Step;DisplacementTop_Step;27;0;Create;True;0;0;False;0;False;0;0.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;414;-1885.13,-4417.333;Inherit;False;MovingPerlinNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;837;-3062.237,-380.5693;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.39;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-3407.827,-5546.799;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;849;-2750.853,-489.5812;Inherit;False;Constant;_Float11;Float 11;27;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;833;-2816.672,-377.6423;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;736;-2614.368,-723.2553;Inherit;False;Property;_WaveNoise_Contrast;WaveNoise_Contrast;26;0;Create;True;0;0;False;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;327;-3206.834,-5570.569;Inherit;True;Property;_BrumeTexture;BrumeTexture;1;0;Create;True;0;0;False;1;Header(Textures);False;-1;None;3d5ebcf0ee6354742ae5206089386699;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;415;-2861.65,-879.0812;Inherit;True;414;MovingPerlinNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;734;-2375.45,-872.3223;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-2874.374,-5570.555;Inherit;False;BrumeTextureSample;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;848;-2519.853,-460.5813;Inherit;False;Property;_Displacement_Top_Mask;Displacement_Top_Mask;29;0;Create;True;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;846;-2122.719,-651.0082;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-2395.786,-1209.787;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;739;-1716.374,-791.2183;Inherit;False;Property;_Displacement_Contrast;Displacement_Contrast;25;0;Create;True;0;0;False;1;Header(Displacement);False;0.41;1.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;737;-2024.072,-1062.899;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;740;-1427.374,-869.2172;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;239;-1035.746,-795.3273;Inherit;True;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;735;-1203.528,-869.7112;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-708.3223,-866.9662;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;580;-3465.739,-2596.507;Inherit;False;3288.516;975.9094;DepthFade;17;718;574;743;708;726;568;727;728;569;719;721;866;865;864;867;868;869;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;558;-515.7286,-982.7421;Inherit;False;BrumeDisplacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;721;-3378.678,-2397.514;Inherit;False;558;BrumeDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;718;-3335.118,-2545.482;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;719;-3121.409,-2493.587;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;569;-2988.408,-2405.903;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;20;0;Create;True;0;0;False;1;Header(Depth Fade);False;1;0.71;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;727;-2760.957,-2348.464;Inherit;False;Property;_DepthFade_SmoothstepMin;DepthFade_SmoothstepMin;21;0;Create;True;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;728;-2761.957,-2271.464;Inherit;False;Property;_DepthFade_SmoothstepMax;DepthFade_SmoothstepMax;22;0;Create;True;0;0;False;0;False;1;0.65;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;568;-2757.221,-2493.323;Inherit;False;True;False;True;2;1;FLOAT3;0,1,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;864;-3336.648,-2150.646;Inherit;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;726;-2471.957,-2367.464;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;868;-2720.646,-1945.379;Inherit;False;Property;_BrumeOpacity_DepthMax_Smoothstep;BrumeOpacity_DepthMax_Smoothstep;24;0;Create;True;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;708;-2273.644,-2367.021;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;865;-3000.085,-2097.858;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;867;-2720.646,-2016.379;Inherit;False;Property;_BrumeOpacity_DepthMax_Step;BrumeOpacity_DepthMax_Step;23;0;Create;True;0;0;False;0;False;0;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;866;-2371.356,-2086.609;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;743;-2072.111,-2366.069;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;869;-1853.609,-2155.186;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;574;-1660.091,-2359.008;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;762;-670.5916,-3253.399;Inherit;False;Constant;_Float0;Float 0;23;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;759;-772.3375,-3102.163;Inherit;False;Property;_Alpha;Alpha;0;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;171;-3458.32,-5311.889;Inherit;False;1849.658;476.1449;Normal Light Dir;10;862;861;180;860;177;179;178;176;175;863;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;447;-1245.101,-4990.604;Inherit;False;1450.723;1205.914;Color;13;312;449;315;335;311;450;314;451;313;336;850;851;853;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;764;-714.783,-3181.387;Inherit;False;574;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;292;-472.4095,-3287.835;Inherit;False;315;BrumeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;859;-2369.739,-3656.792;Inherit;False;Property;_ColorVariationNoise_Contrast;ColorVariationNoise_Contrast;9;0;Create;True;0;0;False;0;False;1.35;1.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;853;-700.509,-4643.152;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;313;-675.7983,-4367.894;Inherit;False;Property;_BrumeColor_ColorHigh;BrumeColor_ColorHigh;13;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;178;-3129.617,-5014.305;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;862;-2357.532,-5105.75;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;775;-3215.067,-3616.071;Inherit;False;Property;_ColorVariationNoise_RotatorSpeed;ColorVariationNoise_RotatorSpeed;10;0;Create;True;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;851;-1175.954,-4413.972;Inherit;False;854;MovingPerlinNoise2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DotProductOpNode;177;-3145.617,-5237.306;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;450;-1044.114,-4249.575;Inherit;False;Constant;_Float2;Float 2;26;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-596.1913,-4077.867;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;768;-2993.116,-3948.492;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;781;-2993.594,-3825.665;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;782;-3165.594,-3740.665;Inherit;False;Constant;_Float7;Float 7;27;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-2857.617,-5237.306;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;-917.7953,-3966.356;Inherit;False;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;449;-865.2142,-4186.777;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;175;-3417.618,-5093.306;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;314;-353.944,-4369.172;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;312;-1192.033,-4601.538;Inherit;False;Property;_BrumeColor_ColorLow2;BrumeColor_ColorLow2;12;0;Create;True;0;0;False;0;False;0.4,0.4470589,0.509804,1;0.5367569,0.6161124,0.6981132,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;861;-2588.108,-4933.377;Inherit;False;414;MovingPerlinNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;854;-1811.448,-3919.983;Inherit;False;MovingPerlinNoise2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;559;-439.7802,-3080.55;Inherit;False;558;BrumeDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;-96.653,-4373.691;Inherit;False;BrumeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;765;-2391.748,-3921.7;Inherit;True;Property;_ColorVariationNoise_Texture;ColorVariationNoise_Texture;7;0;Create;True;0;0;False;0;False;-1;f6ff7a2b76d9a074eb1c734d22e9cb35;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;774;-2905.011,-3609.635;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;760;-484.5918,-3200.399;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;860;-2593.959,-5150.343;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;451;-1158.471,-4088.754;Inherit;False;Property;_BrumeColor_LightImpact;BrumeColor_LightImpact;14;0;Create;True;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-1825.884,-5243.872;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;176;-3401.619,-5237.306;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;850;-1191.241,-4772.746;Inherit;False;Property;_BrumeColor_ColorLow1;BrumeColor_ColorLow1;11;0;Create;True;0;0;False;1;Header(Brume Color);False;0.4,0.4470589,0.509804,1;0.185163,0.3761394,0.5377356,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;858;-2040.433,-3763.091;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;863;-2106.532,-5237.75;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1109.125,-4168.794;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;779;-3295.83,-3930.56;Inherit;False;Property;_ColorVariationNoise_Tiling;ColorVariationNoise_Tiling;8;0;Create;True;0;0;False;0;False;0.49;0.49;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;773;-2610.011,-3892.634;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;607;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;609;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;605;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;606;-153.7433,-3236.922;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;BrumeVolume1;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;2;5;False;-1;10;False;-1;0;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;1;  Blend;0;Two Sided;0;Cast Shadows;0;  Use Shadow Threshold;1;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;1;  Phong;1;  Strength;1,False,-1;  Type;1;  Tess;16,False,-1;  Min;10,False,-1;  Max;100,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;False;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;608;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;511;0;501;4
WireConnection;511;1;512;0
WireConnection;476;0;478;0
WireConnection;368;0;341;0
WireConnection;502;0;511;0
WireConnection;502;1;476;0
WireConnection;369;0;368;0
WireConnection;369;1;370;0
WireConnection;508;0;502;0
WireConnection;508;1;509;0
WireConnection;495;0;402;0
WireConnection;495;1;496;0
WireConnection;322;0;402;0
WireConnection;473;0;322;0
WireConnection;473;1;495;0
WireConnection;473;2;508;0
WireConnection;340;0;341;0
WireConnection;340;1;369;0
WireConnection;375;0;374;0
WireConnection;375;1;376;0
WireConnection;367;0;340;0
WireConnection;367;2;375;0
WireConnection;372;0;357;0
WireConnection;372;1;373;0
WireConnection;513;0;473;0
WireConnection;513;2;515;0
WireConnection;513;1;508;0
WireConnection;474;1;322;0
WireConnection;474;0;513;0
WireConnection;355;0;367;0
WireConnection;355;2;358;0
WireConnection;355;1;372;0
WireConnection;323;0;474;0
WireConnection;337;1;355;0
WireConnection;414;0;337;1
WireConnection;837;0;832;2
WireConnection;837;1;838;0
WireConnection;837;2;839;0
WireConnection;833;0;837;0
WireConnection;327;1;328;0
WireConnection;734;1;415;0
WireConnection;734;0;736;0
WireConnection;329;0;327;0
WireConnection;848;1;849;0
WireConnection;848;0;833;0
WireConnection;846;0;734;0
WireConnection;846;1;848;0
WireConnection;737;0;330;0
WireConnection;737;1;846;0
WireConnection;740;0;737;0
WireConnection;740;1;739;0
WireConnection;735;0;740;0
WireConnection;241;0;735;0
WireConnection;241;1;239;0
WireConnection;558;0;241;0
WireConnection;719;0;718;0
WireConnection;719;1;721;0
WireConnection;568;1;719;0
WireConnection;568;0;569;0
WireConnection;726;0;568;0
WireConnection;726;1;727;0
WireConnection;726;2;728;0
WireConnection;708;0;726;0
WireConnection;865;0;864;2
WireConnection;866;0;865;0
WireConnection;866;1;867;0
WireConnection;866;2;868;0
WireConnection;743;0;708;0
WireConnection;869;0;743;0
WireConnection;869;1;866;0
WireConnection;574;0;869;0
WireConnection;853;0;850;0
WireConnection;853;1;312;0
WireConnection;853;2;851;0
WireConnection;862;0;860;0
WireConnection;862;1;861;0
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;335;0;449;0
WireConnection;335;1;336;0
WireConnection;768;0;779;0
WireConnection;781;0;779;0
WireConnection;781;1;782;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;449;0;450;0
WireConnection;449;1;311;0
WireConnection;449;2;451;0
WireConnection;314;0;853;0
WireConnection;314;1;313;0
WireConnection;314;2;335;0
WireConnection;854;0;858;0
WireConnection;315;0;314;0
WireConnection;765;1;773;0
WireConnection;774;0;775;0
WireConnection;760;0;762;0
WireConnection;760;1;764;0
WireConnection;760;2;759;0
WireConnection;860;0;179;0
WireConnection;180;0;863;0
WireConnection;858;1;765;0
WireConnection;858;0;859;0
WireConnection;863;0;179;0
WireConnection;863;1;862;0
WireConnection;773;0;768;0
WireConnection;773;1;781;0
WireConnection;773;2;774;0
WireConnection;606;2;292;0
WireConnection;606;3;760;0
WireConnection;606;5;559;0
ASEEND*/
//CHKSM=9458F78D778FA6CF4D194C2F4F725D64D71EECEE
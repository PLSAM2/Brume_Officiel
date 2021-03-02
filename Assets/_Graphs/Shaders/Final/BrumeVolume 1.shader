// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrumeVolume1"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin]_Alpha("Alpha", Range( 0 , 1)) = 0
		_BrumeTexture("BrumeTexture", 2D) = "white" {}
		_BrumeTexture_Tiling("BrumeTexture_Tiling", Float) = 2
		[Header(Noise)]_PerlinNoise_Texture("PerlinNoise_Texture", 2D) = "white" {}
		_PerlinNoise_Tiling("PerlinNoise_Tiling", Float) = 0.1
		_PerlinNoise_RotatorSpeed("PerlinNoise_RotatorSpeed", Float) = 0.05
		_PerlinNoise_PannerSpeed("PerlinNoise_PannerSpeed", Vector) = (0,0,0,0)
		[Header(Brume Color)]_BrumeColor_ColorLow("BrumeColor_ColorLow", Color) = (0.4,0.4470589,0.509804,1)
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
		[Header(Displacement)]_Displacement_Contrast("Displacement_Contrast", Float) = 0.41
		_WaveNoise_Contrast("WaveNoise_Contrast", Float) = 0
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Grunge_Smoothstep("Grunge_Smoothstep", Float) = 0
		_Grunge_Tiling("Grunge_Tiling", Float) = 1
		[ASEEnd]_Grunge_Direction("Grunge_Direction", Vector) = (0,-0.1,0,0)

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
			
			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define _RECEIVE_SHADOWS_OFF 1
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
			float4 _BrumeColor_ColorHigh;
			float4 _BrumeColor_ColorLow;
			float2 _Grunge_Direction;
			float2 _BrumeAnimation_PannerSpeed;
			float2 _PerlinNoise_PannerSpeed;
			float _BrumeTexture_Tiling;
			float _Grunge_Smoothstep;
			float _DepthFade_Distance;
			float _DepthFade_SmoothstepMax;
			float _DepthFade_SmoothstepMin;
			float _BrumeColor_LightImpact;
			float _Displacement_Contrast;
			float _PerlinNoise_RotatorSpeed;
			float _PerlinNoise_Tiling;
			float _WaveNoise_Contrast;
			float _BrumeAnimation_WaveStrength;
			float _BrumeAnimation_RotatorTime;
			float _BrumeAnimation_WaveFrequency;
			float _Grunge_Tiling;
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
			sampler2D _TextureSample0;


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
				float4 temp_output_737_0 = ( BrumeTextureSample329 + CalculateContrast(_WaveNoise_Contrast,temp_cast_4) );
				float3 BrumeDisplacement558 = ( ( temp_output_737_0 * _Displacement_Contrast ).r * v.ase_normal );
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				
				float3 vertexPos568 = ( v.vertex.xyz + BrumeDisplacement558 );
				float4 ase_clipPos568 = TransformObjectToHClip((vertexPos568).xyz);
				float4 screenPos568 = ComputeScreenPos(ase_clipPos568);
				o.ase_texcoord5 = screenPos568;
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.zw = 0;
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
				float3 ase_worldNormal = IN.ase_texcoord3.xyz;
				float dotResult177 = dot( ase_worldNormal , _MainLightPosition.xyz );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir180 = ( dotResult177 * ase_lightAtten );
				float lerpResult449 = lerp( 1.0 , normal_LightDir180 , _BrumeColor_LightImpact);
				float2 temp_cast_0 = (_BrumeTexture_Tiling).xx;
				float2 texCoord322 = IN.ase_texcoord4.xy * temp_cast_0 + float2( 0,0 );
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
				float4 BrumeTextureSample329 = tex2D( _BrumeTexture, UV323 );
				float4 lerpResult314 = lerp( _BrumeColor_ColorLow , _BrumeColor_ColorHigh , ( lerpResult449 * BrumeTextureSample329 ));
				float4 BrumeColor315 = lerpResult314;
				
				float4 screenPos568 = IN.ase_texcoord5;
				float4 ase_screenPosNorm568 = screenPos568 / screenPos568.w;
				ase_screenPosNorm568.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm568.z : ase_screenPosNorm568.z * 0.5 + 0.5;
				float screenDepth568 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm568.xy ),_ZBufferParams);
				float distanceDepth568 = abs( ( screenDepth568 - LinearEyeDepth( ase_screenPosNorm568.z,_ZBufferParams ) ) / ( _DepthFade_Distance ) );
				float smoothstepResult726 = smoothstep( _DepthFade_SmoothstepMin , _DepthFade_SmoothstepMax , distanceDepth568);
				float smoothstepResult746 = smoothstep( ( _DepthFade_SmoothstepMin + _Grunge_Smoothstep ) , ( _DepthFade_SmoothstepMax + _Grunge_Smoothstep ) , distanceDepth568);
				float2 temp_cast_3 = (_Grunge_Tiling).xx;
				float2 texCoord753 = IN.ase_texcoord4.xy * temp_cast_3 + float2( 0,0 );
				float2 panner757 = ( 1.0 * _Time.y * _Grunge_Direction + texCoord753);
				float clampResult708 = clamp( ( smoothstepResult726 * ( smoothstepResult746 + ( ( 1.0 - smoothstepResult746 ) * tex2D( _TextureSample0, panner757 ).r ) ) ) , 0.0 , 1.0 );
				float DepthFade574 = clampResult708;
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
			#define _RECEIVE_SHADOWS_OFF 1
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
			#pragma shader_feature_local _ROTATORANIMATION_ON


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
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _BrumeColor_ColorHigh;
			float4 _BrumeColor_ColorLow;
			float2 _Grunge_Direction;
			float2 _BrumeAnimation_PannerSpeed;
			float2 _PerlinNoise_PannerSpeed;
			float _BrumeTexture_Tiling;
			float _Grunge_Smoothstep;
			float _DepthFade_Distance;
			float _DepthFade_SmoothstepMax;
			float _DepthFade_SmoothstepMin;
			float _BrumeColor_LightImpact;
			float _Displacement_Contrast;
			float _PerlinNoise_RotatorSpeed;
			float _PerlinNoise_Tiling;
			float _WaveNoise_Contrast;
			float _BrumeAnimation_WaveStrength;
			float _BrumeAnimation_RotatorTime;
			float _BrumeAnimation_WaveFrequency;
			float _Grunge_Tiling;
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
			sampler2D _TextureSample0;


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
				float4 temp_output_737_0 = ( BrumeTextureSample329 + CalculateContrast(_WaveNoise_Contrast,temp_cast_4) );
				float3 BrumeDisplacement558 = ( ( temp_output_737_0 * _Displacement_Contrast ).r * v.ase_normal );
				
				float3 vertexPos568 = ( v.vertex.xyz + BrumeDisplacement558 );
				float4 ase_clipPos568 = TransformObjectToHClip((vertexPos568).xyz);
				float4 screenPos568 = ComputeScreenPos(ase_clipPos568);
				o.ase_texcoord2 = screenPos568;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;
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
				float smoothstepResult746 = smoothstep( ( _DepthFade_SmoothstepMin + _Grunge_Smoothstep ) , ( _DepthFade_SmoothstepMax + _Grunge_Smoothstep ) , distanceDepth568);
				float2 temp_cast_0 = (_Grunge_Tiling).xx;
				float2 texCoord753 = IN.ase_texcoord3.xy * temp_cast_0 + float2( 0,0 );
				float2 panner757 = ( 1.0 * _Time.y * _Grunge_Direction + texCoord753);
				float clampResult708 = clamp( ( smoothstepResult726 * ( smoothstepResult746 + ( ( 1.0 - smoothstepResult746 ) * tex2D( _TextureSample0, panner757 ).r ) ) ) , 0.0 , 1.0 );
				float DepthFade574 = clampResult708;
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
1920;0;1920;1019;1118.01;3787.823;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;164;-3465.936,-3395.754;Inherit;False;2165.693;783.9038;UV;17;323;474;513;473;515;322;508;495;496;502;402;509;476;511;512;478;501;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinTimeNode;501;-3277.75,-3161.566;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;478;-3410.691,-2917.321;Inherit;False;Property;_BrumeAnimation_RotatorTime;BrumeAnimation_RotatorTime;11;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;512;-3429.901,-3005.708;Inherit;False;Property;_BrumeAnimation_WaveFrequency;BrumeAnimation_WaveFrequency;13;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;511;-3092.9,-3027.708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;476;-3125.691,-2908.321;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;440;-3463.359,-4223.959;Inherit;False;1837.985;805.8237;Noise;16;414;337;355;372;358;367;373;357;340;375;374;369;376;368;370;341;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;402;-3134.5,-3262.15;Inherit;False;Property;_BrumeTexture_Tiling;BrumeTexture_Tiling;2;0;Create;True;0;0;False;0;False;2;7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-3413.359,-4147.363;Inherit;False;Property;_PerlinNoise_Tiling;PerlinNoise_Tiling;4;0;Create;True;0;0;False;0;False;0.1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;496;-2945.225,-3073.113;Inherit;False;Constant;_Float17;Float 17;31;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;502;-2902.642,-2941.323;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;509;-3103.198,-2807.591;Inherit;False;Property;_BrumeAnimation_WaveStrength;BrumeAnimation_WaveStrength;12;0;Create;True;0;0;False;0;False;0.15;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;508;-2755.198,-2869.591;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;322;-2864.052,-3280.805;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;370;-3189.359,-3971.362;Inherit;False;Constant;_Float5;Float 5;29;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;-2787.225,-3135.113;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;368;-3205.359,-4051.362;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;473;-2565.087,-3006.273;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;369;-3045.359,-4019.362;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;515;-2526.992,-2782.576;Inherit;False;Property;_BrumeAnimation_PannerSpeed;BrumeAnimation_PannerSpeed;14;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;376;-3103.359,-3780.361;Inherit;False;Property;_PerlinNoise_RotatorSpeed;PerlinNoise_RotatorSpeed;5;0;Create;True;0;0;False;0;False;0.05;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;374;-3029.359,-3859.363;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;513;-2203.522,-2906.281;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-2853.359,-3859.363;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;-2677.36,-3523.361;Inherit;False;Constant;_Float6;Float 6;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-2917.359,-4163.363;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;357;-2693.36,-3619.361;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;358;-2661.36,-3763.361;Inherit;False;Property;_PerlinNoise_PannerSpeed;PerlinNoise_PannerSpeed;6;0;Create;True;0;0;False;0;False;0,0;0.2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;474;-1846.652,-3281.863;Inherit;False;Property;_RotatorAnimation;RotatorAnimation?;10;0;Create;True;0;0;False;1;Header(Brume Animation);False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;-2517.36,-3571.361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;367;-2661.36,-3987.362;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;355;-2373.36,-3843.362;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1533.229,-3283.032;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;441;-3459.3,-5017.667;Inherit;False;839.0314;313.6436;Texture;3;329;327;328;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;337;-2181.359,-3875.363;Inherit;True;Property;_PerlinNoise_Texture;PerlinNoise_Texture;3;0;Create;True;0;0;False;1;Header(Noise);False;-1;f6ff7a2b76d9a074eb1c734d22e9cb35;f6ff7a2b76d9a074eb1c734d22e9cb35;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;328;-3411.425,-4909.279;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;556;-3457.868,-1523.552;Inherit;False;2893.98;692.6512;Displacement;12;738;558;241;735;239;740;739;737;734;330;415;736;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;327;-3210.432,-4933.049;Inherit;True;Property;_BrumeTexture;BrumeTexture;1;0;Create;True;0;0;False;0;False;-1;None;d59eab6cece9db54b90d982bd90cd50d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;414;-1884.095,-3874.961;Inherit;False;MovingPerlinNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-2877.971,-4933.034;Inherit;False;BrumeTextureSample;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;415;-3399.27,-1114.063;Inherit;True;414;MovingPerlinNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;736;-3151.988,-958.2363;Inherit;False;Property;_WaveNoise_Contrast;WaveNoise_Contrast;19;0;Create;True;0;0;False;0;False;0;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;734;-2913.07,-1107.304;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-2933.406,-1444.769;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;737;-2561.692,-1297.881;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;739;-2376.995,-981.1996;Inherit;False;Property;_Displacement_Contrast;Displacement_Contrast;18;0;Create;True;0;0;False;1;Header(Displacement);False;0.41;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;740;-2095.995,-1341.199;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NormalVertexDataNode;239;-1465.367,-1021.309;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;735;-1741.149,-1104.693;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-1245.943,-1101.948;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;558;-812.6327,-1216.235;Inherit;False;BrumeDisplacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;580;-3465.739,-2596.507;Inherit;False;2704.997;1042.449;DepthFade;24;756;719;718;754;721;574;708;743;728;748;746;727;568;569;749;747;753;742;741;751;726;755;757;758;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;721;-3378.678,-2397.514;Inherit;False;558;BrumeDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.PosVertexDataNode;718;-3335.118,-2545.482;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;728;-2761.957,-2271.464;Inherit;False;Property;_DepthFade_SmoothstepMax;DepthFade_SmoothstepMax;17;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;569;-2988.408,-2405.903;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;15;0;Create;True;0;0;False;1;Header(Depth Fade);False;1;1.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;727;-2760.957,-2348.464;Inherit;False;Property;_DepthFade_SmoothstepMin;DepthFade_SmoothstepMin;16;0;Create;True;0;0;False;0;False;0;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;749;-2771.669,-2124.52;Inherit;False;Property;_Grunge_Smoothstep;Grunge_Smoothstep;21;0;Create;True;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;719;-3121.409,-2493.587;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;754;-2980.31,-1822.323;Inherit;False;Property;_Grunge_Tiling;Grunge_Tiling;22;0;Create;True;0;0;False;0;False;1;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;568;-2757.221,-2493.323;Inherit;False;True;False;True;2;1;FLOAT3;0,1,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;747;-2490.669,-2142.52;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;753;-2792.497,-1841.073;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;748;-2490.669,-2047.52;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;758;-2758.33,-1712.93;Inherit;False;Property;_Grunge_Direction;Grunge_Direction;23;0;Create;True;0;0;False;0;False;0,-0.1;0,-0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;757;-2556.025,-1772.331;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;746;-2338.325,-2167.275;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;742;-2265.253,-1941.288;Inherit;True;Property;_TextureSample0;Texture Sample 0;20;0;Create;True;0;0;False;0;False;-1;None;a61778d50b6394348b9f8089e2c6e1fd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;755;-2148.738,-2052.533;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;741;-1933.07,-2051.812;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;726;-2471.957,-2367.464;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;756;-1797.738,-2165.533;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;751;-1737.203,-2367.064;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;708;-1593.049,-2367.02;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;743;-1391.514,-2366.068;Inherit;False;FLOAT;1;0;FLOAT;0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;574;-1185.924,-2372.693;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;759;-767.5645,-3450.599;Inherit;False;Property;_Alpha;Alpha;0;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;171;-3461.918,-4674.368;Inherit;False;1085.443;423.0433;Normal Light Dir;6;177;176;178;179;180;175;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;762;-665.8186,-3601.835;Inherit;False;Constant;_Float0;Float 0;23;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;764;-710.01,-3529.823;Inherit;False;574;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;447;-1537.889,-4572.719;Inherit;False;1325.925;782.5781;Color;10;315;311;451;335;450;314;336;449;312;313;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;559;-72.30713,-3504.387;Inherit;False;558;BrumeDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;312;-1010.645,-4490.894;Inherit;False;Property;_BrumeColor_ColorLow;BrumeColor_ColorLow;7;0;Create;True;0;0;False;1;Header(Brume Color);False;0.4,0.4470589,0.509804,1;0.3690806,0.4680194,0.5471698,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;292;-39.16504,-3700.558;Inherit;False;315;BrumeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;449;-1199.602,-4128.604;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;177;-3149.215,-4599.785;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-930.5789,-4019.696;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;176;-3405.217,-4599.785;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LightAttenuation;178;-3133.215,-4376.784;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;-431.0404,-4315.519;Inherit;False;BrumeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;-1252.183,-3908.185;Inherit;False;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;314;-688.3316,-4311;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-2577.389,-4605.351;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1443.513,-4110.621;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;313;-1010.186,-4309.722;Inherit;False;Property;_BrumeColor_ColorHigh;BrumeColor_ColorHigh;8;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;175;-3421.216,-4455.785;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-2861.214,-4599.785;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;450;-1378.502,-4191.403;Inherit;False;Constant;_Float2;Float 2;26;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;738;-2103.995,-1106.199;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;451;-1492.859,-4030.583;Inherit;False;Property;_BrumeColor_LightImpact;BrumeColor_LightImpact;9;0;Create;True;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;760;-479.8186,-3548.835;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;607;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;605;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;606;301.282,-3610.192;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;BrumeVolume1;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;2;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;1;  Blend;0;Two Sided;0;Cast Shadows;0;  Use Shadow Threshold;0;Receive Shadows;0;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;1;  Phong;1;  Strength;0.5,False,-1;  Type;1;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;False;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;609;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;608;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;511;0;501;4
WireConnection;511;1;512;0
WireConnection;476;0;478;0
WireConnection;502;0;511;0
WireConnection;502;1;476;0
WireConnection;508;0;502;0
WireConnection;508;1;509;0
WireConnection;322;0;402;0
WireConnection;495;0;402;0
WireConnection;495;1;496;0
WireConnection;368;0;341;0
WireConnection;473;0;322;0
WireConnection;473;1;495;0
WireConnection;473;2;508;0
WireConnection;369;0;368;0
WireConnection;369;1;370;0
WireConnection;513;0;473;0
WireConnection;513;2;515;0
WireConnection;513;1;508;0
WireConnection;375;0;374;0
WireConnection;375;1;376;0
WireConnection;340;0;341;0
WireConnection;340;1;369;0
WireConnection;474;1;322;0
WireConnection;474;0;513;0
WireConnection;372;0;357;0
WireConnection;372;1;373;0
WireConnection;367;0;340;0
WireConnection;367;2;375;0
WireConnection;355;0;367;0
WireConnection;355;2;358;0
WireConnection;355;1;372;0
WireConnection;323;0;474;0
WireConnection;337;1;355;0
WireConnection;327;1;328;0
WireConnection;414;0;337;1
WireConnection;329;0;327;0
WireConnection;734;1;415;0
WireConnection;734;0;736;0
WireConnection;737;0;330;0
WireConnection;737;1;734;0
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
WireConnection;747;0;727;0
WireConnection;747;1;749;0
WireConnection;753;0;754;0
WireConnection;748;0;728;0
WireConnection;748;1;749;0
WireConnection;757;0;753;0
WireConnection;757;2;758;0
WireConnection;746;0;568;0
WireConnection;746;1;747;0
WireConnection;746;2;748;0
WireConnection;742;1;757;0
WireConnection;755;0;746;0
WireConnection;741;0;755;0
WireConnection;741;1;742;1
WireConnection;726;0;568;0
WireConnection;726;1;727;0
WireConnection;726;2;728;0
WireConnection;756;0;746;0
WireConnection;756;1;741;0
WireConnection;751;0;726;0
WireConnection;751;1;756;0
WireConnection;708;0;751;0
WireConnection;743;0;708;0
WireConnection;574;0;743;0
WireConnection;449;0;450;0
WireConnection;449;1;311;0
WireConnection;449;2;451;0
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;335;0;449;0
WireConnection;335;1;336;0
WireConnection;315;0;314;0
WireConnection;314;0;312;0
WireConnection;314;1;313;0
WireConnection;314;2;335;0
WireConnection;180;0;179;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;738;1;737;0
WireConnection;738;0;739;0
WireConnection;760;0;762;0
WireConnection;760;1;764;0
WireConnection;760;2;759;0
WireConnection;606;2;292;0
WireConnection;606;3;760;0
WireConnection;606;5;559;0
ASEEND*/
//CHKSM=C9EB13B8DC8D29B9935A5CD43FD0D71313A70DC7
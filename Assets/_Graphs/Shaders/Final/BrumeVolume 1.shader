// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "BrumeVolume1"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin]_BrumeTexture("BrumeTexture", 2D) = "white" {}
		_BrumeTexture_Tiling("BrumeTexture_Tiling", Float) = 2
		[Toggle(_ROTATORANIMATION_ON)] _RotatorAnimation("RotatorAnimation?", Float) = 0
		[Header(Displacement)][Toggle(_DISPLACEMENT_ON)] _Displacement("Displacement?", Float) = 0
		_DisplacementTexture_Multiply("DisplacementTexture_Multiply", Float) = 1
		_DisplacementTexture_Contrast("DisplacementTexture_Contrast", Float) = 1
		[Header(Light Normal)]_LightNormal("LightNormal?", Range( 0 , 1)) = 0
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
		[Header(Brume Volume Transition)]_BrumeVolumeTransition_Blend("BrumeVolumeTransition_Blend", Range( 0 , 5)) = 5
		_BrumeVolumeTransition_Scale("BrumeVolumeTransition_Scale", Float) = 0.3
		_BrumeVolumeTransition_Offset("BrumeVolumeTransition_Offset", Float) = 1.3
		[Header(Depth Fade)]_DepthFade_Distance("DepthFade_Distance", Float) = 1
		_LightStep("LightStep", Float) = 0.43
		_ShadowColor("ShadowColor", Color) = (0.3584906,0.3584906,0.3584906,0)
		_ShadowStep("ShadowStep", Float) = 0.36
		_ShadowNoise("ShadowNoise", 2D) = "white" {}
		[Toggle(_ISSHADOWON_ON)] _IsShadowOn("IsShadowOn?", Float) = 0
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float0("Float 0", Float) = 0
		_Float11("Float 11", Float) = 1
		[ASEEnd]_Float12("Float 12", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		
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
			
			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0,0
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
			#pragma shader_feature_local _DISPLACEMENT_ON
			#pragma shader_feature_local _ROTATORANIMATION_ON
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma shader_feature_local _ISSHADOWON_ON


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
			float4 _ShadowColor;
			float4 _ShadowNoise_ST;
			float4 _BrumeColor_ColorHigh;
			float4 _BrumeColor_ColorLow;
			float2 _BrumeAnimation_PannerSpeed;
			float2 _PerlinNoise_PannerSpeed;
			float _DisplacementTexture_Contrast;
			float _Float0;
			float _DepthFade_Distance;
			float _ShadowStep;
			float _LightStep;
			float _LightNormal;
			float _BrumeVolumeTransition_Offset;
			float _Float11;
			float _BrumeVolumeTransition_Scale;
			float _DisplacementTexture_Multiply;
			float _PerlinNoise_Tiling;
			float _WaveNoiseContrast;
			float _BrumeAnimation_WaveStrength;
			float _BrumeAnimation_RotatorTime;
			float _BrumeAnimation_WaveFrequency;
			float _BrumeTexture_Tiling;
			float _BrumeVolumeTransition_Blend;
			float _Float12;
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
			sampler2D _ShadowNoise;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _TextureSample1;


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
				float cos367 = cos( ( _TimeParameters.x * 0.05 ) );
				float sin367 = sin( ( _TimeParameters.x * 0.05 ) );
				float2 rotator367 = mul( texCoord340 - float2( 0.5,0.5 ) , float2x2( cos367 , -sin367 , sin367 , cos367 )) + float2( 0.5,0.5 );
				float2 panner355 = ( ( _TimeParameters.x * 0.05 ) * _PerlinNoise_PannerSpeed + rotator367);
				float MovingPerlinNoise414 = tex2Dlod( _PerlinNoise_Texture, float4( panner355, 0, 0.0) ).r;
				float4 temp_cast_4 = ((0.5 + (MovingPerlinNoise414 - 0.0) * (1.0 - 0.5) / (1.0 - 0.0))).xxxx;
				float4 temp_cast_5 = (CalculateContrast(_DisplacementTexture_Contrast,( ( BrumeTextureSample329 * CalculateContrast(_WaveNoiseContrast,temp_cast_4) ) * _DisplacementTexture_Multiply )).r).xxxx;
				float temp_output_9_0_g2 = saturate( pow( max( ( (half4(0,0,0,0)*_BrumeVolumeTransition_Scale + _BrumeVolumeTransition_Offset).r * 0.79 * ( 1.0 + 0.0 ) ) , 0.0 ) , ( _BrumeVolumeTransition_Blend * -1.0 ) ) );
				float4 lerpResult14_g2 = lerp( temp_cast_5 , float4( 0,0,0,0 ) , temp_output_9_0_g2);
				#ifdef _DISPLACEMENT_ON
				float3 staticSwitch267 = ( lerpResult14_g2.r * v.ase_normal );
				#else
				float3 staticSwitch267 = float3( 0,0,0 );
				#endif
				float3 BrumeDisplacement558 = staticSwitch267;
				
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
				float lerpResult449 = lerp( 1.0 , normal_LightDir180 , _LightNormal);
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
				float4 temp_cast_2 = (1.0).xxxx;
				float smoothstepResult656 = smoothstep( _LightStep , ( 0.01 + _LightStep ) , normal_LightDir180);
				float smoothstepResult659 = smoothstep( ( 0.08 + _ShadowStep ) , _ShadowStep , normal_LightDir180);
				float2 uv_ShadowNoise = IN.ase_texcoord4.xy * _ShadowNoise_ST.xy + _ShadowNoise_ST.zw;
				float4 tex2DNode651 = tex2D( _ShadowNoise, uv_ShadowNoise );
				float blendOpSrc668 = ( smoothstepResult659 - tex2DNode651.r );
				float blendOpDest668 = smoothstepResult659;
				float4 Shadow641 = ( smoothstepResult656 + ( ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest668) / max( blendOpSrc668, 0.00001) ) ) )) * _ShadowColor ) );
				#ifdef _ISSHADOWON_ON
				float4 staticSwitch669 = Shadow641;
				#else
				float4 staticSwitch669 = temp_cast_2;
				#endif
				float4 BrumeColor315 = ( lerpResult314 * staticSwitch669 );
				
				float4 screenPos568 = IN.ase_texcoord5;
				float4 ase_screenPosNorm568 = screenPos568 / screenPos568.w;
				ase_screenPosNorm568.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm568.z : ase_screenPosNorm568.z * 0.5 + 0.5;
				float screenDepth568 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm568.xy ),_ZBufferParams);
				float distanceDepth568 = abs( ( screenDepth568 - LinearEyeDepth( ase_screenPosNorm568.z,_ZBufferParams ) ) / ( _DepthFade_Distance ) );
				float4 temp_cast_4 = (_Float0).xxxx;
				float4 temp_cast_5 = (_Float11).xxxx;
				float2 temp_cast_6 = (_Float12).xx;
				float2 texCoord714 = IN.ase_texcoord4.xy * temp_cast_6 + float2( 0,0 );
				float4 smoothstepResult711 = smoothstep( temp_cast_4 , temp_cast_5 , tex2D( _TextureSample1, texCoord714 ));
				float4 clampResult708 = clamp( ( distanceDepth568 * smoothstepResult711 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				float4 DepthFade574 = clampResult708;
				float4 BrumeOpacity420 = DepthFade574;
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = BrumeColor315.rgb;
				float Alpha = saturate( BrumeOpacity420 ).r;
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
			#pragma shader_feature_local _DISPLACEMENT_ON
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
			float4 _ShadowColor;
			float4 _ShadowNoise_ST;
			float4 _BrumeColor_ColorHigh;
			float4 _BrumeColor_ColorLow;
			float2 _BrumeAnimation_PannerSpeed;
			float2 _PerlinNoise_PannerSpeed;
			float _DisplacementTexture_Contrast;
			float _Float0;
			float _DepthFade_Distance;
			float _ShadowStep;
			float _LightStep;
			float _LightNormal;
			float _BrumeVolumeTransition_Offset;
			float _Float11;
			float _BrumeVolumeTransition_Scale;
			float _DisplacementTexture_Multiply;
			float _PerlinNoise_Tiling;
			float _WaveNoiseContrast;
			float _BrumeAnimation_WaveStrength;
			float _BrumeAnimation_RotatorTime;
			float _BrumeAnimation_WaveFrequency;
			float _BrumeTexture_Tiling;
			float _BrumeVolumeTransition_Blend;
			float _Float12;
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
			sampler2D _TextureSample1;


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
				float cos367 = cos( ( _TimeParameters.x * 0.05 ) );
				float sin367 = sin( ( _TimeParameters.x * 0.05 ) );
				float2 rotator367 = mul( texCoord340 - float2( 0.5,0.5 ) , float2x2( cos367 , -sin367 , sin367 , cos367 )) + float2( 0.5,0.5 );
				float2 panner355 = ( ( _TimeParameters.x * 0.05 ) * _PerlinNoise_PannerSpeed + rotator367);
				float MovingPerlinNoise414 = tex2Dlod( _PerlinNoise_Texture, float4( panner355, 0, 0.0) ).r;
				float4 temp_cast_4 = ((0.5 + (MovingPerlinNoise414 - 0.0) * (1.0 - 0.5) / (1.0 - 0.0))).xxxx;
				float4 temp_cast_5 = (CalculateContrast(_DisplacementTexture_Contrast,( ( BrumeTextureSample329 * CalculateContrast(_WaveNoiseContrast,temp_cast_4) ) * _DisplacementTexture_Multiply )).r).xxxx;
				float temp_output_9_0_g2 = saturate( pow( max( ( (half4(0,0,0,0)*_BrumeVolumeTransition_Scale + _BrumeVolumeTransition_Offset).r * 0.79 * ( 1.0 + 0.0 ) ) , 0.0 ) , ( _BrumeVolumeTransition_Blend * -1.0 ) ) );
				float4 lerpResult14_g2 = lerp( temp_cast_5 , float4( 0,0,0,0 ) , temp_output_9_0_g2);
				#ifdef _DISPLACEMENT_ON
				float3 staticSwitch267 = ( lerpResult14_g2.r * v.ase_normal );
				#else
				float3 staticSwitch267 = float3( 0,0,0 );
				#endif
				float3 BrumeDisplacement558 = staticSwitch267;
				
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
				float4 temp_cast_0 = (_Float0).xxxx;
				float4 temp_cast_1 = (_Float11).xxxx;
				float2 temp_cast_2 = (_Float12).xx;
				float2 texCoord714 = IN.ase_texcoord3.xy * temp_cast_2 + float2( 0,0 );
				float4 smoothstepResult711 = smoothstep( temp_cast_0 , temp_cast_1 , tex2D( _TextureSample1, texCoord714 ));
				float4 clampResult708 = clamp( ( distanceDepth568 * smoothstepResult711 ) , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				float4 DepthFade574 = clampResult708;
				float4 BrumeOpacity420 = DepthFade574;
				
				float Alpha = saturate( BrumeOpacity420 ).r;
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
1920;0;1920;1019;-32.14618;4859.742;2.101757;True;False
Node;AmplifyShaderEditor.CommentaryNode;164;-3465.936,-3395.754;Inherit;False;2165.693;783.9038;UV;17;323;474;513;473;515;322;508;495;496;502;402;509;476;511;512;478;501;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SinTimeNode;501;-3277.75,-3161.566;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;512;-3429.901,-3005.708;Inherit;False;Property;_BrumeAnimation_WaveFrequency;BrumeAnimation_WaveFrequency;26;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;478;-3410.691,-2917.321;Inherit;False;Property;_BrumeAnimation_RotatorTime;BrumeAnimation_RotatorTime;24;0;Create;True;0;0;False;1;Header(Brume Animation);False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;440;-3463.359,-4223.959;Inherit;False;1837.985;805.8237;Noise;16;414;337;355;372;358;367;373;357;340;375;374;369;376;368;370;341;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;511;-3092.9,-3027.708;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;476;-3125.691,-2908.321;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-3413.359,-4147.363;Inherit;False;Property;_PerlinNoise_Tiling;PerlinNoise_Tiling;19;0;Create;True;0;0;False;0;False;0.1;0.12;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;496;-2945.225,-3073.113;Inherit;False;Constant;_Float17;Float 17;31;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;402;-3134.5,-3262.15;Inherit;False;Property;_BrumeTexture_Tiling;BrumeTexture_Tiling;3;0;Create;True;0;0;False;0;False;2;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;370;-3189.359,-3971.362;Inherit;False;Constant;_Float5;Float 5;29;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;368;-3205.359,-4051.362;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;502;-2902.642,-2941.323;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;509;-3103.198,-2807.591;Inherit;False;Property;_BrumeAnimation_WaveStrength;BrumeAnimation_WaveStrength;25;0;Create;True;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;322;-2864.052,-3280.805;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;376;-2997.359,-3747.361;Inherit;False;Constant;_Float7;Float 7;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;369;-3045.359,-4019.362;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;508;-2755.198,-2869.591;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;495;-2787.225,-3135.113;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;374;-3029.359,-3859.363;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;375;-2853.359,-3859.363;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;515;-2526.992,-2782.576;Inherit;False;Property;_BrumeAnimation_PannerSpeed;BrumeAnimation_PannerSpeed;27;0;Create;True;0;0;False;0;False;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;357;-2693.36,-3619.361;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;373;-2677.36,-3523.361;Inherit;False;Constant;_Float6;Float 6;29;0;Create;True;0;0;False;0;False;0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;473;-2565.087,-3006.273;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;340;-2917.359,-4163.363;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;513;-2203.522,-2906.281;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;372;-2517.36,-3571.361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;358;-2661.36,-3763.361;Inherit;False;Property;_PerlinNoise_PannerSpeed;PerlinNoise_PannerSpeed;20;0;Create;True;0;0;False;0;False;0,0;0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RotatorNode;367;-2661.36,-3987.362;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;355;-2373.36,-3843.362;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;441;-3456.108,-4551.423;Inherit;False;1247.329;286;Texture;5;329;327;328;128;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;474;-1846.652,-3281.863;Inherit;False;Property;_RotatorAnimation;RotatorAnimation?;4;0;Create;True;0;0;False;0;False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;323;-1533.229,-3283.032;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;337;-2181.359,-3875.363;Inherit;True;Property;_PerlinNoise_Texture;PerlinNoise_Texture;18;0;Create;True;0;0;False;1;Header(Noise);False;-1;f6ff7a2b76d9a074eb1c734d22e9cb35;f6ff7a2b76d9a074eb1c734d22e9cb35;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;18;-3406.108,-4500.423;Inherit;True;Property;_BrumeTexture;BrumeTexture;2;0;Create;True;0;0;False;0;False;9338f0dfd38c86b4ca38561628f333f1;d59eab6cece9db54b90d982bd90cd50d;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;328;-3148.764,-4410.318;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-3168.108,-4501.423;Inherit;False;BrumeTexture;-1;True;1;0;SAMPLER2D;0;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;414;-1884.095,-3874.961;Inherit;False;MovingPerlinNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;556;-3473.63,-1621.067;Inherit;False;3539.135;962.1111;Displacement;27;558;267;241;548;239;547;549;553;325;551;552;234;326;406;235;330;411;407;412;415;410;408;409;565;564;567;563;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;327;-2756.24,-4504.806;Inherit;True;Property;_TextureSample2;Texture Sample 2;29;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;409;-3355.213,-952.6536;Inherit;False;Constant;_Float9;Float 9;32;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;410;-3354.486,-884.1597;Inherit;False;Constant;_Float10;Float 10;32;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;415;-3430.982,-1222.016;Inherit;True;414;MovingPerlinNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;408;-3353.007,-1025.97;Inherit;False;Constant;_Float8;Float 8;32;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;329;-2458.779,-4504.79;Inherit;False;BrumeTextureSample;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;412;-2995.063,-881.4346;Inherit;False;Property;_WaveNoiseContrast;WaveNoiseContrast;21;0;Create;True;0;0;False;0;False;4;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;407;-3188.532,-1091.141;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;411;-2761.154,-1033.973;Inherit;False;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;330;-2941.964,-1290.649;Inherit;True;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;406;-2383.528,-1145.33;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;235;-2073.416,-894.5236;Inherit;False;Property;_DisplacementTexture_Multiply;DisplacementTexture_Multiply;13;0;Create;True;0;0;False;0;False;1;42.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;326;-1899.273,-800.6846;Inherit;False;Property;_DisplacementTexture_Contrast;DisplacementTexture_Contrast;14;0;Create;True;0;0;False;0;False;1;1.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;234;-1794.644,-1132.307;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;552;-1377.553,-817.6416;Inherit;False;Constant;_Float24;Float 24;37;0;Create;True;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;325;-1561.812,-1131.805;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.92;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;564;-1759.032,-1460.689;Inherit;False;Property;_BrumeVolumeTransition_Scale;BrumeVolumeTransition_Scale;29;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;565;-1762.032,-1378.689;Inherit;False;Property;_BrumeVolumeTransition_Offset;BrumeVolumeTransition_Offset;30;0;Create;True;0;0;False;0;False;1.3;1.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;551;-1512.554,-901.6416;Inherit;False;Property;_BrumeVolumeTransition_Blend;BrumeVolumeTransition_Blend;28;0;Create;True;0;0;False;1;Header(Brume Volume Transition);False;5;0.4;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;567;-1658.749,-1549.649;Inherit;False;-1;;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;549;-1280.406,-1259.373;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ScaleAndOffsetNode;563;-1415.32,-1489.031;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;553;-1234.554,-881.6416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;547;-1122.263,-1324.785;Inherit;True;Height-based Blending;-1;;2;31c0084e26e17dc4c963d2f60261c022;0;6;13;COLOR;0,0,0,0;False;12;FLOAT;0;False;4;FLOAT;0.79;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;-0.75;False;2;COLOR;15;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;548;-780.4786,-1239.525;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.NormalVertexDataNode;239;-823.0677,-963.9876;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;241;-603.6436,-1044.627;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;555;-3467.056,-2588.599;Inherit;False;2863.207;949.2275;OpacityMask;3;575;420;580;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;267;-439.9783,-1074.166;Inherit;False;Property;_Displacement;Displacement?;12;0;Create;True;0;0;False;1;Header(Displacement);False;0;0;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;580;-3428.763,-2525.398;Inherit;False;1814.792;673.3985;DepthFade;14;574;568;569;702;708;710;711;712;713;714;715;718;719;721;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;558;-170.336,-1158.914;Inherit;False;BrumeDisplacement;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;715;-3382.237,-2097.373;Inherit;False;Property;_Float12;Float 12;41;0;Create;True;0;0;False;0;False;1;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;721;-3341.702,-2326.405;Inherit;False;558;BrumeDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;714;-3236.926,-2143.441;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PosVertexDataNode;718;-3298.142,-2474.373;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;712;-2717.34,-2065.971;Inherit;False;Property;_Float0;Float 0;39;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;713;-2715.34,-1986.97;Inherit;False;Property;_Float11;Float 11;40;0;Create;True;0;0;False;0;False;1;2.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;719;-3084.433,-2422.478;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;710;-3024.091,-2172.143;Inherit;True;Property;_TextureSample1;Texture Sample 1;38;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;569;-2951.432,-2334.794;Inherit;False;Property;_DepthFade_Distance;DepthFade_Distance;31;0;Create;True;0;0;False;1;Header(Depth Fade);False;1;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;711;-2530.341,-2161.971;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;568;-2720.245,-2422.214;Inherit;False;True;False;True;2;1;FLOAT3;0,1,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;702;-2313.442,-2422.219;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;708;-2112.583,-2197.158;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;574;-1882.458,-2197.831;Inherit;False;DepthFade;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;575;-1453.035,-2398.908;Inherit;False;574;DepthFade;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;420;-888.1638,-2402.686;Inherit;False;BrumeOpacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;1535.251,-3977.22;Inherit;False;420;BrumeOpacity;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;554;-6585.927,-2569.837;Inherit;False;1623.811;655.3071;Flipbook Animation;15;321;222;221;223;225;226;439;224;438;437;278;305;279;256;228;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;649;-3472.118,-626.9675;Inherit;False;3150.737;726.5481;Shadow Smooth Edge + Int Shadow;15;665;664;661;666;651;662;659;663;667;641;635;656;668;657;658;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;447;-1595.039,-4221.434;Inherit;False;2062.827;791.6198;Color;14;315;312;451;311;335;449;450;314;313;336;619;652;669;670;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;171;-2196.127,-4700.583;Inherit;False;1849.498;433.2894;Normal Light Dir;11;180;179;177;178;176;175;273;276;277;274;275;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;-835.2373,-4615.015;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;273;-1898.587,-4621.773;Inherit;True;NormalCreate;0;;3;e12f7ae19d416b942820e3932b56220f;0;4;1;SAMPLER2D;;False;2;FLOAT2;0,0;False;3;FLOAT;0.5;False;4;FLOAT;2;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;665;-1330.808,-204.1716;Inherit;False;Property;_ShadowColor;ShadowColor;33;0;Create;True;0;0;False;0;False;0.3584906,0.3584906,0.3584906,0;0.3584905,0.3584905,0.3584905,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;292;1570.667,-4065.881;Inherit;False;315;BrumeColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;669;-246.5496,-3843.657;Inherit;False;Property;_IsShadowOn;IsShadowOn?;36;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;659;-2573.935,-238.2022;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;666;-1933.272,-551.7462;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;449;-1256.752,-3777.319;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;314;-745.4819,-3959.716;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;313;-1067.336,-3958.437;Inherit;False;Property;_BrumeColor_ColorHigh;BrumeColor_ColorHigh;23;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightAttenuation;178;-1107.238,-4343.014;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-2124.795,-4493.019;Inherit;False;Property;_NormalOffset;NormalOffset;17;0;Create;True;0;0;False;0;False;0.5;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-2146.418,-4572.443;Inherit;False;323;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;223;-6042.176,-2311.192;Inherit;False;Property;_Flipbook_Columns;Flipbook_Columns;9;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;658;-2948.976,-437.5001;Inherit;False;2;2;0;FLOAT;0.01;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;221;-5818.177,-2292.605;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;224;-6042.176,-2230.192;Inherit;False;Property;_Flipbook_Rows;Flipbook_Rows;10;0;Create;True;0;0;False;0;False;1;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;662;-3034.935,-214.2022;Inherit;False;Property;_ShadowStep;ShadowStep;34;0;Create;True;0;0;False;0;False;0.36;0.36;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;177;-1123.238,-4615.015;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;312;-1067.795,-4139.609;Inherit;False;Property;_BrumeColor_ColorLow;BrumeColor_ColorLow;22;0;Create;True;0;0;False;1;Header(Brume Color);False;0.4,0.4470589,0.509804,1;0.3690813,0.4680194,0.5471698,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;668;-1612.936,-312.7611;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;226;-6042.176,-2071.191;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;699;615.0576,-3747.955;Inherit;True;Property;_TextureSample0;Texture Sample 0;37;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;635;-3330.506,-387.8255;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;651;-2323.621,-433.0476;Inherit;True;Property;_ShadowNoise;ShadowNoise;35;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;256;-6509.795,-2096.119;Inherit;False;Property;_Flipbook_Time;Flipbook_Time;11;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;311;-1500.663,-3759.336;Inherit;False;180;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;559;1537.525,-3869.71;Inherit;False;558;BrumeDisplacement;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;663;-2879.935,-132.2022;Inherit;False;2;2;0;FLOAT;0.08;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;657;-3122.976,-518.5001;Inherit;False;Property;_LightStep;LightStep;32;0;Create;True;0;0;False;0;False;0.43;0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;222;-5527.44,-2299.564;Inherit;False;UvAnimation;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;723;1723.956,-3971.763;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;336;-1309.333,-3556.901;Inherit;False;329;BrumeTextureSample;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;667;-1933.144,-173.7413;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;451;-1550.008,-3679.298;Inherit;False;Property;_LightNormal;LightNormal?;15;0;Create;True;0;0;False;1;Header(Light Normal);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;707;991.0028,-3808.232;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldNormalVector;176;-1379.239,-4615.015;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;704;668.7614,-3852.433;Inherit;False;574;DepthFade;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;439;-6003.746,-2485.978;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;228;-6535.927,-2488.905;Inherit;False;Property;_Flipbook_Tiling;Flipbook_Tiling;8;0;Create;True;0;0;False;0;False;1;-1.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;321;-5256.088,-2390.177;Inherit;False;Property;_Flipbook_Animation;Flipbook_Animation?;6;0;Create;True;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;619;30.53345,-3955.693;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-551.4112,-4620.581;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;437;-6139.24,-2504.439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;175;-1395.239,-4471.015;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SmoothstepOpNode;656;-2563.976,-550.5;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;438;-6141.24,-2435.439;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;670;-435.5496,-3846.657;Inherit;False;Constant;_Float4;Float 4;42;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;278;-6292.312,-2080.516;Inherit;False;Property;_AnimationPause;AnimationPause;5;0;Create;True;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;664;-1117.808,-320.1716;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;641;-601.3484,-415.2928;Inherit;False;Shadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-6042.176,-2151.192;Inherit;False;Property;_Flipbook_Speed;Flipbook_Speed;7;0;Create;True;0;0;False;0;False;1;8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;661;-965.4487,-549.2021;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-987.7296,-3668.412;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;450;-1435.652,-3840.119;Inherit;False;Constant;_Float2;Float 2;26;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;259.3799,-3961.195;Inherit;False;BrumeColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;305;-6360.477,-2507.532;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;279;-6495.271,-2016.826;Inherit;False;Constant;_Float1;Float 1;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;722;1361.956,-3926.763;Inherit;False;Constant;_Float3;Float 3;41;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;652;-451.4624,-3735.679;Inherit;False;641;Shadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-2127.795,-4417.019;Inherit;False;Property;_NormalStrength;NormalStrength;16;0;Create;True;0;0;False;0;False;2;4.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-2153.318,-4650.386;Inherit;False;128;BrumeTexture;1;0;OBJECT;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;605;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;608;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;606;1915.114,-3994.515;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;BrumeVolume1;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;2;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;2;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;0;False;-1;True;False;6.86;False;-1;3.18;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;0;Cast Shadows;0;  Use Shadow Threshold;0;Receive Shadows;0;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;1;  Phong;1;  Strength;1,False,-1;  Type;1;  Tess;32,False,238;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;False;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;609;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;607;1156.409,-4626.349;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;511;0;501;4
WireConnection;511;1;512;0
WireConnection;476;0;478;0
WireConnection;368;0;341;0
WireConnection;502;0;511;0
WireConnection;502;1;476;0
WireConnection;322;0;402;0
WireConnection;369;0;368;0
WireConnection;369;1;370;0
WireConnection;508;0;502;0
WireConnection;508;1;509;0
WireConnection;495;0;402;0
WireConnection;495;1;496;0
WireConnection;375;0;374;0
WireConnection;375;1;376;0
WireConnection;473;0;322;0
WireConnection;473;1;495;0
WireConnection;473;2;508;0
WireConnection;340;0;341;0
WireConnection;340;1;369;0
WireConnection;513;0;473;0
WireConnection;513;2;515;0
WireConnection;513;1;508;0
WireConnection;372;0;357;0
WireConnection;372;1;373;0
WireConnection;367;0;340;0
WireConnection;367;2;375;0
WireConnection;355;0;367;0
WireConnection;355;2;358;0
WireConnection;355;1;372;0
WireConnection;474;1;322;0
WireConnection;474;0;513;0
WireConnection;323;0;474;0
WireConnection;337;1;355;0
WireConnection;128;0;18;0
WireConnection;414;0;337;1
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
WireConnection;406;0;330;0
WireConnection;406;1;411;0
WireConnection;234;0;406;0
WireConnection;234;1;235;0
WireConnection;325;1;234;0
WireConnection;325;0;326;0
WireConnection;549;0;325;0
WireConnection;563;0;567;0
WireConnection;563;1;564;0
WireConnection;563;2;565;0
WireConnection;553;0;551;0
WireConnection;553;1;552;0
WireConnection;547;12;549;0
WireConnection;547;1;563;0
WireConnection;547;3;553;0
WireConnection;548;0;547;15
WireConnection;241;0;548;0
WireConnection;241;1;239;0
WireConnection;267;0;241;0
WireConnection;558;0;267;0
WireConnection;714;0;715;0
WireConnection;719;0;718;0
WireConnection;719;1;721;0
WireConnection;710;1;714;0
WireConnection;711;0;710;0
WireConnection;711;1;712;0
WireConnection;711;2;713;0
WireConnection;568;1;719;0
WireConnection;568;0;569;0
WireConnection;702;0;568;0
WireConnection;702;1;711;0
WireConnection;708;0;702;0
WireConnection;574;0;708;0
WireConnection;420;0;575;0
WireConnection;179;0;177;0
WireConnection;179;1;178;0
WireConnection;273;1;274;0
WireConnection;273;2;275;0
WireConnection;273;3;276;0
WireConnection;273;4;277;0
WireConnection;669;1;670;0
WireConnection;669;0;652;0
WireConnection;659;0;635;0
WireConnection;659;1;663;0
WireConnection;659;2;662;0
WireConnection;666;0;656;0
WireConnection;666;1;651;1
WireConnection;449;0;450;0
WireConnection;449;1;311;0
WireConnection;449;2;451;0
WireConnection;314;0;312;0
WireConnection;314;1;313;0
WireConnection;314;2;335;0
WireConnection;658;1;657;0
WireConnection;221;0;439;0
WireConnection;221;1;223;0
WireConnection;221;2;224;0
WireConnection;221;3;225;0
WireConnection;221;5;226;0
WireConnection;177;0;176;0
WireConnection;177;1;175;0
WireConnection;668;0;667;0
WireConnection;668;1;659;0
WireConnection;226;0;278;0
WireConnection;663;1;662;0
WireConnection;222;0;221;0
WireConnection;723;0;324;0
WireConnection;667;0;659;0
WireConnection;667;1;651;1
WireConnection;707;0;704;0
WireConnection;707;1;699;0
WireConnection;439;0;437;0
WireConnection;439;1;438;0
WireConnection;321;0;222;0
WireConnection;619;0;314;0
WireConnection;619;1;669;0
WireConnection;180;0;179;0
WireConnection;437;0;305;1
WireConnection;656;0;635;0
WireConnection;656;1;657;0
WireConnection;656;2;658;0
WireConnection;438;0;305;2
WireConnection;278;1;256;0
WireConnection;278;0;279;0
WireConnection;664;0;668;0
WireConnection;664;1;665;0
WireConnection;641;0;661;0
WireConnection;661;0;656;0
WireConnection;661;1;664;0
WireConnection;335;0;449;0
WireConnection;335;1;336;0
WireConnection;315;0;619;0
WireConnection;305;0;228;0
WireConnection;606;2;292;0
WireConnection;606;3;723;0
WireConnection;606;5;559;0
ASEEND*/
//CHKSM=E3CFB5E1BA6061ABBADCDC5E14BE1B2DFD5F035F
// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin]_In_Out_Brume("In_Out_Brume", Range( 0 , 1)) = 0
		_DepthFadeAnimated_DistanceMax("DepthFadeAnimated_DistanceMax", Float) = 0.3
		_DepthFadeAnimated_DistanceMin("DepthFadeAnimated_DistanceMin", Float) = 0.2
		_TimeScale("TimeScale", Float) = 1
		_Float4("Float 4", Float) = 1
		_WaterColor("WaterColor", Color) = (0.4823529,0.7529412,0.7294118,0)
		_Color4("Color 4", Color) = (0.4823529,0.7529412,0.7294118,0)
		_WaterFoamNoise_Panner("WaterFoamNoise_Panner", Vector) = (0.1,0.1,0,0)
		_WaterFoam_Panner("WaterFoam_Panner", Vector) = (0.1,0.1,0,0)
		_WaterFoamNoise_PannerTime("WaterFoamNoise_PannerTime", Float) = 0.1
		_Color1("Color 1", Color) = (0.01960784,0.04705882,0.04313726,0)
		_Color0("Color 0", Color) = (0.01960784,0.04705882,0.04313726,0)
		_WaterFoam_PannerTime("WaterFoam_PannerTime", Float) = 0.1
		_Vector2("Vector 2", Vector) = (0.1,0.1,0,0)
		_PaintGrunge("PaintGrunge", 2D) = "white" {}
		_WaterFoam_Texture("WaterFoam_Texture", 2D) = "white" {}
		_WaterFoamNoise_Texture("WaterFoamNoise_Texture", 2D) = "white" {}
		_WaterFoam_Tiling("WaterFoam_Tiling", Float) = 1
		_WaterFoamNoise_Tiling("WaterFoamNoise_Tiling", Float) = 1
		_Float8("Float 8", Float) = 1
		_Float1("Float 1", Float) = 1
		_Float7("Float 7", Float) = 0.2
		_Color2("Color 2", Color) = (0.490566,0.490566,0.490566,0)
		_Float9("Float 9", Range( 0 , 1)) = 0
		_Float2("Float 2", Float) = 0
		_FondVisible("FondVisible", Float) = 1
		[ASEEnd]_Float5("Float 5", Float) = 1

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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _WaterColor;
			float4 _Color4;
			float4 _Color2;
			float4 _Color1;
			float4 _Color0;
			float2 _WaterFoam_Panner;
			float2 _WaterFoamNoise_Panner;
			float2 _Vector2;
			float _WaterFoam_PannerTime;
			float _In_Out_Brume;
			float _Float4;
			float _Float2;
			float _Float1;
			float _Float8;
			float _TimeScale;
			float _DepthFadeAnimated_DistanceMin;
			float _DepthFadeAnimated_DistanceMax;
			float _Float7;
			float _WaterFoamNoise_Tiling;
			float _Float9;
			float _WaterFoamNoise_PannerTime;
			float _WaterFoam_Tiling;
			float _Float5;
			float _FondVisible;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _PaintGrunge;
			sampler2D _WaterFoam_Texture;
			sampler2D _WaterFoamNoise_Texture;
			uniform float4 _CameraDepthTexture_TexelSize;


						
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
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
				float mulTime157 = _TimeParameters.x * _Float4;
				float temp_output_159_0 = ( cos( mulTime157 ) + 0.5 );
				float4 lerpResult162 = lerp( _WaterColor , _Color4 , temp_output_159_0);
				float4 lerpResult163 = lerp( _Color1 , _Color0 , temp_output_159_0);
				float2 temp_cast_0 = (_Float5).xx;
				float2 texCoord67 = IN.ase_texcoord3.xy * temp_cast_0 + float2( 0,0 );
				float2 panner64 = ( 1.0 * _Time.y * _Vector2 + texCoord67);
				float4 lerpResult61 = lerp( lerpResult162 , lerpResult163 , tex2D( _PaintGrunge, panner64 ).r);
				float4 color146 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
				float mulTime77 = _TimeParameters.x * _WaterFoam_PannerTime;
				float2 temp_cast_1 = (_WaterFoam_Tiling).xx;
				float2 texCoord81 = IN.ase_texcoord3.xy * temp_cast_1 + float2( 0,0 );
				float2 panner76 = ( mulTime77 * _WaterFoam_Panner + texCoord81);
				float mulTime87 = _TimeParameters.x * _WaterFoamNoise_PannerTime;
				float2 temp_cast_2 = (_WaterFoamNoise_Tiling).xx;
				float2 texCoord86 = IN.ase_texcoord3.xy * temp_cast_2 + float2( 0,0 );
				float2 panner88 = ( mulTime87 * _WaterFoamNoise_Panner + texCoord86);
				float4 tex2DNode73 = tex2D( _WaterFoamNoise_Texture, panner88 );
				float WaterFoamNoise_Texture127 = tex2DNode73.r;
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float mulTime12 = _TimeParameters.x * _TimeScale;
				float temp_output_94_0 = ( cos( mulTime12 ) + 0.5 );
				float lerpResult135 = lerp( ( _Float7 + _DepthFadeAnimated_DistanceMax ) , ( _DepthFadeAnimated_DistanceMin + _Float7 ) , temp_output_94_0);
				float screenDepth122 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth122 = abs( ( screenDepth122 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( lerpResult135 ) );
				float DepthFade109 = ( 1.0 - step( ( ( WaterFoamNoise_Texture127 / distanceDepth122 ) * ( 1.0 - distanceDepth122 ) ) , _Float8 ) );
				float lerpResult16 = lerp( _DepthFadeAnimated_DistanceMax , _DepthFadeAnimated_DistanceMin , temp_output_94_0);
				float screenDepth5 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth5 = abs( ( screenDepth5 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( lerpResult16 ) );
				float clampResult134 = clamp( ( ( ( tex2D( _WaterFoam_Texture, panner76 ).r * DepthFade109 ) + ( 1.0 - step( ( ( tex2DNode73.r / distanceDepth5 ) * ( 1.0 - distanceDepth5 ) ) , _Float1 ) ) ) * 10.0 ) , 0.0 , 1.0 );
				float4 lerpResult145 = lerp( lerpResult61 , color146 , clampResult134);
				float screenDepth137 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth137 = abs( ( screenDepth137 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _Float2 ) );
				float clampResult144 = clamp( ( 1.0 - distanceDepth137 ) , 0.0 , 1.0 );
				float4 temp_output_147_0 = ( lerpResult145 + ( ( clampResult144 * _Color2 ) + clampResult134 ) );
				float grayscale168 = Luminance(temp_output_147_0.rgb);
				float4 temp_cast_4 = (grayscale168).xxxx;
				float4 lerpResult166 = lerp( temp_cast_4 , temp_output_147_0 , _In_Out_Brume);
				
				float screenDepth149 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth149 = abs( ( screenDepth149 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _FondVisible ) );
				float clampResult150 = clamp( distanceDepth149 , 0.0 , 1.0 );
				float clampResult155 = clamp( ( ( clampResult134 + _Float9 ) + clampResult150 ) , 0.0 , 1.0 );
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = lerpResult166.rgb;
				float Alpha = clampResult155;
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
			#define REQUIRE_DEPTH_TEXTURE 1

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
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _WaterColor;
			float4 _Color4;
			float4 _Color2;
			float4 _Color1;
			float4 _Color0;
			float2 _WaterFoam_Panner;
			float2 _WaterFoamNoise_Panner;
			float2 _Vector2;
			float _WaterFoam_PannerTime;
			float _In_Out_Brume;
			float _Float4;
			float _Float2;
			float _Float1;
			float _Float8;
			float _TimeScale;
			float _DepthFadeAnimated_DistanceMin;
			float _DepthFadeAnimated_DistanceMax;
			float _Float7;
			float _WaterFoamNoise_Tiling;
			float _Float9;
			float _WaterFoamNoise_PannerTime;
			float _WaterFoam_Tiling;
			float _Float5;
			float _FondVisible;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _WaterFoam_Texture;
			sampler2D _WaterFoamNoise_Texture;
			uniform float4 _CameraDepthTexture_TexelSize;


			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
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

				float mulTime77 = _TimeParameters.x * _WaterFoam_PannerTime;
				float2 temp_cast_0 = (_WaterFoam_Tiling).xx;
				float2 texCoord81 = IN.ase_texcoord2.xy * temp_cast_0 + float2( 0,0 );
				float2 panner76 = ( mulTime77 * _WaterFoam_Panner + texCoord81);
				float mulTime87 = _TimeParameters.x * _WaterFoamNoise_PannerTime;
				float2 temp_cast_1 = (_WaterFoamNoise_Tiling).xx;
				float2 texCoord86 = IN.ase_texcoord2.xy * temp_cast_1 + float2( 0,0 );
				float2 panner88 = ( mulTime87 * _WaterFoamNoise_Panner + texCoord86);
				float4 tex2DNode73 = tex2D( _WaterFoamNoise_Texture, panner88 );
				float WaterFoamNoise_Texture127 = tex2DNode73.r;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float mulTime12 = _TimeParameters.x * _TimeScale;
				float temp_output_94_0 = ( cos( mulTime12 ) + 0.5 );
				float lerpResult135 = lerp( ( _Float7 + _DepthFadeAnimated_DistanceMax ) , ( _DepthFadeAnimated_DistanceMin + _Float7 ) , temp_output_94_0);
				float screenDepth122 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth122 = abs( ( screenDepth122 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( lerpResult135 ) );
				float DepthFade109 = ( 1.0 - step( ( ( WaterFoamNoise_Texture127 / distanceDepth122 ) * ( 1.0 - distanceDepth122 ) ) , _Float8 ) );
				float lerpResult16 = lerp( _DepthFadeAnimated_DistanceMax , _DepthFadeAnimated_DistanceMin , temp_output_94_0);
				float screenDepth5 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth5 = abs( ( screenDepth5 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( lerpResult16 ) );
				float clampResult134 = clamp( ( ( ( tex2D( _WaterFoam_Texture, panner76 ).r * DepthFade109 ) + ( 1.0 - step( ( ( tex2DNode73.r / distanceDepth5 ) * ( 1.0 - distanceDepth5 ) ) , _Float1 ) ) ) * 10.0 ) , 0.0 , 1.0 );
				float screenDepth149 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth149 = abs( ( screenDepth149 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _FondVisible ) );
				float clampResult150 = clamp( distanceDepth149 , 0.0 , 1.0 );
				float clampResult155 = clamp( ( ( clampResult134 + _Float9 ) + clampResult150 ) , 0.0 , 1.0 );
				
				float Alpha = clampResult155;
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
			#define REQUIRE_DEPTH_TEXTURE 1

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
				float4 ase_texcoord3 : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _WaterColor;
			float4 _Color4;
			float4 _Color2;
			float4 _Color1;
			float4 _Color0;
			float2 _WaterFoam_Panner;
			float2 _WaterFoamNoise_Panner;
			float2 _Vector2;
			float _WaterFoam_PannerTime;
			float _In_Out_Brume;
			float _Float4;
			float _Float2;
			float _Float1;
			float _Float8;
			float _TimeScale;
			float _DepthFadeAnimated_DistanceMin;
			float _DepthFadeAnimated_DistanceMax;
			float _Float7;
			float _WaterFoamNoise_Tiling;
			float _Float9;
			float _WaterFoamNoise_PannerTime;
			float _WaterFoam_Tiling;
			float _Float5;
			float _FondVisible;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _WaterFoam_Texture;
			sampler2D _WaterFoamNoise_Texture;
			uniform float4 _CameraDepthTexture_TexelSize;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
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

				float mulTime77 = _TimeParameters.x * _WaterFoam_PannerTime;
				float2 temp_cast_0 = (_WaterFoam_Tiling).xx;
				float2 texCoord81 = IN.ase_texcoord2.xy * temp_cast_0 + float2( 0,0 );
				float2 panner76 = ( mulTime77 * _WaterFoam_Panner + texCoord81);
				float mulTime87 = _TimeParameters.x * _WaterFoamNoise_PannerTime;
				float2 temp_cast_1 = (_WaterFoamNoise_Tiling).xx;
				float2 texCoord86 = IN.ase_texcoord2.xy * temp_cast_1 + float2( 0,0 );
				float2 panner88 = ( mulTime87 * _WaterFoamNoise_Panner + texCoord86);
				float4 tex2DNode73 = tex2D( _WaterFoamNoise_Texture, panner88 );
				float WaterFoamNoise_Texture127 = tex2DNode73.r;
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float mulTime12 = _TimeParameters.x * _TimeScale;
				float temp_output_94_0 = ( cos( mulTime12 ) + 0.5 );
				float lerpResult135 = lerp( ( _Float7 + _DepthFadeAnimated_DistanceMax ) , ( _DepthFadeAnimated_DistanceMin + _Float7 ) , temp_output_94_0);
				float screenDepth122 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth122 = abs( ( screenDepth122 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( lerpResult135 ) );
				float DepthFade109 = ( 1.0 - step( ( ( WaterFoamNoise_Texture127 / distanceDepth122 ) * ( 1.0 - distanceDepth122 ) ) , _Float8 ) );
				float lerpResult16 = lerp( _DepthFadeAnimated_DistanceMax , _DepthFadeAnimated_DistanceMin , temp_output_94_0);
				float screenDepth5 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth5 = abs( ( screenDepth5 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( lerpResult16 ) );
				float clampResult134 = clamp( ( ( ( tex2D( _WaterFoam_Texture, panner76 ).r * DepthFade109 ) + ( 1.0 - step( ( ( tex2DNode73.r / distanceDepth5 ) * ( 1.0 - distanceDepth5 ) ) , _Float1 ) ) ) * 10.0 ) , 0.0 , 1.0 );
				float screenDepth149 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth149 = abs( ( screenDepth149 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _FondVisible ) );
				float clampResult150 = clamp( distanceDepth149 , 0.0 , 1.0 );
				float clampResult155 = clamp( ( ( clampResult134 + _Float9 ) + clampResult150 ) , 0.0 , 1.0 );
				
				float Alpha = clampResult155;
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
1920;0;1920;1019;3705.826;-972.4897;1.9;True;False
Node;AmplifyShaderEditor.RangedFloatNode;91;-3001.105,1178.431;Inherit;False;Property;_WaterFoamNoise_Tiling;WaterFoamNoise_Tiling;18;0;Create;True;0;0;False;0;False;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2980.098,1422.38;Inherit;False;Property;_WaterFoamNoise_PannerTime;WaterFoamNoise_PannerTime;9;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-3142.323,1757.348;Inherit;False;Property;_TimeScale;TimeScale;3;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;89;-2772.099,1294.38;Inherit;False;Property;_WaterFoamNoise_Panner;WaterFoamNoise_Panner;7;0;Create;True;0;0;False;0;False;0.1,0.1;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleTimeNode;12;-2986.323,1759.348;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;87;-2692.099,1422.38;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;86;-2754.89,1159.82;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CosOpNode;15;-2826.323,1759.348;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;88;-2484.098,1278.38;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2722.323,1851.348;Inherit;False;Constant;_Float0;Float 0;15;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-2886.867,1672.369;Inherit;False;Property;_DepthFadeAnimated_DistanceMax;DepthFadeAnimated_DistanceMax;1;0;Create;True;0;0;False;0;False;0.3;0.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-2760.467,2215.431;Inherit;False;Property;_Float7;Float 7;21;0;Create;True;0;0;False;0;False;0.2;0.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-2886.867,1592.368;Inherit;False;Property;_DepthFadeAnimated_DistanceMin;DepthFadeAnimated_DistanceMin;2;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;124;-2520.467,2146.431;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;73;-2308.099,1246.38;Inherit;True;Property;_WaterFoamNoise_Texture;WaterFoamNoise_Texture;16;0;Create;True;0;0;False;0;False;-1;1cb5d7a8b79999d4b8356e740bbf6667;1cb5d7a8b79999d4b8356e740bbf6667;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;94;-2570.323,1759.348;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;136;-2519.122,2046.891;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;127;-1993.036,1147.557;Inherit;False;WaterFoamNoise_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;135;-2353.197,2150.446;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;122;-2185.272,2125.959;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-2226.85,1910.276;Inherit;False;127;WaterFoamNoise_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;126;-1928.833,2125.965;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;129;-1911.029,1916.248;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-1720.523,2018.976;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-1681.523,2163.976;Inherit;False;Property;_Float8;Float 8;19;0;Create;True;0;0;False;0;False;1;0.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-2406.867,1624.368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;78;-2044.041,509.2088;Inherit;False;Property;_WaterFoam_PannerTime;WaterFoam_PannerTime;12;0;Create;True;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;131;-1517.523,2018.976;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-2047.078,282.1979;Inherit;False;Property;_WaterFoam_Tiling;WaterFoam_Tiling;17;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;5;-2232.099,1516.38;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;81;-1851.863,263.5872;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;77;-1802.041,513.2088;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;133;-1382.524,2018.976;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;99;-1909.098,1275.38;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;72;-1928.098,1516.38;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;79;-1843.346,387.0695;Inherit;False;Property;_WaterFoam_Panner;WaterFoam_Panner;8;0;Create;True;0;0;False;0;False;0.1,0.1;0.1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;107;-1653.098,1515.38;Inherit;False;Property;_Float1;Float 1;20;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;76;-1603.346,369.5695;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;101;-1692.098,1370.38;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-1206.553,2015.653;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;70;-1418.977,340.8132;Inherit;True;Property;_WaterFoam_Texture;WaterFoam_Texture;15;0;Create;True;0;0;False;0;False;-1;dd7a2436d6b20604c8b301910e3cf12e;dd7a2436d6b20604c8b301910e3cf12e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;105;-1489.098,1370.38;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;-1387.25,612.7252;Inherit;False;109;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1043.848,345.9278;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;106;-1354.098,1370.38;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;108;-731.6126,614.6559;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-554.8132,615.3842;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-87.03255,896.9572;Inherit;False;Property;_FondVisible;FondVisible;25;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;134;-388.2206,615.4968;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;35.41905,699.0421;Inherit;False;Property;_Float9;Float 9;23;0;Create;True;0;0;False;0;False;0;0.296;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;149;92.89912,877.7958;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;142;347.9187,618.642;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;150;345.4674,876.9572;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;533.8294,617.7595;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;-1154.423,-1397.145;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;166;1280.485,-142.4813;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;162;-990.9677,-1532.125;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-1306.542,-187.8966;Inherit;False;Property;_Float2;Float 2;24;0;Create;True;0;0;False;0;False;0;0.62;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;63;-998.8088,-642.6371;Inherit;False;Property;_Vector2;Vector 2;13;0;Create;True;0;0;False;0;False;0.1,0.1;0.01,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;140;-533.4937,-162.8145;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;168;919.9464,-267.9315;Inherit;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;146;23.21064,-368.9023;Inherit;False;Constant;_Color3;Color 3;21;0;Create;True;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;60;-578.1837,-688.6614;Inherit;True;Property;_PaintGrunge;PaintGrunge;14;0;Create;True;0;0;False;0;False;-1;88d75bbfdb8a26849988713b4599646a;88d75bbfdb8a26849988713b4599646a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;160;-1726.423,-1399.145;Inherit;False;Property;_Float4;Float 4;4;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;145;306.2107,-386.9023;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;167;918.5555,-24.07098;Inherit;False;Property;_In_Out_Brume;In_Out_Brume;0;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;138;-202.527,48.13414;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;157;-1570.423,-1397.145;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;165;-1275.588,-1017.781;Inherit;False;Property;_Color0;Color 0;11;0;Create;True;0;0;False;0;False;0.01960784,0.04705882,0.04313726,0;0.1961106,0.3679244,0.3421523,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;61;-230.787,-820.0363;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-1306.423,-1305.145;Inherit;False;Constant;_Float3;Float 3;15;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;67;-1051.271,-765.5463;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;155;679.0522,617.5028;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CosOpNode;158;-1410.423,-1397.145;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;20;-1260.887,-1828.092;Inherit;False;Property;_WaterColor;WaterColor;5;0;Create;True;0;0;False;0;False;0.4823529,0.7529412,0.7294118,0;0.480598,0.7547169,0.7279629,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;139;-842.4454,-213.6356;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;64;-758.8087,-660.137;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-1236.802,-746.1631;Inherit;False;Property;_Float5;Float 5;26;0;Create;True;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;141;-825.4938,-52.81453;Inherit;False;Property;_Color2;Color 2;22;0;Create;True;0;0;False;0;False;0.490566,0.490566,0.490566,0;0.5702208,0.7933133,0.8113207,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;137;-1085.255,-213.6481;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;62;-1280.087,-1199.224;Inherit;False;Property;_Color1;Color 1;10;0;Create;True;0;0;False;0;False;0.01960784,0.04705882,0.04313726,0;0.01960784,0.04705874,0.04313717,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;147;623.4838,-116.1481;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;164;-1262.031,-1649.682;Inherit;False;Property;_Color4;Color 4;6;0;Create;True;0;0;False;0;False;0.4823529,0.7529412,0.7294118,0;0.5098037,0.7529412,0.7294118,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;163;-989.8137,-1231.691;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;144;-695.801,-208.3941;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-1088.311,344.9122;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1553.671,122.497;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;Water;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;1;5;False;-1;10;False;-1;1;1;False;-1;10;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;1;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
WireConnection;12;0;14;0
WireConnection;87;0;90;0
WireConnection;86;0;91;0
WireConnection;15;0;12;0
WireConnection;88;0;86;0
WireConnection;88;2;89;0
WireConnection;88;1;87;0
WireConnection;124;0;125;0
WireConnection;124;1;10;0
WireConnection;73;1;88;0
WireConnection;94;0;15;0
WireConnection;94;1;96;0
WireConnection;136;0;11;0
WireConnection;136;1;125;0
WireConnection;127;0;73;1
WireConnection;135;0;124;0
WireConnection;135;1;136;0
WireConnection;135;2;94;0
WireConnection;122;0;135;0
WireConnection;126;0;122;0
WireConnection;129;0;128;0
WireConnection;129;1;122;0
WireConnection;130;0;129;0
WireConnection;130;1;126;0
WireConnection;16;0;10;0
WireConnection;16;1;11;0
WireConnection;16;2;94;0
WireConnection;131;0;130;0
WireConnection;131;1;132;0
WireConnection;5;0;16;0
WireConnection;81;0;85;0
WireConnection;77;0;78;0
WireConnection;133;0;131;0
WireConnection;99;0;73;1
WireConnection;99;1;5;0
WireConnection;72;0;5;0
WireConnection;76;0;81;0
WireConnection;76;2;79;0
WireConnection;76;1;77;0
WireConnection;101;0;99;0
WireConnection;101;1;72;0
WireConnection;109;0;133;0
WireConnection;70;1;76;0
WireConnection;105;0;101;0
WireConnection;105;1;107;0
WireConnection;111;0;70;1
WireConnection;111;1;110;0
WireConnection;106;0;105;0
WireConnection;108;0;111;0
WireConnection;108;1;106;0
WireConnection;98;0;108;0
WireConnection;134;0;98;0
WireConnection;149;0;153;0
WireConnection;142;0;134;0
WireConnection;142;1;143;0
WireConnection;150;0;149;0
WireConnection;156;0;142;0
WireConnection;156;1;150;0
WireConnection;159;0;158;0
WireConnection;159;1;161;0
WireConnection;166;0;168;0
WireConnection;166;1;147;0
WireConnection;166;2;167;0
WireConnection;162;0;20;0
WireConnection;162;1;164;0
WireConnection;162;2;159;0
WireConnection;140;0;144;0
WireConnection;140;1;141;0
WireConnection;168;0;147;0
WireConnection;60;1;64;0
WireConnection;145;0;61;0
WireConnection;145;1;146;0
WireConnection;145;2;134;0
WireConnection;138;0;140;0
WireConnection;138;1;134;0
WireConnection;157;0;160;0
WireConnection;61;0;162;0
WireConnection;61;1;163;0
WireConnection;61;2;60;1
WireConnection;67;0;169;0
WireConnection;155;0;156;0
WireConnection;158;0;157;0
WireConnection;139;0;137;0
WireConnection;64;0;67;0
WireConnection;64;2;63;0
WireConnection;137;0;148;0
WireConnection;147;0;145;0
WireConnection;147;1;138;0
WireConnection;163;0;62;0
WireConnection;163;1;165;0
WireConnection;163;2;159;0
WireConnection;144;0;139;0
WireConnection;1;2;166;0
WireConnection;1;3;155;0
ASEEND*/
//CHKSM=84F796ABCE0D320254CA2F144B1E85F517B76059
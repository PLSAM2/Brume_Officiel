// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "TerrainMaterialShader"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Header(OutInBrume)]_Out_or_InBrume("Out_or_InBrume?", Range( 0 , 1)) = 0
		[Header(Debug)]_LightDebug("LightDebug", Range( 0 , 1)) = 0
		_NormalDebug("NormalDebug", Range( 0 , 1)) = 0
		_GrayscaleDebug("GrayscaleDebug", Range( 0 , 1)) = 0
		_DebugVertexPaint("DebugVertexPaint", Range( 0 , 1)) = 1
		_DebugTextureArray("DebugTextureArray", 2DArray) = "white" {}
		_DebugTextureTiling("DebugTextureTiling", Float) = 10
		_ShadowNoise("ShadowNoise", 2D) = "white" {}
		_ScreenBasedShadowNoise("ScreenBasedShadowNoise?", Range( 0 , 1)) = 0
		_ShadowNoisePanner("ShadowNoisePanner", Vector) = (0.01,0,0,0)
		_StepShadow("StepShadow", Float) = 0.1
		_StepAttenuation("StepAttenuation", Float) = -0.07
		_ShadowColor("ShadowColor", Color) = (0.8018868,0.8018868,0.8018868,0)
		[Header(Shadow and NoiseEdge)]_Noise_Tiling("Noise_Tiling", Float) = 1
		_InBrumeDrippingNoise("InBrumeDrippingNoise", 2D) = "white" {}
		_TA_1_Textures("TA_1_Textures", 2DArray) = "white" {}
		_TA_1_Grunges("TA_1_Grunges", 2DArray) = "white" {}
		_T1_ColorCorrection("T1_ColorCorrection", Color) = (1,1,1,0)
		_T1_PaintGrunge_Tiling("T1_PaintGrunge_Tiling", Float) = 1
		_T1_PaintGrunge_Contrast("T1_PaintGrunge_Contrast", Float) = 0
		_T1_PaintGrunge_Multiply("T1_PaintGrunge_Multiply", Float) = 0
		_T1_NonAnimatedGrunge_Tiling("T1_NonAnimatedGrunge_Tiling", Float) = 1
		[Header(Paper)]_T1_AnimatedGrunge("T1_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T1_AnimatedGrunge_Flipbook_Columns("T1_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T1_AnimatedGrunge_Flipbook_Rows("T1_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T1_AnimatedGrunge_Flipbook_Speed("T1_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T1_AnimatedGrunge_Contrast("T1_AnimatedGrunge_Contrast", Float) = 1.58
		_T1_AnimatedGrunge_Multiply("T1_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Custom Rim Light)]_T1_CustomRimLight("T1_CustomRimLight?", Range( 0 , 1)) = 0
		_T1_CutomRimLight_Texture("T1_CutomRimLight_Texture?", Range( 0 , 1)) = 1
		_T1_CustomRimLight_Color("T1_CustomRimLight_Color", Color) = (1,1,1,0)
		_T1_CustomRimLight_Opacity("T1_CustomRimLight_Opacity", Range( 0 , 1)) = 1
		_T1_IB_ColorCorrection("T1_IB_ColorCorrection", Color) = (1,1,1,0)
		_T1_IB_ShadowColor("T1_IB_ShadowColor", Color) = (0.5283019,0.5283019,0.5283019,0)
		_T1_IB_BackColor("T1_IB_BackColor", Color) = (1,1,1,0)
		_T1_IB_ShadowDrippingNoise_Smoothstep("T1_IB_ShadowDrippingNoise_Smoothstep", Range( 0.001 , 0.5)) = 0.2
		_T1_IB_ShadowDrippingNoise_Step("T1_IB_ShadowDrippingNoise_Step", Range( 0 , 1)) = 0
		_DrippingNoise_Tiling3("T1_IB_ShadowDrippingNoise_Tiling", Float) = 1
		_T1_IB_ShadowDrippingNoise_Offset("T1_IB_ShadowDrippingNoise_Offset", Vector) = (0,0,0,0)
		_T1_IB_ShadowDrippingNoise_Transition("T1_IB_ShadowDrippingNoise_Transition", Range( 0 , 1)) = 1
		_T1_IB_NormalDrippingNoise_Smoothstep("T1_IB_NormalDrippingNoise_Smoothstep", Range( 0 , 1)) = 0.01
		_T1_IB_NormalDrippingNoise_Step("T1_IB_NormalDrippingNoise_Step", Range( 0 , 1)) = 0.45
		_T1_IB_NormalDrippingNoise_Tiling("T1_IB_NormalDrippingNoise_Tiling", Float) = 1
		_T1_IB_NormalDrippingNoise_Offset("T1_IB_NormalDrippingNoise_Offset", Vector) = (0,0,0,0)
		_T1_IB_ShadowGrunge_Tiling("T1_IB_ShadowGrunge_Tiling", Float) = 0.2
		_T1_IB_ShadowGrunge_Contrast("T1_IB_ShadowGrunge_Contrast", Float) = -3.38
		_T1_IB_NormalGrunge_Tiling("T1_IB_NormalGrunge_Tiling", Float) = 0.2
		_T1_IB_NormalGrunge_Contrast("T1_IB_NormalGrunge_Contrast", Float) = 2.4
		_TA_2_Textures("TA_2_Textures", 2DArray) = "white" {}
		_TA_2_Grunges("TA_2_Grunges", 2DArray) = "white" {}
		_T2_ColorCorrection("T2_ColorCorrection", Color) = (1,1,1,0)
		_T2_PaintGrunge_Tiling("T2_PaintGrunge_Tiling", Float) = 1
		_T2_PaintGrunge_Contrast("T2_PaintGrunge_Contrast", Float) = 0
		_T2_PaintGrunge_Multiply("T2_PaintGrunge_Multiply", Float) = 0
		_T2_NonAnimatedGrunge_Tiling("T2_NonAnimatedGrunge_Tiling", Float) = 1
		[Header(Paper)]_T2_AnimatedGrunge("T2_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T2_AnimatedGrunge_Flipbook_Columns("T2_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T2_AnimatedGrunge_Flipbook_Rows("T2_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T2_AnimatedGrunge_Flipbook_Speed("T2_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T2_AnimatedGrunge_Contrast("T2_AnimatedGrunge_Contrast", Float) = 1.58
		_T2_AnimatedGrunge_Multiply("T2_AnimatedGrunge_Multiply", Float) = 1.58
		[Header(Custom Rim Light)]_T2_CustomRimLight("T2_CustomRimLight?", Range( 0 , 1)) = 0
		_T2_CutomRimLight_Texture("T2_CutomRimLight_Texture?", Range( 0 , 1)) = 1
		_T2_CustomRimLight_Color("T2_CustomRimLight_Color", Color) = (1,1,1,0)
		_T2_CustomRimLight_Opacity("T2_CustomRimLight_Opacity", Range( 0 , 1)) = 1
		_T2_IB_ColorCorrection("T2_IB_ColorCorrection", Color) = (1,1,1,0)
		_T2_IB_ShadowColor("T2_IB_ShadowColor", Color) = (0.5283019,0.5283019,0.5283019,0)
		_T2_IB_BackColor("T2_IB_BackColor", Color) = (1,1,1,0)
		_T2_IB_ShadowDrippingNoise_Smoothstep("T2_IB_ShadowDrippingNoise_Smoothstep", Range( 0.001 , 0.5)) = 0.2
		_T2_IB_ShadowDrippingNoise_Step("T2_IB_ShadowDrippingNoise_Step", Range( 0 , 1)) = 0
		_DrippingNoise_Tiling4("T2_IB_ShadowDrippingNoise_Tiling", Float) = 1
		_T2_IB_ShadowDrippingNoise_Offset("T2_IB_ShadowDrippingNoise_Offset", Vector) = (0,0,0,0)
		_T2_IB_ShadowDrippingNoise_Transition("T2_IB_ShadowDrippingNoise_Transition", Range( 0 , 1)) = 1
		_T2_IB_NormalDrippingNoise_Smoothstep("T2_IB_NormalDrippingNoise_Smoothstep", Range( 0 , 1)) = 0.01
		_T2_IB_NormalDrippingNoise_Step("T2_IB_NormalDrippingNoise_Step", Range( 0 , 1)) = 0.45
		_T2_IB_NormalDrippingNoise_Tiling("T2_IB_NormalDrippingNoise_Tiling", Float) = 1
		_T2_IB_NormalDrippingNoise_Offset("T2_IB_NormalDrippingNoise_Offset", Vector) = (0,0,0,0)
		_T2_IB_ShadowGrunge_Tiling("T2_IB_ShadowGrunge_Tiling", Float) = 0.2
		_T2_IB_ShadowGrunge_Contrast("T2_IB_ShadowGrunge_Contrast", Float) = -3.38
		_T2_IB_NormalGrunge_Tiling("T2_IB_NormalGrunge_Tiling", Float) = 0.2
		_T2_IB_NormalGrunge_Contrast("T2_IB_NormalGrunge_Contrast", Float) = 2.4
		_TA_3_Textures("TA_3_Textures", 2DArray) = "white" {}
		_TA_3_Grunges("TA_3_Grunges", 2DArray) = "white" {}
		[Header(Paper)]_T3_AnimatedGrunge("T3_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T3_NonAnimatedGrunge_Tiling("T3_NonAnimatedGrunge_Tiling", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Columns("T3_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Rows("T3_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T3_AnimatedGrunge_Flipbook_Speed("T3_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T3_AnimatedGrunge_Contrast("T3_AnimatedGrunge_Contrast", Float) = 1.58
		_T3_AnimatedGrunge_Multiply("T3_AnimatedGrunge_Multiply", Float) = 1.58
		_T3_PaintGrunge_Tiling("T3_PaintGrunge_Tiling", Float) = 1
		_T3_PaintGrunge_Contrast("T3_PaintGrunge_Contrast", Float) = 0
		_T3_PaintGrunge_Multiply("T3_PaintGrunge_Multiply", Float) = 0
		[Header(Custom Rim Light)]_T3_CustomRimLight("T3_CustomRimLight?", Range( 0 , 1)) = 0
		_T3_CustomRimLight_Color("T3_CustomRimLight_Color", Color) = (1,1,1,0)
		_T3_CutomRimLight_Texture("T3_CutomRimLight_Texture?", Range( 0 , 1)) = 1
		_T3_CustomRimLight_Opacity("T3_CustomRimLight_Opacity", Range( 0 , 1)) = 1
		_T3_ColorCorrection("T3_ColorCorrection", Color) = (1,1,1,0)
		_T3_IB_ShadowColor("T3_IB_ShadowColor", Color) = (0.5283019,0.5283019,0.5283019,0)
		_T3_IB_BackColor("T3_IB_BackColor", Color) = (1,1,1,0)
		_T3_IB_ShadowDrippingNoise_Transition("T3_IB_ShadowDrippingNoise_Transition", Range( 0 , 1)) = 1
		_T3_IB_ShadowDrippingNoise_Smoothstep("T3_IB_ShadowDrippingNoise_Smoothstep", Range( 0.001 , 0.5)) = 0.2
		_T3_IB_ShadowDrippingNoise_Step("T3_IB_ShadowDrippingNoise_Step", Range( 0 , 1)) = 0
		_DrippingNoise_Tiling5("T3_IB_ShadowDrippingNoise_Tiling", Float) = 1
		_T3_IB_ShadowDrippingNoise_Offset("T3_IB_ShadowDrippingNoise_Offset", Vector) = (0,0,0,0)
		_T3_IB_NormalDrippingNoise_Smoothstep("T3_IB_NormalDrippingNoise_Smoothstep", Range( 0 , 1)) = 0.01
		_T3_IB_NormalDrippingNoise_Step("T3_IB_NormalDrippingNoise_Step", Range( 0 , 1)) = 0.45
		_T3_IB_NormalDrippingNoise_Tiling("T3_IB_NormalDrippingNoise_Tiling", Float) = 1
		_T3_IB_NormalDrippingNoise_Offset("T3_IB_NormalDrippingNoise_Offset", Vector) = (0,0,0,0)
		_T3_IB_ShadowGrunge_Tiling("T3_IB_ShadowGrunge_Tiling", Float) = 0.2
		_T3_IB_ShadowGrunge_Contrast("T3_IB_ShadowGrunge_Contrast", Float) = -3.38
		_T3_IB_NormalGrunge_Tiling("T3_IB_NormalGrunge_Tiling", Float) = 0.2
		_T3_IB_NormalGrunge_Contrast("T3_IB_NormalGrunge_Contrast", Float) = 2.4
		_T3_IB_ColorCorrection("T3_IB_ColorCorrection", Color) = (1,1,1,0)
		[Header(Paper)]_T4_AnimatedGrunge("T4_AnimatedGrunge?", Range( 0 , 1)) = 0
		_T4_NonAnimatedGrunge_Tiling("T4_NonAnimatedGrunge_Tiling", Float) = 1
		_T4_AnimatedGrunge_Flipbook_Columns("T4_AnimatedGrunge_Flipbook_Columns", Float) = 1
		_T4_AnimatedGrunge_Flipbook_Rows("T4_AnimatedGrunge_Flipbook_Rows", Float) = 1
		_T4_AnimatedGrunge_Contrast("T4_AnimatedGrunge_Contrast", Float) = 1.58
		_T4_AnimatedGrunge_Flipbook_Speed("T4_AnimatedGrunge_Flipbook_Speed", Float) = 1
		_T4_AnimatedGrunge_Multiply("T4_AnimatedGrunge_Multiply", Float) = 1.58
		_T4_PaintGrunge_Tiling("T4_PaintGrunge_Tiling", Float) = 1
		_T4_PaintGrunge_Contrast("T4_PaintGrunge_Contrast", Float) = 0
		_T4_PaintGrunge_Multiply("T4_PaintGrunge_Multiply", Float) = 0
		[Header(Custom Rim Light)]_T4_CustomRimLight("T4_CustomRimLight?", Range( 0 , 1)) = 0
		_T4_CustomRimLight_Color("T4_CustomRimLight_Color", Color) = (1,1,1,0)
		_T4_CutomRimLight_Texture("T4_CutomRimLight_Texture?", Range( 0 , 1)) = 1
		_T4_CustomRimLight_Opacity("T4_CustomRimLight_Opacity", Range( 0 , 1)) = 1
		_T4_ColorCorrection("T4_ColorCorrection", Color) = (1,1,1,0)
		_T4_IB_ShadowColor("T4_IB_ShadowColor", Color) = (0.5283019,0.5283019,0.5283019,0)
		_T4_IB_BackColor("T4_IB_BackColor", Color) = (1,1,1,0)
		_T4_IB_ShadowDrippingNoise_Transition("T4_IB_ShadowDrippingNoise_Transition", Range( 0 , 1)) = 1
		_T4_IB_ShadowDrippingNoise_Smoothstep("T4_IB_ShadowDrippingNoise_Smoothstep", Range( 0.001 , 0.5)) = 0.2
		_T4_IB_ShadowDrippingNoise_Step("T4_IB_ShadowDrippingNoise_Step", Range( 0 , 1)) = 0
		_DrippingNoise_Tiling6("T4_IB_ShadowDrippingNoise_Tiling", Float) = 1
		_T4_IB_ShadowDrippingNoise_Offset("T4_IB_ShadowDrippingNoise_Offset", Vector) = (0,0,0,0)
		_T4_IB_NormalDrippingNoise_Smoothstep("T4_IB_NormalDrippingNoise_Smoothstep", Range( 0 , 1)) = 0.01
		_T4_IB_NormalDrippingNoise_Step("T4_IB_NormalDrippingNoise_Step", Range( 0 , 1)) = 0.45
		_T4_IB_NormalDrippingNoise_Tiling("T4_IB_NormalDrippingNoise_Tiling", Float) = 1
		_T4_IB_NormalDrippingNoise_Offset("T4_IB_NormalDrippingNoise_Offset", Vector) = (0,0,0,0)
		_T4_IB_ShadowGrunge_Tiling("T4_IB_ShadowGrunge_Tiling", Float) = 0.2
		_T4_IB_ShadowGrunge_Contrast("T4_IB_ShadowGrunge_Contrast", Float) = -3.38
		_T4_IB_NormalGrunge_Tiling("T4_IB_NormalGrunge_Tiling", Float) = 0.2
		_T4_IB_NormalGrunge_Contrast("T4_IB_NormalGrunge_Contrast", Float) = 2.4
		_T4_IB_ColorCorrection("T4_IB_ColorCorrection", Color) = (1,1,1,0)
		_TA_4_Textures("TA_4_Textures", 2DArray) = "white" {}
		[ASEEnd]_TA_4_Grunges("TA_4_Grunges", 2DArray) = "white" {}

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

			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_COLOR
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
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
				float4 ase_color : COLOR;
				float4 ase_texcoord6 : TEXCOORD6;
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _T2_ColorCorrection;
			float4 _T2_IB_ShadowColor;
			float4 _T4_IB_ShadowColor;
			float4 _T4_IB_BackColor;
			float4 _T1_IB_BackColor;
			float4 _T1_IB_ColorCorrection;
			float4 _T4_IB_ColorCorrection;
			float4 _T1_CustomRimLight_Color;
			float4 _T3_IB_ShadowColor;
			float4 _T1_ColorCorrection;
			float4 _T4_CustomRimLight_Color;
			float4 _T3_IB_ColorCorrection;
			float4 _T4_ColorCorrection;
			float4 _T3_ColorCorrection;
			float4 _T2_IB_BackColor;
			float4 _T2_IB_ColorCorrection;
			float4 _T3_CustomRimLight_Color;
			float4 _T2_CustomRimLight_Color;
			float4 _ShadowColor;
			float4 _T3_IB_BackColor;
			float4 _T1_IB_ShadowColor;
			float2 _T1_IB_NormalDrippingNoise_Offset;
			float2 _T2_IB_ShadowDrippingNoise_Offset;
			float2 _T4_IB_ShadowDrippingNoise_Offset;
			float2 _T1_IB_ShadowDrippingNoise_Offset;
			float2 _ShadowNoisePanner;
			float2 _T3_IB_NormalDrippingNoise_Offset;
			float2 _T2_IB_NormalDrippingNoise_Offset;
			float2 _T4_IB_NormalDrippingNoise_Offset;
			float2 _T3_IB_ShadowDrippingNoise_Offset;
			float _T3_IB_ShadowGrunge_Tiling;
			float _T3_IB_ShadowDrippingNoise_Step;
			float _T3_IB_ShadowDrippingNoise_Smoothstep;
			float _T3_IB_NormalGrunge_Contrast;
			float _T3_IB_ShadowDrippingNoise_Transition;
			float _T3_IB_NormalGrunge_Tiling;
			float _T3_CustomRimLight;
			float _T3_IB_NormalDrippingNoise_Step;
			float _T3_CutomRimLight_Texture;
			float _T3_IB_ShadowGrunge_Contrast;
			float _T3_IB_NormalDrippingNoise_Smoothstep;
			float _T3_IB_NormalDrippingNoise_Tiling;
			float _T3_CustomRimLight_Opacity;
			float _DrippingNoise_Tiling5;
			float _T1_AnimatedGrunge_Contrast;
			float _T4_PaintGrunge_Tiling;
			float _T4_NonAnimatedGrunge_Tiling;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _StepAttenuation;
			float _StepShadow;
			float _T4_IB_NormalDrippingNoise_Tiling;
			float _T4_IB_NormalDrippingNoise_Smoothstep;
			float _T4_IB_NormalDrippingNoise_Step;
			float _T4_IB_NormalGrunge_Tiling;
			float _T4_IB_NormalGrunge_Contrast;
			float _T4_IB_ShadowGrunge_Tiling;
			float _T4_IB_ShadowGrunge_Contrast;
			float _T4_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling6;
			float _T4_IB_ShadowDrippingNoise_Step;
			float _T4_IB_ShadowDrippingNoise_Smoothstep;
			float _T4_CustomRimLight;
			float _T4_CutomRimLight_Texture;
			float _T4_CustomRimLight_Opacity;
			float _T4_PaintGrunge_Multiply;
			float _T4_PaintGrunge_Contrast;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Multiply;
			float _T3_NonAnimatedGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _DebugVertexPaint;
			float _DebugTextureTiling;
			float _Out_or_InBrume;
			float _T1_IB_NormalDrippingNoise_Tiling;
			float _T1_IB_NormalDrippingNoise_Smoothstep;
			float _T1_IB_NormalDrippingNoise_Step;
			float _T1_IB_NormalGrunge_Tiling;
			float _T1_IB_NormalGrunge_Contrast;
			float _T1_IB_ShadowGrunge_Tiling;
			float _T1_IB_ShadowGrunge_Contrast;
			float _T1_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling3;
			float _T1_IB_ShadowDrippingNoise_Step;
			float _T1_IB_ShadowDrippingNoise_Smoothstep;
			float _T1_CustomRimLight;
			float _T1_CutomRimLight_Texture;
			float _T1_CustomRimLight_Opacity;
			float _GrayscaleDebug;
			float _T1_PaintGrunge_Multiply;
			float _T1_PaintGrunge_Tiling;
			float _T1_PaintGrunge_Contrast;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_NonAnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Tiling;
			float _T2_NonAnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _LightDebug;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_IB_NormalDrippingNoise_Tiling;
			float _T2_IB_NormalDrippingNoise_Smoothstep;
			float _T2_IB_NormalDrippingNoise_Step;
			float _T2_IB_NormalGrunge_Tiling;
			float _T2_IB_NormalGrunge_Contrast;
			float _T2_IB_ShadowGrunge_Tiling;
			float _T2_IB_ShadowGrunge_Contrast;
			float _T2_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling4;
			float _T2_IB_ShadowDrippingNoise_Step;
			float _T2_IB_ShadowDrippingNoise_Smoothstep;
			float _T2_CustomRimLight;
			float _T2_CutomRimLight_Texture;
			float _T2_CustomRimLight_Opacity;
			float _T2_PaintGrunge_Multiply;
			float _T2_PaintGrunge_Tiling;
			float _T2_PaintGrunge_Contrast;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_AnimatedGrunge;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _NormalDebug;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			TEXTURE2D_ARRAY(_TA_1_Textures);
			SAMPLER(sampler_TA_1_Textures);
			TEXTURE2D_ARRAY(_TA_1_Grunges);
			SAMPLER(sampler_TA_1_Grunges);
			TEXTURE2D_ARRAY(_TA_2_Textures);
			SAMPLER(sampler_TA_2_Textures);
			TEXTURE2D_ARRAY(_TA_3_Textures);
			SAMPLER(sampler_TA_3_Textures);
			TEXTURE2D_ARRAY(_TA_4_Textures);
			SAMPLER(sampler_TA_4_Textures);
			sampler2D _InBrumeDrippingNoise;
			TEXTURE2D_ARRAY(_DebugTextureArray);
			SAMPLER(sampler_DebugTextureArray);
			TEXTURE2D_ARRAY(_TA_2_Grunges);
			SAMPLER(sampler_TA_2_Grunges);
			TEXTURE2D_ARRAY(_TA_3_Grunges);
			SAMPLER(sampler_TA_3_Grunges);
			TEXTURE2D_ARRAY(_TA_4_Grunges);
			SAMPLER(sampler_TA_4_Grunges);
			sampler2D _ShadowNoise;


			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}
			void StochasticTiling( float2 UV, out float2 UV1, out float2 UV2, out float2 UV3, out float W1, out float W2, out float W3 )
			{
				float2 vertex1, vertex2, vertex3;
				// Scaling of the input
				float2 uv = UV * 3.464; // 2 * sqrt (3)
				// Skew input space into simplex triangle grid
				const float2x2 gridToSkewedGrid = float2x2( 1.0, 0.0, -0.57735027, 1.15470054 );
				float2 skewedCoord = mul( gridToSkewedGrid, uv );
				// Compute local triangle vertex IDs and local barycentric coordinates
				int2 baseId = int2( floor( skewedCoord ) );
				float3 temp = float3( frac( skewedCoord ), 0 );
				temp.z = 1.0 - temp.x - temp.y;
				if ( temp.z > 0.0 )
				{
					W1 = temp.z;
					W2 = temp.y;
					W3 = temp.x;
					vertex1 = baseId;
					vertex2 = baseId + int2( 0, 1 );
					vertex3 = baseId + int2( 1, 0 );
				}
				else
				{
					W1 = -temp.z;
					W2 = 1.0 - temp.y;
					W3 = 1.0 - temp.x;
					vertex1 = baseId + int2( 1, 1 );
					vertex2 = baseId + int2( 1, 0 );
					vertex3 = baseId + int2( 0, 1 );
				}
				UV1 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex1 ) ) * 43758.5453 );
				UV2 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex2 ) ) * 43758.5453 );
				UV3 = UV + frac( sin( mul( float2x2( 127.1, 311.7, 269.5, 183.3 ), vertex3 ) ) * 43758.5453 );
				return;
			}
			
			void TriplanarWeights229_g45( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			void TriplanarWeights229_g46( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			void TriplanarWeights229_g43( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			void TriplanarWeights229_g44( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			void TriplanarWeights229_g52( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			void TriplanarWeights229_g53( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			void TriplanarWeights229_g51( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
			}
			
			void TriplanarWeights229_g54( float3 WorldNormal, out float W0, out float W1, out float W2 )
			{
				half3 weights = max( abs( WorldNormal.xyz ), 0.000001 );
				weights /= ( weights.x + weights.y + weights.z ).xxx;
				W0 = weights.x;
				W1 = weights.y;
				W2 = weights.z;
				return;
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
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord6.xyz = ase_worldTangent;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord7.xyz = ase_worldBitangent;
				
				o.ase_texcoord5.xy = v.ase_texcoord.xy;
				o.ase_color = v.ase_color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.zw = 0;
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
				float4 ase_color : COLOR;
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
				o.ase_color = v.ase_color;
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
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
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
				float4 screenPos = IN.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_output_130_0 = ( (ase_screenPosNorm).xy * _T1_NonAnimatedGrunge_Tiling );
				// *** BEGIN Flipbook UV Animation vars ***
				// Total tiles of Flipbook Texture
				float fbtotaltiles179 = _T1_AnimatedGrunge_Flipbook_Columns * _T1_AnimatedGrunge_Flipbook_Rows;
				// Offsets for cols and rows of Flipbook Texture
				float fbcolsoffset179 = 1.0f / _T1_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset179 = 1.0f / _T1_AnimatedGrunge_Flipbook_Rows;
				// Speed of animation
				float fbspeed179 = _TimeParameters.x * _T1_AnimatedGrunge_Flipbook_Speed;
				// UV Tiling (col and row offset)
				float2 fbtiling179 = float2(fbcolsoffset179, fbrowsoffset179);
				// UV Offset - calculate current tile linear index, and convert it to (X * coloffset, Y * rowoffset)
				// Calculate current tile linear index
				float fbcurrenttileindex179 = round( fmod( fbspeed179 + 0.0, fbtotaltiles179) );
				fbcurrenttileindex179 += ( fbcurrenttileindex179 < 0) ? fbtotaltiles179 : 0;
				// Obtain Offset X coordinate from current tile linear index
				float fblinearindextox179 = round ( fmod ( fbcurrenttileindex179, _T1_AnimatedGrunge_Flipbook_Columns ) );
				// Multiply Offset X by coloffset
				float fboffsetx179 = fblinearindextox179 * fbcolsoffset179;
				// Obtain Offset Y coordinate from current tile linear index
				float fblinearindextoy179 = round( fmod( ( fbcurrenttileindex179 - fblinearindextox179 ) / _T1_AnimatedGrunge_Flipbook_Columns, _T1_AnimatedGrunge_Flipbook_Rows ) );
				// Reverse Y to get tiles from Top to Bottom
				fblinearindextoy179 = (int)(_T1_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy179;
				// Multiply Offset Y by rowoffset
				float fboffsety179 = fblinearindextoy179 * fbrowsoffset179;
				// UV Offset
				float2 fboffset179 = float2(fboffsetx179, fboffsety179);
				// Flipbook UV
				half2 fbuv179 = temp_output_130_0 * fbtiling179 + fboffset179;
				// *** END Flipbook UV Animation vars ***
				float2 lerpResult158 = lerp( temp_output_130_0 , fbuv179 , _T1_AnimatedGrunge);
				float3 temp_cast_0 = (SAMPLE_TEXTURE2D_ARRAY( _TA_1_Textures, sampler_TA_1_Textures, lerpResult158,5.0 ).r).xxx;
				float grayscale403 = Luminance(temp_cast_0);
				float4 temp_cast_1 = (grayscale403).xxxx;
				float localStochasticTiling216_g45 = ( 0.0 );
				float2 temp_cast_2 = (_T1_PaintGrunge_Tiling).xx;
				float2 temp_output_104_0_g45 = temp_cast_2;
				float3 temp_output_80_0_g45 = WorldPosition;
				float2 Triplanar_UV050_g45 = ( temp_output_104_0_g45 * (temp_output_80_0_g45).zy );
				float2 UV216_g45 = Triplanar_UV050_g45;
				float2 UV1216_g45 = float2( 0,0 );
				float2 UV2216_g45 = float2( 0,0 );
				float2 UV3216_g45 = float2( 0,0 );
				float W1216_g45 = 0.0;
				float W2216_g45 = 0.0;
				float W3216_g45 = 0.0;
				StochasticTiling( UV216_g45 , UV1216_g45 , UV2216_g45 , UV3216_g45 , W1216_g45 , W2216_g45 , W3216_g45 );
				float Input_Index184_g45 = 4.0;
				float2 temp_output_280_0_g45 = ddx( Triplanar_UV050_g45 );
				float2 temp_output_275_0_g45 = ddy( Triplanar_UV050_g45 );
				float localTriplanarWeights229_g45 = ( 0.0 );
				float3 ase_worldNormal = IN.ase_texcoord4.xyz;
				float3 WorldNormal229_g45 = ase_worldNormal;
				float W0229_g45 = 0.0;
				float W1229_g45 = 0.0;
				float W2229_g45 = 0.0;
				TriplanarWeights229_g45( WorldNormal229_g45 , W0229_g45 , W1229_g45 , W2229_g45 );
				float localStochasticTiling215_g45 = ( 0.0 );
				float2 Triplanar_UV164_g45 = ( temp_output_104_0_g45 * (temp_output_80_0_g45).zx );
				float2 UV215_g45 = Triplanar_UV164_g45;
				float2 UV1215_g45 = float2( 0,0 );
				float2 UV2215_g45 = float2( 0,0 );
				float2 UV3215_g45 = float2( 0,0 );
				float W1215_g45 = 0.0;
				float W2215_g45 = 0.0;
				float W3215_g45 = 0.0;
				StochasticTiling( UV215_g45 , UV1215_g45 , UV2215_g45 , UV3215_g45 , W1215_g45 , W2215_g45 , W3215_g45 );
				float2 temp_output_242_0_g45 = ddx( Triplanar_UV164_g45 );
				float2 temp_output_247_0_g45 = ddy( Triplanar_UV164_g45 );
				float localStochasticTiling201_g45 = ( 0.0 );
				float2 Triplanar_UV271_g45 = ( temp_output_104_0_g45 * (temp_output_80_0_g45).xy );
				float2 UV201_g45 = Triplanar_UV271_g45;
				float2 UV1201_g45 = float2( 0,0 );
				float2 UV2201_g45 = float2( 0,0 );
				float2 UV3201_g45 = float2( 0,0 );
				float W1201_g45 = 0.0;
				float W2201_g45 = 0.0;
				float W3201_g45 = 0.0;
				StochasticTiling( UV201_g45 , UV1201_g45 , UV2201_g45 , UV3201_g45 , W1201_g45 , W2201_g45 , W3201_g45 );
				float2 temp_output_214_0_g45 = ddx( Triplanar_UV271_g45 );
				float2 temp_output_258_0_g45 = ddy( Triplanar_UV271_g45 );
				float4 Output_TriplanarArray296_g45 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV1216_g45,Input_Index184_g45, temp_output_280_0_g45, temp_output_275_0_g45 ) * W1216_g45 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV2216_g45,Input_Index184_g45, temp_output_280_0_g45, temp_output_275_0_g45 ) * W2216_g45 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV3216_g45,Input_Index184_g45, temp_output_280_0_g45, temp_output_275_0_g45 ) * W3216_g45 ) ) * W0229_g45 ) + ( W1229_g45 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV1215_g45,Input_Index184_g45, temp_output_242_0_g45, temp_output_247_0_g45 ) * W1215_g45 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV2215_g45,Input_Index184_g45, temp_output_242_0_g45, temp_output_247_0_g45 ) * W2215_g45 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV3215_g45,Input_Index184_g45, temp_output_242_0_g45, temp_output_247_0_g45 ) * W3215_g45 ) ) ) + ( W2229_g45 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV1201_g45,Input_Index184_g45, temp_output_214_0_g45, temp_output_258_0_g45 ) * W1201_g45 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV2201_g45,Input_Index184_g45, temp_output_214_0_g45, temp_output_258_0_g45 ) * W2201_g45 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV3201_g45,Input_Index184_g45, temp_output_214_0_g45, temp_output_258_0_g45 ) * W3201_g45 ) ) ) );
				float localStochasticTiling216_g46 = ( 0.0 );
				float2 temp_cast_3 = (1.0).xx;
				float2 temp_output_104_0_g46 = temp_cast_3;
				float3 temp_output_80_0_g46 = WorldPosition;
				float2 Triplanar_UV050_g46 = ( temp_output_104_0_g46 * (temp_output_80_0_g46).zy );
				float2 UV216_g46 = Triplanar_UV050_g46;
				float2 UV1216_g46 = float2( 0,0 );
				float2 UV2216_g46 = float2( 0,0 );
				float2 UV3216_g46 = float2( 0,0 );
				float W1216_g46 = 0.0;
				float W2216_g46 = 0.0;
				float W3216_g46 = 0.0;
				StochasticTiling( UV216_g46 , UV1216_g46 , UV2216_g46 , UV3216_g46 , W1216_g46 , W2216_g46 , W3216_g46 );
				float Input_Index184_g46 = 0.0;
				float2 temp_output_280_0_g46 = ddx( Triplanar_UV050_g46 );
				float2 temp_output_275_0_g46 = ddy( Triplanar_UV050_g46 );
				float localTriplanarWeights229_g46 = ( 0.0 );
				float3 WorldNormal229_g46 = ase_worldNormal;
				float W0229_g46 = 0.0;
				float W1229_g46 = 0.0;
				float W2229_g46 = 0.0;
				TriplanarWeights229_g46( WorldNormal229_g46 , W0229_g46 , W1229_g46 , W2229_g46 );
				float localStochasticTiling215_g46 = ( 0.0 );
				float2 Triplanar_UV164_g46 = ( temp_output_104_0_g46 * (temp_output_80_0_g46).zx );
				float2 UV215_g46 = Triplanar_UV164_g46;
				float2 UV1215_g46 = float2( 0,0 );
				float2 UV2215_g46 = float2( 0,0 );
				float2 UV3215_g46 = float2( 0,0 );
				float W1215_g46 = 0.0;
				float W2215_g46 = 0.0;
				float W3215_g46 = 0.0;
				StochasticTiling( UV215_g46 , UV1215_g46 , UV2215_g46 , UV3215_g46 , W1215_g46 , W2215_g46 , W3215_g46 );
				float2 temp_output_242_0_g46 = ddx( Triplanar_UV164_g46 );
				float2 temp_output_247_0_g46 = ddy( Triplanar_UV164_g46 );
				float localStochasticTiling201_g46 = ( 0.0 );
				float2 Triplanar_UV271_g46 = ( temp_output_104_0_g46 * (temp_output_80_0_g46).xy );
				float2 UV201_g46 = Triplanar_UV271_g46;
				float2 UV1201_g46 = float2( 0,0 );
				float2 UV2201_g46 = float2( 0,0 );
				float2 UV3201_g46 = float2( 0,0 );
				float W1201_g46 = 0.0;
				float W2201_g46 = 0.0;
				float W3201_g46 = 0.0;
				StochasticTiling( UV201_g46 , UV1201_g46 , UV2201_g46 , UV3201_g46 , W1201_g46 , W2201_g46 , W3201_g46 );
				float2 temp_output_214_0_g46 = ddx( Triplanar_UV271_g46 );
				float2 temp_output_258_0_g46 = ddy( Triplanar_UV271_g46 );
				float4 Output_TriplanarArray296_g46 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV1216_g46,Input_Index184_g46, temp_output_280_0_g46, temp_output_275_0_g46 ) * W1216_g46 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV2216_g46,Input_Index184_g46, temp_output_280_0_g46, temp_output_275_0_g46 ) * W2216_g46 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV3216_g46,Input_Index184_g46, temp_output_280_0_g46, temp_output_275_0_g46 ) * W3216_g46 ) ) * W0229_g46 ) + ( W1229_g46 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV1215_g46,Input_Index184_g46, temp_output_242_0_g46, temp_output_247_0_g46 ) * W1215_g46 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV2215_g46,Input_Index184_g46, temp_output_242_0_g46, temp_output_247_0_g46 ) * W2215_g46 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV3215_g46,Input_Index184_g46, temp_output_242_0_g46, temp_output_247_0_g46 ) * W3215_g46 ) ) ) + ( W2229_g46 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV1201_g46,Input_Index184_g46, temp_output_214_0_g46, temp_output_258_0_g46 ) * W1201_g46 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV2201_g46,Input_Index184_g46, temp_output_214_0_g46, temp_output_258_0_g46 ) * W2201_g46 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Textures, sampler_TA_1_Textures, UV3201_g46,Input_Index184_g46, temp_output_214_0_g46, temp_output_258_0_g46 ) * W3201_g46 ) ) ) );
				float4 temp_output_335_0 = ( _T1_ColorCorrection * Output_TriplanarArray296_g46 );
				float grayscale252 = dot(temp_output_335_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_5 = (grayscale252).xxxx;
				float GrayscaleDebug614 = _GrayscaleDebug;
				float4 lerpResult191 = lerp( temp_output_335_0 , temp_cast_5 , GrayscaleDebug614);
				float4 blendOpSrc190 = ( ( CalculateContrast(_T1_AnimatedGrunge_Contrast,temp_cast_1) * _T1_AnimatedGrunge_Multiply ) * ( CalculateContrast(_T1_PaintGrunge_Contrast,Output_TriplanarArray296_g45) * _T1_PaintGrunge_Multiply ).r );
				float4 blendOpDest190 = lerpResult191;
				float4 T1_RGB202 = ( saturate( ( blendOpSrc190 * blendOpDest190 ) ));
				float2 texCoord50 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DArrayNode171 = SAMPLE_TEXTURE2D_ARRAY( _TA_1_Textures, sampler_TA_1_Textures, texCoord50,2.0 );
				float T1_RimLightMask_Texture265 = tex2DArrayNode171.a;
				float4 T1_RimLight_Texture599 = tex2DArrayNode171;
				float4 lerpResult601 = lerp( _T1_CustomRimLight_Color , T1_RimLight_Texture599 , _T1_CutomRimLight_Texture);
				float4 T1_CustomRimLight410 = ( ( T1_RimLightMask_Texture265 * _T1_CustomRimLight_Opacity ) * lerpResult601 );
				float4 blendOpSrc415 = T1_RGB202;
				float4 blendOpDest415 = T1_CustomRimLight410;
				float4 lerpResult246 = lerp( T1_RGB202 , ( saturate( max( blendOpSrc415, blendOpDest415 ) )) , _T1_CustomRimLight);
				float4 T1_End_OutBrume187 = lerpResult246;
				float4 T1_Normal_Texture139 = SAMPLE_TEXTURE2D_ARRAY( _TA_1_Textures, sampler_TA_1_Textures, texCoord50,1.0 );
				float2 texCoord876 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float4 T2_Normal_Texture862 = SAMPLE_TEXTURE2D_ARRAY( _TA_2_Textures, sampler_TA_2_Textures, texCoord876,1.0 );
				float4 lerpResult632 = lerp( T1_Normal_Texture139 , T2_Normal_Texture862 , IN.ase_color.r);
				float2 texCoord1164 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float4 T3_Normal_Texture1176 = SAMPLE_TEXTURE2D_ARRAY( _TA_3_Textures, sampler_TA_3_Textures, texCoord1164,1.0 );
				float4 lerpResult635 = lerp( lerpResult632 , T3_Normal_Texture1176 , IN.ase_color.g);
				float2 texCoord1057 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float4 T4_Normal_Texture1100 = SAMPLE_TEXTURE2D_ARRAY( _TA_4_Textures, sampler_TA_4_Textures, texCoord1057,1.0 );
				float4 lerpResult640 = lerp( lerpResult635 , T4_Normal_Texture1100 , IN.ase_color.b);
				float4 AllNormal644 = lerpResult640;
				float3 ase_worldTangent = IN.ase_texcoord6.xyz;
				float3 ase_worldBitangent = IN.ase_texcoord7.xyz;
				float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
				float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
				float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
				float3 tanNormal411 = AllNormal644.rgb;
				float3 worldNormal411 = float3(dot(tanToWorld0,tanNormal411), dot(tanToWorld1,tanNormal411), dot(tanToWorld2,tanNormal411));
				float dotResult414 = dot( worldNormal411 , SafeNormalize(_MainLightPosition.xyz) );
				float ase_lightAtten = 0;
				Light ase_lightAtten_mainLight = GetMainLight( ShadowCoords );
				ase_lightAtten = ase_lightAtten_mainLight.distanceAttenuation * ase_lightAtten_mainLight.shadowAttenuation;
				float normal_LightDir140 = ( dotResult414 * ase_lightAtten );
				float smoothstepResult196 = smoothstep( ( _T1_IB_ShadowDrippingNoise_Smoothstep + _T1_IB_ShadowDrippingNoise_Step ) , _T1_IB_ShadowDrippingNoise_Step , normal_LightDir140);
				float4 temp_cast_7 = (smoothstepResult196).xxxx;
				float2 temp_cast_8 = (_DrippingNoise_Tiling3).xx;
				float2 texCoord213 = IN.ase_texcoord5.xy * temp_cast_8 + _T1_IB_ShadowDrippingNoise_Offset;
				float4 temp_output_211_0 = ( temp_cast_7 - tex2D( _InBrumeDrippingNoise, texCoord213 ) );
				float4 temp_cast_9 = (step( normal_LightDir140 , _T1_IB_ShadowDrippingNoise_Step )).xxxx;
				float4 blendOpSrc247 = temp_output_211_0;
				float4 blendOpDest247 = temp_cast_9;
				float4 temp_cast_10 = (smoothstepResult196).xxxx;
				float4 lerpBlendMode247 = lerp(blendOpDest247,max( blendOpSrc247, blendOpDest247 ),( 1.0 - step( temp_output_211_0 , float4( 0,0,0,0 ) ) ).r);
				float4 temp_cast_12 = (step( normal_LightDir140 , _T1_IB_ShadowDrippingNoise_Step )).xxxx;
				float4 lerpResult304 = lerp( ( saturate( lerpBlendMode247 )) , temp_cast_12 , _T1_IB_ShadowDrippingNoise_Transition);
				float4 T1_IB_ShadowDrippingNoise351 = lerpResult304;
				float localStochasticTiling171_g47 = ( 0.0 );
				float2 temp_cast_13 = (_T1_IB_ShadowGrunge_Tiling).xx;
				float2 texCoord255 = IN.ase_texcoord5.xy * temp_cast_13 + float2( 0,0 );
				float2 Input_UV145_g47 = texCoord255;
				float2 UV171_g47 = Input_UV145_g47;
				float2 UV1171_g47 = float2( 0,0 );
				float2 UV2171_g47 = float2( 0,0 );
				float2 UV3171_g47 = float2( 0,0 );
				float W1171_g47 = 0.0;
				float W2171_g47 = 0.0;
				float W3171_g47 = 0.0;
				StochasticTiling( UV171_g47 , UV1171_g47 , UV2171_g47 , UV3171_g47 , W1171_g47 , W2171_g47 , W3171_g47 );
				float Input_Index184_g47 = 0.2;
				float2 temp_output_172_0_g47 = ddx( Input_UV145_g47 );
				float2 temp_output_182_0_g47 = ddy( Input_UV145_g47 );
				float4 Output_2DArray294_g47 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV1171_g47,Input_Index184_g47, temp_output_172_0_g47, temp_output_182_0_g47 ) * W1171_g47 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV2171_g47,Input_Index184_g47, temp_output_172_0_g47, temp_output_182_0_g47 ) * W2171_g47 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV3171_g47,Input_Index184_g47, temp_output_172_0_g47, temp_output_182_0_g47 ) * W3171_g47 ) );
				float grayscale325 = Luminance(CalculateContrast(_T1_IB_ShadowGrunge_Contrast,Output_2DArray294_g47).rgb);
				float T1_IB_ShadowGrunge374 = grayscale325;
				float4 blendOpSrc417 = ( _T1_IB_BackColor * ( 1.0 - T1_IB_ShadowDrippingNoise351 ).r );
				float4 blendOpDest417 = ( _T1_IB_ShadowColor * ( T1_IB_ShadowDrippingNoise351 * T1_IB_ShadowGrunge374 ) );
				float localStochasticTiling171_g48 = ( 0.0 );
				float2 temp_cast_15 = (_T1_IB_NormalGrunge_Tiling).xx;
				float2 texCoord244 = IN.ase_texcoord5.xy * temp_cast_15 + float2( 0,0 );
				float2 Input_UV145_g48 = texCoord244;
				float2 UV171_g48 = Input_UV145_g48;
				float2 UV1171_g48 = float2( 0,0 );
				float2 UV2171_g48 = float2( 0,0 );
				float2 UV3171_g48 = float2( 0,0 );
				float W1171_g48 = 0.0;
				float W2171_g48 = 0.0;
				float W3171_g48 = 0.0;
				StochasticTiling( UV171_g48 , UV1171_g48 , UV2171_g48 , UV3171_g48 , W1171_g48 , W2171_g48 , W3171_g48 );
				float Input_Index184_g48 = 0.2;
				float2 temp_output_172_0_g48 = ddx( Input_UV145_g48 );
				float2 temp_output_182_0_g48 = ddy( Input_UV145_g48 );
				float4 Output_2DArray294_g48 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV1171_g48,Input_Index184_g48, temp_output_172_0_g48, temp_output_182_0_g48 ) * W1171_g48 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV2171_g48,Input_Index184_g48, temp_output_172_0_g48, temp_output_182_0_g48 ) * W2171_g48 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_1_Grunges, sampler_TA_1_Grunges, UV3171_g48,Input_Index184_g48, temp_output_172_0_g48, temp_output_182_0_g48 ) * W3171_g48 ) );
				float grayscale322 = Luminance(CalculateContrast(_T1_IB_NormalGrunge_Contrast,Output_2DArray294_g48).rgb);
				float T1_IB_NormalGrunge324 = grayscale322;
				float grayscale206 = (T1_Normal_Texture139.rgb.r + T1_Normal_Texture139.rgb.g + T1_Normal_Texture139.rgb.b) / 3;
				float temp_output_382_0 = step( grayscale206 , _T1_IB_NormalDrippingNoise_Step );
				float smoothstepResult339 = smoothstep( _T1_IB_NormalDrippingNoise_Step , ( _T1_IB_NormalDrippingNoise_Step + _T1_IB_NormalDrippingNoise_Smoothstep ) , grayscale206);
				float4 temp_cast_18 = (( 1.0 - smoothstepResult339 )).xxxx;
				float2 temp_cast_19 = (_T1_IB_NormalDrippingNoise_Tiling).xx;
				float2 texCoord303 = IN.ase_texcoord5.xy * temp_cast_19 + _T1_IB_NormalDrippingNoise_Offset;
				float4 temp_output_305_0 = ( temp_output_382_0 + ( temp_cast_18 - tex2D( _InBrumeDrippingNoise, texCoord303 ) ) );
				float4 temp_cast_20 = (( 1.0 - smoothstepResult339 )).xxxx;
				float4 blendOpSrc350 = ( T1_IB_NormalGrunge324 * temp_output_305_0 );
				float4 blendOpDest350 = ( 1.0 - temp_output_305_0 );
				float4 lerpBlendMode350 = lerp(blendOpDest350,max( blendOpSrc350, blendOpDest350 ),temp_output_382_0);
				float4 T1_IB_NormalDrippingGrunge296 = ( saturate( lerpBlendMode350 ));
				float4 T1_End_InBrume289 = ( _T1_IB_ColorCorrection * (float4( 0,0,0,0 ) + (( max( blendOpSrc417, blendOpDest417 ) * T1_IB_NormalDrippingGrunge296 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) );
				float Out_or_InBrume606 = _Out_or_InBrume;
				float4 lerpResult340 = lerp( T1_End_OutBrume187 , T1_End_InBrume289 , Out_or_InBrume606);
				float4 Texture1_Final748 = lerpResult340;
				float2 temp_cast_21 = (_DebugTextureTiling).xx;
				float2 texCoord563 = IN.ase_texcoord5.xy * temp_cast_21 + float2( 0,0 );
				float4 DebugColor1488 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,0.0 );
				float DebugVertexPaint566 = _DebugVertexPaint;
				float4 lerpResult565 = lerp( Texture1_Final748 , DebugColor1488 , DebugVertexPaint566);
				float2 temp_output_821_0 = ( (ase_screenPosNorm).xy * _T2_NonAnimatedGrunge_Tiling );
				float fbtotaltiles919 = _T2_AnimatedGrunge_Flipbook_Columns * _T2_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset919 = 1.0f / _T2_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset919 = 1.0f / _T2_AnimatedGrunge_Flipbook_Rows;
				float fbspeed919 = _TimeParameters.x * _T2_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling919 = float2(fbcolsoffset919, fbrowsoffset919);
				float fbcurrenttileindex919 = round( fmod( fbspeed919 + 0.0, fbtotaltiles919) );
				fbcurrenttileindex919 += ( fbcurrenttileindex919 < 0) ? fbtotaltiles919 : 0;
				float fblinearindextox919 = round ( fmod ( fbcurrenttileindex919, _T2_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx919 = fblinearindextox919 * fbcolsoffset919;
				float fblinearindextoy919 = round( fmod( ( fbcurrenttileindex919 - fblinearindextox919 ) / _T2_AnimatedGrunge_Flipbook_Columns, _T2_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy919 = (int)(_T2_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy919;
				float fboffsety919 = fblinearindextoy919 * fbrowsoffset919;
				float2 fboffset919 = float2(fboffsetx919, fboffsety919);
				half2 fbuv919 = temp_output_821_0 * fbtiling919 + fboffset919;
				float2 lerpResult891 = lerp( temp_output_821_0 , fbuv919 , _T2_AnimatedGrunge);
				float3 temp_cast_22 = (SAMPLE_TEXTURE2D_ARRAY( _TA_2_Textures, sampler_TA_2_Textures, lerpResult891,5.0 ).r).xxx;
				float grayscale907 = Luminance(temp_cast_22);
				float4 temp_cast_23 = (grayscale907).xxxx;
				float localStochasticTiling216_g43 = ( 0.0 );
				float2 temp_cast_24 = (_T2_PaintGrunge_Tiling).xx;
				float2 temp_output_104_0_g43 = temp_cast_24;
				float3 temp_output_80_0_g43 = WorldPosition;
				float2 Triplanar_UV050_g43 = ( temp_output_104_0_g43 * (temp_output_80_0_g43).zy );
				float2 UV216_g43 = Triplanar_UV050_g43;
				float2 UV1216_g43 = float2( 0,0 );
				float2 UV2216_g43 = float2( 0,0 );
				float2 UV3216_g43 = float2( 0,0 );
				float W1216_g43 = 0.0;
				float W2216_g43 = 0.0;
				float W3216_g43 = 0.0;
				StochasticTiling( UV216_g43 , UV1216_g43 , UV2216_g43 , UV3216_g43 , W1216_g43 , W2216_g43 , W3216_g43 );
				float Input_Index184_g43 = 4.0;
				float2 temp_output_280_0_g43 = ddx( Triplanar_UV050_g43 );
				float2 temp_output_275_0_g43 = ddy( Triplanar_UV050_g43 );
				float localTriplanarWeights229_g43 = ( 0.0 );
				float3 WorldNormal229_g43 = ase_worldNormal;
				float W0229_g43 = 0.0;
				float W1229_g43 = 0.0;
				float W2229_g43 = 0.0;
				TriplanarWeights229_g43( WorldNormal229_g43 , W0229_g43 , W1229_g43 , W2229_g43 );
				float localStochasticTiling215_g43 = ( 0.0 );
				float2 Triplanar_UV164_g43 = ( temp_output_104_0_g43 * (temp_output_80_0_g43).zx );
				float2 UV215_g43 = Triplanar_UV164_g43;
				float2 UV1215_g43 = float2( 0,0 );
				float2 UV2215_g43 = float2( 0,0 );
				float2 UV3215_g43 = float2( 0,0 );
				float W1215_g43 = 0.0;
				float W2215_g43 = 0.0;
				float W3215_g43 = 0.0;
				StochasticTiling( UV215_g43 , UV1215_g43 , UV2215_g43 , UV3215_g43 , W1215_g43 , W2215_g43 , W3215_g43 );
				float2 temp_output_242_0_g43 = ddx( Triplanar_UV164_g43 );
				float2 temp_output_247_0_g43 = ddy( Triplanar_UV164_g43 );
				float localStochasticTiling201_g43 = ( 0.0 );
				float2 Triplanar_UV271_g43 = ( temp_output_104_0_g43 * (temp_output_80_0_g43).xy );
				float2 UV201_g43 = Triplanar_UV271_g43;
				float2 UV1201_g43 = float2( 0,0 );
				float2 UV2201_g43 = float2( 0,0 );
				float2 UV3201_g43 = float2( 0,0 );
				float W1201_g43 = 0.0;
				float W2201_g43 = 0.0;
				float W3201_g43 = 0.0;
				StochasticTiling( UV201_g43 , UV1201_g43 , UV2201_g43 , UV3201_g43 , W1201_g43 , W2201_g43 , W3201_g43 );
				float2 temp_output_214_0_g43 = ddx( Triplanar_UV271_g43 );
				float2 temp_output_258_0_g43 = ddy( Triplanar_UV271_g43 );
				float4 Output_TriplanarArray296_g43 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV1216_g43,Input_Index184_g43, temp_output_280_0_g43, temp_output_275_0_g43 ) * W1216_g43 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV2216_g43,Input_Index184_g43, temp_output_280_0_g43, temp_output_275_0_g43 ) * W2216_g43 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV3216_g43,Input_Index184_g43, temp_output_280_0_g43, temp_output_275_0_g43 ) * W3216_g43 ) ) * W0229_g43 ) + ( W1229_g43 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV1215_g43,Input_Index184_g43, temp_output_242_0_g43, temp_output_247_0_g43 ) * W1215_g43 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV2215_g43,Input_Index184_g43, temp_output_242_0_g43, temp_output_247_0_g43 ) * W2215_g43 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV3215_g43,Input_Index184_g43, temp_output_242_0_g43, temp_output_247_0_g43 ) * W3215_g43 ) ) ) + ( W2229_g43 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV1201_g43,Input_Index184_g43, temp_output_214_0_g43, temp_output_258_0_g43 ) * W1201_g43 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV2201_g43,Input_Index184_g43, temp_output_214_0_g43, temp_output_258_0_g43 ) * W2201_g43 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV3201_g43,Input_Index184_g43, temp_output_214_0_g43, temp_output_258_0_g43 ) * W3201_g43 ) ) ) );
				float localStochasticTiling216_g44 = ( 0.0 );
				float2 temp_cast_25 = (1.0).xx;
				float2 temp_output_104_0_g44 = temp_cast_25;
				float3 temp_output_80_0_g44 = WorldPosition;
				float2 Triplanar_UV050_g44 = ( temp_output_104_0_g44 * (temp_output_80_0_g44).zy );
				float2 UV216_g44 = Triplanar_UV050_g44;
				float2 UV1216_g44 = float2( 0,0 );
				float2 UV2216_g44 = float2( 0,0 );
				float2 UV3216_g44 = float2( 0,0 );
				float W1216_g44 = 0.0;
				float W2216_g44 = 0.0;
				float W3216_g44 = 0.0;
				StochasticTiling( UV216_g44 , UV1216_g44 , UV2216_g44 , UV3216_g44 , W1216_g44 , W2216_g44 , W3216_g44 );
				float Input_Index184_g44 = 0.0;
				float2 temp_output_280_0_g44 = ddx( Triplanar_UV050_g44 );
				float2 temp_output_275_0_g44 = ddy( Triplanar_UV050_g44 );
				float localTriplanarWeights229_g44 = ( 0.0 );
				float3 WorldNormal229_g44 = ase_worldNormal;
				float W0229_g44 = 0.0;
				float W1229_g44 = 0.0;
				float W2229_g44 = 0.0;
				TriplanarWeights229_g44( WorldNormal229_g44 , W0229_g44 , W1229_g44 , W2229_g44 );
				float localStochasticTiling215_g44 = ( 0.0 );
				float2 Triplanar_UV164_g44 = ( temp_output_104_0_g44 * (temp_output_80_0_g44).zx );
				float2 UV215_g44 = Triplanar_UV164_g44;
				float2 UV1215_g44 = float2( 0,0 );
				float2 UV2215_g44 = float2( 0,0 );
				float2 UV3215_g44 = float2( 0,0 );
				float W1215_g44 = 0.0;
				float W2215_g44 = 0.0;
				float W3215_g44 = 0.0;
				StochasticTiling( UV215_g44 , UV1215_g44 , UV2215_g44 , UV3215_g44 , W1215_g44 , W2215_g44 , W3215_g44 );
				float2 temp_output_242_0_g44 = ddx( Triplanar_UV164_g44 );
				float2 temp_output_247_0_g44 = ddy( Triplanar_UV164_g44 );
				float localStochasticTiling201_g44 = ( 0.0 );
				float2 Triplanar_UV271_g44 = ( temp_output_104_0_g44 * (temp_output_80_0_g44).xy );
				float2 UV201_g44 = Triplanar_UV271_g44;
				float2 UV1201_g44 = float2( 0,0 );
				float2 UV2201_g44 = float2( 0,0 );
				float2 UV3201_g44 = float2( 0,0 );
				float W1201_g44 = 0.0;
				float W2201_g44 = 0.0;
				float W3201_g44 = 0.0;
				StochasticTiling( UV201_g44 , UV1201_g44 , UV2201_g44 , UV3201_g44 , W1201_g44 , W2201_g44 , W3201_g44 );
				float2 temp_output_214_0_g44 = ddx( Triplanar_UV271_g44 );
				float2 temp_output_258_0_g44 = ddy( Triplanar_UV271_g44 );
				float4 Output_TriplanarArray296_g44 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV1216_g44,Input_Index184_g44, temp_output_280_0_g44, temp_output_275_0_g44 ) * W1216_g44 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV2216_g44,Input_Index184_g44, temp_output_280_0_g44, temp_output_275_0_g44 ) * W2216_g44 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV3216_g44,Input_Index184_g44, temp_output_280_0_g44, temp_output_275_0_g44 ) * W3216_g44 ) ) * W0229_g44 ) + ( W1229_g44 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV1215_g44,Input_Index184_g44, temp_output_242_0_g44, temp_output_247_0_g44 ) * W1215_g44 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV2215_g44,Input_Index184_g44, temp_output_242_0_g44, temp_output_247_0_g44 ) * W2215_g44 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV3215_g44,Input_Index184_g44, temp_output_242_0_g44, temp_output_247_0_g44 ) * W3215_g44 ) ) ) + ( W2229_g44 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV1201_g44,Input_Index184_g44, temp_output_214_0_g44, temp_output_258_0_g44 ) * W1201_g44 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV2201_g44,Input_Index184_g44, temp_output_214_0_g44, temp_output_258_0_g44 ) * W2201_g44 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Textures, sampler_TA_2_Textures, UV3201_g44,Input_Index184_g44, temp_output_214_0_g44, temp_output_258_0_g44 ) * W3201_g44 ) ) ) );
				float4 temp_output_903_0 = ( _T2_ColorCorrection * Output_TriplanarArray296_g44 );
				float grayscale905 = dot(temp_output_903_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_27 = (grayscale905).xxxx;
				float4 lerpResult886 = lerp( temp_output_903_0 , temp_cast_27 , GrayscaleDebug614);
				float4 blendOpSrc912 = ( ( CalculateContrast(_T2_AnimatedGrunge_Contrast,temp_cast_23) * _T2_AnimatedGrunge_Multiply ) * ( CalculateContrast(_T2_PaintGrunge_Contrast,Output_TriplanarArray296_g43) * _T2_PaintGrunge_Multiply ).r );
				float4 blendOpDest912 = lerpResult886;
				float4 T2_RGB816 = ( saturate( ( blendOpSrc912 * blendOpDest912 ) ));
				float4 tex2DArrayNode859 = SAMPLE_TEXTURE2D_ARRAY( _TA_2_Textures, sampler_TA_2_Textures, texCoord876,2.0 );
				float T2_RimLightMask_Texture860 = tex2DArrayNode859.a;
				float4 T2_RimLight_Texture861 = tex2DArrayNode859;
				float4 lerpResult928 = lerp( _T2_CustomRimLight_Color , T2_RimLight_Texture861 , _T2_CutomRimLight_Texture);
				float4 T2_CustomRimLight826 = ( ( T2_RimLightMask_Texture860 * _T2_CustomRimLight_Opacity ) * lerpResult928 );
				float4 blendOpSrc808 = T2_RGB816;
				float4 blendOpDest808 = T2_CustomRimLight826;
				float4 lerpResult809 = lerp( T2_RGB816 , ( saturate( max( blendOpSrc808, blendOpDest808 ) )) , _T2_CustomRimLight);
				float4 T2_End_OutBrume839 = lerpResult809;
				float smoothstepResult943 = smoothstep( ( _T2_IB_ShadowDrippingNoise_Smoothstep + _T2_IB_ShadowDrippingNoise_Step ) , _T2_IB_ShadowDrippingNoise_Step , normal_LightDir140);
				float4 temp_cast_28 = (smoothstepResult943).xxxx;
				float2 temp_cast_29 = (_DrippingNoise_Tiling4).xx;
				float2 texCoord939 = IN.ase_texcoord5.xy * temp_cast_29 + _T2_IB_ShadowDrippingNoise_Offset;
				float4 temp_output_936_0 = ( temp_cast_28 - tex2D( _InBrumeDrippingNoise, texCoord939 ) );
				float4 temp_cast_30 = (step( normal_LightDir140 , _T2_IB_ShadowDrippingNoise_Step )).xxxx;
				float4 blendOpSrc938 = temp_output_936_0;
				float4 blendOpDest938 = temp_cast_30;
				float4 temp_cast_31 = (smoothstepResult943).xxxx;
				float4 lerpBlendMode938 = lerp(blendOpDest938,max( blendOpSrc938, blendOpDest938 ),( 1.0 - step( temp_output_936_0 , float4( 0,0,0,0 ) ) ).r);
				float4 temp_cast_33 = (step( normal_LightDir140 , _T2_IB_ShadowDrippingNoise_Step )).xxxx;
				float4 lerpResult944 = lerp( ( saturate( lerpBlendMode938 )) , temp_cast_33 , _T2_IB_ShadowDrippingNoise_Transition);
				float4 T2_IB_ShadowDrippingNoise969 = lerpResult944;
				float localStochasticTiling171_g49 = ( 0.0 );
				float2 temp_cast_34 = (_T2_IB_ShadowGrunge_Tiling).xx;
				float2 texCoord995 = IN.ase_texcoord5.xy * temp_cast_34 + float2( 0,0 );
				float2 Input_UV145_g49 = texCoord995;
				float2 UV171_g49 = Input_UV145_g49;
				float2 UV1171_g49 = float2( 0,0 );
				float2 UV2171_g49 = float2( 0,0 );
				float2 UV3171_g49 = float2( 0,0 );
				float W1171_g49 = 0.0;
				float W2171_g49 = 0.0;
				float W3171_g49 = 0.0;
				StochasticTiling( UV171_g49 , UV1171_g49 , UV2171_g49 , UV3171_g49 , W1171_g49 , W2171_g49 , W3171_g49 );
				float Input_Index184_g49 = 0.2;
				float2 temp_output_172_0_g49 = ddx( Input_UV145_g49 );
				float2 temp_output_182_0_g49 = ddy( Input_UV145_g49 );
				float4 Output_2DArray294_g49 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV1171_g49,Input_Index184_g49, temp_output_172_0_g49, temp_output_182_0_g49 ) * W1171_g49 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV2171_g49,Input_Index184_g49, temp_output_172_0_g49, temp_output_182_0_g49 ) * W2171_g49 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV3171_g49,Input_Index184_g49, temp_output_172_0_g49, temp_output_182_0_g49 ) * W3171_g49 ) );
				float grayscale980 = Luminance(CalculateContrast(_T2_IB_ShadowGrunge_Contrast,Output_2DArray294_g49).rgb);
				float T2_IB_ShadowGrunge966 = grayscale980;
				float4 blendOpSrc1000 = ( _T2_IB_BackColor * ( 1.0 - T2_IB_ShadowDrippingNoise969 ).r );
				float4 blendOpDest1000 = ( _T2_IB_ShadowColor * ( T2_IB_ShadowDrippingNoise969 * T2_IB_ShadowGrunge966 ) );
				float localStochasticTiling171_g50 = ( 0.0 );
				float2 temp_cast_36 = (_T2_IB_NormalGrunge_Tiling).xx;
				float2 texCoord984 = IN.ase_texcoord5.xy * temp_cast_36 + float2( 0,0 );
				float2 Input_UV145_g50 = texCoord984;
				float2 UV171_g50 = Input_UV145_g50;
				float2 UV1171_g50 = float2( 0,0 );
				float2 UV2171_g50 = float2( 0,0 );
				float2 UV3171_g50 = float2( 0,0 );
				float W1171_g50 = 0.0;
				float W2171_g50 = 0.0;
				float W3171_g50 = 0.0;
				StochasticTiling( UV171_g50 , UV1171_g50 , UV2171_g50 , UV3171_g50 , W1171_g50 , W2171_g50 , W3171_g50 );
				float Input_Index184_g50 = 0.2;
				float2 temp_output_172_0_g50 = ddx( Input_UV145_g50 );
				float2 temp_output_182_0_g50 = ddy( Input_UV145_g50 );
				float4 Output_2DArray294_g50 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV1171_g50,Input_Index184_g50, temp_output_172_0_g50, temp_output_182_0_g50 ) * W1171_g50 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV2171_g50,Input_Index184_g50, temp_output_172_0_g50, temp_output_182_0_g50 ) * W2171_g50 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_2_Grunges, sampler_TA_2_Grunges, UV3171_g50,Input_Index184_g50, temp_output_172_0_g50, temp_output_182_0_g50 ) * W3171_g50 ) );
				float grayscale979 = Luminance(CalculateContrast(_T2_IB_NormalGrunge_Contrast,Output_2DArray294_g50).rgb);
				float T2_IB_NormalGrunge965 = grayscale979;
				float grayscale993 = (T2_Normal_Texture862.rgb.r + T2_Normal_Texture862.rgb.g + T2_Normal_Texture862.rgb.b) / 3;
				float temp_output_1007_0 = step( grayscale993 , _T2_IB_NormalDrippingNoise_Step );
				float smoothstepResult987 = smoothstep( _T2_IB_NormalDrippingNoise_Step , ( _T2_IB_NormalDrippingNoise_Step + _T2_IB_NormalDrippingNoise_Smoothstep ) , grayscale993);
				float4 temp_cast_39 = (( 1.0 - smoothstepResult987 )).xxxx;
				float2 temp_cast_40 = (_T2_IB_NormalDrippingNoise_Tiling).xx;
				float2 texCoord1009 = IN.ase_texcoord5.xy * temp_cast_40 + _T2_IB_NormalDrippingNoise_Offset;
				float4 temp_output_1006_0 = ( temp_output_1007_0 + ( temp_cast_39 - tex2D( _InBrumeDrippingNoise, texCoord1009 ) ) );
				float4 temp_cast_41 = (( 1.0 - smoothstepResult987 )).xxxx;
				float4 blendOpSrc1005 = ( T2_IB_NormalGrunge965 * temp_output_1006_0 );
				float4 blendOpDest1005 = ( 1.0 - temp_output_1006_0 );
				float4 lerpBlendMode1005 = lerp(blendOpDest1005,max( blendOpSrc1005, blendOpDest1005 ),temp_output_1007_0);
				float4 T2_IB_NormalDrippingGrunge985 = ( saturate( lerpBlendMode1005 ));
				float4 T2_End_InBrume950 = ( _T2_IB_ColorCorrection * (float4( 0,0,0,0 ) + (( max( blendOpSrc1000, blendOpDest1000 ) * T2_IB_NormalDrippingGrunge985 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) );
				float4 lerpResult871 = lerp( T2_End_OutBrume839 , T2_End_InBrume950 , Out_or_InBrume606);
				float4 Texture2_Final868 = lerpResult871;
				float4 DebugColor2477 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,1.0 );
				float4 lerpResult569 = lerp( Texture2_Final868 , DebugColor2477 , DebugVertexPaint566);
				float4 lerpResult11 = lerp( lerpResult565 , lerpResult569 , IN.ase_color.r);
				float2 temp_output_1186_0 = ( (ase_screenPosNorm).xy * _T3_NonAnimatedGrunge_Tiling );
				float fbtotaltiles1080 = _T3_AnimatedGrunge_Flipbook_Columns * _T3_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset1080 = 1.0f / _T3_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset1080 = 1.0f / _T3_AnimatedGrunge_Flipbook_Rows;
				float fbspeed1080 = _TimeParameters.x * _T3_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling1080 = float2(fbcolsoffset1080, fbrowsoffset1080);
				float fbcurrenttileindex1080 = round( fmod( fbspeed1080 + 0.0, fbtotaltiles1080) );
				fbcurrenttileindex1080 += ( fbcurrenttileindex1080 < 0) ? fbtotaltiles1080 : 0;
				float fblinearindextox1080 = round ( fmod ( fbcurrenttileindex1080, _T3_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx1080 = fblinearindextox1080 * fbcolsoffset1080;
				float fblinearindextoy1080 = round( fmod( ( fbcurrenttileindex1080 - fblinearindextox1080 ) / _T3_AnimatedGrunge_Flipbook_Columns, _T3_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy1080 = (int)(_T3_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy1080;
				float fboffsety1080 = fblinearindextoy1080 * fbrowsoffset1080;
				float2 fboffset1080 = float2(fboffsetx1080, fboffsety1080);
				half2 fbuv1080 = temp_output_1186_0 * fbtiling1080 + fboffset1080;
				float2 lerpResult1081 = lerp( temp_output_1186_0 , fbuv1080 , _T3_AnimatedGrunge);
				float3 temp_cast_42 = (SAMPLE_TEXTURE2D_ARRAY( _TA_3_Textures, sampler_TA_3_Textures, lerpResult1081,5.0 ).r).xxx;
				float grayscale1112 = Luminance(temp_cast_42);
				float4 temp_cast_43 = (grayscale1112).xxxx;
				float localStochasticTiling216_g52 = ( 0.0 );
				float2 temp_cast_44 = (_T3_PaintGrunge_Tiling).xx;
				float2 temp_output_104_0_g52 = temp_cast_44;
				float3 temp_output_80_0_g52 = WorldPosition;
				float2 Triplanar_UV050_g52 = ( temp_output_104_0_g52 * (temp_output_80_0_g52).zy );
				float2 UV216_g52 = Triplanar_UV050_g52;
				float2 UV1216_g52 = float2( 0,0 );
				float2 UV2216_g52 = float2( 0,0 );
				float2 UV3216_g52 = float2( 0,0 );
				float W1216_g52 = 0.0;
				float W2216_g52 = 0.0;
				float W3216_g52 = 0.0;
				StochasticTiling( UV216_g52 , UV1216_g52 , UV2216_g52 , UV3216_g52 , W1216_g52 , W2216_g52 , W3216_g52 );
				float Input_Index184_g52 = 4.0;
				float2 temp_output_280_0_g52 = ddx( Triplanar_UV050_g52 );
				float2 temp_output_275_0_g52 = ddy( Triplanar_UV050_g52 );
				float localTriplanarWeights229_g52 = ( 0.0 );
				float3 WorldNormal229_g52 = ase_worldNormal;
				float W0229_g52 = 0.0;
				float W1229_g52 = 0.0;
				float W2229_g52 = 0.0;
				TriplanarWeights229_g52( WorldNormal229_g52 , W0229_g52 , W1229_g52 , W2229_g52 );
				float localStochasticTiling215_g52 = ( 0.0 );
				float2 Triplanar_UV164_g52 = ( temp_output_104_0_g52 * (temp_output_80_0_g52).zx );
				float2 UV215_g52 = Triplanar_UV164_g52;
				float2 UV1215_g52 = float2( 0,0 );
				float2 UV2215_g52 = float2( 0,0 );
				float2 UV3215_g52 = float2( 0,0 );
				float W1215_g52 = 0.0;
				float W2215_g52 = 0.0;
				float W3215_g52 = 0.0;
				StochasticTiling( UV215_g52 , UV1215_g52 , UV2215_g52 , UV3215_g52 , W1215_g52 , W2215_g52 , W3215_g52 );
				float2 temp_output_242_0_g52 = ddx( Triplanar_UV164_g52 );
				float2 temp_output_247_0_g52 = ddy( Triplanar_UV164_g52 );
				float localStochasticTiling201_g52 = ( 0.0 );
				float2 Triplanar_UV271_g52 = ( temp_output_104_0_g52 * (temp_output_80_0_g52).xy );
				float2 UV201_g52 = Triplanar_UV271_g52;
				float2 UV1201_g52 = float2( 0,0 );
				float2 UV2201_g52 = float2( 0,0 );
				float2 UV3201_g52 = float2( 0,0 );
				float W1201_g52 = 0.0;
				float W2201_g52 = 0.0;
				float W3201_g52 = 0.0;
				StochasticTiling( UV201_g52 , UV1201_g52 , UV2201_g52 , UV3201_g52 , W1201_g52 , W2201_g52 , W3201_g52 );
				float2 temp_output_214_0_g52 = ddx( Triplanar_UV271_g52 );
				float2 temp_output_258_0_g52 = ddy( Triplanar_UV271_g52 );
				float4 Output_TriplanarArray296_g52 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV1216_g52,Input_Index184_g52, temp_output_280_0_g52, temp_output_275_0_g52 ) * W1216_g52 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV2216_g52,Input_Index184_g52, temp_output_280_0_g52, temp_output_275_0_g52 ) * W2216_g52 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV3216_g52,Input_Index184_g52, temp_output_280_0_g52, temp_output_275_0_g52 ) * W3216_g52 ) ) * W0229_g52 ) + ( W1229_g52 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV1215_g52,Input_Index184_g52, temp_output_242_0_g52, temp_output_247_0_g52 ) * W1215_g52 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV2215_g52,Input_Index184_g52, temp_output_242_0_g52, temp_output_247_0_g52 ) * W2215_g52 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV3215_g52,Input_Index184_g52, temp_output_242_0_g52, temp_output_247_0_g52 ) * W3215_g52 ) ) ) + ( W2229_g52 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV1201_g52,Input_Index184_g52, temp_output_214_0_g52, temp_output_258_0_g52 ) * W1201_g52 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV2201_g52,Input_Index184_g52, temp_output_214_0_g52, temp_output_258_0_g52 ) * W2201_g52 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV3201_g52,Input_Index184_g52, temp_output_214_0_g52, temp_output_258_0_g52 ) * W3201_g52 ) ) ) );
				float localStochasticTiling216_g53 = ( 0.0 );
				float2 temp_cast_45 = (1.0).xx;
				float2 temp_output_104_0_g53 = temp_cast_45;
				float3 temp_output_80_0_g53 = WorldPosition;
				float2 Triplanar_UV050_g53 = ( temp_output_104_0_g53 * (temp_output_80_0_g53).zy );
				float2 UV216_g53 = Triplanar_UV050_g53;
				float2 UV1216_g53 = float2( 0,0 );
				float2 UV2216_g53 = float2( 0,0 );
				float2 UV3216_g53 = float2( 0,0 );
				float W1216_g53 = 0.0;
				float W2216_g53 = 0.0;
				float W3216_g53 = 0.0;
				StochasticTiling( UV216_g53 , UV1216_g53 , UV2216_g53 , UV3216_g53 , W1216_g53 , W2216_g53 , W3216_g53 );
				float Input_Index184_g53 = 0.0;
				float2 temp_output_280_0_g53 = ddx( Triplanar_UV050_g53 );
				float2 temp_output_275_0_g53 = ddy( Triplanar_UV050_g53 );
				float localTriplanarWeights229_g53 = ( 0.0 );
				float3 WorldNormal229_g53 = ase_worldNormal;
				float W0229_g53 = 0.0;
				float W1229_g53 = 0.0;
				float W2229_g53 = 0.0;
				TriplanarWeights229_g53( WorldNormal229_g53 , W0229_g53 , W1229_g53 , W2229_g53 );
				float localStochasticTiling215_g53 = ( 0.0 );
				float2 Triplanar_UV164_g53 = ( temp_output_104_0_g53 * (temp_output_80_0_g53).zx );
				float2 UV215_g53 = Triplanar_UV164_g53;
				float2 UV1215_g53 = float2( 0,0 );
				float2 UV2215_g53 = float2( 0,0 );
				float2 UV3215_g53 = float2( 0,0 );
				float W1215_g53 = 0.0;
				float W2215_g53 = 0.0;
				float W3215_g53 = 0.0;
				StochasticTiling( UV215_g53 , UV1215_g53 , UV2215_g53 , UV3215_g53 , W1215_g53 , W2215_g53 , W3215_g53 );
				float2 temp_output_242_0_g53 = ddx( Triplanar_UV164_g53 );
				float2 temp_output_247_0_g53 = ddy( Triplanar_UV164_g53 );
				float localStochasticTiling201_g53 = ( 0.0 );
				float2 Triplanar_UV271_g53 = ( temp_output_104_0_g53 * (temp_output_80_0_g53).xy );
				float2 UV201_g53 = Triplanar_UV271_g53;
				float2 UV1201_g53 = float2( 0,0 );
				float2 UV2201_g53 = float2( 0,0 );
				float2 UV3201_g53 = float2( 0,0 );
				float W1201_g53 = 0.0;
				float W2201_g53 = 0.0;
				float W3201_g53 = 0.0;
				StochasticTiling( UV201_g53 , UV1201_g53 , UV2201_g53 , UV3201_g53 , W1201_g53 , W2201_g53 , W3201_g53 );
				float2 temp_output_214_0_g53 = ddx( Triplanar_UV271_g53 );
				float2 temp_output_258_0_g53 = ddy( Triplanar_UV271_g53 );
				float4 Output_TriplanarArray296_g53 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV1216_g53,Input_Index184_g53, temp_output_280_0_g53, temp_output_275_0_g53 ) * W1216_g53 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV2216_g53,Input_Index184_g53, temp_output_280_0_g53, temp_output_275_0_g53 ) * W2216_g53 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV3216_g53,Input_Index184_g53, temp_output_280_0_g53, temp_output_275_0_g53 ) * W3216_g53 ) ) * W0229_g53 ) + ( W1229_g53 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV1215_g53,Input_Index184_g53, temp_output_242_0_g53, temp_output_247_0_g53 ) * W1215_g53 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV2215_g53,Input_Index184_g53, temp_output_242_0_g53, temp_output_247_0_g53 ) * W2215_g53 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV3215_g53,Input_Index184_g53, temp_output_242_0_g53, temp_output_247_0_g53 ) * W3215_g53 ) ) ) + ( W2229_g53 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV1201_g53,Input_Index184_g53, temp_output_214_0_g53, temp_output_258_0_g53 ) * W1201_g53 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV2201_g53,Input_Index184_g53, temp_output_214_0_g53, temp_output_258_0_g53 ) * W2201_g53 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Textures, sampler_TA_3_Textures, UV3201_g53,Input_Index184_g53, temp_output_214_0_g53, temp_output_258_0_g53 ) * W3201_g53 ) ) ) );
				float4 temp_output_1094_0 = ( _T3_ColorCorrection * Output_TriplanarArray296_g53 );
				float grayscale1113 = dot(temp_output_1094_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_47 = (grayscale1113).xxxx;
				float4 lerpResult1085 = lerp( temp_output_1094_0 , temp_cast_47 , GrayscaleDebug614);
				float4 blendOpSrc1107 = ( ( CalculateContrast(_T3_AnimatedGrunge_Contrast,temp_cast_43) * _T3_AnimatedGrunge_Multiply ) * ( CalculateContrast(_T3_PaintGrunge_Contrast,Output_TriplanarArray296_g52) * _T3_PaintGrunge_Multiply ).r );
				float4 blendOpDest1107 = lerpResult1085;
				float4 T3_RGB1187 = ( saturate( ( blendOpSrc1107 * blendOpDest1107 ) ));
				float4 tex2DArrayNode1184 = SAMPLE_TEXTURE2D_ARRAY( _TA_3_Textures, sampler_TA_3_Textures, texCoord1164,2.0 );
				float4 T3_RimLight_Texture1202 = tex2DArrayNode1184;
				float4 lerpResult1093 = lerp( _T3_CustomRimLight_Color , T3_RimLight_Texture1202 , _T3_CutomRimLight_Texture);
				float4 T3_CustomRimLight1183 = ( ( T2_RimLightMask_Texture860 * _T3_CustomRimLight_Opacity ) * lerpResult1093 );
				float4 blendOpSrc1245 = T3_RGB1187;
				float4 blendOpDest1245 = T3_CustomRimLight1183;
				float4 lerpResult1209 = lerp( T3_RGB1187 , ( saturate( max( blendOpSrc1245, blendOpDest1245 ) )) , _T3_CustomRimLight);
				float4 T3_End_OutBrume1119 = lerpResult1209;
				float smoothstepResult1222 = smoothstep( ( _T3_IB_ShadowDrippingNoise_Smoothstep + _T3_IB_ShadowDrippingNoise_Step ) , _T3_IB_ShadowDrippingNoise_Step , normal_LightDir140);
				float4 temp_cast_48 = (smoothstepResult1222).xxxx;
				float2 temp_cast_49 = (_DrippingNoise_Tiling5).xx;
				float2 texCoord1218 = IN.ase_texcoord5.xy * temp_cast_49 + _T3_IB_ShadowDrippingNoise_Offset;
				float4 temp_output_1177_0 = ( temp_cast_48 - tex2D( _InBrumeDrippingNoise, texCoord1218 ) );
				float4 temp_cast_50 = (step( normal_LightDir140 , _T3_IB_ShadowDrippingNoise_Step )).xxxx;
				float4 blendOpSrc1253 = temp_output_1177_0;
				float4 blendOpDest1253 = temp_cast_50;
				float4 temp_cast_51 = (smoothstepResult1222).xxxx;
				float4 lerpBlendMode1253 = lerp(blendOpDest1253,max( blendOpSrc1253, blendOpDest1253 ),( 1.0 - step( temp_output_1177_0 , float4( 0,0,0,0 ) ) ).r);
				float4 temp_cast_53 = (step( normal_LightDir140 , _T3_IB_ShadowDrippingNoise_Step )).xxxx;
				float4 lerpResult1223 = lerp( ( saturate( lerpBlendMode1253 )) , temp_cast_53 , _T3_IB_ShadowDrippingNoise_Transition);
				float4 T3_IB_ShadowDrippingNoise1242 = lerpResult1223;
				float localStochasticTiling171_g55 = ( 0.0 );
				float2 temp_cast_54 = (_T3_IB_ShadowGrunge_Tiling).xx;
				float2 texCoord1350 = IN.ase_texcoord5.xy * temp_cast_54 + float2( 0,0 );
				float2 Input_UV145_g55 = texCoord1350;
				float2 UV171_g55 = Input_UV145_g55;
				float2 UV1171_g55 = float2( 0,0 );
				float2 UV2171_g55 = float2( 0,0 );
				float2 UV3171_g55 = float2( 0,0 );
				float W1171_g55 = 0.0;
				float W2171_g55 = 0.0;
				float W3171_g55 = 0.0;
				StochasticTiling( UV171_g55 , UV1171_g55 , UV2171_g55 , UV3171_g55 , W1171_g55 , W2171_g55 , W3171_g55 );
				float Input_Index184_g55 = 0.2;
				float2 temp_output_172_0_g55 = ddx( Input_UV145_g55 );
				float2 temp_output_182_0_g55 = ddy( Input_UV145_g55 );
				float4 Output_2DArray294_g55 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV1171_g55,Input_Index184_g55, temp_output_172_0_g55, temp_output_182_0_g55 ) * W1171_g55 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV2171_g55,Input_Index184_g55, temp_output_172_0_g55, temp_output_182_0_g55 ) * W2171_g55 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV3171_g55,Input_Index184_g55, temp_output_172_0_g55, temp_output_182_0_g55 ) * W3171_g55 ) );
				float grayscale1247 = Luminance(CalculateContrast(_T3_IB_ShadowGrunge_Contrast,Output_2DArray294_g55).rgb);
				float T3_IB_ShadowGrunge1359 = grayscale1247;
				float4 blendOpSrc1278 = ( _T3_IB_BackColor * ( 1.0 - T3_IB_ShadowDrippingNoise1242 ).r );
				float4 blendOpDest1278 = ( _T3_IB_ShadowColor * ( T3_IB_ShadowDrippingNoise1242 * T3_IB_ShadowGrunge1359 ) );
				float localStochasticTiling171_g56 = ( 0.0 );
				float2 temp_cast_56 = (_T3_IB_NormalGrunge_Tiling).xx;
				float2 texCoord1262 = IN.ase_texcoord5.xy * temp_cast_56 + float2( 0,0 );
				float2 Input_UV145_g56 = texCoord1262;
				float2 UV171_g56 = Input_UV145_g56;
				float2 UV1171_g56 = float2( 0,0 );
				float2 UV2171_g56 = float2( 0,0 );
				float2 UV3171_g56 = float2( 0,0 );
				float W1171_g56 = 0.0;
				float W2171_g56 = 0.0;
				float W3171_g56 = 0.0;
				StochasticTiling( UV171_g56 , UV1171_g56 , UV2171_g56 , UV3171_g56 , W1171_g56 , W2171_g56 , W3171_g56 );
				float Input_Index184_g56 = 0.2;
				float2 temp_output_172_0_g56 = ddx( Input_UV145_g56 );
				float2 temp_output_182_0_g56 = ddy( Input_UV145_g56 );
				float4 Output_2DArray294_g56 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV1171_g56,Input_Index184_g56, temp_output_172_0_g56, temp_output_182_0_g56 ) * W1171_g56 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV2171_g56,Input_Index184_g56, temp_output_172_0_g56, temp_output_182_0_g56 ) * W2171_g56 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_3_Grunges, sampler_TA_3_Grunges, UV3171_g56,Input_Index184_g56, temp_output_172_0_g56, temp_output_182_0_g56 ) * W3171_g56 ) );
				float grayscale1257 = Luminance(CalculateContrast(_T3_IB_NormalGrunge_Contrast,Output_2DArray294_g56).rgb);
				float T3_IB_NormalGrunge1360 = grayscale1257;
				float grayscale1212 = (T3_Normal_Texture1176.rgb.r + T3_Normal_Texture1176.rgb.g + T3_Normal_Texture1176.rgb.b) / 3;
				float temp_output_1284_0 = step( grayscale1212 , _T3_IB_NormalDrippingNoise_Step );
				float smoothstepResult1264 = smoothstep( _T3_IB_NormalDrippingNoise_Step , ( _T3_IB_NormalDrippingNoise_Step + _T3_IB_NormalDrippingNoise_Smoothstep ) , grayscale1212);
				float4 temp_cast_59 = (( 1.0 - smoothstepResult1264 )).xxxx;
				float2 temp_cast_60 = (_T3_IB_NormalDrippingNoise_Tiling).xx;
				float2 texCoord1286 = IN.ase_texcoord5.xy * temp_cast_60 + _T3_IB_NormalDrippingNoise_Offset;
				float4 temp_output_1283_0 = ( temp_output_1284_0 + ( temp_cast_59 - tex2D( _InBrumeDrippingNoise, texCoord1286 ) ) );
				float4 temp_cast_61 = (( 1.0 - smoothstepResult1264 )).xxxx;
				float4 blendOpSrc1282 = ( T3_IB_NormalGrunge1360 * temp_output_1283_0 );
				float4 blendOpDest1282 = ( 1.0 - temp_output_1283_0 );
				float4 lerpBlendMode1282 = lerp(blendOpDest1282,max( blendOpSrc1282, blendOpDest1282 ),temp_output_1284_0);
				float4 T3_IB_NormalDrippingGrunge1354 = ( saturate( lerpBlendMode1282 ));
				float4 T3_End_InBrume1217 = ( _T3_IB_ColorCorrection * (float4( 0,0,0,0 ) + (( max( blendOpSrc1278, blendOpDest1278 ) * T3_IB_NormalDrippingGrunge1354 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) );
				float4 lerpResult1196 = lerp( T3_End_OutBrume1119 , T3_End_InBrume1217 , Out_or_InBrume606);
				float4 Texture3_Final1214 = lerpResult1196;
				float4 temp_cast_62 = (Texture3_Final1214).xxxx;
				float4 DebugColor3478 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,2.0 );
				float4 lerpResult576 = lerp( temp_cast_62 , DebugColor3478 , DebugVertexPaint566);
				float4 lerpResult14 = lerp( lerpResult11 , lerpResult576 , IN.ase_color.g);
				float2 temp_output_1046_0 = ( (ase_screenPosNorm).xy * _T4_NonAnimatedGrunge_Tiling );
				float fbtotaltiles1129 = _T4_AnimatedGrunge_Flipbook_Columns * _T4_AnimatedGrunge_Flipbook_Rows;
				float fbcolsoffset1129 = 1.0f / _T4_AnimatedGrunge_Flipbook_Columns;
				float fbrowsoffset1129 = 1.0f / _T4_AnimatedGrunge_Flipbook_Rows;
				float fbspeed1129 = _TimeParameters.x * _T4_AnimatedGrunge_Flipbook_Speed;
				float2 fbtiling1129 = float2(fbcolsoffset1129, fbrowsoffset1129);
				float fbcurrenttileindex1129 = round( fmod( fbspeed1129 + 0.0, fbtotaltiles1129) );
				fbcurrenttileindex1129 += ( fbcurrenttileindex1129 < 0) ? fbtotaltiles1129 : 0;
				float fblinearindextox1129 = round ( fmod ( fbcurrenttileindex1129, _T4_AnimatedGrunge_Flipbook_Columns ) );
				float fboffsetx1129 = fblinearindextox1129 * fbcolsoffset1129;
				float fblinearindextoy1129 = round( fmod( ( fbcurrenttileindex1129 - fblinearindextox1129 ) / _T4_AnimatedGrunge_Flipbook_Columns, _T4_AnimatedGrunge_Flipbook_Rows ) );
				fblinearindextoy1129 = (int)(_T4_AnimatedGrunge_Flipbook_Rows-1) - fblinearindextoy1129;
				float fboffsety1129 = fblinearindextoy1129 * fbrowsoffset1129;
				float2 fboffset1129 = float2(fboffsetx1129, fboffsety1129);
				half2 fbuv1129 = temp_output_1046_0 * fbtiling1129 + fboffset1129;
				float2 lerpResult1069 = lerp( temp_output_1046_0 , fbuv1129 , _T4_AnimatedGrunge);
				float3 temp_cast_63 = (SAMPLE_TEXTURE2D_ARRAY( _TA_4_Textures, sampler_TA_4_Textures, lerpResult1069,5.0 ).r).xxx;
				float grayscale1097 = Luminance(temp_cast_63);
				float4 temp_cast_64 = (grayscale1097).xxxx;
				float localStochasticTiling216_g51 = ( 0.0 );
				float2 temp_cast_65 = (_T4_PaintGrunge_Tiling).xx;
				float2 temp_output_104_0_g51 = temp_cast_65;
				float3 temp_output_80_0_g51 = WorldPosition;
				float2 Triplanar_UV050_g51 = ( temp_output_104_0_g51 * (temp_output_80_0_g51).zy );
				float2 UV216_g51 = Triplanar_UV050_g51;
				float2 UV1216_g51 = float2( 0,0 );
				float2 UV2216_g51 = float2( 0,0 );
				float2 UV3216_g51 = float2( 0,0 );
				float W1216_g51 = 0.0;
				float W2216_g51 = 0.0;
				float W3216_g51 = 0.0;
				StochasticTiling( UV216_g51 , UV1216_g51 , UV2216_g51 , UV3216_g51 , W1216_g51 , W2216_g51 , W3216_g51 );
				float Input_Index184_g51 = 4.0;
				float2 temp_output_280_0_g51 = ddx( Triplanar_UV050_g51 );
				float2 temp_output_275_0_g51 = ddy( Triplanar_UV050_g51 );
				float localTriplanarWeights229_g51 = ( 0.0 );
				float3 WorldNormal229_g51 = ase_worldNormal;
				float W0229_g51 = 0.0;
				float W1229_g51 = 0.0;
				float W2229_g51 = 0.0;
				TriplanarWeights229_g51( WorldNormal229_g51 , W0229_g51 , W1229_g51 , W2229_g51 );
				float localStochasticTiling215_g51 = ( 0.0 );
				float2 Triplanar_UV164_g51 = ( temp_output_104_0_g51 * (temp_output_80_0_g51).zx );
				float2 UV215_g51 = Triplanar_UV164_g51;
				float2 UV1215_g51 = float2( 0,0 );
				float2 UV2215_g51 = float2( 0,0 );
				float2 UV3215_g51 = float2( 0,0 );
				float W1215_g51 = 0.0;
				float W2215_g51 = 0.0;
				float W3215_g51 = 0.0;
				StochasticTiling( UV215_g51 , UV1215_g51 , UV2215_g51 , UV3215_g51 , W1215_g51 , W2215_g51 , W3215_g51 );
				float2 temp_output_242_0_g51 = ddx( Triplanar_UV164_g51 );
				float2 temp_output_247_0_g51 = ddy( Triplanar_UV164_g51 );
				float localStochasticTiling201_g51 = ( 0.0 );
				float2 Triplanar_UV271_g51 = ( temp_output_104_0_g51 * (temp_output_80_0_g51).xy );
				float2 UV201_g51 = Triplanar_UV271_g51;
				float2 UV1201_g51 = float2( 0,0 );
				float2 UV2201_g51 = float2( 0,0 );
				float2 UV3201_g51 = float2( 0,0 );
				float W1201_g51 = 0.0;
				float W2201_g51 = 0.0;
				float W3201_g51 = 0.0;
				StochasticTiling( UV201_g51 , UV1201_g51 , UV2201_g51 , UV3201_g51 , W1201_g51 , W2201_g51 , W3201_g51 );
				float2 temp_output_214_0_g51 = ddx( Triplanar_UV271_g51 );
				float2 temp_output_258_0_g51 = ddy( Triplanar_UV271_g51 );
				float4 Output_TriplanarArray296_g51 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV1216_g51,Input_Index184_g51, temp_output_280_0_g51, temp_output_275_0_g51 ) * W1216_g51 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV2216_g51,Input_Index184_g51, temp_output_280_0_g51, temp_output_275_0_g51 ) * W2216_g51 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV3216_g51,Input_Index184_g51, temp_output_280_0_g51, temp_output_275_0_g51 ) * W3216_g51 ) ) * W0229_g51 ) + ( W1229_g51 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV1215_g51,Input_Index184_g51, temp_output_242_0_g51, temp_output_247_0_g51 ) * W1215_g51 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV2215_g51,Input_Index184_g51, temp_output_242_0_g51, temp_output_247_0_g51 ) * W2215_g51 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV3215_g51,Input_Index184_g51, temp_output_242_0_g51, temp_output_247_0_g51 ) * W3215_g51 ) ) ) + ( W2229_g51 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV1201_g51,Input_Index184_g51, temp_output_214_0_g51, temp_output_258_0_g51 ) * W1201_g51 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV2201_g51,Input_Index184_g51, temp_output_214_0_g51, temp_output_258_0_g51 ) * W2201_g51 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV3201_g51,Input_Index184_g51, temp_output_214_0_g51, temp_output_258_0_g51 ) * W3201_g51 ) ) ) );
				float localStochasticTiling216_g54 = ( 0.0 );
				float2 temp_cast_66 = (1.0).xx;
				float2 temp_output_104_0_g54 = temp_cast_66;
				float3 temp_output_80_0_g54 = WorldPosition;
				float2 Triplanar_UV050_g54 = ( temp_output_104_0_g54 * (temp_output_80_0_g54).zy );
				float2 UV216_g54 = Triplanar_UV050_g54;
				float2 UV1216_g54 = float2( 0,0 );
				float2 UV2216_g54 = float2( 0,0 );
				float2 UV3216_g54 = float2( 0,0 );
				float W1216_g54 = 0.0;
				float W2216_g54 = 0.0;
				float W3216_g54 = 0.0;
				StochasticTiling( UV216_g54 , UV1216_g54 , UV2216_g54 , UV3216_g54 , W1216_g54 , W2216_g54 , W3216_g54 );
				float Input_Index184_g54 = 0.0;
				float2 temp_output_280_0_g54 = ddx( Triplanar_UV050_g54 );
				float2 temp_output_275_0_g54 = ddy( Triplanar_UV050_g54 );
				float localTriplanarWeights229_g54 = ( 0.0 );
				float3 WorldNormal229_g54 = ase_worldNormal;
				float W0229_g54 = 0.0;
				float W1229_g54 = 0.0;
				float W2229_g54 = 0.0;
				TriplanarWeights229_g54( WorldNormal229_g54 , W0229_g54 , W1229_g54 , W2229_g54 );
				float localStochasticTiling215_g54 = ( 0.0 );
				float2 Triplanar_UV164_g54 = ( temp_output_104_0_g54 * (temp_output_80_0_g54).zx );
				float2 UV215_g54 = Triplanar_UV164_g54;
				float2 UV1215_g54 = float2( 0,0 );
				float2 UV2215_g54 = float2( 0,0 );
				float2 UV3215_g54 = float2( 0,0 );
				float W1215_g54 = 0.0;
				float W2215_g54 = 0.0;
				float W3215_g54 = 0.0;
				StochasticTiling( UV215_g54 , UV1215_g54 , UV2215_g54 , UV3215_g54 , W1215_g54 , W2215_g54 , W3215_g54 );
				float2 temp_output_242_0_g54 = ddx( Triplanar_UV164_g54 );
				float2 temp_output_247_0_g54 = ddy( Triplanar_UV164_g54 );
				float localStochasticTiling201_g54 = ( 0.0 );
				float2 Triplanar_UV271_g54 = ( temp_output_104_0_g54 * (temp_output_80_0_g54).xy );
				float2 UV201_g54 = Triplanar_UV271_g54;
				float2 UV1201_g54 = float2( 0,0 );
				float2 UV2201_g54 = float2( 0,0 );
				float2 UV3201_g54 = float2( 0,0 );
				float W1201_g54 = 0.0;
				float W2201_g54 = 0.0;
				float W3201_g54 = 0.0;
				StochasticTiling( UV201_g54 , UV1201_g54 , UV2201_g54 , UV3201_g54 , W1201_g54 , W2201_g54 , W3201_g54 );
				float2 temp_output_214_0_g54 = ddx( Triplanar_UV271_g54 );
				float2 temp_output_258_0_g54 = ddy( Triplanar_UV271_g54 );
				float4 Output_TriplanarArray296_g54 = ( ( ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV1216_g54,Input_Index184_g54, temp_output_280_0_g54, temp_output_275_0_g54 ) * W1216_g54 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV2216_g54,Input_Index184_g54, temp_output_280_0_g54, temp_output_275_0_g54 ) * W2216_g54 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV3216_g54,Input_Index184_g54, temp_output_280_0_g54, temp_output_275_0_g54 ) * W3216_g54 ) ) * W0229_g54 ) + ( W1229_g54 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV1215_g54,Input_Index184_g54, temp_output_242_0_g54, temp_output_247_0_g54 ) * W1215_g54 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV2215_g54,Input_Index184_g54, temp_output_242_0_g54, temp_output_247_0_g54 ) * W2215_g54 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV3215_g54,Input_Index184_g54, temp_output_242_0_g54, temp_output_247_0_g54 ) * W3215_g54 ) ) ) + ( W2229_g54 * ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV1201_g54,Input_Index184_g54, temp_output_214_0_g54, temp_output_258_0_g54 ) * W1201_g54 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV2201_g54,Input_Index184_g54, temp_output_214_0_g54, temp_output_258_0_g54 ) * W2201_g54 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Textures, sampler_TA_4_Textures, UV3201_g54,Input_Index184_g54, temp_output_214_0_g54, temp_output_258_0_g54 ) * W3201_g54 ) ) ) );
				float4 temp_output_1079_0 = ( _T4_ColorCorrection * Output_TriplanarArray296_g54 );
				float grayscale1051 = dot(temp_output_1079_0.rgb, float3(0.299,0.587,0.114));
				float4 temp_cast_68 = (grayscale1051).xxxx;
				float4 lerpResult1074 = lerp( temp_output_1079_0 , temp_cast_68 , GrayscaleDebug614);
				float4 blendOpSrc1064 = ( ( CalculateContrast(_T4_AnimatedGrunge_Contrast,temp_cast_64) * _T4_AnimatedGrunge_Multiply ) * ( CalculateContrast(_T4_PaintGrunge_Contrast,Output_TriplanarArray296_g51) * _T4_PaintGrunge_Multiply ).r );
				float4 blendOpDest1064 = lerpResult1074;
				float4 T4_RGB1122 = ( saturate( ( blendOpSrc1064 * blendOpDest1064 ) ));
				float4 tex2DArrayNode1142 = SAMPLE_TEXTURE2D_ARRAY( _TA_4_Textures, sampler_TA_4_Textures, texCoord1057,2.0 );
				float T4_RimLightMask_Texture1102 = tex2DArrayNode1142.a;
				float4 T4_RimLight_Texture1101 = tex2DArrayNode1142;
				float4 lerpResult1147 = lerp( _T4_CustomRimLight_Color , T4_RimLight_Texture1101 , _T4_CutomRimLight_Texture);
				float4 T4_CustomRimLight1131 = ( ( T4_RimLightMask_Texture1102 * _T4_CustomRimLight_Opacity ) * lerpResult1147 );
				float4 blendOpSrc1055 = T4_RGB1122;
				float4 blendOpDest1055 = T4_CustomRimLight1131;
				float4 lerpResult1053 = lerp( T4_RGB1122 , ( saturate( max( blendOpSrc1055, blendOpDest1055 ) )) , _T4_CustomRimLight);
				float4 T4_End_OutBrume1120 = lerpResult1053;
				float smoothstepResult1320 = smoothstep( ( _T4_IB_ShadowDrippingNoise_Smoothstep + _T4_IB_ShadowDrippingNoise_Step ) , _T4_IB_ShadowDrippingNoise_Step , normal_LightDir140);
				float4 temp_cast_69 = (smoothstepResult1320).xxxx;
				float2 temp_cast_70 = (_DrippingNoise_Tiling6).xx;
				float2 texCoord1291 = IN.ase_texcoord5.xy * temp_cast_70 + _T4_IB_ShadowDrippingNoise_Offset;
				float4 temp_output_1288_0 = ( temp_cast_69 - tex2D( _InBrumeDrippingNoise, texCoord1291 ) );
				float4 temp_cast_71 = (step( normal_LightDir140 , _T4_IB_ShadowDrippingNoise_Step )).xxxx;
				float4 blendOpSrc1290 = temp_output_1288_0;
				float4 blendOpDest1290 = temp_cast_71;
				float4 temp_cast_72 = (smoothstepResult1320).xxxx;
				float4 lerpBlendMode1290 = lerp(blendOpDest1290,max( blendOpSrc1290, blendOpDest1290 ),( 1.0 - step( temp_output_1288_0 , float4( 0,0,0,0 ) ) ).r);
				float4 temp_cast_74 = (step( normal_LightDir140 , _T4_IB_ShadowDrippingNoise_Step )).xxxx;
				float4 lerpResult1323 = lerp( ( saturate( lerpBlendMode1290 )) , temp_cast_74 , _T4_IB_ShadowDrippingNoise_Transition);
				float4 T4_IB_ShadowDrippingNoise1356 = lerpResult1323;
				float localStochasticTiling171_g57 = ( 0.0 );
				float2 temp_cast_75 = (_T4_IB_ShadowGrunge_Tiling).xx;
				float2 texCoord1317 = IN.ase_texcoord5.xy * temp_cast_75 + float2( 0,0 );
				float2 Input_UV145_g57 = texCoord1317;
				float2 UV171_g57 = Input_UV145_g57;
				float2 UV1171_g57 = float2( 0,0 );
				float2 UV2171_g57 = float2( 0,0 );
				float2 UV3171_g57 = float2( 0,0 );
				float W1171_g57 = 0.0;
				float W2171_g57 = 0.0;
				float W3171_g57 = 0.0;
				StochasticTiling( UV171_g57 , UV1171_g57 , UV2171_g57 , UV3171_g57 , W1171_g57 , W2171_g57 , W3171_g57 );
				float Input_Index184_g57 = 0.2;
				float2 temp_output_172_0_g57 = ddx( Input_UV145_g57 );
				float2 temp_output_182_0_g57 = ddy( Input_UV145_g57 );
				float4 Output_2DArray294_g57 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV1171_g57,Input_Index184_g57, temp_output_172_0_g57, temp_output_182_0_g57 ) * W1171_g57 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV2171_g57,Input_Index184_g57, temp_output_172_0_g57, temp_output_182_0_g57 ) * W2171_g57 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV3171_g57,Input_Index184_g57, temp_output_172_0_g57, temp_output_182_0_g57 ) * W3171_g57 ) );
				float grayscale1319 = Luminance(CalculateContrast(_T4_IB_ShadowGrunge_Contrast,Output_2DArray294_g57).rgb);
				float T4_IB_ShadowGrunge1348 = grayscale1319;
				float4 blendOpSrc1322 = ( _T4_IB_BackColor * ( 1.0 - T4_IB_ShadowDrippingNoise1356 ).r );
				float4 blendOpDest1322 = ( _T4_IB_ShadowColor * ( T4_IB_ShadowDrippingNoise1356 * T4_IB_ShadowGrunge1348 ) );
				float localStochasticTiling171_g58 = ( 0.0 );
				float2 temp_cast_77 = (_T4_IB_NormalGrunge_Tiling).xx;
				float2 texCoord1298 = IN.ase_texcoord5.xy * temp_cast_77 + float2( 0,0 );
				float2 Input_UV145_g58 = texCoord1298;
				float2 UV171_g58 = Input_UV145_g58;
				float2 UV1171_g58 = float2( 0,0 );
				float2 UV2171_g58 = float2( 0,0 );
				float2 UV3171_g58 = float2( 0,0 );
				float W1171_g58 = 0.0;
				float W2171_g58 = 0.0;
				float W3171_g58 = 0.0;
				StochasticTiling( UV171_g58 , UV1171_g58 , UV2171_g58 , UV3171_g58 , W1171_g58 , W2171_g58 , W3171_g58 );
				float Input_Index184_g58 = 0.2;
				float2 temp_output_172_0_g58 = ddx( Input_UV145_g58 );
				float2 temp_output_182_0_g58 = ddy( Input_UV145_g58 );
				float4 Output_2DArray294_g58 = ( ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV1171_g58,Input_Index184_g58, temp_output_172_0_g58, temp_output_182_0_g58 ) * W1171_g58 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV2171_g58,Input_Index184_g58, temp_output_172_0_g58, temp_output_182_0_g58 ) * W2171_g58 ) + ( SAMPLE_TEXTURE2D_ARRAY_GRAD( _TA_4_Grunges, sampler_TA_4_Grunges, UV3171_g58,Input_Index184_g58, temp_output_172_0_g58, temp_output_182_0_g58 ) * W3171_g58 ) );
				float grayscale1307 = Luminance(CalculateContrast(_T4_IB_NormalGrunge_Contrast,Output_2DArray294_g58).rgb);
				float T4_IB_NormalGrunge1357 = grayscale1307;
				float grayscale1316 = (T4_Normal_Texture1100.rgb.r + T4_Normal_Texture1100.rgb.g + T4_Normal_Texture1100.rgb.b) / 3;
				float temp_output_1329_0 = step( grayscale1316 , _T4_IB_NormalDrippingNoise_Step );
				float smoothstepResult1311 = smoothstep( _T4_IB_NormalDrippingNoise_Step , ( _T4_IB_NormalDrippingNoise_Step + _T4_IB_NormalDrippingNoise_Smoothstep ) , grayscale1316);
				float4 temp_cast_80 = (( 1.0 - smoothstepResult1311 )).xxxx;
				float2 temp_cast_81 = (_T4_IB_NormalDrippingNoise_Tiling).xx;
				float2 texCoord1331 = IN.ase_texcoord5.xy * temp_cast_81 + _T4_IB_NormalDrippingNoise_Offset;
				float4 temp_output_1328_0 = ( temp_output_1329_0 + ( temp_cast_80 - tex2D( _InBrumeDrippingNoise, texCoord1331 ) ) );
				float4 temp_cast_82 = (( 1.0 - smoothstepResult1311 )).xxxx;
				float4 blendOpSrc1327 = ( T4_IB_NormalGrunge1357 * temp_output_1328_0 );
				float4 blendOpDest1327 = ( 1.0 - temp_output_1328_0 );
				float4 lerpBlendMode1327 = lerp(blendOpDest1327,max( blendOpSrc1327, blendOpDest1327 ),temp_output_1329_0);
				float4 T4_IB_NormalDrippingGrunge1358 = ( saturate( lerpBlendMode1327 ));
				float4 T4_End_InBrume1361 = ( _T4_IB_ColorCorrection * (float4( 0,0,0,0 ) + (( max( blendOpSrc1322, blendOpDest1322 ) * T4_IB_NormalDrippingGrunge1358 ) - float4( 0,0,0,0 )) * (float4( 1,1,1,1 ) - float4( 0,0,0,0 )) / (float4( 1,1,1,1 ) - float4( 0,0,0,0 ))) );
				float4 lerpResult1050 = lerp( T4_End_OutBrume1120 , T4_End_InBrume1361 , Out_or_InBrume606);
				float4 Texture4_Final1364 = lerpResult1050;
				float4 temp_cast_83 = (Texture4_Final1364).xxxx;
				float4 DebugColor4479 = SAMPLE_TEXTURE2D_ARRAY( _DebugTextureArray, sampler_DebugTextureArray, texCoord563,3.0 );
				float4 lerpResult580 = lerp( temp_cast_83 , DebugColor4479 , DebugVertexPaint566);
				float4 lerpResult495 = lerp( lerpResult14 , lerpResult580 , IN.ase_color.b);
				float4 AllAlbedo622 = lerpResult495;
				float temp_output_420_0 = ( _StepShadow + _StepAttenuation );
				float smoothstepResult430 = smoothstep( _StepShadow , temp_output_420_0 , normal_LightDir140);
				float2 temp_cast_84 = (_Noise_Tiling).xx;
				float2 texCoord170 = IN.ase_texcoord5.xy * temp_cast_84 + float2( 0,0 );
				float2 lerpResult157 = lerp( texCoord170 , ( (ase_screenPosNorm).xy * _Noise_Tiling ) , _ScreenBasedShadowNoise);
				float2 panner362 = ( 1.0 * _Time.y * ( _ShadowNoisePanner + float2( 0.1,0.05 ) ) + lerpResult157);
				float2 panner359 = ( 1.0 * _Time.y * _ShadowNoisePanner + lerpResult157);
				float blendOpSrc365 = tex2D( _ShadowNoise, ( panner362 + float2( 0.5,0.5 ) ) ).r;
				float blendOpDest365 = tex2D( _ShadowNoise, panner359 ).r;
				float MapNoise197 = ( saturate( 2.0f*blendOpDest365*blendOpSrc365 + blendOpDest365*blendOpDest365*(1.0f - 2.0f*blendOpSrc365) ));
				float smoothstepResult408 = smoothstep( 0.0 , 0.6 , ( smoothstepResult430 - MapNoise197 ));
				float smoothstepResult406 = smoothstep( ( _StepShadow + -0.02 ) , ( temp_output_420_0 + -0.02 ) , normal_LightDir140);
				float blendOpSrc429 = smoothstepResult408;
				float blendOpDest429 = smoothstepResult406;
				float4 temp_cast_85 = (( saturate( ( 1.0 - ( ( 1.0 - blendOpDest429) / max( blendOpSrc429, 0.00001) ) ) ))).xxxx;
				float4 blendOpSrc434 = temp_cast_85;
				float4 blendOpDest434 = _ShadowColor;
				float4 temp_output_434_0 = ( saturate( ( blendOpSrc434 * blendOpDest434 ) ));
				float4 temp_output_431_0 = step( temp_output_434_0 , float4( 0,0,0,0 ) );
				float4 Shadows428 = ( temp_output_431_0 + temp_output_434_0 );
				float4 temp_cast_86 = (1.0).xxxx;
				float4 lerpResult1010 = lerp( Shadows428 , temp_cast_86 , Out_or_InBrume606);
				float4 temp_cast_87 = (normal_LightDir140).xxxx;
				float LightDebug608 = _LightDebug;
				float4 lerpResult282 = lerp( ( AllAlbedo622 * lerpResult1010 ) , temp_cast_87 , LightDebug608);
				float NormalDebug610 = _NormalDebug;
				float4 lerpResult286 = lerp( lerpResult282 , T1_Normal_Texture139 , NormalDebug610);
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = lerpResult286.rgb;
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
			float4 _T2_ColorCorrection;
			float4 _T2_IB_ShadowColor;
			float4 _T4_IB_ShadowColor;
			float4 _T4_IB_BackColor;
			float4 _T1_IB_BackColor;
			float4 _T1_IB_ColorCorrection;
			float4 _T4_IB_ColorCorrection;
			float4 _T1_CustomRimLight_Color;
			float4 _T3_IB_ShadowColor;
			float4 _T1_ColorCorrection;
			float4 _T4_CustomRimLight_Color;
			float4 _T3_IB_ColorCorrection;
			float4 _T4_ColorCorrection;
			float4 _T3_ColorCorrection;
			float4 _T2_IB_BackColor;
			float4 _T2_IB_ColorCorrection;
			float4 _T3_CustomRimLight_Color;
			float4 _T2_CustomRimLight_Color;
			float4 _ShadowColor;
			float4 _T3_IB_BackColor;
			float4 _T1_IB_ShadowColor;
			float2 _T1_IB_NormalDrippingNoise_Offset;
			float2 _T2_IB_ShadowDrippingNoise_Offset;
			float2 _T4_IB_ShadowDrippingNoise_Offset;
			float2 _T1_IB_ShadowDrippingNoise_Offset;
			float2 _ShadowNoisePanner;
			float2 _T3_IB_NormalDrippingNoise_Offset;
			float2 _T2_IB_NormalDrippingNoise_Offset;
			float2 _T4_IB_NormalDrippingNoise_Offset;
			float2 _T3_IB_ShadowDrippingNoise_Offset;
			float _T3_IB_ShadowGrunge_Tiling;
			float _T3_IB_ShadowDrippingNoise_Step;
			float _T3_IB_ShadowDrippingNoise_Smoothstep;
			float _T3_IB_NormalGrunge_Contrast;
			float _T3_IB_ShadowDrippingNoise_Transition;
			float _T3_IB_NormalGrunge_Tiling;
			float _T3_CustomRimLight;
			float _T3_IB_NormalDrippingNoise_Step;
			float _T3_CutomRimLight_Texture;
			float _T3_IB_ShadowGrunge_Contrast;
			float _T3_IB_NormalDrippingNoise_Smoothstep;
			float _T3_IB_NormalDrippingNoise_Tiling;
			float _T3_CustomRimLight_Opacity;
			float _DrippingNoise_Tiling5;
			float _T1_AnimatedGrunge_Contrast;
			float _T4_PaintGrunge_Tiling;
			float _T4_NonAnimatedGrunge_Tiling;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _StepAttenuation;
			float _StepShadow;
			float _T4_IB_NormalDrippingNoise_Tiling;
			float _T4_IB_NormalDrippingNoise_Smoothstep;
			float _T4_IB_NormalDrippingNoise_Step;
			float _T4_IB_NormalGrunge_Tiling;
			float _T4_IB_NormalGrunge_Contrast;
			float _T4_IB_ShadowGrunge_Tiling;
			float _T4_IB_ShadowGrunge_Contrast;
			float _T4_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling6;
			float _T4_IB_ShadowDrippingNoise_Step;
			float _T4_IB_ShadowDrippingNoise_Smoothstep;
			float _T4_CustomRimLight;
			float _T4_CutomRimLight_Texture;
			float _T4_CustomRimLight_Opacity;
			float _T4_PaintGrunge_Multiply;
			float _T4_PaintGrunge_Contrast;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Multiply;
			float _T3_NonAnimatedGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _DebugVertexPaint;
			float _DebugTextureTiling;
			float _Out_or_InBrume;
			float _T1_IB_NormalDrippingNoise_Tiling;
			float _T1_IB_NormalDrippingNoise_Smoothstep;
			float _T1_IB_NormalDrippingNoise_Step;
			float _T1_IB_NormalGrunge_Tiling;
			float _T1_IB_NormalGrunge_Contrast;
			float _T1_IB_ShadowGrunge_Tiling;
			float _T1_IB_ShadowGrunge_Contrast;
			float _T1_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling3;
			float _T1_IB_ShadowDrippingNoise_Step;
			float _T1_IB_ShadowDrippingNoise_Smoothstep;
			float _T1_CustomRimLight;
			float _T1_CutomRimLight_Texture;
			float _T1_CustomRimLight_Opacity;
			float _GrayscaleDebug;
			float _T1_PaintGrunge_Multiply;
			float _T1_PaintGrunge_Tiling;
			float _T1_PaintGrunge_Contrast;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_NonAnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Tiling;
			float _T2_NonAnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _LightDebug;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_IB_NormalDrippingNoise_Tiling;
			float _T2_IB_NormalDrippingNoise_Smoothstep;
			float _T2_IB_NormalDrippingNoise_Step;
			float _T2_IB_NormalGrunge_Tiling;
			float _T2_IB_NormalGrunge_Contrast;
			float _T2_IB_ShadowGrunge_Tiling;
			float _T2_IB_ShadowGrunge_Contrast;
			float _T2_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling4;
			float _T2_IB_ShadowDrippingNoise_Step;
			float _T2_IB_ShadowDrippingNoise_Smoothstep;
			float _T2_CustomRimLight;
			float _T2_CutomRimLight_Texture;
			float _T2_CustomRimLight_Opacity;
			float _T2_PaintGrunge_Multiply;
			float _T2_PaintGrunge_Tiling;
			float _T2_PaintGrunge_Contrast;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_AnimatedGrunge;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _NormalDebug;
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
			float4 _T2_ColorCorrection;
			float4 _T2_IB_ShadowColor;
			float4 _T4_IB_ShadowColor;
			float4 _T4_IB_BackColor;
			float4 _T1_IB_BackColor;
			float4 _T1_IB_ColorCorrection;
			float4 _T4_IB_ColorCorrection;
			float4 _T1_CustomRimLight_Color;
			float4 _T3_IB_ShadowColor;
			float4 _T1_ColorCorrection;
			float4 _T4_CustomRimLight_Color;
			float4 _T3_IB_ColorCorrection;
			float4 _T4_ColorCorrection;
			float4 _T3_ColorCorrection;
			float4 _T2_IB_BackColor;
			float4 _T2_IB_ColorCorrection;
			float4 _T3_CustomRimLight_Color;
			float4 _T2_CustomRimLight_Color;
			float4 _ShadowColor;
			float4 _T3_IB_BackColor;
			float4 _T1_IB_ShadowColor;
			float2 _T1_IB_NormalDrippingNoise_Offset;
			float2 _T2_IB_ShadowDrippingNoise_Offset;
			float2 _T4_IB_ShadowDrippingNoise_Offset;
			float2 _T1_IB_ShadowDrippingNoise_Offset;
			float2 _ShadowNoisePanner;
			float2 _T3_IB_NormalDrippingNoise_Offset;
			float2 _T2_IB_NormalDrippingNoise_Offset;
			float2 _T4_IB_NormalDrippingNoise_Offset;
			float2 _T3_IB_ShadowDrippingNoise_Offset;
			float _T3_IB_ShadowGrunge_Tiling;
			float _T3_IB_ShadowDrippingNoise_Step;
			float _T3_IB_ShadowDrippingNoise_Smoothstep;
			float _T3_IB_NormalGrunge_Contrast;
			float _T3_IB_ShadowDrippingNoise_Transition;
			float _T3_IB_NormalGrunge_Tiling;
			float _T3_CustomRimLight;
			float _T3_IB_NormalDrippingNoise_Step;
			float _T3_CutomRimLight_Texture;
			float _T3_IB_ShadowGrunge_Contrast;
			float _T3_IB_NormalDrippingNoise_Smoothstep;
			float _T3_IB_NormalDrippingNoise_Tiling;
			float _T3_CustomRimLight_Opacity;
			float _DrippingNoise_Tiling5;
			float _T1_AnimatedGrunge_Contrast;
			float _T4_PaintGrunge_Tiling;
			float _T4_NonAnimatedGrunge_Tiling;
			float _ScreenBasedShadowNoise;
			float _Noise_Tiling;
			float _StepAttenuation;
			float _StepShadow;
			float _T4_IB_NormalDrippingNoise_Tiling;
			float _T4_IB_NormalDrippingNoise_Smoothstep;
			float _T4_IB_NormalDrippingNoise_Step;
			float _T4_IB_NormalGrunge_Tiling;
			float _T4_IB_NormalGrunge_Contrast;
			float _T4_IB_ShadowGrunge_Tiling;
			float _T4_IB_ShadowGrunge_Contrast;
			float _T4_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling6;
			float _T4_IB_ShadowDrippingNoise_Step;
			float _T4_IB_ShadowDrippingNoise_Smoothstep;
			float _T4_CustomRimLight;
			float _T4_CutomRimLight_Texture;
			float _T4_CustomRimLight_Opacity;
			float _T4_PaintGrunge_Multiply;
			float _T4_PaintGrunge_Contrast;
			float _T4_AnimatedGrunge_Multiply;
			float _T4_AnimatedGrunge;
			float _T4_AnimatedGrunge_Flipbook_Speed;
			float _T4_AnimatedGrunge_Flipbook_Rows;
			float _T4_AnimatedGrunge_Flipbook_Columns;
			float _T4_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Multiply;
			float _T3_NonAnimatedGrunge_Tiling;
			float _T3_PaintGrunge_Contrast;
			float _DebugVertexPaint;
			float _DebugTextureTiling;
			float _Out_or_InBrume;
			float _T1_IB_NormalDrippingNoise_Tiling;
			float _T1_IB_NormalDrippingNoise_Smoothstep;
			float _T1_IB_NormalDrippingNoise_Step;
			float _T1_IB_NormalGrunge_Tiling;
			float _T1_IB_NormalGrunge_Contrast;
			float _T1_IB_ShadowGrunge_Tiling;
			float _T1_IB_ShadowGrunge_Contrast;
			float _T1_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling3;
			float _T1_IB_ShadowDrippingNoise_Step;
			float _T1_IB_ShadowDrippingNoise_Smoothstep;
			float _T1_CustomRimLight;
			float _T1_CutomRimLight_Texture;
			float _T1_CustomRimLight_Opacity;
			float _GrayscaleDebug;
			float _T1_PaintGrunge_Multiply;
			float _T1_PaintGrunge_Tiling;
			float _T1_PaintGrunge_Contrast;
			float _T1_AnimatedGrunge_Multiply;
			float _T1_AnimatedGrunge;
			float _T1_AnimatedGrunge_Flipbook_Speed;
			float _T1_AnimatedGrunge_Flipbook_Rows;
			float _T1_AnimatedGrunge_Flipbook_Columns;
			float _T1_NonAnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Contrast;
			float _T3_PaintGrunge_Tiling;
			float _T2_NonAnimatedGrunge_Tiling;
			float _T2_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Multiply;
			float _T3_AnimatedGrunge;
			float _T3_AnimatedGrunge_Flipbook_Speed;
			float _T3_AnimatedGrunge_Flipbook_Rows;
			float _T3_AnimatedGrunge_Flipbook_Columns;
			float _LightDebug;
			float _T3_AnimatedGrunge_Contrast;
			float _T2_IB_NormalDrippingNoise_Tiling;
			float _T2_IB_NormalDrippingNoise_Smoothstep;
			float _T2_IB_NormalDrippingNoise_Step;
			float _T2_IB_NormalGrunge_Tiling;
			float _T2_IB_NormalGrunge_Contrast;
			float _T2_IB_ShadowGrunge_Tiling;
			float _T2_IB_ShadowGrunge_Contrast;
			float _T2_IB_ShadowDrippingNoise_Transition;
			float _DrippingNoise_Tiling4;
			float _T2_IB_ShadowDrippingNoise_Step;
			float _T2_IB_ShadowDrippingNoise_Smoothstep;
			float _T2_CustomRimLight;
			float _T2_CutomRimLight_Texture;
			float _T2_CustomRimLight_Opacity;
			float _T2_PaintGrunge_Multiply;
			float _T2_PaintGrunge_Tiling;
			float _T2_PaintGrunge_Contrast;
			float _T2_AnimatedGrunge_Multiply;
			float _T2_AnimatedGrunge;
			float _T2_AnimatedGrunge_Flipbook_Speed;
			float _T2_AnimatedGrunge_Flipbook_Columns;
			float _NormalDebug;
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
1920;0;1920;1019;10502.43;6047.885;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1373;-4659.422,-7051.386;Inherit;False;4968.104;3818.704;OTHER VARIABLES;7;587;28;30;604;699;39;588;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;746;-15559.13,-7072.62;Inherit;False;10769.91;2740.058;TEXTURE 1;4;42;740;29;749;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;750;-15558.96,-4297.144;Inherit;False;10769.91;2740.058;TEXTURE 2;4;760;753;752;930;;1,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1014;-15557.25,1271.575;Inherit;False;10769.91;2740.058;TEXTURE 4;4;1029;1020;1019;1018;;0,0,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1013;-15557.42,-1503.901;Inherit;False;10769.91;2740.058;TEXTURE 3;4;1044;1017;1016;1015;;0,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;753;-14121.49,-4247.144;Inherit;False;3990.135;2631.681;Paper + Object Texture;8;912;911;816;765;764;762;759;756;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-4609.422,-7001.386;Inherit;False;4669.2;1032.37;Shadow Smooth Edge + Int Shadow;21;427;435;430;426;432;428;429;422;418;420;356;424;421;406;408;433;434;431;416;425;43;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;740;-15478.3,-6904.532;Inherit;False;1279.631;1658.024;Texture Arrays 1;2;27;736;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1016;-15476.59,-1335.813;Inherit;False;1279.631;1658.024;Texture Arrays 3;2;1034;1022;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1015;-10075.92,-1449.218;Inherit;False;5238.415;2629.144;IN BRUME;4;1040;1038;1036;1035;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;42;-14121.66,-7022.62;Inherit;False;3990.135;2631.681;Paper + Object Texture;8;202;184;190;32;718;616;715;730;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1017;-14119.95,-1453.901;Inherit;False;3990.135;2631.681;Paper + Object Texture;8;1187;1108;1107;1039;1037;1032;1031;1028;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;930;-10074.48,-4245.319;Inherit;False;5238.415;2629.144;IN BRUME;4;934;933;932;931;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;-10077.63,-7017.937;Inherit;False;5238.415;2629.144;IN BRUME;4;33;31;34;747;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;752;-15478.13,-4129.056;Inherit;False;1279.631;1658.024;Texture Arrays 2;2;763;757;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1018;-14119.78,1321.575;Inherit;False;3990.135;2631.681;Paper + Object Texture;8;1122;1065;1064;1030;1026;1024;1023;1021;;0.7848188,1,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1019;-15476.42,1439.663;Inherit;False;1279.631;1658.024;Texture Arrays 4;2;1027;1025;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1020;-10072.77,1323.4;Inherit;False;5238.415;2629.144;IN BRUME;4;1043;1042;1041;1033;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1037;-14061.75,-1368.932;Inherit;False;2635.696;674.9272;Animated Grunge;18;1191;1186;1161;1160;1156;1154;1152;1130;1112;1110;1109;1104;1089;1087;1086;1082;1081;1080;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;933;-7092.705,-4178.543;Inherit;False;2215.597;998.5103;InBrume FinalPass;17;1004;1003;1002;1001;1000;999;997;977;975;974;968;967;964;962;961;950;947;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1025;-15426.42,2211.362;Inherit;False;1179.63;861.0986;Grunges;15;1372;1366;1148;1140;1139;1138;1137;1115;1111;1098;1077;1070;1059;1058;1052;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1033;-10022.49,2986.934;Inherit;False;3117.294;921.4316;NormalDrippingGrunge;20;1358;1346;1345;1344;1343;1331;1330;1329;1328;1327;1324;1316;1315;1314;1313;1312;1311;1310;1296;1271;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;749;-15274.2,-5086.536;Inherit;False;863.1523;325.855;Texture1_Final;5;748;274;349;340;607;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;934;-10024.2,-2581.784;Inherit;False;3117.294;921.4316;NormalDrippingGrunge;19;1009;1008;1007;1006;1005;998;993;992;990;989;988;987;986;985;960;959;958;957;954;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1036;-10025.64,214.3177;Inherit;False;3117.294;921.4316;NormalDrippingGrunge;19;1354;1286;1285;1284;1283;1282;1276;1267;1266;1265;1264;1263;1255;1234;1233;1232;1231;1230;1212;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1038;-7094.144,-1382.442;Inherit;False;2215.597;998.5103;InBrume FinalPass;17;1365;1355;1353;1281;1280;1279;1278;1277;1275;1270;1259;1256;1252;1227;1226;1225;1217;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;27;-15427.99,-6854.532;Inherit;False;1178.062;699.5752;Textures;13;50;172;71;241;74;177;708;706;171;265;599;139;133;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1042;-10020.52,1389.718;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;20;1356;1347;1336;1335;1333;1332;1323;1321;1320;1294;1293;1292;1291;1290;1289;1288;1287;1274;1273;1272;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1034;-15426.28,-1285.813;Inherit;False;1178.062;699.5752;Textures;13;1368;1363;1362;1207;1206;1204;1203;1202;1184;1178;1176;1164;1090;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1030;-14061.58,1406.545;Inherit;False;2635.696;674.9272;Animated Grunge;18;1173;1162;1159;1158;1157;1155;1150;1141;1129;1097;1078;1075;1069;1067;1066;1061;1060;1046;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;762;-14063.31,-2406.808;Inherit;False;1313.751;503.8408;FinalPass;6;844;839;809;808;807;806;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1028;-14058,-666.1687;Inherit;False;2010.128;593.3951;Paint Grunge;10;1197;1170;1169;1149;1114;1106;1105;1099;1088;1071;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1024;-14061.6,3161.91;Inherit;False;1313.751;503.8408;FinalPass;6;1121;1120;1116;1055;1053;1048;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1027;-15426.11,1489.664;Inherit;False;1178.062;699.5752;Textures;13;1146;1145;1144;1143;1142;1132;1102;1101;1100;1068;1057;1054;1047;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1035;-10023.67,-1382.901;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;19;1253;1251;1250;1249;1248;1246;1244;1242;1237;1229;1228;1224;1223;1222;1221;1220;1219;1218;1177;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1043;-10019.39,2339.738;Inherit;False;2111.269;615.5154;InBrumeGrunge;18;1357;1348;1342;1341;1325;1319;1318;1317;1309;1308;1307;1306;1305;1303;1301;1300;1299;1298;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1029;-15272.32,3257.659;Inherit;False;863.1523;325.855;Texture4_Final;5;1367;1364;1118;1050;1049;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1023;-14057.83,2109.309;Inherit;False;2010.128;593.3951;Paint Grunge;10;1213;1171;1166;1135;1133;1117;1076;1063;1062;1056;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1041;-7090.994,1390.176;Inherit;False;2215.597;998.5103;InBrume FinalPass;17;1370;1361;1352;1351;1349;1340;1339;1338;1337;1334;1326;1322;1304;1302;1297;1295;1174;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1032;-14061.73,-36.73938;Inherit;False;2024.437;397.7363;Albedo;10;1185;1128;1126;1124;1113;1096;1094;1092;1085;1084;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1022;-15426.59,-564.1155;Inherit;False;1179.63;861.0986;Grunges;15;1371;1369;1241;1215;1205;1194;1193;1192;1190;1182;1180;1179;1163;1136;1091;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;765;-14059.54,-3459.41;Inherit;False;2010.128;593.3951;Paint Grunge;10;922;921;916;915;914;913;883;823;818;817;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1044;-15272.49,482.1825;Inherit;False;863.1523;325.855;Texture3_Final;5;1214;1199;1198;1196;1195;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1040;-10022.54,-432.8795;Inherit;False;2111.269;615.5154;InBrumeGrunge;18;1360;1359;1350;1269;1268;1262;1261;1260;1258;1257;1254;1247;1239;1238;1236;1235;1216;1201;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;718;-14063.46,-6937.651;Inherit;False;2635.696;674.9272;Animated Grunge;18;318;224;717;716;403;381;156;146;127;132;130;175;150;163;167;179;158;208;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1039;-14061.77,386.4334;Inherit;False;1313.751;503.8408;FinalPass;6;1245;1211;1209;1200;1181;1119;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;763;-15428.13,-3357.357;Inherit;False;1179.63;861.0986;Grunges;15;880;879;878;877;875;874;873;867;856;853;852;851;850;849;846;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1026;-14061.56,2738.738;Inherit;False;2024.437;397.7363;Albedo;10;1175;1134;1125;1103;1083;1079;1074;1073;1072;1051;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-4602.845,-5904.483;Inherit;False;3145.105;593.8924;Noise;18;159;365;162;386;180;218;363;197;170;128;142;176;359;362;157;168;703;741;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1031;-11250.45,-1380.647;Inherit;False;1038.211;719.015;CustomRimLight;9;1210;1208;1189;1188;1183;1167;1153;1095;1093;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;715;-14059.71,-6234.887;Inherit;False;2010.128;593.3951;Paint Grunge;10;258;377;135;297;285;253;145;336;710;711;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;759;-11251.99,-4173.89;Inherit;False;1038.211;719.015;CustomRimLight;9;928;926;826;815;814;813;812;811;810;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;587;-3259.282,-5238.938;Inherit;False;2067.298;1155.405;Texture Set by Vertex Color;27;622;1;489;573;576;495;580;581;583;584;14;579;578;11;569;571;574;570;565;577;567;7;586;585;3;4;5;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;756;-14063.29,-4162.174;Inherit;False;2635.696;674.9272;Animated Grunge;18;919;918;917;910;909;908;907;891;890;885;884;882;854;841;822;821;820;819;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;760;-15274.03,-2311.059;Inherit;False;863.1523;325.855;Texture2_Final;5;872;871;870;869;868;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;1021;-11250.28,1394.829;Inherit;False;1038.211;719.015;CustomRimLight;9;1172;1168;1165;1151;1147;1131;1127;1123;1045;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-3050.692,-3874.95;Inherit;False;1708.676;476.5241;Final Mix;13;698;2;705;704;286;282;294;609;611;280;1010;1011;1012;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;32;-11252.16,-6949.366;Inherit;False;1038.211;719.015;CustomRimLight;9;385;410;332;397;602;600;262;395;601;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;736;-15428.3,-6132.834;Inherit;False;1179.63;861.0986;Grunges;15;733;714;702;268;700;737;701;735;732;734;731;713;712;738;739;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;43;-4539.759,-6726.153;Inherit;False;1385.351;464.59;Normal Light Dir;7;140;169;413;414;411;358;412;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;616;-14063.44,-5605.458;Inherit;False;2024.437;397.7363;Albedo;10;335;191;252;399;615;617;619;620;621;709;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;931;-10021.1,-3228.981;Inherit;False;2111.269;615.5154;InBrumeGrunge;18;996;995;994;984;983;982;981;980;979;978;976;966;965;963;956;955;952;951;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;764;-14063.27,-2829.981;Inherit;False;2024.437;397.7363;Albedo;10;923;920;906;905;903;889;888;887;886;825;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;932;-10022.23,-4179.001;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;19;973;972;971;970;969;953;948;946;945;944;943;942;941;940;939;938;937;936;935;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;757;-15427.82,-4079.055;Inherit;False;1178.062;699.5752;Textures;13;881;876;866;865;864;863;862;861;860;859;858;857;855;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;34;-10024.25,-6001.598;Inherit;False;2111.269;615.5154;InBrumeGrunge;18;745;743;744;742;249;124;151;261;244;311;329;320;255;306;324;374;322;325;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;699;-1145.114,-5240.528;Inherit;False;1403.795;972.4626;All Normal by Vertex Color;11;644;624;642;632;640;692;635;691;690;694;693;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;747;-7095.855,-6951.161;Inherit;False;2215.597;998.5103;InBrume FinalPass;17;321;248;401;389;393;295;396;289;229;275;164;276;417;264;319;290;256;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;604;-1360.032,-5906.679;Inherit;False;671.5669;606.8997;Global Variables;10;566;564;605;423;606;614;608;613;281;610;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-10027.35,-5354.401;Inherit;False;3117.294;921.4316;NormalDrippingGrunge;19;210;360;339;317;277;383;305;134;154;236;303;206;344;350;178;216;382;296;372;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;730;-14063.48,-5182.285;Inherit;False;1313.751;503.8408;FinalPass;6;405;409;301;415;187;246;;0,0,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;33;-10025.38,-6951.62;Inherit;False;2880.609;924.5469;ShadowDrippingNoise;19;375;364;232;231;222;213;211;196;195;193;189;137;351;355;304;251;240;247;226;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;588;-4598.669,-5236.005;Inherit;False;1281.268;1101.646;Debug Textures;14;590;479;478;477;488;563;559;592;593;594;595;596;597;598;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;1329;-9077.84,3110.395;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1341;-9977.867,2389.233;Inherit;False;1140;TA_4_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;1323;-7599.478,1696.156;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1317;-9548.084,2479.673;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;1316;-9713.975,3039.327;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1315;-8118.785,3114.216;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1319;-8418.966,2391.073;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1251;-9840.497,-1023.173;Inherit;False;Property;_T3_IB_ShadowDrippingNoise_Step;T3_IB_ShadowDrippingNoise_Step;102;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;430;-2387.47,-6937.386;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1321;-7893.425,1820.175;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1326;-6581.37,1649.193;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;1342;-9979.136,2672.447;Inherit;False;1140;TA_4_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1349;-6384.911,1893.453;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1262;-9558.234,-17.94349;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1133;-13966.9,2378.342;Inherit;False;Constant;_Float35;Float 35;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1370;-6586.83,2075.491;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;1249;-9954.673,-752.8225;Inherit;False;Property;_T3_IB_ShadowDrippingNoise_Offset;T3_IB_ShadowDrippingNoise_Offset;104;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BlendOpsNode;1327;-7804.914,3106.973;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1322;-6181.577,1864.009;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1320;-9292.771,1669.832;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1330;-9492.447,3427.901;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1331;-9273.261,3695.883;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1230;-9827.908,659.0876;Inherit;False;Property;_T3_IB_NormalDrippingNoise_Smoothstep;T3_IB_NormalDrippingNoise_Smoothstep;105;0;Create;True;0;0;False;0;False;0.01;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1250;-9949.18,-840.8986;Inherit;False;Property;_DrippingNoise_Tiling5;T3_IB_ShadowDrippingNoise_Tiling;103;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1167;-11185.25,-756.4875;Inherit;False;Property;_T3_CutomRimLight_Texture;T3_CutomRimLight_Texture?;95;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1187;-10584.52,0.2567101;Inherit;False;T3_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1237;-9846.655,-1109.747;Inherit;False;Property;_T3_IB_ShadowDrippingNoise_Smoothstep;T3_IB_ShadowDrippingNoise_Smoothstep;101;0;Create;True;0;0;False;0;False;0.2;0.2797383;0.001;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1328;-8370.328,3408.811;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1350;-9551.234,-292.9435;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1090;-15134.69,-1209.335;Inherit;False;TA_3_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.BlendOpsNode;1245;-13708.08,551.9475;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1261;-9981.017,-383.3835;Inherit;False;1194;TA_3_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.ColorNode;1208;-11163.25,-1012.488;Inherit;False;Property;_T3_CustomRimLight_Color;T3_CustomRimLight_Color;94;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1266;-9999.988,266.7264;Inherit;False;1176;T3_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1153;-11131.39,-1133.872;Inherit;False;Property;_T3_CustomRimLight_Opacity;T3_CustomRimLight_Opacity;96;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1201;-9982.285,-100.1705;Inherit;False;1194;TA_3_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;1238;-9876.822,-192.5573;Inherit;False;Property;_T3_IB_ShadowGrunge_Tiling;T3_IB_ShadowGrunge_Tiling;109;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1216;-9849.383,90.04668;Inherit;False;Property;_T3_IB_NormalGrunge_Tiling;T3_IB_NormalGrunge_Tiling;111;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1193;-15356.57,-494.2053;Inherit;True;Property;_TA_3_Grunges;TA_3_Grunges;82;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;35617828aa5bd8749a5fa9818f29cabe;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;1156;-12320.74,-1064.461;Inherit;False;Property;_T3_AnimatedGrunge_Contrast;T3_AnimatedGrunge_Contrast;88;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1248;-7906.829,-1302.82;Inherit;False;Property;_T3_IB_ShadowDrippingNoise_Transition;T3_IB_ShadowDrippingNoise_Transition;100;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1236;-8993.997,2.414425;Inherit;False;Property;_T3_IB_NormalGrunge_Contrast;T3_IB_NormalGrunge_Contrast;112;0;Create;True;0;0;False;0;False;2.4;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1189;-11153.25,-836.4885;Inherit;False;1202;T3_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1235;-8974.725,-278.4235;Inherit;False;Property;_T3_IB_ShadowGrunge_Contrast;T3_IB_ShadowGrunge_Contrast;110;0;Create;True;0;0;False;0;False;-3.38;-3.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1232;-9808.776,558.7156;Inherit;False;Property;_T3_IB_NormalDrippingNoise_Step;T3_IB_NormalDrippingNoise_Step;106;0;Create;True;0;0;False;0;False;0.45;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1113;-12491.9,123.1565;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1152;-13806.65,-1213.608;Inherit;False;Property;_T3_NonAnimatedGrunge_Tiling;T3_NonAnimatedGrunge_Tiling;84;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1233;-9598.292,880.8455;Inherit;False;Property;_T3_IB_NormalDrippingNoise_Tiling;T3_IB_NormalDrippingNoise_Tiling;107;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1176;-14512.43,-1015.727;Inherit;False;T3_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1231;-8420.061,335.9007;Inherit;False;1360;T3_IB_NormalGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1202;-14532.35,-823.1442;Inherit;False;T3_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1205;-14531.95,-490.5714;Inherit;False;T3_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1215;-14525.22,-293.0524;Inherit;False;T3_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1371;-14558.7,-100.5275;Inherit;False;T3_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1170;-12801.95,-339.0104;Inherit;False;Property;_T3_PaintGrunge_Multiply;T3_PaintGrunge_Multiply;92;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1369;-14554.69,91.29375;Inherit;False;T3_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1191;-13683.7,-956.8566;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Rows;T3_AnimatedGrunge_Flipbook_Rows;86;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1359;-8205.83,-382.8795;Inherit;False;T3_IB_ShadowGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1188;-11127.84,-1324.915;Inherit;True;860;T2_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1360;-8186.327,-97.27357;Inherit;False;T3_IB_NormalGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;1234;-9604.994,968.3005;Inherit;False;Property;_T3_IB_NormalDrippingNoise_Offset;T3_IB_NormalDrippingNoise_Offset;108;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1161;-13322.55,-1219.23;Inherit;False;Property;_T3_AnimatedGrunge;T3_AnimatedGrunge?;83;0;Create;True;0;0;False;1;Header(Paper);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1154;-11987.81,-824.2717;Inherit;False;Property;_T3_AnimatedGrunge_Multiply;T3_AnimatedGrunge_Multiply;89;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1169;-13966,-162.2892;Inherit;False;Property;_T3_PaintGrunge_Tiling;T3_PaintGrunge_Tiling;90;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1197;-14013.08,-594.1707;Inherit;True;1194;TA_3_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1214;-14628.34,536.1824;Inherit;False;Texture3_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;218;-2307.742,-5806.355;Inherit;True;Property;_TextureSample60;Texture Sample 60;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;703;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1183;-10444.81,-1119.944;Inherit;False;T3_CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1241;-14905.95,-491.5715;Inherit;True;Property;_TA_3_Grunges_Sample;TA_3_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1087;-12702.15,-1322.17;Inherit;True;Property;_TextureSample53;Texture Sample 53;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1362;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1178;-14520.43,-1204.725;Inherit;False;T3_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1194;-15117.46,-493.0602;Inherit;False;TA_3_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.ColorNode;1126;-13076.73,157.6595;Inherit;False;Property;_T3_ColorCorrection;T3_ColorCorrection;97;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;1222;-9295.921,-1102.785;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1223;-7602.627,-1076.46;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;1224;-9281.672,-1327.8;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1227;-5397.376,-660.8547;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1228;-9601.316,-1332.901;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1089;-13682.7,-881.8566;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Speed;T3_AnimatedGrunge_Flipbook_Speed;87;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1229;-9391.648,-850.1623;Inherit;True;Property;_TextureSample29;Texture Sample 29;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;741;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1185;-13985.14,14.63659;Inherit;True;1090;TA_3_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1368;-14533.49,-726.2073;Inherit;False;T3_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1149;-13350.02,-425.4093;Inherit;False;Property;_T3_PaintGrunge_Contrast;T3_PaintGrunge_Contrast;91;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1314;-9194.225,3814.131;Inherit;False;Constant;_Float73;Float 73;88;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1010;-2710.894,-3668.561;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;405;-14014.98,-4925.117;Inherit;True;410;T1_CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;1256;-5640.441,-637.4836;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1257;-8424.347,-97.12415;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1258;-9299.409,-379.8034;Inherit;False;Procedural Sample;-1;;55;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1160;-13684.7,-1030.857;Inherit;False;Property;_T3_AnimatedGrunge_Flipbook_Columns;T3_AnimatedGrunge_Flipbook_Columns;85;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1128;-12493.36,208.1897;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1313;-8078.362,3409.347;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;1311;-9093.597,3362.222;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1294;-9559.498,2093.752;Inherit;False;Constant;_Float66;Float 66;88;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;434;-1219.48,-6425.385;Inherit;True;Multiply;True;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;415;-13709.79,-5016.771;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1263;-8856.29,590.0496;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1147;-10809.51,1839.939;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1163;-15306.56,66.06134;Inherit;False;Constant;_Float37;Float 37;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1164;-15371.68,-1004.485;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1174;-6417.15,1472.107;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1177;-9015.694,-936.3522;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1312;-8618.952,3553.364;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1179;-15304.45,141.9764;Inherit;False;Constant;_Float38;Float 38;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1282;-7808.064,334.3568;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1255;-8121.935,341.5995;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1219;-8113.816,-958.1403;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1254;-8666.775,-91.82435;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1246;-8567.04,-712.5823;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;1244;-8773.041,-712.5823;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1209;-13415.19,453.5428;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1210;-10599.69,-1114.51;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1212;-9717.125,266.7108;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1220;-9468.836,-1079.338;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1186;-13503.65,-1287.608;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1218;-9643.009,-820.4416;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;1141;-13543.53,1991.621;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1247;-8422.115,-381.5436;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1136;-15307.56,-8.493289;Inherit;False;Constant;_Float36;Float 36;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1292;-8110.666,1814.476;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1267;-8081.511,636.7307;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;1130;-13790.65,-1293.608;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1295;-5875.612,2134.685;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1296;-9003.225,3666.131;Inherit;True;Property;_TextureSample32;Texture Sample 32;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;741;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;1297;-6772.359,1649.002;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;1289;-8563.891,2060.035;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1196;-14942.91,541.4324;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1298;-9555.084,2754.673;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;1264;-9096.747,589.6057;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1253;-8289.577,-1216.294;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1192;-15348.65,-263.1105;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;1221;-7896.576,-952.4416;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1303;-8663.626,2680.792;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1278;-6184.726,-908.6076;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1265;-8622.102,780.7473;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;1288;-9012.544,1836.265;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1286;-9276.411,923.2664;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;1290;-8286.427,1556.322;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1268;-8672.499,-375.6613;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1291;-9639.858,1952.175;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1293;-9465.686,1693.279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1351;-7040.994,1642.988;Inherit;False;1356;T4_IB_ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1260;-9301.383,-93.95325;Inherit;False;Procedural Sample;-1;;56;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1011;-2911.894,-3643.561;Inherit;False;Constant;_Float6;Float 6;87;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1287;-8769.891,2060.035;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1277;-5878.761,-637.9314;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1279;-6420.3,-1300.51;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1280;-6589.98,-697.1257;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1270;-6388.06,-879.1642;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;176;-4141.909,-5584.326;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;1283;-8373.478,636.1946;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1273;-9388.498,1922.455;Inherit;True;Property;_TextureSample30;Texture Sample 30;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;741;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1242;-7404.784,-1128.073;Inherit;False;T3_IB_ShadowDrippingNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1276;-9006.375,893.5144;Inherit;True;Property;_TextureSample31;Texture Sample 31;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;741;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1272;-9598.166,1439.716;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1284;-9080.99,337.7787;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1226;-7044.144,-1129.629;Inherit;False;1242;T3_IB_ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1102;-14533.32,2049.271;Inherit;False;T4_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1365;-6849.422,-624.1995;Inherit;False;1359;T3_IB_ShadowGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;428;-171.6799,-6446.036;Inherit;False;Shadows;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;432;-1469.48,-6171.385;Inherit;False;Property;_ShadowColor;ShadowColor;12;0;Create;True;0;0;False;0;False;0.8018868,0.8018868,0.8018868,0;0.509434,0.509434,0.509434,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;1274;-9278.521,1444.816;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;422;-2739.47,-6681.385;Inherit;False;Property;_StepAttenuation;StepAttenuation;11;0;Create;True;0;0;False;0;False;-0.07;-0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;1275;-6775.509,-1123.616;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1305;-8669.35,2396.957;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-3740.31,-5580.228;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;1309;-9298.232,2678.664;Inherit;False;Procedural Sample;-1;;58;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TFHCGrayscale;1307;-8421.197,2675.493;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;429;-1635.48,-6425.385;Inherit;True;ColorBurn;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-3517.352,-5510.816;Inherit;False;Property;_ScreenBasedShadowNoise;ScreenBasedShadowNoise?;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;362;-2782.502,-5776.482;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;435;-2195.47,-6393.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;1304;-5637.291,2135.134;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;427;-2195.47,-6297.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1285;-9495.598,655.2844;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;414;-3961.749,-6638.963;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1281;-6584.519,-1123.423;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;1310;-8853.14,3362.667;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;426;-2131.47,-6761.385;Inherit;False;197;MapNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;433;-579.4796,-6873.386;Inherit;False;LightMask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;286;-1825.177,-3791.399;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;408;-1683.48,-6937.386;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.6;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;406;-1987.471,-6425.385;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;-0.75;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;421;-2403.47,-6345.385;Inherit;False;Constant;_Float77;Float 77;11;0;Create;True;0;0;False;0;False;-0.02;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;866;-15380.65,-4003.868;Inherit;True;Property;_TA_2_Textures;TA_2_Textures;48;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;35617828aa5bd8749a5fa9818f29cabe;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;1132;-14520.26,1570.752;Inherit;False;T4_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1308;-9296.259,2392.813;Inherit;False;Procedural Sample;-1;;57;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.PannerNode;359;-2942.513,-5520.482;Inherit;False;3;0;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;140;-3385.751,-6654.963;Inherit;False;normal_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;424;-1907.472,-6937.386;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;416;-2227.47,-6505.385;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1358;-7508.006,3106.8;Inherit;False;T4_IB_NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;595;-4211.925,-4812.445;Inherit;False;Constant;_Float0;Float 0;69;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;571;-3198.832,-4756.302;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;598;-4208.631,-4569.591;Inherit;False;Constant;_Float3;Float 3;69;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1067;-13806.48,1561.869;Inherit;False;Property;_T4_NonAnimatedGrunge_Tiling;T4_NonAnimatedGrunge_Tiling;115;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;418;-435.4796,-6441.385;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;635;-528.6503,-4779.306;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;624;-1062.882,-4475.065;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;356;-2659.47,-6937.386;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;14;-2234.999,-4590.234;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;594;-3950.372,-4350.56;Inherit;True;Property;_TextureSample26;Texture Sample 26;5;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;282;-2223.19,-3793.365;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;592;-3952.372,-4804.56;Inherit;True;Property;_TextureSample24;Texture Sample 24;5;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;412;-4233.749,-6494.964;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;559;-3954.713,-5027.561;Inherit;True;Property;_DebugTextureArray;DebugTextureArray;5;0;Create;True;0;0;False;0;False;-1;fcf4482ca7d817c42b6d03968194b044;fcf4482ca7d817c42b6d03968194b044;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;597;-4208.631,-4650.591;Inherit;False;Constant;_Float2;Float 2;69;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;622;-1419.846,-4335.654;Inherit;False;AllAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;576;-2433.678,-4567.418;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1158;-13683.53,1818.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Rows;T4_AnimatedGrunge_Flipbook_Rows;117;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;586;-1925.816,-4132.393;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1159;-13684.53,1744.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Columns;T4_AnimatedGrunge_Flipbook_Columns;116;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;565;-2962.08,-5132.168;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1135;-12801.78,2436.467;Inherit;False;Property;_T4_PaintGrunge_Multiply;T4_PaintGrunge_Multiply;123;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;611;-2055.049,-3557.17;Inherit;False;610;NormalDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1155;-12320.57,1711.016;Inherit;False;Property;_T4_AnimatedGrunge_Contrast;T4_AnimatedGrunge_Contrast;118;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;596;-4209.631,-4731.591;Inherit;False;Constant;_Float1;Float 1;69;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;705;-2459.095,-3793.968;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;294;-2512.706,-3569.662;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;197;-1684.501,-5565.482;Inherit;False;MapNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;358;-3945.75,-6366.965;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;578;-2680.882,-4549.047;Inherit;False;478;DebugColor3;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;479;-3544.354,-4372.308;Inherit;True;DebugColor4;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;580;-1942.275,-4306.486;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;363;-2308.742,-5540.354;Inherit;True;Property;_TextureSample66;Texture Sample 66;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;703;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;420;-2547.47,-6697.385;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;157;-3213.352,-5654.817;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;741;-4512.905,-5586.063;Inherit;True;Property;_InBrumeDrippingNoise;InBrumeDrippingNoise;14;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;0fe9101c6b6e1124b90b120ceebd6cba;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;570;-3201.847,-4830.15;Inherit;False;477;DebugColor2;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;584;-2189.48,-4288.115;Inherit;False;479;DebugColor4;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;7;-3093.409,-4353.446;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;488;-3544.653,-5094.258;Inherit;True;DebugColor1;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1207;-15341.3,-711.4895;Inherit;False;Constant;_Float41;Float 41;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;495;-1695.501,-4330.307;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;1143;-14915.91,1567.139;Inherit;True;Property;_TA_4_Textures_Sample;TA_4_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;569;-2954.644,-4848.521;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;703;-4514.157,-5790.851;Inherit;True;Property;_ShadowNoise;ShadowNoise;7;0;Create;True;0;0;False;0;False;-1;4d5dbc1ba3dda0143a39c6a1fa10a3b9;4d5dbc1ba3dda0143a39c6a1fa10a3b9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;593;-3949.372,-4572.56;Inherit;True;Property;_TextureSample25;Texture Sample 25;5;0;Create;True;0;0;False;0;False;-1;4227c1b1ae197eb40a6429b2be4ebc96;4227c1b1ae197eb40a6429b2be4ebc96;True;0;False;white;Auto;False;Instance;559;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;386;-2510.501,-5776.482;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1171;-13349.85,2350.068;Inherit;False;Property;_T4_PaintGrunge_Contrast;T4_PaintGrunge_Contrast;122;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;644;34.68349,-4565.273;Inherit;False;AllNormal;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;583;-2189.503,-4363.903;Inherit;False;1364;Texture4_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;704;-2865.013,-3822.628;Inherit;False;622;AllAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;698;-2942.739,-3718.092;Inherit;False;428;Shadows;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;642;-1095.114,-5190.528;Inherit;True;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;-1093.661,-4996.497;Inherit;True;862;T2_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;563;-4321.25,-5000.2;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1173;-12701.98,1453.307;Inherit;True;Property;_TextureSample50;Texture Sample 50;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1143;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1123;-11153.08,1938.989;Inherit;False;1101;T4_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1355;-6848.234,-702.0574;Inherit;False;1242;T3_IB_ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;478;-3541.9,-4615.076;Inherit;True;DebugColor3;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;590;-4554.859,-4981.286;Inherit;False;Property;_DebugTextureTiling;DebugTextureTiling;6;0;Create;True;0;0;False;0;False;10;9.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1137;-14525.05,2483.425;Inherit;False;T4_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1366;-14554.52,2866.77;Inherit;False;T4_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1162;-11987.64,1951.206;Inherit;False;Property;_T4_AnimatedGrunge_Multiply;T4_AnimatedGrunge_Multiply;120;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1151;-11131.22,1641.605;Inherit;False;Property;_T4_CustomRimLight_Opacity;T4_CustomRimLight_Opacity;127;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1168;-11163.08,1762.989;Inherit;False;Property;_T4_CustomRimLight_Color;T4_CustomRimLight_Color;125;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;159;-3252.154,-5829.296;Inherit;False;Property;_ShadowNoisePanner;ShadowNoisePanner;9;0;Create;True;0;0;False;0;False;0.01,0;0.01,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1318;-9862.136,2756.447;Inherit;False;Constant;_Float44;Float 44;139;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;581;-2186.463,-4214.267;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1157;-13682.53,1893.621;Inherit;False;Property;_T4_AnimatedGrunge_Flipbook_Speed;T4_AnimatedGrunge_Flipbook_Speed;119;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1131;-10444.64,1655.533;Inherit;False;T4_CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;365;-1972.501,-5564.482;Inherit;True;SoftLight;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1165;-11185.08,2018.99;Inherit;False;Property;_T4_CutomRimLight_Texture;T4_CutomRimLight_Texture?;126;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1172;-11127.67,1450.562;Inherit;True;1102;T4_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1372;-14558.53,2674.949;Inherit;False;T4_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1364;-14628.17,3311.659;Inherit;False;Texture4_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;-2106.794,-3640.857;Inherit;False;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;477;-3541.403,-4852.273;Inherit;True;DebugColor2;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;567;-3206.268,-5039.949;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1166;-13965.83,2613.188;Inherit;False;Property;_T4_PaintGrunge_Tiling;T4_PaintGrunge_Tiling;121;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1150;-13322.38,1556.247;Inherit;False;Property;_T4_AnimatedGrunge;T4_AnimatedGrunge?;114;0;Create;True;0;0;False;1;Header(Paper);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwizzleNode;162;-3935.91,-5584.326;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1175;-13984.97,2790.114;Inherit;True;1146;TA_4_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleAddOpNode;180;-2942.513,-5744.482;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.1,0.05;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;411;-4217.748,-6638.963;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;1119;-13168.16,599.3416;Inherit;False;T3_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1211;-14014.91,449.6307;Inherit;True;1187;T3_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1181;-14013.27,643.6013;Inherit;True;1183;T3_CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;1145;-15378.94,1564.851;Inherit;True;Property;_TA_4_Textures;TA_4_Textures;145;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;35617828aa5bd8749a5fa9818f29cabe;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;1146;-15134.52,1566.142;Inherit;False;TA_4_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1217;-5120.546,-667.0994;Inherit;False;T3_End_InBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1225;-5657.167,-924.9294;Inherit;False;Property;_T3_IB_ColorCorrection;T3_IB_ColorCorrection;113;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1213;-14012.91,2181.306;Inherit;True;1140;TA_4_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-3676.511,-5798.626;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1115;-14905.78,2283.906;Inherit;True;Property;_TA_4_Grunges_Sample;TA_4_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;413;-3673.75,-6638.963;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-2726.867,-4873.242;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1204;-15342.3,-864.4894;Inherit;False;Constant;_Float39;Float 39;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1100;-14512.26,1759.75;Inherit;False;T4_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1101;-14532.18,1952.334;Inherit;False;T4_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1198;-15217.49,536.9885;Inherit;False;1119;T3_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1344;-9805.627,3331.333;Inherit;False;Property;_T4_IB_NormalDrippingNoise_Step;T4_IB_NormalDrippingNoise_Step;137;0;Create;True;0;0;False;0;False;0.45;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;609;-2487.465,-3489.921;Inherit;False;608;LightDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1012;-2971.274,-3563.695;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1337;-6845.083,2070.56;Inherit;False;1356;T4_IB_ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1111;-14531.78,2284.906;Inherit;False;T4_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1352;-6140.955,2153.279;Inherit;False;1358;T4_IB_NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1302;-5394.226,2111.762;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1367;-15207.94,3392.865;Inherit;False;1361;T4_End_InBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;1259;-6671.888,-883.9304;Inherit;False;Property;_T3_IB_ShadowColor;T3_IB_ShadowColor;98;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.5283019,0.5283019,0.5283019,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1353;-6144.105,-619.3386;Inherit;False;1354;T3_IB_NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1116;-14013.1,3419.079;Inherit;True;1131;T4_CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;974;-6672.105,-4128.544;Inherit;False;Property;_T2_IB_BackColor;T2_IB_BackColor;67;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;425;-3106.479,-6399.385;Inherit;False;Property;_StepShadow;StepShadow;10;0;Create;True;0;0;False;0;False;0.1;0.09;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1334;-6846.271,2148.417;Inherit;False;1348;T4_IB_ShadowGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;1098;-15356.4,2281.271;Inherit;True;Property;_TA_4_Grunges;TA_4_Grunges;146;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;35617828aa5bd8749a5fa9818f29cabe;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;1206;-15341.3,-787.4894;Inherit;False;Constant;_Float40;Float 40;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1361;-5117.396,2105.517;Inherit;False;T4_End_InBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1140;-15117.29,2282.417;Inherit;False;TA_4_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.ColorNode;1340;-5654.017,1847.687;Inherit;False;Property;_T4_IB_ColorCorrection;T4_IB_ColorCorrection;144;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1335;-9946.03,1931.718;Inherit;False;Property;_DrippingNoise_Tiling6;T4_IB_ShadowDrippingNoise_Tiling;134;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1252;-6673.544,-1332.442;Inherit;False;Property;_T3_IB_BackColor;T3_IB_BackColor;99;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;169;-4491.268,-6644.676;Inherit;True;644;AllNormal;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1199;-15208.11,617.3884;Inherit;False;1217;T3_End_InBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1345;-9824.759,3431.705;Inherit;False;Property;_T4_IB_NormalDrippingNoise_Smoothstep;T4_IB_NormalDrippingNoise_Smoothstep;136;0;Create;True;0;0;False;0;False;0.01;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;813;-11186.79,-3549.729;Inherit;False;Property;_T2_CutomRimLight_Texture;T2_CutomRimLight_Texture?;62;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1048;-13716.29,3562.948;Inherit;False;Property;_T4_CustomRimLight;T4_CustomRimLight?;124;0;Create;True;0;0;False;1;Header(Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1339;-6668.739,1888.687;Inherit;False;Property;_T4_IB_ShadowColor;T4_IB_ShadowColor;129;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.5283019,0.5283019,0.5283019,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;823;-14014.62,-3387.412;Inherit;True;873;TA_2_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.LerpOp;632;-809.1087,-4989.831;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;431;-851.4797,-6745.385;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;640;-240.973,-4559.926;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1346;-9595.142,3653.461;Inherit;False;Property;_T4_IB_NormalDrippingNoise_Tiling;T4_IB_NormalDrippingNoise_Tiling;138;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1338;-6670.394,1440.175;Inherit;False;Property;_T4_IB_BackColor;T4_IB_BackColor;130;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;1118;-15217.32,3312.465;Inherit;False;1120;T4_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1300;-9873.673,2580.06;Inherit;False;Property;_T4_IB_ShadowGrunge_Tiling;T4_IB_ShadowGrunge_Tiling;140;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;952;-9874.385,-2987.659;Inherit;False;Property;_T2_IB_ShadowGrunge_Tiling;T2_IB_ShadowGrunge_Tiling;77;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1336;-7903.679,1469.796;Inherit;False;Property;_T4_IB_ShadowDrippingNoise_Transition;T4_IB_ShadowDrippingNoise_Transition;131;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1348;-8202.681,2389.738;Inherit;False;T4_IB_ShadowGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1333;-9837.348,1749.443;Inherit;False;Property;_T4_IB_ShadowDrippingNoise_Step;T4_IB_ShadowDrippingNoise_Step;133;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1332;-9843.506,1662.871;Inherit;False;Property;_T4_IB_ShadowDrippingNoise_Smoothstep;T4_IB_ShadowDrippingNoise_Smoothstep;132;0;Create;True;0;0;False;0;False;0.2;0.2797383;0.001;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;579;-2680.906,-4624.835;Inherit;False;1214;Texture3_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;694;-307.5099,-4362.324;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;1134;-13076.56,2933.136;Inherit;False;Property;_T4_ColorCorrection;T4_ColorCorrection;128;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;139;-14514.14,-6584.446;Inherit;False;T1_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1306;-8990.847,2775.031;Inherit;False;Property;_T4_IB_NormalGrunge_Contrast;T4_IB_NormalGrunge_Contrast;143;0;Create;True;0;0;False;0;False;2.4;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1120;-13167.99,3374.818;Inherit;False;T4_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;1324;-8416.911,3108.517;Inherit;False;1357;T4_IB_NormalGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1127;-10817.22,1489.606;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;915;-13967.54,-2955.531;Inherit;False;Property;_T2_PaintGrunge_Tiling;T2_PaintGrunge_Tiling;51;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;602;-11186.96,-6325.206;Inherit;False;Property;_T1_CutomRimLight_Texture;T1_CutomRimLight_Texture?;29;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;693;-583.5101,-4585.324;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1343;-9996.839,3039.343;Inherit;False;1100;T4_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;1271;-9601.844,3740.917;Inherit;False;Property;_T4_IB_NormalDrippingNoise_Offset;T4_IB_NormalDrippingNoise_Offset;139;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1301;-9846.233,2862.664;Inherit;False;Property;_T4_IB_NormalGrunge_Tiling;T4_IB_NormalGrunge_Tiling;142;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1325;-8971.574,2494.193;Inherit;False;Property;_T4_IB_ShadowGrunge_Contrast;T4_IB_ShadowGrunge_Contrast;141;0;Create;True;0;0;False;0;False;-3.38;-3.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;1124;-13377.45,14.80359;Inherit;True;Procedural Sample;-1;;53;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1075;-12875,1612.47;Inherit;False;Constant;_Float28;Float 28;87;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-15373.39,-6573.204;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;211;-9017.406,-6505.071;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;133;-14522.14,-6773.444;Inherit;False;T1_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;812;-11164.79,-3805.73;Inherit;False;Property;_T2_CustomRimLight_Color;T2_CustomRimLight_Color;63;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1129;-13306.52,1723.141;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;1299;-9872.742,2477.377;Inherit;False;Constant;_Float43;Float 43;131;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;297;-12803.66,-5907.729;Inherit;False;Property;_T1_PaintGrunge_Multiply;T1_PaintGrunge_Multiply;20;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1121;-14014.74,3225.107;Inherit;True;1122;T4_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;733;-15306.16,-5426.742;Inherit;False;Constant;_Float21;Float 21;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;884;-12703.69,-4115.412;Inherit;True;Property;_TextureSample48;Texture Sample 48;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;865;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1122;-10584.35,2775.733;Inherit;False;T4_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;957;-9603.556,-1827.802;Inherit;False;Property;_T2_IB_NormalDrippingNoise_Offset;T2_IB_NormalDrippingNoise_Offset;76;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;946;-9390.21,-3646.264;Inherit;True;Property;_TextureSample27;Texture Sample 27;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;741;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;709;-13986.85,-5554.082;Inherit;True;708;TA_1_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;714;-15308.27,-5502.657;Inherit;False;Constant;_Float20;Float 20;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;150;-13324.26,-6787.949;Inherit;False;Property;_T1_AnimatedGrunge;T1_AnimatedGrunge?;22;0;Create;True;0;0;False;1;Header(Paper);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1356;-7401.634,1644.545;Inherit;False;T4_IB_ShadowDrippingNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;890;-13545.24,-3577.098;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;-13967.71,-5731.008;Inherit;False;Property;_T1_PaintGrunge_Tiling;T1_PaintGrunge_Tiling;18;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1001;-6418.862,-4096.612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;1357;-8183.177,2675.343;Inherit;False;T4_IB_NormalGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;717;-12322.45,-6633.18;Inherit;False;Property;_T1_AnimatedGrunge_Contrast;T1_AnimatedGrunge_Contrast;26;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;377;-13351.73,-5994.128;Inherit;False;Property;_T1_PaintGrunge_Contrast;T1_PaintGrunge_Contrast;19;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;910;-11989.35,-3617.513;Inherit;False;Property;_T2_AnimatedGrunge_Multiply;T2_AnimatedGrunge_Multiply;60;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;841;-13324.09,-4012.472;Inherit;False;Property;_T2_AnimatedGrunge;T2_AnimatedGrunge?;55;0;Create;True;0;0;False;1;Header(Paper);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;175;-13808.36,-6782.327;Inherit;False;Property;_T1_NonAnimatedGrunge_Tiling;T1_NonAnimatedGrunge_Tiling;21;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;385;-11133.1,-6702.591;Inherit;False;Property;_T1_CustomRimLight_Opacity;T1_CustomRimLight_Opacity;31;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;865;-14917.62,-4001.58;Inherit;True;Property;_TA_2_Textures_Sample;TA_2_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;1354;-7511.157,334.1825;Inherit;False;T3_IB_NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;410;-10446.52,-6688.663;Inherit;False;T1_CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;819;-12322.28,-3857.703;Inherit;False;Property;_T2_AnimatedGrunge_Contrast;T2_AnimatedGrunge_Contrast;59;0;Create;True;0;0;False;0;False;1.58;0.46;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;189;-9603.028,-6901.62;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1195;-15210.02,696.0374;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;240;-8568.752,-6281.301;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;818;-13351.56,-3218.651;Inherit;False;Property;_T2_PaintGrunge_Contrast;T2_PaintGrunge_Contrast;52;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-13686.41,-6599.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Columns;T1_AnimatedGrunge_Flipbook_Columns;23;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;251;-7898.287,-6521.16;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;873;-15119,-3286.302;Inherit;False;TA_2_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-13505.36,-6856.327;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;262;-11129.55,-6893.634;Inherit;True;265;T1_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;748;-14630.05,-5032.536;Inherit;False;Texture1_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;713;-14526.93,-5861.771;Inherit;False;T1_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;213;-9644.721,-6389.16;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;928;-10811.22,-3728.78;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;875;-15350.19,-3056.352;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-5399.088,-6229.573;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;195;-9393.36,-6418.881;Inherit;True;Property;_TextureSample59;Texture Sample 59;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;741;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;810;-11132.93,-3927.114;Inherit;False;Property;_T2_CustomRimLight_Opacity;T2_CustomRimLight_Opacity;64;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;196;-9297.633,-6671.504;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;206;-9718.837,-5302.008;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;304;-7604.339,-6645.179;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;248;-5658.879,-6493.648;Inherit;False;Property;_T1_IB_ColorCorrection;T1_IB_ColorCorrection;32;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;396;-7045.855,-6698.348;Inherit;False;351;T1_IB_ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;854;-13685.24,-3750.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Rows;T2_AnimatedGrunge_Flipbook_Rows;57;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;882;-13684.24,-3675.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Speed;T2_AnimatedGrunge_Flipbook_Speed;58;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;-9851.095,-5478.672;Inherit;False;Property;_T1_IB_NormalGrunge_Tiling;T1_IB_NormalGrunge_Tiling;46;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;289;-5122.258,-6235.818;Inherit;False;T1_End_InBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;738;-15119.17,-6061.779;Inherit;False;TA_1_Grunges;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;178;-9829.62,-4909.631;Inherit;False;Property;_T1_IB_NormalDrippingNoise_Smoothstep;T1_IB_NormalDrippingNoise_Smoothstep;40;0;Create;True;0;0;False;0;False;0.01;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;191;-12219.7,-5543.248;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;222;-9283.384,-6896.519;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;202;-10586.23,-5568.462;Inherit;False;T1_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;301;-14016.62,-5119.088;Inherit;True;202;T1_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;246;-13416.9,-5115.176;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;600;-11154.96,-6405.207;Inherit;False;599;T1_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-13685.41,-6525.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Rows;T1_AnimatedGrunge_Flipbook_Rows;24;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;822;-13686.24,-3824.098;Inherit;False;Property;_T2_AnimatedGrunge_Flipbook_Columns;T2_AnimatedGrunge_Flipbook_Columns;56;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;-8115.528,-6526.859;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;193;-9470.548,-6648.057;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;889;-13751.58,-2693.681;Inherit;False;Constant;_Float26;Float 26;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;710;-14014.79,-6162.889;Inherit;True;738;TA_1_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;332;-10601.4,-6683.229;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;274;-15219.2,-5031.73;Inherit;False;187;T1_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;409;-13718.17,-4781.247;Inherit;False;Property;_T1_CustomRimLight;T1_CustomRimLight?;28;0;Create;True;0;0;False;1;Header(Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;744;-9983.997,-5668.889;Inherit;False;738;TA_1_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;599;-14534.06,-6391.863;Inherit;False;T1_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;1347;-9951.523,2019.794;Inherit;False;Property;_T4_IB_ShadowDrippingNoise_Offset;T4_IB_ShadowDrippingNoise_Offset;135;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;154;-9810.488,-5010.003;Inherit;False;Property;_T1_IB_NormalDrippingNoise_Step;T1_IB_NormalDrippingNoise_Step;41;0;Create;True;0;0;False;0;False;0.45;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1052;-15348.48,2512.366;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;71;-15344.01,-6433.208;Inherit;False;Constant;_Float53;Float 53;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;318;-11989.52,-6392.99;Inherit;False;Property;_T1_AnimatedGrunge_Multiply;T1_AnimatedGrunge_Multiply;27;0;Create;True;0;0;False;0;False;1.58;1.61;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;826;-10446.35,-3913.186;Inherit;False;T2_CustomRimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;883;-13036.58,-3380.432;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;210;-9606.706,-4600.418;Inherit;False;Property;_T1_IB_NormalDrippingNoise_Offset;T1_IB_NormalDrippingNoise_Offset;43;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;853;-14526.76,-3086.294;Inherit;False;T2_PaintGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;891;-12984.92,-4086.297;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;877;-15305.99,-2651.265;Inherit;False;Constant;_Float22;Float 22;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;145;-13994.99,-5883.114;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;172;-15343.01,-6356.208;Inherit;False;Constant;_Float63;Float 63;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;701;-14533.66,-6059.29;Inherit;False;T1_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;885;-12876.71,-3956.249;Inherit;False;Constant;_Float55;Float 55;87;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;397;-11164.96,-6581.207;Inherit;False;Property;_T1_CustomRimLight_Color;T1_CustomRimLight_Color;30;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;241;-15343.01,-6280.208;Inherit;False;Constant;_Float69;Float 69;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1053;-13415.02,3229.02;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;857;-15343.84,-3657.731;Inherit;False;Constant;_Float50;Float 50;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;908;-12044.28,-3929.703;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;179;-13308.4,-6621.055;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;158;-12985.09,-6861.774;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;208;-13545.41,-6352.575;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;887;-13751.11,-2607.677;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;886;-12219.53,-2767.771;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1125;-13377.28,2790.281;Inherit;True;Procedural Sample;-1;;54;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.GetLocalVarNode;349;-15209.82,-4951.33;Inherit;False;289;T1_End_InBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;295;-6849.946,-6270.776;Inherit;False;351;T1_IB_ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;963;-9847.945,-2706.055;Inherit;False;Property;_T2_IB_NormalGrunge_Tiling;T2_IB_NormalGrunge_Tiling;79;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;607;-15211.73,-4872.681;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;809;-13416.73,-2339.698;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;903;-12788.27,-2769.581;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-13684.41,-6450.575;Inherit;False;Property;_T1_AnimatedGrunge_Flipbook_Speed;T1_AnimatedGrunge_Flipbook_Speed;25;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;820;-13808.19,-4006.85;Inherit;False;Property;_T2_NonAnimatedGrunge_Tiling;T2_NonAnimatedGrunge_Tiling;54;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;911;-11269.74,-3274.923;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;811;-10601.23,-3907.752;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;821;-13505.19,-4080.85;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwizzleNode;918;-13792.19,-4086.85;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;340;-14944.62,-5027.286;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;737;-15358.28,-6062.924;Inherit;True;Property;_TA_1_Grunges;TA_1_Grunges;16;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;35617828aa5bd8749a5fa9818f29cabe;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;862;-14513.97,-3808.969;Inherit;False;T2_Normal_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;735;-14556.4,-5477.425;Inherit;False;T1_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;909;-11684.35,-3755.513;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;864;-15342.84,-3504.731;Inherit;False;Constant;_Float51;Float 51;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;914;-12228.43,-3248.752;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TextureCoordinatesNode;876;-15373.22,-3797.727;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;879;-15309.1,-2801.735;Inherit;False;Constant;_Float24;Float 24;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;872;-15211.56,-2097.204;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;871;-14944.45,-2251.809;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;878;-15308.1,-2727.18;Inherit;False;Constant;_Float23;Float 23;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;917;-14016.19,-4086.85;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SwizzleNode;167;-13792.36,-6862.327;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;815;-11129.38,-4118.157;Inherit;True;860;T2_RimLightMask_Texture;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;880;-15308.06,-2879.305;Inherit;False;Constant;_Float52;Float 52;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;868;-14629.88,-2257.059;Inherit;False;Texture2_Final;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;888;-13562.02,-2542.071;Inherit;False;Constant;_Float25;Float 25;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;806;-14016.45,-2343.611;Inherit;True;816;T2_RGB;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;919;-13308.23,-3845.578;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.BlendOpsNode;808;-13709.62,-2241.294;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;912;-10903.62,-2793.841;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;913;-12452.48,-3248.943;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;708;-15136.4,-6778.054;Inherit;False;TA_1_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;855;-15342.84,-3580.731;Inherit;False;Constant;_Float49;Float 49;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;856;-14533.49,-3283.813;Inherit;False;T2_AnimatedGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;732;-14560.41,-5669.246;Inherit;False;T1_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;381;-12703.86,-6890.889;Inherit;True;Property;_TextureSample67;Texture Sample 67;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;739;-15350.36,-5831.829;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;615;-12495.07,-5360.529;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;916;-13697,-3387.659;Inherit;True;Procedural Sample;-1;;43;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RegisterLocalVarNode;839;-13169.7,-2193.9;Inherit;False;T2_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;617;-13379.16,-5553.915;Inherit;True;Procedural Sample;-1;;46;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.WorldPosInputsNode;922;-13994.82,-3107.636;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;399;-13078.44,-5411.059;Inherit;False;Property;_T1_ColorCorrection;T1_ColorCorrection;17;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;814;-11154.79,-3629.73;Inherit;False;861;T2_RimLight_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;906;-13378.99,-2778.438;Inherit;True;Procedural Sample;-1;;44;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,1;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;711;-13968.78,-5965.854;Inherit;False;Constant;_Float19;Float 19;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;844;-14014.81,-2149.64;Inherit;True;826;T2_CustomRimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-13169.87,-4969.377;Inherit;False;T1_End_OutBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;861;-14533.89,-3616.385;Inherit;False;T2_RimLight_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;923;-13078.27,-2635.582;Inherit;False;Property;_T2_ColorCorrection;T2_ColorCorrection;50;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;190;-10903.79,-5569.318;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-11269.91,-6050.4;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;921;-13968.61,-3190.377;Inherit;False;Constant;_Float27;Float 27;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;601;-10811.39,-6504.257;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;252;-12493.61,-5445.562;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;867;-14907.49,-3284.813;Inherit;True;Property;_TA_2_Grunges_Sample;TA_2_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;268;-15308.23,-5654.782;Inherit;False;Constant;_Float71;Float 71;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;335;-12788.44,-5545.058;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;702;-15309.27,-5577.212;Inherit;False;Constant;_Float18;Float 18;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;869;-15219.03,-2256.253;Inherit;False;839;T2_End_OutBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;135;-12228.6,-6024.229;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RegisterLocalVarNode;860;-14535.03,-3519.448;Inherit;False;T2_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;336;-13697.17,-6163.136;Inherit;True;Procedural Sample;-1;;45;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.ScreenPosInputsNode;163;-14016.36,-6862.327;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;620;-13751.28,-5383.155;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCGrayscale;907;-12304.63,-4116.526;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;926;-10818.93,-4079.113;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;863;-14521.97,-3997.967;Inherit;False;T2_Albedo_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;395;-10819.1,-6854.59;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;-12452.65,-6024.42;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;905;-12493.44,-2670.085;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1002;-6386.622,-3675.266;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;236;-9600.004,-4687.873;Inherit;False;Property;_T1_IB_NormalDrippingNoise_Tiling;T1_IB_NormalDrippingNoise_Tiling;42;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;232;-9848.367,-6678.466;Inherit;False;Property;_T1_IB_ShadowDrippingNoise_Smoothstep;T1_IB_ShadowDrippingNoise_Smoothstep;35;0;Create;True;0;0;False;0;False;0.2;0.2797383;0.001;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;393;-6851.134,-6192.918;Inherit;False;374;T1_IB_ShadowGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;849;-14556.23,-2701.948;Inherit;False;T2_IB_NormalGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;870;-15209.65,-2175.853;Inherit;False;950;T2_End_InBrume;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;716;-12044.45,-6705.18;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;224;-11684.52,-6530.99;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-14535.2,-6294.926;Inherit;False;T1_RimLightMask_Texture;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;261;-9301.121,-5948.522;Inherit;False;Procedural Sample;-1;;47;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;329;-8976.437,-5847.142;Inherit;False;Property;_T1_IB_ShadowGrunge_Contrast;T1_IB_ShadowGrunge_Contrast;45;0;Create;True;0;0;False;0;False;-3.38;-3.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;850;-14560.24,-2893.769;Inherit;False;T2_IB_ShadowGrunge_Texture;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;285;-13036.75,-6155.909;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1046;-13503.48,1487.869;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;1049;-15209.85,3471.514;Inherit;False;606;Out_or_InBrume;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1050;-14942.74,3316.909;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;1051;-12491.73,2898.634;Inherit;False;1;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-12876.88,-6731.726;Inherit;False;Constant;_Float62;Float 62;87;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1003;-6588.541,-3493.227;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1094;-12786.73,23.66052;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;920;-12494.9,-2585.052;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1045;-10599.52,1660.967;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;817;-12803.49,-3132.252;Inherit;False;Property;_T2_PaintGrunge_Multiply;T2_PaintGrunge_Multiply;53;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;971;-9953.235,-3548.925;Inherit;False;Property;_T2_IB_ShadowDrippingNoise_Offset;T2_IB_ShadowDrippingNoise_Offset;71;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TFHCGrayscale;403;-12304.8,-6892.003;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;255;-9552.946,-5861.662;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;311;-8995.709,-5566.304;Inherit;False;Property;_T1_IB_NormalGrunge_Contrast;T1_IB_NormalGrunge_Contrast;47;0;Create;True;0;0;False;0;False;2.4;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;994;-9980.848,-2896.272;Inherit;False;873;TA_2_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.GetLocalVarNode;989;-9998.551,-2529.376;Inherit;False;862;T2_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;969;-7403.345,-3924.174;Inherit;False;T2_IB_ShadowDrippingNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1056;-12226.72,2319.967;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;960;-9807.339,-2237.385;Inherit;False;Property;_T2_IB_NormalDrippingNoise_Step;T2_IB_NormalDrippingNoise_Step;74;0;Create;True;0;0;False;0;False;0.45;0.45;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1108;-11268.2,-481.6813;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1047;-15341.13,1987.988;Inherit;False;Constant;_Float11;Float 11;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;372;-8421.772,-5232.818;Inherit;False;324;T1_IB_NormalGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;706;-15380.82,-6779.345;Inherit;True;Property;_TA_1_Textures;TA_1_Textures;15;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;35617828aa5bd8749a5fa9818f29cabe;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;950;-5119.107,-3463.202;Inherit;False;T2_End_InBrume;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;961;-6142.666,-3415.44;Inherit;False;985;T2_IB_NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;-6145.816,-6188.057;Inherit;False;296;T1_IB_NormalDrippingGrunge;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;296;-7512.868,-5234.536;Inherit;False;T1_IB_NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;959;-9826.471,-2137.014;Inherit;False;Property;_T2_IB_NormalDrippingNoise_Smoothstep;T2_IB_NormalDrippingNoise_Smoothstep;73;0;Create;True;0;0;False;0;False;0.01;0.01;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;958;-9596.854,-1915.257;Inherit;False;Property;_T2_IB_NormalDrippingNoise_Tiling;T2_IB_NormalDrippingNoise_Tiling;75;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;-6422.012,-6869.229;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1058;-15307.39,2766.983;Inherit;False;Constant;_Float13;Float 13;104;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;816;-10586.06,-2792.985;Inherit;False;T2_RGB;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;74;-14917.79,-6777.057;Inherit;True;Property;_TA_1_Textures_Sample;TA_1_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;621;-13562.19,-5317.548;Inherit;False;Constant;_Float5;Float 5;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1055;-13707.91,3327.424;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1072;-13560.31,3026.647;Inherit;False;Constant;_Float17;Float 17;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1088;-13035.04,-587.1907;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1091;-15306.52,-86.06361;Inherit;False;Constant;_Float32;Float 32;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1092;-13560.48,251.1707;Inherit;False;Constant;_Float8;Float 8;60;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;985;-7509.718,-2461.919;Inherit;False;T2_IB_NormalDrippingGrunge;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;965;-8184.888,-2893.376;Inherit;False;T2_IB_NormalGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1093;-10809.68,-935.5383;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;947;-7042.705,-3925.731;Inherit;False;969;T2_IB_ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;966;-8204.393,-3178.981;Inherit;False;T2_IB_ShadowGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;1104;-14014.65,-1293.608;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;1061;-14014.48,1481.869;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;935;-8771.603,-3508.684;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;1081;-12983.38,-1293.055;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1106;-12450.94,-455.7013;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1107;-10902.08,-0.599247;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1095;-10817.39,-1285.871;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;374;-8207.542,-5951.598;Inherit;False;T1_IB_ShadowGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1097;-12302.92,1452.193;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1099;-13967.07,-397.1354;Inherit;False;Constant;_Float33;Float 33;62;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1054;-15341.13,2063.988;Inherit;False;Constant;_Float12;Float 12;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1086;-12875.17,-1163.007;Inherit;False;Constant;_Float31;Float 31;87;0;Create;True;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;1103;-12493.19,2983.667;Inherit;False;614;GrayscaleDebug;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;825;-13986.68,-2778.605;Inherit;True;881;TA_2_Textures;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.FunctionNode;1105;-13695.46,-594.4177;Inherit;True;Procedural Sample;-1;;52;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.RangedFloatNode;1077;-15306.35,2689.414;Inherit;False;Constant;_Float29;Float 29;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;585;-2307.816,-4442.393;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1084;-13750.04,99.56036;Inherit;False;Constant;_Float7;Float 7;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1078;-12042.57,1639.016;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1114;-12226.89,-455.5104;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1065;-11268.03,2293.795;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;1110;-12042.74,-1136.461;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SwizzleNode;1060;-13790.48,1481.869;Inherit;False;FLOAT2;0;1;2;3;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;1069;-12983.21,1482.422;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;1083;-13749.87,2875.038;Inherit;False;Constant;_Float30;Float 30;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1085;-12217.99,25.47058;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;1062;-13695.29,2181.06;Inherit;True;Procedural Sample;-1;;51;f5379ff72769e2b4495e5ce2f004d8d4;2,157,3,315,3;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.WorldPosInputsNode;1096;-13749.57,185.5638;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleContrastOpNode;1076;-13034.87,2188.287;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1066;-11682.64,1813.206;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;1068;-15342.13,1910.988;Inherit;False;Constant;_Float15;Float 15;104;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;1112;-12303.09,-1323.284;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1070;-15304.28,2917.454;Inherit;False;Constant;_Float16;Float 16;104;0;Create;True;0;0;False;0;False;3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1071;-13993.28,-314.3952;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ColorNode;962;-5655.729,-3721.032;Inherit;False;Property;_T2_IB_ColorCorrection;T2_IB_ColorCorrection;65;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;619;-13751.75,-5469.158;Inherit;False;Constant;_Float4;Float 4;60;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;1074;-12217.82,2800.948;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;851;-14903.07,-2701.03;Inherit;True;Property;_TextureSample40;Texture Sample 40;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;382;-9082.702,-5230.94;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1063;-12450.77,2319.775;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;360;-8623.813,-4787.971;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCFlipBookUVAnimation;1080;-13306.69,-1052.336;Inherit;False;0;0;6;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;2;False;3;FLOAT;1;False;4;FLOAT;0;False;5;FLOAT;1;False;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1079;-12786.56,2799.137;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;383;-8083.223,-4931.988;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleTimeNode;1082;-13543.7,-783.8566;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1073;-13749.4,2961.042;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;968;-6846.795,-3498.159;Inherit;False;969;T2_IB_ShadowDrippingNoise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;948;-9599.878,-4129.003;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;339;-9098.459,-4979.113;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;970;-7905.39,-4098.923;Inherit;False;Property;_T2_IB_ShadowDrippingNoise_Transition;T2_IB_ShadowDrippingNoise_Transition;72;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;134;-10001.7,-5301.992;Inherit;False;139;T1_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;164;-6777.221,-6692.335;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;417;-6186.438,-6477.326;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;691;-792.7947,-4761.504;Inherit;True;1176;T3_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;319;-6389.772,-6447.883;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.3,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;324;-8188.038,-5665.992;Inherit;False;T1_IB_NormalGrunge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1059;-15306.39,2841.539;Inherit;False;Constant;_Float14;Float 14;104;0;Create;True;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;317;-8858.002,-4978.669;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;881;-15136.23,-4002.577;Inherit;False;TA_2_Textures;-1;True;1;0;SAMPLER2DARRAY;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.SamplerNode;344;-9008.087,-4675.204;Inherit;True;Property;_TextureSample64;Texture Sample 64;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;741;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;-5880.473,-6206.65;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;320;-8674.211,-5944.38;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;1117;-13993.11,2461.083;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;983;-9979.579,-3179.485;Inherit;False;873;TA_2_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.RangedFloatNode;151;-9878.534,-5761.276;Inherit;False;Property;_T1_IB_ShadowGrunge_Tiling;T1_IB_ShadowGrunge_Tiling;44;0;Create;True;0;0;False;0;False;0.2;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;350;-7809.775,-5234.362;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;351;-7406.495,-6696.792;Inherit;False;T1_IB_ShadowDrippingNoise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;306;-8668.487,-5660.543;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1006;-8372.04,-2159.907;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;355;-7908.54,-6871.539;Inherit;False;Property;_T1_IB_ShadowDrippingNoise_Transition;T1_IB_ShadowDrippingNoise_Transition;39;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;742;-9982.729,-5952.102;Inherit;False;738;TA_1_Grunges;1;0;OBJECT;;False;1;SAMPLER2DARRAY;0
Node;AmplifyShaderEditor.Vector2Node;231;-9956.385,-6321.541;Inherit;False;Property;_T1_IB_ShadowDrippingNoise_Offset;T1_IB_ShadowDrippingNoise_Offset;38;0;Create;True;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;249;-9303.095,-5662.672;Inherit;False;Procedural Sample;-1;;48;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TextureCoordinatesNode;1057;-15371.51,1770.992;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;244;-9559.946,-5586.662;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;277;-8123.646,-5227.119;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;305;-8375.189,-4932.524;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;325;-8423.827,-5950.262;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;401;-6673.6,-6452.649;Inherit;False;Property;_T1_IB_ShadowColor;T1_IB_ShadowColor;33;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.5283019,0.5283019,0.5283019,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;942;-7895.137,-3748.544;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;216;-9497.31,-4913.434;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;389;-6675.256,-6901.161;Inherit;False;Property;_T1_IB_BackColor;T1_IB_BackColor;34;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;964;-6670.45,-3680.032;Inherit;False;Property;_T2_IB_ShadowColor;T2_IB_ShadowColor;66;0;Create;True;0;0;False;0;False;0.5283019,0.5283019,0.5283019,0;0.5283019,0.5283019,0.5283019,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;247;-8291.289,-6785.013;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;290;-6591.691,-6265.844;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;375;-9842.209,-6591.892;Inherit;False;Property;_T1_IB_ShadowDrippingNoise_Step;T1_IB_ShadowDrippingNoise_Step;36;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;1109;-11682.81,-962.2717;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;1064;-10901.91,2774.877;Inherit;True;Multiply;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;423;-1278.309,-5725.769;Inherit;False;Property;_LightDebug;LightDebug;1;0;Create;True;0;0;False;1;Header(Debug);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;275;-5642.153,-6206.202;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;995;-9549.796,-3089.046;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;137;-8774.753,-6281.301;Inherit;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;364;-9950.892,-6409.617;Inherit;False;Property;_DrippingNoise_Tiling3;T1_IB_ShadowDrippingNoise_Tiling;37;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1000;-6183.288,-3704.71;Inherit;True;Lighten;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;944;-7601.189,-3872.563;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;988;-8620.664,-2015.354;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;982;-9299.944,-2890.055;Inherit;False;Procedural Sample;-1;;50;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TFHCGrayscale;993;-9715.687,-2529.391;Inherit;True;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;992;-8120.496,-2454.503;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;987;-9095.309,-2206.496;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.45;False;2;FLOAT;0.46;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;1007;-9079.552,-2458.323;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.47;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;943;-9294.482,-3898.887;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.01;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;945;-9280.233,-4123.903;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;256;-6586.231,-6692.142;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;967;-6847.983,-3420.302;Inherit;False;966;T2_IB_ShadowGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;956;-8973.286,-3074.526;Inherit;False;Property;_T2_IB_ShadowGrunge_Contrast;T2_IB_ShadowGrunge_Contrast;78;0;Create;True;0;0;False;0;False;-3.38;-3.38;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;303;-9278.123,-4645.452;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;990;-8080.073,-2159.371;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;953;-9845.218,-3905.848;Inherit;False;Property;_T2_IB_ShadowDrippingNoise_Smoothstep;T2_IB_ShadowDrippingNoise_Smoothstep;68;0;Create;True;0;0;False;0;False;0.2;0.2797383;0.001;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;954;-8418.623,-2460.201;Inherit;False;965;T2_IB_NormalGrunge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;980;-8420.678,-3177.645;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;577;-2677.866,-4475.199;Inherit;False;566;DebugVertexPaint;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;941;-9467.397,-3875.44;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;1008;-9494.159,-2140.817;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;979;-8422.909,-2893.225;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;940;-8112.377,-3754.243;Inherit;False;140;normal_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;986;-8854.852,-2206.051;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;997;-6774.071,-3919.717;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;998;-9004.937,-1902.587;Inherit;True;Property;_TextureSample28;Texture Sample 28;14;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;741;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;975;-5395.938,-3456.956;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;977;-5639.002,-3433.585;Inherit;False;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,1;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;936;-9014.256,-3732.454;Inherit;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;610;-966.8767,-5622.498;Inherit;False;NormalDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;937;-8565.603,-3508.684;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;999;-5877.323,-3434.034;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;973;-9839.06,-3819.276;Inherit;False;Property;_T2_IB_ShadowDrippingNoise_Step;T2_IB_ShadowDrippingNoise_Step;69;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;972;-9947.742,-3637.001;Inherit;False;Property;_DrippingNoise_Tiling4;T2_IB_ShadowDrippingNoise_Tiling;70;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1009;-9274.973,-1872.835;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;874;-15358.11,-3287.447;Inherit;True;Property;_TA_2_Grunges;TA_2_Grunges;49;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;35617828aa5bd8749a5fa9818f29cabe;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1362;-14916.08,-1208.338;Inherit;True;Property;_TA_3_Textures_Sample;TA_3_Textures_Sample;8;0;Create;True;0;0;False;0;False;-1;ef1e633c4c2c51641bd59a932b55b28a;b6b5d9dc92e335d44a8ce9459051a78d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;1363;-15379.11,-1210.626;Inherit;True;Property;_TA_3_Textures;TA_3_Textures;81;0;Create;True;0;0;False;0;False;ef1e633c4c2c51641bd59a932b55b28a;35617828aa5bd8749a5fa9818f29cabe;False;white;Auto;Texture2DArray;-1;0;2;SAMPLER2DARRAY;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TextureCoordinatesNode;939;-9641.57,-3616.544;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleContrastOpNode;976;-8665.338,-2887.927;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;938;-8288.139,-4012.397;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCGrayscale;322;-8426.059,-5665.843;Inherit;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;1005;-7806.625,-2461.745;Inherit;True;Lighten;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;981;-9297.971,-3175.905;Inherit;False;Procedural Sample;-1;;49;f5379ff72769e2b4495e5ce2f004d8d4;2,157,1,315,1;7;82;SAMPLER2D;0;False;158;SAMPLER2DARRAY;0;False;183;FLOAT;0;False;5;FLOAT2;0,0;False;80;FLOAT3;0,0,0;False;104;FLOAT2;1,0;False;74;SAMPLERSTATE;0;False;5;COLOR;0;FLOAT;32;FLOAT;33;FLOAT;34;FLOAT;35
Node;AmplifyShaderEditor.TextureCoordinatesNode;984;-9556.796,-2814.046;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;281;-1271.828,-5622.753;Inherit;False;Property;_NormalDebug;NormalDebug;2;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;564;-1279.365,-5420.153;Inherit;False;Property;_DebugVertexPaint;DebugVertexPaint;4;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;566;-971.4554,-5421.064;Inherit;False;DebugVertexPaint;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;489;-3209.282,-5113.797;Inherit;False;488;DebugColor1;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;573;-3208.871,-5188.938;Inherit;False;748;Texture1_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;574;-3201.871,-4905.938;Inherit;False;868;Texture2_Final;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;734;-14903.24,-5476.507;Inherit;True;Property;_TextureSample38;Texture Sample 38;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;955;-8992.559,-2793.688;Inherit;False;Property;_T2_IB_NormalGrunge_Contrast;T2_IB_NormalGrunge_Contrast;80;0;Create;True;0;0;False;0;False;2.4;2.4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;1004;-6583.081,-3919.526;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;613;-1270.865,-5517.98;Inherit;False;Property;_GrayscaleDebug;GrayscaleDebug;3;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;605;-1275.699,-5824.597;Inherit;False;Property;_Out_or_InBrume;Out_or_InBrume?;0;0;Create;True;0;0;False;1;Header(OutInBrume);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;606;-975.6267,-5823.472;Inherit;False;Out_or_InBrume;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;743;-9877.604,-5863.957;Inherit;False;Constant;_ShadowGrungeIndex;ShadowGrungeIndex;133;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;745;-9866.997,-5584.889;Inherit;False;Constant;_NormalGrungeIndex;NormalGrungeIndex;138;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;177;-14919.35,-6583.95;Inherit;True;Property;_TextureSample57;Texture Sample 57;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;171;-14918.74,-6391.199;Inherit;True;Property;_TextureSample56;Texture Sample 56;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;74;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;700;-14907.66,-6060.29;Inherit;True;Property;_TA_1_Grunges_Sample;TA_1_Grunges_Sample;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;614;-963.4258,-5518.905;Inherit;False;GrayscaleDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;692;-513.6171,-4548.053;Inherit;True;1100;T4_Normal_Texture;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;608;-967.5857,-5724.967;Inherit;False;LightDebug;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleContrastOpNode;978;-8671.062,-3171.762;Inherit;True;2;1;COLOR;0,0,0,0;False;0;FLOAT;1.43;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;731;-14904.77,-5669.23;Inherit;True;Property;_TextureSample37;Texture Sample 37;4;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1180;-14903.9,-291.5104;Inherit;True;Property;_TextureSample51;Texture Sample 51;149;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;852;-14904.6,-2893.753;Inherit;True;Property;_TextureSample41;Texture Sample 41;6;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1203;-14917.64,-1015.232;Inherit;True;Property;_TextureSample33;Texture Sample 33;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1362;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1184;-14917.03,-822.4807;Inherit;True;Property;_TextureSample34;Texture Sample 34;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1362;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1139;-14903.73,2482.967;Inherit;True;Property;_TextureSample43;Texture Sample 43;148;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1138;-14902.89,2674.966;Inherit;True;Property;_TextureSample42;Texture Sample 42;150;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1148;-14901.36,2867.688;Inherit;True;Property;_TextureSample49;Texture Sample 49;158;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1115;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1142;-14916.86,1952.997;Inherit;True;Property;_TextureSample46;Texture Sample 46;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1143;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;712;-14905.61,-5861.229;Inherit;True;Property;_TextureSample36;Texture Sample 36;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;700;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;859;-14918.57,-3615.722;Inherit;True;Property;_TextureSample45;Texture Sample 45;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;865;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;846;-14905.44,-3085.752;Inherit;True;Property;_TextureSample39;Texture Sample 39;5;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;867;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1144;-14917.47,1760.246;Inherit;True;Property;_TextureSample47;Texture Sample 47;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1143;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;128;-3926.91,-5717.327;Inherit;False;Property;_Noise_Tiling;Noise_Tiling;13;0;Create;True;0;0;False;1;Header(Shadow and NoiseEdge);False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1200;-13716.46,787.4714;Inherit;False;Property;_T3_CustomRimLight;T3_CustomRimLight?;93;0;Create;True;0;0;False;1;Header(Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;807;-13718,-2005.77;Inherit;False;Property;_T2_CustomRimLight;T2_CustomRimLight?;61;0;Create;True;0;0;False;1;Header(Custom Rim Light);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;951;-9874.454,-3091.341;Inherit;False;Constant;_Float9;Float 9;130;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;996;-9863.848,-2812.272;Inherit;False;Constant;_Float10;Float 10;140;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1239;-9875.892,-295.2384;Inherit;False;Constant;_Float45;Float 45;132;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1269;-9865.285,-16.17054;Inherit;False;Constant;_Float42;Float 42;137;0;Create;True;0;0;False;0;False;0.2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1182;-14901.53,92.21172;Inherit;True;Property;_TextureSample52;Texture Sample 52;156;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1190;-14903.06,-100.5114;Inherit;True;Property;_TextureSample35;Texture Sample 35;147;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;1241;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;858;-14919.18,-3808.473;Inherit;True;Property;_TextureSample44;Texture Sample 44;8;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;865;Auto;Texture2DArray;8;0;SAMPLER2DARRAY;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;-1642.624,-4513.329;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;-1621.909,-3701.79;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;TerrainMaterialShader;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;0;  Blend;0;Two Sided;1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;True;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;5;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;1329;0;1316;0
WireConnection;1329;1;1344;0
WireConnection;1323;0;1290;0
WireConnection;1323;1;1321;0
WireConnection;1323;2;1336;0
WireConnection;1317;0;1300;0
WireConnection;1316;0;1343;0
WireConnection;1315;0;1324;0
WireConnection;1315;1;1328;0
WireConnection;1319;0;1305;0
WireConnection;430;0;356;0
WireConnection;430;1;425;0
WireConnection;430;2;420;0
WireConnection;1321;0;1292;0
WireConnection;1321;1;1333;0
WireConnection;1326;0;1297;0
WireConnection;1349;0;1339;0
WireConnection;1349;1;1370;0
WireConnection;1262;0;1216;0
WireConnection;1370;0;1337;0
WireConnection;1370;1;1334;0
WireConnection;1327;0;1315;0
WireConnection;1327;1;1313;0
WireConnection;1327;2;1329;0
WireConnection;1322;0;1174;0
WireConnection;1322;1;1349;0
WireConnection;1320;0;1272;0
WireConnection;1320;1;1293;0
WireConnection;1320;2;1333;0
WireConnection;1330;0;1344;0
WireConnection;1330;1;1345;0
WireConnection;1331;0;1346;0
WireConnection;1331;1;1271;0
WireConnection;1187;0;1107;0
WireConnection;1328;0;1329;0
WireConnection;1328;1;1312;0
WireConnection;1350;0;1238;0
WireConnection;1090;0;1363;0
WireConnection;1245;0;1211;0
WireConnection;1245;1;1181;0
WireConnection;1113;0;1094;0
WireConnection;1176;0;1203;0
WireConnection;1202;0;1184;0
WireConnection;1205;0;1241;0
WireConnection;1215;0;1180;0
WireConnection;1371;0;1190;0
WireConnection;1369;0;1182;0
WireConnection;1359;0;1247;0
WireConnection;1360;0;1257;0
WireConnection;1214;0;1196;0
WireConnection;218;1;386;0
WireConnection;1183;0;1210;0
WireConnection;1241;0;1194;0
WireConnection;1241;1;1192;0
WireConnection;1241;6;1091;0
WireConnection;1087;1;1081;0
WireConnection;1087;6;1086;0
WireConnection;1178;0;1362;0
WireConnection;1194;0;1193;0
WireConnection;1222;0;1228;0
WireConnection;1222;1;1220;0
WireConnection;1222;2;1251;0
WireConnection;1223;0;1253;0
WireConnection;1223;1;1221;0
WireConnection;1223;2;1248;0
WireConnection;1224;0;1228;0
WireConnection;1224;1;1251;0
WireConnection;1227;0;1225;0
WireConnection;1227;1;1256;0
WireConnection;1229;1;1218;0
WireConnection;1368;0;1184;4
WireConnection;1010;0;698;0
WireConnection;1010;1;1011;0
WireConnection;1010;2;1012;0
WireConnection;1256;0;1277;0
WireConnection;1257;0;1254;0
WireConnection;1258;158;1261;0
WireConnection;1258;183;1239;0
WireConnection;1258;5;1350;0
WireConnection;1313;0;1328;0
WireConnection;1311;0;1316;0
WireConnection;1311;1;1344;0
WireConnection;1311;2;1330;0
WireConnection;434;0;429;0
WireConnection;434;1;432;0
WireConnection;415;0;301;0
WireConnection;415;1;405;0
WireConnection;1263;0;1264;0
WireConnection;1147;0;1168;0
WireConnection;1147;1;1123;0
WireConnection;1147;2;1165;0
WireConnection;1174;0;1338;0
WireConnection;1174;1;1326;0
WireConnection;1177;0;1222;0
WireConnection;1177;1;1229;0
WireConnection;1312;0;1310;0
WireConnection;1312;1;1296;0
WireConnection;1282;0;1255;0
WireConnection;1282;1;1267;0
WireConnection;1282;2;1284;0
WireConnection;1255;0;1231;0
WireConnection;1255;1;1283;0
WireConnection;1254;1;1260;0
WireConnection;1254;0;1236;0
WireConnection;1246;0;1244;0
WireConnection;1244;0;1177;0
WireConnection;1209;0;1211;0
WireConnection;1209;1;1245;0
WireConnection;1209;2;1200;0
WireConnection;1210;0;1095;0
WireConnection;1210;1;1093;0
WireConnection;1212;0;1266;0
WireConnection;1220;0;1237;0
WireConnection;1220;1;1251;0
WireConnection;1186;0;1130;0
WireConnection;1186;1;1152;0
WireConnection;1218;0;1250;0
WireConnection;1218;1;1249;0
WireConnection;1247;0;1268;0
WireConnection;1267;0;1283;0
WireConnection;1130;0;1104;0
WireConnection;1295;0;1322;0
WireConnection;1295;1;1352;0
WireConnection;1296;1;1331;0
WireConnection;1297;0;1351;0
WireConnection;1289;0;1287;0
WireConnection;1196;0;1198;0
WireConnection;1196;1;1199;0
WireConnection;1196;2;1195;0
WireConnection;1298;0;1301;0
WireConnection;1264;0;1212;0
WireConnection;1264;1;1232;0
WireConnection;1264;2;1285;0
WireConnection;1253;0;1177;0
WireConnection;1253;1;1224;0
WireConnection;1253;2;1246;0
WireConnection;1221;0;1219;0
WireConnection;1221;1;1251;0
WireConnection;1303;1;1309;0
WireConnection;1303;0;1306;0
WireConnection;1278;0;1279;0
WireConnection;1278;1;1270;0
WireConnection;1265;0;1263;0
WireConnection;1265;1;1276;0
WireConnection;1288;0;1320;0
WireConnection;1288;1;1273;0
WireConnection;1286;0;1233;0
WireConnection;1286;1;1234;0
WireConnection;1290;0;1288;0
WireConnection;1290;1;1274;0
WireConnection;1290;2;1289;0
WireConnection;1268;1;1258;0
WireConnection;1268;0;1235;0
WireConnection;1291;0;1335;0
WireConnection;1291;1;1347;0
WireConnection;1293;0;1332;0
WireConnection;1293;1;1333;0
WireConnection;1260;158;1201;0
WireConnection;1260;183;1269;0
WireConnection;1260;5;1262;0
WireConnection;1287;0;1288;0
WireConnection;1277;0;1278;0
WireConnection;1277;1;1353;0
WireConnection;1279;0;1252;0
WireConnection;1279;1;1281;0
WireConnection;1280;0;1355;0
WireConnection;1280;1;1365;0
WireConnection;1270;0;1259;0
WireConnection;1270;1;1280;0
WireConnection;1283;0;1284;0
WireConnection;1283;1;1265;0
WireConnection;1273;1;1291;0
WireConnection;1242;0;1223;0
WireConnection;1276;1;1286;0
WireConnection;1284;0;1212;0
WireConnection;1284;1;1232;0
WireConnection;1102;0;1142;4
WireConnection;428;0;418;0
WireConnection;1274;0;1272;0
WireConnection;1274;1;1333;0
WireConnection;1275;0;1226;0
WireConnection;1305;1;1308;0
WireConnection;1305;0;1325;0
WireConnection;142;0;162;0
WireConnection;142;1;128;0
WireConnection;1309;158;1342;0
WireConnection;1309;183;1318;0
WireConnection;1309;5;1298;0
WireConnection;1307;0;1303;0
WireConnection;429;0;408;0
WireConnection;429;1;406;0
WireConnection;362;0;157;0
WireConnection;362;2;180;0
WireConnection;435;0;425;0
WireConnection;435;1;421;0
WireConnection;1304;0;1295;0
WireConnection;427;0;420;0
WireConnection;427;1;421;0
WireConnection;1285;0;1232;0
WireConnection;1285;1;1230;0
WireConnection;414;0;411;0
WireConnection;414;1;412;0
WireConnection;1281;0;1275;0
WireConnection;1310;0;1311;0
WireConnection;433;0;431;0
WireConnection;286;0;282;0
WireConnection;286;1;280;0
WireConnection;286;2;611;0
WireConnection;408;0;424;0
WireConnection;406;0;416;0
WireConnection;406;1;435;0
WireConnection;406;2;427;0
WireConnection;1132;0;1143;0
WireConnection;1308;158;1341;0
WireConnection;1308;183;1299;0
WireConnection;1308;5;1317;0
WireConnection;359;0;157;0
WireConnection;359;2;159;0
WireConnection;140;0;413;0
WireConnection;424;0;430;0
WireConnection;424;1;426;0
WireConnection;1358;0;1327;0
WireConnection;418;0;431;0
WireConnection;418;1;434;0
WireConnection;635;0;632;0
WireConnection;635;1;691;0
WireConnection;635;2;693;0
WireConnection;14;0;11;0
WireConnection;14;1;576;0
WireConnection;14;2;585;0
WireConnection;594;1;563;0
WireConnection;594;6;598;0
WireConnection;282;0;705;0
WireConnection;282;1;294;0
WireConnection;282;2;609;0
WireConnection;592;1;563;0
WireConnection;592;6;596;0
WireConnection;559;1;563;0
WireConnection;559;6;595;0
WireConnection;622;0;495;0
WireConnection;576;0;579;0
WireConnection;576;1;578;0
WireConnection;576;2;577;0
WireConnection;586;0;7;3
WireConnection;565;0;573;0
WireConnection;565;1;489;0
WireConnection;565;2;567;0
WireConnection;705;0;704;0
WireConnection;705;1;1010;0
WireConnection;197;0;365;0
WireConnection;479;0;594;0
WireConnection;580;0;583;0
WireConnection;580;1;584;0
WireConnection;580;2;581;0
WireConnection;363;1;359;0
WireConnection;420;0;425;0
WireConnection;420;1;422;0
WireConnection;157;0;170;0
WireConnection;157;1;142;0
WireConnection;157;2;168;0
WireConnection;488;0;559;0
WireConnection;495;0;14;0
WireConnection;495;1;580;0
WireConnection;495;2;586;0
WireConnection;1143;0;1146;0
WireConnection;1143;1;1057;0
WireConnection;1143;6;1068;0
WireConnection;569;0;574;0
WireConnection;569;1;570;0
WireConnection;569;2;571;0
WireConnection;593;1;563;0
WireConnection;593;6;597;0
WireConnection;386;0;362;0
WireConnection;644;0;640;0
WireConnection;563;0;590;0
WireConnection;1173;1;1069;0
WireConnection;1173;6;1075;0
WireConnection;478;0;593;0
WireConnection;1137;0;1139;0
WireConnection;1366;0;1148;0
WireConnection;1131;0;1045;0
WireConnection;365;0;218;1
WireConnection;365;1;363;1
WireConnection;1372;0;1138;0
WireConnection;1364;0;1050;0
WireConnection;477;0;592;0
WireConnection;162;0;176;0
WireConnection;180;0;159;0
WireConnection;411;0;169;0
WireConnection;1119;0;1209;0
WireConnection;1146;0;1145;0
WireConnection;1217;0;1227;0
WireConnection;170;0;128;0
WireConnection;1115;0;1140;0
WireConnection;1115;1;1052;0
WireConnection;1115;6;1077;0
WireConnection;413;0;414;0
WireConnection;413;1;358;0
WireConnection;11;0;565;0
WireConnection;11;1;569;0
WireConnection;11;2;7;1
WireConnection;1100;0;1144;0
WireConnection;1101;0;1142;0
WireConnection;1111;0;1115;0
WireConnection;1302;0;1340;0
WireConnection;1302;1;1304;0
WireConnection;1361;0;1302;0
WireConnection;1140;0;1098;0
WireConnection;632;0;642;0
WireConnection;632;1;690;0
WireConnection;632;2;624;1
WireConnection;431;0;434;0
WireConnection;640;0;635;0
WireConnection;640;1;692;0
WireConnection;640;2;694;0
WireConnection;1348;0;1319;0
WireConnection;694;0;624;3
WireConnection;139;0;177;0
WireConnection;1120;0;1053;0
WireConnection;1127;0;1172;0
WireConnection;1127;1;1151;0
WireConnection;693;0;624;2
WireConnection;1124;158;1185;0
WireConnection;1124;183;1084;0
WireConnection;1124;80;1096;0
WireConnection;1124;104;1092;0
WireConnection;211;0;196;0
WireConnection;211;1;195;0
WireConnection;133;0;74;0
WireConnection;1129;0;1046;0
WireConnection;1129;1;1159;0
WireConnection;1129;2;1158;0
WireConnection;1129;3;1157;0
WireConnection;1129;5;1141;0
WireConnection;884;1;891;0
WireConnection;884;6;885;0
WireConnection;1122;0;1064;0
WireConnection;946;1;939;0
WireConnection;1356;0;1323;0
WireConnection;1001;0;974;0
WireConnection;1001;1;1004;0
WireConnection;1357;0;1307;0
WireConnection;865;0;881;0
WireConnection;865;1;876;0
WireConnection;865;6;857;0
WireConnection;1354;0;1282;0
WireConnection;410;0;332;0
WireConnection;240;0;137;0
WireConnection;251;0;226;0
WireConnection;251;1;375;0
WireConnection;873;0;874;0
WireConnection;130;0;167;0
WireConnection;130;1;175;0
WireConnection;748;0;340;0
WireConnection;713;0;712;0
WireConnection;213;0;364;0
WireConnection;213;1;231;0
WireConnection;928;0;812;0
WireConnection;928;1;814;0
WireConnection;928;2;813;0
WireConnection;229;0;248;0
WireConnection;229;1;275;0
WireConnection;195;1;213;0
WireConnection;196;0;189;0
WireConnection;196;1;193;0
WireConnection;196;2;375;0
WireConnection;206;0;134;0
WireConnection;304;0;247;0
WireConnection;304;1;251;0
WireConnection;304;2;355;0
WireConnection;289;0;229;0
WireConnection;738;0;737;0
WireConnection;191;0;335;0
WireConnection;191;1;252;0
WireConnection;191;2;615;0
WireConnection;222;0;189;0
WireConnection;222;1;375;0
WireConnection;202;0;190;0
WireConnection;246;0;301;0
WireConnection;246;1;415;0
WireConnection;246;2;409;0
WireConnection;193;0;232;0
WireConnection;193;1;375;0
WireConnection;332;0;395;0
WireConnection;332;1;601;0
WireConnection;599;0;171;0
WireConnection;826;0;811;0
WireConnection;883;1;916;0
WireConnection;883;0;818;0
WireConnection;853;0;846;0
WireConnection;891;0;821;0
WireConnection;891;1;919;0
WireConnection;891;2;841;0
WireConnection;701;0;700;0
WireConnection;1053;0;1121;0
WireConnection;1053;1;1055;0
WireConnection;1053;2;1048;0
WireConnection;908;1;907;0
WireConnection;908;0;819;0
WireConnection;179;0;130;0
WireConnection;179;1;132;0
WireConnection;179;2;127;0
WireConnection;179;3;146;0
WireConnection;179;5;208;0
WireConnection;158;0;130;0
WireConnection;158;1;179;0
WireConnection;158;2;150;0
WireConnection;886;0;903;0
WireConnection;886;1;905;0
WireConnection;886;2;920;0
WireConnection;1125;158;1175;0
WireConnection;1125;183;1083;0
WireConnection;1125;80;1073;0
WireConnection;1125;104;1072;0
WireConnection;809;0;806;0
WireConnection;809;1;808;0
WireConnection;809;2;807;0
WireConnection;903;0;923;0
WireConnection;903;1;906;0
WireConnection;911;0;909;0
WireConnection;911;1;914;0
WireConnection;811;0;926;0
WireConnection;811;1;928;0
WireConnection;821;0;918;0
WireConnection;821;1;820;0
WireConnection;918;0;917;0
WireConnection;340;0;274;0
WireConnection;340;1;349;0
WireConnection;340;2;607;0
WireConnection;862;0;858;0
WireConnection;735;0;734;0
WireConnection;909;0;908;0
WireConnection;909;1;910;0
WireConnection;914;0;913;0
WireConnection;871;0;869;0
WireConnection;871;1;870;0
WireConnection;871;2;872;0
WireConnection;167;0;163;0
WireConnection;868;0;871;0
WireConnection;919;0;821;0
WireConnection;919;1;822;0
WireConnection;919;2;854;0
WireConnection;919;3;882;0
WireConnection;919;5;890;0
WireConnection;808;0;806;0
WireConnection;808;1;844;0
WireConnection;912;0;911;0
WireConnection;912;1;886;0
WireConnection;913;0;883;0
WireConnection;913;1;817;0
WireConnection;708;0;706;0
WireConnection;856;0;867;0
WireConnection;732;0;731;0
WireConnection;381;1;158;0
WireConnection;381;6;156;0
WireConnection;916;158;823;0
WireConnection;916;183;921;0
WireConnection;916;80;922;0
WireConnection;916;104;915;0
WireConnection;839;0;809;0
WireConnection;617;158;709;0
WireConnection;617;183;619;0
WireConnection;617;80;620;0
WireConnection;617;104;621;0
WireConnection;906;158;825;0
WireConnection;906;183;889;0
WireConnection;906;80;887;0
WireConnection;906;104;888;0
WireConnection;187;0;246;0
WireConnection;861;0;859;0
WireConnection;190;0;184;0
WireConnection;190;1;191;0
WireConnection;184;0;224;0
WireConnection;184;1;135;0
WireConnection;601;0;397;0
WireConnection;601;1;600;0
WireConnection;601;2;602;0
WireConnection;252;0;335;0
WireConnection;867;0;873;0
WireConnection;867;1;875;0
WireConnection;867;6;880;0
WireConnection;335;0;399;0
WireConnection;335;1;617;0
WireConnection;135;0;253;0
WireConnection;860;0;859;4
WireConnection;336;158;710;0
WireConnection;336;183;711;0
WireConnection;336;80;145;0
WireConnection;336;104;258;0
WireConnection;907;0;884;1
WireConnection;926;0;815;0
WireConnection;926;1;810;0
WireConnection;863;0;865;0
WireConnection;395;0;262;0
WireConnection;395;1;385;0
WireConnection;253;0;285;0
WireConnection;253;1;297;0
WireConnection;905;0;903;0
WireConnection;1002;0;964;0
WireConnection;1002;1;1003;0
WireConnection;849;0;851;0
WireConnection;716;1;403;0
WireConnection;716;0;717;0
WireConnection;224;0;716;0
WireConnection;224;1;318;0
WireConnection;265;0;171;4
WireConnection;261;158;742;0
WireConnection;261;183;743;0
WireConnection;261;5;255;0
WireConnection;850;0;852;0
WireConnection;285;1;336;0
WireConnection;285;0;377;0
WireConnection;1046;0;1060;0
WireConnection;1046;1;1067;0
WireConnection;1050;0;1118;0
WireConnection;1050;1;1367;0
WireConnection;1050;2;1049;0
WireConnection;1051;0;1079;0
WireConnection;1003;0;968;0
WireConnection;1003;1;967;0
WireConnection;1094;0;1126;0
WireConnection;1094;1;1124;0
WireConnection;1045;0;1127;0
WireConnection;1045;1;1147;0
WireConnection;403;0;381;1
WireConnection;255;0;151;0
WireConnection;969;0;944;0
WireConnection;1056;0;1063;0
WireConnection;1108;0;1109;0
WireConnection;1108;1;1114;0
WireConnection;950;0;975;0
WireConnection;296;0;350;0
WireConnection;264;0;389;0
WireConnection;264;1;256;0
WireConnection;816;0;912;0
WireConnection;74;0;708;0
WireConnection;74;1;50;0
WireConnection;74;6;71;0
WireConnection;1055;0;1121;0
WireConnection;1055;1;1116;0
WireConnection;1088;1;1105;0
WireConnection;1088;0;1149;0
WireConnection;985;0;1005;0
WireConnection;965;0;979;0
WireConnection;1093;0;1208;0
WireConnection;1093;1;1189;0
WireConnection;1093;2;1167;0
WireConnection;966;0;980;0
WireConnection;935;0;936;0
WireConnection;1081;0;1186;0
WireConnection;1081;1;1080;0
WireConnection;1081;2;1161;0
WireConnection;1106;0;1088;0
WireConnection;1106;1;1170;0
WireConnection;1107;0;1108;0
WireConnection;1107;1;1085;0
WireConnection;1095;0;1188;0
WireConnection;1095;1;1153;0
WireConnection;374;0;325;0
WireConnection;1097;0;1173;1
WireConnection;1105;158;1197;0
WireConnection;1105;183;1099;0
WireConnection;1105;80;1071;0
WireConnection;1105;104;1169;0
WireConnection;585;0;7;2
WireConnection;1078;1;1097;0
WireConnection;1078;0;1155;0
WireConnection;1114;0;1106;0
WireConnection;1065;0;1066;0
WireConnection;1065;1;1056;0
WireConnection;1110;1;1112;0
WireConnection;1110;0;1156;0
WireConnection;1060;0;1061;0
WireConnection;1069;0;1046;0
WireConnection;1069;1;1129;0
WireConnection;1069;2;1150;0
WireConnection;1085;0;1094;0
WireConnection;1085;1;1113;0
WireConnection;1085;2;1128;0
WireConnection;1062;158;1213;0
WireConnection;1062;183;1133;0
WireConnection;1062;80;1117;0
WireConnection;1062;104;1166;0
WireConnection;1076;1;1062;0
WireConnection;1076;0;1171;0
WireConnection;1066;0;1078;0
WireConnection;1066;1;1162;0
WireConnection;1112;0;1087;1
WireConnection;1074;0;1079;0
WireConnection;1074;1;1051;0
WireConnection;1074;2;1103;0
WireConnection;851;1;875;0
WireConnection;851;6;877;0
WireConnection;382;0;206;0
WireConnection;382;1;154;0
WireConnection;1063;0;1076;0
WireConnection;1063;1;1135;0
WireConnection;360;0;317;0
WireConnection;360;1;344;0
WireConnection;1080;0;1186;0
WireConnection;1080;1;1160;0
WireConnection;1080;2;1191;0
WireConnection;1080;3;1089;0
WireConnection;1080;5;1082;0
WireConnection;1079;0;1134;0
WireConnection;1079;1;1125;0
WireConnection;383;0;305;0
WireConnection;339;0;206;0
WireConnection;339;1;154;0
WireConnection;339;2;216;0
WireConnection;164;0;396;0
WireConnection;417;0;264;0
WireConnection;417;1;319;0
WireConnection;319;0;401;0
WireConnection;319;1;290;0
WireConnection;324;0;322;0
WireConnection;317;0;339;0
WireConnection;881;0;866;0
WireConnection;344;1;303;0
WireConnection;276;0;417;0
WireConnection;276;1;321;0
WireConnection;320;1;261;0
WireConnection;320;0;329;0
WireConnection;350;0;277;0
WireConnection;350;1;383;0
WireConnection;350;2;382;0
WireConnection;351;0;304;0
WireConnection;306;1;249;0
WireConnection;306;0;311;0
WireConnection;1006;0;1007;0
WireConnection;1006;1;988;0
WireConnection;249;158;744;0
WireConnection;249;183;745;0
WireConnection;249;5;244;0
WireConnection;244;0;124;0
WireConnection;277;0;372;0
WireConnection;277;1;305;0
WireConnection;305;0;382;0
WireConnection;305;1;360;0
WireConnection;325;0;320;0
WireConnection;942;0;940;0
WireConnection;942;1;973;0
WireConnection;216;0;154;0
WireConnection;216;1;178;0
WireConnection;247;0;211;0
WireConnection;247;1;222;0
WireConnection;247;2;240;0
WireConnection;290;0;295;0
WireConnection;290;1;393;0
WireConnection;1109;0;1110;0
WireConnection;1109;1;1154;0
WireConnection;1064;0;1065;0
WireConnection;1064;1;1074;0
WireConnection;275;0;276;0
WireConnection;995;0;952;0
WireConnection;137;0;211;0
WireConnection;1000;0;1001;0
WireConnection;1000;1;1002;0
WireConnection;944;0;938;0
WireConnection;944;1;942;0
WireConnection;944;2;970;0
WireConnection;988;0;986;0
WireConnection;988;1;998;0
WireConnection;982;158;994;0
WireConnection;982;183;996;0
WireConnection;982;5;984;0
WireConnection;993;0;989;0
WireConnection;992;0;954;0
WireConnection;992;1;1006;0
WireConnection;987;0;993;0
WireConnection;987;1;960;0
WireConnection;987;2;1008;0
WireConnection;1007;0;993;0
WireConnection;1007;1;960;0
WireConnection;943;0;948;0
WireConnection;943;1;941;0
WireConnection;943;2;973;0
WireConnection;945;0;948;0
WireConnection;945;1;973;0
WireConnection;256;0;164;0
WireConnection;303;0;236;0
WireConnection;303;1;210;0
WireConnection;990;0;1006;0
WireConnection;980;0;978;0
WireConnection;941;0;953;0
WireConnection;941;1;973;0
WireConnection;1008;0;960;0
WireConnection;1008;1;959;0
WireConnection;979;0;976;0
WireConnection;986;0;987;0
WireConnection;997;0;947;0
WireConnection;998;1;1009;0
WireConnection;975;0;962;0
WireConnection;975;1;977;0
WireConnection;977;0;999;0
WireConnection;936;0;943;0
WireConnection;936;1;946;0
WireConnection;610;0;281;0
WireConnection;937;0;935;0
WireConnection;999;0;1000;0
WireConnection;999;1;961;0
WireConnection;1009;0;958;0
WireConnection;1009;1;957;0
WireConnection;1362;0;1090;0
WireConnection;1362;1;1164;0
WireConnection;1362;6;1204;0
WireConnection;939;0;972;0
WireConnection;939;1;971;0
WireConnection;976;1;982;0
WireConnection;976;0;955;0
WireConnection;938;0;936;0
WireConnection;938;1;945;0
WireConnection;938;2;937;0
WireConnection;322;0;306;0
WireConnection;1005;0;992;0
WireConnection;1005;1;990;0
WireConnection;1005;2;1007;0
WireConnection;981;158;983;0
WireConnection;981;183;951;0
WireConnection;981;5;995;0
WireConnection;984;0;963;0
WireConnection;566;0;564;0
WireConnection;734;1;739;0
WireConnection;734;6;733;0
WireConnection;1004;0;997;0
WireConnection;606;0;605;0
WireConnection;177;1;50;0
WireConnection;177;6;172;0
WireConnection;171;1;50;0
WireConnection;171;6;241;0
WireConnection;700;0;738;0
WireConnection;700;1;739;0
WireConnection;700;6;268;0
WireConnection;614;0;613;0
WireConnection;608;0;423;0
WireConnection;978;1;981;0
WireConnection;978;0;956;0
WireConnection;731;1;739;0
WireConnection;731;6;714;0
WireConnection;1180;1;1192;0
WireConnection;1180;6;1136;0
WireConnection;852;1;875;0
WireConnection;852;6;878;0
WireConnection;1203;1;1164;0
WireConnection;1203;6;1206;0
WireConnection;1184;1;1164;0
WireConnection;1184;6;1207;0
WireConnection;1139;1;1052;0
WireConnection;1139;6;1058;0
WireConnection;1138;1;1052;0
WireConnection;1138;6;1059;0
WireConnection;1148;1;1052;0
WireConnection;1148;6;1070;0
WireConnection;1142;1;1057;0
WireConnection;1142;6;1054;0
WireConnection;712;1;739;0
WireConnection;712;6;702;0
WireConnection;859;1;876;0
WireConnection;859;6;864;0
WireConnection;846;1;875;0
WireConnection;846;6;879;0
WireConnection;1144;1;1057;0
WireConnection;1144;6;1047;0
WireConnection;1182;1;1192;0
WireConnection;1182;6;1179;0
WireConnection;1190;1;1192;0
WireConnection;1190;6;1163;0
WireConnection;858;1;876;0
WireConnection;858;6;855;0
WireConnection;2;2;286;0
ASEEND*/
//CHKSM=DDFD5069ECC016811E2D8103B01C3C47A642DEDD
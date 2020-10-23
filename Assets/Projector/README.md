
# Projector For LWRP

## Overview
This project provides Unity C# scripts and shaders to use [Projector](https://docs.unity3d.com/Manual/class-Projector.html) component with [Universal Render Pipeline](https://docs.unity3d.com/Packages/com.unity.render-pipelines.universal@7.1/manual/index.html).

[Online Document](https://nyahoon.com/products/projector-for-lwrp)

# Important Change History
### 23/Jun/2020
Switch the default branch to `master-universal`.

### 17/Jun/2020
Added `Projector For SRP` class which is a base component of `Projector For LWRP` and moved non Universal RP specific fumctions to it.

In conjunction with this change, the following properties are removed for simplification.

- `Is Dynamic` property from `Projector For LWRP`. Changes of the projector frustum are now automatically detected. No longer need to call `UpdateFrustum` function manually.
- `Camera Tags` and `Cameras` properties from `Projector For LWRP`. Projectors can be filtered out by camera culling mask.
- `Stencil Ref` and `Stencil Mask` properties from `Projector For LWRP`. Please use `Stencil Mask` propety in `Projector Renderer Feature` instead.
- `Check Unity Projector Component Enabled` property from `Projector Renderer Feature`.
  With this change, existing `Forward Renderer Data` might lose the reference to the `Projector Renderer Feature`.
  Please fix `Forward Renderer Data` if you see `ProjectorRendererFeature is not added to the current Forward Renderer Data.` errors.

### 17/Apr/2020
~~Add `Is Dynamic` property for projectors whose properties are frequently changed at runtime.~~ (Removed by the changes on 17/Jun/2020)

~~Add `Camera Tags` property to specify cameras where the projector is rendered.~~ (Removed by the changes on 17/Jun/2020)

`FSR_PROJECTOR_FOR_LWRP` shader keyword is separated from other `FSR_XXXX` keywords. Please use `#pragma shader_feature` for this keyword.

See [Sample Code](#Sample-Code) section below for the details.

### 22/Dec/2019
Stop disabling the original `Projector` component. Also, the renderer will check if the original `Projector` component is enabled or not, and if not, the projector will not be rendered.

If you are updating from older version, please manually enable the original `Projector` components in your existing scenes.
~~If it is inconvenient to manually enable the original `Projector` components, you can uncheck `Check Unity Projector Component Enabled` field of `ProjectorRendererFeature` in your `ForwardRendererData` asset.~~  (Removed by the changes on 17/Jun/2020)

## Verified Universal RP version
7.1.7

## Branches
| Branch name | Description |
|:---|:---|
| master | A branch for Lightweight Render Pipeline (Unity 2019.2 or below). |
| master-universalrp | A branch for Universal Render Pipeline (Unity 2019.3 or higher). This is the default branch. |

## Install
Clone (or submodule add) `master-universalrp` branch into the Assets folder in your Unity Project.

### Clone:
	cd Pass-to-Your-Unity-Project/Assets
	git clone -b master-universalrp https://github.com/nyahoon-games/ProjectorForLWRP.git

### Submodule Add:
	cd Pass-to-Your-Unity-Project
	git submodule add -b master-universalrp https://github.com/nyahoon-games/ProjectorForLWRP.git Assets/ProjectorForLWRP

## Setup
If you already have a `ForwardRendererData` asset and assigned it to the `LightweightRenderPipelineAsset`, add a `ProjectorRendererFeature` to your `ForwardRendererData`.
The user interface might look different in newer versions but there must be a similer interface.

![](https://nyahoon.com/wp/wp-content/uploads/2020/04/addrendererfeature-urp.png) ![](https://nyahoon.com/wp/wp-content/uploads/2019/05/addrendererfeature-urp.png)

If you don’t have a `ForwardRendererData` asset yet, you can use `Assets/ProjectorForLWRP/Data/ForwardRendererWithProjectorPass`. Go to Graphics Settings and double click `LightweightRenderPipelineAsset` in Scriptable Render Pipeline Settings. Then, in Inspector View, change `Renderer Type` to `custom` and assign  Assets/ProjectorForLWRP/Data/ForwardRendererWithProjectorPass to `Data`.

![](https://nyahoon.com/wp/wp-content/uploads/2019/05/selectforwardrendererdata-urp.png)

## How to Use
1. Select an existing `GameObject` that has Projector component, or create a new empty `GameObject`.
2. Press `Add Component` button in Inspector View, and select `Scripts` > `ProjectorForLWRP` > `Projector For LWRP`.
3. The `GameObject` will contain `Projector` component and `Projector For LWRP` component. You still need to setup `Projector` properties as usual. One thing that is different from usual settings is that you cannot use the projector shaders in Standard Assets. Please use one of the shaders in this project, or create a custom shaders if needed. Shaders in [Dynamic Shadow Projector](https://nyahoon.com/products/dynamic-shadow-projector) and [Fast Shadow Receiver](https://nyahoon.com/products/fast-shadow-receiver) are also available (if you have old version, you might need update them).
4. In addition to setting up Projector properties, you might need to setup the properties of Projector For LWRP component.

## Properties of Projector For LWRP component
| Property | Description |
|:---|:---|
| Rendering Layer Mask | Only the renderers whose `renderingLayerMask` property contains any layers in this property can receive projection. |
| Render Queue Lower/Upper Bound | Only the renderers of which the render queue values of their materials are within this range can receive projection. |
| Render Pass Event | An event in which projector render pass is inserted. Please be aware that the render queue value of the projector's material is ignored. |
| Shader Tag List | An array of `LightMode` tag values. Only the renderers whose material has a shader that contains a pass whose `LightMode` tag value is identical to one of the values in the array can receive projection. If a shader pass doesn't have `LightMode` tag, its  `LightMode` tag value is considered as `SRPDefaultUnlit`. Default value is an empty array which means `UniversalForward` and `SRPDefaultUnlit` are used for this property. If the array is not empty, default tags are overwritten. To add a value, please increase `Size` first. |
| Per Object Data | Kinds of per object data (other than transform matrix) that are required by the projector's material. |
| Use Stencil Test | There is a chance to improve the rendering performance if stencil test is enabled. Just try and see if it is effective or not. Don't need to use stencil test, if the projector is used with [Fast Shadow Receiver](https://nyahoon.com/products/fast-shadow-receiver). |

## Projector Shaders
If you need a custom projector shader, please include "Assets/ProjectorForLWRP/Shaders/P4LWRP.cginc" and use `fsrTransformVertex` function to transform vertex and projection uv. The shader must be compiled with `FSR_PROJECTOR_FOR_LWRP` keyword.

To make the shader SRP Batcher compatible, please use `#pragma enable_cbuffer` or use `HLSLPROGRAM` instead of `CGPROGRAM`.

### Sample Code:

	Shader "Custom/Projector/Shadow" 
	{
		Properties {
			[NoScaleOffset] _ShadowTex ("Cookie", 2D) = "gray" {}
			[NoScaleOffset] _FalloffTex ("FallOff", 2D) = "white" {}
			_Offset ("Offset", Range (-1, -10)) = -1.0
		}
		SubShader
		{
			Tags {"Queue"="Transparent-1"}
			Pass
			{
				ZWrite Off
				Fog { Color (1, 1, 1) }
				ColorMask RGB
				Blend DstColor Zero
				Offset -1, [_Offset]
	
				HLSLPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma shader_feature_local FSR_PROJECTOR_FOR_LWRP
				#pragma multi_compile_fog
				#include "Assets/ProjectorForLWRP/Shaders/P4LWRP.cginc"
	
				P4LWRP_V2F_PROJECTOR vert(float4 vertex : POSITION)
				{
					P4LWRP_V2F_PROJECTOR o;
					fsrTransformVertex(vertex, o.pos, o.uvShadow);
					UNITY_TRANSFER_FOG(o, o.pos);
					return o;
				}

				fixed4 frag(P4LWRP_V2F_PROJECTOR i) : SV_Target
				{
					fixed4 col;
 					fixed falloff = tex2D(_FalloffTex, i.uvShadow.zz).a;
					col.rgb = tex2Dproj(_ShadowTex, UNITY_PROJ_COORD(i.uvShadow)).rgb;
					col.a = 1.0f;
					col.rgb = lerp(fixed3(1,1,1), col.rgb, falloff);
					UNITY_APPLY_FOG_COLOR(i.fogCoord, col, fixed4(1,1,1,1));
					return col;
				}
	
				ENDHLSL
			}
		} 
	}

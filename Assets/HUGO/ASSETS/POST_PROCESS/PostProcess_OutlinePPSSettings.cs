// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( PostProcess_OutlinePPSRenderer ), PostProcessEvent.AfterStack, "PostProcess_Outline", true )]
public sealed class PostProcess_OutlinePPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Screen" )]
	public TextureParameter _MainTex = new TextureParameter {  };
	[Tooltip( "Intensity" )]
	public FloatParameter _Intensity = new FloatParameter { value = 1f };
	[Tooltip( "Step" )]
	public FloatParameter _Step = new FloatParameter { value = 1f };
}

public sealed class PostProcess_OutlinePPSRenderer : PostProcessEffectRenderer<PostProcess_OutlinePPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "PostProcess_Outline" ) );
		if(settings._MainTex.value != null) sheet.properties.SetTexture( "_MainTex", settings._MainTex );
		sheet.properties.SetFloat( "_Intensity", settings._Intensity );
		sheet.properties.SetFloat( "_Step", settings._Step );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif

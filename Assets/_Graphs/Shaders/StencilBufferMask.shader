Shader "Unlit/StencilBufferMask"
{
    Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            ZWrite off
        }
    }
}

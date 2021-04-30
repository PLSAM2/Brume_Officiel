Shader "Custom/StencilCLEAR"{
	SubShader{

		Zwrite off
		ColorMask 0
		Cull off

		Stencil{
			Ref 1
			Comp always
		Pass replace
        }

		Pass {
        }
	}
}
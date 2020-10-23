Shader "Custom/Backobjects"
{
    SubShader
    {
        Pass {

            Stencil
            {
                Ref 1
                Comp Equal
            }
        }

    }
}

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/RealtimeShadowsBUP"
{
	Properties
    {
        //[NoScaleOffset] _MainTex ("Texture", 2D) = "white" {}
        
		_Color ("Tint Color 1", Color) = (1,1,1,1)
		_Color2 ("Tint Color 2", Color) = (1,1,1,1)
		_InkCol ("Ink Color", Color) = (1,1,1,1)
		
		_BlotchTex ("Blotches (RGB)", 2D) = "white" {}
		_DetailTex ("Detail (RGB)", 2D) = "white" {}
		_PaperTex ("Paper (RGB)", 2D) = "white" {}
		_RampTex ("Ramp (RGB)", 2D) = "white" {}
		
		_TintScale ("Tint Scale", Range(2,32)) = 4
		_PaperStrength ("Paper Strength", Range(0,1)) = 1
		_BlotchMulti ("Blotch Multiply", Range(0,8)) = 3
		_BlotchSub ("Blotch Subtract", Range(0,1)) = 0.5
		_BlurDist ("Blur Distance", Range(0,8)) = 1
    }
    SubShader {
    	Name "SubShader"
        Tags { "RenderType"="Opaque" "Queue"="Geometry" }
       
        
// ----------------------------- LIGHTING AND SHADOWS ----------------------------- //            
        Pass
        {
            Tags {"LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            // compile shader into multiple variants, with and without shadows
            // (we don't care about any lightmaps yet, so skip these variants)
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight
            // shadow helper functions and macros
            #include "AutoLight.cginc"

            struct v2f
            {
                float2 uv : TEXCOORD0;
                SHADOW_COORDS(1) // put shadows data into TEXCOORD1
                fixed3 diff : COLOR0;
                fixed3 ambient : COLOR1;
                float4 pos : SV_POSITION;
            };
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half nl = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
                o.diff = nl * _LightColor0.rgb;
                o.ambient = ShadeSH9(half4(worldNormal,1));
                // compute shadows data
                TRANSFER_SHADOW(o)
                return o;
            }

            sampler2D _MainTex;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = fixed4(1,1,1,1);
                // compute shadow attenuation (1.0 = fully lit, 0.0 = fully shadowed)
                fixed shadow = SHADOW_ATTENUATION(i);
                // darken light's illumination with shadow, keep ambient intact
                fixed3 lighting = i.diff * shadow + i.ambient;
                col.rgb *= lighting;
                return col;
            }
            ENDCG
        }

        // shadow casting support
        UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
		
        Pass 
        {
            Tags { "LightMode" = "ForwardAdd" }
            Blend One One
            Fog { Color(0,0,0,0) }
 
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
         uniform float4 _LightColor0;
 
            struct v2f 
            {
                float4 pos : SV_POSITION;
                LIGHTING_COORDS(0,1)
            };
 
            v2f vert (appdata_full v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_VERTEX_TO_FRAGMENT(o);
                return o;
            }
 
            float4 frag (v2f i) : COLOR {
                return LIGHT_ATTENUATION(i).r * _LightColor0.r;
            }
            ENDCG
        } //Pass
        
                
// ----------------------------- GRAB AND BLUR ----------------------------- //    
    
        GrabPass {
            Name "ShadowGrab"
        }
        
        Pass
        {
            Name "BlurGrab"
            Blend Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
 
            struct v2f {
                float4 pos          : POSITION;
                float4 uvgrab       : TEXCOORD0;
                float2 uv           : TEXCOORD1;
                float4 screenPos    : TEXCOORD2;
            };

            v2f vert (appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); 
                o.screenPos = o.pos;
                #if UNITY_UV_STARTS_AT_TOP
                float scale = -1.0;
                #else
                float scale = 1.0;
                #endif
                o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
                o.uvgrab.zw = o.pos.zw;
                o.uv = v.texcoord.xy;
                
                return o;
            }
            
            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize; 
			half _BlurDist;

            half4 frag( v2f i ) : COLOR
            {
            	float blurSize = 0.0025f * _BlurDist;
            	half4 sum = half4(0.0h,0.0h,0.0h,0.0h);   
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-5.0,+5.0,0,0) * blurSize)) * 0.025;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+5.0,-5.0,0,0) * blurSize)) * 0.025;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-4.0,+4.0,0,0) * blurSize)) * 0.05;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+4.0,-4.0,0,0) * blurSize)) * 0.05;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-3.0,+3.0,0,0) * blurSize)) * 0.09;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+3.0,-3.0,0,0) * blurSize)) * 0.09;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-2.0,+2.0,0,0) * blurSize)) * 0.12;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+2.0,-2.0,0,0) * blurSize)) * 0.12;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-1.0,+1.0,0,0) * blurSize)) * 0.15;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+1.0,-1.0,0,0) * blurSize)) * 0.15;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-5.0,-5.0,0,0) * blurSize)) * 0.025;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+5.0,+5.0,0,0) * blurSize)) * 0.025;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-4.0,-4.0,0,0) * blurSize)) * 0.05;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+4.0,+4.0,0,0) * blurSize)) * 0.05;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-3.0,-3.0,0,0) * blurSize)) * 0.09;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+3.0,+3.0,0,0) * blurSize)) * 0.09;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-2.0,-2.0,0,0) * blurSize)) * 0.12;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+2.0,+2.0,0,0) * blurSize)) * 0.12;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-1.0,-1.0,0,0) * blurSize)) * 0.15;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+1.0,+1.0,0,0) * blurSize)) * 0.15;
            	
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab)) * 0.26;
			       
				return sum/2;
            }
            
            ENDCG
        } 
        
// ----------------------------- GRAB AND BLUR (2) ----------------------------- //   
     
        GrabPass {
            Name "ShadowGrab"
        }
        
        Pass
        {
            Name "BlurGrab"
            Blend Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
 
            struct v2f {
                float4 pos          : POSITION;
                float4 uvgrab       : TEXCOORD0;
                float2 uv           : TEXCOORD1;
                float4 screenPos    : TEXCOORD2;
            };

            v2f vert (appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); 
                o.screenPos = o.pos;
                #if UNITY_UV_STARTS_AT_TOP
                float scale = -1.0;
                #else
                float scale = 1.0;
                #endif
                o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
                o.uvgrab.zw = o.pos.zw;
                o.uv = v.texcoord.xy;
                
                return o;
            }
            
            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize; 
			half _BlurDist;

            half4 frag( v2f i ) : COLOR
            {
            	float blurSize = 0.0025f * _BlurDist;
            	half4 sum = half4(0.0h,0.0h,0.0h,0.0h);   
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-5.0,+5.0,0,0) * blurSize)) * 0.025;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+5.0,-5.0,0,0) * blurSize)) * 0.025;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-4.0,+4.0,0,0) * blurSize)) * 0.05;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+4.0,-4.0,0,0) * blurSize)) * 0.05;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-3.0,+3.0,0,0) * blurSize)) * 0.09;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+3.0,-3.0,0,0) * blurSize)) * 0.09;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-2.0,+2.0,0,0) * blurSize)) * 0.12;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+2.0,-2.0,0,0) * blurSize)) * 0.12;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-1.0,+1.0,0,0) * blurSize)) * 0.15;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+1.0,-1.0,0,0) * blurSize)) * 0.15;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-5.0,-5.0,0,0) * blurSize)) * 0.025;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+5.0,+5.0,0,0) * blurSize)) * 0.025;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-4.0,-4.0,0,0) * blurSize)) * 0.05;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+4.0,+4.0,0,0) * blurSize)) * 0.05;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-3.0,-3.0,0,0) * blurSize)) * 0.09;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+3.0,+3.0,0,0) * blurSize)) * 0.09;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-2.0,-2.0,0,0) * blurSize)) * 0.12;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+2.0,+2.0,0,0) * blurSize)) * 0.12;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-1.0,-1.0,0,0) * blurSize)) * 0.15;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+1.0,+1.0,0,0) * blurSize)) * 0.15;
            	
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab)) * 0.26;
			       
				return sum/2;
            }
            
            ENDCG
        }   
        
                           
// ----------------------------- GRAB AND BLUR (3) ----------------------------- //   
     
        GrabPass {
            Name "ShadowGrab"
        }
        
        Pass
        {
            Name "BlurGrab"
            Blend Off
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma fragmentoption ARB_precision_hint_fastest
            #include "UnityCG.cginc"
 
            struct v2f {
                float4 pos          : POSITION;
                float4 uvgrab       : TEXCOORD0;
                float2 uv           : TEXCOORD1;
                float4 screenPos    : TEXCOORD2;
            };

            v2f vert (appdata_full v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex); 
                o.screenPos = o.pos;
                #if UNITY_UV_STARTS_AT_TOP
                float scale = -1.0;
                #else
                float scale = 1.0;
                #endif
                o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
                o.uvgrab.zw = o.pos.zw;
                o.uv = v.texcoord.xy;
                
                return o;
            }
            
            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize; 
			half _BlurDist;

            half4 frag( v2f i ) : COLOR
            {
            	float blurSize = 0.0025f * _BlurDist;
            	half4 sum = half4(0.0h,0.0h,0.0h,0.0h);   
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-5.0,+5.0,0,0) * blurSize)) * 0.025;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+5.0,-5.0,0,0) * blurSize)) * 0.025;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-4.0,+4.0,0,0) * blurSize)) * 0.05;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+4.0,-4.0,0,0) * blurSize)) * 0.05;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-3.0,+3.0,0,0) * blurSize)) * 0.09;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+3.0,-3.0,0,0) * blurSize)) * 0.09;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-2.0,+2.0,0,0) * blurSize)) * 0.12;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+2.0,-2.0,0,0) * blurSize)) * 0.12;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-1.0,+1.0,0,0) * blurSize)) * 0.15;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+1.0,-1.0,0,0) * blurSize)) * 0.15;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-5.0,-5.0,0,0) * blurSize)) * 0.025;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+5.0,+5.0,0,0) * blurSize)) * 0.025;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-4.0,-4.0,0,0) * blurSize)) * 0.05;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+4.0,+4.0,0,0) * blurSize)) * 0.05;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-3.0,-3.0,0,0) * blurSize)) * 0.09;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+3.0,+3.0,0,0) * blurSize)) * 0.09;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-2.0,-2.0,0,0) * blurSize)) * 0.12;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+2.0,+2.0,0,0) * blurSize)) * 0.12;
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(-1.0,-1.0,0,0) * blurSize)) * 0.15;
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab + float4(+1.0,+1.0,0,0) * blurSize)) * 0.15;
            	
            	
            	sum += tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab)) * 0.26;
			       
				return sum/2;
            }
            
            ENDCG
        }   
        
                          
                                                              
                             
                                          
// ----------------------------- FINAL PASS ----------------------------- //       
        
        GrabPass {
            Name "ShadowGrab"
        }
              
        Pass
        {
            //Blend One One
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            #pragma multi_compile_fwdadd_fullshadows
            // shadow helper functions and macros
            #include "AutoLight.cginc"            

            sampler2D _BlotchTex;
			sampler2D _DetailTex;
			sampler2D _PaperTex;
			sampler2D _RampTex;
			
            float4 _BlotchTex_ST;
			float4 _DetailTex_ST;
			float4 _PaperTex_ST;
			//float4 _RampTex_ST;
			half _Glossiness;
			half _Metallic;
			half _BlotchMulti;
			half _BlotchSub;
			half _TintScale;
			half _PaperStrength;
			fixed4 _Color;
			fixed4 _Color2;
			fixed4 _InkCol;
			

            struct v2f
            {                
                float4 pos : SV_POSITION;
                float4 uvgrab : TEXCOORD1;
				float2 uv_BlotchTex : TEXCOORD2;
				float2 uv_DetailTex : TEXCOORD3;
				float2 uv_PaperTex : TEXCOORD4;
            };
            
            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv_BlotchTex = TRANSFORM_TEX(v.texcoord, _BlotchTex);
                o.uv_DetailTex = TRANSFORM_TEX(v.texcoord, _DetailTex);
                o.uv_PaperTex = TRANSFORM_TEX(v.texcoord, _PaperTex); 
                #if UNITY_UV_STARTS_AT_TOP
                float scale = -1.0;
                #else
                float scale = 1.0;
                #endif
                o.uvgrab.xy = (float2(o.pos.x, o.pos.y * scale) + o.pos.w) * 0.5;
                o.uvgrab.zw = o.pos.zw;               
                return o;
            }
            
            sampler2D _GrabTexture;
            float4 _GrabTexture_TexelSize; 
			
			fixed4 screen (fixed4 colA, fixed4 colB)
			{
				fixed4 white = (1,1,1,1);
				return white - (white-colA) * (white-colB);
			}
			fixed4 softlight (fixed4 colA, fixed4 colB)
			{
				fixed4 white = (1,1,1,1);
				return (white-2*colB)*pow(colA, 2) + 2*colB*colA;
			}
			fixed4 multiply (fixed4 colA, fixed4 colB)
			{
				return colB*colA;
			}

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col; 
                
                fixed c = 0.5f*(tex2D (_DetailTex, i.uv_DetailTex).r + tex2D (_BlotchTex, i.uv_BlotchTex).r);	
                
                fixed3 lighting = 1.0f - tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
                c += (lighting-_BlotchSub)*_BlotchMulti;                
				
				//return c;				
				c = tex2D (_RampTex, half2(c, 0)).r;
				c = saturate(c);
				
				fixed4 tint = tex2D (_BlotchTex, i.uv_BlotchTex / _TintScale);	
				tint = lerp(_Color, _Color2, tint.r);
				
				fixed4 ink = screen(_InkCol, fixed4(c,c,c,1) );
				//return ink*tint;
				col = lerp(ink * tint, softlight(tex2D (_PaperTex, i.uv_PaperTex), ink * tint), _PaperStrength);
                
               
                
                return col;
            }
            ENDCG
        }          
        
        
    } //SubShader
    
    FallBack "Diffuse" //note: for passes: ForwardBase, ShadowCaster, ShadowCollector
}

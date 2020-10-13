#include "HLSLSupport.cginc"
#include "UnityCG.cginc"
#include "TerrainEngine.cginc"


sampler2D _MainTex;
fixed _Cutoff;

#include "Assets/VacuumShaders/Advanced Dissolve/Shaders/cginc/AdvancedDissolve.cginc"


 
float _Occlusion, _AO, _BaseLight;
fixed4 _Color;

#ifdef USE_CUSTOM_LIGHT_DIR
CBUFFER_START(UnityTerrainImposter)
    float3 _TerrainTreeLightDirections[4];
    float4 _TerrainTreeLightColors[4];
CBUFFER_END
#endif

CBUFFER_START(UnityPerCamera2)
// float4x4 _CameraToWorld;
CBUFFER_END

float _HalfOverCutoff;

struct v2f {
    float4 pos : SV_POSITION;
    float4 uv : TEXCOORD0;
    half4 color : TEXCOORD1;
    UNITY_FOG_COORDS(2)
    UNITY_VERTEX_OUTPUT_STEREO


	float3 worldPos : TEXCOORD3;
#ifdef _DISSOLVEMAPPINGTYPE_TRIPLANAR
	half3 objNormal : TEXCOORD4;
	float3 coords : TEXCOORD5;
#else
	float4 dissolveUV : TEXCOORD4;
#endif
};

v2f leaves(appdata_full v)
{
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    TerrainAnimateTree(v.vertex, v.color.w);

    float3 viewpos = UnityObjectToViewPos(v.vertex);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord;

    float4 lightDir = 0;
    float4 lightColor = 0;
    lightDir.w = _AO;

    float4 light = UNITY_LIGHTMODEL_AMBIENT;

    for (int i = 0; i < 4; i++) {
        float atten = 1.0;
        #ifdef USE_CUSTOM_LIGHT_DIR
            lightDir.xyz = _TerrainTreeLightDirections[i];
            lightColor = _TerrainTreeLightColors[i];
        #else
                float3 toLight = unity_LightPosition[i].xyz - viewpos.xyz * unity_LightPosition[i].w;
                toLight.z *= -1.0;
                lightDir.xyz = mul( (float3x3)unity_CameraToWorld, normalize(toLight) );
                float lengthSq = dot(toLight, toLight);
                atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[i].z);

                lightColor.rgb = unity_LightColor[i].rgb;
        #endif

        lightDir.xyz *= _Occlusion;
        float occ =  dot (v.tangent, lightDir);
        occ = max(0, occ);
        occ += _BaseLight;
        light += lightColor * (occ * atten);
    }

    o.color = light * _Color * _TreeInstanceColor;
    o.color.a = 0.5 * _HalfOverCutoff;

    UNITY_TRANSFER_FOG(o,o.pos);


	o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
	//VacuumShaders
#ifdef _DISSOLVEMAPPINGTYPE_TRIPLANAR
	o.coords = v.vertex;
	o.objNormal = lerp(UnityObjectToWorldNormal(v.normal), v.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
	DissolveVertex2Fragment(o.pos, v.texcoord, v.texcoord1.xy, o.dissolveUV);
#endif



    return o;
}

v2f bark(appdata_full v)
{
    v2f o;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
    TerrainAnimateTree(v.vertex, v.color.w);

    float3 viewpos = UnityObjectToViewPos(v.vertex);
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.texcoord;

    float4 lightDir = 0;
    float4 lightColor = 0;
    lightDir.w = _AO;

    float4 light = UNITY_LIGHTMODEL_AMBIENT;

    for (int i = 0; i < 4; i++) {
        float atten = 1.0;
        #ifdef USE_CUSTOM_LIGHT_DIR
            lightDir.xyz = _TerrainTreeLightDirections[i];
            lightColor = _TerrainTreeLightColors[i];
        #else
                float3 toLight = unity_LightPosition[i].xyz - viewpos.xyz * unity_LightPosition[i].w;
                toLight.z *= -1.0;
                lightDir.xyz = mul( (float3x3)unity_CameraToWorld, normalize(toLight) );
                float lengthSq = dot(toLight, toLight);
                atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[i].z);

                lightColor.rgb = unity_LightColor[i].rgb;
        #endif


        float diffuse = dot (v.normal, lightDir.xyz);
        diffuse = max(0, diffuse);
        diffuse *= _AO * v.tangent.w + _BaseLight;
        light += lightColor * (diffuse * atten);
    }

    light.a = 1;
	o.color = light *_Color * _TreeInstanceColor;

    #ifdef WRITE_ALPHA_1
    o.color.a = 1;
    #endif



	o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
	//VacuumShaders
#ifdef _DISSOLVEMAPPINGTYPE_TRIPLANAR
	o.coords = v.vertex;
	o.objNormal = lerp(UnityObjectToWorldNormal(v.normal), v.normal, VALUE_TRIPLANARMAPPINGSPACE);
#else
	float4 oPos = 0;
	#ifdef _DISSOLVEMAPPINGTYPE_SCREEN_SPACE
		oPos = UnityObjectToClipPos(v.vertex)
	#endif
	DissolveVertex2Fragment(oPos, v.texcoord, v.texcoord1.xy, o.dissolveUV);
#endif

    UNITY_TRANSFER_FOG(o,o.pos);
    return o;
}

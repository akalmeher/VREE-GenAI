Shader "Ciconia Studio/CS_Standard/Builtin/Standard (Specular setup)/Cutout"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB) Alpha (A)", 2D) = "white" {}
        _SpecGlossMap ("Specular (RGB) Gloss (A)", 2D) = "white" {}
        _BumpMap ("Normal Map", 2D) = "bump" {}
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "RenderType"="TransparentCutout" }
        LOD 200

        CGPROGRAM
        #pragma surface surf StandardSpecular alpha:clip fullforwardshadows

        sampler2D _MainTex;
        sampler2D _SpecGlossMap;
        sampler2D _BumpMap;
        fixed4 _Color;
        float _Cutoff;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_SpecGlossMap;
            float2 uv_BumpMap;
        };

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 albedoTex = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = albedoTex.rgb * _Color.rgb;
            o.Alpha = albedoTex.a * _Color.a;

            // ✅ GLES3-safe alpha clipping
            clip(o.Alpha - _Cutoff);

            fixed4 specTex = tex2D(_SpecGlossMap, IN.uv_SpecGlossMap);
            o.Specular = specTex.rgb;
            o.Smoothness = specTex.a;

            fixed4 bumpTex = tex2D(_BumpMap, IN.uv_BumpMap);
            o.Normal = UnpackNormal(bumpTex);
        }
        ENDCG
    }

    FallBack "Diffuse"
}

Shader "Custom/ToonRamp"
{
    Properties
    {
        _ToonRampTex ("Toon Ramp Texture", 2D) = "white"{}
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("MainTexture", 2D) = "white"{}
    }

    SubShader
    {
        CGPROGRAM
        #pragma surface surf ToonRamp

        float4 _Color;
        sampler2D _ToonRampTex;

        float4 LightingToonRamp(SurfaceOutput  s, fixed3 lightDir, fixed atten)
        {
            float diff = dot(s.Normal, lightDir);
            float h = diff * 0.5 + 0.5;

            float2 rh = float2(h, .5);
            float3 ramp = tex2D(_ToonRampTex, rh).rgb;

            float4 c;
            c.rgb = s.Albedo * _LightColor0.rgb * (ramp);
            c.a = s.Alpha;
            return c;
        }

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        void surf(Input IN, inout SurfaceOutput  o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
        }
        ENDCG
    }

    FallBack "Diffuse"
}
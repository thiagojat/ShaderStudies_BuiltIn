Shader "Custom/OutlineShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _OutlineWidth ("Outline Width", Range(0, 0.1)) = 0.05
        _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM

        #pragma surface surf Standard fullforwardshadows

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG

        Pass
        {
            Cull Front

            CGPROGRAM

            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram

            half _OutlineWidth;

            float4 VertexProgram(float4 position : POSITION, float3 normal : NORMAL) : SV_POSITION
            {
                float4 clipPosition = UnityObjectToClipPos(position);
                float3 clipNormal = mul((float3x3)UNITY_MATRIX_VP, mul((float3x3) UNITY_MATRIX_M, normal));

                clipPosition.xyz += normalize(clipNormal) * _OutlineWidth;

                return clipPosition;
            }

            half4 _OutlineColor;

            half4 FragmentProgram() : SV_TARGET
            {
                return _OutlineColor;
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}

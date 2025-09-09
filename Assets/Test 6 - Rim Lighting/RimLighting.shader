Shader "Unlit/RimLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _RimColor ("Rim Color", Color) = (1, 1, 1, 1)
        _RimIntensity ("Rim Intensity", Range(0, 1)) = 0
        _RimPower ("Rim Power", Range(0, 5)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;

                float3 worldNormal : TEXCOORD1;
                float3 viewDirection : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _RimColor;
            float _RimIntensity;
            float _RimPower;

            v2f vert (appdata v)
            {
                v2f output;
                output.vertex = UnityObjectToClipPos(v.vertex);
                output.uv = TRANSFORM_TEX(v.uv, _MainTex);

                output.worldNormal = UnityObjectToWorldNormal(v.normal);
                output.viewDirection = WorldSpaceViewDir(v.vertex);
                return output;
            }

            float4 rimLight(float4 color, float3 normal, float3 viewDirection)
            {
                float NdotV = 1 - dot(normal, viewDirection);
                NdotV = pow(NdotV, 1/_RimPower);
                NdotV *= _RimIntensity;

                float4 finalColor = lerp(color, _RimColor, NdotV);
                 
                return finalColor;
        }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                i.worldNormal = normalize(i.worldNormal);
                i.viewDirection = normalize(i.viewDirection);

                return rimLight(col, i.worldNormal, i.viewDirection);
            }
            ENDCG
        }
    }
}

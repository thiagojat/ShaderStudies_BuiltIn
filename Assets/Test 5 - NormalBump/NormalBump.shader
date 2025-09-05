Shader "Custom/Diffuse Bump"
{
    Properties
    {
      _MainTex ("Texture", 2D) = "white" {}
      _Tint ("Tint", Color) = (1,1,1,0)
      _BumpMap ("Bumpmap", 2D) = "bump" {}
      _BumpMultiplier ("BumpMulti", Range(0,5)) = 1
    }

    SubShader 
    {
        Tags { "RenderType" = "Opaque" }
        CGPROGRAM
      
        #pragma surface surf Lambert
      
        struct Input 
        {
            float2 uv_MainTex;
            float2 uv_BumpMap;
        };
      
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _BumpMultiplier;
        float4 _Tint;

        void surf (Input IN, inout SurfaceOutput o) 
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Tint;
            o.Albedo = c.rgb;
            half3 normalFromMap = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
            o.Normal = lerp(half3(0.0, 0.0, 1.0), normalFromMap, _BumpMultiplier);
        }

        ENDCG
    } 

    Fallback "Diffuse"
  }
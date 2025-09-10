Shader "Unlit/ExtrudeShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Frequency ("Frequency",Range(0,10)) = 0
        _Speed ("Speed", Range(0,10)) = 0
        _Amount("Amount", Range(0,5)) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        Cull Off // This line disables back-face culling

        CGPROGRAM
        #pragma surface surf Lambert vertex:vert
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 vertColor;
        };

        float _Frequency;
        float _Speed;
        float _Amount;

        void vert (inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);	// compiler was throwing an error without this!
												// "output parameter 'o' not completely initialized (on d3d11)"
			
            float time = _Time.y * _Speed * _Frequency;

			v.vertex.xyz += v.normal * _Amount * sin(time);
		}

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
            ENDCG
    }
    }

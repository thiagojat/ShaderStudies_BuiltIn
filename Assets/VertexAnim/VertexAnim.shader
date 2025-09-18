Shader "Unlit/VertexAnim"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", Range(0,10)) = 0
        _Amount("Amount", Range(0,5)) = 0
        _Offset("Offset", float) = 1
        _Alpha("Alpha", Range(0, 1)) = 1
    }

    SubShader
    {
        Tags {"Queue" = "Transparent" "RenderType"="Transparent" }
        LOD 200

        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha 
        //Cull Off // This line disables back-face culling

        CGPROGRAM

        //#pragma surface surf Lambert vertex:vert
        #pragma surface surf Lambert fullforwardshadows addshadow vertex:vert alpha
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float3 vertColor;
        };

        float getVertexLerpValue(float ver)
        {
           return (ver + 1) /2;
        }

        float _Speed;
        float _Amount;
        float _Offset;

        void vert (inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);	// compiler was throwing an error without this!
												// "output parameter 'o' not completely initialized (on d3d11)"
			
            float time = _Time.y * _Speed;
			v.vertex.x += _Amount * lerp(sin(time), sin(time+_Offset), getVertexLerpValue(v.vertex.y));
		}

        float _Alpha;
		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			o.Albedo = c.rgb;
			o.Alpha = _Alpha;
		}
            ENDCG
    }
    }

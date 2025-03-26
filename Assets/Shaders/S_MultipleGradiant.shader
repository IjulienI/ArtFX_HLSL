Shader "Custom/MutlipleGradient"
{    
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white"{}
        _SecondTex ("Texture", 2D) = "white"{}
    }
    
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }       

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            uniform half4 _Color;
            uniform sampler2D _MainTex;
            uniform sampler2D _SecondTex;
            uniform float4 _MainTex_ST;
            

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 pos : SV_POSITION;
                float4 texcoord : TEXCOORD0;
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.pos = UnityObjectToClipPos(v.vertex);                
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            half4 frag (VertexOutput i) : COLOR
            {              
                float4 color = tex2D(_MainTex, i.texcoord);
                float4 secondColor = tex2D(_SecondTex,i.texcoord);               
                return color * (i.texcoord.x) + secondColor * (1 - i.texcoord.x); 
            }
            ENDCG
        }
    }
}

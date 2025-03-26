Shader "Custom/Flag"
{    
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white"{}
        _Speed ("Speed", Float) = 0.5
        _Frequency ("Frequency", Float) = 0.5
        _Amplitude ("Amplitude", Float) = 0.5
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
            uniform float4 _MainTex_ST;
            uniform float _Speed;
            uniform float _Frequency;
            uniform float _Amplitude;

            float4 vertexAnimFlag(float4 pos, float2 uv)
            {
                pos.z = pos.z + sin((uv.x - _Time.y * _Speed) * _Frequency) * _Amplitude;
                return pos;
            }            

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
                v.vertex = vertexAnimFlag(v.vertex, v.texcoord.xy);
                o.pos = UnityObjectToClipPos(v.vertex);       
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);                
                return o;
            }

            half4 frag (VertexOutput i) : COLOR
            {              
                float4 color = tex2D(_MainTex, i.texcoord) * _Color;
                //color.a = i.texcoord.x;
                return color;
            }
            ENDCG
        }
    }
}

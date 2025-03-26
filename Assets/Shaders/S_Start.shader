Shader "Unlit/Start"
{    
    Properties
    {
        _Color("Color", Color) = (1, 0, 0, 1)
        _Texture("Texture",2D)="white"
    }
    
    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "RenderType"="Transparent"
            "IgnoreProjector"="True"
        }
        
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            fixed4 _Color;
            uniform sampler2D _Texture;
            uniform float4 _Texture_ST;
            

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float4 texcoord : TEXCOORD;
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);                
                o.texcoord.xy = (v.texcoord.xy * _Texture_ST.xy + _Texture_ST.zw);
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {              
                return tex2D(_Texture, i.texcoord) *_Color;
            }
            ENDCG
        }
    }
}

Shader "WindWaker/Grass"
{    
    Properties
    {
        _Color ("Color", Color) = (1, 0, 0, 1)
        _TextureMask ("TextureMask",2D) = "white"
        _Albedo ("Texture", 2D) = "white"
        
        _WindNoise ("WindNoise", 2D) = "white"
        _WindSpeed ("WindSpeed", Float) = 1.0
        _WindForce ("WindForce", Float) = 1.0
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
            
            uniform sampler2D _TextureMask;
            uniform float4 _TextureMask_ST;
            uniform sampler2D _Albedo;
            uniform float4 _Albedo_ST;

            uniform sampler2D _WindNoise;
            uniform float4 _WindNoise_ST;

            uniform float _WindSpeed;
            uniform float _WindForce;
            

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
                float4 uv : TEXCOORD1;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float4 texcoord : TEXCOORD0;
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.texcoord.xy = (v.texcoord.xy * _TextureMask_ST.xy + _TextureMask_ST.zw);
                v.vertex += tex2Dlod(_WindNoise, ((_WindNoise_ST - (_Time.x * _WindSpeed)) * _WindForce) * o.texcoord.x);
                v.vertex.y *= v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
                float mask = tex2D(_TextureMask, i.texcoord);
                float4 albedo = tex2D(_Albedo, i.texcoord) * _Color;
                
                return albedo * mask;
            }
            ENDCG
        }
    }
}

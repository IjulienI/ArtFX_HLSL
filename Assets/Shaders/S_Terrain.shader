Shader "Custom/Terrain"
{    
    Properties
    {
        _FirstColor ("FirstColor", Color) = (1, 1, 1, 1)
        _SecondColor ("SecondColor", Color) = (1, 1, 1, 1)
        _MainTex ("Texture", 2D) = "white"{}
        _DisplacementStrengh ("DisplacementStrengh", Float) = 0.1
    }
    
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
            "TerrainCompatible" = "True"
        }       

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            uniform half4 _FirstColor;
            uniform half4 _SecondColor;
            uniform sampler2D _MainTex;
            uniform float4 _MainTex_ST;
            uniform float _DisplacementStrengh;
            

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 normal: NORMAL;
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
                float displacement = tex2Dlod(_MainTex, v.texcoord * _MainTex_ST);
                o.pos = UnityObjectToClipPos(v.vertex + (v.normal * displacement * _DisplacementStrengh));                
                o.texcoord.xy = (v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
                return o;
            }

            half4 frag (VertexOutput i) : COLOR
            {              
                float4 color = tex2D(_MainTex, i.texcoord);
                return _FirstColor * color.r + _SecondColor * (1 - color.r); 
            }
            ENDCG
        }
    }
}

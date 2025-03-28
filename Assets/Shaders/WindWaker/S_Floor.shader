Shader "WindWaker/Floor"
{    
    Properties
    {
        _FloorAlbedo ("Floor Albedo", 2D) = "white" {}
        _TransitionAlbedo ("Transition Albedo", 2D) = "white" {}
        _WallAlbedo ("Wall Albedo", 2D) = "white" {}
        _FloorSensitivity ("Floor Sensitivity", Range(0.05,0.95)) = 0.5
        _TransitionSensitivity ("Transition Sensitivity", Range(0.05,0.95)) = 0.5
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

            uniform sampler2D _FloorAlbedo;
            uniform float4 _FloorAlbedo_ST;
            uniform sampler2D _WallAlbedo;
            uniform float4 _WallAlbedo_ST;

            uniform  sampler2D _TransitionAlbedo;
            uniform  float4 _TransitionAlbedo_ST;

            uniform float _FloorSensitivity;
            uniform float _TransitionSensitivity;
            

            struct VertexInput
            {
                float4 vertex : POSITION;                
                float4 texcoord : TEXCOORD0;
                float4 transition : TEXCOORD1;
                float4 wall : TEXCOORD2;
                float4 normal : NORMAL;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float4 texcoord : TEXCOORD0;
                float4 transition : TEXCOORD1;
                float4 wall : TEXCOORD2;
                float4 normal : NORMAL;
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);                
                o.texcoord.xy = (v.texcoord.xy * _FloorAlbedo_ST.xy + _FloorAlbedo_ST.zw);
                o.transition.xy = (v.texcoord.xy * _TransitionAlbedo_ST.xy + _TransitionAlbedo_ST.zw);
                o.wall.xy = (v.texcoord.xy * _WallAlbedo_ST.xy + _WallAlbedo_ST.zw);
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (VertexOutput i) : SV_Target
            {
                bool bFloor = i.normal.z > _FloorSensitivity;
                if(bFloor)
                {
                    return tex2D(_FloorAlbedo, i.texcoord);
                }                
                bool bTransition = i.normal.z > _TransitionSensitivity;
                if(bTransition)
                {                    
                    return tex2D(_TransitionAlbedo, i.transition);
                }
                return tex2D(_WallAlbedo, i.wall);  
            }
            ENDCG
        }
    }
}

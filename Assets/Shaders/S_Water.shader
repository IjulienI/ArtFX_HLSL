Shader "Custom/Water"
{    
    Properties
    {
        _ShallowColor ("ShallowColor", Color) = (0.325, 0.807, 0.971, 0.725)
        _DeepColor ("DeepColor", Color) = (0.086, 0.407, 1, 0.749)
        _DepthMaxDistance ("Depth Maximum Distance", Float) = 1
        _NoiseTex ("Noise", 2D) = "white" {}
        _SurfaceNoiseCutoff ("Surface Noise Cutoff", Range(0, 1)) = 0.777
        _FoamDistance ("FoamDistance", Float) = 1.0
        _Speed ("FoamSpeed", Range(0, 2)) = 1.0
        _Trajectoire ("FoamTrajectory", Vector) = (0.5,0.5,0,0)
    }
    
    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }
        LOD 100
        
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            uniform float4 _ShallowColor;
            uniform float4 _DeepColor;
            
            uniform sampler2D _NoiseTex;
            uniform float4 _NoiseTex_ST;

            uniform float _FoamDistance;
            uniform float _Speed;
            uniform float4 _Trajectoire;
            

            uniform float _SurfaceNoiseCutoff;

            uniform float _DepthMaxDistance;

            uniform sampler2D _CameraDepthTexture;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float4 screenPosition : TEXCOORD2;
                float2 noiseUV : TEXCOORD0;
            }; 

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;                
                v.uv = v.uv + (_Time * _Speed) * _Trajectoire;               
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPosition = ComputeScreenPos(o.vertex);
                o.noiseUV = TRANSFORM_TEX(v.uv, _NoiseTex);
                return o;
            }

            half4 frag (VertexOutput i) : SV_Target
            {
                float existingDepth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPosition)).r;
                float existingDepthLinear = LinearEyeDepth(existingDepth01);
                float depthDifference = existingDepthLinear - i.screenPosition.w;
                
                float waterDepthDifference01 = saturate(depthDifference / _DepthMaxDistance);
                float4 waterColor = lerp(_ShallowColor, _DeepColor, waterDepthDifference01);

                float formDepthDifference01 = saturate(depthDifference / _FoamDistance);
                float surfaceNoiseCutoff = formDepthDifference01 * _SurfaceNoiseCutoff;

                float surfaceNoise = tex2D(_NoiseTex, i.noiseUV) > surfaceNoiseCutoff ? 1 : 0;
                return waterColor + surfaceNoise;
            }
            ENDCG
        }
    }
}

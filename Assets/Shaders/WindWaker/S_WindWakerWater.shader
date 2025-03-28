Shader "WindWaker/Water"
{    
    Properties
    {
        _ShallowColor ("Shallow Color", Color) = (0.325, 0.807, 0.971, 1)
        _DeepColor ("Deep Color", Color) = (0.086, 0.407, 1, 1)
        _DarkShallowColor ("Dark Shallow Color", Color) = (0.086, 0.407, 1, 1)
        _DepthMaxDistance ("Depth Maximum Distance", Float) = 1
        _WaterPattern ("Water Pattern", 2D) = "white" {}
        _FlowTex ("Flow", 2D) = "white" {}
        _FlowStengh ("Flow Strengh", Float) = 1.0
        _FlowSpeed ("Flow Speed", Float) = 1.0
        
        _WaveNoise ("Wave Noise", 2D) = "white" {}
        _WaveSpeed ("Wave Speed", Float) = 1.0
        _WaveStrengh ("Wave Strengh", Float) = 1
        _WaveTrajectory ("Wave Trajectory", Vector) = (0.5,0.5,0,0)
        
        _FoamTex ("Foam", 2D) = "white" {}
        _SurfaceNoiseCutoff ("Surface Noise Cutoff", Range(0, 1)) = 0.777
        _FoamDistance ("Foam Distance", Float) = 1.0
        _Speed ("Foam Speed", Range(0, 2)) = 1.0
        _Trajectoire ("Foam Trajectory", Vector) = (0.5,0.5,0,0)
        _WaveFrequency ("Wave Frequency", Float) = 1.0
        _WaveAmplitude ("Wave Amplitude", Float) = 1.0
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
            uniform float4 _DarkShallowColor;
            
            uniform sampler2D _WaterPattern;
            uniform float4 _WaterPattern_ST;

            uniform sampler2D _FlowTex;
            uniform float4 _FlowTex_ST;
            uniform float _FlowStengh;
            uniform float _FlowSpeed;

            uniform sampler2D _WaveNoise;
            uniform float4 _WaveNoise_ST;
            uniform  float _WaveSpeed;
            uniform float _WaveStrengh;
            uniform float4 _WaveTrajectory;

            uniform sampler2D _FoamTex;
            uniform float4 _FoamTex_ST;

            uniform float _FoamDistance;
            uniform float _Speed;
            uniform float4 _Trajectoire;

            uniform float _WaveFrequency;
            uniform float _WaveAmplitude;
            

            uniform float _SurfaceNoiseCutoff;

            uniform float _DepthMaxDistance;

            uniform sampler2D _CameraDepthTexture;

            struct VertexInput
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                float4 flowUV : TEXCOORD1;
                float4 waterUV : TEXCOORD3;
                float4 waterNoise : TEXCOORD5;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float4 screenPosition : TEXCOORD2;
                float2 noiseUV : TEXCOORD0;
                float2 waterUV : TEXCOORD3;
                float2 flowUV : TEXCOORD1;
                float2 darkWaterUV : TEXCOORD4;
            };

            float4 WaveAnimation(float4 pos, float2 uv)
            {
                pos.y = pos.y + cos((uv.x - _Time.y * _Speed) * _WaveFrequency) * _WaveAmplitude;
                return pos;
            }  

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;                
                v.uv = v.uv + (_Time * _Speed) * _Trajectoire;
                v.flowUV = v.flowUV + (_Time * _Speed) * _Trajectoire;
                v.waterUV = v.flowUV;
                v.waterNoise = v.waterNoise + (_Time.x * _WaveSpeed) * _WaveTrajectory;
                v.vertex.y += tex2Dlod(_WaveNoise, v.waterNoise) * _WaveStrengh;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPosition = ComputeScreenPos(o.vertex);                
                o.noiseUV = TRANSFORM_TEX(v.uv, _FoamTex);
                o.waterUV = o.noiseUV;
                o.flowUV = TRANSFORM_TEX(v.flowUV, _FlowTex);
                o.darkWaterUV = o.waterUV + float2(0.2, 0.2);
                return o;
            }

            half4 frag (VertexOutput i) : SV_Target
            {
                float existingDepth01 = tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPosition)).r;
                float existingDepthLinear = LinearEyeDepth(existingDepth01);
                float depthDifference = existingDepthLinear - i.screenPosition.w;
                
                float waterDepthDifference01 = saturate(depthDifference / _DepthMaxDistance);
                float4 waterColor = lerp(_ShallowColor, 0, waterDepthDifference01);

                float formDepthDifference01 = saturate(depthDifference / _FoamDistance);
                float surfaceNoiseCutoff = formDepthDifference01 * _SurfaceNoiseCutoff;                

                float waterFlow = tex2D(_FlowTex, i.flowUV);
                float water = tex2D(_WaterPattern, i.waterUV + (waterFlow + _Time * _FlowSpeed) * _FlowStengh );
                float foam = tex2D(_FoamTex, i.flowUV) > surfaceNoiseCutoff ? 1 : 0;
                float darkWater = tex2D(_WaterPattern, i.darkWaterUV + (waterFlow + _Time * _FlowSpeed) * _FlowStengh );
                float4 darkWaterColor = lerp(_DeepColor, _DarkShallowColor, darkWater);
                
                return water + darkWaterColor + foam + waterColor;
            }
            ENDCG
        }
    }
}
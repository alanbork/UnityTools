// updated https://assetstore.unity.com/packages/tools/particles-effects/quick-outline-115488 to support URP
Shader "Universal Render Pipeline/Custom/OutlineMask"
{
    Properties
    {
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent+100"
            "DisableBatching" = "True"
        }

        Pass
        {
            Name "OutlineMask"
            Tags { "LightMode" = "UniversalForward" }

            Cull Off
            ZTest [_ZTest]
            ZWrite Off
            ColorMask 0

            Stencil
            {
                Ref 1
                Pass Replace
            }

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);

                float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                float4 positionHCS = TransformWorldToHClip(positionWS);

                OUT.positionHCS = positionHCS;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return 0; // Not used due to ColorMask 0
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
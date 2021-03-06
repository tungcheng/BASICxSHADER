﻿Shader "BASICxSHADER/Texturing/Refraction" {
  Properties {
    _CubeMap ("CubeMap", Cube) = "" {}
    _Refractive ("Refractive", Range(0, 1)) = 0.5
  }
  SubShader {
    Pass {
      Tags { "LightMode" = "ForwardBase" }

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag

      // Properties
      uniform samplerCUBE _CubeMap;
      uniform half        _Refractive;

      // Vertex Input
      struct appdata {
        float4 vertex : POSITION;
        float3 normal : NORMAL;
      };

      // Vertex to Fragment
      struct v2f {
        float4 pos      : SV_POSITION;
        float3 normal   : NORMAL;
        float4 posWorld : TEXCOORD0;
      };

      //------------------------------------------------------------------------
      // Vertex Shader
      //------------------------------------------------------------------------
      v2f vert(appdata v) {
        v2f o;
        o.pos      = UnityObjectToClipPos(v.vertex);
        o.normal   = normalize(mul(v.normal, unity_WorldToObject).xyz);
        o.posWorld = mul(unity_ObjectToWorld, v.vertex);
        return o;
      }

      //------------------------------------------------------------------------
      // Fragment Shader
      //------------------------------------------------------------------------
      fixed4 frag(v2f i) : SV_Target {
        // Vector
        half3 normal  = normalize(i.normal);
        half3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.posWorld);

        // Refraction
        fixed4 color = texCUBE(_CubeMap, refract(-viewDir, normal, _Refractive));

        return color;
      }
      ENDCG
    }
  }
}

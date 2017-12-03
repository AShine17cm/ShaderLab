using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Mg.Tut
{
    public class BatchCasters : MonoBehaviour
    {
        const int maxCount = 32000;
        static BatchCasters One;
        public static int casterIdx = -1;
        public Material mat;
        public float frequence = 0.05f, sqrDist = 0.5f;
        StaticCasters staticCaster, dynamicCaster;
        // Use this for initialization
        void Awake()
        {
            One = this;
            casterIdx = -1;
            staticCaster = new StaticCasters(gameObject, mat);
            dynamicCaster = new DynamicCasters(gameObject, mat);
            (dynamicCaster as DynamicCasters).SetVault(frequence, sqrDist);
        }

        // Update is called once per frame
        private void Update()
        {
            staticCaster.Update();
            dynamicCaster.Update();
        }
        public static void AddCaster(CasterItem caster)
        {
            if (One == null) return;
            if (caster.kind == CasterKind.dynamicCaster)
            {
                One.dynamicCaster.AddCaster(caster);
            }
            else if (caster.kind == CasterKind.staticCaster)
            {
                One.staticCaster.AddCaster(caster);
            }
        }
        public static void RemoveCaster(CasterItem caster)
        {
            if (One == null) return;
            if (caster.kind == CasterKind.dynamicCaster)
            {
                One.dynamicCaster.RemoveCaster(caster);
            }
            else if (caster.kind == CasterKind.staticCaster)
            {
                One.staticCaster.RemoveCaster(caster);
            }

        }
        private void OnDestroy()
        {
            staticCaster.OnDestroy();
            dynamicCaster.OnDestroy();
            One = null;
        }
    }
}

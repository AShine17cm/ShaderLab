using System;
using System.Collections.Generic;
using UnityEngine;
namespace Mg.Tut
{
    public class CasterItem : MonoBehaviour
    {
        public MeshFilter caster;
        public CasterKind kind = CasterKind.none;
        [NonSerialized]
        public Transform tr;
        [NonSerialized]
        public Mesh mesh;
        [NonSerialized]
        public int idx;
        // Use this for initialization
        void Start()
        {
            tr = caster.transform;
            mesh = caster.sharedMesh;
            caster.gameObject.SetActive(false);
            BatchCasters.casterIdx += 1;
            this.idx = BatchCasters.casterIdx;
        }
        private void OnBecameInvisible()
        {
            BatchCasters.RemoveCaster(this);
            //Debug.Log("Invisible");
        }
        private void OnBecameVisible()
        {
            BatchCasters.AddCaster(this);
            //Debug.Log("Visible");
        }
    }
    public enum CasterKind
    {
        none = 0,
        dynamicCaster = 1,
        staticCaster = 2,
        //actor=3,
    }
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Mg.Tut
{
    public class DynamicCasters : StaticCasters
    {
        float frequence = 0.1f, sqrDist = 1f;
        float nextTime;
        Dictionary<int, Vector3> lastPoses = new Dictionary<int, Vector3>(100);
        public DynamicCasters(GameObject bacther, Material mat) : base(bacther, mat)
        {

        }
        public void SetVault(float freq, float sqrDist)
        {
            this.frequence = freq;
            this.sqrDist = sqrDist;
        }
        // Use this for initialization
        void Start()
        {

        }

        public override void Update()
        {
            if (isActive && Time.time > nextTime)
            {
                nextTime = Time.time + frequence;
                foreach (CasterItem temp in casters)
                {
                    if ((temp.tr.position - lastPoses[temp.idx]).sqrMagnitude > sqrDist)
                    {
                        lastPoses[temp.idx] = temp.tr.position;
                        RefreshCaster(temp);
                        this.dirty = true;
                    }
                }
            }
            base.Update();
        }
        void RefreshCaster(CasterItem caster)
        {
            int count = caster.mesh.vertexCount;
            Transform tr = caster.tr;
            Vector3[] vertex = caster.mesh.vertices;
            Vector3[] newVertex = wldVertex[caster.idx];
            for (int i = 0; i < count; i++)
            {
                newVertex[i] = tr.localToWorldMatrix.MultiplyPoint3x4(vertex[i]);
            }
        }
        protected override void TransformCaster(CasterItem caster)
        {
            base.TransformCaster(caster);
            lastPoses.Add(caster.idx, caster.tr.position);
        }
        //public override void AddCaster(CasterItem caster)
        //{
        //    base.AddCaster(caster);
        //}
        public override void RemoveCaster(CasterItem caster)
        {
            base.RemoveCaster(caster);
            if (lastPoses.ContainsKey(caster.idx))
            {
                lastPoses.Remove(caster.idx);
            }
        }
        public override void SetActive(bool isActive)
        {
            if (this.isActive == isActive) return;
            this.isActive = isActive;
            caster.SetActive(isActive);
            if (isActive)
            {
                dirty = true;
                nextTime = -1f;
            }
            else
            {
            }
        }
    }
}

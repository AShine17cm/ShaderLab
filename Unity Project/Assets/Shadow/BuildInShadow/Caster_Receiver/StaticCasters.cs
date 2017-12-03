using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace Mg.Tut
{
    public class StaticCasters
    {
        const int maxCount = 32000;
        protected GameObject caster;
        Mesh mesh;

        protected bool isActive = true;
        protected bool dirty = false;
        protected List<CasterItem> casters = new List<CasterItem>(100);
        protected Dictionary<int, Vector3[]> wldVertex = new Dictionary<int, Vector3[]>(100);
        Dictionary<int, int[]> tris = new Dictionary<int, int[]>(100);
        List<Vector3> vertices = new List<Vector3>(1000);
        List<int> triangles = new List<int>(3000);
        int[] temp;
        int count;

        public StaticCasters(GameObject bacther, Material mat)
        {
            caster = new GameObject("caster");
            caster.transform.SetParent(bacther.transform);
            caster.layer = bacther.layer;
            MeshFilter mf = caster.AddComponent<MeshFilter>();
            MeshRenderer mr = caster.AddComponent<MeshRenderer>();
            mr.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.ShadowsOnly;
            mr.material = mat;
            mesh = new Mesh();
            mf.mesh = mesh;
        }
        protected virtual void TransformCaster(CasterItem caster)
        {
            int count = caster.mesh.vertexCount;
            Transform tr = caster.tr;
            Vector3[] vertex = caster.mesh.vertices;
            Vector3[] newVertex = new Vector3[count];
            for (int i = 0; i < count; i++)
            {
                newVertex[i] = tr.localToWorldMatrix.MultiplyPoint3x4(vertex[i]);
            }
            wldVertex.Add(caster.idx, newVertex);
            tris.Add(caster.idx, caster.mesh.triangles);
        }
        public virtual void AddCaster(CasterItem caster)
        {
            if (wldVertex.ContainsKey(caster.idx))
            {
                return;
            }
            else
            {
                TransformCaster(caster);
                casters.Add(caster);
                dirty = true;
            }
        }
        public virtual void RemoveCaster(CasterItem caster)
        {
            if (wldVertex.ContainsKey(caster.idx))
            {
                wldVertex.Remove(caster.idx);
                tris.Remove(caster.idx);
                casters.Remove(caster);
                dirty = true;
            }
        }
        public virtual void Update()
        {
            if (dirty && isActive)
            {
                dirty = false;
                count = 0;
                vertices.Clear();
                triangles.Clear();
                mesh.triangles = null;
                int i;
                foreach (KeyValuePair<int, Vector3[]> kp in wldVertex)
                {
                    if (count + kp.Value.Length < maxCount)
                    {

                        vertices.AddRange(kp.Value);
                        temp = tris[kp.Key];
                        i = 0;
                        for (i = 0; i < temp.Length; i++)
                        {
                            triangles.Add(temp[i] + count);
                        }
                        count = count + kp.Value.Length;
                    }
                    else
                    {
                        break;
                    }

                }
                mesh.SetVertices(vertices);
                mesh.triangles = triangles.ToArray();
            }
        }
        public virtual void SetActive(bool isActive)
        {
            if (this.isActive == isActive) return;
            this.isActive = isActive;
            caster.SetActive(isActive);
            if (isActive)
            {
                dirty = true;

            }
            else
            {
            }
        }
        public virtual void OnDestroy()
        {
            casters.Clear();
            wldVertex.Clear();
            tris.Clear();
            vertices.Clear();
            triangles.Clear();
        }
    }//class
}

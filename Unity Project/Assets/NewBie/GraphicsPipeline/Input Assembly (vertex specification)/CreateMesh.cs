using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CreateMesh : MonoBehaviour
{
    private List<Vector3> verticies = new List<Vector3>();
    private List<int> triangles = new List<int>();
    private MeshFilter meshFilter;
    private Mesh mesh;
    // Use this for initialization
    void Start()
    {
        meshFilter = GetComponent<MeshFilter>();
        mesh = new Mesh()
        {
            name = "Test mesh"
        };
        meshFilter.mesh = mesh;
    }

    private void GenMesh()
    {
        verticies.Clear();
        triangles.Clear();

        // For simulation, we only draw a square here.
        var zeroPosition = transform.position;
        verticies.Add(zeroPosition + new Vector3(-10f, -10f, 0f));
        verticies.Add(zeroPosition + new Vector3(-10f, 10f, 0f));
        verticies.Add(zeroPosition + new Vector3(10f, 10f, 0f));
        verticies.Add(zeroPosition + new Vector3(10f, -10f, 0f));
        triangles.Add(0);
        triangles.Add(1);
        triangles.Add(2);
        triangles.Add(0);
        triangles.Add(2);
        triangles.Add(3);
        mesh.Clear();
        mesh.vertices = verticies.ToArray();
        mesh.triangles = triangles.ToArray();
        mesh.RecalculateNormals();
    }

    // Update is called once per frame
    void Update()
    {
        GenMesh();
    }
}

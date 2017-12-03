//using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class InstancedColor : MonoBehaviour
{
    [SerializeField]
    public List<GameObject> cubes;

    private void Start()
    {
        var props = new MaterialPropertyBlock();
        MeshRenderer renderer;

        foreach (GameObject obj in cubes)
        {
            float r = Random.Range(0.0f, 1.0f);
            float g = Random.Range(0.0f, 1.0f);
            float b = Random.Range(0.0f, 1.0f);
            props.SetColor("_Color", new Color(r, g, b));

            renderer = obj.GetComponent<MeshRenderer>();
            renderer.SetPropertyBlock(props);
        }
    }
}

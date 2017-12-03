using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RestrictPosition : MonoBehaviour
{
    void Update()
    {
        transform.localPosition = Vector3.zero;
    }
}

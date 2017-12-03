using UnityEngine;
[ExecuteInEditMode]
public class PlaneShadowCaster : MonoBehaviour
{
    public Transform reciever;
    void Update()
    {
        GetComponent<Renderer>().sharedMaterial.SetMatrix("_World2Ground", reciever.GetComponent<Renderer>().worldToLocalMatrix);
        GetComponent<Renderer>().sharedMaterial.SetMatrix("_Ground2World", reciever.GetComponent<Renderer>().localToWorldMatrix);
    }
}

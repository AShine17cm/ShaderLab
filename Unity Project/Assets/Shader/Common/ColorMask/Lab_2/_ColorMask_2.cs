using UnityEngine;
public class _ColorMask_2 : MonoBehaviour {
	void Start () {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
	}
}

using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CompatibleWarning : MonoBehaviour
{
    private bool CheckShaderIsSupported(Shader _shader)
    {
        if (_shader != null && _shader.isSupported)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private void OnGUI()
    {
        if (CheckShaderIsSupported(Shader.Find("Custom/Tessellation")) == false)
        {
            var guiStyle = new GUIStyle()
            {
                fontSize = 20,
            };

            GUI.Label(new Rect(0, 0, 100, 100),
                "Tessellation shader is not supported on this platform!",
                guiStyle);
        }
    }
}

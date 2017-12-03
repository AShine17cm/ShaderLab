using UnityEngine;
using System.Collections;

public class Multi_Compile : MonoBehaviour {

    public GUISkin skin;
    public Rect[] rs;

    bool flip1;
    //bool flip2;
    // Use this for initialization
    void Start () {
        flip1 = false;
        //flip2 = false;
    }
    
    // Update is called once per frame
    void Update () {
    
    }

    void OnGUI()
    {
        GUI.skin = skin;
        GUI.BeginGroup(rs[0]);
        GUI.Label(rs[1], "Enable/Disable KeyWord");
        if (GUI.Button(rs[2], "Flip key word"))
        {
            if (flip1)
            {
                Shader.EnableKeyword("MY_multi_1");
                Shader.DisableKeyword("MY_multi_2");
            }
            else
            {
                Shader.EnableKeyword("MY_multi_2");
                Shader.DisableKeyword("MY_multi_1");
            }

            flip1 = !flip1;
        }
        GUI.EndGroup();
    }
}

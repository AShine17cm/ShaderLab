using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class _GenAlphaTest : MonoBehaviour
{
    public Texture tex0;
    public Texture tex1;
    public Renderer rd1;
    public Renderer rd2;

    public Material[] bMaterials;
    public Material[] bMaterials2;
    public GUISkin skin;
    public int i1;
    public float j1;
    public Rect rStr1;
    public Rect rI1;
    public Rect rJ1;
    public Rect[] rects;
    public string[] tips;
    string[] testMode;
    string part1 =
         "Shader \"AlphaTest";
    string part2 =
         "{"
         + "Properties { _DstTex (\"DstTex\", 2D) =\"white\"{} "
         + "_SrcTex (\"SrcTex\", 2D) =\"white\"{}"
         + "_CutOff (\"Cut Off\", Float) =0.5}"
         + "SubShader {"
         + "Pass{ AlphaTest Off "
         + "SetTexture[_DstTex] { combine texture ";

    string part2x = " }"
        + " }"
        + "Pass {";
    string part3 = "  SetTexture [_SrcTex] {"
         + " combine texture";
    string part3x = " }"
        + "    }"
        + " }"
        + " }";
    void Start()
    {
        testMode = new string[] {"Always","Never","Greater","GEqual",
            "Less","LEqual","Equal","NotEqual"};
        Gen();
    }
    void Update()
    {
        rd1.material = bMaterials[i1];
        bMaterials[i1].SetFloat("_CutOff", j1);
        rd2.material = bMaterials2[i1];
        bMaterials2[i1].SetFloat("_CutOff", j1);
    }
    void OnGUI()
    {
        GUI.skin = skin;
        i1 = (int)GUI.HorizontalSlider(rI1, i1, 0, 7);
        j1 = GUI.HorizontalSlider(rJ1, j1, 0, 1);
        GUI.Label(rStr1, "AlphaTest" + "  " + testMode[i1] + "  " + j1);
        for (int i = 0; i < tips.Length; i++)
        {
            GUI.Label(rects[i], tips[i]);
        }
    }
    void Gen()
    {
        bMaterials = new Material[8];
        bMaterials2 = new Material[8];
        for (int i = 0; i < 8; i++)
        {
            string aTest = "AlphaTest" + "  " + testMode[i] + "  " + "[_CutOff]";
            string subNam = i + "" + "\"";
            string shader = part1 + subNam + part2 + part2x + aTest + part3 + part3x;
            shader = "Hidden/Shader/Common/AlphaTest" + i;

            bMaterials[i] = new Material(Shader.Find(shader));
            bMaterials[i].hideFlags = HideFlags.HideAndDontSave;
            bMaterials[i].SetTexture("_DstTex", tex0);
            bMaterials[i].SetTexture("_SrcTex", tex1);
            string shader2 = part1 + subNam + part2 + "alpha " + part2x + aTest + part3 + " alpha " + part3x;
            shader2 = "Hidden/Shader/Common/AlphaTest_alpha_" + i;
            bMaterials2[i] = new Material(Shader.Find(shader2));
            bMaterials2[i].hideFlags = HideFlags.HideAndDontSave;
            bMaterials2[i].SetTexture("_DstTex", tex0);
            bMaterials2[i].SetTexture("_SrcTex", tex1);
        }
    }
}

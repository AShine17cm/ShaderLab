using UnityEngine;
using System.Collections;
using System;
//[ExecuteInEditMode]
public class LP_Lab_7 : MonoBehaviour {
    public Transform actor;
    Vector3 w2Scr;
    public float posx;
    public float factor;
    public Rect[] rects;
    public string[] labels;
    public Rect[] rectL;
    public string shs;
    public Rect rectSH;
    public GUISkin skin;

#if UNITY_5_3_OR_NEWER || UNITY_5 // Compatible for Unity further version, for example, Unity 2017
    //public UnityEngine.Rendering.SphericalHarmonicsL2[] m_BaseCoefficients;
    //public UnityEngine.Rendering.SphericalHarmonicsL2[] m_Coefficients;
#else // Unity 4.x
    public float[] m_BaseCoefficients;
    public float[] m_Coefficients;
#endif
    // Use this for initialization
    void Start () {
        if (LightmapSettings.lightProbes == null) return;
        factor = 1.0f;
#if UNITY_5_3_OR_NEWER || UNITY_5
        //m_BaseCoefficients = new UnityEngine.Rendering.SphericalHarmonicsL2[LightmapSettings.lightProbes.bakedProbes.Length];
        //Array.Copy(LightmapSettings.lightProbes.bakedProbes, m_BaseCoefficients, LightmapSettings.lightProbes.bakedProbes.Length);

        //m_Coefficients = new UnityEngine.Rendering.SphericalHarmonicsL2[LightmapSettings.lightProbes.bakedProbes.Length];
#else
        m_BaseCoefficients = new float[LightmapSettings.lightProbes.coefficients.Length];
        Array.Copy(LightmapSettings.lightProbes.coefficients, m_BaseCoefficients, LightmapSettings.lightProbes.coefficients.Length);

        m_Coefficients = new float[LightmapSettings.lightProbes.coefficients.Length];
#endif
    }
    
    // Update is called once per frame
    void Update () {
        
        w2Scr=Camera.main.WorldToScreenPoint(actor.position);
        //if (LightmapSettings.lightProbes == null)
        //    return;
        actor.position = new Vector3(posx, actor.position.y, actor.position.z);
        //for (int i=0;i<m_BaseCoefficients.Length;i++)
        //{
        //    m_Coefficients[i] = m_BaseCoefficients[i] *factor;
        //}
#if UNITY_5_3_OR_NEWER || UNITY_5
        //LightmapSettings.lightProbes.bakedProbes = m_Coefficients;
#else
        LightmapSettings.lightProbes.coefficients = m_Coefficients;
#endif
    }
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < rectL.Length; i++)
        {
            GUI.Label(rectL[i], labels[i]);
        }
        posx = GUI.HorizontalSlider(rects[0], posx, -4.2f, 4.2f);
        factor = GUI.HorizontalSlider(rects[1], factor, 0f, 2f);
        GUI.Label(new Rect(w2Scr.x-rectSH.width/2,rectSH.y,rectSH.width,rectSH.height),shs);
    }
}

using UnityEngine;
using UnityEngine.UI;
//[ExecuteInEditMode]
public class LP_Lab_1 : MonoBehaviour
{
    public Transform actor;
    public float leftX=-3f, rightX=3f;
    public float factor;

#if UNITY_5_3_OR_NEWER || UNITY_5 // Compatible for Unity further version, for example, Unity 2017
    //public UnityEngine.Rendering.SphericalHarmonicsL2[] m_BaseCoefficients;
    //public UnityEngine.Rendering.SphericalHarmonicsL2[] m_Coefficients;
#else // Unity 4.x version.
    public float[] m_BaseCoefficients;
    public float[] m_Coefficients;
#endif
    // Use this for initialization
    void Start()
    {
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
    //UI slider event
    public void OnSliderVal(Slider slider)
    {
        float posK = slider.value;
        float posX = Mathf.Lerp(leftX, rightX, posK);
        Vector3 ofPos = actor.position;
        actor.position = new Vector3(posX, ofPos.y, ofPos.z);
    }
    // Update is called once per frame
    void Update()
    {
        //for (int i = 0; i < m_BaseCoefficients.Length; i++)
        //{
        //    m_Coefficients[i] = m_BaseCoefficients[i] * factor;
        //}
#if UNITY_5_3_OR_NEWER || UNITY_5
        //LightmapSettings.lightProbes.bakedProbes = m_Coefficients;
#else
        LightmapSettings.lightProbes.coefficients = m_Coefficients;
#endif
    }
}

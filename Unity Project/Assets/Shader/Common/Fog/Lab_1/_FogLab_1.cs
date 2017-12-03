using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class _FogLab_1 : MonoBehaviour {
    public bool fog;
    public Color fogColor;
    public float fogDensity;
    public FogMode fmode;
    public float startDist;
    public float endDist;
    public Rect[] rectLabels;
    public string[] labels;
    public Rect[] rectCo;
    public Texture[] checks;
    private Texture checkFog;
    private float r, g, b;
    private int m;
    public GUISkin skin;
	// Use this for initialization
	void Start () {
        fog = true;
	}
	
	// Update is called once per frame
	void Update () {
        if (fog)
            checkFog = checks[0];
        else
            checkFog = checks[1];

        RenderSettings.fogColor = new Color(r, g, b, 1);
        RenderSettings.fogDensity = fogDensity;
       
        if (m == 0) fmode = FogMode.Linear;
        else if (m == 1) fmode = FogMode.Exponential;
        else fmode = FogMode.ExponentialSquared;
        RenderSettings.fogMode = fmode;

        if (m == 0)
        {
            RenderSettings.fogStartDistance = startDist;
            RenderSettings.fogEndDistance = endDist;
        }
	}
    void OnGUI()
    {
        GUI.skin = skin;
        for (int i = 0; i < labels.Length; i++)
        {
            GUI.Label(rectLabels[i], labels[i]);
        }
        if (GUI.Button(rectCo[0], checkFog))
        {
            fog = !fog;
            RenderSettings.fog = fog;
        }
       
        r = GUI.HorizontalSlider(rectCo[2], r, 0, 1.0f);
        g = GUI.HorizontalSlider(rectCo[3], g, 0, 1.0f);
        b = GUI.HorizontalSlider(rectCo[4], b, 0, 1.0f);
        fogDensity = GUI.HorizontalSlider(rectCo[5], fogDensity, 0, 1);
        m = (int)GUI.HorizontalSlider(rectCo[6], m, 0, 2);
        if (m == 0)
        {
            GUI.Label(rectCo[9], "Linear Mode:Fog Start Distance");
            startDist = GUI.HorizontalSlider(rectCo[7], startDist, 0, 160f);
            GUI.Label(rectCo[10], "Linear Mode:Fog End Distance");
            endDist = GUI.HorizontalSlider(rectCo[8], endDist, 0, 160f);
        }

        GUI.backgroundColor = new Color(r, g, b, 1);
        GUI.Box(rectCo[1], "", GUIStyle.none);
    }
}

using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class RenderShadowVolume_1 : MonoBehaviour {
	public MeshFilter[] objects;
	public Light shadowLight;
	public Shader extrusionShader;
	public float extrusionDistance=20.0f;

	public Material setAlphaMat;
	public Material extrusionMat;
	//for debug GUI
	public Texture[] texs1;
	public GUISkin skin;
	
	public bool[] on1;
	public Rect[] recs1;
	
	public bool[] on2;
	public bool[] on20;
	public bool[] on21;
	public Rect[] recs2;
	
	void Awake()
	{
		on1=new bool[6]{true,true,true,true,true,true};
		on2=new bool[4]{true,true,true,true};
		on20=new bool[4]{true,true,true,true};
		on21=new bool[4]{true,true,true,true};
		
		recs1=RegionSpliter.SplitRegionH(new Rect(0,0,Screen.width,80),2,5f);
		recs2=RegionSpliter.SplitRegionH(new Rect(0,90,Screen.width,80),4,5f);
	}
	void Update(){	}
	void OnGUI()
	{
		GUI.skin=skin;
		//1.1
		GUI.BeginGroup(recs1[0]);
		GUI.Label(new Rect(30,0,120,26),"Draw Obj pass 0");
		if(MyGUI.CheckBox(new Rect(0,0,16,16),texs1[0],texs1[1],ref on1[0]))
		{
			MyGUI.CheckBox(new Rect(30,26,16,16),texs1[0],texs1[1],ref on1[2]);
			GUI.Label(new Rect(60,26,80,26),"Set pass 0");
			MyGUI.CheckBox(new Rect(30,50,16,16),texs1[0],texs1[1],ref on1[3]);
			GUI.Label(new Rect(60,50,80,26),"Draw Mesh");
		}
		GUI.EndGroup();
		//1.2
		GUI.BeginGroup(recs1[1]);
		GUI.Label(new Rect(30,0,120,26),"Draw Obj pass 1");
		if(MyGUI.CheckBox(new Rect(0,0,16,16),texs1[0],texs1[1],ref on1[1]))
		{
			MyGUI.CheckBox(new Rect(30,26,16,16),texs1[0],texs1[1],ref on1[4]);
			GUI.Label(new Rect(60,26,80,26),"Set pass 1");
			MyGUI.CheckBox(new Rect(30,50,16,16),texs1[0],texs1[1],ref on1[5]);
			GUI.Label(new Rect(60,50,80,26),"Draw Mesh");
		}
		GUI.EndGroup();
		//2.1
		GUI.BeginGroup(recs2[0]);
		GUI.Label(new Rect(30,0,120,26),"Set pass 1");
		if(MyGUI.CheckBox(new Rect(0,0,16,16),texs1[0],texs1[1],ref on2[0]))
		{
			MyGUI.CheckBox(new Rect(30,26,16,16),texs1[0],texs1[1],ref on20[0]);
			GUI.Label(new Rect(60,26,80,26),"Set pass 1");
			MyGUI.CheckBox(new Rect(30,50,16,16),texs1[0],texs1[1],ref on21[0]);
			GUI.Label(new Rect(60,50,80,26),"Draw Quad");
		}
		GUI.EndGroup();
		//2.2
		GUI.BeginGroup(recs2[1]);
		GUI.Label(new Rect(30,0,120,26),"Set pass 2");
		if(MyGUI.CheckBox(new Rect(0,0,16,16),texs1[0],texs1[1],ref on2[1]))
		{
			MyGUI.CheckBox(new Rect(30,26,16,16),texs1[0],texs1[1],ref on20[1]);
			GUI.Label(new Rect(60,26,80,26),"Set pass 2");
			MyGUI.CheckBox(new Rect(30,50,16,16),texs1[0],texs1[1],ref on21[1]);
			GUI.Label(new Rect(60,50,80,26),"Draw Quad");
		}
		GUI.EndGroup();
		//2.3
		GUI.BeginGroup(recs2[2]);
		GUI.Label(new Rect(30,0,120,26),"Set pass 3");
		if(MyGUI.CheckBox(new Rect(0,0,16,16),texs1[0],texs1[1],ref on2[2]))
		{
			MyGUI.CheckBox(new Rect(30,26,16,16),texs1[0],texs1[1],ref on20[2]);
			GUI.Label(new Rect(60,26,80,26),"Set pass 3");
			MyGUI.CheckBox(new Rect(30,50,16,16),texs1[0],texs1[1],ref on21[2]);
			GUI.Label(new Rect(60,50,80,26),"Draw Quad");
		}
		GUI.EndGroup();
		//2.4
		GUI.BeginGroup(recs2[3]);
		GUI.Label(new Rect(30,0,120,26),"Set pass 4");
		if(MyGUI.CheckBox(new Rect(0,0,16,16),texs1[0],texs1[1],ref on2[3]))
		{
			MyGUI.CheckBox(new Rect(30,26,16,16),texs1[0],texs1[1],ref on20[3]);
			GUI.Label(new Rect(60,26,80,26),"Set pass 4");
			MyGUI.CheckBox(new Rect(30,50,16,16),texs1[0],texs1[1],ref on21[3]);
			GUI.Label(new Rect(60,50,80,26),"Draw Quad");
		}
		GUI.EndGroup();
	}
	void OnPostRender()
	{
		if(!enabled) return;
		
		GL.PushMatrix();
		GL.LoadOrtho();
		setAlphaMat.SetPass(0);
		DrawQuad();
		GL.PopMatrix();
		
		Vector4 lightPos;
		if(shadowLight.type==LightType.Directional)
		{
			Vector3 dir=-shadowLight.transform.forward;
			lightPos=new Vector4(dir.x,dir.y,dir.z,0.0f);
		}else{
			Vector3 pos=shadowLight.transform.position;
			lightPos=new Vector4(pos.x,pos.y,pos.z,1.0f);
		}
		extrusionMat.SetVector("_LightPosition",lightPos);
		foreach(MeshFilter mf in objects)
		{
			Mesh m=mf.sharedMesh;
			Transform tr=mf.transform;
			
			if(on1[0]){
				if(on1[2])
					extrusionMat.SetPass(0);
				if(on1[3])
					Graphics.DrawMeshNow(m,tr.localToWorldMatrix);
			}
			if(on1[1]){
				if(on1[4])
					extrusionMat.SetPass(1);
				if(on1[5])
					Graphics.DrawMeshNow(m,tr.localToWorldMatrix);
			}
		}
		// normalize and apply shadow mask
	    GL.PushMatrix ();
	    GL.LoadOrtho ();
		if(on2[0]){
			if(on20[0])
			setAlphaMat.SetPass (1);
			if(on21[0])
			DrawQuad();
		}
		if(on2[1]){
			if(on20[1])
			setAlphaMat.SetPass (2);
			if(on21[1])
			DrawQuad();
		}
		if(on2[2]){
			if(on20[2])
			setAlphaMat.SetPass (3);
			if(on21[2])
			DrawQuad();
		}
		if(on2[3]){
			if(on20[3])
			setAlphaMat.SetPass (4);
			if(on21[3])
			DrawQuad();
		}
	    GL.PopMatrix ();
	}
	public static void DrawQuad()
	{
		GL.Begin (GL.QUADS);
		GL.Vertex3 (0, 0, 0.1f);
		GL.Vertex3 (1, 0, 0.1f);
		GL.Vertex3 (1, 1, 0.1f);
		GL.Vertex3 (0, 1, 0.1f);
		GL.End ();
	}
}

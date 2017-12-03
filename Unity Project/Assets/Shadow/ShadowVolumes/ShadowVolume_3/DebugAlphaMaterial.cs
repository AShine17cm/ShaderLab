using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class DebugAlphaMaterial : MonoBehaviour {

	public Material setAlphaMat;
	public Material alphaMat;
	public Material set_RMat;
	public Material R_Mat;
	public MeshFilter alphaObj;
	public MeshFilter R_obj;
	//for debug GUI
	public Texture[] texs1;
	public GUISkin skin;

	public bool[] on2;
	public bool[] on20;
	public bool[] on21;
	public Rect[] recs2;
	
	void Awake()
	{
		on2=new bool[5]{true,true,true,true,true};
		on20=new bool[5]{true,true,true,true,true};
		on21=new bool[5]{true,true,true,true,true};
		
		recs2=RegionSpliter.SplitRegionH(new Rect(0,0,Screen.width,80),5,5f);
	}
	void Update(){	}
	void OnGUI()
	{
		GUI.skin=skin;
		//2.1
		GUI.BeginGroup(recs2[0]);
		GUI.Label(new Rect(30,0,120,26),"pass 1");
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
		GUI.Label(new Rect(30,0,120,26),"pass 1+2");
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
		GUI.Label(new Rect(30,0,120,26),"pass 1+2+3");
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
		GUI.Label(new Rect(30,0,120,26),"pass 1+2+3+4");
		if(MyGUI.CheckBox(new Rect(0,0,16,16),texs1[0],texs1[1],ref on2[3]))
		{
			MyGUI.CheckBox(new Rect(30,26,16,16),texs1[0],texs1[1],ref on20[3]);
			GUI.Label(new Rect(60,26,80,26),"Set pass 4");
			MyGUI.CheckBox(new Rect(30,50,16,16),texs1[0],texs1[1],ref on21[3]);
			GUI.Label(new Rect(60,50,80,26),"Draw Quad");
		}
		GUI.EndGroup();
		//
		//2.5
		GUI.BeginGroup(recs2[4]);
		GUI.Label(new Rect(30,0,120,26),"pass 1+2+3+4+5");
		if(MyGUI.CheckBox(new Rect(0,0,16,16),texs1[0],texs1[1],ref on2[4]))
		{
			MyGUI.CheckBox(new Rect(30,26,16,16),texs1[0],texs1[1],ref on20[4]);
			GUI.Label(new Rect(60,26,80,26),"Set pass 4");
			MyGUI.CheckBox(new Rect(30,50,16,16),texs1[0],texs1[1],ref on21[4]);
			GUI.Label(new Rect(60,50,80,26),"Draw Quad");
		}
		GUI.EndGroup();
	}
	void OnPostRender()
	{
		if(!enabled) return;
		// normalize and apply shadow mask
		//1.1
	    GL.PushMatrix ();
	    GL.LoadOrtho ();
		if(on2[0]){
			if(on20[0])
			setAlphaMat.SetPass (0);
			if(on21[0])
			DrawQuad(0,0);
		}
		GL.PopMatrix();
		//1.alpha
		alphaMat.SetPass(0);
		Graphics.DrawMeshNow(alphaObj.sharedMesh,alphaObj.transform.localToWorldMatrix);
		//
		GL.PushMatrix();
		GL.LoadOrtho();
		//1.2
		if(on2[1]){
			if(on20[1])
			setAlphaMat.SetPass (1);
			if(on21[1])
			DrawQuad(0.2f,0);
		}
		//1.3
		if(on2[2]){
			if(on20[2])
			setAlphaMat.SetPass (2);
			if(on21[2])
			DrawQuad(0.4f,0);
		}
		//1.4
		if(on2[3]){
			if(on20[3])
			setAlphaMat.SetPass (3);
			if(on21[3])
			DrawQuad(0.6f,0);
		}
		//1.5
		if(on2[4]){
			if(on20[4])
			setAlphaMat.SetPass (4);
			if(on21[4])
			DrawQuad(0.8f,0);
		}
	    GL.PopMatrix ();
		//****************************************
		//2.1
		GL.PushMatrix ();
	    GL.LoadOrtho ();
		if(on2[0]){
			if(on20[0])
			set_RMat.SetPass (0);
			if(on21[0])
			DrawQuad(0,.25f);
		}
		GL.PopMatrix();
		//2.R
		//R_Mat.SetPass(0);
		//Graphics.DrawMesh(R_obj.sharedMesh,R_obj.transform.localToWorldMatrix);
		//
		GL.PushMatrix();
		GL.LoadOrtho();
		//2.2
		if(on2[1]){
			if(on20[1])
			set_RMat.SetPass (1);
			if(on21[1])
			DrawQuad(0.2f,0.25f);
		}
		//2.3
		if(on2[2]){
			if(on20[2])
			setAlphaMat.SetPass (2);
			if(on21[2])
			DrawQuad(0.4f,0.25f);
		}
		//2.4
		if(on2[3]){
			if(on20[3])
			set_RMat.SetPass (3);
			if(on21[3])
			DrawQuad(0.6f,0.25f);
		}
		//2.5
		if(on2[4]){
			if(on20[4])
			set_RMat.SetPass (4);
			if(on21[4])
			DrawQuad(0.8f,0.25f);
		}
	    GL.PopMatrix ();
	}
	public  void DrawQuad(float xf,float yf)
	{
		GL.Begin (GL.QUADS);
		GL.Vertex3 (0+xf, 0f+yf, 0.1f);
		GL.Vertex3 (1f, 0f+yf, 0.1f);
		GL.Vertex3 (1f, 0.25f+yf, 0.1f);
		GL.Vertex3 (0+xf, 0.25f+yf, 0.1f);
		GL.End ();
	}
	public  void DrawAlphaQuad(float xf,float yf)
	{
		GL.Begin (GL.QUADS);
		GL.Vertex3 (0+xf, 0f+yf, 0.1f);
		GL.Vertex3 (1f, 0f+yf, 0.1f);
		GL.Vertex3 (1f, 0.5f+yf, 0.1f);
		GL.Vertex3 (0+xf, 0.5f+yf, 0.1f);
		GL.End ();
	}
}

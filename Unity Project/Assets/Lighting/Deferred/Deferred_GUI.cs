using UnityEngine;
using System.Collections;
[ExecuteInEditMode]
public class Deferred_GUI : MonoBehaviour {
	
	public GUISkin skin;
	public Rect[] rects;
	public string[] labels;
	public Rect[] rects2;
	public Light[] dirs;
	public Rect[] rects3;
	Rect[] rects4;
	Rect[] rects5;
	Rect[] rects6;
	public Light[] points;

	// Use this for initialization
	void Start () {
		rects4=new Rect[7];
		rects5=new Rect[7];
		rects6=new Rect[7];
		for(int i=0;i<7;i++)
		{
			rects4[i]=rects3[i];
			rects5[i]=rects3[i];
			rects6[i]=rects3[i];
			rects4[i].y+=30;
			rects5[i].y+=60;
			rects6[i].y+=90;
		}
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	void OnGUI()
	{
		GUI.skin=skin;
		for(int i=0;i<rects.Length;i++)
		{
			GUI.Label(rects[i],labels[i]);
		}

		GUI.Label(rects2[0],"Path: "+Camera.main.renderingPath+"");
		if(GUI.Button(rects2[1],"VertexLit")){Camera.main.renderingPath=RenderingPath.VertexLit;}
		if(GUI.Button(rects2[2],"Forward")){Camera.main.renderingPath=RenderingPath.Forward;}
		if(GUI.Button(rects2[3],"Deferred")){Camera.main.renderingPath=RenderingPath.DeferredLighting;}
		
		if(GUI.Button(rects2[4],"Dir1:Enable")){dirs[0].enabled=true;}
		if(GUI.Button(rects2[5],"Disable")){dirs[0].enabled=false;}
		if(GUI.Button(rects2[6],"Pixel")){dirs[0].renderMode=LightRenderMode.ForcePixel;}
		if(GUI.Button(rects2[7],"Vertex")){dirs[0].renderMode=LightRenderMode.ForceVertex;}
		GUI.Label(rects2[8],"Direction Light 1:  "+dirs[0].enabled+"   "+dirs[0].renderMode);
		
		if(GUI.Button(rects2[9],"Dir2:Enable")){dirs[1].enabled=true;}
		if(GUI.Button(rects2[10],"Disable")){dirs[1].enabled=false;}
		if(GUI.Button(rects2[11],"Pixel")){dirs[1].renderMode=LightRenderMode.ForcePixel;}
		if(GUI.Button(rects2[12],"Vertex")){dirs[1].renderMode=LightRenderMode.ForceVertex;}
		GUI.Label(rects2[13],"Direction Light 2:  "+dirs[1].enabled+"   "+dirs[1].renderMode);
		
		GUI.Label(rects3[0],points[0].enabled+"  "+points[0].renderMode+"  "+points[0].type+" :Yellow L");
		if(GUI.Button(rects3[1],"Enable")){points[0].enabled=true;}
		if(GUI.Button(rects3[2],"Disable")){points[0].enabled=false;}
		if(GUI.Button(rects3[3],"Pixel")){points[0].renderMode=LightRenderMode.ForcePixel;}
		if(GUI.Button(rects3[4],"Vertex")){points[0].renderMode=LightRenderMode.ForceVertex;}
		if(GUI.Button(rects3[5],"Point")){points[0].type=LightType.Point;}
		if(GUI.Button(rects3[6],"Direc")){points[0].type=LightType.Directional;}
		
		GUI.Label(rects4[0],points[1].enabled+"  "+points[1].renderMode+"  "+points[1].type+" :Green L");
		if(GUI.Button(rects4[1],"Enable")){points[1].enabled=true;}
		if(GUI.Button(rects4[2],"Disable")){points[1].enabled=false;}
		if(GUI.Button(rects4[3],"Pixel")){points[1].renderMode=LightRenderMode.ForcePixel;}
		if(GUI.Button(rects4[4],"Vertex")){points[1].renderMode=LightRenderMode.ForceVertex;}
		if(GUI.Button(rects4[5],"Point")){points[1].type=LightType.Point;}
		if(GUI.Button(rects4[6],"Direc")){points[1].type=LightType.Directional;}
		
		GUI.Label(rects5[0],points[2].enabled+"  "+points[2].renderMode+"  "+points[2].type+" :Red L");
		if(GUI.Button(rects5[1],"Enable")){points[2].enabled=true;}
		if(GUI.Button(rects5[2],"Disable")){points[2].enabled=false;}
		if(GUI.Button(rects5[3],"Pixel")){points[2].renderMode=LightRenderMode.ForcePixel;}
		if(GUI.Button(rects5[4],"Vertex")){points[2].renderMode=LightRenderMode.ForceVertex;}
		if(GUI.Button(rects5[5],"Point")){points[2].type=LightType.Point;}
		if(GUI.Button(rects5[6],"Direc")){points[2].type=LightType.Directional;}
		
		GUI.Label(rects6[0],points[3].enabled+"  "+points[3].renderMode+"  "+points[3].type+" :Blue L");
		if(GUI.Button(rects6[1],"Enable")){points[3].enabled=true;}
		if(GUI.Button(rects6[2],"Disable")){points[3].enabled=false;}
		if(GUI.Button(rects6[3],"Pixel")){points[3].renderMode=LightRenderMode.ForcePixel;}
		if(GUI.Button(rects6[4],"Vertex")){points[3].renderMode=LightRenderMode.ForceVertex;}
		if(GUI.Button(rects6[5],"Point")){points[3].type=LightType.Point;}
		if(GUI.Button(rects6[6],"Direc")){points[3].type=LightType.Directional;}

       
	}
}

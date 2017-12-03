using UnityEngine;
using System.Collections;

public class MyGUI {
	
	public static bool CheckBox(Rect pos,Texture onTex,Texture offTex,ref bool on)
	{
		if(on)
		{
			if( GUI.Button(pos,onTex,GUIStyle.none))
				on=false;
		}
		else{
			if(	GUI.Button(pos,offTex,GUIStyle.none))
				on=true;
		}
		return on;
	}
}

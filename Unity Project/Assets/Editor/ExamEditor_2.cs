using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
//http://docs.unity3d.com/Manual/SL-CustomMaterialEditors.html
public class ExamEditor_2 : MaterialEditor 
{

	public override void OnInspectorGUI ()
	{
		base.OnInspectorGUI ();

		if (!isVisible)
				return;

		Material targetMat = target as Material;
		string [] keyWords = targetMat.shaderKeywords;
		bool switon = keyWords.Contains ("MY_multi_1");

		EditorGUI.BeginChangeCheck ();//GUI变动开始
		switon = EditorGUILayout.Toggle ("MY_multi_1",switon);
		if(EditorGUI.EndChangeCheck())//GUI变动结束
		{
			var keys=new List<string>{switon?"MY_multi_1":"MY_multi_2"};
			targetMat.shaderKeywords=keys.ToArray();
			EditorUtility.SetDirty(targetMat);
		}
	}
}

using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class ExamEditor_1 : MaterialEditor {
	
	public override void OnInspectorGUI ()
	{
		base.OnInspectorGUI ();
		
		if (!isVisible)
			return;
		
		Material targetMat = target as Material;//我们正在编辑的材质
		Shader shader = targetMat.shader;
		//第二个材质属性
		string label1 = ShaderUtil.GetPropertyDescription(shader, 1);
		string propertyName1 = ShaderUtil.GetPropertyName(shader, 1);
		float val1 = targetMat.GetFloat (propertyName1);
		//第三个材质属性
		string label2 = ShaderUtil.GetPropertyDescription(shader, 2);
		string propertyName2 = ShaderUtil.GetPropertyName(shader, 2);
		int val2 = targetMat.GetInt (propertyName2);

		//第1个浮点值的展示
		EditorGUILayout.LabelField(label1+"/"+propertyName1," "+val1);
		//第2个整型的展示
		EditorGUILayout.LabelField(label2+"/"+propertyName2," "+val2);


		EditorGUI.BeginChangeCheck ();//GUI变动开始

		if(EditorGUI.EndChangeCheck())//GUI变动结束
		{
			EditorUtility.SetDirty(targetMat);
		}
	}
	public override void OnPreviewGUI (Rect r, GUIStyle background)
	{
		base.OnPreviewGUI (r, background);

		Material targetMat = target as Material;//我们正在编辑的材质
		Shader shader = targetMat.shader;

		//string label = ShaderUtil.GetPropertyDescription(shader, 0);
		string propertyName = ShaderUtil.GetPropertyName(shader, 0);
		Texture tex = targetMat.GetTexture (propertyName);
		
		if(tex!=null)
		{
			EditorGUILayout.LabelField(""+tex.name+"  height:"+tex.height+","+"width:"+tex.width);
		}

	}
}

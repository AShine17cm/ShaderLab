using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Linq;
#if false
public class CustomMatEditor : MaterialEditor {
	
	// this is the same as the ShaderProperty function, show here so 
	// you can see how it works
	private void ShaderPropertyImpl(Shader shader, int propertyIndex)
	{
		int i = propertyIndex;
		string label = ShaderUtil.GetPropertyDescription(shader, i);
		string propertyName = ShaderUtil.GetPropertyName(shader, i);
		switch (ShaderUtil.GetPropertyType(shader, i))
		{
		case ShaderUtil.ShaderPropertyType.Range: // float ranges
		{
			GUILayout.BeginHorizontal();
			float v2 = ShaderUtil.GetRangeLimits(shader, i, 1);
			float v3 = ShaderUtil.GetRangeLimits(shader, i, 2);
			RangeProperty(propertyName, label, v2, v3);
			GUILayout.EndHorizontal();
			
			break;
		}
		case ShaderUtil.ShaderPropertyType.Float: // floats
		{
			FloatProperty(propertyName, label);
			break;
		}
		case ShaderUtil.ShaderPropertyType.Color: // colors
		{
			ColorProperty(propertyName, label);
			break;
		}
		case ShaderUtil.ShaderPropertyType.TexEnv: // textures
		{
			var desiredTexdim = ShaderUtil.GetTexDim(shader, i);
			TextureProperty(propertyName, label, (ShaderUtil.ShaderPropertyTexDim)desiredTexdim);
			
			GUILayout.Space(6);
			break;
		}
		case ShaderUtil.ShaderPropertyType.Vector: // vectors
		{
			VectorProperty(propertyName, label);
			break;
		}
		default:
		{
			GUILayout.Label("ARGH" + label + " : " + ShaderUtil.GetPropertyType(shader, i));
			break;
		}
		}
	}
	
	public override void OnInspectorGUI ()
	{
		serializedObject.Update ();
		var theShader = serializedObject.FindProperty ("m_Shader"); 
		if (isVisible && !theShader.hasMultipleDifferentValues && theShader.objectReferenceValue != null)
		{
			float controlSize = 64;
			
			EditorGUIUtility.LookLikeControls(Screen.width - controlSize - 20);
			
			EditorGUI.BeginChangeCheck();
			Shader shader = theShader.objectReferenceValue as Shader;
			
			for (int i = 0; i < ShaderUtil.GetPropertyCount(shader); i++)
			{
				ShaderPropertyImpl(shader, i);
			}
			
			if (EditorGUI.EndChangeCheck())
				PropertiesChanged ();
		}
	}
}
#endif
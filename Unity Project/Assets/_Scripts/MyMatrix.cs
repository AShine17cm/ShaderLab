using UnityEngine;
using System.Collections;

public class MyMatrix{
    public static int dx=80, dy=30;
    public static void DisplayMatrix(Matrix4x4 m,Rect r)
    {
        GUI.BeginGroup(r);
        GUI.Label(new Rect(0, 0, 90, 25), "Row&Col");
        for (int i = 0; i < 4; i++)
        {
            GUI.Label(new Rect(0, i * dy+10 + 20, 40, 25), "  R:" + i);//Display Row label
            for (int j = 0; j < 4; j++)
            {
                GUI.Label(new Rect(j * dx + 50, i * dy + 20+10, 70, 25), m[i, j] + "");

            }
        }
        GUI.EndGroup();
    }
}

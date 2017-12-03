using UnityEngine;
using System.Collections;

public class RegionSpliter{

	 public static Rect[] SplitRegionH(Rect region, int count,float pad)
    {
        float rw = region.width;
        float rh = region.height;
        float w;
        float h;
        float pads = pad*(count + 1);
        w = (rw - pads) / count;
        h = (rh - pad * 2);

        Rect[] rs = new Rect[count];
        for (int i = 0; i < count; i++)
        {
            Rect r = new Rect();
            r.x = pad * (i + 1) + w * i+region.x;
            r.y = pad+region.y;
            r.width = w;
            r.height = h;
            rs[i] = r;
        }
        return rs;
    }
    public static Rect[] SplitRegionV(Rect region, int count, float pad)
    {
        float rw = region.width;
        float rh = region.height;
        float w;
        float h;
        float pads = pad * (count + 1);
        h = (rh - pads) / count;
        w = (rw - pad * 2);

        Rect[] rs = new Rect[count];
        for (int i = 0; i < count; i++)
        {
            Rect r = new Rect();
            r.y = pad * (i + 1) + h * i + region.y;
            r.x = pad + region.x;
            r.width = w;
            r.height = h;
            rs[i] = r;
        }
        return rs;
    }
    public static void ShowLight(Light l, Rect rect)
    {
        float w = rect.width;
        float h = rect.height/8;

        GUI.BeginGroup(rect);

       //light's Type
        if(GUI.Button(new Rect (0,h*0,w,h),l.type+""))
        {
            if (l.type == LightType.Point)
                l.type = LightType.Directional;
            else
                l.type = LightType.Point;
        }
        //Light's Render Mode
        if (GUI.Button(new Rect(0, h*1, w, h), l.renderMode + ""))
        {
            if (l.renderMode == LightRenderMode.ForcePixel)
                l.renderMode = LightRenderMode.ForceVertex;
            else if (l.renderMode == LightRenderMode.ForceVertex)
                l.renderMode = LightRenderMode.Auto;
            else
                l.renderMode = LightRenderMode.ForcePixel;
        }
        //Light's Intensity
        GUI.Label(new Rect(0 , h * 2+h/3, w / 2, h), "Intensity:");
        GUI.Label(new Rect(0 +w/2, h * 2+h/3, w/2, h),l.intensity + "");
        l.intensity= GUI.HorizontalSlider(new Rect(0 , h * 3, w, h), l.intensity, 0, 8);
        //Light's Range
        GUI.Label(new Rect(0 , h * 4 + h / 3, w / 2, h), "Range:");
        GUI.Label(new Rect(0 + w / 2, h * 4 + h / 3, w / 2, h), l.range + "");
        l.range = GUI.HorizontalSlider(new Rect(0 , h * 5, w, h), l.range, 0, 50);
        //Light's Color
        Color c = GUI.color;
        GUI.color = l.color;
        GUI.Label(new Rect(0+w/4, h * 6, w, h), "ššššššššš");
        GUI.color = c;
        //
        GUI.Label(new Rect(0+w/3,h*7,w,h),l.name,GUIStyle.none);
        GUI.EndGroup();

    }
    public static void DRenderingQuality(Rect qr, Rect[] r)
    {
        int qlev=0;
        //GUI.BeginGroup(qr);
        GUI.Label(r[0], "Quality: "+QualitySettings.GetQualityLevel());
        qlev = (int)GUI.HorizontalSlider(r[1], QualitySettings.GetQualityLevel(), 1, 5);
        QualitySettings.SetQualityLevel(qlev);
        GUI.Label(r[2], "Pixel_L: " + QualitySettings.pixelLightCount);
        QualitySettings.pixelLightCount =(int) GUI.HorizontalSlider(r[3],QualitySettings.pixelLightCount, 0,4);
        //GUI.EndGroup();
    }
}

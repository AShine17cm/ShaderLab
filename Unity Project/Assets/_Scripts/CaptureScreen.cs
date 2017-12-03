/*
 * Attach this Script to MainCamera or Camera which is displaying (recommend).
 * Press 'K' key to get a screen shot.
 * */
using UnityEngine;
using System.Collections;

public class CaptureScreen : MonoBehaviour
{
    private int resWidth;
    private int resHeight;

    private bool takeHiResShot = false;
    private Camera _myCamera;

    public static string ScreenShotName(int width, int height)
    {
        var guidString = System.Guid.NewGuid().ToString();
        return string.Format("{0}/../screenshots/screen_{1}x{2}_{3}.png",
                             Application.dataPath,
                             width, height,
                             System.DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss") + guidString.Substring((Mathf.Max(0, guidString.Length - 4))));
    }

    private void Start()
    {
        _myCamera = GetComponent<Camera>();
        if (_myCamera == null || _myCamera.isActiveAndEnabled == false)
        {
            _myCamera = Camera.main;
        }
        if (_myCamera == null || _myCamera.isActiveAndEnabled == false)
        {
            enabled = false;
        }
        resHeight = Screen.height;
        resWidth = Screen.width;
    }

    public void TakeHiResShot()
    {
        takeHiResShot = true;
    }

    void LateUpdate()
    {
        takeHiResShot |= Input.GetKeyDown("k");
        if (takeHiResShot)
        {
            RenderTexture rt = new RenderTexture(resWidth, resHeight, 24);
            _myCamera.targetTexture = rt;
            Texture2D screenShot = new Texture2D(resWidth, resHeight, TextureFormat.RGB24, false);
            _myCamera.Render();
            RenderTexture.active = rt;
            screenShot.ReadPixels(new Rect(0, 0, resWidth, resHeight), 0, 0);
            _myCamera.targetTexture = null;
            RenderTexture.active = null; // GC: added to avoid errors
            Destroy(rt);
            byte[] bytes = screenShot.EncodeToPNG();
            string filename = ScreenShotName(resWidth, resHeight);
            System.IO.Directory.CreateDirectory(string.Format("{0}/../screenshots", Application.dataPath));
            System.IO.File.WriteAllBytes(filename, bytes);
            Debug.Log(string.Format("Took screenshot to: {0}", filename));
            takeHiResShot = false;
        }
    }
}
using UnityEngine;
using System.Collections;

public class MyDebug  {
    public static int pwd = 0;//0 means pass every message,otherwise pass the current msg has the correct password
    public static DebugType typ = DebugType.Zero;//Zero means pass anything,otherwise pass the cuurent mas has the correct DebugType
    public static void Log(string msg, int password = 0, DebugType type = DebugType.Zero)
    {
        if (pwd != 0)//0 means pass every message,otherwise pass the current msg has the correct password
        {
            if (password != pwd ) return;
        }
        if (typ != DebugType.Zero)//Zero means pass anything,otherwise pass the cuurent mas has the correct DebugType
        {
            if (typ != type)
                return;
        }
        Debug.Log(msg);
    }
    public static void LogError(string msg, int password = 0, DebugType type = DebugType.normal)
    {
        if (pwd != 0)//0 means pass every message,other wise pass the current msg has the correct password
        {
            if (password != pwd) return;
        }
        if (typ != DebugType.Zero)//Zero means pass anything,otherwise pass the cuurent mas has the correct DebugType
        {
            if (typ != type)
                return;
        }
        Debug.LogError(msg);
    }
}
public enum DebugType{
    normal,
    Zero,
}

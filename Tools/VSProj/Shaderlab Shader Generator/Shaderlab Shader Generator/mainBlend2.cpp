#include "ShaderGen.h"
#ifdef BLEND2

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>
using namespace std;

class Gen
{
private:
    string part0 = "BlendTest";
    string part1 =
        "Shader \"Hidden/Shader/Common/BlendTest";
    string part2 =
        "\n    Properties {\n        _DstTex (\"DstTex\", 2D) =\"white\"{}\n"
        "        _SrcTex (\"SrcTex\", 2D) =\"white\"{}\n    }\n"
        "    SubShader {\n"
        "        Pass{\n"
        "            SetTexture[_DstTex] {combine texture}\n"
        "        }\n"
        "        Pass {\n";
    string part3 = 
        "            SetTexture [_SrcTex] { combine texture}\n"
        "        }\n";

    string part4 =
        "        Pass{\n"
        "            Blend DstAlpha Zero\n"
        "            color(1,1,1,1)\n"
        "        }\n";

    string part5 = "    }\n}\n";

    vector<string> bMode = { "One","Zero","SrcColor","SrcAlpha",
        "DstColor","DstAlpha","OneMinusSrcColor","OneMinusSrcAlpha",
        "OneMinusDstColor","OneMinusDstAlpha" };
    vector<string> blendOp = { "Max", "Min", "Sub", "RevSub" };

public:
    void GenShader()
    {
        ofstream outText;
        for (int i = 0; i < 10; i++)
        {
            for (int j = 0; j < 10; j++)
            {
                string bm = "            Blend " + bMode[i] + " " + bMode[j] + "\n";
                string subNam = to_string(i) + to_string(j) + "\"\n{";

                for (int k = 0; k < 4; k++)
                {
                    string bOp = "            BlendOp " + blendOp[k] + "\n";
                    string shaderOp = part1 + "Op" + to_string(k) + subNam + part2 + bOp + bm + part3 + part5;
                    cout << shaderOp << endl;
                    outText = ofstream("BlendTestOP " + blendOp.at(k) + " " + bMode.at(i) + " "  + bMode.at(j) + ".shader", ios::out);
                    outText << shaderOp;
                    outText.close();
                    string shaderOpA = part1 + "OpA" + to_string(k) + subNam + part2 + bOp + bm + part3 + part4 + part5;
                    cout << shaderOpA << endl;
                    outText = ofstream("BlendTestOPA " + blendOp.at(k) + " " + bMode.at(i) + " " + bMode.at(j) + ".shader", ios::out);
                    outText << shaderOpA;
                    outText.close();
                }
            }
        }
    }
};

int main(int argc, char *argv[])
{
    Gen test;
    test.GenShader();
    return 0;
}

#endif
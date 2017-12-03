#include "ShaderGen.h"
#ifdef BLEND1

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>
using namespace std;

class gen
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

public:
    void genShader()
    {
        for (int i = 0; i < 10; i++)
        {
            for (int j = 0; j < 10; j++)
            {
                string bm = "            Blend " + bMode[i] + " " + bMode[j] + "\n";
                string subNam = to_string(i) + to_string(j) + "\" {";
                string shader = part1 + subNam + part2 + bm + part3 + part5;
                cout << shader;
                auto outText = ofstream("BlendTest " + bMode[i] + " " + bMode[j] + ".shader", ios::out);
                outText << shader;
                outText.close();
                string shaderA = part1 + "A" + subNam + part2 + bm + part3 + part4 + part5;
                cout << shaderA;
                outText = ofstream("BlendTestA " + bMode[i] + " " + bMode[j] + ".shader", ios::out);
                outText << shaderA;
                outText.close();
            }
        }
    }
};

int main(int argc, char *argv[])
{
    gen test;
    test.genShader();
    return 0;
}

#endif
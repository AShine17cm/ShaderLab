#include "ShaderGen.h"
#ifdef ALPHA1

#include <iostream>
#include <fstream>
#include <cstdlib>
#include <string>
#include <vector>
using namespace std;

class gen
{
private:
    string part0 = "AlphaTest";
    string part1 =
        "Shader \"Hidden/Shader/Common/AlphaTest";
    string part2 =
        "\n{\n"
        "    Properties {\n        _DstTex (\"DstTex\", 2D) =\"white\"{} \n"
        "        _SrcTex (\"SrcTex\", 2D) =\"white\"{}\n"
        "        _CutOff (\"Cut Off\", Float) =0.5\n    }\n"
        "    SubShader {\n"
        "        Pass{\n"
        "            SetTexture[_DstTex] { combine texture ";
    string part2x = "}\n"
        "        }\n"
        "        Pass {\n";
    string part3 = (string)"            SetTexture [_SrcTex] {"
        " combine texture ";
    string part3x = (string)"}\n"
        "        }\n"
        "    }\n"
        "}\n";

    vector<string> testMode = { "Always","Never","Greater","GEqual",
        "Less","LEqual","Equal","NotEqual" };

public:
    void genShader()
    {
        for (int i = 0; i < 8; i++)
        {
            string aTest = (string)"            AlphaTest  " + this->testMode[i] + "  [_CutOff]\n";
            string subNam = to_string(i) + "" + "\"";
            string shader = part1 + subNam + part2 + part2x + aTest + part3 + part3x;
            //cout << shader;
            auto outText = ofstream((string)"AlphaTest " + this->testMode[i] + ".shader", ios::out);
            outText << shader;
            outText.close();
            string shader2 = part1 + "_alpha_" + subNam + part2 + "alpha " + part2x + aTest + part3 + "alpha " + part3x;
            auto outText2 = ofstream((string)"AlphaTest alpha " + this->testMode[i] + ".shader", ios::out);
            outText2 << shader2;
            outText.close();
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
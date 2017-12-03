#pragma once
#include "HelloTexture.h"

class Win32Application
{
public:
    static HRESULT InitWindow(HINSTANCE hInstance, int nCmdShow);
    static HWND GetHwnd()
    {
        return m_hWnd;
    }

protected:
    static LRESULT CALLBACK WindowProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);

private:
    static HWND m_hWnd;
    static HINSTANCE m_hInst;
    static std::unique_ptr<HelloTexture> m_dxInst;
};


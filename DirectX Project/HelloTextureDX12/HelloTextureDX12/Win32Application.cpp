#include "stdafx.h"
#include "Win32Application.h"
#include "HelloTexture.h"
using namespace std;

HWND Win32Application::m_hWnd = nullptr;
HINSTANCE Win32Application::m_hInst = nullptr;
// The c++ 11 standard has overload operator = to enable unique_ptr equals to a nullptr
// Thus, m_dxInst.Get() will return nullptr.
unique_ptr<HelloTexture> Win32Application::m_dxInst = nullptr;

HRESULT Win32Application::InitWindow(HINSTANCE hInstance, int nCmdShow)
{
    static const std::uint32_t width = 800;
    static const std::uint32_t height = 600;
    // initialize hello triangle dx component
    m_dxInst = make_unique<HelloTexture>(width, height);

    // Register class
    WNDCLASSEX wcex;
    wcex.cbSize = sizeof(WNDCLASSEX);
    wcex.style = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc = WindowProc;
    wcex.cbClsExtra = 0;
    wcex.cbWndExtra = 0;
    wcex.hInstance = hInstance;
    wcex.hIcon = LoadIcon(hInstance, (LPCTSTR)IDI_ICON1);
    wcex.hCursor = LoadCursor(nullptr, IDC_ARROW);
    wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
    wcex.lpszMenuName = nullptr;
    wcex.lpszClassName = L"TutorialWindowClass";
    wcex.hIconSm = LoadIcon(wcex.hInstance, (LPCTSTR)IDI_ICON1);
    if (!RegisterClassEx(&wcex))
        return E_FAIL;

    // Create window
    m_hInst = hInstance;
    RECT rc = { 0, 0, static_cast<LONG>(width), static_cast<LONG>(height) };
    AdjustWindowRect(&rc, WS_OVERLAPPEDWINDOW, FALSE);
    m_hWnd = CreateWindow(L"TutorialWindowClass", L"Direct3D 12 Demo",
        WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX,
        CW_USEDEFAULT, CW_USEDEFAULT, rc.right - rc.left, rc.bottom - rc.top, nullptr, nullptr, hInstance,
        nullptr);
    if (!m_hWnd)
    {
        return E_FAIL;
    }

    // DXinit requires window init.
    m_dxInst->OnInit();

    ShowWindow(m_hWnd, nCmdShow);

    return S_OK;
}


LRESULT Win32Application::WindowProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    //PAINTSTRUCT ps;
    //HDC hdc;

    switch (message)
    {
    case WM_PAINT:
        //hdc = BeginPaint(hWnd, &ps);
        //EndPaint(hWnd, &ps);
        m_dxInst->OnUpdate();
        m_dxInst->OnRender();
        break;

    case WM_DESTROY:
        m_dxInst->OnDestroy();
        PostQuitMessage(0);
        break;

        // Note that this tutorial does not handle resizing (WM_SIZE) requests,
        // so we created the window without the resize border.

    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
    }

    return 0;
}


int WINAPI wWinMain(_In_ HINSTANCE hInstance, _In_opt_ HINSTANCE hPrevInstance, _In_ LPWSTR lpCmdLine, _In_ int nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

    if (FAILED(Win32Application::InitWindow(hInstance, nCmdShow)))
    {
        return -1;
    }


    // Main message loop
    MSG msg = { 0 };
    while (WM_QUIT != msg.message)
    {
        if (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
    }

    return (int)msg.wParam;
}
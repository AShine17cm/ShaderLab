#pragma once


class HelloTriangle
{
public:
    HelloTriangle(std::uint32_t width, std::uint32_t height);
    void OnInit();
    void OnUpdate();
    void OnRender();
    void OnDestroy();

private:
    void LoadPipeline();
    void LoadAssets();
    void PopulateCommandList();
    void WaitForPreviousFrame();

    static const std::uint32_t FrameCount = 2;

    // Vertex infomation
    struct Vertex
    {
        DirectX::XMFLOAT3 position;
        DirectX::XMFLOAT4 color;
    };

    // Pipeline objects
    D3D12_VIEWPORT m_viewport;
    D3D12_RECT m_scissorRect;
    Microsoft::WRL::ComPtr<IDXGISwapChain4> m_swapChain;
    Microsoft::WRL::ComPtr<ID3D12Device> m_device;
    Microsoft::WRL::ComPtr<ID3D12Resource> m_renderTargets[FrameCount];
    Microsoft::WRL::ComPtr<ID3D12CommandAllocator> m_commandAllocator;
    Microsoft::WRL::ComPtr<ID3D12CommandQueue> m_commandQueue;
    Microsoft::WRL::ComPtr<ID3D12RootSignature> m_rootSignature;
    Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> m_rtvHeap;
    Microsoft::WRL::ComPtr<ID3D12PipelineState> m_pipelineState;
    Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> m_commandList;
    std::uint32_t m_rtvDescriptorSize;

    // App resources
    Microsoft::WRL::ComPtr<ID3D12Resource> m_vertexBuffer;
    D3D12_VERTEX_BUFFER_VIEW m_vertexBufferView;

    // Synchronization objects
    std::uint32_t m_frameIndex;
    HANDLE m_fenceEvent;
    Microsoft::WRL::ComPtr<ID3D12Fence> m_fence;
    std::uint64_t m_fenceValue;

    // Adapter info
    bool m_useWarpDevice;

    // misc
    float m_aspectRatio;
    std::uint32_t m_width;
    std::uint32_t m_height;
};

inline void ThrowIfFailed(HRESULT hr)
{
    if (FAILED(hr))
    {
        throw std::exception();
    }
}

struct IDXGIAdapter;
inline void GetHardwareAdapter(IDXGIFactory* pFactory, IDXGIAdapter** ppAdapter)
{
    Microsoft::WRL::ComPtr<IDXGIAdapter> adapter;
    *ppAdapter = nullptr;

    for (UINT adapterIndex = 0; DXGI_ERROR_NOT_FOUND != pFactory->EnumAdapters(adapterIndex, &adapter); ++adapterIndex)
    {
        DXGI_ADAPTER_DESC desc;
        adapter->GetDesc(&desc);

        // Check to see if the adapter supports Direct3D 12, but don't create the
        // actual device yet.
        if (SUCCEEDED(D3D12CreateDevice(adapter.Get(), D3D_FEATURE_LEVEL_11_0, _uuidof(ID3D12Device), nullptr)))
        {
            break;
        }
    }

    *ppAdapter = adapter.Detach();
}
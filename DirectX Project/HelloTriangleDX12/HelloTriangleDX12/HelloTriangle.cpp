#include "stdafx.h"
#include "HelloTriangle.h"
#include "Win32Application.h"

using namespace DirectX;
using namespace std;
using namespace Microsoft::WRL;

HelloTriangle::HelloTriangle(std::uint32_t width, std::uint32_t height)
    :m_frameIndex(0),
    m_rtvDescriptorSize(0),
    m_vertexBufferView({ 0 }),
    m_fenceEvent(nullptr),
    m_fenceValue(0),
    m_useWarpDevice(false)
{
    m_height = height;
    m_width = width;

    m_viewport.TopLeftX = 0.0f;
    m_viewport.TopLeftY = 0.0f;
    m_viewport.MaxDepth = D3D12_MAX_DEPTH;
    m_viewport.MinDepth = D3D12_MIN_DEPTH;
    m_viewport.Height = static_cast<FLOAT>(height);
    m_viewport.Width = static_cast<FLOAT>(width);

    m_scissorRect.left = 0;
    m_scissorRect.top = 0;
    m_scissorRect.right = static_cast<LONG>(width);
    m_scissorRect.bottom = static_cast<LONG>(height);

    m_aspectRatio = static_cast<float>(width) / static_cast<float>(height);
}

void HelloTriangle::OnInit()
{
    LoadPipeline();
    LoadAssets();
}

void HelloTriangle::LoadPipeline()
{
    // Enable the debug layer (requires the Graphics Tools "optional feature").
#pragma region Enable debug layer
    uint32_t dxgiFactoryFlags = 0;
    // NOTE: Enabling the debug layer after device creation will invalidate the active device.
#if defined(_DEBUG)
    // Enable debug layer
    ComPtr<ID3D12Debug1> debugController;

    if (SUCCEEDED(D3D12GetDebugInterface(IID_PPV_ARGS(&debugController))))
    {
        debugController->EnableDebugLayer();

        // Enable additional layers
        dxgiFactoryFlags |= DXGI_CREATE_FACTORY_DEBUG;
    }
#endif
#pragma endregion

    // Create device
#pragma region Create Device
    ComPtr<IDXGIFactory5> factory;
    ComPtr<IDXGIAdapter> hardwareAdapter;

    ThrowIfFailed(CreateDXGIFactory2(dxgiFactoryFlags, IID_PPV_ARGS(&factory)));
    GetHardwareAdapter(factory.Get(), &hardwareAdapter);

    ThrowIfFailed(D3D12CreateDevice(
        hardwareAdapter.Get(),
        D3D_FEATURE_LEVEL_11_0,
        IID_PPV_ARGS(&m_device)));

#pragma endregion

    // Fill out a command queue description, then create the command queue
#pragma region Command Queue
    D3D12_COMMAND_QUEUE_DESC queueDesc = {};
    DXGI_SWAP_CHAIN_DESC1 swapChainDesc = {};

    queueDesc.Flags = D3D12_COMMAND_QUEUE_FLAG_NONE;
    queueDesc.Type = D3D12_COMMAND_LIST_TYPE_DIRECT;

    ThrowIfFailed(m_device->CreateCommandQueue(&queueDesc, IID_PPV_ARGS(&m_commandQueue)));
#pragma endregion

    // Fill out a swapchain description, then create the swap chain:
#pragma region Swap chain
    ComPtr<IDXGISwapChain1> swapChain;

    // Describe and create the swap chain.
    swapChainDesc.BufferCount = FrameCount;
    swapChainDesc.Width = m_width;
    swapChainDesc.Height = m_height;
    swapChainDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    swapChainDesc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    swapChainDesc.SwapEffect = DXGI_SWAP_EFFECT_FLIP_DISCARD;
    swapChainDesc.SampleDesc.Count = 1;

    ThrowIfFailed(factory->CreateSwapChainForHwnd(
        m_commandQueue.Get(),		// Swap chain needs the queue so that it can force a flush on it.
        Win32Application::GetHwnd(),
        &swapChainDesc,
        nullptr,
        nullptr,
        &swapChain
    ));

    ThrowIfFailed(factory->MakeWindowAssociation(Win32Application::GetHwnd(), DXGI_MWA_NO_ALT_ENTER));
    ThrowIfFailed(swapChain.As(&m_swapChain));
    m_frameIndex = m_swapChain->GetCurrentBackBufferIndex();

#pragma endregion

    // Fill out a heap description, then create a descriptor heap
#pragma region Descriptor Heap
    D3D12_DESCRIPTOR_HEAP_DESC rtvHeapDesc = {};

    // Create descriptor heaps.
        // Describe and create a render target view (RTV) descriptor heap.
    rtvHeapDesc.NumDescriptors = FrameCount;
    rtvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
    rtvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
    ThrowIfFailed(m_device->CreateDescriptorHeap(&rtvHeapDesc, IID_PPV_ARGS(&m_rtvHeap)));

    m_rtvDescriptorSize = m_device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
#pragma endregion

    // Create a render target view (RTV).
#pragma region Render target view (RTV)
    // Create frame resources.
    D3D12_CPU_DESCRIPTOR_HANDLE rtvHandle(m_rtvHeap->GetCPUDescriptorHandleForHeapStart());
    // Create a RTV for each frame.
    for (UINT n = 0; n < FrameCount; n++)
    {
        ThrowIfFailed(m_swapChain->GetBuffer(n, IID_PPV_ARGS(&m_renderTargets[n])));
        m_device->CreateRenderTargetView(m_renderTargets[n].Get(), nullptr, rtvHandle);
        //rtvHandle.Offset(1, m_rtvDescriptorSize);
        rtvHandle.ptr += 1 * m_rtvDescriptorSize;
    }
#pragma endregion

    // Create the command allocator
#pragma region Command Allocator
    ThrowIfFailed(m_device->CreateCommandAllocator(D3D12_COMMAND_LIST_TYPE_DIRECT, IID_PPV_ARGS(&m_commandAllocator)));
#pragma endregion
}

void HelloTriangle::LoadAssets()
{
    // Create an empty root signature.
#pragma region Empty Root Signature
    D3D12_ROOT_SIGNATURE_DESC rootSignatureDesc;
    //rootSignatureDesc.Init(0, nullptr, 0, nullptr, D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);
    rootSignatureDesc.NumParameters = 0;
    rootSignatureDesc.pParameters = nullptr;
    rootSignatureDesc.NumStaticSamplers = 0;
    rootSignatureDesc.pStaticSamplers = nullptr;
    rootSignatureDesc.Flags = D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT;

    ComPtr<ID3DBlob> signature;
    ComPtr<ID3DBlob> error;
    ThrowIfFailed(D3D12SerializeRootSignature(&rootSignatureDesc, D3D_ROOT_SIGNATURE_VERSION_1, &signature, &error));
    ThrowIfFailed(m_device->CreateRootSignature(0, signature->GetBufferPointer(), signature->GetBufferSize(), IID_PPV_ARGS(&m_rootSignature)));
#pragma endregion

    // Load and compile shaders
#pragma region Shaders
    // Create the pipeline state, which includes compiling and loading shaders.
    ComPtr<ID3DBlob> vertexShader;
    ComPtr<ID3DBlob> pixelShader;

#if defined(_DEBUG)
    // Enable better shader debugging with the graphics debugging tools.
    UINT compileFlags = D3DCOMPILE_DEBUG | D3DCOMPILE_SKIP_OPTIMIZATION;
#else
    UINT compileFlags = 0;
#endif

    ThrowIfFailed(D3DCompileFromFile(std::wstring(L"shaders.hlsl").c_str(), nullptr, nullptr, "VSMain", "vs_5_0", compileFlags, 0, &vertexShader, nullptr));
    ThrowIfFailed(D3DCompileFromFile(std::wstring(L"shaders.hlsl").c_str(), nullptr, nullptr, "PSMain", "ps_5_0", compileFlags, 0, &pixelShader, nullptr));
#pragma endregion

    // Create the vertex input layout
#pragma region Vertex Input Layout
    // Define the vertex input layout.
    D3D12_INPUT_ELEMENT_DESC inputElementDescs[] =
    {
        { "POSITION", 0, DXGI_FORMAT_R32G32B32_FLOAT, 0, 0, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 },
        { "COLOR", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 }
    };
#pragma endregion

    // Fill out a pipeline state description, using the helper structures available, then create the graphics pipeline state
#pragma region Graphics Pipeline State
    // Describe and create the graphics pipeline state object (PSO).
    D3D12_GRAPHICS_PIPELINE_STATE_DESC psoDesc = {};

    // Vertex shader
    D3D12_SHADER_BYTECODE vsCode;
    vsCode.BytecodeLength = vertexShader.Get()->GetBufferSize();
    vsCode.pShaderBytecode = vertexShader.Get()->GetBufferPointer();
    psoDesc.VS = vsCode;

    // rasterizer desc
    D3D12_RASTERIZER_DESC rdesc;
    rdesc.FillMode = D3D12_FILL_MODE_SOLID;
    rdesc.CullMode = D3D12_CULL_MODE_BACK;
    rdesc.FrontCounterClockwise = FALSE;
    rdesc.DepthBias = D3D12_DEFAULT_DEPTH_BIAS;
    rdesc.DepthBiasClamp = D3D12_DEFAULT_DEPTH_BIAS_CLAMP;
    rdesc.SlopeScaledDepthBias = D3D12_DEFAULT_SLOPE_SCALED_DEPTH_BIAS;
    rdesc.DepthClipEnable = TRUE;
    rdesc.MultisampleEnable = FALSE;
    rdesc.AntialiasedLineEnable = FALSE;
    rdesc.ForcedSampleCount = 0;
    rdesc.ConservativeRaster = D3D12_CONSERVATIVE_RASTERIZATION_MODE_OFF;

    // blend desc
    D3D12_BLEND_DESC bdesc;
    bdesc.AlphaToCoverageEnable = FALSE;
    bdesc.IndependentBlendEnable = FALSE;
    const D3D12_RENDER_TARGET_BLEND_DESC defaultRenderTargetBlendDesc =
    {
        FALSE,FALSE,
        D3D12_BLEND_ONE, D3D12_BLEND_ZERO, D3D12_BLEND_OP_ADD,
        D3D12_BLEND_ONE, D3D12_BLEND_ZERO, D3D12_BLEND_OP_ADD,
        D3D12_LOGIC_OP_NOOP,
        D3D12_COLOR_WRITE_ENABLE_ALL,
    };
    for (uint32_t i = 0; i < D3D12_SIMULTANEOUS_RENDER_TARGET_COUNT; ++i)
    {
        bdesc.RenderTarget[i] = defaultRenderTargetBlendDesc;
    }

    // Pixel shader
    D3D12_SHADER_BYTECODE psCode;
    psCode.BytecodeLength = pixelShader.Get()->GetBufferSize();
    psCode.pShaderBytecode = pixelShader.Get()->GetBufferPointer();
    psoDesc.PS = psCode;

    psoDesc.InputLayout = { inputElementDescs, _countof(inputElementDescs) };
    psoDesc.pRootSignature = m_rootSignature.Get();
    //psoDesc.RasterizerState = D3D12_RASTERIZER_DESC();
    psoDesc.RasterizerState = rdesc;
    //psoDesc.BlendState = D3D12_BLEND_DESC();
    psoDesc.BlendState = bdesc;
    psoDesc.DepthStencilState.DepthEnable = FALSE;
    psoDesc.DepthStencilState.StencilEnable = FALSE;
    psoDesc.SampleMask = UINT_MAX;
    psoDesc.PrimitiveTopologyType = D3D12_PRIMITIVE_TOPOLOGY_TYPE_TRIANGLE;
    psoDesc.NumRenderTargets = 1;
    psoDesc.RTVFormats[0] = DXGI_FORMAT_R8G8B8A8_UNORM;
    psoDesc.SampleDesc.Count = 1;
    ThrowIfFailed(m_device->CreateGraphicsPipelineState(&psoDesc, IID_PPV_ARGS(&m_pipelineState)));
#pragma endregion

    //Create, then close, a command list
#pragma region Command List
    // Create the command list.
    ThrowIfFailed(m_device->CreateCommandList(0, D3D12_COMMAND_LIST_TYPE_DIRECT, m_commandAllocator.Get(), m_pipelineState.Get(), IID_PPV_ARGS(&m_commandList)));
    // Command lists are created in the recording state, but there is nothing
    // to record yet. The main loop expects it to be closed, so close it now.
    ThrowIfFailed(m_commandList->Close());
#pragma endregion

    // Create the vertex buffer
#pragma region Vertex Buffer
    // Create the vertex buffer.
        // Define the geometry for a triangle.
    Vertex triangleVertices[] =
    {
        { { 0.0f, 0.25f * m_aspectRatio, 0.0f },{ 1.0f, 0.0f, 0.0f, 1.0f } },
        { { 0.25f, -0.25f * m_aspectRatio, 0.0f },{ 0.0f, 1.0f, 0.0f, 1.0f } },
        { { -0.25f, -0.25f * m_aspectRatio, 0.0f },{ 0.0f, 0.0f, 1.0f, 1.0f } }
    };

    const UINT vertexBufferSize = sizeof(triangleVertices);

    // Note: using upload heaps to transfer static data like vert buffers is not 
    // recommended. Every time the GPU needs it, the upload heap will be marshalled 
    // over. Please read up on Default Heap usage. An upload heap is used here for 
    // code simplicity and because there are very few verts to actually transfer.
    D3D12_HEAP_PROPERTIES prop;
    prop.Type = D3D12_HEAP_TYPE_UPLOAD;
    prop.CPUPageProperty = D3D12_CPU_PAGE_PROPERTY_UNKNOWN;
    prop.MemoryPoolPreference = D3D12_MEMORY_POOL_UNKNOWN;
    prop.CreationNodeMask = 1;
    prop.VisibleNodeMask = 1;

    D3D12_RESOURCE_DESC resd;
    resd.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
    resd.Alignment = 0;
    resd.Width = vertexBufferSize;
    resd.Height = 1;
    resd.DepthOrArraySize = 1;
    resd.MipLevels = 1;
    resd.Format = DXGI_FORMAT_UNKNOWN;
    resd.SampleDesc.Count = 1;
    resd.SampleDesc.Quality = 0;
    resd.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    resd.Flags = D3D12_RESOURCE_FLAG_NONE;

    ThrowIfFailed(m_device->CreateCommittedResource(
        &prop,
        D3D12_HEAP_FLAG_NONE,
        &resd,
        D3D12_RESOURCE_STATE_GENERIC_READ,
        nullptr,
        IID_PPV_ARGS(&m_vertexBuffer)));
#pragma endregion

    //Copy the vertex data to the vertex buffer:
#pragma region Copy
    // Copy the triangle data to the vertex buffer.
    UINT8* pVertexDataBegin;

    // We do not intend to read from this resource on the CPU.
    D3D12_RANGE readRange;
    readRange.Begin = 0ul;
    readRange.End = 0ul;

    ThrowIfFailed(m_vertexBuffer->Map(0, &readRange, reinterpret_cast<void**>(&pVertexDataBegin)));
    // Is it security?
    std::memcpy(pVertexDataBegin, triangleVertices, sizeof(triangleVertices));
    m_vertexBuffer->Unmap(0, nullptr);
#pragma endregion

    // Initialize the vertex buffer view.
#pragma region Vertex buffer view
    m_vertexBufferView.BufferLocation = m_vertexBuffer->GetGPUVirtualAddress();
    m_vertexBufferView.StrideInBytes = sizeof(Vertex);
    m_vertexBufferView.SizeInBytes = vertexBufferSize;
#pragma endregion

    //Create and initialize the fence
#pragma region Fence
    // Create synchronization objects and wait until assets have been uploaded to the GPU.
    ThrowIfFailed(m_device->CreateFence(0, D3D12_FENCE_FLAG_NONE, IID_PPV_ARGS(&m_fence)));
    m_fenceValue = 1;
#pragma endregion

    // Create an event handle to use for frame synchronization.
#pragma region Synchronization
    m_fenceEvent = CreateEvent(nullptr, FALSE, FALSE, nullptr);
    if (m_fenceEvent == nullptr)
    {
        ThrowIfFailed(HRESULT_FROM_WIN32(GetLastError()));
    }
#pragma endregion

    // Wait for GPU to finish
#pragma region GPU waiting
    // Wait for the command list to execute; we are reusing the same command 
    // list in our main loop but for now, we just want to wait for setup to 
    // complete before continuing.
    WaitForPreviousFrame();
#pragma endregion
}

void HelloTriangle::OnUpdate()
{
    // We update nothing this time.
    return;
}

void HelloTriangle::OnRender()
{
    // Record all the commands we need to render the scene into the command list.
    PopulateCommandList();

    // Execute the command list.
    ID3D12CommandList* ppCommandLists[] = { m_commandList.Get() };
    m_commandQueue->ExecuteCommandLists(_countof(ppCommandLists), ppCommandLists);

    // Present the frame.
    ThrowIfFailed(m_swapChain->Present(1, 0));

    WaitForPreviousFrame();
}

void HelloTriangle::OnDestroy()
{
    // Wait for the GPU to be done with all resources.
    WaitForPreviousFrame();

    // Close event
    CloseHandle(m_fenceEvent);
}

void HelloTriangle::PopulateCommandList()
{
    // Reset the command allocator, and command list
#pragma region Reset
    // Command list allocators can only be reset when the associated 
    // command lists have finished execution on the GPU; apps should use 
    // fences to determine GPU execution progress.
    ThrowIfFailed(m_commandAllocator->Reset());

    // However, when ExecuteCommandList() is called on a particular command 
    // list, that command list can then be reset at any time and must be before 
    // re-recording.
    ThrowIfFailed(m_commandList->Reset(m_commandAllocator.Get(), m_pipelineState.Get()));
#pragma endregion

    // Set the root signature, viewport and scissors rectangles
#pragma region Set
    // Set necessary state.
    m_commandList->SetGraphicsRootSignature(m_rootSignature.Get());
    m_commandList->RSSetViewports(1, &m_viewport);
    m_commandList->RSSetScissorRects(1, &m_scissorRect);
#pragma endregion

    // Indicate that the back buffer is to be used as a render target
#pragma region Back buffer
    D3D12_RESOURCE_BARRIER bar;
    bar.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    bar.Flags = D3D12_RESOURCE_BARRIER_FLAG_NONE;
    bar.Transition.pResource = m_renderTargets[m_frameIndex].Get();
    bar.Transition.StateBefore = D3D12_RESOURCE_STATE_PRESENT;
    bar.Transition.StateAfter = D3D12_RESOURCE_STATE_RENDER_TARGET;
    bar.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;

    // Indicate that the back buffer will be used as a render target.
    m_commandList->ResourceBarrier(1, &bar);

    //D3D12_CPU_DESCRIPTOR_HANDLE rtvHandle(m_rtvHeap->GetCPUDescriptorHandleForHeapStart(), m_frameIndex, m_rtvDescriptorSize);
    D3D12_CPU_DESCRIPTOR_HANDLE rtvHandle;
    rtvHandle.ptr = m_rtvHeap->GetCPUDescriptorHandleForHeapStart().ptr
        + static_cast<uint64_t>(m_frameIndex) * static_cast<uint64_t>(m_rtvDescriptorSize);
    m_commandList->OMSetRenderTargets(1, &rtvHandle, FALSE, nullptr);
#pragma endregion

    // Record commands.
#pragma region Record
    const float clearColor[] = { 0.0f, 0.2f, 0.4f, 1.0f };
    m_commandList->ClearRenderTargetView(rtvHandle, clearColor, 0, nullptr);
    m_commandList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    m_commandList->IASetVertexBuffers(0, 1, &m_vertexBufferView);
    m_commandList->DrawInstanced(3, 1, 0, 0);
#pragma endregion

#pragma region Not used back buffer
    // Indicate that the back buffer will now be used to present.
    D3D12_RESOURCE_BARRIER bar2;
    bar2.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    bar2.Flags = D3D12_RESOURCE_BARRIER_FLAG_NONE;
    bar2.Transition.pResource = m_renderTargets[m_frameIndex].Get();
    bar2.Transition.StateBefore = D3D12_RESOURCE_STATE_RENDER_TARGET;
    bar2.Transition.StateAfter = D3D12_RESOURCE_STATE_PRESENT;
    bar2.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    m_commandList->ResourceBarrier(1, &bar2);
#pragma endregion

    // Close command list
#pragma region Close
    ThrowIfFailed(m_commandList->Close());
#pragma endregion
}

void HelloTriangle::WaitForPreviousFrame()
{
    // WAITING FOR THE FRAME TO COMPLETE BEFORE CONTINUING IS NOT BEST PRACTICE.
    // This is code implemented as such for simplicity. The D3D12HelloFrameBuffering
    // sample illustrates how to use fences for efficient resource usage and to
    // maximize GPU utilization.

    // Signal and increment the fence value.
    const UINT64 fence = m_fenceValue;
    ThrowIfFailed(m_commandQueue->Signal(m_fence.Get(), fence));
    m_fenceValue++;

    // Wait until the previous frame is finished.
    if (m_fence->GetCompletedValue() < fence)
    {
        ThrowIfFailed(m_fence->SetEventOnCompletion(fence, m_fenceEvent));
        WaitForSingleObject(m_fenceEvent, INFINITE);
    }

    m_frameIndex = m_swapChain->GetCurrentBackBufferIndex();
}

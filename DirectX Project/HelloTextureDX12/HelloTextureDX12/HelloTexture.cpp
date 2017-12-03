#include "stdafx.h"
#include "HelloTexture.h"
#include "Win32Application.h"

using namespace DirectX;
using namespace std;
using namespace Microsoft::WRL;

HelloTexture::HelloTexture(std::uint32_t width, std::uint32_t height)
    :m_frameIndex(0), m_rtvDescriptorSize(0)
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

void HelloTexture::OnInit()
{
    LoadPipeline();
    LoadAssets();
}

void HelloTexture::LoadPipeline()
{
    // Enable the debug layer (requires the Graphics Tools "optional feature").
#pragma region Enable debug layer
    // NOTE: Enabling the debug layer after device creation will invalidate the active device.
#if defined(_DEBUG)
    uint32_t dxgiFactoryFlags = 0;
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
    swapChainDesc.BufferCount = frameCount;
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
    rtvHeapDesc.NumDescriptors = frameCount;
    rtvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_RTV;
    rtvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_NONE;
    ThrowIfFailed(m_device->CreateDescriptorHeap(&rtvHeapDesc, IID_PPV_ARGS(&m_rtvHeap)));

    // Describe and create a shader resource view (SRV) heap for the texture.
    D3D12_DESCRIPTOR_HEAP_DESC srvHeapDesc = {};
    srvHeapDesc.NumDescriptors = 1;
    srvHeapDesc.Type = D3D12_DESCRIPTOR_HEAP_TYPE_CBV_SRV_UAV;
    srvHeapDesc.Flags = D3D12_DESCRIPTOR_HEAP_FLAG_SHADER_VISIBLE;
    ThrowIfFailed(m_device->CreateDescriptorHeap(&srvHeapDesc, IID_PPV_ARGS(&m_srvHeap)));

    m_rtvDescriptorSize = m_device->GetDescriptorHandleIncrementSize(D3D12_DESCRIPTOR_HEAP_TYPE_RTV);
#pragma endregion

    // Create a render target view (RTV).
#pragma region Render target view (RTV)
    // Create frame resources.
    D3D12_CPU_DESCRIPTOR_HANDLE rtvHandle(m_rtvHeap->GetCPUDescriptorHandleForHeapStart());
    // Create a RTV for each frame.
    for (UINT n = 0; n < frameCount; n++)
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

void HelloTexture::LoadAssets()
{
    // Create an empty root signature.
#pragma region Root Signature
    D3D12_FEATURE_DATA_ROOT_SIGNATURE featureData = {};

    // This is the highest version the sample supports. If CheckFeatureSupport succeeds, the HighestVersion returned will not be greater than this.
    featureData.HighestVersion = D3D_ROOT_SIGNATURE_VERSION_1_1;

    if (FAILED(m_device->CheckFeatureSupport(D3D12_FEATURE_ROOT_SIGNATURE, &featureData, sizeof(featureData))))
    {
        featureData.HighestVersion = D3D_ROOT_SIGNATURE_VERSION_1_0;
    }

    D3D12_DESCRIPTOR_RANGE1 ranges[1];
    //ranges[0].Init(D3D12_DESCRIPTOR_RANGE_TYPE_SRV, 1, 0, 0, D3D12_DESCRIPTOR_RANGE_FLAG_DATA_STATIC);
    ranges[0].RangeType = D3D12_DESCRIPTOR_RANGE_TYPE_SRV;
    ranges[0].NumDescriptors = 1u;
    ranges[0].BaseShaderRegister = 0u;
    ranges[0].RegisterSpace = 0u;
    ranges[0].Flags = D3D12_DESCRIPTOR_RANGE_FLAG_DATA_STATIC;
    ranges[0].OffsetInDescriptorsFromTableStart = D3D12_DESCRIPTOR_RANGE_OFFSET_APPEND;

    D3D12_ROOT_PARAMETER1 rootParameters[1];
    //rootParameters[0].InitAsDescriptorTable(1, &ranges[0], D3D12_SHADER_VISIBILITY_PIXEL);

    auto fxxkfunc = [&](std::uint32_t numDescriptorRanges, _In_reads_(numDescriptorRanges) const D3D12_DESCRIPTOR_RANGE1* pDescriptorRanges) -> void
    {
        rootParameters[0].ParameterType = D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE;
        rootParameters[0].ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;
        rootParameters[0].DescriptorTable.NumDescriptorRanges = numDescriptorRanges;
        rootParameters[0].DescriptorTable.pDescriptorRanges = &ranges[0];
    };

    fxxkfunc(1, &ranges[0]);

    D3D12_STATIC_SAMPLER_DESC sampler = {};
    sampler.Filter = D3D12_FILTER_MIN_MAG_MIP_POINT;
    sampler.AddressU = D3D12_TEXTURE_ADDRESS_MODE_BORDER;
    sampler.AddressV = D3D12_TEXTURE_ADDRESS_MODE_BORDER;
    sampler.AddressW = D3D12_TEXTURE_ADDRESS_MODE_BORDER;
    sampler.MipLODBias = 0;
    sampler.MaxAnisotropy = 0;
    sampler.ComparisonFunc = D3D12_COMPARISON_FUNC_NEVER;
    sampler.BorderColor = D3D12_STATIC_BORDER_COLOR_TRANSPARENT_BLACK;
    sampler.MinLOD = 0.0f;
    sampler.MaxLOD = D3D12_FLOAT32_MAX;
    sampler.ShaderRegister = 0;
    sampler.RegisterSpace = 0;
    sampler.ShaderVisibility = D3D12_SHADER_VISIBILITY_PIXEL;

    D3D12_VERSIONED_ROOT_SIGNATURE_DESC rootSignatureDesc;
    //rootSignatureDesc.Init_1_1(_countof(rootParameters), rootParameters, 1, &sampler, D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT);
    rootSignatureDesc.Version = D3D_ROOT_SIGNATURE_VERSION_1_1;
    rootSignatureDesc.Desc_1_1.NumParameters = _countof(rootParameters);
    rootSignatureDesc.Desc_1_1.pParameters = rootParameters;
    rootSignatureDesc.Desc_1_1.NumStaticSamplers = 1;
    rootSignatureDesc.Desc_1_1.pStaticSamplers = &sampler;
    rootSignatureDesc.Desc_1_1.Flags = D3D12_ROOT_SIGNATURE_FLAG_ALLOW_INPUT_ASSEMBLER_INPUT_LAYOUT;

    ComPtr<ID3DBlob> signature;
    ComPtr<ID3DBlob> error;

    ThrowIfFailed(CustomD3D12SerializeVersionedRootSignature(&rootSignatureDesc, featureData.HighestVersion, &signature, &error));
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
        //{ "COLOR", 0, DXGI_FORMAT_R32G32B32A32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 }
        { "TEXCOORD", 0, DXGI_FORMAT_R32G32_FLOAT, 0, 12, D3D12_INPUT_CLASSIFICATION_PER_VERTEX_DATA, 0 }
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
    // NOTICE: not applicatible here.
    //ThrowIfFailed(m_commandList->Close());
#pragma endregion

    // Create the vertex buffer
#pragma region Vertex Buffer
    // Create the vertex buffer.
    // Define the geometry for a triangle.
    Vertex vertexList[] =
    {
        { { -0.25f, 0.25f * m_aspectRatio, 0.0f },{ 0.0f, 0.0f } },
        { { 0.25f, 0.25f * m_aspectRatio, 0.0f },{ 1.0f, 0.0f } },
        { { -0.25f, -0.25f * m_aspectRatio, 0.0f },{ 0.0f, 1.0f } },
        { { 0.25f, -0.25f*m_aspectRatio, 0.0f },{ 1.0f, 1.0f } }
    };

    const UINT vertexBufferSize = sizeof(vertexList);

    // Note: using upload heaps to transfer static data like vert buffers is not 
    // recommended. Every time the GPU needs it, the upload heap will be marshalled 
    // over. Please read up on Default Heap usage. An upload heap is used here for 
    // code simplicity and because there are very few verts to actually transfer.
    const D3D12_HEAP_PROPERTIES heapPropDefault
    {
        D3D12_HEAP_TYPE_DEFAULT,
        D3D12_CPU_PAGE_PROPERTY_UNKNOWN,
        D3D12_MEMORY_POOL_UNKNOWN,
        1,
        1
    };

    const D3D12_HEAP_PROPERTIES heapPropUpload
    {
        D3D12_HEAP_TYPE_UPLOAD,
        D3D12_CPU_PAGE_PROPERTY_UNKNOWN,
        D3D12_MEMORY_POOL_UNKNOWN,
        1,
        1
    };

    D3D12_RESOURCE_DESC vertexResDesc;
    vertexResDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
    vertexResDesc.Alignment = 0;
    vertexResDesc.Width = vertexBufferSize;
    vertexResDesc.Height = 1;
    vertexResDesc.DepthOrArraySize = 1;
    vertexResDesc.MipLevels = 1;
    vertexResDesc.Format = DXGI_FORMAT_UNKNOWN;
    vertexResDesc.SampleDesc.Count = 1;
    vertexResDesc.SampleDesc.Quality = 0;
    vertexResDesc.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    vertexResDesc.Flags = D3D12_RESOURCE_FLAG_NONE;

    ThrowIfFailed(m_device->CreateCommittedResource(
        &heapPropDefault,
        D3D12_HEAP_FLAG_NONE,
        &vertexResDesc,
        D3D12_RESOURCE_STATE_COPY_DEST, // copy data from upload heap to this heap.
        nullptr,
        IID_PPV_ARGS(&m_vertexBuffer)));
    m_vertexBuffer->SetName(L"Vertex Buffer Resource");

    ComPtr<ID3D12Resource> vertexBufferUploadHeap;

    ThrowIfFailed(m_device->CreateCommittedResource(
        &heapPropUpload,
        D3D12_HEAP_FLAG_NONE,
        &vertexResDesc,
        D3D12_RESOURCE_STATE_GENERIC_READ,
        nullptr,
        IID_PPV_ARGS(&vertexBufferUploadHeap)));
    vertexBufferUploadHeap->SetName(L"Vertex Buffer Upload Resource");

    D3D12_SUBRESOURCE_DATA vertexData;
    vertexData.pData = reinterpret_cast<BYTE *>(vertexList);
    vertexData.RowPitch = vertexBufferSize;
    vertexData.SlicePitch = vertexBufferSize;

    // we are now creating a command with the command list to copy the data from
    // the upload heap to the default heap
    UpdateSubresources(m_commandList.Get(), m_vertexBuffer.Get(), vertexBufferUploadHeap.Get(), 0, 0, 1, &vertexData);

    D3D12_RESOURCE_BARRIER vertexResBar;
    vertexResBar.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    vertexResBar.Flags = D3D12_RESOURCE_BARRIER_FLAG_NONE;
    vertexResBar.Transition.pResource = m_vertexBuffer.Get();
    vertexResBar.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
    vertexResBar.Transition.StateAfter = D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER;
    vertexResBar.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;

    // transition the vertex buffer data from copy destination state to vertex buffer state
    m_commandList->ResourceBarrier(1, &vertexResBar);

#pragma endregion

#pragma region Index Buffer
    DWORD indexList[] =
    {
        0, 1, 2, // the first triangle.
        2, 1, 3 // the second triangle
    };
    const UINT indexBufferSize = sizeof(indexList);

    D3D12_RESOURCE_DESC indexResDesc;
    indexResDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
    indexResDesc.Alignment = 0;
    indexResDesc.Width = indexBufferSize;
    indexResDesc.Height = 1;
    indexResDesc.DepthOrArraySize = 1;
    indexResDesc.MipLevels = 1;
    indexResDesc.Format = DXGI_FORMAT_UNKNOWN;
    indexResDesc.SampleDesc.Count = 1;
    indexResDesc.SampleDesc.Quality = 0;
    indexResDesc.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    indexResDesc.Flags = D3D12_RESOURCE_FLAG_NONE;

    ThrowIfFailed(m_device->CreateCommittedResource(
        &heapPropDefault,
        D3D12_HEAP_FLAG_NONE,
        &indexResDesc,
        D3D12_RESOURCE_STATE_COPY_DEST,
        nullptr,
        IID_PPV_ARGS(&m_indexBuffer)
    ));

    m_indexBuffer->SetName(L"Index Buffer Resource");

    ComPtr<ID3D12Resource> indexBufferUploadHeap;
    ThrowIfFailed(m_device->CreateCommittedResource(
        &heapPropUpload,
        D3D12_HEAP_FLAG_NONE,
        &indexResDesc, // Todo: check error
        D3D12_RESOURCE_STATE_GENERIC_READ, // GPU will read from this buffer and copy its contents to the default heap
        nullptr,
        IID_PPV_ARGS(&indexBufferUploadHeap)
    ));

    indexBufferUploadHeap->SetName(L"Index Buffer Upload Resource");

    D3D12_SUBRESOURCE_DATA indexData;
    indexData.pData = reinterpret_cast<BYTE *>(indexList);
    indexData.RowPitch = indexBufferSize;
    indexData.SlicePitch = indexBufferSize;

    UpdateSubresources(m_commandList.Get(), m_indexBuffer.Get(), indexBufferUploadHeap.Get(), 0, 0, 1, &indexData);

    D3D12_RESOURCE_BARRIER indexResBar;
    indexResBar.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    indexResBar.Flags = D3D12_RESOURCE_BARRIER_FLAG_NONE;
    indexResBar.Transition.pResource = m_indexBuffer.Get();
    indexResBar.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
    indexResBar.Transition.StateAfter = D3D12_RESOURCE_STATE_VERTEX_AND_CONSTANT_BUFFER;
    indexResBar.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;

    m_commandList->ResourceBarrier(1, &indexResBar);

#pragma endregion

    //Copy the vertex data to the vertex buffer:
#pragma region Copy
#if 0 // discard for a while
    // Copy the triangle data to the vertex buffer.
    UINT8* pVertexDataBegin;

    // We do not intend to read from this resource on the CPU.
    D3D12_RANGE readRange;
    readRange.Begin = 0ul;
    readRange.End = 0ul;

    ThrowIfFailed(m_vertexBuffer->Map(0, &readRange, reinterpret_cast<void**>(&pVertexDataBegin)));
    // Is it security?
    std::memcpy(pVertexDataBegin, vertexList, sizeof(vertexList));
    m_vertexBuffer->Unmap(0, nullptr);
#endif
#pragma endregion

    // Initialize the vertex buffer view.
#pragma region Buffer view
    m_vertexBufferView.BufferLocation = m_vertexBuffer->GetGPUVirtualAddress();
    m_vertexBufferView.StrideInBytes = sizeof(Vertex);
    m_vertexBufferView.SizeInBytes = vertexBufferSize;

    m_indexBufferView.BufferLocation = m_indexBuffer->GetGPUVirtualAddress();
    m_indexBufferView.Format = DXGI_FORMAT_R32_UINT;
    m_indexBufferView.SizeInBytes = indexBufferSize;
#pragma endregion


#pragma region Texture
    // Note: ComPtr's are CPU objects but this resource needs to stay in scope until
    // the command list that references it has finished executing on the GPU.
    // We will flush the GPU at the end of this method to ensure the resource is not
    // prematurely destroyed.
    ComPtr<ID3D12Resource> textureUploadHeap;

    // Create the texture.
    // Describe and create a Texture2D.
    D3D12_RESOURCE_DESC textureResDesc = {};
    textureResDesc.MipLevels = 1;
    textureResDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    textureResDesc.Width = textureWidth;
    textureResDesc.Height = textureHeight;
    textureResDesc.Flags = D3D12_RESOURCE_FLAG_NONE;
    textureResDesc.DepthOrArraySize = 1;
    textureResDesc.SampleDesc.Count = 1;
    textureResDesc.SampleDesc.Quality = 0;
    textureResDesc.Dimension = D3D12_RESOURCE_DIMENSION_TEXTURE2D;

    ThrowIfFailed(m_device->CreateCommittedResource(
        //&CD3DX12_HEAP_PROPERTIES(D3D12_HEAP_TYPE_DEFAULT),
        &heapPropDefault,
        D3D12_HEAP_FLAG_NONE,
        &textureResDesc,
        D3D12_RESOURCE_STATE_COPY_DEST,
        nullptr,
        IID_PPV_ARGS(&m_texture)));

    const uint64_t uploadBufferSize = GetRequiredIntermediateSize(m_texture.Get(), 0, 1);

    D3D12_RESOURCE_DESC resDesc;
    resDesc.Dimension = D3D12_RESOURCE_DIMENSION_BUFFER;
    resDesc.Alignment = 0;
    resDesc.Width = uploadBufferSize;
    resDesc.Height = 1;
    resDesc.DepthOrArraySize = 1;
    resDesc.MipLevels = 1;
    resDesc.Format = DXGI_FORMAT_UNKNOWN;
    resDesc.SampleDesc.Count = 1;
    resDesc.SampleDesc.Quality = 0;
    resDesc.Layout = D3D12_TEXTURE_LAYOUT_ROW_MAJOR;
    resDesc.Flags = D3D12_RESOURCE_FLAG_NONE;

    // Create the GPU upload buffer.
    ThrowIfFailed(m_device->CreateCommittedResource(
        &heapPropUpload,
        D3D12_HEAP_FLAG_NONE,
        &resDesc,
        D3D12_RESOURCE_STATE_GENERIC_READ,
        nullptr,
        IID_PPV_ARGS(&textureUploadHeap)));

    // Copy data to the intermediate upload heap and then schedule a copy 
    // from the upload heap to the Texture2D.
    std::vector<UINT8> texture = GenerateTextureData();

    D3D12_SUBRESOURCE_DATA textureData = {};
    textureData.pData = &texture[0];
    textureData.RowPitch = textureWidth * texturePixelSize;
    textureData.SlicePitch = textureData.RowPitch * textureHeight;

    UpdateSubresources(m_commandList.Get(), m_texture.Get(), textureUploadHeap.Get(), 0, 0, 1, &textureData);
    D3D12_RESOURCE_BARRIER resBar;
    resBar.Type = D3D12_RESOURCE_BARRIER_TYPE_TRANSITION;
    resBar.Flags = D3D12_RESOURCE_BARRIER_FLAG_NONE;
    resBar.Transition.pResource = m_texture.Get();
    resBar.Transition.StateBefore = D3D12_RESOURCE_STATE_COPY_DEST;
    resBar.Transition.StateAfter = D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE;
    resBar.Transition.Subresource = D3D12_RESOURCE_BARRIER_ALL_SUBRESOURCES;
    m_commandList->ResourceBarrier(1, &resBar);
    //m_commandList->ResourceBarrier(1, &CD3DX12_RESOURCE_BARRIER::Transition(m_texture.Get(), D3D12_RESOURCE_STATE_COPY_DEST, D3D12_RESOURCE_STATE_PIXEL_SHADER_RESOURCE));

    // Describe and create a SRV for the texture.
    D3D12_SHADER_RESOURCE_VIEW_DESC srvDesc = {};
    srvDesc.Shader4ComponentMapping = D3D12_DEFAULT_SHADER_4_COMPONENT_MAPPING;
    srvDesc.Format = textureResDesc.Format;
    srvDesc.ViewDimension = D3D12_SRV_DIMENSION_TEXTURE2D;
    srvDesc.Texture2D.MipLevels = 1;
    m_device->CreateShaderResourceView(m_texture.Get(), &srvDesc, m_srvHeap->GetCPUDescriptorHandleForHeapStart());

    // Close the command list and execute it to begin the initial GPU setup.
    ThrowIfFailed(m_commandList->Close());
    ID3D12CommandList* ppCommandLists[] = { m_commandList.Get() };
    m_commandQueue->ExecuteCommandLists(_countof(ppCommandLists), ppCommandLists);

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

void HelloTexture::OnUpdate()
{
    // We update nothing this time.
    return;
}

void HelloTexture::OnRender()
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

void HelloTexture::OnDestroy()
{
    // Wait for the GPU to be done with all resources.
    WaitForPreviousFrame();

    // Close event
    CloseHandle(m_fenceEvent);
}

void HelloTexture::PopulateCommandList()
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

    ID3D12DescriptorHeap* ppHeaps[] = { m_srvHeap.Get() };
    m_commandList->SetDescriptorHeaps(_countof(ppHeaps), ppHeaps);

    m_commandList->SetGraphicsRootDescriptorTable(0, m_srvHeap->GetGPUDescriptorHandleForHeapStart());

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
    rtvHandle.ptr = m_rtvHeap->GetCPUDescriptorHandleForHeapStart().ptr + m_frameIndex * m_rtvDescriptorSize;
    m_commandList->OMSetRenderTargets(1, &rtvHandle, FALSE, nullptr);
#pragma endregion

    // Record commands.
#pragma region Record
    const float clearColor[] = { 0.0f, 0.2f, 0.4f, 1.0f };
    m_commandList->ClearRenderTargetView(rtvHandle, clearColor, 0, nullptr);
    m_commandList->IASetPrimitiveTopology(D3D_PRIMITIVE_TOPOLOGY_TRIANGLELIST);
    m_commandList->IASetVertexBuffers(0, 1, &m_vertexBufferView);
    m_commandList->IASetIndexBuffer(&m_indexBufferView);
    m_commandList->DrawIndexedInstanced(6, 1, 0, 0, 0);
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

void HelloTexture::WaitForPreviousFrame()
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

std::vector<BYTE> HelloTexture::GenerateTextureData()
{
    const uint32_t rowPitch = textureWidth * texturePixelSize;
    const uint32_t cellPitch = rowPitch >> 3;		// The width of a cell in the checkboard texture.
    const uint32_t cellHeight = textureWidth >> 3;	// The height of a cell in the checkerboard texture.
    const uint32_t textureSize = rowPitch * textureHeight;

    vector<BYTE> data(textureSize);
    BYTE* pData = &data[0];

    for (uint32_t n = 0; n < textureSize; n += texturePixelSize)
    {
        uint32_t x = n % rowPitch;
        uint32_t y = n / rowPitch;
        uint32_t i = x / cellPitch;
        uint32_t j = y / cellHeight;

        if (i % 2 == j % 2)
        {
            pData[n] = 0x00;		// R
            pData[n + 1] = 0x00;	// G
            pData[n + 2] = 0x00;	// B
            pData[n + 3] = 0xff;	// A
        }
        else
        {
            pData[n] = 0xff;		// R
            pData[n + 1] = 0xff;	// G
            pData[n + 2] = 0xff;	// B
            pData[n + 3] = 0xff;	// A
        }
    }

    return data;
}

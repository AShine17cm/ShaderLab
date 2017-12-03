#pragma once


class HelloTexture
{
public:
    HelloTexture(std::uint32_t width, std::uint32_t height);
    void OnInit();
    void OnUpdate();
    void OnRender();
    void OnDestroy();

private:
    void LoadPipeline();
    void LoadAssets();
    void PopulateCommandList();
    void WaitForPreviousFrame();
    // DirectX 12 is such a low level api that read and process image texture
    // should be done manually instead of DirectX 12 API, so I have to use this.
    std::vector <std::uint8_t> GenerateTextureData();
    static const std::uint32_t frameCount = 2;
    static const std::uint32_t textureWidth = 256;
    static const std::uint32_t textureHeight = 256;
    static const std::uint32_t texturePixelSize = 4;	// The number of bytes used to represent a pixel in the texture.

                                                        // Vertex infomation
    struct Vertex
    {
        DirectX::XMFLOAT3 position;
        //DirectX::XMFLOAT4 color;
        DirectX::XMFLOAT2 uv;
    };

    // Pipeline objects
    D3D12_VIEWPORT m_viewport;
    D3D12_RECT m_scissorRect;
    Microsoft::WRL::ComPtr<IDXGISwapChain4> m_swapChain;
    Microsoft::WRL::ComPtr<ID3D12Device> m_device;
    Microsoft::WRL::ComPtr<ID3D12Resource> m_renderTargets[frameCount];
    Microsoft::WRL::ComPtr<ID3D12CommandAllocator> m_commandAllocator;
    Microsoft::WRL::ComPtr<ID3D12CommandQueue> m_commandQueue;
    Microsoft::WRL::ComPtr<ID3D12RootSignature> m_rootSignature;
    Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> m_rtvHeap;
    Microsoft::WRL::ComPtr<ID3D12DescriptorHeap> m_srvHeap;
    Microsoft::WRL::ComPtr<ID3D12PipelineState> m_pipelineState;
    Microsoft::WRL::ComPtr<ID3D12GraphicsCommandList> m_commandList;
    std::uint32_t m_rtvDescriptorSize;

    // App resources
    Microsoft::WRL::ComPtr<ID3D12Resource> m_vertexBuffer;
    Microsoft::WRL::ComPtr<ID3D12Resource> m_indexBuffer;
    D3D12_VERTEX_BUFFER_VIEW m_vertexBufferView;
    D3D12_INDEX_BUFFER_VIEW m_indexBufferView;
    Microsoft::WRL::ComPtr<ID3D12Resource> m_texture;

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

// Row-by-row memcpy
inline void MemcpySubresource(
    _In_ const D3D12_MEMCPY_DEST* pDest,
    _In_ const D3D12_SUBRESOURCE_DATA* pSrc,
    SIZE_T RowSizeInBytes,
    UINT NumRows,
    UINT NumSlices)
{
    for (UINT z = 0; z < NumSlices; ++z)
    {
        BYTE* pDestSlice = reinterpret_cast<BYTE*>(pDest->pData) + pDest->SlicePitch * z;
        const BYTE* pSrcSlice = reinterpret_cast<const BYTE*>(pSrc->pData) + pSrc->SlicePitch * z;
        for (UINT y = 0; y < NumRows; ++y)
        {
            memcpy(pDestSlice + pDest->RowPitch * y,
                pSrcSlice + pSrc->RowPitch * y,
                RowSizeInBytes);
        }
    }
}

inline UINT64 UpdateSubresources(
    _In_ ID3D12GraphicsCommandList* pCmdList,
    _In_ ID3D12Resource* pDestinationResource,
    _In_ ID3D12Resource* pIntermediate,
    _In_range_(0, D3D12_REQ_SUBRESOURCES) UINT FirstSubresource,
    _In_range_(0, D3D12_REQ_SUBRESOURCES - FirstSubresource) UINT NumSubresources,
    UINT64 RequiredSize,
    _In_reads_(NumSubresources) const D3D12_PLACED_SUBRESOURCE_FOOTPRINT* pLayouts,
    _In_reads_(NumSubresources) const UINT* pNumRows,
    _In_reads_(NumSubresources) const UINT64* pRowSizesInBytes,
    _In_reads_(NumSubresources) const D3D12_SUBRESOURCE_DATA* pSrcData)
{
    // Minor validation
    D3D12_RESOURCE_DESC IntermediateDesc = pIntermediate->GetDesc();
    D3D12_RESOURCE_DESC DestinationDesc = pDestinationResource->GetDesc();
    if (IntermediateDesc.Dimension != D3D12_RESOURCE_DIMENSION_BUFFER ||
        IntermediateDesc.Width < RequiredSize + pLayouts[0].Offset ||
        RequiredSize >(SIZE_T) - 1 ||
        (DestinationDesc.Dimension == D3D12_RESOURCE_DIMENSION_BUFFER &&
        (FirstSubresource != 0 || NumSubresources != 1)))
    {
        return 0;
    }

    BYTE* pData;
    HRESULT hr = pIntermediate->Map(0, NULL, reinterpret_cast<void**>(&pData));
    if (FAILED(hr))
    {
        return 0;
    }

    for (UINT i = 0; i < NumSubresources; ++i)
    {
        if (pRowSizesInBytes[i] >(SIZE_T)-1) return 0;
        D3D12_MEMCPY_DEST DestData = { pData + pLayouts[i].Offset, pLayouts[i].Footprint.RowPitch, pLayouts[i].Footprint.RowPitch * pNumRows[i] };
        MemcpySubresource(&DestData, &pSrcData[i], (SIZE_T)pRowSizesInBytes[i], pNumRows[i], pLayouts[i].Footprint.Depth);
    }
    pIntermediate->Unmap(0, NULL);

    if (DestinationDesc.Dimension == D3D12_RESOURCE_DIMENSION_BUFFER)
    {
        pCmdList->CopyBufferRegion(
            pDestinationResource, 0, pIntermediate, pLayouts[0].Offset, pLayouts[0].Footprint.Width);
    }
    else
    {
        for (UINT i = 0; i < NumSubresources; ++i)
        {
            //CD3DX12_TEXTURE_COPY_LOCATION Dst(pDestinationResource, i + FirstSubresource);
            //CD3DX12_TEXTURE_COPY_LOCATION Src(pIntermediate, pLayouts[i]);
            D3D12_TEXTURE_COPY_LOCATION Dst;
            Dst.pResource = pDestinationResource;
            Dst.Type = D3D12_TEXTURE_COPY_TYPE_SUBRESOURCE_INDEX;
            Dst.SubresourceIndex = i + FirstSubresource;
            D3D12_TEXTURE_COPY_LOCATION Src;
            Src.pResource = pIntermediate;
            Src.Type = D3D12_TEXTURE_COPY_TYPE_PLACED_FOOTPRINT;
            Src.PlacedFootprint = pLayouts[i];
            pCmdList->CopyTextureRegion(&Dst, 0, 0, 0, &Src, nullptr);
        }
    }
    return RequiredSize;
}

// Heap-allocating UpdateSubresources implementation
inline std::uint64_t UpdateSubresources(
    _In_ ID3D12GraphicsCommandList* pCmdList,
    _In_ ID3D12Resource* pDestinationResource,
    _In_ ID3D12Resource* pIntermediate,
    std::uint64_t IntermediateOffset,
    _In_range_(0, D3D12_REQ_SUBRESOURCES) UINT FirstSubresource,
    _In_range_(0, D3D12_REQ_SUBRESOURCES - FirstSubresource) UINT NumSubresources,
    _In_reads_(NumSubresources) D3D12_SUBRESOURCE_DATA* pSrcData)
{
    std::uint64_t RequiredSize = 0;
    std::uint64_t MemToAlloc = static_cast<std::uint64_t>(sizeof(D3D12_PLACED_SUBRESOURCE_FOOTPRINT) + sizeof(UINT) + sizeof(std::uint64_t)) * NumSubresources;
    if (MemToAlloc > SIZE_MAX)
    {
        return 0;
    }
    void* pMem = HeapAlloc(GetProcessHeap(), 0, static_cast<SIZE_T>(MemToAlloc));
    if (pMem == NULL)
    {
        return 0;
    }
    D3D12_PLACED_SUBRESOURCE_FOOTPRINT* pLayouts = reinterpret_cast<D3D12_PLACED_SUBRESOURCE_FOOTPRINT*>(pMem);
    std::uint64_t* pRowSizesInBytes = reinterpret_cast<std::uint64_t*>(pLayouts + NumSubresources);
    UINT* pNumRows = reinterpret_cast<UINT*>(pRowSizesInBytes + NumSubresources);

    D3D12_RESOURCE_DESC Desc = pDestinationResource->GetDesc();
    ID3D12Device* pDevice;
    pDestinationResource->GetDevice(__uuidof(*pDevice), reinterpret_cast<void**>(&pDevice));
    pDevice->GetCopyableFootprints(&Desc, FirstSubresource, NumSubresources, IntermediateOffset, pLayouts, pNumRows, pRowSizesInBytes, &RequiredSize);
    pDevice->Release();

    std::uint64_t Result = UpdateSubresources(pCmdList, pDestinationResource, pIntermediate, FirstSubresource, NumSubresources, RequiredSize, pLayouts, pNumRows, pRowSizesInBytes, pSrcData);
    HeapFree(GetProcessHeap(), 0, pMem);
    return Result;
}

inline std::uint64_t GetRequiredIntermediateSize(_In_ ID3D12Resource* pDestinationResource,
    _In_range_(0, D3D12_REQ_SUBRESOURCES) UINT FirstSubresource,
    _In_range_(0, D3D12_REQ_SUBRESOURCES - FirstSubresource) UINT NumSubresources)
{
    D3D12_RESOURCE_DESC Desc = pDestinationResource->GetDesc();
    std::uint64_t RequiredSize = 0;

    ID3D12Device* pDevice;
    pDestinationResource->GetDevice(__uuidof(*pDevice), reinterpret_cast<void**>(&pDevice));
    pDevice->GetCopyableFootprints(&Desc, FirstSubresource, NumSubresources, 0, nullptr, nullptr, nullptr, &RequiredSize);
    pDevice->Release();

    return RequiredSize;
}

// The fucking idiot Microsoft should be blamed for this piece of code.
inline HRESULT CustomD3D12SerializeVersionedRootSignature(_In_ const D3D12_VERSIONED_ROOT_SIGNATURE_DESC* pRootSignatureDesc,
    D3D_ROOT_SIGNATURE_VERSION MaxVersion,
    _Outptr_ ID3DBlob** ppBlob,
    _Always_(_Outptr_opt_result_maybenull_) ID3DBlob** ppErrorBlob)
{
    if (ppErrorBlob != NULL)
    {
        *ppErrorBlob = NULL;
    }

    switch (MaxVersion)
    {
    case D3D_ROOT_SIGNATURE_VERSION_1_0:
    {
        switch (pRootSignatureDesc->Version)
        {
        case D3D_ROOT_SIGNATURE_VERSION_1_0:
        {
            return D3D12SerializeRootSignature(&pRootSignatureDesc->Desc_1_0, D3D_ROOT_SIGNATURE_VERSION_1, ppBlob, ppErrorBlob);
        }

        case D3D_ROOT_SIGNATURE_VERSION_1_1:
        {
            HRESULT hr = S_OK;
            const D3D12_ROOT_SIGNATURE_DESC1& desc_1_1 = pRootSignatureDesc->Desc_1_1;

            const SIZE_T ParametersSize = sizeof(D3D12_ROOT_PARAMETER) * desc_1_1.NumParameters;
            void* pParameters = (ParametersSize > 0) ? HeapAlloc(GetProcessHeap(), 0, ParametersSize) : NULL;
            if (ParametersSize > 0 && pParameters == NULL)
            {
                hr = E_OUTOFMEMORY;
            }
            D3D12_ROOT_PARAMETER* pParameters_1_0 = reinterpret_cast<D3D12_ROOT_PARAMETER*>(pParameters);

            if (SUCCEEDED(hr))
            {
                for (UINT n = 0; n < desc_1_1.NumParameters; n++)
                {
                    __analysis_assume(ParametersSize == sizeof(D3D12_ROOT_PARAMETER) * desc_1_1.NumParameters);
                    pParameters_1_0[n].ParameterType = desc_1_1.pParameters[n].ParameterType;
                    pParameters_1_0[n].ShaderVisibility = desc_1_1.pParameters[n].ShaderVisibility;

                    switch (desc_1_1.pParameters[n].ParameterType)
                    {
                    case D3D12_ROOT_PARAMETER_TYPE_32BIT_CONSTANTS:
                        pParameters_1_0[n].Constants.Num32BitValues = desc_1_1.pParameters[n].Constants.Num32BitValues;
                        pParameters_1_0[n].Constants.RegisterSpace = desc_1_1.pParameters[n].Constants.RegisterSpace;
                        pParameters_1_0[n].Constants.ShaderRegister = desc_1_1.pParameters[n].Constants.ShaderRegister;
                        break;

                    case D3D12_ROOT_PARAMETER_TYPE_CBV:
                    case D3D12_ROOT_PARAMETER_TYPE_SRV:
                    case D3D12_ROOT_PARAMETER_TYPE_UAV:
                        pParameters_1_0[n].Descriptor.RegisterSpace = desc_1_1.pParameters[n].Descriptor.RegisterSpace;
                        pParameters_1_0[n].Descriptor.ShaderRegister = desc_1_1.pParameters[n].Descriptor.ShaderRegister;
                        break;

                    case D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE:
                        const D3D12_ROOT_DESCRIPTOR_TABLE1& table_1_1 = desc_1_1.pParameters[n].DescriptorTable;

                        const SIZE_T DescriptorRangesSize = sizeof(D3D12_DESCRIPTOR_RANGE) * table_1_1.NumDescriptorRanges;
                        void* pDescriptorRanges = (DescriptorRangesSize > 0 && SUCCEEDED(hr)) ? HeapAlloc(GetProcessHeap(), 0, DescriptorRangesSize) : NULL;
                        if (DescriptorRangesSize > 0 && pDescriptorRanges == NULL)
                        {
                            hr = E_OUTOFMEMORY;
                        }
                        D3D12_DESCRIPTOR_RANGE* pDescriptorRanges_1_0 = reinterpret_cast<D3D12_DESCRIPTOR_RANGE*>(pDescriptorRanges);

                        if (SUCCEEDED(hr))
                        {
                            for (UINT x = 0; x < table_1_1.NumDescriptorRanges; x++)
                            {
                                __analysis_assume(DescriptorRangesSize == sizeof(D3D12_DESCRIPTOR_RANGE) * table_1_1.NumDescriptorRanges);
                                pDescriptorRanges_1_0[x].BaseShaderRegister = table_1_1.pDescriptorRanges[x].BaseShaderRegister;
                                pDescriptorRanges_1_0[x].NumDescriptors = table_1_1.pDescriptorRanges[x].NumDescriptors;
                                pDescriptorRanges_1_0[x].OffsetInDescriptorsFromTableStart = table_1_1.pDescriptorRanges[x].OffsetInDescriptorsFromTableStart;
                                pDescriptorRanges_1_0[x].RangeType = table_1_1.pDescriptorRanges[x].RangeType;
                                pDescriptorRanges_1_0[x].RegisterSpace = table_1_1.pDescriptorRanges[x].RegisterSpace;
                            }
                        }

                        D3D12_ROOT_DESCRIPTOR_TABLE& table_1_0 = pParameters_1_0[n].DescriptorTable;
                        table_1_0.NumDescriptorRanges = table_1_1.NumDescriptorRanges;
                        table_1_0.pDescriptorRanges = pDescriptorRanges_1_0;
                    }
                }
            }

            if (SUCCEEDED(hr))
            {
                //D3D12_ROOT_SIGNATURE_DESC desc_1_0(desc_1_1.NumParameters, pParameters_1_0, desc_1_1.NumStaticSamplers, desc_1_1.pStaticSamplers, desc_1_1.Flags);
                D3D12_ROOT_SIGNATURE_DESC desc_1_0;
                desc_1_0.NumParameters = desc_1_1.NumParameters;
                desc_1_0.pParameters = pParameters_1_0;
                desc_1_0.NumStaticSamplers = desc_1_1.NumStaticSamplers;
                desc_1_0.pStaticSamplers = desc_1_1.pStaticSamplers;
                desc_1_0.Flags = desc_1_1.Flags;
                hr = D3D12SerializeRootSignature(&desc_1_0, D3D_ROOT_SIGNATURE_VERSION_1, ppBlob, ppErrorBlob);
            }

            if (pParameters)
            {
                for (UINT n = 0; n < desc_1_1.NumParameters; n++)
                {
                    if (desc_1_1.pParameters[n].ParameterType == D3D12_ROOT_PARAMETER_TYPE_DESCRIPTOR_TABLE)
                    {
                        HeapFree(GetProcessHeap(), 0, reinterpret_cast<void*>(const_cast<D3D12_DESCRIPTOR_RANGE*>(pParameters_1_0[n].DescriptorTable.pDescriptorRanges)));
                    }
                }
                HeapFree(GetProcessHeap(), 0, pParameters);
            }
            return hr;
        }
        }
        break;
    }

    case D3D_ROOT_SIGNATURE_VERSION_1_1:
    {
        return D3D12SerializeVersionedRootSignature(pRootSignatureDesc, ppBlob, ppErrorBlob);
    }
    }

    return E_INVALIDARG;
};
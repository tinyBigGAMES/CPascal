{===============================================================================

                         ▒▓▓██████▓▒▒
                     ▒▓███████████████▓
                   ▒█████████▓▓▓████████▒ ▒▓▓▒
                  ▓██████▒         ▓██▓  ▓████▓▒▓▓
                 ▓█████▒               ▓███████████
                 █████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███▓    ▓███▓
                ▓████████████████████████      █████▒
                ▓████▓   ██▒     ▓█▓ ████     ▓████▓
                ▒█████   ▓        ▓▒ █████████████▓
                 ██████              █████████████▓
                  ██████▒            ████▒████  ▒
                   ▓███████▓▒▒▒▒▒▓█▓ ████  ▒▒
                     ▓█████████████▓ ███▓
                       ▒▓██████████▓ ▒▒
                            ▒▒▒▒▒

     ▒▓▓▓▒▒   ▓▓▓▓▓▓▒▒                                             ™
   ███▓▒▓███▒ ███▓▓▓███                                         ██▒
  ███     ▒▓▓ ██▓    ██▓ ▓█████▓  ▒█████▓   ▓█████▓   ▓█████▓   ██▒
 ▒██▒         ██▓▒▒▒▓██▒▒▓▓   ██▓ ██▓  ▒▒▒ ██▓   ▓█▓  ▓▓   ▓██  ██▒
  ██▓         ███▓▓▓▓▒  ▒▓██▓███▓ ▒▓████▓  ██▒       ▒▓███████  ██▒
  ▒██▓▒ ▒▓██▓ ██▓       ██▓  ▒██▓ ▓▓   ▓██ ▓██▒  ▓█▓ ███   ███  ██▒
    ▒▓████▓   ██▒        ▓███▓▓█▒ ▒▓████▓   ▒▓███▓▒   ▓███▓▒█▓  ██▒
                    Better C with Pascal Syntax

 Copyright © 2025-present tinyBigGAMES™ LLC
 All Rights Reserved.

 https://github.com/tinyBigGAMES/CPascal

 BSD 3-Clause License

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
    list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the copyright holder nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
===============================================================================}

unit CPascal.LLVM;

{$I CPascal.Defines.inc}

interface

const
{$IF DEFINED(MSWINDOWS)}
  LLVM_DLL = 'LLVM-C.dll';
  _PU = ''; // No prefix for Windows
{$ELSEIF DEFINED(LINUX)}
  LLVM_DLL = 'libLLVM-C.so';
  _PU = ''; // No prefix for Linux
{$ELSEIF DEFINED(MACOS)}
  LLVM_DLL = 'libLLVM-C.dylib';
  _PU = '_'; // Underscore prefix for macOS
{$ELSE}
  // Default or for other platforms; you might need to adjust
  LLVM_DLL = 'LLVM-C.dll';
  _PU = '';
{$ENDIF}

const
  LLVM_ATTRIBUTE_DEPRECATED = 1;

  LLVM_ENABLE_THREADS = 1;
  LLVM_HAS_ATOMICS = 1;

  LLVM_DEFAULT_TARGET_TRIPLE = 'x86_64-pc-windows-msvc';
  LLVM_HOST_TRIPLE = 'x86_64-pc-windows-msvc';

  LLVM_USE_INTEL_JITEVENTS = 0;
  LLVM_USE_OPROFILE = 0;
  LLVM_USE_PERF = 0;

  LLVM_VERSION_MAJOR = 21;
  LLVM_VERSION_MINOR = 0;
  LLVM_VERSION_PATCH = 0;
  LLVM_VERSION_STRING = '21.0.0git';

  LLVM_FORCE_ENABLE_STATS = 0;
  LLVM_UNREACHABLE_OPTIMIZE = 1;

  LLVM_ENABLE_ZLIB = 0;
  LLVM_ENABLE_ZSTD = 0;
  LLVM_ENABLE_DIA_SDK = 0;
  LLVM_ENABLE_TELEMETRY = 1;
  LLVM_ENABLE_DEBUGLOC_TRACKING_COVERAGE = 0;
  LLVM_ENABLE_DEBUGLOC_TRACKING_ORIGIN = 0;

  LLVMErrorSuccess = 0;

  LLVMDisassembler_VariantKind_None = 0;
  LLVMDisassembler_VariantKind_ARM_HI16 = 1;
  LLVMDisassembler_VariantKind_ARM_LO16 = 2;
  LLVMDisassembler_VariantKind_ARM64_PAGE = 1;
  LLVMDisassembler_VariantKind_ARM64_PAGEOFF = 2;
  LLVMDisassembler_VariantKind_ARM64_GOTPAGE = 3;
  LLVMDisassembler_VariantKind_ARM64_GOTPAGEOFF = 4;
  LLVMDisassembler_VariantKind_ARM64_TLVP = 5;
  LLVMDisassembler_VariantKind_ARM64_TLVOFF = 6;

  LLVMDisassembler_ReferenceType_InOut_None = 0;
  LLVMDisassembler_ReferenceType_In_Branch = 1;
  LLVMDisassembler_ReferenceType_In_PCrel_Load = 2;
  LLVMDisassembler_ReferenceType_In_ARM64_ADRP = $100000001;
  LLVMDisassembler_ReferenceType_In_ARM64_ADDXri = $100000002;
  LLVMDisassembler_ReferenceType_In_ARM64_LDRXui = $100000003;
  LLVMDisassembler_ReferenceType_In_ARM64_LDRXl = $100000004;
  LLVMDisassembler_ReferenceType_In_ARM64_ADR = $100000005;
  LLVMDisassembler_ReferenceType_Out_SymbolStub = 1;
  LLVMDisassembler_ReferenceType_Out_LitPool_SymAddr = 2;
  LLVMDisassembler_ReferenceType_Out_LitPool_CstrAddr = 3;
  LLVMDisassembler_ReferenceType_Out_Objc_CFString_Ref = 4;
  LLVMDisassembler_ReferenceType_Out_Objc_Message = 5;
  LLVMDisassembler_ReferenceType_Out_Objc_Message_Ref = 6;
  LLVMDisassembler_ReferenceType_Out_Objc_Selector_Ref = 7;
  LLVMDisassembler_ReferenceType_Out_Objc_Class_Ref = 8;
  LLVMDisassembler_ReferenceType_DeMangled_Name = 9;

  LLVMDisassembler_Option_UseMarkup = 1;
  LLVMDisassembler_Option_PrintImmHex = 2;
  LLVMDisassembler_Option_AsmPrinterVariant = 4;
  LLVMDisassembler_Option_SetInstrComments = 8;
  LLVMDisassembler_Option_PrintLatency = 16;
  LLVMDisassembler_Option_Color = 32;

  REMARKS_API_VERSION = 1;

type
  // Forward declarations
  PPUTF8Char = ^PUTF8Char;
  PNativeUInt = ^NativeUInt;
  PUInt8 = ^UInt8;
  PUInt64 = ^UInt64;
  PLLVMOpaqueMemoryBuffer = Pointer;
  PPLLVMOpaqueMemoryBuffer = ^PLLVMOpaqueMemoryBuffer;
  PLLVMOpaqueContext = Pointer;
  PPLLVMOpaqueContext = ^PLLVMOpaqueContext;
  PLLVMOpaqueModule = Pointer;
  PPLLVMOpaqueModule = ^PLLVMOpaqueModule;
  PLLVMOpaqueType = Pointer;
  PPLLVMOpaqueType = ^PLLVMOpaqueType;
  PLLVMOpaqueValue = Pointer;
  PPLLVMOpaqueValue = ^PLLVMOpaqueValue;
  PLLVMOpaqueBasicBlock = Pointer;
  PPLLVMOpaqueBasicBlock = ^PLLVMOpaqueBasicBlock;
  PLLVMOpaqueMetadata = Pointer;
  PPLLVMOpaqueMetadata = ^PLLVMOpaqueMetadata;
  PLLVMOpaqueNamedMDNode = Pointer;
  PPLLVMOpaqueNamedMDNode = ^PLLVMOpaqueNamedMDNode;
  PLLVMOpaqueValueMetadataEntry = Pointer;
  PPLLVMOpaqueValueMetadataEntry = ^PLLVMOpaqueValueMetadataEntry;
  PLLVMOpaqueBuilder = Pointer;
  PPLLVMOpaqueBuilder = ^PLLVMOpaqueBuilder;
  PLLVMOpaqueDIBuilder = Pointer;
  PPLLVMOpaqueDIBuilder = ^PLLVMOpaqueDIBuilder;
  PLLVMOpaqueModuleProvider = Pointer;
  PPLLVMOpaqueModuleProvider = ^PLLVMOpaqueModuleProvider;
  PLLVMOpaquePassManager = Pointer;
  PPLLVMOpaquePassManager = ^PLLVMOpaquePassManager;
  PLLVMOpaqueUse = Pointer;
  PPLLVMOpaqueUse = ^PLLVMOpaqueUse;
  PLLVMOpaqueOperandBundle = Pointer;
  PPLLVMOpaqueOperandBundle = ^PLLVMOpaqueOperandBundle;
  PLLVMOpaqueAttributeRef = Pointer;
  PPLLVMOpaqueAttributeRef = ^PLLVMOpaqueAttributeRef;
  PLLVMOpaqueDiagnosticInfo = Pointer;
  PPLLVMOpaqueDiagnosticInfo = ^PLLVMOpaqueDiagnosticInfo;
  PLLVMComdat = Pointer;
  PPLLVMComdat = ^PLLVMComdat;
  PLLVMOpaqueModuleFlagEntry = Pointer;
  PPLLVMOpaqueModuleFlagEntry = ^PLLVMOpaqueModuleFlagEntry;
  PLLVMOpaqueJITEventListener = Pointer;
  PPLLVMOpaqueJITEventListener = ^PLLVMOpaqueJITEventListener;
  PLLVMOpaqueBinary = Pointer;
  PPLLVMOpaqueBinary = ^PLLVMOpaqueBinary;
  PLLVMOpaqueDbgRecord = Pointer;
  PPLLVMOpaqueDbgRecord = ^PLLVMOpaqueDbgRecord;
  PLLVMOpaqueError = Pointer;
  PPLLVMOpaqueError = ^PLLVMOpaqueError;
  PLLVMOpaqueTargetData = Pointer;
  PPLLVMOpaqueTargetData = ^PLLVMOpaqueTargetData;
  PLLVMOpaqueTargetLibraryInfotData = Pointer;
  PPLLVMOpaqueTargetLibraryInfotData = ^PLLVMOpaqueTargetLibraryInfotData;
  PLLVMOpaqueTargetMachineOptions = Pointer;
  PPLLVMOpaqueTargetMachineOptions = ^PLLVMOpaqueTargetMachineOptions;
  PLLVMOpaqueTargetMachine = Pointer;
  PPLLVMOpaqueTargetMachine = ^PLLVMOpaqueTargetMachine;
  PLLVMTarget = Pointer;
  PPLLVMTarget = ^PLLVMTarget;
  PLLVMOpaquePassBuilderOptions = Pointer;
  PPLLVMOpaquePassBuilderOptions = ^PLLVMOpaquePassBuilderOptions;
  PLLVMOpaqueGenericValue = Pointer;
  PPLLVMOpaqueGenericValue = ^PLLVMOpaqueGenericValue;
  PLLVMOpaqueExecutionEngine = Pointer;
  PPLLVMOpaqueExecutionEngine = ^PLLVMOpaqueExecutionEngine;
  PLLVMOpaqueMCJITMemoryManager = Pointer;
  PPLLVMOpaqueMCJITMemoryManager = ^PLLVMOpaqueMCJITMemoryManager;
  PLLVMOrcOpaqueExecutionSession = Pointer;
  PPLLVMOrcOpaqueExecutionSession = ^PLLVMOrcOpaqueExecutionSession;
  PLLVMOrcOpaqueSymbolStringPool = Pointer;
  PPLLVMOrcOpaqueSymbolStringPool = ^PLLVMOrcOpaqueSymbolStringPool;
  PLLVMOrcOpaqueSymbolStringPoolEntry = Pointer;
  PPLLVMOrcOpaqueSymbolStringPoolEntry = ^PLLVMOrcOpaqueSymbolStringPoolEntry;
  PLLVMOrcOpaqueJITDylib = Pointer;
  PPLLVMOrcOpaqueJITDylib = ^PLLVMOrcOpaqueJITDylib;
  PLLVMOrcOpaqueMaterializationUnit = Pointer;
  PPLLVMOrcOpaqueMaterializationUnit = ^PLLVMOrcOpaqueMaterializationUnit;
  PLLVMOrcOpaqueMaterializationResponsibility = Pointer;
  PPLLVMOrcOpaqueMaterializationResponsibility = ^PLLVMOrcOpaqueMaterializationResponsibility;
  PLLVMOrcOpaqueResourceTracker = Pointer;
  PPLLVMOrcOpaqueResourceTracker = ^PLLVMOrcOpaqueResourceTracker;
  PLLVMOrcOpaqueDefinitionGenerator = Pointer;
  PPLLVMOrcOpaqueDefinitionGenerator = ^PLLVMOrcOpaqueDefinitionGenerator;
  PLLVMOrcOpaqueLookupState = Pointer;
  PPLLVMOrcOpaqueLookupState = ^PLLVMOrcOpaqueLookupState;
  PLLVMOrcOpaqueThreadSafeContext = Pointer;
  PPLLVMOrcOpaqueThreadSafeContext = ^PLLVMOrcOpaqueThreadSafeContext;
  PLLVMOrcOpaqueThreadSafeModule = Pointer;
  PPLLVMOrcOpaqueThreadSafeModule = ^PLLVMOrcOpaqueThreadSafeModule;
  PLLVMOrcOpaqueJITTargetMachineBuilder = Pointer;
  PPLLVMOrcOpaqueJITTargetMachineBuilder = ^PLLVMOrcOpaqueJITTargetMachineBuilder;
  PLLVMOrcOpaqueObjectLayer = Pointer;
  PPLLVMOrcOpaqueObjectLayer = ^PLLVMOrcOpaqueObjectLayer;
  PLLVMOrcOpaqueObjectLinkingLayer = Pointer;
  PPLLVMOrcOpaqueObjectLinkingLayer = ^PLLVMOrcOpaqueObjectLinkingLayer;
  PLLVMOrcOpaqueIRTransformLayer = Pointer;
  PPLLVMOrcOpaqueIRTransformLayer = ^PLLVMOrcOpaqueIRTransformLayer;
  PLLVMOrcOpaqueObjectTransformLayer = Pointer;
  PPLLVMOrcOpaqueObjectTransformLayer = ^PLLVMOrcOpaqueObjectTransformLayer;
  PLLVMOrcOpaqueIndirectStubsManager = Pointer;
  PPLLVMOrcOpaqueIndirectStubsManager = ^PLLVMOrcOpaqueIndirectStubsManager;
  PLLVMOrcOpaqueLazyCallThroughManager = Pointer;
  PPLLVMOrcOpaqueLazyCallThroughManager = ^PLLVMOrcOpaqueLazyCallThroughManager;
  PLLVMOrcOpaqueDumpObjects = Pointer;
  PPLLVMOrcOpaqueDumpObjects = ^PLLVMOrcOpaqueDumpObjects;
  PLLVMOrcOpaqueLLJITBuilder = Pointer;
  PPLLVMOrcOpaqueLLJITBuilder = ^PLLVMOrcOpaqueLLJITBuilder;
  PLLVMOrcOpaqueLLJIT = Pointer;
  PPLLVMOrcOpaqueLLJIT = ^PLLVMOrcOpaqueLLJIT;
  PLLVMOpaqueSectionIterator = Pointer;
  PPLLVMOpaqueSectionIterator = ^PLLVMOpaqueSectionIterator;
  PLLVMOpaqueSymbolIterator = Pointer;
  PPLLVMOpaqueSymbolIterator = ^PLLVMOpaqueSymbolIterator;
  PLLVMOpaqueRelocationIterator = Pointer;
  PPLLVMOpaqueRelocationIterator = ^PLLVMOpaqueRelocationIterator;
  PLLVMOpaqueObjectFile = Pointer;
  PPLLVMOpaqueObjectFile = ^PLLVMOpaqueObjectFile;
  PLLVMRemarkOpaqueString = Pointer;
  PPLLVMRemarkOpaqueString = ^PLLVMRemarkOpaqueString;
  PLLVMRemarkOpaqueDebugLoc = Pointer;
  PPLLVMRemarkOpaqueDebugLoc = ^PLLVMRemarkOpaqueDebugLoc;
  PLLVMRemarkOpaqueArg = Pointer;
  PPLLVMRemarkOpaqueArg = ^PLLVMRemarkOpaqueArg;
  PLLVMRemarkOpaqueEntry = Pointer;
  PPLLVMRemarkOpaqueEntry = ^PLLVMRemarkOpaqueEntry;
  PLLVMRemarkOpaqueParser = Pointer;
  PPLLVMRemarkOpaqueParser = ^PLLVMRemarkOpaqueParser;
  PLLVMOpInfoSymbol1 = ^LLVMOpInfoSymbol1;
  PLLVMOpInfo1 = ^LLVMOpInfo1;
  PLLVMMCJITCompilerOptions = ^LLVMMCJITCompilerOptions;
  PLLVMJITSymbolFlags = ^LLVMJITSymbolFlags;
  PLLVMJITEvaluatedSymbol = ^LLVMJITEvaluatedSymbol;
  PLLVMOrcCSymbolFlagsMapPair = ^LLVMOrcCSymbolFlagsMapPair;
  PLLVMOrcCSymbolMapPair = ^LLVMOrcCSymbolMapPair;
  PLLVMOrcCSymbolAliasMapEntry = ^LLVMOrcCSymbolAliasMapEntry;
  PLLVMOrcCSymbolAliasMapPair = ^LLVMOrcCSymbolAliasMapPair;
  PLLVMOrcCSymbolsList = ^LLVMOrcCSymbolsList;
  PLLVMOrcCDependenceMapPair = ^LLVMOrcCDependenceMapPair;
  PLLVMOrcCSymbolDependenceGroup = ^LLVMOrcCSymbolDependenceGroup;
  PLLVMOrcCJITDylibSearchOrderElement = ^LLVMOrcCJITDylibSearchOrderElement;
  PLLVMOrcCLookupSetElement = ^LLVMOrcCLookupSetElement;

  ssize_t = Int64;
  (**
   * @defgroup LLVMCSupportTypes Types and Enumerations
   *
   * @{
   *)
  LLVMBool = Integer;
  PLLVMBool = ^LLVMBool;
  LLVMMemoryBufferRef = Pointer;
  PLLVMMemoryBufferRef = ^LLVMMemoryBufferRef;
  LLVMContextRef = Pointer;
  PLLVMContextRef = ^LLVMContextRef;
  LLVMModuleRef = Pointer;
  PLLVMModuleRef = ^LLVMModuleRef;
  LLVMTypeRef = Pointer;
  PLLVMTypeRef = ^LLVMTypeRef;
  LLVMValueRef = Pointer;
  PLLVMValueRef = ^LLVMValueRef;
  LLVMBasicBlockRef = Pointer;
  PLLVMBasicBlockRef = ^LLVMBasicBlockRef;
  LLVMMetadataRef = Pointer;
  PLLVMMetadataRef = ^LLVMMetadataRef;
  LLVMNamedMDNodeRef = Pointer;
  PLLVMNamedMDNodeRef = ^LLVMNamedMDNodeRef;
  PLLVMValueMetadataEntry = Pointer;
  PPLLVMValueMetadataEntry = ^PLLVMValueMetadataEntry;
  LLVMBuilderRef = Pointer;
  PLLVMBuilderRef = ^LLVMBuilderRef;
  LLVMDIBuilderRef = Pointer;
  PLLVMDIBuilderRef = ^LLVMDIBuilderRef;
  LLVMModuleProviderRef = Pointer;
  PLLVMModuleProviderRef = ^LLVMModuleProviderRef;
  LLVMPassManagerRef = Pointer;
  PLLVMPassManagerRef = ^LLVMPassManagerRef;
  LLVMUseRef = Pointer;
  PLLVMUseRef = ^LLVMUseRef;
  LLVMOperandBundleRef = Pointer;
  PLLVMOperandBundleRef = ^LLVMOperandBundleRef;
  LLVMAttributeRef = Pointer;
  PLLVMAttributeRef = ^LLVMAttributeRef;
  LLVMDiagnosticInfoRef = Pointer;
  PLLVMDiagnosticInfoRef = ^LLVMDiagnosticInfoRef;
  LLVMComdatRef = Pointer;
  PLLVMComdatRef = ^LLVMComdatRef;
  PLLVMModuleFlagEntry = Pointer;
  PPLLVMModuleFlagEntry = ^PLLVMModuleFlagEntry;
  LLVMJITEventListenerRef = Pointer;
  PLLVMJITEventListenerRef = ^LLVMJITEventListenerRef;
  LLVMBinaryRef = Pointer;
  PLLVMBinaryRef = ^LLVMBinaryRef;
  LLVMDbgRecordRef = Pointer;
  PLLVMDbgRecordRef = ^LLVMDbgRecordRef;
  LLVMErrorRef = Pointer;
  PLLVMErrorRef = ^LLVMErrorRef;
  (**
   * Error type identifier.
   *)
  LLVMErrorTypeId = Pointer;

  (**
   * @defgroup LLVMCTarget Target information
   * @ingroup LLVMC
   *
   * @{
   *)
  LLVMByteOrdering = (
    LLVMBigEndian = 0,
    LLVMLittleEndian = 1);
  PLLVMByteOrdering = ^LLVMByteOrdering;
  LLVMTargetDataRef = Pointer;
  PLLVMTargetDataRef = ^LLVMTargetDataRef;
  LLVMTargetLibraryInfoRef = Pointer;
  PLLVMTargetLibraryInfoRef = ^LLVMTargetLibraryInfoRef;
  LLVMTargetMachineOptionsRef = Pointer;
  PLLVMTargetMachineOptionsRef = ^LLVMTargetMachineOptionsRef;
  LLVMTargetMachineRef = Pointer;
  PLLVMTargetMachineRef = ^LLVMTargetMachineRef;
  LLVMTargetRef = Pointer;
  PLLVMTargetRef = ^LLVMTargetRef;

  LLVMCodeGenOptLevel = (
    LLVMCodeGenLevelNone = 0,
    LLVMCodeGenLevelLess = 1,
    LLVMCodeGenLevelDefault = 2,
    LLVMCodeGenLevelAggressive = 3);
  PLLVMCodeGenOptLevel = ^LLVMCodeGenOptLevel;

  LLVMRelocMode = (
    LLVMRelocDefault = 0,
    LLVMRelocStatic = 1,
    LLVMRelocPIC = 2,
    LLVMRelocDynamicNoPic = 3,
    LLVMRelocROPI = 4,
    LLVMRelocRWPI = 5,
    LLVMRelocROPI_RWPI = 6);
  PLLVMRelocMode = ^LLVMRelocMode;

  LLVMCodeModel = (
    LLVMCodeModelDefault = 0,
    LLVMCodeModelJITDefault = 1,
    LLVMCodeModelTiny = 2,
    LLVMCodeModelSmall = 3,
    LLVMCodeModelKernel = 4,
    LLVMCodeModelMedium = 5,
    LLVMCodeModelLarge = 6);
  PLLVMCodeModel = ^LLVMCodeModel;

  LLVMCodeGenFileType = (
    LLVMAssemblyFile = 0,
    LLVMObjectFile = 1);
  PLLVMCodeGenFileType = ^LLVMCodeGenFileType;

  LLVMGlobalISelAbortMode = (
    LLVMGlobalISelAbortEnable = 0,
    LLVMGlobalISelAbortDisable = 1,
    LLVMGlobalISelAbortDisableWithDiag = 2);
  PLLVMGlobalISelAbortMode = ^LLVMGlobalISelAbortMode;
  LLVMPassBuilderOptionsRef = Pointer;
  PLLVMPassBuilderOptionsRef = ^LLVMPassBuilderOptionsRef;

  (**
   * @defgroup LLVMCAnalysis Analysis
   * @ingroup LLVMC
   *
   * @{
   *)
  LLVMVerifierFailureAction = (
    LLVMAbortProcessAction = 0,
    LLVMPrintMessageAction = 1,
    LLVMReturnStatusAction = 2);
  PLLVMVerifierFailureAction = ^LLVMVerifierFailureAction;

  (**
   * @defgroup LLVMCCoreComdat Comdats
   * @ingroup LLVMCCore
   *
   * @{
   *)
  LLVMComdatSelectionKind = (
    /// The linker may choose any COMDAT.
    LLVMAnyComdatSelectionKind = 0,
    /// The data referenced by the COMDAT must
                                         ///< be the same.
    LLVMExactMatchComdatSelectionKind = 1,
    /// The linker will choose the largest
                                         ///< COMDAT.
    LLVMLargestComdatSelectionKind = 2,
    /// No deduplication is performed.
    LLVMNoDeduplicateComdatSelectionKind = 3,
    /// The data referenced by the COMDAT must be
                                      ///< the same size.
    LLVMSameSizeComdatSelectionKind = 4);
  PLLVMComdatSelectionKind = ^LLVMComdatSelectionKind;

  (**
   * @addtogroup LLVMCError
   *
   * @{
   *)
  LLVMFatalErrorHandler = procedure(const Reason: PUTF8Char); cdecl;

  /// External users depend on the following values being stable. It is not safe
  /// to reorder them.
  LLVMOpcode = (
    LLVMRet = 1,
    LLVMBr = 2,
    LLVMSwitch = 3,
    LLVMIndirectBr = 4,
    LLVMInvoke = 5,
    LLVMUnreachable = 7,
    LLVMCallBr = 67,
    LLVMFNeg = 66,
    LLVMAdd = 8,
    LLVMFAdd = 9,
    LLVMSub = 10,
    LLVMFSub = 11,
    LLVMMul = 12,
    LLVMFMul = 13,
    LLVMUDiv = 14,
    LLVMSDiv = 15,
    LLVMFDiv = 16,
    LLVMURem = 17,
    LLVMSRem = 18,
    LLVMFRem = 19,
    LLVMShl = 20,
    LLVMLShr = 21,
    LLVMAShr = 22,
    LLVMAnd = 23,
    LLVMOr = 24,
    LLVMXor = 25,
    LLVMAlloca = 26,
    LLVMLoad = 27,
    LLVMStore = 28,
    LLVMGetElementPtr = 29,
    LLVMTrunc = 30,
    LLVMZExt = 31,
    LLVMSExt = 32,
    LLVMFPToUI = 33,
    LLVMFPToSI = 34,
    LLVMUIToFP = 35,
    LLVMSIToFP = 36,
    LLVMFPTrunc = 37,
    LLVMFPExt = 38,
    LLVMPtrToInt = 39,
    LLVMIntToPtr = 40,
    LLVMBitCast = 41,
    LLVMAddrSpaceCast = 60,
    LLVMICmp = 42,
    LLVMFCmp = 43,
    LLVMPHI = 44,
    LLVMCall = 45,
    LLVMSelect = 46,
    LLVMUserOp1 = 47,
    LLVMUserOp2 = 48,
    LLVMVAArg = 49,
    LLVMExtractElement = 50,
    LLVMInsertElement = 51,
    LLVMShuffleVector = 52,
    LLVMExtractValue = 53,
    LLVMInsertValue = 54,
    LLVMFreeze = 68,
    LLVMFence = 55,
    LLVMAtomicCmpXchg = 56,
    LLVMAtomicRMW = 57,
    LLVMResume = 58,
    LLVMLandingPad = 59,
    LLVMCleanupRet = 61,
    LLVMCatchRet = 62,
    LLVMCatchPad = 63,
    LLVMCleanupPad = 64,
    LLVMCatchSwitch = 65);
  PLLVMOpcode = ^LLVMOpcode;

  LLVMTypeKind = (
    (** type with no size *)
    LLVMVoidTypeKind = 0,
    (** 16 bit floating point type *)
    LLVMHalfTypeKind = 1,
    (** 32 bit floating point type *)
    LLVMFloatTypeKind = 2,
    (** 64 bit floating point type *)
    LLVMDoubleTypeKind = 3,
    (** 80 bit floating point type (X87) *)
    LLVMX86_FP80TypeKind = 4,
    (** 128 bit floating point type (112-bit mantissa)*)
    LLVMFP128TypeKind = 5,
    (** 128 bit floating point type (two 64-bits) *)
    LLVMPPC_FP128TypeKind = 6,
    (** Labels *)
    LLVMLabelTypeKind = 7,
    (** Arbitrary bit width integers *)
    LLVMIntegerTypeKind = 8,
    (** Functions *)
    LLVMFunctionTypeKind = 9,
    (** Structures *)
    LLVMStructTypeKind = 10,
    (** Arrays *)
    LLVMArrayTypeKind = 11,
    (** Pointers *)
    LLVMPointerTypeKind = 12,
    (** Fixed width SIMD vector type *)
    LLVMVectorTypeKind = 13,
    (** Metadata *)
    LLVMMetadataTypeKind = 14,
    (** Tokens *)
    LLVMTokenTypeKind = 16,
    (** Scalable SIMD vector type *)
    LLVMScalableVectorTypeKind = 17,
    (** 16 bit brain floating point type *)
    LLVMBFloatTypeKind = 18,
    (** X86 AMX *)
    LLVMX86_AMXTypeKind = 19,
    (** Target extension type *)
    LLVMTargetExtTypeKind = 20);
  PLLVMTypeKind = ^LLVMTypeKind;

  LLVMLinkage = (
    (** Externally visible function *)
    LLVMExternalLinkage = 0,
    LLVMAvailableExternallyLinkage = 1,
    (** Keep one copy of function when linking (inline)*)
    LLVMLinkOnceAnyLinkage = 2,
    (** Same, but only replaced by something
                                equivalent. *)
    LLVMLinkOnceODRLinkage = 3,
    (** Obsolete *)
    LLVMLinkOnceODRAutoHideLinkage = 4,
    (** Keep one copy of function when linking (weak) *)
    LLVMWeakAnyLinkage = 5,
    (** Same, but only replaced by something
                                equivalent. *)
    LLVMWeakODRLinkage = 6,
    (** Special purpose, only applies to global arrays *)
    LLVMAppendingLinkage = 7,
    (** Rename collisions when linking (static
                                   functions) *)
    LLVMInternalLinkage = 8,
    (** Like Internal, but omit from symbol table *)
    LLVMPrivateLinkage = 9,
    (** Obsolete *)
    LLVMDLLImportLinkage = 10,
    (** Obsolete *)
    LLVMDLLExportLinkage = 11,
    (** ExternalWeak linkage description *)
    LLVMExternalWeakLinkage = 12,
    (** Obsolete *)
    LLVMGhostLinkage = 13,
    (** Tentative definitions *)
    LLVMCommonLinkage = 14,
    (** Like Private, but linker removes. *)
    LLVMLinkerPrivateLinkage = 15,
    (** Like LinkerPrivate, but is weak. *)
    LLVMLinkerPrivateWeakLinkage = 16);
  PLLVMLinkage = ^LLVMLinkage;

  LLVMVisibility = (
    (** The GV is visible *)
    LLVMDefaultVisibility = 0,
    (** The GV is hidden *)
    LLVMHiddenVisibility = 1,
    (** The GV is protected *)
    LLVMProtectedVisibility = 2);
  PLLVMVisibility = ^LLVMVisibility;

  LLVMUnnamedAddr = (
    (** Address of the GV is significant. *)
    LLVMNoUnnamedAddr = 0,
    (** Address of the GV is locally insignificant. *)
    LLVMLocalUnnamedAddr = 1,
    (** Address of the GV is globally insignificant. *)
    LLVMGlobalUnnamedAddr = 2);
  PLLVMUnnamedAddr = ^LLVMUnnamedAddr;

  LLVMDLLStorageClass = (
    LLVMDefaultStorageClass = 0,
    (** Function to be imported from DLL. *)
    LLVMDLLImportStorageClass = 1,
    (** Function to be accessible from DLL. *)
    LLVMDLLExportStorageClass = 2);
  PLLVMDLLStorageClass = ^LLVMDLLStorageClass;

  LLVMCallConv = (
    LLVMCCallConv = 0,
    LLVMFastCallConv = 8,
    LLVMColdCallConv = 9,
    LLVMGHCCallConv = 10,
    LLVMHiPECallConv = 11,
    LLVMAnyRegCallConv = 13,
    LLVMPreserveMostCallConv = 14,
    LLVMPreserveAllCallConv = 15,
    LLVMSwiftCallConv = 16,
    LLVMCXXFASTTLSCallConv = 17,
    LLVMX86StdcallCallConv = 64,
    LLVMX86FastcallCallConv = 65,
    LLVMARMAPCSCallConv = 66,
    LLVMARMAAPCSCallConv = 67,
    LLVMARMAAPCSVFPCallConv = 68,
    LLVMMSP430INTRCallConv = 69,
    LLVMX86ThisCallCallConv = 70,
    LLVMPTXKernelCallConv = 71,
    LLVMPTXDeviceCallConv = 72,
    LLVMSPIRFUNCCallConv = 75,
    LLVMSPIRKERNELCallConv = 76,
    LLVMIntelOCLBICallConv = 77,
    LLVMX8664SysVCallConv = 78,
    LLVMWin64CallConv = 79,
    LLVMX86VectorCallCallConv = 80,
    LLVMHHVMCallConv = 81,
    LLVMHHVMCCallConv = 82,
    LLVMX86INTRCallConv = 83,
    LLVMAVRINTRCallConv = 84,
    LLVMAVRSIGNALCallConv = 85,
    LLVMAVRBUILTINCallConv = 86,
    LLVMAMDGPUVSCallConv = 87,
    LLVMAMDGPUGSCallConv = 88,
    LLVMAMDGPUPSCallConv = 89,
    LLVMAMDGPUCSCallConv = 90,
    LLVMAMDGPUKERNELCallConv = 91,
    LLVMX86RegCallCallConv = 92,
    LLVMAMDGPUHSCallConv = 93,
    LLVMMSP430BUILTINCallConv = 94,
    LLVMAMDGPULSCallConv = 95,
    LLVMAMDGPUESCallConv = 96);
  PLLVMCallConv = ^LLVMCallConv;

  LLVMValueKind = (
    LLVMArgumentValueKind = 0,
    LLVMBasicBlockValueKind = 1,
    LLVMMemoryUseValueKind = 2,
    LLVMMemoryDefValueKind = 3,
    LLVMMemoryPhiValueKind = 4,
    LLVMFunctionValueKind = 5,
    LLVMGlobalAliasValueKind = 6,
    LLVMGlobalIFuncValueKind = 7,
    LLVMGlobalVariableValueKind = 8,
    LLVMBlockAddressValueKind = 9,
    LLVMConstantExprValueKind = 10,
    LLVMConstantArrayValueKind = 11,
    LLVMConstantStructValueKind = 12,
    LLVMConstantVectorValueKind = 13,
    LLVMUndefValueValueKind = 14,
    LLVMConstantAggregateZeroValueKind = 15,
    LLVMConstantDataArrayValueKind = 16,
    LLVMConstantDataVectorValueKind = 17,
    LLVMConstantIntValueKind = 18,
    LLVMConstantFPValueKind = 19,
    LLVMConstantPointerNullValueKind = 20,
    LLVMConstantTokenNoneValueKind = 21,
    LLVMMetadataAsValueValueKind = 22,
    LLVMInlineAsmValueKind = 23,
    LLVMInstructionValueKind = 24,
    LLVMPoisonValueValueKind = 25,
    LLVMConstantTargetNoneValueKind = 26,
    LLVMConstantPtrAuthValueKind = 27);
  PLLVMValueKind = ^LLVMValueKind;

  LLVMIntPredicate = (
    (** equal *)
    LLVMIntEQ = 32,
    (** not equal *)
    LLVMIntNE = 33,
    (** unsigned greater than *)
    LLVMIntUGT = 34,
    (** unsigned greater or equal *)
    LLVMIntUGE = 35,
    (** unsigned less than *)
    LLVMIntULT = 36,
    (** unsigned less or equal *)
    LLVMIntULE = 37,
    (** signed greater than *)
    LLVMIntSGT = 38,
    (** signed greater or equal *)
    LLVMIntSGE = 39,
    (** signed less than *)
    LLVMIntSLT = 40,
    (** signed less or equal *)
    LLVMIntSLE = 41);
  PLLVMIntPredicate = ^LLVMIntPredicate;

  LLVMRealPredicate = (
    (** Always false (always folded) *)
    LLVMRealPredicateFalse = 0,
    (** True if ordered and equal *)
    LLVMRealOEQ = 1,
    (** True if ordered and greater than *)
    LLVMRealOGT = 2,
    (** True if ordered and greater than or equal *)
    LLVMRealOGE = 3,
    (** True if ordered and less than *)
    LLVMRealOLT = 4,
    (** True if ordered and less than or equal *)
    LLVMRealOLE = 5,
    (** True if ordered and operands are unequal *)
    LLVMRealONE = 6,
    (** True if ordered (no nans) *)
    LLVMRealORD = 7,
    (** True if unordered: isnan(X) | isnan(Y) *)
    LLVMRealUNO = 8,
    (** True if unordered or equal *)
    LLVMRealUEQ = 9,
    (** True if unordered or greater than *)
    LLVMRealUGT = 10,
    (** True if unordered, greater than, or equal *)
    LLVMRealUGE = 11,
    (** True if unordered or less than *)
    LLVMRealULT = 12,
    (** True if unordered, less than, or equal *)
    LLVMRealULE = 13,
    (** True if unordered or not equal *)
    LLVMRealUNE = 14,
    (** Always true (always folded) *)
    LLVMRealPredicateTrue = 15);
  PLLVMRealPredicate = ^LLVMRealPredicate;

  LLVMThreadLocalMode = (
    LLVMNotThreadLocal = 0,
    LLVMGeneralDynamicTLSModel = 1,
    LLVMLocalDynamicTLSModel = 2,
    LLVMInitialExecTLSModel = 3,
    LLVMLocalExecTLSModel = 4);
  PLLVMThreadLocalMode = ^LLVMThreadLocalMode;

  LLVMAtomicOrdering = (
    (** A load or store which is not atomic *)
    LLVMAtomicOrderingNotAtomic = 0,
    (** Lowest level of atomicity, guarantees
                                         somewhat sane results, lock free. *)
    LLVMAtomicOrderingUnordered = 1,
    (** guarantees that if you take all the
                                         operations affecting a specific address,
                                         a consistent ordering exists *)
    LLVMAtomicOrderingMonotonic = 2,
    (** Acquire provides a barrier of the sort
                                       necessary to acquire a lock to access other
                                       memory with normal loads and stores. *)
    LLVMAtomicOrderingAcquire = 4,
    (** Release is similar to Acquire, but with
                                       a barrier of the sort necessary to release
                                       a lock. *)
    LLVMAtomicOrderingRelease = 5,
    (** provides both an Acquire and a
                                              Release barrier (for fences and
                                              operations which both read and write
                                               memory). *)
    LLVMAtomicOrderingAcquireRelease = 6,
    (** provides Acquire semantics
                                                     for loads and Release
                                                     semantics for stores.
                                                     Additionally, it guarantees
                                                     that a total ordering exists
                                                     between all
                                                     SequentiallyConsistent
                                                     operations. *)
    LLVMAtomicOrderingSequentiallyConsistent = 7);
  PLLVMAtomicOrdering = ^LLVMAtomicOrdering;

  LLVMAtomicRMWBinOp = (
    (** Set the new value and return the one old *)
    LLVMAtomicRMWBinOpXchg = 0,
    (** Add a value and return the old one *)
    LLVMAtomicRMWBinOpAdd = 1,
    (** Subtract a value and return the old one *)
    LLVMAtomicRMWBinOpSub = 2,
    (** And a value and return the old one *)
    LLVMAtomicRMWBinOpAnd = 3,
    (** Not-And a value and return the old one *)
    LLVMAtomicRMWBinOpNand = 4,
    (** OR a value and return the old one *)
    LLVMAtomicRMWBinOpOr = 5,
    (** Xor a value and return the old one *)
    LLVMAtomicRMWBinOpXor = 6,
    (** Sets the value if it's greater than the
                                original using a signed comparison and return
                                the old one *)
    LLVMAtomicRMWBinOpMax = 7,
    (** Sets the value if it's Smaller than the
                                original using a signed comparison and return
                                the old one *)
    LLVMAtomicRMWBinOpMin = 8,
    (** Sets the value if it's greater than the
                               original using an unsigned comparison and return
                               the old one *)
    LLVMAtomicRMWBinOpUMax = 9,
    (** Sets the value if it's greater than the
                                original using an unsigned comparison and return
                                the old one *)
    LLVMAtomicRMWBinOpUMin = 10,
    (** Add a floating point value and return the
                                old one *)
    LLVMAtomicRMWBinOpFAdd = 11,
    (** Subtract a floating point value and return the
                              old one *)
    LLVMAtomicRMWBinOpFSub = 12,
    (** Sets the value if it's greater than the
                               original using an floating point comparison and
                               return the old one *)
    LLVMAtomicRMWBinOpFMax = 13,
    (** Sets the value if it's smaller than the
                               original using an floating point comparison and
                               return the old one *)
    LLVMAtomicRMWBinOpFMin = 14,
    (** Increments the value, wrapping back to zero
                                   when incremented above input value *)
    LLVMAtomicRMWBinOpUIncWrap = 15,
    (** Decrements the value, wrapping back to
                                   the input value when decremented below zero *)
    LLVMAtomicRMWBinOpUDecWrap = 16,
    (**Subtracts the value only if no unsigned
                                     overflow *)
    LLVMAtomicRMWBinOpUSubCond = 17,
    (**Subtracts the value, clamping to zero *)
    LLVMAtomicRMWBinOpUSubSat = 18,
    (** Sets the value if it's greater than the
                               original using an floating point comparison and
                               return the old one *)
    LLVMAtomicRMWBinOpFMaximum = 19,
    (** Sets the value if it's smaller than the
                               original using an floating point comparison and
                               return the old one *)
    LLVMAtomicRMWBinOpFMinimum = 20);
  PLLVMAtomicRMWBinOp = ^LLVMAtomicRMWBinOp;

  LLVMDiagnosticSeverity = (
    LLVMDSError = 0,
    LLVMDSWarning = 1,
    LLVMDSRemark = 2,
    LLVMDSNote = 3);
  PLLVMDiagnosticSeverity = ^LLVMDiagnosticSeverity;

  LLVMInlineAsmDialect = (
    LLVMInlineAsmDialectATT = 0,
    LLVMInlineAsmDialectIntel = 1);
  PLLVMInlineAsmDialect = ^LLVMInlineAsmDialect;

  LLVMModuleFlagBehavior = (
    (**
     * Emits an error if two values disagree, otherwise the resulting value is
     * that of the operands.
     *
     * @see Module::ModFlagBehavior::Error
     *)
    LLVMModuleFlagBehaviorError = 0,
    (**
     * Emits a warning if two values disagree. The result value will be the
     * operand for the flag from the first module being linked.
     *
     * @see Module::ModFlagBehavior::Warning
     *)
    LLVMModuleFlagBehaviorWarning = 1,
    (**
     * Adds a requirement that another module flag be present and have a
     * specified value after linking is performed. The value must be a metadata
     * pair, where the first element of the pair is the ID of the module flag
     * to be restricted, and the second element of the pair is the value the
     * module flag should be restricted to. This behavior can be used to
     * restrict the allowable results (via triggering of an error) of linking
     * IDs with the **Override** behavior.
     *
     * @see Module::ModFlagBehavior::Require
     *)
    LLVMModuleFlagBehaviorRequire = 2,
    (**
     * Uses the specified value, regardless of the behavior or value of the
     * other module. If both modules specify **Override**, but the values
     * differ, an error will be emitted.
     *
     * @see Module::ModFlagBehavior::Override
     *)
    LLVMModuleFlagBehaviorOverride = 3,
    (**
     * Appends the two values, which are required to be metadata nodes.
     *
     * @see Module::ModFlagBehavior::Append
     *)
    LLVMModuleFlagBehaviorAppend = 4,
    (**
     * Appends the two values, which are required to be metadata
     * nodes. However, duplicate entries in the second list are dropped
     * during the append operation.
     *
     * @see Module::ModFlagBehavior::AppendUnique
     *)
    LLVMModuleFlagBehaviorAppendUnique = 5);
  PLLVMModuleFlagBehavior = ^LLVMModuleFlagBehavior;

  (**
   * Attribute index are either LLVMAttributeReturnIndex,
   * LLVMAttributeFunctionIndex or a parameter number from 1 to N.
   *)
  _anonymous_type_1 = (
    LLVMAttributeReturnIndex = 0,
    LLVMAttributeFunctionIndex = -1);
  P_anonymous_type_1 = ^_anonymous_type_1;
  LLVMAttributeIndex = Cardinal;

  (**
   * Tail call kind for LLVMSetTailCallKind and LLVMGetTailCallKind.
   *
   * Note that 'musttail' implies 'tail'.
   *
   * @see CallInst::TailCallKind
   *)
  LLVMTailCallKind = (
    LLVMTailCallKindNone = 0,
    LLVMTailCallKindTail = 1,
    LLVMTailCallKindMustTail = 2,
    LLVMTailCallKindNoTail = 3);
  PLLVMTailCallKind = ^LLVMTailCallKind;

  _anonymous_type_2 = (
    LLVMFastMathAllowReassoc = 1,
    LLVMFastMathNoNaNs = 2,
    LLVMFastMathNoInfs = 4,
    LLVMFastMathNoSignedZeros = 8,
    LLVMFastMathAllowReciprocal = 16,
    LLVMFastMathAllowContract = 32,
    LLVMFastMathApproxFunc = 64,
    LLVMFastMathNone = 0,
    LLVMFastMathAll = 127);
  P_anonymous_type_2 = ^_anonymous_type_2;
  (**
   * Flags to indicate what fast-math-style optimizations are allowed
   * on operations.
   *
   * See https://llvm.org/docs/LangRef.html#fast-math-flags
   *)
  LLVMFastMathFlags = Cardinal;

  _anonymous_type_3 = (
    LLVMGEPFlagInBounds = 1,
    LLVMGEPFlagNUSW = 2,
    LLVMGEPFlagNUW = 4);
  P_anonymous_type_3 = ^_anonymous_type_3;
  (**
   * Flags that constrain the allowed wrap semantics of a getelementptr
   * instruction.
   *
   * See https://llvm.org/docs/LangRef.html#getelementptr-instruction
   *)
  LLVMGEPNoWrapFlags = Cardinal;

  (**
   * @defgroup LLVMCCoreContext Contexts
   *
   * Contexts are execution states for the core LLVM IR system.
   *
   * Most types are tied to a context instance. Multiple contexts can
   * exist simultaneously. A single context is not thread safe. However,
   * different contexts can execute on different threads simultaneously.
   *
   * @{
   *)
  LLVMDiagnosticHandler = procedure(p1: LLVMDiagnosticInfoRef; p2: Pointer); cdecl;

  LLVMYieldCallback = procedure(p1: LLVMContextRef; p2: Pointer); cdecl;

  (**
   * Debug info flags.
   *)
  LLVMDIFlags = (
    LLVMDIFlagZero = 0,
    LLVMDIFlagPrivate = 1,
    LLVMDIFlagProtected = 2,
    LLVMDIFlagPublic = 3,
    LLVMDIFlagFwdDecl = 4,
    LLVMDIFlagAppleBlock = 8,
    LLVMDIFlagReservedBit4 = 16,
    LLVMDIFlagVirtual = 32,
    LLVMDIFlagArtificial = 64,
    LLVMDIFlagExplicit = 128,
    LLVMDIFlagPrototyped = 256,
    LLVMDIFlagObjcClassComplete = 512,
    LLVMDIFlagObjectPointer = 1024,
    LLVMDIFlagVector = 2048,
    LLVMDIFlagStaticMember = 4096,
    LLVMDIFlagLValueReference = 8192,
    LLVMDIFlagRValueReference = 16384,
    LLVMDIFlagReserved = 32768,
    LLVMDIFlagSingleInheritance = 65536,
    LLVMDIFlagMultipleInheritance = 131072,
    LLVMDIFlagVirtualInheritance = 196608,
    LLVMDIFlagIntroducedVirtual = 262144,
    LLVMDIFlagBitField = 524288,
    LLVMDIFlagNoReturn = 1048576,
    LLVMDIFlagTypePassByValue = 4194304,
    LLVMDIFlagTypePassByReference = 8388608,
    LLVMDIFlagEnumClass = 16777216,
    LLVMDIFlagFixedEnum = 16777216,
    LLVMDIFlagThunk = 33554432,
    LLVMDIFlagNonTrivial = 67108864,
    LLVMDIFlagBigEndian = 134217728,
    LLVMDIFlagLittleEndian = 268435456,
    LLVMDIFlagIndirectVirtualBase = 36,
    LLVMDIFlagAccessibility = 3,
    LLVMDIFlagPtrToMemberRep = 196608);
  PLLVMDIFlags = ^LLVMDIFlags;

  (**
   * Source languages known by DWARF.
   *)
  LLVMDWARFSourceLanguage = (
    LLVMDWARFSourceLanguageC89 = 0,
    LLVMDWARFSourceLanguageC = 1,
    LLVMDWARFSourceLanguageAda83 = 2,
    LLVMDWARFSourceLanguageC_plus_plus = 3,
    LLVMDWARFSourceLanguageCobol74 = 4,
    LLVMDWARFSourceLanguageCobol85 = 5,
    LLVMDWARFSourceLanguageFortran77 = 6,
    LLVMDWARFSourceLanguageFortran90 = 7,
    LLVMDWARFSourceLanguagePascal83 = 8,
    LLVMDWARFSourceLanguageModula2 = 9,
    LLVMDWARFSourceLanguageJava = 10,
    LLVMDWARFSourceLanguageC99 = 11,
    LLVMDWARFSourceLanguageAda95 = 12,
    LLVMDWARFSourceLanguageFortran95 = 13,
    LLVMDWARFSourceLanguagePLI = 14,
    LLVMDWARFSourceLanguageObjC = 15,
    LLVMDWARFSourceLanguageObjC_plus_plus = 16,
    LLVMDWARFSourceLanguageUPC = 17,
    LLVMDWARFSourceLanguageD = 18,
    LLVMDWARFSourceLanguagePython = 19,
    LLVMDWARFSourceLanguageOpenCL = 20,
    LLVMDWARFSourceLanguageGo = 21,
    LLVMDWARFSourceLanguageModula3 = 22,
    LLVMDWARFSourceLanguageHaskell = 23,
    LLVMDWARFSourceLanguageC_plus_plus_03 = 24,
    LLVMDWARFSourceLanguageC_plus_plus_11 = 25,
    LLVMDWARFSourceLanguageOCaml = 26,
    LLVMDWARFSourceLanguageRust = 27,
    LLVMDWARFSourceLanguageC11 = 28,
    LLVMDWARFSourceLanguageSwift = 29,
    LLVMDWARFSourceLanguageJulia = 30,
    LLVMDWARFSourceLanguageDylan = 31,
    LLVMDWARFSourceLanguageC_plus_plus_14 = 32,
    LLVMDWARFSourceLanguageFortran03 = 33,
    LLVMDWARFSourceLanguageFortran08 = 34,
    LLVMDWARFSourceLanguageRenderScript = 35,
    LLVMDWARFSourceLanguageBLISS = 36,
    LLVMDWARFSourceLanguageKotlin = 37,
    LLVMDWARFSourceLanguageZig = 38,
    LLVMDWARFSourceLanguageCrystal = 39,
    LLVMDWARFSourceLanguageC_plus_plus_17 = 40,
    LLVMDWARFSourceLanguageC_plus_plus_20 = 41,
    LLVMDWARFSourceLanguageC17 = 42,
    LLVMDWARFSourceLanguageFortran18 = 43,
    LLVMDWARFSourceLanguageAda2005 = 44,
    LLVMDWARFSourceLanguageAda2012 = 45,
    LLVMDWARFSourceLanguageHIP = 46,
    LLVMDWARFSourceLanguageAssembly = 47,
    LLVMDWARFSourceLanguageC_sharp = 48,
    LLVMDWARFSourceLanguageMojo = 49,
    LLVMDWARFSourceLanguageGLSL = 50,
    LLVMDWARFSourceLanguageGLSL_ES = 51,
    LLVMDWARFSourceLanguageHLSL = 52,
    LLVMDWARFSourceLanguageOpenCL_CPP = 53,
    LLVMDWARFSourceLanguageCPP_for_OpenCL = 54,
    LLVMDWARFSourceLanguageSYCL = 55,
    LLVMDWARFSourceLanguageRuby = 56,
    LLVMDWARFSourceLanguageMove = 57,
    LLVMDWARFSourceLanguageHylo = 58,
    LLVMDWARFSourceLanguageMetal = 59,
    LLVMDWARFSourceLanguageMips_Assembler = 60,
    LLVMDWARFSourceLanguageGOOGLE_RenderScript = 61,
    LLVMDWARFSourceLanguageBORLAND_Delphi = 62);
  PLLVMDWARFSourceLanguage = ^LLVMDWARFSourceLanguage;

  (**
   * The amount of debug information to emit.
   *)
  LLVMDWARFEmissionKind = (
    LLVMDWARFEmissionNone = 0,
    LLVMDWARFEmissionFull = 1,
    LLVMDWARFEmissionLineTablesOnly = 2);
  PLLVMDWARFEmissionKind = ^LLVMDWARFEmissionKind;

  (**
   * The kind of metadata nodes.
   *)
  _anonymous_type_4 = (
    LLVMMDStringMetadataKind = 0,
    LLVMConstantAsMetadataMetadataKind = 1,
    LLVMLocalAsMetadataMetadataKind = 2,
    LLVMDistinctMDOperandPlaceholderMetadataKind = 3,
    LLVMMDTupleMetadataKind = 4,
    LLVMDILocationMetadataKind = 5,
    LLVMDIExpressionMetadataKind = 6,
    LLVMDIGlobalVariableExpressionMetadataKind = 7,
    LLVMGenericDINodeMetadataKind = 8,
    LLVMDISubrangeMetadataKind = 9,
    LLVMDIEnumeratorMetadataKind = 10,
    LLVMDIBasicTypeMetadataKind = 11,
    LLVMDIDerivedTypeMetadataKind = 12,
    LLVMDICompositeTypeMetadataKind = 13,
    LLVMDISubroutineTypeMetadataKind = 14,
    LLVMDIFileMetadataKind = 15,
    LLVMDICompileUnitMetadataKind = 16,
    LLVMDISubprogramMetadataKind = 17,
    LLVMDILexicalBlockMetadataKind = 18,
    LLVMDILexicalBlockFileMetadataKind = 19,
    LLVMDINamespaceMetadataKind = 20,
    LLVMDIModuleMetadataKind = 21,
    LLVMDITemplateTypeParameterMetadataKind = 22,
    LLVMDITemplateValueParameterMetadataKind = 23,
    LLVMDIGlobalVariableMetadataKind = 24,
    LLVMDILocalVariableMetadataKind = 25,
    LLVMDILabelMetadataKind = 26,
    LLVMDIObjCPropertyMetadataKind = 27,
    LLVMDIImportedEntityMetadataKind = 28,
    LLVMDIMacroMetadataKind = 29,
    LLVMDIMacroFileMetadataKind = 30,
    LLVMDICommonBlockMetadataKind = 31,
    LLVMDIStringTypeMetadataKind = 32,
    LLVMDIGenericSubrangeMetadataKind = 33,
    LLVMDIArgListMetadataKind = 34,
    LLVMDIAssignIDMetadataKind = 35,
    LLVMDISubrangeTypeMetadataKind = 36,
    LLVMDIFixedPointTypeMetadataKind = 37);
  P_anonymous_type_4 = ^_anonymous_type_4;
  LLVMMetadataKind = Cardinal;
  (**
   * An LLVM DWARF type encoding.
   *)
  LLVMDWARFTypeEncoding = Cardinal;

  (**
   * Describes the kind of macro declaration used for LLVMDIBuilderCreateMacro.
   * @see llvm::dwarf::MacinfoRecordType
   * @note Values are from DW_MACINFO_* constants in the DWARF specification.
   *)
  LLVMDWARFMacinfoRecordType = (
    LLVMDWARFMacinfoRecordTypeDefine = 1,
    LLVMDWARFMacinfoRecordTypeMacro = 2,
    LLVMDWARFMacinfoRecordTypeStartFile = 3,
    LLVMDWARFMacinfoRecordTypeEndFile = 4,
    LLVMDWARFMacinfoRecordTypeVendorExt = 255);
  PLLVMDWARFMacinfoRecordType = ^LLVMDWARFMacinfoRecordType;
  (**
   * An opaque reference to a disassembler context.
   *)
  LLVMDisasmContextRef = Pointer;

  (**
   * The type for the operand information call back function.  This is called to
   * get the symbolic information for an operand of an instruction.  Typically
   * this is from the relocation information, symbol table, etc.  That block of
   * information is saved when the disassembler context is created and passed to
   * the call back in the DisInfo parameter.  The instruction containing operand
   * is at the PC parameter.  For some instruction sets, there can be more than
   * one operand with symbolic information.  To determine the symbolic operand
   * information for each operand, the bytes for the specific operand in the
   * instruction are specified by the Offset parameter and its byte widith is the
   * OpSize parameter.  For instructions sets with fixed widths and one symbolic
   * operand per instruction, the Offset parameter will be zero and InstSize
   * parameter will be the instruction width.  The information is returned in
   * TagBuf and is Triple specific with its specific information defined by the
   * value of TagType for that Triple.  If symbolic information is returned the
   * function * returns 1, otherwise it returns 0.
   *)
  LLVMOpInfoCallback = function(DisInfo: Pointer; PC: UInt64; Offset: UInt64; OpSize: UInt64; InstSize: UInt64; TagType: Integer; TagBuf: Pointer): Integer; cdecl;

  (**
   * The initial support in LLVM MC for the most general form of a relocatable
   * expression is "AddSymbol - SubtractSymbol + Offset".  For some Darwin targets
   * this full form is encoded in the relocation information so that AddSymbol and
   * SubtractSymbol can be link edited independent of each other.  Many other
   * platforms only allow a relocatable expression of the form AddSymbol + Offset
   * to be encoded.
   *
   * The LLVMOpInfoCallback() for the TagType value of 1 uses the struct
   * LLVMOpInfo1.  The value of the relocatable expression for the operand,
   * including any PC adjustment, is passed in to the call back in the Value
   * field.  The symbolic information about the operand is returned using all
   * the fields of the structure with the Offset of the relocatable expression
   * returned in the Value field.  It is possible that some symbols in the
   * relocatable expression were assembly temporary symbols, for example
   * "Ldata - LpicBase + constant", and only the Values of the symbols without
   * symbol names are present in the relocation information.  The VariantKind
   * type is one of the Target specific #defines below and is used to print
   * operands like "_foo@GOT", ":lower16:_foo", etc.
   *)
  LLVMOpInfoSymbol1 = record
    Present: UInt64;
    Name: PUTF8Char;
    Value: UInt64;
  end;

  LLVMOpInfo1 = record
    AddSymbol: LLVMOpInfoSymbol1;
    SubtractSymbol: LLVMOpInfoSymbol1;
    Value: UInt64;
    VariantKind: UInt64;
  end;

  (**
   * The type for the symbol lookup function.  This may be called by the
   * disassembler for things like adding a comment for a PC plus a constant
   * offset load instruction to use a symbol name instead of a load address value.
   * It is passed the block information is saved when the disassembler context is
   * created and the ReferenceValue to look up as a symbol.  If no symbol is found
   * for the ReferenceValue NULL is returned.  The ReferenceType of the
   * instruction is passed indirectly as is the PC of the instruction in
   * ReferencePC.  If the output reference can be determined its type is returned
   * indirectly in ReferenceType along with ReferenceName if any, or that is set
   * to NULL.
   *)
  LLVMSymbolLookupCallback = function(DisInfo: Pointer; ReferenceValue: UInt64; ReferenceType: PUInt64; ReferencePC: UInt64; ReferenceName: PPUTF8Char): PUTF8Char; cdecl;
  LLVMGenericValueRef = Pointer;
  PLLVMGenericValueRef = ^LLVMGenericValueRef;
  LLVMExecutionEngineRef = Pointer;
  PLLVMExecutionEngineRef = ^LLVMExecutionEngineRef;
  LLVMMCJITMemoryManagerRef = Pointer;
  PLLVMMCJITMemoryManagerRef = ^LLVMMCJITMemoryManagerRef;

  LLVMMCJITCompilerOptions = record
    OptLevel: Cardinal;
    CodeModel: LLVMCodeModel;
    NoFramePointerElim: LLVMBool;
    EnableFastISel: LLVMBool;
    MCJMM: LLVMMCJITMemoryManagerRef;
  end;

  LLVMMemoryManagerAllocateCodeSectionCallback = function(Opaque: Pointer; Size: UIntPtr; Alignment: Cardinal; SectionID: Cardinal; const SectionName: PUTF8Char): PUInt8; cdecl;

  LLVMMemoryManagerAllocateDataSectionCallback = function(Opaque: Pointer; Size: UIntPtr; Alignment: Cardinal; SectionID: Cardinal; const SectionName: PUTF8Char; IsReadOnly: LLVMBool): PUInt8; cdecl;

  LLVMMemoryManagerFinalizeMemoryCallback = function(Opaque: Pointer; ErrMsg: PPUTF8Char): LLVMBool; cdecl;

  LLVMMemoryManagerDestroyCallback = procedure(Opaque: Pointer); cdecl;

  (**
   * @defgroup LLVMCCoreLinker Linker
   * @ingroup LLVMCCore
   *
   * @{
   *)
  LLVMLinkerMode = (
    LLVMLinkerDestroySource = 0,
    LLVMLinkerPreserveSource_Removed = 1);
  PLLVMLinkerMode = ^LLVMLinkerMode;
  (**
   * Represents an address in the executor process.
   *)
  LLVMOrcJITTargetAddress = UInt64;
  (**
   * Represents an address in the executor process.
   *)
  LLVMOrcExecutorAddress = UInt64;
  PLLVMOrcExecutorAddress = ^LLVMOrcExecutorAddress;

  (**
   * Represents generic linkage flags for a symbol definition.
   *)
  LLVMJITSymbolGenericFlags = (
    LLVMJITSymbolGenericFlagsNone = 0,
    LLVMJITSymbolGenericFlagsExported = 1,
    LLVMJITSymbolGenericFlagsWeak = 2,
    LLVMJITSymbolGenericFlagsCallable = 4,
    LLVMJITSymbolGenericFlagsMaterializationSideEffectsOnly = 8);
  PLLVMJITSymbolGenericFlags = ^LLVMJITSymbolGenericFlags;
  (**
   * Represents target specific flags for a symbol definition.
   *)
  LLVMJITSymbolTargetFlags = UInt8;

  (**
   * Represents the linkage flags for a symbol definition.
   *)
  LLVMJITSymbolFlags = record
    GenericFlags: UInt8;
    TargetFlags: UInt8;
  end;

  (**
   * Represents an evaluated symbol address and flags.
   *)
  LLVMJITEvaluatedSymbol = record
    Address: LLVMOrcExecutorAddress;
    Flags: LLVMJITSymbolFlags;
  end;

  LLVMOrcExecutionSessionRef = Pointer;
  PLLVMOrcExecutionSessionRef = ^LLVMOrcExecutionSessionRef;

  (**
   * Error reporter function.
   *)
  LLVMOrcErrorReporterFunction = procedure(Ctx: Pointer; Err: LLVMErrorRef); cdecl;
  LLVMOrcSymbolStringPoolRef = Pointer;
  PLLVMOrcSymbolStringPoolRef = ^LLVMOrcSymbolStringPoolRef;
  LLVMOrcSymbolStringPoolEntryRef = Pointer;
  PLLVMOrcSymbolStringPoolEntryRef = ^LLVMOrcSymbolStringPoolEntryRef;

  (**
   * Represents a pair of a symbol name and LLVMJITSymbolFlags.
   *)
  LLVMOrcCSymbolFlagsMapPair = record
    Name: LLVMOrcSymbolStringPoolEntryRef;
    Flags: LLVMJITSymbolFlags;
  end;

  (**
   * Represents a list of (SymbolStringPtr, JITSymbolFlags) pairs that can be used
   * to construct a SymbolFlagsMap.
   *)
  LLVMOrcCSymbolFlagsMapPairs = PLLVMOrcCSymbolFlagsMapPair;

  (**
   * Represents a pair of a symbol name and an evaluated symbol.
   *)
  LLVMOrcCSymbolMapPair = record
    Name: LLVMOrcSymbolStringPoolEntryRef;
    Sym: LLVMJITEvaluatedSymbol;
  end;

  (**
   * Represents a list of (SymbolStringPtr, JITEvaluatedSymbol) pairs that can be
   * used to construct a SymbolMap.
   *)
  LLVMOrcCSymbolMapPairs = PLLVMOrcCSymbolMapPair;

  (**
   * Represents a SymbolAliasMapEntry
   *)
  LLVMOrcCSymbolAliasMapEntry = record
    Name: LLVMOrcSymbolStringPoolEntryRef;
    Flags: LLVMJITSymbolFlags;
  end;

  (**
   * Represents a pair of a symbol name and SymbolAliasMapEntry.
   *)
  LLVMOrcCSymbolAliasMapPair = record
    Name: LLVMOrcSymbolStringPoolEntryRef;
    Entry: LLVMOrcCSymbolAliasMapEntry;
  end;

  (**
   * Represents a list of (SymbolStringPtr, (SymbolStringPtr, JITSymbolFlags))
   * pairs that can be used to construct a SymbolFlagsMap.
   *)
  LLVMOrcCSymbolAliasMapPairs = PLLVMOrcCSymbolAliasMapPair;
  LLVMOrcJITDylibRef = Pointer;
  PLLVMOrcJITDylibRef = ^LLVMOrcJITDylibRef;

  (**
   * Represents a list of LLVMOrcSymbolStringPoolEntryRef and the associated
   * length.
   *)
  LLVMOrcCSymbolsList = record
    Symbols: PLLVMOrcSymbolStringPoolEntryRef;
    Length: NativeUInt;
  end;

  (**
   * Represents a pair of a JITDylib and LLVMOrcCSymbolsList.
   *)
  LLVMOrcCDependenceMapPair = record
    JD: LLVMOrcJITDylibRef;
    Names: LLVMOrcCSymbolsList;
  end;

  (**
   * Represents a list of (JITDylibRef, (LLVMOrcSymbolStringPoolEntryRef*,
   * size_t)) pairs that can be used to construct a SymbolDependenceMap.
   *)
  LLVMOrcCDependenceMapPairs = PLLVMOrcCDependenceMapPair;

  (**
   * A set of symbols that share dependencies.
   *)
  LLVMOrcCSymbolDependenceGroup = record
    Symbols: LLVMOrcCSymbolsList;
    Dependencies: LLVMOrcCDependenceMapPairs;
    NumDependencies: NativeUInt;
  end;

  (**
   * Lookup kind. This can be used by definition generators when deciding whether
   * to produce a definition for a requested symbol.
   *
   * This enum should be kept in sync with llvm::orc::LookupKind.
   *)
  LLVMOrcLookupKind = (
    LLVMOrcLookupKindStatic = 0,
    LLVMOrcLookupKindDLSym = 1);
  PLLVMOrcLookupKind = ^LLVMOrcLookupKind;

  (**
   * JITDylib lookup flags. This can be used by definition generators when
   * deciding whether to produce a definition for a requested symbol.
   *
   * This enum should be kept in sync with llvm::orc::JITDylibLookupFlags.
   *)
  LLVMOrcJITDylibLookupFlags = (
    LLVMOrcJITDylibLookupFlagsMatchExportedSymbolsOnly = 0,
    LLVMOrcJITDylibLookupFlagsMatchAllSymbols = 1);
  PLLVMOrcJITDylibLookupFlags = ^LLVMOrcJITDylibLookupFlags;

  (**
   * An element type for a JITDylib search order.
   *)
  LLVMOrcCJITDylibSearchOrderElement = record
    JD: LLVMOrcJITDylibRef;
    JDLookupFlags: LLVMOrcJITDylibLookupFlags;
  end;

  (**
   * A JITDylib search order.
   *
   * The list is terminated with an element containing a null pointer for the JD
   * field.
   *)
  LLVMOrcCJITDylibSearchOrder = PLLVMOrcCJITDylibSearchOrderElement;

  (**
   * Symbol lookup flags for lookup sets. This should be kept in sync with
   * llvm::orc::SymbolLookupFlags.
   *)
  LLVMOrcSymbolLookupFlags = (
    LLVMOrcSymbolLookupFlagsRequiredSymbol = 0,
    LLVMOrcSymbolLookupFlagsWeaklyReferencedSymbol = 1);
  PLLVMOrcSymbolLookupFlags = ^LLVMOrcSymbolLookupFlags;

  (**
   * An element type for a symbol lookup set.
   *)
  LLVMOrcCLookupSetElement = record
    Name: LLVMOrcSymbolStringPoolEntryRef;
    LookupFlags: LLVMOrcSymbolLookupFlags;
  end;

  (**
   * A set of symbols to look up / generate.
   *
   * The list is terminated with an element containing a null pointer for the
   * Name field.
   *
   * If a client creates an instance of this type then they are responsible for
   * freeing it, and for ensuring that all strings have been retained over the
   * course of its life. Clients receiving a copy from a callback are not
   * responsible for managing lifetime or retain counts.
   *)
  LLVMOrcCLookupSet = PLLVMOrcCLookupSetElement;
  LLVMOrcMaterializationUnitRef = Pointer;
  PLLVMOrcMaterializationUnitRef = ^LLVMOrcMaterializationUnitRef;
  LLVMOrcMaterializationResponsibilityRef = Pointer;
  PLLVMOrcMaterializationResponsibilityRef = ^LLVMOrcMaterializationResponsibilityRef;

  (**
   * A MaterializationUnit materialize callback.
   *
   * Ownership of the Ctx and MR arguments passes to the callback which must
   * adhere to the LLVMOrcMaterializationResponsibilityRef contract (see comment
   * for that type).
   *
   * If this callback is called then the LLVMOrcMaterializationUnitDestroy
   * callback will NOT be called.
   *)
  LLVMOrcMaterializationUnitMaterializeFunction = procedure(Ctx: Pointer; MR: LLVMOrcMaterializationResponsibilityRef); cdecl;

  (**
   * A MaterializationUnit discard callback.
   *
   * Ownership of JD and Symbol remain with the caller: These arguments should
   * not be disposed of or released.
   *)
  LLVMOrcMaterializationUnitDiscardFunction = procedure(Ctx: Pointer; JD: LLVMOrcJITDylibRef; Symbol: LLVMOrcSymbolStringPoolEntryRef); cdecl;

  (**
   * A MaterializationUnit destruction callback.
   *
   * If a custom MaterializationUnit is destroyed before its Materialize
   * function is called then this function will be called to provide an
   * opportunity for the underlying program representation to be destroyed.
   *)
  LLVMOrcMaterializationUnitDestroyFunction = procedure(Ctx: Pointer); cdecl;
  LLVMOrcResourceTrackerRef = Pointer;
  PLLVMOrcResourceTrackerRef = ^LLVMOrcResourceTrackerRef;
  LLVMOrcDefinitionGeneratorRef = Pointer;
  PLLVMOrcDefinitionGeneratorRef = ^LLVMOrcDefinitionGeneratorRef;
  LLVMOrcLookupStateRef = Pointer;
  PLLVMOrcLookupStateRef = ^LLVMOrcLookupStateRef;

  (**
   * A custom generator function. This can be used to create a custom generator
   * object using LLVMOrcCreateCustomCAPIDefinitionGenerator. The resulting
   * object can be attached to a JITDylib, via LLVMOrcJITDylibAddGenerator, to
   * receive callbacks when lookups fail to match existing definitions.
   *
   * GeneratorObj will contain the address of the custom generator object.
   *
   * Ctx will contain the context object passed to
   * LLVMOrcCreateCustomCAPIDefinitionGenerator.
   *
   * LookupState will contain a pointer to an LLVMOrcLookupStateRef object. This
   * can optionally be modified to make the definition generation process
   * asynchronous: If the LookupStateRef value is copied, and the original
   * LLVMOrcLookupStateRef set to null, the lookup will be suspended. Once the
   * asynchronous definition process has been completed clients must call
   * LLVMOrcLookupStateContinueLookup to continue the lookup (this should be
   * done unconditionally, even if errors have occurred in the mean time, to
   * free the lookup state memory and notify the query object of the failures).
   * If LookupState is captured this function must return LLVMErrorSuccess.
   *
   * The Kind argument can be inspected to determine the lookup kind (e.g.
   * as-if-during-static-link, or as-if-during-dlsym).
   *
   * The JD argument specifies which JITDylib the definitions should be generated
   * into.
   *
   * The JDLookupFlags argument can be inspected to determine whether the original
   * lookup included non-exported symbols.
   *
   * Finally, the LookupSet argument contains the set of symbols that could not
   * be found in JD already (the set of generation candidates).
   *)
  LLVMOrcCAPIDefinitionGeneratorTryToGenerateFunction = function(GeneratorObj: LLVMOrcDefinitionGeneratorRef; Ctx: Pointer; LookupState: PLLVMOrcLookupStateRef; Kind: LLVMOrcLookupKind; JD: LLVMOrcJITDylibRef; JDLookupFlags: LLVMOrcJITDylibLookupFlags; LookupSet: LLVMOrcCLookupSet; LookupSetSize: NativeUInt): LLVMErrorRef; cdecl;

  (**
   * Disposer for a custom generator.
   *
   * Will be called by ORC when the JITDylib that the generator is attached to
   * is destroyed.
   *)
  LLVMOrcDisposeCAPIDefinitionGeneratorFunction = procedure(Ctx: Pointer); cdecl;

  (**
   * Predicate function for SymbolStringPoolEntries.
   *)
  LLVMOrcSymbolPredicate = function(Ctx: Pointer; Sym: LLVMOrcSymbolStringPoolEntryRef): Integer; cdecl;
  LLVMOrcThreadSafeContextRef = Pointer;
  PLLVMOrcThreadSafeContextRef = ^LLVMOrcThreadSafeContextRef;
  LLVMOrcThreadSafeModuleRef = Pointer;
  PLLVMOrcThreadSafeModuleRef = ^LLVMOrcThreadSafeModuleRef;

  (**
   * A function for inspecting/mutating IR modules, suitable for use with
   * LLVMOrcThreadSafeModuleWithModuleDo.
   *)
  LLVMOrcGenericIRModuleOperationFunction = function(Ctx: Pointer; M: LLVMModuleRef): LLVMErrorRef; cdecl;
  LLVMOrcJITTargetMachineBuilderRef = Pointer;
  PLLVMOrcJITTargetMachineBuilderRef = ^LLVMOrcJITTargetMachineBuilderRef;
  LLVMOrcObjectLayerRef = Pointer;
  PLLVMOrcObjectLayerRef = ^LLVMOrcObjectLayerRef;
  LLVMOrcObjectLinkingLayerRef = Pointer;
  PLLVMOrcObjectLinkingLayerRef = ^LLVMOrcObjectLinkingLayerRef;
  LLVMOrcIRTransformLayerRef = Pointer;
  PLLVMOrcIRTransformLayerRef = ^LLVMOrcIRTransformLayerRef;

  (**
   * A function for applying transformations as part of an transform layer.
   *
   * Implementations of this type are responsible for managing the lifetime
   * of the Module pointed to by ModInOut: If the LLVMModuleRef value is
   * overwritten then the function is responsible for disposing of the incoming
   * module. If the module is simply accessed/mutated in-place then ownership
   * returns to the caller and the function does not need to do any lifetime
   * management.
   *
   * Clients can call LLVMOrcLLJITGetIRTransformLayer to obtain the transform
   * layer of a LLJIT instance, and use LLVMOrcIRTransformLayerSetTransform
   * to set the function. This can be used to override the default transform
   * layer.
   *)
  LLVMOrcIRTransformLayerTransformFunction = function(Ctx: Pointer; ModInOut: PLLVMOrcThreadSafeModuleRef; MR: LLVMOrcMaterializationResponsibilityRef): LLVMErrorRef; cdecl;
  LLVMOrcObjectTransformLayerRef = Pointer;
  PLLVMOrcObjectTransformLayerRef = ^LLVMOrcObjectTransformLayerRef;

  (**
   * A function for applying transformations to an object file buffer.
   *
   * Implementations of this type are responsible for managing the lifetime
   * of the memory buffer pointed to by ObjInOut: If the LLVMMemoryBufferRef
   * value is overwritten then the function is responsible for disposing of the
   * incoming buffer. If the buffer is simply accessed/mutated in-place then
   * ownership returns to the caller and the function does not need to do any
   * lifetime management.
   *
   * The transform is allowed to return an error, in which case the ObjInOut
   * buffer should be disposed of and set to null.
   *)
  LLVMOrcObjectTransformLayerTransformFunction = function(Ctx: Pointer; ObjInOut: PLLVMMemoryBufferRef): LLVMErrorRef; cdecl;
  LLVMOrcIndirectStubsManagerRef = Pointer;
  PLLVMOrcIndirectStubsManagerRef = ^LLVMOrcIndirectStubsManagerRef;
  LLVMOrcLazyCallThroughManagerRef = Pointer;
  PLLVMOrcLazyCallThroughManagerRef = ^LLVMOrcLazyCallThroughManagerRef;
  LLVMOrcDumpObjectsRef = Pointer;
  PLLVMOrcDumpObjectsRef = ^LLVMOrcDumpObjectsRef;

  (**
   * Callback type for ExecutionSession lookups.
   *
   * If Err is LLVMErrorSuccess then Result will contain a pointer to a
   * list of ( SymbolStringPtr, JITEvaluatedSymbol ) pairs of length NumPairs.
   *
   * If Err is a failure value then Result and Ctx are undefined and should
   * not be accessed. The Callback is responsible for handling the error
   * value (e.g. by calling LLVMGetErrorMessage + LLVMDisposeErrorMessage).
   *
   * The caller retains ownership of the Result array and will release all
   * contained symbol names. Clients are responsible for retaining any symbol
   * names that they wish to hold after the function returns.
   *)
  LLVMOrcExecutionSessionLookupHandleResultFunction = procedure(Err: LLVMErrorRef; Result: LLVMOrcCSymbolMapPairs; NumPairs: NativeUInt; Ctx: Pointer); cdecl;

  (**
   * A function for constructing an ObjectLinkingLayer instance to be used
   * by an LLJIT instance.
   *
   * Clients can call LLVMOrcLLJITBuilderSetObjectLinkingLayerCreator to
   * set the creator function to use when constructing an LLJIT instance.
   * This can be used to override the default linking layer implementation
   * that would otherwise be chosen by LLJITBuilder.
   *
   * Object linking layers returned by this function will become owned by the
   * LLJIT instance. The client is not responsible for managing their lifetimes
   * after the function returns.
   *)
  LLVMOrcLLJITBuilderObjectLinkingLayerCreatorFunction = function(Ctx: Pointer; ES: LLVMOrcExecutionSessionRef; const Triple: PUTF8Char): LLVMOrcObjectLayerRef; cdecl;
  LLVMOrcLLJITBuilderRef = Pointer;
  PLLVMOrcLLJITBuilderRef = ^LLVMOrcLLJITBuilderRef;
  LLVMOrcLLJITRef = Pointer;
  PLLVMOrcLLJITRef = ^LLVMOrcLLJITRef;
  LLVMSectionIteratorRef = Pointer;
  PLLVMSectionIteratorRef = ^LLVMSectionIteratorRef;
  LLVMSymbolIteratorRef = Pointer;
  PLLVMSymbolIteratorRef = ^LLVMSymbolIteratorRef;
  LLVMRelocationIteratorRef = Pointer;
  PLLVMRelocationIteratorRef = ^LLVMRelocationIteratorRef;

  LLVMBinaryType = (
    (** Archive file. *)
    LLVMBinaryTypeArchive = 0,
    (** Mach-O Universal Binary file. *)
    LLVMBinaryTypeMachOUniversalBinary = 1,
    (** COFF Import file. *)
    LLVMBinaryTypeCOFFImportFile = 2,
    (** LLVM IR. *)
    LLVMBinaryTypeIR = 3,
    (** Windows resource (.res) file. *)
    LLVMBinaryTypeWinRes = 4,
    (** COFF Object file. *)
    LLVMBinaryTypeCOFF = 5,
    (** ELF 32-bit, little endian. *)
    LLVMBinaryTypeELF32L = 6,
    (** ELF 32-bit, big endian. *)
    LLVMBinaryTypeELF32B = 7,
    (** ELF 64-bit, little endian. *)
    LLVMBinaryTypeELF64L = 8,
    (** ELF 64-bit, big endian. *)
    LLVMBinaryTypeELF64B = 9,
    (** MachO 32-bit, little endian. *)
    LLVMBinaryTypeMachO32L = 10,
    (** MachO 32-bit, big endian. *)
    LLVMBinaryTypeMachO32B = 11,
    (** MachO 64-bit, little endian. *)
    LLVMBinaryTypeMachO64L = 12,
    (** MachO 64-bit, big endian. *)
    LLVMBinaryTypeMachO64B = 13,
    (** Web Assembly. *)
    LLVMBinaryTypeWasm = 14,
    (** Offloading fatbinary. *)
    LLVMBinaryTypeOffload = 15);
  PLLVMBinaryType = ^LLVMBinaryType;
  LLVMObjectFileRef = Pointer;
  PLLVMObjectFileRef = ^LLVMObjectFileRef;

  LLVMMemoryManagerCreateContextCallback = function(CtxCtx: Pointer): Pointer; cdecl;

  LLVMMemoryManagerNotifyTerminatingCallback = procedure(CtxCtx: Pointer); cdecl;

  (**
   * The type of the emitted remark.
   *)
  LLVMRemarkType = (
    LLVMRemarkTypeUnknown = 0,
    LLVMRemarkTypePassed = 1,
    LLVMRemarkTypeMissed = 2,
    LLVMRemarkTypeAnalysis = 3,
    LLVMRemarkTypeAnalysisFPCommute = 4,
    LLVMRemarkTypeAnalysisAliasing = 5,
    LLVMRemarkTypeFailure = 6);
  PLLVMRemarkType = ^LLVMRemarkType;
  LLVMRemarkStringRef = Pointer;
  PLLVMRemarkStringRef = ^LLVMRemarkStringRef;
  LLVMRemarkDebugLocRef = Pointer;
  PLLVMRemarkDebugLocRef = ^LLVMRemarkDebugLocRef;
  LLVMRemarkArgRef = Pointer;
  PLLVMRemarkArgRef = ^LLVMRemarkArgRef;
  LLVMRemarkEntryRef = Pointer;
  PLLVMRemarkEntryRef = ^LLVMRemarkEntryRef;
  LLVMRemarkParserRef = Pointer;
  PLLVMRemarkParserRef = ^LLVMRemarkParserRef;

(**
 * Returns the type id for the given error instance, which must be a failure
 * value (i.e. non-null).
 *)
function LLVMGetErrorTypeId(Err: LLVMErrorRef): LLVMErrorTypeId; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetErrorTypeId';

(**
 * Dispose of the given error without handling it. This operation consumes the
 * error, and the given LLVMErrorRef value is not usable once this call returns.
 * Note: This method *only* needs to be called if the error is not being passed
 * to some other consuming operation, e.g. LLVMGetErrorMessage.
 *)
procedure LLVMConsumeError(Err: LLVMErrorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMConsumeError';

(**
 * Report a fatal error if Err is a failure value.
 *
 * This function can be used to wrap calls to fallible functions ONLY when it is
 * known that the Error will always be a success value.
 *)
procedure LLVMCantFail(Err: LLVMErrorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMCantFail';

(**
 * Returns the given string's error message. This operation consumes the error,
 * and the given LLVMErrorRef value is not usable once this call returns.
 * The caller is responsible for disposing of the string by calling
 * LLVMDisposeErrorMessage.
 *)
function LLVMGetErrorMessage(Err: LLVMErrorRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetErrorMessage';

(**
 * Dispose of the given error message.
 *)
procedure LLVMDisposeErrorMessage(ErrMsg: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeErrorMessage';

(**
 * Returns the type id for llvm StringError.
 *)
function LLVMGetStringErrorTypeId(): LLVMErrorTypeId; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetStringErrorTypeId';

(**
 * Create a StringError.
 *)
function LLVMCreateStringError(const ErrMsg: PUTF8Char): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateStringError';

procedure LLVMInitializeX86TargetInfo(); cdecl;
  external LLVM_DLL name _PU + 'LLVMInitializeX86TargetInfo';

procedure LLVMInitializeX86Target(); cdecl;
  external LLVM_DLL name _PU + 'LLVMInitializeX86Target';

procedure LLVMInitializeX86TargetMC(); cdecl;
  external LLVM_DLL name _PU + 'LLVMInitializeX86TargetMC';

procedure LLVMInitializeX86AsmPrinter(); cdecl;
  external LLVM_DLL name _PU + 'LLVMInitializeX86AsmPrinter';

procedure LLVMInitializeX86AsmParser(); cdecl;
  external LLVM_DLL name _PU + 'LLVMInitializeX86AsmParser';

procedure LLVMInitializeX86Disassembler(); cdecl;
  external LLVM_DLL name _PU + 'LLVMInitializeX86Disassembler';

(**
 * Obtain the data layout for a module.
 *
 * @see Module::getDataLayout()
 *)
function LLVMGetModuleDataLayout(M: LLVMModuleRef): LLVMTargetDataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetModuleDataLayout';

(**
 * Set the data layout for a module.
 *
 * @see Module::setDataLayout()
 *)
procedure LLVMSetModuleDataLayout(M: LLVMModuleRef; DL: LLVMTargetDataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetModuleDataLayout';

(** Creates target data from a target layout string.
    See the constructor llvm::DataLayout::DataLayout. *)
function LLVMCreateTargetData(const StringRep: PUTF8Char): LLVMTargetDataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateTargetData';

(** Deallocates a TargetData.
    See the destructor llvm::DataLayout::~DataLayout. *)
procedure LLVMDisposeTargetData(TD: LLVMTargetDataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeTargetData';

(** Adds target library information to a pass manager. This does not take
    ownership of the target library info.
    See the method llvm::PassManagerBase::add. *)
procedure LLVMAddTargetLibraryInfo(TLI: LLVMTargetLibraryInfoRef; PM: LLVMPassManagerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddTargetLibraryInfo';

(** Converts target data to a target layout string. The string must be disposed
    with LLVMDisposeMessage.
    See the constructor llvm::DataLayout::DataLayout. *)
function LLVMCopyStringRepOfTargetData(TD: LLVMTargetDataRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMCopyStringRepOfTargetData';

(** Returns the byte order of a target, either LLVMBigEndian or
    LLVMLittleEndian.
    See the method llvm::DataLayout::isLittleEndian. *)
function LLVMByteOrder(TD: LLVMTargetDataRef): LLVMByteOrdering; cdecl;
  external LLVM_DLL name _PU + 'LLVMByteOrder';

(** Returns the pointer size in bytes for a target.
    See the method llvm::DataLayout::getPointerSize. *)
function LLVMPointerSize(TD: LLVMTargetDataRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMPointerSize';

(** Returns the pointer size in bytes for a target for a specified
    address space.
    See the method llvm::DataLayout::getPointerSize. *)
function LLVMPointerSizeForAS(TD: LLVMTargetDataRef; AS_: Cardinal): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMPointerSizeForAS';

(** Returns the integer type that is the same size as a pointer on a target.
    See the method llvm::DataLayout::getIntPtrType. *)
function LLVMIntPtrType(TD: LLVMTargetDataRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntPtrType';

(** Returns the integer type that is the same size as a pointer on a target.
    This version allows the address space to be specified.
    See the method llvm::DataLayout::getIntPtrType. *)
function LLVMIntPtrTypeForAS(TD: LLVMTargetDataRef; AS_: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntPtrTypeForAS';

(** Returns the integer type that is the same size as a pointer on a target.
    See the method llvm::DataLayout::getIntPtrType. *)
function LLVMIntPtrTypeInContext(C: LLVMContextRef; TD: LLVMTargetDataRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntPtrTypeInContext';

(** Returns the integer type that is the same size as a pointer on a target.
    This version allows the address space to be specified.
    See the method llvm::DataLayout::getIntPtrType. *)
function LLVMIntPtrTypeForASInContext(C: LLVMContextRef; TD: LLVMTargetDataRef; AS_: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntPtrTypeForASInContext';

(** Computes the size of a type in bits for a target.
    See the method llvm::DataLayout::getTypeSizeInBits. *)
function LLVMSizeOfTypeInBits(TD: LLVMTargetDataRef; Ty: LLVMTypeRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMSizeOfTypeInBits';

(** Computes the storage size of a type in bytes for a target.
    See the method llvm::DataLayout::getTypeStoreSize. *)
function LLVMStoreSizeOfType(TD: LLVMTargetDataRef; Ty: LLVMTypeRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMStoreSizeOfType';

(** Computes the ABI size of a type in bytes for a target.
    See the method llvm::DataLayout::getTypeAllocSize. *)
function LLVMABISizeOfType(TD: LLVMTargetDataRef; Ty: LLVMTypeRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMABISizeOfType';

(** Computes the ABI alignment of a type in bytes for a target.
    See the method llvm::DataLayout::getTypeABISize. *)
function LLVMABIAlignmentOfType(TD: LLVMTargetDataRef; Ty: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMABIAlignmentOfType';

(** Computes the call frame alignment of a type in bytes for a target.
    See the method llvm::DataLayout::getTypeABISize. *)
function LLVMCallFrameAlignmentOfType(TD: LLVMTargetDataRef; Ty: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMCallFrameAlignmentOfType';

(** Computes the preferred alignment of a type in bytes for a target.
    See the method llvm::DataLayout::getTypeABISize. *)
function LLVMPreferredAlignmentOfType(TD: LLVMTargetDataRef; Ty: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMPreferredAlignmentOfType';

(** Computes the preferred alignment of a global variable in bytes for a target.
    See the method llvm::DataLayout::getPreferredAlignment. *)
function LLVMPreferredAlignmentOfGlobal(TD: LLVMTargetDataRef; GlobalVar: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMPreferredAlignmentOfGlobal';

(** Computes the structure element that contains the byte offset for a target.
    See the method llvm::StructLayout::getElementContainingOffset. *)
function LLVMElementAtOffset(TD: LLVMTargetDataRef; StructTy: LLVMTypeRef; Offset: UInt64): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMElementAtOffset';

(** Computes the byte offset of the indexed struct element for a target.
    See the method llvm::StructLayout::getElementContainingOffset. *)
function LLVMOffsetOfElement(TD: LLVMTargetDataRef; StructTy: LLVMTypeRef; Element: Cardinal): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMOffsetOfElement';

(** Returns the first llvm::Target in the registered targets list. *)
function LLVMGetFirstTarget(): LLVMTargetRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstTarget';

(** Returns the next llvm::Target given a previous one (or null if there's none) *)
function LLVMGetNextTarget(T: LLVMTargetRef): LLVMTargetRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextTarget';

(** Finds the target corresponding to the given name and stores it in \p T.
  Returns 0 on success. *)
function LLVMGetTargetFromName(const Name: PUTF8Char): LLVMTargetRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetFromName';

(** Finds the target corresponding to the given triple and stores it in \p T.
  Returns 0 on success. Optionally returns any error in ErrorMessage.
  Use LLVMDisposeMessage to dispose the message. *)
function LLVMGetTargetFromTriple(const Triple: PUTF8Char; T: PLLVMTargetRef; ErrorMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetFromTriple';

(** Returns the name of a target. See llvm::Target::getName *)
function LLVMGetTargetName(T: LLVMTargetRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetName';

(** Returns the description  of a target. See llvm::Target::getDescription *)
function LLVMGetTargetDescription(T: LLVMTargetRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetDescription';

(** Returns if the target has a JIT *)
function LLVMTargetHasJIT(T: LLVMTargetRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetHasJIT';

(** Returns if the target has a TargetMachine associated *)
function LLVMTargetHasTargetMachine(T: LLVMTargetRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetHasTargetMachine';

(** Returns if the target as an ASM backend (required for emitting output) *)
function LLVMTargetHasAsmBackend(T: LLVMTargetRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetHasAsmBackend';

(**
 * Create a new set of options for an llvm::TargetMachine.
 *
 * The returned option structure must be released with
 * LLVMDisposeTargetMachineOptions() after the call to
 * LLVMCreateTargetMachineWithOptions().
 *)
function LLVMCreateTargetMachineOptions(): LLVMTargetMachineOptionsRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateTargetMachineOptions';

(**
 * Dispose of an LLVMTargetMachineOptionsRef instance.
 *)
procedure LLVMDisposeTargetMachineOptions(Options: LLVMTargetMachineOptionsRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeTargetMachineOptions';

procedure LLVMTargetMachineOptionsSetCPU(Options: LLVMTargetMachineOptionsRef; const CPU: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetMachineOptionsSetCPU';

(**
 * Set the list of features for the target machine.
 *
 * \param Features a comma-separated list of features.
 *)
procedure LLVMTargetMachineOptionsSetFeatures(Options: LLVMTargetMachineOptionsRef; const Features: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetMachineOptionsSetFeatures';

procedure LLVMTargetMachineOptionsSetABI(Options: LLVMTargetMachineOptionsRef; const ABI: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetMachineOptionsSetABI';

procedure LLVMTargetMachineOptionsSetCodeGenOptLevel(Options: LLVMTargetMachineOptionsRef; Level: LLVMCodeGenOptLevel); cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetMachineOptionsSetCodeGenOptLevel';

procedure LLVMTargetMachineOptionsSetRelocMode(Options: LLVMTargetMachineOptionsRef; Reloc: LLVMRelocMode); cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetMachineOptionsSetRelocMode';

procedure LLVMTargetMachineOptionsSetCodeModel(Options: LLVMTargetMachineOptionsRef; CodeModel: LLVMCodeModel); cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetMachineOptionsSetCodeModel';

(**
 * Create a new llvm::TargetMachine.
 *
 * \param T the target to create a machine for.
 * \param Triple a triple describing the target machine.
 * \param Options additional configuration (see
 *                LLVMCreateTargetMachineOptions()).
 *)
function LLVMCreateTargetMachineWithOptions(T: LLVMTargetRef; const Triple: PUTF8Char; Options: LLVMTargetMachineOptionsRef): LLVMTargetMachineRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateTargetMachineWithOptions';

(** Creates a new llvm::TargetMachine. See llvm::Target::createTargetMachine *)
function LLVMCreateTargetMachine(T: LLVMTargetRef; const Triple: PUTF8Char; const CPU: PUTF8Char; const Features: PUTF8Char; Level: LLVMCodeGenOptLevel; Reloc: LLVMRelocMode; CodeModel: LLVMCodeModel): LLVMTargetMachineRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateTargetMachine';

(** Dispose the LLVMTargetMachineRef instance generated by
  LLVMCreateTargetMachine. *)
procedure LLVMDisposeTargetMachine(T: LLVMTargetMachineRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeTargetMachine';

(** Returns the Target used in a TargetMachine *)
function LLVMGetTargetMachineTarget(T: LLVMTargetMachineRef): LLVMTargetRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetMachineTarget';

(** Returns the triple used creating this target machine. See
  llvm::TargetMachine::getTriple. The result needs to be disposed with
  LLVMDisposeMessage. *)
function LLVMGetTargetMachineTriple(T: LLVMTargetMachineRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetMachineTriple';

(** Returns the cpu used creating this target machine. See
  llvm::TargetMachine::getCPU. The result needs to be disposed with
  LLVMDisposeMessage. *)
function LLVMGetTargetMachineCPU(T: LLVMTargetMachineRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetMachineCPU';

(** Returns the feature string used creating this target machine. See
  llvm::TargetMachine::getFeatureString. The result needs to be disposed with
  LLVMDisposeMessage. *)
function LLVMGetTargetMachineFeatureString(T: LLVMTargetMachineRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetMachineFeatureString';

(** Create a DataLayout based on the targetMachine. *)
function LLVMCreateTargetDataLayout(T: LLVMTargetMachineRef): LLVMTargetDataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateTargetDataLayout';

(** Set the target machine's ASM verbosity. *)
procedure LLVMSetTargetMachineAsmVerbosity(T: LLVMTargetMachineRef; VerboseAsm: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetTargetMachineAsmVerbosity';

(** Enable fast-path instruction selection. *)
procedure LLVMSetTargetMachineFastISel(T: LLVMTargetMachineRef; Enable: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetTargetMachineFastISel';

(** Enable global instruction selection. *)
procedure LLVMSetTargetMachineGlobalISel(T: LLVMTargetMachineRef; Enable: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetTargetMachineGlobalISel';

(** Set abort behaviour when global instruction selection fails to lower/select
 * an instruction. *)
procedure LLVMSetTargetMachineGlobalISelAbort(T: LLVMTargetMachineRef; Mode: LLVMGlobalISelAbortMode); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetTargetMachineGlobalISelAbort';

(** Enable the MachineOutliner pass. *)
procedure LLVMSetTargetMachineMachineOutliner(T: LLVMTargetMachineRef; Enable: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetTargetMachineMachineOutliner';

(** Emits an asm or object file for the given module to the filename. This
  wraps several c++ only classes (among them a file stream). Returns any
  error in ErrorMessage. Use LLVMDisposeMessage to dispose the message. *)
function LLVMTargetMachineEmitToFile(T: LLVMTargetMachineRef; M: LLVMModuleRef; const Filename: PUTF8Char; codegen: LLVMCodeGenFileType; ErrorMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetMachineEmitToFile';

(** Compile the LLVM IR stored in \p M and store the result in \p OutMemBuf. *)
function LLVMTargetMachineEmitToMemoryBuffer(T: LLVMTargetMachineRef; M: LLVMModuleRef; codegen: LLVMCodeGenFileType; ErrorMessage: PPUTF8Char; OutMemBuf: PLLVMMemoryBufferRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetMachineEmitToMemoryBuffer';

(** Get a triple for the host machine as a string. The result needs to be
  disposed with LLVMDisposeMessage. *)
function LLVMGetDefaultTargetTriple(): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDefaultTargetTriple';

(** Normalize a target triple. The result needs to be disposed with
  LLVMDisposeMessage. *)
function LLVMNormalizeTargetTriple(const triple: PUTF8Char): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMNormalizeTargetTriple';

(** Get the host CPU as a string. The result needs to be disposed with
  LLVMDisposeMessage. *)
function LLVMGetHostCPUName(): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetHostCPUName';

(** Get the host CPU's features as a string. The result needs to be disposed
  with LLVMDisposeMessage. *)
function LLVMGetHostCPUFeatures(): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetHostCPUFeatures';

(** Adds the target-specific analysis passes to the pass manager. *)
procedure LLVMAddAnalysisPasses(T: LLVMTargetMachineRef; PM: LLVMPassManagerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddAnalysisPasses';

(**
 * Construct and run a set of passes over a module
 *
 * This function takes a string with the passes that should be used. The format
 * of this string is the same as opt's -passes argument for the new pass
 * manager. Individual passes may be specified, separated by commas. Full
 * pipelines may also be invoked using `default<O3>` and friends. See opt for
 * full reference of the Passes format.
 *)
function LLVMRunPasses(M: LLVMModuleRef; const Passes: PUTF8Char; TM: LLVMTargetMachineRef; Options: LLVMPassBuilderOptionsRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRunPasses';

(**
 * Construct and run a set of passes over a function.
 *
 * This function behaves the same as LLVMRunPasses, but operates on a single
 * function instead of an entire module.
 *)
function LLVMRunPassesOnFunction(F: LLVMValueRef; const Passes: PUTF8Char; TM: LLVMTargetMachineRef; Options: LLVMPassBuilderOptionsRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRunPassesOnFunction';

(**
 * Create a new set of options for a PassBuilder
 *
 * Ownership of the returned instance is given to the client, and they are
 * responsible for it. The client should call LLVMDisposePassBuilderOptions
 * to free the pass builder options.
 *)
function LLVMCreatePassBuilderOptions(): LLVMPassBuilderOptionsRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreatePassBuilderOptions';

(**
 * Toggle adding the VerifierPass for the PassBuilder, ensuring all functions
 * inside the module is valid.
 *)
procedure LLVMPassBuilderOptionsSetVerifyEach(Options: LLVMPassBuilderOptionsRef; VerifyEach: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetVerifyEach';

(**
 * Toggle debug logging when running the PassBuilder
 *)
procedure LLVMPassBuilderOptionsSetDebugLogging(Options: LLVMPassBuilderOptionsRef; DebugLogging: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetDebugLogging';

(**
 * Specify a custom alias analysis pipeline for the PassBuilder to be used
 * instead of the default one. The string argument is not copied; the caller
 * is responsible for ensuring it outlives the PassBuilderOptions instance.
 *)
procedure LLVMPassBuilderOptionsSetAAPipeline(Options: LLVMPassBuilderOptionsRef; const AAPipeline: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetAAPipeline';

procedure LLVMPassBuilderOptionsSetLoopInterleaving(Options: LLVMPassBuilderOptionsRef; LoopInterleaving: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetLoopInterleaving';

procedure LLVMPassBuilderOptionsSetLoopVectorization(Options: LLVMPassBuilderOptionsRef; LoopVectorization: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetLoopVectorization';

procedure LLVMPassBuilderOptionsSetSLPVectorization(Options: LLVMPassBuilderOptionsRef; SLPVectorization: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetSLPVectorization';

procedure LLVMPassBuilderOptionsSetLoopUnrolling(Options: LLVMPassBuilderOptionsRef; LoopUnrolling: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetLoopUnrolling';

procedure LLVMPassBuilderOptionsSetForgetAllSCEVInLoopUnroll(Options: LLVMPassBuilderOptionsRef; ForgetAllSCEVInLoopUnroll: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetForgetAllSCEVInLoopUnroll';

procedure LLVMPassBuilderOptionsSetLicmMssaOptCap(Options: LLVMPassBuilderOptionsRef; LicmMssaOptCap: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetLicmMssaOptCap';

procedure LLVMPassBuilderOptionsSetLicmMssaNoAccForPromotionCap(Options: LLVMPassBuilderOptionsRef; LicmMssaNoAccForPromotionCap: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetLicmMssaNoAccForPromotionCap';

procedure LLVMPassBuilderOptionsSetCallGraphProfile(Options: LLVMPassBuilderOptionsRef; CallGraphProfile: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetCallGraphProfile';

procedure LLVMPassBuilderOptionsSetMergeFunctions(Options: LLVMPassBuilderOptionsRef; MergeFunctions: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetMergeFunctions';

procedure LLVMPassBuilderOptionsSetInlinerThreshold(Options: LLVMPassBuilderOptionsRef; Threshold: Integer); cdecl;
  external LLVM_DLL name _PU + 'LLVMPassBuilderOptionsSetInlinerThreshold';

(**
 * Dispose of a heap-allocated PassBuilderOptions instance
 *)
procedure LLVMDisposePassBuilderOptions(Options: LLVMPassBuilderOptionsRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposePassBuilderOptions';

function LLVMVerifyModule(M: LLVMModuleRef; Action: LLVMVerifierFailureAction; OutMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMVerifyModule';

function LLVMVerifyFunction(Fn: LLVMValueRef; Action: LLVMVerifierFailureAction): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMVerifyFunction';

procedure LLVMViewFunctionCFG(Fn: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMViewFunctionCFG';

procedure LLVMViewFunctionCFGOnly(Fn: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMViewFunctionCFGOnly';

(**
 * @defgroup LLVMCBitReader Bit Reader
 * @ingroup LLVMC
 *
 * @{
 *)
function LLVMParseBitcode(MemBuf: LLVMMemoryBufferRef; OutModule: PLLVMModuleRef; OutMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMParseBitcode';

function LLVMParseBitcode2(MemBuf: LLVMMemoryBufferRef; OutModule: PLLVMModuleRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMParseBitcode2';

function LLVMParseBitcodeInContext(ContextRef: LLVMContextRef; MemBuf: LLVMMemoryBufferRef; OutModule: PLLVMModuleRef; OutMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMParseBitcodeInContext';

function LLVMParseBitcodeInContext2(ContextRef: LLVMContextRef; MemBuf: LLVMMemoryBufferRef; OutModule: PLLVMModuleRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMParseBitcodeInContext2';

(** Reads a module from the specified path, returning via the OutMP parameter
    a module provider which performs lazy deserialization. Returns 0 on success.
    Optionally returns a human-readable error message via OutMessage.
    This is deprecated. Use LLVMGetBitcodeModuleInContext2. *)
function LLVMGetBitcodeModuleInContext(ContextRef: LLVMContextRef; MemBuf: LLVMMemoryBufferRef; OutM: PLLVMModuleRef; OutMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBitcodeModuleInContext';

(** Reads a module from the given memory buffer, returning via the OutMP
 * parameter a module provider which performs lazy deserialization.
 *
 * Returns 0 on success.
 *
 * Takes ownership of \p MemBuf if (and only if) the module was read
 * successfully. *)
function LLVMGetBitcodeModuleInContext2(ContextRef: LLVMContextRef; MemBuf: LLVMMemoryBufferRef; OutM: PLLVMModuleRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBitcodeModuleInContext2';

function LLVMGetBitcodeModule(MemBuf: LLVMMemoryBufferRef; OutM: PLLVMModuleRef; OutMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBitcodeModule';

function LLVMGetBitcodeModule2(MemBuf: LLVMMemoryBufferRef; OutM: PLLVMModuleRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBitcodeModule2';

(** Writes a module to the specified path. Returns 0 on success. *)
function LLVMWriteBitcodeToFile(M: LLVMModuleRef; const Path: PUTF8Char): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMWriteBitcodeToFile';

(** Writes a module to an open file descriptor. Returns 0 on success. *)
function LLVMWriteBitcodeToFD(M: LLVMModuleRef; FD: Integer; ShouldClose: Integer; Unbuffered: Integer): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMWriteBitcodeToFD';

(** Deprecated for LLVMWriteBitcodeToFD. Writes a module to an open file
    descriptor. Returns 0 on success. Closes the Handle. *)
function LLVMWriteBitcodeToFileHandle(M: LLVMModuleRef; Handle: Integer): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMWriteBitcodeToFileHandle';

(** Writes a module to a new memory buffer and returns it. *)
function LLVMWriteBitcodeToMemoryBuffer(M: LLVMModuleRef): LLVMMemoryBufferRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMWriteBitcodeToMemoryBuffer';

(**
 * Return the Comdat in the module with the specified name. It is created
 * if it didn't already exist.
 *
 * @see llvm::Module::getOrInsertComdat()
 *)
function LLVMGetOrInsertComdat(M: LLVMModuleRef; const Name: PUTF8Char): LLVMComdatRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetOrInsertComdat';

(**
 * Get the Comdat assigned to the given global object.
 *
 * @see llvm::GlobalObject::getComdat()
 *)
function LLVMGetComdat(V: LLVMValueRef): LLVMComdatRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetComdat';

(**
 * Assign the Comdat to the given global object.
 *
 * @see llvm::GlobalObject::setComdat()
 *)
procedure LLVMSetComdat(V: LLVMValueRef; C: LLVMComdatRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetComdat';

function LLVMGetComdatSelectionKind(C: LLVMComdatRef): LLVMComdatSelectionKind; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetComdatSelectionKind';

procedure LLVMSetComdatSelectionKind(C: LLVMComdatRef; Kind: LLVMComdatSelectionKind); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetComdatSelectionKind';

(**
 * Install a fatal error handler. By default, if LLVM detects a fatal error, it
 * will call exit(1). This may not be appropriate in many contexts. For example,
 * doing exit(1) will bypass many crash reporting/tracing system tools. This
 * function allows you to install a callback that will be invoked prior to the
 * call to exit(1).
 *)
procedure LLVMInstallFatalErrorHandler(Handler: LLVMFatalErrorHandler); cdecl;
  external LLVM_DLL name _PU + 'LLVMInstallFatalErrorHandler';

(**
 * Reset the fatal error handler. This resets LLVM's fatal error handling
 * behavior to the default.
 *)
procedure LLVMResetFatalErrorHandler(); cdecl;
  external LLVM_DLL name _PU + 'LLVMResetFatalErrorHandler';

(**
 * Enable LLVM's built-in stack trace code. This intercepts the OS's crash
 * signals and prints which component of LLVM you were in at the time if the
 * crash.
 *)
procedure LLVMEnablePrettyStackTrace(); cdecl;
  external LLVM_DLL name _PU + 'LLVMEnablePrettyStackTrace';

(** Deallocate and destroy all ManagedStatic variables.
    @see llvm::llvm_shutdown
    @see ManagedStatic *)
procedure LLVMShutdown(); cdecl;
  external LLVM_DLL name _PU + 'LLVMShutdown';

(**
 * Return the major, minor, and patch version of LLVM
 *
 * The version components are returned via the function's three output
 * parameters or skipped if a NULL pointer was supplied.
 *)
procedure LLVMGetVersion(Major: PCardinal; Minor: PCardinal; Patch: PCardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetVersion';

function LLVMCreateMessage(const Message_: PUTF8Char): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateMessage';

procedure LLVMDisposeMessage(Message_: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeMessage';

(**
 * Create a new context.
 *
 * Every call to this function should be paired with a call to
 * LLVMContextDispose() or the context will leak memory.
 *)
function LLVMContextCreate(): LLVMContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMContextCreate';

(**
 * Obtain the global context instance.
 *)
function LLVMGetGlobalContext(): LLVMContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetGlobalContext';

(**
 * Set the diagnostic handler for this context.
 *)
procedure LLVMContextSetDiagnosticHandler(C: LLVMContextRef; Handler: LLVMDiagnosticHandler; DiagnosticContext: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMContextSetDiagnosticHandler';

(**
 * Get the diagnostic handler of this context.
 *)
function LLVMContextGetDiagnosticHandler(C: LLVMContextRef): LLVMDiagnosticHandler; cdecl;
  external LLVM_DLL name _PU + 'LLVMContextGetDiagnosticHandler';

(**
 * Get the diagnostic context of this context.
 *)
function LLVMContextGetDiagnosticContext(C: LLVMContextRef): Pointer; cdecl;
  external LLVM_DLL name _PU + 'LLVMContextGetDiagnosticContext';

(**
 * Set the yield callback function for this context.
 *
 * @see LLVMContext::setYieldCallback()
 *)
procedure LLVMContextSetYieldCallback(C: LLVMContextRef; Callback: LLVMYieldCallback; OpaqueHandle: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMContextSetYieldCallback';

(**
 * Retrieve whether the given context is set to discard all value names.
 *
 * @see LLVMContext::shouldDiscardValueNames()
 *)
function LLVMContextShouldDiscardValueNames(C: LLVMContextRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMContextShouldDiscardValueNames';

(**
 * Set whether the given context discards all value names.
 *
 * If true, only the names of GlobalValue objects will be available in the IR.
 * This can be used to save memory and runtime, especially in release mode.
 *
 * @see LLVMContext::setDiscardValueNames()
 *)
procedure LLVMContextSetDiscardValueNames(C: LLVMContextRef; Discard: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMContextSetDiscardValueNames';

(**
 * Destroy a context instance.
 *
 * This should be called for every call to LLVMContextCreate() or memory
 * will be leaked.
 *)
procedure LLVMContextDispose(C: LLVMContextRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMContextDispose';

(**
 * Return a string representation of the DiagnosticInfo. Use
 * LLVMDisposeMessage to free the string.
 *
 * @see DiagnosticInfo::print()
 *)
function LLVMGetDiagInfoDescription(DI: LLVMDiagnosticInfoRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDiagInfoDescription';

(**
 * Return an enum LLVMDiagnosticSeverity.
 *
 * @see DiagnosticInfo::getSeverity()
 *)
function LLVMGetDiagInfoSeverity(DI: LLVMDiagnosticInfoRef): LLVMDiagnosticSeverity; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDiagInfoSeverity';

function LLVMGetMDKindIDInContext(C: LLVMContextRef; const Name: PUTF8Char; SLen: Cardinal): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetMDKindIDInContext';

function LLVMGetMDKindID(const Name: PUTF8Char; SLen: Cardinal): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetMDKindID';

(**
 * Maps a synchronization scope name to a ID unique within this context.
 *)
function LLVMGetSyncScopeID(C: LLVMContextRef; const Name: PUTF8Char; SLen: NativeUInt): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSyncScopeID';

(**
 * Return an unique id given the name of a enum attribute,
 * or 0 if no attribute by that name exists.
 *
 * See http://llvm.org/docs/LangRef.html#parameter-attributes
 * and http://llvm.org/docs/LangRef.html#function-attributes
 * for the list of available attributes.
 *
 * NB: Attribute names and/or id are subject to change without
 * going through the C API deprecation cycle.
 *)
function LLVMGetEnumAttributeKindForName(const Name: PUTF8Char; SLen: NativeUInt): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetEnumAttributeKindForName';

function LLVMGetLastEnumAttributeKind(): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastEnumAttributeKind';

(**
 * Create an enum attribute.
 *)
function LLVMCreateEnumAttribute(C: LLVMContextRef; KindID: Cardinal; Val: UInt64): LLVMAttributeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateEnumAttribute';

(**
 * Get the unique id corresponding to the enum attribute
 * passed as argument.
 *)
function LLVMGetEnumAttributeKind(A: LLVMAttributeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetEnumAttributeKind';

(**
 * Get the enum attribute's value. 0 is returned if none exists.
 *)
function LLVMGetEnumAttributeValue(A: LLVMAttributeRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetEnumAttributeValue';

(**
 * Create a type attribute
 *)
function LLVMCreateTypeAttribute(C: LLVMContextRef; KindID: Cardinal; type_ref: LLVMTypeRef): LLVMAttributeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateTypeAttribute';

(**
 * Get the type attribute's value.
 *)
function LLVMGetTypeAttributeValue(A: LLVMAttributeRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTypeAttributeValue';

(**
 * Create a ConstantRange attribute.
 *
 * LowerWords and UpperWords need to be NumBits divided by 64 rounded up
 * elements long.
 *)
function LLVMCreateConstantRangeAttribute(C: LLVMContextRef; KindID: Cardinal; NumBits: Cardinal; LowerWords: PUInt64; UpperWords: PUInt64): LLVMAttributeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateConstantRangeAttribute';

(**
 * Create a string attribute.
 *)
function LLVMCreateStringAttribute(C: LLVMContextRef; const K: PUTF8Char; KLength: Cardinal; const V: PUTF8Char; VLength: Cardinal): LLVMAttributeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateStringAttribute';

(**
 * Get the string attribute's kind.
 *)
function LLVMGetStringAttributeKind(A: LLVMAttributeRef; Length: PCardinal): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetStringAttributeKind';

(**
 * Get the string attribute's value.
 *)
function LLVMGetStringAttributeValue(A: LLVMAttributeRef; Length: PCardinal): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetStringAttributeValue';

(**
 * Check for the different types of attributes.
 *)
function LLVMIsEnumAttribute(A: LLVMAttributeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsEnumAttribute';

function LLVMIsStringAttribute(A: LLVMAttributeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsStringAttribute';

function LLVMIsTypeAttribute(A: LLVMAttributeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsTypeAttribute';

(**
 * Obtain a Type from a context by its registered name.
 *)
function LLVMGetTypeByName2(C: LLVMContextRef; const Name: PUTF8Char): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTypeByName2';

(**
 * Create a new, empty module in the global context.
 *
 * This is equivalent to calling LLVMModuleCreateWithNameInContext with
 * LLVMGetGlobalContext() as the context parameter.
 *
 * Every invocation should be paired with LLVMDisposeModule() or memory
 * will be leaked.
 *)
function LLVMModuleCreateWithName(const ModuleID: PUTF8Char): LLVMModuleRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMModuleCreateWithName';

(**
 * Create a new, empty module in a specific context.
 *
 * Every invocation should be paired with LLVMDisposeModule() or memory
 * will be leaked.
 *)
function LLVMModuleCreateWithNameInContext(const ModuleID: PUTF8Char; C: LLVMContextRef): LLVMModuleRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMModuleCreateWithNameInContext';

(**
 * Return an exact copy of the specified module.
 *)
function LLVMCloneModule(M: LLVMModuleRef): LLVMModuleRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCloneModule';

(**
 * Destroy a module instance.
 *
 * This must be called for every created module or memory will be
 * leaked.
 *)
procedure LLVMDisposeModule(M: LLVMModuleRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeModule';

(**
 * Soon to be deprecated.
 * See https://llvm.org/docs/RemoveDIsDebugInfo.html#c-api-changes
 *
 * Returns true if the module is in the new debug info mode which uses
 * non-instruction debug records instead of debug intrinsics for variable
 * location tracking.
 *)
function LLVMIsNewDbgInfoFormat(M: LLVMModuleRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsNewDbgInfoFormat';

(**
 * Soon to be deprecated.
 * See https://llvm.org/docs/RemoveDIsDebugInfo.html#c-api-changes
 *
 * Convert module into desired debug info format.
 *)
procedure LLVMSetIsNewDbgInfoFormat(M: LLVMModuleRef; UseNewFormat: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetIsNewDbgInfoFormat';

(**
 * Obtain the identifier of a module.
 *
 * @param M Module to obtain identifier of
 * @param Len Out parameter which holds the length of the returned string.
 * @return The identifier of M.
 * @see Module::getModuleIdentifier()
 *)
function LLVMGetModuleIdentifier(M: LLVMModuleRef; Len: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetModuleIdentifier';

(**
 * Set the identifier of a module to a string Ident with length Len.
 *
 * @param M The module to set identifier
 * @param Ident The string to set M's identifier to
 * @param Len Length of Ident
 * @see Module::setModuleIdentifier()
 *)
procedure LLVMSetModuleIdentifier(M: LLVMModuleRef; const Ident: PUTF8Char; Len: NativeUInt); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetModuleIdentifier';

(**
 * Obtain the module's original source file name.
 *
 * @param M Module to obtain the name of
 * @param Len Out parameter which holds the length of the returned string
 * @return The original source file name of M
 * @see Module::getSourceFileName()
 *)
function LLVMGetSourceFileName(M: LLVMModuleRef; Len: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSourceFileName';

(**
 * Set the original source file name of a module to a string Name with length
 * Len.
 *
 * @param M The module to set the source file name of
 * @param Name The string to set M's source file name to
 * @param Len Length of Name
 * @see Module::setSourceFileName()
 *)
procedure LLVMSetSourceFileName(M: LLVMModuleRef; const Name: PUTF8Char; Len: NativeUInt); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetSourceFileName';

(**
 * Obtain the data layout for a module.
 *
 * @see Module::getDataLayoutStr()
 *
 * LLVMGetDataLayout is DEPRECATED, as the name is not only incorrect,
 * but match the name of another method on the module. Prefer the use
 * of LLVMGetDataLayoutStr, which is not ambiguous.
 *)
function LLVMGetDataLayoutStr(M: LLVMModuleRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDataLayoutStr';

function LLVMGetDataLayout(M: LLVMModuleRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDataLayout';

(**
 * Set the data layout for a module.
 *
 * @see Module::setDataLayout()
 *)
procedure LLVMSetDataLayout(M: LLVMModuleRef; const DataLayoutStr: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetDataLayout';

(**
 * Obtain the target triple for a module.
 *
 * @see Module::getTargetTriple()
 *)
function LLVMGetTarget(M: LLVMModuleRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTarget';

(**
 * Set the target triple for a module.
 *
 * @see Module::setTargetTriple()
 *)
procedure LLVMSetTarget(M: LLVMModuleRef; const Triple: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetTarget';

(**
 * Returns the module flags as an array of flag-key-value triples.  The caller
 * is responsible for freeing this array by calling
 * \c LLVMDisposeModuleFlagsMetadata.
 *
 * @see Module::getModuleFlagsMetadata()
 *)
function LLVMCopyModuleFlagsMetadata(M: LLVMModuleRef; Len: PNativeUInt): PLLVMModuleFlagEntry; cdecl;
  external LLVM_DLL name _PU + 'LLVMCopyModuleFlagsMetadata';

(**
 * Destroys module flags metadata entries.
 *)
procedure LLVMDisposeModuleFlagsMetadata(Entries: PLLVMModuleFlagEntry); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeModuleFlagsMetadata';

(**
 * Returns the flag behavior for a module flag entry at a specific index.
 *
 * @see Module::ModuleFlagEntry::Behavior
 *)
function LLVMModuleFlagEntriesGetFlagBehavior(Entries: PLLVMModuleFlagEntry; Index: Cardinal): LLVMModuleFlagBehavior; cdecl;
  external LLVM_DLL name _PU + 'LLVMModuleFlagEntriesGetFlagBehavior';

(**
 * Returns the key for a module flag entry at a specific index.
 *
 * @see Module::ModuleFlagEntry::Key
 *)
function LLVMModuleFlagEntriesGetKey(Entries: PLLVMModuleFlagEntry; Index: Cardinal; Len: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMModuleFlagEntriesGetKey';

(**
 * Returns the metadata for a module flag entry at a specific index.
 *
 * @see Module::ModuleFlagEntry::Val
 *)
function LLVMModuleFlagEntriesGetMetadata(Entries: PLLVMModuleFlagEntry; Index: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMModuleFlagEntriesGetMetadata';

(**
 * Add a module-level flag to the module-level flags metadata if it doesn't
 * already exist.
 *
 * @see Module::getModuleFlag()
 *)
function LLVMGetModuleFlag(M: LLVMModuleRef; const Key: PUTF8Char; KeyLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetModuleFlag';

(**
 * Add a module-level flag to the module-level flags metadata if it doesn't
 * already exist.
 *
 * @see Module::addModuleFlag()
 *)
procedure LLVMAddModuleFlag(M: LLVMModuleRef; Behavior: LLVMModuleFlagBehavior; const Key: PUTF8Char; KeyLen: NativeUInt; Val: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddModuleFlag';

(**
 * Dump a representation of a module to stderr.
 *
 * @see Module::dump()
 *)
procedure LLVMDumpModule(M: LLVMModuleRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDumpModule';

(**
 * Print a representation of a module to a file. The ErrorMessage needs to be
 * disposed with LLVMDisposeMessage. Returns 0 on success, 1 otherwise.
 *
 * @see Module::print()
 *)
function LLVMPrintModuleToFile(M: LLVMModuleRef; const Filename: PUTF8Char; ErrorMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMPrintModuleToFile';

(**
 * Return a string representation of the module. Use
 * LLVMDisposeMessage to free the string.
 *
 * @see Module::print()
 *)
function LLVMPrintModuleToString(M: LLVMModuleRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMPrintModuleToString';

(**
 * Get inline assembly for a module.
 *
 * @see Module::getModuleInlineAsm()
 *)
function LLVMGetModuleInlineAsm(M: LLVMModuleRef; Len: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetModuleInlineAsm';

(**
 * Set inline assembly for a module.
 *
 * @see Module::setModuleInlineAsm()
 *)
procedure LLVMSetModuleInlineAsm2(M: LLVMModuleRef; const Asm_: PUTF8Char; Len: NativeUInt); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetModuleInlineAsm2';

(**
 * Append inline assembly to a module.
 *
 * @see Module::appendModuleInlineAsm()
 *)
procedure LLVMAppendModuleInlineAsm(M: LLVMModuleRef; const Asm_: PUTF8Char; Len: NativeUInt); cdecl;
  external LLVM_DLL name _PU + 'LLVMAppendModuleInlineAsm';

(**
 * Create the specified uniqued inline asm string.
 *
 * @see InlineAsm::get()
 *)
function LLVMGetInlineAsm(Ty: LLVMTypeRef; const AsmString: PUTF8Char; AsmStringSize: NativeUInt; const Constraints: PUTF8Char; ConstraintsSize: NativeUInt; HasSideEffects: LLVMBool; IsAlignStack: LLVMBool; Dialect: LLVMInlineAsmDialect; CanThrow: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInlineAsm';

(**
 * Get the template string used for an inline assembly snippet
 *
 *)
function LLVMGetInlineAsmAsmString(InlineAsmVal: LLVMValueRef; Len: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInlineAsmAsmString';

(**
 * Get the raw constraint string for an inline assembly snippet
 *
 *)
function LLVMGetInlineAsmConstraintString(InlineAsmVal: LLVMValueRef; Len: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInlineAsmConstraintString';

(**
 * Get the dialect used by the inline asm snippet
 *
 *)
function LLVMGetInlineAsmDialect(InlineAsmVal: LLVMValueRef): LLVMInlineAsmDialect; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInlineAsmDialect';

(**
 * Get the function type of the inline assembly snippet. The same type that
 * was passed into LLVMGetInlineAsm originally
 *
 * @see LLVMGetInlineAsm
 *
 *)
function LLVMGetInlineAsmFunctionType(InlineAsmVal: LLVMValueRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInlineAsmFunctionType';

(**
 * Get if the inline asm snippet has side effects
 *
 *)
function LLVMGetInlineAsmHasSideEffects(InlineAsmVal: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInlineAsmHasSideEffects';

(**
 * Get if the inline asm snippet needs an aligned stack
 *
 *)
function LLVMGetInlineAsmNeedsAlignedStack(InlineAsmVal: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInlineAsmNeedsAlignedStack';

(**
 * Get if the inline asm snippet may unwind the stack
 *
 *)
function LLVMGetInlineAsmCanUnwind(InlineAsmVal: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInlineAsmCanUnwind';

(**
 * Obtain the context to which this module is associated.
 *
 * @see Module::getContext()
 *)
function LLVMGetModuleContext(M: LLVMModuleRef): LLVMContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetModuleContext';

(** Deprecated: Use LLVMGetTypeByName2 instead. *)
function LLVMGetTypeByName(M: LLVMModuleRef; const Name: PUTF8Char): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTypeByName';

(**
 * Obtain an iterator to the first NamedMDNode in a Module.
 *
 * @see llvm::Module::named_metadata_begin()
 *)
function LLVMGetFirstNamedMetadata(M: LLVMModuleRef): LLVMNamedMDNodeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstNamedMetadata';

(**
 * Obtain an iterator to the last NamedMDNode in a Module.
 *
 * @see llvm::Module::named_metadata_end()
 *)
function LLVMGetLastNamedMetadata(M: LLVMModuleRef): LLVMNamedMDNodeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastNamedMetadata';

(**
 * Advance a NamedMDNode iterator to the next NamedMDNode.
 *
 * Returns NULL if the iterator was already at the end and there are no more
 * named metadata nodes.
 *)
function LLVMGetNextNamedMetadata(NamedMDNode: LLVMNamedMDNodeRef): LLVMNamedMDNodeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextNamedMetadata';

(**
 * Decrement a NamedMDNode iterator to the previous NamedMDNode.
 *
 * Returns NULL if the iterator was already at the beginning and there are
 * no previous named metadata nodes.
 *)
function LLVMGetPreviousNamedMetadata(NamedMDNode: LLVMNamedMDNodeRef): LLVMNamedMDNodeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousNamedMetadata';

(**
 * Retrieve a NamedMDNode with the given name, returning NULL if no such
 * node exists.
 *
 * @see llvm::Module::getNamedMetadata()
 *)
function LLVMGetNamedMetadata(M: LLVMModuleRef; const Name: PUTF8Char; NameLen: NativeUInt): LLVMNamedMDNodeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedMetadata';

(**
 * Retrieve a NamedMDNode with the given name, creating a new node if no such
 * node exists.
 *
 * @see llvm::Module::getOrInsertNamedMetadata()
 *)
function LLVMGetOrInsertNamedMetadata(M: LLVMModuleRef; const Name: PUTF8Char; NameLen: NativeUInt): LLVMNamedMDNodeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetOrInsertNamedMetadata';

(**
 * Retrieve the name of a NamedMDNode.
 *
 * @see llvm::NamedMDNode::getName()
 *)
function LLVMGetNamedMetadataName(NamedMD: LLVMNamedMDNodeRef; NameLen: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedMetadataName';

(**
 * Obtain the number of operands for named metadata in a module.
 *
 * @see llvm::Module::getNamedMetadata()
 *)
function LLVMGetNamedMetadataNumOperands(M: LLVMModuleRef; const Name: PUTF8Char): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedMetadataNumOperands';

(**
 * Obtain the named metadata operands for a module.
 *
 * The passed LLVMValueRef pointer should refer to an array of
 * LLVMValueRef at least LLVMGetNamedMetadataNumOperands long. This
 * array will be populated with the LLVMValueRef instances. Each
 * instance corresponds to a llvm::MDNode.
 *
 * @see llvm::Module::getNamedMetadata()
 * @see llvm::MDNode::getOperand()
 *)
procedure LLVMGetNamedMetadataOperands(M: LLVMModuleRef; const Name: PUTF8Char; Dest: PLLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedMetadataOperands';

(**
 * Add an operand to named metadata.
 *
 * @see llvm::Module::getNamedMetadata()
 * @see llvm::MDNode::addOperand()
 *)
procedure LLVMAddNamedMetadataOperand(M: LLVMModuleRef; const Name: PUTF8Char; Val: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddNamedMetadataOperand';

(**
 * Return the directory of the debug location for this value, which must be
 * an llvm::Instruction, llvm::GlobalVariable, or llvm::Function.
 *
 * @see llvm::Instruction::getDebugLoc()
 * @see llvm::GlobalVariable::getDebugInfo()
 * @see llvm::Function::getSubprogram()
 *)
function LLVMGetDebugLocDirectory(Val: LLVMValueRef; Length: PCardinal): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDebugLocDirectory';

(**
 * Return the filename of the debug location for this value, which must be
 * an llvm::Instruction, llvm::GlobalVariable, or llvm::Function.
 *
 * @see llvm::Instruction::getDebugLoc()
 * @see llvm::GlobalVariable::getDebugInfo()
 * @see llvm::Function::getSubprogram()
 *)
function LLVMGetDebugLocFilename(Val: LLVMValueRef; Length: PCardinal): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDebugLocFilename';

(**
 * Return the line number of the debug location for this value, which must be
 * an llvm::Instruction, llvm::GlobalVariable, or llvm::Function.
 *
 * @see llvm::Instruction::getDebugLoc()
 * @see llvm::GlobalVariable::getDebugInfo()
 * @see llvm::Function::getSubprogram()
 *)
function LLVMGetDebugLocLine(Val: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDebugLocLine';

(**
 * Return the column number of the debug location for this value, which must be
 * an llvm::Instruction.
 *
 * @see llvm::Instruction::getDebugLoc()
 *)
function LLVMGetDebugLocColumn(Val: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDebugLocColumn';

(**
 * Add a function to a module under a specified name.
 *
 * @see llvm::Function::Create()
 *)
function LLVMAddFunction(M: LLVMModuleRef; const Name: PUTF8Char; FunctionTy: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAddFunction';

(**
 * Obtain a Function value from a Module by its name.
 *
 * The returned value corresponds to a llvm::Function value.
 *
 * @see llvm::Module::getFunction()
 *)
function LLVMGetNamedFunction(M: LLVMModuleRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedFunction';

(**
 * Obtain a Function value from a Module by its name.
 *
 * The returned value corresponds to a llvm::Function value.
 *
 * @see llvm::Module::getFunction()
 *)
function LLVMGetNamedFunctionWithLength(M: LLVMModuleRef; const Name: PUTF8Char; Length: NativeUInt): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedFunctionWithLength';

(**
 * Obtain an iterator to the first Function in a Module.
 *
 * @see llvm::Module::begin()
 *)
function LLVMGetFirstFunction(M: LLVMModuleRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstFunction';

(**
 * Obtain an iterator to the last Function in a Module.
 *
 * @see llvm::Module::end()
 *)
function LLVMGetLastFunction(M: LLVMModuleRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastFunction';

(**
 * Advance a Function iterator to the next Function.
 *
 * Returns NULL if the iterator was already at the end and there are no more
 * functions.
 *)
function LLVMGetNextFunction(Fn: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextFunction';

(**
 * Decrement a Function iterator to the previous Function.
 *
 * Returns NULL if the iterator was already at the beginning and there are
 * no previous functions.
 *)
function LLVMGetPreviousFunction(Fn: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousFunction';

(** Deprecated: Use LLVMSetModuleInlineAsm2 instead. *)
procedure LLVMSetModuleInlineAsm(M: LLVMModuleRef; const Asm_: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetModuleInlineAsm';

(**
 * Obtain the enumerated type of a Type instance.
 *
 * @see llvm::Type:getTypeID()
 *)
function LLVMGetTypeKind(Ty: LLVMTypeRef): LLVMTypeKind; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTypeKind';

(**
 * Whether the type has a known size.
 *
 * Things that don't have a size are abstract types, labels, and void.a
 *
 * @see llvm::Type::isSized()
 *)
function LLVMTypeIsSized(Ty: LLVMTypeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMTypeIsSized';

(**
 * Obtain the context to which this type instance is associated.
 *
 * @see llvm::Type::getContext()
 *)
function LLVMGetTypeContext(Ty: LLVMTypeRef): LLVMContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTypeContext';

(**
 * Dump a representation of a type to stderr.
 *
 * @see llvm::Type::dump()
 *)
procedure LLVMDumpType(Val: LLVMTypeRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDumpType';

(**
 * Return a string representation of the type. Use
 * LLVMDisposeMessage to free the string.
 *
 * @see llvm::Type::print()
 *)
function LLVMPrintTypeToString(Val: LLVMTypeRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMPrintTypeToString';

(**
 * Obtain an integer type from a context with specified bit width.
 *)
function LLVMInt1TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt1TypeInContext';

function LLVMInt8TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt8TypeInContext';

function LLVMInt16TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt16TypeInContext';

function LLVMInt32TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt32TypeInContext';

function LLVMInt64TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt64TypeInContext';

function LLVMInt128TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt128TypeInContext';

function LLVMIntTypeInContext(C: LLVMContextRef; NumBits: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntTypeInContext';

(**
 * Obtain an integer type from the global context with a specified bit
 * width.
 *)
function LLVMInt1Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt1Type';

function LLVMInt8Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt8Type';

function LLVMInt16Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt16Type';

function LLVMInt32Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt32Type';

function LLVMInt64Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt64Type';

function LLVMInt128Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInt128Type';

function LLVMIntType(NumBits: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntType';

function LLVMGetIntTypeWidth(IntegerTy: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetIntTypeWidth';

(**
 * Obtain a 16-bit floating point type from a context.
 *)
function LLVMHalfTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMHalfTypeInContext';

(**
 * Obtain a 16-bit brain floating point type from a context.
 *)
function LLVMBFloatTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBFloatTypeInContext';

(**
 * Obtain a 32-bit floating point type from a context.
 *)
function LLVMFloatTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMFloatTypeInContext';

(**
 * Obtain a 64-bit floating point type from a context.
 *)
function LLVMDoubleTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDoubleTypeInContext';

(**
 * Obtain a 80-bit floating point type (X87) from a context.
 *)
function LLVMX86FP80TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMX86FP80TypeInContext';

(**
 * Obtain a 128-bit floating point type (112-bit mantissa) from a
 * context.
 *)
function LLVMFP128TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMFP128TypeInContext';

(**
 * Obtain a 128-bit floating point type (two 64-bits) from a context.
 *)
function LLVMPPCFP128TypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMPPCFP128TypeInContext';

(**
 * Obtain a floating point type from the global context.
 *
 * These map to the functions in this group of the same name.
 *)
function LLVMHalfType(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMHalfType';

function LLVMBFloatType(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBFloatType';

function LLVMFloatType(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMFloatType';

function LLVMDoubleType(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDoubleType';

function LLVMX86FP80Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMX86FP80Type';

function LLVMFP128Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMFP128Type';

function LLVMPPCFP128Type(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMPPCFP128Type';

(**
 * Obtain a function type consisting of a specified signature.
 *
 * The function is defined as a tuple of a return Type, a list of
 * parameter types, and whether the function is variadic.
 *)
function LLVMFunctionType(ReturnType: LLVMTypeRef; ParamTypes: PLLVMTypeRef; ParamCount: Cardinal; IsVarArg: LLVMBool): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMFunctionType';

(**
 * Returns whether a function type is variadic.
 *)
function LLVMIsFunctionVarArg(FunctionTy: LLVMTypeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsFunctionVarArg';

(**
 * Obtain the Type this function Type returns.
 *)
function LLVMGetReturnType(FunctionTy: LLVMTypeRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetReturnType';

(**
 * Obtain the number of parameters this function accepts.
 *)
function LLVMCountParamTypes(FunctionTy: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMCountParamTypes';

(**
 * Obtain the types of a function's parameters.
 *
 * The Dest parameter should point to a pre-allocated array of
 * LLVMTypeRef at least LLVMCountParamTypes() large. On return, the
 * first LLVMCountParamTypes() entries in the array will be populated
 * with LLVMTypeRef instances.
 *
 * @param FunctionTy The function type to operate on.
 * @param Dest Memory address of an array to be filled with result.
 *)
procedure LLVMGetParamTypes(FunctionTy: LLVMTypeRef; Dest: PLLVMTypeRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetParamTypes';

(**
 * Create a new structure type in a context.
 *
 * A structure is specified by a list of inner elements/types and
 * whether these can be packed together.
 *
 * @see llvm::StructType::create()
 *)
function LLVMStructTypeInContext(C: LLVMContextRef; ElementTypes: PLLVMTypeRef; ElementCount: Cardinal; Packed_: LLVMBool): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMStructTypeInContext';

(**
 * Create a new structure type in the global context.
 *
 * @see llvm::StructType::create()
 *)
function LLVMStructType(ElementTypes: PLLVMTypeRef; ElementCount: Cardinal; Packed_: LLVMBool): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMStructType';

(**
 * Create an empty structure in a context having a specified name.
 *
 * @see llvm::StructType::create()
 *)
function LLVMStructCreateNamed(C: LLVMContextRef; const Name: PUTF8Char): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMStructCreateNamed';

(**
 * Obtain the name of a structure.
 *
 * @see llvm::StructType::getName()
 *)
function LLVMGetStructName(Ty: LLVMTypeRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetStructName';

(**
 * Set the contents of a structure type.
 *
 * @see llvm::StructType::setBody()
 *)
procedure LLVMStructSetBody(StructTy: LLVMTypeRef; ElementTypes: PLLVMTypeRef; ElementCount: Cardinal; Packed_: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMStructSetBody';

(**
 * Get the number of elements defined inside the structure.
 *
 * @see llvm::StructType::getNumElements()
 *)
function LLVMCountStructElementTypes(StructTy: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMCountStructElementTypes';

(**
 * Get the elements within a structure.
 *
 * The function is passed the address of a pre-allocated array of
 * LLVMTypeRef at least LLVMCountStructElementTypes() long. After
 * invocation, this array will be populated with the structure's
 * elements. The objects in the destination array will have a lifetime
 * of the structure type itself, which is the lifetime of the context it
 * is contained in.
 *)
procedure LLVMGetStructElementTypes(StructTy: LLVMTypeRef; Dest: PLLVMTypeRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetStructElementTypes';

(**
 * Get the type of the element at a given index in the structure.
 *
 * @see llvm::StructType::getTypeAtIndex()
 *)
function LLVMStructGetTypeAtIndex(StructTy: LLVMTypeRef; i: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMStructGetTypeAtIndex';

(**
 * Determine whether a structure is packed.
 *
 * @see llvm::StructType::isPacked()
 *)
function LLVMIsPackedStruct(StructTy: LLVMTypeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsPackedStruct';

(**
 * Determine whether a structure is opaque.
 *
 * @see llvm::StructType::isOpaque()
 *)
function LLVMIsOpaqueStruct(StructTy: LLVMTypeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsOpaqueStruct';

(**
 * Determine whether a structure is literal.
 *
 * @see llvm::StructType::isLiteral()
 *)
function LLVMIsLiteralStruct(StructTy: LLVMTypeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsLiteralStruct';

(**
 * Obtain the element type of an array or vector type.
 *
 * @see llvm::SequentialType::getElementType()
 *)
function LLVMGetElementType(Ty: LLVMTypeRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetElementType';

(**
 * Returns type's subtypes
 *
 * @see llvm::Type::subtypes()
 *)
procedure LLVMGetSubtypes(Tp: LLVMTypeRef; Arr: PLLVMTypeRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSubtypes';

(**
 *  Return the number of types in the derived type.
 *
 * @see llvm::Type::getNumContainedTypes()
 *)
function LLVMGetNumContainedTypes(Tp: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumContainedTypes';

(**
 * Create a fixed size array type that refers to a specific type.
 *
 * The created type will exist in the context that its element type
 * exists in.
 *
 * @deprecated LLVMArrayType is deprecated in favor of the API accurate
 * LLVMArrayType2
 * @see llvm::ArrayType::get()
 *)
function LLVMArrayType(ElementType: LLVMTypeRef; ElementCount: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMArrayType';

(**
 * Create a fixed size array type that refers to a specific type.
 *
 * The created type will exist in the context that its element type
 * exists in.
 *
 * @see llvm::ArrayType::get()
 *)
function LLVMArrayType2(ElementType: LLVMTypeRef; ElementCount: UInt64): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMArrayType2';

(**
 * Obtain the length of an array type.
 *
 * This only works on types that represent arrays.
 *
 * @deprecated LLVMGetArrayLength is deprecated in favor of the API accurate
 * LLVMGetArrayLength2
 * @see llvm::ArrayType::getNumElements()
 *)
function LLVMGetArrayLength(ArrayTy: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetArrayLength';

(**
 * Obtain the length of an array type.
 *
 * This only works on types that represent arrays.
 *
 * @see llvm::ArrayType::getNumElements()
 *)
function LLVMGetArrayLength2(ArrayTy: LLVMTypeRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetArrayLength2';

(**
 * Create a pointer type that points to a defined type.
 *
 * The created type will exist in the context that its pointee type
 * exists in.
 *
 * @see llvm::PointerType::get()
 *)
function LLVMPointerType(ElementType: LLVMTypeRef; AddressSpace: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMPointerType';

(**
 * Determine whether a pointer is opaque.
 *
 * True if this is an instance of an opaque PointerType.
 *
 * @see llvm::Type::isOpaquePointerTy()
 *)
function LLVMPointerTypeIsOpaque(Ty: LLVMTypeRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMPointerTypeIsOpaque';

(**
 * Create an opaque pointer type in a context.
 *
 * @see llvm::PointerType::get()
 *)
function LLVMPointerTypeInContext(C: LLVMContextRef; AddressSpace: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMPointerTypeInContext';

(**
 * Obtain the address space of a pointer type.
 *
 * This only works on types that represent pointers.
 *
 * @see llvm::PointerType::getAddressSpace()
 *)
function LLVMGetPointerAddressSpace(PointerTy: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPointerAddressSpace';

(**
 * Create a vector type that contains a defined type and has a specific
 * number of elements.
 *
 * The created type will exist in the context thats its element type
 * exists in.
 *
 * @see llvm::VectorType::get()
 *)
function LLVMVectorType(ElementType: LLVMTypeRef; ElementCount: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMVectorType';

(**
 * Create a vector type that contains a defined type and has a scalable
 * number of elements.
 *
 * The created type will exist in the context thats its element type
 * exists in.
 *
 * @see llvm::ScalableVectorType::get()
 *)
function LLVMScalableVectorType(ElementType: LLVMTypeRef; ElementCount: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMScalableVectorType';

(**
 * Obtain the (possibly scalable) number of elements in a vector type.
 *
 * This only works on types that represent vectors (fixed or scalable).
 *
 * @see llvm::VectorType::getNumElements()
 *)
function LLVMGetVectorSize(VectorTy: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetVectorSize';

(**
 * Get the pointer value for the associated ConstantPtrAuth constant.
 *
 * @see llvm::ConstantPtrAuth::getPointer
 *)
function LLVMGetConstantPtrAuthPointer(PtrAuth: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetConstantPtrAuthPointer';

(**
 * Get the key value for the associated ConstantPtrAuth constant.
 *
 * @see llvm::ConstantPtrAuth::getKey
 *)
function LLVMGetConstantPtrAuthKey(PtrAuth: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetConstantPtrAuthKey';

(**
 * Get the discriminator value for the associated ConstantPtrAuth constant.
 *
 * @see llvm::ConstantPtrAuth::getDiscriminator
 *)
function LLVMGetConstantPtrAuthDiscriminator(PtrAuth: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetConstantPtrAuthDiscriminator';

(**
 * Get the address discriminator value for the associated ConstantPtrAuth
 * constant.
 *
 * @see llvm::ConstantPtrAuth::getAddrDiscriminator
 *)
function LLVMGetConstantPtrAuthAddrDiscriminator(PtrAuth: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetConstantPtrAuthAddrDiscriminator';

(**
 * Create a void type in a context.
 *)
function LLVMVoidTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMVoidTypeInContext';

(**
 * Create a label type in a context.
 *)
function LLVMLabelTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMLabelTypeInContext';

(**
 * Create a X86 AMX type in a context.
 *)
function LLVMX86AMXTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMX86AMXTypeInContext';

(**
 * Create a token type in a context.
 *)
function LLVMTokenTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMTokenTypeInContext';

(**
 * Create a metadata type in a context.
 *)
function LLVMMetadataTypeInContext(C: LLVMContextRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMetadataTypeInContext';

(**
 * These are similar to the above functions except they operate on the
 * global context.
 *)
function LLVMVoidType(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMVoidType';

function LLVMLabelType(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMLabelType';

function LLVMX86AMXType(): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMX86AMXType';

(**
 * Create a target extension type in LLVM context.
 *)
function LLVMTargetExtTypeInContext(C: LLVMContextRef; const Name: PUTF8Char; TypeParams: PLLVMTypeRef; TypeParamCount: Cardinal; IntParams: PCardinal; IntParamCount: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMTargetExtTypeInContext';

(**
 * Obtain the name for this target extension type.
 *
 * @see llvm::TargetExtType::getName()
 *)
function LLVMGetTargetExtTypeName(TargetExtTy: LLVMTypeRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetExtTypeName';

(**
 * Obtain the number of type parameters for this target extension type.
 *
 * @see llvm::TargetExtType::getNumTypeParameters()
 *)
function LLVMGetTargetExtTypeNumTypeParams(TargetExtTy: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetExtTypeNumTypeParams';

(**
 * Get the type parameter at the given index for the target extension type.
 *
 * @see llvm::TargetExtType::getTypeParameter()
 *)
function LLVMGetTargetExtTypeTypeParam(TargetExtTy: LLVMTypeRef; Idx: Cardinal): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetExtTypeTypeParam';

(**
 * Obtain the number of int parameters for this target extension type.
 *
 * @see llvm::TargetExtType::getNumIntParameters()
 *)
function LLVMGetTargetExtTypeNumIntParams(TargetExtTy: LLVMTypeRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetExtTypeNumIntParams';

(**
 * Get the int parameter at the given index for the target extension type.
 *
 * @see llvm::TargetExtType::getIntParameter()
 *)
function LLVMGetTargetExtTypeIntParam(TargetExtTy: LLVMTypeRef; Idx: Cardinal): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTargetExtTypeIntParam';

(**
 * Obtain the type of a value.
 *
 * @see llvm::Value::getType()
 *)
function LLVMTypeOf(Val: LLVMValueRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMTypeOf';

(**
 * Obtain the enumerated type of a Value instance.
 *
 * @see llvm::Value::getValueID()
 *)
function LLVMGetValueKind(Val: LLVMValueRef): LLVMValueKind; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetValueKind';

(**
 * Obtain the string name of a value.
 *
 * @see llvm::Value::getName()
 *)
function LLVMGetValueName2(Val: LLVMValueRef; Length: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetValueName2';

(**
 * Set the string name of a value.
 *
 * @see llvm::Value::setName()
 *)
procedure LLVMSetValueName2(Val: LLVMValueRef; const Name: PUTF8Char; NameLen: NativeUInt); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetValueName2';

(**
 * Dump a representation of a value to stderr.
 *
 * @see llvm::Value::dump()
 *)
procedure LLVMDumpValue(Val: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDumpValue';

(**
 * Return a string representation of the value. Use
 * LLVMDisposeMessage to free the string.
 *
 * @see llvm::Value::print()
 *)
function LLVMPrintValueToString(Val: LLVMValueRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMPrintValueToString';

(**
 * Obtain the context to which this value is associated.
 *
 * @see llvm::Value::getContext()
 *)
function LLVMGetValueContext(Val: LLVMValueRef): LLVMContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetValueContext';

(**
 * Return a string representation of the DbgRecord. Use
 * LLVMDisposeMessage to free the string.
 *
 * @see llvm::DbgRecord::print()
 *)
function LLVMPrintDbgRecordToString(Record_: LLVMDbgRecordRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMPrintDbgRecordToString';

(**
 * Replace all uses of a value with another one.
 *
 * @see llvm::Value::replaceAllUsesWith()
 *)
procedure LLVMReplaceAllUsesWith(OldVal: LLVMValueRef; NewVal: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMReplaceAllUsesWith';

(**
 * Determine whether the specified value instance is constant.
 *)
function LLVMIsConstant(Val: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsConstant';

(**
 * Determine whether a value instance is undefined.
 *)
function LLVMIsUndef(Val: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsUndef';

(**
 * Determine whether a value instance is poisonous.
 *)
function LLVMIsPoison(Val: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsPoison';

function LLVMIsAArgument(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAArgument';

function LLVMIsABasicBlock(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsABasicBlock';

function LLVMIsAInlineAsm(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAInlineAsm';

function LLVMIsAUser(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAUser';

function LLVMIsAConstant(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstant';

function LLVMIsABlockAddress(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsABlockAddress';

function LLVMIsAConstantAggregateZero(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantAggregateZero';

function LLVMIsAConstantArray(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantArray';

function LLVMIsAConstantDataSequential(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantDataSequential';

function LLVMIsAConstantDataArray(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantDataArray';

function LLVMIsAConstantDataVector(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantDataVector';

function LLVMIsAConstantExpr(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantExpr';

function LLVMIsAConstantFP(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantFP';

function LLVMIsAConstantInt(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantInt';

function LLVMIsAConstantPointerNull(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantPointerNull';

function LLVMIsAConstantStruct(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantStruct';

function LLVMIsAConstantTokenNone(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantTokenNone';

function LLVMIsAConstantVector(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantVector';

function LLVMIsAConstantPtrAuth(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAConstantPtrAuth';

function LLVMIsAGlobalValue(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAGlobalValue';

function LLVMIsAGlobalAlias(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAGlobalAlias';

function LLVMIsAGlobalObject(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAGlobalObject';

function LLVMIsAFunction(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFunction';

function LLVMIsAGlobalVariable(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAGlobalVariable';

function LLVMIsAGlobalIFunc(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAGlobalIFunc';

function LLVMIsAUndefValue(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAUndefValue';

function LLVMIsAPoisonValue(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAPoisonValue';

function LLVMIsAInstruction(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAInstruction';

function LLVMIsAUnaryOperator(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAUnaryOperator';

function LLVMIsABinaryOperator(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsABinaryOperator';

function LLVMIsACallInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACallInst';

function LLVMIsAIntrinsicInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAIntrinsicInst';

function LLVMIsADbgInfoIntrinsic(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsADbgInfoIntrinsic';

function LLVMIsADbgVariableIntrinsic(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsADbgVariableIntrinsic';

function LLVMIsADbgDeclareInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsADbgDeclareInst';

function LLVMIsADbgLabelInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsADbgLabelInst';

function LLVMIsAMemIntrinsic(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAMemIntrinsic';

function LLVMIsAMemCpyInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAMemCpyInst';

function LLVMIsAMemMoveInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAMemMoveInst';

function LLVMIsAMemSetInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAMemSetInst';

function LLVMIsACmpInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACmpInst';

function LLVMIsAFCmpInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFCmpInst';

function LLVMIsAICmpInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAICmpInst';

function LLVMIsAExtractElementInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAExtractElementInst';

function LLVMIsAGetElementPtrInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAGetElementPtrInst';

function LLVMIsAInsertElementInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAInsertElementInst';

function LLVMIsAInsertValueInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAInsertValueInst';

function LLVMIsALandingPadInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsALandingPadInst';

function LLVMIsAPHINode(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAPHINode';

function LLVMIsASelectInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsASelectInst';

function LLVMIsAShuffleVectorInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAShuffleVectorInst';

function LLVMIsAStoreInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAStoreInst';

function LLVMIsABranchInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsABranchInst';

function LLVMIsAIndirectBrInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAIndirectBrInst';

function LLVMIsAInvokeInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAInvokeInst';

function LLVMIsAReturnInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAReturnInst';

function LLVMIsASwitchInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsASwitchInst';

function LLVMIsAUnreachableInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAUnreachableInst';

function LLVMIsAResumeInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAResumeInst';

function LLVMIsACleanupReturnInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACleanupReturnInst';

function LLVMIsACatchReturnInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACatchReturnInst';

function LLVMIsACatchSwitchInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACatchSwitchInst';

function LLVMIsACallBrInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACallBrInst';

function LLVMIsAFuncletPadInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFuncletPadInst';

function LLVMIsACatchPadInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACatchPadInst';

function LLVMIsACleanupPadInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACleanupPadInst';

function LLVMIsAUnaryInstruction(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAUnaryInstruction';

function LLVMIsAAllocaInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAAllocaInst';

function LLVMIsACastInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsACastInst';

function LLVMIsAAddrSpaceCastInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAAddrSpaceCastInst';

function LLVMIsABitCastInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsABitCastInst';

function LLVMIsAFPExtInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFPExtInst';

function LLVMIsAFPToSIInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFPToSIInst';

function LLVMIsAFPToUIInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFPToUIInst';

function LLVMIsAFPTruncInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFPTruncInst';

function LLVMIsAIntToPtrInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAIntToPtrInst';

function LLVMIsAPtrToIntInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAPtrToIntInst';

function LLVMIsASExtInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsASExtInst';

function LLVMIsASIToFPInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsASIToFPInst';

function LLVMIsATruncInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsATruncInst';

function LLVMIsAUIToFPInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAUIToFPInst';

function LLVMIsAZExtInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAZExtInst';

function LLVMIsAExtractValueInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAExtractValueInst';

function LLVMIsALoadInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsALoadInst';

function LLVMIsAVAArgInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAVAArgInst';

function LLVMIsAFreezeInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFreezeInst';

function LLVMIsAAtomicCmpXchgInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAAtomicCmpXchgInst';

function LLVMIsAAtomicRMWInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAAtomicRMWInst';

function LLVMIsAFenceInst(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAFenceInst';

function LLVMIsAMDNode(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAMDNode';

function LLVMIsAValueAsMetadata(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAValueAsMetadata';

function LLVMIsAMDString(Val: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAMDString';

(** Deprecated: Use LLVMGetValueName2 instead. *)
function LLVMGetValueName(Val: LLVMValueRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetValueName';

(** Deprecated: Use LLVMSetValueName2 instead. *)
procedure LLVMSetValueName(Val: LLVMValueRef; const Name: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetValueName';

(**
 * Obtain the first use of a value.
 *
 * Uses are obtained in an iterator fashion. First, call this function
 * to obtain a reference to the first use. Then, call LLVMGetNextUse()
 * on that instance and all subsequently obtained instances until
 * LLVMGetNextUse() returns NULL.
 *
 * @see llvm::Value::use_begin()
 *)
function LLVMGetFirstUse(Val: LLVMValueRef): LLVMUseRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstUse';

(**
 * Obtain the next use of a value.
 *
 * This effectively advances the iterator. It returns NULL if you are on
 * the final use and no more are available.
 *)
function LLVMGetNextUse(U: LLVMUseRef): LLVMUseRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextUse';

(**
 * Obtain the user value for a user.
 *
 * The returned value corresponds to a llvm::User type.
 *
 * @see llvm::Use::getUser()
 *)
function LLVMGetUser(U: LLVMUseRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetUser';

(**
 * Obtain the value this use corresponds to.
 *
 * @see llvm::Use::get().
 *)
function LLVMGetUsedValue(U: LLVMUseRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetUsedValue';

(**
 * Obtain an operand at a specific index in a llvm::User value.
 *
 * @see llvm::User::getOperand()
 *)
function LLVMGetOperand(Val: LLVMValueRef; Index: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetOperand';

(**
 * Obtain the use of an operand at a specific index in a llvm::User value.
 *
 * @see llvm::User::getOperandUse()
 *)
function LLVMGetOperandUse(Val: LLVMValueRef; Index: Cardinal): LLVMUseRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetOperandUse';

(**
 * Set an operand at a specific index in a llvm::User value.
 *
 * @see llvm::User::setOperand()
 *)
procedure LLVMSetOperand(User: LLVMValueRef; Index: Cardinal; Val: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetOperand';

(**
 * Obtain the number of operands in a llvm::User value.
 *
 * @see llvm::User::getNumOperands()
 *)
function LLVMGetNumOperands(Val: LLVMValueRef): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumOperands';

(**
 * Obtain a constant value referring to the null instance of a type.
 *
 * @see llvm::Constant::getNullValue()
 *)
function LLVMConstNull(Ty: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNull';

(**
 * Obtain a constant value referring to the instance of a type
 * consisting of all ones.
 *
 * This is only valid for integer types.
 *
 * @see llvm::Constant::getAllOnesValue()
 *)
function LLVMConstAllOnes(Ty: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstAllOnes';

(**
 * Obtain a constant value referring to an undefined value of a type.
 *
 * @see llvm::UndefValue::get()
 *)
function LLVMGetUndef(Ty: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetUndef';

(**
 * Obtain a constant value referring to a poison value of a type.
 *
 * @see llvm::PoisonValue::get()
 *)
function LLVMGetPoison(Ty: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPoison';

(**
 * Determine whether a value instance is null.
 *
 * @see llvm::Constant::isNullValue()
 *)
function LLVMIsNull(Val: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsNull';

(**
 * Obtain a constant that is a constant pointer pointing to NULL for a
 * specified type.
 *)
function LLVMConstPointerNull(Ty: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstPointerNull';

(**
 * Obtain a constant value for an integer type.
 *
 * The returned value corresponds to a llvm::ConstantInt.
 *
 * @see llvm::ConstantInt::get()
 *
 * @param IntTy Integer type to obtain value of.
 * @param N The value the returned instance should refer to.
 * @param SignExtend Whether to sign extend the produced value.
 *)
function LLVMConstInt(IntTy: LLVMTypeRef; N: UInt64; SignExtend: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstInt';

(**
 * Obtain a constant value for an integer of arbitrary precision.
 *
 * @see llvm::ConstantInt::get()
 *)
function LLVMConstIntOfArbitraryPrecision(IntTy: LLVMTypeRef; NumWords: Cardinal; Words: PUInt64): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstIntOfArbitraryPrecision';

(**
 * Obtain a constant value for an integer parsed from a string.
 *
 * A similar API, LLVMConstIntOfStringAndSize is also available. If the
 * string's length is available, it is preferred to call that function
 * instead.
 *
 * @see llvm::ConstantInt::get()
 *)
function LLVMConstIntOfString(IntTy: LLVMTypeRef; const Text: PUTF8Char; Radix: UInt8): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstIntOfString';

(**
 * Obtain a constant value for an integer parsed from a string with
 * specified length.
 *
 * @see llvm::ConstantInt::get()
 *)
function LLVMConstIntOfStringAndSize(IntTy: LLVMTypeRef; const Text: PUTF8Char; SLen: Cardinal; Radix: UInt8): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstIntOfStringAndSize';

(**
 * Obtain a constant value referring to a double floating point value.
 *)
function LLVMConstReal(RealTy: LLVMTypeRef; N: Double): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstReal';

(**
 * Obtain a constant for a floating point value parsed from a string.
 *
 * A similar API, LLVMConstRealOfStringAndSize is also available. It
 * should be used if the input string's length is known.
 *)
function LLVMConstRealOfString(RealTy: LLVMTypeRef; const Text: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstRealOfString';

(**
 * Obtain a constant for a floating point value parsed from a string.
 *)
function LLVMConstRealOfStringAndSize(RealTy: LLVMTypeRef; const Text: PUTF8Char; SLen: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstRealOfStringAndSize';

(**
 * Obtain the zero extended value for an integer constant value.
 *
 * @see llvm::ConstantInt::getZExtValue()
 *)
function LLVMConstIntGetZExtValue(ConstantVal: LLVMValueRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstIntGetZExtValue';

(**
 * Obtain the sign extended value for an integer constant value.
 *
 * @see llvm::ConstantInt::getSExtValue()
 *)
function LLVMConstIntGetSExtValue(ConstantVal: LLVMValueRef): Int64; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstIntGetSExtValue';

(**
 * Obtain the double value for an floating point constant value.
 * losesInfo indicates if some precision was lost in the conversion.
 *
 * @see llvm::ConstantFP::getDoubleValue
 *)
function LLVMConstRealGetDouble(ConstantVal: LLVMValueRef; losesInfo: PLLVMBool): Double; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstRealGetDouble';

(**
 * Create a ConstantDataSequential and initialize it with a string.
 *
 * @deprecated LLVMConstStringInContext is deprecated in favor of the API
 * accurate LLVMConstStringInContext2
 * @see llvm::ConstantDataArray::getString()
 *)
function LLVMConstStringInContext(C: LLVMContextRef; const Str: PUTF8Char; Length: Cardinal; DontNullTerminate: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstStringInContext';

(**
 * Create a ConstantDataSequential and initialize it with a string.
 *
 * @see llvm::ConstantDataArray::getString()
 *)
function LLVMConstStringInContext2(C: LLVMContextRef; const Str: PUTF8Char; Length: NativeUInt; DontNullTerminate: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstStringInContext2';

(**
 * Create a ConstantDataSequential with string content in the global context.
 *
 * This is the same as LLVMConstStringInContext except it operates on the
 * global context.
 *
 * @see LLVMConstStringInContext()
 * @see llvm::ConstantDataArray::getString()
 *)
function LLVMConstString(const Str: PUTF8Char; Length: Cardinal; DontNullTerminate: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstString';

(**
 * Returns true if the specified constant is an array of i8.
 *
 * @see ConstantDataSequential::getAsString()
 *)
function LLVMIsConstantString(c: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsConstantString';

(**
 * Get the given constant data sequential as a string.
 *
 * @see ConstantDataSequential::getAsString()
 *)
function LLVMGetAsString(c: LLVMValueRef; Length: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetAsString';

(**
 * Get the raw, underlying bytes of the given constant data sequential.
 *
 * This is the same as LLVMGetAsString except it works for all constant data
 * sequentials, not just i8 arrays.
 *
 * @see ConstantDataSequential::getRawDataValues()
 *)
function LLVMGetRawDataValues(c: LLVMValueRef; SizeInBytes: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetRawDataValues';

(**
 * Create an anonymous ConstantStruct with the specified values.
 *
 * @see llvm::ConstantStruct::getAnon()
 *)
function LLVMConstStructInContext(C: LLVMContextRef; ConstantVals: PLLVMValueRef; Count: Cardinal; Packed_: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstStructInContext';

(**
 * Create a ConstantStruct in the global Context.
 *
 * This is the same as LLVMConstStructInContext except it operates on the
 * global Context.
 *
 * @see LLVMConstStructInContext()
 *)
function LLVMConstStruct(ConstantVals: PLLVMValueRef; Count: Cardinal; Packed_: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstStruct';

(**
 * Create a ConstantArray from values.
 *
 * @deprecated LLVMConstArray is deprecated in favor of the API accurate
 * LLVMConstArray2
 * @see llvm::ConstantArray::get()
 *)
function LLVMConstArray(ElementTy: LLVMTypeRef; ConstantVals: PLLVMValueRef; Length: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstArray';

(**
 * Create a ConstantArray from values.
 *
 * @see llvm::ConstantArray::get()
 *)
function LLVMConstArray2(ElementTy: LLVMTypeRef; ConstantVals: PLLVMValueRef; Length: UInt64): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstArray2';

(**
 * Create a ConstantDataArray from raw values.
 *
 * ElementTy must be one of i8, i16, i32, i64, half, bfloat, float, or double.
 * Data points to a contiguous buffer of raw values in the host endianness. The
 * element count is inferred from the element type and the data size in bytes.
 *
 * @see llvm::ConstantDataArray::getRaw()
 *)
function LLVMConstDataArray(ElementTy: LLVMTypeRef; const Data: PUTF8Char; SizeInBytes: NativeUInt): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstDataArray';

(**
 * Create a non-anonymous ConstantStruct from values.
 *
 * @see llvm::ConstantStruct::get()
 *)
function LLVMConstNamedStruct(StructTy: LLVMTypeRef; ConstantVals: PLLVMValueRef; Count: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNamedStruct';

(**
 * Get element of a constant aggregate (struct, array or vector) at the
 * specified index. Returns null if the index is out of range, or it's not
 * possible to determine the element (e.g., because the constant is a
 * constant expression.)
 *
 * @see llvm::Constant::getAggregateElement()
 *)
function LLVMGetAggregateElement(C: LLVMValueRef; Idx: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetAggregateElement';

function LLVMGetElementAsConstant(C: LLVMValueRef; idx: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetElementAsConstant';

(**
 * Create a ConstantVector from values.
 *
 * @see llvm::ConstantVector::get()
 *)
function LLVMConstVector(ScalarConstantVals: PLLVMValueRef; Size: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstVector';

(**
 * Create a ConstantPtrAuth constant with the given values.
 *
 * @see llvm::ConstantPtrAuth::get()
 *)
function LLVMConstantPtrAuth(Ptr: LLVMValueRef; Key: LLVMValueRef; Disc: LLVMValueRef; AddrDisc: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstantPtrAuth';

(**
 * @defgroup LLVMCCoreValueConstantExpressions Constant Expressions
 *
 * Functions in this group correspond to APIs on llvm::ConstantExpr.
 *
 * @see llvm::ConstantExpr.
 *
 * @{
 *)
function LLVMGetConstOpcode(ConstantVal: LLVMValueRef): LLVMOpcode; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetConstOpcode';

function LLVMAlignOf(Ty: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAlignOf';

function LLVMSizeOf(Ty: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMSizeOf';

function LLVMConstNeg(ConstantVal: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNeg';

function LLVMConstNSWNeg(ConstantVal: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNSWNeg';

function LLVMConstNUWNeg(ConstantVal: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNUWNeg';

function LLVMConstNot(ConstantVal: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNot';

function LLVMConstAdd(LHSConstant: LLVMValueRef; RHSConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstAdd';

function LLVMConstNSWAdd(LHSConstant: LLVMValueRef; RHSConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNSWAdd';

function LLVMConstNUWAdd(LHSConstant: LLVMValueRef; RHSConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNUWAdd';

function LLVMConstSub(LHSConstant: LLVMValueRef; RHSConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstSub';

function LLVMConstNSWSub(LHSConstant: LLVMValueRef; RHSConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNSWSub';

function LLVMConstNUWSub(LHSConstant: LLVMValueRef; RHSConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstNUWSub';

function LLVMConstXor(LHSConstant: LLVMValueRef; RHSConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstXor';

function LLVMConstGEP2(Ty: LLVMTypeRef; ConstantVal: LLVMValueRef; ConstantIndices: PLLVMValueRef; NumIndices: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstGEP2';

function LLVMConstInBoundsGEP2(Ty: LLVMTypeRef; ConstantVal: LLVMValueRef; ConstantIndices: PLLVMValueRef; NumIndices: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstInBoundsGEP2';

(**
 * Creates a constant GetElementPtr expression. Similar to LLVMConstGEP2, but
 * allows specifying the no-wrap flags.
 *
 * @see llvm::ConstantExpr::getGetElementPtr()
 *)
function LLVMConstGEPWithNoWrapFlags(Ty: LLVMTypeRef; ConstantVal: LLVMValueRef; ConstantIndices: PLLVMValueRef; NumIndices: Cardinal; NoWrapFlags: LLVMGEPNoWrapFlags): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstGEPWithNoWrapFlags';

function LLVMConstTrunc(ConstantVal: LLVMValueRef; ToType: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstTrunc';

function LLVMConstPtrToInt(ConstantVal: LLVMValueRef; ToType: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstPtrToInt';

function LLVMConstIntToPtr(ConstantVal: LLVMValueRef; ToType: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstIntToPtr';

function LLVMConstBitCast(ConstantVal: LLVMValueRef; ToType: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstBitCast';

function LLVMConstAddrSpaceCast(ConstantVal: LLVMValueRef; ToType: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstAddrSpaceCast';

function LLVMConstTruncOrBitCast(ConstantVal: LLVMValueRef; ToType: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstTruncOrBitCast';

function LLVMConstPointerCast(ConstantVal: LLVMValueRef; ToType: LLVMTypeRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstPointerCast';

function LLVMConstExtractElement(VectorConstant: LLVMValueRef; IndexConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstExtractElement';

function LLVMConstInsertElement(VectorConstant: LLVMValueRef; ElementValueConstant: LLVMValueRef; IndexConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstInsertElement';

function LLVMConstShuffleVector(VectorAConstant: LLVMValueRef; VectorBConstant: LLVMValueRef; MaskConstant: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstShuffleVector';

function LLVMBlockAddress(F: LLVMValueRef; BB: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBlockAddress';

(**
 * Gets the function associated with a given BlockAddress constant value.
 *)
function LLVMGetBlockAddressFunction(BlockAddr: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBlockAddressFunction';

(**
 * Gets the basic block associated with a given BlockAddress constant value.
 *)
function LLVMGetBlockAddressBasicBlock(BlockAddr: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBlockAddressBasicBlock';

(** Deprecated: Use LLVMGetInlineAsm instead. *)
function LLVMConstInlineAsm(Ty: LLVMTypeRef; const AsmString: PUTF8Char; const Constraints: PUTF8Char; HasSideEffects: LLVMBool; IsAlignStack: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMConstInlineAsm';

(**
 * @defgroup LLVMCCoreValueConstantGlobals Global Values
 *
 * This group contains functions that operate on global values. Functions in
 * this group relate to functions in the llvm::GlobalValue class tree.
 *
 * @see llvm::GlobalValue
 *
 * @{
 *)
function LLVMGetGlobalParent(Global: LLVMValueRef): LLVMModuleRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetGlobalParent';

function LLVMIsDeclaration(Global: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsDeclaration';

function LLVMGetLinkage(Global: LLVMValueRef): LLVMLinkage; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLinkage';

procedure LLVMSetLinkage(Global: LLVMValueRef; Linkage: LLVMLinkage); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetLinkage';

function LLVMGetSection(Global: LLVMValueRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSection';

procedure LLVMSetSection(Global: LLVMValueRef; const Section: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetSection';

function LLVMGetVisibility(Global: LLVMValueRef): LLVMVisibility; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetVisibility';

procedure LLVMSetVisibility(Global: LLVMValueRef; Viz: LLVMVisibility); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetVisibility';

function LLVMGetDLLStorageClass(Global: LLVMValueRef): LLVMDLLStorageClass; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDLLStorageClass';

procedure LLVMSetDLLStorageClass(Global: LLVMValueRef; Class_: LLVMDLLStorageClass); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetDLLStorageClass';

function LLVMGetUnnamedAddress(Global: LLVMValueRef): LLVMUnnamedAddr; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetUnnamedAddress';

procedure LLVMSetUnnamedAddress(Global: LLVMValueRef; UnnamedAddr: LLVMUnnamedAddr); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetUnnamedAddress';

(**
 * Returns the "value type" of a global value.  This differs from the formal
 * type of a global value which is always a pointer type.
 *
 * @see llvm::GlobalValue::getValueType()
 * @see llvm::Function::getFunctionType()
 *)
function LLVMGlobalGetValueType(Global: LLVMValueRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGlobalGetValueType';

(** Deprecated: Use LLVMGetUnnamedAddress instead. *)
function LLVMHasUnnamedAddr(Global: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMHasUnnamedAddr';

(** Deprecated: Use LLVMSetUnnamedAddress instead. *)
procedure LLVMSetUnnamedAddr(Global: LLVMValueRef; HasUnnamedAddr: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetUnnamedAddr';

(**
 * Obtain the preferred alignment of the value.
 * @see llvm::AllocaInst::getAlignment()
 * @see llvm::LoadInst::getAlignment()
 * @see llvm::StoreInst::getAlignment()
 * @see llvm::AtomicRMWInst::setAlignment()
 * @see llvm::AtomicCmpXchgInst::setAlignment()
 * @see llvm::GlobalValue::getAlignment()
 *)
function LLVMGetAlignment(V: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetAlignment';

(**
 * Set the preferred alignment of the value.
 * @see llvm::AllocaInst::setAlignment()
 * @see llvm::LoadInst::setAlignment()
 * @see llvm::StoreInst::setAlignment()
 * @see llvm::AtomicRMWInst::setAlignment()
 * @see llvm::AtomicCmpXchgInst::setAlignment()
 * @see llvm::GlobalValue::setAlignment()
 *)
procedure LLVMSetAlignment(V: LLVMValueRef; Bytes: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetAlignment';

(**
 * Sets a metadata attachment, erasing the existing metadata attachment if
 * it already exists for the given kind.
 *
 * @see llvm::GlobalObject::setMetadata()
 *)
procedure LLVMGlobalSetMetadata(Global: LLVMValueRef; Kind: Cardinal; MD: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGlobalSetMetadata';

(**
 * Erases a metadata attachment of the given kind if it exists.
 *
 * @see llvm::GlobalObject::eraseMetadata()
 *)
procedure LLVMGlobalEraseMetadata(Global: LLVMValueRef; Kind: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMGlobalEraseMetadata';

(**
 * Removes all metadata attachments from this value.
 *
 * @see llvm::GlobalObject::clearMetadata()
 *)
procedure LLVMGlobalClearMetadata(Global: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGlobalClearMetadata';

(**
 * Retrieves an array of metadata entries representing the metadata attached to
 * this value. The caller is responsible for freeing this array by calling
 * \c LLVMDisposeValueMetadataEntries.
 *
 * @see llvm::GlobalObject::getAllMetadata()
 *)
function LLVMGlobalCopyAllMetadata(Value: LLVMValueRef; NumEntries: PNativeUInt): PLLVMValueMetadataEntry; cdecl;
  external LLVM_DLL name _PU + 'LLVMGlobalCopyAllMetadata';

(**
 * Destroys value metadata entries.
 *)
procedure LLVMDisposeValueMetadataEntries(Entries: PLLVMValueMetadataEntry); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeValueMetadataEntries';

(**
 * Returns the kind of a value metadata entry at a specific index.
 *)
function LLVMValueMetadataEntriesGetKind(Entries: PLLVMValueMetadataEntry; Index: Cardinal): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMValueMetadataEntriesGetKind';

(**
 * Returns the underlying metadata node of a value metadata entry at a
 * specific index.
 *)
function LLVMValueMetadataEntriesGetMetadata(Entries: PLLVMValueMetadataEntry; Index: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMValueMetadataEntriesGetMetadata';

(**
 * @defgroup LLVMCoreValueConstantGlobalVariable Global Variables
 *
 * This group contains functions that operate on global variable values.
 *
 * @see llvm::GlobalVariable
 *
 * @{
 *)
function LLVMAddGlobal(M: LLVMModuleRef; Ty: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAddGlobal';

function LLVMAddGlobalInAddressSpace(M: LLVMModuleRef; Ty: LLVMTypeRef; const Name: PUTF8Char; AddressSpace: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAddGlobalInAddressSpace';

function LLVMGetNamedGlobal(M: LLVMModuleRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedGlobal';

function LLVMGetNamedGlobalWithLength(M: LLVMModuleRef; const Name: PUTF8Char; Length: NativeUInt): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedGlobalWithLength';

function LLVMGetFirstGlobal(M: LLVMModuleRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstGlobal';

function LLVMGetLastGlobal(M: LLVMModuleRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastGlobal';

function LLVMGetNextGlobal(GlobalVar: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextGlobal';

function LLVMGetPreviousGlobal(GlobalVar: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousGlobal';

procedure LLVMDeleteGlobal(GlobalVar: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDeleteGlobal';

function LLVMGetInitializer(GlobalVar: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInitializer';

procedure LLVMSetInitializer(GlobalVar: LLVMValueRef; ConstantVal: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetInitializer';

function LLVMIsThreadLocal(GlobalVar: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsThreadLocal';

procedure LLVMSetThreadLocal(GlobalVar: LLVMValueRef; IsThreadLocal: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetThreadLocal';

function LLVMIsGlobalConstant(GlobalVar: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsGlobalConstant';

procedure LLVMSetGlobalConstant(GlobalVar: LLVMValueRef; IsConstant: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetGlobalConstant';

function LLVMGetThreadLocalMode(GlobalVar: LLVMValueRef): LLVMThreadLocalMode; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetThreadLocalMode';

procedure LLVMSetThreadLocalMode(GlobalVar: LLVMValueRef; Mode: LLVMThreadLocalMode); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetThreadLocalMode';

function LLVMIsExternallyInitialized(GlobalVar: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsExternallyInitialized';

procedure LLVMSetExternallyInitialized(GlobalVar: LLVMValueRef; IsExtInit: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetExternallyInitialized';

(**
 * Add a GlobalAlias with the given value type, address space and aliasee.
 *
 * @see llvm::GlobalAlias::create()
 *)
function LLVMAddAlias2(M: LLVMModuleRef; ValueTy: LLVMTypeRef; AddrSpace: Cardinal; Aliasee: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAddAlias2';

(**
 * Obtain a GlobalAlias value from a Module by its name.
 *
 * The returned value corresponds to a llvm::GlobalAlias value.
 *
 * @see llvm::Module::getNamedAlias()
 *)
function LLVMGetNamedGlobalAlias(M: LLVMModuleRef; const Name: PUTF8Char; NameLen: NativeUInt): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedGlobalAlias';

(**
 * Obtain an iterator to the first GlobalAlias in a Module.
 *
 * @see llvm::Module::alias_begin()
 *)
function LLVMGetFirstGlobalAlias(M: LLVMModuleRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstGlobalAlias';

(**
 * Obtain an iterator to the last GlobalAlias in a Module.
 *
 * @see llvm::Module::alias_end()
 *)
function LLVMGetLastGlobalAlias(M: LLVMModuleRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastGlobalAlias';

(**
 * Advance a GlobalAlias iterator to the next GlobalAlias.
 *
 * Returns NULL if the iterator was already at the end and there are no more
 * global aliases.
 *)
function LLVMGetNextGlobalAlias(GA: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextGlobalAlias';

(**
 * Decrement a GlobalAlias iterator to the previous GlobalAlias.
 *
 * Returns NULL if the iterator was already at the beginning and there are
 * no previous global aliases.
 *)
function LLVMGetPreviousGlobalAlias(GA: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousGlobalAlias';

(**
 * Retrieve the target value of an alias.
 *)
function LLVMAliasGetAliasee(Alias: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAliasGetAliasee';

(**
 * Set the target value of an alias.
 *)
procedure LLVMAliasSetAliasee(Alias: LLVMValueRef; Aliasee: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAliasSetAliasee';

(**
 * Remove a function from its containing module and deletes it.
 *
 * @see llvm::Function::eraseFromParent()
 *)
procedure LLVMDeleteFunction(Fn: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDeleteFunction';

(**
 * Check whether the given function has a personality function.
 *
 * @see llvm::Function::hasPersonalityFn()
 *)
function LLVMHasPersonalityFn(Fn: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMHasPersonalityFn';

(**
 * Obtain the personality function attached to the function.
 *
 * @see llvm::Function::getPersonalityFn()
 *)
function LLVMGetPersonalityFn(Fn: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPersonalityFn';

(**
 * Set the personality function attached to the function.
 *
 * @see llvm::Function::setPersonalityFn()
 *)
procedure LLVMSetPersonalityFn(Fn: LLVMValueRef; PersonalityFn: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetPersonalityFn';

(**
 * Obtain the intrinsic ID number which matches the given function name.
 *
 * @see llvm::Intrinsic::lookupIntrinsicID()
 *)
function LLVMLookupIntrinsicID(const Name: PUTF8Char; NameLen: NativeUInt): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMLookupIntrinsicID';

(**
 * Obtain the ID number from a function instance.
 *
 * @see llvm::Function::getIntrinsicID()
 *)
function LLVMGetIntrinsicID(Fn: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetIntrinsicID';

(**
 * Get or insert the declaration of an intrinsic.  For overloaded intrinsics,
 * parameter types must be provided to uniquely identify an overload.
 *
 * @see llvm::Intrinsic::getOrInsertDeclaration()
 *)
function LLVMGetIntrinsicDeclaration(Mod_: LLVMModuleRef; ID: Cardinal; ParamTypes: PLLVMTypeRef; ParamCount: NativeUInt): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetIntrinsicDeclaration';

(**
 * Retrieves the type of an intrinsic.  For overloaded intrinsics, parameter
 * types must be provided to uniquely identify an overload.
 *
 * @see llvm::Intrinsic::getType()
 *)
function LLVMIntrinsicGetType(Ctx: LLVMContextRef; ID: Cardinal; ParamTypes: PLLVMTypeRef; ParamCount: NativeUInt): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntrinsicGetType';

(**
 * Retrieves the name of an intrinsic.
 *
 * @see llvm::Intrinsic::getName()
 *)
function LLVMIntrinsicGetName(ID: Cardinal; NameLength: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntrinsicGetName';

(** Deprecated: Use LLVMIntrinsicCopyOverloadedName2 instead. *)
function LLVMIntrinsicCopyOverloadedName(ID: Cardinal; ParamTypes: PLLVMTypeRef; ParamCount: NativeUInt; NameLength: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntrinsicCopyOverloadedName';

(**
 * Copies the name of an overloaded intrinsic identified by a given list of
 * parameter types.
 *
 * Unlike LLVMIntrinsicGetName, the caller is responsible for freeing the
 * returned string.
 *
 * This version also supports unnamed types.
 *
 * @see llvm::Intrinsic::getName()
 *)
function LLVMIntrinsicCopyOverloadedName2(Mod_: LLVMModuleRef; ID: Cardinal; ParamTypes: PLLVMTypeRef; ParamCount: NativeUInt; NameLength: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntrinsicCopyOverloadedName2';

(**
 * Obtain if the intrinsic identified by the given ID is overloaded.
 *
 * @see llvm::Intrinsic::isOverloaded()
 *)
function LLVMIntrinsicIsOverloaded(ID: Cardinal): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIntrinsicIsOverloaded';

(**
 * Obtain the calling function of a function.
 *
 * The returned value corresponds to the LLVMCallConv enumeration.
 *
 * @see llvm::Function::getCallingConv()
 *)
function LLVMGetFunctionCallConv(Fn: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFunctionCallConv';

(**
 * Set the calling convention of a function.
 *
 * @see llvm::Function::setCallingConv()
 *
 * @param Fn Function to operate on
 * @param CC LLVMCallConv to set calling convention to
 *)
procedure LLVMSetFunctionCallConv(Fn: LLVMValueRef; CC: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetFunctionCallConv';

(**
 * Obtain the name of the garbage collector to use during code
 * generation.
 *
 * @see llvm::Function::getGC()
 *)
function LLVMGetGC(Fn: LLVMValueRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetGC';

(**
 * Define the garbage collector to use during code generation.
 *
 * @see llvm::Function::setGC()
 *)
procedure LLVMSetGC(Fn: LLVMValueRef; const Name: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetGC';

(**
 * Gets the prefix data associated with a function. Only valid on functions, and
 * only if LLVMHasPrefixData returns true.
 * See https://llvm.org/docs/LangRef.html#prefix-data
 *)
function LLVMGetPrefixData(Fn: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPrefixData';

(**
 * Check if a given function has prefix data. Only valid on functions.
 * See https://llvm.org/docs/LangRef.html#prefix-data
 *)
function LLVMHasPrefixData(Fn: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMHasPrefixData';

(**
 * Sets the prefix data for the function. Only valid on functions.
 * See https://llvm.org/docs/LangRef.html#prefix-data
 *)
procedure LLVMSetPrefixData(Fn: LLVMValueRef; prefixData: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetPrefixData';

(**
 * Gets the prologue data associated with a function. Only valid on functions,
 * and only if LLVMHasPrologueData returns true.
 * See https://llvm.org/docs/LangRef.html#prologue-data
 *)
function LLVMGetPrologueData(Fn: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPrologueData';

(**
 * Check if a given function has prologue data. Only valid on functions.
 * See https://llvm.org/docs/LangRef.html#prologue-data
 *)
function LLVMHasPrologueData(Fn: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMHasPrologueData';

(**
 * Sets the prologue data for the function. Only valid on functions.
 * See https://llvm.org/docs/LangRef.html#prologue-data
 *)
procedure LLVMSetPrologueData(Fn: LLVMValueRef; prologueData: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetPrologueData';

(**
 * Add an attribute to a function.
 *
 * @see llvm::Function::addAttribute()
 *)
procedure LLVMAddAttributeAtIndex(F: LLVMValueRef; Idx: LLVMAttributeIndex; A: LLVMAttributeRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddAttributeAtIndex';

function LLVMGetAttributeCountAtIndex(F: LLVMValueRef; Idx: LLVMAttributeIndex): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetAttributeCountAtIndex';

procedure LLVMGetAttributesAtIndex(F: LLVMValueRef; Idx: LLVMAttributeIndex; Attrs: PLLVMAttributeRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetAttributesAtIndex';

function LLVMGetEnumAttributeAtIndex(F: LLVMValueRef; Idx: LLVMAttributeIndex; KindID: Cardinal): LLVMAttributeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetEnumAttributeAtIndex';

function LLVMGetStringAttributeAtIndex(F: LLVMValueRef; Idx: LLVMAttributeIndex; const K: PUTF8Char; KLen: Cardinal): LLVMAttributeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetStringAttributeAtIndex';

procedure LLVMRemoveEnumAttributeAtIndex(F: LLVMValueRef; Idx: LLVMAttributeIndex; KindID: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMRemoveEnumAttributeAtIndex';

procedure LLVMRemoveStringAttributeAtIndex(F: LLVMValueRef; Idx: LLVMAttributeIndex; const K: PUTF8Char; KLen: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMRemoveStringAttributeAtIndex';

(**
 * Add a target-dependent attribute to a function
 * @see llvm::AttrBuilder::addAttribute()
 *)
procedure LLVMAddTargetDependentFunctionAttr(Fn: LLVMValueRef; const A: PUTF8Char; const V: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddTargetDependentFunctionAttr';

(**
 * Obtain the number of parameters in a function.
 *
 * @see llvm::Function::arg_size()
 *)
function LLVMCountParams(Fn: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMCountParams';

(**
 * Obtain the parameters in a function.
 *
 * The takes a pointer to a pre-allocated array of LLVMValueRef that is
 * at least LLVMCountParams() long. This array will be filled with
 * LLVMValueRef instances which correspond to the parameters the
 * function receives. Each LLVMValueRef corresponds to a llvm::Argument
 * instance.
 *
 * @see llvm::Function::arg_begin()
 *)
procedure LLVMGetParams(Fn: LLVMValueRef; Params: PLLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetParams';

(**
 * Obtain the parameter at the specified index.
 *
 * Parameters are indexed from 0.
 *
 * @see llvm::Function::arg_begin()
 *)
function LLVMGetParam(Fn: LLVMValueRef; Index: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetParam';

(**
 * Obtain the function to which this argument belongs.
 *
 * Unlike other functions in this group, this one takes an LLVMValueRef
 * that corresponds to a llvm::Attribute.
 *
 * The returned LLVMValueRef is the llvm::Function to which this
 * argument belongs.
 *)
function LLVMGetParamParent(Inst: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetParamParent';

(**
 * Obtain the first parameter to a function.
 *
 * @see llvm::Function::arg_begin()
 *)
function LLVMGetFirstParam(Fn: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstParam';

(**
 * Obtain the last parameter to a function.
 *
 * @see llvm::Function::arg_end()
 *)
function LLVMGetLastParam(Fn: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastParam';

(**
 * Obtain the next parameter to a function.
 *
 * This takes an LLVMValueRef obtained from LLVMGetFirstParam() (which is
 * actually a wrapped iterator) and obtains the next parameter from the
 * underlying iterator.
 *)
function LLVMGetNextParam(Arg: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextParam';

(**
 * Obtain the previous parameter to a function.
 *
 * This is the opposite of LLVMGetNextParam().
 *)
function LLVMGetPreviousParam(Arg: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousParam';

(**
 * Set the alignment for a function parameter.
 *
 * @see llvm::Argument::addAttr()
 * @see llvm::AttrBuilder::addAlignmentAttr()
 *)
procedure LLVMSetParamAlignment(Arg: LLVMValueRef; Align: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetParamAlignment';

(**
 * Add a global indirect function to a module under a specified name.
 *
 * @see llvm::GlobalIFunc::create()
 *)
function LLVMAddGlobalIFunc(M: LLVMModuleRef; const Name: PUTF8Char; NameLen: NativeUInt; Ty: LLVMTypeRef; AddrSpace: Cardinal; Resolver: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAddGlobalIFunc';

(**
 * Obtain a GlobalIFunc value from a Module by its name.
 *
 * The returned value corresponds to a llvm::GlobalIFunc value.
 *
 * @see llvm::Module::getNamedIFunc()
 *)
function LLVMGetNamedGlobalIFunc(M: LLVMModuleRef; const Name: PUTF8Char; NameLen: NativeUInt): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNamedGlobalIFunc';

(**
 * Obtain an iterator to the first GlobalIFunc in a Module.
 *
 * @see llvm::Module::ifunc_begin()
 *)
function LLVMGetFirstGlobalIFunc(M: LLVMModuleRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstGlobalIFunc';

(**
 * Obtain an iterator to the last GlobalIFunc in a Module.
 *
 * @see llvm::Module::ifunc_end()
 *)
function LLVMGetLastGlobalIFunc(M: LLVMModuleRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastGlobalIFunc';

(**
 * Advance a GlobalIFunc iterator to the next GlobalIFunc.
 *
 * Returns NULL if the iterator was already at the end and there are no more
 * global aliases.
 *)
function LLVMGetNextGlobalIFunc(IFunc: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextGlobalIFunc';

(**
 * Decrement a GlobalIFunc iterator to the previous GlobalIFunc.
 *
 * Returns NULL if the iterator was already at the beginning and there are
 * no previous global aliases.
 *)
function LLVMGetPreviousGlobalIFunc(IFunc: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousGlobalIFunc';

(**
 * Retrieves the resolver function associated with this indirect function, or
 * NULL if it doesn't not exist.
 *
 * @see llvm::GlobalIFunc::getResolver()
 *)
function LLVMGetGlobalIFuncResolver(IFunc: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetGlobalIFuncResolver';

(**
 * Sets the resolver function associated with this indirect function.
 *
 * @see llvm::GlobalIFunc::setResolver()
 *)
procedure LLVMSetGlobalIFuncResolver(IFunc: LLVMValueRef; Resolver: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetGlobalIFuncResolver';

(**
 * Remove a global indirect function from its parent module and delete it.
 *
 * @see llvm::GlobalIFunc::eraseFromParent()
 *)
procedure LLVMEraseGlobalIFunc(IFunc: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMEraseGlobalIFunc';

(**
 * Remove a global indirect function from its parent module.
 *
 * This unlinks the global indirect function from its containing module but
 * keeps it alive.
 *
 * @see llvm::GlobalIFunc::removeFromParent()
 *)
procedure LLVMRemoveGlobalIFunc(IFunc: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMRemoveGlobalIFunc';

(**
 * Create an MDString value from a given string value.
 *
 * The MDString value does not take ownership of the given string, it remains
 * the responsibility of the caller to free it.
 *
 * @see llvm::MDString::get()
 *)
function LLVMMDStringInContext2(C: LLVMContextRef; const Str: PUTF8Char; SLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMDStringInContext2';

(**
 * Create an MDNode value with the given array of operands.
 *
 * @see llvm::MDNode::get()
 *)
function LLVMMDNodeInContext2(C: LLVMContextRef; MDs: PLLVMMetadataRef; Count: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMDNodeInContext2';

(**
 * Obtain a Metadata as a Value.
 *)
function LLVMMetadataAsValue(C: LLVMContextRef; MD: LLVMMetadataRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMetadataAsValue';

(**
 * Obtain a Value as a Metadata.
 *)
function LLVMValueAsMetadata(Val: LLVMValueRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMValueAsMetadata';

(**
 * Obtain the underlying string from a MDString value.
 *
 * @param V Instance to obtain string from.
 * @param Length Memory address which will hold length of returned string.
 * @return String data in MDString.
 *)
function LLVMGetMDString(V: LLVMValueRef; Length: PCardinal): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetMDString';

(**
 * Obtain the number of operands from an MDNode value.
 *
 * @param V MDNode to get number of operands from.
 * @return Number of operands of the MDNode.
 *)
function LLVMGetMDNodeNumOperands(V: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetMDNodeNumOperands';

(**
 * Obtain the given MDNode's operands.
 *
 * The passed LLVMValueRef pointer should point to enough memory to hold all of
 * the operands of the given MDNode (see LLVMGetMDNodeNumOperands) as
 * LLVMValueRefs. This memory will be populated with the LLVMValueRefs of the
 * MDNode's operands.
 *
 * @param V MDNode to get the operands from.
 * @param Dest Destination array for operands.
 *)
procedure LLVMGetMDNodeOperands(V: LLVMValueRef; Dest: PLLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetMDNodeOperands';

(**
 * Replace an operand at a specific index in a llvm::MDNode value.
 *
 * @see llvm::MDNode::replaceOperandWith()
 *)
procedure LLVMReplaceMDNodeOperandWith(V: LLVMValueRef; Index: Cardinal; Replacement: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMReplaceMDNodeOperandWith';

(** Deprecated: Use LLVMMDStringInContext2 instead. *)
function LLVMMDStringInContext(C: LLVMContextRef; const Str: PUTF8Char; SLen: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMDStringInContext';

(** Deprecated: Use LLVMMDStringInContext2 instead. *)
function LLVMMDString(const Str: PUTF8Char; SLen: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMDString';

(** Deprecated: Use LLVMMDNodeInContext2 instead. *)
function LLVMMDNodeInContext(C: LLVMContextRef; Vals: PLLVMValueRef; Count: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMDNodeInContext';

(** Deprecated: Use LLVMMDNodeInContext2 instead. *)
function LLVMMDNode(Vals: PLLVMValueRef; Count: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMDNode';

(**
 * Create a new operand bundle.
 *
 * Every invocation should be paired with LLVMDisposeOperandBundle() or memory
 * will be leaked.
 *
 * @param Tag Tag name of the operand bundle
 * @param TagLen Length of Tag
 * @param Args Memory address of an array of bundle operands
 * @param NumArgs Length of Args
 *)
function LLVMCreateOperandBundle(const Tag: PUTF8Char; TagLen: NativeUInt; Args: PLLVMValueRef; NumArgs: Cardinal): LLVMOperandBundleRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateOperandBundle';

(**
 * Destroy an operand bundle.
 *
 * This must be called for every created operand bundle or memory will be
 * leaked.
 *)
procedure LLVMDisposeOperandBundle(Bundle: LLVMOperandBundleRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeOperandBundle';

(**
 * Obtain the tag of an operand bundle as a string.
 *
 * @param Bundle Operand bundle to obtain tag of.
 * @param Len Out parameter which holds the length of the returned string.
 * @return The tag name of Bundle.
 * @see OperandBundleDef::getTag()
 *)
function LLVMGetOperandBundleTag(Bundle: LLVMOperandBundleRef; Len: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetOperandBundleTag';

(**
 * Obtain the number of operands for an operand bundle.
 *
 * @param Bundle Operand bundle to obtain operand count of.
 * @return The number of operands.
 * @see OperandBundleDef::input_size()
 *)
function LLVMGetNumOperandBundleArgs(Bundle: LLVMOperandBundleRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumOperandBundleArgs';

(**
 * Obtain the operand for an operand bundle at the given index.
 *
 * @param Bundle Operand bundle to obtain operand of.
 * @param Index An operand index, must be less than
 * LLVMGetNumOperandBundleArgs().
 * @return The operand.
 *)
function LLVMGetOperandBundleArgAtIndex(Bundle: LLVMOperandBundleRef; Index: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetOperandBundleArgAtIndex';

(**
 * Convert a basic block instance to a value type.
 *)
function LLVMBasicBlockAsValue(BB: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBasicBlockAsValue';

(**
 * Determine whether an LLVMValueRef is itself a basic block.
 *)
function LLVMValueIsBasicBlock(Val: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMValueIsBasicBlock';

(**
 * Convert an LLVMValueRef to an LLVMBasicBlockRef instance.
 *)
function LLVMValueAsBasicBlock(Val: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMValueAsBasicBlock';

(**
 * Obtain the string name of a basic block.
 *)
function LLVMGetBasicBlockName(BB: LLVMBasicBlockRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBasicBlockName';

(**
 * Obtain the function to which a basic block belongs.
 *
 * @see llvm::BasicBlock::getParent()
 *)
function LLVMGetBasicBlockParent(BB: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBasicBlockParent';

(**
 * Obtain the terminator instruction for a basic block.
 *
 * If the basic block does not have a terminator (it is not well-formed
 * if it doesn't), then NULL is returned.
 *
 * The returned LLVMValueRef corresponds to an llvm::Instruction.
 *
 * @see llvm::BasicBlock::getTerminator()
 *)
function LLVMGetBasicBlockTerminator(BB: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBasicBlockTerminator';

(**
 * Obtain the number of basic blocks in a function.
 *
 * @param Fn Function value to operate on.
 *)
function LLVMCountBasicBlocks(Fn: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMCountBasicBlocks';

(**
 * Obtain all of the basic blocks in a function.
 *
 * This operates on a function value. The BasicBlocks parameter is a
 * pointer to a pre-allocated array of LLVMBasicBlockRef of at least
 * LLVMCountBasicBlocks() in length. This array is populated with
 * LLVMBasicBlockRef instances.
 *)
procedure LLVMGetBasicBlocks(Fn: LLVMValueRef; BasicBlocks: PLLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBasicBlocks';

(**
 * Obtain the first basic block in a function.
 *
 * The returned basic block can be used as an iterator. You will likely
 * eventually call into LLVMGetNextBasicBlock() with it.
 *
 * @see llvm::Function::begin()
 *)
function LLVMGetFirstBasicBlock(Fn: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstBasicBlock';

(**
 * Obtain the last basic block in a function.
 *
 * @see llvm::Function::end()
 *)
function LLVMGetLastBasicBlock(Fn: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastBasicBlock';

(**
 * Advance a basic block iterator.
 *)
function LLVMGetNextBasicBlock(BB: LLVMBasicBlockRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextBasicBlock';

(**
 * Go backwards in a basic block iterator.
 *)
function LLVMGetPreviousBasicBlock(BB: LLVMBasicBlockRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousBasicBlock';

(**
 * Obtain the basic block that corresponds to the entry point of a
 * function.
 *
 * @see llvm::Function::getEntryBlock()
 *)
function LLVMGetEntryBasicBlock(Fn: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetEntryBasicBlock';

(**
 * Insert the given basic block after the insertion point of the given builder.
 *
 * The insertion point must be valid.
 *
 * @see llvm::Function::BasicBlockListType::insertAfter()
 *)
procedure LLVMInsertExistingBasicBlockAfterInsertBlock(Builder: LLVMBuilderRef; BB: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMInsertExistingBasicBlockAfterInsertBlock';

(**
 * Append the given basic block to the basic block list of the given function.
 *
 * @see llvm::Function::BasicBlockListType::push_back()
 *)
procedure LLVMAppendExistingBasicBlock(Fn: LLVMValueRef; BB: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAppendExistingBasicBlock';

(**
 * Create a new basic block without inserting it into a function.
 *
 * @see llvm::BasicBlock::Create()
 *)
function LLVMCreateBasicBlockInContext(C: LLVMContextRef; const Name: PUTF8Char): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateBasicBlockInContext';

(**
 * Append a basic block to the end of a function.
 *
 * @see llvm::BasicBlock::Create()
 *)
function LLVMAppendBasicBlockInContext(C: LLVMContextRef; Fn: LLVMValueRef; const Name: PUTF8Char): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAppendBasicBlockInContext';

(**
 * Append a basic block to the end of a function using the global
 * context.
 *
 * @see llvm::BasicBlock::Create()
 *)
function LLVMAppendBasicBlock(Fn: LLVMValueRef; const Name: PUTF8Char): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMAppendBasicBlock';

(**
 * Insert a basic block in a function before another basic block.
 *
 * The function to add to is determined by the function of the
 * passed basic block.
 *
 * @see llvm::BasicBlock::Create()
 *)
function LLVMInsertBasicBlockInContext(C: LLVMContextRef; BB: LLVMBasicBlockRef; const Name: PUTF8Char): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInsertBasicBlockInContext';

(**
 * Insert a basic block in a function using the global context.
 *
 * @see llvm::BasicBlock::Create()
 *)
function LLVMInsertBasicBlock(InsertBeforeBB: LLVMBasicBlockRef; const Name: PUTF8Char): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInsertBasicBlock';

(**
 * Remove a basic block from a function and delete it.
 *
 * This deletes the basic block from its containing function and deletes
 * the basic block itself.
 *
 * @see llvm::BasicBlock::eraseFromParent()
 *)
procedure LLVMDeleteBasicBlock(BB: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDeleteBasicBlock';

(**
 * Remove a basic block from a function.
 *
 * This deletes the basic block from its containing function but keep
 * the basic block alive.
 *
 * @see llvm::BasicBlock::removeFromParent()
 *)
procedure LLVMRemoveBasicBlockFromParent(BB: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMRemoveBasicBlockFromParent';

(**
 * Move a basic block to before another one.
 *
 * @see llvm::BasicBlock::moveBefore()
 *)
procedure LLVMMoveBasicBlockBefore(BB: LLVMBasicBlockRef; MovePos: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMMoveBasicBlockBefore';

(**
 * Move a basic block to after another one.
 *
 * @see llvm::BasicBlock::moveAfter()
 *)
procedure LLVMMoveBasicBlockAfter(BB: LLVMBasicBlockRef; MovePos: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMMoveBasicBlockAfter';

(**
 * Obtain the first instruction in a basic block.
 *
 * The returned LLVMValueRef corresponds to a llvm::Instruction
 * instance.
 *)
function LLVMGetFirstInstruction(BB: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstInstruction';

(**
 * Obtain the last instruction in a basic block.
 *
 * The returned LLVMValueRef corresponds to an LLVM:Instruction.
 *)
function LLVMGetLastInstruction(BB: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastInstruction';

(**
 * Determine whether an instruction has any metadata attached.
 *)
function LLVMHasMetadata(Val: LLVMValueRef): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMHasMetadata';

(**
 * Return metadata associated with an instruction value.
 *)
function LLVMGetMetadata(Val: LLVMValueRef; KindID: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetMetadata';

(**
 * Set metadata associated with an instruction value.
 *)
procedure LLVMSetMetadata(Val: LLVMValueRef; KindID: Cardinal; Node: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetMetadata';

(**
 * Returns the metadata associated with an instruction value, but filters out
 * all the debug locations.
 *
 * @see llvm::Instruction::getAllMetadataOtherThanDebugLoc()
 *)
function LLVMInstructionGetAllMetadataOtherThanDebugLoc(Instr: LLVMValueRef; NumEntries: PNativeUInt): PLLVMValueMetadataEntry; cdecl;
  external LLVM_DLL name _PU + 'LLVMInstructionGetAllMetadataOtherThanDebugLoc';

(**
 * Obtain the basic block to which an instruction belongs.
 *
 * @see llvm::Instruction::getParent()
 *)
function LLVMGetInstructionParent(Inst: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInstructionParent';

(**
 * Obtain the instruction that occurs after the one specified.
 *
 * The next instruction will be from the same basic block.
 *
 * If this is the last instruction in a basic block, NULL will be
 * returned.
 *)
function LLVMGetNextInstruction(Inst: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextInstruction';

(**
 * Obtain the instruction that occurred before this one.
 *
 * If the instruction is the first instruction in a basic block, NULL
 * will be returned.
 *)
function LLVMGetPreviousInstruction(Inst: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousInstruction';

(**
 * Remove an instruction.
 *
 * The instruction specified is removed from its containing building
 * block but is kept alive.
 *
 * @see llvm::Instruction::removeFromParent()
 *)
procedure LLVMInstructionRemoveFromParent(Inst: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMInstructionRemoveFromParent';

(**
 * Remove and delete an instruction.
 *
 * The instruction specified is removed from its containing building
 * block and then deleted.
 *
 * @see llvm::Instruction::eraseFromParent()
 *)
procedure LLVMInstructionEraseFromParent(Inst: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMInstructionEraseFromParent';

(**
 * Delete an instruction.
 *
 * The instruction specified is deleted. It must have previously been
 * removed from its containing building block.
 *
 * @see llvm::Value::deleteValue()
 *)
procedure LLVMDeleteInstruction(Inst: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDeleteInstruction';

(**
 * Obtain the code opcode for an individual instruction.
 *
 * @see llvm::Instruction::getOpCode()
 *)
function LLVMGetInstructionOpcode(Inst: LLVMValueRef): LLVMOpcode; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInstructionOpcode';

(**
 * Obtain the predicate of an instruction.
 *
 * This is only valid for instructions that correspond to llvm::ICmpInst.
 *
 * @see llvm::ICmpInst::getPredicate()
 *)
function LLVMGetICmpPredicate(Inst: LLVMValueRef): LLVMIntPredicate; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetICmpPredicate';

(**
 * Get whether or not an icmp instruction has the samesign flag.
 *
 * This is only valid for instructions that correspond to llvm::ICmpInst.
 *
 * @see llvm::ICmpInst::hasSameSign()
 *)
function LLVMGetICmpSameSign(Inst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetICmpSameSign';

(**
 * Set the samesign flag on an icmp instruction.
 *
 * This is only valid for instructions that correspond to llvm::ICmpInst.
 *
 * @see llvm::ICmpInst::setSameSign()
 *)
procedure LLVMSetICmpSameSign(Inst: LLVMValueRef; SameSign: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetICmpSameSign';

(**
 * Obtain the float predicate of an instruction.
 *
 * This is only valid for instructions that correspond to llvm::FCmpInst.
 *
 * @see llvm::FCmpInst::getPredicate()
 *)
function LLVMGetFCmpPredicate(Inst: LLVMValueRef): LLVMRealPredicate; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFCmpPredicate';

(**
 * Create a copy of 'this' instruction that is identical in all ways
 * except the following:
 *   * The instruction has no parent
 *   * The instruction has no name
 *
 * @see llvm::Instruction::clone()
 *)
function LLVMInstructionClone(Inst: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInstructionClone';

(**
 * Determine whether an instruction is a terminator. This routine is named to
 * be compatible with historical functions that did this by querying the
 * underlying C++ type.
 *
 * @see llvm::Instruction::isTerminator()
 *)
function LLVMIsATerminatorInst(Inst: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsATerminatorInst';

(**
 * Obtain the first debug record attached to an instruction.
 *
 * Use LLVMGetNextDbgRecord() and LLVMGetPreviousDbgRecord() to traverse the
 * sequence of DbgRecords.
 *
 * Return the first DbgRecord attached to Inst or NULL if there are none.
 *
 * @see llvm::Instruction::getDbgRecordRange()
 *)
function LLVMGetFirstDbgRecord(Inst: LLVMValueRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFirstDbgRecord';

(**
 * Obtain the last debug record attached to an instruction.
 *
 * Return the last DbgRecord attached to Inst or NULL if there are none.
 *
 * @see llvm::Instruction::getDbgRecordRange()
 *)
function LLVMGetLastDbgRecord(Inst: LLVMValueRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetLastDbgRecord';

(**
 * Obtain the next DbgRecord in the sequence or NULL if there are no more.
 *
 * @see llvm::Instruction::getDbgRecordRange()
 *)
function LLVMGetNextDbgRecord(DbgRecord: LLVMDbgRecordRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNextDbgRecord';

(**
 * Obtain the previous DbgRecord in the sequence or NULL if there are no more.
 *
 * @see llvm::Instruction::getDbgRecordRange()
 *)
function LLVMGetPreviousDbgRecord(DbgRecord: LLVMDbgRecordRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPreviousDbgRecord';

(**
 * Obtain the argument count for a call instruction.
 *
 * This expects an LLVMValueRef that corresponds to a llvm::CallInst,
 * llvm::InvokeInst, or llvm:FuncletPadInst.
 *
 * @see llvm::CallInst::getNumArgOperands()
 * @see llvm::InvokeInst::getNumArgOperands()
 * @see llvm::FuncletPadInst::getNumArgOperands()
 *)
function LLVMGetNumArgOperands(Instr: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumArgOperands';

(**
 * Set the calling convention for a call instruction.
 *
 * This expects an LLVMValueRef that corresponds to a llvm::CallInst or
 * llvm::InvokeInst.
 *
 * @see llvm::CallInst::setCallingConv()
 * @see llvm::InvokeInst::setCallingConv()
 *)
procedure LLVMSetInstructionCallConv(Instr: LLVMValueRef; CC: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetInstructionCallConv';

(**
 * Obtain the calling convention for a call instruction.
 *
 * This is the opposite of LLVMSetInstructionCallConv(). Reads its
 * usage.
 *
 * @see LLVMSetInstructionCallConv()
 *)
function LLVMGetInstructionCallConv(Instr: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInstructionCallConv';

procedure LLVMSetInstrParamAlignment(Instr: LLVMValueRef; Idx: LLVMAttributeIndex; Align: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetInstrParamAlignment';

procedure LLVMAddCallSiteAttribute(C: LLVMValueRef; Idx: LLVMAttributeIndex; A: LLVMAttributeRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddCallSiteAttribute';

function LLVMGetCallSiteAttributeCount(C: LLVMValueRef; Idx: LLVMAttributeIndex): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCallSiteAttributeCount';

procedure LLVMGetCallSiteAttributes(C: LLVMValueRef; Idx: LLVMAttributeIndex; Attrs: PLLVMAttributeRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCallSiteAttributes';

function LLVMGetCallSiteEnumAttribute(C: LLVMValueRef; Idx: LLVMAttributeIndex; KindID: Cardinal): LLVMAttributeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCallSiteEnumAttribute';

function LLVMGetCallSiteStringAttribute(C: LLVMValueRef; Idx: LLVMAttributeIndex; const K: PUTF8Char; KLen: Cardinal): LLVMAttributeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCallSiteStringAttribute';

procedure LLVMRemoveCallSiteEnumAttribute(C: LLVMValueRef; Idx: LLVMAttributeIndex; KindID: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMRemoveCallSiteEnumAttribute';

procedure LLVMRemoveCallSiteStringAttribute(C: LLVMValueRef; Idx: LLVMAttributeIndex; const K: PUTF8Char; KLen: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMRemoveCallSiteStringAttribute';

(**
 * Obtain the function type called by this instruction.
 *
 * @see llvm::CallBase::getFunctionType()
 *)
function LLVMGetCalledFunctionType(C: LLVMValueRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCalledFunctionType';

(**
 * Obtain the pointer to the function invoked by this instruction.
 *
 * This expects an LLVMValueRef that corresponds to a llvm::CallInst or
 * llvm::InvokeInst.
 *
 * @see llvm::CallInst::getCalledOperand()
 * @see llvm::InvokeInst::getCalledOperand()
 *)
function LLVMGetCalledValue(Instr: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCalledValue';

(**
 * Obtain the number of operand bundles attached to this instruction.
 *
 * This only works on llvm::CallInst and llvm::InvokeInst instructions.
 *
 * @see llvm::CallBase::getNumOperandBundles()
 *)
function LLVMGetNumOperandBundles(C: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumOperandBundles';

(**
 * Obtain the operand bundle attached to this instruction at the given index.
 * Use LLVMDisposeOperandBundle to free the operand bundle.
 *
 * This only works on llvm::CallInst and llvm::InvokeInst instructions.
 *)
function LLVMGetOperandBundleAtIndex(C: LLVMValueRef; Index: Cardinal): LLVMOperandBundleRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetOperandBundleAtIndex';

(**
 * Obtain whether a call instruction is a tail call.
 *
 * This only works on llvm::CallInst instructions.
 *
 * @see llvm::CallInst::isTailCall()
 *)
function LLVMIsTailCall(CallInst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsTailCall';

(**
 * Set whether a call instruction is a tail call.
 *
 * This only works on llvm::CallInst instructions.
 *
 * @see llvm::CallInst::setTailCall()
 *)
procedure LLVMSetTailCall(CallInst: LLVMValueRef; IsTailCall: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetTailCall';

(**
 * Obtain a tail call kind of the call instruction.
 *
 * @see llvm::CallInst::setTailCallKind()
 *)
function LLVMGetTailCallKind(CallInst: LLVMValueRef): LLVMTailCallKind; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetTailCallKind';

(**
 * Set the call kind of the call instruction.
 *
 * @see llvm::CallInst::getTailCallKind()
 *)
procedure LLVMSetTailCallKind(CallInst: LLVMValueRef; kind: LLVMTailCallKind); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetTailCallKind';

(**
 * Return the normal destination basic block.
 *
 * This only works on llvm::InvokeInst instructions.
 *
 * @see llvm::InvokeInst::getNormalDest()
 *)
function LLVMGetNormalDest(InvokeInst: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNormalDest';

(**
 * Return the unwind destination basic block.
 *
 * Works on llvm::InvokeInst, llvm::CleanupReturnInst, and
 * llvm::CatchSwitchInst instructions.
 *
 * @see llvm::InvokeInst::getUnwindDest()
 * @see llvm::CleanupReturnInst::getUnwindDest()
 * @see llvm::CatchSwitchInst::getUnwindDest()
 *)
function LLVMGetUnwindDest(InvokeInst: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetUnwindDest';

(**
 * Set the normal destination basic block.
 *
 * This only works on llvm::InvokeInst instructions.
 *
 * @see llvm::InvokeInst::setNormalDest()
 *)
procedure LLVMSetNormalDest(InvokeInst: LLVMValueRef; B: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetNormalDest';

(**
 * Set the unwind destination basic block.
 *
 * Works on llvm::InvokeInst, llvm::CleanupReturnInst, and
 * llvm::CatchSwitchInst instructions.
 *
 * @see llvm::InvokeInst::setUnwindDest()
 * @see llvm::CleanupReturnInst::setUnwindDest()
 * @see llvm::CatchSwitchInst::setUnwindDest()
 *)
procedure LLVMSetUnwindDest(InvokeInst: LLVMValueRef; B: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetUnwindDest';

(**
 * Get the default destination of a CallBr instruction.
 *
 * @see llvm::CallBrInst::getDefaultDest()
 *)
function LLVMGetCallBrDefaultDest(CallBr: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCallBrDefaultDest';

(**
 * Get the number of indirect destinations of a CallBr instruction.
 *
 * @see llvm::CallBrInst::getNumIndirectDests()

 *)
function LLVMGetCallBrNumIndirectDests(CallBr: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCallBrNumIndirectDests';

(**
 * Get the indirect destination of a CallBr instruction at the given index.
 *
 * @see llvm::CallBrInst::getIndirectDest()
 *)
function LLVMGetCallBrIndirectDest(CallBr: LLVMValueRef; Idx: Cardinal): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCallBrIndirectDest';

(**
 * Return the number of successors that this terminator has.
 *
 * @see llvm::Instruction::getNumSuccessors
 *)
function LLVMGetNumSuccessors(Term: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumSuccessors';

(**
 * Return the specified successor.
 *
 * @see llvm::Instruction::getSuccessor
 *)
function LLVMGetSuccessor(Term: LLVMValueRef; i: Cardinal): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSuccessor';

(**
 * Update the specified successor to point at the provided block.
 *
 * @see llvm::Instruction::setSuccessor
 *)
procedure LLVMSetSuccessor(Term: LLVMValueRef; i: Cardinal; block: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetSuccessor';

(**
 * Return if a branch is conditional.
 *
 * This only works on llvm::BranchInst instructions.
 *
 * @see llvm::BranchInst::isConditional
 *)
function LLVMIsConditional(Branch: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsConditional';

(**
 * Return the condition of a branch instruction.
 *
 * This only works on llvm::BranchInst instructions.
 *
 * @see llvm::BranchInst::getCondition
 *)
function LLVMGetCondition(Branch: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCondition';

(**
 * Set the condition of a branch instruction.
 *
 * This only works on llvm::BranchInst instructions.
 *
 * @see llvm::BranchInst::setCondition
 *)
procedure LLVMSetCondition(Branch: LLVMValueRef; Cond: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetCondition';

(**
 * Obtain the default destination basic block of a switch instruction.
 *
 * This only works on llvm::SwitchInst instructions.
 *
 * @see llvm::SwitchInst::getDefaultDest()
 *)
function LLVMGetSwitchDefaultDest(SwitchInstr: LLVMValueRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSwitchDefaultDest';

(**
 * Obtain the type that is being allocated by the alloca instruction.
 *)
function LLVMGetAllocatedType(Alloca: LLVMValueRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetAllocatedType';

(**
 * Check whether the given GEP operator is inbounds.
 *)
function LLVMIsInBounds(GEP: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsInBounds';

(**
 * Set the given GEP instruction to be inbounds or not.
 *)
procedure LLVMSetIsInBounds(GEP: LLVMValueRef; InBounds: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetIsInBounds';

(**
 * Get the source element type of the given GEP operator.
 *)
function LLVMGetGEPSourceElementType(GEP: LLVMValueRef): LLVMTypeRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetGEPSourceElementType';

(**
 * Get the no-wrap related flags for the given GEP instruction.
 *
 * @see llvm::GetElementPtrInst::getNoWrapFlags
 *)
function LLVMGEPGetNoWrapFlags(GEP: LLVMValueRef): LLVMGEPNoWrapFlags; cdecl;
  external LLVM_DLL name _PU + 'LLVMGEPGetNoWrapFlags';

(**
 * Set the no-wrap related flags for the given GEP instruction.
 *
 * @see llvm::GetElementPtrInst::setNoWrapFlags
 *)
procedure LLVMGEPSetNoWrapFlags(GEP: LLVMValueRef; NoWrapFlags: LLVMGEPNoWrapFlags); cdecl;
  external LLVM_DLL name _PU + 'LLVMGEPSetNoWrapFlags';

(**
 * Add an incoming value to the end of a PHI list.
 *)
procedure LLVMAddIncoming(PhiNode: LLVMValueRef; IncomingValues: PLLVMValueRef; IncomingBlocks: PLLVMBasicBlockRef; Count: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddIncoming';

(**
 * Obtain the number of incoming basic blocks to a PHI node.
 *)
function LLVMCountIncoming(PhiNode: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMCountIncoming';

(**
 * Obtain an incoming value to a PHI node as an LLVMValueRef.
 *)
function LLVMGetIncomingValue(PhiNode: LLVMValueRef; Index: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetIncomingValue';

(**
 * Obtain an incoming value to a PHI node as an LLVMBasicBlockRef.
 *)
function LLVMGetIncomingBlock(PhiNode: LLVMValueRef; Index: Cardinal): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetIncomingBlock';

(**
 * Obtain the number of indices.
 * NB: This also works on GEP operators.
 *)
function LLVMGetNumIndices(Inst: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumIndices';

(**
 * Obtain the indices as an array.
 *)
function LLVMGetIndices(Inst: LLVMValueRef): PCardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetIndices';

(**
 * @defgroup LLVMCCoreInstructionBuilder Instruction Builders
 *
 * An instruction builder represents a point within a basic block and is
 * the exclusive means of building instructions using the C interface.
 *
 * @{
 *)
function LLVMCreateBuilderInContext(C: LLVMContextRef): LLVMBuilderRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateBuilderInContext';

function LLVMCreateBuilder(): LLVMBuilderRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateBuilder';

(**
 * Set the builder position before Instr but after any attached debug records,
 * or if Instr is null set the position to the end of Block.
 *)
procedure LLVMPositionBuilder(Builder: LLVMBuilderRef; Block: LLVMBasicBlockRef; Instr: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMPositionBuilder';

(**
 * Set the builder position before Instr and any attached debug records,
 * or if Instr is null set the position to the end of Block.
 *)
procedure LLVMPositionBuilderBeforeDbgRecords(Builder: LLVMBuilderRef; Block: LLVMBasicBlockRef; Inst: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMPositionBuilderBeforeDbgRecords';

(**
 * Set the builder position before Instr but after any attached debug records.
 *)
procedure LLVMPositionBuilderBefore(Builder: LLVMBuilderRef; Instr: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMPositionBuilderBefore';

(**
 * Set the builder position before Instr and any attached debug records.
 *)
procedure LLVMPositionBuilderBeforeInstrAndDbgRecords(Builder: LLVMBuilderRef; Instr: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMPositionBuilderBeforeInstrAndDbgRecords';

procedure LLVMPositionBuilderAtEnd(Builder: LLVMBuilderRef; Block: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMPositionBuilderAtEnd';

function LLVMGetInsertBlock(Builder: LLVMBuilderRef): LLVMBasicBlockRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetInsertBlock';

procedure LLVMClearInsertionPosition(Builder: LLVMBuilderRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMClearInsertionPosition';

procedure LLVMInsertIntoBuilder(Builder: LLVMBuilderRef; Instr: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMInsertIntoBuilder';

procedure LLVMInsertIntoBuilderWithName(Builder: LLVMBuilderRef; Instr: LLVMValueRef; const Name: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMInsertIntoBuilderWithName';

procedure LLVMDisposeBuilder(Builder: LLVMBuilderRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeBuilder';

(**
 * Get location information used by debugging information.
 *
 * @see llvm::IRBuilder::getCurrentDebugLocation()
 *)
function LLVMGetCurrentDebugLocation2(Builder: LLVMBuilderRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCurrentDebugLocation2';

(**
 * Set location information used by debugging information.
 *
 * To clear the location metadata of the given instruction, pass NULL to \p Loc.
 *
 * @see llvm::IRBuilder::SetCurrentDebugLocation()
 *)
procedure LLVMSetCurrentDebugLocation2(Builder: LLVMBuilderRef; Loc: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetCurrentDebugLocation2';

(**
 * Attempts to set the debug location for the given instruction using the
 * current debug location for the given builder.  If the builder has no current
 * debug location, this function is a no-op.
 *
 * @deprecated LLVMSetInstDebugLocation is deprecated in favor of the more general
 *             LLVMAddMetadataToInst.
 *
 * @see llvm::IRBuilder::SetInstDebugLocation()
 *)
procedure LLVMSetInstDebugLocation(Builder: LLVMBuilderRef; Inst: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetInstDebugLocation';

(**
 * Adds the metadata registered with the given builder to the given instruction.
 *
 * @see llvm::IRBuilder::AddMetadataToInst()
 *)
procedure LLVMAddMetadataToInst(Builder: LLVMBuilderRef; Inst: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddMetadataToInst';

(**
 * Get the dafult floating-point math metadata for a given builder.
 *
 * @see llvm::IRBuilder::getDefaultFPMathTag()
 *)
function LLVMBuilderGetDefaultFPMathTag(Builder: LLVMBuilderRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuilderGetDefaultFPMathTag';

(**
 * Set the default floating-point math metadata for the given builder.
 *
 * To clear the metadata, pass NULL to \p FPMathTag.
 *
 * @see llvm::IRBuilder::setDefaultFPMathTag()
 *)
procedure LLVMBuilderSetDefaultFPMathTag(Builder: LLVMBuilderRef; FPMathTag: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMBuilderSetDefaultFPMathTag';

(**
 * Obtain the context to which this builder is associated.
 *
 * @see llvm::IRBuilder::getContext()
 *)
function LLVMGetBuilderContext(Builder: LLVMBuilderRef): LLVMContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBuilderContext';

(**
 * Deprecated: Passing the NULL location will crash.
 * Use LLVMGetCurrentDebugLocation2 instead.
 *)
procedure LLVMSetCurrentDebugLocation(Builder: LLVMBuilderRef; L: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetCurrentDebugLocation';

(**
 * Deprecated: Returning the NULL location will crash.
 * Use LLVMGetCurrentDebugLocation2 instead.
 *)
function LLVMGetCurrentDebugLocation(Builder: LLVMBuilderRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCurrentDebugLocation';

function LLVMBuildRetVoid(p1: LLVMBuilderRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildRetVoid';

function LLVMBuildRet(p1: LLVMBuilderRef; V: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildRet';

function LLVMBuildAggregateRet(p1: LLVMBuilderRef; RetVals: PLLVMValueRef; N: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAggregateRet';

function LLVMBuildBr(p1: LLVMBuilderRef; Dest: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildBr';

function LLVMBuildCondBr(p1: LLVMBuilderRef; If_: LLVMValueRef; Then_: LLVMBasicBlockRef; Else_: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCondBr';

function LLVMBuildSwitch(p1: LLVMBuilderRef; V: LLVMValueRef; Else_: LLVMBasicBlockRef; NumCases: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildSwitch';

function LLVMBuildIndirectBr(B: LLVMBuilderRef; Addr: LLVMValueRef; NumDests: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildIndirectBr';

function LLVMBuildCallBr(B: LLVMBuilderRef; Ty: LLVMTypeRef; Fn: LLVMValueRef; DefaultDest: LLVMBasicBlockRef; IndirectDests: PLLVMBasicBlockRef; NumIndirectDests: Cardinal; Args: PLLVMValueRef; NumArgs: Cardinal; Bundles: PLLVMOperandBundleRef; NumBundles: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCallBr';

function LLVMBuildInvoke2(p1: LLVMBuilderRef; Ty: LLVMTypeRef; Fn: LLVMValueRef; Args: PLLVMValueRef; NumArgs: Cardinal; Then_: LLVMBasicBlockRef; Catch: LLVMBasicBlockRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildInvoke2';

function LLVMBuildInvokeWithOperandBundles(p1: LLVMBuilderRef; Ty: LLVMTypeRef; Fn: LLVMValueRef; Args: PLLVMValueRef; NumArgs: Cardinal; Then_: LLVMBasicBlockRef; Catch: LLVMBasicBlockRef; Bundles: PLLVMOperandBundleRef; NumBundles: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildInvokeWithOperandBundles';

function LLVMBuildUnreachable(p1: LLVMBuilderRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildUnreachable';

function LLVMBuildResume(B: LLVMBuilderRef; Exn: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildResume';

function LLVMBuildLandingPad(B: LLVMBuilderRef; Ty: LLVMTypeRef; PersFn: LLVMValueRef; NumClauses: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildLandingPad';

function LLVMBuildCleanupRet(B: LLVMBuilderRef; CatchPad: LLVMValueRef; BB: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCleanupRet';

function LLVMBuildCatchRet(B: LLVMBuilderRef; CatchPad: LLVMValueRef; BB: LLVMBasicBlockRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCatchRet';

function LLVMBuildCatchPad(B: LLVMBuilderRef; ParentPad: LLVMValueRef; Args: PLLVMValueRef; NumArgs: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCatchPad';

function LLVMBuildCleanupPad(B: LLVMBuilderRef; ParentPad: LLVMValueRef; Args: PLLVMValueRef; NumArgs: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCleanupPad';

function LLVMBuildCatchSwitch(B: LLVMBuilderRef; ParentPad: LLVMValueRef; UnwindBB: LLVMBasicBlockRef; NumHandlers: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCatchSwitch';

procedure LLVMAddCase(Switch: LLVMValueRef; OnVal: LLVMValueRef; Dest: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddCase';

procedure LLVMAddDestination(IndirectBr: LLVMValueRef; Dest: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddDestination';

function LLVMGetNumClauses(LandingPad: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumClauses';

function LLVMGetClause(LandingPad: LLVMValueRef; Idx: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetClause';

procedure LLVMAddClause(LandingPad: LLVMValueRef; ClauseVal: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddClause';

function LLVMIsCleanup(LandingPad: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsCleanup';

procedure LLVMSetCleanup(LandingPad: LLVMValueRef; Val: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetCleanup';

procedure LLVMAddHandler(CatchSwitch: LLVMValueRef; Dest: LLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddHandler';

function LLVMGetNumHandlers(CatchSwitch: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumHandlers';

(**
 * Obtain the basic blocks acting as handlers for a catchswitch instruction.
 *
 * The Handlers parameter should point to a pre-allocated array of
 * LLVMBasicBlockRefs at least LLVMGetNumHandlers() large. On return, the
 * first LLVMGetNumHandlers() entries in the array will be populated
 * with LLVMBasicBlockRef instances.
 *
 * @param CatchSwitch The catchswitch instruction to operate on.
 * @param Handlers Memory address of an array to be filled with basic blocks.
 *)
procedure LLVMGetHandlers(CatchSwitch: LLVMValueRef; Handlers: PLLVMBasicBlockRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMGetHandlers';

function LLVMGetArgOperand(Funclet: LLVMValueRef; i: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetArgOperand';

procedure LLVMSetArgOperand(Funclet: LLVMValueRef; i: Cardinal; value: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetArgOperand';

(**
 * Get the parent catchswitch instruction of a catchpad instruction.
 *
 * This only works on llvm::CatchPadInst instructions.
 *
 * @see llvm::CatchPadInst::getCatchSwitch()
 *)
function LLVMGetParentCatchSwitch(CatchPad: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetParentCatchSwitch';

(**
 * Set the parent catchswitch instruction of a catchpad instruction.
 *
 * This only works on llvm::CatchPadInst instructions.
 *
 * @see llvm::CatchPadInst::setCatchSwitch()
 *)
procedure LLVMSetParentCatchSwitch(CatchPad: LLVMValueRef; CatchSwitch: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetParentCatchSwitch';

function LLVMBuildAdd(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAdd';

function LLVMBuildNSWAdd(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNSWAdd';

function LLVMBuildNUWAdd(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNUWAdd';

function LLVMBuildFAdd(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFAdd';

function LLVMBuildSub(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildSub';

function LLVMBuildNSWSub(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNSWSub';

function LLVMBuildNUWSub(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNUWSub';

function LLVMBuildFSub(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFSub';

function LLVMBuildMul(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildMul';

function LLVMBuildNSWMul(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNSWMul';

function LLVMBuildNUWMul(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNUWMul';

function LLVMBuildFMul(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFMul';

function LLVMBuildUDiv(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildUDiv';

function LLVMBuildExactUDiv(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildExactUDiv';

function LLVMBuildSDiv(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildSDiv';

function LLVMBuildExactSDiv(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildExactSDiv';

function LLVMBuildFDiv(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFDiv';

function LLVMBuildURem(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildURem';

function LLVMBuildSRem(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildSRem';

function LLVMBuildFRem(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFRem';

function LLVMBuildShl(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildShl';

function LLVMBuildLShr(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildLShr';

function LLVMBuildAShr(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAShr';

function LLVMBuildAnd(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAnd';

function LLVMBuildOr(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildOr';

function LLVMBuildXor(p1: LLVMBuilderRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildXor';

function LLVMBuildBinOp(B: LLVMBuilderRef; Op: LLVMOpcode; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildBinOp';

function LLVMBuildNeg(p1: LLVMBuilderRef; V: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNeg';

function LLVMBuildNSWNeg(B: LLVMBuilderRef; V: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNSWNeg';

function LLVMBuildNUWNeg(B: LLVMBuilderRef; V: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNUWNeg';

function LLVMBuildFNeg(p1: LLVMBuilderRef; V: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFNeg';

function LLVMBuildNot(p1: LLVMBuilderRef; V: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildNot';

function LLVMGetNUW(ArithInst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNUW';

procedure LLVMSetNUW(ArithInst: LLVMValueRef; HasNUW: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetNUW';

function LLVMGetNSW(ArithInst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNSW';

procedure LLVMSetNSW(ArithInst: LLVMValueRef; HasNSW: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetNSW';

function LLVMGetExact(DivOrShrInst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetExact';

procedure LLVMSetExact(DivOrShrInst: LLVMValueRef; IsExact: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetExact';

(**
 * Gets if the instruction has the non-negative flag set.
 * Only valid for zext instructions.
 *)
function LLVMGetNNeg(NonNegInst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNNeg';

(**
 * Sets the non-negative flag for the instruction.
 * Only valid for zext instructions.
 *)
procedure LLVMSetNNeg(NonNegInst: LLVMValueRef; IsNonNeg: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetNNeg';

(**
 * Get the flags for which fast-math-style optimizations are allowed for this
 * value.
 *
 * Only valid on floating point instructions.
 * @see LLVMCanValueUseFastMathFlags
 *)
function LLVMGetFastMathFlags(FPMathInst: LLVMValueRef): LLVMFastMathFlags; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFastMathFlags';

(**
 * Sets the flags for which fast-math-style optimizations are allowed for this
 * value.
 *
 * Only valid on floating point instructions.
 * @see LLVMCanValueUseFastMathFlags
 *)
procedure LLVMSetFastMathFlags(FPMathInst: LLVMValueRef; FMF: LLVMFastMathFlags); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetFastMathFlags';

(**
 * Check if a given value can potentially have fast math flags.
 *
 * Will return true for floating point arithmetic instructions, and for select,
 * phi, and call instructions whose type is a floating point type, or a vector
 * or array thereof. See https://llvm.org/docs/LangRef.html#fast-math-flags
 *)
function LLVMCanValueUseFastMathFlags(Inst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMCanValueUseFastMathFlags';

(**
 * Gets whether the instruction has the disjoint flag set.
 * Only valid for or instructions.
 *)
function LLVMGetIsDisjoint(Inst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetIsDisjoint';

(**
 * Sets the disjoint flag for the instruction.
 * Only valid for or instructions.
 *)
procedure LLVMSetIsDisjoint(Inst: LLVMValueRef; IsDisjoint: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetIsDisjoint';

function LLVMBuildMalloc(p1: LLVMBuilderRef; Ty: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildMalloc';

function LLVMBuildArrayMalloc(p1: LLVMBuilderRef; Ty: LLVMTypeRef; Val: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildArrayMalloc';

(**
 * Creates and inserts a memset to the specified pointer and the
 * specified value.
 *
 * @see llvm::IRRBuilder::CreateMemSet()
 *)
function LLVMBuildMemSet(B: LLVMBuilderRef; Ptr: LLVMValueRef; Val: LLVMValueRef; Len: LLVMValueRef; Align: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildMemSet';

(**
 * Creates and inserts a memcpy between the specified pointers.
 *
 * @see llvm::IRRBuilder::CreateMemCpy()
 *)
function LLVMBuildMemCpy(B: LLVMBuilderRef; Dst: LLVMValueRef; DstAlign: Cardinal; Src: LLVMValueRef; SrcAlign: Cardinal; Size: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildMemCpy';

(**
 * Creates and inserts a memmove between the specified pointers.
 *
 * @see llvm::IRRBuilder::CreateMemMove()
 *)
function LLVMBuildMemMove(B: LLVMBuilderRef; Dst: LLVMValueRef; DstAlign: Cardinal; Src: LLVMValueRef; SrcAlign: Cardinal; Size: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildMemMove';

function LLVMBuildAlloca(p1: LLVMBuilderRef; Ty: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAlloca';

function LLVMBuildArrayAlloca(p1: LLVMBuilderRef; Ty: LLVMTypeRef; Val: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildArrayAlloca';

function LLVMBuildFree(p1: LLVMBuilderRef; PointerVal: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFree';

function LLVMBuildLoad2(p1: LLVMBuilderRef; Ty: LLVMTypeRef; PointerVal: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildLoad2';

function LLVMBuildStore(p1: LLVMBuilderRef; Val: LLVMValueRef; Ptr: LLVMValueRef): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildStore';

function LLVMBuildGEP2(B: LLVMBuilderRef; Ty: LLVMTypeRef; Pointer: LLVMValueRef; Indices: PLLVMValueRef; NumIndices: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildGEP2';

function LLVMBuildInBoundsGEP2(B: LLVMBuilderRef; Ty: LLVMTypeRef; Pointer: LLVMValueRef; Indices: PLLVMValueRef; NumIndices: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildInBoundsGEP2';

(**
 * Creates a GetElementPtr instruction. Similar to LLVMBuildGEP2, but allows
 * specifying the no-wrap flags.
 *
 * @see llvm::IRBuilder::CreateGEP()
 *)
function LLVMBuildGEPWithNoWrapFlags(B: LLVMBuilderRef; Ty: LLVMTypeRef; Pointer: LLVMValueRef; Indices: PLLVMValueRef; NumIndices: Cardinal; const Name: PUTF8Char; NoWrapFlags: LLVMGEPNoWrapFlags): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildGEPWithNoWrapFlags';

function LLVMBuildStructGEP2(B: LLVMBuilderRef; Ty: LLVMTypeRef; Pointer: LLVMValueRef; Idx: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildStructGEP2';

function LLVMBuildGlobalString(B: LLVMBuilderRef; const Str: PUTF8Char; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildGlobalString';

(**
 * Deprecated: Use LLVMBuildGlobalString instead, which has identical behavior.
 *)
function LLVMBuildGlobalStringPtr(B: LLVMBuilderRef; const Str: PUTF8Char; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildGlobalStringPtr';

function LLVMGetVolatile(MemoryAccessInst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetVolatile';

procedure LLVMSetVolatile(MemoryAccessInst: LLVMValueRef; IsVolatile: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetVolatile';

function LLVMGetWeak(CmpXchgInst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetWeak';

procedure LLVMSetWeak(CmpXchgInst: LLVMValueRef; IsWeak: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetWeak';

function LLVMGetOrdering(MemoryAccessInst: LLVMValueRef): LLVMAtomicOrdering; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetOrdering';

procedure LLVMSetOrdering(MemoryAccessInst: LLVMValueRef; Ordering: LLVMAtomicOrdering); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetOrdering';

function LLVMGetAtomicRMWBinOp(AtomicRMWInst: LLVMValueRef): LLVMAtomicRMWBinOp; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetAtomicRMWBinOp';

procedure LLVMSetAtomicRMWBinOp(AtomicRMWInst: LLVMValueRef; BinOp: LLVMAtomicRMWBinOp); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetAtomicRMWBinOp';

function LLVMBuildTrunc(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildTrunc';

function LLVMBuildZExt(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildZExt';

function LLVMBuildSExt(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildSExt';

function LLVMBuildFPToUI(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFPToUI';

function LLVMBuildFPToSI(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFPToSI';

function LLVMBuildUIToFP(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildUIToFP';

function LLVMBuildSIToFP(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildSIToFP';

function LLVMBuildFPTrunc(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFPTrunc';

function LLVMBuildFPExt(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFPExt';

function LLVMBuildPtrToInt(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildPtrToInt';

function LLVMBuildIntToPtr(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildIntToPtr';

function LLVMBuildBitCast(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildBitCast';

function LLVMBuildAddrSpaceCast(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAddrSpaceCast';

function LLVMBuildZExtOrBitCast(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildZExtOrBitCast';

function LLVMBuildSExtOrBitCast(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildSExtOrBitCast';

function LLVMBuildTruncOrBitCast(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildTruncOrBitCast';

function LLVMBuildCast(B: LLVMBuilderRef; Op: LLVMOpcode; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCast';

function LLVMBuildPointerCast(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildPointerCast';

function LLVMBuildIntCast2(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; IsSigned: LLVMBool; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildIntCast2';

function LLVMBuildFPCast(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFPCast';

(** Deprecated: This cast is always signed. Use LLVMBuildIntCast2 instead. *)
function LLVMBuildIntCast(p1: LLVMBuilderRef; Val: LLVMValueRef; DestTy: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildIntCast';

function LLVMGetCastOpcode(Src: LLVMValueRef; SrcIsSigned: LLVMBool; DestTy: LLVMTypeRef; DestIsSigned: LLVMBool): LLVMOpcode; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCastOpcode';

function LLVMBuildICmp(p1: LLVMBuilderRef; Op: LLVMIntPredicate; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildICmp';

function LLVMBuildFCmp(p1: LLVMBuilderRef; Op: LLVMRealPredicate; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFCmp';

function LLVMBuildPhi(p1: LLVMBuilderRef; Ty: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildPhi';

function LLVMBuildCall2(p1: LLVMBuilderRef; p2: LLVMTypeRef; Fn: LLVMValueRef; Args: PLLVMValueRef; NumArgs: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCall2';

function LLVMBuildCallWithOperandBundles(p1: LLVMBuilderRef; p2: LLVMTypeRef; Fn: LLVMValueRef; Args: PLLVMValueRef; NumArgs: Cardinal; Bundles: PLLVMOperandBundleRef; NumBundles: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildCallWithOperandBundles';

function LLVMBuildSelect(p1: LLVMBuilderRef; If_: LLVMValueRef; Then_: LLVMValueRef; Else_: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildSelect';

function LLVMBuildVAArg(p1: LLVMBuilderRef; List: LLVMValueRef; Ty: LLVMTypeRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildVAArg';

function LLVMBuildExtractElement(p1: LLVMBuilderRef; VecVal: LLVMValueRef; Index: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildExtractElement';

function LLVMBuildInsertElement(p1: LLVMBuilderRef; VecVal: LLVMValueRef; EltVal: LLVMValueRef; Index: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildInsertElement';

function LLVMBuildShuffleVector(p1: LLVMBuilderRef; V1: LLVMValueRef; V2: LLVMValueRef; Mask: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildShuffleVector';

function LLVMBuildExtractValue(p1: LLVMBuilderRef; AggVal: LLVMValueRef; Index: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildExtractValue';

function LLVMBuildInsertValue(p1: LLVMBuilderRef; AggVal: LLVMValueRef; EltVal: LLVMValueRef; Index: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildInsertValue';

function LLVMBuildFreeze(p1: LLVMBuilderRef; Val: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFreeze';

function LLVMBuildIsNull(p1: LLVMBuilderRef; Val: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildIsNull';

function LLVMBuildIsNotNull(p1: LLVMBuilderRef; Val: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildIsNotNull';

function LLVMBuildPtrDiff2(p1: LLVMBuilderRef; ElemTy: LLVMTypeRef; LHS: LLVMValueRef; RHS: LLVMValueRef; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildPtrDiff2';

function LLVMBuildFence(B: LLVMBuilderRef; ordering: LLVMAtomicOrdering; singleThread: LLVMBool; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFence';

function LLVMBuildFenceSyncScope(B: LLVMBuilderRef; ordering: LLVMAtomicOrdering; SSID: Cardinal; const Name: PUTF8Char): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildFenceSyncScope';

function LLVMBuildAtomicRMW(B: LLVMBuilderRef; op: LLVMAtomicRMWBinOp; PTR: LLVMValueRef; Val: LLVMValueRef; ordering: LLVMAtomicOrdering; singleThread: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAtomicRMW';

function LLVMBuildAtomicRMWSyncScope(B: LLVMBuilderRef; op: LLVMAtomicRMWBinOp; PTR: LLVMValueRef; Val: LLVMValueRef; ordering: LLVMAtomicOrdering; SSID: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAtomicRMWSyncScope';

function LLVMBuildAtomicCmpXchg(B: LLVMBuilderRef; Ptr: LLVMValueRef; Cmp: LLVMValueRef; New: LLVMValueRef; SuccessOrdering: LLVMAtomicOrdering; FailureOrdering: LLVMAtomicOrdering; SingleThread: LLVMBool): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAtomicCmpXchg';

function LLVMBuildAtomicCmpXchgSyncScope(B: LLVMBuilderRef; Ptr: LLVMValueRef; Cmp: LLVMValueRef; New: LLVMValueRef; SuccessOrdering: LLVMAtomicOrdering; FailureOrdering: LLVMAtomicOrdering; SSID: Cardinal): LLVMValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBuildAtomicCmpXchgSyncScope';

(**
 * Get the number of elements in the mask of a ShuffleVector instruction.
 *)
function LLVMGetNumMaskElements(ShuffleVectorInst: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetNumMaskElements';

(**
 * \returns a constant that specifies that the result of a \c ShuffleVectorInst
 * is undefined.
 *)
function LLVMGetUndefMaskElem(): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetUndefMaskElem';

(**
 * Get the mask value at position Elt in the mask of a ShuffleVector
 * instruction.
 *
 * \Returns the result of \c LLVMGetUndefMaskElem() if the mask value is
 * poison at that position.
 *)
function LLVMGetMaskValue(ShuffleVectorInst: LLVMValueRef; Elt: Cardinal): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetMaskValue';

function LLVMIsAtomicSingleThread(AtomicInst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAtomicSingleThread';

procedure LLVMSetAtomicSingleThread(AtomicInst: LLVMValueRef; SingleThread: LLVMBool); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetAtomicSingleThread';

(**
 * Returns whether an instruction is an atomic instruction, e.g., atomicrmw,
 * cmpxchg, fence, or loads and stores with atomic ordering.
 *)
function LLVMIsAtomic(Inst: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsAtomic';

(**
 * Returns the synchronization scope ID of an atomic instruction.
 *)
function LLVMGetAtomicSyncScopeID(AtomicInst: LLVMValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetAtomicSyncScopeID';

(**
 * Sets the synchronization scope ID of an atomic instruction.
 *)
procedure LLVMSetAtomicSyncScopeID(AtomicInst: LLVMValueRef; SSID: Cardinal); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetAtomicSyncScopeID';

function LLVMGetCmpXchgSuccessOrdering(CmpXchgInst: LLVMValueRef): LLVMAtomicOrdering; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCmpXchgSuccessOrdering';

procedure LLVMSetCmpXchgSuccessOrdering(CmpXchgInst: LLVMValueRef; Ordering: LLVMAtomicOrdering); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetCmpXchgSuccessOrdering';

function LLVMGetCmpXchgFailureOrdering(CmpXchgInst: LLVMValueRef): LLVMAtomicOrdering; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetCmpXchgFailureOrdering';

procedure LLVMSetCmpXchgFailureOrdering(CmpXchgInst: LLVMValueRef; Ordering: LLVMAtomicOrdering); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetCmpXchgFailureOrdering';

(**
 * Changes the type of M so it can be passed to FunctionPassManagers and the
 * JIT.  They take ModuleProviders for historical reasons.
 *)
function LLVMCreateModuleProviderForExistingModule(M: LLVMModuleRef): LLVMModuleProviderRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateModuleProviderForExistingModule';

(**
 * Destroys the module M.
 *)
procedure LLVMDisposeModuleProvider(M: LLVMModuleProviderRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeModuleProvider';

(**
 * @defgroup LLVMCCoreMemoryBuffers Memory Buffers
 *
 * @{
 *)
function LLVMCreateMemoryBufferWithContentsOfFile(const Path: PUTF8Char; OutMemBuf: PLLVMMemoryBufferRef; OutMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateMemoryBufferWithContentsOfFile';

function LLVMCreateMemoryBufferWithSTDIN(OutMemBuf: PLLVMMemoryBufferRef; OutMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateMemoryBufferWithSTDIN';

function LLVMCreateMemoryBufferWithMemoryRange(const InputData: PUTF8Char; InputDataLength: NativeUInt; const BufferName: PUTF8Char; RequiresNullTerminator: LLVMBool): LLVMMemoryBufferRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateMemoryBufferWithMemoryRange';

function LLVMCreateMemoryBufferWithMemoryRangeCopy(const InputData: PUTF8Char; InputDataLength: NativeUInt; const BufferName: PUTF8Char): LLVMMemoryBufferRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateMemoryBufferWithMemoryRangeCopy';

function LLVMGetBufferStart(MemBuf: LLVMMemoryBufferRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBufferStart';

function LLVMGetBufferSize(MemBuf: LLVMMemoryBufferRef): NativeUInt; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetBufferSize';

procedure LLVMDisposeMemoryBuffer(MemBuf: LLVMMemoryBufferRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeMemoryBuffer';

(** Constructs a new whole-module pass pipeline. This type of pipeline is
    suitable for link-time optimization and whole-module transformations.
    @see llvm::PassManager::PassManager *)
function LLVMCreatePassManager(): LLVMPassManagerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreatePassManager';

(** Constructs a new function-by-function pass pipeline over the module
    provider. It does not take ownership of the module provider. This type of
    pipeline is suitable for code generation and JIT compilation tasks.
    @see llvm::FunctionPassManager::FunctionPassManager *)
function LLVMCreateFunctionPassManagerForModule(M: LLVMModuleRef): LLVMPassManagerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateFunctionPassManagerForModule';

(** Deprecated: Use LLVMCreateFunctionPassManagerForModule instead. *)
function LLVMCreateFunctionPassManager(MP: LLVMModuleProviderRef): LLVMPassManagerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateFunctionPassManager';

(** Initializes, executes on the provided module, and finalizes all of the
    passes scheduled in the pass manager. Returns 1 if any of the passes
    modified the module, 0 otherwise.
    @see llvm::PassManager::run(Module&) *)
function LLVMRunPassManager(PM: LLVMPassManagerRef; M: LLVMModuleRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMRunPassManager';

(** Initializes all of the function passes scheduled in the function pass
    manager. Returns 1 if any of the passes modified the module, 0 otherwise.
    @see llvm::FunctionPassManager::doInitialization *)
function LLVMInitializeFunctionPassManager(FPM: LLVMPassManagerRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMInitializeFunctionPassManager';

(** Executes all of the function passes scheduled in the function pass manager
    on the provided function. Returns 1 if any of the passes modified the
    function, false otherwise.
    @see llvm::FunctionPassManager::run(Function&) *)
function LLVMRunFunctionPassManager(FPM: LLVMPassManagerRef; F: LLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMRunFunctionPassManager';

(** Finalizes all of the function passes scheduled in the function pass
    manager. Returns 1 if any of the passes modified the module, 0 otherwise.
    @see llvm::FunctionPassManager::doFinalization *)
function LLVMFinalizeFunctionPassManager(FPM: LLVMPassManagerRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMFinalizeFunctionPassManager';

(** Frees the memory of a pass pipeline. For function pipelines, does not free
    the module provider.
    @see llvm::PassManagerBase::~PassManagerBase. *)
procedure LLVMDisposePassManager(PM: LLVMPassManagerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposePassManager';

(** Deprecated: Multi-threading can only be enabled/disabled with the compile
    time define LLVM_ENABLE_THREADS.  This function always returns
    LLVMIsMultithreaded(). *)
function LLVMStartMultithreaded(): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMStartMultithreaded';

(** Deprecated: Multi-threading can only be enabled/disabled with the compile
    time define LLVM_ENABLE_THREADS. *)
procedure LLVMStopMultithreaded(); cdecl;
  external LLVM_DLL name _PU + 'LLVMStopMultithreaded';

(** Check whether LLVM is executing in thread-safe mode or not.
    @see llvm::llvm_is_multithreaded *)
function LLVMIsMultithreaded(): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsMultithreaded';

(**
 * The current debug metadata version number.
 *)
function LLVMDebugMetadataVersion(): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMDebugMetadataVersion';

(**
 * The version of debug metadata that's present in the provided \c Module.
 *)
function LLVMGetModuleDebugMetadataVersion(Module: LLVMModuleRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetModuleDebugMetadataVersion';

(**
 * Strip debug info in the module if it exists.
 * To do this, we remove all calls to the debugger intrinsics and any named
 * metadata for debugging. We also remove debug locations for instructions.
 * Return true if module is modified.
 *)
function LLVMStripModuleDebugInfo(Module: LLVMModuleRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMStripModuleDebugInfo';

(**
 * Construct a builder for a module, and do not allow for unresolved nodes
 * attached to the module.
 *)
function LLVMCreateDIBuilderDisallowUnresolved(M: LLVMModuleRef): LLVMDIBuilderRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateDIBuilderDisallowUnresolved';

(**
 * Construct a builder for a module and collect unresolved nodes attached
 * to the module in order to resolve cycles during a call to
 * \c LLVMDIBuilderFinalize.
 *)
function LLVMCreateDIBuilder(M: LLVMModuleRef): LLVMDIBuilderRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateDIBuilder';

(**
 * Deallocates the \c DIBuilder and everything it owns.
 * @note You must call \c LLVMDIBuilderFinalize before this
 *)
procedure LLVMDisposeDIBuilder(Builder: LLVMDIBuilderRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeDIBuilder';

(**
 * Construct any deferred debug info descriptors.
 *)
procedure LLVMDIBuilderFinalize(Builder: LLVMDIBuilderRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderFinalize';

(**
 * Finalize a specific subprogram.
 * No new variables may be added to this subprogram afterwards.
 *)
procedure LLVMDIBuilderFinalizeSubprogram(Builder: LLVMDIBuilderRef; Subprogram: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderFinalizeSubprogram';

(**
 * A CompileUnit provides an anchor for all debugging
 * information generated during this instance of compilation.
 * \param Lang          Source programming language, eg.
 *                      \c LLVMDWARFSourceLanguageC99
 * \param FileRef       File info.
 * \param Producer      Identify the producer of debugging information
 *                      and code.  Usually this is a compiler
 *                      version string.
 * \param ProducerLen   The length of the C string passed to \c Producer.
 * \param isOptimized   A boolean flag which indicates whether optimization
 *                      is enabled or not.
 * \param Flags         This string lists command line options. This
 *                      string is directly embedded in debug info
 *                      output which may be used by a tool
 *                      analyzing generated debugging information.
 * \param FlagsLen      The length of the C string passed to \c Flags.
 * \param RuntimeVer    This indicates runtime version for languages like
 *                      Objective-C.
 * \param SplitName     The name of the file that we'll split debug info
 *                      out into.
 * \param SplitNameLen  The length of the C string passed to \c SplitName.
 * \param Kind          The kind of debug information to generate.
 * \param DWOId         The DWOId if this is a split skeleton compile unit.
 * \param SplitDebugInlining    Whether to emit inline debug info.
 * \param DebugInfoForProfiling Whether to emit extra debug info for
 *                              profile collection.
 * \param SysRoot         The Clang system root (value of -isysroot).
 * \param SysRootLen      The length of the C string passed to \c SysRoot.
 * \param SDK           The SDK. On Darwin, the last component of the sysroot.
 * \param SDKLen        The length of the C string passed to \c SDK.
 *)
function LLVMDIBuilderCreateCompileUnit(Builder: LLVMDIBuilderRef; Lang: LLVMDWARFSourceLanguage; FileRef: LLVMMetadataRef; const Producer: PUTF8Char; ProducerLen: NativeUInt; isOptimized: LLVMBool; const Flags: PUTF8Char; FlagsLen: NativeUInt; RuntimeVer: Cardinal; const SplitName: PUTF8Char; SplitNameLen: NativeUInt; Kind: LLVMDWARFEmissionKind; DWOId: Cardinal; SplitDebugInlining: LLVMBool; DebugInfoForProfiling: LLVMBool; const SysRoot: PUTF8Char; SysRootLen: NativeUInt; const SDK: PUTF8Char; SDKLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateCompileUnit';

(**
 * Create a file descriptor to hold debugging information for a file.
 * \param Builder      The \c DIBuilder.
 * \param Filename     File name.
 * \param FilenameLen  The length of the C string passed to \c Filename.
 * \param Directory    Directory.
 * \param DirectoryLen The length of the C string passed to \c Directory.
 *)
function LLVMDIBuilderCreateFile(Builder: LLVMDIBuilderRef; const Filename: PUTF8Char; FilenameLen: NativeUInt; const Directory: PUTF8Char; DirectoryLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateFile';

(**
 * Creates a new descriptor for a module with the specified parent scope.
 * \param Builder         The \c DIBuilder.
 * \param ParentScope     The parent scope containing this module declaration.
 * \param Name            Module name.
 * \param NameLen         The length of the C string passed to \c Name.
 * \param ConfigMacros    A space-separated shell-quoted list of -D macro
                          definitions as they would appear on a command line.
 * \param ConfigMacrosLen The length of the C string passed to \c ConfigMacros.
 * \param IncludePath     The path to the module map file.
 * \param IncludePathLen  The length of the C string passed to \c IncludePath.
 * \param APINotesFile    The path to an API notes file for the module.
 * \param APINotesFileLen The length of the C string passed to \c APINotestFile.
 *)
function LLVMDIBuilderCreateModule(Builder: LLVMDIBuilderRef; ParentScope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; const ConfigMacros: PUTF8Char; ConfigMacrosLen: NativeUInt; const IncludePath: PUTF8Char; IncludePathLen: NativeUInt; const APINotesFile: PUTF8Char; APINotesFileLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateModule';

(**
 * Creates a new descriptor for a namespace with the specified parent scope.
 * \param Builder          The \c DIBuilder.
 * \param ParentScope      The parent scope containing this module declaration.
 * \param Name             NameSpace name.
 * \param NameLen          The length of the C string passed to \c Name.
 * \param ExportSymbols    Whether or not the namespace exports symbols, e.g.
 *                         this is true of C++ inline namespaces.
 *)
function LLVMDIBuilderCreateNameSpace(Builder: LLVMDIBuilderRef; ParentScope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; ExportSymbols: LLVMBool): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateNameSpace';

(**
 * Create a new descriptor for the specified subprogram.
 * \param Builder         The \c DIBuilder.
 * \param Scope           Function scope.
 * \param Name            Function name.
 * \param NameLen         Length of enumeration name.
 * \param LinkageName     Mangled function name.
 * \param LinkageNameLen  Length of linkage name.
 * \param File            File where this variable is defined.
 * \param LineNo          Line number.
 * \param Ty              Function type.
 * \param IsLocalToUnit   True if this function is not externally visible.
 * \param IsDefinition    True if this is a function definition.
 * \param ScopeLine       Set to the beginning of the scope this starts
 * \param Flags           E.g.: \c LLVMDIFlagLValueReference. These flags are
 *                        used to emit dwarf attributes.
 * \param IsOptimized     True if optimization is ON.
 *)
function LLVMDIBuilderCreateFunction(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; const LinkageName: PUTF8Char; LinkageNameLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; Ty: LLVMMetadataRef; IsLocalToUnit: LLVMBool; IsDefinition: LLVMBool; ScopeLine: Cardinal; Flags: LLVMDIFlags; IsOptimized: LLVMBool): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateFunction';

(**
 * Create a descriptor for a lexical block with the specified parent context.
 * \param Builder      The \c DIBuilder.
 * \param Scope        Parent lexical block.
 * \param File         Source file.
 * \param Line         The line in the source file.
 * \param Column       The column in the source file.
 *)
function LLVMDIBuilderCreateLexicalBlock(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; File_: LLVMMetadataRef; Line: Cardinal; Column: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateLexicalBlock';

(**
 * Create a descriptor for a lexical block with a new file attached.
 * \param Builder        The \c DIBuilder.
 * \param Scope          Lexical block.
 * \param File           Source file.
 * \param Discriminator  DWARF path discriminator value.
 *)
function LLVMDIBuilderCreateLexicalBlockFile(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; File_: LLVMMetadataRef; Discriminator: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateLexicalBlockFile';

(**
 * Create a descriptor for an imported namespace. Suitable for e.g. C++
 * using declarations.
 * \param Builder    The \c DIBuilder.
 * \param Scope      The scope this module is imported into
 * \param File       File where the declaration is located.
 * \param Line       Line number of the declaration.
 *)
function LLVMDIBuilderCreateImportedModuleFromNamespace(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; NS: LLVMMetadataRef; File_: LLVMMetadataRef; Line: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateImportedModuleFromNamespace';

(**
 * Create a descriptor for an imported module that aliases another
 * imported entity descriptor.
 * \param Builder        The \c DIBuilder.
 * \param Scope          The scope this module is imported into
 * \param ImportedEntity Previous imported entity to alias.
 * \param File           File where the declaration is located.
 * \param Line           Line number of the declaration.
 * \param Elements       Renamed elements.
 * \param NumElements    Number of renamed elements.
 *)
function LLVMDIBuilderCreateImportedModuleFromAlias(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; ImportedEntity: LLVMMetadataRef; File_: LLVMMetadataRef; Line: Cardinal; Elements: PLLVMMetadataRef; NumElements: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateImportedModuleFromAlias';

(**
 * Create a descriptor for an imported module.
 * \param Builder        The \c DIBuilder.
 * \param Scope          The scope this module is imported into
 * \param M              The module being imported here
 * \param File           File where the declaration is located.
 * \param Line           Line number of the declaration.
 * \param Elements       Renamed elements.
 * \param NumElements    Number of renamed elements.
 *)
function LLVMDIBuilderCreateImportedModuleFromModule(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; M: LLVMMetadataRef; File_: LLVMMetadataRef; Line: Cardinal; Elements: PLLVMMetadataRef; NumElements: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateImportedModuleFromModule';

(**
 * Create a descriptor for an imported function, type, or variable.  Suitable
 * for e.g. FORTRAN-style USE declarations.
 * \param Builder        The DIBuilder.
 * \param Scope          The scope this module is imported into.
 * \param Decl           The declaration (or definition) of a function, type,
                         or variable.
 * \param File           File where the declaration is located.
 * \param Line           Line number of the declaration.
 * \param Name           A name that uniquely identifies this imported
 declaration.
 * \param NameLen        The length of the C string passed to \c Name.
 * \param Elements       Renamed elements.
 * \param NumElements    Number of renamed elements.
 *)
function LLVMDIBuilderCreateImportedDeclaration(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; Decl: LLVMMetadataRef; File_: LLVMMetadataRef; Line: Cardinal; const Name: PUTF8Char; NameLen: NativeUInt; Elements: PLLVMMetadataRef; NumElements: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateImportedDeclaration';

(**
 * Creates a new DebugLocation that describes a source location.
 * \param Line The line in the source file.
 * \param Column The column in the source file.
 * \param Scope The scope in which the location resides.
 * \param InlinedAt The scope where this location was inlined, if at all.
 *                  (optional).
 * \note If the item to which this location is attached cannot be
 *       attributed to a source line, pass 0 for the line and column.
 *)
function LLVMDIBuilderCreateDebugLocation(Ctx: LLVMContextRef; Line: Cardinal; Column: Cardinal; Scope: LLVMMetadataRef; InlinedAt: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateDebugLocation';

(**
 * Get the line number of this debug location.
 * \param Location     The debug location.
 *
 * @see DILocation::getLine()
 *)
function LLVMDILocationGetLine(Location: LLVMMetadataRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMDILocationGetLine';

(**
 * Get the column number of this debug location.
 * \param Location     The debug location.
 *
 * @see DILocation::getColumn()
 *)
function LLVMDILocationGetColumn(Location: LLVMMetadataRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMDILocationGetColumn';

(**
 * Get the local scope associated with this debug location.
 * \param Location     The debug location.
 *
 * @see DILocation::getScope()
 *)
function LLVMDILocationGetScope(Location: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDILocationGetScope';

(**
 * Get the "inline at" location associated with this debug location.
 * \param Location     The debug location.
 *
 * @see DILocation::getInlinedAt()
 *)
function LLVMDILocationGetInlinedAt(Location: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDILocationGetInlinedAt';

(**
 * Get the metadata of the file associated with a given scope.
 * \param Scope     The scope object.
 *
 * @see DIScope::getFile()
 *)
function LLVMDIScopeGetFile(Scope: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIScopeGetFile';

(**
 * Get the directory of a given file.
 * \param File     The file object.
 * \param Len      The length of the returned string.
 *
 * @see DIFile::getDirectory()
 *)
function LLVMDIFileGetDirectory(File_: LLVMMetadataRef; Len: PCardinal): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIFileGetDirectory';

(**
 * Get the name of a given file.
 * \param File     The file object.
 * \param Len      The length of the returned string.
 *
 * @see DIFile::getFilename()
 *)
function LLVMDIFileGetFilename(File_: LLVMMetadataRef; Len: PCardinal): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIFileGetFilename';

(**
 * Get the source of a given file.
 * \param File     The file object.
 * \param Len      The length of the returned string.
 *
 * @see DIFile::getSource()
 *)
function LLVMDIFileGetSource(File_: LLVMMetadataRef; Len: PCardinal): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIFileGetSource';

(**
 * Create a type array.
 * \param Builder        The DIBuilder.
 * \param Data           The type elements.
 * \param NumElements    Number of type elements.
 *)
function LLVMDIBuilderGetOrCreateTypeArray(Builder: LLVMDIBuilderRef; Data: PLLVMMetadataRef; NumElements: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderGetOrCreateTypeArray';

(**
 * Create subroutine type.
 * \param Builder        The DIBuilder.
 * \param File            The file in which the subroutine resides.
 * \param ParameterTypes  An array of subroutine parameter types. This
 *                        includes return type at 0th index.
 * \param NumParameterTypes The number of parameter types in \c ParameterTypes
 * \param Flags           E.g.: \c LLVMDIFlagLValueReference.
 *                        These flags are used to emit dwarf attributes.
 *)
function LLVMDIBuilderCreateSubroutineType(Builder: LLVMDIBuilderRef; File_: LLVMMetadataRef; ParameterTypes: PLLVMMetadataRef; NumParameterTypes: Cardinal; Flags: LLVMDIFlags): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateSubroutineType';

(**
 * Create debugging information entry for a macro.
 * @param Builder         The DIBuilder.
 * @param ParentMacroFile Macro parent (could be NULL).
 * @param Line            Source line number where the macro is defined.
 * @param RecordType      DW_MACINFO_define or DW_MACINFO_undef.
 * @param Name            Macro name.
 * @param NameLen         Macro name length.
 * @param Value           Macro value.
 * @param ValueLen        Macro value length.
 *)
function LLVMDIBuilderCreateMacro(Builder: LLVMDIBuilderRef; ParentMacroFile: LLVMMetadataRef; Line: Cardinal; RecordType: LLVMDWARFMacinfoRecordType; const Name: PUTF8Char; NameLen: NativeUInt; const Value: PUTF8Char; ValueLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateMacro';

(**
 * Create debugging information temporary entry for a macro file.
 * List of macro node direct children will be calculated by DIBuilder,
 * using the \p ParentMacroFile relationship.
 * @param Builder         The DIBuilder.
 * @param ParentMacroFile Macro parent (could be NULL).
 * @param Line            Source line number where the macro file is included.
 * @param File            File descriptor containing the name of the macro file.
 *)
function LLVMDIBuilderCreateTempMacroFile(Builder: LLVMDIBuilderRef; ParentMacroFile: LLVMMetadataRef; Line: Cardinal; File_: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateTempMacroFile';

(**
 * Create debugging information entry for an enumerator.
 * @param Builder        The DIBuilder.
 * @param Name           Enumerator name.
 * @param NameLen        Length of enumerator name.
 * @param Value          Enumerator value.
 * @param IsUnsigned     True if the value is unsigned.
 *)
function LLVMDIBuilderCreateEnumerator(Builder: LLVMDIBuilderRef; const Name: PUTF8Char; NameLen: NativeUInt; Value: Int64; IsUnsigned: LLVMBool): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateEnumerator';

(**
 * Create debugging information entry for an enumerator of arbitrary precision.
 * @param Builder        The DIBuilder.
 * @param Name           Enumerator name.
 * @param NameLen        Length of enumerator name.
 * @param SizeInBits     Number of bits of the value.
 * @param Words          The words that make up the value.
 * @param IsUnsigned     True if the value is unsigned.
 *)
function LLVMDIBuilderCreateEnumeratorOfArbitraryPrecision(Builder: LLVMDIBuilderRef; const Name: PUTF8Char; NameLen: NativeUInt; SizeInBits: UInt64; Words: PUInt64; IsUnsigned: LLVMBool): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateEnumeratorOfArbitraryPrecision';

(**
 * Create debugging information entry for an enumeration.
 * \param Builder        The DIBuilder.
 * \param Scope          Scope in which this enumeration is defined.
 * \param Name           Enumeration name.
 * \param NameLen        Length of enumeration name.
 * \param File           File where this member is defined.
 * \param LineNumber     Line number.
 * \param SizeInBits     Member size.
 * \param AlignInBits    Member alignment.
 * \param Elements       Enumeration elements.
 * \param NumElements    Number of enumeration elements.
 * \param ClassTy        Underlying type of a C++11/ObjC fixed enum.
 *)
function LLVMDIBuilderCreateEnumerationType(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNumber: Cardinal; SizeInBits: UInt64; AlignInBits: UInt32; Elements: PLLVMMetadataRef; NumElements: Cardinal; ClassTy: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateEnumerationType';

(**
 * Create debugging information entry for a union.
 * \param Builder      The DIBuilder.
 * \param Scope        Scope in which this union is defined.
 * \param Name         Union name.
 * \param NameLen      Length of union name.
 * \param File         File where this member is defined.
 * \param LineNumber   Line number.
 * \param SizeInBits   Member size.
 * \param AlignInBits  Member alignment.
 * \param Flags        Flags to encode member attribute, e.g. private
 * \param Elements     Union elements.
 * \param NumElements  Number of union elements.
 * \param RunTimeLang  Optional parameter, Objective-C runtime version.
 * \param UniqueId     A unique identifier for the union.
 * \param UniqueIdLen  Length of unique identifier.
 *)
function LLVMDIBuilderCreateUnionType(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNumber: Cardinal; SizeInBits: UInt64; AlignInBits: UInt32; Flags: LLVMDIFlags; Elements: PLLVMMetadataRef; NumElements: Cardinal; RunTimeLang: Cardinal; const UniqueId: PUTF8Char; UniqueIdLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateUnionType';

(**
 * Create debugging information entry for an array.
 * \param Builder      The DIBuilder.
 * \param Size         Array size.
 * \param AlignInBits  Alignment.
 * \param Ty           Element type.
 * \param Subscripts   Subscripts.
 * \param NumSubscripts Number of subscripts.
 *)
function LLVMDIBuilderCreateArrayType(Builder: LLVMDIBuilderRef; Size: UInt64; AlignInBits: UInt32; Ty: LLVMMetadataRef; Subscripts: PLLVMMetadataRef; NumSubscripts: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateArrayType';

(**
 * Create debugging information entry for a vector type.
 * \param Builder      The DIBuilder.
 * \param Size         Vector size.
 * \param AlignInBits  Alignment.
 * \param Ty           Element type.
 * \param Subscripts   Subscripts.
 * \param NumSubscripts Number of subscripts.
 *)
function LLVMDIBuilderCreateVectorType(Builder: LLVMDIBuilderRef; Size: UInt64; AlignInBits: UInt32; Ty: LLVMMetadataRef; Subscripts: PLLVMMetadataRef; NumSubscripts: Cardinal): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateVectorType';

(**
 * Create a DWARF unspecified type.
 * \param Builder   The DIBuilder.
 * \param Name      The unspecified type's name.
 * \param NameLen   Length of type name.
 *)
function LLVMDIBuilderCreateUnspecifiedType(Builder: LLVMDIBuilderRef; const Name: PUTF8Char; NameLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateUnspecifiedType';

(**
 * Create debugging information entry for a basic
 * type.
 * \param Builder     The DIBuilder.
 * \param Name        Type name.
 * \param NameLen     Length of type name.
 * \param SizeInBits  Size of the type.
 * \param Encoding    DWARF encoding code, e.g. \c LLVMDWARFTypeEncoding_float.
 * \param Flags       Flags to encode optional attribute like endianity
 *)
function LLVMDIBuilderCreateBasicType(Builder: LLVMDIBuilderRef; const Name: PUTF8Char; NameLen: NativeUInt; SizeInBits: UInt64; Encoding: LLVMDWARFTypeEncoding; Flags: LLVMDIFlags): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateBasicType';

(**
 * Create debugging information entry for a pointer.
 * \param Builder     The DIBuilder.
 * \param PointeeTy         Type pointed by this pointer.
 * \param SizeInBits        Size.
 * \param AlignInBits       Alignment. (optional, pass 0 to ignore)
 * \param AddressSpace      DWARF address space. (optional, pass 0 to ignore)
 * \param Name              Pointer type name. (optional)
 * \param NameLen           Length of pointer type name. (optional)
 *)
function LLVMDIBuilderCreatePointerType(Builder: LLVMDIBuilderRef; PointeeTy: LLVMMetadataRef; SizeInBits: UInt64; AlignInBits: UInt32; AddressSpace: Cardinal; const Name: PUTF8Char; NameLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreatePointerType';

(**
 * Create debugging information entry for a struct.
 * \param Builder     The DIBuilder.
 * \param Scope        Scope in which this struct is defined.
 * \param Name         Struct name.
 * \param NameLen      Struct name length.
 * \param File         File where this member is defined.
 * \param LineNumber   Line number.
 * \param SizeInBits   Member size.
 * \param AlignInBits  Member alignment.
 * \param Flags        Flags to encode member attribute, e.g. private
 * \param Elements     Struct elements.
 * \param NumElements  Number of struct elements.
 * \param RunTimeLang  Optional parameter, Objective-C runtime version.
 * \param VTableHolder The object containing the vtable for the struct.
 * \param UniqueId     A unique identifier for the struct.
 * \param UniqueIdLen  Length of the unique identifier for the struct.
 *)
function LLVMDIBuilderCreateStructType(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNumber: Cardinal; SizeInBits: UInt64; AlignInBits: UInt32; Flags: LLVMDIFlags; DerivedFrom: LLVMMetadataRef; Elements: PLLVMMetadataRef; NumElements: Cardinal; RunTimeLang: Cardinal; VTableHolder: LLVMMetadataRef; const UniqueId: PUTF8Char; UniqueIdLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateStructType';

(**
 * Create debugging information entry for a member.
 * \param Builder      The DIBuilder.
 * \param Scope        Member scope.
 * \param Name         Member name.
 * \param NameLen      Length of member name.
 * \param File         File where this member is defined.
 * \param LineNo       Line number.
 * \param SizeInBits   Member size.
 * \param AlignInBits  Member alignment.
 * \param OffsetInBits Member offset.
 * \param Flags        Flags to encode member attribute, e.g. private
 * \param Ty           Parent type.
 *)
function LLVMDIBuilderCreateMemberType(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; SizeInBits: UInt64; AlignInBits: UInt32; OffsetInBits: UInt64; Flags: LLVMDIFlags; Ty: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateMemberType';

(**
 * Create debugging information entry for a
 * C++ static data member.
 * \param Builder      The DIBuilder.
 * \param Scope        Member scope.
 * \param Name         Member name.
 * \param NameLen      Length of member name.
 * \param File         File where this member is declared.
 * \param LineNumber   Line number.
 * \param Type         Type of the static member.
 * \param Flags        Flags to encode member attribute, e.g. private.
 * \param ConstantVal  Const initializer of the member.
 * \param AlignInBits  Member alignment.
 *)
function LLVMDIBuilderCreateStaticMemberType(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNumber: Cardinal; Type_: LLVMMetadataRef; Flags: LLVMDIFlags; ConstantVal: LLVMValueRef; AlignInBits: UInt32): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateStaticMemberType';

(**
 * Create debugging information entry for a pointer to member.
 * \param Builder      The DIBuilder.
 * \param PointeeType  Type pointed to by this pointer.
 * \param ClassType    Type for which this pointer points to members of.
 * \param SizeInBits   Size.
 * \param AlignInBits  Alignment.
 * \param Flags        Flags.
 *)
function LLVMDIBuilderCreateMemberPointerType(Builder: LLVMDIBuilderRef; PointeeType: LLVMMetadataRef; ClassType: LLVMMetadataRef; SizeInBits: UInt64; AlignInBits: UInt32; Flags: LLVMDIFlags): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateMemberPointerType';

(**
 * Create debugging information entry for Objective-C instance variable.
 * \param Builder      The DIBuilder.
 * \param Name         Member name.
 * \param NameLen      The length of the C string passed to \c Name.
 * \param File         File where this member is defined.
 * \param LineNo       Line number.
 * \param SizeInBits   Member size.
 * \param AlignInBits  Member alignment.
 * \param OffsetInBits Member offset.
 * \param Flags        Flags to encode member attribute, e.g. private
 * \param Ty           Parent type.
 * \param PropertyNode Property associated with this ivar.
 *)
function LLVMDIBuilderCreateObjCIVar(Builder: LLVMDIBuilderRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; SizeInBits: UInt64; AlignInBits: UInt32; OffsetInBits: UInt64; Flags: LLVMDIFlags; Ty: LLVMMetadataRef; PropertyNode: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateObjCIVar';

(**
 * Create debugging information entry for Objective-C property.
 * \param Builder            The DIBuilder.
 * \param Name               Property name.
 * \param NameLen            The length of the C string passed to \c Name.
 * \param File               File where this property is defined.
 * \param LineNo             Line number.
 * \param GetterName         Name of the Objective C property getter selector.
 * \param GetterNameLen      The length of the C string passed to \c GetterName.
 * \param SetterName         Name of the Objective C property setter selector.
 * \param SetterNameLen      The length of the C string passed to \c SetterName.
 * \param PropertyAttributes Objective C property attributes.
 * \param Ty                 Type.
 *)
function LLVMDIBuilderCreateObjCProperty(Builder: LLVMDIBuilderRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; const GetterName: PUTF8Char; GetterNameLen: NativeUInt; const SetterName: PUTF8Char; SetterNameLen: NativeUInt; PropertyAttributes: Cardinal; Ty: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateObjCProperty';

(**
 * Create a uniqued DIType* clone with FlagObjectPointer. If \c Implicit
 * is true, then also set FlagArtificial.
 * \param Builder   The DIBuilder.
 * \param Type      The underlying type to which this pointer points.
 * \param Implicit  Indicates whether this pointer was implicitly generated
 *                  (i.e., not spelled out in source).
 *)
function LLVMDIBuilderCreateObjectPointerType(Builder: LLVMDIBuilderRef; Type_: LLVMMetadataRef; Implicit: LLVMBool): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateObjectPointerType';

(**
 * Create debugging information entry for a qualified
 * type, e.g. 'const int'.
 * \param Builder     The DIBuilder.
 * \param Tag         Tag identifying type,
 *                    e.g. LLVMDWARFTypeQualifier_volatile_type
 * \param Type        Base Type.
 *)
function LLVMDIBuilderCreateQualifiedType(Builder: LLVMDIBuilderRef; Tag: Cardinal; Type_: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateQualifiedType';

(**
 * Create debugging information entry for a c++
 * style reference or rvalue reference type.
 * \param Builder   The DIBuilder.
 * \param Tag       Tag identifying type,
 * \param Type      Base Type.
 *)
function LLVMDIBuilderCreateReferenceType(Builder: LLVMDIBuilderRef; Tag: Cardinal; Type_: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateReferenceType';

(**
 * Create C++11 nullptr type.
 * \param Builder   The DIBuilder.
 *)
function LLVMDIBuilderCreateNullPtrType(Builder: LLVMDIBuilderRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateNullPtrType';

(**
 * Create debugging information entry for a typedef.
 * \param Builder    The DIBuilder.
 * \param Type       Original type.
 * \param Name       Typedef name.
 * \param File       File where this type is defined.
 * \param LineNo     Line number.
 * \param Scope      The surrounding context for the typedef.
 *)
function LLVMDIBuilderCreateTypedef(Builder: LLVMDIBuilderRef; Type_: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; Scope: LLVMMetadataRef; AlignInBits: UInt32): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateTypedef';

(**
 * Create debugging information entry to establish inheritance relationship
 * between two types.
 * \param Builder       The DIBuilder.
 * \param Ty            Original type.
 * \param BaseTy        Base type. Ty is inherits from base.
 * \param BaseOffset    Base offset.
 * \param VBPtrOffset  Virtual base pointer offset.
 * \param Flags         Flags to describe inheritance attribute, e.g. private
 *)
function LLVMDIBuilderCreateInheritance(Builder: LLVMDIBuilderRef; Ty: LLVMMetadataRef; BaseTy: LLVMMetadataRef; BaseOffset: UInt64; VBPtrOffset: UInt32; Flags: LLVMDIFlags): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateInheritance';

(**
 * Create a permanent forward-declared type.
 * \param Builder             The DIBuilder.
 * \param Tag                 A unique tag for this type.
 * \param Name                Type name.
 * \param NameLen             Length of type name.
 * \param Scope               Type scope.
 * \param File                File where this type is defined.
 * \param Line                Line number where this type is defined.
 * \param RuntimeLang         Indicates runtime version for languages like
 *                            Objective-C.
 * \param SizeInBits          Member size.
 * \param AlignInBits         Member alignment.
 * \param UniqueIdentifier    A unique identifier for the type.
 * \param UniqueIdentifierLen Length of the unique identifier.
 *)
function LLVMDIBuilderCreateForwardDecl(Builder: LLVMDIBuilderRef; Tag: Cardinal; const Name: PUTF8Char; NameLen: NativeUInt; Scope: LLVMMetadataRef; File_: LLVMMetadataRef; Line: Cardinal; RuntimeLang: Cardinal; SizeInBits: UInt64; AlignInBits: UInt32; const UniqueIdentifier: PUTF8Char; UniqueIdentifierLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateForwardDecl';

(**
 * Create a temporary forward-declared type.
 * \param Builder             The DIBuilder.
 * \param Tag                 A unique tag for this type.
 * \param Name                Type name.
 * \param NameLen             Length of type name.
 * \param Scope               Type scope.
 * \param File                File where this type is defined.
 * \param Line                Line number where this type is defined.
 * \param RuntimeLang         Indicates runtime version for languages like
 *                            Objective-C.
 * \param SizeInBits          Member size.
 * \param AlignInBits         Member alignment.
 * \param Flags               Flags.
 * \param UniqueIdentifier    A unique identifier for the type.
 * \param UniqueIdentifierLen Length of the unique identifier.
 *)
function LLVMDIBuilderCreateReplaceableCompositeType(Builder: LLVMDIBuilderRef; Tag: Cardinal; const Name: PUTF8Char; NameLen: NativeUInt; Scope: LLVMMetadataRef; File_: LLVMMetadataRef; Line: Cardinal; RuntimeLang: Cardinal; SizeInBits: UInt64; AlignInBits: UInt32; Flags: LLVMDIFlags; const UniqueIdentifier: PUTF8Char; UniqueIdentifierLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateReplaceableCompositeType';

(**
 * Create debugging information entry for a bit field member.
 * \param Builder             The DIBuilder.
 * \param Scope               Member scope.
 * \param Name                Member name.
 * \param NameLen             Length of member name.
 * \param File                File where this member is defined.
 * \param LineNumber          Line number.
 * \param SizeInBits          Member size.
 * \param OffsetInBits        Member offset.
 * \param StorageOffsetInBits Member storage offset.
 * \param Flags               Flags to encode member attribute.
 * \param Type                Parent type.
 *)
function LLVMDIBuilderCreateBitFieldMemberType(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNumber: Cardinal; SizeInBits: UInt64; OffsetInBits: UInt64; StorageOffsetInBits: UInt64; Flags: LLVMDIFlags; Type_: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateBitFieldMemberType';

(**
 * Create debugging information entry for a class.
 * \param Scope               Scope in which this class is defined.
 * \param Name                Class name.
 * \param NameLen             The length of the C string passed to \c Name.
 * \param File                File where this member is defined.
 * \param LineNumber          Line number.
 * \param SizeInBits          Member size.
 * \param AlignInBits         Member alignment.
 * \param OffsetInBits        Member offset.
 * \param Flags               Flags to encode member attribute, e.g. private.
 * \param DerivedFrom         Debug info of the base class of this type.
 * \param Elements            Class members.
 * \param NumElements         Number of class elements.
 * \param VTableHolder        Debug info of the base class that contains vtable
 *                            for this type. This is used in
 *                            DW_AT_containing_type. See DWARF documentation
 *                            for more info.
 * \param TemplateParamsNode  Template type parameters.
 * \param UniqueIdentifier    A unique identifier for the type.
 * \param UniqueIdentifierLen Length of the unique identifier.
 *)
function LLVMDIBuilderCreateClassType(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNumber: Cardinal; SizeInBits: UInt64; AlignInBits: UInt32; OffsetInBits: UInt64; Flags: LLVMDIFlags; DerivedFrom: LLVMMetadataRef; Elements: PLLVMMetadataRef; NumElements: Cardinal; VTableHolder: LLVMMetadataRef; TemplateParamsNode: LLVMMetadataRef; const UniqueIdentifier: PUTF8Char; UniqueIdentifierLen: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateClassType';

(**
 * Create a uniqued DIType* clone with FlagArtificial set.
 * \param Builder     The DIBuilder.
 * \param Type        The underlying type.
 *)
function LLVMDIBuilderCreateArtificialType(Builder: LLVMDIBuilderRef; Type_: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateArtificialType';

(**
 * Get the name of this DIType.
 * \param DType     The DIType.
 * \param Length    The length of the returned string.
 *
 * @see DIType::getName()
 *)
function LLVMDITypeGetName(DType: LLVMMetadataRef; Length: PNativeUInt): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMDITypeGetName';

(**
 * Get the size of this DIType in bits.
 * \param DType     The DIType.
 *
 * @see DIType::getSizeInBits()
 *)
function LLVMDITypeGetSizeInBits(DType: LLVMMetadataRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMDITypeGetSizeInBits';

(**
 * Get the offset of this DIType in bits.
 * \param DType     The DIType.
 *
 * @see DIType::getOffsetInBits()
 *)
function LLVMDITypeGetOffsetInBits(DType: LLVMMetadataRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMDITypeGetOffsetInBits';

(**
 * Get the alignment of this DIType in bits.
 * \param DType     The DIType.
 *
 * @see DIType::getAlignInBits()
 *)
function LLVMDITypeGetAlignInBits(DType: LLVMMetadataRef): UInt32; cdecl;
  external LLVM_DLL name _PU + 'LLVMDITypeGetAlignInBits';

(**
 * Get the source line where this DIType is declared.
 * \param DType     The DIType.
 *
 * @see DIType::getLine()
 *)
function LLVMDITypeGetLine(DType: LLVMMetadataRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMDITypeGetLine';

(**
 * Get the flags associated with this DIType.
 * \param DType     The DIType.
 *
 * @see DIType::getFlags()
 *)
function LLVMDITypeGetFlags(DType: LLVMMetadataRef): LLVMDIFlags; cdecl;
  external LLVM_DLL name _PU + 'LLVMDITypeGetFlags';

(**
 * Create a descriptor for a value range.
 * \param Builder    The DIBuilder.
 * \param LowerBound Lower bound of the subrange, e.g. 0 for C, 1 for Fortran.
 * \param Count      Count of elements in the subrange.
 *)
function LLVMDIBuilderGetOrCreateSubrange(Builder: LLVMDIBuilderRef; LowerBound: Int64; Count: Int64): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderGetOrCreateSubrange';

(**
 * Create an array of DI Nodes.
 * \param Builder        The DIBuilder.
 * \param Data           The DI Node elements.
 * \param NumElements    Number of DI Node elements.
 *)
function LLVMDIBuilderGetOrCreateArray(Builder: LLVMDIBuilderRef; Data: PLLVMMetadataRef; NumElements: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderGetOrCreateArray';

(**
 * Create a new descriptor for the specified variable which has a complex
 * address expression for its address.
 * \param Builder     The DIBuilder.
 * \param Addr        An array of complex address operations.
 * \param Length      Length of the address operation array.
 *)
function LLVMDIBuilderCreateExpression(Builder: LLVMDIBuilderRef; Addr: PUInt64; Length: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateExpression';

(**
 * Create a new descriptor for the specified variable that does not have an
 * address, but does have a constant value.
 * \param Builder     The DIBuilder.
 * \param Value       The constant value.
 *)
function LLVMDIBuilderCreateConstantValueExpression(Builder: LLVMDIBuilderRef; Value: UInt64): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateConstantValueExpression';

(**
 * Create a new descriptor for the specified variable.
 * \param Scope       Variable scope.
 * \param Name        Name of the variable.
 * \param NameLen     The length of the C string passed to \c Name.
 * \param Linkage     Mangled  name of the variable.
 * \param LinkLen     The length of the C string passed to \c Linkage.
 * \param File        File where this variable is defined.
 * \param LineNo      Line number.
 * \param Ty          Variable Type.
 * \param LocalToUnit Boolean flag indicate whether this variable is
 *                    externally visible or not.
 * \param Expr        The location of the global relative to the attached
 *                    GlobalVariable.
 * \param Decl        Reference to the corresponding declaration.
 *                    variables.
 * \param AlignInBits Variable alignment(or 0 if no alignment attr was
 *                    specified)
 *)
function LLVMDIBuilderCreateGlobalVariableExpression(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; const Linkage: PUTF8Char; LinkLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; Ty: LLVMMetadataRef; LocalToUnit: LLVMBool; Expr: LLVMMetadataRef; Decl: LLVMMetadataRef; AlignInBits: UInt32): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateGlobalVariableExpression';

(**
 * Get the dwarf::Tag of a DINode
 *)
function LLVMGetDINodeTag(MD: LLVMMetadataRef): UInt16; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetDINodeTag';

(**
 * Retrieves the \c DIVariable associated with this global variable expression.
 * \param GVE    The global variable expression.
 *
 * @see llvm::DIGlobalVariableExpression::getVariable()
 *)
function LLVMDIGlobalVariableExpressionGetVariable(GVE: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIGlobalVariableExpressionGetVariable';

(**
 * Retrieves the \c DIExpression associated with this global variable expression.
 * \param GVE    The global variable expression.
 *
 * @see llvm::DIGlobalVariableExpression::getExpression()
 *)
function LLVMDIGlobalVariableExpressionGetExpression(GVE: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIGlobalVariableExpressionGetExpression';

(**
 * Get the metadata of the file associated with a given variable.
 * \param Var     The variable object.
 *
 * @see DIVariable::getFile()
 *)
function LLVMDIVariableGetFile(Var_: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIVariableGetFile';

(**
 * Get the metadata of the scope associated with a given variable.
 * \param Var     The variable object.
 *
 * @see DIVariable::getScope()
 *)
function LLVMDIVariableGetScope(Var_: LLVMMetadataRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIVariableGetScope';

(**
 * Get the source line where this \c DIVariable is declared.
 * \param Var     The DIVariable.
 *
 * @see DIVariable::getLine()
 *)
function LLVMDIVariableGetLine(Var_: LLVMMetadataRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIVariableGetLine';

(**
 * Create a new temporary \c MDNode.  Suitable for use in constructing cyclic
 * \c MDNode structures. A temporary \c MDNode is not uniqued, may be RAUW'd,
 * and must be manually deleted with \c LLVMDisposeTemporaryMDNode.
 * \param Ctx            The context in which to construct the temporary node.
 * \param Data           The metadata elements.
 * \param NumElements    Number of metadata elements.
 *)
function LLVMTemporaryMDNode(Ctx: LLVMContextRef; Data: PLLVMMetadataRef; NumElements: NativeUInt): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMTemporaryMDNode';

(**
 * Deallocate a temporary node.
 *
 * Calls \c replaceAllUsesWith(nullptr) before deleting, so any remaining
 * references will be reset.
 * \param TempNode    The temporary metadata node.
 *)
procedure LLVMDisposeTemporaryMDNode(TempNode: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeTemporaryMDNode';

(**
 * Replace all uses of temporary metadata.
 * \param TempTargetMetadata    The temporary metadata node.
 * \param Replacement           The replacement metadata node.
 *)
procedure LLVMMetadataReplaceAllUsesWith(TempTargetMetadata: LLVMMetadataRef; Replacement: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMMetadataReplaceAllUsesWith';

(**
 * Create a new descriptor for the specified global variable that is temporary
 * and meant to be RAUWed.
 * \param Scope       Variable scope.
 * \param Name        Name of the variable.
 * \param NameLen     The length of the C string passed to \c Name.
 * \param Linkage     Mangled  name of the variable.
 * \param LnkLen      The length of the C string passed to \c Linkage.
 * \param File        File where this variable is defined.
 * \param LineNo      Line number.
 * \param Ty          Variable Type.
 * \param LocalToUnit Boolean flag indicate whether this variable is
 *                    externally visible or not.
 * \param Decl        Reference to the corresponding declaration.
 * \param AlignInBits Variable alignment(or 0 if no alignment attr was
 *                    specified)
 *)
function LLVMDIBuilderCreateTempGlobalVariableFwdDecl(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; const Linkage: PUTF8Char; LnkLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; Ty: LLVMMetadataRef; LocalToUnit: LLVMBool; Decl: LLVMMetadataRef; AlignInBits: UInt32): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateTempGlobalVariableFwdDecl';

(**
 * Only use in "new debug format" (LLVMIsNewDbgInfoFormat() is true).
 * See https://llvm.org/docs/RemoveDIsDebugInfo.html#c-api-changes
 *
 * The debug format can be switched later after inserting the records using
 * LLVMSetIsNewDbgInfoFormat, if needed for legacy or transitionary reasons.
 *
 * Insert a Declare DbgRecord before the given instruction.
 * \param Builder     The DIBuilder.
 * \param Storage     The storage of the variable to declare.
 * \param VarInfo     The variable's debug info descriptor.
 * \param Expr        A complex location expression for the variable.
 * \param DebugLoc    Debug info location.
 * \param Instr       Instruction acting as a location for the new record.
 *)
function LLVMDIBuilderInsertDeclareRecordBefore(Builder: LLVMDIBuilderRef; Storage: LLVMValueRef; VarInfo: LLVMMetadataRef; Expr: LLVMMetadataRef; DebugLoc: LLVMMetadataRef; Instr: LLVMValueRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderInsertDeclareRecordBefore';

(**
 * Only use in "new debug format" (LLVMIsNewDbgInfoFormat() is true).
 * See https://llvm.org/docs/RemoveDIsDebugInfo.html#c-api-changes
 *
 * The debug format can be switched later after inserting the records using
 * LLVMSetIsNewDbgInfoFormat, if needed for legacy or transitionary reasons.
 *
 * Insert a Declare DbgRecord at the end of the given basic block. If the basic
 * block has a terminator instruction, the record is inserted before that
 * terminator instruction.
 * \param Builder     The DIBuilder.
 * \param Storage     The storage of the variable to declare.
 * \param VarInfo     The variable's debug info descriptor.
 * \param Expr        A complex location expression for the variable.
 * \param DebugLoc    Debug info location.
 * \param Block       Basic block acting as a location for the new record.
 *)
function LLVMDIBuilderInsertDeclareRecordAtEnd(Builder: LLVMDIBuilderRef; Storage: LLVMValueRef; VarInfo: LLVMMetadataRef; Expr: LLVMMetadataRef; DebugLoc: LLVMMetadataRef; Block: LLVMBasicBlockRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderInsertDeclareRecordAtEnd';

(**
 * Only use in "new debug format" (LLVMIsNewDbgInfoFormat() is true).
 * See https://llvm.org/docs/RemoveDIsDebugInfo.html#c-api-changes
 *
 * The debug format can be switched later after inserting the records using
 * LLVMSetIsNewDbgInfoFormat, if needed for legacy or transitionary reasons.
 *
 * Insert a new debug record before the given instruction.
 * \param Builder     The DIBuilder.
 * \param Val         The value of the variable.
 * \param VarInfo     The variable's debug info descriptor.
 * \param Expr        A complex location expression for the variable.
 * \param DebugLoc    Debug info location.
 * \param Instr       Instruction acting as a location for the new record.
 *)
function LLVMDIBuilderInsertDbgValueRecordBefore(Builder: LLVMDIBuilderRef; Val: LLVMValueRef; VarInfo: LLVMMetadataRef; Expr: LLVMMetadataRef; DebugLoc: LLVMMetadataRef; Instr: LLVMValueRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderInsertDbgValueRecordBefore';

(**
 * Only use in "new debug format" (LLVMIsNewDbgInfoFormat() is true).
 * See https://llvm.org/docs/RemoveDIsDebugInfo.html#c-api-changes
 *
 * The debug format can be switched later after inserting the records using
 * LLVMSetIsNewDbgInfoFormat, if needed for legacy or transitionary reasons.
 *
 * Insert a new debug record at the end of the given basic block. If the
 * basic block has a terminator instruction, the record is inserted before
 * that terminator instruction.
 * \param Builder     The DIBuilder.
 * \param Val         The value of the variable.
 * \param VarInfo     The variable's debug info descriptor.
 * \param Expr        A complex location expression for the variable.
 * \param DebugLoc    Debug info location.
 * \param Block       Basic block acting as a location for the new record.
 *)
function LLVMDIBuilderInsertDbgValueRecordAtEnd(Builder: LLVMDIBuilderRef; Val: LLVMValueRef; VarInfo: LLVMMetadataRef; Expr: LLVMMetadataRef; DebugLoc: LLVMMetadataRef; Block: LLVMBasicBlockRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderInsertDbgValueRecordAtEnd';

(**
 * Create a new descriptor for a local auto variable.
 * \param Builder         The DIBuilder.
 * \param Scope           The local scope the variable is declared in.
 * \param Name            Variable name.
 * \param NameLen         Length of variable name.
 * \param File            File where this variable is defined.
 * \param LineNo          Line number.
 * \param Ty              Metadata describing the type of the variable.
 * \param AlwaysPreserve  If true, this descriptor will survive optimizations.
 * \param Flags           Flags.
 * \param AlignInBits     Variable alignment.
 *)
function LLVMDIBuilderCreateAutoVariable(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; Ty: LLVMMetadataRef; AlwaysPreserve: LLVMBool; Flags: LLVMDIFlags; AlignInBits: UInt32): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateAutoVariable';

(**
 * Create a new descriptor for a function parameter variable.
 * \param Builder         The DIBuilder.
 * \param Scope           The local scope the variable is declared in.
 * \param Name            Variable name.
 * \param NameLen         Length of variable name.
 * \param ArgNo           Unique argument number for this variable; starts at 1.
 * \param File            File where this variable is defined.
 * \param LineNo          Line number.
 * \param Ty              Metadata describing the type of the variable.
 * \param AlwaysPreserve  If true, this descriptor will survive optimizations.
 * \param Flags           Flags.
 *)
function LLVMDIBuilderCreateParameterVariable(Builder: LLVMDIBuilderRef; Scope: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; ArgNo: Cardinal; File_: LLVMMetadataRef; LineNo: Cardinal; Ty: LLVMMetadataRef; AlwaysPreserve: LLVMBool; Flags: LLVMDIFlags): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateParameterVariable';

(**
 * Get the metadata of the subprogram attached to a function.
 *
 * @see llvm::Function::getSubprogram()
 *)
function LLVMGetSubprogram(Func: LLVMValueRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSubprogram';

(**
 * Set the subprogram attached to a function.
 *
 * @see llvm::Function::setSubprogram()
 *)
procedure LLVMSetSubprogram(Func: LLVMValueRef; SP: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMSetSubprogram';

(**
 * Get the line associated with a given subprogram.
 * \param Subprogram     The subprogram object.
 *
 * @see DISubprogram::getLine()
 *)
function LLVMDISubprogramGetLine(Subprogram: LLVMMetadataRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMDISubprogramGetLine';

(**
 * Replace the subprogram subroutine type.
 * \param Subprogram        The subprogram object.
 * \param SubroutineType    The new subroutine type.
 *
 * @see DISubprogram::replaceType()
 *)
procedure LLVMDISubprogramReplaceType(Subprogram: LLVMMetadataRef; SubroutineType: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDISubprogramReplaceType';

(**
 * Get the debug location for the given instruction.
 *
 * @see llvm::Instruction::getDebugLoc()
 *)
function LLVMInstructionGetDebugLoc(Inst: LLVMValueRef): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMInstructionGetDebugLoc';

(**
 * Set the debug location for the given instruction.
 *
 * To clear the location metadata of the given instruction, pass NULL to \p Loc.
 *
 * @see llvm::Instruction::setDebugLoc()
 *)
procedure LLVMInstructionSetDebugLoc(Inst: LLVMValueRef; Loc: LLVMMetadataRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMInstructionSetDebugLoc';

(**
 * Create a new descriptor for a label
 *
 * \param Builder         The DIBuilder.
 * \param Scope           The scope to create the label in.
 * \param Name            Variable name.
 * \param NameLen         Length of variable name.
 * \param File            The file to create the label in.
 * \param LineNo          Line Number.
 * \param AlwaysPreserve  Preserve the label regardless of optimization.
 *
 * @see llvm::DIBuilder::createLabel()
 *)
function LLVMDIBuilderCreateLabel(Builder: LLVMDIBuilderRef; Context: LLVMMetadataRef; const Name: PUTF8Char; NameLen: NativeUInt; File_: LLVMMetadataRef; LineNo: Cardinal; AlwaysPreserve: LLVMBool): LLVMMetadataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderCreateLabel';

(**
 * Insert a new llvm.dbg.label intrinsic call
 *
 * \param Builder         The DIBuilder.
 * \param LabelInfo       The Label's debug info descriptor
 * \param Location        The debug info location
 * \param InsertBefore    Location for the new intrinsic.
 *
 * @see llvm::DIBuilder::insertLabel()
 *)
function LLVMDIBuilderInsertLabelBefore(Builder: LLVMDIBuilderRef; LabelInfo: LLVMMetadataRef; Location: LLVMMetadataRef; InsertBefore: LLVMValueRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderInsertLabelBefore';

(**
 * Insert a new llvm.dbg.label intrinsic call
 *
 * \param Builder         The DIBuilder.
 * \param LabelInfo       The Label's debug info descriptor
 * \param Location        The debug info location
 * \param InsertAtEnd     Location for the new intrinsic.
 *
 * @see llvm::DIBuilder::insertLabel()
 *)
function LLVMDIBuilderInsertLabelAtEnd(Builder: LLVMDIBuilderRef; LabelInfo: LLVMMetadataRef; Location: LLVMMetadataRef; InsertAtEnd: LLVMBasicBlockRef): LLVMDbgRecordRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMDIBuilderInsertLabelAtEnd';

(**
 * Obtain the enumerated type of a Metadata instance.
 *
 * @see llvm::Metadata::getMetadataID()
 *)
function LLVMGetMetadataKind(Metadata: LLVMMetadataRef): LLVMMetadataKind; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetMetadataKind';

(**
 * Create a disassembler for the TripleName.  Symbolic disassembly is supported
 * by passing a block of information in the DisInfo parameter and specifying the
 * TagType and callback functions as described above.  These can all be passed
 * as NULL.  If successful, this returns a disassembler context.  If not, it
 * returns NULL. This function is equivalent to calling
 * LLVMCreateDisasmCPUFeatures() with an empty CPU name and feature set.
 *)
function LLVMCreateDisasm(const TripleName: PUTF8Char; DisInfo: Pointer; TagType: Integer; GetOpInfo: LLVMOpInfoCallback; SymbolLookUp: LLVMSymbolLookupCallback): LLVMDisasmContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateDisasm';

(**
 * Create a disassembler for the TripleName and a specific CPU.  Symbolic
 * disassembly is supported by passing a block of information in the DisInfo
 * parameter and specifying the TagType and callback functions as described
 * above.  These can all be passed * as NULL.  If successful, this returns a
 * disassembler context.  If not, it returns NULL. This function is equivalent
 * to calling LLVMCreateDisasmCPUFeatures() with an empty feature set.
 *)
function LLVMCreateDisasmCPU(const Triple: PUTF8Char; const CPU: PUTF8Char; DisInfo: Pointer; TagType: Integer; GetOpInfo: LLVMOpInfoCallback; SymbolLookUp: LLVMSymbolLookupCallback): LLVMDisasmContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateDisasmCPU';

(**
 * Create a disassembler for the TripleName, a specific CPU and specific feature
 * string.  Symbolic disassembly is supported by passing a block of information
 * in the DisInfo parameter and specifying the TagType and callback functions as
 * described above.  These can all be passed * as NULL.  If successful, this
 * returns a disassembler context.  If not, it returns NULL.
 *)
function LLVMCreateDisasmCPUFeatures(const Triple: PUTF8Char; const CPU: PUTF8Char; const Features: PUTF8Char; DisInfo: Pointer; TagType: Integer; GetOpInfo: LLVMOpInfoCallback; SymbolLookUp: LLVMSymbolLookupCallback): LLVMDisasmContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateDisasmCPUFeatures';

(**
 * Set the disassembler's options.  Returns 1 if it can set the Options and 0
 * otherwise.
 *)
function LLVMSetDisasmOptions(DC: LLVMDisasmContextRef; Options: UInt64): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMSetDisasmOptions';

(**
 * Dispose of a disassembler context.
 *)
procedure LLVMDisasmDispose(DC: LLVMDisasmContextRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisasmDispose';

(**
 * Disassemble a single instruction using the disassembler context specified in
 * the parameter DC.  The bytes of the instruction are specified in the
 * parameter Bytes, and contains at least BytesSize number of bytes.  The
 * instruction is at the address specified by the PC parameter.  If a valid
 * instruction can be disassembled, its string is returned indirectly in
 * OutString whose size is specified in the parameter OutStringSize.  This
 * function returns the number of bytes in the instruction or zero if there was
 * no valid instruction.
 *)
function LLVMDisasmInstruction(DC: LLVMDisasmContextRef; Bytes: PUInt8; BytesSize: UInt64; PC: UInt64; OutString: PUTF8Char; OutStringSize: NativeUInt): NativeUInt; cdecl;
  external LLVM_DLL name _PU + 'LLVMDisasmInstruction';

(**
 * Empty function used to force the linker to link MCJIT.
 * Has no effect when called on a pre-built library (dylib interface).
 *)
procedure LLVMLinkInMCJIT(); cdecl;
  external LLVM_DLL name _PU + 'LLVMLinkInMCJIT';

(**
 * Empty function used to force the linker to link the LLVM interpreter.
 * Has no effect when called on a pre-built library (dylib interface).
 *)
procedure LLVMLinkInInterpreter(); cdecl;
  external LLVM_DLL name _PU + 'LLVMLinkInInterpreter';

function LLVMCreateGenericValueOfInt(Ty: LLVMTypeRef; N: UInt64; IsSigned: LLVMBool): LLVMGenericValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateGenericValueOfInt';

function LLVMCreateGenericValueOfPointer(P: Pointer): LLVMGenericValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateGenericValueOfPointer';

function LLVMCreateGenericValueOfFloat(Ty: LLVMTypeRef; N: Double): LLVMGenericValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateGenericValueOfFloat';

function LLVMGenericValueIntWidth(GenValRef: LLVMGenericValueRef): Cardinal; cdecl;
  external LLVM_DLL name _PU + 'LLVMGenericValueIntWidth';

function LLVMGenericValueToInt(GenVal: LLVMGenericValueRef; IsSigned: LLVMBool): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGenericValueToInt';

function LLVMGenericValueToPointer(GenVal: LLVMGenericValueRef): Pointer; cdecl;
  external LLVM_DLL name _PU + 'LLVMGenericValueToPointer';

function LLVMGenericValueToFloat(TyRef: LLVMTypeRef; GenVal: LLVMGenericValueRef): Double; cdecl;
  external LLVM_DLL name _PU + 'LLVMGenericValueToFloat';

procedure LLVMDisposeGenericValue(GenVal: LLVMGenericValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeGenericValue';

function LLVMCreateExecutionEngineForModule(OutEE: PLLVMExecutionEngineRef; M: LLVMModuleRef; OutError: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateExecutionEngineForModule';

function LLVMCreateInterpreterForModule(OutInterp: PLLVMExecutionEngineRef; M: LLVMModuleRef; OutError: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateInterpreterForModule';

function LLVMCreateJITCompilerForModule(OutJIT: PLLVMExecutionEngineRef; M: LLVMModuleRef; OptLevel: Cardinal; OutError: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateJITCompilerForModule';

procedure LLVMInitializeMCJITCompilerOptions(Options: PLLVMMCJITCompilerOptions; SizeOfOptions: NativeUInt); cdecl;
  external LLVM_DLL name _PU + 'LLVMInitializeMCJITCompilerOptions';

(**
 * Create an MCJIT execution engine for a module, with the given options. It is
 * the responsibility of the caller to ensure that all fields in Options up to
 * the given SizeOfOptions are initialized. It is correct to pass a smaller
 * value of SizeOfOptions that omits some fields. The canonical way of using
 * this is:
 *
 * LLVMMCJITCompilerOptions options;
 * LLVMInitializeMCJITCompilerOptions(&options, sizeof(options));
 * ... fill in those options you care about
 * LLVMCreateMCJITCompilerForModule(&jit, mod, &options, sizeof(options),
 *                                  &error);
 *
 * Note that this is also correct, though possibly suboptimal:
 *
 * LLVMCreateMCJITCompilerForModule(&jit, mod, 0, 0, &error);
 *)
function LLVMCreateMCJITCompilerForModule(OutJIT: PLLVMExecutionEngineRef; M: LLVMModuleRef; Options: PLLVMMCJITCompilerOptions; SizeOfOptions: NativeUInt; OutError: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateMCJITCompilerForModule';

procedure LLVMDisposeExecutionEngine(EE: LLVMExecutionEngineRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeExecutionEngine';

procedure LLVMRunStaticConstructors(EE: LLVMExecutionEngineRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMRunStaticConstructors';

procedure LLVMRunStaticDestructors(EE: LLVMExecutionEngineRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMRunStaticDestructors';

function LLVMRunFunctionAsMain(EE: LLVMExecutionEngineRef; F: LLVMValueRef; ArgC: Cardinal; const ArgV: PPUTF8Char; const EnvP: PPUTF8Char): Integer; cdecl;
  external LLVM_DLL name _PU + 'LLVMRunFunctionAsMain';

function LLVMRunFunction(EE: LLVMExecutionEngineRef; F: LLVMValueRef; NumArgs: Cardinal; Args: PLLVMGenericValueRef): LLVMGenericValueRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRunFunction';

procedure LLVMFreeMachineCodeForFunction(EE: LLVMExecutionEngineRef; F: LLVMValueRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMFreeMachineCodeForFunction';

procedure LLVMAddModule(EE: LLVMExecutionEngineRef; M: LLVMModuleRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddModule';

function LLVMRemoveModule(EE: LLVMExecutionEngineRef; M: LLVMModuleRef; OutMod: PLLVMModuleRef; OutError: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemoveModule';

function LLVMFindFunction(EE: LLVMExecutionEngineRef; const Name: PUTF8Char; OutFn: PLLVMValueRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMFindFunction';

function LLVMRecompileAndRelinkFunction(EE: LLVMExecutionEngineRef; Fn: LLVMValueRef): Pointer; cdecl;
  external LLVM_DLL name _PU + 'LLVMRecompileAndRelinkFunction';

function LLVMGetExecutionEngineTargetData(EE: LLVMExecutionEngineRef): LLVMTargetDataRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetExecutionEngineTargetData';

function LLVMGetExecutionEngineTargetMachine(EE: LLVMExecutionEngineRef): LLVMTargetMachineRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetExecutionEngineTargetMachine';

procedure LLVMAddGlobalMapping(EE: LLVMExecutionEngineRef; Global: LLVMValueRef; Addr: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddGlobalMapping';

function LLVMGetPointerToGlobal(EE: LLVMExecutionEngineRef; Global: LLVMValueRef): Pointer; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetPointerToGlobal';

function LLVMGetGlobalValueAddress(EE: LLVMExecutionEngineRef; const Name: PUTF8Char): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetGlobalValueAddress';

function LLVMGetFunctionAddress(EE: LLVMExecutionEngineRef; const Name: PUTF8Char): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetFunctionAddress';

/// Returns true on error, false on success. If true is returned then the error
/// message is copied to OutStr and cleared in the ExecutionEngine instance.
function LLVMExecutionEngineGetErrMsg(EE: LLVMExecutionEngineRef; OutError: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMExecutionEngineGetErrMsg';

(**
 * Create a simple custom MCJIT memory manager. This memory manager can
 * intercept allocations in a module-oblivious way. This will return NULL
 * if any of the passed functions are NULL.
 *
 * @param Opaque An opaque client object to pass back to the callbacks.
 * @param AllocateCodeSection Allocate a block of memory for executable code.
 * @param AllocateDataSection Allocate a block of memory for data.
 * @param FinalizeMemory Set page permissions and flush cache. Return 0 on
 *   success, 1 on error.
 *)
function LLVMCreateSimpleMCJITMemoryManager(Opaque: Pointer; AllocateCodeSection: LLVMMemoryManagerAllocateCodeSectionCallback; AllocateDataSection: LLVMMemoryManagerAllocateDataSectionCallback; FinalizeMemory: LLVMMemoryManagerFinalizeMemoryCallback; Destroy: LLVMMemoryManagerDestroyCallback): LLVMMCJITMemoryManagerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateSimpleMCJITMemoryManager';

procedure LLVMDisposeMCJITMemoryManager(MM: LLVMMCJITMemoryManagerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeMCJITMemoryManager';

function LLVMCreateGDBRegistrationListener(): LLVMJITEventListenerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateGDBRegistrationListener';

function LLVMCreateIntelJITEventListener(): LLVMJITEventListenerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateIntelJITEventListener';

function LLVMCreateOProfileJITEventListener(): LLVMJITEventListenerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateOProfileJITEventListener';

function LLVMCreatePerfJITEventListener(): LLVMJITEventListenerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreatePerfJITEventListener';

(**
 * Read LLVM IR from a memory buffer and convert it into an in-memory Module
 * object. Returns 0 on success.
 * Optionally returns a human-readable description of any errors that
 * occurred during parsing IR. OutMessage must be disposed with
 * LLVMDisposeMessage.
 *
 * @see llvm::ParseIR()
 *)
function LLVMParseIRInContext(ContextRef: LLVMContextRef; MemBuf: LLVMMemoryBufferRef; OutM: PLLVMModuleRef; OutMessage: PPUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMParseIRInContext';

function LLVMLinkModules2(Dest: LLVMModuleRef; Src: LLVMModuleRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMLinkModules2';

(**
 * Attach a custom error reporter function to the ExecutionSession.
 *
 * The error reporter will be called to deliver failure notices that can not be
 * directly reported to a caller. For example, failure to resolve symbols in
 * the JIT linker is typically reported via the error reporter (callers
 * requesting definitions from the JIT will typically be delivered a
 * FailureToMaterialize error instead).
 *)
procedure LLVMOrcExecutionSessionSetErrorReporter(ES: LLVMOrcExecutionSessionRef; ReportError: LLVMOrcErrorReporterFunction; Ctx: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcExecutionSessionSetErrorReporter';

(**
 * Return a reference to the SymbolStringPool for an ExecutionSession.
 *
 * Ownership of the pool remains with the ExecutionSession: The caller is
 * not required to free the pool.
 *)
function LLVMOrcExecutionSessionGetSymbolStringPool(ES: LLVMOrcExecutionSessionRef): LLVMOrcSymbolStringPoolRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcExecutionSessionGetSymbolStringPool';

(**
 * Clear all unreferenced symbol string pool entries.
 *
 * This can be called at any time to release unused entries in the
 * ExecutionSession's string pool. Since it locks the pool (preventing
 * interning of any new strings) it is recommended that it only be called
 * infrequently, ideally when the caller has reason to believe that some
 * entries will have become unreferenced, e.g. after removing a module or
 * closing a JITDylib.
 *)
procedure LLVMOrcSymbolStringPoolClearDeadEntries(SSP: LLVMOrcSymbolStringPoolRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcSymbolStringPoolClearDeadEntries';

(**
 * Intern a string in the ExecutionSession's SymbolStringPool and return a
 * reference to it. This increments the ref-count of the pool entry, and the
 * returned value should be released once the client is done with it by
 * calling LLVMOrcReleaseSymbolStringPoolEntry.
 *
 * Since strings are uniqued within the SymbolStringPool
 * LLVMOrcSymbolStringPoolEntryRefs can be compared by value to test string
 * equality.
 *
 * Note that this function does not perform linker-mangling on the string.
 *)
function LLVMOrcExecutionSessionIntern(ES: LLVMOrcExecutionSessionRef; const Name: PUTF8Char): LLVMOrcSymbolStringPoolEntryRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcExecutionSessionIntern';

(**
 * Look up symbols in an execution session.
 *
 * This is a wrapper around the general ExecutionSession::lookup function.
 *
 * The SearchOrder argument contains a list of (JITDylibs, JITDylibSearchFlags)
 * pairs that describe the search order. The JITDylibs will be searched in the
 * given order to try to find the symbols in the Symbols argument.
 *
 * The Symbols argument should contain a null-terminated array of
 * (SymbolStringPtr, SymbolLookupFlags) pairs describing the symbols to be
 * searched for. This function takes ownership of the elements of the Symbols
 * array. The Name fields of the Symbols elements are taken to have been
 * retained by the client for this function. The client should *not* release the
 * Name fields, but are still responsible for destroying the array itself.
 *
 * The HandleResult function will be called once all searched for symbols have
 * been found, or an error occurs. The HandleResult function will be passed an
 * LLVMErrorRef indicating success or failure, and (on success) a
 * null-terminated LLVMOrcCSymbolMapPairs array containing the function result,
 * and the Ctx value passed to the lookup function.
 *
 * The client is fully responsible for managing the lifetime of the Ctx object.
 * A common idiom is to allocate the context prior to the lookup and deallocate
 * it in the handler.
 *
 * THIS API IS EXPERIMENTAL AND LIKELY TO CHANGE IN THE NEAR FUTURE!
 *)
procedure LLVMOrcExecutionSessionLookup(ES: LLVMOrcExecutionSessionRef; K: LLVMOrcLookupKind; SearchOrder: LLVMOrcCJITDylibSearchOrder; SearchOrderSize: NativeUInt; Symbols: LLVMOrcCLookupSet; SymbolsSize: NativeUInt; HandleResult: LLVMOrcExecutionSessionLookupHandleResultFunction; Ctx: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcExecutionSessionLookup';

(**
 * Increments the ref-count for a SymbolStringPool entry.
 *)
procedure LLVMOrcRetainSymbolStringPoolEntry(S: LLVMOrcSymbolStringPoolEntryRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcRetainSymbolStringPoolEntry';

(**
 * Reduces the ref-count for of a SymbolStringPool entry.
 *)
procedure LLVMOrcReleaseSymbolStringPoolEntry(S: LLVMOrcSymbolStringPoolEntryRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcReleaseSymbolStringPoolEntry';

(**
 * Return the c-string for the given symbol. This string will remain valid until
 * the entry is freed (once all LLVMOrcSymbolStringPoolEntryRefs have been
 * released).
 *)
function LLVMOrcSymbolStringPoolEntryStr(S: LLVMOrcSymbolStringPoolEntryRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcSymbolStringPoolEntryStr';

(**
 * Reduces the ref-count of a ResourceTracker.
 *)
procedure LLVMOrcReleaseResourceTracker(RT: LLVMOrcResourceTrackerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcReleaseResourceTracker';

(**
 * Transfers tracking of all resources associated with resource tracker SrcRT
 * to resource tracker DstRT.
 *)
procedure LLVMOrcResourceTrackerTransferTo(SrcRT: LLVMOrcResourceTrackerRef; DstRT: LLVMOrcResourceTrackerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcResourceTrackerTransferTo';

(**
 * Remove all resources associated with the given tracker. See
 * ResourceTracker::remove().
 *)
function LLVMOrcResourceTrackerRemove(RT: LLVMOrcResourceTrackerRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcResourceTrackerRemove';

(**
 * Dispose of a JITDylib::DefinitionGenerator. This should only be called if
 * ownership has not been passed to a JITDylib (e.g. because some error
 * prevented the client from calling LLVMOrcJITDylibAddGenerator).
 *)
procedure LLVMOrcDisposeDefinitionGenerator(DG: LLVMOrcDefinitionGeneratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeDefinitionGenerator';

(**
 * Dispose of a MaterializationUnit.
 *)
procedure LLVMOrcDisposeMaterializationUnit(MU: LLVMOrcMaterializationUnitRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeMaterializationUnit';

(**
 * Create a custom MaterializationUnit.
 *
 * Name is a name for this MaterializationUnit to be used for identification
 * and logging purposes (e.g. if this MaterializationUnit produces an
 * object buffer then the name of that buffer will be derived from this name).
 *
 * The Syms list contains the names and linkages of the symbols provided by this
 * unit. This function takes ownership of the elements of the Syms array. The
 * Name fields of the array elements are taken to have been retained for this
 * function. The client should *not* release the elements of the array, but is
 * still responsible for destroying the array itself.
 *
 * The InitSym argument indicates whether or not this MaterializationUnit
 * contains static initializers. If three are no static initializers (the common
 * case) then this argument should be null. If there are static initializers
 * then InitSym should be set to a unique name that also appears in the Syms
 * list with the LLVMJITSymbolGenericFlagsMaterializationSideEffectsOnly flag
 * set. This function takes ownership of the InitSym, which should have been
 * retained twice on behalf of this function: once for the Syms entry and once
 * for InitSym. If clients wish to use the InitSym value after this function
 * returns they must retain it once more for themselves.
 *
 * If any of the symbols in the Syms list is looked up then the Materialize
 * function will be called.
 *
 * If any of the symbols in the Syms list is overridden then the Discard
 * function will be called.
 *
 * The caller owns the underling MaterializationUnit and is responsible for
 * either passing it to a JITDylib (via LLVMOrcJITDylibDefine) or disposing
 * of it by calling LLVMOrcDisposeMaterializationUnit.
 *)
function LLVMOrcCreateCustomMaterializationUnit(const Name: PUTF8Char; Ctx: Pointer; Syms: LLVMOrcCSymbolFlagsMapPairs; NumSyms: NativeUInt; InitSym: LLVMOrcSymbolStringPoolEntryRef; Materialize: LLVMOrcMaterializationUnitMaterializeFunction; Discard: LLVMOrcMaterializationUnitDiscardFunction; Destroy: LLVMOrcMaterializationUnitDestroyFunction): LLVMOrcMaterializationUnitRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateCustomMaterializationUnit';

(**
 * Create a MaterializationUnit to define the given symbols as pointing to
 * the corresponding raw addresses.
 *
 * This function takes ownership of the elements of the Syms array. The Name
 * fields of the array elements are taken to have been retained for this
 * function. This allows the following pattern...
 *
 *   size_t NumPairs;
 *   LLVMOrcCSymbolMapPairs Sym;
 *   -- Build Syms array --
 *   LLVMOrcMaterializationUnitRef MU =
 *       LLVMOrcAbsoluteSymbols(Syms, NumPairs);
 *
 * ... without requiring cleanup of the elements of the Sym array afterwards.
 *
 * The client is still responsible for deleting the Sym array itself.
 *
 * If a client wishes to reuse elements of the Sym array after this call they
 * must explicitly retain each of the elements for themselves.
 *)
function LLVMOrcAbsoluteSymbols(Syms: LLVMOrcCSymbolMapPairs; NumPairs: NativeUInt): LLVMOrcMaterializationUnitRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcAbsoluteSymbols';

(**
 * Create a MaterializationUnit to define lazy re-expots. These are callable
 * entry points that call through to the given symbols.
 *
 * This function takes ownership of the CallableAliases array. The Name
 * fields of the array elements are taken to have been retained for this
 * function. This allows the following pattern...
 *
 *   size_t NumPairs;
 *   LLVMOrcCSymbolAliasMapPairs CallableAliases;
 *   -- Build CallableAliases array --
 *   LLVMOrcMaterializationUnitRef MU =
 *      LLVMOrcLazyReexports(LCTM, ISM, JD, CallableAliases, NumPairs);
 *
 * ... without requiring cleanup of the elements of the CallableAliases array afterwards.
 *
 * The client is still responsible for deleting the CallableAliases array itself.
 *
 * If a client wishes to reuse elements of the CallableAliases array after this call they
 * must explicitly retain each of the elements for themselves.
 *)
function LLVMOrcLazyReexports(LCTM: LLVMOrcLazyCallThroughManagerRef; ISM: LLVMOrcIndirectStubsManagerRef; SourceRef: LLVMOrcJITDylibRef; CallableAliases: LLVMOrcCSymbolAliasMapPairs; NumPairs: NativeUInt): LLVMOrcMaterializationUnitRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLazyReexports';

(**
 * Disposes of the passed MaterializationResponsibility object.
 *
 * This should only be done after the symbols covered by the object have either
 * been resolved and emitted (via
 * LLVMOrcMaterializationResponsibilityNotifyResolved and
 * LLVMOrcMaterializationResponsibilityNotifyEmitted) or failed (via
 * LLVMOrcMaterializationResponsibilityFailMaterialization).
 *)
procedure LLVMOrcDisposeMaterializationResponsibility(MR: LLVMOrcMaterializationResponsibilityRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeMaterializationResponsibility';

(**
 * Returns the target JITDylib that these symbols are being materialized into.
 *)
function LLVMOrcMaterializationResponsibilityGetTargetDylib(MR: LLVMOrcMaterializationResponsibilityRef): LLVMOrcJITDylibRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityGetTargetDylib';

(**
 * Returns the ExecutionSession for this MaterializationResponsibility.
 *)
function LLVMOrcMaterializationResponsibilityGetExecutionSession(MR: LLVMOrcMaterializationResponsibilityRef): LLVMOrcExecutionSessionRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityGetExecutionSession';

(**
 * Returns the symbol flags map for this responsibility instance.
 *
 * The length of the array is returned in NumPairs and the caller is responsible
 * for the returned memory and needs to call LLVMOrcDisposeCSymbolFlagsMap.
 *
 * To use the returned symbols beyond the livetime of the
 * MaterializationResponsibility requires the caller to retain the symbols
 * explicitly.
 *)
function LLVMOrcMaterializationResponsibilityGetSymbols(MR: LLVMOrcMaterializationResponsibilityRef; NumPairs: PNativeUInt): LLVMOrcCSymbolFlagsMapPairs; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityGetSymbols';

(**
 * Disposes of the passed LLVMOrcCSymbolFlagsMap.
 *
 * Does not release the entries themselves.
 *)
procedure LLVMOrcDisposeCSymbolFlagsMap(Pairs: LLVMOrcCSymbolFlagsMapPairs); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeCSymbolFlagsMap';

(**
 * Returns the initialization pseudo-symbol, if any. This symbol will also
 * be present in the SymbolFlagsMap for this MaterializationResponsibility
 * object.
 *
 * The returned symbol is not retained over any mutating operation of the
 * MaterializationResponsbility or beyond the lifetime thereof.
 *)
function LLVMOrcMaterializationResponsibilityGetInitializerSymbol(MR: LLVMOrcMaterializationResponsibilityRef): LLVMOrcSymbolStringPoolEntryRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityGetInitializerSymbol';

(**
 * Returns the names of any symbols covered by this
 * MaterializationResponsibility object that have queries pending. This
 * information can be used to return responsibility for unrequested symbols
 * back to the JITDylib via the delegate method.
 *)
function LLVMOrcMaterializationResponsibilityGetRequestedSymbols(MR: LLVMOrcMaterializationResponsibilityRef; NumSymbols: PNativeUInt): PLLVMOrcSymbolStringPoolEntryRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityGetRequestedSymbols';

(**
 * Disposes of the passed LLVMOrcSymbolStringPoolEntryRef* .
 *
 * Does not release the symbols themselves.
 *)
procedure LLVMOrcDisposeSymbols(Symbols: PLLVMOrcSymbolStringPoolEntryRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeSymbols';

(**
 * Notifies the target JITDylib that the given symbols have been resolved.
 * This will update the given symbols' addresses in the JITDylib, and notify
 * any pending queries on the given symbols of their resolution. The given
 * symbols must be ones covered by this MaterializationResponsibility
 * instance. Individual calls to this method may resolve a subset of the
 * symbols, but all symbols must have been resolved prior to calling emit.
 *
 * This method will return an error if any symbols being resolved have been
 * moved to the error state due to the failure of a dependency. If this
 * method returns an error then clients should log it and call
 * LLVMOrcMaterializationResponsibilityFailMaterialization. If no dependencies
 * have been registered for the symbols covered by this
 * MaterializationResponsibility then this method is guaranteed to return
 * LLVMErrorSuccess.
 *)
function LLVMOrcMaterializationResponsibilityNotifyResolved(MR: LLVMOrcMaterializationResponsibilityRef; Symbols: LLVMOrcCSymbolMapPairs; NumPairs: NativeUInt): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityNotifyResolved';

(**
 * Notifies the target JITDylib (and any pending queries on that JITDylib)
 * that all symbols covered by this MaterializationResponsibility instance
 * have been emitted.
 *
 * This function takes ownership of the symbols in the Dependencies struct.
 * This allows the following pattern...
 *
 *   LLVMOrcSymbolStringPoolEntryRef Names[] = {...};
 *   LLVMOrcCDependenceMapPair Dependence = {JD, {Names, sizeof(Names)}}
 *   LLVMOrcMaterializationResponsibilityAddDependencies(JD, Name, &Dependence,
 * 1);
 *
 * ... without requiring cleanup of the elements of the Names array afterwards.
 *
 * The client is still responsible for deleting the Dependencies.Names arrays,
 * and the Dependencies array itself.
 *
 * This method will return an error if any symbols being resolved have been
 * moved to the error state due to the failure of a dependency. If this
 * method returns an error then clients should log it and call
 * LLVMOrcMaterializationResponsibilityFailMaterialization.
 * If no dependencies have been registered for the symbols covered by this
 * MaterializationResponsibility then this method is guaranteed to return
 * LLVMErrorSuccess.
 *)
function LLVMOrcMaterializationResponsibilityNotifyEmitted(MR: LLVMOrcMaterializationResponsibilityRef; SymbolDepGroups: PLLVMOrcCSymbolDependenceGroup; NumSymbolDepGroups: NativeUInt): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityNotifyEmitted';

(**
 * Attempt to claim responsibility for new definitions. This method can be
 * used to claim responsibility for symbols that are added to a
 * materialization unit during the compilation process (e.g. literal pool
 * symbols). Symbol linkage rules are the same as for symbols that are
 * defined up front: duplicate strong definitions will result in errors.
 * Duplicate weak definitions will be discarded (in which case they will
 * not be added to this responsibility instance).
 *
 * This method can be used by materialization units that want to add
 * additional symbols at materialization time (e.g. stubs, compile
 * callbacks, metadata)
 *)
function LLVMOrcMaterializationResponsibilityDefineMaterializing(MR: LLVMOrcMaterializationResponsibilityRef; Pairs: LLVMOrcCSymbolFlagsMapPairs; NumPairs: NativeUInt): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityDefineMaterializing';

(**
 * Notify all not-yet-emitted covered by this MaterializationResponsibility
 * instance that an error has occurred.
 * This will remove all symbols covered by this MaterializationResponsibility
 * from the target JITDylib, and send an error to any queries waiting on
 * these symbols.
 *)
procedure LLVMOrcMaterializationResponsibilityFailMaterialization(MR: LLVMOrcMaterializationResponsibilityRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityFailMaterialization';

(**
 * Transfers responsibility to the given MaterializationUnit for all
 * symbols defined by that MaterializationUnit. This allows
 * materializers to break up work based on run-time information (e.g.
 * by introspecting which symbols have actually been looked up and
 * materializing only those).
 *)
function LLVMOrcMaterializationResponsibilityReplace(MR: LLVMOrcMaterializationResponsibilityRef; MU: LLVMOrcMaterializationUnitRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityReplace';

(**
 * Delegates responsibility for the given symbols to the returned
 * materialization responsibility. Useful for breaking up work between
 * threads, or different kinds of materialization processes.
 *
 * The caller retains responsibility of the the passed
 * MaterializationResponsibility.
 *)
function LLVMOrcMaterializationResponsibilityDelegate(MR: LLVMOrcMaterializationResponsibilityRef; Symbols: PLLVMOrcSymbolStringPoolEntryRef; NumSymbols: NativeUInt; Result: PLLVMOrcMaterializationResponsibilityRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcMaterializationResponsibilityDelegate';

(**
 * Create a "bare" JITDylib.
 *
 * The client is responsible for ensuring that the JITDylib's name is unique,
 * e.g. by calling LLVMOrcExecutionSessionGetJTIDylibByName first.
 *
 * This call does not install any library code or symbols into the newly
 * created JITDylib. The client is responsible for all configuration.
 *)
function LLVMOrcExecutionSessionCreateBareJITDylib(ES: LLVMOrcExecutionSessionRef; const Name: PUTF8Char): LLVMOrcJITDylibRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcExecutionSessionCreateBareJITDylib';

(**
 * Create a JITDylib.
 *
 * The client is responsible for ensuring that the JITDylib's name is unique,
 * e.g. by calling LLVMOrcExecutionSessionGetJTIDylibByName first.
 *
 * If a Platform is attached to the ExecutionSession then
 * Platform::setupJITDylib will be called to install standard platform symbols
 * (e.g. standard library interposes). If no Platform is installed then this
 * call is equivalent to LLVMExecutionSessionRefCreateBareJITDylib and will
 * always return success.
 *)
function LLVMOrcExecutionSessionCreateJITDylib(ES: LLVMOrcExecutionSessionRef; Result: PLLVMOrcJITDylibRef; const Name: PUTF8Char): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcExecutionSessionCreateJITDylib';

(**
 * Returns the JITDylib with the given name, or NULL if no such JITDylib
 * exists.
 *)
function LLVMOrcExecutionSessionGetJITDylibByName(ES: LLVMOrcExecutionSessionRef; const Name: PUTF8Char): LLVMOrcJITDylibRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcExecutionSessionGetJITDylibByName';

(**
 * Return a reference to a newly created resource tracker associated with JD.
 * The tracker is returned with an initial ref-count of 1, and must be released
 * with LLVMOrcReleaseResourceTracker when no longer needed.
 *)
function LLVMOrcJITDylibCreateResourceTracker(JD: LLVMOrcJITDylibRef): LLVMOrcResourceTrackerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITDylibCreateResourceTracker';

(**
 * Return a reference to the default resource tracker for the given JITDylib.
 * This operation will increase the retain count of the tracker: Clients should
 * call LLVMOrcReleaseResourceTracker when the result is no longer needed.
 *)
function LLVMOrcJITDylibGetDefaultResourceTracker(JD: LLVMOrcJITDylibRef): LLVMOrcResourceTrackerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITDylibGetDefaultResourceTracker';

(**
 * Add the given MaterializationUnit to the given JITDylib.
 *
 * If this operation succeeds then JITDylib JD will take ownership of MU.
 * If the operation fails then ownership remains with the caller who should
 * call LLVMOrcDisposeMaterializationUnit to destroy it.
 *)
function LLVMOrcJITDylibDefine(JD: LLVMOrcJITDylibRef; MU: LLVMOrcMaterializationUnitRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITDylibDefine';

(**
 * Calls remove on all trackers associated with this JITDylib, see
 * JITDylib::clear().
 *)
function LLVMOrcJITDylibClear(JD: LLVMOrcJITDylibRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITDylibClear';

(**
 * Add a DefinitionGenerator to the given JITDylib.
 *
 * The JITDylib will take ownership of the given generator: The client is no
 * longer responsible for managing its memory.
 *)
procedure LLVMOrcJITDylibAddGenerator(JD: LLVMOrcJITDylibRef; DG: LLVMOrcDefinitionGeneratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITDylibAddGenerator';

(**
 * Create a custom generator.
 *
 * The F argument will be used to implement the DefinitionGenerator's
 * tryToGenerate method (see
 * LLVMOrcCAPIDefinitionGeneratorTryToGenerateFunction).
 *
 * Ctx is a context object that will be passed to F. This argument is
 * permitted to be null.
 *
 * Dispose is the disposal function for Ctx. This argument is permitted to be
 * null (in which case the client is responsible for the lifetime of Ctx).
 *)
function LLVMOrcCreateCustomCAPIDefinitionGenerator(F: LLVMOrcCAPIDefinitionGeneratorTryToGenerateFunction; Ctx: Pointer; Dispose: LLVMOrcDisposeCAPIDefinitionGeneratorFunction): LLVMOrcDefinitionGeneratorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateCustomCAPIDefinitionGenerator';

(**
 * Continue a lookup that was suspended in a generator (see
 * LLVMOrcCAPIDefinitionGeneratorTryToGenerateFunction).
 *)
procedure LLVMOrcLookupStateContinueLookup(S: LLVMOrcLookupStateRef; Err: LLVMErrorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLookupStateContinueLookup';

(**
 * Get a DynamicLibrarySearchGenerator that will reflect process symbols into
 * the JITDylib. On success the resulting generator is owned by the client.
 * Ownership is typically transferred by adding the instance to a JITDylib
 * using LLVMOrcJITDylibAddGenerator,
 *
 * The GlobalPrefix argument specifies the character that appears on the front
 * of linker-mangled symbols for the target platform (e.g. '_' on MachO).
 * If non-null, this character will be stripped from the start of all symbol
 * strings before passing the remaining substring to dlsym.
 *
 * The optional Filter and Ctx arguments can be used to supply a symbol name
 * filter: Only symbols for which the filter returns true will be visible to
 * JIT'd code. If the Filter argument is null then all process symbols will
 * be visible to JIT'd code. Note that the symbol name passed to the Filter
 * function is the full mangled symbol: The client is responsible for stripping
 * the global prefix if present.
 *)
function LLVMOrcCreateDynamicLibrarySearchGeneratorForProcess(Result: PLLVMOrcDefinitionGeneratorRef; GlobalPrefx: UTF8Char; Filter: LLVMOrcSymbolPredicate; FilterCtx: Pointer): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateDynamicLibrarySearchGeneratorForProcess';

(**
 * Get a LLVMOrcCreateDynamicLibararySearchGeneratorForPath that will reflect
 * library symbols into the JITDylib. On success the resulting generator is
 * owned by the client. Ownership is typically transferred by adding the
 * instance to a JITDylib using LLVMOrcJITDylibAddGenerator,
 *
 * The GlobalPrefix argument specifies the character that appears on the front
 * of linker-mangled symbols for the target platform (e.g. '_' on MachO).
 * If non-null, this character will be stripped from the start of all symbol
 * strings before passing the remaining substring to dlsym.
 *
 * The optional Filter and Ctx arguments can be used to supply a symbol name
 * filter: Only symbols for which the filter returns true will be visible to
 * JIT'd code. If the Filter argument is null then all library symbols will
 * be visible to JIT'd code. Note that the symbol name passed to the Filter
 * function is the full mangled symbol: The client is responsible for stripping
 * the global prefix if present.
 *
 * THIS API IS EXPERIMENTAL AND LIKELY TO CHANGE IN THE NEAR FUTURE!
 *
 *)
function LLVMOrcCreateDynamicLibrarySearchGeneratorForPath(Result: PLLVMOrcDefinitionGeneratorRef; const FileName: PUTF8Char; GlobalPrefix: UTF8Char; Filter: LLVMOrcSymbolPredicate; FilterCtx: Pointer): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateDynamicLibrarySearchGeneratorForPath';

(**
 * Get a LLVMOrcCreateStaticLibrarySearchGeneratorForPath that will reflect
 * static library symbols into the JITDylib. On success the resulting
 * generator is owned by the client. Ownership is typically transferred by
 * adding the instance to a JITDylib using LLVMOrcJITDylibAddGenerator,
 *
 * Call with the optional TargetTriple argument will succeed if the file at
 * the given path is a static library or a MachO universal binary containing a
 * static library that is compatible with the given triple. Otherwise it will
 * return an error.
 *
 * THIS API IS EXPERIMENTAL AND LIKELY TO CHANGE IN THE NEAR FUTURE!
 *
 *)
function LLVMOrcCreateStaticLibrarySearchGeneratorForPath(Result: PLLVMOrcDefinitionGeneratorRef; ObjLayer: LLVMOrcObjectLayerRef; const FileName: PUTF8Char): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateStaticLibrarySearchGeneratorForPath';

(**
 * Create a ThreadSafeContext containing a new LLVMContext.
 *
 * Ownership of the underlying ThreadSafeContext data is shared: Clients
 * can and should dispose of their ThreadSafeContext as soon as they no longer
 * need to refer to it directly. Other references (e.g. from ThreadSafeModules)
 * will keep the data alive as long as it is needed.
 *)
function LLVMOrcCreateNewThreadSafeContext(): LLVMOrcThreadSafeContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateNewThreadSafeContext';

(**
 * Get a reference to the wrapped LLVMContext.
 *)
function LLVMOrcThreadSafeContextGetContext(TSCtx: LLVMOrcThreadSafeContextRef): LLVMContextRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcThreadSafeContextGetContext';

(**
 * Dispose of a ThreadSafeContext.
 *)
procedure LLVMOrcDisposeThreadSafeContext(TSCtx: LLVMOrcThreadSafeContextRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeThreadSafeContext';

(**
 * Create a ThreadSafeModule wrapper around the given LLVM module. This takes
 * ownership of the M argument which should not be disposed of or referenced
 * after this function returns.
 *
 * Ownership of the ThreadSafeModule is unique: If it is transferred to the JIT
 * (e.g. by LLVMOrcLLJITAddLLVMIRModule) then the client is no longer
 * responsible for it. If it is not transferred to the JIT then the client
 * should call LLVMOrcDisposeThreadSafeModule to dispose of it.
 *)
function LLVMOrcCreateNewThreadSafeModule(M: LLVMModuleRef; TSCtx: LLVMOrcThreadSafeContextRef): LLVMOrcThreadSafeModuleRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateNewThreadSafeModule';

(**
 * Dispose of a ThreadSafeModule. This should only be called if ownership has
 * not been passed to LLJIT (e.g. because some error prevented the client from
 * adding this to the JIT).
 *)
procedure LLVMOrcDisposeThreadSafeModule(TSM: LLVMOrcThreadSafeModuleRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeThreadSafeModule';

(**
 * Apply the given function to the module contained in this ThreadSafeModule.
 *)
function LLVMOrcThreadSafeModuleWithModuleDo(TSM: LLVMOrcThreadSafeModuleRef; F: LLVMOrcGenericIRModuleOperationFunction; Ctx: Pointer): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcThreadSafeModuleWithModuleDo';

(**
 * Create a JITTargetMachineBuilder by detecting the host.
 *
 * On success the client owns the resulting JITTargetMachineBuilder. It must be
 * passed to a consuming operation (e.g.
 * LLVMOrcLLJITBuilderSetJITTargetMachineBuilder) or disposed of by calling
 * LLVMOrcDisposeJITTargetMachineBuilder.
 *)
function LLVMOrcJITTargetMachineBuilderDetectHost(Result: PLLVMOrcJITTargetMachineBuilderRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITTargetMachineBuilderDetectHost';

(**
 * Create a JITTargetMachineBuilder from the given TargetMachine template.
 *
 * This operation takes ownership of the given TargetMachine and destroys it
 * before returing. The resulting JITTargetMachineBuilder is owned by the client
 * and must be passed to a consuming operation (e.g.
 * LLVMOrcLLJITBuilderSetJITTargetMachineBuilder) or disposed of by calling
 * LLVMOrcDisposeJITTargetMachineBuilder.
 *)
function LLVMOrcJITTargetMachineBuilderCreateFromTargetMachine(TM: LLVMTargetMachineRef): LLVMOrcJITTargetMachineBuilderRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITTargetMachineBuilderCreateFromTargetMachine';

(**
 * Dispose of a JITTargetMachineBuilder.
 *)
procedure LLVMOrcDisposeJITTargetMachineBuilder(JTMB: LLVMOrcJITTargetMachineBuilderRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeJITTargetMachineBuilder';

(**
 * Returns the target triple for the given JITTargetMachineBuilder as a string.
 *
 * The caller owns the resulting string as must dispose of it by calling
 * LLVMDisposeMessage
 *)
function LLVMOrcJITTargetMachineBuilderGetTargetTriple(JTMB: LLVMOrcJITTargetMachineBuilderRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITTargetMachineBuilderGetTargetTriple';

(**
 * Sets the target triple for the given JITTargetMachineBuilder to the given
 * string.
 *)
procedure LLVMOrcJITTargetMachineBuilderSetTargetTriple(JTMB: LLVMOrcJITTargetMachineBuilderRef; const TargetTriple: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcJITTargetMachineBuilderSetTargetTriple';

(**
 * Add an object to an ObjectLayer to the given JITDylib.
 *
 * Adds a buffer representing an object file to the given JITDylib using the
 * given ObjectLayer instance. This operation transfers ownership of the buffer
 * to the ObjectLayer instance. The buffer should not be disposed of or
 * referenced once this function returns.
 *
 * Resources associated with the given object will be tracked by the given
 * JITDylib's default ResourceTracker.
 *)
function LLVMOrcObjectLayerAddObjectFile(ObjLayer: LLVMOrcObjectLayerRef; JD: LLVMOrcJITDylibRef; ObjBuffer: LLVMMemoryBufferRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcObjectLayerAddObjectFile';

(**
 * Add an object to an ObjectLayer using the given ResourceTracker.
 *
 * Adds a buffer representing an object file to the given ResourceTracker's
 * JITDylib using the given ObjectLayer instance. This operation transfers
 * ownership of the buffer to the ObjectLayer instance. The buffer should not
 * be disposed of or referenced once this function returns.
 *
 * Resources associated with the given object will be tracked by
 * ResourceTracker RT.
 *)
function LLVMOrcObjectLayerAddObjectFileWithRT(ObjLayer: LLVMOrcObjectLayerRef; RT: LLVMOrcResourceTrackerRef; ObjBuffer: LLVMMemoryBufferRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcObjectLayerAddObjectFileWithRT';

(**
 * Emit an object buffer to an ObjectLayer.
 *
 * Ownership of the responsibility object and object buffer pass to this
 * function. The client is not responsible for cleanup.
 *)
procedure LLVMOrcObjectLayerEmit(ObjLayer: LLVMOrcObjectLayerRef; R: LLVMOrcMaterializationResponsibilityRef; ObjBuffer: LLVMMemoryBufferRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcObjectLayerEmit';

(**
 * Dispose of an ObjectLayer.
 *)
procedure LLVMOrcDisposeObjectLayer(ObjLayer: LLVMOrcObjectLayerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeObjectLayer';

procedure LLVMOrcIRTransformLayerEmit(IRTransformLayer: LLVMOrcIRTransformLayerRef; MR: LLVMOrcMaterializationResponsibilityRef; TSM: LLVMOrcThreadSafeModuleRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcIRTransformLayerEmit';

(**
 * Set the transform function of the provided transform layer, passing through a
 * pointer to user provided context.
 *)
procedure LLVMOrcIRTransformLayerSetTransform(IRTransformLayer: LLVMOrcIRTransformLayerRef; TransformFunction: LLVMOrcIRTransformLayerTransformFunction; Ctx: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcIRTransformLayerSetTransform';

(**
 * Set the transform function on an LLVMOrcObjectTransformLayer.
 *)
procedure LLVMOrcObjectTransformLayerSetTransform(ObjTransformLayer: LLVMOrcObjectTransformLayerRef; TransformFunction: LLVMOrcObjectTransformLayerTransformFunction; Ctx: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcObjectTransformLayerSetTransform';

(**
 * Create a LocalIndirectStubsManager from the given target triple.
 *
 * The resulting IndirectStubsManager is owned by the client
 * and must be disposed of by calling LLVMOrcDisposeDisposeIndirectStubsManager.
 *)
function LLVMOrcCreateLocalIndirectStubsManager(const TargetTriple: PUTF8Char): LLVMOrcIndirectStubsManagerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateLocalIndirectStubsManager';

(**
 * Dispose of an IndirectStubsManager.
 *)
procedure LLVMOrcDisposeIndirectStubsManager(ISM: LLVMOrcIndirectStubsManagerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeIndirectStubsManager';

function LLVMOrcCreateLocalLazyCallThroughManager(const TargetTriple: PUTF8Char; ES: LLVMOrcExecutionSessionRef; ErrorHandlerAddr: LLVMOrcJITTargetAddress; LCTM: PLLVMOrcLazyCallThroughManagerRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateLocalLazyCallThroughManager';

(**
 * Dispose of an LazyCallThroughManager.
 *)
procedure LLVMOrcDisposeLazyCallThroughManager(LCTM: LLVMOrcLazyCallThroughManagerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeLazyCallThroughManager';

(**
 * Create a DumpObjects instance.
 *
 * DumpDir specifies the path to write dumped objects to. DumpDir may be empty
 * in which case files will be dumped to the working directory.
 *
 * IdentifierOverride specifies a file name stem to use when dumping objects.
 * If empty then each MemoryBuffer's identifier will be used (with a .o suffix
 * added if not already present). If an identifier override is supplied it will
 * be used instead, along with an incrementing counter (since all buffers will
 * use the same identifier, the resulting files will be named <ident>.o,
 * <ident>.2.o, <ident>.3.o, and so on). IdentifierOverride should not contain
 * an extension, as a .o suffix will be added by DumpObjects.
 *)
function LLVMOrcCreateDumpObjects(const DumpDir: PUTF8Char; const IdentifierOverride: PUTF8Char): LLVMOrcDumpObjectsRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateDumpObjects';

(**
 * Dispose of a DumpObjects instance.
 *)
procedure LLVMOrcDisposeDumpObjects(DumpObjects: LLVMOrcDumpObjectsRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeDumpObjects';

(**
 * Dump the contents of the given MemoryBuffer.
 *)
function LLVMOrcDumpObjects_CallOperator(DumpObjects: LLVMOrcDumpObjectsRef; ObjBuffer: PLLVMMemoryBufferRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDumpObjects_CallOperator';

(**
 * Create an LLVMOrcLLJITBuilder.
 *
 * The client owns the resulting LLJITBuilder and should dispose of it using
 * LLVMOrcDisposeLLJITBuilder once they are done with it.
 *)
function LLVMOrcCreateLLJITBuilder(): LLVMOrcLLJITBuilderRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateLLJITBuilder';

(**
 * Dispose of an LLVMOrcLLJITBuilderRef. This should only be called if ownership
 * has not been passed to LLVMOrcCreateLLJIT (e.g. because some error prevented
 * that function from being called).
 *)
procedure LLVMOrcDisposeLLJITBuilder(Builder: LLVMOrcLLJITBuilderRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeLLJITBuilder';

(**
 * Set the JITTargetMachineBuilder to be used when constructing the LLJIT
 * instance. Calling this function is optional: if it is not called then the
 * LLJITBuilder will use JITTargeTMachineBuilder::detectHost to construct a
 * JITTargetMachineBuilder.
 *
 * This function takes ownership of the JTMB argument: clients should not
 * dispose of the JITTargetMachineBuilder after calling this function.
 *)
procedure LLVMOrcLLJITBuilderSetJITTargetMachineBuilder(Builder: LLVMOrcLLJITBuilderRef; JTMB: LLVMOrcJITTargetMachineBuilderRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITBuilderSetJITTargetMachineBuilder';

(**
 * Set an ObjectLinkingLayer creator function for this LLJIT instance.
 *)
procedure LLVMOrcLLJITBuilderSetObjectLinkingLayerCreator(Builder: LLVMOrcLLJITBuilderRef; F: LLVMOrcLLJITBuilderObjectLinkingLayerCreatorFunction; Ctx: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITBuilderSetObjectLinkingLayerCreator';

(**
 * Create an LLJIT instance from an LLJITBuilder.
 *
 * This operation takes ownership of the Builder argument: clients should not
 * dispose of the builder after calling this function (even if the function
 * returns an error). If a null Builder argument is provided then a
 * default-constructed LLJITBuilder will be used.
 *
 * On success the resulting LLJIT instance is uniquely owned by the client and
 * automatically manages the memory of all JIT'd code and all modules that are
 * transferred to it (e.g. via LLVMOrcLLJITAddLLVMIRModule). Disposing of the
 * LLJIT instance will free all memory managed by the JIT, including JIT'd code
 * and not-yet compiled modules.
 *)
function LLVMOrcCreateLLJIT(Result: PLLVMOrcLLJITRef; Builder: LLVMOrcLLJITBuilderRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateLLJIT';

(**
 * Dispose of an LLJIT instance.
 *)
function LLVMOrcDisposeLLJIT(J: LLVMOrcLLJITRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcDisposeLLJIT';

(**
 * Get a reference to the ExecutionSession for this LLJIT instance.
 *
 * The ExecutionSession is owned by the LLJIT instance. The client is not
 * responsible for managing its memory.
 *)
function LLVMOrcLLJITGetExecutionSession(J: LLVMOrcLLJITRef): LLVMOrcExecutionSessionRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITGetExecutionSession';

(**
 * Return a reference to the Main JITDylib.
 *
 * The JITDylib is owned by the LLJIT instance. The client is not responsible
 * for managing its memory.
 *)
function LLVMOrcLLJITGetMainJITDylib(J: LLVMOrcLLJITRef): LLVMOrcJITDylibRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITGetMainJITDylib';

(**
 * Return the target triple for this LLJIT instance. This string is owned by
 * the LLJIT instance and should not be freed by the client.
 *)
function LLVMOrcLLJITGetTripleString(J: LLVMOrcLLJITRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITGetTripleString';

(**
 * Returns the global prefix character according to the LLJIT's DataLayout.
 *)
function LLVMOrcLLJITGetGlobalPrefix(J: LLVMOrcLLJITRef): UTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITGetGlobalPrefix';

(**
 * Mangles the given string according to the LLJIT instance's DataLayout, then
 * interns the result in the SymbolStringPool and returns a reference to the
 * pool entry. Clients should call LLVMOrcReleaseSymbolStringPoolEntry to
 * decrement the ref-count on the pool entry once they are finished with this
 * value.
 *)
function LLVMOrcLLJITMangleAndIntern(J: LLVMOrcLLJITRef; const UnmangledName: PUTF8Char): LLVMOrcSymbolStringPoolEntryRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITMangleAndIntern';

(**
 * Add a buffer representing an object file to the given JITDylib in the given
 * LLJIT instance. This operation transfers ownership of the buffer to the
 * LLJIT instance. The buffer should not be disposed of or referenced once this
 * function returns.
 *
 * Resources associated with the given object will be tracked by the given
 * JITDylib's default resource tracker.
 *)
function LLVMOrcLLJITAddObjectFile(J: LLVMOrcLLJITRef; JD: LLVMOrcJITDylibRef; ObjBuffer: LLVMMemoryBufferRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITAddObjectFile';

(**
 * Add a buffer representing an object file to the given ResourceTracker's
 * JITDylib in the given LLJIT instance. This operation transfers ownership of
 * the buffer to the LLJIT instance. The buffer should not be disposed of or
 * referenced once this function returns.
 *
 * Resources associated with the given object will be tracked by ResourceTracker
 * RT.
 *)
function LLVMOrcLLJITAddObjectFileWithRT(J: LLVMOrcLLJITRef; RT: LLVMOrcResourceTrackerRef; ObjBuffer: LLVMMemoryBufferRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITAddObjectFileWithRT';

(**
 * Add an IR module to the given JITDylib in the given LLJIT instance. This
 * operation transfers ownership of the TSM argument to the LLJIT instance.
 * The TSM argument should not be disposed of or referenced once this
 * function returns.
 *
 * Resources associated with the given Module will be tracked by the given
 * JITDylib's default resource tracker.
 *)
function LLVMOrcLLJITAddLLVMIRModule(J: LLVMOrcLLJITRef; JD: LLVMOrcJITDylibRef; TSM: LLVMOrcThreadSafeModuleRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITAddLLVMIRModule';

(**
 * Add an IR module to the given ResourceTracker's JITDylib in the given LLJIT
 * instance. This operation transfers ownership of the TSM argument to the LLJIT
 * instance. The TSM argument should not be disposed of or referenced once this
 * function returns.
 *
 * Resources associated with the given Module will be tracked by ResourceTracker
 * RT.
 *)
function LLVMOrcLLJITAddLLVMIRModuleWithRT(J: LLVMOrcLLJITRef; JD: LLVMOrcResourceTrackerRef; TSM: LLVMOrcThreadSafeModuleRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITAddLLVMIRModuleWithRT';

(**
 * Look up the given symbol in the main JITDylib of the given LLJIT instance.
 *
 * This operation does not take ownership of the Name argument.
 *)
function LLVMOrcLLJITLookup(J: LLVMOrcLLJITRef; Result: PLLVMOrcExecutorAddress; const Name: PUTF8Char): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITLookup';

(**
 * Returns a non-owning reference to the LLJIT instance's object linking layer.
 *)
function LLVMOrcLLJITGetObjLinkingLayer(J: LLVMOrcLLJITRef): LLVMOrcObjectLayerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITGetObjLinkingLayer';

(**
 * Returns a non-owning reference to the LLJIT instance's object linking layer.
 *)
function LLVMOrcLLJITGetObjTransformLayer(J: LLVMOrcLLJITRef): LLVMOrcObjectTransformLayerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITGetObjTransformLayer';

(**
 * Returns a non-owning reference to the LLJIT instance's IR transform layer.
 *)
function LLVMOrcLLJITGetIRTransformLayer(J: LLVMOrcLLJITRef): LLVMOrcIRTransformLayerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITGetIRTransformLayer';

(**
 * Get the LLJIT instance's default data layout string.
 *
 * This string is owned by the LLJIT instance and does not need to be freed
 * by the caller.
 *)
function LLVMOrcLLJITGetDataLayoutStr(J: LLVMOrcLLJITRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITGetDataLayoutStr';

(**
 * Install the plugin that submits debug objects to the executor. Executors must
 * expose the llvm_orc_registerJITLoaderGDBWrapper symbol.
 *)
function LLVMOrcLLJITEnableDebugSupport(J: LLVMOrcLLJITRef): LLVMErrorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcLLJITEnableDebugSupport';

(**
 * Create a binary file from the given memory buffer.
 *
 * The exact type of the binary file will be inferred automatically, and the
 * appropriate implementation selected.  The context may be NULL except if
 * the resulting file is an LLVM IR file.
 *
 * The memory buffer is not consumed by this function.  It is the responsibilty
 * of the caller to free it with \c LLVMDisposeMemoryBuffer.
 *
 * If NULL is returned, the \p ErrorMessage parameter is populated with the
 * error's description.  It is then the caller's responsibility to free this
 * message by calling \c LLVMDisposeMessage.
 *
 * @see llvm::object::createBinary
 *)
function LLVMCreateBinary(MemBuf: LLVMMemoryBufferRef; Context: LLVMContextRef; ErrorMessage: PPUTF8Char): LLVMBinaryRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateBinary';

(**
 * Dispose of a binary file.
 *
 * The binary file does not own its backing buffer.  It is the responsibilty
 * of the caller to free it with \c LLVMDisposeMemoryBuffer.
 *)
procedure LLVMDisposeBinary(BR: LLVMBinaryRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeBinary';

(**
 * Retrieves a copy of the memory buffer associated with this object file.
 *
 * The returned buffer is merely a shallow copy and does not own the actual
 * backing buffer of the binary. Nevertheless, it is the responsibility of the
 * caller to free it with \c LLVMDisposeMemoryBuffer.
 *
 * @see llvm::object::getMemoryBufferRef
 *)
function LLVMBinaryCopyMemoryBuffer(BR: LLVMBinaryRef): LLVMMemoryBufferRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMBinaryCopyMemoryBuffer';

(**
 * Retrieve the specific type of a binary.
 *
 * @see llvm::object::Binary::getType
 *)
function LLVMBinaryGetType(BR: LLVMBinaryRef): LLVMBinaryType; cdecl;
  external LLVM_DLL name _PU + 'LLVMBinaryGetType';

function LLVMMachOUniversalBinaryCopyObjectForArch(BR: LLVMBinaryRef; const Arch: PUTF8Char; ArchLen: NativeUInt; ErrorMessage: PPUTF8Char): LLVMBinaryRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMMachOUniversalBinaryCopyObjectForArch';

(**
 * Retrieve a copy of the section iterator for this object file.
 *
 * If there are no sections, the result is NULL.
 *
 * The returned iterator is merely a shallow copy. Nevertheless, it is
 * the responsibility of the caller to free it with
 * \c LLVMDisposeSectionIterator.
 *
 * @see llvm::object::sections()
 *)
function LLVMObjectFileCopySectionIterator(BR: LLVMBinaryRef): LLVMSectionIteratorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMObjectFileCopySectionIterator';

(**
 * Returns whether the given section iterator is at the end.
 *
 * @see llvm::object::section_end
 *)
function LLVMObjectFileIsSectionIteratorAtEnd(BR: LLVMBinaryRef; SI: LLVMSectionIteratorRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMObjectFileIsSectionIteratorAtEnd';

(**
 * Retrieve a copy of the symbol iterator for this object file.
 *
 * If there are no symbols, the result is NULL.
 *
 * The returned iterator is merely a shallow copy. Nevertheless, it is
 * the responsibility of the caller to free it with
 * \c LLVMDisposeSymbolIterator.
 *
 * @see llvm::object::symbols()
 *)
function LLVMObjectFileCopySymbolIterator(BR: LLVMBinaryRef): LLVMSymbolIteratorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMObjectFileCopySymbolIterator';

(**
 * Returns whether the given symbol iterator is at the end.
 *
 * @see llvm::object::symbol_end
 *)
function LLVMObjectFileIsSymbolIteratorAtEnd(BR: LLVMBinaryRef; SI: LLVMSymbolIteratorRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMObjectFileIsSymbolIteratorAtEnd';

procedure LLVMDisposeSectionIterator(SI: LLVMSectionIteratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeSectionIterator';

procedure LLVMMoveToNextSection(SI: LLVMSectionIteratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMMoveToNextSection';

procedure LLVMMoveToContainingSection(Sect: LLVMSectionIteratorRef; Sym: LLVMSymbolIteratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMMoveToContainingSection';

procedure LLVMDisposeSymbolIterator(SI: LLVMSymbolIteratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeSymbolIterator';

procedure LLVMMoveToNextSymbol(SI: LLVMSymbolIteratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMMoveToNextSymbol';

function LLVMGetSectionName(SI: LLVMSectionIteratorRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSectionName';

function LLVMGetSectionSize(SI: LLVMSectionIteratorRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSectionSize';

function LLVMGetSectionContents(SI: LLVMSectionIteratorRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSectionContents';

function LLVMGetSectionAddress(SI: LLVMSectionIteratorRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSectionAddress';

function LLVMGetSectionContainsSymbol(SI: LLVMSectionIteratorRef; Sym: LLVMSymbolIteratorRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSectionContainsSymbol';

function LLVMGetRelocations(Section: LLVMSectionIteratorRef): LLVMRelocationIteratorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetRelocations';

procedure LLVMDisposeRelocationIterator(RI: LLVMRelocationIteratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeRelocationIterator';

function LLVMIsRelocationIteratorAtEnd(Section: LLVMSectionIteratorRef; RI: LLVMRelocationIteratorRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsRelocationIteratorAtEnd';

procedure LLVMMoveToNextRelocation(RI: LLVMRelocationIteratorRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMMoveToNextRelocation';

function LLVMGetSymbolName(SI: LLVMSymbolIteratorRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSymbolName';

function LLVMGetSymbolAddress(SI: LLVMSymbolIteratorRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSymbolAddress';

function LLVMGetSymbolSize(SI: LLVMSymbolIteratorRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSymbolSize';

function LLVMGetRelocationOffset(RI: LLVMRelocationIteratorRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetRelocationOffset';

function LLVMGetRelocationSymbol(RI: LLVMRelocationIteratorRef): LLVMSymbolIteratorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetRelocationSymbol';

function LLVMGetRelocationType(RI: LLVMRelocationIteratorRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetRelocationType';

function LLVMGetRelocationTypeName(RI: LLVMRelocationIteratorRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetRelocationTypeName';

function LLVMGetRelocationValueString(RI: LLVMRelocationIteratorRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetRelocationValueString';

(** Deprecated: Use LLVMCreateBinary instead. *)
function LLVMCreateObjectFile(MemBuf: LLVMMemoryBufferRef): LLVMObjectFileRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMCreateObjectFile';

(** Deprecated: Use LLVMDisposeBinary instead. *)
procedure LLVMDisposeObjectFile(ObjectFile: LLVMObjectFileRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMDisposeObjectFile';

(** Deprecated: Use LLVMObjectFileCopySectionIterator instead. *)
function LLVMGetSections(ObjectFile: LLVMObjectFileRef): LLVMSectionIteratorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSections';

(** Deprecated: Use LLVMObjectFileIsSectionIteratorAtEnd instead. *)
function LLVMIsSectionIteratorAtEnd(ObjectFile: LLVMObjectFileRef; SI: LLVMSectionIteratorRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsSectionIteratorAtEnd';

(** Deprecated: Use LLVMObjectFileCopySymbolIterator instead. *)
function LLVMGetSymbols(ObjectFile: LLVMObjectFileRef): LLVMSymbolIteratorRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMGetSymbols';

(** Deprecated: Use LLVMObjectFileIsSymbolIteratorAtEnd instead. *)
function LLVMIsSymbolIteratorAtEnd(ObjectFile: LLVMObjectFileRef; SI: LLVMSymbolIteratorRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMIsSymbolIteratorAtEnd';

(**
 * Create a RTDyldObjectLinkingLayer instance using the standard
 * SectionMemoryManager for memory management.
 *)
function LLVMOrcCreateRTDyldObjectLinkingLayerWithSectionMemoryManager(ES: LLVMOrcExecutionSessionRef): LLVMOrcObjectLayerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateRTDyldObjectLinkingLayerWithSectionMemoryManager';

(**
 * Create a RTDyldObjectLinkingLayer instance using MCJIT-memory-manager-like
 * callbacks.
 *
 * This is intended to simplify transitions for existing MCJIT clients. The
 * callbacks used are similar (but not identical) to the callbacks for
 * LLVMCreateSimpleMCJITMemoryManager: Unlike MCJIT, RTDyldObjectLinkingLayer
 * will create a new memory manager for each object linked by calling the given
 * CreateContext callback. This allows for code removal by destroying each
 * allocator individually. Every allocator will be destroyed (if it has not been
 * already) at RTDyldObjectLinkingLayer destruction time, and the
 * NotifyTerminating callback will be called to indicate that no further
 * allocation contexts will be created.
 *
 * To implement MCJIT-like behavior clients can implement CreateContext,
 * NotifyTerminating, and Destroy as:
 *
 *   void *CreateContext(void *CtxCtx) { return CtxCtx; }
 *   void NotifyTerminating(void *CtxCtx) { MyOriginalDestroy(CtxCtx); }
 *   void Destroy(void *Ctx) { }
 *
 * This scheme simply reuses the CreateContextCtx pointer as the one-and-only
 * allocation context.
 *)
function LLVMOrcCreateRTDyldObjectLinkingLayerWithMCJITMemoryManagerLikeCallbacks(ES: LLVMOrcExecutionSessionRef; CreateContextCtx: Pointer; CreateContext: LLVMMemoryManagerCreateContextCallback; NotifyTerminating: LLVMMemoryManagerNotifyTerminatingCallback; AllocateCodeSection: LLVMMemoryManagerAllocateCodeSectionCallback; AllocateDataSection: LLVMMemoryManagerAllocateDataSectionCallback; FinalizeMemory: LLVMMemoryManagerFinalizeMemoryCallback; Destroy: LLVMMemoryManagerDestroyCallback): LLVMOrcObjectLayerRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcCreateRTDyldObjectLinkingLayerWithMCJITMemoryManagerLikeCallbacks';

(**
 * Add the given listener to the given RTDyldObjectLinkingLayer.
 *
 * Note: Layer must be an RTDyldObjectLinkingLayer instance or
 * behavior is undefined.
 *)
procedure LLVMOrcRTDyldObjectLinkingLayerRegisterJITEventListener(RTDyldObjLinkingLayer: LLVMOrcObjectLayerRef; Listener: LLVMJITEventListenerRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMOrcRTDyldObjectLinkingLayerRegisterJITEventListener';

(**
 * Returns the buffer holding the string.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkStringGetData(String_: LLVMRemarkStringRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkStringGetData';

(**
 * Returns the size of the string.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkStringGetLen(String_: LLVMRemarkStringRef): UInt32; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkStringGetLen';

(**
 * Return the path to the source file for a debug location.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkDebugLocGetSourceFilePath(DL: LLVMRemarkDebugLocRef): LLVMRemarkStringRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkDebugLocGetSourceFilePath';

(**
 * Return the line in the source file for a debug location.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkDebugLocGetSourceLine(DL: LLVMRemarkDebugLocRef): UInt32; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkDebugLocGetSourceLine';

(**
 * Return the column in the source file for a debug location.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkDebugLocGetSourceColumn(DL: LLVMRemarkDebugLocRef): UInt32; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkDebugLocGetSourceColumn';

(**
 * Returns the key of an argument. The key defines what the value is, and the
 * same key can appear multiple times in the list of arguments.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkArgGetKey(Arg: LLVMRemarkArgRef): LLVMRemarkStringRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkArgGetKey';

(**
 * Returns the value of an argument. This is a string that can contain newlines.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkArgGetValue(Arg: LLVMRemarkArgRef): LLVMRemarkStringRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkArgGetValue';

(**
 * Returns the debug location that is attached to the value of this argument.
 *
 * If there is no debug location, the return value will be `NULL`.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkArgGetDebugLoc(Arg: LLVMRemarkArgRef): LLVMRemarkDebugLocRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkArgGetDebugLoc';

(**
 * Free the resources used by the remark entry.
 *
 * \since REMARKS_API_VERSION=0
 *)
procedure LLVMRemarkEntryDispose(Remark: LLVMRemarkEntryRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryDispose';

(**
 * The type of the remark. For example, it can allow users to only keep the
 * missed optimizations from the compiler.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetType(Remark: LLVMRemarkEntryRef): LLVMRemarkType; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetType';

(**
 * Get the name of the pass that emitted this remark.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetPassName(Remark: LLVMRemarkEntryRef): LLVMRemarkStringRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetPassName';

(**
 * Get an identifier of the remark.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetRemarkName(Remark: LLVMRemarkEntryRef): LLVMRemarkStringRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetRemarkName';

(**
 * Get the name of the function being processed when the remark was emitted.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetFunctionName(Remark: LLVMRemarkEntryRef): LLVMRemarkStringRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetFunctionName';

(**
 * Returns the debug location that is attached to this remark.
 *
 * If there is no debug location, the return value will be `NULL`.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetDebugLoc(Remark: LLVMRemarkEntryRef): LLVMRemarkDebugLocRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetDebugLoc';

(**
 * Return the hotness of the remark.
 *
 * A hotness of `0` means this value is not set.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetHotness(Remark: LLVMRemarkEntryRef): UInt64; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetHotness';

(**
 * The number of arguments the remark holds.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetNumArgs(Remark: LLVMRemarkEntryRef): UInt32; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetNumArgs';

(**
 * Get a new iterator to iterate over a remark's argument.
 *
 * If there are no arguments in \p Remark, the return value will be `NULL`.
 *
 * The lifetime of the returned value is bound to the lifetime of \p Remark.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetFirstArg(Remark: LLVMRemarkEntryRef): LLVMRemarkArgRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetFirstArg';

(**
 * Get the next argument in \p Remark from the position of \p It.
 *
 * Returns `NULL` if there are no more arguments available.
 *
 * The lifetime of the returned value is bound to the lifetime of \p Remark.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkEntryGetNextArg(It: LLVMRemarkArgRef; Remark: LLVMRemarkEntryRef): LLVMRemarkArgRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkEntryGetNextArg';

(**
 * Creates a remark parser that can be used to parse the buffer located in \p
 * Buf of size \p Size bytes.
 *
 * \p Buf cannot be `NULL`.
 *
 * This function should be paired with LLVMRemarkParserDispose() to avoid
 * leaking resources.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkParserCreateYAML(const Buf: Pointer; Size: UInt64): LLVMRemarkParserRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkParserCreateYAML';

(**
 * Creates a remark parser that can be used to parse the buffer located in \p
 * Buf of size \p Size bytes.
 *
 * \p Buf cannot be `NULL`.
 *
 * This function should be paired with LLVMRemarkParserDispose() to avoid
 * leaking resources.
 *
 * \since REMARKS_API_VERSION=1
 *)
function LLVMRemarkParserCreateBitstream(const Buf: Pointer; Size: UInt64): LLVMRemarkParserRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkParserCreateBitstream';

(**
 * Returns the next remark in the file.
 *
 * The value pointed to by the return value needs to be disposed using a call to
 * LLVMRemarkEntryDispose().
 *
 * All the entries in the returned value that are of LLVMRemarkStringRef type
 * will become invalidated once a call to LLVMRemarkParserDispose is made.
 *
 * If the parser reaches the end of the buffer, the return value will be `NULL`.
 *
 * In the case of an error, the return value will be `NULL`, and:
 *
 * 1) LLVMRemarkParserHasError() will return `1`.
 *
 * 2) LLVMRemarkParserGetErrorMessage() will return a descriptive error
 *    message.
 *
 * An error may occur if:
 *
 * 1) An argument is invalid.
 *
 * 2) There is a parsing error. This can occur on things like malformed YAML.
 *
 * 3) There is a Remark semantic error. This can occur on well-formed files with
 *    missing or extra fields.
 *
 * Here is a quick example of the usage:
 *
 * ```
 * LLVMRemarkParserRef Parser = LLVMRemarkParserCreateYAML(Buf, Size);
 * LLVMRemarkEntryRef Remark = NULL;
 * while ((Remark = LLVMRemarkParserGetNext(Parser))) {
 *    // use Remark
 *    LLVMRemarkEntryDispose(Remark); // Release memory.
 * }
 * bool HasError = LLVMRemarkParserHasError(Parser);
 * LLVMRemarkParserDispose(Parser);
 * ```
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkParserGetNext(Parser: LLVMRemarkParserRef): LLVMRemarkEntryRef; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkParserGetNext';

(**
 * Returns `1` if the parser encountered an error while parsing the buffer.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkParserHasError(Parser: LLVMRemarkParserRef): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkParserHasError';

(**
 * Returns a null-terminated string containing an error message.
 *
 * In case of no error, the result is `NULL`.
 *
 * The memory of the string is bound to the lifetime of \p Parser. If
 * LLVMRemarkParserDispose() is called, the memory of the string will be
 * released.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkParserGetErrorMessage(Parser: LLVMRemarkParserRef): PUTF8Char; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkParserGetErrorMessage';

(**
 * Releases all the resources used by \p Parser.
 *
 * \since REMARKS_API_VERSION=0
 *)
procedure LLVMRemarkParserDispose(Parser: LLVMRemarkParserRef); cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkParserDispose';

(**
 * Returns the version of the remarks library.
 *
 * \since REMARKS_API_VERSION=0
 *)
function LLVMRemarkVersion(): UInt32; cdecl;
  external LLVM_DLL name _PU + 'LLVMRemarkVersion';

(**
 * This function permanently loads the dynamic library at the given path.
 * It is safe to call this function multiple times for the same library.
 *
 * @see sys::DynamicLibrary::LoadLibraryPermanently()
 *)
function LLVMLoadLibraryPermanently(const Filename: PUTF8Char): LLVMBool; cdecl;
  external LLVM_DLL name _PU + 'LLVMLoadLibraryPermanently';

(**
 * This function parses the given arguments using the LLVM command line parser.
 * Note that the only stable thing about this function is its signature; you
 * cannot rely on any particular set of command line arguments being interpreted
 * the same way across LLVM versions.
 *
 * @see llvm::cl::ParseCommandLineOptions()
 *)
procedure LLVMParseCommandLineOptions(argc: Integer; const argv: PPUTF8Char; const Overview: PUTF8Char); cdecl;
  external LLVM_DLL name _PU + 'LLVMParseCommandLineOptions';

(**
 * This function will search through all previously loaded dynamic
 * libraries for the symbol \p symbolName. If it is found, the address of
 * that symbol is returned. If not, null is returned.
 *
 * @see sys::DynamicLibrary::SearchForAddressOfSymbol()
 *)
function LLVMSearchForAddressOfSymbol(const symbolName: PUTF8Char): Pointer; cdecl;
  external LLVM_DLL name _PU + 'LLVMSearchForAddressOfSymbol';

(**
 * This functions permanently adds the symbol \p symbolName with the
 * value \p symbolValue.  These symbols are searched before any
 * libraries.
 *
 * @see sys::DynamicLibrary::AddSymbol()
 *)
procedure LLVMAddSymbol(const symbolName: PUTF8Char; symbolValue: Pointer); cdecl;
  external LLVM_DLL name _PU + 'LLVMAddSymbol';

implementation

end.

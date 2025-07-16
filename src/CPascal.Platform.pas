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

 https://cpascal.org

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

unit CPascal.Platform;

{$I CPascal.Defines.inc}

interface

uses
  CPascal.LLVM,
  {$IF DEFINED(MSWINDOWS) AND DEFINED(CPUX64)}
  WinApi.Windows;
  {$ENDIF}

type
  { TCPPlatformTarget }
  TCPPlatformTarget = (
    ptX86_64,      // x86-64 (AMD64/Intel 64)
    ptAArch64,     // ARM 64-bit
    ptWebAssembly, // WebAssembly target
    ptRISCV        // RISC-V 64-bit
  );

  { TCPPlatformInitResult }
  TCPPlatformInitResult = record
    Success: Boolean;
    ErrorMessage: string;
    PlatformTarget: TCPPlatformTarget;
    TargetTriple: string;
  end;

function  CPInitLLVMPlatform(): TCPPlatformInitResult;
function  CPGetPlatformTargetTriple(): string;
function  CPGetPlatformTarget(): TCPPlatformTarget;
function  CPInitLLVMForTarget(const ATarget: TCPPlatformTarget): TCPPlatformInitResult;

procedure CPInitConsole();

function  CPIsPlatformInitialized(): Boolean;
function  CPGetPlatformInitResult(): TCPPlatformInitResult;

implementation

uses
  SysUtils;

var
  // Global initialization state
  GPlatformInitialized: Boolean = False;
  GPlatformInitResult: TCPPlatformInitResult;

function CPInitLLVMPlatform(): TCPPlatformInitResult;
begin
  Result.Success := False;
  Result.ErrorMessage := '';
  
  {$IF DEFINED(MSWINDOWS) AND DEFINED(CPUX64)}
    // Windows x86-64 platform
    Result.PlatformTarget := ptX86_64;
    Result.TargetTriple := 'x86_64-pc-windows-msvc';
    
    try
      // Complete X86 target infrastructure initialization
      LLVMInitializeX86TargetInfo();
      LLVMInitializeX86Target();
      LLVMInitializeX86TargetMC();
      LLVMInitializeX86AsmPrinter();
      LLVMInitializeX86AsmParser();
      LLVMInitializeX86Disassembler();
      
      Result.Success := True;
    except
      on E: Exception do
      begin
        Result.ErrorMessage := 'Failed to initialize X86 LLVM target: ' + E.Message;
      end;
    end;

  {$ELSEIF DEFINED(MSWINDOWS) AND DEFINED(CPUX86)}
    // Windows x86-32 platform
    Result.PlatformTarget := ptX86_64; // Still use X86_64 target for 32-bit
    Result.TargetTriple := 'i686-pc-windows-msvc';

    try
      // Complete X86 target infrastructure initialization
      LLVMInitializeX86TargetInfo();
      LLVMInitializeX86Target();
      LLVMInitializeX86TargetMC();
      LLVMInitializeX86AsmPrinter();
      LLVMInitializeX86AsmParser();
      LLVMInitializeX86Disassembler();

      Result.Success := True;
    except
      on E: Exception do
      begin
        Result.ErrorMessage := 'Failed to initialize X86 LLVM target: ' + E.Message;
      end;
    end;

  {$ELSEIF DEFINED(LINUX) AND DEFINED(CPUX64)}
    // Linux x86-64 platform
    Result.PlatformTarget := ptX86_64;
    Result.TargetTriple := 'x86_64-unknown-linux-gnu';

    try
      LLVMInitializeX86Target();
      LLVMInitializeX86TargetMC();
      LLVMInitializeX86AsmPrinter();

      Result.Success := True;
    except
      on E: Exception do
      begin
        Result.ErrorMessage := 'Failed to initialize X86 LLVM target: ' + E.Message;
      end;
    end;

  {$ELSEIF DEFINED(LINUX) AND DEFINED(CPUAARCH64)}
    // Linux ARM 64-bit platform
    Result.PlatformTarget := ptAArch64;
    Result.TargetTriple := 'aarch64-unknown-linux-gnu';

    try
      // Complete AArch64 target infrastructure initialization
      LLVMInitializeAArch64TargetInfo();
      LLVMInitializeAArch64Target();
      LLVMInitializeAArch64TargetMC();
      LLVMInitializeAArch64AsmPrinter();
      LLVMInitializeAArch64AsmParser();
      LLVMInitializeAArch64Disassembler();

      Result.Success := True;
    except
      on E: Exception do
      begin
        Result.ErrorMessage := 'Failed to initialize AArch64 LLVM target: ' + E.Message;
      end;
    end;

  {$ELSEIF DEFINED(MACOS) AND DEFINED(CPUX64)}
    // macOS x86-64 platform
    Result.PlatformTarget := ptX86_64;
    Result.TargetTriple := 'x86_64-apple-darwin';

    try
      // Complete X86 target infrastructure initialization
      LLVMInitializeX86TargetInfo();
      LLVMInitializeX86Target();
      LLVMInitializeX86TargetMC();
      LLVMInitializeX86AsmPrinter();
      LLVMInitializeX86AsmParser();
      LLVMInitializeX86Disassembler();

      Result.Success := True;
    except
      on E: Exception do
      begin
        Result.ErrorMessage := 'Failed to initialize X86 LLVM target: ' + E.Message;
      end;
    end;

  {$ELSEIF DEFINED(MACOS) AND DEFINED(CPUAARCH64)}
    // macOS ARM 64-bit (Apple Silicon) platform
    Result.PlatformTarget := ptAArch64;
    Result.TargetTriple := 'arm64-apple-darwin';

    try
      // Complete AArch64 target infrastructure initialization
      LLVMInitializeAArch64TargetInfo();
      LLVMInitializeAArch64Target();
      LLVMInitializeAArch64TargetMC();
      LLVMInitializeAArch64AsmPrinter();
      LLVMInitializeAArch64AsmParser();
      LLVMInitializeAArch64Disassembler();

      Result.Success := True;
    except
      on E: Exception do
      begin
        Result.ErrorMessage := 'Failed to initialize AArch64 LLVM target: ' + E.Message;
      end;
    end;

  {$ELSE}
    // Unsupported platform - default to Windows X86-64 (most common)
    Result.PlatformTarget := ptX86_64;
    Result.TargetTriple := 'x86_64-pc-windows-msvc';
    Result.ErrorMessage := 'Warning: Unsupported platform detected, defaulting to Windows X86-64 target';

    try
      // Complete X86 target infrastructure initialization (fallback)
      LLVMInitializeX86TargetInfo();
      LLVMInitializeX86Target();
      LLVMInitializeX86TargetMC();
      LLVMInitializeX86AsmPrinter();
      LLVMInitializeX86AsmParser();
      LLVMInitializeX86Disassembler();

      Result.Success := True;
    except
      on E: Exception do
      begin
        Result.ErrorMessage := 'Failed to initialize fallback X86 LLVM target: ' + E.Message;
      end;
    end;
  {$ENDIF}
end;

function CPGetPlatformTargetTriple(): string;
var
  LInitResult: TCPPlatformInitResult;
begin
  LInitResult := CPInitLLVMPlatform();
  Result := LInitResult.TargetTriple;
end;

function CPGetPlatformTarget(): TCPPlatformTarget;
begin
  {$IF DEFINED(MSWINDOWS) AND (DEFINED(CPUX64) OR DEFINED(CPUX86))}
    Result := ptX86_64;
  {$ELSEIF DEFINED(LINUX) AND DEFINED(CPUX64)}
    Result := ptX86_64;
  {$ELSEIF DEFINED(LINUX) AND DEFINED(CPUAARCH64)}
    Result := ptAArch64;
  {$ELSEIF DEFINED(MACOS) AND DEFINED(CPUX64)}
    Result := ptX86_64;
  {$ELSEIF DEFINED(MACOS) AND DEFINED(CPUAARCH64)}
    Result := ptAArch64;
  {$ELSE}
    Result := ptX86_64; // Default fallback
  {$ENDIF}
end;

function CPInitLLVMForTarget(const ATarget: TCPPlatformTarget): TCPPlatformInitResult;
begin
  Result.Success := False;
  Result.ErrorMessage := '';
  Result.PlatformTarget := ATarget;
  
  case ATarget of
    ptX86_64:
    begin
      Result.TargetTriple := 'x86_64-unknown-unknown';
      try
        LLVMInitializeX86TargetInfo();
        LLVMInitializeX86Target();
        LLVMInitializeX86TargetMC();
        LLVMInitializeX86AsmPrinter();
        LLVMInitializeX86AsmParser();
        LLVMInitializeX86Disassembler();
        Result.Success := True;
      except
        on E: Exception do
          Result.ErrorMessage := 'Failed to initialize X86-64 target: ' + E.Message;
      end;
    end;
    
    ptAArch64:
    begin
      Result.TargetTriple := 'aarch64-unknown-unknown';
      try
        LLVMInitializeAArch64TargetInfo();
        LLVMInitializeAArch64Target();
        LLVMInitializeAArch64TargetMC();
        LLVMInitializeAArch64AsmPrinter();
        LLVMInitializeAArch64AsmParser();
        LLVMInitializeAArch64Disassembler();
        Result.Success := True;
      except
        on E: Exception do
          Result.ErrorMessage := 'Failed to initialize AArch64 target: ' + E.Message;
      end;
    end;
    
    ptWebAssembly:
    begin
      Result.TargetTriple := 'wasm32-unknown-unknown';
      try
        LLVMInitializeWebAssemblyTargetInfo();
        LLVMInitializeWebAssemblyTarget();
        LLVMInitializeWebAssemblyTargetMC();
        LLVMInitializeWebAssemblyAsmPrinter();
        LLVMInitializeWebAssemblyAsmParser();
        LLVMInitializeWebAssemblyDisassembler();
        Result.Success := True;
      except
        on E: Exception do
          Result.ErrorMessage := 'Failed to initialize WebAssembly target: ' + E.Message;
      end;
    end;
    
    ptRISCV:
    begin
      Result.TargetTriple := 'riscv64-unknown-unknown';
      try
        LLVMInitializeRISCVTargetInfo();
        LLVMInitializeRISCVTarget();
        LLVMInitializeRISCVTargetMC();
        LLVMInitializeRISCVAsmPrinter();
        LLVMInitializeRISCVAsmParser();
        LLVMInitializeRISCVDisassembler();
        Result.Success := True;
      except
        on E: Exception do
          Result.ErrorMessage := 'Failed to initialize RISC-V target: ' + E.Message;
      end;
    end;
  else
    Result.ErrorMessage := 'Unknown target platform specified';
  end;
end;

{$IF DEFINED(MSWINDOWS) AND DEFINED(CPUX64)}
  function EnableVirtualTerminalProcessing(): Boolean;
  var
    HOut: THandle;
    LMode: DWORD;
  begin
    Result := False;

    HOut := GetStdHandle(STD_OUTPUT_HANDLE);
    if HOut = INVALID_HANDLE_VALUE then Exit;
    if not GetConsoleMode(HOut, LMode) then Exit;

    LMode := LMode or ENABLE_VIRTUAL_TERMINAL_PROCESSING;
    if not SetConsoleMode(HOut, LMode) then Exit;

    Result := True;
  end;
{$ENDIF}

procedure CPInitConsole();
begin
  {$IF DEFINED(MSWINDOWS) AND DEFINED(CPUX64)}
    EnableVirtualTerminalProcessing();
    SetConsoleCP(CP_UTF8);
    SetConsoleOutputCP(CP_UTF8);
  {$ENDIF}
end;

function CPIsPlatformInitialized(): Boolean;
begin
  Result := GPlatformInitialized;
end;

function CPGetPlatformInitResult(): TCPPlatformInitResult;
begin
  Result := GPlatformInitResult;
end;

initialization
  ReportMemoryLeaksOnShutdown := True;
  // Automatically initialize LLVM platform at unit load
  GPlatformInitResult := CPInitLLVMPlatform();
  GPlatformInitialized := GPlatformInitResult.Success;
  
  // Initialize console only for console applications
  {$IF DEFINED(CONSOLE)}
  CPInitConsole();
  {$ENDIF}

end.

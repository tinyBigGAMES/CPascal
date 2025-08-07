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

unit CPascal.CodeGen.CompilationUnit;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.CodeGen,
  CPascal.AST,
  CPascal.AST.CompilationUnit,
  CPascal.AST.Functions,
  CPascal.LLVM;

function GenerateProgram(const ACodeGen: TCPCodeGen; const AProgram: TCPProgramNode): LLVMModuleRef;
function GenerateLibrary(const ACodeGen: TCPCodeGen; const ALibrary: TCPLibraryNode): LLVMModuleRef;
function GenerateModule(const ACodeGen: TCPCodeGen; const AModule: TCPModuleNode): LLVMModuleRef;
procedure GenerateExportsClause(const ACodeGen: TCPCodeGen; const AExports: TCPASTNodeList);

implementation

uses
  CPascal.CodeGen.Declarations,
  CPascal.CodeGen.Functions;

function GenerateProgram(const ACodeGen: TCPCodeGen; const AProgram: TCPProgramNode): LLVMModuleRef;
begin
  // PHASE 1: Generate external function declarations only
  GenerateDeclarations(ACodeGen, AProgram.Declarations);

  // PHASE 2: Generate local function signatures (so they exist in symbol table)
  GenerateLocalFunctionDeclarations(ACodeGen, AProgram.Declarations);

  // PHASE 3: Generate main function with variable allocations (positions builder)
  GenerateMainFunctionWithVariables(ACodeGen, AProgram);

  // PHASE 4: Generate local function implementations (now builder is positioned)
  GenerateLocalFunctionImplementations(ACodeGen, AProgram.Declarations);

  // Return module (ownership transfers to caller)
  Result := ACodeGen.Module_;
end;

function GenerateLibrary(const ACodeGen: TCPCodeGen; const ALibrary: TCPLibraryNode): LLVMModuleRef;
begin
  // Generate declarations (exported functions)
  GenerateDeclarations(ACodeGen, ALibrary.Declarations);

  // Generate export specifications for library
  GenerateExportsClause(ACodeGen, ALibrary.ExportsList);

  // No main function for libraries
  Result := ACodeGen.Module_;
end;

function GenerateModule(const ACodeGen: TCPCodeGen; const AModule: TCPModuleNode): LLVMModuleRef;
begin
  // Pure declarations only - no main, no exports
  GenerateDeclarations(ACodeGen, AModule.Declarations);

  Result := ACodeGen.Module_;
end;

procedure GenerateExportsClause(const ACodeGen: TCPCodeGen; const AExports: TCPASTNodeList);
var
  LLocation: TCPSourceLocation;
begin
  // Export clause generation for libraries - not yet implemented
  // This would involve setting symbol visibility and linkage for exported functions
  if (AExports <> nil) and (AExports.Count > 0) then
  begin
    LLocation := TCPSourceLocation.Create('<exports>', 0, 0);
    ACodeGen.CodeGenError('Export clause generation not yet implemented', [], LLocation);
  end;
end;

end.

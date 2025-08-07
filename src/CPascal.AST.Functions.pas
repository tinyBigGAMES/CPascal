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

unit CPascal.AST.Functions;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.AST,
  CPascal.AST.Types,
  CPascal.AST.Statements;

type
  { TCPParameterNode }
  TCPParameterNode = class(TCPASTNode)
  private
    FParameterName: string;
    FParameterType: TCPTypeNode;
    FIsConst: Boolean;
    FIsVar: Boolean;
    FIsOut: Boolean;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AParameterName: string; const AParameterType: TCPTypeNode;
      const AIsConst: Boolean = False; const AIsVar: Boolean = False; const AIsOut: Boolean = False);
    destructor Destroy; override;

    property ParameterName: string read FParameterName;
    property ParameterType: TCPTypeNode read FParameterType;
    property IsConst: Boolean read FIsConst;
    property IsVar: Boolean read FIsVar;
    property IsOut: Boolean read FIsOut;
  end;

  { TCPFunctionDeclarationNode }
  TCPFunctionDeclarationNode = class(TCPASTNode)
  private
    FFunctionName: string;
    FParameters: TCPASTNodeList;
    FReturnType: TCPTypeNode;
    FCallingConvention: TCPCallingConvention;
    FIsExternal: Boolean;
    FIsVarArgs: Boolean;
    FExternalLibrary: string;
    FLocalDeclarations: TCPASTNodeList;
    FBody: TCPCompoundStatementNode;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AFunctionName: string;
      const AReturnType: TCPTypeNode; const ACallingConvention: TCPCallingConvention = ccDefault;
      const AIsExternal: Boolean = False; const AIsVarArgs: Boolean = False; const AExternalLibrary: string = '');
    destructor Destroy; override;

    procedure AddParameter(const AParameter: TCPParameterNode);
    function GetParameter(const AIndex: Integer): TCPParameterNode;
    function ParameterCount(): Integer;
    procedure AddLocalDeclaration(const ADeclaration: TCPASTNode);
    function LocalDeclarationCount(): Integer;

    property FunctionName: string read FFunctionName;
    property Parameters: TCPASTNodeList read FParameters;
    property ReturnType: TCPTypeNode read FReturnType;
    property CallingConvention: TCPCallingConvention read FCallingConvention;
    property IsExternal: Boolean read FIsExternal;
    property IsVarArgs: Boolean read FIsVarArgs;
    property ExternalLibrary: string read FExternalLibrary;
    property LocalDeclarations: TCPASTNodeList read FLocalDeclarations;
    property Body: TCPCompoundStatementNode read FBody write FBody;
  end;


implementation

{ TCPParameterNode }
constructor TCPParameterNode.Create(const ALocation: TCPSourceLocation; const AParameterName: string; const AParameterType: TCPTypeNode;
  const AIsConst: Boolean = False; const AIsVar: Boolean = False; const AIsOut: Boolean = False);
begin
  inherited Create(nkParameter, ALocation);
  FParameterName := AParameterName;
  FParameterType := AParameterType;
  FIsConst := AIsConst;
  FIsVar := AIsVar;
  FIsOut := AIsOut;
end;

destructor TCPParameterNode.Destroy;
begin
  FParameterType.Free;
  inherited Destroy;
end;

{ TCPFunctionDeclarationNode }
constructor TCPFunctionDeclarationNode.Create(const ALocation: TCPSourceLocation; const AFunctionName: string;
  const AReturnType: TCPTypeNode; const ACallingConvention: TCPCallingConvention = ccDefault;
  const AIsExternal: Boolean = False; const AIsVarArgs: Boolean = False; const AExternalLibrary: string = '');
begin
  inherited Create(nkFunctionDeclaration, ALocation);
  FFunctionName := AFunctionName;
  FReturnType := AReturnType;
  FCallingConvention := ACallingConvention;
  FIsExternal := AIsExternal;
  FIsVarArgs := AIsVarArgs;
  FExternalLibrary := AExternalLibrary;
  FParameters := TCPASTNodeList.Create(True); // Owns objects
  FLocalDeclarations := TCPASTNodeList.Create(True); // Owns objects
  FBody := nil;
end;

destructor TCPFunctionDeclarationNode.Destroy;
begin
  FParameters.Free;
  FLocalDeclarations.Free;
  FReturnType.Free;
  FBody.Free;
  inherited Destroy;
end;

procedure TCPFunctionDeclarationNode.AddParameter(const AParameter: TCPParameterNode);
begin
  if Assigned(AParameter) then
    FParameters.Add(AParameter);
end;

function TCPFunctionDeclarationNode.GetParameter(const AIndex: Integer): TCPParameterNode;
begin
  if (AIndex >= 0) and (AIndex < FParameters.Count) then
    Result := TCPParameterNode(FParameters[AIndex])
  else
    Result := nil;
end;

function TCPFunctionDeclarationNode.ParameterCount(): Integer;
begin
  Result := FParameters.Count;
end;

procedure TCPFunctionDeclarationNode.AddLocalDeclaration(const ADeclaration: TCPASTNode);
begin
  if Assigned(ADeclaration) then
    FLocalDeclarations.Add(ADeclaration);
end;

function TCPFunctionDeclarationNode.LocalDeclarationCount(): Integer;
begin
  Result := FLocalDeclarations.Count;
end;

end.

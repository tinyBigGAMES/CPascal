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

unit CPascal.AST.CompilationUnit;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Exception,
  CPascal.Lexer,
  CPascal.AST,
  CPascal.AST.Statements;

type
  { TCPCompilationUnitNode - Base class for all compilation units }
  TCPCompilationUnitNode = class(TCPASTNode)
  protected
    FUnitName: string;
    FUnitKind: TCPCompilationUnitKind;
    FDeclarations: TCPASTNodeList;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AUnitName: string; const AUnitKind: TCPCompilationUnitKind);
    destructor Destroy; override;

    procedure AddDeclaration(const ADeclaration: TCPASTNode);
    function GetDeclaration(const AIndex: Integer): TCPASTNode;
    function DeclarationCount(): Integer;

    property GetUnitName: string read FUnitName;
    property UnitKind: TCPCompilationUnitKind read FUnitKind;
    property Declarations: TCPASTNodeList read FDeclarations;
  end;

  { TCPProgramNode }
  TCPProgramNode = class(TCPCompilationUnitNode)
  private
    FMainBody: TCPCompoundStatementNode;

  public
    constructor Create(const ALocation: TCPSourceLocation; const AProgramName: string);
    destructor Destroy; override;

    property ProgramName: string read FUnitName;
    property MainBody: TCPCompoundStatementNode read FMainBody write FMainBody;
  end;

  { TCPLibraryNode }
  TCPLibraryNode = class(TCPCompilationUnitNode)
  private
    FExports: TCPASTNodeList;

  public
    constructor Create(const ALocation: TCPSourceLocation; const ALibraryName: string);
    destructor Destroy; override;

    procedure AddExport(const AExport: TCPASTNode);
    function GetExport(const AIndex: Integer): TCPASTNode;
    function ExportCount(): Integer;

    property LibraryName: string read FUnitName;
    property ExportsList: TCPASTNodeList read FExports;
  end;

  { TCPModuleNode }
  TCPModuleNode = class(TCPCompilationUnitNode)
  public
    constructor Create(const ALocation: TCPSourceLocation; const AModuleName: string);

    property ModuleName: string read FUnitName;
  end;

implementation

{ TCPCompilationUnitNode }
constructor TCPCompilationUnitNode.Create(const ALocation: TCPSourceLocation; const AUnitName: string; const AUnitKind: TCPCompilationUnitKind);
begin
  inherited Create(nkProgram, ALocation); // Use nkProgram as base for all compilation units
  FUnitName := AUnitName;
  FUnitKind := AUnitKind;
  FDeclarations := TCPASTNodeList.Create(True); // Owns objects
end;

destructor TCPCompilationUnitNode.Destroy;
begin
  FDeclarations.Free;
  inherited Destroy;
end;

procedure TCPCompilationUnitNode.AddDeclaration(const ADeclaration: TCPASTNode);
begin
  if Assigned(ADeclaration) then
    FDeclarations.Add(ADeclaration);
end;

function TCPCompilationUnitNode.GetDeclaration(const AIndex: Integer): TCPASTNode;
begin
  if (AIndex >= 0) and (AIndex < FDeclarations.Count) then
    Result := FDeclarations[AIndex]
  else
    Result := nil;
end;

function TCPCompilationUnitNode.DeclarationCount(): Integer;
begin
  Result := FDeclarations.Count;
end;

{ TCPProgramNode }
constructor TCPProgramNode.Create(const ALocation: TCPSourceLocation; const AProgramName: string);
begin
  inherited Create(ALocation, AProgramName, ckProgram);
  FMainBody := nil;
end;

destructor TCPProgramNode.Destroy;
begin
  FMainBody.Free;
  inherited Destroy;
end;


{ TCPLibraryNode }
constructor TCPLibraryNode.Create(const ALocation: TCPSourceLocation; const ALibraryName: string);
begin
  inherited Create(ALocation, ALibraryName, ckLibrary);
  FExports := TCPASTNodeList.Create(True); // Owns objects
end;

destructor TCPLibraryNode.Destroy;
begin
  FExports.Free;
  inherited Destroy;
end;

procedure TCPLibraryNode.AddExport(const AExport: TCPASTNode);
begin
  if Assigned(AExport) then
    FExports.Add(AExport);
end;

function TCPLibraryNode.GetExport(const AIndex: Integer): TCPASTNode;
begin
  if (AIndex >= 0) and (AIndex < FExports.Count) then
    Result := FExports[AIndex]
  else
    Result := nil;
end;

function TCPLibraryNode.ExportCount(): Integer;
begin
  Result := FExports.Count;
end;

{ TCPModuleNode }
constructor TCPModuleNode.Create(const ALocation: TCPSourceLocation; const AModuleName: string);
begin
  inherited Create(ALocation, AModuleName, ckModule);
end;

end.

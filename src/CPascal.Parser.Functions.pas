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

unit CPascal.Parser.Functions;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.Classes,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.AST.Types,
  CPascal.AST.Functions;

function ParseFunctionDeclaration(const AParser: TCPParser): TCPFunctionDeclarationNode;
function ParseExternalFunction(const AParser: TCPParser): TCPFunctionDeclarationNode;
function ParseParameterList(const AParser: TCPParser): TCPASTNodeList;
function ParseParameterDeclaration(const AParser: TCPParser): TCPASTNodeList;

implementation

uses
  CPascal.Parser.Types,
  CPascal.Parser.Statements,
  CPascal.Parser.Declarations;

function ParseFunctionDeclaration(const AParser: TCPParser): TCPFunctionDeclarationNode;
var
  LFunctionName: string;
  LParameters: TCPASTNodeList;
  LReturnType: TCPTypeNode;
  LCallingConvention: TCPCallingConvention;
  LIsExternal: Boolean;
  LIsVarArgs: Boolean;
  LExternalLibrary: string;
  LParameter: TCPASTNode;
  LIndex: Integer;
  LIsProcedure: Boolean;
  LLocalDeclarations: TCPASTNodeList;
  LDeclaration: TCPASTNode;
begin
  // Parse function or procedure header
  if not (AParser.MatchToken(tkFunction) or AParser.MatchToken(tkProcedure)) then
    AParser.UnexpectedToken('function or procedure');

  LIsProcedure := AParser.MatchToken(tkProcedure);
  AParser.AdvanceToken();

  if not AParser.MatchToken(tkIdentifier) then
    AParser.UnexpectedToken('function identifier');

  LFunctionName := AParser.CurrentToken.Value;
  AParser.AdvanceToken();

  AParser.ConsumeToken(tkLeftParen);

  // Parse parameter list
  LParameters := nil;
  LIsVarArgs := False;
  if not AParser.MatchToken(tkRightParen) then
  begin
    LParameters := ParseParameterList(AParser);

    // Check for varargs (...)
    if AParser.MatchToken(tkComma) then
    begin
      AParser.AdvanceToken(); // Consume comma
      if AParser.MatchToken(tkEllipsis) then
      begin
        LIsVarArgs := True;
        AParser.AdvanceToken(); // Consume ellipsis
      end
      else
      begin
        AParser.UnexpectedToken('... (ellipsis) for varargs function');
      end;
    end;
  end;

  AParser.ConsumeToken(tkRightParen);

  // Parse return type only for functions, not procedures
  if not LIsProcedure then
  begin
    AParser.ConsumeToken(tkColon);
    LReturnType := ParseType(AParser);
  end
  else
  begin
    // Procedures have no return type per BNF
    LReturnType := nil;
  end;

  AParser.ConsumeToken(tkSemicolon);

  // Check for calling convention
  LCallingConvention := ccDefault;
  if AParser.MatchToken(tkCdecl) or AParser.MatchToken(tkStdcall) or AParser.MatchToken(tkFastcall) or AParser.MatchToken(tkRegister) then
  begin
    LCallingConvention := AParser.TokenKindToCallingConvention(AParser.CurrentToken.Kind);
    AParser.AdvanceToken();
    AParser.ConsumeToken(tkSemicolon);
  end;

  // Check for external declaration
  LIsExternal := False;
  LExternalLibrary := '';
  if AParser.MatchToken(tkExternal) then
  begin
    LIsExternal := True;
    AParser.AdvanceToken();

    // Optional external library name
    if AParser.MatchToken(tkStringLiteral) then
    begin
      LExternalLibrary := AParser.CurrentToken.Value;
      AParser.AdvanceToken();
    end;

    AParser.ConsumeToken(tkSemicolon);

    // Check for calling convention after external (alternative BNF order)
    if AParser.MatchToken(tkCdecl) or AParser.MatchToken(tkStdcall) or AParser.MatchToken(tkFastcall) or AParser.MatchToken(tkRegister) then
    begin
      LCallingConvention := AParser.TokenKindToCallingConvention(AParser.CurrentToken.Kind);
      AParser.AdvanceToken();
      AParser.ConsumeToken(tkSemicolon);
    end;
  end;

  // Create function declaration node
  Result := TCPFunctionDeclarationNode.Create(
    AParser.CurrentToken.Location,
    LFunctionName,
    LReturnType,
    LCallingConvention,
    LIsExternal,
    LIsVarArgs,
    LExternalLibrary
  );
  
  // NEW: Register function/procedure in symbol table for assignment validation
  if LIsProcedure then
    AParser.SymbolTable.AddProcedureSymbol(LFunctionName)
  else
    AParser.SymbolTable.AddFunctionSymbol(LFunctionName);

  // Add parameters to function
  if Assigned(LParameters) then
  begin
    try
      for LIndex := 0 to LParameters.Count - 1 do
      begin
        LParameter := LParameters[LIndex];
        Result.AddParameter(TCPParameterNode(LParameter));
      end;
    finally
      LParameters.Free; // Free the temporary list (not the nodes, they're owned by Result)
    end;
  end;

  // If not external, parse function body
  if not LIsExternal then
  begin
    // Parse local declarations first (var, const, type sections)
    LLocalDeclarations := ParseDeclarations(AParser);
    try
      // Add all local declarations to the function
      for LIndex := 0 to LLocalDeclarations.Count - 1 do
      begin
        LDeclaration := LLocalDeclarations[LIndex];
        Result.AddLocalDeclaration(LDeclaration);
      end;
    finally
      LLocalDeclarations.Free; // Free the temporary list (not the nodes, they're owned by Result)
    end;
    
    // Then parse compound statement as function body
    Result.Body := ParseCompoundStatement(AParser);
    AParser.ConsumeToken(tkSemicolon); // Consume terminating semicolon
  end;
end;

function ParseExternalFunction(const AParser: TCPParser): TCPFunctionDeclarationNode;
begin
  // This method handles external function parsing - currently merged into ParseFunctionDeclaration
  Result := ParseFunctionDeclaration(AParser);
end;

function ParseParameterList(const AParser: TCPParser): TCPASTNodeList;
var
  LParameterNodes: TCPASTNodeList;
  LIndex: Integer;
begin
  Result := TCPASTNodeList.Create(False); // Don't own objects, they'll be owned by the function

  // Parse first parameter declaration (can contain multiple parameters)
  LParameterNodes := ParseParameterDeclaration(AParser);
  try
    for LIndex := 0 to LParameterNodes.Count - 1 do
      Result.Add(LParameterNodes[LIndex]);
  finally
    LParameterNodes.Free; // Free the list, not the nodes
  end;

  // Parse additional parameter declarations
  while AParser.MatchToken(tkSemicolon) do
  begin
    AParser.AdvanceToken(); // Consume semicolon

    // Check if this is the start of varargs (comma before ellipsis)
    if AParser.MatchToken(tkComma) then
      Break; // Let caller handle varargs

    LParameterNodes := ParseParameterDeclaration(AParser);
    try
      for LIndex := 0 to LParameterNodes.Count - 1 do
        Result.Add(LParameterNodes[LIndex]);
    finally
      LParameterNodes.Free; // Free the list, not the nodes
    end;
  end;
end;

function ParseParameterDeclaration(const AParser: TCPParser): TCPASTNodeList;
var
  LParameterNames: TStringList;
  LParameterType: TCPTypeNode;
  LIsConst: Boolean;
  LIsVar: Boolean;
  LIsOut: Boolean;
  LParameterNode: TCPParameterNode;
  LName: string;
begin
  Result := TCPASTNodeList.Create(False); // Don't own objects, they'll be owned by the function
  LParameterNames := TStringList.Create;
  try
    // Parse parameter modifiers
    LIsConst := False;
    LIsVar := False;
    LIsOut := False;

    if AParser.MatchToken(tkConst) then
    begin
      LIsConst := True;
      AParser.AdvanceToken();
    end
    else if AParser.MatchToken(tkVar) then
    begin
      LIsVar := True;
      AParser.AdvanceToken();
    end
    else if AParser.MatchToken(tkOut) then
    begin
      LIsOut := True;
      AParser.AdvanceToken();
    end;

    // Parse identifier list (comma-separated identifiers)
    if not AParser.MatchToken(tkIdentifier) then
      AParser.UnexpectedToken('parameter identifier');

    LParameterNames.Add(AParser.CurrentToken.Value);
    AParser.AdvanceToken();

    // Parse additional identifiers separated by commas
    while AParser.MatchToken(tkComma) do
    begin
      AParser.AdvanceToken(); // Consume comma
      if not AParser.MatchToken(tkIdentifier) then
        AParser.UnexpectedToken('parameter identifier');
      LParameterNames.Add(AParser.CurrentToken.Value);
      AParser.AdvanceToken();
    end;

    AParser.ConsumeToken(tkColon);

    // Parse parameter type
    LParameterType := ParseType(AParser);

    // Create parameter nodes for each identifier
    for LName in LParameterNames do
    begin
      // Create a separate type object for each parameter to avoid double-free
      LParameterNode := TCPParameterNode.Create(
        AParser.CurrentToken.Location,
        LName,
        TCPTypeNode.Create(LParameterType.Location, LParameterType.TypeName, LParameterType.IsPointer),
        LIsConst,
        LIsVar,
        LIsOut
      );
      Result.Add(LParameterNode);
    end;
    
    // Free the original type object since we created copies
    LParameterType.Free;
  finally
    LParameterNames.Free;
  end;
end;

end.

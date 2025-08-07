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

unit CPascal.Parser.CompilationUnit;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  CPascal.Lexer,
  CPascal.Parser,
  CPascal.AST,
  CPascal.AST.CompilationUnit,
  CPascal.AST.Statements,
  CPascal.AST.Expressions;

function ParseCompilationUnit(const AParser: TCPParser): TCPCompilationUnitNode;
function ParseProgramUnit(const AParser: TCPParser): TCPProgramNode;
function ParseLibraryUnit(const AParser: TCPParser): TCPLibraryNode;
function ParseModuleUnit(const AParser: TCPParser): TCPModuleNode;
function ParseProgramHeader(const AParser: TCPParser): string;
function ParseLibraryHeader(const AParser: TCPParser): string;
function ParseModuleHeader(const AParser: TCPParser): string;
function ParseExportsClause(const AParser: TCPParser): TCPASTNodeList;

implementation

uses
  CPascal.Parser.Declarations,
  CPascal.Parser.Statements;

function ParseCompilationUnit(const AParser: TCPParser): TCPCompilationUnitNode;
begin
  // Skip any leading comments and directives (handled by lexer)

  // Determine compilation unit type by first keyword
  case AParser.CurrentToken.Kind of
    tkProgram:
      Result := ParseProgramUnit(AParser);
    tkLibrary:
      Result := ParseLibraryUnit(AParser);
    tkModule:
      Result := ParseModuleUnit(AParser);
  else
    AParser.ParseError('Expected "program", "library", or "module", but found %s "%s"', [CPTokenKindToString(AParser.CurrentToken.Kind), AParser.CurrentToken.Value]);
    Result := nil;
  end;
end;

function ParseProgramUnit(const AParser: TCPParser): TCPProgramNode;
var
  LProgramName: string;
  LDeclarations: TCPASTNodeList;
  LMainBody: TCPCompoundStatementNode;
  LDeclaration: TCPASTNode;
  LIndex: Integer;
begin
  // Skip any leading comments and directives (handled by lexer)

  // Parse program header: "program" <identifier> ";"
  LProgramName := ParseProgramHeader(AParser);

  // Create program node
  Result := TCPProgramNode.Create(AParser.CurrentToken.Location, LProgramName);

  // Parse declarations (functions, constants, types, variables)
  LDeclarations := ParseDeclarations(AParser);

  try
    // Add declarations to program
    for LIndex := 0 to LDeclarations.Count - 1 do
    begin
      LDeclaration := LDeclarations[LIndex];
      Result.AddDeclaration(LDeclaration);
    end;

    // Parse main program body: <compound_statement>
    LMainBody := ParseCompoundStatement(AParser);
    Result.MainBody := LMainBody;

    // Expect program terminator: "."
    AParser.ConsumeToken(tkDot);

    // Expect end of file
    if not AParser.MatchToken(tkEOF) then
      AParser.ParseError('Expected end of file after program', []);

  finally
    LDeclarations.Free; // Free the temporary list (not the nodes, they're owned by Result)
  end;
end;

function ParseLibraryUnit(const AParser: TCPParser): TCPLibraryNode;
var
  LLibraryName: string;
  LDeclarations: TCPASTNodeList;
  LExports: TCPASTNodeList;
  LDeclaration: TCPASTNode;
  LExport: TCPASTNode;
  LIndex: Integer;
begin
  // Parse library header: "library" <identifier> ";"
  LLibraryName := ParseLibraryHeader(AParser);

  // Create library node
  Result := TCPLibraryNode.Create(AParser.CurrentToken.Location, LLibraryName);

  // Parse declarations (functions, constants, types, variables)
  LDeclarations := ParseDeclarations(AParser);

  try
    // Add declarations to library
    for LIndex := 0 to LDeclarations.Count - 1 do
    begin
      LDeclaration := LDeclarations[LIndex];
      Result.AddDeclaration(LDeclaration);
    end;

    // Parse optional exports clause
    if AParser.MatchToken(tkExports) then
    begin
      LExports := ParseExportsClause(AParser);
      for LIndex := 0 to LExports.Count - 1 do
      begin
        LExport := LExports[LIndex];
        Result.AddExport(LExport);
      end;
      LExports.Free;
    end;

    // Expect library terminator: "."
    AParser.ConsumeToken(tkDot);

    // Expect end of file
    if not AParser.MatchToken(tkEOF) then
      AParser.ParseError('Expected end of file after library', []);

  finally
    LDeclarations.Free; // Free the temporary list (not the nodes, they're owned by Result)
  end;
end;

function ParseModuleUnit(const AParser: TCPParser): TCPModuleNode;
var
  LModuleName: string;
  LDeclarations: TCPASTNodeList;
  LDeclaration: TCPASTNode;
  LIndex: Integer;
begin
  // Parse module header: "module" <identifier> ";"
  LModuleName := ParseModuleHeader(AParser);

  // Create module node
  Result := TCPModuleNode.Create(AParser.CurrentToken.Location, LModuleName);

  // Parse declarations (functions, constants, types, variables)
  LDeclarations := ParseDeclarations(AParser);

  try
    // Add declarations to module
    for LIndex := 0 to LDeclarations.Count - 1 do
    begin
      LDeclaration := LDeclarations[LIndex];
      Result.AddDeclaration(LDeclaration);
    end;

    // Expect module terminator: "."
    AParser.ConsumeToken(tkDot);

    // Expect end of file
    if not AParser.MatchToken(tkEOF) then
      AParser.ParseError('Expected end of file after module', []);

  finally
    LDeclarations.Free; // Free the temporary list (not the nodes, they're owned by Result)
  end;
end;

function ParseProgramHeader(const AParser: TCPParser): string;
begin
  // Parse: "program" <identifier> ";"
  AParser.ConsumeToken(tkProgram);

  if not AParser.MatchToken(tkIdentifier) then
    AParser.UnexpectedToken('program identifier');

  Result := AParser.CurrentToken.Value;
  AParser.AdvanceToken();

  AParser.ConsumeToken(tkSemicolon);
end;

function ParseLibraryHeader(const AParser: TCPParser): string;
begin
  // Parse: "library" <identifier> ";"
  AParser.ConsumeToken(tkLibrary);

  if not AParser.MatchToken(tkIdentifier) then
    AParser.UnexpectedToken('library identifier');

  Result := AParser.CurrentToken.Value;
  AParser.AdvanceToken();

  AParser.ConsumeToken(tkSemicolon);
end;

function ParseModuleHeader(const AParser: TCPParser): string;
begin
  // Parse: "module" <identifier> ";"
  AParser.ConsumeToken(tkModule);

  if not AParser.MatchToken(tkIdentifier) then
    AParser.UnexpectedToken('module identifier');

  Result := AParser.CurrentToken.Value;
  AParser.AdvanceToken();

  AParser.ConsumeToken(tkSemicolon);
end;

function ParseExportsClause(const AParser: TCPParser): TCPASTNodeList;
var
  LIdentifierName: string;
  LIdentifierNode: TCPIdentifierNode;
begin
  // Parse: "exports" <qualified_identifier_list> ";"
  Result := TCPASTNodeList.Create(False); // Don't own objects, they'll be owned by the library

  AParser.ConsumeToken(tkExports);

  // Parse first export identifier
  if not AParser.MatchToken(tkIdentifier) then
    AParser.UnexpectedToken('export identifier');

  LIdentifierName := AParser.CurrentToken.Value;
  LIdentifierNode := TCPIdentifierNode.Create(AParser.CurrentToken.Location, LIdentifierName);
  Result.Add(LIdentifierNode);
  AParser.AdvanceToken();

  // Parse additional export identifiers
  while AParser.MatchToken(tkComma) do
  begin
    AParser.AdvanceToken(); // Consume comma

    if not AParser.MatchToken(tkIdentifier) then
      AParser.UnexpectedToken('export identifier');

    LIdentifierName := AParser.CurrentToken.Value;
    LIdentifierNode := TCPIdentifierNode.Create(AParser.CurrentToken.Location, LIdentifierName);
    Result.Add(LIdentifierNode);
    AParser.AdvanceToken();
  end;

  AParser.ConsumeToken(tkSemicolon);
end;

end.

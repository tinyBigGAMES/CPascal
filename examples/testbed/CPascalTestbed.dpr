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

program CPascalTestbed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  UCPascalTestbed in 'UCPascalTestbed.pas',
  CPascal.AST.CompilationUnit in '..\..\src\CPascal.AST.CompilationUnit.pas',
  CPascal.AST.Declarations in '..\..\src\CPascal.AST.Declarations.pas',
  CPascal.AST.Directives in '..\..\src\CPascal.AST.Directives.pas',
  CPascal.AST.Expressions in '..\..\src\CPascal.AST.Expressions.pas',
  CPascal.AST.Functions in '..\..\src\CPascal.AST.Functions.pas',
  CPascal.AST in '..\..\src\CPascal.AST.pas',
  CPascal.AST.Statements in '..\..\src\CPascal.AST.Statements.pas',
  CPascal.AST.Types in '..\..\src\CPascal.AST.Types.pas',
  CPascal.CodeGen.CompilationUnit in '..\..\src\CPascal.CodeGen.CompilationUnit.pas',
  CPascal.CodeGen.Declarations in '..\..\src\CPascal.CodeGen.Declarations.pas',
  CPascal.CodeGen.Directives in '..\..\src\CPascal.CodeGen.Directives.pas',
  CPascal.CodeGen.Expressions in '..\..\src\CPascal.CodeGen.Expressions.pas',
  CPascal.CodeGen.Functions in '..\..\src\CPascal.CodeGen.Functions.pas',
  CPascal.CodeGen.JIT in '..\..\src\CPascal.CodeGen.JIT.pas',
  CPascal.CodeGen in '..\..\src\CPascal.CodeGen.pas',
  CPascal.CodeGen.Statements in '..\..\src\CPascal.CodeGen.Statements.pas',
  CPascal.CodeGen.SymbolTable in '..\..\src\CPascal.CodeGen.SymbolTable.pas',
  CPascal.CodeGen.Types in '..\..\src\CPascal.CodeGen.Types.pas',
  CPascal.Compiler in '..\..\src\CPascal.Compiler.pas',
  CPascal.Exception in '..\..\src\CPascal.Exception.pas',
  CPascal.Lexer in '..\..\src\CPascal.Lexer.pas',
  CPascal.LLVM in '..\..\src\CPascal.LLVM.pas',
  CPascal.Parser.CompilationUnit in '..\..\src\CPascal.Parser.CompilationUnit.pas',
  CPascal.Parser.Declarations in '..\..\src\CPascal.Parser.Declarations.pas',
  CPascal.Parser.Directives in '..\..\src\CPascal.Parser.Directives.pas',
  CPascal.Parser.Expressions in '..\..\src\CPascal.Parser.Expressions.pas',
  CPascal.Parser.Functions in '..\..\src\CPascal.Parser.Functions.pas',
  CPascal.Parser.Lexical in '..\..\src\CPascal.Parser.Lexical.pas',
  CPascal.Parser in '..\..\src\CPascal.Parser.pas',
  CPascal.Parser.Statements in '..\..\src\CPascal.Parser.Statements.pas',
  CPascal.Parser.Types in '..\..\src\CPascal.Parser.Types.pas',
  CPascal.Parser.Variables in '..\..\src\CPascal.Parser.Variables.pas',
  CPascal in '..\..\src\CPascal.pas',
  CPascal.Platform in '..\..\src\CPascal.Platform.pas';

begin
  RunCPascalTestbed();
end.

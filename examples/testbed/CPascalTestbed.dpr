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
  CPascal.Builder in '..\..\src\CPascal.Builder.pas',
  CPascal.Common in '..\..\src\CPascal.Common.pas',
  CPascal.Expressions in '..\..\src\CPascal.Expressions.pas',
  CPascal.LLVM in '..\..\src\CPascal.LLVM.pas',
  CPascal in '..\..\src\CPascal.pas',
  CPascal.Platform in '..\..\src\CPascal.Platform.pas',
  CPascal.Builder.Interfaces in '..\..\src\CPascal.Builder.Interfaces.pas',
  CPascal.Builder.Source in '..\..\src\CPascal.Builder.Source.pas',
  CPascal.Builder.IR in '..\..\src\CPascal.Builder.IR.pas',
  CPascal.Tests.CompilerDirectives in '..\..\src\tests\CPascal.Tests.CompilerDirectives.pas',
  CPascal.Tests.ControlFlow in '..\..\src\tests\CPascal.Tests.ControlFlow.pas',
  CPascal.Tests.Declarations in '..\..\src\tests\CPascal.Tests.Declarations.pas',
  CPascal.Tests.Expressions in '..\..\src\tests\CPascal.Tests.Expressions.pas',
  CPascal.Tests.Functions in '..\..\src\tests\CPascal.Tests.Functions.pas',
  CPascal.Tests.Infrastructure in '..\..\src\tests\CPascal.Tests.Infrastructure.pas',
  CPascal.Tests.Modules in '..\..\src\tests\CPascal.Tests.Modules.pas',
  CPascal.Tests in '..\..\src\tests\CPascal.Tests.pas',
  CPascal.Tests.Structure in '..\..\src\tests\CPascal.Tests.Structure.pas',
  CPascal.Tests.Types in '..\..\src\tests\CPascal.Tests.Types.pas';

begin
  RunCPascalTestbed();
end.

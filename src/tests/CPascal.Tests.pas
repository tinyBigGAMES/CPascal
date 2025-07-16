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

unit CPascal.Tests;

{$I CPascal.Defines.inc}

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal,
  CPascal.Tests.Infrastructure,
  CPascal.Tests.Declarations,
  CPascal.Tests.Structure,
  CPascal.Tests.ControlFlow,
  CPascal.Tests.CompilerDirectives,
  CPascal.Tests.Modules,
  CPascal.Tests.Expressions,
  CPascal.Tests.Types,
  CPascal.Tests.Functions;

procedure TestFullSuite(const ANumber: Integer = 0);

implementation

procedure TestFullSuite(const ANumber: Integer);
begin
  case ANumber of
    // Infrastructure Tests
    01: TestBuilderFoundation();
    
    // Core Language Features
    02: TestCoreDeclarationMethods();
    03: TestAdvancedDeclarationMethods();
    04: TestBasicProgramStructure();
    05: TestUtilityStructureMethods();
    06: TestAdvancedControlFlow();
    07: TestAdvancedStatementMethods();
    
    // Advanced Language Features
    08: TestCompilerDirectives();
    09: TestModules();
    10: TestExpressions();
    
    // Additional Tests
    11: TestConstantsAndTypeSystem();
    12: TestAdvancedStatementsAndFunctionSystem();
  else
    begin
      WriteLn('🚀 Running Complete CPascal Test Suite...');
      WriteLn('');
      
      // Run ALL tests sequentially
      WriteLn('📋 === RUNNING ALL TESTS ===');
      WriteLn('');
      
      WriteLn('01 - Infrastructure Tests');
      TestBuilderFoundation();
      WriteLn('');
      
      WriteLn('02 - Core Declaration Methods');
      TestCoreDeclarationMethods();
      WriteLn('');
      
      WriteLn('03 - Advanced Declaration Methods');
      TestAdvancedDeclarationMethods();
      WriteLn('');
      
      WriteLn('04 - Basic Program Structure');
      TestBasicProgramStructure();
      WriteLn('');
      
      WriteLn('05 - Utility Structure Methods');
      TestUtilityStructureMethods();
      WriteLn('');
      
      WriteLn('06 - Advanced Control Flow');
      TestAdvancedControlFlow();
      WriteLn('');
      
      WriteLn('07 - Advanced Statement Methods');
      TestAdvancedStatementMethods();
      WriteLn('');
      
      WriteLn('08 - Compiler Directives');
      TestCompilerDirectives();
      WriteLn('');
      
      WriteLn('09 - Modules');
      TestModules();
      WriteLn('');
      
      WriteLn('10 - Expressions');
      TestExpressions();
      WriteLn('');
      
      WriteLn('11 - Constants and Type System');
      TestConstantsAndTypeSystem();
      WriteLn('');
      
      WriteLn('12 - Advanced Statements and Function System');
      TestAdvancedStatementsAndFunctionSystem();
      WriteLn('');
      
      WriteLn('✅ Complete CPascal Test Suite Finished!');
      WriteLn('📊 Total Tests Run: 12 test procedures from 9 test units');
    end;
  end;
end;


end.
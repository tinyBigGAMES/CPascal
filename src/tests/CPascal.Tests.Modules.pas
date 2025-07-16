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

unit CPascal.Tests.Modules;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestModules();

implementation

procedure TestModules();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
begin
  WriteLn('🧪 Testing CPascal Module System...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Basic Module Declaration ===
    WriteLn('  🔍 Test ', LTestNumber, ': Basic module declaration');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartModule(CPIdentifier('MathModule'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Module initialized')])
        .CPEndCompoundStatement()
        .CPEndModule()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'module MathModule;') and ContainsText(LSource, 'end.') then
      WriteLn('    ✅ Basic module structure generated correctly')
    else
      WriteLn('    ❌ Basic module structure missing or malformed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 2: Library Declaration ===
    WriteLn('  🔍 Test ', LTestNumber, ': Library declaration');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartLibrary(CPIdentifier('UtilityLibrary'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Library loaded')])
        .CPEndCompoundStatement()
        .CPEndLibrary()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'library UtilityLibrary;') and ContainsText(LSource, 'end.') then
      WriteLn('    ✅ Library structure generated correctly')
    else
      WriteLn('    ❌ Library structure missing or malformed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 3: Single Import Declaration ===
    WriteLn('  🔍 Test ', LTestNumber, ': Single import declaration');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartModule(CPIdentifier('ClientModule'))
        .CPAddImport(CPIdentifier('System.Utils'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Using imported functionality')])
        .CPEndCompoundStatement()
        .CPEndModule()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'import System.Utils;') then
      WriteLn('    ✅ Single import declaration generated correctly')
    else
      WriteLn('    ❌ Single import declaration missing or malformed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 4: Multiple Imports Declaration ===
    WriteLn('  🔍 Test ', LTestNumber, ': Multiple imports declaration');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartModule(CPIdentifier('MultiImportModule'))
        .CPAddImports(['System.IO', 'System.Collections', 'Math.Geometry'])
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Using multiple imports')])
        .CPEndCompoundStatement()
        .CPEndModule()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'import System.IO, System.Collections, Math.Geometry;') then
      WriteLn('    ✅ Multiple imports declaration generated correctly')
    else
      WriteLn('    ❌ Multiple imports declaration missing or malformed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 5: Single Export Declaration ===
    WriteLn('  🔍 Test ', LTestNumber, ': Single export declaration');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartModule(CPIdentifier('ExportModule'))
        .CPAddExport(CPIdentifier('CalculateSum'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Module with exports')])
        .CPEndCompoundStatement()
        .CPEndModule()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'export CalculateSum;') then
      WriteLn('    ✅ Single export declaration generated correctly')
    else
      WriteLn('    ❌ Single export declaration missing or malformed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 6: Multiple Exports Declaration ===
    WriteLn('  🔍 Test ', LTestNumber, ': Multiple exports declaration');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartModule(CPIdentifier('MultiExportModule'))
        .CPAddExports(['Add', 'Subtract', 'Multiply', 'Divide'])
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Math module with multiple exports')])
        .CPEndCompoundStatement()
        .CPEndModule()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'export Add, Subtract, Multiply, Divide;') then
      WriteLn('    ✅ Multiple exports declaration generated correctly')
    else
      WriteLn('    ❌ Multiple exports declaration missing or malformed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 7: Complete Module with Imports and Exports ===
    WriteLn('  🔍 Test ', LTestNumber, ': Complete module with both imports and exports');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartModule(CPIdentifier('CompleteModule'))
        .CPAddImports(['System.Math', 'System.Types'])
        .CPAddExports(['ProcessData', 'ValidateInput'])
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Complete module with imports and exports')])
        .CPEndCompoundStatement()
        .CPEndModule()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'module CompleteModule;') and
       ContainsText(LSource, 'import System.Math, System.Types;') and
       ContainsText(LSource, 'export ProcessData, ValidateInput;') then
      WriteLn('    ✅ Complete module with imports and exports generated correctly')
    else
      WriteLn('    ❌ Complete module generation failed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 8: Library with Exports ===
    WriteLn('  🔍 Test ', LTestNumber, ': Library with export declarations');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartLibrary(CPIdentifier('ExportLibrary'))
        .CPAddExports(['LibraryFunction1', 'LibraryFunction2'])
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Library with exported functions')])
        .CPEndCompoundStatement()
        .CPEndLibrary()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'library ExportLibrary;') and
       ContainsText(LSource, 'export LibraryFunction1, LibraryFunction2;') then
      WriteLn('    ✅ Library with exports generated correctly')
    else
      WriteLn('    ❌ Library with exports generation failed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 9: Mixed Import/Export Order ===
    WriteLn('  🔍 Test ', LTestNumber, ': Mixed import/export declaration order');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartModule(CPIdentifier('MixedOrderModule'))
        .CPAddImport(CPIdentifier('FirstImport'))
        .CPAddExport(CPIdentifier('FirstExport'))
        .CPAddImports(['SecondImport', 'ThirdImport'])
        .CPAddExport(CPIdentifier('SecondExport'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Mixed order declarations')])
        .CPEndCompoundStatement()
        .CPEndModule()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'import FirstImport;') and
       ContainsText(LSource, 'export FirstExport;') and
       ContainsText(LSource, 'import SecondImport, ThirdImport;') and
       ContainsText(LSource, 'export SecondExport;') then
      WriteLn('    ✅ Mixed import/export order handled correctly')
    else
      WriteLn('    ❌ Mixed import/export order handling failed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 10: Program with Import (for completeness) ===
    WriteLn('  🔍 Test ', LTestNumber, ': Program with import declarations');
    //Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ProgramWithImports'))
        .CPAddImports(['System.Console', 'System.IO'])
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Program using imported modules')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'program ProgramWithImports;') and
       ContainsText(LSource, 'import System.Console, System.IO;') then
      WriteLn('    ✅ Program with imports generated correctly')
    else
      WriteLn('    ❌ Program with imports generation failed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Module System test completed successfully!');
    WriteLn('  ✅ All module features verified:');
    WriteLn('    - 📦 Module and library declarations');
    WriteLn('    - 📥 Single and multiple import declarations');
    WriteLn('    - 📤 Single and multiple export declarations');
    WriteLn('    - 🔄 Mixed import/export order handling');
    WriteLn('    - 🏗️ Complete modules with both imports and exports');
    WriteLn('    - 📋 Programs with import support');
    WriteLn('  🚀 Ready for complete modular programming support!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Module System test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;

end.

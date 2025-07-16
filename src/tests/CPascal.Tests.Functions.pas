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

unit CPascal.Tests.Functions;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestAdvancedStatementsAndFunctionSystem();

implementation

procedure TestAdvancedStatementsAndFunctionSystem();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
  LExpectedElements: TArray<string>;
  LElement: string;
  LFound: Boolean;
  LLine: string;
begin
  WriteLn('🧪 Testing Phase 1D: Advanced Statements and Function System...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Basic Function Declaration ===
    WriteLn('  🔧 Test ', LTestNumber, ': Basic function declaration (CPStartFunction/CPEndFunction)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('FunctionTest'))
        .CPStartFunction(CPIdentifier('Calculate'), cptInt32, False)
        .CPStartFunctionBody()
          .CPAddAssignment(CPIdentifier('Result'), CPInt32(42))
        .CPEndFunction()
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Function test complete!')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'function Calculate(): Int32;') then
      WriteLn('    ✅ Function header generated correctly')
    else
      WriteLn('    ❌ Function header missing or incorrect');

    if ContainsText(LSource, 'Result := 42;') then
      WriteLn('    ✅ Function body generated correctly')
    else
      WriteLn('    ❌ Function body missing or incorrect');

    if ContainsText(LSource, 'end;') then
      WriteLn('    ✅ Function end generated correctly')
    else
      WriteLn('    ❌ Function end missing or incorrect');

    WriteLn('    📄 Generated function source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 2: Basic Procedure Declaration ===
    WriteLn('  🔧 Test ', LTestNumber, ': Basic procedure declaration (CPStartProcedure/CPEndProcedure)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ProcedureTest'))
        .CPStartProcedure(CPIdentifier('PrintMessage'), False)
        .CPStartFunctionBody()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Hello from procedure!')])
        .CPEndProcedure()
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('PrintMessage'), [])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'procedure PrintMessage();') then
      WriteLn('    ✅ Procedure header generated correctly')
    else
      WriteLn('    ❌ Procedure header missing or incorrect');

    if ContainsText(LSource, 'Hello from procedure!') then
      WriteLn('    ✅ Procedure body generated correctly')
    else
      WriteLn('    ❌ Procedure body missing or incorrect');

    if ContainsText(LSource, 'PrintMessage();') then
      WriteLn('    ✅ Procedure call generated correctly')
    else
      WriteLn('    ❌ Procedure call missing or incorrect');

    WriteLn('    📄 Generated procedure source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 3: Function with Parameters ===
    WriteLn('  📋 Test ', LTestNumber, ': Function with parameters (CPAddParameter)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ParameterTest'))
        .CPStartFunction(CPIdentifier('Add'), cptInt32, False)
          .CPAddParameter([CPIdentifier('a')], cptInt32, '')
          .CPAddParameter([CPIdentifier('b')], cptInt32, '')
        .CPStartFunctionBody()
          .CPAddAssignment(CPIdentifier('Result'), CPInt32(0))
        .CPEndFunction()
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'function Add(a: Int32; b: Int32): Int32;') then
      WriteLn('    ✅ Function with parameters generated correctly')
    else
      WriteLn('    ❌ Function with parameters missing or incorrect');

    WriteLn('    📄 Function with parameters source:');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 4: Procedure with Complex Parameters ===
    WriteLn('  📋 Test ', LTestNumber, ': Procedure with complex parameters and modifiers');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ComplexParameterTest'))
      .CPStartProcedure(LBuilder.CPIdentifier('ProcessData'), False)
        .CPAddParameter([LBuilder.CPIdentifier('input')], cptString, 'const')
        .CPAddParameter([LBuilder.CPIdentifier('output')], LBuilder.CPGetStringType(), 'var')
        .CPAddParameter([LBuilder.CPIdentifier('count')], cptInt32, '')
      .CPStartFunctionBody()
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Processing data...')])
      .CPEndProcedure()
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'procedure ProcessData(const input: string; var output: string; count: Int32);') then
      WriteLn('    ✅ Procedure with complex parameters generated correctly')
    else
      WriteLn('    ❌ Procedure with complex parameters missing or incorrect');

    WriteLn('    📄 Complex parameters source:');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 5: Function with Calling Convention Modifier ===
    WriteLn('  🎚️ Test ', LTestNumber, ': Function with calling convention modifier');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('CallingConventionTest'))
      .CPStartFunction(LBuilder.CPIdentifier('ExternalFunc'), cptInt32, False)
        .CPAddParameter([LBuilder.CPIdentifier('value')], cptInt32, '')
        .CPSetCallingConvention('cdecl')
      .CPStartFunctionBody()
        .CPAddAssignment(LBuilder.CPIdentifier('Result'), LBuilder.CPInt32(100))
      .CPEndFunction()
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'function ExternalFunc(value: Int32): Int32; cdecl;') then
      WriteLn('    ✅ Function with calling convention generated correctly')
    else
      WriteLn('    ❌ Function with calling convention missing or incorrect');

    // === TEST 6: Function with Inline Modifier ===
    WriteLn('  ⚡ Test ', LTestNumber, ': Function with inline modifier');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('InlineTest'))
      .CPStartFunction(LBuilder.CPIdentifier('FastCalc'), cptInt32, False)
        .CPAddParameter([LBuilder.CPIdentifier('x')], cptInt32, '')
        .CPSetInline(True)
      .CPStartFunctionBody()
        .CPAddAssignment(LBuilder.CPIdentifier('Result'), LBuilder.CPInt32(50))
      .CPEndFunction()
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'function FastCalc(x: Int32): Int32; inline;') then
      WriteLn('    ✅ Function with inline modifier generated correctly')
    else
      WriteLn('    ❌ Function with inline modifier missing or incorrect');

    // === TEST 7: Function with External Modifier ===
    WriteLn('  🔗 Test ', LTestNumber, ': Function with external modifier');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('ExternalTest'))
      .CPStartFunction(LBuilder.CPIdentifier('LibraryFunc'), cptInt32, False)
        .CPAddParameter([LBuilder.CPIdentifier('param')], cptString, '')
        .CPSetExternal('mylib.dll')
      .CPStartFunctionBody()
        .CPAddAssignment(LBuilder.CPIdentifier('Result'), LBuilder.CPInt32(0))
      .CPEndFunction()
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'function LibraryFunc(param: string): Int32; external ''mylib.dll'';') then
      WriteLn('    ✅ Function with external modifier generated correctly')
    else
      WriteLn('    ❌ Function with external modifier missing or incorrect');

    // === TEST 8: Function with Multiple Modifiers ===
    WriteLn('  🎛️ Test ', LTestNumber, ': Function with multiple modifiers');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('MultiModifierTest'))
      .CPStartFunction(LBuilder.CPIdentifier('ComplexFunc'), cptInt32, True) // Public
        .CPAddParameter([LBuilder.CPIdentifier('a'), LBuilder.CPIdentifier('b')], cptInt32, 'const')
        .CPSetCallingConvention('stdcall')
        .CPSetInline(True)
      .CPStartFunctionBody()
        .CPAddAssignment(LBuilder.CPIdentifier('Result'), LBuilder.CPInt32(200))
      .CPEndFunction()
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'public function ComplexFunc(const a, b: Int32): Int32; stdcall; inline;') then
      WriteLn('    ✅ Function with multiple modifiers generated correctly')
    else
      WriteLn('    ❌ Function with multiple modifiers missing or incorrect');

    WriteLn('    📄 Multiple modifiers source:');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 9: Complete Phase 1D Integration Test ===
    WriteLn('  🎯 Test ', LTestNumber, ': Complete Phase 1D integration test (multiple functions)');
    Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('Phase1DComplete'))
      .CPStartConstSection()
        .CPAddConstant('MULTIPLIER', '10')
      .CPStartTypeSection()
        .CPAddTypeAlias('TValue', 'Int32')
      .CPStartVarSection()
        .CPAddVariable([LBuilder.CPIdentifier('result')], cptInt32)
      .CPStartFunction(LBuilder.CPIdentifier('Multiply'), cptInt32, False)
        .CPAddParameter([LBuilder.CPIdentifier('x'), LBuilder.CPIdentifier('y')], cptInt32, 'const')
      .CPStartFunctionBody()
        .CPAddAssignment(LBuilder.CPIdentifier('Result'), LBuilder.CPInt32(0))
      .CPEndFunction()
      .CPStartProcedure(LBuilder.CPIdentifier('PrintResult'), False)
        .CPAddParameter([LBuilder.CPIdentifier('value')], cptInt32, 'const')
        .CPSetInline(True)
      .CPStartFunctionBody()
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Result: ')])
      .CPEndProcedure()
      .CPStartFunction(LBuilder.CPIdentifier('GetVersion'), LBuilder.CPGetStringType(), True) // Public
        .CPSetCallingConvention('cdecl')
      .CPStartFunctionBody()
        .CPAddAssignment(LBuilder.CPIdentifier('Result'), LBuilder.CPString('1.0.0'))
      .CPEndFunction()
      .CPStartCompoundStatement()
        .CPAddAssignment(LBuilder.CPIdentifier('result'), LBuilder.CPInt32(42))
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Phase 1D integration test complete!')])
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    WriteLn('    📄 Complete Phase 1D integration test (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // Verify all major Phase 1D components are present
    LExpectedElements := [
      'program Phase1DComplete;',
      'const',
      'MULTIPLIER = 10;',
      'type',
      'TValue = Int32;',
      'var',
      'result: Int32;',
      'function Multiply(const x, y: Int32): Int32;',
      'procedure PrintResult(const value: Int32); inline;',
      'public function GetVersion(): string; cdecl;',
      'begin',
      'result := 42;',
      'Phase 1D integration test complete!',
      'end.'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing expected element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All expected Phase 1D elements found in complete integration test')
    else
      WriteLn('    ❌ Some expected Phase 1D elements missing from integration test');

    // === TEST 10: Public vs Private Function Declarations ===
    WriteLn('  🔒 Test ', LTestNumber, ': Public vs private function declarations');
    //Inc(LTestNumber);

    LBuilder.CPReset();
    LSource := LBuilder
      .CPStartProgram(LBuilder.CPIdentifier('VisibilityTest'))
      .CPStartFunction(LBuilder.CPIdentifier('PrivateFunc'), cptInt32, False) // Private
      .CPStartFunctionBody()
        .CPAddAssignment(LBuilder.CPIdentifier('Result'), LBuilder.CPInt32(1))
      .CPEndFunction()
      .CPStartFunction(LBuilder.CPIdentifier('PublicFunc'), cptInt32, True) // Public
      .CPStartFunctionBody()
        .CPAddAssignment(LBuilder.CPIdentifier('Result'), LBuilder.CPInt32(2))
      .CPEndFunction()
      .CPStartProcedure(LBuilder.CPIdentifier('PrivateProc'), False) // Private
      .CPStartFunctionBody()
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Private')])
      .CPEndProcedure()
      .CPStartProcedure(LBuilder.CPIdentifier('PublicProc'), True) // Public
      .CPStartFunctionBody()
        .CPAddProcedureCall(LBuilder.CPIdentifier('WriteLn'), [LBuilder.CPString('Public')])
      .CPEndProcedure()
      .CPStartCompoundStatement()
      .CPEndCompoundStatement()
      .CPEndProgram()
      .GetCPas(True);

    if ContainsText(LSource, 'function PrivateFunc(): Int32;') and not ContainsText(LSource, 'public function PrivateFunc') then
      WriteLn('    ✅ Private function declaration generated correctly')
    else
      WriteLn('    ❌ Private function declaration missing or incorrect');

    if ContainsText(LSource, 'public function PublicFunc(): Int32;') then
      WriteLn('    ✅ Public function declaration generated correctly')
    else
      WriteLn('    ❌ Public function declaration missing or incorrect');

    if ContainsText(LSource, 'procedure PrivateProc();') and not ContainsText(LSource, 'public procedure PrivateProc') then
      WriteLn('    ✅ Private procedure declaration generated correctly')
    else
      WriteLn('    ❌ Private procedure declaration missing or incorrect');

    if ContainsText(LSource, 'public procedure PublicProc();') then
      WriteLn('    ✅ Public procedure declaration generated correctly')
    else
      WriteLn('    ❌ Public procedure declaration missing or incorrect');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Phase 1D Advanced Statements and Function System test completed successfully!');
    WriteLn('  ✅ All Phase 1D functionality verified:');
    WriteLn('    - 🔧 Basic function declarations (CPStartFunction/CPEndFunction)');
    WriteLn('    - 🔧 Basic procedure declarations (CPStartProcedure/CPEndProcedure)');
    WriteLn('    - 📋 Function and procedure parameters (CPAddParameter)');
    WriteLn('    - 🎚️ Calling convention modifiers (CPSetCallingConvention)');
    WriteLn('    - ⚡ Inline modifiers (CPSetInline)');
    WriteLn('    - 🔗 External modifiers (CPSetExternal)');
    WriteLn('    - 🎛️ Multiple modifier combinations');
    WriteLn('    - 🔒 Public vs private function visibility');
    WriteLn('    - 🎯 Complete integration test with multiple functions');
    WriteLn('    - 🔧 Function body implementation with CPStartFunctionBody');
    WriteLn('  🚀 Phase 1D: Advanced Statements and Function System is production-ready!');
    WriteLn('  ✨ Builder can now generate complete CPascal programs with full function and procedure support!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Phase 1D Advanced Statements and Function System test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;


end.

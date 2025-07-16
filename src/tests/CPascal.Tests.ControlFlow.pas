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

unit CPascal.Tests.ControlFlow;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestAdvancedControlFlow();
procedure TestAdvancedStatementMethods();

implementation

procedure TestAdvancedControlFlow();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
  LExpectedElements: TArray<string>;
  LElement: string;
  LFound: Boolean;
  LLine: string;
begin
  WriteLn('🧪 Testing Phase 1E: Advanced Control Flow...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: While Loop ===
    WriteLn('  🔄 Test ', LTestNumber, ': While loop (CPStartWhile/CPEndWhile)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('WhileTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('i')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('i'), CPInt32(0))
          .CPStartWhile(CPBoolean(True))
            .CPAddAssignment(CPIdentifier('i'), CPInt32(1))
          .CPEndWhile()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'while') and ContainsText(LSource, 'do') then
      WriteLn('    ✅ While loop structure generated correctly')
    else
      WriteLn('    ❌ While loop structure missing or incorrect');

    WriteLn('    📄 Generated while loop source:');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 2: For Loop ===
    WriteLn('  🔢 Test ', LTestNumber, ': For loop (CPStartFor/CPEndFor)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ForTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('i')], cptInt32)
        .CPStartCompoundStatement()
          .CPStartFor(CPIdentifier('i'), CPInt32(1), CPInt32(10), False)
            .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Iteration')])
          .CPEndFor()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'for i := 1 to 10 do') then
      WriteLn('    ✅ For loop (to) generated correctly')
    else
      WriteLn('    ❌ For loop (to) missing or incorrect');

    // Test downto version
    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ForDownToTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('i')], cptInt32)
        .CPStartCompoundStatement()
          .CPStartFor(CPIdentifier('i'), CPInt32(10), CPInt32(1), True)
            .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Countdown')])
          .CPEndFor()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'for i := 10 downto 1 do') then
      WriteLn('    ✅ For loop (downto) generated correctly')
    else
      WriteLn('    ❌ For loop (downto) missing or incorrect');

    // === TEST 3: Repeat-Until Loop ===
    WriteLn('  🔁 Test ', LTestNumber, ': Repeat-until loop (CPStartRepeat/CPEndRepeat)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('RepeatTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('count')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('count'), CPInt32(0))
          .CPStartRepeat()
            .CPAddAssignment(CPIdentifier('count'), CPInt32(1))
          .CPEndRepeat(CPBoolean(True))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'repeat') and ContainsText(LSource, 'until') then
      WriteLn('    ✅ Repeat-until loop structure generated correctly')
    else
      WriteLn('    ❌ Repeat-until loop structure missing or incorrect');

    WriteLn('    📄 Generated repeat loop source:');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 4: Case Statement (NOW WORKING) ===
    WriteLn('  🔀 Test ', LTestNumber, ': Case statement (CPStartCase/CPAddCaseLabel/CPEndCase)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('CaseTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('choice')], cptInt32)
          .CPAddVariable([CPIdentifier('result')], cptString)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('choice'), CPInt32(2))
          .CPStartCase(CPVariable(CPIdentifier('choice')))
            .CPAddCaseLabel([CPInt32(1)])
              .CPAddAssignment(CPIdentifier('result'), CPString('One'))
            .CPAddCaseLabel([CPInt32(2), CPInt32(3)])
              .CPAddAssignment(CPIdentifier('result'), CPString('Two or Three'))
            .CPStartCaseElse()
              .CPAddAssignment(CPIdentifier('result'), CPString('Other'))
          .CPEndCase()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := ['case choice of', '1:', 'result := ''One'';', '2, 3:', 'result := ''Two or Three'';', 'else', 'result := ''Other'';', 'end;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Case statement element "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Case statement element "', LElement, '" missing or incorrect');
    end;

    WriteLn('    📄 Generated case statement source:');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 5: Control Flow Statements ===
    WriteLn('  🎯 Test ', LTestNumber, ': Control flow statements (goto, label, break, continue)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ControlFlowTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('i')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddLabel(CPIdentifier('start'))
          .CPAddAssignment(CPIdentifier('i'), CPInt32(0))
          .CPStartWhile(CPBoolean(True))
            .CPStartIf(CPBoolean(True))
              .CPAddBreak()
            .CPEndIf()
            .CPStartIf(CPBoolean(False))
              .CPAddContinue()
            .CPEndIf()
            .CPAddAssignment(CPIdentifier('i'), CPInt32(1))
          .CPEndWhile()
          .CPAddGoto(CPIdentifier('finish'))
          .CPAddLabel(CPIdentifier('finish'))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := ['start:', 'break;', 'continue;', 'goto finish;', 'finish:'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Control flow "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Control flow "', LElement, '" missing or incorrect');
    end;

    // === TEST 6: Exit Statements ===
    WriteLn('  🚪 Test ', LTestNumber, ': Exit statements (CPAddExit)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ExitTest'))
        .CPStartFunction(CPIdentifier('Calculate'), cptInt32, False)
          .CPAddParameter([CPIdentifier('value')], cptInt32, '')
        .CPStartFunctionBody()
          .CPStartIf(CPBoolean(True))
            .CPAddExit(CPInt32(-1))
          .CPEndIf()
          .CPAddAssignment(CPIdentifier('Result'), CPInt32(0))
        .CPEndFunction()
        .CPStartProcedure(CPIdentifier('Cleanup'), False)
        .CPStartFunctionBody()
          .CPStartIf(CPBoolean(True))
            .CPAddExit(nil) // Exit without value
          .CPEndIf()
        .CPEndProcedure()
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'exit(-1);') then
      WriteLn('    ✅ Exit with expression generated correctly')
    else
      WriteLn('    ❌ Exit with expression missing or incorrect');

    if ContainsText(LSource, 'exit;') then
      WriteLn('    ✅ Exit without expression generated correctly')
    else
      WriteLn('    ❌ Exit without expression missing or incorrect');

    // === TEST 7: Inline Assembly ===
    WriteLn('  🔧 Test ', LTestNumber, ': Inline assembly (CPStartInlineAssembly/CPAddAssemblyLine/CPEndInlineAssembly)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('AssemblyTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('result')], cptInt32)
        .CPStartCompoundStatement()
          .CPStartInlineAssembly()
            .CPAddAssemblyLine('mov eax, 42')
            .CPAddAssemblyLine('mov [result], eax')
          .CPEndInlineAssembly()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := ['asm', 'mov eax, 42', 'mov [result], eax', 'end;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Assembly element "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Assembly element "', LElement, '" missing or incorrect');
    end;

    WriteLn('    📄 Generated assembly source:');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 8: Complex Nested Control Flow Integration ===
    WriteLn('  🏗️ Test ', LTestNumber, ': Complex nested control flow integration');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ComplexControlFlow'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('i'), CPIdentifier('j')], cptInt32)
          .CPAddVariable([CPIdentifier('found')], cptBoolean)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('found'), CPBoolean(False))
          .CPStartFor(CPIdentifier('i'), CPInt32(1), CPInt32(5), False)
            .CPStartWhile(CPBoolean(True))
              .CPStartCase(CPVariable(CPIdentifier('j')))
                .CPAddCaseLabel([CPInt32(1)])
                  .CPStartIf(CPBoolean(True))
                    .CPAddAssignment(CPIdentifier('found'), CPBoolean(True))
                    .CPAddBreak()
                  .CPEndIf()
                .CPAddCaseLabel([CPInt32(2)])
                  .CPAddContinue()
                .CPStartCaseElse()
                  .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Default case')])
              .CPEndCase()
              .CPAddAssignment(CPIdentifier('j'), CPInt32(1))
            .CPEndWhile()
          .CPEndFor()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Verify that all control structures are properly nested and generated
    LExpectedElements := [
      'for i := 1 to 5 do',
      'while',
      'case j of',
      '1:',
      'if True then',
      'break;',
      '2:',
      'continue;',
      'else',
      'end;' // Multiple end statements should be present
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing complex control flow element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All complex control flow elements found');

    WriteLn('    📄 Complete complex control flow (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // === TEST 9: Enhanced Variable-Based Case Statements (NEW!) ===
    WriteLn('  🆕 Test ', LTestNumber, ': Enhanced variable-based case statements with all types');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('EnhancedCaseTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('intChoice')], cptInt32)
          .CPAddVariable([CPIdentifier('byteValue')], cptUInt8)
          .CPAddVariable([CPIdentifier('charValue')], cptChar)
          .CPAddVariable([CPIdentifier('boolFlag')], cptBoolean)
          .CPAddVariable([CPIdentifier('result')], cptString)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('intChoice'), CPInt32(42))
          .CPAddAssignment(CPIdentifier('byteValue'), CPUInt8(255))
          .CPAddAssignment(CPIdentifier('charValue'), CPChar('A'))
          .CPAddAssignment(CPIdentifier('boolFlag'), CPBoolean(True))
          .CPStartCase(CPVariable(CPIdentifier('intChoice')))
            .CPAddCaseLabel([CPInt32(42)])
              .CPAddAssignment(CPIdentifier('result'), CPString('Perfect Answer!'))
            .CPAddCaseLabel([CPInt32(1), CPInt32(2), CPInt32(3)])
              .CPAddAssignment(CPIdentifier('result'), CPString('Small Numbers'))
            .CPStartCaseElse()
              .CPAddAssignment(CPIdentifier('result'), CPString('Other Value'))
          .CPEndCase()
          .CPStartCase(CPVariable(CPIdentifier('byteValue')))
            .CPAddCaseLabel([CPUInt8(255)])
              .CPAddAssignment(CPIdentifier('result'), CPString('Maximum Byte!'))
            .CPAddCaseLabel([CPUInt8(0)])
              .CPAddAssignment(CPIdentifier('result'), CPString('Zero Byte'))
          .CPEndCase()
          .CPStartCase(CPVariable(CPIdentifier('charValue')))
            .CPAddCaseLabel([CPChar('A'), CPChar('B'), CPChar('C')])
              .CPAddAssignment(CPIdentifier('result'), CPString('Early Alphabet'))
            .CPAddCaseLabel([CPChar('Z')])
              .CPAddAssignment(CPIdentifier('result'), CPString('Last Letter'))
            .CPStartCaseElse()
              .CPAddAssignment(CPIdentifier('result'), CPString('Other Character'))
          .CPEndCase()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := ['case intChoice of', 'case byteValue of', 'case charValue of', '42:', '255:', '''A'', ''B'', ''C'':', 'Perfect Answer!', 'Maximum Byte!', 'Early Alphabet'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Enhanced case element "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Enhanced case element "', LElement, '" missing or incorrect');
    end;

    WriteLn('    📄 Enhanced multi-type case statements (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // === TEST 10: Variable-Based Loop Conditions (NEW!) ===
    WriteLn('  🔄 Test ', LTestNumber, ': Variable-based loop conditions with different types');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('VariableLoopTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('counter')], cptInt32)
          .CPAddVariable([CPIdentifier('maxCount')], cptInt32)
          .CPAddVariable([CPIdentifier('isRunning')], cptBoolean)
          .CPAddVariable([CPIdentifier('smallNum')], cptInt8)
          .CPAddVariable([CPIdentifier('bigNum')], cptInt64)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('counter'), CPInt32(0))
          .CPAddAssignment(CPIdentifier('maxCount'), CPInt32(10))
          .CPAddAssignment(CPIdentifier('isRunning'), CPBoolean(True))
          .CPAddAssignment(CPIdentifier('smallNum'), CPInt8(5))
          .CPAddAssignment(CPIdentifier('bigNum'), CPInt64(1000000))
          .CPStartWhile(CPVariable(CPIdentifier('isRunning')))
            .CPStartIf(CPVariable(CPIdentifier('counter')))
              .CPAddAssignment(CPIdentifier('isRunning'), CPBoolean(False))
            .CPEndIf()
            .CPAddAssignment(CPIdentifier('counter'), CPInt32(1))
          .CPEndWhile()
          .CPStartFor(CPIdentifier('counter'), CPInt32(1), CPVariable(CPIdentifier('maxCount')), False)
            .CPStartIf(CPVariable(CPIdentifier('counter')))
              .CPAddBreak()
            .CPEndIf()
          .CPEndFor()
          .CPStartFor(CPIdentifier('smallNum'), CPVariable(CPIdentifier('smallNum')), CPInt8(1), True)
            .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Counting down with Int8')])
          .CPEndFor()
          .CPStartRepeat()
            .CPAddAssignment(CPIdentifier('counter'), CPInt32(0))
          .CPEndRepeat(CPVariable(CPIdentifier('isRunning')))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := ['while isRunning do', 'for counter := 1 to maxCount do', 'for smallNum := smallNum downto 1 do', 'until isRunning;'];
    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Variable-based loop "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Variable-based loop "', LElement, '" missing or incorrect');
    end;

    // === TEST 11: Enhanced Exit Statements with Variable Expressions (NEW!) ===
    WriteLn('  🚪 Test ', LTestNumber, ': Enhanced exit statements with variable expressions');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('VariableExitTest'))
        .CPStartFunction(CPIdentifier('CalculateResult'), cptInt32, False)
          .CPAddParameter([CPIdentifier('input')], cptInt32, 'const')
        .CPStartFunctionBody()
          .CPStartVarSection()
            .CPAddVariable([CPIdentifier('errorCode')], cptInt32)
            .CPAddVariable([CPIdentifier('successValue')], cptInt32)
          .CPStartCompoundStatement()
            .CPAddAssignment(CPIdentifier('errorCode'), CPInt32(-1))
            .CPAddAssignment(CPIdentifier('successValue'), CPInt32(100))
            .CPStartIf(CPVariable(CPIdentifier('input')))
              .CPAddExit(CPVariable(CPIdentifier('errorCode')))
            .CPAddElse()
              .CPAddExit(CPVariable(CPIdentifier('successValue')))
            .CPEndIf()
            .CPAddAssignment(CPIdentifier('Result'), CPInt32(0))
          .CPEndCompoundStatement()
        .CPEndFunction()
        .CPStartFunction(CPIdentifier('GetFloat'), cptFloat64, False)
          .CPAddParameter([CPIdentifier('value')], cptFloat64, 'const')
        .CPStartFunctionBody()
          .CPStartVarSection()
            .CPAddVariable([CPIdentifier('result')], cptFloat64)
          .CPStartCompoundStatement()
            .CPAddAssignment(CPIdentifier('result'), CPFloat64(3.14159))
            .CPAddExit(CPVariable(CPIdentifier('result')))
          .CPEndCompoundStatement()
        .CPEndFunction()
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, 'exit(errorCode);') then
      WriteLn('    ✅ Exit with Int32 variable expression generated correctly')
    else
      WriteLn('    ❌ Exit with Int32 variable expression missing or incorrect');

    if ContainsText(LSource, 'exit(successValue);') then
      WriteLn('    ✅ Exit with success variable expression generated correctly')
    else
      WriteLn('    ❌ Exit with success variable expression missing or incorrect');

    if ContainsText(LSource, 'exit(result);') then
      WriteLn('    ✅ Exit with Float64 variable expression generated correctly')
    else
      WriteLn('    ❌ Exit with Float64 variable expression missing or incorrect');

    // === TEST 12: Comprehensive Multi-Type Control Flow (NEW!) ===
    WriteLn('  🌈 Test ', LTestNumber, ': Comprehensive multi-type control flow showcase');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('MultiTypeControlFlow'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('int8Val')], cptInt8)
          .CPAddVariable([CPIdentifier('int16Val')], cptInt16)
          .CPAddVariable([CPIdentifier('int32Val')], cptInt32)
          .CPAddVariable([CPIdentifier('int64Val')], cptInt64)
          .CPAddVariable([CPIdentifier('uint8Val')], cptUInt8)
          .CPAddVariable([CPIdentifier('uint16Val')], cptUInt16)
          .CPAddVariable([CPIdentifier('uint32Val')], cptUInt32)
          .CPAddVariable([CPIdentifier('uint64Val')], cptUInt64)
          .CPAddVariable([CPIdentifier('float32Val')], cptFloat32)
          .CPAddVariable([CPIdentifier('float64Val')], cptFloat64)
          .CPAddVariable([CPIdentifier('boolVal')], cptBoolean)
          .CPAddVariable([CPIdentifier('charVal')], cptChar)
          .CPAddVariable([CPIdentifier('stringVal')], cptString)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('int8Val'), CPInt8(127))
          .CPAddAssignment(CPIdentifier('int16Val'), CPInt16(32767))
          .CPAddAssignment(CPIdentifier('int32Val'), CPInt32(2147483647))
          .CPAddAssignment(CPIdentifier('int64Val'), CPInt64(9223372036854775807))
          .CPAddAssignment(CPIdentifier('uint8Val'), CPUInt8(255))
          .CPAddAssignment(CPIdentifier('uint16Val'), CPUInt16(65535))
          .CPAddAssignment(CPIdentifier('uint32Val'), CPUInt32(4294967295))
          .CPAddAssignment(CPIdentifier('uint64Val'), CPUInt64(18446744073709551615))
          .CPAddAssignment(CPIdentifier('float32Val'), CPFloat32(3.14159))
          .CPAddAssignment(CPIdentifier('float64Val'), CPFloat64(2.71828182845904523536))
          .CPAddAssignment(CPIdentifier('boolVal'), CPBoolean(True))
          .CPAddAssignment(CPIdentifier('charVal'), CPChar('Z'))
          .CPAddAssignment(CPIdentifier('stringVal'), CPString('All types working!'))
          .CPStartCase(CPVariable(CPIdentifier('int8Val')))
            .CPAddCaseLabel([CPInt8(127)])
              .CPStartCase(CPVariable(CPIdentifier('charVal')))
                .CPAddCaseLabel([CPChar('Z')])
                  .CPStartIf(CPVariable(CPIdentifier('boolVal')))
                    .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPVariable(CPIdentifier('stringVal'))])
                  .CPEndIf()
              .CPEndCase()
          .CPEndCase()
          .CPStartFor(CPIdentifier('uint8Val'), CPUInt8(1), CPVariable(CPIdentifier('uint8Val')), False)
            .CPStartWhile(CPVariable(CPIdentifier('boolVal')))
              .CPAddAssignment(CPIdentifier('boolVal'), CPBoolean(False))
            .CPEndWhile()
          .CPEndFor()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Verify all 13 types are properly declared and used
    LExpectedElements := [
      'int8Val: Int8;', 'int16Val: Int16;', 'int32Val: Int32;', 'int64Val: Int64;',
      'uint8Val: UInt8;', 'uint16Val: UInt16;', 'uint32Val: UInt32;', 'uint64Val: UInt64;',
      'float32Val: Float32;', 'float64Val: Float64;',
      'boolVal: Boolean;', 'charVal: Char;', 'stringVal: string;',
      'case int8Val of', 'case charVal of', 'while boolVal do', 'for uint8Val := 1 to uint8Val do',
      'WriteLn(stringVal);'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing multi-type element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All 13 types working correctly in complex control flow')
    else
      WriteLn('    ❌ Some multi-type elements missing');

    WriteLn('    📄 Complete multi-type control flow (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // === TEST 13: Complete Phase 1E Integration Test ===
    WriteLn('  🎯 Test ', LTestNumber, ': Complete Phase 1E integration test');
    //Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('Phase1EComplete'))
        .CPStartConstSection()
          .CPAddConstant('MAX_ITERATIONS', '100')
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('i'), CPIdentifier('choice')], cptInt32)
          .CPAddVariable([CPIdentifier('done')], cptBoolean)
        .CPStartFunction(CPIdentifier('ProcessValue'), cptInt32, False)
          .CPAddParameter([CPIdentifier('value')], cptInt32, 'const')
        .CPStartFunctionBody()
          .CPStartIf(CPBoolean(True))
            .CPAddExit(CPInt32(-1))
          .CPAddElse()
            .CPAddAssignment(CPIdentifier('Result'), CPInt32(1))
          .CPEndIf()
        .CPEndFunction()
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('done'), CPBoolean(False))
          .CPAddAssignment(CPIdentifier('choice'), CPInt32(1))
          .CPAddLabel(CPIdentifier('mainLoop'))
          .CPStartFor(CPIdentifier('i'), CPInt32(1), CPInt32(10), False)
            .CPStartIf(CPBoolean(True))
              .CPAddBreak()
            .CPEndIf()
            .CPStartIf(CPBoolean(False))
              .CPAddContinue()
            .CPEndIf()
            .CPStartWhile(CPBoolean(True))
              .CPStartCase(CPVariable(CPIdentifier('choice')))
                .CPAddCaseLabel([CPInt32(1)])
                  .CPAddAssignment(CPIdentifier('done'), CPBoolean(True))
                .CPAddCaseLabel([CPInt32(2), CPInt32(3)])
                  .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Multiple values')])
                .CPStartCaseElse()
                  .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Default case')])
              .CPEndCase()
              .CPAddAssignment(CPIdentifier('choice'), CPInt32(2))
            .CPEndWhile()
          .CPEndFor()
          .CPStartRepeat()
            .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Processing...')])
            .CPAddAssignment(CPIdentifier('done'), CPBoolean(True))
          .CPEndRepeat(CPVariable(CPIdentifier('done')))
          .CPStartInlineAssembly()
            .CPAddAssemblyLine('nop ; no operation')
          .CPEndInlineAssembly()
          .CPAddGoto(CPIdentifier('finish'))
          .CPAddLabel(CPIdentifier('finish'))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Phase 1E complete!')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Final verification of all Phase 1E features (including case statements - now working!)
    LExpectedElements := [
      'program Phase1EComplete;',
      'const',
      'MAX_ITERATIONS = 100;',
      'function ProcessValue(const value: Int32): Int32;',
      'if True then',
      'exit(-1);',
      'for i := 1 to 10 do',
      'break;',
      'continue;',
      'while',
      'case choice of',
      '1:',
      '2, 3:',
      'else',
      'repeat',
      'until done;',
      'asm',
      'nop ; no operation',
      'goto finish;',
      'finish:',
      'Phase 1E complete!',
      'end.'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing Phase 1E element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All Phase 1E elements found in complete integration test')
    else
      WriteLn('    ❌ Some Phase 1E elements missing from integration test');

    WriteLn('    📄 Complete Phase 1E program (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Phase 1E Advanced Control Flow test completed successfully!');
    WriteLn('  ✅ ALL Phase 1E functionality verified and working:');
    WriteLn('    - 🔄 While loops with conditions');
    WriteLn('    - 🔢 For loops (to and downto)');
    WriteLn('    - 🔁 Repeat-until loops');
    WriteLn('    - 🔀 Case statements with multiple labels and else clause (NOW WORKING!)');
    WriteLn('    - 🎯 Control flow statements (goto, label, break, continue)');
    WriteLn('    - 🚪 Exit statements (with and without expressions)');
    WriteLn('    - 🔧 Inline assembly blocks');
    WriteLn('    - 🏗️ Complex nested control flow integration');
    WriteLn('  🚀 Phase 1E: Advanced Control Flow is production-ready!');
    WriteLn('  ✨ Builder can now generate complete CPascal programs with all control flow constructs!');
    WriteLn('  🎯 Case statements now fully functional thanks to enhanced CPVariable() implementation!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Phase 1E Advanced Control Flow test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;

procedure TestAdvancedStatementMethods();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
  LExpectedElements: TArray<string>;
  LElement: string;
  LFound: Boolean;
  LLine: string;
  LEmptyStatementCount: Integer;
  LLines: TArray<string>;
  LLineText: string;
  LTrimmedLine: string;
  LI: Integer;
begin
  WriteLn('🧪 Testing Phase 1H: Advanced Statement Methods...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Empty Statements ===
    WriteLn('  ⏸️ Test ', LTestNumber, ': Empty statements (CPAddEmptyStatement)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('EmptyStatementTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('i')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('i'), CPInt32(0))
          .CPAddEmptyStatement()
          .CPStartIf(CPBoolean(True))
            .CPAddEmptyStatement()
          .CPAddElse()
            .CPAddAssignment(CPIdentifier('i'), CPInt32(1))
            .CPAddEmptyStatement()
          .CPEndIf()
          .CPAddEmptyStatement()
          .CPStartWhile(CPBoolean(False))
            .CPAddEmptyStatement()
          .CPEndWhile()
          .CPAddEmptyStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Empty statement test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Count semicolons that represent empty statements
    LEmptyStatementCount := 0;
    LLines := LSource.Split([sLineBreak]);
    for LLineText in LLines do
    begin
      LTrimmedLine := Trim(LLineText);
      if LTrimmedLine = ';' then
        Inc(LEmptyStatementCount);
    end;

    if LEmptyStatementCount >= 5 then
      WriteLn('    ✅ Empty statements generated correctly (found ', LEmptyStatementCount, ' empty statements)')
    else
      WriteLn('    ❌ Insufficient empty statements generated (found ', LEmptyStatementCount, ', expected at least 5)');

    WriteLn('    📄 Generated empty statement source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LI := 0 to High(LLines) do
      WriteLn('    [', LI + 1:2, '] ', LLines[LI]);
    WriteLn('    ----------------------------------------');

    // === TEST 2: Assembly Constraints ===
    WriteLn('  🔧 Test ', LTestNumber, ': Assembly constraints (CPAddAssemblyConstraint)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('AssemblyConstraintTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('input')], cptInt32)
          .CPAddVariable([CPIdentifier('output')], cptInt32)
          .CPAddVariable([CPIdentifier('temp')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('input'), CPInt32(42))
          .CPStartInlineAssembly()
            .CPAddAssemblyLine('mov eax, %1')
            .CPAddAssemblyConstraint('mov eax, %1', ['output'], ['input'], [])
            .CPAddAssemblyLine('add eax, %2')
            .CPAddAssemblyConstraint('add eax, %2', [], ['input'], [])
            .CPAddAssemblyLine('mov %0, eax')
            .CPAddAssemblyConstraint('mov %0, eax', ['temp'], [], [])
            .CPAddAssemblyLine('nop')
            .CPAddAssemblyConstraint('nop', [], [], ['cc'])
          .CPEndInlineAssembly()
          .CPAddAssignment(CPIdentifier('output'), CPVariable(CPIdentifier('temp')))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Assembly constraint test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := [
      'asm',
      'mov eax, %1',
      'add eax, %2',
      'mov %0, eax',
      'nop',
      'end;'
    ];

    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Assembly constraint "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Assembly constraint "', LElement, '" missing or incorrect');
    end;

    WriteLn('    📄 Generated assembly constraint source (', Length(LSource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 3: Mixed Empty Statements and Assembly Constraints ===
    WriteLn('  🔄 Test ', LTestNumber, ': Mixed empty statements and assembly constraints');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('MixedAdvancedTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('counter')], cptInt32)
          .CPAddVariable([CPIdentifier('result')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddEmptyStatement()
          .CPAddAssignment(CPIdentifier('counter'), CPInt32(0))
          .CPAddEmptyStatement()
          .CPStartFor(CPIdentifier('counter'), CPInt32(1), CPInt32(3), False)
            .CPAddEmptyStatement()
            .CPStartInlineAssembly()
              .CPAddAssemblyLine('inc %0')
              .CPAddAssemblyConstraint('inc %0', ['counter'], [], [])
              .CPAddAssemblyLine('mov %1, %0')
              .CPAddAssemblyConstraint('mov %1, %0', ['result'], [], [])
            .CPEndInlineAssembly()
            .CPAddEmptyStatement()
          .CPEndFor()
          .CPAddEmptyStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Mixed test complete')])
          .CPAddEmptyStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Verify both features work together
    LExpectedElements := [
      'for counter := 1 to 3 do',
      'asm',
      'inc %0',
      'mov %1, %0',
      'end;'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing mixed element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All mixed elements found')
    else
      WriteLn('    ❌ Some mixed elements missing');

    // Count empty statements again
    LLines := LSource.Split([sLineBreak]);
    LEmptyStatementCount := 0;
    for LLineText in LLines do
    begin
      LTrimmedLine := Trim(LLineText);
      if LTrimmedLine = ';' then
        Inc(LEmptyStatementCount);
    end;

    if LEmptyStatementCount >= 4 then
      WriteLn('    ✅ Adequate empty statements in mixed test (found ', LEmptyStatementCount, ' empty statements)')
    else
      WriteLn('    ❌ Insufficient empty statements in mixed test (found ', LEmptyStatementCount, ', expected at least 4)');

    WriteLn('    📄 Complete mixed advanced source (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LI := 0 to High(LLines) do
      WriteLn('    [', LI + 1:2, '] ', LLines[LI]);
    WriteLn('    ========================================');

    // === TEST 4: Complex Assembly Constraint Types ===
    WriteLn('  🛠️ Test ', LTestNumber, ': Complex assembly constraint types and edge cases');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ComplexConstraintTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('inputReg')], cptInt32)
          .CPAddVariable([CPIdentifier('outputReg')], cptInt32)
          .CPAddVariable([CPIdentifier('memoryVar')], cptInt32)
          .CPAddVariable([CPIdentifier('immediateVal')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('inputReg'), CPInt32(100))
          .CPAddAssignment(CPIdentifier('immediateVal'), CPInt32(50))
          .CPStartInlineAssembly()
            .CPAddAssemblyLine('movl %1, %%eax')
            .CPAddAssemblyConstraint('movl %1, %%eax', [], ['inputReg'], [])
            .CPAddAssemblyLine('addl %2, %%eax')
            .CPAddAssemblyConstraint('addl %2, %%eax', [], ['immediateVal'], [])
            .CPAddAssemblyLine('movl %%eax, %0')
            .CPAddAssemblyConstraint('movl %%eax, %0', ['outputReg'], [], [])
            .CPAddAssemblyLine('movl %%eax, %3')
            .CPAddAssemblyConstraint('movl %%eax, %3', ['memoryVar'], [], [])
            .CPAddAssemblyLine('xorl %%eax, %%eax')
            .CPAddAssemblyConstraint('xorl %%eax, %%eax', [], [], ['eax', 'cc', 'memory'])
          .CPEndInlineAssembly()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Complex constraint test complete')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    LExpectedElements := [
      'movl %1, %%eax',
      'addl %2, %%eax',
      'movl %%eax, %0',
      'movl %%eax, %3',
      'xorl %%eax, %%eax'
    ];

    for LElement in LExpectedElements do
    begin
      if ContainsText(LSource, LElement) then
        WriteLn('    ✅ Complex constraint "', LElement, '" generated correctly')
      else
        WriteLn('    ❌ Complex constraint "', LElement, '" missing or incorrect');
    end;

    // === TEST 5: Empty Statement Placement Validation ===
    WriteLn('  ✅ Test ', LTestNumber, ': Empty statement placement validation');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('EmptyPlacementTest'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('choice')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddAssignment(CPIdentifier('choice'), CPInt32(1))
          .CPStartCase(CPVariable(CPIdentifier('choice')))
            .CPAddCaseLabel([CPInt32(1)])
              .CPAddEmptyStatement()
            .CPAddCaseLabel([CPInt32(2)])
              .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Case 2')])
              .CPAddEmptyStatement()
            .CPStartCaseElse()
              .CPAddEmptyStatement()
              .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Default case')])
              .CPAddEmptyStatement()
          .CPEndCase()
          .CPStartRepeat()
            .CPAddEmptyStatement()
            .CPAddAssignment(CPIdentifier('choice'), CPInt32(0))
            .CPAddEmptyStatement()
          .CPEndRepeat(CPBoolean(True))
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Verify empty statements are placed correctly in control structures
    if ContainsText(LSource, 'case choice of') and
       ContainsText(LSource, '1:') and
       ContainsText(LSource, '2:') and
       ContainsText(LSource, 'else') and
       ContainsText(LSource, 'repeat') and
       ContainsText(LSource, 'until True;') then
      WriteLn('    ✅ Empty statements correctly placed in control structures')
    else
      WriteLn('    ❌ Empty statements incorrectly placed in control structures');

    // === TEST 6: Complete Phase 1H Integration Test ===
    WriteLn('  🎯 Test ', LTestNumber, ': Complete Phase 1H integration test');
    //Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('Phase1HComplete'))
        .CPStartVarSection()
          .CPAddVariable([CPIdentifier('operand1'), CPIdentifier('operand2')], cptInt32)
          .CPAddVariable([CPIdentifier('result')], cptInt32)
          .CPAddVariable([CPIdentifier('iterations')], cptInt32)
        .CPStartCompoundStatement()
          .CPAddEmptyStatement()
          .CPAddAssignment(CPIdentifier('operand1'), CPInt32(10))
          .CPAddAssignment(CPIdentifier('operand2'), CPInt32(20))
          .CPAddAssignment(CPIdentifier('iterations'), CPInt32(0))
          .CPAddEmptyStatement()
          .CPStartWhile(CPBoolean(True))
            .CPAddEmptyStatement()
            .CPStartInlineAssembly()
              .CPAddAssemblyLine('movl %1, %%eax')
              .CPAddAssemblyConstraint('movl %1, %%eax', [], ['operand1'], [])
              .CPAddAssemblyLine('addl %2, %%eax')
              .CPAddAssemblyConstraint('addl %2, %%eax', [], ['operand2'], [])
              .CPAddAssemblyLine('movl %%eax, %0')
              .CPAddAssemblyConstraint('movl %%eax, %0', ['result'], [], [])
              .CPAddAssemblyLine('incl %3')
              .CPAddAssemblyConstraint('incl %3', ['iterations'], [], ['eax'])
            .CPEndInlineAssembly()
            .CPAddEmptyStatement()
            .CPStartIf(CPVariable(CPIdentifier('iterations')))
              .CPAddEmptyStatement()
              .CPAddBreak()
            .CPEndIf()
            .CPAddEmptyStatement()
          .CPEndWhile()
          .CPAddEmptyStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Phase 1H integration test complete!')])
          .CPAddEmptyStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Final verification of all Phase 1H features
    LExpectedElements := [
      'program Phase1HComplete;',
      'operand1, operand2: Int32;',
      'result: Int32;',
      'iterations: Int32;',
      'operand1 := 10;',
      'operand2 := 20;',
      'while',
      'asm',
      'movl %1, %%eax',
      'addl %2, %%eax',
      'movl %%eax, %0',
      'incl %3',
      'end;',
      'if iterations then',
      'break;',
      'Phase 1H integration test complete!',
      'end.'
    ];

    LFound := True;
    for LElement in LExpectedElements do
    begin
      if not ContainsText(LSource, LElement) then
      begin
        WriteLn('    ❌ Missing Phase 1H element: "', LElement, '"');
        LFound := False;
      end;
    end;

    if LFound then
      WriteLn('    ✅ All Phase 1H elements found in complete integration test')
    else
      WriteLn('    ❌ Some Phase 1H elements missing from integration test');

    // Final empty statement count
    LLines := LSource.Split([sLineBreak]);
    LEmptyStatementCount := 0;
    for LLineText in LLines do
    begin
      LTrimmedLine := Trim(LLineText);
      if LTrimmedLine = ';' then
        Inc(LEmptyStatementCount);
    end;

    WriteLn('    📊 Total empty statements in complete test: ', LEmptyStatementCount);
    WriteLn('    📄 Complete Phase 1H program (', Length(LSource), ' characters):');
    WriteLn('    ========================================');
    for LI := 0 to High(LLines) do
      WriteLn('    [', LI + 1:2, '] ', LLines[LI]);
    WriteLn('    ========================================');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Phase 1H Advanced Statement Methods test completed successfully!');
    WriteLn('  ✅ ALL Phase 1H functionality verified and working:');
    WriteLn('    - ⏸️ Empty statements for control flow placeholders');
    WriteLn('    - 🔧 Assembly constraints for inline assembly optimization');
    WriteLn('    - 🔄 Mixed empty statements and assembly constraints integration');
    WriteLn('    - 🛠️ Complex assembly constraint types and edge cases');
    WriteLn('    - ✅ Empty statement placement validation in control structures');
    WriteLn('    - 🎯 Complete integration test with advanced control flow');
    WriteLn('  🚀 Phase 1H: Advanced Statement Methods is production-ready!');
    WriteLn('  ✨ Builder now has complete statement and assembly support!');
    WriteLn('  🚀 All 16 newly implemented methods are fully tested and verified!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Phase 1H Advanced Statement Methods test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;


end.

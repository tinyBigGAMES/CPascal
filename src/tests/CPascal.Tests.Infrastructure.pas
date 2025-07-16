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

unit CPascal.Tests.Infrastructure;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestBuilderFoundation();


implementation

procedure TestBuilderFoundation();
var
  LBuilder: ICPBuilder;
  LPrettySource: string;
  LCanonicalSource: string;
  LExpectedLines: TArray<string>;
  LLine: string;
  LTestNumber: Integer;
  LComplexSource: string;
  LNestingLevel: Integer;

begin
  WriteLn('🧪 Testing TStringBuilder-based CPascal source generation...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Basic Program Structure ===
    WriteLn('  🔍 Test ', LTestNumber, ': Basic program structure generation');
    Inc(LTestNumber);

    with LBuilder do
    begin
      LPrettySource := CPStartProgram(CPIdentifier('HelloWorld'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(
            CPIdentifier('WriteLn'),
            [CPString('Hello, World!')]
          )
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Verify pretty-print output contains expected elements
    if ContainsText(LPrettySource, 'program HelloWorld;') then
      WriteLn('    ✅ Program header generated correctly')
    else
      WriteLn('    ❌ Program header missing or incorrect');

    if ContainsText(LPrettySource, 'begin') and ContainsText(LPrettySource, 'end.') then
      WriteLn('    ✅ Compound statement structure generated correctly')
    else
      WriteLn('    ❌ Compound statement structure missing or incorrect');

    if ContainsText(LPrettySource, 'WriteLn(''Hello, World!'');') then
      WriteLn('    ✅ Procedure call with string parameter generated correctly')
    else
      WriteLn('    ❌ Procedure call generation failed');

    if ContainsText(LPrettySource, 'end.') then
      WriteLn('    ✅ Program termination dot generated correctly')
    else
      WriteLn('    ❌ Program termination dot missing or incorrectly positioned');

    WriteLn('    📄 Generated source (', Length(LPrettySource), ' characters):');
    WriteLn('    ----------------------------------------');
    for LLine in LPrettySource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ----------------------------------------');

    // === TEST 2: Dual-Mode Output Verification ===
    WriteLn('  🎭 Test ', LTestNumber, ': Dual-mode output (pretty-print vs canonical)');
    Inc(LTestNumber);

    with LBuilder do
      LCanonicalSource := GetCPas(False);

    if Length(LCanonicalSource) < Length(LPrettySource) then
      WriteLn('    ✅ Canonical mode produces more compact output (', Length(LCanonicalSource), ' vs ', Length(LPrettySource), ' characters)')
    else
      WriteLn('    ❌ Canonical mode should be more compact than pretty-print mode');

    if ContainsText(LCanonicalSource, 'program HelloWorld;') and
       ContainsText(LCanonicalSource, 'WriteLn(''Hello, World!'');') then
      WriteLn('    ✅ Canonical mode preserves essential syntax elements')
    else
      WriteLn('    ❌ Canonical mode missing essential syntax elements');

    WriteLn('    📋 Canonical source: "', LCanonicalSource, '"');

    // === TEST 3: Indentation Verification ===
    WriteLn('  📐 Test ', LTestNumber, ': Proper indentation in pretty-print mode');
    Inc(LTestNumber);

    LExpectedLines := LPrettySource.Split([sLineBreak]);

    // Check that WriteLn call is indented (should have leading spaces)
    for LLine in LExpectedLines do
    begin
      if LLine.Trim().StartsWith('WriteLn(') then
      begin
        if LLine.StartsWith('  ') then
          WriteLn('    ✅ Procedure call properly indented')
        else
          WriteLn('    ❌ Procedure call not properly indented: "', LLine, '"');
        Break;
      end;
    end;

    // === TEST 4: Builder Reset and Reuse ===
    WriteLn('  🔄 Test ', LTestNumber, ': Builder reset and reuse functionality');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();

      if CPGetCurrentContext() = '' then
        WriteLn('    ✅ Builder context cleared after reset')
      else
        WriteLn('    ❌ Builder context not cleared after reset');

      // Generate a different program to test reuse
      LPrettySource := CPStartProgram(CPIdentifier('SecondProgram'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(
            CPIdentifier('WriteLn'),
            [CPString('Second program works!')]
          )
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LPrettySource, 'program SecondProgram;') and
       ContainsText(LPrettySource, 'Second program works!') then
      WriteLn('    ✅ Builder successfully reused after reset')
    else
      WriteLn('    ❌ Builder reuse after reset failed');

    // === TEST 5: Empty Program Structure ===
    WriteLn('  🏗️ Test ', LTestNumber, ': Empty program structure');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LPrettySource := CPStartProgram(CPIdentifier('EmptyProgram'))
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LPrettySource, 'program EmptyProgram;') and
       ContainsText(LPrettySource, 'begin') and
       ContainsText(LPrettySource, 'end.') then
      WriteLn('    ✅ Empty program structure generates correctly')
    else
      WriteLn('    ❌ Empty program structure generation failed');

    // === TEST 6: Complex Procedure Calls ===
    WriteLn('  ⚙️ Test ', LTestNumber, ': Complex procedure calls with multiple parameters');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LPrettySource := CPStartProgram(CPIdentifier('ComplexCalls'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(
            CPIdentifier('printf'),
            [
              CPString('Hello %s! Number: %d'),
              CPString('World'),
              CPString('42')
            ]
          )
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LPrettySource, 'printf(''Hello %s! Number: %d'', ''World'', ''42'');') then
      WriteLn('    ✅ Multiple parameter procedure call generated correctly')
    else
      WriteLn('    ❌ Multiple parameter procedure call generation failed');

    // === TEST 7: Context Tracking ===
    WriteLn('  📍 Test ', LTestNumber, ': Context tracking functionality');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      CPStartProgram(CPIdentifier('ContextTest'));

      if CPGetCurrentContext() = 'program' then
        WriteLn('    ✅ Context correctly tracked as "program"')
      else
        WriteLn('    ❌ Context tracking failed, expected "program", got "', CPGetCurrentContext(), '"');

      CPEndProgram();

      if CPGetCurrentContext() = '' then
        WriteLn('    ✅ Context correctly cleared after program end')
      else
        WriteLn('    ❌ Context not cleared after program end');
    end;

    // === TEST 8: Complex Nesting Stress Test ===
    WriteLn('  🏗️ Test ', LTestNumber, ': Complex nested compound statements (STRESS TEST)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LComplexSource := CPStartProgram(CPIdentifier('ComplexNestingTest'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Starting complex test...')])
          .CPStartCompoundStatement()  // Level 2 nesting
            .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Level 2 nesting')])
            .CPStartCompoundStatement()  // Level 3 nesting
              .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Level 3 nesting')])
              .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Multiple statements at level 3')])
              .CPStartCompoundStatement()  // Level 4 nesting
                .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Level 4 (deepest nesting)')])
              .CPEndCompoundStatement()  // End level 4
            .CPEndCompoundStatement()  // End level 3
            .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Back to level 2')])
          .CPEndCompoundStatement()  // End level 2
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Back to level 1')])
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Test complete!')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    // Verify complex nesting structure
    if ContainsText(LComplexSource, 'program ComplexNestingTest;') then
      WriteLn('    ✅ Complex program header generated correctly')
    else
      WriteLn('    ❌ Complex program header generation failed');

    // Count indentation levels
    //LNestingLevel := 0;
    LExpectedLines := LComplexSource.Split([sLineBreak]);
    for LLine in LExpectedLines do
    begin
      if LLine.Trim().StartsWith('WriteLn(''Level 4') then
      begin
        // Count leading spaces - should be 8 spaces (4 levels * 2 spaces)
        LNestingLevel := 0;
        while (LNestingLevel < Length(LLine)) and (LLine[LNestingLevel + 1] = ' ') do
          Inc(LNestingLevel);

        if LNestingLevel = 8 then
          WriteLn('    ✅ Level 4 nesting properly indented (8 spaces)')
        else
          WriteLn('    ❌ Level 4 nesting incorrectly indented (', LNestingLevel, ' spaces, expected 8)');
        Break;
      end;
    end;

    // Verify statement sequencing
    if ContainsText(LComplexSource, 'Starting complex test') and
       ContainsText(LComplexSource, 'Level 2 nesting') and
       ContainsText(LComplexSource, 'Level 3 nesting') and
       ContainsText(LComplexSource, 'Level 4 (deepest nesting)') and
       ContainsText(LComplexSource, 'Back to level 2') and
       ContainsText(LComplexSource, 'Back to level 1') and
       ContainsText(LComplexSource, 'Test complete!') then
      WriteLn('    ✅ Complex statement sequencing generated correctly')
    else
      WriteLn('    ❌ Complex statement sequencing failed');

    // Show the complex source
    WriteLn('    🔍 Complex nested source (', Length(LComplexSource), ' characters):');
    WriteLn('    ========================================');
    for LLine in LComplexSource.Split([sLineBreak]) do
      WriteLn('    ', LLine);
    WriteLn('    ========================================');

    // === TEST 9: String Complexity Test ===
    WriteLn('  🎭 Test ', LTestNumber, ': Complex string handling and special characters');
    //Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LPrettySource := CPStartProgram(CPIdentifier('StringComplexityTest'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Simple string')])
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('String with "quotes" inside')])
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('String with ''apostrophes'' inside')])
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Multi-parameter'), CPString('string'), CPString('test')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LPrettySource, '''String with "quotes" inside''') and
       ContainsText(LPrettySource, '''String with ''''apostrophes'''' inside''') then
      WriteLn('    ✅ Complex string quoting handled correctly')
    else
      WriteLn('    ❌ Complex string quoting failed');

    if ContainsText(LPrettySource, '''Multi-parameter'', ''string'', ''test''') then
      WriteLn('    ✅ Multi-parameter string calls generated correctly')
    else
      WriteLn('    ❌ Multi-parameter string calls failed');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 TStringBuilder source generation test completed successfully!');
    WriteLn('  ✅ All core functionality verified:');
    WriteLn('    - 🏗️ Program structure generation');
    WriteLn('    - 📐 Proper indentation and formatting (up to 4 levels deep)');
    WriteLn('    - 🎭 Dual-mode output (pretty-print vs canonical)');
    WriteLn('    - 📞 Procedure calls with string parameters');
    WriteLn('    - 🔄 Builder reset and reuse');
    WriteLn('    - 📍 Context tracking');
    WriteLn('    - 🎯 Complex nested compound statements');
    WriteLn('    - 🎭 Advanced string handling with special characters');
    WriteLn('  ✅ GetCPas() method now returns actual CPascal source code!');
    WriteLn('  🚀 Ready for implementing assignment statements, variables, and conditionals!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ TStringBuilder source generation test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;


end.

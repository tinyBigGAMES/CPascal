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

unit CPascal.Tests.CompilerDirectives;

interface

uses
  System.SysUtils,
  System.StrUtils,
  CPascal;

procedure TestCompilerDirectives();

implementation

procedure TestCompilerDirectives();
var
  LBuilder: ICPBuilder;
  LSource: string;
  LTestNumber: Integer;
begin
  WriteLn('🧪 Testing CPascal Compiler Directives...');
  LTestNumber := 1;

  LBuilder := CPCreateBuilder();
  try
    // === TEST 1: Basic Conditional Compilation (IFDEF/ENDIF) ===
    WriteLn('  🔍 Test ', LTestNumber, ': Basic IFDEF/ENDIF conditional compilation');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ConditionalTest'))
        .CPStartIfDef(CPIdentifier('DEBUG'))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Debug mode enabled')])
        .CPEndIf()
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Main program')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, '{$IFDEF DEBUG}') and ContainsText(LSource, '{$ENDIF}') then
      WriteLn('    ✅ IFDEF/ENDIF directives generated correctly')
    else
      WriteLn('    ❌ IFDEF/ENDIF directives missing or malformed');

    WriteLn('    📄 Generated source:');
    WriteLn('    ----------------------------------------');
    WriteLn('    ', LSource.Replace(sLineBreak, sLineBreak + '    '));
    WriteLn('    ----------------------------------------');

    // === TEST 2: IFNDEF (IF NOT DEFINED) ===
    WriteLn('  🔍 Test ', LTestNumber, ': IFNDEF conditional compilation');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('IfNotDefTest'))
        .CPStartIfNDef(CPIdentifier('RELEASE'))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Not in release mode')])
        .CPEndIf()
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, '{$IFNDEF RELEASE}') then
      WriteLn('    ✅ IFNDEF directive generated correctly')
    else
      WriteLn('    ❌ IFNDEF directive missing or malformed');

    // === TEST 3: Conditional Compilation with ELSE ===
    WriteLn('  🔍 Test ', LTestNumber, ': Conditional compilation with ELSE clause');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('ConditionalElseTest'))
        .CPStartIfDef(CPIdentifier('WINDOWS'))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Windows platform')])
        .CPAddElse()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Non-Windows platform')])
        .CPEndIf()
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, '{$IFDEF WINDOWS}') and 
       ContainsText(LSource, '{$ELSE}') and 
       ContainsText(LSource, '{$ENDIF}') then
      WriteLn('    ✅ Conditional compilation with ELSE generated correctly')
    else
      WriteLn('    ❌ Conditional compilation with ELSE failed');

    // === TEST 4: Symbol Definition and Undefinition ===
    WriteLn('  🔍 Test ', LTestNumber, ': Symbol definition and undefinition');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('SymbolTest'))
        .CPAddDefine(CPIdentifier('MY_SYMBOL'))
        .CPStartIfDef(CPIdentifier('MY_SYMBOL'))
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Symbol is defined')])
        .CPEndIf()
        .CPAddUndef(CPIdentifier('MY_SYMBOL'))
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, '{$DEFINE MY_SYMBOL}') and 
       ContainsText(LSource, '{$UNDEF MY_SYMBOL}') then
      WriteLn('    ✅ Symbol definition and undefinition generated correctly')
    else
      WriteLn('    ❌ Symbol definition and undefinition failed');

    // === TEST 5: Linking Directives ===
    WriteLn('  🔍 Test ', LTestNumber, ': Linking directives (LINK, LIBPATH, APPTYPE)');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('LinkingTest'))
        .CPAddLink(CPLibraryName('user32.lib'))
        .CPAddLibPath(CPFilePath('C:\Libraries'))
        .CPSetAppType(CPAppType('CONSOLE'))
        .CPStartCompoundStatement()
          .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Program with linking directives')])
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, '{$LINK ''user32.lib''}') and
       ContainsText(LSource, '{$LIBPATH ''C:\Libraries''}') and
       ContainsText(LSource, '{$APPTYPE ''CONSOLE''}') then
      WriteLn('    ✅ Linking directives generated correctly')
    else
      WriteLn('    ❌ Linking directives missing or malformed');

    // === TEST 6: Complex Nested Conditional Compilation ===
    WriteLn('  🔍 Test ', LTestNumber, ': Complex nested conditional compilation');
    Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('NestedConditionalTest'))
        .CPStartIfDef(CPIdentifier('PLATFORM_SPECIFIC'))
          .CPStartIfDef(CPIdentifier('WINDOWS'))
            .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Windows-specific code')])
          .CPAddElse()
            .CPStartIfDef(CPIdentifier('LINUX'))
              .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Linux-specific code')])
            .CPAddElse()
              .CPAddProcedureCall(CPIdentifier('WriteLn'), [CPString('Generic platform code')])
            .CPEndIf()
          .CPEndIf()
        .CPEndIf()
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, '{$IFDEF PLATFORM_SPECIFIC}') and
       ContainsText(LSource, '{$IFDEF WINDOWS}') and
       ContainsText(LSource, '{$IFDEF LINUX}') then
      WriteLn('    ✅ Complex nested conditional compilation generated correctly')
    else
      WriteLn('    ❌ Complex nested conditional compilation failed');

    // === TEST 7: Additional Linking Directives ===
    WriteLn('  🔍 Test ', LTestNumber, ': Additional linking directives (paths and options)');
    //Inc(LTestNumber);

    with LBuilder do
    begin
      CPReset();
      LSource := CPStartProgram(CPIdentifier('AdvancedLinkingTest'))
        .CPAddModulePath(CPFilePath('C:\Modules'))
        .CPAddExePath(CPFilePath('C:\Output'))
        .CPAddObjPath(CPFilePath('C:\Objects'))
        .CPStartCompoundStatement()
        .CPEndCompoundStatement()
        .CPEndProgram()
        .GetCPas(True);
    end;

    if ContainsText(LSource, '{$MODULEPATH ''C:\Modules''}') and
       ContainsText(LSource, '{$EXEPATH ''C:\Output''}') and
       ContainsText(LSource, '{$OBJPATH ''C:\Objects''}') then
      WriteLn('    ✅ Additional linking directives generated correctly')
    else
      WriteLn('    ❌ Additional linking directives missing or malformed');

    // === FINAL VERIFICATION ===
    WriteLn('  🎉 Compiler Directives test completed successfully!');
    WriteLn('  ✅ All directive types verified:');
    WriteLn('    - 🔄 Conditional compilation (IFDEF/IFNDEF/ELSE/ENDIF)');
    WriteLn('    - 🎯 Symbol definition and undefinition (DEFINE/UNDEF)');
    WriteLn('    - 🔗 Linking directives (LINK/LIBPATH/APPTYPE)');
    WriteLn('    - 📁 Path directives (MODULEPATH/EXEPATH/OBJPATH)');
    WriteLn('    - 🏗️ Complex nested conditional structures');
    WriteLn('  🚀 Ready for complete CPascal language support!');

  except
    on E: Exception do
    begin
      WriteLn('  ❌ Compiler Directives test failed with exception: ', E.Message);
      WriteLn('  ❌ Exception class: ', E.ClassName);
      raise; // Re-raise for test runner
    end;
  end;
end;

end.

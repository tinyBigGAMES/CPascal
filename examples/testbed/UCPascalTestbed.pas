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

 https://github.com/tinyBigGAMES/CPascal

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

unit UCPascalTestbed;

interface

procedure RunCPascalTestbed();

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.TypInfo,
  CPascal.Common,
  CPascal.Compiler;

procedure Pause();
begin
  WriteLn;
  Write('Press ENTER to continue...');
  ReadLn;
  WriteLn;
end;

procedure Coverage();
var
  LCompiler: TCPCompiler;
begin
  // Create the main compiler engine instance.
  LCompiler := TCPCompiler.Create();
  try
    // The OnStartup event fires once before any compilation work begins.
    // It's the ideal place to display introductory information, like a program
    // header, version, and copyright notice.
    LCompiler.OnStartup := procedure()
    begin
      WriteLn(Format('CPascal™ v%s', [LCompiler.GetVersionString()]));
      WriteLn('Copyright © 2025-present tinyBigGAMES™ LLC');
      WriteLn('All Rights Reserved.');
      WriteLn;
    end;

    // The OnShutdown event fires after all compilation tasks are complete,
    // regardless of success or failure. It is suitable for final cleanup
    // messages.
    LCompiler.OnShutdown := procedure()
    begin
      WriteLn;
      WriteLn('CPascal - Shutdown...');
    end;

    // The OnProgress event provides real-time feedback as the compiler
    // advances through its different stages (e.g., Parsing, Semantic Analysis).
    LCompiler.OnProgress := procedure(const AFileName: string; const APhase: TCPCompilerPhase; const AMessage: string)
    begin
      WriteLn(Format('[%s] %s: %s', ['PROGRESS',  TPath.GetFileName(AFileName), AMessage]));
    end;

    // The OnWarning event reports non-critical issues that do not halt
    // compilation (e.g., a potential loss of data from a narrowing type
    // conversion). It includes the file, line, and column of the issue.
    LCompiler.OnWarning := procedure(const AFileName: string; const APhase: TCPCompilerPhase; const ALine, AColumn: Integer; const AMessage: string)
    begin
       WriteLn(Format('[%s]  %s(%d:%d): %s', ['WARNING', TPath.GetFileName(AFileName), ALine, AColumn, AMessage]));
    end;

    // The OnError event reports a fatal error that has stopped compilation
    // (e.g., a syntax error). It includes the precise location and error
    // message.
    LCompiler.OnError := procedure(const AFileName: string; const APhase: TCPCompilerPhase; const ALine, AColumn: Integer; const AMessage: string)
    begin
      WriteLn(Format('[%s]    %s(%d:%d): %s', ['ERROR', TPath.GetFileName(AFileName), ALine, AColumn, AMessage]));
    end;

    // This call invokes the entire compilation process for a single source file.
    // During its execution, it will trigger the various On... events assigned above.
    LCompiler.Compile('res/src/coverage.cpas', 'res/output/coverage.obj');
  finally
    // The try..finally block ensures the compiler object is always freed.}
    LCompiler.Free();
  end;
end;

procedure RunCPascalTestbed();
begin
  Coverage();
  Pause();
end;

end.

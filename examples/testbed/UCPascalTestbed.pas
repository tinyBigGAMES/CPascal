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

unit UCPascalTestbed;

interface

procedure RunCPascalTestbed();

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.Math,
  System.Generics.Collections,
  CPascal;

procedure Pause();
begin
  WriteLn;
  Write('Press ENTER to continue...');
  ReadLn;
  WriteLn;
end;

procedure TestFile(const AFirst, ALast, AMaxNum: UInt32);
var
  LPath: string;
  LCompiler: TCPCompiler;
  LSource: string;
  LIR: string;
  LModuleRef: PCPModuleRef;
  LFiles: TArray<string>;
  LFilename: string;
  LFirst: UInt32;
  LLast: UInt32;
  LNum: UInt32;
begin
  if (AFirst > ALast) or (AFirst > AMaxNum)  then
  begin
    raise Exception.CreateFmt('Invalid first test file number: %d', [AFirst])
  end;

  if (ALast < AFirst) or (ALast > AMaxNum)  then
  begin
    raise Exception.CreateFmt('Invalid last test file number: %d', [ALast])
  end;

  LPath := 'res\src';
  LFiles := System.IOUtils.TDirectory.GetFiles(LPath, '*.cpas');

  if Length(LFiles) = 0 then
  begin
    raise Exception.CreateFmt('No .CPAS files found in: %s', [LPath])
  end;

  LFirst := EnsureRange(AFirst-1, AFirst-1, ALast);
  if LFirst > High(LFiles) then
  begin
    raise Exception.CreateFmt('There are only %s files, invalid first test file number: %d', [Length(LFiles), LFirst]);
  end;

  LLast  := EnsureRange(ALast-1, ALast-1, High(LFiles));

  for LNum := LFirst to LLast do
  begin

    LFilename := LFiles[LNum];

    CPPrintLn(sLineBreak + '==== TEST FILE: %s ===' + sLineBreak, [LFilename]);

    LCompiler := TCPCompiler.Create();
    try
      LSource := '';
      LIR := '';
      LModuleRef := LCompiler.CompileFile(LFilename, LSource);

      if not LSource.IsEmpty then
        CPPrintLn('--- SOURCE ---' + sLineBreak + '%s' + sLineBreak, [LSource.Trim()]);

      LIR := LCompiler.GetLastIR();
      if not LIR.IsEmpty then
        CPPrintLn('--- IR SOURCE ---' + sLineBreak + '%s', [LIR.Trim()]);

      if Assigned(LModuleRef) then
      begin
        CPPrintLn('--- JIT EXECUTION ---', []);
        CPPrintLn('Exit Code: %d', [LCompiler.JIT(LModuleRef)]);
      end;

    finally
      LCompiler.Free();
    end;
  end;
end;

procedure RunCPascalTestbed();
begin
  try
    // currently working examples: 1-29
    TestFile(1, 29, 29);
  except
    // Handle ECPException
    on E: ECPException do
      CPDisplayExceptionError(E);

    // Catch-all for unexpected exceptions
    on E: Exception do
      CPDisplayExceptionError(E);
  end;

  Pause();
end;

end.

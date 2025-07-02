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

unit CPascal.Test.Compiler;

interface

uses
  System.SysUtils,
  System.IOUtils,
  DUnitX.TestFramework,
  CPascal.Compiler;

type
  [TestFixture]
  TTestCompiler = class
  public
    [Test]
    procedure TestEndToEndCompilationSuccess();
    [Test]
    procedure TestEndToEndCompilationFailure();
  end;

implementation

procedure TTestCompiler.TestEndToEndCompilationSuccess;
var
  LCompiler: TCPCompiler;
  LSourceFile: string;
  LOutputFile: string;
  LSuccess: Boolean;
begin
  LSourceFile := TPath.GetTempFileName;
  LOutputFile := TPath.ChangeExtension(LSourceFile, '.obj');
  LCompiler := TCPCompiler.Create();
  try
    // MODIFIED: Replaced 'Integer' with 'Int32'
    TFile.WriteAllText(LSourceFile, 'program Test; var x: Int32; begin x := 123; end.');
    LSuccess := LCompiler.Compile(LSourceFile, LOutputFile);

    Assert.IsTrue(LSuccess, 'Compiler reported a failure on valid code.');
    Assert.IsTrue(TFile.Exists(LOutputFile), 'Output object file was not created.');
    Assert.IsTrue(TFile.GetSize(LOutputFile) > 0, 'Output object file is empty.');
  finally
    LCompiler.Free;
    if TFile.Exists(LSourceFile) then TFile.Delete(LSourceFile);
    if TFile.Exists(LOutputFile) then TFile.Delete(LOutputFile);
  end;
end;

procedure TTestCompiler.TestEndToEndCompilationFailure;
var
  LCompiler: TCPCompiler;
  LSourceFile: string;
  LOutputFile: string;
  LSuccess: Boolean;
begin
  LSourceFile := TPath.GetTempFileName;
  LOutputFile := TPath.ChangeExtension(LSourceFile, '.obj');
  LCompiler := TCPCompiler.Create();
  try
    // MODIFIED: Replaced 'Integer' but kept the intentional syntax error (missing ';')
    TFile.WriteAllText(LSourceFile, 'program Test; var x: Int32 begin x := 123; end.');
    LSuccess := LCompiler.Compile(LSourceFile, LOutputFile);

    Assert.IsFalse(LSuccess, 'Compiler reported success on invalid code.');
    Assert.IsFalse(TFile.Exists(LOutputFile), 'Output object file should not have been created on failure.');
  finally
    LCompiler.Free;
    if TFile.Exists(LSourceFile) then TFile.Delete(LSourceFile);
    if TFile.Exists(LOutputFile) then TFile.Delete(LOutputFile);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestCompiler);

end.

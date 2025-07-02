program CPascalTests;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  UCPascalTests in 'UCPascalTests.pas',
  CPascal.AST in '..\CPascal.AST.pas',
  CPascal.Lexer in '..\CPascal.Lexer.pas',
  CPascal.Parser in '..\CPascal.Parser.pas',
  CPascal.Semantic in '..\CPascal.Semantic.pas',
  CPascal.IRGen in '..\CPascal.IRGen.pas',
  CPascal.LLVM in '..\CPascal.LLVM.pas',
  CPascal.Compiler in '..\CPascal.Compiler.pas',
  CPascal.Test.Compiler in '..\CPascal.Test.Compiler.pas',
  CPascal.Test.IRGen in '..\CPascal.Test.IRGen.pas',
  CPascal.Test.Lexer in '..\CPascal.Test.Lexer.pas',
  CPascal.Test.Logger in '..\CPascal.Test.Logger.pas',
  CPascal.Test.Parser in '..\CPascal.Test.Parser.pas',
  CPascal.Test.Semantic in '..\CPascal.Test.Semantic.pas',
  CPascal.Common in '..\CPascal.Common.pas',
  CPascal.Platform.Win32 in '..\CPascal.Platform.Win32.pas',
  CPascal.Platform in '..\CPascal.Platform.pas';

begin
  try
    RunCPascalTests();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

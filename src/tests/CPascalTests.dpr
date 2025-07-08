program CPascalTests;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  UCPascalTests in 'UCPascalTests.pas',
  CPascal.Common in '..\CPascal.Common.pas',
  CPascal.DUnitX.Logger in 'CPascal.DUnitX.Logger.pas',
  CPascal.Tests in '..\CPascal.Tests.pas';

begin
  try
    RunCPascalTests();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

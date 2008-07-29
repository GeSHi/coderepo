unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OYApplication, OYProgressForm, OYPackageF, OYPackage,
  OYProcessingInfoF, OYXmlConsumer, OYSyntaxView, ComCtrls;

type
  TForm1 = class(TForm, IOYLinguineExecutionContext, IOYLinguineProcessingOptions)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    TabSheet3: TTabSheet;
    Memo2: TMemo;
    TabSheet4: TTabSheet;
    Memo3: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fIProgress : IOYProgress;
    fProgressForm : TOYProgressForm;
  protected
    // IOYLinguineExecutionContext
    function IProgress : IOYProgress;

    // IOYLinguineProcessingOptions
    function GetDefines : WideString;
    function GetSearchPaths : WideString;
    function IgnoreWhitespace : Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  package : IOYLinguineLanguagePackage;
  libName : String;
  info : IOYLinguineProcessingInfo;
  consumer : TOYXmlTransientTree;
  iconsumer : IOYLinguineConsumer;
  lb : TSyntaxListBox;
  high : IOYSyntaxHighlight;
  b : Boolean;
  sz: Integer;
  i : Integer;
begin
  // load Delphi Object Pascal parsing lirary DLL
  libName := ExtractFilePath(Application.ExeName) + '/bop130.llp';
  package := OYCreateInstance(libName, self);

  // create simple XML consumer that will capture abstract
  // syntax tree (AST) while parsing
  consumer := TOYXmlTransientTree.Create();
  iconsumer := consumer;

  // parse source file into XML
  b := package.ProduceFullXmlTreeForUrl(Edit1.Text, self, self, consumer, info);
  if not b then begin

    // show text of error
    Memo1.Lines.Clear;
    memo1.Lines.add('Error: ' + info.GetReason + '. Please configure search path.');
    ShowMessage('Error: ' + info.GetReason);
  end else begin

    // dump lex into memo
    Memo2.Lines.Clear;
    Memo2.Lines.BeginUpdate;
    Memo2.Lines.add('Lex tokens <t> - ' + IntToStr(package.ILexSchema.GetCount));
    for i := 0 to package.ILexSchema.GetCount - 1 do begin
        Memo2.Lines.add(IntToStr(package.ILexSchema.GetId(i)) + ': ' + package.ILexSchema.GetName(i));
    end;
    Memo2.Lines.EndUpdate;


    // dump yacc
    Memo3.Lines.Clear;
    Memo3.Lines.BeginUpdate;
    Memo3.Lines.add('YACC rules <r> - ' + IntToStr(package.IYaccSchema.GetCount));
    for i := 0 to package.IYaccSchema.GetCount - 1 do begin
        Memo3.Lines.add(IntToStr(package.IYaccSchema.GetId(i)) + ': ' + package.IYaccSchema.GetName(i) + ' = ' + package.IYaccSchema.GetSemantics(i));
    end;
    Memo3.Lines.EndUpdate;


    // dump AST into memo
    Memo1.Lines.Clear;
    memo1.Lines.add(consumer.Xml);

  end;

  // parse again and create syntax highlihgter
  package.CreateSyntaxHighlighterForUrl(Edit1.Text, self, self, high, info);

  // create syntax view and load the file into it
  lb := TSyntaxListBox.Create(self, high);
  lb.Font.Name := 'Courier New';
  lb.Parent := TabSheet2;
  lb.Align := alClient;
  lb.LoadFromFile(Edit1.text);
end;

procedure TForm1.FormCreate(Sender: TObject);

  procedure _AttachProgressWidget;
  var
    aIHotSwap : IOYHotSwapProgress;
  begin
    if Succeeded(fIProgress.QueryInterface(IOYHotSwapProgress, aIHotSwap)) then begin
      fProgressForm := TOYProgressForm.Create(Self);
      if not aIHotSwap.AttachWidget(fProgressForm) then begin
        fProgressForm.Free;
        fProgressForm := nil;
      end else begin
        fProgressForm.Parent := nil;
        fProgressForm.ParentWindow := Handle;
      end;
    end;
  end;

begin
  fIProgress := OYProgressForm.OYCreateInstance(nil);

  Edit1.text := ExtractFilePath(Application.ExeName) + '..\source\sample\unit1.pas';
end;

function TForm1.IProgress : IOYProgress;
begin
  Result := fIProgress;
end;

function TForm1.GetDefines : WideString;
begin
  Result := '';
end;

function TForm1.GetSearchPaths : WideString;
begin
  Result := ExtractFilePath(Application.ExeName) + '..\source\inc\';
end;

function TForm1.IgnoreWhitespace : Boolean;
begin
  Result := True;
end;



end.


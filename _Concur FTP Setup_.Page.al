page 50246 "Concur FTP Setup"
{
    ApplicationArea = All;
    Caption = 'Concur FTP Setup';
    PageType = Card;
    SourceTable = "Concur FTP Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("FTP host"; Rec."FTP host")
                {
                    ToolTip = 'Specifies the value of the FTP host field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Username; Rec.Username)
                {
                    ToolTip = 'Specifies the value of the Username field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Private Key"; BlobStr)
                {
                    ToolTip = 'Specifies the value of the Private Key field.', Comment = '%';
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportKey)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    FileName: Text;
                    InStream: InStream;
                    OutStream: OutStream;
                    Base64: Codeunit "Base64 Convert";
                begin
                    if UploadIntoStream('', '', '', FileName, InStream)then begin
                        Rec."Private Key".CreateOutStream(OutStream);
                        OutStream.Write(Base64.ToBase64(InStream));
                        rec.modify();
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec.Count < 1 then begin
            Rec.Init();
            Rec."Entry No.":=1;
            Rec.Insert();
        end;
    end;
    trigger OnAfterGetRecord()
    var
        InStream: InStream;
    begin
        Rec.CalcFields("Private Key");
        Rec."Private Key".CreateInStream((InStream));
        InStream.Read(BlobStr);
    end;
    var BlobStr: Text;
}

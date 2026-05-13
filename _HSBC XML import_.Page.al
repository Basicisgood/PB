page 50194 "HSBC XML import"
{
    ApplicationArea = all;
    PageType = Card;
    // SourceTable = HSBCXMLimport;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(entry; BlobStr)
                {
                    ToolTip = 'Specifies the value of the entry field.', Comment = '%';
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import52)
            {
                ApplicationArea = All;
                Visible = ButtonVisible;

                trigger OnAction()
                var
                    FileInstream: InStream;
                    FileName: Text;
                begin
                    /*  Rec.xmlfile.CreateInStream(InStream);
                     IsImported := Xmlport.Import(Xmlport::"HSBC Inbound CAMT 52", InStream);
                     IF (IsImported = TRUE) THEN
                         MESSAGE('The import from XML is complete.')
                     ELSE
                         MESSAGE(GETLASTERRORTEXT); */
                    UploadIntoStream('', '', '', FileName, FileInstream);
                    if Xmlport.Import(Xmlport::"HSBC Inbound CAMT 52", FileInStream)then Message('Import Done successfully.')
                    else
                        Message(GetLastErrorText());
                end;
            }
            action(Import53)
            {
                ApplicationArea = All;
                Visible = ButtonVisible;

                trigger OnAction()
                var
                    FileInstream: InStream;
                    FileName: Text;
                begin
                    UploadIntoStream('', '', '', FileName, FileInstream);
                    if Xmlport.Import(Xmlport::"HSBC Inbound CAMT 53", FileInStream)then Message('Import Done successfully.')
                    else
                        Message(GetLastErrorText());
                end;
            }
            action(CitiImport53)
            {
                ApplicationArea = All;
                Visible = ButtonVisible;

                trigger OnAction()
                var
                    FileInstream: InStream;
                    FileName: Text;
                begin
                    UploadIntoStream('', '', '', FileName, FileInstream);
                    if Xmlport.Import(Xmlport::CitiCAMT53, FileInStream)then Message('Import Done successfully.')
                    else
                        Message(GetLastErrorText());
                end;
            }
            action(CitiImport52)
            {
                ApplicationArea = All;
                Visible = ButtonVisible;

                trigger OnAction()
                var
                    FileInstream: InStream;
                    FileName: Text;
                begin
                    UploadIntoStream('', '', '', FileName, FileInstream);
                    if Xmlport.Import(Xmlport::CitiCAMT52, FileInStream)then Message('Import Done successfully.')
                    else
                        Message(GetLastErrorText());
                end;
            }
        }
    }
    var BlobStr: Text;
    ButtonVisible: Boolean;
    trigger OnOpenPage()
    var
        tmp: Text;
    begin
        ButtonVisible:=false;
        tmp:=UserId;
        tmp:=tmp.ToUpper();
        if tmp.Contains('TECTURA')then ButtonVisible:=true;
    end;
}

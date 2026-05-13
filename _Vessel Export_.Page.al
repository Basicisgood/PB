page 50241 "Vessel Export"
{
    ApplicationArea = All;
    Caption = 'Vessel Export';
    PageType = List;
    SourceTable = "Vessel Export Inbound";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Datetime"; Rec."Datetime")
                {
                    ToolTip = 'Specifies the value of the Datetime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Data; BlobStr)
                {
                    ToolTip = 'Specifies the value of the Data field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vessel Code"; Rec."Vessel Code")
                {
                    ToolTip = 'Specifies the value of the Vessel Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vessel Name"; Rec."Vessel Name")
                {
                    ToolTip = 'Specifies the value of the Vessel Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Synch; Rec.Synch)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        InStream: InStream;
    begin
        Rec.CalcFields(Rec.Data);
        Rec.Data.CreateInStream(InStream);
        InStream.Read(BlobStr);
    end;
    var BlobStr: Text;
}

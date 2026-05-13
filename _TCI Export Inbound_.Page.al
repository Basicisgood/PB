page 50239 "TCI Export Inbound"
{
    ApplicationArea = All;
    Caption = 'TCI Export Inbound';
    PageType = List;
    SourceTable = "TCI Export Inbound";
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
                    ToolTip = 'Specifies the value of the Content field.';
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
                field(Synched; Rec.Synched)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Details")
            {
                ApplicationArea = All;
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    JsonBuffer: record "JSON Buffer" temporary;
                    InStream: InStream;
                begin
                    JsonBuffer.ReadFromText(BlobStr);
                    page.run(page::"JSon Buffer List", JsonBuffer);
                end;
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

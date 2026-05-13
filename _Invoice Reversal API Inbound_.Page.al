page 50243 "Invoice Reversal API Inbound"
{
    ApplicationArea = All;
    Caption = 'IMOS Payment Reversal API Inbound';
    PageType = List;
    SourceTable = "Invoice Reversal API Inbound";
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
                field("Datetime "; Rec."Datetime ")
                {
                    ToolTip = 'Specifies the value of the Datetime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Cancelled By User"; Rec."Cancelled By User")
                {
                    ApplicationArea = all;
                }
                field("Cancelled Datentime"; Rec."Cancelled Datentime")
                {
                    ApplicationArea = all;
                }
                field(Data; BlobStr)
                {
                    ToolTip = 'Specifies the value of the Data field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Filename; Rec.Filename)
                {
                    ToolTip = 'Specifies the value of the Filename field.';
                    ApplicationArea = All;
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
            action(ProcessJSON)
            {
                Caption = 'Process JSON';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    InStream: InStream;
                    JSONText: Text;
                    ProcessJson: Codeunit "Process Invoice JSON";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    if Rec.FindSet()then repeat Rec.CalcFields(Data);
                            if not Rec.Data.HasValue then Error('The JSONData field is empty.');
                            // Read the Blob field as an InStream
                            Rec.Data.CreateInStream(InStream);
                            // TempBlob.ReadAsText(InStream, TextEncoding::UTF8, JSONText);
                            // Convert the InStream to text
                            InStream.Read(JSONText);
                            // Check if JSONText is not empty
                            if JSONText <> '' then ProcessJson.ProcessReversalJson(JSONText, JSONText, rec)
                            else
                                Error('No JSON data available in the selected record.');
                        until Rec.Next = 0;
                    Rec.Reset();
                    CurrPage.Update(false);
                    if GuiAllowed then Message('Data Processed');
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

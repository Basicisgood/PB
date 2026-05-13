page 50226 "IMOS API Inbound"
{
    ApplicationArea = All;
    Caption = 'IMOS API Inbound';
    PageType = List;
    SourceTable = "IMOS API Inbound";
    UsageCategory = Lists;

    //Editable = false;
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
                field("Transaction No"; Rec."Transaction No")
                {
                    ApplicationArea = all;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = all;
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = all;
                }
                field(Data; BlobStr)
                {
                    ToolTip = 'Specifies the value of the Content field.';
                    ApplicationArea = All;
                }
                field("Processed to Staging"; Rec."Processed to Staging")
                {
                    ApplicationArea = all;
                }
                field("Staging Entry No."; Rec."Staging Entry No.")
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
                            if JSONText <> '' then ProcessJson.ProcessInvoiceJson(JSONText, JSONText, rec)
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

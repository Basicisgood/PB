report 50116 "Process TCI Export Json"
{
    ApplicationArea = All;
    Caption = 'Process TCI Export Json';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("tci export inbound"; "tci export inbound")
        {
            DataItemTableView = WHERE("Vessel Code"=filter(''), "Vessel Name"=filter(''));

            trigger OnAfterGetRecord()
            var
                TempBlob: Codeunit "Temp Blob";
                InStream: InStream;
                JSONText: Text;
                ProcessJson: Codeunit "Process Invoice JSON";
            begin
                "tci export inbound".CalcFields(Data);
                if "tci export inbound".Data.HasValue then begin
                    "tci export inbound".Data.CreateInStream(InStream);
                    InStream.Read(JSONText);
                    if JSONText <> '' then ProcessTCIExportJson(JSONText, JSONText, "tci export inbound");
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    procedure ProcessTCIExportJson(jsonText: Text; jsonText1: Text; var Tciexportinbound: record "tci export inbound")
    var
        JsonObject: JsonObject;
        JsonToken: JsonToken;
        InvoiceObject: JsonObject;
        InvoiceDetailsArray: JsonArray;
        InvoiceDetailObject: JsonObject;
        i: Integer;
        SerializedText: Text;
    begin
        if not JsonObject.ReadFrom(JSONText)then begin
            Error('The JSON text could not be parsed into a JsonObject.');
        end;
        // Retrieve and validate the "invoice" field
        if JsonObject.Get('tcExport', JsonToken)then begin
            if JsonToken.IsObject()then begin
                InvoiceObject:=JsonToken.AsObject();
                InvoiceObject.WriteTo(SerializedText);
            end
            else
            begin
                Error('The "tcExport" field exists but is not a valid object.');
            end;
        end
        else
        begin
            Error('The "tcExport keyword" field is missing.');
        end;
        // Extract the "invoice" object as JsonToken
        if JsonObject.Get('tcExport', JsonToken) and JsonToken.IsObject()then begin
            InvoiceObject:=JsonToken.AsObject();
            if InvoiceObject.Get('VesselCode', JsonToken)then Tciexportinbound."Vessel Code":=JsonToken.AsValue().AsText();
            if InvoiceObject.Get('VesselName', JsonToken)then Tciexportinbound."Vessel Name":=JsonToken.AsValue().AsText();
            Tciexportinbound.Modify();
        end;
    end;
}

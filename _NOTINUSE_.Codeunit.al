codeunit 50165 "NOTINUSE"
{
    TableNo = "IMOS API Inbound";

    trigger OnRun()
    var
        InStream: InStream;
        JsonBuffer: record "JSON Buffer" temporary;
        BlobStr: Text;
    begin
        rec.SetRange("Processed to Staging", false);
        if Rec.FindSet()then repeat Rec.CalcFields(Rec.Data);
                Rec.Data.CreateInStream(InStream);
                InStream.Read(BlobStr);
                JsonBuffer.ReadFromText(BlobStr);
                JsonBuffer.SetRange(Depth, 2);
                JsonBuffer.SetRange("Token type", JsonBuffer."Token type"::String);
                JsonBuffer.SetRange(Path, '=%1', 'invoice.transNo');
                if JsonBuffer.FindSet()then Rec."Transaction No":=JsonBuffer.Value;
                rec.Modify();
            until Rec.Next() = 0;
    end;
}

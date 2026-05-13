codeunit 50166 ImportIMOSJSON
{
    TableNo = "IMOS Json";

    trigger OnRun()
    var
        Imosjson: Record "IMOS Json";
    begin
        Imosjson.Reset();
        Imosjson.Init();
        Imosjson."Entry No.":=0;
        Imosjson.data:='test imos';
        Imosjson.Insert();
    end;
    procedure Getdata(invoice: BigText)
    var
        Imosjson: Record "IMOS Json";
        Cu5324: Codeunit 5324;
    begin
        //if invoice <> '' then begin
        Imosjson.Reset();
        Imosjson.Init();
        Imosjson."Entry No.":=0;
        //Imosjson.data := CopyStr(invoice, 1, 2000);
        //Imosjson.data := format(invoice.Length);
        Imosjson.Insert();
    //end;
    end;
    procedure Getcurrrentdatetime(): Text var
    begin
        exit(Format(CurrentDateTime));
    end;
}

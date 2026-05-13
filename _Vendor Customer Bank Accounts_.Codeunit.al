codeunit 50175 "Vendor Customer Bank Accounts"
{
    [EventSubscriber(ObjectType::Table, Database::"Vendor Bank Account", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertVA(var Rec: Record "Vendor Bank Account"; RunTrigger: Boolean)
    var
        Vendor: Record Vendor;
    begin
        exit;
        Vendor.get(Rec."Vendor No.");
        Vendor.CalcFields("Max Bank Ref ID");
        if Vendor."Max Bank Ref ID" = '' then rec."IMOS Ext Ref":='B1'
        else
        begin
            Rec."IMOS Ext Ref":=IncStr(Vendor."Max Bank Ref ID");
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Customer Bank Account", 'OnAfterInsertEvent', '', false, false)]
    local procedure InsertCBA(var Rec: Record "Customer Bank Account"; RunTrigger: Boolean)
    var
        Customer: Record Customer;
    begin
        Customer.get(Rec."customer No.");
        Customer.CalcFields("Max Bank Ref ID");
        if Customer."Max Bank Ref ID" = '' then rec."IMOS Ext Ref":='B1'
        else
        begin
            Rec."IMOS Ext Ref":=IncStr(Customer."Max Bank Ref ID");
        end;
    end;
}

codeunit 50154 "API Invoice Payment Update"
{
    trigger OnRun()
    var
        iCounter: Integer;
        DNVInvoice: Record "PB Purchase Invoice Inbound";
        DNVOutboundLog: Record "DNV Outbound Log";
        VLE: Record "Vendor Ledger Entry";
        VLE2: Record "Vendor Ledger Entry";
        CuDNVPaymentUpdateAPI: Codeunit "DNV Payment Update API";
    begin
        DNVInvoice.Reset();
        DNVInvoice.SetRange(Paid, false);
        DNVInvoice.SetFilter(status, '<>%1', DNVInvoice."Status"::Cancel);
        if not DNVInvoice.FindSet()then exit;
        repeat DNVOutboundLog.Reset();
            DNVOutboundLog.SetRange("DNV Invoice Entry No.", DNVInvoice."Entry No.");
            if not DNVOutboundLog.FindSet()then begin
                DNVOutboundLog.Reset();
                VLE.Reset();
                VLE.SetRange("Document No.", DNVInvoice."Posted Document No Fin Company");
                vle.SetFilter("Closed by Entry No.", '<>%1', 0);
                if vle.FindSet()then begin
                    VLE2.Reset();
                    vle2.Get(VLE."Closed by Entry No.");
                    DNVOutboundLog.Init();
                    DNVOutboundLog."Entry No.":=0;
                    DNVOutboundLog."Table No.":=25;
                    DNVOutboundLog."Company Name":=CompanyName;
                    DNVOutboundLog."DNV Invoice Entry No.":=DNVInvoice."Entry No.";
                    DNVOutboundLog."External Document No.":=DNVInvoice.Code;
                    DNVOutboundLog."Currency Code":=DNVInvoice."Currency Code";
                    DNVOutboundLog."Invoice No.":=DNVInvoice."Posted Document No Fin Company";
                    DNVOutboundLog."Invoice Posting Date":=vle."Posting Date";
                    DNVOutboundLog."Ship Manager ID":=DNVInvoice."Ship Manager";
                    DNVOutboundLog."Payment Date":=vle2."Payment Date";
                    DNVOutboundLog."Payment Document No.":=VLE2."Document No.";
                    DNVOutboundLog."Bank Document No.":=VLE2."Bank Document No.";
                    DNVOutboundLog."Primary key":=VLE2."Document No.";
                    DNVOutboundLog."Primary key 2":=VLE."Document No.";
                    DNVOutboundLog.Insert();
                    DNVInvoice.Paid:=true;
                    DNVInvoice.Modify();
                end;
            end
            else
            begin
                DNVInvoice.Paid:=true;
                DNVInvoice.Modify();
            end;
        until DNVInvoice.Next() = 0;
        Commit();
        Clear(CuDNVPaymentUpdateAPI);
        CuDNVPaymentUpdateAPI.Run()end;
}

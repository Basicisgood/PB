table 50120 "Vendor Type Mapping"
{
    Caption = 'Vendor Type Mapping';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Type";enum "Company Type")
        {
            Caption = 'Type';
        }
        field(2; "Vendor/Customer No."; Code[20])
        {
            Caption = 'Vendor/Customer No.';
            TableRelation = if("Type"=const(Customer))Customer."No."
            else
            Vendor."No.";
        }
        field(3; "Vendor Type Dimension"; Code[20])
        {
            Caption = 'Vendor Type Dimension';
            TableRelation = Dimension;
        }
        field(4; "Vendor Type"; Code[20])
        {
            Caption = 'Vendor Type';
            TableRelation = "Dimension Value".Code where("Dimension Code"=field("Vendor Type Dimension"));

            trigger OnValidate()
            var
                Log: Record "IMOS API Log";
                DimensionValue: Record "Dimension Value";
            begin
                DimensionValue.Reset();
                DimensionValue.SetRange("Dimension Code", Rec."Vendor Type Dimension");
                DimensionValue.SetRange(Code, Rec."Vendor Type");
                if DimensionValue.FindFirst()then begin
                    Rec.Validate("Company Type", DimensionValue."Company Type");
                end;
            /*
                    Log.reset;
                    Log.SetCurrentKey("Table No.", "Primary key", Status);
                    Log.SetRange("Table No.", Database::"Vendor Type Mapping");
                    Log.SetRange("Primary key", Rec."Type");
                    Log.SetRange("Primary key 2", Rec."Company No.");
                    Log.SetRange("Primary key 3", Rec."Company Dimension");
                    Log.SetRange("Primary key 4", Rec."Company Dimension Value");
                    Log.SetRange("Entry Type", Log."Entry Type"::Insert);
                    Log.SetFilter(Status, '<>%1', Log.Status::Success);
                    IF Log.FindFirst() then begin
                        CreateOutboundLogForIMOS(1);
                        if (Rec.Type = Rec.Type::Vendor) and (Rec."Company Type" = Rec."Company Type"::DNV) then
                            CreateOutboundLog(1);
                    end else begin
                        CreateOutboundLogForIMOS(0);
                        if (Rec.Type = Rec.Type::Vendor) and (Rec."Company Type" = Rec."Company Type"::DNV) then
                            CreateOutboundLog(0);
                    end;
    */
            end;
        }
        field(5; Sync; Boolean)
        {
            Caption = 'Sync';
        }
        field(6; "Company Type"; Option)
        {
            Editable = false;
            OptionMembers = " ", DNV, IMOS, OTHERS;
            OptionCaption = ' ,DNV,IMOS,OTHERS';

            trigger OnValidate()
            begin
                if(Rec.Type = Rec.Type::Customer) and (Rec."Company Type" = Rec."Company Type"::DNV)then Error('');
            end;
        }
        field(10; "IMOS Company No"; Text[20])
        {
            Caption = 'IMOS Company No';
        }
        field(12; "DAX No"; Text[20])
        {
            Caption = 'DAX No';
        }
    }
    keys
    {
        key(PK; "Type", "Vendor/Customer No.", "Vendor Type", "Vendor Type Dimension")
        {
            Clustered = true;
        }
        key(VCNo; "Vendor/Customer No.", "Company Type")
        {
        }
        key(comp; "IMOS Company No")
        {
        }
    }
    // trigger OnInsert()
    // begin
    //     CreateOutboundLogForIMOS(0);
    //     if (Rec.Type = Rec.Type::Vendor) and (Rec."Company Type" = Rec."Company Type"::DNV) then
    //         CreateOutboundLog(0);
    // end;
    // trigger OnModify()
    // begin
    //     CreateOutboundLogForIMOS(1);
    //     if (Rec.Type = Rec.Type::Vendor) and (Rec."Company Type" = Rec."Company Type"::DNV) then
    //         CreateOutboundLog(0);
    // end;
    procedure CreateOutboundLog(P_Type: Option Insert, Update)
    var
        OutboundLog: Record "DNV Outbound Log";
        vendLedgerEntry2: Record "Vendor Ledger Entry";
        Log: Record "DNV Outbound Log";
    begin
        Log.reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", Database::Vendor);
        Log.SetRange("Primary key", Rec."Vendor/Customer No.");
        Log.SetRange("Primary key 2", Rec."Vendor Type");
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        IF Not Log.FindFirst()then begin
            OutboundLog.Init();
            OutboundLog."Table No.":=Database::Vendor;
            OutboundLog."Primary key":=Rec."Vendor/Customer No.";
            OutboundLog."Primary key 2":=Rec."Vendor Type";
            OutboundLog."Entry Type":=P_Type;
            OutboundLog.Status:=OutboundLog.Status::Pending;
            OutboundLog.Insert(true);
        End;
    end;
    procedure CreateOutboundLogForIMOS(P_Type: Option Insert, Update)
    var
        IMOSOutboundLog: Record "IMOS API Log";
        Log: Record "IMOS API Log";
        VendorBankAccounts: Record "Vendor Bank Account";
        CustomerBankAccounts: Record "Customer Bank Account";
    begin
        if Rec."Vendor Type" = '' then exit;
        Log.reset;
        Log.SetCurrentKey("Table No.", "Primary key", Status);
        Log.SetRange("Table No.", Database::"Vendor Type Mapping");
        Log.SetRange("Primary key", Rec."Type");
        Log.SetRange("Primary key 2", Rec."Vendor/Customer No.");
        Log.SetRange("Primary key 3", Rec."Vendor Type Dimension");
        Log.SetRange("Primary key 4", Rec."Vendor Type");
        Log.SetFilter(Status, '<>%1', Log.Status::Success);
        IF Not Log.FindFirst()then begin
            IMOSOutboundLog.Init();
            IMOSOutboundLog."Entry No.":=0;
            IMOSOutboundLog."Table No.":=Database::"Vendor Type Mapping";
            IMOSOutboundLog."Primary key":=Rec."Type";
            IMOSOutboundLog."Primary key 2":=Rec."Vendor/Customer No.";
            IMOSOutboundLog."Primary key 3":=Rec."Vendor Type Dimension";
            IMOSOutboundLog."Primary key 4":=Rec."Vendor Type";
            IMOSOutboundLog."Entry Type":=P_Type;
            IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
            IMOSOutboundLog.Insert(true);
            if rec.Type = rec.Type::Customer then begin
                CustomerBankAccounts.Reset();
                CustomerBankAccounts.SetRange("Customer No.", rec."Vendor/Customer No.");
                if CustomerBankAccounts.FindSet()then repeat IMOSOutboundLog.Init();
                        IMOSOutboundLog."Entry No.":=0;
                        IMOSOutboundLog."Table No.":=Database::"Customer Bank Account";
                        IMOSOutboundLog."Primary key":=IMOSOutboundLog."Primary key"::Customer;
                        IMOSOutboundLog."Primary key 2":=CustomerBankAccounts."Customer No.";
                        IMOSOutboundLog."Primary key 3":=CustomerBankAccounts.Code;
                        IMOSOutboundLog."Entry Type":=IMOSOutboundLog."Entry Type"::Insert;
                        IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
                        IMOSOutboundLog."Primary key 4":=Rec."Vendor Type";
                        IMOSOutboundLog.Insert(true);
                    until CustomerBankAccounts.Next() = 0;
            end;
            if rec.Type = rec.Type::Vendor then begin
                VendorBankAccounts.Reset();
                VendorBankAccounts.SetRange("Vendor No.", rec."Vendor/Customer No.");
                VendorBankAccounts.SetFilter("Vendor Type", '=%1|%2', VendorBankAccounts."Vendor Type"::BOTH, VendorBankAccounts."Vendor Type"::IMOS);
                if VendorBankAccounts.FindSet()then repeat IMOSOutboundLog.Init();
                        IMOSOutboundLog."Entry No.":=0;
                        IMOSOutboundLog."Table No.":=Database::"Vendor Bank Account";
                        IMOSOutboundLog."Primary key":=IMOSOutboundLog."Primary key"::Vendor;
                        IMOSOutboundLog."Primary key 2":=VendorBankAccounts."Vendor No.";
                        IMOSOutboundLog."Primary key 3":=VendorBankAccounts.Code;
                        IMOSOutboundLog."Entry Type":=IMOSOutboundLog."Entry Type"::Insert;
                        IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
                        IMOSOutboundLog."Primary key 4":=Rec."Vendor Type";
                        IMOSOutboundLog.Insert(true);
                    until VendorBankAccounts.Next() = 0;
            end;
        End;
    end;
}

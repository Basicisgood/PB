table 50155 "Company Name Mapping"
{
    Caption = 'Company Name Mapping';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "BC Company Name"; Text[50])
        {
            Caption = 'BC Company Name';
            TableRelation = Company;
            NotBlank = true;
        }
        field(2; "PB Company Code"; Text[50])
        {
            Caption = 'PB Company Code';
        }
        field(3; "DNV Company"; Boolean)
        {
        }
        field(4; "Test Company"; Boolean)
        {
            Caption = 'Test Company';
        }
        field(5; "Master Data Company"; Boolean)
        {
            trigger OnValidate()
            var
                CompNameMapping: Record "Company Name Mapping";
            begin
                if "Master Data Company" then begin
                    CompNameMapping.Reset();
                    CompNameMapping.SetFilter("BC Company Name", '<>%1', Rec."BC Company Name");
                    CompNameMapping.SetRange("Master Data Company", true);
                    if CompNameMapping.FindSet()then Error('Master data company already defined');
                end;
            end;
        }
        field(6; "IMOS Company"; Boolean)
        {
        }
        field(7; "GNA Company"; Boolean)
        {
        }
        field(8; "Consolidation Company"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "COA Template Code"; Code[20])
        {
            Caption = 'COA Template Code';
            TableRelation = "COA Template";
        }
        field(10; "Central payment company"; text[2000])
        {
            Caption = 'Central payment company';
        // TableRelation = Company;
        }
        field(11; "Current Account No."; code[20])
        {
            Caption = 'Current Account No.';
            TableRelation = "G/L Account"."No." where("Direct Posting"=filter(True));
        }
        field(12; "Ship COmpany"; Boolean)
        {
            Caption = 'Ship Company';
        }
        field(13; "IMOS Company code"; Code[3])
        {
        }
        field(20; "Select"; Boolean)
        {
        //used in temporary page
        }
        //PS006 Start
        field(21; "Sync Employees"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if "Sync Employees" then rec.TestField("Master Data Company", false);
            end;
        }
        field(22; "Autopost Depreciation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //PS006 End
        //PS011 STart
        field(23; DBase; text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "DBase Setup";
        }
        //PS011 End
        //PS015 STart
        field(24; "Budget Company"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //PS015 End
        field(25; "Marcura Debit Bank Account No"; Code[30])
        {
            DataClassification = ToBeClassified;
        //            TableRelation = "Bank Account";
        //ValidateTableRelation = false;
        }
        field(26; "Concur Company Code"; Code[20]) //TEC.VJ 30Oct2025 Field Added
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "BC Company Name")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        CheckCompanyType;
    end;
    trigger OnModify()
    begin
        CheckCompanyType;
    end;
    procedure CheckCompanyType()
    var
    begin
        exit;
        if(Rec."DNV Company" = false) or (Rec."IMOS Company" = false) or (Rec."Test Company" = false) or (Rec."Consolidation Company" = false) or (Rec."GNA Company" = false) or (Rec."Master Data Company" = false)then error('Select Company Type');
    end;
    //TEC.VJ 30Oct2025 <<
    procedure GetConcurCompCode(BCCompCode: Text): Text var
        CompNameMapping: Record "Company Name Mapping";
    begin
        CompNameMapping.SetRange("BC Company Name", BCCompCode);
        if CompNameMapping.FindFirst()then exit(CompNameMapping."Concur Company Code");
    end;
    procedure GetBCCompCode(ConcurCompCode: Text): Text var
        CompNameMapping: Record "Company Name Mapping";
    begin
        CompNameMapping.SetRange("Concur Company Code", ConcurCompCode);
        if CompNameMapping.FindFirst()then exit(CompNameMapping."BC Company Name");
    end;
//TEC.VJ 30Oct2025 >>
}

table 50218 "IMOS Voyage Lookup Table"
{
    Caption = 'IMOS Voyage Lookup Table';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; Vessel; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; FD1Name; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; FD2; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_rec_GLSetup: Record "General Ledger Setup";
                l_rec_DimenValue: Record "Dimension Value";
            begin
                if l_rec_GLSetup.Get()then;
                l_rec_DimenValue.Reset();
                l_rec_DimenValue.SetRange("Dimension Code", l_rec_GLSetup."Global Dimension 2 Code");
                if l_rec_DimenValue.FindSet()then begin
                    if Page.RunModal(Page::"Dimension Values", l_rec_DimenValue) = Action::LookupOK then FD2:=l_rec_DimenValue.Code;
                end;
            end;
        }
        field(4; FD4; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_rec_GLSetup: Record "General Ledger Setup";
                l_rec_DimenValue: Record "Dimension Value";
            begin
                if l_rec_GLSetup.Get()then;
                l_rec_DimenValue.Reset();
                l_rec_DimenValue.SetRange("Dimension Code", l_rec_GLSetup."Shortcut Dimension 4 Code");
                if l_rec_DimenValue.FindSet()then begin
                    if Page.RunModal(Page::"Dimension Values", l_rec_DimenValue) = Action::LookupOK then FD4:=l_rec_DimenValue.Code;
                end;
            end;
        }
        field(5; FD3; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_rec_GLSetup: Record "General Ledger Setup";
                l_rec_DimenValue: Record "Dimension Value";
            begin
                if l_rec_GLSetup.Get()then;
                l_rec_DimenValue.Reset();
                l_rec_DimenValue.SetRange("Dimension Code", l_rec_GLSetup."Shortcut Dimension 3 Code");
                if l_rec_DimenValue.FindSet()then begin
                    if Page.RunModal(Page::"Dimension Values", l_rec_DimenValue) = Action::LookupOK then FD3:=l_rec_DimenValue.Code;
                end;
            end;
        }
        field(6; "Opr Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Voyage Start/GMT"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Voyage End/GMT"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Full On Hire Days"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10; LOB; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Voyage Trade Area"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Voyage Status"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "TC In Contract Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Contract Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Index/Non Index"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Period; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Year: Integer;
                Month: Integer;
            begin
                if Evaluate(Year, CopyStr(Period, 1, 4))then;
                if Evaluate(Month, CopyStr(Period, 6, 2))then;
                "Period Date":=DMY2Date(1, Month, Year);
            end;
        }
        field(17; "Opr_LOB"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Opr_Trade_Area"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(19; LastVoy; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(20; COA; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(21; "Core Operating"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(22; ANAL_T3_KEY; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(23; T2Key; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(24; T3Key; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; T4Key; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(26; NewContractType; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(27; NewContractType1; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "TC Type"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(29; NewContractType_full; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(30; NewContractType_RA; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(31; OP2_3; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(32; OP2_3A; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Period Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; FD1Name, FD2, FD4, FD3, Period, "TC Type", NewContractType_full)
        {
            Clustered = true;
        }
    }
}

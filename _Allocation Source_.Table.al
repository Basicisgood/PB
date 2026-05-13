table 50101 "Allocation Source"
{
    Caption = 'Allocation Source';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Rule; Code[20])
        {
            Caption = 'Rule';
            DataClassification = CustomerContent;
            TableRelation = "Allocation Rule";
        }
        field(3; "Line No."; integer)
        {
        }
        field(2; "Field Setting"; Option)
        {
            Caption = 'Field Setting';
            DataClassification = CustomerContent;
            OptionMembers = "Main Account", "Financial Dimension";
            OptionCaption = 'Main Account,Financial Dimension';
        }
        field(5; Name; Code[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            TableRelation = If("Field Setting"=const("Financial Dimension"))"Dimension";
        }
        field(6; "No markup"; Boolean)
        {
        }
        field(10; "Source Criteria"; Text[250])
        {
            Caption = 'Source Criteria';
            DataClassification = CustomerContent;
            TableRelation = if("Field Setting"=const("Main Account"))"G/L Account"
            else if("Field Setting"=const("Financial Dimension"))"Dimension Value".Code where("Dimension Code"=field(Name));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                l_rec_GLList: Record "G/L Account";
                l_pag_GLList: Page "Chart of Accounts (G/L)";
                l_Rec_DimList: Record "Dimension Value";
                l_pag_DimList: Page "Dimension Value List";
            begin
                CASE "Field Setting" of "Field Setting"::"Main Account": begin
                    CLEAR(l_pag_GLList);
                    l_pag_GLList.LookupMode:=TRUE;
                    IF l_pag_GLList.RunModal() = Action::LookupOK THEN begin
                        "Source Criteria":=l_pag_GLList.GetSelectionFilter();
                    end;
                end;
                "Field Setting"::"Financial Dimension": begin
                    TESTFIELD(Name);
                    l_Rec_DimList.RESET;
                    l_Rec_DimList.SETRANGE("Dimension Code", Name);
                    IF l_Rec_DimList.FINDSET THEN;
                    CLEAR(l_pag_DimList);
                    l_pag_DImList.SetTableView(l_Rec_DimList);
                    l_pag_DimList.LookupMode:=TRUE;
                    IF l_pag_DimList.RunModal() = Action::LookupOK THEN begin
                        "Source Criteria":=l_pag_DimList.GetSelectionFilter;
                    end;
                end;
                END;
            end;
        }
        field(34; "Last Source Amount get"; decimal)
        {
        }
        field(35; "Last Get From Date"; Date)
        {
        }
        field(36; "Last Get To Date"; Date)
        {
        }
    }
    keys
    {
        key(PK; Rule, "Line No.")
        {
            Clustered = true;
        }
    }
}

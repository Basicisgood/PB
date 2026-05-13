table 50100 "Allocation Rule"
{
    Caption = 'Allocation Rule';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Rule; Code[20])
        {
            Caption = 'Rule';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                CreateNumbering;
            end;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(8; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            DataClassification = CustomerContent;
        }
        field(9; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
        }
        field(10; Active; Boolean)
        {
            Caption = 'Active';
            DataClassification = CustomerContent;
        }
        field(11; "Date Last Run"; Date)
        {
            Caption = 'Date Last Run';
            DataClassification = CustomerContent;
        }
        field(12; "Intercompany Rule"; Boolean)
        {
            Caption = 'Intercompany Rule';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                l_Rec_GenJnlBatch: Record "Gen. Journal Batch";
            begin
                l_Rec_GenJnlBatch.RESET;
                l_Rec_GenJnlBatch.SETRANGE(Name, "Journal Batch Name");
                //TEC#001>>
                /* IF "Intercompany Rule" THEN begin
                    l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", 'INTERCOMP');
                end ELSE begin
                    l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", 'GENERAL');
                end; */
                l_Rec_GenJnlBatch.SetRange("Journal Template Name", "Journal Template Name");
                //TEC#001<<
                IF NOT l_Rec_GenJnlBatch.FINDSET THEN begin
                    "Journal Batch Name":='';
                end;
            end;
        }
        field(20; "Allocation method";Enum "Allocation method ENum")
        {
            Caption = 'Allocation method';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                IF "Allocation method" = "Allocation method"::Point THEN begin
                    IF "Date Interval Code" <> "Date Interval Code"::MTD THEN begin
                        MESSAGE('Date Interval Code set to MTD');
                        "Date Interval Code":="Date Interval Code"::MTD;
                    end;
                end;
                if "Allocation method" = "Allocation method"::OperatingDaysXRatio THEN begin
                    IF "Date Interval Code" <> "Date Interval Code"::MTD THEN begin
                        MESSAGE('Date Interval Code set to MTD');
                        "Date Interval Code":="Date Interval Code"::MTD;
                    end;
                    IF "Point Calculation Day Type" <> "Point Calculation Day Type"::"Operating Days" THEN begin
                        MESSAGE('Point Calculation Day Type set to Operating Days');
                        "Point Calculation Day Type":="Point Calculation Day Type"::"Operating Days";
                    end;
                end;
                if("Allocation method" <> "Allocation method"::Ratio) AND ("Date Interval Code" = "Date Interval Code"::Min)then begin
                    MESSAGE('Date Interval Code set to MTD');
                    "Date Interval Code":="Date Interval Code"::MTD;
                end;
            end;
        }
        field(21; "Journal Batch Name"; Code[20])
        {
            trigger OnLookup()
            var
                l_Rec_GenJnlBatch: REcord "Gen. Journal Batch";
                l_pag_GenJnlBatch: Page "General Journal Batches";
            begin
                l_Rec_GenJnlBatch.RESET;
                //TEC#001>>
                /*  IF "Intercompany Rule" THEN begin
                     l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", 'INTERCOMP');
                 end ELSE begin
                     l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", 'GENERAL');
                 ENd; */
                l_Rec_GenJnlBatch.SetRange("Journal Template Name", "Journal Template Name");
                //TEC#001<<
                //l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", "Journal Template Name");
                IF l_Rec_GenJnlBatch.FINDSET THEN;
                CLEAR(l_pag_GenJnlBatch);
                l_pag_GenJnlBatch.LookupMode:=TRUE;
                l_pag_GenJnlBatch.SetTableView(l_Rec_GenJnlBatch);
                IF l_pag_GenJnlBatch.RunModal() = Action::LookupOK THEN begin
                    l_pag_GenJnlBatch.GetRecord(l_Rec_GenJnlBatch);
                    "Journal Batch Name":=l_Rec_GenJnlBatch.Name;
                end;
            end;
            trigger OnValidate()
            var
                l_Rec_GenJnlBatch: Record "Gen. Journal Batch";
            begin
                l_Rec_GenJnlBatch.RESET;
                l_Rec_GenJnlBatch.SETRANGE(Name, "Journal Batch Name");
                //TEC#001>>
                /*  IF "Intercompany Rule" THEN begin
                     l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", 'INTERCOMP');
                 end ELSE begin
                     l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", 'GENERAL');
                 end; */
                l_Rec_GenJnlBatch.SetRange("Journal Template Name", "Journal Template Name");
                //TEC#001<<
                IF NOT l_Rec_GenJnlBatch.FINDSET THEN begin
                    Error('Invalid Batch entered');
                end;
            end;
        }
        field(22; "Journal Description"; Text[100])
        {
        }
        field(23; "Data Source";Enum "Allocation Data Source ENum")
        {
        }
        field(24; "Date Interval Code";ENum "Date Interval Setup ENum")
        {
            trigger OnValidate()
            begin
                if "Date Interval Code" = "Date Interval Code"::Min THEN begin
                    "Allocation method":="Allocation method"::Ratio;
                end;
            end;
        }
        field(25; "Offset Account From";Enum "Allocation From ENum")
        {
        }
        field(26; "Offset Account No."; Code[20])
        {
            TableRelation = "G/L Account"."No.";
        }
        field(27; "Offset Dimension From";Enum "Allocation From ENum")
        {
        }
        //Default Dimension
        field(28; MathCalculation;Enum "Allocation Multiply")
        {
        }
        field(29; "Math Ratio"; Decimal)
        {
        }
        field(30; "No. Series"; Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(31; "Fixed Amount"; Decimal)
        {
        }
        field(32; "Calc Total Weight"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Allocation Destination"."Fixed Weight" where(Rule=field(Rule)));
        }
        field(33; "Calc Total Percentage"; Integer)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Allocation Destination"."Fixed Percentage" where(Rule=field(Rule)));
        }
        field(34; "Last Source Amount to Split"; decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Allocation Source"."Last Source Amount get" where(Rule=field(Rule)));
        }
        field(35; "Last Dest. Total PointXDays"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Allocation Destination"."Last Destination POintXDays" where(Rule=field(Rule)));
        }
        field(36; "Point Calculation Day Type";Enum AllocationPointDayType)
        {
        }
        field(37; "Execute Run System Date"; Date)
        {
            Editable = false;
        }
        field(38; "Journal Template Name"; code[10])
        {
            TableRelation = if("Intercompany Rule"=const(True))"Gen. Journal Template".Name where(Type=const(Intercompany))
            else if("Intercompany Rule"=const(false))"Gen. Journal Template".Name where(Type=const(General));
        }
    }
    keys
    {
        key(PK; Rule)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        CreateNumbering;
    end;
    procedure CreateNumbering()
    var
        l_Cdu_NoSeries: COdeunit "No. Series";
        l_rec_GLS: Record "General Ledger Setup";
    begin
        IF l_rec_GLS.GET()THEN;
        IF Rule = '' THEN begin
            l_rec_GLS.TESTFIELD("Allocation Rule No. Series");
            Rule:=l_Cdu_NoSeries.GetNextNo(l_rec_GLS."Allocation Rule No. Series", TODAY);
        end;
    end;
    var g_Rec_DefaultDimension: Record "Default Dimension";
}

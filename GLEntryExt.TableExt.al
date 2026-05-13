tableextension 50105 GLEntryExt extends "G/L Entry"
{
    fields
    {
        //   field(50130; "Original Amount to Apply PB"; Decimal)
        //{  //Created on 9May24
        //     editable = false;
        //}
        field(50004; "Applying Entry PB"; Boolean)
        {
        }
        field(50005; "Closed PB"; Boolean)
        {
            Caption = 'Closed';
        }
        field(50006; "Applied Amount PB"; Decimal)
        {
            CalcFormula = -Sum("Detailed G/L Entry PB".Amount where("G/L Entry No."=field("Entry No."), "Entry Type"=filter(<>"Initial Entry"), "Posting Date"=field("Date Filter PB")));
            Caption = 'Applied Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Closed at Date PB"; Date)
        {
        }
        field(50008; "Date Filter PB"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(50025; "Applied Amount (LCY) PB"; Decimal)
        {
            CalcFormula = -Sum("Detailed G/L Entry PB"."Amount (LCY)" where("G/L Entry No."=field("Entry No."), "Entry Type"=filter(<>"Initial Entry"), "Posting Date"=field("Date Filter PB")));
            Caption = 'Applied Amount LCY';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "Remaining Amount PB"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed G/L Entry PB"."Amount" where("G/L Entry No."=field("Entry No.")));
        }
        field(50029; "Remaining Amount (LCY) PB"; Decimal)
        {
            Caption = 'Remaining Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = sum("Detailed G/L Entry PB"."Amount (LCY)" where("G/L Entry No."=field("Entry No.")));
        }
        field(50030; "Amount to Apply (LCY) PB"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount to Apply (LCY)';

            // Editable = false;
            trigger OnValidate()
            var
                SameSignErr: Label '%1 must have the same sign as %2.', Comment = '%1 = FieldCaption Amount to Apply, %2 = FieldCaption Amount';
                DifferenceErr: Label '%1 must not be larger than difference between %2 and %3.', Comment = '%1 = FieldCaption Amount to Apply, %2 = FieldCaption Amount, %3 = FieldCaption Applied Amount';
            begin
                CalcFields("Applied Amount PB");
                CalcFields("Applied Amount (LCY) PB");
                // if "Amount to Apply PB" * "Amount" < 0 then
                //     Error(SameSignErr, FieldCaption("Amount to Apply PB"), FieldCaption(Amount));
                // if Abs("Amount to Apply PB") > Abs("Amount" - "Applied Amount PB") then
                //     Error(DifferenceErr, FieldCaption("Amount to Apply PB"), FieldCaption(Amount), FieldCaption("Applied Amount PB"));
                if "Amount to Apply (LCY) PB" * "Amount" < 0 then Error(SameSignErr, FieldCaption("Amount to Apply (LCY) PB"), FieldCaption(Amount));
                if Abs("Amount to Apply (LCY) PB") > Abs("Amount" - "Applied Amount (LCY) PB")then Error(DifferenceErr, FieldCaption("Amount to Apply (LCY) PB"), FieldCaption(Amount), FieldCaption("Applied Amount (LCY) PB"));
                //   Sgarg - Code Added <<
                // if "Amount to Apply PB" * "Original Amount PB" < 0 then
                //     Error(SameSignErr, FieldCaption("Amount to Apply PB"), FieldCaption(Amount));
                // if Abs("Amount to Apply PB") > Abs("Original Amount PB" - "Applied Amount PB") then
                //     Error(DifferenceErr, FieldCaption("Amount to Apply PB"), FieldCaption(Amount), FieldCaption("Applied Amount PB"));
                // //   Sgarg - Code Added <<
                //IF "Original Amount PB" <> 0 then //Sgarg - Added - 24Oct24
                //    "Amount to Apply (LCY) PB" := ("Amount to Apply PB" / "Original Amount PB") * Amount;  //Sgarg - Added
                IF Amount <> 0 then begin
                    IF Rec."Adjusted Curr. Factor PB" <> 0 then "Amount to Apply PB":="Amount to Apply (LCY) PB" * "Adjusted Curr. Factor PB"
                    else
                        "Amount to Apply PB":=("Amount to Apply (LCY) PB" * "Original Amount PB" / Amount);
                    IF "Amount to Apply PB" > "Original Amount PB" then "Amount to Apply PB":="Original Amount PB";
                end;
            // IF "Original Amount PB" <> 0 then //Sgarg - Added - 9 May25
            //     "Original Amount to Apply PB" := ("Amount to Apply PB" / Amount) * "Original Amount PB";  //Sgarg - Added
            end;
        }
        field(50038; "Skip Detail GLE"; Boolean)
        {
        }
        // field(50039; "Apply General Entries PB"; Boolean)
        // {
        //     Caption = 'Apply General Entries';
        //     Editable = false;
        // } //Dorothy
        field(50040; "GL Reval"; Boolean)
        {
        } //revaluation of GL Entry
        field(50041; "Revalued"; Boolean) //Shanky- 250725
        {
        }
        field(50110; "Shortcut Dimension 3 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3));
        }
        field(50111; "Shortcut Dimension 4 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4));
        }
        field(50112; "Shortcut Dimension 5 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5));
        }
        field(50113; "Shortcut Dimension 6 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6));
        }
        field(50114; "Shortcut Dimension 7 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7));
        }
        field(50115; "Shortcut Dimension 8 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8));
        }
        field(50116; "Shortcut Dimension 9 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9));
        }
        field(50117; "Shortcut Dimension 10 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,10';
            Caption = 'Shortcut Dimension 10 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10));
        }
        field(50118; "Shortcut Dimension 11 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,11';
            Caption = 'Shortcut Dimension 11 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(11));
        }
        field(50119; "Shortcut Dimension 12 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,12';
            Caption = 'Shortcut Dimension 12 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(12));
        }
        field(50120; "Shortcut Dimension 13 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,13';
            Caption = 'Shortcut Dimension 13 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(13));
        }
        field(50121; "Shortcut Dimension 14 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,14';
            Caption = 'Shortcut Dimension 14 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(14));
        }
        field(50122; "Shortcut Dimension 15 Code_PB"; Code[20])
        {
            CaptionClass = '1,2,15';
            Caption = 'Shortcut Dimension 15 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(15));
        }
        field(50123; "Original Currency PB"; Code[20])
        {
            Caption = 'Original Currency';
            TableRelation = Currency;
        }
        field(50124; "Original Amount PB"; decimal)
        {
            Caption = 'Original Amount';
        }
        field(50125; "Original Currency Factor PB"; Decimal)
        {
            Caption = 'Original Currency Factor';
            DecimalPlaces = 2: 25;
        }
        field(50126; "Adjusted Curr. Factor PB"; Decimal)
        {
            Caption = 'Adjusted Currency Factor';
            DecimalPlaces = 2: 25;
        }
        field(50127; "Include Revaluation"; Boolean)
        {
            Editable = false;
        }
        field(50128; "Applies-to ID PB"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                ApplyGLEntries: Page "Apply G/L Entries PB";
            begin
                ApplyGLEntries.CheckAppliesToID(Rec);
            end;
        }
        field(50129; "Amount to Apply PB"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount to Apply';
            Editable = false;

            trigger OnValidate()
            var
                SameSignErr: Label '%1 must have the same sign as %2.', Comment = '%1 = FieldCaption Amount to Apply, %2 = FieldCaption Amount';
                DifferenceErr: Label '%1 must not be larger than difference between %2 and %3.', Comment = '%1 = FieldCaption Amount to Apply, %2 = FieldCaption Amount, %3 = FieldCaption Applied Amount';
            begin
                CalcFields("Applied Amount PB");
                // if "Amount to Apply PB" * "Amount" < 0 then
                //     Error(SameSignErr, FieldCaption("Amount to Apply PB"), FieldCaption(Amount));
                // if Abs("Amount to Apply PB") > Abs("Amount" - "Applied Amount PB") then
                //     Error(DifferenceErr, FieldCaption("Amount to Apply PB"), FieldCaption(Amount), FieldCaption("Applied Amount PB"));
                if "Amount to Apply PB" * "Original Amount PB" < 0 then Error(SameSignErr, FieldCaption("Amount to Apply PB"), FieldCaption(Amount));
                if Abs("Amount to Apply PB") > Abs("Original Amount PB" - "Applied Amount PB")then Error(DifferenceErr, FieldCaption("Amount to Apply PB"), FieldCaption(Amount), FieldCaption("Applied Amount PB"));
            //   Sgarg - Code Added <<
            //IF "Original Amount PB" <> 0 then //Sgarg - Added - 24Oct24
            //    "Amount to Apply (LCY) PB" := ("Amount to Apply PB" / "Original Amount PB") * Amount;  //Sgarg - Added
            // IF "Original Amount PB" <> 0 then //Sgarg - Added - 9 May25
            //     "Original Amount to Apply PB" := ("Amount to Apply PB" / Amount) * "Original Amount PB";  //Sgarg - Added
            end;
        }
        field(50150; "Report ID"; text[100])
        {
            Editable = false;
        }
        field(50151; "Concur ID"; text[100])
        {
            Editable = false;
        }
        field(50152; "Entry Id"; Text[100])
        {
            Editable = false;
        }
        field(50153; "Receipt image ID"; Text[100])
        { //Editable = false; 
        }
        field(50154; "Original Ex Doc No."; Code[20])
        {
        } //Created on 280525 for concur
        field(50155; "Is Ship Run"; Boolean)
        { //Created to update posted doc no in Concur master -  SGarg
        }
        field(50156; "Fin Company Code"; Text[50])
        {
        //Created to update posted doc no in Concur master -  SGarg
        }
        field(50157; "Ship Company Code"; Text[50])
        {
        //Created to update posted doc no in Concur master -  SGarg
        }
        field(50162; "Cash Advance"; Boolean)
        {
        }
        field(50165; "Inbound Entry No."; integer) //TEC.VG#05NOV2025
        {
            DataClassification = ToBeClassified;
        }
        field(50240; "PB Concur invoice"; Boolean) //#329 TEC.VJ 08MAY2025
        {
            DataClassification = ToBeClassified;
        }
        field(50245; "Central Pay. Parent Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50300; "Original Invoice No"; text[50])
        {
            caption = 'Original Invoice No';
        }
        field(50398; "Central Payment Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50399; "DNV Crew Payroll Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50400; "IMOS invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50401; "IMOS Transaction No"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50402; "Remittance Company No"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50403; "Remittance Account No"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50404; "Remittance Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50405; "IMOS Bank ID"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50406; "Bank Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50407; "Ship Manager Id"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50409; "Manual Application Needed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50410; "Marcura Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //TEC.VJ 18MAR2025>>
        field(50411; "PaymentConfirmationResult"; Text[2048])
        {
            Caption = 'PaymentConfirmationResult';
            DataClassification = ToBeClassified;
        }
        field(50412; "errorMessage"; Text[2048])
        {
            Caption = 'errorMessage';
            DataClassification = ToBeClassified;
        }
        field(50413; "Exported to Concur"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        //TEC.VJ 18MAR2025<<
        field(50414; "Payment Confirmed in Concur"; Boolean)
        {
            DataClassification = ToBeClassified; //#372 VJ 30June2025
        }
        field(50415; "ConfirmationResult"; Text[2048])
        {
            Caption = 'ConfirmationResult';
            DataClassification = ToBeClassified;
        }
        Field(60005; "DNV Staging Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(DNV001; "DNV Staging Entry No.", "Ship Manager Id")
        {
        }
        key(IMOS001; "IMOS Transaction No")
        {
        }
        key(CP001; "Central Payment Entry No")
        {
        }
    }
    procedure RemainingAmount()Result: Decimal var
        IsHandled: Boolean;
    begin
        if not Rec."Closed PB" then begin
            Rec.CalcFields("Applied Amount PB");
            //Result := (Rec.Amount - Rec."Applied Amount PB"); //Sgarg- Code commented
            Result:=(Rec."Original Amount PB" - Rec."Applied Amount PB"); //Sgarg - Code Added
        end;
        exit(Result);
    end;
    procedure RemainingAmountLCY()Result: Decimal var
        IsHandled: Boolean;
    begin
        if not Rec."Closed PB" then begin
            Rec.CalcFields("Applied Amount (LCY) PB");
            Result:=(Rec.Amount - Rec."Applied Amount (LCY) PB");
        end;
        exit(Result);
    end;
}

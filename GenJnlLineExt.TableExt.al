tableextension 50100 GenJnlLineExt extends "Gen. Journal Line"
{
    fields
    {
        field(50100; "Alloc. Rule"; Code[20])
        {
            Caption = 'Allocation Rule';
            DataClassification = ToBeClassified;
            TableRelation = "Allocation Rule";
        }
        field(50102; "Company Code"; Text[30])
        {
            Caption = 'Company Code';
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        //#001>>
        field(50103; "Prepared by"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Certified Correct by"; code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Approved by"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        //#001<<
        field(50106; "Approver A Grp User"; Code[50])
        {
            Caption = 'Approver A Group User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID" where("User Type"=filter("Approver A group"|"Approver B group"));
            ValidateTableRelation = false;
        }
        field(50107; "Approver B Grp User"; Code[50])
        {
            Caption = 'Approver B Group User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID" where("User Type"=filter("Approver A group"));
            ValidateTableRelation = false;
        }
        field(50110; "Invoice Link"; Text[1024])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Link';
            ExtendedDatatype = URL;
        }
        field(50115; "No Corresponding Bank for Pmt"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'No Corresponding Bank For Payment';

            trigger OnValidate()
            var
                VendorBankAcc: Record "Vendor Bank Account";
                EmplBankAcc: Record "Employee Bank Account";
                CustBankAcc: Record "Customer Bank Account";
            begin
                //#232 TEC.VJ 24FEB2025>>
                if(Rec."Account No." = '') or (Rec."No Corresponding Bank for Pmt" = true)then begin
                    Rec."Intermediary Bank Account No":='';
                    Rec."Intermediary Bank Country":='';
                    Rec."Intermediary Bank SWIFT / BIC":='';
                    exit;
                end;
                case "Account Type" of Rec."Account Type"::Vendor: if VendorBankAcc.Get(Rec."Account No.", Rec."Recipient Bank Account")then begin
                        Rec."Intermediary Bank Account No":=VendorBankAcc."Correspondent Bank Account No.";
                        Rec."Intermediary Bank Country":=VendorBankAcc."Corresp. Country/Region Code";
                        Rec."Intermediary Bank SWIFT / BIC":=VendorBankAcc."Correspondent Swift Code";
                    end;
                Rec."Account Type"::Employee: if EmplBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account")then begin
                        Rec."Intermediary Bank Account No":=EmplBankAcc."Correspondent Bank Account No.";
                        Rec."Intermediary Bank Country":=EmplBankAcc."Corresp. Country/Region Code";
                        Rec."Intermediary Bank SWIFT / BIC":=EmplBankAcc."Correspondent Swift Code";
                    end;
                //#242 TEC.VJ 03MARCH2025>>>>
                Rec."Account Type"::Customer: if CustBankAcc.Get(Rec."Account No.", Rec."Recipient Bank Account")then begin
                        Rec."Intermediary Bank Account No":=CustBankAcc."Correspondent Bank Account No.";
                        Rec."Intermediary Bank Country":=CustBankAcc."Corresp. Country/Region Code";
                        Rec."Intermediary Bank SWIFT / BIC":=CustBankAcc."Correspondent Swift Code";
                    end;
                //#242 TEC.VJ 03MARCH2025>><<
                end;
            //#232 TEC.VJ 24FEB2025<<
            end;
        // FieldClass = FlowField;
        // CalcFormula = lookup("Bank Account"."No Corresponding Bank for Pmt" where("No." = field("Bal. Account No.")));
        }
        //PS008 Start
        field(50116; "Bank Charge Debit Pymnt. Amt."; code[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank charges Debited from Payment Amount (BOC Only)';
        }
        field(50117; "Correspon. Bank Charges Method"; code[1])
        {
            DataClassification = ToBeClassified;
            //InitValue = 'A';
            Caption = 'Correspondent Bank Charges Method (BOC Only)';

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                if "Correspon. Bank Charges Method" = 'A' then rec."Bank Charge Debit Pymnt. Amt.":='N';
                if "Correspon. Bank Charges Method" = 'B' then rec."Bank Charge Debit Pymnt. Amt.":='Y';
            end;
        }
        field(50118; "RMB Remittance Trans. Type";Enum "RMB Remittance Trans. Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'RMB Remittance Transaction Type (BOC Only)';
        }
        //PS008 End
        //TEC.VJ 17DEC2024>>
        field(50119; "Suggest Vendor Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Suggest Vendor Line';
        }
        field(50120; "Payment Purpose"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Purpose';
        }
        //TEC.VJ 17DEC2024<<
        //VT20-12-24 >>
        field(50121; "Original Ex Doc No."; Code[20])
        {
        } //Created on 280525 for concur
        field(50122; "Report ID"; text[100])
        {
            Caption = 'Report ID';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50123; "Concur ID"; text[100])
        {
            Caption = 'Concur ID';
            DataClassification = ToBeClassified;
        }
        field(50124; "Entry Id"; Text[100])
        {
            Caption = 'Entry Id';
        }
        //VT20-12-24 <<
        //VT23-12-24 >>
        field(50125; "Receipt image ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        //VT23-12-24 <<
        field(50126; "Applied Entries to XML"; Text[2048])
        { //TEC.VJ
            DataClassification = ToBeClassified;
        }
        field(50127; "Tax Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        //#132 VJ Start
        field(50128; "Purpose Code Preflix"; Text[10])
        {
            DataClassification = ToBeClassified;
        }
        //#4 TEC.VJ 20012025>>
        field(50129; "Applied Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50130; "Amount Mismatch"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        //#4 TEC.VJ 20012025<<
        //#189 TEC.VJ 25012025>>
        field(50131; "Additional Entry Information"; text[500])
        {
            DataClassification = ToBeClassified;
        }
        field(50132; "Creditor Name"; Text[70])
        {
            DataClassification = ToBeClassified;
        }
        //#189 TEC.VJ 25012025<<
        field(50150; "Invoice Currency Code"; Code[20])
        { //used in split fxnality
        }
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
        //#235 VJ 24Feb2025
        field(50158; "Txf Account No."; Code[20])
        {
            Caption = 'Txf Account No.';
            TableRelation = if("Account Type"=const("G/L Account"))"G/L Account" where("Account Type"=const(Posting), Blocked=const(false))
            else if("Account Type"=const(Customer))Customer
            else if("Account Type"=const(Vendor))Vendor
            else if("Account Type"=const("Bank Account"))"Bank Account"
            else if("Account Type"=const("Fixed Asset"))"Fixed Asset"
            else if("Account Type"=const("IC Partner"))"IC Partner"
            else if("Account Type"=const("Allocation Account"))"Allocation Account"
            else if("Account Type"=const(Employee))Employee;

            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
                ICPartner: Record "IC Partner";
                BankAPISetup: Record "Bank API Setup";
            begin
                BankAPISetup.Get();
                if(Rec."Account Type" = Rec."Account Type"::"IC Partner") AND (Rec."Source Code" = 'PAYMENTJNL')then begin
                    Clear(BankAccount);
                    ICPartner.Get(Rec."Account No.");
                    if BankAccount.ChangeCompany(ICPartner."Inbox Details")then if BankAccount.GET(Rec."Txf Account No.")then if(BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi) or (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC)then begin
                                Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::"G/L Account");
                                Rec.Validate("Bal. Account No.", BankAPISetup."Dummy GL Account");
                            end
                            ELSE
                            begin
                                Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::"Bank Account");
                                Rec.Validate("Bal. Account No.", Rec."Txf Account No.");
                            end;
                end END;
        }
        //#293 TEC.VJ 02APR2025>>
        // field(50159; "PB Txf Bank Account"; code[20])
        // {
        //     //TableRelation = "IC G/L Account" where("Account Type" = const(Posting), Blocked = const(false));
        //     TableRelation = if ("PB IC Account Type" = const("G/L Account")) "IC G/L Account" where("Account Type" = const(Posting),
        //                                                                                   Blocked = const(false))
        //     else
        //     if ("PB IC Account Type" = const("Bank Account")) "IC Bank Account" where("IC Partner Code" = field("Account No."));//#154 TEC.VJ
        //     trigger OnValidate()
        //     var
        //         BankAccount: Record "Bank Account";
        //         ICPartner: Record "IC Partner";
        //         BankAPISetup: Record "Bank API Setup";
        //     begin
        //         //#235 VJ 25FEB2025>>
        //         BankAPISetup.Get();
        //         // if (Rec."Account Type" = Rec."Account Type"::"Bank Account") AND (Rec."Source Code" = 'PAYMENTJNL') then begin
        //         //     Clear(BankAccount);
        //         //     ICPartner.Get(Rec."Account No.");
        //         //     if BankAccount.ChangeCompany(ICPartner."Inbox Details") then
        //         //         if BankAccount.GET(Rec."PB IC Account") then
        //         //             if (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi) and (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC) then begin
        //         //                 Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::"G/L Account");
        //         //                 Rec.Validate("Bal. Account No.", BankAPISetup."Dummy GL Account");
        //         //             end ELSE begin
        //         //                 Rec.Validate("Bal. Account Type", Rec."Bal. Account Type"::"Bank Account");
        //         //                 Rec.Validate("Bal. Account No.", Rec."PB Txf Bank Account");
        //         //             end;
        //         // end;
        //         if (Rec."Account Type" = Rec."Account Type"::"IC Partner") AND (Rec."Source Code" = 'INTERCOMP') then begin
        //             Clear(BankAccount);
        //             ICPartner.Get(Rec."Account No.");
        //             if BankAccount.ChangeCompany(ICPartner."Inbox Details") then
        //                 if BankAccount.GET(Rec."PB Txf Bank Account") then
        //                     if (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi) or (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC) then begin
        //                         Rec.Validate("PB IC Account Type", Rec."PB IC Account Type"::"G/L Account");
        //                         Rec.Validate("PB IC Account", BankAPISetup."Dummy GL Account");
        //                     end ELSE begin
        //                         Rec.Validate("PB IC Account Type", Rec."PB IC Account Type"::"Bank Account");
        //                         Rec.Validate("PB IC Account", Rec."PB Txf Bank Account");
        //                     end;
        //         end;
        //         //#235 VJ 25FEB2025<<
        //     end;
        // }
        //#235 end
        //#293 TEC.VJ 02APR2025<<
        field(50160; "Original Document No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        //#293 TEC.VJ 02APR2025>>
        field(50161; "API Bank Account Indicator"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //#293 TEC.VJ 02APR2025<<
        field(50162; "Cash Advance"; Boolean)
        {
        }
        field(50163; "Auto Post"; Boolean) //VJ15APR2025
        {
        }
        //>>VJ #384 22072025
        field(50164; "Skip BankDoc Checking"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //<<VJ #384 22072025
        field(50165; "Inbound Entry No."; integer) //TEC.VG#05NOV2025
        {
            DataClassification = ToBeClassified;
        }
        field(50201; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(3), Blocked=const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(50202; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(4), Blocked=const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(50203; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(5), Blocked=const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(50204; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(6), Blocked=const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(6, "Shortcut Dimension 6 Code");
            end;
        }
        field(50205; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(7), Blocked=const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(7, "Shortcut Dimension 7 Code");
            end;
        }
        field(50206; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(8), Blocked=const(false));

            trigger OnValidate()
            begin
                Rec.ValidateShortcutDimCode(8, "Shortcut Dimension 8 Code");
            end;
        }
        field(50207; "Shortcut Dimension 9 Code"; Code[20])
        {
            CaptionClass = '1,2,9';
            Caption = 'Shortcut Dimension 9 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(9), Blocked=const(false));

            trigger OnValidate()
            var
            begin
                GLSetup.GET;
                UpdateDimensionSetID(rec."Dimension Set ID", GLSetup."Shortcut Dimension 9 Code", "Shortcut Dimension 9 Code");
            end;
        }
        field(50208; "Shortcut Dimension 10 Code"; Code[20])
        {
            CaptionClass = '1,2,10';
            Caption = 'Shortcut Dimension 10 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(10), Blocked=const(false));

            trigger OnValidate()
            begin
                GLSetup.GET;
                UpdateDimensionSetID(rec."Dimension Set ID", GLSetup."Shortcut Dimension 10 Code", "Shortcut Dimension 10 Code");
            end;
        }
        field(50209; "Shortcut Dimension 11 Code"; Code[20])
        {
            CaptionClass = '1,2,11';
            Caption = 'Shortcut Dimension 11 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(11), Blocked=const(false));

            trigger OnValidate()
            begin
                GLSetup.GET;
                UpdateDimensionSetID(rec."Dimension Set ID", GLSetup."Shortcut Dimension 11 Code", "Shortcut Dimension 11 Code");
            end;
        }
        field(50210; "Shortcut Dimension 12 Code"; Code[20])
        {
            CaptionClass = '1,2,12';
            Caption = 'Shortcut Dimension 12 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(12), Blocked=const(false));

            trigger OnValidate()
            begin
                GLSetup.GET;
                UpdateDimensionSetID(rec."Dimension Set ID", GLSetup."Shortcut Dimension 12 Code", "Shortcut Dimension 12 Code");
            end;
        }
        field(50211; "Shortcut Dimension 13 Code"; Code[20])
        {
            CaptionClass = '1,2,13';
            Caption = 'Shortcut Dimension 13 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(13), Blocked=const(false));

            trigger OnValidate()
            begin
                GLSetup.GET;
                UpdateDimensionSetID(rec."Dimension Set ID", GLSetup."Shortcut Dimension 13 Code", "Shortcut Dimension 13 Code");
            end;
        }
        field(50212; "Shortcut Dimension 14 Code"; Code[20])
        {
            CaptionClass = '1,2,14';
            Caption = 'Shortcut Dimension 14 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(14), Blocked=const(false));

            trigger OnValidate()
            begin
                GLSetup.GET;
                UpdateDimensionSetID(rec."Dimension Set ID", GLSetup."Shortcut Dimension 14 Code", "Shortcut Dimension 14 Code");
            end;
        }
        field(50213; "Shortcut Dimension 15 Code"; Code[20])
        {
            CaptionClass = '1,2,15';
            Caption = 'Shortcut Dimension 15 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No."=const(15), Blocked=const(false));

            trigger OnValidate()
            begin
                GLSetup.GET;
                UpdateDimensionSetID(rec."Dimension Set ID", GLSetup."Shortcut Dimension 15 Code", "Shortcut Dimension 15 Code");
            end;
        }
        field(50214; "Rule Line No."; Integer)
        {
        }
        //PS003 Start
        field(50215; "IC Dimension 5"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 5);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 5":=l_DimValues.Code;
                end;
            end;
        }
        field(50216; "IC Dimension 6"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'IC Dimension 6';

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 6);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 6":=l_DimValues.Code;
                end;
            end;
        }
        field(50217; "IC Dimension 1"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 1);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 1":=l_DimValues.Code;
                end;
            end;
        }
        field(50218; "IC Dimension 2"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 2);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 2":=l_DimValues.Code;
                end;
            end;
        }
        field(50219; "IC Dimension 3"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 3);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 3":=l_DimValues.Code;
                end;
            end;
        }
        field(50220; "IC Dimension 4"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 4);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 4":=l_DimValues.Code;
                end;
            end;
        }
        field(50221; "IC Dimension 7"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 7);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 7":=l_DimValues.Code;
                end;
            end;
        }
        field(50222; "IC Dimension 8"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 8);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 8":=l_DimValues.Code;
                end;
            end;
        }
        field(50223; "IC Dimension 9"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 9);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 9":=l_DimValues.Code;
                end;
            end;
        }
        field(50224; "IC Dimension 10"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 10);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 10":=l_DimValues.Code;
                end;
            end;
        }
        field(50225; "IC Dimension 11"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 11);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 11":=l_DimValues.Code;
                end;
            end;
        }
        field(50226; "IC Dimension 12"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                l_DimValues: Record "Dimension Value";
                l_ICPartner: Record "IC Partner";
                l_Company: Record Company;
            begin
                rec.TestField("Account Type", "Account Type"::"IC Partner");
                Rec.TestField("Account No.");
                l_ICPartner.Get(rec."Account No.");
                l_ICPartner.TestField("Inbox Details");
                l_Company.Get(l_ICPartner."Inbox Details");
                l_DimValues.Reset();
                l_DimValues.ChangeCompany(l_ICPartner."Inbox Details");
                l_DimValues.SetRange("Global Dimension No.", 12);
                l_DimValues.SetRange(Blocked, false);
                if Page.RunModal(page::"Dimension Value List", l_DimValues) = Action::LookupOK then begin
                    "IC Dimension 12":=l_DimValues.Code;
                end;
            end;
        }
        field(50227; "PB DNV invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50228; "PB IC Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "G/L Account", "Bank Account";
        }
        field(50229; "World Link"; Text[1024])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(50230; "Trans. Amt."; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50231; "Trans. Currency"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50232; "IFSC Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50233; "Purpose Code"; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
            //#166 TEC.VJ 16012025>>
            //#127 VJ
            // if (rec."Message to Recipient" = '') and (Rec."Purpose Code" = '') and (Rec."Applied Entries to XML" = '') then
            //     Rec."Message to Recipient" := '-';
            //#127 VJ
            //AssignMessagetoRecip();//#387 VJ 25072025
            //#166 TEC.VJ 16012025<<
            end;
        }
        field(50234; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate (Worldlink)';
            DecimalPlaces = 1: 6;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        // field(50235; "Correspondent Bank"; Boolean)
        // {
        //     DataClassification = ToBeClassified;
        // }
        field(50236; "Employee Bank Account"; Code[20])
        {
            Caption = 'Employee Bank Account';
            TableRelation = if("Account Type"=const(Employee))"Employee Bank Account"."Code" where("Employee No."=field("Account No."), "Is Inactive"=filter(false));

            trigger OnValidate()
            var
                EmpBankAcc: Record "Employee Bank Account";
                GJB: Record "Gen. Journal Batch";
                PM: Record "Payment Method";
                CountryRegion: Record "Country/Region";
                BankAccount: Record "Bank Account";
            begin
                Rec."IFSC Code":='';
                Rec."Payment Purpose":='';
                rec."Message to Recipient":='';
                if(rec."Document Type" <> rec."Document Type"::Payment) and (rec."Document Type" <> rec."Document Type"::Refund)then exit; //#289 VJ 25Mar2025
                if EmpBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account")then begin
                    Rec."IFSC Code":=EmpBankAcc."IFSC Code"; //TEC.reVJ 27NOV2024
                    Rec."Payment Purpose":=EmpBankAcc."Payment Purpose"; //TEC.VJ 10DEC2024
                    // Rec."Message to Recipient" := EmpBankAcc."Payment Purpose"; //TEC.VT 080125 //#158 TEC.vj Commented 
                    Rec."Charges Bearer":=EmpBankAcc."Charge Bearer"; //VJ 08JAN2025
                    Rec."Remittance Email 1":=EmpBankAcc."Email Address 1"; //VJ #165 17Jan2024
                    Rec."Remittance Email 2":=EmpBankAcc."Email Address 2"; //VJ #165 17Jan2024
                    //PS008 Start
                    if(EmpBankAcc."CNAPS No." = 'CN') or (EmpBankAcc."CNAPS No." = 'MO')then rec."Message to Recipient":=EmpBankAcc."CNAPS No.";
                    rec."Correspon. Bank Charges Method":=EmpBankAcc."Correspon. Bank Charges Method";
                    if EmpBankAcc."Correspon. Bank Charges Method" = 'A' then rec."Bank Charge Debit Pymnt. Amt.":='N';
                    if EmpBankAcc."Correspon. Bank Charges Method" = 'B' then rec."Bank Charge Debit Pymnt. Amt.":='Y';
                //PS008 End
                end;
                //TEC.VT 16JAN2024 >>
                PM.Reset();
                GJB.Reset();
                if GJB.Get(Rec."Journal Template Name", Rec."Journal Batch Name")then begin
                    if PM.Get(GJB."Payment Method Code")then begin
                        if(PM."Transaction Type" = PM."Transaction Type"::"BOC Remittance Plus") OR (PM."Transaction Type" = PM."Transaction Type"::"Telegraphic Transfer")then begin
                            if EmpBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account")then begin
                                Rec."Payment Purpose":=EmpBankAcc."Payment Purpose";
                                Rec."Message to Recipient":=EmpBankAcc."Payment Purpose";
                            end;
                        end;
                    end;
                end;
                //TEC.VT 16JAN2024 <<
                AssignMessagetoRecip(); //VJ 24Jan2025
                //NT_ 18-02-2025 >>
                if Rec."Account Type" = Rec."Account Type"::Employee then begin
                    if GJB.Get(Rec."Journal Template Name", Rec."Journal Batch Name")then begin
                        if PM.Get(GJB."Payment Method Code")then begin
                            if pm."Transaction Type" = pm."Transaction Type"::"Telegraphic Transfer" then begin
                                if EmpBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account")then;
                                if CountryRegion.get(EmpBankAcc."Country/Region Code")then;
                                if CountryRegion."Default IFSC" then Rec."Message to Recipient":=EmpBankAcc."IFSC Code";
                            end;
                        end;
                    end;
                end;
                //NT_ 18-02-2025 <<
                //#273 TEC.VJ 18MAR2025>>
                if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then begin
                    if BankAccount.Get(Rec."Bal. Account No.")then UpdatePurposeCodePrefix(BankAccount."Bank Integration Type");
                end
                else
                    Rec."Purpose Code Preflix":='';
            //#273 TEC.VJ 18MAR2025<<
            end;
        }
        field(50237; "Payment Set Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Set Code";
        }
        field(50238; "FPS Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Email,FPS ID,Telephon No.';
            OptionMembers = " ", Email, "FPS ID", "Telephon No.";
        }
        field(50239; "FPS No."; text[70])
        {
            DataClassification = ToBeClassified;
        }
        //PS006 Start
        field(50240; "PB Concur invoice"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
            //if "PB Concur invoice" then
            //    rec.TestField("Document Type", rec."Document Type"::Invoice);
            end;
        }
        //PS006 End
        field(50245; "Central Pay. Parent Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        //PS003 End
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
        //Editable = false;
        }
        field(50402; "Remittance Company No"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50403; "Remittance Account No"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50404; "Remittance Full Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50405; "IMOS Bank ID"; Text[30])
        {
            DataClassification = ToBeClassified;
            //Editable = false;
            TableRelation = "IMOS Bank Mapping";

            trigger OnValidate()
            var
                IMOSBankMapping: Record "IMOS Bank Mapping";
                IMOSSetup: record "IMOS Setup";
            begin
                if rec."Account Type" <> rec."Account Type"::"G/L Account" then exit;
                IMOSSetup.Get();
                if "IMOS Bank ID" <> '' then begin
                    IMOSBankMapping.Reset();
                    ;
                    IMOSBankMapping.Get(rec."IMOS Bank ID");
                    if rec."Journal Template Name" = IMOSSetup."Default Cash Receipt Batch" then rec.Validate("Account No.", IMOSBankMapping."IC GL Code");
                    if rec."Journal Template Name" = IMOSSetup."Default Payment Reversal Batch" then rec.Validate("Account No.", IMOSBankMapping."Dummy GL Code");
                end;
            end;
        }
        field(50406; "Bank Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        //VJ#50 13dec24
        field(50407; "Bank Transaction Code"; Text[90])
        {
            DataClassification = ToBeClassified;
        }
        //VJ#50 13dec24
        //VJ#51 13DEC24
        field(50408; "CP External Document No"; Text[35])
        {
            DataClassification = ToBeClassified;
        }
        field(50409; "Manual Application Needed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50415; "Marcura Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52000; "Lavel Service Code";Enum "Level Service Code")
        {
            DataClassification = ToBeClassified;
        }
        field(52001; "Order Importance"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = HIGH, NORM;
        }
        field(52002; "Charges Bearer"; Option)
        {
            DataClassification = ToBeClassified;
            //OptionMembers = DEBT,CRED,SHAR;
            OptionMembers = "SHA", "OUR", "BEN"; //VJ #138
            OptionCaption = 'SHA,OUR,BEN';
        }
        field(52003; "Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank Name';
        }
        field(52004; "Vendor Bank Account Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52005; "Comment to bank"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52006; "Instruction to Bank"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52007; "Remittance Email 1"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52008; "Remittance Email 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52009; "Remittance Email 3"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52010; "Remittance Email 4"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52011; "Remittance Email 5"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52012; "Remittance Email 6"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52013; "Intermediary Bank Account No"; Text[35])
        {
        }
        field(52014; "Intermediary Bank SWIFT / BIC"; Text[35])
        {
        }
        field(52015; "Intermediary Bank Country"; Text[2])
        {
        }
        //dont use field no 55000
        field(60000; HSBC; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60001; "WorkFlow Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Workflow;
        }
        field(60002; "WorkFlow User Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Workflow User Group";
        }
        field(60003; "Booking Method"; text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60004; "Ship Manager Id"; text[250])
        {
            DataClassification = ToBeClassified;
        }
        Field(60005; "DNV Staging Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(60006; "Over Receipt"; Decimal)
        {
            Caption = 'Over Receipt Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60007; "Batch Type";enum "Batch Type")
        {
            DataClassification = ToBeClassified;
        }
        field(60008; "Batch No."; Text[35])
        {
            DataClassification = ToBeClassified;
        }
        field(60009; "Bypass API"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60010; "Payment Method Bank XML"; Code[3])
        {
            Caption = 'Payment Method Bank XML';
            DataClassification = ToBeClassified;
        }
        field(60011; "Bank Charges"; Decimal)
        {
            Caption = 'Bank Charges';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60012; "CP Over Receipt"; Boolean)
        {
            Caption = 'CP Over Receipt';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60020; "GL Reval"; Boolean)
        {
        } //revaluation of GL Entry
        field(70000; "Is Vat Line"; Boolean)
        {
        //Added by Sgarg for temporary use , to flow Original amount in VAt GL Entry
        }
        field(70001; "Skip Detail GLE"; Boolean)
        {
        }
        field(70002; "PB IC Account"; code[20])
        {
            //TableRelation = "IC G/L Account" where("Account Type" = const(Posting), Blocked = const(false));
            TableRelation = if("PB IC Account Type"=const("G/L Account"))"IC G/L Account" where("Account Type"=const(Posting), Blocked=const(false))
            else if("PB IC Account Type"=const("Bank Account"))"IC Bank Account" where("IC Partner Code"=field("Account No.")); //#154 TEC.VJ

            trigger OnValidate()
            var
                BankAccount: Record "Bank Account";
                ICPartner: Record "IC Partner";
            begin
                //#293 TEC.VJ 02APR2025>>
                Rec."API Bank Account Indicator":=false;
                if(Rec."Account Type" = Rec."Account Type"::"IC Partner") AND (Rec."Source Code" = 'INTERCOMP') and (Rec."PB IC Account Type" = Rec."PB IC Account Type"::"Bank Account")then begin
                    Clear(BankAccount);
                    ICPartner.Get(Rec."Account No.");
                    if BankAccount.ChangeCompany(ICPartner."Inbox Details")then if BankAccount.GET(Rec."PB IC Account")then if(BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi) or (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC)then begin
                                Rec."API Bank Account Indicator":=true;
                            end;
                end;
            //#293 TEC.VJ 02APR2025<<
            end;
        }
        field(70003; "PB IC Journal Batch Name"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("PB IC Journal Template Name"));
        }
        field(70004; "PB IC Journal Template Name"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        //VJ 13JAN2025 Start fix the issue where batch type is not updating for account type bank and IC Partner
        modify("Account No.")
        {
        // trigger OnBeforeValidate()
        // BEGIN
        //     //14FEB2025 TEC.VJ>>
        //     IF REC."Account No." <> xRec."Account No." then
        //         Rec.Validate(Amount, 0);
        //     //14FEB2025 TEC.VJ<<
        // END;
        trigger OnAfterValidate()
        var
            Employee: Record Employee;
            EmplBankAcc: Record "Employee Bank Account";
            BankAPISetup: Record "Bank API Setup";
            GenJnlBat: Record "Gen. Journal Batch";
            CommonFucntion: Codeunit "Common Functions";
            BankAccount: Record "Bank Account";
        begin
            //>>VJ 07Ma2025 #249
            if("Account No." <> xRec."Account No.") and not(xRec."Account No." = '')then CommonFucntion."Gen. Journal Line_OnAfterClearCustVendApplnEntry"(Rec);
            //<<VJ 07Ma2025
            IF(Rec."Account Type" = Rec."Account Type"::"Bank Account") or (Rec."Account Type" = Rec."Account Type"::"IC Partner") or (Rec."Account Type" = Rec."Account Type"::Employee)then Validate("Payment Method Code");
            if(Rec."Account Type" = Rec."Account Type"::Employee) and (Rec."Account No." <> '') and (Rec."Source Code" = 'PAYMENTJNL')then begin
                Employee.Get(Rec."Account No.");
                EmplBankAcc.Reset();
                EmplBankAcc.SetRange("Employee No.", Employee."No.");
                EmplBankAcc.SetRange("Is Main Account", true);
                if EmplBankAcc.FindFirst()then Rec.Description:=Employee.FullName() + ' ' + EmplBankAcc."Beneficiary Name";
            end;
            //VJ 06Feb2025
            if Rec."IC Partner Transaction No." = 0 then //#291 VJ 27MAR2025 added condtion
 UpdateICAccount();
            //#294 TEC.VJ 02APR2025>>
            Rec."API Bank Account Indicator":=false;
            if(Rec."Account Type" = Rec."Account Type"::"Bank Account") AND (Rec."Source Code" = 'PAYMENTJNL')then begin
                Clear(BankAccount);
                if BankAccount.GET(Rec."Account No.")then if(BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi) or (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC)then begin
                        Rec."API Bank Account Indicator":=true;
                    end;
            end;
            //#294 TEC.VJ 02APR2025<<
            //VJ 06Feb2025
            //#236 TEC.VJ >>
            IF(Rec."Account Type" = Rec."Account Type"::"Bank Account") and (Rec."Source Code" = 'INTERCOMP')THEN begin
                GenJnlBat.Get(Rec."Journal Template Name", Rec."Journal Batch Name");
                // if GenJnlBat."Review Status" = GenJnlBat."Review Status"::"Pending for Review" then begin
                BankAPISetup.GET();
                Rec.Validate("IC Account Type", Rec."IC Account Type"::"G/L Account");
                Rec.Validate("IC Account No.", BankAPISetup."Dummy GL Account");
            // end;
            end;
        //#236 TEC.VJ <<
        end;
        }
        //VJ#51 13DEC24
        modify("Bal. Account No.")
        {
        trigger OnAfterValidate()
        var
            BankAccount: Record "Bank Account";
            l_Rec_GenJnlBatch: Record "Gen. Journal Batch";
        begin
            if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then begin
                // if BankAccount.Get(Rec."Bal. Account No.") and ((BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::"Non API")) then
                if BankAccount.Get(Rec."Bal. Account No.") and ((BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::"Non API") or (BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::BOC))then //#180 TEC.VJ 24012025
 Rec."Bypass API":=true
                else
                    Rec."Bypass API":=false;
                Rec.Validate("No Corresponding Bank for Pmt", BankAccount."No Corresponding Bank for Pmt"); //VJ#51 #232
                BankAccount.TestField(Blocked, false); //VJ#52
                //#132 VJ Start 07Jan24
                UpdatePurposeCodePrefix(BankAccount."Bank Integration Type"); //#273 TEC.VJ 18MAR2025>>
            end
            else
                Rec."Bypass API":=false;
            //DC 02Apr2025 <<
            l_Rec_GenJnlBatch.RESET;
            l_Rec_GenJnlBatch.SETRANGE("Journal Template Name", Rec."Journal Template Name");
            l_Rec_GenJnlBatch.SETRANGE(Name, Rec."Journal Batch Name");
            l_Rec_GenJnlBatch.SETRANGE("Bypass API", TRUE);
            IF l_Rec_GenJnlBatch.FINDSET THEN begin
                Rec."Bypass API":=TRUE;
            end;
            //DC 02Apr2025 >>
            //VJ 06Feb2025
            UpdateICAccount();
        //VJ 06Feb2025
        end;
        }
        modify("Payment Method Code")
        {
        trigger OnAfterValidate()
        var
            PaymentMethod: Record "Payment Method";
            SalesSetup: Record "Sales & Receivables Setup";
        begin
            if PaymentMethod.GET(Rec."Payment Method Code")then begin
                Rec."Batch Type":=PaymentMethod."Batch Type";
                Rec."Payment Method Bank XML":=PaymentMethod."Payment Method Bank XML";
                Rec."Lavel Service Code":=PaymentMethod."Lavel Service Code"; //TEC.VJ 27NOV2024
                Rec."Purpose Code":=PaymentMethod."Purpose Code"; //TEC.VJ 10DEC2024
                REC."Instruction to Bank":=PaymentMethod."Inst to Debotr"; //#80//TEC.VJ
                Rec."Trans. Currency":=PaymentMethod."Trans. Currency"; //VJ 23Jan2025
                //PS008 Start
                // if PaymentMethod."Export ifile" then
                //     "No Corresponding Bank for Pmt" := true;//VT commented as Requested by Parco//02012025
                //PS008 End
                //VJ#83 20DEC2024
                if PaymentMethod."Batch Type" <> PaymentMethod."Batch Type"::CITI949 then Rec."World Link":=''
                //>>VJ 10JAN2025
                else
                begin
                    SalesSetup.Get();
                    Rec."World Link":=SalesSetup."Word Link";
                end;
            //<<VJ 10JAN2025
            //VJ#83 20DEC2024
            end;
            //#166 TEC.VJ 16012025>>
            //#127 VJ
            // if (rec."Message to Recipient" = '') and (Rec."Purpose Code" = '') and (Rec."Applied Entries to XML" = '') then
            //     Rec."Message to Recipient" := '-';
            //#127 VJ
            AssignMessagetoRecip();
            //#166 TEC.VJ 16012025<<
            Rec.UpdateTransAmount(); //VJ 24Jan2025
        end;
        }
        //VJ 13JAN2025 End
        modify("Recipient Bank Account")
        {
        trigger OnAfterValidate()
        var
            VendorBankAcc: Record "Vendor Bank Account";
            CustomerBankAcc: Record "Customer Bank Account";
            GJB: Record "Gen. Journal Batch";
            PM: Record "Payment Method";
            BankAccount: Record "Bank Account";
            IsCitibank: Boolean;
            IsHSBC: Boolean;
        begin
            //if rec."Document Type" <> rec."Document Type"::Payment then exit; //#289 VJ 25Mar2025
            if(rec."Document Type" <> rec."Document Type"::Payment) and (rec."Document Type" <> rec."Document Type"::Refund)then exit; //#289 VJ 25Mar2025
            IsCitibank:=false;
            IsHSBC:=false;
            if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then begin
                if BankAccount.Get(Rec."Bal. Account No.")then begin
                    IsCitibank:=BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::Citi;
                    IsHSBC:=BankAccount."Bank Integration Type" = BankAccount."Bank Integration Type"::HSBC;
                end;
            end;
            Rec."Remittance Email 1":='';
            Rec."Remittance Email 2":='';
            Rec."Remittance Email 3":='';
            Rec."Remittance Email 4":='';
            Rec."IFSC Code":='';
            Rec."Payment Purpose":='';
            rec."Message to Recipient":='';
            Rec."Remittance Email 5":='';
            Rec."Remittance Email 6":='';
            if Rec."Account Type" = Rec."Account Type"::Vendor then begin
                VendorBankAcc.Reset();
                VendorBankAcc.SetRange("Vendor No.", Rec."Account No.");
                VendorBankAcc.SetRange(Code, Rec."Recipient Bank Account");
                if VendorBankAcc.FindFirst()then begin
                    VendorBankAcc.TestField("Is Inactive", false);
                    Rec."Remittance Email 1":=VendorBankAcc."Email Address 1";
                    Rec."Remittance Email 2":=VendorBankAcc."Email Address 2";
                    Rec."Remittance Email 3":=VendorBankAcc."Email Address 3";
                    Rec."Remittance Email 4":=VendorBankAcc."Email Address 4";
                    Rec."Remittance Email 5":=VendorBankAcc."Email Address 5";
                    Rec."Remittance Email 6":=VendorBankAcc."Email Address 6";
                    if IsCitibank then begin
                        if strlen(Rec."Remittance Email 1") > 35 then Rec."Remittance Email 1":='';
                        if strlen(Rec."Remittance Email 2") > 35 then Rec."Remittance Email 2":='';
                        if strlen(Rec."Remittance Email 3") > 35 then Rec."Remittance Email 3":='';
                        if strlen(Rec."Remittance Email 4") > 35 then Rec."Remittance Email 4":='';
                        if strlen(Rec."Remittance Email 5") > 35 then Rec."Remittance Email 5":='';
                        if strlen(Rec."Remittance Email 6") > 35 then Rec."Remittance Email 6":='';
                    end;
                    Rec."IFSC Code":=vendorBankAcc."IFSC Code";
                    Rec."Charges Bearer":=VendorBankAcc."Charge Bearer"; //VJ #94
                    Rec."Payment Purpose":=vendorBankAcc."Payment Purpose";
                    Rec."Message to Recipient":=vendorBankAcc."Payment Purpose"; //TEC.VT 080125
                    Rec.Description:=VendorBankAcc."Beneficiary Name"; //VJ #139
                    if(vendorBankAcc."CNAPS No." = 'CN') or (vendorBankAcc."CNAPS No." = 'MO')then rec."Message to Recipient":=vendorBankAcc."CNAPS No.";
                    if vendorBankAcc."Correspon. Bank Charges Method" = 'A' then rec."Bank Charge Debit Pymnt. Amt.":='N';
                    if vendorBankAcc."Correspon. Bank Charges Method" = 'B' then rec."Bank Charge Debit Pymnt. Amt.":='Y';
                    rec."Correspon. Bank Charges Method":=VendorBankAcc."Correspon. Bank Charges Method"; //#258 TEC.VJ
                end;
            end
            else //#242 TEC.VJ 03MARCH2025>>>>
                if Rec."Account Type" = Rec."Account Type"::Customer then begin
                    CustomerBankAcc.Reset();
                    CustomerBankAcc.SetRange("Customer No.", Rec."Account No.");
                    CustomerBankAcc.SetRange(Code, Rec."Recipient Bank Account");
                    if CustomerBankAcc.FindFirst()then begin
                        CustomerBankAcc.TestField("Is Inactive", false);
                        Rec."Remittance Email 1":=CustomerBankAcc."Email Address 1";
                        Rec."Remittance Email 2":=CustomerBankAcc."Email Address 2";
                        Rec."Remittance Email 3":=CustomerBankAcc."Email Address 3";
                        Rec."Remittance Email 4":=CustomerBankAcc."Email Address 4";
                        Rec."Remittance Email 5":=CustomerBankAcc."Email Address 5";
                        Rec."Remittance Email 6":=CustomerBankAcc."Email Address 6";
                        if IsCitibank then begin
                            if strlen(Rec."Remittance Email 1") > 35 then Rec."Remittance Email 1":='';
                            if strlen(Rec."Remittance Email 2") > 35 then Rec."Remittance Email 2":='';
                            if strlen(Rec."Remittance Email 3") > 35 then Rec."Remittance Email 3":='';
                            if strlen(Rec."Remittance Email 4") > 35 then Rec."Remittance Email 4":='';
                            if strlen(Rec."Remittance Email 5") > 35 then Rec."Remittance Email 5":='';
                            if strlen(Rec."Remittance Email 6") > 35 then Rec."Remittance Email 6":='';
                        end;
                        Rec."IFSC Code":=CustomerBankAcc."IFSC Code";
                        Rec."Charges Bearer":=CustomerBankAcc."Charge Bearer"; //VJ #94
                        Rec."Payment Purpose":=CustomerBankAcc."Payment Purpose";
                        Rec."Message to Recipient":=CustomerBankAcc."Payment Purpose";
                        Rec.Description:=CustomerBankAcc."Beneficiary Name"; //VJ #139
                        if(CustomerBankAcc."CNAPS No." = 'CN') or (CustomerBankAcc."CNAPS No." = 'MO')then rec."Message to Recipient":=CustomerBankAcc."CNAPS No.";
                        if CustomerBankAcc."Correspon. Bank Charges Method" = 'A' then rec."Bank Charge Debit Pymnt. Amt.":='N';
                        if CustomerBankAcc."Correspon. Bank Charges Method" = 'B' then rec."Bank Charge Debit Pymnt. Amt.":='Y';
                        rec."Correspon. Bank Charges Method":=CustomerBankAcc."Correspon. Bank Charges Method"; //#258 TEC.VJ
                    end;
                end;
            //#242 TEC.VJ 03MARCH2025>><<
            //#166 TEC.VJ 16012025>>
            //#127 VJ
            // if (rec."Message to Recipient" = '') and (Rec."Purpose Code" = '') and (Rec."Applied Entries to XML" = '') then
            //     Rec."Message to Recipient" := '-';
            //#127 VJ
            AssignMessagetoRecip();
            //#166 TEC.VJ 16012025<<
            //TEC.VT 16JAN2024 >>
            PM.Reset();
            GJB.Reset();
            if GJB.Get(Rec."Journal Template Name", Rec."Journal Batch Name")then begin
                if PM.Get(GJB."Payment Method Code")then begin
                    if(PM."Transaction Type" = PM."Transaction Type"::"BOC Remittance Plus") or (PM."Transaction Type" = PM."Transaction Type"::"Telegraphic Transfer")then begin
                        if VendorBankAcc.get("Account No.", "Recipient Bank Account")then begin
                            Rec."Payment Purpose":=VendorBankAcc."Payment Purpose";
                            Rec."Message to Recipient":=VendorBankAcc."Payment Purpose";
                        end;
                        //#242 TEC.VJ 03MARCH2025>>>>
                        if CustomerBankAcc.get("Account No.", "Recipient Bank Account")then begin
                            Rec."Payment Purpose":=CustomerBankAcc."Payment Purpose";
                            Rec."Message to Recipient":=CustomerBankAcc."Payment Purpose";
                        end;
                    //#242 TEC.VJ 03MARCH2025>><<
                    end;
                end;
            end;
            //TEC.VT 16JAN2024 <<
            AssignMessagetoRecip(); //20Jan2025
            //NT_ 17-03-2025 >>
            if Rec."Account Type" = Rec."Account Type"::Vendor then begin
                if GJB.get(Rec."Journal Template Name", Rec."Journal Batch Name")then begin
                    if PM.get(GJB."Payment Method Code")then begin
                        if((PM."Transaction Type" = PM."Transaction Type"::"Telegraphic Transfer") or (pm."Transaction Type" = pm."Transaction Type"::"BOC Remittance Plus")) and (Rec."RMB Remittance Trans. Type" = Rec."RMB Remittance Trans. Type"::Z)then Rec."Payment Purpose":='-';
                    end;
                end;
            end;
            //NT_ 17-03-2025 <<
            //#273 TEC.VJ 18MAR2025>>
            if "Bal. Account Type" = "Bal. Account Type"::"Bank Account" then begin
                if BankAccount.Get(Rec."Bal. Account No.")then UpdatePurposeCodePrefix(BankAccount."Bank Integration Type");
            end
            else
                Rec."Purpose Code Preflix":='';
        //#273 TEC.VJ 18MAR2025<<
        end;
        }
    }
    var GLSetup: Record "General Ledger Setup";
    //TEC#002>>
    trigger OnAfterInsert()
    var
        GJB: Record "Gen. Journal Batch";
        EmpBankAcc: Record "Employee Bank Account";
        VendorBankAcc: Record "Vendor Bank Account";
        CustomerBankAcc: Record "Customer Bank Account";
        PM: Record "Payment Method";
    begin
        "Prepared by":=UserId;
        //"Correspondent Bank" := true;//VJ 10DEC2024
        //TEC.VT 16JAN2024 >>
        PM.Reset();
        GJB.Reset();
        if GJB.Get(Rec."Journal Template Name", Rec."Journal Batch Name")then begin
            if PM.Get(GJB."Payment Method Code")then begin
                if(PM."Transaction Type" = PM."Transaction Type"::"BOC Remittance Plus") OR (PM."Transaction Type" = PM."Transaction Type"::"Telegraphic Transfer")then begin
                    //if EmpBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account") then begin//#387 VJ 25072025
                    if EmpBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account") and (EmpBankAcc."Payment Purpose" <> '')then begin //#387 VJ 25072025
                        Rec."Payment Purpose":=EmpBankAcc."Payment Purpose";
                        Rec."Message to Recipient":=EmpBankAcc."Payment Purpose";
                    end;
                    //if VendorBankAcc.get("Account No.", "Recipient Bank Account") then begin//#387 VJ 25072025
                    if VendorBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account") and (VendorBankAcc."Payment Purpose" <> '')then begin //#387 VJ 25072025
                        Rec."Payment Purpose":=VendorBankAcc."Payment Purpose";
                        Rec."Message to Recipient":=VendorBankAcc."Payment Purpose";
                    end;
                    //#242 TEC.VJ 03MARCH2025>><<
                    //if CustomerBankAcc.get("Account No.", "Recipient Bank Account") then begin//#387 VJ 25072025
                    if CustomerBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account") and (CustomerBankAcc."Payment Purpose" <> '')then begin //#387 VJ 25072025
                        Rec."Payment Purpose":=CustomerBankAcc."Payment Purpose";
                        Rec."Message to Recipient":=CustomerBankAcc."Payment Purpose";
                    end;
                //#242 TEC.VJ 03MARCH2025>>>>
                end;
            end;
        end;
    //TEC.VT 16JAN2024 <<
    end;
    //TEC#002<<
    trigger OnBeforeInsert()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        GJB: Record "Gen. Journal Batch";
        EmpBankAcc: Record "Employee Bank Account";
        VendorBankAcc: Record "Vendor Bank Account";
        CustomerBankAcc: Record "Customer Bank Account";
        PM: Record "Payment Method";
    begin
        SalesSetup.Get();
        Rec."World Link":=SalesSetup."Word Link";
        GJB.Reset();
        if GJB.Get(Rec."Journal Template Name", Rec."Journal Batch Name")then if GJB."Value Date" <> 0D then Rec."Posting Date":=GJB."Value Date";
        //TEC.VT 16JAN2024 >>
        PM.Reset();
        GJB.Reset();
        if GJB.Get(Rec."Journal Template Name", Rec."Journal Batch Name")then begin
            if PM.Get(GJB."Payment Method Code")then begin
                if(PM."Transaction Type" = PM."Transaction Type"::"Telegraphic Transfer") OR (PM."Transaction Type" = PM."Transaction Type"::"BOC Remittance Plus")then begin
                    if EmpBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account")then begin
                        Rec."Payment Purpose":=EmpBankAcc."Payment Purpose";
                        Rec."Message to Recipient":=EmpBankAcc."Payment Purpose";
                    end;
                    if VendorBankAcc.get("Account No.", "Recipient Bank Account")then begin
                        Rec."Payment Purpose":=VendorBankAcc."Payment Purpose";
                        Rec."Message to Recipient":=VendorBankAcc."Payment Purpose";
                    end;
                    //#242 TEC.VJ 03MARCH2025>>>>
                    if CustomerBankAcc.get("Account No.", "Recipient Bank Account")then begin
                        Rec."Payment Purpose":=CustomerBankAcc."Payment Purpose";
                        Rec."Message to Recipient":=CustomerBankAcc."Payment Purpose";
                    end;
                //#242 TEC.VJ 03MARCH2025>><<
                end;
            end;
        end;
    //TEC.VT 16JAN2024 <<
    end;
    procedure UpdateDimensionSetID(P_DimSetID: Integer; DimCode: Code[20]; DimValCode: Code[20])
    var
        //Sgarg- Created
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgmt: Codeunit DimensionManagement;
        DimVal: Record "Dimension Value";
    begin
        DimMgmt.GetDimensionSet(TempDimSetEntry, P_DimSetID);
        IF TempDimSetEntry.GET(TempDimSetEntry."Dimension Set ID", DimCode)THEN IF TempDimSetEntry."Dimension Value Code" <> DimValCode THEN TempDimSetEntry.DELETE;
        IF DimValCode <> '' THEN BEGIN
            DimVal.GET(DimCode, DimValCode);
            TempDimSetEntry."Dimension Code":=DimVal."Dimension Code";
            TempDimSetEntry."Dimension Value Code":=DimVal.Code;
            TempDimSetEntry."Dimension Value ID":=DimVal."Dimension Value ID";
            IF TempDimSetEntry.INSERT THEN;
        END;
        rec."Dimension Set ID":=DimMgmt.GetDimensionSetID(TempDimSetEntry);
    end;
    //TEC.VJ 25112024>>
    procedure UpdateTransAmount()
    var
        WorldLinkSpotRate: Record "Worldlink Spot Rate";
        GLSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        GLSetup.Get();
        if Rec."Currency Code" = GLSetup."LCY Code" then begin
            WorldLinkSpotRate.Reset();
            WorldLinkSpotRate.SetCurrentKey(Date);
            WorldLinkSpotRate.SetRange("From Currency", Rec."Currency Code");
            WorldLinkSpotRate.SetRange("To Currency", Rec."Trans. Currency");
            WorldLinkSpotRate.SetFilter(Date, '<=%1', Rec."Posting Date");
            if WorldLinkSpotRate.FindLast()then;
            if WorldLinkSpotRate.Rate = 0 then begin
                Rec."Exchange Rate":=0;
                Rec."Trans. Amt.":=0;
                exit;
            end
            else
            begin
                Rec."Exchange Rate":=WorldLinkSpotRate.Rate;
                Rec."Trans. Amt.":=Rec.Amount * WorldLinkSpotRate.Rate;
            end;
        end
        else if GLSetup."LCY Code" = Rec."Trans. Currency" then begin
                CurrencyExchangeRate.Reset();
                CurrencyExchangeRate.SetRange("Currency Code", Rec."Currency Code");
                CurrencyExchangeRate.SetFilter("Starting Date", '<=%1', Rec."Posting Date");
                if CurrencyExchangeRate.FindLast()then begin
                    Rec."Exchange Rate":=1 / CurrencyExchangeRate."Relational Exch. Rate Amount";
                    Rec."Trans. Amt.":=Rec.Amount * (CurrencyExchangeRate."Relational Exch. Rate Amount" / CurrencyExchangeRate."Exchange Rate Amount");
                end;
            end;
    end;
    local procedure AssignMessagetoRecip()
    var
        PaymentMethod: Record "Payment Method";
        EmpBankAcc: Record "Employee Bank Account";
    begin
        //#166 TEC.VJ
        case Rec."Batch Type" of //>>#387 Commented
        //Rec."Batch Type"::"HK Lower Value", Rec."Batch Type"::"HK Upper Value", Rec."Batch Type"::"US Upper Value":
        //  Rec."Message to Recipient" := '';
        //<<#387 Commented
        Rec."Batch Type"::CITI949, Rec."Batch Type"::CITI391, Rec."Batch Type"::CITI392, Rec."Batch Type"::CITI393, Rec."Batch Type"::CITI403: // if (rec."Message to Recipient" = '') AND (REC."Payment Purpose" = '') and (Rec."Purpose Code" = '') and (Rec."Applied Entries to XML" = '') then
            if(rec."Message to Recipient" = '') AND (REC."Payment Purpose" = '') and (Rec."Purpose Code" = '')then //NT_ 17-02-2025
 Rec."Message to Recipient":='-';
        end;
        //vj 20Jan2025 put ifsc code if mssage to recipient is empty
        if PaymentMethod.Get(Rec."Payment Method Code")then;
        if(Rec."IFSC Code" <> '')then Rec."Message to Recipient":=Rec."IFSC Code";
        //vj 20Jan2025 put ifsc code if mssage to recipient is empty
        //VJ 23jan2025 added from suggest pament report start
        if(PAYMENTMETHOD."Transaction Type" = PAYMENTMETHOD."Transaction Type"::"BOC Remittance Plus") or (PAYMENTMETHOD."Transaction Type" = PAYMENTMETHOD."Transaction Type"::"Telegraphic Transfer")then begin //VJ 23Jan changed
            if EmpBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account")then begin
                if EmpBankAcc."Payment Purpose" <> '' then begin //#387 VJ Added
                    Rec."Payment Purpose":=EmpBankAcc."Payment Purpose";
                    Rec."Message to Recipient":=EmpBankAcc."Payment Purpose";
                end;
            end;
        end;
        //VJ 23Jan added
        /* 
        //#283 VJ 21032025>>
        if PAYMENTMETHOD."Transaction Type" = PAYMENTMETHOD."Transaction Type"::Citi then begin
            if EmpBankAcc.Get(Rec."Account No.", Rec."Employee Bank Account") then begin

                Rec."Message to Recipient" := 'IFSC Code ' + EmpBankAcc."IFSC Code";
            end;
        end;
        */
        if PAYMENTMETHOD."Transaction Type" = PAYMENTMETHOD."Transaction Type"::Citi then Rec."Message to Recipient":='IFSC Code ' + Rec."IFSC Code";
    //#283 VJ 21032025<<
    //>>#387 VJ commented 25072025
    //if (PaymentMethod."Transaction Type" = PaymentMethod."Transaction Type"::" ") then
    //  Rec."Message to Recipient" := '';
    //<<#387 VJ commented
    //VJ 23jan2025 end
    end;
    //TEC.VJ 25112024<<
    procedure UpdateICAccount()
    var
        BankAPISetup: Record "Bank API Setup";
    begin
        //VJ 06Feb2025
        BankAPISetup.Get();
        if(Rec."Account Type" = Rec."Account Type"::"Bank Account") AND (Rec."Source Code" = 'INTERCOMP') AND (Rec."Bypass API")then begin
            Rec.Validate("IC Account Type", Rec."IC Account Type"::"G/L Account");
            Rec.Validate("IC Account No.", BankAPISetup."Dummy GL Account");
        end;
    //VJ 06Feb2025
    end;
    procedure UpdatePurposeCodePrefix(BankIntType: option " ", HSBC, BOC, Citi, "Non API")
    var
        Countries: Record "Country/Region";
        VendorBankAcc: Record "Vendor Bank Account";
        CustomerBankAcc: Record "Customer Bank Account";
        EmpBankAcc: Record "Employee Bank Account";
    begin
        case Rec."Account Type" of Rec."Account Type"::Customer: begin
            //#242 TEC.VJ 03MARCH2025>>>>
            if CustomerBankAcc.get("Account No.", "Recipient Bank Account")then begin
                Countries.get(CustomerBankAcc."Country/Region Code");
                if BankIntType = BankIntType::HSBC then Rec."Purpose Code Preflix":=Countries."Purpose Code (HSBC)  Prefix";
                if BankIntType = BankIntType::Citi then Rec."Purpose Code Preflix":=Countries."Purpose Code (Citi)  Prefix";
            end;
        //#242 TEC.VJ 03MARCH2025>><<
        end;
        Rec."Account Type"::Vendor: begin
            if VendorBankAcc.get("Account No.", "Recipient Bank Account")then begin
                Countries.get(VendorBankAcc."Country/Region Code");
                if BankIntType = BankIntType::HSBC then Rec."Purpose Code Preflix":=Countries."Purpose Code (HSBC)  Prefix";
                if BankIntType = BankIntType::Citi then Rec."Purpose Code Preflix":=Countries."Purpose Code (Citi)  Prefix";
            end;
        end;
        Rec."Account Type"::Employee: begin
            if EmpBankAcc.get("Account No.", Rec."Employee Bank Account")then begin
                Countries.get(EmpBankAcc."Country/Region Code");
                if BankIntType = BankIntType::HSBC then Rec."Purpose Code Preflix":=Countries."Purpose Code (HSBC)  Prefix";
                if BankIntType = BankIntType::Citi then Rec."Purpose Code Preflix":=Countries."Purpose Code (Citi)  Prefix";
            end;
        end
        ELSE
            Rec."Purpose Code Preflix":='';
        end;
    end;
    var G_DimVal: Record "Dimension Value";
}

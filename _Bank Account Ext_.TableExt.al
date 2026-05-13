tableextension 50128 "Bank Account Ext" extends "Bank Account"
{
    fields
    {
        field(50100; "Intermediary Bank Account No"; Text[35])
        {
        }
        field(50101; "Intermediary Bank SWIFT / BIC"; Text[35])
        {
        }
        field(50102; "Intermediary Bank Country"; Text[2])
        {
        }
        field(50103; "Remittance Email 1"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50104; "Remittance Email 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Remittance Email 3"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Remittance Email 4"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50107; "Remittance Email 5"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "Remittance Email 6"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50109; "Exclude Revaluation"; Boolean)
        {
        }
        field(50110; "Bank Integration Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ", HSBC, BOC, Citi, "Non API";
        }
        field(50111; "Currency Code Custom"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            var
                GeneralLedgerSetup: Record "General Ledger Setup";
                BankAccount: Record "Bank Account";
                BankAccLedgEntry: Record "Bank Account Ledger Entry";
            begin
                if "Currency Code" = xRec."Currency Code" then exit;
                GeneralLedgerSetup.Get();
                if(("Currency Code" in['', GeneralLedgerSetup."LCY Code"]) and (xRec."Currency Code" in['', GeneralLedgerSetup."LCY Code"]))then exit;
                BankAccount:=Rec;
                BankAccount.CalcFields(Balance, "Balance (LCY)");
                BankAccount.TestField(Balance, 0);
                BankAccount.TestField("Balance (LCY)", 0);
                if not BankAccLedgEntry.SetCurrentKey("Bank Account No.", Open)then BankAccLedgEntry.SetCurrentKey("Bank Account No.");
                BankAccLedgEntry.SetRange("Bank Account No.", "No.");
                BankAccLedgEntry.SetRange(Open, true);
                if BankAccLedgEntry.FindLast()then Error(Text50000, FieldCaption("Currency Code"));
            end;
        }
        field(50112; "ABA Routing Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50113; "Bank Beneficiary Name"; Text[35]) //#216 TEC.VJ 
        {
            Caption = 'Bank Beneficiary Name';
            DataClassification = ToBeClassified;
        }
        field(50114; "Bank Statement from API"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "No API", CAMT52, CAMT53, "CAMT52 & 53";
        }
        //VJ#51 13DEC2024
        field(50115; "No Corresponding Bank for Pmt"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'No Corresponding Bank For Payment';
        }
        //VJ#51 13DEC2024
        //PS008 Start
        field(50116; "Bank Charge Deb. Pymnt. Amt."; code[1])
        {
            DataClassification = ToBeClassified;
            InitValue = 'N';
            Caption = 'Bank charges Debited from Payment Amount';
            ObsoleteState = Removed;
            ObsoleteReason = 'Not Needed';
        }
        field(50117; "Correspon. Bank Charges Method"; code[1])
        {
            DataClassification = ToBeClassified;
            InitValue = 'A';
            Caption = 'Correspondent Bank Charges Method';
            ObsoleteState = Removed;
            ObsoleteReason = 'Not Needed';
        }
        //PS008 End
        field(50118; "Account Holder Name"; TEXT[140])
        {
            DataClassification = ToBeClassified;
        }
        //#162 TEC.VJ 16012025>>
        field(50119; "Correspondent Bank Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50120; "Correspondent Swift Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "SWIFT Code";
        }
        field(50121; "Correspondent Bank Account No."; Text[30])
        {
            Caption = 'Correspondent Bank Account No.';
        }
        //#162 TEC.VJ 16012025<<
        field(50122; "HSBC Institution Code";Enum "HSBC Institution Code")
        {
            DataClassification = ToBeClassified;
        }
        field(50123; "HSBC Account Type"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        modify("Address 2")
        {
        trigger OnBeforeValidate()
        begin
            IF StrLen("Address 2") > 35 then Error('Address 2 String length %1 must be less then 35 charactor.', StrLen("Address 2"));
        end;
        }
        //#216 TEC.VJ>>
        modify(Address)
        {
        trigger OnBeforeValidate()
        begin
            IF StrLen(Address) > 35 then Error('Address String length %1 must be less then 35 charactor.', StrLen(Address));
        end;
        }
    }
    trigger OnAfterInsert()
    begin
        Rec.IntercompanyEnable:=true;
    end;
    var Text50000: Label 'You cannot change %1 because there are one or more open ledger entries for this bank account.';
}

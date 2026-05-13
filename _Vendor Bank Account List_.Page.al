page 50251 "Vendor Bank Account List"
{
    ApplicationArea = All;
    Caption = 'Vendor Bank Account List';
    PageType = List;
    SourceTable = "Vendor Bank Account";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("ABA/BSB No."; Rec."ABA/BSB No.")
                {
                    ToolTip = 'Specifies the value of the ABA/BSB No. field.';
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the address of the bank where the vendor has the bank account.';
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies additional address information.';
                    ApplicationArea = All;
                }
                field("Address 3"; Rec."Address 3")
                {
                    ToolTip = 'Specifies the value of the Address 3 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Address 4"; Rec."Address 4")
                {
                    ToolTip = 'Specifies the value of the Address 4 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                    ApplicationArea = All;
                }
                field("Bank Branch No."; Rec."Bank Branch No.")
                {
                    ToolTip = 'Specifies the number of the bank branch.';
                    ApplicationArea = All;
                }
                field("Bank Clearing Code"; Rec."Bank Clearing Code")
                {
                    ToolTip = 'Specifies the code for bank clearing that is required according to the format standard you selected in the Bank Clearing Standard field.';
                    ApplicationArea = All;
                }
                field("Bank Clearing Standard"; Rec."Bank Clearing Standard")
                {
                    ToolTip = 'Specifies the format standard to be used in bank transfers if you use the Bank Clearing Code field to identify you as the sender.';
                    ApplicationArea = All;
                }
                field("Bene Bank Address 1"; Rec."Bene Bank Address 1")
                {
                    ToolTip = 'Specifies the value of the Bene Bank Address 1 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Bene Bank Address 2"; Rec."Bene Bank Address 2")
                {
                    ToolTip = 'Specifies the value of the Bene Bank Address 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    ToolTip = 'Specifies the value of the Beneficiary Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                    ApplicationArea = All;
                }
                field("CNAPS No."; Rec."CNAPS No.")
                {
                    ToolTip = 'Specifies the value of the CNAPS No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Charge Bearer"; Rec."Charge Bearer")
                {
                    ToolTip = 'Specifies the value of the Charge Bearer field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the city of the bank where the vendor has the bank account.';
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies a code to identify this vendor bank account.';
                    ApplicationArea = All;
                }
                field(Contact; Rec.Contact)
                {
                    ToolTip = 'Specifies the name of the bank employee regularly contacted in connection with this bank account.';
                    ApplicationArea = All;
                }
                field("Corresp. Country/Region Code"; Rec."Corresp. Country/Region Code")
                {
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                    ApplicationArea = All;
                }
                field("Correspon. Bank Charges Method"; Rec."Correspon. Bank Charges Method")
                {
                    ToolTip = 'Specifies the value of the Correspondent Bank Charges Method field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Correspondent ABA/BSB No."; Rec."Correspondent ABA/BSB No.")
                {
                    ToolTip = 'Specifies the value of the ABA/BSB No. field.';
                    ApplicationArea = All;
                }
                field("Correspondent Address"; Rec."Correspondent Address")
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                }
                field("Correspondent Bank Account No."; Rec."Correspondent Bank Account No.")
                {
                    ToolTip = 'Specifies the value of the Bank Account No. field.';
                    ApplicationArea = All;
                }
                field("Correspondent Bank Name"; Rec."Correspondent Bank Name")
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field("Correspondent Branch"; Rec."Correspondent Branch")
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                    ApplicationArea = All;
                }
                field("Correspondent IBAN No."; Rec."Correspondent IBAN No.")
                {
                    ToolTip = 'Specifies the value of the IBAN No. field.';
                    ApplicationArea = All;
                }
                field("Correspondent Swift Code"; Rec."Correspondent Swift Code")
                {
                    ToolTip = 'Specifies the value of the Swift Code field.';
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ToolTip = 'Specifies the country/region of the address.';
                    ApplicationArea = All;
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the value of the County field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the relevant currency code for the bank account.';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the email address associated with the bank account.';
                    ApplicationArea = All;
                }
                field("Email Address 1"; Rec."Email Address 1")
                {
                    ToolTip = 'Specifies the value of the Email Address 1 field.';
                    ApplicationArea = All;
                }
                field("Email Address 2"; Rec."Email Address 2")
                {
                    ToolTip = 'Specifies the value of the Email Address 2 field.';
                    ApplicationArea = All;
                }
                field("Email Address 3"; Rec."Email Address 3")
                {
                    ToolTip = 'Specifies the value of the Email Address 3 field.';
                    ApplicationArea = All;
                }
                field("Email Address 4"; Rec."Email Address 4")
                {
                    ToolTip = 'Specifies the value of the Email Address 4 field.';
                    ApplicationArea = All;
                }
                field("Email Address 5"; Rec."Email Address 5")
                {
                    ToolTip = 'Specifies the value of the Email Address 5 field.';
                    ApplicationArea = All;
                }
                field("Email Address 6"; Rec."Email Address 6")
                {
                    ToolTip = 'Specifies the value of the Email Address 6 field.';
                    ApplicationArea = All;
                }
                field("Email Name 1"; Rec."Email Name 1")
                {
                    ToolTip = 'Specifies the value of the Email Name 1 field.';
                    ApplicationArea = All;
                }
                field("Email Name 2"; Rec."Email Name 2")
                {
                    ToolTip = 'Specifies the value of the Email Name 2 field.';
                    ApplicationArea = All;
                }
                field("Email Name 3"; Rec."Email Name 3")
                {
                    ToolTip = 'Specifies the value of the Email Name 3 field.';
                    ApplicationArea = All;
                }
                field("Email Name 4"; Rec."Email Name 4")
                {
                    ToolTip = 'Specifies the value of the Email Name 4 field.';
                    ApplicationArea = All;
                }
                field("Email Name 5"; Rec."Email Name 5")
                {
                    ToolTip = 'Specifies the value of the Email Name 5 field.';
                    ApplicationArea = All;
                }
                field("Email Name 6"; Rec."Email Name 6")
                {
                    ToolTip = 'Specifies the value of the Email Name 6 field.';
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the fax number of the bank where the vendor has the bank account.';
                    ApplicationArea = All;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ToolTip = 'Specifies the bank web site.';
                    ApplicationArea = All;
                }
                field(IBAN; Rec.IBAN)
                {
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                    ApplicationArea = All;
                }
                field("IFSC Code"; Rec."IFSC Code")
                {
                    ToolTip = 'Specifies the value of the IFSC Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("IMOS Ext Ref"; Rec."IMOS Ext Ref")
                {
                    ToolTip = 'Specifies the value of the Ext Ref field.';
                    ApplicationArea = All;
                }
                field("Is Default"; Rec."Is Default")
                {
                    ToolTip = 'Specifies the value of the Is Default field.';
                    ApplicationArea = All;
                }
                field("Is Inactive"; Rec."Is Inactive")
                {
                    ToolTip = 'Specifies the value of the Is Inactive field.';
                    ApplicationArea = All;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ToolTip = 'Specifies the language that is used when translating specified text on documents to foreign business partner, such as an item description on an order confirmation.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the name of the bank where the vendor has this bank account.';
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ToolTip = 'Specifies the value of the Name 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Payment Purpose"; Rec."Payment Purpose")
                {
                    ToolTip = 'Specifies the value of the Payment Purpose field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the telephone number of the bank where the vendor has the bank account.';
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the postal code.';
                    ApplicationArea = All;
                }
                field("Res. PB"; Rec."Res. PB")
                {
                    ToolTip = 'Specifies the value of the Res. PB field.';
                    ApplicationArea = All;
                }
                field("SWIFT Code"; Rec."SWIFT Code")
                {
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the vendor has the account.';
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ToolTip = 'Specifies the value of the SystemId field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Telex Answer Back"; Rec."Telex Answer Back")
                {
                    ToolTip = 'Specifies the value of the Telex Answer Back field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Telex No."; Rec."Telex No.")
                {
                    ToolTip = 'Specifies the value of the Telex No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Transit No."; Rec."Transit No.")
                {
                    ToolTip = 'Specifies a bank identification number of your own choice.';
                    ApplicationArea = All;
                }
                field("UK Clearing Code"; Rec."UK Clearing Code")
                {
                    ToolTip = 'Specifies the value of the UK Clearing Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("bank Code"; Rec."bank Code")
                {
                    ToolTip = 'Specifies the value of the Bank Code field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
}

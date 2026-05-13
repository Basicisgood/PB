page 50300 "Customer Bank Account List"
{
    ApplicationArea = All;
    Caption = 'Customer Bank Account List';
    PageType = List;
    SourceTable = "Customer Bank Account";
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
                    ToolTip = 'Specifies the address of the bank where the customer has the bank account.';
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
                    ToolTip = 'Specifies the value of the Address field.';
                    ApplicationArea = All;
                }
                field("Bene Bank Address 2"; Rec."Bene Bank Address 2")
                {
                    ToolTip = 'Specifies the value of the Address field.';
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
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the city of the bank where the customer has the bank account.';
                    ApplicationArea = All;
                }
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies a code to identify this customer bank account.';
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
                field("Correspondent ABA/BSB No."; Rec."Correspondent ABA/BSB No.")
                {
                    ToolTip = 'Specifies the value of the ABA/BSB No. field.';
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
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the email address associated with the bank account.';
                    ApplicationArea = All;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the fax number of the bank where the customer has the bank account.';
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
                field("IMOS Ext Ref"; Rec."IMOS Ext Ref")
                {
                    ToolTip = 'Specifies the value of the Ext Ref field.';
                    ApplicationArea = All;
                }
                field(Inact; Rec.Inact)
                {
                    ToolTip = 'Specifies the value of the Inact field.';
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
                    ToolTip = 'Specifies the name of the bank where the customer has the bank account.';
                    ApplicationArea = All;
                }
                field("Name 2"; Rec."Name 2")
                {
                    ToolTip = 'Specifies the value of the Name 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the telephone number of the bank where the customer has the bank account.';
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
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the customer has the account.';
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
            }
        }
    }
}

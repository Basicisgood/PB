pageextension 50122 "Customer Bank Account Card Ext" extends "Customer Bank Account Card"
{
    layout
    {
        modify("Country/Region Code")
        {
            Caption = 'Bene Bank Country/Region Code';
            ApplicationArea = All;
        }
        //#242 TEC.VJ 03MARCH2025>>>>
        addafter("Country/Region Code")
        {
            field("Correspon. Bank Charges Method55278"; Rec."Correspon. Bank Charges Method")
            {
                ApplicationArea = All;
            }
        }
        addafter(Name)
        {
            field("bank Code"; Rec."bank Code")
            {
                ApplicationArea = All;
            }
        }
        //#242 TEC.VJ 03MARCH2025>><<
        addafter("Address 2")
        {
            field("Address 3"; Rec."Address 3")
            {
                ApplicationArea = All;
            }
            field("Address 4"; Rec."Address 4")
            {
                ApplicationArea = All;
            }
        }
        addafter(Name)
        {
            field("Beneficiary Name"; Rec."Beneficiary Name")
            {
                ApplicationArea = All;
            }
            //#242 TEC.VJ 03MARCH2025>>>>
            field("Beneficiary Name 2"; Rec."Beneficiary Name 2")
            {
                //#218 TEC.VJ 12022025
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Beneficiary Name 2 field.', Comment = '%';
            }
            field("Beneficiary Name 3"; Rec."Beneficiary Name 3")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Beneficiary Name 3 field.', Comment = '%';
            }
            //#242 TEC.VJ 03MARCH2025>><<
            field("Bene Bank Address 1"; Rec."Bene Bank Address 1")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address field.', Comment = '%';
            }
            field("Bene Bank Address 2"; Rec."Bene Bank Address 2")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Address field.', Comment = '%';
            }
            field("Ext Ref"; Rec."IMOS Ext Ref")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Ext Ref field.', Comment = '%';
            }
            field("ABA/BSB No."; Rec."ABA/BSB No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the ABA/BSB No. field.', Comment = '%';
            }
            field(Branch; Rec.Branch)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Branch field.', Comment = '%';
            }
            field("Res. PB"; Rec."Res. PB")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Res. PB field.', Comment = '%';
            }
            field(Inact; Rec.Inact)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Inact field.', Comment = '%';
            }
            field("Is Inactive"; Rec."Is Inactive")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Is Inactive field.', Comment = '%';
            }
            field("Is Default"; Rec."Is Default")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Is Default field.', Comment = '%';
            }
            field("Default Pay Method"; Rec."Default Pay Method")
            {
                ApplicationArea = all;
            }
            field("Charge Bearer"; Rec."Charge Bearer")
            {
                ApplicationArea = all; //TEC.VJ 13012024
                ToolTip = 'Specifies the value of the Charge Bearer field.', Comment = '%';
            }
        }
        addafter(Transfer)
        {
            group("Correspondent Bank")
            {
                field("Correspondent Bank Name"; Rec."Correspondent Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.', Comment = '%';
                }
                field("Correspondent Branch"; Rec."Correspondent Branch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Branch field.', Comment = '%';
                }
                //#242 TEC.VJ 03MARCH2025>><<
                field("Correspondent Address"; Rec."Correspondent Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.', Comment = '%';
                }
                //#242 TEC.VJ 03MARCH2025>><<
                field("Corresp. Country/Region Code"; Rec."Corresp. Country/Region Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Country/Region Code field.', Comment = '%';
                }
                field("Correspondent Swift Code"; Rec."Correspondent Swift Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Swift Code field.', Comment = '%';
                }
                field("Correspondent ABA/BSB No."; Rec."Correspondent ABA/BSB No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ABA/BSB No. field.', Comment = '%';
                }
                field("Correspondent Bank Account No."; Rec."Correspondent Bank Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account No. field.', Comment = '%';
                }
                field("Correspondent IBAN No."; Rec."Correspondent IBAN No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the IBAN No. field.', Comment = '%';
                }
            }
        }
        addlast(Communication)
        {
            //#242 TEC.VJ 03MARCH2025>>>>
            group(Email)
            {
                grid(Row1)
                {
                    field("Email Name 1"; Rec."Email Name 1")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Name 1 field.', Comment = '%';
                    }
                    field("Email Address 1"; Rec."Email Address 1")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Address 1 field.', Comment = '%';
                    }
                }
                grid(Row2)
                {
                    field("Email Name 2"; Rec."Email Name 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Name 2 field.', Comment = '%';
                    }
                    field("Email Address 2"; Rec."Email Address 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Address 2 field.', Comment = '%';
                    }
                }
                grid(Row3)
                {
                    field("Email Name 3"; Rec."Email Name 3")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Name 3 field.', Comment = '%';
                    }
                    field("Email Address 3"; Rec."Email Address 3")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Address 3 field.', Comment = '%';
                    }
                }
                grid(Row4)
                {
                    field("Email Name 4"; Rec."Email Name 4")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Name 4 field.', Comment = '%';
                    }
                    field("Email Address 4"; Rec."Email Address 4")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Address 4 field.', Comment = '%';
                    }
                }
                grid(Row5)
                {
                    field("Email Name 5"; Rec."Email Name 5")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Name 5 field.', Comment = '%';
                    }
                    field("Email Address 5"; Rec."Email Address 5")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Address 5 field.', Comment = '%';
                    }
                }
                grid(Row6)
                {
                    field("Email Name 6"; Rec."Email Name 6")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Name 6 field.', Comment = '%';
                    }
                    field("Email Address 6"; Rec."Email Address 6")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Address 6 field.', Comment = '%';
                    }
                }
            //#242 TEC.VJ 03MARCH2025>><<
            }
        }
        addlast(General)
        {
            //#242 TEC.VJ 03MARCH2025>>>>
            field("IFSC Code"; Rec."IFSC Code")
            {
                ApplicationArea = all;
            }
            field("Payment Purpose"; Rec."Payment Purpose")
            {
                ApplicationArea = all;
            }
            field("CNAPS No."; Rec."CNAPS No.")
            {
                ApplicationArea = all;
            }
            field("UK Clearing Code"; Rec."UK Clearing Code")
            {
                ApplicationArea = all;
            }
        //#242 TEC.VJ 03MARCH2025>><<
        }
    }
}

pageextension 50143 "Country/Region_Ext" extends "Countries/Regions"
{
    layout
    {
        addafter(Name)
        {
            field("Add Mandatory for Address"; Rec."Add Mandatory for Address")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Add Mandatory for Address field.', Comment = '%';
            }
            field("Purpose Code (HSBC)  Prefix"; Rec."Purpose Code (HSBC)  Prefix")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purpose Code (HSBC)  Prefix field.', Comment = '%';
            }
            field("Purpose Code (HSBC) Mandatory"; Rec."Purpose Code (HSBC) Mandatory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purpose Code (HSBC)  Mandatory field.', Comment = '%';
            }
            field("Purpose Code (Citi)  Prefix"; Rec."Purpose Code (Citi)  Prefix")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purpose Code (Citi)  Prefix field.', Comment = '%';
            }
            field("Purpose Code (Citi) Mandatory"; Rec."Purpose Code (Citi) Mandatory")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Purpose Code (Citi)  Mandatory field.', Comment = '%';
            }
            field("Local Currency Code"; Rec."Local Currency Code")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Local Currency Code field.';
            }
            field("Default IFSC"; Rec."Default IFSC")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Default ISFC to Message to Recipient in Payment Journal(BOC) field.';
            }
        }
    }
}

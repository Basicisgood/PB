tableextension 50126 "Country/Region_Ext" extends "Country/Region"
{
    fields
    {
        field(50100; "Purpose Code (HSBC) Mandatory"; Boolean)
        {
            Caption = 'Purpose Code (HSBC)  Mandatory';
            DataClassification = ToBeClassified;
        }
        field(50101; "Purpose Code (HSBC)  Prefix"; Text[10])
        {
            Caption = 'Purpose Code (HSBC)  Prefix';
            DataClassification = ToBeClassified;
        }
        field(50102; "Purpose Code (Citi) Mandatory"; Boolean)
        {
            Caption = 'Purpose Code (Citi)  Mandatory';
            DataClassification = ToBeClassified;
        }
        field(50103; "Purpose Code (Citi)  Prefix"; Text[10])
        {
            Caption = 'Purpose Code (Citi)  Prefix';
            DataClassification = ToBeClassified;
        }
        field(50105; "Add Mandatory for Address"; Boolean)
        {
            Caption = 'Add Mandatory for Address';
            DataClassification = ToBeClassified;
        }
        field(50106; "Local Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(50107; "Default IFSC"; Boolean)
        {
            Caption = 'Default ISFC to Message to Recipient in Payment Journal(BOC)';
            DataClassification = ToBeClassified;
        }
    }
}

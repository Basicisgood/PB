tableextension 50116 "UserSetup_Ext" extends "User Setup"
{
    fields
    {
        field(50100; "User Type";Enum "User Type User Setup")
        {
            Caption = 'User Type';
            DataClassification = CustomerContent;
        }
        field(50101; "Allow Force Reject Pmt Journal"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //PS098 STart
        field(50102; "Deployment Notification"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //TEC.VJ>>
        field(50103; "Allow Inbound Edit/Delete"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //TEC.VJ<<
        //PS098 End
        //#323 TEC.VJ 30APR2025>>
        field(50104; "Allow Undo Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

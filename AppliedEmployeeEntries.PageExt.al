pageextension 50151 AppliedEmployeeEntries extends "Applied Employee Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Bank Document No."; Rec."Bank Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
}

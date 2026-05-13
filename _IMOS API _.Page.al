page 50227 "IMOS API "
{
    Caption = 'IMOS API ';
    SourceTable = "IMOS API Inbound";
    PageType = API;
    APIPublisher = 'sd';
    APIGroup = 'customapi';
    APIVersion = 'v1.0';
    EntityName = 'IMOS';
    EntitySetName = 'IMOS';
    DelayedInsert = true;
    InsertAllowed = true;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("EntryNo"; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
                field("Datetime"; Rec."Datetime")
                {
                    ToolTip = 'Specifies the value of the Datetime field.', Comment = '%';
                }
                field(Data; Rec.Data)
                {
                    ToolTip = 'Specifies the value of the Content field.';
                }
            }
        }
    }
}

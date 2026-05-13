page 50238 "TCI Export API"
{
    APIGroup = 'TCIExport';
    APIPublisher = 'publisherName';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'tciExportAPI';
    DelayedInsert = true;
    InsertAllowed = true;
    DeleteAllowed = false;
    EntityName = 'TCIExport';
    EntitySetName = 'TCIExport';
    SourceTable = "TCI Export Inbound";
    PageType = API;

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

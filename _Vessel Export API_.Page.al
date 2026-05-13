page 50240 "Vessel Export API"
{
    APIGroup = 'VesselExport';
    APIPublisher = 'VesselExport';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'vesselExportAPI';
    DelayedInsert = true;
    InsertAllowed = true;
    DeleteAllowed = false;
    EntityName = 'VesselExport';
    EntitySetName = 'VesselExport';
    PageType = API;
    SourceTable = "Vessel Export Inbound";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field("datetime"; Rec."Datetime")
                {
                    Caption = 'Datetime';
                }
                field(data; Rec.Data)
                {
                    Caption = 'Data';
                }
            }
        }
    }
}

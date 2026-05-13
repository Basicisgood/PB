page 50225 "IMOS Json"
{
    APIGroup = 'IMOS';
    APIPublisher = 'PB';
    APIVersion = 'v1.0', 'v2.0';
    ApplicationArea = All;
    Caption = 'imosJson';
    DelayedInsert = true;
    EntityName = 'imosjson';
    EntitySetName = 'imosjson';
    PageType = API;
    SourceTable = "IMOS Json";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Visible = false;
                }
                field(jsonFile; Rec.JSONFile)
                {
                    Caption = 'JSONFile';
                }
            }
        }
    }
}

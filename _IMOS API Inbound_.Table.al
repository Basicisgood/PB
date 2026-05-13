table 50187 "IMOS API Inbound"
{
    Caption = 'IMOS API Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Datetime"; Text[50])
        {
            Caption = 'Datetime';
        }
        field(3; Data; Blob)
        {
            Caption = 'Content';
        }
        field(4; "Processed to Staging"; Boolean)
        {
            Caption = 'Processed to Staging';
        }
        field(5; "Staging Entry No."; Integer)
        {
            Caption = 'Staging Entry No.';
        }
        field(10; "Transaction No"; Text[50])
        {
            caption = 'Transaction No';
        }
        field(15; Status;Enum EnumStatus)
        {
        }
        field(20; "Error Description"; Text[250])
        {
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    procedure CreateOutboundLogForIMOS(P_Type: Option Insert, Update)
    var
        IMOSOutboundLog: Record "IMOS API Log";
        Log: Record "IMOS API Log";
    begin
        exit;
        IMOSOutboundLog.Init();
        IMOSOutboundLog."Entry No.":=0;
        IMOSOutboundLog."Table No.":=Database::"IMOS API Inbound";
        IMOSOutboundLog."Primary key":=IMOSOutboundLog."Primary key"::Invoice;
        IMOSOutboundLog."Primary key 2":=format(Rec."Entry No.");
        IMOSOutboundLog."Primary key 3":=Rec."Transaction No";
        IMOSOutboundLog.Status:=IMOSOutboundLog.Status::Pending;
        IMOSOutboundLog.Insert(true);
    End;
}

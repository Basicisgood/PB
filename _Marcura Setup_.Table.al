table 50225 "Marcura Setup"
{
    Caption = 'Marcura Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; PK; Text[20])
        {
            Caption = 'PK';
        }
        field(2; "Token URL"; Text[250])
        {
            Caption = 'Token URL';
        }
        field(3; "Payment API URL"; Text[250])
        {
            Caption = 'Payment API URL';
        }
        field(5; "User Id"; Text[100])
        {
            Caption = 'Client id';
        }
        field(6; "Password"; Text[100])
        {
            Caption = 'Client Secret';
        }
        field(10; "Access Token"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Payment Template Name"; code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(13; "Payment Batch Name"; code[10])
        {
            Caption = 'Payment Batch Name';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name"=field("Payment Template Name"));
        }
    }
    keys
    {
        key(PK; PK)
        {
            Clustered = true;
        }
    }
    procedure SetAccessToken(NewAccessToken: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Access Token");
        "Access Token".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewAccessToken);
        Modify;
    end;
    procedure GetAccessToken()AccessToken: Text var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Access Token");
        "Access Token".CreateInStream(InStream, TEXTENCODING::UTF8);
        if not TypeHelper.TryReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator(), AccessToken)then Message(ReadingDataSkippedMsg, FieldCaption("Access Token"));
    end;
    var myInt: Integer;
    ReadingDataSkippedMsg: Label 'Loading field %1 will be skipped because there was an error when reading the data.\To fix the current data, contact your administrator.\Alternatively, you can overwrite the current data by entering data in the field.', Comment = '%1=field caption';
}

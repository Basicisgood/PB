table 50189 "Concur API Inbound"
{
    //TEC.VJ Created new table to get response from concur for expense,attendee and image api
    Caption = 'Concur API Inbound';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Creation DateTime"; DateTime)
        {
            Caption = 'Creation DateTime';
        }
        field(3; JsonData; Blob)
        {
            Caption = 'Json Response';
        }
        field(4; "Processed to Staging"; Boolean)
        {
            Caption = 'Processed to Staging';
        }
        field(5; "Staging Entry No."; Integer)
        {
            Caption = 'Staging Entry No.';
        }
        field(6; "API Type"; Option)
        {
            Caption = 'API Type';
            OptionCaption = ' ,Expense,Attende,Image,Confirmation,Payment Confirmation,Get Identity,Attendee Info,Cash Advance,CA Post Confirmation';
            OptionMembers = " ", Expense, Attende, Image, Confirmation, "Payment Confirmation", "Get Identity", "Attendee Info", "Cash Advance", "CA Post Confirmation";
        }
        field(10; "Transaction No"; Text[50])
        {
            caption = 'Transaction No';
        }
        field(11; acknowledgeResult; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Ack errorMessage"; Text[1024])
        {
            DataClassification = ToBeClassified;
        }
        field(13; ExpenseID; TEXT[2048])
        {
            DataClassification = ToBeClassified;
        }
        field(14; AckJsonData; Blob)
        {
            Caption = 'AckContent';
        }
        field(15; JsonRequest; Blob)
        {
            Caption = 'JsonRequest';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    procedure InsertLog(p_apitype: Option; JsonRequest: text; JsonResponse: text): Integer var
        OutStream: OutStream;
        OutStream2: OutStream;
    begin
        Rec.Init();
        Rec."Entry No.":=0;
        Rec."API Type":=p_apitype;
        Rec."Creation DateTime":=CurrentDateTime;
        // Create OutStream for the Blob field
        Rec.JsonData.CreateOutStream(OutStream);
        rec.JsonRequest.CreateOutStream(OutStream2);
        Rec."Processed to Staging":=true;
        // Write the JSON data to the Blob field using OutStream
        OutStream.WriteText(JsonResponse);
        OutStream2.WriteText(JsonRequest);
        // Commit the record
        Rec.Insert(true);
        exit(Rec."Entry No.");
    end;
    procedure InsertLog(p_apitype: Option; JsonResponse: text): Integer var
        OutStream: OutStream;
    begin
        Rec.Init();
        Rec."Entry No.":=0;
        Rec."API Type":=p_apitype;
        Rec."Creation DateTime":=CurrentDateTime;
        // Create OutStream for the Blob field
        Rec.JsonData.CreateOutStream(OutStream);
        Rec."Processed to Staging":=true;
        // Write the JSON data to the Blob field using OutStream
        OutStream.WriteText(JsonResponse);
        // Commit the record
        Rec.Insert(true);
        exit(Rec."Entry No.");
    end;
    procedure Updateexpenseid(p_expenseid: Text; logentryno: Integer)
    var
        ConcurAPIInbound: Record "Concur API Inbound";
    begin
        ConcurAPIInbound.Get(logentryno);
        ConcurAPIInbound.ExpenseID:=p_expenseid;
        ConcurAPIInbound.Modify();
    end;
    procedure Updateexpnseack(AcknowledgeResult: Text; ErrorMessage: Text; JsonResponseTxt: Text; p_expenseid: Text; logentryno: Integer)
    var
        ConcurAPIInbound: Record "Concur API Inbound";
        OutStream: OutStream;
    begin
        ConcurAPIInbound.Get(logentryno);
        ConcurAPIInbound.acknowledgeResult:=AcknowledgeResult;
        ConcurAPIInbound."Ack errorMessage":=ErrorMessage;
        ConcurAPIInbound.ExpenseID:=p_expenseid;
        ConcurAPIInbound.AckJsonData.CreateOutStream(OutStream);
        // Write the JSON data to the Blob field using OutStream
        OutStream.WriteText(JsonResponseTxt);
        ConcurAPIInbound.Modify();
    end;
}

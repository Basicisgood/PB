page 50232 "Concur Outbound Log"
{ //PS004
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Concur Outbound Log";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ToolTip = 'Specifies the value of the Table Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Company Name"; Rec."Company Name")
                {
                    ToolTip = 'Specifies the value of the Company Name field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Primary key"; Rec."Primary key")
                {
                    ToolTip = 'Specifies the value of the Primary key field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Primary key 2"; Rec."Primary key 2")
                {
                    ToolTip = 'Specifies the value of the Primary key 2 field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Sent Date Time"; Rec."Sent Date Time")
                {
                    ToolTip = 'Specifies the value of the Sent Date Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Overall Status"; Rec."Overall Status")
                {
                    ToolTip = 'Specifies the value of the Overall Status field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = all;
                }
                field(Message; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Request Body"; RequestBody)
                {
                    ApplicationArea = all;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ToolTip = 'Specifies the value of the Status Code field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Status Message"; Rec."Status Message")
                {
                    ToolTip = 'Specifies the value of the Status Message field.', Comment = '%';
                    ApplicationArea = All;
                }
                field(Path; Rec.Path)
                {
                    ToolTip = 'Specifies the value of the Path field.', Comment = '%';
                    ApplicationArea = All;
                }
                //PS005 Start
                field("Concur ID"; Rec."Concur ID")
                {
                    ToolTip = 'Specifies the value of the Concur ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Privision ID"; Rec."Privision ID")
                {
                    ToolTip = 'Specifies the value of the Privision ID field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Status URL"; Rec."Status URL")
                {
                    ToolTip = 'Specifies the value of the Status URL field.', Comment = '%';
                    ApplicationArea = All;
                }
            //PS005 End
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Exch Rate API")
            {
                ApplicationArea = all;
                RunObject = codeunit "Concur Outbound Exch. Rate API";
            //RunObject = codeunit "Concur Outbound Emp. Ins./Upd.";
            }
            action("Employee API")
            {
                ApplicationArea = all;
                // RunObject = codeunit "Concur Outbound Exch. Rate API";
                RunObject = codeunit "Concur Outbound Emp. Ins./Upd.";
            }
        }
    }
    var RequestBody: Text;
    local procedure GetRequestBody()
    var
        InStr: InStream;
    begin
        rec.CalcFields("Request Body");
        rec."Request Body".CreateInStream(instr);
        instr.read(RequestBody);
    end;
    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        GetRequestBody();
    end;
}

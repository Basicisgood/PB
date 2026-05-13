page 50269 "PB Deployment Notification"
{
    Caption = 'PB Deployment Notification';
    PageType = Card;
    SourceTable = "PB Deployment Details";
    InsertAllowed = true;
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Deployment Date"; Rec."Deployment Date")
                {
                    ToolTip = 'Specifies the value of the Deployment Date field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Deployment Time"; Rec."Deployment Time")
                {
                    ToolTip = 'Specifies the value of the Deployment Time field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Deployment Subject"; Rec."Deployment Subject")
                {
                    ToolTip = 'Specifies the value of the Deployment Subject field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Deployment Body"; Rec."Deployment Body")
                {
                    ToolTip = 'Specifies the value of the Deployment Body field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Recipient List"; Rec."Recipient List")
                {
                    ToolTip = 'Specifies the value of the Recipient List field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Recipient CC List"; Rec."Recipient CC List")
                {
                    ToolTip = 'Specifies the value of the Recipient CC List field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("Start Processed DatenTime"; Rec."Start Processed DatenTime")
                {
                    ToolTip = 'Specifies the value of the Start Processed DatenTime field.', Comment = '%';
                    ApplicationArea = All;
                }
                field("End Processed DatenTime"; Rec."End Processed DatenTime")
                {
                    ToolTip = 'Specifies the value of the End Processed DatenTime field.', Comment = '%';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(StartNotification)
            {
                ApplicationArea = All;
                Caption = 'Start Notification';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    emailsubj: Text;
                    emailBody: Text;
                    DateFormat: Text;
                    TimeFormat: Text;
                    BodyText: Text;
                begin
                    DateFormat:=Format(rec."Deployment Date", 11, '<Day,2>-<Month Text,3>-<Year4>');
                    TimeFormat:=Format(rec."Deployment Time", 10, '<Hours12>:<Minutes,2> <AM/PM>');
                    emailsubj:=StrSubstNo(rec."Deployment Subject", DateFormat, TimeFormat);
                    Message(emailsubj);
                    BodyText:='********************************************************************************' + '<br />' + '<br />' + 'Dear All,' + '<br />' + '<br />' + 'Please note that a BC urgent  deployment is scheduled on ' + DateFormat + ' & ' + TimeFormat + ' .' + '<br />' + '<br />' + 'Regards,' + '<br />' + 'BC Team' + '<br />' + '<br />' + '********************************************************************************';
                    Message(BodyText);
                end;
            }
        }
    }
}

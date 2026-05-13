page 50123 "Inbound Error Log Entry"
{
    ApplicationArea = All;
    Caption = 'Inbound Error Log Entry';
    PageType = List;
    SourceTable = "Inbound Error Log Entry";
    UsageCategory = Lists;

    // Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                }
                field("Error Text"; Rec."Error Text")
                {
                    ToolTip = 'Specifies the value of Error Text field.';
                    ApplicationArea = All;
                }
                field("Interface Entry No."; Rec."Inbound Entry No.")
                {
                    ToolTip = 'Specifies the value of the Interface Entry No. field.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Function)
            {
                action(Process)
                {
                    ApplicationArea = all;

                    trigger OnAction()
                    begin
                        Codeunit.Run(50001);
                    end;
                }
            }
        }
    }
}

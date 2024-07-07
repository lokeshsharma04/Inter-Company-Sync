page 57101 "ITOS Inter Company Sync Log"
{
    ApplicationArea = All;
    Caption = 'IC Sync Log';
    PageType = List;
    SourceTable = "ITOS IC Sync Entries";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."ITOS Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No field.';
                }

                field("Table No"; Rec."ITOS Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No field.';
                }
                field("Primary Key 1"; Rec."ITOS Primary Key 1")
                {
                    ToolTip = 'Specifies the value of the Primary Key 1 field.';
                }
                field("Primary Key 2"; Rec."ITOS Primary Key 2")
                {
                    ToolTip = 'Specifies the value of the Primary Key 2 field.';
                }
                field("Primary Key 3"; Rec."ITOS Primary Key 3")
                {
                    ToolTip = 'Specifies the value of the Primary Key 3 field.';
                }
                field("Record ID"; Rec."ITOS Record ID")
                {
                    ToolTip = 'Specifies the value of the Record ID field.';
                }
                field(Status; Rec."ITOS Status")
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Company NITOS"; Rec."ITOS Company Name")
                {
                    ToolTip = 'Specifies the value of the Company NITOS field.';
                }
                field("Created On"; Rec."ITOS Created On")
                {
                    ToolTip = 'Specifies the value of the Created On  field.';
                }
                field("Last Updated On"; Rec."ITOS Last Updated On")
                {
                    ToolTip = 'Specifies the value of the Last Updated On  field.';
                }

            }
        }
    }
}

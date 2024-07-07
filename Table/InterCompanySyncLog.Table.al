table 57101 "ITOS IC Sync Entries"
{
    Caption = 'Inter Company Sync Entries';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "ITOS Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "ITOS Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(3; "ITOS Primary Key 1"; Text[50])
        {
            Caption = 'Primary Key 1';
        }
        field(4; "ITOS Primary Key 2"; Text[50])
        {
            Caption = 'Primary Key 2';
        }
        field(5; "ITOS Primary Key 3"; Text[50])
        {
            Caption = 'Primary Key 3';
        }
        field(6; "ITOS Record ID"; Guid)
        {
            Caption = 'Record ID';
        }
        field(7; "ITOS Status"; Option)
        {
            OptionMembers = Created,"Sync Completed";
            OptionCaption = 'Pending,Sync Completed';
            Caption = 'Status';
        }
        field(8; "ITOS Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company;
        }
        field(9; "ITOS Created On"; DateTime)
        {
            Caption = 'Created On ';
        }
        field(10; "ITOS Last Updated On"; DateTime)
        {
            Caption = 'Last Updated On ';
        }
    }
    keys
    {
        key(PK; "ITOS Entry No.")
        {
            Clustered = true;
        }
    }

    procedure InitFromSetup(SyncSetup: Record "ITOS IC Sync Setup")
    begin
        Rec."ITOS Table No." := SyncSetup."ITOS Table No.";
        Rec."ITOS Primary Key 1" := SyncSetup."ITOS Primary Key 1";
        Rec."ITOS Primary Key 2" := SyncSetup."ITOS Primary Key 2";
        Rec."ITOS Primary Key 3" := SyncSetup."ITOS Primary Key 3";
        Rec."ITOS Company Name" := SyncSetup."ITOS Company Name";
    end;
}

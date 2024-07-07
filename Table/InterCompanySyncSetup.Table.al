table 57102 "ITOS IC Sync Setup"
{
    Caption = 'Inter-Company Sync Setup';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; "ITOS Entry No."; Integer)
        {
            Caption = 'Entry No';
            AutoIncrement = true;
        }
        field(10; "ITOS Table No."; Integer)
        {
            Caption = 'Table No.';
        }
        field(20; "ITOS Primary Key 1"; Text[50])
        {
            Caption = 'Primary Key 1';
        }
        field(30; "ITOS Primary Key 2"; Text[50])
        {
            Caption = 'Primary Key 2';
        }
        field(40; "ITOS Primary Key 3"; Text[50])
        {
            Caption = 'Primary Key 3';
        }
        field(50; "ITOS Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company.Name;

            trigger OnLookup()
            var
                Company: Record Company;
                Companies: Page Companies;
                FileName: Text;
            begin

                Company.SetFilter(Name, '<>%1', CompanyName);
                Companies.SetTableView(Company);
                Companies.LookupMode := true;
                if Companies.RunModal() = ACTION::LookupOK then begin
                    Companies.GetRecord(Company);
                    "ITOS Company Name" := Company.Name;
                end;
            end;
        }
        field(100; "ITOS Created On"; DateTime)
        {
            Caption = 'Created On';

        }
        field(101; "ITOS Last Updated On"; DateTime)
        {
            Caption = 'Last Updated On ';
        }
        field(110; "ITOS Status"; Option)
        {
            Caption = 'Status';
            OptionMembers = Active,Inactive;
        }
    }
    keys
    {
        key(PK; "ITOS Table No.", "ITOS Primary Key 1", "ITOS Primary Key 2", "ITOS Primary Key 3", "ITOS Company Name")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    var
        myInt: Integer;
    begin
        "ITOS Created On" := CurrentDateTime;
    end;
}

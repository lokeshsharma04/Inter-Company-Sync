pageextension 57106 "ITOS G/L Account Card" extends "G/L Account Card"
{
    actions
    {
        addlast(processing)
        {
            action(ITOSSyncSetup)
            {
                Caption = 'IC Sync Setup';
                ApplicationArea = All;
                RunObject = page "ITOS Inter-Company Sync Setup";
                RunPageLink = "ITOS Primary Key 1" = field("No."), "ITOS Table No." = const(Database::"G/L Account");
            }
        }
    }
}

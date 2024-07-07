pageextension 57107 "ITOS Item Card" extends "Item Card"
{
    actions
    {
        addlast(processing)
        {
            group(ITOSICSync)
            {
                Caption = 'IC Sync';
                action(ITOSSyncSetup)
                {
                    Caption = 'IC Sync Setup';
                    ApplicationArea = All;
                    RunObject = page "ITOS Inter-Company Sync Setup";
                    RunPageLink = "ITOS Primary Key 1" = field("No."), "ITOS Table No." = const(Database::Item);
                }
                action("ITOSSendToIC")
                {
                    ApplicationArea = Intercompany;
                    Caption = 'Send IC Item';
                    Image = IntercompanyOrder;

                    trigger OnAction()
                    var
                        ICSyncMgt: Codeunit "ITOS IC Sync Mgt.";
                    begin
                        if not ICSyncMgt.SendItemToIC(Rec) then
                            Message(GetLastErrorText());
                    end;
                }
                action("ITOSICSyncLogEntries")
                {
                    ApplicationArea = Intercompany;
                    Caption = 'IC Sync Entries';
                    Image = History;
                    RunObject = page "ITOS Inter Company Sync Log";
                    RunPageLink = "ITOS Primary Key 1" = field("No."), "ITOS Table No." = const(Database::Item);
                }
            }
        }
    }
}
page 50100 "My Prompt Dialog"
{
    Caption = 'Crete a draft';
    PageType = PromptDialog;
    Extensible = false;
    PromptMode = Prompt;
    IsPreview = true;
    DataCaptionExpression = UserInput;
    SourceTable = TempInputData;
    SourceTableTemporary = true;

    layout
    {
        area(Prompt)
        {
            field(input; UserInput)
            {
                ApplicationArea = All;
                ShowCaption = false;
                MultiLine = true;
                // Adds placeholder text.
                InstructionalText = 'Enter information that describes that you want to give Copilot...';
            }
        }
        area(Content)
        {
            field(generatedOutput; Output)
            {
                ShowCaption = false;
                MultiLine = true;
            }
        }
        area(PromptOptions)
        {
            field(tone; Tone)
            {
            }
            field(format; Format)
            {
            }
            field(emphasis; Emphasis)
            {
            }
        }
    }

    actions
    {
        area(PromptGuide)
        {
            action(MyPromptAction)
            {
                Caption = 'How can I [do this]';
                ToolTip = 'Ask Copilot for help with a specific task.';

                trigger OnAction()
                begin
                    InputProjectDescription := 'How can I [do this]';
                end;
            }
        }
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                trigger OnAction()
                begin
                    // The code triggering the Copilot interaction. This is where you call the Copilot API, and get the results back. You must implement this yourself. 
                    RunGeneration();
                end;
            }
            systemaction(Attach)
            {
                Caption = 'Attach a file';
                ToolTip = 'Attach a file describing the job.';
                trigger OnAction()
                var
                    InStr: InStream;
                    Filename: Text;
                begin
                    UploadIntoStream(‘Select a file...', '', ‘All files (*.*)|*.*', Filename, InStr);
                    if not (Filename = '') then begin

                    end;
                end;
            }
            systemaction(OK)
            {
                Caption = 'Save';
                ToolTip = 'Save the draft.';
            }
            systemaction(Cancel)
            {
                Caption = 'Cancel';
                ToolTip = 'Throw away the draft.';
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';

                trigger OnAction()
                begin
                    RunGenerate();
                end;
            }

        }
        area(Prompting)
        {
            action(MyPromptAction)
            {
                Caption = 'Draft a proposal';
                Image = Sparkle;
                RunObject = page "My Prompt Dialog";
            }
        }


    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        SaveCopilotJobProposal: Codeunit "Save Copilot Job Proposal";
    begin
        if CloseAction = CloseAction::OK then
            SaveCopilotJobProposal.Save(CustomerNo, CopilotJobProposal);
    end;

    var
        InputProjectDescription: Text;

    trigger OnInit()
    begin
        CurrPage.PromptMode := PromptMode::Generate;
    end;
    systemaction(Generate)
    {
        trigger OnAction()
        var
            GenerateModeProgress: Dialog;
        begin
            GenerateModeProgress.Open('Creating a draft for you...');
        end;
    }

    systemaction(Regenerate)
    {
        trigger OnAction()
        var
            GenerateModeProgress: Dialog;
        begin
            GenerateModeProgress.Open('Revising the draft...');
        end;
    }
    systemaction(Generate)
    {
        Caption = 'Generate';

        trigger OnAction();
        begin
            RunGenerate(CopilotGeneratingTxt);
        end;
    }
    systemaction(Regenerate)
    {
        Caption = 'Regenerate';
        trigger OnAction()
        begin
            RunGenerate(CopilotRegeneratingTxt);
        end;
    }
    local procedure RunGenerate(ProgressTxt: Text)
    begin
        GenerateModeProgress.Open(ProgressTxt);
        var
            GenerateModeProgress: Dialog;
            CopilotGeneratingTxt: Label 'Creating a draft for you...';
            CopilotRegeneratingTxt: Label 'Revising the draft...';

    end;
    var
    IsSaaS: Boolean;


    trigger OnOpenPage()
    var
        EnvInfo: Codeunit "Environment Information";

    begin
        IsSaaS := EnvInfo.IsSaaSInfrastructure()
    end;

}
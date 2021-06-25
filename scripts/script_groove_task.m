clear all
close all

settings.relative                   = '../';
settings.PreRunDuration             = '10s';
settings.PostRunDuration            = '10s';
settings.NumberOfSequences          = '1';
settings.WindowTop                  = '0';
settings.WindowLeft                 = '0';
settings.WindowWidth                = '1920';
settings.WindowHeight               = '1080';
settings.BackgroundColor            = '0xFFFFFF';
settings.WindowBackgroundColor      = '0xFFFFFF';
settings.ISIMinDuration             = '0ms';
settings.ISIMaxDuration             = '0ms';
settings.SubjectName                = 'ECOG';
settings.DataDirectory              = 'data/groove_task/';
settings.SubjectSession             = '001';
settings.SubjectRun                 = '01';
settings.StimuliDirectory           = 'stimuli/stimuli_groove_task';
settings.prm_filename               = '../parms.ECoG/MITFamiliarityScreeningTask/fragment_groove_task_%d.prm';
settings.UserComment                = 'MIT Groove task block 1 %d';

%%
stimuli_names = {...
    
21, 'LR7 LH4'; ... % practice #1

81, 'HR7 HH6'; ... % practice #2

49, 'Mariato Clave MR5 MH1'; ... % practice #3

24, 'LR7 MH4'; ... % practice #4

32, 'Son Clave MR1 MH2'; ...

33, 'Son Clave MR1 MH4'; ...

41, 'Rumba Clave MR2 MH2'; ...

42, 'Rumba Clave MR2 MH4'; ...

50, 'Mariato Clave MR5 MH2'; ...

51, 'Mariato Clave MR5 MH4'; ...

34, 'Son Clave MR1 HH3'; ...

35, 'Son Clave MR1 HH5'; ...

43, 'Rumba Clave MR2 HH3'; ...

44, 'Rumba Clave MR2 HH5'; ...

52, 'Mariato Clave MR5 HH3'; ...

53, 'Mariato Clave MR5 HH5'; ...

59, 'HR1 MH2'; ...

60, 'HR1 MH4'; ...

68, 'HR3 MH2'; ...

69, 'HR3 MH4'; ...

77, 'HR7 MH2'; ...

78, 'HR7 MH4'; ...

61, 'HR1 HH3'; ...

62, 'HR1 HH5'; ...

70, 'HR3 HH3'; ...

71, 'HR3 HH5'; ...

79, 'HR7 HH3'; ...

80, 'HR7 HH5'; ...
};


stimuli_names(:, 1) = cellfun(@num2str, stimuli_names(:,1), 'un', 0);
practice_list = {[1,2],[3,4]};

for idx_dir = 1:2 % we create a file for each of the two tasks
    %% prepare instruction and other screens:
    screen_txt = {
        sprintf('instructions%d.png',idx_dir),sprintf('instructions%d',idx_dir);
        sprintf('question%d.png',idx_dir),sprintf('question%d',idx_dir);
        'practice_start.png','practice_start';
        'practice_end.png','practice_end';
        'fixation.png','fixation';
        'break.png','break';
        'block_end.png','block_end';
        'black_screen.png','black_screen';
        };
    screen_durations = [3600000,7000,3600000,3600000,1000,3600000,3000,500];
    key_presses = {'KeyDown==32',...#'KeyDown!=0',...
                   'KeyDown==49 || KeyDown==50 || KeyDown==51 || KeyDown==52 || KeyDown==53',...
                   'KeyDown==32',...#'KeyDown!=0',...
                   'KeyDown==32',...#'KeyDown!=0',...
                   '',...
                   'KeyDown==32',...%'KeyDown!=0',...
                   '',...
                   ''};
               
    num_stimuli = length(stimuli_names);   
    num_screens = length(screen_txt);
    %%
    
    temp_prm_filename = sprintf(settings.prm_filename, idx_dir);
    temp_UserComment  = sprintf(settings.UserComment, idx_dir);
    
    
    %%
    
    param.Stimuli.Section      = 'Application';
    param.Stimuli.Type         = 'matrix';
    param.Stimuli.DefaultValue = '';
    param.Stimuli.LowRange     = '';
    param.Stimuli.HighRange    = '';
    param.Stimuli.Comment      = 'captions and icons to be displayed, sounds to be played for different stimuli';
    param.Stimuli.Value        = cell(6,num_stimuli + num_screens + 48);
    param.Stimuli.RowLabels    = cell(6,1);
    param.Stimuli.ColumnLabels = cell(1,num_stimuli + num_screens + 48);
    
    param.Stimuli.RowLabels{1} = 'caption';
    param.Stimuli.RowLabels{2} = 'icon';
    param.Stimuli.RowLabels{3} = 'audio';
    param.Stimuli.RowLabels{4} = 'StimulusDuration';
    param.Stimuli.RowLabels{5} = 'AudioVolume';
    param.Stimuli.RowLabels{6} = 'EarlyOffsetExpression';
    param.Stimuli.RowLabels{7} = 'CaptionColor';
    
    
    
    for idx=1:(num_stimuli + num_screens + 48)
        param.Stimuli.ColumnLabels{idx} = sprintf('%d',idx);
        param.Stimuli.Value{1,idx}      = '';
        param.Stimuli.Value{2,idx}      = '';
        param.Stimuli.Value{3,idx}      = '';
        param.Stimuli.Value{4,idx}      = '';
        param.Stimuli.Value{5,idx}      = '';
        param.Stimuli.Value{6,idx}      = '';
        param.Stimuli.Value{7,idx}      = '';
    end
    
    
    for idx=1:(num_stimuli)
        param.Stimuli.ColumnLabels{idx} = sprintf('%d',idx);
        param.Stimuli.Value{1,idx}      = stimuli_names{idx,2};
        param.Stimuli.Value{2,idx}      = [settings.relative, settings.StimuliDirectory,'/','fixation.png'];
        param.Stimuli.Value{3,idx}      = [settings.relative, settings.StimuliDirectory,'/',stimuli_names{idx,1},'.wav'];
        param.Stimuli.Value{4,idx}      = '10000ms';
        param.Stimuli.Value{5,idx}      = '100';
        param.Stimuli.Value{6,idx}      = '';
        param.Stimuli.Value{7,idx}      = '';
    end  
    
    
    for idx=1:length(screen_txt)
        param.Stimuli.ColumnLabels{num_stimuli + idx} = sprintf('%d',num_stimuli + idx);
        param.Stimuli.Value{1,num_stimuli + idx}      = screen_txt{idx,2};
        param.Stimuli.Value{2,num_stimuli + idx}      = [settings.relative, settings.StimuliDirectory,'/',screen_txt{idx,1}];
        param.Stimuli.Value{3,num_stimuli + idx}      = '';
        param.Stimuli.Value{4,num_stimuli + idx}      = sprintf('%dms',screen_durations(idx));
        param.Stimuli.Value{5,num_stimuli + idx}      = '';
        param.Stimuli.Value{6,num_stimuli + idx}      = key_presses{idx};
        param.Stimuli.Value{7,num_stimuli + idx}      = '0xFF0000';
    end
    
    for idx=1:48
        param.Stimuli.ColumnLabels{num_stimuli + idx + num_screens} = sprintf('%d',num_stimuli + 7 + idx);
        param.Stimuli.Value{1,num_stimuli + idx + num_screens}      = sprintf('trial %d', idx);
        param.Stimuli.Value{2,num_stimuli + idx + num_screens}      = [settings.relative, settings.StimuliDirectory,'/',num2str(idx),'.png'];
        param.Stimuli.Value{3,num_stimuli + idx + num_screens}      = '';
        param.Stimuli.Value{4,num_stimuli + idx + num_screens}      = '1000ms';
        param.Stimuli.Value{5,num_stimuli + idx + num_screens}      = '';
        param.Stimuli.Value{6,num_stimuli + idx + num_screens}      = '';
        param.Stimuli.Value{7,num_stimuli + idx + num_screens}      = '0xFF0000';
    end  
    %%
    
    param.Sequence.Section                   = 'Application';
    param.Sequence.Type                      = 'intlist';
    param.Sequence.DefaultValue              = '1';
    param.Sequence.LowRange                  = '1';
    param.Sequence.HighRange                 = '';
    param.Sequence.Comment                   = 'Sequence in which stimuli are presented (deterministic mode)/ Stimulus frequencies for each stimulus (random mode)';
      
    stim_list = [5:num_stimuli,5:num_stimuli];
    
    %randomize stimuli
    stim_list = stim_list(randperm(length(stim_list)));
    counter = 1;
    seq = {};
    for idx = 1:length(stim_list)
        
        % trial #
        seq{counter,1} = sprintf('%d',num_stimuli + num_screens + idx);
        
        %% beggining of fixation
        %seq{counter,1} = sprintf('%d',num_stimuli+5);
        
        % Auditory stimulus
        seq{counter+1,1} = sprintf('%d',stim_list(idx));

        %question
        seq{counter+2,1} = sprintf('%d',num_stimuli+2);
        
        counter = counter + 3;
        
    end
    
    %Add instructions, practice, break and block_end, and store in param:
    
    param.Sequence.Value =  [{sprintf('%d',num_stimuli + 1); %instructions
                              sprintf('%d',num_stimuli + 8)
                              sprintf('%d',num_stimuli + 3); %practice_start
                             
                             %practice_trial1:
                              sprintf('%d',num_stimuli+5);
                              sprintf('%d',practice_list{idx_dir}(1));
                              sprintf('%d',num_stimuli+2);
                             
                             %practice_trial2:
                              sprintf('%d',num_stimuli+5);
                              sprintf('%d',practice_list{idx_dir}(2));
                              sprintf('%d',num_stimuli + 2);
                              
                              sprintf('%d',num_stimuli + 4)}; %practice end
                             
                             %sequence:
                              seq(1:(24*3),1);
                              {sprintf('%d',num_stimuli + 6)}; %break
                              seq((24*3 +1):(48*3),1);
                             
                              {sprintf('%d',num_stimuli + 7)}]; %block end
                                                   
                             
    %%

    param.CaptionSwitch.Section       = 'Application';
    param.CaptionSwitch.Type          = 'int';
    param.CaptionSwitch.DefaultValue  = '1';
    param.CaptionSwitch.LowRange      = '0';
    param.CaptionSwitch.HighRange     = '1';
    param.CaptionSwitch.Comment       = 'Present captions (boolean)';
    param.CaptionSwitch.Value         = {'0'};
    %%
    
    param.NumberOfSequences.Section         = 'Application';
    param.NumberOfSequences.Type            = 'int';
    param.NumberOfSequences.DefaultValue    = '1';
    param.NumberOfSequences.LowRange        = '0';
    param.NumberOfSequences.HighRange       = '';
    param.NumberOfSequences.Comment         = 'number of sequence repetitions in a run';
    param.NumberOfSequences.Value           = {settings.NumberOfSequences};
    
    %%
    
    param.SequenceType.Section              = 'Application';
    param.SequenceType.Type                 = 'int';
    param.SequenceType.DefaultValue         = '0';
    param.SequenceType.LowRange             = '0';
    param.SequenceType.HighRange            = '1';
    param.SequenceType.Comment              = 'Sequence of stimuli is 0 deterministic, 1 random (enumeration)';
    param.SequenceType.Value                = {'0'};
    
    %%
    
    param.StimulusDuration.Section           = 'Application';
    param.StimulusDuration.Type              = 'float';
    param.StimulusDuration.DefaultValue      = '40ms';
    param.StimulusDuration.LowRange          = '0';
    param.StimulusDuration.HighRange         = '';
    param.StimulusDuration.Comment           = 'stimulus duration';
    param.StimulusDuration.Value             = {'0s'};
    
    %%
    
    param.ISIMaxDuration.Section       = 'Application';
    param.ISIMaxDuration.Type          = 'float';
    param.ISIMaxDuration.DefaultValue  = '80ms';
    param.ISIMaxDuration.LowRange      = '0';
    param.ISIMaxDuration.HighRange     = '';
    param.ISIMaxDuration.Comment       = 'maximum duration of inter-stimulus interval';
    param.ISIMaxDuration.Value         = {settings.ISIMaxDuration};
    
    %%
    
    param.ISIMinDuration.Section       = 'Application';
    param.ISIMinDuration.Type          = 'float';
    param.ISIMinDuration.DefaultValue  = '80ms';
    param.ISIMinDuration.LowRange      = '0';
    param.ISIMinDuration.HighRange     = '';
    param.ISIMinDuration.Comment       = 'minimum duration of inter-stimulus interval';
    param.ISIMinDuration.Value         = {settings.ISIMinDuration};
    
    %%
    
    param.PreSequenceDuration.Section       = 'Application';
    param.PreSequenceDuration.Type          = 'float';
    param.PreSequenceDuration.DefaultValue  = '2s';
    param.PreSequenceDuration.LowRange      = '0';
    param.PreSequenceDuration.HighRange     = '';
    param.PreSequenceDuration.Comment       = 'pause preceding sequences/sets of intensifications';
    param.PreSequenceDuration.Value         = {'0s'};
    
    %%
    
    param.PostSequenceDuration.Section       = 'Application';
    param.PostSequenceDuration.Type          = 'float';
    param.PostSequenceDuration.DefaultValue  = '2s';
    param.PostSequenceDuration.LowRange      = '0';
    param.PostSequenceDuration.HighRange     = '';
    param.PostSequenceDuration.Comment       = 'pause following sequences/sets of intensifications';
    param.PostSequenceDuration.Value         = {'0s'};
    
    %%
    
    param.PreRunDuration.Section       = 'Application';
    param.PreRunDuration.Type          = 'float';
    param.PreRunDuration.DefaultValue  = '30000ms';
    param.PreRunDuration.LowRange      = '0';
    param.PreRunDuration.HighRange     = '';
    param.PreRunDuration.Comment       = 'pause preceding first sequence';
    param.PreRunDuration.Value         = {settings.PreRunDuration};
    
    %%
    
    param.PostRunDuration.Section       = 'Application';
    param.PostRunDuration.Type          = 'float';
    param.PostRunDuration.DefaultValue  = '30000ms';
    param.PostRunDuration.LowRange      = '0';
    param.PostRunDuration.HighRange     = '';
    param.PostRunDuration.Comment       = 'pause following last squence';
    param.PostRunDuration.Value         = {settings.PostRunDuration};
    
    
    %%
    
    param.BackgroundColor.Section      = 'Application';
    param.BackgroundColor.Type         = 'string';
    param.BackgroundColor.DefaultValue = '0x00FFFF00';
    param.BackgroundColor.LowRange     = '0x00000000';
    param.BackgroundColor.HighRange    = '0x00000000';
    param.BackgroundColor.Comment      = 'Color of stimulus background (color)';
    param.BackgroundColor.Value        = {settings.BackgroundColor};
    
    %%
    
    param.CaptionColor.Section      = 'Application';
    param.CaptionColor.Type         = 'string';
    param.CaptionColor.DefaultValue = '0x00FFFF00';
    param.CaptionColor.LowRange     = '0x00000000';
    param.CaptionColor.HighRange    = '0x00000000';
    param.CaptionColor.Comment      = 'Color of stimulus caption text (color)';
    param.CaptionColor.Value        = {'0x000000'};
    
    %%
    
    param.WindowBackgroundColor.Section      = 'Application';
    param.WindowBackgroundColor.Type         = 'string';
    param.WindowBackgroundColor.DefaultValue = '0x00FFFF00';
    param.WindowBackgroundColor.LowRange     = '0x00000000';
    param.WindowBackgroundColor.HighRange    = '0x00000000';
    param.WindowBackgroundColor.Comment      = 'background color (color)';
    param.WindowBackgroundColor.Value        = {settings.WindowBackgroundColor};
    
    %%
    
    param.IconSwitch.Section          = 'Application';
    param.IconSwitch.Type             = 'int';
    param.IconSwitch.DefaultValue     = '1';
    param.IconSwitch.LowRange         = '0';
    param.IconSwitch.HighRange        = '1';
    param.IconSwitch.Comment          = 'Present icon files (boolean)';
    param.IconSwitch.Value            = {'1'};
    
    %%
    
    param.AudioSwitch.Section         = 'Application';
    param.AudioSwitch.Type            = 'int';
    param.AudioSwitch.DefaultValue    = '1';
    param.AudioSwitch.LowRange        = '0';
    param.AudioSwitch.HighRange       = '1';
    param.AudioSwitch.Comment         = 'Present audio files (boolean)';
    param.AudioSwitch.Value           = {'1'};
    
    
    %%
    
    param.UserComment.Section         = 'Application';
    param.UserComment.Type            = 'string';
    param.UserComment.DefaultValue    = '';
    param.UserComment.LowRange        = '';
    param.UserComment.HighRange       = '';
    param.UserComment.Comment         = 'User comments for a specific run';
    param.UserComment.Value           = {temp_UserComment};
    
    %%
    
    param.WindowHeight.Section        = 'Application';
    param.WindowHeight.Type           = 'int';
    param.WindowHeight.DefaultValue   = '480';
    param.WindowHeight.LowRange       = '0';
    param.WindowHeight.HighRange      = '';
    param.WindowHeight.Comment        = 'height of application window';
    param.WindowHeight.Value          = {settings.WindowHeight};
    
    %%
    
    param.WindowWidth.Section        = 'Application';
    param.WindowWidth.Type           = 'int';
    param.WindowWidth.DefaultValue   = '480';
    param.WindowWidth.LowRange       = '0';
    param.WindowWidth.HighRange      = '';
    param.WindowWidth.Comment        = 'width of application window';
    param.WindowWidth.Value          = {settings.WindowWidth};
    
    %%
    
    param.WindowLeft.Section        = 'Application';
    param.WindowLeft.Type           = 'int';
    param.WindowLeft.DefaultValue   = '0';
    param.WindowLeft.LowRange       = '';
    param.WindowLeft.HighRange      = '';
    param.WindowLeft.Comment        = 'screen coordinate of application window''s left edge';
    param.WindowLeft.Value          = {settings.WindowLeft};
    
    %%
    
    param.WindowTop.Section        = 'Application';
    param.WindowTop.Type           = 'int';
    param.WindowTop.DefaultValue   = '0';
    param.WindowTop.LowRange       = '';
    param.WindowTop.HighRange      = '';
    param.WindowTop.Comment        = 'screen coordinate of application window''s top edge';
    param.WindowTop.Value          = {settings.WindowTop};
    
    %%
    
    param.StimulusWidth.Section      = 'Application';
    param.StimulusWidth.Type         = 'int';
    param.StimulusWidth.DefaultValue = '0';
    param.StimulusWidth.LowRange     = '0';
    param.StimulusWidth.HighRange    = '100';
    param.StimulusWidth.Comment      = 'StimulusWidth in percent of screen width (zero for original pixel size)';
    param.StimulusWidth.Value        = {'0'};
    
    %%
    
    param.CaptionHeight.Section      = 'Application';
    param.CaptionHeight.Type         = 'int';
    param.CaptionHeight.DefaultValue = '0';
    param.CaptionHeight.LowRange     = '0';
    param.CaptionHeight.HighRange    = '100';
    param.CaptionHeight.Comment      = 'Height of stimulus caption text in percent of screen height';
    param.CaptionHeight.Value        = {'6'};
    
    %%
    
    param.WarningExpression.Section      = 'Filtering';
    param.WarningExpression.Type         = 'string';
    param.WarningExpression.DefaultValue = '';
    param.WarningExpression.LowRange     = '';
    param.WarningExpression.HighRange    = '';
    param.WarningExpression.Comment      = 'expression that results in a warning when it evaluates to true';
    param.WarningExpression.Value        = {''};
    
    %%
    
    param.Expressions.Section      = 'Filtering';
    param.Expressions.Type         = 'matrix';
    param.Expressions.DefaultValue = '';
    param.Expressions.LowRange     = '';
    param.Expressions.HighRange    = '';
    param.Expressions.Comment      = 'expressions used to compute the output of the ExpressionFilter';
    param.Expressions.Value        = {''};
    
    %%
    
    param.SubjectName.Section      = 'Storage';
    param.SubjectName.Type         = 'string';
    param.SubjectName.DefaultValue = 'Name';
    param.SubjectName.LowRange     = '';
    param.SubjectName.HighRange    = '';
    param.SubjectName.Comment      = 'subject alias';
    param.SubjectName.Value        = {settings.SubjectName};
    
    %%
    
    param.DataDirectory.Section      = 'Storage';
    param.DataDirectory.Type         = 'string';
    param.DataDirectory.DefaultValue = '..\data';
    param.DataDirectory.LowRange     = '';
    param.DataDirectory.HighRange    = '';
    param.DataDirectory.Comment      = 'path to top level data directory (directory)';
    param.DataDirectory.Value        = {[settings.relative, settings.DataDirectory]};
    
    %%
    
    param.SubjectRun.Section      = 'Storage';
    param.SubjectRun.Type         = 'string';
    param.SubjectRun.DefaultValue = '00';
    param.SubjectRun.LowRange     = '';
    param.SubjectRun.HighRange    = '';
    param.SubjectRun.Comment      = 'two-digit run number';
    param.SubjectRun.Value        = {settings.SubjectRun};
    
    %%
    
    param.SubjectSession.Section      = 'Storage';
    param.SubjectSession.Type         = 'string';
    param.SubjectSession.DefaultValue = '00';
    param.SubjectSession.LowRange     = '';
    param.SubjectSession.HighRange    = '';
    param.SubjectSession.Comment      = 'three-digit session number';
    param.SubjectSession.Value        = {settings.SubjectSession};
    
    
    %%
    
    parameter_lines = convert_bciprm( param );
    
    fid = fopen(temp_prm_filename,'w');
    
    for idx=1:length(parameter_lines)
        fprintf(fid,'%s',parameter_lines{idx});
        fprintf(fid,'\r\n');
    end
    
    fclose(fid);
    
end
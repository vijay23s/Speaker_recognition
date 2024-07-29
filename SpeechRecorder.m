% SPEECHRECORDER script records the various users audio feature into a database 

% Main file
speechRecord();

function recordNAnalyse(id)

    recDuration = 3;
    recObj = audiorecorder(8000,24,1);
    disp(["Begin speaking user ",num2str(id)])
    recordblocking(recObj, recDuration);
    disp("End of recording.")
    play(recObj);
    timeSamples = getaudiodata(recObj);
    
    % Frequency response
    timeSamples = timeSamples';
    %timeSamples = timeSamples.*hanning(length(timeSamples),"periodic")';
    sound(timeSamples);
    frequencyResponse=fft(timeSamples);
    m = max(abs(frequencyResponse));
    xpitch = find(abs(frequencyResponse)==m,1)
    feature.pitch = xpitch;
    feature.id = id;
    filename = "speechDatabase.mat";
    if isfile(filename)
        % File exists.
        load(filename,'feature');
        feature.pitch = [feature.pitch  xpitch];
        feature.id = [feature.id  id];
        save(filename,"feature");
    else
        % File does not exist.
        save(filename,"feature");
    end

    disp('Voice registered : ');
    fig(1)= figure('Visible', 'on', 'units','normalized','Position',...
            [0 0 0.75 0.75],'color','white');
        set(fig(1), 'Units','normalized', 'NumberTitle', 'off', 'Name',...
            ['Audio Signal of user ',num2str(id)], 'Toolbar', 'figure');
    subplot(211)
    plot(timeSamples);
    title('Time domain');
    subplot(212)
    plot(abs(frequencyResponse));
    title('Frequency domain');
end

function speechRecord()
    % SPEECHRECORD function reads the user information and records the user
    % audio
    % user
    %OUTPUTS:
    %userId: The recorded user Id and pitch feature
    prompt = {'Enter the User ID (Integer value):'};
    dlgtitle = 'Audio Recorder';
    fieldsize = [1 100];
    definput = {'1'};
    opts.Interpreter = 'tex';
    answer = inputdlg(prompt,dlgtitle,fieldsize,definput,opts);
    id = str2double(answer{1});
    recordNAnalyse(id);
    
end




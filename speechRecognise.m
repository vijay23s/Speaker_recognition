% SPEECHRECOGNISE script records the users audio  and matches it with the
% database
clear ;
% Load the saved database
load("speechDatabase.mat");

% Record the user voice to identify
timeSamples = recordVoice();
xpitch = extractFeatures(timeSamples);
predictedClass = knnAlgorithm(xpitch,feature,3);
disp(['Predicted user : ', num2str(predictedClass)]);


function timeSamples = recordVoice()
    recDuration = 3;
    recObj = audiorecorder(8000,24,1);
    disp("Begin speaking ")
    recordblocking(recObj, recDuration);
    disp("End of recording.")
    play(recObj);
    timeSamples = getaudiodata(recObj);
end

function xpitch = extractFeatures(timeSamples)
    % Frequency response
    timeSamples = timeSamples';
    timeSamples = timeSamples.*hanning(length(timeSamples),"periodic")';
    frequencyResponse=fft(timeSamples);
    m = max(abs(frequencyResponse));
    xpitch = find(abs(frequencyResponse)==m,1);
end

function predictedClass = knnAlgorithm(inPitch,ref,k)
    % k should be odd 
    refPitch = ref.pitch;
    refClass = ref.id;
    % find the distance between the current input with all the data base values
    l1distance = abs(refPitch - inPitch);
    % Sort the calculated distances in ascending order 
    [~,ind] = sort(l1distance,'ascend');
    % Select the top K closest points 
    kClasses = refClass(ind(1:k));
    predictedClass = mode(kClasses);

end

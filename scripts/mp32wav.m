codes = 1:81;
wdir = 'C:/Users/au571303/Documents/projects/groove_iEEG';
for c = 1:length(codes)
    mp3file = sprintf('%s/stimuli_mp3/%02d.mp3',wdir,codes(c));
    wavfile = sprintf('%s/stimuli/%02d.wav',wdir,codes(c));
    fprintf('converting %s to %s\n',mp3file,wavfile);
    [sound, Fs] = audioread(mp3file);
    audiowrite(wavfile,sound, Fs);
end
# groove_iEEG

Experimental paradigm to study wanting to move and pleasure feelings while people listen to short musical patterns. The experiment is currently optimized to perform intracranial EEG. Levels of syncopation and harmony complexity are manipulated. For research using a similar paradigm and same stimuli please see:

Matthews, T. E., Witek, M. A. G., Heggli, O. A., Penhune, V. B., & Vuust, P. (2019). The sensation of groove is affected by the interaction of rhythmic and harmonic complexity. PLOS ONE, 14(1), e0204539. https://doi.org/10.1371/journal.pone.0204539

Matthews, T. E., Witek, M. A. G., Lund, T., Vuust, P., & Penhune, V. B. (2020). The sensation of groove engages motor and reward networks. NeuroImage, 214, 116768. https://doi.org/10.1016/j.neuroimage.2020.116768

## Rationale for the experiment

In the experiment, we present musical patterns to the participants lasting 10s each. The patterns consist of a repeated chord played with different rhythms on top of a metrical background (hi-hat). The rhythms have three levels of complexity (defined as syncopation) and the chords have also three levels of complexity (defined as consonance/dissonance). In previous experiments, it has been shown that participants like more and want to move more to patterns with medium rhythm complexity (i.e. not too predictable and not too complex). This effect is enhanced when chords have meedium complexity (i.e. not too consonant and not too dissonant). These findings provide an empirical basis to the idea that there is a "sweet spot" in music appreciation and groove, where music with medium levels of complexity is preferred. The experimental paradigm here is intended to further investigate this with iEEG. 

## Experimental paradigm

There are two blocks in the experiment. In one of them, on each trial participants hear the musical pattern and then rate how much they wanted to move (1=not at all, 5= very much). In the other block, they hear the same excerpts but instead have to rate how much they liked it. Listeners have up to 7 seconds to provide ratings. Blocks are counterbalanced. Two practice trials are played at the start of each block. There are 36 trials per block. Each level of complexity for either rhythm or harmony has 12 trials per block and 24 in the whole experiment. For the interaction between rhythm and harmony, there are 8 trials per design cell (e.g. harmony-low/rhythm-medium) in the whole experiment. The paradigm takes around 20 minutes. There is a break in the middle of each block and a pause between blocks.

The experiment is implemented in psychopy and can be run with the script:

- [scripts/groove_harmony_iEEG.py](https://github.com/drqm/groove_iEEG/tree/master/scripts)

The stimuli are found under the "stimuli" directory. A list and metadata for the stimuli used in this experiment are found in "stimuli/stim_list.csv". This list is loaded and randomized in the psychopy script. Names and data for other stimuli not included in this experiment are also found in "stimuli/Stim_Names.xlsx". 

Test logfiles are saved under "logs".


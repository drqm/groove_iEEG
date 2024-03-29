# -*- coding: utf-8 -*-

"""
Groove Harmony MEG study

Script to present stimuli and record participants' ratings (David Quiroga-Martinez)
Currently optimized for MEG, but could be run for (i)EEG as well.

Experiment where participants (musicians and non-musicans) listen to a musical 
pattern then rate, in one block, how much they wanted to move or, in another 
block, how much they liked it using key presses (1-5). 

RUNS FROM PSYCHOPY STANDALONE APP. NOT TESTED OUTSIDE STANDALONE APP.
**********************
Stimuli (built by Tomas Matthews and Alexandre Selma Miralles)
***********************
Stimuli consist of musical patterns lasting 10 seconds that vary rhythm 
and harmonic complexity
    3 levels: Low, medium or high for both rhythm and harmonic complexity
    9 conditions: LL,LM,LH,ML,MM,MH,HL,HM,HH
    24 unique stims for each level of complexity (i.e. 24 medium rhythms, 24 high
    chords etc) so:
        24 unique stims in each block.
        48 total
    24 stims per design cell (e.g. medium harmony, high rhythm) and 12 per block.

**************************
Experimental design
*************************
-factorial design: 3(rhythmic complexity) X 3(harmonic complexity)
-2 counterbalanced blocks per person
-two presentions of each stim per block
-trials randomized for each subject
-one break in the 24th trial of each block.
"""

"""
'IMPORT'
"""
from psychopy import prefs
prefs.hardware['audioLib'] = ['PTB']
from psychopy import visual, core, sound, event, gui, logging#, parallel
import numpy as np
import random as rnd
import os
import csv
# Uncomment only if MEG in Aarhus:
from triggers import setParallelData # only if
setParallelData(0)

# set the project directory
os.chdir('C:/Users/au571303/Documents/projects/groove_iEEG')

# specify the frame rate of your screen
frate = 60 #48 #60 #120 #
prd = 1000/frate # inter frame interval in ms

# Load stimulus list and store in a dictionary
# change the stim file below to use different stimuli 
stim_file = open('stimuli/stim_list_MEG2021.csv',newline = '') 
stim_obj = csv.DictReader(stim_file,delimiter = ',')
blocks = {}
for row in stim_obj:
    blocks.setdefault(row['condition'],{})
    blocks[row['condition']].setdefault(row['block'],{})
    for column, value in row.items():  # consider .iteritems() for Python 2
        blocks[row['condition']][row['block']].setdefault(column, []).append(value)

# load sounds
sounds = {s: sound.Sound('stimuli/{:>02d}.wav'.format(int(s))) 
            for s in np.unique(blocks['pleasure']['main']['number'] + 
                                blocks['pleasure']['practice']['number'] +
                                blocks['wanting_to_move']['practice']['number'] +
                                blocks['wanting_to_move']['main']['number'])}

# randomize trial order
for b in blocks:
    for c in blocks[b]:
        blocks[b][c]['order'] = np.arange(len(blocks[b][c]['code']))
        rnd.shuffle(blocks[b][c]['order'])

#function and key to quit the experiment and save log file
def quit_and_save():
    win.close()
    if logfile:
       logfile.close()
    logging.flush()
    core.quit()
event.globalKeys.add(key='escape', func=quit_and_save, name='shutdown')

#response keys
resp_keys = ['1','2','3','4','5']

# Collect participant identity and options:
ID_box = gui.Dlg(title = 'Subject identity')
ID_box.addField('ID: ')
ID_box.addField('block order (Random order: Leave blank; "liking" first: 1; "wanting to move" first: 2): ')
ID_box.addField('practice? (YES: 1, higher or blank; NO: 0): ')
sub_id = ID_box.show()

# change counterbalance order
block_order = [0,1]
rnd.shuffle(block_order)

if sub_id[1] == '1':
   block_order = [0,1]
elif sub_id[1] == '2':
   block_order = [1,0]


# create switch to do practice block or not
practice_switch = 1
if sub_id[2] == '0':
    practice_switch = 0

# create display window and corresponding texts
txt_color = 'white'
win = visual.Window(fullscr=True, color='black')

# create all the text to be displayed
fixation = visual.TextStim(win, text='+', color=txt_color, height=0.2)
blocks['wanting_to_move']['instr'] =  visual.TextStim(win, 
                text = 'You will hear various short musical patterns.\n\n'
                'After each one, you will be asked to rate '
                'the degree to which the musical pattern MADE YOU WANT '
                ' TO MOVE, as follows:\n\n '
                'not at all  < 1    2    3    4    5 >  very much\n\n'
                'To answer, please use buttons 1 and 2 to select the '
                'desired rating and "spacebar" to confirm your choice.\n\n'
                'Press spacebar to continue.',
                color=txt_color, wrapWidth=1.8)

blocks['pleasure']['instr'] =  visual.TextStim(win, 
                text = 'You will hear various short musical patterns.\n\n'
                'After each pattern, you will be asked to rate '
                'HOW MUCH YOU LIKED the musical pattern, as follows:\n\n'
                'not at all  < 1    2    3    4    5 >  very much\n\n'
                'To answer, please use buttons 1 and 2 to select the '
                'desired rating and "spacebar" to confirm your choice.\n\n'
                'Press spacebar to continue.',
                color=txt_color, wrapWidth=1.8)

blocks['pleasure']['ratingtxt'] = pleasure_txt = visual.TextStim(win, 
                text = 'How much did you like it?\n\n'
                       'Please select the desired rating and press space '
                       'to confirm your answer\n\n\n\n\n\n\n\n',
                color=txt_color, wrapWidth=1.8)

blocks['wanting_to_move']['ratingtxt'] = visual.TextStim(win, 
                text = 'How much did you want to move?\n\n'
                       'Please select the desired rating and press space '
                       'to confirm your answer\n\n\n\n\n\n\n\n',
                color=txt_color, wrapWidth=1.8)

practice = visual.TextStim(win, 
                text = 'First, let us do some practice trials.\n\n'
                    'When ready, press spacebar to hear the first musical pattern.',
                color=txt_color, wrapWidth=1.8)

main_task = visual.TextStim(win,
                text = 'This is the end of the practice trials.\n\n'
                    'When ready, press spacebar to start the main task.',
                color=txt_color, wrapWidth=1.8)

break_txt = visual.TextStim(win,
                text = 'Now it is time for a little break.\n'
                        'Take as much time as you need.\n\n'
                        'We will continue in a moment.',
                color=txt_color, wrapWidth=1.8)

block_end_txt = visual.TextStim(win, 
                text = 'This is the end of the first block.\n\n'
                        'Now take a little break. We will continue in a moment.',
                color=txt_color, wrapWidth=1.8)

end_txt = visual.TextStim(win, 
                text = 'This is the end of the experiment.\n'
                        'Thanks for participating!',
                color=txt_color, wrapWidth=1.8)

trialtxt = visual.TextStim(win, text='',color=txt_color, height=0.1)

#set clocks
RT = core.Clock()
exp_time = core.Clock()

# set default log file
logging.setDefaultClock(exp_time)
log_fn_def = 'logs/' + sub_id[0] +  '_default.log'
lastLog = logging.LogFile(log_fn_def, level=logging.INFO, filemode='a')

# set custom log file
log_fn_cus = 'logs/' + sub_id[0] +  '_custom.csv'
logfile = open(log_fn_cus,'w')
logfile.write("subject,trialCode,code,number,name,rhythm,harmony,"
              "condition,block,startTime,response,rt,trigger\n")

# make function to loop over trials and present the stimuli
def block_run(s_dict, s_order, b_sounds, breaks=[]):
    """
    s_dict: dictionary containing the stimulus list and metadata, as loaded 
            from a csv file. Must contain the lists:

                'trial_code': code of the trial before randomization
                'code': experiment specific stimulus code
                'name': stimulus name
                'number': stimulus number corresponding to wav file
                'rhythm': rhythm complexity (low,medium,high)
                'harmony': harmony complexity (low, medium, high)
                'condition': 'pleasure' or 'wanting to move'
                'block': 'practice' or 'main'

            each list contains the above information for each trial in the
            experiment.

    s_order: randomized stimulus order. Must match the length of s_dict lists.
    b_sounds: dictionary with the loaded sounds. Keys must match elements in the
            "number" list in s_dict.
    breaks: list with numbers indicating the indices of trials where a pause is
            wanted.
    """
    for mtrial, midx in enumerate(s_order): # loop over trials
        ratingScale = [];
        ratingScale = visual.RatingScale(win, choices = [1,2,3,4,5], low=1, high  = 5,
                                markerStart  = 2,
                                leftKeys = '1', rightKeys = '2',acceptKeys = 'space',
                                maxTime = 7, textColor = txt_color, pos = (0.0,-0.2),
                                scale = 'not at all                        '
                                '                   very much',markerColor = 'blue',
                                size = 1.5,showAccept = False,noMouse = True)
        m = s_dict['number'][midx]
        trialtxt.setText('trial {} / {}'.format(mtrial + 1, len(s_order)))
        trialtxt.draw()
        #fixation.draw()
        win.flip()
        core.wait(1)
        fixation.draw()
        win.flip()
        core.wait(1)
        nextFlip = win.getFutureFlipTime(clock='ptb')
        startTime = win.getFutureFlipTime(clock=exp_time)
        trigger = int(s_dict['trigger'][midx])
        win.callOnFlip(setParallelData, int(trigger)) # only if MEG in Aarhus
        b_sounds[m].play(when = nextFlip)
        RT.reset()
        # we synchronize stimulus delivery with screen frames for time acc.
        for frs in range(int(np.round(50/prd))): # wait 0.05 seconds
            fixation.draw()
            win.flip()
        win.callOnFlip(setParallelData, 0) # only if MEG in Aarhus
        for frs in range(int(np.round(9950/prd))): # wait 9.95 seconds
            fixation.draw()
            win.flip()
        event.clearEvents(eventType='keyboard')
#        resp = None
#        while resp == None:
#            blocks[s_dict['condition'][midx]]['ratingtxt'].draw()
#            win.flip()
#            key = event.getKeys(timeStamped = RT, keyList = resp_keys)
#            #search for key presses. If none, set limit of 17 (10+7) seconds.
#            if len(key) > 0:
#                resp = key[0][0]
#                rt = key[0][1]
#            elif RT.getTime() > 17: #17 after trial onset
#                resp = 0
#                rt = RT.getTime()
        while ratingScale.noResponse:            
            blocks[s_dict['condition'][midx]]['ratingtxt'].draw()
            ratingScale.draw()
            win.flip()
        resp = ratingScale.getRating()
        rt = ratingScale.getRT

        lrow = '{},{},{},{},{},{},{},{},{},{},{},{},{}\n'
        lrow = lrow.format(sub_id[0],s_dict['trial_code'][midx],s_dict['code'][midx],
                            m,s_dict['name'][midx],s_dict['rhythm'][midx],
                            s_dict['harmony'][midx],s_dict['condition'][midx],
                            s_dict['block'][midx],startTime,resp,rt,trigger)
        logfile.write(lrow)
        if mtrial in breaks:
            break_txt.draw()
            win.flip()
            event.waitKeys(keyList = ['space'])

# Now run the experiment.
bnames = ['pleasure','wanting_to_move']
bnames = [bnames[b] for b in block_order] # counterbalance blocks
for bidx,b in enumerate(bnames):
    
    # present instructions
    blocks[b]['instr'].draw()
    win.flip()
    event.waitKeys()
    
    # run practice trials if requested
    if practice_switch == 1:
        practice.draw()
        win.flip()
        event.waitKeys()

        block_run(blocks[b]['practice'], blocks[b]['practice']['order'], sounds)

        main_task.draw()
        win.flip()
        event.waitKeys()

    #run main task
    block_run(blocks[b]['main'],blocks[b]['main']['order'], sounds, breaks = [27,55,83])
    
    if  (bidx + 1) < len(bnames):
        block_end_txt.draw()
        win.flip()
        event.waitKeys(keyList = ['space'])

end_txt.draw()
win.flip()
core.wait(2)


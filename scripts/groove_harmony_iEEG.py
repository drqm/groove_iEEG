from psychopy import prefs
prefs.hardware['audioLib'] = ['PTB']
from psychopy import visual, core, sound, event, gui, logging#, parallel
import numpy as np
import random as rnd
import os
import csv
# Uncomment only if MEG in Aarhus:
#from triggers import setParallelData # only if
#setParallelData(0)

# set the project directory
os.chdir('C:/Users/au571303/Documents/projects/groove_iEEG')

# specify the frame rate of your screen
frate = 60 #48 #60 #120 #
prd = 1000/frate # inter frame interval in ms

# Load stimulus list and store in a dictionary
stim_file = open('stimuli/stim_list.csv',newline = '')
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

#### function and key to quit the experiment and save log file
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
ID_box.addField('counterbalance (1 or 2): ')
ID_box.addField('practice? (YES: 1, higher or blank; NO: 0): ')
sub_id = ID_box.show()

# change counterbalance order
block_order = [0,1]
if sub_id[1] == '2':
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
                'To answer, please type 1, 2, 3, 4 or 5 on your keyboard.\n\n'
                'press a key to continue.',
                color=txt_color, wrapWidth=1.8)

blocks['pleasure']['instr'] =  visual.TextStim(win, 
                text = 'You will hear various short musical patterns.\n\n'
                'After each pattern, you will be asked to rate '
                'HOW MUCH YOU LIKED the musical pattern, as follows:\n\n'
                'not at all  < 1    2    3    4    5 >  very much\n\n'
                'To answer, please type 1, 2, 3, 4 or 5 on your keyboard.\n\n'
                'press a key to continue.',
                color=txt_color, wrapWidth=1.8)

blocks['pleasure']['ratingtxt'] = pleasure_txt = visual.TextStim(win, 
                text = 'How much did you like it?\n\n'
                    'not at all  < 1    2    3    4    5 >  very much',
                color=txt_color, wrapWidth=1.8)

blocks['wanting_to_move']['ratingtxt'] = visual.TextStim(win, 
                text = 'How much did you want to move?\n\n'
                   'not at all  < 1    2    3    4    5 >  very much',
                color=txt_color, wrapWidth=1.8)

practice = visual.TextStim(win, 
                text = 'First, let us do some practice trials.\n\n'
                    'When ready, press a key to hear the first musical pattern.',
                color=txt_color, wrapWidth=1.8)

main_task = visual.TextStim(win,
                text = 'This is the end of the practice trials.\n\n'
                    'When ready, press a key to start the main task.',
                color=txt_color, wrapWidth=1.8)

break_txt = visual.TextStim(win,
                text = 'Now it is time for a little break.\n'
                        'Take as much time as you need.\n\n'
                        'Press a key when ready to continue.',
                color=txt_color, wrapWidth=1.8)

block_end_txt = visual.TextStim(win, 
                text = 'This is the end of the first block.\n\n'
                        'Now take a little break and press a key when '
                        'ready to continue with the next task',
                color=txt_color, wrapWidth=1.8)

end_txt = visual.TextStim(win, 
                text = 'This is the end of the experiment.\n'
                        'Thanks for participating!',
                color=txt_color, wrapWidth=1.8)

trialtxt = visual.TextStim(win, text='',color=txt_color, height=0.2)

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
    for mtrial, midx in enumerate(s_order):
        m = s_dict['number'][midx]
        trialtxt.setText('trial {} / {}'.format(mtrial + 1, len(s_order)))
        trialtxt.draw()
        win.flip()
        core.wait(1)
        fixation.draw()
        win.flip()
        nextFlip = win.getFutureFlipTime(clock='ptb')
        startTime = win.getFutureFlipTime(clock=exp_time)
        trigger = int(s_dict['trigger'][midx])
        #win.callOnFlip(setParallelData, int(trigger)) # only if MEG in Aarhus
        win.callOnFlip(print, trigger)
        b_sounds[m].play(when = nextFlip)
        RT.reset()
        for frs in range(int(np.round(10000/prd))): # 10 seconds
            fixation.draw()
            win.flip()
        event.clearEvents(eventType='keyboard')
        resp = None
        while resp == None:
            blocks[s_dict['condition'][midx]]['ratingtxt'].draw()
            win.flip()
            key = event.getKeys(timeStamped = RT, keyList = resp_keys)
            #search for key presses. If none, set limit of 17 (10+7) seconds.
            if len(key) > 0:
                resp = key[0][0]
                rt = key[0][1]
            elif RT.getTime() > 17: #17 after trial onset
                resp = 0
                rt = RT.getTime()
        lrow = '{},{},{},{},{},{},{},{},{},{},{},{},{}\n'
        lrow = lrow.format(sub_id[0],s_dict['trial_code'][midx],s_dict['code'][midx],
                            m,s_dict['name'][midx],s_dict['rhythm'][midx],
                            s_dict['harmony'][midx],s_dict['condition'][midx],
                            s_dict['block'][midx],startTime,resp,rt,trigger)
        logfile.write(lrow)
        if mtrial in breaks:
            break_txt.draw()
            win.flip()
            event.waitKeys()

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
    block_run(blocks[b]['main'],blocks[b]['main']['order'], sounds, breaks = [17])
    
    if  (bidx + 1) < len(bnames):
        block_end_txt.draw()
        win.flip()
        event.waitKeys()

end_txt.draw()
win.flip()
core.wait(2)


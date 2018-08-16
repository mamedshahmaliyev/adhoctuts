'''Simulation of birth and death process with a M/M/1 queue which is a simple Markov model'''
import random
def getSystemParameters():
    return {'lambda': 5, 'mu': 10}
def nextStateSpace(currentState):
    '''All the possible transition rates from the currentState: dict(possibleState: rate)'''
    p = getSystemParameters()
    nextStateSpace = {currentState + 1: p['lambda']}
    if currentState > 0: nextStateSpace[currentState - 1] = p['mu']
    return nextStateSpace
def simulate(initialState = 0, simulationTime = 5000):
    currentState = initialState
    timePassed = 0
    reachedStates = {} #dict(state:sojournTime); sojournTime is total spent time for the state
    while timePassed < simulationTime:
        if currentState not in reachedStates: reachedStates[currentState] = 0
        nextStates = nextStateSpace(currentState)
        transRateSum = sum(nextStates.values())
        nextInterval = random.expovariate(transRateSum)
        r = random.uniform(0,1)
        prevRateSum = 0
        for state in nextStates:
            if r > prevRateSum / transRateSum and r < (prevRateSum + nextStates[state]) / transRateSum:   
                reachedStates[currentState]  += nextInterval
                currentState = state 
                break
            prevRateSum += nextStates[state] 
        timePassed += nextInterval
    totalTime = sum(reachedStates.values()) 
    return {state: reachedStates[state] / totalTime for state in reachedStates}
def exactStationaryDistribution(state):
    p = getSystemParameters()
    systemLoad = p['lambda'] / p['mu']
    return (1 - systemLoad) * systemLoad ** state
#----------------------- Run the experiment ----------------------------#
sd = simulate(0, 20000)
mse = 0 # mean squared error
for state in sd:
    e = exactStationaryDistribution(state) # exact distribution
    mse += (sd[state] - e)**2
    print('[ State -',state,'] [ Simulation -', "{:.7f}".format(sd[state]),'] [ Exact -',"{:.7f}".format(e),' ]')

print ("Mean Squared Error (MSE):", "{:.7f}".format(mse / len(sd)))

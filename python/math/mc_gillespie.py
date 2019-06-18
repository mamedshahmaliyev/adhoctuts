'''Stochastic simulation of birth and death process with a Markov M/M/1 queue using Gillespie Direct method'''
####### urls: 
####### https://adhoctuts.com/find-stationary-distribution-of-markov-chain-using-stochastic-simulation-gillespies-in-python/
####### https://youtu.be/3DRdoqhNFrk
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
    nextStatesAll = {} #dict(state:nextStates); 
    while timePassed < simulationTime:
        if currentState not in reachedStates: reachedStates[currentState] = 0
        if currentState not in nextStatesAll: nextStatesAll[currentState] = nextStateSpace(currentState)         
        nextStates = nextStatesAll[currentState]
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
sd = simulate(0, 10000)
mse = 0 # mean squared error
for state in sd:
    e = exactStationaryDistribution(state) # exact distribution
    mse += (sd[state] - e)**2
    print('[ State -',state,'] [ Simulation -', "{:.7f}".format(sd[state]),'] [ Exact -',"{:.7f}".format(e),' ]')

print ("Mean Squared Error (MSE):", "{:.7f}".format(mse / len(sd)))

#----------------------- Visualize the accuracy based on Simulation Time ----------------------------#
serie = {'x':[],'y':[]}
for t in [500,1000,2000,3000,5000,7000,10000,15000,20000]:
    mse = 0
    sd = simulate(0, t)
    for state in sd:
        e = exactStationaryDistribution(state) # exact distribution
        mse += (sd[state] - e)**2
    serie['x'].append(t)
    serie['y'].append(mse / len(sd))

import matplotlib.pyplot as plt
fig = plt.figure(1,figsize=(7.5, 3.9), dpi=80)
plt.plot(serie['x'], serie['y'], label='MSE Dependence on Simulation Time')
ax = plt.gca();
ax.set_xlabel('Simulation Time')
ax.set_ylabel('MSE')
plt.grid(color='#A9A9A9', linestyle='--', linewidth=0.5)
plt.show()
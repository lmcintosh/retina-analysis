from scipy import *
from random import *
from numpy import *
from math import *

N = 10000
process = zeros(N)
sigma = 1.0

for i in range(1,N):
    process[i] = process[i-1] + sigma*gauss(0,1)

print N, power(sigma,2), N*power(sigma,2)

trueVariance = N*power(sigma,2)
actualVariance = std(process)
actualVariance = int(actualVariance)
actualVariance = power(actualVariance,2)

print trueVariance, actualVariance

import matplotlib.pyplot as plt
from scipy.stats import norm

import math
import numpy as np
import simulationRunner
import itertools

fig, ax = plt.subplots(1, 1)
# x = np.linspace(-1, 1, 1000)
# ax.plot(x, norm.pdf(x), label='norm pdf')
# print(norm.cdf(4))

def diffusion_percentage(length, diffusion_coefficient, time):
    L = length
    D = diffusion_coefficient
    t = time
    a = math.sqrt(D*t)
    return 1/L * (-2*math.pi*math.pow(a,2)*L*math.erf(L/(2*a))+2*math.pi*math.pow(a,2)*L-4*math.sqrt(math.pi)*
                  math.pow(a,3) * math.exp(-1*math.pow(L,2)/(4*math.pow(a,2))) - (-4*math.sqrt(math.pi)*math.pow(a,3)))

def diffusion_prob_dist(diffusion_coeff, time, x):
    D = diffusion_coeff
    t = time
    return math.sqrt(4*math.pi*D*t)*math.exp(-1*math.pow(x,2)/(4*D*t))

def get_random_walk_paths_that_hit_point(point, path_len):
    fx = lambda x: x*2 - 1
    walks_that_hit = 0
    for seq in itertools.product([0,1], repeat=path_len):
        steps = map(fx,seq)
        current_position = 0
        if point == 0:
            walks_that_hit += 1
        else:
            for step in steps:
                current_position += step
                if current_position == point:
                    walks_that_hit += 1
                    break
    return walks_that_hit

def closer_form_walk_paths_that_hit_point(point, path_len):
    if(point > path_len):
        return 0
    if(point == 0):
        return math.pow(2, path_len)
    return closer_form_walk_paths_that_hit_point(point-1, path_len-1) + closer_form_walk_paths_that_hit_point(point+1, path_len-1)
   # paths = 0
   #
   #  for n in range(0, iters):
   #      paths += math.pow(point,n) * math.pow(2, path_len-point-2*n)
   #  return paths

def closer_form_walk_paths_that_hit_point2(point, path_len):
    if(point > path_len):
        return 0
    if(point == 0):
        return math.pow(2, path_len)
    return math.pow(2,path_len-point) + closer_form_walk_paths_that_hit_point(point+1, path_len-1)


closer_form_walk_paths_that_hit_point(1, 5)

for ts in range(0,8):
    t=ts*2
    # print('*****')
    for m in range(0,int(t/2)):
        #m=ms*2
        print('h(' + str(m) + ',' + str(t) + '): ' + str(get_random_walk_paths_that_hit_point(m,t)) + ' est: ' +
            str(closer_form_walk_paths_that_hit_point2(m, t)))









#
#
#
#
# x = np.linspace(-.0005, .0005, 100)
# runner = simulationRunner.SimulationRunner()
# fx = lambda x: diffusion_percentage(x, runner.diffusion_coeff(), runner.total_time)
# fx2 = lambda x:diffusion_prob_dist(runner.diffusion_coeff(), runner.total_time, x)
# # ys = np.array(list(map(fx, x)))
# ys = np.array(list(map(fx2, x)))
#
# ax.plot(x, ys)
#
# plt.show()
import scipy.constants
import math
import numpy as np
from itertools import repeat
from matplotlib import collections
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d.axes3d as p3
import mpl_toolkits.mplot3d.art3d as art3d
import logging

class SimulationRunner:
    def __init__(self, radius, density,
                 total_time=24*60*60,
                 steps = 10000,
                 x_max =.007,
                 y_max = .001,
                 z_max = .002):
        self.total_time = total_time #time in seconds #seconds
        self.steps = steps
        self.x_max = x_max # x size in m
        self.y_max = y_max # y size in m
        self.z_max = z_max # z size in m
        self.temp = 298.15 #temp in K
        self.medium_viscosity = .00101 #1.01 #cp 
        self.radius = radius #radius in m
        self.g = 9.80665 # acceleration in m/s^2
        self.medium_density = 1000 #density in kg/m^3
        self.density = density #density in kg/m^3
        self.recalculate_invariants()

    def recalculate_invariants(self):
        self.sedimentation_velocity = self.calculate_stokes_sedimentation_velocity()
        self.diffusion_coeff = self.calculate_diffusion_coeff()
        self.step_distance = self.calculate_step_distance()
        self.volume = 4/3 * math.pi * pow(self.radius, 3)
        self.mass = self.volume * self.density

    # some publications report this equation as diameter, but it should be radius
    def calculate_stokes_sedimentation_velocity(self):
        r = self.radius  # THIS SHOULD BE RADIUS
        return 2*self.g*(self.density-self.medium_density)*r*r / (9 * self.medium_viscosity)

    def calculate_newtonian_sedimentation_velocity(self):
        return 2.46 * math.sqrt( (self.density- self.medium_density) * self.g * self.radius / self.medium_density)

    def calculate_max_sedimentation_distance(self):
        return self.sedimentation_velocity * self.total_time

    def calculate_diffusion_coeff(self):
        kB = scipy.constants.physical_constants['Boltzmann constant'][0]
        return kB * self.temp / (6 * math.pi * self.medium_viscosity * self.radius)

    def calculate_particle_reynolds_number_max(self):
        return self.medium_density * self.calculate_stokes_sedimentation_velocity() * self.radius * 2 / self.medium_viscosity

    def total_path_distance(self):
        squared_path = 6 * self.diffusion_coeff * self.total_time
        total_distance = squared_path ** 0.5
        return total_distance

    def calculate_step_distance(self):
        #because we are in 3D, we desire the diagonal of the step cube to have distance = path distance/steps
        #this would change in 2D or 1D
        return self.total_path_distance() / self.steps / (3 ** 0.5)

    def get_random_step_vector(self):
        return np.random.randint(2, size=self.steps) * 2 - 1

    def get_random_point(self):
        random_pt_fun = lambda x: x * np.random.random_sample()
        point = tuple(map(random_pt_fun, (self.x_max, self.y_max, self.z_max)))
        return point

    def take_step_in_one_direction(self, max_position, position, step):
        position = position + (step * self.step_distance)
        position = max(0.0, position)
        position = min(max_position, position)
        return position

    def apply_single_step(self, position, step):
        x_new = self.take_step_in_one_direction(self.x_max, position[0], step[0])
        y_new = self.take_step_in_one_direction(self.y_max, position[1], step[1])
        z_new = self.take_step_in_one_direction(self.z_max, position[2], step[2])
        return x_new, y_new, z_new

    def get_random_position_vector_from_random_start(self):
        x_steps, y_steps, z_steps = map(SimulationRunner.get_random_step_vector, repeat(self, 3))
        xyz_steps = zip(x_steps, y_steps, z_steps)
        current_position = self.get_random_point()
        position_vector = [current_position]
        for step in xyz_steps:
            current_position = self.apply_single_step(current_position, step)
            position_vector.append(current_position)
        return position_vector

    def plot_sediment_velocity(self):
        a = (self.density -self.medium_density)*self.g*4/3*math.pi*pow(self.radius, 3)/self.mass
        b = 6* math.pi*self.medium_viscosity*self.radius/self.mass
        t_pts = np.linspace(0, 1, 1000)
        def vt(t):
            c = math.exp(math.log(a) - t*b)
            return (a - c)/b
            # return self.sedimentation_velocity - self.sedimentation_velocity/math.exp(t*b)
        plt.figure()
        vels = list(map(vt, t_pts))
        plt.plot(t_pts, vels)

        plt.show()

    def visualize_single_run(self, scale_to_container_size=True):
        position_vector = self.get_random_position_vector_from_random_start()
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        coords = list(zip(*position_vector))
        lines = convert_to_colormap_lines(plt.get_cmap('jet'), position_vector)

        ax.add_collection(lines)
        (xmin, xmax) = min(coords[0]), max(coords[0])
        (ymin, ymax) = min(coords[1]), max(coords[1])
        (zmin, zmax) = min(coords[2]), max(coords[2])
        max_range = max(xmax-xmin, ymax-ymin, zmax-zmin)

        xrange = (xmin, xmin+max_range)
        yrange = (ymin, ymin+max_range)
        zrange = (zmin, zmin+max_range)
        ax.set_xlim(*xrange)
        ax.set_ylim(*yrange)
        ax.set_zlim(*zrange)
        ax.set_xticks(np.linspace(*xrange, num=10))
        ax.set_yticks(np.linspace(*yrange, num=10))
        ax.set_zticks(np.linspace(*zrange, num=10))
        ax.set_xticklabels(get_tick_labels(ax.get_xticks(), xrange))
        ax.set_yticklabels(get_tick_labels(ax.get_yticks(), yrange))
        ax.set_zticklabels(get_tick_labels(ax.get_zticks(), zrange))

        #
        # dist_str = distance_string(max_range)
        # xticks = ax.get_xticks()
        # labels = ['' for tick in ax.get_xticks()]
        # labels[len()]
        # #0 labels = ['' for label in plt.]
        # ax.set_yticks(yrange)
        # ax.set_yticklabels(['0', dist_str])
        # plt.xticks(xrange, ['0', dist_str])
        # #plt.yticks(yrange, ['0', dist_str])
        # ax.set_zticks(zrange)
        # ax.set_zticklabels(['0', dist_str])


        # ax.plot(coords[0], coords[1], coords[2])
        # ax.axis('auto')
        total_pts = len(coords)

        if scale_to_container_size:
            sed_xs = [coords[0][total_pts], coords[0][total_pts]]
            sed_ys = [coords[1][total_pts], coords[1][total_pts]]
            sed_zs = [coords[2][total_pts], max(0, coords[2][total_pts] - self.calculate_max_sedimentation_distance())]
            pts =[]
            diff = sed_zs[0] - sed_zs[1]
            for i in np.linspace(0, 1, 1000):
                z_pt = sed_zs[0] - diff*i
                pts.append((sed_xs[0], sed_ys[0], z_pt))

            lines = convert_to_colormap_lines(plt.get_cmap('jet'), pts)
            ax.add_collection(lines)
            #ax.plot(sed_xs, sed_ys, sed_zs, 'blue')
            (xrange, yrange, zrange) = ((0, self.x_max), (0, self.y_max), (0, self.z_max))

            ax.set_xlim(*xrange)
            ax.set_ylim(*yrange)
            ax.set_zlim(*zrange)
            ax.set_xticks(np.linspace(*xrange, num=10))
            ax.set_yticks(np.linspace(*yrange, num=10))
            ax.set_zticks(np.linspace(*zrange, num=10))
            ax.set_xticklabels(get_tick_labels(ax.get_xticks(), xrange))
            ax.set_yticklabels(get_tick_labels(ax.get_yticks(), yrange))
            ax.set_zticklabels(get_tick_labels(ax.get_zticks(), zrange))
            #
            # plt.xticks([0, self.x_max], ['0', distance_string(self.x_max)])
            # plt.yticks([0, self.y_max], ['0', distance_string(self.y_max)])
            # ax.set_zticks([0, self.z_max])
            # ax.set_zticklabels(['0', distance_string(self.z_max)])

        title = str.format('Radius: {0}, Density: ${1} kg/m^3$', distance_string(self.radius), self.density)
        plt.title(title)
        print(title)
        print('Total sedimentation movement: {0}'.format(distance_string(self.calculate_max_sedimentation_distance())))
        print('Total diffusion movement: {0}'.format(distance_string(self.total_path_distance())))
        print(str.format('stokes sed vel: {0}', self.calculate_stokes_sedimentation_velocity()))
        print(str.format('newton sed vel: {0}', self.calculate_newtonian_sedimentation_velocity()))
        print(str.format('max reynolds number: {0}', self.calculate_particle_reynolds_number_max()))

        plt.draw()

def convert_to_colormap_lines(cmap, pts):
    line_list = []
    init_pt = pts[0]
    colors = [cmap(x) for x in np.linspace(0, 1, len(pts))]

    for pt in pts:
        line_list.append([init_pt, pt])
        init_pt = pt

    #NEED THESE FOR COLORING
    lines = art3d.Line3DCollection(line_list, colors=colors)
    return lines


def distance_string(distance_in_meters):

    if 1e-2 <= distance_in_meters <= 10e-2:
        (conversion, unit_name) = (1e-2, 'cm')
    elif 1e-3 <= distance_in_meters <= 1e-2:
        (conversion, unit_name) = (1e-3, 'mm')
    elif 1e-6 <= distance_in_meters <= 1e-3:
        (conversion, unit_name) = (1e-6, '\mu m') #um
    elif 1e-9 <= distance_in_meters <= 1e-6:
        (conversion, unit_name) = (1e-9, 'nm')
    else:
        raise ValueError

    return '${:.0f} {}$'.format(distance_in_meters/conversion, unit_name)

def get_tick_labels(ticks, axis_range, offset=0):
    labels = ['' for tick in ticks]
    halfway_tick = round(len(ticks)/2) - offset
    labels[halfway_tick] = distance_string(axis_range[1]-axis_range[0])
    return labels

def compare_diffusion_and_sedimentation():
    runner = SimulationRunner(density=7000, radius=100e-9, steps=10000)
    # runner.recalculate_invariants()
    runner.visualize_single_run()

    runner2 = SimulationRunner(density=7000, radius=100e-11, steps=10000)
    runner2.visualize_single_run()

    runner3 = SimulationRunner(density=7000, radius=100e-13, steps=10000)
    runner3.visualize_single_run()


if __name__ == "__main__":
    runner = SimulationRunner(density=1060, radius=200e-9, steps=10000)
    # runner.recalculate_invariants()
    # runner.plot_sediment_velocity()
    runner.visualize_single_run(True)
    runner.visualize_single_run(False)

    runner2 = SimulationRunner(density=1650, radius=250e-9, steps=10000)
    # runner2.plot_sediment_velocity()
    runner2.visualize_single_run(True)
    runner2.visualize_single_run(False)

    plt.show()
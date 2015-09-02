import unittest
import scipy.constants
from unittest.mock import MagicMock
from scipy.spatial import distance
from simulationRunner import SimulationRunner


class SimulationRunnerTestCase(unittest.TestCase):
    def setUp(self):
        self.runner = SimulationRunner(radius = 100e-7, density = 1)
        self.runner.x_max = .007
        self.runner.y_max = .008
        self.runner.z_max = .008

    def tearDown(self):
        pass

    def _get_expected_diff_coeff(self):
        return 3.43e-12
        # return 1.3806488E-23*self.runner.temp/(6*3.141592653*self.runner.viscosity*self.runner.radius)

    def test_sedimentation_velocity(self):
        self.runner.radius = (77.7e-9)/2
        self.runner.density = 7.01e3
        self.runner.recalculate_invariants()
        self.assertAlmostEqual(self.runner.sedimentation_velocity, (7.82e-8)/4, 9)

    def test_diffusion_coeff(self):
        self.runner.medium_viscosity = .00101
        self.runner.temp = 298.15
        self.runner.radius = 63.65e-9
        self.runner.recalculate_invariants()
        self.assertAlmostEqual(self._get_expected_diff_coeff(), self.runner.diffusion_coeff,13)

    def test_total_path_distance(self):
        self.runner.diffusion_coeff = 1 #MagicMock(return_value=1)
        self.runner.total_time = 1
        expected_total_path = (6 ** 0.5)
        self.assertAlmostEqual(expected_total_path, self.runner.total_path_distance(), 10)

    def test_step_distance(self):
        self.runner.total_path_distance = MagicMock(return_value=1)
        self.runner.steps = 1
        self.assertAlmostEqual(1 / (3 ** 0.5), self.runner.calculate_step_distance())

    def test_get_random_step_vector_is_good(self):
        self.runner.steps = 1000
        for i in range(50):
            step_vector = self.runner.get_random_step_vector()
            non_steps = [x for x in step_vector if abs(x) != 1]
            self.assertListEqual([], non_steps)

    #this will fail, rarely
    def test_get_random_step_vector_close_to_uniform_distribution(self):
        self.runner.steps = 10000
        for i in range(50):
            total = 0
            step_vector = self.runner.get_random_step_vector()
            for step in step_vector:
                total += step
            self.assertLessEqual(abs(total), 300)

    def test_get_random_point_produces_different_points(self):
        for i in range(100):
            point1 = self.runner.get_random_point()
            point2 = self.runner.get_random_point()
            self.assertNotAlmostEqual(point1[0], point2[0])
            self.assertNotAlmostEqual(point1[1], point2[1])
            self.assertNotAlmostEqual(point1[2], point2[2])

    def test_apply_single_step_one_step_distance_away(self):
        start_pt = (self.runner.x_max/2, self.runner.y_max/2, self.runner.z_max/2)
        new_pt = self.runner.apply_single_step(start_pt, (1, 1, 1))
        dist = distance.euclidean(start_pt, new_pt)
        self.assertAlmostEqual(self.runner.total_path_distance()/self.runner.steps, dist, 10)

    def test_apply_single_step_stays_in_bounds(self):
        def minus_epsilon(x): return x - self.runner.step_distance/10;
        def plus_epsilon(x): return x + self.runner.step_distance/10;
        far_point = tuple(map(minus_epsilon, (self.runner.x_max, self.runner.y_max, self.runner.z_max)))
        near_point = tuple(map(plus_epsilon, (0,0,0)))

        far_after_step = self.runner.apply_single_step(far_point, (1, 1, 1))
        near_after_step = self.runner.apply_single_step(near_point, (-1, -1, -1))

        self.assertEqual(far_after_step[0], self.runner.x_max)
        self.assertEqual(far_after_step[1], self.runner.y_max)
        self.assertEqual(far_after_step[2], self.runner.z_max)

        self.assertEqual(near_after_step[0], 0)
        self.assertEqual(near_after_step[1], 0)
        self.assertEqual(near_after_step[2], 0)



# def test_get_random_position_vector_from_random_start_moves_in_all_directions(self):
#     position_vector = self.runner.get_random_position_vector_from_random_start()


if __name__ == "__main__":
    unittest.main()

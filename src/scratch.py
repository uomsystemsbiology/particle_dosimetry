import math

capsule_weight = 2.57e-15 # verify that this is polymer weight, ie, capsule weight w/o water
polymer_density = 1.18 #allegedly g/mL

total_volume = (4/3 * math.pi * pow(120e-7, 3))
polymer_volume = capsule_weight / polymer_density
water_volume = total_volume - polymer_volume

volume_frac_water = water_volume/ total_volume
water_dens = 1

frac_dens_pmash = water_dens * volume_frac_water + polymer_density * (1-volume_frac_water)
alternative_dens_pmash = (2.57e-15 + 5.05e-15) / total_volume

template_volume = (4/3 * math.pi * pow(125e-7, 3))
template_weight = 1.185e-14
dens_scms = (capsule_weight + template_weight)  / (template_volume)

capsule_diameter = 240e-9

#particle_reynolds_number = medium_density +




print(frac_dens_pmash)
print(alternative_dens_pmash)
print(dens_scms)

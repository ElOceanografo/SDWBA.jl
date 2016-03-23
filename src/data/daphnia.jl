
major =  1.1E-3 # diameter in m
minor =  0.7E-3 # diameter in m
nsegments = 15
g = 1.04 * ones(nsegments)
h = 1.04 * ones(nsegments)

x = linspace(0, 0.001, nsegments)
a = major / 2*cos(abs(x - mean(x)) / (minor / 2) * pi / 2)
r = [x zeros(nsegments) zeros(nsegments)]'

"""
Generic Daphnia shape used in Warren et al. 2016, 'Measuring the distribution, 
abundance, and biovolume of zooplankton in an oligotrophic freshwater lake 
with a 710 kHz scientific echosounder.' Limnology and Oceanography: Methods
"""
daphnia = Scatterer(r, a, g, h)


#--- for loop ends here

# # calanoid

# major_mn =  0.7E-3; # diameter in m
# minor_mn =  0.2E-3;  # diameter in m

# major_sd = 0.2E-3;
# minor_sd = 0.1E-3;

#---for loop begins here ---

# major_dim = randn()*major_sd + major_mn;
# minor_dim = randn()*minor_sd + minor_mn;

# a = major_dim/2*[.01,.1,.3,.4,.5,.6 ,.7,.8,.9,1, .9, .7, .5, .2,.01];
#--- for loop ends here
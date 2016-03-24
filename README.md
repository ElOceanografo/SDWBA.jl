# SDWBA.jl

[![Build Status](https://travis-ci.org/ElOceanografo/SDWBA.jl.svg?branch=master)](https://travis-ci.org/ElOceanografo/SDWBA.jl)

This Julia package implements the (stochastic) distorted-wave Born approximation for 
acoustic scattering from fluid-like objects shaped like distorted cylinders.  These
models are useful for modeling the acoustic target strengths (TS) of zooplankton, which
are needed to convert sonar echoes to estimates of biomass.

To install and load it, simply run

```julia
Pkg.clone("https://github.com/ElOceanografo/SDWBA.jl.git")
using SDWBA
```

Several models of common animals are included.  To calculate the TS of an Antarctic krill,
*Euphausia superba*:

```julia
krill = Models.krill_mcgeehee
freq = 120e3	# acoustic frequency (kHz)
c = 1456		# sound speed in water (m/s)
target_strength(krill, freq, c)
# -66.9
``` 

Functions are included to tilt/rotate scatterers, as well as to resize them:

```julia
krill2 = rescale(krill, 0.8) # shrink the krill by 20%
krill2 = rotate(krill2, tilt = 45) # tilt it 45 degrees nose-up
target_strength(krill2, freq, c)
# -100.09
```

The full documentation and function reference can be found at [http://sdwbajl.readthedocs.org/en/latest/](http://sdwbajl.readthedocs.org/en/latest/).
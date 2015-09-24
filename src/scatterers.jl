"""
This submodule contains ready-to-use Scatterer models of zooplankton.
"""
module scatterers

using SDWBA


export krill_mcgeehee
export krill_conti

DATA_DIR = joinpath(dirname(@__FILE__), "data/")


"""
Krill shape from Conti and Demer, 2006, 'Improved parameterization of the SDWBA for 
estimating krill target strength.' ICES Journal of Marine Science 63(5), 928-935.
"""
krill_mcgeehee = from_csv(joinpath(DATA_DIR, "generic_krill_McGeehee1998.csv"), f0=200e3)

"""
Krill shape from McGeehee et al. 1998, 'Effects of orientation on acoustic scattering
from Antarctic krill at 120 kHz.' Deep-Sea Research II 45(7), 1273-1294.
"""
krill_conti = from_csv(joinpath(DATA_DIR, "generic_krill_Conti2006.csv"), f0=200e3)


end

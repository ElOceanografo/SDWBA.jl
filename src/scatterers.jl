
module scatterers

using SDWBA

using Docile

export krill_mcgeehee
export krill_conti

DATA_DIR = Pkg.dir() * "/SDWBA/src/data/"


@doc """
Krill shape from Conti and Demer, 2006, 'Improved parameterization of the SDWBA for 
estimating krill target strength.' ICES Journal of Marine Science 63(5), 928-935.
""" ->
krill_mcgeehee = from_csv(DATA_DIR * "generic_krill_McGeehee1998.csv", f0=200e3)

@doc """
Krill shape from McGeehee et al. 1998, 'Effects of orientation on acoustic scattering
from Antarctic krill at 120 kHz.' Deep-Sea Research II 45(7), 1273-1294.
""" ->
krill_conti = from_csv(DATA_DIR * "generic_krill_Conti2006.csv", f0=200e3)

using Lexicon

end

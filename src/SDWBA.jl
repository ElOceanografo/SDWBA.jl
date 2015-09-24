module SDWBA

using Docile
@docstrings

export Scatterer,
	rescale,
	rotate,
	form_function,
	backscatter_xsection,
	target_strength,
	tilt_spectrum,
	freq_spectrum,
	from_csv,
	to_csv,
	scatterers

import Base: copy, length

include("types.jl")
include("scatterers.jl")

end # module

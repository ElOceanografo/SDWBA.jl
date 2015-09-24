module SDWBA


export Scatterer,
	rescale,
	rotate,
	length,
	form_function,
	backscatter_xsection,
	target_strength,
	tilt_spectrum,
	freq_spectrum,
	from_csv,
	to_csv,
	Models

import Base: copy, length

include("Scatterer.jl")
include("Models.jl")

end # module

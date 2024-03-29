module SDWBA

using QuadGK
using LinearAlgebra
using SpecialFunctions
using BSplineKit
using DelimitedFiles

export AbstractScatterer,
	Scatterer,
	DeformedCylinder,
	rescale,
	resize,
	interpolate,
	rotate,
	bodylength,
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

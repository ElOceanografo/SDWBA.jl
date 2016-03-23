import Base: show


"""
Construct a data structure describing a fluid-like weak scatterer with a deformed
cylindrical shape.  This shape is approximated by a series of `N` discrete segments,
described by the [x, y, z] coordinates, radii, and material properties at their
endpoints.

#### Parameters
- `r` : 3x`N` matrix describing the scatterer's centerline.  Each column is the 
location in 3-D space of one of the centerline points (these should be arranged 
in the proper order).
- `a` : Vector of radii, length `N`.
- `h`, `g` : Vectors of sound speed and density contrasts (i.e., the ratio
of sound speed or density inside the scatter to the same quantity in the
surrounding medium).
- `f0` : Default frequency for the scatterer.  Used when rescaling to ensure
the digitized shape has enough segments relative to the acoustic wavelength.

"""
:Scatterer
type Scatterer{T}
	r::Array{T, 2}
	a::Array{T, 1}
	h::Array{T, 1}
	g::Array{T, 1}
end

function Scatterer(r::Array{Real, 2}, a::Vector{Real}, h::Vector{Real},
	g::Vector{Real})
	return Scatterer(promote(r, a, h, g)...)	
end

# function Scatterer(r::Array{Real, 2}, a::Vector{Real}, h::Real, g::Real, f0::Real)
# 	g1 = g * ones(a)
# 	h1 = h * ones(a)
# 	return Scatterer(promote(r, a, h1, g1, f0)...)	
# end

function show(io::IO, s::Scatterer)
	println("$(typeof(s)) with $(length(s.a)) segments")
	print("Length $(signif(length(s), 3))")
end

copy(s::Scatterer) = Scatterer(s.r, s.a, s.h, s.g)

function rescale(s::Scatterer; scale=1.0, radius=1.0, x=1.0, y=1.0, z=1.0)
	s = copy(s)
	M = diagm([x, y, z]) * scale
	s.r = M * s.r
	s.a = s.a * scale * radius
	return s
end

rescale(s::Scatterer, scale) = rescale(s, scale=scale)

"""
Return the length of the scatterer (cartesian distance from one end to the other).
""" 
length(s::Scatterer) = norm(s.r[:, 1] - s.r[:, end])

"""
Rotate the scatterer in space, returning a rotated copy.

#### Parameters
- `roll` : Angle to roll the scatterer, in degrees. Defaults to 0.
- `tilt` : Angle to tilt the scatterer, in degrees. Defaults to 0.
- `yaw` : Angle to yaw the scatterer, in degrees. Defaults to 0.

#### Returns
A Scatterer with the same shape and properties, but a new orientation.

The roll, tilt, and yaw refer to rotations around the x, y, and z axes,
respectively. They are applied in that order.
"""
function rotate(s::Scatterer; roll=0.0, tilt=0.0, yaw=0.0)
	roll, tilt, yaw = deg2rad([roll, tilt, yaw])
	Rx = [1 0 0; 0 cos(roll) -sin(roll); 0 sin(roll) cos(roll)]
	Ry = [cos(tilt) 0 sin(tilt); 0 1 0; -sin(tilt) 0 cos(tilt)]
	Rz = [cos(yaw) -sin(yaw) 0; sin(yaw) cos(yaw) 0; 0 0 1]
	R = Rz * Ry * Rx
	s1 = copy(s)
	s1.r = R * s1.r
	return s1
end

function DWBAintegrand(s, rr, aa, gg, hh, k)
	r = vec(rr[:, 1] + s * diff(rr, 2))
	a = aa[1] + s * diff(aa)[1]
	g = gg[1] + s * diff(gg)[1]
	h = hh[1] + s * diff(hh)[1]
	alphatilt = acos(dot(k, r) / (norm(k) * norm(r)))
	betatilt = abs(alphatilt - pi/2.0)
	gammagamma = 1.0 / (g * h^2.0) + 1 / g - 2.0
	if abs(abs(betatilt) - pi/2.0) < 1e-10
		bessy = norm(k) * a / h
	else
		bessy = besselj1(2.0*norm(k) * a / h * cos(betatilt)) / cos(betatilt)
	end
	return (norm(k) / 4.0 * gammagamma * exp(2.0 * im * dot(k,r) / h) * a * 
		bessy * norm(diff(rr, 2)))
end

scattering_function_param_docs = """
#### Parameters

- `s` : Scatterer object.
- `k` : Acoustic wavenumber vector.  Its magnitude is 2 * pi * f / c (where 
f is the frequency and c is the sound speed) and it points in
the direction of propagation.  For downward-propagating sound waves, 
it is [0, 0, -2pi * f / c].
- `phase_sd` : Standard deviation of the phase variability for each segment (in radians).
Defaults to 0.0, that is, an ordinary deterministic DWBA.  If > 0, the
return value will be stochastic (i.e., the SDWBA).
"""

"""
Calculate the complex-valued form function of a scatterer using the (S)DWBA.

$scattering_function_param_docs 
"""
:form_function
function form_function(s::Scatterer, k::Vector, phase_sd=0.0)
	fbs = 0 + 0im
	m, n = size(s.r)

	for i in 1:(n-1)
		f(x) = DWBAintegrand(x, s.r[:, i:i+1], s.a[i:i+1],
			s.g[i:i+1], s.h[i:i+1], k)
		fbs += quadgk(f, 0.0, 1.0)[1] * exp(im * randn() * phase_sd)
	end
	return fbs
end


"""
Calculate the backscattering cross-section (sigma_bs) of a scatterer using the (S)DWBA.
This is the absolute square of the form function.

$scattering_function_param_docs 
"""
function backscatter_xsection{T}(s::Scatterer{T}, k::Vector{T}, phase_sd=0.0)
	return abs2(form_function(s, k, phase_sd))
end

"""
Calculate the target strength (TS) of a scatterer using the (S)DWBA.  This is just
10 * log10(sigma_bs).

$scattering_function_param_docs
"""
function target_strength{T}(s::Scatterer{T}, k::Vector{T}, phase_sd=0.0)
	return 10 * log10(backscatter_xsection(s, k, phase_sd))
end


for func in [:form_function, :backscatter_xsection, :target_strength]
	eval(quote
		function ($func)(s::Scatterer, freq::Real, sound_speed::Real, phase_sd=0.0)
			k = [0.0, 0.0, -2pi * freq / sound_speed]
			return ($func)(s, k, phase_sd)
		end
	end)
end


"""
Calculate backscatter over a range of angles.

#### Parameters

- `s` : Scatterer object
- `angle1`, `angle2` : Endpoints of the angle range to calculate.
- `k` : Acoustic wavenumber vector
- `n` : Number of angles to calculate; defaults to 100

#### Returns

A dictionary containing elements "angles", "sigma_bs", and "TS",
each a length-n vector.
"""
function tilt_spectrum(s::Scatterer, angle1, angle2, k, n=100)
	angles = linspace(angle1, angle2, n)
	sigma = zeros(angles)
	for i in 1:n
		tilt = angles[i]
		sigma[i] = backscatter_xsection(rotate(s, tilt=tilt), k)
	end
	TS = 10 * log10(sigma)
	return Dict([("angles", angles), ("sigma_bs", sigma), ("TS", TS)])
end


"""
Calculate backscatter over a range of frequencies.  The insonifying sound comes
from above (i.e., traveling in the -z direction).

#### Parameters
- `s` : Scatterer object
- `freq1`, `freq2` : Endpoints of the angle range to calculate.
- `sound_speed` : Sound speed in the surrounding medium
- `n` : Number of frequencies to calculate; defaults to 100

Returns: A dictionary containing elements "freqs", "sigma_bs", and "TS",
	each a length-n vector.
"""
function freq_spectrum(s::Scatterer, freq1, freq2, sound_speed, n=100)
	freqs = linspace(freq1, freq2, n)
	sigma = zeros(freqs)
	for i in 1:n
		k = [0, 0, -2pi * freqs[i] / sound_speed]
		sigma[i] = backscatter_xsection(s, k)
	end
	TS = 10 * log10(sigma)
	return Dict([("freqs", freqs), ("sigma_bs", sigma), ("TS", TS)])
end

"""
Load a scatterer from a file on disk with comma-separated values.

#### Parameters
- `filename` : String.  Path to the datafile.  This should be a standard .csv file 
with columns for the x, y, and z coordinates of the scatterer's centerline, as well
as the `a`, `h`, and `g` arguments to Scatterer().
- `columns` : Optional dictionary of column names. If the columns do not have the names 
- `x`, `y`, `z`, `h`, and `g`, this must be provided.  The keys are the standard column
names and the values are the actual ones in the file.
"""
function from_csv(filename, columns=Dict([("x","x"),("y","y"),("z","z"), 
		("a","a"), ("h","h"), ("g","g")]))
	data, header = readdlm(filename, ',', header=true)
	x = data[:, vec(header .== columns["x"])]
	y = data[:, vec(header .== columns["y"])]
	z = data[:, vec(header .== columns["z"])]
	a = vec(data[:, vec(header .== columns["a"])])
	h = vec(data[:, vec(header .== columns["h"])])
	g = vec(data[:, vec(header .== columns["g"])])
	r = [x y z]'
	return Scatterer(r, a, h, g)
end

function to_csv(s::Scatterer, filename)
	header = ["x" "y" "z" "a" "h" "g"]
	data = [s.r' s.a s.h s.g]
	writedlm(expanduser(filename), [header; data], ',')
end


@doc """
Construct a data structure describing a fluid-like weak scatterer with a deformed
cylindrical shape.  This shape is approximated by a series of `N` discrete segments,
described by the [x, y, z] coordinates, radii, and material properties at their
endpoints.

## Parameters ##

`r` : 3x`N` matrix describing the scatterer's centerline.  Each column is the 
location in 3-D space of one of the centerline points (these should be arranged 
in the proper order).
	
`a` : Vector of radii, length `N`.
	
`h`, `g` : Vectors of sound speed and density contrasts (i.e., the ratio
of sound speed or density inside the scatter to the same quantity in the
surrounding medium).
	
`f0` : Default frequency for the scatterer.  Used when rescaling to ensure
the digitized shape has enough segments relative to the acoustic wavelength.

""" ->
type Scatterer{T}
	r::Array{T, 2}
	a::Array{T, 1}
	h::Array{T, 1}
	g::Array{T, 1}
	f0::T
end

function Scatterer(r::Array{Real, 2}, a::Vector{Real}, h::Vector{Real},
	g::Vector{Real}, f0::Real)
	return Scatterer(promote(r, a, h, g, f0)...)	
end

copy(s::Scatterer) = Scatterer(s.r, s.a, s.h, s.g, s.f0)

function rescale(s::Scatterer; scale=1.0, radius=1.0, x=1.0, y=1.0, z=1.0)
	s = copy(s)
	M = diagm([x, y, z]) * scale
	s.r = M * s.r
	s.a = s.a * scale * radius
	return s
end

@doc """
Return the length of the scatterer (cartesian distance from one end to the other).
""" ->
length(s::Scatterer) = norm(s.r[:, 1] - s.r[:, end])

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
	betatilt = abs(alphatilt - pi/2)
	gammagamma = 1 / (g * h^2) + 1 / g - 2
	if abs(abs(betatilt) - pi/2) < 1e-10
		bessy = norm(k) * a / h
	else
		bessy = besselj1(2*norm(k) * a / h * cos(betatilt)) / cos(betatilt)
	end
	return (norm(k) / 4 * gammagamma * exp(2im * dot(k,r) / h) * a * 
		bessy * norm(diff(rr, 2)))
end

scattering_function_param_docs = """
## Parameters ##

`s` : Scatterer object.

`k` : Acoustic wavenumber vector.  Its magnitude is 2 * pi * f / c (where 
f is the frequency and c is the sound speed) and it points in
the direction of propagation.  For downward-propagating sound waves, 
it is [0, 0, -2pi * f / c].

`phase_sd` : Standard deviation of the phase variability for each segment.
Defaults to 0.0, that is an ordinary deterministic DWBA.  If > 0, the
return value will be stochastic (i.e., the SDWBA).
"""

@doc """
Calculate the complex-valued form function of a scatterer using the (S)DWBA.

$scattering_function_param_docs 
""" ->
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

@doc """
Calculate the backscattering cross-section (sigma_bs) of a scatterer using the (S)DWBA.
This is the absolute square of the form function.

$scattering_function_param_docs 
"""->
function backscatter_xsection{T}(s::Scatterer{T}, k::Vector{T}, phase_sd=0.0)
	return abs2(form_function(s, k, phase_sd))
end

@doc """
Calculate the target strength (TS) of a scatterer using the (S)DWBA.  This is just
10 * log10(sigma_bs).

$scattering_function_param_docs
""" ->
function target_strength{T}(s::Scatterer{T}, k::Vector{T}, phase_sd=0.0)
	return 10 * log10(backscatter_xsection(s, k, phase_sd))
end


@doc """
Calculate backscatter over a range of angles.

## Parameters ##:

`s` : Scatterer object

`angle1`, `angle2` : Endpoints of the angle range to calculate.

`k` : Acoustic wavenumber vector

`n` : Number of angles to calculate; defaults to 100

Returns: A dictionary containing elements "angles", "sigma_bs", and "TS",
	each a length-n vector.
""" ->
function tilt_spectrum(s::Scatterer, angle1, angle2, k, n=100)
	angles = linspace(angle1, angle2, n)
	sigma = zeros(angles)
	for i in 1:n
		sigma[i] = backscatter_xsection(s, k)
	end
	TS = 10 * log10(sigma)
	return Dict("angle" => angles, "sigma_bs" => sigma, "TS" => TS)
end

@doc """
Calculate backscatter over a range of frequencies.  The insonifying sound comes
from above (i.e., traveling in the -z direction).

## Parameters ##:

`s` : Scatterer object

`freq1`, `freq2` : Endpoints of the angle range to calculate.

`sound_speed` : Sound speed in the surrounding medium

`n` : Number of frequencies to calculate; defaults to 100

Returns: A dictionary containing elements "freqs", "sigma_bs", and "TS",
	each a length-n vector.
""" ->
function freq_spectrum(s::Scatterer, freq1, freq2, sound_speed, n=100)
	freqs = linspace(freq1, freq2, n)
	sigma = zeros(freqs)
	for i in 1:n
		k = [0, 0, -2pi * freqs[i] / sound_speed]
		sigma[i] = backscatter_xsection(s, k)
	end
	TS = 10 * log10(sigma)
	return Dict("freqs" => freqs, "sigma_bs" => sigma, "TS" => TS)
end

@doc """
Load a scatterer from a file on disk with comma-separated values.

## Parameters ##

`filename` : String.  Path to the datafile.  This should be a standard .csv file 
with columns for the x, y, and z coordinates of the scatterer's centerline, as well
as the `a`, `h`, and `g` arguments to Scatterer().

`columns` : Optional dictionary of column names. If the columns do not have the names 
`x`, `y`, `z`, `h`, and `g`, this must be provided.  The keys are the standard column
names and the values are the actual ones in the file.

`f0` : Standard or verified frequency for the scatterer.  Defaults to 1.0.
""" ->
function from_csv(filename, columns=Dict([("x","x"),("y","y"),("z","z"), 
		("a","a"), ("h","h"), ("g","g")]); f0=1.0)
	data, header = readdlm(filename, ',', header=true)
	x = data[:, vec(header .== columns["x"])]
	y = data[:, vec(header .== columns["y"])]
	z = data[:, vec(header .== columns["z"])]
	a = vec(data[:, vec(header .== columns["a"])])
	h = vec(data[:, vec(header .== columns["h"])])
	g = vec(data[:, vec(header .== columns["g"])])
	r = [x y z]'
	return Scatterer(r, a, h, g, f0)
end

function to_csv(s::Scatterer, filename)
	header = ["x" "y" "z" "a" "h" "g"]
	data = [s.r' s.a s.h s.g]
	writedlm(expanduser(filename), [header; data], ',')
end

# SDWBA


## Methods [Exported]

---

<a id="method__freq_spectrum.1" class="lexicon_definition"></a>
#### freq_spectrum(s::SDWBA.Scatterer{T},  freq1,  freq2,  sound_speed) [¶](#method__freq_spectrum.1)
Calculate backscatter over a range of frequencies.  The insonifying sound comes
from above (i.e., traveling in the -z direction).

### Parameters
-`s` : Scatterer object
-`freq1`, `freq2` : Endpoints of the angle range to calculate.
-`sound_speed` : Sound speed in the surrounding medium
-`n` : Number of frequencies to calculate; defaults to 100

Returns: A dictionary containing elements "freqs", "sigma_bs", and "TS",
	each a length-n vector.


*source:*
[SDWBA/src/types.jl:166](https://github.com/ElOceanografo/SDWBA.jl/tree/7fbe2c7b477427f6a5f0b50223d5e4df5bae754f/src/types.jl#L166)

---

<a id="method__freq_spectrum.2" class="lexicon_definition"></a>
#### freq_spectrum(s::SDWBA.Scatterer{T},  freq1,  freq2,  sound_speed,  n) [¶](#method__freq_spectrum.2)
Calculate backscatter over a range of frequencies.  The insonifying sound comes
from above (i.e., traveling in the -z direction).

### Parameters
-`s` : Scatterer object
-`freq1`, `freq2` : Endpoints of the angle range to calculate.
-`sound_speed` : Sound speed in the surrounding medium
-`n` : Number of frequencies to calculate; defaults to 100

Returns: A dictionary containing elements "freqs", "sigma_bs", and "TS",
	each a length-n vector.


*source:*
[SDWBA/src/types.jl:166](https://github.com/ElOceanografo/SDWBA.jl/tree/7fbe2c7b477427f6a5f0b50223d5e4df5bae754f/src/types.jl#L166)

---

<a id="method__from_csv.1" class="lexicon_definition"></a>
#### from_csv(filename) [¶](#method__from_csv.1)
Load a scatterer from a file on disk with comma-separated values.

## Parameters
- `filename` : String.  Path to the datafile.  This should be a standard .csv file 
with columns for the x, y, and z coordinates of the scatterer's centerline, as well
as the `a`, `h`, and `g` arguments to Scatterer().
- `columns` : Optional dictionary of column names. If the columns do not have the names 
- `x`, `y`, `z`, `h`, and `g`, this must be provided.  The keys are the standard column
names and the values are the actual ones in the file.
- `f0` : Standard or verified frequency for the scatterer.  Defaults to 1.0.


*source:*
[SDWBA/src/types.jl:189](https://github.com/ElOceanografo/SDWBA.jl/tree/7fbe2c7b477427f6a5f0b50223d5e4df5bae754f/src/types.jl#L189)

---

<a id="method__from_csv.2" class="lexicon_definition"></a>
#### from_csv(filename,  columns) [¶](#method__from_csv.2)
Load a scatterer from a file on disk with comma-separated values.

## Parameters
- `filename` : String.  Path to the datafile.  This should be a standard .csv file 
with columns for the x, y, and z coordinates of the scatterer's centerline, as well
as the `a`, `h`, and `g` arguments to Scatterer().
- `columns` : Optional dictionary of column names. If the columns do not have the names 
- `x`, `y`, `z`, `h`, and `g`, this must be provided.  The keys are the standard column
names and the values are the actual ones in the file.
- `f0` : Standard or verified frequency for the scatterer.  Defaults to 1.0.


*source:*
[SDWBA/src/types.jl:189](https://github.com/ElOceanografo/SDWBA.jl/tree/7fbe2c7b477427f6a5f0b50223d5e4df5bae754f/src/types.jl#L189)

---

<a id="method__tilt_spectrum.1" class="lexicon_definition"></a>
#### tilt_spectrum(s::SDWBA.Scatterer{T},  angle1,  angle2,  k) [¶](#method__tilt_spectrum.1)
Calculate backscatter over a range of angles.

### Parameters

- `s` : Scatterer object
- `angle1`, `angle2` : Endpoints of the angle range to calculate.
- `k` : Acoustic wavenumber vector
- `n` : Number of angles to calculate; defaults to 100

### Returns

A dictionary containing elements "angles", "sigma_bs", and "TS",
each a length-n vector.


*source:*
[SDWBA/src/types.jl:143](https://github.com/ElOceanografo/SDWBA.jl/tree/7fbe2c7b477427f6a5f0b50223d5e4df5bae754f/src/types.jl#L143)

---

<a id="method__tilt_spectrum.2" class="lexicon_definition"></a>
#### tilt_spectrum(s::SDWBA.Scatterer{T},  angle1,  angle2,  k,  n) [¶](#method__tilt_spectrum.2)
Calculate backscatter over a range of angles.

### Parameters

- `s` : Scatterer object
- `angle1`, `angle2` : Endpoints of the angle range to calculate.
- `k` : Acoustic wavenumber vector
- `n` : Number of angles to calculate; defaults to 100

### Returns

A dictionary containing elements "angles", "sigma_bs", and "TS",
each a length-n vector.


*source:*
[SDWBA/src/types.jl:143](https://github.com/ElOceanografo/SDWBA.jl/tree/7fbe2c7b477427f6a5f0b50223d5e4df5bae754f/src/types.jl#L143)

## Types [Exported]

---

<a id="type__scatterer.1" class="lexicon_definition"></a>
#### SDWBA.Scatterer{T} [¶](#type__scatterer.1)
Construct a data structure describing a fluid-like weak scatterer with a deformed
cylindrical shape.  This shape is approximated by a series of `N` discrete segments,
described by the [x, y, z] coordinates, radii, and material properties at their
endpoints.

### Parameters
- `r` : 3x`N` matrix describing the scatterer's centerline.  Each column is the 
location in 3-D space of one of the centerline points (these should be arranged 
in the proper order).
- `a` : Vector of radii, length `N`.
- `h`, `g` : Vectors of sound speed and density contrasts (i.e., the ratio
of sound speed or density inside the scatter to the same quantity in the
surrounding medium).
- `f0` : Default frequency for the scatterer.  Used when rescaling to ensure
the digitized shape has enough segments relative to the acoustic wavelength.



*source:*
[SDWBA/src/types.jl:20](https://github.com/ElOceanografo/SDWBA.jl/tree/7fbe2c7b477427f6a5f0b50223d5e4df5bae754f/src/types.jl#L20)


## Methods [Internal]

---

<a id="method__length.1" class="lexicon_definition"></a>
#### length(s::SDWBA.Scatterer{T}) [¶](#method__length.1)
Return the length of the scatterer (cartesian distance from one end to the other).


*source:*
[SDWBA/src/types.jl:46](https://github.com/ElOceanografo/SDWBA.jl/tree/7fbe2c7b477427f6a5f0b50223d5e4df5bae754f/src/types.jl#L46)


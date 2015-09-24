# API-INDEX


## MODULE: SDWBA

---

## Methods [Exported]

[freq_spectrum(s::SDWBA.Scatterer{T},  freq1,  freq2,  sound_speed)](SDWBA.md#method__freq_spectrum.1)  Calculate backscatter over a range of frequencies.  The insonifying sound comes

[freq_spectrum(s::SDWBA.Scatterer{T},  freq1,  freq2,  sound_speed,  n)](SDWBA.md#method__freq_spectrum.2)  Calculate backscatter over a range of frequencies.  The insonifying sound comes

[from_csv(filename)](SDWBA.md#method__from_csv.1)  Load a scatterer from a file on disk with comma-separated values.

[from_csv(filename,  columns)](SDWBA.md#method__from_csv.2)  Load a scatterer from a file on disk with comma-separated values.

[tilt_spectrum(s::SDWBA.Scatterer{T},  angle1,  angle2,  k)](SDWBA.md#method__tilt_spectrum.1)  Calculate backscatter over a range of angles.

[tilt_spectrum(s::SDWBA.Scatterer{T},  angle1,  angle2,  k,  n)](SDWBA.md#method__tilt_spectrum.2)  Calculate backscatter over a range of angles.

---

## Types [Exported]

[SDWBA.Scatterer{T}](SDWBA.md#type__scatterer.1)  Construct a data structure describing a fluid-like weak scatterer with a deformed

---

## Methods [Internal]

[length(s::SDWBA.Scatterer{T})](SDWBA.md#method__length.1)  Return the length of the scatterer (cartesian distance from one end to the other).

## MODULE: SDWBA.scatterers

---

## Globals [Exported]

[krill_conti](SDWBA.scatterers.md#global__krill_conti.1)  Krill shape from McGeehee et al. 1998, 'Effects of orientation on acoustic scattering

[krill_mcgeehee](SDWBA.scatterers.md#global__krill_mcgeehee.1)  Krill shape from Conti and Demer, 2006, 'Improved parameterization of the SDWBA for 


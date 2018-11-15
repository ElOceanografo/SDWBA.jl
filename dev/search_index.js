var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "#SDWBA-1",
    "page": "Introduction",
    "title": "SDWBA",
    "category": "section",
    "text": "This Julia package implements the (stochastic) distorted-wave Born approximation for simple, fluid-like scatterers. The goal is to provide a set of easy-to-use tools to calculate the acoustic backscattering cross-sections of marine organisms using the (stochastic) distorted-wave Born approximation (the DWBA or SWDBA). These models discretize zooplankton or other scatterers as a series of cylindrical sections, and are efficient and accurate for fluid-like organisms, including krill and copepods."
},

{
    "location": "#Installation-1",
    "page": "Introduction",
    "title": "Installation",
    "category": "section",
    "text": "To install, runPkg.add(\"SDWBA\")It can then be loaded the normal way:using SDWBA"
},

{
    "location": "#Basic-use-1",
    "page": "Introduction",
    "title": "Basic use",
    "category": "section",
    "text": ""
},

{
    "location": "#Constructing-Scatterers-1",
    "page": "Introduction",
    "title": "Constructing Scatterers",
    "category": "section",
    "text": "Sound-scattering things (e.g. zooplankton) are represented as Scatterer objects.  A Scatterer contains information about the shape and material properties of such an object.  The (S)DWBA assumes the a deformed cylindrical shape: circular in cross-section, with a varying radius and a centerline that doesn\'t need to be straight.  A Scatterer represents this shape as a series of discrete segments.To construct a scatterer, we need to specify the 3-D coordinates of its centerline.  The standard orientation is for the animal\'s body to lie roughly parallel to the x-axis, with the z-axis pointing up.x = range(0, stop=0.2, length=10)\ny = zeros(x)\nz = zeros(x)These coordinates are stacked into a 3xN matrix, which will be called r.r = [x\'; y\'; z\']The scatterer\'s radius can vary as well.  We\'ll make ours kinda lumpy.a = randn(10).^2  # squared to make sure the\'re all positiveWe also define the density and sound-speed contrasts h and g (value inside scatterer / value in the surrounding medium).  These can vary from one segmen to another, but will often be assumed constant inside the scatterer.h = 1.02 * ones(a)\ng = 1.04 * ones(a)We can now define the scatterer.weird_zoop = Scatterer(r, a, h, g)"
},

{
    "location": "#Loading-Scatterers-from-file-1",
    "page": "Introduction",
    "title": "Loading Scatterers from file",
    "category": "section",
    "text": "A function from_csv() is provided to load a scatterer directly from a comma-separated datafile.  This file should have columns for the x, y, z, a, g, and h values of the scatterer.  If the columns have those names, the function will work automatically:my_scat = from_csv(\"path/to/my_scat.csv\")If the columns have some other names, you can provide a dictionary telling the function which is which.colnames = Dict([(\"x\",\"foo\"),(\"y\",\"bar\"),(\"z\",\"baz\"), (\"a\",\"qux\"),\n	(\"h\",\"plugh\"), (\"g\",\"garply\")])\nmy_scat = from_csv(\"path/to/my_scat.csv\", colnames)\n"
},

{
    "location": "#Build-in-models-1",
    "page": "Introduction",
    "title": "Build-in models",
    "category": "section",
    "text": "The package comes with a sub-module called Models containing several ready-made Scatterers.  See the documentation for references for each one.krill = Models.krill_mcgeehee"
},

{
    "location": "#Calculating-backscatter-1",
    "page": "Introduction",
    "title": "Calculating backscatter",
    "category": "section",
    "text": "There are three functions that calculate backscatter: form_function, backscatter_xsection, and target_strength.  Each is just a wrapper around the one before it, and they all have the same arguments.krill = Models.krill_mcgeehee\nfreq = 120e3 # Hz\nsound_speed = 1470 # m/s\n\n# deterministic DWBA\ntarget_strength(krill, freq, sound_speed)\n\n# stochastic SDWBA\nphase_sd = 0.7071\ntarget_strength(krill, freq, sound_speed, phase_sd)When a frequency and sound speed are provided, the sound is assumed to come from above, as is the usual case with a ship-mounted echosounder.  If you would like it to come from some other direction, you can specify a 3-D wavenumber vector–that is, a vector, pointing in the direction of propagation, whose magnitude is k = 2 pi f  c.k_mag = 2pi * freq / sound_speed\nk_vertical = [0.0, 0.0, -k_mag]\ntarget_strength(krill, k_vertical)\n\nangle = deg2rad(30)\nk_slanted = k_mag * [sin(angle), 0, cos(angle)]\ntarget_strength(krill, k_slanted)It is usually easier to think of the scatterer tilting than the wavenumber vector.  The rotate function does this easily, accepting roll, tilt, and yaw angles (in degrees) as keyword arguments.target_strength(rotate(krill, tilt=30), freq, sound_speed)\ntarget_strength(rotate(krill, tilt=45, roll=10), freq, sound_speed)"
},

{
    "location": "#Frequency-and-tilt-angle-spectrums-1",
    "page": "Introduction",
    "title": "Frequency and tilt-angle spectrums",
    "category": "section",
    "text": "Often, we are interested in calculating the target strength of a scatter over a range of frequencies or angles.  Two convenience functions are provided to do this: freq_spectrum and tilt_spectrum.  Both return a dictionary, with results in both the linear and log domains.start, stop = 10e3, 1000e3 # endpoints of the spectrum, in Hz\nnfreqs = 200\nfs = freq_spectrum(krill, start, stop, sound_speed, nfreqs)\n\nrequire(:PyPlot)\nsemilogx(fs[\"freqs\"], fs[\"TS\"])\n\n\nts = tilt_spectrum(krill, -180, 180, k_vertical, 360)\n"
},

{
    "location": "API/#",
    "page": "API reference",
    "title": "API reference",
    "category": "page",
    "text": ""
},

{
    "location": "API/#SDWBA.Scatterer",
    "page": "API reference",
    "title": "SDWBA.Scatterer",
    "category": "type",
    "text": "Construct a data structure describing a fluid-like weak scatterer with a deformed cylindrical shape.  This shape is approximated by a series of N discrete segments, described by the [x, y, z] coordinates, radii, and material properties at their endpoints.\n\nParameters\n\nr : 3xN matrix describing the scatterer\'s centerline.  Each column is the\n\nlocation in 3-D space of one of the centerline points (these should be arranged in the proper order).\n\na : Vector of radii, length N.\nh, g : Vectors of sound speed and density contrasts (i.e., the ratio\n\nof sound speed or density inside the scatter to the same quantity in the surrounding medium).\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.rescale",
    "page": "API reference",
    "title": "SDWBA.rescale",
    "category": "function",
    "text": "Scale the scatterer\'s size (overall or along a particular dimension) by a constant factor.\n\nParameters\n\ns : Scatterer object.\nscale : Factor by which to grow/shrink the scatterer.\nradius, x, y, z : Optional factors, scaling the scatterer\'s radius\n\nand along each dimension in space. All default to 1.0.\n\nReturns\n\nA rescaled scatterer.\n\nDetails\n\nWhen making a scatterer larger, it is important to make sure it\'s body has enough segments to accurately represent the shape at the frequencies of interest. Specifically, the ratio L / (N λ), where L is the length of the animal, N is the number of segments, and λ is the acoustic wavelength, should remain constant, which may require interpolating new points between the existing ones. See Conti and Demer (2006) or Calise and Skaret (2011) for details.\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.resize",
    "page": "API reference",
    "title": "SDWBA.resize",
    "category": "function",
    "text": "Resize a scatterer.  This is a convenience wrapper around rescale, for the common situation where you want to change a scatterer to a specific length. The scatterer\'s relative proportions are preserved.\n\nParameters\n\ns : Scatterer\nlen : Desired length to which the scatterer should be scaled.\n\nReturns\n\nA resized scatterer.\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.interpolate",
    "page": "API reference",
    "title": "SDWBA.interpolate",
    "category": "function",
    "text": "Resample a scatterer\'s measurement points by interpolating between them. Used to change the resolution, for instance when increasing the scatterer\'s body size or decreasing the acoustic wavelength.\n\nParameters\n\ns : Scatterer\nn : Number of body segments desired in the interpolated scatterer.\n\nReturns\n\nA Scatterer with a different number of body segments.\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.rotate",
    "page": "API reference",
    "title": "SDWBA.rotate",
    "category": "function",
    "text": "Rotate the scatterer in space, returning a rotated copy.\n\nParameters\n\nroll : Angle to roll the scatterer, in degrees. Defaults to 0.\ntilt : Angle to tilt the scatterer, in degrees. Defaults to 0.\nyaw : Angle to yaw the scatterer, in degrees. Defaults to 0.\n\nReturns\n\nA Scatterer with the same shape and properties, but a new orientation.\n\nThe roll, tilt, and yaw refer to rotations around the x, y, and z axes, respectively. They are applied in that order.\n\n\n\n\n\n"
},

{
    "location": "API/#Base.length",
    "page": "API reference",
    "title": "Base.length",
    "category": "function",
    "text": "length(collection) -> Integer\n\nReturn the number of elements in the collection.\n\nUse lastindex to get the last valid index of an indexable collection.\n\nExamples\n\njulia> length(1:5)\n5\n\njulia> length([1, 2, 3, 4])\n4\n\njulia> length([1 2; 3 4])\n4\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.form_function",
    "page": "API reference",
    "title": "SDWBA.form_function",
    "category": "function",
    "text": "Calculate the complex-valued form function of a scatterer using the (S)DWBA.\n\nParameters\n\ns : Scatterer object.\nk : Acoustic wavenumber vector.  Its magnitude is 2 * pi * f / c (where\n\nf is the frequency and c is the sound speed) and it points in the direction of propagation.  For downward-propagating sound waves, it is [0, 0, -2pi * f / c].\n\nphase_sd : Standard deviation of the phase variability for each segment (in radians).\n\nDefaults to 0.0, that is, an ordinary deterministic DWBA.  If > 0, the return value will be stochastic (i.e., the SDWBA).\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.backscatter_xsection",
    "page": "API reference",
    "title": "SDWBA.backscatter_xsection",
    "category": "function",
    "text": "Calculate the backscattering cross-section (sigma_bs) of a scatterer using the (S)DWBA. This is the absolute square of the form function.\n\nParameters\n\ns : Scatterer object.\nk : Acoustic wavenumber vector.  Its magnitude is 2 * pi * f / c (where\n\nf is the frequency and c is the sound speed) and it points in the direction of propagation.  For downward-propagating sound waves, it is [0, 0, -2pi * f / c].\n\nphase_sd : Standard deviation of the phase variability for each segment (in radians).\n\nDefaults to 0.0, that is, an ordinary deterministic DWBA.  If > 0, the return value will be stochastic (i.e., the SDWBA).\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.target_strength",
    "page": "API reference",
    "title": "SDWBA.target_strength",
    "category": "function",
    "text": "Calculate the target strength (TS) of a scatterer using the (S)DWBA.  This is just 10 * log10(sigma_bs).\n\nParameters\n\ns : Scatterer object.\nk : Acoustic wavenumber vector.  Its magnitude is 2 * pi * f / c (where\n\nf is the frequency and c is the sound speed) and it points in the direction of propagation.  For downward-propagating sound waves, it is [0, 0, -2pi * f / c].\n\nphase_sd : Standard deviation of the phase variability for each segment (in radians).\n\nDefaults to 0.0, that is, an ordinary deterministic DWBA.  If > 0, the return value will be stochastic (i.e., the SDWBA).\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.tilt_spectrum",
    "page": "API reference",
    "title": "SDWBA.tilt_spectrum",
    "category": "function",
    "text": "Calculate backscatter over a range of angles.\n\nParameters\n\ns : Scatterer object\nangle1, angle2 : Endpoints of the angle range to calculate.\nk : Acoustic wavenumber vector\nn : Number of angles to calculate; defaults to 100\n\nReturns\n\nA dictionary containing elements \"angles\", \"sigma_bs\", and \"TS\", each a length-n vector.\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.freq_spectrum",
    "page": "API reference",
    "title": "SDWBA.freq_spectrum",
    "category": "function",
    "text": "Calculate backscatter over a range of frequencies.  The insonifying sound comes from above (i.e., traveling in the -z direction).\n\nParameters\n\ns : Scatterer object\nfreq1, freq2 : Endpoints of the angle range to calculate.\nsound_speed : Sound speed in the surrounding medium\nn : Number of frequencies to calculate; defaults to 100\n\nReturns: A dictionary containing elements \"freqs\", \"sigma_bs\", and \"TS\", 	each a length-n vector.\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.from_csv",
    "page": "API reference",
    "title": "SDWBA.from_csv",
    "category": "function",
    "text": "Load a scatterer from a file on disk with comma-separated values.\n\nParameters\n\nfilename : String.  Path to the datafile.  This should be a standard .csv file\n\nwith columns for the x, y, and z coordinates of the scatterer\'s centerline, as well as the a, h, and g arguments to Scatterer().\n\ncolumns : Optional dictionary of column names. If the columns do not have the names\nx, y, z, h, and g, this must be provided.  The keys are the standard column\n\nnames and the values are the actual ones in the file.\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA.to_csv",
    "page": "API reference",
    "title": "SDWBA.to_csv",
    "category": "function",
    "text": "Save a scatterer\'s shape to a file on disk with comma-separated values.\n\nParameters\n\ns : Scatterer object to save.\nfilename : Where to save it.\n\n\n\n\n\n"
},

{
    "location": "API/#SDWBA-API-1",
    "page": "API reference",
    "title": "SDWBA API",
    "category": "section",
    "text": "Scatterer\nrescale\nresize\ninterpolate\nrotate\nlength\nform_function\nbackscatter_xsection\ntarget_strength\ntilt_spectrum\nfreq_spectrum\nfrom_csv\nto_csv"
},

{
    "location": "Models/#",
    "page": "Included Scatterering Models",
    "title": "Included Scatterering Models",
    "category": "page",
    "text": ""
},

{
    "location": "Models/#SDWBA.Models.krill_mcgeehee",
    "page": "Included Scatterering Models",
    "title": "SDWBA.Models.krill_mcgeehee",
    "category": "constant",
    "text": "Krill shape from McGeehee et al. 1998, \'Effects of orientation on acoustic scattering from Antarctic krill at 120 kHz.\' Deep-Sea Research II 45(7), 1273-1294.\n\n\n\n\n\n"
},

{
    "location": "Models/#SDWBA.Models.krill_conti",
    "page": "Included Scatterering Models",
    "title": "SDWBA.Models.krill_conti",
    "category": "constant",
    "text": "Krill shape from Conti and Demer, 2006, \'Improved parameterization of the SDWBA for estimating krill target strength.\' ICES Journal of Marine Science 63(5), 928-935.\n\n\n\n\n\n"
},

{
    "location": "Models/#SDWBA.Models.sandeel",
    "page": "Included Scatterering Models",
    "title": "SDWBA.Models.sandeel",
    "category": "constant",
    "text": "Generic sand eel/sand lance shape (Ammodytes spp.).  Shape is taken from illustration in Bigelow and Schroeder, \'Fishes of the Gulf of Maine.\'  Material properties from Yasuma et al. (2009), \'Density and sound-speed contrasts, and target strength of Japanese sandeel Ammodytes personatus.\' Fisheries Science 75 (3) 545-552.\n\n\n\n\n\n"
},

{
    "location": "Models/#SDWBA.Models.calanoid_copepod",
    "page": "Included Scatterering Models",
    "title": "SDWBA.Models.calanoid_copepod",
    "category": "constant",
    "text": "Generic calanoid copepod shape, 1 mm long, with g and h for \"typical\" marine zooplankton (both 1.04, as per Stanton and Chu 2000, \'Review and recommendations for the modelling of acoustic scattering by fluid-like elongated zooplankton: euphausiids and copepods.\' ICES Journal of Marine Science 57, 793-807).\n\n\n\n\n\n"
},

{
    "location": "Models/#SDWBA.Models.daphnia",
    "page": "Included Scatterering Models",
    "title": "SDWBA.Models.daphnia",
    "category": "constant",
    "text": "Generic Daphnia shape used in Warren et al. 2016, \'Measuring the distribution, abundance, and biovolume of zooplankton in an oligotrophic freshwater lake with a 710 kHz scientific echosounder.\' Limnology and Oceanography: Methods\n\n\n\n\n\n"
},

{
    "location": "Models/#SDWBA.Models.daphnia2",
    "page": "Included Scatterering Models",
    "title": "SDWBA.Models.daphnia2",
    "category": "constant",
    "text": "Alternative (more realistic?) daphnia shape\n\n\n\n\n\n"
},

{
    "location": "Models/#SDWBA.Models.nauplius",
    "page": "Included Scatterering Models",
    "title": "SDWBA.Models.nauplius",
    "category": "constant",
    "text": "Generic nauplius larva shape, 0.5 mm long, with g and h for \"typical\" marine zooplankton (both 1.04, as per Stanton and Chu 2000, \'Review and recommendations for the modelling of acoustic scattering by fluid-like elongated zooplankton: euphausiids and copepods.\' ICES Journal of Marine Science 57, 793-807).\n\n\n\n\n\n"
},

{
    "location": "Models/#SDWBA-Scatterer-Models-1",
    "page": "Included Scatterering Models",
    "title": "SDWBA Scatterer Models",
    "category": "section",
    "text": "Models.krill_mcgeehee\nModels.krill_conti\nModels.sandeel\nModels.calanoid_copepod\nModels.daphnia\nModels.daphnia2\nModels.nauplius"
},

]}

using SDWBA, Docile, Lexicon

Lexicon.save("API.md", SDWBA)
Lexicon.save("scatterers.md", SDWBA.scatterers)
cd("../")
run(`mkdocs build`)
cd("docs")
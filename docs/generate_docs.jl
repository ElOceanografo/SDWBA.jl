using SDWBA, Docile, Lexicon

Lexicon.save("API.md", SDWBA)
Lexicon.save("Models.md", SDWBA.Models)
cd("../")
run(`mkdocs build --clean`)
cd("docs")
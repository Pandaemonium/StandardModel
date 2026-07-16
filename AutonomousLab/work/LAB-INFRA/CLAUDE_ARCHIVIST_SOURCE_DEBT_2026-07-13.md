# Archivist activation: source-debt resolution 2026-07-13

- Activation: `role-20260713-043254-147025c6`
- Role: Archivist (`archivist`), model `claude` (Claude-only rotation this window)
- Work item: `ARCHIVE-BASELINE-001`
- Scope: resolve at least one of the six remaining `NEEDS-VERIFY` rows in
  `Sources/Null_Edge_References.md` with primary evidence, exact claim scope, and
  canonical identifiers.
- Method: `scholarly` MCP (Crossref DOI-backed metadata, INSPIRE-HEP relevance).
  Neo4j/Zotero reported running but not mutated this pass (no add/dedup needed).

## Resolved: Koide original relation (`TBD-Koide1982`) -> PRIMARY-METADATA-VERIFIED

**Canonical identifiers (Crossref-verified this pass):**

- Y. Koide, "New view of quark and lepton mass hierarchy," *Phys. Rev. D* 28
  (1983) 252 - DOI `10.1103/PhysRevD.28.252`.
- Erratum, *Phys. Rev. D* 29 (1984) 1544 - DOI `10.1103/PhysRevD.29.1544`.

**Exact claim scope (what the source does and does not assert):**

- The relation is the charged-lepton mass formula
  `Q = (m_e + m_mu + m_tau) / (sqrt(m_e) + sqrt(m_mu) + sqrt(m_tau))^2 = 2/3`.
- Koide's own later account (arXiv `1701.01921`, "Sumino Model and My Personal
  View") distinguishes TWO formulas: "formula A" (proposed in 1982 from a U(3)
  family model, satisfied only when all interactions except the U(3) family
  interaction are switched off) and "formula B" (the empirical `Q = 2/3`, which
  he says is "excellently satisfied by POLE masses" but "may be an accidental
  coincidence"). The famous numerical agreement (~1e-5) is formula B.
- Therefore the honest grade is: a PHENOMENOLOGICAL / empirical relation, NOT a
  derived theorem. Its agreement is for pole masses; a running/QED correction
  (the Sumino route, already carried as `TBD-Sumino2009`, `0812.2103`) is what a
  Koide-based mechanism must clear to explain why pole masses fit.
- Project use (Q07 / T-solder mass-values comparison): a comparison TARGET, not
  theorem support for any null-edge claim.

**Honesty note recorded in the row:** the earliest 1982 announcement (Lett.
Nuovo Cim. 34 (1982) 201) was NOT separately DOI-checked this pass; the row is
anchored on the two Crossref-verified PRD identifiers.

## Partially advanced: Shale-Stinespring implementability (`TBD-ShaleStinespring`)

**Identifiers:**

- Boson/symplectic case (Crossref-VERIFIED): D. Shale, "Linear symmetries of
  free boson fields," *Trans. Amer. Math. Soc.* 103 (1962) 149-167 - DOI
  `10.1090/S0002-9947-1962-0137504-6`.
- Fermion/orthogonal case (named from canonical bibliography, DOI NOT yet
  checked): D. Shale, W. F. Stinespring, "Spinor representations of infinite
  orthogonal groups," *J. Math. Mech.* 14 (1965) 315-322.

**Claim scope:** the implementability criterion - a Bogoliubov transformation is
unitarily implementable on the boson (resp. fermion) Fock space iff its
off-diagonal block is Hilbert-Schmidt; boson = symplectic (Shale 1962), fermion =
orthogonal (the eponymous Shale-Stinespring 1965). Continuum non-implementability
obstruction; the finite null-edge lane does not instantiate the Hilbert-Schmidt
hypothesis, so it is a comparison/boundary source, not theorem support.

**Status kept PARTIAL:** the eponymous fermion-case 1965 J. Math. Mech.
identifier and full text are not yet confirmed. Do not promote to fully verified
until that primary is checked (J. Math. Mech. has no clean Crossref DOI; needs a
direct Indiana Univ. Math. J. / archive lookup).

## Remaining NEEDS-VERIFY debt (4 rows)

1. `TBD-ConnesNCG` - Connes NCG / real structures (J_C / KO convention).
2. `TBD-TomitaTakesaki` - Tomita-Takesaki modular theory (J_mod; state
   dependence must be explicit).
3. `TBD-Hyperuniformity` - Torquato-Stillinger hyperuniformity + Martin-Yalcin /
   Stillinger-Lovett Coulomb sum rules.
4. `TBD-WilczekMassWithoutMass` - Wilczek "Mass without mass" essays (framing
   only; canonical Physics Today identifiers to add).

Plus the fermion-case Shale-Stinespring 1965 identifier above.

## Cross-note to the tranche-2 review

Separately from this activation, my tranche-2 review flagged a REPAIR_REQUIRED:
the Nielsen-Ninomiya row 63 (`CP84QBM4`) duplicates the pre-existing row 179
(`TBD-NielsenNinomiya1981`) with a divergent "no-go traded by the Krein
J-hermiticity route" claim. That dedup is Codex's (owner) to apply; I did not
touch either NN row in this Archivist pass.

## Verification commands

- `scholarly` Crossref: "Koide new view quark lepton mass hierarchy" ->
  PRD 28 252 + erratum PRD 29 1544 (DOIs above).
- `scholarly` INSPIRE-HEP: "Koide charged lepton mass formula" -> surfaced
  arXiv `1701.01921` with the formula-A/formula-B pole-mass distinction.
- `scholarly` Crossref: "Shale linear symmetries free boson fields 1962" ->
  Trans. AMS 103 (1962) DOI `10.1090/S0002-9947-1962-0137504-6`.
- `pre-commit run --files Sources/Null_Edge_References.md`.

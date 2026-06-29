# Summary of changes for run 7add477d-ce8d-43b4-8643-bbe50c3b1c15
Prepared the Gate C1 reference index/anomaly/locality source-and-theorem map. Two deliverables were added to the project:

1. `GateC1_SourceMap.md` — the strategy document covering all six requested items:
   - **(1) Wilson/Neuberger overlap:** the exact lattice index theorem (Hasenfratz–Laliena–Niedermayer 1998; Lüscher 1998), the Ginsparg–Wilson relation (Ginsparg–Wilson 1982; Neuberger 1998), the locality/admissibility theorem (Hernández–Jansen–Lüscher 1999, admissibility bound ε≤1/30), and the anomaly-cancellation source shape (Lüscher 1999/2000), each with its precise statement.
   - **(2) Domain-wall:** boundary index / anomaly inflow (Callan–Harvey; Kaplan; Shamir/Furman–Shamir), effective-overlap equivalence as L_s→∞ (Kikukawa–Noguchi; Borici; Edwards–Heller), residual-mass control (Furman–Shamir; RBC/UKQCD; Brower–Neff–Orginos), and locality via the overlap limit.
   - **(3) Adams/staggered overlap:** the extra spin–taste (Γ₅₅ = γ₅⊗ξ₅) taste-singlet index theorem (Adams 2010/2011; Hoelbling).
   - **(4) Gate routing table** mapping every source theorem to a Lean certificate for C159/C183/C184.
   - **(5) Convention hazards:** γ₅ vs Γ₅₅, chirality/index sign (±Q, n₋−n₊), mass window 0<m₀<2, admissibility bound, index normalization (a/2, (1−aD/2)), and hypercharge/charge normalization for Σq³=Σq=0.
   - **(6) Recommendation:** formalize/cite the GW⇒index algebraic certificate first, then locality, then anomaly (C183), with domain-wall second and staggered deferred — consistent with C179.

   Every external result is tagged **[SOURCE OBLIGATION]**; no source support is fabricated, and bibliographic constants are flagged for verification against the primary papers.

2. `RequestProject/GateC1SourceMap.lean` — the Lean/API certificate statements (item 4), encoding each source theorem as a `structure` interface (not a raw assumption): `GinspargWilsonCert`, `LatticeIndexCert`, `OverlapLocalityCert`, `AbelianAnomalyCert`, `NonabelianAnomalyCert`, `BoundaryIndexInflowCert`, `DomainWallOverlapEquivCert`, `ResidualMassControlCert`, `StaggeredTasteIndexCert`. Algebraic content (GW relation, involutivity, index trace identity, anomaly conditions) is kept concrete over an abstract ℝ-algebra; analytic statements (locality, spectral gap, L_s→∞ convergence, m_res decay) are carried as named Prop fields plus the theorem-content implication. Each structure carries its citation and source-obligation note. The module builds successfully and contains no proof placeholders, raw a x i o m declaration, or `@[implemented_by]`.

This is a research/strategy output: it selects and maps the reference theorems and provides honest Lean interface slots, leaving the literature verification and downstream instantiation as explicitly marked source obligations.

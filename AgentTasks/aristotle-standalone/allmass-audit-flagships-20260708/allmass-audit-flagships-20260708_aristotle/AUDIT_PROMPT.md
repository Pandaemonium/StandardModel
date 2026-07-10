# Adversarial over-claim audit of the all-mass run's landed flagships

You are the program's toughest internal auditor. This is an AUDIT job (no proof
required): the `src/` directory contains the verbatim Lean source of five landed,
kernel-checked, guard-pinned "flagship" results from a finite mathematical-physics
program (*mass is the obstruction to coherent null transport*). Every one has
passed the Lean kernel and is axiom-pinned to `[propext, Classical.choice,
Quot.sound]`. **The kernel guarantees the proofs are valid; it does NOT guarantee
the statements are the intended mathematics.** Your job is to find where, if
anywhere, a statement claims more than it proves.

## The five flagships (in `src/`)

1. `SectorGroundMassWitness.lean` — `T2_positive_mass`: an explicit two-edge Cl(4)
   carrier whose `J`-positive sector form `M6 = 1 + BᴴB` is positive-definite, so
   the Rayleigh keystone `sector_ground_mass` fires to give a positive squared mass
   at couplings `(λ,κ)=(2,1)`.
2. `MassGapWitness.lean` — the parametrized `3×3` block `B(λ,κ)`: spectrum
   `{λ−κ,λ,λ+κ}`, `PosDef ↔ |κ|<λ`, massless line `κ=±λ` (λ>0), least eigenvalue
   `λ−κ`; plus the carrier bridge `M6 = B(2,1) ⊕ B(2,-1)` (top/bot/off block lemmas).
3. `CarrierUnitaryFlow.lean` — the carrier flow `exp(-i t H)` is unitary
   (`hermitian_flow_mem_unitaryGroup`), a `LinearIsometryEquiv`
   (`hermitian_flow_isometry`), and the real carrier orbit conserves norm/energy
   (`carrier_orbit_norm_conserved`).
4. `FreeMassBridge.lean` — `free_mass_operator_eq_plucker`: the free carrier mass
   operator `P · adjugate P = det P • 1 = |ψ∧φ|² • 1` (the free operator mass IS
   the §3 kinematic mass).

## Audit each against the four over-claim modes

For **every** theorem in `src/` (name it, quote the Lean statement), classify it
against these failure modes and give a verdict (CLEAN / MINOR / LOAD-BEARING):

- **Vacuity** — are the hypotheses satisfiable by an explicit witness, or could the
  theorem be vacuously true (e.g. an empty/degenerate sector, an isometry that is
  secretly trivial, a `PosDef` on a zero space)?
- **Hollow telescoping** — is a triviality dressed as depth (e.g. a generic Mathlib
  fact renamed to sound physical; `carrier_orbit_norm_conserved` applied to *any*
  isometry)? Where does the real content live?
- **Docstring-outruns-kernel** — does any docstring / theorem name claim more than
  the statement proves (e.g. "the carrier's mass gap" when only a `3×3` block's
  spectrum is proved; "generalizes to the whole plane" when only a fixed point is
  tied to the carrier)?
- **False shape** — is a kernel-checked statement subtly NOT the intended
  mathematics (wrong sector, wrong inner product, wrong sign/convention, a mirror
  block mistaken for the whole form, Euclidean vs Krein inner product confusion)?

## Specific probes (be adversarial)

- `MassGapWitness.B` vs `SectorGroundMassWitness.M6`: is the bridge
  `M6_topBlock_eq_B` genuinely the *physical* sector form, and is the general-`(λ,κ)`
  reduction honestly quarantined as oracle-grade (not kernel)?
- `CarrierUnitaryFlow`: is the flow on `EuclideanSpace ℂ (Fin 3)` (a *positive*
  inner product) an honest model of the carrier's evolution, given the carrier lives
  in a *Krein* (indefinite) space elsewhere in the program? Is calling this "D2 fires
  on the actual carrier" earned, or is it norm-unitarity on a first-quantized
  Euclidean sector that is quietly not the Krein evolution?
- `T2_positive_mass`: is `M6 = 1 + BᴴB` the actual compressed Krein form, or is the
  positivity built in by the `1 + BᴴB` shape (which is *automatically* PosDef)? If
  the latter, what is the real content — that the compression *has* this shape?

## Required output

- A per-theorem table: name, one-line intended reading, verdict (CLEAN / MINOR /
  LOAD-BEARING), and for anything not CLEAN, the precise mismatch.
- **The single most load-bearing over-claim** across all five files, if any, stated
  sharply with the exact remedy (a statement change, a docstring regrade, or a new
  lemma needed).
- If everything is genuinely clean, say so and say exactly what you verified.

One correct load-bearing finding is worth more than ten generic cautions. Report
even if the news is that it is all honest.

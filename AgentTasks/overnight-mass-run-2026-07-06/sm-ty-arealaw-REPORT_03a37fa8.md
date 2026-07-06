# Tomboulis–Yaffe area-law bound on the `Z2` Wilson slab — report

New file: `TYAreaLaw.lean`, namespace
`PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw`. It builds and type-checks against
Mathlib (`leanprover/lean4:v4.28.0`) with **no `sorry`, no `axiom`, no
`native_decide`**; every listed theorem uses only the standard axioms
`propext`, `Classical.choice`, `Quot.sound`.

## Build / self-containment note

The three attached files (`SlabClustering.lean`, `TwoStateTransferSpectrum.lean`,
`TwoStateTransferZ2Sector.lean`) import upstream modules
(`PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1`, `OSReconstruction`,
`TransferGapDefinition`, `SlabTransferGap`) that are **not present in this
repository snapshot**, so they do not compile here (this is pre-existing and
unrelated to the new file). To keep the deliverable self-contained and honest,
`TYAreaLaw.lean` therefore imports **only Mathlib**, and reproduces the small
amount of landed structure it ties back to (the `tanh β` spectral ratio and the
spectral gap) as local definitions, documenting the correspondence.

## Model and provenance

- `Z ∝ Zplus β = e^β + e^{-β}` (periodic-BC one-plaquette sum), matching the
  landed `lambda0 β = 2·Zplus β`.
- `Z⁻ ∝ Zminus β = e^β − e^{-β}` (antiperiodic / 't Hooft-twisted sum), matching
  the landed `lambdaFlux β = 2·Zminus β`.
- `partitionRatio β = Z⁻/Z = tanh β`; `tyBase β = (1/2)(1 − tanh β)`.

## Deliverables and status

Fully proved:

1. `tyBaseOf`, `tyStringTensionOf` (abstract) and `Zplus`, `Zminus`,
   `partitionRatio`, `tyBase`, `tyStringTension`, `slabSpectralGap` (concrete).
2. `partitionRatio_pos`, `partitionRatio_nonneg`, `partitionRatio_lt_one`,
   `partitionRatio_mem_Ico` — `0 ≤ Z⁻/Z < 1`; and `tyBase_pos`,
   `tyBase_lt_half`, `tyBase_mem_Ioo` — `0 < tyBase β < 1/2` for `β > 0`.
3. `tyStringTension_pos` — strictly positive area-law rate; `tyBase_eq_exp_neg`
   / `tyBaseOf_eq_exp_neg` — the read-off `tyBase = exp(−tyStringTension)`;
   `tyBaseOf_rpow_eq_exp` — `(tyBase)^r = exp(−r·tyStringTension)`.
4. Area law: `tyAreaLaw` / `tyAreaLaw_slab` derive
   `|W| ≤ 2·(tyBase β)^r` from the RP/Cauchy–Schwarz input
   (`hq : q ≤ tyBase β`, `hW : |W| ≤ 2·q^r`) via `rpow` monotonicity;
   `tyAreaLaw_exp` / `tyAreaLaw_slab_exp` give the non-vacuous positive-rate form
   `0 < tyStringTension β ∧ |W| ≤ 2·exp(−(r·tyStringTension β))`.
5. BC-insensitivity: `tyStringTensionOf_tendsto_atTop` proves that as
   `partitionRatio → 1⁻` the rate `→ +∞`; `tyStringTension_eq_tanh` gives the
   explicit `−log((1 − tanh β)/2)`; `partitionRatio_eq_exp_neg_slabGap` ties
   `Z⁻/Z = exp(−slabSpectralGap β)` to the landed `osSpectralGap` /
   `neU4ClosureGap` / `fluxGap` (all equal to `−log(tanh β)`).

Modeled (explicit hypotheses, deliberately not proved here):

- The reflection-positivity / Cauchy–Schwarz raw bound `|W| ≤ 2·q^r` with
  per-cell factor `q ≤ tyBase β` (hypotheses `hW`, `hq`). This is the genuine RP
  input; the file packages it into the stated area-law shape but does not derive
  it from a lattice measure.
- The identification of `Z`, `Z⁻` with the one-plaquette Boltzmann sums.

## Generalisation to SU(N)

The abstract layer (`tyBaseOf`, `tyStringTensionOf`, `tyAreaLaw`,
`tyAreaLaw_exp`, `tyStringTensionOf_tendsto_atTop`) is stated for an arbitrary
partition ratio `p` with `0 ≤ p < 1`. The SU(N) statement (Kanazawa Thm 2) is a
drop-in: replace `partitionRatio` by `(1/N)·Σ_k Z^{[k]}/Z`; all abstract lemmas
apply unchanged.

## Remaining gap to the genuine SU(2) statement

1. Construct the actual lattice gauge measure and derive the RP/Cauchy–Schwarz
   inequality (currently hypothesis `hW`) rather than assuming it.
2. Define `Z`, `Z⁻` as true partition functions of that measure and prove the
   `tanh β` ratio (currently a model) from first principles.
3. Replace the center ratio by the full `(1/N)·Σ_k Z^{[k]}/Z` and the abelian
   `Z2` slab by the nonabelian single gate.

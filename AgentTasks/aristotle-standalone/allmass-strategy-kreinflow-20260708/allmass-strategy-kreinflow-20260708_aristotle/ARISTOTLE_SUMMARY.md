# Summary of changes for run 6aee7b2f-ba01-452e-8de7-3cbf44a3eda1
Closed the audited static-vs-dynamical gap for the carrier Krein flow. All new results are in `src/CarrierKreinFlow.lean` (imports Mathlib + `src.SectorGroundMassWitness`, reusing the witness objects `HAC`, `Jmet`, `Piso`, `M6`). The file builds cleanly with no `sorry`/`admit`/`native_decide`/new `axiom`, and every result is kernel-checked with footprint `[propext, Classical.choice, Quot.sound]` (verified in-file via `#print axioms` guards). No existing statement was weakened.

Verdict on the two witness identities — both are TRUE (no failing entry):
1. `HAC_Jmet_selfAdjoint : Jmet * HAC = HACᴴ * Jmet` — `HAC` is Krein-(`Jmet`-)self-adjoint. (`HAC` is Hermitian and block-diagonal over the four Clifford blocks; `Jmet` is a constant ±1 on each block, so it commutes with `HAC`. No sign/convention fix needed.)
2. `HAC_sector_invariant : HAC * Piso = Piso * (Pisoᴴ * HAC * Piso)` — the `J`-positive sector `range Piso` is `HAC`-invariant (with restriction `M6`).

General reusable lemma (target 3):
- `J_selfAdjoint_flow_J_unitary`: for any `J H` with `J*J = 1` and `J*H = Hᴴ*J`, the flow `U = exp(-i t H)` is `J`-unitary, `Uᴴ*J*U = J` — via `gen_Jmet_anticomm` (`J A = -Aᴴ J`), `Matrix.exp_conj`, and `Matrix.exp_conjTranspose`. (Hermiticity of `J` turned out unnecessary and was dropped, giving a cleaner statement; it still holds on the witness.)
- `exp_intertwine`: `X*P = P*Y ⇒ exp X * P = P * exp Y` (even for rectangular `P`) — from `X^k*P = P*Y^k` by pushing left/right multiplication through the exponential power series.
- `flow_intertwine`: subspace invariance `H*P = P*M` lifts to `exp(-i t H)*P = P*exp(-i t M)`.

Assembled consequences on the witness:
- `HAC_flow_Jmet_unitary (t) : (exp(-i t HAC))ᴴ * Jmet * (exp(-i t HAC)) = Jmet`.
- `HAC_flow_sector_invariant (t) : exp(-i t HAC) * Piso = Piso * exp(-i t M6)`.

Together with the existing static identity `sector_krein_form_eq_one`, these upgrade the sector orbit from Euclidean-norm-conserving to Krein-form-conserving and sector-preserving, closing the dynamical half for this witness. `ARISTOTLE_SUMMARY.md` records the statements, proof routes, and an honest scope note (these certify the specific witness and the `HAC`-generated flow; identifying that flow with the manuscript's physical Krein evolution remains the separate grade-C generator-as-Hamiltonian posit). The general lemmas are dimension-agnostic and reusable.

Note: the sibling `src/CarrierUnitaryFlow.lean` was already failing before this work (it imports project modules `...Carrier.MassGapWitness` and `...Carrier.FiniteUnitaryEvolution` that are absent from this checkout); it was left untouched and is unrelated to these results.

# Closing the static-vs-dynamical gap for the carrier Krein flow

All new results live in `src/CarrierKreinFlow.lean` (namespace
`PhysicsSM.Draft.NullEdge.Carrier.CarrierKreinFlow`). The file imports Mathlib and
`src.SectorGroundMassWitness` and reuses the witness objects `HAC`, `Jmet`,
`Piso`, `M6` together with `Jmet_sq`, `compression_eq`, etc. defined there. No
existing statement was weakened.

Every new theorem is kernel-checked with footprint
`[propext, Classical.choice, Quot.sound]` (verified in-file by `#print axioms`
guards; no `sorry`/`admit`/`native_decide`/new `axiom`).

## Verdict on the two witness identities

Both audited identities are **TRUE** on the concrete witness — no failing entry.

* **(1) `HAC` is `Jmet`-self-adjoint.** `HAC_Jmet_selfAdjoint : Jmet * HAC = HACᴴ * Jmet`.
  Mechanism: `HAC` is Hermitian and block-diagonal over the four 3-dimensional
  Clifford blocks, while `Jmet` is constant (a scalar `±1`) on each such block, so
  `Jmet` commutes with `HAC`; combined with `HACᴴ = HAC` this gives the stated
  Krein-self-adjointness. (No sign/convention fix was needed.)

* **(2) `range Piso` is `HAC`-invariant.**
  `HAC_sector_invariant : HAC * Piso = Piso * (Pisoᴴ * HAC * Piso)`.
  Mechanism: `Piso` selects coordinates `{3,4,5,9,10,11}` (Clifford blocks 1 and
  3); `HAC` maps each of those blocks into itself, so it preserves the sector, and
  the restriction is exactly `M6 = Pisoᴴ HAC Piso`.

Both are finite matrix identities, discharged entrywise (`ext` + `fin_cases` +
`simp`; target (2) is routed through the existing `compression_eq`).

## The general reusable lemma (target 3, cleanest first win)

`J_selfAdjoint_flow_J_unitary`
: for any `J H : Matrix n n ℂ` with `J * J = 1` and `J * H = Hᴴ * J`, the flow
`U = exp(-i t H)` is `J`-unitary: `Uᴴ * J * U = J`, for every `t : ℝ`.

Proof route (as intended, via `Matrix.exp_conj` / `Matrix.exp_conjTranspose`):
* `gen_Jmet_anticomm` : the generator `A = (-t) • (i • H)` satisfies `J A = -Aᴴ J`;
  hence `J A J = -Aᴴ` (using `J² = 1`).
* `Matrix.exp_conj` gives `exp(J A J) = J U J`, so `J U J = exp(-Aᴴ)`.
* `Matrix.exp_conjTranspose` gives `Uᴴ = exp(Aᴴ)`, and `exp(Aᴴ)·exp(-Aᴴ) = 1`.
* Assembling: `Uᴴ (J U J) = 1`, and right-multiplying by `J` (with `J² = 1`) yields
  `Uᴴ J U = J`.

`Jmet` is not assumed Hermitian in the lemma (it is not needed — `J² = 1` and the
intertwining suffice); Hermiticity of `Jmet` still holds on the witness.

## Assembled consequences on the witness

* `HAC_flow_Jmet_unitary (t : ℝ) : (exp(-i t HAC))ᴴ * Jmet * (exp(-i t HAC)) = Jmet`
  — the Krein flow of `HAC` is `Jmet`-unitary. (Instantiates the general lemma with
  `Jmet_sq` and `HAC_Jmet_selfAdjoint`.)

* `exp_intertwine` : if `X * P = P * Y` (with `P` possibly rectangular) then
  `exp X * P = P * exp Y`. Proved from `X^k * P = P * Y^k` (induction) by pushing
  left/right multiplication (as continuous linear maps) through the exponential
  power series (`NormedSpace.exp_series_hasSum_exp'`, `HasSum.mapL`,
  `HasSum.unique`).

* `flow_intertwine` : subspace invariance `H * P = P * M` lifts to the flow,
  `exp(-i t H) * P = P * exp(-i t M)`.

* `HAC_flow_sector_invariant (t : ℝ) :`
  `exp(-i t HAC) * Piso = Piso * exp(-i t M6)` (with `M6 = Pisoᴴ HAC Piso`) — the
  Krein flow preserves the `J`-positive sector `range Piso`, with compressed
  generator `M6`.

## What this does and does not establish

* **Establishes (kernel-certified).** On this concrete witness, `HAC` is genuinely
  Krein-self-adjoint and the `J`-positive sector `range Piso` is invariant under
  both `HAC` and its one-parameter flow `exp(-i t HAC)`; moreover that flow is
  `Jmet`-unitary. Combined with the pre-existing static identity
  `sector_krein_form_eq_one` (`Pisoᴴ Jmet Piso = 1`), this upgrades the sector
  orbit from merely Euclidean-norm-conserving to **Krein-form-conserving and
  sector-preserving**: the flow keeps states on the physical sector, where the
  Krein form and the Euclidean inner product coincide. This closes the dynamical
  half flagged by the audit for this witness.

* **Does not establish.** These are statements about the specific hand-typed
  witness `HAC`/`Jmet`/`Piso` and about the flow generated by `HAC` (equivalently
  its sector compression `M6`); they do not by themselves certify that this flow is
  the manuscript's physical Krein time-evolution — that identification remains the
  separate grade-C "generator-as-Hamiltonian" modeling posit noted in
  `CarrierUnitaryFlow`. The general lemma `J_selfAdjoint_flow_J_unitary` /
  `exp_intertwine` / `flow_intertwine` are dimension-agnostic and reusable beyond
  the witness.

## Build note

`src/CarrierKreinFlow.lean` builds cleanly (kernel-checked, no `sorry`). The
sibling `src/CarrierUnitaryFlow.lean` was already failing before this work because
it imports project modules absent from this checkout
(`...Carrier.MassGapWitness`, `...Carrier.FiniteUnitaryEvolution`); it was left
untouched and is unrelated to these results.

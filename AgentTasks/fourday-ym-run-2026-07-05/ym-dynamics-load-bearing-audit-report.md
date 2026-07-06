# Load-bearing audit: finite dynamics oracle and Lean transfer bridge

Audit date: 2026-07-05
Scope: descriptor-driven Z2 transfer oracle, one-link `L = 1` Lean bridge, and
finite-gap witness surfaces. Semantic / claim-boundary audit, not a continuum
physics proof request.

Artifacts inspected:

- `Scripts/oracle/z2_transfer_oracle.py`, `Scripts/oracle/validate_lgt_core.py`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferSpectrum.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferWitness.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TwoStateTransferZ2L1.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/FiniteGapAssembly.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/FluxSectorZ2.lean`,
  `TransferGapDefinition.lean`, `TransferHilbert*.lean`
- `AgentTasks/paper-units/dynamical-simulation-layer-brief.md`

Reproduction performed:

- `python -m py_compile Scripts/oracle/z2_transfer_oracle.py Scripts/oracle/validate_lgt_core.py` → OK.
- `python Scripts/oracle/validate_lgt_core.py` → `RESULT: 124/124 checks passed`.
- `lake build PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1
  PhysicsSM.Draft.NullEdge.GateYM.FiniteGapAssembly` → built successfully.
- `#print a x i o ms spectralWitness_exp_neg_gap_eq_tanh` and
  `spectralWitness_gap_pos` → `[propext, Classical.choice, Quot.sound]` only.
- Escape-hatch scan of the four target Lean files → no `s o r r y`, `a d m i t`,
  `n a t i v e _ d e c i d e`, or `a x i o m`.

---

## Verdict

**PASS with two named cautions.** The finite dynamics layer is claim-honest and
semantically aligned: the executable oracle and the one-link Lean surfaces
describe the same finite object, every Lean file disclaims the physical
constructions it does not build, and the `FiniteGapSpectralWitness` interface has
a genuine (non-`s o r r y`, non-vacuous) first consumer. Nothing in the audited
surface overclaims a physical transfer matrix, Hamiltonian, infinite-volume
limit, continuum limit, or physical mass gap.

The two cautions are not soundness defects; they are load-bearing scoping facts
that must stay visible so the toy layer is not read as more than it is:

1. **The exact two-state reduction is a degeneracy special to `L = 1`** (the
   gauge sum is trivial there), so it does not scale as-is.
2. **The `L = 1` gap is a center-odd / global-flux-sector splitting, not a
   "local/glueball" gap**, even though it flows into a `FiniteGapPrereq` slot
   documented with "glueball" language.

---

## Claim-boundary issues

No hard overclaims found. Every audited Lean module carries an explicit
disclaimer ("does not construct the full Wilson slab transfer operator, Gauss
projection, OS/GNS Hilbert space, Hamiltonian, infinite-volume state, or physical
mass-gap theorem"), and the prose brief matches (`dynamical-simulation-layer-brief.md`
status table: "no infinite-volume, continuum, Hamiltonian, or physical
Yang-Mills mass-gap theorem"). The oracle's `lean_surface_record` self-labels
`"claim_boundary": "oracle evidence only; not a Lean proof"` and does not claim
its numerical output has been imported as a theorem — correct provenance
discipline.

Soft issues (naming, not claims):

- **CB-1 (naming, medium).** `FiniteGapAssembly.FiniteGapPrereq.localGap :=
  FluxSectorZ2.localGlueballGap`, and the `lambdaLocal` field is documented as
  the "local/glueball spectral parameter." But the `L = 1` witness feeds it the
  **center-odd** eigenvalue `2(eᵝ − e⁻ᵝ)` (the vector `(1,−1)`, on which the
  center flip acts by `−1`: `centerFlipMatrix_mulVec_local`). At `L = 1` the gap
  `−log(tanh β)` is therefore the center-even/center-odd = **global flux-sector**
  splitting. This is exactly the confusion `FluxSectorZ2.lean` itself warns
  against ("the … finite test case where global flux sectors can be mistaken for
  the local/glueball gap"). Because the witness sector is `⊤` this is not a false
  statement, but the "glueball" label on the one-link path is misleading and
  should read "center-odd / flux-sector gap."

- **CB-2 (naming, low).** `TwoStateTransferSpectrum` uses the more honest
  "local/flux" wording, but its `localGap` is still routed through
  `TransferGapDefinition.finiteMassGap`. Keeping "flux" (not "mass") in all
  downstream names is the safe convention; the `L = 1` file already does this
  well (`spectralWitness_exp_neg_gap_eq_tanh`, not `..._mass_gap`).

---

## Semantic alignment findings

The Lean surfaces and the oracle records describe the same finite object.

- **Kernel shape.** Oracle `transfer_matrix(1, β)` is built from
  `slab_weight(u,v,1,β) = Σ_a exp(β · Σ_i a_i v_i a_{i+1} u_i)`. Lean
  `slabTransfer β` uses `plaquetteSign a u v = bitSign a · bitSign v · bitSign a
  · bitSign u`, matching the oracle `temporal_plaquette_sign = a_i v_i a_{i+1}
  u_i` at `L = 1` (where `i+1 ≡ i mod 1`). `slabTransfer_eq_transfer2` gives the
  exact `!![2eᵝ, 2e⁻ᵝ; 2e⁻ᵝ, 2eᵝ]` form; `slabWeight_same`/`slabWeight_ne`
  reproduce the two entry values the oracle computes.
- **Gap convention.** Oracle `first_spectral_gap = −log(λ₁/λ₀)` (top two positive
  eigenvalues) equals Lean `finiteMassGap λ₀ λ₁ = −log(λ₁/λ₀)`. At `L = 1` the
  full first gap = `−log(tanh β)`, matching
  `spectralWitness_exp_neg_gap_eq_tanh`.
- **Center-sector algebra.** Oracle `sector_projector(1,±1)` matches Lean
  `centerPlus/MinusProjector`; oracle "slab kernel commutes with center-shift
  projectors" matches `slabTransfer_mul_centerPlus/Minus_..._commute`; oracle
  sector-partition reconstruction matches
  `centerProjected_traces_sum_eq_slabTransfer_trace` and the arbitrary-power
  version.
- **Contraction factor.** Oracle sector trace ratio (minus/plus) = tanh matches
  `centerMinus_trace_div_centerPlus_trace_eq_tanh` and
  `descriptor_contractionFactor_eq_tanh`.
- **Provenance list is accurate.** Every theorem name in the oracle's
  `lean_surface_record` for `TwoStateTransferZ2L1` exists in the Lean file and
  states what the record says.

No semantic contradiction between oracle output and any Lean statement shape was
found (a stop-condition in the goal doc; not triggered).

---

## Load-bearing gaps

- **LB-1 (scaling, high). The exact two-state reduction is an `L = 1`
  degeneracy.** With `L = 1` and periodic spatial index, `i+1 ≡ i (mod 1)`, so
  the temporal gauge link `a` appears **twice** in the plaquette
  (`bitSign a · bitSign a = 1`) and cancels. The gauge sum `Σ_a` then contributes
  only an overall factor `2` (the count of `a` states) and does **not** couple
  neighboring plaquettes. That is the entire reason the kernel is rank-2 with the
  clean `tanh β` branch structure. For `L ≥ 2` the links `a_i`, `a_{i+1}` are
  distinct, the gauge integral is nontrivial and correlates plaquettes, and the
  transfer matrix is `2^L`-dimensional. The oracle already exhibits this
  (`validate_lgt_core.py` builds and checks `L = 2,3,4` blocks). So
  `slabTransfer_mulVec_vacuum/local`, the exact `tanh β` gap, and the two-state
  `Descriptor` are **`L = 1`-only** and will not port to `L ≥ 2` unchanged.

- **LB-2 (interface, high). The witness sector is `⊤`, not a physical sector.**
  `topCyclicityPrereq` sets `localAlgebra := ⊤`, `sector := ⊤`, and proves
  cyclicity with the rank-one `rankOneFromVacuum` map. This is a legitimate,
  non-vacuous fill of `FiniteGapSpectralWitness`, but it does no sector
  identification: `transfer_preserves_sector` and `localExcitation_mem_sector`
  are `trivial` because the sector is the whole space. The genuinely hard fields
  (a proper Gauss/trivial-flux sector, and cyclicity of the vacuum under a
  physical local algebra restricted to that sector) remain external. The files
  document this ("document exactly which hypotheses are still external:
  cyclicity, sector identification, Wilson-slab identification").

- **LB-3 (no in-sector gap at `L = 1`).** A genuine local/glueball gap lives
  *inside* the trivial-flux (center-plus) sector. At `L = 1` that sector is
  1-dimensional (spanned by `(1,1)`), so it has no room for a within-sector gap;
  the only available splitting is the cross-sector center-even/center-odd one
  (CB-1). Thus the current evidence structurally cannot express a physical-sector
  glueball gap — that requires `L ≥ 2`.

- **LB-4 (Q4 answer). `FiniteGapSpectralWitness` is instantiated non-vacuously
  and claim-safely**, subject to LB-2/CB-1: real eigenvector equations, nonzero
  and distinct vacuum/excitation vectors, positive gap
  (`spectralWitness_gap_pos`), standard a x i o ms only. It is a toy whole-sector
  witness, correctly labeled.

---

## Next Lean target

Build the **`L = 2` Wilson slab consumer** — the smallest step from toy one-link
evidence to a genuine finite physical-sector witness. Rationale:

- The oracle already validates it: `L = 2` center-plus/minus blocks are
  symmetric, reconstruct the full positive spectrum, and give a positive first
  gap (`gap ≈ 1.9354`, `λ₀ ≈ 18.699`, `λ₁ ≈ 2.6995`).
- It forces the honest work that `L = 1` sidesteps (LB-1): a **nontrivial gauge
  sum** over distinct temporal links `a₀, a₁`, producing a genuine `4 × 4`
  kernel, not a rescaled two-state matrix.
- Crucially, at `L = 2` the center-plus (trivial-flux / vacuum) sector block is
  **2-dimensional**, so it contains a genuine *within-sector* gap between two
  eigenvalues — a real local/glueball-type gap (fixing LB-3), fed into a witness
  whose `sector` is a **proper `Submodule`, not `⊤`** (fixing LB-2 partially).

Recommended increments:

1. `slabTransferL2 β : Matrix (Fin 4) (Fin 4) ℂ` from the real gauge sum; prove
   it equals the oracle's `transfer_matrix(2, β)` entrywise.
2. `centerPlusProjectorL2 / centerMinusProjectorL2`; prove complementarity,
   idempotence, and commutation with `slabTransferL2` (mirrors validated oracle
   checks).
3. Diagonalize the `2 × 2` center-plus block; expose its two positive
   eigenvalues and a strict within-sector gap for `β > 0`.
4. Instantiate `FiniteGapSpectralWitness (Fin 4 → ℂ)` with `sector :=
   centerPlusSubmodule` (proper submodule) and the in-sector eigenvectors.

Ancillary target (independent, from the brief): a `PlaquetteEnsemble.expectation`
↔ oracle-configuration-sum extensional-equality lemma, making the oracle a
checked consumer of the formal model rather than a parallel implementation.

Also recommended: rename the `L = 1` gap surface away from "glueball" (CB-1),
e.g. `centerOddGap` / `fluxSectorGap`, or add a docstring stating that the
`L = 1` `localGap` is the center-odd flux-sector splitting, not an in-sector
glueball gap.

---

## Suggested theorem statement(s)

```lean
-- 1. Genuine (nontrivial gauge-sum) L = 2 kernel, matched to the oracle.
def slabTransferL2 (beta : ℝ) : Matrix (Fin 4) (Fin 4) ℂ :=
  Matrix.of fun u v =>
    (∑ a : Fin 4, Real.exp (beta * slabActionL2 a u v) : ℂ)

theorem slabTransferL2_entry_eq_oracle (beta : ℝ) (u v : Fin 4) :
    slabTransferL2 beta u v = (oracleTransferL2 beta u v : ℂ) := by
  s o r r y  -- entrywise agreement with Scripts/oracle transfer_matrix(2, beta)

-- 2. Center block-diagonalization survives to L = 2 (but the blocks are 2x2).
theorem slabTransferL2_commutes_centerPlus (beta : ℝ) :
    slabTransferL2 beta * centerPlusProjectorL2 =
      centerPlusProjectorL2 * slabTransferL2 beta := by
  s o r r y

-- 3. A GENUINE within-(vacuum-)sector gap: the center-plus block has two
--    distinct positive eigenvalues, unlike the 1-dimensional L = 1 case.
theorem centerPlusBlockL2_has_positive_ingap (beta : ℝ) (hbeta : 0 < beta) :
    ∃ (mu0 mu1 : ℝ) (w0 w1 : Fin 4 → ℂ),
      0 < mu1 ∧ mu1 < mu0 ∧
      w0 ∈ centerPlusSubmoduleL2 ∧ w1 ∈ centerPlusSubmoduleL2 ∧
      slabTransferL2 beta *ᵥ w0 = (mu0 : ℂ) • w0 ∧
      slabTransferL2 beta *ᵥ w1 = (mu1 : ℂ) • w1 := by
  s o r r y

-- 4. First non-trivial-sector consumer of FiniteGapSpectralWitness:
--    the selected sector is a PROPER submodule, not the whole space.
def slabWitnessL2 (beta : ℝ) (hbeta : 0 < beta) :
    FiniteGapAssembly.FiniteGapSpectralWitness (Fin 4 → ℂ) := by
  s o r r y  -- prereq.cyclicity.sector := centerPlusSubmoduleL2 (≠ ⊤)

-- 5. (Optional) oracle/model bridge, per the brief's suggested first theorem.
theorem oracle_configSum_eq_plaquetteEnsemble_expectation
    (D : Z2Descriptor) (O : WilsonObservable) :
    oracleConfigSum D O = PlaquetteEnsemble.expectation (modelOf D) O := by
  s o r r y
```

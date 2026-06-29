# Job C162 — Concrete null-edge point-split `W_branch` construction

Artifact: `RequestProject/Draft/NullEdgePointSplitWBranch.lean`
(Mathlib-only; builds clean, no `s o r r y`; only `propext`/`Classical.choice`/`Quot.sound`.)
Promotion target: `PhysicsSM/Draft/NullEdgePointSplitWBranch.lean`.

## Executive verdict

The C155 point-split / flavored / species-mass dictionary is now a **concrete,
machine-checked `W_branch` design** over an explicit null-edge branch hypercube,
not an abstract recipe. `W_branch` is built as a diagonal point-split operator
whose value at each branch corner is an amplitude `a` times the *product of
one-edge branch Pauli signs* — so it is honestly point-split, never an arbitrary
inserted matrix. The two structural facts the C159 import needs are proved:

1. the point-split `W_branch` **sign-straddles** once the amplitude exceeds the
   mass window (`|d − m0| < a`), and
2. a **constant scalar mass cannot sign-straddle** (and the zero-amplitude
   `W_branch` degenerates exactly to that constant case).

The construction is exposed to C159 through a single `BranchHamiltonianData`
record carrying the precise extra hypotheses needed to lift the finite branch
statement to `H_ne = Γ_K(D_ne + W_branch − m0 R)`. **No physical Gate-C1 claim is
made**; this job delivers only the `W_branch` construction and its sign-straddle
interface.

## Definitions / API

| Object | Lean | Meaning |
| --- | --- | --- |
| Branch hypercube corner | `BranchCorner n := Fin n → Bool` | a corner of the `n`-cube / BZ corner; each null edge occupied or empty |
| Reference corners | `emptyCorner`, `singleCorner i` | origin; the corner with only edge `i` occupied |
| Branch level | `branchLevel c` | number of occupied edges (`card` of the occupied filter) |
| Branch parity | `branchParity c : ZMod 2` | `Z/2` grading of the corner |
| One-edge branch Pauli sign | `edgeSign c i = if c i then -1 else 1` | the C145 single-direction Pauli seed |
| Corner sign | `cornerSign c = ∏ i, edgeSign c i` | C155 product of one-edge Pauli signs |
| Point-split `W_branch` | `Wbranch a c = a * cornerSign c` | diagonal point-split mass insertion |
| Shifted mass | `shiftedMass d a m0 c = d + Wbranch a c − m0` | diagonal of `D_ne + W_branch − m0 R` |
| Branch sign / `T_br` | `branchSign d a m0 c` | `sign` of the shifted mass at each corner |
| Branch projector | `branchProjPos d a m0 c` | spectral projector onto positive shifted mass |
| Sign-straddle | `SignStraddles f` | `(∃ c, 0 < f c) ∧ (∃ c, f c < 0)` |
| Interface record | `BranchHamiltonianData n` | named extra hypotheses + `signStraddles` consumer lemma |

## Theorems / proofs (all proved)

- `cornerSign_eq_neg_one_pow` : `cornerSign c = (-1) ^ branchLevel c` — the
  point-split product realises the parity grading.
- `cornerSign_emptyCorner` / `cornerSign_singleCorner` : `+1` on the origin,
  `−1` on a single-edge corner (the explicit sign-straddle witnesses).
- `Wbranch_signStraddles` : `0 < n` and `|d − m0| < a ⇒ SignStraddles
  (shiftedMass d a m0)`. Positive witness `emptyCorner` gives `(d−m0)+a > 0`;
  negative witness `singleCorner 0` gives `(d−m0)−a < 0`.
- `const_not_signStraddles` : a constant function never sign-straddles.
- `zeroAmplitude_not_signStraddles` : `Wbranch 0` collapses to the constant
  `d − m0`, hence cannot sign-straddle — the straddle truly needs nonzero
  point-split amplitude.
- `cornerSign_one_eq_edgeSign` : at `n = 1`, `cornerSign c = edgeSign c 0` (the
  C145 bridge).
- `BranchHamiltonianData.signStraddles` : the C159-facing consumer lemma.

## Relation to C155 / C145 / C138

- **C155** (point-split/flavored mass is the best concrete `W_branch`): this file
  *is* the concretisation. BZ corners → `BranchCorner`, corner parity → branch
  grading (`branchLevel`/`branchParity`), product of one-edge Pauli signs →
  `cornerSign`, point-split mass → `Wbranch`. "It sign-straddles; constant mass
  does not" is `Wbranch_signStraddles` + `const_not_signStraddles`.
- **C145** (one branch-direction Pauli seed): recovered as the `n = 1` slice via
  `cornerSign_one_eq_edgeSign`. The hypercube `W_branch` is the generalisation of
  the single branch-Pauli seed from one direction to all `n` directions, the
  corner sign being the tensor product of the per-direction Pauli signs.
- **C138** (finite seed lineage): consistent with the doctrine that the finite
  branch seed is the *input* to the import chain, not the physical release. The
  `BranchHamiltonianData` record makes the gap between finite seed and `H_ne`
  explicit rather than implicit.

## The exact extra hypotheses (finite → `H_ne = Γ_K(D_ne + W_branch − m0 R)`)

Recorded as fields of `BranchHamiltonianData n`:

1. `Dne_const` — `D_ne` acts as the constant `d` on the branch factor (diagonal
   in / commuting with the branch grading), so it contributes a corner-independent
   shift.
2. `R_id` — the chirality/regulator `R` acts as the identity on the branch
   factor, so `m0 R` contributes the constant `m0` (the C157 internality flavor).
3. `gammaK_sign_preserving` — conjugation by `Γ_K` preserves the sign of the
   branch-diagonal shifted mass, so `sign(H_ne)` restricted to the branch factor
   agrees with `branchSign`.
4. `branch_window` — the mass-window inequality `|d − m0| < a`.
5. `branch_nontrivial` — at least one branch direction (`0 < n`).

Given these, `BranchHamiltonianData.signStraddles` delivers the sign-straddling
seed `T_br` restricted to the branch factor without any further assumption.

## Integration advice (for C159 import)

- Consume the seed through `BranchHamiltonianData.signStraddles`; do not re-derive
  the straddle inside the import. Supply `(d, a, m0)` from the genuine
  branch-diagonal contributions and discharge the five fields above.
- Fields 1–3 are *placeholders for genuine operator statements*: when the import
  has concrete `D_ne`, `R`, `Γ_K`, replace the `Prop` fields with the real
  operator identities and adjust `gammaK_sign_preserving` into the lemma that
  ports `branchSign` to `sign(H_ne)|_branch`. The finite straddle is already
  a x i o m-clean; only these bridge lemmas remain operator-level work.
- The straddle is *necessary, not sufficient*: per the claim boundaries it must
  still be combined with the C160 mass-window/gap package, C154 sector-signature
  match, the gapped homotopy, and the anomaly/ghost/control certificates before
  any `GateC1_NU` statement. Keep `T_br = sign(H_ne)` gated behind the C160
  hypotheses.
- For SM gauge safety, pair `R_id`/`Dne_const` with C157 `SMActsInternally`
  (every generator `= id_B ⊗ g_i`); if gauge mixes branch `J`, the native mode
  fails and this seed does not apply.

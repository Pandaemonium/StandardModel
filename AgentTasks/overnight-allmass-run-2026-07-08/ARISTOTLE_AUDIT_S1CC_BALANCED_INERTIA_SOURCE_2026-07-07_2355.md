# Aristotle audit job - S1-CC balanced-inertia source audit 2026-07-07 23:55 PDT

```yaml
aristotle:
  project_id: 283e0e8d-16d0-4e51-a385-517f2e4a01eb
  task_id: 82ac655a-985f-4a6a-9451-2fc0a522fc9a
  target_file: PhysicsSM/Draft/NullEdge/GateYM/S1CCBalancedInertia.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia
  submission_project: none
  output_dir: AgentTasks/aristotle-output/283e0e8d-16d0-4e51-a385-517f2e4a01eb-extracted/82ac655a-985f-4a6a-9451-2fc0a522fc9a_aristotle
  status: harvested_COMPLETE
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_S1CC_BALANCED_INERTIA_SOURCE_2026-07-07_2355.md)
```

## Prompt

You are Aristotle, asked for a source-aware semantic audit, not a proof attempt.

Context: another agent landed the S1-CC balanced-inertia algebraic rungs during
the overnight all-mass run. These declarations are important because the docs now
describe the S1-CC positivity question as resolved into a signed/balanced
closure channel rather than true positivity. The Lean file is supposed to prove
only finite matrix algebra rungs:

- odd powers have zero trace under anticonjugation;
- the characteristic polynomial is invariant under negation under the same
  anticonjugation;
- a 2-by-2 block constraint charge is nilpotent iff both products vanish.

The physical identification of `B = J Q_C`, preservation of the physical sector,
the quotient `V'/N`, and the final Hermitian inertia count are supposed to remain
MEMO / future Lean rungs unless separately proved.

Please audit the source below for:

1. Whether each Lean theorem proves the advertised finite algebra statement.
2. Whether the docstrings overclaim by saying "spectrum symmetric",
   "balanced inertia", or "resolved" more strongly than the theorem statements
   justify.
3. Whether `anticonj_charpoly_eq` is stated in the correct direction and whether
   it is enough as the next rung toward eigenvalue-pairing for Hermitian `B`.
4. Whether `half_constraint_rigidity` exactly matches the claimed block-matrix
   square statement over an arbitrary ring.
5. What exact next Lean theorem should be packaged for Aristotle to bridge from
   `charpoly` symmetry to balanced inertia, with minimal semantic risk.

Source:

```lean
/-
# S1-CC: closure is balanced (not positive) on the physical sector

DRAFT (kernel-clean; no `s o r r y`). The kernel core of the Fable call-01
resolution of the central positivity crux (S1-CC), overnight all-mass run
2026-07-08. The full analysis is in the call log
(`AgentTasks/model-calls/claude/2026-07-07-231939-fable-call-01.md`,
Part B) and summarized in the QCD roadmap.

## The finding (grade MEMO for the physics, M for this file)

The nonabelian closure channel is an exact Krein square `Q_C = L^# L`
(kernel-checked elsewhere), but Krein squares carry no positivity. The
crux "is closure positive on the physical sector `V'/N`?" is resolved:
**no - it is exactly BALANCED (Krein signature zero), structurally.** The
mechanism is a grading anticonjugation: the closure bivector
`b = sigma_z (x) 1` satisfies `b^{-1} (J Q_C) b = -(J Q_C)` and preserves
every gauge-defined constraint sector (gauge acts on the color/site factor
alone, commuting with `b`). A matrix congruent to its own negative has
balanced inertia (`n_+ = n_-`). So closure positivity holds only vacuously
(flat Gauss sector); otherwise the channel is honestly signed - which is
exactly what chiral symmetry breaking needs (§8 of the manuscript).

## What this file proves (the house-style rung)

`anticonj_odd_pow_trace_zero`: if an invertible `S` anticonjugates `B`
(`S^{-1} B S = -B`), then every ODD power of `B` is traceless. This is the
spectral-symmetry engine behind the balanced inertia: all odd moments of
the Hermitian form vanish, so its eigenvalues are symmetric about zero. A
pure finite trace identity in the same register as `banks_casher_count` -
no inertia API, no spectral theorem. The inertia reading itself (via
`charpoly` congruence and Sylvester) and the concrete `V'` construction
are the next rungs (see the roadmap); this is the load-bearing algebra.

## Claim boundary

`anticonj_odd_pow_trace_zero` is kernel-checked (M). The identification of
`B = J Q_C` and `S = b` on the concrete carrier physical sector, and the
step from odd-moment-vanishing to balanced inertia, are MEMO (Fable Part
B), pending their own Lean rungs. No positivity is claimed; the point is
precisely that closure is NOT positive on the sector.

## Provenance

Fable-5 call-01 (2026-07-08), Part B - the crux resolution and the
recommended house-style rung - [orig]/[interp]; the trace-conjugation and
odd-power algebra is standard - [import].
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Trace is invariant under conjugation by an invertible matrix:
`Tr(S⁻¹ X S) = Tr X`. -/
theorem trace_invOf_conj (S X : Matrix n n ℂ) [Invertible S] :
    (⅟S * X * S).trace = X.trace := by
  rw [Matrix.trace_mul_comm, ← mul_assoc, mul_invOf_self, one_mul]

/-- Conjugation distributes over powers: `(S⁻¹ B S)^m = S⁻¹ B^m S`. -/
theorem conj_pow (S B : Matrix n n ℂ) [Invertible S] (m : ℕ) :
    (⅟S * B * S) ^ m = ⅟S * B ^ m * S := by
  induction m with
  | zero => simp
  | succ m ih =>
    rw [pow_succ, ih, pow_succ]
    have hreassoc : (⅟S * B ^ m * S) * (⅟S * B * S)
        = ⅟S * B ^ m * (S * ⅟S) * B * S := by noncomm_ring
    rw [hreassoc, mul_invOf_self, mul_one]
    noncomm_ring

/-- **Anticonjugation kills odd-power traces (S1-CC flagship).** If an
invertible `S` anticonjugates `B` (`S⁻¹ * B * S = -B`), then every odd
power of `B` is traceless: `Tr(B^(2k+1)) = 0`. The odd moments of the
associated Hermitian form all vanish, forcing a spectrum symmetric about
zero - the engine behind the BALANCED Krein inertia of the closure channel
on the physical sector (closure is signed, not positive). -/
theorem anticonj_odd_pow_trace_zero (B S : Matrix n n ℂ) [Invertible S]
    (h : ⅟S * B * S = -B) (k : ℕ) :
    (B ^ (2 * k + 1)).trace = 0 := by
  have h1 : ((-B) ^ (2 * k + 1)).trace = (B ^ (2 * k + 1)).trace := by
    rw [← h, conj_pow, trace_invOf_conj]
  have h2 : ((-B) ^ (2 * k + 1)).trace = -(B ^ (2 * k + 1)).trace := by
    rw [Odd.neg_pow ⟨k, rfl⟩, Matrix.trace_neg]
  have key : -(B ^ (2 * k + 1)).trace = (B ^ (2 * k + 1)).trace := h2 ▸ h1
  linear_combination (-(1 : ℂ) / 2) * key

/-- **Even-power form of the same fact:** for a self-adjoint `B` (`Bᴴ = B`)
that is anticonjugate to itself, the anticonjugation gives a spectrum
symmetric under negation. Recorded as the companion identity: `Tr B = 0`
(the `k = 0` case), the vanishing of the first moment. -/
theorem anticonj_trace_zero (B S : Matrix n n ℂ) [Invertible S]
    (h : ⅟S * B * S = -B) : B.trace = 0 := by
  have := anticonj_odd_pow_trace_zero B S h 0
  simpa using this

/-- **Spectrum symmetric under negation (the balanced-inertia essence).**
Anticonjugation `⅟S * B * S = -B` makes `B` similar to `-B`, so their
characteristic polynomials agree: `(-B).charpoly = B.charpoly`. Hence the
eigenvalue multiset of `B` is invariant under `lambda -> -lambda` - the
polynomial-level statement that the spectrum is symmetric about zero, from
which `n_+ = n_-` (balanced Krein inertia) follows for Hermitian `B` by
counting. This is the charpoly rung of the balanced-inertia theorem. -/
theorem anticonj_charpoly_eq (B S : Matrix n n ℂ) [Invertible S]
    (h : ⅟S * B * S = -B) : (-B).charpoly = B.charpoly := by
  rw [← h]
  exact Matrix.charpoly_units_conj' (unitOfInvertible S) B

/-! ## Lemma 1: the half-constraint rigidity (Gupta-Bleuler is forced) -/

/-- **Half-constraint rigidity (Fable call-01, Part B, Lemma 1).** For the
null pair `c₁ = E₀₁`, `c₂ = E₁₀` on the Clifford factor, a two-covector
constraint charge `Q = c₁ ⊗ G₁ + c₂ ⊗ G₂` (here the `2x2`-over-`B` matrix
`!![0, G₁; G₂, 0]`) is nilpotent iff `G₁ G₂ = 0` AND `G₂ G₁ = 0`. So a
NILPOTENT (BRST-type) Gauss charge on the hyperbolic pair cannot use both
null covectors nontrivially: the Gupta-Bleuler "impose only half the
constraint" is not a modeling choice - it is FORCED by nilpotency.
(`Q² = !![G₁G₂, 0; 0, G₂G₁]`.) -/
theorem half_constraint_rigidity {B : Type*} [Ring B] (G₁ G₂ : B) :
    (!![0, G₁; G₂, 0] : Matrix (Fin 2) (Fin 2) B) ^ 2 = 0
      ↔ G₁ * G₂ = 0 ∧ G₂ * G₁ = 0 := by
  have hsq : (!![0, G₁; G₂, 0] : Matrix (Fin 2) (Fin 2) B)
      * !![0, G₁; G₂, 0] = !![G₁ * G₂, 0; 0, G₂ * G₁] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  rw [sq, hsq]
  constructor
  · intro hQ
    refine ⟨?_, ?_⟩
    · have := congrFun (congrFun hQ 0) 0; simpa using this
    · have := congrFun (congrFun hQ 1) 1; simpa using this
  · rintro ⟨h1, h2⟩
    ext i j
    fin_cases i <;> fin_cases j <;> simp [h1, h2]

end PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia
```

Guard pins in `SlabAxiomGuard.lean`:

```lean
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia.anticonj_odd_pow_trace_zero
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia.conj_pow
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia.half_constraint_rigidity
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia.anticonj_charpoly_eq
```

Observed commands from the landing ledger:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/S1CCBalancedInertia.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.SlabAxiomGuard
```

Return concise sections: verdict, theorem audit, docstring/overclaim audit,
guard audit, next Lean target.

## Harvest

Verdict:

- Aristotle re-elaborated the source in Lean 4.28.0 + Mathlib v4.28.0 and
  found the finite matrix-algebra rungs honest: odd-power traces vanish under
  anticonjugation, `(-B).charpoly = B.charpoly`, and the half-constraint
  block-square theorem is exactly as claimed over an arbitrary ring.
- No positivity theorem is present. The physical balanced-inertia and `V'/N`
  reading remains MEMO / future Lean work.
- The main audit finding was docstring hygiene: the trace theorem docstrings
  spoke too strongly about spectral symmetry. Codex softened those local
  docstrings after harvest.

Applied follow-up:

- Added guard pins for `trace_invOf_conj` and `anticonj_trace_zero`.
- Added the pure finite count helper
  `countP_pos_eq_countP_neg_of_map_neg_eq` and its indexed form
  `card_pos_eq_card_neg_of_multiset_map_neg_eq`: a real multiset invariant
  under negation has equal positive and negative counts.
- Verified after edits:
  `lake env lean PhysicsSM/Draft/NullEdge/GateYM/S1CCBalancedInertia.lean`;
  `lake build PhysicsSM.Draft.NullEdge.GateYM.SlabAxiomGuard`.

Next Lean target:

- Prove the spectral bridge from `anticonj_charpoly_eq` to the count helper:
  for Hermitian `B`, `(-B).charpoly = B.charpoly` should imply that the
  multiset of `Matrix.IsHermitian.eigenvalues` is invariant under negation.
  Then `card_pos_eq_card_neg_of_multiset_map_neg_eq` gives the balanced count.

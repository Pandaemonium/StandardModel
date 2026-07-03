import Mathlib

/-!
# C45/C46: Is the Route B species-splitting `M_split = r · T` symmetry-forced or a modulus?

This module is the **Lean-facing companion** of the strategy/audit report
`AgentTasks/null-edge-weber-flavored-qcd-splitting-audit.md`.  It turns the
adversarial question

> Can Weber's no-fine-tuning mechanism (arXiv:1611.08388, *QCD with Flavored
> Minimally Doubled Fermions*) be adapted so that the tetrahedral null-edge
> Route B sign pattern `(+,+,-,-)`, the taste operator `T`, and the coefficient
> `r` are **symmetry-forced** rather than freely tuned?

into a small package of kernel-checked finite facts.  It is deliberately
*standalone* (`import Mathlib` only) so it does not depend on the rest of the
in-progress null-edge tree.

## The model objects

A Route B splitting acts on the four high-momentum branches indexed by
`Fin 4` (the position of the unique non-`π` edge of a `{0,π}^4` corner).  The
splitting is `M_split = r · T` where the taste operator `T = Σ_a s_a P_a` is
fixed by a **sign vector** `s : Fin 4 → ℝ` and a real **coefficient** `r`.  The
literature target pattern is

```text
g5 = (+,+,-,-) = ![1, 1, -1, -1].
```

The natural *bare* symmetry of the four branches is the full tetrahedral
permutation group `S₄ = Equiv.Perm (Fin 4)` acting on the branch index.

## What is proved (the adversarial core)

1. `invariant_iff_const` / `g5_not_S4_invariant` — **the full branch symmetry
   `S₄` cannot force the pattern.**  The only `S₄`-invariant sign vectors are the
   constants; `g5` is non-constant, hence not `S₄`-invariant.  Equivalently
   `g5` lives in the 3-dimensional *standard* irrep, on which `S₄` acts without
   fixed lines: no single direction is singled out.

2. `partitions_in_one_S4_orbit` — **the 2+2 partition is a discrete (`Z₃`-type)
   choice, not canonical.**  The three sign patterns
   `![1,1,-1,-1]`, `![1,-1,1,-1]`, `![1,-1,-1,1]` (the three ways to split four
   branches `2+2`) lie in a single `S₄` orbit, so the bare symmetry maps any one
   to any other: nothing in the unbroken tetrahedral symmetry prefers one.

3. `direction_forced_scale_free` — **fixing the partition forces the *direction*
   but leaves a free *scale*.**  Once a partition is chosen (encoded as
   `BlockConstant`: constant on `{0,1}` and on `{2,3}`) and tracelessness is
   imposed (`Traceless`, i.e. `Σ_a s_a = 0`, the `signature (2,2)` / flavored
   index condition), every admissible `s` is `s = (s 0) • g5`.  The single
   surviving parameter is exactly the scale `s 0` — i.e. the coefficient `r`.

4. `coeff_modulus_injective` — **the coefficient `r` is a genuine 1-parameter
   modulus.**  For any nonzero taste operator `T`, the family `r ↦ r • T` is
   injective: distinct `r` give genuinely distinct splittings.  A linear
   symmetry can fix the *direction* `T` but never a *nonzero scale*, so `r`
   ranges over all of `ℝ`.

5. `SymmetryForcesDirection` / `weber_best_case_still_a_modulus` — the
   **conditional API**: even granting the strongest plausible adaptation of
   Weber's mechanism (a canonical partition-selecting `C`/reflection symmetry
   that forces `BlockConstant` and `Traceless`, hence forces the *direction* of
   `T` to be `g5` up to scale), the coefficient `r` is still an unconstrained
   real modulus.

## Verdict (see the report for the full classification table)

* The **2+2 / traceless structure** (`Σ s_a = 0`) is *forced*.
* The **direction** of `T` (the pattern `g5` up to scale) is *forced only after*
  a partition is selected; the partition itself is *not* fixed by the bare
  tetrahedral symmetry (it is a discrete modulus unless an external
  `C`/reflection + preferred-covector structure canonically picks it).
* The **coefficient `r`** is **never symmetry-forced**: it is a free modulus.
  Weber's argument, *if* it adapts, delivers *technical naturalness*
  (no extra taste-breaking counterterms to tune), **not** a predicted value of
  `r`.  Hence Gate F prediction language stays **off** for any claim that
  depends on the magnitude `r`; only a *structural* (forbidden-counterterm /
  forced-texture) prediction survives.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit

/-! ## Model objects -/

/-- The literature target taste pattern `(+,+,-,-)` on the four branches. -/
def g5 : Fin 4 → ℝ := ![1, 1, -1, -1]

/-- The `S₄` action on a branch sign vector by precomposition with the
permutation of branch indices. -/
def permAct (σ : Equiv.Perm (Fin 4)) (s : Fin 4 → ℝ) : Fin 4 → ℝ := s ∘ σ

/-- A sign vector is `S₄`-invariant if every branch permutation fixes it. -/
def IsInvariant (s : Fin 4 → ℝ) : Prop := ∀ σ : Equiv.Perm (Fin 4), permAct σ s = s

/-- `BlockConstant` encodes the chosen `2+2` partition `{0,1} | {2,3}`:
the sign vector is constant on each block. -/
def BlockConstant (s : Fin 4 → ℝ) : Prop := s 0 = s 1 ∧ s 2 = s 3

/-- Tracelessness `Σ_a s_a = 0`: the `signature (2,2)` / flavored-index
condition (the two `+` and two `−` must cancel). -/
def Traceless (s : Fin 4 → ℝ) : Prop := s 0 + s 1 + s 2 + s 3 = 0

/-! ## 1. The bare symmetry `S₄` cannot force the pattern -/

/-
The only `S₄`-invariant branch sign vectors are the constants.
-/
theorem invariant_iff_const (s : Fin 4 → ℝ) :
    IsInvariant s ↔ ∃ c : ℝ, s = fun _ => c := by
  constructor;
  · intro hs
    use s 0
    funext x
    have h_eq : s x = s 0 := by
      have := congr_fun ( hs ( Equiv.swap 0 x ) ) 0; aesop;
    exact h_eq;
  · unfold IsInvariant; aesop;

/-
**`S₄` does not force `g5`.**  The target pattern `(+,+,-,-)` is not
invariant under the full tetrahedral branch-permutation symmetry.
-/
theorem g5_not_S4_invariant : ¬ IsInvariant g5 := by
  intro h; have := h ( Equiv.swap 0 2 ) ; have := congrFun this 0; simp +decide [ g5 ] at this;
  simp +decide [ permAct ] at this;
  norm_num at this

/-! ## 2. The 2+2 partition is a non-canonical discrete choice -/

/-- The three `2+2` sign patterns (the three synthemes / pairings of four
branches). -/
def part01 : Fin 4 → ℝ := ![1, 1, -1, -1]
def part02 : Fin 4 → ℝ := ![1, -1, 1, -1]
def part03 : Fin 4 → ℝ := ![1, -1, -1, 1]

/-
**The partition is not canonical.**  The patterns of the partitions
`{0,1}|{2,3}` and `{0,2}|{1,3}` lie in one `S₄` orbit: the transposition
`(1 2)` carries one to the other.  Hence the unbroken tetrahedral symmetry has
no preferred `2+2` split.
-/
theorem partitions_in_one_S4_orbit :
    permAct (Equiv.swap 1 2) part01 = part02 := by
  funext i; fin_cases i <;> simp +decide [ permAct, part01, part02, Equiv.swap_apply_def ]

/-
The third partition is in the same orbit as well (via `(1 3)`).
-/
theorem partitions_in_one_S4_orbit' :
    permAct (Equiv.swap 1 3) part01 = part03 := by
  funext i; fin_cases i <;> simp +decide [ permAct, part01, part03, Equiv.swap_apply_def ] ;

/-! ## 3. Fixing the partition forces the direction but leaves the scale free -/

/-
**Direction forced, scale free.**  Given the chosen partition
(`BlockConstant`) and tracelessness (`Traceless`), every admissible sign vector
is a scalar multiple of `g5`, and the scalar is exactly `s 0`.  The surviving
free parameter is precisely the splitting coefficient.
-/
theorem direction_forced_scale_free (s : Fin 4 → ℝ)
    (hb : BlockConstant s) (ht : Traceless s) :
    s = (s 0) • g5 := by
  ext i; fin_cases i <;> simp_all +decide [ BlockConstant, Traceless ] ;
  · unfold g5; norm_num;
  · unfold g5; norm_num;
  · exact show s 3 = s 1 * ( -1 ) by linarith!;
  · exact show s 3 = s 1 * -1 by linarith!;

/-! ## 4. The coefficient `r` is a genuine modulus -/

/-
**The coefficient is a 1-parameter modulus.**  For any nonzero taste
operator `T` (here a nonzero branch vector), the splitting family `r ↦ r · T` is
injective: distinct coefficients give genuinely distinct splittings, so no
single value of `r` is symmetry-distinguished.
-/
theorem coeff_modulus_injective (T : Fin 4 → ℝ) (hT : T ≠ 0) :
    Function.Injective (fun r : ℝ => r • T) := by
  exact fun x y hxy => smul_left_injective _ hT hxy

/-
The set of splitting coefficients realized by `r ↦ r · g5` is all of `ℝ`
(a full real modulus), since `g5 ≠ 0`.
-/
theorem coeff_range_full :
    Function.Injective (fun r : ℝ => r • g5) := by
  exact coeff_modulus_injective g5 ( by intro h; have := congr_fun h 0; norm_num [ g5 ] at this )

/-! ## 5. Conditional API: even the best-case Weber adaptation leaves `r` free -/

/-- **What a symmetry argument could at best force.**  `SymmetryForcesDirection`
abstracts the strongest plausible adaptation of Weber's `C`/reflection
no-fine-tuning argument: a (hypothetical) external structure that (i) selects the
partition (`BlockConstant`) and (ii) imposes tracelessness (`Traceless`).  By
`direction_forced_scale_free` this pins the *direction* of the splitting to `g5`,
but says nothing about its magnitude. -/
def SymmetryForcesDirection (s : Fin 4 → ℝ) : Prop :=
  BlockConstant s ∧ Traceless s

/-- **Best-case verdict: the splitting remains a modulus.**  Even when the
symmetry forces the direction (`SymmetryForcesDirection`), the family of
admissible splittings is the full real line `{ r • g5 : r ∈ ℝ }`, parametrised
injectively by the coefficient `r`.  Therefore the coefficient is *not*
symmetry-forced: Weber's mechanism, if it adapts, gives technical naturalness,
not a predicted value of `r`. -/
theorem weber_best_case_still_a_modulus :
    (∀ s, SymmetryForcesDirection s → s = (s 0) • g5) ∧
      Function.Injective (fun r : ℝ => r • g5) := by
  refine ⟨fun s h => direction_forced_scale_free s h.1 h.2, coeff_range_full⟩

/-- **C45/C46 summary.**  A compact record of the audit's formal content:

* `S₄` does not force the pattern (`g5_not_S4_invariant`);
* the `2+2` partition is a non-canonical `S₄`-orbit choice
  (`partitions_in_one_S4_orbit`);
* selecting a partition + tracelessness forces only the *direction*
  (`direction_forced_scale_free`);
* the coefficient `r` is a genuine injective real modulus
  (`coeff_range_full`).

Together: the splitting `M_split = r · T` is, at best, a *direction-forced* but
*magnitude-free* modulus. -/
theorem c45_c46_audit_summary :
    (¬ IsInvariant g5) ∧
    (permAct (Equiv.swap 1 2) part01 = part02) ∧
    (∀ s, BlockConstant s → Traceless s → s = (s 0) • g5) ∧
    (Function.Injective (fun r : ℝ => r • g5)) :=
  ⟨g5_not_S4_invariant, partitions_in_one_S4_orbit,
    fun s hb ht => direction_forced_scale_free s hb ht, coeff_range_full⟩

end PhysicsSM.Draft.NullEdgeSymmetryForcedSpeciesSplit

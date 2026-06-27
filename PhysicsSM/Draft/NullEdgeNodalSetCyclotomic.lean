import Mathlib
import PhysicsSM.Draft.TetrahedralHighMomentumNullBranch
import PhysicsSM.Draft.NullEdgeSpectralGraphNodalSet
import PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine
import PhysicsSM.Draft.NullEdgeNodalSetExhaustion

/-!
# C66: The cyclotomic off-branch family of tetrahedral determinant zeros

Aristotle Gate C Route B deliverable, hardening the C64 exhaustion audit
(`PhysicsSM.Draft.NullEdgeNodalSetExhaustion`).

## Background

C64 found a single explicit off-branch determinant-zero point
`q⋆ = (2π/3, 0, 0, 4π/3)`, with retarded phase vector `u⋆ = (ω−1, 0, 0, ω²−1)`
(`ω = exp(2πi/3)` a primitive cube root of unity), that is

* a genuine scalar/Clifford determinant zero (`qform u⋆ = 0`, `mink (pCov u⋆) = 0`),
* not the origin,
* on **none** of the four certified branch lines, and
* **not** gapped by the modeled `g5 = (+,+,−,−)` species split.

The open problem this module attacks: *stop discovering off-branch zeros one at a
time*.  We classify the whole **cyclotomic / cube-root** off-branch family that
`q⋆` belongs to, and we determine exactly which of its members the `g5` species
split fails to gap.

## The abstract nodal criterion

The scalar Lorentzian symbol square is `qform u = −¾·Σ uₐ² + ¼·(Σ uₐ)²`
(`TetrahedralNullBranch.qform_eq`).  Hence (`qform_zero_iff_sumSq`):

```text
qform u = 0  ↔  (Σ uₐ)² = 3 · Σ uₐ².
```

For a vector supported on two distinct edges `i ≠ j` with values `c, d`
(`pairVec`) this collapses to a single cyclotomic equation
(`qform_pairVec`):

```text
qform (pairVec i j c d) = −½ · (c² − c·d + d²),
```

so such a point is a determinant zero **iff** `c² − c·d + d² = 0`, i.e. iff
`c/d` is a primitive sixth root of unity.

## The cyclotomic orbit

`cycPhase i j` puts `q_i = 2π/3`, `q_j = 4π/3` and `0` on the other two edges
(`i ≠ j`).  Its retarded phase vector is `pairVec i j (ω−1) (ω²−1)`, and
`(ω−1)² − (ω−1)(ω²−1) + (ω²−1)² = 0` (`cubeRootPair_vanishes`).  Letting `i, j`
range over ordered distinct pairs produces the full `S₄`-orbit of `q⋆`
(`12` points), each of which is proved to be:

* a scalar **and** Clifford determinant zero (`cyc_qform_zero`, `cyc_mink_zero`),
* nonzero (`cyc_ne_origin`), and
* off every certified branch line (`cyc_off_branchLine`).

`cycPhase 0 3` is exactly the C64 witness `q⋆`
(`cycPhase_zero_three_eq_extraPhase`).

## What the `g5` split does on the orbit (sharp, corrected verdict)

A closed form (`cyc_Tlin_g5`) computes the modeled split on the whole orbit:

```text
T_lin[g5] (cycPhase i j) = −¾ · (g5 i + g5 j).
```

Therefore (`cyc_Msplit_g5_zero_iff`) for `r ≠ 0` the split **fails to gap**
`cycPhase i j` **iff** `g5 i = −g5 j`, i.e. iff the two excited edges straddle the
`g5` sign blocks `{0,1} | {2,3}`.  This is sharper and more honest than "the split
fails on the whole family":

* the split **fails** on the `8`-point straddling sub-orbit — the genuine
  `g5`-symmetry orbit of `q⋆` — (`g5_split_fails_on_straddle`,
  `g5_split_fails_whole_qstar_orbit`);
* the split **does** gap the remaining `4` within-block cyclotomic points
  (`g5_split_gaps_within_block`).

So the `g5` species split controls part of the cyclotomic family but provably not
the part containing `q⋆`.

## Scope / honesty

This is **nodal control** only (scalar/Clifford determinant zeros), not a
Furey/internal-legality claim.  We do *not* claim the cyclotomic orbit exhausts
the full complex zero sheet `{ q | qform (phaseU q) = 0 }`; the orbit is the
cube-root locus of the two-support sub-family.  The remaining classification of
the higher-dimensional sheet is flagged as open (see the closing remark).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeNodalSetCyclotomic

open Complex
open PhysicsSM.Draft.TetrahedralNullBranch (qform qform_eq pCov mink pSq_mink_eq_qform)
open PhysicsSM.Draft.NullEdgeSpectralGraphNodalSet (phaseU branchLineU branchLineU_apply)
open PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine (Tlin Msplit g5)

/-! ## The abstract nodal criterion -/

/-
**Abstract determinant-zero criterion.**  The scalar Lorentzian symbol square
vanishes iff `(Σ uₐ)² = 3 · Σ uₐ²`.
-/
theorem qform_zero_iff_sumSq (u : Fin 4 → ℂ) :
    qform u = 0 ↔ (∑ a, u a) ^ 2 = 3 * ∑ a, (u a) ^ 2 := by
  grind +suggestions

/-! ## Two-support vectors and the cyclotomic collapse -/

/-- A vector supported on two edges: value `c` at `i`, `d` at `j`, `0` elsewhere. -/
def pairVec (i j : Fin 4) (c d : ℂ) : Fin 4 → ℂ :=
  fun a => if a = i then c else if a = j then d else 0

/-
**Two-support collapse.**  For distinct edges `i ≠ j`,
`qform (pairVec i j c d) = −½ · (c² − c·d + d²)`.  Hence such a point is a
determinant zero iff `c² − c·d + d² = 0` (a primitive-sixth-root condition on
`c/d`).
-/
theorem qform_pairVec (i j : Fin 4) (hij : i ≠ j) (c d : ℂ) :
    qform (pairVec i j c d) = (-1/2 : ℂ) * (c ^ 2 - c * d + d ^ 2) := by
  fin_cases i <;> fin_cases j <;> simp +decide [ pairVec ] at hij ⊢;
  all_goals unfold qform; simp +decide [ Fin.sum_univ_four, pairVec ] ; ring;
  all_goals unfold TetrahedralNullBranch.Ginv; simp +decide ; ring;

/-
The cube-root pair identity: with `c = ω−1`, `d = ω²−1` (`ω = exp(2πi/3)`),
`c² − c·d + d² = 0`.
-/
theorem cubeRootPair_vanishes :
    (Complex.exp (Complex.I * ((2 * Real.pi / 3 : ℝ) : ℂ)) - 1) ^ 2
      - (Complex.exp (Complex.I * ((2 * Real.pi / 3 : ℝ) : ℂ)) - 1)
        * (Complex.exp (Complex.I * ((4 * Real.pi / 3 : ℝ) : ℂ)) - 1)
      + (Complex.exp (Complex.I * ((4 * Real.pi / 3 : ℝ) : ℂ)) - 1) ^ 2 = 0 := by
  norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im, sq ];
  norm_num [ show 2 * Real.pi / 3 = Real.pi - Real.pi / 3 by ring, show 4 * Real.pi / 3 = Real.pi + Real.pi / 3 by ring, Real.cos_add, Real.sin_add ] ; ring_nf ; norm_num

/-! ## The cyclotomic orbit `cycPhase i j` -/

/-- The cyclotomic phase configuration: `q_i = 2π/3`, `q_j = 4π/3`, and `0` on the
other two edges. -/
def cycPhase (i j : Fin 4) : Fin 4 → ℝ :=
  fun a => if a = i then 2 * Real.pi / 3 else if a = j then 4 * Real.pi / 3 else 0

/-
The retarded phase vector of `cycPhase i j` is the two-support vector
`pairVec i j (ω−1) (ω²−1)` (for `i ≠ j`).
-/
theorem cycPhase_phaseU_eq_pairVec (i j : Fin 4) :
    phaseU (cycPhase i j) =
      pairVec i j (Complex.exp (Complex.I * ((2 * Real.pi / 3 : ℝ) : ℂ)) - 1)
        (Complex.exp (Complex.I * ((4 * Real.pi / 3 : ℝ) : ℂ)) - 1) := by
  ext a; simp [phaseU, cycPhase, pairVec];
  split_ifs <;> simp +decide [ *, Complex.exp_zero ]

/-
**Scalar determinant zero on the orbit.**  Every cyclotomic point is a zero
of the scalar Lorentzian symbol square.
-/
theorem cyc_qform_zero (i j : Fin 4) (hij : i ≠ j) :
    qform (phaseU (cycPhase i j)) = 0 := by
  rw [ cycPhase_phaseU_eq_pairVec i j, qform_pairVec i j hij, cubeRootPair_vanishes, mul_zero ]

/-- **Clifford determinant zero on the orbit.**  Every cyclotomic point is a zero
of the mostly-minus Minkowski square of the spacetime symbol covector. -/
theorem cyc_mink_zero (i j : Fin 4) (hij : i ≠ j) :
    mink (pCov (phaseU (cycPhase i j))) = 0 := by
  rw [pSq_mink_eq_qform]; exact cyc_qform_zero i j hij

/-
**Nonzero on the orbit.**  No cyclotomic point is the origin: its `i`-edge
component is `ω − 1 ≠ 0`.
-/
theorem cyc_ne_origin (i j : Fin 4) :
    phaseU (cycPhase i j) ≠ 0 := by
  unfold phaseU cycPhase; norm_num [ Fin.ext_iff, Complex.ext_iff, Complex.exp_re, Complex.exp_im ] ;
  intro h; have := congr_fun h i; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ] at this;
  norm_num [ Real.cos_two_mul, mul_div_assoc ] at this

/-
**Off every certified branch line.**  A branch line has exactly one vanishing
component (or is the origin), whereas a cyclotomic point has *two* vanishing
components and is nonzero; hence it lies on no `branchLineU a t`.
-/
theorem cyc_off_branchLine (i j : Fin 4) (hij : i ≠ j) :
    ∀ (a : Fin 4) (t : ℝ), phaseU (cycPhase i j) ≠ branchLineU a t := by
  intro a t h_eq;
  have h_comp : ∀ b, phaseU (cycPhase i j) b = 0 ↔ b ≠ i ∧ b ≠ j := by
    intro b
    simp [phaseU, cycPhase];
    split_ifs <;> simp_all +decide [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
    · norm_num [ Real.cos_two_mul, mul_div_assoc ];
    · norm_num [ show 4 * Real.pi / 3 = Real.pi + Real.pi / 3 by ring, Real.cos_add, Real.sin_add ];
  fin_cases i <;> fin_cases j <;> simp_all +decide only [branchLineU_apply];
  all_goals fin_cases a <;> simp +decide [ Fin.forall_fin_succ ] at h_comp ⊢;

/-! ## Recovering the C64 witness `q⋆` -/

/-
`cycPhase 0 3` is exactly the C64 off-branch witness
`q⋆ = (2π/3, 0, 0, 4π/3)`.
-/
theorem cycPhase_zero_three_eq_extraPhase :
    cycPhase 0 3 = PhysicsSM.Draft.NullEdgeNodalSetExhaustion.extraPhase := by
  funext a; fin_cases a <;> simp +decide [ cycPhase, NullEdgeNodalSetExhaustion.extraPhase ] ;

/-! ## The `g5` species split on the orbit (sharp verdict) -/

/-
**Closed form of the modeled split on the orbit.**  With `g5 = (+,+,−,−)`,
`T_lin[g5] (cycPhase i j) = −¾ · (g5 i + g5 j)`.
-/
theorem cyc_Tlin_g5 (i j : Fin 4) (hij : i ≠ j) :
    Tlin g5 (cycPhase i j) = (-3 / 4 : ℝ) * (g5 i + g5 j) := by
  unfold Tlin g5 cycPhase;
  fin_cases i <;> fin_cases j <;> simp +decide [ Fin.sum_univ_succ ] <;> ring_nf <;> norm_num [ mul_div ];
  all_goals norm_num [ show Real.pi * 2 / 3 = Real.pi - Real.pi / 3 by ring, show Real.pi * 4 / 3 = Real.pi + Real.pi / 3 by ring, Real.cos_add, Real.cos_sub ] at *;

/-
**Exact split-failure criterion.**  For nonzero coefficient `r`, the modeled
`g5` species split fails to gap the cyclotomic point `cycPhase i j` iff the two
excited edges straddle the `g5` sign blocks, `g5 i + g5 j = 0`.
-/
theorem cyc_Msplit_g5_zero_iff (r : ℝ) (i j : Fin 4) (hij : i ≠ j) :
    Msplit r g5 (cycPhase i j) = 0 ↔ (r = 0 ∨ g5 i + g5 j = 0) := by
  unfold Msplit; rw [ cyc_Tlin_g5 i j hij ] ; norm_num;

/-
**The split fails on the straddling sub-orbit.**  Whenever the two excited
edges lie in opposite `g5` blocks (`g5 i = −g5 j`), the modeled `g5` split
vanishes at `cycPhase i j` for *every* coefficient `r` — it never gaps these
points.
-/
theorem g5_split_fails_on_straddle (i j : Fin 4) (hij : i ≠ j)
    (hstr : g5 i + g5 j = 0) :
    ∀ r : ℝ, Msplit r g5 (cycPhase i j) = 0 := by
  exact fun r => cyc_Msplit_g5_zero_iff r i j hij |>.2 <| Or.inr hstr

/-
**The split gaps the within-block points.**  When the two excited edges lie in
the same `g5` block (`g5 i = g5 j ≠ 0`), the modeled `g5` split is nonzero at
`cycPhase i j` for every nonzero coefficient `r` — it does gap these cyclotomic
points.
-/
theorem g5_split_gaps_within_block (r : ℝ) (i j : Fin 4) (hij : i ≠ j)
    (hr : r ≠ 0) (hblk : g5 i + g5 j ≠ 0) :
    Msplit r g5 (cycPhase i j) ≠ 0 := by
  exact fun h => hblk <| by have := cyc_Msplit_g5_zero_iff r i j hij; aesop;

/-
**The split fails on the whole `g5`-orbit of `q⋆`.**  The C64 witness
`q⋆ = cycPhase 0 3` straddles the blocks (`g5 0 + g5 3 = 0`), and so does every
point obtained from it by exchanging edges within or between the two `g5` blocks;
on all of them the modeled `g5` split vanishes for every `r`.  Concretely, the
eight straddling cyclotomic points `cycPhase i j` with `i ∈ {0,1}, j ∈ {2,3}` or
`i ∈ {2,3}, j ∈ {0,1}` are never gapped.
-/
theorem g5_split_fails_whole_qstar_orbit (i j : Fin 4) (hij : i ≠ j)
    (hstr : (g5 i = 1 ∧ g5 j = -1) ∨ (g5 i = -1 ∧ g5 j = 1)) :
    ∀ r : ℝ, Msplit r g5 (cycPhase i j) = 0 := by
  cases hstr <;> simp +decide [ *, Msplit ]; all_goals exact fun r => Or.inr ( by rw [ cyc_Tlin_g5 i j hij ] ; norm_num [ * ] )

/-! ## Summary -/

/-- **C66 cyclotomic-family summary.**

1. The whole `S₄`-orbit of `q⋆` (the cyclotomic points `cycPhase i j`, `i ≠ j`) is
   a determinant-zero family: each is a scalar and Clifford zero
   (`cyc_qform_zero`, `cyc_mink_zero`), nonzero (`cyc_ne_origin`), and off every
   certified branch line (`cyc_off_branchLine`).
2. `cycPhase 0 3` is the C64 witness `q⋆`.
3. The modeled `g5` species split obeys the closed form
   `T_lin[g5] (cycPhase i j) = −¾(g5 i + g5 j)`, so it fails to gap exactly the
   straddling sub-orbit (which contains `q⋆`) and gaps the within-block points. -/
theorem c66_cyclotomic_summary :
    (∀ (i j : Fin 4), i ≠ j →
        qform (phaseU (cycPhase i j)) = 0 ∧
        mink (pCov (phaseU (cycPhase i j))) = 0 ∧
        phaseU (cycPhase i j) ≠ 0 ∧
        (∀ (a : Fin 4) (t : ℝ), phaseU (cycPhase i j) ≠ branchLineU a t)) ∧
    cycPhase 0 3 = PhysicsSM.Draft.NullEdgeNodalSetExhaustion.extraPhase ∧
    (∀ (i j : Fin 4), i ≠ j → Tlin g5 (cycPhase i j) = (-3 / 4 : ℝ) * (g5 i + g5 j)) ∧
    (∀ (r : ℝ) (i j : Fin 4), i ≠ j →
        (Msplit r g5 (cycPhase i j) = 0 ↔ (r = 0 ∨ g5 i + g5 j = 0))) :=
  ⟨fun i j hij =>
      ⟨cyc_qform_zero i j hij, cyc_mink_zero i j hij, cyc_ne_origin i j,
        cyc_off_branchLine i j hij⟩,
    cycPhase_zero_three_eq_extraPhase, cyc_Tlin_g5, cyc_Msplit_g5_zero_iff⟩

end PhysicsSM.Draft.NullEdgeNodalSetCyclotomic

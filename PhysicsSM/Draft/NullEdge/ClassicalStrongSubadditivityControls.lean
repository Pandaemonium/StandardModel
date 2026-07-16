import Mathlib

/-!
# SSA anti-vacuity controls: conditional-independence equality + strict witness

Draft module. Preregistered anti-vacuity controls for the classical
strong-subadditivity result `ClassicalSSA.shannon_ssa` (work item GRAV-SSA-001):
the SSA inequality is a substantive result because (1) the displayed
conditional-independence condition is sufficient for EQUALITY, and (2) the
inequality is STRICT on a genuinely correlated distribution. These two
controls rule out the vacuity / always-equality failure modes. No converse
characterization of equality is claimed here.

The definitions (`shannonEntropy`, `margXZ`, `margYZ`, `margZ`) are byte-identical
to `PhysicsSM.Draft.NullEdge.ClassicalSSA`, so the controls concern the same
mathematical objects as `shannon_ssa`. Companion to
`PhysicsSM.Draft.NullEdge.ClassicalStrongSubadditivity`.

- `ssa_eq_of_condIndep`: if the joint distribution satisfies the
  conditional-independence (Markov) identity
  `p(x,y,z) * margZ z = margXZ (x,z) * margYZ (y,z)` for all `x,y,z`, then SSA
  holds with EQUALITY (conditional mutual information `I(X:Y|Z) = 0`).
- `ssa_strict_witness`: the explicit perfectly-correlated distribution
  `witnessP` on `Fin 2 x Fin 2 x Fin 1` (`p = 1/2` when `X = Y`, else `0`) makes
  SSA STRICT: `H(XYZ) + H(Z) < H(XZ) + H(YZ)` (numerically `log 2 < 2 log 2`, so
  `I(X:Y|Z) = log 2 > 0`).

## Trust status

Draft-trust by kernel: both controls are `sorry`-free and depend only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard blocks at the end.

## Provenance

Statements authored in-project (AFPL run 2026-07-12) as the GRAV-SSA-001
controls. Proof search by Aristotle (project
`92ee3e9e-75a3-484d-ba56-5fc370808bdc`), then independently re-checked in this
repo under the pinned toolchain (`lake env lean`; axiom footprint confirmed
kernel-only). Clean-room formalization from the mathematical statement.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ClassicalSSAControls

open scoped BigOperators

variable {X Y Z : Type*} [Fintype X] [Fintype Y] [Fintype Z]

/-- Shannon entropy of a finite distribution `r`, `∑ i, negMulLog (r i)`. -/
def shannonEntropy {ι : Type*} [Fintype ι] (r : ι → ℝ) : ℝ :=
  ∑ i, Real.negMulLog (r i)

/-- `XZ` marginal of a joint `X × Y × Z` distribution. -/
def margXZ (p : X × Y × Z → ℝ) : X × Z → ℝ :=
  fun xz => ∑ y : Y, p (xz.1, y, xz.2)

/-- `YZ` marginal. -/
def margYZ (p : X × Y × Z → ℝ) : Y × Z → ℝ :=
  fun yz => ∑ x : X, p (x, yz.1, yz.2)

/-- `Z` marginal. -/
def margZ (p : X × Y × Z → ℝ) : Z → ℝ :=
  fun z => ∑ x : X, ∑ y : Y, p (x, y, z)

/-
**CONTROL 1 (the hole): conditional-independence equality.**  When the joint
distribution satisfies the Markov identity, SSA holds with equality
(`I(X:Y|Z) = 0`).
-/
theorem ssa_eq_of_condIndep (p : X × Y × Z → ℝ)
    (hp : ∀ t, 0 ≤ p t) (hps : ∑ t, p t = 1)
    (hCI : ∀ x y z, p (x, y, z) * margZ p z = margXZ p (x, z) * margYZ p (y, z)) :
    shannonEntropy (margXZ p) + shannonEntropy (margYZ p)
      = shannonEntropy p + shannonEntropy (margZ p) := by
  unfold shannonEntropy;
  -- By definition of marginals, we can rewrite the sums involving marginals.
  have h_margXZ : ∑ xz : X × Z, Real.negMulLog (margXZ p xz) = ∑ x : X, ∑ y : Y, ∑ z : Z, (-p (x, y, z) * Real.log (margXZ p (x, z))) := by
    simp +decide [ margXZ, Real.negMulLog_def ];
    simp +decide only [Finset.sum_mul _ _ _, Finset.sum_sigma'];
    refine' Finset.sum_bij ( fun x _ => ⟨ x.fst.1, x.snd, x.fst.2 ⟩ ) _ _ _ _ <;> simp +decide;
    grind
  have h_margYZ : ∑ yz : Y × Z, Real.negMulLog (margYZ p yz) = ∑ x : X, ∑ y : Y, ∑ z : Z, (-p (x, y, z) * Real.log (margYZ p (y, z))) := by
    have h_margYZ : ∑ yz : Y × Z, Real.negMulLog (margYZ p yz) = ∑ y : Y, ∑ z : Z, Real.negMulLog (∑ x : X, p (x, y, z)) := by
      rw [ ← Finset.sum_product' ];
      rfl;
    -- By definition of negMulLog, we can rewrite the sum.
    have h_negMulLog : ∀ y z, Real.negMulLog (∑ x : X, p (x, y, z)) = ∑ x : X, (-p (x, y, z) * Real.log (∑ x : X, p (x, y, z))) := by
      simp +decide [ Real.negMulLog, Finset.sum_mul _ _ _ ];
    rw [ h_margYZ, Finset.sum_congr rfl fun y hy => Finset.sum_congr rfl fun z hz => h_negMulLog y z ];
    exact Eq.symm ( by rw [ Finset.sum_comm ] ; exact Finset.sum_congr rfl fun _ _ => Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by rfl ) )
  have h_margZ : ∑ z : Z, Real.negMulLog (margZ p z) = ∑ x : X, ∑ y : Y, ∑ z : Z, (-p (x, y, z) * Real.log (margZ p z)) := by
    have h_margZ : ∑ z : Z, Real.negMulLog (margZ p z) = ∑ z : Z, (∑ x : X, ∑ y : Y, -p (x, y, z) * Real.log (margZ p z)) := by
      have : ∀ z : Z, Real.negMulLog (margZ p z) = ∑ x : X, ∑ y : Y, -p (x, y, z) * Real.log (margZ p z) := by
        simp +decide [ ← Finset.sum_mul, Real.negMulLog ];
        exact fun z => Or.inl rfl
      exact Finset.sum_congr rfl fun _ _ => this _;
    rw [ h_margZ, Finset.sum_comm, Finset.sum_congr rfl fun _ _ => Finset.sum_comm ];
  simp_all +decide only [Real.negMulLog];
  have h_log_eq : ∀ x y z, p (x, y, z) ≠ 0 → Real.log (margXZ p (x, z)) + Real.log (margYZ p (y, z)) = Real.log (p (x, y, z)) + Real.log (margZ p z) := by
    intro x y z hp_nonzero
    have h_pos : 0 < margXZ p (x, z) ∧ 0 < margYZ p (y, z) ∧ 0 < margZ p z := by
      refine' ⟨ _, _, _ ⟩;
      · exact lt_of_lt_of_le ( lt_of_le_of_ne ( hp _ ) ( Ne.symm hp_nonzero ) ) ( Finset.single_le_sum ( fun y _ => hp ( x, y, z ) ) ( Finset.mem_univ y ) );
      · exact lt_of_lt_of_le ( lt_of_le_of_ne ( hp _ ) ( Ne.symm hp_nonzero ) ) ( Finset.single_le_sum ( fun a _ => hp ( a, y, z ) ) ( Finset.mem_univ x ) );
      · exact lt_of_lt_of_le ( lt_of_le_of_ne ( hp _ ) ( Ne.symm hp_nonzero ) ) ( Finset.single_le_sum ( fun x _ => Finset.sum_nonneg fun y _ => hp ( x, y, z ) ) ( Finset.mem_univ x ) |> le_trans ( Finset.single_le_sum ( fun y _ => hp ( x, y, z ) ) ( Finset.mem_univ y ) ) );
    rw [ ← Real.log_mul, ← Real.log_mul ] <;> try linarith;
    · rw [ hCI ];
    · exact hp_nonzero;
  have h_log_eq : ∀ x y z, -p (x, y, z) * Real.log (margXZ p (x, z)) + -p (x, y, z) * Real.log (margYZ p (y, z)) = -p (x, y, z) * Real.log (p (x, y, z)) + -p (x, y, z) * Real.log (margZ p z) := by
    grind +qlia;
  simp +decide only [← Finset.sum_add_distrib];
  simp +decide only [h_log_eq, Finset.sum_add_distrib];
  simp +decide only [← Finset.sum_product'];
  rfl

/-- Perfectly-correlated witness on `Fin 2 × Fin 2 × Fin 1`: mass `1/2` on the
diagonal `X = Y`, else `0`. -/
def witnessP : Fin 2 × Fin 2 × Fin 1 → ℝ :=
  fun t => if t.1 = t.2.1 then (1 : ℝ) / 2 else 0

/-
**CONTROL 2 (the hole): strict correlated witness.**  On `witnessP` the SSA
inequality is strict, so SSA is not vacuously an equality.
-/
theorem ssa_strict_witness :
    (∀ t, 0 ≤ witnessP t) ∧ (∑ t, witnessP t = 1) ∧
      shannonEntropy witnessP + shannonEntropy (margZ witnessP)
        < shannonEntropy (margXZ witnessP) + shannonEntropy (margYZ witnessP) := by
  unfold shannonEntropy margZ margXZ margYZ witnessP;
  norm_num [ Fintype.sum_prod_type, Real.negMulLog ];
  linarith [ Real.log_le_sub_one_of_pos ( by norm_num : ( 0 : ℝ ) < 1 / 2 ) ]

end PhysicsSM.Draft.NullEdge.ClassicalSSAControls

-- Axiom-footprint guards (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.ClassicalSSAControls.ssa_eq_of_condIndep' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ClassicalSSAControls.ssa_eq_of_condIndep

/--
info: 'PhysicsSM.Draft.NullEdge.ClassicalSSAControls.ssa_strict_witness' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ClassicalSSAControls.ssa_strict_witness

import Mathlib

/-!
# NullEdgeRelativeEntropyObserverRoadmap (NON-IMPORTED SCAFFOLD)

Design scaffold for the relative-entropy / observer-channel spine shared by the
null-edge program branches P7 (visible/internal reduction, mass-as-mixedness)
and P9 (causal-diamond source visibility, ANEC/QNEC-style positivity,
recoverability).

STATUS / HONESTY MARKERS

* This file is a **scaffold**, not a trusted surface.  It is deliberately NOT
  added to the `LeanContext` / `RequestProject` build globs; it is meant to be
  checked standalone with `lake env lean` against Mathlib only.  It imports no
  `PhysicsSM.*` module, so it cannot break, and is not broken by, the rest of
  the program.
* As of this writing every declaration below is FULLY PROVED and checked with
  `lake env lean` (axioms: `propext`, `Classical.choice`, `Quot.sound` only;
  no `s o r r y`).  The comments retained on the harder theorems record the proof
  strategy and the original `PROOF JOB` ranking from the design note, not an
  open obligation.  This validates the readiness scores: the classical finite
  spine (Gibbs, equality case, the headline data-processing inequality, and
  exact recoverability) is done.  What remains genuinely open is the QUANTUM
  matrix layer and the program-specific `PhysicsSM.*` interface wrappers in
  section 5, which are commented signatures only.
* Everything here is the *classical finite* (commutative / diagonal) layer.
  No quantum matrix relative entropy, no continuum modular Hamiltonian, no
  ANEC/QNEC, and no Sorkin-Johnston diamond entropy is asserted as a theorem.
  Those remain source-backed continuum motivation; see the companion design
  note `AgentTasks/null-edge-relative-entropy-observer-channel-output.md`.

Convention: a `FinObs` (observer / coarse-graining channel) is a
COLUMN-stochastic matrix `M : κ → ι → ℝ`, read as `M j i = P(see j | state i)`.
A `FinDist` is a finite classical distribution.  Relative entropy is the
nat-log Kullback-Leibler divergence.  Mathlib has `InformationTheory.klDiv`
(measures, `ℝ≥0∞`) but NO data-processing inequality, so the finite real
version below is built from scratch.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeRelativeEntropyObserver

open scoped BigOperators

/-! ## 1. Finite distributions and observer channels -/

/-- A finite classical distribution on `ι`: nonnegative weights summing to one. -/
structure FinDist (ι : Type*) [Fintype ι] where
  p : ι → ℝ
  nonneg : ∀ i, 0 ≤ p i
  sum_one : ∑ i, p i = 1

/-- A finite observer / coarse-graining channel `ι → κ`, encoded as a
column-stochastic matrix `M j i = P(observe j | underlying state i)`.  This is
the single shared object both branches must name *before* any monotonicity
claim. -/
structure FinObs (ι κ : Type*) [Fintype ι] [Fintype κ] where
  M : κ → ι → ℝ
  nonneg : ∀ j i, 0 ≤ M j i
  col_sum_one : ∀ i, ∑ j, M j i = 1

variable {ι κ μ : Type*} [Fintype ι] [Fintype κ] [Fintype μ]

/-- Push a distribution through an observer channel. -/
def applyObs (T : FinObs ι κ) (d : FinDist ι) : κ → ℝ :=
  fun j => ∑ i, T.M j i * d.p i

/-- The pushforward of a distribution is a distribution.  (Cheap; proved.) -/
theorem applyObs_nonneg (T : FinObs ι κ) (d : FinDist ι) (j : κ) :
    0 ≤ applyObs T d j := by
  unfold applyObs
  exact Finset.sum_nonneg fun i _ => mul_nonneg (T.nonneg j i) (d.nonneg i)

/-- The pushforward weights sum to one. -/
theorem applyObs_sum_one (T : FinObs ι κ) (d : FinDist ι) :
    ∑ j, applyObs T d j = 1 := by
  unfold applyObs
  rw [Finset.sum_comm]
  calc
    ∑ i, ∑ j, T.M j i * d.p i
        = ∑ i, (∑ j, T.M j i) * d.p i := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [Finset.sum_mul]
    _ = ∑ i, d.p i := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [T.col_sum_one i, one_mul]
    _ = 1 := d.sum_one

/-- Packaged pushforward distribution. -/
def pushforward (T : FinObs ι κ) (d : FinDist ι) : FinDist κ where
  p := applyObs T d
  nonneg := applyObs_nonneg T d
  sum_one := applyObs_sum_one T d

/-
Composition of observer channels (sequential coarse-graining).
-/
def FinObs.comp (S : FinObs κ μ) (T : FinObs ι κ) : FinObs ι μ where
  M := fun n i => ∑ j, S.M n j * T.M j i
  nonneg := by
    intro n i
    exact Finset.sum_nonneg fun j _ => mul_nonneg (S.nonneg n j) (T.nonneg j i)
  col_sum_one := by
    intro i
    rw [ Finset.sum_comm, ← Finset.sum_congr rfl fun _ _ => Finset.sum_mul _ _ _ ];
    simp +decide [ S.col_sum_one, T.col_sum_one ]

/-! ## 2. Finite Kullback-Leibler relative entropy -/

/-- Absolute continuity / support inclusion: `q i = 0 → p i = 0`.  This is the
hypothesis that must be BUNDLED into every nonnegativity and data-processing
statement; without it the finite formula silently drops `+∞` terms. -/
def AbsCont (p q : FinDist ι) : Prop := ∀ i, q.p i = 0 → p.p i = 0

/-- Finite nat-log Kullback-Leibler divergence.  By `0 * _ = 0` the zero-`p`
terms vanish automatically; the `AbsCont` hypothesis is what makes the
positive-`p`/zero-`q` terms physically correct rather than silently zero. -/
def klDiv (p q : FinDist ι) : ℝ := ∑ i, p.p i * Real.log (p.p i / q.p i)

/-- Self-divergence is zero. (Cheap; proved.) -/
theorem klDiv_self (p : FinDist ι) : klDiv p p = 0 := by
  unfold klDiv
  refine Finset.sum_eq_zero fun i _ => ?_
  rcases eq_or_ne (p.p i) 0 with h | h
  · simp [h]
  · rw [div_self h, Real.log_one, mul_zero]

/-
Gibbs' inequality: finite relative entropy is nonnegative under absolute
continuity.

PROVED (was PROOF JOB #1).  Proof via
`Real.log_le_sub_one_of_pos` applied to `q i / p i` on the support of `p`, then
`∑ q - ∑ p = 0`.  Confidence the statement is correct and the proof is in reach:
high.
-/
theorem klDiv_nonneg (p q : FinDist ι) (hac : AbsCont p q) :
    0 ≤ klDiv p q := by
  have h_gibbs : ∀ i, p.p i * Real.log (p.p i / q.p i) ≥ p.p i - q.p i := by
    intro i
    by_cases hpi : p.p i = 0;
    · simpa [ hpi ] using q.nonneg i;
    · by_cases hqi : q.p i = 0;
      · exact False.elim ( hpi ( hac i hqi ) );
      · have := Real.log_le_sub_one_of_pos ( show 0 < q.p i / p.p i from div_pos ( lt_of_le_of_ne ( q.nonneg i ) ( Ne.symm hqi ) ) ( lt_of_le_of_ne ( p.nonneg i ) ( Ne.symm hpi ) ) );
        rw [ Real.log_div ] at * <;> first | positivity | nlinarith [ mul_div_cancel₀ ( q.p i ) hpi, p.nonneg i, q.nonneg i ] ;
  convert Finset.sum_le_sum fun i _ => h_gibbs i using 1 ; simp +decide [ Finset.sum_sub_distrib, p.sum_one, q.sum_one ]

/-
Relative entropy is zero iff the distributions agree (under absolute
continuity).  Equality case of Gibbs.

PROVED (was PROOF JOB #2).  Strict form of
`log_le_sub_one`.  Confidence: medium-high.
-/
theorem klDiv_eq_zero_iff (p q : FinDist ι) (hac : AbsCont p q) :
    klDiv p q = 0 ↔ p.p = q.p := by
  constructor <;> intro h_eq
  by_cases h_zero : ∀ i, p.p i * Real.log (p.p i / q.p i) = p.p i - q.p i;
  · ext i; specialize h_zero i; by_cases hi : p.p i = 0 <;> simp_all +decide [ div_eq_mul_inv ] ;
    by_contra h_contra;
    have := Real.log_lt_sub_one_of_pos ( show 0 < q.p i / p.p i from div_pos ( lt_of_le_of_ne ( q.nonneg i ) ( Ne.symm ( by intro h; simp_all +decide [ hac ] ) ) ) ( lt_of_le_of_ne ( p.nonneg i ) ( Ne.symm hi ) ) ) ( div_ne_one_of_ne ( Ne.symm h_contra ) );
    rw [ Real.log_div ] at this <;> simp_all +decide [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm ];
    · rw [ Real.log_mul ] at h_zero <;> simp_all +decide [ ne_of_gt ];
      · nlinarith [ inv_mul_cancel_left₀ hi ( q.p i ), p.nonneg i, q.nonneg i, show 0 < p.p i from lt_of_le_of_ne ( p.nonneg i ) ( Ne.symm hi ) ];
      · exact fun h => hi <| hac i h;
    · exact fun h => hi <| hac i h;
  · contrapose! h_zero; have h_sum_zero : ∑ i, (p.p i * Real.log (p.p i / q.p i) - (p.p i - q.p i)) = 0 := by
      simp_all +decide [ Finset.sum_sub_distrib, klDiv ];
      rw [ p.sum_one, q.sum_one, sub_self ];
    have h_nonneg : ∀ i, p.p i * Real.log (p.p i / q.p i) - (p.p i - q.p i) ≥ 0 := by
      intro i
      by_cases hpi : p.p i = 0
      · simp [hpi]
        exact q.nonneg i
      · by_cases hqi : q.p i = 0
        · exact False.elim ( hpi ( hac i hqi ) )
        · have := Real.log_le_sub_one_of_pos ( show 0 < q.p i / p.p i from div_pos ( lt_of_le_of_ne ( q.nonneg i ) ( Ne.symm hqi ) ) ( lt_of_le_of_ne ( p.nonneg i ) ( Ne.symm hpi ) ) )
          rw [ Real.log_div ] at * <;> first | positivity | nlinarith [ mul_div_cancel₀ ( q.p i ) hpi, p.nonneg i, q.nonneg i ] ;
    exact fun i => eq_of_sub_eq_zero ( le_antisymm ( le_trans ( Finset.single_le_sum ( fun i _ => h_nonneg i ) ( Finset.mem_univ i ) ) h_sum_zero.le ) ( h_nonneg i ) );
  · convert klDiv_self p;
    cases p ; cases q ; aesop

/-! ## 3. Data processing and observer loss -/

/-- The information an observer loses by coarse-graining:
`L = D(p‖q) - D(Tp‖Tq) ≥ 0`. -/
def observerLoss (T : FinObs ι κ) (p q : FinDist ι) : ℝ :=
  klDiv p q - klDiv (pushforward T p) (pushforward T q)

/-
**Data-processing inequality (headline finite target).**  Coarse-graining
through any observer channel cannot increase relative entropy.

PROVED (was PROOF JOB #3, HEADLINE).  Proof via the finite log-sum
inequality (equivalently joint convexity of `(a,b) ↦ a log (a/b)`), summed over
the fibers of the channel.  This theorem is NOT in Mathlib and is the load-
bearing lemma for both branches.  Recommended decomposition:
  (a) `klFun_two` joint convexity / log-sum on two pairs;
  (b) `logSum` inequality over a finite index;
  (c) assemble over `j` then `i`.
Confidence the statement is correct: high.  Confidence it is provable at
current Aristotle strength with the decomposition: medium-high.
-/
theorem klDiv_dataProcessing (T : FinObs ι κ) (p q : FinDist ι)
    (hac : AbsCont p q) :
    klDiv (pushforward T p) (pushforward T q) ≤ klDiv p q := by
  -- Apply the log-sum inequality to each term in the sum.
  have h_log_sum : ∀ j, (∑ i, T.M j i * p.p i) * Real.log ((∑ i, T.M j i * p.p i) / (∑ i, T.M j i * q.p i)) ≤ ∑ i, T.M j i * p.p i * Real.log (p.p i / q.p i) := by
    intro j
    by_cases hq : ∑ i, T.M j i * q.p i = 0;
    · rw [ Finset.sum_eq_zero ] <;> simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg, mul_nonneg, T.nonneg, q.nonneg ];
      · exact Finset.sum_nonneg fun i _ => by cases hq i <;> simp +decide [ * ] ;
      · exact fun i => Or.imp id ( hac i ) ( hq i );
    · by_cases hp : ∑ i, T.M j i * p.p i = 0;
      · simp_all +decide [ Finset.sum_eq_zero_iff_of_nonneg, mul_nonneg, T.nonneg ];
        rw [ Finset.sum_eq_zero_iff_of_nonneg fun _ _ => mul_nonneg ( T.nonneg _ _ ) ( p.nonneg _ ) ] at hp;
        exact Finset.sum_nonneg fun i _ => by rw [ hp i ( Finset.mem_univ i ) ] ; norm_num;
      · have h_log_sum : ∀ i, T.M j i * p.p i * Real.log (p.p i / q.p i) ≥ T.M j i * p.p i * Real.log ((∑ i, T.M j i * p.p i) / (∑ i, T.M j i * q.p i)) + T.M j i * p.p i - (∑ i, T.M j i * p.p i) * (T.M j i * q.p i) / (∑ i, T.M j i * q.p i) := by
          intro i
          by_cases hpi : p.p i = 0;
          · simp_all +decide [ hac i ];
            exact div_nonneg ( mul_nonneg ( Finset.sum_nonneg fun _ _ => mul_nonneg ( T.nonneg _ _ ) ( p.nonneg _ ) ) ( mul_nonneg ( T.nonneg _ _ ) ( q.nonneg _ ) ) ) ( Finset.sum_nonneg fun _ _ => mul_nonneg ( T.nonneg _ _ ) ( q.nonneg _ ) );
          · by_cases hqi : q.p i = 0;
            · exact absurd ( hac i hqi ) hpi;
            · have := Real.log_le_sub_one_of_pos ( show 0 < ( ( ∑ i, T.M j i * p.p i ) / ∑ i, T.M j i * q.p i ) / ( p.p i / q.p i ) from div_pos ( div_pos ( lt_of_le_of_ne ( Finset.sum_nonneg fun _ _ => mul_nonneg ( T.nonneg _ _ ) ( p.nonneg _ ) ) ( Ne.symm hp ) ) ( lt_of_le_of_ne ( Finset.sum_nonneg fun _ _ => mul_nonneg ( T.nonneg _ _ ) ( q.nonneg _ ) ) ( Ne.symm hq ) ) ) ( div_pos ( lt_of_le_of_ne ( p.nonneg _ ) ( Ne.symm hpi ) ) ( lt_of_le_of_ne ( q.nonneg _ ) ( Ne.symm hqi ) ) ) );
              rw [ Real.log_div ( div_ne_zero hp hq ) ( div_ne_zero hpi hqi ) ] at this;
              field_simp at this ⊢;
              rw [ div_le_iff₀ ( lt_of_le_of_ne ( Finset.sum_nonneg fun _ _ => mul_nonneg ( T.nonneg _ _ ) ( q.nonneg _ ) ) ( Ne.symm hq ) ) ];
              rw [ le_div_iff₀ ( mul_pos ( lt_of_le_of_ne ( Finset.sum_nonneg fun _ _ => mul_nonneg ( T.nonneg _ _ ) ( q.nonneg _ ) ) ( Ne.symm hq ) ) ( lt_of_le_of_ne ( p.nonneg _ ) ( Ne.symm hpi ) ) ) ] at this;
              nlinarith [ T.nonneg j i ];
        refine' le_trans _ ( Finset.sum_le_sum fun i _ => h_log_sum i );
        simp +decide [ Finset.sum_add_distrib, ← Finset.sum_div _ _ _, mul_div_assoc, hp, hq ];
        simp +decide [ ← mul_div_assoc, ← Finset.sum_div _ _ _, ← Finset.mul_sum _ _ _, ← Finset.sum_mul, hp, hq ];
  unfold klDiv;
  refine' le_trans ( Finset.sum_le_sum fun j _ => h_log_sum j ) _;
  rw [ Finset.sum_comm ];
  simp +decide [ ← Finset.mul_sum _ _ _, ← Finset.sum_mul, T.col_sum_one ]

/-- Observer loss is nonnegative.  Immediate corollary of data processing. -/
theorem observerLoss_nonneg (T : FinObs ι κ) (p q : FinDist ι)
    (hac : AbsCont p q) :
    0 ≤ observerLoss T p q := by
  have h := klDiv_dataProcessing T p q hac
  unfold observerLoss
  linarith

/-! ## 4. Recoverability (finite Petz analogue) -/

/-- `R` exactly recovers `(T, p, q)` if pushing `p` and `q` forward through `T`
and back through `R` returns them unchanged. -/
def ExactRecovery (T : FinObs ι κ) (R : FinObs κ ι) (p q : FinDist ι) : Prop :=
  pushforward R (pushforward T p) = p ∧ pushforward R (pushforward T q) = q

/-
If a recovery channel exists, the observer loses no information: the
data-processing inequality is saturated.

PROVED (was PROOF JOB #4).  Apply `klDiv_dataProcessing` to `R` acting on
`(Tp, Tq)` to get `D(p‖q) = D(RTp‖RTq) ≤ D(Tp‖Tq) ≤ D(p‖q)`, forcing equality.
This is the finite, exact analogue of the Petz recoverability statement.
Confidence: high (given #3).
-/
theorem observerLoss_zero_of_exactRecovery (T : FinObs ι κ) (R : FinObs κ ι)
    (p q : FinDist ι) (hac : AbsCont p q)
    (hR : ExactRecovery T R p q) :
    observerLoss T p q = 0 := by
  refine' le_antisymm _ _;
  · unfold observerLoss;
    convert sub_nonpos_of_le ( klDiv_dataProcessing R ( pushforward T p ) ( pushforward T q ) _ ) using 1;
    · rw [ hR.1, hR.2 ];
    · intro j hj; simp_all +decide [ pushforward, applyObs ] ;
      rw [ Finset.sum_eq_zero_iff_of_nonneg fun _ _ => mul_nonneg ( T.nonneg _ _ ) ( q.nonneg _ ) ] at hj;
      exact Finset.sum_eq_zero fun i _ => by specialize hj i; by_cases hi : q.p i = 0 <;> aesop;
  · exact observerLoss_nonneg T p q hac

/-- The recoverability *gap*: the residual relative entropy not recovered by a
candidate recovery map `R`.  This is the finite diagnostic that P9 should use
for "approximate source invisibility": small gap ⇔ approximately recoverable.
It is a DEFINITION, not yet tied to any source functional. -/
def recoverabilityGap (T : FinObs ι κ) (R : FinObs κ ι) (p q : FinDist ι) : ℝ :=
  klDiv p q - klDiv (pushforward R (pushforward T p)) (pushforward R (pushforward T q))

/-! ## 5. Interface stubs (typed handoffs, NOT physics claims) -/

/-
The following are deliberately left as commented signatures.  They are the
points where this finite spine MEETS the rest of the program.  They are written
out so the API shape is fixed, but they are not Lean declarations here because
they depend on `PhysicsSM.*` modules absent from this scaffold package.

P7 / concurrence interface (visible/internal cut).  The visible qubit's
SINGLE-qubit linear entropy `2(1 - tr ρ²) = 4 det ρ` is, in the eigenbasis, the
classical KL/quadratic mixedness of the 2-point eigenvalue distribution.  The
honest bridge is to the classical `klDiv` on the *eigenvalue distribution* of
ρ_vis, NOT to the Wootters two-qubit concurrence formula.  Proposed handoff:

    -- def eigDist (ρ : QubitDensity) : FinDist (Fin 2) := <eigenvalues, PSD+trace1>
    -- theorem visibleObserver_mixedness_monotone
    --   (T : FinObs (Fin 2) (Fin 2)) ... : <classical DPI specialization>

  Boundary: this is monotonicity of a CLASSICAL mixedness functional under a
  classical (diagonal) observer channel; it is the disciplined analogue of the
  LOCC-only `m/E` monotonicity, not the full quantum statement.

P9 / source-visibility interface (diamond screen cut).  The observer channel is
the screen coarse-graining; the reference state σ is a finite (SJ-style) diamond
correlation distribution.  Proposed handoff:

    -- def sjDiamondReferenceState (D : DiamondData) : FinDist (Screen D)
    -- theorem relativeEntropyDataProcessing_for_diamondObserver := klDiv_dataProcessing
    -- def petzRecoverabilityGap_controls_sourceVisibility := recoverabilityGap (...)

  Boundary: ANEC/QNEC positivity and the SJ area law are CONTINUUM motivation;
  the finite theorem proves only data processing and the recoverability gap.
-/

end PhysicsSM.Draft.NullEdgeRelativeEntropyObserver

end

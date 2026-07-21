import Mathlib

/-!
# Changing-cell reuse audit (Opus, verified Aristotle f8eaa84b)

Probes the MC5 sub-claim 'reuse the changing-cell lemmas, generalized from two to
four components', flagged in
`AutonomousLab/work/NE-3PLUS1/OPUS_HNU_MASSIVE_CONTINUUM_AUDIT_2026-07-20.md`.

VERDICT: the reuse is NOT unconditional. It is free PRECISELY for operators of
`T (x) id_E` shape - equivalently (proved here) for linear operators commuting with
every coordinate embedding. For those, componentwiseLift inherits the scalar bound
K EXACTLY, for any finite component type.

SHARP COUNTEREXAMPLE: the mixing matrix [[1,1],[0,0]] has every scalar block of norm
at most 1, yet the vector-valued operator has norm EXACTLY sqrt 2 (upper bound for
every finite lattice; optimality witnessed by (1,1) on a one-site lattice). It is
not a componentwise lift and fails the commutation criterion.

CONSEQUENCE for MC5: each reused changing-cell lemma must be CLASSIFIED as
componentwise or component-mixing. Anything mixing the spinor index - e.g. a
nontrivial spinor-basis change - does NOT inherit the scalar constant and needs its
own operator-norm bound.

Namespace kept as the prover's ChangingCellAudit. Provenance: verified at pin from
task 9d19e5ed. Standard three. Grade M, [orig] (independent-review artifact). -/

open scoped BigOperators

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace ChangingCellAudit

/-- Squared `L²` norm on a finite lattice scope.  Keeping the square visible makes
Pythagorean decompositions literal finite-sum identities. -/
def l2Sq {Z E : Type*} [Fintype Z] [Fintype E] (f : Z → E → ℝ) : ℝ :=
  ∑ z, ∑ e, (f z e) ^ 2

/-- The corresponding scalar squared `L²` norm. -/
def scalarL2Sq {Z : Type*} [Fintype Z] (f : Z → ℝ) : ℝ :=
  ∑ z, (f z) ^ 2

/-- A scoped `L²` bound, expressed after squaring.  For `K ≥ 0` this is exactly
`‖A f‖₂ ≤ K ‖f‖₂`. -/
def L2Bound {Z E : Type*} [Fintype Z] [Fintype E]
    (K : ℝ) (A : (Z → E → ℝ) → (Z → E → ℝ)) : Prop :=
  ∀ f, l2Sq (A f) ≤ K ^ 2 * l2Sq f

/-- Scalar version of `L2Bound`. -/
def ScalarL2Bound {Z : Type*} [Fintype Z]
    (K : ℝ) (T : (Z → ℝ) → (Z → ℝ)) : Prop :=
  ∀ f, scalarL2Sq (T f) ≤ K ^ 2 * scalarL2Sq f

/-- Apply a scalar operator independently in every component.  This is the
finite-dimensional `T ⊗ id_E` construction. -/
def componentwiseLift {Z E : Type*}
    (T : (Z → ℝ) → (Z → ℝ)) (f : Z → E → ℝ) : Z → E → ℝ :=
  fun z e ↦ T (fun w ↦ f w e) z

/-
Pythagorean decomposition by components.
-/
theorem l2Sq_componentwiseLift {Z E : Type*} [Fintype Z] [Fintype E]
    (T : (Z → ℝ) → (Z → ℝ)) (f : Z → E → ℝ) :
    l2Sq (componentwiseLift T f) =
      ∑ e, scalarL2Sq (T (fun z ↦ f z e)) := by
  unfold l2Sq scalarL2Sq componentwiseLift; rw [ Finset.sum_comm ] ;

/-
**Free lift theorem.** A componentwise extension has exactly the same
bound as its scalar operator.
-/
theorem componentwiseLift_bound {Z E : Type*} [Fintype Z] [Fintype E]
    {K : ℝ} {T : (Z → ℝ) → (Z → ℝ)}
    (hT : ScalarL2Bound K T) :
    L2Bound K (componentwiseLift (E := E) T) := by
  intro f;
  convert Finset.sum_le_sum fun e _ => hT fun z => f z e using 1;
  convert l2Sq_componentwiseLift T f;
  simp +decide only [l2Sq, Finset.mul_sum _ _ _, scalarL2Sq];
  exact Finset.sum_comm

/-- Inclusion of scalar data into one component. -/
def componentEmbedding {Z E : Type*} [DecidableEq E]
    (e : E) (x : Z → ℝ) : Z → E → ℝ :=
  fun z j ↦ if j = e then x z else 0

/-- The precise coordinate-commutation criterion. -/
def CommutesWithComponentEmbeddings {Z E : Type*} [DecidableEq E]
    (A : (Z → E → ℝ) → (Z → E → ℝ))
    (T : (Z → ℝ) → (Z → ℝ)) : Prop :=
  ∀ e x, A (componentEmbedding e x) = componentEmbedding e (T x)

/-
For a linear operator, commuting with every coordinate inclusion is
*equivalent* to being `T ⊗ id_E`.
-/
theorem commute_iff_componentwise {Z E : Type*} [Fintype E] [DecidableEq E]
    (A : (Z → E → ℝ) →ₗ[ℝ] (Z → E → ℝ))
    (T : (Z → ℝ) →ₗ[ℝ] (Z → ℝ)) :
    CommutesWithComponentEmbeddings A T ↔
      ∀ f, A f = componentwiseLift T f := by
  constructor;
  · intro h f;
    ext z e; simp +decide [ componentwiseLift ] ;
    -- By linearity of $A$, we can expand $A(f)$ as a sum over $e$.
    have h_expand : A f = ∑ e', A (componentEmbedding e' (fun w => f w e')) := by
      rw [ ← map_sum ] ; congr ; ext ; simp +decide [ componentEmbedding ] ;
    simp_all +decide [ CommutesWithComponentEmbeddings, componentEmbedding ];
  · intro h e x;
    unfold componentwiseLift componentEmbedding at *;
    ext z j; by_cases hj : j = e <;> simp +decide [ * ] ;
    erw [ LinearMap.map_zero ] ; aesop

/-
Thus the commutation criterion is sufficient for the free bound.
-/
theorem commuting_operator_bound {Z E : Type*} [Fintype Z] [Fintype E]
    [DecidableEq E]
    (A : (Z → E → ℝ) →ₗ[ℝ] (Z → E → ℝ))
    (T : (Z → ℝ) →ₗ[ℝ] (Z → ℝ)) {K : ℝ}
    (hcomm : CommutesWithComponentEmbeddings A T)
    (hT : ScalarL2Bound K T) : L2Bound K A := by
  convert componentwiseLift_bound hT using 1;
  · exact funext fun f => ( commute_iff_componentwise A T ).mp hcomm f;
  · infer_instance

/-- A concrete component-mixing matrix. -/
def mixingMatrix : Matrix (Fin 2) (Fin 2) ℝ := !![1, 1; 0, 0]

/-- The matrix acts independently at each lattice site, but mixes the two
internal components. -/
def mixingOperator {Z : Type*} (f : Z → Fin 2 → ℝ) : Z → Fin 2 → ℝ :=
  fun z ↦ Matrix.mulVec mixingMatrix (f z)

/-
Every scalar matrix block of the mixing operator has norm at most one.
-/
theorem mixing_component_blocks_bound {Z : Type*} [Fintype Z] :
    ∀ i j : Fin 2,
      ScalarL2Bound 1 (fun (x : Z → ℝ) (z : Z) ↦
        mixingOperator (componentEmbedding j x) z i) := by
  intro i j h; fin_cases i <;> fin_cases j <;> simp +decide [mixingOperator] ;
  · unfold mixingMatrix componentEmbedding scalarL2Sq; simp +decide [Matrix.mulVec] ;
    simp +decide [ Matrix.vecHead, Matrix.vecTail ];
  · unfold mixingMatrix componentEmbedding; simp +decide [ Matrix.mulVec ] ;
    simp +decide [ Matrix.vecHead, Matrix.vecTail, scalarL2Sq ];
  · unfold mixingMatrix componentEmbedding; norm_num [ Matrix.mulVec ] ;
    exact Finset.sum_le_sum fun _ _ => by simp +decide ; positivity;
  · simp +decide [scalarL2Sq, mixingMatrix, Matrix.mulVec];
    exact Finset.sum_nonneg fun _ _ => sq_nonneg _

/-
Its full vector-valued norm is at most `√2`.
-/
theorem mixing_bound_sqrt_two {Z : Type*} [Fintype Z] :
    L2Bound (Real.sqrt 2) (mixingOperator (Z := Z)) := by
  intro f
  simp [l2Sq, mixingOperator];
  norm_num [ Fin.sum_univ_succ, Matrix.mulVec ];
  rw [ Finset.mul_sum _ _ _ ] ; exact Finset.sum_le_sum fun i _ => by norm_num [ mixingMatrix ] ; nlinarith [ sq_nonneg ( f i 0 - f i 1 ) ] ;

/-
An explicit one-site vector shows that every valid nonnegative bound for
`mixingOperator` is at least `√2`; hence its scoped `L²` operator norm is
exactly `√2`.
-/
theorem mixing_bound_optimal {K : ℝ} (hK : 0 ≤ K)
    (h : L2Bound K (mixingOperator (Z := Unit))) :
    Real.sqrt 2 ≤ K := by
  convert Real.sqrt_le_iff.mpr _;
  have := h ( fun _ => 1 ) ; norm_num [ l2Sq, mixingOperator, mixingMatrix ] at this;
  exact ⟨ hK, by norm_num [ Matrix.vecHead, Matrix.vecTail ] at this; linarith ⟩

/-
In particular, the full norm is strictly larger than the common bound one
for all of its scalar component blocks.
-/
theorem mixing_not_bound_one :
    ¬ L2Bound 1 (mixingOperator (Z := Unit)) := by
  intro h
  have h_contra : Real.sqrt 2 ≤ 1 := by
    exact mixing_bound_optimal zero_le_one h;
  norm_num [ Real.sqrt_le_iff ] at h_contra

/-
The witness is genuinely non-componentwise: there is no scalar operator
whose componentwise lift is this mixing map.
-/
theorem mixing_not_componentwise :
    ¬ ∃ T : (Unit → ℝ) →ₗ[ℝ] (Unit → ℝ),
      ∀ f, mixingOperator f = componentwiseLift T f := by
  rintro ⟨ T, hT ⟩ ; have := hT ( fun _ => 1 ) ; norm_num [ funext_iff, Fin.forall_fin_two, componentwiseLift, mixingOperator ] at this;
  norm_num [ ← this Unit.unit, mixingMatrix ] at this;
  norm_num [ Matrix.vecHead, Matrix.vecTail ] at this

/-
Equivalently, the component-embedding commutation criterion is not
automatic for vector-valued operators.
-/
theorem mixing_fails_commutation :
    ¬ ∃ T : (Unit → ℝ) →ₗ[ℝ] (Unit → ℝ),
      CommutesWithComponentEmbeddings (mixingOperator (Z := Unit)) T := by
  rintro ⟨ T, hT ⟩;
  have := hT 0 ( fun _ => 1 ) ; have := hT 1 ( fun _ => 1 ) ; norm_num [ funext_iff, Fin.forall_fin_two, Matrix.mulVec ] at *;
  unfold mixingOperator componentEmbedding at * ; norm_num at *;
  unfold mixingMatrix at * ; norm_num [ Matrix.mulVec ] at *;
  norm_num [ Matrix.vecHead, Matrix.vecTail ] at *

end ChangingCellAudit

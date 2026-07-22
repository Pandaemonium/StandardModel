import Mathlib

/-!
# Which symmetry groups permit hyperuniformity? A rank dichotomy, with my own claim refuted

Finite linear algebra about invariant covariance matrices, arising from the `Lambda`
lane. A covariance is *hyperuniform* here when it annihilates the uniform (grand-total)
mode; the question is how the invariance group constrains the **regional** variance
`V(C, A) = 1_A . C 1_A`.

## What is proved

* `uniform_mode_eigenvector` - for a transitive action, every invariant matrix has
  constant row sum, so the uniform vector is an eigenvector, and hyperuniformity reduces
  to a single scalar row-sum equation (`hyperuniform_iff_one_row_sum`).
* `pairClassIndicator_basis` - pair-class indicators give unique coordinates for matrices
  constant on a surjective pair-class labelling: the orbit-indicator dimension statement.
* `rankTwo_rigidity` - **the rigidity half.** Every PSD hyperuniform rank-two (i.e.
  2-transitive-invariant) matrix is `q . (I - (1/N) . J)` with `q >= 0`, and its regional
  variance is exactly `q |A| (N - |A|) / N` - the finite-population law, linear in `|A|`
  for small regions.
* `cyclicCovariance6_*` and `rank_dichotomy_witness` - **the freedom half**, as an
  explicit six-cycle Laplacian witness: symmetric, rotation invariant under a transitive
  action with at least three pair-orbits, PSD by an exact sum-of-squares identity,
  hyperuniform, nonzero, and with regional variance exactly `2` for **every** proper
  nonempty arc - bounded, not growing with arc length.
* `cyclic_rankTwo_explicit_comparison` - the two laws side by side at arc size three:
  cyclic variance `2` versus rank-two diagonal-normalized variance `18/5`.

## MY REQUESTED CLAIM WAS REFUTED, and the refutation is the interesting part

I asked for: *a transitive group admits a nonzero invariant PSD hyperuniform covariance
only if its rank is at least three.* That is **FALSE**, and `rankTwo_nonzero_counterexample`
proves it: rank two already admits the nonzero covariance `I - J/N` for every `N >= 2` -
the projector onto the zero-sum subspace, which is PSD, invariant, and kills the uniform
mode. Existence is never the obstruction.

The valid dichotomy is about the **shape of the regional variance**, not about existence:

> Rank two FORCES the finite-population law `V(A) = q |A| (N - |A|) / N`, which grows
> linearly in `|A|` for small regions. Higher rank PERMITS bounded regional variance -
> the six-cycle witness has arc variance exactly `2` regardless of arc length.

So a maximally symmetric (2-transitive) invariance does not forbid hyperuniform
covariances; it forbids them from being *regionally* quiet. That is a sharper and more
useful statement than the one I asked for. The prover also caught that my target-3
formula mixed two normalizations, and proved both correct versions separately
(`rankTwo_rigidity` in the `q` normalization, `rankTwo_variance_diagonal_normalization`
in the `a = C 0 0` normalization).

## Scope - read `AgentTasks/lambda-harvest-governance-2026-07-21.md` before glossing this

This is finite linear algebra about invariant covariance matrices. It is **not** a
theorem about point processes, sprinklings, or Lorentz invariance, and it derives
nothing about the value, sign, or magnitude of `Lambda`.

In particular, do **not** say that invariance forbids hyperuniformity. It does not:
Torquato's reviews (arXiv:1801.06924, arXiv:1608.02212) define disordered hyperuniform
systems as ones that are *statistically isotropic*, and such systems are the central
objects of a large active field. Physical isotropy leaves one pair-orbit per distance -
an infinite-rank symmetry with ample room. The hypothesis here is 2-transitivity, which
is the much stronger condition that the symmetry retains **no notion of separation at
all**. The Lorentz group has the interval as a pair invariant and is nowhere near rank
two, so nothing here bears on the causal-set hyperuniformity question. An earlier gloss
of mine claiming otherwise was withdrawn on 2026-07-21.

Provenance: Aristotle project `8ee92569-255d-4c01-8455-e32bef13881a`, task
`3082e64f-9c60-4f5a-8454-1c4b5322a975`, verified verbatim at the pinned toolchain.
The prover's short namespace `HyperuniformRank` is kept verbatim, per this repository's
practice of not renaming into long dotted paths (which has broken `simp +decide` proofs
before). Claim grade `M`, `[orig]` for the dichotomy statement and the refutation.
-/

open scoped BigOperators
open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace HyperuniformRank

variable {G X : Type*} [Group G] [Fintype X] [DecidableEq X] [MulAction G X]

/-- Invariance of a matrix under the diagonal action on ordered pairs. -/
def IsInvariant (C : Matrix X X ℝ) : Prop :=
  ∀ (g : G) (x y : X), C (g • x) (g • y) = C x y

/-- Positive semidefiniteness, in quadratic-form language. -/
def IsPSD (C : Matrix X X ℝ) : Prop :=
  ∀ v : X → ℝ, 0 ≤ dotProduct v (C.mulVec v)

/-- The real-valued indicator of a finite region. -/
def regionIndicator (A : Finset X) : X → ℝ := fun x => if x ∈ A then 1 else 0

/-- The variance assigned by `C` to the indicator of a finite region. -/
def regionalVariance (C : Matrix X X ℝ) (A : Finset X) : ℝ :=
  dotProduct (regionIndicator A) (C.mulVec (regionIndicator A))

/-- The grand-total (uniform) mode is suppressed. -/
def IsHyperuniform (C : Matrix X X ℝ) : Prop :=
  C.mulVec (fun _ => 1) = 0

/-
For a transitive action, every invariant matrix has constant row sum, so the
uniform vector is an eigenvector.
-/
theorem uniform_mode_eigenvector [MulAction.IsPretransitive G X]
    (C : Matrix X X ℝ) (hC : IsInvariant (G := G) C) :
    ∃ lam : ℝ, C.mulVec (fun _ : X => (1 : ℝ)) =
      lam • (fun _ : X => (1 : ℝ)) := by
  -- By definition of invariance, we know that for any $g \in G$, $C_{g(x), g(y)} = C_{x,y}$ for all $x, y \in X$.
  have h_invariance : ∀ g : G, ∀ x y : X, C (g • x) (g • y) = C x y := by
    exact hC;
  -- By definition of invariance, each row sum is the same.
  have h_row_sum : ∀ x y : X, ∑ i, C x i = ∑ i, C y i := by
    intro x y;
    obtain ⟨g, hg⟩ : ∃ g : G, g • y = x := by
      exact MulAction.exists_smul_eq G y x;
    rw [ ← hg, ← Equiv.sum_comp ( Equiv.ofBijective ( fun i => g • i ) ⟨ fun i => by aesop, fun i => by exact ⟨ g⁻¹ • i, by simp +decide ⟩ ⟩ ) ] ; aesop;
  cases isEmpty_or_nonempty X <;> simp_all +decide [ funext_iff, Matrix.mulVec, dotProduct ];
  exact ⟨ _, fun x => h_row_sum x ( Classical.arbitrary X ) ⟩

section OrbitIndicatorBasis

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- Indicator matrix of one (symmetrized) pair class. -/
def pairClassIndicator (label : X × X → I) (i : I) : Matrix X X ℝ :=
  fun x y => if label (x, y) = i then 1 else 0

/-- A matrix is constant on the pair classes selected by `label`. -/
def ConstantOnPairClasses (label : X × X → I) (C : Matrix X X ℝ) : Prop :=
  ∀ p q : X × X, label p = label q → C p.1 p.2 = C q.1 q.2

/-
Indicators of a surjective finite pair-class labeling give unique coordinates
for every matrix constant on those classes.  Taking `I` to be the symmetrized
pair-orbits gives the requested dimension count.
-/
theorem pairClassIndicator_basis (label : X × X → I)
    (hsurj : Function.Surjective label) (C : Matrix X X ℝ)
    (hC : ConstantOnPairClasses label C) :
    ∃! a : I → ℝ,
      C = ∑ i : I, a i • pairClassIndicator label i := by
  refine' ⟨ fun i => C ( Classical.choose ( hsurj i ) |>.1 ) ( Classical.choose ( hsurj i ) |>.2 ), _, _ ⟩;
  · ext x y; simp +decide [ pairClassIndicator ] ;
    simp +decide [ pairClassIndicator, Matrix.sum_apply ];
    exact hC ( x, y ) ( Classical.choose ( hsurj ( label ( x, y ) ) ) ) ( by simp +decide [ Classical.choose_spec ( hsurj ( label ( x, y ) ) ) ] );
  · intro a ha;
    ext i; simp +decide [ ha, pairClassIndicator ] ;
    rw [ Finset.sum_apply, Finset.sum_apply ] ; simp +decide [ Classical.choose_spec ( hsurj i ), pairClassIndicator ]

/-
For an invariant matrix under a transitive action, hyperuniformity is exactly
one scalar row-sum equation.
-/
theorem hyperuniform_iff_one_row_sum [MulAction.IsPretransitive G X]
    (C : Matrix X X ℝ) (hC : IsInvariant (G := G) C) (x : X) :
    IsHyperuniform C ↔ ∑ y : X, C x y = 0 := by
  constructor <;> intro h;
  · simpa [ Matrix.mulVec, dotProduct ] using congr_fun h x;
  · obtain ⟨ lam, hl ⟩ := uniform_mode_eigenvector C hC;
    have := congr_fun hl x; simp_all +decide [ Matrix.mulVec, dotProduct ] ;
    exact funext fun y => by simpa [ ← this ] using congr_fun hl y;

end OrbitIndicatorBasis

section RankTwo

variable {N : ℕ} [NeZero N]

/-- The concrete algebraic content of rank two: entries depend only on whether
an ordered pair is diagonal or off diagonal. -/
def HasRankTwoForm (C : Matrix (Fin N) (Fin N) ℝ) : Prop :=
  ∃ d o : ℝ, ∀ i j, C i j = if i = j then d else o

/-- The identity matrix. -/
def identityMatrix : Matrix (Fin N) (Fin N) ℝ := fun i j => if i = j then 1 else 0

/-- The all-ones matrix. -/
def onesMatrix : Matrix (Fin N) (Fin N) ℝ := fun _ _ => 1

/-
Rank-two rigidity in the coefficient normalization that is algebraically
consistent: the projection coefficient is `q`, and its regional variance has
denominator `N`.
-/
theorem rankTwo_rigidity
    (hN : 2 ≤ N) (C : Matrix (Fin N) (Fin N) ℝ)
    (hr : HasRankTwoForm C) (hpsd : IsPSD C) (hhu : IsHyperuniform C) :
    ∃ q : ℝ, 0 ≤ q ∧
      C = q • (identityMatrix - (1 / (N : ℝ)) • onesMatrix) ∧
      ∀ A : Finset (Fin N),
        regionalVariance C A =
          q * (A.card : ℝ) * ((N : ℝ) - A.card) / N := by
  -- Prove that $C$ is of the form $q • (identityMatrix - (1 / N) • onesMatrix)$.
  obtain ⟨q, hq⟩ : ∃ q : ℝ, C = q • (identityMatrix - (1 / N : ℝ) • onesMatrix) := by
    obtain ⟨ d, o, h ⟩ := hr;
    -- By definition of $C$, we know that $d + (N-1)o = 0$.
    have h_eq : d + (N - 1) * o = 0 := by
      convert congr_fun hhu ⟨ 0, by linarith ⟩ using 1 ; simp +decide [ h, Matrix.mulVec, dotProduct ] ; ring;
      simp +decide [ Finset.sum_ite, Finset.filter_eq, Finset.filter_ne ] ; ring;
      rw [ Nat.cast_pred ] <;> linarith;
    use d - o;
    ext i j; simp +decide [ h, identityMatrix, onesMatrix ] ; split_ifs <;> ring;
    · nlinarith [ inv_mul_cancel_left₀ ( by positivity : ( N : ℝ ) ≠ 0 ) d, inv_mul_cancel_left₀ ( by positivity : ( N : ℝ ) ≠ 0 ) o, ( by norm_cast : ( 2 : ℝ ) ≤ N ) ];
    · field_simp;
      linarith;
  refine' ⟨ q, _, hq, _ ⟩;
  · specialize hpsd ( Pi.single ⟨ 0, by linarith ⟩ 1 ) ; simp_all +decide [ Matrix.mulVec, dotProduct ];
    simp_all +decide [ Finset.sum_apply, Pi.single_apply, identityMatrix, onesMatrix ];
    nlinarith [ inv_lt_one_of_one_lt₀ ( by norm_cast : ( 1 : ℝ ) < N ) ];
  · intro A; simp +decide [ *, regionalVariance, dotProduct, Matrix.mulVec ] ; ring;
    simp +decide [ regionIndicator, identityMatrix, onesMatrix, Finset.sum_ite, Finset.filter_eq, Finset.filter_ne ];
    simpa [ NeZero.ne ] using by ring;

/-
In diagonal-entry normalization, the familiar finite-population formula has
denominator `N-1`.
-/
theorem rankTwo_variance_diagonal_normalization
    (hN : 2 ≤ N) (C : Matrix (Fin N) (Fin N) ℝ)
    (hr : HasRankTwoForm C) (hpsd : IsPSD C) (hhu : IsHyperuniform C) :
    let a := C 0 0
    0 ≤ a ∧
    C = (a * (N : ℝ) / (N - 1 : ℕ)) •
      (identityMatrix - (1 / (N : ℝ)) • onesMatrix) ∧
    ∀ A : Finset (Fin N),
      regionalVariance C A =
        a * (A.card : ℝ) * ((N : ℝ) - A.card) / (N - 1 : ℕ) := by
  obtain ⟨q, hq_nonneg, hq_eq, hq_var⟩ := rankTwo_rigidity hN C hr hpsd hhu;
  rcases N with ( _ | _ | N ) <;> simp_all +decide [ identityMatrix, onesMatrix ];
  field_simp;
  exact ⟨ by nlinarith, by rw [ show ( q * ( N + 1 + 1 - 1 ) / ( N + 1 ) : ℝ ) = q by rw [ div_eq_iff ( by linarith ) ] ; ring ], fun A => by ring ⟩

/-
A rank-two PSD hyperuniform covariance with zero diagonal is zero.
-/
theorem rankTwo_zero_of_diagonal_zero
    (hN : 2 ≤ N) (C : Matrix (Fin N) (Fin N) ℝ)
    (hr : HasRankTwoForm C) (hpsd : IsPSD C) (hhu : IsHyperuniform C)
    (hdiag : C 0 0 = 0) : C = 0 := by
  obtain ⟨q, hq⟩ := rankTwo_variance_diagonal_normalization hN C hr hpsd hhu;
  simpa [ hdiag ] using hq.1

/-
Rank two does *not* forbid nonzero PSD hyperuniform covariances: the
mean-zero orthogonal projection is a counterexample to that proposed claim.
-/
theorem rankTwo_nonzero_counterexample (hN : 2 ≤ N) :
    let C : Matrix (Fin N) (Fin N) ℝ :=
      identityMatrix - (1 / (N : ℝ)) • onesMatrix
    HasRankTwoForm C ∧ IsPSD C ∧ IsHyperuniform C ∧ C ≠ 0 := by
  refine' ⟨ _, _, _, _ ⟩;
  · refine' ⟨ 1 - ( 1 / N : ℝ ), - ( 1 / N : ℝ ), _ ⟩;
    unfold identityMatrix onesMatrix; aesop;
  · intro v;
    -- By definition of matrix multiplication and the properties of the identity and ones matrices, we can simplify the expression.
    have h_simp : v ⬝ᵥ (identityMatrix - (1 / N : ℝ) • onesMatrix) *ᵥ v = ∑ i, v i ^ 2 - (1 / N : ℝ) * (∑ i, v i) ^ 2 := by
      simp +decide [ Matrix.mulVec, dotProduct, Finset.mul_sum _ _ _, Finset.sum_mul, sq ];
      simp +decide [ identityMatrix, onesMatrix, Finset.sum_sub_distrib, mul_sub, sub_mul, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _ ];
    have h_cauchy_schwarz : (∑ i : Fin N, v i) ^ 2 ≤ N * ∑ i : Fin N, v i ^ 2 := by
      have := ( Finset.univ.sum_le_sum fun i _ => mul_self_nonneg ( v i - ( ∑ i : Fin N, v i ) / N ) );
      simp_all +decide [ add_mul, sub_mul, mul_sub ];
      case _ => simp_all +decide only [← Finset.sum_mul, ← sq, ← Finset.mul_sum _ _ _] ; nlinarith [ mul_div_cancel₀ ( ( ∑ i, v i ) : ℝ ) ( by positivity : ( N : ℝ ) ≠ 0 ) ] ;
    nlinarith [ show ( N : ℝ ) ≥ 2 by norm_cast, one_div_mul_cancel ( by positivity : ( N : ℝ ) ≠ 0 ) ];
  · ext i; norm_num [ Matrix.mulVec, dotProduct ] ; ring;
    simp +decide [ identityMatrix, onesMatrix ];
  · intro h; have := congr_fun ( congr_fun h ⟨ 0, by linarith ⟩ ) ⟨ 0, by linarith ⟩ ; norm_num [ identityMatrix, onesMatrix ] at this; rcases N with ( _ | _ | N ) <;> norm_num at *;
    nlinarith [ inv_mul_cancel₀ ( by linarith : ( N : ℝ ) + 1 + 1 ≠ 0 ) ]

end RankTwo

section CyclicWitness

/-- The cycle-graph Laplacian on six sites. -/
def cyclicCovariance6 : Matrix (Fin 6) (Fin 6) ℝ := fun i j =>
  if i = j then 2
  else if i = j + 1 ∨ j = i + 1 then -1
  else 0

/-- Translation on the six-cycle. -/
def rotate6 (g x : Fin 6) : Fin 6 := g + x

/-
The cyclic witness is symmetric.
-/
theorem cyclicCovariance6_symmetric : cyclicCovariance6.IsSymm := by
  ext i j; fin_cases i <;> fin_cases j <;> rfl;

/-
The cyclic witness is invariant under every rotation.
-/
theorem cyclicCovariance6_invariant :
    ∀ g x y : Fin 6,
      cyclicCovariance6 (rotate6 g x) (rotate6 g y) = cyclicCovariance6 x y := by
  unfold cyclicCovariance6;
  norm_num [ Fin.val_add ] ; norm_cast

/-
The cycle Laplacian quadratic form is a sum of edge squares.
-/
theorem cyclicCovariance6_quadratic (v : Fin 6 → ℝ) :
    dotProduct v (cyclicCovariance6.mulVec v) =
      ∑ i : Fin 6, (v i - v (i + 1)) ^ 2 := by
  unfold cyclicCovariance6;
  simp +decide [ Fin.sum_univ_six, dotProduct, Matrix.mulVec, Finset.sum_add_distrib, sub_sq ] ; ring!

/-
Hence the cyclic witness is positive semidefinite.
-/
theorem cyclicCovariance6_psd : IsPSD cyclicCovariance6 := by
  exact fun x => by rw [ cyclicCovariance6_quadratic ] ; exact Finset.sum_nonneg fun _ _ => sq_nonneg _;

/-
Its uniform mode is in the kernel.
-/
theorem cyclicCovariance6_hyperuniform : IsHyperuniform cyclicCovariance6 := by
  ext i; simp +decide [ Matrix.mulVec, dotProduct, cyclicCovariance6 ] ;
  fin_cases i <;> norm_cast

/-- Initial cyclic arcs, of lengths `0` through `6`. -/
def arc6 (k : ℕ) : Finset (Fin 6) := Finset.univ.filter fun i => i.val < k

/-
Every proper nonempty initial arc has boundary variance exactly two.
-/
theorem cyclicCovariance6_arc_variance (k : ℕ) (hk0 : 0 < k) (hk6 : k < 6) :
    regionalVariance cyclicCovariance6 (arc6 k) = 2 := by
  interval_cases k <;> simp +decide [ regionalVariance, cyclicCovariance6, arc6 ] at *;
  · unfold regionIndicator cyclicCovariance6 ;
    simp +decide [ Fin.sum_univ_succ, Matrix.mulVec, dotProduct ];
  · unfold regionIndicator cyclicCovariance6 ;
    norm_num [ Fin.sum_univ_succ, dotProduct, Matrix.mulVec ];
  · norm_num [ Matrix.mulVec, dotProduct, regionIndicator, cyclicCovariance6 ];
    norm_cast;
  · unfold regionIndicator cyclicCovariance6 ;
    simp +decide [ dotProduct, Matrix.mulVec ];
    norm_cast;
  · unfold regionIndicator cyclicCovariance6 ;
    simp +decide [ dotProduct, Matrix.mulVec ];
    norm_cast

/-
The witness is nonzero.
-/
theorem cyclicCovariance6_nonzero : cyclicCovariance6 ≠ 0 := by
  exact ne_of_apply_ne ( fun m => m 0 0 ) ( by norm_num [ cyclicCovariance6 ] )

/-
At three sites the cyclic variance is `2`, whereas the rank-two projection
with the same diagonal (`a = 2`) would give `18/5`.
-/
theorem cyclic_rankTwo_explicit_comparison :
    regionalVariance cyclicCovariance6 (arc6 3) = 2 ∧
    (2 : ℝ) * 3 * (6 - 3) / (6 - 1) = 18 / 5 ∧
    (2 : ℝ) ≠ 18 / 5 := by
  grind +suggestions

/-
The regular cyclic action is transitive.
-/
theorem rotate6_transitive : ∀ x y : Fin 6, ∃ g : Fin 6, rotate6 g x = y := by
  intro x y
  exact ⟨y - x, by simp [rotate6]⟩

/-- Translation-equivalence of ordered pairs for the regular cyclic action. -/
def PairTranslationEquivalent (p q : Fin 6 × Fin 6) : Prop :=
  ∃ g : Fin 6, q.1 = g + p.1 ∧ q.2 = g + p.2

/-
Three displayed ordered pairs lie in distinct translation orbits; thus this
transitive cyclic action has rank at least three.
-/
theorem cyclic_action_has_three_pair_orbits :
    ¬ PairTranslationEquivalent (0, 0) (0, 1) ∧
    ¬ PairTranslationEquivalent (0, 0) (0, 2) ∧
    ¬ PairTranslationEquivalent (0, 1) (0, 2) := by
  simp +decide [ PairTranslationEquivalent ]

/-
The precise proved dichotomy: rank two forces the finite-population variance
law, while a transitive cyclic action with at least three pair-orbits admits a
nonzero invariant PSD hyperuniform covariance with constant proper-arc variance.
-/
theorem rank_dichotomy_witness :
    (∀ x y : Fin 6, ∃ g : Fin 6, rotate6 g x = y) ∧
    (¬ PairTranslationEquivalent (0, 0) (0, 1) ∧
      ¬ PairTranslationEquivalent (0, 0) (0, 2) ∧
      ¬ PairTranslationEquivalent (0, 1) (0, 2)) ∧
    cyclicCovariance6.IsSymm ∧
    (∀ g x y : Fin 6,
      cyclicCovariance6 (rotate6 g x) (rotate6 g y) = cyclicCovariance6 x y) ∧
    IsPSD cyclicCovariance6 ∧ IsHyperuniform cyclicCovariance6 ∧
    cyclicCovariance6 ≠ 0 ∧
    (∀ k : ℕ, 0 < k → k < 6 →
      regionalVariance cyclicCovariance6 (arc6 k) = 2) := by
  exact ⟨rotate6_transitive, cyclic_action_has_three_pair_orbits,
    cyclicCovariance6_symmetric, cyclicCovariance6_invariant,
    cyclicCovariance6_psd, cyclicCovariance6_hyperuniform,
    cyclicCovariance6_nonzero, cyclicCovariance6_arc_variance⟩

end CyclicWitness

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'HyperuniformRank.uniform_mode_eigenvector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms uniform_mode_eigenvector
/-- info: 'HyperuniformRank.pairClassIndicator_basis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pairClassIndicator_basis
/-- info: 'HyperuniformRank.hyperuniform_iff_one_row_sum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hyperuniform_iff_one_row_sum
/-- info: 'HyperuniformRank.rankTwo_rigidity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankTwo_rigidity
/-- info: 'HyperuniformRank.rankTwo_variance_diagonal_normalization' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankTwo_variance_diagonal_normalization
/-- info: 'HyperuniformRank.rankTwo_zero_of_diagonal_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankTwo_zero_of_diagonal_zero
/-- info: 'HyperuniformRank.rankTwo_nonzero_counterexample' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankTwo_nonzero_counterexample
/-- info: 'HyperuniformRank.cyclicCovariance6_symmetric' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclicCovariance6_symmetric
/-- info: 'HyperuniformRank.cyclicCovariance6_quadratic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclicCovariance6_quadratic
/-- info: 'HyperuniformRank.cyclicCovariance6_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclicCovariance6_invariant
/-- info: 'HyperuniformRank.cyclicCovariance6_psd' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclicCovariance6_psd
/-- info: 'HyperuniformRank.cyclicCovariance6_hyperuniform' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclicCovariance6_hyperuniform
/-- info: 'HyperuniformRank.cyclicCovariance6_arc_variance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclicCovariance6_arc_variance
/-- info: 'HyperuniformRank.cyclicCovariance6_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclicCovariance6_nonzero
/-- info: 'HyperuniformRank.cyclic_rankTwo_explicit_comparison' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclic_rankTwo_explicit_comparison
/-- info: 'HyperuniformRank.rotate6_transitive' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rotate6_transitive
/-- info: 'HyperuniformRank.cyclic_action_has_three_pair_orbits' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms cyclic_action_has_three_pair_orbits
/-- info: 'HyperuniformRank.rank_dichotomy_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rank_dichotomy_witness

end HyperuniformRank

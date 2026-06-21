import Mathlib

/-!
# Draft.NullEdgeCoreAristotle

Aristotle handoff for the highest-leverage finite theorem targets in the
null-edge causal graph program.

Source notes:
- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Toward_a_Null-Edge_Causal_Graph_Formulation.md`
- `Sources/Luminal_Motion_Checkerboard_Research_Program.md`

The goal is not to formalize a full continuum theory.  This file isolates
three finite, kernel-checkable theorem islands that directly support the
program:

1. Pluecker mass: a two-edge bundle of complex null spinors has determinant
   mass equal to the squared spinor wedge.
2. Causal-diamond holonomy: the Abelian path-comparison defect is invariant
   under vertex gauge transformations.
3. Order-complex seed: the alternating boundary on formal simplices squares
   to zero, the combinatorial start of a graph-native Kahler-Dirac branch.

All statements below are draft targets for Aristotle.  They may contain
documented `s o r r y`s here, and should not be moved to trusted code until the
proofs are reviewed, placeholder-free, and the convention choices are checked.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeCore

open Matrix Complex

/-! ## Target A: Pluecker mass for two complex null spinors -/

/-- A visible complex Weyl spinor attached to a null edge. -/
abbrev CSpinor := Fin 2 -> ℂ

/-- The rank-one Hermitian bispinor `psi psi^dagger`. -/
def rankOneHermitian (psi : CSpinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.vecMulVec psi (star psi)

/-- The spinor wedge / Pluecker coordinate of two complex 2-spinors. -/
def spinorWedge (psi phi : CSpinor) : ℂ :=
  psi 0 * phi 1 - psi 1 * phi 0

/-- Complex squared modulus, valued in `ℂ` for direct comparison with a determinant. -/
def complexAbsSq (z : ℂ) : ℂ :=
  z * (starRingEnd ℂ) z

/-- The Hermitian momentum matrix of a two-edge visible bundle. -/
def twoEdgeMomentum (psi phi : CSpinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  rankOneHermitian psi + rankOneHermitian phi

/--
A single visible null edge is massless: the determinant of `psi psi^dagger`
vanishes.
-/
theorem det_rankOneHermitian_eq_zero (psi : CSpinor) :
    (rankOneHermitian psi).det = 0 := by
  simp [rankOneHermitian, Matrix.det_fin_two, Matrix.vecMulVec]
  ring

/--
Two-edge Pluecker mass identity.  The determinant of the summed null momenta
is the squared modulus of the spinor wedge.

This is the finite algebraic keystone of the null-edge program:
mass is not attached to one edge, but to the Pluecker spread of a bundle of
non-collinear null edges.
-/
theorem two_edge_plucker_mass_identity (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = complexAbsSq (spinorWedge psi phi) := by
  simp [twoEdgeMomentum, rankOneHermitian, Matrix.det_fin_two, Matrix.vecMulVec,
    spinorWedge, complexAbsSq]
  ring

/--
Squared complex modulus vanishes exactly when the complex number vanishes.
-/
theorem complexAbsSq_eq_zero_iff (z : ℂ) :
    complexAbsSq z = 0 ↔ z = 0 := by
  exact mul_eq_zero.trans ( or_iff_left_of_imp fun h => by simpa using h )

/--
The two-edge bundle is massless exactly when the two spinor directions have
zero Pluecker spread.
-/
theorem two_edge_mass_zero_iff_wedge_zero (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = 0 ↔ spinorWedge psi phi = 0 := by
  exact two_edge_plucker_mass_identity psi phi ▸ complexAbsSq_eq_zero_iff _

/--
Zero Pluecker spread is projective collinearity, stated in a form that avoids
quotients: if `psi` is nonzero, then `phi` is a scalar multiple of `psi`.
-/
theorem spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
    (psi phi : CSpinor) (hpsi : psi 0 ≠ 0 ∨ psi 1 ≠ 0) :
    spinorWedge psi phi = 0 ↔ ∃ c : ℂ, phi = c • psi := by
  constructor
  · intro h
    by_cases h0 : psi 0 = 0
    · simp_all [funext_iff, Fin.forall_fin_two, spinorWedge]
      exact ⟨ phi 1 / psi 1, by rw [ div_mul_cancel₀ _ hpsi ] ⟩
    · refine ⟨ phi 0 / psi 0, ?_ ⟩
      ext i; fin_cases i <;> simp_all [spinorWedge]
      grind
  · rintro ⟨ c, rfl ⟩
    simp [spinorWedge, mul_comm]
    ring

/-! ## Target B: Abelian causal-diamond holonomy -/

/--
The four edge labels of a finite causal diamond:

```
      top
     /   \
   left right
     \   /
    bottom
```

The two directed paths from `bottom` to `top` are
`bottomLeft * leftTop` and `bottomRight * rightTop`.
-/
structure DiamondLabels (G : Type*) where
  bottomLeft : G
  leftTop : G
  bottomRight : G
  rightTop : G

/-- Vertex gauge parameters for the same finite diamond. -/
structure DiamondGauge (G : Type*) where
  bottom : G
  left : G
  right : G
  top : G

variable {G : Type*}

/-- Holonomy along the left branch of the diamond. -/
def leftHolonomy [Mul G] (U : DiamondLabels G) : G :=
  U.bottomLeft * U.leftTop

/-- Holonomy along the right branch of the diamond. -/
def rightHolonomy [Mul G] (U : DiamondLabels G) : G :=
  U.bottomRight * U.rightTop

/-- The Abelian path-comparison defect across the diamond. -/
def diamondDefect [Group G] (U : DiamondLabels G) : G :=
  (leftHolonomy U)⁻¹ * rightHolonomy U

/-- Vertex gauge transformation of edge transports. -/
def gaugeTransformDiamond [Group G] (g : DiamondGauge G) (U : DiamondLabels G) :
    DiamondLabels G where
  bottomLeft := g.bottom⁻¹ * U.bottomLeft * g.left
  leftTop := g.left⁻¹ * U.leftTop * g.top
  bottomRight := g.bottom⁻¹ * U.bottomRight * g.right
  rightTop := g.right⁻¹ * U.rightTop * g.top

/--
Finite Abelian causal-diamond curvature carrier: the path-comparison defect
is invariant under arbitrary vertex gauge transformations.
-/
theorem diamondDefect_gauge_invariant [CommGroup G]
    (g : DiamondGauge G) (U : DiamondLabels G) :
    diamondDefect (gaugeTransformDiamond g U) = diamondDefect U := by
  unfold gaugeTransformDiamond diamondDefect leftHolonomy rightHolonomy;
  simp +decide [ mul_assoc, mul_comm, mul_left_comm ];
  simp +decide [ mul_assoc, mul_comm g.bottom, mul_comm g.right, mul_comm g.top ];
  simp +decide [ mul_assoc, mul_comm g.bottom⁻¹ ]

/-! ## Target C: formal order-complex boundary squares to zero -/

/-- A formal simplex is represented by its ordered vertex list. -/
abbrev Simplex (V : Type*) := List V

/-- Integral chains on formal ordered simplices. -/
abbrev Chain (V : Type*) := Simplex V →₀ ℤ

/-- Delete the `i`-th vertex of a formal simplex. -/
def face {V : Type*} (s : Simplex V) (i : Nat) : Simplex V :=
  s.eraseIdx i

/-- Alternating boundary of one formal ordered simplex. -/
def simplexBoundary {V : Type*} (s : Simplex V) : Chain V :=
  ∑ i ∈ Finset.range s.length,
    Finsupp.single (face s i) ((-1 : ℤ) ^ i)

/-- Extend simplex boundary linearly to formal integral chains. -/
def chainBoundary {V : Type*} (c : Chain V) : Chain V :=
  c.sum fun s coeff => coeff • simplexBoundary s

/--
`chainBoundary` of a single generator.
-/
lemma chainBoundary_single {V : Type*} (s : Simplex V) (n : ℤ) :
    chainBoundary (Finsupp.single s n) = n • simplexBoundary s := by
  unfold chainBoundary simplexBoundary; aesop;

/--
`chainBoundary` sends `0` to `0`.
-/
lemma chainBoundary_zero {V : Type*} :
    chainBoundary (0 : Chain V) = 0 := by
  unfold chainBoundary;
  simp +decide [ Finsupp.sum ]

/--
`chainBoundary` is additive.
-/
lemma chainBoundary_add {V : Type*} (c d : Chain V) :
    chainBoundary (c + d) = chainBoundary c + chainBoundary d := by
  unfold chainBoundary;
  rw [ Finsupp.sum_add_index' ] <;> simp +decide [ add_smul ]

/--
`chainBoundary` commutes with finite sums.
-/
lemma chainBoundary_sum {V ι : Type*} (t : Finset ι) (f : ι → Chain V) :
    chainBoundary (∑ i ∈ t, f i) = ∑ i ∈ t, chainBoundary (f i) := by
  induction' t using Finset.induction with i t ih;
  convert chainBoundary_zero;
  grind +suggestions;
  exact Classical.decEq ι

/--
Face-of-face commutation identity (`eraseIdx` of `eraseIdx`).
-/
lemma face_face_comm {V : Type*} (s : Simplex V) {a b : ℕ} (h : a ≤ b) :
    face (face s a) b = face (face s (b + 1)) a := by
  induction' s with x xs ih generalizing a b;
  · rfl;
  · rcases a with ( _ | a ) <;> rcases b with ( _ | b ) <;> simp_all +decide [ face ]

/--
The alternating double sum over pairs of faces cancels to zero.
-/
lemma face_double_sum_eq_zero {V : Type*} (s : Simplex V) :
    (∑ i ∈ Finset.range s.length, ∑ j ∈ Finset.range (s.length - 1),
        Finsupp.single (face (face s i) j) ((-1 : ℤ) ^ (i + j))) = 0 := by
  -- The sum is over a product of ranges, so we can apply the sum_involution lemma.
  have h_sum_prod : ∑ p ∈ Finset.product (Finset.range s.length) (Finset.range (s.length - 1)), Finsupp.single (face (face s p.1) p.2) ((-1 : ℤ) ^ (p.1 + p.2)) = 0 := by
    apply Finset.sum_involution;
    case g => exact fun a ha => if a.2 < a.1 then ( a.2, a.1 - 1 ) else ( a.2 + 1, a.1 );
    · intro a ha; split_ifs <;> simp_all +decide [ pow_add, pow_one ] ;
      · ext; simp +decide [ * ] ; ring;
        by_cases h : face ( face s a.1 ) a.2 = ‹_› <;> by_cases h' : face ( face s a.2 ) ( a.1 - 1 ) = ‹_› <;> simp_all +decide ;
        · cases a_1 : a.1 <;> simp_all +decide [ pow_succ' ] ; ring;
        · exact h' ( by rw [ ← h, face_face_comm _ ( by omega ) ] ; simp +decide [ *, Nat.sub_add_cancel ( by omega : 1 ≤ a.1 ) ] );
        · convert face_face_comm s ( show a.2 ≤ a.1 - 1 from Nat.le_sub_one_of_lt ‹_› ) using 1;
          grind;
      · rw [ ← face_face_comm _ ( by linarith : a.1 ≤ a.2 ) ] ; ring;
        simp +decide [ mul_comm ];
    · grind;
    · grind;
    · simp +zetaDelta at *;
      grind;
  erw [ ← h_sum_prod, Finset.sum_product ]

/--
Order-complex/Kahler-Dirac seed theorem: the formal alternating boundary
squares to zero on every ordered simplex.
-/
theorem chainBoundary_simplexBoundary_eq_zero {V : Type*} (s : Simplex V) :
    chainBoundary (simplexBoundary s) = 0 := by
  -- By definition of `chainBoundary`, we can expand `chainBoundary (simplexBoundary s)`.
  have h_expand : chainBoundary (simplexBoundary s) = ∑ i ∈ Finset.range s.length, (-1 : ℤ) ^ i • simplexBoundary (face s i) := by
    convert chainBoundary_sum ( Finset.range s.length ) ( fun i => Finsupp.single ( face s i ) ( ( -1 : ℤ ) ^ i ) ) using 1;
    exact Finset.sum_congr rfl fun _ _ => by rw [ chainBoundary_single ] ;
  -- By definition of `simplexBoundary`, we can expand `simplexBoundary (face s i)`.
  have h_expand_face : ∀ i ∈ Finset.range s.length, simplexBoundary (face s i) = ∑ j ∈ Finset.range (s.length - 1), Finsupp.single (face (face s i) j) ((-1 : ℤ) ^ j) := by
    unfold simplexBoundary face;
    grind +suggestions;
  convert face_double_sum_eq_zero s using 1;
  rw [ h_expand, Finset.sum_congr rfl ] ; intros ; rw [ h_expand_face _ ‹_› ] ; simp +decide [ pow_add, Finset.smul_sum ] ;

/--
`chainBoundary` commutes with integer scalar multiplication.
-/
lemma chainBoundary_zsmul {V : Type*} (n : ℤ) (c : Chain V) :
    chainBoundary (n • c) = n • chainBoundary c := by
  ext s;
  simp +decide [ chainBoundary, Finsupp.smul_apply, Finsupp.sum_apply ];
  simp +decide [ Finsupp.sum, mul_assoc, Finset.mul_sum _ _ _ ];
  refine' Finset.sum_subset _ _ <;> intro x hx <;> aesop

/--
The boundary operator squares to zero on all formal integral chains.
-/
theorem chainBoundary_comp_self_eq_zero {V : Type*} (c : Chain V) :
    chainBoundary (chainBoundary c) = 0 := by
  convert chainBoundary_sum c.support ( fun s => c s • simplexBoundary s ) using 1;
  exact Eq.symm ( Finset.sum_eq_zero fun x hx => by rw [ chainBoundary_zsmul, chainBoundary_simplexBoundary_eq_zero, smul_zero ] )

/-! ## Target D: three-edge Pluecker mass -/

/-- The Hermitian momentum matrix of a three-edge visible bundle. -/
def threeEdgeMomentum (psi phi chi : CSpinor) : Matrix (Fin 2) (Fin 2) ℂ :=
  rankOneHermitian psi + rankOneHermitian phi + rankOneHermitian chi

/--
Three-edge Pluecker mass identity: determinant mass of a three-null-edge
bundle is the sum of the three pairwise squared spinor wedges.
-/
theorem three_edge_plucker_mass_identity (psi phi chi : CSpinor) :
    (threeEdgeMomentum psi phi chi).det =
      complexAbsSq (spinorWedge psi phi) +
      complexAbsSq (spinorWedge psi chi) +
      complexAbsSq (spinorWedge phi chi) := by
  simp [threeEdgeMomentum, rankOneHermitian, Matrix.det_fin_two, Matrix.vecMulVec,
    spinorWedge, complexAbsSq]
  ring

end PhysicsSM.Draft.NullEdgeCore

end

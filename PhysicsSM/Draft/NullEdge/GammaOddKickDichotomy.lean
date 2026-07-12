/-
Provenance: Aristotle job 634a64e1 (fable-24h-oddkick), harvested
2026-07-11 ~19:35 PDT. All five statements integrated UNCHANGED.
KERNEL-ONLY via a notable technique worth reusing: a computable
Gaussian-integer twin (G2g over ZZ[i]) with the ring-hom bridge
GaussianInt.toComplex lets 28x28 matrix identities discharge by plain
kernel `decide` on integer data, then transport to CC - no
native_decide anywhere despite complex entries.
Oracle: c4_oracle_out.txt + c4_orbit_out.txt (2026-07-11).
Program role: Route C / C4 dichotomy - the chirality-odd repair
demanded by the C3 audit is IMPOSSIBLE on the {(0,1),(2,3)} same-site
corner proven here (audit F9: the extension to all four same-site
pairs is now LANDED - Selection2Repairs.no_odd_generator_on_full_samesite_block) (the
derived kick's support) and exactly two-real-dimensional on each
component-mixing two-cycle block.
-/
import Mathlib

/-!
# Chirality-odd pair generators on the four-site ring: a support dichotomy

Route C (embrace-the-doublers) follow-up. The C3 chirality audit showed
the derived pair kick is chirality-EVEN for the exact symmetric-frame
grading, so the composed automaton exits the chiral class and vectorizes
the protected sector. The algebra demands a chirality-ODD generator
(`G H G = -H`, so the gate `K = exp(-iH)` obeys `G K G = Kdag`) in
palindromic placement. This file pins WHERE such generators can live.

Objects (all explicit; conventions = the momentum-companion job):
8 modes, mode = site*2 + component; the symmetric-frame chiral grading
is site-diagonal sigma_y, `G1[2s, 2s+1] = -i`, `G1[2s+1, 2s] = i`;
`G2` is its determinant-minor pair lift on the 28 pair states
(lexicographic pairs `(i,j)`, `i < j`).

## Oracle-decided facts (exact sympy, 2026-07-11; seed for the proofs)

* `G2` is a SIGNED PERMUTATION of the pair basis: every column has
  exactly one nonzero entry.
* The four same-site doubly-occupied states `(0,1), (2,3), (4,5), (6,7)`
  are fixed with eigenvalue `-1` (each inherits `det sigma_y = -1`).
* The remaining 24 states form 12 two-cycles, each swapping a pair state
  with its component-flip partner, with restriction
  `g = [[0, e],[e, 0]]`, `e = +-1` (examples: `(0,2) <-> (1,3)` with
  `e = -1`; `(0,3) <-> (1,2)` with `e = +1`).
* Gamma-odd generator spaces on invariant 2-blocks
  (`H` Hermitian 2x2 with `g H g^{-1} = -H`):
  - on a FIXED-pair block (e.g. span of `(0,1)` and `(2,3)`): `g = -1`
    is scalar, conjugation is trivial, so `H = 0` - the ONLY
    chirality-odd generator supported on same-site pair blocks is zero.
    In particular the proven corner of the derived kick's support cannot host the odd
    repair. (T1)
  - on any TWO-CYCLE block: the odd space is exactly two-real-
    dimensional, `H = [[a, i w],[ -i w, -a]]`, `a, w` real. (T2)

## Targets

T1 (the no-go, kernel): on the span of the two same-site pair states
`(0,1)` and `(2,3)`, every Hermitian `H` with `G2 H G2^{-1} = -H`
(equivalently `G2 H = -H G2` there) vanishes. State via the concrete
28x28 embedding: any 28x28 Hermitian `H` supported on indices
`{0, 13}` (the pair indices of `(0,1)` and `(2,3)`) satisfying
`G2 * H = -(H * G2)` is zero.

T2 (the existence, kernel): exhibit the explicit two-parameter family on
the `(0,2) <-> (1,3)` block - for all real `a w`, the 28x28 Hermitian
`H(a, w)` supported on the pair indices of `(0,2)` and `(1,3)` with
block `[[a, i w],[-i w, -a]]` satisfies `G2 * H(a,w) = -(H(a,w) * G2)`,
is Hermitian, and is nonzero when `(a, w) /= 0`.

T3 (the census, kernel or kernel+decide): `G2` is a signed permutation
with `-1`-fixed states at the same-site pairs (audit F10: what is
PROVEN here is the per-state disjunction below plus the two pinned
fixed points 0 and 13; the exact census and component-flip partner
identification are now LANDED in Selection2Repairs.G2_census_exact):
for every pair index `p`, either
`G2 *ᵥ (basis p) = -(basis p)` and `p` is same-site, or there is
`q /= p` with `G2 *ᵥ (basis p) = e • basis q`, `e = 1 ∨ e = -1`, and
`q` is the component-flip partner.

Statements must not be weakened. If any oracle fact fails, prove the
corrected fact, name it, and stop. Everything is finite Gaussian-
rational linear algebra; NO native_decide (kernel routes: `decide` on
integer/rational data, `simp`/`norm_num` entrywise, or `Finset` sums).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GammaOddKickDichotomy

open Matrix

abbrev M8 := Matrix (Fin 8) (Fin 8) ℂ
abbrev M28 := Matrix (Fin 28) (Fin 28) ℂ

/-- Site-diagonal sigma_y chiral grading (symmetric time frame). -/
def G1 : M8 := Matrix.of fun i j =>
  if i.1 / 2 = j.1 / 2 then
    (if i.1 % 2 = 0 ∧ j.1 % 2 = 1 then -Complex.I
     else if i.1 % 2 = 1 ∧ j.1 % 2 = 0 then Complex.I else 0)
  else 0

def pairFst : Fin 28 → Fin 8 :=
  ![0,0,0,0,0,0,0, 1,1,1,1,1,1, 2,2,2,2,2, 3,3,3,3, 4,4,4, 5,5, 6]
def pairSnd : Fin 28 → Fin 8 :=
  ![1,2,3,4,5,6,7, 2,3,4,5,6,7, 3,4,5,6,7, 4,5,6,7, 5,6,7, 6,7, 7]

/-- Determinant-minor pair lift. -/
def minorLift (A : M8) : M28 := Matrix.of fun r c =>
  A (pairFst r) (pairFst c) * A (pairSnd r) (pairSnd c)
    - A (pairFst r) (pairSnd c) * A (pairSnd r) (pairFst c)

def G2 : M28 := minorLift G1

/-!
## Gaussian-integer bridge

All entries of `G1` (hence of `G2`) are Gaussian integers, so we carry a
computable Gaussian-integer twin of every object and transport facts along
the ring homomorphism `phi : ℤ[i] →+* ℂ`.  This lets us discharge the
finite linear-algebra facts by kernel `decide` on `GaussianInt` data
(no `native_decide`).
-/

abbrev Z8 := Matrix (Fin 8) (Fin 8) GaussianInt
abbrev Z28 := Matrix (Fin 28) (Fin 28) GaussianInt

def G1g : Z8 := Matrix.of fun i j =>
  if i.1 / 2 = j.1 / 2 then
    (if i.1 % 2 = 0 ∧ j.1 % 2 = 1 then -⟨0,1⟩
     else if i.1 % 2 = 1 ∧ j.1 % 2 = 0 then (⟨0,1⟩ : GaussianInt) else 0)
  else 0

def minorLiftg (A : Z8) : Z28 := Matrix.of fun r c =>
  A (pairFst r) (pairFst c) * A (pairSnd r) (pairSnd c)
    - A (pairFst r) (pairSnd c) * A (pairSnd r) (pairFst c)

def G2g : Z28 := minorLiftg G1g

/-- The Gaussian-integer to complex ring homomorphism. -/
noncomputable def phi : GaussianInt →+* ℂ := GaussianInt.toComplex

lemma G1_eq : G1 = G1g.map phi := by
  ext i j
  simp only [G1, G1g, Matrix.map_apply, Matrix.of_apply]
  split_ifs <;> simp [phi, GaussianInt.toComplex_def]

lemma minorLift_map (A : Z8) : minorLift (A.map phi) = (minorLiftg A).map phi := by
  ext r c
  simp [minorLift, minorLiftg, Matrix.map_apply, map_sub, map_mul]

lemma G2_eq : G2 = G2g.map phi := by
  unfold G2 G2g; rw [G1_eq, minorLift_map]

lemma map_neg' (M : Z28) : (-M).map phi = -(M.map phi) := by
  ext i j; simp [Matrix.map_apply, Matrix.neg_apply, map_neg]

/-! ## Row/column structure of `G2` (T1 support). -/

lemma G2g_row0 : ∀ k : Fin 28, G2g 0 k = if k = 0 then -1 else 0 := by decide
lemma G2g_row13 : ∀ k : Fin 28, G2g 13 k = if k = 13 then -1 else 0 := by decide
lemma G2g_col0 : ∀ k : Fin 28, G2g k 0 = if k = 0 then -1 else 0 := by decide
lemma G2g_col13 : ∀ k : Fin 28, G2g k 13 = if k = 13 then -1 else 0 := by decide

lemma G2_row0 (k : Fin 28) : G2 0 k = if k = 0 then -1 else 0 := by
  rw [show G2 0 k = phi (G2g 0 k) from by rw [G2_eq]; rfl, G2g_row0 k]
  split_ifs <;> simp [phi]
lemma G2_row13 (k : Fin 28) : G2 13 k = if k = 13 then -1 else 0 := by
  rw [show G2 13 k = phi (G2g 13 k) from by rw [G2_eq]; rfl, G2g_row13 k]
  split_ifs <;> simp [phi]
lemma G2_col0 (k : Fin 28) : G2 k 0 = if k = 0 then -1 else 0 := by
  rw [show G2 k 0 = phi (G2g k 0) from by rw [G2_eq]; rfl, G2g_col0 k]
  split_ifs <;> simp [phi]
lemma G2_col13 (k : Fin 28) : G2 k 13 = if k = 13 then -1 else 0 := by
  rw [show G2 k 13 = phi (G2g k 13) from by rw [G2_eq]; rfl, G2g_col13 k]
  split_ifs <;> simp [phi]

lemma G2_rowD (i k : Fin 28) (hi : i = 0 ∨ i = 13) : G2 i k = if k = i then -1 else 0 := by
  rcases hi with rfl | rfl
  · simpa using G2_row0 k
  · simpa using G2_row13 k
lemma G2_colD (j k : Fin 28) (hj : j = 0 ∨ j = 13) : G2 k j = if k = j then -1 else 0 := by
  rcases hj with rfl | rfl
  · simpa using G2_col0 k
  · simpa using G2_col13 k

/-- T1: no chirality-odd generator lives on the same-site pair block.
`(0,1)` is pair index 0 and `(2,3)` is pair index 13. -/
theorem no_odd_generator_on_samesite_block (H : M28)
    (hsupp : ∀ r c, H r c ≠ 0 → (r = 0 ∨ r = 13) ∧ (c = 0 ∨ c = 13))
    (hodd : G2 * H = -(H * G2)) :
    H = 0 := by
  ext i j
  by_cases hij : (i = 0 ∨ i = 13) ∧ (j = 0 ∨ j = 13)
  · obtain ⟨hi, hj⟩ := hij
    have key := congrFun (congrFun hodd i) j
    rw [Matrix.mul_apply, Matrix.neg_apply, Matrix.mul_apply] at key
    have lhs : (∑ k, G2 i k * H k j) = -(H i j) := by
      rw [Finset.sum_eq_single i]
      · rw [G2_rowD i i hi]; simp
      · intro k _ hk; rw [G2_rowD i k hi]; simp [hk]
      · simp
    have rhs : (∑ k, H i k * G2 k j) = -(H i j) := by
      rw [Finset.sum_eq_single j]
      · rw [G2_colD j j hj]; simp
      · intro k _ hk; rw [G2_colD j k hj]; simp [hk]
      · simp
    rw [lhs, rhs] at key
    simp only [Matrix.zero_apply]
    linear_combination (-1/2 : ℂ) * key
  · simp only [Matrix.zero_apply]
    by_contra h
    exact hij (hsupp i j h)

/-- The explicit two-parameter odd family on the `(0,2) <-> (1,3)`
block: `(0,2)` is pair index 1 and `(1,3)` is pair index 8. -/
def oddH (a w : ℝ) : M28 := Matrix.of fun r c =>
  if r = 1 ∧ c = 1 then (a : ℂ)
  else if r = 8 ∧ c = 8 then (-a : ℂ)
  else if r = 1 ∧ c = 8 then Complex.I * (w : ℂ)
  else if r = 8 ∧ c = 1 then -(Complex.I * (w : ℂ))
  else 0

/-- Gaussian-integer generators of the odd block. -/
def Pg : Z28 := Matrix.of fun r c => if r = 1 ∧ c = 1 then 1 else if r = 8 ∧ c = 8 then -1 else 0
def Qg : Z28 := Matrix.of fun r c => if r = 1 ∧ c = 8 then (⟨0,1⟩ : GaussianInt) else if r = 8 ∧ c = 1 then -⟨0,1⟩ else 0

lemma oddH_decomp (a w : ℝ) : oddH a w = (a:ℂ) • (Pg.map phi) + (w:ℂ) • (Qg.map phi) := by
  ext r c
  simp only [oddH, Pg, Qg, Matrix.map_apply, Matrix.of_apply, Matrix.add_apply,
    Matrix.smul_apply, smul_eq_mul]
  split_ifs <;> simp_all [phi, GaussianInt.toComplex_def] <;> ring

set_option maxHeartbeats 4000000 in
set_option maxRecDepth 8000 in
lemma Pg_odd : G2g * Pg = -(Pg * G2g) := by decide

set_option maxHeartbeats 4000000 in
set_option maxRecDepth 8000 in
lemma Qg_odd : G2g * Qg = -(Qg * G2g) := by decide

lemma P_odd : G2 * (Pg.map phi) = -((Pg.map phi) * G2) := by
  rw [G2_eq, ← Matrix.map_mul, ← Matrix.map_mul, Pg_odd, map_neg']
lemma Q_odd : G2 * (Qg.map phi) = -((Qg.map phi) * G2) := by
  rw [G2_eq, ← Matrix.map_mul, ← Matrix.map_mul, Qg_odd, map_neg']

/-- T2a: the family is chirality-odd. -/
theorem oddH_odd (a w : ℝ) : G2 * oddH a w = -(oddH a w * G2) := by
  rw [oddH_decomp, Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul, Matrix.mul_smul,
    Matrix.smul_mul, Matrix.smul_mul, P_odd, Q_odd]
  simp only [smul_neg]
  abel

/-- T2b: the family is Hermitian. -/
theorem oddH_isHermitian (a w : ℝ) : (oddH a w).IsHermitian := by
  show (oddH a w)ᴴ = oddH a w
  ext i j
  simp only [Matrix.conjTranspose_apply, oddH, Matrix.of_apply]
  split_ifs <;>
    simp_all [Complex.conj_ofReal, Complex.conj_I, mul_comm]

/-- T2c: nonzero at nonzero parameters. -/
theorem oddH_ne_zero (a w : ℝ) (h : ¬(a = 0 ∧ w = 0)) : oddH a w ≠ 0 := by
  intro heq
  apply h
  have h11 := congrFun (congrFun heq 1) 1
  have h18 := congrFun (congrFun heq 1) 8
  simp [oddH] at h11 h18
  exact ⟨h11, h18⟩

/-! ## The signed-permutation census (T3). -/

lemma singleC (p : Fin 28) :
    (Pi.single p 1 : Fin 28 → ℂ) = fun i => phi ((Pi.single p 1 : Fin 28 → GaussianInt) i) := by
  funext i; simp only [Pi.single_apply]; split_ifs <;> simp [phi]

lemma mulVec_map (v : Fin 28 → GaussianInt) :
    (G2g.map phi) *ᵥ (fun i => phi (v i)) = fun i => phi ((G2g *ᵥ v) i) := by
  ext i; simp only [Matrix.mulVec, dotProduct, Matrix.map_apply, map_sum, map_mul]

lemma G2_mulVec_single (p : Fin 28) :
    G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = fun i => phi ((G2g *ᵥ (Pi.single p 1)) i) := by
  rw [G2_eq, singleC p, mulVec_map]

set_option maxHeartbeats 4000000 in
set_option maxRecDepth 8000 in
lemma census_g :
    ∀ p : Fin 28, (G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = -(Pi.single p 1))
        ∨ ∃ q : Fin 28, q ≠ p ∧
          ((G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = Pi.single q 1)
            ∨ (G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = -(Pi.single q 1))) := by
  decide

/-- T3: the grading's pair lift is a signed permutation: every basis
state is sent to plus-or-minus a basis state, with the four same-site
pairs fixed with sign `-1`. -/
theorem G2_signed_permutation :
    (∀ p : Fin 28, (G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = -(Pi.single p 1))
        ∨ ∃ q : Fin 28, q ≠ p ∧
          ((G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = Pi.single q 1)
            ∨ (G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = -(Pi.single q 1))))
      ∧ G2 *ᵥ (Pi.single 0 1 : Fin 28 → ℂ) = -(Pi.single 0 1)
      ∧ G2 *ᵥ (Pi.single 13 1 : Fin 28 → ℂ) = -(Pi.single 13 1) := by
  have transfer : ∀ (p q : Fin 28),
      (G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = Pi.single q 1) →
      (G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = Pi.single q 1) := by
    intro p q hpq
    rw [G2_mulVec_single p, hpq, ← singleC q]
  have transferNeg : ∀ (p q : Fin 28),
      (G2g *ᵥ (Pi.single p 1 : Fin 28 → GaussianInt) = -(Pi.single q 1)) →
      (G2 *ᵥ (Pi.single p 1 : Fin 28 → ℂ) = -(Pi.single q 1)) := by
    intro p q hpq
    rw [G2_mulVec_single p, hpq]
    have e : (fun i => phi ((-(Pi.single q 1 : Fin 28 → GaussianInt)) i))
         = -(fun i => phi ((Pi.single q 1 : Fin 28 → GaussianInt) i)) := by
      funext i; simp [map_neg]
    rw [e, ← singleC q]
  refine ⟨fun p => ?_, ?_, ?_⟩
  · rcases census_g p with h | ⟨q, hq, h | h⟩
    · exact Or.inl (transferNeg p p h)
    · exact Or.inr ⟨q, hq, Or.inl (transfer p q h)⟩
    · exact Or.inr ⟨q, hq, Or.inr (transferNeg p q h)⟩
  · exact transferNeg 0 0 (by decide)
  · exact transferNeg 13 13 (by decide)

end PhysicsSM.Draft.NullEdge.GammaOddKickDichotomy

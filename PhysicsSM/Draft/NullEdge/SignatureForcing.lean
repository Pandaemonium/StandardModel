import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The signature is forced, not chosen (Conjecture M, null-edge mass program)

A finite null-edge program takes *null soldering* `c(a)^2 = 0` with `c(a) ≠ 0` as
primitive.  In a real Clifford algebra `c(v)^2 = Q(v) • 1`.  A definite quadratic form
has **no** nonzero isotropic vector, so the mere existence of one null edge already
*forces* the soldering Gram to be indefinite.  This inverts the usual narrative: not
"spacetime is Lorentzian ⟹ null cones" but "null is primitive ⟹ any metric it generates
is indefinite."

This file delivers:

* **Rung 1 (`null_forces_indefinite`, fully proved).**  A real quadratic form with a
  nonzero isotropic vector is neither positive- nor negative-definite, together with the
  Clifford wrapper `clifford_null_forces_indefinite`.
* **Concrete witnesses (fully proved).**  Explicit null vectors for the standard
  `(1,3)` and `(2,2)` diagonal forms.  Both are indefinite — so indefiniteness *alone*
  does not single out Lorentzian, which is exactly what motivates a second selector
  (rung 2).
* **Celestial cross-check (fully proved).**  The clean topological heart of the
  celestial-sphere selector: the unit sphere `S^{p-1}` is connected for `p ≥ 2` but
  *disconnected* for `p = 1` (two points).
* **Rung 2 (`ReflectionPositivityProbe`, pre-registered probe).**  A precise finite
  reflection-positivity statement contrasting `(1,3)` and `(2,2)`, stated as a
  `Prop`-valued definition (the kill condition is its explicit negation).

All proved statements are kernel-checked with footprint
`[propext, Classical.choice, Quot.sound]`; see the `#print axioms` guard at the end.
-/

namespace NullEdge

open QuadraticMap

/-! ## Rung 1 — a null edge forces an indefinite metric -/

/-- **Rung 1, positive half.**  If a real quadratic form `Q` has a nonzero isotropic
(null) vector, it cannot be positive-definite: positive-definiteness would make `Q`
anisotropic, contradicting the null vector. -/
theorem null_forces_not_posDef {R V : Type*} [CommRing R] [PartialOrder R]
    [AddCommGroup V] [Module R V] (Q : QuadraticForm R V)
    {v : V} (hv : v ≠ 0) (hQv : Q v = 0) : ¬ Q.PosDef := by
  intro h
  exact hv (h.anisotropic v hQv)

/-- **Rung 1, negative half.**  Negative-definiteness of `Q` is positive-definiteness of
`-Q`.  A null vector of `Q` is also a null vector of `-Q`, so `Q` cannot be
negative-definite either. -/
theorem null_forces_not_negDef {R V : Type*} [CommRing R] [PartialOrder R]
    [AddCommGroup V] [Module R V] (Q : QuadraticForm R V)
    {v : V} (hv : v ≠ 0) (hQv : Q v = 0) : ¬ (-Q).PosDef := by
  intro h
  apply hv
  apply h.anisotropic v
  simp [hQv]

/-- A real quadratic form is **indefinite** here means: neither positive- nor
negative-definite. -/
def Indefinite {R V : Type*} [CommRing R] [PartialOrder R] [AddCommGroup V] [Module R V]
    (Q : QuadraticForm R V) : Prop :=
  ¬ Q.PosDef ∧ ¬ (-Q).PosDef

/-- **Rung 1 (main).**  A single nonzero isotropic vector forces the quadratic form to be
indefinite. -/
theorem null_forces_indefinite {R V : Type*} [CommRing R] [PartialOrder R]
    [AddCommGroup V] [Module R V] (Q : QuadraticForm R V)
    {v : V} (hv : v ≠ 0) (hQv : Q v = 0) : Indefinite Q :=
  ⟨null_forces_not_posDef Q hv hQv, null_forces_not_negDef Q hv hQv⟩

/-- Contrapositive, the "definite ⟹ no null edge" reading: a positive-definite quadratic
form is anisotropic, i.e. admits no nonzero null vector.  (This is Mathlib's
`QuadraticMap.PosDef.anisotropic`, restated in the null-edge language.) -/
theorem posDef_no_null {R V : Type*} [CommRing R] [PartialOrder R]
    [AddCommGroup V] [Module R V] {Q : QuadraticForm R V} (h : Q.PosDef)
    {v : V} (hv : v ≠ 0) : Q v ≠ 0 :=
  fun hQv => hv (h.anisotropic v hQv)

/-! ## Rung 1 — Clifford wrapper

In a real Clifford algebra the soldering map is `c = CliffordAlgebra.ι Q` and
`c(v)^2 = Q(v) • 1` (`CliffordAlgebra.ι_sq_scalar`).  A *null edge* is a `v` with
`c(v) ≠ 0` yet `c(v)^2 = 0`.  Because `algebraMap ℝ (CliffordAlgebra Q)` is injective,
`c(v)^2 = 0` forces `Q v = 0`, and `c(v) ≠ 0` forces `v ≠ 0`; rung 1 then applies. -/

/-- **Rung 1, Clifford form.**  A null edge in the Clifford algebra — a vector `v` whose
soldering `c(v) = ι Q v` is nonzero but squares to zero — forces the underlying quadratic
form to be indefinite. -/
theorem clifford_null_forces_indefinite {V : Type*} [AddCommGroup V] [Module ℝ V]
    (Q : QuadraticForm ℝ V) {v : V}
    (hne : (CliffordAlgebra.ι Q) v ≠ 0)
    (hsq : (CliffordAlgebra.ι Q) v * (CliffordAlgebra.ι Q) v = 0) :
    Indefinite Q := by
  have hQv : Q v = 0 := by
    have h1 : (algebraMap ℝ (CliffordAlgebra Q)) (Q v) = 0 := by
      rw [← CliffordAlgebra.ι_sq_scalar]; exact hsq
    exact FaithfulSMul.algebraMap_injective ℝ (CliffordAlgebra Q) (by simpa using h1)
  have hv : v ≠ 0 := by
    rintro rfl; exact hne (by simp)
  exact null_forces_indefinite Q hv hQv

/-! ## Concrete witnesses: `(1,3)` and `(2,2)` are both indefinite

Standard diagonal forms of signature `(1,3)` and `(2,2)` each carry an explicit null
edge, hence are indefinite by rung 1.  In particular indefiniteness by itself does **not**
distinguish Lorentzian from split signature — motivating the rung-2 selector below. -/

/-- Diagonal quadratic form of signature `(1,3)`: `x₀² - x₁² - x₂² - x₃²`. -/
noncomputable def Q13 : QuadraticForm ℝ (Fin 4 → ℝ) := weightedSumSquares ℝ ![1, -1, -1, -1]

/-- Diagonal quadratic form of signature `(2,2)`: `x₀² + x₁² - x₂² - x₃²`. -/
noncomputable def Q22 : QuadraticForm ℝ (Fin 4 → ℝ) := weightedSumSquares ℝ ![1, 1, -1, -1]

/-- `(1,0,0,0) + (0,1,0,0)` is a nonzero null vector for the `(1,3)` form. -/
theorem Q13_has_null : Q13 ![1, 1, 0, 0] = 0 := by
  simp [Q13, weightedSumSquares_apply, Fin.sum_univ_four]

theorem null_vec13_ne : (![1, 1, 0, 0] : Fin 4 → ℝ) ≠ 0 := by
  intro h; have := congrFun h 0; simp at this

/-- The signature-`(1,3)` form is indefinite. -/
theorem Q13_indefinite : Indefinite Q13 :=
  null_forces_indefinite Q13 null_vec13_ne Q13_has_null

/-- `(1,0,1,0)` is a nonzero null vector for the `(2,2)` form. -/
theorem Q22_has_null : Q22 ![1, 0, 1, 0] = 0 := by
  simp [Q22, weightedSumSquares_apply, Fin.sum_univ_four]

theorem null_vec22_ne : (![1, 0, 1, 0] : Fin 4 → ℝ) ≠ 0 := by
  intro h; have := congrFun h 0; simp at this

/-- The signature-`(2,2)` form is indefinite. -/
theorem Q22_indefinite : Indefinite Q22 :=
  null_forces_indefinite Q22 null_vec22_ne Q22_has_null

/-! ## Celestial cross-check: the sphere connectedness dichotomy

An independent selector converging on Lorentzian: the projective null quadric of
signature `(p,q)` is `(S^{p-1} × S^{q-1})/ℤ₂`, and it is a single *sphere* precisely when
one of the spherical factors degenerates, i.e. `p = 1` or `q = 1`.  The clean, fully
formal heart of this is the connectedness dichotomy of the factor `S^{p-1}`:

* for `p ≥ 2` the sphere `S^{p-1}` is connected (`celestial_sphere_connected`);
* for `p = 1` the "sphere" is the two-point set `{-1, 1}`, which is **disconnected**
  (`celestial_sphere_disconnected_dim_one`).

It is exactly this `p = 1` degeneration (one time direction) that collapses the celestial
quadric to a single sphere. -/

/-- For a real normed space of rank `> 1`, every sphere of nonnegative radius is
connected.  (Wrapper around `isConnected_sphere`.) -/
theorem celestial_sphere_connected {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (h : 1 < Module.rank ℝ E) (x : E) {r : ℝ} (hr : 0 ≤ r) :
    IsConnected (Metric.sphere x r) :=
  isConnected_sphere h x hr

/-- The `p = 1` degenerate case: the unit sphere in `ℝ` is the two-point set `{-1, 1}`. -/
theorem celestial_sphere_dim_one_eq : Metric.sphere (0 : ℝ) 1 = {-1, 1} := by
  ext x
  simp only [Metric.mem_sphere, Real.dist_eq, sub_zero, Set.mem_insert_iff,
    Set.mem_singleton_iff, abs_eq (by norm_num : (0 : ℝ) ≤ 1)]
  constructor
  · rintro (h | h) <;> [right; left] <;> linarith
  · rintro (h | h) <;> subst h <;> norm_num

/-- The `p = 1` "sphere" `{-1, 1} ⊆ ℝ` is not preconnected: an order-connected subset of
`ℝ` containing `-1` and `1` would have to contain `0`. -/
theorem celestial_sphere_disconnected_dim_one : ¬ IsPreconnected (Metric.sphere (0 : ℝ) 1) := by
  rw [celestial_sphere_dim_one_eq]
  intro h
  have hc := h.ordConnected
  have h0 : (0 : ℝ) ∈ ({-1, 1} : Set ℝ) :=
    hc.out (x := -1) (y := 1) (by simp) (by simp) (by constructor <;> norm_num)
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at h0
  rcases h0 with h0 | h0 <;> norm_num at h0

/-! ## Rung 2 — the "exactly one time" selector, pre-registered as a probe

The natural selector for one time (Lorentzian) rather than several is **reflection
positivity** (Osterwalder–Schrader).  We fix a precise finite formulation and register the
`(2,2)`-vs-`(1,3)` claim as a `Prop`-valued definition.  It is deliberately *not* proved
here: it is a pre-registered probe, and the KILL condition of the program — "a `(2,2)`
carrier passing OS positivity with a nondegenerate physical sector" — is exactly the
failure of the second conjunct of `ReflectionPositivityProbe`.

Finite RP datum: on the carrier `Fin n → ℝ` with metric `g`, a linear involution `θ`
(the Euclidean-time reflection) that is a `g`-isometry, together with a subset `S` of
coordinate axes spanning the "positive-time" sector.  Reflection positivity asks that the
reflected Gram matrix `RPGram D` — with entries `polar g (θ eᵢ) eⱼ` for `i, j ∈ S` — be
positive semidefinite; the physical sector is nondegenerate when that matrix is nonzero
(the physical Hilbert space, `S`-sector modulo the RP null space, is nonzero). -/

/-- A finite reflection-positivity datum for a metric `g` on `Fin n → ℝ`. -/
structure RPDatum (n : ℕ) (g : QuadraticForm ℝ (Fin n → ℝ)) where
  /-- The Euclidean-time reflection. -/
  θ : (Fin n → ℝ) →ₗ[ℝ] (Fin n → ℝ)
  /-- `θ` is an involution. -/
  invol : θ.comp θ = LinearMap.id
  /-- `θ` is an isometry of `g`. -/
  isom : ∀ x, g (θ x) = g x
  /-- The coordinate axes spanning the positive-time sector. -/
  S : Finset (Fin n)

/-- The reflected Gram matrix of an RP datum: `RPGram D i j = polar g (θ eᵢ) eⱼ`. -/
noncomputable def RPGram {n : ℕ} {g : QuadraticForm ℝ (Fin n → ℝ)} (D : RPDatum n g) :
    Matrix D.S D.S ℝ :=
  Matrix.of fun i j => QuadraticMap.polar (⇑g) (D.θ (Pi.single i.1 1)) (Pi.single j.1 1)

/-- Reflection positivity of a datum: the reflected Gram matrix is positive semidefinite. -/
def IsReflectionPositive {n : ℕ} {g : QuadraticForm ℝ (Fin n → ℝ)} (D : RPDatum n g) : Prop :=
  (RPGram D).PosSemidef

/-- The physical sector is nondegenerate when the reflected Gram matrix is nonzero
(the physical Hilbert space is nontrivial). -/
def HasNondegeneratePhysicalSector {n : ℕ} {g : QuadraticForm ℝ (Fin n → ℝ)}
    (D : RPDatum n g) : Prop :=
  RPGram D ≠ 0

/-- **Rung 2 — pre-registered probe.**  The Lorentzian `(1,3)` carrier admits a reflection
positive datum with a nondegenerate physical sector, while every reflection positive datum
for the split `(2,2)` carrier has a degenerate physical sector.  The KILL condition of the
program is the negation of the second conjunct: a `(2,2)` RP datum with a nondegenerate
physical sector. -/
def ReflectionPositivityProbe : Prop :=
  (∃ D : RPDatum 4 Q13, IsReflectionPositive D ∧ HasNondegeneratePhysicalSector D) ∧
  (∀ D : RPDatum 4 Q22, IsReflectionPositive D → ¬ HasNondegeneratePhysicalSector D)

/-- The explicit KILL statement: existence of a `(2,2)` RP datum with a nondegenerate
physical sector.  Proving this would refute the rung-2 selector. -/
def ReflectionPositivityKill : Prop :=
  ∃ D : RPDatum 4 Q22, IsReflectionPositive D ∧ HasNondegeneratePhysicalSector D

end NullEdge

/-! ## Axiom-footprint guard

All proved statements depend only on `[propext, Classical.choice, Quot.sound]`. -/

#print axioms NullEdge.null_forces_indefinite
#print axioms NullEdge.clifford_null_forces_indefinite
#print axioms NullEdge.posDef_no_null
#print axioms NullEdge.Q13_indefinite
#print axioms NullEdge.Q22_indefinite
#print axioms NullEdge.celestial_sphere_connected
#print axioms NullEdge.celestial_sphere_disconnected_dim_one

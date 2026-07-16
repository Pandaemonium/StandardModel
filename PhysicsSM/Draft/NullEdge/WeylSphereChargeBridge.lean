import Mathlib

/-!
# Weyl determinant-sign → enclosing-sphere degree / Chern bridge

This file builds the smallest honest theorem ladder connecting the *local*
Jacobian determinant sign of a two-band Pauli crossing `h(q) = (A q)·σ` to the
*topological* charge (degree / first Chern number) on an enclosing 2-sphere.

See `AUDIT.md` for the full Mathlib/PhysLean API audit. The one-line summary:
this Mathlib (`v4.28.0`) has **no** topological/Brouwer degree of sphere maps,
**no** `πₙ(Sⁿ) ≅ ℤ` / `Hₙ(Sⁿ)` computation, **no** `GL⁺` path-connectivity, and
**no** Chern/Berry/characteristic-class API; PhysLean is not a dependency.
Therefore the topological *endpoints* cannot even be defined here.

What is delivered:

* §1–§3  A proof-complete finite/linear layer: the Pauli↔sphere link
  (`pauliDot_sq`, `weylHam_eq_norm_smul`), the Bloch map as a self-map of the
  unit sphere with **functoriality** (`blochVec_comp`, `blochVec_bloch`), and the
  determinant-sign chirality with **canonical identity and reflection witnesses**
  (`chirality_one`, `chirality_reflect`, `blochVec_one`) and multiplicativity
  (`chirality_mul`).

* §4  The **degree bridge** as an abstract, proof-complete *reduction*
  (`deg_eq_chirality`): from the standard degree axioms — presented as named
  hypotheses that stand in for the missing API — the degree of the Bloch map
  equals `sign(det A)`. The hypotheses `deg_pos_det`/`deg_neg_det` are exactly
  the missing `GL⁺(3,ℝ)`-connectivity + homotopy-invariance input; the existence
  of `deg` is the missing Brouwer-degree API.

* §5  The **Chern bridge** kept *separate* (`chern_eq_chirality`), linked to the
  degree only by the explicit named hypothesis `chern_eq_deg` (the missing
  first-Chern-number = Bloch-degree physics), never by prose.

* Non-vacuity guard (`chirality_isDegreeModel`): `chirality = sign ∘ det`
  itself satisfies the abstract degree axioms, so §4 is not vacuous.

No new assumptions or compiled-evaluator shortcuts. Missing-API handoffs appear only as the named
hypotheses above and are documented at their use sites.

Provenance: clean-room finite algebra informed by the HNU single-Weyl
reconstruction (arXiv:1806.06868). The degree and Chern endpoints are not
available in the pinned Mathlib and are not claimed as proved here.
-/

open scoped BigOperators
open Matrix

namespace PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge

/-- Real momentum 3-vectors. -/
abbrev V3 := Fin 3 → ℝ
/-- Real `3×3` "vielbein"/Jacobian matrices `A`. -/
abbrev M3 := Matrix (Fin 3) (Fin 3) ℝ
/-- Complex `2×2` matrices (the two-band Pauli algebra). -/
abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ

/-! ## §0  Euclidean norm and normalization on `V3` -/

/-- Squared Euclidean norm `∑ vᵢ²`. -/
noncomputable def nrmSq (v : V3) : ℝ := ∑ i, (v i) ^ 2

/-- Euclidean norm `√(∑ vᵢ²)`. -/
noncomputable def nrm (v : V3) : ℝ := Real.sqrt (nrmSq v)

/-- Radial normalization `v ↦ v/‖v‖` (the map onto the unit sphere for `v ≠ 0`). -/
noncomputable def normalize (v : V3) : V3 := (nrm v)⁻¹ • v

/-- The unit-sphere predicate. -/
def OnSphere (v : V3) : Prop := nrm v = 1

lemma nrmSq_nonneg (v : V3) : 0 ≤ nrmSq v := Finset.sum_nonneg (fun _ _ => sq_nonneg _)

lemma nrmSq_eq_zero {v : V3} : nrmSq v = 0 ↔ v = 0 := by
  unfold nrmSq
  rw [Finset.sum_eq_zero_iff_of_nonneg (fun _ _ => sq_nonneg _)]
  simp [funext_iff]

lemma nrm_nonneg (v : V3) : 0 ≤ nrm v := Real.sqrt_nonneg _

lemma nrm_eq_zero {v : V3} : nrm v = 0 ↔ v = 0 := by
  unfold nrm; rw [Real.sqrt_eq_zero (nrmSq_nonneg v)]; exact nrmSq_eq_zero

lemma nrm_pos {v : V3} (hv : v ≠ 0) : 0 < nrm v :=
  lt_of_le_of_ne (nrm_nonneg v) (fun h => hv (nrm_eq_zero.mp h.symm))

lemma nrm_smul (t : ℝ) (v : V3) : nrm (t • v) = |t| * nrm v := by
  unfold nrm nrmSq
  have h : ∑ i, ((t • v) i) ^ 2 = t ^ 2 * ∑ i, (v i) ^ 2 := by
    simp [Pi.smul_apply, smul_eq_mul, mul_pow, Finset.mul_sum]
  rw [h, Real.sqrt_mul (sq_nonneg t), Real.sqrt_sq_eq_abs]

/-- Normalization lands on the unit sphere, for nonzero vectors. -/
lemma normalize_onSphere {v : V3} (hv : v ≠ 0) : OnSphere (normalize v) := by
  unfold OnSphere normalize
  rw [nrm_smul, abs_of_nonneg (inv_nonneg.2 (nrm_nonneg v)),
    inv_mul_cancel₀ (nrm_eq_zero.not.mpr hv)]

/-- Normalization is invariant under positive rescaling. -/
lemma normalize_smul_pos {t : ℝ} (ht : 0 < t) (v : V3) :
    normalize (t • v) = normalize v := by
  unfold normalize
  rw [nrm_smul, abs_of_pos ht, smul_smul, mul_inv, mul_right_comm,
    inv_mul_cancel₀ ht.ne', one_mul]

/-- Normalization fixes vectors already on the sphere. -/
lemma normalize_of_onSphere {v : V3} (hv : OnSphere v) : normalize v = v := by
  unfold normalize; rw [hv]; simp

/-! ## §1  Pauli algebra and the Weyl Hamiltonian `h(q) = (A q)·σ` -/

/-- Pauli `σ₁`. -/
def sigma1 : M2 := !![0, 1; 1, 0]
/-- Pauli `σ₂`. -/
def sigma2 : M2 := !![0, -Complex.I; Complex.I, 0]
/-- Pauli `σ₃`. -/
def sigma3 : M2 := !![1, 0; 0, -1]

/-- The Pauli contraction `v·σ = v₀σ₁ + v₁σ₂ + v₂σ₃` for a real 3-vector `v`. -/
noncomputable def pauliDot (v : V3) : M2 :=
  (v 0 : ℂ) • sigma1 + (v 1 : ℂ) • sigma2 + (v 2 : ℂ) • sigma3

/-- The two-band Weyl/Pauli Hamiltonian `h(q) = (A q)·σ`. -/
noncomputable def weylHam (A : M3) (q : V3) : M2 := pauliDot (A.mulVec q)

/-- **Pauli identity** `(v·σ)² = ‖v‖² • I`. This is the algebraic fact that makes
`v·σ` a Clifford/Weyl symbol: its square is the scalar `‖v‖²`. -/
lemma pauliDot_sq (v : V3) :
    pauliDot v * pauliDot v = ((nrmSq v : ℝ) : ℂ) • (1 : M2) := by
  unfold pauliDot sigma1 sigma2 sigma3 nrmSq
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.smul_apply, Fin.sum_univ_three,
      Complex.ext_iff, Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, pow_two] <;>
    first
      | (constructor <;> ring)
      | ring

/-- `v ↦ v·σ` is real-linear: `(t v)·σ = t (v·σ)`. -/
lemma pauliDot_smul (t : ℝ) (v : V3) : pauliDot (t • v) = (t : ℂ) • pauliDot v := by
  unfold pauliDot
  simp only [Pi.smul_apply, smul_eq_mul, Complex.ofReal_mul, smul_add, smul_smul]

/-- Squared Weyl Hamiltonian: `h(q)² = ‖A q‖² • I`. Eigenvalues are `±‖A q‖`. -/
lemma weylHam_sq (A : M3) (q : V3) :
    weylHam A q * weylHam A q = ((nrmSq (A.mulVec q) : ℝ) : ℂ) • (1 : M2) := by
  unfold weylHam; exact pauliDot_sq _

/-! ## §2  The normalized Bloch map `n : q ↦ (A q)/‖A q‖` as a sphere self-map -/

/-- The normalized Bloch map of the crossing `h(q) = (A q)·σ`: the sphere object
attached to the Pauli Hamiltonian. -/
noncomputable def blochVec (A : M3) (q : V3) : V3 := normalize (A.mulVec q)

/-- **Pauli Hamiltonian → sphere object**, made explicit: away from the crossing,
`h(q) = ‖A q‖ • ( n(q)·σ )` with `n(q) = blochVec A q ∈ S²`. This is the map from
the Hamiltonian to the sphere object referenced by the bridge theorems. -/
lemma weylHam_eq_norm_smul (A : M3) (q : V3) :
    weylHam A q = ((nrm (A.mulVec q) : ℝ) : ℂ) • pauliDot (blochVec A q) := by
  unfold weylHam blochVec normalize
  rw [pauliDot_smul, smul_smul, ← Complex.ofReal_mul]
  by_cases h : A.mulVec q = 0
  · simp [h, pauliDot]
  · rw [mul_inv_cancel₀ (nrm_pos h).ne', Complex.ofReal_one, one_smul]

/-- The Bloch map lands on the unit sphere away from the crossing. -/
lemma blochVec_onSphere {A : M3} {q : V3} (h : A.mulVec q ≠ 0) :
    OnSphere (blochVec A q) :=
  normalize_onSphere h

/-- The Bloch map is invariant under positive radial rescaling of `q` (it is a
genuine function of the ray, i.e. of a point of the sphere). -/
lemma blochVec_smul_pos {t : ℝ} (ht : 0 < t) (A : M3) (q : V3) :
    blochVec A (t • q) = blochVec A q := by
  unfold blochVec; rw [Matrix.mulVec_smul, normalize_smul_pos ht]

/-- **Functoriality of the Bloch construction** at the linear-algebra level:
`n_{AB} = n_A ∘ (B ·)`. Normalization kills the positive scalar introduced by
`B`, so `blochVec (A*B) q = blochVec A (B q)`. -/
lemma blochVec_comp (A B : M3) (q : V3) :
    blochVec (A * B) q = blochVec A (B.mulVec q) := by
  unfold blochVec; rw [Matrix.mulVec_mulVec]

/-- **Functoriality as composition of sphere self-maps**: applying `n_A` to the
sphere point `n_B q` gives `n_{AB} q` (for `B q ≠ 0`). This is the honest
`deg(f∘g)=deg f·deg g` substrate. -/
lemma blochVec_bloch {A B : M3} {q : V3} (h : B.mulVec q ≠ 0) :
    blochVec A (blochVec B q) = blochVec (A * B) q := by
  have hc : 0 < (nrm (B.mulVec q))⁻¹ := inv_pos.2 (nrm_pos h)
  have hbq : blochVec B q = (nrm (B.mulVec q))⁻¹ • B.mulVec q := rfl
  rw [hbq, blochVec_smul_pos hc, ← blochVec_comp]

/-! ## §3  Determinant-sign chirality, with identity/reflection witnesses -/

/-- The local Jacobian-sign chirality `χ(A) = sign(det A) ∈ {-1,0,1}`. This is a
total function of the supplied matrix; it is **not** a degree or a Chern number
(that identification is the content of §4–§5). -/
noncomputable def chirality (A : M3) : ℤ :=
  if 0 < A.det then 1 else if A.det < 0 then -1 else 0

/-- Canonical **identity witness**: `χ(I) = +1`. -/
lemma chirality_one : chirality (1 : M3) = 1 := by
  unfold chirality; rw [Matrix.det_one]; norm_num

/-- The canonical single-axis **reflection**. -/
noncomputable def reflect : M3 := Matrix.diagonal ![(-1 : ℝ), 1, 1]

lemma reflect_det : (reflect).det = -1 := by
  unfold reflect; rw [Matrix.det_diagonal]; simp [Fin.prod_univ_three]

/-- Canonical **reflection witness**: `χ(reflection) = -1`. -/
lemma chirality_reflect : chirality reflect = -1 := by
  unfold chirality; rw [reflect_det]; norm_num

/-- **Identity Bloch map**: `n_I` is the identity on the unit sphere. -/
lemma blochVec_one {q : V3} (hq : OnSphere q) : blochVec (1 : M3) q = q := by
  unfold blochVec; rw [Matrix.one_mulVec]; exact normalize_of_onSphere hq

/-- Chirality is `≠ 0` exactly on invertible (non-degenerate) crossings. -/
lemma chirality_ne_zero_iff (A : M3) : chirality A ≠ 0 ↔ A.det ≠ 0 := by
  unfold chirality
  rcases lt_trichotomy A.det 0 with h | h | h
  · rw [if_neg (not_lt.2 h.le), if_pos h]; simp [h.ne]
  · rw [if_neg (by simp [h]), if_neg (by simp [h])]; simp [h]
  · rw [if_pos h]; simp [h.ne']

/-- **Multiplicativity** `χ(A·B) = χ(A)·χ(B)` (from `det_mul` and sign of a
product). This is the algebraic shadow of degree multiplicativity under
`blochVec_comp`. -/
lemma chirality_mul (A B : M3) : chirality (A * B) = chirality A * chirality B := by
  unfold chirality
  rw [Matrix.det_mul]
  rcases lt_trichotomy A.det 0 with hA | hA | hA <;>
  rcases lt_trichotomy B.det 0 with hB | hB | hB <;>
  simp_all [mul_pos_iff, mul_neg_iff, not_lt.2, le_of_lt]

/-! ## §4  The degree bridge (abstract reduction; honest missing-API handoff)

We do **not** have a Brouwer degree in this Mathlib (see `AUDIT.md`). So the
bridge is stated as a reduction from the standard degree axioms, presented as
named hypotheses on an abstract `deg : M3 → ℤ` (read: the degree of the Bloch
self-map `blochVec A` on the enclosing sphere).

The two homotopy-invariance hypotheses are the exact missing input:

* `deg_pos_det` ⇐ `GL⁺(3,ℝ)` is path-connected, so `blochVec A ≃ₕ id` when
  `det A > 0`, plus homotopy invariance of degree;
* `deg_neg_det` ⇐ the `det < 0` component is path-connected to the reflection.

The existence of any such `deg` is the missing Brouwer-degree-of-`S²` API.
-/

/-- **Degree bridge.** Under the standard degree axioms (named hypotheses
standing in for the missing API), the degree of the enclosing-sphere Bloch map
equals the determinant-sign chirality. -/
theorem deg_eq_chirality
    (deg : M3 → ℤ)
    (deg_id : deg 1 = 1)
    (deg_reflect : deg reflect = -1)
    -- MISSING API (GL⁺ connectivity + homotopy invariance of degree):
    (deg_pos_det : ∀ A : M3, 0 < A.det → deg A = deg 1)
    -- MISSING API (det<0 component connected to the reflection):
    (deg_neg_det : ∀ A : M3, A.det < 0 → deg A = deg reflect)
    (A : M3) (hA : A.det ≠ 0) :
    deg A = chirality A := by
  unfold chirality
  rcases lt_trichotomy A.det 0 with h | h | h
  · rw [if_neg (not_lt.2 h.le), if_pos h, deg_neg_det A h, deg_reflect]
  · exact absurd h hA
  · rw [if_pos h, deg_pos_det A h, deg_id]

/-- **Non-vacuity guard.** `chirality = sign ∘ det` itself satisfies every
abstract degree axiom used in `deg_eq_chirality`, so the reduction is
satisfiable and pins the unique invariant (it is not vacuously true). -/
theorem chirality_isDegreeModel :
    chirality 1 = 1 ∧ chirality reflect = -1 ∧
    (∀ A : M3, 0 < A.det → chirality A = chirality 1) ∧
    (∀ A : M3, A.det < 0 → chirality A = chirality reflect) := by
  refine ⟨chirality_one, chirality_reflect, ?_, ?_⟩
  · intro A h; rw [chirality_one]; unfold chirality; rw [if_pos h]
  · intro A h; rw [chirality_reflect]; unfold chirality;
    rw [if_neg (not_lt.2 h.le), if_pos h]

/-! ## §5  The Chern bridge (kept SEPARATE from the degree bridge)

The first Chern number of the negative-energy Berry eigenline bundle over the
enclosing sphere is a *distinct* object from the Bloch degree. Neither Chern
classes nor Berry curvature exist in this Mathlib. We keep the two invariants
separate and connect them **only** by the explicit named hypothesis
`chern_eq_deg` — never by prose — which is the missing physics theorem
(first Chern number = Bloch degree, i.e. Berry-curvature integration).
-/

/-- **Chern bridge.** Given the degree axioms *and* the separate first-Chern =
degree identity (`chern_eq_deg`, the missing Berry-curvature-integration
theorem), the first Chern number of the Berry eigenline bundle equals the
determinant-sign chirality. The degree and Chern invariants are linked only
through the explicit hypothesis, not by identification. -/
theorem chern_eq_chirality
    (deg chern : M3 → ℤ)
    (deg_id : deg 1 = 1)
    (deg_reflect : deg reflect = -1)
    (deg_pos_det : ∀ A : M3, 0 < A.det → deg A = deg 1)
    (deg_neg_det : ∀ A : M3, A.det < 0 → deg A = deg reflect)
    -- MISSING PHYSICS API (first Chern number of Berry eigenline bundle = Bloch degree):
    (chern_eq_deg : ∀ A : M3, A.det ≠ 0 → chern A = deg A)
    (A : M3) (hA : A.det ≠ 0) :
    chern A = chirality A := by
  rw [chern_eq_deg A hA]
  exact deg_eq_chirality deg deg_id deg_reflect deg_pos_det deg_neg_det A hA

/-! ### Build-enforced guards for the unconditional finite-algebra layer -/

/-- info: 'PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge.pauliDot_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pauliDot_sq

/-- info: 'PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge.chirality_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chirality_mul

end PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge

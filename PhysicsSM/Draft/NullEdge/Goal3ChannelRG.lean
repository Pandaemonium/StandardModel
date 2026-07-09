import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
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
# Goal III / Suite B — S4a kill-test: a RELEVANT direction outside the channels?

Self-contained rational linear algebra (Mathlib only).

## The model

A two-coupling null-edge chain (aperture `lam`, closure `kap`) has the exact rational
decimation `R2(lam,kap) = (lam - 2 kap²/lam, -kap²/lam)`.  It arises from a two-site Schur
complement of a tridiagonal scalar chain with on-site mass `lam` and nearest-neighbour
coupling `kap`, each surviving site losing two neighbours (hence the factor `2`).

We add a **third coupling `tau` (turn)** as an off-diagonal *chiral* term, promoting each
site to a 2-component (chiral) object.  Concretely take the on-site block `A = lam • I`
and the nearest-neighbour block `B = kap • I + tau • J`, where `J = !![0,1;-1,0]` is the
chiral generator (`J² = -I`).  The two-site Schur complement (eliminating the middle 2×2
block, both neighbours contributing) gives the effective on-site and coupling blocks

* on-site:  `lam • I - 2 (B Bᵀ)/lam = (lam - 2(kap²+tau²)/lam) • I`   (stays scalar),
* coupling: `-(1/lam) B² = -(1/lam)[(kap²-tau²) I + 2 kap tau J]`,

so the closed 3-coupling decimation is

```
R3(lam,kap,tau) = ( lam - 2(kap²+tau²)/lam ,  -(kap²-tau²)/lam ,  -2 kap tau / lam ).
```

Equivalently, writing the complex closure/turn coupling `z = kap + i tau`, one has
`z' = -z²/lam` — the free-Dirac chiral square, with the aperture flowing as
`lam' = lam - 2|z|²/lam`.

## The results (all kernel-checked over ℚ / ℝ, no `Complex`, no transcendentals)

1. `R3_closed_form` — `R3(lam,kap,0) = (R2(lam,kap), 0)`; the turn-free subspace is invariant.
2. `critical_fixed_data` — at the critical point `(lam,kap,tau) = (1,1,0)` (on the invariant
   critical line `|kap| = |lam|`, whose R2 relevant eigenvalue is `2`) the `3×3` Jacobian is
   `DR3 = !![3,-4,0; 1,-2,0; 0,0,-2]`, each entry proved as the corresponding partial
   derivative (`HasDerivAt`, over ℝ).
3. `rg_eigenvalues` — the characteristic polynomial of `DR3` is
   `x³ + x² - 4x - 4 = (x-2)(x+1)(x+2)`, so the eigenvalues are exactly `2, -1, -2`.
4. `kill_test` — the verdict.  Eigenvalue `2` (relevant) has eigenvector in the
   aperture–closure plane; eigenvalue `-1` (marginal) likewise; and eigenvalue `-2`
   (RELEVANT, `|-2| > 1`) has eigenvector the **pure turn axis** `(0,0,1)`.

   **Verdict:** turn is a *new relevant direction* (eigenvalue `-2`).  It lies inside the
   named channel basis (it *is* the turn coupling), so this is **not a kill** of
   basin-membership, but a sharpened result: on this model the turn coupling is relevant,
   not irrelevant/marginal.
-/

namespace Goal3ChannelRG

/-- Two-coupling decimation (aperture `lam`, closure `kap`). -/
def R2 {K : Type*} [Field K] (lam kap : K) : K × K :=
  (lam - 2 * kap ^ 2 / lam, -kap ^ 2 / lam)

/-- Three-coupling decimation (aperture `lam`, closure `kap`, turn `tau`), obtained from the
two-site Schur complement of the chiral 2×2-block chain. -/
def R3 {K : Type*} [Field K] (lam kap tau : K) : K × K × K :=
  (lam - 2 * (kap ^ 2 + tau ^ 2) / lam, -(kap ^ 2 - tau ^ 2) / lam, -2 * kap * tau / lam)

/-! ## Target 1 — closed form and turn-free invariance -/

/-- **`R3_closed_form`.** On `tau = 0` the three-coupling flow reduces to the two-coupling
flow, and the turn coordinate stays `0`: the turn-free subspace is invariant. -/
theorem R3_closed_form (lam kap : ℚ) :
    R3 lam kap 0 = ((R2 lam kap).1, (R2 lam kap).2, 0) := by
  simp [R3, R2]

/-! ## Target 2 — the critical point and the Jacobian `DR3`

The critical point is `(lam, kap, tau) = (1, 1, 0)`, which lies on the invariant critical
line `|kap| = |lam|` of `R2` (there `R2`'s relevant eigenvalue is `2`).  We compute the
`3×3` Jacobian of `R3` there, each entry as the corresponding partial derivative.  The
slices are:

* column 0 (∂/∂lam):  `fun l => R3 l 1 0`   at `l = 1`,
* column 1 (∂/∂kap):  `fun k => R3 1 k 0`   at `k = 1`,
* column 2 (∂/∂tau):  `fun t => R3 1 1 t`   at `t = 0`.
-/

/-- The Jacobian `DR3` of `R3` at the critical point `(1,1,0)`, as an exact rational matrix. -/
def DR3 : Matrix (Fin 3) (Fin 3) ℚ := !![3, -4, 0; 1, -2, 0; 0, 0, -2]

-- Column 0 : partial derivatives with respect to the aperture `lam`.
private lemma partial_lam_1 : HasDerivAt (fun l : ℝ => (R3 l 1 0).1) 3 1 := by
  have h1 : (1 : ℝ) ≠ 0 := one_ne_zero
  show HasDerivAt (fun l : ℝ => l - 2 * ((1 : ℝ) ^ 2 + (0 : ℝ) ^ 2) / l) 3 1
  have := (hasDerivAt_id (1 : ℝ)).sub
    (((hasDerivAt_const (1 : ℝ) (2 * ((1 : ℝ) ^ 2 + (0 : ℝ) ^ 2))).div (hasDerivAt_id (1 : ℝ)) h1))
  convert this using 1; norm_num [id]

private lemma partial_lam_2 : HasDerivAt (fun l : ℝ => (R3 l 1 0).2.1) 1 1 := by
  have h1 : (1 : ℝ) ≠ 0 := one_ne_zero
  show HasDerivAt (fun l : ℝ => -((1 : ℝ) ^ 2 - (0 : ℝ) ^ 2) / l) 1 1
  have := ((hasDerivAt_const (1 : ℝ) (-((1 : ℝ) ^ 2 - (0 : ℝ) ^ 2))).div (hasDerivAt_id (1 : ℝ)) h1)
  convert this using 1; norm_num [id]

private lemma partial_lam_3 : HasDerivAt (fun l : ℝ => (R3 l 1 0).2.2) 0 1 := by
  have h1 : (1 : ℝ) ≠ 0 := one_ne_zero
  show HasDerivAt (fun l : ℝ => -2 * (1 : ℝ) * 0 / l) 0 1
  have := ((hasDerivAt_const (1 : ℝ) (-2 * (1 : ℝ) * 0)).div (hasDerivAt_id (1 : ℝ)) h1)
  convert this using 1; norm_num [id]

-- Column 1 : partial derivatives with respect to the closure `kap`.
private lemma partial_kap_1 : HasDerivAt (fun k : ℝ => (R3 1 k 0).1) (-4) 1 := by
  show HasDerivAt (fun k : ℝ => (1 : ℝ) - 2 * (k ^ 2 + (0 : ℝ) ^ 2) / 1) (-4) 1
  have hk : HasDerivAt (fun k : ℝ => k ^ 2) ((2 : ℕ) * 1 ^ (2 - 1)) 1 := hasDerivAt_pow 2 1
  have := (hasDerivAt_const (1 : ℝ) (1 : ℝ)).sub
    (((hk.add_const ((0 : ℝ) ^ 2)).const_mul (2 : ℝ)).div_const (1 : ℝ))
  convert this using 1; push_cast; ring

private lemma partial_kap_2 : HasDerivAt (fun k : ℝ => (R3 1 k 0).2.1) (-2) 1 := by
  show HasDerivAt (fun k : ℝ => -(k ^ 2 - (0 : ℝ) ^ 2) / 1) (-2) 1
  have hk : HasDerivAt (fun k : ℝ => k ^ 2) ((2 : ℕ) * 1 ^ (2 - 1)) 1 := hasDerivAt_pow 2 1
  have := ((hk.sub_const ((0 : ℝ) ^ 2)).neg).div_const (1 : ℝ)
  convert this using 1; push_cast; ring

private lemma partial_kap_3 : HasDerivAt (fun k : ℝ => (R3 1 k 0).2.2) 0 1 := by
  show HasDerivAt (fun k : ℝ => -2 * k * 0 / 1) 0 1
  have hk : HasDerivAt (fun k : ℝ => k) 1 1 := hasDerivAt_id 1
  have := (((hk.const_mul (-2 : ℝ)).mul_const (0 : ℝ)).div_const (1 : ℝ))
  convert this using 1; norm_num

-- Column 2 : partial derivatives with respect to the turn `tau`.
private lemma partial_tau_1 : HasDerivAt (fun t : ℝ => (R3 1 1 t).1) 0 0 := by
  show HasDerivAt (fun t : ℝ => (1 : ℝ) - 2 * ((1 : ℝ) ^ 2 + t ^ 2) / 1) 0 0
  have hk : HasDerivAt (fun t : ℝ => t ^ 2) ((2 : ℕ) * (0 : ℝ) ^ (2 - 1)) 0 := hasDerivAt_pow 2 0
  have := (hasDerivAt_const (0 : ℝ) (1 : ℝ)).sub
    (((hk.const_add ((1 : ℝ) ^ 2)).const_mul (2 : ℝ)).div_const (1 : ℝ))
  convert this using 1; push_cast; ring

private lemma partial_tau_2 : HasDerivAt (fun t : ℝ => (R3 1 1 t).2.1) 0 0 := by
  show HasDerivAt (fun t : ℝ => -((1 : ℝ) ^ 2 - t ^ 2) / 1) 0 0
  have hk : HasDerivAt (fun t : ℝ => t ^ 2) ((2 : ℕ) * (0 : ℝ) ^ (2 - 1)) 0 := hasDerivAt_pow 2 0
  have := ((hk.const_sub ((1 : ℝ) ^ 2)).neg).div_const (1 : ℝ)
  convert this using 1; push_cast; ring

private lemma partial_tau_3 : HasDerivAt (fun t : ℝ => (R3 1 1 t).2.2) (-2) 0 := by
  show HasDerivAt (fun t : ℝ => -2 * 1 * t / 1) (-2) 0
  have hk : HasDerivAt (fun t : ℝ => t) 1 0 := hasDerivAt_id 0
  have := ((hk.const_mul ((-2 : ℝ) * 1)).div_const (1 : ℝ))
  convert this using 1; norm_num

/-- **`critical_fixed_data`.** At the critical point `(1,1,0)` every entry of the Jacobian
`DR3` is the corresponding partial derivative of `R3` (proved via `HasDerivAt`), and the
Jacobian is the exact rational matrix `!![3,-4,0; 1,-2,0; 0,0,-2]`. -/
theorem critical_fixed_data :
    (HasDerivAt (fun l : ℝ => (R3 l 1 0).1) ((DR3 0 0 : ℚ) : ℝ) 1 ∧
     HasDerivAt (fun l : ℝ => (R3 l 1 0).2.1) ((DR3 1 0 : ℚ) : ℝ) 1 ∧
     HasDerivAt (fun l : ℝ => (R3 l 1 0).2.2) ((DR3 2 0 : ℚ) : ℝ) 1) ∧
    (HasDerivAt (fun k : ℝ => (R3 1 k 0).1) ((DR3 0 1 : ℚ) : ℝ) 1 ∧
     HasDerivAt (fun k : ℝ => (R3 1 k 0).2.1) ((DR3 1 1 : ℚ) : ℝ) 1 ∧
     HasDerivAt (fun k : ℝ => (R3 1 k 0).2.2) ((DR3 2 1 : ℚ) : ℝ) 1) ∧
    (HasDerivAt (fun t : ℝ => (R3 1 1 t).1) ((DR3 0 2 : ℚ) : ℝ) 0 ∧
     HasDerivAt (fun t : ℝ => (R3 1 1 t).2.1) ((DR3 1 2 : ℚ) : ℝ) 0 ∧
     HasDerivAt (fun t : ℝ => (R3 1 1 t).2.2) ((DR3 2 2 : ℚ) : ℝ) 0) ∧
    DR3 = !![3, -4, 0; 1, -2, 0; 0, 0, -2] := by
  refine ⟨⟨?_, ?_, ?_⟩, ⟨?_, ?_, ?_⟩, ⟨?_, ?_, ?_⟩, rfl⟩
  · simpa [DR3] using partial_lam_1
  · simpa [DR3] using partial_lam_2
  · simpa [DR3] using partial_lam_3
  · simpa [DR3] using partial_kap_1
  · simpa [DR3] using partial_kap_2
  · simpa [DR3] using partial_kap_3
  · simpa [DR3] using partial_tau_1
  · simpa [DR3] using partial_tau_2
  · simpa [DR3] using partial_tau_3

/-! ## Target 3 — characteristic polynomial and eigenvalues -/

/-- **`rg_eigenvalues`.** The characteristic polynomial `det(x·I - DR3)` equals
`x³ + x² - 4x - 4 = (x-2)(x+1)(x+2)`, whose roots — the RG eigenvalues — are exactly
`2, -1, -2`. -/
theorem rg_eigenvalues :
    (∀ x : ℚ, (x • (1 : Matrix (Fin 3) (Fin 3) ℚ) - DR3).det = x ^ 3 + x ^ 2 - 4 * x - 4) ∧
    (∀ x : ℚ, x ^ 3 + x ^ 2 - 4 * x - 4 = (x - 2) * (x + 1) * (x + 2)) ∧
    ((2 : ℚ) ^ 3 + 2 ^ 2 - 4 * 2 - 4 = 0 ∧
     (-1 : ℚ) ^ 3 + (-1) ^ 2 - 4 * (-1) - 4 = 0 ∧
     (-2 : ℚ) ^ 3 + (-2) ^ 2 - 4 * (-2) - 4 = 0) := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · intro x
    simp [DR3, Matrix.det_fin_three, Matrix.one_fin_three]
    ring
  · intro x; ring
  · norm_num
  · norm_num
  · norm_num

/-! ## Target 4 — the kill-test payload -/

/-- **`kill_test`.** Classification of the three eigendirections of `DR3`.

* Eigenvalue `2` — **RELEVANT** (`|2| > 1`); eigenvector `(4,1,0)` lies in the
  aperture–closure plane (turn component `= 0`).
* Eigenvalue `-1` — **MARGINAL** (`|-1| = 1`); eigenvector `(1,1,0)` lies in the
  aperture–closure plane (turn component `= 0`).
* Eigenvalue `-2` — **RELEVANT** (`|-2| > 1`); eigenvector is the **pure turn axis**
  `(0,0,1)` (aperture and closure components `= 0`, turn component `= 1`).

**Verdict:** the turn coupling introduces a *new relevant direction* (eigenvalue `-2`).
This relevant direction is the turn basis vector, i.e. it lies inside the span of the named
channel couplings — so basin-membership as stated is **not killed**.  It is a sharpened
result: on this model the turn coupling is relevant, not irrelevant/marginal. -/
theorem kill_test :
    -- eigenvalue 2 : RELEVANT, eigenvector in the aperture–closure plane
    (DR3.mulVec ![4, 1, 0] = (2 : ℚ) • ![4, 1, 0] ∧
      (1 : ℚ) < |(2 : ℚ)| ∧ (![4, 1, 0] : Fin 3 → ℚ) 2 = 0) ∧
    -- eigenvalue -1 : MARGINAL, eigenvector in the aperture–closure plane
    (DR3.mulVec ![1, 1, 0] = (-1 : ℚ) • ![1, 1, 0] ∧
      |(-1 : ℚ)| = 1 ∧ (![1, 1, 0] : Fin 3 → ℚ) 2 = 0) ∧
    -- eigenvalue -2 : RELEVANT, eigenvector is the pure turn axis (NEW relevant direction)
    (DR3.mulVec ![0, 0, 1] = (-2 : ℚ) • ![0, 0, 1] ∧
      (1 : ℚ) < |(-2 : ℚ)| ∧
      (![0, 0, 1] : Fin 3 → ℚ) 0 = 0 ∧
      (![0, 0, 1] : Fin 3 → ℚ) 1 = 0 ∧
      (![0, 0, 1] : Fin 3 → ℚ) 2 = 1) := by
  refine ⟨⟨?_, ?_, ?_⟩, ⟨?_, ?_, ?_⟩, ⟨?_, ?_, ?_, ?_, ?_⟩⟩
  · funext i; fin_cases i <;>
      simp [DR3, Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;> norm_num
  · norm_num
  · simp
  · funext i; fin_cases i <;>
      simp [DR3, Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;> norm_num
  · norm_num
  · simp
  · funext i; fin_cases i <;>
      simp [DR3, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · norm_num
  · simp
  · simp
  · simp

/-! ## Axiom audit — footprint exactly `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'Goal3ChannelRG.R3_closed_form' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms R3_closed_form

/-- info: 'Goal3ChannelRG.critical_fixed_data' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms critical_fixed_data

/-- info: 'Goal3ChannelRG.rg_eigenvalues' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rg_eigenvalues

/-- info: 'Goal3ChannelRG.kill_test' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kill_test

end Goal3ChannelRG

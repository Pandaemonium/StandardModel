import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace EinsteinHilbertTerm

open Matrix

/-!
# The spectral action's order-2 term IS the finite curvature (Einstein–Hilbert)

In the spectral action `Tr f(D/Λ)`, the order-2 heat-kernel term is the gravity
(Einstein–Hilbert, `~ ∫ R`) term.  This file gives a **finite matrix avatar**:
we take a soldered Dirac carrier `D E = Dkin + E • Dsold`, where `Dkin` is an
explicit rational kinetic part and `Dsold` is the soldering generator scaled by
the E-slot decoration `E`, and we compute the order-2 term `tr(D²)` in closed
form as a quadratic in `E`.

* `order2_is_curvature` — `tr(D²) = tr(Dkin²) + 2E·tr(Dkin·Dsold) + E²·tr(Dsold²)`,
  the closed rational quadratic. The `E`-dependent part `Rfin` is the finite
  curvature / Einstein–Hilbert functional of the soldering.
* `einstein_equation` — stationarity `d/dE[tr(D²)] = 0` is the finite Einstein
  field equation, solved by the explicit rational `E⋆ = -tr(Dkin·Dsold)/tr(Dsold²)`;
  with a matter source `μ` the equation becomes `... = μ`.
* `curvature_sign` — the sign of the `E²`-coefficient `tr(Dsold²)` (Krein grading
  of the soldering block) decides convexity: here it is positive, so `E⋆` is a
  genuine minimum.
* `eh_verdict` — the package.

Honest scope: this is a finite rational-polynomial avatar, **not** the heat-kernel
`a₂` coefficient of a genuine spectral triple.
-/

/-- Explicit rational kinetic part of the Dirac carrier. -/
def Dkin : Matrix (Fin 2) (Fin 2) ℚ := !![1, 2; 0, -1]

/-- Explicit rational soldering generator (off-diagonal E-slot block). -/
def Dsold : Matrix (Fin 2) (Fin 2) ℚ := !![0, 1; 1, 0]

/-- The soldered carrier `D(E) = Dkin + E • Dsold`. -/
def D (E : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := Dkin + E • Dsold

/-- Generic expansion of the order-2 trace of `A + c•B`.  This is the algebraic
core: linearity of the trace plus `tr(AB) = tr(BA)`. -/
theorem trace_sq_expand {n : Type*} [Fintype n]
    (A B : Matrix n n ℚ) (c : ℚ) :
    Matrix.trace ((A + c • B) * (A + c • B))
      = Matrix.trace (A * A) + 2 * c * Matrix.trace (A * B)
        + c ^ 2 * Matrix.trace (B * B) := by
  simp only [add_mul, mul_add, Matrix.smul_mul, Matrix.mul_smul, Matrix.trace_add,
    Matrix.trace_smul, smul_eq_mul]
  rw [Matrix.trace_mul_comm B A]
  ring

/-- Concrete trace `tr(Dsold²) = 2`. -/
theorem trace_Dsold_sq : Matrix.trace (Dsold * Dsold) = 2 := by
  norm_num [Dsold, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two]

/-- Concrete cross trace `tr(Dkin·Dsold) = 2`. -/
theorem trace_Dkin_Dsold : Matrix.trace (Dkin * Dsold) = 2 := by
  norm_num [Dkin, Dsold, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two]

/-- Concrete trace `tr(Dkin²) = 2`. -/
theorem trace_Dkin_sq : Matrix.trace (Dkin * Dkin) = 2 := by
  norm_num [Dkin, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_two]

/-! ## Target 1 : the order-2 term is a finite curvature functional -/

/-- **Order-2 = curvature.** The order-2 spectral-action term `tr(D²)` splits as a
closed rational quadratic in the soldering decoration `E`. -/
theorem order2_is_curvature (E : ℚ) :
    Matrix.trace (D E * D E)
      = Matrix.trace (Dkin * Dkin) + 2 * E * Matrix.trace (Dkin * Dsold)
        + E ^ 2 * Matrix.trace (Dsold * Dsold) :=
  trace_sq_expand Dkin Dsold E

/-- The finite curvature / Einstein–Hilbert functional: the `E`-dependent part of
the order-2 term. -/
def Rfin (E : ℚ) : ℚ :=
  2 * E * Matrix.trace (Dkin * Dsold) + E ^ 2 * Matrix.trace (Dsold * Dsold)

/-- `tr(D²)` = (constant order-2 offset) + finite curvature functional `Rfin`. -/
theorem order2_split (E : ℚ) :
    Matrix.trace (D E * D E) = Matrix.trace (Dkin * Dkin) + Rfin E := by
  rw [order2_is_curvature, Rfin]; ring

/-- Fully explicit closed form: `tr(D²) = 2 + 4E + 2E²`. -/
theorem order2_explicit (E : ℚ) :
    Matrix.trace (D E * D E) = 2 + 4 * E + 2 * E ^ 2 := by
  rw [order2_is_curvature, trace_Dkin_sq, trace_Dkin_Dsold, trace_Dsold_sq]; ring

/-- Explicit finite curvature functional: `Rfin E = 4E + 2E²`. -/
theorem Rfin_explicit (E : ℚ) : Rfin E = 4 * E + 2 * E ^ 2 := by
  rw [Rfin, trace_Dkin_Dsold, trace_Dsold_sq]; ring

/-! ## Target 2 : the finite Einstein equation (stationarity) -/

/-- The order-2 term, as a scalar function of the soldering decoration, is the
concrete quadratic `2 + 4E + 2E²`. -/
theorem order2_fun : (fun E : ℚ => Matrix.trace (D E * D E)) = fun E => 2 + 4 * E + 2 * E ^ 2 := by
  funext E; exact order2_explicit E

/-- **Einstein equation (derivative).** The derivative of the order-2 term under
the soldering variation is `2·tr(Dkin·Dsold) + 2E·tr(Dsold²)` (`= 4 + 4E`). -/
theorem einstein_equation (E : ℚ) :
    HasDerivAt (fun x : ℚ => Matrix.trace (D x * D x)) (4 + 4 * E) E := by
  rw [order2_fun]
  have h0 : HasDerivAt (fun _ : ℚ => (2 : ℚ)) 0 E := hasDerivAt_const E 2
  have h1 : HasDerivAt (fun x : ℚ => 4 * x) 4 E := by
    simpa using (hasDerivAt_id E).const_mul 4
  have h2 : HasDerivAt (fun x : ℚ => 2 * x ^ 2) (4 * E) E := by
    have := (hasDerivAt_pow 2 E).const_mul (2 : ℚ)
    simp only [Nat.cast_ofNat] at this
    convert this using 1; ring
  simpa using (h0.add h1).add h2

/-- The explicit vacuum soldering configuration `E⋆ = -1`. -/
def Estar : ℚ := -1

/-- `E⋆` is the finite Einstein solution `E⋆ = -tr(Dkin·Dsold)/tr(Dsold²)`. -/
theorem Estar_formula : Estar = -Matrix.trace (Dkin * Dsold) / Matrix.trace (Dsold * Dsold) := by
  rw [Estar, trace_Dkin_Dsold, trace_Dsold_sq]; norm_num

/-- **Vacuum stationarity.** At `E⋆` the derivative of the order-2 term vanishes:
the finite "Einstein tensor = 0" configuration. -/
theorem einstein_vacuum :
    HasDerivAt (fun x : ℚ => Matrix.trace (D x * D x)) 0 Estar := by
  have h := einstein_equation Estar
  rwa [Estar, show (4 : ℚ) + 4 * (-1) = 0 by norm_num] at h

/-- **Sourced stationarity.** With a matter source `μ` (tie to `GravitySourceMatter`)
the field equation becomes `d/dE[tr(D²)] = μ`, solved by the explicit rational
`Eμ = (μ - 2·tr(Dkin·Dsold))/(2·tr(Dsold²))`. -/
theorem einstein_sourced (mu : ℚ) :
    HasDerivAt (fun x : ℚ => Matrix.trace (D x * D x)) mu
      ((mu - 2 * Matrix.trace (Dkin * Dsold)) / (2 * Matrix.trace (Dsold * Dsold))) := by
  rw [trace_Dkin_Dsold, trace_Dsold_sq]
  have h := einstein_equation ((mu - 2 * 2) / (2 * 2))
  rwa [show (4 : ℚ) + 4 * ((mu - 2 * 2) / (2 * 2)) = mu by ring] at h

/-- **Control.** At the non-stationary point `E = 0 ≠ E⋆` the derivative is `4 ≠ 0`,
so stationarity genuinely fails there. -/
theorem einstein_control :
    HasDerivAt (fun x : ℚ => Matrix.trace (D x * D x)) 4 0 ∧ (4 : ℚ) ≠ 0 := by
  refine ⟨?_, by norm_num⟩
  have h := einstein_equation 0
  rwa [show (4 : ℚ) + 4 * 0 = 4 by norm_num] at h

/-! ## Target 3 : curvature sign / convexity -/

/-- **Curvature sign.** The `E²`-coefficient `tr(Dsold²)` (Krein grading of the
soldering block) is positive here, so the finite curvature functional is convex
and `E⋆` is a genuine minimum (not a saddle). -/
theorem curvature_sign : 0 < Matrix.trace (Dsold * Dsold) := by
  rw [trace_Dsold_sq]; norm_num

/-! ## Target 4 : the verdict -/

/-- **Einstein–Hilbert verdict.** The spectral action's order-2 term is a finite
curvature functional of the soldering (E-slot):

* it splits as `tr(D²) = tr(Dkin²) + Rfin(E)` with `Rfin` the finite
  Einstein–Hilbert functional;
* its stationarity `d/dE[tr(D²)] = 0` is a finite Einstein field equation, solved
  by the explicit rational vacuum `E⋆ = -tr(Dkin·Dsold)/tr(Dsold²) = -1`;
* the `E²`-coefficient `tr(Dsold²) > 0` makes the functional convex, so `E⋆` is a
  genuine minimum.

Order-0 (Λ, volume) and order-4 (matter) live in the same functional; this is the
order-2 gravity term. -/
theorem eh_verdict :
    (∀ E : ℚ, Matrix.trace (D E * D E) = Matrix.trace (Dkin * Dkin) + Rfin E) ∧
    (∀ E : ℚ, Rfin E = 4 * E + 2 * E ^ 2) ∧
    HasDerivAt (fun x : ℚ => Matrix.trace (D x * D x)) 0 Estar ∧
    Estar = -Matrix.trace (Dkin * Dsold) / Matrix.trace (Dsold * Dsold) ∧
    0 < Matrix.trace (Dsold * Dsold) :=
  ⟨order2_split, Rfin_explicit, einstein_vacuum, Estar_formula, curvature_sign⟩

/-! ## Kernel-checked axiom footprints (headlines) -/

/-- info: 'EinsteinHilbertTerm.order2_is_curvature' depends on axioms:
[propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms order2_is_curvature

/-- info: 'EinsteinHilbertTerm.einstein_equation' depends on axioms:
[propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms einstein_equation

/-- info: 'EinsteinHilbertTerm.curvature_sign' depends on axioms:
[propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms curvature_sign

/-- info: 'EinsteinHilbertTerm.eh_verdict' depends on axioms:
[propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eh_verdict

end EinsteinHilbertTerm

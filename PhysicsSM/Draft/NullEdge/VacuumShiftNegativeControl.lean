import Mathlib

/-!
# Vacuum-shift negative control: the pi/2 quadratic offset is not gauge

Micro-tail completing the landed `VacuumShiftEnsemble` module (parent
repository).  The original negative control at `c = pi` was refuted by
Aristotle: on counts `(1,2)`, `N^2 = N (mod 2)`, so the pi-quadratic offset
is secretly extensive and absorbable.  This package proves the TRUE negative
control at `c = pi/2`: the offset weights are `(exp(i pi/2), exp(2 pi i)) =
(i, 1)`, while any Lambda shift supplies unit phases `(a, a^2)` with
`a = exp(-i c')`; matching forces `a = i` hence `a^2 = -1 /= 1`.
Contradiction.  Only extensive offsets are gauge; genuinely non-extensive
offsets are observable.

Proof route (suggested): evaluate the assumed equality at `Lambda = 0` and
`Lambda = pi`; with `exp(i pi) = -1` the two evaluations give
`i + 1 = a + b` and `1 - i = -a + b`; subtract and add to force `a = i`,
`b = 1`; but `b = exp(-2 i c') = a^2 = -1`.

Do not weaken the statement.  Helper lemmas welcome.  Run the narrow check
`lake env lean VacuumShiftNegativeControl/HalfPiControl.lean` first.
Recovered from Aristotle project `77a5d5c5-aa67-4594-8916-586ff15a16ac`; proof bodies verified locally
under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.VacuumShiftNegativeControl

open Complex

/-- The dressed total amplitude of a finite geometry ensemble (copied
verbatim from the landed `VacuumShiftEnsemble`). -/
noncomputable def Ztot {g : ℕ} (N : Fin g → ℕ) (Zrel : Fin g → ℂ)
    (Λ : ℝ) : ℂ :=
  ∑ K : Fin g, Complex.exp (Complex.I * (Λ : ℂ) * (N K : ℂ)) * Zrel K

/-
The pi/2 quadratic offset on counts `(1,2)` cannot be absorbed by any
constant shift of Lambda.
-/
theorem halfpi_offset_not_absorbable :
    ¬ ∃ c' : ℝ, ∀ Λ : ℝ,
      Ztot (g := 2) ![1, 2]
          (fun K =>
            Complex.exp
                (Complex.I * ((Real.pi / 2 : ℝ) : ℂ) * ((![1, 2] K : ℕ) : ℂ) ^ 2) *
              (1 : ℂ))
          Λ =
        Ztot (g := 2) ![1, 2] (fun _ => (1 : ℂ)) (Λ - c') := by
  norm_num [ Ztot ];
  intro x; use 0; norm_num [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ] ; ring_nf;
  norm_num [ mul_two ];
  intro h; nlinarith [ Real.sin_sq_add_cos_sq x, Real.sin_sq_add_cos_sq ( x + x ), Real.sin_add x x, Real.cos_add x x ] ;

end PhysicsSM.Draft.NullEdge.VacuumShiftNegativeControl

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.VacuumShiftNegativeControl.halfpi_offset_not_absorbable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.VacuumShiftNegativeControl.halfpi_offset_not_absorbable

import Mathlib

/-!
# The derived charge group: automorphisms of the witness decoder

Bridge (vii) of the manuscript's open-bridge list, and RUN_PLAN E2.2: derive
the gauge group as the automorphism group of the decoder data rather than
supplying charge registers.  This package computes it EXACTLY for the
program's explicit three-dimensional witness: the constraint differential
`Q = !![0,1,0;0,0,0;0,0,0]`, the Krein involution `J = !![0,1,0;1,0,0;0,0,1]`,
and the spectral decoder `D = diag(0,0,mu)` (`mu` real, nonzero).

A physical symmetry of the decoder is an invertible `U` with

  `U Q = Q U`,  `Uᴴ J U = J`,  `U D = D U`.

## Targets

1. `automorphism_classification` — the exact two-way normal form.  The
   commutant of the nilpotent `Q` forces the flag form
   `!![a, b, c; 0, a, 0; 0, e, f]`; the Krein isometry then forces
   `|a| = |f| = 1`, `2 Re(conj(a) b) + |e|^2 = 0`, and
   `conj(a) c + conj(e) f = 0`; commutation with `D = diag(0,0,mu)`
   (`mu ≠ 0`) kills `c` and `e`.  The result is the two-parameter torus with
   one real gauge modulus:
   `IsDecoderAut mu U ↔ ∃ (a w : ℂ) (t : ℝ), star a * a = 1 ∧
      star w * w = 1 ∧ U = !![a, (Complex.I * t) * a, 0; 0, a, 0; 0, 0, w]`
   (the condition `Re(conj(a) b) = 0` is equivalent to `b = I t a`, `t`
   real).  This derivation chain was checked by hand before submission; if
   any clause fails, REPORT the discrepancy — do not weaken the
   biconditional to one direction.
2. `induced_action_on_class` — every decoder automorphism acts on the
   physical representative `e2 = ![0,0,1]` by a unit phase: the DERIVED
   charge group acting on the physical class is exactly `U(1)` — derived,
   not inserted.  (The `t`-modulus moves only the exact/gauge line: channel
   gauge, not physical charge.)
3. `witness_nontrivial` — the explicit automorphism `diag(1, 1, I)` acts on
   `e2` by the quarter phase.
4. `rigidity_control` — dropping `D`-commutation strictly enlarges the
   group: a `U0` satisfying the `Q` and Krein conditions but not commuting
   with `D` exists (e.g. flag form with `e = 1`, `c = -1`,
   `b = -1/2`); the decoder is load-bearing in cutting the symmetry to the
   physical torus.

Honest scope: the automorphism group of ONE witness decoder; deriving
`SU(3) x SU(2) x U(1)` or any nonabelian structure is untouched.  What this
establishes is the METHOD: charge groups can be outputs of decoder data.
Do not weaken the statements (two-way characterizations stay two-way; if a
normal form is wrong, report and correct rather than dropping a direction).
Run `lake env lean DecoderAutomorphismGroup/DerivedChargeGroup.lean` first.
-/

namespace DecoderAutomorphismGroup

open Matrix

/-- The witness constraint differential. -/
def Qc : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 0, 0, 0; 0, 0, 0]

/-- The witness Krein involution. -/
def Jc : Matrix (Fin 3) (Fin 3) ℂ := !![0, 1, 0; 1, 0, 0; 0, 0, 1]

/-- The witness spectral decoder. -/
noncomputable def Dc (mu : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![0, 0, 0; 0, 0, 0; 0, 0, (mu : ℂ)]

/-- A decoder automorphism: invertible, intertwines `Q`, preserves the Krein
form, commutes with the decoder. -/
def IsDecoderAut (mu : ℝ) (U : Matrix (Fin 3) (Fin 3) ℂ) : Prop :=
  IsUnit U ∧ U * Qc = Qc * U ∧ Uᴴ * Jc * U = Jc ∧ U * Dc mu = Dc mu * U

/-- The physical class representative. -/
def e2 : Fin 3 → ℂ := ![0, 0, 1]

/-- Target 2: exact classification of the decoder automorphisms.  (If the
derived normal form differs, prove the corrected two-way version and report
the discrepancy.) -/
theorem automorphism_classification (mu : ℝ) (hmu : mu ≠ 0)
    (U : Matrix (Fin 3) (Fin 3) ℂ) :
    IsDecoderAut mu U ↔
      ∃ (a w : ℂ) (t : ℝ), star a * a = 1 ∧ star w * w = 1 ∧
        U = !![a, (Complex.I * (t : ℂ)) * a, 0; 0, a, 0; 0, 0, w] := by
  sorry

/-- Target 3: the derived charge group.  Every decoder automorphism acts on
the physical class by a unit phase — the derived `U(1)`. -/
theorem induced_action_on_class (mu : ℝ) (hmu : mu ≠ 0)
    (U : Matrix (Fin 3) (Fin 3) ℂ) (hU : IsDecoderAut mu U) :
    ∃ w : ℂ, star w * w = 1 ∧ U.mulVec e2 = w • e2 := by
  sorry

/-- Target 5: an explicit nontrivial automorphism acting on the physical
class by the quarter phase. -/
theorem witness_nontrivial (mu : ℝ) :
    IsDecoderAut mu !![1, 0, 0; 0, 1, 0; 0, 0, Complex.I] ∧
    (!![1, 0, 0; 0, 1, 0; 0, 0, Complex.I] : Matrix (Fin 3) (Fin 3) ℂ).mulVec e2
      = Complex.I • e2 := by
  sorry

/-- Target 6 (rigidity control): dropping decoder-commutation strictly
enlarges the group — an explicit `U0` satisfies the `Q` and Krein conditions
but fails to commute with `D`. -/
theorem rigidity_control (mu : ℝ) (hmu : mu ≠ 0) :
    ∃ U0 : Matrix (Fin 3) (Fin 3) ℂ,
      IsUnit U0 ∧ U0 * Qc = Qc * U0 ∧ U0ᴴ * Jc * U0 = Jc ∧
        U0 * Dc mu ≠ Dc mu * U0 := by
  sorry

end DecoderAutomorphismGroup

import Mathlib

/-!
# Finite Lorentz audit forcing the quadratic mass Casimir

This standalone target formalizes a scoped taxonomy anchor for the null-edge
kinematic-completeness theorem.  It does not attempt the full Wigner
classification of unitary irreducible Poincare representations.  Instead it
proves that a symmetric real quadratic form on four-momentum which survives a
small explicit set of standard Lorentz transformations is necessarily a scalar
multiple of the Minkowski metric.

Preserve the theorem statements exactly.  The explicit matrices are mandatory
nonvacuity witnesses.  The proof may expand all 4 by 4 matrix entries and use
linear arithmetic.
-/

open Matrix

noncomputable section

namespace FiniteLorentzMassCasimir

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Real

def eta : Mat4 := diagonal ![1, -1, -1, -1]

def halfTurnXY : Mat4 :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, 1]

def halfTurnXZ : Mat4 :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, -1]

def quarterTurnXY : Mat4 :=
  !![1, 0, 0, 0;
     0, 0, -1, 0;
     0, 1, 0, 0;
     0, 0, 0, 1]

def quarterTurnYZ : Mat4 :=
  !![1, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, 0, -1;
     0, 0, 1, 0]

/-- The exact 3-4-5 Lorentz boost in the first spatial direction. -/
def rationalBoostX : Mat4 :=
  !![5 / 4, 3 / 4, 0, 0;
     3 / 4, 5 / 4, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, 1]

def Preserves (L Q : Mat4) : Prop := L.transpose * Q * L = Q

/-- Every displayed audit transformation really preserves the chosen
Minkowski metric. -/
theorem audit_witnesses_preserve_eta :
    Preserves halfTurnXY eta /\
      Preserves halfTurnXZ eta /\
      Preserves quarterTurnXY eta /\
      Preserves quarterTurnYZ eta /\
      Preserves rationalBoostX eta := by
  sorry

/-- A symmetric four-momentum quadratic form invariant under the displayed
finite Lorentz audit is a scalar multiple of the Minkowski metric. -/
theorem quadratic_casimir_unique (Q : Mat4)
    (hSymm : Q.IsSymm)
    (hXY : Preserves halfTurnXY Q)
    (hXZ : Preserves halfTurnXZ Q)
    (hRotXY : Preserves quarterTurnXY Q)
    (hRotYZ : Preserves quarterTurnYZ Q)
    (hBoost : Preserves rationalBoostX Q) :
    Q = Q 0 0 • eta := by
  sorry

/-- The finite audit is nonvacuous and fixes the standard normalization when
the time-time coefficient is one. -/
theorem normalized_quadratic_casimir_unique (Q : Mat4)
    (hSymm : Q.IsSymm)
    (h00 : Q 0 0 = 1)
    (hXY : Preserves halfTurnXY Q)
    (hXZ : Preserves halfTurnXZ Q)
    (hRotXY : Preserves quarterTurnXY Q)
    (hRotYZ : Preserves quarterTurnYZ Q)
    (hBoost : Preserves rationalBoostX Q) :
    Q = eta := by
  rw [quadratic_casimir_unique Q hSymm hXY hXZ hRotXY hRotYZ hBoost, h00,
    one_smul]

end FiniteLorentzMassCasimir

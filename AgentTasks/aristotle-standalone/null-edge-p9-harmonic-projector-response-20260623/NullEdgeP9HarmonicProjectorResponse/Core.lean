import Mathlib.Tactic

/-!
# P9 harmonic-projector response algebra

This focused package adds the first explicit projector layer to the P9
source-visibility API. A self-adjoint finite projector `Pi` plays the role of a
chosen harmonic/source-visible projection. Harmonic tests see only `Pi source`,
and boundary-exact perturbations vanish if `Pi` annihilates boundary sources.
-/

noncomputable section

namespace NullEdgeP9HarmonicProjectorResponse

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

def dot {n : Nat} (x y : Cochain n) : Real :=
  Finset.univ.sum fun i => x i * y i

def sourcePairing {n : Nat} (source test : Cochain n) : Real :=
  dot source test

def lin {n : Nat} (Pi : Fin n -> Fin n -> Real) (x : Cochain n) : Cochain n :=
  fun i => Finset.univ.sum fun j => Pi i j * x j

def SelfAdjoint {n : Nat} (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x y : Cochain n, dot (lin Pi x) y = dot x (lin Pi y)

def HarmonicTest {n : Nat} (Pi : Fin n -> Fin n -> Real)
    (test : Cochain n) : Prop :=
  lin Pi test = test

def boundarySource {b f : Nat} (D : Fin b -> Fin f -> Real)
    (a : Cochain b) : Cochain f :=
  fun i => Finset.univ.sum fun j => D j i * a j

def AnnihilatesBoundary {b f : Nat}
    (Pi : Fin f -> Fin f -> Real) (D : Fin b -> Fin f -> Real) : Prop :=
  forall a : Cochain b, lin Pi (boundarySource D a) = 0

def addCochain {n : Nat} (x y : Cochain n) : Cochain n :=
  fun i => x i + y i

theorem harmonicTest_pairing_eq_projectedSource
    {f : Nat} (Pi : Fin f -> Fin f -> Real)
    (source test : Cochain f)
    (hself : SelfAdjoint Pi) (htest : HarmonicTest Pi test) :
    sourcePairing source test = sourcePairing (lin Pi source) test := by
  sorry

theorem boundarySource_pairing_harmonicTest_eq_zero
    {b f : Nat} (Pi : Fin f -> Fin f -> Real) (D : Fin b -> Fin f -> Real)
    (a : Cochain b) (test : Cochain f)
    (hself : SelfAdjoint Pi)
    (hann : AnnihilatesBoundary Pi D)
    (htest : HarmonicTest Pi test) :
    sourcePairing (boundarySource D a) test = 0 := by
  sorry

theorem boundaryPerturb_pairing_harmonicTest_eq_projectedSource
    {b f : Nat} (Pi : Fin f -> Fin f -> Real) (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) (test : Cochain f)
    (hself : SelfAdjoint Pi)
    (hann : AnnihilatesBoundary Pi D)
    (htest : HarmonicTest Pi test) :
    sourcePairing (addCochain source (boundarySource D a)) test =
      sourcePairing (lin Pi source) test := by
  sorry

end NullEdgeP9HarmonicProjectorResponse

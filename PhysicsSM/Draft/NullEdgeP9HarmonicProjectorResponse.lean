import Mathlib.Tactic

/-!
# P9 harmonic-projector response algebra

This draft module adds the first explicit projector layer to the P9
source-visibility API. A self-adjoint finite projector `Pi` plays the role of a
chosen harmonic/source-visible projection. Harmonic tests see only `Pi source`,
and boundary-exact perturbations vanish if `Pi` annihilates boundary sources.

Proven by Aristotle project `dcaa53fb-7c55-441f-b56b-ded744d7e6ed` on
2026-06-23 from the focused package
`null-edge-p9-harmonic-projector-response-20260623`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9HarmonicProjectorResponse

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
  rw [sourcePairing, sourcePairing, hself]
  rw [htest]

theorem boundarySource_pairing_harmonicTest_eq_zero
    {b f : Nat} (Pi : Fin f -> Fin f -> Real) (D : Fin b -> Fin f -> Real)
    (a : Cochain b) (test : Cochain f)
    (hself : SelfAdjoint Pi)
    (hann : AnnihilatesBoundary Pi D)
    (htest : HarmonicTest Pi test) :
    sourcePairing (boundarySource D a) test = 0 := by
  unfold sourcePairing
  conv_lhs => rw [<- htest]
  rw [<- hself, hann]
  unfold dot
  norm_num

theorem boundaryPerturb_pairing_harmonicTest_eq_projectedSource
    {b f : Nat} (Pi : Fin f -> Fin f -> Real) (D : Fin b -> Fin f -> Real)
    (source : Cochain f) (a : Cochain b) (test : Cochain f)
    (hself : SelfAdjoint Pi)
    (hann : AnnihilatesBoundary Pi D)
    (htest : HarmonicTest Pi test) :
    sourcePairing (addCochain source (boundarySource D a)) test =
      sourcePairing (lin Pi source) test := by
  calc
    sourcePairing (addCochain source (boundarySource D a)) test =
        sourcePairing source test + sourcePairing (boundarySource D a) test := by
      unfold sourcePairing addCochain
      unfold dot
      simp +decide [Finset.sum_add_distrib, add_mul]
    _ = sourcePairing (lin Pi source) test + 0 := by
      rw [harmonicTest_pairing_eq_projectedSource Pi source test hself htest,
        boundarySource_pairing_harmonicTest_eq_zero Pi D a test hself hann htest]
    _ = sourcePairing (lin Pi source) test := by
      ring

end PhysicsSM.Draft.NullEdgeP9HarmonicProjectorResponse

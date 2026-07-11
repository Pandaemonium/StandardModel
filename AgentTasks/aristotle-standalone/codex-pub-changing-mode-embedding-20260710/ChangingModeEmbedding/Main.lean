import Mathlib

/-!
# Explicit changing-space mode embeddings

This standalone Paper D target supplies concrete sample/interpolate maps between
finite momentum boxes and the common countable Fourier-mode space.  It is the
changing-Hilbert-space infrastructure needed between finite-torus DFT conjugacy
and a continuum `L2` theorem.

The target is deliberately analytic rather than physical: it proves exact
round trips, exact energy normalization, and strong square-summable tail
convergence.  It does not identify the live walk or the continuum Dirac flow.
-/

noncomputable section

open scoped BigOperators Topology
open Filter

namespace ChangingModeEmbedding

/-- Integer momentum labels in three dimensions. -/
abbrev Mode := (Int × Int) × Int

/-- Symmetric integer interval of radius `N`. -/
def intInterval (N : Nat) : Finset Int :=
  Finset.Icc (-(N : Int)) (N : Int)

/-- The cubic momentum box `[-N,N]^3`. -/
def modeBox (N : Nat) : Finset Mode :=
  (intInterval N).product (intInterval N) |>.product (intInterval N)

/-- The finite coefficient space at cutoff `N`. -/
abbrev BoxCoeff (N : Nat) (E : Type*) := {k : Mode // k ∈ modeBox N} → E

/-- Restrict a common mode field to the finite cutoff box. -/
def sample {E : Type*} (N : Nat) (f : Mode → E) : BoxCoeff N E :=
  fun k => f k.1

/-- Embed finite coefficients into the common mode space by zero padding. -/
def interpolate {E : Type*} [Zero E] (N : Nat) (c : BoxCoeff N E) : Mode → E :=
  fun k => if hk : k ∈ modeBox N then c ⟨k, hk⟩ else 0

/-- Cut a common mode field off outside the box. -/
def truncate {E : Type*} [Zero E] (N : Nat) (f : Mode → E) : Mode → E :=
  fun k => if k ∈ modeBox N then f k else 0

/-- Sampling after zero-padding is exactly the identity on every finite space. -/
theorem sample_interpolate {E : Type*} [Zero E] (N : Nat) (c : BoxCoeff N E) :
    sample N (interpolate N c) = c := by
  sorry

/-- Zero-padding after sampling is exactly the common-space truncation. -/
theorem interpolate_sample {E : Type*} [Zero E] (N : Nat) (f : Mode → E) :
    interpolate N (sample N f) = truncate N f := by
  sorry

/-- The boxes are nested as the cutoff grows. -/
theorem modeBox_mono : Monotone modeBox := by
  sorry

/-- Every integer momentum lies in some finite box. -/
theorem modeBox_exhausts :
    (⋃ N : Nat, (modeBox N : Set Mode)) = Set.univ := by
  sorry

/-- Finite squared norm of cutoff coefficients. -/
def finiteEnergy {E : Type*} [Norm E] (N : Nat) (c : BoxCoeff N E) : Real :=
  ∑ k, ‖c k‖ ^ 2

/-- Squared norm in the common countable mode space. -/
def modeEnergy {E : Type*} [Norm E] (f : Mode → E) : Real :=
  ∑' k, ‖f k‖ ^ 2

/-- Zero-padding preserves the finite coefficient energy exactly. -/
theorem interpolate_energy {E : Type*} [NormedAddCommGroup E]
    (N : Nat) (c : BoxCoeff N E) :
    modeEnergy (interpolate N c) = finiteEnergy N c := by
  sorry

/-- Strong changing-space convergence: sample and zero-pad converge in squared
mode energy to every square-summable field. -/
theorem interpolate_sample_tendsto {E : Type*} [NormedAddCommGroup E]
    (f : Mode → E) (hf : Summable (fun k => ‖f k‖ ^ 2)) :
    Tendsto
      (fun N => modeEnergy (fun k => f k - interpolate N (sample N f) k))
      atTop (nhds 0) := by
  sorry

/-- Delta field at one momentum. -/
def deltaAt {E : Type*} [Zero E] (q : Mode) (v : E) : Mode → E :=
  fun k => if k = q then v else 0

/-- Nonzero control: the zero momentum survives every cutoff. -/
theorem zero_mode_roundtrip {E : Type*} [Zero E] (N : Nat) (v : E) :
    interpolate N (sample N (deltaAt ((0, 0), 0) v)) =
      deltaAt ((0, 0), 0) v := by
  sorry

/-- Boundary control: a mode one unit beyond the positive x face is removed. -/
theorem outside_mode_killed {E : Type*} [Zero E] (N : Nat) (v : E) :
    interpolate N
        (sample N (deltaAt ((((N + 1 : Nat) : Int), 0), 0) v)) = 0 := by
  sorry

end ChangingModeEmbedding

import PhysicsSM.Draft.NullEdge.ExactCheckerboardPathSum

/-!
# Exact checkerboard amplitude gluing

This module supplies the missing composition arrow between finite null
histories and their amplitudes. Concatenating histories multiplies their path
weights, provided the terminal direction of the first segment is used as the
incoming direction of the second. That intermediate direction is essential:
it counts a turn at the gluing boundary exactly once.

The result is finite and exact over any semiring for `pathWeight`, and then over
the Gaussian rationals for the physical checkerboard amplitude
`(i * eps * m)^turnCount`. It is not a continuum propagator composition law or
a derivation of the amplitude assignment itself.

Provenance: run-level composition theorem identified independently by the
2026-07-10 Aristotle strategy and architecture audits, then clean-room
formalized by Codex from the trusted checkerboard recursion API.
-/

namespace PhysicsSM.Draft.NullEdge.CheckerboardAmplitudeGluing

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction

/-- Path weights multiply under chronological concatenation. The terminal
direction of `h1` is the incoming direction for `h2`. -/
theorem pathWeight_append {R : Type*} [Semiring R] (mu : R)
    (startDir : Direction) (h1 h2 : List Direction) :
    pathWeight mu startDir (h1 ++ h2) =
      pathWeight mu startDir h1 *
        pathWeight mu (terminalDirection startDir h1) h2 := by
  induction h1 generalizing startDir with
  | nil => simp
  | cons next rest ih =>
      simp only [List.cons_append, pathWeight_cons, terminalDirection_cons]
      rw [ih]
      simp only [mul_assoc]

/-- Gaussian-rational checkerboard amplitudes obey the same exact gluing law. -/
theorem pathAmplitude_append (eps m : ℚ) (startDir : Direction)
    (h1 h2 : List Direction) :
    pathAmplitude eps m startDir (h1 ++ h2) =
      pathAmplitude eps m startDir h1 *
        pathAmplitude eps m (terminalDirection startDir h1) h2 := by
  rw [← pathAmplitude_eq_corner_power, pathWeight_append,
    pathAmplitude_eq_corner_power, pathAmplitude_eq_corner_power]

/-- A nonzero two-segment fixture whose gluing boundary contributes the second
turn. It excludes the degenerate readings `m = 0` and straight-only history. -/
theorem two_segment_turn_gluing_witness :
    turnCount right [right, left] = 1 ∧
      terminalDirection right [right, left] = left ∧
      turnCount left [right] = 1 ∧
      turnCount right ([right, left] ++ [right]) = 2 ∧
      pathAmplitude 1 1 right ([right, left] ++ [right]) =
          pathAmplitude 1 1 right [right, left] *
            pathAmplitude 1 1
              (terminalDirection right [right, left]) [right] ∧
      pathAmplitude 1 1 right [right, left] ≠ 0 ∧
      pathAmplitude 1 1
          (terminalDirection right [right, left]) [right] ≠ 0 := by
  refine ⟨by decide, rfl, by decide, by decide,
    pathAmplitude_append 1 1 right [right, left] [right], ?_, ?_⟩
  · intro h
    have him := congrArg GaussianRat.im h
    simp +decide [pathAmplitude, cornerWeight, turnCount, GaussianRat.I,
      GaussianRat.ofRat] at him
  · intro h
    have him := congrArg GaussianRat.im h
    simp +decide [pathAmplitude, cornerWeight, turnCount,
      GaussianRat.I, GaussianRat.ofRat] at him

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CheckerboardAmplitudeGluing.pathAmplitude_append' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pathAmplitude_append

/-- info: 'PhysicsSM.Draft.NullEdge.CheckerboardAmplitudeGluing.two_segment_turn_gluing_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_segment_turn_gluing_witness

end PhysicsSM.Draft.NullEdge.CheckerboardAmplitudeGluing

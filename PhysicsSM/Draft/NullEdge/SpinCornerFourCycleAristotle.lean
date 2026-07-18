import Mathlib

/-!
# Four-cycle Bargmann identity and the exact hairpin lune-phase law

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 2,
job A, 2026-07-16.
Integrated 2026-07-16 from Aristotle project 3b35a00c-6139-4105-9ac9-7742c7810bb2 (run 6caae25f); statements verbatim from the submitted package; namespace renamed for the draft tree; axiom guards added at integration.

## What this file states

Wave 1 (landed 2026-07-14/16 in the parent repo) proved the three-cycle
Bargmann identity, planar CP-inertness at three corners, and two rational
four-corner witnesses (-1/4 for the antipodal-meridian hairpin pair, +1/4 for
the zero-lune backtrack). This file upgrades the witness layer to exact laws:

1. `four_cycle`: the general polynomial four-cycle Bargmann identity
   tr(P(a)P(b)P(c)P(d)) = (1 + [six pairwise dots]
     + (a.b)(c.d) + (a.d)(b.c) - (a.c)(b.d)
     + i * [t(abc) + t(abd) + t(acd) + t(bcd)]) / 8,
   with t the oriented triple product. No unit-norm hypotheses.
2. `four_cycle_im` / `four_cycle_planar_real`: the imaginary part is the sum
   of the four oriented volumes over 8; if those volumes vanish (in
   particular for any coplanar four directions) the invariant is real.
3. `four_cycle_reversal_conj`: orientation reversal conjugates the invariant.
4. `hairpin_lune_phase`: THE exact lune-phase law. For the hairpin pair
   z -> (u,v,0) -> -z -> (u',v',0),
   tr = ((u u' + v v') + i (u v' - v u')) / 4
      = conj(u + i v) * (u' + i v') / 4.
   The azimuthal U(1) of meridian resolutions acts as a LITERAL complex
   phase on the hairpin amplitude: phase = the azimuthal angle between the
   two meridians = half the enclosed lune solid angle. Polynomial in
   (u,v,u',v') - no normalization hypotheses.
5. `hairpin_lune_phase_complex`: the same law packaged as complex
   multiplication (the equatorial corner algebra IS the complex numbers).
6. `quarter_turn_corner`: (u,v) = (1,0), (u',v') = (0,1) gives trace i/4 -
   the 1+1 checkerboard's corner factor i is EXACTLY a quarter-turn lune.
7. `half_turn_corner` / `zero_turn_corner`: the wave-1 witnesses -(1/4) and
   +1/4 recovered as the Delta = pi and Delta = 0 cases.

## Conventions

- Pauli matrices sigmaX = !![0,1;1,0], sigmaY = !![0,-i;i,0],
  sigmaZ = !![1,0;0,-1] (standard); directions are raw triples Fin 3 -> R;
  proj a = (1 + a.sigma)/2; dot and triple are the Euclidean dot and the
  right-handed oriented triple product. Identical to the wave-1 package
  SpinCornerCore (parent-repo module SpinCornerBargmannAristotle).
- equator u v = (u, v, 0); ez = (0,0,1). The lune law needs no norm
  hypotheses because ez is exactly unit by construction.

## Intended reading (spiral layer)

The hairpin (mass) corner pair, resolved through meridians, carries exactly
the geometric phase e^{i Delta} predicted by the half-solid-angle rule
(lune of dihedral angle Delta has solid angle 2*Delta). The 1+1 checkerboard
corner weight i*eps*m is therefore the quarter-turn (Delta = pi/2) fossil of
a handed spiral resolution, now as an exact one-parameter law rather than two
witnesses. Left- vs right-handed resolutions give conjugate phases
(matter/antimatter orientation in the program's CPT reading). M-grade finite
identities once proved; the checkerboard-limit and CP readings are
interpretation and are NOT claimed by the statements.

## Provenance

Clean-room from standard Pauli algebra and the spin-1/2 Bargmann-invariant
geometric-phase rule. Wave-1 parent-repo companions:
`PhysicsSM.Draft.NullEdge.SpinCornerBargmannAristotle` (three-cycle),
`PhysicsSM.Draft.NullEdge.HairpinLunePhaseAristotle` (rational witnesses).
The four-cycle coefficients were hand-derived twice via
tr((a.sigma)(b.sigma)(c.sigma)(d.sigma)) = 2[(a.b)(c.d) - (axb).(cxd)] and
cross-checked against both wave-1 witnesses before submission.

## Proof guidance

Everything is 2x2 and entrywise-finite. Unfold proj, pauli, dot, triple,
equator; ext i j; fin_cases i <;> fin_cases j; simp with Matrix.mul_apply,
Fin.sum_univ_succ, Matrix.smul_apply, Matrix.one_apply; then Complex.ext_iff
and ring / norm_num. Matrix.trace_fin_two helps trace goals. The corollaries
follow from `four_cycle` by taking im-parts / star / specialization; direct
entrywise computation is also fine. Helper lemmas welcome; the numbered
statements must stay verbatim.

Do not weaken or modify any statement or definition; the placeholder proofs
are the only intended gaps.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.SpinCornerFourCycle

open Matrix

/-- 2x2 complex matrices: the spin-coherent corner algebra. -/
abbrev SpinMat := Matrix (Fin 2) (Fin 2) ℂ

/-- Raw real direction triples (no normalization built in). -/
abbrev Vec3 := Fin 3 → ℝ

/-- Standard Pauli sigma_x. -/
def sigmaX : SpinMat := !![0, 1; 1, 0]

/-- Standard Pauli sigma_y. -/
def sigmaY : SpinMat := !![0, -Complex.I; Complex.I, 0]

/-- Standard Pauli sigma_z. -/
def sigmaZ : SpinMat := !![1, 0; 0, -1]

/-- Pauli vector a.sigma for a raw real triple a. -/
def pauli (a : Vec3) : SpinMat :=
  ((a 0 : ℂ)) • sigmaX + ((a 1 : ℂ)) • sigmaY + ((a 2 : ℂ)) • sigmaZ

/-- Spin-coherent corner matrix (1 + a.sigma)/2. -/
def proj (a : Vec3) : SpinMat := (1 / 2 : ℂ) • (1 + pauli a)

/-- Euclidean dot product of raw triples. -/
def dot (a b : Vec3) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

/-- Oriented triple product a.(b x c). -/
def triple (a b c : Vec3) : ℝ :=
  a 0 * (b 1 * c 2 - b 2 * c 1) + a 1 * (b 2 * c 0 - b 0 * c 2)
    + a 2 * (b 0 * c 1 - b 1 * c 0)

/-- Unit z direction. -/
def ez : Vec3 := ![0, 0, 1]

/-- Equatorial direction (u, v, 0); not assumed normalized. -/
def equator (u v : ℝ) : Vec3 := ![u, v, 0]

/-- **General four-cycle Bargmann identity.** Polynomial in all four raw
directions - no unit-norm hypotheses. -/
theorem four_cycle (a b c d : Vec3) :
    (proj a * proj b * proj c * proj d).trace
      = (((1 + dot a b + dot a c + dot a d + dot b c + dot b d + dot c d
            + dot a b * dot c d + dot a d * dot b c
            - dot a c * dot b d : ℝ) : ℂ)
          + Complex.I
            * ((triple a b c + triple a b d + triple a c d
                + triple b c d : ℝ) : ℂ)) / 8 := by
  unfold proj dot triple
  simp +decide [Matrix.trace_fin_two, Matrix.mul_apply, pauli]
  norm_num [Complex.ext_iff, sigmaX, sigmaY, sigmaZ] at *
  grind

/-- The four-cycle's imaginary part is the sum of the four oriented volumes
over eight: the unique orientation-odd invariant at four corners. -/
theorem four_cycle_im (a b c d : Vec3) :
    ((proj a * proj b * proj c * proj d).trace).im
      = (triple a b c + triple a b d + triple a c d + triple b c d) / 8 := by
  convert congr_arg Complex.im (four_cycle a b c d) using 1
  norm_num [div_eq_mul_inv]

/-- Planar (zigzag) four-corner histories are CP-inert: if the four oriented
volumes cancel (in particular for coplanar directions), the invariant is
real. -/
theorem four_cycle_planar_real (a b c d : Vec3)
    (h : triple a b c + triple a b d + triple a c d + triple b c d = 0) :
    ((proj a * proj b * proj c * proj d).trace).im = 0 := by
  convert congr_arg (fun x : ℝ => x / 8) h using 1
  · convert four_cycle_im a b c d using 1
  · norm_num

/-- Orientation reversal conjugates the four-cycle invariant. -/
theorem four_cycle_reversal_conj (a b c d : Vec3) :
    (proj d * proj c * proj b * proj a).trace
      = star ((proj a * proj b * proj c * proj d).trace) := by
  unfold proj pauli sigmaX sigmaY sigmaZ
  norm_num [Matrix.mul_apply, Matrix.trace]
  ring

/-- **Exact hairpin lune-phase law.** The hairpin pair resolved through the
equatorial directions (u,v,0) then (u',v',0) has invariant
((u u' + v v') + i (u v' - v u')) / 4: magnitude from the bend factors, phase
exactly the azimuthal angle between the two meridians (half the enclosed lune
solid angle). Polynomial - no normalization hypotheses. -/
theorem hairpin_lune_phase (u v u' v' : ℝ) :
    (proj ez * proj (equator u v) * proj (-ez) * proj (equator u' v')).trace
      = (((u * u' + v * v' : ℝ) : ℂ)
          + Complex.I * ((u * v' - v * u' : ℝ) : ℂ)) / 4 := by
  rw [four_cycle]
  simp +decide [ez, equator, dot, triple]
  ring

/-- The lune law packaged as complex multiplication: the equatorial corner
algebra is literally the complex numbers acting by phase. -/
theorem hairpin_lune_phase_complex (u v u' v' : ℝ) :
    (proj ez * proj (equator u v) * proj (-ez) * proj (equator u' v')).trace
      = star ((u : ℂ) + Complex.I * (v : ℂ))
          * ((u' : ℂ) + Complex.I * (v' : ℂ)) / 4 := by
  convert hairpin_lune_phase u v u' v' using 1
  norm_num [Complex.ext_iff]
  ring

/-- **The checkerboard corner factor i is a quarter-turn lune.** A quarter
turn between the two meridian resolutions gives invariant exactly i/4. -/
theorem quarter_turn_corner :
    (proj ez * proj (equator 1 0) * proj (-ez) * proj (equator 0 1)).trace
      = Complex.I / 4 := by
  convert hairpin_lune_phase 1 0 0 1 using 1
  all_goals norm_num

/-- Wave-1 witness recovered: antipodal meridians (half turn) give -(1/4). -/
theorem half_turn_corner :
    (proj ez * proj (equator 1 0) * proj (-ez) * proj (equator (-1) 0)).trace
      = -(1 / 4) := by
  convert hairpin_lune_phase 1 0 (-1) 0 using 1
  all_goals norm_num

/-- Wave-1 witness recovered: the same-meridian backtrack (zero lune) gives
+(1/4). -/
theorem zero_turn_corner :
    (proj ez * proj (equator 1 0) * proj (-ez) * proj (equator 1 0)).trace
      = 1 / 4 := by
  convert hairpin_lune_phase 1 0 1 0 using 1
  all_goals norm_num

end PhysicsSM.Draft.NullEdge.SpinCornerFourCycle

/-! ## Build-enforced assumption-footprint guards (added at integration) -/

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle_im' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle_im

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle_planar_real' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle_planar_real

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle_reversal_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.four_cycle_reversal_conj

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.hairpin_lune_phase' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.hairpin_lune_phase

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.hairpin_lune_phase_complex' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.hairpin_lune_phase_complex

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.quarter_turn_corner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.quarter_turn_corner

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.half_turn_corner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.half_turn_corner

/-- info: 'PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.zero_turn_corner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.SpinCornerFourCycle.zero_turn_corner


end

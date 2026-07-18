import PhysicsSM.Draft.NullEdge.GateYM.StrongCouplingAreaLaw
import PhysicsSM.Spinor.SpinCornerBargmann

/-!
# Framed Wilson loops inherit the strong-coupling area law

Spiral-layer C3 target T2 (transfer lemma), 2026-07-16. This module is an
HONEST COMPOSITION layer, not new analysis: it composes the landed
strong-coupling area law (`StrongCouplingAreaLaw.wilson_area_law`, whose
character-expansion factorization input is an explicit hypothesis) with a
deterministic spectator framing scalar, and proves the two structural
facts of the C3 bridge:

1. A fixed framing factor `S` with `‖S‖ ≤ 1` cannot degrade the area law
   (`framed_wilson_area_law`), and the sharp bound keeps the SAME string
   tension `σ_R` with `‖S‖` as a pure area-independent prefactor
   (`framed_wilson_area_law_sharp`, `framed_wilson_area_law_strict`).
   In the spiral-layer reading, `S` is the spin-corner factor of the
   loop's direction sequence: smooth-loop framing costs phase and an
   area-independent constant, never string tension.
2. Constant runs of a direction contribute NO additional corner factors:
   the spin-coherent projector of a unit direction is idempotent
   (`proj_idem`), so its `k`-fold power collapses (`proj_pow_collapse`).
   Consequently the direction-sequence factor of an axis-aligned
   `a x b` rectangle equals the four-corner square factor for every
   `a, b >= 1` (`rectangle_sequence_collapse`) - the corner cost depends
   on the corner set, not the perimeter length. The exact square value
   (-1/4 at the equator, the hemisphere Berry sign) is the wave-7
   package's statement and plugs in at its integration; this module
   deliberately keeps `S` abstract.

Claim boundary: finite algebraic composition on the landed lattice
interface. No new expectation is constructed, no gauge average is
performed (the factorization stays the modeled hypothesis it always
was), and no continuum, confinement, or physical-QCD claim is made.

Provenance: program-internal composition of
`GateYM.StrongCouplingAreaLaw` (character-coefficient dominance
repackaging, OS-regime provenance recorded there) and the wave-1 spiral
corner calculus (`PhysicsSM/Spinor/SpinCornerBargmann.lean`, promoted 2026-07-16).
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FramedAreaLawTransfer

open StrongCouplingAreaLaw
open PhysicsSM.Spinor.SpinCornerBargmann

variable {G : Type} [Group G] [Fintype G] {n : ℕ}

/-- **Framing cannot degrade the area law.** If the unframed Wilson value
obeys the factorization hypothesis, any deterministic framing scalar with
`‖S‖ ≤ 1` leaves the exponential area bound intact at the same string
tension. -/
theorem framed_wilson_area_law (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hne : gammaR beta rho R ≠ 0) (A : ℕ) (wloop S : ℂ)
    (hS : ‖S‖ ≤ 1)
    (hfact : ‖wloop‖ ≤ ‖gammaR beta rho R‖ ^ A) :
    ‖S * wloop‖ ≤ Real.exp (-(sigmaR beta rho R) * A) := by
  have hw := wilson_area_law beta rho R hne A wloop hfact
  calc ‖S * wloop‖ = ‖S‖ * ‖wloop‖ := norm_mul S wloop
    _ ≤ 1 * ‖wloop‖ := by
        exact mul_le_mul_of_nonneg_right hS (norm_nonneg wloop)
    _ = ‖wloop‖ := one_mul _
    _ ≤ Real.exp (-(sigmaR beta rho R) * A) := hw

/-- **Sharp framed bound: the corner cost is a pure prefactor.** The
framed Wilson value is bounded by `‖S‖ · exp(-σ_R · A)`: the string
tension is untouched and the framing contributes an area-independent
constant. -/
theorem framed_wilson_area_law_sharp (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hne : gammaR beta rho R ≠ 0) (A : ℕ) (wloop S : ℂ)
    (hfact : ‖wloop‖ ≤ ‖gammaR beta rho R‖ ^ A) :
    ‖S * wloop‖ ≤ ‖S‖ * Real.exp (-(sigmaR beta rho R) * A) := by
  have hw := wilson_area_law beta rho R hne A wloop hfact
  calc ‖S * wloop‖ = ‖S‖ * ‖wloop‖ := norm_mul S wloop
    _ ≤ ‖S‖ * Real.exp (-(sigmaR beta rho R) * A) :=
        mul_le_mul_of_nonneg_left hw (norm_nonneg S)

/-- **Strict-rate framed form.** Under the strict strong-coupling
hypotheses the framed loop decays at the genuinely positive unframed
string tension, with the framing as prefactor. -/
theorem framed_wilson_area_law_strict (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hdim : 0 < (R.character 1).re)
    (hstrict : ‖charCoeff beta rho R‖ < (R.character 1).re * trivCoeff beta rho)
    (hne : gammaR beta rho R ≠ 0) (A : ℕ) (wloop S : ℂ)
    (hfact : ‖wloop‖ ≤ ‖gammaR beta rho R‖ ^ A) :
    ‖S * wloop‖ ≤ ‖S‖ * Real.exp (-(sigmaR beta rho R) * A)
      ∧ 0 < sigmaR beta rho R :=
  ⟨framed_wilson_area_law_sharp beta rho R hne A wloop S hfact,
   sigmaR_pos beta rho R hdim hstrict hne⟩

/-- **Unit-direction corner matrices are idempotent.** From the wave-1
Pauli square: `(a.sigma)^2 = (a.a) • 1`, so at `a.a = 1` the projector
`(1 + a.sigma)/2` squares to itself. -/
theorem proj_idem (a : Vec3) (h : dot a a = 1) :
    proj a * proj a = proj a := by
  unfold proj
  have hsq := pauli_sq a
  rw [h] at hsq
  rw [smul_mul_smul_comm]
  rw [mul_add, add_mul, add_mul, one_mul, mul_one, hsq]
  norm_num
  module

/-- **Constant runs collapse.** A `k`-fold repeated unit direction
contributes exactly one projector for every `k ≥ 1`: rewalking an edge
direction adds no corner factor. -/
theorem proj_pow_collapse (a : Vec3) (h : dot a a = 1) :
    ∀ k : ℕ, 1 ≤ k → proj a ^ k = proj a := by
  intro k hk
  induction k with
  | zero => omega
  | succ m ih =>
    rcases Nat.eq_or_lt_of_le hk with heq | hlt
    · simp [← heq]
    · have hm : 1 ≤ m := Nat.lt_succ_iff.mp hlt
      rw [pow_succ, ih hm, proj_idem a h]

/-- **Rectangle sequences collapse to the corner square.** The
direction-sequence factor of an axis-aligned rectangle with side runs
`p, q, r, s >= 1` along unit directions `a, b, c, d` equals the
four-corner square factor: the corner cost depends on the corner set,
not the side lengths. The exact square value is supplied by the wave-7
cap-square package at its integration. -/
theorem rectangle_sequence_collapse (a b c d : Vec3)
    (ha : dot a a = 1) (hb : dot b b = 1)
    (hc : dot c c = 1) (hd : dot d d = 1)
    (p q r s : ℕ) (hp : 1 ≤ p) (hq : 1 ≤ q) (hr : 1 ≤ r) (hs : 1 ≤ s) :
    (proj a ^ p * proj b ^ q * proj c ^ r * proj d ^ s).trace
      = (proj a * proj b * proj c * proj d).trace := by
  rw [proj_pow_collapse a ha p hp, proj_pow_collapse b hb q hq,
    proj_pow_collapse c hc r hr, proj_pow_collapse d hd s hs]

/-! ## The exact rectangle-framed area law (wave-7 connector)

The wave-7 cap-square package (`CapSquareBerryAristotle`) proves the
equatorial square value -1/4 in its own namespace; the lemma below
restates that exact value for THIS module's corner conventions (the
definitions are identical spin-coherent projectors), and the corollary
combines it with the collapse layer and the sharp framed bound: every
axis-aligned rectangle framing, of any side lengths, costs exactly the
factor 1/4 in magnitude and inherits the area law at the unchanged
string tension. -/

/-- Westward equatorial direction `(-1, 0, 0)`. -/
def exm : Vec3 := ![-1, 0, 0]

/-- Southward equatorial direction `(0, -1, 0)`. -/
def eym : Vec3 := ![0, -1, 0]

/-- The equatorial four-corner square has spin factor exactly -1/4: the
hemisphere Berry sign (wave-7 `equator_square_invariant`, restated for
this module's conventions). -/
theorem equator_square_trace :
    (proj ex * proj ey * proj exm * proj eym).trace = -(1 / 4) := by
  unfold proj pauli
  norm_num [ex, ey, exm, eym, sigmaX, sigmaY, sigmaZ,
    Matrix.trace_fin_two, Matrix.mul_apply, Fin.sum_univ_succ,
    Matrix.one_apply, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.vecHead, Matrix.vecTail,
    Fin.succ_zero_eq_one, Complex.ext_iff]

/-- Unit hypotheses for the four equatorial directions. -/
theorem equator_units :
    dot ex ex = 1 ∧ dot ey ey = 1 ∧ dot exm exm = 1
      ∧ dot eym eym = 1 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;>
    norm_num [dot, ex, ey, exm, eym, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.vecHead,
      Matrix.vecTail]

/-- **Exact rectangle-framed area law.** For any axis-aligned rectangle
with side runs `p, q, r, s >= 1`, the framed Wilson value inherits the
strong-coupling area law at the SAME string tension with the exact
side-length-independent corner constant `1/4`. -/
theorem framed_rectangle_area_law (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G)
    (hne : gammaR beta rho R ≠ 0) (A : ℕ) (wloop : ℂ)
    (hfact : ‖wloop‖ ≤ ‖gammaR beta rho R‖ ^ A)
    (p q r s : ℕ) (hp : 1 ≤ p) (hq : 1 ≤ q) (hr : 1 ≤ r) (hs : 1 ≤ s) :
    ‖(proj ex ^ p * proj ey ^ q * proj exm ^ r * proj eym ^ s).trace
        * wloop‖
      ≤ (1 / 4) * Real.exp (-(sigmaR beta rho R) * A) := by
  obtain ⟨hx, hy, hnx, hny⟩ := equator_units
  have hcollapse := rectangle_sequence_collapse ex ey exm eym
    hx hy hnx hny p q r s hp hq hr hs
  rw [hcollapse, equator_square_trace]
  have hsharp := framed_wilson_area_law_sharp beta rho R hne A wloop
    (-(1 / 4 : ℂ)) hfact
  calc ‖(-(1 / 4 : ℂ)) * wloop‖
      ≤ ‖(-(1 / 4 : ℂ))‖ * Real.exp (-(sigmaR beta rho R) * A) := hsharp
    _ = (1 / 4) * Real.exp (-(sigmaR beta rho R) * A) := by norm_num

end FramedAreaLawTransfer
end GateYM
end NullEdge
end Draft
end PhysicsSM

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.framed_wilson_area_law' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.framed_wilson_area_law

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.framed_wilson_area_law_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.framed_wilson_area_law_sharp

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.framed_wilson_area_law_strict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.framed_wilson_area_law_strict

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.proj_idem' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.proj_idem

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.proj_pow_collapse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.proj_pow_collapse

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.rectangle_sequence_collapse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.rectangle_sequence_collapse

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.equator_square_trace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.equator_square_trace

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.framed_rectangle_area_law' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.FramedAreaLawTransfer.framed_rectangle_area_law

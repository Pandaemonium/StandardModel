import Mathlib

/-!
# The blindness pattern is THREE phenomena, not one (Opus, verified 4a2bc7d3)

Adversarial test of my own cross-lane synthesis claim that five program results are
instances of a single 'blindness' theorem. VERDICT: NOT one theorem. The sharp
common statement is ORBIT-QUOTIENT FACTORIZATION - a functional is invariant exactly
when it factors through the orbit quotient (constant-on-orbits and the
non-invariance contrapositive also proved) - but it covers only part of the list.

THE CORRECT THREE-WAY TAXONOMY:
1. ORBIT INVARIANCE / quotient factorization: the crossing-orientation blindness,
   the Wilson-plaquette CENTER blindness, the corrected vacuum-shift blindness, and
   the spectrum-blindness PART of the mass result.
2. ORBIT RICHNESS / ATTAINABILITY: the extreme-weight part of the mass result -
   attaining weights 1 and 0 at fixed spectrum needs a genuine attainability
   argument, NOT merely invariance. (A Fin 2 model proves equal characteristic
   polynomial with weights 1 and 0, and non-invariance of the fixed-coordinate
   weight.)
3. NOT AN ORBIT PHENOMENON AT ALL: the independence of gauge invariance from
   first-excited overlap. Two INVARIANT operators with overlaps 0 and 1 are
   exhibited and proved NOT to lie in the same orbit - so this is independence of
   invariant-sector membership from another functional, a different mechanism.

TWO SHARPENINGS of my own table: the RAW trace is NOT shift-blind (the
traceless/centered PROJECTION is the invariant object), and the center-blindness
statement is correctly limited to a ZERO-CENTER-CHARGE loop under the specified
center action.

Consequence for the synthesis: state the pattern as a three-way taxonomy with one
genuine shared theorem, not as five instances of one idea.

Provenance: verified at pin from task 087aae71. Standard three. Grade M, [orig]. -/

open scoped BigOperators
open scoped Classical

set_option autoImplicit false

namespace Blindness

/-! ## The general orbit theorem -/

variable {G X Y Z : Type*} [Group G] [MulAction G X]

/-- A functional is invariant when it is constant after every group action. -/
def Invariant (G : Type*) [SMul G X] (F : X → Y) : Prop :=
  ∀ (g : G) (x : X), F (g • x) = F x

/-- The elementary blindness statement: an invariant cannot separate two points in one orbit. -/
theorem invariant_of_same_orbit (F : X → Y) (hF : Invariant G F)
    {x x' : X} (h : (MulAction.orbitRel G X).r x x') : F x = F x' := by
  cases h ; aesop

/-- An invariant descends canonically to the orbit quotient. -/
def descendToOrbits (F : X → Y) (hF : Invariant G F) :
    MulAction.orbitRel.Quotient G X → Y :=
  Quotient.lift F (by
    intro x x' h
    exact invariant_of_same_orbit F hF h)

@[simp] theorem descendToOrbits_mk (F : X → Y) (hF : Invariant G F) (x : X) :
    descendToOrbits F hF (Quotient.mk'' x) = F x := by
  rfl

/-- Contrapositive form: a functional which separates an acted pair is not invariant. -/
theorem not_invariant_of_separates (Q : X → Y) {g : G} {x : X}
    (h : Q (g • x) ≠ Q x) : ¬ Invariant G Q := by
  exact fun h' => h ( h' g x )

/-- Every function on the orbit quotient pulls back to an invariant. -/
theorem invariant_quotient_pullback (q : MulAction.orbitRel.Quotient G X → Y) :
    Invariant G (fun x => q (Quotient.mk'' x)) := by
  intro g x
  refine congr_arg q (Quotient.sound ?_)
  exact ⟨g, rfl⟩

/-
Sharp factorization form: invariants are exactly pullbacks from the orbit quotient.
-/
theorem invariant_iff_factors_through_orbits (F : X → Y) :
    Invariant G F ↔
      ∃ q : MulAction.orbitRel.Quotient G X → Y,
        ∀ x, q (Quotient.mk'' x) = F x := by
  constructor
  · intro hF
    exact ⟨descendToOrbits F hF, fun x => rfl⟩
  · rintro ⟨q, hq⟩ g x
    rw [← hq, ← hq]
    exact congr_arg q (Quotient.sound ⟨g, rfl⟩)

/-! ## (a): fixed spectrum versus a fixed coordinate's spectral weight

For a rank-one spectral projector, its `(0,0)` entry is the weight of the fixed
coordinate vector in that eigenspace.  Relabelling the eigenbasis preserves the
characteristic polynomial but can exchange weights 1 and 0.
-/

namespace SpectrumWeight

abbrev Idx := Fin 2
abbrev Mat := Matrix Idx Idx ℝ
abbrev Config := Equiv.Perm Idx

noncomputable def projector : Mat := Matrix.diagonal ![1, 0]

noncomputable def matrixOf (σ : Config) : Mat := Matrix.reindex σ σ projector

noncomputable def spectrum (σ : Config) : Polynomial ℝ := (matrixOf σ).charpoly

noncomputable def weight (σ : Config) : ℝ := matrixOf σ 0 0

noncomputable def swap : Config := Equiv.swap 0 1

/-
Spectrum is invariant under relabelling (indeed it is constant here).
-/
theorem spectrum_invariant : Invariant Config spectrum := by
  intro σ x; simp +decide [ spectrum, matrixOf ] ;
  unfold projector; fin_cases σ <;> fin_cases x <;> simp +decide [Matrix.charpoly] ;
  · ring;
  · ring

/-
The two extreme weights occur at the same characteristic polynomial.
-/
theorem both_weight_extremes :
    spectrum (1 : Config) = spectrum swap ∧
    weight (1 : Config) = 1 ∧ weight swap = 0 := by
  unfold spectrum weight;
  unfold matrixOf;
  unfold projector; norm_num [ Matrix.charpoly, Matrix.det_fin_two ] ;
  erw [ show ( Equiv.swap 0 1 : Equiv.Perm ( Fin 2 ) ).symm 0 = 1 from rfl, show ( Equiv.swap 0 1 : Equiv.Perm ( Fin 2 ) ).symm 1 = 0 from rfl ] ; norm_num;
  ring

/-
Hence the fixed-coordinate weight is not invariant under the same action.
-/
theorem weight_not_invariant : ¬ Invariant Config weight := by
  unfold Invariant;
  simp +zetaDelta at *;
  refine' ⟨ Equiv.swap 0 1, 1, _ ⟩ ; unfold weight ;
  unfold matrixOf; norm_num [ projector ] ;

end SpectrumWeight

/-! ## (b): invariance and overlap are logically independent -/

namespace GaugeOverlap

abbrev Gauge := Units ℤ
abbrev Operator := ℤ × ℤ

instance : SMul Gauge Operator where
  smul u p := ((u : ℤ) * p.1, p.2)

instance : MulAction Gauge Operator where
  one_smul p := by
    change (((1 : Gauge) : ℤ) * p.1, p.2) = p
    simp
  mul_smul u v p := by
    change ((((u * v : Gauge) : ℤ) * p.1, p.2)) =
      ((u : ℤ) * ((v : ℤ) * p.1), p.2)
    simp [mul_assoc]

/-- Being a gauge-invariant operator means being fixed by the gauge action. -/
def GaugeInvariant (p : Operator) : Prop := ∀ u : Gauge, u • p = p

def overlap (p : Operator) : ℤ := p.2

theorem invariant_operators_can_have_zero_or_nonzero_overlap :
    GaugeInvariant (0, 0) ∧ GaugeInvariant (0, 1) ∧
    overlap (0, 0) = 0 ∧ overlap (0, 1) = 1 := by
  simp +decide [GaugeInvariant]

/-- These two invariant operators are not in one orbit, so orbit blindness does not compare them. -/
theorem overlap_examples_not_same_orbit :
    ¬ (MulAction.orbitRel Gauge Operator).r (0, 0) (0, 1) := by
  unfold MulAction.orbitRel
  simp +decide [MulAction.orbit]

end GaugeOverlap

/-! ## (c): unsigned versus signed crossing number -/

namespace Crossing

abbrev OrientationChange := Units ℤ
abbrev CrossingNumber := ℤ

def unsigned : CrossingNumber → ℕ := Int.natAbs

def signed : CrossingNumber → ℤ := id

theorem unsigned_invariant : Invariant OrientationChange unsigned := by
  intro u x
  cases' Int.units_eq_one_or u with h h <;> simp +decide [h]
  exact Int.natAbs_neg x

theorem signed_not_invariant : ¬ Invariant OrientationChange signed := by
  exact fun h => absurd (h (-1) 1) (by decide)

end Crossing

/-! ## (d): cancellation of a central factor around a contractible loop -/

namespace CenterLoop

variable (H : Type*) [Group H]

abbrev CenterGauge := Subgroup.center H
abbrev TwoEdges := H × H

/-- A two-edge presentation of a zero-center-charge loop holonomy. -/
def loopHolonomy (p : TwoEdges H) : H := p.1 * p.2⁻¹

theorem loopHolonomy_invariant :
    Invariant (CenterGauge H) (loopHolonomy H) := by
  intro z p
  simp +decide [loopHolonomy, Subgroup.smul_def]
  simp +decide [← mul_assoc]
  simp +decide [mul_inv_eq_iff_eq_mul, Subgroup.mem_center_iff.mp z.2]
  simp +decide [mul_assoc]

end CenterLoop

/-! ## (e): centering is blind to uniform additive shifts; raw trace is not -/

namespace UniformShift

abbrev Shift := Multiplicative ℝ
abbrev Config := Fin 2 → ℝ

instance : SMul Shift Config where
  smul c x := fun i => c.toAdd + x i

instance : MulAction Shift Config where
  one_smul x := by ext i; simp
  mul_smul a b x := by
    ext i
    change (a.toAdd + b.toAdd) + x i = a.toAdd + (b.toAdd + x i)
    ring

/-- Traceless/mean-zero projection in dimension two. -/
noncomputable def centered (x : Config) : Config :=
  fun i => x i - (x 0 + x 1) / 2

/-- The order-zero sum, i.e. the trace of the corresponding diagonal matrix. -/
def rawTrace (x : Config) : ℝ := x 0 + x 1

theorem centered_invariant : Invariant Shift centered := by
  intro c x
  ext i
  exact (by
    convert sub_eq_sub_iff_add_eq_add.mpr _ using 1
    fin_cases i <;>
      erw [show (c • x) 0 = c.toAdd + x 0 from rfl,
        show (c • x) 1 = c.toAdd + x 1 from rfl] <;> ring!)

/-- Literal trace detects a nonzero uniform shift, so it is not shift-blind. -/
theorem rawTrace_not_invariant : ¬ Invariant Shift rawTrace := by
  intro h
  have h' := h (Multiplicative.ofAdd 1) (fun _ => 0)
  norm_num at h'
  unfold rawTrace at h'
  aesop

end UniformShift

end Blindness

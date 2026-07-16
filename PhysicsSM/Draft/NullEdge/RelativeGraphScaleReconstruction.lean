import PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction

/-!
# Density-free relative scale reconstruction from graph counts

`BareGraphScaleReconstruction` proves that a bare relation cannot select an
absolute scale and that converting event number to absolute volume requires a
positive density calibration.  This module sharpens the constructive side:
when the same unknown density applies to two regions, it cancels from their
relative four-dimensional Weyl scale.

For positive counts `n,n0` and nondegenerate conformal coframe
representatives `e,e0`, define

```text
r^4 = n * volume(e0) / (n0 * volume(e)).
```

Then every common positive density gives

```text
omega(density,n,e) = r * omega(density,n0,e0).
```

Consequently one positive anchor scale determines the complete relative Weyl
profile, and the reconstructed coframe-volume ratio is exactly `n/n0`.  The
relative factor is unique among positive factors with that volume ratio.

## Scope boundary

This is a finite four-dimensional order-number reconstruction identity.  It
does not derive the regions, counts, common-density hypothesis, conformal
coframe representatives, dimension four, manifoldlikeness, or the remaining
global unit from a bare graph.  Its gain is precise: a separate density value
is not needed at every region; only one global scale anchor remains after the
relative profile is fixed.

Provenance: clean-room algebraic consequence of the count-volume and positive
fourth-root reconstruction in `BareGraphScaleReconstruction`.  The physical
interpretation follows the causal-set order-plus-number split. Claim grade:
`M [orig]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction

open PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction

/-- Positive relative Weyl factor inferred from two event counts and two
conformal coframe representative volumes. -/
def relativeCountScale
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4) : Real :=
  fourthRoot
    (((n : Real) * coframeVolume e0) /
      ((n0 : Real) * coframeVolume e))

/-- A positive common anchor fixes the remaining global scale unit. -/
def anchorRelativeScale
    (anchor : Real) (n : Nat) (e : Coframe4)
    (n0 : Nat) (e0 : Coframe4) : Real :=
  relativeCountScale n e n0 e0 * anchor

/-- Relative area factor induced by the four-dimensional Weyl factor.  This is
the relative normalization inherited by plaquette areas in G4. -/
def relativeAreaScale
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4) : Real :=
  relativeCountScale n e n0 e0 ^ 2

/-! ## Relabeling covariance of the relative profile -/

variable {V : Type*}

/-- A local event-count field is intrinsic when every automorphism of the bare
relation preserves it pointwise. -/
def CountInvariant
    (R : V → V → Prop) (count : V → Nat) : Prop :=
  ∀ (T : V ≃ V), RelationAutomorphism R T → ∀ x, count (T x) = count x

/-- Relative Weyl profile anchored at one vertex, expressed using a count field
and the positive base-volume field of conformal representatives. -/
def relativeScaleProfile
    (count : V → Nat) (baseVolume : V → Real) (anchor : V) (x : V) : Real :=
  fourthRoot
    (((count x : Nat) : Real) * baseVolume anchor /
      (((count anchor : Nat) : Real) * baseVolume x))

/-- The profile definition specializes exactly to `relativeCountScale` when
the base-volume field is supplied by conformal coframe representatives. -/
theorem relativeScaleProfile_eq_relativeCountScale
    (count : V → Nat) (coframe : V → Coframe4) (anchor x : V) :
    relativeScaleProfile count (fun y => coframeVolume (coframe y)) anchor x =
      relativeCountScale (count x) (coframe x) (count anchor)
        (coframe anchor) := by
  rfl

/-- Intrinsic count and representative-volume fields produce a profile
invariant under automorphisms acting on the evaluation vertex while the
chosen anchor is held fixed. The result uses invariance of both fields, so the
anchor-dependent numerator and denominator are unchanged constants. This is
fixed-anchor invariance, not the distinct covariance statement obtained by
transporting the anchor together with the evaluation vertex. -/
theorem relativeScaleProfile_graphInvariant
    (R : V → V → Prop) (count : V → Nat) (baseVolume : V → Real) (anchor : V)
    (hcount : CountInvariant R count)
    (hvolume : GraphInvariant R baseVolume) :
    GraphInvariant R (relativeScaleProfile count baseVolume anchor) := by
  intro T hT x
  unfold relativeScaleProfile
  rw [hcount T hT x, hvolume T hT x]

/-- Simultaneously transporting the anchor and evaluation vertex by a graph
automorphism leaves the relative profile unchanged. This is the covariance
statement distinct from fixed-anchor `GraphInvariant`. -/
theorem relativeScaleProfile_anchor_covariant
    (R : V → V → Prop) (count : V → Nat) (baseVolume : V → Real)
    (anchor x : V) (T : V ≃ V) (hT : RelationAutomorphism R T)
    (hcount : CountInvariant R count)
    (hvolume : GraphInvariant R baseVolume) :
    relativeScaleProfile count baseVolume (T anchor) (T x) =
      relativeScaleProfile count baseVolume anchor x := by
  unfold relativeScaleProfile
  rw [hcount T hT x, hcount T hT anchor,
    hvolume T hT x, hvolume T hT anchor]

/-- On a vertex-transitive bare relation, every relative profile built only
from invariant count and base-volume fields is constant.  An inhomogeneous
Weyl profile therefore requires relational inhomogeneity or additional
symmetry-breaking data. -/
theorem relativeScaleProfile_constant_of_vertexTransitive
    (R : V → V → Prop) (count : V → Nat) (baseVolume : V → Real) (anchor : V)
    (htrans : VertexTransitive R)
    (hcount : CountInvariant R count)
    (hvolume : GraphInvariant R baseVolume) :
    ∀ x y,
      relativeScaleProfile count baseVolume anchor x =
        relativeScaleProfile count baseVolume anchor y := by
  exact graphInvariant_constant_of_vertexTransitive R _ htrans
    (relativeScaleProfile_graphInvariant R count baseVolume anchor
      hcount hvolume)

/-- Positive counts and representative volumes give a positive relative
factor. -/
theorem relativeCountScale_pos
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0) :
    0 < relativeCountScale n e n0 e0 := by
  unfold relativeCountScale
  apply fourthRoot_pos
  exact div_pos
    (mul_pos (Nat.cast_pos.mpr hn) he0)
    (mul_pos (Nat.cast_pos.mpr hn0) he)

/-- The fourth power of the relative factor is the exact count/base-volume
ratio used in its definition. -/
theorem relativeCountScale_pow_four
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0) :
    relativeCountScale n e n0 e0 ^ 4 =
      ((n : Real) * coframeVolume e0) /
        ((n0 : Real) * coframeVolume e) := by
  unfold relativeCountScale
  apply fourthRoot_pow_four
  exact (div_pos
    (mul_pos (Nat.cast_pos.mpr hn) he0)
    (mul_pos (Nat.cast_pos.mpr hn0) he)).le

/-- The square of the relative area factor is the exact count/base-volume
ratio. This is the four-dimensional relation `area^2 = volume` for isotropic
Weyl weights, not a claim that arbitrary geometric areas are determined by
volume alone. -/
theorem relativeAreaScale_sq
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0) :
    relativeAreaScale n e n0 e0 ^ 2 =
      ((n : Real) * coframeVolume e0) /
        ((n0 : Real) * coframeVolume e) := by
  unfold relativeAreaScale
  rw [← pow_mul,
    show 2 * 2 = 4 by norm_num,
    relativeCountScale_pow_four n e n0 e0 hn hn0 he he0]

/-- The fourth power of a count-calibrated scale is its target/base-volume
ratio. -/
theorem countCalibratedScale_pow_four
    (density : Real) (n : Nat) (e : Coframe4)
    (hdensity : 0 < density) (hn : 0 < n)
    (he : 0 < coframeVolume e) :
    countCalibratedScale density n e ^ 4 =
      countingVolume density n / coframeVolume e := by
  unfold countCalibratedScale calibratedConformalScale
  apply fourthRoot_pow_four
  exact (div_pos (countingVolume_pos hdensity hn) he).le

/-- Positive density, count, and representative volume give a positive
count-calibrated scale. -/
theorem countCalibratedScale_pos
    (density : Real) (n : Nat) (e : Coframe4)
    (hdensity : 0 < density) (hn : 0 < n)
    (he : 0 < coframeVolume e) :
    0 < countCalibratedScale density n e := by
  unfold countCalibratedScale
  exact calibratedConformalScale_pos e _ he
    (countingVolume_pos hdensity hn)

/-- **Common-density cancellation.** For every positive common density, the
calibrated scale at one region is the density-free relative factor times the
calibrated scale at the anchor region. -/
theorem countCalibratedScale_eq_relative_mul_anchor
    (density : Real)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hdensity : 0 < density) (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0) :
    countCalibratedScale density n e =
      relativeCountScale n e n0 e0 *
        countCalibratedScale density n0 e0 := by
  have hleft := countCalibratedScale_pos density n e hdensity hn he
  have hrelative := relativeCountScale_pos n e n0 e0 hn hn0 he he0
  have hanchor := countCalibratedScale_pos density n0 e0 hdensity hn0 he0
  apply (pow_left_inj₀ hleft.le (mul_pos hrelative hanchor).le
    (by norm_num : (4 : Nat) ≠ 0)).mp
  rw [countCalibratedScale_pow_four density n e hdensity hn he,
    mul_pow,
    relativeCountScale_pow_four n e n0 e0 hn hn0 he he0,
    countCalibratedScale_pow_four density n0 e0 hdensity hn0 he0]
  unfold countingVolume
  field_simp [hdensity.ne', Nat.cast_ne_zero.mpr hn.ne',
    Nat.cast_ne_zero.mpr hn0.ne', he.ne', he0.ne']

/-- Squaring common-density cancellation gives the density-free relative area
normalization needed by a conformally scaled plaquette family. -/
theorem countCalibratedAreaScale_eq_relative_mul_anchor
    (density : Real)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hdensity : 0 < density) (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0) :
    countCalibratedScale density n e ^ 2 =
      relativeAreaScale n e n0 e0 *
        countCalibratedScale density n0 e0 ^ 2 := by
  rw [countCalibratedScale_eq_relative_mul_anchor density n e n0 e0
    hdensity hn hn0 he he0]
  unfold relativeAreaScale
  ring

/-- The relative scale from a positive region to itself is one. -/
theorem relativeCountScale_self
    (n : Nat) (e : Coframe4) (hn : 0 < n) (he : 0 < coframeVolume e) :
    relativeCountScale n e n e = 1 := by
  unfold relativeCountScale
  rw [div_self (mul_ne_zero (Nat.cast_ne_zero.mpr hn.ne') he.ne')]
  simp [fourthRoot]

/-- **Anchor-overlap cocycle.** Changing from anchor region `0` to overlap
region `1` and then to the target gives the same positive relative Weyl factor
as calibrating the target directly against region `0`. -/
theorem relativeCountScale_anchor_cocycle
    (n : Nat) (e : Coframe4)
    (n1 : Nat) (e1 : Coframe4)
    (n0 : Nat) (e0 : Coframe4)
    (hn : 0 < n) (hn1 : 0 < n1) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e)
    (he1 : 0 < coframeVolume e1)
    (he0 : 0 < coframeVolume e0) :
    relativeCountScale n e n0 e0 =
      relativeCountScale n e n1 e1 *
        relativeCountScale n1 e1 n0 e0 := by
  have hdirect := countCalibratedScale_eq_relative_mul_anchor
    1 n e n0 e0 one_pos hn hn0 he he0
  have hto1 := countCalibratedScale_eq_relative_mul_anchor
    1 n e n1 e1 one_pos hn hn1 he he1
  have h1to0 := countCalibratedScale_eq_relative_mul_anchor
    1 n1 e1 n0 e0 one_pos hn1 hn0 he1 he0
  have hanchor : countCalibratedScale 1 n0 e0 ≠ 0 :=
    (countCalibratedScale_pos 1 n0 e0 one_pos hn0 he0).ne'
  apply mul_right_cancel₀ hanchor
  calc
    relativeCountScale n e n0 e0 * countCalibratedScale 1 n0 e0 =
        countCalibratedScale 1 n e := hdirect.symm
    _ = relativeCountScale n e n1 e1 *
        countCalibratedScale 1 n1 e1 := hto1
    _ = relativeCountScale n e n1 e1 *
        (relativeCountScale n1 e1 n0 e0 *
          countCalibratedScale 1 n0 e0) := by rw [h1to0]
    _ = (relativeCountScale n e n1 e1 *
        relativeCountScale n1 e1 n0 e0) *
          countCalibratedScale 1 n0 e0 := by ring

/-- Reversing the two positive anchor regions gives the multiplicative inverse
transition, expressed without division. -/
theorem relativeCountScale_mul_reverse
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0) :
    relativeCountScale n e n0 e0 *
      relativeCountScale n0 e0 n e = 1 := by
  have h := relativeCountScale_anchor_cocycle
    n e n0 e0 n e hn hn0 hn he he0 he
  rw [relativeCountScale_self n e hn he] at h
  exact h.symm

/-- Squaring the anchor-overlap law gives the corresponding transition law for
the relative plaquette-area weight. -/
theorem relativeAreaScale_anchor_cocycle
    (n : Nat) (e : Coframe4)
    (n1 : Nat) (e1 : Coframe4)
    (n0 : Nat) (e0 : Coframe4)
    (hn : 0 < n) (hn1 : 0 < n1) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e)
    (he1 : 0 < coframeVolume e1)
    (he0 : 0 < coframeVolume e0) :
    relativeAreaScale n e n0 e0 =
      relativeAreaScale n e n1 e1 *
        relativeAreaScale n1 e1 n0 e0 := by
  unfold relativeAreaScale
  rw [relativeCountScale_anchor_cocycle
    n e n1 e1 n0 e0 hn hn1 hn0 he he1 he0]
  ring

/-- The ratio of two count-calibrated scales is independent of which positive
common density is used. -/
theorem calibratedScale_ratio_density_independent
    (density1 density2 : Real)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hdensity1 : 0 < density1) (hdensity2 : 0 < density2)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0) :
    countCalibratedScale density1 n e /
        countCalibratedScale density1 n0 e0 =
      countCalibratedScale density2 n e /
        countCalibratedScale density2 n0 e0 := by
  rw [countCalibratedScale_eq_relative_mul_anchor density1 n e n0 e0
      hdensity1 hn hn0 he he0,
    countCalibratedScale_eq_relative_mul_anchor density2 n e n0 e0
      hdensity2 hn hn0 he he0]
  field_simp [
    (countCalibratedScale_pos density1 n0 e0 hdensity1 hn0 he0).ne',
    (countCalibratedScale_pos density2 n0 e0 hdensity2 hn0 he0).ne']

/-- If an anchor agrees with any absolute density calibration, the relative
construction recovers every other scale from counts and representative
volumes. -/
theorem anchorRelativeScale_recovers_calibrated
    (density anchor : Real)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hdensity : 0 < density) (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0)
    (hanchor : anchor = countCalibratedScale density n0 e0) :
    anchorRelativeScale anchor n e n0 e0 =
      countCalibratedScale density n e := by
  unfold anchorRelativeScale
  rw [hanchor]
  exact (countCalibratedScale_eq_relative_mul_anchor density n e n0 e0
    hdensity hn hn0 he he0).symm

/-- **Relative order-number reconstruction.** For any positive global anchor,
the reconstructed coframe-volume ratio is exactly the event-count ratio. -/
theorem anchorRelativeScale_volume_ratio
    (anchor : Real)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hanchor : 0 < anchor) (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0) :
    coframeVolume
          (conformalCoframe (anchorRelativeScale anchor n e n0 e0) e) /
        coframeVolume (conformalCoframe anchor e0) =
      (n : Real) / (n0 : Real) := by
  have hrelative := relativeCountScale_pos n e n0 e0 hn hn0 he he0
  unfold anchorRelativeScale
  rw [coframeVolume_conformalCoframe _ _
      (mul_pos hrelative hanchor).le,
    coframeVolume_conformalCoframe anchor e0 hanchor.le]
  rw [mul_pow,
    relativeCountScale_pow_four n e n0 e0 hn hn0 he he0]
  field_simp [hanchor.ne', Nat.cast_ne_zero.mpr hn.ne',
    Nat.cast_ne_zero.mpr hn0.ne', he.ne', he0.ne']

/-- A positive local scale with the prescribed count ratio relative to a
positive anchor is uniquely the relative reconstruction. -/
theorem positive_anchorRelativeScale_unique
    (anchor candidate : Real)
    (n : Nat) (e : Coframe4) (n0 : Nat) (e0 : Coframe4)
    (hanchor : 0 < anchor) (hcandidate : 0 < candidate)
    (hn : 0 < n) (hn0 : 0 < n0)
    (he : 0 < coframeVolume e) (he0 : 0 < coframeVolume e0)
    (hratio :
      coframeVolume (conformalCoframe candidate e) /
          coframeVolume (conformalCoframe anchor e0) =
        (n : Real) / (n0 : Real)) :
    candidate = anchorRelativeScale anchor n e n0 e0 := by
  have hreconstructed : 0 < anchorRelativeScale anchor n e n0 e0 :=
    mul_pos (relativeCountScale_pos n e n0 e0 hn hn0 he he0) hanchor
  apply (pow_left_inj₀ hcandidate.le hreconstructed.le
    (by norm_num : (4 : Nat) ≠ 0)).mp
  rw [coframeVolume_conformalCoframe candidate e hcandidate.le,
    coframeVolume_conformalCoframe anchor e0 hanchor.le] at hratio
  have htarget := anchorRelativeScale_volume_ratio anchor n e n0 e0
    hanchor hn hn0 he he0
  rw [coframeVolume_conformalCoframe _ _ hreconstructed.le,
    coframeVolume_conformalCoframe anchor e0 hanchor.le] at htarget
  field_simp [hanchor.ne', he.ne', he0.ne'] at hratio htarget
  apply mul_left_cancel₀
    (mul_ne_zero he.ne' (Nat.cast_ne_zero.mpr hn0.ne'))
  linear_combination hratio - htarget

/-! ## Nonvacuity control -/

/-- Sixteen events relative to one event on identity conformal representatives
give relative Weyl factor two and coframe-volume ratio sixteen. -/
theorem relative_scale_unit_witness :
    relativeCountScale 16 (1 : Coframe4) 1 (1 : Coframe4) = 2 ∧
      anchorRelativeScale 1 16 (1 : Coframe4) 1 (1 : Coframe4) = 2 ∧
      coframeVolume
          (conformalCoframe
            (anchorRelativeScale 1 16 (1 : Coframe4) 1 (1 : Coframe4))
            (1 : Coframe4)) /
          coframeVolume (conformalCoframe 1 (1 : Coframe4)) = 16 := by
  have hvolume : coframeVolume (1 : Coframe4) = 1 := by
    simp [coframeVolume]
  constructor
  · norm_num [relativeCountScale, fourthRoot, hvolume]
  constructor
  · norm_num [anchorRelativeScale, relativeCountScale, fourthRoot, hvolume]
  · simpa using anchorRelativeScale_volume_ratio
      1 16 (1 : Coframe4) 1 (1 : Coframe4)
      one_pos (by norm_num) one_pos (by simp [hvolume]) (by simp [hvolume])

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relativeScaleProfile_anchor_covariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relativeScaleProfile_anchor_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relativeCountScale_anchor_cocycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relativeCountScale_anchor_cocycle

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relativeAreaScale_anchor_cocycle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relativeAreaScale_anchor_cocycle

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relativeScaleProfile_graphInvariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relativeScaleProfile_graphInvariant

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relativeAreaScale_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relativeAreaScale_sq

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.countCalibratedScale_eq_relative_mul_anchor' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.countCalibratedScale_eq_relative_mul_anchor

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.anchorRelativeScale_volume_ratio' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.anchorRelativeScale_volume_ratio

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.positive_anchorRelativeScale_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.positive_anchorRelativeScale_unique

/-- info: 'PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relative_scale_unit_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction.relative_scale_unit_witness

end PhysicsSM.Draft.NullEdge.RelativeGraphScaleReconstruction

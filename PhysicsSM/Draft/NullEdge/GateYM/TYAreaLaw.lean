import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.OSReconstruction

/-!
# Gate YM: the Tomboulis–Yaffe area-law bound on the one-link `Z2` Wilson slab

This module formalises, on the exactly-solvable one-link `Z2` Wilson slab, the
reflection-positivity **area-law bound** of Tomboulis–Yaffe (1985)
[N7SIEMAC], in the `SU(2)`/`Z2`-center form used by Kanazawa
[K9FIBTZC] (arXiv:0808.3442, their eq. 4):

    |⟨W(C)⟩|  ≤  2 · { (1/2)·(1 − Z⁻/Z) } ^ ( A_C / (L_μ L_ν) )

where `Z` is the periodic-BC partition function, `Z⁻` the `Z2`-twisted
('t Hooft flux) one, `A_C` the minimal spanned loop area and `L_μ L_ν` the
transverse box area.  The "base" of the area law is the **finite lattice ratio**
`Z⁻/Z` (the vortex / 't Hooft free energy); there is no memorised numerical
constant.

## Design: an abstract scaffold, a concrete `Z2` model

The file is deliberately split into two layers so that the *same* area-law
statement generalises to `SU(N)` by a drop-in replacement of the partition
ratio (Kanazawa Thm 2 replaces `Z⁻/Z` by `(1/N)·Σ_k Z^{[k]}/Z`):

* **Abstract layer.**  For an abstract partition ratio `p : ℝ` we set
  `tyBaseOf p := (1/2)·(1 − p)` and `tyStringTensionOf p := -log (tyBaseOf p)`,
  and prove all the sign/monotonicity facts and the area-law repackaging from
  `0 ≤ p` and `p < 1` alone.  The nonabelian version reuses this layer verbatim
  by feeding it `p = (1/N)·Σ_k Z^{[k]}/Z`.

* **Concrete `Z2` model.**  We model the two partition functions by the
  one-plaquette Boltzmann sums
  `Z  ∝ Zplus  β = e^β + e^{-β}` (periodic BC) and
  `Z⁻ ∝ Zminus β = e^β − e^{-β}` (antiperiodic / 't Hooft-twisted BC),
  the same weights that produce the landed transfer eigenvalues
  `lambda0 β = 2·Zplus β`, `lambdaFlux β = 2·Zminus β`.  This gives
  `partitionRatio β = Z⁻/Z = tanh β` and `tyBase β = (1/2)(1 − tanh β)`.

## Provenance and honest claim label

This is a **finite `Z2`-slab identity**, not a continuum or nonabelian result.
The provenance used here is the rigorous Tomboulis-Yaffe reflection-positivity
inequality lineage (CMP 100, 313-341, DOI `10.1007/BF01206134`) plus Kanazawa's
SU(N) center-twist notation/generalization.  It does **not** rely on any
decimation-based all-coupling confinement claim.

The `Z`/`Z⁻` model is the one-plaquette Boltzmann model quoted above; its ratio
`tanh β` coincides with the landed flux/vacuum spectral ratio
`lambdaFlux β / lambda0 β = exp(-osSpectralGap β) = exp(-neU4ClosureGap β)`
of `TwoStateTransferZ2Sector` / `SlabClustering` (recorded here abstractly as
`partitionRatio β = exp(-slabSpectralGap β)`, tying the TY vortex free energy to
the landed spectral gap).  The reflection-positivity / Cauchy–Schwarz step that
produces the raw `|W| ≤ 2·q^r` inequality is kept as an **explicit hypothesis**
`hW` on the theorems — it is *modeled*, not proved here — so the file never
smuggles the area-law bound in as an axiom.

### What is fully proved vs modeled (see the report at the end of the file)

* Fully proved: all sign/positivity facts, `0 ≤ partitionRatio β < 1`,
  `0 < tyBase β < 1/2`, `tyStringTension β > 0`, the read-off
  `tyBase β = exp(-tyStringTension β)`, the area-law repackaging
  `|W| ≤ 2·q^r ⟹ |W| ≤ 2·(tyBase β)^r ⟹ |W| ≤ 2·exp(-r·tyStringTension β)`,
  the explicit `tanh` formula for the string tension, and the
  BC-insensitivity limit (`partitionRatio → 1 ⟹ rate → ∞`).
* Modeled (explicit hypotheses, not proved): the RP/Cauchy–Schwarz input `hW`,
  and the identification of `Z`, `Z⁻` with the one-plaquette Boltzmann sums.

Draft-trust: no `s o r r y`, no `a x i o m`, no `n a t i v e _ d e c i d e`.

Update (integration 2026-07-06): the local `slabSpectralGap` is now tied to the
REAL landed gap by `slabSpectralGap_eq_osSpectralGap` below (both equal
`-log(tanh β)`), so the TY vortex free energy `Z⁻/Z` is proved equal to the
exponential of the assembled `OSReconstruction.osSpectralGap`, not just an
abstract restatement.
-/

noncomputable section

open scoped Topology

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace TYAreaLaw

/-! ## Abstract layer: the area-law base and string tension of a partition ratio -/

/-- The Tomboulis–Yaffe **area-law base** attached to an abstract partition ratio
`p` (`= Z⁻/Z`): `tyBaseOf p = (1/2)·(1 − p)`.  For `SU(N)` the same definition is
fed `p = (1/N)·Σ_k Z^{[k]}/Z`. -/
def tyBaseOf (p : ℝ) : ℝ := (1 / 2) * (1 - p)

/-- The Tomboulis–Yaffe **string tension / area-law rate**
`tyStringTensionOf p = -log (tyBaseOf p)`. -/
def tyStringTensionOf (p : ℝ) : ℝ := -Real.log (tyBaseOf p)

/-- The area-law base is positive whenever the partition ratio is below one. -/
theorem tyBaseOf_pos {p : ℝ} (hp : p < 1) : 0 < tyBaseOf p := by
  unfold tyBaseOf; linarith

/-- The area-law base is strictly below `1/2` whenever the partition ratio is
strictly positive. -/
theorem tyBaseOf_lt_half {p : ℝ} (hp : 0 < p) : tyBaseOf p < 1 / 2 := by
  unfold tyBaseOf; linarith

/-- The area-law base is strictly below one whenever the partition ratio is
strictly positive (via `tyBase < 1/2 < 1`). -/
theorem tyBaseOf_lt_one {p : ℝ} (hp : 0 < p) : tyBaseOf p < 1 := by
  have := tyBaseOf_lt_half hp; linarith

/-- The string tension is strictly positive for `0 < p < 1`. -/
theorem tyStringTensionOf_pos {p : ℝ} (hp0 : 0 < p) (hp1 : p < 1) :
    0 < tyStringTensionOf p := by
  unfold tyStringTensionOf
  have hpos : 0 < tyBaseOf p := tyBaseOf_pos hp1
  have hlt : tyBaseOf p < 1 := tyBaseOf_lt_one hp0
  have : Real.log (tyBaseOf p) < 0 := Real.log_neg hpos hlt
  linarith

/-- Read-off: the area-law base is the exponential of the negative string
tension, `tyBaseOf p = exp(-tyStringTensionOf p)`. -/
theorem tyBaseOf_eq_exp_neg {p : ℝ} (hp : p < 1) :
    tyBaseOf p = Real.exp (-tyStringTensionOf p) := by
  unfold tyStringTensionOf
  rw [neg_neg, Real.exp_log (tyBaseOf_pos hp)]

/-- The `rpow` read-off used by the area law: for `p < 1` and any real exponent
`r`, `(tyBaseOf p) ^ r = exp(-(r · tyStringTensionOf p))`. -/
theorem tyBaseOf_rpow_eq_exp {p : ℝ} (hp : p < 1) (r : ℝ) :
    (tyBaseOf p) ^ r = Real.exp (-(r * tyStringTensionOf p)) := by
  rw [Real.rpow_def_of_pos (tyBaseOf_pos hp)]
  unfold tyStringTensionOf
  ring_nf

/-! ### The abstract area-law bound

The genuine Tomboulis–Yaffe derivation obtains, by iterating a
reflection-positivity / Cauchy–Schwarz inequality across the `A_C/(L_μ L_ν)`
transverse cells, a raw bound `|W| ≤ 2·q^r` for some per-cell factor `q` with
`q ≤ tyBaseOf p`.  We take this RP input as an explicit hypothesis `hW` and
`hq`, and *prove* the packaging into the stated area-law base and into the
positive-rate exponential form. -/

/-- **Abstract Tomboulis–Yaffe area-law bound.**  Given the RP-derived raw bound
`|W| ≤ 2·q^r` with a per-cell factor `q ∈ [0, tyBaseOf p]`, the Wilson loop
obeys the area law `|W| ≤ 2·(tyBaseOf p)^r`.  (`hW` and `hq` encode exactly the
reflection-positivity / Cauchy–Schwarz input; they are modeled, not proved.) -/
theorem tyAreaLaw {p q r W : ℝ} (hr : 0 ≤ r) (hq0 : 0 ≤ q)
    (hq : q ≤ tyBaseOf p) (hW : |W| ≤ 2 * q ^ r) :
    |W| ≤ 2 * (tyBaseOf p) ^ r := by
  have hmono : q ^ r ≤ (tyBaseOf p) ^ r := Real.rpow_le_rpow hq0 hq hr
  calc |W| ≤ 2 * q ^ r := hW
    _ ≤ 2 * (tyBaseOf p) ^ r := by nlinarith [Real.rpow_nonneg hq0 r]

/-- **Positive-rate corollary (non-vacuous form).**  The area-law bound rewritten
as exponential decay in the area exponent `r` at the strictly positive rate
`tyStringTensionOf p`: `|W| ≤ 2·exp(-(r · tyStringTensionOf p))`. -/
theorem tyAreaLaw_exp {p r W : ℝ} (hp1 : p < 1)
    (hW : |W| ≤ 2 * (tyBaseOf p) ^ r) :
    |W| ≤ 2 * Real.exp (-(r * tyStringTensionOf p)) := by
  rwa [tyBaseOf_rpow_eq_exp hp1 r] at hW

/-! ## BC-insensitivity: as the partition ratio → 1, the rate → ∞ -/

/-- **Boundary-condition insensitivity.**  As the partition ratio `p → 1⁻`
(the box becomes insensitive to the `Z2` twist, `Z⁻/Z → 1`), the area-law base
`tyBaseOf p → 0` and hence the string tension `tyStringTensionOf p → +∞`. -/
theorem tyStringTensionOf_tendsto_atTop :
    Filter.Tendsto tyStringTensionOf (𝓝[<] (1 : ℝ)) Filter.atTop := by
  have hbase : Filter.Tendsto tyBaseOf (𝓝[<] (1 : ℝ)) (𝓝[>] (0 : ℝ)) := by
    apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within
    · have hc : Continuous tyBaseOf := by unfold tyBaseOf; fun_prop
      have ht := hc.tendsto (1 : ℝ)
      have h1 : tyBaseOf 1 = 0 := by unfold tyBaseOf; ring
      rw [h1] at ht
      exact ht.mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with x hx
      exact tyBaseOf_pos hx
  have hlog : Filter.Tendsto Real.log (𝓝[>] (0 : ℝ)) Filter.atBot :=
    Real.tendsto_log_nhdsGT_zero
  have hcomp : Filter.Tendsto (Real.log ∘ tyBaseOf) (𝓝[<] (1 : ℝ)) Filter.atBot :=
    hlog.comp hbase
  exact Filter.tendsto_neg_atTop_iff.mpr hcomp

/-! ## Concrete one-link `Z2` model: `Z⁻/Z = tanh β`

We model the two partition functions by the one-plaquette Boltzmann sums.  These
are the same weights that produce the landed transfer eigenvalues
`lambda0 β = 2·Zplus β` and `lambdaFlux β = 2·Zminus β`. -/

/-- Periodic-BC one-plaquette partition sum `Z ∝ e^β + e^{-β}`. -/
def Zplus (beta : ℝ) : ℝ := Real.exp beta + Real.exp (-beta)

/-- Antiperiodic / 't Hooft-twisted one-plaquette partition sum
`Z⁻ ∝ e^β − e^{-β}`. -/
def Zminus (beta : ℝ) : ℝ := Real.exp beta - Real.exp (-beta)

/-- The finite lattice **partition ratio** `Z⁻/Z` (the vortex / 't Hooft free
energy exponential).  For `SU(N)` this single scalar is replaced by
`(1/N)·Σ_k Z^{[k]}/Z`. -/
def partitionRatio (beta : ℝ) : ℝ := Zminus beta / Zplus beta

/-- The concrete area-law base `tyBase β = (1/2)(1 − tanh β)`. -/
def tyBase (beta : ℝ) : ℝ := tyBaseOf (partitionRatio beta)

/-- The concrete string tension `tyStringTension β = -log((1 − tanh β)/2)`. -/
def tyStringTension (beta : ℝ) : ℝ := tyStringTensionOf (partitionRatio beta)

theorem Zplus_pos (beta : ℝ) : 0 < Zplus beta :=
  add_pos (Real.exp_pos beta) (Real.exp_pos (-beta))

theorem Zminus_pos {beta : ℝ} (hbeta : 0 < beta) : 0 < Zminus beta := by
  unfold Zminus
  have : Real.exp (-beta) < Real.exp beta := Real.exp_lt_exp.mpr (by linarith)
  linarith

/-- The partition ratio is exactly `tanh β`. -/
theorem partitionRatio_eq_tanh (beta : ℝ) :
    partitionRatio beta = Real.tanh beta := by
  rw [Real.tanh_eq]; rfl

/-- `0 ≤ partitionRatio β` for `β > 0` (in fact strictly positive). -/
theorem partitionRatio_pos {beta : ℝ} (hbeta : 0 < beta) :
    0 < partitionRatio beta :=
  div_pos (Zminus_pos hbeta) (Zplus_pos beta)

theorem partitionRatio_nonneg {beta : ℝ} (hbeta : 0 < beta) :
    0 ≤ partitionRatio beta := (partitionRatio_pos hbeta).le

/-- `partitionRatio β < 1` for all `β` (the antiperiodic sum never exceeds the
periodic one, since `e^{-β} > 0`). -/
theorem partitionRatio_lt_one (beta : ℝ) :
    partitionRatio beta < 1 := by
  rw [partitionRatio, div_lt_one (Zplus_pos beta)]
  unfold Zminus Zplus
  have := Real.exp_pos (-beta)
  linarith

/-- `partitionRatio β ∈ [0, 1)` for `β > 0`. -/
theorem partitionRatio_mem_Ico {beta : ℝ} (hbeta : 0 < beta) :
    partitionRatio beta ∈ Set.Ico (0 : ℝ) 1 :=
  ⟨partitionRatio_nonneg hbeta, partitionRatio_lt_one beta⟩

/-! ### Concrete positivity of the base and string tension -/

/-- `0 < tyBase β` for all `β` (since `partitionRatio β < 1` always). -/
theorem tyBase_pos (beta : ℝ) : 0 < tyBase beta :=
  tyBaseOf_pos (partitionRatio_lt_one beta)

/-- `tyBase β < 1/2` for `β > 0`. -/
theorem tyBase_lt_half {beta : ℝ} (hbeta : 0 < beta) : tyBase beta < 1 / 2 :=
  tyBaseOf_lt_half (partitionRatio_pos hbeta)

/-- `0 < tyBase β < 1/2` for `β > 0`. -/
theorem tyBase_mem_Ioo {beta : ℝ} (hbeta : 0 < beta) :
    tyBase beta ∈ Set.Ioo (0 : ℝ) (1 / 2) :=
  ⟨tyBase_pos beta, tyBase_lt_half hbeta⟩

/-- `tyStringTension β > 0` for `β > 0`: a strictly positive area-law rate. -/
theorem tyStringTension_pos {beta : ℝ} (hbeta : 0 < beta) :
    0 < tyStringTension beta :=
  tyStringTensionOf_pos (partitionRatio_pos hbeta) (partitionRatio_lt_one beta)

/-- Read-off `tyBase β = exp(-tyStringTension β)` (holds for all `β`). -/
theorem tyBase_eq_exp_neg (beta : ℝ) :
    tyBase beta = Real.exp (-tyStringTension beta) :=
  tyBaseOf_eq_exp_neg (partitionRatio_lt_one beta)

/-- The explicit `tanh` formula for the string tension:
`tyStringTension β = -log((1 − tanh β)/2)`. -/
theorem tyStringTension_eq_tanh (beta : ℝ) :
    tyStringTension beta = -Real.log ((1 - Real.tanh beta) / 2) := by
  unfold tyStringTension tyStringTensionOf tyBaseOf
  rw [partitionRatio_eq_tanh]
  ring_nf

/-! ### The concrete area law on the `Z2` slab -/

/-- **Concrete Tomboulis–Yaffe area law on the `Z2` slab.**  Given the RP-derived
raw bound `|W| ≤ 2·q^r` with per-cell factor `q ∈ [0, tyBase β]`, the Wilson
loop obeys `|W| ≤ 2·(tyBase β)^r`.  Here `r = A_C/(L_μ L_ν) ≥ 0` is the area
exponent. -/
theorem tyAreaLaw_slab {beta q r W : ℝ} (hr : 0 ≤ r) (hq0 : 0 ≤ q)
    (hq : q ≤ tyBase beta) (hW : |W| ≤ 2 * q ^ r) :
    |W| ≤ 2 * (tyBase beta) ^ r :=
  tyAreaLaw hr hq0 hq hW

/-- **Positive-rate corollary on the `Z2` slab (non-vacuous).**  For `β > 0` the
rate `tyStringTension β` is strictly positive *and* the Wilson loop decays as
`|W| ≤ 2·exp(-(r · tyStringTension β))`. -/
theorem tyAreaLaw_slab_exp {beta r W : ℝ} (hbeta : 0 < beta)
    (hW : |W| ≤ 2 * (tyBase beta) ^ r) :
    0 < tyStringTension beta ∧
      |W| ≤ 2 * Real.exp (-(r * tyStringTension beta)) :=
  ⟨tyStringTension_pos hbeta, tyAreaLaw_exp (partitionRatio_lt_one beta) hW⟩

/-! ## Tie-back to the landed spectral gap

The landed one-link `Z2` results record the flux/vacuum spectral ratio
`lambdaFlux β / lambda0 β = tanh β = exp(-osSpectralGap β) = exp(-neU4ClosureGap β)`.
We reproduce that spectral gap abstractly here and show the TY partition ratio is
exactly its exponential, tying the vortex / 't Hooft free energy to the landed
spectral gap. -/

/-- The landed one-link `Z2` spectral gap `-log(tanh β)`
(`= osSpectralGap β = neU4ClosureGap β = fluxGap` of the landed modules). -/
def slabSpectralGap (beta : ℝ) : ℝ := -Real.log (Real.tanh beta)

/-- The TY partition ratio is the exponential of the negative landed spectral
gap: `partitionRatio β = exp(-slabSpectralGap β)`.  This ties the 't Hooft /
vortex free-energy ratio `Z⁻/Z` to the landed `osSpectralGap`/`neU4ClosureGap`. -/
theorem partitionRatio_eq_exp_neg_slabGap {beta : ℝ} (hbeta : 0 < beta) :
    partitionRatio beta = Real.exp (-slabSpectralGap beta) := by
  unfold slabSpectralGap
  rw [neg_neg, partitionRatio_eq_tanh, Real.exp_log]
  rw [← partitionRatio_eq_tanh]
  exact partitionRatio_pos hbeta

/-- **The local `slabSpectralGap` IS the landed OS spectral gap.**  Both equal
`-log(tanh β)`, so the TY area-law rate and the assembled
`OSReconstruction.osSpectralGap` (the `SlabGapAssembly` gap conjunct) are the same
positive number.  This makes the tie-back a proved identity, not just prose. -/
theorem slabSpectralGap_eq_osSpectralGap {beta : ℝ} (hbeta : 0 < beta) :
    slabSpectralGap beta = OSReconstruction.osSpectralGap beta hbeta := by
  rw [slabSpectralGap, OSReconstruction.osSpectralGap_eq_neg_log_tanh beta hbeta]

/-- **The TY vortex free energy equals the exponential of the assembled OS gap.**
`partitionRatio β = Z⁻/Z = exp(-osSpectralGap β)`.  The Tomboulis–Yaffe area-law
base is thus driven by exactly the `SlabGapAssembly` spectral gap.

CAVEAT (semantic audit 2026-07-06, job `029b8cd3`): this identity is TRUE but
*coincidental / essentially definitional on this exactly-solvable abelian
one-plaquette slab* - both sides reduce to `tanh β` because `partitionRatio` is
built from the same Boltzmann weights `e^{±β}` that fix the transfer spectrum.
It must NOT be read as "the Wilson-loop area law / vortex free energy EQUALS the
transfer-Hamiltonian spectral gap" in general (they are physically distinct
objects); it is a finite `Z2`-slab coincidence, not a general theorem. -/
theorem partitionRatio_eq_exp_neg_osSpectralGap {beta : ℝ} (hbeta : 0 < beta) :
    partitionRatio beta = Real.exp (-OSReconstruction.osSpectralGap beta hbeta) := by
  rw [partitionRatio_eq_exp_neg_slabGap hbeta, slabSpectralGap_eq_osSpectralGap hbeta]

end TYAreaLaw
end GateYM
end NullEdge
end Draft
end PhysicsSM

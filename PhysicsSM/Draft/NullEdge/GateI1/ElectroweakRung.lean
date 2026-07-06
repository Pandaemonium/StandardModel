import Mathlib
import PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass

/-!
# NE-U6: the electroweak rung - the physical W as a gauge-invariant composite

Rung NE-U6 of the null-edge mass unification ladder
(`AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md`, section 3,
"NE-U6 - the electroweak rung"). This module is a **statement freeze plus one
smallest provable finite identity**. It builds the smallest possible finite
lattice gauge-Higgs toy - a `Z2` gauge link between two sites carrying a `Z2`
Higgs/matter field - and proves the honest finite fact behind "the W-mass is a
transfer-spectrum feature of GAUGE-INVARIANT composite operators": the physical
W is a CLOSED composite `phi(x) . U_xy . phi(y)`, gauge-invariant, whereas the
bare link and the bare Higgs are gauge-covariant only, and the composite channel
carries a strictly positive transfer gap of exactly the same 2-state shape as
the pure-gauge glueball gap of NE-U5.

## The model (smallest finite gauge-Higgs, `Z2`)

Two sites `Fin 2 = {0, 1}`; one ordered link variable `U : Bool` (`false = +1`,
`true = -1`, matching `Z2GaugeCore`); a `Z2` Higgs/matter field `phi : Fin 2 ->
Bool` living on the sites. A gauge transformation `g : Fin 2 -> Bool` acts by

    U      |->  g 0 * U * g 1      (link, covariant: rotates by the endpoints)
    phi i  |->  g i * phi i        (Higgs, covariant: rotates by its own site)

(all products are `xor`, since `Z2` inverses are trivial). The **physical W** -
the gauge-invariant link-Higgs-Higgs composite `phi(x)^dag U_xy phi(y)` - is

    W(phi, U)  =  phi 0 * U * phi 1     (`wComposite`).

## What is proved here (the smallest provable finite identity)

* `wComposite_gauge_invariant` : the composite W is gauge-invariant for EVERY
  gauge transformation `g` and EVERY configuration - the electroweak analogue of
  closure (the physical W is a closed composite, not an open edge).
* `bareLink_not_gauge_invariant`, `bareHiggs_not_gauge_invariant` : the bare link
  and the bare Higgs are genuinely NOT gauge-invariant (there is always a gauge
  transformation that changes them) - the Elitzur/closure obstruction in the
  Higgs sector: the bare fields carry no gauge-invariant content by themselves.
* `wLikeMass_pos` : the composite ("W") channel transfer gap `wLikeMass beta =
  log coth beta` is strictly positive for every finite `beta > 0` - a strictly
  positive `W`-like mass appearing purely as a transfer-spectrum feature of the
  gauge-invariant composite channel, with zero primitive mass input.
* `wLikeMass_eq_glueballMass` : the `W`-like composite gap is, in this smallest
  toy, the SAME 2-state functional shape as the NE-U5 glueball gap. This is the
  honest "shared mechanism SHAPE" statement (see the HARD BOUNDARY below): both
  the electroweak and the pure-gauge physical masses are closure/composite gaps
  of the identical `transfer2` form. It is NOT a mechanism identity.
* `electroweakRung` : the bundled headline conjunction.

Reused finite-transfer machinery (NOT redefined): `MassWithoutMass.transfer2`,
`MassWithoutMass.gap2`, `MassWithoutMass.transfer2_gap_pos`,
`MassWithoutMass.z2GlueballMass`, `MassWithoutMass.z2GlueballMass_pos`. The `Z2`
gauge action is the same convention as `GateYM/Z2GaugeCore` (`xor`, `false = +1`).

## HARD BOUNDARY (kill condition)

Fradkin-Shenker is FINITE-LATTICE PHASE-DIAGRAM connectivity of the Higgs and
confinement regimes, NOT an identity of mechanisms. Claiming "Higgs mechanism IS
confinement" outright is a KILL CONDITION and is NOT asserted anywhere in this
module. The honest claim proved here is only that, on the lattice, the physical W
is a gauge-invariant CLOSED composite (like a glueball), so its mass is a
closure/composite obstruction of the SAME SHAPE as the gauge sector - a shared
MECHANISM SHAPE (`wLikeMass_eq_glueballMass`), NOT a proven mechanism identity.
Any Fradkin-Shenker citation is bibliographic-verification-pending and is NOT
relied upon for any formal step here.

## Claim discipline

Claim label: **reconstruction (statement layer) + one finite identity**. The
proved core (`wComposite_gauge_invariant`, `bare*_not_gauge_invariant`,
`wLikeMass_pos`, `wLikeMass_eq_glueballMass`, `electroweakRung`) is
`s o r r y`-free and kernel-checked. The two-point composite transfer
correlation identities (`compositeTwoPoint_decay`, `compositeTwoPoint_total`)
were also proved `s o r r y`-free in this pass; only the Fradkin-Shenker
phase-diagram connectivity reconstruction remains a STATEMENT FREEZE with a
clearly-labeled handoff `s o r r y` in the `Frozen` section below. Draft-trust;
no continuum, no numerical W-mass
value, no new `a x i o m`, no `n a t i v e _ d e c i d e`, no statement weakening.
Prerequisites: Mathlib, `GateI1/MassWithoutMass`.
-/

open scoped Matrix

namespace PhysicsSM.Draft.NullEdge.GateI1
namespace ElectroweakRung

open PhysicsSM.Draft.NullEdge.GateI1.MassWithoutMass

/-! ## The smallest finite gauge-Higgs model (Z2, two sites, one link) -/

/-- Gauge action on the link variable: `U |-> g 0 * U * g 1` (`xor` for `Z2`).
The link is gauge-COVARIANT: it rotates by its two endpoints. -/
def gaugeLink (g : Fin 2 → Bool) (U : Bool) : Bool := g 0 ^^ (U ^^ g 1)

/-- Gauge action on the Higgs/matter field: `phi i |-> g i * phi i` (`xor`). The
Higgs is gauge-COVARIANT: it rotates by its own site. -/
def gaugeHiggs (g : Fin 2 → Bool) (φ : Fin 2 → Bool) : Fin 2 → Bool :=
  fun i => g i ^^ φ i

/-- The **physical W**: the gauge-invariant link-Higgs-Higgs composite
`phi(0)^dag . U_{01} . phi(1)`, here `phi 0 * U * phi 1` (`xor`). This is a CLOSED
composite (a "gauge-invariant loop through the Higgs"), not an open edge. -/
def wComposite (φ : Fin 2 → Bool) (U : Bool) : Bool := φ 0 ^^ (U ^^ φ 1)

/-! ## The finite identity: W is a gauge-invariant composite, the bare fields are not -/

/-- **NE-U6 closure (electroweak Elitzur analogue), invariance half.** The
composite W is gauge-invariant for EVERY gauge transformation `g` and EVERY
configuration `(phi, U)`: the endpoint rotations of the link cancel exactly
against the site rotations of the two Higgs factors. The physical W is a closed
composite. -/
theorem wComposite_gauge_invariant (g φ : Fin 2 → Bool) (U : Bool) :
    wComposite (gaugeHiggs g φ) (gaugeLink g U) = wComposite φ U := by
  simp only [wComposite, gaugeHiggs, gaugeLink]
  cases g 0 <;> cases g 1 <;> cases φ 0 <;> cases φ 1 <;> cases U <;> rfl

/-- **NE-U6 closure, covariance (non-invariance) half for the link.** The bare
link is genuinely NOT gauge-invariant: for every configuration there is a gauge
transformation (flip the site-`0` gauge factor only) that changes it. The open
gauge edge carries no gauge-invariant content by itself. -/
theorem bareLink_not_gauge_invariant (U : Bool) :
    ∃ g : Fin 2 → Bool, gaugeLink g U ≠ U := by
  refine ⟨fun i => decide (i = 0), ?_⟩
  simp only [gaugeLink]
  cases U <;> decide

/-- **NE-U6 closure, covariance (non-invariance) half for the Higgs.** The bare
Higgs field is genuinely NOT gauge-invariant: for every configuration there is a
gauge transformation (flip the site-`0` gauge factor only) that changes it. The
bare matter field carries no gauge-invariant content by itself. -/
theorem bareHiggs_not_gauge_invariant (φ : Fin 2 → Bool) :
    ∃ g : Fin 2 → Bool, gaugeHiggs g φ ≠ φ := by
  refine ⟨fun i => decide (i = 0), ?_⟩
  intro h
  have h0 := congrFun h 0
  simp only [gaugeHiggs] at h0
  revert h0
  cases φ 0 <;> decide

/-! ## The W-like mass: transfer gap of the gauge-invariant composite channel -/

/-- The composite ("physical W") **channel transfer operator**: the same
symmetric `2 x 2` `transfer2` on the two states of the gauge-invariant composite
`W in {even, odd}`, with `a = e^beta`, `b = e^{-beta}`. Reuses
`MassWithoutMass.transfer2` verbatim (not redefined). -/
noncomputable def wCompositeTransfer (β : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  transfer2 (Real.exp β) (Real.exp (-β))

/-- The **W-like mass**: the transfer gap of the gauge-invariant composite
channel, `wLikeMass beta = gap2 (e^beta) (e^{-beta}) = log coth beta`. It is a
transfer-SPECTRUM feature of the composite operator, not a primitive `m^2 W^2`
term. -/
noncomputable def wLikeMass (β : ℝ) : ℝ := gap2 (Real.exp β) (Real.exp (-β))

/-- The composite channel transfer operator is exactly the `transfer2` object. -/
theorem wCompositeTransfer_eq (β : ℝ) :
    wCompositeTransfer β = transfer2 (Real.exp β) (Real.exp (-β)) := rfl

/-- **NE-U6 headline positivity (`wLikeMass = transferGap(compositeChannel) >
0`).** The gauge-invariant composite ("W") channel has a STRICTLY POSITIVE
transfer gap for every finite `beta > 0`: a strictly positive W-like mass
appearing purely as a transfer-spectrum feature of the composite operator, with
zero primitive mass input. -/
theorem wLikeMass_pos {β : ℝ} (hβ : 0 < β) : 0 < wLikeMass β := by
  refine transfer2_gap_pos (Real.exp_pos _) ?_
  exact Real.exp_lt_exp.mpr (by linarith)

/-- **NE-U6 shared-mechanism-SHAPE identity (the honest Fradkin-Shenker-adjacent
statement).** In this smallest toy the W-like composite gap is the SAME 2-state
functional shape as the NE-U5 pure-gauge glueball gap: both are the identical
`gap2 (e^beta) (e^{-beta})` closure/composite obstruction of the identical
`transfer2` form. This is a shared MECHANISM SHAPE, NOT a mechanism identity, and
NOT the Fradkin-Shenker theorem (see the HARD BOUNDARY in the module docstring):
it does not license claiming "Higgs mechanism IS confinement". -/
theorem wLikeMass_eq_glueballMass (β : ℝ) : wLikeMass β = z2GlueballMass β := rfl

/-- **NE-U6 bundled headline (electroweak rung, proved core).** In the smallest
finite `Z2` gauge-Higgs toy, at any coupling `beta > 0`:

1. the physical W is a gauge-invariant CLOSED composite (`phi 0 * U * phi 1`),
   invariant under every gauge transformation;
2. the bare link and the bare Higgs are genuinely gauge-covariant, NOT invariant;
3. the composite ("W") channel carries a STRICTLY POSITIVE transfer gap
   (`wLikeMass beta > 0`) with zero primitive mass input;
4. this W-like gap has the SAME 2-state shape as the NE-U5 glueball gap - a
   shared mechanism SHAPE, not a mechanism identity.

The W-mass is therefore, in this toy, a transfer-spectrum feature of a
gauge-invariant composite - a closure/composite obstruction of the same shape as
the gauge sector. -/
theorem electroweakRung {β : ℝ} (hβ : 0 < β) :
    (∀ g φ U, wComposite (gaugeHiggs g φ) (gaugeLink g U) = wComposite φ U) ∧
      (∀ U, ∃ g : Fin 2 → Bool, gaugeLink g U ≠ U) ∧
      (∀ φ, ∃ g : Fin 2 → Bool, gaugeHiggs g φ ≠ φ) ∧
      0 < wLikeMass β ∧
      wLikeMass β = z2GlueballMass β :=
  ⟨wComposite_gauge_invariant, bareLink_not_gauge_invariant,
    bareHiggs_not_gauge_invariant, wLikeMass_pos hβ, wLikeMass_eq_glueballMass β⟩

/-! ## The intended arc: composite two-point decay (PROVED) and Fradkin-Shenker (FROZEN)

The rung's intended arc is W-mass as a gauge-invariant-composite transfer-
spectrum feature. The two-point transfer correlation identities below turned out
to be provable in this pass and are `s o r r y`-free; the Fradkin-Shenker phase-
diagram reconstruction remains a clearly-labeled STATEMENT FREEZE with a handoff
`s o r r y`. All items in this namespace are cleanly separated from the proved core
above and are NOT used by any core theorem. Draft-trust; each carries its own
claim label. -/

namespace Frozen

/-- **[PROVED - finite identity]** Two-point transfer correlation of the
composite channel decays with the W-like mass. The connected composite
correlator `(T^n)_{00} - (T^n)_{01}` in the composite channel equals `(a - b)^n`;
together with `compositeTwoPoint_total` below (`(T^n)_{00} + (T^n)_{01} =
(a + b)^n`) the normalized composite correlation decays exactly as
`((a - b)/(a + b))^n = exp (- n * wLikeMass beta)`. This is the "positive
transfer-gap => exponential clustering of the gauge-invariant W composite"
statement. Claim label: finite identity. -/
theorem compositeTwoPoint_decay {β : ℝ} (_hβ : 0 < β) (n : ℕ) :
    ((wCompositeTransfer β) ^ n) 0 0 - ((wCompositeTransfer β) ^ n) 0 1
      = (Real.exp β - Real.exp (-β)) ^ n := by
  induction' n with n ih <;> simp_all +decide [ pow_succ, Matrix.mul_apply ];
  rw [ ← ih ] ; ring!

/-- **[PROVED - finite identity]** The total composite-channel `n`-step weight is
`(a + b)^n`, so together with `compositeTwoPoint_decay` the NORMALIZED composite
correlation is `((a - b)/(a + b))^n = exp (- n * wLikeMass beta)`: the W-like
mass controls the exponential clustering rate of the gauge-invariant composite.
Claim label: finite identity. -/
theorem compositeTwoPoint_total {β : ℝ} (_hβ : 0 < β) (n : ℕ) :
    ((wCompositeTransfer β) ^ n) 0 0 + ((wCompositeTransfer β) ^ n) 0 1
      = (Real.exp β + Real.exp (-β)) ^ n := by
  induction' n with n ih <;> simp_all +decide [ pow_succ, Matrix.mul_apply ];
  convert congr_arg ( · * ( Real.exp β + Real.exp ( -β ) ) ) ih using 1 ; ring!

/-- **[FROZEN - handoff `s o r r y`, bibliographic-verification-pending]** The
Fradkin-Shenker phase-diagram RECONSTRUCTION statement layer: on the finite
lattice the Higgs and confinement regimes are analytically connected in the
`(beta, kappa)` coupling plane (gauge coupling `beta`, Higgs hopping `kappa`).

HARD BOUNDARY: this is phase-diagram CONNECTIVITY, NOT a mechanism identity;
citing Fradkin-Shenker (1979) is bibliographic-verification-pending and is NOT
relied on by any proved theorem here. Stated here only as a frozen reconstruction
target for a later pass; deliberately phrased as connectivity of a region, never
as "Higgs = confinement". Claim label: reconstruction (frozen; citation pending).

The concrete finite formalization (a path in coupling space along which the
gauge-invariant composite spectrum varies analytically with no phase boundary
crossed) is deferred; the statement is recorded as a `Prop`-level placeholder to
freeze the arc's shape without asserting it. -/
def FradkinShenkerConnectivity : Prop :=
  -- Placeholder shape: "there is a coupling-space path connecting a Higgs-regime
  -- point to a confinement-regime point along which the composite W channel gap
  -- stays positive (no gap closure / no phase boundary)". Deferred formalization.
  ∀ β : ℝ, 0 < β → 0 < wLikeMass β

/-- **[FROZEN - handoff `s o r r y`]** The frozen connectivity placeholder. Note:
the placeholder body is literally the proved positivity, but it is kept in the
`Frozen` namespace and marked as a reconstruction TARGET because the intended
statement (an analytic path across the phase diagram) is far stronger than this
single-regime positivity and remains to be formalized honestly. Claim label:
reconstruction (frozen). -/
theorem fradkinShenker_connectivity : FradkinShenkerConnectivity := by
  sorry

end Frozen

end ElectroweakRung
end PhysicsSM.Draft.NullEdge.GateI1

/-
# HNU infrared tangent ↦ local Weyl charge (composition layer)

This module composes two already-proved, self-contained results:

* the **exact HNU endpoint** (`endpoint`, from the uploaded live
  `HNUExactCore.lean`, namespace `PhysicsSM.Draft.NullEdge.HNUExactCore`), and
* the **exact infrared tangent** `endpoint_ray_hasDerivAt` (from
  `HNUInfraredTangent.lean`), which proves
  `d/dt endpoint(t·q)|₀ = -i·(q₀σ₁ + q₁σ₂ + q₂σ₃)`,

into the strongest *honest, local* Weyl-charge statement that the uploaded
finite Weyl orientation/degree architecture (`WeylSphereChargeBridge.lean`)
permits.

## What is proved (the honest local ladder)

1. **Exact Jacobian / coefficient map & nonzero determinant.**  Dividing the
   infrared tangent by `-i` gives exactly the two-band Weyl Hamiltonian
   `h(q) = (A q)·σ` with real coefficient matrix (vielbein / Jacobian)
   `A = weylJacobian = I₃`.  Proved: `endpoint_ir_tangent_weyl`,
   `weylJacobian_det` (`det = 1`), `weylJacobian_det_ne_zero`.

2. **Isolated linearized node + explicit witnesses.**  The linearized
   Hamiltonian vanishes only at the node: `linearized_node_isolated`
   (`weylHam weylJacobian q = 0 ↔ q = 0`).  Explicit nonzero axis / rational
   witnesses: `linearized_node_axis0` (`weylHam weylJacobian ![1,0,0] = σ₁ ≠ 0`)
   and `ir_tangent_axis0_ne_zero` (the genuine tangent `-i·σ₁ ≠ 0`).

3. **Local chirality / orientation `+1` (all signs displayed).**
   `local_chirality_one` (`χ(A) = sign(det A) = +1`), with the opposite-orientation
   contrast `reflected_chirality_neg_one` (`χ(reflection) = -1`) and the full
   `ir_weyl_sign_conventions` bundle exhibiting the `-i` factor, the Pauli
   ordering `σ₁,σ₂,σ₃`, `A = I₃`, `det A = +1`, and `χ = +1` together.

4. **Bridge into the enclosing-sphere degree / Chern shape.**  Because the
   uploaded `WeylSphereChargeBridge` uses the *same* Pauli conventions
   (`σⱼ = sigmaⱼ`, verified by `rfl`), the abstract reduction composes with no
   adapter beyond the missing topological API: under the standard degree hypotheses,
   the enclosing-sphere degree of this node's Bloch map is `+1`
   (`hnu_ir_node_degree_eq_one`), and, adding the separate first-Chern = degree
   physics hypothesis, the first Chern number is `+1`
   (`hnu_ir_node_chern_eq_one`).  The identity Bloch map is recorded as
   `blochVec_hnu_ir`.

## Scope guards (what is NOT claimed)

This is a purely *local* result about the first derivative at the single node
`k = 0`.  It does **not** assert (and nothing here should be read as asserting):
a copy-free lattice, anomaly cancellation, a bulk–edge theorem, primitive-null
support, a continuum PDE, or an *unconditional* global Brillouin-zone charge.
The global degree / Chern statements are honest reductions from named
hypotheses standing in for the Brouwer-degree / Berry-curvature API that is
absent from the pinned Mathlib (`v4.28.0`); see `WeylSphereChargeBridge.lean`.

Every headline theorem carries a build-enforced assumption-footprint guard
reporting only `propext`, `Classical.choice`, and `Quot.sound`.
-/
import PhysicsSM.Draft.NullEdge.HNUInfraredTangent
import PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUInfraredTangent
open PhysicsSM.Draft.NullEdge.WeylSphereChargeBridge
  (pauliDot weylHam chirality reflect blochVec normalize nrm nrmSq OnSphere
   sigma1 sigma2 sigma3 pauliDot_sq nrmSq_eq_zero chirality_one chirality_reflect
   reflect_det blochVec_one deg_eq_chirality chern_eq_chirality)

namespace PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge

noncomputable section

/-- Local abbreviation: `2×2` complex matrices (the two-band Bloch space). -/
abbrev M2 := Matrix (Fin 2) (Fin 2) ℂ
/-- Local abbreviation: real `3×3` coefficient / Jacobian matrices. -/
abbrev M3 := Matrix (Fin 3) (Fin 3) ℝ

/-! ## §0  The Pauli conventions agree (definitional bridge)

The uploaded `HNUExactCore` Pauli matrices `σ₁,σ₂,σ₃` and the
`WeylSphereChargeBridge` Pauli matrices `sigma₁,sigma₂,sigma₃` are *the same
matrices* — no convention adapter is needed. -/

lemma sigma1_eq : (σ1 : M2) = sigma1 := rfl
lemma sigma2_eq : (σ2 : M2) = sigma2 := rfl
lemma sigma3_eq : (σ3 : M2) = sigma3 := rfl

/-- The bridge contraction `pauliDot q` is exactly the Pauli sum appearing in the
infrared tangent. -/
lemma pauliDot_eq_sigmaSum (q : Fin 3 → ℝ) :
    pauliDot q = (q 0 : ℂ) • σ1 + (q 1 : ℂ) • σ2 + (q 2 : ℂ) • σ3 := by
  simp only [pauliDot, sigma1_eq, sigma2_eq, sigma3_eq]

/-! ## §1  The exact coefficient map / Jacobian and its nonzero determinant -/

/-- The real coefficient matrix (vielbein / Jacobian) of the linearized Weyl
node read off from the infrared tangent: the tangent is `-i·(A q)·σ` with
`A = I₃`.  The coefficient map `q ↦ A q` is the identity, so the Jacobian is the
`3×3` identity. -/
def weylJacobian : M3 := 1

/-- The linearized effective Hamiltonian is the two-band Weyl symbol
`weylHam weylJacobian q = pauliDot q`. -/
lemma weylHam_weylJacobian (q : Fin 3 → ℝ) : weylHam weylJacobian q = pauliDot q := by
  unfold weylJacobian weylHam
  rw [Matrix.one_mulVec]

/-- **Exact infrared tangent as a Weyl Hamiltonian derivative.** For every ray
`q`, `d/dt endpoint(t·q)|₀ = -i · (weylHam weylJacobian q)`, i.e. the tangent is
`-i·(A q)·σ` with the identity Jacobian `A = weylJacobian`. -/
theorem endpoint_ir_tangent_weyl (q : Fin 3 → ℝ) :
    HasDerivAt (fun t : ℝ => endpoint (fun i => t * q i))
      ((-I) • weylHam weylJacobian q) 0 := by
  have h := endpoint_ray_hasDerivAt q
  rw [weylHam_weylJacobian, pauliDot_eq_sigmaSum]
  exact h

/-- The coefficient map is the identity, so its Jacobian determinant is `1`. -/
theorem weylJacobian_det : weylJacobian.det = 1 := by
  unfold weylJacobian; exact Matrix.det_one

/-- **Nonzero determinant** of the exact Jacobian: `det A = 1 ≠ 0`. -/
theorem weylJacobian_det_ne_zero : weylJacobian.det ≠ 0 := by
  rw [weylJacobian_det]; norm_num

/-! ## §2  The linearized node is isolated, with explicit witnesses -/

/-- **Isolated linearized node.** The linearized effective Hamiltonian vanishes
exactly at the crossing: `weylHam weylJacobian q = 0 ↔ q = 0`.  (Consequence of
the Clifford square `(v·σ)² = ‖v‖²·I` and non-degeneracy of the Jacobian.) -/
theorem linearized_node_isolated (q : Fin 3 → ℝ) :
    weylHam weylJacobian q = 0 ↔ q = 0 := by
  rw [weylHam_weylJacobian]
  constructor
  · intro h
    have hsq := pauliDot_sq q
    rw [h, zero_mul] at hsq
    have hz : ((nrmSq q : ℝ) : ℂ) = 0 := by
      rcases smul_eq_zero.mp hsq.symm with hc | h1
      · exact hc
      · exact absurd h1 one_ne_zero
    have : nrmSq q = 0 := by exact_mod_cast hz
    exact nrmSq_eq_zero.mp this
  · rintro rfl
    simp [pauliDot]

/-- Explicit nonzero **axis witness** for the coefficient map: along the first
axis the linearized Hamiltonian is `σ₁`. -/
theorem linearized_node_axis0 : weylHam weylJacobian ![1, 0, 0] = σ1 := by
  rw [weylHam_weylJacobian, pauliDot_eq_sigmaSum]
  simp

/-- `σ₁ ≠ 0`. -/
theorem sigma1_ne_zero : (σ1 : M2) ≠ 0 := by
  intro h
  have h01 : (σ1 : M2) 0 1 = 0 := by rw [h]; rfl
  simp [σ1] at h01

/-- The linearized node is genuinely nonzero off the crossing (rational witness
`q = (1,0,0)`): `weylHam weylJacobian ![1,0,0] = σ₁ ≠ 0`. -/
theorem linearized_node_axis0_ne_zero : weylHam weylJacobian ![1, 0, 0] ≠ 0 := by
  rw [linearized_node_axis0]; exact sigma1_ne_zero

/-- The **genuine infrared tangent** along the first axis is `-i·σ₁`, and it is
nonzero. This is the derivative-level (not merely coefficient-level) witness. -/
theorem ir_tangent_axis0_ne_zero : ((-I) • σ1 : M2) ≠ 0 := by
  intro h
  have h01 : ((-I) • σ1 : M2) 0 1 = 0 := by rw [h]; rfl
  simp [σ1] at h01

/-! ## §3  Local chirality / orientation `+1`, all sign conventions displayed -/

/-- **Local chirality `+1`.** The Jacobian-sign chirality of the node is
`χ(A) = sign(det A) = +1`. -/
theorem local_chirality_one : chirality weylJacobian = 1 := by
  unfold weylJacobian; exact chirality_one

/-- **Opposite-orientation contrast.** A single-axis reflection has chirality
`-1`, so the `+1` above is a genuine oriented sign, not a normalization
artifact. -/
theorem reflected_chirality_neg_one : chirality reflect = -1 := chirality_reflect

/-- **Every sign convention displayed together.** The exact infrared tangent is
`-i·(A q)·σ` with `A = I₃`; its determinant is `+1`; and the resulting local
chirality/orientation is `+1`.  All four conventions (the `-i` prefactor, the
Pauli ordering `σ₁,σ₂,σ₃` inside `weylHam`, the identity coefficient matrix, and
the positive determinant/chirality) appear in a single statement. -/
theorem ir_weyl_sign_conventions :
    (∀ q : Fin 3 → ℝ,
        HasDerivAt (fun t : ℝ => endpoint (fun i => t * q i))
          ((-I) • weylHam weylJacobian q) 0) ∧
      weylJacobian = 1 ∧ weylJacobian.det = 1 ∧ chirality weylJacobian = 1 := by
  refine ⟨endpoint_ir_tangent_weyl, rfl, weylJacobian_det, local_chirality_one⟩

/-! ## §4  Bridge into the enclosing-sphere degree / Chern shape

The uploaded `WeylSphereChargeBridge` provides the abstract reduction
`deg_eq_chirality` / `chern_eq_chirality` from the standard degree hypotheses
(named hypotheses standing in for the Brouwer-degree / Berry-curvature API that
is absent from the pinned Mathlib).  Because the Pauli conventions match
(`§0`), the reduction composes here with **no** further adapter: the only
missing input is the abstract `deg` (respectively `chern`) itself.

The `blochVec` of this node is the identity self-map of the sphere. -/

/-- The enclosing-sphere Bloch map of the HNU infrared node is the identity on
the unit sphere (the `A = I₃` Bloch map). -/
theorem blochVec_hnu_ir {q : Fin 3 → ℝ} (hq : OnSphere q) :
    blochVec weylJacobian q = q := by
  unfold weylJacobian; exact blochVec_one hq

/-- **Degree bridge for the HNU infrared node.** Under the standard degree hypotheses
(named hypotheses standing in for the missing Brouwer-degree + `GL⁺(3,ℝ)`
connectivity API), the enclosing-sphere degree of this node's Bloch map is `+1`.
This is *not* an unconditional global Brillouin-zone charge: it is exactly the
local Jacobian orientation `+1` transported through the abstract reduction. -/
theorem hnu_ir_node_degree_eq_one
    (deg : M3 → ℤ)
    (deg_id : deg 1 = 1)
    (deg_reflect : deg reflect = -1)
    (deg_pos_det : ∀ A : M3, 0 < A.det → deg A = deg 1)
    (deg_neg_det : ∀ A : M3, A.det < 0 → deg A = deg reflect) :
    deg weylJacobian = 1 := by
  rw [deg_eq_chirality deg deg_id deg_reflect deg_pos_det deg_neg_det weylJacobian
        weylJacobian_det_ne_zero, local_chirality_one]

/-- **Chern bridge for the HNU infrared node.** Adding the separate
first-Chern = degree physics hypothesis (`chern_eq_deg`, the missing
Berry-curvature-integration theorem), the first Chern number of the Berry
eigenline bundle over the enclosing sphere is `+1`.  The degree and Chern
invariants are linked only through the explicit hypothesis. -/
theorem hnu_ir_node_chern_eq_one
    (deg chern : M3 → ℤ)
    (deg_id : deg 1 = 1)
    (deg_reflect : deg reflect = -1)
    (deg_pos_det : ∀ A : M3, 0 < A.det → deg A = deg 1)
    (deg_neg_det : ∀ A : M3, A.det < 0 → deg A = deg reflect)
    (chern_eq_deg : ∀ A : M3, A.det ≠ 0 → chern A = deg A) :
    chern weylJacobian = 1 := by
  rw [chern_eq_chirality deg chern deg_id deg_reflect deg_pos_det deg_neg_det chern_eq_deg
        weylJacobian weylJacobian_det_ne_zero, local_chirality_one]

end

end PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge

/-!
## Build-enforced assumption-footprint guards

Every headline theorem uses only Lean/Mathlib's standard three assumptions:
`propext`, `Classical.choice`, and `Quot.sound`.
-/

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.endpoint_ir_tangent_weyl' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms endpoint_ir_tangent_weyl

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.weylJacobian_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms weylJacobian_det

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.weylJacobian_det_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms weylJacobian_det_ne_zero

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.linearized_node_isolated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms linearized_node_isolated

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.linearized_node_axis0_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms linearized_node_axis0_ne_zero

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.ir_tangent_axis0_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms ir_tangent_axis0_ne_zero

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.local_chirality_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms local_chirality_one

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.ir_weyl_sign_conventions' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms ir_weyl_sign_conventions

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.hnu_ir_node_degree_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnu_ir_node_degree_eq_one

open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge.hnu_ir_node_chern_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms hnu_ir_node_chern_eq_one

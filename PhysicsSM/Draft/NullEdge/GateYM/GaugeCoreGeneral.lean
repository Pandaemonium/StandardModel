import Mathlib

/-!
# Gate YM0/T3: general finite-group gauge core, first definitions

This draft module starts PKG-YM0-B from the overnight YM run. It generalizes the
Z2/Bool gauge-invariance core to arbitrary groups while keeping the convention
choices explicit and small.

Conventions/provenance:
* C-1 from the freeze document
  `AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md`: link variables
  live on positively oriented edges, and reversed traversal uses the group
  inverse.
* Gauge action: `(g.U)_e = g(src e) * U_e * (g(tgt e))^{-1}`.
* Walks are typed by endpoints. A forward step along `e` goes from `src e` to
  `tgt e`; a reverse step goes from `tgt e` to `src e`. This makes
  composability a Lean type invariant rather than a separate predicate.

Current trusted-in-draft content:
* `stepHol_gauge`: one-step gauge covariance.
* `hol_gauge`: telescoping covariance for any typed walk.
* `hol_gauge_closed`: closed-walk holonomy is conjugated at the basepoint.
* `classFunction_hol_gauge_closed`: class functions of closed-walk holonomy are
  gauge invariant.
* `gauge_one` and `gauge_comp`: the local gauge transformations act on link
  configurations.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity** once specialized to finite vertex/link sets;
the definitions themselves do not need finiteness.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace GaugeCoreGeneral

/-- A finite lattice will instantiate this with finite `V` and `E`. The core
gauge-covariance identities do not require finiteness, so the structure itself
keeps only the source and target maps for positively oriented links. -/
structure OrientedLattice where
  V : Type*
  E : Type*
  src : E → V
  tgt : E → V

namespace OrientedLattice

variable (Λ : OrientedLattice)
variable {G : Type*} [Group G]

/-- A link field assigns a group element to every positively oriented link. -/
abbrev LinkField : Type _ := Λ.E → G

/-- Gauge action on a link field:
`(g.U)_e = g(src e) * U_e * (g(tgt e))^{-1}`. -/
def gauge (g : Λ.V → G) (U : Λ.LinkField (G := G)) : Λ.LinkField (G := G) :=
  fun e => g (Λ.src e) * U e * (g (Λ.tgt e))⁻¹

/-- One oriented traversal step. `fwd e` follows the positive orientation of
`e`; `rev e` traverses the same link in reverse and therefore contributes the
inverse holonomy. -/
inductive Step : Λ.V → Λ.V → Type _
  | fwd (e : Λ.E) : Step (Λ.src e) (Λ.tgt e)
  | rev (e : Λ.E) : Step (Λ.tgt e) (Λ.src e)

/-- A typed walk, with composability carried by the endpoint indices. -/
inductive Walk : Λ.V → Λ.V → Type _
  | nil (x : Λ.V) : Walk x x
  | cons {x y z : Λ.V} : Step Λ x y → Walk y z → Walk x z

variable {Λ}

/-- Holonomy contribution of one step. -/
def stepHol (U : Λ.LinkField (G := G)) : {x y : Λ.V} → Step Λ x y → G
  | _, _, Step.fwd e => U e
  | _, _, Step.rev e => (U e)⁻¹

/-- Holonomy of a typed walk, with multiplication parenthesized from the left
by recursion on the list of steps. -/
def hol (U : Λ.LinkField (G := G)) : {x y : Λ.V} → Walk Λ x y → G
  | _, _, Walk.nil _ => 1
  | _, _, Walk.cons s w => stepHol U s * hol U w

/-- One-step gauge covariance. This is where the reverse-step convention
`(U_e)^{-1}` is used. -/
theorem stepHol_gauge (g : Λ.V → G) (U : Λ.LinkField (G := G))
    {x y : Λ.V} (s : Step Λ x y) :
    stepHol (Λ.gauge g U) s = g x * stepHol U s * (g y)⁻¹ := by
  cases s with
  | fwd e =>
      simp [stepHol, OrientedLattice.gauge]
  | rev e =>
      simp [stepHol, OrientedLattice.gauge]
      group

/-- Telescoping gauge covariance for walk holonomy:
`hol(g.U, w) = g(x) * hol(U,w) * g(y)^{-1}` for a walk from `x` to `y`. -/
theorem hol_gauge (g : Λ.V → G) (U : Λ.LinkField (G := G))
    {x y : Λ.V} (w : Walk Λ x y) :
    hol (Λ.gauge g U) w = g x * hol U w * (g y)⁻¹ := by
  induction w with
  | nil x =>
      simp [hol]
  | cons s w ih =>
      rw [hol, hol, stepHol_gauge, ih]
      group

/-- Closed-walk holonomy is conjugated by the gauge value at the basepoint. -/
theorem hol_gauge_closed (g : Λ.V → G) (U : Λ.LinkField (G := G))
    {x : Λ.V} (w : Walk Λ x x) :
    hol (Λ.gauge g U) w = g x * hol U w * (g x)⁻¹ :=
  hol_gauge g U w

/-- Any class function of a closed-walk holonomy is gauge invariant. -/
theorem classFunction_hol_gauge_closed {α : Type*}
    (F : G → α)
    (hclass : ∀ a b : G, F (a * b * a⁻¹) = F b)
    (g : Λ.V → G) (U : Λ.LinkField (G := G))
    {x : Λ.V} (w : Walk Λ x x) :
    F (hol (Λ.gauge g U) w) = F (hol U w) := by
  rw [hol_gauge_closed]
  exact hclass (g x) (hol U w)

/-- The identity gauge transformation fixes every link field. -/
theorem gauge_one (U : Λ.LinkField (G := G)) :
    Λ.gauge (fun _ => (1 : G)) U = U := by
  funext e
  simp [OrientedLattice.gauge]

/-- Gauge transformations compose pointwise. -/
theorem gauge_comp (g h : Λ.V → G) (U : Λ.LinkField (G := G)) :
    Λ.gauge g (Λ.gauge h U) = Λ.gauge (fun v => g v * h v) U := by
  funext e
  simp [OrientedLattice.gauge]
  group

/-- Applying the pointwise inverse gauge transformation undoes `gauge g`. -/
theorem gauge_inv_apply (g : Λ.V → G) (U : Λ.LinkField (G := G)) :
    Λ.gauge (fun v => (g v)⁻¹) (Λ.gauge g U) = U := by
  funext e
  simp [OrientedLattice.gauge]
  group

/-- A fixed gauge transformation is an equivalence of configuration space.
This is the finite change-of-variables core used later for partition-function
and expectation invariance. -/
def gaugeEquiv (g : Λ.V → G) : Λ.LinkField (G := G) ≃ Λ.LinkField (G := G) where
  toFun := Λ.gauge g
  invFun := Λ.gauge (fun v => (g v)⁻¹)
  left_inv U := by
    exact gauge_inv_apply g U
  right_inv U := by
    funext e
    simp [OrientedLattice.gauge]
    group

/-- Finite change of variables under a gauge transformation: summing any
observable after applying a fixed gauge transformation gives the same finite
sum. This is the algebraic core of finite measure invariance. -/
theorem sum_comp_gauge {R : Type*} [AddCommMonoid R]
    [Fintype (Λ.LinkField (G := G))]
    (g : Λ.V → G) (F : Λ.LinkField (G := G) → R) :
    (∑ U, F (Λ.gauge g U)) = ∑ U, F U := by
  simpa [gaugeEquiv] using (Equiv.sum_comp (Λ.gaugeEquiv g) F)

end OrientedLattice

end GaugeCoreGeneral
end GateYM
end NullEdge
end Draft
end PhysicsSM

import PhysicsSM.Draft.NullEdge.FinitePoissonConfigurationInvariance

/-!
# Marked finite-Poisson configuration invariance

Focused Aristotle target.  The landed finite-Poisson theorem proves invariance
of bare random point configurations.  This successor attaches a deterministic
measurable mark to every point and asks for invariance of the complete marked
configuration law under a displayed equivariant product action.

The equivariance hypothesis is intentionally explicit: invariance of the
unmarked point process does not manufacture an invariant decoration.  The
result is finite-volume and distributional; it does not construct an
infinite-volume process, a Lorentz action, or a physical frame field.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace PhysicsSM.Draft.NullEdge.MarkedPoissonConfigurationInvariance

open FinitePoissonConfigurationInvariance

variable {X M : Type*} [MeasurableSpace X] [MeasurableSpace M]

/-- Attach a deterministic mark to one point. -/
def markPoint (d : X -> M) : X -> Prod X M := fun x => (x, d x)

/-- Product action on a marked point. -/
def pointProductMap (T : X -> X) (S : M -> M) : Prod X M -> Prod X M :=
  fun q => (T q.1, S q.2)

/-- One-point graph law induced by a base position law and a deterministic
decoration. -/
def markedPointLaw (P : Measure X) (d : X -> M) : Measure (Prod X M) :=
  P.map (markPoint d)

/-- Mixed-Poisson law of finite configurations of marked points. -/
def markedConfigLaw (r : NNReal) (P : Measure X) (d : X -> M) :
    Measure (Config (Prod X M)) :=
  configLaw r (markedPointLaw P d)

/-- Pointwise action induced on a finite marked configuration. -/
def markedConfigMap (T : X -> X) (S : M -> M) :
    Config (Prod X M) -> Config (Prod X M) :=
  configMap (pointProductMap T S)

lemma measurable_markPoint (d : X -> M) (hd : Measurable d) :
    Measurable (markPoint d) := by
  fun_prop

lemma measurable_pointProductMap (T : X -> X) (S : M -> M)
    (hT : Measurable T) (hS : Measurable S) :
    Measurable (pointProductMap T S) := by
  fun_prop

/-- An equivariant deterministic graph law is preserved by the product
action whenever the underlying position law is preserved. -/
theorem markedPointLaw_measurePreserving
    (P : Measure X) [IsProbabilityMeasure P]
    (T : X -> X) (S : M -> M) (d : X -> M)
    (hT : MeasurePreserving T P P) (hS : Measurable S)
    (hd : Measurable d) (heq : forall x, d (T x) = S (d x)) :
    MeasurePreserving (pointProductMap T S)
      (markedPointLaw P d) (markedPointLaw P d) := by
  sorry

/-- **Marked mixed-Poisson invariance.** Equivariance of the pointwise mark
upgrades base-law invariance to invariance of the entire random finite marked
configuration, including the Poisson count mixture. -/
theorem markedConfigLaw_invariant
    (r : NNReal) (P : Measure X) [IsProbabilityMeasure P]
    (T : X -> X) (S : M -> M) (d : X -> M)
    (hT : MeasurePreserving T P P) (hS : Measurable S)
    (hd : Measurable d) (heq : forall x, d (T x) = S (d x)) :
    Measure.map (markedConfigMap T S) (markedConfigLaw r P d) =
      markedConfigLaw r P d := by
  sorry

/-! ## Non-degeneracy and boundary controls -/

/-- The product action need not be the identity: simultaneous Boolean
complement moves a concrete marked point. -/
theorem bool_product_action_nontrivial :
    pointProductMap Bool.not Bool.not (false, false) = (true, true) := by
  rfl

/-- With identity transformations, every measurable decoration satisfies the
equivariance condition used by the capstone. -/
theorem identity_decoration_equivariant (d : X -> M) :
    forall x, d (id x) = id (d x) := by
  simp

end PhysicsSM.Draft.NullEdge.MarkedPoissonConfigurationInvariance

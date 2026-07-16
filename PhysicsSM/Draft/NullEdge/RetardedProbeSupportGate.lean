import PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

/-!
# Intrinsic retarded support and the rank-four availability gate

The intrinsic-probe benchmark identified an order-side obstruction before any
target metric is inspected: a candidate probe sector must be visible in a
two-sided interior retarded shell at the marked event. This module formalizes
that necessary finite condition.

All selector inputs are natural-number count windows. `pastAbundance` and
`futureAbundance` count events in a prescribed interval-cardinality band. A
two-sided interior event has at least a prescribed abundance in both
directions. The retarded shell of a marked event then consists of interior
predecessors in a second count band. Every definition is transported exactly
by finite-order isomorphisms.

For a probe subspace `P`, shell visibility means that restriction to the shell
is injective: no nonzero probe direction is invisible on every shell event.
Finite-dimensional linear algebra then gives the exact necessary bound

`finrank P <= shell.card`.

Consequently, a rank-four probe sector cannot pass even the qualitative
support gate when the retarded shell has fewer than four events. This is the
kernel-checked form of the availability check used before generalized
Rayleigh-quotient coverage is scored. It is necessary, not sufficient:
cardinality four does not establish quantitative coverage, product quality,
Lorentzian inertia, metric accuracy, or continuum convergence.

Claim grade: `M [orig/comp]`. Provenance: program-internal formalization of the
pre-registered two-sided interior and retarded-support architecture recorded in
`AgentTasks/null-edge-intrinsic-probe-stage-a3-support-benchmark-2026-07-15.md`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate

open FiniteCausalOrderOperator
open IntrinsicProbeSubspace

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## Order-only two-sided retarded shells -/

/-- Natural-number count windows for the interior and retarded-shell tests.
The counts use `openIntervalCount + 1`, matching the inclusive interval-size
normalization in the numerical support audit. -/
structure RetardedSupportWindow where
  interiorLower : Nat
  interiorUpper : Nat
  minimumAbundance : Nat
  shellLower : Nat
  shellUpper : Nat
  deriving DecidableEq

/-- The inclusive interval size lies in a supplied natural-number band. -/
def intervalCountInBand
    (C : FiniteCausalOrder V) (lower upper : Nat) (y x : V) : Prop :=
  lower ≤ C.openIntervalCount y x + 1 ∧
    C.openIntervalCount y x + 1 ≤ upper

instance intervalCountInBandDecidable
    (C : FiniteCausalOrder V) (lower upper : Nat) (y x : V) :
    Decidable (intervalCountInBand C lower upper y x) := by
  unfold intervalCountInBand
  infer_instance

/-- Count-band membership is intrinsic under order isomorphisms. -/
theorem intervalCountInBand_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (lower upper : Nat) (y x : V) :
    intervalCountInBand D lower upper (e.toEquiv y) (e.toEquiv x) ↔
      intervalCountInBand C lower upper y x := by
  simp [intervalCountInBand, e.openIntervalCount_eq]

/-- Number of predecessors in the supplied interval-count band. -/
def pastAbundance
    (C : FiniteCausalOrder V) (lower upper : Nat) (x : V) : Nat :=
  Fintype.card
    {y : V // C.before y x ∧ intervalCountInBand C lower upper y x}

/-- Number of successors in the supplied interval-count band. -/
def futureAbundance
    (C : FiniteCausalOrder V) (lower upper : Nat) (x : V) : Nat :=
  Fintype.card
    {z : V // C.before x z ∧ intervalCountInBand C lower upper x z}

/-- Past abundance is exactly preserved by every order isomorphism. -/
theorem pastAbundance_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (lower upper : Nat) (x : V) :
    pastAbundance D lower upper (e.toEquiv x) =
      pastAbundance C lower upper x := by
  unfold pastAbundance
  symm
  apply Fintype.card_congr
  exact
    { toFun := fun y => ⟨e.toEquiv y.1,
        (e.map_before_iff y.1 x).2 y.2.1,
        (intervalCountInBand_map_iff e lower upper y.1 x).2 y.2.2⟩
      invFun := fun z => ⟨e.toEquiv.symm z.1,
        (e.map_before_iff (e.toEquiv.symm z.1) x).1 (by simpa using z.2.1),
        (intervalCountInBand_map_iff e lower upper
          (e.toEquiv.symm z.1) x).1 (by simpa using z.2.2)⟩
      left_inv := by
        intro y
        apply Subtype.ext
        simp
      right_inv := by
        intro z
        apply Subtype.ext
        simp }

/-- Future abundance is exactly preserved by every order isomorphism. -/
theorem futureAbundance_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (lower upper : Nat) (x : V) :
    futureAbundance D lower upper (e.toEquiv x) =
      futureAbundance C lower upper x := by
  unfold futureAbundance
  symm
  apply Fintype.card_congr
  exact
    { toFun := fun z => ⟨e.toEquiv z.1,
        (e.map_before_iff x z.1).2 z.2.1,
        (intervalCountInBand_map_iff e lower upper x z.1).2 z.2.2⟩
      invFun := fun z => ⟨e.toEquiv.symm z.1,
        (e.map_before_iff x (e.toEquiv.symm z.1)).1 (by simpa using z.2.1),
        (intervalCountInBand_map_iff e lower upper
          x (e.toEquiv.symm z.1)).1 (by simpa using z.2.2)⟩
      left_inv := by
        intro z
        apply Subtype.ext
        simp
      right_inv := by
        intro z
        apply Subtype.ext
        simp }

/-- An event is in the count-defined two-sided interior when both its past and
future band abundances meet the supplied threshold. -/
def TwoSidedInterior
    (C : FiniteCausalOrder V) (window : RetardedSupportWindow) (x : V) : Prop :=
  window.minimumAbundance ≤
      pastAbundance C window.interiorLower window.interiorUpper x ∧
    window.minimumAbundance ≤
      futureAbundance C window.interiorLower window.interiorUpper x

instance twoSidedInteriorDecidable
    (C : FiniteCausalOrder V) (window : RetardedSupportWindow) (x : V) :
    Decidable (TwoSidedInterior C window x) := by
  unfold TwoSidedInterior
  infer_instance

/-- Two-sided interior membership is intrinsic under order isomorphisms. -/
theorem twoSidedInterior_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (window : RetardedSupportWindow) (x : V) :
    TwoSidedInterior D window (e.toEquiv x) ↔
      TwoSidedInterior C window x := by
  simp [TwoSidedInterior, pastAbundance_equivariant,
    futureAbundance_equivariant]

/-- Intrinsic retarded shell at a marked event: two-sided-interior
predecessors in the shell interval-count band. -/
def retardedShell
    (C : FiniteCausalOrder V) (window : RetardedSupportWindow) (x : V) :
    Finset V :=
  Finset.univ.filter fun y =>
    C.before y x ∧ TwoSidedInterior C window y ∧
      intervalCountInBand C window.shellLower window.shellUpper y x

@[simp] theorem mem_retardedShell
    (C : FiniteCausalOrder V) (window : RetardedSupportWindow) (x y : V) :
    y ∈ retardedShell C window x ↔
      C.before y x ∧ TwoSidedInterior C window y ∧
        intervalCountInBand C window.shellLower window.shellUpper y x := by
  simp [retardedShell]

/-- Retarded-shell membership is exactly transported by an order
isomorphism. -/
theorem mem_retardedShell_map_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (window : RetardedSupportWindow) (x y : V) :
    e.toEquiv y ∈ retardedShell D window (e.toEquiv x) ↔
      y ∈ retardedShell C window x := by
  simp [e.map_before_iff, twoSidedInterior_map_iff,
    intervalCountInBand_map_iff]

/-- The source and target retarded shells are equivalent as finite types. -/
def retardedShellEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (window : RetardedSupportWindow) (x : V) :
    ↥(retardedShell C window x) ≃
      ↥(retardedShell D window (e.toEquiv x)) where
  toFun y := ⟨e.toEquiv y.1,
    (mem_retardedShell_map_iff e window x y.1).2 y.2⟩
  invFun z := ⟨e.toEquiv.symm z.1, by
    apply (mem_retardedShell_map_iff e window x (e.toEquiv.symm z.1)).1
    simpa only [Equiv.apply_symm_apply] using z.2⟩
  left_inv y := by
    apply Subtype.ext
    simp
  right_inv z := by
    apply Subtype.ext
    simp

/-- Retarded-shell cardinality is a relabeling invariant. -/
theorem retardedShell_card_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (window : RetardedSupportWindow) (x : V) :
    (retardedShell D window (e.toEquiv x)).card =
      (retardedShell C window x).card := by
  rw [← Fintype.card_coe, ← Fintype.card_coe]
  exact (Fintype.card_congr (retardedShellEquiv e window x)).symm

/-! ## Probe visibility and the dimension obstruction -/

/-- Restrict a scalar-probe subspace to a finite set of events. -/
def probeRestrictionLinearMap
    (P : Submodule Real (V → Real)) (S : Finset V) :
    P →ₗ[Real] (↥S → Real) where
  toFun phi := fun x => phi.1 x.1
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- A shell separates a probe subspace when no two probe directions have the
same restriction to that shell. Equivalently, no nonzero direction is entirely
invisible there. -/
def ShellSeparates
    (P : Submodule Real (V → Real)) (S : Finset V) : Prop :=
  Function.Injective (probeRestrictionLinearMap P S)

omit [Fintype V] in
/-- An injective shell restriction bounds probe dimension by shell
cardinality. -/
theorem finrank_le_card_of_shellSeparates
    (P : Submodule Real (V → Real)) (S : Finset V)
    (hseparates : ShellSeparates P S) :
    Module.finrank Real P ≤ S.card := by
  have hdim :=
    (probeRestrictionLinearMap P S).finrank_le_finrank_of_injective hseparates
  simpa [Module.finrank_pi] using hdim

omit [Fintype V] in
/-- A rank-four probe sector visible on a shell forces at least four shell
events. -/
theorem four_le_card_of_rankFour_shellSeparates
    (P : Submodule Real (V → Real)) (S : Finset V)
    (hrank : 4 ≤ Module.finrank Real P)
    (hseparates : ShellSeparates P S) :
    4 ≤ S.card :=
  hrank.trans (finrank_le_card_of_shellSeparates P S hseparates)

/-- The qualitative shell-separation gate is invariant for every intrinsic
probe-subspace sector under simultaneous transport of order, marked event, and
shell. -/
theorem shellSeparates_intrinsic_map_iff
    (P : IntrinsicProbeSubspaceSector)
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (window : RetardedSupportWindow) (x : V) :
    ShellSeparates (P.space D)
        (retardedShell D window (e.toEquiv x)) ↔
      ShellSeparates (P.space C) (retardedShell C window x) := by
  let E := P.spaceLinearEquiv e
  let shellEquiv := retardedShellEquiv e window x
  constructor
  · intro hD f g hfg
    apply E.injective
    apply hD
    funext z
    let y : ↥(retardedShell C window x) := shellEquiv.symm z
    have hy := congrFun hfg y
    simpa [E, shellEquiv, probeRestrictionLinearMap,
      IntrinsicProbeSubspaceSector.spaceLinearEquiv,
      fieldRelabelLinearEquiv, OrderIso.relabelField] using hy
  · intro hC f g hfg
    apply E.symm.injective
    apply hC
    funext y
    have hy := congrFun hfg (shellEquiv y)
    simpa [E, shellEquiv, probeRestrictionLinearMap,
      IntrinsicProbeSubspaceSector.spaceLinearEquiv,
      fieldRelabelLinearEquiv, OrderIso.relabelField] using hy

/-- A four-probe frame on the existing zero-sum carrier sector can pass the
qualitative retarded-shell gate only if that intrinsic carrier shell has at
least four events. -/
theorem carrierProbeFrame_requires_four_shell_events
    {C : FiniteCausalOrder V} (A : AlexandrovAlgebraGerm.MarkedDiamond C)
    (window : RetardedSupportWindow)
    (x : AlexandrovGermInternalOperator.ClosedCarrier A)
    (b : ProbeFrameLorentzGauge.CarrierProbeFrame A)
    (hseparates : ShellSeparates (carrierProbeSubspace A)
      (retardedShell (AlexandrovGermInternalOperator.inducedOrder A) window x)) :
    4 ≤ (retardedShell
      (AlexandrovGermInternalOperator.inducedOrder A) window x).card := by
  apply four_le_card_of_rankFour_shellSeparates (carrierProbeSubspace A)
    (retardedShell (AlexandrovGermInternalOperator.inducedOrder A) window x)
  · have hrank := Module.finrank_eq_card_basis b
    simpa using hrank.ge
  · exact hseparates

/-- **G2 retarded-support availability obstruction.** If the intrinsic shell
has fewer than four events, no rank-four probe subspace can be separated by
that shell. This rules out positive worst-direction shell coverage before any
metric or signature target is opened. -/
theorem retardedShell_card_lt_four_forbids_rankFour
    (C : FiniteCausalOrder V) (window : RetardedSupportWindow) (x : V)
    (hcard : (retardedShell C window x).card < 4) :
    ¬ ∃ P : Submodule Real (V → Real),
      4 ≤ Module.finrank Real P ∧
        ShellSeparates P (retardedShell C window x) := by
  rintro ⟨P, hrank, hseparates⟩
  have hfour := four_le_card_of_rankFour_shellSeparates P
    (retardedShell C window x) hrank hseparates
  omega

/-! ## Sharp finite control -/

/-- Five-event order with four incomparable leaves strictly before one top
event. -/
def fourLeafPastOrder : FiniteCausalOrder (Fin 5) where
  before := fun y x => y.1 < 4 ∧ x = 4
  decidableBefore := inferInstance
  irrefl := by
    intro x hx
    omega
  trans := by
    intro x y z hxy hyz
    omega

/-- Minimal window exposing all four leaves at the top event. The zero
abundance threshold makes this only a sharpness control, not a physical
interior prescription. -/
def fourLeafSupportWindow : RetardedSupportWindow where
  interiorLower := 0
  interiorUpper := 0
  minimumAbundance := 0
  shellLower := 1
  shellUpper := 1

/-- The rank bound is sharp: the four-leaf shell has cardinality four and
separates the rank-four zero-sum sector on five events. -/
theorem fourLeaf_rankFour_visible_witness :
    Module.finrank Real (zeroSumFieldSubspace (Fin 5)) = 4 ∧
      (retardedShell fourLeafPastOrder fourLeafSupportWindow 4).card = 4 ∧
      ShellSeparates (zeroSumFieldSubspace (Fin 5))
        (retardedShell fourLeafPastOrder fourLeafSupportWindow 4) := by
  have hshell :
      (retardedShell fourLeafPastOrder fourLeafSupportWindow 4).card = 4 := by
    decide
  refine ⟨finrank_fiveEvent_zeroSum, hshell, ?_⟩
  intro f g hfg
  have h0 := congrFun hfg
    (⟨0, by decide⟩ : ↥(retardedShell
      fourLeafPastOrder fourLeafSupportWindow 4))
  have h1 := congrFun hfg
    (⟨1, by decide⟩ : ↥(retardedShell
      fourLeafPastOrder fourLeafSupportWindow 4))
  have h2 := congrFun hfg
    (⟨2, by decide⟩ : ↥(retardedShell
      fourLeafPastOrder fourLeafSupportWindow 4))
  have h3 := congrFun hfg
    (⟨3, by decide⟩ : ↥(retardedShell
      fourLeafPastOrder fourLeafSupportWindow 4))
  change f.1 0 = g.1 0 at h0
  change f.1 1 = g.1 1 at h1
  change f.1 2 = g.1 2 at h2
  change f.1 3 = g.1 3 at h3
  have hsumf : ∑ i : Fin 5, f.1 i = 0 := f.2
  have hsumg : ∑ i : Fin 5, g.1 i = 0 := g.2
  have h4 : f.1 4 = g.1 4 := by
    rw [Fin.sum_univ_castSucc] at hsumf hsumg
    have hprefix :
        (∑ i : Fin 4, f.1 i.castSucc) =
          ∑ i : Fin 4, g.1 i.castSucc := by
      apply Finset.sum_congr rfl
      intro i _
      fin_cases i
      · exact h0
      · exact h1
      · exact h2
      · exact h3
    have hlast : f.1 (Fin.last 4) = g.1 (Fin.last 4) := by
      linear_combination hsumf - hsumg - hprefix
    exact hlast
  apply Subtype.ext
  funext i
  fin_cases i
  · exact h0
  · exact h1
  · exact h2
  · exact h3
  · exact h4

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.retardedShell_card_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.retardedShell_card_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.retardedShell_card_lt_four_forbids_rankFour' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.retardedShell_card_lt_four_forbids_rankFour

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.shellSeparates_intrinsic_map_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.shellSeparates_intrinsic_map_iff

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.carrierProbeFrame_requires_four_shell_events' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.carrierProbeFrame_requires_four_shell_events

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.fourLeaf_rankFour_visible_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate.fourLeaf_rankFour_visible_witness

end PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate

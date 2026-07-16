import PhysicsSM.Draft.NullEdge.RetardedProbeSupportGate

/-!
# Arbitrarily large fixed-interval retarded shells

`RetardedProbeSupportGate` proves that shell cardinality is a necessary bound
on visible probe rank. This module records the complementary locality warning:
shell cardinality is not itself a local-scale observable.

For every natural number `n`, an explicit finite causal order has `n` source
events in the same minimal inclusive interval-count band before one marked
event. Every source satisfies a nonzero two-sided abundance threshold, yet the
marked retarded shell has cardinality exactly `n`. Every shell source has zero
events in its open interval to the mark.

Thus a fixed interval-count band and nonzero interior abundance do not impose
an upper bound on shell population. In the continuum interpretation this is
the finite combinatorial counterpart of the noncompact rapidity direction of
a Lorentz-invariant timelike shell. The theorem does not identify a continuum
limit; it prevents shell cardinality alone from being presented as locality or
as a convergent cotangent-sector construction.

Claim grade: `M [orig]`. Provenance: finite abstraction of the Stage A3c
fixed-density larger-diamond boundary control recorded in
`AgentTasks/null-edge-causal-larger-diamond-support-stage-a3c-benchmark-2026-07-16.md`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.RetardedShellInfraredNoGo

open FiniteCausalOrderOperator
open RetardedProbeSupportGate

/-- Three-level event type: one private bottom and one shell source for each
index, followed by a common marked event. -/
inductive InfraredShellEvent (n : Nat) where
  | bottom : Fin n -> InfraredShellEvent n
  | source : Fin n -> InfraredShellEvent n
  | mark : InfraredShellEvent n
  deriving DecidableEq, Fintype

/-- Transitive three-level order used by the arbitrary-cardinality witness. -/
def infraredBefore {n : Nat} :
    InfraredShellEvent n -> InfraredShellEvent n -> Prop
  | .bottom i, .source j => i = j
  | .bottom _, .mark => True
  | .source _, .mark => True
  | _, _ => False

instance infraredBeforeDecidable {n : Nat} :
    DecidableRel (infraredBefore (n := n)) := by
  intro x y
  classical
  infer_instance

/-- Finite strict causal order with replicated private bottoms and one common
mark. -/
def infraredShellOrder (n : Nat) : FiniteCausalOrder (InfraredShellEvent n) where
  before := infraredBefore
  decidableBefore := infraredBeforeDecidable
  irrefl := by
    intro x
    cases x <;> simp [infraredBefore]
  trans := by
    intro x y z hxy hyz
    cases x <;> cases y <;> cases z <;> simp_all [infraredBefore]

/-- The fixed window has a genuinely nonzero past/future abundance threshold
and selects only causal links into the marked shell. -/
def infraredSupportWindow : RetardedSupportWindow where
  interiorLower := 1
  interiorUpper := 1
  minimumAbundance := 1
  shellLower := 1
  shellUpper := 1

@[simp] theorem source_mark_openIntervalCount
    {n : Nat} (i : Fin n) :
    (infraredShellOrder n).openIntervalCount
      (.source i) .mark = 0 := by
  rw [FiniteCausalOrder.openIntervalCount, Fintype.card_eq_zero_iff]
  refine ⟨?_⟩
  intro z
  rcases z with ⟨z, hz⟩
  cases z <;> simp_all [infraredShellOrder, infraredBefore]

@[simp] theorem bottom_source_openIntervalCount
    {n : Nat} (i : Fin n) :
    (infraredShellOrder n).openIntervalCount
      (.bottom i) (.source i) = 0 := by
  rw [FiniteCausalOrder.openIntervalCount, Fintype.card_eq_zero_iff]
  refine ⟨?_⟩
  intro z
  rcases z with ⟨z, hz⟩
  cases z <;> simp_all [infraredShellOrder, infraredBefore]

/-- Each replicated source passes the nonzero two-sided interior test. -/
theorem source_twoSidedInterior
    {n : Nat} (i : Fin n) :
    TwoSidedInterior (infraredShellOrder n) infraredSupportWindow
      (.source i) := by
  constructor
  · change 1 ≤ Fintype.card
      {y // (infraredShellOrder n).before y (.source i) ∧
        intervalCountInBand (infraredShellOrder n) 1 1 y (.source i)}
    exact Fintype.card_pos_iff.mpr ⟨⟨.bottom i, by
      refine ⟨by simp [infraredShellOrder, infraredBefore], ?_⟩
      simp [intervalCountInBand, bottom_source_openIntervalCount]⟩⟩
  · change 1 ≤ Fintype.card
      {z // (infraredShellOrder n).before (.source i) z ∧
        intervalCountInBand (infraredShellOrder n) 1 1 (.source i) z}
    exact Fintype.card_pos_iff.mpr ⟨⟨.mark, by
      refine ⟨by simp [infraredShellOrder, infraredBefore], ?_⟩
      simp [intervalCountInBand, source_mark_openIntervalCount]⟩⟩

@[simp] theorem source_mem_retardedShell
    {n : Nat} (i : Fin n) :
    InfraredShellEvent.source i ∈
      retardedShell (infraredShellOrder n) infraredSupportWindow .mark := by
  rw [mem_retardedShell]
  exact ⟨by simp [infraredShellOrder, infraredBefore],
    source_twoSidedInterior i,
    by simp [intervalCountInBand, infraredSupportWindow]⟩

/-- A private bottom has its source in the open interval to the mark, so it is
outside the minimal shell band. -/
theorem bottom_not_mem_retardedShell
    {n : Nat} (i : Fin n) :
    InfraredShellEvent.bottom i ∉
      retardedShell (infraredShellOrder n) infraredSupportWindow .mark := by
  rw [mem_retardedShell]
  rintro ⟨_, _, hband⟩
  have hpositive :
      1 ≤ (infraredShellOrder n).openIntervalCount (.bottom i) .mark := by
    rw [FiniteCausalOrder.openIntervalCount]
    exact Fintype.card_pos_iff.mpr ⟨⟨.source i, by
      simp [infraredShellOrder, infraredBefore]⟩⟩
  simp only [intervalCountInBand] at hband
  change 1 ≤ (infraredShellOrder n).openIntervalCount (.bottom i) .mark + 1 ∧
    (infraredShellOrder n).openIntervalCount (.bottom i) .mark + 1 ≤ 1 at hband
  omega

@[simp] theorem mark_not_mem_retardedShell (n : Nat) :
    InfraredShellEvent.mark ∉
      retardedShell (infraredShellOrder n) infraredSupportWindow .mark := by
  rw [mem_retardedShell]
  simp [infraredShellOrder, infraredBefore]

/-- The marked shell is exactly the image of the `n` replicated sources. -/
theorem retardedShell_eq_source_image (n : Nat) :
    retardedShell (infraredShellOrder n) infraredSupportWindow .mark =
      Finset.univ.image InfraredShellEvent.source := by
  ext y
  constructor
  · intro hy
    cases y with
    | bottom i => exact (bottom_not_mem_retardedShell i hy).elim
    | source i => simp
    | mark => exact (mark_not_mem_retardedShell n hy).elim
  · intro hy
    simp only [Finset.mem_image] at hy
    rcases hy with ⟨i, _, rfl⟩
    exact source_mem_retardedShell i

/-- **Fixed-interval shell-cardinality no-go.** For every `n`, a fixed
inclusive interval-count band and a nonzero two-sided abundance threshold allow
a marked retarded shell of cardinality exactly `n`; every shell member has
open-interval count zero to the mark. -/
theorem arbitrarily_large_fixedInterval_shell (n : Nat) :
    (retardedShell
        (infraredShellOrder n) infraredSupportWindow .mark).card = n ∧
      ∀ y ∈ retardedShell
          (infraredShellOrder n) infraredSupportWindow .mark,
        (infraredShellOrder n).openIntervalCount y .mark = 0 := by
  constructor
  · rw [retardedShell_eq_source_image,
      Finset.card_image_of_injective]
    · simp
    · intro i j hij
      cases hij
      rfl
  · intro y hy
    rw [retardedShell_eq_source_image] at hy
    simp only [Finset.mem_image] at hy
    rcases hy with ⟨i, _, rfl⟩
    exact source_mark_openIntervalCount i

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.RetardedShellInfraredNoGo.arbitrarily_large_fixedInterval_shell' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RetardedShellInfraredNoGo.arbitrarily_large_fixedInterval_shell

end PhysicsSM.Draft.NullEdge.RetardedShellInfraredNoGo

import PhysicsSM.Draft.NullEdge.FloquetMicromotionSchedule

/-!
# Exact causal exhaustion for finite open updates

This module isolates the algebraic content of the OD5 open-diamond experiment.
Two finite update matrices may have different boundaries and different spectra.
If they agree on every backward causal layer of a chosen interior region, and
the initial states agree on the last layer, then their finite-time interior
amplitudes agree exactly.

The list of regions is ordered from observation region to initial-data region.
`evolveAlong A f [S0, S1, ..., St]` applies `A` exactly `t` times.  The local
condition says that every nonzero matrix entry feeding a site in `Sn` comes
from `S(n+1)`, and that the two updates have the same entry there.

Scope: finite matrix algebra only.  This is not a Dirac continuum limit, a
single-Weyl theorem, a boundary spectral-gap theorem, or a statement that
physical spacetime has a boundary.  It proves that boundary spectra cannot
affect an observable before the declared causal cone reaches them.

Provenance: clean-room finite-propagation lemma motivated by the directed-edge
open-diamond oracle in `Scripts/experiments/directed_edge_open_diamond.py`.
-/

noncomputable section

open Matrix

namespace PhysicsSM.Draft.NullEdge.OpenDiamondCausalExhaustion

variable {V : Type*} [Fintype V]

/-- The two update matrices agree on every nonzero transition feeding `inner`,
and all such predecessors lie in the next backward causal layer. -/
def LocalAgreement (A B : Matrix V V Complex) (inner next : Set V) : Prop :=
  ∀ i, i ∈ inner → ∀ j,
    (A i j ≠ 0 ∨ B i j ≠ 0) → j ∈ next ∧ A i j = B i j

/-- Compatibility data for a complete backward causal-region chain. -/
def CausalChain (A B : Matrix V V Complex) (f g : V → Complex) :
    List (Set V) → Prop
  | [] => True
  | [S] => ∀ i, i ∈ S → f i = g i
  | S :: T :: tail =>
      LocalAgreement A B S T ∧ CausalChain A B f g (T :: tail)

/-- Apply one update for every link in a causal-region chain. -/
def evolveAlong (A : Matrix V V Complex) (f : V → Complex) :
    List (Set V) → V → Complex
  | [] => f
  | [_] => f
  | _ :: T :: tail => A *ᵥ evolveAlong A f (T :: tail)

/-- **Exact finite-time interior exhaustion.** Updates that agree throughout a
backward causal chain give identical amplitudes on its observation region. -/
theorem evolveAlong_eq_on_head (A B : Matrix V V Complex) (f g : V → Complex) :
    ∀ regions : List (Set V),
      CausalChain A B f g regions →
      ∀ i, i ∈ regions.headD ∅ →
        evolveAlong A f regions i = evolveAlong B g regions i := by
  intro regions
  induction regions with
  | nil =>
      intro _ i hi
      simp at hi
  | cons S regions ih =>
      cases regions with
      | nil =>
          intro hchain i hi
          exact hchain i (by simpa using hi)
      | cons T tail =>
          intro hchain i hi
          rcases hchain with ⟨hlocal, htail⟩
          simp only [evolveAlong]
          apply Finset.sum_congr rfl
          intro j _
          by_cases hzero : A i j = 0 ∧ B i j = 0
          · simp [hzero.1, hzero.2]
          · have hnz : A i j ≠ 0 ∨ B i j ≠ 0 := by tauto
            obtain ⟨hjT, hij⟩ := hlocal i (by simpa using hi) j hnz
            have hfuture := ih htail j (by simpa using hjT)
            change A i j * evolveAlong A f (T :: tail) j =
              B i j * evolveAlong B g (T :: tail) j
            rw [hij, hfuture]

/-! ## Non-vacuous two-layer fixture -/

/-- One-site identity update used to witness the theorem with a nonempty cone. -/
def singletonUpdate : Matrix (Fin 1) (Fin 1) Complex := 1

/-- A one-step nonempty causal chain satisfies the compatibility predicate. -/
theorem singleton_causal_chain :
    CausalChain singletonUpdate singletonUpdate (fun _ => 1) (fun _ => 1)
      [Set.univ, Set.univ] := by
  constructor
  · intro i _ j _
    exact ⟨Set.mem_univ j, rfl⟩
  · intro i _
    rfl

/-- The exact exhaustion theorem has a concrete nonzero one-step instance. -/
theorem singleton_exhaustion_witness :
    evolveAlong singletonUpdate (fun _ => 1) [Set.univ, Set.univ] 0 = 1 := by
  simp [evolveAlong, singletonUpdate, Matrix.mulVec, dotProduct]

/-! ## Off-cone difference control -/

/-- A two-site update with one transition feeding the observation site. -/
def boundaryUpdateA : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 0, 0]

/-- A globally different update with the same row feeding the observation site. -/
def boundaryUpdateB : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]

/-- The two updates agree on the declared one-step backward cone. -/
theorem boundaryUpdates_causal_chain :
    CausalChain boundaryUpdateA boundaryUpdateB (fun _ => 1) (fun _ => 1)
      [({0} : Set (Fin 2)), ({1} : Set (Fin 2))] := by
  constructor
  · intro i hi j hnz
    have hi0 : i = 0 := by simpa using hi
    subst i
    fin_cases j
    · simp [boundaryUpdateA, boundaryUpdateB] at hnz
    · exact ⟨by simp, by simp [boundaryUpdateA, boundaryUpdateB]⟩
  · intro i _
    rfl

/-- The updates differ outside the cone while their protected interior
one-step amplitudes remain exactly equal. -/
theorem outside_cone_difference_witness :
    boundaryUpdateA ≠ boundaryUpdateB ∧
      evolveAlong boundaryUpdateA (fun _ => 1)
          [({0} : Set (Fin 2)), ({1} : Set (Fin 2))] 0 =
        evolveAlong boundaryUpdateB (fun _ => 1)
          [({0} : Set (Fin 2)), ({1} : Set (Fin 2))] 0 := by
  constructor
  · intro h
    have h10 := congr_fun (congr_fun h 1) 0
    norm_num [boundaryUpdateA, boundaryUpdateB] at h10
  · exact evolveAlong_eq_on_head boundaryUpdateA boundaryUpdateB
      (fun _ => 1) (fun _ => 1)
      [({0} : Set (Fin 2)), ({1} : Set (Fin 2))]
      boundaryUpdates_causal_chain 0 (by simp)

/-- info: 'PhysicsSM.Draft.NullEdge.OpenDiamondCausalExhaustion.evolveAlong_eq_on_head' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms evolveAlong_eq_on_head

/-- info: 'PhysicsSM.Draft.NullEdge.OpenDiamondCausalExhaustion.singleton_exhaustion_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms singleton_exhaustion_witness

/-- info: 'PhysicsSM.Draft.NullEdge.OpenDiamondCausalExhaustion.outside_cone_difference_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms outside_cone_difference_witness

end PhysicsSM.Draft.NullEdge.OpenDiamondCausalExhaustion

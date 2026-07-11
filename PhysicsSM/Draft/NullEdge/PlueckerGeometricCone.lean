import Mathlib
import PhysicsSM.Draft.NullEdge.PlueckerCausalCone

/-!
# Geometric (bounded-radius) causal cone for a local Pluecker pair-kick schedule

`PlueckerCausalCone` proved *scheduled* CAR-support propagation: after a block
schedule `ms` an observable is `CARSupported (coneRegion ms R)`, where
`coneRegion` unions **every** scheduled block into the cone.  As the semantic
audits note, that is not bounded-speed locality: a `Block` is an arbitrary
four-mode embedding `Fin 4 ↪ ι`, a schedule may name blocks arbitrarily far from
the current front, and unioning all of them says nothing geometric.

This module repairs that with the smallest exact **geometric** theorem.

A schedule here is a `List (Block ι)` interpreted as a **sequential** stream of
local gates (one gate applied after another), *not* a list of parallel
brickwork layers.  Consequently the bound below counts *sequential local gates*,
not synchronized layers; the `t` appearing in `ballIter N t` is `ms.length`, the
number of sequential gates.  (A per-layer theorem would additionally require a
`Layer` of pairwise-disjoint blocks; that refinement is not proved here.)

* `ballStep N`, `ballIter N t` : a graph/chain neighborhood expansion built from a
  closed, reflexive neighborhood map `N : ι → Finset ι`.  `ballIter N t R` is the
  `t`-fold neighborhood of `R`.
* `BlockLocal N m` : the *local schedule condition* tying each acted block to one
  neighborhood step — if `block m` touches a region `S` then
  `block m ⊆ ballStep N S`.  (For a contiguous chain block of diameter `d` this
  holds for the radius-`d` chain neighborhood.)
* `reachStep`, `reachCone` : the **disjoint-drop** cone.  Using exact
  disjoint-gate invariance (`heisenStep_outside_cone`), a gate whose block is
  disjoint from the current front is exactly invariant and does **not** enter the
  cone.  Distant blocks are thus pruned, unlike `coneRegion`.
* `heisenFoldBlocks_reachCone` : scheduled CAR-support propagation on the pruned
  cone (needs the unit-phase involutivity hypothesis to invoke exact invariance).
* `reachCone_subset_ballIter` : the geometric bound — after a schedule of local
  gates the pruned cone lies in the `ms.length`-fold neighborhood.
* `heisenFoldBlocks_geometric_cone` : the headline — after a schedule of
  `t = ms.length` sequential local gates a `CARSupported R` observable is
  `CARSupported (ballIter N t R)`, a bounded-radius causal cone: support
  propagates at most one neighborhood step per sequential gate.
* `heisenFoldBlocks_isConj` : under the unit-phase hypothesis each gate is an
  invertible involution and the fold is *algebraic conjugation* `A ↦ U A U⁻¹`.
  This is a purely algebraic (invertible-involution) statement; it does **not**
  assert Hilbert-space unitarity or adjoint preservation, which are not proved
  here.
* Contiguous-chain witness `witBlock` is `BlockLocal` for the radius-3 chain
  neighborhood (`witBlock_BlockLocal`), with `witBlock_nonzero_boundary_transfer`
  exhibiting a nonzero pair-transfer amplitude across the block width — a
  *nontriviality* witness, not a proof that the CAR-support bound is sharp.
* Negative control `not_BlockLocal_farBlock` : an explicit far (noncontiguous)
  four-mode block that is **not** `BlockLocal` for a small (radius-1) chain
  neighborhood, so `BlockLocal` is a genuine, non-vacuous hypothesis.

`CARSupported` and the number-operator counterexample from `PlueckerCausalCone`
are unchanged and reused.

Lean 4.28.0.
-/

noncomputable section

open Complex

namespace PhysicsSM.Draft.NullEdge.PlueckerCausalCone

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization (basisVec)
open PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction (witnessUnitPhase
  witnessUnitPhase_ne_zero)

variable {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]

/-! ## Neighborhood expansion of a finite graph/chain -/

/-- One neighborhood step: replace `R` by the union of the closed neighborhoods of
its elements. -/
def ballStep (N : ι → Finset ι) (R : Finset ι) : Finset ι := R.biUnion N

/-- The `t`-fold neighborhood of `R`. -/
def ballIter (N : ι → Finset ι) : ℕ → Finset ι → Finset ι
  | 0, R => R
  | (t + 1), R => ballStep N (ballIter N t R)

omit [Fintype ι] [LinearOrder ι] in
theorem ballStep_mono (N : ι → Finset ι) {R R' : Finset ι} (h : R ⊆ R') :
    ballStep N R ⊆ ballStep N R' :=
  Finset.biUnion_subset_biUnion_of_subset_left _ h

omit [Fintype ι] [LinearOrder ι] in
/-- If `N` is reflexive (each site is in its own neighborhood) then a
neighborhood step only grows the region. -/
theorem subset_ballStep (N : ι → Finset ι) (hN : ∀ i, i ∈ N i) (R : Finset ι) :
    R ⊆ ballStep N R :=
  fun x hx => Finset.mem_biUnion.mpr ⟨x, hx, hN x⟩

omit [Fintype ι] [LinearOrder ι] in
theorem ballIter_mono (N : ι → Finset ι) (t : ℕ) {R R' : Finset ι} (h : R ⊆ R') :
    ballIter N t R ⊆ ballIter N t R' := by
  induction' t with t ih generalizing R R'
  · exact h
  · exact ballStep_mono N (ih h)

omit [Fintype ι] [LinearOrder ι] in
theorem ballIter_subset_succ (N : ι → Finset ι) (hN : ∀ i, i ∈ N i)
    (t : ℕ) (R : Finset ι) : ballIter N t R ⊆ ballIter N (t + 1) R := by
  induction' t with t ih generalizing R <;> simp_all +decide [ballIter]
  · exact subset_ballStep N hN R
  · exact ballStep_mono N (ih R)

/-- Local schedule condition: an acted block, whenever it touches a region `S`,
is contained in one neighborhood step of `S`.  This ties each block to a
finite-radius one-step neighborhood and forbids a touching block from reaching
farther than `ballStep N S`. -/
def BlockLocal (N : ι → Finset ι) (m : Block ι) : Prop :=
  ∀ S : Finset ι, ¬ Disjoint (block m) S → block m ⊆ ballStep N S

/-! ## Commuting an even gate past a `CARSupported` observable -/

/-- If `A` commutes with all four creation/annihilation generators of block `m`,
then it commutes with the whole even kick gate. -/
theorem commuteOn_bKickL_of_generators {A : Fock ι →ₗ[Complex] Fock ι}
    {m : Block ι} (u : Complex)
    (hgen : ∀ i : Fin 4,
      CommuteOn A (createL (m i)) ∧ CommuteOn A (annihilateL (m i))) :
    CommuteOn A (bKickL m u) := by
  unfold bKickL
  have hq : CommuteOn A (bQuarticL m u) := by
    apply CommuteOn.add
    · apply CommuteOn.smul
      exact CommuteOn.comp (hgen 0 |>.1) (CommuteOn.comp (hgen 1 |>.1)
        (CommuteOn.comp (hgen 3 |>.2) (hgen 2 |>.2)))
    · apply CommuteOn.smul
      exact CommuteOn.comp (hgen 2 |>.1) (CommuteOn.comp (hgen 3 |>.1)
        (CommuteOn.comp (hgen 1 |>.2) (hgen 0 |>.2)))
  exact CommuteOn.add hq (CommuteOn.sub (CommuteOn.symm (commuteOn_id _)) (hq.comp hq))

/-- If `A` is `CARSupported R` and `block m` is disjoint from `R`, then `A`
commutes with the gate `bKickL m u`. -/
theorem commuteOn_bKickL_of_disjoint {A : Fock ι →ₗ[Complex] Fock ι}
    {R : Finset ι} {m : Block ι} (u : Complex)
    (hA : CARSupported R A) (hd : Disjoint (block m) R) :
    CommuteOn A (bKickL m u) :=
  commuteOn_bKickL_of_generators u (fun i =>
    ⟨(hA (m i) (Finset.disjoint_left.mp hd (mem_block m i))).1.symm,
     (hA (m i) (Finset.disjoint_left.mp hd (mem_block m i))).2.symm⟩)

/-! ## The disjoint-drop cone -/

open scoped Classical in
/-- One step of the pruned cone: a gate whose block is disjoint from the current
front is dropped; otherwise its block is added. -/
def reachStep (m : Block ι) (acc : Finset ι) : Finset ι :=
  if Disjoint (block m) acc then acc else block m ∪ acc

open scoped Classical in
/-- The pruned causal cone of a sequential schedule. -/
def reachCone (ms : List (Block ι)) (R : Finset ι) : Finset ι :=
  ms.foldr reachStep R

omit [Fintype ι] [LinearOrder ι] in
theorem reachCone_nil (R : Finset ι) : reachCone [] R = R := rfl

omit [Fintype ι] [LinearOrder ι] in
theorem reachCone_cons (m : Block ι) (ms : List (Block ι)) (R : Finset ι) :
    reachCone (m :: ms) R = reachStep m (reachCone ms R) := rfl

omit [Fintype ι] [LinearOrder ι] in
/-- The pruned cone is contained in the naive union-everything cone. -/
theorem reachCone_subset_coneRegion (ms : List (Block ι)) (R : Finset ι) :
    reachCone ms R ⊆ coneRegion ms R := by
  induction' ms with m ms ih generalizing R
  · rfl
  · rw [reachCone_cons]
    unfold reachStep coneRegion
    split_ifs <;>
      [exact Finset.Subset.trans (ih _) (Finset.subset_union_right);
       exact Finset.union_subset_union (Finset.Subset.refl _) (ih _)]

omit [Fintype ι] [LinearOrder ι] in
/-- The front is always inside the pruned cone. -/
theorem subset_reachCone (ms : List (Block ι)) (R : Finset ι) :
    R ⊆ reachCone ms R := by
  induction ms
  · rfl
  · grind +locals

/-! ## Scheduled CAR-support propagation on the pruned cone

This is the honest scheduled statement: it uses exact disjoint-gate invariance to
prune distant blocks, but the cone still depends on the sequential schedule.  The
geometric bound is `heisenFoldBlocks_geometric_cone`. -/

/-- Scheduled CAR-support propagation with disjoint pruning.  Requires the
unit-phase (`u * conj u = 1`) hypothesis so that a disjoint gate is exactly
invariant (`heisenStep_outside_cone` needs involutivity). -/
theorem heisenFoldBlocks_reachCone {u : Complex}
    (hu : u * (starRingEnd Complex) u = 1) (ms : List (Block ι))
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι} (hA : CARSupported R A) :
    CARSupported (reachCone ms R) (heisenFoldBlocks u ms A) := by
  induction' ms with m ms ih generalizing R A
  · convert hA using 1
  · by_cases hdisj : Disjoint (block m) (reachCone ms R)
    · convert ih hA using 1
      · exact if_pos hdisj
      · convert heisenStep_outside_cone (fun psi => bKickL_involutive m hu psi)
          (commuteOn_bKickL_of_disjoint u (ih hA) hdisj) using 1
    · convert heisenStep_CARSupported (bKickL_CARSupported m u) (ih hA) using 1
      exact if_neg hdisj

/-! ## The geometric bound: pruned cone lies in the `t`-fold neighborhood -/

omit [Fintype ι] [LinearOrder ι] in
/-- Geometric containment: if every scheduled block is `BlockLocal` for the
neighborhood `N`, the pruned cone of a schedule of `t = ms.length` sequential
gates lies in the `t`-fold neighborhood of `R`. -/
theorem reachCone_subset_ballIter (N : ι → Finset ι) (hN : ∀ i, i ∈ N i)
    (ms : List (Block ι)) (hloc : ∀ m ∈ ms, BlockLocal N m) (R : Finset ι) :
    reachCone ms R ⊆ ballIter N ms.length R := by
  induction ms generalizing R <;> simp_all +decide [reachCone_cons, ballIter]
  · exact reachCone_nil R ▸ Finset.Subset.refl _
  · rename_i k hk ih
    by_cases hdisj : Disjoint (block k) (reachCone hk R) <;> simp_all +decide [reachStep]
    · exact Finset.Subset.trans (ih R) (subset_ballStep N hN _)
    · exact Finset.union_subset
        (hloc.1 _ hdisj |> Finset.Subset.trans <| ballStep_mono _ <| ih _)
        (Finset.Subset.trans (ih _) <| subset_ballStep _ hN _)

/-- **Geometric causal cone (headline).**  After a schedule of `t = ms.length`
sequential local (`BlockLocal N`) unit-phase gates, a `CARSupported R` observable
is `CARSupported` inside the `t`-fold neighborhood `ballIter N t R`.  This is a
bounded-radius statement: support propagates at most one neighborhood step per
sequential gate. -/
theorem heisenFoldBlocks_geometric_cone (N : ι → Finset ι) (hN : ∀ i, i ∈ N i)
    {u : Complex} (hu : u * (starRingEnd Complex) u = 1) (ms : List (Block ι))
    (hloc : ∀ m ∈ ms, BlockLocal N m)
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι} (hA : CARSupported R A) :
    CARSupported (ballIter N ms.length R) (heisenFoldBlocks u ms A) :=
  (heisenFoldBlocks_reachCone hu ms hA).mono (reachCone_subset_ballIter N hN ms hloc R)

/-! ## Unit-phase corollary: algebraic conjugation by an invertible involution

Under the unit-phase hypothesis each gate is an involution, so it is its own
inverse and `heisenStep (bKickL m u)` is *algebraic conjugation* `A ↦ g A g⁻¹`.
This is a statement about invertible linear maps only.  It does NOT assert
Hilbert-space unitarity or `star`/adjoint preservation, which are not proved in
this module. -/

/-- The unit-phase gate squares to the identity, hence is its own inverse (an
invertible involution). -/
theorem bKickL_comp_self {m : Block ι} {u : Complex}
    (hu : u * (starRingEnd Complex) u = 1) :
    bKickL m u ∘ₗ bKickL m u = LinearMap.id := by
  apply LinearMap.ext
  intro x
  simpa using bKickL_involutive m hu x

/-- The ordered product of the schedule's gates (an invertible linear map). -/
def scheduleProd (u : Complex) (ms : List (Block ι)) :
    Fock ι →ₗ[Complex] Fock ι :=
  ms.foldr (fun m acc => bKickL m u ∘ₗ acc) LinearMap.id

/-- The reversed product, which is the two-sided inverse of `scheduleProd` under
the unit-phase hypothesis. -/
def scheduleProdRev (u : Complex) (ms : List (Block ι)) :
    Fock ι →ₗ[Complex] Fock ι :=
  ms.foldr (fun m acc => acc ∘ₗ bKickL m u) LinearMap.id

/-- **Algebraic conjugation (invertible involution).**  Under the unit-phase
hypothesis the whole schedule fold is conjugation of `A` by the invertible linear
map `U = scheduleProd u ms` with two-sided inverse `U⁻¹ = scheduleProdRev u ms`:
`heisenFoldBlocks u ms A = U ∘ A ∘ U⁻¹`.  This is a purely algebraic identity; no
Hilbert-space unitarity or adjoint claim is made. -/
theorem heisenFoldBlocks_isConj {u : Complex}
    (hu : u * (starRingEnd Complex) u = 1) (ms : List (Block ι))
    (A : Fock ι →ₗ[Complex] Fock ι) :
    heisenFoldBlocks u ms A
      = scheduleProd u ms ∘ₗ A ∘ₗ scheduleProdRev u ms
    ∧ scheduleProd u ms ∘ₗ scheduleProdRev u ms = LinearMap.id
    ∧ scheduleProdRev u ms ∘ₗ scheduleProd u ms = LinearMap.id := by
  induction' ms with m ms ih generalizing A
  · aesop
  · simp_all +decide [heisenFoldBlocks, scheduleProd, scheduleProdRev]
    refine ⟨?_, ?_, ?_⟩
    · ext; simp +decide [heisenStep]
    · ext x; simp +decide [← LinearMap.comp_assoc]
      have := ih (bKickL m u); simp_all +decide [LinearMap.ext_iff]
      exact bKickL_involutive m hu _ ▸ rfl
    · simp_all +decide [LinearMap.ext_iff, bKickL_involutive]
      exact ih A |>.2.2

/-! ## Contiguous-chain neighborhood, nontriviality witness, negative control -/

/-- The radius-`r` chain neighborhood on `Fin 8`: all sites within integer
distance `r`. -/
def chainNbhd (r : ℕ) (i : Fin 8) : Finset (Fin 8) :=
  Finset.univ.filter (fun j => ((i : ℤ) - (j : ℤ)).natAbs ≤ r)

theorem chainNbhd_refl (r : ℕ) (i : Fin 8) : i ∈ chainNbhd r i := by
  unfold chainNbhd
  simp

set_option maxRecDepth 10000 in
/-- The contiguous witness block `{0,1,2,3}` is `BlockLocal` for the radius-3
chain neighborhood (its diameter is 3). -/
theorem witBlock_BlockLocal : BlockLocal (chainNbhd 3) witBlock := by
  unfold BlockLocal ballStep chainNbhd block witBlock
  decide

/-- Nontriviality witness (NOT cone sharpness): the local gate on the contiguous
block moves a nonzero amplitude across the full width of its block (high pair
`{2,3}` to low pair `{0,1}`), reusing the nonzero disjoint-pair Pluecker phase.
This shows the gate acts nontrivially inside its block; it does **not** exhibit a
local observable whose conjugate fails support in every smaller neighborhood, so
it does not establish that the CAR-support bound is sharp. -/
theorem witBlock_nonzero_boundary_transfer :
    bKickL witBlock witnessUnitPhase (basisVec (highPair witBlock))
      (lowPair witBlock) ≠ 0 :=
  witBlock_forward_amplitude

/-- A far (noncontiguous) four-mode block on the 8-site chain, spanning modes
`{0,1,2,7}`. -/
def farBlock : Block (Fin 8) := ⟨![0, 1, 2, 7], by decide⟩

set_option maxRecDepth 10000 in
/-- **Load-bearing negative control.**  The far block `{0,1,2,7}` is NOT
`BlockLocal` for the radius-1 chain neighborhood: it touches `{0}` but reaches
mode `7`, which is not within one radius-1 step of `{0}`.  Hence `BlockLocal` is a
genuine, non-vacuous hypothesis — it really does exclude distant/noncontiguous
blocks. -/
theorem not_BlockLocal_farBlock : ¬ BlockLocal (chainNbhd 1) farBlock := by
  unfold BlockLocal ballStep chainNbhd block farBlock
  decide

/-! ## Build-enforced axiom pins for the geometric results (standard three) -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.heisenFoldBlocks_geometric_cone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms heisenFoldBlocks_geometric_cone

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.reachCone_subset_ballIter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms reachCone_subset_ballIter

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.heisenFoldBlocks_reachCone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms heisenFoldBlocks_reachCone

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.heisenFoldBlocks_isConj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms heisenFoldBlocks_isConj

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.witBlock_BlockLocal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witBlock_BlockLocal

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.not_BlockLocal_farBlock' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms not_BlockLocal_farBlock

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.witBlock_nonzero_boundary_transfer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witBlock_nonzero_boundary_transfer

end PhysicsSM.Draft.NullEdge.PlueckerCausalCone

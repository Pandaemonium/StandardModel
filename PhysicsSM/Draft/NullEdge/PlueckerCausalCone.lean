import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
import PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization
import PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction

/-!
# Exact CAR support for scheduled Pluecker pair-kick layers

This module carries out the spatial embedding designed in `review/design.md`:
it places the four-mode Pluecker pair kick onto an arbitrary block of a finite
fermionic chain, builds it out of the generic CAR generators of
`FiniteCARFockBasic`, and proves exact finite support propagation through a
declared gate schedule.

* `CARSupported R A` : the **genuine local support predicate** for even
  operators — `A` commutes with every creation/annihilation generator on a mode
  outside `R`. This is the strong algebraic support notion used below.
* `bKickL m u` : the local pair gate on the four modes of block `m`, proved
  `CARSupported (block m)`.
* Scheduled support: one-step growth (`heisenStep_CARSupported`) and its list
  corollary (`heisenFoldBlocks_CARSupported`).
* Exact disjoint-block commutation (`bKickL_commute_disjoint`) and the
  outside-cone invariance (`heisenStep_outside_cone`).
* A support-nontrivial witness reusing the nonzero disjoint-pair phase amplitude
  `witnessUnitPhase = (3+4i)/5`.

* `FootprintIn R f` : a strictly **weaker** occupation-transition footprint (it
  only says basis transitions preserve occupations outside `R`). It is retained
  as an auxiliary bookkeeping notion but is **NOT** a locality/support predicate:
  a global diagonal multiplier such as the number operator satisfies
  `FootprintIn ∅` while failing `CARSupported ∅`
  (`footprintIn_numberOp`, `not_CARSupported_numberOp`). None of the `FootprintIn`
  results are called a causal cone.

Parity: `bKickL` is an *even* CAR operator (a degree-4 word), so disjoint blocks
commute in the ordinary sense; the even-observable restriction is stated in the
design and is exactly the hypothesis behind `bKickL_commute_disjoint` and behind
the generator-commutation form of `CARSupported`.

Geometric boundary: `Block ι` is an arbitrary embedding of four modes and
`coneRegion` is the union of all scheduled blocks. No graph metric,
contiguity/range condition, local-layer predicate, or radius-versus-time bound
is present. The exact results are therefore algebraic support and schedule
propagation theorems, not yet a bounded-speed causal cone. Likewise `g A g` is
physical Heisenberg conjugation only when the gate is unitary/involutive; for
the displayed pair kick this requires the stated unit-phase hypothesis.

Provenance: Aristotle project `0388c69e-854c-46d1-824b-dd3eed71184c`.
Codex's in-progress semantic audit identified the weak-footprint counterexample
and required the `CARSupported` repair; Aristotle returned the corrected strong
ladder and explicit number-operator control. Lean 4.28.0.
-/

noncomputable section

open Complex

namespace PhysicsSM.Draft.NullEdge.PlueckerCausalCone

open PhysicsSM.Draft.NullEdge.FiniteCARFockBasic
open PhysicsSM.Draft.NullEdge.FiniteCARSecondQuantization (basisVec)

variable {ι : Type*} [Fintype ι] [DecidableEq ι] [LinearOrder ι]

/-! ## CAR generator linearity helpers -/

omit [Fintype ι] in
theorem create_add (i : ι) (a b : Fock ι) :
    create i (a + b) = create i a + create i b := by
  funext S; simp only [create, Pi.add_apply]; split <;> ring

omit [Fintype ι] in
theorem create_smul (i : ι) (c : Complex) (a : Fock ι) :
    create i (c • a) = c • create i a := by
  funext S; simp only [create, Pi.smul_apply, smul_eq_mul]; split <;> ring

omit [Fintype ι] in
theorem create_neg (i : ι) (a : Fock ι) : create i (-a) = - create i a := by
  funext S; simp only [create, Pi.neg_apply]; split <;> ring

omit [Fintype ι] in
theorem annihilate_add (i : ι) (a b : Fock ι) :
    annihilate i (a + b) = annihilate i a + annihilate i b := by
  funext S; simp only [annihilate, Pi.add_apply]; split <;> ring

omit [Fintype ι] in
theorem annihilate_smul (i : ι) (c : Complex) (a : Fock ι) :
    annihilate i (c • a) = c • annihilate i a := by
  funext S; simp only [annihilate, Pi.smul_apply, smul_eq_mul]; split <;> ring

omit [Fintype ι] in
theorem annihilate_neg (i : ι) (a : Fock ι) :
    annihilate i (-a) = - annihilate i a := by
  funext S; simp only [annihilate, Pi.neg_apply]; split <;> ring

/-- Bundled creation operator. -/
def createL (i : ι) : Fock ι →ₗ[Complex] Fock ι where
  toFun := create i
  map_add' := create_add i
  map_smul' := fun c x => create_smul i c x

/-- Bundled annihilation operator. -/
def annihilateL (i : ι) : Fock ι →ₗ[Complex] Fock ι where
  toFun := annihilate i
  map_add' := annihilate_add i
  map_smul' := fun c x => annihilate_smul i c x

@[simp] theorem createL_apply (i : ι) (psi : Fock ι) :
    createL i psi = create i psi := rfl

@[simp] theorem annihilateL_apply (i : ι) (psi : Fock ι) :
    annihilateL i psi = annihilate i psi := rfl

/-! ## Blocks and the local pair gate -/

/-- A block is an embedding of the four abstract modes into the chain. -/
abbrev Block (ι : Type*) := Fin 4 ↪ ι

/-- The four chain modes covered by a block. -/
def block (m : Block ι) : Finset ι := Finset.univ.image (m : Fin 4 → ι)

omit [Fintype ι] [LinearOrder ι] in
theorem mem_block (m : Block ι) (i : Fin 4) : m i ∈ block m := by
  simp [block]

omit [Fintype ι] [LinearOrder ι] in
theorem mem_block_iff (m : Block ι) (x : ι) :
    x ∈ block m ↔ ∃ i : Fin 4, m i = x := by
  simp [block, eq_comm]

/-- Low pair `{m0,m1}` of a block. -/
def lowPair (m : Block ι) : Finset ι := {m 0, m 1}

/-- High pair `{m2,m3}` of a block. -/
def highPair (m : Block ι) : Finset ι := {m 2, m 3}

/-- Two blocks are mode-disjoint. -/
def Disj (m m' : Block ι) : Prop := ∀ i j : Fin 4, m i ≠ m' j

/-- Forward pair transfer of block `m` (high pair `{m2,m3}` → low `{m0,m1}`). -/
def bForwardL (m : Block ι) : Fock ι →ₗ[Complex] Fock ι :=
  createL (m 0) ∘ₗ createL (m 1) ∘ₗ annihilateL (m 3) ∘ₗ annihilateL (m 2)

/-- Backward pair transfer of block `m`. -/
def bBackwardL (m : Block ι) : Fock ι →ₗ[Complex] Fock ι :=
  createL (m 2) ∘ₗ createL (m 3) ∘ₗ annihilateL (m 1) ∘ₗ annihilateL (m 0)

theorem bForwardL_apply (m : Block ι) (psi : Fock ι) :
    bForwardL m psi =
      create (m 0) (create (m 1) (annihilate (m 3) (annihilate (m 2) psi))) := rfl

theorem bBackwardL_apply (m : Block ι) (psi : Fock ι) :
    bBackwardL m psi =
      create (m 2) (create (m 3) (annihilate (m 1) (annihilate (m 0) psi))) := rfl

/-- The Hermitian quartic generator of block `m` with phase `u`. -/
def bQuarticL (m : Block ι) (u : Complex) : Fock ι →ₗ[Complex] Fock ι :=
  u • bForwardL m + (starRingEnd Complex) u • bBackwardL m

/-- The local Pluecker pair kick of block `m`, built from CAR generators.
For unit-modulus `u` this equals `quartic + (id − quartic²)`, the placed form of
the supplied `pairKick`. -/
def bKickL (m : Block ι) (u : Complex) : Fock ι →ₗ[Complex] Fock ι :=
  bQuarticL m u + (LinearMap.id - bQuarticL m u ∘ₗ bQuarticL m u)

/-! ## Commutation atoms: one generator past a disjoint block word -/

theorem createL_commute_bForwardL {m : Block ι} {x : ι} (hx : x ∉ block m)
    (psi : Fock ι) :
    createL x (bForwardL m psi) = bForwardL m (createL x psi) := by
  have hxi : ∀ i : Fin 4, x ≠ m i := fun i h => hx (h ▸ mem_block m i)
  simp only [bForwardL_apply, createL_apply]
  have c0 : ∀ p : Fock ι, create x (create (m 0) p) = - create (m 0) (create x p) :=
    fun p => eq_neg_of_add_eq_zero_left (create_create_anticomm (hxi 0) p)
  have c1 : ∀ p : Fock ι, create x (create (m 1) p) = - create (m 1) (create x p) :=
    fun p => eq_neg_of_add_eq_zero_left (create_create_anticomm (hxi 1) p)
  have c3 : ∀ p : Fock ι, create x (annihilate (m 3) p) = - annihilate (m 3) (create x p) :=
    fun p => eq_neg_of_add_eq_zero_left (create_annihilate_distinct_anticomm (hxi 3) p)
  have c2 : ∀ p : Fock ι, create x (annihilate (m 2) p) = - annihilate (m 2) (create x p) :=
    fun p => eq_neg_of_add_eq_zero_left (create_annihilate_distinct_anticomm (hxi 2) p)
  rw [c0, c1, c3, c2]
  simp only [create_neg, annihilate_neg]; ring

theorem annihilateL_commute_bForwardL {m : Block ι} {x : ι} (hx : x ∉ block m)
    (psi : Fock ι) :
    annihilateL x (bForwardL m psi) = bForwardL m (annihilateL x psi) := by
  have hxi : ∀ i : Fin 4, x ≠ m i := fun i h => hx (h ▸ mem_block m i)
  simp only [bForwardL_apply, annihilateL_apply]
  have c0 : ∀ p : Fock ι, annihilate x (create (m 0) p) = - create (m 0) (annihilate x p) :=
    fun p => eq_neg_of_add_eq_zero_right (create_annihilate_distinct_anticomm (hxi 0).symm p)
  have c1 : ∀ p : Fock ι, annihilate x (create (m 1) p) = - create (m 1) (annihilate x p) :=
    fun p => eq_neg_of_add_eq_zero_right (create_annihilate_distinct_anticomm (hxi 1).symm p)
  have c3 : ∀ p : Fock ι, annihilate x (annihilate (m 3) p) = - annihilate (m 3) (annihilate x p) :=
    fun p => eq_neg_of_add_eq_zero_left (annihilate_annihilate_anticomm (hxi 3) p)
  have c2 : ∀ p : Fock ι, annihilate x (annihilate (m 2) p) = - annihilate (m 2) (annihilate x p) :=
    fun p => eq_neg_of_add_eq_zero_left (annihilate_annihilate_anticomm (hxi 2) p)
  rw [c0, c1, c3, c2]
  simp only [create_neg, annihilate_neg]; ring

theorem createL_commute_bBackwardL {m : Block ι} {x : ι} (hx : x ∉ block m)
    (psi : Fock ι) :
    createL x (bBackwardL m psi) = bBackwardL m (createL x psi) := by
  have hxi : ∀ i : Fin 4, x ≠ m i := fun i h => hx (h ▸ mem_block m i)
  simp only [bBackwardL_apply, createL_apply]
  have c2 : ∀ p : Fock ι, create x (create (m 2) p) = - create (m 2) (create x p) :=
    fun p => eq_neg_of_add_eq_zero_left (create_create_anticomm (hxi 2) p)
  have c3 : ∀ p : Fock ι, create x (create (m 3) p) = - create (m 3) (create x p) :=
    fun p => eq_neg_of_add_eq_zero_left (create_create_anticomm (hxi 3) p)
  have c1 : ∀ p : Fock ι, create x (annihilate (m 1) p) = - annihilate (m 1) (create x p) :=
    fun p => eq_neg_of_add_eq_zero_left (create_annihilate_distinct_anticomm (hxi 1) p)
  have c0 : ∀ p : Fock ι, create x (annihilate (m 0) p) = - annihilate (m 0) (create x p) :=
    fun p => eq_neg_of_add_eq_zero_left (create_annihilate_distinct_anticomm (hxi 0) p)
  rw [c2, c3, c1, c0]
  simp only [create_neg, annihilate_neg]; ring

theorem annihilateL_commute_bBackwardL {m : Block ι} {x : ι} (hx : x ∉ block m)
    (psi : Fock ι) :
    annihilateL x (bBackwardL m psi) = bBackwardL m (annihilateL x psi) := by
  have hxi : ∀ i : Fin 4, x ≠ m i := fun i h => hx (h ▸ mem_block m i)
  simp only [bBackwardL_apply, annihilateL_apply]
  have c2 : ∀ p : Fock ι, annihilate x (create (m 2) p) = - create (m 2) (annihilate x p) :=
    fun p => eq_neg_of_add_eq_zero_right (create_annihilate_distinct_anticomm (hxi 2).symm p)
  have c3 : ∀ p : Fock ι, annihilate x (create (m 3) p) = - create (m 3) (annihilate x p) :=
    fun p => eq_neg_of_add_eq_zero_right (create_annihilate_distinct_anticomm (hxi 3).symm p)
  have c1 : ∀ p : Fock ι, annihilate x (annihilate (m 1) p) = - annihilate (m 1) (annihilate x p) :=
    fun p => eq_neg_of_add_eq_zero_left (annihilate_annihilate_anticomm (hxi 1) p)
  have c0 : ∀ p : Fock ι, annihilate x (annihilate (m 0) p) = - annihilate (m 0) (annihilate x p) :=
    fun p => eq_neg_of_add_eq_zero_left (annihilate_annihilate_anticomm (hxi 0) p)
  rw [c2, c3, c1, c0]
  simp only [create_neg, annihilate_neg]; ring

/-! ## `CommuteOn` calculus -/

/-- Two Fock operators commute (ordinary commutator). -/
def CommuteOn (f g : Fock ι →ₗ[Complex] Fock ι) : Prop :=
  ∀ psi, f (g psi) = g (f psi)

theorem CommuteOn.symm {f g : Fock ι →ₗ[Complex] Fock ι} (h : CommuteOn f g) :
    CommuteOn g f := fun psi => (h psi).symm

theorem commuteOn_id (f : Fock ι →ₗ[Complex] Fock ι) :
    CommuteOn f (LinearMap.id) := fun _ => rfl

theorem CommuteOn.comp {f g h : Fock ι →ₗ[Complex] Fock ι}
    (hg : CommuteOn f g) (hh : CommuteOn f h) : CommuteOn f (g ∘ₗ h) := by
  intro psi
  simp only [LinearMap.comp_apply]
  rw [hg (h psi), hh psi]

theorem CommuteOn.add {f g h : Fock ι →ₗ[Complex] Fock ι}
    (hg : CommuteOn f g) (hh : CommuteOn f h) : CommuteOn f (g + h) := by
  intro psi
  simp only [LinearMap.add_apply, map_add]
  rw [hg psi, hh psi]

theorem CommuteOn.sub {f g h : Fock ι →ₗ[Complex] Fock ι}
    (hg : CommuteOn f g) (hh : CommuteOn f h) : CommuteOn f (g - h) := by
  intro psi
  simp only [LinearMap.sub_apply, map_sub]
  rw [hg psi, hh psi]

theorem CommuteOn.smul {f g : Fock ι →ₗ[Complex] Fock ι} (c : Complex)
    (hg : CommuteOn f g) : CommuteOn f (c • g) := by
  intro psi
  simp only [LinearMap.smul_apply, map_smul]
  rw [hg psi]

/-! ## A single generator commutes with a disjoint gate -/

theorem createL_commute_bQuarticL {m : Block ι} {x : ι} (hx : x ∉ block m)
    (u : Complex) : CommuteOn (createL x) (bQuarticL m u) :=
  CommuteOn.add
    (CommuteOn.smul u (fun psi => createL_commute_bForwardL hx psi))
    (CommuteOn.smul _ (fun psi => createL_commute_bBackwardL hx psi))

theorem annihilateL_commute_bQuarticL {m : Block ι} {x : ι} (hx : x ∉ block m)
    (u : Complex) : CommuteOn (annihilateL x) (bQuarticL m u) :=
  CommuteOn.add
    (CommuteOn.smul u (fun psi => annihilateL_commute_bForwardL hx psi))
    (CommuteOn.smul _ (fun psi => annihilateL_commute_bBackwardL hx psi))

theorem createL_commute_bKickL {m : Block ι} {x : ι} (hx : x ∉ block m)
    (u : Complex) : CommuteOn (createL x) (bKickL m u) := by
  have hq := createL_commute_bQuarticL hx u
  exact CommuteOn.add hq (CommuteOn.sub (commuteOn_id _) (hq.comp hq))

theorem annihilateL_commute_bKickL {m : Block ι} {x : ι} (hx : x ∉ block m)
    (u : Complex) : CommuteOn (annihilateL x) (bKickL m u) := by
  have hq := annihilateL_commute_bQuarticL hx u
  exact CommuteOn.add hq (CommuteOn.sub (commuteOn_id _) (hq.comp hq))

/-- Any block-`m'` generator commutes with the block-`m` kick when the blocks are
disjoint. -/
theorem generator_commute_bKickL {m m' : Block ι} (hd : Disj m m')
    (u : Complex) (i : Fin 4) :
    CommuteOn (createL (m' i)) (bKickL m u) ∧
      CommuteOn (annihilateL (m' i)) (bKickL m u) := by
  have hx : m' i ∉ block m := by
    rw [mem_block_iff]; rintro ⟨j, hj⟩; exact hd j i hj
  exact ⟨createL_commute_bKickL hx u, annihilateL_commute_bKickL hx u⟩

/-- Exact disjoint-block gate commutation: the core outside-cone control. -/
theorem bKickL_commute_disjoint {m m' : Block ι} (hd : Disj m m')
    (u u' : Complex) : CommuteOn (bKickL m u) (bKickL m' u') := by
  have hfwd : CommuteOn (bKickL m u) (bForwardL m') :=
    CommuteOn.comp (generator_commute_bKickL hd u 0).1.symm
      (CommuteOn.comp (generator_commute_bKickL hd u 1).1.symm
        (CommuteOn.comp (generator_commute_bKickL hd u 3).2.symm
          (generator_commute_bKickL hd u 2).2.symm))
  have hbwd : CommuteOn (bKickL m u) (bBackwardL m') :=
    CommuteOn.comp (generator_commute_bKickL hd u 2).1.symm
      (CommuteOn.comp (generator_commute_bKickL hd u 3).1.symm
        (CommuteOn.comp (generator_commute_bKickL hd u 1).2.symm
          (generator_commute_bKickL hd u 0).2.symm))
  have hq : CommuteOn (bKickL m u) (bQuarticL m' u') :=
    CommuteOn.add (CommuteOn.smul u' hfwd) (CommuteOn.smul _ hbwd)
  exact CommuteOn.add hq (CommuteOn.sub (commuteOn_id _) (hq.comp hq))

/-! ## Occupation-transition footprint calculus (auxiliary, NOT locality)

WARNING: `FootprintIn R f` below only records that basis transitions of `f`
preserve occupations outside `R`. It is a weak bookkeeping device, **not** a
locality predicate: see `footprintIn_numberOp` / `not_CARSupported_numberOp`
for a global operator with `FootprintIn ∅`. The genuine local support predicate
is `CARSupported` further below, and only its ladder is called a causal cone. -/

/-- Weak occupation-transition footprint: applied to a basis configuration `T`,
`f` only produces configurations `S` agreeing with `T` outside `R`. This does
**not** capture locality (a global diagonal multiplier has `FootprintIn ∅`). -/
def FootprintIn (R : Finset ι) (f : Fock ι →ₗ[Complex] Fock ι) : Prop :=
  ∀ T S : Finset ι, f (basisVec T) S ≠ 0 → S \ R = T \ R

theorem FootprintIn.mono {R R' : Finset ι} (hR : R ⊆ R')
    {f : Fock ι →ₗ[Complex] Fock ι} (hf : FootprintIn R f) : FootprintIn R' f := by
  intro T S hTS
  have h := hf T S hTS
  have hcalc : ∀ A : Finset ι, A \ R' = (A \ R) \ R' := by
    intro A; ext a; simp only [Finset.mem_sdiff]
    constructor
    · rintro ⟨ha, ha'⟩; exact ⟨⟨ha, fun h => ha' (hR h)⟩, ha'⟩
    · rintro ⟨⟨ha, _⟩, ha'⟩; exact ⟨ha, ha'⟩
  rw [hcalc S, hcalc T, h]

theorem footprintIn_id (R : Finset ι) : FootprintIn R (LinearMap.id) := by
  intro T S hTS
  have : S = T := by
    by_contra h
    apply hTS
    simp [basisVec, h]
  rw [this]

theorem footprintIn_createL (i : ι) : FootprintIn {i} (createL i) := by
  intro T S h
  simp only [createL_apply, create, basisVec] at h
  split_ifs at h with hiS he
  · subst he
    ext a; simp only [Finset.mem_sdiff, Finset.mem_singleton, Finset.mem_erase]; tauto
  all_goals simp at h

theorem footprintIn_annihilateL (i : ι) : FootprintIn {i} (annihilateL i) := by
  intro T S h
  simp only [annihilateL_apply, annihilate, basisVec] at h
  split_ifs at h with hiS he
  · simp at h
  · subst he
    ext a; simp only [Finset.mem_sdiff, Finset.mem_singleton, Finset.mem_insert]
    have hi : i ∉ S := hiS
    aesop
  · simp at h

theorem FootprintIn.add {R : Finset ι} {f g : Fock ι →ₗ[Complex] Fock ι}
    (hf : FootprintIn R f) (hg : FootprintIn R g) : FootprintIn R (f + g) := by
  intro T S hTS
  simp only [LinearMap.add_apply, Pi.add_apply] at hTS
  by_cases hfz : f (basisVec T) S = 0
  · exact hg T S (by rw [hfz, zero_add] at hTS; exact hTS)
  · exact hf T S hfz

theorem FootprintIn.sub {R : Finset ι} {f g : Fock ι →ₗ[Complex] Fock ι}
    (hf : FootprintIn R f) (hg : FootprintIn R g) : FootprintIn R (f - g) := by
  intro T S hTS
  simp only [LinearMap.sub_apply, Pi.sub_apply] at hTS
  by_cases hfz : f (basisVec T) S = 0
  · exact hg T S (by rw [hfz, zero_sub, neg_ne_zero] at hTS; exact hTS)
  · exact hf T S hfz

theorem FootprintIn.smul {R : Finset ι} (c : Complex)
    {f : Fock ι →ₗ[Complex] Fock ι} (hf : FootprintIn R f) :
    FootprintIn R (c • f) := by
  intro T S hTS
  simp only [LinearMap.smul_apply, Pi.smul_apply, smul_eq_mul] at hTS
  exact hf T S (right_ne_zero_of_mul hTS)

/-- Any Fock vector is its occupation-basis expansion. -/
theorem fock_expand (v : Fock ι) : v = ∑ U : Finset ι, v U • basisVec U := by
  funext S
  simp only [Finset.sum_apply, Pi.smul_apply, basisVec, smul_eq_mul, mul_ite, mul_one, mul_zero]
  rw [Finset.sum_ite_eq Finset.univ S (fun U => v U)]
  simp

/-- Applying a linear map through the basis expansion. -/
theorem apply_expand (f : Fock ι →ₗ[Complex] Fock ι) (v : Fock ι) (S : Finset ι) :
    f v S = ∑ U : Finset ι, v U * (f (basisVec U)) S := by
  conv_lhs => rw [fock_expand v]
  rw [map_sum]
  simp only [map_smul, Finset.sum_apply, Pi.smul_apply, smul_eq_mul]

/-- Footprints add under composition. -/
theorem FootprintIn.comp {R R' : Finset ι} {f g : Fock ι →ₗ[Complex] Fock ι}
    (hf : FootprintIn R f) (hg : FootprintIn R' g) :
    FootprintIn (R ∪ R') (f ∘ₗ g) := by
  intro T S h
  simp only [LinearMap.comp_apply] at h
  rw [apply_expand f (g (basisVec T)) S] at h
  obtain ⟨U, _, hU⟩ := Finset.exists_ne_zero_of_sum_ne_zero h
  have h1 := hg T U (left_ne_zero_of_mul hU)
  have h2 := hf U S (right_ne_zero_of_mul hU)
  ext a
  have e1 := (Finset.ext_iff.mp h1) a
  have e2 := (Finset.ext_iff.mp h2) a
  simp only [Finset.mem_sdiff, Finset.mem_union] at *
  tauto

/-! ## The local gate is supported on its block -/

theorem block_generators_subset (m : Block ι) :
    ({m 0} ∪ ({m 1} ∪ ({m 3} ∪ {m 2})) : Finset ι) ⊆ block m := by
  intro x hx
  simp only [Finset.mem_union, Finset.mem_singleton] at hx
  rw [mem_block_iff]
  rcases hx with h | h | h | h
  · exact ⟨0, h.symm⟩
  · exact ⟨1, h.symm⟩
  · exact ⟨3, h.symm⟩
  · exact ⟨2, h.symm⟩

theorem footprintIn_bForwardL (m : Block ι) : FootprintIn (block m) (bForwardL m) := by
  have h : FootprintIn ({m 0} ∪ ({m 1} ∪ ({m 3} ∪ {m 2}))) (bForwardL m) := by
    refine ((footprintIn_createL (m 0)).comp ((footprintIn_createL (m 1)).comp
      ((footprintIn_annihilateL (m 3)).comp (footprintIn_annihilateL (m 2)))))
  exact h.mono (block_generators_subset m)

theorem footprintIn_bBackwardL (m : Block ι) : FootprintIn (block m) (bBackwardL m) := by
  have hsub : ({m 2} ∪ ({m 3} ∪ ({m 1} ∪ {m 0})) : Finset ι) ⊆ block m := by
    intro x hx
    simp only [Finset.mem_union, Finset.mem_singleton] at hx
    rw [mem_block_iff]
    rcases hx with h | h | h | h
    · exact ⟨2, h.symm⟩
    · exact ⟨3, h.symm⟩
    · exact ⟨1, h.symm⟩
    · exact ⟨0, h.symm⟩
  have h : FootprintIn ({m 2} ∪ ({m 3} ∪ ({m 1} ∪ {m 0}))) (bBackwardL m) :=
    ((footprintIn_createL (m 2)).comp ((footprintIn_createL (m 3)).comp
      ((footprintIn_annihilateL (m 1)).comp (footprintIn_annihilateL (m 0)))))
  exact h.mono hsub

theorem footprintIn_bQuarticL (m : Block ι) (u : Complex) :
    FootprintIn (block m) (bQuarticL m u) :=
  FootprintIn.add (FootprintIn.smul u (footprintIn_bForwardL m))
    (FootprintIn.smul _ (footprintIn_bBackwardL m))

/-- One-step support: the local pair gate is supported on its block. -/
theorem bKickL_footprint (m : Block ι) (u : Complex) :
    FootprintIn (block m) (bKickL m u) := by
  have hq := footprintIn_bQuarticL m u
  have hcomp : FootprintIn (block m) (bQuarticL m u ∘ₗ bQuarticL m u) := by
    have := hq.comp hq
    rwa [Finset.union_self] at this
  exact FootprintIn.add hq (FootprintIn.sub (footprintIn_id (block m)) hcomp)

/-! ## Heisenberg evolution -/

/-- Heisenberg step by an involutive gate `g` (its own inverse). -/
def heisenStep (g A : Fock ι →ₗ[Complex] Fock ι) : Fock ι →ₗ[Complex] Fock ι :=
  g ∘ₗ A ∘ₗ g

/-- Heisenberg evolution folding a whole block schedule. -/
def heisenFoldBlocks (u : Complex) (ms : List (Block ι))
    (A : Fock ι →ₗ[Complex] Fock ι) : Fock ι →ₗ[Complex] Fock ι :=
  ms.foldr (fun m acc => heisenStep (bKickL m u) acc) A

/-- The causal-cone region carried by a block schedule. -/
def coneRegion (ms : List (Block ι)) (R : Finset ι) : Finset ι :=
  ms.foldr (fun m acc => block m ∪ acc) R

/-- Occupation-transition footprint growth (weak; NOT a causal cone):
conjugating by a block gate enlarges the transition footprint by at most that
block. See `heisenStep_CARSupported` for the genuine local statement. -/
theorem heisenStep_footprint {B R : Finset ι} {g A : Fock ι →ₗ[Complex] Fock ι}
    (hg : FootprintIn B g) (hA : FootprintIn R A) :
    FootprintIn (B ∪ R) (heisenStep g A) := by
  have h1 : FootprintIn (R ∪ B) (A ∘ₗ g) := hA.comp hg
  have h2 : FootprintIn (B ∪ (R ∪ B)) (heisenStep g A) := hg.comp h1
  refine h2.mono ?_
  intro x hx
  simp only [Finset.mem_union] at hx ⊢
  tauto

/-- Weak `t`-step occupation-transition footprint (NOT a causal cone): after a
whole block schedule the transition footprint stays inside `R ∪ (⋃ blocks)`.
The genuine causal cone is `heisenFoldBlocks_CARSupported`. -/
theorem heisenFoldBlocks_footprint (u : Complex) (ms : List (Block ι))
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι} (hA : FootprintIn R A) :
    FootprintIn (coneRegion ms R) (heisenFoldBlocks u ms A) := by
  induction ms with
  | nil => exact hA
  | cons m ms ih =>
      exact heisenStep_footprint (bKickL_footprint m u) ih

/-! ## Strong CAR support and scheduled propagation

`CARSupported R A` is the correct locality predicate for even operators: `A`
commutes with every creation and annihilation generator on a mode outside `R`.
Unlike `FootprintIn`, it constrains how `A` *depends* on outside modes, not only
how it moves occupations. -/

/-- Genuine local support of an even operator: `A` commutes with every CAR
generator located outside `R`. -/
def CARSupported (R : Finset ι) (A : Fock ι →ₗ[Complex] Fock ι) : Prop :=
  ∀ x : ι, x ∉ R → CommuteOn (createL x) A ∧ CommuteOn (annihilateL x) A

theorem CARSupported.mono {R R' : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι}
    (h : CARSupported R A) (hR : R ⊆ R') : CARSupported R' A :=
  fun x hx => h x (fun hxR => hx (hR hxR))

/-- The local pair gate is genuinely supported on its block. -/
theorem bKickL_CARSupported (m : Block ι) (u : Complex) :
    CARSupported (block m) (bKickL m u) :=
  fun x hx => ⟨createL_commute_bKickL hx u, annihilateL_commute_bKickL hx u⟩

/-- One-step support growth: sandwiching a `CARSupported R` operator by a
`CARSupported B` gate yields a `CARSupported (B ∪ R)` observable. -/
theorem heisenStep_CARSupported {B R : Finset ι}
    {g A : Fock ι →ₗ[Complex] Fock ι}
    (hg : CARSupported B g) (hA : CARSupported R A) :
    CARSupported (B ∪ R) (heisenStep g A) := by
  intro x hx
  rw [Finset.mem_union, not_or] at hx
  obtain ⟨hxB, hxR⟩ := hx
  exact ⟨(hg x hxB).1.comp ((hA x hxR).1.comp (hg x hxB).1),
         (hg x hxB).2.comp ((hA x hxR).2.comp (hg x hxB).2)⟩

/-- Finite-schedule support propagation: after a declared block schedule a
`CARSupported R` operator is supported inside `R ∪ (⋃ blocks)`. This does not
by itself bound graph distance per time step. -/
theorem heisenFoldBlocks_CARSupported (u : Complex) (ms : List (Block ι))
    {R : Finset ι} {A : Fock ι →ₗ[Complex] Fock ι} (hA : CARSupported R A) :
    CARSupported (coneRegion ms R) (heisenFoldBlocks u ms A) := by
  induction ms with
  | nil => exact hA
  | cons m ms ih =>
      exact heisenStep_CARSupported (bKickL_CARSupported m u) ih

/-! ## Why `FootprintIn` is insufficient: the number-operator counterexample -/

/-- The total number operator: a diagonal, globally configuration-dependent
multiplier. -/
def numberOp : Fock ι →ₗ[Complex] Fock ι where
  toFun psi := fun S => (S.card : Complex) * psi S
  map_add' := by intro a b; funext S; simp [mul_add]
  map_smul' := by intro c a; funext S; simp; ring

/-- The number operator has empty occupation-transition footprint (it is
diagonal), even though it is a global observable. -/
theorem footprintIn_numberOp : FootprintIn (∅ : Finset ι) numberOp := by
  intro T S h
  simp only [numberOp, basisVec, LinearMap.coe_mk, AddHom.coe_mk] at h
  by_cases hST : S = T
  · rw [hST]
  · exact absurd (by rw [if_neg hST, mul_zero]) h

/-- ...but the number operator is NOT `CARSupported ∅`: it fails to commute with
creation. This is exactly why `FootprintIn ∅` cannot mean "local": the empty
footprint does not imply the empty support. -/
theorem not_CARSupported_numberOp :
    ¬ CARSupported (∅ : Finset (Fin 1)) numberOp := by
  intro h
  have hc := (h 0 (by simp)).1
  have key := congrFun (hc (basisVec ∅)) {0}
  simp only [createL_apply, numberOp, LinearMap.coe_mk, AddHom.coe_mk,
    create, basisVec] at key
  norm_num [opSign, belowCount] at key

/-- Exactly commuting outside-cone control: an involutive gate that commutes with
the observable leaves it unchanged under the Heisenberg step. -/
theorem heisenStep_outside_cone {g A : Fock ι →ₗ[Complex] Fock ι}
    (hinv : ∀ psi, g (g psi) = psi) (hcomm : CommuteOn A g) :
    heisenStep g A = A := by
  apply LinearMap.ext
  intro psi
  simp only [heisenStep, LinearMap.comp_apply]
  rw [hcomm psi, hinv]

/-! ## Involutivity of the unit-phase kick -/

/-- Abstract involutivity: if `Q³ = Q` then `Q + (id − Q²)` squares to the
identity. -/
theorem invol_of_cube {M : Type*} [AddCommGroup M] [Module Complex M]
    (Q : M →ₗ[Complex] M) (h : ∀ x, Q (Q (Q x)) = Q x) (x : M) :
    (Q + (LinearMap.id - Q ∘ₗ Q) : M →ₗ[Complex] M)
      ((Q + (LinearMap.id - Q ∘ₗ Q) : M →ₗ[Complex] M) x) = x := by
  simp only [LinearMap.add_apply, LinearMap.sub_apply, LinearMap.id_apply,
    LinearMap.comp_apply, map_add, map_sub]
  rw [h x]
  abel

/-
The forward pair word is nilpotent (it annihilates the high pair twice).
-/
theorem bForwardL_sq (m : Block ι) (x : Fock ι) :
    bForwardL m (bForwardL m x) = 0 := by
  ext S;
  simp +decide [ bForwardL_apply, create, annihilate ]

/-
The backward pair word is nilpotent.
-/
theorem bBackwardL_sq (m : Block ι) (x : Fock ι) :
    bBackwardL m (bBackwardL m x) = 0 := by
  unfold bBackwardL;
  simp +decide [ createL, annihilateL ];
  unfold create annihilate; simp +decide [ m.injective.eq_iff ] ;
  rfl

/-
Forward–backward–forward returns the forward word (`FBF = F`).
-/
theorem bForwardL_bBackwardL_bForwardL (m : Block ι) (x : Fock ι) :
    bForwardL m (bBackwardL m (bForwardL m x)) = bForwardL m x := by
  ext T;
  rw [ bForwardL_apply, bBackwardL_apply, bForwardL_apply ];
  simp +decide [ create, annihilate, m.injective.eq_iff ];
  grind +suggestions

/-
Backward–forward–backward returns the backward word (`BFB = B`).
-/
theorem bBackwardL_bForwardL_bBackwardL (m : Block ι) (x : Fock ι) :
    bBackwardL m (bForwardL m (bBackwardL m x)) = bBackwardL m x := by
  nontriviality;
  rename_i h;
  obtain ⟨ x, y, hxy ⟩ := h;
  rename_i z;
  rename_i w;
  cases m;
  rename_i f hf;
  ext S; simp +decide [ bBackwardL_apply, bForwardL_apply, createL_apply, annihilateL_apply ] ;
  unfold create annihilate; simp +decide [ hf.eq_iff ] ;
  split_ifs <;> simp_all +decide [ opSign_mul_self ];
  grind +suggestions

/-- For unit phase, the Hermitian quartic generator is a cube root of itself:
`Q³ = Q`. -/
theorem bQuarticL_cube (m : Block ι) {u : Complex}
    (hu : u * (starRingEnd Complex) u = 1) (x : Fock ι) :
    bQuarticL m u (bQuarticL m u (bQuarticL m u x)) = bQuarticL m u x := by
  have hu' : (starRingEnd Complex) u * u = 1 := by rw [mul_comm]; exact hu
  simp only [bQuarticL, LinearMap.add_apply, LinearMap.smul_apply, map_add,
    map_smul, smul_add, smul_smul]
  simp only [bForwardL_sq, bBackwardL_sq, map_zero, smul_zero, add_zero, zero_add]
  rw [bForwardL_bBackwardL_bForwardL, bBackwardL_bForwardL_bBackwardL]
  rw [show u * (starRingEnd Complex) u * u = u by rw [hu]; ring,
      show (starRingEnd Complex) u * u * (starRingEnd Complex) u
        = (starRingEnd Complex) u by rw [hu']; ring]

/-- The unit-modulus placed pair kick is its own inverse (involutive). -/
theorem bKickL_involutive (m : Block ι) {u : Complex}
    (hu : u * (starRingEnd Complex) u = 1) (psi : Fock ι) :
    bKickL m u (bKickL m u psi) = psi :=
  invol_of_cube (bQuarticL m u) (bQuarticL_cube m hu) psi

/-! ## Nontrivial-support witness -/

open PhysicsSM.Draft.NullEdge.PlueckerQuarticInteraction (witnessUnitPhase
  witnessUnitPhase_ne_zero witnessUnitPhase_unitary)

/-- Concrete four-mode block on an 8-site chain. -/
def witBlock : Block (Fin 8) :=
  ⟨fun i => i.castLE (by omega), fun a b h => by
    simpa [Fin.castLE_inj] using h⟩

set_option maxRecDepth 4000 in
/-- Exact placed-gate forward amplitude: the local gate moves amplitude between
the two disjoint pairs of its block with the normalized Pluecker phase. -/
theorem witBlock_forward_amplitude_eq :
    bKickL witBlock witnessUnitPhase (basisVec (highPair witBlock))
      (lowPair witBlock) = witnessUnitPhase := by
  simp only [bKickL, bQuarticL, bForwardL, bBackwardL, highPair, lowPair, witBlock,
    LinearMap.add_apply, LinearMap.sub_apply, LinearMap.smul_apply, LinearMap.comp_apply,
    LinearMap.id_apply, createL_apply, annihilateL_apply, Pi.add_apply, Pi.sub_apply,
    Pi.smul_apply, smul_eq_mul]
  norm_num [create, annihilate, opSign, belowCount, basisVec, Fin.castLE]
  rw [if_neg (by decide), if_neg (by decide)]
  norm_num [Finset.filter_singleton]

theorem witBlock_forward_amplitude :
    bKickL witBlock witnessUnitPhase (basisVec (highPair witBlock))
      (lowPair witBlock) ≠ 0 := by
  rw [witBlock_forward_amplitude_eq]; exact witnessUnitPhase_ne_zero

/-- A disjoint control block on the same 8-site chain. -/
def witBlock' : Block (Fin 8) :=
  ⟨fun i => (Fin.castLE (by omega : 4 ≤ 8) i) + 4, by
    intro a b h
    simp only [add_left_inj] at h
    simpa [Fin.castLE_inj] using h⟩

theorem witBlocks_disjoint : Disj witBlock witBlock' := by
  intro i j; fin_cases i <;> fin_cases j <;> decide

/-- Concrete exact outside-cone control: the two disjoint gates commute. -/
theorem witBlocks_commute (u u' : Complex) :
    CommuteOn (bKickL witBlock u) (bKickL witBlock' u') :=
  bKickL_commute_disjoint witBlocks_disjoint u u'

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.bKickL_CARSupported' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bKickL_CARSupported

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.heisenStep_CARSupported' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms heisenStep_CARSupported

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.heisenFoldBlocks_CARSupported' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms heisenFoldBlocks_CARSupported

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.not_CARSupported_numberOp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms not_CARSupported_numberOp

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.bKickL_footprint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bKickL_footprint

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.heisenStep_footprint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms heisenStep_footprint

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.heisenFoldBlocks_footprint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms heisenFoldBlocks_footprint

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.bKickL_commute_disjoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bKickL_commute_disjoint

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.bKickL_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms bKickL_involutive

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.heisenStep_outside_cone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms heisenStep_outside_cone

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.witBlock_forward_amplitude' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witBlock_forward_amplitude

/-- info: 'PhysicsSM.Draft.NullEdge.PlueckerCausalCone.witBlocks_commute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witBlocks_commute

end PhysicsSM.Draft.NullEdge.PlueckerCausalCone

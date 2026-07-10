import Mathlib
import PhysicsSM.Draft.NullEdge.FamilyIndexNoGo
import PhysicsSM.Draft.NullEdge.FamilyRankNoGo
import PhysicsSM.Draft.NullEdge.KMFamilyRankBridge

/-!
# A finite no-go: diagonal triplication is not yet three derived generations

## Setting

Suppose a null-edge construction has produced a fixed carrier/charge module `V`
(a finite-dimensional `K`-vector space) and, to model "three generations",
simply duplicates it `N`-fold:

    FamilyVec K N V := Fin N → V

together with the pointwise ("diagonal") lift of any single-generation operator
`A : V →ₗ[K] V`,

    diagLift N A : (Fin N → V) →ₗ[K] (Fin N → V),   (diagLift N A f) i = A (f i).

The family index `Fin N` carries *no* external structure: it is pure
duplication.  Relabelling generations by a permutation `σ : Equiv.Perm (Fin N)`
acts by the linear equivalence

    permLift N σ : (Fin N → V) ≃ₗ[K] (Fin N → V),   (permLift N σ f) i = f (σ i).

## The obstruction

Purely diagonal family data retains the *entire* family-permutation symmetry:

* `permLift_diagLift_comm` — **every** family permutation commutes with **every**
  diagonal lift.  So no diagonal operator can break, distinguish, or order the
  family labels: the family-permutation group is a full commutant of the
  diagonal algebra.
* `not_exists_universally_fixed_family` (and its `Fin N`, `2 ≤ N` generalization
  `not_exists_universally_fixed_family_gen`) — there is **no** family label fixed
  by every permutation.  Hence there is no canonical "first" generation.
* `swap_moves_vector` — the symmetry is not vacuous: at `N = 3` the concrete swap
  `(0 1)` genuinely moves a concrete nonzero family vector.

## Verdict (`generation_permutation_nogo`)

Diagonal triplication plus the currently-landed *symmetric* finite observables —
one physical CP phase (`FiniteKM.physicalPhases 3 = 1`), three positive-sector
completions (`FamilyIndex.count_completions 2 = 3`), and the rank-fixing
equivalence `completionCount n = 3 ↔ n = 2` — does **not** canonically
distinguish or order three families.  An additional symmetry-breaking /
intertwining datum (one that fails to commute with some `permLift N σ`, i.e. a
non-diagonal generation operator) is required to derive genuine generations.

## Semantic boundary

This is a no-go for the *explicitly defined duplicated diagonal family model*
only.  It is **not** a claim that no future null-edge construction can derive
generations, and it makes **no** claim about physical generation masses, Yukawa
matrices, or PMNS/CKM data.  The number three enters here as an input, not a
derived quantity.
-/

set_option linter.style.openClassical false

namespace GenerationPermutationNoGo

variable {K : Type*} [Field K] {V : Type*} [AddCommGroup V] [Module K V]

/-! ## 1. The duplicated family space and its two operator families -/

/-- The `N`-fold duplicated family space: `N` interchangeable copies of the
single-generation carrier `V`. -/
abbrev FamilyVec (K : Type*) [Field K] (N : ℕ) (V : Type*)
    [AddCommGroup V] [Module K V] : Type _ := Fin N → V

/-- **Family relabelling.** A permutation `σ` of the family index acts on the
duplicated family space by the linear equivalence `f ↦ f ∘ σ`. -/
def permLift (N : ℕ) (σ : Equiv.Perm (Fin N)) :
    (Fin N → V) ≃ₗ[K] (Fin N → V) :=
  LinearEquiv.funCongrLeft K V σ

/-- **Diagonal lift.** A single-generation operator `A` acts on the duplicated
family space pointwise (identically on every generation). -/
def diagLift (N : ℕ) (A : V →ₗ[K] V) : (Fin N → V) →ₗ[K] (Fin N → V) :=
  LinearMap.compLeft A (Fin N)

@[simp] theorem permLift_apply (N : ℕ) (σ : Equiv.Perm (Fin N))
    (f : Fin N → V) (i : Fin N) : (permLift (K := K) N σ) f i = f (σ i) := by
  simp [permLift, LinearEquiv.funCongrLeft, LinearMap.funLeft]

@[simp] theorem diagLift_apply (N : ℕ) (A : V →ₗ[K] V)
    (f : Fin N → V) (i : Fin N) : diagLift N A f i = A (f i) := rfl

/-- Composition order for the pullback action: relabelling by `σ.trans τ` is
first pulling back by `τ`, then by `σ`. -/
theorem permLift_trans (N : ℕ) (σ τ : Equiv.Perm (Fin N)) :
    (permLift (K := K) (V := V) N (σ.trans τ))
      = (permLift (K := K) N τ).trans (permLift (K := K) N σ) := by
  ext f i
  simp

/-- `permLift` of the identity permutation is the identity equivalence. -/
theorem permLift_one (N : ℕ) :
    (permLift (K := K) (V := V) N (Equiv.refl (Fin N))) = LinearEquiv.refl K _ := by
  ext f i
  simp

/-! ## 2. The full permutation commutant -/

/-- **Full permutation commutant.**  Every family permutation commutes with every
diagonal lift.  Purely diagonal family data therefore cannot distinguish the
family labels: the whole family-permutation group lies in the commutant of the
diagonal operator algebra. -/
theorem permLift_diagLift_comm (N : ℕ) (σ : Equiv.Perm (Fin N))
    (A : V →ₗ[K] V) :
    (diagLift N A) ∘ₗ (permLift (K := K) N σ).toLinearMap
      = (permLift (K := K) N σ).toLinearMap ∘ₗ (diagLift N A) := by
  ext f i
  simp

/-- Pointwise form of the commutant identity. -/
theorem permLift_diagLift_comm_apply (N : ℕ) (σ : Equiv.Perm (Fin N))
    (A : V →ₗ[K] V) (f : Fin N → V) :
    (diagLift N A) ((permLift (K := K) N σ) f)
      = (permLift (K := K) N σ) ((diagLift N A) f) := by
  ext i
  simp

/-! ## 3. No canonical family label -/

/-- **No universally fixed family label (general `N ≥ 2`).**  For `2 ≤ N` there is
no family index fixed by every permutation; hence pure duplication has no
canonical "first" generation. -/
theorem not_exists_universally_fixed_family_gen (N : ℕ) (hN : 2 ≤ N) :
    ¬ ∃ i : Fin N, ∀ σ : Equiv.Perm (Fin N), σ i = i := by
  rintro ⟨i, hi⟩
  have hcard : 1 < Fintype.card (Fin N) := by simpa using hN
  obtain ⟨j, hj⟩ := Fintype.exists_ne_of_one_lt_card hcard i
  have h := hi (Equiv.swap i j)
  rw [Equiv.swap_apply_left] at h
  exact hj h

/-- **No universally fixed family label at `N = 3`.**  There is no `i : Fin 3`
fixed by every permutation of the three families. -/
theorem not_exists_universally_fixed_family :
    ¬ ∃ i : Fin 3, ∀ σ : Equiv.Perm (Fin 3), σ i = i :=
  not_exists_universally_fixed_family_gen 3 (by norm_num)

/-! ## 4. Non-vacuity: an explicit swap moves an explicit vector -/

/-- **Explicit nontriviality at `N = 3`.**  The concrete transposition `(0 1)`
genuinely moves the concrete family vector supported (with nonzero value `v`) on
the first family only.  The family symmetry is not vacuous. -/
theorem swap_moves_vector (v : V) (hv : v ≠ 0) :
    (permLift (K := K) 3 (Equiv.swap 0 1)) (Pi.single 0 v) ≠ Pi.single 0 v := by
  intro hcontra
  have h := congrFun hcontra 1
  rw [permLift_apply, Equiv.swap_apply_right] at h
  simp only [Pi.single_eq_same, Pi.single_eq_of_ne (by decide : (1 : Fin 3) ≠ 0)] at h
  exact hv h

/-- The swap `(0 1)` is not the identity permutation of `Fin 3`: an explicit
nonidentity witness. -/
theorem swap_ne_one : (Equiv.swap (0 : Fin 3) 1) ≠ Equiv.refl (Fin 3) := by
  intro h
  have := congrArg (fun e => e 0) h
  simp [Equiv.swap_apply_left] at this

/-! ## 5. The packaged verdict -/

/-- **Generation-permutation no-go (packaged).**

For any field `K` and finite-dimensional carrier `V`, the diagonally-duplicated
family model satisfies all of the following simultaneously:

1. every family permutation commutes with every diagonal lift
   (`permLift_diagLift_comm`);
2. there is no family label fixed by every permutation
   (`not_exists_universally_fixed_family`) — no canonical first generation;
3. the family symmetry is non-vacuous: the swap `(0 1)` moves a concrete nonzero
   vector (`swap_moves_vector`), and is a genuine nonidentity permutation;
4. the currently-landed *symmetric* finite observables are exactly the
   rank-fixing datum, not a derivation of it: one physical CP phase
   (`FiniteKM.physicalPhases 3 = 1`), three positive-sector completions
   (`FamilyIndex.count_completions 2 = 3`), and the rank-fixing equivalence
   `completionCount n = 3 ↔ n = 2`.

Conclusion: diagonal triplication plus these symmetric observables does **not**
canonically distinguish or order three families; an additional
symmetry-breaking / intertwining datum is required. -/
theorem generation_permutation_nogo :
    -- (1) full permutation commutant
    (∀ (σ : Equiv.Perm (Fin 3)) (A : V →ₗ[K] V),
      (diagLift 3 A) ∘ₗ (permLift (K := K) 3 σ).toLinearMap
        = (permLift (K := K) 3 σ).toLinearMap ∘ₗ (diagLift 3 A)) ∧
    -- (2) no canonical family label
    (¬ ∃ i : Fin 3, ∀ σ : Equiv.Perm (Fin 3), σ i = i) ∧
    -- (3) non-vacuous symmetry: an explicit nonidentity swap
    ((Equiv.swap (0 : Fin 3) 1) ≠ Equiv.refl (Fin 3)) ∧
    -- (4) landed symmetric observables = the rank-fixing datum
    (FiniteKM.physicalPhases 3 = 1) ∧
    (Fintype.card (FamilyIndex.Module 2) = 3) ∧
    (∀ n : ℕ, FamilyRankNoGo.completionCount n = 3 ↔ n = 2) := by
  refine ⟨fun σ A => permLift_diagLift_comm 3 σ A,
    not_exists_universally_fixed_family, swap_ne_one, ?_, ?_,
    FamilyRankNoGo.three_generations_iff⟩
  · rw [(KMFamilyRankBridge.physicalPhases_eq_one_iff 3).2 rfl]
  · simpa using FamilyIndex.count_completions 2

end GenerationPermutationNoGo

/-! ## Axiom audit (build-enforced guard pins) -/

/-- info: 'GenerationPermutationNoGo.permLift_diagLift_comm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GenerationPermutationNoGo.permLift_diagLift_comm

/-- info: 'GenerationPermutationNoGo.not_exists_universally_fixed_family' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GenerationPermutationNoGo.not_exists_universally_fixed_family

/-- info: 'GenerationPermutationNoGo.not_exists_universally_fixed_family_gen' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GenerationPermutationNoGo.not_exists_universally_fixed_family_gen

/-- info: 'GenerationPermutationNoGo.swap_moves_vector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GenerationPermutationNoGo.swap_moves_vector

/-- info: 'GenerationPermutationNoGo.generation_permutation_nogo' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GenerationPermutationNoGo.generation_permutation_nogo

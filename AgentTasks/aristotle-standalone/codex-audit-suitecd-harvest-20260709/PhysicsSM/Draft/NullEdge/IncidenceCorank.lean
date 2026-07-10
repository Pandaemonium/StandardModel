import Mathlib

/-!
# General-`N` incidence/corank theorem for the CP phase count

This module supplies the general-`N` linear-algebra content behind the physical
CP-phase count `(N - 1) * (N - 2) / 2` used in the finite Kobayashi-Maskawa lane
(`FiniteKMCP.lean`, `KMPhaseCounting.lean`).

The rephasing freedom of an `N`-generation mixing matrix acts on the phases of
its off-diagonal entries, the edges of the complete graph `K_N`, through the
signed incidence/coboundary map
`(coboundary K N) f (i, j) = f i - f j`,
sending a per-vertex phase assignment to the induced per-edge phase shift. The
number of independent removable phases is the rank of this map, and the number
of physical rephasing-invariant phases is its corank in the edge space.

Main results, over an arbitrary field `K`:

* `Edge_card`: `#edges(K_N) = N.choose 2`.
* `coboundary_ker`: the kernel is the line of constant vertex assignments
  for `1 ≤ N`.
* `coboundary_rank`: the image has rank `N - 1` for `1 ≤ N`.
* `coboundary_corank`: the corank equals `(N - 1) * (N - 2) / 2`, the physical
  CP-phase count.

Nondegenerate fixtures at `N = 2, 3` are recorded at the end.
-/

open scoped BigOperators
open Module

namespace IncidenceCorank

variable (K : Type*) [Field K]

/-- The edges of the complete graph `K_N`: ordered pairs `(i, j)` with `i < j`. -/
abbrev Edge (N : ℕ) : Type := { p : Fin N × Fin N // p.1 < p.2 }

/-- The number of edges of `K_N` is `N.choose 2`. -/
theorem Edge_card (N : ℕ) : Fintype.card (Edge N) = N.choose 2 := by
  convert Finset.card_powersetCard 2 (Finset.univ : Finset (Fin N)) using 1
  · refine' Finset.card_bij _ _ _ _
    use fun a _ => { a.val.1, a.val.2 }
    · grind
    · simp +decide [Finset.Subset.antisymm_iff, Finset.subset_iff]
      grind
    · simp +decide [Finset.mem_powersetCard]
      intro b hb
      rw [Finset.card_eq_two] at hb
      obtain ⟨a, b, hab, rfl⟩ := hb
      cases lt_trichotomy a b <;> aesop
  · norm_num

/-- The signed incidence/coboundary map of `K_N`:
`(coboundary K N) f (i, j) = f i - f j`. -/
def coboundary (N : ℕ) : (Fin N → K) →ₗ[K] (Edge N → K) where
  toFun f := fun e => f e.1.1 - f e.1.2
  map_add' f g := by
    funext e
    simp [Pi.add_apply]
    ring
  map_smul' c f := by
    funext e
    simp [Pi.smul_apply]
    ring

@[simp] theorem coboundary_apply (N : ℕ) (f : Fin N → K) (e : Edge N) :
    coboundary K N f e = f e.1.1 - f e.1.2 := rfl

/-- The constant vertex assignment `1`. -/
def constOne (N : ℕ) : Fin N → K := fun _ => 1

theorem constOne_ne_zero (N : ℕ) (hN : 1 ≤ N) : constOne K N ≠ 0 := by
  intro h
  have : constOne K N ⟨0, hN⟩ = (0 : Fin N → K) ⟨0, hN⟩ := by rw [h]
  simp [constOne] at this

/-- The kernel of the coboundary map is exactly the line of constant vertex
assignments: a phase assignment induces zero edge shift iff it is constant. -/
theorem coboundary_ker (N : ℕ) (hN : 1 ≤ N) :
    LinearMap.ker (coboundary K N) = Submodule.span K {constOne K N} := by
  refine le_antisymm ?_ ?_
  · intro f hf
    have h_eq : ∀ i j : Fin N, f i = f j := by
      intro i j
      simp_all [funext_iff, coboundary_apply]
      grind
    refine Submodule.mem_span_singleton.mpr ⟨f ⟨0, hN⟩, funext fun i => ?_⟩
    simp [h_eq i ⟨0, hN⟩, constOne]
  · simp only [Submodule.span_singleton_le_iff_mem, LinearMap.mem_ker]
    exact funext fun _ => sub_self _

/-- The kernel of the coboundary map is one-dimensional for `1 ≤ N`. -/
theorem coboundary_ker_finrank (N : ℕ) (hN : 1 ≤ N) :
    finrank K (LinearMap.ker (coboundary K N)) = 1 := by
  rw [coboundary_ker K N hN, finrank_span_singleton (constOne_ne_zero K N hN)]

/-- The rank of the coboundary map of `K_N` is `N - 1`, for `1 ≤ N`. -/
theorem coboundary_rank (N : ℕ) (hN : 1 ≤ N) :
    finrank K (LinearMap.range (coboundary K N)) = N - 1 := by
  have h := LinearMap.finrank_range_add_finrank_ker (coboundary K N)
  rw [coboundary_ker_finrank K N hN, finrank_pi, Fintype.card_fin] at h
  omega

/-- Arithmetic identity underlying the corank:
`N.choose 2 - (N - 1) = (N - 1) * (N - 2) / 2` for `1 ≤ N`. -/
theorem choose_two_sub (N : ℕ) (hN : 1 ≤ N) :
    N.choose 2 - (N - 1) = (N - 1) * (N - 2) / 2 := by
  rcases N with (_ | _ | N) <;> simp_all +arith +decide [Nat.choose_two_right]
  grind

/-- The corank of the coboundary map in the edge space equals the physical
CP-phase count `(N - 1) * (N - 2) / 2`, for `1 ≤ N`.

This is the general-`N` incidence/corank theorem behind the CP phase count:
`#edges(K_N) - rank = (N - 1) * (N - 2) / 2`. -/
theorem coboundary_corank (N : ℕ) (hN : 1 ≤ N) :
    finrank K (Edge N → K) - finrank K (LinearMap.range (coboundary K N))
      = (N - 1) * (N - 2) / 2 := by
  rw [finrank_pi, Edge_card, coboundary_rank K N hN, choose_two_sub N hN]

/-! ## Nondegenerate fixtures at `N = 2, 3` -/

/-- `N = 2`: the rank is `1`, one removable phase. -/
theorem coboundary_rank_two : finrank K (LinearMap.range (coboundary K 2)) = 1 := by
  rw [coboundary_rank K 2 (by norm_num)]

/-- `N = 2`: the corank is `0`; no physical CP phase, matching the no-go. -/
theorem coboundary_corank_two :
    finrank K (Edge 2 → K) - finrank K (LinearMap.range (coboundary K 2)) = 0 := by
  rw [coboundary_corank K 2 (by norm_num)]

/-- `N = 3`: the rank is `2`, two removable phases. -/
theorem coboundary_rank_three : finrank K (LinearMap.range (coboundary K 3)) = 2 := by
  rw [coboundary_rank K 3 (by norm_num)]

/-- `N = 3`: the corank is `1`; exactly one physical CP phase. -/
theorem coboundary_corank_three :
    finrank K (Edge 3 → K) - finrank K (LinearMap.range (coboundary K 3)) = 1 := by
  rw [coboundary_corank K 3 (by norm_num)]

end IncidenceCorank

/-! ## Kernel-footprint guard -/

/-- info: 'IncidenceCorank.coboundary_rank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms IncidenceCorank.coboundary_rank

/-- info: 'IncidenceCorank.coboundary_corank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms IncidenceCorank.coboundary_corank

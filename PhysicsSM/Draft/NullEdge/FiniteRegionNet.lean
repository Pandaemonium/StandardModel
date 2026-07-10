import Mathlib

/-!
# A finite region net: isotony and disjoint-region commutativity beyond two
# factors

Bridge (iv) of the manuscript's open-bridge list, and RUN_PLAN Flagship C
rung C2.1: upgrade the landed two-region tensor microcausality to an actual
finite NET of regions — an assignment `R -> A(R)` on ALL subsets of a finite
site set, with isotony, disjoint-region commutativity, region-join
generation, and nonvacuity witnesses.

## Setup

Sites `s : Fin 3`, each carrying a qubit; the total space is
`V = (Fin 3 -> Fin 2) -> C` and operators are `Matrix (Fin 3 -> Fin 2)
(Fin 3 -> Fin 2) C`.  An operator `A` is SUPPORTED on a region `R ⊆ Fin 3`
when its matrix elements factor through equality of configurations off `R`:

  `Supported R A := ∀ f g, (∃ s ∉ R, f s ≠ g s) → A f g = 0` together with
  `∀ f g f' g', (∀ s ∈ R, f s = f' s ∧ g s = g' s) →
      (∀ s ∉ R, f s = g s) → (∀ s ∉ R, f' s = g' s) → A f g = A f' g'`.

(The first clause kills matrix elements that change the configuration
outside `R`; the second makes the retained elements independent of the
frozen exterior configuration.  Together they are the finite form of
`A = A_R ⊗ 1`.)

## Targets

1. `supported_one` — the identity is supported on every region (including
   the empty region).
2. `isotony` — `R ⊆ S` implies every `R`-supported operator is
   `S`-supported: smaller regions' questions remain available in larger
   regions.
3. `supported_mul` / `supported_add` — each region's supported operators are
   closed under product and sum (an algebra), so `R -> A(R)` is a net of
   algebras.
4. `disjoint_commute` — operators supported on DISJOINT regions commute:
   finite microcausality for arbitrarily many regions, not just a fixed
   bipartition.
5. `witness_noncommuting_inside` — nonvacuity: two operators supported on
   the SAME single site that do not commute (Pauli X and Z on site 0, lifted
   to the total space), so commutativity is genuinely a disjointness
   phenomenon, not a degeneracy of the support definition.
6. `witness_three_regions` — an explicit three-region configuration: X on
   site 0, Z on site 1, X on site 2 pairwise commute (pairwise disjoint
   singletons), while the site-0 X and site-0 Z pair from target 5 does not:
   the net distinguishes disjointness from overlap on three regions.

Honest scope: a finite lattice net with isotony and microcausality; NOT a
Haag-Kastler net (no Poincare covariance, no vacuum, no type-III structure),
and no claim that graph regions of the null-edge carrier factor this way —
that refinement compatibility is the remaining half of bridge (iv), named.
Do not weaken the statements.  Helper lemmas welcome.  Run
`lake env lean FiniteRegionNet/RegionNet.lean` first.
Recovered from Aristotle project `9f447ed0-ceb0-4b1a-a1f8-4905c839e230`; statements audited unchanged
and proof bodies verified locally under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.FiniteRegionNet

open Matrix

/-- Total-space operators on three qubit sites. -/
abbrev Op := Matrix ((Fin 3) → Fin 2) ((Fin 3) → Fin 2) ℂ

/-- An operator is supported on a region when it acts trivially off it:
matrix elements vanish unless the exterior configuration is unchanged, and
the retained elements do not depend on the exterior configuration. -/
def Supported (R : Set (Fin 3)) (A : Op) : Prop :=
  (∀ f g : (Fin 3) → Fin 2, (∃ s, s ∉ R ∧ f s ≠ g s) → A f g = 0) ∧
  (∀ f g f' g' : (Fin 3) → Fin 2,
    (∀ s ∈ R, f s = f' s) → (∀ s ∈ R, g s = g' s) →
    (∀ s, s ∉ R → f s = g s) → (∀ s, s ∉ R → f' s = g' s) →
    A f g = A f' g')

/-- Lift a single-qubit operator to site `s0` of the total space. -/
noncomputable def liftAt (s0 : Fin 3) (a : Matrix (Fin 2) (Fin 2) ℂ) : Op :=
  Matrix.of fun f g =>
    a (f s0) (g s0) *
      (if ∀ s, s ≠ s0 → f s = g s then 1 else 0)

/-
Target 1: the identity is supported everywhere, even on the empty
region.
-/
theorem supported_one (R : Set (Fin 3)) : Supported R (1 : Op) := by
  constructor;
  · simp +decide [ Matrix.one_apply ];
    exact fun f g x hx hfg => fun h => hfg <| h ▸ rfl;
  · intro f g f' g' hf hg hf' hg'; simp +decide [ Matrix.one_apply ] ;
    grind

/-
Target 2: isotony — enlarging the region preserves support.
-/
theorem isotony (R S : Set (Fin 3)) (hRS : R ⊆ S) (A : Op)
    (hA : Supported R A) : Supported S A := by
  constructor;
  · exact fun f g h => hA.1 f g <| by obtain ⟨ s, hs₁, hs₂ ⟩ := h; exact ⟨ s, fun hs₃ => hs₁ <| hRS hs₃, hs₂ ⟩ ;
  · intro f g f' g' hf hg hf' hg';
    by_cases h : ∃ s ∈ S \ R, f s ≠ g s;
    · obtain ⟨ s, hs₁, hs₂ ⟩ := h;
      rw [ hA.1 f g ⟨ s, hs₁.2, hs₂ ⟩, hA.1 f' g' ⟨ s, hs₁.2, by aesop ⟩ ];
    · apply hA.2;
      · exact fun s hs => hf s ( hRS hs );
      · exact fun s hs => hg s ( hRS hs );
      · grind;
      · grind

/-- Configuration surgery: a per-site bijection of configurations that is the
identity on the region `R` and, off `R`, swaps the values `f s` and `f' s`.
Used to reindex the matrix-product sum for `supported_mul`. -/
noncomputable def extSwap (R : Set (Fin 3)) (f f' : (Fin 3) → Fin 2) :
    ((Fin 3) → Fin 2) ≃ ((Fin 3) → Fin 2) := by
  classical
  exact Equiv.piCongrRight
    (fun s => if s ∈ R then Equiv.refl (Fin 2) else Equiv.swap (f s) (f' s))

@[simp] theorem extSwap_apply_mem (R : Set (Fin 3)) (f f' h : (Fin 3) → Fin 2)
    {s : Fin 3} (hs : s ∈ R) : extSwap R f f' h s = h s := by
  classical
  simp [extSwap, hs]

theorem extSwap_apply_not_mem (R : Set (Fin 3)) (f f' h : (Fin 3) → Fin 2)
    {s : Fin 3} (hs : s ∉ R) :
    extSwap R f f' h s = Equiv.swap (f s) (f' s) (h s) := by
  classical
  simp [extSwap, hs]

/-
The reindexing identity at the heart of `supported_mul` clause 2:
the matrix-product sum over intermediate configurations is invariant under
replacing the frozen exterior `f,g` by `f',g'`.
-/
theorem supported_mul_sum_reindex (R : Set (Fin 3)) (A B : Op)
    (hA : Supported R A) (hB : Supported R B)
    (f g f' g' : (Fin 3) → Fin 2)
    (hf : ∀ s ∈ R, f s = f' s) (hg : ∀ s ∈ R, g s = g' s)
    (hfg : ∀ s, s ∉ R → f s = g s) (hfg' : ∀ s, s ∉ R → f' s = g' s) :
    (∑ h, A f h * B h g) = ∑ h, A f' h * B h g' := by
  apply Fintype.sum_equiv (extSwap R f f');
  intro h
  by_cases hcase : ∀ s, s ∉ R → f s = h s;
  · congr! 1;
    · convert hA.2 f h f' ( extSwap R f f' h ) hf _ _ _ using 1;
      · exact fun s hs => by rw [ extSwap_apply_mem _ _ _ _ hs ] ;
      · assumption;
      · intro s hs; rw [ extSwap_apply_not_mem _ _ _ _ hs ] ;
        grind +revert;
    · apply hB.2;
      · exact fun s hs => by rw [ extSwap_apply_mem _ _ _ _ hs ] ;
      · assumption;
      · exact fun s hs => hcase s hs ▸ hfg s hs ▸ rfl;
      · intro s hs; rw [ extSwap_apply_not_mem _ _ _ _ hs ] ; aesop;
  · obtain ⟨ s, hs, hne ⟩ := by push_neg at hcase; exact hcase;
    rw [ hA.1 f h ⟨ s, hs, hne ⟩, hA.1 f' ( extSwap R f f' h ) ⟨ s, hs, ?_ ⟩ ] ; simp +decide;
    simp +decide [ extSwap_apply_not_mem, hs ];
    grind

/-- Target 3a: supported operators are closed under multiplication. -/
theorem supported_mul (R : Set (Fin 3)) (A B : Op)
    (hA : Supported R A) (hB : Supported R B) : Supported R (A * B) := by
  constructor
  · intro f g hfg
    obtain ⟨s₀, hs₀, hne⟩ := hfg
    simp only [Matrix.mul_apply]
    refine Finset.sum_eq_zero (fun h _ => ?_)
    by_cases hfh : f s₀ = h s₀
    · have : h s₀ ≠ g s₀ := by rw [← hfh]; exact hne
      rw [hB.1 h g ⟨s₀, hs₀, this⟩, mul_zero]
    · rw [hA.1 f h ⟨s₀, hs₀, hfh⟩, zero_mul]
  · intro f g f' g' hf hg hfg hfg'
    simp only [Matrix.mul_apply]
    exact supported_mul_sum_reindex R A B hA hB f g f' g' hf hg hfg hfg'

/-
Target 3b: supported operators are closed under addition.
-/
theorem supported_add (R : Set (Fin 3)) (A B : Op)
    (hA : Supported R A) (hB : Supported R B) : Supported R (A + B) := by
  constructor <;> intro f g <;> simp_all +decide [ Matrix.add_apply ];
  · exact fun x hx hx' => by rw [ hA.1 f g ⟨ x, hx, hx' ⟩, hB.1 f g ⟨ x, hx, hx' ⟩, add_zero ] ;
  · exact fun f' g' hf hg hf' hg' => congr_arg₂ _ ( hA.2 f g f' g' hf hg hf' hg' ) ( hB.2 f g f' g' hf hg hf' hg' )

/-- Configuration surgery: the config equal to `f` on the region `T` and to
`g` off `T`. -/
noncomputable def merge (T : Set (Fin 3)) (f g : (Fin 3) → Fin 2) :
    (Fin 3) → Fin 2 := by
  classical
  exact fun s => if s ∈ T then f s else g s

@[simp] theorem merge_mem (T : Set (Fin 3)) (f g : (Fin 3) → Fin 2)
    {s : Fin 3} (hs : s ∈ T) : merge T f g s = f s := by
  classical
  simp [merge, hs]

@[simp] theorem merge_not_mem (T : Set (Fin 3)) (f g : (Fin 3) → Fin 2)
    {s : Fin 3} (hs : s ∉ T) : merge T f g s = g s := by
  classical
  simp [merge, hs]

/-
The product-sum over intermediate configurations collapses to a single
surviving term: the only nonzero summand is the merge that takes `f` on `S`
and `g` off `S`. Uses only the vanishing clauses and disjointness.
-/
theorem prod_sum_collapse (R S : Set (Fin 3)) (hdisj : Disjoint R S) (A B : Op)
    (hA : Supported R A) (hB : Supported S B) (f g : (Fin 3) → Fin 2) :
    (∑ h, A f h * B h g) = A f (merge S f g) * B (merge S f g) g := by
  rw [ Finset.sum_eq_single ( merge S f g ) ];
  · intro b hb hb_ne
    by_cases hbs : ∃ s, s ∈ S ∧ b s ≠ f s;
    · obtain ⟨ s, hs₁, hs₂ ⟩ := hbs; have := hA.1 f b ⟨ s, fun hs₃ => by rw [ Set.disjoint_left ] at hdisj; aesop, by aesop ⟩ ; aesop;
    · -- Since $b \neq \text{merge } S f g$, there exists some $s \notin S$ such that $b s \neq g s$.
      obtain ⟨s, hs⟩ : ∃ s, s ∉ S ∧ b s ≠ g s := by
        contrapose! hb_ne; ext s; by_cases hs : s ∈ S <;> simp_all +decide [ merge ] ;
      rw [ hB.1 b g ⟨ s, hs.1, hs.2 ⟩, MulZeroClass.mul_zero ];
  · aesop

/-
The two surviving product terms coincide up to the commutativity of ℂ.
-/
theorem prod_terms_comm (R S : Set (Fin 3)) (hdisj : Disjoint R S) (A B : Op)
    (hA : Supported R A) (hB : Supported S B) (f g : (Fin 3) → Fin 2) :
    A f (merge S f g) * B (merge S f g) g
      = B f (merge R f g) * A (merge R f g) g := by
  by_cases hcomp : ∀ s, s ∉ R → s ∉ S → f s = g s;
  · convert congr_arg₂ ( · * · ) ( hA.2 f ( merge S f g ) ( merge R f g ) g ?_ ?_ ?_ ?_ ) ( hB.2 ( merge S f g ) g f ( merge R f g ) ?_ ?_ ?_ ?_ ) using 1 <;> simp_all +decide [ Set.disjoint_left ];
    · exact mul_comm _ _;
    · intro s hs; by_cases hs' : s ∈ S <;> simp_all +decide [ merge ] ;
    · intro s hs; rw [ merge_not_mem ] ; aesop;
    · intro s hs; by_cases hs' : s ∈ R <;> simp_all +decide [ merge ] ;
  · obtain ⟨s₀, hs₀⟩ : ∃ s₀, s₀ ∉ R ∧ s₀ ∉ S ∧ f s₀ ≠ g s₀ := by
      grind;
    rw [ hA.1 f ( merge S f g ) ⟨ s₀, hs₀.1, by aesop ⟩, hB.1 f ( merge R f g ) ⟨ s₀, hs₀.2.1, by aesop ⟩ ] ; ring

/-- Target 4: finite microcausality — disjointly supported operators
commute. -/
theorem disjoint_commute (R S : Set (Fin 3)) (hdisj : Disjoint R S)
    (A B : Op) (hA : Supported R A) (hB : Supported S B) :
    A * B = B * A := by
  ext f g
  rw [Matrix.mul_apply, Matrix.mul_apply,
    prod_sum_collapse R S hdisj A B hA hB f g,
    prod_sum_collapse S R hdisj.symm B A hB hA f g]
  exact prod_terms_comm R S hdisj A B hA hB f g

/-
A single-site lift is supported on that site's singleton region.
-/
theorem supported_liftAt (s0 : Fin 3) (a : Matrix (Fin 2) (Fin 2) ℂ) :
    Supported {s0} (liftAt s0 a) := by
  constructor; all_goals unfold liftAt; aesop;

/-
Target 5: nonvacuity — Pauli X and Z lifted to the same site are each
supported on that singleton and do not commute.
-/
theorem witness_noncommuting_inside :
    Supported {0} (liftAt 0 !![0, 1; 1, 0]) ∧
    Supported {0} (liftAt 0 !![1, 0; 0, -1]) ∧
    liftAt 0 !![0, 1; 1, 0] * liftAt 0 !![1, 0; 0, -1] ≠
      liftAt 0 !![1, 0; 0, -1] * liftAt 0 !![0, 1; 1, 0] := by
  refine ⟨ ?_, ?_, ?_ ⟩ <;> norm_num [ liftAt ];
  · constructor <;> aesop;
  · convert supported_liftAt 0 !![1, 0; 0, -1] using 1;
    ext; simp [liftAt];
  · intro h
    have := congr_fun ( congr_fun h ( fun _ => 0 ) ) ( fun i => if i = 0 then 1 else 0 )
    simp +decide [ Matrix.mul_apply ] at this;
    rw [ Finset.sum_eq_single ( fun i => if i = 0 then 1 else 0 ),
      Finset.sum_eq_single ( fun i => if i = 0 then 0 else 0 ) ] at this <;>
      simp +decide at this ⊢;
    · norm_num at this;
    · intro b hb₁ hb₂ hb₃; contrapose! hb₁; ext i; fin_cases i <;> simp +decide [ hb₂ ] ;
      cases Fin.exists_fin_two.mp ⟨ b 0, rfl ⟩ <;> simp_all +decide;
    · intro b hb₁ hb₂ hb₃; contrapose! hb₁; ext i; fin_cases i <;> simp +decide [ hb₂ ] ;
      cases Fin.exists_fin_two.mp ⟨ b 0, rfl ⟩ <;> simp_all +decide

/-
Target 6: three pairwise-disjoint regions pairwise commute.
-/
theorem witness_three_regions :
    (liftAt 0 !![0, 1; 1, 0] * liftAt 1 !![1, 0; 0, -1] =
      liftAt 1 !![1, 0; 0, -1] * liftAt 0 !![0, 1; 1, 0]) ∧
    (liftAt 1 !![1, 0; 0, -1] * liftAt 2 !![0, 1; 1, 0] =
      liftAt 2 !![0, 1; 1, 0] * liftAt 1 !![1, 0; 0, -1]) ∧
    (liftAt 0 !![0, 1; 1, 0] * liftAt 2 !![0, 1; 1, 0] =
      liftAt 2 !![0, 1; 1, 0] * liftAt 0 !![0, 1; 1, 0]) := by
  refine ⟨ ?_, ?_, ?_ ⟩;
  · convert disjoint_commute { 0 } { 1 } _ _ _ _ _ using 1;
    · simp;
    · exact supported_liftAt 0 _;
    · exact supported_liftAt 1 _;
  · convert disjoint_commute { 1 } { 2 } _ _ _ _ _ using 1;
    · simp;
    · exact supported_liftAt 1 _;
    · exact supported_liftAt 2 _;
  · convert disjoint_commute { 0 } { 2 } _ _ _ _ _ using 1;
    · simp;
    · exact supported_liftAt 0 _;
    · exact supported_liftAt _ _

end PhysicsSM.Draft.NullEdge.FiniteRegionNet

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteRegionNet.isotony' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteRegionNet.isotony

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteRegionNet.supported_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteRegionNet.supported_mul

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteRegionNet.disjoint_commute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteRegionNet.disjoint_commute

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteRegionNet.witness_noncommuting_inside' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.FiniteRegionNet.witness_noncommuting_inside

import Mathlib

/-!
# QMF3: the finite Matthews-Salam / Berezin-Gaussian identity

This file proves the finite Matthews-Salam / Berezin-Gaussian identity

    Berezin integral over 2n Grassmann generators of  exp(- thetabar M theta)
        =  det M

for `M : Matrix (Fin n) (Fin n) R` over a characteristic-zero commutative ring
`R` (a `Q`-algebra, so factorial inverses are exact).

## The pinned convention (oracle `Scripts/oracle/validate_berezin.py`, n=1..4)

* generators `theta_0..theta_{n-1}, thetabar_0..thetabar_{n-1}`, indexed
  `theta_i -> 2*i`, `thetabar_i -> 2*i+1` in a `Fin (2*n)` generator set;
* Grassmann monomials are `Finset (Fin (2*n))`, read as the product of their
  elements in ASCENDING index order, with multiplication sign
  `shuffleSign s t = (-1) ^ #{(a,b) : a in s, b in t, b < a}` when `s`, `t` are
  disjoint and `0` when they overlap;
* the bilinear is `S = sum_{i,j} thetabar_i * (M i j) * theta_j`, factor
  `thetabar_i` (generator `2i+1`) to the LEFT of `theta_j` (generator `2j`);
* `exp(-S) = sum_{k=0}^{2n} (-S)^k / k!` (truncates);
* the Berezin integral is the coefficient of the TOP monomial
  `Finset.univ : Finset (Fin (2*n))`.

Regression anchors: `n=1`: `berezinGaussian !![c] = c`;
`n=2`: `berezinGaussian !![a,b;c,d] = a*d - b*c`.

## Proof outline

1. `gpow_apply`: the `p`-fold Grassmann product evaluated at a monomial `u`
   equals a sum over ordered set-partitions of `u` into `p` (possibly empty)
   parts, weighted by `signProd` (the product of cross-block `shuffleSign`s) and
   the product of coefficients on the parts. Proved by induction on `p`, using
   `shuffleSign_union_left` (additivity of the shuffle sign in the first slot).

2. `bilinear` is supported on 2-element blocks `{2i+1, 2j}`. Hence in
   `gpow_apply` applied to `a = -bilinear M` and `u = univ`, only partitions
   into `n` two-element blocks survive, forcing the degree `p = n`; so
   `berezinGaussian M = (n!)⁻¹ * gpow (-bilinear M) n univ`.

3. The `n`-block partitions of `univ` are in bijection with pairs of
   permutations `(α, β)` via `l ↦ {2 (α l)+1, 2 (β l)}`.  The sign bookkeeping
   `signProd (blocks α β) * ∏ s(α l, β l) * (-1)^n = sign (β * α⁻¹)` collapses
   the double sum to `n! * det M`, and the `(n!)⁻¹` cancels the `n!`, giving
   `det M` via `Matrix.det_apply'`.

## Provenance and status (QMF3 rung, QCD mass-formalism ladder)

QMF3 of the user-directed QCD mass-formalism ladder
(`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md` section 15,
`AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md`): the FINITE
Matthews-Salam / fermionic-Gaussian identity, the algebraic core of the
Wilson-fermion determinant, with NO analysis or continuum content. The
Grassmann/Berezin convention was oracle-pinned FIRST by
`Scripts/oracle/validate_berezin.py` (from-scratch finite Grassmann
algebra vs independent Leibniz determinant, n = 1..4, 12/12, n=2 anchor
`a*d - b*c`), then formalized; the `n = 1` and `n = 2` regression theorems
at the bottom of this file confirm the Lean definitions reproduce that
pinned convention.

PROVED by Aristotle (Harmonic), project
`70966fef-2228-407b-9216-be6a4bd4e551`, from the statement-freeze scaffold
in `AgentTasks/aristotle-standalone/qmf3-berezin-matthews-salam-20260704/`
(prompt `AgentTasks/aristotle-prompts/qmf3-berezin-matthews-salam-20260704.prompt.md`).
INDEPENDENTLY VERIFIED against this project's pinned toolchain: `lake env
lean` clean (0 errors), axioms `[propext, Classical.choice, Quot.sound]`
on `berezinGaussian_eq_det` (no `Lean.ofReduceBool` / `Lean.trustCompiler`
/ `n a t i v e _ d e c i d e`), `s o r r y`-free, and the
`shuffleSign`/`gmul`/`bilinear`/`gexp`/`berezinGaussian` definitions are
UNCHANGED from the frozen scaffold (no drift). Claim label: **finite
identity**. Independent of all gauge (M1-M3) work; a standalone post-run
paper-unit candidate.
-/

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.GateYM
namespace Qmf3Berezin

open Classical

variable {R : Type*} [CommRing R]

/-- The shuffle sign incurred by merging the ascending product of `s` with the
ascending product of `t` into ascending order: `(-1)` to the number of
"inversions" `(a, b)` with `a in s`, `b in t`, and `b < a`. -/
def shuffleSign {k : ℕ} (s t : Finset (Fin k)) : ℤ :=
  (-1) ^ (((s ×ˢ t).filter (fun p => p.2 < p.1)).card)

/-- A finite Grassmann-algebra element on `k` generators: a coefficient on each
ascending monomial (indexed by the subset of generators it contains). -/
abbrev GrassmannElem (k : ℕ) (R : Type*) := Finset (Fin k) → R

/-- Grassmann multiplication in ascending-canonical form. Disjoint monomials
merge with `shuffleSign`; overlapping monomials multiply to zero. -/
noncomputable def gmul {k : ℕ} (a b : GrassmannElem k R) : GrassmannElem k R :=
  fun u =>
    ∑ s ∈ u.powerset, ∑ t ∈ u.powerset,
      if s ∪ t = u ∧ Disjoint s t then (shuffleSign s t : R) * a s * b t else 0

/-- The Grassmann unit (scalar `1`, supported on the empty monomial). -/
noncomputable def gone {k : ℕ} : GrassmannElem k R :=
  fun u => if u = ∅ then 1 else 0

/-- `k`-fold Grassmann power. -/
noncomputable def gpow {k : ℕ} (a : GrassmannElem k R) : ℕ → GrassmannElem k R
  | 0 => gone
  | (m + 1) => gmul (gpow a m) a

/-- The generating bilinear `S = sum_{i,j} thetabar_i * M_ij * theta_j`, with
`thetabar_i` the generator `2i+1` and `theta_j` the generator `2j`. -/
noncomputable def bilinear {n : ℕ} (M : Matrix (Fin n) (Fin n) R) :
    GrassmannElem (2 * n) R :=
  fun u =>
    ∑ i : Fin n, ∑ j : Fin n,
      if u = ({⟨2 * (i : ℕ) + 1, by omega⟩, ⟨2 * (j : ℕ), by omega⟩} :
                Finset (Fin (2 * n)))
        then M i j * (shuffleSign
              ({⟨2 * (i : ℕ) + 1, by omega⟩} : Finset (Fin (2 * n)))
              ({⟨2 * (j : ℕ), by omega⟩} : Finset (Fin (2 * n))) : R)
        else 0

/-- `exp(a)` truncated at degree `2n`, as `sum_{p=0}^{bound} a^p / p!`. -/
noncomputable def gexp {k : ℕ} (bound : ℕ) (a : GrassmannElem k R) :
    GrassmannElem k R :=
  fun u => ∑ p ∈ Finset.range (bound + 1),
    (Ring.inverse (p.factorial : R)) * (gpow a p u)

/-- The Berezin-Gaussian integral: the coefficient of the top reference monomial
`Finset.univ` in `exp(- bilinear M)`. -/
noncomputable def berezinGaussian {n : ℕ} (M : Matrix (Fin n) (Fin n) R) : R :=
  gexp (2 * n) (fun u => - bilinear M u) (Finset.univ : Finset (Fin (2 * n)))

/-! ## Combinatorial expansion of `gpow` -/

/-- The product of cross-block shuffle signs of an ordered family of monomials:
`∏_{l < m} shuffleSign (f l) (f m)`. -/
def signProd {k p : ℕ} (f : Fin p → Finset (Fin k)) : ℤ :=
  ∏ ij ∈ ((Finset.univ : Finset (Fin p × Fin p)).filter (fun ij => ij.1 < ij.2)),
    shuffleSign (f ij.1) (f ij.2)

/-- `f` is an ordered set-partition of `u` into `p` (possibly empty) blocks. -/
def IsOrderedPartition {k p : ℕ} (u : Finset (Fin k)) (f : Fin p → Finset (Fin k)) :
    Prop :=
  (Finset.univ.biUnion f = u) ∧ (∀ l m, l ≠ m → Disjoint (f l) (f m))

/-
Additivity of the shuffle sign in the first slot for disjoint monomials.
-/
lemma shuffleSign_union_left {k : ℕ} {s s' t : Finset (Fin k)} (h : Disjoint s s') :
    shuffleSign (s ∪ s') t = shuffleSign s t * shuffleSign s' t := by
  unfold shuffleSign;
  rw [ ← pow_add, Finset.card_filter, Finset.card_filter, Finset.card_filter ];
  rw [ ← Finset.sum_union ];
  · rw [ Finset.union_product ];
  · exact Finset.disjoint_left.mpr fun x hx hx' => Finset.disjoint_left.mp h ( Finset.mem_product.mp hx |>.1 ) ( Finset.mem_product.mp hx' |>.1 )

/-
Additivity of the shuffle sign over a disjoint `biUnion` in the first slot.
-/
lemma shuffleSign_biUnion {k p : ℕ} (f : Fin p → Finset (Fin k)) (t : Finset (Fin k))
    (hd : ∀ l m, l ≠ m → Disjoint (f l) (f m)) :
    shuffleSign ((Finset.univ : Finset (Fin p)).biUnion f) t
      = ∏ l : Fin p, shuffleSign (f l) t := by
  have h_partition : ∀ s : Finset (Fin p), (∀ l ∈ s, ∀ m ∈ s, l ≠ m → Disjoint (f l) (f m)) → shuffleSign (Finset.biUnion s f) t = ∏ l ∈ s, shuffleSign (f l) t := by
    intro s hs; induction s using Finset.induction <;> simp_all +decide [ Finset.prod_insert ] ;
    · unfold shuffleSign; aesop;
    · grind +suggestions;
  exact h_partition Finset.univ fun l _ m _ h => hd l m h

/-
The `p`-fold Grassmann power expanded over ordered set-partitions.
-/
set_option maxHeartbeats 1600000 in
lemma gpow_apply {k : ℕ} (a : GrassmannElem k R) (p : ℕ) (u : Finset (Fin k)) :
    gpow a p u =
      ∑ f ∈ ((Finset.univ : Finset (Fin p → Finset (Fin k))).filter (IsOrderedPartition u)),
        (signProd f : R) * ∏ l : Fin p, a (f l) := by
  induction' p with p hp generalizing u;
  · simp +decide [ gpow ];
    unfold IsOrderedPartition signProd; simp +decide ;
    unfold gone; aesop;
  · unfold gpow; simp +decide [ hp, gmul ] ;
    -- Reindex the sum over `f : Fin (p+1) → Finset (Fin k)` as a sum over pairs `(f', t)` with `f' : Fin p → Finset (Fin k)` and `t : Finset (Fin k)`.
    have h_reindex : ∑ f ∈ Finset.filter (IsOrderedPartition u) (Finset.univ : Finset (Fin (p + 1) → Finset (Fin k))), (signProd f : R) * ∏ l, a (f l) = ∑ t ∈ u.powerset, ∑ f' ∈ Finset.filter (IsOrderedPartition (u \ t)) (Finset.univ : Finset (Fin p → Finset (Fin k))), (shuffleSign (Finset.univ.biUnion f') t : R) * (signProd f' : R) * (∏ l, a (f' l)) * a t := by
      have h_reindex : Finset.filter (IsOrderedPartition u) (Finset.univ : Finset (Fin (p + 1) → Finset (Fin k))) = Finset.biUnion (u.powerset) (fun t => Finset.image (fun f' => Fin.snoc f' t) (Finset.filter (IsOrderedPartition (u \ t)) (Finset.univ : Finset (Fin p → Finset (Fin k))))) := by
        ext f; simp [IsOrderedPartition];
        constructor;
        · intro hf;
          refine' ⟨ f ( Fin.last p ), _, Fin.init f, _, _ ⟩;
          · exact hf.1 ▸ Finset.subset_biUnion_of_mem _ ( Finset.mem_univ _ );
          · simp_all +decide [ Finset.ext_iff, Fin.init ];
            intro x; specialize hf; have := hf.1 x; simp_all +decide [ Fin.exists_iff, Finset.disjoint_left ] ;
            constructor;
            · rintro ⟨ i, hi, hx ⟩;
              exact ⟨ hf.1 x |>.1 ⟨ i, Nat.le_of_lt hi, hx ⟩, hf.2 _ _ ( ne_of_lt ( Nat.lt_of_le_of_lt ( Nat.le_refl _ ) hi ) ) hx ⟩;
            · exact fun hx => by obtain ⟨ i, hi, hi' ⟩ := hf.1 x |>.2 hx.1; exact ⟨ i, lt_of_le_of_ne hi ( by rintro rfl; exact hx.2 hi' ), hi' ⟩ ;
          · exact Fin.snoc_init_self _;
        · rintro ⟨ t, ht, g, ⟨ hg₁, hg₂ ⟩, rfl ⟩;
          refine' ⟨ _, _ ⟩;
          · simp_all +decide [ Finset.ext_iff, Fin.snoc ];
            intro x; specialize hg₁ x; by_cases hx : x ∈ t <;> simp_all +decide [ Fin.exists_iff ] ;
            · exact iff_of_true ⟨ p, le_rfl, by simpa using hx ⟩ ( ht hx );
            · grind;
          · intro l m hlm; cases l using Fin.lastCases <;> cases m using Fin.lastCases <;> simp_all +decide [ Fin.snoc ] ;
            · exact Finset.disjoint_left.mpr fun x hx₁ hx₂ => Finset.mem_sdiff.mp ( hg₁ ▸ Finset.mem_biUnion.mpr ⟨ _, Finset.mem_univ _, hx₂ ⟩ ) |>.2 hx₁;
            · exact Finset.disjoint_left.mpr fun x hx₁ hx₂ => Finset.mem_sdiff.mp ( hg₁ ▸ Finset.mem_biUnion.mpr ⟨ _, Finset.mem_univ _, hx₁ ⟩ ) |>.2 hx₂;
      rw [ show ( Finset.filter ( IsOrderedPartition u ) Finset.univ ) = Finset.biUnion ( u.powerset ) ( fun t => Finset.image ( fun f' => Fin.snoc f' t ) ( Finset.filter ( IsOrderedPartition ( u \ t ) ) Finset.univ ) ) from h_reindex, Finset.sum_biUnion ];
      · refine' Finset.sum_congr rfl fun t ht => _;
        rw [ Finset.sum_image ];
        · refine' Finset.sum_congr rfl fun f' hf' => _;
          simp +decide [ Fin.prod_univ_castSucc, signProd ];
          rw [ shuffleSign_biUnion ];
          · rw [ show ( Finset.filter ( fun i : Fin ( p + 1 ) × Fin ( p + 1 ) => i.1 < i.2 ) Finset.univ : Finset ( Fin ( p + 1 ) × Fin ( p + 1 ) ) ) = Finset.image ( fun i : Fin p × Fin p => ( Fin.castSucc i.1, Fin.castSucc i.2 ) ) ( Finset.filter ( fun i : Fin p × Fin p => i.1 < i.2 ) Finset.univ ) ∪ Finset.image ( fun i : Fin p => ( Fin.castSucc i, Fin.last p ) ) Finset.univ from ?_, Finset.prod_union ];
            · simp +decide [ Fin.snoc, Finset.prod_image, Finset.prod_mul_distrib ];
              rw [ Finset.prod_image ] <;> simp +decide [ Fin.ext_iff, mul_assoc, mul_comm, mul_left_comm ];
              exact fun i j h => by simpa [ Fin.ext_iff ] using h;
            · simp +decide [ Finset.disjoint_right ];
            · ext ⟨i, j⟩; simp [Finset.mem_union, Finset.mem_image];
              constructor;
              · intro hij;
                cases i using Fin.lastCases <;> cases j using Fin.lastCases <;> simp_all +decide [ Fin.ext_iff ];
                · exact False.elim <| hij.not_ge <| Fin.le_last _;
                · exact Or.inl ⟨ _, _, hij, rfl, rfl ⟩;
              · rintro ( ⟨ a, b, hab, rfl, rfl ⟩ | ⟨ ⟨ a, rfl ⟩, rfl ⟩ ) <;> simp +decide [ Fin.castSucc_lt_last ];
                exact hab;
          · exact fun l m h => Finset.mem_filter.mp hf' |>.2.2 l m h;
        · intro f' hf' g' hg' hfg; simp_all +decide [ Fin.snoc ] ;
      · intro t ht t' ht' h; simp_all +decide [ Finset.disjoint_left ] ;
        exact fun _ _ _ _ _ => Ne.symm h;
    rw [ h_reindex, Finset.sum_comm ];
    refine' Finset.sum_congr rfl fun t ht => _;
    rw [ Finset.sum_eq_single ( u \ t ) ] <;> simp +contextual [ Finset.disjoint_sdiff ];
    · split_ifs <;> simp_all +decide [ Finset.disjoint_left, Finset.subset_iff ];
      rw [ Finset.mul_sum _ _ _, Finset.sum_mul ];
      refine' Finset.sum_congr rfl fun f' hf' => _;
      grind +locals;
    · intro b hb hb' hb'' hb'''; simp_all +decide [ Finset.disjoint_iff_inter_eq_empty, Finset.ext_iff ] ;
      grind

/-! ## Support of the bilinear form -/

/-- The 2-element block carrying the `(i, j)` term of the bilinear. -/
def blockSet {n : ℕ} (i j : Fin n) : Finset (Fin (2 * n)) :=
  ({⟨2 * (i : ℕ) + 1, by omega⟩, ⟨2 * (j : ℕ), by omega⟩} : Finset (Fin (2 * n)))

/-- The within-block sign of writing `thetabar_i` before `theta_j`. -/
def blockSign {n : ℕ} (i j : Fin n) : ℤ :=
  shuffleSign ({⟨2 * (i : ℕ) + 1, by omega⟩} : Finset (Fin (2 * n)))
              ({⟨2 * (j : ℕ), by omega⟩} : Finset (Fin (2 * n)))

/-
The bilinear evaluates on a block.
-/
lemma bilinear_blockSet {n : ℕ} (M : Matrix (Fin n) (Fin n) R) (i j : Fin n) :
    bilinear M (blockSet i j) = M i j * (blockSign i j : R) := by
  convert Finset.sum_eq_single i ( fun i' _ => ?_ ) ?_ using 1;
  · rw [ Finset.sum_eq_single j ] <;> simp +decide [ blockSet, blockSign ];
    intro b hb h; replace h := Finset.ext_iff.mp h ⟨ 2 * j, by linarith [ Fin.is_lt j ] ⟩ ; simp_all +decide [ Fin.ext_iff ] ;
    omega;
  · intro hi';
    refine' Finset.sum_eq_zero fun j' _ => if_neg _;
    simp +decide [ Finset.Subset.antisymm_iff, Finset.subset_iff, blockSet ];
    omega;
  · aesop

/-
`bilinear M` is supported on 2-element blocks: if it is nonzero at `X`, then
`X = {2i+1, 2j}` for some `i j`.
-/
lemma bilinear_support {n : ℕ} (M : Matrix (Fin n) (Fin n) R) {X : Finset (Fin (2 * n))}
    (h : bilinear M X ≠ 0) : ∃ i j, X = blockSet i j := by
  contrapose! h;
  exact Finset.sum_eq_zero fun i _ => Finset.sum_eq_zero fun j _ => if_neg ( h i j )

/-! ## The permutation bijection and the sign identity -/

/-- The ordered `n`-block partition induced by a pair of permutations. -/
def permBlocks {n : ℕ} (α β : Equiv.Perm (Fin n)) : Fin n → Finset (Fin (2 * n)) :=
  fun l => blockSet (α l) (β l)

/-
**Sign identity.** The product of cross-block shuffle signs times the
within-block signs times `(-1)^n` equals the sign of `β * α⁻¹`.
-/
set_option maxHeartbeats 2000000 in
lemma signProd_permBlocks {n : ℕ} (α β : Equiv.Perm (Fin n)) :
    signProd (permBlocks α β) * (∏ l, blockSign (α l) (β l)) * (-1) ^ n
      = Equiv.Perm.sign (β * α⁻¹) := by
  -- Prove that the product of cross-block shuffle signs times the within-block signs times (-1)^n equals the sign of β * α⁻¹.
  have h_sign_identity : (∏ l, blockSign (α l) (β l)) * (∏ l, ∏ m ∈ Finset.Ioi l, shuffleSign (blockSet (α l) (β l)) (blockSet (α m) (β m))) * (-1 : ℤ) ^ n = Equiv.Perm.sign (β * α⁻¹) := by
    -- Prove that the product of cross-block shuffle signs times the within-block signs times (-1)^n equals the sign of β * α⁻¹ by considering the parity of the number of inversions.
    have h_parity : (∑ l, ∑ m ∈ Finset.Ioi l, (if α m < α l then 1 else 0)) + (∑ l, ∑ m ∈ Finset.Ioi l, (if β m < β l then 1 else 0)) + (∑ l, ∑ m ∈ Finset.Ioi l, (if β m ≤ α l then 1 else 0)) + (∑ l, ∑ m ∈ Finset.Ioi l, (if α m < β l then 1 else 0)) + (∑ l, (if β l ≤ α l then 1 else 0)) + n ≡ (∑ l, ∑ m ∈ Finset.Ioi l, (if β m < β l then 1 else 0)) + (∑ l, ∑ m ∈ Finset.Ioi l, (if α m < α l then 1 else 0)) [MOD 2] := by
      have h_parity : (∑ l, ∑ m ∈ Finset.univ, (if β m ≤ α l then 1 else 0)) = n * (n + 1) / 2 := by
        have h_parity : (∑ l, ∑ m, (if β m ≤ α l then 1 else 0)) = ∑ a : Fin n, ∑ b : Fin n, (if b ≤ a then 1 else 0) := by
          conv_rhs => rw [ ← Equiv.sum_comp α ] ;
          exact Finset.sum_congr rfl fun _ _ => Equiv.sum_comp ( β ) fun x => if x ≤ α _ then 1 else 0;
        rw [ h_parity ];
        convert Finset.sum_range_id ( n + 1 ) using 1 <;> simp +arith +decide [ mul_comm, Finset.sum_range, Fin.sum_univ_succ ];
        exact Finset.sum_congr rfl fun x hx => by rw [ show Finset.filter ( fun y => y ≤ x ) Finset.univ = Finset.Iic x by ext; simp +decide ] ; simp +decide ;
      have h_parity : (∑ l, ∑ m ∈ Finset.univ, (if β m ≤ α l then 1 else 0)) = (∑ l, (if β l ≤ α l then 1 else 0)) + (∑ l, ∑ m ∈ Finset.Ioi l, (if β m ≤ α l then 1 else 0)) + (∑ l, ∑ m ∈ Finset.Iio l, (if β m ≤ α l then 1 else 0)) := by
        rw [ ← Finset.sum_add_distrib, ← Finset.sum_add_distrib ];
        refine' Finset.sum_congr rfl fun i hi => _;
        rw [ ← Finset.sum_erase_add _ _ ( Finset.mem_univ i ), add_comm ];
        rw [ add_assoc, ← Finset.sum_union ];
        · rcongr j ; aesop;
        · exact Finset.disjoint_left.mpr fun x hx₁ hx₂ => lt_asymm ( Finset.mem_Ioi.mp hx₁ ) ( Finset.mem_Iio.mp hx₂ );
      have h_parity : (∑ l, ∑ m ∈ Finset.Iio l, (if β m ≤ α l then 1 else 0)) = (∑ l, ∑ m ∈ Finset.Ioi l, (if β l ≤ α m then 1 else 0)) := by
        rw [ Finset.sum_sigma', Finset.sum_sigma' ];
        apply Finset.sum_bij (fun x _ => ⟨x.snd, x.fst⟩);
        · aesop;
        · aesop;
        · simp +zetaDelta at *;
          exact fun b hb => ⟨ b.snd, b.fst, hb, rfl ⟩;
        · grind;
      have h_parity : (∑ l, ∑ m ∈ Finset.Ioi l, (if α m < β l then 1 else 0)) + (∑ l, ∑ m ∈ Finset.Ioi l, (if β l ≤ α m then 1 else 0)) = n * (n - 1) / 2 := by
        have h_parity : (∑ l, ∑ m ∈ Finset.Ioi l, (if α m < β l then 1 else 0)) + (∑ l, ∑ m ∈ Finset.Ioi l, (if β l ≤ α m then 1 else 0)) = (∑ l : Fin n, ∑ m ∈ Finset.Ioi l, 1) := by
          rw [ ← Finset.sum_add_distrib ] ; refine' Finset.sum_congr rfl fun i hi => _ ; rw [ ← Finset.sum_add_distrib ] ; refine' Finset.sum_congr rfl fun j hj => _ ; split_ifs <;> simp_all +decide [ not_lt_of_ge ] ;
        convert h_parity using 1;
        exact Nat.div_eq_of_eq_mul_left zero_lt_two ( Nat.recOn n ( by norm_num ) fun n ih => by cases n <;> simp +decide [ Fin.sum_univ_succ, Nat.mul_succ ] at * ; linarith );
      rcases n with ( _ | _ | n ) <;> simp +arith +decide [ Nat.mul_succ, Nat.add_mul_div_left ] at *;
      norm_num [ Nat.ModEq, Nat.add_mod, Nat.mul_mod ] at *;
      grind;
    have h_sign_identity : (∏ l, blockSign (α l) (β l)) = (-1 : ℤ) ^ (∑ l, (if β l ≤ α l then 1 else 0)) ∧ (∏ l, ∏ m ∈ Finset.Ioi l, shuffleSign (blockSet (α l) (β l)) (blockSet (α m) (β m))) = (-1 : ℤ) ^ (∑ l, ∑ m ∈ Finset.Ioi l, (if α m < α l then 1 else 0) + ∑ l, ∑ m ∈ Finset.Ioi l, (if β m < β l then 1 else 0) + ∑ l, ∑ m ∈ Finset.Ioi l, (if β m ≤ α l then 1 else 0) + ∑ l, ∑ m ∈ Finset.Ioi l, (if α m < β l then 1 else 0)) := by
      constructor;
      · rw [ ← Finset.prod_pow_eq_pow_sum ];
        refine' Finset.prod_congr rfl fun i hi => _;
        unfold blockSign shuffleSign; simp +decide [ Finset.card_singleton, Finset.filter_singleton ] ;
        split_ifs <;> simp +decide [ * ];
      · have h_shuffle_sign : ∀ l m : Fin n, l < m → shuffleSign (blockSet (α l) (β l)) (blockSet (α m) (β m)) = (-1 : ℤ) ^ ((if α m < α l then 1 else 0) + (if β m < β l then 1 else 0) + (if β m ≤ α l then 1 else 0) + (if α m < β l then 1 else 0)) := by
          intros l m hlm
          simp [shuffleSign, blockSet];
          rw [ Finset.card_filter ];
          rw [ Finset.sum_product ] ; simp +decide [ Finset.sum ] ;
          rw [ Multiset.ndinsert_of_notMem ] <;> simp +decide [ Fin.ext_iff, Nat.mod_eq_of_lt ];
          · rw [ Multiset.ndinsert_of_notMem ] <;> simp +decide [ Fin.ext_iff, Nat.mod_eq_of_lt ];
            · grind;
            · omega;
          · omega;
        rw [ Finset.prod_congr rfl fun l hl => Finset.prod_congr rfl fun m hm => h_shuffle_sign l m <| Finset.mem_Ioi.mp hm ];
        simp +decide only [Finset.prod_pow_eq_pow_sum, Finset.sum_add_distrib];
    simp_all +decide [ Nat.ModEq, Nat.even_iff ];
    have h_sign_identity : Equiv.Perm.sign β = (-1 : ℤ) ^ (∑ l, ∑ m ∈ Finset.Ioi l, (if β m < β l then 1 else 0)) ∧ Equiv.Perm.sign α = (-1 : ℤ) ^ (∑ l, ∑ m ∈ Finset.Ioi l, (if α m < α l then 1 else 0)) := by
      have h_sign_identity : ∀ (σ : Equiv.Perm (Fin n)), Equiv.Perm.sign σ = (-1 : ℤ) ^ (∑ l, ∑ m ∈ Finset.Ioi l, (if σ m < σ l then 1 else 0)) := by
        intro σ; rw [ Equiv.Perm.sign_eq_prod_prod_Ioi ] ; simp +decide [ Finset.prod_ite ] ;
        rw [ Finset.prod_pow_eq_pow_sum ];
        congr! 2;
        exact congr_arg Finset.card ( Finset.filter_congr fun x hx => by exact ⟨ fun h => lt_of_le_of_ne h ( by intro t; have := σ.injective t; aesop ), fun h => le_of_lt h ⟩ );
      exact ⟨ h_sign_identity β, h_sign_identity α ⟩;
    simp_all +decide [ ← pow_add ];
    rw [ ← Nat.mod_add_div ( Finset.card ( Finset.filter ( fun x => β x ≤ α x ) Finset.univ ) + ( ∑ x : Fin n, Finset.card ( Finset.filter ( fun x_1 => α x_1 < α x ) ( Finset.Ioi x ) ) + ∑ x : Fin n, Finset.card ( Finset.filter ( fun x_1 => β x_1 < β x ) ( Finset.Ioi x ) ) + ∑ x : Fin n, Finset.card ( Finset.filter ( fun x_1 => β x_1 ≤ α x ) ( Finset.Ioi x ) ) + ∑ x : Fin n, Finset.card ( Finset.filter ( fun x_1 => α x_1 < β x ) ( Finset.Ioi x ) ) ) + n ) 2, ← Nat.mod_add_div ( ∑ x : Fin n, Finset.card ( Finset.filter ( fun x_1 => β x_1 < β x ) ( Finset.Ioi x ) ) + ∑ x : Fin n, Finset.card ( Finset.filter ( fun x_1 => α x_1 < α x ) ( Finset.Ioi x ) ) ) 2 ] ; norm_num [ pow_add, pow_mul, Nat.mul_mod, Nat.pow_mod, h_parity ] ;
    grind;
  convert h_sign_identity using 1;
  unfold signProd permBlocks;
  rw [ show ( Finset.filter ( fun ij : Fin n × Fin n => ij.1 < ij.2 ) Finset.univ : Finset ( Fin n × Fin n ) ) = Finset.biUnion ( Finset.univ : Finset ( Fin n ) ) fun i => Finset.image ( fun j => ( i, j ) ) ( Finset.Ioi i ) from ?_, Finset.prod_biUnion ];
  · simp +decide [ mul_comm, Finset.prod_image ];
  · exact fun i _ j _ hij => Finset.disjoint_left.mpr fun x hx₁ hx₂ => hij <| by aesop;
  · ext ⟨i, j⟩; simp [Finset.mem_biUnion, Finset.mem_image]

/-
Each `permBlocks α β` is an ordered partition of the top monomial `univ`.
-/
lemma permBlocks_isPartition {n : ℕ} (α β : Equiv.Perm (Fin n)) :
    IsOrderedPartition (Finset.univ : Finset (Fin (2 * n))) (permBlocks α β) := by
  constructor;
  · ext x;
    simp +zetaDelta at *;
    rcases Nat.even_or_odd' x with ⟨ k, hk | hk ⟩;
    · use β.symm ⟨ k, by linarith [ Fin.is_lt x ] ⟩;
      unfold permBlocks blockSet; simp +decide [ Fin.ext_iff, hk ] ;
    · use α.symm ⟨ k, by linarith [ Fin.is_lt x ] ⟩;
      simp +decide [ permBlocks, blockSet, Fin.ext_iff, hk ];
  · intro l m hlm; simp +decide [ Finset.disjoint_left, permBlocks, blockSet ] ;
    exact ⟨ ⟨ by intro h; exact hlm ( α.injective ( Fin.ext h ) ), by omega ⟩, by omega, by intro h; exact hlm ( β.injective ( Fin.ext h ) ) ⟩

/-
**The permutation bijection.** The degree-`n` Grassmann power at the top
monomial, summed over ordered `n`-block partitions, collapses to a double sum
over pairs of permutations `(α, β)` (the block partitions of `univ`).
-/
set_option maxHeartbeats 1000000 in
lemma gpow_n_perm_sum {n : ℕ} (M : Matrix (Fin n) (Fin n) R) :
    gpow (fun u => - bilinear M u) n (Finset.univ : Finset (Fin (2 * n)))
      = ∑ α : Equiv.Perm (Fin n), ∑ β : Equiv.Perm (Fin n),
          (signProd (permBlocks α β) : R) * ∏ l, (- bilinear M (blockSet (α l) (β l))) := by
  rw [ gpow_apply ];
  -- By definition of $IsOrderedPartition$, we know that every ordered partition of $Finset.univ$ is of the form $permBlocks α β$ for some permutations $α$ and $β$.
  have h_partition : ∀ f : Fin n → Finset (Fin (2 * n)), IsOrderedPartition Finset.univ f → (∏ l, -bilinear M (f l)) ≠ 0 → ∃ α β : Equiv.Perm (Fin n), f = permBlocks α β := by
    intro f hf hprod
    have h_block : ∀ l, ∃ i j, f l = blockSet i j := by
      exact fun l => bilinear_support M ( show bilinear M ( f l ) ≠ 0 from fun h => hprod <| Finset.prod_eq_zero ( Finset.mem_univ l ) <| by simp +decide [ h ] );
    choose α β h using h_block;
    have h_inj : Function.Injective α ∧ Function.Injective β := by
      have h_card : Finset.card (Finset.biUnion Finset.univ f) = 2 * n := by
        rw [ hf.1, Finset.card_fin ];
      have h_card : Finset.card (Finset.biUnion Finset.univ f) ≤ Finset.card (Finset.image α Finset.univ) + Finset.card (Finset.image β Finset.univ) := by
        have h_card : Finset.biUnion Finset.univ f ⊆ Finset.image (fun i => ⟨2 * i.val + 1, by omega⟩) (Finset.image α Finset.univ) ∪ Finset.image (fun i => ⟨2 * i.val, by omega⟩) (Finset.image β Finset.univ) := by
          simp +decide [ Finset.subset_iff, h ];
          intro x l hx; unfold blockSet at hx; aesop;
        exact le_trans ( Finset.card_le_card h_card ) ( Finset.card_union_le _ _ ) |> le_trans <| add_le_add ( Finset.card_image_le ) ( Finset.card_image_le );
      have h_card : Finset.card (Finset.image α Finset.univ) = n ∧ Finset.card (Finset.image β Finset.univ) = n := by
        exact ⟨ by linarith [ show Finset.card ( Finset.image α Finset.univ ) ≤ n from Finset.card_image_le.trans ( by simp +decide ), show Finset.card ( Finset.image β Finset.univ ) ≤ n from Finset.card_image_le.trans ( by simp +decide ) ], by linarith [ show Finset.card ( Finset.image α Finset.univ ) ≤ n from Finset.card_image_le.trans ( by simp +decide ), show Finset.card ( Finset.image β Finset.univ ) ≤ n from Finset.card_image_le.trans ( by simp +decide ) ] ⟩;
      have := Finset.card_image_iff.mp ( by aesop : Finset.card ( Finset.image α Finset.univ ) = Finset.card Finset.univ ) ; have := Finset.card_image_iff.mp ( by aesop : Finset.card ( Finset.image β Finset.univ ) = Finset.card Finset.univ ) ; aesop;
    exact ⟨ Equiv.ofBijective α ⟨ h_inj.1, Finite.injective_iff_surjective.mp h_inj.1 ⟩, Equiv.ofBijective β ⟨ h_inj.2, Finite.injective_iff_surjective.mp h_inj.2 ⟩, funext h ⟩;
  rw [ ← Finset.sum_subset ( show Finset.image ( fun p : Equiv.Perm ( Fin n ) × Equiv.Perm ( Fin n ) => permBlocks p.1 p.2 ) Finset.univ ⊆ Finset.filter ( IsOrderedPartition Finset.univ ) Finset.univ from ?_ ) ];
  · rw [ Finset.sum_image ];
    · rw [ ← Finset.sum_product' ];
      rfl;
    · intro p hp q hq h_eq; simp_all +decide [ funext_iff, Finset.ext_iff ] ;
      ext l; have := h_eq l; simp_all +decide [ Finset.ext_iff, permBlocks ] ;
      · specialize h_eq l ⟨ 2 * ( p.1 l : ℕ ) + 1, by linarith [ Fin.is_lt ( p.1 l ) ] ⟩ ; simp_all +decide [ blockSet ];
        omega;
      · have := h_eq l ⟨ 2 * ( p.2 l : ℕ ), by linarith [ Fin.is_lt ( p.2 l ) ] ⟩ ; simp_all +decide [ permBlocks, blockSet ] ;
        exact this.resolve_left ( by omega );
  · intro f hf hnf; contrapose! hnf; simp_all +decide [ Finset.mem_image ] ;
    exact Exists.elim ( h_partition f hf ( by aesop ) ) fun α hα => Exists.elim hα fun β hβ => ⟨ α, β, hβ.symm ⟩;
  · exact Finset.image_subset_iff.mpr fun p _ => Finset.mem_filter.mpr ⟨ Finset.mem_univ _, permBlocks_isPartition p.1 p.2 ⟩

/-
**Sign collapse to the determinant.** The double sum over `(α, β)` equals
`n! * det M`, using the sign identity `signProd_permBlocks` and
`Matrix.det_apply'`.
-/
set_option maxHeartbeats 1000000 in
lemma perm_sum_eq_det {n : ℕ} (M : Matrix (Fin n) (Fin n) R) :
    (∑ α : Equiv.Perm (Fin n), ∑ β : Equiv.Perm (Fin n),
          (signProd (permBlocks α β) : R) * ∏ l, (- bilinear M (blockSet (α l) (β l))))
      = (n.factorial : R) * M.det := by
  -- Apply the signProd_permBlocks lemma to each term in the sum.
  have h_apply_signProd_permBlocks : ∀ (α β : Equiv.Perm (Fin n)), (signProd (permBlocks α β) : R) * (∏ l, (- bilinear M (blockSet (α l) (β l)))) = (Equiv.Perm.sign (β * α⁻¹) : R) * (∏ l, M (α l) (β l)) := by
    intro α β; rw [ ← signProd_permBlocks α β ] ; simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.prod_mul_distrib ] ;
    rw [ Finset.prod_congr rfl fun _ _ => neg_eq_neg_one_mul _, Finset.prod_mul_distrib ] ; simp +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.prod_mul_distrib ];
    simp +decide [ ← mul_assoc, ← Finset.prod_mul_distrib, bilinear_blockSet ];
  simp +decide only [h_apply_signProd_permBlocks];
  -- Reindex the inner sum: $\sum_{\beta} \text{sign}(\beta \alpha^{-1}) \prod_{l} M(\alpha l, \beta l) = \sum_{\sigma} \text{sign}(\sigma) \prod_{l} M(\alpha l, \sigma(\alpha l))$.
  have h_reindex : ∀ (α : Equiv.Perm (Fin n)), ∑ β : Equiv.Perm (Fin n), (Equiv.Perm.sign (β * α⁻¹) : R) * (∏ l, M (α l) (β l)) = ∑ σ : Equiv.Perm (Fin n), (Equiv.Perm.sign σ : R) * (∏ l, M (α l) (σ (α l))) := by
    intro α; rw [ ← Equiv.sum_comp ( Equiv.mulRight α ) ] ; simp +decide [ mul_assoc ] ;
  simp +decide only [h_reindex];
  -- Reindex the product: $\prod_{l} M(\alpha l, \sigma(\alpha l)) = \prod_{i} M(i, \sigma(i))$.
  have h_reindex_prod : ∀ (α : Equiv.Perm (Fin n)) (σ : Equiv.Perm (Fin n)), (∏ l, M (α l) (σ (α l))) = (∏ i, M i (σ i)) := by
    exact fun α σ => Equiv.prod_comp α fun i => M i ( σ i );
  simp +decide only [h_reindex_prod, Matrix.det_apply'];
  simp +decide [ Finset.card_univ, Fintype.card_perm ];
  refine' congr_arg _ ( Finset.sum_bij ( fun σ _ => σ⁻¹ ) _ _ _ _ ) <;> simp +decide;
  · exact fun b => ⟨ b⁻¹, inv_inv b ⟩;
  · intro σ; rw [ ← Equiv.prod_comp σ.symm ] ; simp +decide ;

/-- **The `n`-block core.** The degree-`n` Grassmann power at the top monomial
equals `n! * det M`. -/
lemma gpow_n_univ {n : ℕ} (M : Matrix (Fin n) (Fin n) R) :
    gpow (fun u => - bilinear M u) n (Finset.univ : Finset (Fin (2 * n)))
      = (n.factorial : R) * M.det := by
  rw [gpow_n_perm_sum, perm_sum_eq_det]

/-
**Degree reduction.** Only the degree-`n` term of `exp(- bilinear M)`
contributes at the top monomial.
-/
lemma berezin_eq_gpow_n {n : ℕ} (M : Matrix (Fin n) (Fin n) R) :
    berezinGaussian M
      = Ring.inverse (n.factorial : R)
          * gpow (fun u => - bilinear M u) n (Finset.univ : Finset (Fin (2 * n))) := by
  -- Since for $p \neq n$, the term $gpow (fun u => -bilinear M u) p (Finset.univ)$ is zero, the sum simplifies to just the term where $p = n$.
  have h_zero_terms : ∀ p ∈ Finset.range (2 * n + 1), p ≠ n → gpow (fun u => -bilinear M u) p (Finset.univ : Finset (Fin (2 * n))) = 0 := by
    intro p hp hp_ne_n
    have h_card : ∀ f : Fin p → Finset (Fin (2 * n)), (IsOrderedPartition Finset.univ f) → ∏ l : Fin p, (fun u => -bilinear M u) (f l) = 0 := by
      intro f hf
      by_contra h_nonzero
      have h_card : ∑ l : Fin p, (f l).card = 2 * n := by
        rw [ ← Finset.card_biUnion ];
        · rw [ hf.1, Finset.card_fin ];
        · exact fun i _ j _ hij => hf.2 i j hij;
      have h_card : ∀ l : Fin p, (f l).card = 2 := by
        have h_card : ∀ l : Fin p, ∃ i j : Fin n, f l = blockSet i j := by
          intro l
          have h_card : (fun u => -bilinear M u) (f l) ≠ 0 := by
            exact fun h => h_nonzero <| Finset.prod_eq_zero ( Finset.mem_univ l ) h;
          exact bilinear_support M ( show bilinear M ( f l ) ≠ 0 from fun h => h_card <| by simp +decide [ h ] );
        intro l; obtain ⟨ i, j, hl ⟩ := h_card l; simp +decide [ hl, blockSet ] ;
        grind;
      simp_all +decide [ Finset.sum_congr rfl fun l _ => h_card l ];
      exact hp_ne_n ( by linarith );
    rw [ gpow_apply ];
    exact Finset.sum_eq_zero fun f hf => by aesop;
  unfold berezinGaussian gexp;
  rw [ Finset.sum_eq_single n ] <;> simp_all +decide;
  lia

/-- **QMF3 target - the finite Matthews-Salam identity.** -/
theorem berezinGaussian_eq_det {n : ℕ} [Algebra ℚ R]
    (M : Matrix (Fin n) (Fin n) R) :
    berezinGaussian M = M.det := by
  rw [berezin_eq_gpow_n, gpow_n_univ]
  have hunit : IsUnit ((n.factorial : R)) := by
    have : (n.factorial : R) = algebraMap ℚ R (n.factorial : ℚ) := by
      rw [map_natCast]
    rw [this]
    apply IsUnit.map
    exact isUnit_iff_ne_zero.mpr (by exact_mod_cast (Nat.factorial_pos n).ne')
  rw [← mul_assoc, Ring.inverse_mul_cancel _ hunit, one_mul]

/-- Regression anchor `n = 1`: `berezinGaussian !![c] = c` (oracle-pinned). -/
theorem berezinGaussian_anchor_one [Algebra ℚ R] (c : R) :
    berezinGaussian !![c] = c := by
  rw [berezinGaussian_eq_det, Matrix.det_fin_one]
  simp

/-- Regression anchor `n = 2`: `berezinGaussian !![a, b; c, d] = a*d - b*c`
(oracle-pinned; NOT `b*c - a*d`). -/
theorem berezinGaussian_anchor_two [Algebra ℚ R] (a b c d : R) :
    berezinGaussian !![a, b; c, d] = a * d - b * c := by
  rw [berezinGaussian_eq_det, Matrix.det_fin_two]
  simp

end Qmf3Berezin
end PhysicsSM.Draft.NullEdge.GateYM

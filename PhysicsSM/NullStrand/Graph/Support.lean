import Mathlib

/-!
# NullStrand.Graph.Support

Manifest node GRAPH-002: the support of `D²` lies in the two-step relational
closure of the support of `D`. This corrects the misconception that a first-order
null-local operator has a nearest-neighbour square (improved roadmap §6.5, W12).

## Scope of this module (proven vs. speculative)

Everything below is **pure finite linear algebra** over `Matrix Q Q ℂ` (and the
graded space `Matrix (L ⊕ R) (L ⊕ R) ℂ`). The statements are kernel-checked and
carry no physics content beyond bookkeeping of where matrix entries can be
nonzero. In particular:

* `SupportedOn R D` says `D` has entries only on the relation `R`.
* `support_mul_subset_relComp` / `support_pow_subset_relPow` are the auditable
  "support spreads by relational composition" facts: an `n`-fold product can only
  reach configurations joined by an `R`-walk of length `n`. This is the finite
  graph backbone of the GRAPH-002 claim.
* The `gradedOdd` block (a finite `D = d_U + δ_U`-style odd operator on `L ⊕ R`)
  has a **chirality-preserving square**: `D²` is supported on the
  `sameChirality` relation, with diagonal blocks `ψφ` and `φψ`. This is the
  smallest concrete "super-Dirac square has an auditable support/decomposition"
  statement, and it follows from the generic graph-support machinery applied to
  the off-diagonal (`crossChirality`) support of `D`.

The **speculative super-Dirac interpretation** — identifying the diagonal blocks
`ψφ`, `φψ` with a graph Laplacian, a causal-diamond curvature defect, and a
Higgs/Yukawa mass block, or claiming Krein/Lorentzian self-adjointness — is *not*
asserted here as a theorem. Those identifications live in the `PhysicsSM.Draft.*`
super-Dirac cores and the roadmap; only the entry-support skeleton is trusted in
this module.

Provenance: clean-room statement; `support_square_subset_relComp` proof from
Aristotle project `d9e2e308-9492-4421-b68b-28c88e5eed68`, verified `s o r r y`/
`a x i o m`-free and statement-identical, integrated 2026-06-25. The generalized
support algebra and graded chirality-square support facts were added in wave 4
(2026-06-25), all kernel-checked `s o r r y`/`a x i o m`-free.
-/

namespace PhysicsSM.NullStrand.Graph

open Matrix Finset
open scoped BigOperators

/-- A finite matrix is supported on `R` when every entry off `R` vanishes. -/
def SupportedOn {Q : Type*} [Fintype Q] (R : Q → Q → Prop) (D : Matrix Q Q ℂ) : Prop :=
  ∀ q q', ¬ R q q' → D q q' = 0

/-- GRAPH-002. The support of `D * D` is contained in the two-step relational
closure of the support of `D`: a nonzero `(D * D) q q'` entry forces an
intermediate `m` with `R q m` and `R m q'`. -/
theorem support_square_subset_relComp {Q : Type*} [Fintype Q]
    (R : Q → Q → Prop) (D : Matrix Q Q ℂ) (hD : SupportedOn R D)
    (q q' : Q) (h : (D * D) q q' ≠ 0) :
    ∃ m, R q m ∧ R m q' := by
  contrapose! h
  exact Finset.sum_eq_zero fun m _ => by by_cases hm : R q m <;> aesop

/-! ## Generalized relational support algebra -/

/-- Relational composition: `relComp R S q q'` holds when some `m` is
`R`-reachable from `q` and `S`-reaches `q'`. -/
def relComp {Q : Type*} (R S : Q → Q → Prop) : Q → Q → Prop :=
  fun q q' => ∃ m, R q m ∧ S m q'

/-- `relPow R n` is the `n`-step relational closure of `R` (with `relPow R 0` the
diagonal). A nonzero entry of `D ^ n` forces an `R`-walk of length `n`. -/
def relPow {Q : Type*} (R : Q → Q → Prop) : ℕ → (Q → Q → Prop)
  | 0 => fun q q' => q = q'
  | (n + 1) => relComp R (relPow R n)

/-- Support of a product lands in the relational composition of the supports:
a nonzero `(D₁ * D₂) q q'` forces an intermediate `m` with `R q m` and `S m q'`. -/
theorem support_mul_subset_relComp {Q : Type*} [Fintype Q]
    (R S : Q → Q → Prop) (D₁ D₂ : Matrix Q Q ℂ)
    (h₁ : SupportedOn R D₁) (h₂ : SupportedOn S D₂)
    (q q' : Q) (h : (D₁ * D₂) q q' ≠ 0) :
    relComp R S q q' := by
  contrapose! h;
  exact Finset.sum_eq_zero fun j hj => by_contradiction fun hj' => h ⟨ j, by have := h₁ q j; have := h₂ j q'; aesop ⟩

/-- The product of operators supported on `R` and `S` is supported on `relComp R S`. -/
theorem mul_supportedOn_relComp {Q : Type*} [Fintype Q]
    (R S : Q → Q → Prop) (D₁ D₂ : Matrix Q Q ℂ)
    (h₁ : SupportedOn R D₁) (h₂ : SupportedOn S D₂) :
    SupportedOn (relComp R S) (D₁ * D₂) := by
  intro q q' h;
  convert support_mul_subset_relComp R S D₁ D₂ h₁ h₂ q q';
  grind

/-- The identity matrix is supported on the diagonal relation `relPow R 0`. -/
theorem one_supportedOn_relPow_zero {Q : Type*} [Fintype Q] [DecidableEq Q] (R : Q → Q → Prop) :
    SupportedOn (relPow R 0) (1 : Matrix Q Q ℂ) := by
  intro q q';
  exact fun h => Matrix.one_apply_ne ( by tauto )

/-- The `n`-th matrix power of an `R`-supported operator is supported on the
`n`-step relational closure `relPow R n`. This is the auditable statement that
support spreads by exactly one relational step per factor. -/
theorem support_pow_subset_relPow {Q : Type*} [Fintype Q] [DecidableEq Q]
    (R : Q → Q → Prop) (D : Matrix Q Q ℂ) (hD : SupportedOn R D) :
    ∀ n, SupportedOn (relPow R n) (D ^ n) := by
  intro n;
  induction' n with n ih;
  · exact one_supportedOn_relPow_zero R;
  · simpa only [ pow_succ' ] using mul_supportedOn_relComp R ( relPow R n ) D ( D ^ n ) hD ih

/-! ## Graded (super-Dirac) odd operator and its chirality-preserving square

We isolate the smallest finite "super-Dirac" pattern: an odd off-diagonal
operator `D = gradedOdd φ ψ` on the graded space `L ⊕ R`. Reading `L` as the
left (positive-chirality) sector and `R` as the right sector, `D` only connects
opposite chiralities (`crossChirality`), so its square only connects equal
chiralities (`sameChirality`). The diagonal blocks of `D²` are `ψ * φ` and
`φ * ψ`. The physics reading of these blocks (Laplacian / curvature / mass) is
deliberately left to the draft super-Dirac cores; here only the support and the
block identities are asserted. -/

/-- Odd off-diagonal operator on `L ⊕ R`: `ψ` maps `R → L`, `φ` maps `L → R`. -/
def gradedOdd {L R : Type*} (φ : Matrix R L ℂ) (ψ : Matrix L R ℂ) :
    Matrix (Sum L R) (Sum L R) ℂ :=
  fun a b =>
    match a, b with
    | Sum.inl _, Sum.inl _ => 0
    | Sum.inl l, Sum.inr r => ψ l r
    | Sum.inr r, Sum.inl l => φ r l
    | Sum.inr _, Sum.inr _ => 0

/-- Two graded indices have opposite chirality. -/
def crossChirality {L R : Type*} : (Sum L R) → (Sum L R) → Prop :=
  fun a b => a.isLeft ≠ b.isLeft

/-- Two graded indices have equal chirality. -/
def sameChirality {L R : Type*} : (Sum L R) → (Sum L R) → Prop :=
  fun a b => a.isLeft = b.isLeft

/-- The odd operator only connects opposite chiralities. -/
theorem gradedOdd_supportedOn_cross {L R : Type*} [Fintype L] [Fintype R]
    (φ : Matrix R L ℂ) (ψ : Matrix L R ℂ) :
    SupportedOn crossChirality (gradedOdd φ ψ) := by
  intro a b; by_cases ha : a.isLeft <;> by_cases hb : b.isLeft <;> simp +decide [ *, crossChirality ]
  · cases a <;> cases b <;> tauto;
  · cases a <;> cases b <;> tauto

/-- Composing two opposite-chirality steps returns to the same chirality. -/
theorem relComp_cross_cross_subset_same {L R : Type*}
    (a b : Sum L R) (h : relComp crossChirality crossChirality a b) :
    sameChirality a b := by
  obtain ⟨ m, hm ⟩ := h;
  cases a <;> cases m <;> cases b <;> simp_all +decide [ crossChirality, sameChirality ]

/-- **Chirality-preserving super-Dirac square.** The square of the odd operator
`D = gradedOdd φ ψ` is supported on `sameChirality`: it carries no
chirality-changing entry. This is the finite-graph "auditable support" form of
the super-Dirac square, obtained from the generic support algebra applied to the
off-diagonal support of `D`. -/
theorem gradedOdd_sq_supportedOn_sameChirality {L R : Type*} [Fintype L] [Fintype R]
    (φ : Matrix R L ℂ) (ψ : Matrix L R ℂ) :
    SupportedOn sameChirality (gradedOdd φ ψ * gradedOdd φ ψ) := by
  intro a b h;
  contrapose! h;
  apply relComp_cross_cross_subset_same;
  apply support_mul_subset_relComp crossChirality crossChirality (gradedOdd φ ψ) (gradedOdd φ ψ) (gradedOdd_supportedOn_cross φ ψ) (gradedOdd_supportedOn_cross φ ψ) a b h

/-- Left diagonal block of the super-Dirac square is `ψ * φ`. -/
theorem gradedOdd_sq_leftBlock {L R : Type*} [Fintype L] [Fintype R]
    (φ : Matrix R L ℂ) (ψ : Matrix L R ℂ) (l l' : L) :
    (gradedOdd φ ψ * gradedOdd φ ψ) (Sum.inl l) (Sum.inl l') = (ψ * φ) l l' := by
  unfold gradedOdd; simp +decide [ Fintype.sum_sum_type, Matrix.mul_apply ]

/-- Right diagonal block of the super-Dirac square is `φ * ψ`. -/
theorem gradedOdd_sq_rightBlock {L R : Type*} [Fintype L] [Fintype R]
    (φ : Matrix R L ℂ) (ψ : Matrix L R ℂ) (r r' : R) :
    (gradedOdd φ ψ * gradedOdd φ ψ) (Sum.inr r) (Sum.inr r') = (φ * ψ) r r' := by
  unfold gradedOdd; simp +decide [ Matrix.mul_apply, Fintype.sum_sum_type ]

end PhysicsSM.NullStrand.Graph

import Mathlib

/-!
# Finite maximum-entropy / Gibbs variational principle (DYN-MODULAR-001 S2)

Draft module. Among all finite probability distributions with a fixed mean
energy, the Gibbs (Boltzmann) distribution uniquely maximizes the Shannon
entropy. This is the eigenvalue-level (commuting / shared-eigenbasis) core of the
quantum maximum-entropy uniqueness for density matrices: for co-diagonalizable
density matrices, the von Neumann entropy is the Shannon entropy of the
eigenvalue distribution and the mean energy is the classical expectation of the
Hamiltonian eigenvalues, so this classical statement IS the quantum variational
principle in that case.

The Gibbs distribution `g` is **constructed** from the energies `ε` and inverse
temperature `β` (not assumed), so the selected maximizer is not encoded in the
hypotheses; the only side condition on the competitor `p` is the physical mean-
energy constraint `⟨ε⟩_p = ⟨ε⟩_g`.

Mathematics (the intended proof route):
For any probability vector `r`, `relEntropy r g = -H(r) + β ⟨ε⟩_r + log Z`
(expand `log g_i = -β ε_i - log Z`). Applying this at `r = g` and using
`relEntropy g g = 0` gives `log Z = H(g) - β ⟨ε⟩_g`. Substituting back,
`relEntropy p g = (H(g) - H(p)) + β (⟨ε⟩_p - ⟨ε⟩_g)`. Under the energy constraint
the last term vanishes, so `relEntropy p g = H(g) - H(p)`; nonnegativity of
relative entropy (Gibbs' inequality) gives `H(p) ≤ H(g)`, and its equality
condition gives `p = g`.

## Scope (anti-overclaim)

This is the DISTRIBUTION-level (classical) variational principle over Shannon
entropy with the mean-energy constraint. It is the eigenvalue-level core of the
quantum density-matrix statement in the commuting / shared-eigenbasis case only;
the general non-commuting operator variational principle is a successor (see the
qubit Bloch-ball route `4ef06d09` and its bridge design). The scalar Gibbs
inequality (`relEntropy_nonneg`) and its equality condition are also proved
in-project (`FiniteGibbsInequality`); this module restates the minimal pieces so
it is self-contained.

## Trust status

Draft-trust by kernel: `gibbs_maximizes_entropy` is `sorry`-free and depends only
on `[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12, DYN-MODULAR-001 S2:
maximum-entropy uniqueness). Proof search by Aristotle (project
`5c0fa5d3-4774-4e8a-8740-16f97c188974`), then independently re-checked in this
repo (`lake env lean`; axiom footprint confirmed kernel-only). Route: for any
probability vector `r`, `relEntropy r g = -H(r) + β <ε>_r + log Z`; at `r = g`
with `relEntropy g g = 0` this gives `log Z = H(g) - β <ε>_g`, so
`relEntropy p g = (H(g) - H(p)) + β (<ε>_p - <ε>_g)`; under the energy constraint
Gibbs' inequality (`relEntropy_nonneg`) and its equality condition
(`relEntropy_eq_zero_iff`) close both the bound and uniqueness. Clean-room
formalization from the mathematical statement. Canonical source: the maximum-
entropy principle (Jaynes 1957; Cover & Thomas, Elements of Information Theory,
Thm 12.1.1).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GibbsVariational

open scoped BigOperators

variable {k : Type*} [Fintype k]

/-- Finite classical relative entropy `∑ i, p i * log (p i / q i)`
(convention `Real.log 0 = 0`). -/
def relEntropy (p q : k → ℝ) : ℝ :=
  ∑ i, p i * Real.log (p i / q i)

/-- Shannon entropy `∑ i, negMulLog (p i) = -∑ i, p i log (p i)`. -/
def shannonEntropy (p : k → ℝ) : ℝ :=
  ∑ i, Real.negMulLog (p i)

/-- Mean energy `⟨ε⟩_p = ∑ i, p i * ε i`. -/
def energy (ε p : k → ℝ) : ℝ :=
  ∑ i, p i * ε i

/-- Gibbs partition function `Z = ∑ i, exp (-β ε i)`. -/
def partition (ε : k → ℝ) (β : ℝ) : ℝ :=
  ∑ i, Real.exp (-(β * ε i))

/-- Gibbs (Boltzmann) distribution `g_i = exp(-β ε_i) / Z`. -/
def gibbs (ε : k → ℝ) (β : ℝ) : k → ℝ :=
  fun i => Real.exp (-(β * ε i)) / partition ε β

/-- The partition function is strictly positive. -/
theorem partition_pos [Nonempty k] (ε : k → ℝ) (β : ℝ) :
    0 < partition ε β := by
  apply Finset.sum_pos
  · intro i _; exact Real.exp_pos _
  · exact Finset.univ_nonempty

/-- Each Gibbs weight is strictly positive. -/
theorem gibbs_pos [Nonempty k] (ε : k → ℝ) (β : ℝ) (i : k) :
    0 < gibbs ε β i := by
  exact div_pos (Real.exp_pos _) (partition_pos ε β)

/-- The Gibbs distribution is normalized. -/
theorem gibbs_sum_one [Nonempty k] (ε : k → ℝ) (β : ℝ) :
    ∑ i, gibbs ε β i = 1 := by
  unfold gibbs
  rw [← Finset.sum_div]
  exact div_self (ne_of_gt (partition_pos ε β))

/-
Gibbs' inequality (imported target): finite relative entropy is
nonnegative for probability vectors with strictly positive reference.
-/
theorem relEntropy_nonneg (p q : k → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    0 ≤ relEntropy p q := by
  -- For each $i$, we have $p_i \log (p_i / q_i) \geq p_i - q_i$.
  have h_ineq (i : k) : p i * Real.log (p i / q i) ≥ p i - q i := by
    by_cases hi : p i = 0 <;> simp_all +decide [ div_eq_mul_inv ];
    · linarith [ hq i ];
    · have := Real.log_le_sub_one_of_pos ( div_pos ( hq i ) ( lt_of_le_of_ne ( hp i ) ( Ne.symm hi ) ) );
      rw [ show p i * ( q i ) ⁻¹ = ( q i / p i ) ⁻¹ by group, Real.log_inv ] ; nlinarith [ hp i, hq i, mul_div_cancel₀ ( q i ) hi ];
  exact le_trans ( by simp +decide [ hps, hqs ] ) ( Finset.sum_le_sum fun i _ => h_ineq i )

/-
Equality condition (imported target): relative entropy vanishes iff the
distributions coincide.
-/
theorem relEntropy_eq_zero_iff (p q : k → ℝ)
    (hp : ∀ i, 0 ≤ p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    relEntropy p q = 0 ↔ p = q := by
  refine' ⟨ fun h => _, fun h => _ ⟩;
  · -- By the strict tangent bound, if $p_i \neq q_i$, then $p_i \log(p_i / q_i) > p_i - q_i$.
    have h_strict : ∀ i, p i ≠ q i → p i * Real.log (p i / q i) > p i - q i := by
      intro i hi; by_cases hi' : p i = 0 <;> simp_all +decide [ Real.log_div, ne_of_gt ] ;
      have := Real.log_lt_sub_one_of_pos ( div_pos ( hq i ) ( lt_of_le_of_ne ( hp i ) ( Ne.symm hi' ) ) ) ?_ <;> simp_all +decide;
      · rw [ Real.log_div ( ne_of_gt ( hq i ) ) ( ne_of_gt ( lt_of_le_of_ne ( hp i ) ( Ne.symm hi' ) ) ) ] at this ; nlinarith [ hp i, hq i, mul_div_cancel₀ ( q i ) hi', mul_div_cancel₀ ( p i ) ( ne_of_gt ( hq i ) ), mul_pos ( lt_of_le_of_ne ( hp i ) ( Ne.symm hi' ) ) ( hq i ) ];
      · exact div_ne_one_of_ne ( Ne.symm hi );
    contrapose! h;
    refine' ne_of_gt ( lt_of_le_of_lt _ ( Finset.sum_lt_sum _ _ ) );
    rotate_left;
    use fun i => p i - q i;
    · exact fun i _ => if hi : p i = q i then by simp +decide [ hi ] else le_of_lt ( h_strict i hi );
    · exact Function.ne_iff.mp h |> Exists.imp fun i hi => ⟨ Finset.mem_univ _, h_strict i hi ⟩;
    · simp +decide [ hps, hqs ];
  · simp +decide [ h, relEntropy ]

/-
Key algebraic identity: for any probability vector `r`, the relative entropy
against the Gibbs distribution decomposes into an entropy difference and a
mean-energy difference:
`relEntropy r (gibbs ε β) = (H(g) - H(r)) + β (⟨ε⟩_r - ⟨ε⟩_g)`.
-/
theorem relEntropy_gibbs_decomp [Nonempty k] (ε : k → ℝ) (β : ℝ)
    (r : k → ℝ) (hr : ∀ i, 0 ≤ r i) (hrs : ∑ i, r i = 1) :
    relEntropy r (gibbs ε β)
      = (shannonEntropy (gibbs ε β) - shannonEntropy r)
        + β * (energy ε r - energy ε (gibbs ε β)) := by
  -- By definition of $relEntropy$, we have:
  have h_relEntropy_def : relEntropy r (gibbs ε β) = -shannonEntropy r + β * (∑ i, r i * ε i) + (∑ i, r i * Real.log (partition ε β)) := by
    unfold relEntropy shannonEntropy gibbs;
    rw [ ← Finset.sum_neg_distrib, Finset.mul_sum _ _ _ ];
    rw [ ← Finset.sum_add_distrib, ← Finset.sum_add_distrib ]
    apply Finset.sum_congr rfl
    intro i _
    have hZ : partition ε β ≠ 0 := ne_of_gt (partition_pos ε β)
    rcases eq_or_lt_of_le (hr i) with hi | hi
    · simp [← hi, Real.negMulLog]
    · rw [ Real.log_div hi.ne' (div_ne_zero (Real.exp_ne_zero _) hZ),
        Real.log_div (Real.exp_ne_zero _) hZ, Real.log_exp, Real.negMulLog ]
      ring
  -- By definition of $relEntropy$, we have for the Gibbs distribution:
  have h_relEntropy_gibbs : relEntropy (gibbs ε β) (gibbs ε β) = -shannonEntropy (gibbs ε β) + β * (∑ i, (gibbs ε β) i * ε i) + (∑ i, (gibbs ε β) i * Real.log (partition ε β)) := by
    unfold relEntropy shannonEntropy;
    simp +decide [ Real.negMulLog, gibbs ];
    rw [ Finset.mul_sum _ _ _ ] ; rw [ ← Finset.sum_add_distrib ] ; rw [ ← Finset.sum_add_distrib ] ; refine' Eq.symm ( Finset.sum_eq_zero fun i _ => _ ) ; rw [ Real.log_div ( by positivity ) ( by exact ne_of_gt ( partition_pos ε β ) ), Real.log_exp ] ; ring;
  simp_all +decide [ mul_add, add_assoc, sub_eq_add_neg, Finset.mul_sum _ _ _ ];
  simp_all +decide [ ← Finset.mul_sum _ _ _, ← Finset.sum_mul, energy ];
  rw [ show relEntropy ( gibbs ε β ) ( gibbs ε β ) = 0 from _ ] at h_relEntropy_gibbs ; rw [ gibbs_sum_one ] at h_relEntropy_gibbs ; linarith;
  exact Finset.sum_eq_zero fun i _ => by rw [ div_self ( ne_of_gt ( gibbs_pos ε β i ) ) ] ; simp +decide [ Real.log_one ] ;

/-
**TARGET (main): maximum-entropy / Gibbs variational principle.**
Among probability distributions with mean energy equal to that of the Gibbs
state, the Gibbs state maximizes Shannon entropy, uniquely.
-/
theorem gibbs_maximizes_entropy [Nonempty k] (ε : k → ℝ) (β : ℝ)
    (p : k → ℝ) (hp : ∀ i, 0 ≤ p i) (hps : ∑ i, p i = 1)
    (hE : energy ε p = energy ε (gibbs ε β)) :
    shannonEntropy p ≤ shannonEntropy (gibbs ε β)
      ∧ (shannonEntropy p = shannonEntropy (gibbs ε β) ↔ p = gibbs ε β) := by
  constructor;
  · have h_relEntropy_nonneg : 0 ≤ relEntropy p (gibbs ε β) := by
      apply relEntropy_nonneg p (gibbs ε β) hp (fun i => gibbs_pos ε β i) hps (gibbs_sum_one ε β);
    rw [ relEntropy_gibbs_decomp ] at h_relEntropy_nonneg;
    · aesop;
    · assumption;
    · grind +revert;
  · constructor;
    · intro h_eq
      have h_rel : relEntropy p (gibbs ε β) = 0 := by
        grind +suggestions;
      apply (relEntropy_eq_zero_iff p (gibbs ε β) hp (fun i => gibbs_pos ε β i) hps (gibbs_sum_one ε β)).mp h_rel;
    · aesop

end PhysicsSM.Draft.NullEdge.GibbsVariational

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.GibbsVariational.gibbs_maximizes_entropy' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GibbsVariational.gibbs_maximizes_entropy

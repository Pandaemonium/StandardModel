import Mathlib

/-!
# General (non-commuting) quantum Klein inequality via a CFC-free spectral log

Draft module (DYN-MODULAR-001 general-`N` extension). Removes the commuting /
shared-eigenbasis restriction of the landed `QuantumKleinShared` and the
qubit-only scope of the operator-level S2 capstone: for ARBITRARY finite density
matrices `rho`, `sigma` (Hermitian, PSD, unit trace; `sigma` positive definite),
the quantum relative entropy
`S(rho || sigma) = Tr(rho (log rho - log sigma))` is nonnegative -- this is the
general non-commuting Klein inequality, the operator statement whose commuting
case is `QuantumKleinShared`.

The matrix logarithm is built CFC-free from the Hermitian spectral decomposition
(`Matrix.IsHermitian.eigenvectorUnitary` / `eigenvalues`), so no `Matrix.log`
or continuous-functional-calculus instance is required.

## Key idea (why no operator convexity is needed)

The non-commuting case does NOT require operator convexity of `x |-> x log x`,
operator Jensen, Peierls-Bogoliubov, or Lieb concavity (none of which are in
Mathlib v4.28). Instead the cross term reduces to a scalar doubly-stochastic
Jensen bound: with eigenvalues `lam` of `rho`, `mu` of `sigma`, and the two-basis
overlap `W = Uᴴ V`, `Tr(rho log sigma) = sum_{i,j} lam_i |W_ij|^2 log mu_j`
(`cross_trace_eq_sum`); `p_ij = |W_ij|^2` is doubly stochastic because `W` is
unitary; and `scalar_klein` closes `0 <= sum lam_i log lam_i - sum lam_i p_ij
log mu_j` for any doubly-stochastic `p` using ONLY scalar `Real.log` concavity
(Jensen) and `Real.log_le_sub_one_of_pos`. In the commuting case `W` is a
permutation and this collapses to the diagonal Gibbs inequality; in the
non-commuting case `W` is a general unitary but `|W_ij|^2` is still doubly
stochastic -- that is exactly what replaces the missing operator lemmas.

## Trust status

Draft-trust by kernel: `qKlein_nonneg` and `entropy_trace_eq_sum` are `sorry`-free
and depend only on `[propext, Classical.choice, Quot.sound]` (no `native_decide`
/ `Lean.ofReduceBool`; a `set_option maxHeartbeats` on `cross_trace_eq_sum` is a
resource limit only, not a trust change), pinned by the `#print axioms` guard
blocks at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12, DYN-MODULAR-001 general-`N`
extension). Proof search by Aristotle (project
`c35c62e5-68d7-49d2-b086-9a683bfc8c30`), then independently re-checked in this
repo (`lake env lean`; axiom footprint confirmed kernel-only). The doubly-
stochastic overlap reduction is the standard route to Klein's inequality;
formalizing it CFC-free (via `Matrix.IsHermitian.eigenvectorUnitary`) is the
in-project contribution. Clean-room formalization from the mathematical
statement.
-/

noncomputable section

namespace GeneralKleinEquality

open Matrix
open scoped ComplexOrder BigOperators

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- CFC-free spectral matrix logarithm of a Hermitian matrix:
`log rho = U diag(log lambda) Uᴴ` with `U` the eigenvector unitary.

Note (terminology, per Codex cross-audit): for a SINGULAR `rho` (a zero
eigenvalue), this uses `Real.log 0 = 0`, so `logHermitian` is the
ENTROPY-COMPATIBLE spectral extension of the logarithm (matching the
`0 * log 0 = 0` convention of von Neumann entropy), NOT the ordinary matrix
logarithm (which is undefined on singular matrices). In `qKlein_nonneg` this is
harmless: `sigma` is `PosDef` so `logHermitian sigma` is the ordinary log, and
`rho`'s zero eigenvalues contribute `0` to the entropy trace, exactly as the
entropy functional requires. -/
def logHermitian (ρ : Matrix n n ℂ) (hρ : ρ.IsHermitian) : Matrix n n ℂ :=
  (hρ.eigenvectorUnitary : Matrix n n ℂ) *
      diagonal (fun i => (Real.log (hρ.eigenvalues i) : ℂ)) *
    (hρ.eigenvectorUnitary : Matrix n n ℂ)ᴴ

/-- Quantum relative entropy `S(rho || sigma) = Tr(rho (log rho - log sigma))`,
taken CFC-free through `logHermitian`. -/
def qRelEntropy (ρ σ : Matrix n n ℂ) (hρ : ρ.IsHermitian) (hσ : σ.IsHermitian) : ℝ :=
  (ρ * (logHermitian ρ hρ - logHermitian σ hσ)).trace.re

/-
**HELPER TARGET (should be provable): entropy trace identity.**
`Tr(rho log rho) = sum_i lambda_i log lambda_i` (`= -S(rho)`), via the spectral
decomposition and trace cyclicity. This is the CFC-free bridge to
`sum_i negMulLog(lambda_i)` and does not need Klein.
-/
theorem entropy_trace_eq_sum (ρ : Matrix n n ℂ) (hρ : ρ.IsHermitian) :
    (ρ * logHermitian ρ hρ).trace.re
      = ∑ i, (hρ.eigenvalues i) * Real.log (hρ.eigenvalues i) := by
  -- Now, use the fact that the eigenvalues and eigenvectors of `ρ` are orthogonal and that `ρ` is Hermitian: thus, `ρ` is diagonalizable.
  have h_diag : ρ * logHermitian ρ hρ = (hρ.eigenvectorUnitary : Matrix n n ℂ) * diagonal (fun i => (hρ.eigenvalues i : ℂ) * (Real.log (hρ.eigenvalues i) : ℂ)) * (hρ.eigenvectorUnitary : Matrix n n ℂ)ᴴ := by
    have h₁ := hρ.spectral_theorem;
    convert congr_arg ( fun x => x * ( logHermitian ρ hρ ) ) h₁ using 1;
    unfold logHermitian; simp +decide [ Matrix.mul_assoc ] ;
    simp +decide [ ← mul_assoc ];
  convert congr_arg Complex.re ( congrArg Matrix.trace ( show ρ * logHermitian ρ hρ = ( hρ.eigenvectorUnitary : Matrix n n ℂ ) * diagonal ( fun i => ( hρ.eigenvalues i : ℂ ) * ( Real.log ( hρ.eigenvalues i ) : ℂ ) ) * ( hρ.eigenvectorUnitary : Matrix n n ℂ ) ᴴ from h_diag ) ) using 1;
  rw [ ← Matrix.trace_mul_comm ] ; simp +decide [ Matrix.trace ] ;
  simp +decide [ ← mul_assoc, Matrix.IsHermitian.eigenvectorUnitary ]

/-
**Scalar / finite Klein (Gibbs) inequality** via a doubly-stochastic
transition matrix `p`. This is the arithmetic core of the non-commuting Klein
inequality; it uses ONLY scalar concavity of `Real.log` (`strictConcaveOn_log_Ioi`
via `ConcaveOn.le_map_sum`) and the elementary bound `Real.log_le_sub_one_of_pos`.
No operator convexity is required.
-/
omit [DecidableEq n] in
lemma scalar_klein {m : Type*} [Fintype m]
    (lam : n → ℝ) (mu : m → ℝ) (p : n → m → ℝ)
    (hlam : ∀ i, 0 ≤ lam i) (hmu : ∀ j, 0 < mu j)
    (hp : ∀ i j, 0 ≤ p i j)
    (hrow : ∀ i, ∑ j, p i j = 1)
    (hcol : ∀ j, ∑ i, p i j = 1)
    (hlamsum : ∑ i, lam i = 1)
    (hmusum : ∑ j, mu j = 1) :
    0 ≤ (∑ i, lam i * Real.log (lam i))
        - ∑ i, ∑ j, lam i * p i j * Real.log (mu j) := by
  -- Define ν i := ∑ j, p i j * mu j.
  set ν := fun i => ∑ j, p i j * mu j;
  -- By the properties of logarithms and the strict concavity of the logarithm function, we have:
  have h_log_ineq : ∀ i, lam i * Real.log (lam i) - lam i * Real.log (ν i) ≥ lam i - ν i := by
    intro i
    by_cases h_lam_zero : lam i = 0;
    · simp [h_lam_zero];
      exact Finset.sum_nonneg fun _ _ => mul_nonneg ( hp _ _ ) ( le_of_lt ( hmu _ ) );
    · have h_log_ineq : Real.log (ν i / lam i) ≤ ν i / lam i - 1 := by
        apply Real.log_le_sub_one_of_pos;
        exact div_pos ( lt_of_lt_of_le ( mul_pos ( show 0 < p i ( Classical.choose ( show ∃ j, p i j ≠ 0 from not_forall.mp fun h => by have := hrow i; simp_all +decide ) ) from lt_of_le_of_ne ( hp i _ ) ( Ne.symm ( Classical.choose_spec ( show ∃ j, p i j ≠ 0 from not_forall.mp fun h => by have := hrow i; simp_all +decide ) ) ) ) ( hmu _ ) ) ( Finset.single_le_sum ( fun j _ => mul_nonneg ( hp i j ) ( le_of_lt ( hmu j ) ) ) ( Finset.mem_univ _ ) ) ) ( lt_of_le_of_ne ( hlam i ) ( Ne.symm h_lam_zero ) );
      rw [ Real.log_div ] at h_log_ineq;
      · nlinarith [ hlam i, mul_div_cancel₀ ( ν i ) h_lam_zero ];
      · contrapose! h_log_ineq; simp_all +decide ;
      · exact h_lam_zero;
  -- By the properties of logarithms and the strict concavity of the logarithm function, we have $\sum_i \lambda_i \log(\nu_i) \geq \sum_i \lambda_i \sum_j p_{ij} \log(\mu_j)$.
  have h_log_sum_ineq : ∑ i, lam i * Real.log (ν i) ≥ ∑ i, lam i * ∑ j, p i j * Real.log (mu j) := by
    -- Apply Jensen's inequality to the concave function $\log$.
    have h_jensen : ∀ i, Real.log (∑ j, p i j * mu j) ≥ ∑ j, p i j * Real.log (mu j) := by
      intro i;
      have h_jensen : ConcaveOn ℝ (Set.Ioi 0) Real.log := by
        exact ( StrictConcaveOn.concaveOn <| strictConcaveOn_log_Ioi );
      apply_rules [ h_jensen.le_map_sum ];
      · exact fun _ _ => hp _ _;
      · exact fun _ _ => hmu _;
    exact Finset.sum_le_sum fun i _ => mul_le_mul_of_nonneg_left ( h_jensen i ) ( hlam i );
  simp_all +decide [ mul_assoc, Finset.mul_sum _ _ _ ];
  refine' le_trans h_log_sum_ineq ( le_trans ( Finset.sum_le_sum fun i _ => show lam i * Real.log ( ν i ) ≤ lam i * Real.log ( lam i ) - ( lam i - ν i ) by linarith [ h_log_ineq i ] ) _ );
  simp +decide [ Finset.sum_sub_distrib, hlamsum ];
  rw [ Finset.sum_comm ];
  simp +decide [ ← Finset.sum_mul, hcol, hmusum ]

/-
Row sums of `|W i j|²` for a unitary `W` equal `1` (from `W * star W = 1`).
-/
lemma unitary_normSq_row_sum (W : Matrix n n ℂ)
    (hW : W ∈ Matrix.unitaryGroup n ℂ) (i : n) :
    ∑ j, Complex.normSq (W i j) = 1 := by
  convert congr_arg ( fun x => x.re ) ( congr_fun ( congr_fun ( show W * W.conjTranspose = 1 from ?_ ) i ) i );
  · simp +decide [ Complex.normSq, Matrix.mul_apply, Matrix.conjTranspose_apply ];
  · simp +decide;
  · exact hW.2

/-
Column sums of `|W i j|²` for a unitary `W` equal `1` (from `star W * W = 1`).
-/
lemma unitary_normSq_col_sum (W : Matrix n n ℂ)
    (hW : W ∈ Matrix.unitaryGroup n ℂ) (j : n) :
    ∑ i, Complex.normSq (W i j) = 1 := by
  convert congr_arg ( fun x => x.re ) ( show ( ∑ i, ( starRingEnd ℂ ) ( W i j ) * ( W i j ) : ℂ ) = 1 from ?_ ) using 1;
  · simp +decide [ Complex.normSq, mul_comm ];
  · convert congr_arg ( fun x => x j j ) ( show ( star W ) * W = 1 from ?_ ) using 1;
    · simp +decide;
    · exact hW.1

/-
The `Uᴴ V` "overlap" matrix built from the two eigenvector unitaries is
unitary.
-/
lemma overlap_mem_unitaryGroup (ρ σ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hσ : σ.IsHermitian) :
    ((hρ.eigenvectorUnitary : Matrix n n ℂ)ᴴ * (hσ.eigenvectorUnitary : Matrix n n ℂ))
      ∈ Matrix.unitaryGroup n ℂ := by
  constructor;
  · simp +decide [ Matrix.mul_assoc, mul_eq_one_comm ];
    simp +decide [ Matrix.IsHermitian.eigenvectorUnitary ];
    simp +decide [ mul_eq_one_comm, Matrix.star_eq_conjTranspose ];
  · simp +decide [ Matrix.mul_assoc, mul_eq_one_comm ];
    simp +decide [ ← Matrix.mul_assoc ];
    simp +decide [ mul_eq_one_comm, Matrix.star_eq_conjTranspose ];
    have := hρ.eigenvectorUnitary.2;
    exact this.2

/-
**Cross-term trace identity.**
`Tr(rho log sigma) = ∑_{i,j} λ_i |Wᵢⱼ|² log μ_j`, where `λ`, `μ` are the
eigenvalues of `rho`, `sigma` and `W = Uᴴ V` is the overlap of the eigenvector
unitaries. This is the two-basis analogue of `entropy_trace_eq_sum`.
-/
set_option maxHeartbeats 1000000 in
lemma cross_trace_eq_sum (ρ σ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hσ : σ.IsHermitian) :
    (ρ * logHermitian σ hσ).trace.re
      = ∑ i, ∑ j, hρ.eigenvalues i *
          Complex.normSq (((hρ.eigenvectorUnitary : Matrix n n ℂ)ᴴ *
            (hσ.eigenvectorUnitary : Matrix n n ℂ)) i j)
          * Real.log (hσ.eigenvalues j) := by
  convert congr_arg Complex.re ?_ using 1;
  rotate_left;
  exact ∑ i, ∑ j, ( hρ.eigenvalues i : ℂ ) * Complex.normSq ( ( hρ.eigenvectorUnitary : Matrix n n ℂ )ᴴ * hσ.eigenvectorUnitary |> fun m => m i j ) * Real.log ( hσ.eigenvalues j );
  · convert congr_arg Matrix.trace ?_ using 1;
    rotate_left;
    exact ( hρ.eigenvectorUnitary : Matrix n n ℂ ) * diagonal ( fun i => ( hρ.eigenvalues i : ℂ ) ) * ( hρ.eigenvectorUnitary : Matrix n n ℂ )ᴴ * ( hσ.eigenvectorUnitary : Matrix n n ℂ ) * diagonal ( fun j => ( Real.log ( hσ.eigenvalues j ) : ℂ ) ) * ( hσ.eigenvectorUnitary : Matrix n n ℂ )ᴴ;
    · convert congr_arg ( fun x => x * logHermitian σ hσ ) ( hρ.spectral_theorem ) using 1;
      unfold logHermitian; simp +decide [ Matrix.mul_assoc ] ;
      rfl;
    · simp +decide [ Matrix.trace, Matrix.mul_apply, Complex.normSq_eq_conj_mul_self ];
      simp +decide [ Matrix.diagonal, Finset.mul_sum _ _ _, Finset.sum_mul, mul_assoc, mul_comm, mul_left_comm ];
      simp +decide only [← Finset.sum_product'];
      refine' Finset.sum_bij ( fun x _ => ( x.2.2.2, x.2.1, x.2.2.1, x.1 ) ) _ _ _ _ <;> simp +decide;
  · norm_cast

/-- **MAIN TARGET (hard; prove or map the obstruction): general quantum Klein
inequality.** For finite density matrices `rho` (PSD, unit trace) and `sigma`
(positive definite, unit trace), the quantum relative entropy is nonnegative,
with NO commuting assumption. -/
theorem qKlein_nonneg (ρ σ : Matrix n n ℂ)
    (hρ : ρ.IsHermitian) (hσ : σ.IsHermitian)
    (hρpsd : ρ.PosSemidef) (hσpd : σ.PosDef)
    (hρtr : ρ.trace = 1) (hσtr : σ.trace = 1) :
    0 ≤ qRelEntropy ρ σ hρ hσ := by
  -- Rewrite the relative entropy as a difference of the two trace identities.
  have hsplit : qRelEntropy ρ σ hρ hσ
      = (ρ * logHermitian ρ hρ).trace.re - (ρ * logHermitian σ hσ).trace.re := by
    unfold qRelEntropy
    rw [Matrix.mul_sub, Matrix.trace_sub, Complex.sub_re]
  rw [hsplit, entropy_trace_eq_sum ρ hρ,
      cross_trace_eq_sum ρ σ hρ hσ]
  -- The overlap matrix `W = Uᴴ V` is unitary, so `|Wᵢⱼ|²` is doubly stochastic.
  have hWmem : ((hρ.eigenvectorUnitary : Matrix n n ℂ)ᴴ *
      (hσ.eigenvectorUnitary : Matrix n n ℂ)) ∈ Matrix.unitaryGroup n ℂ :=
    overlap_mem_unitaryGroup ρ σ hρ hσ
  exact scalar_klein hρ.eigenvalues hσ.eigenvalues
    (fun i j => Complex.normSq (((hρ.eigenvectorUnitary : Matrix n n ℂ)ᴴ *
      (hσ.eigenvectorUnitary : Matrix n n ℂ)) i j))
    (fun i => hρpsd.eigenvalues_nonneg i)
    (fun j => hσpd.eigenvalues_pos j)
    (fun _ _ => Complex.normSq_nonneg _)
    (fun i => unitary_normSq_row_sum _ hWmem i)
    (fun j => unitary_normSq_col_sum _ hWmem j)
    (by have h := hρ.trace_eq_sum_eigenvalues; rw [hρtr] at h
        have := congrArg Complex.re h.symm; simpa using this)
    (by have h := hσ.trace_eq_sum_eigenvalues; rw [hσtr] at h
        have := congrArg Complex.re h.symm; simpa using this)

/-- **TARGET (ambitious; prove OR map the obstruction): equality case of the
general quantum Klein inequality.** For a density matrix `rho` (PSD, unit trace)
and `sigma` (positive definite, unit trace), the quantum relative entropy
vanishes iff the states coincide. This upgrades `qKlein_nonneg` to full
uniqueness (and hence general-N max-entropy uniqueness).

Forward (`rho = sigma => 0`) is immediate. The hard direction requires tracking
equality through the reduction: equality in `scalar_klein` forces the tangent
bound to be tight (`lam i = nu i`, i.e. `Real.log_le_sub_one` equality only at
`1`) AND Jensen equality for the concave `log` (the `mu j` constant on the
support of each `p i`), which with `p_ij = |W_ij|^2` doubly stochastic forces the
overlap `W` to be a permutation aligning the eigenbases and the eigenvalues to
match, hence `rho = sigma`. If this reconstruction cannot be completed, do NOT
fabricate a proof: leave the backward direction `sorry` with a comment naming the
exact missing step (equality case of `ConcaveOn.le_map_sum` / a doubly-stochastic
Birkhoff-type rigidity lemma) and whether Mathlib v4.28 provides it. -/
theorem qKlein_eq_zero_iff (rho sigma : Matrix n n ℂ)
    (hrho : rho.IsHermitian) (hsigma : sigma.IsHermitian)
    (hrhopsd : rho.PosSemidef) (hsigmapd : sigma.PosDef)
    (hrhotr : rho.trace = 1) (hsigmatr : sigma.trace = 1) :
    qRelEntropy rho sigma hrho hsigma = 0 ↔ rho = sigma := by
  sorry

end GeneralKleinEquality

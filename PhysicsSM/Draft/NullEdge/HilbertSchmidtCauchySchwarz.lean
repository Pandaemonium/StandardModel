import Mathlib

/-!
# Hilbert-Schmidt (trace / Frobenius) Cauchy-Schwarz inequality

Draft module. For complex matrices `A, B`, the squared norm of the Frobenius
inner product `tr(A^H B)` is bounded by the product of the squared Frobenius
norms `re tr(A^H A)` and `re tr(B^H B)`. This is Cauchy-Schwarz for the
Hilbert-Schmidt inner product, foundational for the mass-as-entanglement /
Cauchy-Binet program and for quantum-information overlap bounds. Pure linear
algebra -- no matrix exponential or logarithm.

## Statement

`‖(Aᴴ * B).trace‖ ^ 2 <= (Aᴴ * A).trace.re * (Bᴴ * B).trace.re`.

## Trust status

Draft-trust by kernel: `hs_cauchy_schwarz` is `sorry`-free and depends only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.
Independently re-checked under the pinned toolchain despite the upstream job's
`COMPLETE_WITH_ERRORS` label (which reflected Aristotle's search iterations, not
the final artifact): the downloaded file compiles clean with kernel-only axioms.

## Provenance

Statement authored in-project (AFPL run 2026-07-12). Proof search by Aristotle
(project `5c6b4653-68af-47a3-b708-262e11d90db3`), then independently re-checked in
this repo (`lake env lean`; axiom footprint confirmed kernel-only). Route: reduce
the trace inner product to a coordinate sum over `n x n` and apply the finite
Cauchy-Schwarz `Finset.sum_mul_sq_le_sq_mul_sq`. Clean-room formalization from the
mathematical statement, not copied from external code.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HilbertSchmidt

open Matrix

variable {n : Type*} [Fintype n]

/-- **Hilbert-Schmidt Cauchy-Schwarz.**  The squared norm of the Frobenius inner
product `tr(Aᴴ B)` is bounded by the product of the squared Frobenius norms. -/
theorem hs_cauchy_schwarz (A B : Matrix n n ℂ) :
    ‖(Aᴴ * B).trace‖ ^ 2 ≤ (Aᴴ * A).trace.re * (Bᴴ * B).trace.re := by
  simp [Matrix.trace];
  simp +decide [ Matrix.mul_apply, mul_comm ];
  have h_inner : ∀ (u v : n × n → ℂ), ‖∑ p : n × n, u p * starRingEnd ℂ (v p)‖ ^ 2 ≤ (∑ p : n × n, ‖u p‖ ^ 2) * (∑ p : n × n, ‖v p‖ ^ 2) := by
    intro u v
    have h_inner : ‖∑ p : n × n, u p * starRingEnd ℂ (v p)‖ ^ 2 ≤ (∑ p : n × n, ‖u p‖ * ‖v p‖) ^ 2 := by
      exact pow_le_pow_left₀ ( norm_nonneg _ ) ( le_trans ( norm_sum_le _ _ ) ( Finset.sum_le_sum fun _ _ => by simp +decide ) ) _;
    refine' le_trans h_inner _;
    exact Finset.sum_mul_sq_le_sq_mul_sq Finset.univ (fun i => ‖u i‖) fun i => ‖v i‖;
  convert h_inner ( fun p => B p.2 p.1 ) ( fun p => A p.2 p.1 ) using 1 <;> simp +decide [ Complex.normSq, Complex.sq_norm ];
  · erw [ Finset.sum_product, Finset.sum_product ];
  · simp +decide only [← Finset.sum_product'] ; ring!;

end PhysicsSM.Draft.NullEdge.HilbertSchmidt

-- Axiom-footprint guard (draft-trust by kernel): kernel axioms only, no
-- `native_decide` / `Lean.ofReduceBool`.
/--
info: 'PhysicsSM.Draft.NullEdge.HilbertSchmidt.hs_cauchy_schwarz' depends on axioms: [propext, Classical.choice, Quot.sound]
-/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HilbertSchmidt.hs_cauchy_schwarz

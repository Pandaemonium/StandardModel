import Mathlib

/-!
# Gate A super-Dirac sign theorem and grading counterexamples

This file is the Aristotle deliverable for the **Gate A super-Dirac sign audit**
of the null-edge unified mass program (see `PROMPT.md`,
`AgentTasks/null-edge-super-dirac-sign-double-counting-audit.md`,
`docs/CONVENTIONS.md` and
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §20-21).

This is **finite algebra**, not a continuum claim.  We model the finite
null-edge operators as elements of an arbitrary associative `Ring A`:

* `Gs`  — spacetime chirality `Γ_s` (kept strictly distinct from any internal
  grading `χ_E` or form degree `ε_form`; see `docs/CONVENTIONS.md`);
* `C a` — Clifford / dual-soldered symbols `C_a = c(α^a)`;
* `nab a` — finite transports `∇_a`;
* `Ph` — internal mass block `Φ = Φ_H`;
* `Im` — the central scalar `i` with `i² = -1`.

The null Dirac operator is `D = i D_N + Γ_s Φ` with `D_N = ∑_a C_a ∇_a`.

## Standing (clean / `+Φ²`) hypotheses

```text
(H1) Γ_s² = 1
(H2) {Γ_s, C_a} = 0      (Gs * C a = -(C a * Gs))
(H3) [Γ_s, ∇_a] = 0      (Gs * nab a = nab a * Gs)
(H4) [Γ_s, Φ]   = 0      (Gs * Ph   = Ph * Gs)
(H5) [C_a, Φ]   = 0      (C a * Ph  = Ph * C a)
```

## Main results

* `super_dirac_square_single` — the core single-mode `+Φ²` identity
  `D² = -D_N² + Φ² - i Γ_s C (∇Φ - Φ∇)`.
* `super_dirac_square_sum` — the finite-sum version
  `D² = -D_N² + Φ² - i Γ_s ∑_a C_a [∇_a, Φ]`.
* `super_dirac_square_single_odd` — the wrong-grading companion: if instead
  `{Γ_s, Φ} = 0` the mass sign flips to `-Φ²` (tachyonic), the M1/M2 guardrail
  made formal.
* `graded_square_anticomm` — the headline sign flip `(Γ_s Φ)² = -Φ²` when
  `{Γ_s, Φ} = 0`, and `graded_square_comm` its `+Φ²` counterpart.
* `cross_term_general` — the exact cross-term decomposition, exhibiting the
  extra `[C_a, Φ] ∇` contaminant that survives when (H5) fails.
* Concrete `Matrix (Fin 2) (Fin 2) ℤ` examples (`σz`, `σx`, ...) realising the
  commuting `+Φ²`, anticommuting `-Φ²`, and `[C,Φ] ≠ 0` extra-term cases.

## Guardrails

* `Gs` is *spacetime* chirality only; it is never identified with an internal
  grading `χ_E` or with form degree.  The positive lemmas use `[Γ_s, Φ] = 0`
  (H4); the negative companion uses `{Γ_s, Φ} = 0`.  This contrast is the
  formal M1/M2 sign-trap guardrail.
* The hypotheses are **not** weakened to manufacture the `+Φ²` sign: each sign
  result carries the exact (anti)commutation hypothesis it needs.
-/

namespace PhysicsSM
namespace Draft
namespace SuperDirac

open Finset

/-! ## 1. The headline zero-order sign: `(Γ_s Φ)² = ± Φ²` -/

section GradedSquare

variable {A : Type*} [Ring A]

/-
**Clean grading (`+Φ²`).**  If `Γ_s² = 1` and `Φ` commutes with the same
`Γ_s` that appears in `D` (`[Γ_s, Φ] = 0`), then `(Γ_s Φ)² = +Φ²`.
-/
theorem graded_square_comm (Gs Ph : A)
    (hGs2 : Gs * Gs = 1) (hGsPh : Gs * Ph = Ph * Gs) :
    (Gs * Ph) * (Gs * Ph) = Ph * Ph := by
  grind

/-
**Wrong grading (`-Φ²`).**  If `Γ_s² = 1` and `Φ` *anticommutes* with the
`Γ_s` in `D` (`{Γ_s, Φ} = 0`), then `(Γ_s Φ)² = -Φ²`: a tachyonic sign flip.
This is the headline M1 failure mode made formal.
-/
theorem graded_square_anticomm (Gs Ph : A)
    (hGs2 : Gs * Gs = 1) (hGsPh : Gs * Ph = -(Ph * Gs)) :
    (Gs * Ph) * (Gs * Ph) = -(Ph * Ph) := by
  simp +decide [ mul_assoc, hGsPh ];
  simp +decide [ ← mul_assoc, hGsPh ];
  simp +decide [ mul_assoc, hGs2 ]

end GradedSquare

/-! ## 2. The single-mode super-Dirac square -/

section SingleMode

variable {A : Type*} [Ring A]

/-
**Core single-mode super-Dirac square (clean `+Φ²` regime).**

With a central imaginary unit `Im` (`Im` central, `Im² = -1`), `D_N = C ∇`, and
`D = i D_N + Γ_s Φ`, the clean hypotheses (H1)-(H5) give

```text
D² = -D_N² + Φ² - i Γ_s C (∇Φ - Φ∇).
```
-/
theorem super_dirac_square_single
    (Im Gs C Nb Ph : A)
    (hImc : ∀ x : A, Im * x = x * Im)
    (hIm2 : Im * Im = -1)
    (hGs2 : Gs * Gs = 1)
    (hGsC : Gs * C = -(C * Gs))
    (hGsNb : Gs * Nb = Nb * Gs)
    (hGsPh : Gs * Ph = Ph * Gs)
    (hCPh : C * Ph = Ph * C) :
    (Im * (C * Nb) + Gs * Ph) * (Im * (C * Nb) + Gs * Ph)
      = -((C * Nb) * (C * Nb)) + Ph * Ph
        - Im * (Gs * (C * (Nb * Ph - Ph * Nb))) := by
  simp +decide only [mul_add, add_mul];
  simp +decide [ mul_assoc, hImc ];
  simp +decide [ ← mul_assoc, hIm2, hGsC, hGsPh ];
  simp +decide [ mul_sub, sub_mul, mul_assoc, hGsC, hGsNb, hGsPh ];
  grind

/-
**Wrong-grading companion (`-Φ²`).**  Identical to
`super_dirac_square_single` except `Φ` is *odd* under the spacetime chirality
(`{Γ_s, Φ} = 0`).  The mass term flips sign to the fatal tachyonic `-Φ²`:

```text
D² = -D_N² - Φ² - i Γ_s C (∇Φ - Φ∇).
```

The `-Φ²` is the fatal tachyonic mass; this is the load-bearing negative result
guarding against the M1/M2 sign trap.

**Correction note.**  The draft companion in
`AgentTasks/null-edge-super-dirac-sign-double-counting-audit.md` (§2, row B)
asserted that *both* the mass term *and* the gradient term flip sign
(`+ i Γ_s C (∇Φ - Φ∇)`).  That is incorrect: in the odd regime two sign flips
occur in the cross term — one from combining `D_N Γ_s Φ + Γ_s Φ D_N` and one
from relocating `Γ_s` past `[D_N, Φ]` (which now *anticommutes* with `Γ_s`) —
and they cancel.  Hence only the **mass** term flips; the gradient term keeps
the `- i Γ_s C (∇Φ - Φ∇)` sign of the clean case.  This was verified by an
explicit Gaussian-integer matrix computation before being stated here.  The
audit's headline conclusion (`+Φ² → -Φ²`, the tachyonic mass) is unaffected.
-/
theorem super_dirac_square_single_odd
    (Im Gs C Nb Ph : A)
    (hImc : ∀ x : A, Im * x = x * Im)
    (hIm2 : Im * Im = -1)
    (hGs2 : Gs * Gs = 1)
    (hGsC : Gs * C = -(C * Gs))
    (hGsNb : Gs * Nb = Nb * Gs)
    (hGsPh : Gs * Ph = -(Ph * Gs))
    (hCPh : C * Ph = Ph * C) :
    (Im * (C * Nb) + Gs * Ph) * (Im * (C * Nb) + Gs * Ph)
      = -((C * Nb) * (C * Nb)) - Ph * Ph
        - Im * (Gs * (C * (Nb * Ph - Ph * Nb))) := by
  simp_all +decide [ mul_add, add_mul, mul_assoc, sub_eq_add_neg ];
  simp_all +decide [ ← mul_assoc ];
  simp_all +decide [ mul_assoc, ← eq_sub_iff_add_eq' ];
  abel1

end SingleMode

/-! ## 3. The finite-sum super-Dirac square -/

section FiniteSum

variable {ι : Type*} [Fintype ι]
variable {A : Type*} [Ring A]

/-- The finite null Dirac operator `D_N = ∑_a C_a ∇_a`. -/
def dNsum (C nab : ι → A) : A := ∑ a, C a * nab a

/-
`Γ_s` anticommutes with `D_N`: `{Γ_s, D_N} = 0`, from (H2) and (H3).
-/
theorem gs_anticomm_dNsum (Gs : A) (C nab : ι → A)
    (hGsC : ∀ a, Gs * C a = -(C a * Gs))
    (hGsNb : ∀ a, Gs * nab a = nab a * Gs) :
    Gs * dNsum C nab = -(dNsum C nab * Gs) := by
  simp_all +decide [ mul_assoc, Finset.mul_sum _ _ _, Finset.sum_mul, dNsum ];
  simp +decide only [← mul_assoc, hGsC, neg_mul];
  simp +decide only [mul_assoc, hGsNb, sum_neg_distrib]

/-
The commutator `[D_N, Φ]` collapses to `∑_a C_a [∇_a, Φ]` using (H5).
-/
theorem dNsum_Ph_commutator (Ph : A) (C nab : ι → A)
    (hCPh : ∀ a, C a * Ph = Ph * C a) :
    dNsum C nab * Ph - Ph * dNsum C nab
      = ∑ a, C a * (nab a * Ph - Ph * nab a) := by
  simp +decide [ dNsum, mul_sub, Finset.sum_mul, mul_assoc ];
  simp +decide only [Finset.mul_sum _ _ _, ← mul_assoc, hCPh]

/-
**Finite-sum super-Dirac square (clean `+Φ²` regime).**

With `D_N = ∑_a C_a ∇_a` and `D = i D_N + Γ_s Φ`, the clean hypotheses (H1)-(H5)
give

```text
D² = -D_N² + Φ² - i Γ_s ∑_a C_a [∇_a, Φ].
```
-/
theorem super_dirac_square_sum
    (Im Gs Ph : A) (C nab : ι → A)
    (hImc : ∀ x : A, Im * x = x * Im)
    (hIm2 : Im * Im = -1)
    (hGs2 : Gs * Gs = 1)
    (hGsC : ∀ a, Gs * C a = -(C a * Gs))
    (hGsNb : ∀ a, Gs * nab a = nab a * Gs)
    (hGsPh : Gs * Ph = Ph * Gs)
    (hCPh : ∀ a, C a * Ph = Ph * C a) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
      = -(dNsum C nab * dNsum C nab) + Ph * Ph
        - Im * (Gs * ∑ a, C a * (nab a * Ph - Ph * nab a)) := by
  simp +decide [ mul_add, add_mul, Finset.mul_sum _ _ _, Finset.sum_mul, dNsum ];
  simp +decide only [mul_assoc, sum_add_distrib, mul_sub];
  simp +decide [ ← mul_assoc, hImc, hGsPh, hCPh, hGsC ];
  simp +decide [ mul_assoc, hIm2, hGs2, hGsNb, hGsC, hGsPh, sub_eq_add_neg, add_assoc, add_left_comm, add_comm ]

/--
The clean Gate A hypotheses, packaged so downstream files can depend on one
semantic object rather than repeating the sign assumptions by hand.

This is deliberately a `Prop`: it records exactly the algebraic conditions
needed for the positive-mass super-Dirac square and no more.
-/
structure CleanSquareHypotheses (Im Gs Ph : A) (C nab : ι → A) : Prop where
  im_central : ∀ x : A, Im * x = x * Im
  im_sq : Im * Im = -1
  gs_sq : Gs * Gs = 1
  gs_clifford : ∀ a, Gs * C a = -(C a * Gs)
  gs_transport : ∀ a, Gs * nab a = nab a * Gs
  gs_mass : Gs * Ph = Ph * Gs
  clifford_mass : ∀ a, C a * Ph = Ph * C a

/--
Gate A closeout theorem in operator commutator form.

This is the finite super-Dirac square written without expanding the commutator
`[D_N, Phi]` into edge labels.  The result is the downstream-facing theorem:
under the clean sign hypotheses,

```text
(i D_N + Gamma_s Phi)^2
  = -D_N^2 + Phi^2 - i Gamma_s (D_N Phi - Phi D_N).
```

The indexed gradient form is recovered by `dNsum_Ph_commutator`.
-/
theorem super_dirac_square_commutator_form
    (Im Gs Ph : A) (C nab : ι → A)
    (hImc : ∀ x : A, Im * x = x * Im)
    (hIm2 : Im * Im = -1)
    (hGs2 : Gs * Gs = 1)
    (hGsC : ∀ a, Gs * C a = -(C a * Gs))
    (hGsNb : ∀ a, Gs * nab a = nab a * Gs)
    (hGsPh : Gs * Ph = Ph * Gs)
    (hCPh : ∀ a, C a * Ph = Ph * C a) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
      = -(dNsum C nab * dNsum C nab) + Ph * Ph
        - Im * (Gs * (dNsum C nab * Ph - Ph * dNsum C nab)) := by
  rw [dNsum_Ph_commutator Ph C nab hCPh]
  exact super_dirac_square_sum Im Gs Ph C nab
    hImc hIm2 hGs2 hGsC hGsNb hGsPh hCPh

/--
Named Gate A closeout theorem using the packaged clean hypotheses.

This is intentionally just a thin wrapper around
`super_dirac_square_commutator_form`: the point is to freeze the sign and
commutation ledger in one hypothesis object that later Gate B/D/H files can
import without restating or silently changing the assumptions.
-/
theorem super_dirac_square_named
    (Im Gs Ph : A) (C nab : ι → A)
    (h : CleanSquareHypotheses Im Gs Ph C nab) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
      = -(dNsum C nab * dNsum C nab) + Ph * Ph
        - Im * (Gs * (dNsum C nab * Ph - Ph * dNsum C nab)) := by
  exact super_dirac_square_commutator_form Im Gs Ph C nab
    h.im_central h.im_sq h.gs_sq h.gs_clifford h.gs_transport
    h.gs_mass h.clifford_mass

/--
Parallel-mass specialization of the Gate A square.

If the finite transports also commute with the mass block, the gradient
commutator vanishes.  The square reduces to the clean no-double-count form
`-D_N^2 + Phi^2`; the kinetic symbol and internal square may then be related by
a mass-shell constraint rather than added as independent mass-square terms.
-/
theorem super_dirac_square_parallel_mass
    (Im Gs Ph : A) (C nab : ι → A)
    (h : CleanSquareHypotheses Im Gs Ph C nab)
    (hNabPh : ∀ a, nab a * Ph = Ph * nab a) :
    (Im * dNsum C nab + Gs * Ph) * (Im * dNsum C nab + Gs * Ph)
      = -(dNsum C nab * dNsum C nab) + Ph * Ph := by
  have hSquare := super_dirac_square_sum Im Gs Ph C nab
    h.im_central h.im_sq h.gs_sq h.gs_clifford h.gs_transport
    h.gs_mass h.clifford_mass
  simpa [hNabPh] using hSquare

end FiniteSum

/-! ## 4. The cross-term decomposition and the `[C,Φ] ≠ 0` contaminant -/

section CrossTerm

variable {A : Type*} [Ring A]

/-
**Exact cross-term decomposition (no hypotheses).**  In any ring,

```text
[C ∇, Φ] = C [∇, Φ] + [C, Φ] ∇.
```

When (H5) `[C, Φ] = 0` holds the second term drops and `[D_N, Φ]` collapses to
the clean gradient `C [∇, Φ]`.  When (H5) *fails*, the `[C, Φ] ∇` contaminant
survives — the clean square theorem then does **not** apply.
-/
theorem cross_term_general (C Nb Ph : A) :
    (C * Nb) * Ph - Ph * (C * Nb)
      = C * (Nb * Ph - Ph * Nb) + (C * Ph - Ph * C) * Nb := by
  grind +qlia

end CrossTerm

/-! ## 5. Tiny concrete matrix examples (`Matrix (Fin 2) (Fin 2) ℤ`)

These realise the three audited regimes with explicit Pauli-type matrices.
`Gs = σ_z` throughout.  No imaginary unit is needed for the zero-order sign
examples, so we work over `ℤ`. -/

section MatrixExamples

/-- `σ_z = diag(1, -1)`, used as the spacetime chirality `Γ_s`. -/
def σz : Matrix (Fin 2) (Fin 2) ℤ := !![1, 0; 0, -1]

/-- `σ_x`, which anticommutes with `σ_z`. -/
def σx : Matrix (Fin 2) (Fin 2) ℤ := !![0, 1; 1, 0]

/-- A diagonal `Φ` that commutes with `σ_z`. -/
def Phdiag : Matrix (Fin 2) (Fin 2) ℤ := !![2, 0; 0, 3]

/-
`σ_z² = 1`.

Structural (kernel-checked) proof: expand each of the four entries with
`Matrix.mul_apply` + `Fin.sum_univ_two`.  No native evaluation; axiom footprint
is `propext, Classical.choice, Quot.sound` only.
-/
theorem σz_sq : σz * σz = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [σz, Matrix.mul_apply, Fin.sum_univ_two]

/-
**Commuting `Φ` ⇒ `+Φ²`.**  `Φ = diag(2,3)` commutes with `Γ_s = σ_z`, and
`(Γ_s Φ)² = +Φ²`.

Structural (kernel-checked) proof: entrywise expansion via `Matrix.mul_apply`.
-/
theorem example_commuting_plus :
    σz * Phdiag = Phdiag * σz ∧
    (σz * Phdiag) * (σz * Phdiag) = Phdiag * Phdiag := by
  refine ⟨?_, ?_⟩ <;> ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [σz, Phdiag, Matrix.mul_apply, Fin.sum_univ_two]

/-
**Anticommuting `Φ` ⇒ `-Φ²`.**  `Φ = σ_x` anticommutes with `Γ_s = σ_z`
(`{Γ_s, Φ} = 0`), and `(Γ_s Φ)² = -Φ²`: the tachyonic sign flip.

Structural (kernel-checked) proof: entrywise expansion via `Matrix.mul_apply`.
-/
theorem example_anticommuting_minus :
    σz * σx + σx * σz = 0 ∧
    (σz * σx) * (σz * σx) = -(σx * σx) := by
  refine ⟨?_, ?_⟩ <;> ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [σz, σx, Matrix.mul_apply, Fin.sum_univ_two]

/-
**`[C, Φ] ≠ 0` ⇒ extra term, theorem does not apply.**  With `C = σ_x`,
`Φ = σ_z`, `∇ = 1`, the symbol `C` and `Φ` do not commute, so the clean
collapse `[D_N, Φ] = C [∇, Φ]` *fails*: the left side is the nonzero
contaminant `[C, Φ] ∇`, while the clean right side is `0`.

Structural (kernel-checked) proof: each inequality is witnessed by the `(0,1)`
entry, expanded via `Matrix.mul_apply`.  No native evaluation.
-/
theorem example_extra_term_when_CPh_fails :
    σx * σz ≠ σz * σx ∧
    (σx * (1 : Matrix (Fin 2) (Fin 2) ℤ)) * σz - σz * (σx * 1)
      ≠ σx * (1 * σz - σz * 1) := by
  constructor
  · intro h
    have := congrFun (congrFun h 0) 1
    simp [σz, σx, Matrix.mul_apply, Fin.sum_univ_two] at this
  · intro h
    have := congrFun (congrFun h 0) 1
    simp [σz, σx, Matrix.mul_apply, Matrix.sub_apply] at this

end MatrixExamples

end SuperDirac
end Draft
end PhysicsSM

# Null-edge Krein double self-adjointness and counterexamples report

**Build-checked Lean deliverable. Generated 2026-06-26.**

Scope. This report accompanies the kernel-checked Lean file
`PhysicsSM/Draft/KreinDoubleAndCounterexamples.lean`. It realizes the Krein /
Lorentzian-adjointness audit (`AgentTasks/null-edge-krein-stability-audit.md`,
Sections 1-2 and 5.1) and the C5+C7 honesty pairing recorded in
`AgentTasks/null-edge-job-dependency-dag.md`, under the locked non-overclaim rule
of `docs/CONVENTIONS.md`, section "Krein / Lorentzian adjointness".

All statements below are proved in Lean and build cleanly with no `sorry` and no
nonstandard axioms (each theorem depends only on `propext`, `Classical.choice`,
`Quot.sound`).

Operating principle (the load-bearing distinction, restated):

```text
Krein J-self-adjointness is an algebraic Lorentzian-hygiene identity.
Real spectrum, positivity, unitary evolution, and absence of growing modes
are separate physical facts. The first is proved here. None of the second
follow from it, and none may be claimed by convention.
```

---

## 1. Conventions and definitions (Layer A datum)

Work over `Matrix n n ℂ` (finite `n`) with conjugate-transpose `Aᴴ`. A
*fundamental symmetry* `J` satisfies `J = Jᴴ = J⁻¹`, encoded as the two
hypotheses `hHerm : Jᴴ = J` and `hInv : J * J = 1`.

Lean definitions (`section General`):

```text
sharp J A      := J * Aᴴ * J                      -- Krein adjoint  A♯
Ddbl Dp Dm     := fromBlocks 0 Dm Dp 0            -- [[0, D₋], [D₊, 0]]
Jdbl J         := fromBlocks J 0 0 J              -- diag(J, J)
```

These are faithful to the locked statement `J = J^dagger = J^{-1}`,
`A^sharp = J A^dagger J`, `D_- = D_+^sharp`, `D_dbl = [[0, D_-],[D_+, 0]]`,
`J_dbl = diag(J, J)`. `sharp` is marked `noncomputable` (conjugate-transpose
over `ℂ`).

---

## 2. Layer A: the finite Krein double identity (proved)

| Lean name | Statement |
| --- | --- |
| `Jdbl_isFundamental` | If `Jᴴ = J` and `J*J = 1` then `(Jdbl J)ᴴ = Jdbl J` and `(Jdbl J)*(Jdbl J) = 1`. |
| `sharp_sharp` | `sharp J (sharp J A) = A` under `hHerm`, `hInv` (sharp is involutive). |
| `sharp_mul` | `sharp J (A * B) = sharp J B * sharp J A` under `hInv` (antimultiplicative). |
| `Ddbl_kreinSelfAdjoint` | If `Jᴴ = J` and `J*J = 1` then `sharp (Jdbl J) (Ddbl Dp (sharp J Dp)) = Ddbl Dp (sharp J Dp)`. |

`Ddbl_kreinSelfAdjoint` is the finite Krein double theorem: with `D₋ = D₊♯`, the
doubled operator `D_dbl` is `J_dbl`-self-adjoint. It holds for **every** `D₊`
(no spectral hypothesis), which is exactly why it is hygiene and not stability.

Note on hypotheses: `sharp_mul` needs only involutivity `J*J = 1`, not
Hermiticity; the `hHerm` hypothesis was dropped from that one lemma since the
proof does not use it. The other three genuinely use both.

---

## 3. Layer B counterexamples (proved): hygiene does not give stability

All counterexamples use the indefinite metric `J2 = diag(1, -1)` of signature
`(1, 1)`, verified a genuine fundamental symmetry by `J2_isFundamental`
(`J2ᴴ = J2` and `J2 * J2 = 1`).

For real `2 × 2` matrices the `J`-self-adjointness condition `J Aᵀ J = A` forces
`A = [[a, b], [-b, d]]`, whose eigenvalues are
`(a + d)/2 ± sqrt((a - d)² - 4 b²)/2`; for `(a - d)² < 4 b²` they are a
complex-conjugate pair. This single family breaks every "stability" reading.

| Lean name | Matrix | What it shows |
| --- | --- | --- |
| `jselfadj_not_real_spectrum` | `A1 = [[0,1],[-1,0]]` | `J`-self-adjoint, eigenvalue `i` (eigenvector `(1, i)`); `Im = 1 ≠ 0`. **Real spectrum fails.** |
| `jselfadj_not_stable` | `A2 = [[1,2],[-2,1]]` | `J`-self-adjoint, eigenvalue `1 + 2i` (eigenvector `(1, i)`); `Re = 1 > 0`. **Stability fails** (growing mode under `exp(t A)`). |
| `doubling_not_positive` | `Dp0 = [[0,1],[1,0]]` | `Dp0` Hermitian (`Dp0ᴴ = Dp0`), yet `D₋ D₊ = -I` and `D_dbl² = -I`. **Positive energy and real spectrum both fail**, while `D_dbl` is `J_dbl`-self-adjoint by `Ddbl_kreinSelfAdjoint`. |

Statement shapes (Lean):

* `jselfadj_not_real_spectrum`:
  `sharp J2 A1 = A1 ∧ ∃ μ v, v ≠ 0 ∧ A1.mulVec v = μ • v ∧ μ.im ≠ 0`.
* `jselfadj_not_stable`:
  `sharp J2 A2 = A2 ∧ ∃ μ v, v ≠ 0 ∧ A2.mulVec v = μ • v ∧ 0 < μ.re`.
* `doubling_not_positive`:
  `Dp0ᴴ = Dp0 ∧ (sharp J2 Dp0) * Dp0 = -1 ∧ Ddbl Dp0 (sharp J2 Dp0) * Ddbl Dp0 (sharp J2 Dp0) = -1`.

The `doubling_not_positive` example is the Section 2.3 demonstration in Lean: an
innocent Hermitian retarded block produces a Krein double whose
`D₋ D₊ = -I` (negative-definite energy form) and whose square is `-I` (spectrum
`{±i}`, entirely off the real axis), even though the doubling is `J_dbl`-self-
adjoint. The pathology is invisible to the `J`-self-adjointness audit and visible
only in `D₋ D₊`.

---

## 4. Guardrail compliance

* The file proves only the algebraic Layer-A identity plus explicit Layer-B
  counterexamples. It states **no** stability, unitarity, positive-energy, or
  real-spectrum theorem, in keeping with the locked non-overclaim rule.
* Krein doubling is **not** claimed to solve chirality or no-doubling; those are
  separate index/domain-wall/overlap/anomaly and determinant-branch-count
  questions outside this file's scope.
* Cf. Chernodub `arXiv:1701.07426` as a standing hazard warning that
  non-Hermitian / Krein-type operators can be self-consistent yet carry complex
  spectral branches; cited as a hazard, not as evidence the present operator is
  safe.

---

## 5. Build status

`PhysicsSM/Draft/KreinDoubleAndCounterexamples.lean` builds with the project
toolchain (Lean `v4.28.0`, Mathlib `v4.28.0`) with no errors, no warnings, and no
`sorry`. Axiom check on every theorem returns only
`[propext, Classical.choice, Quot.sound]`.

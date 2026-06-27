# Null-edge Krein physical-sector stability audit

**No-build strategy/audit deliverable. Generated 2026-06-26.**

Scope and method. This is a written audit. No Lean, Lake, pre-commit, or build
command was run. It reviews the Krein/Lorentzian-adjointness guardrails recorded
in `docs/CONVENTIONS.md` (section "Krein / Lorentzian adjointness"),
`docs/NULLSTRAND.md` ("Krein double guardrails"), and Section 20.6 of
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`, together with the
blocker ranking in Section 18.5 and the proof-chain entries in
`AgentTasks/null-edge-unified-mass-proof-chain.md`. Small matrix examples below
are worked by hand; they are illustrative, not build-checked.

Operating principle for the whole audit (the load-bearing distinction):

```text
Krein J-self-adjointness is an algebraic Lorentzian-hygiene identity.
Real spectrum, positivity, unitary evolution, absence of growing modes,
anomaly safety, and chirality are separate physical facts.
The first is locked. None of the second follow from it, and none may be
claimed by convention.
```

This restates the locked non-overclaim rule: `J`-self-adjointness is a necessary
Lorentzian audit, not a stability theorem.

---

## 1. The finite Krein double theorem, stated precisely

Work over a finite-dimensional complex inner-product space `V = C^n` with the
standard positive inner product `<u, v>` and conjugate-transpose `A^dagger`.
Fix a *fundamental symmetry* (signature operator) `J` on `V`.

Hypotheses on `J`:

```text
J = J^dagger         (J is Hermitian)
J = J^{-1}           (J is involutive), equivalently J J = I
```

These two give `J^dagger J = I`, so `J` is also unitary, with eigenvalues in
`{+1, -1}`. The associated *Krein (indefinite) form* is

```text
[u, v]_J := <u, J v>,
```

a nondegenerate Hermitian sesquilinear form of signature `(p, q)`, where
`p` and `q` are the multiplicities of `+1` and `-1` in `J`.

Krein adjoint (the "sharp"):

```text
A^sharp := J A^dagger J.
```

It is the adjoint with respect to `[-, -]_J`, i.e. `[A u, v]_J = [u, A^sharp v]_J`
for all `u, v`. Basic algebra (all provable finite identities):

```text
(A^sharp)^sharp = A
(A + B)^sharp = A^sharp + B^sharp
(A B)^sharp = B^sharp A^sharp
I^sharp = I
(c A)^sharp = conj(c) A^sharp.
```

`A` is *Krein self-adjoint* (`J`-self-adjoint) iff `A^sharp = A`, equivalently
`J A^dagger J = A`, equivalently `J A = (J A)^dagger` (i.e. `J A` is Hermitian).

**Retarded/advanced double.** Let `D_+` be the retarded null-edge symbol/operator
(any operator on `V`; no self-adjointness assumed). Define the advanced operator
as its Krein adjoint, and assemble the doubled operator and doubled symmetry on
`V (+) V`:

```text
D_- := D_+^sharp = J D_+^dagger J
D_dbl := [[0, D_-], [D_+, 0]]
J_dbl := [[J, 0], [0, J]].
```

**Theorem (finite Krein double).** With `J = J^dagger = J^{-1}` and
`D_- = D_+^sharp`, the doubled symmetry satisfies
`J_dbl = J_dbl^dagger = J_dbl^{-1}`, and the doubled operator is
`J_dbl`-self-adjoint:

```text
D_dbl^{sharp_dbl} = J_dbl D_dbl^dagger J_dbl = D_dbl.
```

*Proof sketch (block algebra).* `J_dbl` is block-diagonal with `J` in each block,
so `J_dbl^dagger = J_dbl` and `J_dbl J_dbl = I` follow blockwise. Compute

```text
D_dbl^dagger = [[0, D_+^dagger], [D_-^dagger, 0]],
J_dbl D_dbl^dagger J_dbl
  = [[0, J D_+^dagger J], [J D_-^dagger J, 0]]
  = [[0, D_+^sharp], [D_-^sharp, 0]].
```

Now `D_+^sharp = D_-` by definition, and
`D_-^sharp = (D_+^sharp)^sharp = D_+`. Hence the result equals
`[[0, D_-], [D_+, 0]] = D_dbl`. QED.

The theorem holds for *every* `D_+`. This is exactly why it is hygiene and not
stability: it constrains nothing about the spectrum of `D_+`, `D_-`, `D_dbl`, or
`D_- D_+`.

---

## 2. Counterexamples: `J`-self-adjointness does not give stability or real spectrum

All three examples use the indefinite metric

```text
J = diag(1, -1),   J = J^dagger = J^{-1},   signature (1, 1).
```

For real `2 x 2` matrices the `J`-self-adjointness condition `J A^T J = A`
reduces to: a matrix `A = [[a, b], [c, d]]` is `J`-self-adjoint iff `c = -b`,
i.e. `A = [[a, b], [-b, d]]`. Its eigenvalues are

```text
lambda = (a + d)/2 +/- sqrt((a - d)^2 - 4 b^2) / 2.
```

Whenever `(a - d)^2 < 4 b^2`, the eigenvalues are a complex-conjugate pair with
real part `(a + d)/2`. This single family already breaks every "stability" reading.

### 2.1 Nonreal spectrum (marginal)

```text
A1 = [[0, 1], [-1, 0]].
```

Check: `A1^dagger = A1^T = [[0, -1], [1, 0]]`,
`J A1^dagger J = [[0, 1], [-1, 0]] = A1`, so `A1^sharp = A1`. Yet its eigenvalues
are `+i` and `-i`: **nonreal**. A Hermitian operator can never do this; a merely
`J`-self-adjoint one can.

### 2.2 Growing mode (dynamical instability)

```text
A2 = [[1, 2], [-2, 1]].
```

Check: `A2^dagger = [[1, -2], [2, 1]]`, `J A2^dagger J = [[1, 2], [-2, 1]] = A2`,
so `A2^sharp = A2`. Eigenvalues are `1 +/- i sqrt(3)`: a conjugate pair with
**positive real part**. Under any first-order evolution `exp(t A2)` (or a symbol
whose dispersion is read off `A2`), the mode amplitude grows like `exp(t)`. So a
`J`-self-adjoint generator can be exponentially unstable.

### 2.3 The doubling itself guarantees nothing (directly on `D_dbl`)

Take a perfectly innocent *Hermitian* retarded block on the indefinite space:

```text
D_+ = [[0, 1], [1, 0]]   (Hermitian, real spectrum {+1, -1}).
```

Then `D_- = D_+^sharp = J D_+ J = [[0, -1], [-1, 0]]`, and

```text
D_- D_+ = [[-1, 0], [0, -1]] = -I.
```

The doubled operator `D_dbl = [[0, D_-], [D_+, 0]]` satisfies `D_dbl^2`
= diag(`D_- D_+`, `D_+ D_-`) = `-I`, so

```text
spec(D_dbl) = { +i, +i, -i, -i }   (purely imaginary).
```

By the Section 1 theorem `D_dbl` is `J_dbl`-self-adjoint, yet its spectrum is
entirely off the real axis. The pathology is invisible to the `J`-self-adjointness
audit and visible only in `D_- D_+`. **Moral: the indefinite "norm" of the Krein
form is not a Hilbert norm; `J`-self-adjointness organizes the spectrum into
real points and conjugate pairs, but does not exclude the conjugate pairs, the
growth, or the negative `D_- D_+`.**

---

## 3. Finite-box spectral audit protocol for the null-edge operator

This is the separate stability test mandated in Section 20.6. It is run *after*
the Section 1 algebraic identity is confirmed, never as a substitute for it. Work
on a flat decorated periodic patch (finite torus `Z_N^{d-1}` in space, or a
finite null-diamond box) so every operator below is a finite matrix and every
check is a finite computation.

Inputs: the retarded symbol `D_+(q) = sum_a C_a (exp(i q_a) - 1) / h` on the
chosen periodic patch, the Clifford generators `C_a = c(alpha^a)`, the
fundamental symmetry `J`, and a candidate physical-subspace projector `P`.

Protocol steps:

1. **`J` validity.** Confirm `J = J^dagger` and `J J = I` numerically on the box.
   If `J` is not a fundamental symmetry, nothing downstream is meaningful.

2. **Algebraic doubling check.** Form `D_-(q) = J D_+(q)^dagger J`,
   `D_dbl(q)`, `J_dbl`, and verify
   `J_dbl D_dbl(q)^dagger J_dbl - D_dbl(q) = 0` to machine precision for a grid
   of `q`. This is the numerical shadow of the Section 1 theorem and a sanity
   gate, not a result.

3. **Eigenvalue reality scan.** For each `q`, compute `spec(D_dbl(q))` (or
   `spec(D_+(q))`) and record `max_lambda |Im lambda|`. Classify each `q` as
   real-spectrum or nonreal-spectrum.

4. **Nonreal-pair structure.** For nonreal `q`, verify that nonreal eigenvalues
   occur in the pattern forced by `J`-self-adjointness: the spectrum is symmetric
   under complex conjugation (`lambda` and `conj(lambda)` both present with equal
   multiplicity). Record the eigenvalue `J`-signatures (the sign of
   `[v, v]_J` on the corresponding eigenvectors); pairs of opposite or null
   `J`-signature are the Krein-characteristic signal. Flag any nonreal eigenvalue
   not appearing in a conjugate pair as a numerical or modelling error.

5. **Growth/decay interpretation.** Fix the intended evolution law (which factor
   of `i` multiplies `D` in the equation of motion). Translate eigenvalues into
   temporal behavior under that law and tabulate, per `q`:
   stable (bounded), marginal (purely oscillatory), or growing (amplitude
   `exp(t Re ...) -> infinity`). Any growing mode at finite `q` is a candidate
   instability and must be tracked to step 7.

6. **`D_- D_+` positivity / sectoriality.** Compute the Hermitian part and the
   spectrum of `M(q) := D_-(q) D_+(q) = D_+(q)^sharp D_+(q)`. Record whether
   `M(q)` is positive semidefinite, positive definite away from the continuum
   point `q = 0`, sectorial (numerical range in a half-plane / cone avoiding a
   neighborhood of the negative axis), or indefinite. Note that `M = D_+^sharp D_+`
   is `J`-self-adjoint but **not** automatically positive (Section 2.3 gives
   `M = -I`); positivity here is precisely the missing stability content.

7. **Physical-subspace projection.** Search for a projector `P` (`P = P^2`)
   onto a subspace on which the restricted form `[-, -]_J` is positive definite
   (a maximal `J`-positive / uniformly positive subspace) and which is invariant
   (or approximately invariant) under `D_dbl(q)`. On `range(P)` recheck steps
   3-6: are the restricted eigenvalues real, the restricted `M` positive, and the
   restricted evolution non-growing? A consistent such `P` across the whole box
   is the only thing that earns the phrase "Hilbert-positive observable sector".

Outputs: per-`q` tables for steps 3-6, the `J`-signature ledger from step 4, and
either an explicit `P` with its restricted spectra (step 7) or a documented
failure to find one.

---

## 4. Acceptance and failure criteria for the Krein branch

Two layers must be reported separately; do not let the first stand in for the
second.

**Layer A (algebraic, hygiene). Acceptance:** `J = J^dagger = J^{-1}` and
`D_dbl` is `J_dbl`-self-adjoint (Section 1 theorem, plus its numerical shadow in
step 2). **Failure:** `J` is not a fundamental symmetry, or
`D_- != D_+^sharp`, or `D_dbl^{sharp_dbl} != D_dbl`. Layer-A failure means the
Lorentzian-adjointness bookkeeping is wrong and must be fixed before any physics
talk. Layer-A success is *necessary and cheap*; it certifies nothing about
stability.

**Layer B (spectral stability on the physical sector). Acceptance** requires all
of:

- a uniformly `J`-positive, (approximately) invariant physical subspace
  `range(P)` exists across the box;
- on `range(P)`, the spectrum is real, or nonreal eigenvalues are conjugate-paired
  *and* non-growing under the chosen evolution;
- on `range(P)`, `D_+^sharp D_+` is positive (or at least sectorial away from the
  continuum point);
- no persistent high-momentum massless poles survive after projection.

**Layer B failure** (any one suffices):

- persistent high-momentum massless poles in the physical sector;
- complex growing modes in the physical sector (positive-real-part eigenvalues
  under the chosen evolution that are not projected out);
- `D_+^sharp D_+` indefinite on every candidate physical subspace;
- no consistent projector `P` to a Hilbert-positive sector exists.

**False acceptance to forbid explicitly:** declaring stability, unitarity,
positive energy, real spectrum, or chirality on the strength of Layer A alone.
This is the banned sentence `Krein self-adjoint, therefore stable / unitary /
real spectrum`. Cross-reference: Chernodub `arXiv:1701.07426` is the standing
warning that non-Hermitian / Krein-type operators can be self-consistent and
still carry complex spectral branches; cite it as a hazard, not as evidence the
present operator is safe.

---

## 5. Smallest useful Lean theorem and smallest useful audit script

### 5.1 Smallest useful Lean theorem

The minimal kernel-checkable content is the Section 1 doubling identity over
concrete complex matrices. It needs only `Matrix`, conjugate transpose, and block
matrices; it does not need spectra, so it is a clean, isolatable target. (Stated
here for handoff; not build-checked, per the no-build scope.)

```lean
import Mathlib

open Matrix

namespace NullEdge.Krein

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Krein adjoint ("sharp") for a fundamental symmetry `J`. -/
def sharp (J A : Matrix n n ℂ) : Matrix n n ℂ := J * Aᴴ * J

/-- Doubled operator `[[0, D-], [D+, 0]]`. -/
def Ddbl (Dp Dm : Matrix n n ℂ) : Matrix (n ⊕ n) (n ⊕ n) ℂ :=
  Matrix.fromBlocks 0 Dm Dp 0

/-- Doubled fundamental symmetry `diag(J, J)`. -/
def Jdbl (J : Matrix n n ℂ) : Matrix (n ⊕ n) (n ⊕ n) ℂ :=
  Matrix.fromBlocks J 0 0 J

/-- Finite Krein double: with `J` Hermitian and involutive and
`D- = sharp J D+`, the doubled operator is `Jdbl`-self-adjoint. -/
theorem Ddbl_kreinSelfAdjoint
    (J Dp : Matrix n n ℂ) (hHerm : Jᴴ = J) (hInv : J * J = 1) :
    sharp (Jdbl J) (Ddbl Dp (sharp J Dp)) = Ddbl Dp (sharp J Dp) := by
  -- unfold `sharp`, `Ddbl`, `Jdbl`; push `conjTranspose` and `*` through
  -- `fromBlocks` (`fromBlocks_conjTranspose`, `fromBlocks_multiply`);
  -- reduce to the two scalar facts `J Jᴴ = 1` and
  -- `J (J Dpᴴ J)ᴴ J = Dp` using `hHerm`, `hInv`, and `conjTranspose` algebra.
  sorry
```

Why this is the right minimal target: it is the *only* part of the Krein branch
that is a theorem rather than a numerical audit, it is convention-faithful to the
locked statement (`J = J^dagger = J^{-1}`, `A^sharp = J A^dagger J`,
`D_- = D_+^sharp`), and it is small enough to isolate to Mathlib plus the few
definitions above. Useful companion one-liners worth adding next to it (each a
short finite identity): `sharp J (sharp J A) = A` under the same hypotheses,
antimultiplicativity `sharp J (A * B) = sharp J B * sharp J A`, and
`Jdbl`-involutivity `Jdbl J * Jdbl J = 1`. Do **not** attempt a Lean "stability"
theorem here: real spectrum / positivity are false in general (Section 2), so
there is no such theorem to state without extra hypotheses that belong to the
Layer-B audit, not to the doubling identity.

### 5.2 Smallest useful numerical/audit script

A short, self-contained checker for one fundamental symmetry `J` and one symbol
value `D_+` (extend by looping `D_+(q)` over the periodic box). It performs the
Layer-A shadow check (step 2) and the Layer-B diagnostics (steps 3, 5, 6). It is
an oracle/diagnostic, not a proof.

```python
import numpy as np

def krein_audit(J, Dp, tol=1e-10):
    J = np.asarray(J, dtype=complex)
    Dp = np.asarray(Dp, dtype=complex)
    # Layer A: J is a fundamental symmetry, and doubling is J-self-adjoint.
    assert np.allclose(J, J.conj().T, atol=tol), "J not Hermitian"
    assert np.allclose(J @ J, np.eye(J.shape[0]), atol=tol), "J not involutive"
    sharp = lambda A: J @ A.conj().T @ J
    Dm = sharp(Dp)
    Z = np.zeros_like(Dp)
    Ddbl = np.block([[Z, Dm], [Dp, Z]])
    Jdbl = np.block([[J, Z], [Z, J]])
    selfadj_residual = np.max(np.abs(Jdbl @ Ddbl.conj().T @ Jdbl - Ddbl))
    # Layer B diagnostics (NOT implied by Layer A).
    ev = np.linalg.eigvals(Ddbl)
    max_imag = float(np.max(np.abs(ev.imag)))          # 0 => real spectrum
    max_growth = float(np.max(ev.real))                # >0 => growing mode
    M = Dm @ Dp                                         # = sharp(Dp) @ Dp
    M_herm_eigs = np.linalg.eigvalsh((M + M.conj().T) / 2)
    M_min_herm = float(np.min(M_herm_eigs))            # >0 => positive sector
    return {
        "layerA_selfadjoint_residual": float(selfadj_residual),  # ~0 expected
        "spectrum": ev,
        "max_abs_imag_eig": max_imag,
        "max_real_eig_growth": max_growth,
        "DmDp_min_hermitian_eig": M_min_herm,
    }

# Section 2.3 demonstration: Layer A passes, Layer B does not.
J  = np.diag([1.0, -1.0]).astype(complex)
Dp = np.array([[0, 1], [1, 0]], dtype=complex)
print(krein_audit(J, Dp))
# layerA_selfadjoint_residual ~ 0  (J_dbl-self-adjoint, as the theorem says)
# spectrum ~ {+i, +i, -i, -i}      (nonreal: real-spectrum FAILS)
# DmDp_min_hermitian_eig ~ -1      (D- D+ = -I: positivity FAILS)
```

The script makes the audit's whole point operational: `layerA_*` is ~0 (hygiene
passes) while `max_abs_imag_eig` and `DmDp_min_hermitian_eig` simultaneously
report nonreal spectrum and lost positivity (stability fails). Reporting only the
first number is the overclaim this audit forbids.

---

## 6. Coordination with the determinant branch-count audit (no duplication)

The Krein branch and the determinant branch-count branch (T16 in the proof chain;
the "branch-count / no-doubling" audit rule in `docs/CONVENTIONS.md`) share the
single object `D_+(q)` but ask different questions, and this audit deliberately
stops at the boundary between them:

- **Branch-count audit owns** the zero set `{ q : det D_+(q) = 0 }` over the
  torus, the massless mass-shell condition `p(q)^2 = 0`, kernel dimensions, and
  the enumeration of real vs complex high-momentum branches. That is where
  no-doubling is decided. This audit does **not** recompute that zero set.
- **Krein audit owns** the `J`-pairing, signature, growth, and positive-subspace
  structure layered on top of whatever branches exist. Where branch-count says
  "here is a branch / kernel," the Krein audit asks "what is its `J`-signature,
  is its eigenvalue real or a conjugate pair, does it grow, and does it survive
  projection to a `J`-positive sector?"

Concretely, the two meet only at step 4 (nonreal-pair structure) and step 7
(physical projection): branch-count supplies the list of branches and kernels;
the Krein audit annotates that list with `J`-data and stability verdicts. Neither
result substitutes for the other. Retardedness rules out coefficient-zero
doublers but not determinant-level Clifford kernels (branch-count's job), and
`J`-self-adjointness rules out neither doublers nor instabilities (this audit's
repeated point).

---

## 7. Guardrail compliance check

- Does not claim Krein doubling solves chirality. Section 1 holds for every
  `D_+`; Sections 2 and 4 state chirality requires a separate
  index/domain-wall/overlap/anomaly mechanism, matching Section 20.6's minimal
  statement.
- Does not claim `J`-self-adjointness implies unitarity or positive energy.
  Section 2.3 exhibits `J`-self-adjoint operators with purely imaginary spectrum
  and `D_- D_+ = -I`; Section 4 forbids the banned inference explicitly.
- Coordinates with, but does not duplicate, the determinant branch-count audit
  (Section 6).
- Text hygiene: ASCII only, `dagger`/`sharp` spelled out in prose, Lean
  escape-hatch placeholder left only inside the executable Lean code block as a
  handoff marker.

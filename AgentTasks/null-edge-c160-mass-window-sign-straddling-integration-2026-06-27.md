# C160 — Mass-window and sign-straddling theorem package

Gate C1 / PhysicsSM null-edge program. Companion notes for the formal artifact
`RequestProject/C160.lean` (builds clean under Lean 4 + Mathlib, no `s o r r y`, only
the standard a x i o ms `propext, Classical.choice, Quot.sound`).

Operator architecture under discussion (from `ROUND_CONTEXT.md`):

```text
H_ne    = Gamma_K (D_ne + W_branch - m0 R)
T_br    = sign(H_ne)
D_ov_ne = rho (1 + Gamma_K T_br)
```

This job formalizes the C138 sharpening: *nonzero `Odd_J(W_branch)` is not
enough*. We give the finite-dimensional/linear-algebraic core, with the heavy
analytic functional calculus deliberately replaced by faithful finite
surrogates, and we flag exactly which analytic lemmas are missing to upgrade to
the literal matrix-sign statements.

---

## 0. Modelling dictionary (finite surrogates for `sign(H)`)

The matrix sign function `sign(H) = P₊ − P₋` (spectral projection split) is the
physical object, but its analytic construction is not what is load-bearing for
C160. We use the standard finite surrogates for its *qualitative content*:

| Physical statement about `sign(H)`           | Finite surrogate (proved in Lean)                      |
|----------------------------------------------|--------------------------------------------------------|
| sector keeps a definite sign of `sign(H)`    | sign of sector mass `sectorSign m`, stable below gap   |
| `sign(H)` carries odd (J-anticommuting) content | kernel **indefinite**: `qform` takes both signs; `det H < 0` |
| `sign(H) = ±I`, odd content killed           | kernel **definite**: `qform` one-signed                |

An indefinite Hermitian 2×2 block has eigenvalues of opposite sign, hence its
sign matrix has both `+1` and `−1` and a nonzero odd part; a definite block has
`sign(H) = ±I` with zero odd part. So the surrogates are tight.

The distinction **origin finite seed vs. physical branch-line release** is
preserved: the off-diagonal `a` is the *finite odd seed* (the `Odd_J(W_branch)`
content of the Hamiltonian); whether it survives into `sign(H)` (the branch
release) is exactly the indefinite-vs-definite dichotomy below. A nonzero seed
is necessary but not sufficient for release.

---

## 1. Mass-window theorem (sector-sign stability)

**Theorem (scalar, `mass_window_scalar`).** Let `δ > 0`. If a sector mass `m`
clears the margin, `δ ≤ |m|`, and a kinetic/J-even perturbation `v` is strictly
sub-margin, `|v| < δ`, then `sectorSign (m + v) = sectorSign m`.

**Theorem (diagonal, `mass_window_diag`).** For finitely many sectors
`i : Fin n` with masses `m i` and perturbations `v i`, if `δ > 0`,
`δ ≤ |m i|` for all `i`, and `|v i| < δ` for all `i`, then
`sectorSign (m i + v i) = sectorSign (m i)` for every `i`.

This is the finite-matrix statement in the simultaneously-diagonalizable
(commuting) regime, where `sign(H) = sign(diag m)` acts sector-by-sector. It is
the certificate that "a sector mass window with margin `δ` and kinetic/even
perturbation norm smaller than the margin preserves the sector signs of
`sign(H)`."

> The condition is genuinely the mass-window margin condition; it is **not**
> weakened to "`Odd_J(W_branch) ≠ 0`".

---

## 2. Sign-straddling / odd-dominance theorem

Chiral block model: grading `J = diag(1, −1)` (`Jgr`, with `J² = 1`,
`Jgr_mul_Jgr`). A symmetric kernel `Hsym p a q = [[p, a], [a, q]]` splits as

```text
H        = H_even        + H_odd
H_even   = diag(p, q)    commutes with J        (diag_commutesJ)
H_odd    = [[0,a],[a,0]] anticommutes with J    (offDiag_anticommutesJ)
```

with `evenPart`, `oddPart`, and `even_add_odd : evenPart A + oddPart A = A`. For
`Hsym`: `evenPart_Hsym`, `oddPart_Hsym`, and
`oddPart_Hsym_ne_zero_iff : oddPart (Hsym p a q) ≠ 0 ↔ a ≠ 0`.

**Theorem (sign-straddling, indefinite form, `straddling_indefinite`).** If the
J-even background is sub-gap, `|p| < |a|` and `|q| < |a|` (even part smaller than
the odd gap `|a|`), then

```text
qform (Hsym p a q) (1, 1) * qform (Hsym p a q) (1, −1) < 0,
```

i.e. the quadratic form is strictly positive on one test vector and strictly
negative on another — the kernel is indefinite, its eigenvalues straddle `0`, so
`sign(H)` retains nonzero odd content.

**Theorem (determinant form, `straddling_det_neg`).** Under the same hypotheses,
`det (Hsym p a q) < 0` — the cleanest finite witness that the two eigenvalues
straddle `0`.

**Theorem (non-vacuity, `straddling_oddSeed_ne_zero`).** The sub-gap hypotheses
force `a ≠ 0`: the odd seed is automatically present, so the conclusion is not
vacuous.

**Proof plan / why this is the right hypothesis.** The product equals
`(p+q)² − 4a²`; from `|p|,|q| < |a|` one gets `|p+q| < 2|a|`, hence the product
is negative. For the determinant, `det = pq − a²` and `|pq| = |p||q| < a²`. Both
are discharged by `nlinarith` after expanding `qform`/`det` on the explicit 2×2.

**Upgrade to the literal `sign(H)` statement** ("gapped-homotopic to
`sign(H_odd)`, same sector signature/odd content") requires the analytic lemmas
in §5; the finite core here supplies the algebraic invariant (signature `(1,1)`)
that homotopy invariance would preserve along `H_odd + t·H_even`, `t ∈ [0,1]`,
since `det(H_odd + t·H_even) < 0` for all such `t` by the same bound — no
eigenvalue crosses `0`.

> The hypothesis is anticommutation of `H_odd` with `J` **plus** an explicit
> sub-gap (sign-straddling) margin on `H_even`. It is **not** weakened to mere
> `Odd_J(W_branch) ≠ 0`.

---

## 3. Counterexample / no-go note (C138)

**Theorem (even-dominant kills odd content, `evenDominant_posDef`).** For
`H = Hsym M a M` with equal diagonal `M` and `|a| < M`, the kernel is positive
definite: `0 < qform (Hsym M a M) x` for every `x ≠ 0`. Hence `sign(H) = +I` and
its odd part is `0`.

**Theorem (packaged no-go, `c138_nonzero_seed_insufficient`).** There exist
`M, a` (explicitly `M = 1`, `a = 1/2`) with

```text
a ≠ 0  ∧  oddPart (Hsym M a M) ≠ 0  ∧  (∀ x ≠ 0, 0 < qform (Hsym M a M) x).
```

That is: a **nonzero odd seed** in the Hamiltonian whose `sign(H)` nonetheless
has **zero odd content**, because a dominant positive J-even background makes the
kernel definite. This is the precise formal statement that *nonzero
`Odd_J(W_branch)` alone does not imply nonzero `Odd_J(sign(H))`*.

---

## 4. Lean-friendly API (as realized in `RequestProject/C160.lean`)

```text
namespace C160

-- NullEdgeMassWindow
def      sectorSign (m : ℝ) : ℝ
theorem  mass_window_scalar (δ m v : ℝ) (hδ : 0 < δ) (hm : δ ≤ |m|) (hv : |v| < δ) :
           sectorSign (m + v) = sectorSign m
theorem  mass_window_diag  {n} (δ) (m v : Fin n → ℝ) (hδ) (hm) (hv) :
           ∀ i, sectorSign (m i + v i) = sectorSign (m i)

-- SignStraddlingKernel
def      Jgr : Matrix (Fin 2) (Fin 2) ℝ                 -- grading diag(1,-1)
def      Hsym (p a q : ℝ) : Matrix (Fin 2) (Fin 2) ℝ    -- [[p,a],[a,q]]
def      CommutesJ / AntiCommutesJ (A) : Prop
def      evenPart / oddPart (A) : Matrix (Fin 2) (Fin 2) ℝ
def      qform (H) (x) : ℝ                               -- xᵀ H x
theorem  Jgr_mul_Jgr / even_add_odd / diag_commutesJ / offDiag_anticommutesJ
theorem  evenPart_Hsym / oddPart_Hsym / oddPart_Hsym_ne_zero_iff
theorem  straddling_indefinite / straddling_det_neg / straddling_oddSeed_ne_zero

-- SectorSignatureStability (counterexample side)
theorem  evenDominant_posDef
theorem  c138_nonzero_seed_insufficient

end C160
```

Suggested structure-level wrappers for downstream draft modules (optional sugar
over the above), if you want bundled certificates rather than loose hypotheses:

```text
structure NullEdgeMassWindow (δ : ℝ) (m : Fin n → ℝ) where
  δ_pos   : 0 < δ
  cleared : ∀ i, δ ≤ |m i|

structure SignStraddlingKernel (p a q : ℝ) where
  even_sub_gap_p : |p| < |a|
  even_sub_gap_q : |q| < |a|
-- carries straddling_det_neg / straddling_indefinite as derived facts

structure SectorSignatureStability (δ : ℝ) (m v : Fin n → ℝ) where
  window  : NullEdgeMassWindow δ m
  small_v : ∀ i, |v i| < δ
-- conclusion: ∀ i, sectorSign (m i + v i) = sectorSign (m i)
```

---

## 5. Missing analytic lemmas (to reach literal `sign(H)` statements)

The finite core above is complete and kernel-checked. To replace the surrogates
(`sectorSign`, `det < 0`, `qform`-definiteness) by the literal matrix sign
function, the following are *not* currently available in the project and would
need to be imported or built:

1. **Hermitian matrix sign function.** Definition `sign(H) = P₊ − P₋` for
   invertible Hermitian `H` via spectral projections, with `sign(H)² = I` and
   `oddPart (sign H) ≠ 0 ↔` signature is mixed.
2. **Signature homotopy invariance.** Along a path of *invertible* Hermitian
   matrices the signature (number of negative eigenvalues) is constant — i.e. no
   eigenvalue crosses `0` when `‖V‖ < gap`. This is what turns
   `straddling_det_neg` into "`sign(H)` gapped-homotopic to `sign(H_odd)`".
3. **Operator-norm spectral perturbation bound.** `‖V‖ < δ ⟹ spec(H+V) ⊂
   spec(H) + (−δ, δ)` (Weyl / Bauer–Fike). This converts a sub-margin
   *operator-norm* bound into the per-sector mass-window bound used in §1.

These three are the genuine blockers; everything they would be glued to is
proved here. (1)–(2) are the natural content of a follow-up job; (3) is a
standard but currently-absent Mathlib perturbation lemma.

---

## 6. Integration advice for Gate C1 docs and Lean draft modules

- **Use C160 as the "mass-window / sign-straddling certificate" node** in the
  target chain of `ROUND_CONTEXT.md` (`sector-signature match → mass-window /
  sign-straddling certificate → uniformly gapped homotopy`). The Lean names
  `mass_window_diag`, `straddling_det_neg`, `straddling_indefinite` are the
  certificate-producing lemmas to cite.
- **Keep the seed/release distinction explicit in docs.** Reference
  `oddPart_Hsym_ne_zero_iff` (seed nonzero) and `c138_nonzero_seed_insufficient`
  (seed nonzero yet release trivial) side by side wherever the doctrine
  "finite seed ≠ physical release" is asserted.
- **Feed §5 item (2) into the C159/C161 chain.** The "uniformly gapped Hermitian
  homotopy" node and the C161 bad-sector inverse-gap theorem both consume
  signature homotopy invariance; C160's `straddling_det_neg` is the `t = 0` and
  `t = 1` endpoint witness, with the path bound `det(H_odd + t·H_even) < 0`
  available from the same sub-gap inequality.
- **Do not over-claim.** C160 proves only the algebraic dichotomy
  (definite ⇒ odd content dies; sub-gap indefinite ⇒ odd content survives). It
  does **not** establish anomaly/index, locality/control, or the literal
  `sign(H)` continuity; those remain separate certificates (C159/C161 and the §5
  imports).
- **Module placement.** `RequestProject/C160.lean` is part of the
  `RequestProject` library glob and builds by default. Downstream draft modules
  can `import RequestProject.C160` and open `C160`.

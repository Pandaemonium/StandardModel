# Aristotle statement-design + proof job: the finite Matthews-Salam / Berezin identity (QMF3)

You are formalizing a single FINITE identity in combinatorial algebra - no
analysis, no continuum, no physics needed to do the work. This is the
fermionic-determinant core of a lattice-QCD mass-formalism program, but the task
is pure Mathlib. Deliverable: a kernel-checked proof of the Matthews-Salam
identity, with the cleanest formalization of the finite Grassmann/Berezin setup
you can find. This is BOTH a statement-design job (choose the best model) and a
proof job (close it).

Formatting: ASCII only, LF. Spaced escape-hatch tokens in prose (`s o r r y`).

BUILD BUDGET: run `lake env lean Qmf3Berezin/MatthewsSalam.lean` FIRST. Do not
start with a broad `lake build`.

## The identity

For `M : Matrix (Fin n) (Fin n) R` over a characteristic-zero commutative ring
`R` (a `Q`-algebra, so factorial inverses are exact):

    Berezin integral over 2n Grassmann generators of  exp(- thetabar M theta)
        =  det M

where `theta_0..theta_{n-1}`, `thetabar_0..thetabar_{n-1}` are the Grassmann
generators and `thetabar M theta = sum_{i,j} thetabar_i (M i j) theta_j`.

## The convention is ORACLE-PINNED - do not drift from it

An independent from-scratch Grassmann computation (in
`Scripts/oracle/validate_berezin.py` in the parent project, not shipped here but
summarized below) was checked against the Leibniz determinant for `n = 1,2,3,4`,
confirmed identical, and confirmed sign-SENSITIVE. The pinned convention, which
the attached scaffold `Qmf3Berezin/MatthewsSalam.lean` already encodes:

* generators `Fin (2*n)`; `theta_i -> 2*i`, `thetabar_i -> 2*i+1`;
* monomials are `Finset (Fin (2*n))` = ascending product of their elements;
* multiplication sign `shuffleSign s t = (-1)^#{(a,b): a in s, b in t, b < a}`
  for disjoint `s,t`, and `0` when they overlap;
* bilinear term `(i,j)` is `thetabar_i` (gen `2i+1`) LEFT of `theta_j` (gen
  `2j`);
* `exp(-S) = sum_{p=0}^{2n} (-S)^p / p!` (truncates);
* Berezin integral = coefficient of the top monomial `Finset.univ`.

The non-negotiable regression anchors (must hold in your final definitions):
`n = 1`: `berezinGaussian !![c] = c`.
`n = 2`: `berezinGaussian !![a, b; c, d] = a*d - b*c`  (NOT `b*c - a*d`).

## Your task

1. Take the attached scaffold's model (route (a), self-contained
   `GrassmannElem k R := Finset (Fin k) -> R` with `gmul`/`gexp`/`bilinear`/
   `berezinGaussian` as given), OR replace it with a `Mathlib.ExteriorAlgebra`
   model (route (b)) if you find that genuinely cleaner. If you change the
   definitions, you MUST preserve the two regression anchors above and say why
   the new convention still matches.
2. Prove `berezinGaussian_eq_det : berezinGaussian M = M.det`. Mathematical
   route: the only nonzero contributions to the top monomial `Finset.univ` come
   from degree-`n` terms of `exp(-S)` in which the `n` chosen bilinear factors
   use each `thetabar_i` exactly once and each `theta_j` exactly once - i.e. a
   permutation `sigma : Perm (Fin n)` with `j = sigma i`. The `1/n!` from `exp`
   cancels the `n!` orderings of the `n` chosen factors. Track the product of
   `shuffleSign`s against `Equiv.Perm.sign sigma`, then close with
   `Matrix.det_apply'` (`det M = sum over Perm of (sign sigma) * prod_i M (sigma i) i`)
   - mind whether your bijection yields `M (sigma i) i` or `M i (sigma i)` and
   transpose-adjust via `Matrix.det_transpose` if needed (this does not change
   the `n=2` anchor `a*d - b*c`, which is symmetric under transpose).
3. Add the `n = 1` and `n = 2` regression lemmas as explicit `example`s or
   theorems (proved WITHOUT `decide`/`native_decide` - `simp`/`norm_num`/`Fin`
   case-splitting is fine).

## If you cannot fully close it

Leave the single documented `s o r r y` on `berezinGaussian_eq_det` and return:
the model you settled on, the permutation bijection lemma (stated, ideally
proved), the sign-tracking lemma relating `shuffleSign` products to
`Equiv.Perm.sign`, and a precise description of the remaining gap. A partial
result with the bijection and sign lemmas in place is high value.

## Guardrails

- Do NOT weaken the statement (e.g. do not restrict to symmetric/diagonal `M`,
  do not drop to `n <= 2`). The theorem is for arbitrary finite `n`.
- No `a x i o m` / `o p a q u e` / `n a t i v e _ d e c i d e` / `s o r r y` in
  the final proof (one documented `s o r r y` allowed only if you cannot close
  it). `decide` is acceptable only inside a fixed-`n` regression `example`, not
  in the general theorem.
- If the identity as stated is false under the pinned convention (it is NOT -
  the oracle verified `n=1..4`), you would report a counterexample; but the
  oracle strongly indicates it is true, so a false result means a definition
  mismatch to debug against the `n=2` anchor first.

## Output format

1. Verdict: proved / partial (with the exact remaining gap) / definitional-issue.
2. The complete `Qmf3Berezin/MatthewsSalam.lean`.
3. If proved: confirm `#print axioms Qmf3Berezin.berezinGaussian_eq_det` is
   `[propext, Classical.choice, Quot.sound]` only, and that
   `lake env lean Qmf3Berezin/MatthewsSalam.lean` is clean.
4. A short prose account of the permutation bijection and the sign bookkeeping,
   so a reviewer can check the idea independent of the Lean.

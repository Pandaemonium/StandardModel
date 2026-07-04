# Gate F2.1 pre-registration freeze: the democratic-spurion Koide orbit test

Status: FROZEN pre-registration, 2026-07-03 (claude), per Codex review
feedback on the Measure Problem next-steps ordering. This document exists
because F2.0 (the fully-invariant-potential formulation) was killed by proof
the same day it was proposed
(`AgentTasks/nerd-gate-f2-koide-preregistration-2026-07-03.md`,
`PhysicsSM/Draft/NullEdge/GateF2/InvariantPotentialNogo.lean`), and Round 8's
own lesson (Attack 2.1, the WW episode) is that post-hoc adjustment of a test
after seeing partial results is exactly the failure mode this program exists
to avoid. **No computation for F2.1 has been run as of this freeze.** The
freeze must exist, unaltered, before any symbolic or numeric work on F2.1
begins. Any change to this document after computation starts invalidates the
gate; a revised test is a new gate (F2.2) with its own freeze.

## 1. Family (the coupling family - frozen)

Configuration space: `X in Herm_3(R)` (equivalently `Sym_3(R)`), the space of
`3 x 3` real symmetric matrices, coordinatized by its six independent entries
`X_ij` (`i <= j`) in the fixed **generation basis** `e_1, e_2, e_3` (the basis
in which the three charged-lepton flavors are the coordinate axes). The
democratic direction is the fixed rank-one projector

```text
d := (1/3) J,   J = all-ones 3x3 matrix,   d^2 = d,   tr(d) = 1,
```

which is NOT diagonal in the generation basis (its distinguished eigenvector
is `(1,1,1)/sqrt(3)`, eigenvalue `1`; the orthogonal complement has
eigenvalue `0`). `d` is the fixed external "spurion" - the only object
allowed to break the full conjugation invariance that killed F2.0.

The frozen potential family, six real couplings `(a, b, c, e1, e2, e3)`:

```text
V(X) = a * tr(X^2) + b * (tr X)^2 + c * det(X)
     + e1 * tr(X d) * tr(X) + e2 * tr(X d)^2 + e3 * tr(X^2 d).
```

`tr(X^2)`, `(tr X)^2`, `det(X)` are the three fully invariant polynomials
(the ones F2.0 exhausted); `tr(X d)`, `tr(X d)^2`, `tr(X^2 d)` are the three
lowest-degree polynomials built from `X` and ONE insertion of the spurion
`d`, up to total degree matching `det(X)` (degree 3). This is the complete
list of `O(3)`-scalar polynomials in `X` and `d` through degree 3 with at
most one `d` insertion; higher-degree or multi-`d` terms are explicitly
OUT OF SCOPE for F2.1 (a later gate, if needed, would be F2.2). No other
terms, no `d`-dependent coefficients, no explicit `mu` or `delta` dependence
in `V` itself - `V` is a fixed polynomial functional of `X` alone.

## 2. The Koide locus (frozen parametrization)

```text
X(mu, delta) := mu * ( I + sqrt(2) * F(delta) ),
F(delta) := diag( cos(delta), cos(delta + 2*pi/3), cos(delta + 4*pi/3) ),
mu in R, mu > 0,   delta in [0, 2*pi).
```

This is diagonal in the generation basis by construction (matching Round 7's
`sqrt(m_i) = mu(1 + sqrt(2) cos(delta + 2*pi*i/3))` parametrization exactly,
with `i = 0, 1, 2`). `X(mu,delta)` sits on the Koide 45-degree cone for every
`(mu, delta)`: `(tr X)^2 = (3/2) tr(X^2)` identically (the two locked
invariants), with `delta` the free cubic-norm modulus. This is an ALGEBRAIC
locus, defined without reference to the observed lepton masses; the physical
point corresponds to one specific `(mu_phys, delta_phys)` with
`delta_phys ~ 0.2222` (Round 7), which enters NOWHERE in this section.

## 3. Criticality (frozen - this is the crux of the gate)

`X_0 = X(mu_0, delta_0)` is a critical point of `V` iff `dV(X_0) = 0` as a
linear functional on the tangent space `Sym_3(R)`, i.e.
`d/dX_ij [V(X)]|_{X = X_0} = 0` for every independent entry `X_ij` (`i<=j`)
of the ambient `6`-dimensional space - full stationarity in ALL six
directions, not merely along the two-parameter locus itself. (This matches
the F2.0 no-go's own criticality notion, restricted here to points that
happen to lie on the Koide locus, with `d` now permitted to appear in `V`.)

**THE FROZEN TEST.** F2.1 asks whether `X(mu,delta)` is critical for
**every** `(mu, delta)` with `mu > 0` - i.e., whether the ENTIRE two-parameter
Koide locus is a critical submanifold of `V`, not just the single physical
point. This is the non-negotiable methodological core: demanding criticality
only at the one physical `(mu_phys, delta_phys)` would be curve-fitting (six
free couplings can always be tuned to kill six gradient components at one
point; that proves nothing). Demanding it identically in `(mu, delta)` forces
the gradient components, expanded as polynomials in `mu` and trigonometric
polynomials in `delta`, to vanish COEFFICIENT-BY-COEFFICIENT - a genuine,
overdetermined linear system in `(a,b,c,e1,e2,e3)` with no reference to the
measured masses anywhere in its statement.

## 4. Allowed couplings and the computation to be run (frozen, not yet executed)

Expand `dV(X(mu,delta))_ij = 0` for each independent `(i,j)`, `i<=j` (six
equations), as an identity in `mu, delta`. Because every term in `V` is
homogeneous of degree 2 or 3 in `X` (hence degree 2 or 3 in `mu`), each
equation splits into a `mu^2`-coefficient (linear in `a,b,e1,e2,e3`) and a
`mu^3`-coefficient (proportional to `c` alone), and the `mu^2` part further
splits by Fourier degree in `delta` (functions of `cos(delta+2*pi k/3)` and
`sin(delta+2*pi k/3)` decompose into at most a few independent trigonometric
harmonics). This produces a **finite linear system** `M * (a,b,c,e1,e2,e3)^T
= 0` with rational-in-nothing (pure-number) coefficient matrix `M` (its
entries depend only on the fixed numbers `sqrt(2)`, `2*pi/3`, and the
combinatorics of the trace/determinant expansions - never on `mu`, `delta`,
or the physical masses). Computing `M` and its null space `S = ker(M)
subset R^6` is the entire content of the F2.1 run. Allowed tools: exact
symbolic computation (CAS or hand derivation); a numerical eigenvalue/rank
computation on `M` MAY be used as a cross-check but the reported result must
be the exact rational/algebraic null space, not a floating-point
approximation.

## 5. Success criterion (frozen)

**F2.1 SUCCEEDS** iff `dim(S) >= 1`, i.e. the null space contains a nonzero
coupling vector `(a,b,c,e1,e2,e3) != 0`. In that case:

- report `S` explicitly (an exact basis, e.g. as vectors over `Q` or a
  simple algebraic extension);
- "an open set of couplings" means: the set of couplings for which the whole
  locus is critical is exactly `S` (a linear subspace), and every point of
  `S` other than the origin gives a genuine potential with the property -
  so "open" is witnessed by `S \ {0}` being a dense open subset of `S`
  itself (in the subspace topology), which is automatic once `dim(S) >= 1`;
  no separate genericity argument is required or permitted;
- as an independent (non-tunable) cross-check ONLY, verify that plugging in
  a generic point of `S` and evaluating at the physical `(mu_phys,
  delta_phys)` reproduces `dV = 0` there too (this must hold automatically
  if the derivation above is correct - it is a consistency check on the
  algebra, not a fitting step, and a mismatch means the derivation has an
  error, not that the couplings should be adjusted).

## 6. Kill condition (frozen)

**F2.1 DIES** iff `S = {0}` - the only coupling vector making the entire
Koide locus critical is the trivial potential `V = 0`. In that case: file the
null exactly as F2.0 was filed (update the disposition section of
`nerd-gate-f2-koide-preregistration-2026-07-03.md`); R4-2's confidence
(Round 7/8) takes a further honest decrement (the potential-selection
mechanism class - invariant plus one spurion insertion, degree <= 3 - would
then be excluded, not merely the fully-invariant case); the Koide relation
returns fully to the coincidence bin pending a genuinely different mechanism
class (e.g. a non-potential selection principle, or a spurion-dependent
KINETIC term rather than a potential term - out of scope here and requiring
its own fresh pre-registration).

A partial result - e.g. `dim(S) >= 1` but the physical `delta_phys` requires
a coupling vector outside `S`, or `S` exists but forces an UNphysical sign
pattern making all three `X_0` entries fail to be positive (recall
`X_0 = sqrt(m)`, so the eigenvalues of `X(mu,delta)` must be positive for any
physically relevant point, though this positivity is NOT part of the
algebraic success criterion above and must be checked and reported
separately) - is recorded as SUCCESS-WITH-CAVEAT and reported in full, not
silently upgraded or downgraded.

## 7. Forbidden after-the-fact edits (frozen)

Once this document is committed, the following may NOT be changed in light
of computed results, under any framing:

- the coupling family (section 1) - no terms added, removed, or reweighted;
- the criticality notion (section 3) - in particular, NEVER relax "for every
  `(mu,delta)`" to "at the physical point only," even if the full-locus
  system turns out to have `S = {0}`;
- the success/kill criteria (sections 5-6);
- the locus parametrization (section 2).

If the computation reveals that this family is too small (kill) or too
unconstrained (e.g. `dim(S) = 6`, i.e. EVERY potential in the family works,
which would itself be suspicious and must be checked for a parametrization
error before being reported as a positive result), that is grounds for a
NEW, separately timestamped gate (F2.2, F2.3, ...) with its own frozen family
and criteria - never a retroactive edit of this one. The Brannen phase
observation (`delta ~ 2/9`) remains quarantined in the recorded-coincidence
file per the parent document and plays no role anywhere in this freeze.

## 8. Relation to the Round 8 scheme clause

This freeze concerns only the ALGEBRAIC question (does an invariant-plus-one-
spurion potential admit the Koide locus as a critical submanifold). It is
scheme-independent by construction: nothing above refers to pole masses,
running masses, or any energy scale. If F2.1 succeeds, the Round 8 scheme
clause (Attack 1.6) still applies IN FULL before any physical claim is made:
a scale `Lambda_F` and a survival mechanism to the pole-mass point (most
plausibly an infrared fixed point of the mass-matrix RG flow) must be
identified separately. That is explicitly downstream of, and not addressed
by, this freeze.

## 9. Status

Frozen, not executed. Next action: run the section-4 computation exactly as
specified, report `M` and `S` in full (success or kill), and update the
disposition sections of both this document and the parent F2 pre-registration
note. No numbers have been computed or previewed in this document.

# Aristotle strategy job: the Q1 cut-plaquette conjugation (N3) - the actual RP-LINK content

You are acting as a research strategist for a Lean 4 formalization
project, not primarily as a prover. A short, correct Lean lemma is
welcome if you find one, but the deliverable is a written analysis: what
is true, why, and how it would be proved.

Formatting: ASCII only, LF line endings. Spaced escape-hatch tokens in
prose (`s o r r y`, `a x i o m`).

## Standalone context

We are formalizing Osterwalder-Seiler link-reflection positivity for the
Wilson lattice gauge action, finite gauge group `G`. A "plaquette" is a
closed 4-step walk on an oriented lattice: `base -> v1 -> v2 -> v3 ->
base`, with steps typed `fwd e` (traverse edge `e` forward, contributing
`U e`) or `rev e` (traverse `e` backward, contributing `(U e)^-1`). The
standard convention (matching our project's concrete rectangular-lattice
plaquettes) is `[step0 = fwd e0, step1 = fwd e1, step2 = rev e2, step3 =
rev e3]` (right, up, left-reversed, down-reversed), giving holonomy

```
p.hol(U) = U(e0) * U(e1) * U(e2)^-1 * U(e3)^-1
```

(product taken in step order, left to right, standard group
multiplication).

We have a general "doubled lattice" construction: given any base lattice
`L0`, glue two copies - a `true` copy with `L0`'s own edge orientation,
and a `false` copy with REVERSED orientation - into one lattice with a
canonical reflection map that flips the copy label and leaves the edge
index alone (`reflectE (side, e) = (!side, e)`). Call the two copies'
link-field restrictions `a` (true side) and `b` (false side); both are
functions `L0.E -> G`.

Lifting the plaquette `p0` (defined on `L0` via edges `e0,e1,e2,e3`) to
the `true` copy is direct (same orientation, so `fwd`/`rev` tags are
unchanged, only the edge label gains `true`). The GENUINE mirror image of
this lifted plaquette, under the general "mirror a typed walk" operation
(reverse the STEP ORDER, and apply a per-step "reflect" operation that
changes the copy label of each step's edge from `true` to `false` but
does NOT swap `fwd` and `rev` tags - this asymmetry, relative to the
ORDINARY walk-reversal operation which DOES swap `fwd`/`rev`, is exactly
the point of interest below), has, after unwinding the definitions, the
following four steps in order:

```
[rev(false, e3), rev(false, e2), fwd(false, e1), fwd(false, e0)]
```

so its holonomy against the negative-side restriction `b` is

```
mirror_hol(b) = b(e3)^-1 * b(e2)^-1 * b(e1) * b(e0)
```

Compare this to what the ORDINARY (fwd/rev-swapping) reversal of `p0`
would give, which is the textbook "traverse the same loop backward"
holonomy and is definitionally `p0.hol(b)^-1`:

```
p0.hol(b)^-1 = b(e3) * b(e2) * b(e1)^-1 * b(e0)^-1
```

**The open question (this is node "N3" of our project's lemma DAG, the
actual mathematical content of link-reflection positivity - everything
proved so far is either upstream algebra or a degenerate zero-cut case
that does not touch this question):** `mirror_hol(b)` is neither equal
to `p0.hol(b)` nor to `p0.hol(b)^-1` as raw group elements in general (we
believe this, but have not exhaustively checked). For the Wilson weight
`w(g) := exp(beta * Re(chi_rho(g)))` (built from the REAL part of the
trace/character of a unitary representation `rho`) to satisfy
`w(mirror_hol(b)) = w(p0.hol(b))` - which is EXACTLY what our project
needs to complete the reflection-positivity theorem for a genuine
cut-plaquette instance (as opposed to the zero-cut case we have already
proved, which is degenerate and does not require this identity) - it
suffices that `Re(chi_rho(mirror_hol(b))) = Re(chi_rho(p0.hol(b)))` for
ALL unitary `rho` and ALL `b`, i.e. that `mirror_hol(b)` and `p0.hol(b)`
lie in the same conjugacy class, OR are related in a way that trace
alone (not the raw group element) sees as equal.

## Questions

1. Super-stretch primary deliverable: is `mirror_hol(b)` ALWAYS conjugate
   to `p0.hol(b)` (or to `p0.hol(b)^-1` - either would suffice for the
   real-part trace to agree, given trace is conjugation-invariant and,
   for unitary rho, `chi(g^-1) = conj(chi(g))` so `Re chi(g^-1) = Re
   chi(g)`), for an ARBITRARY finite (or more generally arbitrary) group
   `G` and arbitrary `b(e0), b(e1), b(e2), b(e3) in G`? If yes: exhibit
   the EXPLICIT conjugating element (as a word in `b(e0)..b(e3)`) and
   prove the conjugation identity as a clean group-theory lemma, stated
   and proved abstractly (four group elements, not lattice-specific).
   Then explain how this becomes a Lean theorem
   `mirror_hol_conj_p0_hol : exists x, mirror_hol b = x * p0_hol b * x⁻¹`
   or the corresponding statement with `p0_hol b⁻¹` on the right, whichever
   is actually true.
2. If NOT always conjugate: give an explicit counterexample (concrete
   finite group - S3 or a small dihedral/quaternion group is fine -
   and concrete `b(e0)..b(e3)` values) where `mirror_hol(b)` is NOT
   conjugate to `p0.hol(b)` or `p0.hol(b)^-1`. Then determine: is it
   still true that `Re chi(mirror_hol(b)) = Re chi(p0.hol(b))` for every
   UNITARY representation `rho` even without literal conjugacy (e.g.
   because of some other trace identity - cyclic invariance of trace
   under a different rearrangement, or an identity specific to real Wilson
   weights) - or is the Wilson-weight identity ALSO false in your
   counterexample? If the identity is false, this is a genuinely
   important negative result for the project: say so plainly, and
   suggest what WOULD have to be true instead (a different plaquette
   product ordering, an extra hypothesis on `rho`, a different definition
   of the mirror plaquette) to make progress.
3. Fallback if 1-2 together are too large: at minimum, verify by
   DIRECT COMPUTATION (symbolic or numerical, in S3 or Z_4 or another
   small explicit group) whether `mirror_hol(b) = p0.hol(b)` or
   `mirror_hol(b) = p0.hol(b)^-1` holds for SEVERAL random choices of
   `b(e0)..b(e3)`, and report the pattern you find (equal / inverse /
   conjugate-but-not-equal / unrelated), even if you cannot yet prove
   the general case.
4. General-shape check: our specific plaquette convention is `[fwd e0,
   fwd e1, rev e2, rev e3]`. Does your answer to 1/2 depend on this exact
   step-type pattern, or does the SAME relationship (conjugate / not
   conjugate / trace-equal) hold for ANY typed 4-step (or n-step) closed
   walk under the same "reverse order, relabel copy, do not swap
   fwd/rev" mirroring operation? If the answer is shape-dependent,
   characterize exactly which shapes work.

## Output format

1. Verdict: conjugate (with explicit conjugating element) / not
   conjugate but trace-equal (with the alternate identity) / not even
   trace-equal (with the counterexample and the recommended fix).
2. Full derivation or counterexample computation, shown explicitly enough
   to be checked by hand.
3. The precise Lean-ready lemma statement(s) this implies, in the style
   of the abstract 4-element group-theory statement in Question 1.
4. Answer to Question 4 (shape-dependence).
5. Recommended next step for the parent project given your verdict:
   proceed to Lean formalization of the conjugation lemma, or escalate
   the negative result and redesign the plaquette-pairing convention.

## Guardrails

Do not weaken the target to make it provable - if the exact identity as
posed is false, report that plainly with the counterexample and the
corrected strongest true statement, do not substitute a convenient
easier claim. This is finite group theory / representation theory,
"finite identity" scope; nothing physics-related to conflate. This
question is explicitly flagged (in an internal project strategy audit)
as the single highest-value open mathematical question in the run right
now - it gates the entire link-reflection-positivity result beyond the
degenerate zero-cut case already proved, so a correct, well-justified
NEGATIVE answer is exactly as valuable as a positive one.

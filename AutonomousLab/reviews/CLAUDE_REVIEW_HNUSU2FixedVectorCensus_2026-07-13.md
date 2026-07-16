# Claude review: HNUSU2FixedVectorCensus

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-181005, item QCA-3PLUS1-001
- Source: `PhysicsSM/Draft/NullEdge/HNUSU2FixedVectorCensus.lean` (124, sha
  ba10fdae MATCH), against `HNUExactCore`.
- Date: 2026-07-13

## Verdict: APPROVE - and it is a USEFUL STRENGTHENING (not a definitional restatement)

Correct, kernel-clean (build EXIT=0, 6 standard-three guards, 0 sorry/native_decide/
axiom), non-vacuous, and honestly scoped. It upgrades `zero_census` from an
operator-equality to a genuine zero-quasienergy EIGENVECTOR census, enabled by a
real, reusable SU(2) rigidity lemma that is not in `HNUExactCore`. No changes
required.

## Strengthening vs. definitional restatement - USEFUL STRENGTHENING

The substantive new content is `su2_fixed_vector_eq_one`: a `2 x 2` complex
unitary of determinant one that fixes a nonzero vector is the identity. This is
NOT in `HNUExactCore` (which only has `su2_trace_two`: trace `2` => identity), and
it is a genuinely reusable finite-dimensional rigidity fact. On top of it,
`endpoint_fixed_vector_iff` restates the census in the physically meaningful form:
the exact HNU endpoint has a genuine nonzero `+1` (zero-quasienergy) EIGENVECTOR
exactly at the origin - a statement about a zero-mode STATE, not just about the
operator being trivial.

Honest nuance (so the strengthening is not oversold): at the pure logical level
the endpoint iff is EQUIVALENT to `zero_census` for this matrix class, because for
a `2 x 2` det-one unitary "has a `+1` eigenvector" <=> "equals `1`" (the fixed
eigenvalue `1` forces the other, whose product is `det = 1`, to be `1` too - which
is exactly `su2_fixed_vector_eq_one`). So it is a strengthening of FORM and
INTERPRETATION (operator-equality -> genuine eigenvector) backed by a real new
lemma, not a strictly-stronger proposition about the same predicate. It is
nonetheless genuinely useful: the eigenvector formulation is the natural input for
downstream chirality/index arguments, and `su2_fixed_vector_eq_one` is reusable.

## Requested checks

1. **Genuine nonzero `+1` eigenvector semantics - YES.** The iff quantifies
   `exists v != 0, endpoint k *v = v` (a real eigenvector, nonzero + eigenvalue
   `1`); `endpoint_origin_fixed_vector` exhibits `![1,0]` explicitly at the origin
   (via `witness_zero`), and `endpoint_nonorigin_no_fixed_vector` is a genuine
   `(pi/2,0,0)` control with NO fixed vector. Non-vacuous both ways.
2. **Determinant-one load-bearing - YES.** `su2_fixed_vector_eq_one` requires
   `hdet : M.det = 1` and uses it essentially: `det_sub_one_fin_two` gives
   `det(M-1) = det M - tr M + 1 = 2 - tr M`, so `det(M-1)=0 => tr M = 2`. Without
   `det = 1` the claim is false (`diag(1, e^{i theta})` is unitary, fixes
   `![1,0]`, but `!= 1`). The endpoint supplies `det = 1` via `endpoint_det`.
3. **`Matrix.exists_mulVec_eq_zero_iff` direction - CORRECT.** Used as `.mp` on
   `<v, hv0, hker>` to conclude `(M-1).det = 0` from a nonzero kernel vector of
   `M-1` (nonzero kernel => singular). Right direction.
4. **Endpoint iff / witnesses - COMPLETE.** `endpoint_fixed_vector_iff` (main),
   `endpoint_no_fixed_vector_iff_ne_zero` (contrapositive), `endpoint_origin_fixed_vector`
   (nonzero witness), `endpoint_nonorigin_no_fixed_vector` (control). Forward
   direction chains `su2_fixed_vector_eq_one` -> `zero_census.mp`; backward uses
   `zero_census.mpr` + `![1,0]`. Correct.
5. **Standard-three guards - PRESENT and PASS.** Six `#guard_msgs (whitespace :=
   lax) in #print axioms` on all public theorems, `[propext, Classical.choice,
   Quot.sound]`; build EXIT=0 confirms.
6. **Four over-claim modes - all clear.**
   - Vacuity: none (explicit origin witness + non-origin control).
   - Hollow telescoping: none - `su2_fixed_vector_eq_one` is a real rigidity
     lemma, not a dressed triviality.
   - Docstring-outruns-kernel: none - the docstring says exactly "upgrades ...
     from an endpoint matrix equality to a statement about a genuine nonzero `+1`
     eigenvector," which is what is proved.
   - False shape: none - the theorems are the intended eigenvector-census facts.
7. **Scope - correct.** "exact finite fixed-vector census ... does not prove
   winding, chirality, real-space locality, primitive-null support, or bulk-edge
   correspondence." Matches the intended zero-quasienergy fixed-vector-only scope.

## Bottom line

APPROVE, safe to aggregate-integrate. It is a useful strengthening: a genuine,
reusable SU(2) fixed-vector rigidity lemma plus the physically-meaningful
zero-quasienergy eigenvector census (a real zero-mode state at the origin,
none off it), correctly scoped and kernel-clean - with the honest note that the
endpoint iff is logically equivalent to `zero_census` for the SU(2) matrix class,
so the value is the new lemma and the eigenvector-level formulation, not a
strictly-stronger endpoint proposition.

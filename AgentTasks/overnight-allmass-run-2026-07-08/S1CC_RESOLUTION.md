# S1-CC conditional no-go: finite balance engine landed, physical bridge open (2026-07-08)

Source: Fable-5 call-01 Part B (full log:
`AgentTasks/model-calls/claude/2026-07-07-231939-fable-call-01.md`).
Executor status: the finite engine is LANDED
(`anticonj_odd_pow_trace_zero`, `anticonj_charpoly_eq`,
`hermitian_balanced_count_of_neg_charpoly`, `half_constraint_rigidity`;
`S1CCBalancedInertia.lean`, guard-pinned). The physical `J Q_C|V'/N` bridge
and concrete `V'` construction remain the next rungs.

## UPDATE (2026-07-08 PM) — witness kernel-checked + general reduction landed

The rungs below the finite engine that this note listed as "next" / "M-target"
have since landed as kernel theorems (the note's ladder is preserved below for
provenance; this block records the current state):

- **Witness bridge — DONE (M).** Theorem 3's `6x6` witness (K-B, previously
  oracle) is now kernel-checked: `S1CCPhysicalSectorWitness.balanced_on_physical_sector`
  (inertia `(2,2,0)` on `V'/N`), with the full descent data — `[G,K]=0`,
  `Q_G^2=0`, `N ⊆ radical`, `b(JQc)b = -JQc`, `V' = ker Q_G` / `N = range Q_G`
  (`QG_ker_eq`/`QG_range_eq`/`QG_ker_reps_basis`) — all M, self-guarded.
- **Witness → general balance MECHANISM — DONE (M).**
  `S1CCGeneralReduction.compression_balanced` (any coset reps `r`, any `±1`
  grading, `Q_G`-blind), `compression_balanced_eigbasis` (any `b`-eigenvector
  family `P` — coordinate alignment dropped; proved in-repo), and
  `compression_has_neg_eigenvalue`. The witness is re-derived as a literal
  instance: `S1CCWitnessAsInstance.witness_balanced_via_general` (M). Guard-pinned
  inline + in `SlabAxiomGuard`.
- **What STILL stays MEMO — the sector PRESENTATION (not the mechanism).** Two
  adversarial reviews (Fable call-09, Aristotle audit batch-5) caught that a naive
  "b-eigenbasis exists" statement is vacuous (empty family). The honest remaining
  obligation is the existence of a `b`-adapted presentation of the *actual* sector
  `V'/N`: an orthonormal `b`-eigenbasis in `ker Q_G` **complementary to
  `range Q_G`**, dimension pinned to `dim ker Q_G - rank Q_G`, with the closure
  form descending to the quotient. Both reviews also ruled the underlying MATH true
  (balance survives the quotient because `range Q_G` is `b`-invariant ⇒ `±` pairs
  cancel) — so the gap is formalization, not mathematical risk. This is the live
  Aristotle proof target (`allmass-strategy-s1ccpres-20260708`, corrected to the
  non-vacuous statement).
- **NEW insight (Aristotle s1ccpres iteration, 2026-07-08 PM) — the physical
  `Q_G` is Krein-self-adjoint, NOT definite-Hermitian.** A first attempt to state
  the general existence with `Q_G.IsHermitian` (definite conjugate-transpose
  adjoint) + `Q_G² = 0` was proved by Aristotle to be **degenerate**: over `ℂ`
  with the definite adjoint, a Hermitian nilpotent vanishes
  (`Aᴴ = A`, `A² = 0 ⇒ AᴴA = 0 ⇒ A = 0`, helper
  `isHermitian_sq_eq_zero_imp_eq_zero`), so those hypotheses collapse `Q_G = 0` and
  the "sector" degenerates to the whole carrier. This is a semantic sharpening, not
  a setback: the *physical* BRST/Gauss charge is nilpotent and **non-Hermitian**
  (self-adjoint only w.r.t. the indefinite Krein form), exactly like the witness's
  `Q_G = c₁ ⊗ G` with `c₁ = E₀₁` (null covector, `c₁² = 0`, `c₁ ≠ c₁ᴴ`). The
  correct general hypotheses are therefore `Q_G² = 0` and `[b, Q_G] = 0` (no
  Hermiticity) — under which the sector `ker Q_G / range Q_G` is genuinely
  nontrivial, and the b-eigenbasis existence is the real (non-degenerate)
  simultaneous-structure problem. The degenerate `Q_G = 0` theorem was **not
  integrated** into the trusted tree (it would be a hollow landing); the corrected
  target is back with Aristotle. Also note `compression_balanced_eigbasis` needs
  only the b-intertwining, **not** `Pᴴ P = 1`, so orthonormality (the wrong notion
  without definite structure) is not required.
- **K-A (soldered `Q_G`) still the pre-registered kill** — unchanged.

## The resolution (grade MEMO unless noted)

The central positivity crux S1-CC is now a CONDITIONAL STRUCTURED NO-GO WITH
CONTENT: the finite matrix engine proves the balance mechanism, and the
checked `6x6` witness has `sig(J Q_C|_{V'/N}) = (2,2,0)` by oracle. The
physical-sector statement still depends on MEMO-grade rungs: concrete `V'`,
descent to `V'/N`, and identification of the restricted representative as the
Hermitian `B = J Q_C` to which the finite theorem applies. The gate's
torsor-compatibility question was the wrong question; only the square `Q_C`
must descend, and descent <=> the finite Ward condition.

## The theorem ladder (formalize in this order)

- **LANDED (M):** `anticonj_odd_pow_trace_zero` - `S^{-1} B S = -B` implies
  `Tr(B^(2k+1)) = 0` (`GateYM/S1CCBalancedInertia.lean`). The spectral-
  symmetry engine; house trace-identity style, guard-pinned.
- **LANDED (M):** `countP_pos_eq_countP_neg_of_map_neg_eq` and
  `card_pos_eq_card_neg_of_multiset_map_neg_eq` - the pure finite count half:
  if a real multiset (or finite indexed family) is invariant under negation,
  then positive and negative counts agree. This is not the spectral bridge; it
  is the reusable final combinatorial step once the Hermitian eigenvalue
  multiset is shown negation-invariant.
- **LANDED (M):** `hermitian_balanced_count_of_neg_charpoly` - if a Hermitian
  complex matrix satisfies `(-B).charpoly = B.charpoly`, then the number of
  positive Hermitian eigenvalues equals the number of negative Hermitian
  eigenvalues. Support rungs:
  `neg_charpoly_roots_eq_map_neg_eigenvalues` and
  `hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly`.
- **Lemma 1 (half-constraint rigidity) [LANDED, M].**
  `half_constraint_rigidity` in `S1CCBalancedInertia.lean`, guard-pinned. For
  `Q = c1 (x) G1 + c2 (x) G2` with the null pair, `Q^2 = 0 <=>
  G1 G2 = 0 and G2 G1 = 0`; so a nilpotent Gauss charge must use a SINGLE
  null covector - Gupta-Bleuler "half the constraint" is FORCED by
  nilpotency, not chosen. Four-line matrix algebra.
- **Definition (V', N) [M-target].** `Q_G = c(alpha1) (x) G`, `G = G^dag`
  the finite Gauss operator; `V' = ker Q_G = (e0 (x) W) + (e1 (x) ker G)`;
  `N = range Q_G = e0 (x) range G`. `Q_G^2 = 0` always; `N = range Q_G`
  is `finite_kugo_ojima` instantiated (already M in the repo). Plugs
  straight into the Q01 interface. `G` = linearized lattice divergence
  (abelian/linearized first).
- **Theorem 1 (descent <=> finite Ward) [M-target].** `Q_C(V') <= V'` and
  `Q_C(N) <= N` iff `K(ker G) <= ker G` (`K = [nabla1, nabla2]`).
  Sufficient: `[G,K] = 0` (abelian gauge covariance). Only the SQUARE
  descends - the current `L_A` does NOT (fails for every representative,
  and does not need to).
- **Theorem 2 (restricted inertia, closed form) [M-target].** If the physical
  bridge hypotheses are instantiated as stated, then on
  `V'/N ~= ker G (+) ker G` with the hyperbolic induced form, the closure
  form has inertia `(rank K-bar, rank K-bar, 2(dim ker G - rank K-bar))` -
  balanced exactly by the displayed formula. Positive only vacuously
  (`K-bar = 0`).
- **Theorem 3 (grading anticonjugation no-go) [M-target; flagship].**
  `S^dag (J'Q') S = -(J'Q')` implies `n+ = n-` (Sylvester congruence).
  Instantiate `S = b = sigma_z (x) 1`: it descends and anticonjugates `J`
  (`Jb = -bJ`). Under the bridge hypotheses, every `b`-invariant `V'` has
  balanced closure inertia; a positive sector would need a constraint mixing
  Clifford and color factors, which Lemma 1 forbids. The trace engine
  (`anticonj_odd_pow_trace_zero`) is the odd-moment half of this.
- **6x6 explicit witness [M-target, decide-style].** `W = C^3`,
  `G = diag(0,0,1)`, `K = antisym(e0,e1)`; `[G,K]=0`, `dim V'=5`,
  `dim N=1`, quotient inertia `(2,2,0)`.

## Kill conditions (pre-registered)

- **K-A (identification):** transcribe the concrete plaquette Gauss
  covectors. If `G` is NOT of the form `1_{C^2} (x) G` (genuinely
  soldered, mixing Clifford and color), Theorem 3's `b`-invariance fails
  and the inertia prediction is void (forcing the ghost-extended BRST
  route). 
- **K-B (numeric): PASSED (2026-07-08).**
  `Scripts/oracle/probe_s1cc_balanced_inertia.py` on the 6x6 witness:
  ALL structural checks hold ([G,K]=0, K skew-Herm, Q_G nilpotent,
  J Q_C Hermitian, anticonjugation `b^-1(JQ_C)b = -(JQ_C)`), dims
  (V'=5, N=1, quotient=4), and `sig(J Q_C|_{V'/N}) = (2,2,0)`, balanced
  exactly by oracle, matching the predicted `(rank K-bar, rank K-bar) =
  (2,2)`.
  The resolution passes its own pre-registered kill condition.
- **K-C (nonabelian):** if no Hermitian `G` implementing the Gauss
  covectors satisfies `K(ker G) <= ker G` with `ker G != 0`, Theorem 1 is
  empty there; re-pose at linearized level.

## Consequence for the program

The spectral-language rail does NOT lift: the finite engine gives count-level
balance, not spectral measures or physical positivity. The checked witness
shows the closure form is balanced on its `V'/N` realization, and the
aperture-rescue route is killed there. Any surviving total-operator positivity
needs a `J`-positive sector not balanced by the same grading. A post-06
two-edge Cl(4) oracle supplies a MEMO/numeric route of exactly that kind, but
it is not a theorem supplied by this note; the Lean `Matrix.PosDef` witness and
the physical-sector bridge are still separate targets.

## Next Aristotle target: physical-sector bridge (Theorem 3 instantiation)

The Hermitian count capstone is now kernel-checked as finite matrix algebra:
`hermitian_balanced_count_of_neg_charpoly`. The remaining work is not spectral
API; it is the concrete null-edge identification:

```lean
-- Schematic next target:
-- identify the physical-sector representative B' of J Q_C,
-- prove B'.IsHermitian and (-B').charpoly = B'.charpoly from the grading
-- anticonjugation, then apply hermitian_balanced_count_of_neg_charpoly.
```

Do not fold the `V'/N` quotient, descent, or `B = J Q_C` identification into
the finite matrix theorem. Those remain separate physical-sector rungs.

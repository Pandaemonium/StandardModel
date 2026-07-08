# S1-CC resolved: closure is balanced, not positive (Fable call-01, 2026-07-08)

Source: Fable-5 call-01 Part B (full log:
`AgentTasks/model-calls/claude/2026-07-07-231939-fable-call-01.md`).
Executor status: the trace engine is LANDED
(`anticonj_odd_pow_trace_zero`, `S1CCBalancedInertia.lean`, guard-pinned);
the remaining M-target theorems and the concrete `V'` are the next rungs.

## The resolution (grade MEMO unless noted)

The central positivity crux S1-CC closes as a STRUCTURED NO-GO WITH
CONTENT: closure is not positive on the physical sector `V'/N` - it is
exactly BALANCED (signature zero), structurally, via a grading
anticonjugation. The gate's torsor-compatibility question was the wrong
question; only the square `Q_C` must descend, and descent <=> the finite
Ward condition. Surviving positivity lives on the doublet-free complement
(the `p - q` inertia surplus), converging with the repo's (2,1)/(1,2)
Kugo-Ojima witnesses.

## The theorem ladder (formalize in this order)

- **LANDED (M):** `anticonj_odd_pow_trace_zero` - `S^{-1} B S = -B` implies
  `Tr(B^(2k+1)) = 0` (`GateYM/S1CCBalancedInertia.lean`). The spectral-
  symmetry engine; house trace-identity style, guard-pinned.
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
- **Theorem 2 (restricted inertia, closed form) [M-target].** On
  `V'/N ~= ker G (+) ker G` with the hyperbolic induced form, the closure
  form has inertia `(rank K-bar, rank K-bar, 2(dim ker G - rank K-bar))` -
  EXACTLY BALANCED. Positive only vacuously (`K-bar = 0`).
- **Theorem 3 (grading anticonjugation no-go) [M-target; flagship].**
  `S^dag (J'Q') S = -(J'Q')` implies `n+ = n-` (Sylvester congruence).
  Instantiate `S = b = sigma_z (x) 1`: it descends and anticonjugates `J`
  (`Jb = -bJ`). Every `b`-invariant `V'` has balanced closure inertia; a
  positive sector would need a constraint mixing Clifford and color
  factors, which Lemma 1 forbids. The trace engine
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
  (V'=5, N=1, quotient=4), and `sig(J Q_C|_{V'/N}) = (2,2,0)` EXACTLY
  BALANCED, matching the predicted `(rank K-bar, rank K-bar) = (2,2)`.
  The resolution passes its own pre-registered kill condition.
- **K-C (nonabelian):** if no Hermitian `G` implementing the Gauss
  covectors satisfies `K(ker G) <= ker G` with `ker G != 0`, Theorem 1 is
  empty there; re-pose at linearized level.

## Consequence for the program

The spectral-language rail does NOT lift: closure being balanced (not
positive) means the physical-positivity question relocates to the
doublet-free complement, and the `p - q` inertia surplus is the decider -
the same quantity the KreinPositiveSectorWitness `p > q` MEMO already
names, now mechanized. Physical (total-operator) positivity on the full
quotient is grade C: holds iff an aperture/turn-dominance inequality over
the definite complement holds (Weyl-type bound). This TIGHTENS the §6/§8
coupling: the balanced closure spectrum on the Gauss sector IS the finite
chromomagnetic equioscillation (hyperfine), and it is what lets curvature
pull total-operator eigenvalues toward zero from both sides, feeding the
Banks-Casher count.

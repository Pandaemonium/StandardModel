# Null-edge continuum square-limit and Lichnerowicz compatibility strategy

**No-build strategy/audit deliverable. Generated 2026-06-26.**

This report answers PROMPT.md: the smallest rigorous path from the finite
dual-soldered operator and the finite square decomposition to a Lorentzian
Dirac/Lichnerowicz-type continuum square. No Lean, Lake, pre-commit, or build
command was run. Every "Lean status" or "proved" note is read from the program's
own source documents (`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
Sections 18-20, `AgentTasks/null-edge-unified-mass-proof-chain.md` entries
T13-T16, `docs/CONVENTIONS.md`, `docs/NULLSTRAND.md`) and must be re-verified
against the live repository before being relied upon.

Companion documents:

- `AgentTasks/null-edge-unified-mass-proof-chain.md` (T13-T18 entries).
- `AgentTasks/null-edge-unified-mass-grand-strategy-report.md` (blockers, gates).
- `docs/CONVENTIONS.md`, `docs/NULLSTRAND.md` (conventions, guardrails).

## 0. Conventions assumed throughout (locked)

- Metric signature `(+,-,-,-)` (mostly minus). Null momenta satisfy `p^2 = 0`;
  on-shell massive modes satisfy `p^2 = m^2`. The analytic d'Alembertian has
  plane-wave symbol `-p^2`, so the mass-shell normalization for
  `-Box_null + Phi^2 = 0` gives `p^2 = m^2`.
- Active architecture (locked): `D_N = sum_a c(alpha^a) nabla_{ell_a}`, null
  support `ell_a`, dual-covector soldering `alpha^a`. The diagonal architecture
  `sum_a c(ell_a^flat) nabla_{ell_a}` is admitted ONLY as a documented negative
  comparison (diagonal trace obstruction).
- Simplex null-solder frame: in `d = s + 1`, spatial simplex `n_A` with
  `n_A . n_A = 1`, `n_A . n_B = -1/(d-1)` for `A != B`, `sum_A n_A = 0`,
  `ell_A = (1, n_A)`, dual `alpha^A = (1/d) dt + ((d-1)/d) n_A . dx`,
  `alpha^A(ell_B) = delta^A_B`. For `d = 4`: `alpha^A = 1/4 dt + 3/4 n_A . dx`.
  Scaled vectors require consistently scaled duals; mixing scaled `ell` with
  unscaled `alpha` is a convention error.
- Gradings kept strictly separate: `Gamma_s` (spacetime chirality), `chi_E`
  (internal grading), `epsilon_form` (cochain/form degree). Form degree or
  internal grading may never be used to repair a spacetime chirality sign error.
- Super-Dirac square sign convention (locked):
  `D = i D_N + Gamma_s Phi_H`,
  `D^2 = -D_N^2 + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]`,
  with `D_N^2 = K_h + C_diamond + T_frame`.
- Claim-type labels: representation (R), reconstruction (Rec), structural
  theorem (S), prediction (P). Job-type: Lean proof job (L), strategy job (St),
  audit job (Au).

## 1. Master theorem and its staged decomposition

### 1.1 The master theorem (the thing we are NOT proving yet)

The master (Gate D) target is the commuting square:

```text
D_h   --finite square-->   D_h^2
 |                          |
h->0                       h->0
 |                          |
D_cont --Lichnerowicz-->   D_cont^2
```

i.e. "finite square then limit equals continuum Dirac then Lichnerowicz square."
The continuum target is the Lorentzian analogue of a Dirac-square/Lichnerowicz
decomposition: a connection (Bochner) Laplacian plus a curvature/Clifford
endomorphism term plus the zero-order `Phi_H^2` block.

Guardrail (PROMPT): the finite square is NOT a proof of this master theorem.
The finite square can be an exact identity while the continuum limit fails
(surviving frame term, wrong holonomy normalization, wrong Pauli/diamond
coefficient, non-decoupling high-frequency branches, wrong Lichnerowicz
endomorphism). The deliverable below is the smallest staged chain that makes the
master theorem attackable, not a claim that it holds.

### 1.2 Staged theorem sequence (the spine)

The required staged sequence, in dependency order, is:

```text
S1  flat affine commutator symbol            (= Plan B1; finite algebra)
S2  smooth local symbol asymptotic           (= Plan B2; first true estimate)
S3  scalar/gauge null kinetic reconstruction (= Plan B3; finite algebra + limit)
S4  finite square decomposition              (= Plan B4; finite algebra)
S5  frame/tetrad-postulate control           (= Plan B5 / T15; finite + scaling)
S6  curvature/diamond coefficient normalization (Pauli/holonomy; estimate)
S7  commuting-square continuum limit          (= Gate D master; estimate)
```

Mapping to the existing proof chain: S1+S2 are the analytic content of T13
(dual-soldered commutator/symbol); S4 is the finite-algebra core feeding T14
(graded super-Dirac square); S5 is T15 (frame/tetrad postulate and frame-term
audit); S3 is an independent prerequisite (B3) that the working plan flags as
mandatory, not optional; S6 and S7 are the genuinely new continuum content that
sits above T14/T15 and below the prediction gate. The flat determinant
branch-count audit (T16 / Gate C) is a sibling track that must be passed before
the continuum claim is physically meaningful, but it is not on the algebraic
spine and is treated separately in Section 6.

## 2. Stage-by-stage: hypotheses, output, proof tools, failure signatures

Throughout, `T_a` is the shift `T_a psi(x) = U_a(x) psi(x + h ell_a)` (with link
`U_a` the gauge holonomy along `ell_a`), `nabla_a = (T_a - I)/h` the finite
covariant difference, `C_a = c(alpha^a)` the (possibly `x`-dependent) Clifford
soldering, and `M_f` multiplication by `f`.

### S1. Flat affine commutator symbol (Plan B1; finite algebra)

- Hypotheses: flat decorated null-tetrad graph, mesh `h`; trivial transport
  `U_a = I` (no connection); `f` affine; fixed (`x`-independent) dual frame
  `alpha^a`; simplex completeness `df = sum_a df(ell_a) alpha^a`.
- Output (exact, no remainder):

  ```text
  [D_h, M_f] = sum_a c(alpha^a) ((f(x + h ell_a) - f(x))/h) T_a
             = c(df)        when f is affine and T_a = I.
  ```

- Proof tools: pure Clifford/operator algebra; the finite-difference Leibniz
  identity `[D_h, M_f] psi = sum_a C_a ((f(.+h ell_a) - f) / h) T_a psi`; the
  dual-frame completeness identity `df = sum_a df(ell_a) alpha^a`
  (`alpha^A(ell_B) = delta^A_B`). In Lean: `Finset.sum`, `Matrix`/Clifford
  module rewriting, `ring`/`simp`; no analysis.
- Failure signatures: reappearance of `c(ell_a^flat)` instead of `c(alpha^a)`
  (diagonal trace obstruction, trace `0` vs `d`); scaling mismatch between
  `ell_a` and `alpha^a`; a leftover `T_a` that does not collapse to `I`
  (signals the affine/flat hypothesis was not actually used).
- Type: Rec/S (finite identity). Pure finite algebra.

### S2. Smooth local symbol asymptotic (Plan B2; first true estimate)

- Hypotheses: smooth `f`; smooth local trivialization; bounded derivatives on
  the patch; flat or slowly varying transport so the leading commutator is the
  finite difference of `f`.
- Output (first genuine continuum estimate):

  ```text
  [D_h, M_f] = c(df) + O(h)
  ```

  uniformly on compact patches, in the chosen operator norm.
- Proof tools: Taylor expansion of `f(x + h ell_a)` to first order with explicit
  `O(h)` remainder; uniform bounds on second derivatives; triangle inequality
  over the finite edge set `a`. In Lean: `Mathlib` Taylor / `IsBigO` /
  `Filter.Tendsto`, `Finset.sum` norm bounds. This is the first stage that
  requires real analysis, not just algebra.
- Failure signatures: remainder that is `O(1)` instead of `O(h)` (e.g. `C_a`
  jumping by order one across `h`-edges -> smooth-limit contamination); norm
  blowup from an unbounded edge count or unbounded `alpha^a`; hidden dependence
  of the constant on `x` (loss of uniformity).
- Type: Rec (asymptotic theorem). Genuine estimate.

### S3. Scalar/gauge null kinetic reconstruction (Plan B3; algebra + limit)

- Hypotheses: Lorentzian inverse-Gram `G^{ab} = g^{-1}(alpha^a, alpha^b)`;
  simplex dual frame; covariant differences `nabla_a^A H` of a scalar/Higgs
  field; the inverse-metric reconstruction identity
  `g^{-1}(xi, eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b)`.
- Output:

  ```text
  g^{-1}(xi, eta) = sum_{a,b} G^{ab} xi(ell_a) eta(ell_b)            (finite identity)
  g^{-1}(D H, D H) ~ sum_{a,b} G^{ab} <nabla_a^A H, nabla_b^A H>     (continuum limit)
  ```

  with `G^{-1} = -3/4 I + 1/4 J` on the `d = 4` tetrahedral frame (Lorentzian,
  indefinite weights with nonzero cross terms).
- Proof tools: finite linear algebra for the inverse-Gram identity (Gram-matrix
  inversion, `Matrix.inv`, `decide`/`ring` on the explicit `4 x 4` block);
  S2-style `O(h)` expansion for the covariant-derivative version.
- Failure signatures: a positive sum over edges with no cross terms (this is
  Euclidean/graph-like and is the precise failure mode that collapses P1.5 into
  "lattice gauge-Higgs with null labels"); dropping the off-diagonal `G^{ab}`;
  sign of the indefinite weights wrong (Euclidean rather than Lorentzian limit).
- Type: Rec (the "null-edge-earns-its-keep" theorem for scalar/gauge kinetics).
  Finite-identity core + genuine estimate for the limit. Keep this distinct from
  positive graph energy: the inverse-Gram cross terms are the whole point, and a
  positive-definite edge sum is the negative comparison, not the target.

### S4. Finite square decomposition (Plan B4 / T14 core; finite algebra)

- Hypotheses: `D_N = sum_a C_a nabla_a`, `C_a = c(alpha^a)`; finite edge set;
  no continuum hypothesis. (For the full graded square add the five locked
  grading hypotheses: `Gamma_s^2 = 1`, `{Gamma_s, C_a} = 0`,
  `[Gamma_s, nabla_a] = 0`, `[Gamma_s, Phi] = 0`, `[C_a, Phi] = 0`.)
- Output (exact finite identity):

  ```text
  D_N^2 = K_h + C_diamond + T_frame
  K_h        = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b}
  C_diamond  = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b]
  T_frame    = sum_{a,b} C_a [nabla_a, C_b] nabla_b
  ```

  and, with the grading hypotheses,
  `D_h^2 = -K_h - C_diamond - T_frame + Phi_H^2 - i Gamma_s sum_a C_a [nabla_a, Phi_H]`.
- Proof tools: split the double sum `sum_{a,b} C_a nabla_a C_b nabla_b` into
  symmetric/antisymmetric parts via the polarization identities
  `XY = 1/2{X,Y} + 1/2[X,Y]`; move `C_b` past `nabla_a` producing the
  `[nabla_a, C_b]` defect; `ring`/`abel`/`simp` on the operator algebra. No
  analysis. The `+Phi_H^2` sign is forced by `[Gamma_s, Phi] = 0`.
- Failure signatures: THE sign trap -- `Phi` odd under the same `Gamma_s` flips
  `+Phi^2` to `-Phi^2`; conflating `chi_E`-oddness with `Gamma_s`-oddness;
  silently dropping `T_frame` instead of carrying it; a `Box_null`/`K_h`
  normalization that does not give `p^2 = m^2`.
- Type: Rec (finite identity). Pure finite algebra. "Not new physics by itself."

### S5. Frame/tetrad-postulate control (Plan B5 / T15; finite + scaling)

- Hypotheses: the finite tetrad postulate `[nabla_a, C_b] = 0` for all `a, b`
  (edge-transport compatibility carries the soldering frame).
- Output:

  ```text
  ([nabla_a, C_b] = 0 for all a,b)  implies  T_frame = 0,
  ```

  plus a defect classification when the postulate fails (see Section 4).
- Proof tools: direct substitution into the `T_frame` formula and `simp` once
  every `[nabla_a, C_b]` is zero (finite algebra). The defect-classification
  branch is an audit, not a single theorem.
- Failure signatures: claiming the postulate when the frame varies (`C_b =
  C_b(x)`) but transport does not actually carry it; hiding a surviving
  `T_frame = O(h^{-1})` term in the continuum limit (the key contamination mode,
  see Section 4); using metric compatibility to disguise a holonomy term.
- Type: S (consistency check / audit). Vanishing lemma is finite algebra; the
  `h`-scaling of a non-vanishing `T_frame` is a genuine estimate.

### S6. Curvature/diamond coefficient normalization (Pauli/holonomy; estimate)

- Hypotheses: smooth spin connection and gauge connection; curvature entering
  through holonomy `U_a U_b U_a^{-1} U_b^{-1}` around finite null diamonds;
  S2-type smoothness; the finite tetrad postulate controlled (S5) so `T_frame`
  does not contaminate the diamond term.
- Output: the finite `C_diamond` converges to the correct continuum
  Clifford/gauge curvature (Pauli) term with the correct numerical coefficient,

  ```text
  C_diamond  ->  (the intended Pauli/curvature endomorphism, correct coefficient).
  ```

- Proof tools: expand `[nabla_a, nabla_b]` via the diamond holonomy to extract
  curvature `F_{ab}` at order `h^2`/`h^0` as appropriate; track the
  `1/4 [C_a, C_b]` Clifford prefactor and the simplex weights `alpha^a`; compare
  to the target `(1/2) c(alpha^a) c(alpha^b) F_{ab}` (or the project's audited
  normalization). Genuine estimate; needs the Pauli diamond normalization audit.
- Failure signatures: wrong Pauli coefficient (factor of 2, sign, or frame
  weight); wrong holonomy normalization (`F_{ab}` extracted at the wrong order
  in `h`); curvature term that is Euclidean rather than Lorentzian; a diamond
  term that does not close (torsion-like defect leaking from S5).
- Type: S/Rec (consistency check). Genuine estimate/analysis.

### S7. Commuting-square continuum limit (Gate D master; estimate)

- Hypotheses: S1-S6 established on the same smooth decorated null-tetrad
  background with local frame `ell_a(x)`, `alpha^a(x)`; uniform smoothness;
  finite tetrad postulate (or controlled torsion, Section 4); branch/stability
  gate (Gate C, Section 6) passed so the limit is taken on the physical sector.
- Output: the commuting square of Section 1.1 commutes, i.e.

  ```text
  lim_{h->0} D_h = D_cont   and   lim_{h->0} D_h^2 = D_cont^2
  ```

  with `D_cont^2` equal to the intended Lorentzian Dirac-square/Lichnerowicz
  decomposition: connection Laplacian + curvature/Clifford endomorphism +
  `Phi_H^2`, with audited signs and normalizations.

  ```text
  K_h        ->  Lorentzian connection (Bochner) Laplacian / kinetic operator
  C_diamond  ->  Clifford/gauge curvature (Pauli) term, correct coefficient
  T_frame    ->  0 (finite tetrad postulate) or controlled spin-connection/torsion
  ```

- Proof tools: combine the S2/S3/S6 estimates with strong-resolvent or
  graph-norm convergence; uniform `O(h)` control of every term in the finite
  square; commute `lim` with the finite sum (finite index set, so no
  interchange-of-limit subtlety beyond uniformity).
- Failure signatures: `T_frame = O(h^{-1})`; wrong curvature coefficient;
  limiting square that is not the intended Dirac/Lichnerowicz square; scalar/
  gauge kinetic limit that is Euclidean rather than Lorentzian; high-frequency
  branches that do not decouple from the low-energy continuum sector.
- Type: Rec (asymptotic / master theorem). Genuine estimate/analysis. This is
  the one stage whose success is the actual continuum claim; until it is proved,
  the program is "finite operator reconstruction," not a continuum theorem.

## 3. Pure finite algebra versus genuine estimates/analysis

```text
Stage  Content                                  Class
S1     flat affine commutator symbol            pure finite algebra
S2     smooth local symbol asymptotic           genuine estimate (first one)
S3     null kinetic reconstruction              finite-identity core + estimate for limit
S4     finite square decomposition              pure finite algebra
S5     frame/tetrad postulate vanishing         pure finite algebra
S5'    T_frame h-scaling when postulate fails   genuine estimate
S6     curvature/diamond coefficient            genuine estimate/analysis
S7     commuting-square continuum limit         genuine estimate/analysis (master)
```

Summary: S1, S4, S5 (vanishing lemma), and the finite-identity core of S3 are
pure finite algebra and are the cheapest, highest-confidence targets. The true
analytic content -- and the real risk -- lives in S2, the limit half of S3, the
`h`-scaling of S5', S6, and the master S7. The strategic implication is the one
already encoded in the gate ordering: lock and prove all finite algebra (S1, S4,
S5-vanishing, S3-identity) before spending effort on the estimates, because a
finite-algebra failure invalidates the estimates above it, and because the
finite algebra is where the dual-soldering architecture earns its keep.

## 4. What `T_frame -> 0` (or controlled survival) must mean

`T_frame = sum_{a,b} C_a [nabla_a, C_b] nabla_b` is the frame/tetrad
compatibility defect. There are exactly two acceptable continuum outcomes, and
several forbidden ones.

Acceptable outcome 1 -- genuine vanishing (the clean case):

```text
finite tetrad postulate [nabla_a, C_b] = 0 holds  =>  T_frame = 0 exactly,
and it stays 0 (not merely o(1)) in the limit.
```

This is the target. It requires that edge transport actually carries the
soldering frame, i.e. the connection used in `nabla_a` is the one that
parallel-transports `C_b = c(alpha^b(x))`. The vanishing must be an identity at
finite `h`, not an `h->0` cancellation, otherwise it is contamination in
disguise.

Acceptable outcome 2 -- controlled survival (torsion/spin-connection):

```text
T_frame -> T_0,  with T_0 a bounded, O(h^0), explicitly identified
spin-connection or torsion endomorphism that is deliberately retained.
```

This is acceptable ONLY if `T_0` is (a) bounded as `h->0`, (b) named and
classified as a specific geometric object (spin-connection survival or a
torsion/nonmetricity term), and (c) consistent with the intended generalized
Lichnerowicz decomposition (it belongs to the connection/endomorphism part, not
a spurious kinetic correction). A retained `T_frame` changes the theorem from a
torsion-free Lichnerowicz square to a torsionful one; the claim must then say so.

Forbidden outcomes (must be reported, never hidden):

```text
T_frame = O(h^{-1})         divergent -> the limit does not exist; FATAL.
T_frame = O(1) but unnamed  smooth-limit contamination (C_b jumps order one
                            across h-edges); must be classified, not absorbed.
T_frame absorbed into K_h   double-counting / silent kinetic correction; FORBIDDEN.
```

Classification rule when the postulate fails (from `docs/NULLSTRAND.md`):
nonmetricity/bad soldering if metric compatibility fails; curvature/holonomy if
metric compatibility holds but connection commutators survive; torsion-like
defect if edge parallelograms fail to close or antisymmetric displacement
defects appear; smooth-limit contamination if `C_b` jumps by order one across
`h`-edges. The deliverable of S5/S6 must place any surviving `T_frame` into
exactly one of these boxes with its `h`-scaling stated.

## 5. What comparison to generalized Lichnerowicz formulas should and should not claim

Should claim:

- That the continuum limit `D_cont^2` has the SHAPE of a generalized
  Lichnerowicz/Dirac-square decomposition on a Clifford module: a connection
  (Bochner) Laplacian, plus a curvature/Clifford endomorphism term, plus the
  zero-order `Phi_H^2` block, in mostly-minus Lorentzian signature.
- That Ackermann-Tolksdorf (`arXiv:hep-th/9503153`) is a useful comparison CLASS
  for generalized Lichnerowicz decompositions on Clifford modules -- a template
  for the term structure and for what an endomorphism term is allowed to be.
- That the finite `C_diamond` is the discrete pre-image of the curvature
  endomorphism, subject to the S6 coefficient audit.

Should NOT claim:

- That the finite square IS a Lichnerowicz formula. The finite identity
  `D_N^2 = K_h + C_diamond + T_frame` is exact finite algebra; it becomes a
  Lichnerowicz statement only after S6 and S7 succeed with audited coefficients.
- That matching the generic SHAPE fixes the COEFFICIENTS. The Pauli/curvature
  coefficient and the endomorphism content are exactly what S6 must compute; a
  shape match is necessary, not sufficient.
- That the comparison source proves the present construction. The comparison
  literature is Euclidean/Riemannian Clifford-module Lichnerowicz theory; the
  present object is finite and Lorentzian. The signature, the Krein/Lorentzian
  adjointness, and the null support are NOT supplied by the comparison class and
  remain the program's own burden.
- Anything about positivity, real spectrum, or stability from the Lichnerowicz
  shape alone. The Bochner/Weitzenbock positivity arguments familiar from the
  Riemannian case do not transfer to mostly-minus signature; Krein
  `J`-self-adjointness is a necessary audit, not a stability theorem.

In one line: claim a generalized-Lichnerowicz-TYPE decomposition with audited
Lorentzian signs and coefficients; do not import Riemannian Lichnerowicz
positivity or treat the shape match as the theorem.

## 6. Smallest next targets

### 6.1 Smallest next Lean theorem target

S1 (flat affine commutator symbol, = Plan B1, the analytic seed of T13), in the
flat `d = 4` tetrahedral case with trivial transport:

```text
theorem flat_affine_commutator_symbol :
  -- on the flat decorated null-tetrad graph, U_a = I, f affine,
  -- fixed dual frame with alpha^A(ell_B) = delta^A_B and df = sum_a df(ell_a) alpha^a:
  [D_h, M_f] = c (df)
```

Why this is the smallest: it is pure finite algebra (no estimate), it is the
named "missing seam" content that ties the static `gamma.P` Plucker theorem to
the order-complex operator, and every later stage (S2 estimate, S4 square, S6
curvature) reuses its dual-frame completeness identity. It also forces the
dual-soldering vs diagonal choice to be made correctly in code before any
analysis is attempted. Precede it with the finite square decomposition S4
(`D_N^2 = K_h + C_diamond + T_frame`) only if the proving effort wants the
algebra skeleton in place first; both are finite algebra and independent of the
estimates. Recommended: prove S1 first, then S4, then the S5 vanishing lemma.

### 6.2 Smallest next no-build audit target

The `superDirac_square_sign_audit` (Gate A), a four-case sign table on tiny
matrices, paired with the `T_frame` scaling classification:

```text
case [Gamma_s, Phi] = 0   -> (Gamma_s Phi)^2 = +Phi^2     (intended)
case {Gamma_s, Phi} = 0   -> (Gamma_s Phi)^2 = -Phi^2     (sign flip)
case [C_a, Phi] = 0       -> intended gradient term -i Gamma_s C_a [nabla_a, Phi]
case [C_a, Phi] != 0      -> extra terms; theorem does not apply
```

Why this is the smallest: it is the highest-ranked internal-consistency trap
(the `+Phi^2` vs `-Phi^2` sign and the `chi_E`-vs-`Gamma_s` confusion), it is
prerequisite to T14/S4 being meaningful, and it is a paper-only audit requiring
no build. Bundle it with a one-page `T_frame` defect-classification table
(Section 4: which `h`-scaling lands in which box) so that the frame-term
guardrail is fixed before S5/S6 estimates begin.

## 7. Guardrail compliance check (PROMPT.md)

- "Do not claim the continuum theorem is proved by the finite square": honored.
  S7 is explicitly the only stage that constitutes the continuum claim; S1-S6
  are labelled finite identities or partial estimates; Section 1.1 states the
  non-implication directly.
- "Keep `sum_a c(alpha^a) nabla_{ell_a}` as the active architecture": honored.
  Used throughout as `D_N`.
- "Do not revive the diagonal `c(ell_a^flat)` operator except as a negative
  comparison": honored. It appears only as the trace-obstruction negative
  comparison in S1 failure signatures and Section 0.
- "Keep scalar/gauge Lorentzian inverse-Gram reconstruction distinct from
  positive graph energy": honored. S3 isolates the indefinite inverse-Gram
  cross terms as the target and names the positive edge sum as the negative
  comparison / failure mode.

## 8. One-line ordering recommendation

```text
Audit (Gate A sign table + T_frame classification)
 -> S1 flat affine commutator [Lean, finite algebra]
 -> S4 finite square decomposition [Lean, finite algebra]
 -> S5 tetrad-postulate vanishing [Lean, finite algebra]
 -> S3 inverse-Gram identity [Lean, finite algebra] + its limit [estimate]
 -> S2 smooth symbol asymptotic [estimate]
 -> S6 curvature/diamond coefficient [estimate]
 -> Gate C flat determinant branch count [sibling audit, must pass]
 -> S7 commuting-square continuum limit [master estimate].
```

All "proved/Lean status" claims above are read from program source documents and
must be re-verified against the live repository before use.

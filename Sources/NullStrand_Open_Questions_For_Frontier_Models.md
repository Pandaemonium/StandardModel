# Null-strand Bohm–Bell program: hardest open questions

**Compiled:** 2026-06-25
**Purpose:** a self-contained briefing of the deepest unresolved problems in this
project, written so it can be pasted directly to a frontier AI model to ask for
mathematical, physical, and formalization guidance. It assumes the reader has no
access to the repository, so every term and convention needed to engage with a
question is defined inline.

---

## 0. How to use this document

Each open question below is stated three ways: the **informal physics goal**, the
**precise mathematical target** (what a theorem would have to say), and the
**specific guidance wanted**. If you are a frontier model reading this, you do not
need to produce Lean code. We want: candidate constructions, known theorems we may
have missed, counterexamples or impossibility arguments, sharper problem
statements, and pointers to literature. Flag anywhere our target looks ill-posed,
convention-dependent, or already known to be false.

When proposing a construction, please separate four layers explicitly, because we
do not want success on one to silently promote the others:

1. **exact finite identity** — algebra or combinatorics on a finite set;
2. **existence / naturality** — whether the object is canonical or hand-tuned;
3. **scaling / dynamical theorem** — whether it survives a continuum or long-time limit;
4. **physical interpretation** — what the finite result actually means physically.

---

## 1. Project context

### 1.1 The physical proposal

The program is a **finite, relativistically-motivated hidden-variable (pilot-wave /
Bohm–Bell) ontology**. The core intuition:

- A fundamental "strand" (a particle's hidden trajectory) moves in **null
  (lightlike) microscopic steps**. Each individual step is on the light cone and
  is in that sense massless.
- A **timelike, massive** coarse-grained trajectory emerges because an observer
  sees a *bundle* of lightlike directions whose barycenter is timelike, not one
  perfectly collinear ray. Mass is the "spread" of unresolved null motion.
- The dynamics should be **Born-equivariant**: if the hidden variables are
  distributed according to the quantum equilibrium (Born) measure at one time,
  they remain so under the update rule (the standard equivariance property that
  makes Bohmian mechanics empirically equivalent to quantum mechanics).
- Entanglement and Bell nonlocality are to be carried by a **hidden transport /
  synchronization rule** across a foliation of spacetime, and we want to
  understand when this rule is foliation-independent (a holonomy / flatness
  question).

The mathematical anchors that already exist as kernel-checked theorems include a
finite "Plücker mass" identity (invariant mass squared of a bundle of null spinor
directions equals the total pairwise Plücker/wedge spread of those directions; mass
zero iff projectively collinear), a Feynman-checkerboard 1+1 luminal dynamics, and
finite causal-diamond gauge holonomy.

### 1.2 Conventions (so external suggestions can be checked)

- **Metric / Minkowski:** 4D Minkowski space, mostly-minus signature `(+,-,-,-)`
  unless a module says otherwise. `minkowskiInner U V` is the bilinear form.
  "Future null" = on the future light cone. A null resolution is **normalized**
  against a timelike observer `n` by `minkowskiInner n (k w) = 1`.
- **Null resolution of a timelike direction `U`:** a finite probability law `law`
  on an index set `Omega`, a map `k : Omega -> Minkowski4` with each `k w` future
  null and normalized, such that the barycenter `E_law[k] = U`. This is the finite
  object that realizes "timelike = average of null."
- **Observer flux / direction:** for observer time direction `n`,
  `observerDirection(k) = k/(n·k) - n`; the flux law reweights the null law by
  `(n·k)`. The key kinematic cancellation is that the flux-weighted mean of
  `observerDirection` depends only on `integral k dnu = U`.
- **gamma / Gamma_5:** chirality operator written `Gamma_5` (or `Γ₅`); left/right
  Weyl chirality is a separate `Z2` grading from cochain/form degree on the causal
  complex. Two distinct gradings must not be conflated.
- **Octonion basis (only relevant to the internal-algebra branch):** XOR
  binary-label convention `e000..e111`, product index = bitwise XOR, signs from a
  fixed Fano orientation. This is **not** Baez or Furey verbatim; any imported
  formula needs explicit relabeling and sign correction. Octonions are
  nonassociative — parenthesization is load-bearing.

### 1.3 What is already done (so we don't ask for it again)

Kernel-checked or kernel-clean: the finite null-fiber / rest-sphere equivalence and
an octahedral finite null resolution; abstract finite flux theorems (mean = relative
velocity, variance = inverse gamma squared, expected strand rate = inverse gamma); a
finite i.i.d. null-strand master theorem (`finiteIIDNullStrand_master`: every
increment null, one actual history has a timelike coarse limit almost surely, via a
Banach-valued strong law of large numbers); a finite checkerboard Bohm–Bell master
theorem (`checkerboardBohmBell_master`: every step null, Born-equivariant, has a
trajectory measure — for the current finite model); finite weighted-graph Laplacian
least-action results; refresh-chain spectral-gap facts; a finite separability
obstruction (positive product-direction representation implies separable); finite
Bell-current / master-equation safety lemmas; finite causal-diamond holonomy with
composition laws. These are **finite** results; the hard open questions are almost
all about **canonicity, continuum limits, and one concrete unifying operator.**

---

## 2. The hardest open questions

### Q1 — A covariant mixing / spectral-gap theorem for the continuous-time generator

**Informal goal.** The finite i.i.d. model proves a single history is null-microscopic
and timelike-macroscopic. We want the same for a *correlated*, physically-motivated
continuous-time generator (a "Compton-locked" jump generator on the null fiber), i.e.
a genuine ergodic / mixing theorem rather than an i.i.d. shortcut, with the long-run
clock rate `E[ds/dt] = 1/(n·U)` realized pathwise.

**Precise target.** Given a continuous-time Markov jump generator `L` on a finite (or
nice measurable) null-direction space with a prescribed invariant law whose
barycenter is the timelike `U`:
1. existence / nonexplosion / closability of the process;
2. identification of reversible or **hypocoercive** structure;
3. a Poincaré / spectral-gap / absolute-contraction bound under explicit hypotheses;
4. the relation (derived or postulated) between the particle **mass** and the size of
   the gap — we expect the gap to **degenerate at the massless boundary** and want
   the correct conditional statement, not a universal gap claim.

**Guidance wanted.** Is there a clean hypocoercivity framework (Villani / Dolbeault–
Mouhot–Schmeiser style, or a discrete analogue) that applies to a generator on a
sphere/null-fiber with a timelike-biased invariant measure? What is the right way to
tie a spectral gap to a mass parameter so the massless limit is a controlled
degeneration rather than a failure? Are there known counterexamples where covariance
forces the gap to vanish?

---

### Q2 — A continuum null-strand process near nodes and at the massless boundary

**Informal goal.** Upgrade the finite/i.i.d. picture to an actual continuum
sphere-valued diffusion or jump process whose paths are everywhere null and whose
coarse limit is the timelike Bohmian trajectory, **without** silently excluding the
nodes of the wavefunction (where the Born density vanishes) or collapsing support.

**Precise target.** Construct, on the unit "rest sphere" fiber over each spacetime
point, a process with a weighted Laplace–Beltrami / weighted-Poisson generator
(finite analogue already proven via a weighted graph Laplacian) such that:
- the process is well-defined and non-exploding *as a stopped process near nodes*;
- Born equivariance holds for the induced spacetime motion;
- the massless boundary is handled as an explicit degeneration.

We expect only a **stopped / local** theorem to be honestly available; a global
theorem that hides node exclusion would be wrong.

**Guidance wanted.** What is the right existence theory for manifold-valued SDEs with
a weight that degenerates on a nodal set? Is there a Dirichlet-form / Sobolev-space
formulation on `S^2` (weighted Laplace–Beltrami) that yields a self-adjoint generator
with the correct invariant measure and a usable nonexplosion criterion? How is the
near-node behavior (analogous to the well-known singularity of Bohmian velocities at
nodes) best controlled — time change, h-transform, or stopping?

---

### Q3 — Entanglement vs. synchronization curvature: the right conditional theorem

**Informal goal.** In a Bell scenario the hidden transport rule that keeps two
entangled strands "synchronized" across a foliation may be **path/foliation
dependent**. We want to know precisely when it is *not* — when synchronization is a
flat (path-independent) connection — and when entanglement *forces* curvature.

**Precise target.** Define a `HiddenTransportRule` (a hidden state space, an
equilibrium map from quantum states to hidden-state laws, an update kernel per local
event, plus equivariance and covariance conditions). "Synchronization curvature" is a
property of an *instance* of this structure, not of the quantum state alone. The
target theorem is a **holonomy / flatness** statement over the finite space of cuts:

```text
zero elementary-diamond defect + path-homotopy generation
  -> path-independent hidden transport.
```

We explicitly do **not** want an unconditional "entanglement iff curvature"
equivalence; we want a family of theorems parameterized by locality, positivity,
covariance, and regularity assumptions on the rule, plus at least two worked Bell-pair
pilots (a final-state-redraw baseline and a minimum-transport / least-action rule)
showing the result is rule-dependent.

**Guidance wanted.** Is the "zero defect on generators + homotopy generation implies
global flatness" step a clean discrete analogue of a known holonomy theorem (e.g. for
groupoid / 2-group connections on a poset)? What is the minimal locality/covariance
hypothesis on the transport rule under which a nonzero curvature is genuinely forced
by an entangled input, and is there a no-go obstruction (à la Bell/Colbeck–Renner or
PBR) that bounds what such a rule can be?

---

### Q4 — When is an internal phase / holonomy an *operational* clock?

**Informal goal.** The strand may carry an internal phase or holonomy that
accumulates along the trajectory. We currently treat `E[ds/dt] = 1/(n·U)` as a
kinematic identity and the long-run average clock rate as a separate ergodic claim.
A passive absolute phase is **not** an observable. We want the conditions under which
internal holonomy becomes a real, gauge-invariant clock.

**Precise target.** Specify a **gauge-invariant record variable** and a **coupling**
from the relative internal holonomy to that record, such that the recorded quantity
is invariant under the internal gauge freedom and tracks proper time. Without such a
readout coupling, the internal phase must not be called a clock.

**Guidance wanted.** What is the minimal model of a "clock + pointer" coupling (in the
spirit of Page–Wootters conditional probabilities, or a quantum-reference-frame /
relational-observable construction) that turns an internal holonomy into a
gauge-invariant operational record? Are there known obstructions to having a good
relational clock for a *null*-stepping system specifically?

---

### Q5 — One concrete "super-Dirac" graph operator with the right square (highest value)

**Informal goal.** This is the single most important open construction. We want **one
concrete first-order operator** on a causal graph / order complex whose square
delivers, simultaneously and *without double-counting mass*, the null Laplacian,
the causal-diamond curvature, and the Higgs/Yukawa mass block — i.e. a finite
spectral-triple-like factorization that is genuinely the program's "Dirac operator."

**Precise target.** The priority proposal is the **null-diamond super-Dirac operator**

```text
D_N = Σ_i c(ℓ_i) (T_i − P_i),     D = i D_N + Γ₅ Φ
```

where `c(ℓ_i)` is the null Clifford symbol for edge-direction `i`, `T_i` is the
pullback/shift along direction `i`, `P_i` is the existence (support) projector, and
`Φ` is an odd self-adjoint Yukawa operator on the internal finite space. The required
exact finite identity is

```text
D^2 = −□_null − 𝒞_diamond − 𝒯_frame + Φ²
      − i Γ₅ Σ_i c(ℓ_i)[∇_i, Φ]
```

with `□_null` the null second-order propagation, `𝒞_diamond` the causal-diamond
holonomy curvature term, `𝒯_frame` a frame-variation term that vanishes under a
finite tetrad postulate, and **`Φ²` the only mass block**. The crucial constraint is
that the **Plücker mass is the square of the kinetic symbol, not an extra zero-order
addend** — on shell, for a mode with symbol momentum `P(ξ)` and `Φ²ψ = m²ψ`, one must
get `P(ξ)² = m²` (no separate additive "Plücker mass" term).

The genuinely missing piece is the **symbol / soldering theorem**: that the order-
complex operator's first-order symbol equals the Dirac slash of the weighted null-edge
momentum bundle,

```text
[D, M_f] near x  ->  Σ_y a_xy (f(y) − f(x)) γ·p_xy  ->  Plücker mass after squaring.
```

**Guidance wanted.** Is there a known finite spectral-triple / Quillen-superconnection
construction (Chamseddine–Connes spectral action, Marcolli–van Suijlekom gauge
networks, Bianconi topological Dirac, Ackermann–Tolksdorf generalized Lichnerowicz)
whose `D²` expansion has exactly this `−Laplacian − curvature − frame + Φ²` shape on a
*causal/Lorentzian* graph? How do we keep the grading honest (form-degree on the
complex vs. L/R chirality internally), and should the Lorentzian version be a
**Krein / J-self-adjoint** operator rather than an ordinary Hilbert self-adjoint one?
Most importantly: is the no-double-counting constraint (`Φ²` as the *only* mass block,
Plücker mass as kinetic symbol) actually consistent, or does some index/heat-trace
obstruction force an extra zero-order term?

---

### Q6 — A null-local, covariant, continuum-correct operator (or a sharp no-go)

**Informal goal.** Independent of Q5's internal structure, we want to know whether a
single first-order operator on a Lorentz-covariant causal structure can be **all** of:
retarded, intrinsically local, supported on primitive null continuations, covariant in
law, stable, and convergent to the right continuum operator. The folklore worry is
that covariant causal-set operators are forced to be nonlocal.

**Precise target.** Set up a **property matrix** (retardedness, intrinsic locality,
primitive null support, covariance-in-law, stability, continuum convergence) and either
exhibit one operator satisfying all columns, or prove a precise tradeoff / no-go
showing two properties are incompatible. Additionally: test whether an apparently
nonlocal *effective* operator can be realized as the **projected square of a natural
null-local operator on an enlarged state space** (a dilation), with naturality and
dimension controls so trivial encodings don't count.

**Guidance wanted.** What is the current best statement of the causal-set nonlocality
obstruction (Sorkin/Johnston-style retarded operators, the "nonlocal d'Alembertian"
literature), and is it a true no-go or an artifact of specific constructions? Is there
a Stinespring-like dilation framework in which a local operator on a larger space
projects to the desired effective dynamics, and what naturality condition rules out
cheating?

---

### Q7 — A *natural* null dilation (ruling out trivial hidden-state encodings)

**Informal goal.** Closely related to Q6: if we realize timelike/massive dynamics as a
projection of null-local dynamics on an enlarged state space, we must forbid the
trivial encoding that just "hides" the answer in an unconstrained ancilla.

**Precise target.** Require the dilation to be: **bounded local dimension**,
**functorial under graph embeddings**, **covariant**, and to have a **controlled
continuum limit**. A theorem here would say a natural null dilation with these
constraints exists (or that the constraints are jointly unsatisfiable).

**Guidance wanted.** What is the right categorical/functorial formulation of "natural
dilation" here (functor from a category of causal graphs/embeddings to operators)?
Are there known results bounding the ancilla dimension needed to make a given effective
generator the projection of a local one?

---

### Q8 — The observed mass spectrum (explicitly out of near-term scope, but stated)

**Informal goal.** None of the current null-lift, Plücker, or Gram-weighted identities
*derive* the Standard Model Yukawa/mass spectrum; they only reformulate mass as a
finite geometric invariant. We state this as an open question to mark the boundary, not
to claim near-term progress.

**Precise target.** Under what additional structure on the internal state space (e.g. an
exceptional-Jordan `H_3(O)` substrate, a triality layer) do the internal Gram overlaps
become **non-generic** in a way that constrains mass ratios — turning
`det(M G M†) = w† (Λ² G) w` into allowed-spectrum data rather than free parameters?

**Guidance wanted.** Is the quantum-marginal / entanglement-polytope route (Klyachko)
a viable way to convert "internal overlap matrix `G`" into constraints on the allowed
mass-ratio spectrum? Are there known no-go results that forbid deriving fermion mass
hierarchies from such a finite internal-geometry mechanism without inputting them by
hand?

---

## 3. Cross-cutting formalization questions

These are not physics questions but determine whether the above can be made
kernel-checked in Lean 4 + Mathlib (toolchain pinned, no axioms/`sorry` in trusted
code).

- **F1 — Finite Markov-chain strong law in a usable kernel API.** Mathlib has a
  Banach-valued SLLN (used for the i.i.d. master) and Ionescu–Tulcea for infinite
  trajectory measures, but not a convenient *finite Markov chain* SLLN / ergodic
  theorem in a kernel form. What is the cleanest route: build it from the existing
  martingale/ergodic infrastructure, or from spectral-gap + Borel–Cantelli?
- **F2 — Weighted Sobolev / Laplace–Beltrami on `S^2`.** Needed for Q2's continuum
  generator. Mathlib has analytic manifold structure on spheres and abstract Lax–
  Milgram; is there enough weak-derivative / Dirichlet-form API to define a weighted
  Poisson problem on the sphere, or is this a genuine library project?
- **F3 — Manifold-valued SDE existence / nonexplosion.** Needed for Q2's process layer.
  Believed to be long-horizon / missing in Mathlib. Is there a stochastic-calculus
  shortcut (e.g. via a time-changed Dirichlet form) that avoids full SDE theory?
- **F4 — Krein / J-self-adjoint finite operators.** Needed for Q5's Lorentzian audit, so
  that the construction is not merely a Euclidean/Wick-rotated shadow. What is the
  minimal finite-dimensional Krein-space API required?

---

## 4. Stop / falsification conditions (please pressure-test these)

We try to keep the program honest with explicit stop rules. We would value an external
view on whether any of these should fire *now*:

- If the abstract finite flux theorem were false, the covariant null-lift mathematics
  is wrong (foundational stop). *(It is currently proven, so we believe the kinematic
  core is sound — is there a hidden convention assumption that makes it vacuous?)*
- If the Bell-pair synchronization defect depends strongly on tie-breakers, we report
  **rule dependence** rather than chasing a universal "entanglement = curvature" slogan
  (relevant to Q3).
- If **no concrete super-Dirac symbol** exists (Q5/Q6), we freeze the graph branch as
  "related finite algebra," not a unified theory.
- If **null support and continuum scaling cannot coexist** for any operator (Q6), we
  retain the ontology as an *interpretation* of standard QM and record the tradeoff as
  a no-go / model-selection result — empirically equivalent, not new physics.
- If continuum mixing assumptions necessarily exclude nodes and near-massless states
  (Q1/Q2), we state only stopped/local theorems and do not advertise a global continuum
  process.

The decisive scientific gate ("G5"): only a concrete operator (Q5) with primitive null
support, correct Dirac/null symbol, the right squared Laplacian/curvature/Yukawa blocks
without double-counting mass, a controlled continuum/scaling limit, **and at least one
nontrivial constraint or prediction not inserted by hand** would turn this from an
empirically-equivalent reformulation of quantum mechanics into a candidate *new
dynamics*. Everything short of that is interpretation or finite mathematics.

---

## 5. The single most important question

If you answer only one thing: **Q5.** Does a concrete, Lorentzian-honest, finite
first-order operator exist whose square is exactly
`−□_null − 𝒞_diamond − 𝒯_frame + Φ²` with `Φ²` the sole mass block and the Plücker
mass appearing as the *kinetic symbol* rather than an additive term — and is the
required symbol/soldering identity `[D, M_f] ~ Σ_y a_xy (f(y)−f(x)) γ·p_xy` actually
achievable, or is there an index-theoretic / heat-trace obstruction forcing an extra
zero-order term? A construction, a known reference, or an impossibility argument would
each be decisive.

---

## 6. Frontier-analysis synthesis update (2026-06-25)

Two external analyses were folded into this briefing on 2026-06-25. They do not
close any G4/G5 research question, but they sharpen several open questions enough
to change the next targets.

### 6.1 Q5 super-Dirac: conditionally positive, with sharper blockers

The proposed finite operator should be treated as a concrete construction target:

```text
D_N = sum_i c(ell_i)(T_i - P_i)
D   = i D_N + Gamma_5 Phi
```

Under the expected compatibility hypotheses, the square has the desired discrete
Lichnerowicz/Weitzenbock shape:

```text
(i D_N + Gamma_5 Phi)^2
  = -D_N^2 + Phi^2 - i Gamma_5 [D_N, Phi].
```

The symmetric Clifford part of `D_N^2` is the null second-order propagation
term, the antisymmetric commutator part is the diamond-curvature term, and
nonparallel support projectors or vertex-varying Clifford frames produce the
frame-defect term. This means the exact finite square is plausible and
Lean-suitable.

The no-double-counting mass constraint is also consistent when interpreted by
operator order. `Phi^2` is the zero-order mass operator. Pluecker mass is the
kinetic principal-symbol invariant. On a flat mode, `D_N(xi) = gamma . P(xi)`,
so `D_N(xi)^2 = P(xi)^2`; if `Phi^2 psi = m^2 psi`, the on-shell equation is
`P(xi)^2 = m^2`. That equality is a dispersion relation, not a second additive
mass term.

The actual Q5 blockers are now sharper:

- **grading/sign audit:** if `Phi` is odd under the same `Gamma_5`, then
  `(Gamma_5 Phi)^2` may be `-Phi^2`, not `+Phi^2`; either the oddness belongs to
  a different internal grading or the convention needs an extra factor;
- **forced-endomorphism audit:** compute the finite analogue of the residual
  Lichnerowicz endomorphism, for example `Tr(D^2)` minus the kinetic and Yukawa
  pieces, and check whether a scalar/frame term remains that cannot be absorbed
  into `Phi^2`;
- **soldering audit:** positive null Markov probabilities cannot also be the
  continuum Dirac soldering coefficients, because
  `sum_i a_i ell_i^mu ell_i^nu` with `a_i >= 0` is positive semidefinite on real
  covectors and cannot equal the indefinite Lorentz metric.

The soldering obstruction does not kill the program. It says the hidden-process
probability layer and the Dirac-symbol coefficient layer must be separated. The
candidate exits are signed or complex operator coefficients, dual null coframes,
or a doubled/Krein advanced-retarded construction.

### 6.2 Q6/Q7 locality, covariance, and natural dilation

Do not state a broad "covariance implies nonlocality" theorem without caveats.
The stricter null-strand requirement is sharper: primitive-null-only, positive
finite-valence coefficients cannot reconstruct the continuum Dirac symbol by the
positive-semidefinite obstruction above. On Poisson sprinklings, exact Lorentz
covariance tends to push neighbor selection toward nonlocal tails because
invariant light-cone neighborhoods have noncompact boost orbits. On regular
complexes, locality is easier but covariance and chirality audits reappear.

For Q7, a useful naturality contract is a functor from decorated causal graphs to
finite Krein modules, together with a bounded-radius null-local operator on the
enlarged module and natural inclusion/projection maps whose compression gives the
effective operator. To rule out trivial encodings, require uniform local fiber
dimension under refinement, functoriality under induced subgraphs, covariance,
and graph-size-independent continuum estimates. A plausible no-go route is that
bounded-dimension, gapped local dilations tend to produce exponentially decaying
effective couplings after compression, while covariant causal-set effective
operators often require power-law tails. This remains conjectural but is sharper
than the earlier "no natural dilation" question.

### 6.3 Q1/Q2 analytic guidance

For Q1, the clean finite theorem is ordinary irreducible finite Markov-chain
mixing. Use a reversible Poincare/Dirichlet-form estimate when possible, and a
hypocoercive `S + A` estimate when transport is included. The mass-gap relation
should be conditional, not universal: one can keep a gap fixed in the timelike
interior unless additional physical hypotheses force collapse of the invariant
law, vanishing of a Compton-rate scale, or disconnection at the massless boundary.

For Q2, the honest first theorem is stopped/local. Work on `{rho >= epsilon}`,
prove equivariance and nonexplosion up to the exit time, and then study
`epsilon -> 0`. Whether the nodal set is absorbing, reflecting, sticky,
inaccessible, or polar depends on weighted capacity. A Muckenhoupt-type
condition such as `A_2` near the nodal set is a plausible regularity criterion;
without such a criterion, the theorem should explicitly stop at the node
boundary.

### 6.4 Q3/Q4 operational framing

For Q3, the flatness half is standard: a hidden transport rule is a functor from
the path groupoid of the cut complex to kernels or linear maps, and zero
elementary-diamond defect gives homotopy-invariant transport when the diamonds
generate the path-homotopy relation. The forcing half should remain conditional:
Bell-violating correlations force failure of at least one locality,
outcome-independence, parameter-independence, positivity, or
measurement-independence hypothesis; they do not by themselves force curvature
as a state-only invariant.

For Q4, a passive phase is not a clock. The record must be relational and
gauge-invariant, such as a closed Wilson-loop trace or an open-path holonomy
compared with a reference holonomy transforming at the same endpoints. In a
null-stepping model, the microscopic proper time on each segment is zero, so the
readout can track step/affine count or relative phase; proper time appears only
as a calibrated coarse-grained functional plus an ergodic theorem.

### 6.5 Q8 and formalization consequences

The quantum-marginal/entanglement-polytope route can at best provide kinematic
inequalities or allowed regions for spectra. It does not select observed Yukawa
ratios without an additional variational principle, symmetry-breaking rule,
distinguished internal state, or equivalent extra data.

For F1, the most formalization-friendly finite Markov-chain strong-law route is
likely a Poisson-equation decomposition on the zero-mean subspace:

```text
(I - P) g = f - pi f.
```

Then express additive sums as a bounded martingale difference plus telescoping
terms and use spectral-gap/Borel-Cantelli estimates. For F2/F3, keep finite graph
Laplacian approximants as the trusted Lean core while continuum weighted
Dirichlet-form and SDE statements remain external analytic hypotheses. For F4,
the minimal finite Krein API is now high priority: define a fundamental symmetry
`J`, indefinite form `[u,v] = <J u, v>`, `J`-adjoint
`A^sharp = J A^dagger J`, `J`-self-adjointness, and closure lemmas for sums,
block operators, Clifford symbols, and the `D^2` expansion.

### 6.6 Second Q5 refinement: diagonal null soldering fails, dual soldering survives

A further analysis sharpens the Q5 symbol question. The original diagonal null
symbol

```text
D_N = sum_i b_i c(ell_i) nabla_i
```

where the Clifford coefficient and the finite-difference direction use the same
null vector `ell_i`, cannot be the exact continuum Dirac soldering operator in
4D, even with signed or complex scalar coefficients. In the continuum symbol,
the induced cotangent endomorphism is

```text
A xi = sum_i b_i xi(ell_i) ell_i^flat.
```

Its trace is

```text
tr(A) = sum_i b_i ell_i^flat(ell_i) = sum_i b_i g(ell_i, ell_i) = 0,
```

because every `ell_i` is null. But the identity on `T^*V` has trace `4`.
Therefore `A` cannot be the identity. This is stronger than the earlier
positive-weight obstruction: the diagonal `c(ell_i) nabla_{ell_i}` ansatz fails
as a Dirac soldering symbol even before positivity is imposed.

The corrected construction keeps primitive null support but decouples the
Clifford coefficient from the shift direction. Choose null edge directions
`ell_a` and covectors `alpha^a` satisfying the dual-soldering identity

```text
sum_a alpha^a tensor ell_a = I,
equivalently xi = sum_a xi(ell_a) alpha^a.
```

Then define

```text
D_sol = sum_a c(alpha^a) nabla_a.
```

The commutator has the desired first-order symbol:

```text
h^{-1} [D_sol, M_f] -> c(df).
```

The graph support remains primitive-null because every finite difference is
still along a null edge. What changes is the Clifford/soldering coefficient.

The clean tetrahedral model uses four future-null directions `ell_A = (1, n_A)`,
with the `n_A` the regular tetrahedron vertices in the observer rest frame. Their
Gram matrix satisfies

```text
G_AA = 0,
G_AB = 4/3 for A != B,
G^AA = -1/2,
G^AB = 1/4 for A != B.
```

Set

```text
alpha^A = sum_B G^AB ell_B^flat,
```

so that `alpha^A(ell_B) = delta^A_B`. The resulting operator is

```text
D_tet = sum_A c(alpha^A) nabla_A
      = sum_A,B G^AB c(ell_B^flat) nabla_A.
```

This becomes the preferred replacement for the failed diagonal proposal:

```text
failed: sum_A c(ell_A) nabla_A
target: sum_A,B G^AB c(ell_B^flat) nabla_A.
```

With `C_a = c(alpha^a)`, the finite square target becomes

```text
D_N^2 = Box_null + C_diamond + T_frame,
```

where

```text
Box_null  = 1/4 sum_a,b {C_a, C_b} {nabla_a, nabla_b},
C_diamond = 1/4 sum_a,b [C_a, C_b] [nabla_a, nabla_b],
T_frame   = sum_a,b C_a [nabla_a, C_b] nabla_b.
```

Then, under the grading hypotheses

```text
Gamma_5 C_a = -C_a Gamma_5,
[Gamma_5, nabla_a] = 0,
[Gamma_5, Phi] = 0,
```

the desired super-Dirac identity is

```text
D^2 =
  -Box_null
  -C_diamond
  -T_frame
  +Phi^2
  -i Gamma_5 sum_a C_a [nabla_a, Phi].
```

This preserves the no-double-counting conclusion. `Phi^2` remains the only
zero-order mass block; the kinetic symbol squares to the Lorentzian quadratic
form through the dual-soldered covector `sum_a lambda_a(xi) alpha^a`.

### 6.7 Consequences for Q6/Q7 and finite dynamics

The Q6/Q7 property matrix should now distinguish four operators:

| operator | primitive null support | Dirac symbol | retarded | spectral/Krein audit |
|---|---:|---:|---:|---:|
| `sum c(ell_a) nabla_a` | yes | no | yes | maybe |
| `sum c(alpha^a) nabla_a` | yes | yes | yes | not self-adjoint alone |
| symmetric two-way finite difference | yes | yes | no | likely yes |
| retarded/advanced doubled operator | yes blockwise | yes | yes blockwise | likely yes |

The natural dilation candidate is therefore not an arbitrary Stinespring-style
encoding, but the minimal retarded/advanced doubling

```text
D_double = [[0, D_-],
            [D_+, 0]].
```

This keeps bounded ancilla dimension `2`, is local blockwise, and is functorial
for graph embeddings preserving labeled null edges and their reverse/advanced
partners.

For Q1, the continuous-time finite-chain strong law can be stated with a
Poisson-equation proof. Given an irreducible finite generator `Q`, invariant law
`pi`, and bounded vector observable `f`, solve

```text
-Q g = f - pi f
```

on the zero-mean subspace. Then

```text
M_t = g(X_t) - g(X_0) - integral_0^t Qg(X_s) ds
```

is a martingale, and

```text
integral_0^t (f(X_s) - pi f) ds = g(X_0) - g(X_t) + M_t.
```

After division by `t`, the bounded endpoint term vanishes and `M_t/t -> 0` when
the quadratic variation grows at most linearly. This gives the pathwise
coarse-motion theorem

```text
t^{-1} integral_0^t k(X_s) ds -> E_pi[k] = U
```

for a finite continuous-time null-direction process.

For Q2, the stopped weighted-diffusion target can be sharpened near nodes. For

```text
E(f,g) = kappa integral_{S^2} <grad f, grad g> rho d sigma
```

the formal generator is

```text
L f = kappa rho^{-1} div(rho grad f)
    = kappa (Delta f + grad log rho . grad f).
```

Work up to the exit time `tau_epsilon = inf {t : rho(X_t) <= epsilon}`. Near a
node with normal distance `r` and `rho ~ r^alpha`, a radial approximation has
effective Bessel dimension

```text
delta = d_perp + alpha.
```

The node is inaccessible in this approximation when `delta >= 2`. This supports
the existing stopped/local stance while giving a concrete capacity-style
criterion to investigate.
### 6.8 Physical consequence map from the super-Dirac square

A further analysis adds useful consequences downstream of the operator definition.
+It overlaps with the Q5 square program, but its main value is different: it
+identifies exact finite theorem clusters that could turn the operator from a
+kinematic unifier into a source of mass, spin, topology, defects, and action
+principles.
+
+The organizing hierarchy is:
+
+```text
+one-edge data  -> D   -> propagation and universal causal symbol
+two-edge data  -> D^2 -> mass, oriented area, spin coupling, curvature
+three-edge data       -> associators, higher curvature, exceptional sectors
+```
+
+High-confidence finite consequences:
+
+- **Null-pair mass and bivector area are two projections of one invariant.** For
+  future-null `p` and `q`, the pair mass satisfies `m_pq^2 = (p+q)^2 = 2 p.q`,
+  while the simple bivector `B = p wedge q` satisfies
+  `B_mn B^mn = -1/2 m_pq^4` in mostly-minus signature, and the dual pairing
+  vanishes for a simple bivector. The scalar Clifford projection gives the
+  Pluecker mass contribution; the antisymmetric projection retains oriented area
+  data.
+- **Spin coupling is the oriented remainder of the mass theorem.** The curvature
+  term in `D^2` has Pauli/Weitzenbock form with coefficient fixed by the Clifford
+  algebra. In a Dirac-like electromagnetic limit, the diamond-curvature
+  normalization should reproduce the minimal `g = 2` spin coupling. A wrong
+  coefficient becomes a falsifiable normalization test.
+- **The principal symbol encodes a discrete equivalence principle.** If the
+  first-order symbol is universal and the Yukawa block is lower order, then all
+  internal species share the same microscopic null-edge support and causal cone.
+  Mass changes phase and coarse propagation, not the primitive one-edge causal
+  relation. Violations are localized to species-dependent edge symbols,
+  Lorentz transports, nonminimal curvature-Yukawa couplings, or observer-channel
+  feedback.
+- **Finite mass-shell matching is exact linear algebra.** In a flat patch with
+  constant `Phi`, a decomposition `D^2 = -K tensor I + I tensor M^2` implies that
+  `ker D^2` is the direct sum over matching eigenspaces of `K` and `M^2`.
+  This suggests spectral locking: physical massive modes occur at intersections
+  of geometric and internal spectra. It is explanatory only if both spectra are
+  independently constrained.
+- **The Hilbert/Krein envelope has supersymmetric-quantum-mechanics structure.**
+  For `Q = [[0, A^dagger], [A, 0]]`, nonzero spectrum is paired between
+  `A^dagger A` and `A A^dagger`, while zero-mode imbalance is the index of `A`.
+  This gives a natural finite topological sector without implying spacetime
+  supersymmetry.
+
+Constructive but more speculative consequences:
+
+- **Matter as defects.** Domain walls or defects in `Phi`, an Albert frame, or an
+  internal embedding may support localized chiral modes. A finite chain with a
+  sign-changing mass is the first pilot. Periodic finite systems generally
+  produce wall/anti-wall partners, so unpaired Weyl modes need boundary,
+  anomaly-inflow, or extra internal-direction mechanisms.
+- **Curvature can protect or destroy zero modes.** A finite Weitzenbock form
+  `H = nabla^dagger nabla + V` gives direct Rayleigh bounds: if `V >= epsilon I`,
+  then `ker H = 0`; negative curvature in a spin sector can close the gap and
+  permit zero modes.
+- **Anomaly cancellation becomes an operator-level rejection test.** A chiral
+  internal sector must pass a finite spectral-flow or anomalous-phase test under
+  gauge, Albert-frame, or diamond-holonomy loops. Correct-looking
+  representations are not enough without index cancellation.
+- **Strict null locality and exact effective chirality may require a hidden-sheet
+  dilation.** A local block operator can yield a nonlocal effective visible
+  operator through a Schur complement `D_eff = D_vis - B D_hid^{-1} C`. This
+  supports microscopic null locality with nonlocal continuum-correct effective
+  chirality.
+- **A finite spectral action is the dynamical upgrade.** For a positive envelope
+  `H = D^sharp D`, traces such as `Tr H` and `Tr H^2` should decompose into
+  graph propagation, diamond-curvature squares, Higgs kinetic terms, Higgs
+  quartic terms, and mixed frame-curvature terms. This is the gate from operator
+  kinematics to a unified action.
+- **The Higgs derivative belongs to superconnection curvature.** The term
+  `[nabla, Phi]` should be viewed as part of `A_super^2 = F + Gamma_5 nabla Phi
+  + Phi^2`, not as an inconvenient leftover. This makes flavor transport a
+  holonomy problem.
+- **Octonionic associators belong on 3-cells.** Ordinary curvature measures
+  two-step diamond disagreement; octonionic nonassociativity first appears in
+  triple products and naturally belongs to oriented triples or 3-cells. The safe
+  operator-valued definition should use real-linear left multiplication by the
+  associator, keeping cubic scalar invariants and oriented higher-flux invariants
+  distinct.
+- **Spectral dimension is a model-selection diagnostic.** The positive envelope
+  `H` can define a finite heat trace `Z(t) = Tr exp(-tH)` and scale-dependent
+  spectral dimension `d_s(t) = -2 d log Z(t) / d log t`, testing whether a graph
+  family has an intermediate four-dimensional phase.
+
+Suggested theorem clusters to add to the open registry:
+
+```text
+nullPair_massSq_eq_two_inner
+nullPair_bivectorNormSq_eq_neg_half_massFourth
+nullPair_bivector_dualPairing_eq_zero
+nullPair_cliffordProduct_eq_scalar_add_bivector
+principalSymbol_independentOfInternalState
+speciesUniversal_oneEdgeSupport
+kernel_tensorDifference_eq_matchingEigenspaces
+massShellMultiplicity_eq_sum_matchingMultiplicities
+superDirac_nonzeroSpectrum_paired
+superDirac_zeroModeImbalance_eq_index
+zeroMode_absent_of_positiveWeitzenbockPotential
+finiteSpectralFlow_def
+spectralFlow_eq_signedZeroCrossings
+localDilation_effectiveOperator_eq_schurComplement
+trace_superDiracFourth_curvatureSq
+trace_superDiracFourth_higgsKinetic
+octonionicThreePathAssociator_alternating
+spectralDimension_from_heatTrace
+```
+
+Priority judgment: the exact finite algebra targets should come first
+(`nullPair_*`, spectral matching, SUSY-QM pairing, Schur complement). Defect,
+anomaly, spectral-action, and octonionic 3-cell work are promising but should be
+kept as separate speculative-to-conditional tracks until the dual-soldered
+operator core is trusted.
### 6.9 ChatGPT Pro refinement: normalization, Higgs grading, and proof package

A ChatGPT Pro pass confirmed the dual-soldered path and sharpened several
proof-critical details.

First, the tetrahedral frame should be formalized in the observer-normalized
unit version before using any scaled null-vector witness:

```text
s_1 = ( 1,  1,  1),  s_2 = ( 1, -1, -1),
s_3 = (-1,  1, -1),  s_4 = (-1, -1,  1),
n_A = s_A / sqrt(3),
ell_A = (1, n_A).
```

Then `ell_A` is future null and normalized against the rest observer `e_0` by
`e_0 . ell_A = 1`. Its Gram matrix is

```text
G_AA = 0,
G_AB = 4/3 for A != B,
G^{-1}_AA = -1/2,
G^{-1}_AB = 1/4 for A != B.
```

The dual-soldering covectors are

```text
alpha^A = sum_B G^{AB} ell_B^flat
        = (1/4) dt + (3/4) n_A . d x,
```

and satisfy `alpha^A(ell_B) = delta^A_B`, hence
`xi = sum_A xi(ell_A) alpha^A`. If using scaled vectors
`L_A = (sqrt(3), s_A) = sqrt(3) ell_A`, the dual covectors must also scale:
`beta^A = alpha^A / sqrt(3)`. Mixing `alpha` with `L`, or `beta` with `ell`,
rescales the symbol and is a convention error.

Second, the graded square requires a precise product-triple-style convention.
Use separate objects:

```text
Gamma_s      = spacetime chirality,
chi_E        = internal finite grading,
epsilon_form = form/cochain degree, only if a Hodge-type complex is used.
```

For

```text
D_N = sum_a C_a nabla_a,
C_a = c(alpha^a),
D = i D_N + Gamma_s Phi,
```

the desired sign follows from

```text
Gamma_s^2 = 1,
{Gamma_s, C_a} = 0,
[Gamma_s, nabla_a] = 0,
[Gamma_s, Phi] = 0,
[C_a, Phi] = 0.
```

Then

```text
D^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi].
```

The trap is explicit: if `Phi` anticommutes with the same `Gamma_s`, then
`(Gamma_s Phi)^2 = -Phi^2`. The Higgs/Yukawa operator may be odd, but that
oddness should be with respect to the internal grading `chi_E`, not the same
spacetime chirality used in `D = i D_N + Gamma_s Phi`.

Third, the mass-shell sign must be named. In mostly-minus convention, decide
whether `Box_null` denotes the kinetic mass-shell operator or the analytic
D'Alembertian. To get `P^2 = m^2` from `-Box_null + Phi^2 = 0`, the plane-wave
symbol of `Box_null` must be `P^2`; otherwise the sign is wrong.

Fourth, the finite square/frame term should be used as an audit:

```text
T_frame = sum_a,b C_a [nabla_a, C_b] nabla_b.
```

It vanishes under the finite tetrad postulate `[nabla_a, C_b] = 0`. It is
physical when it is the discrete spin-connection/tetrad-variation remnant. It is
contamination if the frame varies but the transport does not carry the Clifford
frame; after rescaling finite differences, `O(1)` frame jumps over `h`-edges can
blow up like `O(h^{-1})`.

Fifth, the next proof package should prioritize:

```text
1. tetrahedral dual frame with the unit observer-normalized convention;
2. diagonal null trace obstruction;
3. dual-soldering commutator/symbol theorem;
4. graded super-Dirac square with the Higgs sign guardrail.
```

Secondary but useful finite targets are spectral mass-shell matching,
Schur-complement local dilation, an SSH/Jackiw-Rebbi finite defect pilot, and the
finite CTMC Poisson-equation SLLN route.

### 6.10 Literature leads mapped to the open blockers (2026-06-26)

A Neo4j + arXiv/INSPIRE search pass on 2026-06-26 located concrete prior art for
the super-Dirac core and the prediction gate. Newly curated items were added to
the `null-edge-lit` Zotero collection (`9W59V3K9`) and the Neo4j paper graph
(embedded, semantically searchable via `Scripts/lit/neo4j_paper_search.py`);
lane tags in brackets. Items marked "already curated" were in the graph before
this pass.

Closest existing constructions (start here):

- Bianconi, *Dirac gauge theory for topological spinors in 3+1 networks*,
  arXiv:2212.05621 [super-dirac, graph-dirac]. Topological spinor =
  0-cochain (+) 1-cochain; the anticommutator and commutator of the discrete
  Dirac operators give the metric/curvature and the magnetic-field terms, and
  the non-relativistic limit yields the correct gyromagnetic moment. Directly
  templates the D^2 block structure (#1), the grading bookkeeping (#2), and the
  "is g=2 forced or inherited" prediction (Q5/P4).
- Post, *First order approach and index theorems for discrete and metric
  graphs*, arXiv:0708.3707 [graph-dirac, index-anomaly]. Supersymmetric
  (doubled) graph Dirac with decorated vertex spaces = subspaces of C^d (the
  internal grading), plus a graph index theorem (metric index = discrete
  index). Templates the Krein-doubled audit (#4), the anomaly/index test (#10),
  and the SUSY-QM pairing cluster in section 6.8.
- Casiday, Contreras, et al., *Laplace and Dirac Operators on Graphs*,
  arXiv:2203.02782 [graph-dirac]. Graph Clifford algebras plus gluing
  identities for the lattice Dirac operator; the most directly
  Lean-formalizable finite-Clifford API for the dual-soldered core.

Krein / Lorentzian honesty (#4):

- van den Dungen, *Krein spectral triples and the fermionic action*,
  arXiv:1505.01939 [krein-lorentzian, super-dirac]. Cleanest Krein template;
  the fermionic action recovers the QED/EW/SM Lagrangians.
- van den Dungen, *Families of spectral triples and foliations of spacetime*,
  arXiv:1711.07299 [already curated]. Reconstructs the total Dirac operator
  from a family on spacelike hypersurfaces -- the existing anchor for the
  continuum-scaling bridge (#5) and the foliated-synchronization story (Q3).
- Devastato, Farnsworth, Lizzi, Martinetti, *Lorentz signature and twisted
  spectral triples*, arXiv:1710.04965 [krein-lorentzian]. Twist yields the
  Krein space from Wick rotation; a lighter alternative route.
- Bizi, Brouder, Besnard, arXiv:1611.07062 [already curated]; Bizi thesis
  arXiv:1812.00038 [krein-lorentzian]. Indefinite Clifford algebras, space/time
  dimension mod 8, and an explicit fermion-doubling resolution; comprehensive
  reference for the Krein audit.

D^2 endomorphism / forced-term audit (#3):

- Ackermann, Tolksdorf, *The generalized Lichnerowicz formula*,
  arXiv:hep-th/9503153 [already curated]. The
  `D^2 = nabla^dagger nabla + curvature-endomorphism` expansion; the reference
  for whether a residual scalar/frame term survives (the `T_frame` /
  forced-endomorphism audit).

Continuum-limit / nonlocality obstruction (#5, Q6):

- Aslanbeigi, Saravani, Sorkin, *Generalized causal-set d'Alembertians*,
  arXiv:1403.1622 [already curated]. Lorentz-invariant, retarded, nonlocal; the
  4D causet d'Alembertian is UNSTABLE (the 2D one is stable). Treat as a
  falsification probe for the continuum limit; it motivates the
  retarded/advanced Krein doubling.
- Sorkin, *Scalar field theory on a causal set in histories form*,
  arXiv:1107.0698 [causal-set]. The d'Alembertian as a generalized inverse of
  the retarded Green function; pairs with arXiv:1403.1622 for the Q6 locality
  matrix.

Prediction gate (#7 / G5):

- Chamseddine, Connes, Marcolli, *Gravity and the standard model with neutrino
  mixing*, arXiv:hep-th/0610241 [spectral-action, prediction-gate]. The
  canonical spectral-action predictions (gauge-coupling relations, the Yukawa
  sum rule, the Higgs-mass relation). Both the precedent and the cautionary
  tale (the ~170 GeV miss) for a "prediction not inserted by hand."
- Already in the tree: *Spin on a 4D Feynman Checkerboard*, arXiv:1610.01142
  [checkerboard] -- an explicitly doubling-free discrete chiral scheme;
  relevant to #10 and the prediction gate.

Search gaps (no clean hit; flagged from knowledge, verify before relying):

- #9 finite-Markov-chain pathwise SLLN: Glynn and Meyn, *A Liapounov bound for
  solutions of the Poisson equation*; Meyn and Tweedie, *Markov Chains and
  Stochastic Stability* (the `(I - P) g = f - pi f` + martingale-CLT route of
  section 6.7). These are not arXiv-first; confirm on INSPIRE/MathSciNet.
- #8 continuum process near nodes: no new prior art beyond the
  weighted-Dirichlet-form / Muckenhoupt-A_2 angle of section 6.3 -- consistent
  with the stopped/local stance.

### 6.10 Prediction gate clarification: reconstruction is valuable, rigidity is extra

A further discussion sharpened the status of empirical predictions. The key
point is not that the program must predict new numbers to be scientifically
valuable. A null-edge formalism that exactly reconstructs known quantum physics
with a clearer finite causal/Dirac architecture would already be a meaningful
mathematical and interpretive result. New predictions are an additional, harder
rigidity goal.

The claim boundary should therefore be split:

```text
G5a reconstruction success:
  a concrete null-edge / dual-soldered / Krein super-Dirac architecture
  reproduces the known Dirac, gauge, Higgs/Yukawa, and Born-equivariant physics
  with clean finite foundations and controlled scaling.

G5b rigidity / prediction success:
  the allowed finite structures map into a proper lower-dimensional subset of
  continuum EFT parameter space, forcing at least one relation or exclusion not
  inserted by hand.
```

Born-equivariant hidden-variable dynamics is not expected to generate new
laboratory predictions by itself. If the hidden law is exactly Born-equivariant,
the operator/Hamiltonian is the standard one, and measurements are read from the
same macroscopic pointer variables, then the equilibrium statistics are exactly
ordinary quantum statistics. This is a feature for reconstruction, not a defect.
New empirical content must come from one of the following:

```text
operator/spectral-geometry rigidity;
fixed finite-cutoff corrections;
non-equilibrium hidden-variable initial conditions;
modified measurement dynamics;
anomaly/index constraints that reject otherwise possible internal sectors.
```

The cleanest route is operator/spectral rigidity, not hidden-variable
disequilibrium. In moduli language, let `M_A` be the moduli space of finite
models satisfying the null/Krein/spectral axioms and let

```text
F : M_A -> M_EFT
```

send a finite model to its continuum effective-field-theory parameters. A genuine
prediction requires `F(M_A)` to lie in a proper subspace of `M_EFT`; equivalently,
the finite construction must have fewer effective knobs than the target EFT
sector after quotienting field redefinitions and convention choices.

Prediction checklist:

1. **Frozen input:** finite algebra, graph rule, Clifford normalization, spectral
   function class, cutoff prescription, and continuum matching are fixed before
   data comparison.
2. **Parameter deficit:** the finite model has fewer continuous knobs than the
   target EFT sector.
3. **Field-redefinition audit:** the claimed relation survives rescaling, basis
   changes, and equivalent parametrizations.
4. **RG survival:** the relation is stated at a scale and run to observables with
   controlled thresholds.
5. **No hidden absorption:** the relation cannot be moved into `f`, `Lambda`,
   `Phi`, link weights, graph ensemble, or extra hidden fields.
6. **Falsifiable width:** the predicted range is narrower than current
   experimental/theoretical uncertainty.

Prediction ledger:

| result | current classification |
|---|---|
| Timelike motion as averaged null motion | kinematic representation |
| Pluecker mass identity | kinematic identity |
| Diagonal null-symbol obstruction | internal architecture constraint |
| Dual-soldered Dirac symbol | consistency theorem |
| Super-Dirac square | exact finite algebra theorem |
| `Phi^2` sole mass block | consistency condition |
| `P(xi)^2 = m^2` | mass-shell matching, not prediction |
| `g = 2` from Clifford square | inherited Dirac normalization unless Pauli counterterms are forbidden |
| Absence of `O(E/Lambda)` Lorentz-violation terms | potential prediction if exact covariance forbids them |
| Gauge group | potential prediction only if finite algebra is forced |
| Three generations | not currently forced |
| Higgs quartic or mass relation | potential prediction only if `Phi`, `f`, `Lambda`, thresholds, and extra scalars are fixed independently |

The noncommutative-geometry spectral-action precedent is useful but cautionary:
a Dirac/spectral-action framework can unify geometry, gauge, Higgs, and Yukawa
data, but the finite Dirac operator, spectral function, cutoff, threshold fields,
and internal algebra can also become storage locations for the Standard Model
parameters. In this program, reproducing `g = 2` is best treated as a
normalization consistency check unless the null-diamond axioms also forbid an
independent Pauli operator at the cutoff.

The cheapest pressure tests before phenomenology are:

```text
flat-symbol / fermion-doubling test;
graded square sign audit;
Pauli coefficient normalization on one U(1) diamond;
minimal spectral-action trace on a periodic null-diamond complex;
frame-term scaling test;
anomaly cancellation of the proposed internal sector;
parameter-moduli audit;
Lorentz-dispersion expansion through O(h^2).
```

Most important refinement: even if G5b never lands, G5a can still be a strong
result. A clean finite null-edge formalism reproducing known physics would be a
valuable reconstruction. The docs should avoid treating lack of new predictions
as a failure of the whole program; it is only a failure of the stronger rigidity
claim.

### 6.11 Commuting-square and retarded-symbol refinement

A further ChatGPT Pro analysis sharpens how to evaluate the super-Dirac program.
The key methodological update is that the "super-Dirac core" should not be
judged as one monolithic theorem. It should be split into commuting tests:

```text
D_h  --finite square-->  D_h^2
 |                         |
 h -> 0                    h -> 0
 v                         v
D_cont --Lichnerowicz--> D_cont^2
```

This yields three distinct targets:

```text
finiteSuperDiracSquare       -- exact finite algebra;
dualSolderedSymbolLimit      -- symbol/continuum asymptotic;
squareLimitCompatibility     -- the hard continuum bridge.
```

The finite square can be correct while the continuum limit fails. Likewise, the
first-order symbol can converge correctly while the square develops an unwanted
frame, nonmetricity, or zero-order residue. Only the first target is fully
near-term trusted Lean; the second should be handled by finite affine/symbol
proxies where possible; the third remains a G5 scaling problem.

#### Retarded-symbol / no-naive-doubling diagnostic

The most actionable new finite test is the flat periodic symbol of the retarded
operator. For a translation-invariant dual-soldered patch,

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h,
C_a = c(alpha^a),
q_a = h xi(ell_a).
```

If the `alpha^a` form a basis and the Clifford map is injective on covectors,
then

```text
D_+(q) = 0  iff  exp(i q_a) - 1 = 0 for every a,
```

so the Brillouin torus has only the continuum zero `q_a = 0 mod 2 pi`. By
contrast, the symmetric derivative

```text
D_sym(q) = sum_a C_a sin(q_a) / h
```

has zeros whenever each `q_a` is `0` or `pi`, producing the usual `2^d` naive
zero pattern. This suggests a precise Nielsen-Ninomiya evasion route:
retardedness removes naive sine-derivative doublers, while the price is ordinary
Hilbert non-self-adjointness, to be audited by the retarded/advanced Krein
double.

This should become an early finite diagnostic, before expensive continuum or
phenomenology work.

#### Frame compatibility tests

The frame term should be treated as a discrete tetrad-postulate defect:

```text
T_frame = sum_a,b C_a [nabla_a, C_b] nabla_b.
```

The clean finite tetrad postulate is

```text
[nabla_a, C_b] = 0 for all a,b,
```

or, with explicit spin transport and label rotation, a covariance condition of
the form

```text
U_a C_b(target) U_a^{-1} = sum_c R_ab^c C_c(source).
```

Recommended finite tests:

```text
frameTermVanishesUnderTetradPostulate;
metricCompatibilityFromCliffordAnticommutator;
curvatureIsCommutatorOfCompatibleConnection.
```

The metric-compatibility proxy is

```text
nabla_a {C_b, C_c} = 0.
```

If this fails, the defect is not merely curvature; it indicates nonmetricity or
inconsistent soldering. If metric compatibility holds and `[nabla_a,nabla_b]` is
nonzero, the remaining defect belongs in curvature/holonomy.

#### Dimension and covariance cautions

The tetrahedral frame is excellent for 3+1 dimensions but does not derive them.
It is the `d = s + 1 = 4` case of a general simplex construction. In `d`
spacetime dimensions, take `d` spatial simplex vertices with

```text
n_A . n_B = -1/(d-1) for A != B,
ell_A = (1, n_A),
ell_A . ell_B = d/(d-1) for A != B,
G^{-1} = -((d-1)/d) I + (1/d) J,
alpha^A = (1/d) dt + ((d-1)/d) n_A . d x.
```

Therefore `four null directions form a tetrahedron` is not a dimension-four
prediction. Dimension four would need a separate spectral-dimension,
anomaly/Krein, finite-algebra classification, or scaling theorem.

For Q6, the sharper pressure point is not the broad slogan "locality versus
Lorentz covariance." It is:

```text
finite valence + primitive null support + exact Lorentz covariance without an
extra local timelike/reference datum.
```

A particle strand may use its timelike barycenter `U` or observer `n` as physical
normalization data. A universal vacuum field operator needs either a dynamical
frame/tetrad, a randomized covariant structure, graph-derived local data, or an
explicitly accepted covariance limitation.

#### Mass-shell and prediction boundary

The mass-shell theorem remains exact finite linear algebra, not a mass
prediction:

```text
ker(-K tensor I + I tensor M^2)
  = direct sum over matching eigenspaces E_lambda(K) tensor E_lambda(M^2).
```

This proves the matching subspace once `K` and `M^2` are given. It does not
explain why the spectra match. A physics theorem still needs a constraint on the
finite geometry, a constraint on the internal algebra/Yukawa block, or a
variational/spectral-action rule coupling the two.

#### Probability and node-process refinements

For finite Markov strong laws, a regenerative-cycle route may be more Lean
friendly than continuous-time martingale theory. For finite irreducible
discrete-time chains, pick a recurrent state, decompose the path into i.i.d.
return cycles, and apply the existing i.i.d. strong law to cycle rewards and
cycle lengths. A CTMC can then be approached by uniformization where appropriate.

For near-node continuum dynamics, the right charter remains capacity theory:

```text
Global process = stopped process + capacity/polarity theorem.
```

The Bessel proxy `delta = d_perp + alpha` remains the finite/analytic heuristic:
`delta >= 2` indicates node inaccessibility in the radial approximation.
### 6.12 Nielsen-Ninomiya evasion and null-frame source clarification

A further ChatGPT Pro analysis sharpens two architectural decisions.

#### Nielsen-Ninomiya route

The declared evasion route is:

```text
D_+ gives up ordinary single-layer Hilbert Hermiticity / anti-Hermiticity.
```

Retardedness comes first: the visible block is causal and one-sided,

```text
D_+ = sum_a C_a nabla_a^+,
nabla_a^+ = (T_a - I) / h.
```

Its non-Hermiticity is an algebraic consequence of retarded causal support, not
an ad hoc trick introduced merely to remove doublers. The Lorentzian repair is
then the Krein retarded/advanced double:

```text
A^sharp = J_0 A^dagger J_0,
D_- = D_+^sharp,
D_dbl = [[0, D_-], [D_+, 0]],
J_dbl = [[J_0, 0], [0, J_0]],
D_dbl^sharp = D_dbl.
```

This is an evasion hypothesis and finite Lorentzian audit mechanism, not yet a
solution to chiral Standard Model matter. The program must still pass branch
counting, Krein stability, and anomaly/index tests.

Assumption ledger for the flat periodic test:

| Nielsen-Ninomiya-type assumption | status |
|---|---|
| locality | kept |
| translation invariance | kept in flat test |
| finite Brillouin torus | kept |
| ordinary Hilbert Hermiticity / anti-Hermiticity | violated by `D_+` |
| chiral symmetry | must be specified |
| real dispersion / stable spectrum | not automatic |
| correct anomaly/index | not yet shown |

Required tests:

```text
retarded determinant branch count:
  det D_+(omega,k) = 0, count real/complex/low-energy branches and chirality;

doubled branch count:
  D_dbl^2 = diag(D_- D_+, D_+ D_-), check whether the double merely vectorizes;

gauge/anomaly test:
  retarded/Krein no-doubling does not replace anomaly cancellation.
```

Important warning:

```text
no naive Brillouin doublers != chiral gauge theory solved.
```

#### Source of the local null frame

There are two different frame questions and they must not be conflated.

For the hidden strand layer, a particle's timelike coarse direction `U` or an
observer/rest direction `n` may supply the local rest null fiber:

```text
strand layer: U supplies e_0 = U / sqrt(U^2).
```

This is particle state data, not a universal preferred frame.

For the universal field operator, a fixed observer direction is not acceptable
unless a preferred foliation is explicitly declared as physical. The safest
continuum interpretation is a dynamical tetrad/spin frame:

```text
e_I(x) = local tetrad,
ell_A(x) = e_0(x) + n_A^i e_i(x),
alpha^A(x) = (1/4) e^0(x) + (3/4) n_A^i e^i(x).
```

The tetrahedral null directions are then a local quadrature/soldering rule inside
the tetrad bundle, not a fixed spacetime frame.

A bare causal set or unlabeled graph probably cannot canonically supply a
finite-valence null frame without breaking Lorentz invariance. A graph can supply
the frame only if it is already decorated with:

```text
ell_a(x), alpha^a(x), spin transport U_a(x), edge scale h_a(x).
```

Thus the formalization object should be a decorated null-tetrad graph. The later
physics question is whether the decoration is dynamical, natural, gauge data, or
tuned input.

Null-frame source matrix:

| source | good for | risk | status |
|---|---|---|---|
| observer/time direction `n` | hidden strand, rest-sphere process | preferred frame for universal field | use only as particle/gauge data |
| dynamical tetrad `e_I(x)` | universal field operator | tetrad is input unless dynamically derived | best continuum route |
| random covariant structure | bare causal set/background independence | no canonical finite valence; often nonlocal | best bare-graph route, hard |
| graph data alone | finite formalism | decorations may hide geometry | acceptable only as decorated graph |

Recommended wording:

```text
Finite formalization: decorated null-tetrad graphs.
Continuum field interpretation: decoration supplied by a dynamical tetrad and spin connection.
Bare causal-set ambition: do not demand finite valence unless a new theorem beats the sprinkling obstruction.
```
## 6.13 Strategy memo synthesis: finite-core paper, determinant branch test, and claim boundaries

The newest strategy memo sharpens the program's near-term target: the publishable finite core should be framed as a **dual-soldered null-edge Dirac algebra**, not as a completed physical theory. This is a positive refinement rather than a retreat. The finite construction can be valuable if it proves a clean primitive-null algebra with the correct leading Dirac symbol and square, while keeping canonicity, continuum scaling, chirality, and prediction claims explicitly open.

### 6.13.1 Architectural correction: primitive-null support, dual-covector soldering

The graph operator should be stated as

```text
D_+^h = sum_a c(alpha^a) (T_a - I) / h.
```

The null support lives in the finite difference directions `ell_a`; the Dirac soldering lives in the dual covectors `alpha^a`. The diagonal attempt

```text
sum_a c(ell_a^flat) nabla_{ell_a}
```

should now be treated as dead for continuum Dirac soldering. The trace obstruction is decisive: any diagonal map of the form `sum_a b_a ell_a^flat tensor ell_a` has trace zero because each `ell_a` is null, whereas the identity on cotangent space has trace `d`.

This means the honest object is not a bare null-walk Dirac operator, but a dual-soldered operator: null-edge motion supplies the primitive finite support, while a dual null-solder frame supplies the Clifford symbol.

### 6.13.2 Simplex null-solder frame and normalization guardrail

For spacetime dimension `d = s + 1` in mostly-minus signature, take spatial simplex vertices `n_A` with

```text
n_A . n_A = 1,
n_A . n_B = -1 / (d - 1) for A != B,
sum_A n_A = 0,
ell_A = (1, n_A).
```

Then `ell_A` are future null, with Gram matrix

```text
G = d/(d - 1) * (J - I),
G^{-1} = -(d - 1)/d * I + 1/d * J.
```

The dual covectors are

```text
alpha^A = sum_B G^{AB} ell_B^flat
        = (1/d) dt + ((d - 1)/d) n_A . dx,
```

and satisfy

```text
alpha^A(ell_B) = delta^A_B,
xi = sum_A xi(ell_A) alpha^A.
```

For `d = 4`, this gives `G^{AA} = -1/2`, `G^{AB} = 1/4` for `A != B`, and

```text
alpha^A = 1/4 dt + 3/4 n_A . dx.
```

If the scaled vectors `L_A = sqrt(3) ell_A` are used, the dual covectors must be scaled by `1/sqrt(3)`. Mixing the unscaled `alpha^A` with the scaled `L_A`, or vice versa, silently rescales the Dirac symbol. This is now a first-class convention guardrail.

This construction does not derive four spacetime dimensions. It works for every `d >= 2` using a spatial `(d - 1)`-simplex, so dimension four remains input unless another theorem selects it.

### 6.13.3 Exact commutator theorem versus continuum symbol theorem

The finite commutator identity should be split into two claims.

For multiplication by `f`,

```text
[D_sol^h, M_f] psi(x)
  = sum_a c(alpha^a) (f(x + h ell_a) - f(x)) / h * T_a psi(x).
```

If `f` is affine on a flat patch, then the identity is exact:

```text
[D_sol^h, M_f] = c(df_x).
```

For smooth non-affine `f`, the statement is asymptotic:

```text
[D_sol^h, M_f] = c(df_x) + O(h).
```

The first is a finite affine-symbol theorem. The second is a continuum symbol-limit theorem and requires mesh, smoothness, transport, and convergence hypotheses. The docs should keep these labels separate.

### 6.13.4 Graded square: safe sign and grading hypotheses

The safe finite square theorem uses three distinct gradings:

```text
Gamma_s       = spacetime chirality,
chi_E         = internal finite grading,
epsilon_form  = cochain or form degree, if graph forms are used.
```

For

```text
D_N = sum_a C_a nabla_a,
C_a = c(alpha^a),
D = i D_N + Gamma_s Phi,
```

with

```text
Gamma_s^2 = 1,
{Gamma_s, C_a} = 0,
[Gamma_s, nabla_a] = 0,
[Gamma_s, Phi] = 0,
[C_a, Phi] = 0,
```

one gets

```text
D^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi].
```

The Higgs/internal mass block must be odd under `chi_E`, not under the same `Gamma_s`. If `Phi` anticommutes with `Gamma_s`, the mass term flips to `-Phi^2`, which is the dangerous sign error.

The null kinetic operator should be sign-normalized as a mass-shell operator. In mostly-minus signature, the analytic d'Alembertian has plane-wave symbol `-p^2`; for the squared equation `-Box_null + Phi^2 = 0` to imply `p^2 = m^2`, `Box_null` should have symbol `p^2`, equivalently `Box_null = -Box_an` in the continuum convention.

### 6.13.5 Frame term, tetrad postulate, and defect classification

The finite square decomposes as

```text
D_N^2 = Box_null + C_diamond + T_frame,
```

where

```text
Box_null  = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b},
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b],
T_frame   = sum_{a,b} C_a [nabla_a, C_b] nabla_b.
```

Thus

```text
D^2 = -Box_null - C_diamond - T_frame
      + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi].
```

The clean finite tetrad postulate is

```text
[nabla_a, C_b] = 0,
```

or, edgewise,

```text
U_a(x) C_b(y) U_a(x)^{-1} = C_b(x)
```

when labels are globally fixed. If local labels rotate, allow a rotation matrix among the `C_c`. Metric compatibility should be audited by `nabla_a {C_b, C_c} = 0`.

Failure modes split cleanly:

- If metric compatibility fails, the defect is nonmetricity or bad soldering.
- If metric compatibility holds but curvature commutators survive, the defect is curvature or holonomy.
- If edge parallelograms fail to close or antisymmetric displacement defects appear, the defect is torsion-like.
- If `C_b` jumps by order one across `h`-edges, then `T_frame` can contaminate the smooth limit at order `1/h`.

### 6.13.6 Krein double and Nielsen-Ninomiya evasion: legitimate route, not solved chirality

The clean evasion story is:

```text
Retardedness forces non-Hermiticity of D_+;
Lorentzian honesty is restored by a Krein retarded/advanced double.
```

The finite API should introduce

```text
J = J^dagger = J^{-1},
[u, v]_J = <u, J v>,
A^sharp = J A^dagger J.
```

Then prove the algebraic rules for `sharp`, define `D_- := D_+^sharp`, and set

```text
D_dbl = [[0, D_-], [D_+, 0]].
```

With block `J_dbl`, `D_dbl` is `J_dbl`-self-adjoint. This is a good finite theorem. It does not by itself guarantee positivity, unitary time evolution, real spectrum, a sensible spectral action, absence of runaway modes, anomaly cancellation, or a chiral Standard Model sector. The doubled square

```text
D_dbl^2 = [[D_- D_+, 0], [0, D_+ D_-]]
```

is supersymmetric-quantum-mechanics-like, but this is structural analogy, not physical supersymmetry.

### 6.13.7 Decisive correction: no-doubling test must be determinant-level

The memo's most important correction is that the no-doubling test cannot stop at coefficient-vector zeros.

On a flat periodic patch,

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h = c(p(q)),
p(q) = h^{-1} sum_a (exp(i q_a) - 1) alpha^a.
```

Because the `alpha^a` form a basis, `p(q) = 0` only when all `exp(i q_a) = 1`. This proves only that there are no scalar coefficient-zero doublers.

For a massless Lorentzian Dirac operator, the physical singularity condition is instead

```text
det D_+(q) = 0,
```

or equivalently

```text
p(q)^2 = 0.
```

Nonzero null `p(q)` still gives a nontrivial Clifford kernel. In the four-dimensional tetrahedral case, the Brillouin point

```text
q = (pi, pi, pi, 0)
```

has nonzero coefficient vector but `p(q)^2 = 0`. This is a high-momentum null Clifford singularity and a candidate doubler or cutoff pole.

The decisive finite test is therefore:

```text
solve det(i D_+(q) + Gamma_s Phi) = 0 over the Brillouin domain,
```

then classify connected components near `q = 0`, high-momentum real branches, complex-energy branches, kernel dimension and chirality on each branch, and behavior under Krein doubling. Retardedness alone proves no coefficient-zero doublers; it does not prove no determinant-level doublers.

### 6.13.8 Universal null frame: decorated null-tetrad graph

For a single hidden strand, a timelike barycenter or observer can normalize null directions. For a universal field operator, this would be a preferred observer unless explicitly declared. The better architecture is a dynamical tetrad or spin frame:

```text
ell_A(x) = e_0(x) + n_A^i e_i(x),
alpha^A(x) = 1/4 e^0(x) + 3/4 n_A^i e^i(x)
```

in four dimensions. The tetrahedron is then a local quadrature/soldering rule inside the tetrad bundle, not a global preferred frame.

A bare causal set should not be claimed to canonically supply a finite-valence null frame. The honest finite object is a decorated null-tetrad graph carrying

```text
V, E, ell_a(x), alpha^a(x), h_a(x), U_a(x), J_x,
Gamma_s, chi_E, Phi_x,
```

plus compatibility conditions. The claim is: given such a decorated causal/null-tetrad graph, the dual-soldered operator has the right finite algebra and leading symbol. The claim is not: a bare graph automatically gives a tetrad.

### 6.13.9 Scaling test order and commuting-square risk

The scaling program should be staged as follows:

1. Flat symbol test on a fixed decorated periodic graph.
2. Flat determinant/branch-count test for real and complex branches.
3. Curved tetrad test with smooth `e_I(x)` and spin connection.
4. Square-limit test comparing finite square then limit with continuum Dirac then Lichnerowicz square.
5. Stochastic or covariant graph ensemble test only after the decorated deterministic case works.

The finite square can be exact while the continuum square limit still fails. The commuting square can fail because the frame term survives, the holonomy coefficient is wrong, the Pauli term is misnormalized, high-frequency branches do not decouple, or the continuum Lichnerowicz endomorphism is wrong.

### 6.13.10 Mass matching, Pauli coefficient, and prediction gate

The no-double-counting statement is now:

```text
Pluecker spread/mass = kinetic invariant of the symbol,
Phi^2 = zero-order internal mass block.
```

For spectral matching, the finite theorem should first be stated for finite-dimensional diagonalizable self-adjoint operators:

```text
ker(-K tensor I + I tensor M^2)
  = direct_sum_lambda E_lambda(K) tensor E_lambda(M^2).
```

This is an on-shell matching theorem, not a mass prediction. A mass prediction requires the finite geometry to constrain `K`, `M^2`, or their relation by a variational or spectral-action principle.

The diamond curvature term has the standard Pauli shape:

```text
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b]
          -> 1/2 gamma^{ab} F_ab.
```

This supports tree-level `g = 2` as a consistency check if the holonomy and soldering normalizations are fixed. It is not a `(g - 2)` prediction without quantization, loops, or an explicit finite spectral-action analogue.

Prediction claims should be governed by a moduli-rank ledger. Let

```text
F : M_finite -> M_EFT.
```

If `rank(dF)` is full, the construction is a reparametrization. A prediction requires codimension in the image, or an independently forced restriction. Each claim should be labeled as finite identity, symbol/asymptotic theorem, reconstruction, kinematic identity, consistency check, or prediction.

### 6.13.11 Defects, anomalies, Markov clocks, and node theorems

The smallest defect pilot is an SSH/Jackiw-Rebbi chain with chiral symmetry and a domain-wall zero mode satisfying

```text
psi_{A_{j+1}} = -(v_j / w_j) psi_{A_j}.
```

This is a clean pilot for matter-as-defect-modes, but not yet Standard Model chirality. Chiral imbalance still needs an index, boundary/domain-wall mechanism, overlap/Ginsparg-Wilson-type structure, or another controlled route.

Anomaly tests should begin as representation-theoretic finite sums:

```text
sum_left tr(T^a {T^b, T^c}) = 0,
sum_i Y_i = 0,
sum_i Y_i^3 = 0,
```

with color and weak multiplicities included.

For finite Markov pathwise work, regenerative cycles are likely the best Lean route. Choose a recurrent state `r`, decompose into return cycles, prove iid cycle rewards after the first cycle, and obtain the ratio limit. For CTMCs, use uniformization `Q = lambda(P - I)` to reduce to a discrete embedded chain plus holding-time rewards.

Near Born nodes, only stopped/local theorems should be advertised until a capacity theorem is proved. Work on `{rho >= epsilon}` with a stopped time `tau_epsilon`; global existence requires a nodal-set polarity or weighted capacity estimate.

An internal phase is not a clock by itself. A clock claim needs a gauge-invariant relational readout, for example a relative holonomy and pointer variable.

### 6.13.12 Finite-core paper package

A serious finite-core paper can aim to prove the following package without claiming new physics:

1. Simplex null-solder theorem: `xi = sum_A xi(ell_A) alpha^A`.
2. Diagonal trace obstruction for diagonal null soldering.
3. Dual-soldered commutator theorem: `[D_sol^h, M_f] -> c(df)`.
4. Graded square theorem with the correct `Gamma_s` and `chi_E` hypotheses.
5. Finite tetrad-postulate theorem: `[nabla_a, C_b] = 0` implies `T_frame = 0`.
6. Krein double theorem: `D_- := D_+^sharp` gives a block `J`-self-adjoint doubled operator.
7. Flat determinant branch-count protocol, not merely coefficient-zero analysis.
8. Spectral mass-shell matching theorem.
9. Pauli normalization diamond.
10. Claim-boundary ledger.

Top failure modes are determinant-level high-momentum massless branches or complex instabilities, grading conflation, uncontrolled frame contamination, arbitrary tetrad decoration, full-rank finite-to-EFT reparametrization, wrong spectral-action signs, and anomaly repair by ad hoc spectators.

Top near-term success is a dual-soldered finite null-edge Dirac algebra with correct graded square, finite tetrad postulate, Krein retarded/advanced audit, clean branch-count result, and mass-shell matching. A full G5 physics endpoint additionally needs controlled continuum scaling, anomaly-safe chirality, and a finite spectral action with a real codimension constraint.

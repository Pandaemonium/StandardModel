# HELP NEEDED — conceptual brief for Fable 5 (self-contained)

You are **Fable 5**, Anthropic's most capable model. You are being handed a large,
mature formalization program and asked to do the thing we cannot outsource to a
proof engine: **think**. This brief is fully self-contained — it assumes you know
nothing about the repository.

**We do not need you to write Lean.** We have a capable Lean team (human + coding
agents + an external proof fleet) that turns precise statements into kernel-checked
proofs. What we are short on is the layer *above* the kernel: the conceptual moves,
the synthesis across lanes, the new connections, the right literature, and — above
all — a clear-eyed strategy that actually **drives us to the goal**.

**Your job, in order of value:**
1. **Drive us to the goal.** The goal is *a single model that explains all mass as
   an obstruction to null-edge transport* (§2). Tell us what that model must contain,
   which of our pieces belong in it, which are distractions, and what the shortest
   honest path to it is. Be the north star.
2. **Solve hard conceptual problems.** Where we are stuck, the block is usually
   conceptual, not tactical (§6). Crack the *idea*; we'll formalize it.
3. **Synthesize.** We have ~40 finite results across five lanes (§5) that we suspect
   are facets of one structure. Find the structure. Tell us what unifies them — or
   prove to us that they don't unify and why.
4. **Make new connections.** Between our lanes, and between our program and the rest
   of physics/mathematics. The best contribution might be a bridge we can't see.
5. **Alert us to the literature.** Point us at the papers, theorems, and communities
   whose results we should be standing on and probably aren't.

Do not optimize for volume or for producing proofs. One decisive conceptual insight —
"here is why your taxonomy is really one object," or "the gate you think is central is
a corollary of X," or "this 1987 paper already contains the mechanism you're
rebuilding" — is worth more than a hundred restatements. **And hold yourself to our
honesty bar (§3): don't hand us a synthesis that quietly assumes the hard part.**

---

## 1. The project in one screen

**PhysicsSM** is a Lean 4 formalization of the mathematical structures behind the
Standard Model: octonions and division algebras, exceptional Lie theory (E8),
Clifford/spinor algebra, lattice gauge theory, and a research program we call
**null-edge theory**. The Lean kernel is our source of truth: a claim counts only
when a machine-checked proof of a faithful statement exists. That discipline is a
strength, but it also means we spend our formal effort on things we already
understand. **The frontier is understanding, and that is where you come in.**

You should treat the kernel-checked results below (§5) as *hard, trustworthy data
points* — finite facts we are certain of — and reason about what they *mean* and
what they're *missing*.

---

## 2. THE GOAL — a model that explains all mass from null edges

This is the thing to keep your eyes on. Everything else is scaffolding.

**The thesis:** *mass is a relational obstruction to null (lightlike) transport.* A
lone lightlike excitation carries no mass; mass appears when something obstructs the
free null propagation — when the excitation is forced to **turn**, to **close a
loop**, or to combine with others into a bound **aperture**. Concretely we have
argued mass shows up in three taxonomically-distinct modes:

- **T (Turn)** — matter/chirality mass. The Higgs–Yukawa chirality-flipping vertex:
  a massless Weyl mode acquires mass by being made to reverse handedness (to "turn").
- **C (Closure)** — gauge mass. The Yang–Mills mass gap / confinement scale: the cost
  of closing a null loop against a nonabelian gauge connection.
- **A (Aperture)** — composite/kinematic mass. The invariant mass of several null
  momenta: individually massless constituents bound into a massive whole.

**What "delivering the model" would mean** (this is the target you should be sharpening
and steering us toward — help us make it precise and reachable):

> A *single* mathematical object — a null-edge structure (a graph/complex of lightlike
> edges with the soldering and transport data on it) — from which **all three mass
> modes arise as different obstructions of the same transport operator**, such that the
> Standard Model's mass content (a chiral fermion getting a Yukawa mass, a gauge sector
> getting a confinement/mass gap, a composite getting a binding mass) is *derived*, not
> assembled by hand from three separate constructions.

Right now we have the three modes as **separate, distinct** finite theorems, and we
have even proved (honestly) that our current models have **no common carrier**
(`MassCommonCarrier.no_common_carrier_via_turn`) — i.e., no single one of our existing
constructions carries all four masses non-artificially. **That negative is the central
tension of the whole program**, and resolving it is the heart of the goal:

- Either the three modes are genuinely irreducible and "the origin of mass" is
  *inherently* a taxonomy of three obstructions on a null-edge structure (in which case
  we need the crisp theorem that says *these three and no others*, with the taxonomy
  proven exhaustive) —
- or there is a deeper single carrier we haven't found, and the "no common carrier"
  result is an artifact of our current, too-rigid models (in which case we need to know
  what the right carrier is).

**We need you to tell us which, and drive us there.** This is the single most valuable
thing you can do: adjudicate the common-carrier question and lay out the model that
resolves it.

---

## 3. The bar: honest-claim discipline (this applies to your conceptual work too)

Our formal side has a hard-won discipline, and your conceptual deliverables must
respect the same standard so we can actually build on them.

Every kernel-checked headline is **axiom-guarded**: a build-time check fails if a
theorem's transitive axiom footprint ever drifts from the standard
`[propext, Classical.choice, Quot.sound]` (a leaked `sorry`, a slipped-in fast-but-
unchecked evaluator, or a new bare assumption). Forbidden in trusted results: any
escape hatch that lets an unproven thing masquerade as proven. Every result is graded
**PROVED** (kernel-checked) vs **MODELED** (true only under an explicit hypothesis we
have *not* derived) vs **OPEN**.

During the run that produced this corpus, **four over-claims were caught and
corrected** — this is the standard, and it's exactly the kind of self-deception a
synthesis can smuggle in:
- A decay estimate written "for all `m` there exists a constant `C`…" was **vacuous**
  (the constant could depend on `m`, so it asserted no decay at all); the real content
  needs `C` uniform in `m`.
- A claimed "topological no-go" actually proved only a local algebraic fact; it did not
  establish the global obstruction. Downgraded.
- A "fix" for it telescoped a quantity that was *identically zero for trivial reasons*
  (the crucial symmetry hypothesis went unused), so it proved nothing about the real
  object. Downgraded.
- A second "fix" had the same hollowness and was **rejected outright**; the genuine
  theorem was then re-derived from scratch (and *did* land).

**What this means for you:** when you synthesize or propose a model, **separate "the
appealing picture" from "the load-bearing claim," and be explicit about which steps are
established, which are conjectural, and which are the genuinely hard crux.** If your
unifying story works only because it quietly assumes the SU(N) mass gap, or assumes the
three obstructions collapse, *say so and mark that as the crux* — don't present the
picture as if the crux were free. A conceptual map that honestly flags its own hard
step is exactly what we want; a seamless-looking synthesis that hides one is the thing
we most need to avoid.

---

## 4. Environment (context only — you are not asked to run it)

The formalization is Lean 4 + Mathlib, toolchain pinned. When we quote a result as
kernel-checked, it typechecks under that pin with the standard axiom footprint. One
convention you should know because it affects the physics reasoning: **octonions are
nonassociative**, so anything octonionic is done by composing *linear maps / left-
multiplication operators*, never by manipulating raw octonion products; and our
octonion basis is an XOR binary-label Fano convention (`e000…e111`), *not* the
Baez-2002 or Furey-2015 labeling — so if you cite their formulas, flag that a
relabeling/sign-correction stands between their equations and ours.

You do not need to produce or run any code. Reason in mathematics and physics; we
handle Lean.

---

## 5. What is already landed (the material to synthesize)

These are kernel-checked, honestly-scoped finite facts. Treat them as the pieces on
the table. Theorem names are given so you can refer to them precisely; you do not need
to read their proofs.

**A — aperture/kinematic (essentially complete):**
- `NBodyAperture.nbody_aperture_massless_iff_collinear` — for any `N` future-null
  momenta, the sum is again null **iff** all point in a single null direction (both
  directions of the iff).
- `ApertureEntropy` / `ApertureObserverState` — a null-direction "spread" entropy;
  zero iff a single direction; massive ⟹ strictly positive spread.
- `BindingMassQuantitative.compositeMassSq_eq_sin_half` — `M² = 4E² sin²(θ/2)` exactly
  for two equal-energy null momenta (mass is literally the *angle* between null edges).
- `MassFromMasslessNEU5.compositeMass_pos` — a composite of individually *massless*
  constituents has strictly positive mass. Mass from relation, in one line.

**T — turn/matter (genuine 1D no-go landed; higher-d open):**
- `FiniteNNZeroCount.signedZeroCount_eq_zero` — the genuine 1D Nielsen–Ninomiya no-go:
  the signed count of sign-crossings of a real periodic dispersion vanishes (up- and
  down-crossings balance on the boundaryless torus). This is the honest "you cannot
  have a single chiral mode on a lattice" — a lone crossing is impossible.
- `GinspargWilson` / `OverlapDirac` — the finite Ginsparg–Wilson relation and the
  Neuberger overlap operator satisfying it; the deformed chiral symmetry is an exact
  involution — the *price of the turn* made precise.
- `NNIndexExact.signedZeroCount_eq_two_indexTr_diff` — **the crossing count equals the
  overlap index.** The two T-leg strands (zeros of the dispersion ↔ topological index)
  are tied together.
- `YukawaTurnAmplitude.turnAmplitude_eq_zero_iff` — n-flavor "no turn ⟺ no mass": the
  chirality-flipping vertex vanishes iff the mass matrix is zero.

**C — closure/gauge (Z2 complete; nonabelian is the crown-jewel gap, §6.1):**
- `SlabGapAssembly.slabGapAssembly` — the complete **Z2** gauge chain as one theorem:
  reflection positivity → self-adjoint transfer operator → strictly-positive spectral
  gap `= −log(tanh β)` → **exponential clustering**, uniform in separation. A full
  finite confinement-gap story, for the abelian Z2 group, cluster-expansion-free.
- `CharacterExpansion.charCoeff_abs_le_dim_mul_trivCoeff` — the correct **nonabelian**
  strong-coupling character dominance (applicable to SU(2)/SU(3)).
- `TYAreaLawSUN.TwistSystem` — an abstract SU(N) center-twist system (Tomboulis–Yaffe
  route) with positive string tension and an area law; `Q8StringTension` — a first
  genuinely **nonabelian** (quaternion group Q8) concrete string tension.
- `GapAsymptotics` — the Z2 gap `→ +∞` at strong coupling (confinement), `→ 0` at weak
  coupling. The right qualitative shape.
- **MODELED, not derived** (the honest gap): the reflection-positivity "raw bound" is
  an *explicit hypothesis* in the nonabelian theorems, and the SU(N) partition functions
  are *modeled* (abstract twist weights), **not** built from an actual SU(N) Haar
  measure. Closing this is §6.1.

**X — taxonomy / unification (the crux lives here):**
- `MassTaxonomySeparation` — the four mass functionals are pairwise **distinct**.
- `MassTaxonomyNonDegeneracy.massTaxonomy_nondegenerate` — each is independently
  realizable.
- `MassCommonCarrier.no_common_carrier_via_turn` — **the honest negative: no single
  one of our current models carries all four masses non-artificially.** (This is the
  tension you must adjudicate — §2.)
- `GrandMassCapstoneUnconditional.grandMassCapstoneUnconditional` — the unconditional
  all-lane capstone, scrupulously labeled a *bundle of distinct finite obstructions*,
  **not** a single unified model. We know it's a bundle, not the goal.

**B — division algebra → SM:**
- `su3Submonoid = SU(3)`, color triplet = fundamental, charge co-location; SM anomaly
  cancellation formalized.
- `OctonionMassCoupling` — a coupling *beyond* co-location: a split mass matrix does
  not commute with the su(3) ladder generators, proven faithful to the octonionic color
  action on the triplet.
- **Open, with honest negatives:** the Spin(10) pure-spinor stabilizer program — the
  Transitivity claim was proven **false**; the Isomorphism claim is **false as stated**
  (a complex form, real-dim 24, cannot be isomorphic to the compact `S(U(2)×U(3))`,
  real-dim 12); the Selector is underspecified.

**V — trust:** the entire **E8-240 root system is kernel-checked** by structural
counting (`112` integer roots `±eᵢ±eⱼ` + `128` half-integer even-parity roots), and
proven to be *exactly* the norm-2 E8-lattice vectors.

---

## 6. The conceptual frontier — where we most need you

For each item: what we have, and the **conceptual/strategic question we need you to
attack** (not a request for code). Ranked by value to the goal.

### 6.1 THE COMMON-CARRIER VERDICT (the goal itself — do this first)

We have three distinct mass obstructions (T, C, A) and a proof that **no single current
model carries all of them** (`MassCommonCarrier`). Section 2 lays out the dichotomy:
irreducible taxonomy vs undiscovered common carrier. **We need your verdict and your
construction or your no-go.**

Concretely, help us answer:
- Is there a single null-edge transport operator `D` (schematically `D = Σ_a c(α^a) ∇_{ℓ_a}`
  — a soldering `c` of a covector `α^a` composed with a null-direction difference operator
  `∇_{ℓ_a}`) whose **different failure modes** reproduce T, C, and A? I.e., does "chirality
  obstruction of `D`" give the Yukawa turn, "holonomy/closure obstruction of `D`" give the
  gauge gap, and "multi-edge kinematic obstruction of `D`" give the aperture mass — all
  from *one* operator? If yes, sketch it precisely enough that we can formalize the claim
  "these three are the three obstruction classes of one operator."
- If no, what is the sharpest **exhaustiveness theorem** we should be proving — "mass on a
  finite null-edge structure is *necessarily* one of exactly these three obstruction
  types" — and what is the classification argument (an index/cohomology decomposition of
  the transport operator into turn/closure/aperture sectors)?
- Is our `no_common_carrier` result *deep* (a real theorem about null-edge structures) or
  *shallow* (an artifact of over-rigid modeling that a better carrier dissolves)? This is
  the single highest-value judgment call in the brief.

This is not a Lean task. It is a physics/mathematics *design and adjudication* task, and
it is the goal. Everything below is in service of it.

### 6.2 THE NONABELIAN GAUGE GAP — is it a gate, or a distraction?

We treat a nonabelian (SU(2)/SU(N)) lattice Yang–Mills mass gap at *fixed spacing* as
"the single gate" of lane C. We have the full Z2 story and an abstract SU(N) scaffold
whose one missing input is a reflection-positivity bound currently taken as a hypothesis
(and partition functions that are modeled, not built from Haar measure).

**Conceptual questions for you:**
- **Strategically: is this the right hill?** Does the *goal* (§2) actually require a
  finite-spacing nonabelian gap, or is the C-mode's essential content already captured by
  the Z2 chain + the nonabelian character dominance we have, with the full SU(N) gap being
  a Clay-adjacent side-quest that doesn't move the *unification*? Tell us if we are
  over-investing here.
- **Route selection:** two attacks are open — (i) Tomboulis–Yaffe / Kanazawa vortex free
  energy (`Z^{[k]}/Z`, arXiv:0808.3442), and (ii) a convergent Kotecký–Preiss / Fernández–
  Procacci cluster expansion (see §6.3). Which is more likely to yield an *honest,
  finite* result, and is there a third route (e.g. a direct reflection-positivity /
  Griffiths inequality argument for twist-monotonicity `Z^{[k]} ≤ Z^{[0]}`) we're missing?
- **The conceptual crux:** the physics claim that a nonabelian center-twist raises the
  free energy (giving positive string tension) — what is the cleanest *finite* argument
  for it, and does it have a null-edge interpretation that ties it back to §2's closure
  mode? A gauge gap that we can *interpret* as a closure obstruction is worth far more to
  us than one we merely prove.

### 6.3 THE POLYMER/CLUSTER-EXPANSION CRUX (analytic; conceptual reframing wanted)

Our alternative route to §6.2 is gated by one hard combinatorial inequality — the
labeled-tree exponential bound underlying Kotecký–Preiss / Fernández–Procacci cluster-
expansion convergence (the sum over connected clusters is bounded by an exponential of
the single-polymer weight). We have attempted it 4+ times; a naive root-overcounting
reduction is provably false at third order.

**What we want from you (conceptual, not a Lean proof):** the *right* form of the
argument — the Fernández–Procacci "new bounds from an old approach" (math-ph/0605041)
inductive scheme, stated as a clean sequence of lemmas with the one genuinely hard step
isolated; or a different, more formalizable convergence criterion (e.g. Dobrushin-type)
that reaches the same clustering conclusion with a combinatorics we can actually
mechanize. Alert us if there's a modern treatment (a survey, a cleaner reformulation)
that sidesteps the tree-graph inequality entirely.

### 6.4 HIGHER-DIMENSIONAL TURN NO-GO (conceptual generalization)

We have the genuine **1D** Nielsen–Ninomiya no-go (crossing count = overlap index). The
honest **general-d / 4D** statement — signed sum of the chiralities (local degrees) of the
Dirac symbol's zeros over the discrete Brillouin torus vanishes, a discrete Poincaré–Hopf
/ index theorem — is open.

**Conceptual questions:** what is the cleanest *finite, combinatorial* formulation of
discrete Poincaré–Hopf on `(ZMod N)^d` that makes the degree-sum-is-zero statement true by
a boundaryless-manifold argument we can mechanize? And — the connection we care about — how
does this d-dimensional index tie back to the **turn mode** of §2: is the statement "you
cannot have a single chiral fermion" *literally the same obstruction* as "a null edge
cannot turn without a partner," in the sense of §6.1's classification?

### 6.5 OCTONION → STANDARD MODEL: the dynamical step (synthesis + literature)

Lane B has charge co-location and a structural coupling, but no genuine piece of SM
*dynamics* derived from the complex octonions `ℂ⊗𝕆`. Two open threads: (i) getting the
one-generation fermion mass/mixing structure as an eigenvalue/intertwiner problem for the
associative left-action algebra of complex-octonion left-multiplications (the safe object
is a *module / minimal left ideal for the left-action algebra*, never "the minimal left
ideal of the octonions"); (ii) repairing the Spin(10) stabilizer program (the Isomorphism
is false as stated — complex vs compact real form).

**What we want:** the conceptual bridge from `ℂ⊗𝕆` structure to a **mass** in the null-
edge sense of §2 — does the octonionic color/charge structure supply the *turn* data (the
Yukawa vertex) for lane T, connecting B and T into one story? And a literature sweep: whose
division-algebra Standard Model work (Furey, Dubois-Violette, Todorov, Gording–Schmidt-May,
Boyle, …) already contains a mass mechanism we should be adopting rather than reinventing —
and where does the honest Spin(10) real-form obstruction actually leave the program?

### 6.6 SYNTHESIS & LITERATURE (standing asks — always in scope)

Independent of the specific problems above:
- **The unifying principle.** If you had to state, in one theorem-shaped sentence, "what
  null-edge theory says mass *is*," what is it — and does our corpus support it or fall
  short of it? Give us the sentence and the gap.
- **New connections.** Where does this program touch established mathematics we're not
  citing — spectral/index theory (is the whole thing an index theorem in disguise?),
  Connes-style noncommutative geometry and the spectral action (our `D = Σ c(α)∇` smells
  like a Dirac operator — is the mass literally `Tr f(D)` content?), topological/K-theory
  invariants, causal set theory, twistor theory (null edges ↔ twistors?), the
  amplituhedron/positive geometry (aperture mass as a positive-geometry volume?), or
  categorical/operadic structure on the edge complex?
- **Literature we're missing.** Point us at specific papers/theorems/people. We have a
  literature-mining pipeline; what should we feed it? Flag both "prior art that already did
  this" (so we don't reinvent) and "adjacent tools we should import."
- **The reframes that would change our strategy.** Tell us if we're carving the problem
  wrong — wrong invariant, wrong lane boundaries, a fourth mode we've missed, or a mode
  that isn't real.

---

## 7. What to deliver

Prose and mathematics, not code. For whatever you engage, give us:

1. **A verdict or a construction**, stated sharply enough that we can turn it into a Lean
   statement ourselves — the exact claim, its hypotheses, and (crucially) **which step is
   the load-bearing crux**. The most valuable single deliverable is §6.1: your adjudication
   of the common-carrier question and the model (or no-go) that resolves it.
2. **The synthesis** — what unifies the corpus, or the honest argument that it doesn't, at
   the §3 standard (separate the picture from the load-bearing claim; flag every
   conjectural step).
3. **New connections and literature** — specific bridges to established math/physics and
   specific papers/people, with enough detail that we can act on them.
4. **Strategic direction** — where to invest, what to abandon, what the shortest honest
   path to the goal (§2) is, and what the *next three moves* should be.

For every claim, grade it **established / conjectural / the-hard-crux**, the same way we
grade PROVED / MODELED / OPEN. Don't let a compelling narrative outrun what's actually
supported — and where the crux is genuinely hard, isolating it cleanly *is* the
contribution. Aim everything at the goal: **a single model that explains all mass as an
obstruction to null-edge transport.** Drive us there.

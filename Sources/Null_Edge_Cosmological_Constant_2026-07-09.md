# The cosmological constant in the null-edge framework

**Status: analysis + program note (2026-07-09).** This document collects what the
finite null-edge / "all mass from massless edges" framework can and cannot say about
the cosmological constant `Lambda`. It is held to the project claim calculus: **T**
source-verified, **M** kernel-checked in this repo, **[import]** an external result we
rely on, **[C]** a pre-registered conjecture, **[spec]** honest speculation. It is a
companion to `Null_Edge_Future_Directions.md` (see P-L, the unified gravity+QFT program)
and is *outside* the main manuscript until any piece is promoted with a guard-pinned
anchor.

The one-line summary: **the framework has a genuine, specific, and already
partly-kernel-checked handle on `Lambda` — the causal-set "everpresent `Lambda`"
mechanism, which gives the observed order of magnitude `~10^-122` — but it is a handle
on the *coincidence* problem (why `Lambda` tracks the ambient density), not a
first-principles derivation of the value, and it predicts a *fluctuating* dark energy.**

---

## 1. The problem, stated in two halves

- **The magnitude problem.** In continuum QFT the vacuum zero-point energy density is
  naively `~M_Planck^4`, about **120 orders of magnitude** larger than the observed
  `rho_Lambda ~ (10^-3 eV)^4`, i.e. `~10^-122` in Planck units. "The worst prediction
  in physics."
- **The coincidence problem.** Why is `rho_Lambda` comparable to the matter density
  `rho_m` *now* (both order the critical density today), when the two scale completely
  differently with expansion?

A predictive theory of `Lambda` should say something about at least one half. The
null-edge framework's leverage is strongest on the **coincidence** half.

---

## 2. Why a finite null-edge theory changes the question

The magnitude problem in its usual form is a **continuum** artifact: a divergent (or
Planck-cutoff) sum of field zero-point energies. A **finite** theory has no such sum —
the "vacuum energy" is a finite, computable quantity, not a divergence `[spec ->
structural]`. This does not by itself *predict* the small value, but it means the
framework does not inherit the 120-orders-of-magnitude catastrophe; the question becomes
"what finite quantity is `Lambda`, and what sets its scale?", which has three concrete
loci below.

---

## 3. The main handle: everpresent `Lambda` (causal-set mechanism) — partly M

The deepest leverage comes from the theory being **discrete** (finite null edges as the
elementary spacetime elements), which is exactly the ingredient the **everpresent
`Lambda`** proposal needs.

**The mechanism** (Sorkin; Ahmed, Dodelson, Greene, Sorkin 2002 `[import]`):
1. In unimodular gravity `Lambda` is *conjugate to the spacetime 4-volume* `V` — they
   form a conjugate pair like energy and time `[import]`.
2. In a discrete spacetime the number of elements `N` in a region is `~ V` (one element
   per Planck 4-volume), and a Poisson fluctuation gives `delta N ~ sqrt(<N>) ~ sqrt(V)`.
3. The conjugacy then makes `Lambda` fluctuate about zero with magnitude
   `|Lambda| ~ delta N / V ~ 1 / sqrt(V)`.

**The number.** For the present cosmological horizon, the past 4-volume in Planck units
is `V ~ 10^244`, so `1/sqrt(V) ~ 10^-122` — **the observed magnitude of `rho_Lambda`,
with no tuning.** And because `Lambda ~ 1/sqrt(V)` tracks the ambient density at *every*
epoch, the mechanism naturally addresses the **coincidence** problem: `Lambda` is always
of order the critical density, "everpresent."

**What is kernel-checked in this repo (M).** The finite *scaling-law core* is formalized
(`PhysicsSM/Draft/NullEdgeP9EverpresentLambdaScaling.lean`,
`NullEdgeP9EverpresentLambdaTension.lean`):
- `lambdaOfFluct deltaN V = deltaN / V` — the normalized cosmological constant from a
  number fluctuation over a volume.
- `everpresentLambda_secondMoment_eq_inv_volume` (**M**): if the number-fluctuation
  second moment equals the volume (`deltaN^2 = V`, the Poisson input), then
  `Lambda = deltaN/V` has second moment `deltaN^2 / V^2 = 1/V`.
- `everpresentLambda_rms_eq_inv_sqrt_volume` (**M**): the RMS magnitude is
  `sqrt(V/V^2) = 1/sqrt(V)` — the everpresent scaling law, kernel-checked.
- `uniformSuppression_below_everpresent` (**M**): a *uniform* suppression mechanism with
  residual `A^2/N` beats the everpresent `sqrt(N)` growth **iff** the scale is
  sub-extensive (`A^2 < N^2`) — a kernel-checked statement of *when* a competing
  smoothing can win against the fluctuation (`uniformSecondMoment_antitone` gives the
  monotonicity).

**Honest scope.** What is **M** is the *arithmetic of the scaling* (given the Poisson
input `deltaN^2 = V`, the RMS is `1/sqrt(V)`). What is **[import]/[C]** and *not* proved
here: (i) the `Lambda`-`V` conjugacy (unimodular gravity); (ii) that the null-edge count
is Poisson with `deltaN^2 = V` (the discreteness sprinkling assumption); and (iii) the
identification of *our* null-edge count with the spacetime 4-volume. Those are the
inputs; the repo proves the consequence.

---

## 4. The spectral-action locus: `Lambda` as the order-0 term — [C], tied to the unification work

In the noncommutative-geometry / spectral-action route (Connes-Chamseddine `[import]`;
finite avatar `[job: spectral-action-avatar]`, submitted 2026-07-09), the whole action is
one functional `S(D) = Tr f(D/Lambda_cutoff)`, and its expansion gives, at successive
orders, a **cosmological/volume term (order 0), a gravity term (order 2), and matter
terms (order 4)**. So `Lambda` is precisely the **order-0 coefficient `a_0 * Tr(1)`** —
a specific, finite, computable number, not a divergence, and a graded piece of the *same*
functional that yields gravity and matter. In the finite avatar this makes `Lambda` a
concrete rational quantity of the carrier; it does **not** explain why `a_0` is tiny (the
fine-tuning is *relocated*, not removed) `[C]`.

This ties the cosmological constant directly to the unified gravity+QFT program (P-L):
`Lambda` is the order-0 rung of the very functional whose order-2/4 rungs are gravity and
matter.

---

## 5. The Jacobson locus: `Lambda` as an integration constant — [import]

In the thermodynamic / equation-of-state derivation of the field equation (Jacobson
`[import]`; finite avatar `[job: jacobson-clausius]`), `Lambda` enters as an **undetermined
constant of integration** — the Clausius relation `delta Q = T delta S` fixes the field
equation *up to* a cosmological term. So this route, by itself, does **not** predict
`Lambda`; it is consistent with any value. Its interest is that it makes the *dynamics*
(the field equation) thermodynamic while leaving `Lambda` as the one piece the
thermodynamics does not fix — which is exactly the slot the everpresent mechanism (Sec 3)
then fills stochastically.

---

## 6. What is proved, conjectured, and outside

| Claim | Grade | Where |
|---|---|---|
| Everpresent scaling: Poisson `deltaN^2=V` ⇒ `Lambda` RMS `= 1/sqrt(V)` | **M** | `EverpresentLambdaScaling` |
| A sub-extensive uniform suppression beats the `sqrt(N)` fluctuation (`A^2<N^2`) | **M** | `EverpresentLambdaTension` |
| `1/sqrt(V) ~ 10^-122` for the present horizon (the magnitude success) | **T/[import]** | ADGS 2002 |
| `Lambda` = the order-0 term of one spectral action (finite avatar) | **[C]/[job]** | `spectral-action-avatar` |
| `Lambda` is the unfixed integration constant of the equation of state | **[import]** | Jacobson |
| `Lambda`-`V` conjugacy (unimodular gravity) | **[import]** | — |
| The null-edge count *is* the 4-volume `V` (our ontology ⇒ the scaling) | **[C]** | proposed, Sec 8 |
| A first-principles derivation of the *value* `10^-122` | **outside** | event horizon |
| Whether `Lambda` is fixed or fluctuating dark energy (observational test) | **outside/[C]** | — |

---

## 7. The honest boundary — what this framework does *not* claim about `Lambda`

- **No derivation of the value.** The everpresent mechanism ties the *magnitude* to the
  spacetime volume `V`, which is an **input** (the age/size of the universe). It explains
  why `Lambda` tracks the ambient density, not why the universe has the size it does.
- **It predicts *fluctuating* dark energy.** Everpresent `Lambda` has vanishing mean and
  RMS `1/sqrt(V)` — a *dynamical, fluctuating* dark energy with a specific spectrum, not a
  rigid constant. This is falsifiable and is a live tension with a pure-`Lambda`CDM fit; it
  is a **prediction to be tested**, not a retrofit.
- **The magnitude problem is dissolved, not solved.** Finiteness removes the divergence;
  the spectral action makes `Lambda` a finite coefficient — but neither *predicts* its
  smallness from first principles (the coincidence half is the framework's real strength).
- **Event horizon (unchanged).** Absolute scales, the Born rule, initial conditions, and
  the number of null edges stay outside the framework; `V` itself is not derived.

---

## 8. The distinctive next step (buildable, rule-v3)

The everpresent modules use an abstract `N` and `V`. The framework's *own* contribution
would be to close the gap in row 7 of the table: prove that **our null-edge count is the
volume**, so `Lambda ~ 1/sqrt(edge count)` in the theory's native primitive.

- **[job proposal: lambda-edge-count]** — On a finite causal region (a diamond/slab),
  define the pierced-null-edge count `N`; prove `N` is an extensive volume measure
  (additive over disjoint sub-regions, `N(A ∪ B) = N(A) + N(B)`); assume the Poisson
  second moment `deltaN^2 = N` (the discreteness input, stated as a hypothesis); and
  conclude `Lambda = deltaN/N` has RMS `1/sqrt(N)` **with `N` = the edge count**. This
  routes the kernel-checked `EverpresentLambdaScaling` arithmetic through the framework's
  own primitive rather than an abstract `V`, making the everpresent handle *ours*. All
  rational/finite; buildable in-project.

Pairing this with surfacing the everpresent result into the manuscript (currently only in
the P9 draft modules) would give the paper an honest, kernel-checked paragraph on the one
cosmological big-ticket item where this framework genuinely has something specific to say.

---

## References (verify before any manuscript citation)

- R. Sorkin, "Is the cosmological 'constant' a nonlocal quantum residue of discreteness
  of the causal set type?" (2007) `[import]`.
- M. Ahmed, S. Dodelson, P. Greene, R. Sorkin, "Everpresent Lambda," Phys. Rev. D 69,
  103523 (2004), arXiv:astro-ph/0209274 `[import]` — the `1/sqrt(V)` prediction.
- T. Jacobson, "Thermodynamics of spacetime: the Einstein equation of state,"
  arXiv:gr-qc/9504004 `[import]`; entanglement-equilibrium version arXiv:1505.04753.
- A. Chamseddine, A. Connes, M. Marcolli, "Gravity and the standard model with neutrino
  mixing," arXiv:hep-th/0610241 `[import]` — `Lambda` as the order-0 spectral-action term.
- (Discrete spectral action) "Bratteli networks and the spectral action on quivers,"
  arXiv:2401.03705 `[import]`.
- Unimodular gravity / `Lambda`-`V` conjugacy: Henneaux-Teitelboim; Unruh `[import]`.

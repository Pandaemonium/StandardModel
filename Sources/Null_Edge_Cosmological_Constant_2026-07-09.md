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

## 7b. Round-2 synthesis (Fable + Pro analyses, 2026-07-09) — the unifying frame

Two external analyses (Fable-5 and Pro, relayed 2026-07-09) sharpen Sections 3-5 into one
statement in the program's native voice. Recorded here at the honest grade; the rung table
below carries the job IDs.

### The synthesis: `Lambda` is the conjugate of the count

The three loci of Sec 3-5 say the same thing in three dialects. Spectral action: `Lambda`
is the coefficient of `tr(1)` — the **zeroth moment**. Unimodular gravity: `Lambda` is the
multiplier **conjugate to the 4-volume**. Everpresent: `Lambda`'s magnitude is the
fluctuation of the element **count**. Unified:

> **The mass channels decompose the second spectral moment of the carrier (per-state
> `tr(D^2)`-type data); `Lambda` is the zeroth moment. It couples to the bare existence of
> null edges — `tr(1)` — and is blind to every channel.**

This yields a three-level hierarchy the framework already half-owns: `tr(1) -> Lambda`
(couples to the count), `tr(rho) ->` the channel-blind matter source (exactly the landed
`WEPTrace`/`WEPActionBridge` `kappa Tr(rho)`), channel-resolved traces `->` the budget
shares. `Lambda` is the channel-blind coupling *par excellence* — one rung below the WEP
source, coupling to the space rather than the state. Equivalently (Pro's split), keep three
`Lambda`s distinct: `Lambda_spec` (the finite order-0 coefficient), `Lambda_int` (the
unimodular/Jacobson integration constant), `Lambda_fluc` (the count fluctuation — the
distinctive one).

Two theorem-shaped consequences, genuinely new for the program:

1. **The magnitude problem dissolves structurally, not just by finiteness.** `tr(1)` is
   invariant under *every* deformation of `D` — every gauge move, channel coupling,
   soldering decoration. There is **no channel pathway into the order-0 coefficient**:
   matter physics cannot renormalize or generate `Lambda`; only count statistics can touch
   it. (Caveat to formalize: `tr(1)` = edge count x internal fiber dimension; with the
   fiber fixed, the fluctuating part is the edge count.) `[job: lambda-unimodular]`
2. **The mean is gauge; the fluctuation is physical** (the finite unimodular trade). Under
   a count constraint, shifting the order-0 coefficient shifts the action by a constant on
   the constraint surface — unobservable; the multiplier enters the field equation as
   `+Lambda * 1` (Jacobson's integration constant, finitely); the observable residue is the
   count's *deviation from its constrained mean* — RMS `1/sqrt(N)`. The landed
   `Goal4FieldEquation` multiplier `mu` in `M(psi) gamma = mu eta gamma` is exactly this
   integration-constant shape (null-cone constraint); the `Lambda` rung is the sibling with
   the volume/trace constraint. This converts the `Lambda`-`V` conjugacy from `[import]` to
   a finite **M-target**. `[job: lambda-unimodular]`

### `Lambda` as a susceptibility, and the Poisson/hyperuniform fork (the sharpest new question)

The Poisson input `deltaN^2 = V` need not be assumed — it can be *situated* via the D5
ensemble. Grand-canonical: with a chemical potential `mu` conjugate to edge count, the
finite identity `Var(N) = T * d<N>/dmu` makes **`Lambda`'s RMS a thermodynamic response
coefficient**: `Lambda_rms = sqrt(chi_N)/<N>`. `Lambda` folds into Suite D: mass channels
are budget susceptibilities; `Lambda` is the *count* susceptibility. For independent edge
occupancies the Bernoulli-sum bound gives `Var(N) = sum p_i(1-p_i) <= <N>` (equality in the
sparse/Poisson limit), so everpresent becomes an **upper-bound theorem for an ideal edge
gas**: `Lambda_rms <= 1/sqrt(<N>)`. `[job: lambda-susceptibility]`

The pre-registered fork — arguably the single most interesting `Lambda` question the
framework can ask, and the place it could *exceed* the borrowed causal-set mechanism:

> **Do the framework's own constraints correlate the count?** Gauss/gauge constraints
> induce correlations, and the physical precedent (Coulomb systems are hyperuniform:
> charge fluctuations scale with surface, not volume — Martin-Yalcin, Stillinger-Lovett,
> Torquato-Stillinger `[import]`) says constraint-induced correlations can make number
> fluctuations *sub-extensive*.

- **Poisson branch** (`Var(N) ~ N`): the input is derived at the ensemble level;
  everpresent survives; the framework predicts fluctuating dark energy at `1/sqrt(V)`.
- **Hyperuniform branch** (`Var(N) ~ N^alpha, alpha < 1`): `Lambda` is suppressed *below*
  `1/sqrt(V)` (e.g. area-scaling `Var ~ V^{3/4}` gives `~10^{-152}`), which would **kill
  the everpresent identification of observed dark energy** in this framework and demote
  `Lambda` to an unexplained integration constant. The landed
  `uniformSuppression_below_everpresent` is already the comparison machinery.

Refinement to state up front: *which count is conjugate to `Lambda`?* Unimodular gravity
pairs `Lambda` with the bare geometric 4-volume — presumably the bare edge count, which the
Gauss constraint (acting on the internal fiber) may not touch; but the D5 ensemble ranges
over decorations, so correlations can enter through the soldering sector. Decidable on
finite witnesses; either answer is publishable. `[job: lambda-count-dichotomy]` (finite
witnesses both ways; oracle probes on larger ensembles remain the standard follow-up).

### Making the conjugacy native: a finite Fourier/uncertainty theorem

Pro's sharpest formal proposal: build the finite volume register `|N>` and `Lambda`
register related by a finite Fourier transform (`|Lambda> = sum_N e^{i Lambda N} |N>`), and
prove a finite uncertainty relation `DeltaN * DeltaLambda >~ 1` (Donoho-Stark-style support
uncertainty over `ZMod N` is the kernel-checkable form). Then "`Lambda` is conjugate to
volume" is *native* to the finite information theory, not imported from unimodular gravity.
The mass/`Lambda` dictionary becomes exact: **mass = residual mixedness of hidden null
directions; `Lambda` = residual phase noise of hidden null volumes** — the same
trace-out-the-hidden-register operation applied to the direction register (mass) vs the
volume register (`Lambda`). `[job: lambda-conjugacy-uncertainty]`

### The area-law reading `[C/spec]`

For a Hubble volume `V_H ~ H^{-4}`: `sqrt(V_H) ~ H^{-2} ~ A_H` (the horizon area in Planck
units), so `Lambda_rms ~ 1/sqrt(V_H) ~ 1/A_H` — the observed `Lambda` is **inverse
horizon-area** suppressed. In a null-edge ontology this is suggestive (horizons are null
boundaries; volume uncertainty looks like an area count): "dark energy is the inverse area
of the causal diamond's null information boundary." Conjectural interpretation, not a
theorem; the exponent identity (`V = A^2 => 1/sqrt(V) = 1/A`) is trivially formalizable and
the interpretation stays `[C/spec]`.

### Predictions (the shape, conditional on the Poisson branch)

1. `<Lambda> ~ 0`, `Lambda_rms ~ V^{-1/2}` — the observed positive value is a realization;
   the **sign is not derived** (honest boundary).
2. **Coincidence is permanent**: `|rho_Lambda| ~ rho_crit` at every epoch — tiny because
   the universe is old and large, not because of microscopic tuning.
3. Deviations are **horizon-scale** (long correlation length, low-frequency drift), not a
   clustering local fluid.
4. **CPL fits may mislead**: a stochastic `Lambda(t)` projected onto `(w0, wa)` can fake
   smooth evolution; the underlying object is volume noise, not a rolling scalar.
5. **No exact future de Sitter equilibrium**: `Lambda_rms ~ t^{-2}` keeps tracking rather
   than settling — long-term acceleration may be intermittent or weakening.

### Observational posture (for the manuscript's eventual paragraph; all `[import]`, verify before citing)

Planck 2018 (arXiv:1807.06209) makes rigid `LambdaCDM` the baseline. DESI DR2 BAO + CMB
(arXiv:2503.14738) report a time-evolving equation of state fitting better than `LambdaCDM`
at ~3.1 sigma (2.8-4.2 sigma with supernovae) — *hints*, not a replacement. The honest
posture: the framework *inherits* a falsifiable phenomenology (fluctuating, sign-changing,
`1/sqrt(V)`-tracking dark energy) **conditional on the Poisson branch of the dichotomy**,
where the framework itself gets a vote. Cautions to include: Zwane-Afshordi-Sorkin (everpresent
models can fit as well as `LambdaCDM` and relieve low-z tensions) vs the Aspects-II finding
(CMB-favored fluctuation magnitudes are smaller than typical everpresent models) — a live
tension, not a confirmation. A confirmed rigid `w = -1` with tight fluctuation bounds is the
kill; a confirmed deviation is friendly but NOT a confirmation of this framework.

### Inflation note `[spec]`

Small `V` makes `Lambda_rms ~ V^{-1/2}` large: the early universe naturally has large
vacuum-like pressure fluctuations of order the ambient density. This makes early
acceleration less alien but does **not** derive inflation (no long smooth positive phase,
no perturbation spectrum). Whether positive-sector decoding selects prolonged-positive-
`Lambda` histories is a `[spec]` question, one line, nothing more.

### The rung table (jobs of 2026-07-09)

| Rung | Content | Status |
|---|---|---|
| L1 `lambda-unimodular` | finite unimodular trade: count-constrained stationarity => `+Lambda*1` multiplier term; order-0 shifts are gauge on the constraint surface; `tr(1)` channel-blindness | **LANDED M** (`LambdaUnimodular`) |
| L2 `lambda-edge-count` | extensive edge count = volume; everpresent scaling through the native primitive | **LANDED M** (`LambdaEdgeCount`) |
| L3 `lambda-susceptibility` | grand-canonical `Var(N) = T d<N>/dmu`; `Lambda_rms = sqrt(chi_N)/<N>`; Bernoulli bound => everpresent as upper bound | submitted |
| L4 `lambda-count-dichotomy` | the fork on finite witnesses: free/independent => `Var = sum p(1-p)` (Poisson in the sparse limit) vs a constrained witness with strictly sub-extensive variance (hyperuniform direction) + the pre-registered kill criterion | submitted |
| L5 moment hierarchy | `Lambda` = order-0 / gravity = order-2 / matter = order-4 of one functional | rides `spectral-action-avatar` (2db9868c) + L1's blindness lemma |
| L6 surfacing | one graded manuscript section + the **exponent prediction** (`Lambda_rms ~ N^{-1/2}` on the Poisson branch; deviation from -1/2 measures hyperuniformity — an exponent, not a scale, per program discipline) + observational posture | after L1-L4 land |

### The `Lambda`-specific event horizon (restated so no sentence drifts)

No derivation of `V` (hence not of the value `10^{-122}`); no derivation of the **sign**
(the positive-sector/Krein sign-bias question is one `[spec]` line at most); no claim on the
stochastic *dynamics* (sequential growth is causal set theory's, not ours); and the claim to
defend is exactly: **the framework dissolves the magnitude divergence structurally (L1/L5),
explains the coincidence conditionally (L4 Poisson branch), and derives neither the value
nor the sign.** The vacuum-sequestering theorem (local `c*1` shifts neutralized by the
unimodular constraint — Pro's target E) is the hard remaining magnitude theorem; L1 contains
its finite core.

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

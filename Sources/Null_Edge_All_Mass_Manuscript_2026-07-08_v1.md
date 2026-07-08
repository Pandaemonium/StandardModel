# All mass from null edges

**A machine-verified account of where mass comes from, built from a single
primitive: light-speed transport that disagrees with itself.**

Draft v1, 2026-07-08. Status: **[DRAFT-MS]**. This is the *all-mass*
manuscript; it subsumes and cites the P1 origin-of-mass draft
(`Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md`) rather than
replacing it.

Every technical claim below carries a grade, and the grades are the
point of the paper as much as the claims are:

| Grade | Meaning |
|---|---|
| **T** | source-verified theorem (external mathematics) |
| **M** | machine-verified: kernel-checked in Lean 4 under the pinned toolchain, axiom-audited, guard-pinned |
| **MEMO** | expert-verified prose; kernel transcription pending |
| **C** | pre-registered conjecture with an explicit kill condition |
| **[import]** | an external result used as input, not reproved here |

The discipline this paper holds itself to: **a sentence that claims more
than its grade licenses is an error, however true it may turn out to be.**
Two long-standing conjectures of this program died this month by their own
pre-registered tests (§10). We report those with the same prominence as
the theorems, because a program that cannot say what it has *disproved*
cannot be trusted about what it has proved.

---

## 1. Thesis and reading guide

One sentence: **mass is the obstruction to coherent null transport.**

Unpacked: the only primitive is a *null edge* — an elementary step that
moves at the speed of light, the way a photon does. Nothing in the theory
is slow, and nothing is heavy, at the bottom. Bind several such steps into
one object and ask whether the bundle can still move at light speed. If
its constituent light-directions all agree, it can, and it is massless.
If they disagree, the bundle as a whole cannot keep up with light, and the
amount by which it falls short *is* its mass. Mass is trapped, mutually
disagreeing light.

The organizing slogan of the formal work is **"unification is
decomposition."** A single finite operator — the carrier Dirac operator —
squares to a sum of four terms, and each term is one physical channel
through which mass enters: aperture (kinetic), closure (gauge / QCD), turn
(Higgs / Yukawa), and soldering-gradient (gravity). We do not unify the
forces by identifying them; we unify them by exhibiting them as four
summands of one square (§4).

**How to read this paper.** Part I (§2) is written for a reader who has
seen special relativity and a little quantum mechanics — no gauge theory
assumed. From §3 onward the grades take over and the register is
technical. A reader who wants only the verified core can read §3 (the one
trusted theorem), §4 (the decomposition that organizes everything), and
the anchor table (§11), and skip the rest.

---

## 2. Part I: what is a particle, and what is mass?

*(This section makes no new claims; it is the physical picture behind the
mathematics, in plain language.)*

**A particle is a knot of trapped light.** Picture an electron not as a
tiny ball but as light caught zig-zagging: a left-moving light-step, then
a right-moving light-step, alternating forever. Each leg races at the
speed of light. But a zig-zag that reverses on itself does not *get*
anywhere fast — its average progress is slow, and a particle "at rest" is
the extreme case where the legs cancel and the light runs in place. This
is the old idea that a massive particle is light that has been trapped, and
this program's central theorem (§3) makes it exact: **the mass of a bundle
of light-steps is precisely the total disagreement among their
directions.** All directions parallel: no disagreement, no mass, and the
thing flies off at light speed like a photon. Any disagreement: mass.

**Where mass is made: the corners.** The mass lives not in the legs of the
zig-zag but in the *corners* — the events where the light changes
direction. Take away the ability to turn, and the particle runs straight
at light speed forever, massless. So "how much mass" and "how often it
turns" are the same question. And a turn is not free: turning a
left-handed mover into a right-handed one changes a bookkeeping quantity
(weak charge) that must balance, and the thing that balances it is a field
filling all of space — the Higgs. In this picture the Higgs is not an
optional extra; it is the entry the corner *requires* in order to exist
(§5).

**What a particle is made of: strands.** Internally, a particle's identity
is a short list — which of a few elementary "strands" it carries. Charge
is the bookkeeping of that list: quarks and leptons differ by how many
color strands they hold, which is why quark charges come in thirds; lepton
number and baryon number are just *counts* of strands (the Q04
analysis). An antiparticle is the same list read backwards. The whole
particle zoo of one generation is the catalogue of ways to occupy a
handful of strands.

**Why particles are stable: topology.** Some patterns cannot come apart,
not because a force holds them but because a *count* forbids it. When the
left-handed and right-handed slots fail to balance, the surplus cannot
find a partner to turn with, and so it cannot acquire mass no matter what
fields you switch on. It stays massless the way a knot stays knotted (§8).
This is the program's reading of why masslessness in the Standard Model
tracks chirality.

**Nothing moves slower than light — fundamentally.** Every edge is null.
The electron on your desk is, in this ontology, moving at light speed the
entire time — it simply is not *going* anywhere, because its light-steps
disagree and cancel. "Slower than light" is what the statistics of
disagreeing light-steps looks like from far away. There is no slow
substance underneath.

That is the entire picture. The rest of the paper is the mathematics that
makes each italicized claim precise, and honest about which are theorems
and which are still hopes.

---

## 3. The kinematic layer: one trusted theorem (**T**/**M**)

Everything orbits a single kernel-checked identity. Represent a massless
degree of freedom by a two-component Weyl spinor `psi`; its contribution
to energy-momentum is the rank-one Hermitian matrix `psi psi^dagger`. A
particle-like system is a finite bundle of these, with total momentum
`P = sum_i psi_i psi_i^dagger`. Then

```text
det P = sum_{i<j} | psi_i wedge psi_j |^2 .
```

The left side is invariant mass squared. The right side is the total
pairwise *disagreement* of the null directions — the sum of squared
wedges, which vanishes exactly when two directions are parallel. So:

- A single null edge is massless: `det (psi psi^dagger) = 0`
  (`det_rankOneHermitian_eq_zero`, **M**, trusted namespace
  `PhysicsSM.Spinor.PluckerMass`); and the two-edge mass identity and its
  collinearity criterion are trusted there too (`two_edge_plucker_mass_identity`,
  `two_edge_mass_zero_iff_wedge_zero`).
- Mass equals total pairwise disagreement for any finite bundle
  (`fin_bundle_plucker_mass_identity`, **M**; the general `n`-bundle
  version is kernel-checked in the Draft namespace).
- Mass is exactly zero iff all directions are projectively collinear —
  one common beam (`fin_bundle_mass_zero_iff_common_direction`, **M**, Draft).

This is the precise form of "mass is trapped disagreeing light," and it is
the strongest thing the program owns: kernel-checked, axiom-audited, in the
trusted layer. It is also *only* kinematics — it says what mass *is* for a
given bundle, not what dynamics builds the bundle. The rest of the paper is
about the dynamics, and it is held to a lower grade for exactly that
reason.

---

## 4. The organizing spine: the mass-budget decomposition (**M** + **C**)

The dynamical object is the finite carrier Dirac operator on a finite
2-complex,

```text
D = sum_e c(alpha_e) nabla_e + Gamma phi ,
```

with a null covector soldering `c(alpha_e)` on each edge (a Clifford
coefficient, `c(alpha)^2 = 0`), a covariant transport `nabla_e`, and a
vertex "turn" term `Gamma phi`. The master identity of the whole program is
that its Krein-adjoint square decomposes into channels:

```text
4 . D^#D  =  Q_A  +  Q_C  +  4 Q_T  +  E_#            (carrier_krein_square, M)
```

and every other channel statement is a specialization of this one equation.
Each summand is one physical channel, and the reader can carry this table
through §§5–9:

| channel | operator shape | force | how the invariant enters | positivity |
|---|---|---|---|---|
| `Q_A` | aperture / `{nabla, nabla}` | kinetic | Plücker mass of §3 (`det P`) | positive (§3) |
| `Q_C` | closure / `[gamma,gamma][nabla,nabla]` | gauge / QCD | chromomagnetic `sigma·F`, §6 | signed (§6/§8) |
| `4 Q_T` | turn / `phi^2` | Higgs / Yukawa | corner amplitude, §5 | turn-sign |
| `E_#` | Krein self-adjointness defect | — | cross term, §7 | vanishes in the self-adjoint gauge class |

**Two specializations, both kernel-checked.** In the self-adjoint gauge
class the cross term `E_#` vanishes, and the master identity reduces to the
three-slot square `4 D^2 = Q_A + Q_C + 4 Q_T` (`carrier_square_assembly`,
**M**) — this is the form §§5–6 use. Separately, for *varying* soldering the
gravity channel is a genuinely distinct object, the soldering-gradient
defect `E` of `weitzenbock_master_varying` (**M**, §7) — note this `E` (a
`D^2`-defect measuring non-constancy of the soldering) and the Krein
cross-term `E_#` above are two different blocks; identifying them is a
conjecture (**C**), not a theorem.

**Unification is decomposition.** These are not four theories glued
together; they are four summands of one square. The claim the program
stakes is that *the* invariant — pairwise null disagreement — reappears in
each channel through a different canonical map.

**The budget corollary (M).** A one-line consequence of the assembly
(apply any linear expectation `ev` — the state functional `<psi, . psi>` —
and divide by `M^2 = 4 ev(D^2) != 0`): the channel shares

```text
b_A + b_C + b_T = 1 ,
```

is kernel-checked (`signed_budget_sum_one`, **M**), with a concrete
non-vacuous witness: a single-edge `2x2` carrier gives closure share
exactly zero (one edge, no closure) and budget `(1/2, 0, 1/2)`
(`witness_budget_sum_one`, **M**). Two honesty rails, both load-bearing:

1. **The shares are signed.** We do *not* call them positive fractions.
   Whether a channel share is positive is the closure-positivity question
   of §6 — now *resolved*: `b_C` is genuinely signed (the closure form is
   balanced on the physical sector), so `b_C` can be negative on some
   states. This is not a defect: §8 explains why the physics of chiral
   symmetry breaking *requires* the closure channel to have negative
   directions.
2. **`b_C` is the chromomagnetic share, not "gluon energy."** The closure
   *channel* `Q_C` is linear in field strength (a `sigma·F` /
   chromomagnetic object); the `|F|^2` gluon *energy* density is a
   different object (the Wilson action, §6). Conflating them is a
   pre-registered error (§10).

The physical target this shape is aimed at — a finite analogue of the Ji
decomposition of the proton mass — is grade **C**: the weak claim
(non-turn dominance, `|b_T|` small, matching that ~99% of nucleon mass is
not Higgs-generated `[import]`: Yang et al., proton mass decomposition) is
the honest first goal; the strong claim (closure is the single largest
share) is a separate, harder, falsifiable test.

---

## 5. Turn mass: the Higgs-shaped channel (**M** + a reported kill)

The turn block `Q_T = phi^2` is where mass enters at a corner. The
mechanism, in the program's language: a corner converts a left-handed
light-mover into a right-handed one; the two carry different weak charge;
the corner must therefore exchange weak charge with a background
condensate; that condensate is the Higgs. The corner amplitude *is* the
mass. This is a **MEMO**-grade reading, resting on the kinematic corner
identity (`onshell_wedge_normSq_eq_coin_sq`, **M**, kernel-checked in
`GateI1/MassCoinBridge.lean` — a supporting identity, not guard-pinned;
§11) and the Standard-Model strand bookkeeping (Q04, **MEMO**).

**A reported kill (this is the honest heart of the section).** The program
attempted to derive the *value* of the charged-lepton mass ratios — the
Koide relation `Q = 2/3` — from corner geometry, via a soldering
coefficient `kappa` that would have to equal 1. A pre-registered numerical
probe measured it: `kappa = 3/2`, not 1, predicting `Q = 5/9` against the
observed `2/3`, and the carrier reduction does not even produce the
required uniform-diagonal form. **The tetrahedral-corner Koide route is
dead** (probe P1, `TSOLDER_KAPPA_ANALYSIS.md` §4a). What survives is the
equipartition trace identity behind the Koide *combination* (pure algebra,
unaffected) and a sharper open question — see §8. Any future mass-value
route must additionally clear the Sumino bar `[import]`: a real Koide
mechanism must survive QED running, which this route never reached. The
honest status of mass *values* in this program is therefore: **no live
prediction**; ratios, not absolute scales, are the only admissible targets
(§10).

---

## 6. Closure mass: the QCD-shaped channel (**M** + the central crux, resolved)

Most visible mass is QCD binding energy. In this program it lives in the
closure channel, and the closure channel is where the program is,
surprisingly, furthest along outside pure kinematics.

**The Wilson action is a squared closure defect (M).** Before any carrier
identification, the standard lattice gauge action is *exactly* the squared
norm of the failure of transport to close around a face: for a face
holonomy `U`,

```text
Tr((1 - U)^dag (1 - U)) = 2N - 2 Re Tr U ,
```

so the Wilson plaquette weight `N - Re Tr U` is half the Hilbert-Schmidt
square of the closure defect `1 - U`
(`wilson_plaquette_eq_half_closure_defect`, **M**;
`closure_defect_trace_eq`, **M**). QCD's action and the program's closure
channel are the same object at the source. And this squared defect *is
positive energy*: for the linearized connection its leading value is the
non-negative Hilbert-Schmidt norm `-Tr(A²) = ‖A‖² = |F|²` at leading order
(`leading_closure_energy_nonneg`, **M**), zero exactly at flatness. The
static-pair potential then reads as the transfer-time cost of excess areal
closure defect (**C**, Amendment A2). (This `|F|²` *defect-gram* energy is
distinct from the chromomagnetic `Q_C` channel — §4 rail 2.)

**The strong-coupling pillars are kernel-checked (M).** On concrete finite
lattices: the Wilson-loop area law (`tyAreaLaw_slab_exp`), slab reflection
positivity (`wilsonSlabConnected_reflectionPositive`), an OS-reconstructed
spectral gap (`osSpectralGap_pos`), and exponential clustering
(`slab_exponential_clustering`) — the two hard pillars of confinement and
mass gap, in their strong-coupling forms. The one remaining hole in the
gap chain is a finite forest-counting injection, now diagnosed (this
month, audit memo, **MEMO**) as a *malposed statement* rather than a hard
proof: the total-block
permutation count collapses under the root-pinning constraint, so the
structured-partition route is the only viable one
(`PolymerKPConclusion.lean`; K1-STEP0 audit).

**The closure channel is an exact Krein square — and this relocates the
crux (M + MEMO).** The nonabelian closure block factors exactly:

```text
Q_C = L^# L ,   L = c(alpha_1) (x) 1 + c(alpha_2) (x) (-K/2),
      K = [nabla_1, nabla_2] ,
```

with the abstract square identity kernel-checked (`null_soldered_square`,
`closure_current_square`, **M** — a group-free ring identity with explicit
hypotheses, which is *stronger* in that direction); the group-independence
(any compact group) and the GL-torsor classification of representatives are
**MEMO**, oracle-verified across SU(2) and SU(3)). But a Krein square carries no
positivity by itself — null Clifford coefficients are isotropic, so the
square has no positive-definite diagonal. Therefore:

> **The central crux, resolved as a structured no-go (M engine + MEMO).**
> Positivity of the closure channel is not a full-space fact and never
> could be; it can hold only on the physical (Gauss-law) sector `V'/N`.
> The resolution (Fable analysis, this run): closure is **not** positive
> there — it is exactly *balanced* (Krein signature zero), structurally.
> The mechanism is a grading anticonjugation: the closure bivector
> `b = sigma_z (x) 1` satisfies `b^{-1}(J Q_C) b = -(J Q_C)` and preserves
> every gauge-defined constraint sector (gauge acts on the color factor
> alone, commuting with `b`), and a Hermitian form congruent to its own
> negative has equal positive and negative inertia. The kernel engine is
> proved: anticonjugation forces every odd power traceless
> (`anticonj_odd_pow_trace_zero`, **M**), so the form's spectrum is
> symmetric about zero; the half-constraint rigidity that forces the
> single-covector Gauss charge is also kernel-checked
> (`half_constraint_rigidity`, **M**); and the balanced inertia is
> confirmed on the `6x6` witness by the pre-registered numeric probe
> (`sig = (2,2,0)`, oracle). So `Q_C` is honestly a *signed* chromomagnetic
> channel; physical positivity must come from the `J`-definite complement
> of the closure doublet (the matter/transverse directions), exactly as in
> Gupta–Bleuler the longitudinal pair contributes zero norm. Two clauses
> stay MEMO pending their own rungs: the concrete `V'` construction from
> the carrier Gauss covectors, and the step from odd-moment-vanishing to
> the inertia count.

A second correction the resolution forces: the gate as originally posed
asked whether a torsor *representative* `L_A` descends to `V'`; it does
not (**MEMO**), but that was the wrong question — only the *square* `Q_C`
needs to descend, and it does iff the finite Ward condition
`K(ker G) subseteq ker G` holds. The existing finite Kugo–Ojima witnesses
frame the surviving question: the nonvacuous positive sector on `(2,1)`
(`nonvacuous_positive_sector`, **M**) and the indefinite no-go on `(1,2)`
(`nondegenerate_but_indefinite_no_go`, **M**) show the decision quantity is
the inertia surplus `p - q` on the doublet-free complement — now with a
mechanism. Scope, stated plainly: everything here is finite and
strong-coupling; the continuum Yang–Mills mass gap is the Clay problem and
is **not claimed** (§10).

---

## 7. Soldering mass: the gravity-shaped channel (**M** + **C**)

The soldering-gradient block `E` is the gravity-shaped channel: it
measures how the null soldering fails to be covariantly constant, via the
frame commutator `D(e,f) = nabla_e gamma_f - gamma_f nabla_e`. The finite
"geometric trinity" split is now kernel-checked:

```text
2 E = Contract(T) + Contract(S)
```

(`eslot_torsion_solder_split`, **M**, choice-free), with `T` the
antisymmetrized soldering difference (torsion-shaped) and `S` a symmetric
remainder (non-metricity-shaped). And the split is *non-trivial*: the
program's earlier conjecture that `E` is *pure* torsion is refuted by an
explicit `2x2` witness where the symmetric contraction does not vanish
(`eslot_not_pure_torsion_witness`, **M**; §10). So at finite algebraic
level the gravity channel is a torsion-plus-non-metricity mix, not pure
teleparallel — the corrected statement after the pure-torsion kill.

What remains conjectural (**C**) is the *geometric* reading: identifying
`T` and `S` with a discrete contorsion and non-metricity carrying the
right transformation law, with the discrete teleparallel /
symmetric-teleparallel literature `[import]` (Pereira–Vargas and
Regge-adjacent work) as the anchor. This is still the least-developed
channel physically, and the honest content is mostly the boundary, per the
Malament split: causal order supplies the light-cone structure for free,
and the decorations owe exactly the scale. But the finite *algebra* of the
split is a theorem, not a hope.

---

## 8. Protected masslessness: topology forbids mass (**M**)

Some modes cannot acquire mass, and this is a theorem, not a tuning. The
finite McKean–Singer index family shows that for a rank-symmetric carrier
the chiral index equals the graded dimension
(`chiralIndex_eq_graded_dimension`, **M**), and an unbalanced count forces
an exact massless mode immune to every potential and transport
(`exists_protected_massless_mode`, **M**). Masslessness of the chiral
surplus is topological — the knot of Part I, made precise.

**A new protection mechanism, found this month (M + C).** A determinant-
parity probe redirected a stalled line of work: the protected zero modes of
the decorated transport cycle are *not* forced by cyclic symmetry (that
reading was falsified — abstract symmetric data is generically unpinned),
but by a **chiral** symmetry — an involution `Gamma` with
`Gamma W Gamma = W^dagger`, which is exactly the edge-orientation-reversal
grading that also gives the program's Ginsparg–Wilson structure. Its
kernel-checked core: a unitary carrying such an involution has determinant
`+-1` (`chiral_det_eq_pm_one`, **M**); by the standard conjugate-pairing of
unitary spectra (**T**, transcription pending) that sign pins the parity of
the `-1`-eigenvalue multiplicity (the Lean file states the determinant fact;
the multiplicity reading is prose, per its own docstring). The full amplitude-independent double pinning
(observed for every hop strength) is grade **C**, awaiting the chiral
winding invariant `[import]` (Asbóth–Obuse, chiral quantum walks). The
resulting spectrum on the small cycle is neutrino-shaped (one exactly
massless mode; oracle observation, **C**) — which is where the mass-value
question, having failed for charged leptons (§5), honestly relocates.

**Why indefiniteness is a feature, not a bug.** The closure channel's
global indefiniteness (§6) is *required* here: chiral symmetry breaking
needs the curvature term to pull eigenvalues toward zero against the
positive kinetic part, so a positive-definite closure channel would have
killed this mechanism outright. §6 and §8 are coupled in the right
direction: the same sign structure that blocks naive closure positivity is
what makes protected and near-protected light modes possible.

---

## 9. Dynamics: mass generation under coarse-graining (**M**)

The kinematic theorem (§3) says what mass *is*; this section's theorem says
coarse-graining *makes* it, from the same invariant. One decimation
(Schur-complement) step on a null chain — integrating out a hidden site —
converts square-zero (null) edge terms into a non-null effective term. The
abstract law is

```text
(a b)^2 = k . (a b)   for   a^2 = b^2 = 0,  a b + b a = k . 1
```

(`null_pair_prod_sq_eq_pairing_smul`, **M**): the effective term fails to
be nilpotent exactly when the pairing `k` is nonzero — and for null
directions, nonzero pairing means non-collinear, i.e. *disagreeing*. On the
concrete three-site chain the induced edge is a nonzero idempotent
(`effective_edge_not_nilpotent`, **M**), where none existed before
blocking. The negative control is what makes this a statement about mass:
collinear couplings produce exactly zero effective coupling
(`collinear_schurComplement_eq_zero`, **M**) — nullity survives blocking
precisely on the massless configurations.

So the program's thesis is two-sided, and both sides are kernel-checked:
*kinematically* mass is pairwise null disagreement (§3); *dynamically*,
coarse-graining converts that same disagreement into an effective mass
term, and converts nothing when there is no disagreement.

**The coupling is a propagator element (M).** For a general (non-scalar)
invertible hidden block, the effective edge term is
`c(l) Minv c(n) = (Minv)_{11} . (c(l) c(n))`
(`nullL_mul_mid_mul_nullN`, **M**): the generated coupling is exactly the
matrix element of the hidden-block resolvent between the two null
light-cone directions, and it is non-nilpotent iff that element is nonzero
(`mid_effective_not_nilpotent`, **M**). This is the expected physics — the
effective coupling between two null directions is their propagator
overlap — and it recovers the scalar case as `Minv = mu⁻¹ . 1`.

Claim boundary: one finite decimation step — no renormalization-group
flow, no fixed point, no continuum. The bridge from this step to
constituent-mass generation was conjectured (Amendment A4) as "blocking a
closure-disordered background increases the finite near-zero count `N_m`
of §6". A pre-registered probe this run **refutes that at the finite
random-disorder level**: both generic and chiral-preserving random
closure disorder *decrease* `N_m` (they spread the spectrum away from
zero). So the Banks–Casher accumulation that would signal a condensate is
*not* produced by finite random curvature; it needs a specific coherent /
topological low-mode structure or a thermodynamic limit. The §9→§6 bridge
is therefore a documented kill at this level, and the honest open question
is sharper: *which* structured (not random) closure backgrounds accumulate
low modes. Grade **C**, with the naive version now closed.

---

## 10. Boundaries, and the things we have disproved

**The permanent boundary.** No continuum limit is claimed. No physical mass
scale (dimensional transmutation) is claimed. Nothing Clay-adjacent is
claimed. The only sanctioned limit language is the refinement-ladder
(quotient-then-limit) discipline, and the only admissible mass targets are
dimensionless ratios protected by finite structure — never absolute MeV
values (finding 9; NuFIT-6.0 `[import]` for the one neutrino ratio that is
a legitimate finite target).

**The kills — reported with the prominence of the theorems.** A reader
familiar with the field will expect several natural ideas; here is why each
is dead, so no one re-derives them:

- **Koide from tetrahedral corner geometry** — killed by measurement
  (`kappa = 3/2`, probe P1). The equipartition identity survives as algebra
  (§5).
- **"`Tr E` = discrete torsion"** — killed by probe; replaced by the
  trinity-split target (§7).
- **"`Q_C` = site-diagonal defect Gram"** — killed structurally (grading:
  `Q_C` is purely off-diagonal, orthogonal to every site-local Gram). The
  defect Gram is a real object — it is the Wilson action — just not this
  operator (§6).
- **"`Q_C` is the positive gluon-energy share"** — killed by the
  chromomagnetic distinction: `Q_C` is linear in `F` (hyperfine-shaped);
  the `|F|^2` energy is the defect Gram (§4, §6).
- **Cyclic symmetry forces the protected zero mode** — falsified; the
  correct mechanism is chiral, not cyclic (§8).
- **Retardedness alone deletes fermion doublers** — killed by a
  determinant-level obstruction; one-sided Ginsparg–Wilson inversion is
  false nonabelian (explicit counterexample); the palindromic transfer
  ordering is the correct convention.
- **Spectral-measure language before positivity** — embargoed
  program-wide; finite eigenvalue-*count* identities are the sanctioned
  form (§6's Banks–Casher count, `banks_casher_count`, **M**).
- **"Random closure disorder increases the near-zero count `N_m`"** (the
  naive §9→§6 constituent-mass bridge, Amendment A4) — killed by a
  pre-registered probe: finite random curvature, chiral or generic,
  *decreases* `N_m` by spreading the spectrum. Condensate accumulation
  needs structured, not random, low-mode content (§9).

**The open cruxes, ranked** (after this run's progress). The former #1 —
physical-sector closure positivity (S1-CC) — is now *resolved* as a
structured no-go (§6): closure is balanced, its algebraic engine is
kernel-checked, and the pre-registered numeric kill probe passed. What
remains: (1) the surviving positivity question it exposed — total-operator
positivity on the doublet-free complement, i.e. an aperture/turn-dominance
inequality over the `J`-definite directions (§6). (2) The strong-coupling
gap's forest injection (§6) — now a well-posed combinatorics problem, the
malposed-statement diagnosis in hand. (3) The multi-direction closure
square (a stabilization, largely dissolved). (4) The chiral winding
invariant for the double-pinning (§8). (5) Completing the S1-CC ladder in
Lean (Theorems 1–3: descent, restricted inertia, the grading no-go —
oracle-confirmed, transcription pending). Each is finite, each has a kill
condition, none requires new axioms.

---

## 11. The Lean anchor table

Every declaration cited in §§3–9, with file, grade, and guard-pin status.
All are kernel-checked under `leanprover/lean4:v4.28.0`. Axiom footprint is
the standard `[propext, Classical.choice, Quot.sound]` (several abstract
algebra lemmas are choice-free, `[propext, Quot.sound]`); the exact
footprints are the `#print axioms` messages inside the guard blocks. Guard
status: **trusted namespace** = outside `Draft/`, needs no pin;
**guard-pinned** = a `#guard_msgs … #print axioms` block enforces the
footprint in the named guard file; **local guard pin** = the block is in the
declaration's own file; **not pinned** = kernel-checked but without an
enforced pin (supporting identities only, never flagship claims). *(Table
anchor-swept — every name and guard status grep-verified against the repo on
2026-07-08, per the anchor rule.)*

| § | Declaration | File | Grade / guard | Role |
|---|---|---|---|---|
| 3 | `det_rankOneHermitian_eq_zero` | `Spinor/PluckerMass.lean` | T, trusted namespace | single edge massless |
| 3 | `two_edge_plucker_mass_identity` | `Spinor/PluckerMass.lean` | T, trusted namespace | two-edge mass = disagreement |
| 3 | `fin_bundle_plucker_mass_identity` | `Draft/NullEdgePluckerGeneralAristotle.lean` | M, Draft (kernel-checked) | mass = pairwise disagreement, general `n` |
| 3 | `fin_bundle_mass_zero_iff_common_direction` | `Draft/NullEdgePluckerGeneralAristotle.lean` | M, Draft (kernel-checked) | massless iff collinear |
| 4 | `carrier_krein_square` | `Carrier/CarrierKreinSquare.lean` | M, guard-pinned (`CarrierAxiomGuard`) | master identity `4 D^#D = Q_A+Q_C+4Q_T+E_#` |
| 4 | `carrier_square_assembly` | `Carrier/CarrierSquareAssembly.lean` | M, guard-pinned (`CarrierAxiomGuard`) | 3-slot specialization (`E_#=0`) |
| 4 | `signed_budget_sum_one` | `Carrier/CarrierMassBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | shares sum to one (abstract) |
| 4 | `witness_budget_sum_one` | `Carrier/CarrierMassBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | non-vacuous `(1/2,0,1/2)` witness |
| 5 | `onshell_wedge_normSq_eq_coin_sq` | `GateI1/MassCoinBridge.lean` | M, kernel-checked (not pinned; supporting) | corner flip amplitude = wedge |
| 6 | `closure_defect_trace_eq` | `GateYM/PlaquetteClosureAction.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure-defect trace identity |
| 6 | `wilson_plaquette_eq_half_closure_defect` | `GateYM/PlaquetteClosureAction.lean` | M, guard-pinned (`SlabAxiomGuard`) | Wilson action = squared defect |
| 6 | `leading_closure_energy_nonneg` | `GateYM/LinearizedClosureEnergy.lean` | M, local guard pin | leading closure defect = positive `|F|²` energy |
| 6 | `null_soldered_square` | `GateYM/S1ClosureCurrentAlgebra.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure square structure (abstract) |
| 6 | `closure_current_square` | `GateYM/S1ClosureCurrentAlgebra.lean` | M, guard-pinned (`SlabAxiomGuard`) | abstract skew-pairing square (concrete `Q_C=L^#L` is MEMO) |
| 6 | `tyAreaLaw_slab_exp` | `GateYM/TYAreaLaw.lean` | M, guard-pinned (`SlabAxiomGuard`) | strong-coupling area law |
| 6 | `wilsonSlabConnected_reflectionPositive` | `GateYM/WilsonSlabConnected.lean` | M, guard-pinned (`SlabAxiomGuard`) | slab reflection positivity |
| 6 | `OSReconstruction.osSpectralGap_pos` | `GateYM/OSReconstruction.lean` | M, guard-pinned (`SlabAxiomGuard`) | OS spectral gap |
| 6 | `slab_exponential_clustering` | `GateYM/SlabClustering.lean` | M, guard-pinned (`SlabAxiomGuard`) | exponential clustering |
| 6 | `banks_casher_count` | `GateYM/FiniteBanksCasherCount.lean` | M, guard-pinned (`SlabAxiomGuard`) | finite Banks-Casher count |
| 6 | `skew_prod` | `GateYM/FiniteBanksCasherCount.lean` | M, guard-pinned (`SlabAxiomGuard`) | count denominator `= m²+AᴴA` |
| 6 | `anticonj_odd_pow_trace_zero` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure balanced on physical sector (engine) |
| 6 | `nonvacuous_positive_sector` | `Carrier/KreinPositiveSectorWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | positive physical sector `(2,1)` |
| 6 | `nondegenerate_but_indefinite_no_go` | `Carrier/KreinPositiveSectorWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | indefinite no-go `(1,2)` |
| 7 | `weitzenbock_master_varying` | `Carrier/CarrierESlot.lean` | M, guard-pinned (`CarrierAxiomGuard`) | soldering-gradient `E` (varying soldering) |
| 7 | `eslot_torsion_solder_split` | `Carrier/CarrierESlotTorsionSplit.lean` | M, guard-pinned (`CarrierAxiomGuard`) | `2E = Contract(T)+Contract(S)` |
| 7 | `eslot_not_pure_torsion_witness` | `Carrier/CarrierESlotTorsionSplit.lean` | M, guard-pinned (`CarrierAxiomGuard`) | not pure torsion (witness) |
| 8 | `chiralIndex_eq_graded_dimension` | `Carrier/CarrierIndexProtection.lean` | M, guard-pinned (`CarrierAxiomGuard`) | index = graded dimension |
| 8 | `exists_protected_massless_mode` | `Carrier/CarrierIndexProtection.lean` | M, guard-pinned (`CarrierAxiomGuard`) | forced massless mode |
| 8 | `chiral_det_eq_pm_one` | `Carrier/ChiralZeroModeParity.lean` | M, guard-pinned (`CarrierAxiomGuard`) | chiral determinant dichotomy |
| 9 | `null_pair_prod_sq_eq_pairing_smul` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | decimation coefficient law |
| 9 | `effective_edge_not_nilpotent` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | blocking generates non-null term |
| 9 | `collinear_schurComplement_eq_zero` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | collinear negative control |
| 9 | `nullL_mul_mid_mul_nullN` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | coupling = propagator element |
| 9 | `mid_effective_not_nilpotent` | `Carrier/RGSchurMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | non-null iff propagator-coupled |

---

## Provenance and status

This manuscript is a draft of the overnight all-mass run (2026-07-08). Its
verified core (§3, §4, §6 pillars, §8, §9) is machine-checked; its physical
readings (§5, §7, the budget's hadron interpretation) are MEMO or
conjectural and labeled as such. The external anchors — Wilson,
Osterwalder–Seiler, Banks–Casher, Ji, Yang et al., Dürr et al.,
Asbóth–Obuse, Pereira–Vargas, NuFIT-6.0, Sumino — are `[import]` and are
recorded in `Sources/Null_Edge_References.md`. It supersedes nothing; it
sits beside the P1 origin-of-mass draft as the wider-scope companion.

# Mass as null disagreement: a machine-verified finite framework

**A finite, kernel-checked framework in which the invariant mass of a
bundle of light-speed degrees of freedom is the geometric disagreement of
their directions, and a single Dirac-type square decomposes into four
force-shaped channels. The one trusted theorem is classical kinematics,
formalized; the dynamics is finite operator algebra, graded honestly.**

Draft v1, 2026-07-08. Status: **[DRAFT-MS]**. It subsumes and cites the P1
origin-of-mass draft (`Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md`)
rather than replacing it.

*On the title (the paper's discipline applied to itself).* An earlier
working title, "All mass from null edges," claimed more than the grades
license: the kernel-checked content is (a) a classical kinematic identity,
formalized, and (b) finite operator algebra about a functional *conjectured*
(not yet proved) to be a mass — see §4 rail 3. Per this paper's own rule, a
title graded **C** is an error; the present title is what the grades support.
"All mass" survives only as the *program's* aim, not this paper's result.

Every technical claim below carries a grade, and the grades are as much the
point of the paper as the claims are:

| Grade | Meaning |
|---|---|
| **T** | source-verified theorem (external mathematics) |
| **M** | machine-verified: kernel-checked in Lean 4 under the pinned toolchain, axiom-audited, guard-pinned |
| **MEMO** | expert- and LLM-oracle-verified prose (hand-derivation plus frontier-model cross-check), pending kernel transcription — an explicit methodological choice, not a proof; failure mode is a convention or algebra slip that the kernel would catch |
| **C** | pre-registered conjecture with an explicit kill condition |
| **[import]** | an external result used as input, not reproved here |

The discipline this paper holds itself to: **a sentence that claims more
than its grade licenses is an error, however true it may turn out to be** —
and (per the reviews this draft has had) that discipline binds the
*interpretive* vocabulary too: the channel names of §4 are **structural
analogies at grade C** (no continuum reduction is claimed; §4a), and any
"oracle" / "Fable-analysis" evidence is a numerical experiment, not part of
the verified core (§11). Two long-standing conjectures of this program died
this month by their own pre-registered tests (§10); we report those with the
same prominence as the theorems, because a program that cannot say what it
has *disproved* cannot be trusted about what it has proved.

---

## 1. Thesis and reading guide

One sentence: **mass is the obstruction to coherent null transport.**

Unpacked: the only primitive is a *null edge* — an elementary step that
moves at the speed of light, the way a photon does. Nothing in the theory
is slow, and nothing is heavy, at the bottom. Bind several such steps into
one object and ask whether the bundle can still move at light speed. If
its constituent light-directions all agree, it can, and it is massless.
If they disagree, the bundle as a whole cannot keep up with light, and the
total amount of that disagreement *is* its mass squared (the exact form, §3;
"squared" is not a hedge — the invariant is literally a sum of squares).
Mass is trapped, mutually disagreeing light.

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

**Glossary (recurring terms and internal labels).** So the technical
sections do not rely on codenames a reader cannot decode:

*Objects.* **Null edge** — an elementary light-speed step (the only
primitive). **Carrier (Dirac) operator `D`** — the finite first-quantized
operator whose square organizes the mass channels. **`det P`** — the
Gram/Plücker invariant of §3 that equals total pairwise null disagreement;
the paper's definition of "mass" at the kinematic layer. **Krein space** —
a vector space with an *indefinite* inner product (a `+`/`−` metric); the
right setting for a Lorentzian, not Euclidean, operator, and the reason
"positive" is a theorem to be earned, not assumed. **Channel operators
`Q_A, Q_C, Q_T`** — three Krein blocks of `4 D^#D`: aperture/**kinetic**,
closure/**gauge–QCD**, and turn/**Higgs** respectively. **`E_#`** — the Krein
self-adjointness *defect* (the cross term; vanishes in the self-adjoint gauge
class); it is *not* the gravity block — identifying it with the gravity-shaped
soldering-gradient channel `E` of §7 is a *conjecture* (§4). (All channel
names are grade-C analogies, §4a.)

*Named external tools (all `[import]`/`T`).* **Weitzenböck / Lichnerowicz
identity** — the algebraic fact that a Dirac operator's square is a
Laplacian plus curvature; our four-block split is the finite instance.
**Ginsparg–Wilson** — the lattice way to keep exact chirality at finite
size; here the edge-orientation-reversal grading. **McKean–Singer /
Lefschetz index** — supertrace formulas that count protected modes; §8's
masslessness protection. **Banks–Casher** — relates near-zero eigenvalue
density to condensation; we use only its finite *count* form. **Schur
complement** — the linear-algebra "integrate out a site" step; §9's
decimation. **Rayleigh–Ritz** — variational characterization of the lowest
eigenvalue; the keystone (`sector_ground_mass`) that would turn the budget
functional into a mass.

*Internal labels (this program's own bookkeeping).* **S1-CC** — the
"closure-channel positivity" question (S1) and its resolution as
*balanced* (§6); the program's former #1 crux. **Amendment A2/A4** —
numbered proposals in the program's working memos (A2: closure-defect
energy; A4: the disorder→condensate bridge, since killed, §9/§10). **Probe
P#** — a pre-registered numerical oracle experiment with a kill condition
(e.g. probe P1 killed the tetrahedral-Koide route, §5). **`sector_ground_
mass`, `aperture_dominance_pos`, `carrier_square_assembly`, …** — Lean
theorem names; every one appears with its file and guard status in §11.

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
this program's central theorem (§3) makes it exact: **the mass *squared* of
a bundle of light-steps is precisely the total disagreement among their
directions** (the disagreement is a sum of squared wedges, so it carries the
dimensions of mass squared — see §3). All directions parallel: no disagreement, no mass, and the
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
number and baryon number are just *counts* of strands. An antiparticle is
the same list read backwards. The whole
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

## 2a. Related work: where this sits, and what is new

None of the physical *pictures* above is original, and the paper is stronger
for saying so; the novelty is a finite Krein-space setting, machine
verification, and the four-channel budget as one object. Situating the work:

- **The kinematic identity (§3) is classical spinor-helicity.** For a sum of
  real null momenta `P = Σ pᵢ`, `P² = Σ_{i<j} 2 pᵢ·pⱼ = Σ_{i<j} |⟨ij⟩|²`, and
  the invariant mass of a multi-massless system vanishes iff the momenta are
  collinear — textbook in the amplitudes literature (Elvang–Huang; Dixon,
  TASI lectures) `[import]`. Our contribution in §3 is *not* the fact but its
  Plücker/Cauchy–Binet packaging, its kernel-checked formalization, and its
  use as the organizing invariant that reappears in every channel. As an
  independent convention check, our spinor wedge `ψ⁰φ¹ − ψ¹φ⁰` coincides
  exactly with the left-handed Weyl metric `𝓔 = !![0,1;-1,0]` of the PhysLean
  physics library (`Physlib/Relativity/Tensors/ComplexTensor/Weyl`,
  Tooby-Smith) `[import]` — same 2-component `SL(2,ℂ)` spinors, same sign — so
  §3 is not idiosyncratic notation but the standard, independently-formalized
  object; PhysLean's `comm_metricRaw` is the `SL(2,ℂ)`-invariance that makes
  `det P` Lorentz-invariant.
- **Part I is Penrose and Feynman.** The zig-zag electron is Penrose (*Road
  to Reality* §25.2); the "velocity eigenvalues are ±c, rest is light running
  in place" picture is *Zitterbewegung* (Dirac; Hestenes); the discrete
  null-step-with-corners model is the **Feynman checkerboard**. The last is a
  standing **asset**, not just a citation: the checkerboard's continuum limit
  to the 1+1D Dirac propagator is a *proven theorem* (Gersch; Jacobson–
  Schulman) `[import]` — a `T`-grade external result that closes the §9/§10
  continuum gap *for the simplest chain*, which we import rather than reprove.
  **This is also the closest living prior art, and we flag it plainly:**
  Foster–Jacobson (2016), "Spin on a 4D Feynman Checkerboard" `[import]`,
  discretize the Weyl equation on a hypercubic lattice with **null faces**,
  with step amplitudes that are **spin projection operators** and a retarded
  propagator that is a product of projectors, and **no fermion doubling** — a
  construction startlingly close to our null-soldered Clifford carrier with
  reflection sectors. Our added structure is the Krein grading and the
  four-channel budget on top of such a carrier; the honest reading of F8/§9 is
  "cast the Foster–Jacobson null-face checkerboard as a Krein carrier and read
  its mass budget," not a new 3+1D checkerboard. Kull (2002) similarly builds a
  checkerboard on a *dense rational* (non-continuous) 2D Minkowski.
- **Structurally closest living programs.** The nearest relatives are the
  *indefinite-metric spectral-triple* programs, and we cite them because they
  already occupy ground §2a earlier drafts implied was ours: **Bizi–Brouder–
  Besnard (2016)** build a pseudo-Riemannian spectral triple over **Krein**
  spaces and *exhibit a physical-state space solving the fermion-doubling
  problem* `[import]` — the same Krein-positive-sector move we make (§6, §8);
  **Barrett (2007)** gives a *Lorentzian* version of the NCG Standard Model
  `[import]`; **Connes (2006)** cures fermion doubling by a KO-dimension-6
  twist `[import]`. Finster's *causal fermion systems* (finite/measure-
  theoretic, mass from a variational principle, no background) `[import]` and
  Connes' *spectral triples* generally (our carrier `D` with the `Γφ`
  fluctuation is NCG-adjacent) are the broader family. On the discrete-Dirac
  side, the *quantum-walk / quantum-cellular-automaton* literature (Bakircioglu–
  Arnault–Arrighi 2025 give a chiral, doubler-free, neutrino-like QCA and its
  Nielsen–Ninomiya evasion) `[import]` is the nearest kin to §8/the doubler
  discussion. Kauffman–Noyes combinatorial work and Wilczek's "mass without
  mass" (the QCD share) `[import]` are the nearest slogans; Zwanziger's (1991)
  lattice confinement / positivity-violation setting is a nearby comparison
  and a warning that this terrain is occupied, not source support for §6's
  finite balanced-closure theorem `[import]`.
- **What is new, stated by contrast — and narrowed after a literature
  review.** Neither the finite Krein setting (Bizi et al; Barrett) nor
  machine-verified physics (HepLean `2405.08863`, exact-ID verified but not yet
  source-quoted) `[import]` is new *on its own*, and we do not claim either.
  The defensible novelty is the **combination**: (i) a
  finite Krein *null-edge* carrier whose square is graded into a four-channel
  budget `4 D^#D = Q_A+Q_C+4Q_T+E_#` that **answers to the kernel-checked
  Plücker mass invariant `det P`** — we did not find this specific tie between
  an indefinite-metric operator budget and the §3 kinematic mass in our search,
  and we make no primacy claim;
  (ii) a **pre-registered kill-discipline** (grades, oracle quarantine, kill
  conditions) applied to a speculative unification — a working methodology, not
  "first verified physics"; and (iii) **kernel verification of a specific
  constructive-QFT chain** (reflection positivity → OS reconstruction →
  spectral gap → clustering), a machine-checked instance of that chain on finite
  lattices; we make no priority claim relative to existing verified-physics work
  such as HepLean. The pictures are borrowed and the individual ingredients are
  occupied; the combination, the `det P`-answering budget, and the verified
  kill-discipline are the current contribution. A full prior-art map with
  novelty-gap analysis is in
  `Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`. Full source-key:
  `Sources/Null_Edge_References.md`.

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
wedges, which vanishes exactly when two directions are parallel.

The sharpest reading is geometric: `P = sum_i psi_i psi_i^dagger` is a
positive matrix, and `det P` is the *area* (squared volume) its null
directions span in spinor space. A massless bundle has **rank-one**
momentum — all its light points one way, a single coherent beam. A massive
bundle spans a **two-** (or higher-) dimensional slice, and its mass squared
is exactly the area opened by the nonparallel directions. So "mass is trapped
disagreeing light" is, precisely, *mass is the area null directions open in
spinor space* — massless is rank-collapse, massive is spread. So:

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
the most solid thing the paper rests on: kernel-checked, axiom-audited, in
the trusted layer. **What is ours here is the formalization and the framing,
not the fact.** The identity is classical spinor-helicity kinematics (§2a;
Elvang–Huang, Dixon) — the invariant mass of a multi-massless system as its
total pairwise non-collinearity. Our contribution is (a) the kernel-checked
Plücker/Cauchy–Binet formalization and (b) the decision to make *this*
invariant the organizing quantity that every later channel is measured
against. It is also *only* kinematics — it says what mass *is* for a given
bundle, not what dynamics builds the bundle, and crucially not what its mass
*spectrum* is (a spectral quantity; §4 rail 3). The rest of the paper is
about the dynamics, held to a lower grade for exactly that reason.

---

## 4. The organizing spine: the mass-budget decomposition (**M** + **C**)

The dynamical object is the finite carrier Dirac operator on a finite
2-complex,

```text
D = sum_e c(alpha_e) nabla_e + Gamma phi ,
```

with a null covector soldering `c(alpha_e)` on each edge (a Clifford
coefficient, `c(alpha)^2 = 0`), a covariant transport `nabla_e`, and a
vertex "turn" term `Gamma phi`. The master identity of the whole program is that its Krein-adjoint square
decomposes into channels. The exact kernel-checked statement
(`carrier_krein_square`, **M**) is

```text
4 . D^#D  =  Q_A^#  +  Q_C^#  +  4 Q_T  +  4 E_#      (carrier_krein_square, M)

  Q_A^# = sum_{e,f} g(e,f) ( nabla_e^# nabla_f + nabla_f^# nabla_e )
  Q_C^# = sum_{e,f} ( gamma_e gamma_f - gamma_f gamma_e )
                    ( nabla_e^# nabla_f - nabla_f^# nabla_e )
  Q_T   = phi^2
  E_#   = sum_e gamma_e Gamma ( phi ( nabla_e^# - nabla_e ) )
```

Two honesty notes the paper's own discipline requires (both were drifts in
an earlier draft of this display): the aperture/closure blocks contract the
**Krein-adjoint** transports `nabla_e^#` against the bare ones — they are the
*starred* blocks `nabla_e^# nabla_f`, not `nabla_e nabla_f` — and the defect
enters with a **factor 4**, as `4 E_#`. Each summand is one physical channel;
the reader can carry this table through §§5–9 (operator shapes shown in the
self-adjoint gauge, where the blocks are bare — see the specialization below):

| channel | operator shape | force | how the invariant enters | positivity |
|---|---|---|---|---|
| `Q_A` | aperture / `{nabla, nabla}` | kinetic | Plücker mass of §3 (`det P`) | positive (§3) |
| `Q_C` | closure / `[gamma,gamma][nabla,nabla]` | gauge / QCD | chromomagnetic `sigma·F`, §6 | signed (§6/§8) |
| `4 Q_T` | turn / `phi^2` | Higgs / Yukawa | corner amplitude, §5 | turn-sign |
| `4 E_#` | Krein self-adjointness defect | — | cross term, §7 | vanishes in the self-adjoint gauge class |

**The hypotheses are the physics (and one of them freezes the Higgs).** The
master identity holds under an explicit hypothesis set, and three hypotheses
are load-bearing for how §§5–7 read: `hcl` (the Clifford/closure relation
`{gamma_e, gamma_f} = g(e,f)`), `hcomm` (soldering commutes with transport,
`gamma_e nabla_f = nabla_f gamma_e`), and `hCov` (the turn field is
covariantly constant, `nabla_e phi = phi nabla_e`). Two consequences must be
stated plainly, because the kernel sees them and the prose must not hide them:

- Under `hcomm` the soldering-gradient (gravity) channel of §7 is
  *identically absent* from this identity. So **no single kernel theorem
  contains all four forces**: the four-channel table is assembled from two
  theorems with different hypothesis sets — `carrier_krein_square` for
  aperture/closure/turn, and `weitzenbock_master_varying` (§7) for the
  soldering-gradient — and their union is a *program claim*, not one equation.
- Under `hCov` the turn block is `Q_T = phi^2` with `phi` frozen, so at **M**
  grade the "Higgs channel" is indistinguishable from an explicit Dirac mass
  term. The Higgs *reading* (§5) is a grade-C interpretation; the kernel sees
  a constant. This is the specific gap in the turn-channel name (§4a).

**Two specializations, both kernel-checked.** In the self-adjoint gauge class
(`nabla_e^# = nabla_e`) the cross term `E_#` vanishes and the starred blocks
become bare, so the master identity reduces to the three-slot square
`4 D^#D = Q_A + Q_C + 4 Q_T` (`carrier_krein_square_selfAdjoint`;
`carrier_square_assembly`, **M**) — this is the form §§5–6 use. Separately,
for *varying* soldering the gravity channel is a genuinely distinct object,
the soldering-gradient defect `E` of `weitzenbock_master_varying` (**M**,
§7) — this `E` (a `D^2`-defect measuring non-constancy of the soldering) and
the Krein cross-term `E_#` above are two different blocks; identifying them
is a conjecture (**C**), not a theorem.

**Unification is decomposition.** These are not four theories glued
together; they are four summands of one square. The claim the program
stakes is that *the* invariant — pairwise null disagreement — reappears in
each channel through a different canonical map.

*It is not a telescoping tautology.* A referee will ask whether `E_#` is
merely *defined* as the residual `4 D^#D − Q_A − Q_C − 4 Q_T`, which would
make the identity vacuous (an audit this run raised exactly this). It is
not: each of the four blocks has an **independent, canonical definition**,
visible in the display above — `Q_A^#` from the *anticommutator* (the metric
`g`), `Q_C^#` from the *commutator* (the Clifford bivector), `Q_T` from
`phi^2`, and `E_#` from the *specific* cross-term sum
`Σ_e γ_e Γ (φ(∇_e^# − ∇_e))`. The content of `carrier_krein_square` is that
these four independently-built operators *sum to* `4 D^#D` — a genuine
decomposition, not a renaming of a leftover. What remains open is not
non-vacuity but *forcing*:

*The honest weakness in this thesis, named as a conjecture.* Every
Dirac-type operator squares into a Lichnerowicz/Weitzenböck identity;
decomposition-of-the-square is a property of the *category*, not of our
carrier. So "unification is decomposition" is only a thesis if the
decomposition is *forced*. We therefore pre-register the missing rigidity
statement:

> **Conjecture (carrier rigidity, C).** The axioms — null soldering on a
> finite 2-complex, Krein structure, chiral grading, and covariantly
> constant turn field — determine the carrier operator and its four-block
> split *essentially uniquely* (up to the representation gauge already
> identified in §6). **Kill condition:** exhibit two axiom-satisfying
> carriers whose square-decompositions are not related by that gauge, or a
> fifth canonically-forced block. Until this is settled, §4's split is a
> *natural* decomposition, not a *forced* one, and the reader should hold
> "unification" to that lower standard.

**The budget corollary (M).** A one-line consequence of the assembly
(apply any linear expectation `ev` — the state functional `<psi, . psi>` —
and divide by `M^2 = 4 ev(D^2) != 0`): the channel shares

```text
b_A + b_C + b_T = 1 ,
```

is kernel-checked (`signed_budget_sum_one`, **M**), with a concrete
non-vacuous witness: a single-edge `2x2` carrier has closure share exactly
zero (`witness_QC_zero`, **M** — one edge, no closure) and, as an arithmetic
consequence of the kernel-pinned `sum = 1` and `D^2` value, shares
`(1/2, 0, 1/2)` (`witness_budget_sum_one`, **M**). *(The closure share of a
non-trivial state is generally nonzero: a color-singlet stretched over a
non-flat holonomy loop has `b_C` equal to a difference of Wilson loops — a
concrete rational `18`-dim quark–antiquark witness with `b_C = −32/223 ≠ 0`
and a hyperfine spin-flip splitting is designed and awaiting transcription;
Fable analysis this run.)* Three honesty rails, all load-bearing:

1. **The shares are signed.** We do *not* call them positive fractions.
   Whether a channel share is positive is the closure-positivity question
   of §6 — now conditionally resolved at the M-engine + MEMO-instantiation
   boundary: `b_C` is genuinely signed, and the checked `6x6` witness has
   balanced closure inertia on its `V'/N` realization. So `b_C` can be
   negative on some states. This is not a defect: §8 explains why the physics
   of chiral symmetry breaking *requires* the closure channel to have negative
   directions.
2. **`b_C` is the chromomagnetic share, not "gluon energy."** The closure
   *channel* `Q_C` is linear in field strength (a `sigma·F` /
   chromomagnetic object); the `|F|^2` gluon *energy* density is a
   different object (the Wilson action, §6). Conflating them is a
   pre-registered error (§10).
3. **What the budget decomposes is a quadratic functional, not yet a
   mass.** This is the paper's most important caveat, and it is the deepest
   open link. In §3 "mass" is `det P`, an invariant of a state's momentum
   (trusted, spectral). From §4 on, `M^2 := 4 ev(D^2)` is the expectation
   of an operator square in a *chosen* state against a *chosen* functional.
   The expectation of `D^2` is a genuine mass only at an eigenstate — on a
   Krein space, only at the ground state of a *positive* physical sector.
   So the four-channel budget honestly decomposes a quadratic functional,
   and it becomes a decomposition of a *mass* exactly when that functional
   is minimized on a *positive* sector. The keystone that performs this
   upgrade — a finite Rayleigh–Ritz theorem, `sector_ground_mass` — is now
   **kernel-checked (M, guard-pinned; proved this run by an Aristotle
   strengthening job)**: on a finite-dimensional sector with a *definite*
   inner product, an ordinary-self-adjoint `T = D^#D|_P` whose real form is
   bounded below by `c > 0` has its Rayleigh-quotient infimum attained *as a
   genuine eigenvalue that is `> 0`*. That is the exact statement that turns
   "a quadratic functional" into "a positive squared mass." But the theorem
   is honest about being **conditional**, and two independent expert reviews
   this run pinned exactly what it is conditional *on* — these are now the
   program's two deepest open links, not hand-waves:

   - *The positive sector must exist — now instantiated (M).* The hypothesis
     is a *definite* (`J`-positive) sector. On the single-doublet witness none
     exists (the closure grading balances the aperture's Krein form too), but
     that was a small-model artifact: `T2_positive_mass` (**M**, guard-pinned)
     builds an explicit **two-edge Cl(4) carrier**, proves its sector form
     `M6 = 1 + B^H B` positive-definite, and *fires* the keystone to yield a
     genuine positive squared-mass eigenvalue. The positive sector is now a
     theorem, not a hope.
   - *The eigenvalue and `det P` — free case now PROVED (M).* The keystone
     yields the least eigenvalue of `D^#D`; the §3 mass is `det P`. In the
     **free case** these coincide, kernel-checked: `free_mass_operator_eq_plucker`
     (**M**) shows the free carrier mass operator `P · adjugate P = det P • 1
     = (Plücker mass) • 1`, so its least eigenvalue *is* the §3 mass (the finite
     Clifford mass-shell). For **interacting** carriers the identification fails
     by the `Delta` binding-defect candidate — the eigenvalue drops *below*
     `det P` by a closure-controlled, off-diagonal amount, which is the
     physically correct behaviour (binding is not additive), not a gap. Naming
     `Delta` a finite binding invariant is the remaining grade-**C** target
     (§10).

**A worked example — the whole paper on one object.** Everything above is
concrete on a single carrier, the one `T2_positive_mass` (**M**) is built from.
Take two null edges: the Clifford factor is `Cl(4)` (Hermitian gammas
`γ_1=σ_x⊗I, γ_2=σ_y⊗I, γ_3=σ_z⊗σ_x, γ_4=σ_z⊗σ_y`), the color factor `C^3`, so
the carrier space is `C^12`. The closure bivector is `ω = γ_1γ_2`, the Krein
metric `J = iγ_3γ_4 ⊗ I_3 = diag(-1,-1,-1,1,1,1,-1,-1,-1,1,1,1)` (inertia
`(6,6)`), the aperture `Q_A = I_4 ⊗ 2·I_3`, the closure `Q_C = ω ⊗ K` with `K`
the skew curvature. The assembled Krein form `J(Q_A+Q_C)` is block-diagonal;
its `J`-positive sector is the 6 coordinates `{3,4,5,9,10,11}`, and the
compressed sector form is `M6 = 1 + B^H B` with eigenvalues `{1,3,2}` on each
block — **positive-definite, least eigenvalue 1** (aperture dominance
`2 > 1`). So on this one object: §3's kinematic mass is the Plücker `det` of a
momentum bundle; §4's budget splits `4 D^#D` into `Q_A + Q_C + 4Q_T + 4E_#`;
§6's closure `Q_C` is the balanced (chromomagnetic) block; the positive
physical sector exists (the 6-dim one above); and §4's keystone fires there to
give a genuine positive squared mass of `1`. The reader who wants a single
picture to hold should hold this carrier.

The physical target this shape is aimed at — a finite analogue of the Ji
decomposition of the proton mass — is grade **C**, and the two claims it
supports are *not* on the same footing, for a reason internal to QCD:

- **Weak claim (scheme-robust, the honest first goal):** the turn/Higgs
  share `|b_T|` is small — most of the mass is not Higgs-generated. The
  physical counterpart (~99% of the nucleon mass is not from the Higgs
  Yukawa) is renormalization-*scheme-independent* — it is the statement
  that the light-quark masses are small — so a finite model reproducing
  `|b_T| ≪ 1` is matching a robust fact `[import]` (Yang et al.).
- **Strong claim (scheme-dependent, demoted):** "closure (chromomagnetic)
  is the single largest share." The individual terms of the Ji
  decomposition — quark energy, gluon energy, quark mass, trace anomaly —
  are separately **renormalization-scheme and scale dependent**; their
  relative sizes shift with the scheme, and only the *total* is invariant.
  So a bare inequality `b_C > b_A` in this finite model, even if proved,
  cannot be matched to "the chromomagnetic term dominates the proton mass"
  without fixing a scheme correspondence the model does not yet have. We
  therefore demote the strong claim to a **scheme-relative** statement and
  do not present term dominance as a prediction. This is a genuine
  limitation, not a temporary gap: term-by-term matching requires a
  continuum renormalization dictionary (§9, §10) the model lacks.

### 4a. What the channel names claim, and what they do not (grade **C**)

The four channel names — *aperture*, *closure*, *turn*, *soldering*, mapped
to *kinetic/QCD/Higgs/geometric* mass — do real organizing work, and they
are also the paper's largest reservoir of unearned suggestion. State the
boundary once, plainly, so no later sentence smuggles it back:

1. **What is a theorem (M).** The operator square `4 D^#D` splits into four
   named Krein blocks `Q_A + Q_C + 4Q_T + E_#` (§4, `carrier_square_assembly`).
   That the split *exists*, that the blocks have the stated Krein
   symmetries, and that their expectations sum to one budget — these are
   kernel-checked. The *algebra* of the decomposition is not in question.

2. **What is a named analogy (C).** That block `Q_A` *is* the QCD kinetic
   term, `Q_C` *is* the chromomagnetic/gluonic term, `Q_T` *is* the Higgs
   Yukawa, and `E_#` *is* the geometric/gravitational mass — these are
   **structural analogies**, justified by shape (each block is the finite
   image of the operator that carries that physics: a covariant Laplacian,
   a curvature/commutator `σ·F`, a scalar-coupling term, a soldering
   defect), **not** by any theorem that reduces the finite block to the
   continuum object in a limit. There is **no continuum reduction** in this
   paper. The names are load-bearing *hypotheses about a correspondence*,
   pre-registered so they can be falsified, not established identifications.

3. **The kill condition for the whole naming scheme.** If the finite
   blocks' expectations, evaluated on a family of complexes approaching a
   known continuum gauge theory, do *not* converge to the corresponding Ji
   terms (up to the scheme caveat above), the correspondence is wrong and
   the channel names should be retired to "block 1..4." That test is not
   run here; it is the §9/§10 continuum program. The checkerboard continuum
   limit (§2a) is the one sub-case where a genuine reduction exists in the
   literature, which is why we flag it as the most promising bridge.

Read §§5–8 with this in force: every time the text says "the QCD channel"
or "the Higgs channel," it means "the block whose *shape* is that of the
QCD/Higgs term, conjecturally its finite image" — grade **C** — never a
proved identity.

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
dead** (pre-registered probe P1; full analysis in the program's
soldering-constant memo). What survives is the
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
(`slab_exponential_clustering`) — finite strong-coupling analogues of two
hard pillars often associated with confinement and mass-gap arguments. The one
remaining hole in the
gap chain is a finite forest-counting injection, now diagnosed (this
month, audit memo, **MEMO**) as a *malposed statement* rather than a hard
proof: the total-block
permutation count collapses under the root-pinning constraint, so the
structured-partition route is the only viable one
(`PolymerKPConclusion.lean`; strong-coupling cluster-expansion audit).

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

> **The central crux, conditionally resolved as a structured no-go
> (M engine + MEMO physical instantiation).**
> Positivity of the closure channel is not a full-space fact and never
> could be; it can hold only on the physical (Gauss-law) sector `V'/N`.
> If the MEMO physical-sector identification and descent hypotheses are
> instantiated as stated, closure is **not** positive there: it is balanced
> on the checked `6x6` witness realization of `V'/N`
> (`sig = (2,2,0)`, oracle).
> The mechanism is a grading anticonjugation: the closure bivector
> `b = sigma_z (x) 1` satisfies `b^{-1}(J Q_C) b = -(J Q_C)` and preserves
> every gauge-defined constraint sector (gauge acts on the color factor
> alone, commuting with `b`), and a Hermitian form whose characteristic
> polynomial is invariant under negation has equal positive and negative
> eigenvalue counts. The kernel engine now has both rungs: anticonjugation
> forces every odd power traceless (`anticonj_odd_pow_trace_zero`, **M**),
> while `anticonj_charpoly_eq` plus
> `hermitian_balanced_count_of_neg_charpoly` prove the finite Hermitian
> count theorem (**M**). The half-constraint rigidity that forces the
> single-covector Gauss charge is also kernel-checked
> (`half_constraint_rigidity`, **M**); and the actual nullity and
> `(2,2,0)` inertia are confirmed on the `6x6` witness by the
> pre-registered numeric probe. So `Q_C` is honestly a *signed* chromomagnetic
> channel; any surviving physical positivity would require a `J`-positive
> sector not balanced by the same grading. The finite
> count theorem is landed; what stays MEMO pending separate rungs is the
> concrete `V'` construction from the carrier Gauss covectors, the descent
> data, and the identification of the restricted representative as the
> Hermitian `B = J Q_C` to which the finite theorem applies.

**The adversarial check the resolution turns on — run, and it fails on the
witness (a pre-registered probe finding, MEMO).** The escape route —
"physical positivity comes from the `J`-definite complement" — silently
requires that the closure bivector `b = sigma_z (x) 1` anticonjugates *only*
the closure block, and does **not** also anticonjugate `J(Q_A + 4 Q_T)`.
Prompted by an external review (Fable call-04), we checked this on the `6x6`
witness and found the escape route **does not survive** there
(`probe_s1cc_aperture_grading.py`): `b` negates `J Q_A` and `J Q_T` **as well
as** `J Q_C`, so the *whole* form `J(Q_A + Q_C + 4 Q_T)` is congruent to its
negative and is balanced — inertia `(2,2,0)` — on the `6x6` witness
realization of the physical sector `V'/N` (probe finding, MEMO).
The aperture does **not** rescue positivity, because the object that must be
positive is the *Krein* form `J Q_A`, and it is balanced even though `Q_A`
itself is positive-definite as a matrix.

The reason is structural, not an artifact of the toy: to balance closure by
`b` one needs `J` to anticommute with `b` (so that `J Q_C` is `b`-odd); but
the aperture `Q_A = {gamma, gamma}(...) = g . (transports)` is Clifford-*scalar*
(the anticommutator is central by the closure relation `hcl`), hence
`b`-even, hence `J Q_A` is `b`-odd — negated by the *same* grading. The turn
`Q_T = phi^2` is `b`-even for the same reason. So **for any scalar-metric
carrier with a `b`-invariant physical sector, the grading that balances
closure balances the aperture and turn too.** What this does and does not
touch: the no-go half — "`Q_C` is a balanced Krein square" — is unaffected;
what is obstructed is the *surviving positivity* half (crux #1 below, §4 rail
3, §10 crux 0). A rescue must break one of three premises — give `Q_A`
genuine `sigma_z`-*odd* Clifford content (a **larger** Clifford algebra where
the closure bivector and the chirality are *distinct* gradings), or use a `J`
not anticommuting with `b` (reopening S1-CC), or a non-`b`-invariant sector
(likewise). The live route is the first, and it is now **kernel-checked**, not
merely numeric: `T2_positive_mass` (**M**, guard-pinned) builds an explicit
*two-edge* Cl(4) carrier whose grading `b` anticommutes the closure bivector
(balancing `Q_C`) while *commuting* with the Krein metric `J_s` (fixing `Q_A`)
— the pair the 2-dimensional single-doublet could not provide — proves its
6-dimensional `J`-positive sector form is **positive-definite** (via the exact
Gram decomposition `M6 = 1 + B^H B`), and *fires* `sector_ground_mass` to produce
a genuine positive squared mass. So the aperture-balancing obstruction was a
small-model artifact, and the positive-sector escape the whole §6 program needed
is now a theorem on a concrete multi-edge carrier — the numeric escape
(`probe_multiedge_positive_sector.py`) transcribed and closed. Full analysis:
`S1CC_APERTURE_GRADING_FINDING.md` (the obstruction) and
`T2_MULTIEDGE_ESCAPE_FINDING.md` (the escape). (Technical note preserved: the kernel rung
proves trace identities via a *similarity*; the inertia conclusion needs `b`
to act by *congruence*, which holds because `b = sigma_z (x) 1` is
Hermitian-unitary — this belongs in the mechanism's hypotheses, since a
generic invertible `b` gives symmetric traces without equal inertia.)

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
the multiplicity reading is prose, per its own docstring). The full
amplitude-independent *double* pinning (both `±1` at every hop strength) is
**not** a global winding invariant — that index was measured to vanish
here. It is an equivariant *reflection-sectored* index: `W` commutes with a
reflection `R` (leg-reversal ∘ orientation-swap), and the two `R`-sectors
carry opposite chiral indices that cancel globally but each pin one `±1`
mode. The sector index is a Lefschetz fixed-point count `±¼ Tr(ΓR)` that
does not involve `W` — hence the `|t|`-independence (grade **C** /
**M**-target, with a rational fixture and a spectral-theorem-free pinning
theorem in hand; Fable analysis this run). The resulting spectrum on the
small cycle is neutrino-shaped (one exactly massless mode; oracle, **C**) —
which is where the mass-value question, having failed for charged leptons
(§5), honestly relocates.

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

**On the level of quantization (a boundary a reviewer will ask about).**
Everything in this paper is **first-quantized**: `D` is a one-particle
operator on a finite-dimensional space, "mass" is a spectral/kinematic
invariant of *states*, and the budget decomposes an expectation in a chosen
one-particle state. There is no Fock space, no creation/annihilation
algebra, no path integral, and therefore no particle number, no vacuum
condensate as an operator statement, and no second-quantized mass gap. This
is deliberate and it is also a real limitation:

- Several physical notions the words invite — a *chiral condensate*
  `⟨ψ̄ψ⟩`, the *number* of light hadrons, spontaneous symmetry breaking as a
  vacuum property — are genuinely second-quantized and are **out of scope**
  of every theorem here. When §6/§9 speak of Banks–Casher accumulation, the
  kernel content is a statement about the *one-particle* near-zero
  eigenvalue count, which is the finite shadow of the condensate, not the
  condensate itself.
- Promoting `D` to a field operator (a fermion field on the finite complex
  with a functional integral over the closure/turn decorations) is the
  natural next layer, and it is where a genuine hadron mass — an eigenvalue
  of a *many-body* Hamiltonian — would have to live. Nothing here forbids
  that construction; it is simply not attempted, and no claim in this paper
  should be read as a many-body or field-theoretic result. Grade **C**,
  and explicitly a future program, not a gap in a proof. We note that the
  second-quantized layer we defer — creation/annihilation operators, normal
  and time ordering, Wick's theorem — is *itself* already machine-verified in
  the PhysLean library (`Physlib/QFT/PerturbationTheory`, with `wicks_theorem`
  kernel-checked) `[import]`; that is the concrete peer framework a future
  many-body extension of this carrier would build on, not reinvent.

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
  form (§6's Banks–Casher-type finite count, `banks_casher_count`, **M**).
- **"Random closure disorder increases the near-zero count `N_m`"** (the
  naive §9→§6 constituent-mass bridge, Amendment A4) — killed by a
  pre-registered probe: finite random curvature, chiral or generic,
  *decreases* `N_m` by spreading the spectrum. Condensate accumulation
  needs structured, not random, low-mode content (§9).
- **"The aperture rescues positivity on the S1-CC witness's physical
  sector"** — killed by a pre-registered probe this run
  (`probe_s1cc_aperture_grading.py`), prompted by an external review. The
  closure grading `b` that balances `Q_C` also balances `Q_A` and `Q_T` (the
  aperture is Clifford-scalar, hence `b`-even, hence its Krein form `J Q_A` is
  `b`-negated), so the *whole* operator `J(Q_A+Q_C+4Q_T)` is balanced
  `(2,2,0)` on the checked `6x6` witness realization of `V'/N`. The escape
  route of §6 has no witness; a rescuing model must give the aperture genuine
  `sigma_z`-odd Clifford content — a larger
  Clifford algebra with the closure bivector and chirality as distinct
  gradings (a multi-edge carrier). This is the sharpest open problem, not a
  refutation of the balanced-closure no-go itself (§6).

**The open cruxes, ranked** (after this run's progress). The former #1 —
physical-sector closure positivity (S1-CC) — is now *conditionally resolved at
MEMO grade with a kernel-checked engine* (§6): the finite anticonjugation and
Hermitian count algebra is kernel-checked (**M**), and the pre-registered
numeric kill probe passed, but the physical `J Q_C|V'/N` instantiation still
rests on the MEMO-grade Gauss-sector `V'` construction and descent data. So it
is a structured no-go established at the program's highest non-kernel grade,
not a fully kernel-closed theorem. What remains, ranked: **(0) The Rayleigh–Ritz
keystone `sector_ground_mass` is *proved* (M, guard-pinned; §4 rail 3), and its
positive-sector hypothesis is now *instantiated in the kernel*.** The two links
this was conditional on have both moved this run:

- **(0a) — RESOLVED.** A positive sector must *exist*; it now does, kernel
  -checked. `T2_positive_mass` (**M**, guard-pinned) builds the explicit
  two-edge Cl(4) carrier, proves its sector form `M6 = 1 + B^H B` is
  positive-definite (aperture dominance), and *fires* `sector_ground_mass` to
  produce a genuine positive squared-mass eigenvalue. What was a numeric escape
  (`probe_multiedge_positive_sector.py`, §6) is now a theorem: the aperture
  -balancing obstruction was a single-doublet artifact, and a concrete
  multi-edge model carries a real positive mass. The former #1 construction is
  done.
- **(0b) — the §3↔§4 bridge, now split, free half PROVED.** *(0b-a, free
  case, done):* `free_mass_operator_eq_plucker` (**M**) — the free carrier mass
  operator `P · adjugate P` equals `det P • 1 = (Plücker mass) • 1`, so its least
  eigenvalue *is* the §3 kinematic mass. In the free case "the operator mass is
  the kinematic mass" is now a theorem (the finite Clifford mass-shell). *(0b-b,
  interacting, the honest open link):* for nonflat carriers the bridge fails by
  the `Delta` binding-defect candidate (§4 rail 3) — the least eigenvalue is
  *below* `det P` by a closure-controlled, off-diagonal amount. This "failure"
  is the physically correct one (bound-state mass is not additive); naming
  `Delta` as a finite binding-energy invariant, and proving it is governed by
  the closure sector, is the remaining grade-**C** target. **Kill condition:** a
  carrier where `Delta` is positive or uncorrelated with closure. (1) The strong-coupling gap's forest injection (§6) — now a
well-posed combinatorics problem (demoted to a standing bounty). (2) The
color-singlet mass-budget witness (§4) — designed, `b_C ≠ 0`, awaiting
transcription. (3) The reflection-sectored double-pinning theorem and its
rational fixture (§8). (4) The S1-CC physical `J Q_C|V'/N` bridge applying
the landed finite capstone, and the equivariant-index unification of §§4/6/8
(the program's candidate organizing theorem). Each is finite, each has a kill
condition, none requires new axioms.

**Pre-registered predictions (falsifiable, dimensionless, dated).** The
program is permitted exactly one kind of numeric prediction: a
*dimensionless ratio protected by finite structure*. Two are on the table.
Both are recorded here so a later "success" cannot be back-fitted; both are
grade **C** (they rest on the channel-name correspondence of §4a, not yet a
theorem).

| # | Prediction | Model source | Comparison / kill condition |
|---|---|---|---|
| P-ν | Exactly one massless mode on the small chiral cycle; the *next* mode's ratio is a protected finite target (not an absolute mass) | §8 protection (chiral, not cyclic); oracle | Compare the finite mode-ratio pattern to a neutrino mass-squared ratio `Δm²₂₁/Δm²₃₁` (NuFIT-6.0 `[import]`). **Kill:** if the protected structure forces a ratio pattern incompatible with the measured hierarchy/ordering. Honest status: the *count* (one massless mode) is what the model owns; the *ratio value* is not yet computed, so this is a registered target, not a delivered number. |
| P-hf | Finite hyperfine (π/ρ-analog) mass-squared splitting `M²(↓) − M²(↑) = 512/125` on the 18-dim color-singlet witness | §4 S6 witness; exact-fraction oracle (`probe_s6_singlet_budget.py`) | This is a property of *one specific finite witness* with fixed 3-4-5 rational holonomies — it is a self-consistency prediction of the construction (the closure/chromomagnetic sign flips between spin states), **not** a claim about the physical π/ρ ratio. **Kill:** if the Lean 18×18 transcription does not reproduce `512/125`, or if the sign structure is an artifact of the chosen holonomies (test: vary them). |

Neither is a physical mass. P-ν is the only place the program touches a
measured number, and it does so at the one point (§8) where masslessness is
a theorem and the residual ratio is a protected finite quantity — which is
the honest home for the mass-value question after it failed for charged
leptons (§5). P-hf is a prediction *about the model's own consistency*,
valuable because it is exact and checkable, not because `512/125` is a
hadron ratio.

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
declaration's own file and is enforced when that module builds; **not pinned** = kernel-checked but without an
enforced pin (supporting identities only, never flagship claims). *(Table
anchor-swept — every one of the 38 declaration names produced a string
`grep` match in its claimed file on 2026-07-08. This is a text-match check,
not an elaboration check; existence and axiom footprints are supported
separately by the targeted Lean and guard builds.)*

| § | Declaration | File | Grade / guard | Role |
|---|---|---|---|---|
| 3 | `det_rankOneHermitian_eq_zero` | `Spinor/PluckerMass.lean` | M, trusted namespace | single edge massless |
| 3 | `two_edge_plucker_mass_identity` | `Spinor/PluckerMass.lean` | M, trusted namespace | two-edge mass = disagreement |
| 3 | `fin_bundle_plucker_mass_identity` | `Draft/NullEdgePluckerGeneralAristotle.lean` | M, Draft (kernel-checked) | mass = pairwise disagreement, general `n` |
| 3 | `fin_bundle_mass_zero_iff_common_direction` | `Draft/NullEdgePluckerGeneralAristotle.lean` | M, Draft (kernel-checked) | massless iff collinear |
| 4 | `carrier_krein_square` | `Carrier/CarrierKreinSquare.lean` | M, guard-pinned (`CarrierAxiomGuard`) | master Krein identity: starred blocks `Q_{A,C}^#` + `4 Q_T` + `4 E_#` (§4) |
| 4 | `carrier_square_assembly` | `Carrier/CarrierSquareAssembly.lean` | M, guard-pinned (`CarrierAxiomGuard`) | self-adjoint 3-slot specialization `4 D^#D = Q_A+Q_C+4Q_T` (`E_#=0`, bare blocks) |
| 4 | `signed_budget_sum_one` | `Carrier/CarrierMassBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | shares sum to one (abstract) |
| 4 | `witness_budget_sum_one` | `Carrier/CarrierMassBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | non-vacuous `(1/2,0,1/2)` witness |
| 4 | `sector_ground_mass` | `Carrier/SectorGroundMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | Rayleigh–Ritz keystone: definite-sector ground value is a positive squared mass (§4 rail 3, §10 crux 0) |
| 4 | `T2_positive_mass` | `Carrier/SectorGroundMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **the positivity linchpin**: explicit two-edge Cl(4) carrier, sector form `1+B^HB` PosDef, keystone fires ⇒ genuine positive mass (§6, §10 crux 0a) |
| 3 | `free_mass_operator_eq_plucker` | `Carrier/FreeMassBridge.lean` | M, local guard pin | **free §3↔§4 bridge**: free mass operator `P·adj P = det P • 1` = Plücker mass (§10 crux 0b-a) |
| 3 | `pairwiseMass_append` (+`_le`, `_append_eq_iff`) | `Carrier/MassMonogamy.lean` | M, guard-pinned (`CarrierAxiomGuard`) | mass monogamy: Plücker mass superadditive, excess = cross-disagreement (F3) |
| 3 | `massOn_add_massOn_compl_le` | `Carrier/MassMonogamyPartition.lean` | M, guard-pinned (`CarrierAxiomGuard`) | general-partition monogamy: internal masses ≤ whole |
| 3 | `posDef_iff_det_pos`, `det_eq_zero_iff_not_posDef` | `Carrier/RankAreaMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | massive ⇔ momentum PosDef ⇔ `det P > 0` (rank/area) |
| 7 | `weitzenbock_eq_zero_iff` (+`_re_inner_nonneg`) | `Carrier/WittenPositiveMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite Witten/Lichnerowicz: `A^#A+C` PSD, vanishes iff covariantly constant & curvature-null (F4) |
| 9 | `multiplierStationary_iff_eom` | `Carrier/FiniteCarrierAction.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite carrier action: variational stationarity ⇔ the equation of motion (dynamics D1) |
| 9 | `FiniteCanonicalEnsemble` (Z>0, probabilities) | `Carrier/FiniteCanonicalEnsemble.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite canonical ensemble over the carrier spectrum (dynamics D5) |
| 5 | `onshell_wedge_normSq_eq_coin_sq` | `GateI1/MassCoinBridge.lean` | M, kernel-checked (not pinned; supporting) | corner flip amplitude = wedge |
| 6 | `closure_defect_trace_eq` | `GateYM/PlaquetteClosureAction.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure-defect trace identity |
| 6 | `wilson_plaquette_eq_half_closure_defect` | `GateYM/PlaquetteClosureAction.lean` | M, guard-pinned (`SlabAxiomGuard`) | Wilson action = squared defect |
| 6 | `leading_closure_energy_nonneg` | `GateYM/LinearizedClosureEnergy.lean` | M, local guard pin in `LinearizedClosureEnergy.lean`; enforced transitively because `SlabAxiomGuard` imports that module | leading closure defect = nonnegative `|F|²` energy |
| 6 | `null_soldered_square` | `GateYM/S1ClosureCurrentAlgebra.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure square structure (abstract) |
| 6 | `closure_current_square` | `GateYM/S1ClosureCurrentAlgebra.lean` | M, guard-pinned (`SlabAxiomGuard`) | abstract skew-pairing square (concrete `Q_C=L^#L` is MEMO) |
| 6 | `tyAreaLaw_slab_exp` | `GateYM/TYAreaLaw.lean` | M, guard-pinned (`SlabAxiomGuard`) | strong-coupling area law |
| 6 | `wilsonSlabConnected_reflectionPositive` | `GateYM/WilsonSlabConnected.lean` | M, guard-pinned (`SlabAxiomGuard`) | slab reflection positivity |
| 6 | `OSReconstruction.osSpectralGap_pos` | `GateYM/OSReconstruction.lean` | M, guard-pinned (`SlabAxiomGuard`) | OS spectral gap |
| 6 | `slab_exponential_clustering` | `GateYM/SlabClustering.lean` | M, guard-pinned (`SlabAxiomGuard`) | exponential clustering |
| 6 | `banks_casher_count` | `GateYM/FiniteBanksCasherCount.lean` | M, guard-pinned (`SlabAxiomGuard`) | finite Banks-Casher-type eigenvalue count |
| 6 | `skew_prod` | `GateYM/FiniteBanksCasherCount.lean` | M, guard-pinned (`SlabAxiomGuard`) | count denominator `= m²+AᴴA` |
| 6 | `anticonj_odd_pow_trace_zero` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | odd-trace identity from finite anticonjugation |
| 6 | `anticonj_charpoly_eq` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | finite anticonjugation gives charpoly negation symmetry |
| 6 | `hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | Hermitian eigenvalue multiset is negation-invariant |
| 6 | `hermitian_balanced_count_of_neg_charpoly` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | equal positive/negative Hermitian eigenvalue counts; physical `J Q_C|V'/N` bridge still MEMO |
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

---

## References

External works cited (`[import]`), grouped by role. Identifiers verified against
INSPIRE-HEP / arXiv (2026-07-08): the modern arXiv ids and the load-bearing
classics (Barrett hep-th/0608221 = J. Math. Phys. 48 012303; Banks–Casher DOI
10.1016/0550-3213(80)90255-2 = Nucl. Phys. B169 103; Zwanziger DOI
10.1016/0550-3213(91)90581-H; Nielsen–Ninomiya Nucl. Phys. B185 20; Osterwalder–
Seiler Ann. Phys. 110 440) are confirmed. The full source map with keys and
status is `Sources/Null_Edge_References.md`. The project's own kernel-checked
anchors are in the §11 table, not here. A fuller prior-art map with
novelty-gap analysis is in
`Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`.

**Kinematics / spinor-helicity (§2a, §3).**

- H. Elvang, Y. Huang, *Scattering Amplitudes*, arXiv:1308.1697.
- L. Dixon, *A brief introduction to modern amplitude methods* (TASI lectures),
  arXiv:1310.5353.

**Physical pictures — zig-zag, Zitterbewegung, causal order (§2a).**

- R. Penrose, *The Road to Reality*, Jonathan Cape (2004), §25.2.
- P. A. M. Dirac (1930); D. Hestenes, *The Zitterbewegung interpretation of
  quantum mechanics*, Found. Phys. 20 (1990) 1213.
- D. Malament, *The class of continuous timelike curves determines the topology
  of spacetime*, J. Math. Phys. 18 (1977) 1399.

**Feynman checkerboard and its continuum limit (§2a, §9).**

- R. P. Feynman, A. R. Hibbs, *Quantum Mechanics and Path Integrals* (1965).
- H. A. Gersch, *Feynman's relativistic chessboard as an Ising model*, Int. J.
  Theor. Phys. 20 (1981) 491; T. Jacobson, L. S. Schulman, *Quantum stochastics:
  the passage from a relativistic to a non-relativistic path integral*, J. Phys.
  A 17 (1984) 375.
- B. Z. Foster, T. Jacobson, *Spin on a 4D Feynman Checkerboard*,
  arXiv:1610.01142.
- A. Kull, *Quantum mechanical motion of relativistic particle in
  non-continuous spacetime*, arXiv:quant-ph/0212053.

**Finite / Lorentzian / Krein spectral triples, NCG Standard Model (§2a, §6, §8).**

- N. Bizi, C. Brouder, F. Besnard, *Space and time dimensions of algebras with
  applications to Lorentzian noncommutative geometry*, arXiv:1611.07062.
- J. W. Barrett, *A Lorentzian version of the non-commutative geometry of the
  Standard Model*, J. Math. Phys. 48 (2007) 012303, arXiv:hep-th/0608221.
- A. Connes, *Noncommutative geometry and the standard model with neutrino
  mixing*, JHEP 0611 (2006) 081, arXiv:hep-th/0608226.
- F. Finster, *The Continuum Limit of Causal Fermion Systems*, Springer (2016),
  arXiv:1605.04742.

**Discrete Dirac, quantum walks/automata, fermion doubling (§2a, §8).**

- D. Bakircioglu, P. Arnault, P. Arrighi, *Fermion Doubling in Quantum Cellular
  Automata*, arXiv:2505.07900.
- H. B. Nielsen, M. Ninomiya, *Absence of neutrinos on a lattice*, Nucl. Phys.
  B185 (1981) 20.

**Confinement, positivity, constructive/lattice gauge theory (§6, §9).**

- D. Zwanziger, *Vanishing of zero-momentum lattice gluon propagator and color
  confinement*, Nucl. Phys. B364 (1991) 127.
- K. Osterwalder, E. Seiler, *Gauge field theories on a lattice*, Ann. Phys. 110
  (1978) 440.
- T. Banks, A. Casher, *Chiral symmetry breaking in confining theories*, Nucl.
  Phys. B169 (1980) 103.
- J. K. Asbóth, H. Obuse, *Bulk-boundary correspondence for chiral symmetric
  quantum walks*, Phys. Rev. B 88 (2013) 121406.

**Hadron mass, proton mass decomposition (§4, §4a, §5).**

- Y.-B. Yang et al., *Proton Mass Decomposition from the QCD Energy Momentum
  Tensor*, Phys. Rev. Lett. 121 (2018) 212001, arXiv:1808.08677.
- S. Dürr et al., *Ab initio determination of light hadron masses*, Science 322
  (2008) 1224, arXiv:0906.3599.

**Charged-lepton and neutrino masses (§5, §8, §10).**

- Y. Koide, *Charged lepton mass formula: development and prospect*,
  arXiv:0706.2534.
- Y. Sumino, *Family gauge symmetry and Koide's mass formula*, Phys. Lett. B671
  (2009) 477, arXiv:0812.2103.
- I. Esteban et al. (NuFIT-6.0), *Updated global analysis of three-flavor
  neutrino oscillations*, arXiv:2410.05380.

**Discrete geometry / gravity (§7).**

- T. Regge, *General relativity without coordinates*, Nuovo Cim. 19 (1961) 558.
- R. Aldrovandi, J. G. Pereira, *Teleparallel Gravity*, Springer (2013)
  (teleparallel / contorsion background for the E-slot trinity).

**Machine-verified physics; slogans (§2a).**

- J. Tooby-Smith, *HepLean: Digitalising high energy physics*, arXiv:2405.08863
  (now the *PhysLean* library, `Physlib`; its `Relativity/.../Weyl` metric
  `!![0,1;-1,0]` is the independent convention check for §3's spinor wedge).
- F. Wilczek, *QCD Made Simple* / "Mass Without Mass", Phys. Today 53 (2000) 22;
  L. H. Kauffman, H. P. Noyes, discrete-physics program (bit-string / iterant
  combinatorics).

---

## Appendix A. Reproducibility

Every **M** claim in this paper is machine-checked and independently
reproducible. The verification is not a claim to be trusted — it is a build to
be re-run.

**Toolchain (pinned).** `leanprover/lean4:v4.28.0` with Mathlib at the matching
`v4.28.0` (see `lakefile.toml`). Do not upgrade the pin; it is fixed for the
Aristotle and Sphere-Packing workflows.

**Rebuild everything.** From the repository root:

```bash
lake build                                  # builds the whole project (~8300 jobs)
lake env lean PhysicsSM/Path/To/File.lean   # check a single module
```

A green `lake build` is the top-level integrity check: it fails if any **M**
theorem acquires a `s o r r y`, a fake `a x i o m`, or a `n a t i v e _ d e c i d e`.

**Axiom audit (the M grade).** Each flagship carries a build-enforced axiom pin
— a `#guard_msgs (whitespace := lax) in #print axioms <name>` block — in its
module and in the lane guard file (`PhysicsSM/Draft/NullEdge/Carrier/CarrierAxiomGuard.lean`
for the Weitzenböck-carrier lane, `.../GateYM/SlabAxiomGuard.lean` for the
closure lane). The build **fails** if a theorem's transitive axiom footprint
drifts from the standard base `[propext, Classical.choice, Quot.sound]` (choice
-free results use only `[propext, Quot.sound]`). To audit any result yourself:
`#print axioms PhysicsSM.Draft.NullEdge.Carrier.SectorGroundMassWitness.T2_positive_mass`.

**The anchor table (§11)** lists every M theorem with its file and guard status;
each name is grep-checkable against the source.

**Numeric oracles (NOT M).** The pre-registered numerical probes live in
`Scripts/oracle/` and are quarantined from the verified core. Each states, in its
docstring, exactly which kernel-checked identity it mirrors or which kill it
tests; run `python Scripts/oracle/<probe>.py`. Key ones: the S1-CC balanced
-inertia probe, the aperture-grading kill, the multi-edge positive-sector escape,
the Δ binding-energy probe, the T3a free-bridge probe, and the carrier
spectrum/dynamics simulators. A probe is evidence for adding a fixture or
pre-registering a prediction — never a substitute for a kernel proof.

**Provenance.** Source keys and convention checks are in
`Sources/Null_Edge_References.md`; the PhysLean convention cross-checks and the
prior-art / novelty-gap analysis are in `docs/PHYSLEAN.md` and
`Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`.

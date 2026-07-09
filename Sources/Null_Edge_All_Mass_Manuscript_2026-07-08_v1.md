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
formalized, and (b) finite operator algebra whose central functional is now
proved a genuine *positive squared mass* on a concrete carrier
(`T2_positive_mass`, **M**; §4 rail 3), while its identification with *the*
physical mass of a Standard-Model particle remains conjectural (**C**). Per
this paper's own rule, a title graded **C** is an error; the present title is
what the grades support.
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
  discussion. **Mlodinow–Brun (2018) is the closest *mass*-side kin:** a 3D
  quantum walk whose **four-dimensional** coin space is *forced* to carry the
  Dirac gamma matrices by parity and a discrete-rotation ("noncorrelation")
  symmetry, with the **coin-flip operator as the mass term** and a *massless*
  particle recovered exactly when that operator is switched off `[import]`. That
  is an independent "mass is an internal operator you can turn off" statement,
  and it rhymes precisely with our two-null-edge `Cl(4)` carrier and its
  massless critical line `κ = λ` (§4) — but without our Krein grading, the
  four-channel budget, or the `det P` kinematic-mass tie; their single coin
  operator is our aperture/closure pair. Kauffman–Noyes combinatorial work and Wilczek's "mass without
  mass" (the QCD share) `[import]` are the nearest slogans; Zwanziger's (1991)
  lattice confinement / positivity-violation setting is a nearby comparison
  and a warning that this terrain is occupied, not source support for §6's
  finite balanced-closure theorem `[import]`.
- **What is new, stated by contrast — and narrowed after a literature
  review.** Neither the finite Krein setting (Bizi et al; Barrett) nor
  machine-verified physics (HepLean/PhysLean `2405.08863`) `[import]` is new
  *on its own*, and we do not claim either.
  The defensible novelty is the **combination**: (i) a
  finite Krein *null-edge* carrier whose square is graded into a four-channel
  budget `4 D^#D = Q_A+Q_C+4Q_T+4E_#` that **answers to the kernel-checked
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

**Where this sits, at a glance.** The table crystallizes the positioning: no
column is uniquely ours, but the *conjunction* of the last three rows is.

| Program | finite | indefinite / Krein | fermion doubling handled | mass = `det P` (null-disagreement) invariant | one four-channel budget | kernel-verified + kill-discipline |
|---|---|---|---|---|---|---|
| **This paper** | ✓ | ✓ | ✓ (Krein-null) | ✓ | ✓ | ✓ |
| Bizi–Brouder–Besnard (Krein triple) | — | ✓ | ✓ | — | — | — |
| Barrett (Lorentzian NCG-SM) | fin. internal | ✓ | ✓ (KO-6) | — | — | — |
| Connes–Chamseddine (NCG-SM) | fin. internal | Euclidean | ✓ (KO-6) | — | — | — |
| Foster–Jacobson (4D checkerboard) | ✓ | — | ✓ | — | — | — |
| QCA / quantum-walk Dirac | ✓ | — | ✓ | — | — | — |
| Finster (causal fermion systems) | ✓ | Lorentzian | — | variational | — | — |
| HepLean / PhysLean | ✓ | — | — | — | — | ✓ (formalized) |

The novelty is the bottom-right block read together — a finite *Krein* carrier
whose square is a four-channel budget *answering to the kernel-checked Plücker
mass*, under a pre-registered kill-discipline — not any single ✓.

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

The identity also runs **the other way** — the thesis is not just "a null bundle
*has* mass = disagreement" but "*every* mass *is* a null bundle's disagreement"
(`MassNullDecomposition`, **M**, guard-pinned): every future-timelike 4-momentum is
a sum of *two future-null momenta* with `m² = 2·(their Minkowski disagreement)`
(`massive_eq_two_null`, `massSq_eq_two_null_disagreement`), and every
positive-semidefinite momentum matrix decomposes into null-edge dyads `P = M Mᴴ =
Σ ψᵢ ψᵢᴴ` with `det P = |det M|²` (`posSemidef_eq_null_edge_sum`,
`det_eq_null_edge_disagreement`). So the mass ⇔ null-edge-disagreement correspondence
is **bidirectional and universal**: nothing massive fails to decompose into
massless edges, and its mass is exactly their disagreement. (The decomposition is
not unique — a given mass *admits* many null-edge presentations; which one the
carrier's dynamics selects is the C/dynamical layer.)

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

### 3a. The same invariant reads as a visible entropy (**M**)

The mass invariant has a second, equivalent reading that costs nothing extra and
is worth stating because it is *also* kernel-checked: the visible mass ratio is a
**von Neumann entropy** of the normalized momentum block. Writing the normalized
visible-momentum block of a momentum `p` as a two-level density `ρ` with
eigenvalues `(1 ± √(1 − m²/E²))/2`, one has the finite dictionary
(`MassEntropyDictionary`, **M**, guard-pinned):

- `velocityNormSq_eq_one_sub_massRatio` — `|v|² = 1 − m²/E²`, so the block spectrum
  (hence its entropy) is a function of the mass ratio alone;
- `vonNeumannEntropy_eq_zero_iff_null` — the visible von Neumann entropy is `0`
  **iff** the edge is null (`m² = 0`): *massless edges carry zero visible entropy —
  they "do not age"*;
- `vonNeumannEntropy_pos_of_timelike` — a timelike (massive) edge has strictly
  positive visible entropy; and `vonNeumannEntropy_rest_eq_log_two` pins the other
  endpoint — at rest the block is maximally mixed, `S = log 2`.

So the two endpoints of "mass = null disagreement" are also the two endpoints of
an entropy: massless/null ↔ pure (`S = 0`), fully massive/at rest ↔ maximally
mixed (`S = log 2`). Coarse-graining that discards internal null structure (the D4
Schur decimation of §9a) is then exactly the step that *produces* both effective
mass and this visible entropy — mass generation as an information-loss phenomenon.
This is a reconstruction/finite-identity (frame-conditioned: "rest" is an observer
choice), not new physics; but it is the honest, kernel-checked form of the
"mass–entropy" reading, and it sits at grade **M**.

That endpoint is also an **extremal principle** (**M**): for the `2×2` Hermitian
momentum `P = E·1 + p⃗·σ` (energy `E = tr P/2`, mass `m² = det P = E²−|p⃗|²`), one has
`det P ≤ (tr P/2)²`, i.e. **`m ≤ E`**, by one line of AM–GM on the Gram
(`det_le_half_trace_sq`, **M**, guard-pinned; the gap is `((P₀₀−P₁₁)/2)² + |P₀₁|²`).
Equality holds iff `P` is scalar — the **rest frame**, which is thus *simultaneously*
the maximum-mass and maximum-mixedness configuration at fixed energy. So the
`S = log 2` endpoint is not just a value but a variational extremum: rest maximizes
both the mass and the visible entropy of the null bundle.

And for a **two-edge** bundle the identification is now exact and kernel-checked,
not an analogy. Writing the two null 2-spinors as the columns of `M`, the momentum
matrix is `P = M Mᴴ`, the wedge is `det M = ψ₁ ∧ ψ₂`, and the **Wootters
concurrence** of the corresponding two-qubit state is `C = 2|det M|`. Then
(`TwoEdgeMassConcurrence`, **M**, guard-pinned):

- `det_gram_eq_normSq_wedge` — `det P = |det M|²` (the two-edge Plücker mass is the
  squared wedge magnitude);
- `four_mul_det_gram_eq_concurrence_sq` — **`4 · det P = C²`**, i.e.
  `det P = (C/2)²`: the two-edge mass literally *is* the Wootters concurrence²;
- `det_gram_eq_zero_iff_concurrence_eq_zero` — massless ⇔ zero concurrence ⇔ a
  collinear, unentangled product state.

So for a single edge-pair, "mass is trapped disagreeing light" and "mass is the
entanglement of the bundle with itself" are the *same* **M** statement.

And this is **not** a two-edge coincidence: it generalizes to `n` edges once the
correct multi-party measure is used (`NEdgeMassConcurrence`, `NEdgeCauchyBinet`,
**M**, guard-pinned). For `n` null spinors with amplitude matrix `M`:
`det P = |ψ₁ ∧ … ∧ ψₙ|²` (`det_gram_eq_normSq_wedge`, general `n`), and with
**Gour's G-concurrence** `G = n·(det ρ)^{1/n}` — the natural `n`-party successor of
the Wootters concurrence —

- `gConcurrence_pow_eq_det_gram` — **`det P = (G/n)ⁿ`**;
- `four_mul_det_gram_eq_gConcurrence_two_sq` — at `n = 2`, `G = C` and this collapses
  to the two-edge `4 · det P = C²`. The fixed `2`/square of the two-edge case is
  just the `n = 2` shadow of the general `n`/`n`-th-power normalization.

For a rectangular bundle (`d`-dim spinors, `n > d`) the **Cauchy–Binet** form
`det_gram_eq_sum_normSq_minors` gives `det P = Σ_S |det M_S|²` over `d`-subsets `S`
— the honest "mass = total `d`-wise disagreement," proved from scratch (not in
Mathlib). So former pre-registered target (i) is now **M**: mass *is* the (Gour)
concurrence² of the null bundle, at every `n`. And former target (ii) is now **M**
too: the binding defect **is** an entanglement deficit
(`BindingEntanglementDeficit`, guard-pinned). On the coupled `2×2` binding block
`Bc(λ,κ) = !![λ, κi; −κi, λ]` (least eigenvalue `λ−κ`, so the defect `Δ = λ−(λ−κ) =
κ`, `binding_defect_eq_coupling`), the exact identity `Δ = κ = C(ρ)·λ`
(`binding_defect_eq_concurrence`) holds, where `C(ρ) = 2‖ρ₀₁‖ = κ/λ` is the
concurrence-type off-diagonal coherence of the normalized coupled density `ρ =
Bc/tr Bc` — so **the mass lost to binding equals the coherence/entanglement the
coupling creates between the bound modes**, and the state binds below the constituent
sum *iff* it is entangled (`binding_below_threshold_iff_entangled`, `Δ ≠ 0 ⇔ κ ≠ 0`).
Both entanglement readings of mass — the bundle's own mass as concurrence², and
binding as an entanglement deficit — are now kernel-checked.

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

> **Conjecture (carrier rigidity, C) — now partly resolved (M + no-go).** The
> axioms — null soldering on a finite 2-complex, Krein structure, chiral grading,
> and covariantly constant turn field — determine the carrier operator and its
> four-block split *essentially uniquely*. **What is now kernel-checked
> (`CarrierRigidity`, M):** the *type-count* half is forced — the expansion of
> `2·(D#D)` falls into *exactly* these four grade-typed blocks
> `Q_A + Q_C + 2E_# + 2Q_T` with **no fifth block** (`square_decomposition`), and
> the four channels carry distinct even/odd Krein grades. **What is refuted (no-go):**
> full *uniqueness* is **not** forced — one can exhibit axiom-satisfying carriers
> whose split differs by more than the §6 representation gauge (two extra structures
> make it non-unique). So "unification is decomposition" splits into a **forced**
> claim (the four channel *types* are the only ones the square admits) and an
> **open** one (a further axiom is needed to pin the split uniquely). The reader
> should read §4's "unification" at the forced-type-count standard, not the
> unique-decomposition standard.

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
   of §6 — now **kernel-resolved on the explicit witness**: `b_C` is genuinely
   signed, and the `6×6` Clifford⊗color witness is *proved* to have balanced
   closure inertia `(2,2,0)` on its `V'/N` realization
   (`S1CCPhysicalSectorWitness.balanced_on_physical_sector`, **M**). So `b_C` can
   be negative on some states. This is not a defect: §8 explains why the physics
   of chiral symmetry breaking *requires* the closure channel to have negative
   directions.
2. **`b_C` is the chromomagnetic share, not "gluon energy."** The closure
   *channel* `Q_C` is linear in field strength (a `sigma·F` /
   chromomagnetic object); the `|F|^2` gluon *energy* density is a
   different object (the Wilson action, §6). Conflating them is a
   pre-registered error (§10).
3. **What the budget decomposes is a quadratic functional — and this run it
   was made a genuine mass on a concrete carrier.** This was the paper's most
   important caveat; the honest status is now much sharper (see below). In §3
   "mass" is `det P`, an invariant of a state's momentum
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
   "a quadratic functional" into "a positive squared mass." The theorem is
   **conditional**, and this run *both* of its conditions were met on a
   concrete carrier — what were the program's two deepest open links are now
   substantially closed:

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

**The mass phase diagram (aperture − closure).** The worked point `(λ,κ)=(2,1)`
is one point of a plane. Consider the `3×3` Hermitian block
`B(λ,κ) = !![λ, κi, 0; -κi, λ, 0; 0, 0, λ]` (aperture strength `λ`, closure
strength `κ`, both real), whose spectrum is `{λ − κ, λ, λ + κ}`. Its **complete
spectral theory is a kernel theorem** (grade **M**, guard-pinned;
`MassGapWitness`, `CarrierAxiomGuard`), and it organizes the whole coupling
plane: `det B = λ(λ² − κ²)` (`B_det`); the block is **positive-definite (massive)
iff `|κ| < λ`** (`B_posDef_iff`); it is **singular (massless) exactly on the
critical line `κ = ±λ`, for `λ > 0`** (`B_massless_iff_of_pos`; the `λ = 0`
edge case is handled separately — at `λ = 0` the block is singular for every `κ`);
and — the sharpest form — its **least eigenvalue is `λ − κ`**,
`IsLeast (range eigenvalues) (λ − κ)` for `0 ≤ κ ≤ λ` (`B_least_eigenvalue`). So
*the squared mass gap of `B` = aperture − closure* is a **theorem** (axiom-audited
`[propext, Classical.choice, Quot.sound]`): closure *subtracts* from mass and,
tuned to equal aperture, cancels it — a finite, exactly-solvable massless
critical line. This gives a genuine **finite three-phase diagram** in the
`(λ,κ)` plane, all three phases kernel-checked: a **massive** phase `|κ| < λ`
(positive-definite, gap `λ − κ > 0`; `B_posDef_iff`), a **massless critical
line** `|κ| = λ` (singular, gap `0`; `B_massless_iff_of_pos`), and an
**over-closure phase** `|κ| > λ` where `λ − κ` is a strictly negative eigenvalue
(it lies in the spectrum `{λ−κ, λ, λ+κ}`, `B_spectrum`) and the block is therefore
no longer positive (`¬ B_posDef` by `B_posDef_iff`) — a tachyonic/unstable mode
with no physical positive mass. So closure below aperture is mass, closure equal to aperture is the
massless line, and closure above aperture over-shoots into instability — a finite,
exactly-solvable order parameter for mass, with the critical line `|κ| = λ` a
second-order boundary (where, per §9a, the gap closes and the correlation length
would diverge — the pre-registered continuum-limit probe).

*What ties `B` to the carrier, and what does not (the honest grade split).* At
the fixed point `(2,1)` the tie is **kernel-checked**: the actual carrier
compression `M6 = PᴴHAC P` is *exactly* the block diagonal `B(2,1) ⊕ B(2,-1)`
(`M6_topBlock_eq_B`, `M6_botBlock_eq_B`, `M6_offBlock_eq_zero`, all **M**,
guard-pinned) — so the full sector form is a pair of closure-mirror blocks
`Msec(λ,κ) = B(λ,κ) ⊕ B(λ,-κ)` (isospectral, both covered by the two-sided
`B_posDef_iff`), and `T2_positive_mass` is its `(2,1)` corner *in the kernel*. The
block-diagonal `6`-dimensional form `Msec = B(λ,κ) ⊕ B(λ,-κ)` also has its gap as a
theorem: `SectorMassGap.Msec_least_eigenvalue` (**M**, guard-pinned) proves its
least eigenvalue is `λ − κ` (and `Msec_posDef_iff`: massive iff `|κ| < λ`).
*Honest scope (per the batch-3 audit):* `Msec` is a hand-defined block-diagonal
*ansatz*, and — since the two mirror blocks are isospectral — its least eigenvalue
is *definitionally* the block's `λ−κ`; the lift only doubles multiplicities, and
`Msec` is not tied to the carrier except through the `3×3` top block at `(2,1)`
(via `M6_topBlock_eq_B`). So this is not an independent "actual sector" result — it
is the honest statement that the mirror pair shares the block's gap. What is **not** a
theorem is that the carrier reduces to this shape at *general* `(λ,κ)`: that
identification is **oracle-grade** (`carrier_spectrum_sim.py`, §9a), kernel-checked
only at `(2,1)`. So the phase diagram is: *`B`'s spectral theory is M for all
`(λ,κ)`; that `B` is the carrier's sector form is M at `(2,1)` and oracle-grade
off it.*

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
   named Krein blocks `Q_A + Q_C + 4Q_T + 4E_#` (§4, `carrier_square_assembly`).
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

4. **A first RG probe of the naming scheme (M, partial).** The kill
   condition in (3) has a sharper, RG-flavoured form — *basin membership*:
   the channel names are physics iff the carrier flows to the free-Dirac
   fixed point and aperture/closure/turn are its relevant/marginal
   coordinates. On a concrete rational 3-coupling decimation model
   (aperture `λ`, closure `κ`, chiral turn `τ`), this is now
   kernel-checked: the exact flow is
   `R3(λ,κ,τ) = (λ−2(κ²+τ²)/λ, −(κ²−τ²)/λ, −2κτ/λ)` — the free-Dirac
   chiral square `z' = −z²/λ` with `z = κ+iτ` — and at criticality its
   Jacobian has characteristic polynomial `(x−2)(x+1)(x+2)`, eigenvalues
   `2` (relevant, aperture–closure), `−1` (marginal), `−2` (relevant, the
   pure **turn** axis) (`Goal3ChannelRG.kill_test`, **M**). So on this model
   the turn coupling is a *relevant* RG direction, and — being one of the
   named channel couplings — it lies **inside** the channel basis: the
   basin-membership form of the naming scheme is **not** falsified here, and
   is sharpened (turn is relevant, not marginal). This is one rational
   model, not the continuum reduction (3) still demands; it is the first
   time the channel-name question has a kernel-checked RG answer rather than
   only a shape analogy. Extending the model to the **fourth** channel —
   soldering `E` on the on-site block — closes the picture: the exact 4×4
   critical Jacobian has characteristic polynomial `(x−2)(x+1)(x+2)(x−3)`,
   so the soldering axis carries eigenvalue `3` (relevant, even more so than
   aperture's `2`) (`Goal3ChannelRG4.soldering_verdict`, **M**). On this
   model, then, **all four named channels — aperture, closure, turn,
   soldering — are genuine relevant/marginal RG coordinates**, and geometry
   does not decouple from the Dirac universality class at the fixed point.
   The basin-membership reading of the naming scheme is thus supported on a
   concrete finite model in all four channels at once — still short of the
   continuum reduction (3), but the strongest kernel-checked evidence the
   program has that the channel basis is the right coordinate system.

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

> **The central crux, resolved as a structured no-go — now fully kernel-checked
> (M engine + M witness + M general reduction + M presentation-existence); only
> the pre-registered soldered-`Q_G` escape (K-A) stays open.**
> Positivity of the closure channel is not a full-space fact and never
> could be; it can hold only on the physical (Gauss-law) sector `V'/N`.
> On the explicit `6x6` Clifford⊗color witness, closure is **not** positive
> there: the induced closure form is balanced,
> `sig = (2,2,0)` — now **kernel-checked**
> (`S1CCPhysicalSectorWitness.balanced_on_physical_sector`, **M**), not an
> oracle probe. And the witness → general upgrade is now itself a **theorem**:
> `S1CCGeneralReduction.compression_balanced` (**M**, guard-pinned) proves that
> for *any* `±1` closure grading `d` anticonjugating the closure form and *any*
> choice of coset representatives `r`, the compressed form `J.submatrix r r` is
> balanced — **with no hypothesis whatsoever on the Gauss charge `Q_G`** (`Q_G`
> only selects *which* representatives `r`; balance holds for every `r`). The
> `6x6` witness is re-derived as a literal instance of this general theorem
> (`S1CCWitnessAsInstance.witness_balanced_via_general`, **M**), confirming it is
> not special to its coordinate alignment. And the balance *mechanism* is now
> **presentation-independent**: `compression_balanced_eigbasis` (**M**,
> guard-pinned) drops the coordinate-`submatrix` assumption and proves the same
> balance for compression by *any* `b`-eigenvector family `P` (`b P = P e`, `e` a
> `±1` grading) — the reps of `V'/N` need not be coordinate axes. And the balance
> **mechanism** is `Q_G`-blind by construction (the theorems never mention `Q_G`).
> **The presentation-existence — the last MEMO piece — is now also kernel-checked
> (M).** `S1CCPresentationExistence.physical_sector_b_eigenbasis_exists` (**M**,
> guard-pinned) proves that for *any* `±1` grading `b` and *any* **nilpotent**
> `Q_G` (`Q_G²=0`) commuting with `b` — **no Hermiticity assumed** — there exists a
> `b`-eigenvector family `P` that genuinely presents `V'/N`: its columns lie in
> `ker Q_G` (`Q_G P = 0`), are linearly independent (a left inverse `L` with
> `L P = 1`), have the **full physical dimension** `card κ = card ι − 2·rank Q_G`,
> and **span a complement of `range Q_G` inside `ker Q_G`**. Feeding that `P` into
> `compression_balanced_eigbasis` gives the physical-sector balance for the whole
> scalar-metric class (`physical_sector_balanced`, **M**). The genuine argument
> (`S1CCEigenbasis`) is coordinate-free: a nilpotent `φ` commuting with a `±1`
> involution `β` has `range φ ⊆ ker φ` both `β`-invariant, `β` splits the complement
> along its `±1` eigenspaces, and rank–nullity fixes the dimension.
>
> *Honest scope / history (this is the third iteration; the first two were caught by
> review).* The **non-Hermiticity is load-bearing**: a first attempt stated `Q_G`
> Hermitian *and* nilpotent, which over `ℂ` forces `Q_G = 0`
> (`Aᴴ=A, A²=0 ⇒ A=0`), degenerating the sector to the whole carrier — an Aristotle
> pass proved that degenerate version, and it was **rejected**, not integrated.
> The physical Gauss/BRST charge is nilpotent and *non*-Hermitian (Krein-self-adjoint;
> the witness `Q_G = c₁ ⊗ G`, `c₁ = E₀₁`), which is exactly why `V'/N` is nontrivial;
> the corrected statement above drops Hermiticity and is non-degenerate. (Three
> adversarial reviews bear on this: Fable call-09 and the batch-5 audit flagged the
> empty-`κ` vacuity and the definite-vs-Krein adjoint issue on earlier iterations,
> and the batch-7 audit **ruled the corrected version CLEAN** — confirming the
> hypotheses admit a nonzero nilpotent `Q_G`, the dimension count
> `card ι − 2·rank Q_G` is exact, and the abstract `eigenbasis_core` argument is
> sound. That audit also folded the dimension clause into `physical_sector_balanced`
> itself, so a *single* theorem now certifies a full-dimensional `b`-adapted `P` in
> `ker Q_G` whose compression `PᴴMP` is balanced — no split citation.) What
> survives as the pre-registered kill is only the genuinely-soldered non-scalar
> `Q_G` escape (**K-A**).
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
> (`half_constraint_rigidity`, **M**); and the actual `(2,2,0)` inertia is now
> **kernel-checked** on the explicit `6x6` Clifford⊗color witness
> (`S1CCPhysicalSectorWitness.balanced_on_physical_sector`, **M**, self-guarded) —
> no longer only a numeric probe. So `Q_C` is honestly a *signed* chromomagnetic
> channel; any surviving physical positivity would require a `J`-positive
> sector not balanced by the same grading. What used to stay MEMO is now
> **kernel-checked** on that witness — including the Gauss-sector construction
> itself: the descent data (`[G,K]=0`, `Q_G²=0`, `N ⊆ radical`,
> `b(J Q_C)b = −J Q_C`), the restricted form `B = (J Q_C).submatrix`, its balanced
> inertia `(2,2,0)`, **and** the identification `V' = ker Q_G` / `N = range Q_G`
> with `r` enumerating the coset representatives — the latter now a named,
> guard-pinned theorem set (`QG_range_eq`, `QG_ker_eq`, `QG_ker_reps_basis`, **M**),
> not a by-inspection step. And the general-representative reduction — that the
> balance holds for *every* representative, not just the coordinate-aligned
> witness — is now the kernel theorem `compression_balanced` (**M**), with the
> witness as an instance (`witness_balanced_via_general`, **M**). And the
> *presentation* step is now **M** as well (`physical_sector_b_eigenbasis_exists`):
> for any `±1` grading and any nilpotent `Q_G` commuting with it, a full-dimension
> `b`-eigenbasis presenting `V'/N` (complementary to `range Q_G`) exists — so
> nothing in the reduction, the witness, or the presentation stays MEMO; only the
> soldered-`Q_G` kill (K-A) is open.

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
symmetric-teleparallel literature `[import]` (Aldrovandi–Pereira,
*Teleparallel Gravity*, and Regge-adjacent work) as the anchor. This is still the least-developed
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

**Masslessness is not one thing — a taxonomy (all four kinds kernel-checked).**
The framework separates *four distinct mechanisms* by which a mode is massless, and
each is a theorem in a different section — so "massless" is a structural verdict, not
a single parameter set to zero:

1. **Collinear (kinematic).** All null directions are projectively collinear, so the
   Plücker mass vanishes: `det P = 0 ⇔ common direction`
   (`fin_bundle_mass_zero_iff_common_direction`, **M**; §3). A single coherent beam.
2. **Critical (aperture–closure cancellation).** Signed closure exactly cancels
   aperture, `|κ| = λ`, closing the gap `λ − κ = 0` on the massless critical line
   (`B_massless_iff_of_pos`, **M**; §4 phase diagram). A tuned cancellation, not a
   collapse.
3. **Index-protected (topological).** A chiral surplus forces a zero mode immune to
   every potential and transport (`exists_protected_massless_mode`, **M**; this
   section). No tuning — an index forbids the partner.
4. **Gauge-quotient (Krein/BRST).** Masslessness/positivity is decided only *after*
   passing to the physical Gauss sector `V'/N`; the closure form is balanced there
   (`physical_sector_balanced` / `balanced_on_physical_sector`, **M**; §6) — the
   finite analogue of a mode being *unphysical* (a gauge/quotient artifact) rather
   than genuinely massive.

So a photon-, gluon-, neutrino-, or critical-mode-like masslessness need not share a
mechanism: the framework asks, for each light state, *which* of collinear, cancelled,
protected, or quotient-null it is (or which mixture). That the four are separate
kernel-checked theorems — not one — is itself a result.

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

**Two inputs converted to outputs, on toys (M, 2026-07-09).** The
indefinite metric this section leans on is not a free choice: a nonzero
null edge `c(alpha)` satisfies `c(alpha)^2 = 0` with `c(alpha) != 0`, and in
a real Clifford algebra `c(v)^2 = Q(v)`, so a definite form has no nonzero
isotropic vectors — the mere existence of a null edge *forces* the soldering
Gram to be indefinite (`clifford_null_forces_indefinite`, with `Q13_indefinite`
and `Q22_indefinite` the concrete `(1,3)`/`(2,2)` witnesses, M). A finite
Osterwalder–Schrader toy then sharpens indefinite to Lorentzian: on the minimal
single-mode two-site lattice the `(1,3)` signature is reflection-positive with a
nondegenerate physical sector, while **any** second time direction (in
particular `(2,2)`) fails reflection positivity (`oneTime_reflectionPositive`,
`twoTime_reflectionPositive_fails`, M). So "indefinite, with exactly one time" is
a two-step consequence rather than an assumption — with the honest scope that the
second step is a minimal toy, not a full lattice OS reconstruction. Separately,
the conjugate-pairing invoked above has a finite kernel-checked instance: an
antiunitary CPT operator `Theta = C . Gamma_rev . #` on an explicit
non-degenerate `C^4` Clifford ⊗ color witness satisfies `Theta D Theta^{-1} =
D^#` and forces the Dirac spectrum to be conjugate-paired
(`Theta_conjugates_D_to_sharp`, `spectrum_conjugate_paired`, M) — for that
carrier's `D`, not the §8 unitary `W`, so it corroborates rather than discharges
the transcription note above.

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

**The full rational RG flow (M, 2026-07-09).** The single decimation step
above has since been iterated into an *exact rational* renormalization map.
Integrating out every second site of the tridiagonal chain carrier (on-site
aperture `lam`, closure edge `kap`) gives the closed form
`R(lam,kap) = (lam − 2κ²/λ, −κ²/λ)` (`Rlam`, `Rkap`, `R_schur_derivation`,
**M**, off the codimension-1 locus `lam=0`). Three consequences are now
kernel-checked: the massless/critical line `|κ|=|λ|` is **R-invariant**
(`massless_line_invariant_and_nondegenerate`, with the explicit non-degeneracy
witness `R(1,1/2)=(1/2,−1/4)≠(1,1/2)` proving `R` is a genuine nontrivial flow);
the linearization at the critical point has relevant eigenvalue **exactly 2**
(`linearized_mass_eigenvalue_eq_two`, which also kernel-checks `log₂2 = 1`); with
the standard RG rescale `b=2` this reads as the correlation exponent `ν = 1/y_t =
1` — an *interpretive* step, since the Lean proves the eigenvalue and the
`logb 2 2 = 1` arithmetic, not a `ν` object set equal to 1. On the critical line
the mass shell is conical `(k·σz)² = k²·1` (`conical_dispersion_z_eq_one`), i.e.
`ω = ±k`, the `z = 1` reading (the theorem's second conjunct is the Pythagorean
`cos 0` identity, carrying no extra model-specific content, so "z=1" is the
standard RG reading of the conical first conjunct, not a separately proved
dynamical-exponent object). Honest scope: `R` maps the critical *line* to itself
as a set (a period-2 sign flip `(λ,λ)↦(−λ,−λ)`, so it is line-invariance, not a
strict fixed point — the genuine fixed line of `R` is the decoupled `κ=0` line);
the `ν=1`/`z=1` exponents are the standard RG *reading* of the kernel-checked
linearization/dispersion data at criticality; and this is still finite rational
algebra, not a continuum limit. This is the honest "basin-membership" form of the §4a channel-
name question: the carrier flows to a `z=1`, `ν=1` critical point — the Dirac
universality class's exponents — by exact decimation.

Claim boundary: the decimation is now an exact rational RG *flow* with an
invariant critical line and its `ν`/`z` exponents (above) — but still no
continuum, and the critical set is a period-2 line rather than a strict fixed
point. The bridge from this step to
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
condensate as an operator statement, and no second-quantized mass gap *of the
interacting many-body system*. (This run did land the finite **free**
second-quantized gap — `FockMassGap.secondQuantized_massGap` (**M**,
self-guarded): on the fermionic occupation Fock space, the free many-body
Hamiltonian `dΓ(B)` has ground energy `0` and first excited energy exactly the
one-particle gap `λ − κ`, with the free two-body energy exactly the *sum of
constituents* (`fockEnergy_twoParticle`) and the binding defect `Δ = −κ` as the
seed (`twoBody_bound_below_threshold`). The *interacting* two-body bound state is
now itself a **theorem**: `InteractingTwoBody.interacting_boundState_below_threshold`
(**M**, self-guarded) exhibits, for an attractive interaction `V` of strength `κ`
on the two lowest pairs, a genuine `IsLeast` eigenvalue `boundEnergy < ` the free
constituent threshold `min_{i≠j}(d_i+d_j)` whenever `κ > 0` — via an explicit
`2×2`-block eigenvalue computation, with **no hand-inserted defect**. Moreover the
interaction is not an arbitrary rank-one form: `Vderived = dΓ(i·κ·K)` is the
*second-quantized closure operator* — the `dΓ` of a closure curvature `i·κ·K`
projected to the two-particle sector — and it equals the modelled `V` up to a
diagonal phase gauge (`DerivedInteraction.Vderived_conj`), so it produces the same
below-threshold bound state (`derived_boundState_below_threshold`, **M**,
guard-pinned). *Honest scope (per the batch-4 audit — this is a conditional, not an
unconditional first-principles derivation):* the kernel does **not** tie the chosen
curvature to the carrier's *actual* closure `K` (the carrier module is not imported
into this finite computation), and — crucially — `derived_wrongPlane_no_binding`
(**M**) proves the *choice of plane is exactly what decides binding*: a closure
curvature acting in a plane containing the ground mode leaves the ground pair
decoupled and gives **no** binding (least eigenvalue = the free threshold), with the
exact boundary `κ² = (d₂−d₀)(d₂−d₁)`. So the honest content is the **conditional**
theorem: *if* the closure acts among the excited modes (not the ground plane), *then*
a second-quantized closure interaction binds a state below the constituent sum. **And
that condition is now itself kernel-checked for the carrier** (`CarrierClosurePlane`,
**M**, guard-pinned): reading the closure generator off the mass block `B(λ,κ) =
λ·I + i·κ·K` gives the explicit `carrierK = !![0,0,0; 0,0,−1; 0,1,0]`
(`massBlock_eq_carrierK`), and `carrierK_eq_closureCurvature` proves it **equals** the
excited-mode/binding-plane curvature — the ground mode 0 is a spectator
(`carrierK_ground_spectator`) and it is provably **not** the ground-plane curvature
(`carrierK_ne_closureCurvature2`). So the carrier's *own* `K` occupies the binding
plane, and the binding is **unconditional for the carrier** (`carrier_closure_binds`,
**M**): the "closure *can* bind" conditional is upgraded to "*this* carrier's closure
*does* bind" — **C → M**. The one step that stays **C** is only the mass-value
identification (a *specific* hadron mass), which the program lacks (§10).) This is a
real limitation only at the last step:

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

### 9a. A finite dynamics layer: action, evolution, RG, ensemble (**M** scaffolds)

The §3 identity and the §4 budget are *static*. This run added a finite
**dynamics** layer — kernel-checked as abstract scaffolds, plus validated
numerical simulations built on them. The honest reading is uniform: **each
theorem is a general finite fact (M); the physics is its instantiation on the
carrier, which is the pending link** — the same "the machine is built, the model
that satisfies its hypothesis is next" pattern as the keystone (§4 rail 3).

- **D1 — action and equation of motion.** `multiplierStationary_iff_eom`
  (`FiniteCarrierAction`, **M**): a finite action's variational stationarity is
  equivalent to the equation of motion `D psi = 0`. The carrier's dynamics is
  *derived* from an action, not posited. (Scaffold: the abstract Dirichlet /
  multiplier variation; a specific carrier Lagrangian is the physics.) A finite
  Noether-flavored companion is also kernel-checked (`FiniteQuadraticAction`,
  **M**, self-guarded): a unitary symmetry that commutes with the carrier operator
  `A` preserves both the quadratic and the constrained mass-shell action
  (`quadraticAction_invariant_of_commutes`, `massShellAction_invariant_of_commutes`)
  and transports mass-shell solutions to mass-shell solutions of the *same* mass
  (`massShell_equation_symmetry`) — the finite statement that a symmetry of the
  dynamics is a symmetry of the mass spectrum.
- **D2/D3 — evolution and conservation.** `norm_conserved_orbit`,
  `energy_conserved_orbit` (`FiniteUnitaryEvolution`, **M**) prove that *any
  sector isometry* conserves norm and energy along its orbit — generic finite
  functional analysis (`LinearIsometryEquiv`). This was previously flagged with
  the honest caveat that the *instantiation* (the T2 carrier's step actually
  being such an isometry) was open. **That instantiation is now closed** and
  kernel-checked (`CarrierUnitaryFlow`, **M**, guard-pinned): the sector form is
  Hermitian (the mass-gap block `B`), so the flow it generates `exp(−i t H)` is
  **unitary** (`hermitian_flow_mem_unitaryGroup` / `B_flow_unitary`) and induces a
  genuine `LinearIsometryEquiv` on the sector (`hermitian_flow_isometry`). Wired
  through the generic scaffold, this gives single concrete theorems —
  `carrier_orbit_norm_conserved` and `carrier_orbit_energy_conserved` (both **M**,
  guard-pinned): the discrete time-evolution *orbit* of the carrier block flow
  conserves the sector norm and (for commuting observables) energy. So
  `FiniteUnitaryEvolution` fires on the block flow. Stated exactly (per the
  flagship audit): this is Euclidean-unitarity of `exp(−i t H)` for Hermitian `H`,
  instantiated at the mass block — a generic fact with `H := B`, *not* yet the
  carrier's Krein evolution.
  **Two grade caveats, stated plainly.** *(i) The generator is a posit (**C**).*
  `B = Q_A + Q_C` is the compressed squared-mass / energy *form*, not a Hamiltonian
  *derived* from the D1 action (D1 gives the constraint `Dψ = 0`, not a Schrödinger
  equation). Taking the sector mass form as the generator of a one-parameter flow
  is a canonical modeling choice (Stueckelberg-style proper-time evolution),
  defensible but chosen; what is **M** is the unitarity/isometry and orbit
  conservation of `exp(−i t H)` for Hermitian `H`; that this flow *is* the
  carrier's physical time evolution is grade **C**. *(ii) Carrier tie at `(2,1)`.*
  the flow is of the *block* `B(λ,κ)` for all `(λ,κ)`, but `B` is the carrier's
  sector form kernel-checked only at `(2,1)` (§4), oracle-grade off it. (First
  -quantized throughout; Krein-unitary ≠ norm-unitary was the earlier worry. Its
  *static* half is now **kernel-certified**: `sector_krein_form_eq_one` (**M**,
  guard-pinned) proves `Pisoᴴ J Piso = 1`, i.e. the indefinite Krein metric `J`
  compressed to the physical sector *is* the identity — the sector carries the
  ordinary positive inner product, so the two metrics *agree* on the sector. The
  *dynamical* half — flagged open by the batch-6 audit — is now also
  **kernel-certified on the witness** (`CarrierKreinFlow`, **M**): `HAC` is
  Krein-(`Jmet`-)self-adjoint (`HAC_Jmet_selfAdjoint`) and the `J`-positive sector
  `range Piso` is `HAC`-invariant (`HAC_sector_invariant`), so by a general
  reusable lemma (`J_selfAdjoint_flow_J_unitary`: `J²=1 ∧ JH=HᴴJ ⇒ exp(−itH)` is
  `J`-unitary) the flow is `Jmet`-unitary (`HAC_flow_Jmet_unitary`,
  `Uᴴ Jmet U = Jmet`) **and** keeps you on the sector
  (`HAC_flow_sector_invariant`, `exp(−itHAC)·Piso = Piso·exp(−itM6)`). So the
  sector orbit is upgraded from Euclidean-norm-conserving to **Krein-form-conserving
  and sector-preserving** — the static+dynamical equivalence of Euclidean and
  Krein evolution *on this witness* is closed. What remains **C** is only the
  identification of this `HAC`-generated flow with the *physical* time evolution
  (the generator-as-Hamiltonian posit), and the `(2,1)` carrier tie above.)
- **D4 — renormalization flow.** `invariant_orbit`,
  `observable_antitone_orbit` (`FiniteRGFlow`, **M**, axiom-free): orbit
  invariants and monotones under an iterated step. The intended step is the §9
  Schur decimation (`RGSchurMassWitness`); its instantiation is the physics.
- **D5 — canonical ensemble.** `partitionFunction_pos`,
  `sum_probability_eq_one`, `probability_pos` (`FiniteCanonicalEnsemble`, **M**):
  a finite canonical ensemble over any spectrum; applied to the carrier sector
  spectrum it gives the thermodynamics (and the §9 condensate's finite handle).

**Lean-informed simulations (oracle grade, quarantined from the M core).** Five
Python simulators, each output *validated against a landed M-identity* (the Lean
is the simulation's spec and validation oracle):

- `carrier_spectrum_sim.py` — the physical-sector **mass phase diagram**: the
  squared mass gap is **aperture − closure**, with a **massless critical line at
  closure = aperture**. The *block* spectral theory the diagram rests on is now a
  kernel theorem (`MassGapWitness`, §4, `B_least_eigenvalue` / `B_posDef_iff`,
  **M**, guard-pinned), and the tie to the carrier is kernel-checked at `(2,1)`
  (`M6_topBlock_eq_B`); so at that point the simulator *cross-checks a proved
  result*. The general-coupling reduction the diagram sweeps is oracle-grade
  (also validated against `T2_positive_mass`, `signed_budget_sum_one`,
  `posDef_iff_det_pos`).
- `carrier_evolution_sim.py` — unitary Hamiltonian flow with a positive mass
  gap, survival-amplitude **mass-spectrum resolution**, a unitary
  **quantum-walk transfer operator** (whose continuum limit yields a Dirac-type
  flow under the standard QW→Dirac conditions — a 4-dimensional coin carrying
  the gamma matrices, with parity and discrete-rotation symmetry; Mlodinow–Brun,
  §2a; the *finite symbol facts* underlying that limit are now kernel-checked in
  `ContinuumLimit` — the exact lattice dispersion `cos ω = cos k cos θ`, the mass
  shell `(kσ_z+mσ_x)² = (k²+m²)·1` (`dirac_mass_shell`, **M**), and the
  leading-order match of the discrete transfer generator to the Dirac Hamiltonian
  symbol `-i(kσ_z+mσ_x)` (`Ustep_hasDerivAt_generator`, **M**); the continuum
  *theorem* itself is `[import]` for 1+1D (Gersch; Jacobson–Schulman) and open for
  the Cl(4) carrier). That same dispersion **derives the relativistic speed limit**
  (`SubluminalBound`, **M**, guard-pinned): the group velocity `v_g = sin k cos θ /
  sin ω` has `v_g² ≤ 1` with luminal deficit `sin²ω − (v_g sin ω)² = 1 − cos²θ =
  sin²θ ≥ 0`, so **every massive mode is *strictly* subluminal and only the massless
  walk (`θ = 0`) saturates the light cone** (`massive_implies_subluminal`,
  `luminal_iff_massless`). "Nothing outruns light, and only the massless reach it"
  is thus a theorem on the pinned dispersion, not an assumption. (What is *not*
  derived is boost symmetry — expected only at the critical point.) Also,
  antisymmetrized **2-fermion Slater scattering
  amplitudes** (validated against `FiniteUnitaryEvolution`, `T2`).
- `carrier_rgflow_sim.py` — Schur **RG flow** (`k_eff = t^2/mu`, invariant
  `mu·k_eff`), the **canonical ensemble** (`Z`, `F = <E> − T S`, ground
  dominance), and a **condensate** near-zero-mode fraction rising to the
  critical line — the finite Banks–Casher shadow (validated against
  `FiniteRGFlow`, `FiniteCanonicalEnsemble`, `RGSchurMassWitness`).
- `carrier_scattering_sim.py` — a finite **S-matrix**: a 1+1D Dirac quantum walk
  (the checkerboard asset) with a localized **mass barrier**, giving transmission
  and reflection `T(m₀), R(m₀)`. Outputs: the S-matrix is **unitary**
  (`|T| + |R| = 1` after the packet clears, from the exact norm conservation),
  transmission **falls monotonically with the barrier mass** and `→ 1` as
  `m₀ → 0` (a *massless* region is transparent — the critical line κ=λ as a
  scattering statement), and it is **reciprocal** (`T_left = T_right` to `<10⁻³`).
  The faithful regime is small coin angle `θ = m₀·dt < π/2` (the Mlodinow–Brun
  continuum conditions, §2a); the mass a packet scatters off *is* the
  aperture−closure gap. Validated against `FiniteUnitaryEvolution` and the T2
  spectrum.
- `carrier_fock_sim.py` — a finite **second-quantized (Fock)** simulator: the free
  many-body spectrum of `dΓ(B)` on the fermionic occupation Fock space (ground
  `= 0`, gap `= λ−κ`, two-body `=` sum of constituents), the binding seed
  `Δ = −κ`, and an **interacting two-body probe** — with an attractive closure
  interaction `V` of strength `κ` on the ground pair, the least eigenvalue drops
  strictly *below* the free constituent threshold (a finite below-threshold bound
  state, binding energy `< 0` iff `κ > 0`). Validated against
  `FockMassGap.secondQuantized_massGap` / `fockEnergy_twoParticle`,
  `BindingDefect` (`Δ = −κ`), and `B_spectrum`. The interacting probe is the
  numeric shadow of the now-landed interacting bound-state theorem
  (`InteractingTwoBody.interacting_boundState_below_threshold`, **M**; the physical
  hadron identification stays **C** — `V`'s form is modelled, not derived).

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
physical-sector closure positivity (S1-CC) — is now **kernel-resolved on the
explicit witness** (§6). Not only is the finite anticonjugation + Hermitian-count
*engine* kernel-checked (**M**); the physical `J Q_C|V'/N` **instantiation is now
also kernel-checked** on the explicit `6×6` Clifford⊗color carrier
(`S1CCPhysicalSectorWitness`, **M**, self-guarded): with the Gauss projector
`Q_G = c₁⊗G`, the coset representatives of `V'/N` are coordinate axes (so the
compression is a literal `submatrix`), and the induced closure form `B = J Q_C|V'/N`
is proved to have inertia exactly **`(2,2,0)`** (`balanced_on_physical_sector`) and
to be genuinely indefinite (`JQc_not_positive_on_sector`) — the balanced closure
no-go, with the descent data (`[G,K]=0`, `Q_G²=0`, `N ⊆ radical`,
`b(JQc)b = −JQc`) all kernel-checked. So on the explicit witness the no-go is a
**theorem**, not MEMO. And the general-representative reduction has now moved to
the kernel too: `S1CCGeneralReduction.compression_balanced` (**M**, guard-pinned)
proves the balance for *any* coset-representative selection and *any* `±1` closure
grading with **no** hypothesis on `Q_G`, its presentation-independent strengthening
`compression_balanced_eigbasis` (**M**) drops coordinate alignment (compression by
*any* `b`-eigenvector family), and the `6×6` witness is re-derived as a literal
instance (`witness_balanced_via_general`, **M**). So the balance *mechanism* is
general **M** (`Q_G`-blind). And the last piece — existence of a `b`-adapted
presentation of the *actual* sector `V'/N` — is now **M** too:
`S1CCPresentationExistence.physical_sector_b_eigenbasis_exists` (guard-pinned)
produces, for any `±1` grading and any **nilpotent** `Q_G` (no Hermiticity)
commuting with it, a `b`-eigenbasis in `ker Q_G` that is linearly independent,
full-dimension (`card ι − 2·rank Q_G`), and complementary to `range Q_G` — the
genuine `V'/N` presentation (`S1CCEigenbasis`). Non-Hermiticity is load-bearing (a
Hermitian nilpotent would collapse `Q_G=0`; a first Aristotle pass proved that
degenerate version and it was rejected — this is the corrected third iteration, and
the dimension/complementarity answer the Fable call-09 + batch-5 findings). So the
S1-CC no-go is now fully kernel-checked; the only pre-registered escape left is the
genuinely-soldered non-scalar `Q_G` (kill K-A).
What remains, ranked: **(0) The Rayleigh–Ritz
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
  interacting, now a block-level theorem):* for interacting carriers the bridge
  fails by a `Delta` binding defect — the least eigenvalue is *below* `det P` by a
  closure-controlled, off-diagonal amount. This is no longer only a candidate: on
  the sector mass block `B(λ,κ)` it is **kernel-proved** that
  `Δ_block(λ,κ) = −κ` (`BindingDefect.blockBindingDefect_eq_neg_kappa`, **M**,
  guard-pinned) — closure lowers the ground mass by *exactly its strength*. It is
  **negative** (binding sign, not additive constituent mass;
  `blockBindingDefect_nonpos`), **closure-controlled** with unit slope
  (`blockBindingDefect_closure_controlled`), and **off-diagonal**: the closure
  perturbation `B(λ,κ) − B(λ,0)` has zero diagonal
  (`closurePerturbation_offDiagonal`), so the naive additive estimate is `0` while
  the true `Δ = −κ` — the finite shadow of "bound-state mass is not assembled from
  constituents", and exactly why the naive bridge `0b` fails. **Kill condition**
  (`Δ > 0` or uncorrelated with closure) is now provably *unreachable* on the
  physical branch: `Δ > 0` forces `κ < 0` (`blockBindingDefect_pos_imp_neg_kappa`).
  What stays grade **C** is only the *physical identification* — that this block
  `Δ` is *the* carrier binding energy — which inherits the `(λ,κ)` carrier
  reduction (kernel at `(2,1)`, oracle-grade off it). (1) The strong-coupling gap's forest injection (§6) — now a
well-posed combinatorics problem (demoted to a standing bounty). (2) The
color-singlet mass-budget witness (§4) — designed, `b_C ≠ 0`, awaiting
transcription. (3) The reflection-sectored double-pinning theorem and its
rational fixture (§8). (4) The equivariant-index unification of §§4/6/8 (the
program's candidate organizing theorem) — whose **provable half is now landed**:
`EquivariantGradedIndex.graded_budget_decomposition` (**M**, self-guarded) shows
that *any* four-channel budget identity — including the kernel-checked
`carrier_krein_square` `4 D^#D = Q_A+Q_C+4Q_T+4E_#` — pushes through the graded
supertrace by linearity, giving *one equivariant graded-supertrace identity* on
the four channels (McKean–Singer odd-power cancellation `graded_trace_odd_vanishes`;
"unification is decomposition" `graded_trace_sum`; the C4 isotypic split
`graded_trace_sector_split`). The budget hypothesis is **now discharged on the
real carrier**: `CarrierGradedBudget.carrier_graded_budget` (**M**, guard-pinned)
supplies it from the kernel-checked `carrier_krein_square` (specialized to the
matrix algebra), so the graded supertrace of the carrier's *own* `4 D^#D`
decomposes over the four channels with *no assumed hypothesis* — "the channels ARE
the graded pieces of the carrier's Dirac square" is a theorem about the carrier.
(This still is finite graded linear algebra — McKean–Singer + supertrace linearity
— **not** a topological index theorem
à la Atiyah–Singer — that is a category error at this generality (no base space, no
K-theory receptacle, no family of operators; the count is direct), not a research
gap.) What stays open is the `finrank`/projection-trace dimension-counting layer
that would turn the algebraic supertrace facts into inertia/dimension theorems.
Each of (1)–(4) is finite, each has a kill condition, none requires new axioms.

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
| P-spacing | The three squared-mass levels of one carrier are **equally spaced**: `(m²_mid − m²_lo)/(m²_hi − m²_mid) = 1`, scale-invariant | §4 `MassSpacingPrediction.spec_spacing_ratio` (**M**, guard-pinned; the levels `{λ-κ,λ,λ+κ}` = `B_spectrum`) | A kernel-checked *within-carrier* structural constraint: closure/mean/aperture form an arithmetic progression, dimensionless and scale-free. **Kill:** a single carrier whose two adjacent squared-mass gaps measure to a ratio `≠ 1`. Honest scope: within-carrier only — it is **not** the cross-generation neutrino ratio. |

None is a physical mass. P-ν is the only place the program touches a
measured number, and it does so at the one point (§8) where masslessness is
a theorem and the residual ratio is a protected finite quantity — which is
the honest home for the mass-value question after it failed for charged
leptons (§5). **The neutrino mass ratio itself is an honest boundary, not a
pending calculation** (Aristotle no-go, 2026-07-08): predicting `m₂/m₃` is a
*category error* at this generality — the finite structural data of one carrier
fixes only the within-carrier ratio pattern `(λ-κ):λ:(λ+κ)` up to scale
(`P-spacing`), and a cross-generation ratio needs two ingredients the theory
does *not* derive — a **generation/family-replication index** selecting three
distinct carriers as the mass eigenstates, and a **cross-carrier scale map**
(a Yukawa-like texture) relating their normalizations. Both are external inputs;
until they are supplied *and* derived, the neutrino ratio is outside what the
program predicts. (Naively identifying one block's three levels with three
generations fails twice: they are one sector's closure/mean/aperture, not a
replication, and they would force an *arithmetic* `Δm²` ratio of `1`,
contradicting the observed hierarchical splittings.) P-hf is a prediction
*about the model's own consistency*, valuable because it is exact and
checkable, not because `512/125` is a hadron ratio.

**What the theory *does* now own about small masses (M).** While an absolute
neutrino mass stays outside the program, the *mechanism* for a small mass is
kernel-checked. There are three, and only three, structural ways to be light, each
now a theorem: (a) **index-protected zero** — a chiral surplus forces an exact
massless mode no potential can lift (`ChiralIndexProtection.corner_ker_ge_index`,
**M**; §8); (b) **critical cancellation** — closure exactly offsets aperture on the
massless line `|κ|=λ` (§4); and (c) **finite seesaw** — a protected mode that leaks
into a *heavy hidden block* `M` acquires only a suppressed effective mass
`|m_eff| ≤ ‖Bᴴv‖²/λ_min(M) → 0` as the hidden scale grows
(`SchurSeesaw.seesaw_suppression`, **M**), vanishing exactly when the leakage channel
is closed (`Bᴴv = 0`). So the *smallness* of a light mass is disciplined —
projective/index/critical/seesaw, not arbitrary tuning — even though its *value*
awaits the generation index and scale map above. (This is why a small neutrino mass
would be *natural* in the framework: a protected mode with suppressed hidden leakage,
not a fine-tuned coincidence — a falsifiable *shape*, not a number.)

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
separately by the targeted Lean and guard builds. The 2026-07-09 round-2
additions — `SignatureForcing`, `RPSelectsLorentzian`, `FiniteCPT` (§8 rows),
`Goal3ExactRG` (§9 row), `SuiteAOp2Geom` (§7 row), `Goal1Hadron` + `Goal1Rung5Tie`
(§6 rows), `Goal3BoostCovRational` (§9 row), `Goal3ChannelRG` + `Goal3ChannelRG4` (§4a rows) — and Codex seed additions —
`KMPhaseCounting`, `FiniteKMCP`, `IncidenceCorank`, `WEPTrace`,
`WEPActionBridge`, `MassResourceModularAudit`, `IndexAnomalyInterface`,
`GateI1.MassEntropyMonotone`, `SuiteCDNextRungs` — are per-module
`lake build` green with in-file guard pins (the new modules' cited declaration
names were grep-verified in-file on 2026-07-09); they await the next independent
anchor sweep.)*

| § | Declaration | File | Grade / guard | Role |
|---|---|---|---|---|
| 3 | `det_rankOneHermitian_eq_zero` | `Spinor/PluckerMass.lean` | M, trusted namespace | single edge massless |
| 3 | `two_edge_plucker_mass_identity` | `Spinor/PluckerMass.lean` | M, trusted namespace | two-edge mass = disagreement |
| 3 | `two_edge_mass_zero_iff_wedge_zero` | `Spinor/PluckerMass.lean` | M, trusted namespace | two-edge massless ⇔ wedge vanishes (collinear) |
| 3 | `fin_bundle_plucker_mass_identity` | `Draft/NullEdgePluckerGeneralAristotle.lean` | M, Draft (kernel-checked) | mass = pairwise disagreement, general `n` |
| 3 | `fin_bundle_mass_zero_iff_common_direction` | `Draft/NullEdgePluckerGeneralAristotle.lean` | M, Draft (kernel-checked) | massless iff collinear |
| 4 | `carrier_krein_square` | `Carrier/CarrierKreinSquare.lean` | M, guard-pinned (`CarrierAxiomGuard`) | master Krein identity: starred blocks `Q_{A,C}^#` + `4 Q_T` + `4 E_#` (§4) |
| 4 | `carrier_square_assembly` | `Carrier/CarrierSquareAssembly.lean` | M, guard-pinned (`CarrierAxiomGuard`) | self-adjoint 3-slot specialization `4 D^#D = Q_A+Q_C+4Q_T` (`E_#=0`, bare blocks) |
| 4 | `signed_budget_sum_one` | `Carrier/CarrierMassBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | shares sum to one (abstract) |
| 4/10 | `graded_budget_decomposition`, `graded_trace_odd_vanishes` | `Carrier/EquivariantGradedIndex.lean` | M, self-guarded (in-file pin) | **organizing theorem, provable half**: *any* 4-channel budget pushes through the graded supertrace by linearity ("unification is decomposition"); McKean–Singer odd-power cancellation. Not a topological index |
| 4/10 | `carrier_graded_budget` | `Carrier/CarrierGradedBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **the budget hypothesis discharged on the real carrier**: the graded supertrace of the carrier's *own* `4 D^#D` decomposes over the four channels (budget from `carrier_krein_square`, no assumed hypothesis) — the channels ARE the graded pieces of the carrier's Dirac square |
| 4 | `witness_budget_sum_one` | `Carrier/CarrierMassBudget.lean` | M, guard-pinned (`CarrierAxiomGuard`) | non-vacuous `(1/2,0,1/2)` witness |
| 4 | `sector_ground_mass` | `Carrier/SectorGroundMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | Rayleigh–Ritz keystone: definite-sector ground value is a positive squared mass (§4 rail 3, §10 crux 0) |
| 4 | `T2_positive_mass` | `Carrier/SectorGroundMassWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **the positivity linchpin**: explicit two-edge Cl(4) carrier, sector form `1+B^HB` PosDef, keystone fires ⇒ genuine positive mass (§6, §10 crux 0a) |
| 4 | `HAC_eq_clifford`, `Jmet_eq_clifford` | `Carrier/CliffordAssembly.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **T2 carrier realizes the documented Cl(4) recipe**: hand-typed Krein form/metric `= J(Q_A+Q_C)` / `Js⊗I3` (verbatim) — closes the docstring-only-provenance gap. Certifies *a* Clifford presentation, not canonicity (`K`/order are inputs) |
| 4 | `B_posDef_iff`, `B_massless_iff_of_pos` | `Carrier/MassGapWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | spectral theory of the block `B(λ,κ)`: massive `↔ \|κ\|<λ`, massless line `κ=±λ` for `λ>0` (§4) |
| 4 | `B_least_eigenvalue`, `B_spectrum` | `Carrier/MassGapWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **the mass gap as a theorem**: least eigenvalue of `B` `= λ−κ` = aperture − closure (`IsLeast`); full spectrum `= {λ−κ, λ, λ+κ}` (`B_spectrum`) — the three sector mass levels |
| 4 | `Msec_least_eigenvalue`, `Msec_posDef_iff` | `Carrier/SectorMassGap.lean` | M, guard-pinned (`CarrierAxiomGuard`) | block-diagonal `Msec = B(λ,κ)⊕B(λ,-κ)`: least eigenvalue `= λ−κ`; PosDef iff `\|κ\|<λ`. Honest scope: `Msec` is a hand ansatz, isospectral mirror pair (gap = the block's, multiplicity-doubled); carrier-tied only via the `(2,1)` top block |
| 4/10 | `spec_spacing_ratio`, `levels_eq_spectrum` | `Carrier/MassSpacingPrediction.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **within-carrier prediction P-spacing**: the three mass levels are equally spaced (`(m²_mid−m²_lo)/(m²_hi−m²_mid)=1`, scale-invariant); NOT the cross-generation neutrino ratio (honest boundary, §10) |
| 4 | `M6_topBlock_eq_B`, `M6_botBlock_eq_B` | `Carrier/MassGapWitness.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **the carrier tie at `(2,1)`**: `M6 = B(2,1) ⊕ B(2,-1)` — so the phase diagram is the carrier's actual sector form there (general `(λ,κ)` reduction is oracle-grade) |
| 4/10 | `blockBindingDefect_eq_neg_kappa`, `closurePerturbation_offDiagonal` | `Carrier/BindingDefect.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **T3b binding defect**: `Δ_block(λ,κ) = −κ` — closure lowers the ground mass by exactly its strength (negative, closure-controlled, off-diagonal); physical identification stays **C** (§10 crux 0b-b) |
| 3 | `free_mass_operator_eq_plucker` | `Carrier/FreeMassBridge.lean` | M, local guard pin | **free §3↔§4 bridge**: free mass operator `P·adj P = det P • 1` = Plücker mass (§10 crux 0b-a) |
| 3 | `pairwiseMass_append` (+`_le`, `_append_eq_iff`) | `Carrier/MassMonogamy.lean` | M, guard-pinned (`CarrierAxiomGuard`) | mass monogamy: Plücker mass superadditive, excess = cross-disagreement (F3) |
| 3 | `massOn_add_massOn_compl_le` | `Carrier/MassMonogamyPartition.lean` | M, guard-pinned (`CarrierAxiomGuard`) | general-partition monogamy: internal masses ≤ whole |
| 3a | `vonNeumannEntropy_eq_zero_iff_null`, `vonNeumannEntropy_pos_of_timelike`, `velocityNormSq_eq_one_sub_massRatio`, `vonNeumannEntropy_rest_eq_log_two` | `GateI1/MassEntropyDictionary.lean` | M, self-guarded (in-file pin) | **mass ↔ visible-entropy dictionary**: null ⇔ `S=0` ("null edges don't age"), timelike ⇔ `S>0`, rest ⇔ `S=log 2`; `\|v\|²=1−m²/E²` |
| 3a | `four_mul_det_gram_eq_concurrence_sq`, `det_gram_eq_normSq_wedge`, `det_gram_eq_zero_iff_concurrence_eq_zero` | `NullEdge/TwoEdgeMassConcurrence.lean` | M, self-guarded (in-file pin) | **two-edge mass = Wootters concurrence²**: `4·det P = C²` (`det P = (C/2)²`); massless ⇔ zero concurrence ⇔ product state |
| 3a | `gConcurrence_pow_eq_det_gram`, `det_gram_eq_normSq_wedge`, `det_gram_eq_sum_normSq_minors` | `NullEdge/NEdgeMassConcurrence.lean`, `NullEdge/NEdgeCauchyBinet.lean` | M, self-guarded (in-file pins) | **`n`-edge mass = G-concurrence²**: `det P = (G/n)ⁿ` (Gour G-concurrence), two-edge = `n=2` instance; Cauchy–Binet `det P = Σ_S \|det M_S\|²` (mass = total `d`-wise disagreement). "mass = concurrence²" is not a two-edge coincidence |
| 3a | `det_le_half_trace_sq` | `NullEdge/MassEnergyBound.lean` | M, self-guarded (in-file pin) | **mass ≤ energy, extremal at rest**: `det P ≤ (tr P/2)²` (`m ≤ E`), gap `((P₀₀−P₁₁)/2)²+\|P₀₁\|²`; equality iff `P` scalar = rest = max-mass & max-mixedness at fixed energy |
| 3 | `massive_eq_two_null`, `massSq_eq_two_null_disagreement`, `posSemidef_eq_null_edge_sum`, `det_eq_null_edge_disagreement` | `NullEdge/MassNullDecomposition.lean` | M, self-guarded (in-file pin) | **the converse — all mass IS null-edge disagreement**: every timelike `p` = sum of two null momenta (`m²=2·disagreement`); every PSD `P = M Mᴴ = Σψᵢψᵢᴴ`, `det P=\|det M\|²`. Mass ⇔ null-disagreement is bidirectional/universal |
| 3a | `binding_defect_eq_coupling`, `binding_defect_eq_concurrence`, `binding_below_threshold_iff_entangled` | `NullEdge/BindingEntanglementDeficit.lean` | M, self-guarded (in-file pin) | **binding = entanglement deficit**: on `Bc(λ,κ)`, defect `Δ=κ=C(ρ)·λ` where `C(ρ)=κ/λ` is the coupled block's concurrence; binds below threshold iff entangled (§3a target ii, C→M) |
| 3a | `coherent_is_pure`, `decohered_mass_eq_disagreement`, `mass_monotone_in_decoherence` | `NullEdge/PathSumSemantics.lean` | M, self-guarded (in-file pin) | **path-sum semantics**: the path-conditioned visible state `ρ_dir`; full coherence ⇒ pure (`det=0`, massless), decoherence ⇒ `det = Σ\|a\|²\|a'\|²\|ψ∧ψ'\|²` (mass = retained which-direction info), monotone `det ρ(t)=t(2−t)D`. Non-collinear witness `det=4/25` |
| 3a | `det_pinch`, `mass_monotone_under_pinch`, `signed_closure_exception` | `NullEdge/EntropyMonotoneReal.lean` | M, self-guarded (in-file pin) | **entropy monotonicity under decoherence**: `det(Pinch t ρ)=det ρ+(2t−t²)x²`; decohering hidden coherence can only increase mass²/linear-entropy; a signed closure move can lower it (`49/2500<1/4`) — closure is not noise |
| 3a | `compton_floor_sq`, `no_sub_compton_sq` | `NullEdge/ComptonBoundSq.lean` | M, self-guarded (in-file pin) | **finite Compton bound**: the mass gap is a length floor `widthSq m ψ ≥ 1/(4m²)` on the `J`-positive sector; `widthSq = ¼·dCausal²` — the localization floor is half the Connes distance. Honest scope: 2-point carrier, structural constant `½` |
| 8 | `corner_ker_ge_index`, `corner_ker_ge_index_perturbed`, `witness_one_protected_mode` | `NullEdge/ChiralIndexProtection.lean` | M, self-guarded (in-file pin) | **chiral index ⇒ protected modes**: `dim ker A ≥ n₊−n₋` (rank–nullity), stable under any odd (mass) perturbation; witness index-1 carrier has ≥1 protected massless mode |
| 10 | `seesaw_suppression`, `seesaw_zero_iff_no_overlap` | `NullEdge/SchurSeesaw.lean` | M, self-guarded (in-file pin) | **finite seesaw**: a protected mode leaking into a heavy hidden block `M` gets `\|m_eff\| ≤ ‖Bᴴv‖²/λ_min(M) → 0` (resolvent suppression, not tuning); mass=0 iff no overlap `Bᴴv=0` |
| 3 | `posDef_iff_det_pos`, `det_eq_zero_iff_not_posDef` | `Carrier/RankAreaMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | massive ⇔ momentum PosDef ⇔ `det P > 0` (rank/area) |
| 7 | `weitzenbock_eq_zero_iff` (+`_re_inner_nonneg`) | `Carrier/WittenPositiveMass.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite Witten/Lichnerowicz: `A^#A+C` PSD, vanishes iff covariantly constant & curvature-null (F4) |
| 9 | `multiplierStationary_iff_eom` | `Carrier/FiniteCarrierAction.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite carrier action: variational stationarity ⇔ the equation of motion (dynamics D1) |
| 9 | `massShellAction_invariant_of_commutes`, `massShell_equation_symmetry` | `Carrier/FiniteQuadraticAction.lean` | M, self-guarded (in-file pin) | finite Noether: a unitary symmetry commuting with `A` preserves the (mass-shell) action and transports mass-shell solutions to solutions of the same mass (dynamics D1) |
| 9 | `norm_conserved_orbit`, `energy_conserved_orbit` | `Carrier/FiniteUnitaryEvolution.lean` | M, guard-pinned (`CarrierAxiomGuard`) | a sector isometry conserves norm & energy along its orbit (dynamics D2/D3) |
| 9 | `hermitian_flow_mem_unitaryGroup`, `B_flow_unitary`, `hermitian_flow_isometry` | `Carrier/CarrierUnitaryFlow.lean` | M (first two guard-pinned) | **the D2 instantiation, closed**: the carrier-block Hermitian flow `exp(−i t H)` is unitary and a `LinearIsometryEquiv` (generator-as-Hamiltonian is a **C** posit; carrier tie kernel at `(2,1)`) |
| 9 | `HAC_flow_Jmet_unitary`, `HAC_flow_sector_invariant`, `J_selfAdjoint_flow_J_unitary`, `HAC_Jmet_selfAdjoint` | `Carrier/CarrierKreinFlow.lean` | M, self-guarded (in-file pin) | **the dynamical Krein half, closed on the witness** (batch-6 audit gap): `HAC` is `Jmet`-self-adjoint and `range Piso` is `HAC`-invariant, so `exp(−itHAC)` is `Jmet`-unitary AND sector-preserving — Krein-form-conserving orbit, not just Euclidean (generator-as-Hamiltonian stays **C**) |
| 9 | `carrier_orbit_norm_conserved`, `carrier_orbit_energy_conserved`, `carrier6_orbit_norm_conserved` | `Carrier/CarrierUnitaryFlow.lean` | M, guard-pinned (`CarrierAxiomGuard`) | the flow **orbit** of the carrier block `B(λ,κ)` — and of the full `6×6` physical sector form `M6` (`carrier6_…`) — conserves sector norm & (commuting-observable) energy: `FiniteUnitaryEvolution` fired on the concrete carrier |
| 9 | `secondQuantized_massGap` | `Carrier/FockMassGap.lean` | M, self-guarded (in-file pin) | **free second-quantized mass gap**: on the fermionic occupation Fock space, `dΓ(B)`'s gap = one-particle gap `λ−κ`; free 2-body = sum of constituents; `Δ=−κ` seeds a below-threshold bound state |
| 9 | `interacting_boundState_below_threshold` | `Carrier/InteractingTwoBody.lean` | M, self-guarded (in-file pin) | **interacting below-threshold bound state**: an attractive `V` of the closure scale `κ` gives a least eigenvalue strictly below the constituent sum (`IsLeast`, no inserted defect) |
| 9 | `derived_boundState_below_threshold`, `derived_wrongPlane_no_binding` | `Carrier/DerivedInteraction.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **`V` is a 2nd-quantized closure operator, conditionally binding**: `Vderived = dΓ(iκK)` (= modelled `V` up to phase gauge) binds below threshold *iff* the closure acts among *excited* modes (ground-plane closure → no binding; boundary `κ²=(d₂−d₀)(d₂−d₁)`) |
| 9 | `massBlock_eq_carrierK`, `carrierK_eq_closureCurvature`, `carrier_closure_binds` | `Carrier/CarrierClosurePlane.lean` | M, self-guarded (in-file pin) | **the carrier's own `K` IS in the binding plane** → binding is unconditional for the carrier (**C→M**): `carrierK = !![0,0,0;0,0,−1;0,1,0] = closureCurvature`, ground mode a spectator, ≠ ground-plane curvature. Only the specific mass-value stays **C** |
| 4 | `square_decomposition` | `NullEdge/CarrierRigidity.lean` | M, self-guarded (in-file pin) | **four-block square, no fifth block**: `2(D#D)=Q_A+Q_C+2E_#+2Q_T` exactly, four distinct even/odd Krein grades — the channel *type-count* is forced (structure of "unification=decomposition"). Full *uniqueness* of the split is NOT forced (non-rigid; needs a further axiom) |
| 9a | `posDef_aperture_add_gram`, `massGap_one_add_gram` | `NullEdge/PositiveSectorClassification.lean` | M, self-guarded (in-file pin) | **positive-sector criterion (generalizes T2)**: `A PosDef ⇒ (A+BᴴB) PosDef`, gap `≥1` — closure entering *squared* never destabilizes a positive aperture, beyond the `Cl(4)` witness |
| 2a | `Dop`/`kdag_Dop`, walk = carrier | `NullEdge/CheckerboardCarrierBridge.lean` | M, self-guarded (in-file pin) | **the 1+1D Dirac quantum walk IS a Krein null-edge carrier**: null Clifford edges `cP²=cM²=0`, `{cP,cM}=1`, kinetic/mass/`D` all Krein-self-adjoint; channel names match kinetic/mass. First "channels = physics" evidence |
| 9 | `dirac_mass_shell`, `Ustep_hasDerivAt_generator` | `Carrier/ContinuumLimit.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **continuum-limit finite symbol facts**: mass shell `(kσ_z+mσ_x)²=(k²+m²)·1`; discrete transfer generator matches the Dirac Hamiltonian symbol to leading order. Continuum *theorem* is `[import]` (1+1D) / open (Cl(4)) |
| 2a/9 | `massive_implies_subluminal`, `luminal_iff_massless`, `groupVelSq_num_le_sin_sq_omega` | `Carrier/SubluminalBound.lean` | M, self-guarded (in-file pin) | **derived speed limit**: from the pinned dispersion `cos ω=cos k cos θ`, `v_g²≤1` with deficit `1−cos²θ`; every massive mode strictly subluminal, only the massless (`θ=0`) luminal. Boost symmetry NOT derived (critical-point only) |
| 9 | `invariant_orbit`, `observable_antitone_orbit` | `Carrier/FiniteRGFlow.lean` | M, guard-pinned (`CarrierAxiomGuard`) | RG orbit invariants/monotones under an iterated step (dynamics D4; axiom-free) |
| 9 | `partitionFunction_pos`, `sum_probability_eq_one` | `Carrier/FiniteCanonicalEnsemble.lean` | M, guard-pinned (`CarrierAxiomGuard`) | finite canonical ensemble over the carrier spectrum (dynamics D5) |
| 5 | `onshell_wedge_normSq_eq_coin_sq` | `GateI1/MassCoinBridge.lean` | M, kernel-checked (not pinned; supporting) | corner flip amplitude = wedge |
| 6 | `closure_defect_trace_eq` | `GateYM/PlaquetteClosureAction.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure-defect trace identity |
| 6 | `wilson_plaquette_eq_half_closure_defect` | `GateYM/PlaquetteClosureAction.lean` | M, guard-pinned (`SlabAxiomGuard`) | Wilson action = squared defect |
| 6 | `leading_closure_energy_nonneg` | `GateYM/LinearizedClosureEnergy.lean` | M, local guard pin in `LinearizedClosureEnergy.lean`; enforced transitively because `SlabAxiomGuard` imports that module | leading closure defect = nonnegative `|F|²` energy |
| 6 | `null_soldered_square` | `GateYM/S1ClosureCurrentAlgebra.lean` | M, guard-pinned (`SlabAxiomGuard`) | closure square structure (abstract) |
| 6 | `closure_current_square` | `GateYM/S1ClosureCurrentAlgebra.lean` | M, guard-pinned (`SlabAxiomGuard`) | abstract skew-pairing square (concrete `Q_C=L^#L` is MEMO) |
| 6/10 | `balanced_on_physical_sector`, `JQc_not_positive_on_sector` | `GateYM/S1CCPhysicalSectorWitness.lean` | M, self-guarded (in-file pin) | **S1-CC physical-sector instantiation, now kernel**: on the explicit `6×6` Clifford⊗color witness the induced closure form `J Q_C\|V'/N` has inertia `(2,2,0)` (balanced, indefinite) — the central-crux no-go on the witness is a theorem, not MEMO (§6, §10 #1) |
| 6/10 | `compression_balanced`, `compression_balanced_eigbasis`, `compression_has_neg_eigenvalue` | `GateYM/S1CCGeneralReduction.lean` | M, guard-pinned (`SlabAxiomGuard`) + self-guarded | **S1-CC balance mechanism, general kernel**: for *any* coset-representative selection `r` (or, `_eigbasis`, *any* `b`-eigenvector family `P`) and *any* `±1` closure grading anticonjugating the closure form, the compression is balanced — **`Q_G`-blind by construction**. `_eigbasis` drops coordinate alignment (§6, §10 #1) |
| 6/10 | `physical_sector_b_eigenbasis_exists`, `physical_sector_balanced` | `GateYM/S1CCPresentationExistence.lean` (+ `S1CCEigenbasis.lean`) | M, guard-pinned (`SlabAxiomGuard`) | **S1-CC presentation-existence, closed (non-degenerate)**: for any `±1` grading `b` and any **nilpotent** `Q_G` (`Q_G²=0`, *no Hermiticity*) commuting with `b`, a `b`-eigenbasis presenting `V'/N` exists — in `ker Q_G`, linearly independent, full dimension `card ι − 2·rank Q_G`, complementary to `range Q_G` — closing the last MEMO piece of the central crux. Non-Hermiticity is load-bearing (a Hermitian nilpotent collapses to 0); 3rd iteration, prior two rejected on review |
| 6/10 | `witness_balanced_via_general` | `GateYM/S1CCWitnessAsInstance.lean` | M, guard-pinned (`SlabAxiomGuard`) + self-guarded | the `6×6` witness balance re-derived as a **literal instance** of `compression_balanced` — confirming it is not special to its coordinate alignment |
| 6 | `tyAreaLaw_slab_exp` | `GateYM/TYAreaLaw.lean` | M, guard-pinned (`SlabAxiomGuard`) | strong-coupling area law |
| 6 | `wilsonSlabConnected_reflectionPositive` | `GateYM/WilsonSlabConnected.lean` | M, guard-pinned (`SlabAxiomGuard`) | slab reflection positivity |
| 6 | `OSReconstruction.osSpectralGap_pos` | `GateYM/OSReconstruction.lean` | M, guard-pinned (`SlabAxiomGuard`) | OS spectral gap |
| 6 | `slab_exponential_clustering` | `GateYM/SlabClustering.lean` | M, guard-pinned (`SlabAxiomGuard`) | exponential clustering |
| 6 | `banks_casher_count` | `GateYM/FiniteBanksCasherCount.lean` | M, guard-pinned (`SlabAxiomGuard`) | finite Banks-Casher-type eigenvalue count |
| 6 | `skew_prod` | `GateYM/FiniteBanksCasherCount.lean` | M, guard-pinned (`SlabAxiomGuard`) | count denominator `= m²+AᴴA` |
| 6 | `anticonj_odd_pow_trace_zero` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | odd-trace identity from finite anticonjugation |
| 6 | `anticonj_charpoly_eq` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | finite anticonjugation gives charpoly negation symmetry |
| 6 | `hermitian_eigenvalue_multiset_map_neg_eq_of_neg_charpoly` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | Hermitian eigenvalue multiset is negation-invariant |
| 6 | `hermitian_balanced_count_of_neg_charpoly` | `GateYM/S1CCBalancedInertia.lean` | M, guard-pinned (`SlabAxiomGuard`) | equal positive/negative Hermitian eigenvalue counts (the balance engine); physical `J Q_C\|V'/N` instantiation **M** on the witness (`S1CCPhysicalSectorWitness`); the general balance *mechanism* **M** (`S1CCGeneralReduction`) and the V'/N presentation-existence now **M** too (`S1CCPresentationExistence`, non-degenerate) |
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
| 8 | `clifford_null_forces_indefinite`, `Q13_indefinite`, `Q22_indefinite` | `NullEdge/SignatureForcing.lean` | M, self-guarded (in-file pin) | **null forces indefinite metric**: a nonzero null edge forbids a definite soldering Gram (`c(v)²=Q(v)`); `(1,3)` and `(2,2)` both indefinite (signature rung 1) |
| 8 | `oneTime_reflectionPositive`, `twoTime_reflectionPositive_fails` | `NullEdge/RPSelectsLorentzian.lean` | M, self-guarded (in-file pin) | **reflection positivity selects one time**: the `(1,3)` OS toy is reflection-positive with a nondegenerate physical sector; any second time direction (incl. `(2,2)`) fails RP (signature rung 2). Honest scope: minimal single-mode two-site toy, not full OS reconstruction |
| 8 | `Theta_conjugates_D_to_sharp`, `spectrum_conjugate_paired` | `NullEdge/FiniteCPT.lean` | M, self-guarded (in-file pin) | **finite CPT**: antiunitary `Theta=C.Gamma_rev.#` on a non-degenerate `C^4` Clifford⊗color witness gives `Theta D Theta^{-1}=D^#` ⇒ conjugate-paired Dirac spectrum. Honest scope: the concrete witness's `D`, not the §8 unitary `W` |
| 9 | `R_schur_derivation`, `massless_line_invariant_and_nondegenerate`, `linearized_mass_eigenvalue_eq_two`, `conical_dispersion_z_eq_one` | `NullEdge/Goal3ExactRG.lean` | M, self-guarded (in-file pin) | **exact rational RG flow**: decimation `R(λ,κ)=(λ−2κ²/λ, −κ²/λ)`; critical line `\|κ\|=\|λ\|` invariant (witness `R(1,1/2)≠(1,1/2)`); relevant eigenvalue exactly `2` ⇒ `ν=1`; conical dispersion ⇒ `z=1`. Honest scope: critical *line* invariant (period-2, not a strict fixed point); finite rational, not a continuum limit |
| 7 | `dCausal_01`, `causalLE_isPartialOrder`, `Eslot_mismatch`, `Eslot_ne_one` | `NullEdge/SuiteAOp2Geom.lean` | M, self-guarded (in-file pin) | **finite Malament split**: causal spectral distance `dCausal m 0 1 = 1/m` (witnesses `1/3`, `5/3`); `CausalLE` a partial order recovering edge orientation; order/conformal class mass-independent while scale `Eslot m m' = m'/m` — "causal order fixes the conformal class, decorations owe the scale". Honest scope: 2-point Krein carrier |
| 6 | `confinement_dichotomy_12`, `rung3_bound_below_threshold`, `rung4_positive_gap` | `NullEdge/Goal1Hadron.lean` | M, self-guarded (in-file pin) | **verified toy hadron** on the 12-dim `Cl(4)⊗C³` carrier: singlet sector PosDef / colored NegDef (dims pinned `>0`, witnesses `(1,1,1)`/`(1,−1,0)`); the two-particle singlet ground state is bound (`−1`) strictly below threshold `1` (witness `d=(0,1,7)`, `κ=4`); exact spectrum `{−1,8,9}` ⇒ gap `9`. Honest scope: finite toy, NOT a physical pion/rho, no continuum; the genuine chained result is rungs 1–4 |
| 6 | `bound_budget_from_eigenvector`, `closure_share_nonneg`, `closure_energy_neg` | `NullEdge/Goal1Rung5Tie.lean` | M, self-guarded (in-file pin) | **honest budget of the toy hadron's actual ground state**: computed from the bound eigenvector `v=(2,1,0)`, closure ENERGY is negative (`⟨v,H_C v⟩=−16`, binding IS closure-driven) but the normalized closure SHARE is `b_C=16/5 ≥ 0` (total energy `−5<0` flips the sign). Corrects a modelled `b_C<0`; the program's negative-closure-share result is the separate 18-dim S1-CC witness (§6 above) |
| 9 | `massless_cone_invariant`, `boost_preserves_Q`, `massless_cone_witness`, `massive_shell_not_invariant` | `NullEdge/Goal3BoostCovRational.lean` | M, self-guarded (in-file pin) | **emergent boost covariance (rational)**: the rational boost `Boost(5/3,4/3)` (det 1, `≠1`) preserves `Q=ω²−k²` and maps the massless light cone `Q=0` to itself (witness `(3,3)↦(9,9)`, moved but on-cone); massive states are boosted to distinct on-shell points. Honest scope: mass-shell-set + `Q`-form invariance, not a spinor intertwiner |
| 4a | `R3_closed_form`, `critical_fixed_data`, `rg_eigenvalues`, `kill_test` | `NullEdge/Goal3ChannelRG.lean` | M, self-guarded (in-file pin) | **channel-RG kill-test (§4a point 4)**: 3-coupling decimation `R3(λ,κ,τ)=(λ−2(κ²+τ²)/λ, −(κ²−τ²)/λ, −2κτ/λ)` = chiral square `z'=−z²/λ`; criticality Jacobian char poly `(x−2)(x+1)(x+2)`, eigenvalues `2,−1,−2` (turn axis relevant); basin-membership NOT killed, turn is relevant. Honest scope: one rational model, not a continuum reduction |
| 4a | `R4_closed_form`, `critical_jacobian`, `rg_charpoly`, `soldering_verdict` | `NullEdge/Goal3ChannelRG4.lean` | M, self-guarded (in-file pin) | **full 4-channel RG (§4a point 4)**: adds soldering `E`; critical `4×4` Jacobian char poly `(x−2)(x+1)(x+2)(x−3)`, soldering eigenvalue `3` (RELEVANT). All four named channels (aperture/closure/turn/soldering) are relevant/marginal RG coordinates; geometry does not decouple. Honest scope: one rational model, not a continuum reduction |
| 8/10 | `ckm_param_split`, `cp_possible_iff` | `NullEdge/KMPhaseCounting.lean` | M, self-guarded (in-file pin) | **finite CP phase-count arithmetic**: CKM bookkeeping splits `N^2` into angles, removable phases, and physical CP phases; the physical CP count is positive iff `N >= 3`. Honest scope: not yet the constructive N=2 rephasing theorem or N=3 Jarlskog witness |
| 8/10 | `jarlskog_rephase`, `jarlskog_two_eq_zero`, `exists_real_rephasing_two`, `Vwitness_unitary`, `jarlskog_Vwitness_ne_zero` | `NullEdge/FiniteKMCP.lean` | M, self-guarded (in-file pin) | **finite KM CP rung**: the Jarlskog plaquette is rephasing-invariant; every unitary `2 x 2` matrix is rephasable to real entries; and an exact unitary `3-4-5` witness has `J = 6912 / 78125 != 0`. Honest scope: constructive low-N witnesses; global normal form still separate |
| 8/10 | `coboundary_rank`, `coboundary_corank`, `coboundary_corank_two`, `coboundary_corank_three` | `NullEdge/IncidenceCorank.lean` | M, self-guarded (in-file pin) | **general-N CP corank theorem**: complete-graph phase coboundary has rank `N-1` and corank `(N-1)(N-2)/2` over an arbitrary field; N=2 has no physical phase and N=3 has exactly one. Honest scope: linearized phase-count/corank theorem, not a full unitary normal-form theorem |
| 7/9 | `wep_trace_identity`, `wep_universality`, `wep_source_nonvacuous`, `wep_violation_of_channel_stress` | `NullEdge/WEPTrace.lean` | M, self-guarded (in-file pin) | **WEP trace rung**: a channel-blind finite source `Tr(K rho)` depends only on total budget `Tr rho`, with a nonvacuous equal-trace witness and a channel-stress negative control. Honest scope: not the E-slot field equation or Clausius/Jacobson rung |
| 7/9 | `stationary_iff_fieldEquation`, `stationary_channelBlind_source`, `bridge_nonvacuous` | `NullEdge/WEPActionBridge.lean` | M, self-guarded (in-file pin) | **WEP action/source bridge**: a finite trace-level multiplier action is stationary against all matrix variations iff `G=K`; channel-blind coupling gives source side `kappa * Tr rho`, with nonzero source witness. Honest scope: trace/source bridge, not the E-slot geometric field equation |
| 9/10 | `modular_generator_eq_adB`, `modular_generator_matrix`, `modular_shift_operator_ne` | `NullEdge/MassResourceModularAudit.lean` | M, self-guarded (in-file pin) | **Suite D modular guardrail**: a central normalization shift cancels in the commutator derivation, but operator equality with `B` is false for every background `B` when the shift is nonzero. Honest scope: modular false-shape guard, not a full mass-resource theory |
| 8/10 | `toyIndex_eq_dim_diff`, `toy_index_anomaly`, `windingOne_nonvacuity`, `analytic_anomaly_of_reduction` | `NullEdge/IndexAnomalyInterface.lean` | M, self-guarded (in-file pin) | **C3 finite index-anomaly interface**: signed finite index is dimension mismatch; the winding family satisfies `Index(D_w)-Index(D_0)=w`; winding one has a nonzero protected mode; the analytic statement is isolated as an explicit reduction hypothesis. Honest scope: finite rank-nullity only |
| 3a/10 | `binEnt_antitoneOn`, `vonNeumannEntropy_antitone_speed`, `vonNeumannEntropy_monotone_massRatio`, `massEntropyMonotone` | `NullEdge/GateI1/MassEntropyMonotone.lean` | M, self-guarded (in-file pin) | **mass-entropy resource monotone**: binary entropy is antitone in speed; visible entropy is monotone in invariant mass ratio on future-cone momenta; null momenta are the free states of the bundled resource monotone. Honest scope: same-frame finite block, observer-conditioned entropy |
| 4a/8/10 | `uN_parameter_count`, `c3_index_anomaly`, `channel_charges_traceless`, `channel_charges_independent` | `NullEdge/SuiteCDNextRungs.lean` | M, self-guarded (in-file pin) | **small Suite C/D next rungs**: U(N) parameter count, finite relative-index identity, Suite D traceless channel charges, and linear independence of the four GGE charges. Honest scope: arithmetic/interface rungs, not a continuum reduction |

---

## Provenance and status

This manuscript is a draft of the overnight all-mass run (2026-07-08). Its
verified core (§3, §4, §6 pillars, §8, §9) is machine-checked; its physical
readings (§5, §7, the budget's hadron interpretation) are MEMO or
conjectural and labeled as such. The external anchors — Wilson,
Osterwalder–Seiler, Banks–Casher, Ji, Yang et al., Dürr et al.,
Asbóth–Obuse, Aldrovandi–Pereira, NuFIT-6.0, Sumino — are `[import]` and are
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
- K. van den Dungen, *Krein spectral triples and the fermionic action*, Math.
  Phys. Anal. Geom. 19 (2016) 4, arXiv:1505.01939 (Krein-space generalization of
  spectral triples; fundamental-symmetry decomposition `K = K⁺ ⊕ K⁻`; the
  indefinite-inner-product setting for the §6 balanced-closure form — `[import]`
  for the Krein/fundamental-symmetry framework, the anticonjugation-forces-balance
  argument `b Q_C b = −Q_C ⇒ sig = (n,n,·)` is `[orig]`).
- N. Bizi, *Semi-Riemannian Noncommutative Geometry, Gauge Theory, and the
  Standard Model of Particle Physics*, PhD thesis (2018), arXiv:1812.00038
  (indefinite spectral triples over a `Z₂`-graded Krein space; the grading
  involution `Γ` with adjoint sign flip `Γ^‡ = (−1)^q Γ` — the NCG precedent for
  the §6 closure grading `b = σ_z ⊗ 1` being Krein-`‡`-odd on the closure channel).
- T. Ya. Azizov, I. S. Iokhvidov, *Linear Operators in Spaces with an Indefinite
  Metric*, Wiley (1989); J. Bognár, *Indefinite Inner Product Spaces*, Springer
  (1974) (`[import]` — the standard operator theory of `J`-self-adjoint and
  `J`-unitary operators on Krein spaces; the functional-analysis backing for the
  §6 positive-sector framing and the §9a `J`-self-adjoint-generator ⇒
  `J`-unitary-flow question).

**Discrete Dirac, quantum walks/automata, fermion doubling (§2a, §8).**

- D. Bakircioglu, P. Arnault, P. Arrighi, *Fermion Doubling in Quantum Cellular
  Automata*, arXiv:2505.07900.
- L. Mlodinow, T. A. Brun, *Discrete spacetime, quantum walks, and relativistic
  wave equations*, Phys. Rev. A 97 (2018) 042131, arXiv:1802.03910 (4D coin →
  Dirac gammas; coin-flip operator = mass term; §2a mass-side comparator).
- A. Bisio, G. M. D'Ariano, P. Perinotti, A. Tosini, *Weyl, Dirac and Maxwell
  Quantum Cellular Automata*, arXiv:1601.04842 (1D Dirac QCA barrier scattering;
  the prior-art setup for the §9a `carrier_scattering_sim.py` S-matrix).
- H. B. Nielsen, M. Ninomiya, *Absence of neutrinos on a lattice*, Nucl. Phys.
  B185 (1981) 20.

**Confinement, positivity, constructive/lattice gauge theory (§6, §9).**

- D. Zwanziger, *Vanishing of zero-momentum lattice gluon propagator and color
  confinement*, Nucl. Phys. B364 (1991) 127.
- K. Osterwalder, E. Seiler, *Gauge field theories on a lattice*, Ann. Phys. 110
  (1978) 440.
- K. G. Wilson, *Confinement of quarks*, Phys. Rev. D 10 (1974) 2445 (the Wilson
  action, §6).
- T. Banks, A. Casher, *Chiral symmetry breaking in confining theories*, Nucl.
  Phys. B169 (1980) 103.
- P. H. Ginsparg, K. G. Wilson, *A remnant of chiral symmetry on the lattice*,
  Phys. Rev. D 25 (1982) 2649 (the GW relation, §8).
- J. K. Asbóth, H. Obuse, *Bulk-boundary correspondence for chiral symmetric
  quantum walks*, Phys. Rev. B 88 (2013) 121406.
- T. Kugo, I. Ojima, *Local Covariant Operator Formalism of Nonabelian Gauge
  Theories and Quark Confinement Problem*, Prog. Theor. Phys. Suppl. 66 (1979) 1,
  doi:10.1143/PTPS.66.1 (the BRS-charge quartet / physical-subspace criterion and
  the general theory of indefinite-metric quantum fields — the nonabelian
  Gauss-sector precedent for the §6 physical sector `V'/N`; `[import]`).
- S. N. Gupta, *Theory of longitudinal photons in quantum electrodynamics*, Proc.
  Phys. Soc. A63 (1950) 681, doi:10.1088/0370-1298/63/7/301; K. Bleuler, *Eine
  neue Methode zur Behandlung der longitudinalen und skalaren Photonen*, Helv.
  Phys. Acta 23 (1950) 567 (the abelian indefinite-metric physical-state
  construction with a modified supplementary condition — the classic precedent for
  the §6 quotient/half-constraint analogy; `[import]`).

**Hadron mass, proton mass decomposition (§4, §4a, §5).**

- X. Ji, *QCD analysis of the mass structure of the nucleon*, Phys. Rev. Lett.
  74 (1995) 1071, arXiv:hep-ph/9410274 (the Ji decomposition, §4/§4a).
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
the Δ binding-energy probe, the T3a free-bridge probe, and the five dynamics
simulators — `carrier_spectrum_sim.py` (mass phase diagram; validates
`T2_positive_mass` + `signed_budget_sum_one`), `carrier_evolution_sim.py`
(unitary flow, quantum-walk transfer, Slater amplitudes; validates
`FiniteUnitaryEvolution` + `T2`), `carrier_rgflow_sim.py` (RG flow, canonical
ensemble, condensate shadow; validates `FiniteRGFlow` +
`FiniteCanonicalEnsemble` + `RGSchurMassWitness`), and `carrier_scattering_sim.py`
(a finite S-matrix: mass-barrier transmission/reflection, unitary and reciprocal;
validates `FiniteUnitaryEvolution` + `T2`), and `carrier_fock_sim.py` (finite
second-quantized Fock: free gap, binding seed, interacting below-threshold bound
state; validates `FockMassGap` + `BindingDefect` + `B_spectrum`). A probe is
evidence for adding a fixture or pre-registering a prediction — never a substitute
for a kernel proof.

**Provenance.** Source keys and convention checks are in
`Sources/Null_Edge_References.md`; the PhysLean convention cross-checks and the
prior-art / novelty-gap analysis are in `docs/PHYSLEAN.md` and
`Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`.

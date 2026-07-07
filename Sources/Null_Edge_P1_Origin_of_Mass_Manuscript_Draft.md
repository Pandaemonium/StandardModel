# The Origin of Mass: matter as trapped, disagreeing light

> **Status (2026-07-07): SUPERSEDED by v3**
> (`Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md` - rewrite for
> clarity/impact with the status map updated through 2026-07-07). This v2
> file is retained for provenance; the claim-calculus constitution and all
> kernel statements carry forward unchanged.

**Working draft v2, 2026-07-03** (supersedes the 2026-06-25 draft and its
2026-06-27 addendum; see the change log at the end).
Publication-plan slot: P1 in
[`Null_Edge_Causal_Graph_Publication_Plan.md`](Null_Edge_Causal_Graph_Publication_Plan.md).
Companion skeleton:
[`Null_Edge_P1_Plucker_Mass_Manuscript_Skeleton.md`](Null_Edge_P1_Plucker_Mass_Manuscript_Skeleton.md).

This revision applies the program's Round 8 adversarial-review constitution
(`Sources/nrqg-round8-adversarial-synthesis.md`) and absorbs the Round 7
parameter audit (`Sources/nrqg-round7-parameters.md`):

- the core theorem is stated in **interpretation-free form** first, with the
  null-edge reading supplied separately as motivation (Round 8, Attack 1.3);
- the mass/concurrence language is corrected to the **orbit-invariant** form
  (Round 8, Attack 1.4): the invariant is `det P`; "concurrence" is its value
  in a decomposition gauge;
- claims carry the closed **claim calculus**: `T` (theorem, source-verified),
  `T|H` (theorem conditional on displayed hypotheses), `M` (program-internal,
  Lean-verified or reproducible numerics), `C` (pre-registered conjecture with
  gate and kill-condition), plus originality tags `[orig]` / `[comp]` /
  `[import]` / `[interp]`; a composite claim's grade is the minimum over its
  links;
- the **Omega-firewall** is observed: ontological program language (sessions,
  schedulers, commits) appears nowhere in this paper's claims; Part I is
  standard-physics pedagogy plus one clearly labeled motivating hypothesis;
- a new **layered status map** (Part II, section 16) answers, with grades,
  how close the program currently is to a full origin-of-mass account.

**Lean anchors** (all verified to exist 2026-07-03; build status in the
provenance note below):

- Trusted: `PhysicsSM.Spinor.PluckerMass`, `PhysicsSM.Spinor.TwistorPluckerMass`.
- Kernel-clean drafts: `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`
  (SL(2,C) covariance), `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`
  (static Dirac square root).
- Standalone kernel-clean artifact:
  `AgentTasks/aristotle-standalone/null-edge-spinor-network-closure-20260621/`
  (celestial moment form).
- New program anchors (kernel-clean drafts, cited as context, not as results
  of this paper): `PhysicsSM.Draft.NullEdge.GateI1.Core` (soldering
  determinant and spectral layer), the Gate C1 free chiral release
  (`PhysicsSM/Draft/NullEdge/GateC1/`, e.g. `TetraOperatorOverlapGW`,
  `TetraOperatorWeylProjectors`), and the Gate C2 index/certified-sign layer
  (`PhysicsSM/Draft/NullEdge/GateC2.lean` aggregator; summary in
  `Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md`).

**Provenance check (2026-07-03).** Every Lean declaration named in Part II was
grep-verified to exist in the cited module. The trusted namespace builds green
under the pinned toolchain `leanprover/lean4:v4.28.0` (`lake build`, 8295
jobs, run this date). The gate-tree anchors are outside the default target and
were verified by targeted aggregate builds the same date (Gate C2 aggregator:
8063 jobs green; Gate I1: 8027 jobs green); their axiom footprint is
`[propext, Classical.choice, Quot.sound]` (no placeholders, no native
evaluation). Literature anchors were verified 2026-06-25 against INSPIRE-HEP /
Semantic Scholar / Crossref as recorded in section 12; per the program's
citation-verification debt rule, the two remaining unverified imports (the
Wilczek "mass without mass" essay reference and the Koide 1981 original) are
explicitly flagged there and must be source-verified before submission.

**Conventions.** Metric signature `(+,-,-,-)`; visible Weyl spinors are
complex two-component objects `psi : Fin 2 -> C`; the bispinor of a null edge
is the rank-one Hermitian matrix `psi psi^dagger`; mass squared is the `2 x 2`
complex determinant of the summed bispinor. Formulas are plain ASCII to match
repository text hygiene; conversion to LaTeX is a later step.

---

## Abstract

We give, and formally verify, a precise finite answer to one clean version of
an old question: how can invariant mass arise from massless, lightlike
motion?

The core result is stated first in interpretation-free form, because that is
what the proof kernel checked. Let `psi_1, ..., psi_n` be complex two-component
vectors and let `P = sum_i psi_i psi_i^dagger` be the sum of their rank-one
Hermitian squares. Then, exactly,

```text
det( sum_i psi_i psi_i^dagger ) = sum_{i<j} | psi_i wedge psi_j |^2 ,
```

where `psi_i wedge psi_j = (psi_i)_0 (psi_j)_1 - (psi_i)_1 (psi_j)_0` is the
`2 x 2` Pluecker bracket. The right-hand side is manifestly real and
nonnegative, and it vanishes if and only if all the vectors are projectively
collinear (every one a scalar multiple of a common direction). Every step is
checked by the Lean 4 proof kernel. Grade: `M [comp]` - the ingredients are
classical (a Cauchy-Binet-type identity and spinor bookkeeping); the finite
`n`-bundle formulation, the exact massless criterion, and the machine-checked
packaging are the contribution.

The physics reading enters through the standard soldering of four-momenta to
Hermitian `2 x 2` matrices, under which a rank-one bispinor is a
future-pointing null momentum and `det P = m^2`. Read this way, the identity
says: a system assembled from lightlike constituents has invariant mass equal
to the total pairwise disagreement of their null directions, and is massless
exactly when they all point one way. Because a timelike `P` admits many null
decompositions, we state the invariance carefully: **mass is the
decomposition-independent invariant `det P`; the pairwise-spread expression is
its evaluation in any decomposition gauge, and for the minimal two-edge split
the gauge freedom is precisely the massive little group SU(2)**. Equivalently,
on the celestial sphere, energy is the monopole and momentum the dipole of a
weighted set of light rays, and mass is the deficit by which the dipole fails
to saturate the monopole, `m^2 = (E^2 - |C|^2)/4`.

The contribution is threefold. (i) A clean, fully finite, machine-checked
theorem identifying invariant mass with a geometric quantity - the
disagreement in direction among lightlike constituents - together with an
exact massless criterion and covariance/twistor/Dirac-square-root wrappers
whose status is tracked explicitly. (ii) The corrected conceptual statement:
rest mass, in this finite kinematic setting, is the orbit invariant of trapped,
mutually disagreeing lightlike motion. (iii) A layered status map locating
this theorem inside an origin-of-mass program: the kinematic layer (this
paper) is closed; a chirality-substrate layer (lattice Ginsparg-Wilson
release and a kernel-checked chiral-index calculus, now including the
index-forced zero-mode vanishing theorem) exists as program-internal
mathematics; the minimal (1+1D) dynamical/coupling bridge is now itself a
kernel-checked theorem - the chirality-flip amplitude IS the Pluecker wedge -
with the general legality layer posed; and the mass-value layer remains open,
with exactly one live pre-registered relation gate and honest bedrock bins
for the rest. We separate the theorem from everything downstream of it
throughout.

---

# Part I. How mass can come from lightlike motion

*(Intended to be read by a curious high-school student. No formulas are needed
to follow it; the equations return in Part II. Nothing in Part I is
load-bearing for the theorem: it is the standard physics story - trapped
light, chirality, the Higgs - told plainly, plus one labeled research
hypothesis.)*

## A question that sounds silly until you try to answer it

Everyone knows what mass is. It is how much *stuff* there is. A bowling ball
has more of it than a tennis ball; that is why the bowling ball is harder to
throw and harder to stop. Step on a scale and you read your mass (dressed up
as weight). Mass feels like the most basic, most obvious property a thing can
have.

So here is a question that sounds almost too simple: *what is the mass made
of?* If you cut your body into smaller and smaller pieces - organs, cells,
molecules, atoms, and finally the protons and neutrons in the nuclei - where,
exactly, does the mass live? Most people guess that mass is just added up from
the masses of the little parts, all the way down, like weighing a bag of sand
by weighing each grain. That guess is wrong, and the way it is wrong is the
most beautiful fact in physics.

## Light has no mass - and that is the clue, not the problem

Start with the most familiar thing in the universe that has *zero* mass:
light. A particle of light, a photon, weighs nothing. You can never put a
photon on a scale, because you can never make it sit still. Light always moves
at exactly the speed of light, `c`, no matter who is looking or how fast they
chase it. There is no "point of view" in which a photon is at rest. That is
what it means to be massless: to be forever moving at the speed limit of the
universe.

Physicists call any motion of this kind **lightlike** or **null**. Photons are
the everyday example, but the mathematics below is about lightlike momentum in
general, with photons as the familiar example.

The research program this paper belongs to adopts, as its organizing
hypothesis, that lightlike motion is the elementary visible building block:
look closely enough, and every individual visible piece is massless; look at a
whole bundle of pieces moving in several directions at once, and a massive
object can appear. That hypothesis motivates the theorem below but is not
needed for it - the theorem is a fact of finite linear algebra either way.

A massive thing is the opposite of light. A bowling ball *can* sit still.
There is a point of view - yours, when you hold it - in which it just sits
there, going nowhere. Having mass means having a frame in which you are at
rest. Being massless means never having one.

So mass and "having a rest frame" are the same idea. Keep that thought; it is
the whole key.

## Two beams of light can weigh something

Now the trick. Take *two* photons. A single photon has no rest frame: it races
off at `c` and you can never catch it. But suppose the two photons fly in
*opposite* directions, one going left, one going right, with equal energy. As
a *pair*, which way are they going? Neither. Their motions cancel. The pair,
taken as a whole, is going nowhere.

And "going nowhere" was exactly our definition of having a rest frame - of
having mass. The two-photon system has a rest frame even though neither photon
does. So the pair has mass. Two massless things, put together, make something
massive. The mass belongs to the pair, to the fact that the two photons
*disagreed about which way to go.*

This is real and measurable. If you trapped two such photons in a perfectly
mirrored box, the box would be measurably heavier than an empty box, by
exactly the energy of the light inside (divided by `c` squared, via
`E = m c^2`). The trapped light has weight as a coupled, disagreeing system.
Mass, here, is bottled-up, churning, self-cancelling motion.

So we can already state the punchline in plain words:

> **Mass is what you get when lightlike motion is trapped and points in more
> than one direction at once. The more the directions disagree, the more mass
> there is. Each fine-grained piece can remain massless while the whole bundle
> becomes massive. If everything points the same way, the mass is zero.**

## This is where *your* weight actually comes from

The two-photon box is the simple version of a pattern that appears throughout
ordinary matter.

Your body's mass lives almost entirely in the protons and neutrons of your
atomic nuclei. Each proton is made of three small quarks held together by the
strong force, which is carried by particles called gluons. Now the surprise:
if you add up the masses of the three quarks inside a proton, you get only
about one to two percent of the proton's mass. The gluons, like photons, are
massless. So roughly *ninety-five percent of the proton's mass - and therefore
about ninety-five percent of yours - is carried by motion and field energy.*
It is the energy of nearly massless quarks moving almost at the speed of
light, and of massless gluons, all trapped inside the proton, all pulling and
racing in different directions at once. The physicist Frank Wilczek named this
"mass without mass."

So when you step on a scale, almost everything it reads is trapped,
disagreeing, light-speed motion - the very same effect as the two-photon box,
just bound up by the strong force instead of mirrors. Mass is mostly
*confined, restless lightlike motion*.

## But what about the rest? The Higgs field

That trapped-light story explains almost all of the mass of ordinary matter,
but not quite all of it, and it does not by itself explain the electron at
all. The electron is not made of smaller pieces you could trap in a box; as
far as anyone has ever measured, it is elementary, a single point. Yet it has
a mass. And the tiny intrinsic masses of the quarks - the few percent the
strong force did not account for - are elementary in the same way. Where do
*those* masses come from? This is the part of the story the Higgs field tells,
and remarkably, it turns out to be the same trick once more.

Start again from the rule that anything massless must travel at the speed of
light. A spinning massless particle has one extra feature: its spin is locked
to its direction of motion. It is either *left-handed* (spinning like a
left-handed screw as it goes) or *right-handed*. At the speed of light this
handedness is absolute - everyone agrees on it, no matter how they are moving -
because no one can ever overtake the particle and look at it from the other
side. So a massless electron would really be two separate things that never
mix: a "lefty" that races forever at `c`, and a "righty" that does the same.

Here is the key idea, and it is the idea from earlier in this paper wearing a
new costume. *Mass is what makes the lefty and the righty turn into each
other.* A massive electron is one that constantly flips: lefty, righty, lefty,
righty, as it travels. And anything that keeps flipping cannot move at the
speed of light - because at light speed the handedness was frozen, with no way
to change. So the flipping forces the electron below light speed, which means
it now has a frame in which it sits still, which, as we said at the very
start, is exactly what having mass means. The electron is, deep down, two
light-speed motions - a lefty and a righty - stitched together so tightly that
it zig-zags between them instead of going straight. Its mass is the price of
that zig-zag.

What does the stitching? An invisible field that fills all of space, even
where there is nothing else: the Higgs field. The strange part is why it is
switched on in empty space at all. Most fields are quietest - lowest energy -
when they are set to zero everywhere. The Higgs field is the opposite: its
lowest-energy state is *not* zero. A good picture is a pencil balanced
perfectly on its tip. Balanced, it is symmetric - no direction is special -
but that position is a hilltop, and the slightest nudge makes it topple and
point some particular way. The early universe was like that pencil. The Higgs
field "fell" off its symmetric peak and settled into a steady, nonzero value
that now fills every cubic centimeter of space. Empty space is not empty; it
is soaked in a frozen Higgs value.

That frozen background is the stitching. Each time the racing lefty electron
brushes against it, it is turned into a righty, and then back - the relentless
zig-zag that is the electron's mass. A particle that interacts strongly with
the Higgs background flips often and comes out heavy; one that barely
interacts flips rarely and stays light; one that ignores it completely, like
the photon, never flips and stays massless, forever at `c`.

> **An elementary particle's mass is how strongly it is forced to flip its
> handedness against the ever-present Higgs field. No flipping, no mass - just
> a massless thing that flies at light speed forever. The Higgs supplies the
> flips; the flips are the mass.**

The Higgs does one more famous job, and it shows the same pattern at the level
of forces. Forces are carried by particles: electricity and magnetism by the
massless photon, and the *weak* force - the one behind certain kinds of
radioactivity and behind the reactions that let the Sun shine - by two heavy
particles called the W and the Z. "Heavy" is an understatement: the W and Z
weigh about eighty to ninety times as much as a proton. That weight has a
dramatic consequence. A force carried by a massless particle, like the photon,
can reach clear across the universe, which is why you can see light from
distant stars. A force carried by very heavy particles can only reach across a
tiny distance - here, far smaller than an atomic nucleus - which is why the
weak force is so feeble and so short-ranged, and why radioactive decay is
usually so slow.

Where did the W and Z get all that mass? From the same frozen Higgs field. In
the early, symmetric universe the photon, the W, and the Z were a single
family of massless, light-speed force-carriers. When the Higgs field toppled
off its peak, it weighed down the W and the Z - the universe's frozen field
refusing to let them travel freely at `c`, the very same way it refuses to let
the electron go straight - while leaving one particular combination, the
photon, completely untouched. That is why, in the universe we actually live
in, light stays massless and electromagnetism reaches forever, while the weak
force is heavy and hides inside the nucleus.

## Neutrinos: almost light, but not quite

Neutrinos are the most delicate test of this story. For a long time physicists
thought they might be exactly massless. They interact only through the weak
force, and the weak force sees them almost entirely as left-handed particles.
That is very close to the cleanest possible lightlike picture: one handedness,
one direction of motion, racing almost exactly at the speed of light.

But neutrinos oscillate. They change flavor as they travel, and that can
happen only if at least two of the neutrino mass states have nonzero mass.
Direct laboratory measurements still have not weighed them exactly; KATRIN's
current model-independent bound is that the effective electron-neutrino mass
is below about `0.45 eV` at 90 percent confidence, more than a million times
lighter than the electron. Cosmology gives even tighter but more
model-dependent constraints on the sum of the neutrino masses.

In the null-edge language, a massless neutrino would be a nearly pure
left-handed null mode. A massive neutrino is almost that, but with a tiny
coupling to something the weak detector does not directly see: perhaps a
right-handed sterile partner in a Dirac-mass story, or a Majorana mass
mechanism in which the neutrino is related to its own antiparticle. Either
way, the neutrino is a beautiful edge case: it is almost a perfect lightlike
particle, with mass showing up as a tiny impurity or hidden-sector coupling.

One encouraging note from the broader program, stated at its honest strength:
if the right-handed partner exists, consistency arguments push its own mass to
the enormous energies where the three forces would unify, and the seesaw
formula then makes the ordinary neutrinos light in *just about the observed
window* - a successful order-of-magnitude relation, inherited from standard
grand-unification physics rather than invented here, and a relation rather
than a computed value. This paper does not solve the neutrino problem. It does
not decide whether neutrinos are Dirac or Majorana particles, explain their
mixing angles, determine their mass ordering, or predict the absolute mass
scale. What it does provide is the right kind of finite language for the
question: when a visible weak channel sees something almost null, what hidden
chirality or internal bookkeeping would make the visible state just impure
enough to have mass?

So every kind of mass in this paper is one idea wearing different clothes. The
proton: many lightlike pieces trapped by the strong force, all pointing
different ways. The electron: a single lightlike lefty and righty, stitched
into a zig-zag by the Higgs field. The W and Z: force-carriers the frozen
Higgs field will not let travel at light speed. In every case, mass is
lightlike motion that something prevents from going perfectly straight - and
the theorem at the heart of this paper makes the kinematic core of that
statement exact: lightlike pieces whose directions disagree carry mass, equal
to the disagreement. (Making the electron's left-right zig-zag precise in this
language is the subject of a companion paper in this program, P2, on the
"Dirac square root" of the mass; the literal zig-zag of light has its own
finite model, the checkerboard of P4.)

Two honest cautions before we leave the words behind. First, the Higgs
explains *that* elementary particles have intrinsic mass, and *why* some
force-carriers are heavy while light is not, but it does not explain *why each
mass has the size it does*. The electron, the quarks, and the rest differ from
one another by factors of hundreds of thousands, and those numbers are
measured and put into the theory by hand, not derived. Our theorem does not
fix them either; the broader program keeps an explicit scorecard of which of
those numbers might ever be derivable and which are, so far, brute facts, and
it is investigating exactly one forty-year-old empirical relation among the
electron, muon, and tau masses (the Koide relation) under pre-registered rules
- but nothing in this paper computes a mass value. Second, the pictures here -
handedness flipping, a field freezing across the sky - are honest cartoons of
mathematics that is genuinely about chirality and broken symmetry. They are
meant to convey the shape of the idea, not to replace the equations. Supplying
the equations is what the rest of this program is for.

## Our contribution: making "disagreeing light" exact

The story above has been told before, in words, and pieces of the mathematics
are familiar in relativity, spinor-helicity theory, and twistor theory. What
we add here is a clean, finite, *checkable* version for a bundle of lightlike
pieces: a single equation that says precisely how much mass the bundle has
from how much its directions disagree, with a proof so explicit that a
computer can verify every step.

That is what this paper provides. We describe each lightlike microscopic piece
by the most economical bookkeeping physics knows for "a ray of light-speed
motion with a direction and an energy": a *null spinor*. We add up the pieces.
And we prove, with the Lean proof assistant checking every line, that the mass
squared of the whole bundle is exactly the sum, over every pair of pieces, of
how much that pair disagrees in direction. The disagreement of a pair is
measured by an "area" between their two directions - the squared Pluecker
bracket. No disagreement, no area, no mass. Lots of disagreement, lots of
mass.

We also prove the sharp boundary case: the mass is *exactly* zero if and only
if every piece points the same way. One single ray, or many perfectly aligned
rays, stays massless, just like a single photon or a coherent laser beam. The
instant the directions fan out, mass switches on.

One more piece of honesty, which Part II makes precise: a massive bundle can
be cut into lightlike pieces in many different ways, so the pieces themselves
should not be reified. What is real is the whole - its mass is the same no
matter how you cut it - and the theorem holds for *every* cut. The cutting
freedom is not a defect; for the minimal two-piece cut it is exactly the spin
freedom a massive particle is known to have.

## A picture you can hold in your head

Imagine the night sky as a sphere, and put a little arrow on the sphere for
each lightlike piece, pointing toward where that piece is heading, with a
length set by its energy. Two numbers summarize the whole bundle:

- **The total energy** is just how much arrow there is altogether - add up all
  the lengths. (Think of it as the "monopole": the overall amount.)
- **The total momentum** is the *single arrow you get by laying all the little
  arrows tip-to-tail* - the vector sum. (Think of it as the "dipole": the net
  lopsidedness, which way the bundle leans as a whole.)

If every arrow points the same way, they stack up into one long arrow: the net
momentum is as big as the total energy can possibly make it. That is the
massless case - a beam. But if the arrows fan out around the sphere, they
partly cancel when you lay them tip-to-tail, so the net arrow is *shorter*
than the total amount of arrow. That shortfall - the gap between how much
momentum the energy could have carried and how much it actually carries - *is
the mass.* Spread the directions out and the gap grows; the bundle gets
heavier. Pull them together and the gap closes; the bundle approaches a
massless beam.

That is the entire idea of where mass comes from, in one image: **mass is the
deficit between the energy a bundle of light carries and the momentum it
manages to point in one direction.** It is the price of disagreement.

## Claim boundary

We want to be honest about the size of the claim, because the subject invites
overreach. What we have is a finite, exact, machine-checked piece of *geometry
and kinematics*: given a bundle of null pieces, here is its mass, here is
exactly when it is zero, and here is why both are true. This is real, and it
makes the old "trapped light" story precise in a form a proof kernel will sign
off on.

The broader research program adds a stronger organizing hypothesis: visible
microscopic histories are made from null edges, and massive motion is the
coarse-grained behavior of coupled null-edge bundles. This paper proves the
finite mass formula behind that hypothesis. Later work must supply the
dynamics: the actual masses of the electron, quarks, and other particles; the
strong force; the Higgs/Yukawa transition amplitudes; and the rules by which
lightlike pieces move and bind over time. Part II, section 16 gives the
current status of each of those pieces, with grades.

---

# Part II. The finite Pluecker-mass theorem

This part states the formal content precisely and points to the exact
kernel-checked Lean declarations. Every named theorem below compiles under the
pinned toolchain `leanprover/lean4:v4.28.0` with no placeholders, except where
a declaration is explicitly marked *draft (kernel-clean)* or *artifact*.

Per the program's interpretation-free statement rule (Round 8), sections 1-5
are pure finite linear algebra about complex two-component vectors; the words
"null," "momentum," and "mass" acquire their physical meaning only through the
soldering convention recorded in section 1 and the covariance statement of
section 8. Nothing in the proofs depends on the physics reading.

## 1. Setup and conventions

A **visible Weyl spinor** is a complex two-component vector
`psi : Fin 2 -> C` (`CSpinor`). To a single such vector we attach its rank-one
Hermitian square, the **bispinor**

```text
rankOneHermitian psi := psi psi^dagger  =  vecMulVec psi (star psi),
```

a `2 x 2` complex Hermitian matrix. In the standard soldering
`p_{A A'} = p_0 I + p . sigma` of a four-momentum to a Hermitian `2 x 2`
matrix, `psi psi^dagger` is the bispinor of a future-pointing **null**
momentum: its determinant is `p_0^2 - |p|^2 = 0`. This is the formal version
of "a single lightlike piece is massless." The soldering dictionary itself -
`det(minkHerm p) = p_0^2 - p_1^2 - p_2^2 - p_3^2` as an identity of real
polynomials, with its positivity/future-cone spectral conditions - is now also
kernel-checked in-repo (`PhysicsSM.Draft.NullEdge.GateI1.Core`:
`i1_1_soldering_det`, `det_minkHerm_eq_minkowskiSq`,
`i1_2_spectralMinus_nonneg_iff_futureCone`; kernel-clean draft), so the
physics reading of `det` as the mostly-plus-signature invariant mass square
rests on a checked identity rather than a citation.

The **spinor Pluecker bracket** (spinor wedge) of two spinors is the
antisymmetric contraction

```text
spinorWedge psi phi := psi_0 phi_1 - psi_1 phi_0  in  Lambda^2(C^2) ~= C.
```

Convention warning (recorded in the Lean docstrings): the Pluecker bracket
lives in the antisymmetric square `Lambda^2 S ~= C`, the singlet, *not* in the
symmetric square `Sym^2 S` that carries field-strength / curvature data. Mass
is a `Lambda^2` invariant.

We write the complex squared modulus as `complexAbsSq z := z * conj z`, which
equals `(Complex.normSq z : C)` and is used so that determinants and squared
brackets can be compared as complex numbers before reality is extracted.

Anchor: module `PhysicsSM.Spinor.PluckerMass`, definitions `CSpinor`,
`rankOneHermitian`, `spinorWedge`, `complexAbsSq`. Grade of sections 2-5:
`M [comp]`, trusted namespace.

## 2. A single null edge is massless

```text
theorem det_rankOneHermitian_eq_zero (psi : CSpinor) :
    (rankOneHermitian psi).det = 0
```

The determinant of one rank-one bispinor vanishes identically: one ray of
light-speed motion has no rest mass.

## 3. Two edges: mass is the squared Pluecker bracket

Define the two-edge visible momentum `twoEdgeMomentum psi phi :=
rankOneHermitian psi + rankOneHermitian phi`. Then:

```text
theorem two_edge_plucker_mass_identity (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = complexAbsSq (spinorWedge psi phi)
```

The mass squared of a two-edge bundle is exactly the squared modulus of the
Pluecker bracket of the two null directions - the squared "area" between them.
It is zero exactly when the bracket vanishes:

```text
theorem two_edge_mass_zero_iff_wedge_zero (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = 0 <-> spinorWedge psi phi = 0
```

and (for a nonzero base direction) a vanishing bracket is projective
collinearity:

```text
theorem spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
    (psi phi : CSpinor) (hpsi : psi 0 != 0 \/ psi 1 != 0) :
    spinorWedge psi phi = 0 <-> exists c : C, phi = c . psi
```

This is the two-photon box, made exact: two null momenta combine to a massive
system precisely when they are not collinear.

## 4. The general finite bundle: mass is total pairwise spread

For a finite family `psi : Fin n -> CSpinor`, the visible momentum is
`finBundleMomentum psi := sum_i rankOneHermitian (psi i)` and the total
pairwise Pluecker spread is `finPairwisePluckerMass psi := sum_{i<j}
complexAbsSq (spinorWedge (psi i) (psi j))` (summed over the ordered-pair
index set `finPairIndexSet n = { (i,j) : i < j }`). The keystone theorem:

```text
theorem fin_bundle_plucker_mass_identity {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi
```

i.e.

```text
det( sum_i psi_i psi_i^dagger ) = sum_{i<j} | psi_i wedge psi_j |^2 .
```

The proof is a Cauchy-Binet / off-diagonal-folding argument: expanding the
`2 x 2` determinant of the summed rank-one matrices produces a double sum
whose diagonal cancels and whose `(i,j) + (j,i)` off-diagonal terms assemble
into the squared bracket. The folding lemma `sum_pairs_offdiag` carries this
step.

## 5. Reality, nonnegativity, and the exact massless criterion

The right-hand side is a sum of squared moduli, hence real and nonnegative.
The Lean surface records this explicitly:

```text
theorem fin_bundle_det_im_eq_zero : ((finBundleMomentum psi).det).im = 0
theorem fin_bundle_det_re_nonneg  : 0 <= ((finBundleMomentum psi).det).re
theorem fin_bundle_det_eq_ofReal_nonneg :
    exists r : R, 0 <= r /\ (finBundleMomentum psi).det = (r : C)
```

so the determinant mass is a genuine nonnegative real `m^2 >= 0`. The exact
massless criterion, for a bundle with a chosen nonzero base spinor:

```text
theorem fin_bundle_mass_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 != 0 \/ psi base 1 != 0) :
    (finBundleMomentum psi).det = 0 <->
      exists c : Fin n -> C, forall i, psi i = c i . psi base
```

Mass vanishes if and only if every null direction is a scalar multiple of one
common direction - a single beam. Any projective spread switches mass on. This
is the precise form of the Part I slogan.

## 6. Mass is an orbit invariant, not a property of a decomposition

This section implements the Round 8 correction (Attack 1.4) and governs how
every downstream statement in this paper and the program may be phrased.

A timelike `P` admits infinitely many null decompositions - any number of
edges `n >= 2`, any energy split. A quantity attached to one particular
decomposition would therefore be gauge data, not physics. The invariant
statement has three parts:

1. **The invariant.** `m^2 = det P` depends only on `P`, not on any
   decomposition. This is a triviality of the definition, and it is the only
   quantity this paper calls "mass."
2. **The identity holds in every gauge.** For *every* finite decomposition
   `P = sum_i psi_i psi_i^dagger`, the pairwise-spread expression evaluates to
   the same `det P` (section 4). So "mass = total pairwise disagreement" is a
   statement about each decomposition gauge separately, with a
   gauge-independent value - exactly like writing a gauge-invariant quantity
   in a particular gauge.
3. **The minimal gauge freedom is the little group.** For the minimal split
   `n = 2` of a timelike `P`, the residual freedom in choosing the two null
   spinors (beyond the per-edge phase, which the bispinor never sees) is
   precisely the massive little group `SU(2)` - the same index structure that
   massive spinor-helicity variables carry `[import: Arkani-Hamed-Huang-Huang,
   section 12]`. Mass is the orbit invariant of this null-splitting gauge
   orbit; the "concurrence" of the pair (section 12) is the value of that
   invariant computed in any gauge.

Corrected slogan, which supersedes earlier program phrasing:

> **Mass is the orbit invariant of the null-splitting gauge; "concurrence" is
> its value in any gauge.**

For `n > 2` the identity remains exactly true, but the entanglement-flavored
language must not pretend the decomposition is physical: different bundles
realizing the same `P` are purification / gauge freedom unless a dynamical
model distinguishes them. The program's failure-mode register names this
**F-RE (reification of formal structures)**, and this paper observes it in two
places: (i) decompositions are never treated as ontic; (ii) the normalized
matrix `rho = P / Tr(P)` is used only as a frame-conditioned *proxy* whose
mixedness encodes the ratio `m/E` after an observer convention is fixed - it
is not claimed to be the reduced density matrix of a physical system until a
dynamical model supplies one.

Two Lean-facing notes. The `SL(2,C)` covariance of `det P` (section 8) is the
frame half of the orbit-invariance statement and is kernel-clean draft. The
`SU(2)`-orbit transitivity statement for `n = 2` (that the little group acts
transitively on minimal decompositions of a fixed timelike `P`) is standard
`[import]` and is registered as a named formalization target
(`two_null_decompositions_little_group_orbit`), together with the
observer-selected canonical resolution: fixing a unit timelike observer `u`
singles out the two null directions

```text
k_+ = ((E_u + s)/2)(u + n),   k_- = ((E_u - s)/2)(u - n),
E_u = p.u,  s = sqrt(E_u^2 - m^2),  n = (p - E_u u)/s,
```

with `k_+ + k_- = p` and `k_+^2 = k_-^2 = 0` - a clean gauge-fixing lemma pair
(`observer_twoNullDecomposition_sum_eq_momentum`,
`observer_twoNullDecomposition_each_null`) that makes the two-null picture
canonical *after* an observer is chosen, and only then.

## 7. Celestial moment form: energy monopole, momentum dipole, mass deficit

Normalizing each spinor to a unit celestial (Bloch) direction `n_i` on the
two-sphere with visible energy weight `w_i`, the same scalar becomes a
monopole/dipole statement. With total energy `E = sum_i w_i` and closure
(momentum) vector `C = sum_i w_i n_i`, the standalone artifact
`NullEdgeSpinorNetworkClosure.Finite` proves:

```text
theorem pluckerMass_eq_energy_sq_sub_closureDefect_sq
    (w : Fin n -> R) (u : Fin n -> Vec3) (hunit : forall i, normSq (u i) = 1) :
    pairwiseAngularMass w u = momentMassSq w u
```

where `pairwiseAngularMass w u = sum_{i<j} w_i w_j (1 - n_i . n_j) / 2` and
`momentMassSq w u = (E^2 - |C|^2) / 4`. So

```text
m^2 = ( E^2 - |C|^2 ) / 4 :
```

mass is exactly the deficit by which the momentum dipole `|C|` falls short of
the energy monopole `E`. Aligned directions saturate `|C| = E` and give
`m = 0`; a fanned-out bundle has `|C| < E` and is massive.

Guardrail (kernel-checked, and important for the downstream P9 program): the
closed case `C = 0` does **not** mean "no source." It is the *rest frame*:

```text
theorem closed_spinorFan_is_restFrame
    (hunit : ...) (hclosed : closureVector w u = 0) :
    pairwiseAngularMass w u = energy w ^ 2 / 4
```

A closed visible fan has the maximal rest energy `E^2/4`, not zero mass.
Visible momentum closure is a kinematic rest-frame condition, never to be
conflated with source invisibility.

*Status:* this artifact is kernel-clean but lives in the standalone Aristotle
package, not yet in the trusted `PhysicsSM` namespace. The manuscript should
either promote it before submission or cite it as an appendix result.
(Tracked in the publication plan's "Remaining" note for P1.)

## 8. Lorentz covariance: SL(2,C) invariance of the determinant mass

Mass must be frame-independent. Under a spinor change of frame
`psi |-> A psi` with `A in SL(2,C)` (`det A = 1`), the determinant mass is
invariant:

```text
theorem finBundleMomentum_det_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) C) (hA : A.det = 1)
    (psi : Fin n -> CSpinor) :
    (finBundleMomentum (fun i => spinorAction A (psi i))).det
      = (finBundleMomentum psi).det
```

Since `SL(2,C)` is the double cover of the proper orthochronous Lorentz group,
this is the statement that the bundle mass is a Lorentz invariant of the
visible null data - the frame half of the orbit-invariance discipline of
section 6. *Status:* draft (kernel-clean) in
`PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`; a convention/semantic review
is required before promotion to the trusted surface.

The manuscript keeps this unnormalized invariant strictly separate from the
normalized reduced-state language. If

```text
rho_vis = P / Tr(P),
```

then `det(rho_vis) = det(P) / Tr(P)^2` measures `(m/E)^2` after choosing a
timelike observer or lab-energy convention; the observer-covariant form is
`rho_{p|u} = U^{-1/2} P U^{-1/2} / Tr(U^{-1} P)` with `U = u.sigma`, giving
`2 sqrt(det rho_{p|u}) = m/(p.u)`. These are frame-relative proxies (see the
F-RE note in section 6), useful for proper-time-rate and concurrence language.
They are not the invariant mass. The invariant statement is `det(P) = m^2`.

## 9. Twistor-chart matching

In the spinor chart `Z = (omega^A, pi_{A'})` - with only the `pi` spinor
entering the mass - the same identity reads as a two-twistor / multi-twistor
mass. From the trusted module `PhysicsSM.Spinor.TwistorPluckerMass`:

```text
theorem two_twistor_mass_invariant_eq_plucker (Z W : SpinorChartTwistor) :
    twoTwistorMassInvariant Z W = complexAbsSq (spinorWedge Z.pi W.pi)
theorem multi_twistor_momentum_det_eq_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    (multiTwistorMomentum Z).det = multiTwistorPairwiseMass Z
```

The module also records both normalization conventions explicitly (determinant
vs. trace-pairing mass, differing by the factor `2`:
`twoTwistorMassSqDetConvention_eq_massInvariant` vs.
`twoTwistorMassSqTraceConvention_eq_two_massInvariant`) so no silent
factor-of-two drift can occur. Scope: this is the finite spinor chart only.
Projective twistor space, twistor cohomology, the Penrose transform, and
incidence geometry are explicitly out of scope.

## 10. The first-order (Dirac) square root - bridge to P2

The static chiral Dirac slash of the bundle momentum squares back to the same
mass scalar:

```text
theorem chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass : ...
```

(`PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`, draft/kernel-clean). This
is the square root of the *static* mass and is the natural seam to paper P2
("A finite Dirac square root of the Pluecker mass"). It is *not* yet a
dynamical propagation theorem and should be flagged as a forward pointer, not
a result of this paper.

The dynamical target it points at is the discrete null-step transfer operator
`U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x)`, whose quasienergy obeys
`cos(omega a) = cos(k a) cos(mu a)` and whose chirality coherence
`C_z = |sin(mu a)| / |sin(omega a)|` tends to `mu / sqrt(k^2 + mu^2) = m/E` in
the continuum limit `[import: standard quantum-walk / checkerboard
dispersion]`. That model realizes, in one finite operator, the Part I claims
that luminal conditional shifts plus a chirality-flip amplitude produce
massive Dirac dispersion with `m/E` as the coherence readout; its
formalization is P2/P4 scope.

## 11. The chirality substrate: program anchors for the zig-zag story

*(Context section. Grades `M [orig-packaging]` for the Lean content named;
nothing here is a claim of this paper, and per the interpretation-free rule
the anchors are stated as lattice operator theory, with the null-edge reading
only as motivation. Per the halo rule: what was verified is exactly what is
listed, no more.)*

Part I's electron story - mass as a legal stitching of a left mover to a right
mover - presupposes that "left" and "right" are exactly defined and separately
conserved in the massless theory, so that a mass term is precisely the legal
operator that couples them. On a finite or discrete substrate that
presupposition is famously fragile: the Nielsen-Ninomiya obstruction forces
naive lattice fermions to come in doubled chiral pairs, destroying exact
chirality `[import]`. The standard escape is the Ginsparg-Wilson (GW)
relation, under which an exact, deformed chiral symmetry survives at finite
spacing `[import]`.

Since the previous draft of this manuscript, the program has kernel-checked
this substrate layer at the free/regulator level. Stated interpretation-free:

- **Free GW release (Gate C1).** For the tetrahedral (rank-4) free lattice
  kernel: a gapped Hermitian symbol and operator; an overlap operator
  satisfying the GW relation `gamma5 D + D gamma5 = D gamma5 D` at symbol and
  operator level; and the corresponding exact Weyl projectors
  (`PhysicsSM/Draft/NullEdge/GateC1/`, e.g. `TetraOperatorOverlapGW`,
  `TetraOperatorWeylProjectors`). Kernel-checked draft Lean.
- **Chiral index calculus (Gate C2).** Above any chirality involution
  `gamma5` and sign involution `eps`: the lattice chiral index
  `overlapIndex = (1/2)(Tr gamma5 - Tr eps)` is an integer
  (`overlapIndex_isInteger`); for a gapped Hermitian operator `H` the overlap
  sign is characterized by a finite functional-calculus-free certificate with
  existence, uniqueness, and automatic self-adjointness
  (`certifiedSign_exists`, `certifiedSign_unique`,
  `signCertificate_isHermitian`); the index equals half the signature
  difference and reduces to eigenvalue-sign counts of `H`
  (`overlapIndex_eq_half_signature`, `epsCFC_trace_eq_inertia`,
  `gaugeOverlap_index_eigenvalue_count_form`); the index is invariant under
  unitary conjugation (`overlapIndex_conj`); and there is an explicit
  gauge-flux witness - a pi-flux triangle with gauge-invariant holonomy whose
  certified-sign index is nonzero and shifts by `-2` under flux insertion
  (`overlapIndex_flux`, `flux_shifts_index`). Kernel-checked draft Lean; one
  aggregate build command covers the layer
  (`lake build PhysicsSM.Draft.NullEdge.GateC2`). Summary document:
  `Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md`.

Why this belongs in an origin-of-mass paper's orbit, stated carefully: in the
GW framework masslessness is an exactly protected chirality, the chiral index
is its integer bookkeeping, and a mass term is precisely a legal breaking of
that protection. The free benchmark (index `0`) and the flux witness
(index `!= 0`) verify the bookkeeping in both regimes. The finite **vanishing
statement** on this axis is now also kernel-checked
(`PhysicsSM/Draft/NullEdge/GateC2/OverlapIndexVanishing.lean`, harvested from
Aristotle job 2b9ab4ce and rewired onto the repo index): an invertible
("gapped", mass-admitting) overlap operator forces index `0`
(`overlapIndex_eq_zero_of_isUnit_dov`), so a nonzero chiral index forces an
exact zero mode (`exists_zero_mode_of_overlapIndex_ne_zero`) - and the
pi-flux witness, whose index is `-1`, therefore carries a genuine exact zero
mode (`flux_witness_has_zero_mode`). Hermiticity turned out to be unnecessary
(the proof is purely algebraic: `gamma5 - eps` and `gamma5 + eps`
anticommute, and invertibility of the overlap operator forces the latter
invertible, giving `Tr(gamma5 - eps) = 0`), so the ported statements are
strictly more general than the ones originally posed. This formalizes
"topological protection of masslessness" and completes the substrate half of
the zig-zag story at the free level.

## 12. Relation to prior work

- **Massive spinor-helicity.** Arkani-Hamed, Huang and Huang (`1709.04891`;
  JHEP 11 (2021) 070, DOI `10.1007/JHEP11(2021)070`) write a massive momentum
  as a pair of `SU(2)`-little-group spinors. The present identity is the
  finite-bundle generalization: an arbitrary number of null edges, with mass
  as the total pairwise spread rather than a single two-spinor pairing,
  packaged as a kernel-checked theorem. The reverse move - writing one massive
  momentum as a sum of two null momenta - is textbook spinor-helicity
  bookkeeping, and section 6's little-group orbit statement is exactly the AHH
  index structure; the contribution here is the `n`-edge forward direction,
  its exact massless criterion, the orbit-invariant packaging, and the
  formalization.
- **Two-twistor mass models** realize a massive particle from two twistors;
  our twistor-chart section recovers exactly this as the `n = 2` case and
  then generalizes. Kim, Kim and Lee (`2102.07063`, J. Phys. A 54 (2021)
  335203, DOI `10.1088/1751-8121/ac11be`) show that the massive twistor /
  relativistic spherical-top model reproduces the AHH massive spinor-helicity
  spectrum on quantization, which is the precise sense in which the `n = 2`
  twistor chart and the bispinor mass coincide.
- **Mass/concurrence prior art and frame-dependence.** Chin and Lee,
  *Momentum bispinor, two-qubit entanglement and twistor space*
  (`arXiv:1407.2492`, arXiv preprint, no journal DOI), explicitly identify the
  two-twistor/momentum-bispinor mass with two-qubit concurrence by restricting
  the momentum to the unit-energy hyperplane - precisely the normalized-energy
  setting we keep distinct from the invariant determinant (sections 6 and 8).
  (Its second author, Sangmin Lee, is also an author of the massive-twistor
  paper `2102.07063` cited above.) Peres-Scudo-Terno (`quant-ph/0203033`,
  PRL 88, 230402, DOI `10.1103/PhysRevLett.88.230402`) and Gingrich-Adami
  (`quant-ph/0205179`, PRL 89, 270402, DOI
  `10.1103/PhysRevLett.89.270402`) are the guardrails: reduced spin or
  entanglement quantities can be frame-dependent under boosts. The novelty of
  this paper is therefore the finite null-edge bundle theorem, its
  orbit-invariant statement, and the formalized packaging - not the bare
  mass/concurrence analogy, which is prior art in the `n = 2` normalized
  setting.
- **Ginsparg-Wilson / overlap and the index.** The GW relation, the overlap
  construction, and the lattice index are standard lattice field theory
  `[import]`; section 11's contribution is only the kernel-checked finite
  packaging (free release, certificate calculus, flux witness). Specific
  source attributions for GW/overlap/index classics are part of the
  pre-submission verification sprint below.
- **Grassmannian / Pluecker geometry.** The right-hand side is a sum of
  squared `Gr(2,n)` Pluecker coordinates; the massless locus is the cone
  where all minors vanish (projective collinearity). This connects to the
  positive-Grassmannian stratification (`1212.5605`) as a
  minor-stratification angle, kept as a remark.
- **Spinor-network closure / loop gravity.** The celestial moment form is the
  Dupuis-Speziale-Tambornino closure constraint (`1201.2120`) read as a mass
  identity; `C = 0` is the moment-map / rest-frame condition.
- **"Mass without mass."** The physical anchor for Part I is the QCD origin
  of the proton mass (Wilczek): most hadron mass is the energy of nearly
  massless confined constituents. Our theorem is the clean kinematic skeleton
  of that picture, not a derivation of QCD. *(Verification debt: the precise
  Wilczek reference is still to be source-verified before submission.)*
- **The Koide relation** (referenced only in section 16's status map): the
  empirical charged-lepton relation `Q = 2/3` (Koide, 1981) predates precision
  `m_tau` data and moved onto the prediction as measurements improved; the
  program investigates it under a pre-registered gate with a mandatory
  scheme/scale clause. *(Verification debt: the original Koide citation must
  be source-verified before any use beyond this status remark.)*

The novelty claim is deliberately narrow and reviewable. The contribution is
the finite-bundle formulation, its exact massless criterion, the
orbit-invariant statement, reality/covariance/celestial/twistor wrappers, and
the machine-checked packaging that turns the "trapped light" intuition into a
theorem spine for the null-edge program. Under the program's originality
tags, the mathematics is `[comp]` (a composition of classical ingredients);
the formalization-first packaging and the massless-criterion statement are
the `[orig]` component.

## 13. Claim boundary

The program's Round 8 review reorganized all claims into two columns, and
this paper sits entirely in **Column A**: finite, discrete, substrate-safe
mathematics, all of it Lean-checked or Lean-checkable. Its physical reading
as a statement about continuum mass is **Column B**-conditional: it holds in
the regime where the soldering dictionary and Lorentz kinematics apply (grade
`T|H(soldering)` for the reading, on top of `M` for the mathematics).

What is established (kernel-checked finite linear algebra):

- the determinant/Pluecker mass identity for any finite null-spinor bundle
  (trusted);
- reality and nonnegativity of the determinant mass (trusted);
- the exact massless-iff-projectively-collinear criterion (trusted);
- the twistor-chart matching with explicit normalization conventions
  (trusted);
- the celestial monopole/dipole moment form (standalone artifact);
- `SL(2,C)` covariance (draft, kernel-clean);
- the static Dirac square root (draft, kernel-clean) as a bridge to P2;
- the soldering determinant dictionary (draft, kernel-clean, Gate I1);
- the chirality-substrate anchors of section 11 (draft, kernel-clean; program
  context, not results of this paper).

What is *stated but not yet formalized* (named targets):

- the `SU(2)`-orbit transitivity of minimal null splits and the
  observer-selected canonical resolution (section 6);
- the vanishing statement tying a nonzero chiral index to obstructed mass
  terms (section 11).

Separate work required for the full physics program (see section 16 for the
graded map):

- a continuum Dirac equation from null-edge dynamics;
- a Standard-Model mass spectrum and predicted Yukawa couplings;
- a derivation of QCD confinement, the proton mass, or the strong force;
- a neutrino-mass mechanism: Dirac versus Majorana, sterile/right-handed
  sectors, seesaw scale, PMNS mixing, mass ordering, and the absolute mass
  scale remain outside this theorem;
- a cosmological / source-visibility theorem (gated work, P9);
- a Higgs/Yukawa dynamics layer explaining which chirality flips are allowed
  and proving the no-double-counting bridge (section 16, layer 4);
- projective twistor geometry beyond the checked spinor chart.

## 14. Theorem-to-Lean map

```text
Result                                   Lean declaration                                  Status
---------------------------------------  ------------------------------------------------  ------
single null edge is massless             det_rankOneHermitian_eq_zero                      trusted
two-edge mass = squared wedge            two_edge_plucker_mass_identity                    trusted
two-edge massless iff wedge zero         two_edge_mass_zero_iff_wedge_zero                 trusted
wedge zero iff collinear                 spinorWedge_eq_zero_iff_exists_smul_..._nonzero   trusted
finite bundle mass = pairwise spread     fin_bundle_plucker_mass_identity                  trusted
determinant mass real, nonnegative       fin_bundle_det_im_eq_zero / _det_re_nonneg        trusted
massless iff common direction            fin_bundle_mass_zero_iff_common_direction         trusted
two-twistor mass = wedge                 two_twistor_mass_invariant_eq_plucker             trusted
multi-twistor mass = pairwise            multi_twistor_momentum_det_eq_pairwiseMass        trusted
celestial moment form (E^2-|C|^2)/4      pluckerMass_eq_energy_sq_sub_closureDefect_sq     artifact*
closed fan is rest frame                 closed_spinorFan_is_restFrame                     artifact*
SL(2,C) invariance of det mass           finBundleMomentum_det_sl2_invariant               draft**
Dirac slash squares to mass              chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass draft**
soldering det = Minkowski square         det_minkHerm_eq_minkowskiSq (Gate I1)             draft**
future cone spectral criterion           i1_2_spectralMinus_nonneg_iff_futureCone          draft**
GW overlap release (free, rank-4)        Gate C1 modules (TetraOperatorOverlapGW, ...)     draft** (context)
integer chiral index                     overlapIndex_isInteger (Gate C2)                  draft** (context)
certified sign exists/unique/Hermitian   certifiedSign_exists / _unique / _isHermitian     draft** (context)
index from eigenvalue-sign counts        gaugeOverlap_index_eigenvalue_count_form          draft** (context)
nonzero-flux index witness               overlapIndex_flux / flux_shifts_index             draft** (context)
gapped overlap forces index zero         overlapIndex_eq_zero_of_isUnit_dov                draft** (context)
nonzero index forces exact zero mode     exists_zero_mode_of_overlapIndex_ne_zero          draft** (context)
flux witness carries a zero mode         flux_witness_has_zero_mode                        draft** (context)
coin amplitude = wedge (1+1D bridge)     onshell_wedge_normSq_eq_coin_sq                   draft**
two-null resolution, 1+1D                twoNull_resolution / wedge_normSq_eq_det_solder   draft**
Dirac coherence = mu/E exactly           diracEigvec_chirality_coherence                   draft**
walk dispersion + exact coherence        walkStep_trace_dispersion / walkEigvec_coherence_abs  draft**
walk eigenvector (explicit)              walkStep_mulVec_eigvec / walkEigval               draft**
little-group orbit of minimal splits     two_null_decompositions_little_group_orbit        TARGET
observer two-null resolution (3+1D)      observer_twoNullDecomposition_*                   TARGET (1+1D done)

*  kernel-clean, standalone Aristotle package; promote or cite as appendix.
** kernel-clean draft in PhysicsSM.Draft.*; needs convention review to promote.
   "(context)" rows are program anchors cited for orientation, not results of
   this paper.
```

## 15. Conventions table

```text
Quantity                 Convention chosen
-----------------------  ---------------------------------------------------
metric signature         (+,-,-,-)
Weyl spinor carrier      Fin 2 -> C  (complex two-component)
null bispinor            psi psi^dagger = vecMulVec psi (star psi)
mass square              det of the 2x2 Hermitian momentum (det convention)
trace-pairing variant    2 x det  (kept as a separate explicit definition)
Pluecker bracket         psi_0 phi_1 - psi_1 phi_0, in Lambda^2 S ~= C
squared modulus          complexAbsSq z = z * conj z = (normSq z : C)
celestial normalization  unit directions n_i on S^2, weights w_i = energies
moment mass square       m^2 = (E^2 - |C|^2)/4,  E = sum w_i, C = sum w_i n_i
frame group              SL(2,C), det A = 1 (double cover of Lorentz)
decomposition gauge      null splits of fixed P; minimal split carries SU(2)
```

---

## 16. How close is this to a full origin of mass? The layered status map

This section is the honest answer to the title question, replacing the older
"what remains" list. The origin-of-mass problem decomposes into six layers.
For each: what the program has, at what grade, and what would close it. The
grades follow the claim calculus (T / T|H / M / C, originality tags), and the
chain rule applies: any composite story is only as strong as its weakest
layer.

### Layer 1 - Kinematic: what mass IS, given lightlike constituents. CLOSED.

The content of this paper. `M [comp]`, trusted for the core identity and
massless criterion; kernel-clean drafts for covariance and the soldering
dictionary; the orbit-invariant statement (section 6) makes the language
gauge-safe. Given null constituents, invariant mass is exactly the failure of
projective collinearity, is decomposition-independent, and vanishes iff the
bundle is a beam. Nothing in this layer is conjectural, and no further physics
input can change it. Remaining work is bookkeeping: promote the drafts,
formalize the two named orbit lemmas.

### Layer 2 - Dynamical: mass as the rate of chirality exchange. CLOSED at
### the 1+1D level (harvested 2026-07-03); 3+1D packaging remains.

The static half was already formalized (the chiral Dirac slash of a bundle
momentum squares to the Pluecker scalar; draft, kernel-clean). The dynamical
half is now program mathematics as well
(`PhysicsSM/Draft/NullEdge/GateI1/MassCoinBridge.lean`, Aristotle job
f983a254, all 12 statements authored in-repo and proved unchanged): the
null-step walk's dispersion `cos(omega a) = cos(ka) cos(mu a)` in trace form,
an explicit walk eigenvector, and the EXACT finite-step chirality coherence
`|sin(mu a)| / sin(omega a)` (continuum reading `m/E`) - no limits taken -
plus the Dirac-Hamiltonian statement that the on-shell eigenvector's
chirality coherence is `mu/E` exactly, matching the normalized bundle
mixedness `4 det P / (Tr P)^2`. What remains: the 3+1D generalization and the
connection into the position-space checkerboard stack (P2/P4 writing scope),
both engineering rather than research risk.

### Layer 3 - Substrate: exact chirality available to be coupled. CLOSED at
### the free/regulator level (new since the previous draft).

For the zig-zag story to be non-circular on a finite substrate, exact
handedness must exist there in the first place, despite Nielsen-Ninomiya. The
program has now kernel-checked, at the free level: the GW overlap release
with exact Weyl projectors (Gate C1); and the full finite chiral-index
calculus - integer index, certified sign with
existence/uniqueness/self-adjointness, index = signature = eigenvalue-sign
counts, unitary invariance, and an explicit nonzero-flux witness with the
correct flux response (Gate C2). Grade `M [orig-packaging]`; stated
interpretation-free per Round 8. The **vanishing statement is now also
proved** (harvested 2026-07-03, Aristotle job 2b9ab4ce,
`OverlapIndexVanishing.lean`): a gapped overlap operator forces index zero, a
nonzero index forces exact zero modes, and the pi-flux witness's index `-1`
pins a genuine zero mode - topological protection of masslessness as a finite
theorem, and (a strict bonus) with no Hermiticity hypothesis needed. What
would close the layer fully beyond the free level: (i) gauge-background
locality and the index-density (anomaly) bridge, the program's named C2
successors; (ii) eventually, interacting statements. The free layer,
including protection, is done and machine-checked in both directions: flux
drives the index, and the index obstructs the gap.

### Layer 4 - Legality: what supplies and licenses the coupling. POSED.

Standard-Model input `[import]`: a bare left-right flip is not gauge-legal;
the Yukawa/Higgs insertion is the unique legal odd operator, and after
electroweak symmetry breaking it reads as a mass term. Program addition, at
its corrected grade: the node-bootstrap result (four-point consistency plus
soft theorems) puts Yukawa-type scalar couplings on the short list of the
only consistent vertex decorations - but after the Round 8 audit this is
graded `T|FP`: a consistency condition on the continuum fixed point, not a
substrate theorem, pending the transplant gate (NB1). The layer's keystone
theorem target is the **no-double-counting bridge**: a finite channel model
in which the Higgs/Yukawa singular value and the Pluecker determinant are
the same on-shell scalar - one mass, two descriptions, never two masses. Its
MINIMAL INSTANCE is now proved (`onshell_wedge_normSq_eq_coin_sq`, harvested
2026-07-03): in the 1+1D model the chirality-flip amplitude `mu` equals the
Pluecker wedge of the canonical two-null split of the on-shell momentum,
exactly. The general finite channel version (gauge-dressed, 3+1D,
several flavors) remains the open keystone; until it is proved in that
generality, the program must not (and this paper does not) count a "Higgs
mass term" and a "Pluecker mass" as separate contributions.

### Layer 5 - Values: the actual spectrum. OPEN, with exact boundaries.

This is where honesty matters most, and the Round 7 parameter audit supplies
the boundaries. What the program can currently say about mass *values*:

- **Derived structures (Tier 0)**: charge quantization, hypercharge
  assignments, `N_c = 3`, `sin^2 theta_W = 3/8` at unification - welded by
  compactness, anomalies, and fiber algebra; these constrain the mass sector's
  arena but fix no mass.
- **Scale relations (Tier 1)**: the seesaw postdiction - with the
  right-handed-neutrino Majorana scale at the unification-forced intermediate
  scale, the light neutrino masses land in the observed `0.01-0.1 eV` window;
  one structure fixes the order of magnitude of the seven neutrino-sector
  parameters. Grade: inherited relation `[import/comp]`, genuinely owned by
  the program only through the Z_16/erasability mandate for the nu_R sector.
- **One live relation gate (Tier 2), now sharply rescoped**: the Koide
  relation
  `Q = (m_e + m_mu + m_tau) / (sqrt(m_e) + sqrt(m_mu) + sqrt(m_tau))^2 = 2/3`
  - empirically satisfied at `9 x 10^-6` relative deviation with pole masses,
  a forty-year-old external prediction that improving data moved onto. The
  gate ran its Round 8 lifecycle on 2026-07-03: the naive formulation F2.0
  ("the Koide configuration is a critical point of an invariant potential on
  `J_3`") was KILLED BY PROOF the same day it was pre-registered - a
  kernel-checked no-go
  (`PhysicsSM/Draft/NullEdge/GateF2/InvariantPotentialNogo.lean`) shows any
  critical point of any nontrivial conjugation-invariant potential has a
  repeated eigenvalue, and the three charged-lepton masses are distinct. The
  null is filed
  (`AgentTasks/nerd-gate-f2-koide-preregistration-2026-07-03.md`); the
  surviving formulations - F2.1, potentials invariant only under the
  stabilizer of the democratic direction (spurion class), and F2.0',
  directional extremality - remain grade `C` pending their own pre-registered
  freeze, still under the audit-mandated scheme/scale clause (pole vs running
  masses; an IR-fixed-point survival mechanism must be named). The Brannen
  phase observation stays in the recorded-coincidence file, unleaned-on.
- **Counting (Tier 2)**: three generations as the Jordan-tower cap
  (`J_3(O)` is the last rung) plus the Kobayashi-Maskawa/CP pincer - grade
  `C` with one soft jaw, on probation (Gate F1 requires a pre-registered
  canonical construction before any numerics are admissible).
- **Hierarchies (Tier 2/3)**: Froggatt-Nielsen-style suppression-by-distance
  is the named mechanism class (Gate F3), mechanism-only, no numbers claimed.
- **Out of reach, binned (Tier 3)**: the absolute Yukawa scale, the electron
  mass value, the electroweak/Planck hierarchy, theta_QCD - currently bedrock
  (`B`) or substrate-statistical (`S`), all waiting on the growth measure,
  which is the program's declared central open problem. The program's
  distinctive deliverable here is the *bin classification itself*: for every
  mass parameter it states whether it is derived, protected, statistical, or
  bedrock - which no competing framework currently does.

Bottom line for layer 5: **no mass value is computed, and this paper claims
none.** The value problem is not evaded; it is partitioned, with one live
gated relation, one owned scale postdiction, and named bedrock.

### Layer 6 - Composite mass: QCD and the proton. IMPORTED CONTEXT.

Ninety-five-plus percent of visible mass is confined field energy ("mass
without mass") - established QCD, of which this program derives nothing. The
Pluecker theorem is that story's exact kinematic skeleton (trapped,
disagreeing, nearly-null constituents), no more. Confinement, the trace
anomaly, and the hadron spectrum are outside the program's current reach and
are marked so in its own leverage map.

### The composed answer

Chain rule applied, the strongest honest composite statement today:

> Given lightlike constituents, what mass is - and exactly when it vanishes -
> is a closed, machine-checked theorem (layer 1). That the substrate can host
> the exactly-chiral fermions the mass mechanism needs is closed at the free
> regulator level, machine-checked in both directions - flux drives the
> index, and the index obstructs the gap (layer 3). That mass is the rate of
> legal chirality exchange is now itself machine-checked in the minimal 1+1D
> model - dispersion, exact coherence `m/E`, and the bridge identity "coin
> amplitude = Pluecker wedge" - with the 3+1D and gauge-dressed
> generalizations remaining (layers 2 and 4). What the values of the masses
> are remains open: one relation gate whose naive form was killed by proof
> and honestly rescoped, one owned scale relation, honest bedrock bins for
> the rest (layer 5). Composite hadronic mass is imported context (layer 6).

In one sentence: **the program can now state, at theorem grade, what mass is,
where it can live, that masslessness is topologically protected, and that its
geometric and coupling mass stories are one scalar in the minimal model; it
can state, at gate grade, why there are three copies; and it cannot yet
state, at any grade, why the electron weighs what it weighs - and it says
so.**

---

## 17. Open writing tasks (not part of the paper text)

- **Verification-debt sprint (blocking, per Round 8):** source-verify the two
  flagged imports (Wilczek "mass without mass"; Koide 1981) and re-confirm
  the GW/overlap/index classic attributions before submission. The 2026-06-25
  INSPIRE/Semantic Scholar verifications (AHH `1709.04891`; Kim-Kim-Lee
  `2102.07063`; Peres-Scudo-Terno `quant-ph/0203033`; Gingrich-Adami
  `quant-ph/0205179`; Chin-Lee `1407.2492` arXiv-only) stand.
- Decide whether to promote the celestial-moment artifact and the `SL(2,C)`
  covariance draft into the trusted `PhysicsSM` surface before submission, or
  to present them as a clearly-labeled appendix / handoff layer.
- Formalize the two named orbit lemmas of section 6 (small, well-posed; same
  species as the existing I1 stack) so the orbit-invariant language is fully
  backed in Lean.
- Convert ASCII formulas to LaTeX and add the three figures from the
  skeleton: a two-edge collinear-vs-fanned diagram, the Bloch-sphere
  monopole/dipole/deficit picture, and the theorem-status map (now section
  16) as a typeset figure.
- Choose the lead venue framing (formalized-mathematics artifact vs.
  math-physics) per the publication plan, and route external review per the
  Round 8 plan (formalization community for the Lean artifact; lattice
  community for the section 11 anchors; flavor community only if/when F2
  graduates).
- Keep the Omega-firewall check in the submission checklist: no program
  ontology language in the final text (Part I's pedagogy and one labeled
  hypothesis are the permitted maximum).

## Change log

- **2026-06-25 (v1).** Initial draft: Part I pedagogy, Part II trusted core
  (Pluecker identity, massless criterion, twistor chart), wrappers, prior-art
  audit with verified citations.
- **2026-06-27 (addendum, now folded in).** Frame-relative vs invariant
  discipline (`det P` invariant; `rho = P/Tr P` as proxy only); neutrino
  stress-test framing; no-overclaim guardrails. All incorporated into
  sections 6, 8, and 16.
- **2026-07-03 (v2.1, harvest update).** Same-day integration of three
  Aristotle harvests and one self-proved no-go: the vanishing theorem
  (`OverlapIndexVanishing.lean`, job 2b9ab4ce - gapped forces index zero;
  nonzero index forces exact zero modes; flux witness carries a zero mode;
  Hermiticity dropped as unnecessary), the 1+1D mass-coin/Pluecker-wedge
  bridge suite (`GateI1/MassCoinBridge.lean`, job f983a254 - 12 statements
  including `onshell_wedge_normSq_eq_coin_sq`, exact Dirac and walk coherence
  identities), the Hermitian Sylvester congruence-inertia bridge
  (`GateC2/HermitianSylvester.lean`, job 635b44ae, integrated by the
  co-agent), and the Gate F2.0 invariant-potential no-go
  (`GateF2/InvariantPotentialNogo.lean`, self-proved; F2 rescoped in the
  pre-registration document). Sections 11, 14, and 16 updated accordingly:
  layer 2 closed at the 1+1D level, layer 3's protection statement proved,
  layer 4's keystone proved in its minimal instance, layer 5's Koide gate
  honestly rescoped after its naive form was killed by proof.
- **2026-07-03 (v2, this revision).** Applied the Round 8 constitution:
  interpretation-free core statement; orbit-invariant correction (new section
  6) with two named Lean targets; claim calculus and originality tags
  throughout; Omega-firewall compliance; halo-rule-compliant context section
  (new section 11) for the newly kernel-checked chirality substrate (Gates
  C1-C2) and soldering dictionary (Gate I1); prior-art section extended (GW /
  index imports; Koide status remark) with explicit verification-debt flags;
  claim boundary restated in two-column form; replaced "what remains" with
  the graded six-layer status map (new section 16) incorporating the Round 7
  parameter audit (Tier 0 structures, seesaw postdiction, Gate F2 with scheme
  clause and kill-condition, generation pincer, bedrock bins); updated
  provenance note (2026-07-03 builds: trusted 8295 green; Gate C2 aggregate
  8063 green; Gate I1 8027 green).

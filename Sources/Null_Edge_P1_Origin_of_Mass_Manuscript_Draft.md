# The Origin of Mass: matter as trapped, disagreeing light

**Working draft, 2026-06-22.**
Publication-plan slot: P1 in
[`Null_Edge_Causal_Graph_Publication_Plan.md`](Null_Edge_Causal_Graph_Publication_Plan.md).
Companion skeleton:
[`Null_Edge_P1_Plucker_Mass_Manuscript_Skeleton.md`](Null_Edge_P1_Plucker_Mass_Manuscript_Skeleton.md).

Lean anchors (trusted unless noted):
`PhysicsSM.Spinor.PluckerMass`,
`PhysicsSM.Spinor.TwistorPluckerMass`,
`PhysicsSM.Draft.NullEdgeSpinorGeometryTargets` (kernel-clean draft),
`PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore` (kernel-clean draft),
and the standalone celestial-moment artifact
`AgentTasks/aristotle-standalone/null-edge-spinor-network-closure-20260621/`.

Conventions used throughout: metric signature `(+,-,-,-)`; visible Weyl
spinors are complex two-component objects `psi : Fin 2 -> C`; the bispinor of a
null edge is the rank-one Hermitian matrix `psi psi^dagger`; mass squared is the
`2 x 2` complex determinant of the summed bispinor. Formulas are written in
plain ASCII to match repository text hygiene; conversion to LaTeX is a later
step.

---

## Abstract

We give, and formally verify, a precise finite answer to one clean version of an
old question: how can invariant mass arise from massless, lightlike motion? In
the model developed here the visible microscopic degrees of freedom are
*lightlike*. Each is a ray of light-speed motion that carries energy and momentum
but no rest mass, encoded by a null two-spinor `psi`. A visible particle-like
system is represented by a finite *bundle* of such null edges, and its total
momentum is the sum of their rank-one contributions
`psi_i psi_i^dagger`.

The organizing proposal is that elementary visible motion is null motion. At a
fine enough scale each visible edge is individually massless; ordinary
sub-luminal motion and rest mass appear after many such lightlike contributions
are coupled, trapped, or coarse-grained into one visible bundle.

Our central result, checked by the Lean 4 proof kernel, is an exact identity: the
invariant mass squared of the bundle equals the total pairwise Pluecker spread of
its null directions,

```text
det( sum_i psi_i psi_i^dagger ) = sum_{i<j} | psi_i wedge psi_j |^2 ,
```

where `psi_i wedge psi_j = (psi_i)_0 (psi_j)_1 - (psi_i)_1 (psi_j)_0` is the
spinor Pluecker bracket. The right-hand side is manifestly real and nonnegative,
and it vanishes if and only if all of the null directions coincide projectively
(every spinor is a scalar multiple of one common direction). Equivalently, on the
celestial sphere energy is the monopole and momentum the dipole of a weighted set
of light rays, and mass is exactly the amount by which the dipole fails to
saturate the energy,

```text
m^2 = ( E^2 - |C|^2 ) / 4 ,   C = sum_i w_i n_i .
```

The contribution is twofold. (i) A clean, fully finite, machine-checked theorem
identifying invariant mass with a geometric quantity -- the disagreement in
direction among lightlike constituents -- together with an exact massless
criterion and companion covariance/twistor/Dirac-square-root wrappers whose
status is tracked explicitly below. (ii) The resulting conceptual statement that
rest mass, in this finite kinematic setting, is a collective relation among
trapped, mutually disagreeing lightlike motions. We separate this theorem
carefully from the dynamical and Standard-Model questions it leaves for later: a
continuum Dirac limit, the actual particle mass spectrum, and the detailed Higgs
and QCD dynamics of observed matter.

---

# Part I. How mass can come from lightlike motion

*(Intended to be read by a curious high-school student. No formulas are needed
to follow it; the equations return in Part II.)*

## A question that sounds silly until you try to answer it

Everyone knows what mass is. It is how much *stuff* there is. A bowling ball has
more of it than a tennis ball; that is why the bowling ball is harder to throw
and harder to stop. Step on a scale and you read your mass (dressed up as
weight). Mass feels like the most basic, most obvious property a thing can have.

So here is a question that sounds almost too simple: *what is the mass made of?*
If you cut your body into smaller and smaller pieces -- organs, cells, molecules,
atoms, and finally the protons and neutrons in the nuclei -- where, exactly, does
the mass live? Most people guess that mass is just added up from the masses of
the little parts, all the way down, like weighing a bag of sand by weighing each
grain. That guess is wrong, and the way it is wrong is the most beautiful fact in
physics.

## Light has no mass -- and that is the clue, not the problem

Start with the most familiar thing in the universe that has *zero* mass: light. A
particle of light, a photon, weighs nothing. You can never put a photon on a
scale, because you can never make it sit still. Light always moves at exactly the
speed of light, `c`, no matter who is looking or how fast they chase it. There is
no "point of view" in which a photon is at rest. That is what it means to be
massless: to be forever moving at the speed limit of the universe.

Physicists call any motion of this kind **lightlike** or **null**. Photons are
the everyday example, but the mathematics below is about lightlike momentum in
general, with photons as the familiar example.

The proposal of this paper is to use lightlike motion as the elementary visible
building block. Look closely enough, and every individual visible piece is
massless. Look at a whole bundle of pieces moving in several directions at once,
and a massive object can appear.

A massive thing is the opposite. A bowling ball *can* sit still. There is a point
of view -- yours, when you hold it -- in which it just sits there, going nowhere.
Having mass means having a frame in which you are at rest. Being massless means
never having one.

So mass and "having a rest frame" are the same idea. Keep that thought; it is the
whole key.

## Two beams of light can weigh something

Now the trick. Take *two* photons. A single photon has no rest frame: it races
off at `c` and you can never catch it. But suppose the two photons fly in
*opposite* directions, one going left, one going right, with equal energy. As a
*pair*, which way are they going? Neither. Their motions cancel. The pair, taken
as a whole, is going nowhere.

And "going nowhere" was exactly our definition of having a rest frame -- of having
mass. The two-photon system has a rest frame even though neither photon does. So
the pair has mass. Two massless things, put together, make something massive. The
mass belongs to the pair, to the fact that the two photons *disagreed about which
way to go.*

This is real and measurable. If you trapped two such photons in a perfectly
mirrored box, the box would be measurably heavier than an empty box, by exactly
the energy of the light inside (divided by `c` squared, via `E = m c^2`). The
trapped light has weight as a coupled, disagreeing system. Mass, here, is
bottled-up, churning, self-cancelling motion.

So we can already state the punchline in plain words:

> **Mass is what you get when lightlike motion is trapped and points in more than
> one direction at once. The more the directions disagree, the more mass there
> is. Each fine-grained piece can remain massless while the whole bundle becomes
> massive. If everything points the same way, the mass is zero.**

## This is where *your* weight actually comes from

The two-photon box is the simple version of a pattern that appears throughout
ordinary matter.

Your body's mass lives almost entirely in the protons and neutrons of your atomic
nuclei. Each proton is made of three small quarks held together by the strong
force, which is carried by particles called gluons. Now the surprise: if you add
up the masses of the three quarks inside a proton, you get only about one to two
percent of the proton's mass. The gluons, like photons, are massless. So roughly
*ninety-five percent of the proton's mass -- and therefore about ninety-five
percent of yours -- is carried by motion and field energy.* It is the energy of
nearly massless quarks moving almost at the speed of light, and of massless
gluons, all trapped inside the proton, all pulling and racing in different
directions at once. The physicist Frank Wilczek named this "mass without mass."

So when you step on a scale, almost everything it reads is trapped, disagreeing,
light-speed motion -- the very same effect as the two-photon box, just bound up by
the strong force instead of mirrors. Mass is mostly *confined, restless
lightlike motion*.

## But what about the rest? The Higgs field

That trapped-light story explains almost all of the mass of ordinary matter, but
not quite all of it, and it does not by itself explain the electron at all. The
electron is not made of smaller pieces you could trap in a box; as far as anyone
has ever measured, it is elementary, a single point. Yet it has a mass. And the
tiny intrinsic masses of the quarks -- the few percent the strong force did not
account for -- are elementary in the same way. Where do *those* masses come from?
This is the part of the story the Higgs field tells, and remarkably, it turns out
to be the same trick once more.

Start again from the rule that anything massless must travel at the speed of
light. A spinning massless particle has one extra feature: its spin is locked to
its direction of motion. It is either *left-handed* (spinning like a left-handed
screw as it goes) or *right-handed*. At the speed of light this handedness is
absolute -- everyone agrees on it, no matter how they are moving -- because no one
can ever overtake the particle and look at it from the other side. So a massless
electron would really be two separate things that never mix: a "lefty" that races
forever at `c`, and a "righty" that does the same.

Here is the key idea, and it is the idea from earlier in this paper wearing a new
costume. *Mass is what makes the lefty and the righty turn into each other.* A
massive electron is one that constantly flips: lefty, righty, lefty, righty, as it
travels. And anything that keeps flipping cannot move at the speed of light --
because at light speed the handedness was frozen, with no way to change. So the
flipping forces the electron below light speed, which means it now has a frame in
which it sits still, which, as we said at the very start, is exactly what having
mass means. The electron is, deep down, two light-speed motions -- a lefty and a
righty -- stitched together so tightly that it zig-zags between them instead of
going straight. Its mass is the price of that zig-zag.

What does the stitching? An invisible field that fills all of space, even where
there is nothing else: the Higgs field. The strange part is why it is switched on
in empty space at all. Most fields are quietest -- lowest energy -- when they are
set to zero everywhere. The Higgs field is the opposite: its lowest-energy state
is *not* zero. A good picture is a pencil balanced perfectly on its tip. Balanced,
it is symmetric -- no direction is special -- but that position is a hilltop, and
the slightest nudge makes it topple and point some particular way. The early
universe was like that pencil. The Higgs field "fell" off its symmetric peak and
settled into a steady, nonzero value that now fills every cubic centimeter of
space. Empty space is not empty; it is soaked in a frozen Higgs value.

That frozen background is the stitching. Each time the racing lefty electron
brushes against it, it is turned into a righty, and then back -- the relentless
zig-zag that is the electron's mass. A particle that interacts strongly with the
Higgs background flips often and comes out heavy; one that barely interacts flips
rarely and stays light; one that ignores it completely, like the photon, never
flips and stays massless, forever at `c`.

> **An elementary particle's mass is how strongly it is forced to flip its
> handedness against the ever-present Higgs field. No flipping, no mass -- just a
> massless thing that flies at light speed forever. The Higgs supplies the flips;
> the flips are the mass.**

The Higgs does one more famous job, and it shows the same pattern at the level of
forces. Forces are carried by particles: electricity and magnetism by the massless
photon, and the *weak* force -- the one behind certain kinds of radioactivity and
behind the reactions that let the Sun shine -- by two heavy particles called the W
and the Z. "Heavy" is an understatement: the W and Z weigh about eighty to ninety
times as much as a proton. That weight has a dramatic consequence. A force carried
by a massless particle, like the photon, can reach clear across the universe,
which is why you can see light from distant stars. A force carried by very heavy
particles can only reach across a tiny distance -- here, far smaller than an atomic
nucleus -- which is why the weak force is so feeble and so short-ranged, and why
radioactive decay is usually so slow.

Where did the W and Z get all that mass? From the same frozen Higgs field. In the
early, symmetric universe the photon, the W, and the Z were a single family of
massless, light-speed force-carriers. When the Higgs field toppled off its peak,
it weighed down the W and the Z -- the universe's frozen field refusing to let them
travel freely at `c`, the very same way it refuses to let the electron go straight
-- while leaving one particular combination, the photon, completely untouched. That
is why, in the universe we actually live in, light stays massless and
electromagnetism reaches forever, while the weak force is heavy and hides inside
the nucleus.

So every kind of mass in this paper is one idea wearing different clothes. The
proton: many lightlike pieces trapped by the strong force, all pointing different
ways. The electron: a single lightlike lefty and righty, stitched into a zig-zag by
the Higgs field. The W and Z: force-carriers the frozen Higgs field will not let
travel at light speed. In every case, mass is lightlike motion that something
prevents from going perfectly straight -- and the theorem at the heart of this
paper makes the kinematic core of that statement exact: lightlike pieces whose
directions disagree carry mass, equal to the disagreement. (Making the electron's
left-right zig-zag precise in this language is the subject of a companion paper in
this program, P2, on the "Dirac square root" of the mass; the literal zig-zag of
light has its own finite model, the checkerboard of P4.)

Two honest cautions before we leave the words behind. First, the Higgs explains
*that* elementary particles have intrinsic mass, and *why* some force-carriers are
heavy while light is not, but it does not explain *why each mass has the size it
does*. The electron, the quarks, and the rest differ from one another by factors
of hundreds of thousands, and those numbers are measured and put into the theory
by hand, not derived. Our theorem does not fix them either. Second, the pictures
here -- handedness flipping, a field freezing across the sky -- are honest cartoons
of mathematics that is genuinely about chirality and broken symmetry. They are
meant to convey the shape of the idea, not to replace the equations. Supplying the
equations is what the rest of this program is for.

## Our contribution: making "disagreeing light" exact

The story above has been told before, in words, and pieces of the mathematics
are familiar in relativity, spinor-helicity theory, and twistor theory. What we
add here is a clean, finite, *checkable* version for a bundle of lightlike
pieces: a single equation that says precisely how much mass the bundle has from
how much its directions disagree, with a proof so explicit that a computer can
verify every step.

That is what this paper provides. We describe each lightlike microscopic piece by
the most economical bookkeeping physics knows for "a ray of light-speed motion
with a direction and an energy": a *null spinor*. We add up the pieces. And we
prove, with the Lean proof assistant checking every line, that the mass squared of
the whole bundle is exactly the sum, over every pair of pieces, of how much that
pair disagrees in direction. The disagreement of a pair is measured by an "area"
between their two directions -- the squared Pluecker bracket. No disagreement, no
area, no mass. Lots of disagreement, lots of mass.

This is the precise mathematical form of the null-edge proposal. The elementary
visible pieces are massless. Mass belongs to the coupled bundle: to the pattern
made when many massless, lightlike motions are held together while pointing in
different directions.

We also prove the sharp boundary case: the mass is *exactly* zero if and only if
every piece points the same way. One single ray, or many perfectly aligned rays,
stays massless, just like a single photon or a coherent laser beam. The instant
the directions fan out, mass switches on.

## A picture you can hold in your head

Imagine the night sky as a sphere, and put a little arrow on the sphere for each
lightlike piece, pointing toward where that piece is heading, with a length set by
its energy. Two numbers summarize the whole bundle:

- **The total energy** is just how much arrow there is altogether -- add up all
  the lengths. (Think of it as the "monopole": the overall amount.)
- **The total momentum** is the *single arrow you get by laying all the little
  arrows tip-to-tail* -- the vector sum. (Think of it as the "dipole": the net
  lopsidedness, which way the bundle leans as a whole.)

If every arrow points the same way, they stack up into one long arrow: the net
momentum is as big as the total energy can possibly make it. That is the massless
case -- a beam. But if the arrows fan out around the sphere, they partly cancel
when you lay them tip-to-tail, so the net arrow is *shorter* than the total amount
of arrow. That shortfall -- the gap between how much momentum the energy could
have carried and how much it actually carries -- *is the mass.* Spread the
directions out and the gap grows; the bundle gets heavier. Pull them together and
the gap closes; the bundle approaches a massless beam.

That is the entire idea of where mass comes from, in one image: **mass is the
deficit between the energy a bundle of light carries and the momentum it manages
to point in one direction.** It is the price of disagreement.

## Claim boundary

We want to be honest about the size of the claim, because the subject invites
overreach. What we have is a finite, exact, machine-checked piece of *geometry and
kinematics*: given a bundle of null pieces, here is its mass, here is exactly when
it is zero, and here is why both are true. This is real, and it makes the old
"trapped light" story precise in a form a proof kernel will sign off on.

The broader research program adds a stronger organizing hypothesis: visible
microscopic histories are made from null edges, and massive motion is the
coarse-grained behavior of coupled null-edge bundles. This paper proves the
finite mass formula behind that hypothesis. Later work must supply the dynamics:
the actual masses of the electron, quarks, and other particles; the strong force;
the Higgs/Yukawa transition amplitudes; and the rules by which lightlike pieces
move and bind over time.

---

# Part II. The finite Pluecker-mass theorem

This part states the formal content precisely and points to the exact
kernel-checked Lean declarations. Every named theorem below compiles under the
pinned toolchain `leanprover/lean4:v4.28.0` with no `s o r r y`, except where a
declaration is explicitly marked *draft (kernel-clean)*.

## 1. Setup and conventions

A **visible Weyl spinor** is a complex two-component vector
`psi : Fin 2 -> C` (`CSpinor`). To a single null edge we attach its rank-one
Hermitian **bispinor**

```text
rankOneHermitian psi := psi psi^dagger  =  vecMulVec psi (star psi),
```

a `2 x 2` complex Hermitian matrix. In the standard soldering
`p_{A A'} = p_0 I + p . sigma` of a four-momentum to a Hermitian `2 x 2` matrix,
`psi psi^dagger` is the bispinor of a future-pointing **null** momentum: its
determinant is `p_0^2 - |p|^2 = 0`. This is the formal version of "a single
lightlike piece is massless."

The **spinor Pluecker bracket** (spinor wedge) of two spinors is the
antisymmetric contraction

```text
spinorWedge psi phi := psi_0 phi_1 - psi_1 phi_0  in  Lambda^2(C^2) ~= C.
```

Convention warning (recorded in the Lean docstrings): the Pluecker bracket lives
in the antisymmetric square `Lambda^2 S ~= C`, the singlet, *not* in the
symmetric square `Sym^2 S` that carries field-strength / curvature data. Mass is
a `Lambda^2` invariant.

We write the complex squared modulus as `complexAbsSq z := z * conj z`, which
equals `(Complex.normSq z : C)` and is used so that determinants and squared
brackets can be compared as complex numbers before reality is extracted.

Anchor: module `PhysicsSM.Spinor.PluckerMass`, definitions `CSpinor`,
`rankOneHermitian`, `spinorWedge`, `complexAbsSq`.

## 2. A single null edge is massless

```text
theorem det_rankOneHermitian_eq_zero (psi : CSpinor) :
    (rankOneHermitian psi).det = 0
```

The determinant mass of one null edge vanishes identically: one ray of
light-speed motion has no rest mass.

## 3. Two edges: mass is the squared Pluecker bracket

Define the two-edge visible momentum `twoEdgeMomentum psi phi :=
rankOneHermitian psi + rankOneHermitian phi`. Then:

```text
theorem two_edge_plucker_mass_identity (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = complexAbsSq (spinorWedge psi phi)
```

The mass squared of a two-edge bundle is exactly the squared modulus of the
Pluecker bracket of the two null directions -- the squared "area" between them.
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
`finBundleMomentum psi := sum_i rankOneHermitian (psi i)` and the total pairwise
Pluecker spread is `finPairwisePluckerMass psi := sum_{i<j} complexAbsSq
(spinorWedge (psi i) (psi j))` (summed over the ordered-pair index set
`finPairIndexSet n = { (i,j) : i < j }`). The keystone theorem:

```text
theorem fin_bundle_plucker_mass_identity {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi
```

i.e.

```text
det( sum_i psi_i psi_i^dagger ) = sum_{i<j} | psi_i wedge psi_j |^2 .
```

The proof is a Cauchy-Binet / off-diagonal-folding argument: expanding the
`2 x 2` determinant of the summed rank-one matrices produces a double sum whose
diagonal cancels and whose `(i,j) + (j,i)` off-diagonal terms assemble into the
squared bracket. The folding lemma `sum_pairs_offdiag` carries this step.

## 5. Reality, nonnegativity, and the exact massless criterion

The right-hand side is a sum of squared moduli, hence real and nonnegative. The
Lean surface records this explicitly:

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
common direction -- a single beam. Any projective spread switches mass on. This is
the precise form of the Part I slogan.

## 6. Celestial moment form: energy monopole, momentum dipole, mass deficit

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

mass is exactly the deficit by which the momentum dipole `|C|` falls short of the
energy monopole `E`. Aligned directions saturate `|C| = E` and give `m = 0`; a
fanned-out bundle has `|C| < E` and is massive.

Guardrail (kernel-checked, and important for the downstream P9 program): the
closed case `C = 0` does **not** mean "no source." It is the *rest frame*:

```text
theorem closed_spinorFan_is_restFrame
    (hunit : ...) (hclosed : closureVector w u = 0) :
    pairwiseAngularMass w u = energy w ^ 2 / 4
```

A closed visible fan has the maximal rest energy `E^2/4`, not zero mass. Visible
momentum closure is a kinematic rest-frame condition, never to be conflated with
source invisibility.

*Status:* this artifact is kernel-clean (no `s o r r y`) but lives in the
standalone Aristotle package, not yet in the trusted `PhysicsSM` namespace. The
manuscript should either promote it before submission or cite it as an appendix
result. (Tracked in the publication plan's "Remaining" note for P1.)

## 7. Lorentz covariance: SL(2,C) invariance of the determinant mass

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
this is the statement that the bundle mass is a Lorentz invariant of the visible
null data. *Status:* draft (kernel-clean) in
`PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`; a convention/semantic review is
required before promotion to the trusted surface.

The manuscript should keep this unnormalized invariant separate from the
normalized reduced-state language. If

```text
rho_vis = P / Tr(P),
```

then `det(rho_vis) = det(P) / Tr(P)^2` measures `(m/E)^2` after choosing a
timelike observer or lab-energy convention. That is useful for proper-time-rate
and concurrence language, but it is not the invariant mass. The invariant
statement is `det(P) = m^2`.

## 8. Twistor-chart matching

In the spinor chart `Z = (omega^A, pi_{A'})` -- with only the `pi` spinor entering
the mass -- the same identity reads as a two-twistor / multi-twistor mass. From
the trusted module `PhysicsSM.Spinor.TwistorPluckerMass`:

```text
theorem two_twistor_mass_invariant_eq_plucker (Z W : SpinorChartTwistor) :
    twoTwistorMassInvariant Z W = complexAbsSq (spinorWedge Z.pi W.pi)
theorem multi_twistor_momentum_det_eq_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    (multiTwistorMomentum Z).det = multiTwistorPairwiseMass Z
```

The module also records both normalization conventions explicitly (determinant
vs. trace-pairing mass, differing by the factor `2`:
`twoTwistorMassSqDetConvention` vs. `twoTwistorMassSqTraceConvention`) so no
silent factor-of-two drift can occur. Scope: this is the finite spinor chart
only. Projective twistor space, twistor cohomology, the Penrose transform, and
incidence geometry are explicitly out of scope.

## 9. The first-order (Dirac) square root -- bridge to P2

The static chiral Dirac slash of the bundle momentum squares back to the same
mass scalar:

```text
theorem chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass : ...
```

(`PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`, draft/kernel-clean). This is
the square root of the *static* mass and is the natural seam to paper P2 ("A
finite Dirac square root of the Pluecker mass"). It is *not* yet a dynamical
propagation theorem and should be flagged as a forward pointer, not a result of
this paper.

## 10. Relation to prior work

- **Massive spinor-helicity.** Arkani-Hamed, Huang and Huang (`1709.04891`) write
  a massive momentum as a pair of `SU(2)`-little-group spinors. The present
  identity is the finite-bundle generalization: an arbitrary number of null
  edges, with mass as the total pairwise spread rather than a single
  two-spinor pairing, packaged as a kernel-checked theorem in the null-edge
  language.
- **Two-twistor mass models** realize a massive particle from two twistors; our
  twistor-chart section recovers exactly this as the `n = 2` case and then
  generalizes.
- **Mass/concurrence prior art and frame-dependence.** Chin-Lee
  (`1407.2492`) explicitly identify the two-twistor/momentum-bispinor mass with
  two-qubit concurrence in the normalized-energy setting. Peres-Scudo-Terno
  (`quant-ph/0203033`, PRL 88, 230402) and Gingrich-Adami
  (`quant-ph/0205179`, PRL 89, 270402) are the guardrails: reduced spin or
  entanglement quantities can be frame-dependent under boosts. The novelty of
  this paper should therefore be the finite null-edge bundle theorem and its
  formalized packaging, not the bare mass/concurrence analogy.
- **Grassmannian / Pluecker geometry.** The right-hand side is a sum of squared
  `Gr(2,n)` Pluecker coordinates; the massless locus is the cone where all minors
  vanish (projective collinearity). This connects to the positive-Grassmannian
  stratification (`1212.5605`) as a minor-stratification angle, kept as a remark.
- **Spinor-network closure / loop gravity.** The celestial moment form is the
  Dupuis-Speziale-Tambornino closure constraint (`1201.2120`) read as a mass
  identity; `C = 0` is the moment-map / rest-frame condition.
- **"Mass without mass."** The physical anchor for Part I is the QCD origin of
  the proton mass (Wilczek): most hadron mass is the energy of nearly massless
  confined constituents. Our theorem is the clean kinematic skeleton of that
  picture, not a derivation of QCD.

The novelty claim is deliberately narrow and reviewable. The contribution is the
finite-bundle formulation, its exact massless criterion, reality, covariance and
celestial-moment wrappers, and the machine-checked packaging that turns the
"trapped light" intuition into a theorem spine for the null-edge program.

## 11. Claim boundary

What is established (kernel-checked finite linear algebra):

- the determinant/Pluecker mass identity for any finite null-spinor bundle;
- reality and nonnegativity of the determinant mass;
- the exact massless-iff-projectively-collinear criterion;
- the celestial monopole/dipole moment form (standalone artifact);
- `SL(2,C)` covariance (draft, kernel-clean);
- twistor-chart matching with explicit normalization conventions;
- the static Dirac square root (draft, kernel-clean) as a bridge to P2.

Separate work required for the full physics program:

- a continuum Dirac equation from null-edge dynamics;
- a Standard-Model mass spectrum and predicted Yukawa couplings;
- a derivation of QCD confinement, the proton mass, or the strong force;
- a cosmological / source-visibility theorem (that is gated work, P9);
- a Higgs/Yukawa dynamics layer explaining which chirality flips are allowed;
- projective twistor geometry beyond the checked spinor chart.

## 12. Theorem-to-Lean map

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
celestial moment form (E^2-|C|^2)/4      pluckerMass_eq_energy_sq_sub_closureDefect_sq     artifact*
closed fan is rest frame                 closed_spinorFan_is_restFrame                     artifact*
SL(2,C) invariance of det mass           finBundleMomentum_det_sl2_invariant               draft**
two-twistor mass = wedge                 two_twistor_mass_invariant_eq_plucker             trusted
multi-twistor mass = pairwise            multi_twistor_momentum_det_eq_pairwiseMass        trusted
Dirac slash squares to mass              chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass draft**

*  kernel-clean, standalone Aristotle package; promote or cite as appendix.
** kernel-clean draft in PhysicsSM.Draft.*; needs convention review to promote.
```

## 13. Conventions table

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
```

---

## 14. What remains for a complete origin-of-mass treatment

This draft should be presented as the finite kinematic core of an
origin-of-mass program. A complete treatment needs the following additional
pieces.

1. **Promote the companion theorem layer.** The celestial moment form,
   `SL(2,C)` covariance, twistor-chart wrapper, and static Dirac square root
   should either be promoted to trusted surfaces or quarantined as clearly marked
   appendices. The trusted Pluecker theorem can carry the paper by itself, but
   the broader "origin of mass" story is stronger when these wrappers have been
   reviewed semantically.

2. **Insert a sourced Standard Model/QCD bridge.** Part I should remain simple,
   but the technical discussion needs a precise account of what the Higgs does,
   what QCD does, and what this theorem does. The Higgs supplies elementary
   bare masses through Yukawa couplings. In the null-edge reading, those
   couplings are the Standard-Model permission and amplitude for chirality-flip
   vertices, allowing left- and right-handed null components to mix into
   massive Dirac propagation. Most proton and neutron mass comes from confined
   QCD field/kinetic energy. The Pluecker theorem explains the finite kinematic
   invariant of a bundle of null momenta. The QCD part of the program must still
   derive confinement, the trace anomaly, and the hadron spectrum.

3. **Separate kinematics from dynamics.** The theorem answers: given a finite
   family of null visible momenta, what invariant mass does the family have? A
   complete theory must also answer why the null pieces are trapped, what
   dynamics fixes their distribution, and how effective Dirac, Higgs, or QCD
   behavior emerges from the underlying graph histories.

4. **Use the Dirac square root as the next structural gate.** The determinant
   mass is a square-level observable. The draft Dirac-slash bridge is therefore
   the right transition to P2: it shows what first-order operator has this mass
   as its square. Without that operator-level sequel, this paper is a beautiful
   invariant identity; with it, the paper becomes the first block of a dynamics
   program.

5. **Audit prior art before submission.** The final manuscript should cite and
   differentiate massive spinor-helicity, two-twistor mass models, Cauchy-Binet
   / Gram determinant identities, spinor-network closure, and the QCD "mass
   without mass" literature. The honest positioning is: known mathematical
   ingredients, newly assembled and formally checked for this null-edge research
   program.

6. **Add the public-facing figures.** The high-school section would benefit from
   three visual anchors: two opposite photons in a box, a fanned celestial sphere
   with total energy versus net momentum, and a theorem-status map showing which
   claims are trusted, draft, or future work.

## Open writing tasks (not part of the paper text)

- Decide whether to promote the celestial-moment artifact and the `SL(2,C)`
  covariance draft into the trusted `PhysicsSM` surface before submission, or to
  present them as a clearly-labeled appendix / handoff layer.
- Convert ASCII formulas to LaTeX and add the three figures from the skeleton: a
  two-edge collinear-vs-fanned diagram, the Bloch-sphere monopole/dipole/deficit
  picture, and the theorem-to-Lean table as a typeset figure.
- Audit and insert the source keys (massive spinor-helicity `1709.04891`,
  positive Grassmannian `1212.5605`, spinor-network closure `1201.2120`, Wilczek
  "mass without mass") against the program bibliography before citing.
- Choose the lead venue framing (formalized-mathematics artifact vs.
  math-physics) per the publication plan.

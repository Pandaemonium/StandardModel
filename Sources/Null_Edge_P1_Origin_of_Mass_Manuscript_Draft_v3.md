# The Origin of Mass: matter as trapped, disagreeing light

**Working draft v3, 2026-07-07** (supersedes the v2 draft of 2026-07-03; see
the change log at the end). Publication-plan slot: P1 in
[`Null_Edge_Causal_Graph_Publication_Plan.md`](Null_Edge_Causal_Graph_Publication_Plan.md).

**What changed in v3.** This revision is a rewrite for clarity and impact:
Part I is written so that a college student with one course of linear algebra
and a little special relativity can follow every step; Part II keeps every
kernel-checked statement of v2 but opens each section with a plain-language
sentence. The layered status map (Part II, section 15) is updated through
2026-07-07, including the new draft carrier layer: a guard-pinned `D^2`
decomposition into aperture, closure, and turn slots, with the Krein/E
four-slot mass form and the concrete `det P` carrier identification still
open.  It also records the index-protection theorems and their current
positivity boundary. The paper's own claims are unchanged: this is still a
paper about ONE theorem.

**How to read the grades.** Every claim in this paper carries a grade, so
that the reader always knows what kind of confidence backs a sentence:

- `T` - a theorem with a source-verified classical proof in the literature.
- `T|H` - a theorem conditional on hypotheses displayed right there.
- `M` - machine-verified: the statement is checked by the Lean 4 proof
  kernel in this project's repository, and its axiom footprint is audited.
- `C` - a pre-registered conjecture, with a gate (what would confirm it) and
  a kill-condition (what would refute it) written down BEFORE looking.
- Originality tags: `[orig]` new here, `[comp]` known mathematics newly
  packaged, `[import]` quoted from the literature, `[interp]`
  interpretation.

A composite claim is only as strong as its weakest link, and we say so each
time. When a sentence has no grade, it is exposition.

**Lean anchors (verification status).** The core theorem chain lives in the
trusted namespace `PhysicsSM.Spinor.PluckerMass` and
`PhysicsSM.Spinor.TwistorPluckerMass` (verified green under the pinned
toolchain `leanprover/lean4:v4.28.0`; provenance note of v2, 2026-07-03).
Kernel-clean draft anchors: `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`
(SL(2,C) covariance), `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`
(static Dirac square root), the celestial-moment standalone artifact, the
Gate C1/C2 chirality-substrate layer, and - new in this revision - the
carrier layer `PhysicsSM/Draft/NullEdge/Carrier/` with its build-enforced
axiom guard (`CarrierAxiomGuard.lean`; guard build green 2026-07-07, axiom
footprint `[propext, Classical.choice, Quot.sound]`, no placeholders, no
native evaluation). Program-level results from the 2026-07-07 consultation
round are cited only in the status map, at their own grade (`MEMO`: working
rigor, executor-spot-verified, kernel transcription pending), never as
results of this paper.

**Conventions.** Metric signature `(+,-,-,-)`. Visible Weyl spinors are
complex two-component vectors `psi : Fin 2 -> C`. The bispinor of a null
edge is the rank-one Hermitian matrix `psi psi^dagger`. Mass squared is the
`2 x 2` complex determinant of the summed bispinor. All formulas are plain
ASCII to match repository text hygiene.

---

## Abstract

How can something with mass be built out of things that have none?

We give a precise, fully finite answer to one clean version of that old
question, and we verify every step of it by machine. Let `psi_1, ..., psi_n`
be complex two-component vectors ("null directions"), and let
`P = sum_i psi_i psi_i^dagger` be the sum of their rank-one Hermitian
squares. Then, exactly,

```text
det( sum_i psi_i psi_i^dagger )  =  sum_{i<j} | psi_i wedge psi_j |^2 ,
```

where `psi_i wedge psi_j = (psi_i)_0 (psi_j)_1 - (psi_i)_1 (psi_j)_0` is the
`2 x 2` bracket. The right-hand side is manifestly real and nonnegative, and
it vanishes exactly when all the vectors point along one common direction.
Every step is checked by the Lean 4 proof kernel. Grade: `M [comp]` - the
ingredients are classical; the finite bundle formulation, the exact massless
criterion, and the machine-checked packaging are the contribution.

The physics reading enters through one standard dictionary (also
kernel-checked): rank-one bispinors are future-pointing lightlike momenta,
and `det P` is invariant mass squared. Read that way, the identity says:

> A system assembled from lightlike constituents has invariant mass equal to
> the total pairwise DISAGREEMENT of their directions - and is massless
> exactly when they all point one way.

Mass is not a substance. In this exact finite sense, mass is a relationship:
the geometry of light that cannot agree on a direction. The paper states the
theorem, its gauge discipline (mass is an orbit invariant; any particular
decomposition into null pieces is a gauge choice), its covariance, its
celestial-sphere form (`m^2 = (E^2 - |C|^2)/4`: energy monopole minus
momentum dipole), and an updated map of exactly how much of a full
origin-of-mass account this theorem does and does not supply.

---

# Part I. How mass can come from light

## 1. A question that sounds silly until you try to answer it

Pick up a rock. It has mass: it resists being pushed, it presses down on
your hand. Now ask the childish question: what IS that? Where does the
number on the scale come from?

The twentieth century gave a surprising partial answer: most of the mass of
ordinary matter is not a property of its smallest pieces. It is something
the pieces DO together. This paper is about making one version of that
answer exact - so exact that a computer checks every line of the proof -
and about saying, with unusual honesty, which parts of the full story
remain open.

## 2. The clue: light has energy but no mass

A photon - a particle of light - has energy and momentum but zero mass. You
cannot bring a photon to rest; it always moves at speed `c`, and its energy
`E` and momentum `p` satisfy `E = |p| c`. In relativity, the mass of any
object is defined by the leftover in the famous relation

```text
m^2 c^4 = E^2 - |p|^2 c^2 .
```

For one photon the two terms cancel exactly: `m = 0`. Light is the extreme
case of "all energy, no mass." That sounds like the opposite of what we
want. It is actually the clue.

## 3. Two flashlights in a box

Now take TWO photons, flying in opposite directions, each with energy `E`.
Add up the system: total energy `2E`, total momentum `p + (-p) = 0`. Put
that into the mass relation:

```text
m^2 c^4 = (2E)^2 - 0  =>  m = 2E / c^2 .
```

The pair has mass - real mass, the kind a scale would weigh - even though
neither photon has any. Nothing was added. The mass is not IN either photon;
it lives in the relationship between them: they disagree about which way to
go, so their momenta cancel while their energies add.

Try the other case: two photons flying the SAME way. Total energy `2E`,
total momentum `2E/c`, and the mass relation gives `m = 0`. Agreement is
massless; disagreement weighs.

This is not a trick or an approximation. It is exact special relativity,
and it already contains the whole idea of this paper. What we add is the
general, sharp, machine-checked version: any number of lightlike pieces, an
exact formula for the mass in terms of the pairwise disagreements, and a
proof that mass vanishes exactly when there is no disagreement at all.

## 4. Your weight is mostly trapped light (well - trapped gluons)

Is this cute bookkeeping, or is it how nature actually works? Look inside a
proton. A proton is made of three quarks - but the quarks' own masses add
up to roughly one percent of the proton's mass. The other ninety-nine
percent is the energy of the gluon field and the quarks' relativistic
motion, confined into a sphere a femtometer across: nearly-lightlike stuff,
trapped, pointing every which way. The mass of the proton - and therefore
almost all of YOUR mass - is exactly the two-flashlight effect, realized by
quantum chromodynamics. Physicists call it "mass without mass." Our theorem
is the exact kinematic skeleton of that story: it says precisely how much
mass a bundle of lightlike constituents has, given only their directions
and energies. (What it does not do is solve QCD; see section 9.)

## 5. The Higgs, sized honestly

"But doesn't the Higgs field give things mass?" Yes - and it is worth
saying exactly what that means, because the popular version overstates it.
The Higgs mechanism gives mass to the elementary particles themselves: the
electron, the quarks, the W and Z bosons. Those masses matter enormously
(chemistry would not exist without the electron mass). But numerically they
are the one percent, not the ninety-nine: for the ordinary matter around
you, the Higgs contribution is a small correction on top of the trapped
gluon-light of section 4.

There is also a deeper point, and the program this paper belongs to takes
it seriously. In the Standard Model, a massless electron would be two
independent half-particles: a left-handed one and a right-handed one, each
moving at light speed. What the Higgs actually sells is a LICENSE for those
two to convert into each other. An electron at rest is, in this picture, a
lightlike zigzag: a left-mover flipping into a right-mover and back,
trapped in place by the flipping. The flip rate IS the mass. So even
"Higgs mass" is mass from trapped, disagreeing lightlike motion - the
disagreement here being between the two chirality directions. In the
minimal model this is now a machine-checked statement, not a metaphor: the
flip amplitude equals the geometric disagreement bracket of the theorem
below, exactly (Part II, sections 10-11 and 15).

## 6. Directions on the sky: making "disagreement" a number

To turn the story into a theorem we need one piece of standard technology.
Every lightlike direction - every "way a photon can point" - can be encoded
as a complex two-component vector

```text
psi = (psi_0, psi_1),
```

called a Weyl spinor, determined up to an overall complex scale. (If you
like pictures: the sky of all light rays through you is a sphere, and a
spinor is a stereographic address on that sphere. If you like linear
algebra: the matrix `psi psi^dagger` is the momentum.) The dictionary is
the standard "soldering" of relativity: a four-momentum `p` becomes the
`2 x 2` Hermitian matrix `p_0 I + p . sigma`, and rank-one matrices
`psi psi^dagger` are exactly the future-pointing lightlike momenta. In the
repository even this dictionary is machine-checked, including the sign and
cone conventions (`det = E^2 - |p|^2`, positivity on the future cone).

Given two spinors, there is a natural measure of their disagreement:

```text
psi wedge phi := psi_0 phi_1 - psi_1 phi_0 .
```

This "wedge" (the Pluecker bracket) is zero exactly when `phi` is a
multiple of `psi` - same ray, no disagreement - and grows with the angle
between the rays. Squaring its absolute value gives a real, nonnegative
disagreement score for the pair. One warning we keep explicit everywhere:
the wedge lives in the ANTISYMMETRIC pairing of the two spinors. Mass, in
this framework, is an antisymmetric-pairing invariant.

## 7. The theorem

Now take any finite number of lightlike pieces `psi_1, ..., psi_n`. Their
total momentum is the matrix sum `P = sum_i psi_i psi_i^dagger`, and the
system's invariant mass squared is `det P`. The theorem - the entire
technical heart of this paper - is:

```text
det( sum_i psi_i psi_i^dagger )  =  sum_{i<j} | psi_i wedge psi_j |^2 .
```

In words: **the mass squared of the bundle equals the sum, over every pair
of constituents, of that pair's disagreement score.** Nothing else
contributes. And the exact massless criterion follows: the bundle is
massless if and only if every constituent points along one common ray.

Three follow-up facts complete the package (all machine-checked, all stated
precisely in Part II):

- **Mass is an orbit invariant.** A massive `P` can be split into lightlike
  pieces in infinitely many ways. The theorem holds in EVERY split, with
  the same answer `det P`. So no particular decomposition is "the real
  one"; the splits are gauge choices, and for the minimal two-piece split
  the leftover freedom is exactly the rotation group `SU(2)` that massive
  particles are known to carry. Mass belongs to the orbit, not to a
  representative.
- **The sky formula.** Writing each piece as an energy `w_i` times a unit
  direction `n_i` on the celestial sphere, the same number becomes
  `m^2 = (E^2 - |C|^2)/4`, where `E = sum w_i` is the total energy (the
  "monopole" of the light on the sky) and `C = sum w_i n_i` is the total
  momentum (the "dipole"). Mass is the deficit by which the dipole fails
  to use up the monopole. All rays aligned: `|C| = E`, massless. Rays
  fanned out: `|C| < E`, massive.
- **Frame independence.** The determinant mass is invariant under
  `SL(2,C)`, the double cover of the Lorentz group: every inertial observer
  computes the same `m^2` from their own view of the sky.

## 8. What "machine-verified" means, and why we bother

Every theorem statement in Part II compiles in the Lean 4 proof assistant
against the Mathlib mathematical library, and the proof is accepted by
Lean's kernel - a small, heavily audited program that checks every
inference down to the axioms of mathematics. The repository additionally
pins the axiom footprint of each flagship result (`propext`,
`Classical.choice`, `Quot.sound` - the standard classical base - and
nothing else) with a guard that BREAKS THE BUILD if any hidden assumption
ever slips in.

Why go to this trouble for linear algebra? Two reasons. First, physics
history is full of "obvious" identities with wrong signs, silently swapped
conventions, and factor-of-two drift; this program's rule is that the
kernel, not the author, is the source of truth. Second, and more
important for what comes after this paper: the road from this clean
kinematic theorem toward dynamics, gauge fields, and gravity is exactly
where wishful thinking creeps in. A machine-checked floor plus a written
claim calculus is how the program keeps itself honest as the claims get
more ambitious. This paper is deliberately the most defensible step: one
theorem, fully checked, with its interpretation cleanly separated from its
mathematics.

## 9. What this paper does NOT claim

Honesty is a design feature of this program, so the boundary goes in the
body of the paper, in plain words:

- We do NOT derive the value of any mass. Not the electron's, not anyone's.
  The theorem computes the mass of a bundle GIVEN its constituents'
  directions and energies; it does not tell you which bundles nature makes.
- We do NOT solve QCD or derive confinement. Section 4's proton story is
  established physics quoted as context (`[import]`); our theorem is its
  kinematic skeleton only.
- We do NOT claim the lightlike decompositions are physically real objects.
  They are gauge representatives of an invariant (section 7); treating a
  gauge artifact as a thing is a named failure mode in this program, and we
  police it.
- We do NOT claim a completed dynamical theory. The dynamical statement we
  DO have at machine grade is minimal and one-dimensional: in the simplest
  zigzag model, the chirality-flip amplitude equals the wedge - "mass is
  the amplitude to turn," in one exactly solved case.
- Everything quoted from the ongoing research program beyond this theorem
  is labeled with its own grade in section 15 and is context, not a claim
  of this paper.

## 10. Where this is going (a graded preview, not a promise)

The program that produced this theorem has since taken two further
machine-checked steps that reframe it, and one round of expert analysis
that charts the road ahead. Briefly, with grades:

- **One carrier, three checked slots and one open mass slot (`M/OPEN`, draft
  namespace, 2026-07).** There is now a finite "carrier" operator `D` -
  built from null directions, transports, a chirality grading, and a turn
  amplitude - whose `D^2` square has a guard-pinned decomposition into three
  checked slots: aperture, gauge-curvature, and turn. The Krein `D^#D`
  upgrade with the soldering-gradient `E` slot is still OPEN. The aperture
  slot has an abstract total-square identity; the concrete identification
  with this paper's `det P` is the next registered target, not yet a claim.
  Unification, in this program, means DECOMPOSITION - one operator, separated
  channels - not a bigger symmetry group.
- **Masslessness is topological (`M`, draft namespace, 2026-07).** For such
  operators, the number of protected massless chiral modes is an index -
  fixed by the complex, invariant under EVERY choice of potential and
  transport. Mass explains what leaves the light cone; the index explains
  what must stay. The checked finite results include the index-protection
  algebra, a balanced positive-chirality witness, and a new finite unbalanced
  `(2,1)` Kugo-Ojima positive-sector witness paired with a same-charge `(1,2)`
  no-go. The carrier-level identification of this witness with the model's
  Gauss/closure constraints remains OPEN.
- **The road map (`MEMO` grade).** A 2026-07-07 consultation round produced,
  at working rigor with kernel transcription in progress: the exact finite
  state-space construction that would make spectral mass language legal
  (with the striking bookkeeping "dimension of the physical sector = the
  index"); an exact lattice chiral symmetry for the zigzag model whose
  grading is edge-orientation reversal; and one candidate first PHYSICAL
  number (a sum rule tying the observed charged-lepton mass combination to
  an equipartition condition - pre-registered with kill conditions, and
  emphatically not yet a claim).

None of that is this paper's result. It is listed so the reader can see
that the theorem below is a floor being built on, and can check - grade by
grade - how much weight the upper floors currently bear.

---

# Part II. The finite Pluecker-mass theorem

This part states the formal content precisely and points to the exact
kernel-checked Lean declarations. Every named theorem compiles under the
pinned toolchain `leanprover/lean4:v4.28.0` with no placeholders, except
where a declaration is explicitly marked *draft (kernel-clean)* or
*artifact*. Sections 1-5 are pure finite linear algebra about complex
two-component vectors; the words "null," "momentum," and "mass" acquire
physical meaning only through the soldering convention of section 1 and
the covariance statement of section 8. Nothing in the proofs depends on
the physics reading.

## 1. Setup and conventions

*Plain language: we define the objects - spinors, their rank-one squares,
and the wedge - and pin every convention.*

A **visible Weyl spinor** is a complex two-component vector
`psi : Fin 2 -> C` (`CSpinor`). Its **bispinor** is the rank-one Hermitian
square

```text
rankOneHermitian psi := psi psi^dagger = vecMulVec psi (star psi) ,
```

a `2 x 2` complex Hermitian matrix. In the standard soldering
`p_{A A'} = p_0 I + p . sigma`, `psi psi^dagger` is the bispinor of a
future-pointing null momentum: `det = p_0^2 - |p|^2 = 0`. The soldering
dictionary itself is kernel-checked in-repo
(`PhysicsSM.Draft.NullEdge.GateI1.Core`: `i1_1_soldering_det`,
`det_minkHerm_eq_minkowskiSq`,
`i1_2_spectralMinus_nonneg_iff_futureCone`; kernel-clean draft), so the
reading of `det` as the invariant mass square rests on a checked identity,
not a citation.

The **spinor Pluecker bracket** is

```text
spinorWedge psi phi := psi_0 phi_1 - psi_1 phi_0   in   Lambda^2(C^2) ~= C .
```

Convention warning (recorded in the Lean docstrings): the bracket lives in
the antisymmetric square `Lambda^2 S`, the singlet - NOT in `Sym^2 S`,
which carries field-strength data. Mass is a `Lambda^2` invariant. We write
`complexAbsSq z := z * conj z` so determinants and squared brackets can be
compared as complex numbers before reality is extracted.

Anchor: `PhysicsSM.Spinor.PluckerMass` (`CSpinor`, `rankOneHermitian`,
`spinorWedge`, `complexAbsSq`). Grade of sections 2-5: `M [comp]`, trusted
namespace.

## 2. One ray of light is massless

*Plain language: a single lightlike piece has zero mass - by determinant.*

```text
theorem det_rankOneHermitian_eq_zero (psi : CSpinor) :
    (rankOneHermitian psi).det = 0
```

## 3. Two rays: mass is the squared bracket

*Plain language: the two-flashlight box of Part I, as an identity.*

With `twoEdgeMomentum psi phi := rankOneHermitian psi + rankOneHermitian phi`:

```text
theorem two_edge_plucker_mass_identity (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = complexAbsSq (spinorWedge psi phi)

theorem two_edge_mass_zero_iff_wedge_zero (psi phi : CSpinor) :
    (twoEdgeMomentum psi phi).det = 0 <-> spinorWedge psi phi = 0

theorem spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero
    (psi phi : CSpinor) (hpsi : psi 0 != 0 \/ psi 1 != 0) :
    spinorWedge psi phi = 0 <-> exists c : C, phi = c . psi
```

Two null momenta form a massive system precisely when they are not
projectively collinear.

## 4. Any number of rays: the keystone

*Plain language: for a whole bundle, add up every pair's disagreement -
that IS the mass squared.*

For `psi : Fin n -> CSpinor`, define
`finBundleMomentum psi := sum_i rankOneHermitian (psi i)` and
`finPairwisePluckerMass psi := sum_{i<j} complexAbsSq (spinorWedge (psi i)
(psi j))` over the ordered-pair index set. The keystone:

```text
theorem fin_bundle_plucker_mass_identity {n : Nat} (psi : Fin n -> CSpinor) :
    (finBundleMomentum psi).det = finPairwisePluckerMass psi
```

The proof is a Cauchy-Binet / off-diagonal-folding argument: expanding the
`2 x 2` determinant of summed rank-one matrices, the diagonal cancels and
the `(i,j) + (j,i)` terms assemble into squared brackets (folding lemma
`sum_pairs_offdiag`).

## 5. Reality, nonnegativity, and the exact massless criterion

*Plain language: the mass squared is a genuine nonnegative real number, and
it is zero exactly for a single common beam.*

```text
theorem fin_bundle_det_im_eq_zero : ((finBundleMomentum psi).det).im = 0
theorem fin_bundle_det_re_nonneg  : 0 <= ((finBundleMomentum psi).det).re
theorem fin_bundle_det_eq_ofReal_nonneg :
    exists r : R, 0 <= r /\ (finBundleMomentum psi).det = (r : C)

theorem fin_bundle_mass_zero_iff_common_direction
    {n : Nat} (psi : Fin n -> CSpinor) (base : Fin n)
    (hbase : psi base 0 != 0 \/ psi base 1 != 0) :
    (finBundleMomentum psi).det = 0 <->
      exists c : Fin n -> C, forall i, psi i = c i . psi base
```

Any projective spread switches mass on. This is the precise form of the
Part I slogan.

## 6. Mass is an orbit invariant, not a property of a decomposition

*Plain language: a massive system can be split into light in infinitely
many ways; the mass belongs to the system, and each split is a gauge
choice. This section is the discipline that governs all our language.*

1. **The invariant.** `m^2 = det P` depends only on `P`. It is the only
   quantity this paper calls "mass."
2. **The identity holds in every gauge.** For EVERY finite decomposition
   `P = sum_i psi_i psi_i^dagger`, the pairwise-spread expression evaluates
   to the same `det P` (section 4) - a gauge-invariant quantity computed in
   a particular gauge.
3. **The minimal gauge freedom is the little group.** For the minimal split
   `n = 2` of a timelike `P`, the residual freedom in the two null spinors
   is precisely the massive little group `SU(2)` `[import:
   Arkani-Hamed-Huang-Huang]`. Mass is the orbit invariant of the
   null-splitting gauge orbit; the pair "concurrence" is its value in any
   gauge.

> **Mass is the orbit invariant of the null-splitting gauge; "concurrence"
> is its value in any gauge.**

Decompositions are never treated as ontic (failure mode F-RE, policed).
The normalized matrix `rho = P / Tr(P)` is only a frame-conditioned proxy
whose mixedness encodes `m/E` after an observer convention is fixed.
Registered formalization target: little-group transitivity on minimal
decompositions (`two_null_decompositions_little_group_orbit`), with the
observer-selected canonical split

```text
k_+ = ((E_u + s)/2)(u + n),  k_- = ((E_u - s)/2)(u - n),
E_u = p.u,  s = sqrt(E_u^2 - m^2),  n = (p - E_u u)/s ,
```

which makes the two-null picture canonical AFTER an observer is chosen,
and only then.

## 7. The celestial form: energy monopole, momentum dipole, mass deficit

*Plain language: paint the bundle on the sky - mass is how far the arrows
fail to add up to the brightness.*

With unit celestial directions `n_i`, weights `w_i`, total energy
`E = sum w_i`, closure vector `C = sum w_i n_i`, the standalone artifact
`NullEdgeSpinorNetworkClosure.Finite` proves

```text
theorem pluckerMass_eq_energy_sq_sub_closureDefect_sq :
    pairwiseAngularMass w u = momentMassSq w u
-- pairwiseAngularMass = sum_{i<j} w_i w_j (1 - n_i . n_j) / 2
-- momentMassSq       = (E^2 - |C|^2) / 4
```

so `m^2 = (E^2 - |C|^2)/4`. Guardrail (kernel-checked, load-bearing for the
program's P9 branch): closure `C = 0` is the REST FRAME, not "no source" -
a closed fan has maximal rest energy `E^2/4`
(`closed_spinorFan_is_restFrame`). *Status:* kernel-clean standalone
artifact; promote to the trusted namespace or cite as an appendix before
submission (tracked in the publication plan).

## 8. Lorentz covariance

*Plain language: every observer computes the same mass.*

```text
theorem finBundleMomentum_det_sl2_invariant
    {n : Nat} (A : Matrix (Fin 2) (Fin 2) C) (hA : A.det = 1)
    (psi : Fin n -> CSpinor) :
    (finBundleMomentum (fun i => spinorAction A (psi i))).det
      = (finBundleMomentum psi).det
```

*Status:* draft (kernel-clean), `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`;
convention review required before promotion. Frame-relative proxies
(`det(rho_vis) = det(P)/Tr(P)^2` measuring `(m/E)^2`; the observer-covariant
`rho_{p|u}` giving `2 sqrt(det rho_{p|u}) = m/(p.u)`) are kept strictly
separate from the invariant statement `det(P) = m^2`.

## 9. Twistor-chart matching

*Plain language: the same identity, in twistor coordinates, with both
normalization conventions pinned so no factor of two can drift.*

From the trusted `PhysicsSM.Spinor.TwistorPluckerMass`:

```text
theorem two_twistor_mass_invariant_eq_plucker (Z W : SpinorChartTwistor) :
    twoTwistorMassInvariant Z W = complexAbsSq (spinorWedge Z.pi W.pi)
theorem multi_twistor_momentum_det_eq_pairwiseMass
    {n : Nat} (Z : MultiTwistorChart n) :
    (multiTwistorMomentum Z).det = multiTwistorPairwiseMass Z
```

plus the explicit det-vs-trace convention pair. Scope: finite spinor chart
only; projective twistor space and the Penrose transform are out of scope.

## 10. The first-order (Dirac) square root - bridge to P2

*Plain language: there is a natural "square root" of the mass formula, and
it is the seam to the next paper.*

```text
theorem chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass : ...
```

(`PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`, draft/kernel-clean).
This is the square root of the STATIC mass - a forward pointer, not a
result of this paper. The dynamical target it points at is the null-step
transfer `U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x)` with
quasienergy `cos(omega a) = cos(k a) cos(mu a)` and chirality coherence
tending to `m/E` `[import: standard checkerboard dispersion]`; P2/P4 scope.

## 11. The chirality substrate and the dynamical bridge

*(Context section; grades `M [orig-packaging]` for the named Lean content;
nothing here is a claim of this paper.)*

*Plain language: for "mass = the amplitude to flip chirality" to even make
sense, left and right must be exactly defined on a finite substrate - a
famously delicate demand - and the flip amplitude must provably equal the
geometric bracket. Both halves are now machine-checked at the free /
minimal level.*

- **Free Ginsparg-Wilson release (Gate C1).** For the tetrahedral rank-4
  free lattice kernel: a gapped Hermitian symbol and operator, an overlap
  operator satisfying `gamma5 D + D gamma5 = D gamma5 D`, and exact Weyl
  projectors (`PhysicsSM/Draft/NullEdge/GateC1/`). Kernel-checked draft.
- **Chiral index calculus (Gate C2).** The lattice chiral index is an
  integer; certified-sign machinery with existence/uniqueness; index =
  half signature difference; unitary invariance; an explicit pi-flux
  witness with nonzero index; and the finite VANISHING theorem - an
  invertible (mass-admitting) overlap operator forces index `0`, so a
  nonzero chiral index forces an exact zero mode
  (`overlapIndex_eq_zero_of_isUnit_dov`,
  `exists_zero_mode_of_overlapIndex_ne_zero`,
  `flux_witness_has_zero_mode`). "Topological protection of masslessness,"
  machine-checked in both directions at the free level.
- **The minimal dynamical bridge (1+1D, kernel-checked 2026-07-03).** In
  the minimal zigzag model the chirality-flip amplitude EQUALS the Pluecker
  wedge of the canonical two-null split of the on-shell momentum
  (`onshell_wedge_normSq_eq_coin_sq`): the geometric mass of this paper and
  the coupling mass of the flip are ONE scalar in the one exactly solved
  case. The gauge-dressed, 3+1D generalization is the open keystone of the
  legality layer (section 15, layer 4); until it is proved, the program
  does not count "Higgs mass" and "Pluecker mass" as separate
  contributions.
- **New since v2 (2026-07-07, draft namespace, guard-pinned).** The index
  story now extends beyond the substrate to the operator layer itself: the
  finite McKean-Singer protection family
  (`PhysicsSM/Draft/NullEdge/Carrier/CarrierIndexProtection.lean`) proves
  the chiral index equals the graded dimension for every rank-symmetric
  carrier - automatic for Hilbert- AND Krein-self-adjoint ones - with
  explicit two-pole witnesses (a balanced complex, fully gappable, with
  strictly positive flat mass form; an unbalanced complex with a forced
  massless mode for every dynamics). A separate Q01 finite Kugo-Ojima witness
  now proves that the unbalanced `(2,1)` case can carry a nonvacuous positive
  quotient, while the same charge in inertia `(1,2)` is a no-go for positivity.
  Masslessness of a chiral surplus is a property of the complex, not of the
  dynamics.

## 12. Relation to prior work

Massive spinor-helicity (Arkani-Hamed-Huang-Huang, `1709.04891`): a massive
momentum as a pair of `SU(2)` little-group spinors; the present identity is
the finite-bundle generalization, with mass as TOTAL pairwise spread
`[comp/orig packaging]`. The two-photon box is textbook relativity
`[import]`. "Mass without mass" for QCD is established physics `[import]`.
The zigzag/chirality-flip picture of the massive electron is standard in
spirit (Feynman checkerboard; Penrose's zigzag) `[import]`; its exact
finite bracket identity at 1+1D is program-original `M [orig]`. The
celestial monopole/dipole form connects to the celestial-sphere kinematics
literature `[comp]`. Full citations with verification status are carried in
the program bibliography; two imports (the Wilczek "mass without mass"
essay and Koide's original) remain flagged for source verification before
submission.

## 13. Claim boundary (formal)

The claims of this paper are exactly: sections 2-5 (`M [comp]`, trusted),
section 6's discipline (with the little-group transitivity registered as a
target, `[import]` for the classical fact), section 7 (`M`, artifact),
section 8 (`M`, draft), section 9 (`M`, trusted), section 10's static
identity (`M`, draft). Everything in sections 11 and 15 is context at its
own grade. No mass value, no dynamics beyond the cited 1+1D bridge, no
spectral statement anywhere (the program's positivity crux gates all
spectral language; see layer 4).

## 14. Theorem-to-Lean map

| Statement | Lean anchor | Status |
|---|---|---|
| Soldering dictionary, future cone | `GateI1.Core` (`i1_1_soldering_det`, ...) | draft, kernel-clean |
| One ray massless | `det_rankOneHermitian_eq_zero` | trusted |
| Two-ray identity + iff | `two_edge_plucker_mass_identity`, ... | trusted |
| Keystone bundle identity | `fin_bundle_plucker_mass_identity` | trusted |
| Reality, nonnegativity | `fin_bundle_det_*` | trusted |
| Exact massless criterion | `fin_bundle_mass_zero_iff_common_direction` | trusted |
| Celestial moment form | `pluckerMass_eq_energy_sq_sub_closureDefect_sq` | artifact |
| Rest-frame guardrail | `closed_spinorFan_is_restFrame` | artifact |
| SL(2,C) invariance | `finBundleMomentum_det_sl2_invariant` | draft |
| Twistor chart | `two_twistor_mass_invariant_eq_plucker`, ... | trusted |
| Static Dirac square root | `chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass` | draft |
| GW substrate + index + vanishing | Gate C1 / C2 modules | draft |
| 1+1D flip = wedge | `onshell_wedge_normSq_eq_coin_sq` | draft |
| Carrier index protection (context) | `Carrier/CarrierIndexProtection.lean` | draft, guard-pinned |
| Carrier Weitzenbock + witness (context) | `Carrier/` + `CarrierAxiomGuard.lean` | draft, guard-pinned |

## 15. How close is this to a full origin of mass? The layered status map

*Plain language: the honest dashboard. Each layer says what is closed, at
what grade, and what is still open. This is the section to reread before
believing anything anyone says about this program.*

### Layer 1 - Kinematic: what mass IS, given lightlike constituents. CLOSED.

The theorem of this paper (`M`, trusted): mass = total pairwise
disagreement; exact massless criterion; orbit invariance; covariance;
celestial form.

### Layer 2 - Dynamical: mass as the rate of chirality exchange. CLOSED at 1+1D; 3+1D open.

The minimal model is machine-checked end to end: dispersion, exact
coherence `m/E`, and the bridge identity "flip amplitude = Pluecker wedge."
New context (2026-07-07, `MEMO` + Aristotle jobs in flight): the zigzag
transfer operator satisfies an EXACT Ginsparg-Wilson relation with
`R = 1/2` whose grading is chirality composed with spatial reflection
(edge-orientation reversal), and "retardedness IS the hidden Wilson term"
as an exact dispersion identity - tightening the claim that the 1+1D
story survives discretization with exact chiral bookkeeping. 3+1D
packaging remains open.

### Layer 2.5 - Operator: one carrier, checked D^2 slots plus open Krein/E slot. NEW; draft grade, 2026-07.

The finite carrier `D = sum_e c(alpha_e) nabla_e + Gamma phi` on a
decorated 2-complex satisfies, kernel-checked and guard-pinned
(`CarrierAxiomGuard.lean`):

```text
4 D^2 = Q_A + Q_C + 4 Q_T            (covariantly constant soldering)
```

The intended Krein mass form is still a registered target:

```text
4 D^#D = Q_A^# + Q_C^# + 4 Q_T + 4 E (OPEN; varying soldering; # = Krein slot)
```

The aperture block currently has an abstract total-square identity
`Q_A = Q(sum_e alpha_e)`. Its concrete identification with this paper's
Minkowski `det P` is still OPEN, so the four-slot mass identity remains an
open target. A balanced `kappa = 2` witness has a positive mass form on a
positive-chirality Hilbert half; this is not an indefinite/Pontryagin
positive-sector certificate. A load-bearing finite unbalanced positive-sector
witness is now guard-pinned as Q01 linear algebra, but its carrier/Gauss
constraint interpretation remains OPEN. Everything here is form-level; no
spectral claim (see layer 4).

### Layer 3 - Substrate: exact chirality available to be coupled. CLOSED at the free/regulator level.

Gate C1 (free GW release), Gate C2 (chiral index calculus + the vanishing
theorem: gap forces index zero; nonzero index forces a zero mode), and -
new - the carrier index-protection family: the protected massless chiral
count equals the graded dimension under the stated finite hypotheses. The
physical Krein `#` restatement is still open; the unbalanced positive-sector
witness is proved only as finite Kugo-Ojima linear algebra, pending
carrier/Gauss wiring. Masslessness of the surplus is topology; mass generation
gaps modes only in pairs.

### Layer 4 - Legality: what supplies and licenses the coupling. POSED; the state-space half now has a MEMO-grade solution.

Standard-Model input `[import]`: the Yukawa/Higgs insertion is the legal
left-right coupling. Program keystone target: the no-double-counting
bridge, whose minimal 1+1D instance is proved (layer 2). The other half of
legality - WHICH state space makes mass a legitimate spectral quantity -
was this program's hardest open problem ("physical-sector positivity").
Status 2026-07-07 (`MEMO` grade; kernel ladder in flight, Aristotle):
reduced to an explicit finite boundary at working rigor. State positivity is
Witt geometry of the constraint span (isotropy + count + a finite Ward
identity), definitizability is vacuous in finite dimensions, and the proposed
physical sector's dimension equals the chiral index:
`dim(V'/N) = ind(D)` - the index does not merely protect massless modes,
it counts the states that survive gauge. Until the kernel transcription
lands, all spectral language remains forbidden in this program, including
in this paper.

### Layer 5 - Values: the actual spectrum. OPEN, with exact boundaries and one new pre-registered gate.

No mass value is computed, and this paper claims none. The Round 7/8
boundaries stand (derived structures; the seesaw scale postdiction
`[import/comp]`; hierarchies as a named mechanism class; absolute scales
binned as bedrock). Two updates. (i) The naive Koide gate F2.0 was killed
by proof on 2026-07-03 (kernel-checked no-go: invariant-potential critical
points force degenerate eigenvalues). (ii) A NEW formulation entered on
2026-07-07 at `MEMO` grade with a kernel job in flight: the equipartition
sum rule - for a uniform "turn" channel soldered to its incident "hop"
channels (turn power = hop power), the trace identity
`tr M^2 = (2/V)(tr M)^2` holds exactly, giving the Koide combination
`Q = 2/V`, i.e. `2/3` for three modes, with the empirical
`9 x 10^-6` pole-mass precision explicitly DISCLAIMED as below this
framework's honest resolution (permille matching floor). Gate M-KOIDE is
pre-registered with kill conditions, the load-bearing one being the
derivation (or refutation) of the soldering coefficient from carrier
axioms. Until that derivation exists, this is a registered gate, not a
result.

### Layer 6 - Composite mass: QCD and the proton. IMPORTED CONTEXT.

Ninety-five-plus percent of visible mass is confined field energy -
established QCD, of which this program derives nothing. The Pluecker
theorem is that story's exact kinematic skeleton, no more.

### The composed answer

> Given lightlike constituents, what mass is - and exactly when it
> vanishes - is a closed, machine-checked theorem (layer 1). That theorem
> is now the target first channel of a guard-pinned carrier decomposition:
> three `D^2` slots are checked, while the Krein/E slot and concrete
> carrier-to-`det P` identification remain open (layer 2.5). That the
> substrate can host exactly-chiral
> fermions, and that a chiral surplus is topologically protected against
> the modeled carrier deformations, is machine-checked under stated finite
> hypotheses (layer 3). That mass is the
> rate of legal chirality exchange is machine-checked in the minimal
> model, now with an exact lattice chiral symmetry protecting it (layer
> 2). Which state space makes mass a spectrum has a solution at working
> rigor whose kernel transcription is in flight - with the beautiful
> bookkeeping that the physical sector's size IS the index (layer 4). What
> the values of the masses are remains open: one killed gate, one newly
> registered gate with its make-or-break derivation named, honest bedrock
> bins for the rest (layer 5). Hadronic mass is imported context (layer
> 6).

In one sentence: **the program can now state, at machine-checked grade,
what mass is and why some things must stay massless; it has a guard-pinned
carrier decomposition that points to where the same invariant should live
inside one operator, but its Krein/E mass form and concrete `det P`
identification are still open; it can state at working rigor how mass becomes
a spectrum and how large the physical world of such a model is; and it
cannot yet state, at any grade, why the electron weighs what it weighs - and
it says so.**

---

## Change log

- **v3 (2026-07-07).** Full rewrite for clarity and impact; Part I
  rewritten to college-student accessibility with the claim calculus
  explained inline; Part II statements unchanged, each section given a
  plain-language opener; theorem-to-Lean map extended with carrier
  anchors; status map updated: new layer 2.5 (carrier/Weitzenbock `D^2`
  decomposition at draft grade, with the Krein/E and concrete `det P`
  identifications open), layer 3 extended by the index-protection family,
  layer 4 updated with the MEMO-grade positivity boundary and the `dim = ind`
  bookkeeping, layer 5 updated with the killed F2.0 gate and the newly
  pre-registered equipartition gate M-KOIDE. All 2026-07-07 program results
  cited at `MEMO` or draft grade only; the paper's own claims unchanged from
  v2.
- **v2 (2026-07-03).** Interpretation-free core statement; orbit-invariant
  correction; claim calculus; Omega-firewall; layered status map.
  (Superseded; retained at
  `Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`.)
- **v1 (2026-06-25, + addendum 2026-06-27).** First draft. (Superseded.)

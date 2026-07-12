# Jordan-Clifford bridge program

This memo incorporates the 2026-07-11 Pro analysis into the 24-hour run. It
defines a theorem program, not a claim that the synthesis is already proved.
Every recent external result below must be checked in primary full text before
it enters manuscript prose, and every repository claim must be tied to a live
Lean declaration and axiom audit.

## 1. Central target

Investigate whether a nested Jordan flag

```text
X ~= h_2(C)  subset  B ~= h_3(C)  subset  J = h_3(O)
```

canonically and equivariantly determines one coherent package:

```text
weak space W ~= C^2
color space V ~= C^3
Standard Model group S(U(W) x U(V))
Jordan complement B_perp ~= U tensor V*
Furey color module ~= exterior(V)
one-generation chiral module ~= exterior_even(W direct_sum V).
```

The desired paper-level master theorem is a dependency chain joining these
objects. Dimension matching is not enough. Each arrow must specify its choices,
equivariance, kernel, convention, and uniqueness or residual moduli.

## 2. Evidence grades at startup

- The Baez-Schwahn stabilizer and transitivity statements reported for
  arXiv:2606.15235 are external theorem candidates. They are not yet
  kernel-checked repository results.
- Existing project modules contain trusted octonion, left-action, gauge,
  charge, and triality ingredients. Their exact statements must be opened and
  audited before being used in the bridge.
- The exterior-algebra and five-mode synthesis is a proposed composition until
  its maps, actions, and kernels are formalized.
- The local order-parameter and field-theory layers are research programs, not
  consequences of representation theory alone.

## 3. Immediate theorem ladder

### JC1. Jordan flag and stabilizer

1. Verify the exact hypotheses, connected-component notation, action, and
   transitivity statement in Baez-Schwahn 2026.
2. Map their conventions to the project's XOR octonion convention through the
   existing convention bridge.
3. State a clean-room Lean API for the nested flag and stabilizer intersection.
4. Formalize the smallest nontrivial rungs first: the selected complex spaces,
   determinant constraint, inclusions, and action kernels.
5. Treat the full `F4` stabilizer theorem as external `T` until a kernel proof
   lands; never relabel a coordinate witness as an intrinsic classification.

### JC2. Furey ideal as an exterior algebra

1. Recover the color space `V` from the same selected octonion complex
   structure used in the Jordan lane.
2. Construct an explicit equivariant map between the associative left-action
   Clifford module and `exterior(V)`.
3. Identify creation with wedge and annihilation with contraction.
4. Prove degree decomposition `1 + 3 + 3bar + 1`, including the exact
   fundamental/antifundamental convention.
5. Supply a nonidentity `SU(3)` action witness and a convention-reversal
   control.

Status: `PhysicsSM.Draft.JordanCliffordFureyFockBridge` now proves the exact
occupancy bijection, all 48 signed creation/contraction table matches, and a
basis-for-basis linear equivalence from the corrected concrete `Jbar'` span to
three-mode exterior coordinates. This is stronger than dimension matching but
still one rung short of item 2 as stated: the whole-submodule restricted left
multiplications and their linear intertwining are in flight as Aristotle
`40a38072-7634-4708-9721-4123cdd253e7`. The `SU(3)` equivariance and its
fundamental/antifundamental convention remain open.

### JC3. Correct occupation dictionaries

Formalize the two conjugate ideals separately. For the original Furey
convention under review, the target audit table is:

| Degree | Color type | Charge | Label |
| --- | --- | --- | --- |
| 0 | singlet | 0 | neutrino |
| 1 | antitriplet | +1/3 | anti-down |
| 2 | triplet | +2/3 | up |
| 3 | singlet | +1 | positron |

The conjugate ideal carries the opposite charges and conjugate particle
content. Verify this table against the primary Furey source and the repository
conventions before publication.

Mandatory semantic guards:

- representation conjugacy is not particle-antiparticle conjugacy;
- the primitive idempotent called a vacuum is not the QFT vacuum;
- occupation degree is an algebraic grading, not constituent compositeness;
- empty and full color states do not automatically form a weak doublet.

### JC4. Five-mode generation module

1. Derive, rather than merely posit, commuting weak and color spaces
   `W ~= C^2` and `V ~= C^3` from the Jordan/quaternionic/octonionic data.
2. Construct `E = W direct_sum V` and `exterior_even(E)`.
3. Prove its complex dimension is 16 and derive the complete representation
   table, including right-handed neutrino conventions.
4. Prove which states are weak doublets and which are singlets; do not infer
   this from degree alone.
5. Define and audit `Y = -(1/3) N_V + (1/2) N_W` in the convention
   `Q = T3 + Y`.
6. Identify the Higgs representation and any additional intertwiners needed;
   if they are inputs, label them as inputs.

### JC5. Representation-level global quotient

Prove the exact central kernel of the **covering-group** action on the complete
exterior-algebra fermion module. The distinction is load-bearing:
`S(U(2) x U(3))` is the faithful quotient group, while `Z6` is the kernel of
the cover `SU(3) x SU(2) x U(1)` acting on the fermions. The goal is stronger
than an abstract quotient-group isomorphism:

```text
kernel(cover action on exterior_even(W direct_sum V)) = Z6
```

with the determinant constraint and all charge normalizations explicit. Include
one central element that acts trivially and nearby central elements that do not.

The finite modular-arithmetic backbone is now landed in
`PhysicsSM.Draft.JordanCliffordFermionKernel`: it proves that the central phase
kernel on the six even weak/color bidegrees is exactly the injective image of
the six standard powers. The open rung is transporting that finite kernel to
the actual group representation and composing it with the derived `W,V`
module, not recounting six elements.

The next finite composition is now landed in
`PhysicsSM.Draft.JordanCliffordSpinorZ6Bridge`: for every five-mode occupation
state, the trusted Fock hypercharge equals the primitive center phase
`3 N_W - 2 N_V`; on the even sector this composes with the trusted
one-generation multiplet table. Each finite kernel label is paired uniquely
with one explicit trusted unit-level covering-kernel witness mapping to the
identity. This correspondence by itself does not identify the kernel types or
actions; the later exact algebraic action-kernel theorem below supplies that
identification on the true product-cover domain.

Hostile audit `83a0b810-896e-4166-b997-5f953874d93e` independently confirmed
the arithmetic and identified two high scope gaps. The finite bridge now
closes both as far as possible without inventing a group action: it quantifies
over every actual even five-mode occupation, proves equality with the six
standard powers, adds a mixed near-miss control, and gives each label a unique
trusted explicit unit-level covering-kernel witness mapping to identity. The
next rung was to package the phase rule itself as a homomorphism and then prove
the full action-level kernel theorem.

The finite homomorphism rung is now landed in
`PhysicsSM.Draft.JordanCliffordFinitePhaseCharacter`: the finite center labels
act through an additive character on all actual even occupations, and its
kernel is exactly the six standard powers.

The first algebraic representation half is now landed in
`PhysicsSM.Draft.JordanCliffordExteriorCoverAction`. It packages the trusted
unit-cover block action on the supplied five-dimensional weak-plus-color space
as a linear action, lifts it through Mathlib exterior powers, and obtains a
monoid representation on exterior degrees `0`, `2`, and `4`. The module proves
this even exterior space has complex dimension sixteen and that every one of
the six trusted unit-level covering-kernel elements acts as the identity.

The converse exactness rung is now landed in
`PhysicsSM.Draft.JordanCliffordExactExteriorKernel`. Identity of the full
sixteen-state action forces identity of its degree-two mixed minors; the shared
cover phase and determinant-one constraints then force both weak and color
blocks to be identity. Consequently, on the true algebraic product-cover
domain, the action kernel is exactly the six standard elements, with an
outside-family nontriviality theorem. This closes the action-level `Z6` gate
for the supplied carrier. It is not a topological or smooth Lie-group quotient
theorem, does not derive the `2+3` split from the Jordan flag, and does not
identify the exterior module with Furey's left-action module.

The coordinate first-factor stabilizer rung is now landed in
`PhysicsSM.Draft.JordanCliffordH2BlockStabilizer`. For a unitary complex
`3 x 3` matrix, preserving the upper `2 x 2` matrix block under conjugation is
equivalent to block diagonality for the `2+1` split, with the expected
determinant factorization. A nonidentity determinant-one block witness and a
unitary mixing counterexample keep the theorem nondegenerate. This is only the
coordinate `SU(3)` factor modeled on the source calculation; Baez--Schwahn's
intrinsic `F4` transitivity, intersection, and identity-component statements
remain external.

The weak/color vector-space derivation is now materially stronger. The trusted
`PhysicsSM.Spinor.SpinorTenfoldColorAxis` module already identifies the common
annihilator of the marked normal-form pure-spinor pair with `C^3`. New trusted
module `PhysicsSM.Spinor.SpinorTenfoldWeakQuotient` regards that color axis as
a submodule of the first five-dimensional annihilator and defines the
canonical quotient `N1 / (N1 ∩ N2)`. Its weak-coordinate map is surjective,
has exactly the color axis as kernel, and therefore gives a linear equivalence
of the quotient with `C^2`; an explicit quotient class is nonzero. Thus the
pair derives color `C^3` and a weak `C^2` candidate at the vector-space level
without choosing a complement. JC4's decisive successor is
equivariance: prove the relevant stabilizer preserves the color submodule,
descends to the quotient, and acts as the physical `SU(3)` and chiral
`SU(2)_L` factors with the stated hypercharge convention.

Trusted module `PhysicsSM.Spinor.SpinorTenfoldWeakQuotientDescent` now lands
the exact conditional interface for that successor. Any complex-linear
endomorphism of the first annihilator preserving the color axis descends
functorially to the weak quotient, and the descended operator is the identity
if and only if every upstairs displacement lies in the color axis. The module
also transports the result to the proved `C^2` coordinate model. What remains
load-bearing is no longer quotient mechanics: it is proving invariance for the
actual marked-pair stabilizer and identifying the resulting group action and
chirality.

The first explicit infinitesimal action and its exact coordinate matrix have
now landed in trusted modules
`PhysicsSM.Spinor.SpinorTenfoldWeakQuotientSO10Generator` and
`PhysicsSM.Spinor.SpinorTenfoldWeakQuotientSO10Coordinates`. The complex
`so(10)` generator `e_3 wedge f_4` preserves the normal-form first annihilator
and common color axis, acts nontrivially on the quotient, and is exactly
`(w_3,w_4) |-> (0,-w_3)` in the derived two-coordinate model. Independent
controls show that preserving the annihilator and preserving color are
separate gates. This is a concrete raising operator, not yet an `sl(2)` triple,
compact real form, pair stabilizer, group action, or physical `SU(2)_L`.

## 4. Second-wave research directions

### Local order parameter

Develop the preferred octonion direction as a section of an associated
seven-dimensional bundle for a principal `G2` bundle. Where nonzero, its
normalized direction should define an `SU(3)` reduction and a local color/Fock
bundle. Distinguish gauge-removable orientation from the invariant content in
the covariant derivative, curvature, radial mode, and global topology.

The stronger Jordan-flag order parameter should be studied through an
`F4 / S(U(2) x U(3))`-type homogeneous space only after the stabilizer source
and conventions are verified. Do not infer a viable four-dimensional `F4`
fermion unification: chirality is an explicit gate.

### Electroweak derivation

Test whether quaternionic and octonionic constructions canonically produce two
commuting Clifford systems on `W` and `V`, with the physically correct left and
right actions. Success requires deriving `SU(2)_L` chirality, weak singlets,
hypercharge, the right-handed sectors, the Higgs representation, and the fate
of unwanted proton-decay generators.

### Three generations

Compare the Furey-Hughes triality proposal with the reported 2026 Gresnigt
`S3` construction inside `Cl(10)`. Compare the actual ideals, commutants,
Higgs/Yukawa intertwiners, and possible restriction or quotient maps. Merely
producing three copies is not success; seek constraints on mixing, CP,
neutrinos, and the number of light Higgs doublets.

### Field theory and predictions

Keep a separate ledger of what representation theory does not supply: local
fields, kinetic terms, action, covariant derivatives, symmetry-breaking
potential, Yukawa operators, anomalies, RG flow, and vacuum selection. Rank
phenomenology by falsifiability: extra `G2/SU(3)` vectors, baryon-number and
proton-decay rules, Higgs count, flavor-changing currents, neutrino channels,
coupling relations, and weak-mixing-angle predictions.

## 5. Success and kill conditions

Best success: a kernel-checked dependency chain from one Jordan flag to the
gauge group, DVT complement, Furey exterior module, complete generation, and
exact representation kernel.

Valuable partial success: one equivariant bridge theorem with explicit
conventions, or a no-go showing that one advertised arrow requires an
additional noncanonical choice.

Kill or demotion conditions:

- only dimensions match, with no natural equivariant map;
- weak structure is appended rather than derived;
- the `Z6` is imposed group-theoretically but not recovered from the fermion
  action;
- raw octonion multiplication is confused with the associative left-action
  algebra;
- a real or pseudoreal exceptional representation cannot supply the required
  chiral theory without extra structure;
- no action or held-out observable follows from the algebra.

## 6. Source-verification queue

Primary sources named by the Pro memo, pending full-text verification:

- Furey, arXiv:1603.04078;
- Baez-Schwahn, arXiv:2606.15235;
- Baez-Huerta, arXiv:0904.1556;
- Wellegehausen, "Phase diagram of the G(2) Higgs model and G(2)-QCD",
  arXiv:1111.0496, plus the more direct symmetry-breaking statements in
  arXiv:hep-lat/0302023 and arXiv:hep-lat/0610076;
- exceptional-Jordan/Standard-Model work at arXiv:2006.16265;
- Furey-Hughes, arXiv:2210.10126 and arXiv:2409.17948;
- Gresnigt, arXiv:2601.07857 and any cited companion Higgs/Yukawa paper.

Use full text, not search snippets or this memo, to establish theorem content.
Record theorem numbers, hypotheses, conventions, licenses, and the exact
manuscript sentence each source supports.

## 7. Deliberate deprioritization

Until the bridge has a theorem-level spine, deprioritize broad information
ontology, larger-exceptional-group escalation, and mass numerology. The near
term test is whether the modest Jordan flag actually forces more of the
Standard Model architecture than a collection of parallel correspondences.

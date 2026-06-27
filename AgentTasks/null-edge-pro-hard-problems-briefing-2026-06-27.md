# Null-edge project: three hard problems for ChatGPT Pro

Date: 2026-06-27.

Purpose: paste-ready briefing for ChatGPT Pro. The goal is not a general review.
The goal is to ask Pro to attack the hardest remaining mathematical problems in
the null-edge/Furey unified mass program and return concrete theorem targets,
hand proofs, failure criteria, and literature-backed recommendations.

## Project snapshot

We are building a formal Lean-backed research program around this thesis:

```text
Primitive spacetime transport can be organized as null-edge transport.
Effective mass appears as a canonical quadratic obstruction to remaining a
single free gapless null mode.
```

The claim hierarchy is strict:

```text
Representation:
  Standard physics data are placed on null-edge variables.

Reconstruction:
  A theorem recovers a known mechanism from null-edge primitives, with inputs
  still free.

Structural theorem:
  A qualitative feature is forced once specified algebraic inputs are assumed.

Prediction:
  A normally free EFT parameter or structure is fixed or restricted.
```

Current safe claim:

```text
The program has strong finite reconstruction and structural-theorem evidence.
It has not yet produced a numerical Standard Model mass prediction.
```

## What has been shown so far

P1 finite kinematic theorem:

```text
For a finite family of null spinor momenta psi_i,

det(sum_i psi_i psi_i^dagger)
  = sum_{i<j} |psi_i wedge psi_j|^2.

Massless iff all nonzero psi_i are projectively collinear.
```

Interpretation:

```text
Composite invariant mass is Plucker spread, or failure of a null bundle to
remain rank one.
```

Operator reconstruction:

```text
D_h = i D_N + Gamma_s Phi_H
D_N = sum_a c(alpha^a) nabla_a
```

Target square:

```text
D_h^2 =
  -K_null
  -C_diamond
  -T_frame
  +Phi_H^2
  -i Gamma_s sum_a C_a [nabla_a, Phi_H].
```

Convention guardrail:

```text
Phi_H may be odd under internal grading chi_E.
Phi_H must be Gamma_s-even in this super-Dirac convention if Phi_H^2 is to
enter with the positive sign.
```

Electroweak/FMS reconstruction:

```text
Gauge holonomies live on null edges.
The Higgs field is a covariant internal reference section.
Holonomies preserving the Higgs section remain gapless.
Holonomies moving it acquire quadratic orbit stiffness.
```

Finite electroweak theorem status:

```text
ker q = u(1)_em;
rank q = 3;
W/Z leading terms are reconstructed as gauge-invariant orbit stiffness.
```

Furey/Baez/internal algebra status:

```text
Furey/Baez/DVT supplies a promising finite internal spectral-triple half:
internal Hilbert space, internal grading chi_E, Standard Model-like charge
data, anomaly inheritance, and legal-Yukawa bookkeeping.
```

Guardrail:

```text
Furey helps Gate H, the internal-spectrum/anomaly/Yukawa-legality gate.
Furey does not by itself solve the null-edge kinetic/doubler problem.
```

## Gate C is the current binding blocker

Gate C asks whether the flat null-edge Dirac seed can support a physically
acceptable chiral branch sector.

The bare flat operator is:

```text
D_+(q) = sum_a C_a (exp(i q_a) - 1) / h = c(p(q)).
```

Critical correction:

```text
Coefficient-vector zeros p(q)=0 are not the physical test.
The physical branch test is det D_+(q)=0, equivalently p(q)^2=0 in the flat
massless Clifford-symbol setting.
```

Kernel-checked results already found:

```text
C21:
  The actual four-component tetrahedral Clifford symbol has a two-dimensional
  chiral-balanced kernel at each nonzero null branch.
  Bare ordinary chirality does not assign a single sign to a branch.
  Bare OperatorForcesAlignment is false.

C43/C44:
  Known high branches lie on exact determinant-zero nodal curves reaching the
  origin.

C64:
  The known branch lines do not exhaust the determinant-zero locus.
  There is an explicit off-branch determinant zero:
    q_star = (2*pi/3, 0, 0, 4*pi/3).
  The simple g5/T_lin split misses this zero.

C66:
  Cyclotomic/orbit-style off-branch zero structure is being explored.

C22/K2:
  Krein signature and chirality pattern can pull apart.
  J-self-adjointness alone does not imply positivity or stability.
```

Therefore the old target is dead:

```text
Do not release Gate C for the bare D_+.
```

The current target is:

```text
Release Gate C, if possible, for a specified regulated/projected physical
operator D_phys built from the null-edge kinetic seed.
```

## Current strategic pivot

The null-edge seed should be treated like a lattice kernel:

```text
bare D_+:
  null kinetic seed;
  FATAL-FOR-NAIVE-FLAT as a physical chiral operator.

D_phys:
  regulated/projected operator built from branch projectors, flavored mass,
  spectral flow, overlap/domain-wall-like projection, or another controlled
  physical-sector construction.
```

Recent Claude/Codex consensus:

```text
Scalar Wilson positivity is useful but not enough.
The more literature-aligned centerpiece is flavored mass / point splitting /
Hermitian spectral flow, with scalar Wilson positivity as a branch-lifting
lemma.
```

Scalar Wilson support lemma:

```text
W(q) = sum_a (1 - cos q_a).

On the real torus:
  W(q) >= 0;
  W(q)=0 iff q=0 mod 2*pi.

At q_star = (2*pi/3, 0, 0, 4*pi/3):
  W(q_star)=3.
```

This would lift non-origin real-torus zeros, but by itself it does not solve
chirality.

## Main danger: chirality versus Krein

Overlap/Ginsparg-Wilson machinery normally uses a Hermitian Euclidean kernel:

```text
H_W = gamma_5 (D_W - m),
D_ov = 1 + gamma_5 sign(H_W).
```

But the null-edge operator is natively retarded/Krein:

```text
J-self-adjointness does not imply real spectrum.
sign(H) is not available for a generic complex-spectrum operator.
```

Thus an overlap construction can be circular if it assumes the positive
Hermitian physical sector that Gate C is supposed to prove.

This is why the regulator should first be tested by grading and spectral-flow
legality:

```text
Does the regulator lift unwanted determinant zeros while preserving the intended
physical chirality at the origin?
```

The correct chirality may be:

```text
ordinary Gamma_s,
flavored Gamma_f = Gamma_s T,
or a product involving the Furey/internal grading chi_E.
```

## Hard problem 1: regulator grading legality and non-circular chirality

Ask Pro:

```text
We need a non-circular Gate C regulator theorem.

Given the null-edge seed D_+(q), C21 proves the bare branch kernels are
chiral-balanced. C64 proves off-branch determinant zeros that the simple T_lin
split misses. A scalar Wilson function W(q)=sum_a(1-cos q_a) can lift all
non-origin real-torus zeros, but a plain Wilson mass risks making the surviving
origin sector vectorlike. Overlap/Ginsparg-Wilson projection would restore
modified chirality in the usual Euclidean lattice setting, but our native
operator is retarded/Krein, so sign(H) may be undefined or circular.

Please solve or sharply analyze this problem:

1. Define the correct finite regulator-legality predicate for the null-edge
   Gate C setting. It should say what it means for a branch regulator R to lift
   non-origin determinant zeros without destroying the physical chirality at the
   origin.

2. Decide whether legality should be stated relative to Gamma_s, flavored
   Gamma_f = Gamma_s T, Gamma_s tensor chi_E, or another grading.

3. Give a finite hand-proof or counterexample showing why a Gamma_s-odd plain
   Wilson mass is not a valid chiral Gate C release, if that is indeed true.
   Be careful about conventions: in our super-Dirac convention Phi_H commutes
   with Gamma_s to give +Phi_H^2.

4. Propose the minimal flavored-mass or point-split regulator that satisfies
   the legality predicate, or explain why no such regulator exists for the
   tetrahedral null-edge symbol without an overlap/domain-wall layer.

5. State the exact Lean theorem targets we should ask Aristotle to prove next,
   including names, hypotheses, and conclusions.

6. Identify the circularity trap precisely: under what assumptions would an
   overlap construction be legitimate, and under what assumptions would it
   merely assume Gate C?

Please return:

- a theorem-level definition of RegulatorLegal;
- a hand proof of at least one positive or negative legality result;
- a recommended construction path;
- a list of failure criteria.
```

Why this matters:

```text
This is the core Gate C problem. Positivity alone is not enough. Chirality alone
is not enough. Krein adjointness alone is not enough.
```

## Hard problem 2: flavored mass / spectral flow / ghost-safe D_phys

Ask Pro:

```text
We need a concrete D_phys construction that can replace the bare D_+.

The literature suggests flavored mass terms, point splitting, and Hermitian
spectral flow for naive/minimally doubled kernels. Creutz-Kimura-Misumi
arXiv:1011.0761 and arXiv:1110.2482 construct overlap fermions from naive and
minimally doubled kernels using flavored mass terms. Kishore-Basak-Chakrabarti
arXiv:2602.19767 uses flavored mass terms, modified chirality, and spectral
flow for 4D KW/BC fermions. Golterman-Shamir arXiv:2311.12790 warns that
propagator zeros can become gauge-coupled ghosts.

Our null-edge setting differs because:

1. the determinant-zero set includes branch lines and off-branch zeros;
2. the native operator is retarded/Krein rather than Euclidean Hermitian;
3. point splitting may require backward shifts, which must be assigned to the
   Krein/spectral double rather than the causal update block;
4. the Furey/internal sector may supply a physical grading chi_E but not the
   kinetic branch regulator by itself.

Please design a candidate D_phys and audit it.

Questions:

1. What is the best analogue of the CKM flavored-mass construction for the
   tetrahedral null-edge symbol?

2. Should the construction use point-split branch projectors P_a(q), a scalar
   Wilson lower bound W(q), a flavored mass M_flavored(q), or some combination?

3. Can a flavored mass both:
   a. lift q_star and other off-origin determinant zeros;
   b. retain a modified chirality/spectral-flow index?

4. What is the correct Hermitian or Krein-Hermitian spectral-flow kernel?
   Is it H = Gamma_f(D + M_flavored - m), or something else?

5. What ghost-zero safety condition must be added so that lifted branches do
   not become Golterman-Shamir-style gauge-coupled ghosts?

6. Is there a plausible finite theorem that proves ghost safety, or is this
   necessarily an analytic/gauge-dynamical assumption?

7. What local/gauge-covariant position-space realization should replace the
   free-field momentum-space projectors P_a(q)?

Please return:

- an explicit proposed D_phys formula;
- the role of each term;
- a branch-by-branch classification protocol;
- a ghost-zero decision tree;
- Lean theorem targets for the finite algebraic parts;
- a clear statement of which parts are not finite Lean targets.
```

Why this matters:

```text
This problem turns the Gate C pivot into an actual operator construction.
Without it, we only know the bare operator fails.
```

## Hard problem 3: Furey/Baez internal fiber and prediction-grade constraints

Ask Pro:

```text
We need to know whether the Furey/Baez/DVT internal algebra can do more than
provide a beautiful internal-spectrum reconstruction.

Current status:

1. The null-edge program supplies the external kinetic candidate:
   D_N = sum_a c(alpha^a) nabla_a.

2. The Furey/Baez/DVT formalization supplies a candidate internal fiber:
   minimal ideals, internal grading chi_E, charge data, anomaly inheritance,
   and the true Standard Model gauge group quotient.

3. The intended almost-commutative product is:
   D = i D_N tensor 1 + Gamma_s tensor Phi_H.

4. Phi_H should be chi_E-odd but Gamma_s-even in the current super-Dirac
   convention so that Phi_H^2 enters the square with positive sign.

5. We do not currently derive Yukawa magnitudes or the mass hierarchy.

Please analyze whether Furey/Baez can provide an actual constraint, not merely
a reconstruction.

Questions:

1. Can the Furey/Baez/DVT internal algebra force the allowed form, rank, zero
   pattern, or texture of Phi_H?

2. Can it force the correct right-handed singlet completion, or is that still
   conventional input?

3. Can the true SM gauge group quotient, anomaly cancellation, and legal
   Yukawa maps be packaged as a finite internal spectral triple theorem?

4. Is there a natural internal grading chi_E that should enter Gate C regulator
   legality, such as Gamma_s tensor chi_E, and can it protect the physical
   chirality from a vectorlike Wilson regulator?

5. Can the internal algebra force a 2+2 taste partition, branch projector, or
   flavored chirality sign pattern, or would that be an unjustified mixing of
   internal and spacetime/branch data?

6. What is the first realistic prediction-grade theorem here? Examples:
   forbidden operator, restricted Yukawa texture, anomaly-selected
   representation, generation constraint, or forced Higgs representation.

Please return:

- a clean almost-commutative product architecture;
- a list of formal bridge theorems in dependency order;
- a verdict on whether Gate H can help Gate C or should remain separate;
- one realistic prediction/codimension target;
- one no-go criterion showing when Furey remains reconstruction only.
```

Why this matters:

```text
Gate H may be the path from reconstruction to structural constraint or
prediction. But it must not be allowed to masquerade as a solution to Gate C
unless it really constrains the physical branch projector or chirality grading.
```

## Existing documents Pro can use

If Pro needs more background, point it to:

```text
Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md
Sources/NullStrand_Lean_Roadmap_Improved.md
AgentTasks/null-edge-decision-log-2026-06-27.md
AgentTasks/null-edge-wave17-submissions-2026-06-27.md
AgentTasks/null-edge-wave18-submissions-2026-06-27.md
AgentTasks/context-packs/gate-c-flavored-mass-overlap-20260627-065620.md
```

But the present document is intended to be self-contained enough to paste
directly into Pro.

## Request to Pro

Please do not give only a literature summary. For each hard problem, give:

```text
1. a concrete proposed theorem statement or no-go statement;
2. a hand proof sketch or counterexample;
3. what Lean should formalize next;
4. what remains analytic or physical rather than finite algebra;
5. what would make the program downgrade from prediction to reconstruction;
6. citations only where they materially affect the decision.
```

The desired output is a decision memo that can drive the next Aristotle wave.

## Returned Pro answer digest

Status: answers to the three hard problems were supplied on 2026-06-27. The
durable conclusions below have been incorporated into
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` and
`AgentTasks/null-edge-decision-log-2026-06-27.md`.

### Answer 1: scalar Wilson is useful but not a Gate C release

Main verdict:

```text
W(q) = sum_a (1 - cos q_a) is a real-torus lifting lemma, not a chirality
theorem.
```

Useful result:

```text
W(q) >= 0;
W(q)=0 iff q=0 mod 2*pi;
W(q_star)=3 for q_star=(2*pi/3,0,0,4*pi/3).
```

Limitation:

```text
D_+(0)=0 and W(0)=0, so a scalar Wilson lift leaves the origin fiber
Gamma_s-balanced unless a separate physical projection or flavored grading is
constructed.
```

Updated target:

```text
RegulatorLegal must include both LiftNonOrigin and OriginWeylPure or an
equivalent modified-chirality condition.
```

### Answer 2: RA-doubled flavored-Wilson overlap candidate

Main recommendation:

```text
Use a retarded/advanced doubled, flavored-Wilson overlap candidate rather than
an overlap directly on the bare retarded block.
```

Candidate spectral double:

```text
D_RA =
  [ 0       D_+ ]
  [ -D_+^* 0   ]
```

Candidate lift:

```text
M_lift =
  r W
  + mu (I - T_br) / 2
  + lambda (I - F_tet)
```

Candidate spectral-flow kernel:

```text
H_NED(m) =
  Gamma_hat_sE (D_RA + M_lift - m I)
```

where:

```text
W lifts non-origin real-torus zeros;
F_tet is the tetrahedral CKM-style flavor scalar;
T_br is the decisive branch-flavor involution.
```

Key no-go:

```text
W and F_tet vanish quadratically near the origin. They cannot by themselves
separate an unwanted determinant-zero branch germ that reaches the origin.
```

Central open finite problem:

```text
Find or refute a local/gauge-covariant branch involution T_br with opposite
limiting eigenvalues on the target branch and unwanted branch germs.
```

Ghost rule:

```text
No gauge-charged branch may be removed solely by a point-split numerator or
propagator zero. Lifted branches should be heavy by an inverse-propagator gap.
```

### Answer 3: Furey/Baez helps Gate H, not Gate C

Main verdict:

```text
Furey/Baez/DVT can justify the internal Hilbert space, gauge quotient, charge
pattern, chi_E grading, anomaly inheritance, and legal Yukawa/Phi_H block form.
It cannot by itself assign chirality to null-edge branches or repair the D_+
determinant-zero locus.
```

Almost-commutative product:

```text
H_total = H_N tensor H_F
D_h = i D_N tensor 1 + Gamma_s tensor Phi_H
```

with:

```text
Phi_H chi_E + chi_E Phi_H = 0
[Phi_H, Gamma_s] = 0
```

Realistic prediction-grade target:

```text
LegalFiniteDiracForbiddenOperator:
  every chi_E-odd, J_F-real, first-order, gauge-covariant finite Dirac/Higgs
  operator has exactly the SM Yukawa block form, with arbitrary generation
  matrices, and no leptoquark, diquark, proton-decay, wrong-hypercharge, or
  colored-Higgs blocks.
```

Non-claims:

```text
No Yukawa magnitudes, ranks, CKM/PMNS angles, hierarchy, or generation number
are derived by this alone.
```

Gate H/Gate C separation:

```text
If H = H_N tensor H_F and branch projectors act only on H_N, then chi_E cannot
determine the external branch/taste chirality unless a new theorem couples
branch idempotents to internal idempotents.
```

### Updated next Aristotle themes

```text
C80/C84-style release API:
  PhysicalSectorData, RegulatorLegal, D_phys, and GateCReleaseV4.

T_br search/no-go:
  local/gauge-covariant branch-flavor involution separating target and unwanted
  branch germs.

RA spectral flow:
  D_RA anti-Hermitian, H_NED Hermitian under explicit grading/lift hypotheses,
  and finite overlap assumptions.

Scalar Wilson no-release:
  formal negative theorem that Wilson lifting of non-origin zeros does not
  imply nonzero physical chiral index at the origin.

Gate H forbidden-operator:
  finite internal Dirac/Phi_H block classification and forbidden-block theorem.
```

# Aristotle semantic context pack

Generated: 2026-07-09T14:55:17
Query: `second quantization exterior algebra dGamma additive decomposition four channel carrier square Fock mass gap derived closure interaction binding wrong plane`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Research_Plan.md` [New master criterion: finite Dirac square root]

Score: `0.776`

```text
stial relaxation gap is a square-level diagnostic; the more
  fundamental object is the first-order flip generator whose eigenvalue is
  the mass.
- The complex Plucker amplitude should be retained before taking modulus:
  its modulus gives the pairwise mass spread, while its phase is the
  Pancharatnam/Berry target to compare with graph holonomy.
- The sign of the square root is a required two-sheet branch datum for any
  CPT, particle/antiparticle, or in/out interpretation.

The finite two-sheet branch algebra is now integrated in
`PhysicsSM.Draft.NullEdgeDiracTwoSheetCore`: any operator with
`D^2 = m^2 I` and `m != 0` has complementary projectors
`(1/2)(I plus/minus m^{-1}D)` carrying the `+m` and `-m` branches. The remaining
physics question is not whether the branches exist algebraically, but how a
causal graph, CPT convention, or scattering boundary condition should interpret
them.

The static bundle bridge is now also integrated in
`PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`: after extracting Weyl
coordinates from the trusted finite bundle momentum, the chiral slash squares
to `PhysicsSM.Spinor.PluckerMass.finPairwisePluckerMass`. The concrete
mass-shell branch specialization is integrated in
`PhysicsSM.Draft.NullEdgeDiracMassShellProjectorsCore`, proving idempotence,
orthogonality, and the `+m`/`-m` slash eigenvalue equations for the mass-shell
projectors.

**2026-06-21 branch/projector additions.** Added Foldy-Wouthuysen `NFMI3A99`
(`10.1103/physrev.78.29`), Newton-Wigner `74NU4C33`
(`10.1103/revmodphys.21.400`), and Thaller's *The Dirac Equation* `UI9343SX`
(`10.1007/978-3-662-02753-0`) to Zotero/Neo4j under `two-sheet-branch`.
These are guardrails for interpreting the algebraic branch projectors without
overclaiming a scattering or localization theory.
```

### 2. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [Claim boundary]

Score: `0.772`

```text
### Claim boundary

The qubit/qutrit framing does not solve:

```text
fermion doubling;
the GW relation;
sign-kernel locality;
bad-sector gapping;
anomaly accounting;
Krein positivity;
gauge determinant construction.
```

It only sharpens the finite origin selector language and the design of
matrix-valued Wilson/flavored-mass terms.
```

### 3. `Sources/NullStrand_Open_Questions_For_Frontier_Models.md` [6.9 ChatGPT Pro refinement: normalization, Higgs grading, and proof package]

Score: `0.771`

```text
Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi].
```

The trap is explicit: if `Phi` anticommutes with the same `Gamma_s`, then
`(Gamma_s Phi)^2 = -Phi^2`. The Higgs/Yukawa operator may be odd, but that
oddness should be with respect to the internal grading `chi_E`, not the same
spacetime chirality used in `D = i D_N + Gamma_s Phi`.

Third, the mass-shell sign must be named. In mostly-minus convention, decide
whether `Box_null` denotes the kinetic mass-shell operator or the analytic
D'Alembertian. To get `P^2 = m^2` from `-Box_null + Phi^2 = 0`, the plane-wave
symbol of `Box_null` must be `P^2`; otherwise the sign is wrong.

Fourth, the finite square/frame term should be used as an audit:

```text
T_frame = sum_a,b C_a [nabla_a, C_b] nabla_b.
```

It vanishes under the finite tetrad postulate `[nabla_a, C_b] = 0`. It is
physical when it is the discrete spin-connection/tetrad-variation remnant. It is
contamination if the frame varies but the transport does not carry the Clifford
frame; after rescaling finite differences, `O(1)` frame jumps over `h`-edges can
blow up like `O(h^{-1})`.

Fifth, the next proof package should prioritize:

```text
1. tetrahedral dual frame with the unit observer-normalized convention;
2. diagonal null trace obstruction;
3. dual-soldering commutator/symbol theorem;
4. graded super-Dirac square with the Higgs sign guardrail.
```

Secondary but useful finite targets are spectral mass-shell matching,
Schur-complement local dilation, an SSH/Jackiw-Rebbi finite defect pilot, and the
finite CTMC Poisson-equation SLLN route.
```

### 4. `Sources/Null_Edge_Key_Conjectures.md` [What we think]

Score: `0.762`

```text
block. It is
the principal symbol or momentum-eigenvalue of the kinetic block, while
`Phi^dagger Phi` is the internal/Yukawa mass block. On shell these two numbers
must agree:

```text
kinetic symbol on bundle momentum P = det(P)
Yukawa mass block                    = Phi^dagger Phi
mass shell constraint                = det(P) = Phi^dagger Phi.
```

Thus the desired square is not "Laplacian plus curvature plus Pluecker mass
plus Yukawa mass." That would double-count the same physical mass. The honest
decomposition is:

```text
D_{U,Phi}^2 =
  covariant graph Laplacian          -- symbol evaluates to det(P)
  + diamond curvature block
  + Higgs/Yukawa mass block
  + gauged Higgs kinetic cross term.
```

The product grading should be built into the candidate operator. On finite
cochains with simplicial grading `Gamma_K`, the cleaner model is

```text
D_U = d_U + d_U^x
M_Phi = offDiagonal(Phi)
D_{U,Phi} = D_U + Gamma_K M_Phi.
```

The factor `Gamma_K` matters: without it, even a constant internal mass block
can produce the wrong cross terms. The exact finite square identity should be
treated as a theorem-level algebra target:

```text
D_{U,Phi}^2 =
  d_U d_U^x + d_U^x d_U
  + d_U^2 + (d_U^x)^2
  + M_Phi^2
  - Gamma_K [D_U, M_Phi].
```

In this decomposition, the first line is the covariant Hodge Laplacian, the
second line is the additive curvature defect, `M_Phi^2` is the Yukawa mass
block, and the commutator is the finite gauged Higgs derivative. This identity
is not by itself the deep conjecture; the deep parts are Lorentzian sign,
diamond-holonomy identification, symbol definition, and naturality.

The non-tautological content is the consistency claim: the same finite operator
surface should make the kinetic Pluecker determinant, the Yukawa mass block, and
the diamond
```

### 5. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [0. Dirac square-root criterion]

Score: `0.762`

```text
, form

```text
P = sum_i psi_i psi_i^dagger = P_mu sigma^mu.
```

With gamma matrices satisfying

```text
gamma_mu gamma_nu + gamma_nu gamma_mu = 2 eta_{mu,nu} I,
```

the Dirac slash obeys

```text
(gamma . P)^2 = (P_mu P^mu) I = det(P) I.
```

The trusted Plucker theorem then identifies the scalar:

```text
(gamma . P)^2 = finPairwisePluckerMass(psi) I.
```

Near-term Lean targets:

```lean
hermitianTwoByTwo_det_eq_minkowski_norm
diracSlash_sq_eq_minkowski_norm
diracSlash_bundleMomentum_sq_eq_pluckerMass
leftRightDiracBlock_sq_eq_pluckerMass
higgsFlipBlock_sq_eq_yukawaMass
complexPluckerAmplitude_modSq_eq_pairMass
complexPluckerTriangle_phase_eq_pancharatnam
checkerboardFlipTransfer_sq_eq_kgRecurrence
diracSlash_massless_iff_common_spinor_direction
```

This does not yet prove dynamics. It factors the number already proved by
`PluckerMass` and gives the correct first-order object to connect to
checkerboard dynamics, chirality flips, and order-complex fermions.

The branch projectors are not optional decoration. Once a finite operator
satisfies `D^2 = m^2 I`, the plus and minus spectral projectors carry the data
discarded by the scalar square. The integrated
`PhysicsSM.Draft.NullEdgeDiracTwoSheetCore` theorem proves this algebraically;
the physics reading must then be checked against the Foldy-Wouthuysen
diagonalization, Newton-Wigner localization, and standard Dirac spectral
projector literature before claiming a particle/antiparticle or in/out
interpretation.

The full finite synthesis asks for a graded operator

```text
D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger
```

on a finite causal order complex with visible spinor and internal label
fibers. Here \(U\) is edge/gauge transport and \(\Phi:E_L\to E_R\) is the
odd Higgs/Yukawa zero-form. This should be read as th
```

### 6. `Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md` [75. First Wilson band and uniform-gap adapter]

Score: `0.761`

```text
y momentum block has `K(k)^* K(k) = coeff(k) I` with
  `coeff(k) >= gamma > 0`.
- The proof uses the finite real-variable split around
  `R(k) = sum_A (1 - cos(k_A))`: outside the middle interval the Wilson mass is
  bounded away from zero, and inside the middle interval `qLower` is bounded
  below by the elementary inequality
  `qLower >= (1/4) * R(k) * (2 - R(k))`.

What remains:

- Transfer the `K(k)` norm gap to the Hermitian sign-kernel symbol
  `H(k) = gamma5 K(k)` once a unitary/Hermitian `gamma5` interface is fixed.
- Lift the pointwise symbol norm gap through a finite Fourier/Parseval bridge
  to the free operator gap.
```

### 7. `AgentTasks/furey-electroweak-complete-package-aristotle-2026-06-03.md` [Mathematical context]

Score: `0.760`

```text
## Mathematical context

The Furey electroweak formalization is now complete across several modules.
This file bundles everything into a single citeable record for Section 5 of
the paper, together with two derived results not yet proved:

1. **[Q, W⁺] = W⁺** and **[Q, W⁻] = -W⁻** — the charge operator Q
   satisfies the correct commutation relations with the raising/lowering
   operators. These follow from [T₃,W±] = ±W± and [Y,W±] = 0 by linearity.

2. **Q eigenvalue gap in each doublet** — T⁺ raises Q by 1 and T⁻ lowers
   by 1 within each SU(2)_L doublet (this should follow from the existing
   doublet charge difference theorems).
```

### 8. `docs/NULLSTRAND.md` [Super-Dirac square guardrails]

Score: `0.759`

```text
## Super-Dirac square guardrails

Keep these gradings distinct:

```text
Gamma_s       spacetime chirality
chi_E         internal finite grading
epsilon_form  cochain/form degree, if present
```

For:

```text
D_N = sum_a C_a nabla_a
C_a = c(alpha^a)
D = i D_N + Gamma_s Phi
```

the safe sign hypotheses for a `+ Phi^2` square include:

```text
Gamma_s^2 = 1
{Gamma_s, C_a} = 0
[Gamma_s, nabla_a] = 0
[Gamma_s, Phi] = 0
[C_a, Phi] = 0
```

The Higgs or internal mass block should be internally odd under `chi_E`, not
spacetime-chirality odd under the same `Gamma_s`. If `Phi` anticommutes with
`Gamma_s`, the square flips the sign of `Phi^2`.

Use `Box_null` as the kinetic mass-shell operator. In mostly-minus signature,
the analytic d'Alembertian has plane-wave symbol `-p^2`; the mass-shell
normalization for `-Box_null + Phi^2 = 0` should give `p^2 = m^2`.
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.742`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. Free quantum field theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell quantum cellular automata

Score: `0.739`
Zotero key: `BVJBTK8J`
arXiv: `1601.04832`
URL: http://arxiv.org/abs/1601.04832v1

### 3. Quantum Field Theory On Causal Sets

Score: `0.733`
Zotero key: `arxiv:2306.04800`
arXiv: `2306.04800`
URL: http://arxiv.org/abs/2306.04800

Abstract:

Overview of matter QFT on fixed causal-set backgrounds, including Green functions, Sorkin-Johnston two-point functions, and fermion/interacting-theory directions.

### 4. Weyl, Dirac and Maxwell Quantum Cellular Automata: analytical solutions and phenomenological predictions of the Quantum Cellular Automata Theory of Free Fields

Score: `0.732`
Zotero key: `KCQGEDJE`
arXiv: `1601.04842`
URL: http://arxiv.org/abs/1601.04842v1

### 5. Massive relativistic particle model with spin from free two-twistor dynamics and its quantization

Score: `0.728`
Zotero key: `zotero:2T3HC5NC`
arXiv: `hep-th/0510161`
DOI: `10.1103/PhysRevD.73.105011`
URL: https://doi.org/10.1103/PhysRevD.73.105011

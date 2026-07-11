# Aristotle semantic context pack

Generated: 2026-07-10T20:51:39
Query: `classify moduli of channel decompositions of a finite Krein Dirac carrier square under chirality adjoint edge exchange word degree locality positivity information monotonicity and refinement naturality`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/A_moduli_theory_of_self-decoding_null_information.md` [C. Channel-equivalence theorem]

Score: `0.810`

```text
## C. Channel-equivalence theorem

The explicit (Q=E_{01}) carrier now has a complete answer: its commuting
decoder space modulo (QR+RQ) is classified by the single complex coordinate
(mu=D_{22}). The remaining theorem program is to generalize this result to
arbitrary finite constraint complexes and then prove preservation of the
additional structures below.

Classify changes of decomposition that are (Q)-exact or chain-homotopic and prove that they preserve:

[
\text{physical spectrum},
\quad
\text{index},
\quad
\text{positive inertia},
\quad
\text{critical locus}.
]

For the explicit three-state carrier, this already turns non-rigidity into a
controlled channel gauge. The universal classification and the full invariant
packet remain open.
```

### 2. `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` [4. The organizing spine: the mass-budget decomposition (**M** + **C**)]

Score: `0.804`

```text
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
| `4 Q_T` | turn / `phi^2` | Higgs
```

### 3. `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` [11. The Lean anchor table]

Score: `0.798`

```text
gidity_with_boundary` | `NullEdge/FourChannelRigidityCapstone.lean` | M, self-guarded (six in-file pins) | **the explicit four-channel witness is coefficient-rigid**: rational entry selectors recover every coefficient, `QA/QC/QT/Es` are linearly independent, and `4 D^T D` recovers `(1,1,1,1)`. The final theorem carries the abstract no-go beside the positive result: concrete support data force this presentation; chirality/Krein type and block count alone do not force a unique carrier split |
| 9a | `posDef_aperture_add_gram`, `massGap_one_add_gram` | `NullEdge/PositiveSectorClassification.lean` | M, self-guarded (in-file pin) | **positive-sector criterion (generalizes T2)**: `A PosDef ⇒ (A+BᴴB) PosDef`, gap `≥1` — closure entering *squared* never destabilizes a positive aperture, beyond the `Cl(4)` witness |
| 2a | `Dop`/`kdag_Dop`, walk = carrier | `NullEdge/CheckerboardCarrierBridge.lean` | M, self-guarded (in-file pin) | **the 1+1D Dirac quantum walk IS a Krein null-edge carrier**: null Clifford edges `cP²=cM²=0`, `{cP,cM}=1`, kinetic/mass/`D` all Krein-self-adjoint; channel names match kinetic/mass. First "channels = physics" evidence |
| 9 | `dirac_mass_shell`, `Ustep_hasDerivAt_generator` | `Carrier/ContinuumLimit.lean` | M, guard-pinned (`CarrierAxiomGuard`) | **continuum-limit finite symbol facts**: mass shell `(kσ_z+mσ_x)²=(k²+m²)·1`; discrete transfer generator matches the Dirac Hamiltonian symbol to leading order. Continuum *theorem* is `[import]` (1+1D) / open (Cl(4)) |
| 2a/9 | `massive_implies_subluminal`, `luminal_iff_massless`, `groupVelSq_num_le_sin_sq_omega` | `Carrier/SubluminalBound.lean` | M, self-guarded (in-file pin) | **derived speed limit**: from the pinned dispersion `cos ω=cos k cos θ`, `v_g²≤1` with deficit `1−cos²θ`; every massive mode strict
```

### 4. `Sources/Null_Edge_Future_Directions.md` [Round-8 (Pro, 2026-07-10): the moduli theory — digestion, corrections, jobs]

Score: `0.795`

```text
## Round-8 (Pro, 2026-07-10): the moduli theory — digestion, corrections, jobs

Pro's round-8 ("a moduli theory of self-decoding null information") genuinely adds a
layer beyond round-7: the fundamental object becomes an EQUIVALENCE CLASS of finite
decoders, turning the carrier non-rigidity no-go into channel-gauge freedom.
Digestion status: the same-carrier homotopy core landed same-day as
`Carrier/DecoderChainHomotopy` [M] (sec 2's `D' = D + QR + RQ` acts identically on
cohomology); secs 6/8/9/10/15 are substantially covered by `NullEdgeP7BlochMassRatio`,
`VelocityMixtureLinearEntropy`/`KraftCompressionMass`, `UnifiedActionVariation`,
`MassGradientMorse`, the WEP stack, and the P7 recovery stack
(`P7PetzRecovery`/`P7RecoverabilityGap`/`P7KLDataProcessing`/`P7StochasticContraction`).
Sec 11 (Lambda central) is a one-lemma corollary of `LambdaUnimodular`'s
channel-blindness; secs 13/14/18/19 stay [spec] pending the Lambda statistics jobs and
the area-law lane.  Sec 1's amplitude functor: the finite gluing shadows are landed
(concatenation/holonomy-append lemmas); full monoidal categorification is packaging,
deferred until an invariant needs it.

**Own-analysis corrections recorded (2026-07-10):**

- **Sec 16 (generations as sheet monodromy) needs a correction:** Hermitian carrier
  families have real eigenvalues, and strictly ordered real spectra CANNOT braid — the
  permutation monodromy of a nondegenerate Hermitian loop is always trivial.  The
  honest dichotomy is: Z3 sheet monodromy exists on COMPLEXIFIED moduli loops
  (explicit `lambda^3 = e^{i theta}` companion family), while for Hermitian families
  generation structure must live in eigenVECTOR (Berry/Bargmann) holonomy or
  degeneracy crossings — consistent with the landed `BargmannCP`.  Jobbed as a
  two-half
```

### 5. `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md` [Already proved or kernel-checked]

Score: `0.790`

```text
rver-channel mass core.**
  `PhysicsSM.Draft.NullEdgeObserverChannelCore` packages the sharpened
  observer-channel conjecture into finite theorem surfaces. It distinguishes
  the unnormalized resolution output from the kinematic normalization, proves
  `SL(2,C)` determinant invariance for the resolution output, records scalar
  filtering of normalized visible data, factors the two-label internal Gram
  channel as visible Plucker spread times the hidden Gram determinant, proves
  dephasing monotonicity of that factor, proves the unital visible-channel
  mass-ratio-square monotone, and records a toy counterexample showing why
  entangling hidden dynamics cannot be covered by an unrestricted monotonicity
  slogan.

- **Finite Schmidt determinant bridge.**
  `PhysicsSM.Draft.NullEdgeSchmidtDeterminantCore` proves that, for a real
  two-qubit pure-state coefficient matrix, the visible reduced determinant and
  chirality/internal reduced determinant are equal, and both equal the square
  of the coefficient determinant. This banks the determinant part of the
  mixedness/coherence duality while leaving the boosted chirality-coherence
  interpretation behind an explicit balance/frame convention.

- **Finite super-Dirac Krein core.**
  `PhysicsSM.Draft.NullEdgeSuperDiracKreinCore` formalizes the Lorentzian
  refinement of the super-Dirac conjecture. It defines finite
  `J`-self-adjointness, the mass-shell branch symmetry `J = (1 / m) D`, proves
  that `J^2 = 1` when `D^2 = m^2 I`, identifies this `J` with the difference of
  the plus and minus branch projectors, and introduces a `MassShellConstraint`
  predicate to record equality of the kinetic Pluecker symbol and Yukawa square
  rather than adding them as two mass blocks.

- **Finite null-step quantum-walk norm core.**
  `Phys
```

### 6. `NULL-EDGE_TARGET_AUDIENCE.md` [Paper II: the carrier theorem]

Score: `0.788`

```text
## Paper II: the carrier theorem

**Proposed title**

> **Positive Cohomology and Moduli of Finite Krein–Dirac Carriers**

**Primary audience:** mathematical physics, Krein geometry, noncommutative geometry.

**Required core results:**

1. An abstract definition of the carrier category.
2. Necessary and sufficient positivity criteria.
3. Classification of induced physical operators on cohomology.
4. A general four-block decomposition theorem.
5. A moduli/equivalence theorem.
6. Stability of the physical gap under admissible perturbations or refinement.

The binding model and coframe can appear as applications. Generation counting, cosmology, and Standard Model nomenclature should not.
```

### 7. `NULL-EDGE_TARGET_AUDIENCE.md` [The theorem package needed for them]

Score: `0.787`

```text
## The theorem package needed for them

A compelling carrier paper should prove a general result resembling:

> For a specified category of finite graded Krein complexes with compatible carrier (D) and constraint differential (Q), the induced physical operator on cohomology is well defined; positivity is characterized by explicit inertia/radical conditions; and admissible carrier decompositions form a classified moduli space modulo Krein intertwining and chain homotopy.

That would combine your best present ingredients:

* positive versus merely nondegenerate cohomology;
* the Hilbert-Hodge/Krein-Hodge distinction;
* chain-homotopy invariance;
* concrete rigidity and abstract nonuniqueness;
* the aperture–closure phase diagram.

The four physical names—kinetic, QCD, Yukawa, and gravity—should be absent from the theorem statements. Introduce them only after proving a representation-independent characterization of the blocks.

A suitable title would be:

> **Positive Cohomology and Four-Block Decompositions of Finite Krein–Dirac Carriers**

Natural venues include **Journal of Geometry and Physics**, **Mathematical Physics, Analysis and Geometry**, **Journal of Mathematical Physics**, and, with a sufficiently complete spectral-geometric construction, **Journal of Noncommutative Geometry**.
```

### 8. `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md` [10. Where this is going (a graded preview, not a promise)]

Score: `0.783`

```text
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
  state-space construction that would m
```

### 9. `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` [6. Closure mass: the QCD-shaped channel (**M** + the central crux, resolved)]

Score: `0.782`

```text
ked (**M**):
for every finite nilpotent `Q`, each closed vector has a unique representative
in `ker Q intersect ker Q^*` modulo `range Q`; a decoder commuting with `Q`
descends to cohomology, and commuting also with `Q^*` preserves harmonic
representatives (`GenericFiniteHodge`). This does not make the Krein version
true. `KreinHodgeNoGo` proves on the explicit `2x2` pair
`J=[[0,1],[1,0]]`, `Q=[[0,1],[0,0]]` that `Q^2=0` and `Q#=Q` while
`Q#Q+QQ#=0`; every vector is Krein-harmonic, yet `ker Q=range Q` and one
harmonic vector is not closed. The Hilbert adjoint is therefore load-bearing.

Nor is there a canonical `(ker Q/range Q)_{J>0}`. The condition `Q#=Q`
allows the form to descend, but a nondegenerate indefinite quotient has no
preferred positive part. Physicalization requires additional data: a chosen
nonzero `D`-invariant `J`-positive subspace of cohomology. The positive witness
constructs one such model; the matched negative witness proves that its
existence is contingent, while maximality and uniqueness remain open.

The first decoder-moduli theorem is now landed (**M**). If `Q^2=0`, `D`
commutes with `Q`, and `D' = D + QR + RQ`, then `D'` also descends through the
constraint quotient and `D'x-Dx` is exact for every closed `x`. The more general
cross-carrier equation `D'U-UD=Q'R+RQ`, together with `UQ=Q'U`, intertwines the
induced cohomology actions (`DecoderChainHomotopy`). The explicit shift
`D'_mu=D_mu+2Q` is a genuinely different prephysical matrix but acts identically
on the positive harmonic class `e2`. This makes chain-homotopy presentation
freedom theorem-backed; it does not yet classify all four-channel
non-uniqueness or prove full-spectrum invariance before quotienting.

---
```

### 10. `README.md` [The flagship: the null-edge origin-of-mass program]

Score: `0.782`

```text
of the chiral surplus is topological - immune to every
  potential and transport). All under `PhysicsSM/Draft/NullEdge/Carrier/` with
  build-enforced axiom pins in `CarrierAxiomGuard.lean`.
- **Open cruxes (tracked, not claimed).** Physical-sector (off-flat) Krein
  positivity; the concrete `Q_A`-to-`det P` (trusted kinematic mass)
  identification; the all-slots-active glue witness; beyond-leading closure
  positivity; every continuum statement.
```

### 11. `PhysicsSM/Draft/NullEdgeP2ChiralityCoherence.lean` [chiralityCoherence]

Score: `0.782`

```text
def chiralityCoherence (offdiag : Real) : Real :=
  2 * |offdiag|

/--
For the two-level Dirac/Yukawa block, the positive-energy projector has
chirality coherence `m / E` when `m >= 0` and `E > 0`.
-/
```

### 12. `PhysicsSM/Draft/NullEdgeP2ChiralityCoherence.lean`

Score: `0.781`

```text
namespace PhysicsSM.Draft.NullEdgeP2ChiralityCoherence

/-- Off-diagonal left/right entry of the positive-energy chiral projector. -/
```

## Scoped paper hits

### 1. Locality properties of Neuberger's lattice Dirac operator

Score: `0.751`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 2. Extension of the Nielsen-Ninomiya theorem

Score: `0.744`
Zotero key: `arxiv:hep-lat/9803002`
arXiv: `hep-lat/9803002`
DOI: `10.1103/PhysRevD.58.057505`
URL: http://arxiv.org/abs/hep-lat/9803002

Abstract:

Extends the Nielsen-Ninomiya no-go theorem for lattice chiral Dirac fermions using the index theorem, including translation non-invariant and non-local formulations.

### 3. Modular Hamiltonians for Deformed Half-Spaces and the Averaged Null Energy Condition

Score: `0.735`
Zotero key: `B68T629C`
arXiv: `1605.08072`
DOI: `10.1007/JHEP09(2016)038`
URL: http://arxiv.org/abs/1605.08072

Abstract:

Derives a modular Hamiltonian term for deformed half-spaces and uses relative-entropy monotonicity to prove ANEC.

### 4. Lattice regularization of reduced Kähler-Dirac fermions and connections to chiral fermions

Score: `0.734`
Zotero key: `8RSBSW7Z`
DOI: `10.21468/scipostphys.16.4.108`
URL: https://doi.org/10.21468/scipostphys.16.4.108

Abstract:

Reduced Kähler-Dirac fermions, mirror sectors, measure phase, and a doubler-free lattice action; source guardrail for the null-edge order-complex fermion branch and no-doubling claims.

### 5. Spin on a 4D Feynman Checkerboard

Score: `0.734`
Zotero key: `TN53N8J2`
arXiv: `1610.01142`
DOI: `10.1007/s10773-016-3170-0`
URL: https://www.zotero.org/19894138/items/TN53N8J2

Abstract:

We discretize the Weyl equation for a massless, spin-1/2 particle on a time-diagonal, hypercubic spacetime lattice with null faces. The amplitude for a step of right-handed chirality is proportional to the spin projection operator in the step direction, while for left-handed it is the orthogonal projector. Iteration yields a path integral for the retarded propagator, with matrix path amplitude proportional to the product of projection operators. This assigns the amplitude i$^{±}^{T}$ 3$^{−}^{B}^{/2}$ 2$^{−}^{N}$ to a path with N steps, B bends, and T right-handed minus left-handed bends, where the sign corresponds to the chirality. Fermion doubling does not occur in this discrete scheme. A Dirac mass m introduces the amplitude i 𝜖 m to flip chirality in any given time step 𝜖, and a Majorana mass similarly introduces a charge conjugation amplitude.

### 6. Moduli spaces of Dirac operators for finite spectral triples

Score: `0.733`
Zotero key: `XEECSHKK`
arXiv: `0902.2068`
DOI: `10.1007/978-3-8348-9831-9_2`
URL: http://arxiv.org/abs/0902.2068

Abstract:

The structure theory of finite real spectral triples developed by Krajewski and by Paschke and Sitarz is generalised to allow for arbitrary KO-dimension and the failure of orientability and Poincare duality, and moduli spaces of Dirac operators for such spectral triples are defined and studied. This theory is then applied to recent work by Chamseddine and Connes towards deriving the finite spectral triple of the noncommutative-geometric Standard Model.

### 7. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.727`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 8. An analysis of completely-positive trace-preserving maps on M2

Score: `0.721`
Zotero key: `M6HR9WD6`
DOI: `10.1016/s0024-3795(01)00547-x`

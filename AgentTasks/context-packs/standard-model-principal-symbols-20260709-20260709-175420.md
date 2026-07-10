# Aristotle semantic context pack

Generated: 2026-07-09T17:54:28
Query: `3+1 Klein Gordon Dirac Maxwell Lorenz gauge principal symbol characteristic null cone lower order mass mixing`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [2026-06-25 super-Dirac refinement (concrete gate)]

Score: `0.788`

```text
#### 2026-06-25 super-Dirac refinement (concrete gate)

A new concrete proposal is the **null-diamond super-Dirac operator**:

```text
D_N = Σ_i c(ℓ_i) (T_i - P_i),   D = i D_N + Γ_5 Φ
```

`c(ℓ_i)` is the null Clifford symbol for direction `i`, `T_i` is the pullback
shift, `P_i` is the existence projector, and `Φ` is the odd self-adjoint Yukawa
operator on the internal finite space.

This proposal enforces the key refinement: **Plücker mass is the square of the
kinetic symbol, not an extra zero-order addend in `D_N^2`.** `Φ^2` is the only
mass block. The finite square should split as

```text
D^2 = -□_null - 𝒞_diamond - 𝒯_frame + Φ^2
      - i Γ_5 Σ_i c(ℓ_i)[∇_i, Φ]
```

where `□_null` is the null-direction second-order propagation, `𝒞_diamond` is the
causal-diamond holonomy curvature term, and `𝒯_frame` is the frame-variation term
that vanishes under a finite tetrad postulate.

In a flat, frame-covariantly constant regime, the shell condition is:

```text
-□_null + Φ^2 = 0  on shell
```

equivalently, on a local mode with symbol momentum `P(ξ)` and a `Φ`-eigenvector
`Φ^2 ψ = m^2 ψ`:

```text
P(ξ)^2 = m^2.
```

This is exactly the non-double-counting message.

Notation guardrail. The Krein/spectral-triple layer should reserve `eta` for
the linear fundamental symmetry defining the Krein product, `JReal` or `C` for
the antilinear real structure, and `Sigma_m = D / m` for the mass-shell sheet
involution. The existing two-sheet projector theorem concerns `Sigma_m`, not
the real structure or the fundamental symmetry.

Finite spectral-action target. On a finite complex, the low-order spectral
action is finite linear algebra rather than asymptotic heat-kernel analysis.
The first useful target is:

```text
Tr(D_total^2) = graph kinetic trace + Yukawa trace + diamond-curvature
```

### 2. `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` [Recommended sequencing]

Score: `0.784`

```text
C1 release is proved.
8. Gate H/Gate F forbidden-operator work should be treated as the first
   prediction-grade lane: prove absences and codimensions before claiming mass
   values, and use neutrinos as the explicit Dirac/Majorana/seesaw stress test.
9. P11-R after P2/P4 have a concrete transfer operator and P7 has a usable
   observer-channel API.
10. P5-F and P6-R opportunistically; P10-R only after doubler, chirality, and
   internal-family multiplicities are proven disjoint or explicitly identified.

The most useful theorem/counterexample sequence after P1 is:

1. `localNullSymbol_sq_eq_weightedPluckerMass`;
2. `nullDirac_commutator_mul_eq_edgeDifferences`;
3. `superDirac_isOdd`;
4. `flatSuperDiracSymbol_has_lorentzianMassShell`;
5. `productGradedSuperDirac_sq`;
6. `diamondAdditiveDefect_eq_holonomyMinusId`;
7. `oneDiamond_naturalOperator_classification`;
8. `superDirac_sq_eq_finiteLichnerowicz`;
9. `observerSpinFrame_wellDefined_up_to_SU2`;
10. `gramWeightedPlucker_eq_exteriorSquare`;
11. `massless_iff_rank_VGsqrt_le_one`;
12. `threeLabel_dephasing_not_monotone`;
13. `twoLevelYukawa_coherence_to_dephasedDet`;
14. `closedIntervalOrderComplex_contractible`;
15. `weightedHodgeProjector_eq_pseudoinverseProjector`;
16. `bandLimitedNullWalk_convergesToDirac` plus
    `brillouinZone_coneCensus`.

Near-term editorial work order:

1. freeze P1 around the theorem package and frame audit;
2. build the theorem index / reproducibility appendix;
3. rewrite the P1 introduction and novelty statement using the P1 paper
   contract above;
4. add the robustness examples;
5. move ontology, Higgs-mixedness, particle-sector, and P9 material into a
   separate program note or final future-work section.
```

### 3. `Sources/NullStrand_Open_Questions_For_Frontier_Models.md` [5. The single most important question]

Score: `0.783`

```text
## 5. The single most important question

If you answer only one thing: **Q5.** Does a concrete, Lorentzian-honest, finite
first-order operator exist whose square is exactly
`−□_null − 𝒞_diamond − 𝒯_frame + Φ²` with `Φ²` the sole mass block and the Plücker
mass appearing as the *kinetic symbol* rather than an additive term — and is the
required symbol/soldering identity `[D, M_f] ~ Σ_y a_xy (f(y)−f(x)) γ·p_xy` actually
achievable, or is there an index-theoretic / heat-trace obstruction forcing an extra
zero-order term? A construction, a known reference, or an impossibility argument would
each be decisive.

---
```

### 4. `Sources/Null_Edge_Key_Conjectures.md` [What the literature says]

Score: `0.782`

```text
ventions, the super-Dirac conjecture should be weakened before
further Lean investment.

On a diamond with two path transports `T1` and `T2`, the additive curvature
defect and multiplicative holonomy should be related exactly:

```text
H_diamond = T1 * T2^{-1}
F_diamond = T1 - T2 = (H_diamond - I) * T2.
```

Only a comparison with `log H_diamond` requires a small-curvature approximation
and a branch choice. Thus the best finite target is additive, not logarithmic:
the `d_U^2` matrix on the diamond 2-cell equals `T1 - T2`, hence equals
`(H_diamond - I) * T2`.

The Krein part has the same discipline. Existence of an indefinite form is not
enough, since many finite operators can be made self-adjoint for some chosen
indefinite form. The target is a causally forced split signature and time
orientation compatible with the causal order and the plus/minus branch
projectors.

The mass-shell statement also needs correct typing. Since `Phi^dagger Phi` is
generally a flavor/internal matrix, the honest condition is statewise or
spectral:

```text
(det(P) I_F - M_Phi^2) Psi = 0
```

or, on a mass eigenchannel `f_r`,

```text
M_Phi^2 f_r = m_r^2 f_r
det(P_r) = m_r^2.
```

The word "symbol" should also be restricted. An irregular finite graph has no
canonical momentum-space principal symbol. The claim should be one of:

```text
exact Bloch symbol on a periodic diamond complex
frozen-coefficient local symbol
asymptotic symbol for a refining family
```

Without one of these, "the kinetic symbol equals the Pluecker determinant" is
undefined rather than merely unproved.

The latest sharpening makes the symbol/soldering theorem the flagship target.
The already banked static theorem

```text
(gamma . P)^2 = det(P) I
```

is not enough unless the causal order-complex operator has a first-orde
```

### 5. `Sources/Null_Edge_Key_Conjectures.md` [What the literature says]

Score: `0.781`

```text
makes the symbol/soldering theorem the flagship target.
The already banked static theorem

```text
(gamma . P)^2 = det(P) I
```

is not enough unless the causal order-complex operator has a first-order
commutator whose local symbol is exactly the slash of the weighted null-edge
momentum bundle. For an edge-weighted local covector `xi`, the desired finite
statement is:

```text
sigma_x(xi) = sum_{e incident x} a_e xi_e gamma.p_e
sigma_x(xi)^2 =
  (sum_{e<f} a_e a_f xi_e xi_f |psi_e wedge psi_f|^2) I.
```

With nonnegative active weights, the scalar is nonnegative and vanishes exactly
when all active null directions are collinear. This would identify the graph
operator's characteristic variety with the null cone, turning the Lorentzian
non-ellipticity of a Krein Dirac operator into a feature rather than a defect.
```

### 6. `Sources/NullStrand_Lean_Roadmap_Improved.md` [Physical consequence map from earlier analysis (2026-06-26)]

Score: `0.781`

```text
### Physical consequence map from earlier analysis (2026-06-26)
+
+An earlier attached analysis is useful, but mostly downstream of the immediate
+dual-soldering task. It should be treated as a consequence map for what the
+super-Dirac operator could buy us after the symbol and square are trusted.
+
+#### Consequences now worth adding to the roadmap
+
+1. **Null-pair mass-area theorem**
+
+   Exact finite target: for null `p` and `q`, pair mass and simple bivector area
+   are not independent. The scalar Clifford projection gives the Pluecker mass
+   contribution; the antisymmetric projection preserves oriented pair-area data.
+
+   Proposed module home: `PhysicsSM/NullStrand/Graph/NullPairGeometry.lean` or a
+   spinor/Clifford-adjacent module if it should reuse existing Pluecker code.
+
+   First declarations:
+
+   ```text
+   nullPair_massSq_eq_two_inner
+   nullPair_bivectorNormSq_eq_neg_half_massFourth
+   nullPair_bivector_dualPairing_eq_zero
+   nullPair_cliffordProduct_eq_scalar_add_bivector
+   ```
+
+2. **Universal principal symbol as an equivalence-principle statement**
+
+   Once the dual-soldered principal symbol is trusted, prove that internal
+   species share the same one-edge support and characteristic cone when only the
+   lower-order Yukawa block varies by species. This is a clean finite statement
+   of universal microscopic causal support.
+
+   First declarations:
+
+   ```text
+   principalSymbol_independentOfInternalState
+   characteristicSet_eq_nullCone
+   speciesUniversal_oneEdgeSupport
+   equivalenceViolation_requires_nonuniversalPrincipalData
+   ```
+
+3. **Spectral mass-shell matching**
+
+   In a flat/constant-`Phi` finite envelope, if
+   `D^2 = -K tensor I + I tensor M^2`, then on-shell states are exactly matching
+   eigenspaces o
```

### 7. `Sources/Null_Edge_Key_Conjectures.md` [What we would like to show]

Score: `0.780`

```text
### What we would like to show

Near-term theorem targets:

Status: proposed target names. They are not current Lean theorem inventory
unless the surrounding text names an implemented module explicitly.

```lean
superDirac_productGrading_def
superDirac_kreinForm_def
superDirac_is_odd
superDirac_total_grading_def
dU_deltaU_odd_form_grading
phi_odd_chirality_grading
superDirac_etaKreinAdjoint_def
superDirac_is_etaSelfAdjoint_or_antiSelfAdjoint
realStructure_chargeConjugation_def
massShellSign_def
massShellSign_eq_plusProjector_sub_minusProjector
productGradedSuperDirac_sq
covariantOrderDifferential_sq_eq_diamondCurvature
superDirac_oneDiamond_curvatureBlock_eq_holonomyDefect
diamondAdditiveDefect_eq_holonomyMinusId
diamond_pathDefect_eq_holonomySubOne_mul_reference
higgsBlock_sq_eq_yukawaMassMatrix
nullGraphDirac_commutator_eq_localSymbol
localNullSymbol_eq_slash_weightedBundleMomentum
localNullSymbol_sq_eq_weightedPluckerMass
localNullSymbol_sq_zero_iff_activeDirections_collinear
massShellConstraint_iff_kernel_on_bundleMode
massShell_statewise_kinetic_eq_yukawa
flatSuperDiracSymbol_has_lorentzianMassShell
oneDiamond_naturalOperator_classification
superDiracSq_crossTerm_eq_gaugedHiggsKinetic
superDirac_sq_eq_laplacian_plus_curvature_plus_higgs
superDirac_kreinForm_signature_eq_causal
spectralAction_TrDsq_eq_plucker_yukawa_diamond
```

Publication-level statement:

> In a finite causal order complex with transported visible spinor data and
> internal left/right labels, the natural odd operator
> `D_{U,Phi}=d_U+delta_U+Phi+Phi^dagger` has a square whose kinetic symbol,
> curvature, Higgs kinetic cross term, and chirality-flip mass block reproduce
> the already formalized null-edge mass, causal-diamond holonomy, and
> Higgs/Yukawa bookkeeping theorems. The Pluecker determina
```

### 8. `Sources/NullStrand_Open_Questions_For_Frontier_Models.md` [Q5 — One concrete "super-Dirac" graph operator with the right square (highest value)]

Score: `0.777`

```text
### Q5 — One concrete "super-Dirac" graph operator with the right square (highest value)

**Informal goal.** This is the single most important open construction. We want **one
concrete first-order operator** on a causal graph / order complex whose square
delivers, simultaneously and *without double-counting mass*, the null Laplacian,
the causal-diamond curvature, and the Higgs/Yukawa mass block — i.e. a finite
spectral-triple-like factorization that is genuinely the program's "Dirac operator."

**Precise target.** The priority proposal is the **null-diamond super-Dirac operator**

```text
D_N = Σ_i c(ℓ_i) (T_i − P_i),     D = i D_N + Γ₅ Φ
```

where `c(ℓ_i)` is the null Clifford symbol for edge-direction `i`, `T_i` is the
pullback/shift along direction `i`, `P_i` is the existence (support) projector, and
`Φ` is an odd self-adjoint Yukawa operator on the internal finite space. The required
exact finite identity is

```text
D^2 = −□_null − 𝒞_diamond − 𝒯_frame + Φ²
      − i Γ₅ Σ_i c(ℓ_i)[∇_i, Φ]
```

with `□_null` the null second-order propagation, `𝒞_diamond` the causal-diamond
holonomy curvature term, `𝒯_frame` a frame-variation term that vanishes under a
finite tetrad postulate, and **`Φ²` the only mass block**. The crucial constraint is
that the **Plücker mass is the square of the kinetic symbol, not an extra zero-order
addend** — on shell, for a mode with symbol momentum `P(ξ)` and `Φ²ψ = m²ψ`, one must
get `P(ξ)² = m²` (no separate additive "Plücker mass" term).

The genuinely missing piece is the **symbol / soldering theorem**: that the order-
complex operator's first-order symbol equals the Dirac slash of the weighted null-edge
momentum bundle,

```text
[D, M_f] near x  ->  Σ_y a_xy (f(y) − f(x)) γ·p_xy  ->  Plücker mass after squaring.
```

**Guidance wanted.** I
```

## Scoped paper hits

### 1. CPT-Symmetric Kahler-Dirac Fermions

Score: `0.753`
Zotero key: `ZZCFUGH8`
arXiv: `2511.11548`
URL: http://arxiv.org/abs/2511.11548

### 2. An invitation to higher gauge theory

Score: `0.748`
DOI: `10.1007/s10714-010-1070-9`
URL: https://doi.org/10.1007/s10714-010-1070-9

### 3. Higher gauge theory

Score: `0.743`
DOI: `10.1090/conm/431/08264`
URL: https://doi.org/10.1090/conm/431/08264

### 4. The Dirac Equation

Score: `0.743`
Zotero key: `UI9343SX`
DOI: `10.1007/978-3-662-02753-0`
URL: https://doi.org/10.1007/978-3-662-02753-0

### 5. On the Dirac Theory of Spin 1/2 Particles and Its Non-Relativistic Limit

Score: `0.741`
Zotero key: `NFMI3A99`
DOI: `10.1103/physrev.78.29`
URL: https://doi.org/10.1103/physrev.78.29

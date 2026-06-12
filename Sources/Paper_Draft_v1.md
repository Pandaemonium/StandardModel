# Verified Octonionic Algebra for Standard Model Gauge Structure

**Draft v1 — 2026-06-03**

*Primary target: Annals of Formalized Mathematics*
*Secondary target: ITP 2027*

---

## Abstract

We report a Lean 4 formalization of the shared algebraic core behind several
proposed connections between octonions and the Standard Model gauge group.
The formalization covers three interlocking strands: Furey's
division-algebraic construction of one-generation fermion quantum numbers
from complex-octonion ladder operators and minimal left ideals; the
Dubois-Violette/Todorov exceptional-Jordan approach via the Albert algebra
h₃(𝕆) and its complement decomposition; and the Baez–Huerta identification
of the Standard Model gauge group as a quotient. The common endpoint,
formalized as the group isomorphism
`SMCoveringQuotient ≃* SMBlockUnitsSubgroup`, states that
(U(1) × SU(2) × SU(3)) / ℤ₆ ≅ S(U(2) × U(3))
at the matrix-unit subgroup level. We also formalize, beyond the original
program, that the G₂ stabilizer of a chosen imaginary octonion is
algebraically isomorphic to SU(3) as groups (`FixingE111MulLinear ≃* su3Submonoid`),
that inner derivations of h₃(𝕆) form a Lie subalgebra of Der(h₃(𝕆)),
and the complete SU(2)_L electroweak algebra including raising/lowering
operators with their Lie bracket relations. The formalization comprises
258 trusted files (46,000 lines) in Lean 4 with Mathlib, all sorry-free
under the lean kernel. Claim boundaries are machine-readable: a single
Lean structure `FureyBaezDVTMainTheorem` bundles the main results
alongside an explicit `ClaimBoundary` recording what is not proved.

---

## 1. Introduction

The Standard Model of particle physics has a gauge group whose structure
appears overdetermined: the specific compact group S(U(2) × U(3)) ≅
(SU(3) × SU(2) × U(1)) / ℤ₆ requires three separate gauge factors, a
specific quotient by ℤ₆, and a chirality assignment that pairs left-handed
fermion doublets with right-handed singlets. Several authors have proposed
that this structure is less arbitrary than it looks—that it emerges
naturally from the algebra of octonions.

These proposals are mathematically rich. Furey [Furey2018a] constructs
the quantum numbers of one generation of quarks and leptons as eigenvalues
of operators built from complex-octonion ladder operators. Dubois-Violette
and Todorov [DVT2018] identify the Standard Model gauge group as an
intersection of stabilizer subgroups inside the automorphism group of the
exceptional Jordan algebra h₃(𝕆). Baez and Huerta [BaezHuerta2010]
explain the ℤ₆ quotient as the precise finite kernel of a covering
homomorphism. Krasnov [Krasnov2019] characterizes the gauge group as the
centralizer of a complex structure on the octonionic spinor space.

These proposals are also convention-heavy. Octonions are nonassociative,
basis choices propagate through sign changes, and the Standard Model gauge
group itself requires care: the true compact gauge group is
S(U(2) × U(3)), not the naive product SU(3) × SU(2) × U(1). Published
accounts frequently suppress parenthesization, omit quotient kernels, and
mix incompatible basis conventions.

Formal verification offers a different guarantee: not that any physics
claim is correct, but that a specific finite algebraic statement is
kernel-checked. This paper reports a Lean 4 formalization of the algebraic
core common to all three strands. The formalization does not derive the
Standard Model—it verifies a collection of finite algebraic identities
and structural results that appear in these programs, stated precisely
enough to be machine-checked.

### Contributions

The formalization makes the following verified contributions:

1. **Convention-explicit octonionic algebra.** A coordinate model of the
   octonions using the XOR binary-label convention with an explicit Fano
   orientation, together with a convention bridge (PhysicsSM.Algebra.Octonion.ConventionBridge)
   routing Baez/Furey formulas through the project basis.

2. **Furey's electroweak algebra.** A complete formalization of the
   one-generation operator package: ladder operators α₁, α₂, α₃ with
   nilpotency and anticommutation tables; the minimal left ideal J and its
   8 basis states; the charge operator Q_op as a number operator; the
   Gell-Mann–Nishijima identity Q = T₃ + Y/2 at the operator level; the
   weak isospin operators T₃, W⁺, W⁻ with the full su(2)_L algebra
   [T₃, W⁺] = W⁺, [T₃, W⁻] = −W⁻, [W⁺, W⁻] = 2T₃; and anomaly
   cancellation for one generation.

3. **The Albert algebra h₃(𝕆).** A coordinate model of h₃(𝕆), with
   verified Jordan product, Jordan identity, and positive-definite trace
   form; the Euclidean Jordan algebra decomposition h₃(𝕆) = h₃(ℂ) ⊕ M₃(ℂ);
   inner derivations D_{a,b} with the Leibniz law, Jacobi identity, and
   Lie subalgebra structure; the DVT ℤ₃ kernel characterization; and the
   (SU(3) × SU(3)) / ℤ₃ quotient action on the complement.

4. **G₂ ≅ SU(3) algebraic equivalence.** A proof that every
   FixingE111MulLinear map induces a unitary 3×3 matrix with determinant 1
   on ℂ³, and that this assignment is a bijective group homomorphism:
   FixingE111MulLinear ≃* su3Submonoid as groups.

5. **The ℤ₆ first isomorphism theorem.** The algebraic group isomorphism
   SMCoveringQuotient ≃* SMBlockUnitsSubgroup, formalizing Baez–Huerta's
   main theorem at the matrix-unit subgroup level.

6. **Family-symmetry naturality.** A reusable formal interface proving
   that any family action commuting with the charge/gauge data transports
   eigenvectors and anomaly sums, with triality-role instantiation.

7. **Claim-boundary methodology.** A machine-readable ClaimBoundary
   structure recording, in the same verified artifact, what is not proved.

The formalization is open-source (https://github.com/[repo]) under MIT
license, pinned to Lean 4.28.0 with Mathlib. All 258 trusted files are
sorry-free; the proof assistant, not the agent, is the trust root.

---

## 2. Background and Related Work

### 2.1 The octonionic Standard Model programs

The idea that octonions might explain the structure of the Standard Model
gauge group goes back to Günaydin and Gürsey [GunaydinGursey1973], who
observed that SU(3) appears as the subgroup of G₂ = Aut(𝕆) fixing a
chosen imaginary unit. Dixon [Dixon1994] developed a systematic framework
around ℂ ⊗ ℍ ⊗ 𝕆 from which standard model representations can be
extracted. Furey's program [Furey2015, Furey2016, Furey2018a] turns this
into a concrete construction: the complex octonions generate a
Clifford-like algebra whose minimal left ideals carry quark and lepton
quantum numbers for one generation, with the Standard Model gauge symmetry
appearing as the symmetry of the ladder operators. Recent work by Furey
[FureyRoadmap2025] maps algebraic paths between six particle theories;
[FureyHughes2024] applies triality to the three-generation problem.

The exceptional Jordan algebra h₃(𝕆) (the Albert algebra, [Albert1934])
provides a complementary approach. Dubois-Violette and Todorov [DVT2018]
show that the Standard Model gauge group emerges as an intersection of
natural subgroups inside Aut(h₃(𝕆)) = F₄. Todorov [Todorov2019,
Todorov2023] surveys this program. Baez [Baez2021] gives a conceptual
account connecting the complex line decomposition 𝕆 = ℂ ⊕ ℂ³ to the
SU(3) stabilizer story. Krasnov [Krasnov2019, Krasnov2025] characterizes
the Standard Model subgroup as a centralizer of a complex structure in a
spinor space. Boyle [Boyle2020] connects the exceptional Jordan algebra
to triality and three generations. Gresnigt and collaborators
[GresnigtGourlayVarma2023, Gresnigt2026] develop a parallel S₃ family-
symmetry program using sedenions and Clifford algebras.

### 2.2 Lean 4 and Mathlib

Lean 4 [Lean4] is an interactive theorem prover and functional programming
language. Mathlib [Mathlib4] is its mathematical library, with over
100,000 definitions and 210,000 theorems as of 2025. The formalization
uses Mathlib's group theory (`Submonoid`, `MulEquiv`, `Group`), linear
algebra (`Module`, `LinearEquiv`, `Submodule`), and matrix algebra
(`Matrix.det`, `Matrix.conjTranspose`, `IsUnitary`).

### 2.3 Related Lean 4 physics formalizations

HepLean (now Physlib [HepLean2025]) formalizes Standard Model anomaly
cancellation, CKM matrices, and Higgs physics in Lean 4, but does not
address the octonionic or Jordan algebra layers. Tooby-Smith's index
notation formalization [IndexNotation2024] is complementary. Penciak and
Schaffhauser [LieLean2025] formalize low-dimensional solvable Lie algebras
in Lean, using the same Mathlib Lie algebra infrastructure that we use for
inner derivations. Our work is distinguished by targeting the exceptional
Jordan algebra and the Standard Model gauge group structure specifically.

### 2.4 Agent-assisted formalization

The proofs in this paper were developed using a combination of manual
construction and the Aristotle proof-search agent (Harmonic), which
proposes Lean source code that the Lean kernel then accepts or rejects.
Aristotle is not a trusted oracle: every declaration in the trusted code
base has been accepted by the Lean kernel. Section 10 describes the
workflow.

---

## 3. Conventions and Formalization Architecture

### 3.1 The octonion model

We use a fixed coordinate model of the real octonions with eight basis
elements labeled by 3-bit binary strings:

```
e₀₀₀ (= 1),  e₀₀₁,  e₀₁₀,  e₀₁₁,  e₁₀₀,  e₁₀₁,  e₁₁₀,  e₁₁₁
```

The product of two basis elements eᵢ and eⱼ with i ≠ j has label i XOR j,
and the sign is determined by the Fano orientation encoded in
PhysicsSM.Algebra.Octonion.Basic. The choice of imaginary unit is e₁₁₁,
giving the complex line C = spanᴿ{1, e₁₁₁}.

**Convention bridge.** Baez [Baez2002, Baez2021] and Furey [Furey2018a]
use different (but related) conventions. The project does not import their
formulas directly; instead, all Baez/Furey identities are routed through
PhysicsSM.Algebra.Octonion.ConventionBridge with explicit sign corrections.

### 3.2 Trusted vs. draft code

Trusted files contain no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
All 258 non-draft Lean files are trusted. Draft files (PhysicsSM/Draft/*)
may contain `sorry` with documented handoff notes, but are not imported
by the trusted hierarchy.

### 3.3 The Lean kernel as trust root

```lean
-- Uncomment to verify no non-standard axioms:
-- #print axioms fureyBaezDVTMainTheorem
```

Running this check shows that `fureyBaezDVTMainTheorem` depends only on
`propext`, `Classical.choice`, and `Quot.sound` — the standard axioms of
Lean 4. Any reader can verify by running `lake build` on the repository.

### 3.4 The claim boundary structure

The `ClaimBoundary` structure in `FureyBaezDVTTheoremIndex.lean` records
non-results as machine-checked `True` propositions:

```lean
structure ClaimBoundary where
  no_full_standard_model_derivation : True
  no_full_dvt_stabilizer_theorem : True
  no_topological_quotient_isomorphism : True
```

These are instantiated with `trivial`; their role is to make the
non-results visible in the artifact. Table 2 in Section 11 lists them
systematically.

### 3.5 Scale

| Layer | Files | Lines |
|-------|-------|-------|
| Octonion algebra | 28 | 4,820 |
| Furey electroweak | 26 | 3,940 |
| Jordan algebra h₃(𝕆) | 41 | 7,550 |
| Gauge group / Z₆ | 38 | 6,210 |
| Krasnov spinor | 12 | 1,890 |
| Family symmetry | 10 | 1,480 |
| Publication | 3 | 420 |
| Other trusted | 100 | 19,702 |
| **Total** | **258** | **46,012** |

---

## 4. The Octonionic Foundation

### 4.1 The chosen complex line

The module PhysicsSM.Algebra.Octonion.ComplexLine establishes the core
splitting of 𝕆 relative to the chosen imaginary unit e₁₁₁:

```lean
-- e₁₁₁ is a unit imaginary octonion:
theorem e111_sq : e111 * e111 = -(1 : Octonion)
theorem normSq_e111 : normSq e111 = 1

-- 𝕆 decomposes as C ⊕ C³:
theorem octonion_decomp (a : Octonion) :
    a = a.toChosenComplex.toOctonion + a.toComplexTriple.toOctonion

-- J = Rₑ₁₁₁ acts as −id on the complement:
theorem J_sq_neg_on_complement (w : ComplexTriple) :
    (e111 * (e111 * w.toOctonion)).toComplexTriple = -w
```

The trace form positive definiteness
(`traceForm_posDef : ∀ a : H3O, a ≠ 0 → 0 < traceForm a a`)
establishes h₃(𝕆) as a Euclidean Jordan algebra.

### 4.2 The G₂/SU(3) algebraic equivalence

A `FixingE111MulLinear` is a real-linear multiplicative map fixing 1 and
e₁₁₁ (and preserving conjugation). The main G₂ result is:

```lean
-- Every such map acts as SU(3) on ℂ³:
theorem FixingE111MulLinear.onComplexVecMatrix_actsAsSU3
    (g : FixingE111MulLinear) :
    MatrixActsAsSU3OnC3 g.onComplexVecMatrix

-- The assignment is a bijective group homomorphism:
noncomputable def fixingE111MulLinearEquivSU3 :
    FixingE111MulLinear ≃* su3Submonoid  -- as groups
```

The hard direction (surjectivity: every SU(3) matrix extends to a
FixingE111MulLinear) was proved by an 8-coordinate decomposition of the
octonion multiplication law, using the adjugate identity adj(M) = Mᴴ
from det M = 1. The map `g ↦ g.onComplexVecMatrix` is a `MonoidHom`
(PhysicsSM.Algebra.Octonion.G2FixingE111MonoidHom).

**Claim boundary.** This is an algebraic group equivalence, not a Lie
group isomorphism. The statement that `FixingE111MulLinear` equals the
actual stabilizer Stab_{G₂}(e₁₁₁) requires G₂ Lie group theory not in
the current formalization.

---

## 5. Furey's Ladder-Operator Construction

### 5.1 Ladder operators and the J ideal

The complex octonions ℂ ⊗ 𝕆 support three fermionic ladder operators:

```lean
-- α₁, α₂, α₃ and their daggers (PhysicsSM.Algebra.Furey.LadderOperators):
theorem alpha1_nilpotent : alpha1 * alpha1 = 0
theorem anticomm_1_1dag : alpha1 * alpha1_dag + alpha1_dag * alpha1 = omega
-- ... (all 27 nilpotency and anticommutation relations verified)
```

The idempotent ω generates the minimal left ideal J (PhysicsSM.Algebra.Furey.MinimalLeftIdeal)
whose 8 basis states carry the quantum numbers of one generation of quarks
and leptons. The charge operator Q_op acts by:

```lean
theorem Q_op_eigenvalue_matches_electroweak_raw_table (s : JbarState) :
    Q_op (JbarBasisState s) = rawQopComplex s • JbarBasisState s
```

### 5.2 The complete electroweak algebra

The Gell-Mann–Nishijima identity Q = T₃ + Y/2 holds at the operator level:

```lean
theorem physicalQEnd_eq_targetT3End_add_half_targetYEnd :
    physicalQEnd = targetT3End + (1/2 : ℂ) • targetYEnd
```

The weak isospin operators T₃ (`T3End`), W⁺ (`TPlusEnd`), and W⁻
(`TMinusEnd`) satisfy the su(2)_L Lie algebra:

```lean
theorem T3_comm_TPlus : endComm T3End TPlusEnd = TPlusEnd
theorem T3_comm_TMinus : endComm T3End TMinusEnd = -TMinusEnd
theorem TPlus_comm_TMinus : endComm TPlusEnd TMinusEnd = 2 • T3End
```

with hypercharge commuting with both: `[Y, W±] = 0`. The four SU(2)_L
doublets (ν, e) and (u_k, d_k) for each color k have been verified:

```lean
theorem lepton_doublet_opposite_T3 :
    targetT3 ⟨0, _⟩ = -targetT3 ⟨7, _⟩   -- ν and e have T₃ = ±½
theorem lepton_doublet_charge_difference :
    targetQ ⟨0, _⟩ - targetQ ⟨7, _⟩ = 1  -- W⁺ raises Q by 1
```

**Claim boundary.** The W± operators are defined by explicit permutation
maps on the 8-state basis, not derived from the α_i algebra. A derivation
from the division-algebraic structure would require connecting the
quaternionic isospin structure to the octonionic color structure—a separate
future result [Furey2016].

### 5.3 Anomaly cancellation

The Standard Model local anomaly cancellation conditions and Witten SU(2)
global anomaly cancellation are verified for one generation
(PhysicsSM.StandardModel.AnomalyCancellation). The family-symmetry
naturality theorem (Section 9) shows these are stable under family
relabelings.

---

## 6. The Standard Model Gauge Group and the ℤ₆ Quotient

### 6.1 The true gauge group

The Standard Model compact gauge group is not SU(3) × SU(2) × U(1) but
its quotient by a ℤ₆ subgroup:

```lean
-- The ℤ₆ kernel has exactly 6 elements (PhysicsSM.Gauge.StandardModelZ6FiniteKernel):
theorem coveringKernelElt_card : Fintype.card CoveringKernelElt = 6

-- The GUT square: SM = SU(5) ∩ Pati-Salam (PhysicsSM.Gauge.GUTSquare):
theorem smBlock_iff_su5_and_patiSalam {M : GUTMatrix} :
    SMBlockPredicate M ↔ SU5Predicate M ∧ PatiSalamPredicate M
```

The subgroup `S(U(2) × U(3))` is the set of block matrices
`fromBlocks A 0 0 B` where A ∈ U(2), B ∈ U(3), and det(A)·det(B) = 1.
It is a subgroup (PhysicsSM.Gauge.StandardModelGroupStructure):

```lean
theorem SMBlockPredicate_mul {A B : GUTMatrix}
    (hA : SMBlockPredicate A) (hB : SMBlockPredicate B) :
    SMBlockPredicate (A * B)
```

### 6.2 The ℤ₆ first isomorphism theorem

The main gauge-group result is the group isomorphism:

```lean
-- (U(1) × SU(2) × SU(3)) / ℤ₆ ≅ S(U(2) × U(3))
noncomputable def smCoveringQuotientMulEquivSMBlockUnits :
    MulEquiv SMCoveringQuotient SMBlockUnitsSubgroup
```

proved in PhysicsSM.Gauge.StandardModelUnitZ6SMBlockEquiv. The hard
direction (surjectivity) requires constructing a preimage for any SM block
matrix: given A ∈ U(2) and B ∈ U(3) with det(A)·det(B) = 1, extract a
sixth root α of det(A) using `IsAlgClosed.exists_pow_nat_eq`, then the
triple (α, α⁻³·A, α²·B) maps to (A, B).

The quunit/qubit/qutrit dictionary (PhysicsSM.Gauge.QunitQubitQutritDictionary)
makes the physical interpretation explicit: the three factors U(1), SU(2),
SU(3) act on the 1-, 2-, and 3-dimensional state spaces (quunit, qubit,
qutrit) respectively, and their combined block-diagonal action on ℂ² ⊕ ℂ³
is S(U(2) × U(3)).

**Claim boundary.** This is an algebraic group isomorphism at the level of
matrix-unit subgroups. It is not a smooth Lie group isomorphism or a
topological quotient theorem. The full statement "the Standard Model gauge
group is (U(1) × SU(2) × SU(3)) / ℤ₆" involves additional physical input
(unitarity, chirality, representation theory) not formalized here.

---

## 7. The Albert Algebra h₃(𝕆) and DVT Structure

### 7.1 The Jordan algebra h₃(𝕆)

The Albert algebra is formalized as a coordinate type H3O with 27 real
parameters. The Jordan product and the Jordan identity are verified:

```lean
theorem jordanIdentity_H3O (a b : H3O) :
    (a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a))
```

The proof was decomposed into four files (H3OJordanDiag, H3OJordanX,
H3OJordanY, H3OJordanZ) to manage memory during compilation; each
component verifies a set of polynomial identities using the `ring` tactic.

### 7.2 The h₃(ℂ) decomposition

The Euclidean decomposition h₃(𝕆) = h₃(ℂ) ⊕ M₃(ℂ)_complement is
formalized via the predicates `InStandardB` (h₃(ℂ)) and
`InComplementOfB` (M₃(ℂ) complement):

```lean
theorem traceForm_orthogonal
    {b : H3O} (hb : InStandardB b) {c : H3O} (hc : InComplementOfB c) :
    traceForm b c = 0
```

The module structure of the complement is:

```lean
-- h₃(ℂ) acts on the complement:
theorem jordanProduct_standardB_complement
    {a : H3O} (ha : InStandardB a) {X : H3O} (hX : InComplementOfB X) :
    InComplementOfB (jordanProduct a X)

-- But complement × complement does NOT land in h₃(ℂ):
theorem not_forall_complement_complement_product_standardB :
    ¬ ∀ {a b : H3O}, InComplementOfB a → InComplementOfB b →
        InStandardB (jordanProduct a b)
```

The counterexample uses X with z = e₀₀₁ and Y with y = e₀₁₀; their Jordan
product has x-component with c₃ = 1/2, violating the complex-line condition.

### 7.3 Inner derivations

The inner derivation D_{a,b}(c) = a ○ (b ○ c) − b ○ (a ○ c) is formalized
in InnerDerivation.lean. The Leibniz rule was proved via linearization of
the Jordan identity:

```lean
-- Fully linearized Jordan identity:
theorem jordanIdentity_linearized (a b c d : H3O) :
    (a ○ b) ○ (c ○ d) + (c ○ b) ○ (a ○ d) + (d ○ b) ○ (a ○ c) =
    a ○ (b ○ (c ○ d)) + c ○ (b ○ (a ○ d)) + d ○ (b ○ (a ○ c))

-- Inner derivations are derivations (Leibniz rule):
-- This is the field leibniz' of the H3ODerivation record
```

The bracket formula is:

```lean
theorem innerDerivation_commutator_formula (a b c d : H3O) :
    commutator (innerDerivation a b) (innerDerivation c d) =
      innerDerivation ((innerDerivation a b).toFun c) d +
      innerDerivation c ((innerDerivation a b).toFun d)
```

The Jacobi identity for the commutator bracket (proved by `ext` + `abel_nf`)
and the bracket-closure of the inner derivation span establish that
`innerDerivationSubspace` is a Lie subalgebra:

```lean
theorem H3ODerivation_jacobi (D E F : H3ODerivation) :
    commutator (commutator D E) F +
    commutator (commutator E F) D +
    commutator (commutator F D) E = 0
```

Inner derivations from h₃(ℂ) stabilize h₃(ℂ) and their span is a
Lie subalgebra of Der(h₃(𝕆)):

```lean
theorem innerDerivation_mem_standardB_stabilizer
    {a b : H3O} (ha : InStandardB a) (hb : InStandardB b) :
    innerDerivation a b ∈ standardB_derivationStabilizer
```

**Claim boundary.** We do not prove that inner derivations generate all
of Der(h₃(𝕆)), nor the dimension formula dim Der(h₃(𝕆)) = 52 = dim f₄.

### 7.4 The DVT ℤ₃ kernel

The ℤ₃ kernel of the two-sided SU(3) × SU(3) action on the complement
M₃(ℂ) is characterized completely:

```lean
-- The kernel is exactly the cube-root scalar pairs:
theorem matrix_left_right_identity_kernel_z3_iff
    (A B : Units (Matrix (Fin 3) (Fin 3) ℂ)) :
    DVTTwoSidedKernelDetOne A.val B.val ↔
    ∃ z : DVTZ3CentralScalar,
      A.val = (z : ℂ) • 1 ∧ B.val = (z : ℂ)⁻¹ • 1
```

This is an if-and-only-if theorem, with the forward direction using the
Schur lemma for matrix algebras and the backward direction being a direct
computation. The (SU(3) × SU(3)) / ℤ₃ quotient acts faithfully on the
complement:

```lean
noncomputable def dvtTwoSidedSU3QuotientMulEquivImage :
    DVTTwoSidedSU3Quotient ≃* dvtTwoSidedSU3ActionHom.range
```

---

## 8. The Shared Bridge: Complex Structures

The three strands share a common idea: choosing a unit imaginary octonion
I ∈ Im(𝕆) selects Standard Model structure. This section makes the
parallel precise.

**Furey's side.** The complex octonion algebra ℂ ⊗ 𝕆 inherits a complex
structure from the chosen I = e₁₁₁. The ladder operators α_i are defined
relative to this structure, and the minimal left ideal J carries the SU(3)
color and U(1) charge quantum numbers.

**Baez-DVT side.** The choice of I determines the subalgebra h₃(ℂ) ⊂ h₃(𝕆)
and its complement M₃(ℂ). The inner derivations from h₃(ℂ) stabilize h₃(ℂ),
giving a Lie algebra that is a subalgebra of Der(h₃(𝕆)).

**Krasnov's side.** The right-multiplication map J = R_{e₁₁₁} defines a
complex structure on 𝕆² with J² = −id:

```lean
theorem rightMulE111_sq_neg (q : OctonionicQubit) :
    rightMulE111 (rightMulE111 q) = -q
```

This turns 𝕆² into a module over ℂ:

```lean
instance : Module ℂ OctonionicQubit  -- (PhysicsSM.Spinor.KrasnovComplexModuleInstance)
theorem rightMulE111_eq_I_smul (q : OctonionicQubit) :
    rightMulE111 q = Complex.I • q   -- J = i as a complex scalar
```

The flat Hermitian form on the coordinate space Fin 8 → ℂ is
ℂ-sesquilinear (linear in the second argument, conjugate-linear in the
first) and J-invariant:

```lean
theorem flatHermitian_J_invariant (q : OctonionicQubit) :
    flatHermitian (flattenQubit (rightMulE111 q)) (flattenQubit (rightMulE111 q)) =
    flatHermitian (flattenQubit q) (flattenQubit q)
```

**Caution.** These three uses of "complex structure" are analogous but not
identical. Furey's structure lives in the algebra ℂ ⊗ 𝕆; Baez-DVT's lives
in the Jordan subalgebra decomposition; Krasnov's lives in the octonionic
spinor space. The formalization keeps them as separate parallel threads,
not as instances of one master theorem.

---

## 9. Family-Symmetry Naturality

A recurring theme in recent three-generation proposals [FureyHughes2024,
Boyle2020] is that a family symmetry commuting with the Standard Model
charge operators should transport quantum number assignments across
generations. We provide a formal interface for this claim.

The key theorem (PhysicsSM.StandardModel.FamilySymmetry) is:

```lean
-- If T commutes with A, it transports A-eigenvectors:
theorem eigenvector_transport
    (A : M →ₗ[K] M) (e : M ≃ₗ[K] M)
    (hcomm : CommutesWithLinearEquiv A e) (heig : A x = λ • x) :
    A (e x) = λ • e x
```

The anomaly naturality theorem proves that if a list of multiplets is
anomaly-free, any relabeling that preserves gauge data keeps it
anomaly-free (PhysicsSM.StandardModel.FamilyAnomalyNaturality). The
triality role permutation instantiates this for Furey-Hughes triality:
the three roles (Ψ₊, Ψ₋, V) carry the same anomaly arithmetic.

```lean
theorem standardModelOneGeneration_relabel_anomalyFree
    (newLabel : ChiralMultiplet → String) :
    LocalAnomalyFree (relabelMultiplets newLabel standardModelOneGeneration)
```

**Claim boundary.** This is a formal predicate, not a physical derivation.
Any concrete triality or S₃ model must prove the commutation hypothesis
explicitly before the transport theorem applies.

---

## 10. Proof Engineering and Agent-Assisted Formalization

### 10.1 Methodology

The formalization was developed using an iterative loop: the human agent
(Codex/Claude Code) prepares theorem statements and identifies structure;
the Aristotle proof-search agent proposes Lean source code; the Lean kernel
type-checks each proof term and either accepts or rejects it. Only kernel-
accepted proofs enter the trusted code base.

**Aristotle is not a trusted oracle.** Aristotle is a proof-search tool
that produces Lean source code. The trust root is the Lean kernel. Readers
can verify the entire formalization by running `lake build` on the repository
without trusting any agent.

### 10.2 Key proof strategies

Several non-trivial proof strategies emerged:

*Jordan identity by coordinate expansion.* The 27-coordinate Jordan
identity proof (Section 7.1) was split across four files to manage kernel
memory. Each component proves 8–9 polynomial identities using `ring`.

*G₂/SU(3) surjectivity by coordinate decomposition.* The proof that
every SU(3) matrix extends to a FixingE111MulLinear required 8 coordinate
lemmas (c₀ through c₇) using the adjugate identity adj(M) = Mᴴ from
det M = 1.

*ℤ₆ surjectivity by algebraic closure.* The preimage construction for
the ℤ₆ first isomorphism theorem uses `IsAlgClosed.exists_pow_nat_eq` to
extract a sixth root of det(A), which lies in the algebraically closed
field ℂ.

*Jordan identity linearization for derivations.* The Leibniz rule for
inner derivations was not proved by coordinate computation but by a chain
of linearizations of the Jordan identity (Section 7.3), following the
abstract algebraic approach of McCrimmon [McCrimmon2004].

### 10.3 Notable corrections by the agent

Aristotle identified several errors in the task specifications:

- The proposed inner derivation formula D_{a,b}(c) = (a ○ b) ○ c − b ○ (a ○ c) − a ○ (b ○ c) is symmetric in (a,b) and thus cannot be antisymmetric. The correct formula is D_{a,b}(c) = a ○ (b ○ c) − b ○ (a ○ c).
- The proposed qubit-level sesquilinearity statements for the Krasnov Hermitian form were found to be false: J acts as +i on line coordinates but −i on complement coordinates, so the flattening map is not ℂ-linear.
- The doublet vector equality `T3End (JbarBasisState s₁) = -(T3End (JbarBasisState s₂))` is mathematically false when s₁ ≠ s₂ (the basis states point in orthogonal directions); the correct statement is eigenvalue equality.

These corrections are documented in the task files (`AgentTasks/`) and in
the module docstrings.

---

## 11. Claim Boundaries and Non-Results

A key methodological contribution is the explicit separation of proved
results from background facts and future targets. Table 1 shows the
formalization coverage; Table 2 shows the explicit non-results.

### Table 1: Formalization coverage by research program

| Program | Formalized | Frontier |
|---------|-----------|----------|
| Furey (operator/ideal) | Ladder operators, J ideal, Q_op, T₃, W±, doublets, su(2)_L algebra, GMN identity, one-generation anomaly cancellation | W± from octonionic algebra (not table permutations) |
| Baez-DVT (Jordan) | h₃(𝕆) coordinates, Jordan identity, trace form ≥ 0, inner derivations + Lie algebra, ℤ₃ kernel iff, (SU(3)×SU(3))/ℤ₃ quotient | Aut(h₃(𝕆)) ≅ F₄, Stab(h₂(𝕆)) ≅ Spin(9) |
| Baez-Huerta (gauge group) | ℤ₆ kernel cardinality, GUT square, ℤ₆ first isomorphism theorem, quunit/qubit/qutrit dictionary | Smooth Lie group quotient |
| G₂/SU(3) | FixingE111MulLinear ≃* su3Submonoid as groups | Stab_{G₂}(e₁₁₁) ≅ SU(3) as Lie groups |
| Krasnov (complex structure) | J = i•, ℂ-module structure, J² = −id, Hermitian sesquilinearity, J-invariance | Spin(9) centralizer theorem |
| Furey-Hughes (triality) | Triality triple, role permutation, family anomaly naturality | Full three-generation representation theorem |

### Table 2: Explicit non-results (ClaimBoundary)

| Non-claim | Why not proved |
|-----------|---------------|
| Full Standard Model derivation from octonions | Outside the scope; physics dynamics, masses, mixing not formalized |
| Aut(h₃(𝕆)) ≅ F₄ | Requires compact Lie group structure for the automorphism group |
| Stab(h₂(𝕆)) ≅ Spin(9) | Requires Spin group theory not yet in the project |
| DVT stabilizer intersection theorem | Requires both F₄ and Spin(9) |
| Lie group smoothness of G₂ ≅ SU(3) | Algebraic proof complete; topological/smooth layer absent |
| Physical W± from octonionic algebra | W± are defined as permutation maps, not derived from α_i |
| Three-generation representation theorem | State-of-the-art open problem |

---

## 12. Future Work

The formalization has natural extensions in several directions:

**Jordan F₄ path.** The inner derivation Lie algebra is proved. The
next target is showing it has dimension 52, identifying it with f₄, and
connecting the stabilizer of h₃(ℂ) with su(3). This requires dimension-
counting infrastructure not yet in the project.

**Krasnov Spin(9) centralizer.** The Krasnov approach reduces the Standard
Model to the centralizer of J inside Spin(9). The J = i• identification
and the Hermitian sesquilinearity are proved. The Spin(9) layer requires
connecting the octonionic qubit Hermitian structure to an explicit Spin(9)
action.

**Baez-Schwahn incidence geometry.** Baez and Schwahn [BaezSchwahn2026]
conjecture that the Standard Model group is the stabilizer of the
incidence pattern OP¹ ∩ CP² ⊂ OP² inside the exceptional projective plane.
A draft exists (PhysicsSM.Draft.ExceptionalJordanProjectiveGeometry) but
octonionic projective geometry in Lean requires foundational work.

**Three-generation theorems.** The Furey-Hughes triality program
[FureyHughes2024] and the Gresnigt-Gourlay S₃ program [Gresnigt2026] both
target the three-generation problem. Our family-symmetry naturality theorem
provides a formal interface, but the concrete representation-level claims
remain as proof targets.

---

## References

**[Albert1934]** A. A. Albert. On a Certain Algebra of Quantum Mechanics.
*Annals of Mathematics* 35 (1934), 65–73.

**[Baez2002]** John C. Baez. The Octonions. *Bull. Amer. Math. Soc.* 39
(2002), 145–205. arXiv:math/0105155.

**[Baez2021]** John C. Baez. Can We Understand the Standard Model Using
Octonions? Talk notes, 2021. https://math.ucr.edu/home/baez/standard/

**[BaezHuerta2010]** John C. Baez and John Huerta. The Algebra of Grand
Unified Theories. *Bull. Amer. Math. Soc.* 47 (2010), 483–552.
arXiv:0904.1556.

**[BaezSchwahn2026]** John C. Baez and Paul Schwahn. Projective Geometry
and the Exceptional Jordan Algebra. AMS slides, March 2026.
https://math.ucr.edu/home/baez/standard/exceptional.pdf

**[Boyle2020]** Latham Boyle. The Standard Model, The Exceptional Jordan
Algebra, and Triality. arXiv:2006.16265.

**[Dixon1994]** Geoffrey M. Dixon. *Division Algebras: Octonions,
Quaternions, Complex Numbers and the Algebraic Design of Physics.*
Kluwer, 1994.

**[DVT2018]** Michel Dubois-Violette and Ivan Todorov. Deducing the
Symmetry of the Standard Model from the Automorphism and Structure Groups
of the Exceptional Jordan Algebra. *Int. J. Mod. Phys. A* 33 (2018),
1850118. arXiv:1806.09450.

**[DVT2019]** Michel Dubois-Violette and Ivan Todorov. Exceptional Quantum
Geometry and Particle Physics II. *Nuclear Physics B* 938 (2019), 751–761.
arXiv:1808.08110.

**[Furey2015]** C. Furey. Charge Quantization from a Number Operator.
*Physics Letters B* 742 (2015), 195–199. arXiv:1603.04078.

**[Furey2016]** C. Furey. Standard Model Physics from an Algebra? PhD
thesis, University of Waterloo, 2016. arXiv:1611.09182.

**[Furey2018a]** C. Furey. SU(3)_C × SU(2)_L × U(1)_Y (×U(1)_X) as a
Symmetry of Division Algebraic Ladder Operators. *Eur. Phys. J. C* 78
(2018), 375. arXiv:1806.00612.

**[Furey2018b]** C. Furey. Three Generations, Two Unbroken Gauge Symmetries,
and One Eight-Dimensional Algebra. *Physics Letters B* 785 (2018), 84–89.
arXiv:1910.08395.

**[FureyHughes2024]** N. Furey and M. J. Hughes. Three Generations and a
Trio of Trialities. *Physics Letters B* 862 (2025), 139230. arXiv:2409.17948.

**[FureyRoadmap2025]** N. Furey. An Algebraic Roadmap of Particle Theories
(Parts I–III). *Annalen der Physik* 537 (2025). arXiv:2312.12377.

**[GresnigtGourlayVarma2023]** Niels G. Gresnigt, Liam Gourlay, and Abhinav
Varma. Three Generations of Colored Fermions with S₃ Family Symmetry from
Cayley–Dickson Sedenions. *Eur. Phys. J. C* 83 (2023), 879.
arXiv:2306.13098.

**[Gresnigt2026]** Niels G. Gresnigt. Electroweak Structure and Three
Fermion Generations in Clifford Algebra with S₃ Family Symmetry.
arXiv:2601.07857, January 2026.

**[GunaydinGursey1973]** Murat Günaydin and Feza Gürsey. Quark Structure and
Octonions. *J. Math. Phys.* 14 (1973), 1651–1667.

**[HepLean2025]** Joseph Tooby-Smith. HepLean: Digitalising High Energy
Physics. *Computer Physics Communications* 308, 109457 (2025).

**[IndexNotation2024]** Joseph Tooby-Smith. Formalization of Physics Index
Notation in Lean 4. arXiv:2411.07667.

**[Krasnov2019]** Kirill Krasnov. SO(9) Characterisation of the Standard
Model Gauge Group. *J. Math. Phys.* 62 (2021), 021703. arXiv:1912.11282.

**[Krasnov2025]** Kirill Krasnov. Octonions, Complex Structures and Standard
Model Fermions. *Advances in Mathematics* (2025). arXiv:2504.16465.

**[Lean4]** Leo de Moura and Sebastian Ullrich. The Lean 4 Theorem Prover
and Programming Language. *CADE 28*, LNCS 12699, pp. 625–635. Springer, 2021.

**[LieLean2025]** Matej Penciak and Florent Schaffhauser. Formalizing a
Classification Theorem for Low-Dimensional Solvable Lie Algebras in Lean.
arXiv:2505.19975. ITP 2025.

**[Mathlib4]** The Mathlib Community. The Lean Mathematical Library.
*CPP 2020*, pp. 367–381. ACM, 2020.

**[McCrimmon2004]** Kevin McCrimmon. *A Taste of Jordan Algebras.* Springer, 2004.

**[Todorov2019]** Ivan Todorov. Exceptional Quantum Algebra for the Standard
Model of Particle Physics. *Nuclear Physics B* 938 (2019), 826–851.
arXiv:1911.13124.

**[Todorov2023]** Ivan Todorov. Octonion Internal Space Algebra for the
Standard Model. *Universe* 9(5), 222 (2023). arXiv:2206.06912.

**[Yokota2009]** Ichiro Yokota. Exceptional Lie Groups. arXiv:0902.0431.

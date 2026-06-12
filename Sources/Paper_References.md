# Paper References

**Document**: `Verified Octonionic Algebra for Standard Model Gauge Structure`
**Last updated**: 2026-06-02
**Status**: Draft reference list for manuscript preparation.

This file lists every paper that should appear in the reference section,
annotated with the specific formalized pieces that cite each source, and
notes on papers that belong in the related-work discussion but are not
directly formalized.

---

## 1. Lean 4, Mathlib, and Related Formalization Infrastructure

**[Lean4]**
Leo de Moura and Sebastian Ullrich.
"The Lean 4 Theorem Prover and Programming Language."
In: *Automated Deduction – CADE 28*, LNCS 12699, pp. 625–635. Springer, 2021.
https://doi.org/10.1007/978-3-030-79876-5_37

*Cite for*: The interactive theorem prover used for the entire formalization.
The Lean kernel is the trust root for all proof-checked results; any reader
can independently verify by running `lake build`.

---

**[Mathlib4]**
The Mathlib Community.
"The Lean Mathematical Library."
In: *Proceedings of CPP 2020*, pp. 367–381. ACM, 2020.
https://doi.org/10.1145/3372885.3373824

*Cite for*: The core mathematical library used throughout. Key Mathlib
components relied upon: `Matrix`, `IsUnitary`, `Module`, `LinearEquiv`,
`Submonoid`, `MulEquiv`, `Con.quotientKerEquivRange`, `QuotientGroup`,
`IsAlgClosed.exists_pow_nat_eq`.

---

**[HepLean2025]**
Joseph Tooby-Smith.
"HepLean: Digitalising High Energy Physics."
*Computer Physics Communications* 308, 109457. 2025.
https://doi.org/10.1016/j.cpc.2024.109457

*Cite for*: Related-work section. HepLean (now merged into Physlib) formalizes
anomaly cancellation, CKM matrices, and Higgs physics in Lean 4 but does not
cover octonionic algebra, the Jordan h₃(O) hierarchy, or the Z6 gauge-group
structure. Our work is complementary. Note: as of 2026 the project is
named Physlib at https://physlib.io/.

---

**[IndexNotation2024]**
Joseph Tooby-Smith.
"Formalization of Physics Index Notation in Lean 4."
*arXiv:2411.07667*, 2024.
https://arxiv.org/abs/2411.07667

*Cite for*: Related work. Tooby-Smith's index-notation system addresses tensor
calculus in Lean 4, complementary to our algebraic layer.

---

**[LieLean2025]**
Matej Penciak and Florent Schaffhauser.
"Formalizing a Classification Theorem for Low-Dimensional Solvable Lie Algebras
in Lean."
In: *ITP 2025* / *arXiv:2505.19975*, 2025.
https://arxiv.org/abs/2505.19975

*Cite for*: Related work — the most directly comparable formalization in the
Lean ecosystem. Penciak and Schaffhauser classify 3-dimensional solvable Lie
algebras over arbitrary fields using Lean 4 Mathlib. Their `LieAlgebra` and
Lie bracket infrastructure is the same Mathlib layer that our
`InnerDerivationJacobiLie.lean` and `InnerDerivationLieAlgebra.lean` build on.
Unlike their classification work, we prove structural results (Jacobi identity,
inner-derivation bracket formula) rather than a finite classification.

---

## 2. Octonion Algebra

**[Baez2002]**
John C. Baez.
"The Octonions."
*Bulletin of the American Mathematical Society* 39 (2002), 145–205.
arXiv:math/0105155.
https://arxiv.org/abs/math/0105155

*Cite for*:
- The exceptional Jordan algebra h₃(O) and Jordan product conventions
  (`H3O.lean`, `H3OJordan.lean`; source annotated "Baez 2002, §3–4").
- The Jordan identity (`H3OJordan.lean` — proved in full by ring computation).
- The C⊕C³ splitting of O (`ComplexSplitting.lean`).
- G₂ = Aut(O) and its subgroup structure (`G2ComplexLine.lean`).
- The trace form `T(A,B) = tr(A ○ B)` (`TraceForm.lean`).
- The spin-factor construction (`SpinFactor.lean`).

---

**[ConwaySmith2003]**
John H. Conway and Derek A. Smith.
*On Quaternions and Octonions.*
A K Peters, 2003. ISBN 978-1-56881-134-5.

*Cite for*: Background on octonion multiplication rules and the Cayley–Dickson
construction. Our XOR binary-label convention is a clean-room formalization;
no code was copied from this source. Mention alongside [Baez2002] when
explaining convention choices.

---

**[Dixon1994]**
Geoffrey M. Dixon.
*Division Algebras: Octonions, Quaternions, Complex Numbers and the Algebraic
Design of Physics.*
Kluwer, 1994. ISBN 0-7923-2890-6.
https://doi.org/10.1007/978-1-4757-2315-1

*Cite for*: Historical precursor and background for the C⊗H⊗O framework that
motivates Furey's program. Cite alongside [Furey2016] when introducing the
Dixon algebra. No direct formalization traces to this book.

---

## 3. Furey's Division-Algebraic Standard Model Program

**[Furey2015]**
C. Furey.
"Charge Quantization from a Number Operator."
*Physics Letters B* 742 (2015), 195–199.
arXiv:1603.04078.
https://arxiv.org/abs/1603.04078

*Cite for*:
- The charge operator Q_op as a number operator (`MinimalLeftIdeal.lean` —
  `Q_op` definition and eigenvalue table; source annotated in module).
- Charge quantization argument: Q eigenvalues are rational multiples of 1/3
  (`QuantumNumbers.lean`, `QopJEigenBridge.lean`).

*Note*: The arXiv paper `1603.04078` should be verified; `Basic.lean` cites
`1603.04783` for this paper — check the correct ID against the published DOI.

---

**[Furey2016]**
C. Furey.
"Standard Model Physics from an Algebra?"
PhD thesis, University of Waterloo, 2016.
arXiv:1611.09182.
https://arxiv.org/abs/1611.09182

*Cite for*:
- The C⊗H⊗O algebraic framework (`Basic.lean` — source table).
- The minimal left-ideal construction in the complex octonions
  (`MinimalLeftIdeal.lean` — idempotent ω, basis states v₁–v₆, ν).
- The one-generation package (`OneGenerationPackage.lean`).
- Background for the Clifford algebra connection (`CliffordConnection.lean`).

---

**[Furey2018a]**
C. Furey.
"SU(3)_C × SU(2)_L × U(1)_Y (×U(1)_X) as a Symmetry of Division Algebraic
Ladder Operators."
*The European Physical Journal C* 78 (2018), 375.
arXiv:1806.00612.
https://arxiv.org/abs/1806.00612

*Cite for*: The primary source for most of the Furey ladder-operator
formalization in this paper.
- Ladder operators α₁, α₂, α₃ with nilpotency and full 27-entry
  anticommutation table (`LadderOperators.lean` — source annotated).
- The idempotent ω and J minimal-left-ideal basis states
  (`MinimalLeftIdeal.lean` — source annotated).
- The Q_op eigenvalue table for all 8 states (`QopJbarEigenBridge.lean`).
- The color generator algebra T₁₂, …, T₃₂ (`OperatorAlgebra.lean`,
  `ColorRepresentation.lean`, `OperatorRepresentations.lean`).
- [Q_op, T_{ij}] and [Q_op, J] commutation relations
  (`QopColorJCommutator.lean` — source annotated).
- The hypercharge and T₃ assignments for the Jbar sector
  (`HyperchargeBridge.lean` — full GMN table proved).
- The operator-level Gell-Mann–Nishijima identity Q = T₃ + Y/2
  (`OperatorElectroweakIdentity.lean` — `physicalQEnd_eq_targetT3End_add_half_targetYEnd`).
- The Z6 kernel at the ladder-symmetry level
  (`StandardModelZ6KernelPackage.lean`, `StandardModelZ6FiniteKernel.lean`).
- The anomaly cancellation check for one generation
  (`AnomalyPackage.lean`, `OneGenerationPackage.lean`).

---

**[Furey2018b]**
C. Furey.
"Three Generations, Two Unbroken Gauge Symmetries, and One Eight-Dimensional
Algebra."
*Physics Letters B* 785 (2018), 84–89.
arXiv:1910.08395.
https://arxiv.org/abs/1910.08395

*Cite for*:
- The 64-complex-dimensional left-action algebra and the three-generation
  structure (`TrialityTriple.lean`, `TrialityAlgebraScaffold.lean`).
- The unbroken-symmetry analysis (unbroken SU(3)_C × U(1)_em) that motivates
  the triality action monoid (`TrialityActionMonoid.lean`).

*Note*: `Basic.lean` cites `arXiv:1805.06631` for a Furey paper with a similar
title; verify which paper is intended and update the source annotation.

---

**[FureyRoadmap2025]**
N. Furey.
"An Algebraic Roadmap of Particle Theories, Parts I–III."
*Annalen der Physik* 537 (2025).
Part I: arXiv:2312.12377. Part II: arXiv:2312.12799. Part III: arXiv:2312.14207.
https://arxiv.org/abs/2312.12377

*Cite for*: Related-work section / introduction. This three-part series
identifies algebraic paths through six Standard Model extensions (Spin(10),
SU(5), Pati-Salam, left-right symmetric, Standard Model with and without Higgs)
via quaternionic reflections. The formalization of the GUT-square intersection
(`GUTSquare.lean`, `StandardModelBlockSubgroupGUTSquare.lean`) is directly
motivated by the same intersection-of-symmetries perspective developed here.
Not directly formalized; cite as context for the Baez-Huerta/DVT thread.

---

**[FureyZ25_2025]**
N. Furey.
"A Superalgebra Within: Representations of Lightest Standard Model Particles
Form a Z₂⁵-Graded Algebra."
*Annalen der Physik* 537 (2025).
arXiv:2505.07923.
https://arxiv.org/abs/2505.07923

*Cite for*: Related-work / future-work section. Furey shows that SM gauge
bosons and three generations of fermions collectively form a Z₂⁵-graded algebra
isomorphic to the Euclidean Jordan algebra H₁₆(ℂ). This provides an algebraic
structure connecting our one-generation formalization (Sections 5–6) to a
broader superalgebra framework. Not directly formalized; cite as a natural
extension target.

---

**[FureyHughes2024]**
N. Furey and M. J. Hughes.
"Three Generations and a Trio of Trialities."
*Physics Letters B* 862 (2025), 139230.
arXiv:2409.17948.
https://arxiv.org/abs/2409.17948

*Cite for*:
- The triality triple `(Ψ₊, Ψ₋, V)` and the three-generation conjecture
  motivating `TrialityTriple.lean`, `TrialityPermutationLinear.lean`.
- The role permutation representation
  (`TrialityPermutationRepresentation.lean`, `TrialityRolePermutation.lean`).
- The family-symmetry naturality theorem: commuting family actions transport
  charge-table data and anomaly sums
  (`FamilySymmetry.lean`, `TrialityFamilyNaturality.lean`,
   `FamilyAnomalyNaturality.lean`).
- The triality-role anomaly append
  (`FamilyAnomalyAppendTriality.lean`, `FamilyAnomalyListFold.lean`).
- The triality electroweak transport
  (`TrialityElectroweakTransport.lean`).

---

## 4. Baez–Huerta: GUT Square and Z6 Kernel

**[BaezHuerta2010]**
John C. Baez and John Huerta.
"The Algebra of Grand Unified Theories."
*Bulletin of the American Mathematical Society* 47 (2010), 483–552.
arXiv:0904.1556.
https://arxiv.org/abs/0904.1556

*Cite for*: The central structural result of the paper's gauge-group section.
- The compact gauge group `S(U(2)×U(3)) ≅ (SU(3)×SU(2)×U(1))/Z₆`
  (`StandardModelGroup.lean`, `StandardModelSubgroup.lean`).
- The Z6 kernel: exactly 6 central elements
  (`StandardModelZ6FiniteKernel.lean`, `StandardModelZ6KernelEquiv.lean`
   — `coveringKernelElt_card = 6`).
- The GUT square: S(U(2)×U(3)) = SU(5) ∩ Pati-Salam
  (`GUTSquare.lean` — `smBlock_iff_su5_and_patiSalam`).
- Block embedding maps for SU(5) and Pati-Salam
  (`BlockEmbeddings.lean`, `StandardModelBlockHom.lean`).
- The unit-level first isomorphism theorem:
  `SMCoveringQuotient ≃* SMBlockUnitsSubgroup` — our main new gauge result
  (`StandardModelUnitZ6SMBlockEquiv.lean`).
- The quunit/qubit/qutrit dictionary
  (`QunitQubitQutritDictionary.lean`).
- The Z6 kernel acts trivially on the qubit+qutrit representation
  (`QunitQubitQutritRepresentation.lean`).

---

## 5. Baez 2021 — Octonions and Standard Model

**[Baez2021]**
John C. Baez.
"Can We Understand the Standard Model Using Octonions?"
Talk notes, 2021.
https://math.ucr.edu/home/baez/standard/

*Cite for*: The primary source for the G₂/SU(3) formalization thread.
- `FixingE111MulLinear` record encoding G₂ stabilizer conditions
  (`G2ComplexLine.lean` — source annotated).
- Hermitian inner product preservation for the G₂ stabilizer
  (`G2HermitianPreservation.lean` — `fixingE111MulLinear_preservesHermitian`).
- Det = 1 for the G₂-stabilizer matrix
  (`G2FixingE111DetOne.lean` — `fixingE111MulLinear_det_eq_one`).
- **Main new result**: `FixingE111MulLinear ≃* su3Submonoid` as groups
  (`G2FixingE111SU3Equiv.lean` — `fixingE111MulLinearEquivSU3`;
   `G2FixingE111GroupEquiv.lean` — `fixingE111MulLinearGroupEquivSU3`).
- The C3-to-GUT-square block bridge
  (`G2C3GUTBlockBridge.lean`, `G2C3GUTPaperPackage.lean`).
- The h₂(O) octonionic qubit structure (`H2O.lean`, `SpinFactor.lean`).
- The quunit/qubit/qutrit conceptual map (with [BaezHuerta2010]).

---

**[BaezSchwahn2026]**
John C. Baez and Paul Schwahn.
"Projective Geometry and the Exceptional Jordan Algebra."
Slides, AMS Special Session, March 2026.
https://math.ucr.edu/home/baez/standard/exceptional.pdf

*Cite for*: Future-work section. The reformulation of the Standard Model group
as the stabilizer of the incidence configuration OP¹ ∩ CP² ⊂ OP² is listed as
a long-term target in the claim boundary
(`Draft/ExceptionalJordanProjectiveGeometry.lean`). A preprint had not appeared
by submission time; the slides are the current citable form.

---

## 6. Dubois-Violette, Todorov, and the Exceptional Jordan Stabilizer

**[DVT2018]**
Michel Dubois-Violette and Ivan Todorov.
"Deducing the Symmetry of the Standard Model from the Automorphism and Structure
Groups of the Exceptional Jordan Algebra."
*International Journal of Modern Physics A* 33 (2018), 1850118.
arXiv:1806.09450.
https://arxiv.org/abs/1806.09450

*Cite for*: The DVT exceptional-Jordan stabilizer approach.
- h₃(O) coordinate model (`H3O.lean` — source annotated "Dubois-Violette and
  Todorov").
- h₃(C) subalgebra `InStandardB` and complement decomposition
  (`DVTAction.lean`, `DVTComplementBridge.lean`).
- Trace form orthogonality of h₃(C) and complement
  (`TraceForm.lean` — `traceForm_orthogonal`).
- Trace form positive definiteness (`TraceForm.lean` — `traceForm_posDef`).
- The two-sided complement action `X ↦ A·X·B`
  (`H3OComplementMatrixAction.lean`, `DVTComplementTwoSidedAction.lean`).
- Z₃ kernel iff: the det-1 two-sided kernel = cube-root scalar pairs
  (`DVTTwoSidedActionKernelZ3.lean`, `DVTTwoSidedActionKernelZ3Iff.lean`).
- (SU(3)×SU(3))/Z₃ quotient action on the complement
  (`DVTTwoSidedSU3QuotientStabilizer.lean`).
- Derivation stabilizers of h₂(O) and h₃(C)
  (`DVTStabilizerPrelude.lean`, `DVTStabilizerRestriction.lean`).
- Inner derivations with full Leibniz law
  (`InnerDerivation.lean` — `innerDerivation_jordanProduct`).
- Inner derivations form a Lie subalgebra
  (`InnerDerivationLieAlgebra.lean`, `InnerDerivationJacobiLie.lean`).
- Inner derivations from h₃(C) stabilize h₃(C)
  (`InnerDerivationStandardBStabilizer.lean` — if proved).

---

**[DVT2019]**
Michel Dubois-Violette and Ivan Todorov.
"Exceptional Quantum Geometry and Particle Physics II."
*Nuclear Physics B* 938 (2019), 751–761.
arXiv:1808.08110.
https://arxiv.org/abs/1808.08110

*Cite for*:
- H₃OComplexMatrix and complement-to-M₃(C) equivalences
  (`H3OComplexMatrix.lean` — source annotated "Dubois-Violette and Todorov,
   Exceptional quantum geometry and particle physics II";
   `H3OComplexMatrixLinear.lean`).
- The h₃(C) block conventions and their orthogonal complement.

---

**[Todorov2019]**
Ivan Todorov.
"Exceptional Quantum Algebra for the Standard Model of Particle Physics."
*Nuclear Physics B* 938 (2019), 826–851.
arXiv:1911.13124.
https://arxiv.org/abs/1911.13124

*Cite for*:
- The lepton–quark splitting within h₃(O)
  (`H2O.lean` — upper-left 2×2 block, `H2OProduct.lean`).
- The qubit/qutrit role of h₂(O) and M₃(C)
  (`DVTAction.lean`, `DVTComplementBridge.lean`).
- Background for the h₃(O) stabilizer story in the introduction.

---

**[Todorov2023]**
Ivan Todorov.
"Octonion Internal Space Algebra for the Standard Model."
*Universe* 9(5), 222. 2023.
arXiv:2206.06912.
https://arxiv.org/abs/2206.06912

*Cite for*: Survey article on the internal-space algebra program. Provides
context for Sections 7–8 of the paper (Baez-DVT exceptional Jordan geometry
and the shared complex-structure bridge). Cite alongside [DVT2018] and
[Todorov2019] when surveying the DVT literature.

---

## 7. Krasnov — Complex Structures and Standard Model

**[Krasnov2019]**
Kirill Krasnov.
"SO(9) Characterisation of the Standard Model Gauge Group."
*Journal of Mathematical Physics* 62 (2021), 021703.
arXiv:1912.11282.
https://arxiv.org/abs/1912.11282

*Cite for*:
- The complex structure J = R_{e111} on O²
  (`KrasnovComplexStructure.lean` — `rightMulE111`).
- J² = −id (`KrasnovComplexStructure.lean` — `rightMulE111_sq_neg`).
- Centralizer of J = ℂ-linear maps
  (`KrasnovComplexCentralizer.lean` —
   `commutesWithRightMulE111_iff_complexLinear`).
- ℂ-module structure on O²
  (`KrasnovComplexModule.lean`, `KrasnovComplexModuleInstance.lean`).
- Key identification J = Complex.I •
  (`KrasnovComplexModuleInstance.lean` — `rightMulE111_eq_I_smul`).
- Flat Hermitian form on O² in coordinates
  (`KrasnovQubitHermitian.lean` — source annotated "Krasnov, arXiv:1912.11282").
- Sesquilinearity and J-invariance of the Hermitian form
  (`KrasnovHermitianSesquilinear.lean` — if proved).

---

**[Krasnov2025]**
Kirill Krasnov.
"Octonions, Complex Structures and Standard Model Fermions."
*Advances in Mathematics* (2025).
arXiv:2504.16465.
https://arxiv.org/abs/2504.16465

*Cite for*:
- The pure-spinor / commuting-complex-structure perspective on symmetry
  breaking that motivates `PureSpinor10.lean`.
- The Spin(10)/SU(5) framework connecting to the GUT-square bridge
  (`G2C3GUTBlockBridge.lean`, `G2C3GUTSU5Bridge.lean`).

---

## 8. Exceptional Jordan Algebra and Physics: Additional Sources

**[Albert1934]**
A. A. Albert.
"On a Certain Algebra of Quantum Mechanics."
*Annals of Mathematics* 35 (1934), 65–73.
https://doi.org/10.2307/1968118

*Cite for*: The original source for exceptional Jordan algebras. Cite in
the introduction when h₃(O) is first introduced, alongside [Baez2002]
and [DVT2018].

---

**[McCrimmon2004]**
Kevin McCrimmon.
*A Taste of Jordan Algebras.*
Springer, 2004. ISBN 978-0-387-21796-3.

*Cite for*:
- The inner derivation formula `D_{a,b}(c) = [L_a,L_b](c)`
  (`InnerDerivation.lean` — note in module docstring on the correct
   antisymmetric formula vs. the symmetric alternative).
- The Jacobi identity proof strategy for derivations of Jordan algebras
  (`InnerDerivationJacobiLie.lean`).
- The Lie algebra structure of derivations as background for stating
  `InnDer(h₃(O)) ⊆ Der(h₃(O))`.

---

**[Yokota2009]**
Ichiro Yokota.
"Exceptional Lie Groups."
arXiv:0902.0431, 2009.
https://arxiv.org/abs/0902.0431

*Cite for*:
- DVT stabilizer prelude language
  (`DVTStabilizerPrelude.lean` — source cites "Yokota, arXiv:0902.0431").
- The subgroup structure of F₄ (future work target: full DVT theorem).
- Background for the claim boundary: "We do not yet prove Aut(h₃(O)) ≅ F₄."

---

**[Boyle2020]**
Latham Boyle.
"The Standard Model, The Exceptional Jordan Algebra, and Triality."
arXiv:2006.16265, 2020.
https://arxiv.org/abs/2006.16265

*Cite for*: Related-work section. Boyle connects the complexified exceptional
Jordan algebra, the minimal left-right-symmetric Standard Model extension, and
SO(8) triality for three generations. Our triality-action formalization
(`TrialityTriple.lean`) and the DVT thread both intersect with ideas from this
paper. Not directly formalized; cite alongside [FureyHughes2024] when
describing the triality/generation frontier.

---

**[FermionMass2026]**
Tejinder P. Singh.
"Fermion Mass Hierarchies and the Exceptional Jordan Algebra."
arXiv:2605.24866, May 2026.
https://arxiv.org/abs/2605.24866

*Cite for*: Very recent related work. Singh derives fermion mass hierarchies
from eigenvalues of the complexified exceptional Jordan algebra J₃(O_C), with
three generations arising from three canonical Jordan eigenvalues. This paper
directly builds on the DVT formalism that we formalize in Sections 7–8. Mention
in the related-work section and future-work discussion (mass hierarchies are
explicitly not addressed in our paper).

---

## 9. Historical Background

**[GunaydinGursey1973]**
Murat Günaydin and Feza Gürsey.
"Quark Structure and Octonions."
*Journal of Mathematical Physics* 14 (1973), 1651–1667.
https://doi.org/10.1063/1.1666240

*Cite for*: Historical background in the introduction on octonions and quarks.
No direct formalization traces to this paper.

---

**[GunaydinGursey1974]**
Murat Günaydin and Feza Gürsey.
"Quark Statistics and Octonions."
*Physical Review D* 9 (1974), 3387–3391.
https://doi.org/10.1103/PhysRevD.9.3387

*Cite for*: Historical background alongside [GunaydinGursey1973]. The first
explicit connection of SU(3) color to the octonionic structure predates
Furey's program by several decades.

---

## 10. Related Work: Alternative Algebraic Approaches to Three Generations

*The following papers are relevant for the related-work section. None are
directly formalized in this project.*

**[Gresnigt2019]**
Niels G. Gresnigt.
"Three Fermion Generations with Two Unbroken Gauge Symmetries from the Complex
Sedenions."
*European Physical Journal C* 79 (2019), 282.
arXiv:1904.03186.
https://arxiv.org/abs/1904.03186

**[GresnigtGourlayVarma2023]**
Niels G. Gresnigt, Liam Gourlay, and Abhinav Varma.
"Three Generations of Colored Fermions with S₃ Family Symmetry from
Cayley-Dickson Sedenions."
*European Physical Journal C* 83 (2023), 879.
arXiv:2306.13098.
https://arxiv.org/abs/2306.13098

**[GourlayGresnigt2024]**
Liam Gourlay and Niels G. Gresnigt.
"Algebraic Realisation of Three Fermion Generations with S₃ Family and
Unbroken Gauge Symmetry from Cℓ(8)."
*European Physical Journal C* 84 (2024), 1218.
arXiv:2407.01580.
https://arxiv.org/abs/2407.01580

**[Gresnigt2026]**
Niels G. Gresnigt.
"Electroweak Structure and Three Fermion Generations in Clifford Algebra with
S₃ Family Symmetry."
arXiv:2601.07857, January 2026.
https://arxiv.org/abs/2601.07857

**[GourlayThesis2025]**
Liam Gourlay.
"An Algebraic Framework for Describing Three Fermion Generations Using a
Discrete Family Symmetry."
PhD thesis, University of Liverpool, December 2025.
https://livrepository.liverpool.ac.uk/3196062/

*Cite for these five*: The sedenion/S₃ line is the nearest neighbor to our
formalization project: it also uses Clifford algebras built from octonionic
ladder operators, and its S₃ family symmetry is the finite-group counterpart of
the triality action formalized in Sections 5 and 9. However, the Gresnigt
program is more Clifford-algebraic and less Jordan-geometric than the DVT/Baez
line we formalize. Note the explicit comparison: our family-symmetry naturality
theorem (`FamilyAnomalyNaturality.lean`) is designed to be an interface that
concrete models — including S₃ models — must prove the commutation hypothesis
for before the transport result applies.

---

**[Stoica2018]**
Ovidiu Cristinel Stoica.
"Leptons, Quarks, and Gauge from the Complex Clifford Algebra Cℓ₆."
*Advances in Applied Clifford Algebras* 28 (2018), 52.
arXiv:1702.04336.
https://arxiv.org/abs/1702.04336

*Cite for*: Related work. Stoica shows that Cℓ₆ generates leptons, quarks,
and the electroweak/color symmetries from a Witt decomposition. Mention
alongside Furey's program when explaining the general landscape of Clifford
algebraic Standard Model constructions.

---

**[Rowlands2019]**
Peter Rowlands and Sydney Rowlands.
"Are Octonions Necessary to the Standard Model?"
*Journal of Physics: Conference Series* 1251 (2019), 012044.
https://doi.org/10.1088/1742-6596/1251/1/012044

*Cite for*: The Rowlands skeptical critique — the key observation that what
does the structural work in many "octonion" models is actually the adjoint or
left-multiplied algebra (effectively a Clifford algebra), not raw non-associative
multiplication. This is directly relevant to our claim boundary: we use
`CliffordConnection.lean` to formalize the Clifford envelope, and our
`DVTComplementBridge.lean` shows the complement is isomorphic to M₃(ℂ), which
is an associative algebra. Cite in the conventions/architecture section when
explaining why we keep the Clifford envelope and the Jordan structure as
separate layers.

---

## Quick Correspondence Table

| Paper section / formalized result | Primary reference(s) |
|------------------------------------|----------------------|
| Octonion convention, XOR basis | [Baez2002] |
| Complex splitting O = C⊕C³ | [Baez2021] |
| Furey ladder operators + ideal | [Furey2018a] |
| Q_op as number operator | [Furey2015] |
| One-generation anomaly cancellation | [Furey2018a] |
| GMN identity Q = T₃ + Y/2 (operator) | [Furey2018a] |
| Three generations / triality triple | [Furey2018b], [FureyHughes2024] |
| Family anomaly naturality | [FureyHughes2024] |
| h₂(O), h₃(O) Jordan coordinates | [DVT2018], [Baez2002] |
| Jordan identity proof | [Baez2002] §3 |
| Trace form positive definiteness | [DVT2018], [McCrimmon2004] |
| Complement decomposition and actions | [DVT2018], [DVT2019] |
| DVT Z₃ kernel iff theorem | [DVT2018] |
| (SU(3)×SU(3))/Z₃ quotient stabilizer | [DVT2018] |
| Inner derivations + Leibniz law | [McCrimmon2004], [DVT2018] |
| Inner derivation Lie subalgebra | [McCrimmon2004], [LieLean2025] (comparison) |
| Inner derivations stabilize h₃(C) | [McCrimmon2004] |
| Z6 finite kernel (cardinality = 6) | [BaezHuerta2010] |
| GUT square: SM = SU(5) ∩ Pati-Salam | [BaezHuerta2010] |
| Z6 first isomorphism theorem | [BaezHuerta2010] |
| G₂ stabilizer ≅ SU(3) as groups | [Baez2021] |
| Krasnov J = rightMulE111, J² = −id | [Krasnov2019] |
| Krasnov ℂ-module, J = i• | [Krasnov2019] |
| Krasnov Hermitian sesquilinearity | [Krasnov2019] |
| Quunit/qubit/qutrit dictionary | [BaezHuerta2010], [Baez2021] |
| Lean kernel as trust root | [Lean4] |
| Mathlib infrastructure | [Mathlib4] |
| HepLean/Physlib comparison | [HepLean2025] |
| Index notation formalization (comparison) | [IndexNotation2024] |
| Lie algebra formalization (comparison) | [LieLean2025] |
| Furey roadmap (context) | [FureyRoadmap2025] |
| Furey Z₂⁵ algebra (future work) | [FureyZ25_2025] |
| Fermion masses (future work) | [FermionMass2026] |
| OP² geometry (future work) | [BaezSchwahn2026] |
| Gresnigt S₃/sedenion comparison | [GresnigtGourlayVarma2023], [Gresnigt2026] |
| Clifford vs. Jordan critique | [Rowlands2019], [Stoica2018] |

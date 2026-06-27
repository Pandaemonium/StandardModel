# Aristotle job: C17/C18 spectral-graph species and flavored chirality audit

This is a no-build audit/strategy job.

Goal: sharpen Gate C beyond flat momentum-symbol determinant zeros by using spectral-graph species counting and modified/flavored chirality diagnostics.

Use the Gate C literature:

- Yumoto-Misumi arXiv:2112.13501, lattice fermions as spectral graphs.
- Basak-Chakrabarti-Kishore arXiv:2501.10336, eigenspectra of minimally doubled fermions.
- Catterall arXiv:2311.02487, reduced Kahler-Dirac/chiral issues.
- Existing minimally doubled pack: Misumi 2512.22609, Golterman-Shamir 2505.20436, Weber 2312.08526, Weber 2502.16500, Capitani-Weber-Wittig 0910.2597.

Please analyze:

1. How to translate the null-edge flat finite operator into a spectral graph/matrix species-count problem.
2. What branch data must be collected beyond det(iD_+(q) + Gamma_s Phi) = 0.
3. Whether high-momentum null branches should be classified as physical poles, doublers, kinematical propagator zeros, graph-topological nullities, boundary artifacts, taste partners, or redesign triggers.
4. How ordinary chirality can fail as a diagnostic for minimally doubled or graph-native zero modes.
5. What modified or flavored chirality operator would be natural for the null-edge/cochain/form-degree architecture.
6. How this interacts with Krein doubling, internal grading chi_E, spacetime chirality Gamma_s, and Kahler-Dirac form degree.
7. A concrete finite-matrix protocol that can be run before any continuum interpretation.
8. Which parts can become Lean theorems and which are numerical/audit scripts.

Deliverables:

- A Gate C zero-classification table schema.
- A proposed spectral-graph nullity experiment.
- A chirality/flavored-chirality decision tree.
- A list of theorem statements suitable for `PhysicsSM/Draft/TetrahedralNodalStructure.lean` or related files.
- A verdict on whether Gate C is still a possible kill switch.

# Sources

Source material metadata for the PhysicsSM project.

Each source used in a formalization should have a corresponding entry here or in a
subdirectory, recording:

- Bibliographic information (authors, title, year, DOI/arXiv ID)
- Source type: paper / book / repo / oracle-output
- License
- Relevant sections
- Convention notes (basis choices, sign conventions, normalizations)
- Whether it is a specification source, oracle source, or translatable source

## Key sources

### Division algebras and octonions

- `baez_octonions_2002` — Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002) 145–205. arXiv:math/0105155
- `baez_huerta_susy_2010` — Baez & Huerta, "Division Algebras and Supersymmetry I", arXiv:0909.0551

### Standard Model from division algebras (Furey program)

- `Furey_Baez_Octonions_Standard_Model_Survey.md` — high-level survey of the
  Furey, Baez, Dubois-Violette/Todorov, Krasnov, Boyle, and related
  octonion/Clifford/Jordan-algebra approaches to the Standard Model.

- `furey_thesis_2016` — Furey, "Standard model physics from an algebra?", PhD thesis, University of Waterloo, 2016. arXiv:1611.09182
  - Primary reference for the overall algebraic SM construction.
  - Convention: Baez mod-7 octonion labeling.
  - Relevant sections: Ch. 2–4 (complex octonions, ladder operators, SM states).

- `furey_charge_2015` — Furey, "Charge quantization from a number operator", Phys. Lett. B 742 (2015) 195–199. arXiv:1603.04783
  - Derives electric charge assignments from the number operator N = sum_k alpha_k† alpha_k.
  - Convention: same as thesis.
  - Key result: Q = -(1/3)(N_1 + N_2 + N_3) on the minimal left ideal.

- `furey_su3_2018` — Furey, "Three generations, two unbroken gauge symmetries, and one eight-dimensional algebra", Phys. Lett. B 785 (2018) 84–89. arXiv:1805.06631
  - Extends to three generations using ℝ⊗ℂ⊗ℍ⊗𝕆 (Dixon algebra).
  - Convention: Baez mod-7 octonion labeling.

- `furey_sm_2018` — Furey, "SU(3)_C × SU(2)_L × U(1)_Y (×U(1)_X) as a symmetry of division algebraic ladder operators", EPJC 78 (2018) 375. arXiv:1806.00612
  - **Primary technical reference** for ladder operators, minimal left ideal, and SM symmetry recovery.
  - Convention: Baez convention, e_7 as privileged imaginary unit (= project e111).
  - Key: Table 1 (SM state identification), Section 2 (ladder operators), Section 3 (symmetry).
  - ConventionBridge: Baez e_5 → −e100 (sign flip); all others +1.
  - Translation verified by Scripts/oracle/validate_convention_bridge.py.

### Exceptional Lie theory

- `adams_exceptional_1996` — Adams, "Lectures on Exceptional Lie Groups", University of Chicago Press (1996)

### Standard Model physics

- `peskin_schroeder_1995` — Peskin & Schroeder, "Introduction to Quantum Field Theory", Addison-Wesley (1995)
- `weinberg_qft2_1996` — Weinberg, "The Quantum Theory of Fields, Vol. 2", Cambridge (1996)

### Supersymmetry

- `wess_bagger_1992` — Wess & Bagger, "Supersymmetry and Supergravity", 2nd ed., Princeton (1992)

### Luminal checkerboard path integrals

- `Luminal_Motion_Checkerboard_Research_Program.md` - draft research program
  for finite checkerboards, higher-dimensional null-polygon expansions, and
  causal-set hop-stop propagators.
- `Luminal_Motion_Checkerboard_Publication_Advance_2026-06-11.md` - Codex
  evaluation, source-verification notes, corrections before publication, and
  the Lean theorem sequence started in `PhysicsSM.Spinor.Checkerboard`.
- `Null_Edge_Causal_Graph_Strengthened_Program.md` - clean synthesis of the
  null-edge causal graph program, with corrections to the octonionic
  collinearity claim, theorem-first extensions, and repo-native Lean targets.
- `Null_Edge_Causal_Graph_Theorem_Roadmap_2026-06-21.md` - literature-backed
  theorem roadmap after the SPL-free Aristotle verification of the null-edge
  core, including the next Aristotle waves for finite Pluecker mass, twistor
  matching, Higgs/Yukawa flips, diamond holonomy, and cochains.
- `Null_Edge_Causal_Graph_Proof_Advances_2026-06-21.md` - hand-proof and
  theorem-target note advancing the finite Pluecker, `SL(2,C)` covariance,
  twistor-chart, non-Abelian diamond, Higgs-flip, and cochain branches.
- `Null_Edge_Causal_Graph_Next_Wave_2026-06-21.md` - post-Pluecker and
  post-spinor-geometry next-wave plan, including promotion criteria, dynamics
  targets, twistor/projective targets, diamond composition, cochains, and graph
  gravity observables.
- `Null_Edge_Attachment_Extraction_2026-06-21.md` - triage of the attached
  ChatGPT synthesis note, separating redundant material from useful theorem
  targets, numerical pilots, and reference follow-ups.
  Trusted dynamics advance: `PhysicsSM.Spinor.CheckerboardDynamics` promotes
  the finite endpoint recursion, iterated two-component evolution, and
  telegraph/Klein-Gordon checkerboard recursion.
  Trusted Pluecker-mass advance: `PhysicsSM.Spinor.PluckerMass` promotes the
  finite determinant identity, real-valued nonnegativity wrapper, and
  mass-zero/common-direction criterion for visible complex null-spinor
  bundles.
  Twistor wrapper advance: `PhysicsSM.Draft.TwistorPluckerMass` and
  `Twistor_Plucker_Matching_Wrapper_2026-06-21.md` isolate the spinor-chart
  reduction of the two-/multi-twistor mass invariant to the Pluecker wedge
  squared, without claiming a full incidence formalization. The Zotero/Neo4j
  source additions for this bridge are `MFUJKFEA`, `2T3HC5NC`, `NFHRVF2Q`,
  `SZJE69PE`, and `J5GA3CQ8`.
  Trusted diamond-holonomy advance: `PhysicsSM.Gauge.CausalDiamondHolonomy`
  promotes finite Abelian gauge invariance, non-Abelian endpoint covariance,
  class-function gauge invariance, and vertical/horizontal composition laws
  for glued causal-diamond path-pair defects. The related Zotero/Neo4j
  source additions are `AHK54SN9`, `K9XTAJUM`, `Z38RZX2Q`; existing Wilson
  lattice-gauge item `QDII2KHM` is linked in Neo4j.
  Draft higher-gauge handoff: `PhysicsSM.Draft.CausalDiamondHigherGaugeAristotle`
  queues endpoint transport, associativity, and interchange lemmas for
  Aristotle project `0897a0dd-888e-451f-97e7-e24633cd2699`.
  Draft projective advance: `PhysicsSM.Draft.NullEdgeSpinorGeometryTargets`
  now includes independent spinor-column rescaling laws and normalized
  projective wedge-spread invariance.

### Mathlib (primary Lean library)

- `mathlib4` — leanprover-community/mathlib4, Apache-2.0, https://github.com/leanprover-community/mathlib4

### Adjacent public Lean repositories

- `Lean_Adjacent_Repositories_Survey.md` records public Lean repositories
  adjacent to the octonion/Standard Model/E8/Clifford/formal physics program,
  with license, toolchain, and integration notes.

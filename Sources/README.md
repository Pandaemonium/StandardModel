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

### Mathlib (primary Lean library)

- `mathlib4` — leanprover-community/mathlib4, Apache-2.0, https://github.com/leanprover-community/mathlib4

### Adjacent public Lean repositories

- `Lean_Adjacent_Repositories_Survey.md` records public Lean repositories
  adjacent to the octonion/Standard Model/E8/Clifford/formal physics program,
  with license, toolchain, and integration notes.

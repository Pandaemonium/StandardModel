/-!
# Docs.Glossary

Notation and terminology glossary for the PhysicsSM project.

This module is documentation-only. It records the canonical meanings of notation
and terms used throughout the project.

## Algebra notation

| Symbol | Meaning |
|--------|---------|
| ℝ, ℂ, ℍ, 𝕆 | reals, complex numbers, quaternions, octonions |
| Cl(V, Q) | Clifford algebra of (V, Q) |
| Spin(p, q) | spin group, double cover of SO(p, q) |
| 𝔤, 𝔥 | semisimple Lie algebra, Cartan subalgebra |
| α, β | roots |
| ω₁, …, ωᵣ | fundamental weights |
| ρ | Weyl vector = (1/2) Σ positive roots |
| W | Weyl group |
| Φ | root system |
| V(λ) | irreducible 𝔤-module with highest weight λ |

## Spinor notation

| Symbol | Meaning |
|--------|---------|
| ψ_α | left-Weyl spinor (undotted index) |
| χ̄^{α̇} | right-Weyl spinor (dotted index) |
| Ψ | Dirac spinor (4-component) |
| γᵘ | gamma matrices |
| γ₅ | chirality matrix |
| {A, B} | anticommutator A·B + B·A |
| [A, B] | commutator A·B - B·A |

## Standard Model notation

| Symbol | Meaning |
|--------|---------|
| G_SM | SU(3)_c × SU(2)_L × U(1)_Y |
| Y | hypercharge |
| T₃ | third component of weak isospin |
| Q | electric charge = T₃ + Y/2 |
| (r, d, Y) | rep under (SU(3), SU(2), U(1)_Y) |

## Convention register

Every convention choice that could differ between sources is recorded here.

| Item | Convention used | Source |
|------|----------------|--------|
| Hypercharge formula | Q = T₃ + Y/2 | Weinberg Vol. 2 |
| Metric signature | mostly-minus: (+,-,-,-) | Peskin–Schroeder |
| Octonion basis | XOR binary labels e000–e111 | project convention (see Basic.lean) |
| Fano plane orientation | positive triples listed in Basic.lean; anchored by e011*e111=e100 | project convention, validated by Scripts/oracle/validate_octonion.py |
| Cartan matrix labelling | Bourbaki | Bourbaki Ch. 4–6 |
| Spinor conventions | two-component van der Waerden | Wess–Bagger |

## Octonion basis elements

| Label  | Index | Decimal |
|--------|-------|---------|
| e000   | unit  | 0       |
| e001   | imag  | 1       |
| e010   | imag  | 2       |
| e011   | imag  | 3       |
| e100   | imag  | 4       |
| e101   | imag  | 5       |
| e110   | imag  | 6       |
| e111   | imag  | 7       |

## Octonion Fano positive triples

Product index = bitwise XOR of the two input labels.
Sign from the positive-triple orientation below.

```
e001 * e010 = e011
e001 * e101 = e100
e001 * e110 = e111
e010 * e100 = e110
e010 * e101 = e111
e011 * e101 = e110
e011 * e111 = e100
```

Reversed products are negative: e010 * e001 = -e011, etc.

## Convention translation warning

Do NOT use Baez (2002) or Furey (2015) product formulas, structure constants,
or ladder operator definitions directly. The project convention differs by a
basis relabeling AND sign flips. All translations must go through
`PhysicsSM.Algebra.Octonion.ConventionBridge`.
-/

namespace PhysicsSM.Docs.Glossary

end PhysicsSM.Docs.Glossary

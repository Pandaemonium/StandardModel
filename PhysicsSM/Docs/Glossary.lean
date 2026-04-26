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
| Octonion basis | Baez (2002) Table 1 | Baez, "The Octonions" |
| Fano plane orientation | Baez (2002) | Baez, "The Octonions" |
| Cartan matrix labelling | Bourbaki | Bourbaki Ch. 4–6 |
| Spinor conventions | two-component van der Waerden | Wess–Bagger |
-/

namespace PhysicsSM.Docs.Glossary

end PhysicsSM.Docs.Glossary

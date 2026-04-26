/-!
# Spinor.Basic

Spinor conventions for this project.

Spinors are representations of the spin group Spin(p, q), the double cover of SO(p, q).
They arise naturally as elements of minimal left ideals in Clifford algebras.

## Spinor types

The four real spinor types in 4D Lorentzian signature (3+1) are:
- Dirac spinors: 4-component complex, representation of Spin(3,1) ≅ SL(2,ℂ)
- Weyl (chiral) spinors: 2-component complex, (1/2, 0) or (0, 1/2) of SL(2,ℂ)×SL(2,ℂ)
- Majorana spinors: 4-component real (after imposing Majorana condition)
- Majorana–Weyl: exist only in signatures where both conditions are compatible

## Convention

Spinor index notation follows van der Waerden conventions:
  - Undotted indices α, β, ... for left-Weyl (1/2, 0)
  - Dotted indices α̇, β̇, ... for right-Weyl (0, 1/2)

Source: Wess and Bagger, "Supersymmetry and Supergravity" (1992), Appendix.
Convention: two-component spinor conventions of Wess–Bagger.

Status: stub — spinor type definitions to be added.
-/

namespace PhysicsSM.Spinor

end PhysicsSM.Spinor

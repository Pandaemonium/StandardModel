/-!
# Algebra.Octonion.Alternativity

Left and right alternative laws for octonions.

An algebra is alternative if:
- `left_alternative`  : (x * x) * y = x * (x * y)
- `right_alternative` : x * (y * y) = (x * y) * y

These are weaker than associativity and hold for all four normed division algebras.
The octonions are the largest alternative division algebra.

Note: The flexible law  x * (y * x) = (x * y) * x  follows from alternativity.

WARNING: Alternativity does NOT imply associativity. The associator
  [x, y, z] = (x * y) * z - x * (y * z)
is nonzero for generic octonions.

Source: Baez, "The Octonions", §1.
Convention: follows `PhysicsSM.Algebra.Octonion.Basic` multiplication convention.

Prerequisites:
- `PhysicsSM.Algebra.Octonion.Basic`

Status: stub — alternativity proofs to be added.
-/

namespace PhysicsSM.Algebra.Octonion

end PhysicsSM.Algebra.Octonion

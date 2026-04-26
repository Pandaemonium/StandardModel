/-!
# Algebra.Division.QuaternionBridge

Bridge from project conventions to Mathlib's quaternion infrastructure.

Mathlib provides `Quaternion ℝ` in `Mathlib.Analysis.Quaternion`. This module
aligns the project's division-algebra conventions with that implementation and
re-exports useful lemmas under project namespaces.

Source: Mathlib `Mathlib.Analysis.Quaternion`.
Conventions: standard basis {1, i, j, k} with i² = j² = k² = ijk = -1.

Prerequisites:
- `PhysicsSM.Algebra.Division.Basic`

Status: stub — bridge lemmas and re-exports to be added.
-/

namespace PhysicsSM.Algebra.Division.QuaternionBridge

end PhysicsSM.Algebra.Division.QuaternionBridge

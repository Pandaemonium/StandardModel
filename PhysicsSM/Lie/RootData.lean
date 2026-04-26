/-!
# Lie.RootData

Project root system wrappers over Mathlib infrastructure.

Provides project-local interfaces to root systems, building on
`Mathlib.LinearAlgebra.RootSystem.Basic`.

Key data for each type:
- Rank (dimension of Cartan subalgebra)
- Number of positive roots
- Total number of roots
- Simple roots and Cartan matrix
- Weyl group order

This module focuses on combinatorial root data. Representation-theoretic
content is in `PhysicsSM.Lie.Weights`.

Source: Bourbaki, "Lie Groups and Lie Algebras", Chapters 4–6.

Prerequisites:
- `PhysicsSM.Lie.Cartan`

Status: stub — root data wrappers to be defined.
-/

namespace PhysicsSM.Lie.RootData

end PhysicsSM.Lie.RootData

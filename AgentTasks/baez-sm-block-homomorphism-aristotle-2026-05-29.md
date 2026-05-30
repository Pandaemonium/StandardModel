# Aristotle task: Baez Standard Model block embedding homomorphism laws

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `6a49742e-22f2-45b0-8432-686b89df56f4`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-round-20260529-project`
**Output**: `AgentTasks/aristotle-output/baez-sm-block-homomorphism-20260529`
**Type**: Baez true gauge group / concrete block matrix homomorphism scaffold

**Integrated**: 2026-05-30
**Integrated files**:
- `PhysicsSM/Gauge/StandardModelBlockHom.lean`
- `PhysicsSM.lean`

**Review note**: Aristotle's trusted theorem file was imported, locally
reviewed, provenance-cleaned, and checked with the pinned Lean toolchain.

## Goal

Strengthen the current Baez block-embedding scaffold by proving that the
concrete block maps are multiplicative and preserve identities.

This is a safe algebraic step toward the slides' homomorphism

```text
U(1) x SU(2) x SU(3) -> SU(2) x SU(4)
(alpha, g, h) |-> (g, block_diag(alpha h, alpha^-3)).
```

## Current context

The project already has:

- `PhysicsSM.Gauge.BlockEmbeddings`
- `PhysicsSM.Gauge.StandardModelGroup`
- `PhysicsSM.Gauge.StandardModelSubgroup`
- `su4Block`
- `slideMap`
- `coveringMap`
- determinant lemmas for the SU(4) block and `S(U(2) x U(3))` covering map.

## Sources and claim boundary

Source motivation:

- John Baez, "Can We Understand the Standard Model Using Octonions?", 2021,
  especially the `S(U(2) x U(3))` and `SU(2) x SU(4)` block-map slides.
- Kirill Krasnov, "SO(9) characterisation of the Standard Model gauge group",
  arXiv:1912.11282.

Claim boundary:

- This job proves concrete matrix identities only.
- Do not claim the quotient isomorphism, the Lie-group topology, or the
  `Spin(9)` centralizer theorem.

## Requested file

Create a trusted file:

```text
PhysicsSM/Gauge/StandardModelBlockHom.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelSubgroup
import PhysicsSM.Gauge.StandardModelGroup
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.BlockEmbeddings
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Prove identity and multiplication laws for `su4Block`:

```lean
theorem su4Block_one :
    su4Block 1 (1 : Matrix (Fin 3) (Fin 3) Complex) = 1 := ...

theorem su4Block_mul
    (alpha beta : Complex)
    (h1 h2 : Matrix (Fin 3) (Fin 3) Complex) :
    su4Block (alpha * beta) (h1 * h2) =
      su4Block alpha h1 * su4Block beta h2 := ...
```

Prove identity and multiplication laws for `slideMap`:

```lean
theorem slideMap_one :
    slideMap 1
      (1 : Matrix (Fin 2) (Fin 2) Complex)
      (1 : Matrix (Fin 3) (Fin 3) Complex) =
    (1, 1) := ...

theorem slideMap_mul
    (alpha beta : Complex)
    (g1 g2 : Matrix (Fin 2) (Fin 2) Complex)
    (h1 h2 : Matrix (Fin 3) (Fin 3) Complex) :
    slideMap (alpha * beta) (g1 * g2) (h1 * h2) =
      let p := slideMap alpha g1 h1
      let q := slideMap beta g2 h2
      (p.1 * q.1, p.2 * q.2) := ...
```

Prove analogous laws for `StandardModelSubgroup.coveringMap` if feasible:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup

theorem coveringMap_one : ...
theorem coveringMap_mul : ...

end PhysicsSM.Gauge.StandardModelSubgroup
```

If pair `let` statements make the exact statement awkward, choose a clean
kernel-checked equivalent and document the orientation.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep all results concrete; do not introduce quotient group assumptions.
- Prefer block matrix lemmas and `ext i j` proofs.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelBlockHom.lean
lake build PhysicsSM.Gauge.StandardModelBlockHom
lake build PhysicsSM
```

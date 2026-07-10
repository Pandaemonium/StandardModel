# codex-C3-index-protection-bridge-20260709

You are Aristotle working in the `PhysicsSM` Lean project.

## Goal

Create and prove a new module:

```text
PhysicsSM/Draft/NullEdge/IndexProtectionBridge.lean
```

Compose the C3 finite index-anomaly interface with the landed winding
low-mode/protection facts:

- `PhysicsSM.Draft.NullEdge.WindingLowModes`
- `PhysicsSM.Draft.NullEdge.IndexAnomalyInterface`
- optionally `PhysicsSM.Draft.NullEdge.ChiralIndexProtection` if it helps

Run the narrow check first:

```text
lake env lean PhysicsSM/Draft/NullEdge/IndexProtectionBridge.lean
```

## Intended theorem pieces

Prove a small theorem suite that makes the finite C3 claim hard to overstate:

1. The relative signed finite index equals winding, reusing
   `F4Winding.toy_index_anomaly`.

2. The same winding gives at least `w` protected kernel modes, reusing
   `F4Winding.windingDirac_kernel` or the strongest available landed theorem.

3. A bundled theorem:

```lean
theorem winding_anomaly_protects_modes (N w : Nat) :
    F4Winding.toyIndex (F4Winding.Kw N w)
      - F4Winding.toyIndex (F4Winding.Kw N 0) = (w : Int)
      /\ w <= Module.finrank Complex (LinearMap.ker (F4Winding.Kw N w))
```

Use the exact namespace/API from the repo. If the kernel-mode statement needs
`1 <= ...` or a different operator name (`windingDirac` vs `Kw`), adjust to the
strongest true statement.

4. A nonvacuity fixture at `w = 1`:

```lean
theorem winding_one_anomaly_and_mode (N : Nat) :
    F4Winding.toyIndex (F4Winding.Kw N 1)
      - F4Winding.toyIndex (F4Winding.Kw N 0) = 1
      /\ 1 <= Module.finrank Complex (LinearMap.ker (F4Winding.Kw N 1))
```

## Claim discipline

This is finite rank-nullity and protected-mode bookkeeping only. Do not claim
Fredholm theory, Atiyah-Singer, spectral flow, or a continuum anomaly. If a
target would require analytic input, isolate the missing hypothesis explicitly.

Add guard pins for headline theorems. Do not introduce new global assumptions.

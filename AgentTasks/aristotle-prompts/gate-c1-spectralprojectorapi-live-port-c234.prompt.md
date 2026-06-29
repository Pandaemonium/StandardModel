Gate C1 live-safe SpectralProjectorAPI port, C234

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C233 produced a strong Riesz/spectral-projector API, but Codex did not port the
Lean file verbatim because it used names under `GateC1.OperatorFreeze`, which
would collide conceptually with the C227 `OperatorFreeze` API.

Task:

Design and, if feasible, rewrite the C233 artifact into a live-safe Draft module
with a non-colliding namespace:

```text
PhysicsSM/Draft/NullEdge/GateC1/SpectralProjectorAPI.lean
namespace GateC1.SpectralProjectorAPI
```

Included context:

```text
C233_RieszProjectorAPI_design.md;
RieszProjectorAPI.lean;
OperatorFreeze.lean;
ProjectorPersistence.lean.
```

Requirements:

1. Preserve the C233 finite-first theorem:

   ```text
   eq_of_isIdempotent_range_ker
   ```

2. Preserve the C233 regression guard:

   ```text
   weak_fingerprint_not_unique
   ```

3. Preserve the strengthened contract:

   ```text
   IsSpectralProjector A P S
   ```

   with range/kernel generalized-eigenspace data.

4. Preserve uniqueness:

   ```text
   IsSpectralProjector.unique
   ```

5. Do not define any theorem under `GateC1.OperatorFreeze`.

6. If connecting to `OperatorFreeze`, use a distinct theorem name or a source
   contract structure that imports `OperatorFreeze` safely.

7. Keep all claims Draft/local. Do not claim GateC1_NU.

Requested output:

- live-safe module text or patch plan;
- exact import list;
- namespace and theorem-name plan;
- any Lean risks;
- no-overclaim checklist.

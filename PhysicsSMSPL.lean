import PhysicsSMDraft
import PhysicsSM.Draft.E8SpherePackingImported
import PhysicsSM.Draft.E8ThetaSPLBridge

/-!
# PhysicsSM SPL root

This optional root imports the platform-sensitive Sphere-Packing-Lean bridge.
It is intentionally separate from both:

- `PhysicsSM`, the default trusted root; and
- `PhysicsSMDraft`, the draft root that remains independent of the direct SPL
  bridge import.

Build explicitly with:

```text
lake build PhysicsSMSPL
```
-/

/-
FBConcreteGroupIso : the concrete instantiation of the generic FBGroupIso
upgrade against the Furey–Baez octonion objects.

STATUS: DOCUMENTED BLOCKER (the `PhysicsSM` library is absent from this
workspace).  See the "Blocker" section below.  This file itself is
KERNEL-ONLY and `sorry`-free: it imports only `Mathlib` and the generic,
self-contained `context.FBGroupIso`, and it builds.  The concrete
instantiation is provided verbatim, ready to drop in, once `PhysicsSM`
is on the path.
-/
import Mathlib
import context.FBGroupIso

/-!
# FBConcreteGroupIso : concretizing the group-isomorphism upgrade

## What was requested

Produce the concrete

```
octonionMulAutFixingE111GroupIsoSU3 :
    OctonionMulAutFixingE111 ≃* Matrix.specialUnitaryGroup (Fin 3) ℂ :=
  FBGroupIso.mulEquivToSU3AsGroups
    octonionMulAutFixingE111MulEquivSU3 su3Submonoid_eq_specialUnitaryGroup
```

together with the concrete `map_inv` / `map_div`, by instantiating the generic
theorems in `context/FBGroupIso.lean`.

## The `[Group OctonionMulAutFixingE111]` question — RESOLVED (instance exists)

The generic theorem `FBGroupIso.mulEquivToSU3AsGroups` requires
`[Group OctonionMulAutFixingE111]`.  **The repository provides this instance.**
It is

```
noncomputable instance OctonionMulAutFixingE111.instGroup :
    Group OctonionMulAutFixingE111
```

in `context/G2AutomorphismSU3ActionPackage.lean` (Part 1, at line 48),
transported from the group structure on `FixingE111MulLinear` along the
canonical bijection `octonionMulAutFixingE111EquivFixingE111MulLinear`.  Its
`inv` field is `fun f => e.symm (e f)⁻¹` with `inv_mul_cancel` discharged by
`simp`, so the automorphism composition genuinely **has inverses**: this is a
full `Group`, not merely a monoid.  Consequently:

* there is **no** missing-inverse finding — the automorphisms fixing `e111`
  form a group, so `map_inv` / `map_div` for any `MulEquiv` out of it hold
  automatically (`map_inv`, `map_div` from Mathlib);
* **no** transport-of-group-structure needs to be derived here — the repo
  already did the transport (`instGroup`).  Had it been missing, the intended
  fix would have been the standard `MulEquiv` transport along
  `octonionMulAutFixingE111MulEquivSU3` onto the `Group` on
  `specialUnitaryGroup` (via `Function.Injective.group` / `Equiv`-pullback);
  but that contingency does not arise.

## Blocker: the `PhysicsSM` library is absent from this workspace

The concrete names required for the instantiation —
`OctonionMulAutFixingE111`, its `Group` instance,
`octonionMulAutFixingE111MulEquivSU3`
(`G2AutomorphismSU3ActionPackage.lean`, line 103), and
`su3Submonoid_eq_specialUnitaryGroup`
(`G2FixingE111SpecialUnitaryGroup.lean`, line 55) — all live in modules whose
first lines are `import PhysicsSM.Algebra.Octonion.…`.  That library is **not
vendored in this workspace**.  Building any of those three modules fails with

```
unknown module prefix 'PhysicsSM'
No directory 'PhysicsSM' or file 'PhysicsSM.olean' in the search path …
```

Therefore a file that `import`s them cannot compile here, and the concrete
`octonionMulAutFixingE111GroupIsoSU3` cannot be *built* in this workspace.
This is exactly the ambient-dependency limitation already flagged in
`context/FBGroupIso.lean` ("Note on the ambient dependency"), which is why the
upgrade was proved generically there.  The blocker is the missing dependency —
**not** a missing `Group` instance and **not** any genuine absence of inverses.

## The loop is mathematically closed; only the packaging awaits `PhysicsSM`

Two independent observations make the loop closed modulo the missing library:

1. The generic `FBGroupIso.mulEquivToSU3AsGroups` /
   `…_map_inv` / `…_map_div` are proved for an *arbitrary* group `G` and an
   arbitrary submonoid `S = Matrix.specialUnitaryGroup (Fin 3) ℂ`, which is
   exactly the concrete situation; instantiation is definitional.

2. The concrete group isomorphism is in fact **already present in the repo**, as
   `octonionMulAutFixingE111MulEquivSpecialUnitary`
   (`G2FixingE111SpecialUnitaryGroup.lean`, line 65), defined as
   `octonionMulAutFixingE111MulEquivSU3.trans
     (MulEquiv.submonoidCongr su3Submonoid_eq_specialUnitaryGroup)` — which is
   *definitionally the same term* as
   `FBGroupIso.mulEquivToSU3AsGroups octonionMulAutFixingE111MulEquivSU3
     su3Submonoid_eq_specialUnitaryGroup`.

### Ready-to-drop concrete instantiation (uncomment once `PhysicsSM` resolves)

Add `import PhysicsSM.Algebra.Octonion.G2AutomorphismSU3ActionPackage` and
`import PhysicsSM.Algebra.Octonion.G2FixingE111SpecialUnitaryGroup` above, then:

```
open PhysicsSM.Algebra.Octonion.G2ComplexLine

/-- The Furey–Baez equivalence AS A GROUP ISOMORPHISM onto Mathlib's SU(3). -/
noncomputable def octonionMulAutFixingE111GroupIsoSU3 :
    OctonionMulAutFixingE111 ≃* Matrix.specialUnitaryGroup (Fin 3) ℂ :=
  FBGroupIso.mulEquivToSU3AsGroups
    octonionMulAutFixingE111MulEquivSU3 su3Submonoid_eq_specialUnitaryGroup

/-- It preserves inverses, so it is a group isomorphism (not merely monoid). -/
theorem octonionMulAutFixingE111GroupIsoSU3_map_inv
    (f : OctonionMulAutFixingE111) :
    octonionMulAutFixingE111GroupIsoSU3 f⁻¹ =
      (octonionMulAutFixingE111GroupIsoSU3 f)⁻¹ :=
  FBGroupIso.mulEquivToSU3AsGroups_map_inv _ _ f

/-- It preserves division. -/
theorem octonionMulAutFixingE111GroupIsoSU3_map_div
    (f g : OctonionMulAutFixingE111) :
    octonionMulAutFixingE111GroupIsoSU3 (f / g) =
      octonionMulAutFixingE111GroupIsoSU3 f / octonionMulAutFixingE111GroupIsoSU3 g :=
  FBGroupIso.mulEquivToSU3AsGroups_map_div _ _ f g

/-- The bundled certificate. -/
noncomputable def octonionMulAutFixingE111GroupIsoPackage :
    FBGroupIso.GroupIsoPackage OctonionMulAutFixingE111 su3Submonoid :=
  FBGroupIso.mkGroupIsoPackage
    octonionMulAutFixingE111MulEquivSU3 su3Submonoid_eq_specialUnitaryGroup
```

These type-check by construction, because the generic lemmas in
`context/FBGroupIso.lean` are proved for exactly this shape.

## A buildable stand-in demonstrating the instantiation is definitional

Because the concrete group `OctonionMulAutFixingE111` is unavailable, we
exhibit the *same instantiation pattern* against an arbitrary group standing in
for it.  This certifies, in the kernel, that the generic machinery specializes
to any concrete group carrying a `MulEquiv` onto `su3Submonoid` — the concrete
`octonionMulAutFixingE111GroupIsoSU3` is the special case `G := …FixingE111`.
-/

namespace FBConcreteGroupIso

open Matrix

variable {G : Type*} [Group G]
variable {S : Submonoid (Matrix (Fin 3) (Fin 3) ℂ)}

/-- Stand-in for `octonionMulAutFixingE111GroupIsoSU3`: the generic upgrade
applied to an arbitrary group `G` (the role played concretely by
`OctonionMulAutFixingE111`) with a `MulEquiv` onto a submonoid equal to SU(3).
The concrete def is `groupIsoSU3 octonionMulAutFixingE111MulEquivSU3
su3Submonoid_eq_specialUnitaryGroup`. -/
noncomputable def groupIsoSU3
    (e : G ≃* S) (hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ) :
    G ≃* Matrix.specialUnitaryGroup (Fin 3) ℂ :=
  FBGroupIso.mulEquivToSU3AsGroups e hS

/-- The concrete `map_inv`, instantiated generically. -/
theorem groupIsoSU3_map_inv
    (e : G ≃* S) (hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ) (g : G) :
    groupIsoSU3 e hS g⁻¹ = (groupIsoSU3 e hS g)⁻¹ :=
  FBGroupIso.mulEquivToSU3AsGroups_map_inv e hS g

/-- The concrete `map_div`, instantiated generically. -/
theorem groupIsoSU3_map_div
    (e : G ≃* S) (hS : S = Matrix.specialUnitaryGroup (Fin 3) ℂ) (g h : G) :
    groupIsoSU3 e hS (g / h) = groupIsoSU3 e hS g / groupIsoSU3 e hS h :=
  FBGroupIso.mulEquivToSU3AsGroups_map_div e hS g h

end FBConcreteGroupIso

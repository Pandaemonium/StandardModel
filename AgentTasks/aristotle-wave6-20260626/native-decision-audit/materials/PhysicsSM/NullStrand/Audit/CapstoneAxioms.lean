import PhysicsSM.NullStrand.Master.FiniteModel
import PhysicsSM.NullStrand.Master.Checkerboard

/-!
# NullStrand.Audit.CapstoneAxioms

Mechanical **assumption-surface whitelist** for the two *concrete* NullStrand
capstones.

A `#check` only proves a declaration still exists with a compatible type. It says
nothing about *what the proof rests on*. The whole point of a "trusted, no
`sorry`/`axiom`" capstone is that its kernel-level assumption surface stays
confined to Lean/Mathlib's three foundational axioms

* `propext` — propositional extensionality,
* `Classical.choice` — the axiom of choice,
* `Quot.sound` — soundness of quotients,

and never silently grows a `sorryAx` (an unfinished proof), a `Lean.ofReduceBool`
(a `native_decide` trust hole), or a project-local assumption axiom.

This module pins that surface with `#guard_msgs in #print axioms …`. Each block
below **fails to build** if the audited capstone's transitive axiom set changes —
for example if a `sorry` leaks in through a dependency, if `native_decide` is
introduced, or if a new `axiom` is added anywhere underneath. That makes the G0
"no hidden assumptions" obligation a hard, generated build gate rather than a
manual review item.

`(whitespace := lax)` only normalises message line-wrapping; it does **not**
relax which axioms are listed. If the proof team intentionally changes the
surface, update the expected list here in the same commit and explain why.

Companion modules:
* `PhysicsSM.NullStrand.Audit.Inventory` — public-surface `#check` drift guard;
* `PhysicsSM.NullStrand.Audit.DraftFirewall` — draft-import `#check` drift guard;
* `PhysicsSM.NullStrand.Audit.DuplicateNames` — base-name collision report.

Provenance: wave-4 audit-automation hardening, 2026-06-25. No
`s o r r y`/`a x i o m`; `#print axioms` + `#guard_msgs` only.
-/

namespace PhysicsSM.NullStrand.Audit.CapstoneAxioms

/-! ## Concrete capstone 1: finite i.i.d. null-strand master (MASTER-001) -/

/-- info: 'PhysicsSM.NullStrand.Master.finiteIIDNullStrand_master' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.NullStrand.Master.finiteIIDNullStrand_master

/-- info: 'PhysicsSM.NullStrand.Master.finiteIIDNullStrandModel_nonempty' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.NullStrand.Master.finiteIIDNullStrandModel_nonempty

/-! ## Concrete capstone 2: checkerboard Bohm–Bell master -/

/-- info: 'PhysicsSM.NullStrand.Master.checkerboardBohmBell_master' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.NullStrand.Master.checkerboardBohmBell_master

end PhysicsSM.NullStrand.Audit.CapstoneAxioms

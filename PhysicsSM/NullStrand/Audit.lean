import PhysicsSM.NullStrand.Audit.Inventory
import PhysicsSM.NullStrand.Audit.DraftFirewall
import PhysicsSM.NullStrand.Audit.CapstoneAxioms

/-!
# NullStrand.Audit

Aggregator for the lightweight G0/G1 audit guards:

- `PhysicsSM.NullStrand.Audit.Inventory` — `#check`s the trusted public surface
  (conventions, finite core, null-fiber resolutions and regulator no-go family,
  null-lift residual current, chiral currents, quantum walk). Turns a rename or
  deletion of any audited public declaration into a hard build failure.
- `PhysicsSM.NullStrand.Audit.DraftFirewall` — `#check`s the exact
  `PhysicsSM.Draft.*` surface the trusted NullStrand files depend on, and
  documents the four-core draft-import firewall policy.
- `PhysicsSM.NullStrand.Audit.CapstoneAxioms` — pins, via
  `#guard_msgs in #print axioms …`, the *kernel-level assumption surface* of the
  two concrete capstones (`finiteIIDNullStrand_master`,
  `checkerboardBohmBell_master`) and the i.i.d. non-vacuity witness. Build fails
  if a `sorry`, a `native_decide` trust hole, or a new `axiom` ever leaks into
  their transitive dependencies.

A fourth guard, `PhysicsSM.NullStrand.Audit.DuplicateNames`, is **not** imported
here on purpose: it imports the whole `PhysicsSM.NullStrand` root to enumerate
the trusted environment, so importing it from this aggregator (which the root
imports) would create an import cycle. Build it explicitly (see below).

These modules contain no new mathematics (only `#check`, `#print axioms`, and
environment introspection), so building them turns API drift, an assumption-surface
change, or a new base-name collision into a hard build failure at G0 instead of
silently downstream.

Build the import-time guards with:

```text
lake build PhysicsSM.NullStrand.Audit
```

and the environment-introspection collision gate with:

```text
lake build PhysicsSM.NullStrand.Audit.DuplicateNames
```

Two script-level companions police artifacts Lean cannot see:

```text
python3 Scripts/check_nullstrand_draft_firewall.py     # trusted/draft import graph
python3 Scripts/check_nullstrand_manifest.py           # manifest <-> source drift
```
-/

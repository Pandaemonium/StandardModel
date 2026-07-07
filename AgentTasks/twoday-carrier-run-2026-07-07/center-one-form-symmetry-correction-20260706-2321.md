# Aristotle correction prompt: center one-form strategy context fix

Metadata:
- Status: submitted 2026-07-06 23:21 -07:00
- Project: `f8cdf5c2-1990-446a-a072-49d2603b6738`
- Prior task: `987a9882-c129-4ef0-9b53-e1819d1a96ad`
- Correction task: `87f5a0e1-1b55-463c-9cbf-3fb92fbec504`

The prior center one-form strategy report made a decisive stale-check finding
that `PhysicsSM/Draft/NullEdge/GateYM/TYAreaLaw.lean` was absent. That was a
staging omission by Codex, not a repository fact.

Local verification in the real repository:

```text
Test-Path PhysicsSM/Draft/NullEdge/GateYM/TYAreaLaw.lean
=> True

lake env lean PhysicsSM/Draft/NullEdge/GateYM/TYAreaLawSUN.lean
=> passed

lake env lean PhysicsSM/Draft/NullEdge/GateYM/TYTwistSystemZ2.lean
=> passed

lake build
=> passed
```

I am uploading the missing dependency `TYAreaLaw.lean` plus the same relevant
GateYM files.

Please produce a corrected short Markdown report:

1. Explicitly retract the "missing TYAreaLaw/build blocker" finding as an
   artifact of the incomplete staged package.
2. Preserve or revise the substantive one-form center-symmetry strategy now
   that the TY files are known to compile locally.
3. Decide whether the ranked next jobs change. In particular, should the first
   proof target still be charged Wilson/Polyakov line transformation under
   center shifts, or should a finite `TwistSystem` constructor/tie-in move up?
4. Give exact Lean statement sketches for the top 2 recommended jobs.
5. Keep the same non-claim discipline: no continuum confinement, Ward identity,
   anomaly, spontaneous breaking, or `H^2(K,Z(G))` background claim unless that
   object is explicitly built.

Do not edit code. The desired output is a corrected strategy/audit report that
we can cite in the run ledger.

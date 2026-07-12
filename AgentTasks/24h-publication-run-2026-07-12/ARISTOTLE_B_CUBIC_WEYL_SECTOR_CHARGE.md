# Aristotle target: live cubic Weyl-sector charge

Complete the exact bridge from the repository's actual Clifford generators to
the two explicit Weyl bases and the landed Jacobian-sign charge API. Preserve
every theorem statement. The target must prove that `Xi=-i alpha1 alpha2 alpha3`
commutes with the spatial tangent and anticommutes with the mass matrix, that the
two restrictions are the Pauli triple and its negative, and that their exact
charges are opposite. Do not claim global chirality of the full walk or a zone
charge-sum theorem.

```yaml
aristotle:
  project_id: 343be2d9-f4d8-4c75-9bab-18405e6692c4
  task_id: 735a52dc-7dd3-4c39-aa7a-7b0687ef0406
  target_file: AgentTasks/aristotle-targets/codex_24h_b_cubic_weyl_sector_charge.lean
  expected_module: PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-cubic-weyl-sector-charge-20260711-project
  output_dir: AgentTasks/aristotle-output/343be2d9-f4d8-4c75-9bab-18405e6692c4
  status: landed
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Harvested with all 13 theorem statements unchanged and every proof hole closed.
Promoted as `PhysicsSM/Draft/NullEdge/CubicWeylSectorCharge.lean`. Direct Lean
PASS; targeted build PASS (8,028 jobs); aggregate axiom guard PASS (8,291 jobs),
with only the standard `propext`, `Classical.choice`, and `Quot.sound` footprint.
The result is a local tangent restriction and supplied-Jacobian charge
composition only; no global Bloch chirality or zone-sum claim was added.

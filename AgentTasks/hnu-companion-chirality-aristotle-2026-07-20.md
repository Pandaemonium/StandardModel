# Aristotle task: exact HNU companion block and chirality balance

Date: 2026-07-20
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated

## Objective

Complete every theorem in
`HNUCompanionChirality/HNUCompanionChirality.lean` without changing the
statements.  The central theorem is the all-momentum identity

```text
endpoint(k1,k2,k3-2*pi) = endpoint(k1,-k2,k3).
```

Compose it with the existing exact HNU tangent and crossing census to prove
that the selected lower two-band block has Jacobian determinant `+1`, while
the published shifted high block has determinant `-1`.  Also prove the exact
lower/high invariant-subspace equations for the block-diagonal four-band
endpoint.

## Scientific reading

This is the finite theorem that reconciles the two claims which must coexist:

1. the invariant lower two-band subspace carries one Weyl cone of one
   chirality;
2. the complete four-band drive remains locally chirality-balanced.

Do not infer a Brouwer degree, winding integral, bulk-edge correspondence, or
interacting anomaly theorem from this local ledger.  Conversely, do not weaken
the global reflection identity to a first-order or sampled statement.

## Provenance and oracle discipline

Primary source: S. Higashikawa, M. Nakagawa, and M. Ueda, "Floquet chiral
magnetic effect", Phys. Rev. Lett. 123, 066403 (2019), arXiv:1806.06868.
The source defines `V^wh(k) = U(k) direct-sum U^H(k)` and
`U^H(k)=U(k1,k2,k3-2*pi)`.

A numerical oracle identified the candidate exact identity and the two tangent
matrices.  The oracle is not evidence for any theorem; Lean must establish all
identities symbolically.

## Verification

Run first:

```text
lake env lean HNUCompanionChirality/HNUCompanionChirality.lean
```

Finish with a concise report listing solved targets, any statement changes
(expected: none), remaining proof holes, and the axiom footprint.

```yaml
aristotle:
  project_id: 8222da3c-0f20-40e9-9a7c-35744e4a26ae
  task_id: 18257cf8-c30d-4e54-82e8-276f2fe5d65e
  target_file: HNUCompanionChirality/HNUCompanionChirality.lean
  expected_module: HNUCompanionChirality.HNUCompanionChirality
  submission_project: AgentTasks/aristotle-submit/hnu-companion-chirality-20260720b-project
  output_dir: AgentTasks/aristotle-output/8222da3c-0f20-40e9-9a7c-35744e4a26ae
  status: integrated
```

The first upload (`84723af3-28be-40f7-a42a-6d47da5b13a1`, task
`33b6ece5-1dd8-4264-aff8-91b369fe27ac`) was cancelled before proof search
because the focused copy still contained three unintended auto-implicit Pauli
identifiers.  The replacement above uses the qualified live declarations.

## Integration result

The replacement job closed all nine targets and landed as
`PhysicsSM/Draft/NullEdge/HNUCompanionChirality.lean`.  The exact global
reflection identity implies an opposite high-block Weyl Jacobian, zero total
local chirality for the complete four-band endpoint, and exact invariant lower
and high subspaces.  This is the required complement audit for the selected
single-Weyl sector; it does not erase the selected block's nonzero endpoint
winding.

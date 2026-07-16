# Aristotle task: exact HNU selected sector with explicit pi complement

```yaml
aristotle:
  project_id: d82ea36b-490a-4e78-bc17-29e1aa3c96e9
  task_id: 29039417-befe-4736-be47-00af35e42c28
  target_file: HNUTransversePiComposite.lean
  expected_module: HNUTransversePiComposite
  submission_project: continued standalone FloquetTransverseComposite project
  output_dir: AgentTasks/aristotle-output/d82ea36b-490a-4e78-bc17-29e1aa3c96e9
  status: integrated
```

## Scientific target

Replace the free complement update `V` in the accepted controlled-sector
precursor by an explicit quasienergy-pi unitary while instantiating the selected
update with the exact HNU endpoint. Prove a true eigenvalue census rather than
projecting the complement away.

## Inputs

- `FloquetTransverseComposite/Core.lean` from the completed project;
- the uploaded Mathlib-only live source
  `PhysicsSM/Draft/NullEdge/HNUExactCore.lean`.

## Required theorem ladder

1. Define `Vpi = -1` on the two-component complement spin sector. Prove it is
   unitary, every vector is a `-1` eigenvector, and its only `+1` eigenvector is
   zero.
2. Define `hnuPiComposite k = controlled (HNUExactCore.endpoint k) Vpi` and
   prove full-operator unitarity.
3. Prove the selected transverse embedding carries the exact HNU endpoint and
   the orthogonal transverse complement carries exactly `Vpi`.
4. Prove a nonzero selected `+1` eigenvector at `k = 0` and nonzero complement
   `-1` witnesses.
5. Prove the hard `SU(2)` lemma needed for a no-copy census: if a unitary
   `2 x 2` matrix has determinant one and a nonzero fixed vector, then it is the
   identity. Use it with the existing HNU determinant and cube census.
6. On `[-pi,pi]^3`, prove that a nonzero selected vector can be a `+1`
   eigenvector of the composite only at `k = 0`. Prove separately that the
   explicit complement contributes no `+1` eigenvector at any momentum.
7. Add standard-three axiom guards and exact nonzero witnesses.

## Hard boundaries

This target is a finite momentum-space spectral composite. It does not prove
real-space locality of the complement update, primitive-null microscopic
support, an HNU winding number, bulk-edge correspondence, anomaly inflow, or a
physical domain wall. A constant `Vpi = -1` is an explicit pi-sector spectral
control, not yet an all-moving local compensator. State this prominently.

Do not weaken the census to matrix equality `endpoint k = 1`; the point of the
successor is to bridge from a nonzero `+1` eigenvector to that existing census.
Do not assume the desired no-copy conclusion. No proof placeholders, compiled
evaluation, or new assumptions in the returned target.

## 2026-07-13 harvest and integration

Interactive Claude/Opus approved the result with the required spectral-only
boundary. The live module is
`PhysicsSM/Draft/NullEdge/HNUTransversePiComposite.lean`; it reuses
`HNUSU2FixedVectorCensus` instead of duplicating the SU(2) rigidity lemma.
Direct replay and targeted Lake build pass, and the aggregate import and
central axiom guard include the headline theorems.

# Aristotle proof: canonical decoder for the local HNU selected sector

## Objective

Remove the arbitrary component-reading decoder from the integrated local HNU
architecture. Replace it by the normalized orthogonal coefficient along the
rank-one transverse profile `w`.

## Target

Fill every proof hole in
`PhysicsSM/Draft/NullEdge/HNUCanonicalDecoder.lean`.

The key identity is

```text
encode (canonicalDecode psi) = selected psi.
```

Derive it from the exact normalization `w dotProduct w = 5` and the existing
selector action. Then prove the left-inverse identity, invariance under onsite
selection, exact decoded HNU dynamics, and the nonzero control.

## Stretch target

Prove a uniqueness theorem: among fiberwise complex-linear decoders that are
orthogonal to the selector complement and are left inverses of `encode`, the
canonical decoder is unique. State linearity and fiberwise locality explicitly;
do not hide them in an unrestricted function hypothesis.

## Boundaries

This job canonicalizes the decoder relative to the supplied profile `w`. It
does not derive `w` from a symmetry, action, environment, or experiment. Use no
new assumptions or compiler-trusted decision procedures.

## Aristotle metadata

```yaml
aristotle:
  project_id: 70183b62-2e63-4e3a-a112-9ffab39017f2
  target_file: PhysicsSM/Draft/NullEdge/HNUCanonicalDecoder.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUCanonicalDecoder
  submission_project: AgentTasks/aristotle-submit/codex-hnu-canonical-decoder-uniqueness-20260719-project
  output_dir: AgentTasks/aristotle-output/70183b62-2e63-4e3a-a112-9ffab39017f2
  status: submitted
  owner: Codex
```

Submitted on 2026-07-19 after the five core decoder identities were proved and
checked locally; Aristotle is assigned the explicit locality/linearity
uniqueness extension.
